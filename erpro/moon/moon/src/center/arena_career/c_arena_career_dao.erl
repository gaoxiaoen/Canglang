%%----------------------------------------------------
%% @doc 跨服师门竞技模块
%% 
%% @author shawn 
%% @end
%%----------------------------------------------------
-module(c_arena_career_dao).
-export([
        get_role/3
        ,do_update_role/1
        ,save_combat_result/8
        ,get_role_rank/3
        ,get_role_info/3
        ,get_range/3
        ,get_cross_hero/0
        ,sign/1
        ,update_role/2
        ,get_rand_rank/2
    ]
).

-include("common.hrl").
-include("pet.hrl").
-include("arena_career.hrl").

%% 获取周围对手
get_range(Rid, SrvId, Career) ->
    %% ?DEBUG("Rid:~w, SrvId:~w",[Rid, SrvId]),
    RangeRole = do_get_range(Rid, SrvId, Career),
    %%to_show(RangeRole),
    RangeRole.

%% 获取英雄榜
get_cross_hero() ->
    RankMs = [{
            #c_arena_career_role{rank = '$1', _ = '_'},
            [{'andalso', {'>=', '$1', 1}, {'=<', '$1', 100}}],
            ['$_']
        }],
    L = ets:select(c_arena_career_rank, RankMs),
    [{Rank, Rid, SrvId, Name, Lev, FightCapacity, Career} || #c_arena_career_role{id = {Rid, SrvId, _}, name = Name, lev = Lev, rank = Rank, fight_capacity =FightCapacity, career = Career} <- L].

%% 开始注册
sign(Data) ->
    case do_sign(Data) of
        ok -> ok;
        _X -> 
            ?ERR("_X:~w",[_X]),
            false
    end.

%% 获取角色数据
get_role(Rid, SrvId, Career) ->
    case ets:lookup(c_arena_career_rank, {Rid, SrvId, Career}) of
        [CRole] when is_record(CRole, c_arena_career_role) ->
            {true, CRole};
        _X ->
            ?ERR("查询角色信息出错,Reason:~w",[_X]),
            false
    end.

%% 更新角色数据
do_update_role({Rid, SrvId, Name, Career, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend}) ->
    case ets:lookup(c_arena_career_rank, {Rid, SrvId, Career}) of
        [R] when is_record(R, c_arena_career_role) ->
            NewR = R#c_arena_career_role{id = {Rid, SrvId, Career}, rid = Rid, srv_id = SrvId, name = Name, sex = Sex, lev = Lev, face = Face, hp_max = HpMax, mp_max = MpMax, attr = Attr, looks = Looks, eqm = Eqm, pet_bag = PetBag, skill = Skill, fight_capacity = FightCapacity, ascend = Ascend},
            update_role(all, NewR);
        _X ->
            ?ERR("更新角色信息出错,ToRid:~w, ToSrvId:~s, Reason:~w",[Rid, SrvId, _X])
    end;
do_update_role(_) ->
    ?DEBUG("收到未知的更新角色消息"),
    skip.

%% 存储战斗结果
save_combat_result(FromRid, FromSrvId, FromCareer, FromRank, ToRid, ToSrvId, ToCareer, ToRank) ->
    case ets:lookup(c_arena_career_rank, {FromRid, FromSrvId, FromCareer}) of
        [FromRole] when is_record(FromRole, c_arena_career_role) ->
            case ets:lookup(c_arena_career_rank, {ToRid, ToSrvId, ToCareer}) of
                [ToRole] when is_record(ToRole, c_arena_career_role) ->
                    NewFromRole = FromRole#c_arena_career_role{rank = FromRank},
                    NewToRole = ToRole#c_arena_career_role{rank = ToRank},
                    update_role(all, NewFromRole),
                    update_role(all, NewToRole);
                _X ->
                    ?ERR("查询角色信息出错,ToRid:~w, ToSrvId:~s, ToCareer:~w Reason:~w",[ToRid, ToSrvId, ToCareer, _X]),
                    false
            end;
        _X ->
            ?ERR("查询角色信息出错,FromRid:~w, FromSrvId:~s, FromCareer:~w, Reason:~w",[FromRid, FromSrvId, FromCareer, _X]),
            false
    end.

%%  更新角色数据
update_role(all, Crole) ->
    ets:insert(c_arena_career_rank, Crole),
    dets:insert(c_arena_career_rank, Crole);

update_role(ets, Crole) ->
    ets:insert(c_arena_career_rank, Crole),
    dets:insert(c_arena_career_rank, Crole);

update_role(dets, Crole) ->
    ets:insert(c_arena_career_rank, Crole),
    dets:insert(c_arena_career_rank, Crole).

%% 获取角色排名
get_role_rank(Rid, SrvId, Career) ->
    case ets:lookup(c_arena_career_rank, {Rid, SrvId, Career}) of
        [#c_arena_career_role{rank = Rank}] ->
            Rank;
        [] ->
            ?DEBUG("该角色不存在"),
            false;
        _X ->
            ?ERR("查询角色排名出错:Reason:~w",[_X]),
            false
    end.

%% 获取角色部分信息
get_role_info(Rid, SrvId, Career) ->
    case ets:lookup(c_arena_career_rank, {Rid, SrvId, Career}) of
        [#c_arena_career_role{rank = Rank, lev = Lev}] ->
            {Rank, Lev};
        [] ->
            ?DEBUG("该角色不存在"),
            false;
        _X ->
            ?ERR("查询角色排名出错:Reason:~w",[_X]),
            false
    end.


%% ---------------------
%% 内部处理
%% --------------------
do_sign([]) -> ok;
do_sign([H | T]) ->
    do_sign(H),
    do_sign(T);

do_sign({Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend}) ->
    R = #c_arena_career_role{id = {Rid, SrvId, Career}, rid = Rid, srv_id = SrvId, name =Name, career = Career, rank = Rank, sex = Sex, lev = Lev, face = Face, hp_max = HpMax, mp_max = MpMax, attr = Attr, looks = Looks, eqm = Eqm, pet_bag = PetBag, skill = Skill, fight_capacity = FightCapacity, ascend = Ascend},
    update_role(all, R).

do_get_range(Rid, SrvId, Career) ->
    case ets:lookup(c_arena_career_rank, {Rid, SrvId, Career}) of
        [#c_arena_career_role{rank = 1}] ->
            RankMs = [{
                    #c_arena_career_role{rank = '$1', _ = '_'},
                    [{'andalso', {'>=', '$1', 2}, {'=<', '$1', 5}}],
                    ['$_']
                }],
            ets:select(c_arena_career_rank, RankMs);
        [#c_arena_career_role{rank = 2}] ->
            RankMs = [{
                    #c_arena_career_role{rank = '$1', _ = '_'},
                    [{'orelse',
                            {'andalso', {'>=', '$1', 3}, {'=<', '$1', 5}},
                            {'andalso', {'=:=', '$1', 1}}}],
                    ['$_']
                }],
            ets:select(c_arena_career_rank, RankMs);
        [#c_arena_career_role{rank = 3}] ->
            RankMs = [{
                    #c_arena_career_role{rank = '$1', _ = '_'},
                    [{'orelse',
                            {'andalso', {'>=', '$1', 4}, {'=<', '$1', 5}},
                            {'andalso', {'>=', '$1', 1}, {'=<', '$1', 2}}}],
                    ['$_']
                }],
            ets:select(c_arena_career_rank, RankMs);
        [#c_arena_career_role{rank = 4}] ->
            RankMs = [{
                    #c_arena_career_role{rank = '$1', _ = '_'},
                    [{'orelse',
                            {'andalso', {'=:=', '$1', 5}},
                            {'andalso', {'>=', '$1', 1}, {'=<', '$1', 3}}}],
                    ['$_']
                }],
            ets:select(c_arena_career_rank, RankMs);
        [#c_arena_career_role{rank = Rank}] when Rank =< 100 ->
            RankMs = [{
                    #c_arena_career_role{rank = '$1', _ = '_'},
                    [{'andalso', {'>=', '$1', Rank - 4}, {'=<', '$1', Rank - 1}}],
                    ['$_']
                }],
            ets:select(c_arena_career_rank, RankMs);
        [#c_arena_career_role{rank = Rank}] ->
            [R1, R2, R3, R4] = case get_rand_rank(Rank, 4) of
                [R11, R12, R13, R14] -> [R11, R12, R13, R14];
                _ -> [Rank - 1, Rank - 2, Rank - 3, Rank - 4]
            end,
            RankMs = [{
                    #c_arena_career_role{rank = '$1', _ = '_'},
                    [{'orelse', {'=:=', '$1', R1}, {'=:=', '$1', R2}, {'=:=', '$1', R3},
                            {'=:=', '$1', R4}}],
                    ['$_']
                }],
            ets:select(c_arena_career_rank, RankMs);
        _X -> 
            ?ERR("无法查询该角色排名,Reason:~w",[_X]),
            []
    end.

%% 从列表中取出M个项
get_rand_rank(N, M) when N >= 3001 ->
    do_get_rand_rank(M, lists:seq(2800, 3000));
get_rand_rank(N, M) when N >= 1501 andalso N =< 3000 ->
    do_get_rand_rank(M, lists:seq(N - 150, N - 1));
get_rand_rank(N, M) when N >= 1001 andalso N =< 1500 ->
    do_get_rand_rank(M, lists:seq(N - 100, N - 1));
get_rand_rank(N, M) when N >= 501 andalso N =< 1000 ->
    do_get_rand_rank(M, lists:seq(N - 80, N - 1));
get_rand_rank(N, M) when N >= 301 andalso N =< 500 ->
    do_get_rand_rank(M, lists:seq(N - 50, N - 1));
get_rand_rank(N, M) when N >= 201 andalso N =< 300 ->
    do_get_rand_rank(M, lists:seq(N - 30, N - 1));
get_rand_rank(N, M) when N >= 101 andalso N =< 200 ->
    do_get_rand_rank(M, lists:seq(N - 15, N - 1)).

do_get_rand_rank(M, List) ->
    do_get_rand_rank(M, List, []).
do_get_rand_rank(0, _List, GetList) -> GetList;
do_get_rand_rank(M, List, GetList) ->
    G = util:rand_list(List),
    do_get_rand_rank(M - 1, List -- [G], [G | GetList]).

%%to_show([]) -> ok;
%%to_show([#c_arena_career_role{rid = _Rid, srv_id = _SrvId, sex = _Sex, lev = _Lev, fight_capacity = _FightCapacity, name = _Name, rank = _Rank} | T]) ->
%%    ?DEBUG("Rid:~w,SrvId:~s,名字:~s,性别:~w,等级:~w,战斗力:~w,排名:~w",[_Rid, _SrvId, _Name, _Sex, _Lev, _FightCapacity, _Rank]),
%%    to_show(T).
