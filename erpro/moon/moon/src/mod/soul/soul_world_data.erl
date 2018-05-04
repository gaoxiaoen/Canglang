%%----------------------------------------------------
%% @doc 灵戒洞天配置数据
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(soul_world_data).
-include("soul_world.hrl").
-include("gain.hrl").
-export([get/1, get_all_ids/0, get_quality_ids/1, get_upgrade/2, get_array_by_lev/1, get_spirit_factor/1, get_magic_by_lev/1, get_pet_array/1, get_workshop/1, get_workshop_ids/0]).
%% 根据id获取妖灵配置
get(1) ->
    #soul_world_spirit{
        id = 1
        ,name =  <<"玄冰妖之灵">>
        ,quality = 1
        ,max_exp = 5
        ,fc = 75
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(2) ->
    #soul_world_spirit{
        id = 2
        ,name =  <<"赤炎羽之灵">>
        ,quality = 1
        ,max_exp = 5
        ,fc = 77
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(3) ->
    #soul_world_spirit{
        id = 3
        ,name =  <<"流萤雪之灵">>
        ,quality = 1
        ,max_exp = 5
        ,fc = 79
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(4) ->
    #soul_world_spirit{
        id = 4
        ,name =  <<"万森罗之灵">>
        ,quality = 2
        ,max_exp = 6
        ,fc = 85
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(5) ->
    #soul_world_spirit{
        id = 5
        ,name =  <<"罡少白之灵">>
        ,quality = 2
        ,max_exp = 6
        ,fc = 88
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(6) ->
    #soul_world_spirit{
        id = 6
        ,name =  <<"花千骨之灵">>
        ,quality = 2
        ,max_exp = 6
        ,fc = 90
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(7) ->
    #soul_world_spirit{
        id = 7
        ,name =  <<"小刑天之灵">>
        ,quality = 3
        ,max_exp = 9
        ,fc = 102
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(8) ->
    #soul_world_spirit{
        id = 8
        ,name =  <<"雷音铃之灵">>
        ,quality = 3
        ,max_exp = 9
        ,fc = 106
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(9) ->
    #soul_world_spirit{
        id = 9
        ,name =  <<"巨灵天之灵">>
        ,quality = 3
        ,max_exp = 9
        ,fc = 110
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(10) ->
    #soul_world_spirit{
        id = 10
        ,name =  <<"绝地王之灵">>
        ,quality = 4
        ,max_exp = 12
        ,fc = 213
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(11) ->
    #soul_world_spirit{
        id = 11
        ,name =  <<"破天王之灵">>
        ,quality = 4
        ,max_exp = 12
        ,fc = 223
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(12) ->
    #soul_world_spirit{
        id = 12
        ,name =  <<"镇妖塔之灵">>
        ,quality = 4
        ,max_exp = 12
        ,fc = 233
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(13) ->
    #soul_world_spirit{
        id = 13
        ,name =  <<"重明鸟之灵">>
        ,quality = 1
        ,max_exp = 5
        ,fc = 77
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(14) ->
    #soul_world_spirit{
        id = 14
        ,name =  <<"地狱战神之灵">>
        ,quality = 1
        ,max_exp = 5
        ,fc = 79
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(15) ->
    #soul_world_spirit{
        id = 15
        ,name =  <<"毕方之灵">>
        ,quality = 1
        ,max_exp = 5
        ,fc = 81
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(16) ->
    #soul_world_spirit{
        id = 16
        ,name =  <<"开明兽之灵">>
        ,quality = 2
        ,max_exp = 6
        ,fc = 88
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(17) ->
    #soul_world_spirit{
        id = 17
        ,name =  <<"后土之灵">>
        ,quality = 2
        ,max_exp = 6
        ,fc = 90
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(18) ->
    #soul_world_spirit{
        id = 18
        ,name =  <<"离朱之灵">>
        ,quality = 2
        ,max_exp = 6
        ,fc = 93
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(19) ->
    #soul_world_spirit{
        id = 19
        ,name =  <<"墨云裂齿龙之灵">>
        ,quality = 3
        ,max_exp = 9
        ,fc = 106
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(20) ->
    #soul_world_spirit{
        id = 20
        ,name =  <<"地狱魔将之灵">>
        ,quality = 3
        ,max_exp = 9
        ,fc = 110
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(21) ->
    #soul_world_spirit{
        id = 21
        ,name =  <<"青猿妖圣之灵">>
        ,quality = 3
        ,max_exp = 9
        ,fc = 113
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(22) ->
    #soul_world_spirit{
        id = 22
        ,name =  <<"裂齿狂龙之灵">>
        ,quality = 4
        ,max_exp = 12
        ,fc = 223
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(23) ->
    #soul_world_spirit{
        id = 23
        ,name =  <<"双子大王之灵">>
        ,quality = 4
        ,max_exp = 12
        ,fc = 233
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(24) ->
    #soul_world_spirit{
        id = 24
        ,name =  <<"烈焰战魂之灵">>
        ,quality = 4
        ,max_exp = 12
        ,fc = 244
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(25) ->
    #soul_world_spirit{
        id = 25
        ,name =  <<"青龙之灵">>
        ,quality = 4
        ,max_exp = 12
        ,fc = 254
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(26) ->
    #soul_world_spirit{
        id = 26
        ,name =  <<"白虎之灵">>
        ,quality = 4
        ,max_exp = 12
        ,fc = 254
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(27) ->
    #soul_world_spirit{
        id = 27
        ,name =  <<"朱雀之灵">>
        ,quality = 4
        ,max_exp = 12
        ,fc = 254
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(28) ->
    #soul_world_spirit{
        id = 28
        ,name =  <<"玄武之灵">>
        ,quality = 4
        ,max_exp = 12
        ,fc = 254
        ,magics = [
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]
    };
