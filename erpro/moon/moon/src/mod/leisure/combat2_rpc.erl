%%----------------------------------------------------
%% 战斗系统远程调用
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(combat2_rpc).
-export([
        handle/3
        ,distance_check/2
        ,team_check/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("team.hrl").
-include("link.hrl").
-include("npc.hrl").
-include("pos.hrl").
-include("combat.hrl").
-include("map.hrl").
-include("task.hrl").
-include("tutorial.hrl").
-include("hall.hrl").
-include("attr.hrl").
-include("dungeon.hrl").

-define(first_leisure_id, 11091).
%%

%% 对角色发起切磋战斗
%% 对角色镜像发起战斗
%% 对NPC发起战斗

handle(19800, {Rid, SrvId}, Role) ->
    case role_api:c_lookup(by_id, {Rid, SrvId}) of
        {ok, _Node, Defender = #role{}} ->
            case distance_check(Role, Defender) of
                true ->
                    case combat_type:check(Role, Defender) of
                        {false, Reason} -> 
                            notice:alert(error, Role, Reason);
                        _ -> 
                            {ok}
                    end;
                false ->
                    notice:alert(error, Role, ?MSGID(<<"距离太远，发起战斗失败">>))
            end;
        _E ->
            notice:alert(error, Role, ?MSGID(<<"对方不在线，发起战斗失败">>))
    end;

%% 玩家对NPC发起战斗
% ?tutorial_handle(10705, {_NpcId}, Role);
handle(19805, {next, {NpcId}}, Role) ->
    put({captcha_next, NpcId}, true),
    handle(19805, {NpcId}, Role);
handle(19805, {_NpcId}, Role = #role{combat_pid = CombatPid, event = Event,
        hall = #role_hall{id = HallId}}) when is_pid(CombatPid) ->
    case Event =:= ?event_dungeon andalso HallId =/= 0 of
        true ->
            %%远征王军
            {ok};
        false ->
            notice:alert(error, Role, ?MSGID(<<"你正在战斗中，无法发起新的战斗">>)),
            {reply, {}}
    end;
handle(19805, {_NpcId}, Role = #role{status = Status}) when Status =/= ?status_normal andalso Status =/= ?status_die ->
    notice:alert(error, Role, ?MSGID(<<"当前状态无法发起战斗">>)),
    {reply, {}};
handle(19805, _, Role = #role{event = Event}) when Event =:= ?event_jiebai ->
    notice:alert(error, Role, ?MSGID(<<"马上要结拜了打打杀杀多不好">>)),
    {reply, {}};
handle(19805, _, Role = #role{event = Event}) when Event =:= ?event_hall ->
    notice:alert(error, Role, ?MSGID(<<"当前状态无法发起战斗">>)),
    {reply, {}};
%% 普通情况
handle(19805, {NpcId}, Role0 = #role{id = RoleId,  pos = #pos{map_pid = MapPid}, cross_srv_id = CrossSrvId, status = Status, hp = Hp, hp_max = HpMax, link = #link{conn_pid = ConnPid}}) ->
    ?DEBUG("---玩家对NPC发起战斗---NpcId---：~p~n~n", [NpcId]),

    Role = case Status =:= ?status_die orelse Hp < 1 of  %% 先复活
        true ->
            %% TODO 广播通知
            role_attr:push(ConnPid, {hp, HpMax}),
            Role0#role{status = ?status_normal, hp = HpMax};
        false ->
            Role0
    end,
    case distance_check(Role, NpcId) of
        true ->
            case npc_mgr:get_npc(CrossSrvId, NpcId) of
                false -> 
                    notice:alert(error, Role, ?MSGID(<<"目标不存在，无法发起战斗">>)),
                    {reply, {}, Role};
                Npc ->
                    ObjectRole = leisure:to_leisure_object(Role),
                    % ObjectNpc = leisure:to_leisure_object(Npc),
                    ObjectNpc = Npc,
                    case is_record(ObjectRole, role) andalso is_record(ObjectNpc, npc) of
                        true ->
                            {ok, CF0} = role_convert:do(to_fighter, ObjectRole),
                            {ok, CF1} = npc_convert:do(to_fighter, ObjectNpc),
                            _If_new_guy = check_if_new_guild(Role),
                            combat2:start(?combat_type_leisure, MapPid, [CF0], [CF1], [_If_new_guy]),
                            % combat2:start(?combat_type_leisure, MapPid, [CF0], [CF1], [?false]),
                            {ok, Role};
                        _ ->
                            notice:alert(error, Role, ?L(<<"参与战斗对象属性初始化出错">>)),
                            {ok}
                    end
            end;
        false -> 
            notice:alert(error, Role, ?MSGID(<<"距离太远，发起战斗失败">>)),
            {reply, {}, Role};
        null_npc ->
            ?DEBUG("不存在的NPC,通知客户端移除"),
            role_api:c_pack_send(RoleId, 10121, {NpcId}),
            {reply, {}, Role}
    end;


%% 客户端查询是否需要进入战斗场景
handle(19810, {}, #role{pid = Pid, combat_pid = CombatPid}) when is_pid(CombatPid) ->
    ?DEBUG("在战斗中，已发送client_ready事件"),
    combat2:client_ready(CombatPid, Pid),
    {ok};

%% 没有在战斗中时不忽略此信息
handle(19810, {}, _Role) ->
    %% ?DEBUG("没有在战斗中，不需要发送client_ready事件"),
    {ok};

%% 接收战斗加载进度信息
handle(19811, {Val}, #role{combat_pid = CombatPid, pid = Pid}) ->
    case is_pid(CombatPid) andalso util:is_process_alive(CombatPid) of
        true -> combat2:load_event(CombatPid, Pid, Val);
        false -> ignore
    end,
    {ok};

handle(19812, {Val}, #role{combat_pid = CombatPid, pid = Pid})  when Val =:= 1 orelse Val =:= 0 ->
    case is_pid(CombatPid) andalso util:is_process_alive(CombatPid) of
        true ->    
            combat2:auto_action_event(CombatPid, Pid, Val),
            {ok};
        false -> 
            {reply, {0}}
    end;

%% TODO: 客户端表示收到了出招通知
handle(19821, {}, _Role) ->
    {ok};

%% 处理行动数据，注意:行动处理结果不在此处返回，将由战斗进程异步返回
handle(19830, {Skill, Target}, #role{combat_pid = CombatPid, pid = Pid}) when is_pid(CombatPid) ->
    combat2:action_event(CombatPid, Pid, Skill, Target),
    {ok};
% handle(19830, {Skill, Target, Special}, #role{combat_pid = CombatPid, pid = Pid}) when is_pid(CombatPid) ->
%     Special1 = [{Type, Val} || [Type, Val] <- Special],
%     combat2:action_event(CombatPid, Pid, Skill, Target, Special1),
%     {ok};
handle(19830, _, _Role) ->
    {ok};

%% 收到客户端动画播放完成通知
handle(19831, {}, #role{combat_pid = CombatPid, pid = Pid}) when is_pid(CombatPid) ->
    combat2:play_event(CombatPid, Pid),
    {ok};
handle(19831, {}, _Role) ->
    {ok};


%% 收到客户端结算面板播放完成通知
handle(19891, {}, #role{combat_pid = CombatPid, pid = Pid}) when is_pid(CombatPid) ->
    combat2:play_end_calc_event(CombatPid, Pid),
    {ok};
handle(19891, {}, _Role) ->
    %% ?DEBUG("你丫延迟那么高，都超时了才发过来，不处理你!"),
    {ok};

handle(_Cmd, _Data, _Role = #role{name = _Name}) ->
    ?ERR("收到[~s]发送的无效信息[Cmd:~w Data:...]", [_Name, _Cmd]),
    {ok}.


%% 组队情况下的判断
team_check(Role = #role{team_pid = TeamPid}) ->
    %% 是否有队伍
    A = not is_pid(TeamPid),
    %% 是否队长
    B = case team_api:is_leader(Role) of
        {T, _} -> T;
        K -> K
    end,
    %% 是否暂离队员
    C = team_api:is_tempout_member(Role),
    %% 三者有一个符合就行
    (A=:=true) orelse (B=:=true) orelse (C=:=true).

%% 距离检测
%% 判断人与NPC距离
distance_check(#role{pos = #pos{map_pid = MapPid1, x = X1, y = Y1}}, #role{pos = #pos{map_pid = MapPid2, x = X2, y = Y2}}) ->
    distance_check(MapPid1, X1, Y1, MapPid2, X2, Y2);
distance_check(#role{cross_srv_id = CrossSrvId, pos = #pos{map_pid = MapPid1, x = X1, y = Y1}}, NpcId) ->
    case npc_mgr:get_npc(CrossSrvId, NpcId) of
        false -> null_npc;
        #npc{pos = #pos{map_pid = MapPid2, x = X2, y = Y2}} ->
            distance_check(MapPid1, X1, Y1, MapPid2, X2, Y2)
    end.
distance_check(MapPid1, X1, Y1, MapPid2, X2, Y2) ->
    DistX = erlang:abs(X1 - X2),
    DistY = erlang:abs(Y1 - Y2),
    if
        MapPid1 =:= MapPid2 andalso DistX =< 1000 andalso DistY =< 1000 ->
            true;
        true ->
            false
    end.

%% 检查是否是第一次进入或者尚未通关，两种情况都需要新手引导
check_if_new_guild(_Role = #role{dungeon = RoleDungeons}) when is_list(RoleDungeons)->
    case lists:keyfind(?first_leisure_id, #role_dungeon.id, RoleDungeons) of 
        #role_dungeon{id = ?first_leisure_id, clear_count = N} ->
            case N =< 0 of 
                true ->
                    ?true;
                _ ->
                    ?false
            end;
        _ -> 
            ?true
    end;

check_if_new_guild(_Role) ->
    ?false.


