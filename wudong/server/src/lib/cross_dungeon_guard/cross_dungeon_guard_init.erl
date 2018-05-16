%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 十一月 2016 17:42
%%%-------------------------------------------------------------------
-module(cross_dungeon_guard_init).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("cross_dungeon_guard.hrl").

%% API
-export([init/1, logout/0, timer_update/0, midnight_refresh/2, get_dungeon_times/0, update_dungeon_times/5]).

%%登陆初始化
init(Player) ->
    Now = util:unixtime(),
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, #st_cross_dun_guard{pkey = Player#player.key, time = Now, lv = Player#player.lv});
        false ->
            case load(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, #st_cross_dun_guard{pkey = Player#player.key, time = Now, lv = Player#player.lv});
                [DunList, Times, Time, Lv, MilestoneList] ->
                    case util:is_same_date(Now, Time) of
                        true ->
                            lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, #st_cross_dun_guard{pkey = Player#player.key, dun_list = util:bitstring_to_term(DunList), lv = Lv, times = Times, time = Time, milestone_list = util:bitstring_to_term(MilestoneList)});
                        false ->
                            F = fun({DunId, _Times, Floor1, Time1, State, CountList}) ->
                                {DunId, 0, Floor1, Time1, State, CountList}
                            end,
                            NewDunList = lists:map(F, util:bitstring_to_term(DunList)),
                            lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, #st_cross_dun_guard{pkey = Player#player.key, dun_list = NewDunList, time = Now, is_change = 1, lv = Player#player.lv, milestone_list = util:bitstring_to_term(MilestoneList)})
                    end
            end
    end,
    Player.

%%离线
logout() ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    if St#st_cross_dun_guard.is_change == 1 ->
        replace(St);
        true -> ok
    end.

%%定时更新
timer_update() ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    if St#st_cross_dun_guard.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, St#st_cross_dun_guard{is_change = 0}),
        replace(St);
        true -> ok
    end.

%%零点
midnight_refresh(Lv, Now) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    F = fun({DunId, _Times, Floor1, Time1, State, CountList}) ->
        {DunId, 0, Floor1, Time1, State, CountList}
    end,
    NewDunList = lists:map(F, St#st_cross_dun_guard.dun_list),
    ?DEBUG("St#st_cross_dun_guard.dun_list ~p~n", [St#st_cross_dun_guard.dun_list]),
    ?DEBUG("NewDunList ~p~n", [NewDunList]),
    lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, St#st_cross_dun_guard{time = Now, times = 0, dun_list = NewDunList, lv = Lv}).
%%     if St#st_cross_dun_guard.is_change == 1 ->
%%         lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, St#st_cross_dun_guard{time = Now, times = 0, is_change = 0});
%%         true -> ok
%%     end.


%%获取今日副本挑战次数
get_dungeon_times() ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    St#st_cross_dun_guard.times.

%%更新副本挑战次数
update_dungeon_times(St, DunId, Floor, Time, 1) ->
    {DunList, Times1, IsNew, MaxFloor, Reward0} =
        case lists:keytake(DunId, 1, St#st_cross_dun_guard.dun_list) of
            false ->
                Reward = data_dungeon_cross_guard_count:get(St#st_cross_dun_guard.lv, 1),
                State = ?IF_ELSE(Reward == [], 0, 1),
                {[{DunId, 1, Floor, Time, State, []} | St#st_cross_dun_guard.dun_list], 1, 1, Floor, Reward};
            {value, {_, Times, Floor0, Time0, State, CountList}, T} ->
                {Floor1, IsNew0, MaxFloor0} = ?IF_ELSE(Floor0 > Floor, {Floor0, 0, Floor0}, {Floor, 1, Floor}),
                Time1 = ?IF_ELSE(Time0 >= Time, Time0, Time),
                Reward = data_dungeon_cross_guard_count:get(St#st_cross_dun_guard.lv, St#st_cross_dun_guard.times + 1),
                State0 = ?IF_ELSE(Reward == [], 0, 1),
                {[{DunId, Times, Floor1, Time1, max(State0, State), CountList} | T], Times, IsNew0, MaxFloor0, Reward}
        end,
    ?DEBUG("Reward0 ~p~n", [Reward0]),
    NewSt = St#st_cross_dun_guard{dun_list = DunList, times = St#st_cross_dun_guard.times + 1, is_change = 1},
    lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, NewSt),
    {NewSt, Times1, IsNew, MaxFloor, Reward0};

%%更新副本挑战次数
update_dungeon_times(St, DunId, Floor, Time, 0) ->
    {DunList, Times1, IsNew, MaxFloor, Reward0} =
        case lists:keytake(DunId, 1, St#st_cross_dun_guard.dun_list) of
            false ->
                {[{DunId, 1, Floor, Time, 0, []} | St#st_cross_dun_guard.dun_list], 1, 1, Floor, []};
            {value, {_, Times, Floor0, Time0, State, CountList}, T} ->
                {Floor1, IsNew0, MaxFloor0} = ?IF_ELSE(Floor0 > Floor, {Floor0, 0, Floor0}, {Floor, 1, Floor}),
                Time1 = ?IF_ELSE(Time0 >= Time, Time0, Time),
                {[{DunId, Times, Floor1, Time1, State, CountList} | T], Times, IsNew0, MaxFloor0, []}
        end,
    NewSt = St#st_cross_dun_guard{dun_list = DunList, times = St#st_cross_dun_guard.times, is_change = 1},
    lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, NewSt),
    {NewSt, Times1, IsNew, MaxFloor, Reward0}.

load(Pkey) ->
    Sql = io_lib:format("select dun_list,times,time,lv,milestone_list from player_dun_cross_guard where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace(CrossDun) ->
    Sql = io_lib:format("replace into player_dun_cross_guard set pkey=~p, dun_list='~s',times=~p,time=~p,milestone_list='~s',lv = ~p",
        [CrossDun#st_cross_dun_guard.pkey, util:term_to_bitstring(CrossDun#st_cross_dun_guard.dun_list), CrossDun#st_cross_dun_guard.times, CrossDun#st_cross_dun_guard.time, util:term_to_bitstring(CrossDun#st_cross_dun_guard.milestone_list), CrossDun#st_cross_dun_guard.lv]),
    db:execute(Sql),
    ok.
