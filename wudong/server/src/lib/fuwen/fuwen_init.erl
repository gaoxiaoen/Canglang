%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2017 15:47
%%%-------------------------------------------------------------------
-module(fuwen_init).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("fuwen.hrl").
-include("goods.hrl").

%% API
-export([
    init/1
]).

init(#player{key = Pkey} = Player) ->
    StFuwen =
        case player_util:is_new_role(Player) of
            true ->
                #st_fuwen{pkey = Pkey};
            false ->
                fuwen_load:dbget_self_fuwen_info(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_FUWEN, StFuwen),
    Player.

