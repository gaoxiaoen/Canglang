%%----------------------------------------------------
%% 悬赏Boss数据配置
%% @author mobin
%% @end
%%----------------------------------------------------
-module(wanted_data).
-export([
        wanted_npc/1
        ,npc_assets/1
        ,wanted_role/1
        ,role_assets/1
        ,wanted_assets_weights/0
        ,need_counts/0
        ,rewards/1
    ]
).
-include("common.hrl").
-include("wanted.hrl").


wanted_npc(1) ->
    #wanted_npc{
        id = 1
        ,base_id = 15011
        ,origin_coin = 80000
        ,origin_stone = 40
        ,kill_count = 0
        ,kill_count_index = 0.7
        ,kill_count_factor = 13
    };
wanted_npc(2) ->
    #wanted_npc{
        id = 2
        ,base_id = 15012
        ,origin_coin = 100000
        ,origin_stone = 50
        ,kill_count = 0
        ,kill_count_index = 0.7
        ,kill_count_factor = 13
    };
wanted_npc(3) ->
    #wanted_npc{
        id = 3
        ,base_id = 15013
        ,origin_coin = 120000
        ,origin_stone = 60
        ,kill_count = 0
        ,kill_count_index = 0.7
        ,kill_count_factor = 13
    };
wanted_npc(4) ->
    #wanted_npc{
        id = 4
        ,base_id = 15014
        ,origin_coin = 150000
        ,origin_stone = 70
        ,kill_count = 0
        ,kill_count_index = 0.7
        ,kill_count_factor = 13
    };
wanted_npc(5) ->
    #wanted_npc{
        id = 5
        ,base_id = 15015
        ,origin_coin = 180000
        ,origin_stone = 80
        ,kill_count = 0
        ,kill_count_index = 0.7
        ,kill_count_factor = 13
    };
wanted_npc(_) ->
    undefined.

npc_assets(1) ->
    #wanted_assets{
        coin = 80000
        ,stone = 40
        ,odds = 3400
        ,coin_index = 0.35
        ,coin_factor = 25000
        ,stone_index = 0.35
        ,stone_factor = 5
    };
npc_assets(2) ->
    #wanted_assets{
        coin = 100000
        ,stone = 50
        ,odds = 3400
        ,coin_index = 0.35
        ,coin_factor = 25000
        ,stone_index = 0.35
        ,stone_factor = 5
    };
npc_assets(3) ->
    #wanted_assets{
        coin = 120000
        ,stone = 60
        ,odds = 3400
        ,coin_index = 0.35
        ,coin_factor = 25000
        ,stone_index = 0.35
        ,stone_factor = 5
    };
npc_assets(4) ->
    #wanted_assets{
        coin = 150000
        ,stone = 70
        ,odds = 3400
        ,coin_index = 0.35
        ,coin_factor = 25000
        ,stone_index = 0.35
        ,stone_factor = 5
    };
npc_assets(5) ->
    #wanted_assets{
        coin = 180000
        ,stone = 80
        ,odds = 3400
        ,coin_index = 0.35
        ,coin_factor = 25000
        ,stone_index = 0.35
        ,stone_factor = 5
    };
npc_assets(_) ->
    undefined.

wanted_role(1) ->
    #wanted_role{
        id = 1
        ,origin_coin = 80000
        ,origin_stone = 40
        ,kill_count = 0
        ,kill_count_index = 0.7
        ,kill_count_factor = 17
    };
wanted_role(2) ->
    #wanted_role{
        id = 2
        ,origin_coin = 100000
        ,origin_stone = 50
        ,kill_count = 0
        ,kill_count_index = 0.7
        ,kill_count_factor = 17
    };
wanted_role(3) ->
    #wanted_role{
        id = 3
        ,origin_coin = 120000
        ,origin_stone = 60
        ,kill_count = 0
        ,kill_count_index = 0.7
        ,kill_count_factor = 17
    };
wanted_role(4) ->
    #wanted_role{
        id = 4
        ,origin_coin = 150000
        ,origin_stone = 70
        ,kill_count = 0
        ,kill_count_index = 0.7
        ,kill_count_factor = 17
    };
wanted_role(5) ->
    #wanted_role{
        id = 5
        ,origin_coin = 180000
        ,origin_stone = 80
        ,kill_count = 0
        ,kill_count_index = 0.7
        ,kill_count_factor = 17
    };
wanted_role(_) ->
    undefined.

role_assets(1) ->
    #wanted_assets{
        coin = 80000
        ,stone = 40
        ,odds = 3400
        ,coin_index = 0.35
        ,coin_factor = 25000
        ,stone_index = 0.35
        ,stone_factor = 15
    };
role_assets(2) ->
    #wanted_assets{
        coin = 100000
        ,stone = 50
        ,odds = 3400
        ,coin_index = 0.35
        ,coin_factor = 25000
        ,stone_index = 0.35
        ,stone_factor = 15
    };
