%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 七月 2016 11:19
%%%-------------------------------------------------------------------
-module(task_kill).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("battle.hrl").
-include("task.hrl").

%% API
-compile(export_all).

%%经常玩家死亡
check_die(Player, Attacker) ->
    if Player#player.sn == Attacker#attacker.sn -> skip;
        true ->
            cross_area:apply(task_kill, check_kill, [Attacker#attacker.key, Attacker#attacker.node, Player#player.sn])
    end.

%%
check_kill(Key, Node, Sn) ->
    center:apply(Node, task_kill, check_kmb, [Key, Sn]),
    ok.

check_kmb(Key, Sn) ->
    case ets:lookup(?ETS_ONLINE, Key) of
        [] -> skip;
        [Online] ->
            Online#ets_online.pid ! {task_kmb, Sn}
    end.

%%任务击杀异服玩家
task_kmb(_Player, _Sn) ->
    task_event:event(?TASK_ACT_KMB, {1}).
%%    Key = lists:concat([Player#player.key, Sn]),
%%    case cache:get(Key) of
%%        [] ->
%%            task_event:event(?TASK_ACT_KMB, {1}),
%%            cache:set(Key, Sn, ?ONE_HOUR_SECONDS),
%%            ok;
%%        _ -> skip
%%    end.

