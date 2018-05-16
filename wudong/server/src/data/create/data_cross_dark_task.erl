%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_dark_task
	%%% @Created : 2017-11-23 18:26:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_dark_task).
-export([type_ids/1]).
-export([get/1]).
-include("common.hrl").
-include("cross_dark_bribe.hrl").

type_ids(1) ->[11,14,21,24,31,34,41,44,51,54];

type_ids(2) ->[3001,4001,5001];
type_ids(_) -> [].
get(11)->#config_darak_bribe_task{task_id = 11,type = 1,sub_type = 1,tar = 100,desc = "击杀1层怪物100只",next_id = 12,award_list = [{2003000,1},{8001085,1}]};
get(12)->#config_darak_bribe_task{task_id = 12,type = 1,sub_type = 1,tar = 500,desc = "击杀1层怪物500只",next_id = 13,award_list = [{2003000,3},{8001085,2}]};
get(13)->#config_darak_bribe_task{task_id = 13,type = 1,sub_type = 1,tar = 1000,desc = "击杀1层怪物1000只",next_id = 0,award_list = [{2003000,5},{8001085,3}]};
get(14)->#config_darak_bribe_task{task_id = 14,type = 1,sub_type = 2,tar = 1,desc = "击杀其他服务器玩家1次",next_id = 15,award_list = [{2005000,3},{8001163,1}]};
get(15)->#config_darak_bribe_task{task_id = 15,type = 1,sub_type = 2,tar = 2,desc = "击杀其他服务器玩家2次",next_id = 16,award_list = [{2005000,4},{8001163,2}]};
get(16)->#config_darak_bribe_task{task_id = 16,type = 1,sub_type = 2,tar = 3,desc = "击杀其他服务器玩家3次",next_id = 0,award_list = [{2005000,5},{8001163,3}]};
get(21)->#config_darak_bribe_task{task_id = 21,type = 1,sub_type = 1,tar = 100,desc = "击杀2层怪物100只",next_id = 22,award_list = [{2003000,2},{8001085,2}]};
get(22)->#config_darak_bribe_task{task_id = 22,type = 1,sub_type = 1,tar = 500,desc = "击杀2层怪物500只",next_id = 23,award_list = [{2003000,3},{8001085,3}]};
get(23)->#config_darak_bribe_task{task_id = 23,type = 1,sub_type = 1,tar = 1000,desc = "击杀2层怪物1000只",next_id = 0,award_list = [{2003000,4},{8001085,4}]};
get(24)->#config_darak_bribe_task{task_id = 24,type = 1,sub_type = 2,tar = 1,desc = "击杀其他服务器玩家1次",next_id = 25,award_list = [{2005000,4},{8001163,2}]};
get(25)->#config_darak_bribe_task{task_id = 25,type = 1,sub_type = 2,tar = 2,desc = "击杀其他服务器玩家2次",next_id = 26,award_list = [{2005000,5},{8001163,3}]};
get(26)->#config_darak_bribe_task{task_id = 26,type = 1,sub_type = 2,tar = 3,desc = "击杀其他服务器玩家3次",next_id = 0,award_list = [{2005000,6},{8001163,4}]};
get(31)->#config_darak_bribe_task{task_id = 31,type = 1,sub_type = 1,tar = 100,desc = "击杀3层怪物100只",next_id = 32,award_list = [{2003000,3},{8001085,3}]};
get(32)->#config_darak_bribe_task{task_id = 32,type = 1,sub_type = 1,tar = 500,desc = "击杀3层怪物500只",next_id = 33,award_list = [{2003000,4},{8001085,4}]};
get(33)->#config_darak_bribe_task{task_id = 33,type = 1,sub_type = 1,tar = 1000,desc = "击杀3层怪物1000只",next_id = 0,award_list = [{2003000,5},{8001085,5}]};
get(34)->#config_darak_bribe_task{task_id = 34,type = 1,sub_type = 2,tar = 1,desc = "击杀其他服务器玩家1次",next_id = 35,award_list = [{2005000,5},{8001163,3}]};
get(35)->#config_darak_bribe_task{task_id = 35,type = 1,sub_type = 2,tar = 2,desc = "击杀其他服务器玩家2次",next_id = 36,award_list = [{2005000,6},{8001163,4}]};
get(36)->#config_darak_bribe_task{task_id = 36,type = 1,sub_type = 2,tar = 3,desc = "击杀其他服务器玩家3次",next_id = 0,award_list = [{2005000,7},{8001163,5}]};
get(41)->#config_darak_bribe_task{task_id = 41,type = 1,sub_type = 1,tar = 100,desc = "击杀4层怪物100只",next_id = 42,award_list = [{2003000,4},{8001085,4}]};
get(42)->#config_darak_bribe_task{task_id = 42,type = 1,sub_type = 1,tar = 500,desc = "击杀4层怪物500只",next_id = 43,award_list = [{2003000,5},{8001085,5}]};
get(43)->#config_darak_bribe_task{task_id = 43,type = 1,sub_type = 1,tar = 1000,desc = "击杀4层怪物1000只",next_id = 0,award_list = [{2003000,6},{8001085,6}]};
get(44)->#config_darak_bribe_task{task_id = 44,type = 1,sub_type = 2,tar = 1,desc = "击杀其他服务器玩家1次",next_id = 45,award_list = [{2005000,6},{8001163,4}]};
get(45)->#config_darak_bribe_task{task_id = 45,type = 1,sub_type = 2,tar = 2,desc = "击杀其他服务器玩家2次",next_id = 46,award_list = [{2005000,7},{8001163,5}]};
get(46)->#config_darak_bribe_task{task_id = 46,type = 1,sub_type = 2,tar = 3,desc = "击杀其他服务器玩家3次",next_id = 0,award_list = [{2005000,8},{8001163,6}]};
get(51)->#config_darak_bribe_task{task_id = 51,type = 1,sub_type = 1,tar = 100,desc = "击杀5层怪物100只",next_id = 52,award_list = [{2003000,5},{8001085,5}]};
get(52)->#config_darak_bribe_task{task_id = 52,type = 1,sub_type = 1,tar = 500,desc = "击杀5层怪物500只",next_id = 53,award_list = [{2003000,6},{8001085,6}]};
get(53)->#config_darak_bribe_task{task_id = 53,type = 1,sub_type = 1,tar = 1000,desc = "击杀5层怪物1000只",next_id = 0,award_list = [{2003000,7},{8001085,7}]};
get(54)->#config_darak_bribe_task{task_id = 54,type = 1,sub_type = 2,tar = 1,desc = "击杀其他服务器玩家1次",next_id = 55,award_list = [{2005000,7},{8001163,5}]};
get(55)->#config_darak_bribe_task{task_id = 55,type = 1,sub_type = 2,tar = 2,desc = "击杀其他服务器玩家2次",next_id = 56,award_list = [{2005000,8},{8001163,6}]};
get(56)->#config_darak_bribe_task{task_id = 56,type = 1,sub_type = 2,tar = 3,desc = "击杀其他服务器玩家3次",next_id = 0,award_list = [{2005000,9},{8001163,7}]};
get(3001)->#config_darak_bribe_task{task_id = 3001,type = 2,sub_type = 3,tar = 5000,desc = "在魔宫击杀5000只怪物",next_id = 3002,award_list = [{8001057,1},{8001054,1},{10400,10}]};
get(3002)->#config_darak_bribe_task{task_id = 3002,type = 2,sub_type = 3,tar = 20000,desc = "在魔宫击杀20000只怪物",next_id = 3003,award_list = [{8001057,2},{8001054,2},{10400,15}]};
get(3003)->#config_darak_bribe_task{task_id = 3003,type = 2,sub_type = 3,tar = 50000,desc = "在魔宫击杀50000只怪物",next_id = 0,award_list = [{8001057,3},{8001054,3},{10400,20}]};
get(4001)->#config_darak_bribe_task{task_id = 4001,type = 2,sub_type = 4,tar = 50,desc = "击杀其他服务器玩家50次",next_id = 4002,award_list = [{8001057,1},{8001161,1},{8001085,1}]};
get(4002)->#config_darak_bribe_task{task_id = 4002,type = 2,sub_type = 4,tar = 200,desc = "击杀其他服务器玩家200次",next_id = 4003,award_list = [{8001057,2},{8001161,1},{8001085,2}]};
get(4003)->#config_darak_bribe_task{task_id = 4003,type = 2,sub_type = 4,tar = 500,desc = "击杀其他服务器玩家500次",next_id = 0,award_list = [{8001057,3},{8001161,1},{8001085,3}]};
get(5001)->#config_darak_bribe_task{task_id = 5001,type = 2,sub_type = 5,tar = 5000,desc = "占领度达到5000",next_id = 5002,award_list = [{1010005,1},{20340,2}]};
get(5002)->#config_darak_bribe_task{task_id = 5002,type = 2,sub_type = 5,tar = 20000,desc = "占领度达到20000",next_id = 5003,award_list = [{1010005,2},{20340,4}]};
get(5003)->#config_darak_bribe_task{task_id = 5003,type = 2,sub_type = 5,tar = 50000,desc = "占领度达到50000",next_id = 0,award_list = [{1010005,3},{20340,6}]};
get(_) -> [].
