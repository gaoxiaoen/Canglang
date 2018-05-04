%% --------------------------------------------------------------------
%% @doc 飞仙历练消息订阅
%% @author weihua@jieyou.cn
%% --------------------------------------------------------------------
-module(train_rss).
-export([
        rss/3
    ]).

-include("train.hrl").
-include("role.hrl").
-include("common.hrl").

%% 更新一个历练角色
rss(Mod, train_role_update, {TrainRole, Visitors}) ->
    train_mgr_common:update(Mod, train_role, TrainRole),
    refresh(refresh_sit_role, TrainRole, Visitors),
    {ok};

%% 更新一个历练角色
rss(Mod, train_role_update, TrainRole) ->
    train_mgr_common:update(Mod, train_role, TrainRole),
    {ok};

%% 更新历练状态
rss(Mod, update_train_state, TrainRole) ->
    train_mgr_common:update(Mod, train_role, TrainRole),
    refresh(train_time, TrainRole),
    {ok};

%% 角色第一次入住历练场
rss(Mod, role_settle, {NewTR, Visitor}) ->
    train_mgr_common:update(Mod, train_role, NewTR),
    train_mgr_common:update(Mod, train_visitor, Visitor),
    {ok};

%% 角色开始历练
rss(Mod, sit, {TrainRole, Visitors}) ->
    refresh(refresh_sit_role, TrainRole, Visitors),
    refresh(train_time, TrainRole),
    train_mgr_common:update(Mod, train_role, TrainRole),
    ok;

%% 删除角色历练信息(转移场区)
rss(Mod, delete_sit_info, {RoleId, Fid, Visitors}) ->
    refresh(delete_sit_role, {Fid, RoleId}, Visitors),
    train_mgr_common:leave(Mod, train_role, {Fid, RoleId}),
    ok;

%% 角色离开场区
rss(Mod, delete_train_role, {RoleId, Fid}) ->
    train_mgr_common:leave(Mod, train_role, {Fid, RoleId}),
    ok;

%% 新增一个游客
rss(Mod, visit, Visitor) ->
    train_mgr_common:update(Mod, train_visitor, Visitor),
    ok;

