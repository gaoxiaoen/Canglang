%%----------------------------------------------------
%% 副本配置数据
%% @author mobin
%% @end
%%----------------------------------------------------
-module(dungeon_data).
-export([
        all/0,
        get/1,
        all_map/0,
        map/1
    ]
).
-include("common.hrl").
-include("dungeon.hrl").
-include("condition.hrl").
-include("gain.hrl").

all() ->
    [
1300, 10011, 10021, 10031, 10041, 10051, 10061, 10071, 10081, 10091, 10101, 10111, 11011, 11021, 11031, 11041, 11051, 11061, 11071, 11081, 11091, 12011, 12021, 12031, 12041, 12051, 12061, 12071, 12081, 12091, 12101, 12111, 12121, 12131, 13011, 13021, 13031, 13041, 13051, 13061, 13071, 13081, 13091, 13101, 13111, 13121, 14011, 14021, 14031, 14041, 14051, 14061, 14071, 14081, 14091, 14101, 14111, 14121, 15011, 15021, 15031, 15041, 15051, 15061, 15071, 15081, 15091, 15101, 15111, 15121, 15131, 16011, 16021, 16031, 16041, 16051, 16061, 16071, 16081, 16091, 16101, 16111, 16121, 16131, 17011, 17021, 17031, 17041, 17051, 17061, 17071, 17081, 17091, 17101, 17111, 17121, 17131, 18011, 18021, 18031, 18041, 18051, 18061, 18071, 18081, 18091, 18101, 18111, 18121, 18131, 10012, 10022, 10032, 10042, 10052, 10062, 10072, 10082, 10092, 10102, 10112, 11012, 11022, 11032, 11042, 11052, 11062, 11072, 11082, 11092, 12012, 12022, 12032, 12042, 12052, 12062, 12072, 12082, 12092, 12102, 12112, 12122, 12132, 13012, 13022, 13032, 13042, 13052, 13062, 13072, 13082, 13092, 13102, 13112, 13122, 14012, 14022, 14032, 14042, 14052, 14062, 14072, 14082, 14092, 14102, 14112, 14122, 15012, 15022, 15032, 15042, 15052, 15062, 15072, 15082, 15092, 15102, 15112, 15122, 15132, 16012, 16022, 16032, 16042, 16052, 16062, 16072, 16082, 16092, 16102, 16112, 16122, 16132, 17012, 17022, 17032, 17042, 17052, 17062, 17072, 17082, 17092, 17102, 17112, 17122, 17132, 18012, 18022, 18032, 18042, 18052, 18062, 18072, 18082, 18092, 18102, 18112, 18122, 18132
    ].

get(1300) ->
    #dungeon_base{
        id = 1300
        ,name = <<"沐晨危机">>
        ,type = 5
        ,show_type = 1
        ,args = [1401,1500,500]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 1300, msg = <<"次数不足">>}, #condition{label = energy, target_value = 0, msg = <<"体力不足">>}, #loss{label = energy, val = 0}]
        ,maps = [1300]
        ,enter_point = {1300, 420, 433}
        ,pet_exp = 0
        ,energy = 0 
        ,clear_rewards = [#gain{label = exp, val = 0}, #gain{label = coin, val = 0}, #gain{label = attainment, val = 0}]
    };
get(10011) ->
    #dungeon_base{
        id = 10011
        ,name = <<"精灵之森">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10011, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10011]
        ,enter_point = {10011, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [131007,1,1]}}, {3, #gain{label = item, val = [131016,1,1]}}, {5, #gain{label = item, val = [131029,1,1]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 866}, #gain{label = attainment, val = 51}]
    };
get(10021) ->
    #dungeon_base{
        id = 10021
        ,name = <<"日光小径 ">>
        ,type = 4
        ,show_type = 0
        ,args = [8,2]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10021, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10021]
        ,enter_point = {10021, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1118}, #gain{label = attainment, val = 85}]
    };
get(10031) ->
    #dungeon_base{
        id = 10031
        ,name = <<"日光小径 ">>
        ,type = 4
        ,show_type = 1
        ,args = [8,2]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10031, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10031]
        ,enter_point = {10031, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [131004,1,1]}}, {3, #gain{label = item, val = [131018,1,1]}}, {5, #gain{label = item, val = [131026,1,1]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1118}, #gain{label = attainment, val = 85}]
    };
get(10041) ->
    #dungeon_base{
        id = 10041
        ,name = <<"月光森林">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10041, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10041]
        ,enter_point = {10041, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1225}, #gain{label = attainment, val = 102}]
    };
get(10051) ->
    #dungeon_base{
        id = 10051
        ,name = <<"月光森林">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10051, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10051]
        ,enter_point = {10051, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1225}, #gain{label = attainment, val = 102}]
    };
get(10061) ->
    #dungeon_base{
        id = 10061
        ,name = <<"魅影丛林">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10061, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10061]
        ,enter_point = {10061, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1323}, #gain{label = attainment, val = 119}]
    };
get(10071) ->
    #dungeon_base{
        id = 10071
        ,name = <<"魅影丛林">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10071, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10071]
        ,enter_point = {10071, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1323}, #gain{label = attainment, val = 119}]
    };
get(10081) ->
    #dungeon_base{
        id = 10081
        ,name = <<"影月林间">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10081, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10081]
        ,enter_point = {10081, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [131005,1,1]}}, {3, #gain{label = item, val = [131015,1,1]}}, {5, #gain{label = item, val = [131028,1,1]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1414}, #gain{label = attainment, val = 136}]
    };
get(10091) ->
    #dungeon_base{
        id = 10091
        ,name = <<"影月林间">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10091, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10091]
        ,enter_point = {10091, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1414}, #gain{label = attainment, val = 136}]
    };
get(10101) ->
    #dungeon_base{
        id = 10101
        ,name = <<"神鸦秘林">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10101, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10101]
        ,enter_point = {10101, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1414}, #gain{label = attainment, val = 136}]
    };
get(10111) ->
    #dungeon_base{
        id = 10111
        ,name = <<"神鸦秘林">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10111, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [10111]
        ,enter_point = {10111, 420, 433}
        ,pet_exp = 0
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1414}, #gain{label = attainment, val = 136}]
    };
get(11011) ->
    #dungeon_base{
        id = 11011
        ,name = <<"晨曦小径">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11011, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [11011]
        ,enter_point = {11011, 420, 433}
        ,pet_exp = 500
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [131006,1,1]}}, {3, #gain{label = item, val = [131017,1,1]}}, {5, #gain{label = item, val = [131027,1,1]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1732}, #gain{label = attainment, val = 204}]
    };
get(11021) ->
    #dungeon_base{
        id = 11021
        ,name = <<"绿涛旷野">>
        ,type = 4
        ,show_type = 0
        ,args = [15,1]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11021, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [11021]
        ,enter_point = {11021, 420, 433}
        ,pet_exp = 550
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1803}, #gain{label = attainment, val = 221}]
    };
get(11031) ->
    #dungeon_base{
        id = 11031
        ,name = <<"绿涛旷野">>
        ,type = 4
        ,show_type = 1
        ,args = [15,1]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11031, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [11031]
        ,enter_point = {11031, 420, 433}
        ,pet_exp = 600
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1803}, #gain{label = attainment, val = 221}]
    };
get(11041) ->
    #dungeon_base{
        id = 11041
        ,name = <<"崇神湿地">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11041, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [11041]
        ,enter_point = {11041, 420, 433}
        ,pet_exp = 700
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1871}, #gain{label = attainment, val = 238}]
    };
get(11051) ->
    #dungeon_base{
        id = 11051
        ,name = <<"崇神湿地">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11051, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [11051]
        ,enter_point = {11051, 420, 433}
        ,pet_exp = 750
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [131008,1,1]}}, {3, #gain{label = item, val = [131019,1,1]}}, {5, #gain{label = item, val = [131030,1,1]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1871}, #gain{label = attainment, val = 238}]
    };
get(11061) ->
    #dungeon_base{
        id = 11061
        ,name = <<"贫瘠腹地">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11061, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [11061]
        ,enter_point = {11061, 420, 433}
        ,pet_exp = 800
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1936}, #gain{label = attainment, val = 255}]
    };
get(11071) ->
    #dungeon_base{
        id = 11071
        ,name = <<"贫瘠腹地">>
        ,type = 3
        ,show_type = 1
        ,args = [6,10328,10329,10633,10634
]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11071, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [11071]
        ,enter_point = {11071, 420, 433}
        ,pet_exp = 850
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1936}, #gain{label = attainment, val = 255}]
    };
