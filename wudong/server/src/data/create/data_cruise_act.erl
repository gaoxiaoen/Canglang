%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cruise_act
	%%% @Created : 2017-09-13 16:44:56
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cruise_act).
-export([get/1]).
-export([get_all/0]).
-include("marry.hrl").
-include("common.hrl").
  get(1) -> #base_cruise{type=1,price_type=1,price=30,goods_id=7204001,num=1};
  get(2) -> #base_cruise{type=2,price_type=2,price=50,goods_id=7202004,num=1};
  get(3) -> #base_cruise{type=3,price_type=0,price=0,goods_id=7201001,num=1};
  get(4) -> #base_cruise{type=4,price_type=0,price=0,goods_id=7201002,num=1};
  get(5) -> #base_cruise{type=5,price_type=2,price=10,goods_id=7202001,num=1};
  get(6) -> #base_cruise{type=6,price_type=2,price=20,goods_id=7202002,num=1};
  get(7) -> #base_cruise{type=7,price_type=2,price=30,goods_id=7202003,num=1};
  get(8) -> #base_cruise{type=8,price_type=2,price=10,goods_id=7205002,num=1};
get(_) -> [].
get_all()->[1,2,3,4,5,6,7,8].

