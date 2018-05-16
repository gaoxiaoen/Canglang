-ifndef(TIPS_HRL).
-define(TIPS_HRL, 1).

-record(base_tips, {
    index = 0,
    id = 0,
    type = 0, %% 类型 1、为福利大厅 2、在线以及签到再领一次 3、副本操作 4、道具开启 5、系统功能升级
    type_desc = <<>>,
    priority = 0, %% 优先级 1最高 2其次
    name = <<>>,
    msg = <<>>,
    lv_lim = 0,
    login = 0,
    uplv = 0,
    timer = 0

}).

-record(tips, {
    state = 0, %% 是否有红点推送
    args1 = 0,
    args2 = 0,
    args3 = 0,
    args4 = 0,
    args5 = 0,
    args6 = 0,
    args7 = 0,
    args8 = 0,
    saodang_dungeon_list = [], %% 推送可以扫荡副本 0经验 1剧情 2神器 3经脉 4灵脉 5九霄塔
    uplv_dungeon_list = [], %% 推送提升等级可挑战副本 1剧情 2神器 3经脉 4灵脉 6进阶材料副本 7符文塔
    upcombat_dungeon_list = [] %% 战力提升推送副本 0经验 5九霄塔
}).

-define(TIPS_DUNGEON_TYPE_EXP, 0). %% 经验副本
-define(TIPS_DUNGEON_TYPE_DAILY_ONE,   1). %% 剧情副本
-define(TIPS_DUNGEON_TYPE_DAILY_TWO,   2). %% 神器副本 {神器副本不再是每日副本}
-define(TIPS_DUNGEON_TYPE_DAILY_THREE, 3). %% 经脉副本
-define(TIPS_DUNGEON_TYPE_DAILY_FOUR,  4). %% 灵脉副本
-define(TIPS_DUNGEON_TYPE_TOWER, 5). %% 九霄塔
-define(TIPS_DUNGEON_TYPE_MATERIAL, 6). %% 进阶材料副本
-define(TIPS_DUNGEON_TYPE_FUWEN_TOWER, 7). %% 符文塔
-define(TIPS_DUNGEON_TYPE_GUARD, 8). %% 守护副本

-define(DUNGEON_TYPE_DAILY_LIST, [?TIPS_DUNGEON_TYPE_DAILY_ONE, ?TIPS_DUNGEON_TYPE_DAILY_FOUR]).


-define(TIPS_DUNGEON_EXP_CACHE, tips_dungeon_exp_cache).
-define(TIPS_DUNGEON_TOWER_CACHE, tips_dungeon_tower_cache).



-endif.