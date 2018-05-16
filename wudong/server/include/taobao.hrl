%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 下午12:09
%%%-------------------------------------------------------------------
-author("and_me").
-record(base_taobao_config,{type = 1,gold = 450,bind_gold = 95,cd_time = 10,max_times = 604800}).
-record(base_taobao,{id = 1,goods_id = 1,luck_value = 10,storage = 1,show_pos = 1,weight = 2}).
-record(taobao_info,{pkey = 0,luck_value = 0,times = [],refresh_times = [],recently_goods = []}).
-define(ETS_TAOBAO_RECORD,ets_taobao_record).