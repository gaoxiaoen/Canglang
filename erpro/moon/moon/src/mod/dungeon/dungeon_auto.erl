%% -------------------------------------------------------------------
%% Description : 副本扫荡相关调用
%% Author  : mobin
%% -------------------------------------------------------------------
-module(dungeon_auto).

%% api functions
-export([
        auto/4,
        login/1,
        % check/2,
        gain_rewards/1,
        % stop_clear/1
        logout/1
    ]).

-include("common.hrl").
-include("dungeon.hrl").
-include("role.hrl").
-include("pet.hrl").
-include("assets.hrl").
-include("gain.hrl").
-include("npc.hrl").
-include("link.hrl").
-include("timing.hrl").
-include("vip.hrl").
-include("item.hrl").
-include("storage.hrl").

-define(proto_exp, 0).
-define(proto_coin, 3).

%% 是否挂机
-define(HOOK_NO, 0).
-define(HOOK_ING, 1).

-define(VIPLEV, 3).
-define(clear_item, 611501).

-define(apply_send, 1).
% -define(all_send, 0).

%% auto = {Hook, A, B, C}  A,B,C三个大参数是没有用到的，故都分配给了个无厘头的名字
% login(Role = #role{id = {Rid, _}, link = #link{conn_pid = ConnPid}}) ->
%     case dungeon_auto_mgr:fetch_reward(Rid) of 
%         {} ->
%             ?DEBUG("------没有扫荡-----~n~n~n~n"),
%             update_role_eventno(Role);
%         {Val, DungeonDrop} ->
%             ?DEBUG("---扫荡已完成！未领取掉落~n~n~n---"),
%             sys_conn:pack_send(ConnPid, 13590, {DungeonId, Count}),
%             Rewards = dungeon_auto_mgr:fetch_reward(Rid),
%             send_13585(ConnPid, {0, 0, Rewards}),
%             Role
%     end.
login(Role) -> Role.

logout(Role) ->
    ?DEBUG("掉线时获取扫荡掉落！！~n~n"),
    case gain_rewards(Role) of
        {false, _Reason, NRole, _Reply} ->
            Content = util:fbin(?L(<<"亲爱的玩家, 网络不稳定导致游戏异常掉线，扫荡掉落由于背包已满, 已经发送到你的奖励大厅，请前往查看">>), []),
            send_mail(NRole, Content),
            {ok, NRole};
        {false, _Reason} ->
            % {ok};
            {ok, Role};
        {ok, NR, _Reply} ->
            Content = util:fbin(?L(<<"亲爱的玩家, 网络不稳定导致游戏异常掉线，扫荡掉落已经发送到你的背包，请前往背包查看">>), []),
            send_mail(NR, Content),
            {ok, NR}
    end.
send_mail(Role, Content) ->
    mail:send_system(Role, {?L(<<"系统邮件">>), Content, [], []}),
    ok.


%% auto = {Hook, A, B, C}  A,B,C三个大参数是没有用到的，故都分配给了个无厘头的名字
% login(Role = #role{id = {Rid, _}, pid = RolePid, link = #link{conn_pid = ConnPid}, timer = Timers}) ->
%     case dungeon_auto_mgr:fetch_info(Rid) of 
%         [] ->
%             ?DEBUG("------没有扫荡-----~n~n~n~n"),
%             update_role_eventno(Role);
%         {Rid, _SrvId, DungeonId, Count, Rest_Count, Start_Time, Is_Stop} ->
%             Rewards = dungeon_auto_mgr:fetch_reward(Rid),
%             case Is_Stop of 
%                 1 ->
%                     ?DEBUG("---扫荡已被终止！未领取掉落~n~n~n---"),

%                     sys_conn:pack_send(ConnPid, 13590, {DungeonId, Count}),
%                     send_13585(ConnPid, {0, 0, lists:sublist(Rewards, Count - Rest_Count)}),
%                     Role;
%                 0 ->
%                     case Rest_Count of 
%                         0 ->
%                             ?DEBUG("---扫荡已完成！未领取掉落~n~n~n---"),
%                             sys_conn:pack_send(ConnPid, 13590, {DungeonId, Count}),
%                             send_13585(ConnPid, {0, 0, Rewards}),
%                             Role;
%                         _N ->
%                             Now = util:unixtime(),
%                             case Now - Start_Time >= ?dungeon_clear_time * Count of 
%                                 true -> %%离线时间较长，完成了扫荡
%                                     ?DEBUG("---离线时间较长，完成了扫荡~n~n~n---"),
%                                     update_info(rest_count, {Rid, 0}),
%                                     sys_conn:pack_send(ConnPid, 13590, {DungeonId, Count}),
%                                     send_13585(ConnPid, {0, 0, Rewards}),
%                                     Role1 = update_role_eventno(Role),
%                                     update_role_hookno(Role1);
%                                 false ->
%                                     All_Time = Now - Start_Time, %%开始扫荡至今时间隔离
%                                     Left_time  = ?dungeon_clear_time * Count  - All_Time,
%                                     ?DEBUG("--发送剩余时间--~p~n~n~n",[Left_time]),

%                                     sys_conn:pack_send(ConnPid, 13590, {DungeonId, Count}),
%                                     Finish = All_Time div ?dungeon_clear_time,
%                                     Next_Time = ?dungeon_clear_time - All_Time rem ?dungeon_clear_time,

%                                     update_info(rest_count, {Rid, Count - Finish}),
%                                     send_13585(ConnPid, {Count - Finish, Left_time, lists:sublist(Rewards, Finish)}),
%                                     Ref = erlang:send_after(Next_Time * 1000, RolePid, {clear_dungeon, {dungeon_auto, check, [{DungeonId, Count, Count - Finish, Rewards, ?apply_send}]}}),
%                                     NTimers = 
%                                         case lists:keyfind(clear_dungeon, #timing.id, Timers) of 
%                                             false ->
%                                                 T = #timing{id = clear_dungeon, ref = Ref},
%                                                 [T|Timers];
%                                             _ ->
%                                                 lists:keyreplace(clear_dungeon, #timing.id, Timers, #timing{id = clear_dungeon, ref = Ref})
%                                         end,
%                                     Role#role{timer = NTimers}
%                             end
%                     end;
%                 _ -> Role
%             end
%     end.

%%开始扫荡
% start_clear(Role = #role{id = {Rid, SrvId}, auto = {_, A, B, C}, pid = RolePid, timer = Timers}, {DungeonId, Count, Rewards}) ->
%     Start_Time = util:unixtime(),
%     case save_info({Rid, SrvId, DungeonId, Count, Count, Rewards, Start_Time}) of 
%         ok -> 
%             TimerRef = erlang:send_after(?dungeon_clear_time * 1000, RolePid, {clear_dungeon, {dungeon_auto, check, [{DungeonId, Count, Count, Rewards, ?apply_send}]}}),
%             T = #timing{id = clear_dungeon, ref = TimerRef},
%             Reply = {Count, Count * ?dungeon_clear_time, []},
%             role:send_buff_flush(),
%             % {Reply, Role#role{event = ?event_guaji, timer = [T|Timers]}};
%             {Reply, Role#role{auto = {?HOOK_ING, A, B, C}, timer = [T|Timers]}};
%         _ ->
%             role:send_buff_clean(),
%             {false, ?MSGID(<<"操作失败，请稍后再试">>)}
%     end.

%% call back func
% check(Role = #role{id = {Rid, _}, pid = RolePid, link = #link{conn_pid = ConnPid}, timer = Timers}, {DungeonId, Count, Rest_Count, Rewards, SFlag}) ->
%     {Reward, NRole} = 
%         case Rest_Count =:= 1 of %% 1表示最后一次 
%             true ->
%                 % sys_conn:pack_send(ConnPid, 11170, {[{13511, 0}]}),
%                 update_info(rest_count, {Rid, Rest_Count - 1}),
%                 Re = lists:last(Rewards),
%                 NTimers = lists:keydelete(clear_dungeon, #timing.id, Timers),
%                 Role1 = update_role_eventno(Role),
%                 Role2 = update_role_hookno(Role1),
%                 {Re, Role2#role{timer = NTimers}};
%             false ->
%                 update_info(rest_count, {Rid, Rest_Count - 1}),
%                 Ref = erlang:send_after(?dungeon_clear_time * 1000, RolePid, {clear_dungeon, {dungeon_auto, check, [{DungeonId, Count, Rest_Count - 1, Rewards, ?apply_send}]}}),
%                 Re = lists:nth(Count - (Rest_Count - 1), Rewards),
%                 NTimers = lists:keyreplace(clear_dungeon, #timing.id, Timers, #timing{id = clear_dungeon, ref = Ref}),
%                 {Re, Role#role{timer = NTimers}}
%         end,

%     %% 触发奇遇事件
%     % adventure_trigger(NRole, DungeonId, 1),
    
%     case SFlag of 
%         ?apply_send ->
%             send_13585(ConnPid, {Rest_Count - 1, (Rest_Count - 1) * ?dungeon_clear_time, [Reward]});
%         _ -> 
%             send_13585(ConnPid, {Rest_Count - 1, (Rest_Count - 1) * ?dungeon_clear_time, lists:sublist(Rewards, Count - (Rest_Count - 1))})
%     end,
%     {ok, NRole}.

% send_13585(ConnPid, {Left_times, Left_time, Rewards}) ->
%     ProtoRe = to_proto13585(Rewards),
%     sys_conn:pack_send(ConnPid, 13585, {Left_times, Left_time, ProtoRe}).

to_proto13585(Rewards) ->
    [{Exp, Coin, Point, PetExp, Fragiles ++ Items}||{Exp, Coin, _, Point, PetExp, Fragiles, Items}<-Rewards].

%%获取掉落
gain_rewards(Role = #role{id = {Rid, SrvId}, name = Name, pid = RolePid})  ->
    case dungeon_auto_mgr:fetch_info(Rid) of 
        {_, _, DungeonId, Count, Rest_Count, _, _} ->

            {Rewards, DungeonDrops} = dungeon_auto_mgr:fetch_reward(Rid),
            [dungeon_api:notify_to_the_world(Name, DungeonDrop)||DungeonDrop<-DungeonDrops],

            Actual_Reward = lists:sublist(Rewards, Count - Rest_Count),
            {Exp, Coin, Stone, Point, Pet_Exp, Fragiles, Items} = merge_rewards(Actual_Reward),
            Assets = [
                        #gain{label = exp, val = Exp},
                        #gain{label = coin, val = Coin},
                        #gain{label = stone, val = Stone},
                        #gain{label = attainment, val = Point}
                    ],

            {ok, Role0} = role_gain:do(Assets, Role),
            log:log(log_coin, {<<"副本扫荡">>, <<"副本扫荡">>, Role, Role0}),

            {ok, Role1} = demon:gain_debris(Role0, Fragiles),

            Role2 = pet_api:asc_pet_exp(Role1, Pet_Exp),

            dungeon_api:clear_dungeon(RolePid, DungeonId, 1, Count - Rest_Count),

            delete_info(Rid),

            case dungeon_auto_data:get(DungeonId) of
                #dungeon_auto_base{npcs = Npcs} ->
            % ?DEBUG("-----已扫荡的次数--：~p", [Count - Rest_Count]),
            % ?DEBUG("-----已扫荡的Npcs--：~p", [Npcs]),
                    role:apply(async, RolePid, {fun async_kill_npc/3, [Count - Rest_Count, Npcs]});
                false -> 
                    ignore
            end,

            % 1:经验，2:金币，3:技能点，4:宠物经验，5:物品.(非物品时，type与base_id相同)
            Reply = [{1, 1, Exp}, {2, 2, Coin}, {3, 3, Point}, {4, 4, Pet_Exp}] ++ format_items(Items ++ Fragiles),
            case deal_items(Role2, Items) of 
                {ok, R} -> {ok, R, Reply};
                {false, Rest, NR, _Reason} ->
                    award:send({Rid, SrvId}, 104005, Rest),
                    {false, ?MSGID(<<"背包已满，物品已发送到奖励大厅">>), NR, Reply}
            end;

        _ ->
             {false, ?MSGID(<<"您之前已获取掉落！">>)}
    end.

format_items([]) -> [];
format_items(Items) ->
    do_format_items(Items, []).
do_format_items([], Res) -> Res;
do_format_items([{BaseId, Num}|T], Res) ->
    case lists:keyfind(BaseId, 2, Res) of 
        false ->
            do_format_items(T, [{5, BaseId, Num}|Res]);
        {5, _, N} ->
            NRes = lists:keyreplace(BaseId, 2, Res, {5, BaseId, N + Num}),
            do_format_items(T, NRes)
    end.


% %%终止扫荡
% stop_clear(Role = #role{id = {Rid, _}, timer = Timers}) ->
%     case lists:keyfind(clear_dungeon, #timing.id, Timers) of 
%         #timing{ref = Ref} ->
%             case dungeon_auto_mgr:fetch_info(Rid) of 
%                 [] ->
%                      {false, ?L(<<"当前未进行扫荡或扫荡已结束！">>)};
%                 {_, _, _, Count, Rest_Count, _, _} ->
%                     ?DEBUG("--终止扫荡总次数-~p~n~n~n~n---", [Count]),
%                     ?DEBUG("--终止扫荡剩余次数-~p~n~n~n~n---", [Rest_Count]),
%                     case role_gain:do([#gain{label = energy, val = 5 * Rest_Count}], Role) of 
%                         {ok, NRole} ->
%                             erlang:cancel_timer(Ref),
%                             NTimers = lists:keydelete(clear_dungeon, #timing.id, Timers),
%                             case Count =:= Rest_Count of 
%                                 true ->
%                                     delete_info(Rid);
%                                 false -> 
%                                     update_info(stop_clear, {Rid, ?true})
%                             end,
%                             NRole1 = update_role_eventno(NRole),
%                             {ok, update_role_hookno(NRole1#role{timer = NTimers})};    
%                         {false, Reason} ->
%                             {false, Reason}
%                     end
%             end;
%         _ -> 
%             {false, ?MSGID(<<"当前未进行扫荡或扫荡已结束！">>)}
%     end.



%% @spec auto(DungeonId, Count, Imm, Role) -> {ok, Reply, Role} | {false, Reason}
%% DungeonId = Count = integer()
%% Imm 是否立即完成 ，1:是  0:否
%% Role = #role{}
%% Reason = bitstring()
auto(DungeonId, Count, _Imm, Role = #role{pid = _RolePid, 
        assets = #assets{energy = Energy}}) when Count > 0  andalso (Count =:= 1 orelse Count =:= 10) ->

    case check_all([ishard, ungain, stars3, count10], Role, {DungeonId, Count}) of 
        true ->    %%未进行扫荡
            %% 副本通关奖励
            DungeonBase = #dungeon_base{energy = CostEnergy, pet_exp = PetExp} = dungeon_data:get(DungeonId),
            case CostEnergy * Count =< Energy of
                false ->
                    {false, ?MSGID(<<"很遗憾，您的体力值不足了">>)};
                true ->

                    {ok, Role2} = role_gain:do([#loss{label = energy, val = CostEnergy * Count}], Role),

                    {GainsList, DungeonDrops, PetExp1} = 
                        case lists:member(DungeonId, leisure_goals_data:dungeon_list()) of %% 判断是否是趣味副本
                            false ->
                                % DungeonAutoBase = dungeon_auto_data:get(DungeonId),
                                % {GainsList1, DungeonDrop} = get_auto_rewards(Count, DungeonBase, DungeonAutoBase, Role2, [], []),
                                {GainsList1, DungeonDrop} = get_auto_rewards(Count, DungeonBase, Role2, [], []),
                                {GainsList1, DungeonDrop, PetExp};
                            true -> 
                                GainsList1 = get_auto_rewards2(Count, Role2, DungeonId, []),
                                {GainsList1, [], 0}
                        end,

                    ProtoGains = [get_proto_gains(Gains) || Gains <- GainsList],
                    ProtoGains2 = [{Exp, Coin, Stone, Point, PetExp1, Fragiles, Items} || {Exp, Coin, Stone, Point, Fragiles, Items} <- ProtoGains],

                    % case Imm of 
                    %     1 ->
                            log:log(log_dungeon_drop, {<<"副本扫荡掉落">>, DungeonId, util:fbin("~w", [DungeonDrops]), Role}),
                            do_auto(Role2, DungeonId, Count, ProtoGains2, DungeonDrops)

                        % 0 ->
                        %     % ?DEBUG("----ProtoGains2-----~p~n",[ProtoGains2]),
                        %     start_clear(Role2, {DungeonId, Count, ProtoGains2}) 
                    % end
            end;
        Other -> %%正在进行扫荡
            % case Imm of 
            %     0 -> {false, ?MSGID(<<"当前状态不能进行扫荡">>)};
            %     1 -> clear_now(Role, DungeonId)
            % end
            Other
    end;

auto(_Did, _Count, _, _Role) ->
    ?DEBUG("Did:~p---Count:~p-~n~n~n~n", [_Did, _Count]),
    {false, ?MSGID(<<"扫荡失败">>)}.

% add_2_gains(DungeonGain, GainsList) ->
%     L = erlang:length(DungeonGain),
%     case L > 0 of
%         true ->


%         false ->
%             GainsList
%     end.


do_auto(Role2 = #role{id = {Rid, SrvId}}, DungeonId, Count, ProtoGains2, DungeonDrop) ->
    Loss = calc_loss(Role2, Count),
    case role_gain:do(Loss, Role2) of 
        {ok, Role3} ->
            Reply = {0, 0, to_proto13585(ProtoGains2)},
            save_info({Rid, SrvId, DungeonId, Count, 0, ProtoGains2, util:unixtime(), DungeonDrop}),%%记录副本扫荡，在领取掉落之前掉线也不影响
            Role4 = update_role_eventno(Role3),

            %% 触发奇遇事件
            % adventure_trigger(Role4, DungeonId, Count),
            %% 添加困难副本进入次数
            Role5 = add_dungeon_enter_count(Role4, DungeonId, Count),

            {Reply, update_role_hookno(Role5)};

        {false, #loss{msg = Msg}} -> 
            {false, Msg};
        {false, Rea} -> 
            {false, Rea}
    end.

calc_loss(#role{bag = #bag{items = Items}}, Count) ->
    case storage:find(Items, #item.base_id, ?clear_item) of 
        {false, _Msg} -> 
            [#loss{label = gold, val = Count * ?clear_loss, msg = ?MSGID(<<"晶钻不足">>)}];
        {ok, Num, _, _, _} -> 
            if
                Num >= Count ->
                    [#loss{label = item, val = [?clear_item, 1, Count]}];
                true ->
                    [
                        #loss{label = item, val = [?clear_item, 1, Num]},
                        #loss{label = gold, val = (Count - Num) * ?clear_loss, msg = ?MSGID(<<"晶钻不足">>)}    
                    ]
            end
    end.

check_all([], _, _) ->
    true;
check_all([H|T], Role, {DungeonId, Count}) -> 
    case check_condition(H, Role, {DungeonId, Count}) of 
        true ->
            check_all(T, Role, {DungeonId, Count});
        Other -> Other
    end.

check_condition(ishard, #role{dungeon = RoleDungeons}, {DungeonId, Count}) ->
    case dungeon_api:is_hard(DungeonId) of 
        true ->
            LeftCount = dungeon_type:get_left_count(DungeonId, RoleDungeons),
            case LeftCount >= Count of 
                true ->
                    true;
                false -> 
                    {false, ?MSGID(<<"副本可进入次数不足！">>)}
            end;
        false ->
            true
    end; 

check_condition(ungain, #role{id = {Rid, _}}, _) ->
    case dungeon_auto_mgr:fetch_info(Rid) of 
        [] -> 
           true;
        _ -> {false, ?MSGID(<<"上次扫荡结果尚未领取！">>)}
    end;

check_condition(stars3, #role{dungeon = RoleDungeons}, {DungeonId, _Count}) ->
    case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        #role_dungeon{best_star = BestStar} when BestStar >= 3->
            true;
        _ -> {false, ?MSGID(<<"副本未获得3颗星！">>)}
    end;

check_condition(count10, #role{vip = #vip{type = Lev}}, {DungeonId, Count}) ->
    case Count =:= 10 of 
        false -> 
            true;
        true -> 
            case dungeon_api:is_hard(DungeonId) of 
                true -> 
                    {false, ?MSGID(<<"困难副本每次不能进行10次扫荡!">>)};
                false ->
                    case Lev >= ?VIPLEV of
                        true -> 
                            true;
                        false ->
                            {false, ?MSGID(<<"vip等级不足,不能进行10次扫荡!">>)}
                    end
            end
    end;

check_condition(_, _, _) ->
    {false, ?MSGID(<<"错误的判断类型！">>)}.

add_dungeon_enter_count(Role = #role{dungeon = RoleDungeons}, DungeonId, Count) ->
    case dungeon_api:is_hard(DungeonId) of 
        true -> 
            NRoleDungeons = dungeon_type:add_enter_count(RoleDungeons, DungeonId, Count),
            Role#role{dungeon = NRoleDungeons};
        false -> 
            Role
    end.


% %%立即完成扫荡
% clear_now(Role = #role{id = {Rid, _}, timer = Timers}, _DungeonId) ->
%     case lists:keyfind(clear_dungeon, #timing.id, Timers) of 
%         false ->
%             {false, ?MSGID(<<"扫荡已完成！">>)};
%         #timing{ref = Ref} ->
%             case dungeon_auto_mgr:fetch_info(Rid) of 
%                 {_, _, _, Count, Rest_Count, _, _} ->
%                     case Rest_Count =:= 0 of 
%                         true ->  {false, ?MSGID(<<"扫荡已完成！">>)};
%                         false ->
%                             case role_gain:do([#loss{label = gold, val = Rest_Count * ?clear_loss, msg = ?MSGID(<<"晶钻不足">>)}], Role) of
%                                 {false, #loss{msg = Msg}} ->
%                                     {false, Msg}; 
%                                 {false, Reason} -> 
%                                     {false, Reason};
%                                 {ok, NewRole} ->
%                                     erlang:cancel_timer(Ref),
%                                     Rewards = dungeon_auto_mgr:fetch_reward(Rid),
%                                     Reply = {0, 0, to_proto13585(lists:sublist(Rewards, Count - (Rest_Count - 1), Count))},
%                                     NTimers = lists:keydelete(clear_dungeon, #timing.id, Timers),
%                                     update_info(rest_count, {Rid, 0}),
%                                     NewRole1 = update_role_eventno(NewRole),

%                                     %% 触发奇遇事件
%                                     % adventure_trigger(NewRole1, DungeonId, Rest_Count),

%                                     {Reply, update_role_hookno(NewRole1#role{timer = NTimers})}
%                             end
%                     end;
%                 _ ->
%                     {false, ?MSGID(<<"扫荡已完成！">>)}
%             end
%     end.

get_auto_rewards(0, _DungeonBase, _Role, Return, DungeonDrops) ->
    {Return, DungeonDrops};
get_auto_rewards(Count, DungeonBase = #dungeon_base{id = DungeonId, cards_id = CardsId, clear_rewards = ClearRewards}, 
        Role = #role{pid = _RolePid}, Return, DungeonDrops) ->
    
    % Npcs2 = get_slaves(Npcs, []) ++ Npcs,

    % NpcRewards = lists:foldl(fun(NpcBaseId, Sum) -> 
    %             get_npc_rewards(NpcBaseId) ++ Sum 
    %     end, [], Npcs2), 
    % %%[#gain{}, #gain{}, ...]
    % DropItems = get_drop(Npcs2),
    %%vip
    ClearRewards2 = dungeon_api:get_vip_rewards(ClearRewards, Role),
    
    ClearRewards3 = case CardsId =/= 0 of
        true ->
            CardsItem = dungeon_cards:get_config_item(CardsId, Role),
            [CardsItem | ClearRewards2];
        false ->
            ClearRewards2
    end,

    DungeonDrop = dungeon_api:get_dungeon_drop(DungeonId, 1, 0),

    DungeonGain = dungeon_api:make_gain_info(DungeonDrop),

    ClearTicket = get_clear_ticket_radomly(),

    % Gains = ClearTicket ++ DungeonGain ++ ClearRewards3 ++ DropItems ++ NpcRewards,
    Gains = ClearTicket ++ DungeonGain ++ ClearRewards3,
    Gains2 = merge_gains(Gains),
    get_auto_rewards(Count - 1, DungeonBase, Role, [Gains2 | Return], [DungeonDrop | DungeonDrops]).

get_auto_rewards2(0, _Role, _DungeonId, Return) ->
    Return;
get_auto_rewards2(Count, Role, DungeonId, Return) ->
    A = leisure:calc_leisure_award(Role, DungeonId, 5),
    ClearTicket = get_clear_ticket_radomly(),
    get_auto_rewards2(Count - 1, Role, DungeonId, [ClearTicket ++ A |Return]).

% 611501
get_clear_ticket_radomly() ->
    Random = util:rand(1, 100),
    case Random =< 20 of 
        true ->
            [#gain{label = item, val = [611501, 0, 1]}];
        false ->[]
    end.

% get_slaves([], Return) -> Return;
% get_slaves([H|T], Return) ->
%     case npc_data:get(H) of
%         {ok,  #npc_base{slave = Slaves}} -> 
%             SlaNpc = [Npcid||{Npcid, _, _}<-Slaves],
%             get_slaves(T, SlaNpc ++ Return);
%         _ -> 
%             get_slaves(T, Return)
%     end.

%% 掉落
% get_drop(NpcBaseIds) ->
%     DropRatio = case platform_cfg:get_cfg(drop_ratio) of
%         false -> 1;
%         Value -> Value / 100
%     end,
%     Ratio2 = erlang:round(100 * DropRatio),
%     {Sitems, Items} = drop:produce(NpcBaseIds, Ratio2),
%     [G || {_, G} <- Sitems] ++ flat([Gs || {_, Gs} <- Items]).

% get_npc_rewards(NpcBaseId) ->
%     case npc_data:get(NpcBaseId) of
%         {ok, #npc_base{rewards = Rewards}} ->
%             Rewards;
%         _ ->
%             []
%     end.

% 完成杀怪的触发
async_kill_npc(Role, _, []) ->
    {ok, Role};
async_kill_npc(Role, Num, [H | T]) ->
    Role2 = role_listener:kill_npc(Role, H, Num),
    async_kill_npc(Role2, Num, T).

% 完成杀怪的触发
% async_kill_npc(Role, []) ->
%     {ok, Role};
% async_kill_npc(Role, [H | T]) ->
%     Role2 = role_listener:kill_npc(Role, H, 1),
%     async_kill_npc(Role2, T).

%% 由gain产生物品
get_proto_gains(Gains) ->
    get_proto_gains(Gains, 0, 0, 0, 0, [], []).

get_proto_gains([], Exp, Coin, Stone, Point, Fragiles, Return) ->
    {Exp, Coin, Stone, Point, Fragiles, Return};

get_proto_gains(List, Exp, Coin, Stone, Point, Fragiles, Return) ->
    do_get_proto_gains(List, Exp, Coin, Stone, Point, Fragiles, Return).

do_get_proto_gains([], Exp, Coin, Stone, Point, Fragiles, Return) ->
    {Exp, Coin, Stone, Point, Fragiles, Return};

do_get_proto_gains([#gain{label = item, val = [ItemBaseId, _Bind, Count]} | T], Exp, Coin, Stone, Point, Fragiles, Return) ->
    do_get_proto_gains(T, Exp, Coin, Stone, Point, Fragiles, [{ItemBaseId, Count} | Return]);

do_get_proto_gains([#gain{label = exp, val = Value} | T], Exp, Coin, Stone, Point, Fragiles, Return) ->
    do_get_proto_gains(T, Exp + Value, Coin, Stone, Point, Fragiles, Return);

do_get_proto_gains([#gain{label = exp_npc, val = Value} | T], Exp, Coin, Stone, Point, Fragiles, Return) ->
    do_get_proto_gains(T, Exp + Value, Coin, Stone, Point, Fragiles, Return);

do_get_proto_gains([#gain{label = coin, val = Value} | T], Exp, Coin, Stone, Point, Fragiles, Return) ->
    do_get_proto_gains(T, Exp, Coin + Value, Stone, Point, Fragiles, Return);

do_get_proto_gains([#gain{label = stone, val = Value} | T], Exp, Coin, Stone, Point, Fragiles, Return) ->
    do_get_proto_gains(T, Exp, Coin, Stone + Value, Point, Fragiles, Return);    

do_get_proto_gains([#gain{label = attainment, val = Value} | T], Exp, Coin, Stone, Point, Fragiles, Return) ->
    do_get_proto_gains(T, Exp, Coin, Stone, Point + Value, Fragiles, Return);

do_get_proto_gains([#gain{label = fragile, val = [ItemBaseId, Num]} | T], Exp, Coin, Stone, Point, Fragiles, Return) ->
    do_get_proto_gains(T, Exp, Coin, Stone, Point,  [{ItemBaseId, Num}|Fragiles], Return);

do_get_proto_gains([_ | T], Exp, Coin, Stone, Point, Fragiles, Return) ->
    do_get_proto_gains(T, Exp, Coin, Stone, Point, Fragiles, Return).

% %% 合并列表
% flat(L) ->
%     flat(L, []).
% flat([], Back) ->
%     Back;
% flat([H | T], Back) ->
%     flat(T, Back ++ H).

merge_gains(Gains) ->
    merge_gains(Gains, []).
merge_gains([], Return) ->
    Return;
merge_gains([H | T], Return) ->
    Return2 = merge(H, Return),
    merge_gains(T, Return2).

merge(Gain, Gains) ->
    merge(Gain, Gains, []). 
merge(Gain, [], Return) ->
    [Gain | Return];
merge(Gain = #gain{label = Label, val = Value}, [Gain2 = #gain{label = Label2, val = Value2} | T], Return) ->
    case Label =:= Label2 of
        false ->
            merge(Gain, T, [Gain2 | Return]);
        true ->
            case Label of
                item ->
                    [ItemBaseId, Bind, Num] = Value,
                    [ItemBaseId2, Bind2, Num2] = Value2,
                    case ItemBaseId =:= ItemBaseId2 andalso Bind =:= Bind2 of
                        false ->
                            merge(Gain, T, [Gain2 | Return]);
                        true ->
                            [Gain#gain{val = [ItemBaseId, Bind, Num + Num2]} | T] ++ Return
                    end;
                fragile ->
                    [ItemBaseId, Num] = Value,
                    [ItemBaseId2, Num2] = Value2,
                    case ItemBaseId =:= ItemBaseId2 of 
                        true ->
                            [Gain#gain{val = [ItemBaseId, Num + Num2]} | T] ++ Return;
                        false ->
                            merge(Gain, T, [Gain2 | Return])
                    end;
                _ ->
                    [Gain#gain{val = Value + Value2} | T] ++ Return
            end
    end.


save_info({Rid, SrvId, DungeonId, Count, Rest_Count, Rewards, Start_Time, DungeonDrop}) ->
    Is_Stop = ?false,
    % case dungeon_auto_dao:insert_info({Rid, SrvId, DungeonId, Count, Rest_Count, Start_Time, Is_Stop, Rewards}) of 
    %     {ok, _} -> 
            dungeon_auto_mgr:insert_info({Rid, SrvId, DungeonId, Count, Rest_Count, Start_Time, Is_Stop}),
            dungeon_auto_mgr:insert_reward({Rid, Rewards, DungeonDrop}).
    %         ok;
    %     _ -> false
    % end.

% update_info(Event, {Rid, Is_Stop}) ->
%     case dungeon_auto_dao:update_info(Event, {Rid, Is_Stop}) of 
%         {ok, _} -> 
%             dungeon_auto_mgr:update_info(Event, {Rid, Is_Stop});
%         _ -> false
%     end.

delete_info(Rid) ->
    % dungeon_auto_dao:delete_info(Rid),
    dungeon_auto_mgr:delete_info(Rid),
    dungeon_auto_mgr:delete_reward(Rid).


%%更新挂机状态为停止挂机
update_role_hookno(Role = #role{auto = {Hook, A, B, C}}) ->
    case Hook of 
        ?HOOK_ING ->
            Role#role{auto = {?HOOK_NO, A, B, C}};
        _  ->
            Role
    end.
%%当event状态为event_guaji时更新为event_no
update_role_eventno(Role = #role{event = Event}) ->
    case Event of 
        ?event_guaji ->
            Role#role{event = ?event_no};
        _ ->
            Role
    end.

%%处理扫荡获取的物品
deal_items(Role, []) -> {ok, Role};
deal_items(Role, [{BaseId, Num}|T]) ->
    role:send_buff_begin(),
    case role_gain:do([#gain{label = item, val = [BaseId, 1, Num]}], Role) of 
        {ok, NewRole} ->
            role:send_buff_flush(),
            deal_items(NewRole, T);
        {false, #gain{msg = Msg}} ->
            role:send_buff_clean(),
            Rest = [ #gain{label = item, val = [Base, 1, N]}|| {Base, N} <- [{BaseId, Num}|T]],
            {false, Rest, Role, Msg}
    end.


merge_rewards([]) ->{0, 0, 0, 0, 0, [], []};
merge_rewards(Rewards) ->
    do_merge_rewards(Rewards, {0, 0, 0, 0, 0, [], []}).

do_merge_rewards([], Result) ->
    Result;
do_merge_rewards([{HExp, HCoin, HStone, HPoint, HPetExp, HFragiles, HItems}| T], {Exp, Coin, Stone, Point, PetExp, Fragiles, Items}) ->
    NItems = do_merge_items(HItems, Items),
    do_merge_rewards(T, {HExp + Exp, HCoin + Coin, HStone + Stone, HPoint + Point, HPetExp + PetExp, HFragiles ++ Fragiles, NItems}).

do_merge_items([], Items) -> Items;
do_merge_items([{Item_BaseId, Num}|T], Items) ->
    case lists:keyfind(Item_BaseId, 1, Items) of 
        {_, Num2} ->
            NItems = lists:keyreplace(Item_BaseId, 1, Items, {Item_BaseId, Num + Num2}),
            do_merge_items(T, NItems);
        false ->
            do_merge_items(T, [{Item_BaseId, Num}] ++ Items)
    end.

% adventure_trigger(_Role, _DungeonId, Times) when Times =< 0 -> ok;
% adventure_trigger(Role, DungeonId, Times) ->
%     adventure:trigger_adventure(Role, DungeonId, ?false, ?true),
%     adventure_trigger(Role, DungeonId, Times - 1).
