%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 八月 2017 10:25
%%%-------------------------------------------------------------------
-module(bomb).
-author("hxming").

-include("common.hrl").
-include("scene.hrl").
%% API
-export([bomb/1]).

%%爆炸
bomb(Mon) ->
    if Mon#mon.kind =/= ?MON_KIND_REMOVE_TRAP -> skip;
        Mon#mon.dieeff == [] -> skip;
        true ->
            Bs = battle:init_data(Mon, util:longunixtime()),
            Attacker = battle:make_attacker(Bs, 0),
            F = fun(Target) ->
                if
                    is_record(Target, mon) ->
                        Target#mon.pid ! {buff_list, Mon#mon.dieeff, Attacker};
                    true ->
                        server_send:send_node_pid(Target#scene_player.node, Target#scene_player.pid, {buff_list, Mon#mon.dieeff, Attacker})
                end
                end,
            lists:foreach(F, get_target_list(Mon)),
            ok
    end.


%%获取伤害目标
get_target_list(Mon) ->
    scene_agent:get_scene_obj_for_battle(Mon#mon.scene, Mon#mon.copy, Mon#mon.x, Mon#mon.y, Mon#mon.att_area, [Mon#mon.key], Mon#mon.group).