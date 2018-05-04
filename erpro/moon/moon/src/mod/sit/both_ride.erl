%% *****************************************
%% 双人坐骑处理
%% @author wpf wprehard@qq.com
%% *****************************************
-module(both_ride).
-export([
        logout/1
        ,check_sex/1
        ,check_mounts/2
        ,check_both_ride/1
        ,check_both_ride2/1
        ,cancel_both_ride/1
        ,handle_both_ride/2
        ,handle_both_ride_callback/2
    ]).

-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("looks.hrl").
-include("pos.hrl").
-include("team.hrl").

%% <div> 组队相关的一些规则处理 </div>
%% 双人骑乘队伍可以邀请别人，但自动取消双人骑乘状态；
%% 玩家可以向共乘队伍申请入队，队长同意后自动取消双人骑乘状态；
%% 暂离、自动暂离、委任、退队等操作需要自动取消双人骑乘状态，客户端弹确认提示；
%% 玩家在同一队伍且只有2人情况下，允许请求双人骑乘；其他情况都不允许
%% 2人成功进入双人骑乘时，建立2人队伍，可以组队进入副本，但不可参加其他活动

%% @spec logout(Role) -> ok
%% @doc 双人骑乘离线处理
logout(Role = #role{action = Action}) when Action =:= ?action_ride_both ->
    cancel_both_ride(Role),
    ok;
logout(_Role) -> ok.

%% @spec check_sex(Sex1, Sex2) -> ok | {false, Msg}
%% @doc 检测异性
check_sex({?male, ?female}) -> ok;
check_sex({?female, ?male}) -> ok;
check_sex(_SexData) -> {false, ?L(<<"双人骑乘只能异性共同骑乘">>)}.

%% @spec check_both_ride(Role) -> ok | {false, Msg}
%% @doc 检查角色是否可以双人骑乘
check_both_ride(#role{status = Status}) when Status =/= ?status_normal ->
    {false, ?L(<<"您的状态无法请求双人骑乘">>)};
check_both_ride(#role{action = Action}) when Action =:= ?action_ride_both ->
    {false, ?L(<<"您当前已处于双人骑乘状态中">>)};
check_both_ride(#role{action = Action}) when Action =/= ?action_no ->
    {false, ?L(<<"您当前处于打坐或双修状态中，无法双人骑乘">>)};
check_both_ride(#role{ride = ?ride_fly}) ->
    {false, ?L(<<"您当前处于飞行状态中，无法双人骑乘">>)};
%% check_both_ride(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
%%     {false, <<"您当前处于队伍中，无法双人骑乘">>};
check_both_ride(#role{event = Event})
when Event =/= ?event_no andalso Event =/= ?event_dungeon ->
    {false, ?L(<<"参加活动中，暂时无法双人骑乘">>)};
%% check_both_ride(#role{team = RoleTeam}) ->
%%     %% TODO: 必须 无队伍 或者 队长
%%     case RoleTeam of
%%         #role_team{is_leader = ?false} ->
%%             {false, <<"您不是队长，不能请求双人骑乘">>};
%%         _ -> ok
%%     end;
check_both_ride(#role{cross_srv_id = <<"center">>, pos = #pos{map_base_id = MbaseId}})
when (MbaseId =:= 30401 orelse MbaseId =:= 30402 orelse MbaseId =:= 30501 orelse MbaseId =:= 30502) ->
    {false, ?L(<<"副本准备区内，暂时无法双人骑乘">>)};
check_both_ride(#role{cross_srv_id = <<"center">>, pos = #pos{map_base_id = MbaseId}})
when MbaseId =:= 36002 ->
    {false, ?L(<<"无尽试炼准备区内，暂时无法双人骑乘">>)};
check_both_ride(_) -> ok.

%% 检查坐骑
check_mounts(Mounts1, Mounts2) ->
    case mount:is_both_mount(Mounts1) of
        true -> ok;
        false ->
            case mount:is_both_mount(Mounts2) of
                false ->
                    {false, ?L(<<"对方没有装备双人坐骑或打开双人骑乘形象，无法请求双人骑乘">>)};
                true -> ok
            end
    end.

%% @spec check_both_ride2(Args) -> ok | {false, Msg}
%% @doc 检查角色是否可以双人骑乘
check_both_ride2([]) -> ok;
check_both_ride2([{CheckType, Data} | T]) ->
    case do_check_both_ride2(CheckType, Data) of
        {false, Msg} -> {false, Msg};
        ok -> check_both_ride2(T)
    end;

check_both_ride2(#role{action = Action}) when Action =/= ?action_no ->
    {false, ?L(<<"您当前处于打坐或双修状态中，无法双人骑乘">>)};
check_both_ride2(#role{ride = ?ride_fly}) ->
    {false, ?L(<<"您当前处于飞行状态中，无法双人骑乘">>)};
check_both_ride2(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"您当前处于队伍中，无法双人骑乘">>)};
check_both_ride2(#role{event = Event})
when Event =:= ?event_no orelse Event =:= ?event_dungeon ->
    ok;
check_both_ride2(_) ->
    {false, ?L(<<"您当前参加活动中，无法双人骑乘">>)}.

%% @spec cancel_both_ride(Role) -> NewRole
%% @doc 取消玩家的双人骑乘状态，不场景广播
cancel_both_ride(Role = #role{action = ?action_ride_both, special = Special, looks = Looks}) ->
    {ok, {_, _, Pid}} = role:get_dict(action_ride_both_other),
    role:c_apply(async, Pid, {fun handle_both_ride_callback/2, [?action_no]}),
    role:put_dict(action_ride_both_other, undefined),
    Role1 = remove_buff(Role),
    Role1#role{action = ?action_no, special = clean_special_info(Special), looks = clean_looks_info(Looks)};
cancel_both_ride(Role) -> Role.

%% @doc 异步处理角色双人骑乘效果
%% <div> 角色回调函数 </div>
handle_both_ride_callback(Role = #role{special = Special, looks = Looks}, ?action_no) ->
    role:put_dict(action_ride_both_other, undefined),
    Role1 = remove_buff(Role),
    NewRole = Role1#role{action = ?action_no, special = clean_special_info(Special), looks = clean_looks_info(Looks)},
    map:role_update(NewRole),
    {ok, NewRole};
%% 骑乘者 -- 暂未使用
handle_both_ride_callback(Role = #role{action = Action, special = Special, looks = Looks}, {1, OtherId, OtherName, OtherPid})
when Action =:= ?action_no ->
    NewSpecial = [{?special_ride_both_name, 0, OtherName} | Special],
    NewLooks = [{?LOOKS_TYPE_RIDE_BOTH, 0, 1} | Looks],
    role:put_dict(action_ride_both_other, {OtherId, OtherName, OtherPid}),
    NewRole = Role#role{action = ?action_ride_both, special = NewSpecial, looks = NewLooks},
    map:role_update(NewRole),
    {ok, NewRole};
%% 跟随者
handle_both_ride_callback(Role = #role{action = Action, looks = Looks, pos = #pos{map = MapId}}, {2, OtherId, OtherName, OtherPid, MountId, {CrossSrv, MapId, X, Y}})
when Action =:= ?action_no -> %% 注意：必须是同地图才有效，否则不同副本会有bug
    NewLooks = [{?LOOKS_TYPE_RIDE_BOTH, 0, 2} | Looks],
    role:put_dict(action_ride_both_other, {OtherId, OtherName, OtherPid}),
    Role1 = update_buff(Role, mount_id_to_buff(MountId)),
    Role2 = Role1#role{action = ?action_ride_both, looks = NewLooks},
    case map:role_enter(MapId, X, Y, Role2#role{cross_srv_id = CrossSrv}) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {ok, Role1}
    end;
handle_both_ride_callback(Role, _ActionInfo) ->
    {ok, Role}.

%% @spec handle_both_ride(Args, Role) -> NewRole
%% @doc 处理角色双人骑乘相关
%% 卸载
handle_both_ride(?action_no, Role = #role{action = ?action_ride_both}) ->
    NewRole = cancel_both_ride(Role),
    map:role_update(NewRole),
    NewRole;
%% 骑乘者
handle_both_ride({1, OtherId, OtherName, OtherPid}, Role = #role{action = ?action_no, cross_srv_id = CrossSrv, id = RoleId, name = RoleName, special = Special, looks = Looks, pos = #pos{map = MapId, x = X, y = Y}}) ->
    MountId = mount:get_now_mount_id(Role),
    role:c_apply(async, OtherPid, {fun handle_both_ride_callback/2, [{2, RoleId, RoleName, self(), MountId, {CrossSrv, MapId, X, Y}}]}),
    NewSpecial = [{?special_ride_both_name, 0, OtherName} | Special],
    NewLooks = [{?LOOKS_TYPE_RIDE_BOTH, 0, 1} | Looks],
    role:put_dict(action_ride_both_other, {OtherId, OtherName, OtherPid}),
    Role1 = update_buff(Role, mount_id_to_buff(MountId)),
    NewRole = Role1#role{action = ?action_ride_both, special = NewSpecial, looks = NewLooks},
    map:role_update(NewRole),
    NewRole;
%% 跟随者-暂未使用
handle_both_ride({2, OtherId, OtherName, OtherPid, {CrossSrv, MapId, X, Y}}, Role = #role{action = ?action_no, id = RoleId, name = RoleName, looks = Looks}) ->
    role:c_apply(async, OtherPid, {fun handle_both_ride_callback/2, [{1, RoleId, RoleName, self()}]}),
    NewLooks = [{?LOOKS_TYPE_RIDE_BOTH, 0, 2} | Looks],
    role:put_dict(action_ride_both_other, {OtherId, OtherName, OtherPid}),
    Role1 = Role#role{action = ?action_ride_both, looks = NewLooks},
    case map:role_enter(MapId, X, Y, Role1#role{cross_srv_id = CrossSrv}) of
        {ok, NewRole} -> NewRole;
        _ -> Role1
    end;
%% 其他忽略
handle_both_ride(_, Role) ->
    Role.

%% -------------------------------------------------
%% 内部函数
%% -------------------------------------------------

%% 清除双人骑乘信息
clean_special_info(Special) ->
    clean_special_info(?special_ride_both_name, Special, []).

clean_special_info(_Type, [], L) -> L;
clean_special_info(Type, [{Type, _, _} | T], L) ->
    clean_special_info(Type, T, L);
clean_special_info(Type, [H | T], L) ->
    clean_special_info(Type, T, [H | L]).

%% 清除双人骑乘外观信息
clean_looks_info(Looks) ->
    clean_looks_info(?LOOKS_TYPE_RIDE_BOTH, Looks, []).

clean_looks_info(_Type, [], L) -> L;
clean_looks_info(Type, [{Type, _, _} | T], L) ->
    clean_looks_info(Type, T, L);
clean_looks_info(Type, [H | T], L) ->
    clean_looks_info(Type, T, [H | L]).

%% 检查是否可以发起或操作双人骑乘
%% action
do_check_both_ride2(action, Action)
when Action =:= ?action_ride_both ->
    {false, ?L(<<"对方已处于双人骑乘中，无法请求">>)};
do_check_both_ride2(action, Action)
when Action =/= ?action_no ->
    {false, ?L(<<"对方处于打坐或者双修中，无法请求">>)};
do_check_both_ride2(action, _Action) ->
    ok;
%% 飞行
do_check_both_ride2(ride, ?ride_fly) ->
    {false, ?L(<<"对方飞行中，无法请求双人骑乘">>)};
do_check_both_ride2(ride, _) ->
    ok;
%% 队伍人数判断
do_check_both_ride2(team, {TeamPid, NeedNum}) ->
    case is_pid(TeamPid) of
        true ->
            case team_api:get_member_count(TeamPid) of
                NeedNum -> ok;
                _ -> {false, ?L(<<"队伍人数不支持双人骑乘">>)}
            end;
        false -> {false, ?L(<<"队伍人数不支持双人骑乘">>)}
    end;
%% 队长
do_check_both_ride2(leader, #role_team{is_leader = ?true}) -> ok;
do_check_both_ride2(leader, #role_team{is_leader = ?false}) ->
    {false, ?L(<<"只能由队长发起请求双人骑乘">>)};
do_check_both_ride2(leader, _) ->
    ok;
%% 队员
do_check_both_ride2(member, #role_team{is_leader = ?false}) -> ok;
do_check_both_ride2(member, #role_team{is_leader = ?true}) ->
    {false, ?L(<<"对方不是队伍中队员无法请求双人骑乘">>)};
do_check_both_ride2(member, _) -> ok;
%% 活动
do_check_both_ride2(event, Event)
when Event =:= ?event_no orelse Event =:= ?event_dungeon ->
    ok;
do_check_both_ride2(event, _) ->
    {false, ?L(<<"对方参加活动中，无法双人骑乘">>)};
%% 性别
do_check_both_ride2(sex, SexData) ->
    check_sex(SexData);
do_check_both_ride2(other_mount, Mounts) ->
    case mount:is_both_mount(Mounts) of
        false -> {reply, {?false, ?L(<<"对方没有装备双人坐骑或骑乘形象，无法骑乘">>)}};
        true -> ok
    end;
%% 其他
do_check_both_ride2(_CheckType, _Data) ->
    ?DEBUG("Type: ~w", [_CheckType]),
    {false, ?L(<<"操作失败">>)}.

%% 所有双人坐骑buff列表
mount_buff_list() ->
    [double_mount_1].

%% 坐骑ID对应的共乘buff label
mount_id_to_buff(19100) -> [double_mount_1];
mount_id_to_buff(_) -> [double_mount_1].

%% 更新坐骑buff
update_buff(Role, []) -> Role;
update_buff(Role, [MountId | T]) ->
    update_buff(do_update_buff(Role, MountId), T).

do_update_buff(Role, MountId) ->
    case mount_id_to_buff(MountId) of
        [BuffLabel] ->
            case buff:add(Role, BuffLabel) of
                {ok, NewRole} -> %% 需要buff表设置好覆盖关系，内部处理
                    role_api:push_attr(NewRole);
                _ -> Role
            end;
        [] ->
            Role
    end.

%% 删除buff
remove_buff(Role) ->
    BuffList = mount_buff_list(),
    do_remove_buff(Role, BuffList).

do_remove_buff(Role, []) ->
    role_api:push_attr(Role);
do_remove_buff(Role, [BuffLabel | T]) ->
    case buff:del_buff_by_label_no_push(Role, BuffLabel) of
        {ok, NewRole} ->
            do_remove_buff(NewRole, T);
        _ -> do_remove_buff(Role, T)
    end.
