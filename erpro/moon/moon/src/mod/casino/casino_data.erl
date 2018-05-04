%%----------------------------------------------------
%% 开封印基础数据
%% @author whjing2011
%%----------------------------------------------------
-module(casino_data).
-export([
     list/1
     ,get/4
     ,rand_reward/3
   ]
).

-include("casino.hrl").


%% 开封印基础数据列表
list(0) ->
    [27000,30010,30012];
list(1) ->
    [29473,32001,23003,25022,25021,23012,21030,27003,21021,21022,21035,26040,26041,26042,26043,26044,26045,26046,26047,26048,26020,26021,26022,26023,26024,26025,26026,26027,26028,26000,26001,26002,26003,26004,26005,26006,26007,26008,31003,31002,32521,32520,21002,21012,21001,21011,21020,21000,21010,27002,27001,27000,30010,22000,22010,22020,22030,24124,24109,24100,24103,24106,24112,24115,23000,33088,23040];
list(2) ->
    [23116,23115,26060,26061,21030,26062,26063,21022,25023,26064,26065,26066,26067,22243,26068,21035,25022,33051,32001,21021,25021,31003,23018,21700,23003,27003,21701,32702,26040,26041,26042,26043,26044,26045,26046,26047,26048,32301,33053,33070,32522,23001,21020,27002,32701,32703,32203,24120,26020,26021,26022,26023,26024,26025,26026,26027,26028,30012,24101,24104,24107,24110,24113,24116,27001,33241];
list(3) ->
    [22000,22242,22243,26021,26020,26023,26024,26025,26026,26027,26022,26028,26029,26030,26031,26032,26033,26034,26035,26041,26040,26043,26044,26045,26046,26047,26042,26048,26049,26050,26051,26052,26053,26054,26055,26061,26060,26063,26064,26065,26066,26067,26062,26068,26069,26070,26071,26072,26073,26074,26075,26081,26080,26083,26084,26085,26086,26087,26082,26088,26101,26100,26103,26104,26105,26106,26107,26102,26108];
list(4) ->
    [22243,23440,23426,23404,23405,23406,23408,23420,23421,23422,23423,23424,23425,23427,23428,23429,23430,23431,23432,23433,23434,23438,23439,23457,23458,23461,33051,25022,33109,32001,27507,33274,33085,25021,23019,21700,33128,22203,23003,21701,32702,22221,33127,33149,33151,32701,32203,32301,32522,23001,21020,32703,27505,33114,33108,33101,33088,24120,33126,30012,26020,26021,26022,26023,26024,26025,26026,26027,26028,33125,23000,31001,27000,33241];
list(_) -> [].

%% 开封印物品
get(default, 1, 27000, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,is_default = 1
           ,base_id = 27000
           ,name = <<"绿色洗练石">>
           ,rand = 5000
           ,bind = 0
        }
    };

get(default, 1, 30010, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,is_default = 1
           ,base_id = 30010
           ,name = <<"金币卡">>
           ,rand = 5000
           ,bind = 0
        }
    };

get(default, 2, 27000, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,is_default = 1
           ,base_id = 27000
           ,name = <<"绿色洗练石">>
           ,rand = 5000
           ,bind = 0
        }
    };

get(default, 2, 30012, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,is_default = 1
           ,base_id = 30012
           ,name = <<"高级金币卡">>
           ,rand = 5000
           ,bind = 0
        }
    };

get(default, 3, 27000, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,is_default = 1
           ,base_id = 27000
           ,name = <<"绿色洗练石">>
           ,rand = 5000
           ,bind = 0
        }
    };

get(default, 3, 30012, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,is_default = 1
           ,base_id = 30012
           ,name = <<"高级金币卡">>
           ,rand = 5000
           ,bind = 0
        }
    };

get(default, 4, 27000, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,is_default = 1
           ,base_id = 27000
           ,name = <<"绿色洗练石">>
           ,rand = 5000
           ,bind = 0
        }
    };

get(default, 4, 30012, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,is_default = 1
           ,base_id = 30012
           ,name = <<"高级金币卡">>
           ,rand = 5000
           ,bind = 0
        }
    };

get(normal, 1, 29473, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 29473
           ,name = <<"真·月桂仙子唤灵礼盒">>
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,500}
           ,must_out = 700
           ,is_notice = 1
           ,sort = 910
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 300
        }
    };

