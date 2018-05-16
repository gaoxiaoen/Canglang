%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_hi_config
	%%% @Created : 2017-11-07 20:37:50
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_hi_config).
-export([get/1]).
-export([ids/0]).
-export([id_types/1]).
-include("activity.hrl").
-include("common.hrl").
get(1) -> 
   #base_hi_config{id = 1 ,desc = ?T("进阶副本") ,type = 1 ,fun_id = {25,1} ,val = 1 ,time_limit = 12 ,condition = []};
get(2) -> 
   #base_hi_config{id = 2 ,desc = ?T("剧情副本") ,type = 2 ,fun_id = {25,3} ,val = 1 ,time_limit = 5 ,condition = []};
get(4) -> 
   #base_hi_config{id = 4 ,desc = ?T("日常任务") ,type = 4 ,fun_id = {37,1} ,val = 1 ,time_limit = 20 ,condition = []};
get(5) -> 
   #base_hi_config{id = 5 ,desc = ?T("仙盟任务") ,type = 5 ,fun_id = {37,2} ,val = 1 ,time_limit = 20 ,condition = []};
get(6) -> 
   #base_hi_config{id = 6 ,desc = ?T("悬赏任务") ,type = 6 ,fun_id = {37,4} ,val = 1 ,time_limit = 10 ,condition = []};
get(7) -> 
   #base_hi_config{id = 7 ,desc = ?T("竞技场") ,type = 7 ,fun_id = {27,1} ,val = 1 ,time_limit = 15 ,condition = []};
get(8) -> 
   #base_hi_config{id = 8 ,desc = ?T("跨服副本") ,type = 8 ,fun_id = {34,1} ,val = 1 ,time_limit = 40 ,condition = []};
get(9) -> 
   #base_hi_config{id = 9 ,desc = ?T("世界首领") ,type = 9 ,fun_id = {35,2} ,val = 5 ,time_limit = 5 ,condition = []};
get(10) -> 
   #base_hi_config{id = 10 ,desc = ?T("护送美人") ,type = 10 ,fun_id = {36,1} ,val = 3 ,time_limit = 3 ,condition = []};
get(11) -> 
   #base_hi_config{id = 11 ,desc = ?T("跨服首领") ,type = 11 ,fun_id = {57,1} ,val = 5 ,time_limit = 2 ,condition = []};
get(12) -> 
   #base_hi_config{id = 12 ,desc = ?T("王城夺宝") ,type = 12 ,fun_id = {44,1} ,val = 3 ,time_limit = 1 ,condition = []};
get(13) -> 
   #base_hi_config{id = 13 ,desc = ?T("深渊魔宫") ,type = 13 ,fun_id = {27,9} ,val = 3 ,time_limit = 3 ,condition = []};
get(14) -> 
   #base_hi_config{id = 14 ,desc = ?T("符文寻宝") ,type = 14 ,fun_id = {38,1} ,val = 3 ,time_limit = 10 ,condition = []};
get(16) -> 
   #base_hi_config{id = 16 ,desc = ?T("招财进宝") ,type = 16 ,fun_id = {59,1} ,val = 2 ,time_limit = 15 ,condition = []};
get(17) -> 
   #base_hi_config{id = 17 ,desc = ?T("仙境寻宝") ,type = 17 ,fun_id = {60,1} ,val = 2 ,time_limit = 15 ,condition = []};
get(18) -> 
   #base_hi_config{id = 18 ,desc = ?T("充值次数") ,type = 18 ,fun_id = {31,1} ,val = 10 ,time_limit = 1 ,condition = []};
get(19) -> 
   #base_hi_config{id = 19 ,desc = ?T("累充有礼一") ,type = 19 ,fun_id = {67,1} ,val = 5 ,time_limit = 1 ,condition = [{charge,100}]};
get(20) -> 
   #base_hi_config{id = 20 ,desc = ?T("累充有礼二") ,type = 19 ,fun_id = {67,1} ,val = 8 ,time_limit = 1 ,condition = [{charge,300}]};
get(21) -> 
   #base_hi_config{id = 21 ,desc = ?T("累充有礼三") ,type = 19 ,fun_id = {67,1} ,val = 10 ,time_limit = 1 ,condition = [{charge,500}]};
get(22) -> 
   #base_hi_config{id = 22 ,desc = ?T("累充有礼四") ,type = 19 ,fun_id = {67,1} ,val = 15 ,time_limit = 1 ,condition = [{charge,980}]};
get(23) -> 
   #base_hi_config{id = 23 ,desc = ?T("累充有礼五") ,type = 19 ,fun_id = {67,1} ,val = 20 ,time_limit = 1 ,condition = [{charge,1280}]};
get(_) -> [].


ids() -> [1,2,4,5,6,7,8,9,10,11,12,13,14,16,17,18,19,20,21,22,23].
id_types(1) -> [1];

id_types(2) -> [2];

id_types(4) -> [4];

id_types(5) -> [5];

id_types(6) -> [6];

id_types(7) -> [7];

id_types(8) -> [8];

id_types(9) -> [9];

id_types(10) -> [10];

id_types(11) -> [11];

id_types(12) -> [12];

id_types(13) -> [13];

id_types(14) -> [14];

id_types(16) -> [16];

id_types(17) -> [17];

id_types(18) -> [18];

id_types(19) -> [19,20,21,22,23];
 id_types(_) -> [].

            