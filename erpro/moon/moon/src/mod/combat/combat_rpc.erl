%%----------------------------------------------------
%% 战斗系统远程调用
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(combat_rpc).
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

%%

%% 对角色发起切磋战斗
%% 对角色镜像发起战斗
%% 对NPC发起战斗

%%handle(10700, _Target, _Role) ->
%%    {ok};
% %% 过滤无法发起战斗的情况
% handle(10700, _Target, #role{status = Status}) when Status =/= ?status_normal ->
%     {reply, {?false, ?MSGID(<<"当前状态无法发起战斗">>)}};
% handle(10700, _Target, #role{combat_pid = CombatPid}) when is_pid(CombatPid) ->
%     {reply, {?false, ?MSGID(<<"不能重复发起战斗">>)}};
% handle(10700, {_TargetId, _TargetSrvId}, #role{event = ?event_arena_prepare}) ->
%     {reply, {?false, ?MSGID(<<"竞技场准备区不可以打架，别猴急">>)}};
% handle(10700, {_TargetId, _TargetSrvId}, #role{event = ?event_top_fight_prepare}) ->
%     {reply, {?false, ?MSGID(<<"竞技场准备区不可以打架，别猴急">>)}};
% handle(10700, {_TargetId, _TargetSrvId}, #role{event = ?event_cross_king_prepare}) ->
%     {reply, {?false, ?MSGID(<<"至尊王者赛的时候，就不要打打杀杀的嘛！">>)}};
% handle(10700, {_TargetId, _TargetSrvId}, #role{event = ?event_guard_counter}) ->
%     {reply, {?false, ?MSGID(<<"洛水反击的时候，就不要自相残杀啦！">>)}};
% handle(10700, {_TargetId, _TargetSrvId}, #role{event = ?event_cross_king_match}) ->
%     {reply, {?false, ?MSGID(<<"至尊王者赛的时候，就不要打打杀杀的嘛！">>)}};
% handle(10700, {_TargetId, _TargetSrvId}, #role{event = ?event_cross_warlord_prepare}) ->
%     {reply, {?false, ?MSGID(<<"武神坛的时候，就不要打打杀杀的嘛！">>)}};
% handle(10700, {_TargetId, _TargetSrvId}, #role{event = ?event_cross_warlord_match}) ->
%     {reply, {?false, ?MSGID(<<"武神坛的时候，就不要打打杀杀的嘛！">>)}};
% handle(10700, {_, _}, #role{event = Event}) when Event =:= ?event_jiebai ->
%     {reply, {?false, ?MSGID(<<"马上要结拜了打打杀杀多不好">>)}};
% handle(10700, _, #role{event = Event1}) when Event1 =:= ?event_pk_duel ->
%     {reply, {?false, ?MSGID(<<"参加跨服决斗中，不能发起其他战斗">>)}};
% %% 对角色发起战斗
% handle(10700, {Rid, SrvId}, Role = #role{cross_srv_id = <<"center">>}) -> %% 跨服地图
%     case team_check(Role) of
%         true ->
%             case role_api:c_lookup(by_id, {Rid, SrvId}) of
%                 {ok, _Node, Defender = #role{pos = #pos{map_base_id = TargetMapBaseId}}} ->
%                     %% 只有非安全区域可以杀
%                     CanKill =  case map_data:get(TargetMapBaseId) of
%                         #map_data{type = ?map_type_unsafe} -> true;
%                         _ -> false
%                     end,
%                     case CanKill of
%                         true ->
%                             case distance_check(Role, Defender) of
%                                 true ->
%                                     case combat_type:check(Role, Defender) of
%                                         {false, Reason} -> {reply, {?false, Reason}};
%                                         true -> {ok}
%                                     end;
%                                 false ->
%                                     {reply, {?false, ?MSGID(<<"距离太远，发起战斗失败">>)}}
%                             end;
%                         false -> {reply, {?false, ?MSGID(<<"此地区不允许杀戮">>)}}
%                     end;
%                 _E ->
%                     {reply, {?false, ?MSGID(<<"对方不在线，发起战斗失败">>)}}
%             end;
%         false -> {reply, {?false, ?MSGID(<<"你在队伍中，只有队长或者暂离队员才能发起战斗">>)}}
%     end;
handle(10700, {Rid, SrvId}, Role) ->
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

%% 请求切磋
handle(10701, {_TargetId, _TargetSrvId}, #role{status = Status, hp = Hp}) when Status =:= ?status_die orelse Hp < 1 ->
    {reply, {?false, ?MSGID(<<"当前状态无法发起切磋">>)}};
handle(10701, {_TargetId, _TargetSrvId}, #role{event = ?event_arena_prepare}) ->
    {reply, {?false, ?MSGID(<<"竞技场准备区不可以切磋">>)}};
handle(10701, {_TargetId, _TargetSrvId}, #role{event = ?event_arena_match}) ->
    {reply, {?false, ?MSGID(<<"竞技场就不要切磋，直接杀吧">>)}};
handle(10701, {_TargetId, _TargetSrvId}, #role{event = ?event_top_fight_prepare}) ->
    {reply, {?false, ?MSGID(<<"此地区不允许切磋">>)}};
handle(10701, {_TargetId, _TargetSrvId}, #role{event = ?event_top_fight_match}) ->
    {reply, {?false, ?MSGID(<<"此地区不允许切磋">>)}};
handle(10701, {_TargetId, _TargetSrvId}, #role{event = Event}) when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    {reply, {?false, ?MSGID(<<"此地区不允许切磋">>)}};
handle(10701, {_TargetId, _TargetSrvId}, #role{event = Event}) when Event =:= ?event_cross_king_prepare orelse Event =:= ?event_cross_king_match ->
    {reply, {?false, ?MSGID(<<"至尊王者赛的时候，就不要打打杀杀的嘛！">>)}};
handle(10701, {_TargetId, _TargetSrvId}, #role{event = Event}) when Event =:= ?event_guard_counter ->
    {reply, {?false, ?MSGID(<<"洛水反击的时候，就不要自相残杀啦！">>)}};
handle(10701, {_TargetId, _TargetSrvId}, #role{event = Event}) when Event =:= ?event_cross_warlord_prepare orelse Event =:= ?event_cross_warlord_match ->
    {reply, {?false, ?MSGID(<<"武神坛的时候，就不要打打杀杀的嘛！">>)}};
handle(10701, {_TargetId, _TargetSrvId}, #role{event = Event}) when Event =:= ?event_jiebai ->
    {reply, {?false, ?MSGID(<<"马上要结拜了打打杀杀多不好">>)}};
handle(10701, _, #role{event = Event1}) when Event1 =:= ?event_pk_duel ->
    {reply, {?false, ?MSGID(<<"参加跨服决斗中，不能发起其他战斗">>)}};
handle(10701, {TargetId, TargetSrvId}, Role = #role{id = {Rid, SrvId}, name = Name, team_pid = STeamPid, cross_srv_id = CrossSrvId, pos = #pos{map_base_id = MapBaseId}}) ->
    case role_api:c_lookup(by_id, {TargetId, TargetSrvId}) of
        {ok, _Node, Target = #role{pid = Pid, team_pid = TeamPid, cross_srv_id = TargetCrossSrvId, pos = #pos{map_base_id = TargetMapBaseId}}} ->
            DistanceCheckResult = case MapBaseId =:= TargetMapBaseId andalso MapBaseId =:= 30015 andalso CrossSrvId =:= TargetCrossSrvId andalso CrossSrvId =:= <<"center">> of
                true -> true;
                false -> distance_check(Role, Target)
            end,
            case DistanceCheckResult of
                true ->
                    %% 非安全区域不能切磋
                    CanChallenge =  case map_data:get(TargetMapBaseId) of
                        #map_data{type = ?map_type_safe} -> true; %% 只有安全区域可以切磋
                        _ -> false
                    end,
                    case CanChallenge of
                        true -> 
                            %% 如果有队伍且不是队长且非离队状态，则转发给队长
                            {RealPid, RealRoleId, Why} = case is_pid(TeamPid) andalso util:is_process_alive(TeamPid) of
                                true -> %% 有组队
                                    if
                                        TeamPid =:= STeamPid ->
                                            {undefined, undefined, ?MSGID(<<"不能对队员发起切磋">>)};
                                        true ->
                                            case team:get_team_info(TeamPid) of
                                                {ok, #team{leader = #team_member{id = {LeaderId, LeaderSrvId}, pid = LeaderPid, mode = LeaderMode}, member = Member}} ->
                                                    if 
                                                        (LeaderId=:=TargetId) andalso (LeaderSrvId=:=TargetSrvId) -> %% 目标是队长
                                                            case LeaderMode of
                                                                ?MODE_OFFLINE -> {undefined, undefined, ?MSGID(<<"队长离线，不能发起切磋">>)};
                                                                _ -> {LeaderPid, {LeaderId, LeaderSrvId}, <<>>}
                                                            end;
                                                        true -> %% 目标不是队长
                                                            case lists:keyfind({TargetId, TargetSrvId}, #team_member.id, Member) of
                                                                false -> 
                                                                    ?ERR("对方既有组队但是又找不到其信息"),
                                                                    {undefined, undefined, ?MSGID(<<"对方状态异常，无法发起切磋请求">>)};
                                                                #team_member{mode = ?MODE_TEMPOUT} -> 
                                                                    ?DEBUG("对方是队员，但是暂离，所以单独对他发起切磋请求"),
                                                                    {Pid, {TargetId, TargetSrvId}, <<>>};
                                                                _ ->
                                                                    case LeaderMode of
                                                                        ?MODE_OFFLINE -> {undefined, undefined, ?MSGID(<<"队长离线，不能发起切磋">>)};
                                                                        _ -> {LeaderPid, {LeaderId, LeaderSrvId}, <<>>}
                                                                    end
                                                            end
                                                    end;
                                                _Err ->
                                                    ?ERR("获取队伍信息发生异常:~w", [_Err]),
                                                    {undefined, undefined, ?MSGID(<<"对方状态异常，无法发起切磋请求">>)}
                                            end
                                    end;
                                false -> %% 没有组队
                                    {Pid, {TargetId, TargetSrvId}, <<>>}
                            end,
                            case RealPid of
                                undefined ->
                                    {reply, {0, Why}};
                                _ ->
                                    %% 发送切磋请求给对方
                                    role_api:c_pack_send(RealRoleId, 10702, {Rid, SrvId, Name}),
                                    {reply, {1, ?MSGID(<<"切磋请求已经发出，请等待对方回应">>)}}
                            end;
                        false -> 
                            {reply, {0, ?MSGID(<<"此地区不允许切磋">>)}}
                    end;
                false ->
                    {reply, {?false, ?MSGID(<<"竞技场准备区不可以切磋">>)}}
            end;
        _ ->
            {reply, {0, ?MSGID(<<"对方不在线无法发送切磋请求">>)}}
    end;

%% 非法数据
handle(10703, {Rid, SrvId, _Name, _Accept}, #role{id = {Srid, SsrvId}}) when Rid =:= Srid andalso SrvId =:= SsrvId ->
    {ok};

%% 同意切磋请求
%% Target:#role{}，发起切磋的目标
%% {Rid, SrvId}:切磋发起者
handle(10703, _, #role{id = RoleId, name = _Name2, combat_pid = CombatPid}) when is_pid(CombatPid) ->
    role_api:c_pack_send(RoleId, 10701, {?false, ?MSGID(<<"你正在战斗中，无法发起新的战斗">>)}),
    {ok};
handle(10703, _, #role{id = RoleId, event = Event}) when Event =:= ?event_jiebai ->
    role_api:c_pack_send(RoleId, 10701, {?false, ?MSGID(<<"马上要结拜了打打杀杀多不好">>)}),
    {reply, {?false, ?MSGID(<<"马上要结拜了打打杀杀多不好">>)}};
handle(10703, _, #role{id = RoleId, event = Event}) when Event =:= ?event_cross_warlord_prepare orelse Event =:= ?event_cross_warlord_match ->
    role_api:c_pack_send(RoleId, 10701, {?false, ?MSGID(<<"武神坛的时候，就不要打打杀杀的嘛！">>)}),
    {reply, {?false, ?MSGID(<<"武神坛的时候，就不要打打杀杀的嘛！">>)}};
handle(10703, _, #role{event = Event1}) when Event1 =:= ?event_pk_duel ->
    {reply, {?false, ?MSGID(<<"参加跨服决斗中，不能发起其他战斗">>)}};
handle(10703, _, #role{event = Event1}) when Event1 =:= ?event_guard_counter ->
    {reply, {?false, ?MSGID(<<"洛水反击的时候，就不要自相残杀啦！">>)}};
handle(10703, {Rid, SrvId, _Name1, 1}, Target = #role{name = _Name2}) ->
    case role_api:c_lookup(by_id, {Rid, SrvId}) of
        {ok, _Node, #role{combat_pid = CombatPid}} when is_pid(CombatPid) ->
            role_api:c_pack_send({Rid, SrvId}, 10701, {?false, ?MSGID(<<"对方正在战斗中">>)});
        {ok, _Node, Role = #role{cross_srv_id = <<"center">>, pos = #pos{map_base_id = 30015}}} -> %% 跨服切磋
            %% AtkList = role_api:fighter_group(Role),
            %% DfdList = role_api:fighter_group(Target),
            %% center:call(combat, start, [?combat_type_challenge, AtkList, DfdList]);
            AtkRoleIdList = role_api:fighter_roleid_group(Role),
            DfdRoleIdList = role_api:fighter_roleid_group(Target),
            center:cast(c_combat_mgr, start_combat, [[?combat_type_challenge, AtkRoleIdList, DfdRoleIdList]]);
        {ok, _Node, Role} ->
            case distance_check(Role, Target) of
                true ->
                    case combat_type:check(?combat_type_challenge, Target, Role) of
                        {false, Reason} ->
                            %% 借10701协议来发送给切磋目标不能战斗的理由
                            role_api:c_pack_send({Rid, SrvId}, 10701, {?false, Reason});
                        true -> ignore
                    end;
                false ->
                    role_api:c_pack_send({Rid, SrvId}, 10701, {?false, ?MSGID(<<"距离太远，无法发起切磋">>)})
            end;
        _E ->
            %% 借10701协议来发送给切磋目标不能战斗的理由
            role_api:c_pack_send({Rid, SrvId}, 10701, {?false, ?MSGID(<<"对方不在线，发起战斗失败">>)})
    end,
    {ok};

%% 拒绝切磋请求
%% Target:#role{}，发起切磋的目标
%% {Rid, SrvId}:切磋发起者
handle(10703, {Rid, SrvId, _Name, _Accept}, _Target = #role{name = Name}) ->
    role_api:c_pack_send({Rid, SrvId}, 10703, {Name}),
    {ok};

%% 玩家对NPC发起战斗
?tutorial_handle(10705, {_NpcId}, Role);
handle(10705, {next, {NpcId}}, Role) ->
    put({captcha_next, NpcId}, true),
    handle(10705, {NpcId}, Role);
handle(10705, {_NpcId}, Role = #role{combat_pid = CombatPid, event = Event,
        hall = #role_hall{id = HallId}}) when is_pid(CombatPid) ->
    case Event =:= ?event_dungeon andalso HallId =/= 0 of
        true ->
            %%远征王军
            {ok};
        false ->
            notice:alert(error, Role, ?MSGID(<<"你正在战斗中，无法发起新的战斗">>)),
            {reply, {}}
    end;
handle(10705, {_NpcId}, Role = #role{status = Status}) when Status =/= ?status_normal andalso Status =/= ?status_die ->
    notice:alert(error, Role, ?MSGID(<<"当前状态无法发起战斗">>)),
    {reply, {}};
handle(10705, _, Role = #role{event = Event}) when Event =:= ?event_jiebai ->
    notice:alert(error, Role, ?MSGID(<<"马上要结拜了打打杀杀多不好">>)),
    {reply, {}};
handle(10705, _, Role = #role{event = Event}) when Event =:= ?event_hall ->
    notice:alert(error, Role, ?MSGID(<<"当前状态无法发起战斗">>)),
    {reply, {}};
%% 普通情况
handle(10705, {NpcId}, Role0 = #role{id = RoleId, cross_srv_id = CrossSrvId, status = Status, hp = Hp, hp_max = HpMax, link = #link{conn_pid = ConnPid}}) ->
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
            case team_check(Role) of
                true ->
                    case hook:combat_before(Role) of %% 判断挂机次数是否满了
                        ok ->
                            case npc_mgr:get_npc(CrossSrvId, NpcId) of
                                false -> 
                                    notice:alert(error, Role, ?MSGID(<<"目标不存在，无法发起战斗">>)),
                                    {reply, {}, Role};
                                Npc ->
                                    case combat_type:check(?combat_type_npc, Role, Npc) of
                                        {true, NewCombatType} ->
                                            case npc:fight(Npc, Role, NewCombatType) of
                                                {false, Reason} -> 
                                                    notice:alert(error, Role, Reason),
                                                    {reply, {}, Role};
                                                true -> {ok, Role} %% 此处不返回信息，交给npc:fight/2处理
                                            end;
                                        %% 狂暴怪抢到别人的开出来的
                                        {rob, NewCombatType, OwerId} ->
                                            case npc:fight(Npc#npc{owner = OwerId}, Role, NewCombatType) of
                                                {false, Reason} -> 
                                                    notice:alert(error, Role, Reason),
                                                    {reply, {}, Role};
                                                true -> {ok, Role} %% 此处不返回信息，交给npc:fight/2处理
                                            end;
                                        {true, NewCombatType, Referees} ->
                                            case npc:fight(Npc, Role, NewCombatType, Referees) of
                                                {false, Reason} -> 
                                                    notice:alert(error, Role, Reason),
                                                    {reply, {}, Role};
                                                true -> {ok, Role} %% 此处不返回信息，交给npc:fight/2处理
                                            end;
                                        {guard_counter, NewCombatType, Referees} ->
                                            case npc:fight(Npc, Role, NewCombatType, Referees) of
                                                {false, Reason} -> 
                                                    notice:alert(error, Role, Reason),
                                                    {reply, {}, Role};
                                                true -> {ok, Role} %% 此处不返回信息，交给npc:fight/2处理
                                            end;
                                        {false, Reason} -> 
                                            ?DEBUG("错误来到这里"),
                                            notice:alert(error, Role, Reason),
                                            {reply, {}, Role};
                                        {false} ->
                                            %%远征王军触发失败
                                            {ok}
                                    end
                            end;
                        {false, Reason} ->
                            notice:alert(error, Role, Reason),
                            {reply, {}, Role}
                    end;
                false -> 
                    notice:alert(error, Role, ?MSGID(<<"你在队伍中，只有队长或者暂离队员才能发起战斗">>)),
                    {reply, {}, Role}
            end;
        false -> 
            notice:alert(error, Role, ?MSGID(<<"距离太远，发起战斗失败">>)),
            {reply, {}, Role};
        null_npc ->
            ?DEBUG("不存在的NPC,通知客户端移除"),
            role_api:c_pack_send(RoleId, 10121, {NpcId}),
            {reply, {}, Role}
    end;

%% TODO:申请加入正在进行中的战斗
handle(10706, {_Id, _Side}, #role{pid = _Pid}) ->
    {ok};

%% 申请观战
handle(10707, _, #role{combat_pid = CombatPid}) when is_pid(CombatPid) -> {reply, {?false, ?MSGID(<<"你正在战斗中，无法发起观战">>)}};
handle(10707, _, #role{event = Event}) when Event =:= ?event_jiebai ->
    {reply, {?false, ?MSGID(<<"您正在结拜，如此大事，不要再搀和别人的事哦">>)}};
handle(10707, TargetId = {_TargetRid, _TargetSrvId}, Role = #role{id = Sid, pid = Spid, name = Name, link = #link{conn_pid = ConnPid}}) ->
    %% 判断自己是否在观战
    case combat:is_observing(Role) of
        {true, _} -> {reply, {?false, ?MSGID(<<"你当前正在观战，请先退出观战">>)}};
        false ->
            %% 判断自己是否队长或者暂离队员
            case team_check(Role) of
                true ->
                    %% 判断对方是否在线
                    case role_api:c_lookup(by_id, TargetId, [#role.pid, #role.combat_pid]) of
                        {ok, _Node, [Tpid, CombatPid]} when is_pid(CombatPid) -> %% 判断目标是否在战斗
                            CombatPid ! {observer_enter, #c_observer{id = Sid, pid = Spid, name = Name, conn_pid = ConnPid, target_pid = Tpid}},
                            {reply, {?true, <<>>}};
                        {ok, _, _} ->
                            {reply, {?false, ?MSGID(<<"对方不在战斗中，无法观战">>)}};
                        _ ->
                            {reply, {?false, ?MSGID(<<"对方不在线无法发送观战请求">>)}}
                    end;
                false ->
                    {reply, {?false, ?MSGID(<<"你在队伍中，只有队长或者暂离队员才能观战">>)}}
            end
    end;
   

%% 退出观战
handle(10708, _, #role{combat_pid = CombatPid}) when is_pid(CombatPid) -> {reply, {?false, ?MSGID(<<"你正在战斗中">>)}};
handle(10708, _TargetId, Role = #role{id = RoleId, pid = Pid, combat = CombatParams}) ->
    %% 判断自己是否在观战
    case combat:is_observing(Role) of
        {true, CombatPid} ->
            CombatPid ! {observer_exit, Pid},
            {ok};
        false ->
            %% 如果是在看录像则终止播放
            case lists:keyfind(replay_pid, 1, CombatParams) of
                {replay_pid, ReplayPid} when is_pid(ReplayPid) ->
                    ReplayPid ! stop,
                    CombatParams1 = lists:keydelete(replay_pid, 1, CombatParams),
                    {ok, Role#role{combat = CombatParams1}};
                _ ->
                    %% 如果是在看直播则离开
                    case lists:keyfind(live_pid, 1, CombatParams) of
                        {live_pid, LivePid} when is_pid(LivePid) ->
                            LivePid ! {exit_live, Pid},
                            role_api:c_pack_send(RoleId, 10708, {?true, <<>>});
                        _ ->
                            role_api:c_pack_send(RoleId, 10708, {?true, <<>>}),
                            {reply, {?false, ?MSGID(<<"你目前不在观战">>)}}
                    end
            end
    end;

%% 客户端查询是否需要进入战斗场景
handle(10710, {}, #role{pid = Pid, combat_pid = CombatPid}) when is_pid(CombatPid) ->
    ?DEBUG("在战斗中，已发送client_ready事件"),
    combat:client_ready(CombatPid, Pid),
    {ok};

%% 没有在战斗中时不忽略此信息
handle(10710, {}, _Role) ->
    %% ?DEBUG("没有在战斗中，不需要发送client_ready事件"),
    {ok};

%% 接收战斗加载进度信息
handle(10711, {Val}, #role{combat_pid = CombatPid, pid = Pid}) ->
    case is_pid(CombatPid) andalso util:is_process_alive(CombatPid) of
        true -> combat:load_event(CombatPid, Pid, Val);
        false -> ignore
    end,
    {ok};

%% TODO: 客户端表示收到了出招通知
handle(10721, {}, _Role) ->
    {ok};

%% 改变自动战斗选招
handle(10728, {SkillId}, Role = #role{combat_pid = CombatPid}) when is_pid(CombatPid) ->
    %% 战斗中不给修改
    {reply, {?false, SkillId}, Role};
handle(10728, {SkillId}, Role = #role{combat = CombatParams}) ->
    case combat:is_illegal_auto_skill(SkillId) of
        true -> {reply, {?false, SkillId}, Role};
        false ->
            CombatParams1 = lists:keyreplace(last_skill, 1, CombatParams, {last_skill, SkillId}),
            {reply, {?true, SkillId}, Role#role{combat = CombatParams1}}
    end;
handle(10728, _, _) ->
    {ok};

%% 改变自动战斗状态
handle(10729, {SkillId, Val}, #role{combat_pid = CombatPid, pid = Pid}) ->
    case is_pid(CombatPid) andalso util:is_process_alive(CombatPid) of
        true -> combat:auto_action_event(CombatPid, Pid, SkillId, Val);
        false -> ignore
    end,
    {ok};

%% 处理行动数据，注意:行动处理结果不在此处返回，将由战斗进程异步返回
handle(10730, {Skill, Target, Special}, #role{combat_pid = CombatPid, pid = Pid}) when is_pid(CombatPid) ->
    Special1 = [{Type, Val} || [Type, Val] <- Special],
    combat:action_event(CombatPid, Pid, Skill, Target, Special1),
    {ok};
handle(10730, _, _Role) ->
    {ok};

%% 收到客户端动画播放完成通知
handle(10731, {}, #role{combat_pid = CombatPid, pid = Pid}) when is_pid(CombatPid) ->
    combat:play_event(CombatPid, Pid),
    {ok};
handle(10731, {}, _Role) ->
    {ok};

%% 客户端请求播放动画
handle(10740, _, #role{combat_pid = CombatPid}) when is_pid(CombatPid) ->
    {ok};
handle(10740, {ReplayIdStr}, Role = #role{pid = RolePid, link = #link{conn_pid = ConnPid}}) ->
    %% 判断自己是否在观战
    case combat:is_observing(Role) of
        {true, _CombatPid} ->
            ignore;
        false ->
            {ok, ReplayId} = util:bitstring_to_term(ReplayIdStr),
            combat_replay_mgr:playback(ReplayId, RolePid, ConnPid)
    end,
    {ok};

%% 收到客户端结算面板播放完成通知
handle(10791, {}, #role{combat_pid = CombatPid, pid = Pid}) when is_pid(CombatPid) ->
    combat:play_end_calc_event(CombatPid, Pid),
    {ok};
handle(10791, {}, _Role) ->
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
