%%----------------------------------------------------
%% @doc 竞技场日志模块
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(arena_dao_log).

-export([
        replace_insert_log/13
        ,update_winner/4
        ,update_log/4
        ,get_log/3
        ,get_last_time/0
        ,get_winner/2
        ,get_hero_data/1
    ]
).

-include("common.hrl").

%% 插入日志记录
replace_insert_log(RoleId, SrvId, Name, Week, Time, Score, Kill, ArenaLev, ArenaSeq, Career, Lev, GroupId, Death) ->
    Sql = <<"replace into log_arena_score (role_id, srv_id, name, week, time, score, kill_num, arena_lev, arena_seq, career, lev, group_id, death) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [RoleId, SrvId, Name, Week, Time, Score, Kill, ArenaLev, ArenaSeq, Career, Lev, GroupId, Death]) of
        {ok, Affected} -> {ok, Affected};
        {error, Msg} ->
            ?DEBUG("插入竞技场积分日志失败[Msg:~s]", [Msg]),
            {error, Msg}
    end.

%% 更新优胜者
update_winner(RoleId, SrvId, Time, IsWinner) ->
    Sql = <<"update log_arena_score set winner = ~s where role_id = ~s and srv_id = ~s and time = ~s">>,
    db:execute(Sql, [IsWinner, RoleId, SrvId, Time]).

%% 更新积分
update_log(RoleId, SrvId, Time, Score) ->
    Sql = <<"update log_arena_score set score = ~s where role_id = ~s and srv_id = ~s and time = ~s">>,
    db:execute(Sql, [Score, RoleId, SrvId, Time]).

%% 获取
get_log(RoleId, SrvId, Time) ->
    Sql = <<"select score from log_arena_score where role_id = ~s and srv_id = ~s and time = ~s">>,
    case db:get_row(Sql, [RoleId, SrvId, Time]) of
        {error, undefined} ->
            {false, []};
        {ok, [Score]} ->
            {true, [Score]}
    end.

%% 获取上次竞技时间
get_last_time() ->
    Sql = <<"select max(time), arena_lev from log_arena_score group by arena_lev">>,
    case db:get_all(Sql, []) of
        {ok, Data} -> {ok, Data};
        _Else -> {false, ?L(<<"没有竞技场比赛信息">>)}
    end.

%% 获取优胜者
get_winner(Time, ArenaLev) ->
    Sql = <<"select role_id, srv_id, name, kill_num from log_arena_score where time = ~s and arena_lev = ~s and winner = 1">>,
    case db:get_all(Sql, [Time, ArenaLev]) of
        {ok, Data} -> {ok, Data};
        _ -> {false, ?L(<<"没有找到信息">>)}
    end.

%% 获取英雄榜数据
get_hero_data(Time) ->
    Sql = <<"select role_id, srv_id, name, score, kill_num, arena_lev, arena_seq, career, lev, group_id, death, winner from log_arena_score where time > ~s and score > 0">>,
    case db:get_all(Sql, [(Time - 20)]) of
        {ok, Data} -> {ok, Data};
        _ -> {false, ?L(<<"没有找到数据">>)}
    end.
