%%----------------------------------------------------
%% @doc 中庭战神模块
%% 
%% @author shawn 
%% @end
%%----------------------------------------------------
-module(arena_career_dao).

-export([
        get_range/3
        ,get_weakest/3
        ,update/1
        ,save_combat_result/10
        ,sign/2
        ,get_role/2
        ,get_role_info/2
        ,get_role_rank/2
        ,get_role_wins/2
        ,get_award_rank/2
        ,get_hero/0
        ,get_wins_rank/0
        ,get_award_list/0
        ,do_get_rank_role/1
        ,get_max/1
        ,assign_opponents/2
        ,active_award/0
        ,get_next_award_queue/0
        ,fetch_award/1
        ,max_rank/0
        ,get_wins_rank_range/2
        ,save_con_wins/3
        ,get_expedition_partners/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("pet.hrl").
-include("skill.hrl").
-include("vip.hrl").

get_range(Rid, SrvId, LatestWins) ->
    case db:tx(fun() -> do_get_range(Rid, SrvId, LatestWins) end) of
        {ok, RangeRole} when is_list(RangeRole) ->
            lists:reverse(RangeRole);
        _ ->
            ?ERR("Rid:~w, SrvId:~s中庭战神获取角色范围对手出错",[Rid, SrvId]),
            []
    end.

get_hero() ->
    do_get_rank_role(20).

get_wins_rank() ->
    do_get_wins_rank(20).

%% -> null | term()
get_weakest(Rid, SrvId, LatestWins) ->
    case db:tx(fun() -> do_get_weakest(Rid, SrvId, LatestWins) end) of
        {ok, Role} when is_list(Role) ->
            Role;
        Else ->
            ?ERR("Rid:~w, SrvId:~s中庭战神获取角色范围对手出错 ~p : ~p",[Rid, SrvId, Else, erlang:get_stacktrace()]),
            null
    end.

get_award_list() ->
    do_get_award().

update({Rid, SrvId, Name, Career, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend}) ->
    Sql = <<"update sys_arena_career set name = ~s, sex = ~s, lev = ~s, face = ~s, hp_max = ~s, mp_max = ~s, attr = ~s, looks = ~s, eqm = ~s, pet_bag = ~s, skill = ~s, fight_capacity = ~s, ascend = ~s where rid = ~s and srv_id = ~s and career = ~s">>,
    case db:execute(Sql, [Name, Sex, Lev, Face, HpMax, MpMax, util:term_to_bitstring(Attr), util:term_to_bitstring(Looks), util:term_to_bitstring(Eqm), util:term_to_bitstring(PetBag#pet_bag{pets = []}), util:term_to_bitstring(Skill), FightCapacity, util:term_to_bitstring(Ascend), Rid, SrvId, Career]) of
        {ok, _Result} -> ok;
        Err ->
            ?ERR("更新角色Rid:~w,srv_id:~s中庭战神数据出错:原因:~w",[Rid, SrvId, Err])
    end.

save_combat_result(FromRid, FromSrvId, FromRank, FromCareer, FromWins, ToRid, ToSrvId, ToRank, ToCareer, ToWins) ->
    case db:tx(fun() -> do_save_result(FromRid, FromSrvId, FromRank, FromCareer, FromWins, ToRid, ToSrvId, ToRank, ToCareer, ToWins) end) of
        {ok, true} -> ok;
        _ ->
            ?ERR("更新中庭战神排名出错FromRid:~w, FromSrvId:~s, FromRank:~w, FromWins:~w, ToRid:~w, ToSrvId:~s, ToRank:~w, ToWins:~w",[FromRid, FromSrvId, FromRank, FromWins, ToRid, ToSrvId, ToRank, ToWins])
    end.

sign(RankId, #role{id = {Rid, SrvId}, name = Name, vip = #vip{portrait_id = Face}, eqm = Eqm, looks = Looks, sex = Sex, lev = Lev, pet = PetBag, hp_max = HpMax, mp_max = MpMax, attr = Attr = #attr{fight_capacity = FightCapacity}, career = Career, skill = Skill, ascend = Ascend}) ->
    Sql = <<"insert into sys_arena_career (rid, srv_id, name, career, rank, sex, lev, face, hp_max, mp_max, attr, looks, eqm, pet_bag, skill, fight_capacity, ascend, last_sign_time) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [Rid, SrvId, Name, Career, RankId, Sex, Lev, Face, HpMax, MpMax, util:term_to_bitstring(Attr), util:term_to_bitstring(Looks), util:term_to_bitstring(Eqm), util:term_to_bitstring(PetBag#pet_bag{pets = []}), util:term_to_bitstring(Skill), FightCapacity, util:term_to_bitstring(Ascend), util:unixtime()]) of
        {ok, _} -> true;
        _Err ->
            ?ERR("角色中庭战神注册失败,原因:~w",[_Err]),
            false
    end.

get_role(Rid, SrvId) ->
    Sql = <<"select * from sys_arena_career where rid = ~s and srv_id = ~s">>,
    case db:get_row(Sql, [Rid, SrvId]) of
        {ok, [Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend, ConWins, AwardRank, MaxConWins, LastSignTime]} ->
            Arole = arena_career:to_arena_role(Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend, ConWins, AwardRank, MaxConWins, LastSignTime),
            {true, Arole};
        {error, undefined} ->
            undefined;
        _X ->
            ?ERR("查询角色信息出错,Reason:~w",[_X]),
            false
    end.

get_role_info(Rid, SrvId) ->
    Sql = <<"select * from sys_arena_career where rid = ~s and srv_id = ~s">>,
    case db:get_row(Sql, [Rid, SrvId]) of
        {ok, [Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend]} ->
            {true, to_c_role([Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend])};
        {error, undefined} ->
            undefined;
        _X ->
            ?ERR("查询角色信息出错,Reason:~w",[_X]),
            false
    end.

get_role_rank(Rid, SrvId) ->
    Sql = <<"select rank from sys_arena_career where rid = ~s and srv_id = ~s LIMIT 1">>,
    case db:get_row(Sql, [Rid, SrvId]) of
        {ok, [Rank]} when is_integer(Rank) ->
            Rank;
        _X ->
            ?ERR("查询角色排名出错:Reason:~w",[_X]),
            false
    end.

%% 获取连胜次数
get_role_wins(Rid, SrvId) ->
    Sql = <<"select con_wins from sys_arena_career where rid = ~s and srv_id = ~s LIMIT 1">>,
    case db:get_row(Sql, [Rid, SrvId]) of
        {ok, [Wins]} when is_integer(Wins) ->
            Wins;
        _X ->
            ?ERR("查询角色连胜次数出错:Reason:~w",[_X]),
            false
    end.

get_award_rank(Rid, SrvId) ->
    Sql = <<"select award_rank, rank from sys_arena_career where rid = ~s and srv_id = ~s LIMIT 1">>,
    case db:get_row(Sql, [Rid, SrvId]) of
        {ok, [AwardRank, Rank]} when is_integer(Rank) ->
            {AwardRank, Rank};
        _X ->
            ?ERR("查询角色排名出错:Reason:~w",[_X]),
            false
    end.

save_con_wins(RoleId, SrvId, ConWins) ->
    Sql = <<"update sys_arena_career set con_wins = ~s, max_con_wins = GREATEST(~s, max_con_wins)  where rid = ~s and srv_id = ~s">>,
    case db:execute(Sql, [ConWins, ConWins, RoleId, SrvId]) of
        {ok, _} ->
            true;
        _Err ->
            ?ERR("更新中庭战神连胜~p, ~p, ~p失败: ~p, ", [RoleId, SrvId, ConWins, _Err]),
            false
    end.

%% -------------------------------------
do_save_result(FromRid, FromSrvId, FromRank, FromCareer, FromWins, ToRid, ToSrvId, ToRank, ToCareer, ToWins) ->
    Sql = <<"update sys_arena_career set rank = ~s, con_wins = ~s, max_con_wins = GREATEST(~s, max_con_wins) where rid = ~s and srv_id = ~s and career = ~s">>,
    case db:execute(Sql, [FromRank, FromWins, FromWins, FromRid, FromSrvId, FromCareer]) of
        {ok, _} ->
            case db:execute(Sql, [ToRank, ToWins, ToWins, ToRid, ToSrvId, ToCareer]) of
                {ok, _} ->
                    true;
                _Err ->
                    ?ERR("更新中庭战神战斗结果失败ToRid:~w, ToSrvId:~s, ToRank:~w, ToCareer:~w",[ToRid, ToSrvId, ToRank, ToCareer]),
                    false
            end;
        _Err ->
            ?ERR("更新中庭战神战斗结果失败FromRid:~w, FromSrvId:~s, FromRank:~w, FromCareer:~w",[FromRid, FromSrvId, FromRank, FromCareer]),
            false
    end.

do_get_rank_role(Num) ->
    Sql = <<"select rid, srv_id, name, rank, lev, fight_capacity, career from sys_arena_career order by rank limit ~s">>,
    case db:get_all(Sql, [Num]) of
        {ok, Rows} ->
            Rows;
        _X ->
            ?ERR("查询英雄榜出错:Reason:~w",[_X]),
            []
    end.

do_get_wins_rank(Num) ->
    Sql = <<"select rid, srv_id, name, lev, max_con_wins, career from sys_arena_career order by max_con_wins desc, fight_capacity asc limit ~s">>,
    case db:get_all(Sql, [Num]) of
        {ok, Rows} ->
            {NewRows, _} = lists:mapfoldl(fun([Rid, SrvId, Name, Lev, ConWins, Career], Rank) -> 
                    {[Rid, SrvId, Name, Rank, Lev, ConWins, Career], Rank + 1}
            end, 1, Rows),
            NewRows;
        _X ->
            ?ERR("查询英雄榜出错:Reason:~w",[_X]),
            []
    end.


get_max(Career) ->
    Sql = <<"select rid, srv_id from sys_arena_career where rank = 1 and career = ~s">>,
    case db:get_row(Sql, [Career]) of
        {ok, [Rid, SrvId]} ->
            {Rid, SrvId};
        {error, undefined} ->
            false;
        _X ->
            ?ERR("查询首席弟子出错:Reason:~w",[_X]),
            false 
    end.

do_get_award() ->
    Sql = <<"select rid, srv_id, rank, lev from sys_arena_career where rank >= 1 and rank <= 100">>,
    case db:get_all(Sql, []) of
        {ok, Rows} ->
            to_award(Rows);
        _X ->
            ?ERR("查询奖励列表出错:Reason:~w",[_X]),
            []
    end.

do_get_range(Rid, SrvId, LatestWins) ->
    Sql1 = <<"select rank from sys_arena_career where rid = ~s and srv_id = ~s">>,
    Result = case db:get_row(Sql1, [Rid, SrvId]) of
        {ok, [Rank]} when Rank =<6 ->
            Sql2 = <<"select * from sys_arena_career where rank<>~s order by rank asc limit 5">>,
            db:get_all(Sql2, [Rank]);
        {ok, [Rank]} ->
            [R1, R2, R3, R4, R5] = assign_opponents(Rank, LatestWins),
            Sql4 = <<"select * from sys_arena_career where (rank = ~s or rank = ~s or rank = ~s or rank = ~s or rank = ~s) order by rank asc">>,
            db:get_all(Sql4, [R1, R2, R3, R4, R5]);
        _X -> 
            ?ERR("无法查询该角色排名,Reason:~w",[_X]),
            _X
    end,
    case Result of
        {ok, Rows2} when is_list(Rows2) ->
            lists:reverse(Rows2);
        _ ->
            ?ERR("查询角色周围排名出错,Reason:~w",[Result]),
            []
    end.

do_get_weakest(Rid, SrvId, LatestWins) ->
    Sql1 = <<"select rank from sys_arena_career where rid = ~s and srv_id = ~s limit 1">>,
    Result = case db:get_row(Sql1, [Rid, SrvId]) of
        {ok, [Rank]} when Rank =< 6 ->
            Sql2 = <<"select * from (select * from sys_arena_career where rank<>~s order by rank limit 5) as x order by fight_capacity limit 1">>,
            db:get_row(Sql2, [Rank]);
        {ok, [Rank]} ->
            [Rank1|_] = assign_opponents(Rank, LatestWins),
            Sql2 = <<"select * from (select * from sys_arena_career where rank<~s and rank>=~s order by rank) as x order by fight_capacity limit 1">>,
            db:get_row(Sql2, [Rank, Rank1]);
        _X -> 
            ?ERR("无法查询该角色排名,Reason:~w",[_X]),
            _X
    end,
    case Result of
        {ok, Row} ->
            Row;
        _ ->
            ?ERR("查询角色周围排名出错,Reason:~w",[Result]),
            null
    end.


%% 从列表中取出M个项
% get_rand_rank(N, M) when N >= 1001 ->
%     do_get_rand_rank(M, lists:seq(N - 100, N - 1));
% get_rand_rank(N, M) when N >= 501 andalso N =< 1000 ->
%     do_get_rand_rank(M, lists:seq(N - 80, N - 1));
% get_rand_rank(N, M) when N >= 301 andalso N =< 500 ->
%     do_get_rand_rank(M, lists:seq(N - 50, N - 1));
% get_rand_rank(N, M) when N >= 201 andalso N =< 300 ->
%     do_get_rand_rank(M, lists:seq(N - 30, N - 1));
% get_rand_rank(N, M) when N >= 101 andalso N =< 200 ->
%     do_get_rand_rank(M, lists:seq(N - 15, N - 1)).
% 
% do_get_rand_rank(M, List) ->
%     do_get_rand_rank(M, List, []).
% do_get_rand_rank(0, _List, GetList) -> GetList;
% do_get_rand_rank(M, List, GetList) ->
%     G = util:rand_list(List),
%     do_get_rand_rank(M - 1, List -- [G], [G | GetList]).

assign_opponents(Rank, LatestWins) ->
    do_assign_opponents(Rank, LatestWins, 5, []).   

do_assign_opponents(_Rank, _LatestWins, 0, Ret) ->
    Ret;
do_assign_opponents(Rank, LatestWins, Num, Ret) ->
    Rank0 = Rank - arena_career_range_data:get(Rank, LatestWins),
    do_assign_opponents(Rank0, LatestWins, Num - 1, [Rank0 | Ret]).


to_award(Award) ->
    to_award(Award, []).
to_award([], NewAward) -> NewAward;
to_award([[Rid, SrvId, Rank, Lev] | T], NewAward) ->
    to_award(T, [{Rid, SrvId, Rank, Lev, ?false} | NewAward]).

to_c_role([Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend]) -> 
    Looks2 = case util:bitstring_to_term(Looks) of
        {ok, Looks1} -> 
            case Looks1 of
                [_|_] -> Looks1;
                _ -> []
            end;
        {error, _Why1} -> 
            ?ERR("中庭战神获取外观出错:~w", [_Why1]),
            []
    end,
    Eqm2 = case util:bitstring_to_term(Eqm) of
        {ok, Eqm1} ->
            case Eqm1 of
                [_|_] ->
                    case item_parse:do(Eqm1) of
                        {ok, Eqm3} -> Eqm3;
                        _ -> 
                            ?ERR("中庭战神装备列表转换错误"),
                            []
                    end;
                _ -> []
            end;
        {error, _Why2} ->
            ?ERR("中庭战神获取装备列表错误:~w", [_Why2]),
            []
    end,
    Attr2 = case util:bitstring_to_term(Attr) of
        {ok, Attr1} ->
            role_attr:ver_parse(Attr1);
        _Why3 ->
            ?ERR("中庭战神获取角色属性出错:~w",[_Why3]),
            #attr{}
    end,
    PetBag2 = case util:bitstring_to_term(PetBag) of
        {ok, PetBag1} ->
            case pet_parse:do(PetBag1) of
                {ok, NewPetPag1} -> 
                    NewPetPag1;
                _ ->
                    ?ERR("宠物数据版本转换失败"),
                    #pet_bag{}
            end;
        _Why4 ->
            ?ERR("中庭战神获取宠物背包出错:~w",[_Why4]),
            #pet_bag{}
    end,
    Skill2 = case util:bitstring_to_term(Skill) of
        {ok, Skill1} ->
            case skill:ver_parse_2(Skill1) of
                NewSkill when is_record(NewSkill, skill_all) ->
                    NewSkill;
                _Why6 ->
                    ?ERR("中庭战神获取技能出错:~w",[_Why6]),
                    #skill_all{}
            end;
        _Why5 ->
            ?ERR("中庭战神获取技能出错:~w",[_Why5]),
            #skill_all{}
    end,
    NewAscend = case util:bitstring_to_term(Ascend) of
        {ok, CA} -> ascend:ver_parse(CA);
        _ -> ascend:init()
    end,
    {Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr2, Looks2, Eqm2, PetBag2, Skill2, FightCapacity, NewAscend}.

active_award() ->
    TimeBefore15Days = util:unixtime() - 15*86400,
    db:execute(?DB_SYS, "UPDATE sys_arena_career SET award_rank=0"),  %% 只发给最15天有登录的
    db:execute(?DB_SYS, "UPDATE sys_arena_career SET award_rank=rank WHERE last_sign_time >= ~s", [TimeBefore15Days]).

get_next_award_queue() ->
    db:get_all("SELECT `rid`, `srv_id`, `award_rank` FROM `sys_arena_career` WHERE award_rank > 0 LIMIT 20").

%% -> true | false
fetch_award({RoleId, SrvId}) ->
    case db:execute("UPDATE sys_arena_career SET award_rank=0 WHERE rid=~s AND srv_id=~s LIMIT 1", [RoleId, SrvId]) of
        {ok, Affected} when Affected > 0 ->
            true;
        _ ->
            false
    end.

max_rank() ->
    db:get_one("SELECT IFNULL(max(rank), 0) FROM sys_arena_career").

get_wins_rank_range(FromRank, ToRank) ->
    db:get_all("SELECT `rid`, `srv_id` FROM `sys_arena_career` ORDER BY `max_con_wins` DESC LIMIT ~s, ~s", [FromRank, ToRank-FromRank+1]).

get_expedition_partners(Rank) ->
    MaxRank = case arena_career_mgr:max_rank() of
        _MaxRank when _MaxRank > 0 -> _MaxRank;    
        _ -> Rank
    end,
    Min = erlang:max(1, Rank - 10),
    Max = erlang:min(MaxRank, Rank + 10),
    Allow = lists:seq(Min, Max) -- [Rank],
    Ranks = util:rand_list(Allow, 2),
    case Ranks of
        [] -> [];
        [Rank1] ->
            Sql = <<"select * from sys_arena_career where rank=~s LIMIT 1">>,
            case db:get_all(Sql, [Rank1]) of
                {ok, List} ->
                    ?DUMP(List),
                    List;
                _Else ->
                    [] 
            end;
        [Rank1, Rank2] ->
            Sql = <<"select * from sys_arena_career where (rank=~s OR rank=~s) LIMIT 2">>,
            case db:get_all(Sql, [Rank1, Rank2]) of
                {ok, List} ->
                    ?DUMP(List),
                    List;
                _Else ->
                    [] 
            end;
        _ ->
            []
    end.
