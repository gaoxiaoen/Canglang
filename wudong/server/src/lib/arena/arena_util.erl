%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 一月 2017 10:15
%%%-------------------------------------------------------------------
-module(arena_util).
-author("hxming").
-include("arena.hrl").
-include("server.hrl").
-include("common.hrl").
-include("scene.hrl").
%% API
-compile(export_all).


%%获取可挑战列表
arena_list(Arena, RankDict, _Now, Cbp) ->
    case check_challenge(Arena#arena.challenge) of
        false ->
            pack_challenge(Arena#arena.challenge);
        true ->
            ChallengeList = challenge_list(Arena, RankDict, open, Cbp),
            NewArena = Arena#arena{challenge = ChallengeList, refresh_cd = _Now},
            arena_init:set_arena(NewArena),
            pack_challenge(ChallengeList)
    end.

check_challenge(ChallengeList) ->
    case ChallengeList of
        [] -> true;
        _ ->
            F = fun(Challenge) ->
                case arena_init:get_arena(Challenge#challenge.pkey) of
                    false -> true;
                    Arena ->
                        Arena#arena.rank =/= Challenge#challenge.rank

                end
                end,
            lists:any(F, ChallengeList)
    end.
arena_career(Rank) ->
    case Rank rem 2 of
        0 -> 2;
        Val -> Val
    end.

challenge_list(Arena, RankDict, Type, MyCbp) ->
    Rank =
        if Arena#arena.rank == 0 -> ?ROBOT_NUM;
            true -> Arena#arena.rank
        end,
    Ids = rank_ids(Rank, Type),
    F = fun(RankId) ->
        case dict:is_key(RankId, RankDict) of
            false -> [];
            true ->
                Pkey = dict:fetch(RankId, RankDict),
                if Pkey == Arena#arena.pkey -> [];
                    true ->
                        case arena_init:get_arena(Pkey) of
                            false -> [];
                            Are ->
                                Player = get_player(Are#arena.type, Are),
                                %%首次挑战继承挑战者属性,战力
                                Cbp = ?IF_ELSE(Arena#arena.wins == 0, round(util:rand(80, 100) / 100 * MyCbp), Player#player.cbp),
                                [init_challenge(Are#arena.type, Player, RankId, Cbp)]
                        end
                end
        end
        end,
    lists:flatmap(F, Ids).

init_challenge(Type, Player, RankId, Cbp) ->
    #challenge{
        type = Type,
        vip = Player#player.vip_lv,
        pkey = Player#player.key,
        nickname = Player#player.nickname,
        realm = Player#player.realm,
        career = Player#player.career,
        sex = Player#player.sex,
        rank = RankId,
        cbp = Cbp,
        wind_id = Player#player.wing_id,
        weapon_id = Player#player.equip_figure#equip_figure.weapon_id,
        clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
        light_weaponid = Player#player.light_weaponid,
        fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
        footprint_id = Player#player.footprint_id,
        fashion_head_id = Player#player.fashion#fashion_figure.fashion_head_id
    }.

pack_challenge(ChallengeList) ->
    F = fun(Challenge) ->
        [Challenge#challenge.pkey,
            Challenge#challenge.nickname,
            Challenge#challenge.realm,
            Challenge#challenge.career,
            Challenge#challenge.sex,
            Challenge#challenge.rank,
            Challenge#challenge.cbp,
            Challenge#challenge.wind_id,
            Challenge#challenge.weapon_id,
            Challenge#challenge.clothing_id,
            Challenge#challenge.light_weaponid,
            Challenge#challenge.fashion_cloth_id,
            Challenge#challenge.footprint_id,
            Challenge#challenge.fashion_head_id

        ]
        end,
    lists:map(F, ChallengeList).

get_player(1, Arena) ->
    shadow_proc:get_shadow(Arena#arena.pkey);
get_player(_, Arena) ->
    case data_arena_robot:get(Arena#arena.rank) of
        [] ->
            Shadow = shadow:shadow_ai_for_arena(Arena#arena.career, Arena#arena.sex),
            Shadow#player{
                key = Arena#arena.pkey,
                nickname = Arena#arena.nickname,
                realm = Arena#arena.realm,
                career = Arena#arena.career,
                sex = Arena#arena.sex,
                attribute = #attribute{hp_lim = 10000, att = 1000, def = 1000},
                shadow = #st_shadow{shadow_id = ?SHADOW_ID}
            };
        Robot ->
            HpLim = case data_mon:get(Robot#base_arena_robot.mon_id) of
                        [] -> 10000;
                        Mon -> Mon#mon.hp_lim
                    end,
            Attribute = #attribute{hp_lim = HpLim},
            Shadow = shadow:shadow_ai_for_arena(Arena#arena.career, Arena#arena.sex),
            Shadow#player{
                key = Arena#arena.pkey,
                nickname = Arena#arena.nickname,
                realm = Arena#arena.realm,
                career = Arena#arena.career,
                sex = Arena#arena.sex,
                cbp = round(Robot#base_arena_robot.power * util:rand(100, 120) / 100),
                attribute = Attribute,
                shadow = #st_shadow{shadow_id = Robot#base_arena_robot.mon_id}
            }
    end.

%%可挑战ID
rank_ids(Rank, _Type) ->
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
        Rank >= 51 andalso Rank =< 80 ->
            [util:list_rand(lists:delete(Rank, lists:seq(40, 49))),
                util:list_rand(lists:delete(Rank, lists:seq(50, 69))),
                util:list_rand(lists:delete(Rank, lists:seq(70, 100)))];
        Rank >= 81 andalso Rank =< 200 ->
            [util:list_rand(lists:delete(Rank, lists:seq(Rank - 40, Rank - 26))),
                util:list_rand(lists:delete(Rank, lists:seq(Rank - 25, Rank - 11))),
                util:list_rand(lists:delete(Rank, lists:seq(Rank - 10, Rank + 30)))];
        true ->
            [util:list_rand(lists:delete(Rank, lists:seq(Rank - 120, Rank - 81))),
                util:list_rand(lists:delete(Rank, lists:seq(Rank - 80, Rank - 41))),
                util:list_rand(lists:delete(Rank, lists:seq(Rank - 40, min(Rank + 40, ?ROBOT_NUM))))]
    end.

%%未上榜玩家优先系统机器人
filter_id(Rank, _Type) when Rank == ?ROBOT_NUM ->
    RankList = [
        {util:floor(?ROBOT_NUM * 0.3), util:floor(?ROBOT_NUM * 0.50)},
        {util:floor(?ROBOT_NUM * 0.51), util:floor(?ROBOT_NUM * 0.90)},
        {util:floor(?ROBOT_NUM * 0.91), util:floor(?ROBOT_NUM * 0.99)}
    ],
    RankDict = arena_init:get_rank(),
    F = fun({Max, Min}) ->
        match_ai(Max, Min, RankDict)
        end,
    Ids = lists:map(F, RankList),
    util:list_filter_repeat(Ids);
filter_id(Rank, _Type) ->
    Id1 = util:list_rand(lists:delete(Rank, lists:seq(util:floor(Rank * 0.3), util:floor(Rank * 0.5)))),
    Id2 = util:list_rand(lists:delete(Rank, lists:seq(util:floor(Rank * 0.51), util:floor(Rank * 0.90)))),
    Extra = ?IF_ELSE(Rank =< ?ROBOT_NUM * 0.8, 1.2, 0.99),
    Id3 = util:list_rand(lists:delete(Rank, lists:seq(util:floor(Rank * 0.91), util:floor(Rank * Extra)))),
    util:list_filter_repeat([Id1, Id2, Id3]).

match_ai(Max, Min, RankDict) ->
    F = fun(Rank) ->
        case dict:is_key(Rank, RankDict) of
            false -> [Rank];
            true ->
                []
        end
        end,
    AiList =
        lists:flatmap(F, lists:seq(Max, Min)),
    case AiList of
        [] -> util:rand(Max, Min);
        Ids -> util:list_rand(Ids)
    end.