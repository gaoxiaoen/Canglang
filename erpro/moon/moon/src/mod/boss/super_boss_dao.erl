%%----------------------------------------------------
%% @doc 超级世界boss数据库操作模块
%%
%% <pre>
%% 超级世界boss数据库操作模块
%% </pre>
%% @author mobin
%%----------------------------------------------------
-module(super_boss_dao).

-export([
        save_summary/1,
        load_last_summary/0,
        load_last_normal_summary/0,
        save_info/1,
        load_all_info/1,
        save_rank/1,
        delete_old_summary/1,
        delete_old_info/1,
        delete_old_rank/1,
        load_all_rank/2,
        select_from_rank/2
    ]).

-include("common.hrl").
-include("boss.hrl").
-include("item.hrl").

%% @spec save_summary(Summary) -> {ok, _} | {error, Reason}
%% Summary = #super_boss_summary{}
%% 保存超级世界boss概要
save_summary(#super_boss_summary{id = SummaryId, start_time = StartTime, boss_count = BossCount,
    killed_boss_count = KilledBossCount, kill_count = KillCount, reward_count = RewardCount, next_count = NextCount}) ->
    Sql = "select * from sys_super_boss_summary where id=~s",
    case db:get_row(Sql, [SummaryId]) of
        {error, undefined} ->
            InsertSql = "insert into sys_super_boss_summary(start_time, boss_count, killed_boss_count, kill_count, reward_count, next_count) values(~s,~s,~s,~s,~s,~s)",
            db:execute(InsertSql, [StartTime, BossCount, KilledBossCount, KillCount, RewardCount, NextCount]);
        {ok, _} ->
            UpdateSql = "update sys_super_boss_summary set start_time=~s, boss_count=~s, killed_boss_count=~s, kill_count=~s, reward_count=~s, next_count=~s where id=~s",
            db:execute(UpdateSql, [StartTime, BossCount, KilledBossCount, KillCount, RewardCount, NextCount, SummaryId]);
        Err -> {error, Err}
    end.

%% @spec load_last_summary()
%% 读取上一次概要
load_last_summary() ->
    Sql = "select id, start_time, boss_count, killed_boss_count, kill_count, reward_count, next_count from sys_super_boss_summary order by id desc limit 1",
    case db:get_row(Sql, []) of
        {ok, [Id, StartTime, BossCount, KilledBossCount, KillCount, RewardCount, NextCount]} ->
            #super_boss_summary{id = Id, start_time = StartTime, boss_count = BossCount, killed_boss_count = KilledBossCount,
                kill_count = KillCount, reward_count = RewardCount, next_count = NextCount};
        _ ->
            undefined
    end.

%% @spec load_last_normal_summary()
%% 读取上一次有排行的概要
load_last_normal_summary() ->
    Sql = "select id, start_time, boss_count, killed_boss_count, kill_count, reward_count, next_count from sys_super_boss_summary where id in(select max(summary_id) from sys_super_boss_rank) order by id desc limit 1",
    case db:get_row(Sql, []) of
        {ok, [Id, StartTime, BossCount, KilledBossCount, KillCount, RewardCount, NextCount]} ->
            #super_boss_summary{id = Id, start_time = StartTime, boss_count = BossCount, killed_boss_count = KilledBossCount,
                kill_count = KillCount, reward_count = RewardCount, next_count = NextCount};
        _ ->
            undefined
    end.

%% @spec delete_old_summary(SummaryId) -> ok | {error, Reason}
%% SummaryId = integer   从这个概要id往前的删除
%% 删除旧的概要信息
delete_old_summary(SummaryId) ->
    Sql = "delete from sys_super_boss_summary where id<=~s",
    case db:execute(Sql, [SummaryId]) of
        {ok, _} -> ok;
        _Err ->
            ?ERR("删除旧的概要信息[id=~w]失败:~w", [SummaryId, _Err]),
            _Err
    end.

delete_old_info(SummaryId) ->
    Sql = "delete from sys_super_boss_info where summary_id<=~s",
    case db:execute(Sql, [SummaryId]) of
        {ok, _} -> 
            ok;
        _Err ->
            ?ERR("删除旧的概要信息[id=~w]失败:~w", [SummaryId, _Err]),
            _Err
    end.

%% @spec delete_old_rank(SummaryId) -> ok
%% SummaryId = integer   从这个概要id往前的删除
%% 删除旧的挑战排行榜数据
delete_old_rank(SummaryId) ->
    Sql = "delete from sys_super_boss_rank where summary_id<=~s",
    case db:execute(Sql, [SummaryId]) of
        {ok, _} -> ok;
        _Err ->
            ?ERR("删除旧的概要信息[id=~w]失败:~w", [SummaryId, _Err]),
            _Err
    end.

