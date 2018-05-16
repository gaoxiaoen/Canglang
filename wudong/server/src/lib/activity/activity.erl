%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 一月 2016 下午7:24
%%%-------------------------------------------------------------------
-module(activity).
-author("fengzhenlin").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").
%%协议接口
-export([
    get_notice/3,  %%获取活动状态
    check_activity_state/1,
    get_all_act_state/1,
    get_leave_time/1,
    calc_act_leave_time/1,
    calc_act_start_day/1,
    get_start_day/1,
    get_act_info/1,
    all_act_mod/0,
    timer_notice/1,
    get_base_state/1,  %%获取活动基础状态信息
    do_get_notice/3, %%实时获取活动通知
    send_act_state/2 %% 通知客户端红点变化状态
]).

%% 活动工具函数
-export([
    f/3,  %%apply 增加catch处理
    get_work_list_by_time_all/1  %%获取特定时间戳有效的活动列表(所有)
    , get_work_list_by_time/2  %%获取特定时间戳有效的活动列表
    , get_work_list/1  %%获取有效的活动列表
    , get_work_list_mutex/1  %%获取有效的活动列表(有互斥活动处理)
    , activity_reset/1%%活动重置
    , is_merge_act/1  %%当前活动是否是合服活动
    , gm_print/2 %% 打印当前红点状态
    , activity_gm_print/2
    , sys_notice/2
    , pack_act_state/1
    , timer_min_notice/2
    , set_timer_open_state/2
    , get_timer_state/1
    , check_timer_state/2
]).

sys_notice(IdList, Player) ->
    get_notice(Player, IdList, true),
    ok.

gm_print(Key, Id) ->
    case ets:lookup(ets_online, Key) of
        [] ->
            ok;
        [#ets_online{pid = Pid}] ->
            Pid ! {activity_gm_print, Id}
    end.

activity_gm_print(Player, 0) ->
    gm_get_notice(Player, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33,
        34, 35, 36, 37, 38, 39, 40, 41, 42, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 73, 72, 74, 75, 76,
        77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
        110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 140, 141], true);

activity_gm_print(Player, Id) ->
    gm_get_notice(Player, [Id], true).

%%所有的活动模块
all_act_mod() ->
    [
        {1, data_fir_charge},
        {2, data_act_rank},
        {3, data_d_fir_charge},
        {4, data_acc_charge},
        {5, data_acc_consume},
        {6, data_one_charge},
        {7, data_new_daily_charge},
        {8, data_new_one_charge},
        {9, data_act_rank_goal},
        {10, data_exchange},
        {11, data_act_rank},
        {12, data_online_time_gift},
        {13, data_daily_acc_charge},
        {14, data_lim_shop},
        {15, data_online_gift},
        {16, data_acc_charge_turntable},
        {17, data_daily_fir_charge_return},
        {18, data_acc_charge_gift},
        {19, data_goods_exchange},
        {20, data_role_d_acc_charge},
        {21, data_con_charge},
        {22, data_open_egg},
        {23, data_merge_sign_in},
        {24, data_charge_mul},
        {26, data_target_act}
    ].

%%活动/功能的奖励状态更新
%%活动id 1首充 2冲榜 3每日充值 4累计充值 5累计消费 6单笔充值 7新每日充值 8新单笔充值 9冲榜返利 10兑换活动 11冲榜抢购 12在线时长 13每日累充
%% 14抢购商店 15定时奖励 16累充转盘 17每日首冲返还 18累充礼包 19物品兑换 20角色每日累充 21连续充值 22砸蛋 23合服签到 24充值多倍 25仙盟排行 26目标福利
%% 27名人堂 28活动预览 31藏宝阁 32花千骨每日首充 33开服活动 34投资计划 35进阶宝箱 36迷宫寻宝 37限时抢购 38符文寻宝 39登陆有礼 40新兑换活动 41特权炫装
%% 42护送称号活动 43大额累充活动 44消费抽返利 45仙境寻宝 46合服活动
%% 51活动7天目标 52活动7天登陆领取奖励 53等级礼包 54签到 56跑环 57帮派战
%% 58竞技场 59 护送 60天天跑环 61 组队副本 63.坐骑副本 64.翅膀副本 65.宠物副本 66.商城副本
%% 70 资源下载奖励 72 淘宝信息 73邮件 74 洗练副本 75强化副本 77vip礼包 79 投资领取奖励 80月卡奖励 81终身卡奖励 82全民福利
%% 84许愿树 85野外boss 86消消乐 87经脉 89离线经验找回 90离线资源找回 91剑池是否有升级 92仙盟奖励 93跨服竞技奖励 94时装相关 95图鉴相关 96福利大厅相关
%% 97进阶副本 98经验副本 99剧情副本 100神器副本 101经脉副本 102符文塔 103vip副本 104跨服副本 105竞技场挑战 106竞技场积分奖励 107跨服竞技场挑战 108成就相关
%% 109十方神器 110宠物相关提示 111抽奖转盘 112鲜花榜 113百倍返利 114集字活动 115灵脉副本 116原石鉴定 117仙盟家园 118符文镶嵌 119限时活动入口 120消费充值榜入口 121守护副本
%% 122 单服鲜花榜  123连续充值 124 金银塔 125水果大作战 126开心消消乐 127仙羽飞升丹 128坐骑飞升丹 129红装兑换 130碎片兑换 131结婚排行榜 132招财进宝 133仙侣大厅 134爱情试炼
%% 135爱情香囊 136巡游 137结婚羁绊 138结婚戒指 139结婚称号 140招财猫, 141深渊魔宫, 142 全名嗨翻天 143攻城战入口 144 零元礼包 147 转职 148新招财猫 149攻城战红点 150 转盘抽奖
%% 151疯狂砸蛋 152一元抢购 153节日活动登陆有礼 154节日活动累计充值 155神秘商城 156限时抢购礼包 159小额充值活动,160 钻石VIP 161 节日活动入口 162双倍充值,163 神装副本 164 套装
%% 165等级返利 168财神单笔充值活动 169聚宝盆 171限时仙装活动 172 红装兑换活动 173爱情树红点 174跨服试炼 175小额单笔充值 176显示宠物成长 177 回归活动广告 178公会宝箱 179 1vn 180神祇副本
%% 183 许愿池 184 跨服许愿池 86 仙盟对战红点 187 仙盟对战双倍活动红点 190跃升冲榜 191奇遇礼包 192元素/剑道副本 193剑道寻宝 194符文寻宝折扣 195剑道寻宝折扣 196仙晶矿洞红点 197新零元礼包
%% 198消费有礼
get_all_act_state(Player) ->
    get_notice(Player, [4, 5, 12, 15, 25, 27, 31, 32, 33,
        34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 73, 72, 74, 75, 76,
        77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
        110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143,
        144, 145, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 186, 187, 188, 189, 190, 191,
        192, 193, 196, 197], true).

