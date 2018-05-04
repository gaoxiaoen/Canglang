%%----------------------------------------------------
%% NPC相关远程调用
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(npc_rpc).
-export([handle/3]).

-include("common.hrl").
-include("npc.hrl").

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
