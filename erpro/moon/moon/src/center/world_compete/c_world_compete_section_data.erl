%%----------------------------------------------------
%% 仙道会段位信息配置
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(c_world_compete_section_data).
-export([
        get/1,
        max_lev/0,
        section_mark_to_section_lev/1
    ]
).
-include("common.hrl").
-include("world_compete.hrl").

%% 当前最大段位等级
max_lev() -> 31.

%% 段位积分与等级映射
section_mark_to_section_lev(SectionMark) when SectionMark =< 0 -> 1;
section_mark_to_section_lev(SectionMark) ->
    do_section_mark_to_section_lev(SectionMark, 1, max_lev()).
do_section_mark_to_section_lev(_SectionMark, Max, Max) ->
    #world_compete_section_data{lev = Lev} = c_world_compete_section_data:get(max_lev()),
    Lev;
do_section_mark_to_section_lev(SectionMark, CL, Max) when CL < Max->
    case c_world_compete_section_data:get(CL) of
        #world_compete_section_data{mark = Mark, lev = Lev} when SectionMark < Mark -> Lev-1;
        #world_compete_section_data{mark = Mark, lev = Lev} when SectionMark =:= Mark -> Lev;
        #world_compete_section_data{mark = Mark} when SectionMark > Mark ->
            do_section_mark_to_section_lev(SectionMark, CL+1, Max);
        _ ->
            1
    end.

%% 根据等级获取段位信息
get(1) ->
    #world_compete_section_data{
        lev = 1,
        mark = 0,
        next_mark = 200,
        base_lilian = 60,
        day_lilian = 0,
        day_attainment = 0
    };

get(2) ->
    #world_compete_section_data{
        lev = 2,
        mark = 200,
        next_mark = 220,
        base_lilian = 65,
        day_lilian = 60,
        day_attainment = 100,
        day_item_rewards = [{29480, 1, 1}]
    };

get(3) ->
    #world_compete_section_data{
        lev = 3,
        mark = 420,
        next_mark = 242,
        base_lilian = 70,
        day_lilian = 90,
        day_attainment = 145,
        day_item_rewards = [{29480, 1, 2}]
    };

get(4) ->
    #world_compete_section_data{
        lev = 4,
        mark = 662,
        next_mark = 266,
        base_lilian = 75,
        day_lilian = 120,
        day_attainment = 203,
        day_item_rewards = [{29480, 1, 3}],
        section_over_rewards = [{29484, 1, 2}, {29481, 1, 3}, {29480, 1, 3}]
    };

get(5) ->
    #world_compete_section_data{
        lev = 5,
        mark = 928,
        next_mark = 293,
        base_lilian = 80,
        day_lilian = 150,
        day_attainment = 274,
        day_item_rewards = [{29480, 1, 4}],
        section_over_rewards = [{29484, 1, 2}, {29481, 1, 4}, {29480, 1, 4}]
    };

get(6) ->
    #world_compete_section_data{
        lev = 6,
        mark = 1221,
        next_mark = 322,
        base_lilian = 85,
        day_lilian = 180,
        day_attainment = 360,
        day_item_rewards = [{29480, 1, 5}],
        section_over_rewards = [{29484, 1, 3}, {29482, 1, 3}, {29481, 1, 3}, {29480, 1, 3}]
    };

get(7) ->
    #world_compete_section_data{
        lev = 7,
        mark = 1543,
        next_mark = 354,
        base_lilian = 90,
        day_lilian = 210,
        day_attainment = 460,
        day_item_rewards = [{29480, 1, 6}],
        section_over_rewards = [{29484, 1, 3}, {29482, 1, 3}, {29481, 1, 4}, {29480, 1, 4}]
    };

get(8) ->
    #world_compete_section_data{
        lev = 8,
        mark = 1897,
        next_mark = 389,
        base_lilian = 95,
        day_lilian = 240,
        day_attainment = 573,
        day_item_rewards = [{29480, 1, 7}],
        section_over_rewards = [{29484, 1, 3}, {29482, 1, 4}, {29481, 1, 4}, {29480, 1, 4}]
    };

