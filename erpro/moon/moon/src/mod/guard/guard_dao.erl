%%----------------------------------------------------
%% @doc 守卫洛水 
%% 
%% @author shawn 
%% @end
%%----------------------------------------------------
-module(guard_dao).

-export([
        save_rank_to_db/2
        ,get_rank_from_db/0
        ,clean_db_rank/0
        ,save_c_rank_to_db/2
        ,save_c_boss_to_db/1
        ,clean_db_c_rank/0
        ,get_c_rank_from_db/0
    ]
).

-include("common.hrl").
-include("guard.hrl").

-define(type_lastrank, 1).
-define(type_allrank, 2).

%% 清除榜数据
clean_db_rank() ->
    Sql = <<"delete from sys_guard_rank">>,
    case db:execute(Sql) of
        {ok, _} -> true;
        _E ->
           ?ERR("删除sys_guard_rank记录失败: ~w"),
           false
    end.

%% 清除榜数据
clean_db_c_rank() ->
    Sql = <<"delete from sys_guard_counter_rank">>,
    case db:execute(Sql) of
        {ok, _} -> true;
        _E ->
           ?ERR("删除sys_guard_counter_rank记录失败: ~w"),
           false
    end.

%% 插入数据到数据库
save_rank_to_db([], []) -> ok;
save_rank_to_db([], [R | AllRank]) -> 
    save_record(?type_allrank, R),
    save_rank_to_db([], AllRank);
save_rank_to_db([R | LastRank], AllRank) ->
    save_record(?type_lastrank, R),
    save_rank_to_db(LastRank, AllRank).

