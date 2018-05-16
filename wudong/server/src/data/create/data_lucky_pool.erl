%%%---------------------------------------
%%% @Author  : 苍狼工作室
%%% @Module  : data_lucky_pool
%%% @Created : 2016-05-07 16:59:50
%%% @Description:  自动生成
%%%---------------------------------------
-module(data_lucky_pool).
-export([def_coin/0]).
-export([once_price/0]).
-export([once_back/0]).
-export([once_pool/0]).
-export([ten_price/0]).
-export([ten_back/0]).
-export([ten_pool/0]).
-export([coin_ratio/0]).
-export([goods_ratio/0]).
-include("common.hrl").
-include("lucky_pool.hrl").
def_coin() -> 5000000.
once_price() -> 50000.
once_back() -> 25000.
once_pool() -> 25000.
ten_price() -> 450000.
ten_back() -> 225000.
ten_pool() -> 225000.
coin_ratio() -> 999.
goods_ratio() -> 1.
