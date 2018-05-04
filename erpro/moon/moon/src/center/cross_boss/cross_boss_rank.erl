%% --------------------------------------------------------------------
%% 跨服boss的排行榜管理进程
%% @author wpf wprehard@qq.com
%% @end
%% --------------------------------------------------------------------
-module(cross_boss_rank).
-export([
        start_link/0
        ,get_rank/0
        ,get_rank/2
        ,get_champion/0
        ,update_rank/1
        ,update_champion/0
        ,save_rank/0
        ,gm_clean_rank/0
    ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-behaviour(gen_server).

-include("common.hrl").
-include("boss.hrl").
-include("role.hrl").

-record(state, {
        ranks = [] %% 排行榜
        ,champion  %% 冠军队伍
    }).

%% @spec update_rank(Rank) -> any()
%% Rank = #cross_boss_rank{} | #cross_boss_combat{}
update_rank(#cross_boss_combat{roles = Roles, boss_id = BossId, round = Round})  ->
    update_rank(#cross_boss_rank{roles = Roles, boss_id = BossId, round = Round});
update_rank(Rank) ->
    gen_server:cast(?MODULE, {update_rank, Rank}).

%% @spec update_champion() -> any()
%% Rank = #cross_boss_rank{} | #cross_boss_combat{}
update_champion()  ->
    gen_server:cast(?MODULE, update_champion).

%% @spec get_rank() -> Ranks :: list()
get_rank() ->
    gen_server:call(?MODULE, get_rank).

%% @spec get_rank(Nth, Ntail) -> Ranks :: list()
get_rank(Nth, Ntail) ->
    gen_server:call(?MODULE, {get_rank, Nth, Ntail}).

%% @spec get_champion() -> Champion :: tuple() | false
get_champion() ->
    gen_server:call(?MODULE, get_champion).

%% @spec save_rank() -> any()
save_rank() ->
    Ranks = get_rank(),
    Champion = get_champion(),
    save_rank(Ranks, Champion).

%% @doc 清除排行榜
gm_clean_rank() ->
    gen_server:cast(?MODULE, clean_rank).

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Pid = pid()
%% Error = string()
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

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
    {Champion, Ranks} = load_rank(),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{champion = Champion, ranks = Ranks}}.

handle_call(get_rank, _From, State = #state{ranks = Ranks}) ->
    {reply, Ranks, State};

handle_call({get_rank, Nth, Ntail}, _From, State = #state{ranks = Ranks}) ->
    PageRanks = do_page(Nth, Ntail, Ranks),
    {reply, PageRanks, State};

handle_call(get_champion, _From, State = #state{champion = Champion}) ->
    {reply, Champion, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({update_rank, Rank}, State = #state{ranks = Ranks}) ->
    NewRanks = sort_rank([Rank | Ranks]),
    {noreply, State#state{ranks = NewRanks}};

handle_cast(update_champion, State = #state{ranks = []}) ->
    {noreply, State};
handle_cast(update_champion, State = #state{ranks = Ranks = [Champion | _]}) ->
    NewChampion = case Champion of
        #cross_boss_rank{roles = Roles} ->
            Champion#cross_boss_rank{roles = lists:map(fun get_looks/1, Roles)};
        _ -> false
    end,
    save_rank(Ranks, Champion), %% 保存一次
    {noreply, State#state{champion = NewChampion}};

handle_cast(clean_rank, _State) ->
    {noreply, #state{champion = false, ranks = []}};

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

%% 导入排行榜
load_rank() ->
    Sql = "select ctime, champion, ranks from sys_cross_boss_rank where id = ~s",
    case db:get_row(Sql, [?CROSS_BOSS_RANK_TYPE_1]) of
        {ok, [_Ctime, Champion, Ranks]} ->
            {to_term(Champion, false), to_term(Ranks, [])};
        _ ->
            {false, []}
    end.

%% 保存排行榜
save_rank(Ranks, Champion) ->
    V1 = util:term_to_bitstring(Ranks),
    V2 = util:term_to_bitstring(Champion),
    Sql = "replace into sys_cross_boss_rank(id, ctime, champion, ranks) values(~s, ~s, ~s, ~s)",
    case db:execute(Sql, [?CROSS_BOSS_RANK_TYPE_1, util:unixtime(), V2, V1]) of
        {error, _Why} ->
            ?ERR("保存跨服boss排行榜出错:~w", [_Why]),
            ignore;
        {ok, _} -> ok
    end.

%% 将数据库存储的数据转换为term
to_term(Data, Def) ->
    case util:bitstring_to_term(Data) of
        {ok, R} ->
            R;
        _ ->
            Def
    end.

%% 排序
sort_rank([]) -> [];
sort_rank(Ranks) ->
    Ranks1 = lists:keysort(#cross_boss_rank.round, Ranks), %% (由小到大)
    Ranks3 = [_ | Ranks2] = lists:keysort(#cross_boss_rank.boss_id, lists:reverse(Ranks1)),
    case length(Ranks3) > ?DEF_RANK_COUNT of
        true ->
            lists:reverse(Ranks2);
        false ->
            lists:reverse(Ranks3)
    end.

%% 远程获取用户外观(在线&离线)
get_looks(CR = #cross_boss_role{id = {Rid, SrvId}}) ->
    NewLooks = case c_mirror_group:call(node, SrvId, cross_boss, get_looks, [{Rid, SrvId}]) of
        Looks when is_list(Looks) -> Looks;
        _ -> []
    end,
    CR#cross_boss_role{looks = NewLooks}.

%% 分页
do_page(Nth, Ntail, _L) when Nth > Ntail -> [];
do_page(Nth, Ntail, L) ->
    Length = length(L),
    case Nth > Length of
        true -> [];
        false ->
            case Length < Ntail of
                true -> %% 取最后一页
                    do_page(Nth, Length, L, []);
                false ->
                    do_page(Nth, Ntail, L, [])
            end
    end.
do_page(Nth, Nth, L, BackL) ->
    [lists:nth(Nth, L) | BackL];
do_page(Nth, Ntail, L, BackL) ->
    do_page(Nth, Ntail -1, L, [lists:nth(Ntail, L) | BackL]).
