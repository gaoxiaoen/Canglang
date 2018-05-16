%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 一月 2016 下午9:30
%%%-------------------------------------------------------------------
-module(activity_init).
-author("fengzhenlin").

%% API
-export([
    init/1,
    logout/1
]).

init(Player) ->
    %%当日充值数据
    act_charge:init(Player),
    %%首冲
    first_charge:init(Player),
    %%冲榜活动
    act_rank:init(Player),
    act_rank_goal:init(Player),
    %%每日充值
    daily_charge:init(Player),
    %%累计充值
    acc_charge:init(Player),
    %%累计消费
    acc_consume:init(Player),
    %%单笔充值
    one_charge:init(Player),
    %%抢购商店
    lim_shop:init(Player),
    %%新每日充值
    new_daily_charge:init(Player),
    %%新单笔充值
    new_one_charge:init(Player),
    %%在线奖励
    online_gift:init(Player),
    %%兑换活动
    exchange:init(Player),
    %%在线时长奖励
    online_time_gift:init(Player),
    %%每日累计充值
    daily_acc_charge:init(Player),
    %%累充转盘
    acc_charge_turntable:init(Player),
    %%每日首冲返还
    daily_fir_charge_return:init(Player),
    %%累充礼包
    acc_charge_gift:init(Player),
    %%物品兑换
    goods_exchange:init(Player),
    %%角色每日累充
    role_d_acc_charge:init(Player),
    %%连续充值
    con_charge:init(Player),
    %%砸蛋
    open_egg:init(Player),
    %%合服签到
    merge_sign_in:init(Player),
    %%目标福利
    target_act:init(Player),
    %%大富翁