get(_Else) -> null.

%% 获取妖灵的属性系数
get_spirit_factor(Id) when is_integer(Id) andalso Id > 0 ->
   Data = {0.85, 0.9, 0.95, 0.85, 0.9, 0.95, 0.85, 0.9, 0.95, 0.85, 0.9, 0.95, 0.9, 0.95, 1, 0.9, 0.95, 1, 0.9, 0.95, 1, 0.9, 0.95, 1, 1.05, 1.05, 1.05, 1.05},
   case erlang:tuple_size(Data) >= Id of
       true -> erlang:element(Id, Data);
       _ -> 1
   end;
get_spirit_factor(_Id) -> 1.

%% 获取妖灵升级效果
%% get_upgrade(Lev, Quality) -> {MaxExp, Fc}
get_upgrade(1, 1) ->
    {5, 40};
get_upgrade(2, 1) ->
    {25, 60};
get_upgrade(3, 1) ->
    {105, 80};
get_upgrade(4, 1) ->
    {255, 110};
get_upgrade(5, 1) ->
    {465, 140};
get_upgrade(6, 1) ->
    {710, 175};
get_upgrade(7, 1) ->
    {990, 214};
get_upgrade(8, 1) ->
    {1305, 257};
get_upgrade(9, 1) ->
    {1655, 304};
get_upgrade(10, 1) ->
    {2040, 355};
get_upgrade(11, 1) ->
    {2460, 410};
get_upgrade(12, 1) ->
    {2916, 469};
get_upgrade(13, 1) ->
    {3407, 532};
get_upgrade(14, 1) ->
    {3933, 599};
get_upgrade(15, 1) ->
    {4494, 670};
get_upgrade(16, 1) ->
    {5090, 745};
get_upgrade(17, 1) ->
    {5721, 824};
get_upgrade(18, 1) ->
    {6387, 907};
get_upgrade(19, 1) ->
    {7088, 994};
get_upgrade(20, 1) ->
    {99999, 1085};
get_upgrade(1, 2) ->
    {6, 52};
get_upgrade(2, 2) ->
    {32, 78};
get_upgrade(3, 2) ->
    {136, 104};
get_upgrade(4, 2) ->
    {331, 143};
get_upgrade(5, 2) ->
    {604, 182};
get_upgrade(6, 2) ->
    {922, 228};
get_upgrade(7, 2) ->
    {1286, 278};
get_upgrade(8, 2) ->
    {1695, 334};
get_upgrade(9, 2) ->
    {2150, 395};
get_upgrade(10, 2) ->
    {2650, 462};
get_upgrade(11, 2) ->
    {3196, 533};
get_upgrade(12, 2) ->
    {3788, 610};
get_upgrade(13, 2) ->
    {4426, 692};
get_upgrade(14, 2) ->
    {5109, 779};
get_upgrade(15, 2) ->
    {5838, 871};
get_upgrade(16, 2) ->
    {6612, 969};
get_upgrade(17, 2) ->
    {7432, 1071};
get_upgrade(18, 2) ->
    {8297, 1179};
get_upgrade(19, 2) ->
    {9208, 1292};
get_upgrade(20, 2) ->
    {99999, 1411};
get_upgrade(1, 3) ->
    {9, 72};
get_upgrade(2, 3) ->
    {45, 108};
get_upgrade(3, 3) ->
    {189, 144};
get_upgrade(4, 3) ->
    {459, 198};
get_upgrade(5, 3) ->
    {837, 252};
get_upgrade(6, 3) ->
    {1278, 315};
get_upgrade(7, 3) ->
    {1782, 385};
get_upgrade(8, 3) ->
    {2349, 463};
