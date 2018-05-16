%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_marry
	%%% @Created : 2017-09-13 16:44:56
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_marry).
-export([get/1]).
-export([get_all/0]).
-include("marry.hrl").
-include("common.hrl").
  get(1) -> #base_marry{type=1,price={bgold,199},close=99,goods_list=[{6601009,1},{6603050,1}],cruise=0,cruise_price=600};
  get(2) -> #base_marry{type=2,price={gold,520},close=99,goods_list=[{6601010,1},{6603051,1}],cruise=0,cruise_price=600};
  get(3) -> #base_marry{type=3,price={gold,1314},close=99,goods_list=[{6601011,1},{6603052,1}],cruise=1,cruise_price=600};
get(_) -> [].
get_all()->[1,2,3].