%% 插入一条记录
save_record(?type_lastrank, #role_guard{rid = Rid, srv_id = SrvId, name = Name, career = Career, lev = Lev, sex = Sex, guild_name = GuildName, looks = Looks, eqm = Eqm, kill_npc = KillNpc, kill_boss = KillBoss, point = Point, all_point = AllPoint}) ->
    Sql = <<"insert into sys_guard_rank (type, rid, srv_id, name, career, lev, sex, guild_name, looks, eqm, kill_npc, kill_boss, point, all_point) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [?type_lastrank, Rid, SrvId, Name, Career, Lev, Sex, GuildName, util:term_to_bitstring(Looks), util:term_to_bitstring(Eqm), KillNpc, KillBoss, Point, AllPoint]) of
        {ok, _Rows} -> ok;
        _X ->
            ?ERR("插入上一次排行记录失败:~s, Point:~w, AllPoint:~w, 原因:~w",[Name, Point, AllPoint, _X]),
            false
    end;

save_record(?type_allrank, #role_guard{rid = Rid, srv_id = SrvId, name = Name, career = Career, lev = Lev, sex = Sex, guild_name = GuildName, looks = Looks, eqm = Eqm, kill_npc = KillNpc, kill_boss = KillBoss, point = Point, all_point = AllPoint}) ->
    Sql = <<"insert into sys_guard_rank (type, rid, srv_id, name, career, lev, sex, guild_name, looks, eqm, kill_npc, kill_boss, point, all_point) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [?type_allrank, Rid, SrvId, Name, Career, Lev, Sex, GuildName, util:term_to_bitstring(Looks), util:term_to_bitstring(Eqm), KillNpc, KillBoss, Point, AllPoint]) of
        {ok, _Rows} -> ok;
        _X ->
            ?ERR("插入累计排行记录失败:~s, Point:~w, AllPoint:~w, 原因:~w",[Name, Point, AllPoint, _X]),
            false
    end.

%% 插入数据到数据库
save_c_rank_to_db([], []) -> ok;
save_c_rank_to_db([], [R | AllRank]) -> 
    save_c_record(?type_allrank, R),
    save_c_rank_to_db([], AllRank);
save_c_rank_to_db([R | LastRank], AllRank) ->
    save_c_record(?type_lastrank, R),
    save_c_rank_to_db(LastRank, AllRank).

save_c_boss_to_db(Boss) when is_record(Boss, guard_counter_role) -> save_c_record(3, Boss);
save_c_boss_to_db(_) -> skip.

%% 插入一条记录
save_c_record(?type_lastrank, #guard_counter_role{rid = Rid, srv_id = SrvId, name = Name, career = Career, lev = Lev, sex = Sex, guild_name = GuildName, looks = Looks, eqm = Eqm, kill_npc = KillNpc, point = Point, all_point = AllPoint}) ->
    Sql = <<"insert into sys_guard_counter_rank (type, rid, srv_id, name, career, lev, sex, guild_name, looks, eqm, kill_npc, point, all_point) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [?type_lastrank, Rid, SrvId, Name, Career, Lev, Sex, GuildName, util:term_to_bitstring(Looks), util:term_to_bitstring(Eqm), KillNpc, Point, AllPoint]) of
        {ok, _Rows} -> ok;
        _X ->
            ?ERR("插入上一次排行记录失败:~s, Point:~w, AllPoint:~w, 原因:~w",[Name, Point, AllPoint, _X]),
            false
    end;

save_c_record(?type_allrank, #guard_counter_role{rid = Rid, srv_id = SrvId, name = Name, career = Career, lev = Lev, sex = Sex, guild_name = GuildName, looks = Looks, eqm = Eqm, kill_npc = KillNpc, point = Point, all_point = AllPoint}) ->
    Sql = <<"insert into sys_guard_counter_rank (type, rid, srv_id, name, career, lev, sex, guild_name, looks, eqm, kill_npc, point, all_point) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [?type_allrank, Rid, SrvId, Name, Career, Lev, Sex, GuildName, util:term_to_bitstring(Looks), util:term_to_bitstring(Eqm), KillNpc, Point, AllPoint]) of
        {ok, _Rows} -> ok;
        _X ->
            ?ERR("插入累计排行记录失败:~s, Point:~w, AllPoint:~w, 原因:~w",[Name, Point, AllPoint, _X]),
            false
    end;
save_c_record(3, #guard_counter_role{rid = Rid, srv_id = SrvId, name = Name, career = Career, lev = Lev, sex = Sex, guild_name = GuildName, looks = Looks, eqm = Eqm, kill_npc = KillNpc, point = Point, all_point = AllPoint}) ->
    Sql = <<"insert into sys_guard_counter_rank (type, rid, srv_id, name, career, lev, sex, guild_name, looks, eqm, kill_npc, point, all_point) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [3, Rid, SrvId, Name, Career, Lev, Sex, GuildName, util:term_to_bitstring(Looks), util:term_to_bitstring(Eqm), KillNpc, Point, AllPoint]) of
        {ok, _Rows} -> ok;
        _X ->
            ?ERR("插入累计排行记录失败:~s, Point:~w, AllPoint:~w, 原因:~w",[Name, Point, AllPoint, _X]),
            false
    end.

get_rank_from_db() ->
    Sql1 = <<"select * from sys_guard_rank where type = 1">>,
    Sql2 = <<"select * from sys_guard_rank where type = 2">>,
    Last = case db:get_all(Sql1) of
        {ok, Rows} -> 
            to_record(Rows);
        _X1 ->
            ?ERR("查询上一次排行榜出错:~w",[_X1]),
            []
    end,
    All = case db:get_all(Sql2) of
        {ok, AllRows} -> 
            to_record(AllRows);
        _X2 ->
            ?ERR("查询上一次排行榜出错:~w",[_X2]),
            []
    end,
    LastRank = lists:sort(fun sort_point/2, Last),
    AllRank = guard_mgr:qsort_all_point(All),
    Boss = guard_mgr:to_boss(LastRank),
    {Boss, LastRank, AllRank}.

get_c_rank_from_db() ->
    Sql1 = <<"select * from sys_guard_counter_rank where type = 1">>,
    Sql2 = <<"select * from sys_guard_counter_rank where type = 2">>,
    Sql3 = <<"select * from sys_guard_counter_rank where type = 3">>,
    Last = case db:get_all(Sql1) of
        {ok, Rows} -> 
            to_c_record(Rows);
        _X1 ->
            ?ERR("查询上一次排行榜出错:~w",[_X1]),
            []
    end,
    All = case db:get_all(Sql2) of
        {ok, AllRows} -> 
            to_c_record(AllRows);
        _X2 ->
            ?ERR("查询上一次排行榜出错:~w",[_X2]),
            []
    end,
    Boss = case db:get_all(Sql3) of
        {ok, BossRows} ->
            to_c_boss(BossRows);
        _X3 ->
            ?ERR("查询上一次屠魔勇士出错:~w",[_X3]),
            {}
    end,
    LastRank = lists:sort(fun sort_c_point/2, Last),
    AllRank = guard_mgr:qsort_all_c_point(All),
    {Boss, LastRank, AllRank}.

to_record(Rows) ->
    to_record(Rows, []).
to_record([], Rank) -> Rank;
to_record([[_Type, Rid, SrvId, Name, Career, Lev, Sex, GuildName, Looks, Eqm, KillNpc, KillBoss, Point, AllPoint] | T], Rank) ->
    Looks2 = case util:bitstring_to_term(Looks) of
        {ok, Looks1} -> 
            case Looks1 of
                [_|_] -> Looks1;
                _ -> []
            end;
        {error, _Why1} -> 
            ?ERR("守卫洛水上一次排行榜外观错误:~w", [_Why1]),
            []
    end,
    Eqm2 = case util:bitstring_to_term(Eqm) of
        {ok, Eqm1} ->
            case Eqm1 of
                [_|_] ->
                    case item_parse:do(Eqm1) of
                        {ok, Eqm3} -> Eqm3;
                        _ -> 
                            ?ERR("守卫洛水名人榜装备列表转换错误"),
                            []
                    end;
                _ -> []
            end;
        {error, _Why2} ->
            ?ERR("守卫洛水累计排行榜外观错误:~w", [_Why2]),
            []
    end,
    R = #role_guard{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, career = Career, lev = Lev, sex = Sex, guild_name = GuildName, looks = Looks2, eqm = Eqm2, kill_npc = KillNpc, kill_boss = KillBoss, point = Point, all_point = AllPoint},
    to_record(T, [R | Rank]).

to_c_record(Rows) ->
    to_c_record(Rows, []).
to_c_record([], Rank) -> Rank;
to_c_record([[_Type, Rid, SrvId, Name, Career, Lev, Sex, GuildName, Looks, Eqm, KillNpc, Point, AllPoint] | T], Rank) ->
    Looks2 = case util:bitstring_to_term(Looks) of
        {ok, Looks1} -> 
            case Looks1 of
                [_|_] -> Looks1;
                _ -> []
            end;
        {error, _Why1} -> 
            ?ERR("洛水反击上一次排行榜外观错误:~w", [_Why1]),
            []
    end,
    Eqm2 = case util:bitstring_to_term(Eqm) of
        {ok, Eqm1} ->
            case Eqm1 of
                [_|_] ->
                    case item_parse:do(Eqm1) of
                        {ok, Eqm3} -> Eqm3;
                        _ -> 
                            ?ERR("洛水反击名人榜装备列表转换错误"),
                            []
                    end;
                _ -> []
            end;
        {error, _Why2} ->
            ?ERR("洛水反击排行榜外观错误:~w", [_Why2]),
            []
    end,
    R = #guard_counter_role{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, career = Career, lev = Lev, sex = Sex, guild_name = GuildName, looks = Looks2, eqm = Eqm2, kill_npc = KillNpc, point = Point, all_point = AllPoint},
    to_c_record(T, [R | Rank]).

to_c_boss(Rows) ->
    to_c_boss(Rows, []).
to_c_boss([], _) -> {};
to_c_boss([[_Type, Rid, SrvId, Name, Career, Lev, Sex, GuildName, Looks, Eqm, _, _, _] | _], []) ->
    Looks2 = case util:bitstring_to_term(Looks) of
        {ok, Looks1} -> 
            case Looks1 of
                [_|_] -> Looks1;
                _ -> []
            end;
        {error, _Why1} -> 
            ?ERR("洛水反击屠魔勇士外观错误:~w", [_Why1]),
            []
    end,
    Eqm2 = case util:bitstring_to_term(Eqm) of
        {ok, Eqm1} ->
            case Eqm1 of
                [_|_] ->
                    case item_parse:do(Eqm1) of
                        {ok, Eqm3} -> Eqm3;
                        _ -> 
                            ?ERR("洛水反击屠魔装备列表转换错误"),
                            []
                    end;
                _ -> []
            end;
        {error, _Why2} ->
            ?ERR("洛水反击屠魔勇士外观错误:~w", [_Why2]),
            []
    end,
    {Rid, SrvId, Name, Career, Lev, Sex, GuildName, Looks2, Eqm2};
to_c_boss([_ | T], B) ->
    to_c_boss(T, B). 

%% ---------------------------
sort_point(#role_guard{point = Point1}, #role_guard{point = Point2}) when Point1 > Point2 -> true;
sort_point(R1 = #role_guard{point = Point}, R2 = #role_guard{point = Point}) ->
    sort_all_point(R1, R2);
sort_point(_, _) -> false.

sort_all_point(#role_guard{all_point = Point1}, #role_guard{all_point = Point2}) when Point1 > Point2 -> true;
sort_all_point(_, _) -> false.

%% ---------------------------
sort_c_point(#guard_counter_role{point = Point1}, #guard_counter_role{point = Point2}) when Point1 > Point2 -> true;
sort_c_point(R1 = #guard_counter_role{point = Point}, R2 = #guard_counter_role{point = Point}) ->
    sort_c_all_point(R1, R2);
sort_c_point(_, _) -> false.

sort_c_all_point(#guard_counter_role{all_point = Point1}, #guard_counter_role{all_point = Point2}) when Point1 > Point2 -> true;
sort_c_all_point(_, _) -> false.
