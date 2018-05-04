%% --------------------------------------------------------------------
%% 帮战对外的接口
%% @author abu
%% @end
%% --------------------------------------------------------------------
-module(guild_war_api).

-export([
        is_can_team/2
        ,check_realm_last_guild_war/1
        ,get_last_guild_war_win_cnt/1
    ]).

%% include files
-include("common.hrl").
-include("role.hrl").
-include("looks.hrl").
-include("guild_war.hrl").

%% --------------------------------------------------------------------
%% api functions
%% --------------------------------------------------------------------

%% @spec is_can_team(Role1, Role2) -> true | false
%% Role1 = #role{}
%% Role2 = #role{} | lists()
%% @doc 检查帮战中是否可以组队--用于特殊判断
is_can_team(#role{looks = L1, event = ?event_guild_war}, #role{looks = L2, event = ?event_guild_war}) ->
    U1 = case lists:keyfind(?LOOKS_TYPE_ACT, 1, L1) of
        {_, _, Val} ->
            Val;
        _ ->
            0
    end,
    U2 = case lists:keyfind(?LOOKS_TYPE_ACT, 1, L2) of
        {_, _, Val2} ->
            Val2;
        _ ->
            0
    end,
    U1 =:= U2;
is_can_team(#role{event = ?event_guild_war}, #role{}) ->
    true;
is_can_team(#role{looks = L1, event = ?event_guild_war}, L2) when is_list(L2) ->
    U1 = case lists:keyfind(?LOOKS_TYPE_ACT, 1, L1) of
        {_, _, Val} ->
            Val;
        _ ->
            0
    end,
    U2 = case lists:keyfind(?LOOKS_TYPE_ACT, 1, L2) of
        {_, _, Val2} ->
            Val2;
        _ ->
            0
    end,
    U1 =:= U2;
is_can_team(_, _) ->
    true.

%% @spec check_realm_last_guild_war(Realm) -> true | false
%% @doc 检查所属阵营上2场圣地之争是否是连续打赢
check_realm_last_guild_war(Realm) ->
    case guild_war_dao:get_last_2_war() of
        [#guild_war_union{realm = Realm}, #guild_war_union{realm = Realm}] -> true;
        _ -> false
    end.

%% @spec get_last_guild_war_win_cnt(Realm) -> {integer(), integer()}
%% @doc 获取上一场本联盟的连赢次数
get_last_guild_war_win_cnt(Realm) ->
    case [G || G = #guild_war_union{realm = Rl} <- guild_war_dao:get_last_2_war(), Rl =/= 0] of
        [#guild_war_union{realm = Realm}, #guild_war_union{realm = Realm}] -> {2, 0};
        [_, #guild_war_union{realm = Realm}] -> {1, 0};
        [#guild_war_union{realm = Realm}, _] -> {0, 1};
        [_, _] -> {0, 2};
        [#guild_war_union{realm = Realm}] -> {1, 0};
        [_] -> {0, 1};
        [] -> {0, 0};
        _ -> {0, 0}
    end.