get(9) ->
    #world_compete_section_data{
        lev = 9,
        mark = 2286,
        next_mark = 428,
        base_lilian = 100,
        day_lilian = 270,
        day_attainment = 698,
        day_item_rewards = [{29480, 1, 8}],
        section_over_rewards = [{29484, 1, 4}, {29482, 1, 4}, {29481, 1, 5}, {29480, 1, 5}]
    };

get(10) ->
    #world_compete_section_data{
        lev = 10,
        mark = 2714,
        next_mark = 471,
        base_lilian = 105,
        day_lilian = 300,
        day_attainment = 834,
        day_item_rewards = [{29480, 1, 9}],
        section_over_rewards = [{29484, 1, 4}, {29482, 1, 5}, {29481, 1, 5}, {29480, 1, 5}]
    };

get(11) ->
    #world_compete_section_data{
        lev = 11,
        mark = 3185,
        next_mark = 518,
        base_lilian = 110,
        day_lilian = 330,
        day_attainment = 979,
        day_item_rewards = [{29480, 1, 9}, {29481, 1, 1}],
        section_over_rewards = [{29484, 1, 4}, {25061, 1, 1}, {29483, 1, 1}, {29482, 1, 5}, {29481, 1, 5}]
    };

get(12) ->
    #world_compete_section_data{
        lev = 12,
        mark = 3703,
        next_mark = 570,
        base_lilian = 115,
        day_lilian = 360,
        day_attainment = 1131,
        day_item_rewards = [{29480, 1, 10}, {29481, 1, 1}],
        section_over_rewards = [{29484, 1, 5}, {25061, 1, 1}, {29483, 1, 2}, {29482, 1, 5}, {29481, 1, 5}]
    };

get(13) ->
    #world_compete_section_data{
        lev = 13,
        mark = 4273,
        next_mark = 627,
        base_lilian = 120,
        day_lilian = 390,
        day_attainment = 1288,
        day_item_rewards = [{29480, 1, 11}, {29481, 1, 1}],
        section_over_rewards = [{29484, 1, 5}, {25061, 1, 2}, {29483, 1, 3}, {29482, 1, 6}, {29481, 1, 6}]
    };

get(14) ->
    #world_compete_section_data{
        lev = 14,
        mark = 4900,
        next_mark = 690,
        base_lilian = 125,
        day_lilian = 420,
        day_attainment = 1448,
        day_item_rewards = [{29480, 1, 11}, {29481, 1, 2}],
        section_over_rewards = [{29484, 1, 5}, {25061, 1, 3}, {29483, 1, 4}, {29482, 1, 6}, {29481, 1, 6}]
    };

get(15) ->
    #world_compete_section_data{
        lev = 15,
        mark = 5590,
        next_mark = 759,
        base_lilian = 130,
        day_lilian = 450,
        day_attainment = 1608,
        day_item_rewards = [{29480, 1, 12}, {29481, 1, 2}],
        section_over_rewards = [{29484, 1, 6}, {25061, 1, 4}, {29483, 1, 6}, {29482, 1, 6}, {29481, 1, 6}]
    };

get(16) ->
    #world_compete_section_data{
        lev = 16,
        mark = 6349,
        next_mark = 835,
        base_lilian = 135,
        day_lilian = 480,
        day_attainment = 1768,
        day_item_rewards = [{29480, 1, 13}, {29481, 1, 2}],
        section_over_rewards = [{29484, 1, 6}, {25060, 1, 1}, {29483, 1, 6}, {29482, 1, 8}, {29481, 1, 8}]
    };

get(17) ->
    #world_compete_section_data{
        lev = 17,
        mark = 7184,
        next_mark = 919,
        base_lilian = 140,
        day_lilian = 510,
        day_attainment = 1925,
        day_item_rewards = [{29480, 1, 13}, {29481, 1, 3}],
        section_over_rewards = [{29484, 1, 6}, {25060, 1, 2}, {29483, 1, 6}, {29482, 1, 10}, {29481, 1, 10}]
    };

