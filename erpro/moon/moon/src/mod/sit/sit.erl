%% ************************
%% 打坐双修模块
%% wpf wprehard@qq.com
%% ************************
-module(sit).
-export([
        handle_sit/2
        ,handle_enter_map/1
        ,both_sit/2
        ,sit_both_logout/1
        ,combat_before/2    %% 进战场前检测打坐双修并取消
        ,check_sit/1
        ,do_check_both_sit/2
        ,pack_proto_msg/2
        ,get_sit_partner/1
        %% 角色进程回调函数
        ,set_action_sit/3
        ,sit_exp_callback/1
    ]).

-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("ratio.hrl").
-include("sit.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("assets.hrl").
%%
-include("looks.hrl").

%% 双修距离计算
-define(BOTH_DISTANCE, 50). %% 50 pixel
%% 打坐回血同步计算间隔(ms)
-define(CALC_TIME, 5000).
-define(CALC_NUM, 5).
%% 打坐加经验同步更新间隔(ms)
-define(SYNC_TIME, 60000).
%% 跨服支持
-define(CROSS_CALL(F, A), center:call(?MODULE, F, A)).
-define(CROSS_CALL(M, F, A), center:call(M, F, A)).
-define(CROSS_CAST(F, A), center:cast(?MODULE, F, A)).
-define(CROSS_CAST(M, F, A), center:cast(M, F, A)).
-define(CALL_SRV(S, M, F, A), center:call(c_mirror_group, call, [node, S, M, F, A])).
-define(CAST_SRV(S, M, F, A), center:cast(c_mirror_group, cast, [node, S, M, F, A])).
-define(CALL_NODE(Node, M, F, A), center:call(rpc, call, [Node, M, F, A])).
-define(CAST_NODE(Node, M, F, A), center:cast(rpc, cast, [Node, M, F, A])).
%% 打坐功能：
%% 1、通过角色定时器来计算打坐收益
%% 2、血量和法力的回复:每5s计算一次
%% 3、经验和灵力的加成1分钟计算一次, 同时同步信息一次；

%% @spec handle_sit(ActionType, Role) -> NewRole
%% ActionType = integer() | {integer(), tuple()} 打坐类型, 双修对方的ID
%% @doc 处理打坐请求，由服务端判断，打坐或取消
%% <div> 角色进程调用函数 </div>
handle_sit(?action_no, Role = #role{id = Rid, action = Action, link = #link{conn_pid = ConnPid}, special = Special})
when Action >= ?action_sit andalso Action =< ?action_sit_lovers -> %% 取消打坐&双修
    NR2 = case role_timer:del_timer(sit_exp, Role) of
        false -> Role;
        {ok, _, R} -> R
    end,
    put(role_sit_heap, undefined), %% 重置累积经验和灵力
    NewSpecial = clean_both_special(Special, []),
    NR3 = NR2#role{action = ?action_no, special = NewSpecial},
    NewRole = case ets:lookup(ets_sit_both, Rid) of
        [#sit_both{id_two = IdTwo, pid_two = PidTwo, type = Action}] ->
            ets:delete(ets_sit_both, Rid),
            del_other_both_info(IdTwo, PidTwo),
            calc_time(NR3);
        _ -> NR3
    end,
    %% NewRole = looks:calc(NR4),
    map:role_update(NewRole),
    sys_conn:pack_send(ConnPid, 11601, pack_proto_msg(11601, {?sit_cancel, <<>>, NewRole})),
    NewRole;
handle_sit(?action_no, Role = #role{action = Action, looks = Looks, special = Special})
when Action =:= ?action_sit_demon -> %% 取消守护双修
    NR2 = case role_timer:del_timer(sit_exp, Role) of
        false -> Role;
        {ok, _, R} -> R
    end,
    NewLooks = clean_both_looks(Looks, []),
    NewSpecial = clean_both_special(Special, []),
    NewRole = NR2#role{action = ?action_no, looks = NewLooks, special = NewSpecial},
    map:role_update(NewRole),
    NewRole;
handle_sit(?action_no, Role) ->
    Role;
handle_sit(?action_sit_demon, Role = #role{team_pid = TeamPid, link = #link{conn_pid = ConnPid}}) ->
    case check_sit(Role) of
        {false, Reason} ->
            sys_conn:pack_send(ConnPid, 11601, pack_proto_msg(11601, {?sit_cancel, Reason, Role})),
            Role;
        ok ->
            ActionInfo = get_demon_both_info(Role),
            case is_pid(TeamPid) of
                true ->
                    Role1 = team_api:team_listener(tempout, Role),
                    team:tempout(Role1, sit),
                    do_handle_sit(ActionInfo, Role1);
                false ->
                    do_handle_sit(ActionInfo, Role)
            end
    end;
handle_sit(ActionInfo, Role = #role{team_pid = TeamPid, link = #link{conn_pid = ConnPid}}) ->
    case check_sit(Role) of
        {false, Reason} ->
            sys_conn:pack_send(ConnPid, 11601, pack_proto_msg(11601, {?sit_cancel, Reason, Role})),
            Role;
        ok ->
            case is_pid(TeamPid) of
                true ->
                    Role1 = team_api:team_listener(tempout, Role), %% 目前主要处理双人坐骑
                    team:tempout(Role1, sit),
                    do_handle_sit(ActionInfo, Role1);
                false ->
                    do_handle_sit(ActionInfo, Role)
            end
    end;
handle_sit(_, R) ->
    ?DEBUG("角色[ID:~w, NAME:~s]请求或取消打坐, 错误忽略", [R#role.id, R#role.name]),
    R.

%% @spec handle_enter_map(Role) -> NewRole
%% @doc 提供给底层地图进程模块调用，切换地图时对打坐或者双修状态进行取消处理
%% <div> 角色进程调用 </div>
handle_enter_map(Role = #role{id = Rid, action = Action, link = #link{conn_pid = ConnPid}, special = Special}) 
when Action >= ?action_sit andalso Action =< ?action_sit_lovers ->
    NR2 = case role_timer:del_timer(sit_exp, Role) of
        false -> Role;
        {ok, _, R} -> R
    end,
    put(role_sit_heap, undefined), %% 重置累积经验和灵力
    NewSpecial = clean_both_special(Special, []),
    NR3 = NR2#role{action = ?action_no, special = NewSpecial},
    NewRole = case ets:lookup(ets_sit_both, Rid) of
        [#sit_both{id_two = IdTwo, pid_two = PidTwo, type = Action}] ->
            ets:delete(ets_sit_both, Rid),
            del_other_both_info(IdTwo, PidTwo),
            calc_time(NR3);
        _ -> NR3
    end,
    sys_conn:pack_send(ConnPid, 11601, pack_proto_msg(11601, {?sit_cancel, <<>>, NewRole})),
    NewRole;
handle_enter_map(Role = #role{action = Action, looks = Looks, special = Special}) 
when Action =:= ?action_sit_demon -> %% 取消守护双修
    NR2 = case role_timer:del_timer(sit_exp, Role) of
        false -> Role;
        {ok, _, R} -> R
    end,
    NewLooks = clean_both_looks(Looks, []),
    NewSpecial = clean_both_special(Special, []),
    NewRole = NR2#role{action = ?action_no, looks = NewLooks, special = NewSpecial},
    map:role_update(NewRole),
    NewRole;
handle_enter_map(Role) ->
    Role.

%% @spec get_sit_partner(Rid) -> {PartnerId, PartnerPid} | none
%% Rid = {integer(), bitstring()}
%% PartnerId = {integer(), bitstring()}
%% PartnerPid = pid()
%% @doc 获取双修对方的信息
get_sit_partner(Rid) ->
    case ets:lookup(ets_sit_both, Rid) of
        [#sit_both{id_two = IdTwo, pid_two = PidTwo}] -> {IdTwo, PidTwo};
        _ -> none
    end.

%% @spec both_sit(InviteRole, InvitedId) -> {ok, BothType} | {false, Reason}
%% InviteRole = #role{} 邀请人的角色信息
%% InvitedId = tuple()  被邀请人的ID
%% @doc 处理双修邀请: TODO: 待优化
both_sit(Role = #role{pid = PidOne, id = IdOne, pos = Pos1}, InvitedId) ->
    case check_sit(Role) of
        ok ->
            case role_api:c_lookup(by_id, InvitedId, [#role.pid, #role.id, #role.pos]) of
                {ok, Node, [PidTwo, IdTwo, Pos2]} when Node =:= node() ->
                    case role:apply(sync, PidTwo, {fun do_check_both_sit/2, [Pos1]}) of
                        {false, Reason} -> {false, Reason};
                        ok ->
                            {BothType, S1, S2} = get_both_info(IdOne, IdTwo, Pos1, Pos2),%% TODO: 获取双修类型
                            ets:insert(ets_sit_both, #sit_both{id_one = IdOne, id_two = IdTwo, pid_two = PidTwo, type = BothType, s_time = 0}),
                            ets:insert(ets_sit_both, #sit_both{id_one = IdTwo, id_two = IdOne, pid_two = PidOne, type = BothType, s_time = 0}),
                            role:apply(async, PidTwo, {sit, set_action_sit, [BothType, S2]}),
                            {ok, {BothType, S1}};
                        _ -> {false, ?L(<<"您现在不能双修">>)}
                    end;
                {ok, Node, [PidTwo, IdTwo, Pos2]} -> %% 跨服双修
                    case role:c_apply(sync, PidTwo, {fun do_check_both_sit/2, [Pos1]}) of
                        {false, Reason} -> {false, Reason};
                        ok ->
                            {BothType, S1, S2} = get_both_info(IdOne, IdTwo, Pos1, Pos2),%% TODO: 获取双修类型
                            ets:insert(ets_sit_both, #sit_both{id_one = IdOne, id_two = IdTwo, pid_two = PidTwo, type = BothType, s_time = 0}),
                            ?CAST_NODE(Node, ets, insert, [ets_sit_both, #sit_both{id_one = IdTwo, id_two = IdOne, pid_two = PidOne, type = BothType, s_time = 0}]),
                            role:c_apply(async, PidTwo, {sit, set_action_sit, [BothType, S2]}),
                            {ok, {BothType, S1}};
                        _ -> {false, ?L(<<"您现在不能双修">>)}
                    end;
                _ -> {false, ?L(<<"您现在不能双修">>)}
            end;
        F = {false, _} -> F
    end.

%% @spec combat_before(IsSelf, Role) -> NewRole
%% IsSelf = integer() 是否当前角色进程 0:是当前进程 1:非当前角色进程
%% @doc 角色战斗前检测打坐状态
combat_before(0, Role = #role{action = ?action_no}) ->
    Role;
combat_before(0, Role) ->
    handle_sit(?action_no, Role);
combat_before(1, Role = #role{action = ?action_no}) ->
    Role;
combat_before(1, #role{pid = Rpid}) -> %% 此处是一个同步回写操作，建议combat中的调用可以整合
    NewRole = role:apply(sync, Rpid, {fun do_combat_before/1, []}),
    NewRole.
do_combat_before(Role = #role{action = ?action_no}) ->
    Role;
do_combat_before(Role) ->
    NewRole = handle_sit(?action_no, Role),
    {ok, NewRole, NewRole}.

%% @spec sit_both_logout(Role) -> any()
%% @doc 双修离线处理
sit_both_logout(#role{id = Rid, action = Action})
when Action >= ?action_sit andalso Action =< ?action_sit_lovers ->
    case ets:lookup(ets_sit_both, Rid) of
        [#sit_both{id_two = IdTwo, pid_two = PidTwo, type = Action}] ->
            ets:delete(ets_sit_both, Rid),
            del_other_both_info(IdTwo, PidTwo);
        _ -> ignore
    end;
sit_both_logout(_R) ->
    ignore.

%% @spec check_sit(Role) -> {false, Reason} | ok
%% @doc 判断是否可以打坐或双修
check_sit(#role{ride = ?ride_fly}) ->
    {false, ?L(<<"飞行中不允许打坐">>)};
check_sit(#role{event = ?event_arena_match}) ->
    ok;
check_sit(#role{event = ?event_arena_prepare}) ->
    ok;
check_sit(#role{event = ?event_top_fight_match}) ->
    ok;
check_sit(#role{event = ?event_top_fight_prepare}) ->
    ok;
check_sit(#role{event = ?event_dungeon}) ->
    ok;
check_sit(#role{event = ?event_guild}) ->
    ok;
check_sit(#role{event = ?event_escort}) ->
    ok;
check_sit(#role{event = Event}) when Event =/= ?event_no ->
    {false, ?L(<<"当前活动中不允许打坐或双修">>)};
check_sit(_) -> ok.

%% @spec do_check_both_sit(InvitedRole, InvitePos) -> {ok, Reply}
%% InvitedRole = #role{} 被邀请的角色信息
%% InvitePos = #pos{}    邀请人的位置信息
%% Reply = ok | {false, Reason}
%% @doc 判断被邀请人是否可以进行双修
%% <div> 角色同步回调函数 </div>
do_check_both_sit(#role{status = ?status_fight}, _) ->
    {ok, {false, ?L(<<"对方当前状态不能与您双修">>)}};
do_check_both_sit(#role{ride = ?ride_fly}, _) ->
    {ok, {false, ?L(<<"对方当前状态不能与您双修">>)}};
do_check_both_sit(#role{action = ?action_sit, pos = InvitedPos}, InvitePos) ->
    {ok,
        case map:calc_distance(InvitePos, InvitedPos) of
            {ok, {DetX, DetY}} ->
                case DetX =< ?BOTH_DISTANCE andalso DetY =< ?BOTH_DISTANCE of
                    true -> ok;
                    false ->  {false, ?L(<<"双修失败，距离过远">>)}
                end;
            _ -> {false, ?L(<<"双修失败，距离过远">>)}
        end
    };
do_check_both_sit(#role{action = Action}, _) when Action >= ?action_sit_both andalso Action =< ?action_sit_lovers ->
    {ok, {false, ?L(<<"对方已经在双修中，您不能再邀请">>)}};
do_check_both_sit(_R, _) ->
    ?DEBUG("双修邀请检查到无匹配项[对方的Action:~w,Event:~w]", [_R#role.action, _R#role.event]),
    {ok, {false, ?L(<<"对方暂时无法与您双修">>)}}.

%% @spec pack_proto_msg(Cmd, {Result::integer(), Msg::bitstring(), Role}) -> tuple()
%% @doc 获取协议数据
%% 返回11601消息
pack_proto_msg(11601, {Result, Msg, #role{hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, assets = #assets{exp = Exp, psychic = Psy}}}) -> 
    {Result, 0, 0, HpMax, MpMax, Hp, Mp, Exp, Psy, Msg};
pack_proto_msg(11602, #role{assets = #assets{exp = Exp, psychic = Psy}}) -> 
    {Exp, Psy}.

%% @spec set_action_sit(Role, BothType, IdTwo) -> {ok} | {ok, NewState}
%% BothType = integer() 双修类型
%% IdTwo = {integer(), bitstring()} 对方ID
%% @doc 设置角色之间的双修打坐状态/类型
%% <div> 角色进程异步回调函数 </div>
%% 取消双修-进入普通打坐
set_action_sit(Role = #role{action = Action, special = Special}, ?action_sit, _)
when Action >= ?action_sit_both andalso Action =< ?action_sit_lovers ->
    NewSpecial = clean_both_special(Special, []),
    NewRole0 = Role#role{action = ?action_sit, special = NewSpecial},
    NewRole = calc_time(NewRole0), %% 计算双修时间
    map:role_update(NewRole),
    {ok, NewRole};
%% 普通打坐--进入双修 --停用
set_action_sit(Role = #role{action = Action, special = Special, pos = Pos}, BothType, {Id, SrvId})
when Action =:= ?action_sit andalso BothType >= ?action_sit_both andalso BothType =< ?action_sit_lovers ->
    NewRole1 = Role#role{action = BothType, special = [{?special_both_sit, Id, SrvId} | Special]},
    NewRole = case Pos of
        #pos{map_base_id = 36031} ->
            role_listener:special_event(NewRole1, {30032, 1});
        _ -> NewRole1
    end,
    map:role_update(NewRole),
    {ok, NewRole};
%% 普通打坐--进入双修 -- 12/01/07
set_action_sit(Role = #role{action = Action, special = Special, pos = Pos}, BothType, {X2, Y2, Dir2})
when Action =:= ?action_sit andalso BothType >= ?action_sit_both andalso BothType =< ?action_sit_lovers ->
    Special0 = [{?special_both_sit_dir, Dir2, <<>>} | Special],
    Special1 = [{?special_both_sit_y, Y2, <<>>} | Special0],
    NewSpecial = [{?special_both_sit_x, X2, <<>>} | Special1],
    Role1 = Role#role{action = BothType, special = NewSpecial},
    NewRole = case Pos of
        #pos{map_base_id = 36031} ->
            role_listener:special_event(Role1, {30032, 1});
        _ -> Role1
    end,
    put(sit_both_start_time, util:unixtime()),
    map:role_update(NewRole),
    {ok, NewRole};
set_action_sit(_Role, _BothType, _) ->
    ?DEBUG("错误的异步操作[失败:~w]：设置打坐/双修动作状态，角色[NAME:~s, ACTION:~w]", [_BothType, _Role#role.name, _Role#role.action]),
    {ok}.

%% @spec sit_exp_callback(Role) -> {ok} | {ok, NewState}
%% @doc 打坐加经验效果，双修加成判断加成比率
%% <div> 注意：角色进程定时回调函数 </div>
sit_exp_callback(#role{status = ?status_die}) -> {ok};
sit_exp_callback(Role = #role{action = ?action_sit_demon}) -> %% 守护双修
    {AddExp, _AddPsy, StrMsg} = get_gain_both(Role),
    AddList = [#gain{label = exp, val = AddExp}],
    case role_gain:do(AddList, Role) of
        {false, _} -> {ok};
        {ok, NR} ->
            notice:inform(StrMsg), %% 事件通知
            {ok, NR}
    end;
sit_exp_callback(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    {AddExp, AddPsy, StrMsg} = get_gain_both(Role),
    %% AddList = [#gain{label = exp, val = AddExp}, #gain{label = psychic, val = AddPsy}],
    AddList = [#gain{label = exp, val = AddExp}],
    case role_gain:do(AddList, Role) of
        {false, _} -> {ok};
        {ok, NR} ->
            case get(role_sit_heap) of
                {E, P} ->
                    P0 = P + AddPsy,
                    E0 = E + AddExp,
                    put(role_sit_heap, {E0, P0}),
                    sys_conn:pack_send(ConnPid, 11602, {E0, P0});
                _ ->
                    put(role_sit_heap, {AddExp, AddPsy}),
                    sys_conn:pack_send(ConnPid, 11602, {AddExp, AddPsy})
            end,
            notice:inform(StrMsg), %% 事件通知
            {ok, NR}
    end.

%% ----------------------------------------------------------------------
%% 内部函数
%% ----------------------------------------------------------------------

%% @doc 删除另一方双修记录信息，支持跨服双修处理
%% @spec del_other_both_info(IdTwo, PidTwo) -> any()
%% IdTwo = {integer(), bitstring()}
%% PidTwo = pid()
del_other_both_info(IdTwo, PidTwo) ->
    Node = node(PidTwo),
    case Node =:= node() of
        true ->
            ets:delete(ets_sit_both, IdTwo),
            role:apply(async, PidTwo, {sit, set_action_sit, [?action_sit, 0]}); %% 双修另一方置为普通打坐
        false -> %% 跨服
            ?CAST_NODE(Node, ets, delete, [ets_sit_both, IdTwo]),
            role:c_apply(async, PidTwo, {sit, set_action_sit, [?action_sit, 0]}) %% 双修另一方置为普通打坐
    end.

%% 获取打坐经验灵力以及双修加成
get_gain_both(R = #role{lev = Lev, action = Action, ratio = #ratio{sit_exp = SitExp}, event = _Event}) ->
    AddExp = role_exp_data:get_sit_exp(Lev),
    %% AddPsy = role_exp_data:get_sit_spirit(Lev),
    VipAddExp = vip:effect(sit_exp, R),
    case Action of
        ?action_sit ->
            A1 = erlang:round(AddExp * (SitExp + VipAddExp) / 100),
            %% A2 = erlang:round(AddPsy * SitPsy / 100),
            %% {A1, A2, util:fbin(?L(<<"普通打坐\n获得 {str,经验,#00FF00} ~w">>), [A1, A2])};
            {A1, 0, util:fbin(?L(<<"普通打坐\n获得 {str,经验,#00FF00} ~w">>), [A1])};
        ?action_sit_both ->
            %% A2 = erlang:round(AddPsy * (SitPsy + 20) / 100),
            %% {A1, A2, util:fbin(?L(<<"双修打坐\n获得 {str,经验,#00FF00} ~w">>), [A1, A2])};
            A1 = erlang:round(AddExp * (SitExp + 20 + VipAddExp) / 100),
            {A1, 0, util:fbin(?L(<<"双修打坐\n获得 {str,经验,#00FF00} ~w">>), [A1])};
        ?action_sit_brother ->
            A1 = erlang:round(AddExp * (SitExp + 25 + VipAddExp) / 100),
            %% A2 = erlang:round(AddPsy * (SitPsy + 25) / 100),
            %% {A1, A2, util:fbin(?L(<<"师徒双修\n获得 {str,经验,#00FF00} ~w">>), [A1, A2])};
            {A1, 0, util:fbin(?L(<<"师徒双修\n获得 {str,经验,#00FF00} ~w">>), [A1])};
        ?action_sit_master ->
            A1 = erlang:round(AddExp * (SitExp + 25 + VipAddExp) / 100),
            %% A2 = erlang:round(AddPsy * (SitPsy + 25) / 100),
            %% {A1, A2, util:fbin(?L(<<"结拜双修\n获得 {str,经验,#00FF00} ~w">>), [A1, A2])};
            {A1, 0, util:fbin(?L(<<"结拜双修\n获得 {str,经验,#00FF00} ~w">>), [A1])};
        ?action_sit_lovers ->
            A1 = erlang:round(AddExp * (SitExp + 30 + VipAddExp) / 100),
            %% A2 = erlang:round(AddPsy * (SitPsy + 30) / 100),
            %% {A1, A2, util:fbin(?L(<<"情侣双修\n获得 {str,经验,#00FF00} ~w">>), [A1, A2])};
            {A1, 0, util:fbin(?L(<<"情侣双修\n获得 {str,经验,#00FF00} ~w">>), [A1])};
        ?action_sit_demon ->
            A1 = erlang:round(AddExp * (SitExp + 20 + VipAddExp) / 100) * demon:both_exp_ratio(),
            %% A2 = erlang:round(AddPsy * (SitPsy + 30) / 100),
            %% {A1, A2, util:fbin(?L(<<"情侣双修\n获得 {str,经验,#00FF00} ~w">>), [A1, A2])};
            {A1, 0, util:fbin(?L(<<"精灵守护双修\n获得 {str,经验,#00FF00} ~w">>), [A1])};
        _ -> ?ELOG("异常的双修状态"),
            {0, 0, <<>>}
    end.

%% 获取双修信息，精灵守护双修
get_demon_both_info(#role{pos = #pos{x = X, y = Y}}) ->
    {?action_sit_demon, {X, Y, 1}}.
%% 获取双修信息 TODO: 
get_both_info(IdOne, IdTwo, _, Pos2 = #pos{x = X2, y = Y2}) ->
    Type = get_both_type(IdOne, IdTwo),
    {Dir2, {X1, Y1, Dir1}} = get_dir(Pos2),
    {Type, {X1, Y1, Dir1}, {X2, Y2, Dir2}}.

get_both_type(_IdOne, _IdTwo) -> ?action_sit_both.

get_dir(#pos{map_base_id = MapBaseId, x = X, y = Y}) ->
    case map_mgr:is_blocked(MapBaseId, X + 60, Y) of
        true -> {2, {X - 60, Y, 1}};
        false -> {1, {X + 60, Y, 2}}
    end.

%% 获取计时
calc_time(Role = #role{assets = A = #assets{both_time = BothTime}}) ->
    case get(sit_both_start_time) of
        undefined -> Role;
        T -> 
            NowTime = BothTime + (util:unixtime() - T),
            Role0 = Role#role{assets = A#assets{both_time = NowTime}},
            role_listener:special_event(Role0, {20011, NowTime})
    end.

%% 处理speical的清理工作
%% 清除special字段中的双修信息 -- 可以确保清空
clean_both_special([], Special) -> Special;
clean_both_special([{?special_both_sit_dir, _, _} | T], Special) ->
    clean_both_special(T, Special);
clean_both_special([{?special_both_sit_x, _, _} | T], Special) ->
    clean_both_special(T, Special);
clean_both_special([{?special_both_sit_y, _, _} | T], Special) ->
    clean_both_special(T, Special);
clean_both_special([H | T], Special) ->
    clean_both_special(T, [H | Special]); %% TODO: 场景special字段顺序会反转，已确认客户端不会受影响
clean_both_special(_, Special) ->
    Special.
%% 清除special字段中的双修信息 -- 可以确保清空
clean_both_looks([], Looks) -> Looks;
clean_both_looks([{?LOOKS_TYPE_DEMON_BOTH, _, _} | T], Looks) ->
    clean_both_looks(T, Looks);
clean_both_looks([H | T], Looks) ->
    clean_both_looks(T, [H | Looks]).

%% 以下处理打坐相关的定时设置及广播
%% 处理双修 -- 12/01/07 客户端变更
do_handle_sit({?action_sit_demon, {X, Y, Dir}}, Role = #role{action = ?action_no, looks = Looks, special = Special}) ->
    %% 处理守护双修
    NR1 = role_timer:set_timer(sit_exp, ?SYNC_TIME, {sit, sit_exp_callback, []}, 0, Role),
    Special0 = [{?special_both_sit_dir, Dir, <<>>} | Special],
    Special1 = [{?special_both_sit_y, Y, <<>>} | Special0],
    NewSpecial = [{?special_both_sit_x, X, <<>>} | Special1],
    NewRole = NR1#role{action = ?action_sit_demon, looks = demon:add_both_looks(Looks, Role), special = NewSpecial},
    map:role_update(NewRole),
    NewRole;
do_handle_sit({Type, {X1, Y1, Dir1}}, Role = #role{action = ?action_no, link = #link{conn_pid = ConnPid}, special = Special, pos = Pos}) ->
    NR1 = role_timer:set_timer(sit_exp, ?SYNC_TIME, {sit, sit_exp_callback, []}, 0, Role),
    Special0 = [{?special_both_sit_dir, Dir1, <<>>} | Special],
    Special1 = [{?special_both_sit_y, Y1, <<>>} | Special0],
    NewSpecial = [{?special_both_sit_x, X1, <<>>} | Special1],
    NewRole1 = NR1#role{action = Type, special = NewSpecial},
    NewRole = case Pos of
        #pos{map_base_id = 36031} ->
            role_listener:special_event(NewRole1, {30032, 1});
        _ -> NewRole1
    end,
    put(sit_both_start_time, util:unixtime()),
    map:role_update(NewRole),
    sys_conn:pack_send(ConnPid, 11601, pack_proto_msg(11601, {?sit_ok, <<>>, NewRole})),
    NewRole;
do_handle_sit({Type, {X1, Y1, Dir1}}, Role = #role{link = #link{conn_pid = ConnPid}, special = Special, pos = Pos}) ->
    Special0 = [{?special_both_sit_dir, Dir1, <<>>} | Special],
    Special1 = [{?special_both_sit_y, Y1, <<>>} | Special0],
    NewSpecial = [{?special_both_sit_x, X1, <<>>} | Special1],
    NewRole1 = Role#role{action = Type, special = NewSpecial},
    NewRole = case Pos of
        #pos{map_base_id = 36031} ->
            role_listener:special_event(NewRole1, {30032, 1});
        _ -> NewRole1
    end,
    put(sit_both_start_time, util:unixtime()),
    map:role_update(NewRole),
    sys_conn:pack_send(ConnPid, 11601, pack_proto_msg(11601, {?sit_ok, <<>>, NewRole})),
    NewRole;
%% 处理普通打坐
do_handle_sit(?action_sit, Role = #role{action = ?action_no, link = #link{conn_pid = ConnPid}}) ->
    NR1 = role_timer:set_timer(sit_exp, ?SYNC_TIME, {sit, sit_exp_callback, []}, 0, Role),
    NewRole = NR1#role{action = ?action_sit},
    map:role_update(NewRole),
    sys_conn:pack_send(ConnPid, 11601, pack_proto_msg(11601, {?sit_ok, <<>>, NewRole})),
    NewRole;
do_handle_sit(_, Role) -> Role.

%% %% 处理双修 --停用
%% do_handle_sit({Type, {Id, SrvId}}, Role = #role{action = ?action_no, link = #link{conn_pid = ConnPid}, special = Special}) ->
%%     NR1 = role_timer:set_timer(sit_exp, ?SYNC_TIME, {sit, sit_exp_callback, []}, 0, Role),
%%     NewRole = NR1#role{action = Type, special = [{?special_both_sit, Id, SrvId} | Special]},
%%     ?DEBUG("角色双修邀请成功, 对方ID：~w", [{Id, SrvId}]),
%%     %% NewRole = looks:calc(NR3),
%%     map:role_update(NewRole),
%%     sys_conn:pack_send(ConnPid, 11601, pack_proto_msg(11601, {?sit_ok, <<>>, NewRole})),
%%     NewRole;
%% do_handle_sit({Type, {Id, SrvId}}, Role = #role{link = #link{conn_pid = ConnPid}, special = Special}) ->
%%     NewRole = Role#role{action = Type, special = [{?special_both_sit, Id, SrvId} | Special]},
%%     ?DEBUG("角色双修邀请成功2, 对方ID：~w", [{Id, SrvId}]),
%%     %% NewRole = looks:calc(NR3),
%%     map:role_update(NewRole),
%%     sys_conn:pack_send(ConnPid, 11601, pack_proto_msg(11601, {?sit_ok, <<>>, NewRole})),
%%     NewRole;
