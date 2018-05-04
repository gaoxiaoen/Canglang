%% -------------------------------------------------------------------------------------------------------------
%% 飞仙历练进程执行代码
%% -------------------------------------------------------------------------------------------------------------
-module(train_server).
-export([check_need_assign/3
        ,sit/3
        ,if_sit_able/3
        ,if_change_grade_able/3
        ,rob/3
        ,arrest/3
        ,leave/3
        ,rob_failed/3
        ,i_am_the_won_rob/3
        ,i_resist_the_rob/3
        ,rob_complete/3
        ,arrest_failed/3
        ,arrest_success/5
        ,arrest_resisted/4
        ,arrest_complete/3
        ,login/4
        ,logout/3
        ,role_status/4
        ,train_info/3
        ,rob_info/3
        ,delete_sit_info/3
        ,enter/4
        ,visit/4
        ,arrest/5,
        rob/5
        ,check_robbing_dead_status/3
        ,check_be_rob_dead_status/3
        ,check_rob_dead_status/3
        ,check_train_gain/2
        ,rob_sale/4
        ,role_settle/3
        ,uplas/5
        ,maintain/2
    ]).

-include("train.hrl").
-include("common.hrl").
-include("mail.hrl").

%%-----------------------------------------------------------
%% 同步请求
%%-----------------------------------------------------------
%% @spec check_need_assign(Mod, RoleId, TrainField) -> {reply, Reply}
%% Mod = train | train_center
%% RoleId = {integer(), integer()}
%% TrainField = #train_field{}
%% @doc 战力发生变化，查看是否应该重新分配历练场
check_need_assign(_Mod, RoleId, #train_field{roles = Roles}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false -> {reply, {ok, grade}};
        #train_role{train_time = 0} -> {reply, {ok, grade}};
        _ -> {reply, {ok, pass}}
    end.

%% 进行历练
sit(_Mod, _TR, #train_field{xys = []}) ->
    {reply, {false, ?L(<<"该场区已满，请切换其他场区">>)}};
sit(Mod, _TR, #train_field{lid = Lid, num = Num}) when Num >= ?train_field_max_num ->
    train_mgr_common:check_area_load(Mod, Lid),
    {reply, {false, ?L(<<"该场区已满，请切换其他场区">>)}};
sit(Mod, TR = #train_role{name = Name, id = RoleId}, State = #train_field{id = {Lid, Aid}, pid = Pid, num = Num, roles = Roles, visitors = Visitors, xys = [{X, Y} | Xys]}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        #train_role{robbing = RobBing} when RobBing > 0 ->
            train_common:info(Mod, Pid, {check_robbing_dead_status, RoleId}),
            {reply, {false, ?L(<<"您正在打劫(缉拿), 不可以进行历练">>)}};
        #train_role{train_time = Time} when Time =/= 0 ->
            {reply, {false, ?L(<<"您已经在历练中">>)}};
        #train_role{} ->
            NewTR = TR#train_role{grade = Lid, area = Aid, x = X, y = Y, train_time = util:unixtime()}, 
            NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewTR),
            NewState = State#train_field{roles = NewRoles, xys = Xys, num = Num + 1},
            train_rss:rss(Mod, sit, {NewTR, Visitors}),
            train_common:notice(train, {Name, Visitors}),
            train_mgr_common:update_area_num(Mod, Lid, Aid, Num + 1),
            {reply, {ok, {Lid, Aid}}, NewState};
        false ->
            NewTR = TR#train_role{grade = Lid, area = Aid, train_time = util:unixtime(), x = X, y = Y},
            NewRoles = [NewTR | Roles],
            NewState = State#train_field{roles = NewRoles, xys = Xys, num = Num + 1},
            train_common:notice(train, {Name, Visitors}),
            train_rss:rss(Mod, sit, {NewTR, Visitors}),
            train_mgr_common:update_area_num(Mod, Lid, Aid, Num + 1),
            {reply, {ok, {Lid, Aid}}, NewState}
    end.

%% 查询是否可以进行历练(切换场区历练)
if_sit_able(Mod, RoleId, #train_field{pid = Pid, roles = Roles}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        #train_role{train_time = Time} when Time =/= 0 ->
            {reply, {false, ?L(<<"您已经在历练中">>)}};
        #train_role{robbing = RobBing} when RobBing > 0 ->
            train_common:info(Mod, Pid, {check_robbing_dead_status, RoleId}),
            {reply, {false, ?L(<<"您正在打劫(缉拿)">>)}};
        _ ->
            {reply, true}
    end.

%% 检测是否可以更换段位
if_change_grade_able(Mod, RoleId, #train_field{pid = Pid, roles = Roles}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        #train_role{train_time = Time} when Time =/= 0 ->
            {reply, false};
        #train_role{robbing = RobBing} when RobBing > 0 ->
            train_common:info(Mod, Pid, {check_robbing_dead_status, RoleId}),
            {reply, false};
        _ ->
            {reply, true}
    end.

%% 请求打劫
rob(Mod, RoleId, State = #train_field{pid = Pid, roles = Roles}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            {reply, {false, ?L(<<"您飞仙历练数据有问题">>)}};
        #train_role{robbing = RobBing} when RobBing > 0 ->
            train_common:info(Mod, Pid, {check_robbing_dead_status, RoleId}),
            {reply, {false, ?L(<<"您正在打劫(缉拿)中！">>)}};
        Trole ->
            NewRole = Trole#train_role{robbing = util:unixtime()},
            NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewRole),
            NewState = State#train_field{roles = NewRoles},
            train_rss:rss(Mod, all_times, NewRole),
            {reply, ok, NewState}
    end.

%% 请求缉拿
arrest(Mod, RoleId, State = #train_field{pid = Pid, roles = Roles}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            {reply, {false, ?L(<<"您飞仙历练数据有问题">>)}};
        #train_role{robbing = RobBing} when RobBing > 0 ->
            train_common:info(Mod, Pid, {check_robbing_dead_status, RoleId}),
            {reply, {false, ?L(<<"您正在缉拿(打劫)中！">>)}};
        Trole ->
            NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, Trole#train_role{robbing = util:unixtime()}),
            NewState = State#train_field{roles = NewRoles},
            {reply, ok, NewState}
    end.

%% 玩家离开历练场
leave(Mod, RoleId, State = #train_field{id = Fid, visitors = Visitors}) ->
    NewVisitors = lists:keydelete(RoleId, #train_visitor.id, Visitors),
    NewState = State#train_field{visitors = NewVisitors},
    train_rss:rss(Mod, leave, {RoleId, Fid}),
    {ok, NewState}.

%% 打劫发起失败
rob_failed(_Mod, RoleId, State = #train_field{roles = Roles}) -> 
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            {ok};
        Role ->
            NewRole = Role#train_role{robbing = ?false},
            NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewRole),
            NewState = State#train_field{roles = NewRoles},
            {ok, NewState}
    end.

%% 打劫主动方胜利了, 被动方输了
i_am_the_won_rob(Mod, RobRole = #train_rob{name = RobName, id = RobId, oid = ORoleId, fight = Frob}, State = #train_field{id = {Lid, Aid}, robs = Robs, roles = Roles, visitors = Visitors, pid = Pid}) ->
    case lists:keyfind(ORoleId, #train_role.id, Roles) of
        false ->
            ?ERR("打劫成功后找不到被打劫者数据, [~w]", [ORoleId]),
            {ok};
        Role = #train_role{name = RoleName, x = X, y = Y, type = Type, lev = Lev, train_time = Beg, pause_time = Ptime, rob_time = Rtime, loss = Loss, fight = Frole} ->
            Des = util:rand(1, 4),
            Gap = train_common:count_train_time(Beg, Rtime, Ptime),
            Soul = fx_train_data:soul(Lev, Type),
            MaxRobSoul = ?rob_soul_max(Soul),
            RobSoul = ?rob_soul_gain(Lid, Gap, Soul, Frole, Frob),
            GainSoul = case RobSoul + Loss > MaxRobSoul of
                true -> MaxRobSoul - Loss;
                false -> RobSoul
            end,
            {Desxy, Viaxy} = fx_train_data:path(Des),
            Distance = train_common:distance({X,Y}, Viaxy) + train_common:distance(Viaxy, Desxy),
            EvaluateTime = round(Distance/?rob_speed),
            Now = util:unixtime(),
            %% TODO
            erlang:send_after(EvaluateTime * 1000, Pid, {rob_sale, RobId, Now}),
            NewRobRole = RobRole#train_rob{grade = Lid, area = Aid, x = X, y = Y, speed = ?rob_speed, des = Des, time = Now, soul = GainSoul, run = Now, desxy = Desxy, viaxy = Viaxy, cost = EvaluateTime},
            NewRobs = [NewRobRole | lists:keydelete(RobId, #train_rob.id, Robs)],  %% 这里先清理，后加，防止清理死数据造成多份rob数据
            NewRole = Role#train_role{loss = Loss + GainSoul},
            NewRoles = lists:keyreplace(ORoleId, #train_role.id, Roles, NewRole),
            NewState = State#train_field{robs = NewRobs, roles = NewRoles},
            train_rss:rss(Mod, update_rob, {NewRobRole, Visitors}),
            train_rss:rss(Mod, be_robed, {NewRole, Visitors}),
            train_common:rob_hearsay(Mod, {Lid, Aid}, {RobId, RobName}, {ORoleId, RoleName}),
            train_common:notice(rob, {RobName, RoleName, Visitors}),
            {ok, NewState}
    end.

%% 打劫被动方胜利了，主动方输了
i_resist_the_rob(Mod, RoleId, State = #train_field{roles = Roles, visitors = Visitors}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            ?ERR("机器人抵抗了打劫后, 找不到自己数据"),
            {ok};
        Role = #train_role{rob_time = Rt, pause_time = Ptime} ->
            NewRole = Role#train_role{rob_time = 0, pause_time = util:unixtime() - Rt + Ptime},
            NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewRole),
            NewState = State#train_field{roles = NewRoles},
            train_rss:rss(Mod, resist_rob, {NewRole, Visitors}),
            {ok, NewState}
    end.

%% 打劫完成
rob_complete(Mod, RoleId, State = #train_field{roles = Roles}) -> 
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            {ok};
        Role ->
            NewRole = Role#train_role{robbing = ?false},
            NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewRole),
            NewState = State#train_field{roles = NewRoles},
            train_rss:rss(Mod, update_train_state, NewRole),
            {ok, NewState}
    end.

%% 缉拿发起失败
arrest_failed(_Mod, RoleId, State = #train_field{roles = Roles}) -> 
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            {ok};
        Role ->
            NewRole = Role#train_role{robbing = ?false},
            NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewRole),
            NewState = State#train_field{roles = NewRoles},
            {ok, NewState}
    end.

%% 缉拿主动方胜利, 被动方失败
arrest_success(Mod, Aname, ArrestId, RobId, State = #train_field{id = {Lid, Aid}, roles = Roles, robs = Robs, visitors = Visitors}) ->
    case lists:keyfind(RobId, #train_rob.id, Robs) of
        false ->
            {ok};
        Rob = #train_rob{oid = Oid, soul = Soul, fid = RobFid, name = RobName} ->
            case lists:keyfind(Oid, #train_role.id, Roles) of
                false ->
                    {ok};
                Role = #train_role{rob_time = Rtime, pause_time = Ptime, pid = Pid, train_time = Beg} ->
                    train_common:arrest_success_mail(Mod, {ArrestId, Aname}, {RobId, RobName}, Soul),
                    NewRobs = lists:keydelete(RobId, #train_rob.id, Robs),
                    NewPtime = Ptime + util:unixtime() - Rtime,
                    NewRole = Role#train_role{rob_time = 0, pause_time = NewPtime},
                    RemTime = case ?train_time_cost - (util:unixtime() - Beg - NewPtime) of
                        Diff when Diff > 0 -> Diff;
                        _ -> 0
                    end,
                    catch role:pack_send(Pid, 18903, {2, RemTime, Lid, Aid}),
                    NewRoles = lists:keyreplace(Oid, #train_role.id, Roles, NewRole),
                    NewState = State#train_field{roles = NewRoles, robs = NewRobs},
                    train_rss:rss(Mod, arrest_success, {NewRole, Rob, Visitors}), 
                    catch train_common:info(Mod, RobFid, {rob_complete, RobId}),
                    train_common:notice(arrest, {Aname, RobName, Visitors}),
                    {ok, NewState}
            end
    end.

%% 缉拿主动方失败, 被动方胜利
arrest_resisted(Mod, _ArrestId, RobId, State = #train_field{robs = Robs, visitors = Visitors, pid = Pid}) ->
    case lists:keyfind(RobId, #train_rob.id, Robs) of
        false ->
            {ok};
        RobRole  = #train_rob{time = Beg, pause = Ptime, arrest = Atime, cost = Cost} ->
            Now = util:unixtime(),
            NewPtime = Now - Atime + Ptime,
            NewAfterTime = Cost - (Now - Beg - NewPtime),
            erlang:send_after(NewAfterTime * 1000, Pid, {rob_sale, RobId, Now}),
            NewRob = RobRole#train_rob{busy = ?false, run = Now, pause = NewPtime, arrest = 0},
            NewRobs = lists:keyreplace(RobId, #train_rob.id, Robs, NewRob),
            NewState = State#train_field{robs = NewRobs},
            train_rss:rss(Mod, update_rob, {NewRob, Visitors}),
            {ok, NewState}
    end.

%% 缉拿完成
arrest_complete(Mod, RoleId, State = #train_field{roles = Roles}) -> 
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            {ok};
        Role ->
            NewRole = Role#train_role{robbing = ?false},
            NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewRole),
            NewState = State#train_field{roles = NewRoles},
            train_rss:rss(Mod, train_role_update, NewRole),
            {ok, NewState}
    end.

%% 玩家登陆
login(Mod, RoleId, Pid, State = #train_field{roles = Roles, visitors = Visitors}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            {ok};
        Role ->
            NewRole = Role#train_role{pid = Pid},
            NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewRole),
            NewState = State#train_field{roles = NewRoles},
            train_rss:rss(Mod, train_role_update, {NewRole, Visitors}),
            {ok, NewState}
    end.

%% 玩家登出
logout(Mod, RoleId, State = #train_field{id = Fid, roles = Roles, visitors = Visitors}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            {ok};
        Role ->
            NewRole = Role#train_role{pid = 0},
            NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewRole),
            NewVisitors = lists:keydelete(RoleId, #train_visitor.id, Visitors),
            NewState = State#train_field{roles = NewRoles, visitors = NewVisitors},
            train_rss:rss(Mod, leave, {RoleId, Fid}),
            train_rss:rss(Mod, train_role_update, {NewRole, Visitors}),
            {ok, NewState}
    end.

%% 获取角色修炼状态
role_status(_Mod, RoleId, ConnPid, #train_field{id = {Lid, Aid}, roles = Roles}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            sys_conn:pack_send(ConnPid, 18903, {0, 0, 0, 0}),
            {ok};
        #train_role{train_time = Beg, rob_time = RT, pause_time = Ptime} ->
            case Beg > 0 of
                true ->
                    case RT > 0 of
                        true ->
                            RemTime = case ?train_time_cost - (RT - Beg - Ptime) of
                                Diff when Diff > 0 -> Diff;
                                _ -> 0
                            end,
                            sys_conn:pack_send(ConnPid, 18903, {1, RemTime, Lid, Aid});
                        false ->
                            RemTime = case ?train_time_cost - (util:unixtime() - Beg - Ptime) of
                                Diff when Diff > 0 -> Diff;
                                _ -> 0
                            end,
                            sys_conn:pack_send(ConnPid, 18903, {2, RemTime, Lid, Aid})
                    end;
                false ->
                    sys_conn:pack_send(ConnPid, 18903, {0, 0, 0, 0})
            end,
            {ok}
    end.

%% 获取指定场区历练者信息
train_info(_Mod, ConnPid, #train_field{id = {Lid, Aid}, roles = Roles}) ->
    Fun = fun(#train_role{id = {Rid, Srvid}, name = Name, pid = Pid, fight = F, train_time = Time, x = X, y = Y,
                rob_time = RobTime, sex = Sex, lev = Lev, type = Type, career = Career, pause_time = Ptime}, Acc) ->
            case Time > 0 andalso RobTime =:= 0 of
                true ->
                    OnLine = case is_pid(Pid) of
                        true -> 1;
                        false -> 0
                    end,
                    LT = case util:unixtime() - Time - Ptime of
                        Diff when Diff > ?train_time_cost -> ?train_time_cost;
                        Diff when Diff > 0 -> Diff;
                        _ -> 0
                    end,
                    [{X, Y, Rid, Srvid, Name, OnLine, 0, F, LT, Sex, Lev, Type, Career} | Acc];
                _ ->
                    Acc
            end
    end,
    RoleInfo = lists:foldl(Fun, [], Roles),
    sys_conn:pack_send(ConnPid, 18904, {Lid, Aid, RoleInfo}),
    {ok}.

%% 获取历练者信息 劫匪
rob_info(_Mod, ConnPid, #train_field{id = {Lid, Aid}, robs = Robs}) ->
    Fun = fun(#train_rob{id = {Rid, Srvid}, oid = {Oid, Osrvid}, name = Name, x = X, y = Y, busy = Busy, viaxy = Viaxy, desxy = Desxy,
                des = Des, speed = Speed, fight = F, sex = Sex, career = Career, time = Beg, soul = Soul, pause = Ptime, arrest = Atime}) ->
            case Busy of
                ?false ->
                    Time = util:unixtime() - Beg - Ptime,
                    {NX, NY} = train_common:count_new_pos({X, Y}, Viaxy, Desxy, Time),
                    {Rid, Srvid, Name, F, Sex, Speed, NX, NY, Des, 0, Soul, Career, Oid, Osrvid};
                _ ->
                    Time = Atime - Beg - Ptime,
                    {NX, NY} = train_common:count_new_pos({X, Y}, Viaxy, Desxy, Time),
                    {Rid, Srvid, Name, F, Sex, Speed, NX, NY, Des, 1, Soul, Career, Oid, Osrvid}
            end
    end,
    RoleInfo = lists:map(Fun, Robs),
    sys_conn:pack_send(ConnPid, 18907, {Lid, Aid, RoleInfo}),
    {ok}.

%% 清除玩家的历练信息
delete_sit_info(Mod, RoleId, State = #train_field{id = Fid, roles = Roles, visitors = Visitors, xys = Xys}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            {ok};
        #train_role{x = X, y = Y} when X =:= 0 orelse Y =:= 0 ->
            NewRoles = lists:keydelete(RoleId, #train_role.id, Roles),
            NewState = State#train_field{roles = NewRoles},
            train_rss:rss(Mod, delete_train_role, {RoleId, Fid}),
            {ok, NewState};
        #train_role{x = X, y = Y} ->    %% TODO 理论上这里玩家没有在历练，不会分配 X,Y
            NewRoles = lists:keydelete(RoleId, #train_role.id, Roles),
            NewXys = case lists:member({X, Y}, Xys) of
                true -> Xys;
                false -> [{X, Y} | Xys]
            end,
            NewState = State#train_field{roles = NewRoles, xys = NewXys},
            train_rss:rss(Mod, delete_sit_info, {RoleId, Fid, Visitors}),
            {ok, NewState}
    end.

%% 进入默认历练场
enter(Mod, RoleId, RolePid, State = #train_field{id = Fid, visitors = Visitors, roles = Roles}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            ?DEBUG("角色身上数据过期，需要重新分配场区"),
            catch role:apply(async, RolePid, {train_common, async_assign, [Mod]}),
            {ok};
        #train_role{name = _Name} ->
            ?DEBUG("[~w]角色 [~w,~s,~s] 进入 飞仙历练 第 ~w 场 ~w 区 ~s", [Mod, element(1, RoleId), element(2, RoleId), _Name, element(1, Fid), element(2, Fid), fx_train_data:lid_to_name(element(1, Fid))]),
            case lists:keyfind(RoleId, #train_visitor.id, Visitors) of
                false ->
                    Visitor = #train_visitor{id = RoleId, pid = RolePid, fid = Fid, ctime = util:unixtime()},
                    NewVisitors = [Visitor | Visitors],
                    NewState = State#train_field{visitors = NewVisitors},
                    train_rss:rss(Mod, visit, Visitor),
                    {ok, NewState};
                _OldVisitor ->
                    Visitor = #train_visitor{id = RoleId, pid = RolePid, fid = Fid, ctime = util:unixtime()},
                    NewVisitors = lists:keyreplace(RoleId, #train_visitor.id, Visitors, Visitor),
                    NewState = State#train_field{visitors = NewVisitors},
                    train_rss:rss(Mod, visit, Visitor),
                    {ok, NewState}
            end
    end.

%% 玩家进入指定历练场
visit(Mod, RoleId, RolePid, State = #train_field{id = Fid, visitors = Visitors}) ->
    ?DEBUG("[~w]角色 [~w,~s] 参观 飞仙历练 第 ~w 场 ~w 区 ~s", [Mod, element(1, RoleId), element(2, RoleId), element(1, Fid), element(2, Fid), fx_train_data:lid_to_name(element(1, Fid))]),
    case lists:keyfind(RoleId, #train_visitor.id, Visitors) of
        false ->
            Visitor = #train_visitor{id = RoleId, pid = RolePid, fid = Fid, ctime = util:unixtime()},
            NewVisitors = [Visitor | Visitors],
            NewState = State#train_field{visitors = NewVisitors},
            train_rss:rss(Mod, visit, Visitor),
            {ok, NewState};
        _OldVisitor ->
            Visitor = #train_visitor{id = RoleId, pid = RolePid, fid = Fid, ctime = util:unixtime()},
            NewVisitors = lists:keyreplace(RoleId, #train_visitor.id, Visitors, Visitor),
            NewState = State#train_field{visitors = NewVisitors},
            train_rss:rss(Mod, visit, Visitor),
            {ok, NewState}
    end.

%% 打劫
rob(Mod, Rid, Srvid, Pid, State = #train_field{roles = Roles, pid = TrainPid}) -> 
    case lists:keyfind({Rid,Srvid}, #train_role.id, Roles) of
        false ->
            catch role:apply(async, Pid, {train_common, async_rob, [false]}),
            {ok};
        #train_role{rob_time = Time} when Time > 0 ->
            catch role:pack_send(Pid, 18908, {?false, ?L(<<"对方处于被打劫状态，不可以再次打劫">>)}),
            catch role:apply(async, Pid, {train_common, async_rob, [false]}),
            {ok};
        TrainRole = #train_role{pid = 0} ->
            erlang:send_after(?dead_status_gap * 1000, TrainPid, {check_be_rob_dead_status, {Rid, Srvid}}),
            NewRole = TrainRole#train_role{rob_time = util:unixtime()},
            NewRoles = lists:keyreplace({Rid, Srvid}, #train_role.id, Roles, NewRole),
            NewState = State#train_field{roles = NewRoles},
            train_rss:rss(Mod, train_role_update, NewRole),
            catch role:apply(async, Pid, {train_common, async_rob, [TrainRole]}),
            {ok, NewState};
        _ ->
            catch role:pack_send(Pid, 18908, {?false, ?L(<<"这位仙友在线，不可乱下手！">>)}),
            catch role:apply(async, Pid, {train_common, async_rob, [false]}),
            {ok}
    end.

%% 缉拿
arrest(Mod, Rid, Srvid, Pid, State = #train_field{robs = Roles, visitors = Visitors, pid = TrainPid}) -> 
    case lists:keyfind({Rid,Srvid}, #train_rob.id, Roles) of
        false ->
            catch role:apply(async, Pid, {train_common, async_arrest, [false]}),
            {ok};
        #train_rob{busy = ?true} ->
            train_common:info(Mod, TrainPid, {check_rob_dead_status, {Rid, Srvid}}),
            catch role:pack_send(Pid, 18908, {?false, ?L(<<"对方处于战斗中，不可以同时缉拿">>)}),
            catch role:apply(async, Pid, {train_common, async_arrest, [false]}),
            {ok};
        RobRole ->
            NewRole = RobRole#train_rob{busy = ?true, run = 0, arrest = util:unixtime()},
            NewRoles = lists:keyreplace({Rid, Srvid}, #train_rob.id, Roles, NewRole),
            NewState = State#train_field{robs = NewRoles},
            catch role:apply(async, Pid, {train_common, async_arrest, [RobRole]}),
            train_rss:rss(Mod, update_rob, {NewRole, Visitors}),
            {ok, NewState}
    end.

%% 清理异常一直处于被缉拿状态劫匪角色
check_rob_dead_status(Mod, RobId, State = #train_field{robs = Robs, visitors = Visitors}) ->
    case lists:keyfind(RobId, #train_rob.id, Robs) of
        Rob = #train_rob{busy = ?true, arrest = Atime, soul = RobSoul, name = RobName} ->
            case util:unixtime() - Atime > ?dead_status_gap of
                true -> %% 需要自动解锁;
                    %% TODO
                    train_common:rob_success_mail(Mod, RobId, RobName, RobSoul),
                    NewRobs = lists:keydelete(RobId, #train_rob.id, Robs),
                    NewState = State#train_field{robs = NewRobs},
                    train_rss:rss(Mod, rob_sale_rober, {Rob, Visitors}),
                    {ok, NewState};
                _ ->
                    {ok}
            end;
        _ ->
            {ok}
    end.

%% 清理异常一直处于打劫(缉拿)状态角色
check_robbing_dead_status(_Mod, RoleId, State = #train_field{roles = Roles}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        Role = #train_role{robbing = RobBing} when RobBing > 0 ->
            case util:unixtime() - RobBing > ?dead_status_gap of
                true -> %% 解锁
                    NewRole = Role#train_role{robbing = ?false},
                    NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewRole),
                    NewState = State#train_field{roles = NewRoles},
                    {ok, NewState};
                _ ->
                    {ok}
            end;
        _ ->
            {ok}
    end.

%% 清理异常一直处于被打劫状态状态历练者
check_be_rob_dead_status(Mod, RoleId, State = #train_field{roles = Roles}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        Role = #train_role{rob_time = Rtime} when Rtime > 0 ->
            Now = util:unixtime(),
            case Now - Rtime >= ?dead_status_gap of
                true ->
                    NewRole = Role#train_role{rob_time = 0},
                    NewRoles = lists:keyreplace(RoleId, #train_role.id, Roles, NewRole),
                    NewState = State#train_field{roles = NewRoles},
                    train_rss:rss(Mod, train_role_update, NewRole),
                    {ok, NewState};
                _ ->
                    {ok}
            end;
        _ ->
            {ok}
    end.

%% 结算奖励
check_train_gain(Mod, State = #train_field{id = {Lid, Aid}, roles = Roles, visitors = Visitors, xys = Xys, num = Num}) ->
    {NewRoles, NewXys, DoneRoles, NeedUpRole} = train_common:train_gain(Mod, Roles, Xys),
    NewNum = Num - length(DoneRoles),
    NewState = State#train_field{roles = NewRoles, xys = NewXys, num = NewNum},
    lists:foreach(fun(Role) -> train_rss:rss(Mod, cancel_train_status, {Role, Visitors}) end, DoneRoles),
    lists:foreach(fun(Role) -> train_rss:rss(Mod, train_role_update, Role) end, NeedUpRole),
    case Num =:= NewNum of
        true -> ok;
        false -> train_mgr_common:update_area_num(Mod, Lid, Aid, NewNum)
    end,
    {ok, NewState}.

%% 打劫交付, 系统
rob_sale(Mod, RoleId, CheckTime, State = #train_field{id = {Lid, Aid}, roles = Roles, robs = Robs, visitors = Visitors, xys = Xys, num = Num}) ->
    case lists:keyfind(RoleId, #train_rob.id, Robs) of
        false ->
            ?DEBUG("机器人交付打劫, 找不到自己数据"),
            {ok};
        Rob = #train_rob{oid = {Oid, Osrvid}, x = X, y = Y, fid = RobFid, run = CheckTime} ->
            case lists:keyfind({Oid, Osrvid}, #train_role.id, Roles) of
                false ->
                    ?ERR("机器人交付打劫, 找不到打劫对象数据"),
                    {ok};
                TRole ->
                    train_common:rob_gain(Mod, Rob, TRole),
                    NewTRole = TRole#train_role{train_time = 0, rob_time = 0, pause_time = 0, x = 0, y = 0},
                    NewRoles = lists:keyreplace({Oid, Osrvid}, #train_role.id, Roles, NewTRole),
                    NewRobs = lists:keydelete(RoleId, #train_rob.id, Robs),
                    train_rss:rss(Mod, rob_sale_trainer, NewTRole),
                    train_rss:rss(Mod, rob_sale_rober, {Rob, Visitors}),
                    NewXys = case lists:member({X, Y}, Xys) of
                        true -> Xys;
                        false -> [{X, Y} | Xys]
                    end,
                    NewState = State#train_field{roles = NewRoles, robs = NewRobs, xys = NewXys, num = Num - 1},
                    catch train_common:info(Mod, RobFid, {rob_complete, RoleId}),
                    train_mgr_common:update_area_num(Mod, Lid, Aid, Num - 1),
                    {ok, NewState}
            end;
        _ ->
            ?DEBUG("机器人交付打劫, 时间不匹配，已忽略"),
            {ok}
    end.

%% 角色重新分配场区
role_settle(Mod, TR = #train_role{id = RoleId = {_Rid, _Srvid}, name = _Name, pid = RolePid}, State = #train_field{id = {Lid, Aid}, roles = Roles, visitors = Visitors}) ->
    case lists:keyfind(RoleId, #train_role.id, Roles) of
        false ->
            ?DEBUG("[~w]角色 [~w,~s,~s] 入驻 飞仙历练 第 ~w 场 ~w 区 ~s", [Mod, _Rid, _Srvid, _Name, Lid, Aid, fx_train_data:lid_to_name(Lid)]),
            NewTR = TR#train_role{grade = Lid, area = Aid},
            NewRoles = [NewTR | Roles],
            Visitor = #train_visitor{id = RoleId, pid = RolePid, fid = {Lid, Aid}, ctime = util:unixtime()},
            NewVisitors = [Visitor | Visitors],
            NewState = State#train_field{roles = NewRoles, visitors = NewVisitors},
            train_rss:rss(Mod, role_settle, {NewTR, Visitor}),
            catch role:apply(async, RolePid, {train_common, update_role_train, [{Lid, Aid}, Mod]}),
            {ok, NewState};
        _OldTR  ->
            ?DEBUG("角色 {~w, ~s, ~s} 第一次分配到的第 ~w 场 ~w 区，但该场区已有该角色数据", [_Rid, _Srvid, _Name, Lid, Aid]),
            NewTR = TR#train_role{grade = Lid, area = Aid},
            NewRoles = [NewTR | lists:keydelete(RoleId, #train_role.id, Roles)],
            Visitor = #train_visitor{id = RoleId, pid = RolePid, fid = {Lid, Aid}, ctime = util:unixtime()},
            NewVisitors = [Visitor | lists:keydelete(RoleId, #train_visitor.id, Visitors)],
            NewState = State#train_field{visitors = NewVisitors, roles = NewRoles},
            train_rss:rss(Mod, role_settle, {NewTR, Visitor}),
            catch role:apply(async, RolePid, {train_common, update_role_train, [{Lid, Aid}, Mod]}),
            {ok, NewState}
    end.

%% 更新场区状态
uplas(Mod, Lid, Aid, Num, #train_field{visitors = Visitors}) ->
    train_common:refresh_area_status(Mod, Lid, Aid, Num, Visitors),
    {ok}.

%% 维护
maintain(_Mod, State = #train_field{visitors = Visitors}) ->
    Now = util:unixtime(),
    NewVisitors = lists:foldl(
        fun(TV = #train_visitor{ctime = Ctime}, Acc) ->
                case Now - Ctime > ?dead_status_gap of
                    true -> Acc;
                    false -> [TV|Acc]
                end
        end, [], Visitors),
    {ok, State#train_field{visitors = NewVisitors}}.
