%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 九月 2017 20:50
%%%-------------------------------------------------------------------
-module(cron_activity).
-author("hxming").

-include("common.hrl").
-include("activity.hrl").
%% API
-export([
    refresh_cron_activity/0,
    cron_activity/0
]).

refresh_cron_activity() ->
%%    F = fun(Node) ->
%%        case center:apply_call(Node, cron_activity, cron_activity, []) of
%%            [] -> [];
%%            [Sn, String] ->
%%                ApiUrl = "http://localhost",
%%%%                config:get_api_url(),
%%                ?DEBUG("String ~p~n", [String]),
%%                Url = lists:concat([ApiUrl, "/api/rpc/server_activity.php"]),
%%                U0 = io_lib:format("?sn=~p&data=~w", [Sn, String]),
%%                U = lists:concat([Url, U0]),
%%                Ret = httpc:request(U),
%%                ?DEBUG("Ret ~p~n", [Ret]),
%%                ok
%%        end
%%        end,
%%    lists:foreach(F, center:get_nodes()),
    ok.




cron_activity() ->
    F = fun({Id, Mod, _Desc}, L) ->
            case activity:get_work_list(Mod) of
                [] -> L;
                [Base | _] ->
                    LeftTime =
                        case catch calc_time(Mod, Base) of
                            T when is_integer(T) -> T;
                            _ -> 0
                        end,
                    [{Id, Mod, LeftTime} | L]
            end
        end,
%%     第二个参数就是[]就是定义的原始的数据结构,F函数的L就是最开始的[]符号
    ActList = lists:foldl(F, [], all_act_mod()),
    OldActList = cache:get(cron_activity),
    case ActList == OldActList of
        true -> ok;
        false ->
%%    ApiUrl = "http://localhost",
            ApiUrl = config:get_api_url(),

            Url = lists:concat([ApiUrl, "/server_activity.php"]),
            PostData = io_lib:format("sn=~p&data=~s", [config:get_server_num(), util:term_to_string(ActList)]),
            PostData2 = unicode:characters_to_list(PostData, unicode),
            httpc:request(post, {Url, [], "application/x-www-form-urlencoded", PostData2}, [{timeout,2000}], []),
            cache:set(cron_activity,ActList,?ONE_DAY_SECONDS),
            ok
    end.


