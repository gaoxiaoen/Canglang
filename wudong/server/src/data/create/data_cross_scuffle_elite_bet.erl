%%%---------------------------------------
%%% @Author  : 苍狼工作室
%%% @Module  : data_cross_scuffle_elite_bet
%%% @Created : 2017-11-15 16:07:51
%%% @Description:  自动生成
%%%---------------------------------------
-module(data_cross_scuffle_elite_bet).
-export([get/1]).
-include("cross_scuffle_elite.hrl").
get(1) -> [#base_cross_scuffle_elite_bet{id = 1, goods_id = 10101, num = 50000},
    #base_cross_scuffle_elite_bet{id = 2, goods_id = 10101, num = 500000},
    #base_cross_scuffle_elite_bet{id = 3, goods_id = 10101, num = 1000000},
    #base_cross_scuffle_elite_bet{id = 4, goods_id = 10106, num = 100},
    #base_cross_scuffle_elite_bet{id = 5, goods_id = 10106, num = 500}
];
get(2) -> [#base_cross_scuffle_elite_bet{id = 1, goods_id = 10101, num = 10000},
    #base_cross_scuffle_elite_bet{id = 2, goods_id = 10101, num = 100000},
    #base_cross_scuffle_elite_bet{id = 3, goods_id = 10101, num = 500000},
    #base_cross_scuffle_elite_bet{id = 4, goods_id = 10106, num = 50},
    #base_cross_scuffle_elite_bet{id = 5, goods_id = 10106, num = 100}
];
get(_) -> []. 