%% 被打劫  中途取消历练
rss(Mod, cancel_train, {TrainRole = #train_role{id = RoleId, grade = Lid, area = Aid}, Visitors}) ->
    refresh(delete_sit_info, {{Lid, Aid}, RoleId}, Visitors),
    train_mgr_common:update(Mod, train_role, TrainRole),
    ok;

%% 游客离开
rss(Mod, leave, {RoleId, Fid}) ->
    train_mgr_common:leave(Mod, train_visitor, {Fid, RoleId}),
    ok;

%% 增加一个劫匪
rss(Mod, update_rob, {NewRobRole, Visitors}) ->
    train_mgr_common:update(Mod, train_rob, NewRobRole),
    refresh(refresh_rob_role, NewRobRole, Visitors),
    ok;

%% 抗击劫匪打劫
rss(Mod, resist_rob, {TrainRole, Visitors}) ->
    train_mgr_common:update(Mod, train_role, TrainRole),
    refresh(refresh_sit_role, TrainRole, Visitors),
    ok;

%% 劫匪打劫成功 更新被打劫者
rss(Mod, rob_sale_trainer, TrainRole = #train_role{pid = Pid}) ->
    train_mgr_common:update(Mod, train_role, TrainRole),
    catch role:pack_send(Pid, 18903, {0, 0, 0, 0}),
    ok;

%% 劫匪打劫成功 更新劫匪
rss(Mod, rob_sale_rober, {#train_rob{id = RoleId = {Rid, Srvid}, grade = Lid, area = Aid}, Visitors}) ->
    train_mgr_common:leave(Mod, train_rob, {{Lid, Aid}, RoleId}),
    refresh(delete_rob_info, {Lid, Aid, Rid, Srvid}, Visitors),
    ok;

%% 劫匪被成功缉拿
rss(Mod, arrest_success, {TrainRole = #train_role{grade = Lid, area = Aid}, #train_rob{id = RobId = {Rid, Srvid}}, Visitors}) ->
    train_mgr_common:update(Mod, train_role, TrainRole),
    refresh(refresh_sit_role, TrainRole, Visitors),
    train_mgr_common:leave(Mod, train_rob, {{Lid, Aid}, RobId}),
    refresh(delete_rob_info, {Lid, Aid, Rid, Srvid}, Visitors),
    ok;

%% 更新各种次数
rss(Mod, all_times, TrainRole) ->
    train_mgr_common:update(Mod, train_role, TrainRole),
    ok;

%% 被打劫了
rss(Mod, be_robed, {TrainRole = #train_role{id = RoleId, grade = Lid, area = Aid}, Visitors}) ->
    train_mgr_common:update(Mod, train_role, TrainRole),
    refresh(delete_sit_role, {{Lid, Aid}, RoleId}, Visitors),
    ok;

%% 取消历练状态
rss(Mod, cancel_train_status, {TrainRole = #train_role{id = RoleId, grade = Lid, area = Aid}, Visitors}) ->
    train_mgr_common:update(Mod, train_role, TrainRole),
    refresh(delete_sit_role, {{Lid, Aid}, RoleId}, Visitors),
    ok;

rss(_Module, _Op, _Data) -> ok.

%% -----------------------------------------------------------------------------------
%% 单角色刷新
%% -----------------------------------------------------------------------------------
%% 历练状态
refresh(train_time, #train_role{pid = Pid, grade = Lid, area = Aid, train_time = Beg, rob_time = RT, pause_time = Ptime}) ->
    case Beg > 0 of
        true ->
            case RT > 0 of
                true ->
                    RemTime = case ?train_time_cost - (RT - Beg - Ptime) of
                        Diff when Diff > 0 -> Diff;
                        _ -> 0
                    end,
                    catch role:pack_send(Pid, 18903, {1, RemTime, Lid, Aid});
                false ->
                    RemTime = case ?train_time_cost - (util:unixtime() - Beg - Ptime) of
                        Diff when Diff > 0 -> Diff;
                        _ -> 0
                    end,
                    catch role:pack_send(Pid, 18903, {2, RemTime, Lid, Aid})
            end;
        false ->
            catch role:pack_send(Pid, 18903, {0, 0, 0, 0})
    end,
    ok.

%% -----------------------------------------------------------------------------------
%% 单场区刷新
%% -----------------------------------------------------------------------------------
%% 刷新增加一个历练者
refresh(refresh_sit_role, #train_role{rob_time = Rtime}, _) when Rtime > 0 ->
    ok;
refresh(refresh_sit_role, #train_role{train_time = Time}, _) when Time =:= 0 ->
    ok;
refresh(refresh_sit_role, #train_role{id = {Rid, Srvid}, name = Name, pid = RolePid, pause_time = Ptime, 
        train_time = Beg, grade = Lid, area = Aid, fight = F, x = X, y = Y, sex = Sex, lev = Lev, type = Type, career = Career}, 
    Visitors) ->

    Online = case is_pid(RolePid) of
        true -> 1;
        _ -> 0
    end,
    LastTime = case util:unixtime() - Beg - Ptime of
        Diff when Diff > ?train_time_cost -> ?train_time_cost;
        Diff when Diff > 0 -> Diff;
        _ -> 0
    end,
    Data = {Lid, Aid, X, Y, Rid, Srvid, Name, Online, 0, F, LastTime, Sex, Lev, Type, Career},
    Fun = fun(#train_visitor{pid = Pid}) -> catch role:pack_send(Pid, 18912, Data) end,
    lists:foreach(Fun, Visitors);

%% 删除一个历练者
refresh(delete_sit_role, {{Lid, Aid}, {Rid, Srvid}}, Visitors) ->
    Data = {Lid, Aid, Rid, Srvid},
    Fun = fun(#train_visitor{pid = Pid}) -> catch role:pack_send(Pid, 18914, Data) end,
    lists:foreach(Fun, Visitors);

%% 刷新增加一个劫匪
refresh(refresh_rob_role, #train_rob{id = {Rid, Srvid}, oid = {Oid, Osrvid}, name = Name, grade = Lid, area = Aid, viaxy = Viaxy, desxy = Desxy, time = Beg,
            fight = F, x = X, y = Y, sex = Sex, career = Career, speed = Speed, des = Des, busy = Busy, arrest = Atime, pause = Ptime, soul = Soul}, 
    Visitors) ->
    Data = case Busy of
        ?false ->
            Time = util:unixtime() - Beg - Ptime,
            {NX, NY} = train_common:count_new_pos({X, Y}, Viaxy, Desxy, Time),
            {Lid, Aid, Rid, Srvid, Name, F, Sex, Speed, NX, NY, Des, 0, Soul, Career, Oid, Osrvid};
        _ ->
            Time = Atime - Beg - Ptime,
            {NX, NY} = train_common:count_new_pos({X, Y}, Viaxy, Desxy, Time),
            {Lid, Aid, Rid, Srvid, Name, F, Sex, Speed, NX, NY, Des, 1, Soul, Career, Oid, Osrvid}
    end,
    Fun = fun(#train_visitor{pid = Pid}) -> catch role:pack_send(Pid, 18913, Data) end,
    lists:foreach(Fun, Visitors);

%% 删除一个劫匪
refresh(delete_rob_info, Data, Visitors) ->
    Fun = fun(#train_visitor{pid = Pid}) -> catch role:pack_send(Pid, 18915, Data) end,
    lists:foreach(Fun, Visitors);

refresh(_Cmd, _, _) ->
    ?ERR("收到错误的单场区刷新命令 [~w]", [_Cmd]),
    ok.
