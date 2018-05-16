-ifndef(GUILD_MANOR_HRL).
-define(GUILD_MANOR_HRL, 1).

-define(ETS_GUILD_MANOR, ets_guild_manor).



-record(g_manor, {
    gkey = 0,
    lv = 0,         %%等级
    exp = 0,        %5当前经验
    building_list = [],%%建筑列表
    retinue_list = [],%%随从列表
    log = [],           %%日志
    time = 0,
    is_change = 0
}).

-record(manor_building, {
    type = 0,
    lv = 0,
    exp = 0,
    talent = [],
    refresh_time = 0,
    special_task_cd = 0,
    task = [],
    box_list = []%%{boxid,times,pkey,[]}
}).


-record(manor_retinue, {
    key = 0,
    id = 0,
    color = 0,
    quality = 0,
    talent = [],
    exp = 0,
    time = 0,
    state = 0,%%工作时间状态
    state_cd = 0,
    state_log = []
}).

%%宝箱信息
-record(manor_building_box, {
    key = 0,
    box_id = 0,
    open_times = 0,
    log = []
}).

-record(manor_building_task, {
    task_id = 0,
    type = 0,
    time = 0,
    pkey = 0,
    retinue = [],
    ratio = 0,
    team_ratio = 0,
    team_talent = []
}).

-record(base_manor_building, {
    type = 0,
    name = <<>>,
    manor_lv = 0,
    task_refresh_time = 0,
    talent = {}
}).

-record(base_building_task, {
    task_id = 0,
    type = 0,%%类型,1普通,2稀有
    desc = <<>>,
    retinue_num = 0,
    talent = {},
    building_exp = 0,
    manor_exp = 0,
    box_id = 0,
    open_times = 0,
    start_reward = {},
    ratio = 0,
    time = 0,
    view_ratio = 0
}).

-record(base_building_task_rule, {
    type = 0,
    lv = 0,
    task_normal = [],
    task_special = [],
    task_num = 0,
    ratio = 0,
    cd = 0
}).


-record(base_manor_retinue, {
    type = 0,
    id = 0,
    name = <<>>,
    color = 0,
    quality = 0,
    talent = 0,
    exp_lim = 0,
    exp = 0
}).

-record(base_manor_retinue_talent, {
    id = 0,
    name = <<>>,
    desc = <<>>,
    type = 0,
    value = 0,
    rela = 0
}).

-record(base_manor_retinue_state, {
    id = 0,
    desc = <<>>,
    repeat = 0,
    cd = 0,
    contrib = 0,
    goods = [],
    ratio = 0
}).


-endif.