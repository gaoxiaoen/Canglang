%% **************************
%% 活动转盘数据
%% @author abu
%% **************************

-module(lottery_camp_data).
-export([
       get/1
       ,all/0
       ,get_default/0
    ]).

-include("lottery_camp.hrl").

get(23000) ->
    {ok, #lottery_camp_item{
        base_id = 23000
        ,name = language:get(<<"仙宠口粮">>)
        ,rand = 10000
        ,is_notice = 0
        ,limit_count = 0
    }};
get(24120) ->
    {ok, #lottery_camp_item{
        base_id = 24120
        ,name = language:get(<<"气血包">>)
        ,rand = 15000
        ,is_notice = 0
        ,limit_count = 0
    }};
get(24122) ->
    {ok, #lottery_camp_item{
        base_id = 24122
        ,name = language:get(<<"法力包">>)
        ,rand = 15000
        ,is_notice = 0
        ,limit_count = 0
    }};
get(23001) ->
    {ok, #lottery_camp_item{
        base_id = 23001
        ,name = language:get(<<"仙宠成长丹">>)
        ,rand = 10000
        ,is_notice = 0
        ,limit_count = 0
    }};
get(33108) ->
    {ok, #lottery_camp_item{
        base_id = 33108
        ,name = language:get(<<"八门金丹">>)
        ,rand = 15000
        ,is_notice = 0
        ,limit_count = 0
    }};
get(33109) ->
    {ok, #lottery_camp_item{
        base_id = 33109
        ,name = language:get(<<"八门保护符">>)
        ,rand = 3000
        ,is_notice = 1
        ,limit_count = 0
    }};
get(33117) ->
    {ok, #lottery_camp_item{
        base_id = 33117
        ,name = language:get(<<"师恩鲜花">>)
        ,rand = 15000
        ,is_notice = 0
        ,limit_count = 0
    }};
get(32203) ->
    {ok, #lottery_camp_item{
        base_id = 32203
        ,name = language:get(<<"翅膀仙羽">>)
        ,rand = 2000
        ,is_notice = 1
        ,limit_count = 0
    }};
get(21020) ->
    {ok, #lottery_camp_item{
        base_id = 21020
        ,name = language:get(<<"幸运石">>)
        ,rand = 10000
        ,is_notice = 0
        ,limit_count = 0
    }};
get(32001) ->
    {ok, #lottery_camp_item{
        base_id = 32001
        ,name = language:get(<<"护神丹">>)
        ,rand = 3000
        ,is_notice = 1
        ,limit_count = 0
    }};
get(25026) ->
    {ok, #lottery_camp_item{
        base_id = 25026
        ,name = language:get(<<"神器之魄碎片">>)
        ,rand = 1000
        ,is_notice = 1
        ,limit_count = 0
    }};
get(33113) ->
    {ok, #lottery_camp_item{
        base_id = 33113
        ,name = language:get(<<"火凤羽碎片">>)
        ,rand = 1000
        ,is_notice = 1
        ,limit_count = 0
    }};

get(_Id) ->
    {false, language:get(<<"无此物品信息">>)}.


all() ->
    [23000,24120,24122,23001,33108,33109,33117,32203,21020,32001,25026,33113].

get_default() ->
    [23000,24120,24122,23001,33108,33117,32203].

