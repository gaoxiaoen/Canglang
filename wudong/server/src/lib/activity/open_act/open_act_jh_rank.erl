%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 江湖榜
%%% @end
%%% Created : 24. 二月 2017 20:19
%%%-------------------------------------------------------------------
-module(open_act_jh_rank).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("dungeon.hrl").
-include("arena.hrl").
-include("cross_arena.hrl").
-include("tips.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act_info/1,
    recv/3,
    get_state/1,
    get_act/0,
    get_sub_act_type/0
]).

init(#player{key = Pkey} = Player) ->
    StOpenActJhRank =
        case player_util:is_new_role(Player) of
            true -> #st_open_act_jh_rank{pkey = Pkey};
            false -> activity_load:dbget_open_act_jh_rank(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_OPEN_ACT_JH_RANK, StOpenActJhRank),
    update_open_act_jh_rank(),
    Player.

update_open_act_jh_rank() ->
    StOpenActJhRank = lib_dict:get(?PROC_STATUS_OPEN_ACT_JH_RANK),
    #st_open_act_jh_rank{
        pkey = Pkey,
        act_id = ActId
    } = StOpenActJhRank,
    case get_act() of
        [] ->
            NewStOpenActJhRank = #st_open_act_jh_rank{pkey = Pkey};
        #base_open_jh_rank{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStOpenActJhRank = #st_open_act_jh_rank{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStOpenActJhRank = StOpenActJhRank
            end
    end,
    lib_dict:put(?PROC_STATUS_OPEN_ACT_JH_RANK, NewStOpenActJhRank).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_open_act_jh_rank().

get_act_info(Player) ->
    update_open_act_jh_rank(),
    StOpenActJhRank = lib_dict:get(?PROC_STATUS_OPEN_ACT_JH_RANK),
    #st_open_act_jh_rank{
        recv_list = RecvList
    } = StOpenActJhRank,
    case get_act() of
        [] ->
            {0, []};
        #base_open_jh_rank{
            list = BaseList,
            open_info = OpenInfo
        } ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            F = fun({ActType, Args, GiftId}) ->
                case lists:member({ActType, Args}, RecvList) of
                    false ->
                        Status = get_status(Player, ActType, Args),
                        [ActType, Args, GiftId, Status];
                    _ ->
                        [ActType, Args, GiftId, 2]
                end
            end,
            List = lists:map(F, BaseList),
            {LTime, List}
    end.

