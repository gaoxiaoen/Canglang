%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 下午4:37
%%%-------------------------------------------------------------------
-module(day7login_init).
-author("fengzhenlin").
-include("common.hrl").
-include("day7login.hrl").
-include("server.hrl").

%% API
-export([
    init/1,
    update/1
]).

init(Player) ->
    Day7St = day7login_load:dbget_info(Player),
    lib_dict:put(?PROC_STATUS_DAY7LOGIN,Day7St),
    update(Player),
    Player.

update(_Player) ->
    Day7St = lib_dict:get(?PROC_STATUS_DAY7LOGIN),
    Now = util:unixtime(),
    DaysList = [{Days,State,Time}||{Days,State,Time}<-Day7St#st_day7.day_list,State =/= 3], %% 获取已领取和可领取的列表
    {LastDays,_State,_GetTime} = hd(lists:reverse(lists:keysort(1,DaysList))),%% 获取已领取和可领取的最后一天
    Len = length(data_day7login:get_all()),
    if
        LastDays > Len -> skip;
        true ->
            case util:is_same_date(Now,Day7St#st_day7.time) of
                true -> Day7St; %% 上次登陆为同一天,不做操作
                false ->
                    NewDays = LastDays + 1,
                    NewDaysInfo = {NewDays,2,0},
                    NewDaysList = lists:keyreplace(NewDays,1,Day7St#st_day7.day_list,NewDaysInfo),
                    NewDay7St = Day7St#st_day7{
                        day_list = NewDaysList,
                        time = Now
                    },
                    lib_dict:put(?PROC_STATUS_DAY7LOGIN,NewDay7St)
            end
    end.



