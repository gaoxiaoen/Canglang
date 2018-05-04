%%----------------------------------------------------
%% super_boss开封印基础数据
%% @author whjing2011
%%----------------------------------------------------
-module(super_boss_data_casino).
-export([
     list/1
     ,get/3
   ]
).

-include("casino.hrl").


%% 开封印基础数据列表
list(0) ->
    [30023];
list(1) ->
    [27001,30023,33033,30102,30103,30104,30105,30106,30107,23002,21020,25021,25022,33051,32300];
list(_) -> [].

%% 开封印物品
get(default, 30023, 0) -> 
    {ok, #super_boss_casino_base{
           is_default = 1
           ,base_id = 30023
           ,name = <<"5*碎银">>
           ,rand = 5000
           ,bind = 1
           ,num = 1
        }
    };

get(normal, 27001, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 27001
           ,name = <<"蓝色洗练石">>
           ,rand = 1060
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 0
           ,bind = 1
           ,num = 1
           ,sort = 200
        }
    };

get(normal, 30023, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 30023
           ,name = <<"5*碎银">>
           ,rand = 7120
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 0
           ,bind = 1
           ,num = 5
           ,sort = 399
        }
    };

get(normal, 33033, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 33033
           ,name = <<"觉醒技能书残卷">>
           ,rand = 500
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 0
           ,num = 1
           ,sort = 449
        }
    };

get(normal, 30102, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 30102
           ,name = <<"眩晕抵抗">>
           ,rand = 40
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 0
           ,num = 1
           ,sort = 499
        }
    };

get(normal, 30103, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 30103
           ,name = <<"中毒抵抗">>
           ,rand = 40
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 0
           ,num = 1
           ,sort = 549
        }
    };

get(normal, 30104, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 30104
           ,name = <<"睡眠抵抗">>
           ,rand = 40
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 0
           ,num = 1
           ,sort = 599
        }
    };

get(normal, 30105, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 30105
           ,name = <<"石化抵抗">>
           ,rand = 40
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 0
           ,num = 1
           ,sort = 649
        }
    };

get(normal, 30106, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 30106
           ,name = <<"嘲讽抵抗">>
           ,rand = 40
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 0
           ,num = 1
           ,sort = 699
        }
    };

get(normal, 30107, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 30107
           ,name = <<"遗忘抵抗">>
           ,rand = 40
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 0
           ,num = 1
           ,sort = 749
        }
    };

get(normal, 23002, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 23002
           ,name = <<"仙宠潜力符">>
           ,rand = 500
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 1
           ,num = 1
           ,sort = 799
        }
    };

get(normal, 21020, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 21020
           ,name = <<"幸运石">>
           ,rand = 300
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {0,0}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 0
           ,num = 1
           ,sort = 849
        }
    };

get(normal, 25021, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 25021
           ,name = <<"紫晶魂">>
           ,rand = 80
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 0
           ,num = 1
           ,sort = 899
        }
    };

get(normal, 25022, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 25022
           ,name = <<"神器之魄">>
           ,rand = 45
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 0
           ,num = 1
           ,sort = 949
        }
    };

get(normal, 33051, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 33051
           ,name = <<"圣域仙草">>
           ,rand = 75
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 1
           ,num = 1
           ,sort = 999
        }
    };

get(normal, 32300, 0) -> 
    {ok, #super_boss_casino_base{
           base_id = 32300
           ,name = <<"坐骑进阶灵丹">>
           ,rand = 80
           ,limit_type = 1
           ,limit_time = {1,0}
           ,limit_num = {1,50}
           ,must_out = 0
           ,is_notice = 1
           ,bind = 1
           ,num = 1
           ,sort = 998
        }
    };

get(_Mod, _Id, _LuckVal) ->
    {false, <<"无此物品信息">>}.
