%%----------------------------------------------------
%% 角色相关接口
%%
%% @author yeahoo2000@gmail.com
%% @m wpf0208@jieyou.cn
%%----------------------------------------------------
-module(role_api).
-export([
        lookup/2
        ,lookup/3
        ,c_lookup/2
        ,c_lookup/3
        ,c_pack_send/3
        ,get_pid/1
        ,lookup_all_online/1
        ,local_lookup_all_online/1
        ,kick/3
        ,choose_career/2
        ,change_sex/1
        ,rename/2
        ,push_attr/1
        ,push_attr_no_fc/1
        ,push_attr/2
        ,push_assets/1
        ,push_assets/2
        ,check_fly_map/2
        ,check_fly/1
        ,login/1
        ,logout/1
        ,is_local_role/1
        ,is_name_used/1

        ,get_rand_career/0          %% 随机职业
        ,revive/1                   %% 复活
        ,set_ride/2                 %% 设置玩家的飞行状态
        ,trans_hook/3               %% 传送
        ,trans_hook/4               %% 传送

        ,fighter_group/1
        ,fighter_roleid_group/1

        ,pack_proto_msg/2
        ,pack_proto_10006/2
        ,reset_status/1
        ,bind_account/3
    ]
).

-include("common.hrl").
-include("role.hrl").
%%
-include("assets.hrl").
-include("vip.hrl").
-include("pos.hrl").
-include("node.hrl").
-include("attr.hrl").
-include("link.hrl").
-include("role_online.hrl").
-include("gain.hrl").
-include("team.hrl").
-include("guild.hrl").
-include("activity.hrl").
-include("pet.hrl").
-include("dungeon.hrl").
-include("map.hrl").
-include("channel.hrl").
-include("manor.hrl").

-define(REVIVE_TIME, 10000).

%% @spec lookup(Type, Name) -> {error, not_found} | {error, self_call} | {ok, record()}
%% Type = by_pid | by_name | by_id
%% Name = binary()
%% Id = int()
%% ReturnType = atom()
%% @doc 查询在线角色的完整属性(自动搜索所有节点)
%% @see lookup/3
lookup(by_pid, Pid) ->
    lookup(by_pid, Pid, to_role);
lookup(by_id, {Id, SrvId}) ->
    lookup(by_id, {Id, SrvId}, to_role);
lookup(by_name, Name) ->
    lookup(by_name, Name, to_role).

%% 跨服查询角色信息 返回值参考lookup/2
c_lookup(by_id, {Id, SrvId}) ->
    c_lookup(by_id, {Id, SrvId}, to_role).

%% 跨服发送信息
c_pack_send(RoleId = {_Id, SrvId}, Cmd, Data) ->
    case is_local_role(SrvId) of
        true ->
            role_group:pack_send(RoleId, Cmd, Data);
        false ->
            case center:is_cross_center() of
                true -> c_proxy:pack_send(RoleId, Cmd, Data);
                false ->
                    center:cast(c_proxy, pack_send, [RoleId, Cmd, Data])
            end
    end.

