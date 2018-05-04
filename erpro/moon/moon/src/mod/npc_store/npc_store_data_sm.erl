%%----------------------------------------------------
%% NPC神秘商店数据
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(npc_store_data_sm).
-export([
     list/1
     ,get/2
   ]
).

-include("npc_store.hrl").


%% NPC神秘商品基础数据列表
list(0) -> [33002,23000,27000,24109,24112,24115];
list(1) -> [25023,32001,23003,25022,25020,21700,30211,32820,23040,25027,25060,23016,23017,24111,24102,24105,24108,24114,24117,23000,21028,21029,27505,21020,21021,21022,21002,21012,24120,24121,24122,24123,24124,25024,25025,30511,30512,30513,30514,30515,30521,30522,30523,30531,30532,30210,23009,21035,26000,26001,26002,26003,26004,26005,26006,26007,26008,26020,26021,26022,26023,26024,26025,26026,26027,26028,26040,26041,26042,26043,26044,26045,26046,26047,26048,26290,26291,26292,26293,26294,26295,26300,26301,26302,26303,26304,26305];
list(2) -> [25023,32001,23003,25022,25020,21700,23016,23017,24111,24102,24105,24108,24114,24117,23000,21028,21029,27505,21020,21021,21022,21002,21012,22221,22202,22203,24120,24121,24122,24123,24124,25024,25025,30511,30512,30513,30514,30515,30521,30522,30523,30531,30532,30210,23009,21035,26000,26001,26002,26003,26004,26005,26006,26007,26008,26020,26021,26022,26023,26024,26025,26026,26027,26028,26040,26041,26042,26043,26044,26045,26046,26047,26048];
list(_) -> [].

%% NPC神秘商品
%% @spec get(BaseId) -> {ok, Items} | {false, Reason}
%% BaseId -> integer() 
%% Items -> #npc_store_base_sm{}
get(0, 33002) -> 
    {ok, #npc_store_base_sm{
           base_id = 33002
           ,name = <<"1朵玫瑰花">>
           ,price = 3000
           ,price_type = 5
           ,rand = 1667
        }
    };

get(0, 23000) -> 
    {ok, #npc_store_base_sm{
           base_id = 23000
           ,name = <<"仙宠口粮">>
           ,price = 6000
           ,price_type = 5
           ,rand = 1666
        }
    };

get(0, 27000) -> 
    {ok, #npc_store_base_sm{
           base_id = 27000
           ,name = <<"绿色洗练石">>
           ,price = 2000
           ,price_type = 5
           ,rand = 1666
        }
    };

get(0, 24109) -> 
    {ok, #npc_store_base_sm{
           base_id = 24109
           ,name = <<"初级攻击药">>
           ,price = 28000
           ,price_type = 5
           ,rand = 1667
        }
    };

get(0, 24112) -> 
    {ok, #npc_store_base_sm{
           base_id = 24112
           ,name = <<"初级命中药">>
           ,price = 28000
           ,price_type = 5
           ,rand = 1667
        }
    };

get(0, 24115) -> 
    {ok, #npc_store_base_sm{
           base_id = 24115
           ,name = <<"初级闪躲药">>
           ,price = 28000
           ,price_type = 5
           ,rand = 1667
        }
    };

get(1, 25023) -> 
    {ok, #npc_store_base_sm{
           base_id = 25023
           ,name = <<"火凤羽">>
           ,price = 150
           ,price_type = 3
           ,rand = 320
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 32001) -> 
    {ok, #npc_store_base_sm{
           base_id = 32001
           ,name = <<"元神保护丹">>
           ,price = 120
           ,price_type = 3
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 23003) -> 
    {ok, #npc_store_base_sm{
           base_id = 23003
           ,name = <<"仙宠潜力保护符">>
           ,price = 60
           ,price_type = 3
           ,rand = 0
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 25022) -> 
    {ok, #npc_store_base_sm{
           base_id = 25022
           ,name = <<"神器之魄">>
           ,price = 150
           ,price_type = 3
           ,rand = 320
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 25020) -> 
    {ok, #npc_store_base_sm{
           base_id = 25020
           ,name = <<"星河之砂">>
           ,price = 5
           ,price_type = 3
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 21700) -> 
    {ok, #npc_store_base_sm{
           base_id = 21700
           ,name = <<"神佑石">>
           ,price = 80
           ,price_type = 3
           ,rand = 380
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 0
        }
    };

