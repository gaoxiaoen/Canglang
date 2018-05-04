%%----------------------------------------------------
%% 竞技场数据
%% @author mobin
%% @end
%%----------------------------------------------------
-module(compete_data).
-export([
        teammate_latitude/1
        ,team_latitude/1
        ,win_honor/1
        ,lose_honor/1
        ,win_badge_weights/0
        ,lose_badge_weights/0
        ,change_items/0
    ]
).

-include("change.hrl").

teammate_latitude(0) ->
    0.05;

teammate_latitude(1) ->
    0.06;

teammate_latitude(2) ->
    0.07;

teammate_latitude(3) ->
    0.08;

teammate_latitude(4) ->
    0.09;

teammate_latitude(5) ->
    0.10;

teammate_latitude(6) ->
    0.11;

teammate_latitude(7) ->
    0.12;

teammate_latitude(8) ->
    0.13;

teammate_latitude(9) ->
    0.14;

teammate_latitude(10) ->
    0.15;

teammate_latitude(11) ->
    0.16;

teammate_latitude(12) ->
    0.17;

teammate_latitude(13) ->
    0.18;

teammate_latitude(14) ->
    0.19;

teammate_latitude(15) ->
    0.20;

teammate_latitude(16) ->
    0.21;

teammate_latitude(17) ->
    0.22;

teammate_latitude(18) ->
    0.23;

teammate_latitude(19) ->
    0.24;

teammate_latitude(20) ->
    0.25;

teammate_latitude(21) ->
    0.26;

teammate_latitude(22) ->
    0.27;

teammate_latitude(23) ->
    0.28;

teammate_latitude(24) ->
    0.29;

teammate_latitude(25) ->
    0.30;

teammate_latitude(26) ->
    0.31;

teammate_latitude(27) ->
    0.32;

teammate_latitude(_) ->
    0.9.

team_latitude(0) ->
    0.05;

team_latitude(1) ->
    0.06;

team_latitude(2) ->
    0.07;

team_latitude(3) ->
    0.08;

team_latitude(4) ->
    0.09;

team_latitude(5) ->
    0.10;

team_latitude(6) ->
    0.11;

team_latitude(7) ->
    0.12;

team_latitude(8) ->
    0.13;

team_latitude(9) ->
    0.14;

team_latitude(10) ->
    0.15;

team_latitude(11) ->
    0.16;

team_latitude(12) ->
    0.17;

team_latitude(13) ->
    0.18;

team_latitude(14) ->
    0.19;

team_latitude(15) ->
    0.20;

team_latitude(16) ->
    0.21;

team_latitude(17) ->
    0.22;

team_latitude(18) ->
    0.23;

team_latitude(19) ->
    0.24;

team_latitude(20) ->
    0.25;

team_latitude(21) ->
    0.26;

team_latitude(22) ->
    0.27;

team_latitude(23) ->
    0.28;

team_latitude(24) ->
    0.29;

team_latitude(25) ->
    0.30;

team_latitude(26) ->
    0.31;

team_latitude(27) ->
    0.32;

team_latitude(_) ->
    0.9.

win_honor(1) ->
    12;

win_honor(2) ->
    10;

win_honor(3) ->
    9;

win_honor(4) ->
    8;

win_honor(5) ->
    7;

win_honor(_) ->
    0.

lose_honor(1) ->
    5;

lose_honor(2) ->
    4;

lose_honor(3) ->
    3;

lose_honor(4) ->
    2;

lose_honor(5) ->
    2;

lose_honor(_) ->
    0.


win_badge_weights() ->    
    [
        {0, 2},
        {1, 4},
        {2, 4}
    ].

lose_badge_weights() ->    
    [
        {0, 4},
        {1, 4},
        {2, 4}
    ].

change_items() ->
    [
        #change_item{id = 1, base_id = 111610, price = 10, count = 999, bind = 1, limit = 20002},
        #change_item{id = 2, base_id = 111476, price = 10, count = 999, bind = 1, limit = 20003},
        #change_item{id = 3, base_id = 111620, price = 10, count = 999, bind = 1, limit = 20004},
        #change_item{id = 4, base_id = 111477, price = 10, count = 999, bind = 1, limit = 20005},
        #change_item{id = 5, base_id = 111630, price = 10, count = 999, bind = 1, limit = 20006},
        #change_item{id = 6, base_id = 111478, price = 10, count = 999, bind = 1, limit = 20007},
        #change_item{id = 7, base_id = 111501, price = 10, count = 999, bind = 1, limit = 20008},
        #change_item{id = 8, base_id = 111502, price = 10, count = 999, bind = 1, limit = 20009},
        #change_item{id = 9, base_id = 111001, price = 10, count = 999, bind = 1, limit = 21000},
        #change_item{id = 10, base_id = 111011, price = 10, count = 999, bind = 1, limit = 21001},
        #change_item{id = 11, base_id = 111002, price = 10, count = 999, bind = 1, limit = 21002},
        #change_item{id = 12, base_id = 111012, price = 10, count = 999, bind = 1, limit = 21003},
        #change_item{id = 13, base_id = 111003, price = 10, count = 999, bind = 1, limit = 22000},
        #change_item{id = 14, base_id = 111013, price = 10, count = 999, bind = 1, limit = 22001}

    ].

