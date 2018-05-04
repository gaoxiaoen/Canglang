%%----------------------------------------------------
%% 世界树数据配置
%% @author mobin
%% @end
%%----------------------------------------------------
-module(tree_data).
-export([
        get/1
        ,material_items/1
        ,strange_items/0
    ]
).
-include("common.hrl").
-include("tree.hrl").

get(1) ->
    #tree_stage{
        id = 1
        ,boss_id = 14031
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(2) ->
    #tree_stage{
        id = 2
        ,boss_id = 14032
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(3) ->
    #tree_stage{
        id = 3
        ,boss_id = 14011
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 6000
        ,boss_strange_odds = 800
    };
get(4) ->
    #tree_stage{
        id = 4
        ,boss_id = 14033
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(5) ->
    #tree_stage{
        id = 5
        ,boss_id = 14034
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(6) ->
    #tree_stage{
        id = 6
        ,boss_id = 14012
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 3076
        ,boss_strange_odds = 800
    };
get(7) ->
    #tree_stage{
        id = 7
        ,boss_id = 14035
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(8) ->
    #tree_stage{
        id = 8
        ,boss_id = 14036
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(9) ->
    #tree_stage{
        id = 9
        ,boss_id = 14013
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 4444
        ,boss_strange_odds = 800
    };
get(10) ->
    #tree_stage{
        id = 10
        ,boss_id = 14037
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(11) ->
    #tree_stage{
        id = 11
        ,boss_id = 14038
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(12) ->
    #tree_stage{
        id = 12
        ,boss_id = 14014
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 3000
        ,boss_strange_odds = 800
    };
get(13) ->
    #tree_stage{
        id = 13
        ,boss_id = 14039
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 46}, {?material, 15}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(14) ->
    #tree_stage{
        id = 14
        ,boss_id = 14040
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 46}, {?material, 15}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(15) ->
    #tree_stage{
        id = 15
        ,boss_id = 14015
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 46}, {?material, 15}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 1000
        ,boss_strange_odds = 800
    };
get(16) ->
    #tree_stage{
        id = 16
        ,boss_id = 14041
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 46}, {?material, 15}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(17) ->
    #tree_stage{
        id = 17
        ,boss_id = 14042
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 46}, {?material, 15}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(18) ->
    #tree_stage{
        id = 18
        ,boss_id = 14016
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 46}, {?material, 15}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 1000
        ,boss_strange_odds = 800
    };
get(19) ->
    #tree_stage{
        id = 19
        ,boss_id = 14043
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(20) ->
    #tree_stage{
        id = 20
        ,boss_id = 14044
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(21) ->
    #tree_stage{
        id = 21
        ,boss_id = 14017
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 2000
        ,boss_strange_odds = 800
    };
get(22) ->
    #tree_stage{
        id = 22
        ,boss_id = 14045
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(23) ->
    #tree_stage{
        id = 23
        ,boss_id = 14046
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(24) ->
    #tree_stage{
        id = 24
        ,boss_id = 14018
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 3000
        ,boss_strange_odds = 800
    };
get(25) ->
    #tree_stage{
        id = 25
        ,boss_id = 14047
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(26) ->
    #tree_stage{
        id = 26
        ,boss_id = 14048
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(27) ->
    #tree_stage{
        id = 27
        ,boss_id = 14019
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 41}, {?material, 20}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 3333
        ,boss_strange_odds = 800
    };
get(28) ->
    #tree_stage{
        id = 28
        ,boss_id = 14049
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 46}, {?material, 15}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(29) ->
    #tree_stage{
        id = 29
        ,boss_id = 14050
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 46}, {?material, 15}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(30) ->
    #tree_stage{
        id = 30
        ,boss_id = 14020
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 46}, {?material, 15}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 1000
        ,boss_strange_odds = 800
    };
get(31) ->
    #tree_stage{
        id = 31
        ,boss_id = 14051
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 53}, {?material, 7}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(32) ->
    #tree_stage{
        id = 32
        ,boss_id = 14052
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 53}, {?material, 7}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(33) ->
    #tree_stage{
        id = 33
        ,boss_id = 14021
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 53}, {?material, 7}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 1000
        ,boss_strange_odds = 800
    };
get(34) ->
    #tree_stage{
        id = 34
        ,boss_id = 14053
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 53}, {?material, 8}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(35) ->
    #tree_stage{
        id = 35
        ,boss_id = 14054
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 53}, {?material, 8}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(36) ->
    #tree_stage{
        id = 36
        ,boss_id = 14022
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 37}, {?coin, 53}, {?material, 8}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 1000
        ,boss_strange_odds = 800
    };
