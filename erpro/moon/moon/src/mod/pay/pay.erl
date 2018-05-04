%%-------------------------------------------------------------------------------------
%% @doc 各模块晶钻价格控制中心， 每种消费请说明下
%% @doc 每个新增的晶钻消费请务必加载最后面，不要中间插入，请务必注明对应的更新版本
%% @doc 采用类似于 db_change.sql 的控制方式
%% @doc 涉及消费数值修改的请注释以前的，然后添加最新的在最后面，
%% @author jackguan@jieyou.cn
%% @end
%%-------------------------------------------------------------------------------------
-module(pay).
-export([price/3]).

%% @spec price(Mod, Type, Val) -> integer() | false
%% Mod = atom() 模块名
%% Type = atom()
%% Val = term() 若模块中此参数无用则用null
%% @doc 获取当前类型的价格

%% 仙境寻宝 揭开价格定义
%% 龙宫仙境 1次 10晶钻，10 次 95晶钻 50 次 450晶钻
price(casino, casino_type_one, 1) -> 10;
price(casino, casino_type_one, 10) -> 95;
price(casino, casino_type_one, 50) -> 450;
%% 仙府秘境 1次 20晶钻，10 次 190晶钻 50 次 900晶钻
price(casino, casino_type_two, 1) -> 20;
price(casino, casino_type_two, 10) -> 190;
price(casino, casino_type_two, 50) -> 900;
%% 天官赐福 1次 20晶钻，10 次 190晶钻 50 次 900晶钻
price(casino, casino_type_three, 1) -> 20;
price(casino, casino_type_three, 10) -> 190;
price(casino, casino_type_three, 50) -> 900;
%% 仙魂探宝 1次 20晶钻，10 次 190晶钻 50 次 900晶钻
price(casino, casino_type_four, 1) -> 20;
price(casino, casino_type_four, 10) -> 190;
price(casino, casino_type_four, 50) -> 900;

%% 师门竞技 增加挑战次数, 每次 Nth * 2 晶钻
price(arena_career_rpc, arena_career_add_times, Nth) -> Nth * 2;

%% 师门竞技 加速CD 1分钟1晶钻
price(arena_career_rpc, arena_career_clear_cd, Cd) -> util:ceil(Cd / 60);

%% 锻造 装备洗练 这里是洗练锁的价格 一个 20晶钻
price(blacksmith, polish_equip, {LossLockNum, HasLockNum}) -> (LossLockNum - HasLockNum) * 20;

%% 锻造 批量洗练 一个洗练锁 20晶钻
price(blacksmith, batch_polish, {LossLockNum, HasLockNum}) ->
    (LossLockNum - HasLockNum) * 20;

%% 锻造 合成 一个合成符 30 晶钻
price(blacksmith, loss_combine, DelMore) ->
    DelMore * 30;

%% 远古巨龙 购买Buff 神佑一次 15 晶钻
price(super_boss, do_purchase, _) ->
    15;
%% 洛水反击 立即复活花费 3晶钻
price(guard_counter, do_revive, _) ->
    3;

%% 元神 加速 3分钟 消耗 1晶钻
price(channel, speed_type_1, Dtime) ->
    util:ceil(Dtime/180);
%% 使用丹药加速，TODO 没有用到
price(channel, speed_type_2, _) ->
    5;
%% 使用丹药加速，TODO 没有用到
price(channel, speed_type_3, _) ->
    20;

%% 元神 一键满级 3分钟一晶钻
price(channel, all_speed, Time) ->
    util:ceil(Time/180);
price(channel, single_speed, T) ->
    util:ceil(T/180);

%% 仙府 神兽升级 2 级 10晶钻 3 级 15晶钻 4 级 20晶钻 5级25晶钻 6级30晶钻 7级35晶钻 8级40晶钻 9级45晶钻 10级 50晶钻
price(cross_ore_rpc, lev_to_upgrad_gold, 2) ->
    10;
price(cross_ore_rpc, lev_to_upgrad_gold, 3) ->
    15;
price(cross_ore_rpc, lev_to_upgrad_gold, 4) ->
    20;
price(cross_ore_rpc, lev_to_upgrad_gold, 5) ->
    25;
price(cross_ore_rpc, lev_to_upgrad_gold, 6) ->
    30;
