%% Author: xiaocenfeng
%% Created: 2013-9-25
%% Description: TODO: 排行榜配制文件
-module(cfg_ranking).


-export([find/1]).

find(rank_id_list)->
	[1001];

%% 角色排行
find({rank_info,1001})->
	{p_ranking,1001,200,10,2,mod_role_rank};
find(_)->[].