get(11081) ->
    #dungeon_base{
        id = 11081
        ,name = <<"女神祭台">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11081, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [11081]
        ,enter_point = {11081, 420, 433}
        ,pet_exp = 950
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2000}, #gain{label = attainment, val = 272}]
    };
get(11091) ->
    #dungeon_base{
        id = 11091
        ,name = <<"女神祭台">>
        ,type = 8
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11091, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [11091]
        ,enter_point = {11091, 420, 433}
        ,pet_exp = 950
        ,energy = 5 
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2000}, #gain{label = attainment, val = 272}]
    };
get(12011) ->
    #dungeon_base{
        id = 12011
        ,name = <<"遗忘之路">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12011, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12011]
        ,enter_point = {12011, 420, 433}
        ,pet_exp = 1000
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2345}, #gain{label = attainment, val = 374}]
    };
get(12021) ->
    #dungeon_base{
        id = 12021
        ,name = <<"失落沙丘">>
        ,type = 4
        ,show_type = 0
        ,args = [15,1]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12021, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12021]
        ,enter_point = {12021, 420, 433}
        ,pet_exp = 1050
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2398}, #gain{label = attainment, val = 391}]
    };
get(12031) ->
    #dungeon_base{
        id = 12031
        ,name = <<"失落沙丘">>
        ,type = 4
        ,show_type = 1
        ,args = [15,1]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12031, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12031]
        ,enter_point = {12031, 420, 433}
        ,pet_exp = 1100
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [131009,1,1]}}, {3, #gain{label = item, val = [131020,1,1]}}, {5, #gain{label = item, val = [131031,1,1]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2398}, #gain{label = attainment, val = 391}]
    };
get(12041) ->
    #dungeon_base{
        id = 12041
        ,name = <<"祭祀迷道">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12041, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12041]
        ,enter_point = {12041, 420, 433}
        ,pet_exp = 1150
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2449}, #gain{label = attainment, val = 408}]
    };
get(12051) ->
    #dungeon_base{
        id = 12051
        ,name = <<"祭祀迷道">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12051, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12051]
        ,enter_point = {12051, 420, 433}
        ,pet_exp = 1200
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2449}, #gain{label = attainment, val = 408}]
    };
get(12061) ->
    #dungeon_base{
        id = 12061
        ,name = <<"祭祀迷道">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12061, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12061]
        ,enter_point = {12061, 420, 433}
        ,pet_exp = 1250
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [131010,1,1]}}, {3, #gain{label = item, val = [131021,1,1]}}, {5, #gain{label = item, val = [131032,1,1]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2449}, #gain{label = attainment, val = 408}]
    };
get(12071) ->
    #dungeon_base{
        id = 12071
        ,name = <<"毒蝎之穴">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12071, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12071]
        ,enter_point = {12071, 420, 433}
        ,pet_exp = 1300
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2550}, #gain{label = attainment, val = 442}]
    };
get(12081) ->
    #dungeon_base{
        id = 12081
        ,name = <<"毒蝎之穴">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12081, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12081]
        ,enter_point = {12081, 420, 433}
        ,pet_exp = 1350
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [131012,1,1]}}, {3, #gain{label = item, val = [131022,1,1]}}, {5, #gain{label = item, val = [131033,1,1]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2550}, #gain{label = attainment, val = 442}]
    };
get(12091) ->
    #dungeon_base{
        id = 12091
        ,name = <<"荒漠废墟">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12091, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12091]
        ,enter_point = {12091, 420, 433}
        ,pet_exp = 1400
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2598}, #gain{label = attainment, val = 459}]
    };
get(12101) ->
    #dungeon_base{
        id = 12101
        ,name = <<"荒漠废墟">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12101, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12101]
        ,enter_point = {12101, 420, 433}
        ,pet_exp = 1400
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2598}, #gain{label = attainment, val = 459}]
    };
get(12111) ->
    #dungeon_base{
        id = 12111
        ,name = <<"荒漠废墟">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12111, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12111]
        ,enter_point = {12111, 420, 433}
        ,pet_exp = 1450
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [131013,1,1]}}, {3, #gain{label = item, val = [131023,1,1]}}, {5, #gain{label = item, val = [131034,1,1]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2598}, #gain{label = attainment, val = 459}]
    };
get(12121) ->
    #dungeon_base{
        id = 12121
        ,name = <<"迷迹腹地">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12121, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12121]
        ,enter_point = {12121, 420, 433}
        ,pet_exp = 1450
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2646}, #gain{label = attainment, val = 476}]
    };
get(12131) ->
    #dungeon_base{
        id = 12131
        ,name = <<"迷迹腹地">>
        ,type = 8
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12131, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [12131]
        ,enter_point = {12131, 420, 433}
        ,pet_exp = 1450
        ,energy = 5 
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 2646}, #gain{label = attainment, val = 476}]
    };
get(13011) ->
    #dungeon_base{
        id = 13011
        ,name = <<"树根之路">>
        ,type = 3
        ,show_type = 1
        ,args = [10,10352,10353]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13011, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13011]
        ,enter_point = {13011, 420, 433}
        ,pet_exp = 1500
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1392}, #gain{label = attainment, val = 527}]
    };
get(13021) ->
    #dungeon_base{
        id = 13021
        ,name = <<"虚渺根林">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13021, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13021]
        ,enter_point = {13021, 420, 433}
        ,pet_exp = 1500
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1414}, #gain{label = attainment, val = 544}]
    };
get(13031) ->
    #dungeon_base{
        id = 13031
        ,name = <<"虚渺根林">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13031, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13031]
        ,enter_point = {13031, 420, 433}
        ,pet_exp = 1550
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [131011,1,1]}}, {3, #gain{label = item, val = [131024,1,1]}}, {5, #gain{label = item, val = [131035,1,1]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1414}, #gain{label = attainment, val = 544}]
    };
get(13041) ->
    #dungeon_base{
        id = 13041
        ,name = <<"萤火之森">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13041, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13041]
        ,enter_point = {13041, 420, 433}
        ,pet_exp = 1550
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1436}, #gain{label = attainment, val = 561}]
    };
get(13051) ->
    #dungeon_base{
        id = 13051
        ,name = <<"萤火之森">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13051, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13051]
        ,enter_point = {13051, 420, 433}
        ,pet_exp = 1600
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1436}, #gain{label = attainment, val = 561}]
    };
get(13061) ->
    #dungeon_base{
        id = 13061
        ,name = <<"萤火之森">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13061, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13061]
        ,enter_point = {13061, 420, 433}
        ,pet_exp = 1600
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1436}, #gain{label = attainment, val = 561}]
    };
get(13071) ->
    #dungeon_base{
        id = 13071
        ,name = <<"神源之地">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13071, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13071]
        ,enter_point = {13071, 420, 433}
        ,pet_exp = 1650
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1458}, #gain{label = attainment, val = 578}]
    };
get(13081) ->
    #dungeon_base{
        id = 13081
        ,name = <<"神源之地">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13081, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13081]
        ,enter_point = {13081, 420, 433}
        ,pet_exp = 1650
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1458}, #gain{label = attainment, val = 578}]
    };
get(13091) ->
    #dungeon_base{
        id = 13091
        ,name = <<"神源之地">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13091, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13091]
        ,enter_point = {13091, 420, 433}
        ,pet_exp = 1650
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1458}, #gain{label = attainment, val = 578}]
    };
get(13101) ->
    #dungeon_base{
        id = 13101
        ,name = <<"盘根之谷">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13101, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13101]
        ,enter_point = {13101, 420, 433}
        ,pet_exp = 1700
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1479}, #gain{label = attainment, val = 595}]
    };
get(13111) ->
    #dungeon_base{
        id = 13111
        ,name = <<"盘根之谷">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13111, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13111]
        ,enter_point = {13111, 420, 433}
        ,pet_exp = 1700
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1479}, #gain{label = attainment, val = 595}]
    };
get(13121) ->
    #dungeon_base{
        id = 13121
        ,name = <<"盘根之谷">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13121, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [13121]
        ,enter_point = {13121, 420, 433}
        ,pet_exp = 1700
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1479}, #gain{label = attainment, val = 595}]
    };
get(14011) ->
    #dungeon_base{
        id = 14011
        ,name = <<"荧光洞穴">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14011, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14011]
        ,enter_point = {14011, 420, 433}
        ,pet_exp = 1750
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1500}, #gain{label = attainment, val = 612}]
    };
