%%----------------------------------------------------
%% 世界Boss数据配置
%% @author mobin
%% @end
%%----------------------------------------------------
-module(super_boss_data).
-export([
        boss/1
        ,bosses/0
        ,scenes/0
        ,scene/1
        ,killed_odds/1
        ,alive_odds/1
        ,change_items/0
        ,exp/1
    ]
).
-include("common.hrl").
-include("change.hrl").
-include("boss.hrl").

boss(1) ->
    14001;
boss(2) ->
    14002;
boss(3) ->
    14003;
boss(4) ->
    14004;
boss(5) ->
    14005;
boss(_) ->
    undefined.

bosses() ->    
    [14001, 14002, 14003, 14004, 14005].

scenes() ->    
    [110, 111, 112, 113].

scene(110) ->
    #super_boss_scene{
        map_id = 110
        ,pos = {2100, 570}
        ,enter_point = {400, 484}
        ,exit_map_id = 1400
        ,exit_point = {620, 484}
    };
scene(111) ->
    #super_boss_scene{
        map_id = 111
        ,pos = {3200, 484}
        ,enter_point = {1500, 484}
        ,exit_map_id = 1405
        ,exit_point = {520, 484}
    };
scene(112) ->
    #super_boss_scene{
        map_id = 112
        ,pos = {2100, 570}
        ,enter_point = {400, 484}
        ,exit_map_id = 1410
        ,exit_point = {720, 484}
    };
scene(113) ->
    #super_boss_scene{
        map_id = 113
        ,pos = {2100, 570}
        ,enter_point = {400, 484}
        ,exit_map_id = 1415
        ,exit_point = {820, 484}
    };
scene(_) ->
    undefined.

killed_odds(1) ->
    [{1, 15}, {2, 70}, {3, 15}, {4, 0}];
killed_odds(2) ->
    [{1, 10}, {2, 30}, {3, 65}, {4, 5}];
killed_odds(3) ->
    [{1, 0}, {2, 10}, {3, 20}, {4, 70}];
killed_odds(4) ->
    [{1, 0}, {2, 10}, {3, 20}, {4, 70}];
killed_odds(_) ->
    [].

alive_odds(1) ->
    [{1, 70}, {2, 25}, {3, 5}, {4, 0}];
alive_odds(2) ->
    [{1, 50}, {2, 45}, {3, 10}, {4, 5}];
alive_odds(3) ->
    [{1, 5}, {2, 50}, {3, 40}, {4, 5}];
alive_odds(4) ->
    [{1, 0}, {2, 10}, {3, 60}, {4, 30}];
alive_odds(_) ->
    [].

change_items() ->
    [
        #change_item{id = 1, base_id = 111610, price = 200, count = 1, bind = 1},
        #change_item{id = 2, base_id = 111620, price = 800, count = 1, bind = 1},
        #change_item{id = 3, base_id = 531010, price = 80, count = 10, bind = 1},
        #change_item{id = 4, base_id = 531011, price = 120, count = 12, bind = 1},
        #change_item{id = 5, base_id = 111630, price = 3000, count = 1, bind = 1},
        #change_item{id = 6, base_id = 111640, price = 9000, count = 1, bind = 1},
        #change_item{id = 7, base_id = 531012, price = 250, count = 36, bind = 1},
        #change_item{id = 8, base_id = 531013, price = 400, count = 60, bind = 1},
        #change_item{id = 9, base_id = 531021, price = 60, count = 15, bind = 1},
        #change_item{id = 10, base_id = 531022, price = 200, count = 15, bind = 1}
    ].

exp(1) ->
    0;
exp(2) ->
    0;
exp(3) ->
    0;
exp(4) ->
    0;
exp(5) ->
    0;
exp(6) ->
    0;
exp(7) ->
    0;
exp(8) ->
    0;
exp(9) ->
    0;
exp(10) ->
    0;
exp(11) ->
    0;
exp(12) ->
    0;
exp(13) ->
    0;
exp(14) ->
    0;
exp(15) ->
    0;
exp(16) ->
    0;
exp(17) ->
    0;
exp(18) ->
    0;
exp(19) ->
    0;
exp(20) ->
    0;
exp(21) ->
    0;
exp(22) ->
    0;
exp(23) ->
    0;
exp(24) ->
    0;
exp(25) ->
    0;
exp(26) ->
    0;
exp(27) ->
    0;
exp(28) ->
    0;
exp(29) ->
    0;
exp(30) ->
    0;
exp(31) ->
    0;
exp(32) ->
    0;
exp(33) ->
    0;
exp(34) ->
    0;
exp(35) ->
    0;
exp(36) ->
    0;
exp(37) ->
    0;
exp(38) ->
    0;
exp(39) ->
    0;
exp(40) ->
    0;
exp(41) ->
    0;
exp(42) ->
    0;
exp(43) ->
    0;
exp(44) ->
    0;
exp(45) ->
    0;
exp(46) ->
    0;
exp(47) ->
    0;
exp(48) ->
    0;
exp(49) ->
    0;
exp(50) ->
    0;
exp(51) ->
    0;
exp(52) ->
    0;
exp(53) ->
    0;
exp(54) ->
    0;
exp(55) ->
    0;
exp(56) ->
    0;
exp(57) ->
    0;
exp(58) ->
    0;
exp(59) ->
    0;
exp(60) ->
    0;
exp(61) ->
    0;
exp(62) ->
    0;
exp(63) ->
    0;
exp(64) ->
    0;
exp(65) ->
    0;
exp(66) ->
    0;
exp(67) ->
    0;
exp(68) ->
    0;
exp(69) ->
    0;
exp(70) ->
    0;
exp(_) ->
    undefined.

