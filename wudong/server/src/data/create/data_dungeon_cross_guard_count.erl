%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_cross_guard_count
	%%% @Created : 2017-11-22 21:09:23
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_cross_guard_count).
-export([get/1]).
-export([get/2]).
-include("dungeon.hrl").
  get(Lv) when Lv =< 120 ->{120 ,3};
  get(Lv) when Lv =< 150 ->{150 ,4};
  get(Lv) when Lv =< 180 ->{180 ,5};
  get(Lv) when Lv =< 999 ->{999 ,6};
get(_) -> [].
  get(Lv,3) when Lv =< 120-> [{10106,50},{7405001,5},{7415001,2}] ;
  get(Lv,4) when Lv =< 150-> [{10106,80},{7405001,6},{7415001,3}] ;
  get(Lv,5) when Lv =< 180-> [{8001651,1},{10106,90},{7405001,5},{7415001,4}] ;
  get(Lv,6) when Lv =< 999-> [{8001651,1},{10106,100},{7405001,6},{7415001,5}] ;
get(_,_) -> [].
