-ifndef(TEAM_HRL).
-define(TEAM_HRL, 1).

-define(ETS_TEAM, ets_team).%%队伍记录
-define(ETS_TEAM_MB, ets_team_mb).%%队伍玩家记录

-define(TEAM_MAX_NUM, 3).%%队伍最大人数
-define(TEAM_LIM_LV, data_menu_open:get(41)).%%组队等级限制
-define(TEAM_LOGOUT_TIME, 60).%%离线更新时间
-define(TEAM_LOGOUT_LEADER_TIME, 30).%%离线队长更新时间
-define(JOIN_TEAM, 1).%%加入队伍
-define(QUIT_TEAM, 2).%%退出队伍
-define(KICK_TEAM, 3).%%踢出队伍

-define(TEAM_RECRUIT_COIN, 10000).%%发布队伍招募费用
%%队伍进程state
-record(st_team, {
    key = 0
}).

%%队伍record
-record(team, {
    key = 0,
    pid = undefined,
    name = <<>>, %% 队长名称
    pkey = 0,   %%队长key
    num = 0
}).

%%队伍成员record
-record(t_mb, {
    pkey = 0,           %%玩家key
    sn_cur = 0,             %%服务器号
    join_time = 0,      %%入队时间
    nickname = <<>>,       %%玩家昵称
    pid = undefined,       %%玩家PID
    realm = 0,              %%阵营
    career = 0,             %%职业
    lv = 0,                 %%等级
    guild_name = <<>>,      %% 仙盟
    vip = 0,
    avatar = "",
    power = 0,              %%战力
    scene = 0,
    copy = 0,
    x = 0,
    y = 0,
    hp = 0,
    hp_lim = 0,
    team_key = 0,
    team_pid = undefined,       %%队伍PID
    team_leader = 0,           %%是否队长，1队长0队员
    is_online = 1,          %%是否在线1是0否
    logout_time = 0,       %%离队时间
    fashion_cloth_id = 0,
    light_weaponid = 0,
    wing_id = 0,
    clothing_id = 0,
    weapon_id = 0,
    pet_type_id = 0,
    pet_figure = 0,
    pet_name = 0,
    head_id = 0,
    sex = 0
}).

%% 成员简要信息
-record(team_simple, {
    key = 0, %% 玩家 key
    nickname = <<>>, %% 玩家姓名
    vip = 0,    %% vip 等级
    lv = 0,     %% 等级
    cbp = 0,    %% 战力
    image = <<>>, %% 头像
    guild = <<>>,%% 仙盟
    sex = 1 %% 性别
}).








-endif.