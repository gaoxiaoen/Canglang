%%----------------------------------------------------
%% 宠物数据
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(pet_data).
-export([
        list/0
        ,get_from_npc/1
        ,get/1
        ,get_grow/1
        ,baseid_type/1
        ,get_next_baseid/2
        ,get_open_free_egg_info/0
    ]
).

-include("pet.hrl").


%% 宠物基础数据列表(宠物蛋刷新使用)
list() ->
    [124000,124001,124002,124003,124004,124005,124006,124007,124008,124009,124010,124011,124012,124013,124014,124015,124016,124017,124018,124019].

%% 宠物列表
get_from_npc(124000) ->
    {ok, #pet_base{
            npc_id = 124000
            ,id = 124000
            ,name = <<"愤怒的小鸟">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124001) ->
    {ok, #pet_base{
            npc_id = 124001
            ,id = 124001
            ,name = <<"小悟空">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124002) ->
    {ok, #pet_base{
            npc_id = 124002
            ,id = 124002
            ,name = <<"咕噜熊">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124003) ->
    {ok, #pet_base{
            npc_id = 124003
            ,id = 124003
            ,name = <<"小飞龙">>
            ,refresh = 99
            ,skills = [{110101, 0},{111101, 0}]
        }
    };

get_from_npc(124004) ->
    {ok, #pet_base{
            npc_id = 124004
            ,id = 124004
            ,name = <<"南瓜仔">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124005) ->
    {ok, #pet_base{
            npc_id = 124005
            ,id = 124005
            ,name = <<"小豆丁">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124006) ->
    {ok, #pet_base{
            npc_id = 124006
            ,id = 124006
            ,name = <<"松鼠蜜蜜">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(124007) ->
    {ok, #pet_base{
            npc_id = 124007
            ,id = 124007
            ,name = <<"鼠白白">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(124008) ->
    {ok, #pet_base{
            npc_id = 124008
            ,id = 124008
            ,name = <<"小熊猫">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124009) ->
    {ok, #pet_base{
            npc_id = 124009
            ,id = 124009
            ,name = <<"流浪的狗">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124010) ->
    {ok, #pet_base{
            npc_id = 124010
            ,id = 124010
            ,name = <<"桃色猪">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124011) ->
    {ok, #pet_base{
            npc_id = 124011
            ,id = 124011
            ,name = <<"蓝美人鱼">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124012) ->
    {ok, #pet_base{
            npc_id = 124012
            ,id = 124012
            ,name = <<"粉红美人鱼">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124013) ->
    {ok, #pet_base{
            npc_id = 124013
            ,id = 124013
            ,name = <<"仙狐">>
            ,refresh = 1
            ,skills = []
        }
    };

get_from_npc(124014) ->
    {ok, #pet_base{
            npc_id = 124014
            ,id = 124014
            ,name = <<"小白虎">>
            ,refresh = 2
            ,skills = []
        }
    };

get_from_npc(124015) ->
    {ok, #pet_base{
            npc_id = 124015
            ,id = 124015
            ,name = <<"小恶魔">>
            ,refresh = 2
            ,skills = []
        }
    };

get_from_npc(124016) ->
    {ok, #pet_base{
            npc_id = 124016
            ,id = 124016
            ,name = <<"神龟">>
            ,refresh = 2
            ,skills = []
        }
    };

get_from_npc(124017) ->
    {ok, #pet_base{
            npc_id = 124017
            ,id = 124017
            ,name = <<"小鱼儿">>
            ,refresh = 2
            ,skills = []
        }
    };

get_from_npc(124018) ->
    {ok, #pet_base{
            npc_id = 124018
            ,id = 124018
            ,name = <<"蝴蝶仙子">>
            ,refresh = 2
            ,skills = []
        }
    };

get_from_npc(124019) ->
    {ok, #pet_base{
            npc_id = 124019
            ,id = 124019
            ,name = <<"狐小妞">>
            ,refresh = 2
            ,skills = []
        }
    };

get_from_npc(124025) ->
    {ok, #pet_base{
            npc_id = 124025
            ,id = 124008
            ,name = <<"小熊猫宝宝">>
            ,refresh = 1
            ,skills = [{110101, 2},{111101, 2}]
        }
    };

get_from_npc(124040) ->
    {ok, #pet_base{
            npc_id = 124040
            ,id = 124040
            ,name = <<"蓝免精灵">>
            ,refresh = 1
            ,skills = [{110101, 0},{111101, 0}]
        }
    };

get_from_npc(20601) ->
    {ok, #pet_base{
            npc_id = 20601
            ,id = 29433
            ,name = <<"倭寇-宝箱">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(20602) ->
    {ok, #pet_base{
            npc_id = 20602
            ,id = 29434
            ,name = <<"倭寇-金晶钻">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(20603) ->
    {ok, #pet_base{
            npc_id = 20603
            ,id = 29435
            ,name = <<"倭寇-银晶钻">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(20604) ->
    {ok, #pet_base{
            npc_id = 20604
            ,id = 29436
            ,name = <<"倭寇-金币">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(20670) ->
    {ok, #pet_base{
            npc_id = 20670
            ,id = 20670
            ,name = <<"愤怒的鸟叔">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(20671) ->
    {ok, #pet_base{
            npc_id = 20671
            ,id = 20671
            ,name = <<"饥饿的熊猫">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(20672) ->
    {ok, #pet_base{
            npc_id = 20672
            ,id = 20672
            ,name = <<"斑点狗">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(20673) ->
    {ok, #pet_base{
            npc_id = 20673
            ,id = 20673
            ,name = <<"鼠萌萌">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(20674) ->
    {ok, #pet_base{
            npc_id = 20674
            ,id = 20674
            ,name = <<"猪坚强">>
            ,refresh = 0
            ,skills = []
        }
    };

get_from_npc(_) ->
    {false, <<"无相关宠物基础数据">>}.

get(124000) ->
    {ok, #pet_base{
            id = 124000
            ,name = <<"愤怒的小鸟">>
        }
    };

get(124001) ->
    {ok, #pet_base{
            id = 124001
            ,name = <<"小悟空">>
        }
    };

get(124002) ->
    {ok, #pet_base{
            id = 124002
            ,name = <<"咕噜熊">>
        }
    };

get(124003) ->
    {ok, #pet_base{
            id = 124003
            ,name = <<"小飞龙">>
        }
    };

get(124004) ->
    {ok, #pet_base{
            id = 124004
            ,name = <<"南瓜仔">>
        }
    };

get(124005) ->
    {ok, #pet_base{
            id = 124005
            ,name = <<"小豆丁">>
        }
    };

get(124006) ->
    {ok, #pet_base{
            id = 124006
            ,name = <<"松鼠蜜蜜">>
        }
    };

get(124007) ->
    {ok, #pet_base{
            id = 124007
            ,name = <<"鼠白白">>
        }
    };

get(124008) ->
    {ok, #pet_base{
            id = 124008
            ,name = <<"小熊猫">>
        }
    };

get(124009) ->
    {ok, #pet_base{
            id = 124009
            ,name = <<"流浪的狗">>
        }
    };

get(124010) ->
    {ok, #pet_base{
            id = 124010
            ,name = <<"桃色猪">>
        }
    };

get(124011) ->
    {ok, #pet_base{
            id = 124011
            ,name = <<"蓝美人鱼">>
        }
    };

get(124012) ->
    {ok, #pet_base{
            id = 124012
            ,name = <<"粉红美人鱼">>
        }
    };

get(124013) ->
    {ok, #pet_base{
            id = 124013
            ,name = <<"仙狐">>
        }
    };

get(124014) ->
    {ok, #pet_base{
            id = 124014
            ,name = <<"小白虎">>
        }
    };

get(124015) ->
    {ok, #pet_base{
            id = 124015
            ,name = <<"小恶魔">>
        }
    };

get(124016) ->
    {ok, #pet_base{
            id = 124016
            ,name = <<"神龟">>
        }
    };

get(124017) ->
    {ok, #pet_base{
            id = 124017
            ,name = <<"小鱼儿">>
        }
    };

get(124018) ->
    {ok, #pet_base{
            id = 124018
            ,name = <<"蝴蝶仙子">>
        }
    };

get(124019) ->
    {ok, #pet_base{
            id = 124019
            ,name = <<"狐小妞">>
        }
    };

get(_) ->
    {false, <<"无相关宠物基础数据">>}.

%% 获取宠物成长基础数据
get_grow(0) ->
    #pet_grow_base{
        lev = 0
        ,base_suc = 1000
        ,max_wish = 1000
        ,min_wish = 0
        ,attr_val = 0
        ,cli_base_suc = 100
        ,cli_max_wish = 600
    };

get_grow(1) ->
    #pet_grow_base{
        lev = 1
        ,base_suc = 950
        ,max_wish = 1000
        ,min_wish = 0
        ,attr_val = 4
        ,cli_base_suc = 95
        ,cli_max_wish = 600
    };

get_grow(2) ->
    #pet_grow_base{
        lev = 2
        ,base_suc = 900
        ,max_wish = 1000
        ,min_wish = 0
        ,attr_val = 8
        ,cli_base_suc = 90
        ,cli_max_wish = 600
    };

get_grow(3) ->
    #pet_grow_base{
        lev = 3
        ,base_suc = 850
        ,max_wish = 1000
        ,min_wish = 0
        ,attr_val = 12
        ,cli_base_suc = 85
        ,cli_max_wish = 600
    };

get_grow(4) ->
    #pet_grow_base{
        lev = 4
        ,base_suc = 800
        ,max_wish = 1000
        ,min_wish = 0
        ,attr_val = 16
        ,cli_base_suc = 80
        ,cli_max_wish = 600
    };

get_grow(5) ->
    #pet_grow_base{
        lev = 5
        ,base_suc = 750
        ,max_wish = 1000
        ,min_wish = 0
        ,attr_val = 20
        ,cli_base_suc = 75
        ,cli_max_wish = 600
    };

get_grow(6) ->
    #pet_grow_base{
        lev = 6
        ,base_suc = 700
        ,max_wish = 1000
        ,min_wish = 0
        ,attr_val = 24
        ,cli_base_suc = 70
        ,cli_max_wish = 600
    };

get_grow(7) ->
    #pet_grow_base{
        lev = 7
        ,base_suc = 650
        ,max_wish = 1000
        ,min_wish = 0
        ,attr_val = 28
        ,cli_base_suc = 65
        ,cli_max_wish = 600
    };

get_grow(8) ->
    #pet_grow_base{
        lev = 8
        ,base_suc = 600
        ,max_wish = 1000
        ,min_wish = 0
        ,attr_val = 32
        ,cli_base_suc = 60
        ,cli_max_wish = 600
    };

get_grow(9) ->
    #pet_grow_base{
        lev = 9
        ,base_suc = 550
        ,max_wish = 1000
        ,min_wish = 0
        ,attr_val = 36
        ,cli_base_suc = 55
        ,cli_max_wish = 600
    };

get_grow(10) ->
    #pet_grow_base{
        lev = 10
        ,base_suc = 500
        ,max_wish = 1000
        ,min_wish = 25
        ,attr_val = 50
        ,cli_base_suc = 50
        ,cli_max_wish = 600
    };

get_grow(11) ->
    #pet_grow_base{
        lev = 11
        ,base_suc = 480
        ,max_wish = 1000
        ,min_wish = 26
        ,attr_val = 54
        ,cli_base_suc = 48
        ,cli_max_wish = 600
    };

get_grow(12) ->
    #pet_grow_base{
        lev = 12
        ,base_suc = 460
        ,max_wish = 1000
        ,min_wish = 27
        ,attr_val = 58
        ,cli_base_suc = 46
        ,cli_max_wish = 600
    };

get_grow(13) ->
    #pet_grow_base{
        lev = 13
        ,base_suc = 440
        ,max_wish = 1000
        ,min_wish = 28
        ,attr_val = 62
        ,cli_base_suc = 44
        ,cli_max_wish = 600
    };

get_grow(14) ->
    #pet_grow_base{
        lev = 14
        ,base_suc = 420
        ,max_wish = 1000
        ,min_wish = 29
        ,attr_val = 66
        ,cli_base_suc = 42
        ,cli_max_wish = 600
    };

get_grow(15) ->
    #pet_grow_base{
        lev = 15
        ,base_suc = 400
        ,max_wish = 1000
        ,min_wish = 30
        ,attr_val = 70
        ,cli_base_suc = 40
        ,cli_max_wish = 600
    };

get_grow(16) ->
    #pet_grow_base{
        lev = 16
        ,base_suc = 380
        ,max_wish = 1000
        ,min_wish = 49.6
        ,attr_val = 74
        ,cli_base_suc = 38
        ,cli_max_wish = 600
    };

get_grow(17) ->
    #pet_grow_base{
        lev = 17
        ,base_suc = 360
        ,max_wish = 1000
        ,min_wish = 64
        ,attr_val = 78
        ,cli_base_suc = 36
        ,cli_max_wish = 600
    };

get_grow(18) ->
    #pet_grow_base{
        lev = 18
        ,base_suc = 340
        ,max_wish = 1000
        ,min_wish = 66
        ,attr_val = 82
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(19) ->
    #pet_grow_base{
        lev = 19
        ,base_suc = 320
        ,max_wish = 1000
        ,min_wish = 68
        ,attr_val = 86
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(20) ->
    #pet_grow_base{
        lev = 20
        ,base_suc = 300
        ,max_wish = 1000
        ,min_wish = 70
        ,attr_val = 100
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(21) ->
    #pet_grow_base{
        lev = 21
        ,base_suc = 290
        ,max_wish = 1000
        ,min_wish = 71
        ,attr_val = 104
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(22) ->
    #pet_grow_base{
        lev = 22
        ,base_suc = 280
        ,max_wish = 1000
        ,min_wish = 72
        ,attr_val = 108
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(23) ->
    #pet_grow_base{
        lev = 23
        ,base_suc = 270
        ,max_wish = 1000
        ,min_wish = 73
        ,attr_val = 112
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(24) ->
    #pet_grow_base{
        lev = 24
        ,base_suc = 260
        ,max_wish = 1000
        ,min_wish = 74
        ,attr_val = 116
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(25) ->
    #pet_grow_base{
        lev = 25
        ,base_suc = 250
        ,max_wish = 1000
        ,min_wish = 75
        ,attr_val = 120
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(26) ->
    #pet_grow_base{
        lev = 26
        ,base_suc = 240
        ,max_wish = 1000
        ,min_wish = 76
        ,attr_val = 124
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(27) ->
    #pet_grow_base{
        lev = 27
        ,base_suc = 230
        ,max_wish = 1000
        ,min_wish = 77
        ,attr_val = 128
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(28) ->
    #pet_grow_base{
        lev = 28
        ,base_suc = 220
        ,max_wish = 1000
        ,min_wish = 78
        ,attr_val = 132
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(29) ->
    #pet_grow_base{
        lev = 29
        ,base_suc = 210
        ,max_wish = 1000
        ,min_wish = 79
        ,attr_val = 136
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(30) ->
    #pet_grow_base{
        lev = 30
        ,base_suc = 200
        ,max_wish = 1000
        ,min_wish = 80
        ,attr_val = 150
        ,cli_base_suc = 35
        ,cli_max_wish = 600
    };

get_grow(31) ->
    #pet_grow_base{
        lev = 31
        ,base_suc = 190
        ,max_wish = 1000
        ,min_wish = 110
        ,attr_val = 154
        ,cli_base_suc = 30
        ,cli_max_wish = 600
    };

get_grow(32) ->
    #pet_grow_base{
        lev = 32
        ,base_suc = 180
        ,max_wish = 1000
        ,min_wish = 110
        ,attr_val = 158
        ,cli_base_suc = 30
        ,cli_max_wish = 600
    };

get_grow(33) ->
    #pet_grow_base{
        lev = 33
        ,base_suc = 170
        ,max_wish = 1000
        ,min_wish = 110
        ,attr_val = 162
        ,cli_base_suc = 30
        ,cli_max_wish = 600
    };

get_grow(34) ->
    #pet_grow_base{
        lev = 34
        ,base_suc = 160
        ,max_wish = 1000
        ,min_wish = 110
        ,attr_val = 166
        ,cli_base_suc = 30
        ,cli_max_wish = 600
    };

get_grow(35) ->
    #pet_grow_base{
        lev = 35
        ,base_suc = 150
        ,max_wish = 1000
        ,min_wish = 110
        ,attr_val = 170
        ,cli_base_suc = 30
        ,cli_max_wish = 600
    };

get_grow(36) ->
    #pet_grow_base{
        lev = 36
        ,base_suc = 140
        ,max_wish = 1000
        ,min_wish = 110
        ,attr_val = 174
        ,cli_base_suc = 30
        ,cli_max_wish = 600
    };

get_grow(37) ->
    #pet_grow_base{
        lev = 37
        ,base_suc = 130
        ,max_wish = 1000
        ,min_wish = 120
        ,attr_val = 178
        ,cli_base_suc = 30
        ,cli_max_wish = 600
    };

get_grow(38) ->
    #pet_grow_base{
        lev = 38
        ,base_suc = 120
        ,max_wish = 1000
        ,min_wish = 120
        ,attr_val = 182
        ,cli_base_suc = 30
        ,cli_max_wish = 600
    };

get_grow(39) ->
    #pet_grow_base{
        lev = 39
        ,base_suc = 110
        ,max_wish = 1000
        ,min_wish = 120
        ,attr_val = 186
        ,cli_base_suc = 30
        ,cli_max_wish = 600
    };

get_grow(40) ->
    #pet_grow_base{
        lev = 40
        ,base_suc = 100
        ,max_wish = 1000
        ,min_wish = 120
        ,attr_val = 190
        ,cli_base_suc = 30
        ,cli_max_wish = 600
    };

get_grow(41) ->
    #pet_grow_base{
        lev = 41
        ,base_suc = 100
        ,max_wish = 1000
        ,min_wish = 120
        ,attr_val = 194
        ,cli_base_suc = 25
        ,cli_max_wish = 600
    };

get_grow(42) ->
    #pet_grow_base{
        lev = 42
        ,base_suc = 100
        ,max_wish = 1000
        ,min_wish = 120
        ,attr_val = 198
        ,cli_base_suc = 25
        ,cli_max_wish = 600
    };

get_grow(43) ->
    #pet_grow_base{
        lev = 43
        ,base_suc = 100
        ,max_wish = 1000
        ,min_wish = 120
        ,attr_val = 202
        ,cli_base_suc = 25
        ,cli_max_wish = 600
    };

get_grow(44) ->
    #pet_grow_base{
        lev = 44
        ,base_suc = 100
        ,max_wish = 1000
        ,min_wish = 120
        ,attr_val = 206
        ,cli_base_suc = 25
        ,cli_max_wish = 600
    };

get_grow(45) ->
    #pet_grow_base{
        lev = 45
        ,base_suc = 100
        ,max_wish = 1000
        ,min_wish = 120
        ,attr_val = 210
        ,cli_base_suc = 25
        ,cli_max_wish = 600
    };

get_grow(46) ->
    #pet_grow_base{
        lev = 46
        ,base_suc = 100
        ,max_wish = 1000
        ,min_wish = 135
        ,attr_val = 214
        ,cli_base_suc = 25
        ,cli_max_wish = 600
    };

get_grow(47) ->
    #pet_grow_base{
        lev = 47
        ,base_suc = 100
        ,max_wish = 1000
        ,min_wish = 135
        ,attr_val = 218
        ,cli_base_suc = 25
        ,cli_max_wish = 600
    };

get_grow(48) ->
    #pet_grow_base{
        lev = 48
        ,base_suc = 100
        ,max_wish = 1000
        ,min_wish = 135
        ,attr_val = 222
        ,cli_base_suc = 25
        ,cli_max_wish = 600
    };

get_grow(49) ->
    #pet_grow_base{
        lev = 49
        ,base_suc = 100
        ,max_wish = 1000
        ,min_wish = 135
        ,attr_val = 226
        ,cli_base_suc = 25
        ,cli_max_wish = 600
    };

get_grow(50) ->
    #pet_grow_base{
        lev = 50
        ,base_suc = 90
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 250
        ,cli_base_suc = 25
        ,cli_max_wish = 600
    };

