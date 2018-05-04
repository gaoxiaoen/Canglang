%% --------------------------------------------------------------------
%% 至尊王者的排行榜管理进程
%% @author shawn 
%% @end
%% --------------------------------------------------------------------
-module(cross_king_rank).
-export([
        start_link/0
        ,get_rank/2
        ,update_rank/1
        ,save_rank/0
        ,clean_rank/0
    ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-behaviour(gen_server).

-include("common.hrl").
-include("role.hrl").
-include("cross_king.hrl").

-record(state, {
        gfs_list = []
        ,ds_list = []
        ,tmp_gfs = []
        ,tmp_ds = []
    }).

%% 战区角色更新
update_rank(KingRoles) ->
    NewRoles = to_rank(KingRoles),
    gen_server:cast(?MODULE, {update_rank, NewRoles}).

%% @spec get_rank(Nth, Ntail) -> Ranks :: list()
get_rank(Type, Page) ->
    gen_server:call(?MODULE, {get_rank, Type, Page}).

clean_rank() ->
    gen_server:cast(?MODULE, clean_rank).

%% 存储最终排行榜
save_rank() ->
    gen_server:cast(?MODULE, save_rank).

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Pid = pid()
%% Error = string()
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @spec update_rank(Rank) -> any()
%% Rank = #cross_boss_rank{} | #cross_boss_combat{}
to_rank_role(#cross_king_role{id = {Rid, SrvId}, group = 1, name = Name, sex = Sex, lev = Lev, vip = Vip, fight_capacity = Fight1, pet_fight = Fight2, career = Career, kill = Kill, death = Death})  ->
    #cross_king_rank{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, group = 1, name = Name, sex = Sex, lev = Lev, vip = Vip, fight_capacity = Fight1, pet_fight = Fight2, career = Career, score = Kill, death = Death};
to_rank_role(#cross_king_role{id = {Rid, SrvId}, group = 0, name = Name, sex = Sex, lev = Lev, vip = Vip, fight_capacity = Fight1, pet_fight = Fight2, career = Career, dmg = Dmg, death = Death})  ->
    #cross_king_rank{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, group = 0, name = Name, sex = Sex, lev = Lev, vip = Vip, fight_capacity = Fight1, pet_fight = Fight2, career = Career, score = Dmg, death = Death}.

to_rank(KingRoles) ->
    to_rank(KingRoles, []).
to_rank([], NewK) -> NewK;
to_rank([R | T], NewK) ->
    NewR = to_rank_role(R),
    to_rank(T, [NewR | NewK]).

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% Func: init/1
%% Returns: {ok, StateName, StateData}          |
%%          {ok, StateName, StateData, Timeout} |
%%          ignore                              |
%%          {stop, StopReason}
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    {GfsList, DsList} = load_rank(),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{gfs_list = GfsList, ds_list = DsList}}.

%% 屌丝
handle_call({get_rank, 0, Page}, _From, State = #state{ds_list = DsList}) ->
    Reply = get_page(ds_list, DsList, Page),
    {reply, Reply, State};

%% 高富帅
handle_call({get_rank, 1, Page}, _From, State = #state{gfs_list = GfsList}) ->
    Reply = get_page(gfs_list, GfsList, Page),
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(clean_rank, State) ->
    {noreply, State#state{tmp_gfs = [], tmp_ds = []}};

handle_cast({update_rank, Rank}, State = #state{tmp_gfs = GfsList, tmp_ds = DsList}) ->
    Time = util:unixtime(),
    spawn(fun() -> save_role_log(Time, Rank) end),
    {Gfs, Ds} = lists:partition(fun(R) -> R#cross_king_rank.group =:= 1 end, Rank), 
    NewGfsList = keys_sort(1, GfsList ++ Gfs), 
    NewDsList = keys_sort(1, DsList ++ Ds), 
    RankGfs = lists:sublist(NewGfsList, 20),
    RankDs = lists:sublist(NewDsList, 100),
    {noreply, State#state{tmp_gfs = RankGfs, tmp_ds = RankDs}};

handle_cast(save_rank, State = #state{tmp_gfs = GfsList, tmp_ds = DsList}) ->
    do_clean_db_rank(),
    NewRankGfs = lists:map(fun get_looks/1, GfsList),
    NewGfs = keys_sort(1, NewRankGfs),
    save_rank(NewGfs, 1),
    save_rank(DsList, 1),
    spawn(fun() -> do_cast(NewGfs) end),
    {noreply, State#state{gfs_list = NewGfs, ds_list = DsList, tmp_gfs = [], tmp_ds = []}};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
do_cast(GfsList) ->
    Rank4List = get_rank_4(GfsList, 0, []), 
    c_mirror_group:cast(all, cross_king_api, broadcast, [Rank4List]).

get_rank_4([], _, RoleList) -> RoleList;
get_rank_4(_GfsList, 4, RoleList) -> RoleList;
get_rank_4([#cross_king_rank{id = {Rid, SrvId}, name = Name} | T], Num, RoleList) ->
    get_rank_4(T, Num + 1, [{Rid, SrvId, Name} | RoleList]).

get_page(Type, List, Page) when Page < 1 -> get_page(Type, List, 1);
get_page(ds_list, DsList, Page) ->
    AllPage = util:ceil(length(DsList) / 10),
    case AllPage < Page of
        true ->
            Get = get_list(DsList, (AllPage - 1) * 10 + 1, AllPage * 10),
            {AllPage, AllPage, Get};
        false ->
            Get = get_list(DsList, (Page - 1) * 10 + 1, Page * 10),
            {AllPage, Page, Get}
    end;
get_page(gfs_list, GfsList, Page) ->
    AllPage = util:ceil(length(GfsList) / 4),
    case AllPage < Page of
        true ->
            Get = get_list(GfsList, (AllPage - 1) * 4 + 1, AllPage * 4),
            {AllPage, AllPage, Get};
        false ->
            Get = get_list(GfsList, (Page - 1) * 4 + 1, Page * 4),
            {AllPage, Page, Get}
    end.

get_list(List, Head, Tail) when Head =< Tail -> get_list(List, Head, Tail, [], 1);
get_list(List, Head, Tail) -> get_list(List, Tail, Head).

get_list([], _, _, GetList, _Flag) -> lists:reverse(GetList);
get_list(_List, Head, Tail, GetList, _Flag) when Head =:= Tail + 1 -> lists:reverse(GetList);
get_list([R | T], Flag, Tail, GetList, Flag) ->
    get_list(T, Flag + 1, Tail, [R | GetList], Flag + 1);
get_list([_ | T], Head, Tail, GetList, Flag) ->
    get_list(T, Head, Tail, GetList, Flag + 1).


%% 按多键排序 后面优先 即第二个键优先于第一个键
keys_sort(N, TupleList) ->
    do_keys_sort(get_sort_key(N), TupleList).
do_keys_sort([],TupleList) ->
    lists:reverse(TupleList);
do_keys_sort([H|T], TupleList) ->
    NewTupleList = lists:keysort(H, TupleList),
    do_keys_sort(T,NewTupleList).

%% 获取排行榜排序key
get_sort_key(1) -> [#cross_king_rank.fight_capacity, #cross_king_rank.score];
get_sort_key(2) -> [#cross_king_rank.rank].

%% 远程获取用户外观(在线&离线)
get_looks(CR = #cross_king_rank{id = {Rid, SrvId}}) ->
    NewLooks = case c_mirror_group:call(node, SrvId, cross_king_api, get_looks, [{Rid, SrvId}]) of
        Looks when is_list(Looks) -> Looks;
        _ -> []
    end,
    CR#cross_king_rank{looks = NewLooks}.

%% 清除榜数据
do_clean_db_rank() ->
    Sql = <<"delete from sys_cross_king_rank">>,
    case db:execute(Sql) of
        {ok, _} -> true;
        _E ->
           ?ERR("删除sys_cross_king_rank记录失败: ~w"),
           false
    end.

load_rank() ->
    Sql = <<"select rid, srv_id, rank, role_group, name, sex, lev, vip, fight_capacity, pet_fight, career, score, looks from sys_cross_king_rank">>,
    AllRole = case db:get_all(Sql) of
        {ok, Rows} ->
            to_record(Rows);
        _Why ->
            []
    end,
    {Gfs, Ds} = lists:partition(fun(R) -> R#cross_king_rank.group =:= 1 end, AllRole), 
    {lists:reverse(keys_sort(2, Gfs)), lists:reverse(keys_sort(2, Ds))}. 

save_rank([], _Num) -> ok;
save_rank([#cross_king_rank{id = {Rid, SrvId}, group = Group, name = Name, sex = Sex, lev = Lev, vip = Vip, fight_capacity = Fight1, pet_fight = Fight2, career = Career, score = Score, looks = Looks} | T], Num) ->
    Looks2 = util:term_to_bitstring(Looks),
    Sql = <<"insert into sys_cross_king_rank (rid, srv_id, rank, role_group, name, sex, lev, vip, fight_capacity, pet_fight, career, score, looks) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [Rid, SrvId, Num, Group, Name, Sex, Lev, Vip, Fight1, Fight2, Career, Score, Looks2]) of
        {ok, _} ->
            save_rank(T, Num + 1);
        {error, _Why} ->
            ?ERR("保存至尊王者排行榜出错:~w", [_Why]),
            save_rank(T, Num)
    end.

save_role_log(_Time, []) -> ok;
save_role_log(Time, [#cross_king_rank{id = {Rid, SrvId}, group = Group, name = Name, lev = Lev, score = Score, death = Death} | T]) ->
    Sql = <<"insert into log_cross_king_role (rid, srv_id, role_group, name, lev, score, death, ctime) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s) ON DUPLICATE KEY UPDATE role_group = ~s, lev = ~s, score = ~s, death = ~s, ctime = ~s">>,
    case db:execute(Sql, [Rid, SrvId, Group, Name, Lev, Score, Death, Time, Group, Lev, Score, Death, Time]) of
        {ok, _} -> ok;
        _Other ->
            ?ELOG("至尊王者修改数据库失败,Rid:~w,Srvid:~s,Reason:~s",[Rid, SrvId, _Other]),
            false
    end,
    save_role_log(Time, T).

to_record(Rows) ->
    to_record(Rows, []).
to_record([], Rank) -> Rank;
to_record([[Rid, SrvId, Num, Group, Name, Sex, Lev, Vip, Fight1, Fight2, Career, Score, Looks] | T], Rank) ->
    Looks2 = case util:bitstring_to_term(Looks) of
        {ok, Looks1} -> 
            case Looks1 of
                [_|_] -> Looks1;
                _ -> []
            end;
        {error, _Why1} -> 
            ?ERR("加载跨服至尊王者外观出错:~w", [_Why1]),
            []
    end,
    R = #cross_king_rank{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, rank = Num,  group = Group, name = Name, sex = Sex, lev = Lev, vip = Vip, fight_capacity = Fight1, pet_fight = Fight2, career = Career, score = Score, looks = Looks2}, 
    to_record(T, [R | Rank]).
