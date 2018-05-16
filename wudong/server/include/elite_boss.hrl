%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 一月 2018 15:24
%%%-------------------------------------------------------------------
-author("li").

-define(ETS_ELITE_BOSS, ets_elite_boss).

-define(ELITE_BOSS_CLOSE, 0).%%已击杀
-define(ELITE_BOSS_OPEN, 1).%%未击杀
-define(ELITE_BOSS_NOTICE_TIME, 5). %% 5秒钟更新在线玩家一次
-define(ELITE_BOSS_BACK_TIME, 60). %% 1min检查一次

-record(elite_boss, {
    id = 0,
    scene_id = 0,
    boss_id = 0,
    x = 0,
    y = 0,
    lv = 0,
    refresh_cd_time = 0,
    consume = [], %% 进入战场消耗
    rank_reward = [], %% 排名奖励
    %%动态数据
    key = 0,
    pid = 0,
    boss_state = 0,  %% 0已击杀 1未击杀
    kill_pkey = 0,    %%击杀者key
    damage_list = [],
    cache_rank_data = [], %% 缓存的排名数据，每5秒更新一次
    hp = 0, %% boss当前血量
    hp_lim = 0, %%boss总血量
    next_bron_time = 0, %% 下次被创建时间
    ref = [] %% 刷新的定时器
}).

-record(st_elite_boss, {
    ref = [],
    elite_boss_list = [], %% [#elite_boss{}]
    back_list = [],
    back_ref = []
}).

%%伤害信息
-record(f_damage, {
    node = none,
    pkey = 0,
    sn = 0,
    name = <<>>,
    lv = 0,
    gkey = 0,
    damage = 0,  %%个人伤害
    damage_ratio = 0,  %%伤害比例
    cbp = 0,
    rank = 0,
    online = 0,
    pid = none,
    sid = none
}).