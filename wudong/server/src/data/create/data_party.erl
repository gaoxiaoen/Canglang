%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_party
	%%% @Created : 2017-09-08 17:27:47
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_party).
-export([get/1]).
-export([get_all/0]).
-include("party.hrl").
-include("common.hrl").
  get(1) -> #base_party{type=1,price_type=1,price=108,daily_times=1,table_num = 5,guest_num = 120,desc =?T("温馨酒宴"),master_goods = {{7206001,30}},master_goods_ratio = {{7302001,3}},guest_goods = {{7206001,1}},eat_times = 1,table_list = [{45104,58,80},{45104,61,76},{45104,61,83},{45104,65,79},{45104,66,85}],exp_add = 0.03};
  get(2) -> #base_party{type=2,price_type=1,price=188,daily_times=1,table_num = 5,guest_num = 120,desc =?T("高级酒宴"),master_goods = {{7206001,50}},master_goods_ratio = {{7302001,8}},guest_goods = {{7206001,1}},eat_times = 1,table_list = [{45105,9,29},{45105,13,26},{45105,17,22},{45105,20,19},{45105,24,15}],exp_add = 0.03};
  get(3) -> #base_party{type=3,price_type=2,price=288,daily_times=1,table_num = 5,guest_num = 120,desc =?T("豪华酒宴"),master_goods = {{7206001,100}},master_goods_ratio = {{7302001,12},{7301001,30}},guest_goods = {{7206001,1}},eat_times = 1,table_list = [{45106,42,99},{45106,49,99},{45106,51,106},{45106,44,109},{45106,40,105}],exp_add = 0.03};
  get(4) -> #base_party{type=4,price_type=2,price=388,daily_times=1,table_num = 5,guest_num = 120,desc =?T("海天盛宴"),master_goods = {{7206001,200}},master_goods_ratio = {{7302001,20},{7301001,30}},guest_goods = {{7206001,1}},eat_times = 1,table_list = [{45107,35,75},{45107,41,70},{45107,48,63},{45107,54,57},{45107,60,50}],exp_add = 0.03};
get(_) -> [].
get_all()->[1,2,3,4].