get(14021) ->
    #dungeon_base{
        id = 14021
        ,name = <<"沉寂湖畔">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14021, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14021]
        ,enter_point = {14021, 420, 433}
        ,pet_exp = 1750
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1521}, #gain{label = attainment, val = 629}]
    };
get(14031) ->
    #dungeon_base{
        id = 14031
        ,name = <<"沉寂湖畔">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14031, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14031]
        ,enter_point = {14031, 420, 433}
        ,pet_exp = 1800
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1521}, #gain{label = attainment, val = 629}]
    };
get(14041) ->
    #dungeon_base{
        id = 14041
        ,name = <<"树根囚笼">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14041, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14041]
        ,enter_point = {14041, 420, 433}
        ,pet_exp = 1800
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1541}, #gain{label = attainment, val = 646}]
    };
get(14051) ->
    #dungeon_base{
        id = 14051
        ,name = <<"树根囚笼">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14051, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14051]
        ,enter_point = {14051, 420, 433}
        ,pet_exp = 1850
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1541}, #gain{label = attainment, val = 646}]
    };
get(14061) ->
    #dungeon_base{
        id = 14061
        ,name = <<"树根囚笼">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14061, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14061]
        ,enter_point = {14061, 420, 433}
        ,pet_exp = 1850
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1541}, #gain{label = attainment, val = 646}]
    };
get(14071) ->
    #dungeon_base{
        id = 14071
        ,name = <<"幽暗地穴">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14071, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14071]
        ,enter_point = {14071, 420, 433}
        ,pet_exp = 1900
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1561}, #gain{label = attainment, val = 663}]
    };
get(14081) ->
    #dungeon_base{
        id = 14081
        ,name = <<"幽暗地穴">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14081, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14081]
        ,enter_point = {14081, 420, 433}
        ,pet_exp = 1900
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1561}, #gain{label = attainment, val = 663}]
    };
get(14091) ->
    #dungeon_base{
        id = 14091
        ,name = <<"幽暗地穴">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14091, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14091]
        ,enter_point = {14091, 420, 433}
        ,pet_exp = 1950
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1561}, #gain{label = attainment, val = 663}]
    };
get(14101) ->
    #dungeon_base{
        id = 14101
        ,name = <<"迷踪深渊">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14101, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14101]
        ,enter_point = {14101, 420, 433}
        ,pet_exp = 1950
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1581}, #gain{label = attainment, val = 680}]
    };
get(14111) ->
    #dungeon_base{
        id = 14111
        ,name = <<"迷踪深渊">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14111, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14111]
        ,enter_point = {14111, 420, 433}
        ,pet_exp = 1950
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1581}, #gain{label = attainment, val = 680}]
    };
get(14121) ->
    #dungeon_base{
        id = 14121
        ,name = <<"迷踪深渊">>
        ,type = 8
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14121, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [14121]
        ,enter_point = {14121, 420, 433}
        ,pet_exp = 1950
        ,energy = 5 
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1581}, #gain{label = attainment, val = 680}]
    };
get(15011) ->
    #dungeon_base{
        id = 15011
        ,name = <<"凛冽冰谷">>
        ,type = 3
        ,show_type = 1
        ,args = [14,10382,10383]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15011, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15011]
        ,enter_point = {15011, 420, 433}
        ,pet_exp = 2000
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1601}, #gain{label = attainment, val = 697}]
    };
get(15021) ->
    #dungeon_base{
        id = 15021
        ,name = <<"冰棱之森">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15021, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15021]
        ,enter_point = {15021, 420, 433}
        ,pet_exp = 2000
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1620}, #gain{label = attainment, val = 714}]
    };
get(15031) ->
    #dungeon_base{
        id = 15031
        ,name = <<"冰棱之森">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15031, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15031]
        ,enter_point = {15031, 420, 433}
        ,pet_exp = 2050
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1620}, #gain{label = attainment, val = 714}]
    };
get(15041) ->
    #dungeon_base{
        id = 15041
        ,name = <<"冰棱之森">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15041, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15041]
        ,enter_point = {15041, 420, 433}
        ,pet_exp = 2050
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1620}, #gain{label = attainment, val = 714}]
    };
get(15051) ->
    #dungeon_base{
        id = 15051
        ,name = <<"风暴要塞">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15051, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15051]
        ,enter_point = {15051, 420, 433}
        ,pet_exp = 2100
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1639}, #gain{label = attainment, val = 731}]
    };
get(15061) ->
    #dungeon_base{
        id = 15061
        ,name = <<"风暴要塞">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15061, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15061]
        ,enter_point = {15061, 420, 433}
        ,pet_exp = 2100
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1639}, #gain{label = attainment, val = 731}]
    };
get(15071) ->
    #dungeon_base{
        id = 15071
        ,name = <<"风暴要塞">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15071, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15071]
        ,enter_point = {15071, 420, 433}
        ,pet_exp = 2100
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1639}, #gain{label = attainment, val = 731}]
    };
get(15081) ->
    #dungeon_base{
        id = 15081
        ,name = <<"荒芜雪野">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15081, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15081]
        ,enter_point = {15081, 420, 433}
        ,pet_exp = 2150
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1658}, #gain{label = attainment, val = 748}]
    };
get(15091) ->
    #dungeon_base{
        id = 15091
        ,name = <<"荒芜雪野">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15091, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15091]
        ,enter_point = {15091, 420, 433}
        ,pet_exp = 2150
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1658}, #gain{label = attainment, val = 748}]
    };
get(15101) ->
    #dungeon_base{
        id = 15101
        ,name = <<"荒芜雪野">>
        ,type = 3
        ,show_type = 1
        ,args = [18,10405,10406,10393,10394]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15101, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15101]
        ,enter_point = {15101, 420, 433}
        ,pet_exp = 2150
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1658}, #gain{label = attainment, val = 748}]
    };
get(15111) ->
    #dungeon_base{
        id = 15111
        ,name = <<"狼嚎野岭">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15111, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15111]
        ,enter_point = {15111, 420, 433}
        ,pet_exp = 2200
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1677}, #gain{label = attainment, val = 765}]
    };
get(15121) ->
    #dungeon_base{
        id = 15121
        ,name = <<"狼嚎野岭">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15121, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15121]
        ,enter_point = {15121, 420, 433}
        ,pet_exp = 2200
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1677}, #gain{label = attainment, val = 765}]
    };
get(15131) ->
    #dungeon_base{
        id = 15131
        ,name = <<"狼嚎野岭">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15131, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [15131]
        ,enter_point = {15131, 420, 433}
        ,pet_exp = 2200
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1677}, #gain{label = attainment, val = 765}]
    };
get(16011) ->
    #dungeon_base{
        id = 16011
        ,name = <<"刀锋高地">>
        ,type = 3
        ,show_type = 1
        ,args = [8,10397,10398]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16011, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16011]
        ,enter_point = {16011, 420, 433}
        ,pet_exp = 2250
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1696}, #gain{label = attainment, val = 782}]
    };
get(16021) ->
    #dungeon_base{
        id = 16021
        ,name = <<"巨槌峰峦">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16021, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16021]
        ,enter_point = {16021, 420, 433}
        ,pet_exp = 2300
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1714}, #gain{label = attainment, val = 799}]
    };
get(16031) ->
    #dungeon_base{
        id = 16031
        ,name = <<"巨槌峰峦">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16031, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16031]
        ,enter_point = {16031, 420, 433}
        ,pet_exp = 2300
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1714}, #gain{label = attainment, val = 799}]
    };
get(16041) ->
    #dungeon_base{
        id = 16041
        ,name = <<"巨槌峰峦">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16041, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16041]
        ,enter_point = {16041, 420, 433}
        ,pet_exp = 2350
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1714}, #gain{label = attainment, val = 799}]
    };
get(16051) ->
    #dungeon_base{
        id = 16051
        ,name = <<"暮色雪岭">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16051, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16051]
        ,enter_point = {16051, 420, 433}
        ,pet_exp = 2400
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1732}, #gain{label = attainment, val = 816}]
    };
get(16061) ->
    #dungeon_base{
        id = 16061
        ,name = <<"暮色雪岭">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16061, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16061]
        ,enter_point = {16061, 420, 433}
        ,pet_exp = 2400
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1732}, #gain{label = attainment, val = 816}]
    };
get(16071) ->
    #dungeon_base{
        id = 16071
        ,name = <<"暮色雪岭">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16071, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16071]
        ,enter_point = {16071, 420, 433}
        ,pet_exp = 2450
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1732}, #gain{label = attainment, val = 816}]
    };
