%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 九月 2015 上午10:41
%%%-------------------------------------------------------------------
-module(npc).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("task.hrl").

%% API
-export([
    get_npc_task/3
]).

%%默认对话
get_npc_task(Player, NpcId, 0) ->
    case data_npc:get(NpcId) of
        [] -> skip;
        Npc ->
            {ok, Bin} = pt_320:write(32001, {NpcId, Npc#npc.talk, 0, 0, [], []}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end;

get_npc_task(Player, NpcId, TaskId) ->
    task_event:event(?TASK_ACT_NPC, {TaskId, NpcId}),
    case task:get_npc_task(TaskId) of
        [] ->
            task:refresh_client_task_all(Player),
            get_npc_task(Player, NpcId, 0);
        Task ->
            if Task#task.npcid /= NpcId andalso Task#task.endnpcid /= NpcId ->
                get_npc_task(Player, NpcId, 0);
                true ->
                    TalkId = ?IF_ELSE(Task#task.state == ?TASK_ST_FINISH orelse Task#task.state == ?TASK_ST_ACCEPT, Task#task.endtalkid, Task#task.talkid),
                    GoodsList = goods_list(Player, Task),
                    {ok, Bin} = pt_320:write(32001, {NpcId, TalkId, TaskId, Task#task.state, GoodsList, []}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end

    end.

goods_list(Player, Task) ->
    if Task#task.type == ?TASK_TYPE_CONVOY ->
        GoodsList = task_convoy:convoy_goods(Player),
        goods:pack_goods(GoodsList);
        Task#task.type == ?TASK_TYPE_CYCLE ->
            lists:foldl(fun(Award, Out) ->
                case Award of
                    {Career, GoodsType, Num} when Player#player.career =:= Career orelse Career == 0 ->
                        [[GoodsType, Num] | Out];
                    {GoodsType, Num} ->
                        [[GoodsType, Num] | Out];
                    _ ->
                        Out
                end
                        end, [], Task#task.goods);
        true ->
            lists:foldl(fun(Award, Out) ->
                case Award of
                    {Career, GoodsType, Num} when Player#player.career =:= Career orelse Career == 0 ->
                        [[GoodsType, Num] | Out];
                    {GoodsType, Num} ->
                        [[GoodsType, Num] | Out];
                    _ ->
                        Out
                end
                        end, [], Task#task.goods)
    end.
%%npc状态
%% get_npc_state(Player,SceneId) ->
%%     case data_scene:get(SceneId) of
%%         [] -> skip;
%%         Scene ->
%%             NpcList = [NpcId||[NpcId,_x,_y]<-Scene#scene.npc],
%%             StTask = lib_dict:get(?PROC_STATUS_TASK),
%%             TaskList = StTask#st_task.tasklist,
%%             ActiveList = StTask#st_task.activelist,
%%             F = fun(NpcId) ->
%%                        case is_task_with_npc(ActiveList,NpcId,[]) of
%%                            [] ->
%%                                case is_task_with_npc(TaskList,NpcId,[]) of
%%                                    [] -> [];
%%                                    Task ->
%%                                        [[NpcId,Task#task.taskid,Task#task.state]]
%%                                end;
%%                            ATask ->
%%                                [[NpcId,ATask#task.taskid,ATask#task.state]]
%%                        end
%%                 end,
%%             NpcTask = lists:flatmap(F,NpcList),
%%             {ok,Bin} = pt_320:write(32002,{NpcTask}),
%%             server_send:send_to_sid(Player#player.sid,Bin),
%%             ok
%%     end.
%%
%% is_task_with_npc([],_Npcid,TaskData) -> TaskData;
%% is_task_with_npc([Task|L],NpcId,TaskData) ->
%%     if
%%         Task#task.endnpcid  == NpcId ->
%%             is_task_with_npc([],NpcId,Task);
%%         true ->
%%             is_task_with_npc(L,NpcId,TaskData)
%%     end.
