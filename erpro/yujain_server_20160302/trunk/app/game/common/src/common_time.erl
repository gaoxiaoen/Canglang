%%%-------------------------------------------------------------------
%%% File        :common_time.erl
%%% @doc
%%%     时间辅助函数
%%% @end
%%%-------------------------------------------------------------------

-module(common_time).

%% API
-export([
         midnight/0,
         weekday/0,
         diff_next_weekdaytime/3,
         diff_next_daytime/2,
         week_of_year/0,
         week_of_year/1,
         time_to_date/1,
         diff_date/2,
         add_days/2,
         date_to_time/1,
		 date_to_seconds/0,
		 date_to_seconds/1,
		 diff_next_weekday/1,
		 diff_seconds_between_datetimes/2,
		 diff_days_between_dates/2
        ]).

%%@doc 增加日期
add_days(TheDate,Diff) when is_integer(Diff) andalso is_tuple(TheDate) ->
    case TheDate of
        {Date, Time} ->            
            GregDate2 = calendar:date_to_gregorian_days(Date)+Diff,
            {calendar:gregorian_days_to_date(GregDate2), Time};
        _ ->
            GregDate2 = calendar:date_to_gregorian_days(TheDate)+Diff,
            calendar:gregorian_days_to_date(GregDate2)
    end.


%%@doc 计算日期是当年中的第几周,简单算法
week_of_year()->
    week_of_year( erlang:date() ).
week_of_year({_Year,_Month,_Day}=Date)->
    DaySum = get_date_sum(Date,0),
    ((DaySum-1) div 7) + 1.

time_to_date(Time) when erlang:is_integer(Time) ->
    Date = {Time div 1000000, Time rem 1000000, 0},
    {Date2, _} = calendar:now_to_local_time(Date),
    Date2.

diff_seconds_between_datetimes(DateTime1, DateTime2) ->
	calendar:datetime_to_gregorian_seconds(DateTime2) - calendar:datetime_to_gregorian_seconds(DateTime1).

diff_days_between_dates(Date1, Date2) ->
	calendar:date_to_gregorian_days(Date2) - calendar:date_to_gregorian_days(Date1).

date_to_seconds() ->
	date_to_seconds(calendar:local_time()).
date_to_seconds({{_Y, _M, _D} = Date}) ->
	date_to_seconds({Date, {0, 0, 0}});
date_to_seconds(DateTime) ->
	calendar:datetime_to_gregorian_seconds(DateTime).

date_to_time({Date, Time}) ->
    calendar:datetime_to_gregorian_seconds({Date, Time}) - calendar:datetime_to_gregorian_seconds({{1970,1,1}, {0,0,0}});
date_to_time({Y,M,D}) ->
    calendar:datetime_to_gregorian_seconds({{Y,M,D}, {0,0,0}}) - calendar:datetime_to_gregorian_seconds({{1970,1,1}, {0,0,0}}).


diff_date(Date1, Date2) ->
    erlang:abs( calendar:date_to_gregorian_days(Date1) - calendar:date_to_gregorian_days(Date2) ).


get_date_sum({_Year,1,Day},DaysAccIn)->
    DaysAccIn+Day;
get_date_sum({Year,Month,Day},DaysAccIn)->
    NewDays = calendar:last_day_of_the_month(Year,Month-1) + DaysAccIn,
    get_date_sum({Year,Month-1,Day},NewDays).

%%今天凌晨0点的time
midnight() ->
    common_tool:now() - calendar:time_to_seconds(erlang:time()).

%%今天星期几
weekday() ->
    {Date, _} = calendar:local_time(),
    calendar:day_of_the_week(Date).

%%距离到下个星期几的几时几分还有多少秒
diff_next_weekdaytime(WeekDay, Hour, Min) ->
    Today = ?MODULE:weekday(),
    case Today > WeekDay of
        true ->
            (7 - Today + WeekDay) * 24 * 3600 + Hour * 3600 + Min * 60 - (calendar:time_to_seconds(erlang:time()));
        false ->            
            Rtn = (WeekDay - Today) * 24 * 3600 + Hour * 3600 + Min * 60 - (calendar:time_to_seconds(erlang:time())),
            case Rtn < 0 of
                true ->
                    7 * 86400 + Rtn;
                false ->
                    Rtn
            end            
    end.

%%距离到下个星期几有几天
diff_next_weekday(WeekDay) ->
    Today = ?MODULE:weekday(),
    case Today >= WeekDay of
        true ->
            7 - Today + WeekDay;
        false ->            
            WeekDay - Today          
    end.

%%距离到明天的几时几分还有多少秒
diff_next_daytime(Hour, Min) ->
    86400 + Hour * 3600 + Min *60 - (calendar:time_to_seconds(erlang:time())).
    