get_grow(51) ->
    #pet_grow_base{
        lev = 51
        ,base_suc = 90
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 254
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(52) ->
    #pet_grow_base{
        lev = 52
        ,base_suc = 90
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 258
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(53) ->
    #pet_grow_base{
        lev = 53
        ,base_suc = 90
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 262
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(54) ->
    #pet_grow_base{
        lev = 54
        ,base_suc = 90
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 266
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(55) ->
    #pet_grow_base{
        lev = 55
        ,base_suc = 90
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 270
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(56) ->
    #pet_grow_base{
        lev = 56
        ,base_suc = 90
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 274
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(57) ->
    #pet_grow_base{
        lev = 57
        ,base_suc = 90
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 278
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(58) ->
    #pet_grow_base{
        lev = 58
        ,base_suc = 90
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 282
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(59) ->
    #pet_grow_base{
        lev = 59
        ,base_suc = 90
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 286
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(60) ->
    #pet_grow_base{
        lev = 60
        ,base_suc = 80
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 320
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(61) ->
    #pet_grow_base{
        lev = 61
        ,base_suc = 80
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 324
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(62) ->
    #pet_grow_base{
        lev = 62
        ,base_suc = 80
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 328
        ,cli_base_suc = 20
        ,cli_max_wish = 600
    };

get_grow(63) ->
    #pet_grow_base{
        lev = 63
        ,base_suc = 80
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 332
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(64) ->
    #pet_grow_base{
        lev = 64
        ,base_suc = 80
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 336
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(65) ->
    #pet_grow_base{
        lev = 65
        ,base_suc = 80
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 340
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(66) ->
    #pet_grow_base{
        lev = 66
        ,base_suc = 80
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 344
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(67) ->
    #pet_grow_base{
        lev = 67
        ,base_suc = 80
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 348
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(68) ->
    #pet_grow_base{
        lev = 68
        ,base_suc = 80
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 352
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(69) ->
    #pet_grow_base{
        lev = 69
        ,base_suc = 80
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 356
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(70) ->
    #pet_grow_base{
        lev = 70
        ,base_suc = 70
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 360
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(71) ->
    #pet_grow_base{
        lev = 71
        ,base_suc = 70
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 364
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(72) ->
    #pet_grow_base{
        lev = 72
        ,base_suc = 70
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 368
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(73) ->
    #pet_grow_base{
        lev = 73
        ,base_suc = 70
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 372
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(74) ->
    #pet_grow_base{
        lev = 74
        ,base_suc = 70
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 376
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(75) ->
    #pet_grow_base{
        lev = 75
        ,base_suc = 70
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 380
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(76) ->
    #pet_grow_base{
        lev = 76
        ,base_suc = 70
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 384
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(77) ->
    #pet_grow_base{
        lev = 77
        ,base_suc = 70
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 388
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(78) ->
    #pet_grow_base{
        lev = 78
        ,base_suc = 70
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 392
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(79) ->
    #pet_grow_base{
        lev = 79
        ,base_suc = 70
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 396
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(80) ->
    #pet_grow_base{
        lev = 80
        ,base_suc = 60
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 420
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(81) ->
    #pet_grow_base{
        lev = 81
        ,base_suc = 60
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 424
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(82) ->
    #pet_grow_base{
        lev = 82
        ,base_suc = 60
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 428
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(83) ->
    #pet_grow_base{
        lev = 83
        ,base_suc = 60
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 432
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(84) ->
    #pet_grow_base{
        lev = 84
        ,base_suc = 60
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 436
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(85) ->
    #pet_grow_base{
        lev = 85
        ,base_suc = 60
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 440
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(86) ->
    #pet_grow_base{
        lev = 86
        ,base_suc = 60
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 444
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(87) ->
    #pet_grow_base{
        lev = 87
        ,base_suc = 60
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 448
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(88) ->
    #pet_grow_base{
        lev = 88
        ,base_suc = 60
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 452
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(89) ->
    #pet_grow_base{
        lev = 89
        ,base_suc = 60
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 456
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(90) ->
    #pet_grow_base{
        lev = 90
        ,base_suc = 50
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 460
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(91) ->
    #pet_grow_base{
        lev = 91
        ,base_suc = 50
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 464
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(92) ->
    #pet_grow_base{
        lev = 92
        ,base_suc = 50
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 468
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(93) ->
    #pet_grow_base{
        lev = 93
        ,base_suc = 50
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 472
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(94) ->
    #pet_grow_base{
        lev = 94
        ,base_suc = 50
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 476
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(95) ->
    #pet_grow_base{
        lev = 95
        ,base_suc = 50
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 480
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(96) ->
    #pet_grow_base{
        lev = 96
        ,base_suc = 50
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 484
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(97) ->
    #pet_grow_base{
        lev = 97
        ,base_suc = 50
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 488
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(98) ->
    #pet_grow_base{
        lev = 98
        ,base_suc = 50
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 492
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(99) ->
    #pet_grow_base{
        lev = 99
        ,base_suc = 50
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 496
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(100) ->
    #pet_grow_base{
        lev = 100
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 530
        ,cli_base_suc = 15
        ,cli_max_wish = 600
    };

