-ifndef(GUILD_WAR_HRL).
-define(GUILD_WAR_HRL, 1).

-define(ETS_ST_FIGURE, ets_st_figure).

%%仙盟战时间
-define(GUILD_WAR_START_TIME, (20 * 3600)).


%%仙盟战准备时间
-define(GUILD_WAR_READY_TIME, 300).

-define(GUILD_WAR_TIME, (30 * 60)).



-define(GUILD_WAR_STATE_APPLY, 0).
-define(GUILD_WAR_STATE_READY, 1).
-define(GUILD_WAR_STATE_START, 2).

-define(GUILD_WAR_FIGURE_COLLECT, 0).

-define(CRYSTAL_TYPE_HIGH, 1).%%高级水晶
-define(CRYSTAL_TYPE_MID, 2).%%中级水晶
-define(CRYSTAL_TYPE_LOW, 3).%%低级水晶

%%
-record(st_guild_war, {
    war_state = 0,  %%仙盟战状态 0报名，1准备，2开始
    ref = undefined,
    end_time = 0,
    g_dict = dict:new(), %%报名仙盟
    p_dict = dict:new(), %%玩家数据
    pos_list = [],      %%刷新的资源位置列表
    collect_list = [],%%采集记录
    cmd_cd = []
}).

%%报名仙盟
-record(guild_war, {
    gkey = 0,
    group = 0,
    time = 0,
    resource = 0 %%资源量
}).

%%仙盟战玩家信息
-record(g_war_mb, {
    pkey = 0,
    contrib = 0,
    is_cmd = 0,
    kill_count = 0,
    collect_contrib = 0,
    assists_count = 0,
    collect_count = [],
    nickname = <<>>,
    career = 0,
    realm = 0,
    vip = 0,
    scene = 0,
    copy = 0,
    x = 0,
    y = 0,
    gkey = 0,
    gname = <<>>,
    group = 0,
    figure = 0,
    rank_id = 0,
    exploit = 0,
    is_new = 0,
    goods_list = [],
    rank_val = 0

}).

-record(st_figure, {
    pkey = 0,
    figure_list = []
}).

-record(p_figure, {
    figure = 0,
    lv = 0,
    contrib = 0
}).
-record(base_guild_war_crystal, {
    id = 0,
    x = 0,
    y = 0,
    type = 0,
    mon_id = 0,
    refresh_time = [],
    state = 0,
    ref = [],
    notice_ref = [],
    notice = ""
}).

-record(base_guild_war_figure, {
    figure = 0,
    contrib = 0,
    extra_contrib = [],
    att_per = 0,
    hp_per = 0,
    collect_time = 0,
    collect_per = 0,
    kill_per = 0,
    assists_per = 0
}).

-endif.