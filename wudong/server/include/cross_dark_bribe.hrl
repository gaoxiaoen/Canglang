%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         魔宫深渊
%%% @end
%%% Created : 21. 七月 2017 13:54
%%%-------------------------------------------------------------------
-author("lzx").

%% 魔宫深渊配置
-record(config_darak_bribe_task, {
    task_id = 0,
    type = 0,
    sub_type = 0, %%子类型
    desc = "",
    tar = 0,
    next_id = 0,
    award_list = []
}).

%% 场景进入等级限制
-record(config_darak_bribe_scene_lv, {
    scene_id = 0,
    min_rate = 0,
    max_rate = 0,
    lv_min = 0,
    t_ids = [],  %% 触发的任务
    mon_list = [],
    xy = []      %%出生复活点
}).


-record(cross_dark_bribe_state, {
    scene_open_lv = [], %%场景开放等级配置
    server_dict = dict:new(), %%服务器信息
    max_lv = 0,
    sn_list = [],
    open_state = 0
}
).

%% 服务器信息
-record(server_info, {
    id = 0,     %%服务器ID
    rank = 0,   %%当前排名
    s_n = "",   %%服务器名称
    plv = 0,
    p_list = [],%%参与人数列表
    t_val = 0,  %%占领值
    time = 0,   %%
    task_list = [],%%数据统计任务列表{type,num}
    is_change = 0
}).


%% 玩家信息
-record(player_info, {
    id = 0,         %%玩家ID
    rank = 0,
    nick_name = "", %%玩家名称
    kill_p_num = 0, %% 杀人数量
    kill_m_num = 0, %% 杀怪数量
    t_val = 0,      %% 占领值
    sn = 0,         %% 服务器ID
    time = 0,
    get_task_ids = [],   %% 以领取的任务列表
    task_list = [],      %% 任务列表
    is_change = 0
}).


%% 占领值
-define(KILL_MON_ADD_VAL, 1).
-define(KILL_PLAYER_ADD_VAL, 5).


%%任务类型
-define(TASK_PLAYER, 1). %%个人任务
-define(TASK_SERVER, 2). %%服务器任务


%% 个人任务子类型
-define(TASK_SUB_TYPE_P_KILL_MON, 1).
-define(TASK_SUB_TYPE_P_KILL_PLAYER, 2).

%%服务器任务子类型
-define(TASK_SUB_TYPE_KILL_MON, 3).
-define(TASK_SUB_TYPE_KILL_PLAYER, 4).
-define(TASK_SUBTYPE_TAKE_VALUE, 5).

%% 发送传闻的占领值
-define(SEND_TV_INIT_VAL,10000).
-define(SEND_TV_INIT_ADD_VAL,10000).