role_assets(3) ->
    #wanted_assets{
        coin = 120000
        ,stone = 60
        ,odds = 3400
        ,coin_index = 0.35
        ,coin_factor = 25000
        ,stone_index = 0.35
        ,stone_factor = 15
    };
role_assets(4) ->
    #wanted_assets{
        coin = 150000
        ,stone = 70
        ,odds = 3400
        ,coin_index = 0.35
        ,coin_factor = 25000
        ,stone_index = 0.35
        ,stone_factor = 15
    };
role_assets(5) ->
    #wanted_assets{
        coin = 180000
        ,stone = 80
        ,odds = 3400
        ,coin_index = 0.35
        ,coin_factor = 25000
        ,stone_index = 0.35
        ,stone_factor = 15
    };
role_assets(_) ->
    undefined.

wanted_assets_weights() ->    
    [
        {1, 22},
        {2, 15},
        {3, 13},
        {4, 12},
        {5, 10},
        {6, 8},
        {7, 6},
        {8, 6},
        {9, 5},
        {10, 3}
    ].

need_counts() ->    
    [
        10,
        25,
        40,
        60,
        0
    ].

rewards(1) ->
    {0, 1000, 20};
rewards(2) ->
    {0, 1000, 20};
rewards(3) ->
    {0, 1000, 20};
rewards(4) ->
    {0, 1000, 20};
rewards(5) ->
    {0, 1000, 20};
rewards(6) ->
    {0, 1000, 20};
rewards(7) ->
    {0, 1000, 20};
rewards(8) ->
    {0, 1000, 20};
rewards(9) ->
    {0, 1000, 20};
rewards(10) ->
    {0, 1000, 20};
rewards(11) ->
    {0, 1000, 20};
rewards(12) ->
    {0, 1000, 20};
rewards(13) ->
    {0, 1000, 20};
rewards(14) ->
    {0, 1000, 20};
rewards(15) ->
    {0, 1000, 20};
rewards(16) ->
    {0, 1000, 20};
rewards(17) ->
    {0, 1000, 20};
rewards(18) ->
    {0, 1000, 20};
rewards(19) ->
    {0, 1000, 20};
rewards(20) ->
    {0, 1000, 20};
rewards(21) ->
    {0, 1000, 20};
rewards(22) ->
    {0, 1000, 20};
rewards(23) ->
    {0, 1000, 20};
rewards(24) ->
    {0, 1000, 20};
rewards(25) ->
    {0, 1000, 20};
rewards(26) ->
    {0, 1000, 20};
rewards(27) ->
    {0, 1000, 20};
rewards(28) ->
    {0, 4000, 20};
rewards(29) ->
    {0, 4000, 20};
rewards(30) ->
    {0, 4000, 20};
rewards(31) ->
    {0, 4000, 20};
rewards(32) ->
    {0, 4000, 20};
rewards(33) ->
    {0, 4000, 20};
rewards(34) ->
    {0, 4000, 20};
rewards(35) ->
    {0, 4000, 20};
rewards(36) ->
    {0, 4000, 20};
rewards(37) ->
    {0, 4000, 20};
rewards(38) ->
    {0, 4000, 20};
rewards(39) ->
    {0, 4000, 20};
rewards(40) ->
    {0, 4000, 20};
rewards(41) ->
    {0, 4000, 20};
rewards(42) ->
    {0, 4000, 20};
rewards(43) ->
    {0, 4000, 20};
rewards(44) ->
    {0, 4000, 20};
rewards(45) ->
    {0, 4000, 20};
rewards(46) ->
    {0, 4000, 20};
rewards(47) ->
    {0, 4000, 20};
rewards(48) ->
    {0, 4000, 20};
rewards(49) ->
    {0, 4000, 20};
rewards(50) ->
    {0, 4000, 20};
rewards(51) ->
    {0, 4000, 20};
rewards(52) ->
    {0, 4000, 20};
rewards(53) ->
    {0, 4000, 20};
rewards(54) ->
    {0, 4000, 20};
rewards(55) ->
    {0, 4000, 20};
rewards(56) ->
    {0, 4000, 20};
rewards(57) ->
    {0, 4000, 20};
rewards(58) ->
    {0, 4000, 20};
rewards(59) ->
    {0, 4000, 20};
rewards(60) ->
    {0, 4000, 20};
rewards(61) ->
    {0, 4000, 20};
rewards(62) ->
    {0, 4000, 20};
rewards(63) ->
    {0, 4000, 20};
rewards(64) ->
    {0, 4000, 20};
rewards(65) ->
    {0, 4000, 20};
rewards(66) ->
    {0, 4000, 20};
rewards(67) ->
    {0, 4000, 20};
rewards(68) ->
    {0, 4000, 20};
rewards(69) ->
    {0, 4000, 20};
rewards(70) ->
    {0, 4000, 20};
rewards(_) ->
    undefined.

