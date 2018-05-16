%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2018 15:27
%%%-------------------------------------------------------------------
-module(guild_fight_load).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("guild_fight.hrl").

%% API
-export([
    load/0,
    update/1,
    load_p/1,
    update_p/1,
    clean_fail_reward/0,
    load_guild_shadow/0,
    update_guild_shadow/1,
    clean_guild_shadow/0
]).

clean_fail_reward() ->
    Sql = io_lib:format("update player_guild_fight set fail_reward = 0", []),
    db:execute(Sql),
    ok.

clean_guild_shadow() ->
    Sql = io_lib:format("TRUNCATE TABLE guild_fight_shadow", []),
    db:execute(Sql),
    ok.

load_guild_shadow() ->
    Sql = io_lib:format("select gkey, g_sn, g_lv, g_name, g_num, g_cbp, member_list from guild_fight_shadow", []),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Gkey, GSn, Glv, GName, GNum, GCbp, MemberListBin]) ->
                #guild_fight_shadow{
                    gkey = Gkey,
                    g_sn = GSn,
                    g_num = GNum,
                    g_cbp = GCbp,
                    g_name = GName,
                    g_lv = Glv,
                    member_list = util:bitstring_to_term(MemberListBin)
                }
            end,
            lists:map(F, Rows)
    end.

update_guild_shadow(GuildShadow) ->
    #guild_fight_shadow{
        gkey = Gkey
        , g_sn = Sn
        , g_name = Name
        , g_lv = Lv
        , g_cbp = Cbp
        , g_num = Num
        , member_list = MemberList
    } = GuildShadow,
    MemberListBin = util:term_to_bitstring(MemberList),
    Sql = io_lib:format("replace into guild_fight_shadow set gkey=~p, g_sn=~p, g_name='~s', g_lv=~p, g_cbp=~p, g_num=~p, member_list='~s'",
        [Gkey, Sn, Name, Lv, Cbp, Num, MemberListBin]),
    db:execute(Sql),
    ok.

load() ->
    Sql = io_lib:format("select gkey, fight_list, medal, flag_lv, flag_exp, sum_lv, guild_num, op_time from guild_fight", []),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Gkey, FightListBin, Medal, FlagLv, FlagExp, SumLv, GuildNum, OpTime]) ->
                FightList = util:bitstring_to_term(FightListBin),
                GuildFight =
                    #guild_fight{
                        gkey = Gkey,
                        fight_list = FightList,
                        medal = Medal,
                        guild_flag_lv = FlagLv,
                        guild_flag_exp = FlagExp,
                        guild_sum_lv = SumLv,
                        guild_num = GuildNum,
                        op_time = OpTime
                    },
                case guild_ets:get_guild(Gkey) of
                    false -> skip;
                    _ ->
                        ets:insert(?ETS_GUILD_FIGHT, GuildFight)
                end
            end,
            lists:map(F, Rows);
        _ ->
            []
    end.

update(GuildFight) ->
    #guild_fight{
        gkey = Gkey,
        fight_list = FightList,
        medal = Medal,
        guild_flag_lv = FlagLv,
        guild_flag_exp = FlagExp,
        guild_sum_lv = SumLv,
        guild_num = GuildNum,
        op_time = OpTime
    } = GuildFight,
    Sql = io_lib:format("replace into guild_fight set gkey=~p, fight_list = '~s', medal=~p, flag_lv=~p, flag_exp=~p, sum_lv=~p, guild_num=~p, op_time=~p",
        [Gkey, util:term_to_bitstring(FightList), Medal, FlagLv, FlagExp, SumLv, GuildNum, OpTime]),
    db:execute(Sql),
    ok.

load_p(Pkey) ->
    Sql = io_lib:format("select challenge_num, recv_list, shop, challenge_time, fail_reward, op_time from player_guild_fight where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ChallengeNum, RecvListBin, ShopBin, ChallengeTime, FailReward, OpTime] ->
            #st_guild_fight{
                pkey = Pkey,
                recv_list = util:bitstring_to_term(RecvListBin),
                challenge_num = ChallengeNum,
                shop = util:bitstring_to_term(ShopBin),
                cd_time = ChallengeTime,
                fail_reward = FailReward,
                op_time = OpTime
            };
        _ ->
            #st_guild_fight{pkey = Pkey}
    end.

update_p(StGuildFight) ->
    #st_guild_fight{
        pkey = Pkey,
        recv_list = RecvList,
        challenge_num = ChallengeNum,
        shop = Shop,
        cd_time = ChallengeTime,
        fail_reward = FailReward,
        op_time = OpTime
    } = StGuildFight,
    Sql = io_lib:format("replace into player_guild_fight set pkey=~p,recv_list='~s',challenge_num=~p, shop='~s', challenge_time=~p, fail_reward=~p, op_time=~p",
        [Pkey, util:term_to_bitstring(RecvList), ChallengeNum, util:term_to_bitstring(Shop), ChallengeTime, FailReward, OpTime]),
    db:execute(Sql).

