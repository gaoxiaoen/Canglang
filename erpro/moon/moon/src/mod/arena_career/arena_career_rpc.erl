%%----------------------------------------------------
%% 中庭战神相关远程调用
%% @author shawnoyc@163.com
%%----------------------------------------------------

-module(arena_career_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("arena_career.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("vip.hrl").
-include("combat.hrl").

%% 获取对手
handle(16100, {_Force}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
handle(16100, {Force}, Role = #role{lev = Lev}) when Lev >= ?arena_career_lev ->
    case Force of
        1 -> %% 强制刷新
            RangeRole = arena_career:get_range(Role),
            {reply, {RangeRole}};
        _ -> %% 非强制
            case allow(arena_career_16100) of
                true ->
                    RangeRole = arena_career:get_range(Role),
                    {reply, {RangeRole}};
                false ->
                    ?DEBUG("cd时间,不响应"),
                    {ok}
            end
    end;

%% 请求角色日志
handle(16101, {}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
handle(16101, {}, #role{id = {Rid, SrvId}, lev = Lev}) when Lev >= ?arena_career_lev ->
    Log = arena_career_mgr:query_data(Rid, SrvId),
    {reply, {Log}};

%% 请求排行
handle(16102, {}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
handle(16102, {}, #role{career = Career, lev = Lev}) when Lev >= ?arena_career_lev ->
    case arena_career_mgr:query_rank(Career) of
        null -> {ok};
        Log -> {reply, Log}
    end;

%% 获取个人信息
handle(16103, {}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
handle(16103, {}, Role = #role{lev = Lev, link = #link{conn_pid = ConnPid}}) when Lev >= ?arena_career_lev ->
    arena_career:notice_client(all, ConnPid, Role),
    {ok};

%% 增加挑战次数
handle(16104, {}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
handle(16104, {}, Role = #role{id = {_Rid, _SrvId}, career = _Career, link = #link{conn_pid = _ConnPid}, arena_career = ArenaCareer = #arena_career{free_count = Count1, pay_count = Count2, pay_time = PayTime}, lev = Lev}) when Lev >= ?arena_career_lev ->
    %case Count1 + Count2 =:= 0 of
    %    true ->
    case PayTime >= ?arena_career_add_times_max + vip:arena_buy(Role) of
                true -> 
                    notice:alert(error, Role, ?MSGID(<<"今日购买挑战次数已满10次,无法购买">>)),
                    {ok};
                false ->
                    role:send_buff_begin(),
                    Price = pay:price(?MODULE, arena_career_add_times, PayTime+1),
                    case role_gain:do([#loss{label = gold, val = Price, msg = ?MSGID(<<"晶钻不足,无法购买挑战次数">>)}], Role) of
                        {false, #loss{msg = Msg, err_code = _ErrCode}} ->
                            role:send_buff_clean(),
                            notice:alert(error, Role, Msg),
                            {ok};
                        {ok, NewRole} ->
                            NewArenaCareer = ArenaCareer#arena_career{pay_count = Count2 + 1, pay_time = PayTime + 1},
                            role:send_buff_flush(),
                            notice:alert(error, Role, ?MSGID(<<"购买挑战次数成功">>)),
                            {reply, {Count1 + Count2 + 1}, NewRole#role{arena_career = NewArenaCareer}}
                    end
            end;
    %    false ->
    %        notice:alert(error, Role, ?MSGID(<<"还有剩余次数,无需购买">>)),
    %        {ok}
    %end;

%% 加速CD
handle(16105, {}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
handle(16105, {}, Role = #role{career = _Career, id = {_Rid, _SrvId}, link = #link{conn_pid = _ConnPid}, arena_career = ArenaCareer = #arena_career{cooldown = CoolDown}, lev = Lev}) when Lev >= ?arena_career_lev ->
    Now = util:unixtime(),
    Cd = case CoolDown =:= 0 orelse vip:arena_loss(Role) of
        true -> 0;
        false ->
            case CoolDown - Now > 0 of
                true -> CoolDown - Now;
                false -> 0
            end
    end,
    case Cd =:= 0 of
        false ->
            role:send_buff_begin(),
            Count = pay:price(?MODULE, arena_career_clear_cd, Cd),
            case role_gain:do([#loss{label = gold, val = Count, msg = ?MSGID(<<"晶钻不足,无法加速">>)}], Role) of
                {false, #loss{msg = Msg, err_code = _ErrCode}} ->
                    role:send_buff_clean(),
                    notice:alert(error, Role, Msg),
                    {ok};
                {ok, NewRole} ->
                    NewArenaCareer = ArenaCareer#arena_career{cooldown = 0},
                    role:send_buff_flush(),
                    notice:alert(succ, Role, ?MSGID(<<"加速成功">>)),
                    {reply, {0}, NewRole#role{arena_career = NewArenaCareer}}
            end;
        true ->
            notice:alert(error, Role, ?MSGID(<<"冷却时间已经为0,无需购买加速">>)),
            {ok}
    end;

%% 发起挑战 
handle(16106, {_, _}, #role{lev = Lev}) when Lev < ?arena_career_lev -> ?DEBUG("error: 等级不够"), {ok};
handle(16106, {_, _}, Role = #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    notice:alert(error, Role, ?MSGID(<<"组队状态下不能参加中庭战神">>)),
    {reply, {3, []}, Role};
handle(Cmd=16106, Data={_, _}, Role = #role{combat_pid = CPid}) when is_pid(CPid) ->
    case erlang:is_process_alive(CPid) of 
        true ->
            notice:alert(error, Role, ?MSGID(<<"正在战斗中, 不能参加中庭战神">>)),
            {reply, {3, []}, Role};
        false ->
            handle(Cmd, Data, Role#role{combat_pid = undefined})
    end;
handle(16106, {_, _}, Role = #role{status = Status}) when Status =/= ?status_normal ->
    ?DEBUG("error: 当前状态 ~p", [Status]),
    notice:alert(error, Role, ?MSGID(<<"当前状态下不能参加中庭战神">>)),
    {reply, {3, []}, Role};
handle(16106, {Rid, SrvId}, Role = #role{id = {Rid, SrvId}}) ->
    notice:alert(error, Role, ?MSGID(<<"自己就不要打自己拉，好痛的~">>)),
    {reply, {3, []}, Role};
handle(16106, _, Role = #role{lev = Lev}) when Lev < ?arena_career_lev ->
    notice:alert(error, Role, ?MSGID(<<"等级不够">>)),
    {reply, {3, []}, Role};
handle(16106, {TRid, TSrvId}, Role = #role{id = {SRid, SSrvId}, lev = Lev, event = Event, link = #link{conn_pid=ConnPid}, arena_career = #arena_career{free_count = Count1, pay_count = Count2, cooldown = CoolDown}}) when Lev >= ?arena_career_lev andalso Event =:= ?event_no ->
    case Count1 + Count2 > 0 of
        true ->
            Now = util:unixtime(),
            case CoolDown =:= 0 orelse Now >= CoolDown orelse vip:arena_loss(Role) of
                true ->
                    ?DEBUG("战斗开始"),
                    case arena_career_lock:lock({SRid, SSrvId}, {TRid, TSrvId}) of
                        true ->
                            case arena_career:combat_start(TRid, TSrvId, Role) of
                                {null, RangeRole} -> %% 列表需刷新
                                    notice:alert(error, Role, ?MSGID(<<"信息已过期">>)),
                                    arena_career_lock:unlock({SRid, SSrvId}, {TRid, TSrvId}),
                                    {reply, {0, RangeRole}, Role};
                                {ok, Role1} -> 
									Role2 = role_listener:special_event(Role1, {1028, finish}),
                                    Role3 = role_listener:special_event(Role2, {3004,1}),   %% 触发日常
                                    arena_career:notice_client(times, ConnPid, Count1 + Count2 - 1),
                                    {NewCount1, NewCount2} = case Count1 =:= 0 of
                                        true -> {0, Count2 - 1};
                                        false -> {Count1 - 1, Count2}
                                    end,
                                    NewRole = Role3#role{
                                        arena_career = Role3#role.arena_career#arena_career{
                                            free_count = NewCount1, 
                                            pay_count = NewCount2, 
                                            last_time = Now
                                        }
                                    },
                                    {reply, {4, []}, NewRole};
                                {error, Reason, Role1} ->
                                    notice:alert(error, Role, Reason),
                                    arena_career_lock:unlock({SRid, SSrvId}, {TRid, TSrvId}),
                                    {reply, {3, []}, Role1}
                            end;
                        {false, {TRid, TSrvId}} ->
                            notice:alert(error, Role, ?MSGID(<<"对方正在战斗中，请稍候">>)),
                            {reply, {3, []}, Role};
                        {false, {SRid, SSrvId}} ->
                            notice:alert(error, Role, ?MSGID(<<"您正在被挑战中，请稍候">>)),
                            {reply, {3, []}, Role};
                        {false, timeout} ->
                            notice:alert(error, Role, ?MSGID(<<"系统繁忙，请稍候">>)),
                            {reply, {3, []}, Role};
                        _ ->
                            ?ERR("锁定失败"),
                            notice:alert(error, Role, ?MSG_NULL),
                            {reply, {3, []}, Role}
                    end;
                false ->
                    notice:alert(error, Role, ?MSGID(<<"冷却中...">>)),
                    {reply, {2, []}, Role}
            end;
        false -> 
            notice:alert(error, Role, ?MSGID(<<"没有挑战次数了">>)),
            {reply, {1, []}, Role}
    end;
handle(16106, {_, _}, Role = #role{event = _Event, pos = _Pos}) ->
    ?DEBUG("error: 没匹配上 event = ~p, pos = ~p", [_Event, _Pos]), 
    notice:alert(error, Role, ?MSGID(<<"当前状态下无法参加中庭战神">>)),
    {reply, {3, []}, Role};

%% 英雄榜
handle(16107, {}, #role{}) ->
    case allow(arena_career_16107) of
        true ->
            Hero = arena_career_mgr:get_hero(),
            {reply, {Hero}};
        false ->
            {ok}
    end;

%% 获取奖励信息
% handle(16108, {}, #role{id = {_Rid, _SrvId}, career = _Career}) ->
%     % Reply = arena_career_mgr:award_info(Rid, SrvId, Career),
%     Reply = {100, 12800, 24*3600+7634}, %% TODO 
%     {reply, Reply};

%% 领取奖励
handle(16109, {}, Role = #role{id = {Rid, SrvId}, name = _Name}) ->
    case arena_career:get_award({Rid, SrvId}) of
        {?true, Stone, Coin, _AwardRank} ->
            case arena_career_dao:fetch_award({Rid, SrvId}) of
                true ->
                    case role_gain:do([#gain{label = coin, val = Coin}, 
                                    #gain{label = stone, val = Stone}], Role) of
                        {ok, Role1} ->
                            NewRole = role_api:push_assets(Role, Role1),
                            log:log(log_coin, {<<"中庭战神">>, <<"中庭战神">>, Role, Role1}),
                            log:log(log_stone, {<<"中庭战神">>, <<"中庭战神">>, Role, Role1}),
                            {reply, {}, NewRole};
                        {false, _G} ->
                            notice:alert(error, Role, ?MSGID(<<"领取奖励失败">>)),
                            {ok, Role}
                    end;
                false ->
                    ?ERR("[~p]领取奖励失败", [_Name]),
                    notice:alert(error, Role, ?MSGID(<<"领取奖励失败">>)),
                    {ok, Role}
            end;
        {?false, _, _} ->
            notice:alert(error, Role, ?MSGID(<<"没有奖励可以领取">>)),
            {ok, Role}
    end;

%% 获取跨服对手
% handle(16110, {}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
% handle(16110, {}, #role{id = {Rid, SrvId}, lev = Lev, career = Career}) when Lev >= ?arena_career_lev ->
%     case allow(arena_career_16110) of
%         true ->
%             RangeRole = case arena_career_mgr:check_center(Rid, SrvId, Career) of
%                 true ->
%                     arena_career:c_get_range(Rid, SrvId, Career);
%                 false ->
%                     []
%             end,
%             {reply, {RangeRole}};
%         false ->
%             ?DEBUG("cd时间,不响应"),
%             {ok}
%     end;

%% 获取个人战斗日志 
% handle(16111, {}, _Role) ->
%     %% TODO 预留协议
%     {ok};

%% 发起跨服挑战
% handle(16112, {_, _, _}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
% handle(16112, {_, _, _}, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
%     {reply, {3, ?L(<<"组队状态下不能参加中庭战神">>)}};
% handle(Cmd = 16112, Data = {_, _, _}, Role = #role{combat_pid = CPid}) when is_pid(CPid) ->
%     case erlang:is_process_alive(CPid) of 
%         true ->
%             {reply, {3, ?L(<<"战斗状态下无法参加中庭战神">>)}};
%         false ->
%             handle(Cmd, Data, Role#role{combat_pid = undefined})
%     end;
% handle(16112, {_, _, _}, #role{status = Status}) when Status =/= ?status_normal ->
%     {reply, {3, ?L(<<"该状态下无法参加中庭战神">>)}};
% handle(16112, {Rid, SrvId, _}, #role{id = {Rid, SrvId}}) ->
%     {reply, {3, ?L(<<"自己就不要打自己拉，好痛的~">>)}};
% handle(16112, {Rid, SrvId, Career}, Role = #role{lev = Lev, career = _Career2, event = Event, arena_career = #arena_career{free_count = Count1, pay_count = Count2, cooldown = CoolDown}}) when Lev >= ?arena_career_lev andalso Event =:= ?event_no andalso Career >= 1 andalso Career =< 5->
%     case arena_career:c_get_role_info(Rid, SrvId, Career) of
%         false -> {ok};
%         {_Rank, _GetLev} ->
%             Now = util:unixtime(),
%             case Count1 + Count2 > 0 of
%                 true ->
%                     case CoolDown =:= 0 of
%                         true ->
%                             case arena_career:c_combat_start(Rid, SrvId, Career, Role) of
%                                 null -> %% 列表需刷新
%                                     {reply, {0, <<>>}};
%                                 {ok, NewRole} -> 
%                                     NR = role_listener:special_event(NewRole, {1028, finish}),
%                                     {reply, {4, <<>>}, NR}
%                             end;
%                         false ->
%                             case Now >= CoolDown of
%                                 true ->
%                                     case arena_career:c_combat_start(Rid, SrvId, Career, Role) of
%                                         null -> %% 列表需刷新
%                                             {reply, {0, <<>>}};
%                                         {ok, NewRole} ->
%                                             NR = role_listener:special_event(NewRole, {1028, finish}),
%                                             {reply, {4, <<>>}, NR}
%                                     end;
%                                 false -> {reply, {2, <<>>}}
%                             end
%                     end;
%                 false -> {reply, {1, <<>>}}
%             end
%     end;
% handle(16112, {_, _}, _) ->
%     {reply, {3, ?L(<<"当前状态下无法参加中庭战神">>)}};

% handle(16113, {}, #role{}) ->
%     case arena_career_mgr:query_center() of
%         [] -> {ok};
%         [{Frid, Fsrvid, Fname, Trid, Tsrvid, Tname}] ->
%             {reply, {Frid, Fsrvid, Fname, Trid, Tsrvid, Tname}};
%         _ -> {ok}
%     end;

%% 获取个人信息
% handle(16114, {}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
% handle(16114, {}, Role = #role{id = {Rid, SrvId}, career = Career, lev = Lev, arena_career = ArenaCareer = #arena_career{free_count = Count1, pay_count = Count2, cooldown = CoolDown}}) when Lev >= ?arena_career_lev ->
%     case arena_career_mgr:check_center(Rid, SrvId, Career) of
%         true ->
%             case center:is_connect() of
%                 false -> {reply, {2, 0, 0, 0, 0, 0}};
%                 {true, _} ->
%                     case arena_career:c_get_role_info(Rid, SrvId, Career) of
%                         false -> {ok};
%                         {Rank, GetLev} ->
%                             Now = util:unixtime(),
%                             Cd = case CoolDown =:= 0 of
%                                 true -> 0;
%                                 false ->
%                                     case CoolDown - Now > 0 of
%                                         true -> CoolDown - Now;
%                                         false -> 0
%                                     end
%                             end,
%                             NewCoolDown = case Cd =:= 0 of
%                                 true -> 0;
%                                 false -> CoolDown 
%                             end,
%                             D = case arena_career_mgr:get_center_award() of
%                                 Day when is_integer(Day) -> Day;
%                                 _X ->
%                                     ?DEBUG("获取奖励发放时间错误:~w",[_X]),
%                                     3
%                             end,
%                             NewArenaCareer = ArenaCareer#arena_career{cooldown = NewCoolDown},
%                             {reply, {?true, Rank, GetLev, Count1 + Count2, Cd, D}, Role#role{arena_career = NewArenaCareer}}
%                     end
%             end;
%         false ->
%             {reply, {?false, 0, 0, 0, 0, 0}}
%     end;

%% 获取英雄榜
% handle(16115, {}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
% handle(16115, {}, #role{}) ->
%     case allow(arena_career_16115) of
%         true ->
%             HeroRole = arena_career_mgr:get_center_hero(),
%             {reply, {HeroRole}};
%         false ->
%             ?DEBUG("cd时间,不响应"),
%             {ok}
%     end;

%% 获取是否有跨服资格
% handle(16116, {}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
% handle(16116, {}, #role{id = {Rid, SrvId}, lev = Lev, career = Career}) when Lev >= ?arena_career_lev ->
%     case allow(arena_career_16116) of
%         true ->
%             case arena_career_mgr:check_center(Rid, SrvId, Career) of
%                 true ->
%                     case center:is_connect() of
%                         false -> {reply, {2}};
%                         {true, _} -> {reply, {?true}}
%                     end;
%                 false -> {reply, {?false}}
%             end;
%         false -> {ok}
%     end;

%% 连胜榜
handle(16118, {}, #role{}) ->
    case allow(arena_career_16118) of
        true ->
            Rank = arena_career_mgr:get_wins_rank(),
            {reply, {Rank}};
        false ->
            {ok}
    end;

%% 搜索最弱对手
handle(16119, {}, #role{lev = Lev}) when Lev < ?arena_career_lev -> {ok};
handle(16119, {}, Role = #role{lev = Lev}) when Lev >= ?arena_career_lev ->
    case allow(arena_career_16119) of
        true ->
            case arena_career:get_weakest(Role) of
                null ->
                    {ok};
                TargetRole ->
                    #arena_career_role{rid = TRid, srv_id = TSrvId, name = TName, sex = TSex, lev = TLev, face = TFace, fight_capacity = TFightCapacity, career = TCareer, rank = TRank, looks = Looks} = TargetRole,
                    {reply, {TRid, TSrvId, TName, TSex, TLev, TFace, TFightCapacity, TCareer, TRank, Looks}}
            end;
        false ->
            ?DEBUG("cd时间,不响应"),
            {ok}
    end;

%% 进入场景 
% handle(16120, _, #role{lev = Lev}) when Lev < ?arena_career_lev -> ?DEBUG("error: 等级不够25"), {ok};
% handle(16120, _, Role = #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
%     notice:alert(error, Role, ?MSGID(<<"组队状态下不能参加中庭战神">>)),
%     {ok};
% handle(Cmd = 16120, Data, Role = #role{combat_pid = CPid}) when is_pid(CPid) ->
%     case erlang:is_process_alive(CPid) of 
%         true ->
%             notice:alert(error, Role, ?MSGID(<<"正在战斗中, 不能参加中庭战神">>)),
%             {ok};
%         false ->
%             handle(Cmd, Data, Role#role{combat_pid = undefined})
%     end;
% handle(16120, _, Role = #role{status = Status}) when Status =/= ?status_normal ->
%     ?DEBUG("当前状态: ~p", [Status]),
%     notice:alert(error, Role, ?MSGID(<<"当前状态下不能参加中庭战神">>)),
%     {ok};
% handle(16120, {TRoleId, TSrvId}, Role = #role{lev = Lev, event = Event, arena_career = #arena_career{free_count = Count1, pay_count = Count2, cooldown = CoolDown}}) when Lev >= ?arena_career_lev andalso Event =:= ?event_no ->
%     case Count1 + Count2 > 0 of
%         true ->
%             Now = util:unixtime(),
%             case CoolDown =:= 0 orelse Now >= CoolDown of
%                 true ->
%                     case arena_career_lock:lock() of
%                         true ->
%                             NewRole = arena_career:enter_map(Role),
%                             {reply, {1}, NewRole};
%                         _ ->
%                             notice:alert(error, Role, ?MSGID(<<"...">>)),
%                             {ok}
%                     end;
%                 false ->
%                     notice:alert(error, Role, ?MSGID(<<"冷却中...">>)),
%                     {ok}
%             end;
%         false -> 
%             notice:alert(error, Role, ?MSGID(<<"没有挑战次数了">>)),
%             {ok}
%     end;
% handle(16120, _, Role = #role{event = Event}) ->
%     ?DEBUG("error: event = ~p", [Event]),
%     notice:alert(error, Role, ?MSGID(<<"当前状态下无法参加中庭战神">>)),
%     {ok};

%% 离开战斗场景
handle(16121, _, Role) ->
    NewRole = arena_career:leave_map(Role),
    {ok, NewRole};

%% 获取剩余次数
handle(16122, _, Role = #role{arena_career = #arena_career{free_count = Count1, pay_count = Count2}}) ->
    {reply, {Count1 + Count2}, Role};

%% 容错
handle(_Cmd, _Data, _Role) ->
    {error, arena_career_rpc_unknow_command}.

%% --------------------
allow(arena_career_16100) -> %% 冷却10S
    do_check(arena_career_16100, 10);
allow(arena_career_16110) -> %% 冷却10S
    do_check(arena_career_16110, 10);
allow(arena_career_16115) -> %% 冷却10S
    do_check(arena_career_16115, 3);
allow(arena_career_16116) -> %% 冷却2S
    do_check(arena_career_16116, 2);
allow(arena_career_16119) -> %% 冷却2S
    do_check(arena_career_16119, 2);
allow(arena_career_16107) -> %% 冷却10S
    do_check(arena_career_16107, 10);
allow(arena_career_16118) -> %% 冷却10S
    do_check(arena_career_16118, 10).


do_check(Type, N) ->
    case get(Type) of
        T when is_integer(T) ->
            case util:unixtime() - T > N of
                true ->
                    put(Type, util:unixtime()),
                    true;
                false ->
                    false
            end;
        _ ->
            put(Type, util:unixtime()),
            true
    end.
