%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2017 15:50
%%%-------------------------------------------------------------------
-author("Administrator").


%%活动状态--关闭
-define(CROSS_1VN_STATE_CLOSE, 0).
%%活动状态--资格赛报名
-define(CROSS_1VN_STATE_SIGN, 1).
%%活动状态--资格赛准备
-define(CROSS_1VN_STATE_READY, 2).
%%活动状态--资格赛开启
-define(CROSS_1VN_STATE_START, 3).
%%活动状态--决赛准备
-define(CROSS_1VN_STATE_FAINAL_READY, 4).
%%活动状态--决赛开启
-define(CROSS_1VN_STATE_FAINAL_START, 5).

%%活动准备时间
-define(CROSS_1VN_READY_TIME, 1800).


%%资格赛准备时间
-define(CROSS_1VN_START_READY_TIME, 150).
%%资格赛每场比赛时间
-define(CROSS_1VN_PLAY_TIME, 60).
%%资格赛次数
-define(CROSS_1VN_TIMES, 6).
%%资格赛下一轮时间
-define(CROSS_1VN_NEXT_TIME, 80).
%%资格赛结束等待时间
-define(CROSS_1VN_WAIT_TIME, 20).

%%擂主赛准备时间
-define(CROSS_1VN_FINAL_READY_TIME, 150).
%%擂主赛每场比赛时间
-define(CROSS_1VN_FINAL_PLAY_TIME, 120).
%%擂主赛下一轮时间
-define(CROSS_1VN_FINAL_NEXT_TIME, 140).

%%选出竞猜擂主
-define(CROSS_1VN_FINAL_CHOOSE_LUCK_WINNER_TIME, 80).

%%擂主赛持续时间时间
-define(CROSS_1VN_FINAL_TOTAL_TIME, 25 * 60).


%%定时更新时间
-define(CROSS_1VN_TIMER_UPDATE, 15).

%%比赛类型 -- 初赛
-define(CROSS_1VN_PLAY_TYPE_0, 0).
%%比赛类型 -- 决赛
-define(CROSS_1VN_PLAY_TYPE_1, 1).

-define(SHOT_TIME, 5).

-define(CROSS_1VN_GROUP_RED, 1).
-define(CROSS_1VN_GROUP_BLUE, 2).
%%跨服1vN
-record(st_1vn, {
    sign_list = [], %% 报名列表(资格赛列表) [#cross_1vn_group{}]
    rank_list = [], %% 资格赛排名 [#cross_1vn_group{}]
    final_list = [], %% 擂主列表 [#cross_1vn_group{}]
    final_rank_list = [], %% 擂主排名 [#cross_1vn_group{}]
    history_info = [], %% 历史记录 [{{month,day},[#cross_1vn_group{}]}]
    history_group = [], %% 期数列表 [{month,day}]
    history_shop = [], %% [{group,List}] 前三名展示
    winner_num = [], %% 擂主数量 [{group,num}]
    bet_list = [],          %% 中场投注信息 [#cross_1vn_bet_info{}]
    winner_bet_list = [],   %% 冠军投注信息
    sign_num = 0, %% 报名人数
    ref = [],
    open_state = 0,
    top_role = [],
    time = 0,
    floor = 0, %% 轮次
    orz_count = 0, %% 每日膜拜次数
    type = 0, %% 比赛类型 初赛0 决赛1
    play_list = [],
    timer_update_ref = 0
}).


%%跨服1vN中场投注
-record(cross_1vn_bet_info, {
    key = {0, 0},           %% {group,floor}
    group = 0,
    floor = 0,
    pkey = 0,               %% 擂主key
    state = 0,              %% 状态 0未开始 1已选出擂主 2已选出挑战者 3擂主胜 4挑战者胜
    winner = [],            %% 擂主
    challenge_list = [],    %% 挑战者列表
    bet_num = 0,            %% 下注人数
    player_bet_list = []    %% 下注列表 [#cross_1vn_final_player_bet_info{}]     type 1擂主胜 2挑战者胜
}).

%% %%跨服1vN擂主投注
%% -record(cross_1vn_bet_info, {
%%     key = {0, 0},           %% {group,floor}
%%     group = 0,
%%     floor = 0,
%%     pkey = 0,               %% 擂主key
%%     state = 0,              %% 状态 0未开始 1已选出擂主 2已选出挑战者 3擂主胜 4挑战者胜
%%     winner = [],            %% 擂主
%%     challenge_list = [],    %% 挑战者列表
%%     bet_num = 0,            %% 下注人数
%%     player_bet_list = []    %% 下注列表 [#cross_1vn_final_player_bet_info{}]     type 1擂主胜 2挑战者胜
%% }).

%%跨服1vN
-record(cross_1vn_final_bet_info, {
    group = 0,
    pkey = 0,        %% 下注玩家key
    ratio = 0,       %% 当时赔率
    winner_key = 0   %% 擂主
}).

%%跨服1vN玩家投注信息
-record(cross_1vn_final_player_bet_info, {
    pkey = 0,
    sn = 0,
    type = 0, %%1擂主胜 2挑战者胜
    cost = 0,
    ratio = 0
}).


%%跨服1vN
-record(cross_1vn_group, {
    group = 0,
    is_final = 0,
    mb_list = [] %% [#cross_1vn_mb{}]
}).

-record(cross_1vn_mb, {
    node = none,
    sn = 0,
    pkey = 0,
    pid = 0,
    nickname = <<>>,
    career = 0,
    sex = 0,
    lv = 0,
    avatar = "",    %%头像
    times = 0,
    combo = 0,
    group = 0,
    lv_group = 0,
    cbp = 0,
    win = 0,
    lose = 0,
    score = 0,
    hp = 0,
    rank = 0,
    ratio = 0, %% 赔率
    bet_list = [], %% 投注列表
    shadow = {},
    attribute = {},
    final_floor = 0, %% 决赛轮次
    robot_state = 0, %% 是否机器人
    war_state = 0, %% 1死亡 2退出
    acc_combo = 0, %% 单局连杀数
    guild_name = "",
    guild_key = 0,
    is_change = 0,
    guild_position = 0,
    time = 0,
    is_lose = 0, %% 是否战败
    mount_id = 0,
    wing_id = 0,
    head_id = 0,
    wepon_id = 0,
    clothing_id = 0,
    light_wepon_id = 0,
    fashion_cloth_id = 0,
    vip = 0,
    flag = {0, 0} %%  期数 N月M日
}).


%%跨服1vN
-record(st_cross_1vn_shop, {
    pkey = 0,
    lv_group = 0,
    time = 0,
    floor = 0,
    is_sign = 0,
    rank = 0,
    shop = [], %% [{{type,id},count}]
    flag = {0, 0}
}).


%%跨服1vN商店
-record(base_cross_1vn_shop, {
    type = 0,
    id = 0,
    round = 0,
    merge_up = 0,
    merge_down = 0,
    goods_id = 0,
    goods_num = 0,
    old_cost = 0,
    now_cost = 0,
    ratio = 0,
    my_count = 0,
    all_count = 0
}).