%%    monopoly_init:init(Player),
    vip_gift:init(Player),
    %%藏宝阁
    treasure_hourse:init(Player),
    %%花千骨每日首充
    hqg_daily_charge:init(Player),
    %%开服活动之江湖榜
    open_act_jh_rank:init(Player),
    %%开服活动之进阶目标
    open_act_up_target:init(Player),
    %%开服活动之进阶目标2
    open_act_up_target2:init(Player),
    %%开服活动之进阶目标3
    open_act_up_target3:init(Player),
    %%开服活动之团购首充
    open_act_group_charge:init(Player),
    %%开服活动之累积充值
    open_act_acc_charge:init(Player),
    %%开服活动之全服目标
    open_act_all_target:init(Player),
    %%开服活动之全服目标2
    open_act_all_target2:init(Player),
    %%开服活动之全服目标3
    open_act_all_target3:init(Player),
    %%开服活动之全民冲榜
    open_act_all_rank:init(Player),
    %%开服活动之全民冲榜2
    open_act_all_rank2:init(Player),
    %%开服活动之全民冲榜3
    open_act_all_rank3:init(Player),
    %% 开服活动返利抢购
    open_act_back_buy:init(Player),
    %%投资计划
    act_invest:init(Player),
    %%迷宫寻宝
    act_map:init(Player),
    %%进阶宝箱
    uplv_box:init(Player),
    %%限时抢购
    limit_buy:init(Player),
    %% 百倍返利
    hundred_return:init(Player),
    %%符文寻宝
    fuwen_map:init(Player),
    %%登陆有礼
    login_online:init(Player),
    %%兑换活动
    new_exchange:init(Player),
    %%特权炫装
    act_equip_sell:init(Player),
    %%护送称号活动
    act_convoy:init(Player),
    %%大额累积充值活动
    acc_charge_d:init(Player),
    %% 消费排行榜
    consume_rank:init(Player),
    %% 充值排行榜
    recharge_rank:init(Player),
    %% 消费抽返利
    consume_back_charge:init(Player),
    %% 仙境寻宝
    xj_map:init(Player),
    %% 连续充值
    act_con_charge:init(Player),
    %%金银塔
    gold_silver_tower:init(Player),
    %% 新招财猫
    act_new_wealth_cat:init(Player),
    %% 幸运转盘
    act_lucky_turn:init(Player),
    %% 本服转盘抽奖
    act_local_lucky_turn:init(Player),
    %% 结婚排行榜
    marry_rank:init(Player),
    %%合服活动之团购首充
    merge_act_group_charge:init(Player),
    %%合服活动之进阶目标
    merge_act_up_target:init(Player),
    %%合服活动之进阶目标2
    merge_act_up_target2:init(Player),
    %%合服活动之进阶目标3
    merge_act_up_target3:init(Player),
    %%合服活动之累积充值
    merge_act_acc_charge:init(Player),
    %% 合服七天登陆
    merge_day7login:init(Player),
    %%合服活动返利抢购
    merge_act_back_buy:init(Player),
    %%合服兑换活动
    merge_exchange:init(Player),
    %% 神秘商城
    mystery_shop:init(Player),
    %% 疯狂砸蛋
    act_throw_egg:init(Player),
    %% 水果大战
    act_throw_fruit:init(Player),
    %% 天宫寻宝
    act_welkin_hunt:init(Player),
    %% 限时礼包
    limit_time_gift:init(Player),
    %% 唤神
    act_call_godness:init(Player),

    %% 神邸限购
    act_godness_limit:init(Player),
    %% 小额充值
    act_small_charge:init(Player),
    %% 一元抢购活动
    act_one_gold_buy:init(Player),
    %% 节日活动之登陆有礼
    festival_login_gift:init(Player),
    %% 节日活动之累积充值
    festival_acc_charge:init(Player),
    %% 节日活动之返利抢购
    festival_back_buy:init(Player),
    %% 节日活动之兑换
    festival_exchange:init(Player),
    %% 节日活动之红包雨
    festival_red_gift:init(Player),

    %% 回归活动之兑换
    re_exchange:init(Player),
    %% 回归活动之登陆
    re_login:init(Player),

    %%额外优惠
    open_act_other_charge:init(Player),
    %%超值优惠
    open_act_super_charge:init(Player),
    %%财神单笔充值活动
    cs_charge_d:init(Player),
    %%聚宝盆
    act_jbp:init(Player),
    %%限时仙装
    act_limit_xian:init(Player),
    %%限时仙宠
    act_limit_pet:init(Player),
    %%红装抢购
    buy_red_equip:init(Player),
    %% 初次登陆奖励
    first_login:init(Player),
    %% 小额单笔充值
    small_charge_d:init(Player),
    %% 区域消费合服服号修复
    area_consume_rank:init(Player),
    %% 区域充值合服服号修复
    area_recharge_rank:init(Player),
    %% 经验副本投资
    act_exp_dungeon:init(Player),
    %%  许愿池(单服)
    act_wishing_well:init(Player),
    %%  许愿池(跨服)
    cross_act_wishing_well:init(Player),
    %%  邀请码
    act_invitation:init(Player),
    %%  跃升冲榜
    act_cbp_rank:init(Player),
    %%  奇遇礼包
    act_meet_limit:init(Player),
    %% 剑道寻宝
    jiandao_map:init(Player),
    %%返利大厅消费
    act_consume_rebate:init(Player),
    %%合服消费
    merge_act_acc_consume:init(Player),

    merge_exp_double:update(Player).

logout(Player) ->
    %% 下线保存在线累积时间
    uplv_box:logout(Player),
    %% 下线保存数据
    consume_back_charge:log_out(),
    %% 保存线上数据，避免再次发邮件
    hqg_daily_charge:logout(),
    %% 招财进宝在线累积时间
    act_buy_money:logout(Player),
    %% 在线有礼在线累积时间
    online_reward:logout(Player),
    %% 疯狂砸蛋累积时间
    act_throw_egg:logout(Player),
    %% 水果大战累积时间
    act_throw_fruit:logout(Player),
    act_consume_rebate:logout(),
    merge_act_acc_consume:logout(),
    Player.
