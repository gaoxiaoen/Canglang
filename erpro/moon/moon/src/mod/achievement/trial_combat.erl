%%----------------------------------------------------
%% 试炼场挑战
%% @author qingxuan
%%----------------------------------------------------
-module(trial_combat).
-export([
    login/1
    ,start/2
    ,over/3
    ,leave/1
    ,leave_map/1
    ,reenter_map/1
]).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("achievement.hrl").
-include("pos.hrl").
-include("npc.hrl").
-include("combat.hrl").
-include("trial.hrl").

-define(leave_pos_x, 430).
-define(leave_pos_y, 530).

login(Role = #role{event = Event, pos = #pos{map = MapBaseId}}) ->
    case Event =:= ?event_trial andalso not trial_data:is_trial_map(MapBaseId) of
        true -> %% 防止数据错误
            Role#role{event = ?event_no};
        _ ->
            Role
    end.

start(_Trial = #trial_base{id = TrialId, map = TrialMapId, npc = TrialNpcId}, 
        Role = #role{link = #link{conn_pid = ConnPid}, pos = #pos{map = MapId}}) ->
    %%
    case npc_data:get(TrialNpcId) of
        {ok, NpcBase} ->
            NpcPos = #pos{
                map = TrialMapId,
                x = ?trial_right_pos_x, 
                y = ?combat_upper_pos_y
            },
            Npc = npc_convert:base_to_npc(1, NpcBase, NpcPos),
            case npc_convert:do(to_fighter, Npc) of
                {ok, NpcCF} ->
                    Role1 = case MapId =/= TrialMapId of %% 重新战斗
                        true ->
                            Role0 = enter_map(Role#role{event = ?event_trial}, TrialMapId),  %% 进地图
                            MapNpc = npc_convert:do(to_map_npc, Npc),
                            map:send_npc_enter_msg(ConnPid, MapNpc), %% 发进入地图包
                            Role0;  
                        false ->
                            Role
                    end,
                    case combat_type:check(?combat_type_trial, Role1, NpcCF) of
                        true ->
                            Special1 = Role1#role.special,
                            Role2 = Role1#role{special = [{?special_trial_id, TrialId, <<"">>}] ++ Special1},
                            {ok, Role2};
                        {false, ErrMsg} ->
                            {error, ErrMsg, leave_map(Role1#role{event = ?event_no})}
                    end;
                _ ->
                    {error, ?MSGID(<<"怪物不存在">>), Role}
            end;
        _ ->
           {error, ?MSGID(<<"怪物不存在">>), Role}
    end.
 
%% -> #role{}
enter_map(Role = #role{id = {Rid, SrvId}, pid = RolePid, link = #link{conn_pid = ConnPid}, pos = Pos = #pos{map = MapId, map_pid = MapPid, x = X, y = Y}}, TrialMapId) ->
    map:role_leave(MapPid, RolePid, Rid, SrvId, X, Y), 
    sys_conn:pack_send(ConnPid, 10110, {TrialMapId, ?trial_left_pos_x, ?combat_upper_pos_y}),
    Role#role{
        pos = Pos#pos{
            last = {MapId, X, Y}, 
            map = TrialMapId,
            x = ?trial_left_pos_x, 
            y = ?combat_upper_pos_y
        } 
    }.

%% -> 重入地图
reenter_map(Role = #role{link = #link{conn_pid = ConnPid}, event = Event, pos = #pos{map = MapId}}) ->
    case Event of
        ?event_trial ->
            sys_conn:pack_send(ConnPid, 10110, {MapId, ?trial_left_pos_x, ?combat_upper_pos_y});
        _ ->
            ignore
    end,
    Role.

%% -> #role{}
leave_map(Role = #role{pos = #pos{last = {LastMapId, _LastX, _LastY}}}) ->
    case map:role_enter(LastMapId, ?leave_pos_x, ?leave_pos_y, Role) of
        {ok, NewR = #role{special = Special}} ->
            NSpe = lists:keydelete(?special_trial_id, 1 ,Special),
            NewR#role{special = NSpe};
        {false, 'bad_pos'} -> 
            notice:alert(error, Role, ?MSGID(<<"进入地图失败:无效的坐标">>)),
            Role;
        {false, 'bad_map' } -> 
            notice:alert(error, Role, ?MSGID(<<"进入地图失败:不存在的地图">>)),
            Role;
        {false, _Reason } -> 
            notice:alert(error, Role, ?MSGID(<<"进入地图失败">>)),
            Role
    end.

%% -> #role{}
leave(Role) ->
    leave_map(Role).

%% 战斗结束时，由战斗进程执行
%% -> ok
over(_Referee, Winner, Loser) ->
    lists:foreach(fun(#fighter{pid = Pid, type = Type})->
        case is_pid(Pid) andalso erlang:is_process_alive(Pid) andalso Type=:=?fighter_type_role of
            true ->
                role:apply(async, Pid, {fun apply_role_combat_over/2, [?combat_result_win]});
            _ ->
                ignore
        end
    end, Winner),
    lists:foreach(fun(#fighter{pid = Pid, type = Type})->
        case is_pid(Pid) andalso erlang:is_process_alive(Pid) andalso Type=:=?fighter_type_role of
            true ->
                role:apply(async, Pid, {fun apply_role_combat_over/2, [?combat_result_lost]});
            _ ->
                ignore
        end
    end, Loser),
    ok.

apply_role_combat_over(Role = #role{link = #link{conn_pid = ConnPid}, attr = #attr{fight_capacity = FC}, special = Special}, Result) ->
    {_, TrialId, _} = lists:keyfind(?special_trial_id, 1, Special),
    NSpe = lists:keydelete(?special_trial_id, 1, Special),
    case Result of 
        ?combat_result_win ->
            NRole = #role{medal = Medal = #medal{pass = Pass}} = medal:listener_special(trial, Role, TrialId),
            % random_award:trial(NRole, TrialId),
            % ?DEBUG("--COND--~p~n", [NRole#role.medal#medal.condition]),
            trial_mgr:update_trial_info(TrialId, {?combat_result_win, FC}),
            NPass = 
                case lists:keyfind(TrialId, 1, Pass) of 
                    false ->
                        Now = util:unixtime(),
                        sys_conn:pack_send(ConnPid, 13068, {TrialId, Now}),
                        lists:sort([{TrialId, 0, Now}] ++ Pass);
                    _ ->
                        Pass
                end,
            NRole1 = NRole#role{event = ?event_no, special = NSpe, medal = Medal#medal{pass = NPass}},
            % NRole2 = role_listener:special_event(NRole1, {1076, TrialId}),   %% 通关试炼场
            {ok, NRole1};
        _ ->
            trial_mgr:update_trial_info(TrialId, {?combat_result_lost, FC}), 
            {ok, Role#role{event = ?event_no, special = NSpe}}
    end.