save_info(#super_boss_info{summary_id = SummaryId, npc_base_id = NpcBaseId, invaid_map_id = InvaidMapId, kill_count = KillCount,
        last_rid = {LastRoleId, LastSrvId}, best_rid = {BestRoleId, BestSrvId}}) ->
    Sql = "replace into sys_super_boss_info values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [SummaryId, NpcBaseId, InvaidMapId, KillCount, LastRoleId, LastSrvId, BestRoleId, BestSrvId]) of
        {error, Why} ->
            ?ERR("save_super_boss_info时发生异常: ~s", [Why]),
            false;
        {ok, _X} ->
            ok
    end.

load_all_info(SummaryId) ->
    Sql = "select * from sys_super_boss_info where summary_id=~s",
    case db:get_all(Sql, [SummaryId]) of
        {ok, Data} when is_list(Data) ->
            convert_to_info(Data, []);
        _ ->
            ?ERR("读取世界boss战况info出错", []),
            []
    end.


save_rank(#super_boss_rank{summary_id = SummaryId, rid = {RoleId, SrvId}, total_dmg = TotalDmg,
        name = Name, sex = Sex, career = Career, lev = Lev, guild_name = GuildName, looks = Looks, eqm = Eqm}) ->
    Sql = "replace into sys_super_boss_rank values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [SummaryId, RoleId, SrvId, TotalDmg, Name, Sex, Career, Lev, GuildName,
                util:term_to_bitstring(Looks), util:term_to_bitstring(Eqm)]) of
        {error, Why} ->
            ?ERR("save_super_boss_rank时发生异常: ~s", [Why]),
            false;
        {ok, _X} ->
            ok
    end.

%% @spec load_all_rank(SummaryId) -> [#super_boss_rank{}]
%% SummaryId = integer()
%% 读取指定概要下的全部排行榜数据
load_all_rank(SummaryId, Limit) ->
    Sql = "select * from sys_super_boss_rank where summary_id=~s order by total_dmg desc limit ~s",
    case db:get_all(Sql, [SummaryId, Limit]) of
        {ok, Data} when is_list(Data) ->
            convert_to_rank(Data, []);
        _ ->
            ?ERR("读取超级世界boss挑战排行榜出错", []),
            []
    end.

%% @spec select_from_rank(SummaryId, RoleId) -> [#super_boss_rank{}]
%% SummaryId = integer()
%% RoleId = integer()
%% 查找角色在排行榜的数据
select_from_rank(SummaryId, {RoleId, SrvId}) ->
    Sql = "select * from sys_super_boss_rank where summary_id=~s and role_id=~s and srv_id=~s",
    case db:get_all(Sql, [SummaryId, RoleId, SrvId]) of
        {ok, Data} when is_list(Data) ->
            convert_to_rank(Data, []);
        _ ->
            ?ERR("读取超级世界boss挑战排行榜出错", []),
            []
    end.


%%------------------------------------------------------------
%% 内部实现
%%------------------------------------------------------------
convert_to_rank([], L) -> lists:reverse(L);
convert_to_rank([[SummaryId, RoleId, SrvId, TotalDmg, Name, Sex, Career, Lev, GuildName, Looks, Eqm] | T], L) ->
    GuildName1 = case GuildName of
        undefined -> <<>>;
        _ -> GuildName
    end,
    Looks2 = case util:bitstring_to_term(Looks) of
        {ok, Looks1} -> 
            case Looks1 of
                [_|_] -> Looks1;
                _ -> []
            end;
        {error, _Why1} -> 
            ?ERR("从排行榜数据中抽取外观数据出错:~w", [_Why1]),
            []
    end,
    Eqm2 = case util:bitstring_to_term(Eqm) of
        {ok, Eqm1} ->
            case Eqm1 of
                [_|_] -> Eqm1;
                _ -> []
            end;
        {error, _Why2} ->
            ?ERR("从排行榜数据中抽取装备数据出错:~w", [_Why2]),
            []
    end,
    Rank = #super_boss_rank{summary_id = SummaryId, rid = {RoleId, SrvId}, total_dmg = TotalDmg,
        name = Name, sex = Sex, career = Career, lev = Lev, guild_name = GuildName1, looks = Looks2, eqm = Eqm2},
    convert_to_rank(T, [Rank | L]).

convert_to_info([], L) -> L;
convert_to_info([[SummaryId, NpcBaseId, InvaidMapId, KillCount, LastRoleId, LastSrvId, BestRoleId, BestSrvId] | T], L) ->
    Info = #super_boss_info{summary_id = SummaryId, npc_base_id = NpcBaseId, invaid_map_id = InvaidMapId, kill_count = KillCount,
        last_rid = {LastRoleId, LastSrvId}, best_rid = {BestRoleId, BestSrvId}},
    convert_to_info(T, [Info | L]).

