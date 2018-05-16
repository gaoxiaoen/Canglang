%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 十二月 2016 14:16
%%%-------------------------------------------------------------------
-module(manor_war_task).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("manor_war.hrl").
-include("task.hrl").
%% API
-compile(export_all).

%%零点刷新任务
midnight_refresh() ->
    F = fun(ManorWar) ->
        if ManorWar#manor_war.scene_list == [] -> ok;
            true ->
                TaskIds = get_task_ids(ManorWar#manor_war.scene_list),
                PidList = guild_util:get_guild_member_pids_online(ManorWar#manor_war.gkey),
                [Pid ! {accept_manor_task, TaskIds} || Pid <- PidList]
        end
        end,
    lists:foreach(F, ets:tab2list(?ETS_MANOR_WAR)),
    ok.

get_task_ids(SceneList) ->
    F = fun({SceneId,_}) ->
        case data_manor_war_scene:get(SceneId) of
            [] -> [];
            Base -> [Base#base_manor_war.task_id]
        end
        end,
    lists:flatmap(F, SceneList).


%%玩家登陆
init(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] ->
            ok;
        [ManorWar] ->
            if ManorWar#manor_war.scene_list == [] -> ok;
                true ->
                    TaskIds = get_task_ids(ManorWar#manor_war.scene_list),
                    task:accept_manor_task(Player, TaskIds)
            end
    end.

