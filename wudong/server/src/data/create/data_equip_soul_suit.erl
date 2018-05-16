%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_equip_soul_suit
	%%% @Created : 2017-12-05 14:49:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_equip_soul_suit).
-export([ids/0]).
-export([max_lv/0]).
-export([get/1]).
-include("error_code.hrl").
-include("equip.hrl").

    ids() ->
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15].

    max_lv() ->
    15.
get(1) -> [{att,16},{def,9},{hp_lim,144}];
get(2) -> [{att,40},{def,24},{hp_lim,360}];
get(3) -> [{att,74},{def,44},{hp_lim,669}];
get(4) -> [{att,136},{def,82},{hp_lim,1231}];
get(5) -> [{att,254},{def,152},{hp_lim,2289}];
get(6) -> [{att,470},{def,282},{hp_lim,4233}];
get(7) -> [{att,870},{def,522},{hp_lim,7833}];
get(8) -> [{att,1610},{def,966},{hp_lim,14493}];
get(9) -> [{att,2980},{def,1788},{hp_lim,26820}];
get(10) -> [{att,5512},{def,3307},{hp_lim,49615}];
get(11) -> [{att,5600},{def,3360},{hp_lim,50400}];
get(12) -> [{att,5760},{def,3456},{hp_lim,51840}];
get(13) -> [{att,5920},{def,3552},{hp_lim,53280}];
get(14) -> [{att,6080},{def,3648},{hp_lim,54720}];
get(15) -> [{att,6400},{def,3840},{hp_lim,57600}];
get(_) -> [].