get(18) ->
    #world_compete_section_data{
        lev = 18,
        mark = 8103,
        next_mark = 1011,
        base_lilian = 145,
        day_lilian = 540,
        day_attainment = 2078,
        day_item_rewards = [{29480, 1, 14}, {29481, 1, 3}],
        section_over_rewards = [{29484, 1, 8}, {25060, 1, 3}, {29483, 1, 8}, {29482, 1, 10}, {29481, 1, 10}]
    };

get(19) ->
    #world_compete_section_data{
        lev = 19,
        mark = 9114,
        next_mark = 1112,
        base_lilian = 150,
        day_lilian = 570,
        day_attainment = 2226,
        day_item_rewards = [{29480, 1, 15}, {29481, 1, 3}],
        section_over_rewards = [{29484, 1, 9}, {25060, 1, 4}, {29483, 1, 10}, {29482, 1, 10}, {29481, 1, 10}]
    };

get(20) ->
    #world_compete_section_data{
        lev = 20,
        mark = 10226,
        next_mark = 1223,
        base_lilian = 155,
        day_lilian = 600,
        day_attainment = 2369,
        day_item_rewards = [{29480, 1, 16}, {29481, 1, 3}],
        section_over_rewards = [{29484, 1, 10}, {25060, 1, 5}, {29483, 1, 12}, {29482, 1, 12}, {29481, 1, 12}]
    };

get(21) ->
    #world_compete_section_data{
        lev = 21,
        mark = 11449,
        next_mark = 1345,
        base_lilian = 160,
        day_lilian = 630,
        day_attainment = 2505
    };

get(22) ->
    #world_compete_section_data{
        lev = 22,
        mark = 12794,
        next_mark = 1480,
        base_lilian = 165,
        day_lilian = 660,
        day_attainment = 2634
    };

get(23) ->
    #world_compete_section_data{
        lev = 23,
        mark = 14274,
        next_mark = 1628,
        base_lilian = 170,
        day_lilian = 690,
        day_attainment = 2756
    };

get(24) ->
    #world_compete_section_data{
        lev = 24,
        mark = 15902,
        next_mark = 1791,
        base_lilian = 175,
        day_lilian = 720,
        day_attainment = 2871
    };

get(25) ->
    #world_compete_section_data{
        lev = 25,
        mark = 17693,
        next_mark = 1970,
        base_lilian = 180,
        day_lilian = 750,
        day_attainment = 2978
    };

get(26) ->
    #world_compete_section_data{
        lev = 26,
        mark = 19663,
        next_mark = 2167,
        base_lilian = 185,
        day_lilian = 780,
        day_attainment = 3078
    };

get(27) ->
    #world_compete_section_data{
        lev = 27,
        mark = 21830,
        next_mark = 2384,
        base_lilian = 190,
        day_lilian = 810,
        day_attainment = 3171
    };

get(28) ->
    #world_compete_section_data{
        lev = 28,
        mark = 24214,
        next_mark = 2622,
        base_lilian = 195,
        day_lilian = 840,
        day_attainment = 3257
    };

get(29) ->
    #world_compete_section_data{
        lev = 29,
        mark = 26836,
        next_mark = 2884,
        base_lilian = 200,
        day_lilian = 870,
        day_attainment = 3336
    };

get(30) ->
    #world_compete_section_data{
        lev = 30,
        mark = 29720,
        next_mark = 3172,
        base_lilian = 205,
        day_lilian = 900,
        day_attainment = 3409
    };

get(31) ->
    #world_compete_section_data{
        lev = 31,
        mark = 29720,
        next_mark = 3172,
        base_lilian = 210,
        day_lilian = 930,
        day_attainment = 3500
    };

get(_) ->
    undefined.
