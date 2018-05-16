%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_colour
	%%% @Created : 2016-09-13 15:58:36
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_colour).
-export([get/3]).
-include("server.hrl").
get(def,1,Value) when Value >= 1 andalso Value =< 5-> 1;
get(hp_lim,1,Value) when Value >= 1 andalso Value =< 75-> 1;
get(att,1,Value) when Value >= 1 andalso Value =< 5-> 1;
get(def,1,Value) when Value >= 6 andalso Value =< 15-> 2;
get(hp_lim,1,Value) when Value >= 76 andalso Value =< 225-> 2;
get(att,1,Value) when Value >= 6 andalso Value =< 15-> 2;
get(def,1,Value) when Value >= 16 andalso Value =< 25-> 3;
get(hp_lim,1,Value) when Value >= 226 andalso Value =< 375-> 3;
get(att,1,Value) when Value >= 16 andalso Value =< 25-> 3;
get(hp_lim,1,Value) when Value >= 750 andalso Value =< 750-> 4;
get(att,1,Value) when Value >= 50 andalso Value =< 50-> 4;
get(def,11,Value) when Value >= 1 andalso Value =< 5-> 1;
get(hp_lim,11,Value) when Value >= 1 andalso Value =< 75-> 1;
get(att,11,Value) when Value >= 1 andalso Value =< 5-> 1;
get(def,11,Value) when Value >= 6 andalso Value =< 15-> 2;
get(hp_lim,11,Value) when Value >= 76 andalso Value =< 225-> 2;
get(att,11,Value) when Value >= 6 andalso Value =< 15-> 2;
get(def,11,Value) when Value >= 16 andalso Value =< 25-> 3;
get(hp_lim,11,Value) when Value >= 226 andalso Value =< 375-> 3;
get(att,11,Value) when Value >= 16 andalso Value =< 25-> 3;
get(hp_lim,11,Value) when Value >= 750 andalso Value =< 750-> 4;
get(att,11,Value) when Value >= 50 andalso Value =< 50-> 4;
get(def,41,Value) when Value >= 1 andalso Value =< 5-> 1;
get(hp_lim,41,Value) when Value >= 1 andalso Value =< 75-> 1;
get(att,41,Value) when Value >= 1 andalso Value =< 5-> 1;
get(def,41,Value) when Value >= 6 andalso Value =< 15-> 2;
get(hp_lim,41,Value) when Value >= 76 andalso Value =< 225-> 2;
get(att,41,Value) when Value >= 6 andalso Value =< 15-> 2;
get(def,41,Value) when Value >= 16 andalso Value =< 25-> 3;
get(hp_lim,41,Value) when Value >= 226 andalso Value =< 375-> 3;
get(att,41,Value) when Value >= 16 andalso Value =< 25-> 3;
get(hp_lim,41,Value) when Value >= 750 andalso Value =< 750-> 4;
get(att,41,Value) when Value >= 50 andalso Value =< 50-> 4;
get(def,51,Value) when Value >= 1 andalso Value =< 10-> 1;
get(hp_lim,51,Value) when Value >= 1 andalso Value =< 150-> 1;
get(att,51,Value) when Value >= 1 andalso Value =< 10-> 1;
get(def,51,Value) when Value >= 11 andalso Value =< 30-> 2;
get(hp_lim,51,Value) when Value >= 151 andalso Value =< 450-> 2;
get(att,51,Value) when Value >= 11 andalso Value =< 30-> 2;
get(def,51,Value) when Value >= 31 andalso Value =< 50-> 3;
get(hp_lim,51,Value) when Value >= 451 andalso Value =< 750-> 3;
get(att,51,Value) when Value >= 31 andalso Value =< 50-> 3;
get(hp_lim,51,Value) when Value >= 1500 andalso Value =< 1500-> 4;
get(att,51,Value) when Value >= 100 andalso Value =< 100-> 4;
get(def,61,Value) when Value >= 1 andalso Value =< 20-> 1;
get(hp_lim,61,Value) when Value >= 1 andalso Value =< 300-> 1;
get(att,61,Value) when Value >= 1 andalso Value =< 20-> 1;
get(def,61,Value) when Value >= 21 andalso Value =< 60-> 2;
get(hp_lim,61,Value) when Value >= 301 andalso Value =< 900-> 2;
get(att,61,Value) when Value >= 21 andalso Value =< 60-> 2;
get(def,61,Value) when Value >= 61 andalso Value =< 100-> 3;
get(hp_lim,61,Value) when Value >= 901 andalso Value =< 1500-> 3;
get(att,61,Value) when Value >= 61 andalso Value =< 100-> 3;
get(hp_lim,61,Value) when Value >= 3000 andalso Value =< 3000-> 4;
get(att,61,Value) when Value >= 200 andalso Value =< 200-> 4;
get(def,71,Value) when Value >= 1 andalso Value =< 40-> 1;
get(hp_lim,71,Value) when Value >= 1 andalso Value =< 600-> 1;
get(att,71,Value) when Value >= 1 andalso Value =< 40-> 1;
get(def,71,Value) when Value >= 41 andalso Value =< 120-> 2;
get(hp_lim,71,Value) when Value >= 601 andalso Value =< 1800-> 2;
get(att,71,Value) when Value >= 41 andalso Value =< 120-> 2;
get(def,71,Value) when Value >= 121 andalso Value =< 200-> 3;
get(hp_lim,71,Value) when Value >= 1801 andalso Value =< 3000-> 3;
get(att,71,Value) when Value >= 121 andalso Value =< 200-> 3;
get(hp_lim,71,Value) when Value >= 6000 andalso Value =< 6000-> 4;
get(att,71,Value) when Value >= 400 andalso Value =< 400-> 4;
get(def,81,Value) when Value >= 1 andalso Value =< 60-> 1;
get(hp_lim,81,Value) when Value >= 1 andalso Value =< 600-> 1;
get(att,81,Value) when Value >= 1 andalso Value =< 60-> 1;
get(def,81,Value) when Value >= 61 andalso Value =< 180-> 2;
get(def,81,Value) when Value >= 61 andalso Value =< 180-> 2;
get(att,81,Value) when Value >= 61 andalso Value =< 180-> 2;
get(def,81,Value) when Value >= 181 andalso Value =< 300-> 3;
get(hp_lim,81,Value) when Value >= 1801 andalso Value =< 3000-> 3;
get(att,81,Value) when Value >= 181 andalso Value =< 300-> 3;
get(hp_lim,81,Value) when Value >= 6000 andalso Value =< 6000-> 4;
get(att,81,Value) when Value >= 600 andalso Value =< 600-> 4;
get(def,91,Value) when Value >= 1 andalso Value =< 80-> 1;
get(hp_lim,91,Value) when Value >= 1 andalso Value =< 800-> 1;
get(att,91,Value) when Value >= 1 andalso Value =< 80-> 1;
get(def,91,Value) when Value >= 81 andalso Value =< 240-> 2;
get(hp_lim,91,Value) when Value >= 801 andalso Value =< 2400-> 2;
get(att,91,Value) when Value >= 81 andalso Value =< 240-> 2;
get(def,91,Value) when Value >= 241 andalso Value =< 400-> 3;
get(hp_lim,91,Value) when Value >= 2401 andalso Value =< 4000-> 3;
get(att,91,Value) when Value >= 241 andalso Value =< 400-> 3;
get(hp_lim,91,Value) when Value >= 8000 andalso Value =< 8000-> 4;
get(att,91,Value) when Value >= 800 andalso Value =< 800-> 4;
get(def,101,Value) when Value >= 1 andalso Value =< 100-> 1;
get(hp_lim,101,Value) when Value >= 1 andalso Value =< 1000-> 1;
get(att,101,Value) when Value >= 1 andalso Value =< 100-> 1;
get(def,101,Value) when Value >= 101 andalso Value =< 300-> 2;
get(hp_lim,101,Value) when Value >= 1001 andalso Value =< 3000-> 2;
get(att,101,Value) when Value >= 101 andalso Value =< 300-> 2;
get(def,101,Value) when Value >= 301 andalso Value =< 500-> 3;
get(hp_lim,101,Value) when Value >= 3001 andalso Value =< 5000-> 3;
get(att,101,Value) when Value >= 301 andalso Value =< 500-> 3;
get(hp_lim,101,Value) when Value >= 10000 andalso Value =< 10000-> 4;
get(att,101,Value) when Value >= 1000 andalso Value =< 1000-> 4;
get(_,_,_) -> 0.