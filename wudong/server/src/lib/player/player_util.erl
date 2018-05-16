%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 一月 2015 下午1:53
%%%-------------------------------------------------------------------
-module(player_util).
-author("fancy").
-include("server.hrl").
-include("common.hrl").
-include("task.hrl").
-include("mount.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("light_weapon.hrl").
-include("fashion.hrl").
-include("achieve.hrl").
-include("scene.hrl").
-include("cross_scuffle.hrl").
-include("cross_scuffle_elite.hrl").
-include("awake.hrl").

-define(INF, 99999999999999999999999999).

%% API
-export([
    count_player_attribute/1,
    count_player_attribute/2,
    count_player_speed/1,
    count_player_speed/2,
    update_notice/1,
    add_exp/3,
    add_exp/4,
    add_sin/2,
    get_player_online/1,
    get_player/1,
    get_player_pid/1,
    timer/2,
    att_area/2,
    rand_career/0,
    rand_sex/0,
    rand_name/0,
    goods_add_lv/2,
    goods_add_to_lv/2,
    update_online_attrs/2,
    is_new_role/1,
    change_name/3,
    set_gm/2,
    transforme_carrer/2,
    init_lv_attr/1,
    calc_exp_attrs/3,
    get_lv_attr/0,
    update_online_time/2,
    check_player_view_func/1,
    is_cur_sn_player/1,  %%是否本服玩家
    world_lv_add/1,
    change_sex/1
]).

-export([
    func_open_tips/3,
    check_player_online/0
]).

%%查找在线玩家
get_player_online(Key) ->
    case ets:lookup(?ETS_ONLINE, Key) of
        [] -> [];
        [Online | _] -> Online
    end.

%%检查在线玩家
check_player_online() ->
    F = fun(Online) ->
        case misc:is_process_alive(Online#ets_online.pid) of
            false ->
                ets:delete(?ETS_ONLINE, Online#ets_online.key);
            true -> ok
        end
        end,
    lists:foreach(F, ets:tab2list(?ETS_ONLINE)).

%%获取玩家state
get_player(Pid) when is_pid(Pid) ->
    case ?CALL(Pid, {get_player}) of
        {ok, Player} ->
            Player;
        [] ->
            []
    end;
get_player(Pkey) ->
    case misc:get_player_process(Pkey) of
        Pid when is_pid(Pid) ->
            case ?CALL(Pid, {get_player}) of
                {ok, Player} ->
                    Player;
                [] ->
                    []
            end;
        _ -> []
    end.

get_player_pid(Pkey) ->
    case misc:get_player_process(Pkey) of
        Pid when is_pid(Pid) -> Pid;
        _ -> false
    end.

%%随机职业
rand_career() -> 1.
%%    util:list_rand([1, 2]).
rand_sex() ->
    util:list_rand([1, 2]).
rand_name() ->
    io_lib:format("~s~s", [data_name:get_first_name(util:list_rand(data_name:ids_first())), data_name:get_second_name(util:list_rand(data_name:ids_second()))]).

%%初始化等级属性
init_lv_attr(Lv) ->
    case data_exp:get_attrs(Lv) of
        [] ->
            lib_dict:put(?PROC_STATUS_LV_ATTR, #attribute{});
        AttrList ->
            Attribute = attribute_util:make_attribute_by_key_val_list(AttrList),
            lib_dict:put(?PROC_STATUS_LV_ATTR, Attribute)
    end.

get_lv_attr() ->
    lib_dict:get(?PROC_STATUS_LV_ATTR).

%%计算玩家属性
%%可调用进程：玩家进程
count_player_attribute(Player) ->
    count_player_attribute(Player, false).

count_player_attribute(Player, IsNoticeClient) when Player#player.scene == ?SCENE_ID_CROSS_SCUFFLE ->
    if Player#player.scuffle_state orelse IsNoticeClient == false ->
        case data_cross_scuffle_career:figure2career(Player#player.figure) of
            [] -> Player;
            Career ->
                case data_cross_scuffle_career:get(Career) of
                    [] -> Player;
                    BaseData ->
                        AttArea = BaseData#base_scuffle_career.att_area,
                        Speed = BaseData#base_scuffle_career.move_speed,
                        Attribute = attribute_util:make_attribute_by_key_val_list(BaseData#base_scuffle_career.attrs),
                        NewAttribute = Attribute#attribute{att_area = AttArea, speed = Speed},
                        Hp = ?IF_ELSE(IsNoticeClient == false, min(Player#player.hp, NewAttribute#attribute.hp_lim), NewAttribute#attribute.hp_lim),
                        {SKill, PassiveSkill} = cross_scuffle:filter_skill(tuple_to_list(BaseData#base_scuffle_career.skill)),
                        NewPlayer = Player#player{hp = Hp, scuffle_attribute = NewAttribute, scuffle_skill = SKill, scuffle_passive_skill = PassiveSkill, scuffle_state = false},
                        if
                            IsNoticeClient ->
                                {ok, Bin} = pt_130:write(13002, {player_pack:trans13002(NewPlayer)}),
                                server_send:send_to_sid(Player#player.sid, Bin);
                            true ->
                                skip
                        end,
                        NewPlayer
                end
        end;
        true -> Player
    end;

count_player_attribute(Player, IsNoticeClient) when Player#player.scene == ?SCENE_ID_CROSS_SCUFFLE_ELITE ->
    if Player#player.scuffle_elite_state orelse IsNoticeClient == false ->
        case data_cross_scuffle_elite_career:figure2career(Player#player.figure) of
            [] -> Player;
            Career ->
                case data_cross_scuffle_elite_career:get(Career) of
                    [] -> Player;
                    BaseData ->
                        AttArea = BaseData#base_scuffle_elite_career.att_area,
                        Speed = BaseData#base_scuffle_elite_career.move_speed,
                        Attribute = attribute_util:make_attribute_by_key_val_list(BaseData#base_scuffle_elite_career.attrs),
                        NewAttribute = Attribute#attribute{att_area = AttArea, speed = Speed},
                        Hp = ?IF_ELSE(IsNoticeClient == false, min(Player#player.hp, NewAttribute#attribute.hp_lim), NewAttribute#attribute.hp_lim),
                        {SKill, PassiveSkill} = cross_scuffle_elite:filter_skill(tuple_to_list(BaseData#base_scuffle_elite_career.skill)),
                        NewPlayer = Player#player{hp = Hp, scuffle_elite_attribute = NewAttribute, scuffle_skill = SKill, scuffle_passive_skill = PassiveSkill, scuffle_elite_state = false},
                        if
                            IsNoticeClient ->
                                {ok, Bin} = pt_130:write(13002, {player_pack:trans13002(NewPlayer)}),
                                server_send:send_to_sid(Player#player.sid, Bin);
                            true ->
                                skip
                        end,
                        NewPlayer
                end

        end;
        true -> Player
    end;

count_player_attribute(Player, IsNoticeClient) ->
    AttArea = att_area(Player#player.career, Player#player.pf),
    BaseAttribute = #attribute{
        crit = 5,      %固定基础值
        crit_inc = 2000,
        cure = 100,
        size = 100,
        mp_lim = 100,
        att_area = AttArea
    },
    %%附上装备属性
    AttributeLv = get_lv_attr(),
    AttributeEquip = equip_attr:get_equip_all_attribute(),
    AttributeEquipSuit = equip_attr:get_equip_suit_attribute(),
    %%获取神祇系统属性
    AttrGodness = godness_attr:get_attr(Player),
    %%获取符文属性
    AttributeFuwen = fuwen_attr:get_fuwen_all_attribute(),
    %%获取仙装属性
    AttributeXian = xian_attr:get_xian_all_attribute(),
    %%获取仙阶属性
    AttributeXianStage = xian_upgrade:get_attr(Player),
    %%获取仙阶属性
    AttributeXianStage = xian_upgrade:get_attr(Player),
    %%获取仙术(觉醒)属性
    AttributeXianSkill = xian_skill:get_attr(),
    %%仙盟旗帜等级属性
    GuildFlagAttr = guild_fight:get_attrs(Player),
    %%获取装备套装属性
    NewAttributeEquipSuit = equip_suit:get_attr(),
    %%技能
    SkillAttribute = skill_init:get_skill_passive_attribute(),
    AttributeGuildSkill = guild_skill:get_guild_skill_attribute(),
    %% 获取仙魂属性
    AttributeFairySoul = fairy_soul_attr:get_fairy_soul_all_attribute(),
    %% 获取剑道属性
    JiandaoAttr = element_attr:get_jiandao_attr(),
    %% 获取元素属性
    ElementAttr = element_attr:get_element_attr(),
    %%宠物
    PetAttribute = pet_attr:get_pet_attribute(),
    %%外观
    AttributeMount = mount_attr:get_mount_attr(),
    AttributeWing = wing_attr:get_wing_attr(),
    AttributeLW = light_weapon_init:get_attribute(),
    AttributeMW = magic_weapon_init:get_attribute(),
    AttributePW = pet_weapon_init:get_attribute(),
    AttributeGW = god_weapon_init:get_attribute(),
    AttributeGWStar = god_weapon_init:get_star_attribute(),
    AttributeFP = footprint_init:get_attribute(),
    AttributeCat = cat_init:get_attribute(),
    AttributeGoldenBody = golden_body_init:get_attribute(),
    AttributeGodTreasure = god_treasure_init:get_attribute(),
    AttributeJade = jade_init:get_attribute(),
    AttributeBabyWing = baby_wing_attr:get_wing_attr(),
    AttributeBabyMount = baby_mount_init:get_attribute(),
    AttributeBabyWeapon = baby_weapon_init:get_attribute(),
    %%时装
    AttributeFashion = fashion_init:get_attribute(),
    AttributeBubble = bubble_init:get_attribute(),
    AttributeDes = designation_init:get_attribute(),
    AttributeHead = head_init:get_attribute(),
    AttributeDecoration = decoration_init:get_attribute(),
    AttrFashionSuit = fashion_suit_init:get_attribute(),

    AttributeVip = vip:get_vip_attr(),
    AttributeVipState = limit_vip:get_attr(Player),
    AttributeMeridian = meridian:get_meridian_attribute(),
    AttributeSwordPool = sword_pool_init:get_sword_pool_attribute(),
    AttributeMonPhoto = mon_photo_init:get_attribute(),
    AttributeSmelt = smelt_init:get_attribute(),
    AttributeMarryTree = marry_tree:get_marry_tree_attri(),
    AttributeMarryRing = marry_ring:get_attribute(),
    AttriMarryHeart = marry_heart:get_attribute(Player),
    BabyAttrbute = baby_attr:get_baby_attribute(),
    RoleAttrDan = role_attr_dan:get_attribute(),
    AwakeAttr = player_awake:get_attribute(),
    CareerAttrbute = attribute_util:make_attribute_by_key_val_list(task_change_career:get_career_attribute(Player)),
    %%属性添加序号,日志用 log_cbp
    AttributeList = [
        {1, AttributeLv}, {2, BaseAttribute}, {3, AttributeEquip},
        {4, AttributeMount}, {5, PetAttribute},
        {6, AttributeFashion}, {7, AttributeWing},
        {8, AttributeCat}, {9, AttributeGoldenBody}, {10, AttributeJade}, {11, AttributeGodTreasure},
        {12, AttributeEquipSuit}, {13, AttributeVip},
        {14, AttributeMeridian}, {15, AttributeSwordPool},
        {16, AttributeLW}, {17, AttributeMW}, {18, AttributeGW},
        {19, AttributeMonPhoto}, {20, AttributeSmelt}, {21, SkillAttribute}, {22, JiandaoAttr}, {23, ElementAttr},
        {24, AttributeBubble}, {25, AttributeDes}, {26, AttributeFuwen}, {27, AttributeXian}, {28, AttributeXianStage},
        {29, AttributePW}, {30, AttributeGuildSkill}, {31, AttributeHead}, {32, AttributeFP},
        {33, AttriMarryHeart}, {34, AttributeXianSkill}, {35, NewAttributeEquipSuit},
        {36, AttributeMarryRing}, {37, AttributeMarryTree}, {38, AttributeDecoration},
        {39, AttributeFairySoul}, {40, BabyAttrbute}, {41, AttributeBabyWing},
        {42, CareerAttrbute}, {43, AttributeBabyMount},
        {44, AttributeBabyWeapon}, {45, AttrFashionSuit}, {46, RoleAttrDan}, {47, AttrGodness},
        {48, AttributeVipState}, {49, GuildFlagAttr}, {50, AwakeAttr},{51,AttributeGWStar}
    ],
    SumAttribute = attribute_util:sum_attribute_list(AttributeList),
    %%血量上限乘上血量百分比加成
    NewHpLim = trunc(SumAttribute#attribute.hp_lim * (SumAttribute#attribute.hp_lim_inc / 100 + 1)),
    NewAttribute = SumAttribute#attribute{hp_lim = NewHpLim},
    Hp = ?IF_ELSE(Player#player.hp > NewAttribute#attribute.hp_lim orelse Player#player.lv == 1, NewHpLim, Player#player.hp),
    Mp = ?IF_ELSE(Player#player.mp > NewAttribute#attribute.mp_lim, NewAttribute#attribute.mp_lim, Player#player.mp),
    CombatPower = get_player_combat_power(Player#player{attribute = NewAttribute}),
    HighestCombatPower = max(CombatPower, Player#player.highest_cbp),
    ?DO_IF(CombatPower > Player#player.highest_cbp, act_cbp_rank:update_daily_cbp(CombatPower, Player)),
    Player2 = Player#player{hp = Hp, mp = Mp, attribute = NewAttribute, cbp = CombatPower, highest_cbp = HighestCombatPower},
    Player3 = Player2,
    Player4 = count_player_speed(Player3),
    if
        IsNoticeClient ->
            {ok, Bin} = pt_130:write(13002, {player_pack:trans13002(Player4)}),
            server_send:send_to_sid(Player#player.sid, Bin);
        true ->
            skip
    end,
    player_handle:sync_data(attr, Player4),
    log_cbp:log_cbp(Player#player.key, Player#player.nickname, CombatPower, AttributeList),
    Player4.

att_area(Career, 888) ->
    ?IF_ELSE(lists:member(Career, [?CAREER2]), 10, 10);

att_area(Career, _Pf) ->
    ?IF_ELSE(lists:member(Career, [?CAREER2]), 4, 4).

%%玩家速度值
count_player_speed(Player) ->
    count_player_speed(Player, false).

count_player_speed(Player, IsNoticeClient) ->
    Attribute = Player#player.attribute,
    Speed =
        if
            Player#player.convoy_state > 0 ->
                round(?BASE_SPEED * 0.8);
            Player#player.mount_id > 0 ->         %%有坐骑
                MountSpeed = mount_attr:get_speed(Player#player.mount_id),
                round(MountSpeed + ?BASE_SPEED);
            true ->
                round(?BASE_SPEED)
        end,
    NewPlayer = Player#player{attribute = Attribute#attribute{speed = Speed, base_speed = ?BASE_SPEED}},
    if
        IsNoticeClient ->
            scene_agent_dispatch:speed_update(NewPlayer),
            ok;
        true ->
            skip
    end,
    NewPlayer.

%%玩家战斗力
get_player_combat_power(Player) ->
    Cbp =
        attribute_util:calc_combat_power(Player#player.attribute) +
            skill:get_skill_comat_effect(Player) +
            mount_skill:calc_skill_cbp() +
            wing_skill:calc_skill_cbp() +
            magic_weapon_skill:calc_skill_cbp() +
            light_weapon_skill:calc_skill_cbp() +
            pet_util:calc_skill_cbp() +
            pet_weapon_skill:calc_skill_cbp() +
            footprint_skill:calc_skill_cbp() +
            cat_skill:calc_skill_cbp() +
            golden_body_skill:calc_skill_cbp() +
            god_treasure_skill:calc_skill_cbp() +
            jade_skill:calc_skill_cbp() +
            baby_wing_skill:calc_skill_cbp() +
            dvip:calc_skill_cbp(Player#player.d_vip#dvip.vip_type) +
            xian_skill:get_cbp() +
            baby_mount_skill:calc_skill_cbp()
            + baby_weapon_skill:calc_skill_cbp(),
    max(0, Cbp - 120000).

%%更新玩家信息
update_notice(Player) ->
    {ok, Bin} = pt_130:write(13001, player_pack:trans13001(Player)),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.


%% 增加经验
%% 增加经验时带上经验来源，新类型请添加注释。
%% ExpType:经验类型 0打怪类型 1药品 2离线战斗 3快速战斗 4gm  5扫荡,6任务,7传说副本,8组队副本,9主线副本,
%% 10 护送抢劫,11 疯狂点击 12 守护副本 13经验物品 14膜拜 15离线经验找回 16结婚仪式 17王城守卫 18妖魔入侵 19答题 20温泉
%%21结婚 22 晚宴 23打坐 24乱斗精英赛 25跨服1VN 26公会旗帜
%% AddTypeList:加成列表[[Type,Add]] 1世界等级加成 2组队加成经验 3vip加成经验 4合服加成 5温泉加成
add_exp(Player, 0, _) ->
    Player;
add_exp(Player, AddExp, ExpType) ->
    add_exp(Player, AddExp, ExpType, []).
add_exp(Player, AddExp, ExpType, AddTypeList) when AddExp > 0 ->
    add_exp_loop(Player, AddExp, ExpType, AddTypeList, 0, 0);
add_exp(Player, _AddExp, _ExpType, _AddTypeList) ->
    Player.


add_exp_loop(Player, AddExp, ExpType, AddTypeList, UpLv, AccAddExp) ->
    NextLvExp0 = data_exp:get(Player#player.lv),
    St = lib_dict:get(?PROC_STATUS_AWAKE),
    NextLvExp =
        case data_awake:get(St#st_awake.type, 1) of
            [] ->
                ?IF_ELSE(Player#player.lv >= data_version_different:get(13), ?INF, NextLvExp0);
            Base ->
                ?IF_ELSE(Player#player.lv >= Base#base_awake.lv_top, ?INF, NextLvExp0)
        end,
    Exp = round(Player#player.exp + AddExp),
    if
        NextLvExp > Exp ->
            Player2 = Player#player{exp = Exp},
            {CacheExp, TT} = ?EMPTY_DEFAULT(lib_dict:get(?PROC_EXE_ADD), {0, 0}),
            case TT > 500 orelse CacheExp > 10000 of
                false ->
                    lib_dict:put(?PROC_EXE_ADD, {CacheExp + AddExp, TT + 1});
                true ->
                    player_load:dbup_player_lvexp(Player2),
                    lib_dict:init(?PROC_EXE_ADD)
            end,
            case lib_dict:get(?LOGIN_FINISH) of
                true ->
                    {ok, Bin} = pt_130:write(13003, {Exp, AddExp + AccAddExp, ExpType, Player2#player.lv, UpLv, AddTypeList}),
                    server_send:send_to_sid(Player2#player.sid, Bin);
                false ->
                    ok
            end,
            NewPlayer = ?IF_ELSE(ExpType == 1, player_util:check_player_view_func(Player2), Player2),
            NewPlayer;
        true -> %%升级
            Lv = Player#player.lv + 1,
            Exp2 = Exp - NextLvExp,
            ExpLim = data_exp:get(Lv),
            {Wlv, WlvAdd} = world_lv_add(Player),
            Player2 = Player#player{exp = 0, exp_lim = ExpLim, lv = Lv, world_lv = Wlv, world_lv_add = WlvAdd},
            lv_vip:lv_up(Player2),
            fairy_soul_init:update(Lv),
            if Lv >= 50 ->
                recharge_rank:add_recharge_val(Player2, 0),
                consume_rank:add_consume_val(0, Player2, 0),
                cross_consume_rank:add_consume_val(0, Player2, 0),
                area_consume_rank:add_consume_val(0, Player2, 0),
                cross_recharge_rank:add_recharge_val(Player2, 0),
                area_recharge_rank:add_recharge_val(Player2, 0);
                true -> skip
            end,
            ?DO_IF(Player2#player.lv == 30, self() ! {d_v_trigger, 13, []}),
            self() ! {d_v_trigger, 2, []},
            scene_agent_dispatch:lv_update(Player2),
            ?DO_IF(Player#player.lv >= 20, player_load:log_up_lv(Player#player.key, Player#player.nickname, Player#player.lv, UpLv, ExpType)),
            Player3 = upgrade_lv_trigger(Player2),
            Player99 = prison:protect_check(Player3, Lv),
            hqg_daily_charge:notice(Player99, Lv),
            hundred_return:notice(Player99, Lv),
            act_invest:notice(Player99, Lv),
            act_meet_limit:update_list(Player99),
            act_cbp_rank:update_cbp(Player99),
            self() ! {activity_lv_notice},
            add_exp_loop(Player99, Exp2, ExpType, AddTypeList, UpLv + 1, AccAddExp + (AddExp - Exp2))
    end.

upgrade_lv_trigger(Player) ->
    %%玩家升级，查询新任务
    Player1 = task:auto_accept_task(Player),
%%    goods_warehouse:lv_up(Player),
    Player2 = player_util:check_player_view_func(Player1),
    Player3 = skill:auto_learn_skill(Player2),
    init_lv_attr(Player#player.lv),
    Player4 = player_util:count_player_attribute(Player3, false),
    Player5 = Player4#player{hp = Player4#player.attribute#attribute.hp_lim, mp = Player4#player.attribute#attribute.mp_lim},
    Player6 = smelt_init:upgrade_lv(Player5),
    %%宠物升级
%%    Player7 = pet:pet_lv_up(Player6),
    Player8 = guild_util:upgrade_auto_apply(Player6),
    NewPlayer = Player8,
    {ok, BinPlayer} = pt_130:write(13002, {player_pack:trans13002(NewPlayer)}),
    {ok, BinUp} = pt_120:write(12031, {NewPlayer#player.key, NewPlayer#player.lv}),
    server_send:send_to_sid(NewPlayer#player.sid, BinPlayer),
    server_send:send_to_scene(NewPlayer#player.scene, NewPlayer#player.copy, NewPlayer#player.x, NewPlayer#player.y, BinUp),
    player_load:dbup_player_state(NewPlayer),
    player_load:dbup_player_lv_time(NewPlayer),
    player_util:update_notice(NewPlayer),

    task_event:event(?TASK_ACT_UPLV, {NewPlayer#player.lv}),
    shadow_proc:set(NewPlayer),
    tips:upgrade_refresh(NewPlayer),
%%     activity:get_notice(NewPlayer, [53, 79], true),
    friend_like:send_upgrade_info(NewPlayer),
    update_online_attrs(NewPlayer#player.key, [{lv, NewPlayer#player.lv}]),
    guild_cbp:update_mb_cbp(NewPlayer),
    target_act:trigger_tar_act(NewPlayer, 1, NewPlayer#player.lv),
    equip_wash:upgrade_plv(NewPlayer#player.lv),
    achieve:trigger_achieve(NewPlayer, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1001, 0, NewPlayer#player.lv),
    activity:check_activity_state(Player),
    team_util:update_player_lv(NewPlayer),
    findback_src:update(NewPlayer),
    goods_init:upgrade_bag_cell(NewPlayer),
    NewPlayer.


check_player_view_func(Player) ->
    Player31 = mount_init:check_upgrade_lv(Player),
    Player32 = wing_init:check_upgrade_lv(Player31),
    Player33 = light_weapon_init:upgrade_lv(Player32),
    Player34 = magic_weapon_init:upgrade_lv(Player33),
    Player35 = pet_weapon_init:upgrade_lv(Player34),
    Player36 = footprint_init:upgrade_lv(Player35),
    Player37 = cat_init:upgrade_lv(Player36),
    Player38 = golden_body_init:upgrade_lv(Player37),
    baby_init:upgrade_lv(Player38),
    Player39 = baby_wing_init:check_upgrade_lv(Player38),
    Player40 = baby_mount_init:upgrade_lv(Player39),
    Player41 = baby_weapon_init:upgrade_lv(Player40),
%%     Player42 = time_limit_wing:open_time_limit_wing(Player41),
    Player42 = time_limit_wing:close_time_limit_wing(Player41),
    Player43 = jade_init:upgrade_lv(Player42),
    Player44 = god_treasure_init:upgrade_lv(Player43),
    Player45 = limit_vip:close_time_limit_vip(Player44),

    Player45.

add_sin(Num, Player) ->
    NewPlayer = Player#player{sin = Player#player.sin + Num},
    NewPlayer.

%%玩家自身定时器,频率5S
timer(Player, Seconds) ->
    Now = util:unixtime(),
    cross_mining_util:timer_update(Player),

%%     act_meet_limit:timer_touch(Player),
    case Seconds rem 120 == 0 of
        true ->
            tips:get_tips(Player, data_tips:timer_tips());
        false -> skip
    end,
    case Seconds rem 3600 == 0 of %% 特殊处理，隔一个小时推送物品过期
        true ->
            tips:get_tips(Player, [160]);
        false -> skip
    end,
    case Seconds rem 1800 == 0 of %% 特殊处理，隔半小时推送飞升丹入口
        true ->
            activity:get_notice(Player, [128, 127], true);
        false -> skip
    end,
    Player0 =
        case Seconds rem 60 == 0 of %%每分钟检查
            true ->
                %%时装过期检查
                PlayerFashion = fashion_init:check_fashion_timeout(Player, Now),
                PlayerBubble = bubble_init:check_bubble_timeout(PlayerFashion, Now),
                PlayerDesignation = designation_init:check_designation_timeout(PlayerBubble, Now),
                PlayerVip = vip_init:update(PlayerDesignation),
                PlayerMount = mount:check_des_time(PlayerVip, Now),
                PlayerWing = wing:check_des_time(PlayerMount, Now),
                PlayerHead = head_init:check_head_timeout(PlayerWing, Now),
                PlayerDecoration = decoration_init:check_decoration_timeout(PlayerHead, Now),
                Player990 = prison:update_online_time(PlayerDecoration, Now),
                Player99 = player_util:update_online_time(Player990, Now),
                act_meet_limit:get_act(),
                {Wlv, WlvAdd} = world_lv_add(Player99),
                timer_update_db(Player99, Now),
                baby:check_baby_born_time_icon(Player99, Now),
                act_meet_limit:update_online_time(Player99),
                vip_face:discard(),
                Player99#player{world_lv = Wlv, world_lv_add = WlvAdd};
            false ->
                Player
        end,
    %%祝福检查
    PlayerBless = player_bless:bless_reset(Player0, Now),
    buff_init:refresh_buff(Now),
    PlayerFightFlag = guild_fight:add_flag_exp(PlayerBless),
    PlayerScuffle1 = cross_scuffle:recover_hp(PlayerFightFlag),
    PlayerScuffle2 = cross_scuffle_elite:recover_hp(PlayerScuffle1),
    PlayerHp = hp_pool:recover_hp_sys(PlayerScuffle2, Now),
    PlayerAccDamage = cross_scuffle:acc_damage(PlayerHp),
    PlayerAccDamage2 = cross_scuffle_elite:acc_damage(PlayerAccDamage),
    PlayerAccDamage3 = cross_scuffle_elite:acc_damage(PlayerAccDamage2),
    PlayerSit = sit_exp(PlayerAccDamage3),
    baby:check_baby_born(Player0, Now),
    player_fcm:refresh_online(Player,Now,Seconds),
    PlayerDVip = dvip_util:check_dvip_end_time(PlayerSit, Now),
    NewPlayer = PlayerDVip,
%%     activity:timer_notice(NewPlayer),
    case Seconds rem 180 == 0 of
        true ->
            tips:get_tips(Player, [110]),
            guild_cbp:update_mb_cbp(Player),
            %%7天目标好友状态更新
            findback_src:timer_update(Player),
            %%掉落绑定
            self() ! {d_v_trigger, 11, []},
            ok;
        false -> skip
    end,
    case Seconds rem 1800 == 0 of %% 登陆时需要处理一次
        true ->
            %%祝福查询定时器
%%             player_bless:timer(NewPlayer, Now),
            tips:get_tips(Player, [161, 162, 163, 164, 165, 166]);
        false -> skip
    end,
%%    check_enter_scene(Player, Now),
    check_heartbeat(Player, Now),
    NewPlayer1 = case Seconds rem 180 == 0 of
                     true ->
                         marry_ring:timer_add_sweet(NewPlayer);
                     false -> NewPlayer
                 end,
    case Seconds rem 30 == 0 of
        true ->
            act_buy_money:update_online_time(NewPlayer1),
            online_reward:update_online_time(NewPlayer1),
            act_throw_egg:update_online_time(NewPlayer1),
            act_throw_fruit:update_online_time(NewPlayer1);
        false -> skip
    end,
    NewPlayer2 =
        case Seconds rem 10 == 0 of
            true ->
                if
                    NewPlayer1#player.scene == ?SCENE_ID_CROSS_SCUFFLE_ELITE_READY ->
                        Exp = util:floor(0.009 * NewPlayer1#player.lv * NewPlayer1#player.lv - 0.649 * NewPlayer1#player.lv + 13.74),
                        player_util:add_exp(Player, Exp * 20, 24);
                    true -> NewPlayer1
                end;
            false -> NewPlayer1
        end,
    NewPlayer3 =
        case Seconds rem 5 == 0 of
            true ->
                if
                    NewPlayer2#player.scene == ?SCENE_ID_CROSS_1VN_READY orelse NewPlayer2#player.scene == ?SCENE_ID_CROSS_1VN_FINAL_READY ->
                        case cross_1vn_util:get_act_state() of
                            0 -> NewPlayer2;
                            _ ->
%%                                 (0.0273* 人物等级 * 人物等级 - 1.9484* 人物等级 + 41.232)*10,
                                Exp1 = util:floor(0.0273 * NewPlayer1#player.lv * NewPlayer1#player.lv - 1.9484 * NewPlayer1#player.lv + 41.232) * 10,
                                ExpUp =
                                    case cache:get({cross_1vn_winner_state, NewPlayer2#player.key}) of
                                        [] -> 0;
                                        {State, ExpUp0} -> ?IF_ELSE(State == 0, 0, ExpUp0)
                                    end,
                                daily:increment(?DAILY_CROSS_1VN_EXP, util:floor(Exp1 * (1 + ExpUp))),
                                player_util:add_exp(Player, util:floor(Exp1 * (1 + ExpUp)), 25)
                        end;
                    true -> NewPlayer2
                end;
            false -> NewPlayer2
        end,
    NewPlayer3.



sit_exp(Player) ->
    if Player#player.sit_state == 0 -> Player;
        true ->
            Exp = data_sit:get(Player#player.lv),
            {ok, Bin} = pt_130:write(13031, {Exp}),
            server_send:send_to_sid(Player#player.sid, Bin),
            player_util:add_exp(Player, Exp, 23)
    end.

%%检查心跳
check_heartbeat(Player, Now) ->
    case get(?HEARTBEAT) of
        undefined -> ok;
        LastTime ->
            %%超过15分钟没心跳,退出
            if Now - LastTime > ?FIFTEEN_MIN_SECONDS ->
                ?WARNING("player ~p check_heartbeat stop~n", [Player#player.key]),
                ?CAST(self(), stop),
                ok;
                true ->
                    ok
            end
    end.


%%check_enter_scene(Player, Now) ->
%%    case scene:is_normal_scene(Player#player.scene) of
%%        false -> skip;
%%        true ->
%%            case get(enter_scene) of
%%                undefined ->
%%                    case scene_agent:get_scene_player(Player#player.scene, Player#player.copy, Player#player.key) of
%%                        [] ->
%%                            self() ! check_enter_scene;
%%                        _ -> ok
%%
%%                    end;
%%                {Sid, _Copy} ->
%%                    if Player#player.scene =/= Sid andalso Now - Player#player.enter_sid_time > 5 ->
%%                        case scene_agent:get_scene_player(Player#player.scene, Player#player.copy, Player#player.key) of
%%                            [] ->
%%                                self() ! check_enter_scene;
%%                            _ -> ok
%%
%%                        end;
%%                        true ->
%%                            skip
%%                    end
%%            end
%%    end.

%%定时同步玩家数据
timer_update_db(Player, _Now) ->
    task_init:timer_update(),
    player_mask:save(),
    daily_init:timer_update(),
%%    treasure:timer_update(),
    guild_skill:timer_update(),
    battlefield_init:timer_update(),
    cross_arena_init:timer_update(),
    equip_wash:timer_update(),
    meridian_init:timer_update(),
    achieve_init:timer_update(),
    sword_pool_init:timer_update(),
    cross_dungeon_init:timer_update(),
    cross_dungeon_guard_init:timer_update(),
    dungeon_tower:timer_update(),
    hp_pool:timer_update(),
    sign_in_init:timer_update(),
    light_weapon_init:timer_update(),
    pet_weapon_init:timer_update(),
    cat_init:timer_update(),
    golden_body_init:timer_update(),
    god_treasure_init:timer_update(),
    jade_init:timer_update(),
    footprint_init:timer_update(),
    magic_weapon_init:timer_update(),
    god_weapon_init:timer_update(),
    mon_photo_init:timer_update(),
    dungeon_material:timer_update(),
    dungeon_exp:timer_update(),
    dungeon_daily:timer_update(),
    mount_util:timer_update(),
    wing_init:timer_update(),
    baby_wing_init:timer_update(),
    smelt_init:timer_update(),
    skill_init:timer_update(),
    fashion_init:timer_update(),
    bubble_init:timer_update(),
    decoration_init:timer_update(),
    designation_init:timer_update(),
    buff_init:timer_update(),
    cross_elite_init:timer_update(),
    cross_eliminate_init:timer_update(),
    pet_init:timer_update(),
    head_init:timer_update(),
    dungeon_god_weapon:timer_update(),
    dungeon_guard:timer_update(),
    goods_load:gem_exp_save(Player),
    goods_load:str_exp_save(Player),
    goods_load:db_save_refine_info(Player),
    goods_load:db_save_magic_info(Player),
    goods_load:db_save_soul_info(Player),
    cross_dark_bribe:timer_update(),
    baby_init:timer_update(),
    baby_mount_init:timer_update(),
    baby_weapon_init:timer_update(),
    act_cbp_rank:update_cbp(Player),
    fashion_suit_init:timer_update(),
    dungeon_equip:timer_update(),
    act_consume_rebate:timer_update(),
    merge_act_acc_consume:timer_update(),
%%     goods_load:db_save_soul_info(Player),
    ok.

%%物品增加玩家等级
goods_add_lv(Player, []) -> Player;
goods_add_lv(Player, [{LvMin, LvMax, AddType} | Tail]) ->
    case Player#player.lv >= LvMin andalso Player#player.lv =< LvMax of
        true ->
            AddExp = data_exp:get(Player#player.lv),
            NewPlayer = player_util:add_exp(Player, AddExp, 13),
            goods_add_lv(NewPlayer, Tail);
        false ->
            NewPlayer = player_util:add_exp(Player, AddType, 13),
            goods_add_lv(NewPlayer, Tail)
    end.

%%物品增加玩家等级
goods_add_to_lv(Player, []) -> Player;
goods_add_to_lv(Player, [{LvMin, LvMax, AddType} | Tail]) ->
    if Player#player.lv < LvMin ->
        goods_add_to_lv(Player, Tail);
        Player#player.lv >= LvMax ->
            NewPlayer = player_util:add_exp(Player, AddType, 13),
            goods_add_to_lv(NewPlayer, Tail);
        true ->
            F = fun(Lv) ->
                data_exp:get(Lv)
                end,
            AddExp = lists:sum(lists:map(F, lists:seq(Player#player.lv, LvMax))),
            NewPlayer = player_util:add_exp(Player, AddExp, 13),
            goods_add_to_lv(NewPlayer, Tail)
    end.

update_online_attrs(Pkey, Attrs) ->
    case get_player_online(Pkey) of
        [] -> [];
        Online ->
            NewOnline = update_online_attrs_helper(Attrs, Online),
            ets:insert(?ETS_ONLINE, NewOnline)
    end.

update_online_attrs_helper([], Online) -> Online;
update_online_attrs_helper([{Type, Val} | Tail], Online) ->
    NewOnline =
        case Type of
            lv -> Online#ets_online{lv = Val};
            _ -> Online
        end,
    update_online_attrs_helper(Tail, NewOnline).

is_new_role(Player) ->
    Player#player.logout_time == 0.

set_gm(Pkey, GM) ->
    case GM == 1 andalso player_load:dbget_player_gm_count() >= 5 of
        true -> 2;
        false ->
            player_load:dbup_player_gm(Pkey, GM),
            case get_player_online(Pkey) of
                [] -> skip;
                Online ->
                    Online#ets_online.pid ! {set_gm, GM}
            end,
            1
    end.

%%改名
change_name(Player, NewName, Type) ->
    case player_login:check_name("", NewName) of
        {false, Res} ->
            Res1 = ?IF_ELSE(Res == 5, 9, Res),
            {false, Res1};
        {true, _} ->
            case Type of
                1 -> ok;
                2 ->
                    GoodsId = 1026000,
                    Count = goods_util:get_goods_count(GoodsId),
                    DailyType = ?DAILY_CHANGE_NAME,
                    LastTime = daily:get_count(DailyType),
                    Now = util:unixtime(),
                    IsSameData = util:is_same_date(Now, LastTime),
                    if
                        Count =< 0 -> {false, 10};
                        IsSameData -> {false, 11};
                        true ->
                            goods:subtract_good(Player, [{GoodsId, 1}], 170),
                            NewPlayer = do_change_name(Player, NewName),
                            daily:set_count(DailyType, Now),
                            {ok, NewPlayer}
                    end
            end
    end.

do_change_name(Player, NewName) ->
    #player{key = Pkey} = Player,
    NewPlayer = Player#player{nickname = NewName},
    player_load:dbup_player_name(NewPlayer),
    shadow_proc:set(NewPlayer),
    cross_boss:change_name(Player#player.key, NewName),
    %%仙盟长、成员名
    guild_util:change_guild_pname(Player, NewName),
    Sql2 = io_lib:format("update recharge set nickname = '~s' where app_role_id = ~p", [NewName, Pkey]),
    db:execute(Sql2),
    NewPlayer.


change_sex(Player) ->
    GoodsId = 7208001,
%%     GoodsId = 8001001,
    Count = goods_util:get_goods_count(GoodsId),
    if
        Count =< 0 ->
            Player;
        true ->
            NewSex = ?IF_ELSE(Player#player.sex == 1, 2, 1),
            NewPlayer = Player#player{sex = NewSex},
            player_load:dbup_player_sex(NewPlayer),
            shadow_proc:set(NewPlayer),
            scene_agent_dispatch:sex_update(NewPlayer),
            guild_util:change_guild_psex(NewPlayer, NewPlayer#player.sex),
            spawn(fun() -> util:sleep(1000), worship_proc:get_worship_pid() ! check_change_people end),
            marry_room:change_info(NewPlayer),
            if
                Player#player.sex == 1 ->
                    Msg = io_lib:format(t_tv:get(259), [t_tv:pn(Player)]),
                    notice:add_sys_notice(Msg, 259);
                true ->
                    Msg = io_lib:format(t_tv:get(260), [t_tv:pn(Player)]),
                    notice:add_sys_notice(Msg, 260)
            end,
            %%        relation:notice_relation(NewPlayer),
            NewPlayer
    end.

transforme_carrer(Player, Career) when is_integer(Career) andalso Career >= 1 andalso Career =< 4 ->
    goods:subtract_good_throw(Player, [{11142, 1}], 0),
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    case lists:keyfind(?GOODS_SUBTYPE_WEAPON, #weared_equip.pos, GoodsStatus#st_goods.weared_equip) of
        false ->
            Player1 = Player,
            GoodsSt1 = GoodsStatus;
        WearedEquip ->
            WeaponGoodsType = data_goods:get(WearedEquip#weared_equip.goods_id),
            WeaponGoods = goods_util:get_goods(WearedEquip#weared_equip.goods_key),
            {Career, NewWeaponGoodsId} = lists:keyfind(Career, 1, data_equip_carrer:get({WeaponGoodsType#goods_type.equip_lv, ?GOODS_SUBTYPE_WEAPON})),
            NewWeaponGoods = WeaponGoods#goods{goods_id = NewWeaponGoodsId},
            GoodsSt1 = goods_dict:update_goods(NewWeaponGoods, GoodsStatus),
            goods_pack:pack_send_goods_info(NewWeaponGoods, Player#player.sid),
            goods_load:dbup_goods_id(NewWeaponGoods),
            NewWeaponGoodsType = data_goods:get(NewWeaponGoodsId),
            Player1 = equip:equip_figure_update(Player, NewWeaponGoodsType)
    end,
    case lists:keyfind(?GOODS_SUBTYPE_WEAPON_2, #weared_equip.pos, GoodsStatus#st_goods.weared_equip) of
        false ->
            GoodsSt2 = GoodsSt1;
        WearedEquip2 ->
            WeaponGoodsType2 = data_goods:get(WearedEquip2#weared_equip.goods_id),
            WeaponGoods2 = goods_util:get_goods(WearedEquip2#weared_equip.goods_key),
            {Career, NewWeaponGoodsId2} = lists:keyfind(Career, 1, data_equip_carrer:get({WeaponGoodsType2#goods_type.equip_lv, ?GOODS_SUBTYPE_WEAPON_2})),
            NewWeaponGoods2 = WeaponGoods2#goods{goods_id = NewWeaponGoodsId2},
            GoodsSt2 = goods_dict:update_goods(NewWeaponGoods2, GoodsSt1),
            goods_pack:pack_send_goods_info(NewWeaponGoods2, Player#player.sid),
            goods_load:dbup_goods_id(NewWeaponGoods2)
    end,
    {EquipAttribute, WearedEquipList} = goods_init:equip_init(GoodsSt2#st_goods.dict),

    GoodsList = goods_dict:dict_to_list(GoodsSt2#st_goods.dict),
    FunGoods = fun(Goods, DictOut) ->
        case data_suipian_carrer:get(Goods#goods.goods_id) of
            [] ->
                DictOut;
            GoodsTypeList ->
                {Career, NewGoodsTypeId1} = lists:keyfind(Career, 1, GoodsTypeList),
                NewGoodsTypeGood = Goods#goods{goods_id = NewGoodsTypeId1},
                goods_pack:pack_send_goods_info(NewGoodsTypeGood, Player#player.sid),
                goods_load:dbup_goods_id(NewGoodsTypeGood),
                goods_dict:update_goods(NewGoodsTypeGood, DictOut)
        end
               end,
    NewDict = lists:foldl(FunGoods, GoodsSt2#st_goods.dict, GoodsList),


    lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2#st_goods{
        dict = NewDict,
        weared_equip = WearedEquipList,
        equip_attribute = EquipAttribute}),

%%    LightWeaponSt = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
%%    FunLight = fun(LightWeapon, {Out, PlayerLight}) ->
%%        case data_light_weapon_carrer:get(LightWeapon#light_weapon.light_weapon_id) of
%%            [] ->
%%                {[LightWeapon | Out], PlayerLight};
%%            LightIdList ->
%%                {Career, NewLightId} = lists:keyfind(Career, 1, LightIdList),
%%                PlayerLight1 = ?IF_ELSE(LightWeapon#light_weapon.light_weapon_id =:= PlayerLight#player.light_weaponid, PlayerLight#player{light_weaponid = NewLightId}, PlayerLight),
%%                light_weapon_load:updata_light_weapon_id(LightWeapon, NewLightId),
%%                {[LightWeapon#light_weapon{light_weapon_id = NewLightId} | Out], PlayerLight1}
%%        end
%%               end,
%%    {NewLightWeaponList, Player2} = lists:foldl(FunLight, {[], Player1}, LightWeaponSt#st_light_weapon.all_light_weapon_list),
%%    NewLightWeaponSt = LightWeaponSt#st_light_weapon{all_light_weapon_list = NewLightWeaponList},
%%    lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeaponSt),
%%    light_weapon_pack:send_light_weapon_info(NewLightWeaponList, Player),

%%    StFa = lib_dict:get(?PROC_STATUS_FASHION),
%%    FunFa = fun(Fashion) ->
%%        case data_fashion_carrer:get(Fashion#fashion.id) of
%%            [] ->
%%                ok;
%%            FashionIdList ->
%%                {Career, NewFashionId} = lists:keyfind(Career, 1, FashionIdList),
%%                fashion_load:dbup_fashion_id(Fashion, Player#player.key, NewFashionId)
%%        end
%%            end,
%%    lists:foreach(FunFa, StFa#st_fashion.own_clothes),
%%    Player3 = fashion_init:init(Player1),
%%    StFaNew = lib_dict:get(?PROC_STATUS_FASHION),
%%    fashion_pack:send_fashion_info(StFaNew#st_fashion.own_clothes, Player1#player.sid),

    FSkill = fun({SkillId, Slv, State}, Out) ->
        case data_skill_carrer:get(SkillId) of
            [] ->
                [{SkillId, Slv, State} | Out];
            SkillIdList ->
                {Career, NewSkillId} = lists:keyfind(Career, 1, SkillIdList),
                [{NewSkillId, Slv, State} | Out]
        end
             end,
    SkillList = lists:foldl(FSkill, [], Player#player.skill),
    skill_load:dbup_player_skill(Player),
    Player4 = Player1#player{career = Career, skill = SkillList},
    {ok, BinPlayer} = pt_130:write(13001, player_pack:trans13001(Player4)),
    server_send:send_to_sid(Player#player.sid, BinPlayer),
    guild_util:career(Player#player.key, Player#player.guild#st_guild.guild_key, Career),
    arena_proc:career(Player#player.key, Career),
    shadow_proc:set(Player4),
    {ok, Player4};

transforme_carrer(_Player, _Career) ->
    _Career.



calc_exp_attrs(Exp, ExpLim, Attrs) ->
    case ExpLim of
        0 -> Attrs;
        _ ->
            Mult = util:floor(Exp / ExpLim * 100),
            [{Type, round(Val * Mult)} || {Type, Val} <- Attrs]
    end.

%%外观功能开启推送
func_open_tips(Player, Type, Id) ->
    {ok, Bin} = pt_130:write(13025, {Type, Id}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%是否本服玩家
is_cur_sn_player(Sn) ->
    case ets:lookup(?ETS_MERGE_SN, Sn) of
        [] -> false;
        _ -> true
    end.

%%世界等级经验加成系数
world_lv_add(Lv) when is_integer(Lv) ->
    Wlv = rank:get_world_lv(),
    Add =
        if Wlv < 60 orelse Lv < 48 -> 0;
            Lv >= Wlv -> 0;
            true ->
                data_world_lv_exp_buff:get(abs(Wlv - Lv))
        end,
    {Wlv, Add};
world_lv_add(Player) ->
    {Wlv, Add} = world_lv_add(Player#player.lv),
    if Add == Player#player.world_lv_add -> ok;
        true ->
            {ok, Bin} = pt_130:write(13027, {Wlv, round(Add * 100)}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    {Wlv, Add}.


update_online_time(Player, Now) ->
    OnlineTime = max(0, Now - Player#player.last_login_time),
    NewPlayer = Player#player{online_time = OnlineTime},
    NewPlayer.
