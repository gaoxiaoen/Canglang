%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2016 下午4:21
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-record(st_click,{
    pkey = 0,
    att_times = 0,  %%剩余攻击次数
    cd_time = 0,  %%cd开始时间
    %%---怪物信息
    mon_id = 0,  %%怪物id
    mon_hp = 0,  %%血量
    update_time = 0  %%每天增加攻击次数更新时间
}).

-record(base_click,{
    lv = 0,  %%玩家等级
    coin = 0,
    exp = 0,
    drop_id = 0
}).