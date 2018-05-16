%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 在线有礼
%%% @end
%%% Created : 22. 九月 2017 16:54
%%%-------------------------------------------------------------------
-module(online_reward).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    get_info/1,
    get_reward/1,
    midnight_refresh/1,
    logout/1,
    update_online_time/1,
    update/0,
    get_state/1
]).

init(#player{key = Pkey} = Player) ->
    StOnlineReward =
        case player_util:is_new_role(Player) of
            true -> #st_online_reward{pkey = Pkey};
            false ->
                activity_load:dbget_online_reward(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_ONLINE_REWARD, StOnlineReward),
    update(),
    Player.

get_info(Player) ->
    update_online_time(Player),
    case get_act() of
        [] -> {0, 0, 0, []};
        Base ->
            LeaveTime = get_leave_time(),
            Base#base_online_reward.time_list,
            StOnlineReward = lib_dict:get(?PROC_STATUS_ONLINE_REWARD),
            #st_online_reward{
                use_count = UseCount
                , online_time = OnlineTime
                , reward = Reward
            } = StOnlineReward,
            TimeList = [X || X <- Base#base_online_reward.time_list, X * 60 =< OnlineTime],
            Count = max(0, length(TimeList) - UseCount),
            NextTimeList = [X || X <- Base#base_online_reward.time_list, X * 60 > OnlineTime],
            NextTime0 = ?IF_ELSE(NextTimeList == [], 0, hd(NextTimeList)),
            NextTime = max(0, NextTime0 * 60 - OnlineTime),
            F = fun({Id, GoodsId, GoodsNum, _Ratio}) ->
                case lists:member(Id, Reward) of
                    true -> [Id, 1, GoodsId, GoodsNum];
                    false ->
                        [Id, 0, GoodsId, GoodsNum]
                end
            end,
            Rreward = lists:map(F, Base#base_online_reward.reward),
            {LeaveTime, Count, NextTime, Rreward}
    end.

get_reward(Player) ->
    update_online_time(Player),
    case check_get_reward(Player) of
        {false, Res} -> {false, Res};
        ok ->
            draw(Player)
    end.

draw(Player) ->
    Base = get_act(),
    StOnlineReward = lib_dict:get(?PROC_STATUS_ONLINE_REWARD),
    Reward = StOnlineReward#st_online_reward.reward,
    F = fun({Id0, GoodsId0, GoodsNum0, Ratio}, List) ->
        case lists:member(Id0, Reward) of
            true -> List;
            false ->
                [{{Id0, GoodsId0, GoodsNum0}, Ratio} | List]
        end
    end,
    Rewards = lists:foldl(F, [], Base#base_online_reward.reward),
    {Id, GoodsId, GoodsNum} = util:list_rand_ratio(Rewards),
    NewSt = StOnlineReward#st_online_reward{
        use_count = StOnlineReward#st_online_reward.use_count + 1,
        reward = [Id | StOnlineReward#st_online_reward.reward]
    },
    lib_dict:put(?PROC_STATUS_ONLINE_REWARD, NewSt),
    activity_load:dbup_online_reward(NewSt),
    log_online_reward(Player#player.key, Player#player.nickname, [{GoodsId, GoodsNum}]),
    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(303, [{GoodsId, GoodsNum}])),
    festival_state:send_all(NewPlayer),
    {ok, NewPlayer, Id}.


check_get_reward(_Player) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            StOnlineReward = lib_dict:get(?PROC_STATUS_ONLINE_REWARD),
            #st_online_reward{
                use_count = UseCount
                , online_time = OnlineTime
            } = StOnlineReward,
            TimeList = [X || X <- Base#base_online_reward.time_list, X * 60 =< OnlineTime],
            Count = length(TimeList) - UseCount,
            if
                Count > 0 -> ok;
                true -> {false, 9}
            end
    end.

update_online_time(Player) ->
    if
        Player#player.lv < 1 ->
            StBuyCoin = lib_dict:get(?PROC_STATUS_ONLINE_REWARD),
            Now = util:unixtime(),
            NewStBuyCoin = StBuyCoin#st_online_reward{online_time = 0, last_login_time = Now},
            lib_dict:put(?PROC_STATUS_ONLINE_REWARD, NewStBuyCoin);
%%             activity:get_notice(Player, [132], true);
        true ->
            Now = util:unixtime(),
            StBuyCoin = lib_dict:get(?PROC_STATUS_ONLINE_REWARD),
            Flag = util:is_same_date(Now, StBuyCoin#st_online_reward.last_login_time),
            #st_online_reward{
                online_time = OnlineTime,
                last_login_time = LastLoginTime
            } = StBuyCoin,
            if
                Flag == true ->
                    NewOnlineTime = OnlineTime + (Now - LastLoginTime),
                    NewSt = StBuyCoin#st_online_reward{pkey = Player#player.key, last_login_time = Now, online_time = NewOnlineTime};
                true ->
                    NewSt = #st_online_reward{pkey = Player#player.key, last_login_time = Now}
            end,
            NewStBuyCoin = NewSt,
            lib_dict:put(?PROC_STATUS_ONLINE_REWARD, NewStBuyCoin)
%%             activity:get_notice(Player, [132], true)
    end.

update() ->
    StOnlineReward = lib_dict:get(?PROC_STATUS_ONLINE_REWARD),
    #st_online_reward{
        pkey = Pkey,
        last_login_time = LastLoginTime
    } = StOnlineReward,
    Now = util:unixtime(),
    Flag = util:is_same_date(Now, LastLoginTime),
    if
        Flag == false ->
            NewStOnlineReward = #st_online_reward{pkey = Pkey, last_login_time = Now};
        true ->
            NewStOnlineReward = StOnlineReward#st_online_reward{last_login_time = Now}
    end,
    lib_dict:put(?PROC_STATUS_ONLINE_REWARD, NewStOnlineReward).


get_act() ->
    case activity:get_work_list(data_online_reward) of
        [] -> [];
        [Base | _] -> Base
    end.

get_leave_time() ->
    LeaveTime = activity:get_leave_time(data_online_reward),
    ?IF_ELSE(LeaveTime < 0, 0, LeaveTime).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update().

logout(Player) ->
    update_online_time(Player),
    St = lib_dict:get(?PROC_STATUS_ONLINE_REWARD),
    activity_load:dbup_online_reward(St).

get_state(Player) ->
    case get_act() of
        [] -> -1;
        _ ->
            case check_get_reward(Player) of
                {false, _} -> 0;
                ok -> 1
            end
    end.

log_online_reward(Pkey, Nickname, GoodsList) ->
    Sql = io_lib:format("insert into log_online_reward set pkey=~p,nickname='~s',goods_list = '~s',time=~p", [Pkey, Nickname, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.
