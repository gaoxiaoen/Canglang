%%----------------------------------------------------
%% 角色后台活动相关事件监听
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(campaign_listener).
-export([
        handle/3
        ,handle/4
        ,handle_async/4
        ,loss_gold/5
        ,login/1
        ,recalc_online_time/1
        ,calc_online_time/1
    ]
).
-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").
-include("mail.hrl").
-include("vip.hrl").
-include("assets.hrl").
-include("arena.hrl").
-include("boss.hrl").
-include("guild_war.hrl").
-include("guild_arena.hrl").
-include("guard.hrl").
-include("guild_td.hrl").
-include("link.hrl").
-include("combat.hrl").
-include("practice.hrl").

%% @spec handle(Label, Role, Args) -> NewRole.
%% @doc 玩家事件监听
%% handle(pay, Role, Gold)           玩家充值监听 (已注册)
%% handle(power, Role, 1)            玩家角色战斗力变化 (已注册)
%% handle(eqm, Role, 1)              装备变化 (已注册)
%% handle(eqm_enchant, Role, Val)    装备强化 (已注册)
%% handle(skill, Role, 1)            技能发生变化 (已注册)
%% handle(pet, Role, Pet)            宠物变化 (已注册)
%% handle(pet_skill_lev, Role, Pet)  宠物技能变化 (已注册)
%% handle(channel_lev, Role, Lev)    元神等级变化 (已注册)
%% handle(channel_step, Role, Step)  元神境界变化 (已注册)
%% handle(kill_npc, Role, NpcBaseId) 斩杀NPC
%% handle(stone_quech, Role, Lev)    宝石淬炼
%% handle(stone_smelt, Role, Lev)    宝石熔炼
%% handle(wing_step, Role, Step)     翅膀进阶
%% handle(mount_step, Role, Step)    坐骑变化 (已注册)
%% handle(activity, Role, Val)       活跃度
%% handle(flower, Role, Num)         送花X朵
%% handle(practice, Role, Wave)      无限试练到X波
%% handle(sworn, Role, Type)         角色结拜
%% handle(eqm_make, Role, {Quality, Lev}) 装备生产
%% handle(pet_magic_lev, Role, {Color, Val})  魔晶等级
%% handle(world_compete, Role, {Type, Wins}) 仙道会
%% handle(escort, Role, {Type, Color})        护送

