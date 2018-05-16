%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 六月 2016 14:46
%%%-------------------------------------------------------------------
-module(cross_eliminate_init).
-author("hxming").

-include("scene.hrl").
-include("common.hrl").
-include("cross_eliminate.hrl").
%% API
-compile(export_all).


init(Player) ->
    Now = util:unixtime(),
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_ELIMINATE, #player_eliminate{pkey = Player#player.key, time = Now});
        false ->
            PlayerEliminate = init_data(Player#player.key, Now),
            lib_dict:put(?PROC_STATUS_ELIMINATE, PlayerEliminate)
    end,
    Player.

init_data(Pkey, Now) ->
    case cross_eliminate_load:load_player_eliminate(Pkey) of
        [] ->
            #player_eliminate{pkey = Pkey, time = Now};
        [Wins, WinningStreak, LosingStreak, Times, Time] ->
            case util:is_same_date(Time, Now) of
                true ->
                    #player_eliminate{pkey = Pkey, wins = Wins, winning_streak = WinningStreak, losing_streak = LosingStreak, times = Times, time = Time};
                false ->
                    #player_eliminate{pkey = Pkey, wins = Wins, winning_streak = WinningStreak, losing_streak = LosingStreak, times = 0, time = Now, is_change = 1}
            end
    end.

logout() ->
    PlayerEliminate = lib_dict:get(?PROC_STATUS_ELIMINATE),
    if PlayerEliminate#player_eliminate.is_change == 1 ->
        cross_eliminate_load:replace_player_eliminate(PlayerEliminate);
        true -> ok
    end,
    ok.

timer_update() ->
    PlayerEliminate = lib_dict:get(?PROC_STATUS_ELIMINATE),
    if PlayerEliminate#player_eliminate.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_ELIMINATE, PlayerEliminate#player_eliminate{is_change = 0}),
        cross_eliminate_load:replace_player_eliminate(PlayerEliminate);
        true -> ok
    end,
    ok.

midnight_refresh(Now) ->
    PlayerEliminate = lib_dict:get(?PROC_STATUS_ELIMINATE),
    lib_dict:put(?PROC_STATUS_ELIMINATE, PlayerEliminate#player_eliminate{is_change = 1, time = Now, times = 0}),
    ok.



cmd_test(Type) ->
    List = default(Type),
    Val = ?IF_ELSE(Type == 1, 0, 10),
    ?DEBUG(" ~p~n", [List]),
    ?DEBUG("~p/~p/~p", [M#eliminate_mon.mid || M <- List, M#eliminate_mon.id - Val =< 3]),
    ?DEBUG("~p/~p/~p", [M#eliminate_mon.mid || M <- List, M#eliminate_mon.id - Val =< 6, M#eliminate_mon.id - Val > 3]),
    ?DEBUG("~p/~p/~p", [M#eliminate_mon.mid || M <- List, M#eliminate_mon.id - Val > 6]),

    F = fun(Num) ->
        F1 = fun(M) ->
            case line(M#eliminate_mon.id) == Num of
                true -> [M#eliminate_mon.mid];
                false -> []
            end
             end,
        LineIds = lists:flatmap(F1, List),
        case length(util:list_filter_repeat(LineIds)) == 1 of
            true -> ?DEBUG("line ~p repeat", [Num]);
            false -> ok
        end,
        F2 = fun(M) ->
            case row(M#eliminate_mon.id) == Num of
                true -> [M#eliminate_mon.mid];
                false -> []
            end
             end,
        RowIds = lists:flatmap(F2, List),
        case length(util:list_filter_repeat(RowIds)) == 1 of
            true -> ?DEBUG("row ~p repeat", [Num]);
            false -> ok
        end

        end,
    lists:foreach(F, [1, 2, 3]),

    ok.

%%默认九宫怪物列表
%%TIPS 同一行或者同一列不能出现三色相同
default(Group) ->
    MonIdList = get_mid_by_type(1),
    F = fun(Id, L) ->
        Line = line(Id),
        Row = row(Id),
        %%获取同行可随机的id
        LineFilter = filter_line_mon(L, Line, MonIdList),
        RowFilter = filter_row_mon(L, Row, MonIdList),
        MonRatioList = [{Mid, data_cross_eliminate:get_ratio(Mid)} || Mid <- util:list_the_same_path(LineFilter, RowFilter)],
        Mid = util:list_rand_ratio(MonRatioList),
        BuffId = cross_eliminate_init:random_mon_buff(Mid),
        %%@创建怪物[MonId, Scene, X, Y, Copy, BroadCast, Args]
        {X, Y} = data_cross_eliminate_pos:get(Id),
        {MKey, Pid} = mon_agent:create_mon([Mid, ?SCENE_ID_CROSS_ELIMINATE, X, Y, self(), 1, [{return_id_pid, true}, {eliminate_group, Group}]]),
        MonType = data_cross_eliminate:get_type(Mid),
        Score = data_cross_eliminate:get_score(Mid),
        EliScore = data_cross_eliminate:get_eli_score(Mid),
        [#eliminate_mon{id = Id, x = X, y = Y, type = MonType, mid = Mid, key = MKey, pid = Pid, buff = BuffId, group = Group, score = Score, eli_score = EliScore} | L]
        end,
    lists:foldl(F, [], ?IF_ELSE(Group == 1, lists:seq(1, 9), lists:seq(11, 19))).

group(Id) ->
    ?IF_ELSE(Id < 10, 1, 2).

%%同一行或同一列同色过滤
filter_line_mon(MonList, Line, MonIdList) ->
    F = fun(M, L) ->
        case line(M#eliminate_mon.id) == Line of
            false -> L;
            true ->
                case lists:keytake(M#eliminate_mon.mid, 1, L) of
                    false -> [{M#eliminate_mon.mid, 1} | L];
                    {value, {_, Count}, T} ->
                        [{M#eliminate_mon.mid, Count + 1} | T]
                end
        end
        end,
    CountList = lists:foldl(F, [], MonList),
    F1 = fun(Mid) ->
        case lists:keytake(Mid, 1, CountList) of
            {value, {_, Count}, _T} when Count >= 2 -> [];
            _false -> [Mid]
        end
         end,
    lists:flatmap(F1, MonIdList).

filter_row_mon(MonList, Row, MonIdList) ->
    F = fun(M, L) ->
        case row(M#eliminate_mon.id) == Row of
            false -> L;
            true ->
                case lists:keytake(M#eliminate_mon.mid, 1, L) of
                    false -> [{M#eliminate_mon.mid, 1} | L];
                    {value, {_, Count}, T} ->
                        [{M#eliminate_mon.mid, Count + 1} | T]
                end
        end
        end,
    CountList = lists:foldl(F, [], MonList),
    F1 = fun(Mid) ->
        case lists:keytake(Mid, 1, CountList) of
            {value, {_, Count}, _T} when Count >= 2 -> [];
            _false -> [Mid]
        end
         end,
    lists:flatmap(F1, MonIdList).

%%获取行号
line(Id) when Id > 10 ->
    util:ceil((Id - 10) / 3);
line(Id) ->
    util:ceil(Id / 3).

%%获取列号
row(Id) when Id > 10 ->
    case (Id - 10) rem 3 of
        0 -> 3;
        Row -> Row
    end;
row(Id) ->
    case Id rem 3 of
        0 -> 3;
        Row -> Row
    end.


%%根据类型获取怪物
get_mid_by_type(Type) ->
    F = fun(Mid) ->
        ?IF_ELSE(data_cross_eliminate:get_type(Mid) == Type, [Mid], [])
        end,
    lists:flatmap(F, data_cross_eliminate:ids()).

%%随机一个怪
random_mon_single(FilterIds) ->
    RatioList = [{Mid, data_cross_eliminate:get_ratio(Mid)} || Mid <- data_cross_eliminate:ids(), lists:member(Mid, FilterIds) == false],
    util:list_rand_ratio(RatioList).

%%随机怪物buff
random_mon_buff(Mid) ->
    case data_cross_eliminate:get_buff(Mid) of
        [] -> 0;
        BuffList ->
            util:list_rand_ratio(BuffList)
    end.