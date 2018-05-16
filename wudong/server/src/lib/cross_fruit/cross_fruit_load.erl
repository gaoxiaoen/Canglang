%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2017 上午11:10
%%%-------------------------------------------------------------------
-module(cross_fruit_load).
-author("fengzhenlin").
-include("cross_fruit.hrl").
-include("server.hrl").

%% API
-compile([export_all]).

dbget_fruit_info(Player) ->
    Init = #st_cross_fruit{
        pkey = Player#player.key
    },
    case player_util:is_new_role(Player) of
        true ->
            Init;
        false ->
            Sql = io_lib:format("select get_times,update_time,win_times,win_update_time from player_cross_fruit where pkey=~p",[Player#player.key]),
            case db:get_row(Sql) of
                [] -> Init;
                [GetTimes, UpdateTime, WinTimes, WinUpdateTime] ->
                    Init#st_cross_fruit{
                        get_times = GetTimes,
                        update_time = UpdateTime,
                        win_times = WinTimes,
                        win_update_time = WinUpdateTime
                    }
            end
    end.

dbup_fruit_info(St) ->
    #st_cross_fruit{
        pkey = Pkey,
        get_times = GetTimes,
        update_time = UpdateTime,
        win_times = WinTimes,
        win_update_time = WinUpdateTime
    } = St,
    Sql = io_lib:format("replace into player_cross_fruit set pkey=~p,get_times=~p,update_time=~p,win_times=~p,win_update_time=~p", [Pkey, GetTimes, UpdateTime, WinTimes, WinUpdateTime]),
    db:execute(Sql),
    ok.

dbget_cross_fruit_player() ->
    Sql = io_lib:format("select pkey,name,sn,career,sex,avatar,win_times from cross_fruit_player", []),
    case db:get_all(Sql) of
        [] -> skip;
        L ->
            F = fun([Pkey,Name,Sn,Career,Sex,Avatar,WinTimes]) ->
                    FP = #cross_fruit_player{
                        pkey = Pkey,
                        name = Name,
                        sn = Sn,
                        career = Career,
                        sex = Sex,
                        vatar = Avatar,

                        win_times = WinTimes
                    },
                    ets:insert(?ETS_CROSS_FRUIT_PLAYER, FP)
                end,
            lists:foreach(F, L)
    end,
    ok.

dbup_cross_fruit_player(FP) ->
    #cross_fruit_player{
        pkey = Pkey,
        name = Name,
        sn = Sn,
        career = Career,
        sex = Sex,
        vatar = Avatar,

        win_times = WinTimes
    } = FP,
    Sql = io_lib:format("replace into cross_fruit_player set pkey=~p,name='~s',sn=~p,career=~p,sex=~p,avatar='~s',win_times=~p",
        [Pkey, Name, Sn, Career, Sex, Avatar, WinTimes]),
    db:execute(Sql),
    ok.
