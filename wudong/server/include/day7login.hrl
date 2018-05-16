%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 下午4:39
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-record(st_day7, {
    pkey = 0,  %%玩家key
    day_list = [],  %%每天数据 [{Days,State,Time}] State:1已领取2可领取3不可领取 Time:领取时间
    time = 0  %%更新时间
}).


%%-record(base_day7,{
%%    days = 0,  %%天数
%%    gift_id = 0,  %%礼包id
%%    gold = 0,  %%礼包价值
%%    get_icon = 0,  %%可领取时的图标id
%%    un_get_icon = 0  %%不可领取时的图标id
%%}).


-record(base_day7, {
    days = 0,  %%天数
    goods_list = []  %% 奖励物品列表
  %%  get_icon = 0,  %%可领取时的图标id
  %%  un_get_icon = 0  %%不可领取时的图标id
}).










