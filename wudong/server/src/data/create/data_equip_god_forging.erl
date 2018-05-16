%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_equip_god_forging
	%%% @Created : 2017-08-28 14:53:11
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_equip_god_forging).
-export([get/2]).
-export([subtype_god_forging_lim/1]).
-export([ids/0]).
-export([max_stren/0]).
-include("error_code.hrl").
-include("equip.hrl").

    ids() ->
    [7,2,130,6,5,1,3,4].

    max_stren() ->5 .
subtype_god_forging_lim(7) ->5;
subtype_god_forging_lim(2) ->5;
subtype_god_forging_lim(130) ->5;
subtype_god_forging_lim(6) ->5;
subtype_god_forging_lim(5) ->5;
subtype_god_forging_lim(1) ->5;
subtype_god_forging_lim(3) ->5;
subtype_god_forging_lim(4) ->5;
subtype_god_forging_lim(_) ->0.
get(7,1) -> #base_equip_god_forging{subtype = 7, strength = 1, goods_id = 2014001, num = 10, attrs = [{att,2000}]};
get(7,2) -> #base_equip_god_forging{subtype = 7, strength = 2, goods_id = 2014001, num = 30, attrs = [{att,5000}]};
get(7,3) -> #base_equip_god_forging{subtype = 7, strength = 3, goods_id = 2014001, num = 50, attrs = [{att,8000}]};
get(7,4) -> #base_equip_god_forging{subtype = 7, strength = 4, goods_id = 2014001, num = 100, attrs = [{att,12000}]};
get(7,5) -> #base_equip_god_forging{subtype = 7, strength = 5, goods_id = 2014001, num = 150, attrs = [{att,15000}]};
get(2,1) -> #base_equip_god_forging{subtype = 2, strength = 1, goods_id = 2014001, num = 10, attrs = [{att,2000}]};
get(2,2) -> #base_equip_god_forging{subtype = 2, strength = 2, goods_id = 2014001, num = 30, attrs = [{att,5000}]};
get(2,3) -> #base_equip_god_forging{subtype = 2, strength = 3, goods_id = 2014001, num = 50, attrs = [{att,8000}]};
get(2,4) -> #base_equip_god_forging{subtype = 2, strength = 4, goods_id = 2014001, num = 100, attrs = [{att,12000}]};
get(2,5) -> #base_equip_god_forging{subtype = 2, strength = 5, goods_id = 2014001, num = 150, attrs = [{att,15000}]};
get(130,1) -> #base_equip_god_forging{subtype = 130, strength = 1, goods_id = 2014001, num = 10, attrs = [{att,2000}]};
get(130,2) -> #base_equip_god_forging{subtype = 130, strength = 2, goods_id = 2014001, num = 30, attrs = [{att,5000}]};
get(130,3) -> #base_equip_god_forging{subtype = 130, strength = 3, goods_id = 2014001, num = 50, attrs = [{att,8000}]};
get(130,4) -> #base_equip_god_forging{subtype = 130, strength = 4, goods_id = 2014001, num = 100, attrs = [{att,12000}]};
get(130,5) -> #base_equip_god_forging{subtype = 130, strength = 5, goods_id = 2014001, num = 150, attrs = [{att,15000}]};
get(6,1) -> #base_equip_god_forging{subtype = 6, strength = 1, goods_id = 2014001, num = 10, attrs = [{def,2000}]};
get(6,2) -> #base_equip_god_forging{subtype = 6, strength = 2, goods_id = 2014001, num = 30, attrs = [{def,5000}]};
get(6,3) -> #base_equip_god_forging{subtype = 6, strength = 3, goods_id = 2014001, num = 50, attrs = [{def,8000}]};
get(6,4) -> #base_equip_god_forging{subtype = 6, strength = 4, goods_id = 2014001, num = 100, attrs = [{def,12000}]};
get(6,5) -> #base_equip_god_forging{subtype = 6, strength = 5, goods_id = 2014001, num = 150, attrs = [{def,15000}]};
get(5,1) -> #base_equip_god_forging{subtype = 5, strength = 1, goods_id = 2014001, num = 10, attrs = [{def,2000}]};
get(5,2) -> #base_equip_god_forging{subtype = 5, strength = 2, goods_id = 2014001, num = 30, attrs = [{def,5000}]};
get(5,3) -> #base_equip_god_forging{subtype = 5, strength = 3, goods_id = 2014001, num = 50, attrs = [{def,8000}]};
get(5,4) -> #base_equip_god_forging{subtype = 5, strength = 4, goods_id = 2014001, num = 100, attrs = [{def,12000}]};
get(5,5) -> #base_equip_god_forging{subtype = 5, strength = 5, goods_id = 2014001, num = 150, attrs = [{def,15000}]};
get(1,1) -> #base_equip_god_forging{subtype = 1, strength = 1, goods_id = 2014001, num = 10, attrs = [{hp_lim,20000}]};
get(1,2) -> #base_equip_god_forging{subtype = 1, strength = 2, goods_id = 2014001, num = 30, attrs = [{hp_lim,50000}]};
get(1,3) -> #base_equip_god_forging{subtype = 1, strength = 3, goods_id = 2014001, num = 50, attrs = [{hp_lim,80000}]};
get(1,4) -> #base_equip_god_forging{subtype = 1, strength = 4, goods_id = 2014001, num = 100, attrs = [{hp_lim,120000}]};
get(1,5) -> #base_equip_god_forging{subtype = 1, strength = 5, goods_id = 2014001, num = 150, attrs = [{hp_lim,150000}]};
get(3,1) -> #base_equip_god_forging{subtype = 3, strength = 1, goods_id = 2014001, num = 10, attrs = [{hp_lim,20000}]};
get(3,2) -> #base_equip_god_forging{subtype = 3, strength = 2, goods_id = 2014001, num = 30, attrs = [{hp_lim,50000}]};
get(3,3) -> #base_equip_god_forging{subtype = 3, strength = 3, goods_id = 2014001, num = 50, attrs = [{hp_lim,80000}]};
get(3,4) -> #base_equip_god_forging{subtype = 3, strength = 4, goods_id = 2014001, num = 100, attrs = [{hp_lim,120000}]};
get(3,5) -> #base_equip_god_forging{subtype = 3, strength = 5, goods_id = 2014001, num = 150, attrs = [{hp_lim,150000}]};
get(4,1) -> #base_equip_god_forging{subtype = 4, strength = 1, goods_id = 2014001, num = 10, attrs = [{hp_lim,20000}]};
get(4,2) -> #base_equip_god_forging{subtype = 4, strength = 2, goods_id = 2014001, num = 30, attrs = [{hp_lim,50000}]};
get(4,3) -> #base_equip_god_forging{subtype = 4, strength = 3, goods_id = 2014001, num = 50, attrs = [{hp_lim,80000}]};
get(4,4) -> #base_equip_god_forging{subtype = 4, strength = 4, goods_id = 2014001, num = 100, attrs = [{hp_lim,120000}]};
get(4,5) -> #base_equip_god_forging{subtype = 4, strength = 5, goods_id = 2014001, num = 150, attrs = [{hp_lim,150000}]};
get(_,_) -> #base_equip_god_forging{}.
