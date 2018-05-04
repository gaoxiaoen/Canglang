%%----------------------------------------------------
%% 经验封印配置表
%% @author lishen@jieyou.cn
%%----------------------------------------------------
-module(exp_seal_data).
-export([
        get_exp_seal_top/1
        ,get_exp_seal_cost/1
        ]).

%% @spec get_exp_seal_top(Top) -> NextTop.
%% @doc 获取经验上限
get_exp_seal_top(0) -> 5000000;
get_exp_seal_top(5000000) -> 10000000;
get_exp_seal_top(10000000) -> 20000000;
get_exp_seal_top(20000000) -> 40000000;
get_exp_seal_top(40000000) -> 80000000;
get_exp_seal_top(80000000) -> 160000000;
get_exp_seal_top(160000000) -> 320000000;
get_exp_seal_top(320000000) -> 640000000;
get_exp_seal_top(640000000) -> 1280000000;
get_exp_seal_top(1280000000) -> 2560000000;
get_exp_seal_top(_) -> 0.

%% @spec get_exp_seal_cost(Top) -> NextCoin.
%% @doc 获取升上限消耗金币
get_exp_seal_cost(0) -> 300000;
get_exp_seal_cost(5000000) -> 50000;
get_exp_seal_cost(10000000) -> 100000;
get_exp_seal_cost(20000000) -> 150000;
get_exp_seal_cost(40000000) -> 200000;
get_exp_seal_cost(80000000) -> 250000;
get_exp_seal_cost(160000000) -> 300000;
get_exp_seal_cost(320000000) -> 350000;
get_exp_seal_cost(640000000) -> 400000;
get_exp_seal_cost(1280000000) -> 450000;
get_exp_seal_cost(_) -> 0.
