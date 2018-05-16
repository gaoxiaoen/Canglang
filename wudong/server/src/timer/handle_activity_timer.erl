
%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%               %% 用于活动时间内的开启与关闭
%%% @end
%%%-------------------------------------------------------------------
-module(handle_activity_timer).
-author("lzx").
-include("common.hrl").

%%每分钟执行
%%每个模块需要自定的函数
%% campaign_ready  campaign_start   campaign_end
%% get_open_time
%% @doc 不支持跨服啊
-define(MODULE_LIST_MINUTE, [
    act_festive_boss
]).

%% API
-export([init/0,handle/2,terminate/2,player_login/1]).

init() ->
    {ok, ?MODULE}.

handle(State, Unixtime) ->
    spawn(fun() ->
        case center:is_center_all() orelse center:is_center_area() of
            true ->
                ok;
            _ ->
                WeekDay = util:get_day_of_week(),
                {Hour, Min} = util:unixtime_hour_min(Unixtime),
                check_campaign_open(?MODULE_LIST_MINUTE, WeekDay, Hour, Min, Unixtime)
        end end),
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

check_campaign_open([Moudle|T],WeekDay,Hour,Min,Unixtime) ->
    {OpenWeekList,[ReadyTimeList,StartTimeList,EndTimeList]} = Moudle:get_open_time(Unixtime),
    case lists:member(WeekDay,OpenWeekList) of
        true ->
            FunList = [{campaign_ready,ReadyTimeList},{campaign_start,StartTimeList},{campaign_end,EndTimeList}],
            [campgin_check(Moudle,Hour,Min,Fun,ArgList) || {Fun,ArgList} <- FunList];
        false ->
            skip
    end,
    check_campaign_open(T,WeekDay,Hour,Min,Unixtime);
check_campaign_open([],_,_,_,_) -> ok.


campgin_check(Moudle,Hour,Min,Fun,[{Hour,Min}|_]) ->
    erlang:apply(Moudle,Fun,[]);
campgin_check(Moulde,Hour,Min,Fun,[_|T]) ->
    campgin_check(Moulde,Hour,Min,Fun,T);
campgin_check(_,_,_,_,[]) -> ok.


%% %% @doc 玩家登陆
player_login(Status) ->
    [erlang:apply(Moudle,send_login_state,[Status])||Moudle <- ?MODULE_LIST_MINUTE].



















