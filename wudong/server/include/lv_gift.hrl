%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 下午8:23
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-record(st_lv_gift, {
    pkey = 0,
    get_list = [],  %%已经领取等级列表
    time = 0  %%最后领取时间s
}).

%%玩家礼包领取状态
-record(st_res_gift, {
    pkey = 0,       %%玩家KEY,
    gift_state = [],  %% 玩家礼包状态列表
    praise_gift = 0,
    is_get = 0,
    is_change = 0   %%
}).