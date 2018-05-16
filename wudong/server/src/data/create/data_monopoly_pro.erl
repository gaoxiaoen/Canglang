%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_monopoly_pro
	%%% @Created : 2016-07-27 11:41:27
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_monopoly_pro).
-export([get/1]).
-export([get_all/0]).
-include("monopoly.hrl").
-include("common.hrl").
  get(1) -> #base_monopoly_pro{num=1,pro=1700 };
  get(2) -> #base_monopoly_pro{num=2,pro=1900 };
  get(3) -> #base_monopoly_pro{num=3,pro=1900 };
  get(4) -> #base_monopoly_pro{num=4,pro=1600 };
  get(5) -> #base_monopoly_pro{num=5,pro=1500 };
  get(6) -> #base_monopoly_pro{num=6,pro=1400 };
get(_) -> [].
get_all()->[1,2,3,4,5,6].

