%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 二月 2017 17:45
%%%-------------------------------------------------------------------
-module(more_exp).
-author("luobq").
-include("daily.hrl").
-include("server.hrl").
-include("common.hrl").
-include("more_exp.hrl").


%% API
-export([
    get_more_exp_info/0
    , update/2
    , init/1
    , get_reward/1
]).

init(Player) ->
    Now = util:unixtime(),
    Date = util:unixdate(Now),
    NowSec = util:get_seconds_from_midnight(Now),
    case [{Id, S, E} || {Id, [S, E]} <- exp_activity_proc:time_list(), E > NowSec] of
        [] ->
            MoreExp = #more_exp{},
            lib_dict:put(?PROC_STATUS_MORE_EXP, MoreExp),
            ok;
        TimeList ->
            {State, _LastTime, _Exp, Reward} = more_exp:get_more_exp_info(),
            {_Id, Star, End} = hd(TimeList),
            MoreExp =
                #more_exp{
                    state = State,
                    reward = Reward,
                    start_time = Date + Star,
                    end_time = Date + End
                },
            lib_dict:put(?PROC_STATUS_MORE_EXP, MoreExp)
    end,
    Player.

get_more_exp_info() ->
    {State, LastTime} = exp_activity_proc:more_exp_info(),
    Reward = exp_activity_proc:more_exp_reward(),
    Exp = daily:get_count(?DAILY_MORE_EXP),%% 多倍经验获得计数
    {State, LastTime, Exp, Reward}.

update(Player, SumExp) ->
    MoreExp = lib_dict:get(?PROC_STATUS_MORE_EXP),
    Base = data_more_exp_time:get(1),
    if
        MoreExp#more_exp.state /= 2 -> skip;
        Player#player.lv < Base#base_more_exp_time.lv ->skip;
        true ->
            Exp = daily:increment(?DAILY_MORE_EXP, SumExp),
            Reward = MoreExp#more_exp.reward,
            LastTime = MoreExp#more_exp.end_time - util:unixtime(),
            if
                Reward > 1 ->
                    {ok, Bin} = pt_432:write(43268, {MoreExp#more_exp.state, LastTime, Exp, Reward}),
                    server_send:send_to_sid(Player#player.sid, Bin);
                true -> skip
            end
    end,
    ok.

get_reward(Lv) ->
    MoreExp = lib_dict:get(?PROC_STATUS_MORE_EXP),
    Limit = data_more_exp_time:get(1),
    if
        Lv < Limit#base_more_exp_time.lv -> 1;
        MoreExp#more_exp.state == 2 -> MoreExp#more_exp.reward;
        true -> 1
    end.