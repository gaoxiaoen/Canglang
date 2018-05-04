%%----------------------------------------------------
%% 任务掉落信息
%% @Author jackguan@jieyou.cn
%% @Create: 2011-10-17 
%%----------------------------------------------------
-module(task_data_drop).
-export([
        get_drop/2
    ]
).
-include("common.hrl").
-include("task.hrl").

%% @spec get(Type, Id) -> {ok, TaskDrop} | {false, Reason}
%% @doc
%% <pre>
%% Type = by_npc | by_item 查找类型
%% Id = integer() Npc基础Id或者是任务物品基础Id
%% TaskDrop = #task_drop{} 任务物品掉落信息
%% </pre>
get_drop(by_npc, 20001) ->
    get_drop(by_item, 20000);
get_drop(by_item, 20000) ->
    {ok, #task_drop{
            npc_id = 20001
            ,item_id = 20000
            ,prob = 100
            ,map_id = 10001
        }
    };
get_drop(by_npc, 50007) ->
    get_drop(by_item, 20001);
get_drop(by_item, 20001) ->
    {ok, #task_drop{
            npc_id = 50007
            ,item_id = 20001
            ,prob = 100
            ,map_id = 10001
        }
    };
get_drop(by_npc, 50010) ->
    get_drop(by_item, 20003);
get_drop(by_item, 20003) ->
    {ok, #task_drop{
            npc_id = 50010
            ,item_id = 20003
            ,prob = 100
            ,map_id = 10002
        }
    };
get_drop(by_npc, 20019) ->
    get_drop(by_item, 20012);
get_drop(by_item, 20012) ->
    {ok, #task_drop{
            npc_id = 20019
            ,item_id = 20012
            ,prob = 100
            ,map_id = 10004
        }
    };
get_drop(by_npc, 20022) ->
    get_drop(by_item, 20013);
get_drop(by_item, 20013) ->
    {ok, #task_drop{
            npc_id = 20022
            ,item_id = 20013
            ,prob = 100
            ,map_id = 10004
        }
    };
get_drop(by_npc, 50013) ->
    get_drop(by_item, 20028);
get_drop(by_item, 20028) ->
    {ok, #task_drop{
            npc_id = 50013
            ,item_id = 20028
            ,prob = 100
            ,map_id = 10003
        }
    };
get_drop(by_npc, 50014) ->
    get_drop(by_item, 20030);
get_drop(by_item, 20030) ->
    {ok, #task_drop{
            npc_id = 50014
            ,item_id = 20030
            ,prob = 100
            ,map_id = 10004
        }
    };
get_drop(by_npc, 50015) ->
    get_drop(by_item, 20029);
get_drop(by_item, 20029) ->
    {ok, #task_drop{
            npc_id = 50015
            ,item_id = 20029
            ,prob = 100
            ,map_id = 10003
        }
    };
get_drop(by_npc, 50008) ->
    get_drop(by_item, 20032);
get_drop(by_item, 20032) ->
    {ok, #task_drop{
            npc_id = 50008
            ,item_id = 20032
            ,prob = 100
            ,map_id = 10001
        }
    };
get_drop(by_npc, 50012) ->
    get_drop(by_item, 20033);
get_drop(by_item, 20033) ->
    {ok, #task_drop{
            npc_id = 50012
            ,item_id = 20033
            ,prob = 100
            ,map_id = 10002
        }
    };
get_drop(by_npc, 50018) ->
    get_drop(by_item, 20034);
get_drop(by_item, 20034) ->
    {ok, #task_drop{
            npc_id = 50018
            ,item_id = 20034
            ,prob = 100
            ,map_id = 10002
        }
    };
get_drop(by_npc, 50019) ->
    get_drop(by_item, 20035);
get_drop(by_item, 20035) ->
    {ok, #task_drop{
            npc_id = 50019
            ,item_id = 20035
            ,prob = 100
            ,map_id = 10003
        }
    };
get_drop(by_npc, 50029) ->
    get_drop(by_item, 20037);
get_drop(by_item, 20037) ->
    {ok, #task_drop{
            npc_id = 50029
            ,item_id = 20037
            ,prob = 100
            ,map_id = 10002
        }
    };
get_drop(by_npc, 50030) ->
    get_drop(by_item, 20038);
get_drop(by_item, 20038) ->
    {ok, #task_drop{
            npc_id = 50030
            ,item_id = 20038
            ,prob = 100
            ,map_id = 10004
        }
    };
get_drop(by_npc, 50028) ->
    get_drop(by_item, 20036);
get_drop(by_item, 20036) ->
    {ok, #task_drop{
            npc_id = 50028
            ,item_id = 20036
            ,prob = 100
            ,map_id = 10002
        }
    };
get_drop(by_npc, 60305) ->
    get_drop(by_item, 124016);
get_drop(by_item, 124016) ->
    {ok, #task_drop{
            npc_id = 60305
            ,item_id = 124016
            ,prob = 100
            ,map_id = 10001
        }
    };
get_drop(by_npc, 50006) ->
    get_drop(by_item, 25012);
get_drop(by_item, 25012) ->
    {ok, #task_drop{
            npc_id = 50006
            ,item_id = 25012
            ,prob = 100
            ,map_id = 10004
        }
    };
get_drop(_Type, _ItemBaseId) ->
    {false, <<"没有找到掉落信息">>}.
