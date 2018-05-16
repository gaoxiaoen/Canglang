%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 九月 2015 上午10:38
%%%-------------------------------------------------------------------
-module(npc_rpc).
-author("fancy").

-include("common.hrl").
%% API
-export([handle/3]).

%%npc 对话
handle(32001,Player,{NpcId,TaskId}) ->
    npc:get_npc_task(Player,NpcId,TaskId),
    ok;


handle(_cmd,_Player,_Data) ->
    ok.
