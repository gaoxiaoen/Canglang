%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 11:21
%%%-------------------------------------------------------------------
-module(cross_war_load).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("cross_war.hrl").

%% API
-export([
    load/1,
    update/1,
    get_all_pkey_list/0,
    dbup_guild_sign/3,
    load_king/1,
    update_king/1
]).

load_king(Node) ->
    Sql = io_lib:format("select gkey,pkey,sign,last_pkey,last_gkey,acc_win,kill_war_door_list,kill_king_door_list,def_gkey_list,att_gkey_list from cross_war_king where node='~s'", [Node]),
    case db:get_row(Sql) of
        [Gkey, Pkey, Sign, LastKey, LastGkey, AccWin, KillWarDoorListBin, KillKingDoorListBin, DefGkeyListBin, AttGkeyListBin] when is_integer(Gkey) ->
            {Gkey, Pkey, Sign, LastKey, LastGkey, AccWin, util:bitstring_to_term(KillWarDoorListBin), util:bitstring_to_term(KillKingDoorListBin), util:bitstring_to_term(DefGkeyListBin), util:bitstring_to_term(AttGkeyListBin)};
        _ -> {0, 0, 0, 0, 0, 0, [], [], [], []}
    end.

update_king([Gkey, Pkey, Sign, LastPkey, LastGkey, AccWin, KillWarDoorList, KillKingDoorList, DefGkeyList, AttGkeyList]) ->
    KillWarDoorListBin = util:term_to_bitstring(KillWarDoorList),
    KillKingDoorListBin = util:term_to_bitstring(KillKingDoorList),
    DefGkeyListBin = util:term_to_bitstring(DefGkeyList),
    AttGkeyListBin = util:term_to_bitstring(AttGkeyList),
    Sql = io_lib:format("replace into cross_war_king set gkey=~p,pkey=~p,sign=~p,last_pkey=~p,last_gkey=~p,acc_win=~p,kill_war_door_list='~s',kill_king_door_list='~s',def_gkey_list='~s',att_gkey_list='~s', node='~s'",
        [Gkey, Pkey, Sign, LastPkey, LastGkey, AccWin, KillWarDoorListBin, KillKingDoorListBin, DefGkeyListBin, AttGkeyListBin, node()]),
    db:execute(Sql),
    ok.

load(Pkey) ->
    Sql = io_lib:format("select contrib, contrib_list, is_recv_member, is_recv_king, op_time, guild_key, is_orz from player_cross_war where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [] ->
            #st_cross_war{pkey = Pkey};
        [Contrib, ContribListBin, IsRecvMember, IsRecvKing, OpTime, GuildKey, IsOrz] ->
            #st_cross_war{
                pkey = Pkey,
                contrib = Contrib,
                contrib_list = util:bitstring_to_term(ContribListBin),
                is_member_reward = IsRecvMember,
                is_king_reward = IsRecvKing,
                op_time = OpTime,
                guild_key = GuildKey,
                is_orz = IsOrz
            }
    end.

update(#st_cross_war{pkey=Pkey} = StCrossWar) ->
    #st_cross_war{
        pkey = Pkey,
        contrib = Contrib,
        contrib_list = ContribList,
        is_member_reward = IsRecvMember,
        is_king_reward = IsRecvKing,
        op_time = OpTime,
        guild_key = GuildKey,
        is_orz = IsOrz
    } = StCrossWar,
    ContribListBin = util:term_to_bitstring(ContribList),
    Sql = io_lib:format("replace into player_cross_war set pkey=~p, contrib=~p, contrib_list='~s', op_time=~p, is_recv_member=~p, is_recv_king=~p, guild_key=~p, is_orz=~p",
        [Pkey, Contrib, ContribListBin, OpTime, IsRecvMember, IsRecvKing, GuildKey, IsOrz]),
    db:execute(Sql).

get_all_pkey_list() ->
    Sql = io_lib:format("select pkey, guild_key, contrib_list from player_cross_war", []),
    case db:get_all(Sql) of
        [] -> [];
        PkeyList ->
            PkeyList
    end.

dbup_guild_sign(Gkey, Sign, ChangeTime) ->
    Sql = io_lib:format("replace into guild_cross_war_sign set gkey=~p, sign=~p, change_time=~p", [Gkey, Sign, ChangeTime]),
    db:execute(Sql).