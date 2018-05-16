%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 10:35
%%%-------------------------------------------------------------------
-module(fairy_soul_init).
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("fairy_soul.hrl").

%% API
-export([
    init/1
    , update/1
]).

init(#player{key = Pkey} = Player) ->
    StFairySoul =
        case player_util:is_new_role(Player) of
            true ->
                #st_fairy_soul{pkey = Pkey};
            false ->
                fairy_soul_load:dbget_fairy_soul_info(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_FAIRY_SOUL, StFairySoul),
    update(Player#player.lv),
    Player.

update(Lv) ->
    LvList = data_fairy_soul_open:get_all(),
    List = [Lv0 || Lv0 <- LvList, Lv0 =< Lv],
    MaxPos = if List == [] -> 1;
                 true ->
                     data_fairy_soul_open:get(lists:max(List))
             end,
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    lib_dict:put(?PROC_STATUS_FAIRY_SOUL, StFairySoul#st_fairy_soul{pos = MaxPos}),
    fairy_soul_load:dbup_fairy_soul_info(StFairySoul#st_fairy_soul{pos = MaxPos}),
    ok.