get(37) ->
    #tree_stage{
        id = 37
        ,boss_id = 14055
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 50}, {?material, 8}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(38) ->
    #tree_stage{
        id = 38
        ,boss_id = 14056
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 50}, {?material, 8}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(39) ->
    #tree_stage{
        id = 39
        ,boss_id = 14023
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 50}, {?material, 8}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 1000
        ,boss_strange_odds = 800
    };
get(40) ->
    #tree_stage{
        id = 40
        ,boss_id = 14057
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 48}, {?material, 10}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(41) ->
    #tree_stage{
        id = 41
        ,boss_id = 14058
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 48}, {?material, 10}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(42) ->
    #tree_stage{
        id = 42
        ,boss_id = 14024
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 48}, {?material, 10}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 2000
        ,boss_strange_odds = 800
    };
get(43) ->
    #tree_stage{
        id = 43
        ,boss_id = 14059
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 48}, {?material, 10}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(44) ->
    #tree_stage{
        id = 44
        ,boss_id = 14060
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 48}, {?material, 10}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(45) ->
    #tree_stage{
        id = 45
        ,boss_id = 14025
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 48}, {?material, 10}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 2000
        ,boss_strange_odds = 800
    };
get(46) ->
    #tree_stage{
        id = 46
        ,boss_id = 14061
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 48}, {?material, 10}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(47) ->
    #tree_stage{
        id = 47
        ,boss_id = 14062
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 48}, {?material, 10}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(48) ->
    #tree_stage{
        id = 48
        ,boss_id = 14026
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 48}, {?material, 10}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 2000
        ,boss_strange_odds = 800
    };
get(49) ->
    #tree_stage{
        id = 49
        ,boss_id = 14063
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 46}, {?material, 12}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(50) ->
    #tree_stage{
        id = 50
        ,boss_id = 14064
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 46}, {?material, 12}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(51) ->
    #tree_stage{
        id = 51
        ,boss_id = 14027
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 46}, {?material, 12}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 3000
        ,boss_strange_odds = 800
    };
get(52) ->
    #tree_stage{
        id = 52
        ,boss_id = 14065
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 46}, {?material, 12}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(53) ->
    #tree_stage{
        id = 53
        ,boss_id = 14066
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 46}, {?material, 12}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(54) ->
    #tree_stage{
        id = 54
        ,boss_id = 14028
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 40}, {?coin, 46}, {?material, 12}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 3000
        ,boss_strange_odds = 800
    };
get(55) ->
    #tree_stage{
        id = 55
        ,boss_id = 14067
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 42}, {?coin, 54}, {?material, 2}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(56) ->
    #tree_stage{
        id = 56
        ,boss_id = 14068
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 42}, {?coin, 54}, {?material, 2}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(57) ->
    #tree_stage{
        id = 57
        ,boss_id = 14029
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 42}, {?coin, 54}, {?material, 2}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 1000
        ,boss_strange_odds = 800
    };
get(58) ->
    #tree_stage{
        id = 58
        ,boss_id = 14069
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 42}, {?coin, 51}, {?material, 5}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(59) ->
    #tree_stage{
        id = 59
        ,boss_id = 14070
        ,kill_odds = 1000
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 42}, {?coin, 51}, {?material, 5}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 0
        ,boss_strange_odds = 800
    };
get(60) ->
    #tree_stage{
        id = 60
        ,boss_id = 14030
        ,kill_odds = 950
        ,exp = 73
        ,coin = 722
        ,strange_limit = 1
        ,weights = [{?exp, 42}, {?coin, 51}, {?material, 5}, {?strange, 2}]
        ,boss_coin = 722
        ,boss_exp = 73
        ,boss_material_odds = 1500
        ,boss_strange_odds = 800
    };
get(_) ->
    undefined.

material_items(1) ->
    [
        {111101, 1, 100}
    ];
material_items(2) ->
    [
        {111101, 1, 100}
    ];
material_items(3) ->
    [
        {111101, 1, 100}
    ];
material_items(4) ->
    [
        {111101, 1, 70},
        {111101, 2, 30}
    ];
material_items(5) ->
    [
        {111101, 1, 70},
        {111101, 2, 30}
    ];
material_items(6) ->
    [
        {111101, 1, 70},
        {111101, 2, 30}
    ];
material_items(7) ->
    [
        {111101, 1, 20},
        {111101, 2, 80}
    ];
material_items(8) ->
    [
        {111101, 1, 20},
        {111101, 2, 80}
    ];