get(16081) ->
    #dungeon_base{
        id = 16081
        ,name = <<"风雪之巅">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16081, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16081]
        ,enter_point = {16081, 420, 433}
        ,pet_exp = 2450
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1750}, #gain{label = attainment, val = 833}]
    };
get(16091) ->
    #dungeon_base{
        id = 16091
        ,name = <<"风雪之巅">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16091, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16091]
        ,enter_point = {16091, 420, 433}
        ,pet_exp = 2500
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1750}, #gain{label = attainment, val = 833}]
    };
get(16101) ->
    #dungeon_base{
        id = 16101
        ,name = <<"风雪之巅">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16101, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16101]
        ,enter_point = {16101, 420, 433}
        ,pet_exp = 2500
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1750}, #gain{label = attainment, val = 833}]
    };
get(16111) ->
    #dungeon_base{
        id = 16111
        ,name = <<"巨人山城">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16111, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16111]
        ,enter_point = {16111, 420, 433}
        ,pet_exp = 2500
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1768}, #gain{label = attainment, val = 850}]
    };
get(16121) ->
    #dungeon_base{
        id = 16121
        ,name = <<"巨人山城">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16121, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16121]
        ,enter_point = {16121, 420, 433}
        ,pet_exp = 2500
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1768}, #gain{label = attainment, val = 850}]
    };
get(16131) ->
    #dungeon_base{
        id = 16131
        ,name = <<"巨人山城">>
        ,type = 8
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16131, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [16131]
        ,enter_point = {16131, 420, 433}
        ,pet_exp = 2500
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 1768}, #gain{label = attainment, val = 850}]
    };
get(17011) ->
    #dungeon_base{
        id = 17011
        ,name = <<"暮光峡湾">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17011, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17011]
        ,enter_point = {17011, 420, 433}
        ,pet_exp = 2550
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3571}, #gain{label = attainment, val = 867}]
    };
get(17021) ->
    #dungeon_base{
        id = 17021
        ,name = <<"荒骨走道">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17021, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17021]
        ,enter_point = {17021, 420, 433}
        ,pet_exp = 2550
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3606}, #gain{label = attainment, val = 884}]
    };
get(17031) ->
    #dungeon_base{
        id = 17031
        ,name = <<"荒骨走道">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17031, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17031]
        ,enter_point = {17031, 420, 433}
        ,pet_exp = 2600
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3606}, #gain{label = attainment, val = 884}]
    };
get(17041) ->
    #dungeon_base{
        id = 17041
        ,name = <<"荒骨走道">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17041, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17041]
        ,enter_point = {17041, 420, 433}
        ,pet_exp = 2600
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3606}, #gain{label = attainment, val = 884}]
    };
get(17051) ->
    #dungeon_base{
        id = 17051
        ,name = <<"荒废之路">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17051, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17051]
        ,enter_point = {17051, 420, 433}
        ,pet_exp = 2650
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3640}, #gain{label = attainment, val = 901}]
    };
get(17061) ->
    #dungeon_base{
        id = 17061
        ,name = <<"荒废之路">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17061, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17061]
        ,enter_point = {17061, 420, 433}
        ,pet_exp = 2650
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3640}, #gain{label = attainment, val = 901}]
    };
get(17071) ->
    #dungeon_base{
        id = 17071
        ,name = <<"荒废之路">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17071, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17071]
        ,enter_point = {17071, 420, 433}
        ,pet_exp = 2650
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3640}, #gain{label = attainment, val = 901}]
    };
get(17081) ->
    #dungeon_base{
        id = 17081
        ,name = <<"绝望回廊">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17081, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17081]
        ,enter_point = {17081, 420, 433}
        ,pet_exp = 2700
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3674}, #gain{label = attainment, val = 918}]
    };
get(17091) ->
    #dungeon_base{
        id = 17091
        ,name = <<"绝望回廊">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17091, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17091]
        ,enter_point = {17091, 420, 433}
        ,pet_exp = 2700
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3674}, #gain{label = attainment, val = 918}]
    };
get(17101) ->
    #dungeon_base{
        id = 17101
        ,name = <<"绝望回廊">>
        ,type = 3
        ,show_type = 1
        ,args = [18,10655,10656,10657,10658
]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17101, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17101]
        ,enter_point = {17101, 420, 433}
        ,pet_exp = 2700
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3674}, #gain{label = attainment, val = 918}]
    };
get(17111) ->
    #dungeon_base{
        id = 17111
        ,name = <<"地牢入口">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17111, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17111]
        ,enter_point = {17111, 420, 433}
        ,pet_exp = 2750
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3708}, #gain{label = attainment, val = 935}]
    };
get(17121) ->
    #dungeon_base{
        id = 17121
        ,name = <<"地牢入口">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17121, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17121]
        ,enter_point = {17121, 420, 433}
        ,pet_exp = 2750
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3708}, #gain{label = attainment, val = 935}]
    };
get(17131) ->
    #dungeon_base{
        id = 17131
        ,name = <<"地牢入口">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17131, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [17131]
        ,enter_point = {17131, 420, 433}
        ,pet_exp = 2750
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3708}, #gain{label = attainment, val = 935}]
    };
get(18011) ->
    #dungeon_base{
        id = 18011
        ,name = <<"噩梦地牢">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18011, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18011]
        ,enter_point = {18011, 420, 433}
        ,pet_exp = 2800
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3742}, #gain{label = attainment, val = 952}]
    };
get(18021) ->
    #dungeon_base{
        id = 18021
        ,name = <<"幽魂牢笼">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18021, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18021]
        ,enter_point = {18021, 420, 433}
        ,pet_exp = 2800
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3775}, #gain{label = attainment, val = 969}]
    };
get(18031) ->
    #dungeon_base{
        id = 18031
        ,name = <<"幽魂牢笼">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18031, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18031]
        ,enter_point = {18031, 420, 433}
        ,pet_exp = 2850
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3775}, #gain{label = attainment, val = 969}]
    };
get(18041) ->
    #dungeon_base{
        id = 18041
        ,name = <<"幽魂牢笼">>
        ,type = 3
        ,show_type = 1
        ,args = [18,10664,10665,10669,10670
]
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18041, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18041]
        ,enter_point = {18041, 420, 433}
        ,pet_exp = 2850
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3775}, #gain{label = attainment, val = 969}]
    };
get(18051) ->
    #dungeon_base{
        id = 18051
        ,name = <<"森火之狱">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18051, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18051]
        ,enter_point = {18051, 420, 433}
        ,pet_exp = 2900
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3808}, #gain{label = attainment, val = 986}]
    };
get(18061) ->
    #dungeon_base{
        id = 18061
        ,name = <<"森火之狱">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18061, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18061]
        ,enter_point = {18061, 420, 433}
        ,pet_exp = 2900
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3808}, #gain{label = attainment, val = 986}]
    };
get(18071) ->
    #dungeon_base{
        id = 18071
        ,name = <<"森火之狱">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18071, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18071]
        ,enter_point = {18071, 420, 433}
        ,pet_exp = 2900
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3808}, #gain{label = attainment, val = 986}]
    };
get(18081) ->
    #dungeon_base{
        id = 18081
        ,name = <<"厄运牢房">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18081, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18081]
        ,enter_point = {18081, 420, 433}
        ,pet_exp = 2950
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3841}, #gain{label = attainment, val = 1003}]
    };
get(18091) ->
    #dungeon_base{
        id = 18091
        ,name = <<"厄运牢房">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18091, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18091]
        ,enter_point = {18091, 420, 433}
        ,pet_exp = 2950
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3841}, #gain{label = attainment, val = 1003}]
    };
get(18101) ->
    #dungeon_base{
        id = 18101
        ,name = <<"厄运牢房">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18101, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18101]
        ,enter_point = {18101, 420, 433}
        ,pet_exp = 2950
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3841}, #gain{label = attainment, val = 1003}]
    };
get(18111) ->
    #dungeon_base{
        id = 18111
        ,name = <<"沉息之地">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18111, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18111]
        ,enter_point = {18111, 420, 433}
        ,pet_exp = 3000
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3873}, #gain{label = attainment, val = 1020}]
    };
get(18121) ->
    #dungeon_base{
        id = 18121
        ,name = <<"沉息之地">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18121, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18121]
        ,enter_point = {18121, 420, 433}
        ,pet_exp = 3000
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3873}, #gain{label = attainment, val = 1020}]
    };
