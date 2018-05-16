%%%---------------------------------------
%%% @Author  : 苍狼工作室
%%% @Module  : data_lucky_pool_goods
%%% @Created : 2016-05-07 16:59:50
%%% @Description:  自动生成
%%%---------------------------------------
-module(data_lucky_pool_goods).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").
-include("lucky_pool.hrl").

ids() ->
    [1, 2, 3, 4, 5, 6, 7, 8].
get(1) ->
    #base_lucky_pool{pos = 1, goods_id = 10109, num = 80, type = 1, ratio = 1, is_show = 1};
get(2) ->
    #base_lucky_pool{pos = 2, goods_id = 10401, num = 1, type = 2, ratio = 150, is_show = 0};
get(3) ->
    #base_lucky_pool{pos = 3, goods_id = 10109, num = 30, type = 1, ratio = 10, is_show = 1};
get(4) ->
    #base_lucky_pool{pos = 4, goods_id = 10401, num = 2, type = 2, ratio = 100, is_show = 0};
get(5) ->
    #base_lucky_pool{pos = 5, goods_id = 10401, num = 3, type = 2, ratio = 100, is_show = 0};
get(6) ->
    #base_lucky_pool{pos = 6, goods_id = 10109, num = 10, type = 1, ratio = 89, is_show = 1};
get(7) ->
    #base_lucky_pool{pos = 7, goods_id = 10401, num = 4, type = 2, ratio = 30, is_show = 1};
get(8) ->
    #base_lucky_pool{pos = 8, goods_id = 10401, num = 5, type = 2, ratio = 20, is_show = 1};
get(_) -> [].