get(normal, 1, 32001, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 32001
           ,name = <<"护神丹">>
           ,rand = 300
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 250
           ,is_notice = 1
           ,sort = 900
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 23003, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 23003
           ,name = <<"仙宠潜力保护符">>
           ,rand = 500
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 150
           ,is_notice = 1
           ,sort = 899
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 25022, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 25022
           ,name = <<"神器之魄">>
           ,rand = 70
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,80}
           ,must_out = 625
           ,is_notice = 1
           ,sort = 898
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 25021, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 25021
           ,name = <<"紫晶魂">>
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,250}
           ,must_out = 2000
           ,is_notice = 1
           ,sort = 897
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 23012, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 23012
           ,name = <<"仙宠蛋">>
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,55}
           ,must_out = 375
           ,is_notice = 1
           ,sort = 896
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21030, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21030
           ,name = <<"+9强化保护符">>
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,200}
           ,must_out = 1875
           ,is_notice = 1
           ,sort = 895
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 27003, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 27003
           ,name = <<"橙色洗练石">>
           ,rand = 40
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,150}
           ,must_out = 937
           ,is_notice = 1
           ,sort = 894
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21021, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21021
           ,name = <<"精品幸运石">>
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,250}
           ,must_out = 1875
           ,is_notice = 1
           ,sort = 893
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21022, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21022
           ,name = <<"优良幸运石">>
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,400}
           ,must_out = 2000
           ,is_notice = 1
           ,sort = 892
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21035, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21035
           ,name = <<"继承保护符碎片">>
           ,rand = 110
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,150}
           ,must_out = 550
           ,is_notice = 1
           ,sort = 891
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26040, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26040
           ,name = <<"三级气血石">>
           ,rand = 19
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 800
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26041, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26041
           ,name = <<"三级法力石">>
           ,rand = 23
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 799
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26042, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26042
           ,name = <<"三级攻击石">>
           ,rand = 9
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 2000
           ,is_notice = 1
           ,sort = 798
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26043, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26043
           ,name = <<"三级防御石">>
           ,rand = 23
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 797
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26044, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26044
           ,name = <<"三级暴击石">>
           ,rand = 19
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 796
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26045, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26045
           ,name = <<"三级命中石">>
           ,rand = 15
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 795
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26046, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26046
           ,name = <<"三级躲闪石">>
           ,rand = 15
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 794
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26047, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26047
           ,name = <<"三级坚韧石">>
           ,rand = 19
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 793
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26048, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26048
           ,name = <<"三级敏捷石">>
           ,rand = 6
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 5000
           ,is_notice = 1
           ,sort = 792
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26020, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26020
           ,name = <<"二级气血石">>
           ,rand = 230
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 700
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26021, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26021
           ,name = <<"二级法力石">>
           ,rand = 288
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 699
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26022, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26022
           ,name = <<"二级攻击石">>
           ,rand = 115
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 698
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26023, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26023
           ,name = <<"二级防御石">>
           ,rand = 288
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 697
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26024, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26024
           ,name = <<"二级暴击石">>
           ,rand = 230
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 696
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26025, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26025
           ,name = <<"二级命中石">>
           ,rand = 191
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 695
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26026, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26026
           ,name = <<"二级躲闪石">>
           ,rand = 191
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 694
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26027, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26027
           ,name = <<"二级坚韧石">>
           ,rand = 230
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 693
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26028, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26028
           ,name = <<"二级敏捷石">>
           ,rand = 37
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 692
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26000, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26000
           ,name = <<"一级气血石">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 600
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26001, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26001
           ,name = <<"一级法力石">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 599
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26002, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26002
           ,name = <<"一级攻击石">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 598
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26003, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26003
           ,name = <<"一级防御石">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 597
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26004, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26004
           ,name = <<"一级暴击石">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 596
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26005, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26005
           ,name = <<"一级命中石">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 595
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26006, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26006
           ,name = <<"一级躲闪石">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 594
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26007, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26007
           ,name = <<"一级坚韧石">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 593
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 26008, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 26008
           ,name = <<"一级敏捷石">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 592
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 31003, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 31003
           ,name = <<"飞仙令牌*紫">>
           ,rand = 80
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 565
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 31002, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 31002
           ,name = <<"飞仙令牌*蓝">>
           ,rand = 400
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 564
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 32521, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 32521
           ,name = <<"中级经验丹">>
           ,rand = 600
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,35}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 555
           ,bind = 1
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 32520, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 32520
           ,name = <<"低级经验丹">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,10}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 554
           ,bind = 1
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21002, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21002
           ,name = <<"高级强化仙玉">>
           ,rand = 50
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 500
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21012, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21012
           ,name = <<"高级强化灵石">>
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 499
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21001, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21001
           ,name = <<"中级强化仙玉">>
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 490
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21011, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21011
           ,name = <<"中级强化灵石">>
           ,rand = 200
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 489
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21020, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21020
           ,name = <<"普通幸运石">>
           ,rand = 600
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 485
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21000, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21000
           ,name = <<"初级强化仙玉">>
           ,rand = 400
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 480
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 21010, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 21010
           ,name = <<"初级强化灵石">>
           ,rand = 1000
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 479
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 27002, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 27002
           ,name = <<"紫色洗练石">>
           ,rand = 150
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 400
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 27001, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 27001
           ,name = <<"蓝色洗练石">>
           ,rand = 650
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 399
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 27000, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 27000
           ,name = <<"绿色洗练石">>
           ,rand = 370
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 398
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 30010, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 30010
           ,name = <<"金币卡">>
           ,rand = 1050
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 350
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 22000, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 22000
           ,name = <<"合成符">>
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 300
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 22010, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 22010
           ,name = <<"打孔符">>
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 299
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 22020, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 22020
           ,name = <<"镶嵌符">>
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 298
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 22030, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 22030
           ,name = <<"摘除符">>
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 297
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 24124, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 24124
           ,name = <<"五行抗性药">>
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 200
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 24109, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 24109
           ,name = <<"初级攻击药">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 100
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 24100, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 24100
           ,name = <<"初级气血药">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 99
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 24103, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 24103
           ,name = <<"初级法力药">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 98
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 24106, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 24106
           ,name = <<"初级防御药">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 97
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 24112, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 24112
           ,name = <<"初级命中药">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 96
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 24115, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 24115
           ,name = <<"初级躲闪药">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 95
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 23000, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 23000
           ,name = <<"仙宠口粮">>
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 10
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 33088, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 33088
           ,name = <<"圣域灵草">>
           ,rand = 200
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 850
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 1, 23040, 0) -> 
    {ok, #casino_base_data{
           type = 1
           ,base_id = 23040
           ,name = <<"灵幻石">>
           ,rand = 400
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 890
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 23116, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 23116
           ,name = <<"真·小仙鹿">>
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,500}
           ,must_out = 1000
           ,is_notice = 1
           ,sort = 995
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 200
        }
    };

get(normal, 2, 23115, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 23115
           ,name = <<"真·小狮妹">>
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,500}
           ,must_out = 1300
           ,is_notice = 1
           ,sort = 999
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 300
        }
    };