%% @spec is_name_used(Name) -> bool()
%% @doc 检查一个字符串是否是曾用名
is_name_used(Name) ->
    case ets:match(ets_role_name_used, #role_name_used{name = Name, id = '$1', _ = '_'}) of
        [_H | _T] -> true;
        _ -> false
    end.

%% @spec get_pid() -> undefined | pid()
get_pid({Id, SrvId}) ->
    global:whereis_name({role, Id, SrvId}).

%% @spec look_all_online(Type) -> {ok, List} | {error, Reason}
%% Type = by_pid
%% ReturnType = list()
%% @doc 查询所有在线角色(所有节点),返回所有玩家的Pid的列表
lookup_all_online(by_pid) ->
    do_lookup_all_online(sys_node_mgr:list(), by_pid, []).

%% @spec local_look_all_online(by_pid, List) -> {ok, List} | {error, Reason}
%% List = [[pid()] | ...]
%% @doc 查询本地节点在线角色的pid列表，注意返回值
local_lookup_all_online(by_pid) ->
    case ets:match(role_online, #role_online{pid = '$1', _ = '_'}) of
        {error, Reason} ->
            ?ERR("查询在线玩家pid列表出错~w", [Reason]);
        L -> {ok, L}
    end.

%% @spec lookup(Type, Id, ReturnType) -> {error, not_found} | {error, self_call} | {error, unknow_type} | {ok, Rtn}
%% Type = by_pid | by_id | by_name
%% Id = pid() | {integer(), bitstring()} | binary()
%% Node = node()
%% ReturnType = atom() | integer() | [integer()]
%% Rtn = #role{} | #fighter{} | #map_role{} | #team_member{} | record() | [term()] | term()
%% @doc 查询在线角色的属性(自动搜索所有节点)，支持直接返回特定类型的数据
%% <div>注意:在可以取得RolePid的情况下，一定要使用RolePid，因为这种方式最直接，性能最好</div>
%% <div>注意:在使用时尽可能返回最适合的record，大部份情况下是无需返回#role{}的，#role{}数据比较大，尽可能少用</div>
%% <div>示例:{ok, Event} = role_api:lookup(by_pid, RolePid, #role.event)</div>
%% <div>示例:{ok, [Event, Status]} = role_api:lookup(by_pid, RolePid, [#role.event, #role.status])</div>
%% <div>示例:{ok, Fighter} = role_api:lookup(by_name, <<"yeahoo">>, to_fighter)</div>
%% <div>注意:以上只是示例，真正使用时要case lookup的结果，因为不一定能找到的</div>
lookup(by_pid, Pid, ReturnType) when is_atom(ReturnType) ->
    case role:convert(ReturnType, Pid) of
        {ok, R} -> {ok, node(), R};
        {error, Reason} -> {error, Reason}
    end;
lookup(by_pid, Pid, ReturnType) ->
    case role:element(Pid, ReturnType) of
        {ok, R} -> {ok, node(), R};
        {error, Reason} -> {error, Reason}
    end;
lookup(by_id, {Id, SrvId}, ReturnType) when is_atom(ReturnType) ->
    case global:whereis_name({role, Id, SrvId}) of
        undefined -> {error, not_found};
        Pid ->
            case role:convert(ReturnType, Pid) of
                {ok, R} -> {ok, node(Pid), R};
                Else -> Else
            end
    end;
lookup(by_id, {Id, SrvId}, ReturnType) ->
    case global:whereis_name({role, Id, SrvId}) of
        undefined -> {error, not_found};
        Pid ->
            case role:element(Pid, ReturnType) of
                {ok, R} -> {ok, node(Pid), R};
                Else -> Else
            end
    end;
lookup(by_name, Name, ReturnType) ->
    case local_lookup(by_name, Name, ReturnType) of
        {ok, R} -> {ok, node(), R};
        {error, not_found} -> do_lookup(sys_node_mgr:list(exclude), by_name, Name, ReturnType);
        Err -> Err
    end.

%% 从所有服中查找某个角色的信息
%% 参数和返回值跟role_api:lookup/3相同
c_lookup(Type = by_pid, RolePid, ReturnType) ->
    case node(RolePid) =:= node() of
        true ->
            lookup(Type, RolePid, ReturnType);
        false ->
            case center:call(role_api, lookup, [Type, RolePid, ReturnType]) of
                {ok, Node, Rtn} -> {ok, Node, Rtn};
                {error, Reason} -> {error, Reason};
                _Err -> {error, not_found}
            end
    end;
c_lookup(Type, {Id, SrvId}, ReturnType) ->
    case is_local_role(SrvId) of
        true ->
            lookup(Type, {Id, SrvId}, ReturnType);
        false ->
            case center:is_cross_center() of
                true -> c_proxy:role_lookup(Type, {Id, SrvId}, ReturnType);
                false ->
                    case center:call(c_proxy, role_lookup, [Type, {Id, SrvId}, ReturnType]) of
                        {ok, Node, Rtn} -> {ok, Node, Rtn};
                        {error, Reason} -> {error, Reason};
                        _Err -> {error, not_found}
                    end
            end
    end.

%% @spec local_lookup(Type, Name, ReturnType) -> {error, not_found} | {error, self_call} | record() 
%% Type = by_name
%% Name = binary()
%% Id = int()
%% Role = #role{}
%% ReturnType = atom()
%% @doc 从本地节点查询在线角色的属性
local_lookup(by_name, Name, ReturnType) when is_atom(ReturnType) ->
    case ets:lookup(role_online, Name) of
        [#role_online{pid = Pid}] -> role:convert(ReturnType, Pid);
        _ -> {error, not_found}
    end;
local_lookup(by_name, Name, ReturnType) ->
    case ets:lookup(role_online, Name) of
        [#role_online{pid = Pid}] -> role:element(Pid, ReturnType);
        _ -> {error, not_found}
    end.

%% 执行查找
do_lookup([], _Type, _Id, _ReturnType) -> {error, not_found};
do_lookup([H | T], Type, {Id, SrvId}, ReturnType) ->
    case rpc:call(H#node.name, ?MODULE, local_lookup, [Type, {Id, SrvId}, ReturnType]) of
        {ok, Rtn} -> {ok, H#node.name, Rtn};
        _ -> do_lookup(T, Type, {Id, SrvId}, ReturnType)
    end.

%% @spec kick(Type, Id, Msg) -> ok | {error, self_call}
%% Type = by_pid | by_id | by_name
%% Id = pid() | {integer(), bitstring()} | bitstring()
%% Msg = bitstring()
%% @doc 将指定的角色踢下线
kick(by_id, {Id, SrvId}, Msg) ->
    case lookup(by_id, {Id, SrvId}, #role.pid) of
        {ok, _, Pid} -> kick(by_pid, Pid, Msg);
        E -> E
    end;
kick(by_name, Name, Msg) ->
    case lookup(by_name, Name, #role.pid) of
        {ok, _, Pid} -> kick(by_pid, Pid, Msg);
        E -> E
    end;
kick(by_pid, Pid, _Msg) when self() =:= Pid ->
    {error, self_call};
kick(by_pid, Pid, Msg) ->
    role:stop(sync, Pid, Msg),
    ok.

%% @spec login(Role) -> NewRole
%% @doc 玩家登录的触发调用函数
login(Role = #role{id = {Rid, SrvId}, login_info = LoginInfo}) ->
    Sql = <<"update role set is_online=1 where id = ~s and srv_id = ~s">>,
    db:send(Sql, [Rid, SrvId]), %% 2012/0709 暂时只提供平台查询
    Role#role{login_info = LoginInfo#login_info{login_time = util:unixtime()}};
login(Role) ->
    ?ERR("玩家登录检测错误：~w", [Role]),
    Role.

%% @spec logout(Role) -> NewRole
%% @doc 玩家登出的触发调用函数
logout(Role = #role{id = {Rid, SrvId}, login_info = LoginInfo}) ->
    %% TODO: 
    spawn(fun() ->
                Sql = <<"update role set is_online=0 where id = ~s and srv_id = ~s">>,
                db:execute(Sql, [Rid, SrvId]) %% 2012/0709 暂时只提供平台查询
        end),
    {ok, Role#role{login_info = LoginInfo#login_info{logout_time = util:unixtime()}}};
logout(Role) ->
    ?ERR("玩家登出检测错误：~w", [Role]),
    {ok, Role}.

%% @spec push_attr(Role) -> NewRole
%% NewRole = Role = #role{}
%% @doc 重新计算角色属性, 推送10005号,更新client
push_attr(Role = #role{link = #link{conn_pid = ConnPid}}) when is_pid(ConnPid) ->
    NewRole = role_attr:calc_attr(Role),
    % rank:listener(power, Role, NewRole),
    ToSend = pack_proto_10005(Role, NewRole),
    %% ?DEBUG("===========================  更新数据为: ~w~n", [ToSend]),
    sys_conn:pack_send(ConnPid, 10005, ToSend), %% 推送属性更新
    % medal:listener(fight_capacity, NewRole);
    NewRole;
push_attr(Role) ->
    Role.

push_attr_no_fc(Role = #role{attr = #attr{fight_capacity = FC}, link = #link{conn_pid = ConnPid}}) ->
    %%不推送战斗力
    Role2 = #role{attr = Attr} = role_attr:calc_attr(Role),
    Role3 = Role2#role{attr = Attr#attr{fight_capacity = FC}},
    ToSend = pack_proto_10005(Role, Role3),
    sys_conn:pack_send(ConnPid, 10005, ToSend), %% 推送属性更新
    Role3.

%% Attrs = [{?idx_hp, 100}]
%% -> any()
push_attr(ConnPid, Attrs) -> %% Attrs = [{?idx_hp, 100}]
    TermData = pack_proto_10005(Attrs),
    sys_conn:pack_send(ConnPid, 10005, TermData).

%% @spec push_assets(Role) -> NewRole
%% Role = tuple()
%% @doc 推送人物资产消息
push_assets(OldRole, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 10006, pack_proto_10006(OldRole, Role)),
    Role;
%% Assets = [{?asset_exp, 111}]
%% -> any()
push_assets(ConnPid, Assets) when is_list(Assets) ->
    sys_conn:pack_send(ConnPid, 10006, Assets). %% Assets = [{?asset_exp, 111}]

push_assets(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 10002, pack_proto_msg(10002, Role)),
    Role;
push_assets(Role) ->
    Role.


%% @spec check_fly(Role) -> true | {false, Msg}
%% @doc 检查是否可以切换飞行状态
check_fly(#role{action = ?action_sit}) ->
    {false, ?MSGID(<<"打坐状态中，无法飞行">>)};
check_fly(#role{action = Action})
when Action >= ?action_sit_both andalso  Action =< ?action_sit_lovers ->
    {false, ?MSGID(<<"双修状态中，无法飞行">>)};
check_fly(#role{action = ?action_ride_both}) ->
    {false, ?MSGID(<<"双人骑乘中，无法飞行">>)};
check_fly(#role{event = ?event_arena_match}) ->
    {false, ?MSGID(<<"竞技场中，不允许飞行">>)};
check_fly(#role{event = ?event_arena_prepare}) ->
    {false, ?MSGID(<<"竞技场中，不允许飞行">>)};
check_fly(#role{event = ?event_top_fight_match}) ->
    {false, ?MSGID(<<"竞技场中，不允许飞行">>)};
check_fly(#role{event = ?event_top_fight_prepare}) ->
    {false, ?MSGID(<<"竞技场中，不允许飞行">>)};
check_fly(#role{event = ?event_dungeon, ride = ?ride_fly, pos = #pos{map_base_id = 20008}}) ->
    {false, ?MSGID(<<"飞行副本中，不允许降落">>)};
check_fly(#role{event = ?event_dungeon, pos = #pos{map_base_id = MapBaseId}}) when MapBaseId =/= 20008 ->
    {false, ?MSGID(<<"副本场景中，不允许飞行">>)};
check_fly(#role{event = ?event_escort}) ->
    {false, ?MSGID(<<"您正在护送中，无法切换飞行状态">>)};
check_fly(#role{event = ?event_escort_child}) ->
    {false, ?MSGID(<<"您正在护送中，无法切换飞行状态">>)};
check_fly(#role{event = ?event_guild_war}) ->
    {false, ?MSGID(<<"帮战活动中，不允许飞行">>)};
check_fly(#role{event = ?event_guild_arena}) ->
    {false, ?MSGID(<<"帮战活动中，不允许飞行">>)};
check_fly(#role{event = ?event_hall}) ->
    {false, ?MSGID(<<"您在房间中，暂时不能飞来飞去">>)};
check_fly(#role{event = ?event_cross_king_prepare}) ->
    {false, ?MSGID(<<"您在至尊比赛中，暂时不能飞来飞去">>)};
check_fly(#role{event = ?event_cross_king_match}) ->
    {false, ?MSGID(<<"您在至尊比赛中，暂时不能飞来飞去">>)};
check_fly(#role{event = ?event_guard_counter}) ->
    {false, ?MSGID(<<"您在洛水反击中，暂时不能飞来飞去">>)};
check_fly(#role{event = ?event_cross_ore}) ->
    {false, ?MSGID(<<"跨服仙府争夺战中，昆仑仙府不能选择飞行状态">>)};
check_fly(#role{event = ?event_jiebai}) ->
    {false, ?MSGID(<<"举行结拜中，不允许飞行">>)};
check_fly(#role{team_pid = TeamPid, team = #role_team{follow = ?true, is_leader = ?false}})
when is_pid(TeamPid) ->
    {false, ?MSGID(<<"跟随队长中，暂时不能选择飞行状态">>)};
check_fly(#role{team_pid = TeamPid, team = #role_team{is_leader = ?true, event = ?event_escort}})
when is_pid(TeamPid) ->
    {false, ?MSGID(<<"您的队伍处于护送活动中，暂时不能选择飞行状态">>)};
check_fly(_) ->
    true.

%% @spec check_fly_map(Role, {MapBase, X, Y}) -> {NewX, NewY}
%% Role = NewRole = #role{}
%% MapBase = X = Y = integer() 地图信息
%% @doc 登陆检查角色是否可以飞行，判断当前所在位置是否合法，返回新的合法位置
check_fly_map(Role, {MapBaseId, X, Y}) ->
    case fly_api:check_can_fly(Role) of
        true -> %% 可以飞行
            {X, Y};
        false ->
            case map_mgr:is_blocked(MapBaseId, X, Y) of
                true -> %% 不可行走区域
                    case map:get_revive(MapBaseId) of
                        {ok, {Dx, Dy}} ->
                            {Dx, Dy};
                        _ ->
                            ?ERR("玩家[NAME:~s]上线检测，未找到复活点[MAP:~w]", [MapBaseId]),
                            {X, Y}
                    end;
                _ -> {X, Y}
            end
    end.

choose_career(Choose, Role = #role{sex = Sex, vip = Vip}) ->
    %% ***********
    FaceId = vip:get_face_id(Choose, Sex),
    NR = Role#role{career = Choose, vip = Vip#vip{portrait_id = FaceId}},
    NR1 = skill:transfer_career(NR),
    NR3 = role_listener:special_event(NR1, {1001, finish}),
    %% ***********
    NewRole = role_api:push_attr(NR3),
    map:role_update(NewRole),
    NewRole.

%% @spec change_sex(Role) -> NewRole
%% @doc 改变性别信息
change_sex(Role = #role{id = {Id, SrvId}, name = Name, sex = Sex, career = Career, link = #link{conn_pid = ConnPid}}) ->
    LossList = [#loss{label = item, val = [33052, 1, 1], msg = ?L(<<"背包没有阴阳造化丹">>)}],
    case role_gain:do(LossList, Role) of
        {false, #loss{msg = Msg}} ->
            {false, Msg};
        {ok, NewRole} ->
            NewSex = case Sex of
                ?male -> ?female;
                ?female -> ?male
            end,
            sys_conn:pack_send(ConnPid, 10004, {Id, SrvId, Name, NewSex, vip:get_face_id(Career, NewSex)}),
            NewRole1 = role_listener:sex(NewRole#role{sex = NewSex}),
            NewRole2 = looks:calc(NewRole1),
            map:role_update(NewRole2),
            {ok, NewRole2}
    end.

%% @spec rename(Role, NewName) -> NewRole
%% Role = NewRole = #role{}
%% NewName = bitstring()
%% @doc 角色改名
rename(#role{name_used = NameUsed}, _) when NameUsed =/= <<>> ->
    {false, ?L(<<"您已经改过名字了">>)};
rename(#role{event = Event}, _NewName) when Event =/= ?event_no andalso Event =/= ?event_guild ->
    {false, ?L(<<"当前状态不能改名">>)};
rename(Role = #role{name = OldName, id = {Id, SrvId}}, NewName) ->
    case is_name_used(NewName) of
        true ->
            {false, ?MSGID(<<"角色名已经存在">>)};
        _ ->
            case db:get_one("select count(*) from role where name = ~s", [NewName]) of
                {error, _Err} ->
                    {false, ?MSGID(<<"访问数据库时发生异常，请稍后再重试">>)};
                {ok, Num} when Num >= 1 -> %% 已经存在同名的角色
                    {false, ?MSGID(<<"角色名已经存在">>)};
                {ok, _} ->
                    case role_gain:do([#loss{label = item, val = [33232, 1, 1]}], Role) of
                        {ok, Role1} ->
                            NewRole = Role1#role{name = NewName, name_used = OldName},
                            case role_data:save_name_used(NewRole) of
                                true ->
                                    map:role_update(NewRole),
                                    friend:update_role_name(NewRole),
                                    role_group:leave(all, Role),
                                    role_group:join(all, NewRole),
                                    notice:send(52, util:fbin(?L(<<"~s玩家，耗了九牛二虎之力终于拿到改名卡，成功将名字修改为~s。从此，~s改名为~s">>), [OldName, NewName, OldName, notice:role_to_msg({Id, SrvId, NewName})])),
                                    {ok, NewRole};
                                _ ->
                                    {false, ?L(<<"改名失败">>)}
                            end;
                        _ ->
                            {false, ?L(<<"没有改名符">>)}
                    end
            end
    end.


%% @spec trans_hook(Type, ToPos, DefMsg, Role) -> {ok, NewRole} | {false, Msg}
%% @spec trans_hook(Type, ToPos, Role) -> {ok, NewRole} | {false, Msg}
%% Type = {normal, vip | item | gold} | free | ...
%% 飞鞋传送 | 免费传送
%% ToPos = {MapId, X, Y}
%% @doc 传送
%% <div> 
%% 内部包含状态检测 和 消息的推送(需要role:send_buff_begin()回滚操作):
%% 竞技、副本、交易、护送、帮会场景、温泉
%% 其他条件需要外部自己判断
%% </div>
trans_hook(Type, ToPos, DefMsg, Role) ->
    case trans_hook(Type, ToPos, Role) of
        {false, _} -> {false, DefMsg};
        Ret -> Ret
    end.
trans_hook(Type, ToPos, Role) ->
    case check_trans(Type, ToPos, Role) of
        true -> trans_hook1(Type, ToPos, Role);
        {true, NewToPos} -> trans_hook1(Type, NewToPos, Role);
        {false, Msg} -> {false, Msg};
        _ -> {false, ?MSGID(<<"传送异常, 请选择其他方式或报告GM">>)}
    end.
trans_hook1(_Type, _ToPos, #role{team_pid = TeamPid, team = #role_team{is_leader = ?false, follow = ?true}})
when is_pid(TeamPid) -> %% 队员队伍中
    {false, ?MSGID(<<"组队中，不能使用飞仙传送">>)};
trans_hook1(Type, ToPos, Role = #role{team_pid = TeamPid, team = #role_team{is_leader = ?false, follow = ?false}})
when is_pid(TeamPid) -> %% 暂离队员
    do_trans_hook(Type, ToPos, Role);
trans_hook1(Type, ToPos, Role = #role{team_pid = TeamPid, id = Rid, team = #role_team{is_leader = ?true}})
when is_pid(TeamPid) -> %% 队长
    case team_api:get_team_info(Role) of
        {ok, #team{leader = #team_member{id = Rid}, member = []}} ->
            do_trans_hook(Type, ToPos, Role);
        {ok, #team{leader = #team_member{id = Rid}, member = [#team_member{mode = Mode}]}} when Mode =/= ?MODE_NORMAL ->
            do_trans_hook(Type, ToPos, Role);
        {ok, #team{leader = #team_member{id = Rid}, member = [#team_member{mode = Mode1}, #team_member{mode = Mode2}]}}
        when Mode1 =/= ?MODE_NORMAL andalso Mode2 =/= ?MODE_NORMAL ->
            do_trans_hook(Type, ToPos, Role);
        {ok, #team{leader = #team_member{id = Rid}}} ->
            {false, ?MSGID(<<"组队中，不能使用飞仙传送">>)};
        _ ->
            do_trans_hook(Type, ToPos, Role)
    end;
trans_hook1(Type, ToPos, Role) ->
    do_trans_hook(Type, ToPos, Role).

%% @spec revive(Role) -> NewRole
%% @doc 复活处理
revive(Role = #role{hp_max = HpMax, mp_max = MpMax}) ->
    NewRole = role_api:push_attr(Role#role{hp = HpMax, mp = MpMax, status = ?status_normal}),
    map:role_update(NewRole),
    NewRole.

%% @spec set_ride(Role, Ride) -> NewRole
%% NewRole = Role = #role{}
%% Ride = 0 | 1
%% @doc 设置角色的飞行状态，内部会根据是否队长同步到对应的队伍进程
%% <div>
%% 一般用于过场景对于飞行状态有要求改变时调用；内部不包括场景更新
%% </div>
set_ride(Role = #role{ride = Ride}, Ride) -> Role;
set_ride(Role = #role{team = #role_team{is_leader = ?true}}, Ride)
when Ride =:= ?ride_no orelse Ride =:= ?ride_fly ->
    NewRole = Role#role{ride = Ride},
    team:set_ride(NewRole),
    NewRole;
set_ride(Role, Ride) ->
    NewRole = Role#role{ride = Ride},
    NewRole.

%% @spec get_rand_career() -> Career::integer()
%% @doc 随机一个职业
get_rand_career() ->
    util:rand(1, 5).

%% @spec fighter_group(Role) -> FighterList
%% Role = #role{}
%% FighterList = [#fighter{}]
%% @doc 获取参战者列表，FighterList中的第一个为战斗发起者
%%远征王军把其它人拉进来打
fighter_group(Role = #role{event = ?event_dungeon, event_pid = EventPid, dungeon_ext = #dungeon_ext{type = ?dungeon_type_expedition}}) when is_pid(EventPid) ->
    Roles = dungeon:get_online_roles(EventPid),
    to_fighter(Roles, Role, []);
%% 单人情况
fighter_group(Role) ->
    {ok, F} = role_convert:do(to_fighter, Role),
    [F].


%% @spec fighter_roleid_group(Role) -> RoleIdList
%% Role = #role{}
%% RoleIdList = [{Rid, SrvId}]
%% @doc 获取组队或者单人情况下的角色id列表

%% 组队情况:
fighter_roleid_group(#role{id = RoleId1, team_pid = TeamPid}) when is_pid(TeamPid) ->
    case team:get_team_info(TeamPid) of
        {ok, #team{leader = #team_member{id = RoleId1}, member = Members}} ->
            ?DEBUG("队长发起战斗"),
            MemberRoleIds = [RoleId || #team_member{id = RoleId, mode = ?MODE_NORMAL} <- Members],
            [RoleId1|MemberRoleIds];
        {ok, #team{leader = #team_member{id = LeaderRoleId}, member = Members}} ->
            case lists:keyfind(RoleId1, #team_member.id, Members) of
                #team_member{mode = ?MODE_NORMAL} -> 
                    MemberRoleIds = [RoleId || #team_member{id = RoleId, mode = ?MODE_NORMAL} <- Members],
                    [LeaderRoleId|MemberRoleIds];
                #team_member{mode = ?MODE_TEMPOUT} -> 
                    ?DEBUG("对方是队员，但是暂离，所以单独对他发起切磋请求"),
                    [RoleId1];
                false -> 
                    ?ERR("对方既有组队但是又找不到其信息"),
                    []
            end;
        _Err ->
            ?ERR("获取队伍信息发生异常:~w", [_Err]),
            []
    end;
%% 单人情况
fighter_roleid_group(#role{id = RoleId}) ->
    [RoleId].

%% @spec pack_proto_msg(Cmd::integer(), Role) -> tuple()
%% @doc 返回协议消息

%% 返回10000号
pack_proto_msg(10000, Role = #role{
        id = {Id, SrvId}, name = Name, label = _Lab, sex = Sex, career = Career, realm = _Realm, lev = Lev, soul_lev = _SoulLev,
        mod = {Mod, _}, speed = Speed, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, assets = Asts, vip = Vip, attr = Attr, guild = Guild,
        ascend = _Ascend, pos = Pos, looks = Looks, special = Special}) when is_record(Role, role) ->
    #assets{exp = Exp} = Asts,
    #vip{type = Vtype, portrait_id = FaceId} = Vip,
    #attr{js = Js, 
        aspd = Aspd, dmg_magic = DmgMag, dmg_min = DmgMin, dmg_max = DmgMax, defence = Def, hitrate = Hit, evasion = Eva, 
        critrate = Crit, tenacity = Ten, resist_metal = RstM, resist_wood = _RstW, resist_water = _RstWa, 
        resist_fire = _RstF, resist_earth = _RstE, dmg_wuxing = _DmgWx, anti_stun = _AntiStun, anti_taunt = _AntiTaunt,
        anti_silent = _AntiSil, anti_sleep = _AntiSleep, anti_stone = _AntiStone,anti_poison = _AntiPoison, anti_seal = _AntiSeal,
        fight_capacity = FC} = Attr,
    #role_guild{name = GuildName} = Guild,
    #pos{x= Pos_X, y = Pos_Y, dir = Dir} = Pos,
    %% AscendType = ascend:get_ascend(Career, Ascend),
    %% ?DEBUG("待发送属性[NAME:~s, Lev:~w, ATTR:~w, Assets:~w]", [Name, Lev, Attr, Asts]),
    %% {Id, SrvId, Name, Lev, SoulLev, Career, Career2, AscendType, Realm, FaceId, Sex, Mod, Lab, Vtype, GuildName, Exp, role_exp_data:get(Lev), Hp, Mp, HpMax, MpMax, DmgMin, DmgMax, DmgMag, Def, Eva, Hit, Crit, Ten, Js, Aspd, RstM, RstW, RstWa, RstF, RstE, DmgWx, AntiStun, AntiTaunt, AntiSil, AntiSleep, AntiStone, AntiPoison, AntiSeal, FC, Speed, Pos_X, Pos_Y, Looks, Special};
    %% ?DEBUG("************** 10000号  绝对伤害: ~w， 防：~w", [DmgMag, Def]),
    {Id, SrvId, Name, Lev, Career, FaceId, Sex, Mod, Vtype, GuildName, Exp, role_exp_data:get(Lev), Hp, Mp, HpMax, MpMax, DmgMin, DmgMax, 
        DmgMag, Def, Eva, Hit, Crit, Ten, Js, Aspd, RstM, FC, Speed, Dir, Pos_X, Pos_Y, Looks, Special};

%% 返回10010号
pack_proto_msg(10010, #role{
        id = {Id, SrvId}, name = Name, label = _Lab, sex = Sex, career = Career, lev = Lev, soul_lev = _SoulLev, hp = Hp, mp = Mp,
        hp_max = HpMax, mp_max = MpMax, assets = Asts, vip = Vip, attr = Attrs, guild = Guild, activity = Activity, pet = PetBag, ascend = _Ascend
        ,channels = #channels{list = Channels}, eqm = Eqm, manor_moyao = #manor_moyao{ has_eat_yao = HasEat}, looks = Looks
    }) ->
    #assets{
        psychic = _Psc, attainment = Atm,
        charm = _Charm, flower = _Flower} = Asts,
    #vip{type = Vtype, portrait_id = FaceId} = Vip,
    #attr{
        js = Js,
        aspd = Aspd, dmg_magic = DmgMag, dmg_min = DmgMin, dmg_max = DmgMax, defence = Def, hitrate = Hit, evasion = Eva, 
        critrate = Crit, tenacity = Ten, resist_metal = RstM, resist_wood = _RstW, resist_water = _RstWa, 
        resist_fire = _RstF, resist_earth = _RstE, dmg_wuxing = _DmgWx, anti_stun = _AntiStun, anti_taunt = _AntiTaunt,
        anti_silent = _AntiSil, anti_sleep = _AntiSleep, anti_stone = _AntiStone,anti_poison = _AntiPoison, anti_seal = _AntiSeal,
        fight_capacity = FC} = Attrs,
    #role_guild{name = GuildName} = Guild,
    #activity{summary = Summary, sum_limit = SumLimit} = Activity,
    PetFC = case PetBag of
        #pet_bag{active = #pet{fight_capacity = Vpetfc}} -> Vpetfc;
        _ -> 0
    end,
     {Id, SrvId, Name, Lev, Career, FaceId, Sex, 
        Atm, Summary, SumLimit, Vtype, GuildName,
        Hp, Mp, HpMax, MpMax, DmgMin, DmgMax, DmgMag, 
        Def, Eva, Hit, Crit, Ten,
        Js, Aspd, RstM, FC, PetFC, Channels, Eqm, HasEat, Looks
    };

%% 返回资产10002
pack_proto_msg(10002, #role{lev = Lev, soul_lev = _SoulLev, assets = #assets{exp = Exp, coin = Coin, gold = Gold,
            gold_bind = GoldBind, psychic = _Psy, energy = Energy, attainment = Attainment, prestige = _Prestige, hearsay = _Hearsay,
            charm = _Charm, flower = _Flower, gold_integral = _GoldIntegral, arena = _Arena, career_devote = _CareerDevote, charge = _Charge, guild_war = _GuildWar, lilian = _Lilian, seal_exp = _SealExp, soul = _Soul,
            stone = Stone, badge = Badge, honor = Honor}}) ->
    {Lev, role_exp_data:get(Lev), Exp, GoldBind, Coin, Gold, Energy, Attainment, Stone, Badge, Honor};
%% 返回属性10003
pack_proto_msg(10003, #role{
        hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax,
        attr = #attr{
            dmg_magic = _DmgMag, dmg_min = DmgMin, dmg_max = DmgMax, defence = Def, evasion = Eva, hitrate = Hit,
            critrate = Crit, tenacity = _Ten, js = Js, aspd = Aspd, resist_metal = Rm, resist_wood = _Rwo,
            resist_water = _Rwa, resist_fire = _Rf, resist_earth = _Re, dmg_wuxing = _DmgWx,
            anti_stun = _AntiStun, anti_taunt = _AntiTaunt, anti_silent = _AntiSil, anti_sleep = _AntiSleep,
            anti_stone = _AntiStone,anti_poison = _AntiPoison, anti_seal = _AntiSeal, fight_capacity = FC
        }}) ->
%%    {Hp, Mp, HpMax, MpMax, DmgMin, DmgMax, DmgMag, Def, Eva, Hit, Crit, Ten, Js, Aspd, Rm, Rwo,
%%        Rwa, Rf, Re, DmgWx, AntiStun, AntiTaunt, AntiSil, AntiSleep, AntiStone, AntiPoison, AntiSeal, FC};
    {Hp, Mp, HpMax, MpMax, DmgMin, DmgMax, Def, Eva, Hit, Crit, Js, Aspd, Rm, FC};
pack_proto_msg(Cmd, _R) ->
    {error, Cmd}.


%% resist_earth-19, dmg_wuxing-20, anti_stun-21, 
%%
pack_proto_10005(#role{%% 旧ROLE
        hp = Hp1, mp = Mp1, hp_max = HpMax1, mp_max = MpMax1,
        attr = #attr{ 
            dmg_magic = DmgMag1, dmg_min = DmgMin1, dmg_max = DmgMax1, defence = Def1, evasion = Eva1, hitrate = Hit1,
            critrate = Crit1, tenacity = Ten1, js = Js1, aspd = Aspd1, resist_metal = Rm1, resist_wood = Rwo1,
            resist_water = Rwa1, resist_fire = Rf1, resist_earth = Re1, dmg_wuxing = DmgWx1,
            anti_stun = AntiStun1, anti_taunt = AntiTaunt1, anti_silent = AntiSil1, anti_sleep = AntiSleep1,
            anti_stone = AntiStone1,anti_poison = AntiPoison1, anti_seal = AntiSeal1, fight_capacity = FC1
        }},
    #role{ 
        hp = Hp2, mp = Mp2, hp_max = HpMax2, mp_max = MpMax2, attr = 
        #attr{dmg_magic = DmgMag2, dmg_min = DmgMin2, dmg_max = DmgMax2, defence = Def2, evasion = Eva2, hitrate = Hit2,
            critrate = Crit2, tenacity = Ten2, js = Js2, aspd = Aspd2, resist_metal = Rm2, resist_wood = Rwo2,
            resist_water = Rwa2, resist_fire = Rf2, resist_earth = Re2, dmg_wuxing = DmgWx2,
            anti_stun = AntiStun2, anti_taunt = AntiTaunt2, anti_silent = AntiSil2, anti_sleep = AntiSleep2,
            anti_stone = AntiStone2,anti_poison = AntiPoison2, anti_seal = AntiSeal2, fight_capacity = FC2
        }} ) ->

    NeedUpdate =
    [{?idx_hp, Hp2}, {?idx_mp,Mp2}, {?idx_hp_max, HpMax2}, {?idx_mp_max,MpMax2}, {?idx_dmg_magic,DmgMag2}, {?idx_dmg_min,DmgMin2}, {?idx_dmg_max,DmgMax2},
         {?idx_defence, Def2}, {?idx_evasion,Eva2}, {?idx_hitrate,Hit2}, {?idx_critrate,Crit2},
        {?idx_tenacity,Ten2}, {?idx_js, Js2}, {?idx_aspd,Aspd2}, {?idx_resist_metal,Rm2}, {?idx_resist_wood, Rwo2},
        {?idx_resist_water, Rwa2}, {?idx_resist_fire, Rf2}, {?idx_resist_earth, Re2}, {?idx_dmg_wuxing, DmgWx2}, 
        {?idx_anti_stun, AntiStun2}, {?idx_anti_taunt, AntiTaunt2}, {?idx_anti_seal,AntiSil2}, {?idx_anti_sleep,AntiSleep2},
        {?idx_anti_stone, AntiStone2}, {?idx_anti_poison, AntiPoison2}, {?idx_anti_seal, AntiSeal2}, {?idx_fight_capacity, FC2}]
        --
    [{?idx_hp, Hp1}, {?idx_mp,Mp1}, {?idx_hp_max, HpMax1}, {?idx_mp_max,MpMax1}, {?idx_dmg_magic,DmgMag1}, {?idx_dmg_min,DmgMin1}, {?idx_dmg_max,DmgMax1},
         {?idx_defence, Def1}, {?idx_evasion,Eva1}, {?idx_hitrate,Hit1}, {?idx_critrate,Crit1},
        {?idx_tenacity,Ten1}, {?idx_js, Js1}, {?idx_aspd,Aspd1}, {?idx_resist_metal,Rm1}, {?idx_resist_wood, Rwo1},
        {?idx_resist_water, Rwa1}, {?idx_resist_fire, Rf1}, {?idx_resist_earth, Re1}, {?idx_dmg_wuxing, DmgWx1}, 
        {?idx_anti_stun, AntiStun1}, {?idx_anti_taunt, AntiTaunt1}, {?idx_anti_seal,AntiSil1}, {?idx_anti_sleep,AntiSleep1},
        {?idx_anti_stone, AntiStone1}, {?idx_anti_poison, AntiPoison1}, {?idx_anti_seal, AntiSeal1}, {?idx_fight_capacity, FC1}],
        %% ?DEBUG("----------->>> 要更新D  ~p~n", [NeedUpdate]),
        %% ?DEBUG("======================= 计算后绝对伤害:~w, 防：~w", [DmgMag2, Def2]),
        MapNum = get_map_number(NeedUpdate),
        Attrs = [Val || {_Idx, Val} <- NeedUpdate],
        {MapNum, Attrs}.

pack_proto_10005(Attrs) -> %% Attrs = [{?idx_hp, 111}]
    lists:foldr(fun({Key, Val}, {AccKey, AccVal})->
            {(1 bsl (Key)) bor AccKey, [Val|AccVal]}
    end, {0, []}, Attrs).

%% 返回资产10006
pack_proto_10006(#role{lev = Lev1, assets = #assets{exp = Exp1, coin = Coin1, gold = Gold1,
            gold_bind = GoldBind1, energy = Energy1, attainment = Attainment1,
            stone = Stone1, badge = Badge1, honor = Honor1},vip = #vip{type = Vip1}},
        #role{lev = Lev2, assets = #assets{exp = Exp2, coin = Coin2, gold = Gold2,
            gold_bind = GoldBind2, energy = Energy2, attainment = Attainment2,
            stone = Stone2, badge = Badge2, honor = Honor2},vip = #vip{type = Vip2}}
) ->
    UpdateList = [{?asset_lev, Lev2}, {?asset_exp_need, role_exp_data:get(Lev2)}, {?asset_exp, Exp2},
        {?asset_gold_bind, GoldBind2}, {?asset_coin, Coin2}, {?asset_gold, Gold2},
        {?asset_energy, Energy2}, {?asset_attainment, Attainment2}, {?asset_stone, Stone2},
        {?asset_vip, Vip2}, {?asset_badge, Badge2}, {?asset_honor, Honor2}] --
                [{?asset_lev, Lev1}, {?asset_exp_need, role_exp_data:get(Lev1)}, {?asset_exp, Exp1},
        {?asset_gold_bind, GoldBind1}, {?asset_coin, Coin1}, {?asset_gold, Gold1},
        {?asset_energy, Energy1}, {?asset_attainment, Attainment1}, {?asset_stone, Stone1},
        {?asset_vip, Vip1}, {?asset_badge, Badge1}, {?asset_honor, Honor1}],
    %% ?DEBUG("更新资产数据为: ~p~n", [UpdateList]),
    {UpdateList}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 根据索引，求出对应的32位整数
%% AttrList = [idx, Val]
%% get_map_number = int
get_map_number(AttrList) ->
    F = fun({Idx, _Val}, Sum) -> N = round(math:pow(2, Idx)), Sum+N end,
    lists:foldl(F, 0, AttrList).

%% 查找
do_lookup_all_online([], by_pid, ReturnList) -> {ok, ReturnList};
do_lookup_all_online([H | T], by_pid, ReturnList) ->
    case rpc:call(H#node.name, ?MODULE, local_lookup_all_online, [by_pid]) of
        {ok, Rtn} -> do_lookup_all_online(T, by_pid, Rtn ++ ReturnList);
        {error, Reason} -> {error, Reason}
    end.

%% 转换成战斗者数据结构，必须保证第一个为战斗发起者
to_fighter([], _, L) ->
    lists:reverse(L);
to_fighter([{_, Pid} | T], Role = #role{pid = RolePid}, L) when Pid =:= RolePid ->
    {ok, F} = role_convert:do(to_fighter, Role), %% 当前进程内转换
    to_fighter(T, Role, [F | L]);
to_fighter([{Rid, Pid} | T], Role, L) ->
    case node(Pid) =:= node() of
        true -> %% 本服
            %% 同步转换
            case role:apply(sync, Pid, {fun sync_to_fighter/1, []}) of
                {ok, F} ->
                    to_fighter(T, Role, [F | L]);
                _ -> 
                    to_fighter(T, Role, L)
            end;
        false -> %% 跨服
            case role_api:c_lookup(by_id, Rid, to_fighter) of
                {ok, _, CF} ->
                    to_fighter(T, Role, [CF | L]);
                _ ->
                    to_fighter(T, Role, L)
            end
    end;
to_fighter([_ | T], Role, L) ->
    to_fighter(T, Role, L).

%% 同步转换角色的战斗数据
%% 返回{ok, {ok, Role}}
sync_to_fighter(Role) ->
    %% ?DEBUG("同步转换[NAME:~s]", [Role#role.name]),
    {ok, role_convert:do(to_fighter, Role)}.

%% 检测是否可以使用飞鞋传送
check_trans(_, _, #role{status = ?status_fight}) ->
    {false, <<"">>};
check_trans(_, _, #role{status = ?status_die}) ->
    {false, <<"">>};
check_trans(_, _, #role{event = ?event_arena_match}) ->
    {false, ?L(<<"竞技中，不能使用飞仙传送">>)}; %% 竞技
check_trans(_, _, #role{event = ?event_arena_prepare}) ->
    {false, ?L(<<"竞技中，不能使用飞仙传送">>)};
check_trans(_, _, #role{event = ?event_top_fight_match}) ->
    {false, ?L(<<"竞技中，不能使用飞仙传送">>)}; %% 巅峰对决
check_trans(_, _, #role{event = ?event_top_fight_prepare}) ->
    {false, ?L(<<"竞技中，不能使用飞仙传送">>)};
check_trans(_, _, #role{event = ?event_trade}) ->
    {false, ?L(<<"跑商中，不能使用飞仙传送">>)}; %% 跑商
check_trans(_, _, #role{event = ?event_escort}) ->
    {false, ?L(<<"护送中，不能使用飞仙传送">>)}; %% 护送
check_trans(_, _, #role{event = ?event_escort_child}) ->
    {false, ?L(<<"护送中，不能使用飞仙传送">>)}; %% 护送小孩
check_trans(_, _, #role{event = ?event_dungeon}) ->
    {false, ?L(<<"副本中，不能使用飞仙传送">>)}; %% 副本
check_trans(_, {MapBaseId, _, _}, #role{event = ?event_guild})
when MapBaseId =:= 31001 orelse MapBaseId =:= 31002 ->
    true;       %% 帮会领地内可以使用小飞鞋
check_trans(_, {MapBaseId, _, _}, #role{event = ?event_guild})
when MapBaseId < 20000 -> %% 帮会领地传送出去，限制几个主要地图
    true;
check_trans(_, {MapBaseId, X, Y}, #role{event = ?event_guild_war, team = #role_team{is_leader = ?false, follow = ?false},
        pos = #pos{map = MapId, map_base_id = MapBaseId}}) -> %% 帮战同地图内允许队员传送-2012/04/24
    {true, {MapId, X, Y}};
check_trans(_, {36031, X, Y}, #role{event = ?event_no, cross_srv_id = <<"center">>, pos = #pos{map = 36031}}) ->
    {true, {36031, X, Y}}; %% 圣城
check_trans(_, _, #role{cross_srv_id = CrossSrvId}) when CrossSrvId =/= <<>> ->
    {false, ?L(<<"跨服活动场景中，不能使用飞仙传送">>)};
%% ------------------
%% TODO: event状态如果此处不屏蔽，则要在飞离一个活动地图时，将活动状态恢复为正常
check_trans(_, {MapId, _, _}, _Role) when MapId >= 20000 ->
    {false, ?L(<<"目标地图不支持飞仙传送">>)};
check_trans(_, _, #role{event = ?event_no}) ->
    true;
check_trans(_, _To, #role{event = _Event, team = _Team, pos = _Pos}) ->
    ?DEBUG("TO:~w, Event:~w, Team:~w, Pos:~w", [_To, _Event, _Team, _Pos]),
    {false, ?L(<<"活动中不能使用飞仙传送">>)}.

%% 根据传送类型，消耗并传送
%% 其中帮会领地的状态处理，很特殊
do_trans_hook(Type, ToPos = {MapBaseId, _, _}, Role = #role{event = ?event_guild})
when MapBaseId < 20000 -> %% 领地外传送
    NewRole = guild_area:moved(Role),
    do_trans_hook(Type, ToPos, NewRole#role{event = ?event_no});
do_trans_hook(Type, {MapBaseId, X, Y}, Role = #role{event = ?event_guild, pos = #pos{map = MapId}})
when MapBaseId =:= 31001 orelse MapBaseId =:= 31002 -> %% 领地内传送
    do_trans_hook(Type, {MapId, X, Y}, Role);
do_trans_hook({normal, vip}, ToPos, Role) ->
    case vip:use(fly_sign, Role) of
        false -> {false, ?MSGID(<<"您的VIP免费传送次数已使用完">>)};
        {ok, NewRole} ->
            vip:push_assets(NewRole),
            do_trans(ToPos, NewRole)
    end;
do_trans_hook({normal, item}, ToPos, Role) ->
    LossList = [#loss{label = item, val = [33011, 0, 1], msg = ?L(<<"背包没有幻影靴">>)}],
    case role_gain:do(LossList, Role) of
        {false, #loss{msg = Msg}} -> {false, inform, Msg};
        {ok, NewRole} ->
            do_trans(ToPos, NewRole)
    end;
do_trans_hook({normal, gold}, ToPos, Role) ->
    LossList = [#loss{label = gold, val = pay:price(?MODULE, do_trans_hook, null), msg = ?L(<<"晶钻不够">>)}],
    case role_gain:do(LossList, Role) of
        {false, #loss{msg = Msg}} -> {false, Msg};
        {ok, NewRole} ->
            do_trans(ToPos, NewRole)
    end;
do_trans_hook({normal, _}, ToPos, Role) ->
    do_trans_hook({normal, item}, ToPos, Role);
do_trans_hook(free, ToPos, Role) ->
    do_trans(ToPos, Role);
do_trans_hook(_, _, _) ->
    {false, ?MSGID(<<"未知的传送方式">>)}.
%% 传送
do_trans({MapId, X, Y}, Role) ->
    map:role_enter(MapId, X, Y, Role);
do_trans(_, _Role) ->
    {false, ?MSGID(<<"目标地图不支持飞仙传送">>)}.

%% 判断角色是本服角色还是跨服角色
is_local_role(#role{id = {_, SrvId}}) ->
    is_local_role(SrvId);
is_local_role({_, SrvId}) ->
    is_local_role(SrvId);
is_local_role(SrvId) ->
    SrvIdStr = util:to_list(SrvId),
    case sys_env:get(srv_id) =:= SrvIdStr of
        true -> true;
        false ->
            case sys_env:get(srv_ids) of
                LocalSrvIds when is_list(LocalSrvIds) ->
                    lists:member(SrvIdStr, LocalSrvIds);
                _ -> false
            end
    end.

%% 重置角色状态（gm使用）
reset_status({RoleId, SrvId}) ->
    case role_api:lookup(by_id, {RoleId, SrvId}, #role.pid) of
        {ok, _N, Pid} -> %% 角色在线 
            role:apply(async, Pid, {fun  reset_status/1, []});
        _ -> %% 角色不在线 
            ok
    end;
reset_status(Role) ->
    ?INFO("~p ~s reset status", [Role#role.id, Role#role.name]),
    %{ok, Role#role{event = ?event_no, map = ?capital_map_id2}.
    Role2 = Role#role{event = ?event_no},
    case map:role_enter(?capital_map_id2, ?map_def_x, ?map_def_x, Role2) of
        {ok, Role3} ->
            {ok, Role3};
        _Other ->
            ?ERR("~p", [_Other]),
            {ok, Role2}
    end.

bind_account(Role = #role{id = {Rid, SrvId}, account = Account, platform = Platform}, OldAccount, NewAccount) when is_binary(Account) ->
    ?DEBUG("bind account ~s ~s ~s", [Account, OldAccount, NewAccount]),
    case string:to_lower(binary_to_list(Account)) =:= string:to_lower(binary_to_list(OldAccount)) of
        true ->
            ?DEBUG("--------------- ok"),
            put(role_info, {Rid, SrvId, NewAccount}), 
            role_group:join(all, Role),
            account_mgr:markRenamed(OldAccount, NewAccount, Platform),
            {ok, Role#role{account = NewAccount}};
        _ ->
            {ok, Role}
    end;
bind_account(Role, _OldAccount, _NewAccount) ->
    ?DEBUG("---------------2 ok"),
    {ok, Role}.

