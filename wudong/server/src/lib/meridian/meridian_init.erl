%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十一月 2016 13:43
%%%-------------------------------------------------------------------
-module(meridian_init).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("meridian.hrl").

%% API
-export([init/1, record2list/1, logout/0, timer_update/0]).

init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_MERIDIAN, #st_meridian{pkey = Player#player.key});
        false ->
            case meridian_load:load(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_MERIDIAN, #st_meridian{pkey = Player#player.key});
                [MeridianList] ->
                    NewMeridianList = list2record(util:bitstring_to_term(MeridianList)),
                    Attribute = meridian:calc_meridian_attribute(NewMeridianList),
                    lib_dict:put(?PROC_STATUS_MERIDIAN, #st_meridian{pkey = Player#player.key, meridian_list = NewMeridianList, attribute = Attribute})
            end
    end,
    Player.

%%数据转换
record2list(MeridianList) ->
    F = fun(Meridian) ->
        {Meridian#meridian.type, Meridian#meridian.subtype, Meridian#meridian.lv, Meridian#meridian.break_lv, Meridian#meridian.cd, Meridian#meridian.in_cd}
        end,
    lists:map(F, MeridianList).

list2record(MeridianList) ->
    F = fun({Type, SubType, Lv, BreakLv, Cd, InCd}) ->
        #meridian{type = Type, subtype = SubType, lv = Lv, break_lv = BreakLv, cd = Cd, in_cd = InCd}
        end,
    lists:map(F, MeridianList).

%%定时更新
timer_update() ->
    StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
    if StMeridian#st_meridian.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_MERIDIAN, StMeridian#st_meridian{is_change = 0}),
        meridian_load:replace(StMeridian);
        true ->
            ok
    end.

%%玩家离线
logout() ->
    StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
    if StMeridian#st_meridian.is_change == 1 ->
        meridian_load:replace(StMeridian);
        true ->
            ok
    end.