%% handle(guild_td_score, #role_td{}, Score)                                帮会降妖积分
%% handle(guard_rank, [#role_guard{}...], 1)                                洛水攻城排行
%% handle(guild_arena_rank, [#guild_arena_role{}...], 1)                    帮会战排行
%% handle(guild_war_rank, [#guild_war_role{}...], 1)                        阵营战排行
%% handle(arena_rank, [#arena_hero_zone{}...], 1)                            竞技场各组排行
%% handle(god_lev, Role, Lev)      神佑升级
%% handle(task, Role, Task)    %% 提交任务
%% handle(wing_skill, Role, Step) %% 翅膀技能阶数
%% handle(king, Role, 1)          %% 参与至尊王者
%% handle(king_kills, Role, Val)  %% 至尊王者连斩
%% handle(demon_skill_step, Role, Step) %% 守护神通等级
%% handle(condense, Role, EqmLev)       %% 装备凝炼
%% handle(talisman_lev, Role, StepLev)  %% 灵器进阶等级
%% handle(hole_lev, Role, HoleLev)      %% 灵器聚灵等级
%% handle(spring_festive_loss_gold, Role, Gold)   %% 春节期间每天消耗晶钻
handle(spring_festive_loss_gold, Role = #role{campaign = Camp = #campaign_role{spring_festive = Spring = #campaign_spring_festive{day_loss_gold = LossGold, last_loss_gold = LastLost}}}, Gold) -> 
    Now = util:unixtime(),
    {StartTime, EndTime} = campaign_adm_data:spring_festive_time(),
    case Now >= StartTime andalso EndTime >= Now of
        true ->
            NewCamp = case util:is_same_day2(Now, LastLost) of
                true ->
                    Camp#campaign_role{spring_festive = Spring#campaign_spring_festive{day_loss_gold = Gold + LossGold, last_loss_gold = Now}};
                _ ->
                    Camp#campaign_role{spring_festive = Spring#campaign_spring_festive{day_loss_gold = Gold, last_loss_gold = Now}}
            end,
            NR = Role#role{campaign = NewCamp},
            campaign_reward:spring_festive_reward(loss_gold, NR, Now);
        _ ->
            Role
    end;
handle(Label, Role, Args) when is_record(Role, role) -> 
    Now = util:unixtime(),
    TotalCampL = campaign_adm:list_all(Now),
    case catch do_total_camp(TotalCampL, Now, Label, Role, Args) of
        {ok, NRole} when is_record(NRole, role) -> 
            catch do_handle_finish(Label, Role, TotalCampL, Args),
            NRole;
        _Reason ->
            ?ERR("[~s]后台活动事件处理异常:~w [label:~w, args:~w]", [Role#role.name, _Reason, Label, {Args}]),
            Role 
    end;
handle(Label, RInfo, Args) ->
    campaign_adm:apply(async, {handle, Label, RInfo, Args}),
    RInfo.

%% 特殊事件
%% handle(mount_lev, Role, OldLev, NewLev)              坐骑等级变化 (已注册)
%% handle(pet_potential_avg, Role, OldVal, NewVal)      宠物变化 (已注册)
%% handle(pet_grow, Role, OldVal, NewVal)               宠物成长变化 (已注册)
%% handle(soul_world_magic_lev, Role, OldLev, NewLev)   灵戒洞天法宝升级
%% handle(soul_world_spirit_lev, Role, OldLev, NewLev)  灵戒洞天妖灵等级
%% handle(demon_shape_lev, Role, OldLev, NewLev)        守护化形等级
%% handle(demon_lev, Role, OldLev, NewLev)              守护等级
handle({Label, Args}, Role, Val1, Val2) when Val2 > Val1 ->
    campaign_reward:handle(Label, Role, Val1 + 1),
    NRole = handle(Label, Role, {Args, Val1 + 1}),
    handle({Label, Args}, NRole, Val1 + 1, Val2);
handle(Label, Role, Val1, Val2) when Val2 > Val1 ->
    campaign_reward:handle(Label, Role, Val1 + 1),
    NRole = handle(Label, Role, Val1 + 1),
    handle(Label, NRole, Val1 + 1, Val2);
handle(_Label, Role, _Val1, _Val2) -> Role.

%% 异步处理监听事件
handle_async(_N, Label, Role, Args) when is_record(Role, role) ->
    handle(Label, Role, Args);
handle_async(_N, Label, {Rid, Srvid}, Args) -> 
    case role_api:lookup(by_id, {Rid, Srvid}) of
        {ok, _, Role} ->
            handle(Label, Role, Args);
        _ -> %% 查找数据库
            case role_data:fetch_base(by_id, {Rid, Srvid}) of
                {ok, Role} -> 
                    handle(Label, Role, Args);
                {false, _Err} -> 
                    ?ERR("角色数据不存在[~p][~s]", [Rid, Srvid]),
                    ok
            end
    end;
handle_async(_N, Label, {Rid, Srvid, Name, Lev, Career, Sex}, Args) -> %% 元组
    handle(Label, #role{id = {Rid, Srvid}, name = Name, lev = Lev, career = Career, sex = Sex}, Args);
handle_async(_N, Label, #fighter{rid = Rid, srv_id = Srvid, name = Name, lev = Lev, career = Career, sex = Sex}, Args) -> %% 击杀NPC
    handle(Label, #role{id = {Rid, Srvid}, name = Name, lev = Lev, career = Career, sex = Sex}, Args);
handle_async(_N, Label, #practice_role{id = {Rid, Srvid}, name = Name, lev = Lev, career = Career, sex = Sex}, Args) -> %% 无限试练角色
    handle(Label, #role{id = {Rid, Srvid}, name = Name, lev = Lev, career = Career, sex = Sex}, Args);
handle_async(_N, Label, #arena_hero{role_id = Rid, srv_id = Srvid, name = Name, career = Career, lev = Lev}, Args) -> %% 竞技分组排行榜
    handle(Label, #role{id = {Rid, Srvid}, name = Name, career = Career, lev = Lev}, Args);
handle_async(_N, Label, #arena_role{role_id = {Rid, Srvid}, name = Name, career = Career, lev = Lev}, Args) -> %% 竞技分组排行榜
    handle(Label, #role{id = {Rid, Srvid}, name = Name, career = Career, lev = Lev}, Args);
handle_async(_N, Label, #guild_war_role{id = {Rid, Srvid}, name = Name, lev = Lev}, Args) -> %% 阵营战排行榜
    handle(Label, #role{id = {Rid, Srvid}, name = Name, lev = Lev}, Args);
handle_async(_N, Label, #guild_arena_role{id = {Rid, Srvid}, name = Name, lev = Lev}, Args) -> %% 帮会战排行榜
    handle(Label, #role{id = {Rid, Srvid}, name = Name, lev = Lev}, Args);
handle_async(_N, Label, #role_guard{rid = Rid, srv_id = Srvid, name = Name, career = Career, lev = Lev, sex = Sex}, Args) -> %% 洛水攻城排行榜
    handle(Label, #role{id = {Rid, Srvid}, name = Name, career = Career, lev = Lev, sex = Sex}, Args);
handle_async(_N, Label, #role_td{id = {Rid, Srvid}, name = Name, lev = Lev}, Args) -> %% 帮会降妖积分
    handle(Label, #role{id = {Rid, Srvid}, name = Name, lev = Lev}, Args);
handle_async(N, Label, [#arena_hero_zone{hero_list = HList} | T], Args) -> %% 竞技场排行榜
    handle_async(1, Label, HList, Args),
    handle_async(N, Label, T, Args);
handle_async(N, Label, [I | T], Args) ->
    handle_async(N, Label, I, N),
    handle_async(N + 1, Label, T, Args);
handle_async(_N, _Label, [], _Args) -> 
    ok;
handle_async(_N, _Label, _R, _Args) ->
    ?ERR("非法角色信息[~w]", [_R]),
    error.

%%玩家登录
login(Role = #role{campaign = Campaign = #campaign_role{day_online = {T, AccTime}, keep_days = {Days, UpdateTime}, spring_festive = Spring = #campaign_spring_festive{last_loss_gold = LastLost}}}) ->
    %% handle(online, Role, login),
    Now = util:unixtime(),
    NewAccTime =case util:is_same_day2(Now, T) of
        true -> AccTime;
        false -> 0
    end,
    KeepDays = case util:day_diff(Now, UpdateTime) of
        0 -> {Days, UpdateTime};  %% 同一天 不处理
        1 -> {Days + 1, Now};     %% 昨天 连续天数+1
        _ -> {1, Now}             %% 其它，重新计算
    end,
    NewSpring = case util:is_same_day2(Now, LastLost) of
        true -> Spring;
        _ -> Spring#campaign_spring_festive{day_loss_gold = 0, day_loss_reward = 0, last_loss_gold = 0}
    end,
    NRole = add_online_timer(Role#role{campaign = Campaign#campaign_role{day_online = {Now, NewAccTime}, keep_days = KeepDays, spring_festive = NewSpring}}),
    role:apply(async, Role#role.pid, {fun async_login/1, []}),
    NRole;
login(Role) -> Role.
async_login(Role) ->
    campaign_adm:apply(async, {handle, online, Role, login}),
    campaign_reward:handle(login_camp_all, Role, 1),
    {ok}.

%% 增加定时结算在线时间功能
add_online_timer(Role) ->
    NRole = case role_timer:del_timer(recalc_online_time, Role) of
        {ok, _, NR} -> NR;
        false -> Role
    end,
    role_timer:set_timer(recalc_online_time, 180*1000, {campaign_listener, recalc_online_time, []}, 0, NRole).

%% 重新计算角色当天在线时间
recalc_online_time(Role= #role{campaign = Campaign = #campaign_role{day_online = {OldT, OldAccTime}}}) ->
    ?DEBUG("定时计算角色当天在线时长"),
    NewCampaign = #campaign_role{day_online = {NewT, NewAccTime}} = calc_online_time(Campaign),
    NewRole = campaign_special:online(Role#role{campaign = NewCampaign}),
    case util:is_same_day2(OldT, NewT) of
        true when OldAccTime < ?spring_festive_sign_time_need andalso NewAccTime >= ?spring_festive_sign_time_need ->
            campaign_reward:push_spring_campaign(online_days, NewRole);
        _ ->
            ok
    end,
    campaign_reward:handle(online_time, NewRole, NewCampaign),
    campaign_adm:apply(async, {handle, online_time, NewRole, online}),
    {ok, NewRole}.

%% 重新计算玩家在线时间
calc_online_time(Campaign = #campaign_role{day_online = {T, AccTime}, spring_festive = Spring = #campaign_spring_festive{online_days = Days}}) ->
    Now = util:unixtime(),
    NewAccTime =case util:is_same_day2(Now, T) of
        true -> AccTime + (Now - T);
        false -> 0
    end,
    %% 春节活动处理
    {StartTime, EndTime} = campaign_adm_data:spring_festive_time(),
    NewSpring = case Now >= StartTime andalso EndTime >= Now of
        true when NewAccTime >= ?spring_festive_sign_time_need ->
            Today = erlang:date(),
            NewDays = case lists:keyfind(Today, 1, Days) of
                false ->
                    [{Today, 1} | Days];
                _ ->
                    Days
            end,
            Spring#campaign_spring_festive{online_days = NewDays};
        _ ->
            Spring
    end,
    Campaign#campaign_role{day_online = {Now, NewAccTime}, spring_festive = NewSpring};
calc_online_time(Campaign) -> Campaign.

%% 晶钻变化处理 必须保证返回值是 #role{}
loss_gold(#role{assets = #assets{gold = OldGold}}, NewRole = #role{assets = #assets{gold = NewGold}}, Mod, Cmd, Data) when OldGold > NewGold -> %% 确定存在晶钻消费才处理
    case campaign_gold_cfg:check(Mod, Cmd, Data) of 
        false -> NewRole;  %% 过滤市场等消费
        Label ->
            case catch do_loss_gold(Label, NewRole, OldGold - NewGold) of
                NRole when is_record(NRole, role) -> NRole; %% 确保返回是 #role{} 结构
                _Err -> 
                    ?ERR("处理消费事件异常:~w", [_Err]),
                    NewRole
            end
    end;
loss_gold(_OldRole, NewRole, _Mod, _Cmd, _Data) ->
    NewRole.

%% 仙境寻宝/神秘商店/商城 消耗事件
%% do_loss_gold(casino, OldRole, NewRole) -> NewRole1;
%% do_loss_gold(npc_store_sm, OldRole, NewRole) -> NewRole1;
%% do_loss_gold(shop, OldRole, NewRole) -> NewRole1;
%% do_loss_gold(pet_magic, OldRole, NewRole) -> NewRole
do_loss_gold(Label, Role, Gold) when Gold > 0 -> 
    campaign_task:listener(Role, Label, Gold),
    NRole0 = handle(Label, Role, Gold),
    NRole1 = handle(loss_gold_all, NRole0, Gold),
    NRole2 = handle(spring_festive_loss_gold, NRole1, Gold),
    NRole3 = campaign_daily_consume:listener(NRole2, Label, Gold),
    NRole4 = campaign_repay_consume:listener(NRole3, Label, Gold),
    campaign_reward:reward_loss_gold(Label, NRole4, Gold);
do_loss_gold(_Label, Role, _Gold) -> 
    Role.

%% 历遍处理所有总活动
do_total_camp([TotalCamp = #campaign_total{camp_list = CampList} | T], Now, Label, Role, Args) ->
    NewRole = do_camp(CampList, TotalCamp, Now, Label, Role, Args),
    do_total_camp(T, Now, Label, NewRole, Args);
do_total_camp(_L, _Now, _Label, Role, _Args) -> 
    {ok, Role}.

%% 历遍处理各活动
do_camp([], _TotalCamp, _Now, _Label, Role, _Args) -> Role;
do_camp([Camp = #campaign_adm{start_time = StartTime, end_time = EndTime, conds = Conds} | T], TotalCamp, Now, Label, Role, Args) when Now >= StartTime andalso (Now < EndTime orelse EndTime =:= 0) ->
    NewConds = [Cond || Cond <- Conds, check_cond(type, Camp, Cond, 1), check_cond(label, Camp, Cond, Label), check_cond(lev, Camp, Cond, Role), check_cond(first_charge, Camp, Cond, Role)],
    NewRole = do_camp_cond(NewConds, Camp, TotalCamp, Role, Args),
    do_camp(T, TotalCamp, Now, Label, NewRole, Args);
do_camp([_ | T], TotalCamp, Now, Label, Role, Args) ->
    do_camp(T, TotalCamp, Now, Label, Role, Args).
   
%% 历遍处理活动中的规则 规则符合则直接发放邮件奖励
do_camp_cond([], _Camp, _TotalCamp, Role, _Args) -> 
    Role;
do_camp_cond([Cond | T], Camp, TotalCamp, Role, Args) -> %% 确保每个规则独立 相互无影响
    NewRole = do_camp_cond(Cond, Camp, TotalCamp, Role, Args),
    do_camp_cond(T, Camp, TotalCamp, NewRole, Args);
do_camp_cond(Cond = #campaign_cond{sec_type = SecType, conds = Conds}, Camp, TotalCamp, Role, Args) ->
    %% ?DEBUG("------------------[~w]", [Role#role.campaign]),
    NRole = calc_loss_gold(Cond, Role, Args),
    %% ?DEBUG("------------------[~w]", [NRole#role.campaign]),
    ContinueFlag = lists:member(SecType, ?camp_need_continue),
    case campaign_cond:do(NRole, TotalCamp, Camp, Cond, Args, Conds) of
        {ok, NewRole} when ContinueFlag =:= true -> %% 条件达成 邮件发放奖励 对部分特殊条件要多次执行 直到条件不成立为止
            campaign_adm_reward:send_reward(Cond, Camp, TotalCamp, NRole, Args),
            NR = update_mail_reward(NewRole, Cond),
            do_camp_cond(Cond, Camp, TotalCamp, NR, 0);
        {ok, NewRole} -> %% 条件达成 邮件发放奖励
            campaign_adm_reward:send_reward(Cond, Camp, TotalCamp, NRole, Args),
            NewRole;
        _ ->
            NRole
    end.

%% 更新信件奖励次数
update_mail_reward(Role = #role{campaign = Camp = #campaign_role{mail_list = MailList}}, #campaign_cond{id = CondId, settlement_type = SettType, reward_num = ReNum}) when ReNum > 0 ->
    Now = util:unixtime(),
    NewMailList = [{Id1, N1, Time1} || {Id1, N1, Time1} <- MailList, Now - Time1 < 2592000], 
    NMailList = case lists:keyfind(CondId, 1, NewMailList) of
        {_, N, Time} when SettType =:= ?camp_settlement_type_everyday ->
            case util:is_same_day2(Now, Time) of
                true -> lists:keyreplace(CondId, 1, NewMailList, {CondId, N + 1, Now});
                _ -> lists:keyreplace(CondId, 1, NewMailList, {CondId, 1, Now})
            end;
        {_, N, _} ->
            lists:keyreplace(CondId, 1, NewMailList, {CondId, N + 1, Now});
        _ ->
            [{CondId, 1, Now} | NewMailList]
    end,
    Role#role{campaign = Camp#campaign_role{mail_list = NMailList}};
update_mail_reward(Role, _Cond) -> 
    Role.

check_cond(type, _Camp, #campaign_cond{button = ?camp_button_type_mail}, _Args) -> true;
check_cond(type, _Camp, #campaign_cond{button = ?camp_button_type_hand}, _Args) -> true;
check_cond(type, _Camp, #campaign_cond{sec_type = ?camp_type_play_task_xx_double}, _Args) -> true;
%% 角色等级非法过滤
check_cond(lev, _Camp, #campaign_cond{min_lev = MinLev, max_lev = MaxLev}, #role{lev = Lev}) when Lev >= MinLev andalso (Lev =< MaxLev orelse MaxLev =:= 0) -> true;
%% 不同事件响应过滤
check_cond(label, _Camp, #campaign_cond{type = ?camp_type_pay}, pay) -> true;

check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_power}, power) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_totalpower}, power) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_eqm_enchant}, eqm_enchant) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_skill}, skill) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_pet_potential_avg}, pet_potential_avg) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_petpower}, pet) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_totalpower}, pet) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_pet_grow}, pet_grow) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_pet_skill_lev}, pet_skill_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_mount_step}, mount_step) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_mount_lev}, mount_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_channel_lev}, channel_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_channel_step}, channel_step) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_answer_rank}, answer_rank) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_guild_td_score}, guild_td_score) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_guard_rank}, guard_rank) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_super_boss_total_dmg_rank}, super_boss_total_dmg_rank) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_super_boss_dmg_rank}, super_boss_dmg_rank) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_guild_arena_rank}, guild_arena_rank) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_guild_war_rank}, guild_war_rank) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_area_rank}, arena_rank) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_eqm_purple}, eqm) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_eqm_orange}, eqm) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_eqm_polish}, eqm) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_dungeon_tower}, kill_npc) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_dungeon_tower_hard}, kill_npc) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_dungeon_tower_all}, kill_npc) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_dungeon_loong}, kill_npc) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_dungeon_loong_hard}, kill_npc) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_dungeon_loong_all}, kill_npc) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_dungeon_demon}, kill_npc) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_stone_quech}, stone_quech) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_stone_smelt}, stone_smelt) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_wing_step}, wing_step) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_activity}, activity) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_sworn}, sworn) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_eqm_make}, eqm_make) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_pet_magic_lev}, pet_magic_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_world_compete}, world_compete) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_world_compete_wins}, world_compete) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_escort}, escort) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_god_lev}, god_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_soul_world_magic_lev}, soul_world_magic_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_soul_world_spirit_lev}, soul_world_spirit_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_demon_shape_lev}, demon_shape_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_demon_lev}, demon_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_wing_skill_step}, wing_skill) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_king}, king) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_king_kills}, king_kills) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_demon_skill_step}, demon_skill_step) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_condense_eqm}, condense) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_hole_lev}, hole_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_pet_magic_lev_qua}, pet_magic_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_soul_world_spirit_lev_qua}, soul_world_spirit_lev) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_game_pet_rb_qua}, pet_rb_qua) -> true;

