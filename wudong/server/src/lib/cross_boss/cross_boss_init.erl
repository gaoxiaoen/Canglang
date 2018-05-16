%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 六月 2016 10:25
%%%-------------------------------------------------------------------
-module(cross_boss_init).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("cross_boss.hrl").
-include("scene.hrl").
%% API
-compile(export_all).


%%初始化boss
init_boss() ->
    default_boss_list().

%%默认boss
default_boss_list() ->
    case data_cross_boss:ids() of
        [] -> [];
        Ids -> Ids
    end.

init_boss_hp() ->
    Ids = data_cross_boss:ids(),
    F = fun(Id) -> #mon{hp_lim = HpLim} = data_mon:get(Id), {Id, HpLim, HpLim} end,
    lists:map(F, Ids).

init(#player{key = Pkey} = Player) ->
    StPlayerCrossBoss =
        case player_util:is_new_role(Player) of
            true -> #st_player_cross_boss{pkey = Pkey};
            false -> cross_boss_load:load(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_CROSS_BOSS_DROP_NUM, StPlayerCrossBoss),
    cross_boss:update_player_cross_boss(),
    Player.