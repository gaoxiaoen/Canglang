%%----------------------------------------------------
%% @doc 新帮战数据持久化处理
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(guild_arena_dao).
-export([
        save/7,
        load/0
    ]).
-include("common.hrl").
-include("guild_arena.hrl").

%% @spec save(Id, Roles, RoleNum, Guilds, GuildNum, LastWinner) -> ok
%% Id = integer()
%% Roles = list(),
%% RoleNum = integer()
%% Guilds = list()
%% GuildNum = integer()
%% LastWinner = tuple()
%% @doc 把状态全部保存到数据库
save(Id, Roles, RoleNum, Guilds, GuildNum, LastWinner, Round) ->
    save_state(Id, RoleNum, GuildNum, LastWinner, Round),
    save_roles(Roles, Id),
    save_guilds(Guilds, Id),
    ok.

%% 从数据库里取出全部状态
load() ->
    {Id, RoleNum, GuildNum, LastWinner, Round} = load_state(),
    Roles = load_roles(Id),
    Guilds = load_guilds(Id),
    {Id, Roles, RoleNum, Guilds, GuildNum, LastWinner, Round}.

%% 载入帮战状态
load_state() ->
    Sql = "select id, role_num, guild_num, last_winner, round_num from sys_guild_arena_state order by id desc limit 1",
    case db:get_row(Sql) of
        {ok, [Id, RoleNum, GuildNum, LastWinner, Round]} ->
            {Id, RoleNum, GuildNum, to_term(LastWinner), Round};
        _ ->
            {0, 0, 0, 0, 0}
    end.

%% 载入玩家战绩
load_roles(StateId) ->
    Sql = "select id, srv_id, name, lev, guild_id, guild_srv_id, guild_name, position, `kill`, lost, die, fc, score, sum_score, sum_kill, sum_lost, last_death from sys_guild_arena_role where state_id = ~s",
    case db:get_all(Sql, [StateId]) of
        {ok, Rdata} when is_list(Rdata) ->
            F = fun([Id, SrvId, Name, Lev, GuildId, GuildSrvId, GuildName, Position, Kill, Lost, Die, Fc, Score, SumScore, SumKill, SumLost, LastDeath]) ->
                    #guild_arena_role{
                        id = {Id, SrvId}, 
                        name = Name, 
                        lev = Lev, 
                        gid = {GuildId, GuildSrvId}, 
                        guild_name = GuildName, 
                        position = Position, 
                        kill = Kill, 
                        lost = Lost, 
                        die = Die, 
                        fc = Fc, 
                        score = Score, 
                        sum_score = SumScore, 
                        sum_kill = SumKill, 
                        sum_lost = SumLost, 
                        last_death = LastDeath}
            end,
            [F(R) || R <- Rdata];
        {error, _Msg} ->
            ?ERR("帮战获取参战帮派信息出错: ~s", [_Msg]),
            [];
        _ ->
            []
    end.

%% 载入帮派战绩
load_guilds(StateId) ->
    Sql = "select id, srv_id, name, lev, chief, member_num, members, `join_num`, `kill`, lost, die, fc, score, round_score, sum_score, sum_kill, sum_lost from sys_guild_arena_guild where state_id = ~s",
    case db:get_all(Sql, [StateId]) of
        {ok, Gdata} when is_list(Gdata) ->
            F = fun([Id, SrvId, Name, Lev, Chief, MemberNum, Members, JoinNum, Kill, Lost, Die, Fc, Score, RoundScore, SumScore, SumKill, SumLost]) ->
                    #arena_guild{
                        id = {Id, SrvId},
                        name = Name,
                        lev = Lev,
                        chief = Chief,
                        member_num = MemberNum,
                        members = to_term(Members),
                        join_num = JoinNum,
                        kill = Kill,
                        lost = Lost,
                        die = Die,
                        fc = Fc,
                        score = Score,
                        round_score = to_term(RoundScore),
                        sum_score = SumScore,
                        sum_kill = SumKill,
                        sum_lost = SumLost
                    }
            end,
            [F(G) || G <- Gdata];
        {error, _Msg} ->
            ?ERR("读取帮会战绩出错: ~s", [_Msg]),
            [];
        _ ->
            []
    end.

%% 保存帮战状态
save_state(Id, RoleNum, GuildNum, LastWinner, Round) ->
    ?DEBUG("round is ~w", [Round]),
    Sql = "insert into sys_guild_arena_state(id, role_num, guild_num, last_winner, round_num) values(~s, ~s, ~s, ~s, ~s)",
    db:execute(Sql, [Id, RoleNum, GuildNum, util:term_to_bitstring(LastWinner), Round]).

%% 保存参战玩家信息
save_roles([H | T], StateId) ->
    Sql = "insert into sys_guild_arena_role(id, srv_id, name, lev, guild_id, guild_srv_id, guild_name, position, `kill`, lost, die, fc, score, sum_score, sum_kill, sum_lost, last_death, state_id) values ",
    F = fun(#guild_arena_role{
                id = {Id, SrvId}, 
                name = Name, 
                lev = Lev, 
                gid = {GuildId, GuildSrvId}, 
                guild_name = GuildName, 
                position = Position, 
                kill = Kill, 
                lost = Lost, 
                die = Die, 
                fc = Fc, 
                score = Score, 
                sum_score = SumScore, 
                sum_kill = SumKill, 
                sum_lost = SumLost, 
                last_death = LastDeath}, 
            Sid) ->
            erlang:bitstring_to_list(db:format_sql("(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)", [Id, SrvId, Name, Lev, GuildId, GuildSrvId, GuildName, Position, Kill, Lost, Die, Fc, Score, SumScore, SumKill, SumLost, LastDeath, Sid]))
    end,
    FullSql = Sql ++ string:join([F(R, StateId) || R <- [H | T]], ","),
    db:execute(FullSql);
save_roles(_, _) -> 
    ok.

%% 保存参战帮派信息
save_guilds([H | T], StateId) ->
    Sql = "insert into sys_guild_arena_guild(id, srv_id, name, lev, chief, member_num, members, join_num, `kill`, lost, die, fc, score, round_score, sum_score, sum_kill, sum_lost, state_id) values",
    F = fun(#arena_guild{
                id = {Id, SrvId},
                name = Name,
                lev = Lev,
                chief = Chief,
                member_num = MemberNum,
                members = Members,
                join_num = JoinNum,
                kill = Kill,
                lost = Lost,
                die = Die,
                fc = Fc,
                score = Score,
                round_score = RoundScore,
                sum_score = SumScore,
                sum_kill = SumKill,
                sum_lost = SumLost
            }, Sid) ->
            erlang:bitstring_to_list(db:format_sql("(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)", [Id, SrvId, Name, Lev, Chief, MemberNum, util:term_to_bitstring(Members), JoinNum, Kill, Lost, Die, Fc, Score, util:term_to_bitstring(RoundScore), SumScore, SumKill, SumLost, Sid]))
    end,
    FullSql = Sql ++ string:join([F(R, StateId) || R <- [H | T]], ","),
    db:execute(FullSql);
save_guilds(_, _) ->
    ok.

%% 将数据库存储的数据转换为 帮会term
to_term(GuildsData) ->
    case util:bitstring_to_term(GuildsData) of
        {ok, R} ->
            R;
        _ ->
            []
    end.