check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_online_login}, online) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_online_days}, online) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_offline_time}, online) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_online_time}, online) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_online_time}, online_time) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_online_time_vip}, online_time) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_online_time_vip_week}, online_time) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_online_time_vip_month}, online_time) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_online_time_vip_half_year}, online_time) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_online_time_vip_no}, online_time) -> true;

check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_flower}, flower) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_flower_acc}, flower) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_flower_acc_each}, flower) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_practice}, practice) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_task_xx}, task) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_task_xx_double}, task) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_longgong}, {casino, 1}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_longgong_acc}, {casino, 1}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_longgong_acc_each}, {casino, 1}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_xianfu}, {casino, 2}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_xianfu_acc}, {casino, 2}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_xianfu_acc_each}, {casino, 2}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_tianguan}, {casino, 3}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_tianguan_acc}, {casino, 3}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_tianguan_acc_each}, {casino, 3}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_jixiang}, {casino, 4}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_jixiang_acc}, {casino, 4}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_jixiang_acc_each}, {casino, 4}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_casino_total}, {casino, _}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_casino_total_acc}, {casino, _}) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_play_casino_total_acc_each}, {casino, _}) -> true;

check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_acc}, casino) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_acc_each}, casino) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_sm_acc}, casino) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_sm_acc_each}, casino) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm}, casino) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm_ico}, casino) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm_each}, casino) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_sm_acc}, npc_store_sm) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_sm_acc_each}, npc_store_sm) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_sm_acc}, npc_store_sm) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_sm_acc_each}, npc_store_sm) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm}, npc_store_sm) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm_ico}, npc_store_sm) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm_each}, npc_store_sm) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_shop_acc}, shop_camp) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_shop_acc_each}, shop_camp) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm}, shop_camp) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm_ico}, shop_camp) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm_each}, shop_camp) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_shop_acc}, shop) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_shop_acc_each}, shop) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm}, shop) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm_ico}, shop) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_casino_shop_sm_each}, shop) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_loss_gold_all}, loss_gold_all) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_loss_gold_all_ico}, loss_gold_all) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_loss_gold_all_new_ico}, loss_gold_all) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_loss_gold_all_each}, loss_gold_all) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_pet_magic}, pet_magic) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_pet_magic_each}, pet_magic) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_wing_skill_acc}, wing_skill_gold) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_wing_skill_each}, wing_skill_gold) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_demon_skill_acc}, demon_skill_gold) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_demon_skill_each}, demon_skill_gold) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_soul_world_call_acc}, soul_world_call_gold) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_soul_world_call_each}, soul_world_call_gold) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_pet_egg_each}, refresh_pet_egg) -> true;
check_cond(label, _Camp, #campaign_cond{sec_type = ?camp_type_gold_pet_egg_acc}, refresh_pet_egg) -> true;

%% 首充特殊判断
check_cond(first_charge, _Camp, #campaign_cond{sec_type = ?camp_type_pay_first}, #role{campaign = #campaign_role{first_charge = 1}}) -> false;
check_cond(first_charge, _Camp, _Cond, _Role) -> true;
check_cond(_Label, _Camp, _Cond, _Args) -> false.

%% 处理结束
do_handle_finish(pay, #role{link = #link{conn_pid = ConnPid}}, TotalCampL, _Args) when is_pid(ConnPid) -> %% 玩家冲值
    case campaign_adm:list_type([?camp_type_pay_each_task, ?camp_type_pay_acc_task, ?camp_type_pay_acc_ico, ?camp_type_pay_acc_ico2, ?camp_type_pay_acc_ico3], TotalCampL) of
        [] -> ok;
        _ ->
            sys_conn:pack_send(ConnPid, 15853, {2}) %% 通知客户端更新充值任务列表数据
    end;
do_handle_finish(Label, #role{link = #link{conn_pid = ConnPid}}, TotalCampL, _Args) when (Label =:= shop orelse Label =:= npc_store_sm orelse Label =:= casino orelse Label =:= loss_gold_all) andalso is_pid(ConnPid) -> %% 玩家消费
    case campaign_adm:list_type([?camp_type_gold_casino_shop_sm_ico, ?camp_type_gold_loss_gold_all_ico, ?camp_type_gold_loss_gold_all_new_ico], TotalCampL) of
        [] -> ok;
        _ ->
            sys_conn:pack_send(ConnPid, 15853, {3}) %% 通知客户端更新消费任务列表数据
    end;
do_handle_finish(_Label, _Role, _TotalCampL, _Args) ->
    ok.

%%----------------------------------------
%% 重新结算晶钻消耗总值
%%----------------------------------------
calc_loss_gold(#campaign_cond{id = CondId, sec_type = SecType, settlement_type = SettType}, Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, Gold) when is_integer(Gold) andalso Gold > 0 ->
    case lists:member(SecType, ?camp_need_acc_gold) of
        true -> %% 需要累计晶钻
            Now = util:unixtime(),
            OutTime = Now - 30 * 24 * 3600,
            AccGoldList1 = [{CondId1, N1, N2, T} || {CondId1, N1, N2, T} <- AccGoldList, T > OutTime],
            NewAccGoldList = case lists:keyfind(CondId, 1, AccGoldList1) of
                {CondId, Acc1, Acc2, Time} when SettType =:= ?camp_settlement_type_everyday -> %% 每天重新计算
                    case util:is_same_day2(Time, Now) of
                        true -> %% 同一天 累计
                            lists:keyreplace(CondId, 1, AccGoldList1, {CondId, Acc1 + Gold, Acc2 + Gold, Now});
                        false -> %% 不是同一天 重新计算
                            lists:keyreplace(CondId, 1, AccGoldList1, {CondId, Gold, Gold, Now})
                    end;
                {CondId, Acc1, Acc2, _Time} ->
                    lists:keyreplace(CondId, 1, AccGoldList1, {CondId, Acc1 + Gold, Acc2 + Gold, Now});
                _ ->
                    [{CondId, Gold, Gold, Now} | AccGoldList1]
            end,
            Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}};
        _ ->
            Role
    end;
calc_loss_gold(_Cond, Role, _Gold) -> Role.

