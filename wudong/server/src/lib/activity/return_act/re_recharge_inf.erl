%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 十二月 2017 14:20
%%%-------------------------------------------------------------------
-module(re_recharge_inf).
-author("Administrator").
-include("daily.hrl").
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").
%% API
-export([
    add_recharge/2
    , get_info/1
    , get_reward/1
    , get_state/1
]).

add_recharge(_Player, Val) ->
    daily:increment(?DAILY_RE_RECHARGE_INF_ALL_VAL, Val),
    ok.

get_info(_Player) ->
    case get_act() of
        [] -> {0, 0, 0, 0, []};
        Base ->
            DailyVal = daily:get_count(?DAILY_RE_RECHARGE_INF_ALL_VAL),
            Count = daily:get_count(?DAILY_RE_RECHARGE_INF_COUNT),
            LeaveTime = get_leave_time(),
            Reward0 = get_reward_info(),
            Reward = [tuple_to_list(X) || X <- Reward0],
            {LeaveTime, DailyVal, Base#base_re_recharge_inf.val, Base#base_re_recharge_inf.val * (Count + 1), Reward}
    end.

get_reward(Player) ->
    case check_get_reward(Player) of
        {false, Res} -> {Res, Player};
        ok ->
            Reward0 = get_reward_info(),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(302, Reward0)),
            daily:increment(?DAILY_RE_RECHARGE_INF_COUNT, 1),
            log_re_recharge_inf(Player#player.key, Player#player.nickname, Reward0),
%%             festival_state:send_all(Player),
            {1, NewPlayer}
    end.

check_get_reward(_Player) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            BaseVal = Base#base_re_recharge_inf.val,
            DailyVal = daily:get_count(?DAILY_RE_RECHARGE_INF_ALL_VAL),
            Count = daily:get_count(?DAILY_RE_RECHARGE_INF_COUNT),
            AllCount = DailyVal div BaseVal,
            if AllCount > Count andalso AllCount =/= 0 -> ok;
                true -> {false, 9}
            end
    end.

get_reward_info() ->
    Count = daily:get_count(?DAILY_RE_RECHARGE_INF_COUNT) + 1,
    case get_act() of
        [] -> [];
        Base ->
            RankInfoList = Base#base_re_recharge_inf.rank_info,
            F = fun(Info, List) ->
                if Count =< Info#rank_info.down -> [Info#rank_info.reward | List];
                    true -> List
                end
            end,
            List1 = lists:foldl(F, [], RankInfoList),
            case lists:reverse(List1) of
                [] -> [];
                Other -> hd(Other)
            end
    end.

get_act() ->
    case activity:get_work_list(data_re_recharge_inf) of
        [] -> [];
        [Base | _] -> Base
    end.

get_leave_time() ->
    activity:get_leave_time(data_re_recharge_inf).

get_state(Player) ->
    case get_act() of
        [] -> -1;
        _ ->
            case check_get_reward(Player) of
                {false, _} -> 0;
                ok -> 1
            end
    end.

log_re_recharge_inf(Pkey, Nickname, GoodsList) ->
    Sql = io_lib:format("insert into log_re_recharge_inf set pkey=~p,nickname='~s',goods_list = '~s',time=~p", [Pkey, Nickname, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.
