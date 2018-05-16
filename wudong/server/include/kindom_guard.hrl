%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 王城守卫
%%% @end
%%% Created : 24. 一月 2017 下午4:57
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(MAX_DUN_NUM, 10).
-define(KINDOM_BUFF_ID_LIST, [53001, 53002, 53003]).  %%战意buff

-define(OPEN_TIME_LIST, [
    {1,{16,0}},
    {2,{16,0}},
    {3,{16,0}},
    {4,{16,0}},
    {5,{16,0}},
    {6,{16,0}},
    {7,{16,0}}]).
-define(KINDOM_GUARD_OPEN_TIME, 1800).  %%活动时长

-define(KINDOM_GUARD_DEFORE_NOTICE_TIME, 1800).  %%开启前公告时间

-define(KINDOM_NOTICE_STATE_SUCCESS, 0). %%胜利
-define(KINDOM_NOTICE_STATE_TIME_END, -1). %%时间结束
-define(KINDOM_NOTICE_STATE_KILL, -2). %%守卫被杀


-record(kindom_guard,{
    copy_list = [] %%副本列表 [{DunPid,PlayerNum}]
    ,player_list = []  %%参与玩家的房间信息 [{pkey,DunPid}]
    , state = 0  %%状态 0未开始 1已开始 2准备开始
    ,start_time = 0
    ,end_time = 0
    ,end_ref = 0
    ,buff_player = []  %%战意buff 玩家 [{type,pkey,pname,state}] type:1盟主、2战神、3状元 state:0没进来 1已进来
}).

-record(base_mon_drop_box,{
    mon_id = 0
    , box_list = []
    , ratio = 0     %%创建宝箱的概率  100代表万分之100
    , is_notice = 0
}).