get(18131) ->
    #dungeon_base{
        id = 18131
        ,name = <<"沉息之地">>
        ,type = 8
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18131, msg = <<"次数不足">>}, #condition{label = energy, target_value = 5, msg = <<"体力不足">>}, #loss{label = energy, val = 5}]
        ,maps = [18131]
        ,enter_point = {18131, 420, 433}
        ,pet_exp = 3000
        ,energy = 5 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 1000}, #gain{label = coin, val = 3873}, #gain{label = attainment, val = 1020}]
    };
get(10012) ->
    #dungeon_base{
        id = 10012
        ,name = <<"精灵之森(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 10012, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10012]
        ,enter_point = {10012, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 500
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 866}, #gain{label = attainment, val = 51}]
    };
get(10022) ->
    #dungeon_base{
        id = 10022
        ,name = <<"日光小径(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10022, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10022]
        ,enter_point = {10022, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 550
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 1118}, #gain{label = attainment, val = 85}]
    };
get(10032) ->
    #dungeon_base{
        id = 10032
        ,name = <<"日光小径(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 10032, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10032]
        ,enter_point = {10032, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 600
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 1118}, #gain{label = attainment, val = 85}]
    };
get(10042) ->
    #dungeon_base{
        id = 10042
        ,name = <<"月光森林(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10042, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10042]
        ,enter_point = {10042, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 700
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 1225}, #gain{label = attainment, val = 102}]
    };
get(10052) ->
    #dungeon_base{
        id = 10052
        ,name = <<"月光森林(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 10052, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10052]
        ,enter_point = {10052, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 750
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 1225}, #gain{label = attainment, val = 102}]
    };
get(10062) ->
    #dungeon_base{
        id = 10062
        ,name = <<"魅影丛林(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10062, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10062]
        ,enter_point = {10062, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 800
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 1323}, #gain{label = attainment, val = 119}]
    };
get(10072) ->
    #dungeon_base{
        id = 10072
        ,name = <<"魅影丛林(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 10072, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10072]
        ,enter_point = {10072, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 850
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 1323}, #gain{label = attainment, val = 119}]
    };
get(10082) ->
    #dungeon_base{
        id = 10082
        ,name = <<"影月林间(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10082, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10082]
        ,enter_point = {10082, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 950
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 1414}, #gain{label = attainment, val = 136}]
    };
get(10092) ->
    #dungeon_base{
        id = 10092
        ,name = <<"影月林间(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 10092, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10092]
        ,enter_point = {10092, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 950
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 1414}, #gain{label = attainment, val = 136}]
    };
get(10102) ->
    #dungeon_base{
        id = 10102
        ,name = <<"女巫秘林(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 10102, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10102]
        ,enter_point = {10102, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1000
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 1414}, #gain{label = attainment, val = 136}]
    };
get(10112) ->
    #dungeon_base{
        id = 10112
        ,name = <<"女巫秘林(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 10112, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [10112]
        ,enter_point = {10112, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1050
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,2]}}, {3, #gain{label = item, val = [221106,1,2]}}, {5, #gain{label = item, val = [221106,1,2]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = coin, val = 1414}, #gain{label = attainment, val = 136}]
    };
get(11012) ->
    #dungeon_base{
        id = 11012
        ,name = <<"晨曦小径(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 11012, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [11012]
        ,enter_point = {11012, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1100
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 408}, #gain{label = stone, val = 173}]
    };
get(11022) ->
    #dungeon_base{
        id = 11022
        ,name = <<"绿涛旷野(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11022, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [11022]
        ,enter_point = {11022, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1150
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 442}, #gain{label = stone, val = 180}]
    };
get(11032) ->
    #dungeon_base{
        id = 11032
        ,name = <<"绿涛旷野(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 11032, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [11032]
        ,enter_point = {11032, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1200
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 442}, #gain{label = stone, val = 180}]
    };
get(11042) ->
    #dungeon_base{
        id = 11042
        ,name = <<"崇神湿地(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11042, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [11042]
        ,enter_point = {11042, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1250
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 476}, #gain{label = stone, val = 187}]
    };
get(11052) ->
    #dungeon_base{
        id = 11052
        ,name = <<"崇神湿地(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 11052, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [11052]
        ,enter_point = {11052, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1300
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 476}, #gain{label = stone, val = 187}]
    };
get(11062) ->
    #dungeon_base{
        id = 11062
        ,name = <<"贫瘠腹地(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11062, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [11062]
        ,enter_point = {11062, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1350
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 510}, #gain{label = stone, val = 193}]
    };
get(11072) ->
    #dungeon_base{
        id = 11072
        ,name = <<"贫瘠腹地(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 11072, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [11072]
        ,enter_point = {11072, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1400
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 510}, #gain{label = stone, val = 193}]
    };
get(11082) ->
    #dungeon_base{
        id = 11082
        ,name = <<"女神祭台(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11082, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [11082]
        ,enter_point = {11082, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1400
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,3]}}, {3, #gain{label = item, val = [221106,1,3]}}, {5, #gain{label = item, val = [221106,1,3]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 544}, #gain{label = stone, val = 200}]
    };
get(11092) ->
    #dungeon_base{
        id = 11092
        ,name = <<"女神祭台(困难)">>
        ,type = 8
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 11092, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [11092]
        ,enter_point = {11092, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1450
        ,energy = 10 
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 544}, #gain{label = stone, val = 200}]
    };
get(12012) ->
    #dungeon_base{
        id = 12012
        ,name = <<"遗忘之路(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 12012, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12012]
        ,enter_point = {12012, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1450
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 748}, #gain{label = stone, val = 229}]
    };
get(12022) ->
    #dungeon_base{
        id = 12022
        ,name = <<"失落沙丘(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12022, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12022]
        ,enter_point = {12022, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1450
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 782}, #gain{label = stone, val = 234}]
    };
get(12032) ->
    #dungeon_base{
        id = 12032
        ,name = <<"失落沙丘(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 12032, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12032]
        ,enter_point = {12032, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1500
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 782}, #gain{label = stone, val = 234}]
    };
get(12042) ->
    #dungeon_base{
        id = 12042
        ,name = <<"祭祀迷道(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12042, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12042]
        ,enter_point = {12042, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1500
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 816}, #gain{label = stone, val = 239}]
    };
get(12052) ->
    #dungeon_base{
        id = 12052
        ,name = <<"祭祀迷道(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12052, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12052]
        ,enter_point = {12052, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1550
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 816}, #gain{label = stone, val = 239}]
    };
get(12062) ->
    #dungeon_base{
        id = 12062
        ,name = <<"祭祀迷道(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 12062, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12062]
        ,enter_point = {12062, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1550
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 816}, #gain{label = stone, val = 239}]
    };
get(12072) ->
    #dungeon_base{
        id = 12072
        ,name = <<"毒蝎之穴(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12072, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12072]
        ,enter_point = {12072, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1600
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 884}, #gain{label = stone, val = 244}]
    };
get(12082) ->
    #dungeon_base{
        id = 12082
        ,name = <<"毒蝎之穴(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 12082, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12082]
        ,enter_point = {12082, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1600
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 884}, #gain{label = stone, val = 244}]
    };
get(12092) ->
    #dungeon_base{
        id = 12092
        ,name = <<"荒漠废墟(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12092, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12092]
        ,enter_point = {12092, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1650
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 918}, #gain{label = stone, val = 249}]
    };
get(12102) ->
    #dungeon_base{
        id = 12102
        ,name = <<"荒漠废墟(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12102, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12102]
        ,enter_point = {12102, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1650
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 918}, #gain{label = stone, val = 249}]
    };
get(12112) ->
    #dungeon_base{
        id = 12112
        ,name = <<"荒漠废墟(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 12112, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12112]
        ,enter_point = {12112, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1650
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 918}, #gain{label = stone, val = 249}]
    };
get(12122) ->
    #dungeon_base{
        id = 12122
        ,name = <<"迷迹腹地(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12122, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12122]
        ,enter_point = {12122, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1700
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,5]}}, {3, #gain{label = item, val = [221106,1,5]}}, {5, #gain{label = item, val = [221106,1,5]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 952}, #gain{label = stone, val = 254}]
    };
get(12132) ->
    #dungeon_base{
        id = 12132
        ,name = <<"迷迹腹地(困难)">>
        ,type = 8
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 12132, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [12132]
        ,enter_point = {12132, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1700
        ,energy = 10 
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 952}, #gain{label = stone, val = 254}]
    };