get(normal, 2, 26060, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26060
           ,name = <<"四级气血石">>
           ,rand = 5
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 770
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26061, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26061
           ,name = <<"四级法力石">>
           ,rand = 5
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 760
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 21030, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 21030
           ,name = <<"+9强化保护符">>
           ,rand = 20
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 880
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26062, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26062
           ,name = <<"四级攻击石">>
           ,rand = 4
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 750
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26063, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26063
           ,name = <<"四级防御石">>
           ,rand = 5
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 740
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 21022, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 21022
           ,name = <<"优良幸运石">>
           ,rand = 10
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 820
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 25023, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 25023
           ,name = <<"火凤羽">>
           ,rand = 80
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 940
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26064, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26064
           ,name = <<"四级暴击石">>
           ,rand = 5
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 730
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26065, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26065
           ,name = <<"四级命中石">>
           ,rand = 4
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 720
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26066, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26066
           ,name = <<"四级躲闪石">>
           ,rand = 4
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 710
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26067, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26067
           ,name = <<"四级坚韧石">>
           ,rand = 5
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 700
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 22243, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 22243
           ,name = <<"四级淬炼石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 910
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26068, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26068
           ,name = <<"四级敏捷石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 690
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 21035, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 21035
           ,name = <<"继承保护符碎片">>
           ,rand = 50
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 860
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 25022, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 25022
           ,name = <<"神器之魄">>
           ,rand = 30
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 970
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 33051, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 33051
           ,name = <<"圣域仙草">>
           ,rand = 250
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 930
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 32001, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 32001
           ,name = <<"护神丹">>
           ,rand = 400
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 990
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 21021, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 21021
           ,name = <<"精品幸运石">>
           ,rand = 20
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 830
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 25021, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 25021
           ,name = <<"紫晶魂">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 960
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 31003, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 31003
           ,name = <<"飞仙令牌*紫">>
           ,rand = 80
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 780
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 23018, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 23018
           ,name = <<"仙宠精魂（紫）">>
           ,rand = 170
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 950
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 21700, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 21700
           ,name = <<"神佑石">>
           ,rand = 500
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 975
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 23003, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 23003
           ,name = <<"仙宠潜力保护符">>
           ,rand = 480
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 980
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 27003, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 27003
           ,name = <<"橙色洗练石">>
           ,rand = 40
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 790
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 21701, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 21701
           ,name = <<"转魂石">>
           ,rand = 200
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 976
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 32702, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 32702
           ,name = <<"灵器洗炼石">>
           ,rand = 200
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 811
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26040, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26040
           ,name = <<"三级气血石">>
           ,rand = 195
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 680
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26041, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26041
           ,name = <<"三级法力石">>
           ,rand = 240
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 670
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26042, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26042
           ,name = <<"三级攻击石">>
           ,rand = 96
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 660
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26043, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26043
           ,name = <<"三级防御石">>
           ,rand = 240
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 650
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26044, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26044
           ,name = <<"三级暴击石">>
           ,rand = 192
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 640
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26045, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26045
           ,name = <<"三级命中石">>
           ,rand = 159
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 630
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26046, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26046
           ,name = <<"三级躲闪石">>
           ,rand = 159
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 620
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26047, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26047
           ,name = <<"三级坚韧石">>
           ,rand = 192
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 610
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26048, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26048
           ,name = <<"三级敏捷石">>
           ,rand = 30
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 600
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 32301, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 32301
           ,name = <<"坐骑进阶仙丹">>
           ,rand = 300
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 920
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 33053, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 33053
           ,name = <<"仙法竞技积分神符">>
           ,rand = 140
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 900
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 33070, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 33070
           ,name = <<"帮战积分神符">>
           ,rand = 120
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 890
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 32522, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 32522
           ,name = <<"高级经验丹">>
           ,rand = 500
           ,limit_type = 1
           ,limit_time = {86400,30}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 870
           ,bind = 1
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 23001, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 23001
           ,name = <<"仙宠成长丹">>
           ,rand = 490
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 850
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 21020, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 21020
           ,name = <<"普通幸运石">>
           ,rand = 580
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 840
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 27002, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 27002
           ,name = <<"紫色洗练石">>
           ,rand = 150
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 800
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 32701, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 32701
           ,name = <<"灵器进阶仙玉">>
           ,rand = 400
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 871
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 32703, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 32703
           ,name = <<"灵器聚灵石">>
           ,rand = 300
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 812
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 32203, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 32203
           ,name = <<"翅膀仙羽">>
           ,rand = 450
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 870
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 24120, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 24120
           ,name = <<"气血包">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 430
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26020, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26020
           ,name = <<"二级气血石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 590
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26021, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26021
           ,name = <<"二级法力石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 580
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26022, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26022
           ,name = <<"二级攻击石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 570
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26023, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26023
           ,name = <<"二级防御石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 560
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26024, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26024
           ,name = <<"二级暴击石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 550
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26025, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26025
           ,name = <<"二级命中石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 540
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26026, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26026
           ,name = <<"二级躲闪石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 530
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26027, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26027
           ,name = <<"二级坚韧石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 520
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 26028, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 26028
           ,name = <<"二级敏捷石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 510
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 30012, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 30012
           ,name = <<"高级金币卡">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 500
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 24101, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 24101
           ,name = <<"中级气血药">>
           ,rand = 390
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 490
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 24104, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 24104
           ,name = <<"中级法力药">>
           ,rand = 390
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 480
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 24107, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 24107
           ,name = <<"中级防御药">>
           ,rand = 390
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 470
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 24110, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 24110
           ,name = <<"中级攻击药">>
           ,rand = 370
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 460
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 24113, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 24113
           ,name = <<"中级命中药">>
           ,rand = 390
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 450
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 24116, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 24116
           ,name = <<"中级躲闪药">>
           ,rand = 390
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 440
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 27001, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 27001
           ,name = <<"蓝色洗练石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 810
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 2, 33241, 0) -> 
    {ok, #casino_base_data{
           type = 2
           ,base_id = 33241
           ,name = <<"仙宠金蛋">>
           ,rand = 50
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 885
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 22000, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 22000
           ,name = <<"合成符">>
           ,rand = 1022
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 10
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 22242, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 22242
           ,name = <<"三级淬炼石">>
           ,rand = 300
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 40
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 22243, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 22243
           ,name = <<"四级淬炼石">>
           ,rand = 100
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 80
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26021, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26021
           ,name = <<"二级法力石">>
           ,rand = 600
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 110
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26020, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26020
           ,name = <<"二级气血石">>
           ,rand = 495
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 120
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26023, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26023
           ,name = <<"二级防御石">>
           ,rand = 495
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 130
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26024, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26024
           ,name = <<"二级暴击石">>
           ,rand = 495
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 140
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26025, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26025
           ,name = <<"二级命中石">>
           ,rand = 495
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 150
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26026, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26026
           ,name = <<"二级躲闪石">>
           ,rand = 495
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 160
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26027, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26027
           ,name = <<"二级坚韧石">>
           ,rand = 495
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 170
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26022, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26022
           ,name = <<"二级攻击石">>
           ,rand = 400
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 180
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26028, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26028
           ,name = <<"二级敏捷石">>
           ,rand = 150
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 190
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26029, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26029
           ,name = <<"二级法伤石">>
           ,rand = 270
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 210
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26030, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26030
           ,name = <<"二级眩晕抵抗石">>
           ,rand = 210
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 220
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26031, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26031
           ,name = <<"二级遗忘抵抗石">>
           ,rand = 210
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 230
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26032, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26032
           ,name = <<"二级睡眠抵抗石">>
           ,rand = 210
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 240
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26033, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26033
           ,name = <<"二级石化抵抗石">>
           ,rand = 210
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 250
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26034, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26034
           ,name = <<"二级嘲讽抵抗石">>
           ,rand = 210
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 260
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26035, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26035
           ,name = <<"二级控制强化石">>
           ,rand = 60
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 270
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26041, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26041
           ,name = <<"三级法力石">>
           ,rand = 190
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 310
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26040, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26040
           ,name = <<"三级气血石">>
           ,rand = 190
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 320
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26043, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26043
           ,name = <<"三级防御石">>
           ,rand = 190
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 330
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26044, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26044
           ,name = <<"三级暴击石">>
           ,rand = 190
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 340
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26045, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26045
           ,name = <<"三级命中石">>
           ,rand = 190
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 350
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26046, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26046
           ,name = <<"三级躲闪石">>
           ,rand = 190
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 360
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26047, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26047
           ,name = <<"三级坚韧石">>
           ,rand = 190
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 370
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26042, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26042
           ,name = <<"三级攻击石">>
           ,rand = 162
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 380
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26048, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26048
           ,name = <<"三级敏捷石">>
           ,rand = 80
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 390
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26049, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26049
           ,name = <<"三级法伤石">>
           ,rand = 120
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 410
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26050, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26050
           ,name = <<"三级眩晕抵抗石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 420
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26051, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26051
           ,name = <<"三级遗忘抵抗石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 430
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26052, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26052
           ,name = <<"三级睡眠抵抗石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 440
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26053, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26053
           ,name = <<"三级石化抵抗石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 450
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26054, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26054
           ,name = <<"三级嘲讽抵抗石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 460
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26055, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26055
           ,name = <<"三级控制强化石">>
           ,rand = 50
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 470
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26061, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26061
           ,name = <<"四级法力石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 510
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26060, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26060
           ,name = <<"四级气血石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 520
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26063, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26063
           ,name = <<"四级防御石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 530
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26064, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26064
           ,name = <<"四级暴击石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 540
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26065, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26065
           ,name = <<"四级命中石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 550
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26066, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26066
           ,name = <<"四级躲闪石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 560
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26067, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26067
           ,name = <<"四级坚韧石">>
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 570
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26062, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26062
           ,name = <<"四级攻击石">>
           ,rand = 54
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 580
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26068, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26068
           ,name = <<"四级敏捷石">>
           ,rand = 27
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 590
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26069, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26069
           ,name = <<"四级法伤石">>
           ,rand = 50
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 610
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26070, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26070
           ,name = <<"四级眩晕抵抗石">>
           ,rand = 20
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 620
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26071, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26071
           ,name = <<"四级遗忘抵抗石">>
           ,rand = 20
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 630
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26072, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26072
           ,name = <<"四级睡眠抵抗石">>
           ,rand = 20
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 640
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26073, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26073
           ,name = <<"四级石化抵抗石">>
           ,rand = 20
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 650
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26074, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26074
           ,name = <<"四级嘲讽抵抗石">>
           ,rand = 20
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 660
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26075, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26075
           ,name = <<"四级控制强化石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 670
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26081, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26081
           ,name = <<"五级法力石">>
           ,rand = 3
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 710
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26080, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26080
           ,name = <<"五级气血石">>
           ,rand = 3
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 720
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26083, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26083
           ,name = <<"五级防御石">>
           ,rand = 3
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 730
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26084, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26084
           ,name = <<"五级暴击石">>
           ,rand = 3
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 740
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26085, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26085
           ,name = <<"五级命中石">>
           ,rand = 3
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 750
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26086, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26086
           ,name = <<"五级躲闪石">>
           ,rand = 3
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 760
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26087, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26087
           ,name = <<"五级坚韧石">>
           ,rand = 3
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 770
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26082, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26082
           ,name = <<"五级攻击石">>
           ,rand = 3
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 780
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26088, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26088
           ,name = <<"五级敏捷石">>
           ,rand = 1
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 790
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26101, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26101
           ,name = <<"六级法力石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 810
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26100, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26100
           ,name = <<"六级气血石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 820
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26103, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26103
           ,name = <<"六级防御石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 830
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26104, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26104
           ,name = <<"六级暴击石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 840
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26105, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26105
           ,name = <<"六级命中石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 850
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26106, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26106
           ,name = <<"六级躲闪石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 860
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26107, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26107
           ,name = <<"六级坚韧石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 870
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26102, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26102
           ,name = <<"六级攻击石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 880
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 3, 26108, 0) -> 
    {ok, #casino_base_data{
           type = 3
           ,base_id = 26108
           ,name = <<"六级敏捷石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 890
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 22243, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 22243
           ,name = <<"四级淬炼石">>
           ,rand = 200
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 779
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23440, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23440
           ,name = <<"灵龙之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 985
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23426, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23426
           ,name = <<"霜焰冥龙之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 980
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23404, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23404
           ,name = <<"玄冥虎刹之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 970
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23405, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23405
           ,name = <<"伊邪那岐之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 960
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23406, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23406
           ,name = <<"慧心灵姬之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 950
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23408, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23408
           ,name = <<"琴虫之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 940
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23420, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23420
           ,name = <<"小蘑菇之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 930
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23421, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23421
           ,name = <<"虫虫特工之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 920
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23422, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23422
           ,name = <<"小马哥之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 910
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23423, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23423
           ,name = <<"万圣节小南瓜之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 900
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23424, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23424
           ,name = <<"花楹精灵之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 890
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23425, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23425
           ,name = <<"圣诞雪人之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 880
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23427, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23427
           ,name = <<"皮皮可西之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 870
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23428, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23428
           ,name = <<"蓝兔精灵之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 860
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23429, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23429
           ,name = <<"粉兔精灵之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 850
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23430, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23430
           ,name = <<"玉锦祥蛇之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 840
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23431, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23431
           ,name = <<"瑞兽之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 830
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23432, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23432
           ,name = <<"粽宝宝之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 820
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23433, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23433
           ,name = <<"奥运吉祥物之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 810
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23434, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23434
           ,name = <<"汤圆宝宝之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 800
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23438, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23438
           ,name = <<"飞仙吉祥物之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 790
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23439, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23439
           ,name = <<"喵星人之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 780
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23457, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23457
           ,name = <<"莲花仙宠之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 780
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23458, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23458
           ,name = <<"哆啦A梦仙宠之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 780
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23461, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23461
           ,name = <<"小火轮仙宠之魂">>
           ,rand = 4
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 780
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33051, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33051
           ,name = <<"圣域仙草">>
           ,rand = 200
           ,limit_type = 2
           ,limit_time = {1,1}
           ,limit_num = {1,1}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 770
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 25022, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 25022
           ,name = <<"神器之魄">>
           ,rand = 10
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 760
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33109, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33109
           ,name = <<"八门保护符">>
           ,rand = 400
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 750
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 32001, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 32001
           ,name = <<"护神丹">>
           ,rand = 280
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 740
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 27507, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 27507
           ,name = <<"守护本源">>
           ,rand = 100
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 730
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33274, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33274
           ,name = <<"感恩玫瑰">>
           ,rand = 250
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 999
           ,bind = 1
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33085, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33085
           ,name = <<"魔晶碎片">>
           ,rand = 250
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 710
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 25021, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 25021
           ,name = <<"紫晶魂">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 700
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23019, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23019
           ,name = <<"仙宠精魂（橙）">>
           ,rand = 240
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 690
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 21700, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 21700
           ,name = <<"神佑石">>
           ,rand = 300
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 680
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33128, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33128
           ,name = <<"妖魂橙">>
           ,rand = 200
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 670
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 22203, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 22203
           ,name = <<"五级星辰石">>
           ,rand = 300
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 660
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23003, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23003
           ,name = <<"仙宠潜力保护符">>
           ,rand = 380
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 650
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 21701, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 21701
           ,name = <<"转魂石">>
           ,rand = 100
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 640
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 32702, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 32702
           ,name = <<"灵器洗炼石">>
           ,rand = 200
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 630
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 22221, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 22221
           ,name = <<"精良水月石">>
           ,rand = 380
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 620
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33127, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33127
           ,name = <<"妖魂紫">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 610
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33149, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33149
           ,name = <<"神魔阵升级丹">>
           ,rand = 150
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 600
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33151, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33151
           ,name = <<"法宝进阶丹">>
           ,rand = 380
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 590
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 32701, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 32701
           ,name = <<"灵器进阶仙玉">>
           ,rand = 350
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 580
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 32203, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 32203
           ,name = <<"翅膀仙羽">>
           ,rand = 350
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 570
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 32301, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 32301
           ,name = <<"坐骑进阶仙丹">>
           ,rand = 350
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 560
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 32522, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 32522
           ,name = <<"高级经验丹">>
           ,rand = 200
           ,limit_type = 1
           ,limit_time = {86400,30}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 550
           ,bind = 1
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23001, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23001
           ,name = <<"仙宠成长丹">>
           ,rand = 400
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 540
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 21020, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 21020
           ,name = <<"普通幸运石">>
           ,rand = 400
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 530
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 32703, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 32703
           ,name = <<"灵器聚灵石">>
           ,rand = 320
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 520
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 27505, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 27505
           ,name = <<"守护水晶">>
           ,rand = 340
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 510
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33114, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33114
           ,name = <<"灵魂水晶">>
           ,rand = 290
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 500
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33108, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33108
           ,name = <<"八门金丹">>
           ,rand = 200
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 490
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33101, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33101
           ,name = <<"洗练锁">>
           ,rand = 340
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 480
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33088, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33088
           ,name = <<"圣域灵草">>
           ,rand = 380
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 470
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 24120, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 24120
           ,name = <<"气血包">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 460
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33126, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33126
           ,name = <<"妖魂蓝">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 450
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 30012, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 30012
           ,name = <<"高级金币卡">>
           ,rand = 560
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 440
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 26020, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 26020
           ,name = <<"二级气血石">>
           ,rand = 128
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 430
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 26021, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 26021
           ,name = <<"二级法力石">>
           ,rand = 160
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 420
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 26022, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 26022
           ,name = <<"二级攻击石">>
           ,rand = 64
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 410
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 26023, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 26023
           ,name = <<"二级防御石">>
           ,rand = 160
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 400
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 26024, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 26024
           ,name = <<"二级暴击石">>
           ,rand = 128
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 390
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 26025, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 26025
           ,name = <<"二级命中石">>
           ,rand = 106
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 380
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 26026, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 26026
           ,name = <<"二级躲闪石">>
           ,rand = 106
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 370
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 26027, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 26027
           ,name = <<"二级坚韧石">>
           ,rand = 128
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 360
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 26028, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 26028
           ,name = <<"二级敏捷石">>
           ,rand = 20
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 350
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33125, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33125
           ,name = <<"妖魂绿">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 340
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 23000, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 23000
           ,name = <<"仙宠口粮">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 330
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 31001, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 31001
           ,name = <<"飞仙令牌·绿">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 320
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 27000, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 27000
           ,name = <<"绿色洗练石">>
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,must_out = 0
           ,is_notice = 0
           ,sort = 310
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(normal, 4, 33241, 0) -> 
    {ok, #casino_base_data{
           type = 4
           ,base_id = 33241
           ,name = <<"仙宠金蛋">>
           ,rand = 100
           ,limit_type = 2
           ,limit_time = {1,1}
           ,limit_num = {1,1}
           ,must_out = 0
           ,is_notice = 1
           ,sort = 775
           ,bind = 0
           ,sex = -1
           ,career = -1
           ,can_out = 0
        }
    };

