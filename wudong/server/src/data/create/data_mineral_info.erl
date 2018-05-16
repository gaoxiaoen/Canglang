%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mineral_info
	%%% @Created : 2018-05-14 22:18:13
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mineral_info).
-export([get/1]).
-export([get_all/0]).
-export([get_ratio/1]).
-export([get_event_ratio/0]).
-include("cross_mining.hrl").
-include("common.hrl").
-include("activity.hrl").
get(1) -> 
   #base_mineral_info{type = 1 ,desc = ?T("普通晶矿") ,life_time = 300 ,ripe_time = 300 ,cbp_limit = 2000000 ,hp_lim = 5 ,att_hp = [{0,120,1},{121,200,2},{201,999999,3}] ,reward = {60, [{1024001, 100}]} ,re_ratio = [{1,40},{2,30},{3,10}] ,event_ratio = 20 ,help_limit = 1};
get(2) -> 
   #base_mineral_info{type = 2 ,desc = ?T("精英晶矿") ,life_time = 900 ,ripe_time = 900 ,cbp_limit = 3000000 ,hp_lim = 7 ,att_hp = [{0,200,1},{201,500,2},{501,999999,3}] ,reward = {60, [{1024001, 200}]} ,re_ratio = [{1,30},{2,30},{3,20}] ,event_ratio = 25 ,help_limit = 2};
get(3) -> 
   #base_mineral_info{type = 3 ,desc = ?T("完美晶矿") ,life_time = 1800 ,ripe_time = 1800 ,cbp_limit = 4000000 ,hp_lim = 9 ,att_hp = [{0,240,1},{241,600,2},{601,999999,3}] ,reward = {60, [{1024001, 300}]} ,re_ratio = [{1,10},{2,10},{3,40}] ,event_ratio = 30 ,help_limit = 3};
get(4) -> 
   #base_mineral_info{type = 4 ,desc = ?T("神遗晶矿") ,life_time = 3600 ,ripe_time = 3600 ,cbp_limit = 5000000 ,hp_lim = 10 ,att_hp = [{0,300,1},{301,800,2},{801,999999,3}] ,reward = {60, [{1024001, 400}]} ,re_ratio = [{1,5},{2,8},{3,10}] ,event_ratio = 40 ,help_limit = 3};
get(5) -> 
   #base_mineral_info{type = 5 ,desc = ?T("圣晶核心") ,life_time = 6000 ,ripe_time = 6000 ,cbp_limit = 6000000 ,hp_lim = 12 ,att_hp = [{0,300,1},{301,900,2},{901,999999,3}] ,reward = {60, [{1024001, 450}]} ,re_ratio = [{1,2},{2,5},{3,8}] ,event_ratio = 50 ,help_limit = 3};
get(_) -> [].


get_ratio(1)-> [{1,40},{2,30},{3,10}];
get_ratio(2)-> [{1,30},{2,30},{3,20}];
get_ratio(3)-> [{1,10},{2,10},{3,40}];
get_ratio(4)-> [{1,5},{2,8},{3,10}];
get_ratio(5)-> [{1,2},{2,5},{3,8}];
get_ratio(_) -> [].


get_all() ->[ 1, 2, 3, 4, 5].
get_event_ratio() ->[{1,20},{2,25},{3,30},{4,40},{5,50}].