get(13012) ->
    #dungeon_base{
        id = 13012
        ,name = <<"树根之路(困难)">>
        ,type = 3
        ,show_type = 1
        ,args = [10,11352,11353]
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 13012, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13012]
        ,enter_point = {13012, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1700
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1054}, #gain{label = stone, val = 278}]
    };
get(13022) ->
    #dungeon_base{
        id = 13022
        ,name = <<"虚渺根林(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13022, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13022]
        ,enter_point = {13022, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1750
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1088}, #gain{label = stone, val = 282}]
    };
get(13032) ->
    #dungeon_base{
        id = 13032
        ,name = <<"虚渺根林(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 13032, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13032]
        ,enter_point = {13032, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1750
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1088}, #gain{label = stone, val = 282}]
    };
get(13042) ->
    #dungeon_base{
        id = 13042
        ,name = <<"萤火之森(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13042, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13042]
        ,enter_point = {13042, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1800
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1122}, #gain{label = stone, val = 287}]
    };
get(13052) ->
    #dungeon_base{
        id = 13052
        ,name = <<"萤火之森(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13052, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13052]
        ,enter_point = {13052, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1800
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1122}, #gain{label = stone, val = 287}]
    };
get(13062) ->
    #dungeon_base{
        id = 13062
        ,name = <<"萤火之森(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 13062, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13062]
        ,enter_point = {13062, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1850
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1122}, #gain{label = stone, val = 287}]
    };
get(13072) ->
    #dungeon_base{
        id = 13072
        ,name = <<"神源之地(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13072, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13072]
        ,enter_point = {13072, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1850
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1156}, #gain{label = stone, val = 291}]
    };
get(13082) ->
    #dungeon_base{
        id = 13082
        ,name = <<"神源之地(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13082, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13082]
        ,enter_point = {13082, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1900
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1156}, #gain{label = stone, val = 291}]
    };
get(13092) ->
    #dungeon_base{
        id = 13092
        ,name = <<"神源之地(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 13092, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13092]
        ,enter_point = {13092, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1900
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1156}, #gain{label = stone, val = 291}]
    };
get(13102) ->
    #dungeon_base{
        id = 13102
        ,name = <<"盘根之谷(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13102, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13102]
        ,enter_point = {13102, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1950
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1190}, #gain{label = stone, val = 295}]
    };
get(13112) ->
    #dungeon_base{
        id = 13112
        ,name = <<"盘根之谷(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 13112, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13112]
        ,enter_point = {13112, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1950
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1190}, #gain{label = stone, val = 295}]
    };
get(13122) ->
    #dungeon_base{
        id = 13122
        ,name = <<"盘根之谷(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 13122, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [13122]
        ,enter_point = {13122, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1950
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1190}, #gain{label = stone, val = 295}]
    };
get(14012) ->
    #dungeon_base{
        id = 14012
        ,name = <<"荧光洞穴(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 14012, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14012]
        ,enter_point = {14012, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 1950
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1224}, #gain{label = stone, val = 300}]
    };
get(14022) ->
    #dungeon_base{
        id = 14022
        ,name = <<"沉寂湖畔(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14022, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14022]
        ,enter_point = {14022, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2000
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1258}, #gain{label = stone, val = 304}]
    };
get(14032) ->
    #dungeon_base{
        id = 14032
        ,name = <<"沉寂湖畔(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 14032, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14032]
        ,enter_point = {14032, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2000
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1258}, #gain{label = stone, val = 304}]
    };
get(14042) ->
    #dungeon_base{
        id = 14042
        ,name = <<"树根囚笼(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14042, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14042]
        ,enter_point = {14042, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2050
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1292}, #gain{label = stone, val = 308}]
    };
get(14052) ->
    #dungeon_base{
        id = 14052
        ,name = <<"树根囚笼(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14052, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14052]
        ,enter_point = {14052, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2050
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1292}, #gain{label = stone, val = 308}]
    };
get(14062) ->
    #dungeon_base{
        id = 14062
        ,name = <<"树根囚笼(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 14062, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14062]
        ,enter_point = {14062, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2100
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1292}, #gain{label = stone, val = 308}]
    };
get(14072) ->
    #dungeon_base{
        id = 14072
        ,name = <<"幽暗地穴(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14072, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14072]
        ,enter_point = {14072, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2100
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1326}, #gain{label = stone, val = 312}]
    };
get(14082) ->
    #dungeon_base{
        id = 14082
        ,name = <<"幽暗地穴(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14082, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14082]
        ,enter_point = {14082, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2100
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1326}, #gain{label = stone, val = 312}]
    };
get(14092) ->
    #dungeon_base{
        id = 14092
        ,name = <<"幽暗地穴(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 14092, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14092]
        ,enter_point = {14092, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2150
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1326}, #gain{label = stone, val = 312}]
    };
get(14102) ->
    #dungeon_base{
        id = 14102
        ,name = <<"迷踪深渊(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14102, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14102]
        ,enter_point = {14102, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2150
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1360}, #gain{label = stone, val = 316}]
    };
get(14112) ->
    #dungeon_base{
        id = 14112
        ,name = <<"迷踪深渊(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14112, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14112]
        ,enter_point = {14112, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2150
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,7]}}, {3, #gain{label = item, val = [221106,1,7]}}, {5, #gain{label = item, val = [221106,1,7]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1360}, #gain{label = stone, val = 316}]
    };
get(14122) ->
    #dungeon_base{
        id = 14122
        ,name = <<"迷踪深渊(困难)">>
        ,type = 8
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 14122, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [14122]
        ,enter_point = {14122, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2200
        ,energy = 10 
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1360}, #gain{label = stone, val = 316}]
    };
get(15012) ->
    #dungeon_base{
        id = 15012
        ,name = <<"凛冽冰谷(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 15012, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15012]
        ,enter_point = {15012, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2200
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1394}, #gain{label = stone, val = 320}]
    };
get(15022) ->
    #dungeon_base{
        id = 15022
        ,name = <<"冰棱之森(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15022, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15022]
        ,enter_point = {15022, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2200
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1428}, #gain{label = stone, val = 324}]
    };
get(15032) ->
    #dungeon_base{
        id = 15032
        ,name = <<"冰棱之森(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15032, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15032]
        ,enter_point = {15032, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2250
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1428}, #gain{label = stone, val = 324}]
    };
get(15042) ->
    #dungeon_base{
        id = 15042
        ,name = <<"冰棱之森(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 15042, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15042]
        ,enter_point = {15042, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2300
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1428}, #gain{label = stone, val = 324}]
    };
get(15052) ->
    #dungeon_base{
        id = 15052
        ,name = <<"风暴要塞(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15052, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15052]
        ,enter_point = {15052, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2300
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1462}, #gain{label = stone, val = 327}]
    };
get(15062) ->
    #dungeon_base{
        id = 15062
        ,name = <<"风暴要塞(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15062, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15062]
        ,enter_point = {15062, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2350
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1462}, #gain{label = stone, val = 327}]
    };
get(15072) ->
    #dungeon_base{
        id = 15072
        ,name = <<"风暴要塞(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 15072, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15072]
        ,enter_point = {15072, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2400
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1462}, #gain{label = stone, val = 327}]
    };
get(15082) ->
    #dungeon_base{
        id = 15082
        ,name = <<"荒芜雪野(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15082, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15082]
        ,enter_point = {15082, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2400
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1496}, #gain{label = stone, val = 331}]
    };
get(15092) ->
    #dungeon_base{
        id = 15092
        ,name = <<"荒芜雪野(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15092, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15092]
        ,enter_point = {15092, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2450
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1496}, #gain{label = stone, val = 331}]
    };
get(15102) ->
    #dungeon_base{
        id = 15102
        ,name = <<"荒芜雪野(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 15102, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15102]
        ,enter_point = {15102, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2450
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1496}, #gain{label = stone, val = 331}]
    };
get(15112) ->
    #dungeon_base{
        id = 15112
        ,name = <<"狼嚎野岭(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15112, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15112]
        ,enter_point = {15112, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2500
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1530}, #gain{label = stone, val = 335}]
    };
get(15122) ->
    #dungeon_base{
        id = 15122
        ,name = <<"狼嚎野岭(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 15122, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15122]
        ,enter_point = {15122, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2500
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1530}, #gain{label = stone, val = 335}]
    };
get(15132) ->
    #dungeon_base{
        id = 15132
        ,name = <<"狼嚎野岭(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 15132, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [15132]
        ,enter_point = {15132, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2500
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1530}, #gain{label = stone, val = 335}]
    };
