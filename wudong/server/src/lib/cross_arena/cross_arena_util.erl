%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 一月 2017 11:44
%%%-------------------------------------------------------------------
-module(cross_arena_util).
-author("hxming").
-include("cross_arena.hrl").
-include("server.hrl").
-include("common.hrl").
%% API
-compile(export_all).



arena_list(Arena, RankDict, _Now) ->
    case check_challenge(Arena#cross_arena.challenge) of
        false ->
            pack_challenge(Arena#cross_arena.challenge);
        true ->
            ChallengeList = challenge_list(Arena, RankDict),
            cross_arena_init:set_cross_arena(Arena#cross_arena{challenge = ChallengeList}),
            pack_challenge(ChallengeList)
    end.

check_challenge(ChallengeList) ->
    case ChallengeList of
        [] -> true;
        _ ->
            F = fun(Challenge) ->
                case cross_arena_init:get_cross_arena(Challenge#cross_challenge.pkey) of
                    false -> true;
                    Arena ->
                        Arena#cross_arena.rank =/= Challenge#cross_challenge.rank
                end
                end,
            lists:any(F, ChallengeList)
    end.

arena_career(Rank) ->
    case Rank rem 2 of
        0 -> 2;
        Val -> Val
    end.

challenge_list(Arena, RankDict) ->
    Rank = ?IF_ELSE(Arena#cross_arena.rank == 0, ?CROSS_ARENA_RANK_MAX, Arena#cross_arena.rank),
    Ids = rank_ids(Rank, dict:size(RankDict)),
    F = fun(RankId) ->
        case dict:is_key(RankId, RankDict) of
            false -> [];
            true ->
                Key = dict:fetch(RankId, RankDict),
                if Key == Arena#cross_arena.pkey -> [];
                    true ->
                        case cross_arena_init:get_cross_arena(Key) of
                            false -> [];
                            Are ->
                                [init_challenge(Are#cross_arena.shadow, RankId)]
                        end
                end
        end
        end,
    lists:flatmap(F, Ids).

init_challenge(Player, RankId) ->
    #cross_challenge{
        sn = Player#player.sn,
        vip = Player#player.vip_lv,
        pkey = Player#player.key,
        nickname = Player#player.nickname,
        career = Player#player.career,
        sex = Player#player.sex,
        rank = RankId,
        cbp = Player#player.cbp,
        wind_id = Player#player.wing_id,
        weapon_id = Player#player.equip_figure#equip_figure.weapon_id,
        clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
        light_weaponid = Player#player.light_weaponid,
        fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
        footprint_id = Player#player.footprint_id,
        fashion_head_id = Player#player.fashion#fashion_figure.fashion_head_id
    }.

pack_challenge(ChallengeList) ->
    [lists:nthtail(3, tuple_to_list(Challenge)) || Challenge <- ChallengeList].

%%可挑战ID
rank_ids(Rank, MaxRank) ->
    if Rank > 0 andalso Rank =< 10 ->
        [util:list_rand(lists:delete(Rank, lists:seq(1, 3))),
            util:list_rand(lists:delete(Rank, lists:seq(4, 7))),
            util:list_rand(lists:delete(Rank, lists:seq(8, 10)))];
        Rank >= 11 andalso Rank =< 30 ->
            [util:list_rand(lists:delete(Rank, lists:seq(4, 13))),
                util:list_rand(lists:delete(Rank, lists:seq(14, 26))),
                util:list_rand(lists:delete(Rank, lists:seq(27, 40)))];
        Rank >= 31 andalso Rank =< 50 ->
            [util:list_rand(lists:delete(Rank, lists:seq(17, 29))),
                util:list_rand(lists:delete(Rank, lists:seq(30, 42))),
                util:list_rand(lists:delete(Rank, lists:seq(43, 55)))];
        true ->
            Id1 = util:list_rand(lists:delete(Rank, lists:seq(util:floor(Rank * 0.3), util:floor(Rank * 0.5)))),
            Id2 = util:list_rand(lists:delete(Rank, lists:seq(util:floor(Rank * 0.51), util:floor(Rank * 0.90)))),
            Extra = ?IF_ELSE(Rank =< MaxRank * 0.8, 1.2, 0.99),
            Id3 = util:list_rand(lists:delete(Rank, lists:seq(util:floor(Rank * 0.91), util:floor(Rank * Extra)))),
            util:list_filter_repeat([Id1, Id2, Id3])
    end.

%%%%获取前三
%%top_three(RankDict) ->
%%    F = fun(RankId) ->
%%        case dict:is_key(RankId, RankDict) of
%%            false ->
%%                [];
%%            true ->
%%                Pkey = dict:fetch(RankId, RankDict),
%%                Are = cross_arena_init:get_cross_arena(Pkey),
%%                Player = Are#cross_arena.shadow,
%%                [[Player#player.sn,
%%                    Pkey, Player#player.nickname,
%%                    Player#player.career, RankId,
%%                    Player#player.wing_id,
%%                    Player#player.equip_figure#equip_figure.weapon_id,
%%                    Player#player.equip_figure#equip_figure.clothing_id,
%%                    Player#player.light_weaponid,
%%                    Player#player.fashion#fashion_figure.fashion_cloth_id,
%%                    Player#player.fashion#fashion_figure.fashion_footprint_id,
%%                    Player#player.fashion#fashion_figure.fashion_spirit_id]]
%%
%%        end
%%        end,
%%    lists:flatmap(F, [1, 2, 3]).
