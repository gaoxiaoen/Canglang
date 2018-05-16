%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 八月 2017 20:01
%%%-------------------------------------------------------------------
-module(cross_war_rank).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("cross_war.hrl").
-include("guild.hrl").

-export([ %% 跨服节点函数
    get_guild_contrib_rank/4
    , get_member_contrib_rank/4

    , get_guild_score_rank/4
    , get_member_score_rank/4
]).

-export([%% 跨服节点进程调用
    get_guild_contrib_rank_cast/4
    , get_member_contrib_rank_cast/4

    , get_guild_score_rank_cast/5
    , get_member_score_rank_cast/5
]).

get_member_contrib_rank(Pkey, Node, Sid, Type) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_member_contrib_rank, Pkey, Node, Sid, Type}),
    ok.

get_member_contrib_rank_cast(Pkey, Node, Sid, Type) ->
    RankList = cross_war_util:get_player_contrib_sort(Type),
    ProList = lists:sublist(RankList, 10),
    F = fun(CrossWarPlayer) ->
        #cross_war_player{
            contrib_rank = Rank,
            nickname = NickName,
            sn = Sn,
            g_name = MyGuildName,
            contrib_val = DefContribVal
        } = CrossWarPlayer,
        ?IF_ELSE(DefContribVal == 0, [], [[Rank, NickName, Sn, MyGuildName, DefContribVal]])
    end,
    NewProList = lists:flatmap(F, ProList),
    case lists:keyfind(Pkey, #cross_war_player.pkey, RankList) of
        false -> %% 没有公会给默认数据
            {ok, NewBin} = pt_601:write(60105, {Type, 0, <<>>, 0, <<>>, 0, NewProList});
        #cross_war_player{
            contrib_rank = MyRank,
            nickname = MyNickName,
            sn = MySn,
            g_name = MyGuildName,
            contrib_val = MyContribVal
        } ->
            NewMyRank =
                if
                    MyContribVal == 0 -> 999;
                    true -> MyRank
                end,
            {ok, NewBin} = pt_601:write(60105, {Type, NewMyRank, MyNickName, MySn, MyGuildName, MyContribVal, NewProList})
    end,
    server_send:send_to_sid(Node, Sid, NewBin).

get_guild_contrib_rank(GuildKey, Node, Sid, Type) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_guild_contrib_rank, GuildKey, Node, Sid, Type}),
    ok.

get_guild_contrib_rank_cast(GuildKey, Node, Sid, Type) ->
    RankList = cross_war_util:get_guild_contrib_sort(Type),
    ProList = lists:sublist(RankList, 10),
    F = fun(CrossWarGuild) ->
        #cross_war_guild{
            contrib_rank = Rank,
            g_name = GuildName,
            sn = Sn,
            sn_name = SnName,
            contrib_val = DefContribVal,
            is_main = IsMain
        } = CrossWarGuild,
        ?IF_ELSE(DefContribVal == 0 andalso IsMain == 0, [], [[IsMain, Rank, GuildName, Sn, SnName, DefContribVal]])
    end,
    NewProList = lists:flatmap(F, ProList),
    case lists:keyfind(GuildKey, #cross_war_guild.g_key, RankList) of
        false -> %% 没有公会给默认数据
            {ok, NewBin} = pt_601:write(60104, {Type, 0, <<>>, 0, <<>>, 0, NewProList});
        #cross_war_guild{
            is_main = IsMain,
            contrib_rank = MyRank,
            g_name = MyGuildName,
            sn = MySn,
            sn_name = MySnName,
            contrib_val = MyContribVal
        } ->
            NewMyRank =
                if
                    IsMain == 0 andalso MyContribVal == 0 -> 999;
                    true -> MyRank
                end,
            {ok, NewBin} = pt_601:write(60104, {Type, NewMyRank, MyGuildName, MySn, MySnName, MyContribVal, NewProList})
    end,
    server_send:send_to_sid(Node,Sid,NewBin).

get_member_score_rank(Pkey, Node, Sid, Type) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_member_score_rank, Pkey, Node, Sid, Type}),
    ok.

get_member_score_rank_cast(_State, Pkey, Node, Sid, Type) ->
    RankList0 = cross_war_util:get_player_score_sort(Type),
    RankList = lists:sublist(RankList0, 10),
    F = fun(CrossWarPlayer) ->
        #cross_war_player{
            score_rank = Rank,
            nickname = NickName,
            sn = Sn,
            score = DefScoreVal,
            g_name = GuildName
        } = CrossWarPlayer,
            [[Rank, NickName, Sn, GuildName, DefScoreVal]]
    end,
    NewProList = lists:flatmap(F, RankList),
    case lists:keyfind(Pkey, #cross_war_player.pkey, RankList0) of
        false -> %% 没有公会给默认数据
            {ok, NewBin} = pt_601:write(60113, {Type, 0, <<>>, 0, <<>>, 0, NewProList});
        #cross_war_player{
            score_rank = MyRank,
            nickname = MyNickName,
            sn = MySn,
            score = MyDefScoreVal,
            g_name = MyGuildName
        } ->
            {ok, NewBin} = pt_601:write(60113, {Type, MyRank, MyNickName, MySn, MyGuildName, MyDefScoreVal, NewProList})
    end,
    server_send:send_to_sid(Node,Sid,NewBin).

get_guild_score_rank(Gkey, Node, Sid, Type) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_guild_score_rank, Gkey, Node, Sid, Type}),
    ok.

get_guild_score_rank_cast(_State, Gkey, Node, Sid, Type) ->
    RankList0 = cross_war_util:get_guild_score_sort(Type),
    RankList = lists:sublist(RankList0, ?CROSS_WAR_SIGN_GUILD_MAX_NUM),
    F = fun(CrossWarGuild) ->
        #cross_war_guild{
            score_rank = Rank,
            g_name = GuildName,
            sn = Sn,
            sn_name = SnName,
            score = DefScoreVal
        } = CrossWarGuild,
        [[Rank, GuildName, Sn, SnName, DefScoreVal]]
    end,
    NewProList = lists:flatmap(F, RankList),
    case lists:keyfind(Gkey, #cross_war_guild.g_key, RankList0) of
        false -> %% 没有公会给默认数据
            {ok, NewBin} = pt_601:write(60112, {Type, 0, <<>>, 0, <<>>, 0, NewProList});
        #cross_war_guild{
            score_rank = MyRank,
            g_name = MyGuildName,
            sn = MySn,
            sn_name = MySnName,
            score = MyDefScoreVal
        } ->
            {ok, NewBin} = pt_601:write(60112, {Type, MyRank, MyGuildName, MySn, MySnName, MyDefScoreVal, NewProList})
    end,
    server_send:send_to_sid(Node, Sid,NewBin).