get_grow(101) ->
    #pet_grow_base{
        lev = 101
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 534
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(102) ->
    #pet_grow_base{
        lev = 102
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 538
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(103) ->
    #pet_grow_base{
        lev = 103
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 542
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(104) ->
    #pet_grow_base{
        lev = 104
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 546
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(105) ->
    #pet_grow_base{
        lev = 105
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 550
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(106) ->
    #pet_grow_base{
        lev = 106
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 554
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(107) ->
    #pet_grow_base{
        lev = 107
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 558
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(108) ->
    #pet_grow_base{
        lev = 108
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 562
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(109) ->
    #pet_grow_base{
        lev = 109
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 566
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(110) ->
    #pet_grow_base{
        lev = 110
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 570
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(111) ->
    #pet_grow_base{
        lev = 111
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 574
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(112) ->
    #pet_grow_base{
        lev = 112
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 578
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(113) ->
    #pet_grow_base{
        lev = 113
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 582
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(114) ->
    #pet_grow_base{
        lev = 114
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 586
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(115) ->
    #pet_grow_base{
        lev = 115
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 590
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(116) ->
    #pet_grow_base{
        lev = 116
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 594
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(117) ->
    #pet_grow_base{
        lev = 117
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 598
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(118) ->
    #pet_grow_base{
        lev = 118
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 602
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(119) ->
    #pet_grow_base{
        lev = 119
        ,base_suc = 40
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 606
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(120) ->
    #pet_grow_base{
        lev = 120
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 610
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(121) ->
    #pet_grow_base{
        lev = 121
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 614
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(122) ->
    #pet_grow_base{
        lev = 122
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 618
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(123) ->
    #pet_grow_base{
        lev = 123
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 622
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(124) ->
    #pet_grow_base{
        lev = 124
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 626
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(125) ->
    #pet_grow_base{
        lev = 125
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 630
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(126) ->
    #pet_grow_base{
        lev = 126
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 634
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(127) ->
    #pet_grow_base{
        lev = 127
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 638
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(128) ->
    #pet_grow_base{
        lev = 128
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 642
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(129) ->
    #pet_grow_base{
        lev = 129
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 646
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(130) ->
    #pet_grow_base{
        lev = 130
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 680
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(131) ->
    #pet_grow_base{
        lev = 131
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 684
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(132) ->
    #pet_grow_base{
        lev = 132
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 688
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(133) ->
    #pet_grow_base{
        lev = 133
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 692
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(134) ->
    #pet_grow_base{
        lev = 134
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 696
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(135) ->
    #pet_grow_base{
        lev = 135
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 700
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(136) ->
    #pet_grow_base{
        lev = 136
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 704
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(137) ->
    #pet_grow_base{
        lev = 137
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 708
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(138) ->
    #pet_grow_base{
        lev = 138
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 712
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(139) ->
    #pet_grow_base{
        lev = 139
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 716
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(140) ->
    #pet_grow_base{
        lev = 140
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 720
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(141) ->
    #pet_grow_base{
        lev = 141
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 724
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(142) ->
    #pet_grow_base{
        lev = 142
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 728
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(143) ->
    #pet_grow_base{
        lev = 143
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 732
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(144) ->
    #pet_grow_base{
        lev = 144
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 736
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(145) ->
    #pet_grow_base{
        lev = 145
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 740
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(146) ->
    #pet_grow_base{
        lev = 146
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 744
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(147) ->
    #pet_grow_base{
        lev = 147
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 748
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(148) ->
    #pet_grow_base{
        lev = 148
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 752
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(149) ->
    #pet_grow_base{
        lev = 149
        ,base_suc = 30
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 756
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(150) ->
    #pet_grow_base{
        lev = 150
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 790
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(151) ->
    #pet_grow_base{
        lev = 151
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 794
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(152) ->
    #pet_grow_base{
        lev = 152
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 798
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(153) ->
    #pet_grow_base{
        lev = 153
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 802
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(154) ->
    #pet_grow_base{
        lev = 154
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 806
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(155) ->
    #pet_grow_base{
        lev = 155
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 810
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(156) ->
    #pet_grow_base{
        lev = 156
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 814
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(157) ->
    #pet_grow_base{
        lev = 157
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 818
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(158) ->
    #pet_grow_base{
        lev = 158
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 822
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(159) ->
    #pet_grow_base{
        lev = 159
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 826
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(160) ->
    #pet_grow_base{
        lev = 160
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 830
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(161) ->
    #pet_grow_base{
        lev = 161
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 834
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(162) ->
    #pet_grow_base{
        lev = 162
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 838
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(163) ->
    #pet_grow_base{
        lev = 163
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 842
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(164) ->
    #pet_grow_base{
        lev = 164
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 846
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(165) ->
    #pet_grow_base{
        lev = 165
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 850
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(166) ->
    #pet_grow_base{
        lev = 166
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 854
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(167) ->
    #pet_grow_base{
        lev = 167
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 858
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(168) ->
    #pet_grow_base{
        lev = 168
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 862
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(169) ->
    #pet_grow_base{
        lev = 169
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 866
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(170) ->
    #pet_grow_base{
        lev = 170
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 870
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(171) ->
    #pet_grow_base{
        lev = 171
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 874
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(172) ->
    #pet_grow_base{
        lev = 172
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 878
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(173) ->
    #pet_grow_base{
        lev = 173
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 882
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(174) ->
    #pet_grow_base{
        lev = 174
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 886
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(175) ->
    #pet_grow_base{
        lev = 175
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 890
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(176) ->
    #pet_grow_base{
        lev = 176
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 894
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(177) ->
    #pet_grow_base{
        lev = 177
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 898
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(178) ->
    #pet_grow_base{
        lev = 178
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 902
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(179) ->
    #pet_grow_base{
        lev = 179
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 906
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(180) ->
    #pet_grow_base{
        lev = 180
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 940
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(181) ->
    #pet_grow_base{
        lev = 181
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 944
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(182) ->
    #pet_grow_base{
        lev = 182
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 948
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(183) ->
    #pet_grow_base{
        lev = 183
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 952
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(184) ->
    #pet_grow_base{
        lev = 184
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 956
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(185) ->
    #pet_grow_base{
        lev = 185
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 960
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(186) ->
    #pet_grow_base{
        lev = 186
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 964
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(187) ->
    #pet_grow_base{
        lev = 187
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 968
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(188) ->
    #pet_grow_base{
        lev = 188
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 972
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(189) ->
    #pet_grow_base{
        lev = 189
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 976
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(190) ->
    #pet_grow_base{
        lev = 190
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 980
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(191) ->
    #pet_grow_base{
        lev = 191
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 984
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(192) ->
    #pet_grow_base{
        lev = 192
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 988
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(193) ->
    #pet_grow_base{
        lev = 193
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 992
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(194) ->
    #pet_grow_base{
        lev = 194
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 996
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(195) ->
    #pet_grow_base{
        lev = 195
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 1000
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(196) ->
    #pet_grow_base{
        lev = 196
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 1004
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(197) ->
    #pet_grow_base{
        lev = 197
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 1008
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(198) ->
    #pet_grow_base{
        lev = 198
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 1012
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(199) ->
    #pet_grow_base{
        lev = 199
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 150
        ,attr_val = 1016
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(200) ->
    #pet_grow_base{
        lev = 200
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1060
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(201) ->
    #pet_grow_base{
        lev = 201
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1064
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(202) ->
    #pet_grow_base{
        lev = 202
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1068
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(203) ->
    #pet_grow_base{
        lev = 203
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1072
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(204) ->
    #pet_grow_base{
        lev = 204
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1076
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(205) ->
    #pet_grow_base{
        lev = 205
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1080
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(206) ->
    #pet_grow_base{
        lev = 206
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1084
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(207) ->
    #pet_grow_base{
        lev = 207
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1088
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(208) ->
    #pet_grow_base{
        lev = 208
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1092
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(209) ->
    #pet_grow_base{
        lev = 209
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1096
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(210) ->
    #pet_grow_base{
        lev = 210
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1100
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(211) ->
    #pet_grow_base{
        lev = 211
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1104
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(212) ->
    #pet_grow_base{
        lev = 212
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1108
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(213) ->
    #pet_grow_base{
        lev = 213
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1112
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(214) ->
    #pet_grow_base{
        lev = 214
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1116
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(215) ->
    #pet_grow_base{
        lev = 215
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1120
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(216) ->
    #pet_grow_base{
        lev = 216
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1124
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(217) ->
    #pet_grow_base{
        lev = 217
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1128
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(218) ->
    #pet_grow_base{
        lev = 218
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1132
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(219) ->
    #pet_grow_base{
        lev = 219
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1136
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(220) ->
    #pet_grow_base{
        lev = 220
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1160
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(221) ->
    #pet_grow_base{
        lev = 221
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1164
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(222) ->
    #pet_grow_base{
        lev = 222
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1168
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(223) ->
    #pet_grow_base{
        lev = 223
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1172
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(224) ->
    #pet_grow_base{
        lev = 224
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1176
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(225) ->
    #pet_grow_base{
        lev = 225
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1180
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(226) ->
    #pet_grow_base{
        lev = 226
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1184
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(227) ->
    #pet_grow_base{
        lev = 227
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1188
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(228) ->
    #pet_grow_base{
        lev = 228
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1192
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(229) ->
    #pet_grow_base{
        lev = 229
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1196
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(230) ->
    #pet_grow_base{
        lev = 230
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1200
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(231) ->
    #pet_grow_base{
        lev = 231
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1204
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(232) ->
    #pet_grow_base{
        lev = 232
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1208
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(233) ->
    #pet_grow_base{
        lev = 233
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1212
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(234) ->
    #pet_grow_base{
        lev = 234
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1216
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(235) ->
    #pet_grow_base{
        lev = 235
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1220
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(236) ->
    #pet_grow_base{
        lev = 236
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1224
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(237) ->
    #pet_grow_base{
        lev = 237
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1228
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(238) ->
    #pet_grow_base{
        lev = 238
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1232
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(239) ->
    #pet_grow_base{
        lev = 239
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1236
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(240) ->
    #pet_grow_base{
        lev = 240
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1240
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(241) ->
    #pet_grow_base{
        lev = 241
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1244
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(242) ->
    #pet_grow_base{
        lev = 242
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1248
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(243) ->
    #pet_grow_base{
        lev = 243
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1252
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(244) ->
    #pet_grow_base{
        lev = 244
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1256
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(245) ->
    #pet_grow_base{
        lev = 245
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1260
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(246) ->
    #pet_grow_base{
        lev = 246
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1264
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(247) ->
    #pet_grow_base{
        lev = 247
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1268
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(248) ->
    #pet_grow_base{
        lev = 248
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1272
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(249) ->
    #pet_grow_base{
        lev = 249
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1276
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(250) ->
    #pet_grow_base{
        lev = 250
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1320
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(251) ->
    #pet_grow_base{
        lev = 251
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1324
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(252) ->
    #pet_grow_base{
        lev = 252
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1328
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(253) ->
    #pet_grow_base{
        lev = 253
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1332
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(254) ->
    #pet_grow_base{
        lev = 254
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1336
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(255) ->
    #pet_grow_base{
        lev = 255
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1340
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(256) ->
    #pet_grow_base{
        lev = 256
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1344
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(257) ->
    #pet_grow_base{
        lev = 257
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1348
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(258) ->
    #pet_grow_base{
        lev = 258
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1352
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(259) ->
    #pet_grow_base{
        lev = 259
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1356
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(260) ->
    #pet_grow_base{
        lev = 260
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1360
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(261) ->
    #pet_grow_base{
        lev = 261
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1364
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(262) ->
    #pet_grow_base{
        lev = 262
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1368
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(263) ->
    #pet_grow_base{
        lev = 263
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1372
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(264) ->
    #pet_grow_base{
        lev = 264
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1376
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(265) ->
    #pet_grow_base{
        lev = 265
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1380
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(266) ->
    #pet_grow_base{
        lev = 266
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1384
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(267) ->
    #pet_grow_base{
        lev = 267
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1388
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(268) ->
    #pet_grow_base{
        lev = 268
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1392
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(269) ->
    #pet_grow_base{
        lev = 269
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1396
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(270) ->
    #pet_grow_base{
        lev = 270
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1400
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(271) ->
    #pet_grow_base{
        lev = 271
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1404
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(272) ->
    #pet_grow_base{
        lev = 272
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1408
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(273) ->
    #pet_grow_base{
        lev = 273
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1412
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(274) ->
    #pet_grow_base{
        lev = 274
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1416
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(275) ->
    #pet_grow_base{
        lev = 275
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1420
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(276) ->
    #pet_grow_base{
        lev = 276
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1424
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(277) ->
    #pet_grow_base{
        lev = 277
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1428
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(278) ->
    #pet_grow_base{
        lev = 278
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1432
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(279) ->
    #pet_grow_base{
        lev = 279
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1436
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(280) ->
    #pet_grow_base{
        lev = 280
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1470
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(281) ->
    #pet_grow_base{
        lev = 281
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1474
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(282) ->
    #pet_grow_base{
        lev = 282
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1478
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(283) ->
    #pet_grow_base{
        lev = 283
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1482
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(284) ->
    #pet_grow_base{
        lev = 284
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1486
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(285) ->
    #pet_grow_base{
        lev = 285
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1490
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(286) ->
    #pet_grow_base{
        lev = 286
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1494
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(287) ->
    #pet_grow_base{
        lev = 287
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1498
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(288) ->
    #pet_grow_base{
        lev = 288
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1502
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(289) ->
    #pet_grow_base{
        lev = 289
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1506
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(290) ->
    #pet_grow_base{
        lev = 290
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1510
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(291) ->
    #pet_grow_base{
        lev = 291
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1514
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(292) ->
    #pet_grow_base{
        lev = 292
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1518
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(293) ->
    #pet_grow_base{
        lev = 293
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1522
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(294) ->
    #pet_grow_base{
        lev = 294
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1526
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(295) ->
    #pet_grow_base{
        lev = 295
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1530
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(296) ->
    #pet_grow_base{
        lev = 296
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1534
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(297) ->
    #pet_grow_base{
        lev = 297
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1538
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(298) ->
    #pet_grow_base{
        lev = 298
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1542
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(299) ->
    #pet_grow_base{
        lev = 299
        ,base_suc = 20
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1546
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(300) ->
    #pet_grow_base{
        lev = 300
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1600
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(301) ->
    #pet_grow_base{
        lev = 301
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1604
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(302) ->
    #pet_grow_base{
        lev = 302
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1608
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(303) ->
    #pet_grow_base{
        lev = 303
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1612
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(304) ->
    #pet_grow_base{
        lev = 304
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1616
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(305) ->
    #pet_grow_base{
        lev = 305
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1620
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(306) ->
    #pet_grow_base{
        lev = 306
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1624
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(307) ->
    #pet_grow_base{
        lev = 307
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1628
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(308) ->
    #pet_grow_base{
        lev = 308
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1632
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(309) ->
    #pet_grow_base{
        lev = 309
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1636
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(310) ->
    #pet_grow_base{
        lev = 310
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1640
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(311) ->
    #pet_grow_base{
        lev = 311
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1644
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(312) ->
    #pet_grow_base{
        lev = 312
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1648
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(313) ->
    #pet_grow_base{
        lev = 313
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1652
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(314) ->
    #pet_grow_base{
        lev = 314
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1656
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(315) ->
    #pet_grow_base{
        lev = 315
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1660
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(316) ->
    #pet_grow_base{
        lev = 316
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1664
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(317) ->
    #pet_grow_base{
        lev = 317
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1668
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(318) ->
    #pet_grow_base{
        lev = 318
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1672
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(319) ->
    #pet_grow_base{
        lev = 319
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1676
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(320) ->
    #pet_grow_base{
        lev = 320
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1680
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(321) ->
    #pet_grow_base{
        lev = 321
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1684
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(322) ->
    #pet_grow_base{
        lev = 322
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1688
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(323) ->
    #pet_grow_base{
        lev = 323
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1692
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(324) ->
    #pet_grow_base{
        lev = 324
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1696
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(325) ->
    #pet_grow_base{
        lev = 325
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1700
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(326) ->
    #pet_grow_base{
        lev = 326
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1704
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(327) ->
    #pet_grow_base{
        lev = 327
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1708
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(328) ->
    #pet_grow_base{
        lev = 328
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1712
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(329) ->
    #pet_grow_base{
        lev = 329
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1716
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(330) ->
    #pet_grow_base{
        lev = 330
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1720
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(331) ->
    #pet_grow_base{
        lev = 331
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1724
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(332) ->
    #pet_grow_base{
        lev = 332
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1728
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(333) ->
    #pet_grow_base{
        lev = 333
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1732
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(334) ->
    #pet_grow_base{
        lev = 334
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1736
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(335) ->
    #pet_grow_base{
        lev = 335
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1740
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(336) ->
    #pet_grow_base{
        lev = 336
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1744
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(337) ->
    #pet_grow_base{
        lev = 337
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1748
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(338) ->
    #pet_grow_base{
        lev = 338
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1752
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(339) ->
    #pet_grow_base{
        lev = 339
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1756
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(340) ->
    #pet_grow_base{
        lev = 340
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1760
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(341) ->
    #pet_grow_base{
        lev = 341
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1764
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(342) ->
    #pet_grow_base{
        lev = 342
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1768
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(343) ->
    #pet_grow_base{
        lev = 343
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1772
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(344) ->
    #pet_grow_base{
        lev = 344
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1776
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(345) ->
    #pet_grow_base{
        lev = 345
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1780
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(346) ->
    #pet_grow_base{
        lev = 346
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1784
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(347) ->
    #pet_grow_base{
        lev = 347
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1788
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(348) ->
    #pet_grow_base{
        lev = 348
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1792
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(349) ->
    #pet_grow_base{
        lev = 349
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1796
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(350) ->
    #pet_grow_base{
        lev = 350
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1800
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(351) ->
    #pet_grow_base{
        lev = 351
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1804
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(352) ->
    #pet_grow_base{
        lev = 352
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1808
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(353) ->
    #pet_grow_base{
        lev = 353
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1812
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(354) ->
    #pet_grow_base{
        lev = 354
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1816
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(355) ->
    #pet_grow_base{
        lev = 355
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1820
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(356) ->
    #pet_grow_base{
        lev = 356
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1824
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(357) ->
    #pet_grow_base{
        lev = 357
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1828
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(358) ->
    #pet_grow_base{
        lev = 358
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1832
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(359) ->
    #pet_grow_base{
        lev = 359
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1836
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(360) ->
    #pet_grow_base{
        lev = 360
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1840
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(361) ->
    #pet_grow_base{
        lev = 361
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1844
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(362) ->
    #pet_grow_base{
        lev = 362
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1848
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(363) ->
    #pet_grow_base{
        lev = 363
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1852
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(364) ->
    #pet_grow_base{
        lev = 364
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1856
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(365) ->
    #pet_grow_base{
        lev = 365
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1860
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(366) ->
    #pet_grow_base{
        lev = 366
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1864
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(367) ->
    #pet_grow_base{
        lev = 367
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1868
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(368) ->
    #pet_grow_base{
        lev = 368
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1872
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(369) ->
    #pet_grow_base{
        lev = 369
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1876
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(370) ->
    #pet_grow_base{
        lev = 370
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1880
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(371) ->
    #pet_grow_base{
        lev = 371
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1884
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(372) ->
    #pet_grow_base{
        lev = 372
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1888
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(373) ->
    #pet_grow_base{
        lev = 373
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1892
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(374) ->
    #pet_grow_base{
        lev = 374
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1896
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(375) ->
    #pet_grow_base{
        lev = 375
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1900
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(376) ->
    #pet_grow_base{
        lev = 376
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1904
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(377) ->
    #pet_grow_base{
        lev = 377
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1908
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(378) ->
    #pet_grow_base{
        lev = 378
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1912
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(379) ->
    #pet_grow_base{
        lev = 379
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1916
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(380) ->
    #pet_grow_base{
        lev = 380
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1920
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(381) ->
    #pet_grow_base{
        lev = 381
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1924
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(382) ->
    #pet_grow_base{
        lev = 382
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1928
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(383) ->
    #pet_grow_base{
        lev = 383
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1932
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(384) ->
    #pet_grow_base{
        lev = 384
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1936
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(385) ->
    #pet_grow_base{
        lev = 385
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1940
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(386) ->
    #pet_grow_base{
        lev = 386
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1944
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(387) ->
    #pet_grow_base{
        lev = 387
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1948
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(388) ->
    #pet_grow_base{
        lev = 388
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1952
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(389) ->
    #pet_grow_base{
        lev = 389
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1956
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(390) ->
    #pet_grow_base{
        lev = 390
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1960
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(391) ->
    #pet_grow_base{
        lev = 391
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1964
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(392) ->
    #pet_grow_base{
        lev = 392
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1968
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(393) ->
    #pet_grow_base{
        lev = 393
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1972
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(394) ->
    #pet_grow_base{
        lev = 394
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1976
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(395) ->
    #pet_grow_base{
        lev = 395
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1980
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(396) ->
    #pet_grow_base{
        lev = 396
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1984
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(397) ->
    #pet_grow_base{
        lev = 397
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1988
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(398) ->
    #pet_grow_base{
        lev = 398
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1992
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(399) ->
    #pet_grow_base{
        lev = 399
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 1996
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(400) ->
    #pet_grow_base{
        lev = 400
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2000
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(401) ->
    #pet_grow_base{
        lev = 401
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2004
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(402) ->
    #pet_grow_base{
        lev = 402
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2008
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(403) ->
    #pet_grow_base{
        lev = 403
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2012
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(404) ->
    #pet_grow_base{
        lev = 404
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2016
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(405) ->
    #pet_grow_base{
        lev = 405
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2020
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(406) ->
    #pet_grow_base{
        lev = 406
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2024
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(407) ->
    #pet_grow_base{
        lev = 407
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2028
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(408) ->
    #pet_grow_base{
        lev = 408
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2032
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(409) ->
    #pet_grow_base{
        lev = 409
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2036
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(410) ->
    #pet_grow_base{
        lev = 410
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2040
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(411) ->
    #pet_grow_base{
        lev = 411
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2044
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(412) ->
    #pet_grow_base{
        lev = 412
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2048
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(413) ->
    #pet_grow_base{
        lev = 413
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2052
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(414) ->
    #pet_grow_base{
        lev = 414
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2056
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(415) ->
    #pet_grow_base{
        lev = 415
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2060
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(416) ->
    #pet_grow_base{
        lev = 416
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2064
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(417) ->
    #pet_grow_base{
        lev = 417
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2068
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(418) ->
    #pet_grow_base{
        lev = 418
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2072
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(419) ->
    #pet_grow_base{
        lev = 419
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2076
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(420) ->
    #pet_grow_base{
        lev = 420
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2080
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(421) ->
    #pet_grow_base{
        lev = 421
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2084
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(422) ->
    #pet_grow_base{
        lev = 422
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2088
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(423) ->
    #pet_grow_base{
        lev = 423
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2092
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(424) ->
    #pet_grow_base{
        lev = 424
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2096
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(425) ->
    #pet_grow_base{
        lev = 425
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2100
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(426) ->
    #pet_grow_base{
        lev = 426
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2104
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(427) ->
    #pet_grow_base{
        lev = 427
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2108
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(428) ->
    #pet_grow_base{
        lev = 428
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2112
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(429) ->
    #pet_grow_base{
        lev = 429
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2116
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(430) ->
    #pet_grow_base{
        lev = 430
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2120
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(431) ->
    #pet_grow_base{
        lev = 431
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2124
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(432) ->
    #pet_grow_base{
        lev = 432
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2128
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(433) ->
    #pet_grow_base{
        lev = 433
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2132
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(434) ->
    #pet_grow_base{
        lev = 434
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2136
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(435) ->
    #pet_grow_base{
        lev = 435
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2140
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(436) ->
    #pet_grow_base{
        lev = 436
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2144
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(437) ->
    #pet_grow_base{
        lev = 437
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2148
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(438) ->
    #pet_grow_base{
        lev = 438
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2152
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(439) ->
    #pet_grow_base{
        lev = 439
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2156
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(440) ->
    #pet_grow_base{
        lev = 440
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2160
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(441) ->
    #pet_grow_base{
        lev = 441
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2164
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(442) ->
    #pet_grow_base{
        lev = 442
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2168
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(443) ->
    #pet_grow_base{
        lev = 443
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2172
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(444) ->
    #pet_grow_base{
        lev = 444
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2176
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(445) ->
    #pet_grow_base{
        lev = 445
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2180
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(446) ->
    #pet_grow_base{
        lev = 446
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2184
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(447) ->
    #pet_grow_base{
        lev = 447
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2188
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(448) ->
    #pet_grow_base{
        lev = 448
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2192
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(449) ->
    #pet_grow_base{
        lev = 449
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2196
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(450) ->
    #pet_grow_base{
        lev = 450
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2200
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(451) ->
    #pet_grow_base{
        lev = 451
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2204
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(452) ->
    #pet_grow_base{
        lev = 452
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2208
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(453) ->
    #pet_grow_base{
        lev = 453
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2212
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(454) ->
    #pet_grow_base{
        lev = 454
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2216
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(455) ->
    #pet_grow_base{
        lev = 455
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2220
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(456) ->
    #pet_grow_base{
        lev = 456
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2224
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(457) ->
    #pet_grow_base{
        lev = 457
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2228
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(458) ->
    #pet_grow_base{
        lev = 458
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2232
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(459) ->
    #pet_grow_base{
        lev = 459
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2236
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(460) ->
    #pet_grow_base{
        lev = 460
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2240
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(461) ->
    #pet_grow_base{
        lev = 461
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2244
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(462) ->
    #pet_grow_base{
        lev = 462
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2248
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(463) ->
    #pet_grow_base{
        lev = 463
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2252
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(464) ->
    #pet_grow_base{
        lev = 464
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2256
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(465) ->
    #pet_grow_base{
        lev = 465
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2260
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(466) ->
    #pet_grow_base{
        lev = 466
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2264
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(467) ->
    #pet_grow_base{
        lev = 467
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2268
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(468) ->
    #pet_grow_base{
        lev = 468
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2272
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(469) ->
    #pet_grow_base{
        lev = 469
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2276
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(470) ->
    #pet_grow_base{
        lev = 470
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2280
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(471) ->
    #pet_grow_base{
        lev = 471
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2284
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(472) ->
    #pet_grow_base{
        lev = 472
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2288
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(473) ->
    #pet_grow_base{
        lev = 473
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2292
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(474) ->
    #pet_grow_base{
        lev = 474
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2296
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(475) ->
    #pet_grow_base{
        lev = 475
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2300
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(476) ->
    #pet_grow_base{
        lev = 476
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2304
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(477) ->
    #pet_grow_base{
        lev = 477
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2308
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(478) ->
    #pet_grow_base{
        lev = 478
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2312
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(479) ->
    #pet_grow_base{
        lev = 479
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2316
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(480) ->
    #pet_grow_base{
        lev = 480
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2320
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(481) ->
    #pet_grow_base{
        lev = 481
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2324
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(482) ->
    #pet_grow_base{
        lev = 482
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2328
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(483) ->
    #pet_grow_base{
        lev = 483
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2332
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(484) ->
    #pet_grow_base{
        lev = 484
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2336
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(485) ->
    #pet_grow_base{
        lev = 485
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2340
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(486) ->
    #pet_grow_base{
        lev = 486
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2344
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(487) ->
    #pet_grow_base{
        lev = 487
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2348
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(488) ->
    #pet_grow_base{
        lev = 488
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2352
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(489) ->
    #pet_grow_base{
        lev = 489
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2356
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(490) ->
    #pet_grow_base{
        lev = 490
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2360
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(491) ->
    #pet_grow_base{
        lev = 491
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2364
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(492) ->
    #pet_grow_base{
        lev = 492
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2368
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(493) ->
    #pet_grow_base{
        lev = 493
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2372
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(494) ->
    #pet_grow_base{
        lev = 494
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2376
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(495) ->
    #pet_grow_base{
        lev = 495
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2380
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(496) ->
    #pet_grow_base{
        lev = 496
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2384
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(497) ->
    #pet_grow_base{
        lev = 497
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2388
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(498) ->
    #pet_grow_base{
        lev = 498
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2392
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(499) ->
    #pet_grow_base{
        lev = 499
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2396
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(500) ->
    #pet_grow_base{
        lev = 500
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2400
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(501) ->
    #pet_grow_base{
        lev = 501
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2404
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(502) ->
    #pet_grow_base{
        lev = 502
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2408
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(503) ->
    #pet_grow_base{
        lev = 503
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2412
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(504) ->
    #pet_grow_base{
        lev = 504
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2416
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(505) ->
    #pet_grow_base{
        lev = 505
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2420
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(506) ->
    #pet_grow_base{
        lev = 506
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2424
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(507) ->
    #pet_grow_base{
        lev = 507
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2428
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(508) ->
    #pet_grow_base{
        lev = 508
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2432
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(509) ->
    #pet_grow_base{
        lev = 509
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2436
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(510) ->
    #pet_grow_base{
        lev = 510
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2440
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(511) ->
    #pet_grow_base{
        lev = 511
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2444
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(512) ->
    #pet_grow_base{
        lev = 512
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2448
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(513) ->
    #pet_grow_base{
        lev = 513
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2452
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(514) ->
    #pet_grow_base{
        lev = 514
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2456
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(515) ->
    #pet_grow_base{
        lev = 515
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2460
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(516) ->
    #pet_grow_base{
        lev = 516
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2464
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(517) ->
    #pet_grow_base{
        lev = 517
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2468
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(518) ->
    #pet_grow_base{
        lev = 518
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2472
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(519) ->
    #pet_grow_base{
        lev = 519
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2476
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(520) ->
    #pet_grow_base{
        lev = 520
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2480
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(521) ->
    #pet_grow_base{
        lev = 521
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2484
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(522) ->
    #pet_grow_base{
        lev = 522
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2488
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(523) ->
    #pet_grow_base{
        lev = 523
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2492
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(524) ->
    #pet_grow_base{
        lev = 524
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2496
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(525) ->
    #pet_grow_base{
        lev = 525
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2500
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(526) ->
    #pet_grow_base{
        lev = 526
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2504
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(527) ->
    #pet_grow_base{
        lev = 527
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2508
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(528) ->
    #pet_grow_base{
        lev = 528
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2512
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(529) ->
    #pet_grow_base{
        lev = 529
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2516
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(530) ->
    #pet_grow_base{
        lev = 530
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2520
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(531) ->
    #pet_grow_base{
        lev = 531
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2524
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(532) ->
    #pet_grow_base{
        lev = 532
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2528
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(533) ->
    #pet_grow_base{
        lev = 533
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2532
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(534) ->
    #pet_grow_base{
        lev = 534
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2536
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(535) ->
    #pet_grow_base{
        lev = 535
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2540
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(536) ->
    #pet_grow_base{
        lev = 536
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2544
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(537) ->
    #pet_grow_base{
        lev = 537
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2548
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(538) ->
    #pet_grow_base{
        lev = 538
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2552
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(539) ->
    #pet_grow_base{
        lev = 539
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2556
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(540) ->
    #pet_grow_base{
        lev = 540
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2560
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(541) ->
    #pet_grow_base{
        lev = 541
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2564
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(542) ->
    #pet_grow_base{
        lev = 542
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2568
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(543) ->
    #pet_grow_base{
        lev = 543
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2572
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(544) ->
    #pet_grow_base{
        lev = 544
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2576
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(545) ->
    #pet_grow_base{
        lev = 545
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2580
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(546) ->
    #pet_grow_base{
        lev = 546
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2584
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(547) ->
    #pet_grow_base{
        lev = 547
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2588
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(548) ->
    #pet_grow_base{
        lev = 548
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2592
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(549) ->
    #pet_grow_base{
        lev = 549
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2596
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(550) ->
    #pet_grow_base{
        lev = 550
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2600
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(551) ->
    #pet_grow_base{
        lev = 551
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2604
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(552) ->
    #pet_grow_base{
        lev = 552
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2608
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(553) ->
    #pet_grow_base{
        lev = 553
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2612
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(554) ->
    #pet_grow_base{
        lev = 554
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2616
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(555) ->
    #pet_grow_base{
        lev = 555
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2620
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(556) ->
    #pet_grow_base{
        lev = 556
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2624
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(557) ->
    #pet_grow_base{
        lev = 557
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2628
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(558) ->
    #pet_grow_base{
        lev = 558
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2632
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(559) ->
    #pet_grow_base{
        lev = 559
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2636
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(560) ->
    #pet_grow_base{
        lev = 560
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2640
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(561) ->
    #pet_grow_base{
        lev = 561
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2644
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(562) ->
    #pet_grow_base{
        lev = 562
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2648
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(563) ->
    #pet_grow_base{
        lev = 563
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2652
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(564) ->
    #pet_grow_base{
        lev = 564
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2656
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(565) ->
    #pet_grow_base{
        lev = 565
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2660
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(566) ->
    #pet_grow_base{
        lev = 566
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2664
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(567) ->
    #pet_grow_base{
        lev = 567
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2668
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(568) ->
    #pet_grow_base{
        lev = 568
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2672
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(569) ->
    #pet_grow_base{
        lev = 569
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2676
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(570) ->
    #pet_grow_base{
        lev = 570
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2680
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(571) ->
    #pet_grow_base{
        lev = 571
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2684
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(572) ->
    #pet_grow_base{
        lev = 572
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2688
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(573) ->
    #pet_grow_base{
        lev = 573
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2692
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(574) ->
    #pet_grow_base{
        lev = 574
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2696
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(575) ->
    #pet_grow_base{
        lev = 575
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2700
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(576) ->
    #pet_grow_base{
        lev = 576
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2704
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(577) ->
    #pet_grow_base{
        lev = 577
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2708
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(578) ->
    #pet_grow_base{
        lev = 578
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2712
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(579) ->
    #pet_grow_base{
        lev = 579
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2716
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(580) ->
    #pet_grow_base{
        lev = 580
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2720
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(581) ->
    #pet_grow_base{
        lev = 581
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2724
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(582) ->
    #pet_grow_base{
        lev = 582
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2728
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(583) ->
    #pet_grow_base{
        lev = 583
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2732
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(584) ->
    #pet_grow_base{
        lev = 584
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2736
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(585) ->
    #pet_grow_base{
        lev = 585
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2740
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(586) ->
    #pet_grow_base{
        lev = 586
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2744
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(587) ->
    #pet_grow_base{
        lev = 587
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2748
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(588) ->
    #pet_grow_base{
        lev = 588
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2752
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(589) ->
    #pet_grow_base{
        lev = 589
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2756
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(590) ->
    #pet_grow_base{
        lev = 590
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2760
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(591) ->
    #pet_grow_base{
        lev = 591
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2764
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(592) ->
    #pet_grow_base{
        lev = 592
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2768
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(593) ->
    #pet_grow_base{
        lev = 593
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2772
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(594) ->
    #pet_grow_base{
        lev = 594
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2776
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(595) ->
    #pet_grow_base{
        lev = 595
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2780
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(596) ->
    #pet_grow_base{
        lev = 596
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2784
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(597) ->
    #pet_grow_base{
        lev = 597
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2788
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(598) ->
    #pet_grow_base{
        lev = 598
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2792
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(599) ->
    #pet_grow_base{
        lev = 599
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2796
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(600) ->
    #pet_grow_base{
        lev = 600
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2800
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(601) ->
    #pet_grow_base{
        lev = 601
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2804
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(602) ->
    #pet_grow_base{
        lev = 602
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2808
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(603) ->
    #pet_grow_base{
        lev = 603
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2812
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(604) ->
    #pet_grow_base{
        lev = 604
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2816
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(605) ->
    #pet_grow_base{
        lev = 605
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2820
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(606) ->
    #pet_grow_base{
        lev = 606
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2824
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(607) ->
    #pet_grow_base{
        lev = 607
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2828
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(608) ->
    #pet_grow_base{
        lev = 608
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2832
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(609) ->
    #pet_grow_base{
        lev = 609
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2836
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(610) ->
    #pet_grow_base{
        lev = 610
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2840
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(611) ->
    #pet_grow_base{
        lev = 611
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2844
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(612) ->
    #pet_grow_base{
        lev = 612
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2848
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(613) ->
    #pet_grow_base{
        lev = 613
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2852
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(614) ->
    #pet_grow_base{
        lev = 614
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2856
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(615) ->
    #pet_grow_base{
        lev = 615
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2860
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(616) ->
    #pet_grow_base{
        lev = 616
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2864
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(617) ->
    #pet_grow_base{
        lev = 617
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2868
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(618) ->
    #pet_grow_base{
        lev = 618
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2872
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(619) ->
    #pet_grow_base{
        lev = 619
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2876
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(620) ->
    #pet_grow_base{
        lev = 620
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2880
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(621) ->
    #pet_grow_base{
        lev = 621
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2884
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(622) ->
    #pet_grow_base{
        lev = 622
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2888
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(623) ->
    #pet_grow_base{
        lev = 623
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2892
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(624) ->
    #pet_grow_base{
        lev = 624
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2896
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(625) ->
    #pet_grow_base{
        lev = 625
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2900
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(626) ->
    #pet_grow_base{
        lev = 626
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2904
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(627) ->
    #pet_grow_base{
        lev = 627
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2908
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(628) ->
    #pet_grow_base{
        lev = 628
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2912
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(629) ->
    #pet_grow_base{
        lev = 629
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2916
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(630) ->
    #pet_grow_base{
        lev = 630
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2920
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(631) ->
    #pet_grow_base{
        lev = 631
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2924
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(632) ->
    #pet_grow_base{
        lev = 632
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2928
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(633) ->
    #pet_grow_base{
        lev = 633
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2932
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(634) ->
    #pet_grow_base{
        lev = 634
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2936
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(635) ->
    #pet_grow_base{
        lev = 635
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2940
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(636) ->
    #pet_grow_base{
        lev = 636
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2944
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(637) ->
    #pet_grow_base{
        lev = 637
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2948
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(638) ->
    #pet_grow_base{
        lev = 638
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2952
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(639) ->
    #pet_grow_base{
        lev = 639
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2956
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(640) ->
    #pet_grow_base{
        lev = 640
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2960
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(641) ->
    #pet_grow_base{
        lev = 641
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2964
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(642) ->
    #pet_grow_base{
        lev = 642
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2968
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(643) ->
    #pet_grow_base{
        lev = 643
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2972
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(644) ->
    #pet_grow_base{
        lev = 644
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2976
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(645) ->
    #pet_grow_base{
        lev = 645
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2980
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(646) ->
    #pet_grow_base{
        lev = 646
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2984
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(647) ->
    #pet_grow_base{
        lev = 647
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2988
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(648) ->
    #pet_grow_base{
        lev = 648
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2992
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(649) ->
    #pet_grow_base{
        lev = 649
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 2996
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(650) ->
    #pet_grow_base{
        lev = 650
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3000
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(651) ->
    #pet_grow_base{
        lev = 651
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3004
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(652) ->
    #pet_grow_base{
        lev = 652
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3008
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(653) ->
    #pet_grow_base{
        lev = 653
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3012
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(654) ->
    #pet_grow_base{
        lev = 654
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3016
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(655) ->
    #pet_grow_base{
        lev = 655
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3020
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(656) ->
    #pet_grow_base{
        lev = 656
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3024
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(657) ->
    #pet_grow_base{
        lev = 657
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3028
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(658) ->
    #pet_grow_base{
        lev = 658
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3032
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(659) ->
    #pet_grow_base{
        lev = 659
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3036
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(660) ->
    #pet_grow_base{
        lev = 660
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3040
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(661) ->
    #pet_grow_base{
        lev = 661
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3044
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(662) ->
    #pet_grow_base{
        lev = 662
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3048
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(663) ->
    #pet_grow_base{
        lev = 663
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3052
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(664) ->
    #pet_grow_base{
        lev = 664
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3056
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(665) ->
    #pet_grow_base{
        lev = 665
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3060
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(666) ->
    #pet_grow_base{
        lev = 666
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3064
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(667) ->
    #pet_grow_base{
        lev = 667
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3068
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(668) ->
    #pet_grow_base{
        lev = 668
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3072
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(669) ->
    #pet_grow_base{
        lev = 669
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3076
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(670) ->
    #pet_grow_base{
        lev = 670
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3080
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(671) ->
    #pet_grow_base{
        lev = 671
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3084
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(672) ->
    #pet_grow_base{
        lev = 672
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3088
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(673) ->
    #pet_grow_base{
        lev = 673
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3092
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(674) ->
    #pet_grow_base{
        lev = 674
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3096
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(675) ->
    #pet_grow_base{
        lev = 675
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3100
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(676) ->
    #pet_grow_base{
        lev = 676
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3104
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(677) ->
    #pet_grow_base{
        lev = 677
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3108
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(678) ->
    #pet_grow_base{
        lev = 678
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3112
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(679) ->
    #pet_grow_base{
        lev = 679
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3116
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(680) ->
    #pet_grow_base{
        lev = 680
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3120
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(681) ->
    #pet_grow_base{
        lev = 681
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3124
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(682) ->
    #pet_grow_base{
        lev = 682
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3128
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(683) ->
    #pet_grow_base{
        lev = 683
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3132
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(684) ->
    #pet_grow_base{
        lev = 684
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3136
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(685) ->
    #pet_grow_base{
        lev = 685
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3140
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(686) ->
    #pet_grow_base{
        lev = 686
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3144
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(687) ->
    #pet_grow_base{
        lev = 687
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3148
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(688) ->
    #pet_grow_base{
        lev = 688
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3152
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(689) ->
    #pet_grow_base{
        lev = 689
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3156
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(690) ->
    #pet_grow_base{
        lev = 690
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3160
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(691) ->
    #pet_grow_base{
        lev = 691
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3164
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(692) ->
    #pet_grow_base{
        lev = 692
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3168
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(693) ->
    #pet_grow_base{
        lev = 693
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3172
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(694) ->
    #pet_grow_base{
        lev = 694
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3176
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(695) ->
    #pet_grow_base{
        lev = 695
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3180
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(696) ->
    #pet_grow_base{
        lev = 696
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3184
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(697) ->
    #pet_grow_base{
        lev = 697
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3188
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(698) ->
    #pet_grow_base{
        lev = 698
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3192
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(699) ->
    #pet_grow_base{
        lev = 699
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3196
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(700) ->
    #pet_grow_base{
        lev = 700
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3200
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(701) ->
    #pet_grow_base{
        lev = 701
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3204
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(702) ->
    #pet_grow_base{
        lev = 702
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3208
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(703) ->
    #pet_grow_base{
        lev = 703
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3212
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(704) ->
    #pet_grow_base{
        lev = 704
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3216
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(705) ->
    #pet_grow_base{
        lev = 705
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3220
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(706) ->
    #pet_grow_base{
        lev = 706
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3224
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(707) ->
    #pet_grow_base{
        lev = 707
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3228
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(708) ->
    #pet_grow_base{
        lev = 708
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3232
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(709) ->
    #pet_grow_base{
        lev = 709
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3236
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(710) ->
    #pet_grow_base{
        lev = 710
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3240
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(711) ->
    #pet_grow_base{
        lev = 711
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3244
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(712) ->
    #pet_grow_base{
        lev = 712
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3248
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(713) ->
    #pet_grow_base{
        lev = 713
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3252
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(714) ->
    #pet_grow_base{
        lev = 714
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3256
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(715) ->
    #pet_grow_base{
        lev = 715
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3260
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(716) ->
    #pet_grow_base{
        lev = 716
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3264
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(717) ->
    #pet_grow_base{
        lev = 717
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3268
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(718) ->
    #pet_grow_base{
        lev = 718
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3272
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(719) ->
    #pet_grow_base{
        lev = 719
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3276
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(720) ->
    #pet_grow_base{
        lev = 720
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3280
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(721) ->
    #pet_grow_base{
        lev = 721
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3284
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(722) ->
    #pet_grow_base{
        lev = 722
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3288
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(723) ->
    #pet_grow_base{
        lev = 723
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3292
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(724) ->
    #pet_grow_base{
        lev = 724
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3296
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(725) ->
    #pet_grow_base{
        lev = 725
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3300
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(726) ->
    #pet_grow_base{
        lev = 726
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3304
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(727) ->
    #pet_grow_base{
        lev = 727
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3308
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(728) ->
    #pet_grow_base{
        lev = 728
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3312
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(729) ->
    #pet_grow_base{
        lev = 729
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3316
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(730) ->
    #pet_grow_base{
        lev = 730
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3320
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(731) ->
    #pet_grow_base{
        lev = 731
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3324
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(732) ->
    #pet_grow_base{
        lev = 732
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3328
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(733) ->
    #pet_grow_base{
        lev = 733
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3332
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(734) ->
    #pet_grow_base{
        lev = 734
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3336
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(735) ->
    #pet_grow_base{
        lev = 735
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3340
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(736) ->
    #pet_grow_base{
        lev = 736
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3344
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(737) ->
    #pet_grow_base{
        lev = 737
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3348
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(738) ->
    #pet_grow_base{
        lev = 738
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3352
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(739) ->
    #pet_grow_base{
        lev = 739
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3356
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(740) ->
    #pet_grow_base{
        lev = 740
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3360
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(741) ->
    #pet_grow_base{
        lev = 741
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3364
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(742) ->
    #pet_grow_base{
        lev = 742
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3368
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(743) ->
    #pet_grow_base{
        lev = 743
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3372
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(744) ->
    #pet_grow_base{
        lev = 744
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3376
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(745) ->
    #pet_grow_base{
        lev = 745
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3380
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(746) ->
    #pet_grow_base{
        lev = 746
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3384
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(747) ->
    #pet_grow_base{
        lev = 747
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3388
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(748) ->
    #pet_grow_base{
        lev = 748
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3392
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(749) ->
    #pet_grow_base{
        lev = 749
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3396
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(750) ->
    #pet_grow_base{
        lev = 750
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3400
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(751) ->
    #pet_grow_base{
        lev = 751
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3404
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(752) ->
    #pet_grow_base{
        lev = 752
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3408
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(753) ->
    #pet_grow_base{
        lev = 753
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3412
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(754) ->
    #pet_grow_base{
        lev = 754
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3416
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(755) ->
    #pet_grow_base{
        lev = 755
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3420
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(756) ->
    #pet_grow_base{
        lev = 756
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3424
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(757) ->
    #pet_grow_base{
        lev = 757
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3428
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(758) ->
    #pet_grow_base{
        lev = 758
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3432
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(759) ->
    #pet_grow_base{
        lev = 759
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3436
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(760) ->
    #pet_grow_base{
        lev = 760
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3440
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(761) ->
    #pet_grow_base{
        lev = 761
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3444
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(762) ->
    #pet_grow_base{
        lev = 762
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3448
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(763) ->
    #pet_grow_base{
        lev = 763
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3452
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(764) ->
    #pet_grow_base{
        lev = 764
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3456
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(765) ->
    #pet_grow_base{
        lev = 765
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3460
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(766) ->
    #pet_grow_base{
        lev = 766
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3464
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(767) ->
    #pet_grow_base{
        lev = 767
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3468
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(768) ->
    #pet_grow_base{
        lev = 768
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3472
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(769) ->
    #pet_grow_base{
        lev = 769
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3476
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(770) ->
    #pet_grow_base{
        lev = 770
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3480
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(771) ->
    #pet_grow_base{
        lev = 771
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3484
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(772) ->
    #pet_grow_base{
        lev = 772
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3488
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(773) ->
    #pet_grow_base{
        lev = 773
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3492
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(774) ->
    #pet_grow_base{
        lev = 774
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3496
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(775) ->
    #pet_grow_base{
        lev = 775
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3500
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(776) ->
    #pet_grow_base{
        lev = 776
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3504
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(777) ->
    #pet_grow_base{
        lev = 777
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3508
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(778) ->
    #pet_grow_base{
        lev = 778
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3512
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(779) ->
    #pet_grow_base{
        lev = 779
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3516
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(780) ->
    #pet_grow_base{
        lev = 780
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3520
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(781) ->
    #pet_grow_base{
        lev = 781
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3524
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(782) ->
    #pet_grow_base{
        lev = 782
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3528
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(783) ->
    #pet_grow_base{
        lev = 783
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3532
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(784) ->
    #pet_grow_base{
        lev = 784
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3536
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(785) ->
    #pet_grow_base{
        lev = 785
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3540
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(786) ->
    #pet_grow_base{
        lev = 786
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3544
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(787) ->
    #pet_grow_base{
        lev = 787
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3548
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(788) ->
    #pet_grow_base{
        lev = 788
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3552
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(789) ->
    #pet_grow_base{
        lev = 789
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3556
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(790) ->
    #pet_grow_base{
        lev = 790
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3560
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(791) ->
    #pet_grow_base{
        lev = 791
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3564
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(792) ->
    #pet_grow_base{
        lev = 792
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3568
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(793) ->
    #pet_grow_base{
        lev = 793
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3572
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(794) ->
    #pet_grow_base{
        lev = 794
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3576
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(795) ->
    #pet_grow_base{
        lev = 795
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3580
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(796) ->
    #pet_grow_base{
        lev = 796
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3584
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(797) ->
    #pet_grow_base{
        lev = 797
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3588
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(798) ->
    #pet_grow_base{
        lev = 798
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3592
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(799) ->
    #pet_grow_base{
        lev = 799
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3596
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(800) ->
    #pet_grow_base{
        lev = 800
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3600
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(801) ->
    #pet_grow_base{
        lev = 801
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3604
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(802) ->
    #pet_grow_base{
        lev = 802
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3608
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(803) ->
    #pet_grow_base{
        lev = 803
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3612
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(804) ->
    #pet_grow_base{
        lev = 804
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3616
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(805) ->
    #pet_grow_base{
        lev = 805
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3620
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(806) ->
    #pet_grow_base{
        lev = 806
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3624
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(807) ->
    #pet_grow_base{
        lev = 807
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3628
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(808) ->
    #pet_grow_base{
        lev = 808
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3632
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(809) ->
    #pet_grow_base{
        lev = 809
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3636
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(810) ->
    #pet_grow_base{
        lev = 810
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3640
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(811) ->
    #pet_grow_base{
        lev = 811
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3644
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(812) ->
    #pet_grow_base{
        lev = 812
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3648
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(813) ->
    #pet_grow_base{
        lev = 813
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3652
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(814) ->
    #pet_grow_base{
        lev = 814
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3656
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(815) ->
    #pet_grow_base{
        lev = 815
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3660
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(816) ->
    #pet_grow_base{
        lev = 816
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3664
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(817) ->
    #pet_grow_base{
        lev = 817
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3668
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(818) ->
    #pet_grow_base{
        lev = 818
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3672
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(819) ->
    #pet_grow_base{
        lev = 819
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3676
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(820) ->
    #pet_grow_base{
        lev = 820
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3680
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(821) ->
    #pet_grow_base{
        lev = 821
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3684
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(822) ->
    #pet_grow_base{
        lev = 822
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3688
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(823) ->
    #pet_grow_base{
        lev = 823
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3692
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(824) ->
    #pet_grow_base{
        lev = 824
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3696
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(825) ->
    #pet_grow_base{
        lev = 825
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3700
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(826) ->
    #pet_grow_base{
        lev = 826
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3704
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(827) ->
    #pet_grow_base{
        lev = 827
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3708
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(828) ->
    #pet_grow_base{
        lev = 828
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3712
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(829) ->
    #pet_grow_base{
        lev = 829
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3716
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(830) ->
    #pet_grow_base{
        lev = 830
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3720
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(831) ->
    #pet_grow_base{
        lev = 831
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3724
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(832) ->
    #pet_grow_base{
        lev = 832
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3728
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(833) ->
    #pet_grow_base{
        lev = 833
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3732
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(834) ->
    #pet_grow_base{
        lev = 834
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3736
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(835) ->
    #pet_grow_base{
        lev = 835
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3740
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(836) ->
    #pet_grow_base{
        lev = 836
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3744
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(837) ->
    #pet_grow_base{
        lev = 837
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3748
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(838) ->
    #pet_grow_base{
        lev = 838
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3752
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(839) ->
    #pet_grow_base{
        lev = 839
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3756
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(840) ->
    #pet_grow_base{
        lev = 840
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3760
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(841) ->
    #pet_grow_base{
        lev = 841
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3764
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(842) ->
    #pet_grow_base{
        lev = 842
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3768
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(843) ->
    #pet_grow_base{
        lev = 843
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3772
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(844) ->
    #pet_grow_base{
        lev = 844
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3776
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(845) ->
    #pet_grow_base{
        lev = 845
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3780
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(846) ->
    #pet_grow_base{
        lev = 846
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3784
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(847) ->
    #pet_grow_base{
        lev = 847
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3788
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(848) ->
    #pet_grow_base{
        lev = 848
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3792
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(849) ->
    #pet_grow_base{
        lev = 849
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3796
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(850) ->
    #pet_grow_base{
        lev = 850
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3800
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(851) ->
    #pet_grow_base{
        lev = 851
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3804
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(852) ->
    #pet_grow_base{
        lev = 852
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3808
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(853) ->
    #pet_grow_base{
        lev = 853
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3812
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(854) ->
    #pet_grow_base{
        lev = 854
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3816
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(855) ->
    #pet_grow_base{
        lev = 855
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3820
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(856) ->
    #pet_grow_base{
        lev = 856
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3824
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(857) ->
    #pet_grow_base{
        lev = 857
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3828
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(858) ->
    #pet_grow_base{
        lev = 858
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3832
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(859) ->
    #pet_grow_base{
        lev = 859
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3836
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(860) ->
    #pet_grow_base{
        lev = 860
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3840
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(861) ->
    #pet_grow_base{
        lev = 861
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3844
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(862) ->
    #pet_grow_base{
        lev = 862
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3848
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(863) ->
    #pet_grow_base{
        lev = 863
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3852
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(864) ->
    #pet_grow_base{
        lev = 864
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3856
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(865) ->
    #pet_grow_base{
        lev = 865
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3860
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(866) ->
    #pet_grow_base{
        lev = 866
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3864
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(867) ->
    #pet_grow_base{
        lev = 867
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3868
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(868) ->
    #pet_grow_base{
        lev = 868
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3872
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(869) ->
    #pet_grow_base{
        lev = 869
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3876
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(870) ->
    #pet_grow_base{
        lev = 870
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3880
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(871) ->
    #pet_grow_base{
        lev = 871
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3884
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(872) ->
    #pet_grow_base{
        lev = 872
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3888
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(873) ->
    #pet_grow_base{
        lev = 873
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3892
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(874) ->
    #pet_grow_base{
        lev = 874
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3896
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(875) ->
    #pet_grow_base{
        lev = 875
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3900
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(876) ->
    #pet_grow_base{
        lev = 876
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3904
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(877) ->
    #pet_grow_base{
        lev = 877
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3908
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(878) ->
    #pet_grow_base{
        lev = 878
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3912
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(879) ->
    #pet_grow_base{
        lev = 879
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3916
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(880) ->
    #pet_grow_base{
        lev = 880
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3920
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(881) ->
    #pet_grow_base{
        lev = 881
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3924
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(882) ->
    #pet_grow_base{
        lev = 882
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3928
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(883) ->
    #pet_grow_base{
        lev = 883
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3932
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(884) ->
    #pet_grow_base{
        lev = 884
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3936
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(885) ->
    #pet_grow_base{
        lev = 885
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3940
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(886) ->
    #pet_grow_base{
        lev = 886
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3944
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(887) ->
    #pet_grow_base{
        lev = 887
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3948
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(888) ->
    #pet_grow_base{
        lev = 888
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3952
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(889) ->
    #pet_grow_base{
        lev = 889
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3956
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(890) ->
    #pet_grow_base{
        lev = 890
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3960
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(891) ->
    #pet_grow_base{
        lev = 891
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3964
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(892) ->
    #pet_grow_base{
        lev = 892
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3968
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(893) ->
    #pet_grow_base{
        lev = 893
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3972
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(894) ->
    #pet_grow_base{
        lev = 894
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3976
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(895) ->
    #pet_grow_base{
        lev = 895
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3980
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(896) ->
    #pet_grow_base{
        lev = 896
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3984
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(897) ->
    #pet_grow_base{
        lev = 897
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3988
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(898) ->
    #pet_grow_base{
        lev = 898
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3992
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(899) ->
    #pet_grow_base{
        lev = 899
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 3996
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(900) ->
    #pet_grow_base{
        lev = 900
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4000
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(901) ->
    #pet_grow_base{
        lev = 901
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4004
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(902) ->
    #pet_grow_base{
        lev = 902
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4008
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(903) ->
    #pet_grow_base{
        lev = 903
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4012
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(904) ->
    #pet_grow_base{
        lev = 904
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4016
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(905) ->
    #pet_grow_base{
        lev = 905
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4020
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(906) ->
    #pet_grow_base{
        lev = 906
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4024
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(907) ->
    #pet_grow_base{
        lev = 907
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4028
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(908) ->
    #pet_grow_base{
        lev = 908
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4032
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(909) ->
    #pet_grow_base{
        lev = 909
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4036
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(910) ->
    #pet_grow_base{
        lev = 910
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4040
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(911) ->
    #pet_grow_base{
        lev = 911
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4044
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(912) ->
    #pet_grow_base{
        lev = 912
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4048
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(913) ->
    #pet_grow_base{
        lev = 913
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4052
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(914) ->
    #pet_grow_base{
        lev = 914
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4056
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(915) ->
    #pet_grow_base{
        lev = 915
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4060
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(916) ->
    #pet_grow_base{
        lev = 916
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4064
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(917) ->
    #pet_grow_base{
        lev = 917
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4068
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(918) ->
    #pet_grow_base{
        lev = 918
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4072
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(919) ->
    #pet_grow_base{
        lev = 919
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4076
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(920) ->
    #pet_grow_base{
        lev = 920
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4080
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(921) ->
    #pet_grow_base{
        lev = 921
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4084
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(922) ->
    #pet_grow_base{
        lev = 922
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4088
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(923) ->
    #pet_grow_base{
        lev = 923
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4092
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(924) ->
    #pet_grow_base{
        lev = 924
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4096
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(925) ->
    #pet_grow_base{
        lev = 925
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4100
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(926) ->
    #pet_grow_base{
        lev = 926
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4104
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(927) ->
    #pet_grow_base{
        lev = 927
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4108
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(928) ->
    #pet_grow_base{
        lev = 928
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4112
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(929) ->
    #pet_grow_base{
        lev = 929
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4116
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(930) ->
    #pet_grow_base{
        lev = 930
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4120
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(931) ->
    #pet_grow_base{
        lev = 931
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4124
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(932) ->
    #pet_grow_base{
        lev = 932
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4128
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(933) ->
    #pet_grow_base{
        lev = 933
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4132
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(934) ->
    #pet_grow_base{
        lev = 934
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4136
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(935) ->
    #pet_grow_base{
        lev = 935
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4140
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(936) ->
    #pet_grow_base{
        lev = 936
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4144
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(937) ->
    #pet_grow_base{
        lev = 937
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4148
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(938) ->
    #pet_grow_base{
        lev = 938
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4152
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(939) ->
    #pet_grow_base{
        lev = 939
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4156
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(940) ->
    #pet_grow_base{
        lev = 940
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4160
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(941) ->
    #pet_grow_base{
        lev = 941
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4164
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(942) ->
    #pet_grow_base{
        lev = 942
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4168
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(943) ->
    #pet_grow_base{
        lev = 943
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4172
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(944) ->
    #pet_grow_base{
        lev = 944
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4176
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(945) ->
    #pet_grow_base{
        lev = 945
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4180
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(946) ->
    #pet_grow_base{
        lev = 946
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4184
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(947) ->
    #pet_grow_base{
        lev = 947
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4188
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(948) ->
    #pet_grow_base{
        lev = 948
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4192
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(949) ->
    #pet_grow_base{
        lev = 949
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4196
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(950) ->
    #pet_grow_base{
        lev = 950
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4200
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(951) ->
    #pet_grow_base{
        lev = 951
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4204
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(952) ->
    #pet_grow_base{
        lev = 952
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4208
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(953) ->
    #pet_grow_base{
        lev = 953
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4212
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(954) ->
    #pet_grow_base{
        lev = 954
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4216
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(955) ->
    #pet_grow_base{
        lev = 955
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4220
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(956) ->
    #pet_grow_base{
        lev = 956
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4224
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(957) ->
    #pet_grow_base{
        lev = 957
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4228
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(958) ->
    #pet_grow_base{
        lev = 958
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4232
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(959) ->
    #pet_grow_base{
        lev = 959
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4236
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(960) ->
    #pet_grow_base{
        lev = 960
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4240
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(961) ->
    #pet_grow_base{
        lev = 961
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4244
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(962) ->
    #pet_grow_base{
        lev = 962
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4248
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(963) ->
    #pet_grow_base{
        lev = 963
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4252
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(964) ->
    #pet_grow_base{
        lev = 964
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4256
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(965) ->
    #pet_grow_base{
        lev = 965
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4260
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(966) ->
    #pet_grow_base{
        lev = 966
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4264
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(967) ->
    #pet_grow_base{
        lev = 967
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4268
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(968) ->
    #pet_grow_base{
        lev = 968
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4272
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(969) ->
    #pet_grow_base{
        lev = 969
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4276
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(970) ->
    #pet_grow_base{
        lev = 970
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4280
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(971) ->
    #pet_grow_base{
        lev = 971
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4284
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(972) ->
    #pet_grow_base{
        lev = 972
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4288
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(973) ->
    #pet_grow_base{
        lev = 973
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4292
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(974) ->
    #pet_grow_base{
        lev = 974
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4296
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(975) ->
    #pet_grow_base{
        lev = 975
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4300
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(976) ->
    #pet_grow_base{
        lev = 976
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4304
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(977) ->
    #pet_grow_base{
        lev = 977
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4308
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(978) ->
    #pet_grow_base{
        lev = 978
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4312
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(979) ->
    #pet_grow_base{
        lev = 979
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4316
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(980) ->
    #pet_grow_base{
        lev = 980
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4320
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(981) ->
    #pet_grow_base{
        lev = 981
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4324
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(982) ->
    #pet_grow_base{
        lev = 982
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4328
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(983) ->
    #pet_grow_base{
        lev = 983
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4332
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(984) ->
    #pet_grow_base{
        lev = 984
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4336
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(985) ->
    #pet_grow_base{
        lev = 985
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4340
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(986) ->
    #pet_grow_base{
        lev = 986
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4344
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(987) ->
    #pet_grow_base{
        lev = 987
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4348
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(988) ->
    #pet_grow_base{
        lev = 988
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4352
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(989) ->
    #pet_grow_base{
        lev = 989
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4356
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(990) ->
    #pet_grow_base{
        lev = 990
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4360
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(991) ->
    #pet_grow_base{
        lev = 991
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4364
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(992) ->
    #pet_grow_base{
        lev = 992
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4368
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(993) ->
    #pet_grow_base{
        lev = 993
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4372
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(994) ->
    #pet_grow_base{
        lev = 994
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4376
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(995) ->
    #pet_grow_base{
        lev = 995
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4380
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(996) ->
    #pet_grow_base{
        lev = 996
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4384
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(997) ->
    #pet_grow_base{
        lev = 997
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4388
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(998) ->
    #pet_grow_base{
        lev = 998
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4392
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(999) ->
    #pet_grow_base{
        lev = 999
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4396
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1000) ->
    #pet_grow_base{
        lev = 1000
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4400
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1001) ->
    #pet_grow_base{
        lev = 1001
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4404
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1002) ->
    #pet_grow_base{
        lev = 1002
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4408
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1003) ->
    #pet_grow_base{
        lev = 1003
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4412
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1004) ->
    #pet_grow_base{
        lev = 1004
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4416
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1005) ->
    #pet_grow_base{
        lev = 1005
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4420
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1006) ->
    #pet_grow_base{
        lev = 1006
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4424
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1007) ->
    #pet_grow_base{
        lev = 1007
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4428
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1008) ->
    #pet_grow_base{
        lev = 1008
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4432
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1009) ->
    #pet_grow_base{
        lev = 1009
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4436
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1010) ->
    #pet_grow_base{
        lev = 1010
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4440
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1011) ->
    #pet_grow_base{
        lev = 1011
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4444
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1012) ->
    #pet_grow_base{
        lev = 1012
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4448
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1013) ->
    #pet_grow_base{
        lev = 1013
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4452
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1014) ->
    #pet_grow_base{
        lev = 1014
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4456
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1015) ->
    #pet_grow_base{
        lev = 1015
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4460
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1016) ->
    #pet_grow_base{
        lev = 1016
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4464
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1017) ->
    #pet_grow_base{
        lev = 1017
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4468
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1018) ->
    #pet_grow_base{
        lev = 1018
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4472
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1019) ->
    #pet_grow_base{
        lev = 1019
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4476
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1020) ->
    #pet_grow_base{
        lev = 1020
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4480
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1021) ->
    #pet_grow_base{
        lev = 1021
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4484
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1022) ->
    #pet_grow_base{
        lev = 1022
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4488
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1023) ->
    #pet_grow_base{
        lev = 1023
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4492
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1024) ->
    #pet_grow_base{
        lev = 1024
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4496
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1025) ->
    #pet_grow_base{
        lev = 1025
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4500
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1026) ->
    #pet_grow_base{
        lev = 1026
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4504
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1027) ->
    #pet_grow_base{
        lev = 1027
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4508
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1028) ->
    #pet_grow_base{
        lev = 1028
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4512
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1029) ->
    #pet_grow_base{
        lev = 1029
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4516
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1030) ->
    #pet_grow_base{
        lev = 1030
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4520
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1031) ->
    #pet_grow_base{
        lev = 1031
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4524
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1032) ->
    #pet_grow_base{
        lev = 1032
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4528
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1033) ->
    #pet_grow_base{
        lev = 1033
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4532
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1034) ->
    #pet_grow_base{
        lev = 1034
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4536
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1035) ->
    #pet_grow_base{
        lev = 1035
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4540
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1036) ->
    #pet_grow_base{
        lev = 1036
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4544
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1037) ->
    #pet_grow_base{
        lev = 1037
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4548
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1038) ->
    #pet_grow_base{
        lev = 1038
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4552
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1039) ->
    #pet_grow_base{
        lev = 1039
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4556
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1040) ->
    #pet_grow_base{
        lev = 1040
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4560
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1041) ->
    #pet_grow_base{
        lev = 1041
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4564
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1042) ->
    #pet_grow_base{
        lev = 1042
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4568
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1043) ->
    #pet_grow_base{
        lev = 1043
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4572
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1044) ->
    #pet_grow_base{
        lev = 1044
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4576
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1045) ->
    #pet_grow_base{
        lev = 1045
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4580
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1046) ->
    #pet_grow_base{
        lev = 1046
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4584
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1047) ->
    #pet_grow_base{
        lev = 1047
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4588
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1048) ->
    #pet_grow_base{
        lev = 1048
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4592
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1049) ->
    #pet_grow_base{
        lev = 1049
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4596
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1050) ->
    #pet_grow_base{
        lev = 1050
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4600
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1051) ->
    #pet_grow_base{
        lev = 1051
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4604
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1052) ->
    #pet_grow_base{
        lev = 1052
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4608
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1053) ->
    #pet_grow_base{
        lev = 1053
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4612
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1054) ->
    #pet_grow_base{
        lev = 1054
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4616
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1055) ->
    #pet_grow_base{
        lev = 1055
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4620
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1056) ->
    #pet_grow_base{
        lev = 1056
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4624
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1057) ->
    #pet_grow_base{
        lev = 1057
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4628
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1058) ->
    #pet_grow_base{
        lev = 1058
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4632
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1059) ->
    #pet_grow_base{
        lev = 1059
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4636
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1060) ->
    #pet_grow_base{
        lev = 1060
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4640
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1061) ->
    #pet_grow_base{
        lev = 1061
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4644
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1062) ->
    #pet_grow_base{
        lev = 1062
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4648
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1063) ->
    #pet_grow_base{
        lev = 1063
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4652
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1064) ->
    #pet_grow_base{
        lev = 1064
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4656
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1065) ->
    #pet_grow_base{
        lev = 1065
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4660
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1066) ->
    #pet_grow_base{
        lev = 1066
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4664
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1067) ->
    #pet_grow_base{
        lev = 1067
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4668
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1068) ->
    #pet_grow_base{
        lev = 1068
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4672
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1069) ->
    #pet_grow_base{
        lev = 1069
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4676
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1070) ->
    #pet_grow_base{
        lev = 1070
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4680
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1071) ->
    #pet_grow_base{
        lev = 1071
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4684
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1072) ->
    #pet_grow_base{
        lev = 1072
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4688
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1073) ->
    #pet_grow_base{
        lev = 1073
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4692
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1074) ->
    #pet_grow_base{
        lev = 1074
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4696
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1075) ->
    #pet_grow_base{
        lev = 1075
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4700
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1076) ->
    #pet_grow_base{
        lev = 1076
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4704
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1077) ->
    #pet_grow_base{
        lev = 1077
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4708
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1078) ->
    #pet_grow_base{
        lev = 1078
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4712
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1079) ->
    #pet_grow_base{
        lev = 1079
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4716
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1080) ->
    #pet_grow_base{
        lev = 1080
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4720
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1081) ->
    #pet_grow_base{
        lev = 1081
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4724
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1082) ->
    #pet_grow_base{
        lev = 1082
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4728
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1083) ->
    #pet_grow_base{
        lev = 1083
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4732
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1084) ->
    #pet_grow_base{
        lev = 1084
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4736
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1085) ->
    #pet_grow_base{
        lev = 1085
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4740
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1086) ->
    #pet_grow_base{
        lev = 1086
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4744
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1087) ->
    #pet_grow_base{
        lev = 1087
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4748
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1088) ->
    #pet_grow_base{
        lev = 1088
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4752
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1089) ->
    #pet_grow_base{
        lev = 1089
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4756
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1090) ->
    #pet_grow_base{
        lev = 1090
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4760
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1091) ->
    #pet_grow_base{
        lev = 1091
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4764
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1092) ->
    #pet_grow_base{
        lev = 1092
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4768
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1093) ->
    #pet_grow_base{
        lev = 1093
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4772
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1094) ->
    #pet_grow_base{
        lev = 1094
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4776
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1095) ->
    #pet_grow_base{
        lev = 1095
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4780
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1096) ->
    #pet_grow_base{
        lev = 1096
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4784
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1097) ->
    #pet_grow_base{
        lev = 1097
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4788
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1098) ->
    #pet_grow_base{
        lev = 1098
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4792
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1099) ->
    #pet_grow_base{
        lev = 1099
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4796
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(1100) ->
    #pet_grow_base{
        lev = 1100
        ,base_suc = 10
        ,max_wish = 1000
        ,min_wish = 160
        ,attr_val = 4800
        ,cli_base_suc = 10
        ,cli_max_wish = 600
    };

