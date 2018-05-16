%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2017 下午8:01
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(ETS_ANSWER_PLAYER, ets_answer_player).  %%答题玩家ets

-define(ANSWER_OPEN_LV, 45).  %%开启等级
-define(COPY_MAX_PLAYER_NUM, 20).  %%单个房间最多人数
-define(QUESTION_READY_TIME, 5).  %%每道题准备时间
-define(QUESTION_RESULT_TIME, 20).  %%每道题公布答案时间
%% -define(QUESTION_READY_TIME, 2).  %%每道题准备时间
%% -define(QUESTION_RESULT_TIME, 4).  %%每道题公布答案时间
-define(QUESTION_NUM, 30). %%一共30道题
-define(DAOJU_USE_TIMES, 2).  %%每类型道具能使用次数
-define(DAOJU_MUST_RIGHT, 1).  %%道具必中
-define(DAOJU_DOUBLE_POINT, 2).  %%道具双倍积分

-define(ANSWER_SCENE_XY_1, {9, 26}).  %%场景答案1 出生点
-define(ANSWER_SCENE_XY_2, {23, 27}).  %%场景答案2 出生点

-record(answer_st, {
    state = 0  %%状态 0未开启 1已开启 2准备中
    , start_time = 0
    , end_time = 0
    , end_ref = 0
    , copy_list = []  %%房间人数统计 [{copy,num}]
    , ready_ref = 0  %%每道题的准备计时器
    , result_ref = 0  %%每道题公布结果计时器
    , question_list = []  %%已出的题目列表 [id]
    , question_time = 0  %%提问时间
    , question_num = 0
}).

-record(a_pinfo, {
    pkey = 0,
    name = "",
    lv = 0,
    career = 0,
    sex = 0,
    gkey = 0,
    node = none,
    sid = 0,

    copy = 0,   %%房间
    question_id = 0,  %%回答的题目id
    my_answer = 0,  %%下道题的答案选择
    answer_time = 0,  %%下道题的回答时间
    point = 0,  %%积分
    exp = 0,    %%获得经验
    right_num = 0,  %%答对题数
    right_combo = 0,%%连对
    cur_use_type = 0,  %%使用的道具类型 1必中 2双倍
    use_type_list = []  %%当前使用的道具列表 [{type,usenum}]
}).


-record(base_question, {
    id = 0,
    answer = 0  %%答案 1 2
}).