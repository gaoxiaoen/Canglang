%%----------------------------------------------------
%% 手工代码配置活动奖励模块
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(campaign_reward).
-export([
        reward_loss_gold/3
        ,get_loss_gold/1
        ,get_reward_list/1
        ,handle_loss/2
        ,handle/3
        ,push_spring_campaign/2
        ,spring_festive_reward/3
        %% gm命令
        ,adm_set_spring_days/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").
-include("mail.hrl").
-include("gain.hrl").
-include("pet.hrl").
-include("item.hrl").
-include("link.hrl").
-include("vip.hrl").

-define(CAMP_TOTAL, #campaign_total{id = 1, name = ?L(<<"畅享飞仙活动">>)}).
-define(CAMP, #campaign_adm{id = 1, title = ?L(<<"畅享飞仙活动">>)}).
-define(LOGIN_ALL, #campaign_cond{id = 1001, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"活动期首先登陆">>)}). %% 该事件每次活动id不能重复
-define(LOGIN_First, #campaign_cond{id = 1002, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"活动期间每天首次登陆">>)}). %% 该事件每次活动id不能重复
-define(LOGIN_30, #campaign_cond{id = 10, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"登录30分钟活动">>)}).
-define(LOGIN_60, #campaign_cond{id = 11, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"登录60分钟活动">>)}).
-define(LOGIN_90, #campaign_cond{id = 12, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"登录90分钟活动">>)}).
-define(LOGIN_120, #campaign_cond{id = 13, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"登录120分钟活动">>)}).
-define(LOGIN_150, #campaign_cond{id = 14, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"登录150分钟活动">>)}).
-define(LOGIN_180, #campaign_cond{id = 15, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"登录180分钟活动">>)}).
-define(FLOWER, #campaign_cond{id = 2, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"送花活动">>)}).
-define(ACTIVITY70, #campaign_cond{id = 3, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"70活跃度活动">>)}).
-define(ACTIVITY100, #campaign_cond{id = 4, reward_num = 1, settlement_type = ?camp_settlement_type_everyday, msg = ?L(<<"100活跃度活动">>)}).
-define(KILL_NPC_24203, #campaign_cond{id = 8, reward_num = 2, settlement_type = ?camp_settlement_type_all, msg = ?L(<<"精灵幻境3层活动">>)}).
-define(KILL_NPC_24205, #campaign_cond{id = 9, reward_num = 2, settlement_type = ?camp_settlement_type_all, msg = ?L(<<"精灵幻境5层活动">>)}).

%% 获取春节活动状态（协议返回格式）
push_spring_campaign(online_days, #role{link = #link{conn_pid = ConnPid}, campaign = #campaign_role{spring_festive = #campaign_spring_festive{online_days = Days, all_online_reward = AllRewarded}, day_online = {_, AccTime}}}) ->
    Now = util:unixtime(),
    Today  = {_, _, Day} = erlang:date(),
    {StartTime, EndTime} = campaign_adm_data:spring_festive_time(),
    case Now >= StartTime andalso EndTime >= Now of
        true ->
            F = fun({{Y, M, D}, St}) ->
                    NewSt = case Today > {Y, M, D} of
                        true when St =:= 2 -> 2;
                        true -> 0;
                        _ -> St
                    end,
                    {Y, M, D, NewSt}
            end,
            ProDays = [F(D) || D <- Days],
            OnlineNum = length([OD || {_Y, _M, OD, 2} <- ProDays]),
            CanRewardAll = case Today of
                ?spring_festive_reward_sign_date when OnlineNum >= 11 andalso AllRewarded =/= 1 -> 1;
                _ -> 0
            end,
            sys_conn:pack_send(ConnPid, 15859, {ProDays, max(?spring_festive_sign_time_need - AccTime, 0), CanRewardAll, OnlineNum, Day});
        _ ->
            ok
    end;
push_spring_campaign(loss_gold, #role{link = #link{conn_pid = ConnPid}, campaign = #campaign_role{spring_festive = #campaign_spring_festive{day_loss_gold = DayLost, day_loss_reward = RewartTime, last_loss_gold = LastLost}}}) ->
    Now = util:unixtime(),
    {StartTime, EndTime} = campaign_adm_data:spring_festive_time(),
    case Now >= StartTime andalso EndTime >= Now of
        true ->
            IsRewarded = util:is_same_day2(Now, RewartTime),
            MaxGoldLost = campaign_adm_data:spring_festive_loss_gold_base(),
            PushData = case util:is_same_day2(LastLost, Now) of
                true when IsRewarded ->
                    {min(MaxGoldLost, DayLost), MaxGoldLost, 1};
                true ->
                    {min(MaxGoldLost, DayLost), MaxGoldLost, 0};
                _ ->
                    {0, MaxGoldLost, 0}
            end,
            sys_conn:pack_send(ConnPid, 15862, PushData);
        _ ->
            ok
    end.

%% 每日消耗晶钻在自动发放时已经判断时间了，所以在这里不再判断活动时间
spring_festive_reward(loss_gold, Role = #role{campaign = Camp = #campaign_role{spring_festive = Spring = #campaign_spring_festive{day_loss_gold = DayLost, day_loss_reward = RewartTime}}}, Now) ->
    MaxGoldLost = campaign_adm_data:spring_festive_loss_gold_base(),
    case util:is_same_day2(Now, RewartTime) of
        false when DayLost >= MaxGoldLost ->
            Subject = ?L(<<"新年消费，礼包回馈">>),
            Content = util:fbin(?L(<<"亲爱的玩家，活动期间，您今日消费达~w晶钻，获得了以下超值奖励，请注意查收！感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>), [MaxGoldLost]),
            Items = [{29485, 1, 1}],
            mail_mgr:deliver(Role, {Subject, Content, [], Items}),
            NewSpring = Spring#campaign_spring_festive{day_loss_reward = Now},
            NR = Role#role{campaign = Camp#campaign_role{spring_festive = NewSpring}},
            push_spring_campaign(loss_gold, NR),
            NR;
        _ ->
            push_spring_campaign(loss_gold, Role),
            Role
    end;
%% 在线天数手工领取，这里做下判断
spring_festive_reward(online_days, Role = #role{pid = Pid, campaign = Camp = #campaign_role{spring_festive = Spring = #campaign_spring_festive{online_days = Days}}}, Day) ->
    Now = util:unixtime(),
    {StartTime, EndTime} = campaign_adm_data:spring_festive_time(),
    case Now >= StartTime andalso EndTime >= Now of
        true ->
            case lists:keyfind(Day, 1, Days) of
                {Day, 1} ->
                    Gains = [#gain{label = item, val = [29486, 1, 1]}],
                    case role_gain:do(Gains, Role) of
                        {ok, Role1} ->
                            NewDays = lists:keyreplace(Day, 1, Days, {Day, 2}),
                            ItemStr = notice:gain_to_item3_inform(Gains),
                            notice:inform(Pid, util:fbin(?L(<<"获得~s">>), [ItemStr])),
                            Role2 = Role1#role{campaign = Camp#campaign_role{spring_festive = Spring#campaign_spring_festive{online_days = NewDays}}},
                            log:log(log_handle_all, {15860, <<"春节登录奖励">>, <<"获得物品29486">>, Role2}),
                            push_spring_campaign(online_days, Role2),
                            {ok, Role2};
                        _ ->
                            {false, ?L(<<"背包满了吧？">>)}
                    end;
                _ ->
                    {false, ?L(<<"没奖励可以领取">>)}
            end;
        _ ->
            {false, ?L(<<"现在不是活动时间，不能领取奖励">>)}
    end;
spring_festive_reward(all_online_days, Role = #role{pid = Pid, campaign = Camp = #campaign_role{spring_festive = Spring = #campaign_spring_festive{online_days = Days, all_online_reward = Rewarded}, day_online = {_, AccTime}}}, Day) ->
    case Day of
        ?spring_festive_reward_sign_date ->
            ADayNum = length([1 || {?spring_festive_reward_sign_date, 1} <- Days]),
            case length([OD || {OD, 2} <- Days]) of
                _ when Rewarded =/= 0 ->
                    {false, ?L(<<"你已经领取过奖励了">>)};
                _ when ADayNum =/= 0 ->
                    {false, ?L(<<"请先领取今天的登录奖励">>)};
                0 ->
                    {false, ?L(<<"没奖励可以领取">>)};
                Num when Num < 11 ->
                    {false, ?L(<<"你累积登录不够11天,不能领取奖励">>)};
                Num when AccTime >= ?spring_festive_sign_time_need ->
                    Gains = case Num - 10 of
                        9 -> [#gain{label = item, val = [29487, 1, 9]}, #gain{label = item, val = [21022, 1, 2]}];
                        Num1 -> [#gain{label = item, val = [29487, 1, Num1]}]
                    end,
                    case role_gain:do(Gains, Role) of
                        {ok, Role1} ->
                            ItemStr = notice:gain_to_item3_inform(Gains),
                            notice:inform(Pid, util:fbin(?L(<<"获得~s">>), [ItemStr])),
                            Role2 = Role1#role{campaign = Camp#campaign_role{spring_festive = Spring#campaign_spring_festive{all_online_reward = 1}}},
                            log:log(log_handle_all, {15861, <<"春节累积登录奖励">>, util:fbin(<<"获得物品~s">>, [ItemStr]), Role2}),
                            push_spring_campaign(online_days, Role2),
                            {ok, Role2};
                        _ ->
                            {false, ?L(<<"背包满了吧？">>)}
                    end;
                _ ->
                    {false, ?L(<<"现在不可以领取奖励">>)}
            end;
        _ ->
            {false, ?L(<<"现在不可以领取奖励">>)}
    end.

%% 获取当前总消耗晶钻数
get_loss_gold(Role) ->
    case camp_gold_times()  of
        [{Label, _, _, _, _} | _] -> get_loss_gold(Role, Label);
        _ -> 0
    end.
get_loss_gold(#role{campaign = #campaign_role{loss_gold = {Label, Gold, _}}}, Label) -> Gold;
get_loss_gold(_Role, _Label) -> 0.

%% 获取当前总消耗奖励情况列表
get_reward_list(Role) ->
    Now = util:unixtime(),
    case camp_gold_times() of
        [{Label, _, _, StartTime, EndTime} | _] ->
            Time1 = case Now >= StartTime of
                true -> 0;
                false -> StartTime - Now
            end,
            Time2 = case Now >= EndTime of
                true -> 0;
                false -> EndTime - Now
            end,
            RewardList = reward_list(Role, Label),
            {Time1, Time2, [Id || {Id, _} <- RewardList]};
        _ ->
            {0, 0, []}
    end.

reward_list(#role{campaign = #campaign_role{loss_gold = {Label, _, _}, reward_list = RewardList}}, Label) -> RewardList;
reward_list(_Role, _Label) -> [].

%% 领取总消耗奖励数据
handle_loss(Role = #role{campaign = Camp}, Id) ->
    Now = util:unixtime(),
    case camp_gold_times() of
        [{Label, _, _, StartTime, _EndTime} | _] when StartTime =< Now ->
            AccGold = get_loss_gold(Role, Label),
            RewardList = reward_list(Role, Label),
            RewardData = camp_gold_reward(Label),
            case lists:keyfind(Id, 1, RewardList) of
                false ->
                    case lists:keyfind(Id, 1, RewardData) of
                        false -> {false, ?L(<<"没有相关奖励数据">>)};
                        {Id, NeedGold, _Items} when AccGold < NeedGold ->
                            {false, util:fbin(?L(<<"累计消耗~p晶钻才能领取此奖励，当前总消耗~p晶钻">>), [NeedGold, AccGold])};
                        {Id, _NeedGold, Items} ->
                            ItemGL = [#gain{label = item, val = [BaseId, Bind, Num]} || {BaseId, Bind, Num} <- Items],
                            case role_gain:do(ItemGL, Role) of
                                {false, _} -> {false, ?L(<<"背包已满，请整理背包后再领取！">>)};
                                {ok, NRole} ->
                                    Msg = notice_inform:gain_loss(ItemGL, ?L(<<"参与活动">>)),
                                    notice:inform(Role#role.pid, Msg),
                                    NewRole = NRole#role{campaign = Camp#campaign_role{reward_list = [{Id, Now} | RewardList]}},
                                    log:log(log_handle_all, {15808, <<"总消耗活动奖励">>, util:fbin("[~s]奖励领取:~p[消耗晶钻:~p]", [Label, Id, _NeedGold]), Role}),
                                    {ok, NewRole}
                            end
                    end;
                _ ->
                    {false, ?L(<<"不能重复领取奖励">>)}
            end;
        _ ->
            {false, ?L(<<"当前没有消费活动">>)}
    end.

%% 消费活动时间
%% all = 消费包括商城、神秘商店、仙境寻宝、天官赐福、翅膀技能刷新、守护神通刷新、召唤妖灵、元神加速修炼、仙宠猎魔、仙园加速晶钻消耗
camp_gold_times() ->
    Now = util:unixtime(),
    L = case sys_env:get(srv_id) of
        "4399_mhfx_1" ->
            [
                {gold_acc_20130320, all, 300, util:datetime_to_seconds({{2013, 3, 20}, {0, 0, 1}}), util:datetime_to_seconds({{2013, 3, 24}, {23, 59, 59}})}
            ];
        _ ->
            [
                {gold_acc_20130320, all, 300, util:datetime_to_seconds({{2013, 3, 20}, {0, 0, 1}}), util:datetime_to_seconds({{2013, 3, 24}, {23, 59, 59}})}
            ]
    end,
    [{Label, Types, Num, StartTime, EndTime} || {Label, Types, Num, StartTime, EndTime} <- L, Now =< EndTime].

camp_gold_reward(gold_acc_20130320) -> [
        {1,  1000,  [{26045, 1, 2}, {33114, 1, 5}, {33118, 1, 5}, {23003, 1, 1}]}
        ,{2, 3000,  [{33141, 1, 1}, {33114, 1, 8}, {33118, 1, 10}, {23003, 1, 3}]}
        ,{3, 5000,  [{33085, 1, 1}, {32001, 1, 3}, {33101, 1, 5}, {33125, 1, 5}, {33151, 1, 5}, {33120, 1, 1}]}
        ,{4, 10000,  [{33085, 1, 3}, {32001, 1, 5}, {33101, 1, 15}, {33126, 1, 10}, {33151, 1, 10}, {33120, 1, 3}]}
        ,{5, 30000,  [{33085, 1, 10}, {32001, 1, 20}, {33101, 1, 30}, {33127, 1, 10}, {33151, 1, 20}, {33120, 1, 15}, {29282, 1, 1}]}
        ,{6, 50000,  [{33085, 1, 15}, {32001, 1, 30}, {33101, 1, 50}, {33128, 1, 10}, {33151, 1, 30}, {33120, 1, 30}, {29282, 1, 3}]}
        ,{7, 100000,  [{33085, 1, 30}, {32001, 1, 50}, {23019, 1, 30}, {33128, 1, 15}, {32701, 1, 30}, {33109, 1, 40}, {29282, 1, 5}]}
        ,{8, 200000,  [{33085, 1, 50}, {32001, 1, 60}, {23019, 1, 60}, {33128, 1, 30}, {32701, 1, 80}, {33109, 1, 60}, {29282, 1, 10}]}
    ];
camp_gold_reward(_Label) -> [].

%% 处理手工配置消耗活动奖励
reward_loss_gold(Type, Role, Gold) -> 
    %% -------------------------------------
    %% 按照总消耗x晶钻计算奖励
    %% L = [{pet_magic, [pet_magic], 500, util:datetime_to_seconds({{2012, 11, 26}, {0, 0, 1}}), util:datetime_to_seconds({{2012, 11, 29}, {23, 59, 59}})}], %% 宠物魔晶消费
    %% -------------------------------------
    %% 按照每消耗x晶钻计算奖励
    L = camp_gold_times(),
    %% L = [{gold_each_20120810, all, 500, util:datetime_to_seconds({{2012, 8, 9}, {23, 0, 1}}), util:datetime_to_seconds({{2012, 8, 12}, {23, 59, 59}})}],
    NewL = [{Label, Num, StartTime, EndTime} || {Label, Types, Num, StartTime, EndTime} <- L, (Types =:= all orelse lists:member(Type, Types) =:= true)],
    Now = util:unixtime(),
    reward_loss_gold(NewL, Now, Role, Gold).
reward_loss_gold([{Label = pet_magic, Num, StartTime, EndTime} | T], Now, Role = #role{pet = PetBag = #pet_bag{hunt = Hunt = #pet_hunt{acc_gold = GoldInfo}}}, Gold) when Now >= StartTime andalso Now < EndTime -> %% 魔晶消费 在活动期间内
    GoldAcc = case GoldInfo of
        {Label, G1} -> G1;
        _ -> 0
    end,
    NewGoldAcc1 = GoldAcc + Gold,
    NewGoldAcc = case NewGoldAcc1 >= Num of
        _ when Num =:= 0 -> %% 累计消耗
            do_mail_reward(Label, GoldAcc, NewGoldAcc1, Role),
            NewGoldAcc1;
        true when Num > 0 -> %% 每消耗X晶钻 
            N = NewGoldAcc1 div Num,
            do_mail_reward(Label, N, Num, Role),
            NewGoldAcc1 - Num * N;
        _ ->
            NewGoldAcc1
    end,
    NewRole = Role#role{pet = PetBag#pet_bag{hunt = Hunt#pet_hunt{acc_gold = {Label, NewGoldAcc}}}},
    reward_loss_gold(T, Now, NewRole, Gold);
reward_loss_gold([{Label, Num, StartTime, EndTime} | T], Now, Role = #role{campaign = Camp}, Gold) when Now >= StartTime andalso Now < EndTime -> %% 在活动期间内
    {Gold1, Gold2, RewardList} = case Camp of
        #campaign_role{loss_gold = {Label, G1, G2}, reward_list = ReList} -> {G1, G2, ReList};
        _ -> {0, 0, []}
    end,
    NewGold1 = Gold1 + Gold,
    NewGold = Gold2 + Gold,
    %% ?DEBUG("Label:~s, gold1:~p, gold2:~p, reward_list:~w", [Label, NewGold1, NewGold, RewardList]),
    NewGold2 = case NewGold >= Num of
        _ when Num =:= 0 -> %% 累计消耗
            do_mail_reward(Label, Gold1, NewGold1, Role),
            NewGold;
        true when Num > 0 -> %% 每消耗X晶钻 
            N = NewGold div Num,
            do_mail_reward(Label, N, Num, Role),
            NewGold - Num * N;
        _ ->
            NewGold
    end,
    sys_conn:pack_send(Role#role.link#link.conn_pid, 15806, {NewGold1}),
    NewRole = Role#role{campaign = Camp#campaign_role{loss_gold = {Label, NewGold1, NewGold2}, reward_list = RewardList}},
    reward_loss_gold(T, Now, NewRole, Gold); 
reward_loss_gold([_ | T], Now, NewRole, Gold) -> 
    reward_loss_gold(T, Now, NewRole, Gold);
reward_loss_gold(_, _Now, NewRole, _Gold) -> 
    NewRole.

%% --------------------------------------------------------------------
%% 程序手工配置的活动数据奖励处理
%% --------------------------------------------------------------------

%% 宠物平均潜力
handle(pet_potential_avg, Role, Val) ->
    %% 手动配置活动开放时间设置
    Now = util:unixtime(),
    StartTime = util:datetime_to_seconds({{2012, 10, 10}, {0, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2012, 10, 11}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true ->
            do_mail_reward(pet_potential_avg, {150, Val}, [{23003, 1, 8}], Role),
            do_mail_reward(pet_potential_avg, {175, Val}, [{23003, 1, 18}], Role),
            do_mail_reward(pet_potential_avg, {200, Val}, [{23003, 1, 20}], Role),
            do_mail_reward(pet_potential_avg, {220, Val}, [{23003, 1, 20}], Role),
            do_mail_reward(pet_potential_avg, {240, Val}, [{23003, 1, 25}], Role),
            do_mail_reward(pet_potential_avg, {260, Val}, [{23003, 1, 30}], Role),
            do_mail_reward(pet_potential_avg, {280, Val}, [{23003, 1, 50}], Role),
            do_mail_reward(pet_potential_avg, {300, Val}, [{22243, 1, 10}, {33101, 1, 50}, {33109, 1, 40}, {32001, 1, 40}], Role);
        _ -> skip 
    end;
%% 宠物成长
handle(pet_grow, Role, Val) ->
    %% 手动配置活动开放时间设置
    Now = util:unixtime(),
    StartTime = util:datetime_to_seconds({{2012, 10, 10}, {0, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2012, 10, 11}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true ->
            do_mail_reward(pet_grow, {40, Val}, [{33101, 1, 5}, {23002, 1, 5}, {23001, 1, 12}], Role),
            do_mail_reward(pet_grow, {60, Val}, [{33101, 1, 8}, {23002, 1, 10}, {23001, 1, 20}], Role),
            do_mail_reward(pet_grow, {80, Val}, [{33101, 1, 9}, {23003, 1, 5}, {23001, 1, 20}], Role),
            do_mail_reward(pet_grow, {100, Val}, [{33101, 1, 10}, {23003, 1, 10}, {23001, 1, 20}], Role),
            do_mail_reward(pet_grow, {150, Val}, [{33101, 1, 20}, {33085, 1, 10}, {23001, 1, 40}], Role),
            do_mail_reward(pet_grow, {200, Val}, [{33101, 1, 20}, {33085, 1, 15}, {23001, 1, 50}], Role),
            do_mail_reward(pet_grow, {250, Val}, [{33101, 1, 20}, {33085, 1, 20}, {23001, 1, 60}], Role),
            do_mail_reward(pet_grow, {300, Val}, [{33101, 1, 20}, {33085, 1, 25}, {23001, 1, 70}], Role),
            do_mail_reward(pet_grow, {350, Val}, [{33101, 1, 20}, {33085, 1, 30}, {23001, 1, 80}], Role);
        _ -> skip 
    end;
%% 翅膀提升活动奖励
handle(wing_step, Role, Step) ->
    %% 手动配置活动开放时间设置
    Now = util:unixtime(),
    StartTime = util:datetime_to_seconds({{2012, 9, 28}, {0, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2012, 9, 30}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true ->
            do_mail_reward(wing_step, {5, Step}, [{32203, 1, 5}, {33101, 1, 5}, {33085, 1, 2}], Role),
            do_mail_reward(wing_step, {6, Step}, [{32203, 1, 10}, {33101, 1, 10}, {33085, 1, 4}], Role),
            do_mail_reward(wing_step, {7, Step}, [{32203, 1, 15}, {33101, 1, 15}, {33085, 1, 8}], Role),
            do_mail_reward(wing_step, {8, Step}, [{32203, 1, 20}, {33101, 1, 20}, {33085, 1, 12}], Role),
            do_mail_reward(wing_step, {9, Step}, [{32203, 1, 30}, {33101, 1, 30}, {33085, 1, 20}], Role),
            do_mail_reward(wing_step, {10, Step}, [{32203, 1, 50}, {33101, 1, 50}, {33085, 1, 30}], Role),
            do_mail_reward(wing_step, {11, Step}, [{32301, 1, 80}, {33101, 1, 70}, {33085, 1, 50}], Role);
        _ -> skip 
    end;
handle(kill_npc, Role, NpcBaseId) ->
    %% 手动配置活动开放时间设置
    Now = util:unixtime(),
    StartTime = util:datetime_to_seconds({{2012, 9, 19}, {0, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2012, 9, 22}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true ->
            case NpcBaseId of
                24203 ->
                    case campaign_adm_reward:check_reward(?CAMP_TOTAL, ?CAMP, ?KILL_NPC_24203, Role) of
                        false -> false;
                        true ->
                            campaign_dao:add_camp_log(?CAMP_TOTAL, ?CAMP, ?KILL_NPC_24203, Role),
                            campaign_adm:apply(async, {rewarded, Role#role.id, ?KILL_NPC_24203}),
                            do_mail_reward(kill_npc, NpcBaseId, [], Role)
                    end;
                24205 ->
                    case campaign_adm_reward:check_reward(?CAMP_TOTAL, ?CAMP, ?KILL_NPC_24205, Role) of
                        false -> false;
                        true ->
                            campaign_dao:add_camp_log(?CAMP_TOTAL, ?CAMP, ?KILL_NPC_24205, Role),
                            campaign_adm:apply(async, {rewarded, Role#role.id, ?KILL_NPC_24205}),
                            do_mail_reward(kill_npc, NpcBaseId, [], Role)
                    end;
                _ -> skip
            end;
        _ -> skip 
    end;
%% 在线时长奖励
handle(online_time, Role = #role{campaign = #campaign_role{day_online = {_, AccTime}}}, _Args) ->
    Now = util:unixtime(),
    StartTime = util:datetime_to_seconds({{2013, 3, 29}, {0, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2013, 4, 2}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true when AccTime >= 1800 ->
            Fun = fun({Cond, NeedTime, Items}) when AccTime >= NeedTime ->
                    case campaign_adm_reward:check_reward(?CAMP_TOTAL, ?CAMP, Cond, Role) of
                        false -> false;
                        true ->
                            campaign_dao:add_camp_log(?CAMP_TOTAL, ?CAMP, Cond, Role),
                            campaign_adm:apply(async, {rewarded, Role#role.id, Cond}),
                            do_mail_reward(online_time, {AccTime, NeedTime}, Items, Role)
                    end;
                (_) ->
                        skip
            end,
            L = [{?LOGIN_30, 1800, [{33116, 1, 1}]}],
            lists:foreach(Fun, L);
        _ -> 
            skip
    end;

%% 活动期间首先登陆
handle(login_camp_all, Role = #role{sex = Sex, vip = #vip{type = _Type}}, _) -> %% 至尊vip卡 魅力女生
    Now = util:unixtime(),
    StartTime = util:datetime_to_seconds({{2013, 5, 12}, {0, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2013, 5, 12}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true ->
           %%  case Type =:= ?vip_half_year of
           %%      true ->
           %%          case campaign_adm_reward:check_reward(?CAMP_TOTAL, ?CAMP, ?LOGIN_ALL, Role) of
           %%              false -> false;
           %%              true ->
           %%                  campaign_dao:add_camp_log(?CAMP_TOTAL, ?CAMP, ?LOGIN_ALL, Role),
           %%                  campaign_adm:apply(async, {rewarded, Role#role.id, ?LOGIN_ALL}),
           %%                  do_mail_reward(login_camp_all, ?LOGIN_ALL, [], Role)
           %%          end;
           %%      false -> skip
           %%  end,
            case Sex =:= 0 of
                true ->
                    case campaign_adm_reward:check_reward(?CAMP_TOTAL, ?CAMP, ?LOGIN_First, Role) of
                        false -> false;
                        true ->
                            campaign_dao:add_camp_log(?CAMP_TOTAL, ?CAMP, ?LOGIN_First, Role),
                            campaign_adm:apply(async, {rewarded, Role#role.id, ?LOGIN_First}),
                            do_mail_reward(login_camp_sex_first, ?LOGIN_First, [], Role)
                    end;
                false -> skip
            end;
        _ -> 
            skip
    end;
handle(login_camp_all, _Role, _) -> skip;
%% 其他参加活动奖励--手工配置
handle(doing, Role, DoingFunc) ->
    Now = util:unixtime(),
    StartTime = util:datetime_to_seconds({{2012, 9, 5}, {0, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2012, 9, 7}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true ->
            case DoingFunc of
                cross_guild_arena ->
                    do_mail_reward(doing, {?L(<<"跨服帮战，战个痛快">>), ?L(<<"跨服帮战">>)}, [{29249, 1, 1}], Role);
                cross_king ->
                    do_mail_reward(doing, {?L(<<"至尊王者，荣耀加冕">>), ?L(<<"至尊王者赛">>)}, [{29250, 1, 1}], Role);
                _ -> skip
            end;
        _ -> skip
    end;
%% 活跃度奖励
handle(activity2, Role, Num) ->
    Now = util:unixtime(),
    StartTime = util:datetime_to_seconds({{2012, 9, 9}, {0, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2012, 9, 10}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true ->
            if
                Num =:= 100 ->
                    case campaign_adm:check_can_reward(Role#role.id, ?ACTIVITY100) of
                        false -> false;
                        true ->
                            Cond = ?ACTIVITY100,
                            campaign_adm:apply(async, {rewarded, Role#role.id, Cond}),
                            do_mail_reward(activity2, 100, [{33116, 1, 1}], Role)
                    end;
                Num >= 70 -> %% TODO: 应该只会触发一次
                    case campaign_adm:check_can_reward(Role#role.id, ?ACTIVITY70) of
                        false -> false;
                        true ->
                            Cond = ?ACTIVITY70,
                            campaign_adm:apply(async, {rewarded, Role#role.id, Cond}),
                            do_mail_reward(activity2, 70, [{33116, 1, 1}], Role)
                    end;
                true -> skip
            end;
        false -> skip
    end;
%% 每天第一次送花奖励
handle(flower_first, Role = #role{id = {Rid, SrvId}}, Num) ->
    Now = util:unixtime(),
    StartTime = util:datetime_to_seconds({{2013, 3, 12}, {0, 0, 1}}),
    EndTime = util:datetime_to_seconds({{2013, 3, 15}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true ->
            case campaign_adm:check_can_reward({Rid, SrvId}, ?FLOWER) of
                false -> false;
                true ->
                    do_mail_reward(flower_first, ?FLOWER, Num, Role)
            end;
        _ -> skip
    end;
%% 其他容错
handle(_Label, _Role, _Args) -> ok.


%%-------------------------------------------
%% 实现信件奖励发放
%%-------------------------------------------

do_mail_reward(Label, Arg1, Arg2, {{Rid, SrvId}, Name}) -> 
    do_mail_reward(Label, Arg1, Arg2, {Rid, SrvId, Name});
%% 在线时长发放奖励格式
do_mail_reward(online_time, {_AccTime, NeedTime}, Items, Role) -> 
    Subject = ?L(<<"辛勤耕耘，铸就富翁">>),
    Content = util:fbin(?L(<<"亲爱的玩家，周年庆活动期间，您今日登陆满~p分钟，获得了幸运骰子*1。此道具可在秘境大富翁面板抽取奖励哦，请注意查收！谢谢您的支持，祝您游戏愉快！">>), [NeedTime div 60]),
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 击杀NPC奖励
do_mail_reward(kill_npc, 24203, _, Role) -> 
    Subject = ?L(<<"精灵守护，闪耀登场">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。清秋活动期间，您成功击杀精灵幻境3层BOSS，获得了守护之魂一个！ 请注意查收，祝您游戏愉快！">>),
    Items = case util:rand(1, 5) of
        1 -> [{27500, 1, 1}];
        2 -> [{27501, 1, 1}];
        3 -> [{27502, 1, 1}];
        4 -> [{27503, 1, 1}];
        _ -> [{27504, 1, 1}]
    end,
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do_mail_reward(kill_npc, 24205, _, Role) -> 
    Subject = ?L(<<"精灵守护，闪耀登场">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。清秋活动期间，您成功击杀精灵幻境5层BOSS，获得了守护水晶3个！ 请注意查收，祝您游戏愉快！">>),
    Items = [{27505, 1, 3}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 每消耗X晶钻信件发放格式
do_mail_reward(Label = gold_acc_20130227, N, Num, Role) when is_integer(N) andalso N > 0 ->  
     Subject = ?L(<<"春暖花开，消费有礼">>),
     Content = util:fbin(?L(<<"\t亲爱的玩家，春暖花开活动期间，您消费了~w晶钻，获得了以下超值奖励，请注意查收！感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您和家人元宵佳节阖家欢乐、健康团圆！">>), [Num]),
     Items = [{29516, 1, 1}],
     mail_mgr:deliver(Role, {Subject, Content, [], Items}),
     do_mail_reward(Label, N -1, Num, Role);


do_mail_reward(Label = pet_magic, N, Num, Role) when is_integer(N) andalso N > 0 ->  
Subject = ?L(<<"魔晶当道，神宠称雄">>),
    Content = util:fbin("\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。清秋活动期间，您在【猎魔】中消耗了~p晶钻，获得了下列额外超值大礼哦！\n\t请注意查收，祝您游戏愉快！", [Num]),
    Items = [{33085, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items}),
    do_mail_reward(Label, N -1, Num, Role);

%% 总消耗X晶钻信件格式
do_mail_reward(gold_acc_mail, AccGold, Items, Role)  -> %% 活动结束后玩家未领取 首次登录以信件发放
    Subject = ?L(<<"消费大礼，金币诱惑">>),
    Content = util:fbin(?L(<<"\t亲爱的玩家，飞仙周年庆活动期间，您在【商城】、【仙境寻宝】、【神秘商店】中消耗了~p晶钻，获得了下列额外超值大礼哦！\n\t请注意查收！感谢您在过去的一年中对梦幻飞仙的鼎力支持，一路有你，精彩无限，您的支持将会是我们的无限动力，祝您游戏愉快！">>), [AccGold]),
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do_mail_reward(gold_acc_20120905, OldGold, NewGold, Role) when OldGold < 1000 andalso NewGold >= 1000  -> 
    Subject = ?L(<<"消费有礼，倾情回馈">>),
    Content = ?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。九月清凉活动期间，您在【商城】、【仙境寻宝】、【神秘商店】和【天官赐福】中消耗了1000晶钻，获得了下列额外超值大礼哦！\n\t请注意查收，祝您游戏愉快！">>),
    Items = [{33108, 1, 1}, {32203, 1, 1}, {33109, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do_mail_reward(gold_acc_20120905, OldGold, NewGold, Role) when OldGold < 3000 andalso NewGold >= 3000  -> 
    Subject = ?L(<<"消费有礼，倾情回馈">>),
    Content = ?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。九月清凉活动期间，您在【商城】、【仙境寻宝】、【神秘商店】和【天官赐福】中消耗了3000晶钻，获得了下列额外超值大礼哦！\n\t请注意查收，祝您游戏愉快！">>),
    Items = [{33108, 1, 3}, {32203, 1, 3}, {33109, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do_mail_reward(gold_acc_20120905, OldGold, NewGold, Role) when OldGold < 5000 andalso NewGold >= 5000  -> 
    Subject = ?L(<<"消费有礼，倾情回馈">>),
    Content = ?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。九月清凉活动期间，您在【商城】、【仙境寻宝】、【神秘商店】和【天官赐福】中消耗了5000晶钻，获得了下列额外超值大礼哦！\n\t请注意查收，祝您游戏愉快！">>),
    Items = [{33108, 1, 5}, {32203, 1, 5}, {33109, 1, 2}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do_mail_reward(gold_acc_20120905, OldGold, NewGold, Role) when OldGold < 10000 andalso NewGold >= 10000  -> 
    Subject = ?L(<<"消费有礼，倾情回馈">>),
    Content = ?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。九月清凉活动期间，您在【商城】、【仙境寻宝】、【神秘商店】和【天官赐福】中消耗了10000晶钻，获得了下列额外超值大礼哦！\n\t请注意查收，祝您游戏愉快！">>),
    Items = [{33108, 1, 10}, {32203, 1, 10}, {33109, 1, 4}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do_mail_reward(gold_acc_20120905, OldGold, NewGold, Role) when OldGold < 20000 andalso NewGold >= 20000  -> 
    Subject = ?L(<<"消费有礼，倾情回馈">>),
    Content = ?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。九月清凉活动期间，您在【商城】、【仙境寻宝】、【神秘商店】和【天官赐福】中消耗了20000晶钻，获得了下列额外超值大礼哦！\n\t请注意查收，祝您游戏愉快！">>),
    Items = [{33108, 1, 15}, {32203, 1, 15}, {33109, 1, 10}, {23020, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do_mail_reward(gold_acc_20120905, OldGold, NewGold, Role) when OldGold < 30000 andalso NewGold >= 30000  -> 
    Subject = ?L(<<"消费有礼，倾情回馈">>),
    Content = ?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。九月清凉活动期间，您在【商城】、【仙境寻宝】、【神秘商店】和【天官赐福】中消耗了30000晶钻，获得了下列额外超值大礼哦！\n\t请注意查收，祝您游戏愉快！">>),
    Items = [{33108, 1, 20}, {32203, 1, 20}, {33109, 1, 10}, {23020, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do_mail_reward(gold_acc_20120905, OldGold, NewGold, Role) when OldGold < 50000 andalso NewGold >= 50000  -> 
    Subject = ?L(<<"消费有礼，倾情回馈">>),
    Content = ?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。九月清凉活动期间，您在【商城】、【仙境寻宝】、【神秘商店】和【天官赐福】中消耗了50000晶钻，获得了下列额外超值大礼哦！\n\t请注意查收，祝您游戏愉快！">>),
    Items = [{33108, 1, 30}, {32203, 1, 30}, {33109, 1, 20}, {23020, 1, 4}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 宠物潜力
do_mail_reward(pet_potential_avg, {Val, Val}, Items, Role) ->
    Subject = ?L(<<"天赋秉义，提升潜力">>),
    Content = util:fbin(?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。金秋活动期间，您成功将宠物潜力提升至~p，获得了下列超值大礼哦！">>), [Val]),
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 宠物成长
do_mail_reward(pet_grow, {Val, Val}, Items, Role) ->
    Subject = ?L(<<"成长提升，我来加速">>),
    Content = util:fbin(?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。金秋活动期间，您成功将宠物成长提升至~p，获得了下列超值大礼哦！">>), [Val]),
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 翅膀升阶
do_mail_reward(wing_step, {Step, Step}, Items, Role) ->
    Subject = ?L(<<"欢庆中秋之翅膀进阶">>),
    Content = util:fbin(?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。中秋活动期间，您的翅膀阶数达到~p阶，获得了下列额外超值大礼哦！\n\t请注意查收，祝您游戏愉快！">>), [Step]),
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
%% 参加功能活动奖励
do_mail_reward(doing, {DoingSubject, Doing}, Items, Role) ->
    Content = util:fbin(?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。九月清凉活动期间，您参加~s，获得了下列额外赠送大礼哦！\n\t请注意查收，祝您游戏愉快！">>), [Doing]),
    mail_mgr:deliver(Role, {DoingSubject, Content, [], Items});
%% 活跃度达到奖励
do_mail_reward(activity2, Num, Items, Role) ->
    Subject = ?L(<<"九月清凉，幸运摇骰">>),
    Content = util:fbin(?L(<<"\t亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。九月清凉活动期间，您的活跃度达到~w，获得了下列额外赠送大礼哦！\n\t请注意查收，祝您游戏愉快！">>), [Num]),
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 每天第一次送花奖励
do_mail_reward(flower_first, Cond, _Num, Role) ->
    Subject = ?L(<<"赠人鲜花，手留余香">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。活动期间，您赠送鲜花，获得了以下额外奖励，请留意查收！祝您游戏愉快！">>),
    Items = [{33111, 1, 1}],
    campaign_adm:apply(async, {rewarded, Role#role.id, Cond}),
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 活动期间首次登陆
do_mail_reward(login_camp_all, _, _, Role) ->
    Subject = ?L(<<"至尊VIP，专属大礼">>),
    Content = ?L(<<"亲爱的至尊VIP玩家，飞仙周年庆活动期间，您首次登陆游戏，获得了【至尊VIP礼包】，请注意查收！感谢您在过去的一年中对梦幻飞仙的鼎力支持，一路有你，精彩无限，您的支持将会是我们的无限动力，祝您游戏愉快！">>),
    Items = [{29531, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 活动期间女性首次登陆赠物品
do_mail_reward(login_camp_sex_first, _, _, Role = #role{lev = Lev}) when Lev >= 40 ->
    Subject = ?L(<<"感念亲恩，奖励满满">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持，母亲节活动期间您今日首次登陆，获得了额外大礼奖励，请注意查收！更多活动精彩内容请继续关注“感念亲恩”图标，谢谢您的支持，祝您游戏愉快！">>),
    Now = util:unixtime(),
    S7 = util:datetime_to_seconds({{2013, 5, 12}, {0, 0, 0}}),
    E7 = util:datetime_to_seconds({{2013, 5, 12}, {23, 59, 59}}),
    case    Now >= S7 andalso Now =< E7  of
        true ->
            Items = [{33270, 1, 1}],
            mail_mgr:deliver(Role, {Subject, Content, [], Items});
        false ->
            ignor
    end;
do_mail_reward(login_camp_sex_first, _, _, _Role) -> ok;

%% 容错
do_mail_reward(_Label, _Arg1, _Arg2, _Role) -> ok.


%% gm命令设置春节登录天数
adm_set_spring_days(_Role, Day) when Day < 0 orelse Day > 29 ->
    {false, ?L(<<"请输入一个0到29之间的数字">>)};
adm_set_spring_days(Role = #role{campaign = Camp = #campaign_role{spring_festive = Spring}}, Day) ->
    EndDay = max(0, min(29, Day)),
    Days = [{{2013, 2, D}, 2} || D <- lists:seq(1, EndDay)],
    NewRole = Role#role{campaign = Camp#campaign_role{spring_festive = Spring#campaign_spring_festive{online_days = Days, all_online_reward = 0}}},
    push_spring_campaign(online_days, NewRole),
    {ok, NewRole}.
