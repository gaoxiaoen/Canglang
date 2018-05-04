%% --------------------------------------------------------------------
%% 跨服师门竞技 
%% @author shawn 
%% --------------------------------------------------------------------
-module(c_arena_career).
-export([
        get_role/3
        ,pack_msg/2
        ,pack_join_rank_to_all/2
        ,convert/1
        ,query_join_data/1
    ]
).

-include("role.hrl").
-include("common.hrl").
-include("arena_career.hrl").
-include("pet.hrl").
-include("skill.hrl").

%% 获取角色信息
get_role(Rid, SrvId, Career) ->
    case c_arena_career_dao:get_role(Rid, SrvId, Career) of
        {true, Arole} -> Arole;
        _ -> false
    end.

%% 请求跨服角色数据
query_join_data(SrvIds) ->
    query_join_data(SrvIds, []).
query_join_data([], JoinRole) ->
    [{Rid, SrvId, Career, Name} || #c_arena_career_role{rid = Rid, srv_id = SrvId, career = Career, name = Name} <- JoinRole];
query_join_data([SrvId | T], JoinRole) ->
    GetSrvId = list_to_bitstring(SrvId),
    RankMs = [{
            #c_arena_career_role{srv_id = GetSrvId, _ = '_'},
            [],
            ['$_']
        }],
    Role = ets:select(c_arena_career_rank, RankMs),
    query_join_data(T, Role ++ JoinRole).

pack_join_rank_to_all([], _AwardTime) -> ok;
pack_join_rank_to_all([{SrvId, Data} | T], AwardTime) ->
    Zhenwu = {?career_zhenwu, [{Rid, SrvId1, Career, Name} || {Rid, SrvId1, Name, Career, _, _, _, _, _, _, _, _, _, _, _, _, _} <- Data, Career =:= ?career_zhenwu]},
    Meiying = {?career_cike, [{Rid, SrvId1, Career, Name} || {Rid, SrvId1, Name, Career, _, _, _, _, _, _, _, _, _, _, _, _, _} <- Data, Career =:= ?career_cike]},
    Tianshi = {?career_xianzhe, [{Rid, SrvId1, Career, Name} || {Rid, SrvId1, Name, Career, _, _, _, _, _, _, _, _, _, _, _, _, _} <- Data, Career =:= ?career_xianzhe]},
    Tianzun = {?career_qishi, [{Rid, SrvId1, Career, Name} || {Rid, SrvId1, Name, Career, _, _, _, _, _, _, _, _, _, _, _, _, _} <- Data, Career =:= ?career_qishi]},
    Feiyu = {?career_feiyu, [{Rid, SrvId1, Career, Name} || {Rid, SrvId1, Name, Career, _, _, _, _, _, _, _, _, _, _, _, _, _} <- Data, Career =:= ?career_feiyu]},
    Msg = [Zhenwu, Meiying, Tianshi, Tianzun, Feiyu],
    pack_msg(SrvId, {join_data, Msg, AwardTime}),
    pack_join_rank_to_all(T, AwardTime).

%% 发送消息给平台
pack_msg(SrvId, Msg) ->
    c_mirror_group:cast(node, SrvId, arena_career_mgr, async_apply, [Msg]).

convert({c_arena_career_role, Id, Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, Hp, Mp, Hpmax, MpMax, Attr, Looks, Eqm, PetBag, Skill, Fightcapacity}) ->
    convert({c_arena_career_role, Id, Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, Hp, Mp, Hpmax, MpMax, Attr, Looks, Eqm, PetBag, Skill, Fightcapacity, ascend:init()});
convert(Crole = #c_arena_career_role{eqm = Eqm, pet_bag = PetBag, skill = Skill, ascend = Ascend, attr = Attr}) ->
    Eqm2 = case Eqm of
        [_|_] ->
            case item_parse:do(Eqm) of
                {ok, Eqm1} -> Eqm1;
                _ -> 
                    ?ERR("跨服师门竞技装备列表转换错误"),
                    []
            end;
        _ -> []
    end,
    PetBag2 = case pet_parse:do(PetBag) of
        {ok, NewPetPag1} -> 
            NewPetPag1;
        _ ->
            ?ERR("宠物数据版本转换失败"),
            #pet_bag{}
    end,
    Skill2 = case skill:ver_parse_2(Skill) of
        NewSkill when is_record(NewSkill, skill_all) ->
            NewSkill;
        _ ->
            ?ERR("跨服师门竞技技能转换错误"),
            #skill_all{}
    end,
    NewAscend = ascend:ver_parse(Ascend),
    Attr1 = role_attr:ver_parse(Attr),
    Crole#c_arena_career_role{eqm = Eqm2, pet_bag = PetBag2, skill = Skill2, ascend = NewAscend, attr = Attr1}.
