%% **************************
%% 彩票系统
%% @author wpf(wprehard@qq.com)
%% **************************

-module(lottery_data).
-export([
        award_list/1
        ,award_list_float/0
        ,award_list_first/0
        ,award_list_end/0
        ,get/2
    ]).

-include("lottery.hrl").


%% 免费
award_list(free) ->
    [32001,25022,23000,23003,21029,21020,30016,21010,30015,27002,30008,30000];

%% 付费
award_list(pay) ->
    [32001,25022,23000,23003,21029,21020,30016,21010,30015,27002,30008,30000].

%% 浮动概率奖品列表
award_list_float() ->
    [30008].

%% 大奖
award_list_first() ->
    [30008].

%% 保底奖
award_list_end() ->
    [30000].

%% 奖品
get(free, 32001) -> 
    {ok, #lottery_item{
           base_id = 32001
           ,name = language:get(<<"护神丹">>)
           ,rand = 70
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(free, 25022) -> 
    {ok, #lottery_item{
           base_id = 25022
           ,name = language:get(<<"神器之魄">>)
           ,rand = 70
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(free, 23000) -> 
    {ok, #lottery_item{
           base_id = 23000
           ,name = language:get(<<"仙宠口粮">>)
           ,rand = 10000
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 0
           ,num = 1
        }
    };
get(free, 23003) -> 
    {ok, #lottery_item{
           base_id = 23003
           ,name = language:get(<<"仙宠潜力保护符">>)
           ,rand = 150
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(free, 21029) -> 
    {ok, #lottery_item{
           base_id = 21029
           ,name = language:get(<<"+8强化保护符">>)
           ,rand = 80
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(free, 21020) -> 
    {ok, #lottery_item{
           base_id = 21020
           ,name = language:get(<<"普通幸运石">>)
           ,rand = 240
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 0
           ,num = 1
        }
    };
get(free, 30016) -> 
    {ok, #lottery_item{
           base_id = 30016
           ,name = language:get(<<"三等奖（头奖3%）">>)
           ,rand = 0
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(free, 21010) -> 
    {ok, #lottery_item{
           base_id = 21010
           ,name = language:get(<<"初级强化灵石">>)
           ,rand = 4000
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 0
           ,num = 1
        }
    };
get(free, 30015) -> 
    {ok, #lottery_item{
           base_id = 30015
           ,name = language:get(<<"二等奖（头奖10%）">>)
           ,rand = 0
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(free, 27002) -> 
    {ok, #lottery_item{
           base_id = 27002
           ,name = language:get(<<"紫色洗练石">>)
           ,rand = 300
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 0
           ,num = 1
        }
    };
get(free, 30008) -> 
    {ok, #lottery_item{
           base_id = 30008
           ,name = language:get(<<"头奖">>)
           ,rand = 0
           ,limit = 2
           ,limit_time = {3600,1}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 100000
        }
    };
get(free, 30000) -> 
    {ok, #lottery_item{
           base_id = 30000
           ,name = language:get(<<"安慰奖（500铜币）">>)
           ,rand = 85090
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 0
           ,num = 500
        }
    };

get(pay, 32001) -> 
    {ok, #lottery_item{
           base_id = 32001
           ,name = language:get(<<"护神丹">>)
           ,rand = 70
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(pay, 25022) -> 
    {ok, #lottery_item{
           base_id = 25022
           ,name = language:get(<<"神器之魄">>)
           ,rand = 70
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(pay, 23000) -> 
    {ok, #lottery_item{
           base_id = 23000
           ,name = language:get(<<"仙宠口粮">>)
           ,rand = 10000
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 0
           ,num = 1
        }
    };
get(pay, 23003) -> 
    {ok, #lottery_item{
           base_id = 23003
           ,name = language:get(<<"仙宠潜力保护符">>)
           ,rand = 150
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(pay, 21029) -> 
    {ok, #lottery_item{
           base_id = 21029
           ,name = language:get(<<"+8强化保护符">>)
           ,rand = 80
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(pay, 21020) -> 
    {ok, #lottery_item{
           base_id = 21020
           ,name = language:get(<<"普通幸运石">>)
           ,rand = 240
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 0
           ,num = 1
        }
    };
get(pay, 30016) -> 
    {ok, #lottery_item{
           base_id = 30016
           ,name = language:get(<<"三等奖（头奖3%）">>)
           ,rand = 100
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(pay, 21010) -> 
    {ok, #lottery_item{
           base_id = 21010
           ,name = language:get(<<"初级强化灵石">>)
           ,rand = 4000
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 0
           ,num = 1
        }
    };
get(pay, 30015) -> 
    {ok, #lottery_item{
           base_id = 30015
           ,name = language:get(<<"二等奖（头奖10%）">>)
           ,rand = 30
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(pay, 27002) -> 
    {ok, #lottery_item{
           base_id = 27002
           ,name = language:get(<<"紫色洗练石">>)
           ,rand = 300
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 0
           ,num = 1
        }
    };
get(pay, 30008) -> 
    {ok, #lottery_item{
           base_id = 30008
           ,name = language:get(<<"头奖">>)
           ,rand = 10
           ,limit = 2
           ,limit_time = {3600,1}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 1
           ,num = 1
        }
    };
get(pay, 30000) -> 
    {ok, #lottery_item{
           base_id = 30000
           ,name = language:get(<<"安慰奖（500铜币）">>)
           ,rand = 84950
           ,limit = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_num = 0
           ,is_notice = 0
           ,num = 500
        }
    };

get(_, _Id) ->
    {false, language:get(<<"无此物品信息">>)}.
