%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十月 2017 15:48
%%%-------------------------------------------------------------------
-author("lzx").
-include("server.hrl").


-record(base_fashion_suit, {
    suit_id = 0,
    tar_list = [],
    attrs = [],
    active_num = 0,
    suit_name = ""
}).



-record(base_goods_to_suit, {
    goodsId = 0,
    suitId = [],
    funid = []
}).


%%
-record(st_fashion_suit, {
    pkey = 0,                    %% 玩家ID
    fashion_suit_ids = [],
    fashion_act_suit_ids = [],   %% [{id,激活等级}]
    attribute = #attribute{},   %% 总属性
    skill_list = [],
    cbp = 0,                     %% 总战力
    is_change = 0                %% 数据是否改变
}).


-record(base_fashion_suit_star, {
    suit_id = 0,
    lv = 0,
    attrs = [],
    skill = 0
}).

