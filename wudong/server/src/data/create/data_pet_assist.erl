%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_assist
	%%% @Created : 2018-05-09 14:50:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_assist).
-export([get_lv/1]).
-export([get_attrs/1]).
-include("common.hrl").
get_lv(1) ->40;
get_lv(2) ->60;
get_lv(3) ->80;
get_lv(4) ->90;
get_lv(5) ->95;
get_lv(6) ->100;
get_lv(7) ->1;
get_lv(_) -> 9999.
get_attrs(1) ->[{att,50},{def,25},{hp_lim,500}];
get_attrs(2) ->[{att,100},{def,50},{hp_lim,1000}];
get_attrs(3) ->[{att,300},{def,150},{hp_lim,3000}];
get_attrs(4) ->[{att,300},{def,150},{hp_lim,3000}];
get_attrs(5) ->[{att,400},{def,200},{hp_lim,4000}];
get_attrs(6) ->[{att,800},{def,400},{hp_lim,8000}];
get_attrs(7) ->[{att,50},{def,25},{hp_lim,500}];
get_attrs(_) -> [].