price(cross_ore_rpc, lev_to_upgrad_gold, 7) ->
    35;
price(cross_ore_rpc, lev_to_upgrad_gold, 8) ->
    40;
price(cross_ore_rpc, lev_to_upgrad_gold, 9) ->
    45;
price(cross_ore_rpc, lev_to_upgrad_gold, 10) ->
    50;

%% 精灵守护 单次刷新技能 刷新一次 30晶钻
price(demon, polish_skill_gold, _) ->
    30;
%% 精灵守护 批量刷技能 批量一次 200 晶钻
price(demon, batch_polish_skill_gold, _) ->
    200;
%% 精灵守护 洗练锁 一个洗练锁 20晶钻
price(demon_rpc, lock_gold, _) ->
    20;

%% 运镖 晶钻刷镖 刷新一次 1晶钻
price(escort, refresh, _) ->
    2;
%% 小屁孩晶钻刷新 刷新一次 8晶钻
price(escort_child, do_refresh, _) ->
    8;
%% 刷美女 刷新一次 2晶钻
price(escort_cyj, beauty, _) ->
    2;

%% 缘分摇一摇 购买互动 10晶钻 购买一次互动
price(fate_act, set_act_status, _) ->
    10;

%% 帮会历练 刷新任务 2晶钻1次
price(guild_practise_rpc, refresh, _) ->
    2;

%% 宠物寄养 3分钟1晶钻
price(guild_pet_deposit, pet_speed_cost, M) ->
    util:ceil(M / 3);
%% 宠物寄养 归还晶钻
price(guild_pet_deposit, pet_deposit_sec_gold, Sec) ->
    ((Sec) div 180);

%% 增加仓库或者背包容量 1 栏 10晶钻
price(storage_api, add_storage_volume, Count) ->
    10 * Count;

%% 摇钱树 扣除晶钻基数 一次 1晶钻
price(lottery_tree, lottery_tree_base_cost, _) ->
    2;

%% 挂机次数购买 30晶钻
price(hook_rpc, hook_times, _) ->
    30;

%% 刷新神秘商店 刷新一次 20 晶钻
price(npc_store_sm, refresh_sm, _) ->
    20;

%% 领取离线经验 每5000经验 1 晶钻
price(offline_exp_rpc, offline_exp, GetExp) ->
    util:ceil(GetExp / 5000);

%% 宠物 购买更名次数 30晶钻购买
price(pet, buy_rename, _) ->
    30;
%% 宠物 刷宠物蛋 1:批量 0:单个
price(pet, pet_egg_green, 0) -> 2;  %% TODO 没有用
price(pet, pet_egg_green, 1) -> 15; %% TODO 没有用
price(pet, pet_egg_blue, 0) -> 15;  %% TODO 没有用
price(pet, pet_egg_blue, 1) -> 100; %% TODO 没有用

%% 一次50晶钻
price(pet, pet_egg_purple, 0) -> 50;
%% 批量 300晶钻
price(pet, pet_egg_purple, 1) -> 300;

price(pet, pet_egg_orange, 0) -> 150;   %% TODO 没有用
price(pet, pet_egg_orange, 1) -> 1200;  %% TODO 没有用

%% 金蛋 一次 80晶钻
price(pet, pet_egg_golden, 0) -> 80;
%% 金蛋 批量一次 480 晶钻
price(pet, pet_egg_golden, 1) -> 480;

%% 宠物 开启双天赋 888晶钻
price(pet_api, open_double_talent, _) -> 888;

%% 宠物 双天赋 冷却加速 3 分钟一晶钻
price(pet_api, del_double_talent_cd, Time) ->
    util:ceil(Time / 180);
%% 宠物 取消更好外观冷却时间  1 小时 1晶钻 
price(pet_ex, cancel_skin_time, Time) ->
    util:ceil(Time / 3600);

%% 宠物 开启魔晶格子 1格20晶钻
price(pet_magic, add_volume, _) -> 20;
%% 宠物魔晶洗练锁  洗练锁的价格
price(pet_magic, do_polish, NeedLockNum) ->
    20 * NeedLockNum;

%% GM命令 转阵营
price(role_adm_rpc, realm, _) ->    %%  TODO  没用到
    168;
%% 角色复活 恢复一般血，法力 3 晶钻
price(role_api, revive_2, _) ->
    3;