%%activity:calc_act_leave_time(Base#base_hundred_return.open_info)
calc_time(Mod, Base) ->
    case Mod of
        data_hqg_daily_charge ->
            activity:calc_act_leave_time(Base#base_hqg_daily_charge.open_info);
        data_act_map ->
            activity:calc_act_leave_time(Base#base_act_map.open_info);
        data_uplv_box ->
            activity:calc_act_leave_time(Base#base_uplv_box.open_info);
        data_draw_turntable ->
            activity:calc_act_leave_time(Base#base_draw_turntable.open_info);
        data_limit_buy ->
            activity:calc_act_leave_time(Base#base_limit_buy.open_info);
        data_cross_flower ->
            activity:calc_act_leave_time(Base#base_act_cross_flower.open_info);
        data_fuwen_map ->
            activity:calc_act_leave_time(Base#base_fuwen_map.open_info);
        data_hundred_return ->
            activity:calc_act_leave_time(Base#base_hundred_return.open_info);
        data_login_online ->
            activity:calc_act_leave_time(Base#base_login_online.open_info);
        data_new_exchange ->
            activity:calc_act_leave_time(Base#base_new_exchange.open_info);
        data_act_equip_sell ->
            activity:calc_act_leave_time(Base#base_act_equip_sell.open_info);
        data_stone_ident ->
            activity:calc_act_leave_time(Base#base_act_stone_ident.open_info);
        data_collect_exchange ->
            activity:calc_act_leave_time(Base#base_act_collect_exchange.open_info);
        data_act_convoy ->
            activity:calc_act_leave_time(Base#base_act_convoy.open_info);
        data_acc_charge_d ->
            activity:calc_act_leave_time(Base#base_acc_charge_d.open_info);
        data_act_consume_back_charge ->
            activity:calc_act_leave_time(Base#base_act_consume_back_charge.open_info);
        data_consume_rank ->
            activity:calc_act_leave_time(Base#base_consume_rank.open_info);
        data_recharge_rank ->
            activity:calc_act_leave_time(Base#base_recharge_rank.open_info);
        data_cross_consume_rank ->
            activity:calc_act_leave_time(Base#base_act_cross_consume_rank.open_info);
        data_cross_recharge_rank ->
            activity:calc_act_leave_time(Base#base_act_cross_recharge_rank.open_info);
        data_acc_charge ->
            activity:calc_act_leave_time(Base#base_acc_charge.open_info);
        data_xj_map ->
            activity:calc_act_leave_time(Base#base_xj_map.open_info);
        data_flower_rank ->
            activity:calc_act_leave_time(Base#base_act_flower_rank.open_info);
        data_act_con_charge ->
            activity:calc_act_leave_time(Base#base_con_charge.open_info);
        data_open_act_back_buy ->
            activity:calc_act_leave_time(Base#base_open_act_back_buy.open_info);
        data_open_up_target2 ->
            activity:calc_act_leave_time(Base#base_open_up_target.open_info);
        data_gold_silver_tower ->
            activity:calc_act_leave_time(Base#base_gold_silver_tower.open_info);
        data_red_goods_exchange ->
            activity:calc_act_leave_time(Base#base_red_goods_exchange.open_info);
        data_debris_exchange ->
            activity:calc_act_leave_time(Base#base_debris_exchange.open_info);
        data_marry_rank ->
            activity:calc_act_leave_time(Base#base_marry_rank.open_info);
        data_open_up_target3 ->
            activity:calc_act_leave_time(Base#base_open_up_target.open_info);
        data_merge_group_charge ->
            activity:calc_act_leave_time(Base#base_merge_group_charge.open_info);
        data_act_wealth_cat ->
            activity:calc_act_leave_time(Base#base_wealth_cat.open_info);
        data_merge_up_target ->
            activity:calc_act_leave_time(Base#base_merge_up_target.open_info);
        data_merge_up_target2 ->
            activity:calc_act_leave_time(Base#base_merge_up_target.open_info);
        data_merge_up_target3 ->
            activity:calc_act_leave_time(Base#base_merge_up_target.open_info);
        data_merge_acc_charge ->
            activity:calc_act_leave_time(Base#base_merge_acc_charge.open_info);
        data_merge_act_back_buy ->
            activity:calc_act_leave_time(Base#base_merge_act_back_buy.open_info);
        data_merge_guild_rank ->
            activity:calc_act_leave_time(Base#base_merge_act_guild_rank.open_info);
        data_merge_exchange ->
            activity:calc_act_leave_time(Base#base_merge_exchange.open_info);
        data_merge_day7login ->
            activity:calc_act_leave_time(Base#base_merge_day7.open_info);
        data_open_all_rank2 ->
            activity:calc_act_leave_time(Base#base_open_act_all_rank.open_info);
        data_open_all_rank3 ->
            activity:calc_act_leave_time(Base#base_open_act_all_rank.open_info);
        data_open_all_target2 ->
            activity:calc_act_leave_time(Base#base_open_all_target.open_info);
        data_open_all_target3 ->
            activity:calc_act_leave_time(Base#base_open_all_target.open_info);
        data_act_dungeon_double ->
            activity:calc_act_leave_time(Base#base_act_dungeon_double.open_info);
        data_act_xj_map_double ->
            activity:calc_act_leave_time(Base#base_act_xj_map_double.open_info);
        data_act_mon_drop ->
            activity:calc_act_leave_time(Base#base_act_mon_drop.open_info);
        data_act_hi_fan_tian ->
            activity:calc_act_leave_time(Base#base_hi_fan_tian.open_info);
        data_free_gift ->
            activity:calc_act_leave_time(Base#base_act_free_gift.open_info);
        data_act_new_wealth_cat ->
            activity:calc_act_leave_time(Base#base_new_wealth_cat.open_info);
        data_mystery_shop ->
            activity:calc_act_leave_time(Base#base_mystery_shop.open_info);
        data_act_throw_egg ->
            activity:calc_act_leave_time(Base#base_act_throw_egg.open_info);
        data_act_lucky_turn ->
            activity:calc_act_leave_time(Base#base_act_lucky_turn.open_info);
        data_limit_time_gift ->
            activity:calc_act_leave_time(Base#base_limit_time_gift.open_info);
        data_act_welkin_hunt ->
            activity:calc_act_leave_time(Base#base_act_welkin_hunt.open_info);
        data_act_local_lucky_turn ->
            activity:calc_act_leave_time(Base#base_act_lucky_turn.open_info);
        data_act_baby_equip_sex ->
            activity:calc_act_leave_time(Base#base_act_baby_equip_sex.open_info);
        data_act_small_charge ->
            activity:calc_act_leave_time(Base#base_act_small_charge.open_info);
        _ -> 0
    end.

all_act_mod() ->
    [
        {37, data_hqg_daily_charge, "花千骨每日充值"},
        {39, data_act_map, "迷宫寻宝"},
        {40, data_uplv_box, "进阶宝箱"},
        {41, data_draw_turntable, "抽奖转盘"},
        {42, data_limit_buy, "限时抢购"},
        {43, data_cross_flower, "跨服鲜花榜"},
        {44, data_fuwen_map, "符文寻宝"},
        {45, data_hundred_return, "白倍返利"},
        {46, data_login_online, "登陆有礼"},
        {47, data_new_exchange, "新兑换活动"},
        {48, data_act_equip_sell, "特权炫装"},
        {49, data_stone_ident, "原石鉴定"},
        {50, data_collect_exchange, "集字活动"},
        {51, data_act_convoy, "护送活动"},
        {52, data_acc_charge_d, "大额充值"},
        {53, data_act_consume_back_charge, "消费返充值比例"},
        {54, data_consume_rank, "单服消费排行榜"},
        {55, data_recharge_rank, "单服充值排行榜"},
        {56, data_cross_consume_rank, "跨服消费排行榜"},
        {57, data_cross_recharge_rank, "跨服充值排行榜"},
        {58, data_acc_charge, "每日累计充值"},
        {59, data_xj_map, "仙境寻宝"},
        {60, data_flower_rank, "单服鲜花榜"},
        {61, data_act_con_charge, "连续充值"},
        {62, data_open_act_back_buy, "返利抢购"},
        {63, data_open_up_target2, "进阶目标2"},
        {64, data_gold_silver_tower, "金银塔"},
        {65, data_red_goods_exchange, "红装兑换"},
        {66, data_debris_exchange, "碎片兑换"},
        {67, data_marry_rank, "结婚排行榜"},
        {68, data_open_up_target3, "进阶目标3"},
        {69, data_merge_group_charge, "合服首充团购"},
        {70, data_act_wealth_cat, "招财猫"},
        {71, data_merge_up_target, "合服进阶目标1"},
        {72, data_merge_up_target2, "合服进阶目标2"},
        {73, data_merge_up_target3, "合服进阶目标3"},
        {74, data_merge_acc_charge, "合服累积充值"},
        {75, data_merge_act_back_buy, "合服返利抢购"},
        {76, data_merge_guild_rank, "合服帮派争霸"},
        {77, data_merge_exchange, "合服兑换活动"},
        {78, data_merge_day7login, "合服7天登陆"},
        {79, data_open_all_rank2, "合服全民冲榜2"},
        {80, data_open_all_rank3, "合服全民冲榜3"},
        {81, data_open_all_target2, "合服全民总动员2"},
        {82, data_open_all_target3, "合服全民总动员3"},
        {83, data_act_dungeon_double, "副本双倍"},
        {84, data_act_xj_map_double, "仙境寻宝双倍"},
        {85, data_act_mon_drop, "怪物掉落"},
        {86, data_act_hi_fan_tian, "嗨翻天"},
        {87, data_free_gift, "零元礼包"},
        {88, data_act_new_wealth_cat, "新招财猫"},
        {89, data_mystery_shop, "神秘商城"},
        {90, data_act_throw_egg, "疯狂砸蛋"},
        {91, data_act_lucky_turn, "跨服抽奖转盘"},
        {92, data_limit_time_gift, "限时礼包"},
        {93, data_act_welkin_hunt, "天宫寻宝"},
        {94, data_act_local_lucky_turn, "单服抽奖转盘"},
        {95, data_act_baby_equip_sex, "宝宝装备性别开关控制"},
        {96, data_act_small_charge, "小额充值"}
    ].


%%        {1, data_fir_charge,"首充活动"},
%%        {2, data_act_rank,"冲榜活动"},
%%        {3, data_daily_charge,"每日充值"},
%%        {5, data_acc_consume,"累计消费"},
%%        {6, data_one_charge,"单笔充值"},
%%        {7, data_lim_shop,"抢购商店"},
%%        {8, data_cycle_double,"双倍跑环"},
%%        {9, data_act_rank_goal,"冲榜达标返利"},
%%        {10, data_new_daily_charge,"新每日充值"},
%%        {11, data_new_one_charge,"新单笔充值"},
%%        {12, data_online_gift,"在线奖励"},
%%        {13, data_exchange,"兑换"},
%%        {14, data_online_time_gift,"在线时长奖励"},
%%        {15, data_daily_acc_charge,"每日累充"},
%%        {16, data_acc_charge_turntable,"累充转盘"},
%%        {17, data_daily_fir_charge_return,"每日首充返还"},
%%        {18, data_acc_charge_gift,"累充礼包"},
%%        {19, data_ad,"开服广告"},
%%        {20, data_goods_exchange,"物品兑换"},
%%        {21, data_role_d_acc_charge,"角色每日累充"},
%%        {22, data_con_charge,"连续充值"},
%%        {23, data_open_egg,"砸蛋"},
%%        {24, data_merge_sign_in,"合服签到"},
%%        {25, data_charge_mul,"多倍充值"},
%%        {26, data_target_act,"目标福利"},
%%        {27, data_act_monopoly,"大富翁"},
%%        {28, data_vip_gift,"VIP礼包"},
%%        {29, data_treasure_hourse,"藏宝阁"},
%%        {30, data_open_jh_rank,"江湖冲榜"},
%%        {31, data_open_up_target,"进阶目标"},
%%        {32, data_open_group_charge,"首充团购"},
%%        {33, data_open_acc_charge,"累积充值"},
%%        {34, data_open_all_target,"全服总动员"},
%%        {35, data_open_all_rank,"全民冲榜"},
%%        {36, data_open_guild_rank,"帮派争霸"},