get(_Mod, _Type, _Id, _LuckVal) ->
    {false, <<"无此物品信息">>}.

%% 活动随机奖励
rand_reward(1, 1, Rand) when Rand >= 1 andalso Rand =< 500 -> {{1,1}, [{23114,1,1,20}, {32001,1,1,300}, {23003,1,1,500}, {25022,1,1,70}, {25021,1,1,10}, {23012,1,1,100}, {21030,1,1,20}, {27003,1,1,40}, {21021,1,1,20}, {21022,1,1,10}, {21035,1,1,110}, {26040,1,1,19}, {26041,1,1,24}, {26042,1,1,9}, {26043,1,1,24}, {26044,1,1,19}, {26045,1,1,15}, {26046,1,1,15}, {26047,1,1,19}, {26048,1,1,6}, {26020,1,1,230}, {26021,1,1,288}, {26022,1,1,115}, {26023,1,1,288}, {26024,1,1,230}, {26025,1,1,191}, {26026,1,1,191}, {26027,1,1,230}, {26028,1,1,37}, {31003,1,1,80}, {31002,1,1,400}, {32521,1,1,600}, {21002,1,1,50}, {21012,1,1,100}, {21001,1,1,100}, {21011,1,1,200}, {21020,1,1,600}, {21000,1,1,400}, {21010,1,1,1000}, {27002,1,1,150}, {27001,1,1,650}, {27000,1,1,370}, {30010,1,1,1050}, {22000,1,1,100}, {22010,1,1,100}, {22020,1,1,100}, {22030,1,1,100}, {24124,1,1,100}, {33088,1,1,200}, {23040,1,1,400}]};
rand_reward(1, 10, Rand) when Rand >= 1 andalso Rand =< 5000 -> {{1,1}, [{23114,1,1,20}, {32001,1,1,300}, {23003,1,1,500}, {25022,1,1,70}, {25021,1,1,10}, {23012,1,1,100}, {21030,1,1,20}, {27003,1,1,40}, {21021,1,1,20}, {21022,1,1,10}, {21035,1,1,110}, {26040,1,1,19}, {26041,1,1,24}, {26042,1,1,9}, {26043,1,1,24}, {26044,1,1,19}, {26045,1,1,15}, {26046,1,1,15}, {26047,1,1,19}, {26048,1,1,6}, {26020,1,1,230}, {26021,1,1,288}, {26022,1,1,115}, {26023,1,1,288}, {26024,1,1,230}, {26025,1,1,191}, {26026,1,1,191}, {26027,1,1,230}, {26028,1,1,37}, {31003,1,1,80}, {31002,1,1,400}, {32521,1,1,600}, {21002,1,1,50}, {21012,1,1,100}, {21001,1,1,100}, {21011,1,1,200}, {21020,1,1,600}, {21000,1,1,400}, {21010,1,1,1000}, {27002,1,1,150}, {27001,1,1,650}, {27000,1,1,370}, {30010,1,1,1050}, {22000,1,1,100}, {22010,1,1,100}, {22020,1,1,100}, {22030,1,1,100}, {24124,1,1,100}, {33088,1,1,200}, {23040,1,1,400}]};
rand_reward(1, 50, Rand) when Rand >= 1 andalso Rand =< 10000 -> {{1,3}, [{23114,1,1,20}, {32001,1,1,300}, {23003,1,1,500}, {25022,1,1,70}, {25021,1,1,10}, {23012,1,1,100}, {21030,1,1,20}, {27003,1,1,40}, {21021,1,1,20}, {21022,1,1,10}, {21035,1,1,110}, {26040,1,1,19}, {26041,1,1,24}, {26042,1,1,9}, {26043,1,1,24}, {26044,1,1,19}, {26045,1,1,15}, {26046,1,1,15}, {26047,1,1,19}, {26048,1,1,6}, {26020,1,1,230}, {26021,1,1,288}, {26022,1,1,115}, {26023,1,1,288}, {26024,1,1,230}, {26025,1,1,191}, {26026,1,1,191}, {26027,1,1,230}, {26028,1,1,37}, {31003,1,1,80}, {31002,1,1,400}, {32521,1,1,600}, {21002,1,1,50}, {21012,1,1,100}, {21001,1,1,100}, {21011,1,1,200}, {21020,1,1,600}, {21000,1,1,400}, {21010,1,1,1000}, {27002,1,1,150}, {27001,1,1,650}, {27000,1,1,370}, {30010,1,1,1050}, {22000,1,1,100}, {22010,1,1,100}, {22020,1,1,100}, {22030,1,1,100}, {24124,1,1,100}, {33088,1,1,200}, {23040,1,1,400}]};
rand_reward(2, 1, Rand) when Rand >= 1 andalso Rand =< 500 -> {{1,1}, [{32001,1,1,600},{23003,1,1,800},{25022,1,1,30},{23018,1,1,170},{25023,1,1,80},{33051,1,1,300},{32301,1,1,300},{22243,1,1,90},{33053,1,1,140},{33070,1,1,120},{21030,1,1,20},{32522,1,1,500},{21035,1,1,50},{23001,1,1,500},{21020,1,1,700},{21021,1,1,20},{21022,1,1,10},{27001,1,1,800},{27002,1,1,150},{27003,1,1,40},{31003,1,1,80},{26060,1,1,3},{26061,1,1,3},{26062,1,1,1},{26063,1,1,3},{26064,1,1,3},{26065,1,1,2},{26066,1,1,2},{26067,1,1,3},{26040,1,1,36},{26041,1,1,45},{26042,1,1,18},{26043,1,1,45},{26044,1,1,36},{26045,1,1,30},{26046,1,1,30},{26047,1,1,36},{26048,1,1,4},{26020,1,1,192},{26021,1,1,240},{26022,1,1,96},{26023,1,1,240},{26024,1,1,192},{26025,1,1,159},{26026,1,1,159},{26027,1,1,192},{26028,1,1,30},{30012,1,1,1200},{24101,1,1,100},{24104,1,1,100},{24107,1,1,100},{24110,1,1,100},{24113,1,1,100},{24116,1,1,100},{21700,1,1,700},{21701,1,1,200}]};
rand_reward(2, 10, Rand) when Rand >= 1 andalso Rand =< 5000 -> {{1,1}, [{32001,1,1,600},{23003,1,1,800},{25022,1,1,30},{23018,1,1,170},{25023,1,1,80},{33051,1,1,300},{32301,1,1,300},{22243,1,1,90},{33053,1,1,140},{33070,1,1,120},{21030,1,1,20},{32522,1,1,500},{21035,1,1,50},{23001,1,1,500},{21020,1,1,700},{21021,1,1,20},{21022,1,1,10},{27001,1,1,800},{27002,1,1,150},{27003,1,1,40},{31003,1,1,80},{26060,1,1,3},{26061,1,1,3},{26062,1,1,1},{26063,1,1,3},{26064,1,1,3},{26065,1,1,2},{26066,1,1,2},{26067,1,1,3},{26040,1,1,36},{26041,1,1,45},{26042,1,1,18},{26043,1,1,45},{26044,1,1,36},{26045,1,1,30},{26046,1,1,30},{26047,1,1,36},{26048,1,1,4},{26020,1,1,192},{26021,1,1,240},{26022,1,1,96},{26023,1,1,240},{26024,1,1,192},{26025,1,1,159},{26026,1,1,159},{26027,1,1,192},{26028,1,1,30},{30012,1,1,1200},{24101,1,1,100},{24104,1,1,100},{24107,1,1,100},{24110,1,1,100},{24113,1,1,100},{24116,1,1,100},{21700,1,1,700},{21701,1,1,200}]};
rand_reward(2, 50, Rand) when Rand >= 1 andalso Rand =< 10000 -> {{1,3}, [{32001,1,1,600},{23003,1,1,800},{25022,1,1,30},{23018,1,1,170},{25023,1,1,80},{33051,1,1,300},{32301,1,1,300},{22243,1,1,90},{33053,1,1,140},{33070,1,1,120},{21030,1,1,20},{32522,1,1,500},{21035,1,1,50},{23001,1,1,500},{21020,1,1,700},{21021,1,1,20},{21022,1,1,10},{27001,1,1,800},{27002,1,1,150},{27003,1,1,40},{31003,1,1,80},{26060,1,1,3},{26061,1,1,3},{26062,1,1,1},{26063,1,1,3},{26064,1,1,3},{26065,1,1,2},{26066,1,1,2},{26067,1,1,3},{26040,1,1,36},{26041,1,1,45},{26042,1,1,18},{26043,1,1,45},{26044,1,1,36},{26045,1,1,30},{26046,1,1,30},{26047,1,1,36},{26048,1,1,4},{26020,1,1,192},{26021,1,1,240},{26022,1,1,96},{26023,1,1,240},{26024,1,1,192},{26025,1,1,159},{26026,1,1,159},{26027,1,1,192},{26028,1,1,30},{30012,1,1,1200},{24101,1,1,100},{24104,1,1,100},{24107,1,1,100},{24110,1,1,100},{24113,1,1,100},{24116,1,1,100},{21700,1,1,700},{21701,1,1,200}]};
rand_reward(3, 1, Rand) when Rand >= 1 andalso Rand =< 500 -> {{1,1}, [{22243,1,1,200},{33051,1,1,150},{25022,1,1,10},{33109,1,1,630},{32001,1,1,200},{33085,1,1,200},{23019,1,1,200},{23003,1,1,450},{32203,1,1,400},{32301,1,1,400},{32522,1,1,400},{23001,1,1,450},{21020,1,1,450},{33108,1,1,200},{33101,1,1,450},{33088,1,1,400},{30010,1,1,600},{26020,1,1,128},{26021,1,1,160},{26022,1,1,64},{26023,1,1,160},{26024,1,1,128},{26025,1,1,106},{26026,1,1,106},{26027,1,1,128},{26028,1,1,20},{23000,1,1,120},{31001,1,1,150},{27000,1,1,170},{33114,1,1,400},{27505,1,1,400},{27507,1,1,80}]};
rand_reward(3, 10, Rand) when Rand >= 1 andalso Rand =< 5000 -> {{1,1}, [{22243,1,1,200},{33051,1,1,150},{25022,1,1,10},{33109,1,1,630},{32001,1,1,200},{33085,1,1,200},{23019,1,1,200},{23003,1,1,450},{32203,1,1,400},{32301,1,1,400},{32522,1,1,400},{23001,1,1,450},{21020,1,1,450},{33108,1,1,200},{33101,1,1,450},{33088,1,1,400},{30010,1,1,600},{26020,1,1,128},{26021,1,1,160},{26022,1,1,64},{26023,1,1,160},{26024,1,1,128},{26025,1,1,106},{26026,1,1,106},{26027,1,1,128},{26028,1,1,20},{23000,1,1,120},{31001,1,1,150},{27000,1,1,170},{33114,1,1,400},{27505,1,1,400},{27507,1,1,80}]};
rand_reward(3, 50, Rand) when Rand >= 1 andalso Rand =< 10000 -> {{1,3}, [{22243,1,1,200},{33051,1,1,150},{25022,1,1,10},{33109,1,1,630},{32001,1,1,200},{33085,1,1,200},{23019,1,1,200},{23003,1,1,450},{32203,1,1,400},{32301,1,1,400},{32522,1,1,400},{23001,1,1,450},{21020,1,1,450},{33108,1,1,200},{33101,1,1,450},{33088,1,1,400},{30010,1,1,600},{26020,1,1,128},{26021,1,1,160},{26022,1,1,64},{26023,1,1,160},{26024,1,1,128},{26025,1,1,106},{26026,1,1,106},{26027,1,1,128},{26028,1,1,20},{23000,1,1,120},{31001,1,1,150},{27000,1,1,170},{33114,1,1,400},{27505,1,1,400},{27507,1,1,80}]};
rand_reward(4, 1, Rand) when Rand >= 1 andalso Rand =< 500 -> {{1,1}, [{22243,1,1,200},{33051,1,1,150},{25022,1,1,10},{33109,1,1,500},{32001,1,1,200},{33085,1,1,200},{23019,1,1,200},{23003,1,1,810},{32203,1,1,700},{32301,1,1,300},{32522,1,1,500},{23001,1,1,600},{21020,1,1,500},{33108,1,1,200},{33101,1,1,700},{33088,1,1,400},{30010,1,1,600},{26020,1,1,128},{26021,1,1,160},{26022,1,1,64},{26023,1,1,160},{26024,1,1,128},{26025,1,1,106},{26026,1,1,106},{26027,1,1,128},{26028,1,1,20},{26009,1,1,60},{26010,1,1,60},{26011,1,1,120},{26012,1,1,120},{26013,1,1,120},{26014,1,1,120},{23000,1,1,500},{31001,1,1,200},{27000,1,1,600}]};
rand_reward(4, 10, Rand) when Rand >= 1 andalso Rand =< 5000 -> {{1,1}, [{22243,1,1,200},{33051,1,1,150},{25022,1,1,10},{33109,1,1,500},{32001,1,1,200},{33085,1,1,200},{23019,1,1,200},{23003,1,1,810},{32203,1,1,700},{32301,1,1,300},{32522,1,1,500},{23001,1,1,600},{21020,1,1,500},{33108,1,1,200},{33101,1,1,700},{33088,1,1,400},{30010,1,1,600},{26020,1,1,128},{26021,1,1,160},{26022,1,1,64},{26023,1,1,160},{26024,1,1,128},{26025,1,1,106},{26026,1,1,106},{26027,1,1,128},{26028,1,1,20},{26009,1,1,60},{26010,1,1,60},{26011,1,1,120},{26012,1,1,120},{26013,1,1,120},{26014,1,1,120},{23000,1,1,500},{31001,1,1,200},{27000,1,1,600}]};
rand_reward(4, 50, Rand) when Rand >= 1 andalso Rand =< 10000 -> {{1,3}, [{22243,1,1,200},{33051,1,1,150},{25022,1,1,10},{33109,1,1,500},{32001,1,1,200},{33085,1,1,200},{23019,1,1,200},{23003,1,1,810},{32203,1,1,700},{32301,1,1,300},{32522,1,1,500},{23001,1,1,600},{21020,1,1,500},{33108,1,1,200},{33101,1,1,700},{33088,1,1,400},{30010,1,1,600},{26020,1,1,128},{26021,1,1,160},{26022,1,1,64},{26023,1,1,160},{26024,1,1,128},{26025,1,1,106},{26026,1,1,106},{26027,1,1,128},{26028,1,1,20},{26009,1,1,60},{26010,1,1,60},{26011,1,1,120},{26012,1,1,120},{26013,1,1,120},{26014,1,1,120},{23000,1,1,500},{31001,1,1,200},{27000,1,1,600}]};
rand_reward(0, 1, Rand) when Rand >= 1 andalso Rand =< 500 -> {{1,1}, [{27001,1,1,1100},{30023,1,1,7120},{33033,1,1,500},{30102,1,1,40},{30103,1,1,40},{30104,1,1,40},{30105,1,1,40},{30106,1,1,40},{23002,1,1,500},{21020,1,1,300},{25021,1,1,80},{25022,1,1,45},{33051,1,1,75},{32300,1,1,80}]};
rand_reward(0, 10, Rand) when Rand >= 1 andalso Rand =< 5000 -> {{1,1}, [{27001,1,1,1100},{30023,1,1,7120},{33033,1,1,500},{30102,1,1,40},{30103,1,1,40},{30104,1,1,40},{30105,1,1,40},{30106,1,1,40},{23002,1,1,500},{21020,1,1,300},{25021,1,1,80},{25022,1,1,45},{33051,1,1,75},{32300,1,1,81}]};
rand_reward(0, 50, Rand) when Rand >= 1 andalso Rand =< 10000 -> {{1,3}, [{27001,1,1,1100},{30023,1,1,7120},{33033,1,1,500},{30102,1,1,40},{30103,1,1,40},{30104,1,1,40},{30105,1,1,40},{30106,1,1,40},{23002,1,1,500},{21020,1,1,300},{25021,1,1,80},{25022,1,1,45},{33051,1,1,75},{32300,1,1,82}]};
rand_reward(_Type, _Num, _Rand) -> false.