%%获取指定活动的状态
get_notice(Player, ActIdList, _IsMustNotice) ->
    Player#player.pid ! update_ref_43099,
    Key = "notice_list",
    case get(Key) of
        undefined ->
            put(Key, ActIdList);
        ActIdListTmp ->
            put(Key, util:list_unique(ActIdList ++ ActIdListTmp))
    end.

%% 每隔1min处理活动动态红点
timer_min_notice(_Player, Sce) ->
    case Sce rem 60 == 0 of
        false ->
            ok;
        true ->
            get_notice(_Player, [12, 33, 35, 36, 38, 40, 46, 96, 98, 105, 110, 107, 112, 114, 116, 117, 119, 122, 124, 129, 130, 137, 138, 139, 140, 142, 147, 150, 151, 158, 164, 178, 179, 191, 196], true),
            ok
    end.

%%定时处理红点通知
timer_notice(Player) ->
    Key = "notice_list",
    case get(Key) of
        undefined ->
            skip;
        ActIdList ->
            erase(Key),
            do_get_notice(Player, ActIdList, true)
    end.

%% 调试问题用
gm_get_notice(Player, ActIdList, IsMustNotice) ->
    StateList = do_get_notice1(Player, ActIdList, IsMustNotice),
    io:format("Player#player.key:~p ~nStateList:~p~n", [Player#player.key, StateList]),
    case StateList == [] of
        false ->
            {ok, Bin} = pt_430:write(43099, {StateList}),
            if
                Player#player.sid == [] ->
                    server_send:send_to_key(Player#player.key, Bin);
                true ->
                    server_send:send_to_sid(Player#player.sid, Bin)
            end;
        true ->
            skip
    end,
    ok.

do_get_notice(Player, ActIdList, IsMustNotice) ->
    StateList = do_get_notice1(Player, ActIdList, IsMustNotice),
    ?IF_ELSE(ActIdList == [123], ?DEBUG("Player#player.key:~p StateList:~p~n", [Player#player.key, StateList]), skip),

    case StateList == [] of
        false ->
            {ok, Bin} = pt_430:write(43099, {StateList}),
            if
                Player#player.sid == [] ->
                    server_send:send_to_key(Player#player.key, Bin);
                true ->
                    server_send:send_to_sid(Player#player.sid, Bin)
            end;
        true ->
            skip
    end,
    ok.

do_get_notice1(Player, ActIdList, IsMustNotice) ->
    F = fun(ActId) ->
        StateRes =
            case ActId of
%%                 1 -> catch first_charge:get_state();
%%                 2 -> catch act_rank:get_state();
%%                 3 -> catch daily_charge:get_state();
                4 -> catch acc_charge:get_state(Player);
                5 -> catch acc_consume:get_state(Player);
%%                 6 -> catch one_charge:get_state(Player);
%%                 7 -> catch new_daily_charge:get_state(Player);
%%                 8 -> catch new_one_charge:get_state(Player);
%%                 9 -> catch act_rank_goal:get_state(Player);
%%                 10 -> catch exchange:get_state(Player);
%%                 11 -> catch act_rank:get_buy_state();
                12 -> catch online_time_gift:get_state(Player);
%%                 13 -> catch daily_acc_charge:get_state(Player);
%%                 14 -> catch lim_shop:get_state();
                15 -> 0;
%%                 16 -> catch acc_charge_turntable:get_state(Player);
%%                 17 -> catch daily_fir_charge_return:get_state(Player);
%%                 18 -> catch acc_charge_gift:get_state(Player);
%%                 19 -> catch goods_exchange:get_state(Player);
%%                 20 -> catch role_d_acc_charge:get_state(Player);
%%                 21 -> catch con_charge:get_state(Player);
%%                 22 -> catch open_egg:get_state(Player);
%%                 23 -> catch merge_sign_in:get_state(Player);
%%                 24 -> catch charge_mul:get_state(Player);
                25 -> catch guild_rank:get_state(Player);
%%                 26 -> catch target_act:get_state(Player);
                27 -> catch ?IF_ELSE(config:get_merge_days() > 0, 0, -1);
%%                 28 -> catch act_content:get_state();
%%                 29 -> catch monopoly:get_state(Player);
%%                 30 -> catch vip_gift:get_state(Player);
                31 -> catch treasure_hourse:get_state(Player);
                32 -> catch hqg_daily_charge:get_state(Player);
                33 -> catch lists:max([open_act_jh_rank:get_state(Player),
                    open_act_up_target:get_state(Player),
                    open_act_up_target2:get_state(Player),
                    open_act_up_target3:get_state(Player),
                    open_act_group_charge:get_state(Player),
                    open_act_acc_charge:get_state(Player),
                    open_act_all_target:get_state(Player),
                    open_act_all_rank:get_state(Player),
                    open_act_back_buy:get_state(Player),
                    open_act_other_charge:get_state(Player),
                    open_act_super_charge:get_state(Player),
                    act_consume_rebate:get_state(Player)
                ]);
                34 -> catch
                    lists:max([
                        act_invest:get_state(Player),
                        act_lv_back:get_state(Player),
                        act_exp_dungeon:get_state(Player)
                    ]);
                35 -> catch uplv_box:get_state(Player);
                36 -> catch act_map:get_state(Player);
                37 -> catch limit_buy:get_state(Player);
                38 -> catch fuwen_map:get_state(Player);
                39 -> catch login_online:get_state(Player);
                40 -> catch new_exchange:get_state(Player);
                41 -> catch act_equip_sell:get_state(Player);
                42 -> catch act_convoy:get_state(Player);
                43 -> catch acc_charge_d:get_state(Player);
                44 -> catch consume_back_charge:get_state(Player);
                45 -> catch xj_map:get_state(Player);
                46 -> catch lists:max([
                    merge_act_up_target:get_state(Player),
                    merge_act_up_target2:get_state(Player),
                    merge_act_up_target3:get_state(Player),
                    merge_act_group_charge:get_state(Player),
                    merge_act_acc_charge:get_state(Player),
                    merge_exchange:get_state(Player),
                    merge_act_back_buy:get_state(Player),
                    merge_day7login:get_state(Player),
                    merge_act_acc_consume:get_state(Player)
                ]);
                52 -> catch day7login:get_state(Player);
                53 -> catch lv_gift:get_state(Player);
                54 -> catch sign_in:get_state(Player);
                56 -> catch task_cycle:get_state();
                57 -> catch guild_war_util:get_state(Player);
                59 -> catch task_convoy:get_notice_state(Player);
                60 -> catch task_cycle:get_notice_state();
                63 -> catch dungeon_material:get_notice_state(50002);
                64 -> catch dungeon_material:get_notice_state(50003);
                65 -> catch dungeon_material:get_notice_state(50001);
                66 -> catch dungeon_material:get_notice_state(50004);
                70 -> catch res_gift:get_notice_state(Player);
                72 -> catch taobao:get_notice_state(Player);
                73 -> catch mail:check_mail_state();
                74 -> catch dungeon_material:get_notice_state(50006);
                75 -> catch dungeon_material:get_notice_state(50005);
                77 -> catch vip:get_vip_gift_state(Player);
                84 -> catch wish_tree_util:get_notice_state(Player);
                85 -> catch field_boss:get_notice_state();
                86 -> catch cross_eliminate:get_notice_state();
                89 -> catch findback_exp:get_state();
                90 -> catch findback_src:get_state(Player);
                91 -> catch sword_pool:get_notice_state();
                92 -> catch guild_hy:get_notice_player(Player);
                93 -> catch cross_elite:get_notice_player(Player);
                94 -> catch
                    lists:max([
                        fashion:get_notice_player(Player),
                        bubble:get_notice_player(Player),
                        designation:get_notice_player(Player),
                        head:get_notice_player(Player),
                        decoration:get_notice_player(Player),
                        mount:check_upgrade_star(),
                        light_weapon:check_upgrade_star(),
                        wing:check_upgrade_star()
                    ]);
                95 -> catch mon_photo:get_notice_player(Player);
                96 -> catch
                    lists:max([
                        online_time_gift:get_notice_player(Player),
                        sign_in:get_state(Player),
                        findback_exp:get_state(),
                        findback_src:get_state(Player)
                    ]);
                97 -> catch dungeon_material:check_dungeon_state(Player);
                98 -> catch dungeon_exp:get_notice_player(Player);
                99 -> catch dungeon_daily:get_notice_player(Player, 1);
                100 -> catch dungeon_god_weapon:get_notice_player(Player);
                101 -> catch dungeon_daily:get_notice_player(Player, 3);
                102 -> catch dungeon_fuwen_tower:get_notice_player(Player);
                103 -> catch dungeon_vip:get_notice_player(Player);
                104 -> catch cross_dungeon_util:get_notice_player(Player);
                105 -> catch arena:get_notice_player(Player);
                106 -> catch arena_score:get_notice_player(Player);
                107 -> catch cross_arena:get_notice_player(Player);
                108 -> catch achieve:get_notice_player(Player);
                109 -> catch god_weapon:get_notice_player(Player);
                110 -> catch
                    lists:max([
                        pet:check_skill_state(),
                        pet_star:check_star_state(Player),
                        pet_stage:check_state_state(Player),
                        pet_pic:check_pic_state(),
                        pet_assist:check_state(Player),
                        pet:check_cbp_state(),
                        fairy_soul:check_state(Player)
                    ]);
                111 -> catch act_draw_turntable:get_state(Player);
                112 -> catch cross_flower:get_state();
                113 -> catch hundred_return:get_state(Player);
                114 -> catch collect_exchange:get_state();
                115 -> catch dungeon_daily:get_notice_player(Player, 4);
                116 -> catch stone_ident:get_state();
                117 -> catch guild_manor:get_notice_player(Player);
                118 -> catch fuwen:get_notice_player(Player);
                119 -> catch
                    lists:max([
                        login_online:get_state(Player),
                        acc_consume:get_state(Player),
                        new_exchange:get_state(Player)
                    ]);
                120 -> catch min(0,
                    lists:max([
                        consume_rank:get_state(Player),
                        recharge_rank:get_state(Player),
                        cross_consume_rank:get_state(),
                        cross_recharge_rank:get_state(),
                        area_consume_rank:get_state(),
                        area_recharge_rank:get_state()
                    ]));
                121 -> catch dungeon_guard:get_state();
                122 -> catch flower_rank:get_state();
                123 -> catch act_con_charge:get_state(Player);
                124 -> catch gold_silver_tower:get_state();
                125 -> catch cross_fruit:get_state();
                126 -> catch cross_eliminate:get_state();
                127 -> catch goods:get_wing_dan_notice(Player);
                128 -> catch goods:get_mount_dan_notice(Player);
                129 -> catch red_goods_exchange:get_state();
                130 -> catch debris_exchange:get_state();
                131 -> catch marry_rank:get_state(Player);
                132 -> catch act_buy_money:get_state(Player);
                133 -> catch marry_room:get_notice_state(Player);
                134 -> catch dungeon_marry:get_notice_state(Player);
                135 -> catch marry_gift:get_notice_state(Player);
                136 -> catch marry_cruise:get_notice_state(Player);
                137 -> catch marry_heart:get_state(Player);
                138 -> catch marry_ring:get_state(Player);
                139 -> catch marry_designation:get_state(Player);
                140 -> catch act_wealth_cat:get_state(Player);
                141 -> catch cross_dark_bribe:check_get_award_state(Player);
                142 -> catch act_hi_fan_tian:get_state(Player);
                143 -> catch cross_war:get_state(Player);
                144 -> catch free_gift:get_state(Player);
                145 ->
                        catch
                        lists:max([
                            baby:check_skill_state(),
                            baby:check_update_step_state(Player),
                            baby:check_update_lv_state(),
                            baby:check_pic_active_state(),
                            baby:check_kill_award_state(),
                            baby:check_sign_up_state(Player),
                            baby:check_equip_state(Player)
                        ]);
                146 -> catch res_gift:get_state(Player);
                147 -> catch task_change_career:get_state(Player);
                148 -> catch act_new_wealth_cat:get_state(Player);
                149 -> catch cross_war:get_notice_state(Player);
                150 -> catch act_lucky_turn:get_state(Player);
                151 -> catch act_throw_egg:get_state(Player);
                152 -> catch act_one_gold_buy:get_state(Player);
                155 -> catch mystery_shop:get_notice_state(Player);
                156 -> catch limit_time_gift:get_notice_state(Player);
                157 -> catch act_welkin_hunt:get_notice_state(Player);
                158 -> catch act_local_lucky_turn:get_state(Player);
                159 -> catch act_small_charge:get_state(Player);
                160 -> catch lists:max([
                    dvip:check_get_gift_state(Player),
                    dvip:check_diamond_exchange_state(Player)
                ]);
                161 -> catch lists:max([
                    double_gold:get_state(),
                    festival_exchange:get_state(Player),
                    act_daily_task:get_state(Player),
                    festival_acc_charge:get_state(Player),
                    act_throw_fruit:get_state(Player),
                    online_reward:get_state(Player),
                    festival_login_gift:get_state(),
                    recharge_inf:get_state(Player),
                    festival_back_buy:get_state(Player),
                    act_flip_card:get_state(Player),
                    festival_red_gift:get_state(),
                    festival_challenge_cs:get_state(Player),
                    act_festive_boss:get_state(Player)
                ]);
                162 -> catch double_gold:get_state_all();
                163 ->
                        catch dungeon_equip:get_state(Player#player.lv);
                164 -> catch fashion_suit:get_state();
                166 -> catch new_double_gold:get_state_all();
                167 -> catch act_mystery_tree:get_notice_state(Player);
                168 -> catch cs_charge_d:get_notice_state(Player);
                169 -> catch act_jbp:get_notice_state(Player);
                170 -> catch act_consume_score:get_notice_state(Player);
                171 -> catch act_limit_xian:get_notice_state(Player);
                172 -> catch buy_red_equip:get_notice_state(Player);
                173 -> catch marry_tree:get_notice(Player);
                174 -> catch cross_dungeon_guard_util:get_milestone_state();
                175 -> catch small_charge_d:get_notice_state(Player);
                176 -> catch act_limit_pet:get_notice_state(Player);
                177 -> catch return_act:get_notice_state(Player);
                178 -> catch guild_box:get_state(Player);
                179 -> catch cross_1vn_util:get_shop_notice_state(Player);
                180 -> catch dungeon_godness:get_notice_state(Player);
                181 -> catch act_call_godness:get_state(Player);
                182 -> catch act_godness_limit:get_notice_state(Player);
                183 -> catch act_wishing_well:get_state(Player);
                184 -> catch cross_act_wishing_well:get_state(Player);
                186 -> catch guild_fight:get_state(Player);
                187 -> catch guild_fight:get_act_state(Player);
                188 -> 1;
                189 -> 1;
                190 -> catch act_cbp_rank:get_state(Player);
                191 -> catch act_meet_limit:get_state(Player);
                192 -> catch lists:max([dungeon_element:get_state(Player), dungeon_jiandao:get_state(Player)]);
                193 -> catch jiandao_map:get_state(Player);
%%                 194 -> catch fuwen_map_discount:get_state(Player);
%%                 195 -> catch jiandao_map_discount:get_state(Player);
                196 -> catch cross_mining_util:get_state(Player);
                197 -> catch new_free_gift:get_state(Player);

                _ -> 0
            end,


        {ActState, ActArgsList} =
            case StateRes of
                ok ->
                    {0, pack_act_state([])};
                cross_war_close -> {-1, pack_act_state([{time, 0}])};
                {State, Args} when is_integer(State) ->
                    {State, pack_act_state(Args)};
                State when is_integer(State) ->
                    {State, pack_act_state([])};
                _Err ->
                    ?ERR("ActId:~p Err:~p", [ActId, _Err]),
                    {0, pack_act_state([])}
            end,
        case IsMustNotice orelse ActState == 1 of
            true ->
                case lists:member(ActId, [105, 149, 178, 196]) of
                    true -> %% 处理掉跨服，或者公共进程内的推送
                        [];
                    false ->
                        [[ActId, ActState | ActArgsList]]
                end;
            false ->
                []
        end
        end,
    lists:flatmap(F, ActIdList).


%% 通知客户端红点状态
send_act_state(Player, ActStateList) ->
%%     ?DEBUG("send_act_state ActStateList:~p~n", [ActStateList]),
    {ok, Bin} = pt_430:write(43099, ActStateList),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

pack_act_state([]) ->
    [0, 0, 0];
pack_act_state(Args) ->
    L = [time, icon, show_pos],
    F = fun(Type, AccList) ->
        case lists:keyfind(Type, 1, Args) of
            false -> AccList ++ [0];
            {_, Val} -> AccList ++ [Val]
        end
        end,
    lists:foldl(F, [], L).

get_mutex_act_list() ->
    [
        %[data_acc_charge_turntable, data_open_egg]
    ].

get_mutex_act(Mod) ->
    ActList = get_mutex_act_list(),
    get_mutex_act_1(ActList, Mod).
get_mutex_act_1([], _Mod) -> [];
get_mutex_act_1([[Mod, Mod1] | _Tail], Mod) -> [Mod, Mod1];
get_mutex_act_1([[Mod1, Mod] | _Tail], Mod) -> [Mod1, Mod];
get_mutex_act_1([_ | Tail], Mod) ->
    get_mutex_act_1(Tail, Mod).

%%获取有效活动列表 考虑互斥活动
get_work_list_mutex(Mod) ->
    ActList = get_work_list(Mod),
    case ActList of
        [] -> [];
        [Base | _] ->
            case get_mutex_act(Mod) of
                [] -> get_work_list(Mod);
                [Mod1, Mod2] ->
                    case Mod1 == Mod of
                        true ->
                            MutexMod = Mod2,
                            IsFirst = 1;
                        false ->
                            MutexMod = Mod1,
                            IsFirst = 0
                    end,
                    MutexActList = get_work_list(MutexMod),
                    case MutexActList of
                        [] -> ActList;
                        [MutexBase | _] ->
                            OpenInfo = erlang:element(2, Base),
                            MutexOpenInfo = erlang:element(2, MutexBase),
                            if
                                OpenInfo#open_info.priority == 1 -> %%最高优先
                                    ActList;
                                MutexOpenInfo#open_info.priority == 1 -> %%互斥活动最高优先
                                    [];
                                OpenInfo#open_info.open_day > 0 ->
                                    case MutexOpenInfo#open_info.open_day > 0 of
                                        true ->
                                            case IsFirst == 1 of
                                                true -> ActList;
                                                false -> []
                                            end;
                                        false ->
                                            ActList
                                    end;
                                MutexOpenInfo#open_info.open_day > 0 ->
                                    [];
                                OpenInfo#open_info.start_time > 0 andalso IsFirst == 1 ->
                                    ActList;
                                OpenInfo#open_info.start_time > 0 andalso IsFirst == 0 ->
                                    [];
                                true ->
                                    ActList
                            end
                    end
            end
    end.

%%获取有效的活动列表
%%返回#base_xxxx 列表
get_work_list(Mod) ->
    AllIds = f(Mod, get_all, []),
    Now = util:unixtime(),
    OpenDay = config:get_open_days(),
    MergeDay = config:get_merge_days(),
    Sn = config:get_act_server_num(),
    get_work_list_helper(lists:sort(AllIds), {[], [], [], []}, [Mod, Sn, OpenDay, Now, MergeDay]).
%%活动开启顺序：合服活动 -> 优先活动->开服活动->全服活动
get_work_list_helper([], {MergeServerList, OpenServerList, GlobalTimeList, PriorityList}, _) ->
    MergeServerList ++ PriorityList ++ OpenServerList ++ GlobalTimeList;
get_work_list_helper([Id | Tail], {MergeServerList, OpenServerList, GlobalTimeList, PriorityList}, Args) ->
    [Mod, Sn, OpenDay, Time, MergeDay] = Args,
    Base = activity:f(Mod, get, [Id]),
    if
        Base == [] ->
            get_work_list_helper(Tail, {MergeServerList, OpenServerList, GlobalTimeList, PriorityList}, Args);
        true ->
            OpenInfo = erlang:element(2, Base),
            case is_work(OpenInfo, [Sn, OpenDay, Time, MergeDay]) of
                false ->
                    get_work_list_helper(Tail, {MergeServerList, OpenServerList, GlobalTimeList, PriorityList}, Args);
                {true, OpenTime} ->
                    NewAccList =
                        case OpenInfo#open_info.priority == 1 of
                            true -> %%是优先活动
                                {MergeServerList, OpenServerList, GlobalTimeList, PriorityList ++ [Base]};
                            false ->
                                case OpenTime of
                                    open_day -> %%开服活动
                                        {MergeServerList, OpenServerList ++ [Base], GlobalTimeList, PriorityList};
                                    global_time -> %%全服活动
                                        {MergeServerList, OpenServerList, GlobalTimeList ++ [Base], PriorityList};
                                    merge_day -> %%合服活动
                                        {MergeServerList ++ [Base], OpenServerList, GlobalTimeList, PriorityList}
                                end
                        end,
                    get_work_list_helper(Tail, NewAccList, Args)
            end
    end.

%%检查活动是否有效
is_work(OpenInfo, [Sn, OpenDay, Time, MergeDay]) ->
    case is_work_server(OpenInfo, Sn) of
        false ->
            false;
        true ->
            is_work_time(OpenInfo, OpenDay, Time, MergeDay)
    end.

%%检查活动是否在指定服开启
is_work_server(OpenInfo, Sn) ->
    #open_info{
        gp_id = Gplist,
        gs_id = Gslist,
        ignore_gs = IgnoreGslist
    } = OpenInfo,
    case lists:member(Sn, IgnoreGslist) of
        true -> false;
        false ->
            case check_work_gp(Sn, Gplist) of
                false ->
                    case check_work_gs(Sn, Gslist) of
                        true -> true;
                        false -> false
                    end;
                true ->
                    true
            end
    end.
check_work_gp(_Sn, []) -> false;
check_work_gp(Sn, [{Start, End} | Tail]) ->
    case Start =< Sn andalso Sn =< End of
        true -> true;
        false ->
            check_work_gp(Sn, Tail)
    end.
check_work_gs(Sn, Gslist) ->
    lists:member(Sn, Gslist).

%%检查活动时间
is_work_time(OpenInfo, NowOpenDay, NowTime, MergeDay) ->
    #open_info{
        open_day = OpenDay,
        end_day = EndDay,
        start_time = StartTime1,
        end_time = EndTime1,
        merge_st_day = MergeStDay,
        merge_et_day = MergeEtDay,
        merge_times_list = MergeTimesList,
        after_open_day = AfterOpenDay,
        limit_open_day = LimitOpenDay,
        limit_end_day = LimitEndDay
    } = OpenInfo,
    StartTime = get_transform_time(StartTime1),
    EndTime = get_transform_time(EndTime1),

    if
        AfterOpenDay > 0 andalso AfterOpenDay > NowOpenDay -> false;
        MergeDay > 0 andalso MergeStDay =< MergeDay andalso MergeEtDay >= MergeDay ->
%%            {true, merge_day};
            case MergeTimesList of
                [] ->
                    {true, merge_day};
                _ ->
                    case lists:member(config:get_merge_times(), MergeTimesList) of
                        false ->
                            false;
                        true ->
                            {true, merge_day}
                    end
            end;
        OpenDay > 0 andalso EndDay > 0 andalso NowOpenDay >= OpenDay andalso NowOpenDay =< EndDay -> {true, open_day};
        StartTime > 0 andalso EndTime > 0 andalso NowTime >= StartTime andalso NowTime =< EndTime ->
            case LimitOpenDay == 0 andalso LimitEndDay == 0 of
                true -> {true, global_time}; %% 支持现有的
                false ->
                    if
                    %% 限制天内开启
                        LimitOpenDay =< NowOpenDay andalso NowOpenDay =< LimitEndDay -> {true, global_time};
                    %% 限制天外，但是在限制天内开启过
                        LimitEndDay =< NowOpenDay andalso NowTime - StartTime > (NowOpenDay - LimitOpenDay) * ?ONE_DAY_SECONDS ->
                            {true, global_time};
                        true ->
                            false
                    end
            end;
        true -> false
    end.

%%apply
f(M, F, A) ->
    case catch apply(M, F, A) of
        {'EXIT', _} ->
%%             ?ERR("activity module err ~p~n",[{M,F,A}]),
            [];
        Info ->
            Info
    end.

%%获取活动剩余时间
get_leave_time(Mod) ->
    case get_work_list(Mod) of
        [] -> -1;
        [Base | _] ->
            calc_act_leave_time(erlang:element(2, Base))
    end.

%%计算活动剩余时间
calc_act_leave_time(OpenInfo) ->
    #open_info{
        open_day = OpenDay,
        end_day = EndDay,
        start_time = StartTime1,
        end_time = EndTime1,
        merge_st_day = MergeStDay,
        merge_et_day = MergeEtDay
    } = OpenInfo,
    StartTime = get_transform_time(StartTime1),
    EndTime = get_transform_time(EndTime1),
    SerOpenDay = config:get_open_days(),
    MergeDay = config:get_merge_days(),
    Now = util:unixtime(),
    Today = util:unixdate(),
    if
        MergeDay > 0 andalso MergeStDay =< MergeDay andalso MergeEtDay >= MergeDay ->
            (MergeEtDay - MergeDay + 1) * ?ONE_DAY_SECONDS - (Now - Today);
        OpenDay =< SerOpenDay andalso EndDay >= SerOpenDay andalso SerOpenDay > 0 ->
            (EndDay - SerOpenDay + 1) * ?ONE_DAY_SECONDS - (Now - Today);
        StartTime =< Now andalso EndTime >= Now ->
            EndTime - Now;
        true ->
            0
    end.


%%获取活动开始天数
get_start_day(Mod) ->
    case get_work_list(Mod) of
        [] -> -1;
        [Base | _] ->
            calc_act_start_day(erlang:element(2, Base))
    end.

%%计算活动开始天数
calc_act_start_day(OpenInfo) ->
    #open_info{
        open_day = OpenDay,
        end_day = EndDay,
        start_time = StartTime1,
        end_time = EndTime1,
        merge_st_day = MergeStDay,
        merge_et_day = MergeEtDay
    } = OpenInfo,
    StartTime = get_transform_time(StartTime1),
    EndTime = get_transform_time(EndTime1),
    SerOpenDay = config:get_open_days(),
    MergeDay = config:get_merge_days(),
    Now = util:unixtime(),
    if
        MergeDay > 0 andalso MergeStDay =< MergeDay andalso MergeEtDay >= MergeDay ->
            MergeDay - MergeStDay + 1;
        OpenDay =< SerOpenDay andalso EndDay >= SerOpenDay andalso SerOpenDay > 0 ->
            SerOpenDay - OpenDay + 1;
        StartTime =< Now andalso EndTime >= Now ->
            (Now - StartTime) div ?ONE_DAY_SECONDS + 1;
        true ->
            0
    end.

%%获取活动描述信息
get_act_info(Mod) ->
    case get_work_list(Mod) of
        [] -> [];
        [Base | _] ->
            case catch erlang:element(3, Base) of
                ActInfo when is_record(ActInfo, act_info) ->
                    case ActInfo#act_info.act_name == <<"">> orelse ActInfo#act_info.act_name == "" of
                        true -> [];
                        false -> ActInfo
                    end;
                _ ->
                    []
            end
    end.

%%检查功能活动类状态,PS 护送,战场
check_activity_state(Player) ->
    Now = util:unixtime(),
    %%护送
    convoy_proc:check_convoy_state(Player#player.sid),
    %%仙盟战
%%    ?CAST(guild_war_proc:get_server_pid(), {check_state, Player#player.sid, Now}),
    ?CAST(manor_war_proc:get_server_pid(), {check_state, Player#player.sid, Now}),
    %%魔物入侵
%%    ?CAST(invade_proc:get_server_pid(), {check_state, Player#player.sid, Now}),
    %%神谕恩泽
    ?CAST(grace_proc:get_server_pid(), {check_state, Player#player.sid, Now}),
    %%战场
%%    battlefield_rpc:handle(64001, Player, {}),
    %%巅峰塔
    cross_battlefield_rpc:handle(55001, Player, {}),
    %%跨服boss
%%    cross_boss_rpc:handle(57001, Player, {}),
%%    1v1
    cross_elite_rpc:handle(58001, Player, {}),
    %%猎场
%%    cross_hunt_rpc:handle(62001, Player, {}),
    %%城战
%%    cross_war_rpc:handle(60101, Player, {}),
    %%全民夺宝
%%    panic_buying_rpc:handle(15301,Player,{})
    %%王城守卫
    dungeon_rpc:handle(12220, Player, {}),
    %%乱斗
    cross_scuffle_rpc:handle(58401, Player, {}),
    %%乱斗精英赛
    cross_scuffle_elite_rpc:handle(58501, Player, {}),
    %%巡游状态
    marry_rpc:handle(28812, Player, {}),
    %%
    party_rpc:handle(28701, Player, {}),
    guild_answer_rpc:handle(40501, Player, {}),
    ok.

activity_reset(Type) ->
    NowTime = util:unixtime(),
    ?IF_ELSE(Type == 0 orelse Type == 2, catch guild_war_proc:get_server_pid() ! {reset, NowTime}, ok),
    ?IF_ELSE(Type == 0 orelse Type == 3, catch convoy_proc:reset(NowTime), ok),
    ?IF_ELSE(Type == 0 orelse Type == 4, catch invade_proc:get_server_pid() ! {reset, NowTime}, ok),
    ?IF_ELSE(Type == 0 orelse Type == 5, catch cross_hunt_proc:get_server_pid() ! {reset, NowTime}, ok),
    ?IF_ELSE(Type == 0 orelse Type == 6, catch grace_proc:get_server_pid() ! {reset, NowTime}, ok),
    ?IF_ELSE(Type == 0 orelse Type == 7, catch battlefield_proc:get_server_pid() ! {reset, NowTime}, ok),
    ok.

is_merge_act(Mod) ->
    case get_work_list(Mod) of
        [] -> false;
        [Base | _] ->
            OpenInfo = erlang:element(2, Base),
            #open_info{
                merge_st_day = MergeStDay,
                merge_et_day = MergeEtDay
            } = OpenInfo,
            MergeDay = config:get_merge_days(),
            case MergeStDay > 0 andalso MergeDay >= MergeStDay andalso MergeEtDay >= MergeDay of
                true -> true;
                false -> false
            end
    end.

get_base_state(Info) ->
    get_base_state(icon, Info, []).
get_base_state(icon, Info, AccList) ->
    L =
        case Info#act_info.icon > 0 of
            true ->
                [{icon, Info#act_info.icon}];
            false ->
                []
        end,
    get_base_state(show_pos, Info, AccList ++ L);
get_base_state(show_pos, Info, AccList) ->
    L =
        case Info#act_info.show_pos_day > 0 of
            true ->
                OpenDay = config:get_open_days(),
                ShowPos = ?IF_ELSE(OpenDay > Info#act_info.show_pos_day, 1, 0),
                [{show_pos, ShowPos}];
            false ->
                []
        end,
    get_base_state(finish, Info, AccList ++ L);
get_base_state(_, _Info, L) -> L.

get_transform_time(LocalTime) ->
    Key = {local_time, LocalTime},
    case get(Key) of
        undefined ->
            case ets:lookup(?ETS_ACT_TIME, LocalTime) of
                [] ->
                    Time = ?IF_ELSE(LocalTime > 0, util:localtime2unixtime(LocalTime), 0),
                    ets:insert(?ETS_ACT_TIME, #ets_act_time{local_time = LocalTime, time = Time}),
                    put(Key, Time),
                    Time;
                [ActTime] ->
                    put(Key, ActTime#ets_act_time.time),
                    ActTime#ets_act_time.time
            end;
        Time -> Time
    end.


set_timer_open_state(SecType, State) ->
    ?GLOBAL_DATA_RAM:set({?GLOBAL_RAM_TIMER_CAMP_IS_OPEN, SecType}, State).

get_timer_state(SecType) ->
    ?GLOBAL_DATA_RAM:get({?GLOBAL_RAM_TIMER_CAMP_IS_OPEN, SecType}, false).

check_timer_state(SecType, State) ->
    OldState = get_timer_state(SecType),
    OldState =:= State.


get_work_list_by_time_all(CheckTime) ->
    ModList = data_activity_all:get_all(),
    F = fun(Id) ->
        case get_work_list_by_time(data_activity_all:get(Id), CheckTime) of
            [] -> [];
            [{ActivityType, Base} | _] ->
                {Id0, Mod0, Desc} = data_activity_all:get_info(Id),
                {Y, M, D, H, M1, S} =
                    case Mod0:module_info(compile) of
                        L when is_list(L) ->
                            case lists:keyfind(time, 1, L) of
                                {time, Time} -> Time;
                                false -> {0, 0, 0, 0, 0, 0}
                            end;
                        _ -> {0, 0, 0, 0, 0, 0}
                    end,
                ActId = if
                            Id0 == 16 orelse Id0 == 116 -> erlang:element(5, Base);
                            Id0 == 53 -> erlang:element(6, Base);
                            true -> erlang:element(4, Base)
                        end,
                UpdateTime = util:localtime2unixtime({{Y, M, D}, {H, M1, S}}),
                Result = {obj, [{type, Id0}, {activity_type, ActivityType}, {mod, Mod0}, {desc, Desc}, {actid, ActId}, {updatetime, UpdateTime}, {checktime, CheckTime}, {base, ?T(util:term_to_string(Base))}]},
                T = lists:flatten(rfc4627:encode(Result)),
                [T]
        end
        end,
    lists:flatmap(F, ModList).

get_work_list_by_time([], _CheckTime) -> [];
get_work_list_by_time(Mod, CheckTime) ->
    AllIds = f(Mod, get_all, []),
    TodayUnixdate = util:unixdate(), %% 今日凌晨
    CheckUnixdate = util:unixdate(CheckTime),
    DiffDay = (CheckUnixdate - TodayUnixdate) div ?ONE_DAY_SECONDS,
    OpenDay = config:get_open_days(),
    MergeDay = config:get_merge_days(),
    Sn = config:get_act_server_num(),
    get_work_list_helper1(lists:sort(AllIds), {[], [], [], []}, [Mod, Sn, max(1, OpenDay + DiffDay), CheckTime, max(1, MergeDay + DiffDay)]).


get_work_list_helper1([], {MergeServerList, OpenServerList, GlobalTimeList, PriorityList}, _) ->
    MergeServerList ++ PriorityList ++ OpenServerList ++ GlobalTimeList;
get_work_list_helper1([Id | Tail], {MergeServerList, OpenServerList, GlobalTimeList, PriorityList}, Args) ->
    [Mod, Sn, OpenDay, Time, MergeDay] = Args,
    Base = activity:f(Mod, get, [Id]),
    if
        Base == [] ->
            get_work_list_helper1(Tail, {MergeServerList, OpenServerList, GlobalTimeList, PriorityList}, Args);
        true ->
            OpenInfo = erlang:element(2, Base),
            case is_work(OpenInfo, [Sn, OpenDay, Time, MergeDay]) of
                false ->
                    get_work_list_helper1(Tail, {MergeServerList, OpenServerList, GlobalTimeList, PriorityList}, Args);
                {true, OpenTime} ->
                    NewAccList =
                        case OpenInfo#open_info.priority == 1 of
                            true -> %%是优先活动
                                {MergeServerList, OpenServerList, GlobalTimeList, PriorityList ++ [{0, Base}]};
                            false ->
                                case OpenTime of
                                    open_day -> %%开服活动
                                        {MergeServerList, OpenServerList ++ [{1, Base}], GlobalTimeList, PriorityList};
                                    global_time -> %%全服活动
                                        {MergeServerList, OpenServerList, GlobalTimeList ++ [{2, Base}], PriorityList};
                                    merge_day -> %%合服活动
                                        {MergeServerList ++ [{3, Base}], OpenServerList, GlobalTimeList, PriorityList}
                                end
                        end,
                    get_work_list_helper1(Tail, NewAccList, Args)
            end
    end.
