%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 三月 2017 15:42
%%%-------------------------------------------------------------------
-module(cross_elite_init).
-author("hxming").

-include("cross_elite.hrl").
-include("common.hrl").
-include("server.hrl").
%% API
-export([init/1, timer_update/0, logout/0, midnight_refresh/1]).
-export([get_score/0, init_data/1]).

init(Player) ->
    Now = util:unixtime(),
    StElite =
        case player_util:is_new_role(Player) of
            true ->
                #st_elite{pkey = Player#player.key, time = Now};
            false ->
                init_data(Player#player.key)
        end,
    lib_dict:put(?PROC_STATUS_ELITE, StElite),
    Player.

init_data(Pkey) ->
    Now = util:unixtime(),
    case cross_elite_load:load_elite(Pkey) of
        [] ->
            #st_elite{pkey = Pkey, time = Now};
        [Lv, Score, Times, DailyScore, Reward, Time] ->
            case util:is_same_date(Time, Now) of
                true ->
                    #st_elite{pkey = Pkey, lv = Lv, score = Score, times = Times, daily_score = DailyScore, reward = util:bitstring_to_term(Reward), time = Time};
                false ->
                    #st_elite{pkey = Pkey, lv = Lv, score = Score, time = Now}
            end
    end.

timer_update() ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    if StElite#st_elite.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_ELITE, StElite#st_elite{is_change = 0}),
        cross_elite_load:replace_elite(StElite);
        true -> ok
    end.

logout() ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    if StElite#st_elite.is_change == 1 ->
        cross_elite_load:replace_elite(StElite);
        true -> ok
    end.

midnight_refresh(Now) ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    lib_dict:put(?PROC_STATUS_ELITE, StElite#st_elite{reward = [], times = 0, daily_score = 0, time = Now, is_change = 1}),
    ok.


%%获取积分
get_score() ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    StElite#st_elite.score.


