%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 一月 2015 18:08
%%%-------------------------------------------------------------------
-module(daily_init).
-include("common.hrl").
-include("daily.hrl").
-include("server.hrl").

%% API
-export([
    init/1,
    logout/0,
    timer_update/0
]).

%%玩家登陆，日常计数初始化
init(Player) ->
    NowDate = util:unixdate(),
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_DAILY, #st_daily_count{pkey = Player#player.key, time = NowDate});
        false ->
            case daily_load:dbload_daily_data(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_DAILY, #st_daily_count{pkey = Player#player.key, time = NowDate});
                [DailyCount, Time] ->
                    case util:is_same_date(Time, NowDate) of
                        false ->
                            lib_dict:put(?PROC_STATUS_DAILY, #st_daily_count{pkey = Player#player.key, time = NowDate});
                        true ->
                            Dict = dict:from_list(util:bitstring_to_term(DailyCount)),
                            lib_dict:put(?PROC_STATUS_DAILY, #st_daily_count{pkey = Player#player.key, daily_count = Dict, time = Time})
                    end
            end
    end,
    Player.

%%玩家离线，存储数据
logout() ->
    DailyCount = lib_dict:get(?PROC_STATUS_DAILY),
    if DailyCount#st_daily_count.is_change /= 0 ->
        daily_load:dbreplace_daily_data(DailyCount);
        true -> skip
    end.

timer_update() ->
    DailyCount = lib_dict:get(?PROC_STATUS_DAILY),
    if DailyCount#st_daily_count.is_change /= 0 ->
        daily_load:dbreplace_daily_data(DailyCount),
        lib_dict:put(?PROC_STATUS_DAILY, DailyCount#st_daily_count{is_change = 0});
        true -> skip
    end.