get(1, 30211) -> 
    {ok, #npc_store_base_sm{
           base_id = 30211
           ,name = <<"炼神丹">>
           ,price = 30
           ,price_type = 3
           ,rand = 400
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 32820) -> 
    {ok, #npc_store_base_sm{
           base_id = 32820
           ,name = <<"鉴宝符">>
           ,price = 30
           ,price_type = 3
           ,rand = 380
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 23040) -> 
    {ok, #npc_store_base_sm{
           base_id = 23040
           ,name = <<"灵幻石">>
           ,price = 30
           ,price_type = 3
           ,rand = 380
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 25027) -> 
    {ok, #npc_store_base_sm{
           base_id = 25027
           ,name = <<"天龙鳞">>
           ,price = 200
           ,price_type = 3
           ,rand = 350
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 25060) -> 
    {ok, #npc_store_base_sm{
           base_id = 25060
           ,name = <<"地华">>
           ,price = 300
           ,price_type = 3
           ,rand = 90
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 23016) -> 
    {ok, #npc_store_base_sm{
           base_id = 23016
           ,name = <<"仙宠精魂·绿">>
           ,price = 40
           ,price_type = 3
           ,rand = 250
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 23017) -> 
    {ok, #npc_store_base_sm{
           base_id = 23017
           ,name = <<"仙宠精魂·蓝">>
           ,price = 60
           ,price_type = 3
           ,rand = 300
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24111) -> 
    {ok, #npc_store_base_sm{
           base_id = 24111
           ,name = <<"高级攻击药">>
           ,price = 30
           ,price_type = 3
           ,rand = 270
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24102) -> 
    {ok, #npc_store_base_sm{
           base_id = 24102
           ,name = <<"高级气血药">>
           ,price = 30
           ,price_type = 3
           ,rand = 270
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24105) -> 
    {ok, #npc_store_base_sm{
           base_id = 24105
           ,name = <<"高级法力药">>
           ,price = 30
           ,price_type = 3
           ,rand = 220
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24108) -> 
    {ok, #npc_store_base_sm{
           base_id = 24108
           ,name = <<"高级防御药">>
           ,price = 30
           ,price_type = 3
           ,rand = 250
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24114) -> 
    {ok, #npc_store_base_sm{
           base_id = 24114
           ,name = <<"高级命中药">>
           ,price = 30
           ,price_type = 3
           ,rand = 250
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24117) -> 
    {ok, #npc_store_base_sm{
           base_id = 24117
           ,name = <<"高级躲闪药">>
           ,price = 30
           ,price_type = 3
           ,rand = 250
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 23000) -> 
    {ok, #npc_store_base_sm{
           base_id = 23000
           ,name = <<"仙宠口粮">>
           ,price = 6000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 21028) -> 
    {ok, #npc_store_base_sm{
           base_id = 21028
           ,name = <<"+7强化保护符">>
           ,price = 35
           ,price_type = 3
           ,rand = 380
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 21029) -> 
    {ok, #npc_store_base_sm{
           base_id = 21029
           ,name = <<"+8强化保护符">>
           ,price = 125
           ,price_type = 3
           ,rand = 280
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 27505) -> 
    {ok, #npc_store_base_sm{
           base_id = 27505
           ,name = <<"守护水晶">>
           ,price = 30
           ,price_type = 3
           ,rand = 300
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 21020) -> 
    {ok, #npc_store_base_sm{
           base_id = 21020
           ,name = <<"普通幸运石">>
           ,price = 30
           ,price_type = 3
           ,rand = 670
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 21021) -> 
    {ok, #npc_store_base_sm{
           base_id = 21021
           ,name = <<"精品幸运石">>
           ,price = 80
           ,price_type = 3
           ,rand = 200
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 21022) -> 
    {ok, #npc_store_base_sm{
           base_id = 21022
           ,name = <<"优良幸运石">>
           ,price = 200
           ,price_type = 3
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 21002) -> 
    {ok, #npc_store_base_sm{
           base_id = 21002
           ,name = <<"高级强化仙玉">>
           ,price = 70
           ,price_type = 3
           ,rand = 80
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 21012) -> 
    {ok, #npc_store_base_sm{
           base_id = 21012
           ,name = <<"高级强化灵石">>
           ,price = 40
           ,price_type = 3
           ,rand = 80
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24120) -> 
    {ok, #npc_store_base_sm{
           base_id = 24120
           ,name = <<"气血包">>
           ,price = 6000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24121) -> 
    {ok, #npc_store_base_sm{
           base_id = 24121
           ,name = <<"大气血包">>
           ,price = 20000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24122) -> 
    {ok, #npc_store_base_sm{
           base_id = 24122
           ,name = <<"法力包">>
           ,price = 55000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24123) -> 
    {ok, #npc_store_base_sm{
           base_id = 24123
           ,name = <<"大法力包">>
           ,price = 200000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 24124) -> 
    {ok, #npc_store_base_sm{
           base_id = 24124
           ,name = <<"五行抗性药">>
           ,price = 30
           ,price_type = 3
           ,rand = 90
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 25024) -> 
    {ok, #npc_store_base_sm{
           base_id = 25024
           ,name = <<"灵戒碎片">>
           ,price = 120
           ,price_type = 3
           ,rand = 250
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 25025) -> 
    {ok, #npc_store_base_sm{
           base_id = 25025
           ,name = <<"灵符碎片">>
           ,price = 120
           ,price_type = 3
           ,rand = 260
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 30511) -> 
    {ok, #npc_store_base_sm{
           base_id = 30511
           ,name = <<"阵图：五行金阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 30
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 30512) -> 
    {ok, #npc_store_base_sm{
           base_id = 30512
           ,name = <<"阵图：五行木阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 30
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 30513) -> 
    {ok, #npc_store_base_sm{
           base_id = 30513
           ,name = <<"阵图：五行火阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 30
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 30514) -> 
    {ok, #npc_store_base_sm{
           base_id = 30514
           ,name = <<"阵图：五行水阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 30
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 30515) -> 
    {ok, #npc_store_base_sm{
           base_id = 30515
           ,name = <<"阵图：五行土阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 30
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 30521) -> 
    {ok, #npc_store_base_sm{
           base_id = 30521
           ,name = <<"阵图：宠物冲杀阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 30
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 30522) -> 
    {ok, #npc_store_base_sm{
           base_id = 30522
           ,name = <<"阵图：宠物护卫阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 30
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 30523) -> 
    {ok, #npc_store_base_sm{
           base_id = 30523
           ,name = <<"阵图：宠物灵气阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 30
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 30531) -> 
    {ok, #npc_store_base_sm{
           base_id = 30531
           ,name = <<"阵图：九阴阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 30
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 30532) -> 
    {ok, #npc_store_base_sm{
           base_id = 30532
           ,name = <<"阵图：九阳阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 30
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 30210) -> 
    {ok, #npc_store_base_sm{
           base_id = 30210
           ,name = <<"技能修为丹">>
           ,price = 20
           ,price_type = 3
           ,rand = 400
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(1, 23009) -> 
    {ok, #npc_store_base_sm{
           base_id = 23009
           ,name = <<"三倍仙宠经验草">>
           ,price = 150
           ,price_type = 3
           ,rand = 250
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 21035) -> 
    {ok, #npc_store_base_sm{
           base_id = 21035
           ,name = <<"继承保护符碎片">>
           ,price = 200
           ,price_type = 3
           ,rand = 330
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(1, 26000) -> 
    {ok, #npc_store_base_sm{
           base_id = 26000
           ,name = <<"一级气血石">>
           ,price = 4000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26001) -> 
    {ok, #npc_store_base_sm{
           base_id = 26001
           ,name = <<"一级法力石">>
           ,price = 3000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26002) -> 
    {ok, #npc_store_base_sm{
           base_id = 26002
           ,name = <<"一级攻击石">>
           ,price = 8000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26003) -> 
    {ok, #npc_store_base_sm{
           base_id = 26003
           ,name = <<"一级防御石">>
           ,price = 3000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26004) -> 
    {ok, #npc_store_base_sm{
           base_id = 26004
           ,name = <<"一级暴击石">>
           ,price = 4000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26005) -> 
    {ok, #npc_store_base_sm{
           base_id = 26005
           ,name = <<"一级命中石">>
           ,price = 4000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26006) -> 
    {ok, #npc_store_base_sm{
           base_id = 26006
           ,name = <<"一级躲闪石">>
           ,price = 4000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26007) -> 
    {ok, #npc_store_base_sm{
           base_id = 26007
           ,name = <<"一级坚韧石">>
           ,price = 4000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26008) -> 
    {ok, #npc_store_base_sm{
           base_id = 26008
           ,name = <<"一级敏捷石">>
           ,price = 16000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26020) -> 
    {ok, #npc_store_base_sm{
           base_id = 26020
           ,name = <<"二级气血石">>
           ,price = 8
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26021) -> 
    {ok, #npc_store_base_sm{
           base_id = 26021
           ,name = <<"二级法力石">>
           ,price = 6
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26022) -> 
    {ok, #npc_store_base_sm{
           base_id = 26022
           ,name = <<"二级攻击石">>
           ,price = 15
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26023) -> 
    {ok, #npc_store_base_sm{
           base_id = 26023
           ,name = <<"二级防御石">>
           ,price = 6
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26024) -> 
    {ok, #npc_store_base_sm{
           base_id = 26024
           ,name = <<"二级暴击石">>
           ,price = 8
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26025) -> 
    {ok, #npc_store_base_sm{
           base_id = 26025
           ,name = <<"二级命中石">>
           ,price = 8
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26026) -> 
    {ok, #npc_store_base_sm{
           base_id = 26026
           ,name = <<"二级躲闪石">>
           ,price = 8
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26027) -> 
    {ok, #npc_store_base_sm{
           base_id = 26027
           ,name = <<"二级坚韧石">>
           ,price = 8
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26028) -> 
    {ok, #npc_store_base_sm{
           base_id = 26028
           ,name = <<"二级敏捷石">>
           ,price = 30
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26040) -> 
    {ok, #npc_store_base_sm{
           base_id = 26040
           ,name = <<"三级气血石">>
           ,price = 30
           ,price_type = 3
           ,rand = 70
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26041) -> 
    {ok, #npc_store_base_sm{
           base_id = 26041
           ,name = <<"三级法力石">>
           ,price = 20
           ,price_type = 3
           ,rand = 70
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26042) -> 
    {ok, #npc_store_base_sm{
           base_id = 26042
           ,name = <<"三级攻击石">>
           ,price = 50
           ,price_type = 3
           ,rand = 70
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26043) -> 
    {ok, #npc_store_base_sm{
           base_id = 26043
           ,name = <<"三级防御石">>
           ,price = 24
           ,price_type = 3
           ,rand = 70
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26044) -> 
    {ok, #npc_store_base_sm{
           base_id = 26044
           ,name = <<"三级暴击石">>
           ,price = 30
           ,price_type = 3
           ,rand = 70
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26045) -> 
    {ok, #npc_store_base_sm{
           base_id = 26045
           ,name = <<"三级命中石">>
           ,price = 30
           ,price_type = 3
           ,rand = 70
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26046) -> 
    {ok, #npc_store_base_sm{
           base_id = 26046
           ,name = <<"三级躲闪石">>
           ,price = 30
           ,price_type = 3
           ,rand = 70
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26047) -> 
    {ok, #npc_store_base_sm{
           base_id = 26047
           ,name = <<"三级坚韧石">>
           ,price = 30
           ,price_type = 3
           ,rand = 70
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26048) -> 
    {ok, #npc_store_base_sm{
           base_id = 26048
           ,name = <<"三级敏捷石">>
           ,price = 100
           ,price_type = 3
           ,rand = 70
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26290) -> 
    {ok, #npc_store_base_sm{
           base_id = 26290
           ,name = <<"三级血防石">>
           ,price = 45
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26291) -> 
    {ok, #npc_store_base_sm{
           base_id = 26291
           ,name = <<"三级血闪石">>
           ,price = 50
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26292) -> 
    {ok, #npc_store_base_sm{
           base_id = 26292
           ,name = <<"三级闪防石">>
           ,price = 45
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26293) -> 
    {ok, #npc_store_base_sm{
           base_id = 26293
           ,name = <<"三级血韧石">>
           ,price = 50
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26294) -> 
    {ok, #npc_store_base_sm{
           base_id = 26294
           ,name = <<"三级防韧石">>
           ,price = 45
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26295) -> 
    {ok, #npc_store_base_sm{
           base_id = 26295
           ,name = <<"三级闪韧石">>
           ,price = 50
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26300) -> 
    {ok, #npc_store_base_sm{
           base_id = 26300
           ,name = <<"三级命韧石">>
           ,price = 50
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26301) -> 
    {ok, #npc_store_base_sm{
           base_id = 26301
           ,name = <<"三级暴韧石">>
           ,price = 50
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26302) -> 
    {ok, #npc_store_base_sm{
           base_id = 26302
           ,name = <<"三级攻韧石">>
           ,price = 65
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26303) -> 
    {ok, #npc_store_base_sm{
           base_id = 26303
           ,name = <<"三级暴命石">>
           ,price = 50
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26304) -> 
    {ok, #npc_store_base_sm{
           base_id = 26304
           ,name = <<"三级攻命石">>
           ,price = 65
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(1, 26305) -> 
    {ok, #npc_store_base_sm{
           base_id = 26305
           ,name = <<"三级攻暴石">>
           ,price = 65
           ,price_type = 3
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 25023) -> 
    {ok, #npc_store_base_sm{
           base_id = 25023
           ,name = <<"火凤羽">>
           ,price = 450
           ,price_type = 3
           ,rand = 340
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 32001) -> 
    {ok, #npc_store_base_sm{
           base_id = 32001
           ,name = <<"元神保护丹">>
           ,price = 120
           ,price_type = 3
           ,rand = 240
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 23003) -> 
    {ok, #npc_store_base_sm{
           base_id = 23003
           ,name = <<"仙宠潜力保护符">>
           ,price = 60
           ,price_type = 3
           ,rand = 300
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 25022) -> 
    {ok, #npc_store_base_sm{
           base_id = 25022
           ,name = <<"神器之魄">>
           ,price = 150
           ,price_type = 3
           ,rand = 340
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 25020) -> 
    {ok, #npc_store_base_sm{
           base_id = 25020
           ,name = <<"星河之砂">>
           ,price = 5
           ,price_type = 3
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 21700) -> 
    {ok, #npc_store_base_sm{
           base_id = 21700
           ,name = <<"神佑石">>
           ,price = 80
           ,price_type = 3
           ,rand = 400
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 0
        }
    };

get(2, 23016) -> 
    {ok, #npc_store_base_sm{
           base_id = 23016
           ,name = <<"仙宠精魂·绿">>
           ,price = 40
           ,price_type = 3
           ,rand = 240
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 23017) -> 
    {ok, #npc_store_base_sm{
           base_id = 23017
           ,name = <<"仙宠精魂·蓝">>
           ,price = 60
           ,price_type = 3
           ,rand = 320
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24111) -> 
    {ok, #npc_store_base_sm{
           base_id = 24111
           ,name = <<"高级攻击药">>
           ,price = 30
           ,price_type = 3
           ,rand = 300
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24102) -> 
    {ok, #npc_store_base_sm{
           base_id = 24102
           ,name = <<"高级气血药">>
           ,price = 30
           ,price_type = 3
           ,rand = 300
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24105) -> 
    {ok, #npc_store_base_sm{
           base_id = 24105
           ,name = <<"高级法力药">>
           ,price = 30
           ,price_type = 3
           ,rand = 250
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24108) -> 
    {ok, #npc_store_base_sm{
           base_id = 24108
           ,name = <<"高级防御药">>
           ,price = 30
           ,price_type = 3
           ,rand = 280
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24114) -> 
    {ok, #npc_store_base_sm{
           base_id = 24114
           ,name = <<"高级命中药">>
           ,price = 30
           ,price_type = 3
           ,rand = 280
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24117) -> 
    {ok, #npc_store_base_sm{
           base_id = 24117
           ,name = <<"高级躲闪药">>
           ,price = 30
           ,price_type = 3
           ,rand = 280
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 23000) -> 
    {ok, #npc_store_base_sm{
           base_id = 23000
           ,name = <<"仙宠口粮">>
           ,price = 6000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 21028) -> 
    {ok, #npc_store_base_sm{
           base_id = 21028
           ,name = <<"+7强化保护符">>
           ,price = 35
           ,price_type = 3
           ,rand = 440
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 21029) -> 
    {ok, #npc_store_base_sm{
           base_id = 21029
           ,name = <<"+8强化保护符">>
           ,price = 125
           ,price_type = 3
           ,rand = 200
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 27505) -> 
    {ok, #npc_store_base_sm{
           base_id = 27505
           ,name = <<"守护水晶">>
           ,price = 30
           ,price_type = 3
           ,rand = 400
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 21020) -> 
    {ok, #npc_store_base_sm{
           base_id = 21020
           ,name = <<"普通幸运石">>
           ,price = 30
           ,price_type = 3
           ,rand = 800
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 21021) -> 
    {ok, #npc_store_base_sm{
           base_id = 21021
           ,name = <<"精品幸运石">>
           ,price = 80
           ,price_type = 3
           ,rand = 150
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 21022) -> 
    {ok, #npc_store_base_sm{
           base_id = 21022
           ,name = <<"优良幸运石">>
           ,price = 200
           ,price_type = 3
           ,rand = 80
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 21002) -> 
    {ok, #npc_store_base_sm{
           base_id = 21002
           ,name = <<"高级强化仙玉">>
           ,price = 70
           ,price_type = 3
           ,rand = 50
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 21012) -> 
    {ok, #npc_store_base_sm{
           base_id = 21012
           ,name = <<"高级强化灵石">>
           ,price = 40
           ,price_type = 3
           ,rand = 50
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 22221) -> 
    {ok, #npc_store_base_sm{
           base_id = 22221
           ,name = <<"精良水月石">>
           ,price = 40
           ,price_type = 3
           ,rand = 550
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 22202) -> 
    {ok, #npc_store_base_sm{
           base_id = 22202
           ,name = <<"四级星辰石">>
           ,price = 20
           ,price_type = 3
           ,rand = 800
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 22203) -> 
    {ok, #npc_store_base_sm{
           base_id = 22203
           ,name = <<"五级星辰石">>
           ,price = 80
           ,price_type = 3
           ,rand = 250
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24120) -> 
    {ok, #npc_store_base_sm{
           base_id = 24120
           ,name = <<"气血包">>
           ,price = 6000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24121) -> 
    {ok, #npc_store_base_sm{
           base_id = 24121
           ,name = <<"大气血包">>
           ,price = 20000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24122) -> 
    {ok, #npc_store_base_sm{
           base_id = 24122
           ,name = <<"法力包">>
           ,price = 55000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24123) -> 
    {ok, #npc_store_base_sm{
           base_id = 24123
           ,name = <<"大法力包">>
           ,price = 200000
           ,price_type = 5
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 24124) -> 
    {ok, #npc_store_base_sm{
           base_id = 24124
           ,name = <<"五行抗性药">>
           ,price = 30
           ,price_type = 3
           ,rand = 0
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 25024) -> 
    {ok, #npc_store_base_sm{
           base_id = 25024
           ,name = <<"灵戒碎片">>
           ,price = 120
           ,price_type = 3
           ,rand = 120
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 25025) -> 
    {ok, #npc_store_base_sm{
           base_id = 25025
           ,name = <<"灵符碎片">>
           ,price = 120
           ,price_type = 3
           ,rand = 120
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 30511) -> 
    {ok, #npc_store_base_sm{
           base_id = 30511
           ,name = <<"阵图：五行金阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 30512) -> 
    {ok, #npc_store_base_sm{
           base_id = 30512
           ,name = <<"阵图：五行木阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 30513) -> 
    {ok, #npc_store_base_sm{
           base_id = 30513
           ,name = <<"阵图：五行火阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 30514) -> 
    {ok, #npc_store_base_sm{
           base_id = 30514
           ,name = <<"阵图：五行水阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 30515) -> 
    {ok, #npc_store_base_sm{
           base_id = 30515
           ,name = <<"阵图：五行土阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 30521) -> 
    {ok, #npc_store_base_sm{
           base_id = 30521
           ,name = <<"阵图：宠物冲杀阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 30522) -> 
    {ok, #npc_store_base_sm{
           base_id = 30522
           ,name = <<"阵图：宠物护卫阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 30523) -> 
    {ok, #npc_store_base_sm{
           base_id = 30523
           ,name = <<"阵图：宠物灵气阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 30531) -> 
    {ok, #npc_store_base_sm{
           base_id = 30531
           ,name = <<"阵图：九阴阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 30532) -> 
    {ok, #npc_store_base_sm{
           base_id = 30532
           ,name = <<"阵图：九阳阵">>
           ,price = 60000
           ,price_type = 5
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 30210) -> 
    {ok, #npc_store_base_sm{
           base_id = 30210
           ,name = <<"技能修为丹">>
           ,price = 20
           ,price_type = 3
           ,rand = 250
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 1
        }
    };

get(2, 23009) -> 
    {ok, #npc_store_base_sm{
           base_id = 23009
           ,name = <<"三倍仙宠经验草">>
           ,price = 150
           ,price_type = 3
           ,rand = 200
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 21035) -> 
    {ok, #npc_store_base_sm{
           base_id = 21035
           ,name = <<"继承保护符碎片">>
           ,price = 200
           ,price_type = 3
           ,rand = 300
           ,limit_type = 2
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 1
           ,is_music = 1
        }
    };

get(2, 26000) -> 
    {ok, #npc_store_base_sm{
           base_id = 26000
           ,name = <<"一级气血石">>
           ,price = 4000
           ,price_type = 5
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26001) -> 
    {ok, #npc_store_base_sm{
           base_id = 26001
           ,name = <<"一级法力石">>
           ,price = 3000
           ,price_type = 5
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26002) -> 
    {ok, #npc_store_base_sm{
           base_id = 26002
           ,name = <<"一级攻击石">>
           ,price = 8000
           ,price_type = 5
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26003) -> 
    {ok, #npc_store_base_sm{
           base_id = 26003
           ,name = <<"一级防御石">>
           ,price = 3000
           ,price_type = 5
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26004) -> 
    {ok, #npc_store_base_sm{
           base_id = 26004
           ,name = <<"一级暴击石">>
           ,price = 4000
           ,price_type = 5
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26005) -> 
    {ok, #npc_store_base_sm{
           base_id = 26005
           ,name = <<"一级命中石">>
           ,price = 4000
           ,price_type = 5
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26006) -> 
    {ok, #npc_store_base_sm{
           base_id = 26006
           ,name = <<"一级躲闪石">>
           ,price = 4000
           ,price_type = 5
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26007) -> 
    {ok, #npc_store_base_sm{
           base_id = 26007
           ,name = <<"一级坚韧石">>
           ,price = 4000
           ,price_type = 5
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26008) -> 
    {ok, #npc_store_base_sm{
           base_id = 26008
           ,name = <<"一级敏捷石">>
           ,price = 16000
           ,price_type = 5
           ,rand = 10
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26020) -> 
    {ok, #npc_store_base_sm{
           base_id = 26020
           ,name = <<"二级气血石">>
           ,price = 8
           ,price_type = 3
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26021) -> 
    {ok, #npc_store_base_sm{
           base_id = 26021
           ,name = <<"二级法力石">>
           ,price = 6
           ,price_type = 3
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26022) -> 
    {ok, #npc_store_base_sm{
           base_id = 26022
           ,name = <<"二级攻击石">>
           ,price = 15
           ,price_type = 3
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26023) -> 
    {ok, #npc_store_base_sm{
           base_id = 26023
           ,name = <<"二级防御石">>
           ,price = 6
           ,price_type = 3
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26024) -> 
    {ok, #npc_store_base_sm{
           base_id = 26024
           ,name = <<"二级暴击石">>
           ,price = 8
           ,price_type = 3
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26025) -> 
    {ok, #npc_store_base_sm{
           base_id = 26025
           ,name = <<"二级命中石">>
           ,price = 8
           ,price_type = 3
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26026) -> 
    {ok, #npc_store_base_sm{
           base_id = 26026
           ,name = <<"二级躲闪石">>
           ,price = 8
           ,price_type = 3
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26027) -> 
    {ok, #npc_store_base_sm{
           base_id = 26027
           ,name = <<"二级坚韧石">>
           ,price = 8
           ,price_type = 3
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26028) -> 
    {ok, #npc_store_base_sm{
           base_id = 26028
           ,name = <<"二级敏捷石">>
           ,price = 30
           ,price_type = 3
           ,rand = 100
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26040) -> 
    {ok, #npc_store_base_sm{
           base_id = 26040
           ,name = <<"三级气血石">>
           ,price = 30
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26041) -> 
    {ok, #npc_store_base_sm{
           base_id = 26041
           ,name = <<"三级法力石">>
           ,price = 20
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26042) -> 
    {ok, #npc_store_base_sm{
           base_id = 26042
           ,name = <<"三级攻击石">>
           ,price = 50
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26043) -> 
    {ok, #npc_store_base_sm{
           base_id = 26043
           ,name = <<"三级防御石">>
           ,price = 24
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26044) -> 
    {ok, #npc_store_base_sm{
           base_id = 26044
           ,name = <<"三级暴击石">>
           ,price = 30
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26045) -> 
    {ok, #npc_store_base_sm{
           base_id = 26045
           ,name = <<"三级命中石">>
           ,price = 30
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26046) -> 
    {ok, #npc_store_base_sm{
           base_id = 26046
           ,name = <<"三级躲闪石">>
           ,price = 30
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26047) -> 
    {ok, #npc_store_base_sm{
           base_id = 26047
           ,name = <<"三级坚韧石">>
           ,price = 30
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(2, 26048) -> 
    {ok, #npc_store_base_sm{
           base_id = 26048
           ,name = <<"三级敏捷石">>
           ,price = 100
           ,price_type = 3
           ,rand = 20
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,0}
           ,is_notice = 0
           ,is_music = 0
        }
    };

get(_, _Id) ->
    {false, <<"无此物品信息">>}.
