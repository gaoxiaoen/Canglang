%%----------------------------------------------------
%% 晶钻转盘数据
%% @author jackguan@jieyou.cn
%% @end
%%----------------------------------------------------
-module(lottery_gold_data).
-export([
        get_golds/1
    ]).
-include("lottery.hrl").

get_golds(1) ->
    {ok, [
        #lottery_gold{gold = 2, pro = 50},
        #lottery_gold{gold = 4, pro = 50},
        #lottery_gold{gold = 6, pro = 100},
        #lottery_gold{gold = 8, pro = 100},
        #lottery_gold{gold = 10, pro = 300},
        #lottery_gold{gold = 20, pro = 400}
    ]};

get_golds(2) ->
    {ok, [
        #lottery_gold{gold = 100, pro = 400},
        #lottery_gold{gold = 200, pro = 300},
        #lottery_gold{gold = 300, pro = 270},
        #lottery_gold{gold = 400, pro = 10},
        #lottery_gold{gold = 500, pro = 10},
        #lottery_gold{gold = 1000, pro = 10}
    ]};

get_golds(3) ->
    {ok, [
        #lottery_gold{gold = 400, pro = 800},
        #lottery_gold{gold = 800, pro = 150},
        #lottery_gold{gold = 1200, pro = 30},
        #lottery_gold{gold = 1600, pro = 10},
        #lottery_gold{gold = 2000, pro = 5},
        #lottery_gold{gold = 4000, pro = 5}
    ]};

get_golds(4) ->
    {ok, [
        #lottery_gold{gold = 800, pro = 950},
        #lottery_gold{gold = 2000, pro = 20},
        #lottery_gold{gold = 3000, pro = 10},
        #lottery_gold{gold = 4000, pro = 10},
        #lottery_gold{gold = 5000, pro = 5},
        #lottery_gold{gold = 10000, pro = 5}
    ]};

get_golds(5) ->
    {ok, [
        #lottery_gold{gold = 1500, pro = 950},
        #lottery_gold{gold = 3000, pro = 24},
        #lottery_gold{gold = 5000, pro = 10},
        #lottery_gold{gold = 7000, pro = 10},
        #lottery_gold{gold = 10000, pro = 5},
        #lottery_gold{gold = 20000, pro = 1}
    ]};

get_golds(_) ->
    {false, error}.