get_status(Player, ?OPEN_JH_RANK_LV, Args) ->
    ?IF_ELSE(Player#player.lv >= Args, 1, 0);

get_status(_Player, ?OPEN_JH_RANK_TOWER, Args) ->
    St = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    ?IF_ELSE(length(St#st_dun_fuwen_tower.dun_list) >= Args, 1, 0);

get_status(_Player, ?OPEN_JH_RANK_DAILY_THREE, Args) ->
    St = lib_dict:get(?PROC_STATUS_DUN_DAILY),
    F = fun(DunId) ->
        case data_dungeon:get(DunId) of
            [] ->
                [];
            _Base ->
                case lists:member(DunId, St#st_dun_daily.dun_list) of
                    true -> [DunId];
                    false -> []
                end
        end
    end,
    L = lists:flatmap(F, data_dungeon_daily:get(?TIPS_DUNGEON_TYPE_DAILY_THREE)),
    ?IF_ELSE(length(L) >= Args, 1, 0);

get_status(_Player, ?OPEN_JH_RANK_EXP_DUNGEON, Args) ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    ?IF_ELSE(St#st_dun_exp.round_highest >= Args, 1, 0);

get_status(Player, ?OPEN_JH_RANK_ARENA, Args) ->
    Now = util:unixtime(),
    case get(open_jh_rank_arena_data) of
        {Time, AreRank0} ->
            Rand = util:rand(1,1),
            if
                Now - Time > 1 + Rand -> %% 做数据缓存
                    ArenaRank =
                        case ?CALL_TIME_OUT(arena_proc:get_server_pid(), {get_arena_rank, [Player#player.key]}, 1000) of
                            [{_Key, Rank, _RankMax}] when is_integer(Rank) ->
                                ?IF_ELSE(Rank == 0, 99999, Rank);
                            _ ->
                                99999
                        end,
                    put(open_jh_rank_arena_data, {Now, ArenaRank});
                true ->
                    ArenaRank = AreRank0
            end;
        _ ->
            ArenaRank =
                case ?CALL_TIME_OUT(arena_proc:get_server_pid(), {get_arena_rank, [Player#player.key]}, 1000) of
                    [{_Key, Rank, _RankMax}] when is_integer(Rank) ->
                        ?IF_ELSE(Rank == 0, 99999, Rank);
                    _ ->
                        999999
                end,
            put(open_jh_rank_arena_data, {Now, ArenaRank})
    end,
%%     ?DEBUG("ArenaRank:~p~n", [ArenaRank]),
    if
        Player#player.lv < 30 -> NewArenaRank = 99999;
        true -> NewArenaRank = ArenaRank
    end,
    ?IF_ELSE(NewArenaRank =< Args, 1, 0);

get_status(Player, ?OPEN_JH_RANK_KF_ARENA, Args) ->
    Now = util:unixtime(),
    case get(open_jh_rank_kf_arena_data) of
        {Time, CroAreRank0} ->
            Rand = util:rand(1,1),
            if
                Now - Time > 1 + Rand -> %% 做数据缓存
                    CrossArenaRank =
%%                         case ?CALL_TIME_OUT(cross_arena_proc:get_server_pid(), {get_arena_info, Player#player.key}, 2000) of
                        case cross_area:apply_call(cross_arena, get_arena_info, [Player#player.key]) of
                            #cross_arena{rank = Rank0} ->
                                ?IF_ELSE(Rank0 == 0, 99999, Rank0);
                            _Other ->
                                99999
                        end,
                    put(open_jh_rank_kf_arena_data, {Now, CrossArenaRank});
                true ->
                    CrossArenaRank = CroAreRank0
            end;
        _ ->
            CrossArenaRank =
                case ?CALL_TIME_OUT(cross_arena_proc:get_server_pid(), {get_arena_info, Player#player.key}, 2000) of
                    #cross_arena{rank = Rank0} ->
                        ?IF_ELSE(Rank0 == 0, 99999, Rank0);
                    _ ->
                        99999
                end,
            put(open_jh_rank_kf_arena_data, {Now, CrossArenaRank})
    end,
%%     ?DEBUG("CrossArenaRank:~p~n", [CrossArenaRank]),
    ?IF_ELSE(CrossArenaRank =< Args, 1, 0);

get_status(Player, ?OPEN_JH_RANK_COMBAT_TARGET, Args) ->
    ?IF_ELSE(Player#player.cbp >= Args, 1, 0);

get_status(_Player, ?OPEN_JH_RANK_GUARD, Args) ->
    DungeonGuard = lib_dict:get(?PROC_STATUS_DUN_GUARD),
    MaxRound = DungeonGuard#st_dun_guard.round_max,
    ?IF_ELSE(MaxRound >= Args, 1, 0);

get_status(_Player, _ActType, _Args) ->
    0.

recv(Player, ActType, Args) ->
    StOpenActJhRank = lib_dict:get(?PROC_STATUS_OPEN_ACT_JH_RANK),
    #st_open_act_jh_rank{
        recv_list = RecvList
    } = StOpenActJhRank,
    case get_act() of
        [] ->
            {4, Player}; %% 活动未开启
        #base_open_jh_rank{list = BaseList} ->
            IsRecv = lists:member({ActType, Args}, RecvList),
            Status = get_status(Player, ActType, Args),
            if
                IsRecv == true ->
                    {3, Player}; %% 已经领取
                Status == 0 ->
                    {2, Player}; %% 未达条件,还不能领取
                true ->
                    F = fun({ActType0, Args0, _GidtId0}) ->
                        ActType0 == ActType andalso Args0 == Args
                    end,
                    case lists:filter(F, BaseList) of
                        [] ->
                            {0, Player}; %% 配置参数错误
                        [{_ActType, _Args, GiftId}|_] ->
                            GiveGoodsList = goods:make_give_goods_list(605,[{GiftId,1}]),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            NewStOpenActJhRank = StOpenActJhRank#st_open_act_jh_rank{recv_list = [{ActType, Args}|RecvList]},
                            lib_dict:put(?PROC_STATUS_OPEN_ACT_JH_RANK, NewStOpenActJhRank),
                            activity_load:dbup_open_act_jh_rank(NewStOpenActJhRank),
                            activity:get_notice(Player, [33], true),
                            {1, NewPlayer}
                    end
            end
    end.

get_state(Player) ->
    case get_act() of
        [] ->
            -1; %% 活动未开启
        #base_open_jh_rank{list = BaseList} ->
            StOpenActJhRank = lib_dict:get(?PROC_STATUS_OPEN_ACT_JH_RANK),
            #st_open_act_jh_rank{
                recv_list = RecvList
            } = StOpenActJhRank,
            F0 = fun({ActType, Args, GiftId}) ->
                case lists:member({ActType, Args}, RecvList) of
                    false ->
                        Status = get_status(Player, ActType, Args),
                        [ActType, Args, GiftId, Status];
                    _ ->
                        [ActType, Args, GiftId, 2]
                end
            end,
            List = lists:map(F0, BaseList),
            F = fun([_ActType, _Args, _GiftId, Status]) ->
                Status == 1
            end,
            L = lists:filter(F, List),
            ?IF_ELSE(L == [], 0, 1)
    end.

get_act() ->
    case activity:get_work_list(data_open_jh_rank) of
        [] -> [];
        [Base | _] -> Base
    end.

get_sub_act_type() ->
    case get_act() of
        [] ->
            0;
        #base_open_jh_rank{list = BaseList} ->
            {ActType, _, _} = hd(BaseList),
            ActType
    end.