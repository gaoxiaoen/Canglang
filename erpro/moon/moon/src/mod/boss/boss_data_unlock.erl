%%----------------------------------------------------
%% @doc 世界boss模块 
%%
%% <pre>
%% 世界boss模块
%% </pre>
%% @author yqhuang(QQ:19123767)
%%----------------------------------------------------
-module(boss_data_unlock).
-export([
        get/1
    ]
).

-include("common.hrl").
-include("boss.hrl").

%% 获取所有世界boss的信息
get(all) ->
    [25023, 25000];

get(25023) ->
    {ok, #boss_base{
            npc_id = 25023
            ,npc_lev = 35 
            ,npc_name = language:get(<<"炎灵">>)
            ,map_id = 10002
            ,map_name = language:get(<<"青云岭">>)
            ,interval = 30
            ,pos_list = [{2220,1920}]
        }
    };

get(25000) ->
    {ok, #boss_base{
            npc_id = 25000
            ,npc_lev = 40 
            ,npc_name = language:get(<<"白泽">>)
            ,map_id = 10002
            ,map_name = language:get(<<"青云岭">>)
            ,interval = 30
            ,pos_list = [{2220,1920}]
        }
    };

get(NpcId) ->
    {false, util:fbin(language:get(<<"没有该世界boss的信息[Id:~w]">>), [NpcId])}.