get(16012) ->
    #dungeon_base{
        id = 16012
        ,name = <<"刀锋高地(困难)">>
        ,type = 3
        ,show_type = 1
        ,args = [8,11397,11398]
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 16012, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16012]
        ,enter_point = {16012, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2500
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1564}, #gain{label = stone, val = 339}]
    };
get(16022) ->
    #dungeon_base{
        id = 16022
        ,name = <<"巨槌峰峦(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16022, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16022]
        ,enter_point = {16022, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2500
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1598}, #gain{label = stone, val = 342}]
    };
get(16032) ->
    #dungeon_base{
        id = 16032
        ,name = <<"巨槌峰峦(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16032, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16032]
        ,enter_point = {16032, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2550
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1598}, #gain{label = stone, val = 342}]
    };
get(16042) ->
    #dungeon_base{
        id = 16042
        ,name = <<"巨槌峰峦(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 16042, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16042]
        ,enter_point = {16042, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2550
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1598}, #gain{label = stone, val = 342}]
    };
get(16052) ->
    #dungeon_base{
        id = 16052
        ,name = <<"暮色雪岭(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16052, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16052]
        ,enter_point = {16052, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2600
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1632}, #gain{label = stone, val = 346}]
    };
get(16062) ->
    #dungeon_base{
        id = 16062
        ,name = <<"暮色雪岭(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16062, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16062]
        ,enter_point = {16062, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2600
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1632}, #gain{label = stone, val = 346}]
    };
get(16072) ->
    #dungeon_base{
        id = 16072
        ,name = <<"暮色雪岭(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 16072, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16072]
        ,enter_point = {16072, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2650
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1632}, #gain{label = stone, val = 346}]
    };
get(16082) ->
    #dungeon_base{
        id = 16082
        ,name = <<"风雪之巅(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16082, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16082]
        ,enter_point = {16082, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2650
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1666}, #gain{label = stone, val = 350}]
    };
get(16092) ->
    #dungeon_base{
        id = 16092
        ,name = <<"风雪之巅(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16092, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16092]
        ,enter_point = {16092, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2650
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1666}, #gain{label = stone, val = 350}]
    };
get(16102) ->
    #dungeon_base{
        id = 16102
        ,name = <<"风雪之巅(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 16102, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16102]
        ,enter_point = {16102, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2700
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1666}, #gain{label = stone, val = 350}]
    };
get(16112) ->
    #dungeon_base{
        id = 16112
        ,name = <<"巨人山城(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16112, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16112]
        ,enter_point = {16112, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2700
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1700}, #gain{label = stone, val = 353}]
    };
get(16122) ->
    #dungeon_base{
        id = 16122
        ,name = <<"巨人山城(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16122, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16122]
        ,enter_point = {16122, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2700
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1700}, #gain{label = stone, val = 353}]
    };
get(16132) ->
    #dungeon_base{
        id = 16132
        ,name = <<"巨人山城(困难)">>
        ,type = 8
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 16132, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [16132]
        ,enter_point = {16132, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2750
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,10]}}, {3, #gain{label = item, val = [221106,1,10]}}, {5, #gain{label = item, val = [221106,1,10]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1700}, #gain{label = stone, val = 353}]
    };
get(17012) ->
    #dungeon_base{
        id = 17012
        ,name = <<"暮光峡湾(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 17012, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17012]
        ,enter_point = {17012, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2750
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1734}, #gain{label = stone, val = 356}]
    };
get(17022) ->
    #dungeon_base{
        id = 17022
        ,name = <<"荒骨走道(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17022, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17022]
        ,enter_point = {17022, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2750
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1768}, #gain{label = stone, val = 358}]
    };
get(17032) ->
    #dungeon_base{
        id = 17032
        ,name = <<"荒骨走道(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17032, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17032]
        ,enter_point = {17032, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2800
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1768}, #gain{label = stone, val = 358}]
    };
get(17042) ->
    #dungeon_base{
        id = 17042
        ,name = <<"荒骨走道(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 17042, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17042]
        ,enter_point = {17042, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2800
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1768}, #gain{label = stone, val = 358}]
    };
get(17052) ->
    #dungeon_base{
        id = 17052
        ,name = <<"荒废之路(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17052, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17052]
        ,enter_point = {17052, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2850
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1802}, #gain{label = stone, val = 360}]
    };
get(17062) ->
    #dungeon_base{
        id = 17062
        ,name = <<"荒废之路(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17062, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17062]
        ,enter_point = {17062, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2850
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1802}, #gain{label = stone, val = 360}]
    };
get(17072) ->
    #dungeon_base{
        id = 17072
        ,name = <<"荒废之路(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 17072, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17072]
        ,enter_point = {17072, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2900
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1802}, #gain{label = stone, val = 360}]
    };
get(17082) ->
    #dungeon_base{
        id = 17082
        ,name = <<"绝望回廊(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17082, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17082]
        ,enter_point = {17082, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2900
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1836}, #gain{label = stone, val = 362}]
    };
get(17092) ->
    #dungeon_base{
        id = 17092
        ,name = <<"绝望回廊(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17092, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17092]
        ,enter_point = {17092, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2900
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1836}, #gain{label = stone, val = 362}]
    };
get(17102) ->
    #dungeon_base{
        id = 17102
        ,name = <<"绝望回廊(困难)">>
        ,type = 3
        ,show_type = 1
        ,args = [20,11655,11656,11657,11658
]
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 17102, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17102]
        ,enter_point = {17102, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2950
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1836}, #gain{label = stone, val = 362}]
    };
get(17112) ->
    #dungeon_base{
        id = 17112
        ,name = <<"地牢入口(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17112, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17112]
        ,enter_point = {17112, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2950
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1870}, #gain{label = stone, val = 364}]
    };
get(17122) ->
    #dungeon_base{
        id = 17122
        ,name = <<"地牢入口(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 17122, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17122]
        ,enter_point = {17122, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 2950
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1870}, #gain{label = stone, val = 364}]
    };
get(17132) ->
    #dungeon_base{
        id = 17132
        ,name = <<"地牢入口(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 17132, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [17132]
        ,enter_point = {17132, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3000
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1870}, #gain{label = stone, val = 364}]
    };
get(18012) ->
    #dungeon_base{
        id = 18012
        ,name = <<"噩梦地牢(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 18012, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18012]
        ,enter_point = {18012, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3000
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1904}, #gain{label = stone, val = 366}]
    };
get(18022) ->
    #dungeon_base{
        id = 18022
        ,name = <<"幽魂牢笼(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18022, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18022]
        ,enter_point = {18022, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3000
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1938}, #gain{label = stone, val = 368}]
    };
get(18032) ->
    #dungeon_base{
        id = 18032
        ,name = <<"幽魂牢笼(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18032, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18032]
        ,enter_point = {18032, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3050
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1938}, #gain{label = stone, val = 368}]
    };
get(18042) ->
    #dungeon_base{
        id = 18042
        ,name = <<"幽魂牢笼(困难)">>
        ,type = 3
        ,show_type = 1
        ,args = [20,11664,11665,11666,11667
]
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 18042, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18042]
        ,enter_point = {18042, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3100
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1938}, #gain{label = stone, val = 368}]
    };
get(18052) ->
    #dungeon_base{
        id = 18052
        ,name = <<"森火之狱(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18052, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18052]
        ,enter_point = {18052, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3150
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1972}, #gain{label = stone, val = 370}]
    };
get(18062) ->
    #dungeon_base{
        id = 18062
        ,name = <<"森火之狱(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18062, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18062]
        ,enter_point = {18062, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3200
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1972}, #gain{label = stone, val = 370}]
    };
get(18072) ->
    #dungeon_base{
        id = 18072
        ,name = <<"森火之狱(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 18072, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18072]
        ,enter_point = {18072, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3250
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 1972}, #gain{label = stone, val = 370}]
    };
get(18082) ->
    #dungeon_base{
        id = 18082
        ,name = <<"厄运牢房(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18082, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18082]
        ,enter_point = {18082, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3300
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 2006}, #gain{label = stone, val = 372}]
    };
get(18092) ->
    #dungeon_base{
        id = 18092
        ,name = <<"厄运牢房(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18092, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18092]
        ,enter_point = {18092, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3350
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 2006}, #gain{label = stone, val = 372}]
    };
get(18102) ->
    #dungeon_base{
        id = 18102
        ,name = <<"厄运牢房(困难)">>
        ,type = 0
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 3, target = 18102, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18102]
        ,enter_point = {18102, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3400
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 2006}, #gain{label = stone, val = 372}]
    };
