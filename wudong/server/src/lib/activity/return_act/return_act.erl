%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 十二月 2017 14:30
%%%-------------------------------------------------------------------
-module(return_act).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
%% API
-export([
    init/1,
    update/1,
    get_re_day/0,
    get_re_state/1,
    get_notice_state/1,
    get_re_list/1]).

-define(RETURN_DAY, 3). %% 连续未登陆天数
-define(RETURN_LV, 80). %% 回归等级
-define(CONTINUE_TIME, 12). %% 回归身份有效期

init(Player) ->
    Now = util:unixtime(),
    ReturnDay =
        if
            Player#player.logout_time == 0 -> 0;
            true ->
                max(0, util:get_diff_days(Now, Player#player.logout_time) - 1)
        end,

    NewPlayer =
        if
            ReturnDay >= ?RETURN_DAY andalso Player#player.lv >= ?RETURN_LV ->
                Time = activity:get_leave_time(data_re_notice),
                Player#player{
                    return_time = Now,
                    continue_end_time = Now + Time + ?CONTINUE_TIME * ?ONE_DAY_SECONDS
                };
            true ->
                        Player
        end,
    update(NewPlayer).


update(Player) ->
    Now = util:unixdate(),
    Time0 = activity:get_leave_time(data_re_notice),
    if
        Player#player.continue_end_time > Now andalso Time0 > 0->
            Time = ?IF_ELSE(Time0 < 0, 0, Time0),
            Player#player{
                continue_end_time = Now + Time + ?CONTINUE_TIME * ?ONE_DAY_SECONDS
            };
        true ->
            Player
    end.

%% 获取回归天数
get_re_day() ->
    Day = 0,
    ?IF_ELSE(Day =< ?RETURN_DAY orelse Day > 30, 0, Day).

%% 获取回归状态
get_re_state(Player) ->
%%     true.
    Now = util:unixdate(),
    ?IF_ELSE(Player#player.continue_end_time > Now, true, false).

get_notice_state(Player) ->
    case get_re_state(Player) of
        true ->
            case re_notice:get_act() of
                [] -> -1;
                _ ->
                    List = get_re_list(Player),
                    StateList = [State0 || [_, State0] <- List],
                    case StateList of
                        [] -> -1;
                        _ ->
                            max(-1, lists:max(StateList))
                    end
            end;
        _ ->
            -1
    end.
%%
%% get_re_list(Player) ->
%%     Now = util:unixdate(),
%%     if
%%         Player#player.continue_end_time < Now -> [];
%%         true ->
%%             [
%%                 [1, re_notice:get_state(Player)], %% 广告
%%                 [2, re_login:get_state(Player)], %% 回归登陆
%%                 [3, re_recharge_inf:get_state(Player)], %% 充值有礼
%%                 [4, re_exchange:get_state(Player)] %% 兑换
%%             ]
%%     end.
get_re_list(Player) ->
    [
        [1, re_notice:get_state(Player)], %% 广告
        [2, re_login:get_state(Player)], %% 回归登陆
        [3, re_recharge_inf:get_state(Player)], %% 充值有礼
        [4, re_exchange:get_state(Player)] %% 兑换
    ].