get_grow(_) -> #pet_grow_base{}.

%% 获取宠物外观选择变化数据
baseid_type(124000) -> 0;
baseid_type(124100) -> 1;
baseid_type(124300) -> 2;
baseid_type(124200) -> 3;
baseid_type(124001) -> 0;
baseid_type(124101) -> 1;
baseid_type(124301) -> 2;
baseid_type(124201) -> 3;
baseid_type(124002) -> 0;
baseid_type(124102) -> 1;
baseid_type(124302) -> 2;
baseid_type(124202) -> 3;
baseid_type(124003) -> 0;
baseid_type(124103) -> 1;
baseid_type(124303) -> 2;
baseid_type(124203) -> 3;
baseid_type(124004) -> 0;
baseid_type(124104) -> 1;
baseid_type(124304) -> 2;
baseid_type(124204) -> 3;
baseid_type(124005) -> 0;
baseid_type(124105) -> 1;
baseid_type(124305) -> 2;
baseid_type(124205) -> 3;
baseid_type(124006) -> 0;
baseid_type(124106) -> 1;
baseid_type(124306) -> 2;
baseid_type(124206) -> 3;
baseid_type(124007) -> 0;
baseid_type(124107) -> 1;
baseid_type(124307) -> 2;
baseid_type(124207) -> 3;
baseid_type(124008) -> 0;
baseid_type(124108) -> 1;
baseid_type(124308) -> 2;
baseid_type(124208) -> 3;
baseid_type(124009) -> 0;
baseid_type(124109) -> 1;
baseid_type(124309) -> 2;
baseid_type(124209) -> 3;
baseid_type(124010) -> 0;
baseid_type(124110) -> 1;
baseid_type(124310) -> 2;
baseid_type(124210) -> 3;
baseid_type(124011) -> 0;
baseid_type(124111) -> 1;
baseid_type(124311) -> 2;
baseid_type(124211) -> 3;
baseid_type(124012) -> 0;
baseid_type(124112) -> 1;
baseid_type(124312) -> 2;
baseid_type(124212) -> 3;
baseid_type(124013) -> 0;
baseid_type(124113) -> 1;
baseid_type(124313) -> 2;
baseid_type(124213) -> 3;
baseid_type(124014) -> 0;
baseid_type(124114) -> 1;
baseid_type(124314) -> 2;
baseid_type(124214) -> 3;
baseid_type(124015) -> 0;
baseid_type(124115) -> 1;
baseid_type(124315) -> 2;
baseid_type(124215) -> 3;
baseid_type(124016) -> 0;
baseid_type(124116) -> 1;
baseid_type(124316) -> 2;
baseid_type(124216) -> 3;
baseid_type(124017) -> 0;
baseid_type(124117) -> 1;
baseid_type(124317) -> 2;
baseid_type(124217) -> 3;
baseid_type(124018) -> 0;
baseid_type(124118) -> 1;
baseid_type(124318) -> 2;
baseid_type(124218) -> 3;
baseid_type(124019) -> 0;
baseid_type(124119) -> 1;
baseid_type(124319) -> 2;
baseid_type(124219) -> 3;
baseid_type(124020) -> 0;
baseid_type(124120) -> 1;
baseid_type(124320) -> 2;
baseid_type(124220) -> 3;
baseid_type(124021) -> 0;
baseid_type(124121) -> 1;
baseid_type(124321) -> 2;
baseid_type(124221) -> 3;
baseid_type(124022) -> 0;
baseid_type(124122) -> 1;
baseid_type(124322) -> 2;
baseid_type(124222) -> 3;
baseid_type(124023) -> 0;
baseid_type(124123) -> 1;
baseid_type(124323) -> 2;
baseid_type(124223) -> 3;
baseid_type(124024) -> 0;
baseid_type(124124) -> 1;
baseid_type(124324) -> 2;
baseid_type(124224) -> 3;
baseid_type(124025) -> 0;
baseid_type(124125) -> 1;
baseid_type(124325) -> 2;
baseid_type(124225) -> 3;
baseid_type(124026) -> 0;
baseid_type(124126) -> 1;
baseid_type(124326) -> 2;
baseid_type(124226) -> 3;
baseid_type(124027) -> 0;
baseid_type(124127) -> 1;
baseid_type(124327) -> 2;
baseid_type(124227) -> 3;
baseid_type(124028) -> 0;
baseid_type(124128) -> 1;
baseid_type(124328) -> 2;
baseid_type(124228) -> 3;
baseid_type(124029) -> 0;
baseid_type(124129) -> 1;
baseid_type(124329) -> 2;
baseid_type(124229) -> 3;
baseid_type(124030) -> 0;
baseid_type(124130) -> 1;
baseid_type(124330) -> 2;
baseid_type(124230) -> 3;
baseid_type(124031) -> 0;
baseid_type(124131) -> 1;
baseid_type(124331) -> 2;
baseid_type(124231) -> 3;
baseid_type(124032) -> 0;
baseid_type(124132) -> 1;
baseid_type(124332) -> 2;
baseid_type(124232) -> 3;
baseid_type(124033) -> 0;
baseid_type(124133) -> 1;
baseid_type(124333) -> 2;
baseid_type(124233) -> 3;
baseid_type(124034) -> 0;
baseid_type(124134) -> 1;
baseid_type(124334) -> 2;
baseid_type(124234) -> 3;
baseid_type(124035) -> 0;
baseid_type(124135) -> 1;
baseid_type(124335) -> 2;
baseid_type(124235) -> 3;
baseid_type(124036) -> 0;
baseid_type(124136) -> 1;
baseid_type(124336) -> 2;
baseid_type(124236) -> 3;
baseid_type(124037) -> 0;
baseid_type(124137) -> 1;
baseid_type(124337) -> 2;
baseid_type(124237) -> 3;
baseid_type(124038) -> 0;
baseid_type(124138) -> 1;
baseid_type(124338) -> 2;
baseid_type(124238) -> 3;
baseid_type(124039) -> 0;
baseid_type(124139) -> 1;
baseid_type(124339) -> 2;
baseid_type(124239) -> 3;
baseid_type(124040) -> 0;
baseid_type(124140) -> 1;
baseid_type(124340) -> 2;
baseid_type(124240) -> 3;
baseid_type(124041) -> 0;
baseid_type(124141) -> 1;
baseid_type(124341) -> 2;
baseid_type(124241) -> 3;
baseid_type(124042) -> 0;
baseid_type(124142) -> 1;
baseid_type(124342) -> 2;
baseid_type(124242) -> 3;
baseid_type(124043) -> 0;
baseid_type(124143) -> 1;
baseid_type(124343) -> 2;
baseid_type(124243) -> 3;
baseid_type(124044) -> 0;
baseid_type(124144) -> 1;
baseid_type(124344) -> 2;
baseid_type(124244) -> 3;
baseid_type(124045) -> 0;
baseid_type(124145) -> 1;
baseid_type(124345) -> 2;
baseid_type(124245) -> 3;
baseid_type(124046) -> 0;
baseid_type(124146) -> 1;
baseid_type(124346) -> 2;
baseid_type(124246) -> 3;
baseid_type(124047) -> 0;
baseid_type(124147) -> 1;
baseid_type(124347) -> 2;
baseid_type(124247) -> 3;
baseid_type(124048) -> 0;
baseid_type(124148) -> 1;
baseid_type(124348) -> 2;
baseid_type(124248) -> 3;
baseid_type(124049) -> 0;
baseid_type(124149) -> 1;
baseid_type(124349) -> 2;
baseid_type(124249) -> 3;
baseid_type(124050) -> 0;
baseid_type(124150) -> 1;
baseid_type(124350) -> 2;
baseid_type(124250) -> 3;
baseid_type(124051) -> 0;
baseid_type(124151) -> 1;
baseid_type(124351) -> 2;
baseid_type(124251) -> 3;
baseid_type(124052) -> 0;
baseid_type(124152) -> 1;
baseid_type(124352) -> 2;
baseid_type(124252) -> 3;
baseid_type(124053) -> 0;
baseid_type(124153) -> 1;
baseid_type(124353) -> 2;
baseid_type(124253) -> 3;
baseid_type(124054) -> 0;
baseid_type(124154) -> 1;
baseid_type(124354) -> 2;
baseid_type(124254) -> 3;
baseid_type(124055) -> 0;
baseid_type(124155) -> 1;
baseid_type(124355) -> 2;
baseid_type(124255) -> 3;
baseid_type(124056) -> 0;
baseid_type(124156) -> 1;
baseid_type(124356) -> 2;
baseid_type(124256) -> 3;
baseid_type(124057) -> 0;
baseid_type(124157) -> 1;
baseid_type(124357) -> 2;
baseid_type(124257) -> 3;
baseid_type(124058) -> 0;
baseid_type(124158) -> 1;
baseid_type(124358) -> 2;
baseid_type(124258) -> 3;
baseid_type(124059) -> 0;
baseid_type(124159) -> 1;
baseid_type(124359) -> 2;
baseid_type(124259) -> 3;
baseid_type(124060) -> 0;
baseid_type(124160) -> 1;
baseid_type(124360) -> 2;
baseid_type(124260) -> 3;
baseid_type(124061) -> 0;
baseid_type(124161) -> 1;
baseid_type(124361) -> 2;
baseid_type(124261) -> 3;
baseid_type(124062) -> 0;
baseid_type(124162) -> 1;
baseid_type(124362) -> 2;
baseid_type(124262) -> 3;
baseid_type(124063) -> 0;
baseid_type(124163) -> 1;
baseid_type(124363) -> 2;
baseid_type(124263) -> 3;
baseid_type(124064) -> 0;
baseid_type(124164) -> 1;
baseid_type(124364) -> 2;
baseid_type(124264) -> 3;
baseid_type(124065) -> 0;
baseid_type(124165) -> 1;
baseid_type(124365) -> 2;
baseid_type(124265) -> 3;
baseid_type(124066) -> 0;
baseid_type(124166) -> 1;
baseid_type(124366) -> 2;
baseid_type(124266) -> 3;
baseid_type(124067) -> 0;
baseid_type(124167) -> 1;
baseid_type(124367) -> 2;
baseid_type(124267) -> 3;
baseid_type(124068) -> 0;
baseid_type(124168) -> 1;
baseid_type(124368) -> 2;
baseid_type(124268) -> 3;
baseid_type(124069) -> 0;
baseid_type(124169) -> 1;
baseid_type(124369) -> 2;
baseid_type(124269) -> 3;
baseid_type(124070) -> 0;
baseid_type(124170) -> 1;
baseid_type(124370) -> 2;
baseid_type(124270) -> 3;
baseid_type(124071) -> 0;
baseid_type(124171) -> 1;
baseid_type(124371) -> 2;
baseid_type(124271) -> 3;
baseid_type(124072) -> 0;
baseid_type(124172) -> 1;
baseid_type(124372) -> 2;
baseid_type(124272) -> 3;
baseid_type(124073) -> 0;
baseid_type(124173) -> 1;
baseid_type(124373) -> 2;
baseid_type(124273) -> 3;
baseid_type(124074) -> 0;
baseid_type(124174) -> 1;
baseid_type(124374) -> 2;
baseid_type(124274) -> 3;
baseid_type(124075) -> 0;
baseid_type(124175) -> 1;
baseid_type(124375) -> 2;
baseid_type(124275) -> 3;
baseid_type(124076) -> 0;
baseid_type(124176) -> 1;
baseid_type(124376) -> 2;
baseid_type(124276) -> 3;
baseid_type(124077) -> 0;
baseid_type(124177) -> 1;
baseid_type(124377) -> 2;
baseid_type(124277) -> 3;
baseid_type(124078) -> 0;
baseid_type(124178) -> 1;
baseid_type(124378) -> 2;
baseid_type(124278) -> 3;
baseid_type(124079) -> 0;
baseid_type(124179) -> 1;
baseid_type(124379) -> 2;
baseid_type(124279) -> 3;
baseid_type(124080) -> 0;
baseid_type(124180) -> 1;
baseid_type(124380) -> 2;
baseid_type(124280) -> 3;
baseid_type(124081) -> 0;
baseid_type(124181) -> 1;
baseid_type(124381) -> 2;
baseid_type(124281) -> 3;
baseid_type(124082) -> 0;
baseid_type(124182) -> 1;
baseid_type(124382) -> 2;
baseid_type(124282) -> 3;
baseid_type(124083) -> 0;
baseid_type(124183) -> 1;
baseid_type(124383) -> 2;
baseid_type(124283) -> 3;
baseid_type(124084) -> 0;
baseid_type(124184) -> 1;
baseid_type(124384) -> 2;
baseid_type(124284) -> 3;
baseid_type(124085) -> 0;
baseid_type(124185) -> 1;
baseid_type(124385) -> 2;
baseid_type(124285) -> 3;
baseid_type(_BaseId) -> 1.

