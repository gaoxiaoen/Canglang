-define(ETS_RANK, ets_rank).   %%排行榜ets
-define(ETS_RANK_WORSHIP, ets_rank_worship).   %%排行榜膜拜ets

-define(RANK_TYPE_CBP, 1).  %%战力排行榜
-define(RANK_TYPE_LV, 2).  %%等级排行榜
-define(RANK_TYPE_FLOWER, 3).  %%鲜花排行榜
-define(RANK_TYPE_MOUNT, 4).  %%坐骑排行榜
-define(RANK_TYPE_WING, 5).  %%翅膀排行榜
-define(RANK_TYPE_FABAO, 6).  %%法宝排行榜
-define(RANK_TYPE_SB, 7).  %%神兵排行榜
-define(RANK_TYPE_YL, 8).  %%妖灵排行榜
-define(RANK_TYPE_PET_STAGE, 9).  %%宠物等阶排行榜
-define(RANK_TYPE_PET_STAR, 10).  %%宠物星级排行榜
-define(RANK_TYPE_FOOT, 11).  %%足迹排行榜
-define(RANK_TYPE_CAT, 12).  %%灵猫排行榜
-define(RANK_TYPE_GOLDEN_BODY, 13).  %%金身排行榜
-define(RANK_TYPE_GOLDEN_BABY_STAGE, 14).  %%子女阶数排行榜
-define(RANK_TYPE_GOLDEN_BABY_STAR, 15).  %%子女等级排行榜
-define(RANK_TYPE_BABY_WING, 16).  %%子女灵羽排行榜
-define(RANK_TYPE_BABY_MOUNT, 17).  %%子女坐骑排行榜
-define(RANK_TYPE_BABY_WEAPON, 18).  %%子女武器排行榜
-define(RANK_TYPE_JADE, 19).  %%灵佩排行榜
-define(RANK_TYPE_GOD_TREASURE, 20).  %%仙宝排行榜

-define(ALL_RANK_TYPE, lists:seq(1, 20)).  %%所有排行类型

-define(RANK_NUM, 100).  %%排行榜前100名

-define(MAX_WORSHIP_TIMES, 5).  %%最大膜拜次数

-define(TIMER_UPDATE_DB, 900).  %%定时更新时间

-record(rank_st, {
    refresh_ref = 0,
    defore_refresh_ref = 0,
    timer_update_ref = 0
}).

%%排行榜人物信息
-record(rp, {
    pkey = 0,
    sn = 0,
    pf = 0,
    nickname = [],
    lv = 0,
    career = 0,
    sex = 0,
    vip = 0,
    realm = 0,
    guild_name = [],
    guild_key = 0,
    cbp = 0,
    dvip = 0
}).

%%鲜花排行信息
-record(r_f, {
    flower_num = 0  %%鲜花数
}).

%%坐骑排行信息
-record(r_m, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).

%%翅膀排行信息
-record(r_w, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).

%%法宝排行信息
-record(r_fb, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).

%%神兵排行信息
-record(r_s, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).

%%妖灵排行信息
-record(r_yl, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).

%%宠物等阶排名信息
-record(r_p_stage, {
    pet_key = 0,
    pet_name = "",
    type_id = 0,
    stage = 0,  %%等阶
    cbp = 0  %%战力
}).

%%宠物星级排名信息
-record(r_p_star, {
    pet_key = 0,
    pet_name = "",
    type_id = 0,
    star = 0,  %%星级
    cbp = 0  %%战力
}).


%%子女等阶排名信息
-record(r_baby_stage, {
    stage = 0,  %%等阶
    type_id = 0,
    cbp = 0  %%战力
}).


%%子女星级排名信息
-record(r_baby_star, {
    star = 0,  %%星级
    type_id = 0,
    cbp = 0  %%战力
}).


%%灵羽排行信息
-record(r_baby_wing, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).

-record(r_baby_mount, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).


-record(r_baby_weapon, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).


%%足迹排行信息
-record(r_foot, {
    stage = 0  %%阶数
    , id = 0  %%外观id
    , cbp = 0 %%外观战力
}).

%%妖灵排行信息
-record(r_cat, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).


%%金身排行信息
-record(r_golden_body, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).

%%灵佩排行信息
-record(r_jade, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).
%%仙宝排行信息
-record(god_treasure, {
    stage = 0  %%阶数
    , id = 0 %%外观id
    , cbp = 0 %%外观战力
}).


%%所有排行榜信息
-record(a_rank, {
    key = {0, 0}  %%key
    , type = 0    %%排行榜类型
    , pkey = 0    %%玩家key
    , rank = 0    %%排名
    , rp = #rp{}  %%玩家信息

    %%---各排行榜信息----
    , r_f = #r_f{} %%鲜花排行信息
    , r_m = #r_m{} %%坐骑排行信息
    , r_w = #r_w{} %%翅膀排行信息
    , r_fb = #r_fb{} %%法宝排行信息
    , r_s = #r_s{} %%神兵排行信息
    , r_yl = #r_yl{} %%妖灵排行信息
    , r_p_stage = #r_p_stage{} %%宠物等阶排名信息
    , r_p_star = #r_p_star{} %%宠物星级排名信息
    , r_foot = #r_foot{}  %%足迹排行信息
    , r_cat = #r_cat{} %%灵猫
    , r_golden_body = #r_golden_body{} %%金身
    , r_jade = #r_jade{} %%灵佩
    , god_treasure = #god_treasure{} %%仙宝
    , r_baby_stage = #r_baby_stage{} %%子女阶数
    , r_baby_star = #r_baby_star{} %%子女星级排名信息
    , r_baby_wing = #r_baby_wing{} %%子女翅膀排行信息
    , r_baby_mount = #r_baby_mount{} %%子女坐骑排行信息
    , r_baby_weapon = #r_baby_weapon{} %%子女武器排行信息

}).

%%排行榜膜拜
-record(rank_wp, {
    pkey = 0
    , worship_times = 0  %%膜拜次数
    , wp_player_list = [] %%已膜拜的玩家列表 [{pkey,type}]
    , update_time = 0    %%更新时间
    , worship_list = []  %%被膜拜次数列表 [{Type, Times}]
    , is_db_update = 0
}).