get(18112) ->
    #dungeon_base{
        id = 18112
        ,name = <<"沉息之地(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18112, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18112]
        ,enter_point = {18112, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3450
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 2040}, #gain{label = stone, val = 374}]
    };
get(18122) ->
    #dungeon_base{
        id = 18122
        ,name = <<"沉息之地(困难)">>
        ,type = 0
        ,show_type = 0
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18122, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18122]
        ,enter_point = {18122, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3500
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 2040}, #gain{label = stone, val = 374}]
    };
get(18132) ->
    #dungeon_base{
        id = 18132
        ,name = <<"沉息之地(困难)">>
        ,type = 8
        ,show_type = 1
        ,args = []
        ,cond_enter = [#condition{label = dun_count, target_value = 1, target = 18132, msg = <<"次数不足">>}, #condition{label = energy, target_value = 10, msg = <<"体力不足">>}, #loss{label = energy, val = 10}]
        ,maps = [18132]
        ,enter_point = {18132, 420, 433}
        ,pay_limit = 1
        ,pet_exp = 3550
        ,energy = 10 
        ,first_rewards = [{2, #gain{label = item, val = [221106,1,15]}}, {3, #gain{label = item, val = [221106,1,15]}}, {5, #gain{label = item, val = [221106,1,15]}}]
        ,clear_rewards = [#gain{label = exp, val = 2000}, #gain{label = attainment, val = 2040}, #gain{label = stone, val = 374}]
    };

get(20) ->
    #dungeon_base{
        id = 20
        ,name = <<"20级多人副本">>
        ,type = 1
        ,maps = [130]
        ,enter_point = {130, 420, 433}
        ,pet_exp = 1500
        ,clear_rewards = [#gain{label = exp, val = 2560}, #gain{label = coin, val = 1118}, #gain{label = attainment, val = 340}]
    };
get(30) ->
    #dungeon_base{
        id = 30
        ,name = <<"30级多人副本">>
        ,type = 1
        ,maps = [132]
        ,enter_point = {132, 420, 433}
        ,pet_exp = 1500
        ,clear_rewards = [#gain{label = exp, val = 2560}, #gain{label = coin, val = 1479}, #gain{label = attainment, val = 595}]
    };
get(40) ->
    #dungeon_base{
        id = 40
        ,name = <<"40级多人副本">>
        ,type = 1
        ,maps = [134]
        ,enter_point = {134, 420, 433}
        ,pet_exp = 1500
        ,clear_rewards = [#gain{label = exp, val = 2560}, #gain{label = coin, val = 1581}, #gain{label = attainment, val = 680}]
    };
get(50) ->
    #dungeon_base{
        id = 50
        ,name = <<"50级多人副本">>
        ,type = 1
        ,maps = [136]
        ,enter_point = {136, 420, 433}
        ,pet_exp = 1500
        ,clear_rewards = [#gain{label = exp, val = 2560}, #gain{label = coin, val = 1677}, #gain{label = attainment, val = 765}]
    };

get(_) ->
    {false, <<"不存在此副本的配置">>}.

map(10) ->
    #dungeon_map_base{
        id = 10
        ,total_blue = 18
        ,total_purple = 18
        ,blue_rewards = [#gain{label = gold, val = 10}, #gain{label = coin, val = 10000}, #gain{label = stone, val = 1000}, #gain{label = item, val = [131001,1,5]}]
        ,purple_rewards = [#gain{label = gold, val = 20}, #gain{label = coin, val = 20000}, #gain{label = stone, val = 2000}, #gain{label = item, val = [111001,1,10]}]
        ,last_normal_id = 10111
        ,first_hard_id = 10012
    };
map(11) ->
    #dungeon_map_base{
        id = 11
        ,total_blue = 15
        ,total_purple = 15
        ,blue_rewards = [#gain{label = gold, val = 20}, #gain{label = coin, val = 30000}, #gain{label = stone, val = 2000}, #gain{label = item, val = [111001,1,10]}]
        ,purple_rewards = [#gain{label = gold, val = 30}, #gain{label = coin, val = 40000}, #gain{label = stone, val = 4000}, #gain{label = item, val = [111203,1,2]}]
        ,last_normal_id = 11091
        ,first_hard_id = 11012
    };
map(12) ->
    #dungeon_map_base{
        id = 12
        ,total_blue = 18
        ,total_purple = 18
        ,blue_rewards = [#gain{label = gold, val = 30}, #gain{label = coin, val = 60000}, #gain{label = stone, val = 3000}, #gain{label = item, val = [111101,1,5]}]
        ,purple_rewards = [#gain{label = gold, val = 40}, #gain{label = coin, val = 80000}, #gain{label = stone, val = 6000}, #gain{label = item, val = [531002,1,1]}]
        ,last_normal_id = 12131
        ,first_hard_id = 12012
    };
map(13) ->
    #dungeon_map_base{
        id = 13
        ,total_blue = 15
        ,total_purple = 15
        ,blue_rewards = [#gain{label = gold, val = 35}, #gain{label = coin, val = 90000}, #gain{label = stone, val = 4000}, #gain{label = item, val = [621501,1,5]}]
        ,purple_rewards = [#gain{label = gold, val = 45}, #gain{label = coin, val = 120000}, #gain{label = stone, val = 8000}, #gain{label = item, val = [535655,1,10]}]
        ,last_normal_id = 13121
        ,first_hard_id = 13012
    };
map(14) ->
    #dungeon_map_base{
        id = 14
        ,total_blue = 15
        ,total_purple = 15
        ,blue_rewards = [#gain{label = gold, val = 40}, #gain{label = coin, val = 120000}, #gain{label = stone, val = 5000}, #gain{label = item, val = [111301,1,20]}]
        ,purple_rewards = [#gain{label = gold, val = 50}, #gain{label = coin, val = 160000}, #gain{label = stone, val = 10000}, #gain{label = item, val = [535655,1,10]}]
        ,last_normal_id = 14121
        ,first_hard_id = 14012
    };
map(15) ->
    #dungeon_map_base{
        id = 15
        ,total_blue = 15
        ,total_purple = 15
        ,blue_rewards = [#gain{label = gold, val = 45}, #gain{label = coin, val = 150000}, #gain{label = stone, val = 6000}, #gain{label = item, val = [231001,1,20]}]
        ,purple_rewards = [#gain{label = gold, val = 55}, #gain{label = coin, val = 200000}, #gain{label = stone, val = 12000}, #gain{label = item, val = [611101,1,3]}]
        ,last_normal_id = 15131
        ,first_hard_id = 15012
    };
map(16) ->
    #dungeon_map_base{
        id = 16
        ,total_blue = 15
        ,total_purple = 15
        ,blue_rewards = [#gain{label = gold, val = 50}, #gain{label = coin, val = 180000}, #gain{label = stone, val = 7000}, #gain{label = item, val = [231001,1,40]}]
        ,purple_rewards = [#gain{label = gold, val = 60}, #gain{label = coin, val = 240000}, #gain{label = stone, val = 14000}, #gain{label = item, val = [531003,1,2]}]
        ,last_normal_id = 16131
        ,first_hard_id = 16012
    };
map(17) ->
    #dungeon_map_base{
        id = 17
        ,total_blue = 15
        ,total_purple = 15
        ,blue_rewards = [#gain{label = gold, val = 55}, #gain{label = coin, val = 210000}, #gain{label = stone, val = 8000}, #gain{label = item, val = [111001,1,30]}]
        ,purple_rewards = [#gain{label = gold, val = 65}, #gain{label = coin, val = 280000}, #gain{label = stone, val = 16000}, #gain{label = item, val = [111301,1,30]}]
        ,last_normal_id = 17131
        ,first_hard_id = 17012
    };
map(18) ->
    #dungeon_map_base{
        id = 18
        ,total_blue = 15
        ,total_purple = 15
        ,blue_rewards = [#gain{label = gold, val = 60}, #gain{label = coin, val = 240000}, #gain{label = stone, val = 9000}, #gain{label = item, val = [111703,1,3]}]
        ,purple_rewards = [#gain{label = gold, val = 70}, #gain{label = coin, val = 320000}, #gain{label = stone, val = 18000}, #gain{label = item, val = [531004,1,2]}]
        ,last_normal_id = 18131
        ,first_hard_id = 18012
    };
map(_) ->
    undefined.

all_map() ->
    [
10, 11, 12, 13, 14, 15, 16, 17, 18
    ].

