%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_feixian_lian
	%%% @Created : 2018-05-03 16:44:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_feixian_lian).
-export([get_attr_num/1]).
-export([get_random_list/1]).
-export([get_maxNum_by_color/1]).
-include("xian.hrl").

%%获取属性条数随机列表 
get_attr_num(2) -> [{0,500},{1,500}];
get_attr_num(3) -> [{0,500},{1,500},{2,400},{3,300}];
get_attr_num(4) -> [{0,500},{1,400},{2,300},{3,200},{4,100},{5,10}];
get_attr_num(5) -> [{0,500},{1,400},{2,300},{3,200},{4,100},{5,10},{6,10}];
get_attr_num(_color) -> [].


%%获取属性品质随机列表 
get_random_list(2) -> [{1,120},{2, 150},{3, 200}];
get_random_list(3) -> [{2, 150},{3, 200},{4, 200},{5, 150}];
get_random_list(4) -> [{3, 200},{4, 200},{5, 150},{6, 100},{7, 50}];
get_random_list(5) -> [{6, 100},{7, 50},{8, 30}];
get_random_list(_color) -> [].

get_maxNum_by_color(2) -> 1;
get_maxNum_by_color(3) -> 3;
get_maxNum_by_color(4) -> 5;
get_maxNum_by_color(5) -> 6;
get_maxNum_by_color(_color) -> 0.