material_items(9) ->
    [
        {111101, 1, 20},
        {111101, 2, 80}
    ];
material_items(10) ->
    [
        {111101, 2, 100}
    ];
material_items(11) ->
    [
        {111101, 2, 100}
    ];
material_items(12) ->
    [
        {111101, 2, 100}
    ];
material_items(13) ->
    [
        {111102, 1, 100}
    ];
material_items(14) ->
    [
        {111102, 1, 100}
    ];
material_items(15) ->
    [
        {111102, 1, 100}
    ];
material_items(16) ->
    [
        {111102, 1, 100}
    ];
material_items(17) ->
    [
        {111102, 1, 100}
    ];
material_items(18) ->
    [
        {111102, 1, 100}
    ];
material_items(19) ->
    [
        {111102, 1, 100}
    ];
material_items(20) ->
    [
        {111102, 1, 100}
    ];
material_items(21) ->
    [
        {111102, 1, 100}
    ];
material_items(22) ->
    [
        {111102, 1, 100}
    ];
material_items(23) ->
    [
        {111102, 1, 100}
    ];
material_items(24) ->
    [
        {111102, 1, 100}
    ];
material_items(25) ->
    [
        {111102, 1, 80},
        {111102, 2, 20}
    ];
material_items(26) ->
    [
        {111102, 1, 80},
        {111102, 2, 20}
    ];
material_items(27) ->
    [
        {111102, 1, 80},
        {111102, 2, 20}
    ];
material_items(28) ->
    [
        {111102, 1, 100}
    ];
material_items(29) ->
    [
        {111102, 1, 100}
    ];
material_items(30) ->
    [
        {111102, 1, 100}
    ];
material_items(31) ->
    [
        {111103, 1, 100}
    ];
material_items(32) ->
    [
        {111103, 1, 100}
    ];
material_items(33) ->
    [
        {111103, 1, 100}
    ];
material_items(34) ->
    [
        {111103, 1, 100}
    ];
material_items(35) ->
    [
        {111103, 1, 100}
    ];
material_items(36) ->
    [
        {111103, 1, 100}
    ];
material_items(37) ->
    [
        {111103, 1, 100}
    ];
material_items(38) ->
    [
        {111103, 1, 100}
    ];
material_items(39) ->
    [
        {111103, 1, 100}
    ];
material_items(40) ->
    [
        {111103, 1, 100}
    ];
material_items(41) ->
    [
        {111103, 1, 100}
    ];
material_items(42) ->
    [
        {111103, 1, 100}
    ];
material_items(43) ->
    [
        {111103, 1, 100}
    ];
material_items(44) ->
    [
        {111103, 1, 100}
    ];
material_items(45) ->
    [
        {111103, 1, 100}
    ];
material_items(46) ->
    [
        {111103, 1, 100}
    ];
material_items(47) ->
    [
        {111103, 1, 100}
    ];
material_items(48) ->
    [
        {111103, 1, 100}
    ];
material_items(49) ->
    [
        {111103, 1, 100}
    ];
material_items(50) ->
    [
        {111103, 1, 100}
    ];
material_items(51) ->
    [
        {111103, 1, 100}
    ];
material_items(52) ->
    [
        {111103, 1, 100}
    ];
material_items(53) ->
    [
        {111103, 1, 100}
    ];
material_items(54) ->
    [
        {111103, 1, 100}
    ];
material_items(55) ->
    [
        {111104, 1, 100}
    ];
material_items(56) ->
    [
        {111104, 1, 100}
    ];
material_items(57) ->
    [
        {111104, 1, 100}
    ];
material_items(58) ->
    [
        {111104, 1, 100}
    ];
material_items(59) ->
    [
        {111104, 1, 100}
    ];
material_items(60) ->
    [
        {111104, 1, 100}
    ];
material_items(_) ->
    [].

strange_items() ->    
    [
        {501201, [{30001, 50}, {30002, 50}], 10},
        {501202, [{30003, 50}, {30004, 50}], 10},
        {501203, [{30005, 50}, {30006, 50}], 10},
        {501204, [{30007, 50}, {30008, 50}], 10},
        {501205, [{30009, 50}, {30010, 50}], 10},
        {501206, [{30011, 50}, {30012, 50}], 10},
        {501207, [{30013, 50}, {30014, 50}], 10},
        {501208, [{30015, 50}, {30016, 50}], 10},
        {501209, [{30017, 50}, {30018, 50}], 10},
        {501210, [{30019, 50}, {30020, 50}], 10}
    ].
