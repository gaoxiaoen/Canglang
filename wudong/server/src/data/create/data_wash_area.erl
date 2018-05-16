%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_area
	%%% @Created : 2017-06-21 16:44:14
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_area).
-export([area_list/0]).
-export([last_area/1]).
-export([area_times/1]).
-export([color_ratio/1]).
-include("error_code.hrl").

    area_list() ->
    [1,2,3,4].
last_area(Times) when Times >= 0 andalso Times =< 1000   ->1;
last_area(Times) when Times >= 1001 andalso Times =< 2000   ->2;
last_area(Times) when Times >= 2001 andalso Times =< 3000   ->3;
last_area(Times) when Times >= 3001 andalso Times =< 9999999   ->4;
last_area(_Data) -> 1.
area_times(1) ->20;
area_times(2) ->15;
area_times(3) ->50;
area_times(4) ->999999;
area_times(_Data) -> 0.
color_ratio(1) ->[{1,6824},{2,3000},{3,170},{4,5},{5,1}];
color_ratio(2) ->[{1,5555},{2,4000},{3,200},{4,240},{5,5}];
color_ratio(3) ->[{1,4520},{2,5000},{3,250},{4,150},{5,250}];
color_ratio(4) ->[{1,0},{2,0},{3,0},{4,0},{5,1}];
color_ratio(_Data) -> [].