%% 满血复活 6 晶钻
price(role_api, revive_3, _) ->
    6;
%% 角色 传送 消耗一个飞鞋 1晶钻
price(role_api, do_trans_hook, _) ->
    1;

%% 角色相关远程调用 转换阵营  168 晶钻
price(role_rpc, do_realm, _) ->
    168;

%% 商城 直接购买并使用 金币卡的 单价 10 晶钻
price(shop_rpc, buy_and_use, Num) ->
    Num * 10;
%% 商城 高级经验符
price(shop_rpc, exp_high, _) -> %% TODO 没有用
    20;

%% 购买技能熟练度  每5点 1晶钻
price(skill_rpc, skill_exp, Num) ->
    util:ceil(Num / 5);

%% 灵戒洞天 召唤妖灵  30晶钻刷新一次， 批量刷新 8次，240晶钻
price(soul_world, soul_world_gold_call_cost, 1) ->
    30 * 8;
price(soul_world, soul_world_gold_call_cost, _) ->
    30;
%% 灵戒洞天 宠物阵加速 按10分钟算，每10分钟2晶钻
price(soul_world, speed_up, Secs) ->
    util:ceil(Secs / 600) * 2;
%% 宠物阵全部加速
price(soul_world, all_speed_up, Secs) ->
    util:ceil(Secs / 600) * 2;
%% 加速了多少秒
price(soul_world, do_speed, Secs) ->
    util:ceil(Secs / 600) * 2;
%% 加速到完成
price(soul_world, speed_finish, Secs) ->
    util:ceil(Secs / 600) * 2;
%% 一键提升阵法到指定等级
price(soul_world, fast_upgrade_array, Val) ->
    util:ceil(Val / 600) * 2;

%% 生成物品 加速 1小时1晶钻
price(soul_world, fast_get_product, 1) ->
    1;
price(soul_world, fast_get_product, Time) ->
    util:ceil(Time / 60 / 60);

%% 增加生成线 第3个 50晶钻，第4个 200晶钻 第5个 500晶钻
price(soul_world, add_product_line, 2) ->
    50;
price(soul_world, add_product_line, 3) ->
    200;
price(soul_world, add_product_line, _) ->
    500;

%% 结拜 500晶钻
price(sworn, sworn_log_gold, _) ->
    500;
%% 结拜花费 活动 288 晶钻
price(sworn, camp_sworn_lod_gold, _) ->
    288;
%% 结拜 设自定义称号  300晶钻
price(sworn_rpc, self_title, _) ->
    300;
%% 割袍断义  100 晶钻
price(sworn_rpc, break_less, _) ->
    100;

%% 任务 修行任务刷新  2晶钻刷新一次
price(task, fresh, _) ->
    2;
%% 师门任务 修行任务
price(task_util, calc_finish_imm_gold, task_type_sm) ->
    2;
price(task_util, calc_finish_imm_gold, task_type_xx) ->
    2;
price(task_util, calc_finish_imm_gold, task_type_bh) ->
    2;

%% 购买VIP VIP 周卡，月卡，年卡的价格
price(vip, vip_week, _) ->
    138;
price(vip, vip_month, _) ->
    388;
price(vip, vip_half_year, _) ->
    1688;

%% 翅膀技能刷新 刷新一次 20晶钻，批量一次 100晶钻
price(wing_skill, refresh_skill, 0) ->
    20;
price(wing_skill, refresh_skill, 1) ->
    100;

%% 职业进阶  飞升 1000晶钻
price(skill_rpc, ascend, _) -> 1000;

%% 飞仙历练 本服
price(train_common, sit, 1) -> 0;   %% 普通
price(train_common, sit, 2) -> 30;  %% 平地风雷 1次 30晶钻
price(train_common, sit, _) -> 90;  %% 风花雪月 1次 90晶钻

%% 升级帮会 升级为VIP帮会 30晶钻
price(guild_common, upgrade_vip, _) -> 30;

%%----------20130508-------------
%% 宠物开启宠物栏 已有10个 N = 10，将要开启的第11个10晶钻， 后面的每个在前面的基础上增加10晶钻 ，每栏 10晶钻
price(pet, expand_limit_num, N) -> 10*(N-9);

price(_, _, _) -> false.