get_upgrade(9, 3) ->
    {2979, 547};
get_upgrade(10, 3) ->
    {3672, 639};
get_upgrade(11, 3) ->
    {4428, 738};
get_upgrade(12, 3) ->
    {5248, 844};
get_upgrade(13, 3) ->
    {6131, 958};
get_upgrade(14, 3) ->
    {7077, 1078};
get_upgrade(15, 3) ->
    {8086, 1206};
get_upgrade(16, 3) ->
    {9158, 1341};
get_upgrade(17, 3) ->
    {10293, 1483};
get_upgrade(18, 3) ->
    {11491, 1633};
get_upgrade(19, 3) ->
    {12752, 1789};
get_upgrade(20, 3) ->
    {99999, 1953};
get_upgrade(1, 4) ->
    {12, 200};
get_upgrade(2, 4) ->
    {62, 240};
get_upgrade(3, 4) ->
    {262, 280};
get_upgrade(4, 4) ->
    {637, 320};
get_upgrade(5, 4) ->
    {1162, 360};
get_upgrade(6, 4) ->
    {1774, 438};
get_upgrade(7, 4) ->
    {2474, 535};
get_upgrade(8, 4) ->
    {3261, 643};
get_upgrade(9, 4) ->
    {4136, 760};
get_upgrade(10, 4) ->
    {5098, 888};
get_upgrade(11, 4) ->
    {6148, 1025};
get_upgrade(12, 4) ->
    {7288, 1173};
get_upgrade(13, 4) ->
    {8515, 1330};
get_upgrade(14, 4) ->
    {9830, 1498};
get_upgrade(15, 4) ->
    {11232, 1675};
get_upgrade(16, 4) ->
    {12722, 1863};
get_upgrade(17, 4) ->
    {14299, 2060};
get_upgrade(18, 4) ->
    {15964, 2268};
get_upgrade(19, 4) ->
    {17716, 2485};
get_upgrade(20, 4) ->
    {99999, 2713};
get_upgrade(_Lev, _Quality) -> {0, 0}.

%% 获取所有妖灵id
get_all_ids() -> [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28].
get_quality_ids(1) -> [1,2,3,13,14,15];
get_quality_ids(2) -> [4,5,6,16,17,18];
get_quality_ids(3) -> [7,8,9,19,20,21];
get_quality_ids(4) -> [10,11,12,22,23,24,25,26,27,28];
get_quality_ids(_Q) -> [].

