%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 三月 2018 下午2:10
%%%-------------------------------------------------------------------
-author("luobaqun").

-record(st_awake, {
    pkey = 0,
    type = 0, %%
    cell = 0,
    attr = []
}).

-record(base_awake,{
   type=0,
    cell=0,
    up_limit1 = [],
    up_limit2 = [],
    awake_limit =[],
    lv_top = 0,
    desc = "",
    awake_attr = [],
    attr=[]
}).
