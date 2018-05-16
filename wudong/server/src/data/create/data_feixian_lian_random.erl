%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_feixian_lian_random
	%%% @Created : 2018-05-03 16:44:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_feixian_lian_random).
-export([get_by_attr/1]).
-export([get_all/0]).
-include("xian.hrl").
get_by_attr(att) -> [{1,120,200},{2,320,480},{3,500,700},{4,800,1200},{5,1800,2200},{6,2500,3500},{7,4500,5500},{8,6000,8000}];
get_by_attr(hp_lim) -> [{1,1200,2000},{2,3200,4800},{3,5000,7000},{4,8000,12000},{5,18000,22000},{6,25000,35000},{7,45000,55000},{8,60000,80000}];
get_by_attr(def) -> [{1,120,200},{2,320,480},{3,500,700},{4,800,1200},{5,1800,2200},{6,2500,3500},{7,4500,5500},{8,6000,8000}];
get_by_attr(crit) -> [{1,25,75},{2,100,160},{3,150,250},{4,280,360},{5,600,750},{6,850,1150},{7,1400,1875},{8,2000,2600}];
get_by_attr(ten) -> [{1,25,75},{2,100,160},{3,150,250},{4,280,360},{5,600,750},{6,850,1150},{7,1400,1875},{8,2000,2600}];
get_by_attr(hit) -> [{1,25,75},{2,100,160},{3,150,250},{4,280,360},{5,600,750},{6,850,1150},{7,1400,1875},{8,2000,2600}];
get_by_attr(dodge) -> [{1,25,75},{2,100,160},{3,150,250},{4,280,360},{5,600,750},{6,850,1150},{7,1400,1875},{8,2000,2600}];
get_by_attr(_attr) -> [].

get_all() -> [att,hp_lim,def,crit,ten,hit,dodge].
