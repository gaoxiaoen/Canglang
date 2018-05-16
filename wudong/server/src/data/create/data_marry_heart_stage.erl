%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_marry_heart_stage
	%%% @Created : 2018-04-27 18:01:22
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_marry_heart_stage).
-export([stage_list/0]).
-export([get/1]).
-include("mount.hrl").
-include("common.hrl").


    stage_list() ->
    [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100].
get(Lv) when Lv >= 0 andalso Lv =< 4->0;
get(Lv) when Lv >= 5 andalso Lv =< 9->5;
get(Lv) when Lv >= 10 andalso Lv =< 14->10;
get(Lv) when Lv >= 15 andalso Lv =< 19->15;
get(Lv) when Lv >= 20 andalso Lv =< 24->20;
get(Lv) when Lv >= 25 andalso Lv =< 29->25;
get(Lv) when Lv >= 30 andalso Lv =< 34->30;
get(Lv) when Lv >= 35 andalso Lv =< 39->35;
get(Lv) when Lv >= 40 andalso Lv =< 44->40;
get(Lv) when Lv >= 45 andalso Lv =< 49->45;
get(Lv) when Lv >= 50 andalso Lv =< 54->50;
get(Lv) when Lv >= 55 andalso Lv =< 59->55;
get(Lv) when Lv >= 60 andalso Lv =< 64->60;
get(Lv) when Lv >= 65 andalso Lv =< 69->65;
get(Lv) when Lv >= 70 andalso Lv =< 74->70;
get(Lv) when Lv >= 75 andalso Lv =< 79->75;
get(Lv) when Lv >= 80 andalso Lv =< 84->80;
get(Lv) when Lv >= 85 andalso Lv =< 89->85;
get(Lv) when Lv >= 90 andalso Lv =< 94->90;
get(Lv) when Lv >= 95 andalso Lv =< 99->95;
get(Lv) when Lv >= 100 andalso Lv =< 200->100;
get(_) -> [].
