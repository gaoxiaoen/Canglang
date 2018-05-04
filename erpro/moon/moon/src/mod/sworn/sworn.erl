%% *******************************
%% 结拜系统进程
%% @author lishen(105326073@qq.com)
%% *******************************
-module(sworn).
-behaviour(gen_fsm).
-export([
        check_propose_sworn/1
        ,start_sworn/3
        ,start_sworn/4
        ,do_handle_role_scene/2
        ,handle_scene/2
        ,role_disconnect/1
        ,role_online/3
        ,start_fight/3
        ,start_fight/4
        ,combat_over/0
        ,send_mail/2
        ,gm_del_title/2
        ,gm_del_sworn/1
        ,set_title/4
        ,edit_title/4
        ,handle_sworn_login/2
        ,handle_divorce_login/2
        ,check_propose_title/2
        ,check_propose_add/2
        ,add_member/2
        ,check_propose_del/1
        ,do_del_member/3
        ,del_member/2
        ,use_jinlanpu/2
        ,change_sex_title/1
    ]).
-export([
        idel/2
        ,fight/2
        ,prepare/2
        ,ceremony/2
    ]).
-export([start_link/0, init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

%%
-include("sworn.hrl").
-include("common.hrl").
-include("team.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("sns.hrl").
-include("link.hrl").
-include("chat_rpc.hrl").
-include("map.hrl").
-include("item.hrl").
-include("gain.hrl").

%% -------------------------------------------
%% GM 命令
%% -------------------------------------------
%% @spec gm_del_title(Role) -> NewRole.
%% @doc 删除结拜称号
gm_del_title(Role, Type) ->
    TitleID = case Type =:= ?SWORN_LOD of
        true -> ?SWORN_CUSTOM_TITLE_ID;
        false -> ?SWORN_COMMON_TITLE_ID
    end,
    case achievement:del_honor(Role, TitleID) of
        {ok, NewRole} ->
            map:role_update(NewRole),
            NewRole;
        _ -> Role
    end.

gm_del_sworn(Role = #role{id = Id}) ->
    case ets:lookup(ets_role_sworn, Id) of
        [] -> {false, ?L(<<"您确定您已经结拜过了吗？">>)};
        [SwornInfo] ->
            case sworn:del_member(Role, SwornInfo) of
                {false, Reason} ->
                    {false, Reason};
                {ok, NewRole} ->
                    {ok, NewRole}
            end
    end.

%% -------------------------------------------
%% 对外接口
%% -------------------------------------------
%% @spec start_fight(Type, Role1, Role2) -> ok | {false, Reason}
%% @doc 生死结拜前战斗
%% 2人结拜
start_fight(Type, Role1, Role2) ->
    State = convert(Type, Role1, Role2),
    case gen_fsm:sync_send_all_state_event(?MODULE, {fight, Role1, State}) of
        {false, Reason} -> {false, Reason};
        ok -> ok
    end.

%% @spec start_fight(Type, Role1, Role2) -> ok | {false, Reason}
%% 3人结拜
start_fight(Type, Role1, Role2, Role3) ->
    State = convert(Type, Role1, Role2, Role3),
    case gen_fsm:sync_send_all_state_event(?MODULE, {fight, Role1, State}) of
        {false, Reason} -> {false, Reason};
        ok -> ok
    end.

%% 战斗结束回调
combat_over() ->
    gen_fsm:sync_send_all_state_event(?MODULE, {prepare}).

%% @spec start_sworn(Type, Role1, Role2) -> ok | {false, Reason}
%% @doc 开始结拜
%% 2人结拜
start_sworn(Type, Role1, Role2) ->
    State = convert(Type, Role1, Role2),
    case gen_fsm:sync_send_all_state_event(?MODULE, {prepare, State}) of
        {false, Reason} -> {false, Reason};
        ok ->
            team:stop(Role1, sworn),
            ok
    end.

%% @spec start_sworn(Type, Role1, Role2, Role3) -> ok | {false, Reason}
%% 3人结拜
start_sworn(Type, Role1, Role2, Role3) ->
    State = convert(Type, Role1, Role2, Role3),
    case gen_fsm:sync_send_all_state_event(?MODULE, {prepare, State}) of
        {false, Reason} -> {false, Reason};
        ok ->
            team:stop(Role1, sworn),
            ok
    end.

%% @spec set_title(Head, Tail, Role, SwornInfo) -> {ok, NewRole} | {false, Reason}
%% @doc 设置结拜称号(生死结拜)
set_title(Head, Tail, Role, SwornInfo = #sworn_info{num = 2, member = [#sworn_member{id = Id1}], type = ?SWORN_LOD}) ->
    set_title_other(Head, Tail, Id1),
    NewSwornInfo = SwornInfo#sworn_info{title_h = Head, title_t = Tail},
    case handle_leader_sworn(Role, NewSwornInfo) of
        {false, Reason} ->
            {false, Reason};
        {ok, NewRole} ->
            {ok, NewRole}
    end;
set_title(Head, Tail, Role, SwornInfo = #sworn_info{num = 3, member = [#sworn_member{id = Id1}, #sworn_member{id = Id2}], type = ?SWORN_LOD}) ->
    set_title_other(Head, Tail, Id1),
    set_title_other(Head, Tail, Id2),
    NewSwornInfo = SwornInfo#sworn_info{title_h = Head, title_t = Tail},
    case handle_leader_sworn(Role, NewSwornInfo) of
        {false, Reason} ->
            {false, Reason};
        {ok, NewRole} ->
            {ok, NewRole}
    end;
set_title(_, _, _, _) ->
    {false, <<>>}.

update_sworn_rank(SwornInfo = #sworn_info{num = 2, id = Id, member = [Member1 = #sworn_member{id = Id1}]}, [{Id, Rank}, {Id1, Rank1}]) ->
    SwornInfo#sworn_info{rank = Rank, member = [Member1#sworn_member{rank = Rank1}]};
update_sworn_rank(SwornInfo = #sworn_info{num = 2, id = Id, member = [Member1 = #sworn_member{id = Id1}]}, [{Id1, Rank1}, {Id, Rank}]) ->
    SwornInfo#sworn_info{rank = Rank, member = [Member1#sworn_member{rank = Rank1}]};
update_sworn_rank(SwornInfo = #sworn_info{num = 3, id = Id, member = [Member1 = #sworn_member{id = Id1}, Member2 = #sworn_member{id = Id2}]}, 
    [{Id, Rank}, {Id1, Rank1}, {Id2, Rank2}]) ->
    SwornInfo#sworn_info{rank = Rank, member = [Member1#sworn_member{rank = Rank1}, Member2#sworn_member{rank = Rank2}]};
update_sworn_rank(SwornInfo = #sworn_info{num = 3, id = Id, member = [Member1 = #sworn_member{id = Id1}, Member2 = #sworn_member{id = Id2}]}, 
    [{Id, Rank}, {Id2, Rank2}, {Id1, Rank1}]) ->
    SwornInfo#sworn_info{rank = Rank, member = [Member1#sworn_member{rank = Rank1}, Member2#sworn_member{rank = Rank2}]};
update_sworn_rank(SwornInfo = #sworn_info{num = 3, id = Id, member = [Member1 = #sworn_member{id = Id1}, Member2 = #sworn_member{id = Id2}]},
    [{Id1, Rank1}, {Id, Rank}, {Id2, Rank2}]) ->
    SwornInfo#sworn_info{rank = Rank, member = [Member1#sworn_member{rank = Rank1}, Member2#sworn_member{rank = Rank2}]};
update_sworn_rank(SwornInfo = #sworn_info{num = 3, id = Id, member = [Member1 = #sworn_member{id = Id1}, Member2 = #sworn_member{id = Id2}]},
    [{Id1, Rank1}, {Id2, Rank2}, {Id, Rank}]) ->
    SwornInfo#sworn_info{rank = Rank, member = [Member1#sworn_member{rank = Rank1}, Member2#sworn_member{rank = Rank2}]};
update_sworn_rank(SwornInfo = #sworn_info{num = 3, id = Id, member = [Member1 = #sworn_member{id = Id1}, Member2 = #sworn_member{id = Id2}]},
    [{Id2, Rank2}, {Id, Rank}, {Id1, Rank1}]) ->
    SwornInfo#sworn_info{rank = Rank, member = [Member1#sworn_member{rank = Rank1}, Member2#sworn_member{rank = Rank2}]};
update_sworn_rank(SwornInfo = #sworn_info{num = 3, id = Id, member = [Member1 = #sworn_member{id = Id1}, Member2 = #sworn_member{id = Id2}]},
    [{Id2, Rank2}, {Id1, Rank1}, {Id, Rank}]) ->
    SwornInfo#sworn_info{rank = Rank, member = [Member1#sworn_member{rank = Rank1}, Member2#sworn_member{rank = Rank2}]}.

%% @spec edit_title(Head, Tail, Role, SwornInfo) -> {ok, NewRole} | {false, Reason}
%% @doc 修改称号
edit_title(Head, Tail, Role = #role{id = Id, lev = Lev}, SwornInfo = #sworn_info{num = 2, member = [#sworn_member{id = Id1}]}) ->
    case role_api:lookup(by_id, Id1) of
        {ok, _, #role{lev = Lev1, pid = Pid1}} ->
            LevList = [Lev, Lev1],
            Rank = rank_list(LevList, rank(LevList), []),
            R = lists:nth(1, Rank),
            R1 = lists:nth(2, Rank),
            case ets:lookup(ets_role_sworn, Id1) of
                [] ->
                    {false, ?L(<<"修改结义称号需要所有结义成员组队申请。">>)};
                [SwornInfo1] ->
                    role:apply(async, Pid1, {fun do_edit_title/2, [update_sworn_rank(SwornInfo1#sworn_info{title_h = Head, title_t = Tail}, [{Id, R}, {Id1, R1}])]}),
                    case do_leader_edit_title(Role, update_sworn_rank(SwornInfo#sworn_info{title_h = Head, title_t = Tail}, [{Id, R}, {Id1, R1}])) of
                        {false, Reason} ->
                            {false, Reason};
                        {ok, NewRole} ->
                            {ok, NewRole}
                    end
            end;
        _ ->
            {false, ?L(<<"有结拜成员不在队伍中">>)}
    end;
edit_title(Head, Tail, Role = #role{id = Id, lev = Lev}, SwornInfo = #sworn_info{num = 3, member = [#sworn_member{id = Id1}, #sworn_member{id = Id2}]}) ->
    case {role_api:lookup(by_id, Id1), role_api:lookup(by_id, Id2)} of
        {{ok, _, #role{lev = Lev1, pid = Pid1}}, {ok, _, #role{lev = Lev2, pid = Pid2}}} ->
            LevList = [Lev, Lev1, Lev2],
            Rank = rank_list(LevList, rank(LevList), []),
            R = lists:nth(1, Rank),
            R1 = lists:nth(2, Rank),
            R2 = lists:nth(3, Rank),
            case {ets:lookup(ets_role_sworn, Id1), ets:lookup(ets_role_sworn, Id2)} of
                {[SwornInfo1], [SwornInfo2]} ->
                    role:apply(async, Pid1, {fun do_edit_title/2, [update_sworn_rank(SwornInfo1#sworn_info{title_h = Head, title_t = Tail}, [{Id, R}, {Id1, R1}, {Id2, R2}])]}),
                    role:apply(async, Pid2, {fun do_edit_title/2, [update_sworn_rank(SwornInfo2#sworn_info{title_h = Head, title_t = Tail}, [{Id, R}, {Id1, R1}, {Id2, R2}])]}),
                    case do_leader_edit_title(Role, update_sworn_rank(SwornInfo#sworn_info{title_h = Head, title_t = Tail}, [{Id, R}, {Id1, R1}, {Id2, R2}])) of
                        {false, Reason} ->
                            {false, Reason};
                        {ok, NewRole} ->
                            {ok, NewRole}
                    end;
                _ ->
                    {false, ?L(<<"修改结义称号需要所有结义成员组队申请。">>)}
            end;
        _ ->
            {false, ?L(<<"有结拜成员不在队伍中">>)}
    end.

%% @spec check_propose(Role) -> {ok, Role1} | {ok, Role1, Role2} | {false, Reason}
%% @doc 检查玩家是否符合结拜条件
check_propose_sworn(Role = #role{id = Id}) ->
    case check_propose(already_sworn, Id) of
        {false, Reason} -> {false, Reason};
        ok ->
            case check_propose_common(Role) of
                {ok, Role1 = #role{id = Id1}} ->
                    case check_propose(already_sworn, Id1) of
                        ok -> {ok, Role1};
                        {false, Reason} -> {false, Reason}
                    end;
                {ok, Role1 = #role{id = Id1}, Role2 = #role{id = Id2}} ->
                    case check_propose(already_sworn, Id1, Id2) of
                        ok -> {ok, Role1, Role2};
                        {false, Reason} -> {false, Reason}
                    end;
                {false, Reason} -> {false, Reason}
            end
    end.

%% @spec check_propose_title(Role, SwornInfo) -> {ok, Num} | {false, Reason}
%% @doc 检查是否符合修改自定义称号条件
check_propose_title(Role, #sworn_info{num = 2, member = [#sworn_member{id = Id1}]}) ->
    case check_propose(team, Role) of
        {ok, #team_member{id = Id1}} ->
            {ok, 2};
        {ok, #team_member{id = Id1}, _Member} ->
            {ok, 2};
        {ok, _Member, #team_member{id = Id1}} ->
            {ok, 2};
        _ ->
            {false, ?L(<<"修改结义称号需要所有结义成员组队申请。">>)}
    end;
check_propose_title(Role, #sworn_info{num = 3, member = [#sworn_member{id = Id1}, #sworn_member{id = Id2}]}) ->
    case check_propose(team, Role) of
        {ok, #team_member{id = Id1}, #team_member{id = Id2}} ->
            {ok, 3};
        {ok, #team_member{id = Id2}, #team_member{id = Id1}} ->
            {ok, 3};
        _ ->
            {false, ?L(<<"修改结义称号需要所有结义成员组队申请。">>)}
    end.

%% @spec check_propose_add(Role, SwornInfo) -> {ok, NewRole} | {false, Reason}
%% @doc 检查添加新成员条件
check_propose_add(Role, #sworn_info{num = 2, member = [#sworn_member{id = Id1}]}) ->
    case check_propose_common(Role) of
        {false, Reason} ->
            {false, Reason};
        {ok, #role{id = Id1}, #role{id = InId, name = NewName}} ->
            case check_propose(already_sworn, InId) of
                ok -> {ok, NewName};
                {false, Reason} -> {false, Reason}
            end;
        {ok, #role{id = InId, name = NewName}, #role{id = Id1}} ->
            case check_propose(already_sworn, InId) of
                ok -> {ok, NewName};
                {false, Reason} -> {false, Reason}
            end;
        _ ->
            {false, ?L(<<"新成员加入需要所有结义成员组队申请。">>)}
    end;
check_propose_add(_Role, _SwornInfo) ->
    {false, ?L(<<"结义金兰成员最多只能有3个。">>)}.

%% @spec check_propose_del(SwornInfo) -> {ok, [{Name}...] | {false, Reason}
%% @doc 检查退出成员的结拜关系
check_propose_del(#sworn_info{num = 2, member = [#sworn_member{name = Name1}]}) -> {ok, [{Name1}]};
check_propose_del(#sworn_info{num = 3, member = [#sworn_member{name = Name1}, #sworn_member{name = Name2}]}) -> {ok, [{Name1}, {Name2}]};
check_propose_del(_) -> {false, ?L(<<"您确定您已经结拜过了吗？">>)}.

%% @spec add_member(Role, SwornInfo) -> {ok, NewRole} | {false, Reason}
%% @doc 确定新成员加入
add_member(Role, SwornInfo = #sworn_info{num = 2, member = [#sworn_member{id = Id1}]}) ->
    case check_propose_common(Role) of
        {false, Reason} ->
            {false, Reason};
        {ok, #role{id = Id1, pid = Pid1}, InRole = #role{id = InId}} ->
            case check_propose(already_sworn, InId) of
                ok ->
                    case handle_add_member(Role, SwornInfo, Pid1, InRole) of
                        {false, Reason} ->
                            {false, Reason};
                        {ok, NewRole} ->
                            {ok, NewRole}
                    end;
                {false, Reason} -> {false, Reason}
            end;
        {ok, InRole = #role{id = InId}, #role{id = Id1, pid = Pid1}} ->
            case check_propose(already_sworn, InId) of
                ok ->
                    case handle_add_member(Role, SwornInfo, Pid1, InRole) of
                        {false, Reason} ->
                            {false, Reason};
                        {ok, NewRole} ->
                            {ok, NewRole}
                    end;
                {false, Reason} -> {false, Reason}
            end;
        _ ->
            {false, ?L(<<"新成员加入需要所有结义成员组队申请。">>)}
    end;
add_member(_Role, _SwornInfo) ->
    {false, ?L(<<"结义金兰成员最多只能有3个。">>)}.

%% @spec del_member(Role, SwornInfo) -> {ok, NewRole} | {false, Reason}
%% @doc 割袍断义
del_member(Role, SwornInfo = #sworn_info{id = OutId, num = 2, member = [#sworn_member{id = Id1}]}) ->
    del_member_other(Id1, OutId, 1, 1),        %% 其他成员处理
    case do_del_member(Role, SwornInfo) of  %% 退出成员处理
        {false, Reason} ->
            {false, Reason};
        {ok, NewRole} ->
            {ok, NewRole}
    end;
del_member(Role, SwornInfo = #sworn_info{id = OutId, num = 3, member = [#sworn_member{id = Id1, rank = Rank1}, #sworn_member{id = Id2, rank = Rank2}]}) ->
    {R1, R2} = case Rank1 =< Rank2 of
        true -> {1, 2};
        false -> {2, 1}
    end,
    del_member_other(Id1, OutId, 2, R1),        %% 其他成员处理
    del_member_other(Id2, OutId, 2, R2),        %% 其他成员处理
    case do_del_member(Role, SwornInfo) of  %% 退出成员处理
        {false, Reason} ->
            {false, Reason};
        {ok, NewRole} ->
            {ok, NewRole}
    end.

%% @spec use_jinlanpu(Role, Item) -> {ok, NewRole} | {false, Reason}
%% @doc 使用金兰谱
use_jinlanpu(Role = #role{id = RoleId, pid = Pid}, #item{id = ItemId}) ->
    LossList = [#loss{label = item_id, val = [{ItemId, 1}]}],
    case role_gain:do(LossList, Role) of
        {false, #loss{msg = Msg}} -> {false, Msg};
        {ok, NewRole} ->
            Val = 500,  %% 增加500点亲密度
            case ets:lookup(ets_role_sworn, RoleId) of
                [] ->
                    {false, ?L(<<"您确定您已经结拜过了吗？">>)};
                [#sworn_info{member = [#sworn_member{id = Id1}]}] ->
                    case role_api:lookup(by_id, Id1) of
                        {ok, _, #role{pid = ToPid1}} ->
                            add_intimacy({RoleId, Pid}, {Id1, ToPid1}, Val),
                            role:pack_send(Pid, 10931, {55, ?L(<<"金兰谱化作一道金光落在了你与结义兄弟的身上，你们之间的亲密值增加500。">>), []}),
                            role:pack_send(ToPid1, 10931, {55, ?L(<<"金兰谱化作一道金光落在了你与结义兄弟的身上，你们之间的亲密值增加500。">>), []});
                        _ ->
                            ignore
                    end,
                    {ok, NewRole};
                [#sworn_info{member = [#sworn_member{id = Id1}, #sworn_member{id = Id2}]}] ->
                    case role_api:lookup(by_id, Id1) of
                        {ok, _, #role{pid = ToPid1}} ->
                            add_intimacy({RoleId, Pid}, {Id1, ToPid1}, Val),
                            role:pack_send(Pid, 10931, {55, ?L(<<"金兰谱化作一道金光落在了你与结义兄弟的身上，你们之间的亲密值增加500。">>), []}),
                            role:pack_send(ToPid1, 10931, {55, ?L(<<"金兰谱化作一道金光落在了你与结义兄弟的身上，你们之间的亲密值增加500。">>), []}),
                            case role_api:lookup(by_id, Id2) of
                                {ok, _, #role{pid = ToPid2}} ->
                                    add_intimacy({RoleId, Pid}, {Id2, ToPid2}, Val),
                                    add_intimacy({Id1, ToPid1}, {Id2, ToPid2}, Val),
                                    role:pack_send(ToPid2, 10931, {55, ?L(<<"金兰谱化作一道金光落在了你与结义兄弟的身上，你们之间的亲密值增加500。">>), []});
                                _ ->
                                    ignore
                            end;
                        _ ->
                            case role_api:lookup(by_id, Id2) of
                                {ok, _, #role{pid = ToPid2}} ->
                                    add_intimacy({RoleId, Pid}, {Id2, ToPid2}, Val),
                                    role:pack_send(Pid, 10931, {55, ?L(<<"金兰谱化作一道金光落在了你与结义兄弟的身上，你们之间的亲密值增加500。">>), []}),
                                    role:pack_send(ToPid2, 10931, {55, ?L(<<"金兰谱化作一道金光落在了你与结义兄弟的身上，你们之间的亲密值增加500。">>), []});
                                _ ->
                                    ignore
                            end
                    end,
                    {ok, NewRole};
                [_] ->
                    {false, ?L(<<"您的结拜信息有异常">>)}
            end
    end.

%% @spec change_sex_title(Role) -> NewRole.
%% @doc 变性后转换普通结拜称号
change_sex_title(Role = #role{id = Id}) ->
    case ets:lookup(ets_role_sworn, Id) of
        [SwornInfo = #sworn_info{type = ?SWORN_COMMON, title_id = TitleID}] ->
            Role1 = del_title_and_push(Role, TitleID),
            {NewRole, NewSwornInfo} = add_title(Role1, SwornInfo),
            save(NewSwornInfo),
            NewRole;
        _ ->
            Role
    end.

%% @spec role_disconnect(Role) -> any()
%% @doc 监听玩家断开连接
role_disconnect(#role{id = Id, event = Event}) when Event =:= ?event_jiebai ->
    gen_fsm:send_all_state_event(?MODULE, {role_disconnect, Id});
role_disconnect(_) -> ignore.

%% @spec role_online(Id, ConnPid) -> any()
%% @doc 玩家活动中重新登录
role_online(Id, Pid, ConnPid) when is_pid(Pid) andalso is_pid(ConnPid) ->
    gen_fsm:send_all_state_event(?MODULE, {role_online, Id, Pid, ConnPid});
role_online(_Id, _, _) -> ignore.

%% @spec handle_sworn_login(Role, SwornInfo) -> NewRole.
%% @doc 中途断线重新登录后获取称号
handle_sworn_login(Role, SwornInfo) ->
    {ok, Role1} = do_handle_sworn(Role, SwornInfo),
    Role1.

%% @doc 开启结拜进程
start_link() ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 初始化
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    State = #sworn{is_swearing = ?false, ts = now(), t_cd = ?SWORN_IDEL_TIMEOUT},
    ets:new(ets_role_sworn, [public, set, named_table, {keypos, #sworn_info.id}]),
    {ok, idel, State}.

%% 上线
handle_event({role_online, Id, Pid, ConnPid}, StateName, State = #sworn{is_swearing = ?true, leader_id = Id}) ->
    NewState = State#sworn{leader_pid = Pid, leader_conn_pid = ConnPid},
    continue(StateName, NewState);
handle_event({role_online, Id, Pid, ConnPid}, StateName, State = #sworn{is_swearing = ?true, member1_id = Id}) ->
    NewState = State#sworn{member1_pid = Pid, member1_conn_pid = ConnPid},
    continue(StateName, NewState);
handle_event({role_online, Id, Pid, ConnPid}, StateName, State = #sworn{is_swearing = ?true, member2_id = Id}) ->
    NewState = State#sworn{member2_pid = Pid, member2_conn_pid = ConnPid},
    continue(StateName, NewState);
%% 掉线
handle_event({role_disconnect, Id}, StateName, State = #sworn{is_swearing = ?true, leader_id = Id}) ->
    continue(StateName, State#sworn{leader_conn_pid = 0});
handle_event({role_disconnect, Id}, StateName, State = #sworn{is_swearing = ?true, member1_id = Id}) ->
    continue(StateName, State#sworn{member1_conn_pid = 0});
handle_event({role_disconnect, Id}, StateName, State = #sworn{is_swearing = ?true, member2_id = Id}) ->
    continue(StateName, State#sworn{member2_conn_pid = 0});
handle_event(_Event, StateName, State) ->
    %?ERR("忽略错误的异步事件[Event: ~w~nStateName: ~w~nState: ~w]", [_Event, StateName, State]),
    continue(StateName, State).

%% 开始结拜
handle_sync_event({fight, Role = #role{pos = #pos{map = MapId}}, NewState}, _From, idel, State = #sworn{is_swearing = ?false}) ->
    ?DEBUG("进行战斗"),
    {ok, BaseNpc1} = npc_data:get(21000),
    {ok, BaseNpc2} = npc_data:get(21001),
    Npc1 = npc_convert:base_to_npc(0, BaseNpc1, #pos{map = MapId}),
    Npc2 = npc_convert:base_to_npc(0, BaseNpc2, #pos{map = MapId}),
    case combat_type:check(sworn, Role, [Npc1, Npc2]) of
        {true, _} ->
            erlang:send_after(?SWORN_READY_FIGHT, self(), {fight, Role, Npc1, Npc2}),
            continue(fight, ok, NewState#sworn{is_swearing = ?true, ts = now(), t_cd = ?SWORN_READY_FIGHT});
        {false, Reason} ->
            Reply = {false, Reason},
            continue(idel, Reply, State)
    end;
handle_sync_event({fight, _, _}, _From, StateName, State) ->
    Reply = {false, ?L(<<"有其他人正在进行结拜，请耐心等待他们结拜结束后，再进行结拜">>)},
    continue(StateName, Reply, State);
handle_sync_event({prepare}, _From, fight, State = #sworn{team_pid = TeamPid}) ->
    ?DEBUG("战斗之后开始结拜"),
    handle_role_scene(prepare, State),
    broad_cast(prepare, State),
    NewState = handle_scene(prepare, State),
    team:stop(TeamPid, sworn),
    notice_time(NewState, ?SWORN_PRE_TIMEOUT div 1000),
    continue(prepare, ok, NewState#sworn{ts = now(), t_cd = ?SWORN_PRE_TIMEOUT});
handle_sync_event({prepare, NewState}, _From, idel, #sworn{is_swearing = ?false}) ->
    ?DEBUG("请求进行结拜"),
    handle_role_scene(prepare, NewState),
    broad_cast(prepare, NewState),
    NewState1 = handle_scene(prepare, NewState),
    notice_time(NewState1, ?SWORN_PRE_TIMEOUT div 1000),
    continue(prepare, ok, NewState1#sworn{is_swearing = ?true, ts = now(), t_cd = ?SWORN_PRE_TIMEOUT});
handle_sync_event({prepare, _}, _From, StateName, State) ->
    Reply = {false, ?L(<<"有其他人正在进行结拜，请耐心等待他们结拜结束后，再进行结拜">>)},
    continue(StateName, Reply, State);
handle_sync_event(_Event, _From, StateName, State) ->
    ?DEBUG("结拜进程在状态:~w 收到忽略的同步请求:~w", [StateName, _Event]),
    Reply = false,
    continue(StateName, Reply, State).

%% 提示客户端剩余时间
notice_time(#sworn{num = 2, leader_conn_pid = LeaderConnPid, member1_conn_pid = Member1ConnPid}, Time) ->
    sys_conn:pack_send(LeaderConnPid, 16308, {Time}),
    sys_conn:pack_send(Member1ConnPid, 16308, {Time});
notice_time(#sworn{num = 3, leader_conn_pid = LeaderConnPid, member1_conn_pid = Member1ConnPid, member2_conn_pid = Member2ConnPid}, Time) ->
    sys_conn:pack_send(LeaderConnPid, 16308, {Time}),
    sys_conn:pack_send(Member1ConnPid, 16308, {Time}),
    sys_conn:pack_send(Member2ConnPid, 16308, {Time}).

%% 进入战斗
handle_info({fight, Role = #role{pos = #pos{map = MapId}}, Npc1, Npc2}, fight, State) ->
    {ok, Fighter1} = npc_convert:do(to_fighter, Npc1),
    {ok, Fighter2} = npc_convert:do(to_fighter, Npc2),
    combat:start(sworn, MapId, role_api:fighter_group(Role), [Fighter1, Fighter2]),
    continue(fight, State);
%% 仪式白帝石像说话
handle_info(broad_cast_ceremony, ceremony, State) ->
    NewState = broad_cast_ceremony(State),
    continue(ceremony, NewState);
%% 仪式玩家动作
handle_info({bows, N}, ceremony, State) ->
    bows(State, N),
    continue(ceremony, State);
handle_info(_Info, StateName, State) ->
    ?DEBUG("忽略的异步消息Info: ~w StateName: ~w State: ~w", [_Info, StateName, State]),
    continue(StateName, State).

%% 进程结束
terminate(_Reason, StateName, State) ->
    stop(StateName, State),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% 结拜中关服处理
stop(fight, State = #sworn{is_swearing = ?true, type = ?SWORN_LOD}) ->
    ?INFO("服务器关机时有玩家正在生死结拜战斗中"),
    send_mail(stop_lod_fight, State),
    ok;
stop(_StateName, State = #sworn{is_swearing = ?true, type = ?SWORN_LOD}) ->
    ?INFO("服务器关机时有玩家正在生死结拜中"),
    send_mail(stop_lod_sworn, State),
    ok;
stop(_StateName, _State) ->
    ok.

%% -------------------------------------------
%% 私有函数
%% -------------------------------------------
%% 仪式玩家动作
bows(S) ->
    bows(S, 0).
bows(#sworn{num = 3, leader_pid = LeaderPid, member1_pid = MemberPid1, member2_pid = MemberPid2}, N) ->
    Data = {bows, N + 1},
    if
        N =:= 0 ->
            ?DEBUG("定下人物方向"),
            role:apply(async, LeaderPid, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid1, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid2, {fun do_bows/2, [N]}),
            erlang:send_after(9 * 1000, self(), Data);
        N =:= 1 -> %% 拜石像
            ?DEBUG("拜石像"),
            role:apply(async, LeaderPid, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid1, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid2, {fun do_bows/2, [N]}),
            erlang:send_after(8 * 1000, self(), Data);
        N =:= 2 -> %% 喝酒
            ?DEBUG("喝酒"),
            role:apply(async, LeaderPid, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid1, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid2, {fun do_bows/2, [N]}),
            erlang:send_after(8 * 1000, self(), Data);
        N =:= 3 -> %% 再拜石像
            ?DEBUG("再拜石像"),
            role:apply(async, LeaderPid, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid1, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid2, {fun do_bows/2, [N]});
        true ->
            ?DEBUG("错拜"),
            ignore
    end;
bows(#sworn{num = 2, leader_pid = LeaderPid, member1_pid = MemberPid1}, N) ->
    Data = {bows, N + 1},
    if
        N =:= 0 ->
            ?DEBUG("定下人物方向"),
            role:apply(async, LeaderPid, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid1, {fun do_bows/2, [N]}),
            erlang:send_after(9 * 1000, self(), Data);
        N =:= 1 -> %% 拜石像
            ?DEBUG("拜石像"),
            role:apply(async, LeaderPid, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid1, {fun do_bows/2, [N]}),
            erlang:send_after(8 * 1000, self(), Data);
        N =:= 2 -> %% 喝酒
            ?DEBUG("喝酒"),
            role:apply(async, LeaderPid, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid1, {fun do_bows/2, [N]}),
            erlang:send_after(8 * 1000, self(), Data);
        N =:= 3 -> %% 再拜石像
            ?DEBUG("再拜石像"),
            role:apply(async, LeaderPid, {fun do_bows/2, [N]}),
            role:apply(async, MemberPid1, {fun do_bows/2, [N]});
        true ->
            ?DEBUG("错拜"),
            ignore
    end.

do_bows(Role = #role{special = Special}, N) ->
    V = if
        N =:= 1 -> ?special_val_ceremony_1;
        N =:= 2 -> ?special_val_ceremony_2;
        N =:= 3 -> ?special_val_ceremony_3;
        true -> ?special_val_ceremony
    end,
    NewS = {?special_sworn_ceremony, V, <<>>},
    NewSpecial = case lists:keyfind(?special_sworn_ceremony, 1, Special) of
        false -> [NewS | Special];
        _S -> lists:keyreplace(?special_sworn_ceremony, 1, Special, NewS)
    end,
    map:role_update(Role#role{special = NewSpecial}),
    {ok}.    

%% 结拜仪式白帝对白
broad_cast_ceremony(S = #sworn{ceremony = Ce})
when Ce =:= 0 ->
    erlang:send_after(ceremony_cd(Ce) * 1000, self(), broad_cast_ceremony),
    S#sworn{ceremony = Ce + 1};
broad_cast_ceremony(S = #sworn{map_pid = MapPid, ceremony = Ce}) ->
    Sentence = ceremony_talk(Ce, S),
    map:pack_send_to_all(MapPid, 10910, {2, 0, <<>>, ?L(<<"白帝石像">>), 0, 0, [], [], Sentence}),
    case ceremony_cd(Ce) of
        false -> ignore;
        Cd -> 
            erlang:send_after(Cd * 1000, self(), broad_cast_ceremony)
    end,
    S#sworn{ceremony = Ce + 1}.

%% 白帝石像对白配置
ceremony_talk(1, _) -> ?L(<<"聚首帝祠结金兰，叱咤飞仙定乾坤。">>);
ceremony_talk(2, _) -> ?L(<<"皇天为证，后土为鉴，吾白帝元神受之托，证汝结义金兰。">>);
ceremony_talk(3, #sworn{num = 2, leader_name = LeaderName, member1_name = MemberName1}) ->
    util:fbin(?L(<<"~s、~s自修道之始，修行不辍，日益精进，终有所成。应天时人和，吾允所托。">>), [LeaderName, MemberName1]); 
ceremony_talk(3, #sworn{num = 3, leader_name = LeaderName, member1_name = MemberName1, member2_name = MemberName2}) ->
    util:fbin(?L(<<"~s、~s、~s自修道之始，修行不辍，日益精进，终有所成。应天时人和，吾允所托。">>), [LeaderName, MemberName1, MemberName2]);
ceremony_talk(4, _) -> ?L(<<"愿汝等日后继续锄强扶弱，救死扶伤，造福一方。">>);
ceremony_talk(5, _) -> ?L(<<"汝等都堪师门楷模、洛水英杰，当举杯豪饮共赴前程。">>);
ceremony_talk(6, _) -> ?L(<<"大义者，不求同年同月同日生，但求同年同月死。">>);
ceremony_talk(7, _) -> ?L(<<"望各位在今后飞仙路上死生相托，吉凶相救，福祸相依，患难相依。">>).
%% 白帝石像说话间隔
ceremony_cd(0) -> 1;
ceremony_cd(1) -> 4;
ceremony_cd(2) -> 4;
ceremony_cd(3) -> 4;
ceremony_cd(4) -> 4;
ceremony_cd(5) -> 4;
ceremony_cd(6) -> 4;
ceremony_cd(_) -> false.

%% 准备阶段场景处理
handle_scene(prepare, State) ->
    ElemIdList = create_elem(?ELEM_DESK),
    State#sworn{elem_id = ElemIdList};
handle_scene(over, State = #sworn{elem_id = Elems}) ->
    remove_elem(Elems),
    State#sworn{elem_id = []};
handle_scene(_, State) -> State.

%% 删除一组元素
remove_elem([]) -> ok;
remove_elem([ElemId | T]) ->
    map:elem_leave(?SWORN_MAP, ElemId),
    remove_elem(T).

%% 创建普通elem
create_elem(List) ->
    create_elem(List, []).
create_elem([], ElemIdList) -> ElemIdList;
create_elem([{Id, BaseId, X, Y} | T], ElemIdList) ->
    case map_data_elem:get(BaseId) of
        Elem when is_record(Elem, map_elem) ->
            map:elem_enter(?SWORN_MAP, Elem#map_elem{id = Id, x = X, y = Y}),
            create_elem(T, [Id | ElemIdList]);
        _E ->
            ?ERR("创建元素:~w, ~w失败了：~w", [Id, BaseId, _E]),
            create_elem(T, ElemIdList)
    end;
create_elem([_ | T], ElemIdList) ->
    create_elem(T, ElemIdList).

broad_cast(prepare, #sworn{num = 2, leader_id = {Id, SrvId}, leader_name = LeaderName, member1_id = {Id1, SrvId1}, member1_name = MemberName1}) ->
    LeaderInfo = notice:role_to_msg({Id, SrvId, LeaderName}),
    MemberInfo1 = notice:role_to_msg({Id1, SrvId1, MemberName1}),
    notice:send(53, util:fbin(?L(<<"~s、~s的结拜仪式1分钟后即将在洛水城白帝祠处举行。">>), [LeaderInfo, MemberInfo1]));
broad_cast(prepare, #sworn{num = 3, leader_id = {Id, SrvId}, leader_name = LeaderName, member1_id = {Id1, SrvId1}, member1_name = MemberName1, member2_id = {Id2, SrvId2}, member2_name = MemberName2}) ->
    LeaderInfo = notice:role_to_msg({Id, SrvId, LeaderName}),
    MemberInfo1 = notice:role_to_msg({Id1, SrvId1, MemberName1}),
    MemberInfo2 = notice:role_to_msg({Id2, SrvId2, MemberName2}),
    notice:send(53, util:fbin(?L(<<"~s、~s、~s的结拜仪式1分钟后即将在洛水城白帝祠处举行。">>), [LeaderInfo, MemberInfo1, MemberInfo2]));
broad_cast(over_common, #sworn{num = 2, type = ?SWORN_COMMON, leader_id = {Id, SrvId}, leader_name = Name, member1_id = {Id1, SrvId1}, member1_name = Name1}) ->
    Info = notice:role_to_msg({Id, SrvId, Name}),
    Info1 = notice:role_to_msg({Id1, SrvId1, Name1}),
    notice:send(53, util:fbin(?L(<<"~s、~s相互敬仰已久，终于在洛水城白帝祠聚首，结为异姓兄弟。">>), [Info, Info1]));
broad_cast(over_common, #sworn{num = 3, type = ?SWORN_COMMON, leader_id = {Id, SrvId}, leader_name = Name, member1_id = {Id1, SrvId1}, member1_name = Name1, member2_id = {Id2, SrvId2}, member2_name = Name2}) ->
    Info = notice:role_to_msg({Id, SrvId, Name}),
    Info1 = notice:role_to_msg({Id1, SrvId1, Name1}),
    Info2 = notice:role_to_msg({Id2, SrvId2, Name2}), 
    notice:send(53, util:fbin(?L(<<"~s、~s、~s相互敬仰已久，终于在洛水城白帝祠聚首，结为异姓兄弟。">>), [Info, Info1, Info2]));
broad_cast(over_lod, #sworn_info{num = 2, type = ?SWORN_LOD, title = Title, id = {Id, SrvId}, name = Name, member = [#sworn_member{id = {Id1, SrvId1}, name = Name1}]}) ->
    Info = notice:role_to_msg({Id, SrvId, Name}),
    Info1 = notice:role_to_msg({Id1, SrvId1, Name1}),
    notice:send(53, util:fbin(?L(<<"~s、~s果然是兄弟情深，历经皇天后土的生死考验，终于在洛水城白帝祠完成结义仪式。【~s】的名号一时无两，震动洛水。">>), [Info, Info1, Title]));
broad_cast(over_lod, #sworn_info{num = 3, type = ?SWORN_LOD, title = Title, id = {Id, SrvId}, name = Name, member = [#sworn_member{id = {Id1, SrvId1}, name = Name1}, #sworn_member{id = {Id2, SrvId2}, name = Name2}]}) ->
    Info = notice:role_to_msg({Id, SrvId, Name}),
    Info1 = notice:role_to_msg({Id1, SrvId1, Name1}),
    Info2 = notice:role_to_msg({Id2, SrvId2, Name2}),
    notice:send(53, util:fbin(?L(<<"~s、~s、~s果然是兄弟情深，历经皇天后土的生死考验，终于在洛水城白帝祠完成结义仪式。【~s】的名号一时无两，震动洛水。">>), [Info, Info1, Info2, Title]));
broad_cast(edit_title, #sworn_info{num = 2, title = Title, id = {Id, SrvId}, name = Name, member = [#sworn_member{id = {Id1, SrvId1}, name = Name1}]}) ->
    Info = notice:role_to_msg({Id, SrvId, Name}),
    Info1 = notice:role_to_msg({Id1, SrvId1, Name1}),
    notice:send(53, util:fbin(?L(<<"~s~s经过深思熟虑后终于在白帝像处重新选取了结义称号，【~s】的名号果然更符合他们的身份。">>), [Info, Info1, Title]));
broad_cast(edit_title, #sworn_info{num = 3, title = Title, id = {Id, SrvId}, name = Name, member = [#sworn_member{id = {Id1, SrvId1}, name = Name1}, #sworn_member{id = {Id2, SrvId2}, name = Name2}]}) ->
    Info = notice:role_to_msg({Id, SrvId, Name}),
    Info1 = notice:role_to_msg({Id1, SrvId1, Name1}),
    Info2 = notice:role_to_msg({Id2, SrvId2, Name2}),
    notice:send(53, util:fbin(?L(<<"~s~s~s经过深思熟虑后终于在白帝像处重新选取了结义称号，【~s】的名号果然更符合他们的身份。">>), [Info, Info1, Info2, Title]));
broad_cast(_, _) -> ok.

%% 结拜各个阶段 异步回调处理
handle_role_scene(Flag, #sworn{type = Type, num = 2, leader_pid = LeaderPid, member1_pid = MemberPid1}) ->
    role:apply(async, LeaderPid, {fun do_handle_role_scene/2, [{Flag, Type, 2, leader}]}),
    role:apply(async, MemberPid1, {fun do_handle_role_scene/2, [{Flag, Type, 2, member1}]});
handle_role_scene(Flag, #sworn{type = Type, num = 3, leader_pid = LeaderPid, member1_pid = MemberPid1, member2_pid = MemberPid2}) ->
    role:apply(async, LeaderPid, {fun do_handle_role_scene/2, [{Flag, Type, 3, leader}]}),
    role:apply(async, MemberPid1, {fun do_handle_role_scene/2, [{Flag, Type, 3, member1}]}),
    role:apply(async, MemberPid2, {fun do_handle_role_scene/2, [{Flag, Type, 3, member2}]}).
do_handle_role_scene(Role, {prepare, _Type, _Num, _Status}) ->
    NewRole = Role#role{ride = ?ride_no, event = ?event_jiebai},
    map:role_update(NewRole),
    {ok, NewRole};
do_handle_role_scene(Role, {ceremony, _Type, 2, Status}) ->
    {X, Y} = case Status of
        leader -> ?MEMBER_2_POS1;
        member1 -> ?MEMBER_2_POS2
    end,
    case map:role_enter(?SWORN_MAP, X, Y, Role) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {ok}
    end;
do_handle_role_scene(Role, {ceremony, _Type, 3, Status}) ->
    {X, Y} = case Status of
        leader -> ?MEMBER_3_POS1;
        member1 -> ?MEMBER_3_POS2;
        member2 -> ?MEMBER_3_POS3
    end,
    case map:role_enter(?SWORN_MAP, X, Y, Role) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {ok}
    end;
do_handle_role_scene(Role, {over, _Type, 2, Status}) ->
    {X, Y} = case Status of
        leader -> ?MEMBER_2_POS1;
        member1 -> ?MEMBER_2_POS2
    end,
    case map:role_enter(?SWORN_MAP, X, Y, Role#role{event = ?event_no}) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {ok}
    end;
do_handle_role_scene(Role, {over, _Type, 3, Status}) ->
    {X, Y} = case Status of
        leader -> ?MEMBER_3_POS1;
        member1 -> ?MEMBER_3_POS2;
        member2 -> ?MEMBER_3_POS3
    end,
    case map:role_enter(?SWORN_MAP, X, Y, Role#role{event = ?event_no}) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {ok}
    end;
do_handle_role_scene(_, _) -> {ok}.

%% 重置时间，切换状态
continue(StateName, Reply, State = #sworn{ts = Ts, t_cd = Tcd}) ->
    {reply, Reply, StateName, State, util:time_left(Tcd, Ts)}.

continue(StateName, State = #sworn{ts = Ts, t_cd = Tcd}) ->
    T = util:time_left(Tcd, Ts),
    Tn = case T =< 0 of
        true ->
            ?DEBUG("检测到时间有问题Tcd:~w, Ts:~w State:~w", [Tcd, Ts, State]),
            1000000;
        false ->
            T
    end,
    ?DEBUG("~w 毫秒后，进入~w处理函数", [T, StateName]),
    {next_state, StateName, State, Tn}.

%% @doc 检查玩家是否符合结拜条件
check_propose_common(Role = #role{id = _Id}) ->
    case check_propose(self, Role) of
        {false, Reason} ->
            {false, Reason};
        ok ->
            case check_propose(team, Role) of
                {false, Reason} ->
                    {false, Reason};
                {ok, #team_member{id = Id1, pid = Pid1}} ->
                    case check_propose(friend, {Id1, Pid1}) of
                        {false, Reason} ->
                            {false, Reason};
                        ok ->
                            case check_propose(online, Pid1) of
                                {false, Reason} ->
                                    {false, Reason};
                                {ok, Role1} ->
                                    case check_propose(member, Role1) of
                                        ok -> {ok, Role1};
                                        {false, Reason} -> {false, Reason}
                                    end
                            end
                    end;
                {ok, #team_member{id = _Id1, pid = Pid1}, #team_member{id = _Id2, pid = Pid2}} ->
                    case check_propose(online, Pid1, Pid2) of
                        {false, Reason} ->
                            {false, Reason};
                        {ok, Role1, Role2} ->
                            case check_propose(member, Role1, Role2) of
                                ok -> {ok, Role1, Role2};
                                {false, Reason} -> {false, Reason}
                            end
                    end
            end
    end.

check_propose(self, #role{lev = Lev})
when Lev < 40 ->
    {false, ?L(<<"队伍中有成员等级不足40哦，请先提升实力再来">>)};
check_propose(self, #role{pos = #pos{map = Map}})
when Map =/= ?SWORN_MAP ->
    {false, ?L(<<"请到白帝庙进行结拜">>)};
check_propose(self, _Role) -> ok;
check_propose(team, #role{team_pid = TeamPid, team = #role_team{is_leader = ?true}})
when is_pid(TeamPid) ->
    case team_api:get_team_info(TeamPid) of
        false ->
            {false, ?L(<<"结拜最少也要两个人，你一个人来是什么意思。">>)};
        {ok, #team{member = [#team_member{mode = Mode}]}}
        when Mode =/= ?MODE_NORMAL ->
            {false, ?L(<<"有结拜成员不在队伍中">>)};
        {ok, #team{member = [#team_member{mode = Mode1}, #team_member{mode = Mode2}]}} 
        when Mode1 =/= ?MODE_NORMAL orelse Mode2 =/= ?MODE_NORMAL ->
            {false, ?L(<<"有结拜成员不在队伍中">>)};
        {ok, #team{member = [Member]}} ->
            {ok, Member};
        {ok, #team{member = [Member1, Member2]}} ->
            {ok, Member1, Member2};
        {ok, _} ->
            {false, ?L(<<"结拜最少也要两个人，你一个人来是什么意思。">>)}
    end;
check_propose(team, _) ->
    {false, ?L(<<"结拜最少也要两个人，你一个人来是什么意思。">>)};
check_propose(sworn, {Id, Id1}) ->
    case sworn_api:is_sworn(Id, Id1) of
        true -> {false, ?L(<<"结拜过的不能再结拜哦">>)};
        false -> ok
    end;
check_propose(friend, {Id, _Pid}) ->
    case friend:get_friend(cache, Id) of
        {ok, #friend{intimacy = Inti}} when Inti >= ?SWORN_INTIMACY -> ok;
        {ok, _} -> {false, ?L(<<"你们之间的亲密值未满1000，一面之交怎可结拜？">>)};
        _ -> {false, ?L(<<"你与队伍中某人不是好友哦，不是好友怎么结拜啊。">>)}
    end;
check_propose(online, Pid) ->
    case role_api:lookup(by_pid, Pid) of
        {ok, _, Role} ->
            {ok, Role};
        _ ->
            {false, ?L(<<"有结拜的成员不在线，结拜不能进行">>)}
    end;
check_propose(member, #role{lev = Lev})
when Lev < 40 ->
    {false, ?L(<<"队伍中有成员等级不足40哦，请先提升实力再来">>)};
check_propose(member, #role{pos = #pos{map = Map}})
when Map =/= ?SWORN_MAP ->
    {false, ?L(<<"请到白帝庙进行结拜">>)};
check_propose(member, _Role) -> ok;    
check_propose(already_sworn, Id) ->
    case ets:lookup(ets_role_sworn, Id) of
        [] -> ok;
        [_] -> {false, ?L(<<"结拜过的不能再结拜哦">>)}
    end.

check_propose(sworn, Id, {Id1, Id2}) ->
    case {sworn_api:is_sworn(Id, Id1), sworn_api:is_sworn(Id, Id2), sworn_api:is_sworn(Id1, Id2)} of
        {false, false, false} -> ok;
        _ -> {false, ?L(<<"结拜过的不能再结拜哦">>)}
    end;
check_propose(friend, {Id1, Pid1}, {Id2, _Pid2}) ->
    case {friend:get_friend(cache, Id1), friend:get_friend(cache, Id2), friend:get_friend(Pid1, Id2)} of
        {{ok, #friend{intimacy = Inti1}}, {ok, #friend{intimacy = Inti2}}, {ok, #friend{intimacy = Inti3}}}
        when Inti1 >= ?SWORN_INTIMACY andalso Inti2 >= ?SWORN_INTIMACY andalso Inti3 >= ?SWORN_INTIMACY ->
            ok;
        {{ok, _}, {ok, _}, {ok, _}} ->
            {false, ?L(<<"你们之间的亲密值未满1000，一面之交怎可结拜？">>)};
        _ ->
            {false, ?L(<<"你与队伍中某人不是好友哦，不是好友怎么结拜啊。">>)}
    end;
check_propose(online, Pid1, Pid2) ->
    case role_api:lookup(by_pid, Pid1) of
        {ok, _, Role1} ->
            case role_api:lookup(by_pid, Pid2) of
                {ok, _, Role2} ->
                    {ok, Role1, Role2};
                _ ->
                    {false, ?L(<<"有结拜的成员不在线，结拜不能进行">>)}
            end;
        _ ->
            {false, ?L(<<"有结拜的成员不在线，结拜不能进行">>)}
    end;
check_propose(member, #role{lev = Lev1}, #role{lev = Lev2})
when Lev1 < 40 orelse Lev2 < 40 ->
    {false, ?L(<<"队伍中有成员等级不足40哦，请先提升实力再来">>)};
check_propose(member, #role{pos = #pos{map = Map1}}, #role{pos = #pos{map = Map2}})
when Map1 =/= ?SWORN_MAP orelse Map2 =/= ?SWORN_MAP ->
    {false, ?L(<<"请到白帝庙进行结拜">>)};
check_propose(member, _Role1, _Role2) -> ok;
check_propose(already_sworn, Id1, Id2) ->
    case {ets:lookup(ets_role_sworn, Id1), ets:lookup(ets_role_sworn, Id2)} of
        {[], []} -> ok;
        {_, _} -> {false, ?L(<<"结拜过的不能再结拜哦">>)}
    end.

%% @doc 数据转换
convert(Type, #role{team_pid = TeamPid, pid = LeaderPid, id = LeaderId, name = LeaderName, lev = Lev, pos = #pos{map_pid = MapPid}, 
    link = #link{conn_pid = LeaderConnPid}}, #role{pid = MemberPid, id = MemberId, name = MemberName, lev = Lev1, link = #link{conn_pid = MemberConnPid}}) ->
    LevList = [Lev, Lev1],
    Rank = rank_list(LevList, rank(LevList), []),
    State = #sworn{
        is_swearing = ?true, time = util:unixtime(), type = Type, map_pid = MapPid, num = 2
        ,leader_id = LeaderId, leader_pid = LeaderPid, leader_conn_pid = LeaderConnPid, leader_name = LeaderName
        ,member1_id = MemberId, member1_pid = MemberPid, member1_conn_pid = MemberConnPid, member1_name = MemberName
        ,leader_rank = lists:nth(1, Rank), member1_rank = lists:nth(2, Rank), team_pid = TeamPid},
    save_sworn_info(State),
    State.
        
convert(Type, #role{team_pid = TeamPid, pid = LeaderPid, id = LeaderId, name = LeaderName, lev = Lev, pos = #pos{map_pid = MapPid}, 
    link = #link{conn_pid = LeaderConnPid}}, #role{pid = MemberPid, id = MemberId, name = MemberName, lev = Lev1, link = #link{conn_pid = MemberConnPid}}
    ,#role{pid = Member2Pid, id = Member2Id, name = Member2Name, lev = Lev2, link = #link{conn_pid = Member2ConnPid}}) ->
    LevList = [Lev, Lev1, Lev2],
    Rank = rank_list(LevList, rank(LevList), []),
    State = #sworn{
        is_swearing = ?true, time = util:unixtime(), type = Type, map_pid = MapPid, num = 3
        ,leader_id = LeaderId, leader_pid = LeaderPid, leader_conn_pid = LeaderConnPid, leader_name = LeaderName
        ,member1_id = MemberId, member1_pid = MemberPid, member1_conn_pid = MemberConnPid, member1_name = MemberName
        ,member2_id = Member2Id, member2_pid = Member2Pid, member2_conn_pid = Member2ConnPid, member2_name = Member2Name
        ,leader_rank = lists:nth(1, Rank), member1_rank = lists:nth(2, Rank), member2_rank = lists:nth(3, Rank), team_pid = TeamPid},
    save_sworn_info(State),
    State.

%% @spec rank(L) -> list().
%% L = [{1,Lev1},{2,Lev2}...]
%% @doc 按等级排列成员
rank(L) ->
    rank(lists:sort(fun(A, B) -> A > B end, L), 1, []).
rank([], _N, Rank) -> Rank;
rank([H | T], N, Rank) ->
    rank(T, N + 1, [{N, H} | Rank]).

%% @doc 最终排位列表
rank_list([], _List, RankList) -> lists:reverse(RankList);
rank_list([Lev | T], List, RankList) ->
    {N, NewList} = get_rank(List, Lev, []),
    rank_list(T, NewList, [N | RankList]).

%% @doc 获取排位
get_rank([], _Lev, NewList) -> {3, NewList};
get_rank([{N, Lev} | T], Lev, NewList) -> {N, NewList ++ T};
get_rank([H | T], Lev, NewList) -> get_rank(T, Lev, [H | NewList]).

%% 结拜过程中关服处理
save_sworn_info(#sworn{num = 2, is_swearing = ?true, type = Type, time = Time, leader_id = LeaderId, leader_name = LeaderName, 
        member1_id = Member1Id, member1_name = Member1Name, leader_rank = R, member1_rank = R1}) ->
    Leader = #sworn_member{id = LeaderId, name = LeaderName, rank = R},
    Member1 = #sworn_member{id = Member1Id, name = Member1Name, rank = R1},
    LeaderInfo = #sworn_info{id = LeaderId, name = LeaderName, rank = R, member = [Member1], num = 2, type = Type, time = Time},
    Member1Info = #sworn_info{id = Member1Id, name = Member1Name, rank = R1, member = [Leader], num = 2, type = Type, time = Time},
    save(LeaderInfo),
    log(sworn, LeaderInfo),
    save(Member1Info),
    log(sworn, Member1Info),
    ok;
save_sworn_info(#sworn{num = 3, is_swearing = ?true, type = Type, time = Time, leader_id = LeaderId, leader_name = LeaderName,
        member1_id = Member1Id, member1_name = Member1Name, member2_id = Member2Id, member2_name = Member2Name,
        leader_rank = R, member1_rank = R1, member2_rank = R2}) ->
    Leader = #sworn_member{id = LeaderId, name = LeaderName, rank = R},
    Member1 = #sworn_member{id = Member1Id, name = Member1Name, rank = R1},
    Member2 = #sworn_member{id = Member2Id, name = Member2Name, rank = R2},
    LeaderInfo = #sworn_info{id = LeaderId, name = LeaderName, rank = R, member = [Member1, Member2], num = 3, type = Type, time = Time},
    Member1Info = #sworn_info{id = Member1Id, name = Member1Name, rank = R1, member = [Leader, Member2], num = 3, type = Type, time = Time},
    Member2Info = #sworn_info{id = Member2Id, name = Member2Name, rank = R2, member = [Leader, Member1], num = 3, type = Type, time = Time},
    save(LeaderInfo),
    log(sworn, LeaderInfo),
    save(Member1Info),
    log(sworn, Member1Info),
    save(Member2Info),
    log(sworn, Member2Info),
    ok;
save_sworn_info(_) -> ok.

%% 结拜结束后处理
handle_over(State = #sworn{num = 2, is_swearing = ?true, type = Type, leader_id = LeaderId, leader_pid = LeaderPid,
        member1_id = Member1Id, member1_pid = Member1Pid, leader_conn_pid = LeaderConnPid}) ->
    case Type =:= ?SWORN_LOD of
        true ->
            case LeaderConnPid =/= 0 of
                true ->
                    sys_conn:pack_send(LeaderConnPid, 16302, {2, 2, <<>>});
                false ->
                    ignore
            end;
        false ->
            case ets:lookup(ets_role_sworn, LeaderId) of
                [LeaderInfo] ->
                    role:apply(async, LeaderPid, {fun do_handle_sworn/2, [LeaderInfo]});
                [] ->
                    ignore
            end,
            case ets:lookup(ets_role_sworn, Member1Id) of
                [Member1Info] ->
                    role:apply(async, Member1Pid, {fun do_handle_sworn/2, [Member1Info]});
                [] ->
                    ignore
            end,
            broad_cast(over_common, State)
    end,
    ok;
handle_over(State = #sworn{num = 3, is_swearing = ?true, type = Type, leader_id = LeaderId, leader_pid = LeaderPid,
        member1_id = Member1Id, member1_pid = Member1Pid, member2_id = Member2Id, member2_pid = Member2Pid, leader_conn_pid = LeaderConnPid}) ->
    case Type =:= ?SWORN_LOD of
        true ->
            case LeaderConnPid =/= 0 of
                true ->
                    sys_conn:pack_send(LeaderConnPid, 16302, {2, 3, <<>>});
                false ->
                    ignore
            end;
        false ->
            case ets:lookup(ets_role_sworn, LeaderId) of
                [LeaderInfo] ->
                    role:apply(async, LeaderPid, {fun do_handle_sworn/2, [LeaderInfo]});
                [] ->
                    ignore
            end,
            case ets:lookup(ets_role_sworn, Member1Id) of
                [Member1Info] ->
                    role:apply(async, Member1Pid, {fun do_handle_sworn/2, [Member1Info]});
                [] ->
                    ignore
            end,
            case ets:lookup(ets_role_sworn, Member2Id) of
                [Member2Info] ->
                    role:apply(async, Member2Pid, {fun do_handle_sworn/2, [Member2Info]});
                [] ->
                    ignore
            end,
            broad_cast(over_common, State)
    end,
    ok;
handle_over(_) -> ok.

%% 保存sworn_info数据
save(SwornInfo) when is_record(SwornInfo, sworn_info) ->
    ets:insert(ets_role_sworn, SwornInfo),
    save_db(SwornInfo).

%% 仅保存到数据库
save_db(SwornInfo) ->
    case sworn_dao:save([SwornInfo]) of
        {ok, _} ->
            ok;
        _E ->
            false
    end.

%% 删除结拜记录
del(Id) ->
    ets:delete(ets_role_sworn, Id),
    sworn_dao:delete(Id).

%% 记录日志（异步）
log(Opt, SwornInfo) ->
    spawn(sworn_dao, log, [Opt, SwornInfo]).

%% 异步回调，处理结拜数据
do_handle_sworn(Role, SwornInfo) ->
    {ok, handle_sworn(Role, SwornInfo)}.
handle_sworn(Role, SwornInfo = #sworn_info{type = Type = ?SWORN_LOD}) ->
    {NewRole, NewSwornInfo} = add_title(Role, SwornInfo#sworn_info{title_id = ?SWORN_CUSTOM_TITLE_ID}),
    save(NewSwornInfo),
    log(sworn, NewSwornInfo),
    spawn(sworn, send_mail, [sworn, NewSwornInfo]), %% 邮件发送
    campaign_listener:handle(sworn, NewRole, Type),
    NewRole;
handle_sworn(Role, SwornInfo = #sworn_info{type = Type}) ->
    {NewRole, NewSwornInfo} = add_title(Role, SwornInfo#sworn_info{title_id = ?SWORN_COMMON_TITLE_ID}),
    save(NewSwornInfo),
    log(sworn, NewSwornInfo),
    spawn(sworn, send_mail, [sworn, NewSwornInfo]), %% 邮件发送
    campaign_listener:handle(sworn, NewRole, Type),
    NewRole.

handle_leader_sworn(Role, SwornInfo = #sworn_info{type = Type = ?SWORN_LOD}) ->
    {NewRole, NewSwornInfo} = add_title(Role, SwornInfo#sworn_info{title_id = ?SWORN_CUSTOM_TITLE_ID}),
    save(NewSwornInfo),
    log(sworn, NewSwornInfo),
    broad_cast(over_lod, NewSwornInfo),
    spawn(sworn, send_mail, [sworn, NewSwornInfo]), %% 邮件发送
    campaign_listener:handle(sworn, NewRole, Type),
    {ok, NewRole}.

%% @spec add_title(Role, SwornInfo) -> NewRole.
%% SwornInfo = #sworn_info{}
%% @doc 增加结拜称号
add_title(Role = #role{sex = Sex}, SwornInfo = #sworn_info{title_id = ?SWORN_COMMON_TITLE_ID, rank = Rank}) ->
    Str = case Sex of
        ?male when Rank =:= 1 -> ?L(<<"金兰结义之大哥">>);
        ?male when Rank =:= 2 -> ?L(<<"金兰结义之二弟">>);
        ?male when Rank =:= 3 -> ?L(<<"金兰结义之小弟">>);
        ?female when Rank =:= 1 -> ?L(<<"金兰结义之大姐">>);
        ?female when Rank =:= 2 -> ?L(<<"金兰结义之二妹">>);
        ?female when Rank =:= 3 -> ?L(<<"金兰结义之小妹">>)
    end,
    Honor = {?SWORN_COMMON_TITLE_ID, Str, 0},
    case achievement:add_and_use_honor(Role, Honor) of
        {ok, NewRole} -> {NewRole, SwornInfo#sworn_info{is_award = ?true, title = ?L(<<"金兰结义">>)}};
        _ -> {Role, SwornInfo}
    end;
add_title(Role, SwornInfo = #sworn_info{title_id = ?SWORN_CUSTOM_TITLE_ID, num = Num, rank = Rank, title_h = Head, title_t = Tail}) ->
    Title = case Num =:= 2 of
        true -> 
            util:fbin(?L(<<"~s双~s">>), [Head, Tail]);
        false ->
            util:fbin(?L(<<"~s三~s">>), [Head, Tail])
    end,
    FullTitle = if
        Rank =:= 1 ->
            util:fbin(?L(<<"~s之大~s">>), [Title, Tail]);
        Rank =:= 2 ->
            util:fbin(?L(<<"~s之二~s">>), [Title, Tail]);
        true ->
            util:fbin(?L(<<"~s之小~s">>), [Title, Tail])
    end,     
    Honor = {?SWORN_CUSTOM_TITLE_ID, FullTitle, 0},
    case achievement:add_and_use_honor(Role, Honor) of
        {ok, NewRole} -> {NewRole, SwornInfo#sworn_info{is_award = ?true, title = Title}};
        _ -> {Role, SwornInfo}
    end;
add_title(Role, _) -> Role.

%% @doc 删除结拜称号
del_title_no_push(Role, TitleID) ->
    case achievement:del_honor_no_push(Role, TitleID) of
        {ok, NewRole} -> NewRole;
        _ -> Role
    end.

%% @doc 删除结拜称号并更新
del_title_and_push(Role, TitleID) ->
    case achievement:del_honor(Role, TitleID) of
        {ok, NewRole} ->
            NewRole;
        _ -> Role
    end.

%% @doc 处理其他成员称号(生死结拜后)
set_title_other(Head, Tail, Id) ->   
    case ets:lookup(ets_role_sworn, Id) of
        [] -> 
            sworn_dao:save_title(Head, Tail, Id);
        [SwornInfo = #sworn_info{type = ?SWORN_LOD}] ->
            case role_api:lookup(by_id, Id) of
                {_, _, #role{pid = Pid}} ->
                    role:apply(async, Pid, {fun do_handle_sworn/2, [SwornInfo#sworn_info{title_h = Head, title_t = Tail}]});
                _ ->
                    save_db(SwornInfo#sworn_info{title_h = Head, title_t = Tail})
            end;
        [_] ->
            {false, <<>>}
    end.

%% @doc 修改称号处理
do_edit_title(Role, SwornInfo = #sworn_info{title_id = TitleID}) ->
    Role1 = del_title_and_push(Role, TitleID),
    {NewRole, NewSwornInfo} = add_title(Role1, SwornInfo#sworn_info{title_id = ?SWORN_CUSTOM_TITLE_ID}),
    save(NewSwornInfo),
    log(edit_title, NewSwornInfo),
    spawn(sworn, send_mail, [edit, NewSwornInfo]), %% 邮件发送
    {ok, NewRole}.

do_leader_edit_title(Role, SwornInfo = #sworn_info{title_id = TitleID}) ->
    Role1 = del_title_and_push(Role, TitleID),
    {NewRole, NewSwornInfo} = add_title(Role1, SwornInfo#sworn_info{title_id = ?SWORN_CUSTOM_TITLE_ID}),
    save(NewSwornInfo),
    log(edit_title, NewSwornInfo),
    spawn(sworn, send_mail, [edit, NewSwornInfo]), %% 邮件发送
    broad_cast(edit_title, NewSwornInfo),
    {ok, NewRole}.

%% 结拜系统邮件
send_mail(sworn, #sworn_info{num = 2, type = Type, id = Id, member = [#sworn_member{name = Name1}], title = Title}) ->
    Content = case Type =:= ?SWORN_LOD of
        true ->
            util:fbin(?L(<<"你与【~s】历经生死考验，获得皇天后土的认可，终于在白帝神像前义结金兰。你们【~s】的名号(可在称号-社交称号中调用)必将威震洛水，远扬飞仙。">>), [Name1, Title]);
        false ->
            util:fbin(?L(<<"经过了简短的仪式，你与【~s】义结金兰(获得了普通结拜称号，可在称号面板中调用)，望你们从此在飞仙路上并肩作战，一飞冲天。">>), [Name1])
    end,
    mail:send_system(Id, {?L(<<"义结金兰通知">>), Content, [], []});
send_mail(sworn, #sworn_info{num = 3, type = Type, id = Id, member = [#sworn_member{name = Name1}, #sworn_member{name = Name2}], title = Title}) ->
    Content = case Type =:= ?SWORN_LOD of
        true ->
            util:fbin(?L(<<"你与【~s】、【~s】历经生死考验，获得皇天后土的认可，终于在白帝神像前义结金兰。你们【~s】的名号(可在称号-社交称号中调用)必将威震洛水，远扬飞仙。">>), [Name1, Name2, Title]);
        false ->
            util:fbin(?L(<<"经过了简短的仪式，你与【~s】、【~s】义结金兰(获得了普通结拜称号，可在称号面板中调用)，望你们从此在飞仙路上并肩作战，一飞冲天。">>), [Name1, Name2])
    end,
    mail:send_system(Id, {?L(<<"义结金兰通知">>), Content, [], []});
send_mail(edit, #sworn_info{id = Id, title = Title}) ->
    mail:send_system(Id, {?L(<<"设置结义称号">>), util:fbin(?L(<<"恭喜您与结义兄弟在白帝祠成功修改了结义称号，愿【~s】的称号(可在称号-社交称号中调用)在不久的将来能够名动洛水，响彻飞仙。">>), [Title]), [], []});
send_mail(add_member_new, #sworn_info{id = Id, member = [#sworn_member{name = Name1}, #sworn_member{name = Name2}], title = Title}) ->
    mail:send_system(Id, {?L(<<"结义新成员">>), util:fbin(?L(<<"恭喜你与~s、~s义结金兰，并获得结义称号【~s】(可在称号-社交称号中调用)、兄弟组队buff等各项结义奖励。">>), [Name1, Name2, Title]), [], []});
send_mail(add_member_other, {Id, InName}) ->
    mail:send_system(Id, {?L(<<"结义新成员">>), util:fbin(?L(<<"恭喜你们又新增一位结义兄弟~s，希望你们今后能继续互帮互爱，共同飞仙。">>), [InName]), [], []});
send_mail(del_member, #sworn_info{num = 2, id = Id, member = [#sworn_member{name = Name1}]}) ->
    mail:send_system(Id, {?L(<<"退出结义通知">>), util:fbin(?L(<<"你已经与【~s】在白帝祠割袍断义，解除结义关系，你的结拜称号也随之取消。">>), [Name1]), [], []});
send_mail(del_member, #sworn_info{num = 3, id = Id, member = [#sworn_member{name = Name1}, #sworn_member{name = Name2}]}) ->
    mail:send_system(Id, {?L(<<"退出结义通知">>), util:fbin(?L(<<"你已经与【~s】、【~s】在白帝祠割袍断义，解除结义关系，你的结拜称号也随之取消。">>), [Name1, Name2]), [], []}); 
send_mail(del_member_other, {Id, OutName}) ->
    mail:send_system(Id, {?L(<<"退出结义通知">>), util:fbin(?L(<<"【~s】在白帝祠处申请了割袍断义，与你解除了结义关系。">>), [OutName]), [], []});
send_mail(del_member_other_over, {Id, OutName}) ->
    mail:send_system(Id, {?L(<<"退出结义通知">>), util:fbin(?L(<<"【~s】在白帝祠处申请了割袍断义，与你解除了结义关系，你们的结拜称号也随之取消。">>), [OutName]), [], []});
send_mail(del_member_over, #sworn_info{num = 1, id = Id, member = [#sworn_member{name = Name1}]}) ->
    mail:send_system(Id, {?L(<<"退出结义通知">>), util:fbin(?L(<<"【~s】在与你相处一段时间后深感人情冷漠，认为与你结义并非正确的选择，与你解除结拜关系。现在你又变成孤身一人了，你们的结拜称号也随风消逝。">>), [Name1]), [], []});
send_mail(del_member_over, #sworn_info{num = 1, id = Id, member = [#sworn_member{name = Name1}, #sworn_member{name = Name2}]}) ->
    mail:send_system(Id, {?L(<<"退出结义通知">>), util:fbin(?L(<<"【~s】、【~s】在与你相处一段时间后深感人情冷漠，认为与你结义并非正确的选择，先后与你解除结拜关系。现在你又变成孤身一人了，你们的结拜称号也随风消逝。">>), [Name1, Name2]), [], []});
send_mail(stop_lod_fight, #sworn{num = 2, leader_id = LeaderId, leader_name = LeaderName, member1_id = Member1Id, member1_name = Member1Name}) ->
    Title = ?L(<<"结拜提醒">>),
    LeaderContent = util:fbin(?L(<<"恭喜您在服务器维护的情况下仍然成功与【~s】进行了生死结拜，获得结拜奖励【金兰谱】（使用后增加结拜好友之间亲密值500点）。同时，你们可以组队在白帝石像处免费设置一次结拜称号。">>), [Member1Name]),
    Member1Content = util:fbin(?L(<<"恭喜您在服务器维护的情况下仍然成功与【~s】进行了生死结拜，你们可以组队在白帝石像处免费设置一次结拜称号。">>), [LeaderName]),
    mail:send_system(LeaderId, {Title, LeaderContent, [], [{33057, 1, 1}]}),
    mail:send_system(Member1Id, {Title, Member1Content, [], []});
send_mail(stop_lod_fight, #sworn{num = 3, leader_id = LeaderId, leader_name = LeaderName, member1_id = Member1Id, member1_name = Member1Name, member2_id = Member2Id, member2_name = Member2Name}) ->
    Title = ?L(<<"结拜提醒">>),
    LeaderContent = util:fbin(?L(<<"恭喜您在服务器维护的情况下仍然成功与【~s】【~s】进行了生死结拜，获得结拜奖励【金兰谱】（使用后增加结拜好友之间亲密值500点）。同时，你们可以组队在白帝石像处免费设置一次结拜称号。">>), [Member1Name, Member2Name]),
    Member1Content = util:fbin(?L(<<"恭喜您在服务器维护的情况下仍然成功与【~s】【~s】进行了生死结拜，你们可以组队在白帝石像处免费设置一次结拜称号。">>), [LeaderName, Member2Name]),
    Member2Content = util:fbin(?L(<<"恭喜您在服务器维护的情况下仍然成功与【~s】【~s】进行了生死结拜，你们可以组队在白帝石像处免费设置一次结拜称号。">>), [LeaderName, Member1Name]),
    mail:send_system(LeaderId, {Title, LeaderContent, [], [{33057, 1, 1}]}),
    mail:send_system(Member1Id, {Title, Member1Content, [], []}),
    mail:send_system(Member2Id, {Title, Member2Content, [], []});
send_mail(stop_lod_sworn, #sworn{num = 2, leader_id = LeaderId, leader_name = LeaderName, member1_id = Member1Id, member1_name = Member1Name}) ->
    Title = ?L(<<"结拜提醒">>),
    LeaderContent = util:fbin(?L(<<"恭喜您在服务器维护的情况下仍然成功与【~s】进行了生死结拜，你们可以组队在白帝石像处免费设置一次结拜称号。">>), [Member1Name]),
    Member1Content = util:fbin(?L(<<"恭喜您在服务器维护的情况下仍然成功与【~s】进行了生死结拜，你们可以组队在白帝石像处免费设置一次结拜称号。">>), [LeaderName]),
    mail:send_system(LeaderId, {Title, LeaderContent, [], []}),
    mail:send_system(Member1Id, {Title, Member1Content, [], []});
send_mail(stop_lod_sworn, #sworn{num = 3, leader_id = LeaderId, leader_name = LeaderName, member1_id = Member1Id, member1_name = Member1Name, member2_id = Member2Id, member2_name = Member2Name}) ->
    Title = ?L(<<"结拜提醒">>),
    LeaderContent = util:fbin(?L(<<"恭喜您在服务器维护的情况下仍然成功与【~s】【~s】进行了生死结拜，你们可以组队在白帝石像处免费设置一次结拜称号。">>), [Member1Name, Member2Name]),
    Member1Content = util:fbin(?L(<<"恭喜您在服务器维护的情况下仍然成功与【~s】【~s】进行了生死结拜，你们可以组队在白帝石像处免费设置一次结拜称号。">>), [LeaderName, Member2Name]),
    Member2Content = util:fbin(?L(<<"恭喜您在服务器维护的情况下仍然成功与【~s】【~s】进行了生死结拜，你们可以组队在白帝石像处免费设置一次结拜称号。">>), [LeaderName, Member1Name]),
    mail:send_system(LeaderId, {Title, LeaderContent, [], []}),
    mail:send_system(Member1Id, {Title, Member1Content, [], []}),
    mail:send_system(Member2Id, {Title, Member2Content, [], []}).

%% @doc 处理新成员加入（队长的处理）
handle_add_member(Role, SwornInfo = #sworn_info{id = Id, member = Members, title_id = TitleID, type = Type}, Pid1, #role{id = NewId, name = NewName, pid = NewPid}) ->
    role:apply(async, NewPid, {fun do_add_member/2, [SwornInfo]}),      %% 新成员处理
    role:apply(async, Pid1, {fun do_add_member/3, [NewId, NewName]}),   %% 原有成员处理
    NewMember = #sworn_member{id = NewId, name = NewName, rank = 3},
    {NewRole, NewSwornInfo} = case TitleID =:= ?SWORN_CUSTOM_TITLE_ID of
        true ->
            Role1 = del_title_and_push(Role, TitleID),
            add_title(Role1, SwornInfo#sworn_info{num = 3, member = Members ++ [NewMember]});
        false ->
            {Role, SwornInfo#sworn_info{num = 3, member = Members ++ [NewMember]}}
    end,
    save(NewSwornInfo),
    log(add_member, NewSwornInfo),
    spawn(sworn, send_mail, [add_member_other, {Id, NewName}]),
    campaign_listener:handle(sworn, NewRole, Type),
    {ok, NewRole}.           
            
%% @doc 新成员加入对新成员的处理
do_add_member(Role = #role{id = Id, name = Name}, SwornInfo = #sworn_info{id = MemId, name = MemName, rank = MemR, member = Members, type = Type}) ->
    Member = #sworn_member{id = MemId, name = MemName, rank = MemR},
    {NewRole, NewSwornInfo} = add_title(Role, SwornInfo#sworn_info{id = Id, name = Name, rank = 3, member = Members ++ [Member] , num = 3, time = util:unixtime()}),
    save(NewSwornInfo),
    log(add_member, NewSwornInfo),
    spawn(sworn, send_mail, [add_member_new, NewSwornInfo]),
    campaign_listener:handle(sworn, NewRole, Type),
    {ok, NewRole}.

%% @doc 新成员加入对原有成员的处理
do_add_member(Role = #role{id = Id}, NewId, NewName) ->
    case ets:lookup(ets_role_sworn, Id) of
        [] -> {ok, Role};
        [SwornInfo = #sworn_info{member = Members, title_id = TitleID, type = Type}] ->
            NewMember = #sworn_member{id = NewId, name = NewName, rank = 3},
            {NewRole, NewSwornInfo} = case TitleID =:= ?SWORN_CUSTOM_TITLE_ID of
                true ->
                    Role1 = del_title_and_push(Role, TitleID),
                    add_title(Role1, SwornInfo#sworn_info{num = 3, member = [NewMember] ++ Members});
                false ->
                    {Role, SwornInfo#sworn_info{num = 3, member = [NewMember] ++ Members}}
            end,
            save(NewSwornInfo),
            log(add_member, NewSwornInfo),
            spawn(sworn, send_mail, [add_member_other, {Id, NewName}]),
            campaign_listener:handle(sworn, NewRole, Type),
            {ok, NewRole}
    end.

%% @doc 割袍断义中处理其他成员
del_member_other(Id, OutId, Num, Rank) ->
    case ets:lookup(ets_role_sworn, Id) of
        [] -> sworn_dao:save_del_member(OutId, Num, Rank, Id);
        [SwornInfo] ->
            NewSwornInfo = SwornInfo#sworn_info{out_member_id = OutId, rank = Rank},
            case role_api:lookup(by_id, Id) of
                {ok, _, #role{pid = Pid}} ->
                    role:apply(async, Pid, {fun do_del_member/3, [NewSwornInfo, OutId]});
                _ ->
                    del_member_offline(NewSwornInfo)
            end
    end.

del_member_offline(SwornInfo = #sworn_info{num = Num}) ->
    save_db(SwornInfo#sworn_info{num = Num - 1}).

%% @doc 处理割袍断义
%% 2人结拜，退出成员处理
do_del_member(Role, SwornInfo = #sworn_info{num = 2, id = Id}) ->
    spawn(sworn, send_mail, [del_member, SwornInfo]),
    Role1 = del_title_and_push(Role, ?SWORN_COMMON_TITLE_ID),
    NewRole = del_title_and_push(Role1, ?SWORN_CUSTOM_TITLE_ID),
    log(break, SwornInfo),
    del(Id),
    {ok, NewRole};
%% 3人结拜，退出成员处理
do_del_member(Role, SwornInfo = #sworn_info{num = 3, id = Id}) ->
    spawn(sworn, send_mail, [del_member, SwornInfo]),
    Role1 = del_title_and_push(Role, ?SWORN_COMMON_TITLE_ID),
    NewRole = del_title_and_push(Role1, ?SWORN_CUSTOM_TITLE_ID),
    log(break, SwornInfo),
    del(Id),
    {ok, NewRole}.
%% 2人结拜，其他成员处理
do_del_member(Role, SwornInfo = #sworn_info{num = 2, id = Id, member = Members}, OutId) ->
    #sworn_member{name = Name} = lists:keyfind(OutId, #sworn_member.id, Members),
    spawn(sworn, send_mail, [del_member_other_over, {Id, Name}]),
    Role1 = del_title_and_push(Role, ?SWORN_COMMON_TITLE_ID),
    NewRole = del_title_and_push(Role1, ?SWORN_CUSTOM_TITLE_ID),
    log(break, SwornInfo),
    del(Id),
    {ok, NewRole};
%% 3人结拜，其他成员处理
do_del_member(Role, SwornInfo = #sworn_info{num = 3, id = Id, rank = Rank, member = Members, title_id = TitleID}, OutId) ->
    OutMember = #sworn_member{name = Name} = lists:keyfind(OutId, #sworn_member.id, Members),
    spawn(sworn, send_mail, [del_member_other, {Id, Name}]),
    Role1 = del_title_and_push(Role, TitleID),
    Rank1 = case Rank =:= 1 of
        true -> 2;
        false -> 1
    end,
    [Member] = Members -- [OutMember],
    {NewRole, NewSwornInfo} = add_title(Role1, SwornInfo#sworn_info{num = 2, member = [Member#sworn_member{rank = Rank1}], out_member_id = {0, 0}}),
    save(NewSwornInfo),
    log(break, NewSwornInfo),
    {ok, NewRole}.

%% @doc 处理割袍断义后其他成员登录处理
handle_divorce_login(Role, SwornInfo = #sworn_info{num = 1, id = Id}) ->
    spawn(sworn, send_mail, [del_member_over, SwornInfo]),
    Role1 = del_title_no_push(Role, ?SWORN_COMMON_TITLE_ID),
    NewRole = del_title_no_push(Role1, ?SWORN_CUSTOM_TITLE_ID),
    log(break, SwornInfo),
    del(Id),
    NewRole;
handle_divorce_login(Role, SwornInfo = #sworn_info{num = 2, id = Id, rank = Rank, out_member_id = OutId, member = Members, title_id = TitleID}) ->
    OutMember = #sworn_member{name = Name} = lists:keyfind(OutId, #sworn_member.id, Members),
    spawn(sworn, send_mail, [del_member_other, {Id, Name}]),
    Role1 = del_title_no_push(Role, TitleID),
    Rank1 = case Rank =:= 1 of
        true -> 2;
        false -> 1
    end,
    [Member] = Members -- [OutMember],
    {NewRole, NewSwornInfo} = add_title(Role1, SwornInfo#sworn_info{member = [Member#sworn_member{rank = Rank1}], out_member_id = {0, 0}}),
    save(NewSwornInfo),
    log(break, NewSwornInfo),
    NewRole.

%% -------------------------------------------
%% 状态处理
%% -------------------------------------------
%% 空闲状态
idel(timeout, State = #sworn{is_swearing = ?false}) ->
    continue(idel, State#sworn{ts = now(), t_cd = ?SWORN_IDEL_TIMEOUT});  %% 无结拜进行，无限idel
idel(_Info, State) ->
    ?DEBUG("空闲阶段消息处理忽略: ~w", [_Info]),
    continue(idel, State).

%% 战斗状态
fight(timeout, State) ->
    continue(fight, State#sworn{ts = now(), t_cd = ?SWORN_FIGHTING});   %% 战斗进行中
fight(_Info, State) ->
    ?DEBUG("战斗阶段消息处理忽略: ~w", [_Info]),
    continue(fight, State).

%% 仪式状态
prepare(timeout, State) ->
    ?DEBUG("仪式开始"),
    handle_role_scene(ceremony, State),
    NewState = broad_cast_ceremony(State),
    bows(State),
    continue(ceremony, NewState#sworn{ts = now(), t_cd = ?SWORN_CEREMONY_TIMEOUT});
prepare(_Info, State) ->
    ?DEBUG("仪式阶段消息处理忽略: ~w", [_Info]),
    continue(prepare, State).

ceremony(timeout, State) ->
    ?DEBUG("结拜结束"),
    handle_scene(over, State),
    handle_role_scene(over, State),
    handle_over(State),
    {next_state, idel, #sworn{ts = now(), t_cd = ?SWORN_IDEL_TIMEOUT}};
ceremony(_Info, State) ->
    ?DEBUG("结束阶段消息处理忽略: ~w", [_Info]),
    continue(ceremony, State).

%% @doc 增加亲密度逻辑调用
add_intimacy({{Id, SrvId}, Pid}, {{ToId, ToSrvId}, ToPid}, Val) ->
    friend:add_intimacy(Pid, {ToId, ToSrvId, ?true}, Val, <<"结拜">>),
    friend:pack_send_intimacy(Pid, {ToId, ToSrvId}),
    friend:add_intimacy(ToPid, {Id, SrvId, ?false}, Val, <<"结拜">>),
    friend:pack_send_intimacy(ToPid, {Id, SrvId}).
