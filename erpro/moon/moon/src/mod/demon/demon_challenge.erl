%%----------------------------------------------------
%% 掠夺战斗
%% @author qingxuan
%%----------------------------------------------------
-module(demon_challenge).
-export([
    login/1
    ,enter_map/1
    ,reenter_map/1
    ,start/5
    ,over/3
    ,leave/1
    ,leave_map/1
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
-include("demon.hrl").
-include("map.hrl").

-define(leave_pos_x, 430).
-define(leave_pos_y, 530).

login(Role = #role{event = Event, pos = #pos{map = MapBaseId}}) ->
    case Event =:= ?event_demon_challenge andalso MapBaseId =/= ?demon_challenge_map_id of
        true -> %% 防止数据错误
            Role#role{event = ?event_no};
        _ ->
            Role
    end.

start(Type, TSrvId, TRoleId, TRoleName, Role = #role{link = #link{conn_pid = ConnPid}, pos = Pos = #pos{map = MapId}, event = _Event}) ->
    case get_component(Type, TSrvId, TRoleId, Pos) of
        {ok, CFighter, MapRole} ->
            CFighter1 = rename(CFighter, TRoleName),
            MapRole1 = rename(MapRole, TRoleName),
            Role1 = case MapId=/= ?demon_challenge_map_id of 
                true -> %% 新挑战
                    TR = enter_map(Role#role{event = ?event_demon_challenge}),  %% 进地图
                    map:send_enter_msg(ConnPid, MapRole1),  %% 发进入地图包 
                    TR;
                _ -> %% 重新挑战 
                    Role  
            end,
            case combat_type:check(?combat_type_demon_challenge, Role1, CFighter1) of
                true ->
                    {ok, Role1};
                {false, ErrMsg} ->
                    {error, ErrMsg, leave_map(Role1#role{event = ?event_no})}
            end;
        {error, _Reason} ->
            {error, ?MSGID(<<"您要发起挑战的玩家不存在">>), Role}
    end.
 
%% -> #role{}
enter_map(Role = #role{id = {Rid, SrvId}, pid = RolePid, link = #link{conn_pid = ConnPid}, pos = Pos = #pos{map = MapId, map_pid = MapPid, x = X, y = Y}}) ->
    map:role_leave(MapPid, RolePid, Rid, SrvId, X, Y), 
    sys_conn:pack_send(ConnPid, 10110, {?demon_challenge_map_id, ?demon_challenge_left_pos_x, ?combat_upper_pos_y}),
    Role#role{
        pos = Pos#pos{
            last = {MapId, X, Y}, 
            map = ?demon_challenge_map_id,
            x = ?demon_challenge_left_pos_x, 
            y = ?combat_upper_pos_y
        } 
    }.

%% -> 重入地图
reenter_map(Role = #role{link = #link{conn_pid = ConnPid}, event = Event}) ->
    case Event of
        ?event_demon_challenge ->
            sys_conn:pack_send(ConnPid, 10110, {?demon_challenge_map_id, ?demon_challenge_left_pos_x, ?combat_upper_pos_y});
        _ ->
            ignore
    end,
    Role.

%% -> #role{}
leave_map(Role = #role{pos = #pos{last = {LastMapId, _LastX, _LastY}}}) ->
    case map:role_enter(LastMapId, ?leave_pos_x, ?leave_pos_y, Role) of
        {ok, NewR} ->
            NewR;
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
% over(_Referee, Winner, Loser) ->
%     case [ Pid || #fighter{pid = Pid} <- Winner ++ Loser, is_pid(Pid), erlang:is_process_alive(Pid) ] of
%         [RolePid|_] ->
%             [Win] = Winner,
%             BaseId = Win#fighter.base_id,
%             case BaseId =:= 0 of 
%                 true ->
%                     role:apply(async, RolePid, {fun apply_role_combat_over/2, [?combat_result_win]});
%                 false ->
%                     role:apply(async, RolePid, {fun apply_role_combat_over/2, [?combat_result_lost]})
%             end;
%         _ ->
%             ignore
%     end,
%     ok.

apply_role_combat_over(Role = #role{link = #link{conn_pid = _ConnPid}}, Result) ->
    case Result of 
        ?combat_result_win ->
            Role1 = Role#role{event = ?event_no},
            {ok, Role1};
        _ ->
            {ok, Role#role{event = ?event_no}}
    end.

over(_Referee, Winner, Loser) ->
    [#fighter{pid = RolePid}] = [F || F <- Winner ++ Loser, F#fighter.group =:= group_atk],
    [#fighter{}] = [F || F <- Winner ++ Loser, F#fighter.group =:= group_dfd],
    Result = case Winner of
        [#fighter{group = group_atk}] -> win;
        _ -> lose
    end,
    case Result of
        win ->
            role:apply(async, RolePid, {fun apply_role_combat_over/2, [?combat_result_win]});
        lose ->
            role:apply(async, RolePid, {fun apply_role_combat_over/2, [?combat_result_lost]})
    end.

rename(CF = #converted_fighter{fighter = F}, Name) ->
    CF#converted_fighter{fighter = F#fighter{name = Name}};
rename(MapRole = #map_role{}, Name) ->
    MapRole#map_role{name = Name}.

%% -> {ok, #converted_fighter{}, #map_role{}} | {error, Reason}
get_component(?demon_challenge_type_virtual, SrvId, RoleId, Pos) ->
    case arena_career:get_role(RoleId, SrvId) of
        false ->
            {error, not_exists};
        ARole ->
            Role = arena_career:to_fight_role(ARole, Pos),
            {ok, CFighter} = role_convert:do(to_fighter, {Role, clone}),
            {ok, MapRole} = role_convert:do(to_map_role, Role),
            #converted_fighter{fighter = F} = CFighter,
            CFighter1 = CFighter#converted_fighter{
                fighter = F#fighter{
                    subtype = ?fighter_subtype_demon_virtual_role
                }
            },
            {ok, CFighter1, MapRole}
    end;
get_component(?demon_challenge_type_real, SrvId, RoleId, Pos) ->
    Ret2 = case global:whereis_name({role, RoleId, SrvId}) of
        Pid when is_pid(Pid) ->
            Ret = role:apply(sync, Pid, {fun return_fighter_map_role/2, [Pos]}),
            case Ret of
                {ok, CFighter, MapRole} -> 
                    #converted_fighter{fighter = F} = CFighter,
                    {ok, CFighter#converted_fighter{
                            fighter = F#fighter{
                                is_clone = ?true, 
                                subtype = ?fighter_subtype_demon_real_role
                            }
                        }, MapRole};
                {error, _Reason} -> offline
            end;
        _ ->
            offline
    end,
    case Ret2 of
        offline ->
            case load_role(SrvId, RoleId) of
                {ok, Role} ->
                    Role1 = Role#role{pos = Pos#pos{
                        x = ?demon_challenge_right_pos_x, 
                        y = ?combat_upper_pos_y
                    }},
                    {ok, CFighter2} = role_convert:do(to_fighter, {Role1, clone}),
                    {ok, MapRole2} = role_convert:do(to_map_role, Role1),
                    #converted_fighter{fighter = F2} = CFighter2,
                    CFighter3 = CFighter2#converted_fighter{
                        fighter = F2#fighter{
                            subtype = ?fighter_subtype_demon_real_role
                        }
                    },
                    {ok, CFighter3, MapRole2};
                {error, Reason} ->
                    {error, Reason}
            end;
        _ ->
            Ret2
    end.

return_fighter_map_role(Role, Pos) ->
    Pos1 = Pos#pos{
        x = ?demon_challenge_right_pos_x, 
        y = ?combat_upper_pos_y
    },
    {ok, CFighter} = role_convert:do(to_fighter, Role#role{pos = Pos1, link = undefined, pid = undefined}),
    {ok, MapRole} = role_convert:do(to_map_role, Role#role{pos = Pos1}), 
    {ok, {ok, CFighter, MapRole}, Role}.

%% -> {ok, #role} | {error, Reason}
load_role(SrvId, RoleId) ->
    From = self(),
    Ref = erlang:make_ref(),
    Pid = spawn(fun()-> 
        Ret = try role_data:fetch_role(by_id, {RoleId, SrvId}) of
            {ok, Role} -> 
                Role1 = pet:append_to_special(Role),
                {ok, role_attr:calc_attr(Role1)};
            {false, Reason} -> {error, Reason};
            Else -> {error, Else}
            catch A:B -> 
                ?ERR("~p : ~p : ~p", [A, B, erlang:get_stacktrace()]),
                {error, {A,B}}
        end,
        From ! {Ref, self(), Ret}
    end),
    receive
        {Ref, Pid, Result} ->
            Result
        after 5000 ->
            {error, timeout}
    end.
