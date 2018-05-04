%%----------------------------------------------------
%% VIP数据
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(vip_data).
-export([get/1]).
-include("vip.hrl").

%% VIP列表
get(1) ->
    {ok, #vip_base{
            type = 1
            ,name = <<"VIP周卡">>
            ,title = <<"黄金VIP">>
            ,time = 604800
            ,buff = vip_bless_3
            ,effect = [{hearsay, 3}, {fly_sign, 20}]
        }
    };

get(2) ->
    {ok, #vip_base{
            type = 2
            ,name = <<"VIP月卡">>
            ,title = <<"钻石VIP">>
            ,time = 2592000
            ,buff = vip_bless_2
            ,effect = [{hearsay, 5}, {fly_sign, 30}]
        }
    };

get(4) ->
    {ok, #vip_base{
            type = 4
            ,name = <<"VIP半年卡">>
            ,title = <<"至尊VIP">>
            ,time = 15724800
            ,buff = vip_bless
            ,effect = [{hearsay, 10}, {fly_sign, -1}]
        }
    };

get(10) ->
    {ok, #vip_base{
            type = 10
            ,name = <<"VIP体验卡">>
            ,title = <<"体验VIP">>
            ,time = 3600
            ,buff = vip_bless_2
            ,effect = [{hearsay, 1}, {fly_sign, -1}]
        }
    };

get(_) ->
    {false, <<"无相关VIP类型">>}.
