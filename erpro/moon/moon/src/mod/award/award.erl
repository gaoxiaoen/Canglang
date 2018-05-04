%%----------------------------------------------------
%% 奖励系统 
%%
%% @author qingxuan
%%----------------------------------------------------
-module(award).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([start_link/0]).
-export([
    send/2
    ,send/3
    ,send/5
    ,fetch/2
    ,notice/2
    ,load/1
    ,login/1
    ,ver_parse/1
    ,pack/1
    ,add_new/1
    ,get_new/0
    ,clear_new/0
    ,clear_new/1
    ,add_del/1
    ,get_del/0
    ,clear_del/0
    ,count_visible/1
]).

-include("common.hrl").
-include("gain.hrl").
-include("role.hrl").
-include("link.hrl").
-include("award.hrl").

-record(state, {next_id = 1}).

%% -> {ok, Role} | {error, Gain} | {error, Reason}
fetch(Role = #role{award = AwardList}, AwardId) ->
    case lists:keyfind(AwardId, #award.id, AwardList) of
        #award{id=AwardId, gains=Gains} ->
            Ret = case role_gain:do(Gains, Role) of
                {ok, _Role} -> {ok, _Role};
                {ok, _Role, _} -> {ok, _Role};
                {false, _Gains} -> {error, _Gains}
            end,
            case Ret of
                {ok, NewRole} ->
                    case db:execute("UPDATE `role_award` SET `fetched`=1 WHERE `id`=~s", [AwardId]) of
                        {ok, Affected} when is_integer(Affected) andalso Affected > 0 ->
                            NewAwardList = lists:keydelete(AwardId, #award.id, AwardList),
                            NewRole2 = NewRole#role{award = NewAwardList},
                            %check_unfetched(NewRole2, force),
                            clear_new(AwardId),
                            {ok, NewRole2};
                        _ ->
                            {error, db_exec}
                    end;
                _ ->
                    Ret
            end;
        _ ->
            {error, not_exists}
    end.

%% -> ok | {error, Reason}
send({RoleId, SrvId}, AwardBaseId) ->
    send({RoleId, SrvId}, AwardBaseId, null, <<"">>, []).

send({RoleId, SrvId}, AwardBaseId, Title) when is_integer(AwardBaseId), is_binary(Title) ->
    send({RoleId, SrvId}, AwardBaseId, Title, <<"">>, []);
send({RoleId, SrvId}, AwardBaseId, Gains) when is_integer(AwardBaseId), is_list(Gains) ->
    send({RoleId, SrvId}, AwardBaseId, null, <<"">>, Gains);
%% 取消以下的发奖励方式，所以奖励都必须在表中配置
% send({RoleId, SrvId}, Gains = [_|_], Title) when is_list(Gains), is_binary(Title) ->
%     ?MODULE ! {send, {RoleId, SrvId}, 0, Title, <<"">>, Gains, ?false},
%     ok;  

send({_RoleId, _SrvId}, _Gains = [], _Title) ->
    ok.

send({RoleId, SrvId}, AwardBaseId, Title, Content, Gains) ->
    case award_data:get(AwardBaseId) of
        undefined ->
            {error, undefined};
        #base_award{gains = Gains = []} ->
            {error, no_items};
        #base_award{gains = BaseGains, title = BaseTitle, hidden = Hidden} ->
            Title0 = case Title of
                null -> BaseTitle;
                _ -> Title
            end,
            Gains0 = case Gains of
                [] -> BaseGains;
                _ -> Gains
            end,
            ?MODULE ! {send, {RoleId, SrvId}, AwardBaseId, Title0, Content, Gains0, Hidden},
            ok
    end.

check_unfetched(#role{award = []}) ->
    ok;
check_unfetched(#role{link=#link{conn_pid=ConnPid}, award = AwardList}) ->
    AwardList0 = [ Award || Award = #award{hidden = Hidden} <- AwardList, Hidden =:= ?false ], %% 过滤掉隐藏的
    case AwardList0 of
        [] -> ok;
        _ -> sys_conn:pack_send(ConnPid, 14004, {length(AwardList0)})
    end.

%check_unfetched(#role{link=#link{conn_pid=ConnPid}, award = AwardList}, force) ->
%    sys_conn:pack_send(ConnPid, 14004, {length(AwardList)}),
%    ok.


notice(Role = #role{award = AwardList}, Award) ->
    NewAwardList = lists:ukeysort(#award.id, [Award|AwardList]),
    add_new(Award),
    NewRole = clear_old(Role#role{award = NewAwardList}, Award#award.base_id),
    %% 通知客户端
    check_unfetched(NewRole),
    {ok, NewRole}.

load(Role = #role{id = {RoleId, SrvId}}) ->
    case db:get_all("SELECT id, base_id, title, content, gains, hidden FROM role_award WHERE role_id=~s AND srv_id=~s AND fetched=0", [RoleId, SrvId]) of
        {ok, L} ->
            AwardList = lists:foldr(fun([AwardId, AwardBaseId, Title, Content, Gains, Hidden], Ret) ->
                    case award_data:get(AwardBaseId) of %% 只加载表里面有的奖励
                        undefined ->
                            Ret;
                        #base_award{} ->
                            case util:bitstring_to_term(Gains) of
                                {ok, GainsTerm} ->
                                    [#award{
                                        id = AwardId, 
                                        base_id = AwardBaseId, 
                                        title = Title, 
                                        content = Content,
                                        gains = GainsTerm,
                                        hidden = Hidden
                                    }|Ret];
                                {error, Reason} ->
                                    ?ERR("parse gains error: ~p", [Reason]),
                                    Ret
                            end
                    end
            end, [], L),
            NewRole = clear_old(Role#role{award = AwardList}),
            %set_new(AwardList),
            check_unfetched(NewRole),
            NewRole;
        {error, _Reason} ->
            Role
    end.

login(Role) ->
    load(Role).

ver_parse(Award) ->
    %case is_record(Award, award) of
    %false -> {false, ?L(<<"奖励数据转换失败">>)};
    %    true -> {ok, Award}
    %end.
    {ok, Award}.

%type_to_int(gold) -> 1;
%type_to_int(coin) -> 2.

clear_old(Role=#role{award = AwardList}, AwardBaseId) ->
    case award_data:get(AwardBaseId) of
        #base_award{limit = Limit} ->
            {SameBaseL, DiffBaseL} = lists:partition(fun(Award)-> Award#award.base_id == AwardBaseId end, AwardList),
            SameBaseLLen = length(SameBaseL),
            case SameBaseLLen > Limit of
                true ->
                    %SortedSameBaseL = lists2:rsort(SameBaseL),
                    %{NewSameBaseL, DelL} = lists:split(Limit, SortedSameBaseL),
                    SortedSameBaseL = lists:sort(SameBaseL),
                    {DelL, NewSameBaseL} = lists:split(SameBaseLLen - Limit, SortedSameBaseL),
                    lists:foreach(fun(Award = #award{id = AwardId})->
                        db:send(?DB_SYS, "UPDATE `role_award` SET `fetched`=2 WHERE `id`=~s", [AwardId]),
                        %% 不需要太严格的删除操作也可以，即使该操作失败，也不会造成大的损失
                        clear_new(Award),
                        add_del(AwardId)
                    end, DelL),
                    Role#role{award = NewSameBaseL ++ DiffBaseL};
                _ ->
                    Role
            end;
        _ ->    
            Role
    end.

clear_old(Role=#role{award = AwardList}) ->
    lists:foldl(fun({AwardBaseId, SameBaseL}, R)->
            ?DUMP({AwardBaseId, SameBaseL}),
            case award_data:get(AwardBaseId) of
                undefined -> R;
                #base_award{limit = Limit} ->
                    SameBaseLLen = length(SameBaseL),
                    case SameBaseLLen > Limit of
                        true ->
                            {DelL, _SaveL} = lists:split(SameBaseLLen - Limit, lists:sort(SameBaseL)),
                            lists:foreach(fun(Award = #award{id = AwardId})-> 
                                db:send(?DB_SYS, "UPDATE `role_award` SET `fetched`=2 WHERE `id`=~s", [AwardId]),
                                %% 不需要太严格的删除操作也可以，即使该操作失败，也不会造成大的损失
                                clear_new(Award),
                                add_del(AwardId)
                            end, DelL),
                            R#role{award = AwardList -- DelL};
                        false ->
                            R
                    end
            end
    end, Role, proplists2:group(AwardList, #award.base_id)).
    

pack(AwardList) ->
    lists:foldr(fun(#award{gains=Gains, base_id=AwardBaseId, id=AwardId, title=Title, hidden = ?false}, Ret) ->
            GainList = lists:map(fun(Gain)->
                case Gain#gain.label of
                    item -> %% 道具 
                        [ItemBaseId, _Bind, Num] = Gain#gain.val,
                        [ItemBaseId, Num];
                    exp -> %% 经验
                        [1, Gain#gain.val];
                    coin -> %% 金币(飞仙的铜钱) 
                        [2, Gain#gain.val];
                    gold ->  %% 晶钻
                        [3, Gain#gain.val];
                    gold_bind ->  %% 绑定晶钻
                        [4, Gain#gain.val];
                    scale ->  %% 龙鳞
                        [5, Gain#gain.val];
                    stone ->  %% 符石
                        [6, Gain#gain.val];
                    honor ->  %% 竞技荣誉
                        [7, Gain#gain.val];
                    badge -> %% 竞技纹章
                        [8, Gain#gain.val];
                    _ ->
                        [0, 0]
                end
            end, Gains),
            [[AwardId, AwardBaseId, Title, GainList]|Ret];
        (_, Ret) -> %% 过滤掉隐藏的
            Ret
    end, [], AwardList).

%set_new(List) ->
%    put(award_new, List).

%% -> any()
add_new(Award) ->
    case get(award_new) of
        undefined -> put(award_new, [Award]);
        L -> put(award_new, L++[Award])
    end.

%% -> list()
get_new() ->
    case get(award_new) of
        undefined -> [];
        L -> L
    end.

%% -> any()
clear_new() ->
    erase(award_new).  

%% -> any()
clear_new(AwardId) ->
    case get(award_new) of
        undefined -> ignore;
        L -> put(award_new, lists:keydelete(AwardId, #award.id, L))
    end.

%% -> any()
add_del(AwardId) ->
    case get(award_del) of
        undefined -> put(award_del, [AwardId]);
        L -> put(award_del, L++[AwardId])
    end.

%% -> list()
get_del() ->
    case get(award_del) of
        undefined -> [];
        L -> L
    end.

%% -> any()
clear_del() ->
    erase(award_del).  

count_visible(AwardList) ->
    length([ 1 || #award{hidden = Hidden} <- AwardList, Hidden =:= ?false]).

%% --------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% -----------------------------------------------------
%% 内部处理
%% -----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    case db:get_one(?DB_SYS, "SELECT IFNULL(max(id), 1) FROM `role_award`") of
        {ok, NextId} -> 
            {ok, #state{next_id = NextId + 1}};
        {error, undefined} -> 
            {ok, #state{next_id = 1}};
        Error ->
            {stop, Error}
    end.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Data, State) ->
    {noreply, State}.

handle_info({send, {RoleId, SrvId}, AwardBaseId, Title, Content, Gains, Hidden}, State) ->
    AwardId = State#state.next_id,
    case db:execute(?DB_SYS, "INSERT INTO `role_award` (`id`, `base_id`, `role_id`, `srv_id`, `fetched`, `ctime`, `title`, `content`, `gains`, `hidden`) VALUES (~s, ~s, ~s, ~s, 0, ~s, ~s, ~s, ~s, ~s)", [AwardId, AwardBaseId, RoleId, SrvId, util:unixtime(), Title, Content, util:term_to_bitstring(Gains), Hidden]) of
        {ok, _} ->
            case role_api:get_pid({RoleId, SrvId}) of
                undefined -> ignore;
                Pid -> role:apply(async, Pid, {fun notice/2, [#award{id=AwardId, base_id=AwardBaseId, title=Title, gains=Gains, hidden = Hidden}]})
            end;
        {error, _Reason} ->
            ?DEBUG("~p", [_Reason]);
        _ ->
            ignore
    end,
    {noreply, State#state{next_id = AwardId + 1}};

%% 容错
handle_info(_Data, State) ->
    ?ELOG("错误的异步消息处理：DATA:~p, State:~p", [_Data, State]),
    {noreply, State}.

terminate(_Reason, _State) ->
    {noreply, _State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

