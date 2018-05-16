%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十一月 2015 16:59
%%%-------------------------------------------------------------------
-module(arena_init).
-author("hxming").

-include("arena.hrl").
-include("common.hrl").

%% API
-compile(export_all).

init() ->
    erlang:send_after(500, self(), {load_arena}).



load_arena() ->
    case config:is_center_node() of
        true -> ok;
        false ->
            Data = arena_load:load_arena(),
            init_arena(Data)
    end.


init_arena(Data) ->
    F = fun([Pkey, Type, Realm, Career, Sex, Rank, MaxRank, Times, ResetTime, BuyTimes, Cd, Wins, Combo, Reward, Time, RankReward], AList) ->
        Arena = #arena{
            pkey = Pkey,
            type = Type,
            realm = Realm,
            career = Career,
            sex = Sex,
            rank = Rank,
            max_rank = MaxRank,
            cd = Cd,
            wins = Wins,
            combo = Combo,
            times = Times,
            reset_time = ResetTime,
            buy_times = BuyTimes,
            reward = util:bitstring_to_term(Reward),
            time = Time,
            rank_reward = util:bitstring_to_term(RankReward)
        },
        [Arena | AList]
        end,
    ArenaList = lists:foldl(F, [], Data),
    Now = util:unixtime(),
    F1 = fun(Rank, {Dict, List}) ->
        case lists:keytake(Rank, #arena.rank, List) of
            false ->
                Arena = robot(Rank, Now),
                arena_init:set_arena_new(Arena),
                NewDict = dict:store(Rank, Arena#arena.pkey, Dict),
                {NewDict, List};
            {value, Arena, L} ->
                arena_init:set_arena_new(Arena),
                NewDict = dict:store(Rank, Arena#arena.pkey, Dict),
                {NewDict, L}
        end
         end,
    {RankDict, NewArenaList} =
        lists:foldl(F1, {dict:new(), ArenaList}, lists:seq(1, ?ROBOT_NUM)),
    arena_init:set_rank(RankDict),
    F2 = fun(Arena) ->
        if Arena#arena.rank =/= 0 ->
            NewArena = Arena#arena{rank = 0},
            arena_init:set_arena(NewArena);
            true ->
                arena_init:set_arena_new(Arena)
        end
         end,
    lists:foreach(F2, NewArenaList),
    ?DEBUG("arena init ok"),
    ok.


%%增加系统玩家
init_robot() ->
    arena_load:clean_arena(),
    Now = util:unixtime(),
    F = fun(Rank, Dict) ->
        Arena = robot(Rank, Now),
        dict:store(Rank, Arena#arena.pkey, Dict)
        end,
    RankDict = lists:foldl(F, dict:new(), lists:seq(1, ?ROBOT_NUM)),
    set_rank(RankDict).

robot(Rank, Now) ->
    Pkey = misc:unique_key_auto(),

    Arena = #arena{pkey = Pkey, career = player_util:rand_career(), sex = player_util:rand_sex(), rank = Rank, time = Now, nickname = player_util:rand_name()},
    set_arena(Arena),
    Arena.

set_arena(Arena) ->
    put({arena, Arena#arena.pkey}, Arena#arena{is_change = 1}),
    update_index(Arena#arena.pkey),
    ok.

set_arena_new(Arena) ->
    put({arena, Arena#arena.pkey}, Arena).

get_arena(Pkey) ->
    case get({arena, Pkey}) of
        undefined -> false;
        Arena -> Arena
    end.

set_rank(Dict) ->
    put(arena_rank, Dict).

get_rank() ->
    get(arena_rank).

update_index(Pkey) ->
    case get(key_index) of
        undefined ->
            put(key_index, [Pkey]);
        List ->
            put(key_index, [Pkey | lists:delete(Pkey, List)])
    end.

get_index() ->
    case get(key_index) of
        undefined -> [];
        List -> List
    end.


timer_update() ->
    case get_index() of
        [] -> 1;
        IndexList ->
            erlang:erase(key_index),
            Now = util:unixtime(),
            F = fun(Key) ->
                case get_arena(Key) of
                    false -> skip;
                    Arena ->
                        if Arena#arena.type == ?ARENA_TYPE_PLAYER andalso Arena#arena.is_change == 1 ->
                            case Arena#arena.challenge /= [] andalso Now - Arena#arena.refresh_cd > 180 of
                                true ->
                                    set_arena_new(Arena#arena{challenge = [], is_change = 0});
                                false ->
                                    set_arena_new(Arena#arena{is_change = 0})
                            end,
                            spawn(fun() -> arena_load:replace_arena(Arena) end);
                            true -> ok
                        end
                end
                end,
            lists:foreach(F, IndexList)
    end.

close_update() ->
    F = fun({Key, Val}) ->
        case Key of
            {arena, _Pkey} ->
                if Val#arena.type == ?ARENA_TYPE_PLAYER andalso Val#arena.is_change == 1 ->
                    arena_load:replace_arena(Val);
                    true -> skip
                end;
            _ -> ok
        end
        end,
    lists:foreach(F, get()),
    ok.
