%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 六月 2016 10:46
%%%-------------------------------------------------------------------
-module(cross_arena_init).
-author("hxming").

-include("cross_arena.hrl").
-include("common.hrl").
-include("server.hrl").
-include("tips.hrl").
%% API
-compile(export_all).

init(Player) ->
    Now = util:unixtime(),
    Mb =
        case player_util:is_new_role(Player) of
            true ->
                #cross_arena_mb{pkey = Player#player.key, times = ?CROSS_ARENA_TIMES, reset_time = Now, time = Now, is_change = 1};
            false ->
                case cross_arena_load:load_arena_mb(Player#player.key) of
                    [] ->
                        #cross_arena_mb{pkey = Player#player.key, times = ?CROSS_ARENA_TIMES, reset_time = Now, time = Now, is_change = 1};
                    [Times, ResetTime, BuyTimes, InCd, Cd, Time, Score, ScoreReward] ->
                        case util:is_same_date(Now, Time) of
                            true ->
                                #cross_arena_mb{pkey = Player#player.key, times = Times, reset_time = ResetTime, buy_times = BuyTimes, in_cd = InCd, cd = Cd, time = Time, score = Score, score_reward = util:bitstring_to_term(ScoreReward)};
                            false ->
                                #cross_arena_mb{pkey = Player#player.key, times = ?CROSS_ARENA_TIMES, reset_time = ResetTime, buy_times = 0, in_cd = InCd, cd = Cd, time = Now, is_change = 1}
                        end
                end
        end,
    lib_dict:put(?PROC_STATUS_CROSS_ARENA, Mb),
    Player.


init_arena_shadow(Pkey) ->
    case cross_arena_load:select_shadow(Pkey) of
        [] -> false;
        [Nickname, Career, Sex, Lv, Cbp, Shadow] ->
            shadow_init:to_player(Pkey, Nickname, 0, Career, Sex, Lv, Cbp, Cbp, Shadow)
    end.

timer_update() ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    if Mb#cross_arena_mb.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_CROSS_ARENA, Mb#cross_arena_mb{is_change = 0}),
        cross_arena_load:replace_arena_mb(Mb);
        true ->
            lib_dict:put(?PROC_STATUS_CROSS_ARENA, Mb)
    end.

logout() ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    if Mb#cross_arena_mb.is_change /= 0 ->
        cross_arena_load:replace_arena_mb(Mb);
        true -> skip
    end.

refresh_midnight(Now) ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    NewMb = Mb#cross_arena_mb{times = ?CROSS_ARENA_TIMES, score = 0, score_reward = [], buy_times = 0, time = Now, is_change = 1},
    lib_dict:put(?PROC_STATUS_CROSS_ARENA, NewMb).

update_arena_times() ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    Now = util:unixtime(),
    {Cd, InCd} = arena:update_cd(Mb#cross_arena_mb.cd, Now),
    NewMb = Mb#cross_arena_mb{times = max(0, Mb#cross_arena_mb.times - 1), cd = Cd, in_cd = InCd, is_change = 1},
    lib_dict:put(?PROC_STATUS_CROSS_ARENA, NewMb).

check_cross_arena_state() ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    ?IF_ELSE(Mb#cross_arena_mb.times >= ?CROSS_ARENA_TIMES, 1, 0).




load_cross_arena() ->
    Data = cross_arena_load:load_cross_arena(),
    init_cross_arena(Data).

init_cross_arena(Data) ->
    F = fun([Pkey, Nickname, Career, Sex, Lv, Cbp, Rank, Shadow, Time, VsTimes], Dict) ->
        Arena = #cross_arena{
            pkey = Pkey,
            nickname = Nickname,
            career = Career,
            sex = Sex,
            lv = Lv,
            cbp = Cbp,
            rank = Rank,
            shadow = shadow_init:to_player(Pkey, Nickname, 0, Career, Sex, Lv, Cbp, Cbp, Shadow),
            time = Time,
            vs = VsTimes
        },
        set_cross_arena(Arena),
        dict:store(Rank, Pkey, Dict)
        end,
    RankDict = lists:foldl(F, dict:new(), Data),
    set_cross_rank(RankDict),
    ?DEBUG("init cross arena ok"),
    ok.


set_cross_arena(Arena) ->
    put({cross_arena, Arena#cross_arena.pkey}, Arena).

get_cross_arena(Pkey) ->
    case get({cross_arena, Pkey}) of
        undefined -> false;
        Arena -> Arena
    end.

set_cross_rank(Dict) ->
    put(cross_arena_rank, Dict).

get_cross_rank() ->
    case get(cross_arena_rank) of
        undefined -> dict:new();
        Val -> Val
    end.

