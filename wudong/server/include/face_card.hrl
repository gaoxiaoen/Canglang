%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2018 16:39
%%%-------------------------------------------------------------------
-author("li").

-record(base_face_vip_card, {
    goods_id = 0
    , vip = 0
    , expire_time = 0
    , recycle_back = []
}).

-record(base_face_magic, {
    id = 0
    , icon = 0
    , name = ""
    , add_val = 0
    , consume1 = []
    , consume2 = []
}).

-record(face_vip_card, {
    pkey = 0
    , list = [] %% [{vip, time}]
}).