%% 神魔阵各等级数据
%% get_array_by_lev(Lev) -> {Addtion, UpgradeTime, Cost}
%% Addtion = integer() 加成系数（千分率）
%% UpgradeTime = integer() 升级所需时间（秒）
%% Cost = [#loss{}..]升级花费
get_array_by_lev(1) ->
    {5, 1, [#loss{label = coin_all, val = 50000}]};
get_array_by_lev(2) ->
    {10, 1, [#loss{label = coin_all, val = 52500}]};
get_array_by_lev(3) ->
    {15, 1, [#loss{label = coin_all, val = 60000}]};
get_array_by_lev(4) ->
    {20, 1, [#loss{label = coin_all, val = 65000}]};
get_array_by_lev(5) ->
    {25, 1, [#loss{label = coin_all, val = 70000}]};
get_array_by_lev(6) ->
    {30, 600, [#loss{label = coin_all, val = 75000}]};
get_array_by_lev(7) ->
    {35, 1800, [#loss{label = coin_all, val = 80000}]};
get_array_by_lev(8) ->
    {40, 2700, [#loss{label = coin_all, val = 85000}]};
get_array_by_lev(9) ->
    {45, 3000, [#loss{label = coin_all, val = 90000}]};
get_array_by_lev(10) ->
    {50, 3300, [#loss{label = coin_all, val = 95000}]};
get_array_by_lev(11) ->
    {55, 3900, [#loss{label = coin_all, val = 100000}]};
get_array_by_lev(12) ->
    {60, 4500, [#loss{label = coin_all, val = 105000}]};
get_array_by_lev(13) ->
    {65, 5100, [#loss{label = coin_all, val = 110000}]};
get_array_by_lev(14) ->
    {70, 5700, [#loss{label = coin_all, val = 115000}]};
get_array_by_lev(15) ->
    {75, 6300, [#loss{label = coin_all, val = 120000}]};
get_array_by_lev(16) ->
    {80, 6900, [#loss{label = coin_all, val = 125000}]};
get_array_by_lev(17) ->
    {85, 7500, [#loss{label = coin_all, val = 130000}]};
get_array_by_lev(18) ->
    {90, 8100, [#loss{label = coin_all, val = 135000}]};
get_array_by_lev(19) ->
    {95, 8700, [#loss{label = coin_all, val = 140000}]};
get_array_by_lev(20) ->
    {100, 9600, [#loss{label = coin_all, val = 145000}]};
get_array_by_lev(21) ->
    {110, 10500, [#loss{label = coin_all, val = 50000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(22) ->
    {120, 11400, [#loss{label = coin_all, val = 55000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(23) ->
    {130, 12300, [#loss{label = coin_all, val = 60000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(24) ->
    {140, 13200, [#loss{label = coin_all, val = 65000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(25) ->
    {150, 14100, [#loss{label = coin_all, val = 70000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(26) ->
    {160, 15000, [#loss{label = coin_all, val = 75000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(27) ->
    {170, 15900, [#loss{label = coin_all, val = 80000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(28) ->
    {180, 16800, [#loss{label = coin_all, val = 85000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(29) ->
    {190, 18000, [#loss{label = coin_all, val = 90000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(30) ->
    {200, 19200, [#loss{label = coin_all, val = 95000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(31) ->
    {210, 20400, [#loss{label = coin_all, val = 100000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(32) ->
    {220, 21600, [#loss{label = coin_all, val = 105000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(33) ->
    {230, 22800, [#loss{label = coin_all, val = 110000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(34) ->
    {240, 24000, [#loss{label = coin_all, val = 115000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(35) ->
    {250, 25200, [#loss{label = coin_all, val = 120000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(36) ->
    {260, 26400, [#loss{label = coin_all, val = 125000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(37) ->
    {270, 27600, [#loss{label = coin_all, val = 130000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(38) ->
    {280, 29100, [#loss{label = coin_all, val = 135000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(39) ->
    {290, 30600, [#loss{label = coin_all, val = 140000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(40) ->
    {300, 32100, [#loss{label = coin_all, val = 145000}, #loss{label = item, val = [33149, 1, 1]}]};
get_array_by_lev(41) ->
    {315, 33600, [#loss{label = coin_all, val = 50000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(42) ->
    {330, 35100, [#loss{label = coin_all, val = 55000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(43) ->
    {345, 36600, [#loss{label = coin_all, val = 60000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(44) ->
    {360, 38100, [#loss{label = coin_all, val = 65000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(45) ->
    {375, 39600, [#loss{label = coin_all, val = 70000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(46) ->
    {390, 41100, [#loss{label = coin_all, val = 75000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(47) ->
    {405, 42900, [#loss{label = coin_all, val = 80000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(48) ->
    {420, 44700, [#loss{label = coin_all, val = 85000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(49) ->
    {435, 46500, [#loss{label = coin_all, val = 90000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(50) ->
    {450, 48300, [#loss{label = coin_all, val = 95000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(51) ->
    {465, 50100, [#loss{label = coin_all, val = 100000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(52) ->
    {480, 51900, [#loss{label = coin_all, val = 105000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(53) ->
    {495, 53700, [#loss{label = coin_all, val = 110000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(54) ->
    {510, 55500, [#loss{label = coin_all, val = 115000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(55) ->
    {525, 57300, [#loss{label = coin_all, val = 120000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(56) ->
    {540, 59400, [#loss{label = coin_all, val = 125000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(57) ->
    {555, 61500, [#loss{label = coin_all, val = 130000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(58) ->
    {570, 63600, [#loss{label = coin_all, val = 135000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(59) ->
    {585, 65700, [#loss{label = coin_all, val = 140000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(60) ->
    {600, 67800, [#loss{label = coin_all, val = 145000}, #loss{label = item, val = [33149, 1, 2]}]};
get_array_by_lev(61) ->
    {620, 69900, [#loss{label = coin_all, val = 50000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(62) ->
    {640, 72000, [#loss{label = coin_all, val = 55000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(63) ->
    {660, 74100, [#loss{label = coin_all, val = 60000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(64) ->
    {680, 76200, [#loss{label = coin_all, val = 65000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(65) ->
    {700, 78600, [#loss{label = coin_all, val = 70000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(66) ->
    {720, 81000, [#loss{label = coin_all, val = 75000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(67) ->
    {740, 83400, [#loss{label = coin_all, val = 80000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(68) ->
    {760, 85800, [#loss{label = coin_all, val = 85000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(69) ->
    {780, 88200, [#loss{label = coin_all, val = 90000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(70) ->
    {800, 90600, [#loss{label = coin_all, val = 95000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(71) ->
    {820, 93000, [#loss{label = coin_all, val = 100000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(72) ->
    {840, 95400, [#loss{label = coin_all, val = 105000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(73) ->
    {860, 97800, [#loss{label = coin_all, val = 110000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(74) ->
    {880, 100500, [#loss{label = coin_all, val = 115000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(75) ->
    {900, 103200, [#loss{label = coin_all, val = 120000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(76) ->
    {920, 105900, [#loss{label = coin_all, val = 125000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(77) ->
    {940, 108600, [#loss{label = coin_all, val = 130000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(78) ->
    {960, 111300, [#loss{label = coin_all, val = 135000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(79) ->
    {980, 114000, [#loss{label = coin_all, val = 140000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(80) ->
    {1000, 116700, [#loss{label = coin_all, val = 145000}, #loss{label = item, val = [33149, 1, 3]}]};
get_array_by_lev(_Lev) -> over.

%% 根据等级获取妖灵法宝数据
%% get_magic_by_lev(Lev) -> {Fc, Addtion, MaxLuck, LuckPer, Ratio}
%% Lev = 等级
%% Fc = 法宝1增加的战力
%% Addtion = 法宝2给战力的加成(千分率)
%% MaxLuck = 幸运上限
%% LuckPer = 开始成功幸运
%% Ratio = 成功几率(百分率)
get_magic_by_lev(1) ->
    {40, 18, 15, 12, 50};
get_magic_by_lev(2) ->
    {70, 30, 25, 20, 33};
get_magic_by_lev(3) ->
    {100, 45, 35, 26, 25};
get_magic_by_lev(4) ->
    {130, 59, 45, 32, 20};
get_magic_by_lev(5) ->
    {160, 74, 50, 38, 17};
get_magic_by_lev(6) ->
    {190, 88, 60, 44, 14};
get_magic_by_lev(7) ->
    {220, 104, 70, 50, 13};
get_magic_by_lev(8) ->
    {257, 123, 80, 58, 11};
get_magic_by_lev(9) ->
    {304, 146, 90, 64, 10};
get_magic_by_lev(10) ->
    {355, 170, 100, 70, 9};
get_magic_by_lev(11) ->
    {410, 197, 105, 76, 8};
get_magic_by_lev(12) ->
    {469, 225, 115, 82, 8};
get_magic_by_lev(13) ->
    {532, 255, 125, 90, 7};
get_magic_by_lev(14) ->
    {599, 288, 135, 96, 7};
get_magic_by_lev(15) ->
    {670, 322, 145, 102, 6};
get_magic_by_lev(16) ->
    {745, 358, 150, 108, 6};
get_magic_by_lev(17) ->
    {824, 396, 160, 114, 6};
get_magic_by_lev(18) ->
    {907, 435, 170, 120, 5};
get_magic_by_lev(19) ->
    {994, 477, 180, 128, 5};
get_magic_by_lev(20) ->
    {1085, 521, 999, 800, 5};
get_magic_by_lev(_Lev) -> over.

%% 根据等级获取宠物阵数据
%% get_pet_array(Lev) -> Data | over
%% Data = {气血, 法伤, 金抗, 木抗, 水抗, 火抗, 土抗, 升级时间(sec), 升级金币}
get_pet_array(1) ->
    {20000, 25, 35, 35, 35, 35, 35, 0, 10000};
get_pet_array(2) ->
    {20350, 50, 70, 70, 70, 70, 70, 0, 13000};
get_pet_array(3) ->
    {20700, 75, 105, 105, 105, 105, 105, 0, 16000};
get_pet_array(4) ->
    {21050, 100, 140, 140, 140, 140, 140, 0, 19000};
get_pet_array(5) ->
    {21400, 125, 175, 175, 175, 175, 175, 0, 22000};
get_pet_array(6) ->
    {21750, 150, 210, 210, 210, 210, 210, 0, 25000};
get_pet_array(7) ->
    {22100, 175, 245, 245, 245, 245, 245, 0, 28000};
get_pet_array(8) ->
    {22450, 200, 280, 280, 280, 280, 280, 0, 31000};
get_pet_array(9) ->
    {22800, 225, 315, 315, 315, 315, 315, 0, 34000};
get_pet_array(10) ->
    {23150, 250, 350, 350, 350, 350, 350, 0, 37000};
get_pet_array(11) ->
    {23500, 275, 385, 385, 385, 385, 385, 0, 40000};
get_pet_array(12) ->
    {23850, 300, 420, 420, 420, 420, 420, 0, 43000};
get_pet_array(13) ->
    {24200, 325, 455, 455, 455, 455, 455, 0, 46000};
get_pet_array(14) ->
    {24550, 350, 490, 490, 490, 490, 490, 0, 49000};
get_pet_array(15) ->
    {24900, 375, 525, 525, 525, 525, 525, 0, 52000};
get_pet_array(16) ->
    {25250, 400, 560, 560, 560, 560, 560, 0, 55000};
get_pet_array(17) ->
    {25600, 425, 595, 595, 595, 595, 595, 0, 58000};
get_pet_array(18) ->
    {25950, 450, 630, 630, 630, 630, 630, 0, 61000};
get_pet_array(19) ->
    {26300, 475, 665, 665, 665, 665, 665, 0, 64000};
get_pet_array(20) ->
    {26650, 500, 700, 700, 700, 700, 700, 600, 67000};
get_pet_array(21) ->
    {27000, 525, 735, 735, 735, 735, 735, 1200, 73000};
get_pet_array(22) ->
    {27350, 550, 770, 770, 770, 770, 770, 1800, 79000};
get_pet_array(23) ->
    {27700, 575, 805, 805, 805, 805, 805, 2400, 85000};
get_pet_array(24) ->
    {28050, 600, 840, 840, 840, 840, 840, 3000, 91000};
get_pet_array(25) ->
    {28400, 625, 875, 875, 875, 875, 875, 3600, 97000};
get_pet_array(26) ->
    {28750, 650, 910, 910, 910, 910, 910, 4200, 103000};
get_pet_array(27) ->
    {29100, 675, 945, 945, 945, 945, 945, 4800, 109000};
get_pet_array(28) ->
    {29450, 700, 980, 980, 980, 980, 980, 5400, 115000};
get_pet_array(29) ->
    {29800, 725, 1015, 1015, 1015, 1015, 1015, 6000, 121000};
get_pet_array(30) ->
    {30150, 750, 1050, 1050, 1050, 1050, 1050, 6600, 127000};
get_pet_array(31) ->
    {30500, 775, 1085, 1085, 1085, 1085, 1085, 7200, 133000};
get_pet_array(32) ->
    {30850, 800, 1120, 1120, 1120, 1120, 1120, 7800, 139000};
get_pet_array(33) ->
    {31200, 825, 1155, 1155, 1155, 1155, 1155, 8400, 145000};
get_pet_array(34) ->
    {31550, 850, 1190, 1190, 1190, 1190, 1190, 9000, 151000};
get_pet_array(35) ->
    {31900, 875, 1225, 1225, 1225, 1225, 1225, 9600, 157000};
get_pet_array(36) ->
    {32250, 900, 1260, 1260, 1260, 1260, 1260, 10200, 163000};
get_pet_array(37) ->
    {32600, 925, 1295, 1295, 1295, 1295, 1295, 10800, 169000};
get_pet_array(38) ->
    {32950, 950, 1330, 1330, 1330, 1330, 1330, 11400, 175000};
get_pet_array(39) ->
    {33300, 975, 1365, 1365, 1365, 1365, 1365, 12000, 181000};
get_pet_array(40) ->
    {33650, 1000, 1400, 1400, 1400, 1400, 1400, 12600, 187000};
get_pet_array(41) ->
    {34000, 1025, 1435, 1435, 1435, 1435, 1435, 13200, 196000};
get_pet_array(42) ->
    {34350, 1050, 1470, 1470, 1470, 1470, 1470, 13800, 205000};
get_pet_array(43) ->
    {34700, 1075, 1505, 1505, 1505, 1505, 1505, 14400, 214000};
get_pet_array(44) ->
    {35050, 1100, 1540, 1540, 1540, 1540, 1540, 15000, 223000};
get_pet_array(45) ->
    {35400, 1125, 1575, 1575, 1575, 1575, 1575, 15600, 232000};
get_pet_array(46) ->
    {35750, 1150, 1610, 1610, 1610, 1610, 1610, 16200, 241000};
get_pet_array(47) ->
    {36100, 1175, 1645, 1645, 1645, 1645, 1645, 16800, 250000};
get_pet_array(48) ->
    {36450, 1200, 1680, 1680, 1680, 1680, 1680, 17400, 259000};
get_pet_array(49) ->
    {36800, 1225, 1715, 1715, 1715, 1715, 1715, 18000, 268000};
get_pet_array(50) ->
    {37150, 1250, 1750, 1750, 1750, 1750, 1750, 18600, 277000};
get_pet_array(51) ->
    {37500, 1275, 1785, 1785, 1785, 1785, 1785, 19200, 286000};
get_pet_array(52) ->
    {37850, 1300, 1820, 1820, 1820, 1820, 1820, 19800, 295000};
get_pet_array(53) ->
    {38200, 1325, 1855, 1855, 1855, 1855, 1855, 20400, 304000};
get_pet_array(54) ->
    {38550, 1350, 1890, 1890, 1890, 1890, 1890, 21000, 313000};
get_pet_array(55) ->
    {38900, 1375, 1925, 1925, 1925, 1925, 1925, 21600, 322000};
get_pet_array(56) ->
    {39250, 1400, 1960, 1960, 1960, 1960, 1960, 22200, 331000};
get_pet_array(57) ->
    {39600, 1425, 1995, 1995, 1995, 1995, 1995, 22800, 340000};
get_pet_array(58) ->
    {39950, 1450, 2030, 2030, 2030, 2030, 2030, 23400, 349000};
get_pet_array(59) ->
    {40300, 1475, 2065, 2065, 2065, 2065, 2065, 24000, 358000};
get_pet_array(60) ->
    {40650, 1500, 2100, 2100, 2100, 2100, 2100, 24600, 367000};
get_pet_array(61) ->
    {41000, 1525, 2135, 2135, 2135, 2135, 2135, 25200, 379000};
get_pet_array(62) ->
    {41350, 1550, 2170, 2170, 2170, 2170, 2170, 25800, 391000};
get_pet_array(63) ->
    {41700, 1575, 2205, 2205, 2205, 2205, 2205, 26400, 403000};
get_pet_array(64) ->
    {42050, 1600, 2240, 2240, 2240, 2240, 2240, 27000, 415000};
get_pet_array(65) ->
    {42400, 1625, 2275, 2275, 2275, 2275, 2275, 27600, 427000};
get_pet_array(66) ->
    {42750, 1650, 2310, 2310, 2310, 2310, 2310, 28200, 439000};
get_pet_array(67) ->
    {43100, 1675, 2345, 2345, 2345, 2345, 2345, 28800, 451000};
get_pet_array(68) ->
    {43450, 1700, 2380, 2380, 2380, 2380, 2380, 28800, 463000};
get_pet_array(69) ->
    {43800, 1725, 2415, 2415, 2415, 2415, 2415, 28800, 475000};
get_pet_array(70) ->
    {44150, 1750, 2450, 2450, 2450, 2450, 2450, 28800, 487000};
get_pet_array(71) ->
    {44500, 1775, 2485, 2485, 2485, 2485, 2485, 28800, 499000};
get_pet_array(72) ->
    {44850, 1800, 2520, 2520, 2520, 2520, 2520, 28800, 511000};
get_pet_array(73) ->
    {45200, 1825, 2555, 2555, 2555, 2555, 2555, 28800, 523000};
get_pet_array(74) ->
    {45550, 1850, 2590, 2590, 2590, 2590, 2590, 28800, 535000};
get_pet_array(75) ->
    {45900, 1875, 2625, 2625, 2625, 2625, 2625, 28800, 547000};
get_pet_array(76) ->
    {46250, 1900, 2660, 2660, 2660, 2660, 2660, 28800, 559000};
get_pet_array(77) ->
    {46600, 1925, 2695, 2695, 2695, 2695, 2695, 28800, 571000};
get_pet_array(78) ->
    {46950, 1950, 2730, 2730, 2730, 2730, 2730, 28800, 583000};
get_pet_array(79) ->
    {47300, 1975, 2765, 2765, 2765, 2765, 2765, 28800, 595000};
get_pet_array(80) ->
    {47650, 2000, 2800, 2800, 2800, 2800, 2800, 28800, 607000};
get_pet_array(_Lev) -> over.
%% @spec get_workshop(Id) -> #soul_world_workshop_base{} | none
%% 获取单个工作坊配置
get_workshop(23000) ->
    #soul_world_workshop_base{item_id = 23000, unlock_fc = 10, unlock_gold = 0, unlock_coin = 10000, produce_gold = 0, produce_coin = 1800, produce_time = 3600};
get_workshop(27000) ->
    #soul_world_workshop_base{item_id = 27000, unlock_fc = 10, unlock_gold = 0, unlock_coin = 10000, produce_gold = 0, produce_coin = 3000, produce_time = 3600};
get_workshop(31001) ->
    #soul_world_workshop_base{item_id = 31001, unlock_fc = 50, unlock_gold = 0, unlock_coin = 30000, produce_gold = 0, produce_coin = 10000, produce_time = 4800};
get_workshop(30210) ->
    #soul_world_workshop_base{item_id = 30210, unlock_fc = 100, unlock_gold = 0, unlock_coin = 100000, produce_gold = 0, produce_coin = 20000, produce_time = 6000};
get_workshop(23300) ->
    #soul_world_workshop_base{item_id = 23300, unlock_fc = 120, unlock_gold = 0, unlock_coin = 500000, produce_gold = 0, produce_coin = 50000, produce_time = 7200};
get_workshop(23301) ->
    #soul_world_workshop_base{item_id = 23301, unlock_fc = 120, unlock_gold = 0, unlock_coin = 500000, produce_gold = 0, produce_coin = 50000, produce_time = 7200};
get_workshop(23302) ->
    #soul_world_workshop_base{item_id = 23302, unlock_fc = 120, unlock_gold = 0, unlock_coin = 500000, produce_gold = 0, produce_coin = 50000, produce_time = 7200};
get_workshop(23303) ->
    #soul_world_workshop_base{item_id = 23303, unlock_fc = 120, unlock_gold = 0, unlock_coin = 500000, produce_gold = 0, produce_coin = 50000, produce_time = 7200};
get_workshop(23304) ->
    #soul_world_workshop_base{item_id = 23304, unlock_fc = 120, unlock_gold = 0, unlock_coin = 500000, produce_gold = 0, produce_coin = 50000, produce_time = 7200};
get_workshop(23210) ->
    #soul_world_workshop_base{item_id = 23210, unlock_fc = 150, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23213) ->
    #soul_world_workshop_base{item_id = 23213, unlock_fc = 200, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23216) ->
    #soul_world_workshop_base{item_id = 23216, unlock_fc = 250, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23219) ->
    #soul_world_workshop_base{item_id = 23219, unlock_fc = 300, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23222) ->
    #soul_world_workshop_base{item_id = 23222, unlock_fc = 400, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23225) ->
    #soul_world_workshop_base{item_id = 23225, unlock_fc = 500, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23228) ->
    #soul_world_workshop_base{item_id = 23228, unlock_fc = 500, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23231) ->
    #soul_world_workshop_base{item_id = 23231, unlock_fc = 500, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23234) ->
    #soul_world_workshop_base{item_id = 23234, unlock_fc = 500, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23237) ->
    #soul_world_workshop_base{item_id = 23237, unlock_fc = 500, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23240) ->
    #soul_world_workshop_base{item_id = 23240, unlock_fc = 500, unlock_gold = 0, unlock_coin = 300000, produce_gold = 0, produce_coin = 20000, produce_time = 21600};
get_workshop(23211) ->
    #soul_world_workshop_base{item_id = 23211, unlock_fc = 1000, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23214) ->
    #soul_world_workshop_base{item_id = 23214, unlock_fc = 1200, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23217) ->
    #soul_world_workshop_base{item_id = 23217, unlock_fc = 1400, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23220) ->
    #soul_world_workshop_base{item_id = 23220, unlock_fc = 1600, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23223) ->
    #soul_world_workshop_base{item_id = 23223, unlock_fc = 1800, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23226) ->
    #soul_world_workshop_base{item_id = 23226, unlock_fc = 2000, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23229) ->
    #soul_world_workshop_base{item_id = 23229, unlock_fc = 2000, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23232) ->
    #soul_world_workshop_base{item_id = 23232, unlock_fc = 2000, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23235) ->
    #soul_world_workshop_base{item_id = 23235, unlock_fc = 2000, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23238) ->
    #soul_world_workshop_base{item_id = 23238, unlock_fc = 2000, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23241) ->
    #soul_world_workshop_base{item_id = 23241, unlock_fc = 2000, unlock_gold = 0, unlock_coin = 800000, produce_gold = 0, produce_coin = 100000, produce_time = 43200};
get_workshop(23212) ->
    #soul_world_workshop_base{item_id = 23212, unlock_fc = 3000, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(23215) ->
    #soul_world_workshop_base{item_id = 23215, unlock_fc = 3300, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(23218) ->
    #soul_world_workshop_base{item_id = 23218, unlock_fc = 3600, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(23221) ->
    #soul_world_workshop_base{item_id = 23221, unlock_fc = 3900, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(23224) ->
    #soul_world_workshop_base{item_id = 23224, unlock_fc = 4200, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(23227) ->
    #soul_world_workshop_base{item_id = 23227, unlock_fc = 4500, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(23230) ->
    #soul_world_workshop_base{item_id = 23230, unlock_fc = 4500, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(23233) ->
    #soul_world_workshop_base{item_id = 23233, unlock_fc = 4500, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(23236) ->
    #soul_world_workshop_base{item_id = 23236, unlock_fc = 4500, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(23239) ->
    #soul_world_workshop_base{item_id = 23239, unlock_fc = 4500, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(23242) ->
    #soul_world_workshop_base{item_id = 23242, unlock_fc = 4500, unlock_gold = 30, unlock_coin = 0, produce_gold = 0, produce_coin = 300000, produce_time = 129600};
get_workshop(_Id) ->
    none.

%% @spec get_workshop_ids() -> list()
%% 获取所有工作坊配置id
get_workshop_ids() ->
    [23000, 27000, 31001, 30210, 23300, 23301, 23302, 23303, 23304, 23210, 23213, 23216, 23219, 23222, 23225, 23228, 23231, 23234, 23237, 23240, 23211, 23214, 23217, 23220, 23223, 23226, 23229, 23232, 23235, 23238, 23241, 23212, 23215, 23218, 23221, 23224, 23227, 23230, 23233, 23236, 23239, 23242].
