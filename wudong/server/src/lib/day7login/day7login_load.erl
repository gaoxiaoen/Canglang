%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 下午4:37
%%%-------------------------------------------------------------------
-module(day7login_load).
-author("fengzhenlin").
-include("server.hrl").
-include("day7login.hrl").
-include("common.hrl").
%% API
-export([
    dbget_info/1,
    dbup_day7login/1
]).

dbget_info(Player) ->
    F = fun(Day) ->
        if
            Day == 1 -> {Day, 2, 0};
            true -> {Day, 3, 0}
        end
    end,
    DaysinfoInit = lists:map(F, data_day7login:get_all()),
    Now = util:unixtime(),
    NewSt = #st_day7{
        pkey = Player#player.key,
        day_list = DaysinfoInit,
        time = Now
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select daysinfo,`time` from player_day7login where pkey = ~p",
                [Player#player.key]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [DaysInfoBin, UpdateTime] ->
                    Daysinfo0 = util:bitstring_to_term(DaysInfoBin),
                    Len = length(data_day7login:get_all()),
                    if
                        length(Daysinfo0) < Len ->
                            F0 = fun(Day, List) ->
                                case lists:keyfind(Day, 1, List) of
                                    false ->
                                        [{Day, 3, 0} | List];
                                    _Val -> List
                                end
                            end,
                            Daysinfo1 = lists:foldl(F0, Daysinfo0, data_day7login:get_all()); %% 旧数据兼容
                        true -> Daysinfo1 = Daysinfo0
                    end,
                    Daysinfo = lists:keysort(1,Daysinfo1),
                    #st_day7{
                        pkey = Player#player.key,
                        day_list = Daysinfo,
                        time = UpdateTime
                    }
            end
    end.

dbup_day7login(Day7St) ->
    #st_day7{
        pkey = Pkey,
        time = UpdateTime,
        day_list = DayList
    } = Day7St,
    Sql = io_lib:format("replace into player_day7login set daysinfo='~s',`time`=~p, pkey=~p",
        [util:term_to_bitstring(DayList), UpdateTime, Pkey]),
    db:execute(Sql),
    ok.
