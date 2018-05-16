-ifndef(FIELD_BOSS_HRL).
-define(FIELD_BOSS_HRL, 1).

-define(ETS_FIELD_BOSS, ets_field_boss).
-define(ETS_FIELD_BOSS_POINT, ets_field_boss_point).  %%积分数据

-define(ETS_FIELD_BOSS_ROLL, ets_field_boss_roll). %%roll
-define(ETS_FIELD_BOSS_BUY, ets_field_boss_buy). %%购买挑战次数数据

-define(FIELD_BOSS_CLOSE, 0).%%已击杀
-define(FIELD_BOSS_OPEN, 1).%%未击杀

-define(SERVER_TYPE_NORMAL, 1).
-define(SERVER_TYPE_CROSS, 2).

-define(FIELD_BOSS_REFRESH_TIME, [{0, 0}, {10, 0}, {14, 0}, {18, 30}]).  %%BOSS刷新时间

-define(ROLL_TIME, 15).  %%roll点时间

-define(DAILY_MAX_FIELD_ELITE, 3).  %%每天最多只可打3次精英怪
-define(DAILY_MAX_FIELD_BOSS, data_version_different:get(12)).  %%每天最多只可打15次世界boss

-define(READY_TIME, 1800).  %%准备时间

-define(FIELD_BOSS_LV_LIM, 30).

-record(field_boss, {
    scene_id = 0,
    type = 0,
    boss_id = 0,
    x = 0,
    y = 0,
    lv = 0,
    is_pk = 0,       %%是否场景
    goods_list = [],  %%掉落物品预览
    kill_point = 0,   %%击杀可得积分
    rank_point = [],  %%排名积分 [{最小排名,最大排名,积分}]
    kill_goods = [],  %%击杀奖励
    hurt_goods = [],  %%伤害奖励 [{排名,物品列表}]
    join_goods = [],  %%参与奖励
    luck_goods = [],  %%星运奖励
    roll_gift = 0,    %%roll礼包id
    red_bag_id = 0,

    %%动态数据
    boss_state = 0,  %% 0已击杀 1未击杀
    kill_pkey = 0,    %%击杀者key
    damage_list = [],
    ref = []
}).

-record(st_field_boss, {
    ref = 0,
    ready_ref = 0,
    end_ref = 0,
    state = 0,  %%状态 0普通 1已刷新 2准备刷新
    end_time = 0
}).

%%伤害信息
-record(f_damage, {
    node = none,
    pkey = 0,
    sn = 0,
    name = <<>>,
    lv = 0,
    gkey = 0,
    hp = 0,  %%boss当前血量
    hp_lim = 0,  %%boss总血量
    damage = 0,  %%个人伤害
    damage_ratio = 0,  %%伤害比例
    cbp = 0,
    rank = 0
}).

%%积分信息
-record(f_point, {
    pkey = 0,
    sn = 0,
    name = "",
    lv = 0,
    cbp = 0,
    point_list = [],  %%积分列表 [{scene_id,point}]
    is_db_update = 0,
    update_time = 0
}).

%%精英首领
-record(field_elite, {
    mon_id = 0,
    scene_id = 0,
    drop_goods = [],  %%掉落物品预览
    kill_goods = [],  %%击杀物品奖励
    lv = 0
}).

%%roll
-record(f_roll, {
    roll_id = 0,    %% roll 点唯一ID
    mkey = 0,       %%怪物key
    mid = 0,       %%怪物id
    state = 0,      %%状态 1已创建 2roll中
    scene_id = 0,
    copy = 0,
    hurt_list = [],  %%有攻击的玩家 [{pkey,node}] 列表
    roll_list = [],  %%已掷骰子的玩家信息 [{pkey,node,point,time,name}]
    create_time = 0,  %%roll点创建时间
    end_time = 0,     %%roll点结束时间
    end_ref = 0
}).

-record(ets_field_boss_buy, {
    pkey = 0
    , buy_num = 0
    , op_time = 0
}).

-endif.