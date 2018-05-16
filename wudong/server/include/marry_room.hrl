%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 七月 2017 20:26
%%%-------------------------------------------------------------------
-author("li").

-record(sys_marry_room,{

}).

-record(st_marry_room,{
    pkey = 0,
    rp_val = 0, %% 人气值
    qm_val = 0, %% 亲密度
    is_marry = 0, %% 是否介乎
    love_desc = <<>>, %% 爱情宣言
    love_desc_type = 0, %% 爱情宣言类型
    love_desc_time = 0, %% 爱情宣言有效时间
    my_look = [], %% 我的关注
    my_face = [], %% 我的粉丝
    is_first_photo = 0 %% 是否在房间里设置头像
}).

-record(ets_marry_room,{
    pkey = 0,
    nickname = <<>>, %% 昵称
    career = 0, %% 职业
    sex = 0, %% 性别
    avatar = <<>>, %% 自定义头像
    vip_lv = 0, %% VIP等级
    rp_val = 0, %% 人气值
    qm_val = 0, %% 亲密度
    is_first_photo = 0,%% 是否在房间里设置头像
    is_marry = 0, %% 是否介乎
    love_desc = <<>>, %% 爱情宣言
    love_desc_type = 0, %% 爱情宣言类型 0普通1豪华
    love_desc_time = 0, %% 爱情宣言有效时间
    my_look = [], %% 我的关注
    my_face = [], %% 我的粉丝
    pid = null, %% 玩家进程
    sid = null,
    online = 0 %% 1在线0下线
}).

-define(ETS_MARRY_ROOM, ets_marry_room).
-define(MARRY_ROOM_LOVE_DESC_0, 30). %% 普通宣言花费30绑元
-define(MARRY_ROOM_LOVE_DESC_1, 50). %% 豪华宣言花费30元宝
-define(MARRY_PAGE_TOTAL_NUM, 20). %% 1页15条
-define(MARRY_LOVE_QMDVAL, 99). %% 表白亲密度值