%% 获取宠物外观选择变化数据
get_next_baseid(0, 124100) -> 124000;
get_next_baseid(0, 124300) -> 124000;
get_next_baseid(0, 124200) -> 124000;
get_next_baseid(1, 124000) -> 124100;
get_next_baseid(1, 124300) -> 124100;
get_next_baseid(1, 124200) -> 124100;
get_next_baseid(2, 124000) -> 124300;
get_next_baseid(2, 124100) -> 124300;
get_next_baseid(2, 124200) -> 124300;
get_next_baseid(3, 124000) -> 124200;
get_next_baseid(3, 124100) -> 124200;
get_next_baseid(3, 124300) -> 124200;
get_next_baseid(0, 124101) -> 124001;
get_next_baseid(0, 124301) -> 124001;
get_next_baseid(0, 124201) -> 124001;
get_next_baseid(1, 124001) -> 124101;
get_next_baseid(1, 124301) -> 124101;
get_next_baseid(1, 124201) -> 124101;
get_next_baseid(2, 124001) -> 124301;
get_next_baseid(2, 124101) -> 124301;
get_next_baseid(2, 124201) -> 124301;
get_next_baseid(3, 124001) -> 124201;
get_next_baseid(3, 124101) -> 124201;
get_next_baseid(3, 124301) -> 124201;
get_next_baseid(0, 124102) -> 124002;
get_next_baseid(0, 124302) -> 124002;
get_next_baseid(0, 124202) -> 124002;
get_next_baseid(1, 124002) -> 124102;
get_next_baseid(1, 124302) -> 124102;
get_next_baseid(1, 124202) -> 124102;
get_next_baseid(2, 124002) -> 124302;
get_next_baseid(2, 124102) -> 124302;
get_next_baseid(2, 124202) -> 124302;
get_next_baseid(3, 124002) -> 124202;
get_next_baseid(3, 124102) -> 124202;
get_next_baseid(3, 124302) -> 124202;
get_next_baseid(0, 124103) -> 124003;
get_next_baseid(0, 124303) -> 124003;
get_next_baseid(0, 124203) -> 124003;
get_next_baseid(1, 124003) -> 124103;
get_next_baseid(1, 124303) -> 124103;
get_next_baseid(1, 124203) -> 124103;
get_next_baseid(2, 124003) -> 124303;
get_next_baseid(2, 124103) -> 124303;
get_next_baseid(2, 124203) -> 124303;
get_next_baseid(3, 124003) -> 124203;
get_next_baseid(3, 124103) -> 124203;
get_next_baseid(3, 124303) -> 124203;
get_next_baseid(0, 124104) -> 124004;
get_next_baseid(0, 124304) -> 124004;
get_next_baseid(0, 124204) -> 124004;
get_next_baseid(1, 124004) -> 124104;
get_next_baseid(1, 124304) -> 124104;
get_next_baseid(1, 124204) -> 124104;
get_next_baseid(2, 124004) -> 124304;
get_next_baseid(2, 124104) -> 124304;
get_next_baseid(2, 124204) -> 124304;
get_next_baseid(3, 124004) -> 124204;
get_next_baseid(3, 124104) -> 124204;
get_next_baseid(3, 124304) -> 124204;
get_next_baseid(0, 124105) -> 124005;
get_next_baseid(0, 124305) -> 124005;
get_next_baseid(0, 124205) -> 124005;
get_next_baseid(1, 124005) -> 124105;
get_next_baseid(1, 124305) -> 124105;
get_next_baseid(1, 124205) -> 124105;
get_next_baseid(2, 124005) -> 124305;
get_next_baseid(2, 124105) -> 124305;
get_next_baseid(2, 124205) -> 124305;
get_next_baseid(3, 124005) -> 124205;
get_next_baseid(3, 124105) -> 124205;
get_next_baseid(3, 124305) -> 124205;
get_next_baseid(0, 124106) -> 124006;
get_next_baseid(0, 124306) -> 124006;
get_next_baseid(0, 124206) -> 124006;
get_next_baseid(1, 124006) -> 124106;
get_next_baseid(1, 124306) -> 124106;
get_next_baseid(1, 124206) -> 124106;
get_next_baseid(2, 124006) -> 124306;
get_next_baseid(2, 124106) -> 124306;
get_next_baseid(2, 124206) -> 124306;
get_next_baseid(3, 124006) -> 124206;
get_next_baseid(3, 124106) -> 124206;
get_next_baseid(3, 124306) -> 124206;
get_next_baseid(0, 124107) -> 124007;
get_next_baseid(0, 124307) -> 124007;
get_next_baseid(0, 124207) -> 124007;
get_next_baseid(1, 124007) -> 124107;
get_next_baseid(1, 124307) -> 124107;
get_next_baseid(1, 124207) -> 124107;
get_next_baseid(2, 124007) -> 124307;
get_next_baseid(2, 124107) -> 124307;
get_next_baseid(2, 124207) -> 124307;
get_next_baseid(3, 124007) -> 124207;
get_next_baseid(3, 124107) -> 124207;
get_next_baseid(3, 124307) -> 124207;
get_next_baseid(0, 124108) -> 124008;
get_next_baseid(0, 124308) -> 124008;
get_next_baseid(0, 124208) -> 124008;
get_next_baseid(1, 124008) -> 124108;
get_next_baseid(1, 124308) -> 124108;
get_next_baseid(1, 124208) -> 124108;
get_next_baseid(2, 124008) -> 124308;
get_next_baseid(2, 124108) -> 124308;
get_next_baseid(2, 124208) -> 124308;
get_next_baseid(3, 124008) -> 124208;
get_next_baseid(3, 124108) -> 124208;
get_next_baseid(3, 124308) -> 124208;
get_next_baseid(0, 124109) -> 124009;
get_next_baseid(0, 124309) -> 124009;
get_next_baseid(0, 124209) -> 124009;
get_next_baseid(1, 124009) -> 124109;
get_next_baseid(1, 124309) -> 124109;
get_next_baseid(1, 124209) -> 124109;
get_next_baseid(2, 124009) -> 124309;
get_next_baseid(2, 124109) -> 124309;
get_next_baseid(2, 124209) -> 124309;
get_next_baseid(3, 124009) -> 124209;
get_next_baseid(3, 124109) -> 124209;
get_next_baseid(3, 124309) -> 124209;
get_next_baseid(0, 124110) -> 124010;
get_next_baseid(0, 124310) -> 124010;
get_next_baseid(0, 124210) -> 124010;
get_next_baseid(1, 124010) -> 124110;
get_next_baseid(1, 124310) -> 124110;
get_next_baseid(1, 124210) -> 124110;
get_next_baseid(2, 124010) -> 124310;
get_next_baseid(2, 124110) -> 124310;
get_next_baseid(2, 124210) -> 124310;
get_next_baseid(3, 124010) -> 124210;
get_next_baseid(3, 124110) -> 124210;
get_next_baseid(3, 124310) -> 124210;
get_next_baseid(0, 124111) -> 124011;
get_next_baseid(0, 124311) -> 124011;
get_next_baseid(0, 124211) -> 124011;
get_next_baseid(1, 124011) -> 124111;
get_next_baseid(1, 124311) -> 124111;
get_next_baseid(1, 124211) -> 124111;
get_next_baseid(2, 124011) -> 124311;
get_next_baseid(2, 124111) -> 124311;
get_next_baseid(2, 124211) -> 124311;
get_next_baseid(3, 124011) -> 124211;
get_next_baseid(3, 124111) -> 124211;
get_next_baseid(3, 124311) -> 124211;
get_next_baseid(0, 124112) -> 124012;
get_next_baseid(0, 124312) -> 124012;
get_next_baseid(0, 124212) -> 124012;
get_next_baseid(1, 124012) -> 124112;
get_next_baseid(1, 124312) -> 124112;
get_next_baseid(1, 124212) -> 124112;
get_next_baseid(2, 124012) -> 124312;
get_next_baseid(2, 124112) -> 124312;
get_next_baseid(2, 124212) -> 124312;
get_next_baseid(3, 124012) -> 124212;
get_next_baseid(3, 124112) -> 124212;
get_next_baseid(3, 124312) -> 124212;
get_next_baseid(0, 124113) -> 124013;
get_next_baseid(0, 124313) -> 124013;
get_next_baseid(0, 124213) -> 124013;
get_next_baseid(1, 124013) -> 124113;
get_next_baseid(1, 124313) -> 124113;
get_next_baseid(1, 124213) -> 124113;
get_next_baseid(2, 124013) -> 124313;
get_next_baseid(2, 124113) -> 124313;
get_next_baseid(2, 124213) -> 124313;
get_next_baseid(3, 124013) -> 124213;
get_next_baseid(3, 124113) -> 124213;
get_next_baseid(3, 124313) -> 124213;
get_next_baseid(0, 124114) -> 124014;
get_next_baseid(0, 124314) -> 124014;
get_next_baseid(0, 124214) -> 124014;
get_next_baseid(1, 124014) -> 124114;
get_next_baseid(1, 124314) -> 124114;
get_next_baseid(1, 124214) -> 124114;
get_next_baseid(2, 124014) -> 124314;
get_next_baseid(2, 124114) -> 124314;
get_next_baseid(2, 124214) -> 124314;
get_next_baseid(3, 124014) -> 124214;
get_next_baseid(3, 124114) -> 124214;
get_next_baseid(3, 124314) -> 124214;
get_next_baseid(0, 124115) -> 124015;
get_next_baseid(0, 124315) -> 124015;
get_next_baseid(0, 124215) -> 124015;
get_next_baseid(1, 124015) -> 124115;
get_next_baseid(1, 124315) -> 124115;
get_next_baseid(1, 124215) -> 124115;
get_next_baseid(2, 124015) -> 124315;
get_next_baseid(2, 124115) -> 124315;
get_next_baseid(2, 124215) -> 124315;
get_next_baseid(3, 124015) -> 124215;
get_next_baseid(3, 124115) -> 124215;
get_next_baseid(3, 124315) -> 124215;
get_next_baseid(0, 124116) -> 124016;
get_next_baseid(0, 124316) -> 124016;
get_next_baseid(0, 124216) -> 124016;
get_next_baseid(1, 124016) -> 124116;
get_next_baseid(1, 124316) -> 124116;
get_next_baseid(1, 124216) -> 124116;
get_next_baseid(2, 124016) -> 124316;
get_next_baseid(2, 124116) -> 124316;
get_next_baseid(2, 124216) -> 124316;
get_next_baseid(3, 124016) -> 124216;
get_next_baseid(3, 124116) -> 124216;
get_next_baseid(3, 124316) -> 124216;
get_next_baseid(0, 124117) -> 124017;
get_next_baseid(0, 124317) -> 124017;
get_next_baseid(0, 124217) -> 124017;
get_next_baseid(1, 124017) -> 124117;
get_next_baseid(1, 124317) -> 124117;
get_next_baseid(1, 124217) -> 124117;
get_next_baseid(2, 124017) -> 124317;
get_next_baseid(2, 124117) -> 124317;
get_next_baseid(2, 124217) -> 124317;
get_next_baseid(3, 124017) -> 124217;
get_next_baseid(3, 124117) -> 124217;
get_next_baseid(3, 124317) -> 124217;
get_next_baseid(0, 124118) -> 124018;
get_next_baseid(0, 124318) -> 124018;
get_next_baseid(0, 124218) -> 124018;
get_next_baseid(1, 124018) -> 124118;
get_next_baseid(1, 124318) -> 124118;
get_next_baseid(1, 124218) -> 124118;
get_next_baseid(2, 124018) -> 124318;
get_next_baseid(2, 124118) -> 124318;
get_next_baseid(2, 124218) -> 124318;
get_next_baseid(3, 124018) -> 124218;
get_next_baseid(3, 124118) -> 124218;
get_next_baseid(3, 124318) -> 124218;
get_next_baseid(0, 124119) -> 124019;
get_next_baseid(0, 124319) -> 124019;
get_next_baseid(0, 124219) -> 124019;
get_next_baseid(1, 124019) -> 124119;
get_next_baseid(1, 124319) -> 124119;
get_next_baseid(1, 124219) -> 124119;
get_next_baseid(2, 124019) -> 124319;
get_next_baseid(2, 124119) -> 124319;
get_next_baseid(2, 124219) -> 124319;
get_next_baseid(3, 124019) -> 124219;
get_next_baseid(3, 124119) -> 124219;
get_next_baseid(3, 124319) -> 124219;
get_next_baseid(0, 124120) -> 124020;
get_next_baseid(0, 124320) -> 124020;
get_next_baseid(0, 124220) -> 124020;
get_next_baseid(1, 124020) -> 124120;
get_next_baseid(1, 124320) -> 124120;
get_next_baseid(1, 124220) -> 124120;
get_next_baseid(2, 124020) -> 124320;
get_next_baseid(2, 124120) -> 124320;
get_next_baseid(2, 124220) -> 124320;
get_next_baseid(3, 124020) -> 124220;
get_next_baseid(3, 124120) -> 124220;
get_next_baseid(3, 124320) -> 124220;
get_next_baseid(0, 124121) -> 124021;
get_next_baseid(0, 124321) -> 124021;
get_next_baseid(0, 124221) -> 124021;
get_next_baseid(1, 124021) -> 124121;
get_next_baseid(1, 124321) -> 124121;
get_next_baseid(1, 124221) -> 124121;
get_next_baseid(2, 124021) -> 124321;
get_next_baseid(2, 124121) -> 124321;
get_next_baseid(2, 124221) -> 124321;
get_next_baseid(3, 124021) -> 124221;
get_next_baseid(3, 124121) -> 124221;
get_next_baseid(3, 124321) -> 124221;
get_next_baseid(0, 124122) -> 124022;
get_next_baseid(0, 124322) -> 124022;
get_next_baseid(0, 124222) -> 124022;
get_next_baseid(1, 124022) -> 124122;
get_next_baseid(1, 124322) -> 124122;
get_next_baseid(1, 124222) -> 124122;
get_next_baseid(2, 124022) -> 124322;
get_next_baseid(2, 124122) -> 124322;
get_next_baseid(2, 124222) -> 124322;
get_next_baseid(3, 124022) -> 124222;
get_next_baseid(3, 124122) -> 124222;
get_next_baseid(3, 124322) -> 124222;
get_next_baseid(0, 124123) -> 124023;
get_next_baseid(0, 124323) -> 124023;
get_next_baseid(0, 124223) -> 124023;
get_next_baseid(1, 124023) -> 124123;
get_next_baseid(1, 124323) -> 124123;
get_next_baseid(1, 124223) -> 124123;
get_next_baseid(2, 124023) -> 124323;
get_next_baseid(2, 124123) -> 124323;
get_next_baseid(2, 124223) -> 124323;
get_next_baseid(3, 124023) -> 124223;
get_next_baseid(3, 124123) -> 124223;
get_next_baseid(3, 124323) -> 124223;
get_next_baseid(0, 124124) -> 124024;
get_next_baseid(0, 124324) -> 124024;
get_next_baseid(0, 124224) -> 124024;
get_next_baseid(1, 124024) -> 124124;
get_next_baseid(1, 124324) -> 124124;
get_next_baseid(1, 124224) -> 124124;
get_next_baseid(2, 124024) -> 124324;
get_next_baseid(2, 124124) -> 124324;
get_next_baseid(2, 124224) -> 124324;
get_next_baseid(3, 124024) -> 124224;
get_next_baseid(3, 124124) -> 124224;
get_next_baseid(3, 124324) -> 124224;
get_next_baseid(0, 124125) -> 124025;
get_next_baseid(0, 124325) -> 124025;
get_next_baseid(0, 124225) -> 124025;
get_next_baseid(1, 124025) -> 124125;
get_next_baseid(1, 124325) -> 124125;
get_next_baseid(1, 124225) -> 124125;
get_next_baseid(2, 124025) -> 124325;
get_next_baseid(2, 124125) -> 124325;
get_next_baseid(2, 124225) -> 124325;
get_next_baseid(3, 124025) -> 124225;
get_next_baseid(3, 124125) -> 124225;
get_next_baseid(3, 124325) -> 124225;
get_next_baseid(0, 124126) -> 124026;
get_next_baseid(0, 124326) -> 124026;
get_next_baseid(0, 124226) -> 124026;
get_next_baseid(1, 124026) -> 124126;
get_next_baseid(1, 124326) -> 124126;
get_next_baseid(1, 124226) -> 124126;
get_next_baseid(2, 124026) -> 124326;
get_next_baseid(2, 124126) -> 124326;
get_next_baseid(2, 124226) -> 124326;
get_next_baseid(3, 124026) -> 124226;
get_next_baseid(3, 124126) -> 124226;
get_next_baseid(3, 124326) -> 124226;
get_next_baseid(0, 124127) -> 124027;
get_next_baseid(0, 124327) -> 124027;
get_next_baseid(0, 124227) -> 124027;
get_next_baseid(1, 124027) -> 124127;
get_next_baseid(1, 124327) -> 124127;
get_next_baseid(1, 124227) -> 124127;
get_next_baseid(2, 124027) -> 124327;
get_next_baseid(2, 124127) -> 124327;
get_next_baseid(2, 124227) -> 124327;
get_next_baseid(3, 124027) -> 124227;
get_next_baseid(3, 124127) -> 124227;
get_next_baseid(3, 124327) -> 124227;
get_next_baseid(0, 124128) -> 124028;
get_next_baseid(0, 124328) -> 124028;
get_next_baseid(0, 124228) -> 124028;
get_next_baseid(1, 124028) -> 124128;
get_next_baseid(1, 124328) -> 124128;
get_next_baseid(1, 124228) -> 124128;
get_next_baseid(2, 124028) -> 124328;
get_next_baseid(2, 124128) -> 124328;
get_next_baseid(2, 124228) -> 124328;
get_next_baseid(3, 124028) -> 124228;
get_next_baseid(3, 124128) -> 124228;
get_next_baseid(3, 124328) -> 124228;
get_next_baseid(0, 124129) -> 124029;
get_next_baseid(0, 124329) -> 124029;
get_next_baseid(0, 124229) -> 124029;
get_next_baseid(1, 124029) -> 124129;
get_next_baseid(1, 124329) -> 124129;
get_next_baseid(1, 124229) -> 124129;
get_next_baseid(2, 124029) -> 124329;
get_next_baseid(2, 124129) -> 124329;
get_next_baseid(2, 124229) -> 124329;
get_next_baseid(3, 124029) -> 124229;
get_next_baseid(3, 124129) -> 124229;
get_next_baseid(3, 124329) -> 124229;
get_next_baseid(0, 124130) -> 124030;
get_next_baseid(0, 124330) -> 124030;
get_next_baseid(0, 124230) -> 124030;
get_next_baseid(1, 124030) -> 124130;
get_next_baseid(1, 124330) -> 124130;
get_next_baseid(1, 124230) -> 124130;
get_next_baseid(2, 124030) -> 124330;
get_next_baseid(2, 124130) -> 124330;
get_next_baseid(2, 124230) -> 124330;
get_next_baseid(3, 124030) -> 124230;
get_next_baseid(3, 124130) -> 124230;
get_next_baseid(3, 124330) -> 124230;
get_next_baseid(0, 124131) -> 124031;
get_next_baseid(0, 124331) -> 124031;
get_next_baseid(0, 124231) -> 124031;
get_next_baseid(1, 124031) -> 124131;
get_next_baseid(1, 124331) -> 124131;
get_next_baseid(1, 124231) -> 124131;
get_next_baseid(2, 124031) -> 124331;
get_next_baseid(2, 124131) -> 124331;
get_next_baseid(2, 124231) -> 124331;
get_next_baseid(3, 124031) -> 124231;
get_next_baseid(3, 124131) -> 124231;
get_next_baseid(3, 124331) -> 124231;
get_next_baseid(0, 124132) -> 124032;
get_next_baseid(0, 124332) -> 124032;
get_next_baseid(0, 124232) -> 124032;
get_next_baseid(1, 124032) -> 124132;
get_next_baseid(1, 124332) -> 124132;
get_next_baseid(1, 124232) -> 124132;
get_next_baseid(2, 124032) -> 124332;
get_next_baseid(2, 124132) -> 124332;
get_next_baseid(2, 124232) -> 124332;
get_next_baseid(3, 124032) -> 124232;
get_next_baseid(3, 124132) -> 124232;
get_next_baseid(3, 124332) -> 124232;
get_next_baseid(0, 124133) -> 124033;
get_next_baseid(0, 124333) -> 124033;
get_next_baseid(0, 124233) -> 124033;
get_next_baseid(1, 124033) -> 124133;
get_next_baseid(1, 124333) -> 124133;
get_next_baseid(1, 124233) -> 124133;
get_next_baseid(2, 124033) -> 124333;
get_next_baseid(2, 124133) -> 124333;
get_next_baseid(2, 124233) -> 124333;
get_next_baseid(3, 124033) -> 124233;
get_next_baseid(3, 124133) -> 124233;
get_next_baseid(3, 124333) -> 124233;
get_next_baseid(0, 124134) -> 124034;
get_next_baseid(0, 124334) -> 124034;
get_next_baseid(0, 124234) -> 124034;
get_next_baseid(1, 124034) -> 124134;
get_next_baseid(1, 124334) -> 124134;
get_next_baseid(1, 124234) -> 124134;
get_next_baseid(2, 124034) -> 124334;
get_next_baseid(2, 124134) -> 124334;
get_next_baseid(2, 124234) -> 124334;
get_next_baseid(3, 124034) -> 124234;
get_next_baseid(3, 124134) -> 124234;
get_next_baseid(3, 124334) -> 124234;
get_next_baseid(0, 124135) -> 124035;
get_next_baseid(0, 124335) -> 124035;
get_next_baseid(0, 124235) -> 124035;
get_next_baseid(1, 124035) -> 124135;
get_next_baseid(1, 124335) -> 124135;
get_next_baseid(1, 124235) -> 124135;
get_next_baseid(2, 124035) -> 124335;
get_next_baseid(2, 124135) -> 124335;
get_next_baseid(2, 124235) -> 124335;
get_next_baseid(3, 124035) -> 124235;
get_next_baseid(3, 124135) -> 124235;
get_next_baseid(3, 124335) -> 124235;
get_next_baseid(0, 124136) -> 124036;
get_next_baseid(0, 124336) -> 124036;
get_next_baseid(0, 124236) -> 124036;
get_next_baseid(1, 124036) -> 124136;
get_next_baseid(1, 124336) -> 124136;
get_next_baseid(1, 124236) -> 124136;
get_next_baseid(2, 124036) -> 124336;
get_next_baseid(2, 124136) -> 124336;
get_next_baseid(2, 124236) -> 124336;
get_next_baseid(3, 124036) -> 124236;
get_next_baseid(3, 124136) -> 124236;
get_next_baseid(3, 124336) -> 124236;
get_next_baseid(0, 124137) -> 124037;
get_next_baseid(0, 124337) -> 124037;
get_next_baseid(0, 124237) -> 124037;
get_next_baseid(1, 124037) -> 124137;
get_next_baseid(1, 124337) -> 124137;
get_next_baseid(1, 124237) -> 124137;
get_next_baseid(2, 124037) -> 124337;
get_next_baseid(2, 124137) -> 124337;
get_next_baseid(2, 124237) -> 124337;
get_next_baseid(3, 124037) -> 124237;
get_next_baseid(3, 124137) -> 124237;
get_next_baseid(3, 124337) -> 124237;
get_next_baseid(0, 124138) -> 124038;
get_next_baseid(0, 124338) -> 124038;
get_next_baseid(0, 124238) -> 124038;
get_next_baseid(1, 124038) -> 124138;
get_next_baseid(1, 124338) -> 124138;
get_next_baseid(1, 124238) -> 124138;
get_next_baseid(2, 124038) -> 124338;
get_next_baseid(2, 124138) -> 124338;
get_next_baseid(2, 124238) -> 124338;
get_next_baseid(3, 124038) -> 124238;
get_next_baseid(3, 124138) -> 124238;
get_next_baseid(3, 124338) -> 124238;
get_next_baseid(0, 124139) -> 124039;
get_next_baseid(0, 124339) -> 124039;
get_next_baseid(0, 124239) -> 124039;
get_next_baseid(1, 124039) -> 124139;
get_next_baseid(1, 124339) -> 124139;
get_next_baseid(1, 124239) -> 124139;
get_next_baseid(2, 124039) -> 124339;
get_next_baseid(2, 124139) -> 124339;
get_next_baseid(2, 124239) -> 124339;
get_next_baseid(3, 124039) -> 124239;
get_next_baseid(3, 124139) -> 124239;
get_next_baseid(3, 124339) -> 124239;
get_next_baseid(0, 124140) -> 124040;
get_next_baseid(0, 124340) -> 124040;
get_next_baseid(0, 124240) -> 124040;
get_next_baseid(1, 124040) -> 124140;
get_next_baseid(1, 124340) -> 124140;
get_next_baseid(1, 124240) -> 124140;
get_next_baseid(2, 124040) -> 124340;
get_next_baseid(2, 124140) -> 124340;
get_next_baseid(2, 124240) -> 124340;
get_next_baseid(3, 124040) -> 124240;
get_next_baseid(3, 124140) -> 124240;
get_next_baseid(3, 124340) -> 124240;
get_next_baseid(0, 124141) -> 124041;
get_next_baseid(0, 124341) -> 124041;
get_next_baseid(0, 124241) -> 124041;
get_next_baseid(1, 124041) -> 124141;
get_next_baseid(1, 124341) -> 124141;
get_next_baseid(1, 124241) -> 124141;
get_next_baseid(2, 124041) -> 124341;
get_next_baseid(2, 124141) -> 124341;
get_next_baseid(2, 124241) -> 124341;
get_next_baseid(3, 124041) -> 124241;
get_next_baseid(3, 124141) -> 124241;
get_next_baseid(3, 124341) -> 124241;
get_next_baseid(0, 124142) -> 124042;
get_next_baseid(0, 124342) -> 124042;
get_next_baseid(0, 124242) -> 124042;
get_next_baseid(1, 124042) -> 124142;
get_next_baseid(1, 124342) -> 124142;
get_next_baseid(1, 124242) -> 124142;
get_next_baseid(2, 124042) -> 124342;
get_next_baseid(2, 124142) -> 124342;
get_next_baseid(2, 124242) -> 124342;
get_next_baseid(3, 124042) -> 124242;
get_next_baseid(3, 124142) -> 124242;
get_next_baseid(3, 124342) -> 124242;
get_next_baseid(0, 124143) -> 124043;
get_next_baseid(0, 124343) -> 124043;
get_next_baseid(0, 124243) -> 124043;
get_next_baseid(1, 124043) -> 124143;
get_next_baseid(1, 124343) -> 124143;
get_next_baseid(1, 124243) -> 124143;
get_next_baseid(2, 124043) -> 124343;
get_next_baseid(2, 124143) -> 124343;
get_next_baseid(2, 124243) -> 124343;
get_next_baseid(3, 124043) -> 124243;
get_next_baseid(3, 124143) -> 124243;
get_next_baseid(3, 124343) -> 124243;
get_next_baseid(0, 124144) -> 124044;
get_next_baseid(0, 124344) -> 124044;
get_next_baseid(0, 124244) -> 124044;
get_next_baseid(1, 124044) -> 124144;
get_next_baseid(1, 124344) -> 124144;
get_next_baseid(1, 124244) -> 124144;
get_next_baseid(2, 124044) -> 124344;
get_next_baseid(2, 124144) -> 124344;
get_next_baseid(2, 124244) -> 124344;
get_next_baseid(3, 124044) -> 124244;
get_next_baseid(3, 124144) -> 124244;
get_next_baseid(3, 124344) -> 124244;
get_next_baseid(0, 124145) -> 124045;
get_next_baseid(0, 124345) -> 124045;
get_next_baseid(0, 124245) -> 124045;
get_next_baseid(1, 124045) -> 124145;
get_next_baseid(1, 124345) -> 124145;
get_next_baseid(1, 124245) -> 124145;
get_next_baseid(2, 124045) -> 124345;
get_next_baseid(2, 124145) -> 124345;
get_next_baseid(2, 124245) -> 124345;
get_next_baseid(3, 124045) -> 124245;
get_next_baseid(3, 124145) -> 124245;
get_next_baseid(3, 124345) -> 124245;
get_next_baseid(0, 124146) -> 124046;
get_next_baseid(0, 124346) -> 124046;
get_next_baseid(0, 124246) -> 124046;
get_next_baseid(1, 124046) -> 124146;
get_next_baseid(1, 124346) -> 124146;
get_next_baseid(1, 124246) -> 124146;
get_next_baseid(2, 124046) -> 124346;
get_next_baseid(2, 124146) -> 124346;
get_next_baseid(2, 124246) -> 124346;
get_next_baseid(3, 124046) -> 124246;
get_next_baseid(3, 124146) -> 124246;
get_next_baseid(3, 124346) -> 124246;
get_next_baseid(0, 124147) -> 124047;
get_next_baseid(0, 124347) -> 124047;
get_next_baseid(0, 124247) -> 124047;
get_next_baseid(1, 124047) -> 124147;
get_next_baseid(1, 124347) -> 124147;
get_next_baseid(1, 124247) -> 124147;
get_next_baseid(2, 124047) -> 124347;
get_next_baseid(2, 124147) -> 124347;
get_next_baseid(2, 124247) -> 124347;
get_next_baseid(3, 124047) -> 124247;
get_next_baseid(3, 124147) -> 124247;
get_next_baseid(3, 124347) -> 124247;
get_next_baseid(0, 124148) -> 124048;
get_next_baseid(0, 124348) -> 124048;
get_next_baseid(0, 124248) -> 124048;
get_next_baseid(1, 124048) -> 124148;
get_next_baseid(1, 124348) -> 124148;
get_next_baseid(1, 124248) -> 124148;
get_next_baseid(2, 124048) -> 124348;
get_next_baseid(2, 124148) -> 124348;
get_next_baseid(2, 124248) -> 124348;
get_next_baseid(3, 124048) -> 124248;
get_next_baseid(3, 124148) -> 124248;
get_next_baseid(3, 124348) -> 124248;
get_next_baseid(0, 124149) -> 124049;
get_next_baseid(0, 124349) -> 124049;
get_next_baseid(0, 124249) -> 124049;
get_next_baseid(1, 124049) -> 124149;
get_next_baseid(1, 124349) -> 124149;
get_next_baseid(1, 124249) -> 124149;
get_next_baseid(2, 124049) -> 124349;
get_next_baseid(2, 124149) -> 124349;
get_next_baseid(2, 124249) -> 124349;
get_next_baseid(3, 124049) -> 124249;
get_next_baseid(3, 124149) -> 124249;
get_next_baseid(3, 124349) -> 124249;
get_next_baseid(0, 124150) -> 124050;
get_next_baseid(0, 124350) -> 124050;
get_next_baseid(0, 124250) -> 124050;
get_next_baseid(1, 124050) -> 124150;
get_next_baseid(1, 124350) -> 124150;
get_next_baseid(1, 124250) -> 124150;
get_next_baseid(2, 124050) -> 124350;
get_next_baseid(2, 124150) -> 124350;
get_next_baseid(2, 124250) -> 124350;
get_next_baseid(3, 124050) -> 124250;
get_next_baseid(3, 124150) -> 124250;
get_next_baseid(3, 124350) -> 124250;
get_next_baseid(0, 124151) -> 124051;
get_next_baseid(0, 124351) -> 124051;
get_next_baseid(0, 124251) -> 124051;
get_next_baseid(1, 124051) -> 124151;
get_next_baseid(1, 124351) -> 124151;
get_next_baseid(1, 124251) -> 124151;
get_next_baseid(2, 124051) -> 124351;
get_next_baseid(2, 124151) -> 124351;
get_next_baseid(2, 124251) -> 124351;
get_next_baseid(3, 124051) -> 124251;
get_next_baseid(3, 124151) -> 124251;
get_next_baseid(3, 124351) -> 124251;
get_next_baseid(0, 124152) -> 124052;
get_next_baseid(0, 124352) -> 124052;
get_next_baseid(0, 124252) -> 124052;
get_next_baseid(1, 124052) -> 124152;
get_next_baseid(1, 124352) -> 124152;
get_next_baseid(1, 124252) -> 124152;
get_next_baseid(2, 124052) -> 124352;
get_next_baseid(2, 124152) -> 124352;
get_next_baseid(2, 124252) -> 124352;
get_next_baseid(3, 124052) -> 124252;
get_next_baseid(3, 124152) -> 124252;
get_next_baseid(3, 124352) -> 124252;
get_next_baseid(0, 124153) -> 124053;
get_next_baseid(0, 124353) -> 124053;
get_next_baseid(0, 124253) -> 124053;
get_next_baseid(1, 124053) -> 124153;
get_next_baseid(1, 124353) -> 124153;
get_next_baseid(1, 124253) -> 124153;
get_next_baseid(2, 124053) -> 124353;
get_next_baseid(2, 124153) -> 124353;
get_next_baseid(2, 124253) -> 124353;
get_next_baseid(3, 124053) -> 124253;
get_next_baseid(3, 124153) -> 124253;
get_next_baseid(3, 124353) -> 124253;
get_next_baseid(0, 124154) -> 124054;
get_next_baseid(0, 124354) -> 124054;
get_next_baseid(0, 124254) -> 124054;
get_next_baseid(1, 124054) -> 124154;
get_next_baseid(1, 124354) -> 124154;
get_next_baseid(1, 124254) -> 124154;
get_next_baseid(2, 124054) -> 124354;
get_next_baseid(2, 124154) -> 124354;
get_next_baseid(2, 124254) -> 124354;
get_next_baseid(3, 124054) -> 124254;
get_next_baseid(3, 124154) -> 124254;
get_next_baseid(3, 124354) -> 124254;
get_next_baseid(0, 124155) -> 124055;
get_next_baseid(0, 124355) -> 124055;
get_next_baseid(0, 124255) -> 124055;
get_next_baseid(1, 124055) -> 124155;
get_next_baseid(1, 124355) -> 124155;
get_next_baseid(1, 124255) -> 124155;
get_next_baseid(2, 124055) -> 124355;
get_next_baseid(2, 124155) -> 124355;
get_next_baseid(2, 124255) -> 124355;
get_next_baseid(3, 124055) -> 124255;
get_next_baseid(3, 124155) -> 124255;
get_next_baseid(3, 124355) -> 124255;
get_next_baseid(0, 124156) -> 124056;
get_next_baseid(0, 124356) -> 124056;
get_next_baseid(0, 124256) -> 124056;
get_next_baseid(1, 124056) -> 124156;
get_next_baseid(1, 124356) -> 124156;
get_next_baseid(1, 124256) -> 124156;
get_next_baseid(2, 124056) -> 124356;
get_next_baseid(2, 124156) -> 124356;
get_next_baseid(2, 124256) -> 124356;
get_next_baseid(3, 124056) -> 124256;
get_next_baseid(3, 124156) -> 124256;
get_next_baseid(3, 124356) -> 124256;
get_next_baseid(0, 124157) -> 124057;
get_next_baseid(0, 124357) -> 124057;
get_next_baseid(0, 124257) -> 124057;
get_next_baseid(1, 124057) -> 124157;
get_next_baseid(1, 124357) -> 124157;
get_next_baseid(1, 124257) -> 124157;
get_next_baseid(2, 124057) -> 124357;
get_next_baseid(2, 124157) -> 124357;
get_next_baseid(2, 124257) -> 124357;
get_next_baseid(3, 124057) -> 124257;
get_next_baseid(3, 124157) -> 124257;
get_next_baseid(3, 124357) -> 124257;
get_next_baseid(0, 124158) -> 124058;
get_next_baseid(0, 124358) -> 124058;
get_next_baseid(0, 124258) -> 124058;
get_next_baseid(1, 124058) -> 124158;
get_next_baseid(1, 124358) -> 124158;
get_next_baseid(1, 124258) -> 124158;
get_next_baseid(2, 124058) -> 124358;
get_next_baseid(2, 124158) -> 124358;
get_next_baseid(2, 124258) -> 124358;
get_next_baseid(3, 124058) -> 124258;
get_next_baseid(3, 124158) -> 124258;
get_next_baseid(3, 124358) -> 124258;
get_next_baseid(0, 124159) -> 124059;
get_next_baseid(0, 124359) -> 124059;
get_next_baseid(0, 124259) -> 124059;
get_next_baseid(1, 124059) -> 124159;
get_next_baseid(1, 124359) -> 124159;
get_next_baseid(1, 124259) -> 124159;
get_next_baseid(2, 124059) -> 124359;
get_next_baseid(2, 124159) -> 124359;
get_next_baseid(2, 124259) -> 124359;
get_next_baseid(3, 124059) -> 124259;
get_next_baseid(3, 124159) -> 124259;
get_next_baseid(3, 124359) -> 124259;
get_next_baseid(0, 124160) -> 124060;
get_next_baseid(0, 124360) -> 124060;
get_next_baseid(0, 124260) -> 124060;
get_next_baseid(1, 124060) -> 124160;
get_next_baseid(1, 124360) -> 124160;
get_next_baseid(1, 124260) -> 124160;
get_next_baseid(2, 124060) -> 124360;
get_next_baseid(2, 124160) -> 124360;
get_next_baseid(2, 124260) -> 124360;
get_next_baseid(3, 124060) -> 124260;
get_next_baseid(3, 124160) -> 124260;
get_next_baseid(3, 124360) -> 124260;
get_next_baseid(0, 124161) -> 124061;
get_next_baseid(0, 124361) -> 124061;
get_next_baseid(0, 124261) -> 124061;
get_next_baseid(1, 124061) -> 124161;
get_next_baseid(1, 124361) -> 124161;
get_next_baseid(1, 124261) -> 124161;
get_next_baseid(2, 124061) -> 124361;
get_next_baseid(2, 124161) -> 124361;
get_next_baseid(2, 124261) -> 124361;
get_next_baseid(3, 124061) -> 124261;
get_next_baseid(3, 124161) -> 124261;
get_next_baseid(3, 124361) -> 124261;
get_next_baseid(0, 124162) -> 124062;
get_next_baseid(0, 124362) -> 124062;
get_next_baseid(0, 124262) -> 124062;
get_next_baseid(1, 124062) -> 124162;
get_next_baseid(1, 124362) -> 124162;
get_next_baseid(1, 124262) -> 124162;
get_next_baseid(2, 124062) -> 124362;
get_next_baseid(2, 124162) -> 124362;
get_next_baseid(2, 124262) -> 124362;
get_next_baseid(3, 124062) -> 124262;
get_next_baseid(3, 124162) -> 124262;
get_next_baseid(3, 124362) -> 124262;
get_next_baseid(0, 124163) -> 124063;
get_next_baseid(0, 124363) -> 124063;
get_next_baseid(0, 124263) -> 124063;
get_next_baseid(1, 124063) -> 124163;
get_next_baseid(1, 124363) -> 124163;
get_next_baseid(1, 124263) -> 124163;
get_next_baseid(2, 124063) -> 124363;
get_next_baseid(2, 124163) -> 124363;
get_next_baseid(2, 124263) -> 124363;
get_next_baseid(3, 124063) -> 124263;
get_next_baseid(3, 124163) -> 124263;
get_next_baseid(3, 124363) -> 124263;
get_next_baseid(0, 124164) -> 124064;
get_next_baseid(0, 124364) -> 124064;
get_next_baseid(0, 124264) -> 124064;
get_next_baseid(1, 124064) -> 124164;
get_next_baseid(1, 124364) -> 124164;
get_next_baseid(1, 124264) -> 124164;
get_next_baseid(2, 124064) -> 124364;
get_next_baseid(2, 124164) -> 124364;
get_next_baseid(2, 124264) -> 124364;
get_next_baseid(3, 124064) -> 124264;
get_next_baseid(3, 124164) -> 124264;
get_next_baseid(3, 124364) -> 124264;
get_next_baseid(0, 124165) -> 124065;
get_next_baseid(0, 124365) -> 124065;
get_next_baseid(0, 124265) -> 124065;
get_next_baseid(1, 124065) -> 124165;
get_next_baseid(1, 124365) -> 124165;
get_next_baseid(1, 124265) -> 124165;
get_next_baseid(2, 124065) -> 124365;
get_next_baseid(2, 124165) -> 124365;
get_next_baseid(2, 124265) -> 124365;
get_next_baseid(3, 124065) -> 124265;
get_next_baseid(3, 124165) -> 124265;
get_next_baseid(3, 124365) -> 124265;
get_next_baseid(0, 124166) -> 124066;
get_next_baseid(0, 124366) -> 124066;
get_next_baseid(0, 124266) -> 124066;
get_next_baseid(1, 124066) -> 124166;
get_next_baseid(1, 124366) -> 124166;
get_next_baseid(1, 124266) -> 124166;
get_next_baseid(2, 124066) -> 124366;
get_next_baseid(2, 124166) -> 124366;
get_next_baseid(2, 124266) -> 124366;
get_next_baseid(3, 124066) -> 124266;
get_next_baseid(3, 124166) -> 124266;
get_next_baseid(3, 124366) -> 124266;
get_next_baseid(0, 124167) -> 124067;
get_next_baseid(0, 124367) -> 124067;
get_next_baseid(0, 124267) -> 124067;
get_next_baseid(1, 124067) -> 124167;
get_next_baseid(1, 124367) -> 124167;
get_next_baseid(1, 124267) -> 124167;
get_next_baseid(2, 124067) -> 124367;
get_next_baseid(2, 124167) -> 124367;
get_next_baseid(2, 124267) -> 124367;
get_next_baseid(3, 124067) -> 124267;
get_next_baseid(3, 124167) -> 124267;
get_next_baseid(3, 124367) -> 124267;
get_next_baseid(0, 124168) -> 124068;
get_next_baseid(0, 124368) -> 124068;
get_next_baseid(0, 124268) -> 124068;
get_next_baseid(1, 124068) -> 124168;
get_next_baseid(1, 124368) -> 124168;
get_next_baseid(1, 124268) -> 124168;
get_next_baseid(2, 124068) -> 124368;
get_next_baseid(2, 124168) -> 124368;
get_next_baseid(2, 124268) -> 124368;
get_next_baseid(3, 124068) -> 124268;
get_next_baseid(3, 124168) -> 124268;
get_next_baseid(3, 124368) -> 124268;
get_next_baseid(0, 124169) -> 124069;
get_next_baseid(0, 124369) -> 124069;
get_next_baseid(0, 124269) -> 124069;
get_next_baseid(1, 124069) -> 124169;
get_next_baseid(1, 124369) -> 124169;
get_next_baseid(1, 124269) -> 124169;
get_next_baseid(2, 124069) -> 124369;
get_next_baseid(2, 124169) -> 124369;
get_next_baseid(2, 124269) -> 124369;
get_next_baseid(3, 124069) -> 124269;
get_next_baseid(3, 124169) -> 124269;
get_next_baseid(3, 124369) -> 124269;
get_next_baseid(0, 124170) -> 124070;
get_next_baseid(0, 124370) -> 124070;
get_next_baseid(0, 124270) -> 124070;
get_next_baseid(1, 124070) -> 124170;
get_next_baseid(1, 124370) -> 124170;
get_next_baseid(1, 124270) -> 124170;
get_next_baseid(2, 124070) -> 124370;
get_next_baseid(2, 124170) -> 124370;
get_next_baseid(2, 124270) -> 124370;
get_next_baseid(3, 124070) -> 124270;
get_next_baseid(3, 124170) -> 124270;
get_next_baseid(3, 124370) -> 124270;
get_next_baseid(0, 124171) -> 124071;
get_next_baseid(0, 124371) -> 124071;
get_next_baseid(0, 124271) -> 124071;
get_next_baseid(1, 124071) -> 124171;
get_next_baseid(1, 124371) -> 124171;
get_next_baseid(1, 124271) -> 124171;
get_next_baseid(2, 124071) -> 124371;
get_next_baseid(2, 124171) -> 124371;
get_next_baseid(2, 124271) -> 124371;
get_next_baseid(3, 124071) -> 124271;
get_next_baseid(3, 124171) -> 124271;
get_next_baseid(3, 124371) -> 124271;
get_next_baseid(0, 124172) -> 124072;
get_next_baseid(0, 124372) -> 124072;
get_next_baseid(0, 124272) -> 124072;
get_next_baseid(1, 124072) -> 124172;
get_next_baseid(1, 124372) -> 124172;
get_next_baseid(1, 124272) -> 124172;
get_next_baseid(2, 124072) -> 124372;
get_next_baseid(2, 124172) -> 124372;
get_next_baseid(2, 124272) -> 124372;
get_next_baseid(3, 124072) -> 124272;
get_next_baseid(3, 124172) -> 124272;
get_next_baseid(3, 124372) -> 124272;
get_next_baseid(0, 124173) -> 124073;
get_next_baseid(0, 124373) -> 124073;
get_next_baseid(0, 124273) -> 124073;
get_next_baseid(1, 124073) -> 124173;
get_next_baseid(1, 124373) -> 124173;
get_next_baseid(1, 124273) -> 124173;
get_next_baseid(2, 124073) -> 124373;
get_next_baseid(2, 124173) -> 124373;
get_next_baseid(2, 124273) -> 124373;
get_next_baseid(3, 124073) -> 124273;
get_next_baseid(3, 124173) -> 124273;
get_next_baseid(3, 124373) -> 124273;
get_next_baseid(0, 124174) -> 124074;
get_next_baseid(0, 124374) -> 124074;
get_next_baseid(0, 124274) -> 124074;
get_next_baseid(1, 124074) -> 124174;
get_next_baseid(1, 124374) -> 124174;
get_next_baseid(1, 124274) -> 124174;
get_next_baseid(2, 124074) -> 124374;
get_next_baseid(2, 124174) -> 124374;
get_next_baseid(2, 124274) -> 124374;
get_next_baseid(3, 124074) -> 124274;
get_next_baseid(3, 124174) -> 124274;
get_next_baseid(3, 124374) -> 124274;
get_next_baseid(0, 124175) -> 124075;
get_next_baseid(0, 124375) -> 124075;
get_next_baseid(0, 124275) -> 124075;
get_next_baseid(1, 124075) -> 124175;
get_next_baseid(1, 124375) -> 124175;
get_next_baseid(1, 124275) -> 124175;
get_next_baseid(2, 124075) -> 124375;
get_next_baseid(2, 124175) -> 124375;
get_next_baseid(2, 124275) -> 124375;
get_next_baseid(3, 124075) -> 124275;
get_next_baseid(3, 124175) -> 124275;
get_next_baseid(3, 124375) -> 124275;
get_next_baseid(0, 124176) -> 124076;
get_next_baseid(0, 124376) -> 124076;
get_next_baseid(0, 124276) -> 124076;
get_next_baseid(1, 124076) -> 124176;
get_next_baseid(1, 124376) -> 124176;
get_next_baseid(1, 124276) -> 124176;
get_next_baseid(2, 124076) -> 124376;
get_next_baseid(2, 124176) -> 124376;
get_next_baseid(2, 124276) -> 124376;
get_next_baseid(3, 124076) -> 124276;
get_next_baseid(3, 124176) -> 124276;
get_next_baseid(3, 124376) -> 124276;
get_next_baseid(0, 124177) -> 124077;
get_next_baseid(0, 124377) -> 124077;
get_next_baseid(0, 124277) -> 124077;
get_next_baseid(1, 124077) -> 124177;
get_next_baseid(1, 124377) -> 124177;
get_next_baseid(1, 124277) -> 124177;
get_next_baseid(2, 124077) -> 124377;
get_next_baseid(2, 124177) -> 124377;
get_next_baseid(2, 124277) -> 124377;
get_next_baseid(3, 124077) -> 124277;
get_next_baseid(3, 124177) -> 124277;
get_next_baseid(3, 124377) -> 124277;
get_next_baseid(0, 124178) -> 124078;
get_next_baseid(0, 124378) -> 124078;
get_next_baseid(0, 124278) -> 124078;
get_next_baseid(1, 124078) -> 124178;
get_next_baseid(1, 124378) -> 124178;
get_next_baseid(1, 124278) -> 124178;
get_next_baseid(2, 124078) -> 124378;
get_next_baseid(2, 124178) -> 124378;
get_next_baseid(2, 124278) -> 124378;
get_next_baseid(3, 124078) -> 124278;
get_next_baseid(3, 124178) -> 124278;
get_next_baseid(3, 124378) -> 124278;
get_next_baseid(0, 124179) -> 124079;
get_next_baseid(0, 124379) -> 124079;
get_next_baseid(0, 124279) -> 124079;
get_next_baseid(1, 124079) -> 124179;
get_next_baseid(1, 124379) -> 124179;
get_next_baseid(1, 124279) -> 124179;
get_next_baseid(2, 124079) -> 124379;
get_next_baseid(2, 124179) -> 124379;
get_next_baseid(2, 124279) -> 124379;
get_next_baseid(3, 124079) -> 124279;
get_next_baseid(3, 124179) -> 124279;
get_next_baseid(3, 124379) -> 124279;
get_next_baseid(0, 124180) -> 124080;
get_next_baseid(0, 124380) -> 124080;
get_next_baseid(0, 124280) -> 124080;
get_next_baseid(1, 124080) -> 124180;
get_next_baseid(1, 124380) -> 124180;
get_next_baseid(1, 124280) -> 124180;
get_next_baseid(2, 124080) -> 124380;
get_next_baseid(2, 124180) -> 124380;
get_next_baseid(2, 124280) -> 124380;
get_next_baseid(3, 124080) -> 124280;
get_next_baseid(3, 124180) -> 124280;
get_next_baseid(3, 124380) -> 124280;
get_next_baseid(0, 124181) -> 124081;
get_next_baseid(0, 124381) -> 124081;
get_next_baseid(0, 124281) -> 124081;
get_next_baseid(1, 124081) -> 124181;
get_next_baseid(1, 124381) -> 124181;
get_next_baseid(1, 124281) -> 124181;
get_next_baseid(2, 124081) -> 124381;
get_next_baseid(2, 124181) -> 124381;
get_next_baseid(2, 124281) -> 124381;
get_next_baseid(3, 124081) -> 124281;
get_next_baseid(3, 124181) -> 124281;
get_next_baseid(3, 124381) -> 124281;
get_next_baseid(0, 124182) -> 124082;
get_next_baseid(0, 124382) -> 124082;
get_next_baseid(0, 124282) -> 124082;
get_next_baseid(1, 124082) -> 124182;
get_next_baseid(1, 124382) -> 124182;
get_next_baseid(1, 124282) -> 124182;
get_next_baseid(2, 124082) -> 124382;
get_next_baseid(2, 124182) -> 124382;
get_next_baseid(2, 124282) -> 124382;
get_next_baseid(3, 124082) -> 124282;
get_next_baseid(3, 124182) -> 124282;
get_next_baseid(3, 124382) -> 124282;
get_next_baseid(0, 124183) -> 124083;
get_next_baseid(0, 124383) -> 124083;
get_next_baseid(0, 124283) -> 124083;
get_next_baseid(1, 124083) -> 124183;
get_next_baseid(1, 124383) -> 124183;
get_next_baseid(1, 124283) -> 124183;
get_next_baseid(2, 124083) -> 124383;
get_next_baseid(2, 124183) -> 124383;
get_next_baseid(2, 124283) -> 124383;
get_next_baseid(3, 124083) -> 124283;
get_next_baseid(3, 124183) -> 124283;
get_next_baseid(3, 124383) -> 124283;
get_next_baseid(0, 124184) -> 124084;
get_next_baseid(0, 124384) -> 124084;
get_next_baseid(0, 124284) -> 124084;
get_next_baseid(1, 124084) -> 124184;
get_next_baseid(1, 124384) -> 124184;
get_next_baseid(1, 124284) -> 124184;
get_next_baseid(2, 124084) -> 124384;
get_next_baseid(2, 124184) -> 124384;
get_next_baseid(2, 124284) -> 124384;
get_next_baseid(3, 124084) -> 124284;
get_next_baseid(3, 124184) -> 124284;
get_next_baseid(3, 124384) -> 124284;
get_next_baseid(0, 124185) -> 124085;
get_next_baseid(0, 124385) -> 124085;
get_next_baseid(0, 124285) -> 124085;
get_next_baseid(1, 124085) -> 124185;
get_next_baseid(1, 124385) -> 124185;
get_next_baseid(1, 124285) -> 124185;
get_next_baseid(2, 124085) -> 124385;
get_next_baseid(2, 124185) -> 124385;
get_next_baseid(2, 124285) -> 124385;
get_next_baseid(3, 124085) -> 124285;
get_next_baseid(3, 124185) -> 124285;
get_next_baseid(3, 124385) -> 124285;
get_next_baseid(_Type, BaseId) -> BaseId.

%% 获取免费砸蛋数据
get_open_free_egg_info() -> {[
    {20, {item, 23000, 1, 1}, <<"很遗憾，今天只获得仙宠口粮一个。">>}
    ,{20, {item, 23002, 1, 1}, <<"恭喜你，获得一个仙宠潜力符">>}
    ,{50, {pet, 2}, <<"恭喜你，获得一个神秘仙宠">>}
    ,{10, nothing, <<"什么都没？？可怜的你，砸到一个“坏蛋”。。。">>}
    ], 100}.
