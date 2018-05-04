%%----------------------------------------------------
%% @doc 世界boss模块 
%%
%% <pre>
%% 世界boss模块
%% </pre>
%% @author yqhuang(QQ:19123767)
%%----------------------------------------------------
-module(boss_data).
-export([
        get/1
    ]
).

-include("common.hrl").
-include("boss.hrl").

%% 获取所有世界boss的信息
get(all) ->
    [25023, 25000, 25016, 25020, 25001, 25002, 25003, 25004, 25005, 25006, 25007, 25009, 25008, 25060, 25011, 25010, 30939, 30963];

get(25023) ->
    {ok, #boss_base{
            npc_id = 25023
            ,npc_lev = 35 
            ,npc_name = ?L(<<"炎灵">>)
            ,map_id = 10002
            ,map_name = ?L(<<"青云岭">>)
            ,interval = 1800 
            ,pos_list = [{2280,4560}]
        }
    };

get(25000) ->
    {ok, #boss_base{
            npc_id = 25000
            ,npc_lev = 40 
            ,npc_name = ?L(<<"白泽">>)
            ,map_id = 10002
            ,map_name = ?L(<<"青云岭">>)
            ,interval = 3600 
            ,pos_list = [{2940,5580}]
        }
    };

get(25016) ->
    {ok, #boss_base{
            npc_id = 25016
            ,npc_lev = 40 
            ,npc_name = ?L(<<"琴虫">>)
            ,map_id = 10002
            ,map_name = ?L(<<"青云岭">>)
            ,interval = 3600 
            ,pos_list = [{3300,1890}]
        }
    };

get(25020) ->
    {ok, #boss_base{
            npc_id = 25020
            ,npc_lev = 40 
            ,npc_name = ?L(<<"刍吾">>)
            ,map_id = 10002
            ,map_name = ?L(<<"青云岭">>)
            ,interval = 3600 
            ,pos_list = [{5400,2820}]
        }
    };

get(25001) ->
    {ok, #boss_base{
            npc_id = 25001
            ,npc_lev = 50 
            ,npc_name = ?L(<<"鬼母">>)
            ,map_id = 10004
            ,map_name = ?L(<<"百花谷">>)
            ,interval = 7200 
            ,pos_list = [{5160,750}]
        }
    };

get(25002) ->
    {ok, #boss_base{
            npc_id = 25002
            ,npc_lev = 50 
            ,npc_name = ?L(<<"鸾凤">>)
            ,map_id = 10004
            ,map_name = ?L(<<"百花谷">>)
            ,interval = 7200 
            ,pos_list = [{4020,5220}]
        }
    };

get(25003) ->
    {ok, #boss_base{
            npc_id = 25003
            ,npc_lev = 50 
            ,npc_name = ?L(<<"金乌">>)
            ,map_id = 10004
            ,map_name = ?L(<<"百花谷">>)
            ,interval = 7200 
            ,pos_list = [{4860,6300}]
        }
    };

get(25004) ->
    {ok, #boss_base{
            npc_id = 25004
            ,npc_lev = 60 
            ,npc_name = ?L(<<"修蛇">>)
            ,map_id = 10005
            ,map_name = ?L(<<"南诏">>)
            ,interval = 14400 
            ,pos_list = [{5760,6330}]
        }
    };

get(25005) ->
    {ok, #boss_base{
            npc_id = 25005
            ,npc_lev = 60 
            ,npc_name = ?L(<<"丧门">>)
            ,map_id = 10005
            ,map_name = ?L(<<"南诏">>)
            ,interval = 14400 
            ,pos_list = [{4800,1350}]
        }
    };

get(25006) ->
    {ok, #boss_base{
            npc_id = 25006
            ,npc_lev = 60 
            ,npc_name = ?L(<<"鲲鹏">>)
            ,map_id = 10005
            ,map_name = ?L(<<"南诏">>)
            ,interval = 14400 
            ,pos_list = [{2700,1710}]
        }
    };

get(25007) ->
    {ok, #boss_base{
            npc_id = 25007
            ,npc_lev = 70 
            ,npc_name = ?L(<<"计蒙">>)
            ,map_id = 10006
            ,map_name = ?L(<<"昆仑">>)
            ,interval = 28800 
            ,pos_list = [{3540,5250}]
        }
    };

get(25009) ->
    {ok, #boss_base{
            npc_id = 25009
            ,npc_lev = 70 
            ,npc_name = ?L(<<"混沌">>)
            ,map_id = 10006
            ,map_name = ?L(<<"昆仑">>)
            ,interval = 28800 
            ,pos_list = [{4500,3450}]
        }
    };

get(25008) ->
    {ok, #boss_base{
            npc_id = 25008
            ,npc_lev = 70 
            ,npc_name = ?L(<<"九婴">>)
            ,map_id = 10006
            ,map_name = ?L(<<"昆仑">>)
            ,interval = 28800 
            ,pos_list = [{1080,1680}]
        }
    };

get(25060) ->
    {ok, #boss_base{
            npc_id = 25060
            ,npc_lev = 80 
            ,npc_name = ?L(<<"飞廉">>)
            ,map_id = 10006
            ,map_name = ?L(<<"昆仑">>)
            ,interval = 28800 
            ,pos_list = [{3780,660}]
        }
    };

get(25011) ->
    {ok, #boss_base{
            npc_id = 25011
            ,npc_lev = 80 
            ,npc_name = ?L(<<"应龙">>)
            ,map_id = 10006
            ,map_name = ?L(<<"昆仑">>)
            ,interval = 28800 
            ,pos_list = [{1080,1080}]
        }
    };

get(25010) ->
    {ok, #boss_base{
            npc_id = 25010
            ,npc_lev = 80 
            ,npc_name = ?L(<<"穷奇分魂">>)
            ,map_id = 10006
            ,map_name = ?L(<<"昆仑">>)
            ,interval = 28800 
            ,pos_list = [{4140,1830}]
        }
    };

get(30939) ->
    {ok, #boss_base{
            npc_id = 30939
            ,npc_lev = 90 
            ,npc_name = ?L(<<"灵威仰元神">>)
            ,map_id = 10003
            ,map_name = ?L(<<"洛水城">>)
            ,interval = 28800 
            ,pos_list = [{840,540}]
        }
    };

get(30963) ->
    {ok, #boss_base{
            npc_id = 30963
            ,npc_lev = 90 
            ,npc_name = ?L(<<"延维">>)
            ,map_id = 10003
            ,map_name = ?L(<<"洛水城">>)
            ,interval = 28800 
            ,pos_list = [{9420,4020}]
        }
    };

get(NpcId) ->
    {false, util:fbin(?L(<<"没有该世界boss的信息[Id:~w]">>), [NpcId])}.
