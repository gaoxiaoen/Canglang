%%----------------------------------------------------
%% 新手流程
%% @author 
%%----------------------------------------------------
-module(tutorial_data).
-include("common.hrl").
-include("npc.hrl").
-include("pos.hrl").
-include("tutorial.hrl").
-export([
    npc/1     
    ,npc_id/1
]).

npc(1) ->
    {?tutorial_npc1, ?tutorial_npc1_pos_x, ?tutorial_npc1_pos_y};
npc(_) ->
    undefined.

npc_id(?tutorial_npc1) -> 1;
npc_id(_) -> 0.
