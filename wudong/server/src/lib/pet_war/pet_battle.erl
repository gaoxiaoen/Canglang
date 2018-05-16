%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十一月 2017 18:13
%%%-------------------------------------------------------------------
-module(pet_battle).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("battle.hrl").
-include("pet_war.hrl").
-include("skill.hrl").
-include("pet.hrl").
-include("scene.hrl").

%% API
-export([
    battle_mon/3,
    battle_mon/4
]).

pack_report(AerList, DerList, Winner, ReportList, SumRound) ->
    F = fun(#bs{sign = Sign, key = Key, name = Name, pos = Pos, type_id = TypeId, star = Star, figure = FigureId}) ->
        [Sign, Key, Name, Pos, Star, FigureId, TypeId]
    end,
    ProAerList = lists:map(F, AerList),
    ProDerList = lists:map(F, DerList),
%%     ?DEBUG("~nReportList:~p", [ReportList]),
    {ok, Bin} = pt_443:write(44301, {Winner, SumRound, ProAerList, ProDerList, lists:reverse(ReportList)}),
    Bin.

%% 宠物打怪物
battle_mon(Player, PetList, MonList) ->
    battle_mon(Player, PetList, MonList, ?BATTLE_MAX_ROUND).
battle_mon(Player, PetList, MonList, RoundMax) ->
    NewMonList = init_mon(MonList),
    AerList0 = init_data(PetList),
    DerList0 = init_data(NewMonList),
    AerList = battle_prepare(AerList0, [?TEAM1, ?DIE_TYPE1], []),
    DefList = battle_prepare(DerList0, [?TEAM2, ?DIE_TYPE1], []),
    {Winner, ReportList, SumRound} = battle_loop(Player, AerList, #player{}, DefList, [], 0, RoundMax, []),
    Bin = pack_report(AerList0, DerList0, Winner, ReportList, SumRound),
    {Winner, Bin}.

battle_prepare([], _, AerList) ->
    AerList;
battle_prepare([Aer | L], [WarSign, DieType], AerList) ->
    battle_prepare(L, [WarSign, DieType], [Aer#bs{war_sign = WarSign, die_type = DieType} | AerList]).

init_mon(MonList) ->
    F = fun(Mon, {MonKey, Acc}) ->
        NewMon =
            Mon#base_round_mon{
                key = MonKey,
                hp = Mon#base_round_mon.hp_lim
            },
        {MonKey + 1, [NewMon | Acc]}
    end,
    {_C, NewMonList} = lists:foldl(F, {1, []}, MonList),
    lists:reverse(NewMonList).

init_data(List) ->
    LongTime = util:longunixtime(),
    F = fun(Tuple) ->
        init_data(Tuple, LongTime)
    end,
    lists:map(F, List).

init_data(P, LongTime) ->
    Now = LongTime div 1000, %秒
    BS =
        if
            is_record(P, pet) ->
                #bs{
                    key = P#pet.key,
                    type_id = P#pet.type_id,
                    name = P#pet.name,
                    figure = P#pet.figure,
                    pos = P#pet.war_pos,
                    sign = ?SIGN_PET,
                    skill = P#pet.war_skill,
                    star = P#pet.star,
                    hp_lim = P#pet.attribute#attribute.hp_lim,
                    hp = P#pet.attribute#attribute.hp_lim,
                    mp_lim = P#pet.attribute#attribute.mp_lim,
                    mp = P#pet.attribute#attribute.mp_lim,
                    att = P#pet.attribute#attribute.att,
                    def = P#pet.attribute#attribute.def,
                    dodge = P#pet.attribute#attribute.dodge,
                    crit = P#pet.attribute#attribute.crit,
                    hit = P#pet.attribute#attribute.hit,
                    ten = P#pet.attribute#attribute.ten,
                    crit_inc = P#pet.attribute#attribute.crit_inc,
                    crit_dec = P#pet.attribute#attribute.crit_dec,
                    hurt_inc = P#pet.attribute#attribute.hurt_inc,
                    hurt_dec = P#pet.attribute#attribute.hurt_dec,
                    hp_lim_inc = P#pet.attribute#attribute.hp_lim_inc,
                    pvp_inc = P#pet.attribute#attribute.pvp_inc,
                    pvp_dec = P#pet.attribute#attribute.pvp_dec,
                    recover = P#pet.attribute#attribute.recover,
                    recover_hit = P#pet.attribute#attribute.recover_hit,
                    size = P#pet.attribute#attribute.size,
                    cure = P#pet.attribute#attribute.cure,
                    prepare = P#pet.attribute#attribute.prepare,
                    att_area = P#pet.attribute#attribute.att_area,
                    speed = P#pet.attribute#attribute.speed
                };
            is_record(P, base_round_mon) ->
                #bs{
                    key = P#base_round_mon.key,
                    name = P#base_round_mon.name,
                    type_id = P#base_round_mon.mon_id,
                    figure = P#base_round_mon.image,
                    now = Now,
                    now2 = LongTime,
                    lv = P#base_round_mon.lv,
                    skill = P#base_round_mon.skill,
                    sign = ?SIGN_MON,
                    %% -- 属性
                    hp_lim = P#base_round_mon.hp_lim,
                    hp = P#base_round_mon.hp,
                    mp_lim = P#base_round_mon.mp_lim,
                    mp = P#base_round_mon.mp_lim,
                    att = P#base_round_mon.att,
                    def = P#base_round_mon.def,
                    dodge = P#base_round_mon.dodge,
                    crit = P#base_round_mon.crit,
                    hit = P#base_round_mon.hit,
                    ten = P#base_round_mon.ten,
                    crit_inc = P#base_round_mon.crit_inc,
                    crit_dec = P#base_round_mon.crit_dec,
                    hurt_inc = P#base_round_mon.hurt_inc,
                    hurt_dec = P#base_round_mon.hurt_dec,
                    hp_lim_inc = P#base_round_mon.hp_lim_inc,
                    pvp_inc = P#base_round_mon.pvp_inc,
                    pvp_dec = P#base_round_mon.pvp_dec,
                    speed = P#base_round_mon.speed,
                    base_speed = P#base_round_mon.speed,
                    %% --
                    mana_lim = P#base_round_mon.mana_lim,
                    mana = P#base_round_mon.mana,
                    pos = P#base_round_mon.war_pos
                };
            true ->
                #bs{}
        end,
    buff:buff_to_eff(BS, BS#bs.buff_list).

new_round_order(AerList, DerList) ->
    List1 = lists:keysort(#bs.pos, AerList),
    List2 = lists:keysort(#bs.pos, DerList),
    KeyList1 = lists:map(fun(#bs{key = Key}) -> Key end, List1),
    KeyList2 = lists:map(fun(#bs{key = Key}) -> Key end, List2),
    new_round_order(KeyList1, KeyList2, []).

new_round_order([], [], AccList) ->
    AccList;
new_round_order(L, [], AccList) ->
    AccList ++ L;
new_round_order([], L, AccList) ->
    AccList ++ L;
new_round_order([H1 | T1], [H2 | T2], AccList) ->
    new_round_order(T1, T2, AccList ++ [H1, H2]).

init_round_data(BsList) ->
    F = fun(Bs) -> Bs#bs{state_list = []} end,
    lists:map(F, BsList).

%% 打平
battle_loop(_AerPlayer, [], _DerPlayer, [], _RoundList, _Round, RoundMax, ReportList) ->
    {0, ReportList, RoundMax};

%% 攻击方全败
battle_loop(_AerPlayer, [], _DerPlayer, DerList, _RoundList, _Round, RoundMax, ReportList) ->
    Winner = hd(DerList),
    {Winner#bs.war_sign, ReportList, RoundMax};

%% 防御方全败
battle_loop(_AerPlayer, AerList, _DerPlayer, [], _RoundList, _Round, RoundMax, ReportList) ->
    Winner = hd(AerList),
    {Winner#bs.war_sign, ReportList, RoundMax};

%% 新的一轮
battle_loop(AerPlayer, AerList, DerPlayer, DerList, [], Round, RoundMax, ReportList) ->
    RoundList = new_round_order(AerList, DerList),
    NewAerList = init_round_data(AerList),
    NewDerList = init_round_data(DerList),
    battle_loop(AerPlayer, NewAerList, DerPlayer, NewDerList, RoundList, Round + 1, RoundMax, ReportList);

%% 回合出手
battle_loop(AerPlayer, AerList, DerPlayer, DerList, [Key | RoundList], Round, RoundMax, ReportList) when Round =< RoundMax ->
    case exist_alive(AerList, DerList) of
        {false, a_die} ->
            battle_loop(AerPlayer, [], DerPlayer, DerList, RoundList, Round, RoundMax, ReportList);
        {false, d_die} ->
            battle_loop(AerPlayer, AerList, DerPlayer, [], RoundList, Round, RoundMax, ReportList);
        true ->
            case lists:keyfind(Key, #bs.key, lists:merge(AerList, DerList)) of
                false ->
                    battle_loop(AerPlayer, AerList, DerPlayer, DerList, RoundList, Round, RoundMax, ReportList);
                Aer when Aer#bs.hp > 0 ->
                    {AerList2, DerList2, AddReprot} = do_battle(Aer, AerList, DerList, Round),
                    battle_loop(AerPlayer, AerList2, DerPlayer, DerList2, RoundList, Round, RoundMax, [AddReprot | ReportList]);
                _ ->
                    battle_loop(AerPlayer, AerList, DerPlayer, DerList, RoundList, Round, RoundMax, ReportList)
            end
    end;

%% 回合结束 防守方胜
battle_loop(_AerPlayer, _AerList, _DerPlayer, _DerList, _RoundList, Round, RoundMax, ReportList) when Round >= RoundMax + 1 ->
    {0, ReportList, RoundMax}.

%%判断是否某一方的玩家已经全部死亡
exist_alive(AerList, DerList) ->
    AerLen = length([BS || BS <- AerList, BS#bs.hp > 0]),
    DerLen = length([BS || BS <- DerList, BS#bs.hp > 0]),
    case AerLen == 0 of
        true -> {false, a_die};
        false ->
            case DerLen == 0 of
                true -> {false, d_die};
                false -> true
            end
    end.

do_battle(Aer, AerList, DerList, Round) ->
    case check_do_battle(Aer) of
        {dizzy, Aer0} ->
            {AerList1, DerList1} = update_user(Aer0, AerList, DerList),
            AerListState = get_state_list(Aer0, AerList1++DerList1),
            {AerList1, DerList1, [Round, Aer0#bs.key, max(0, Aer#bs.hp - Aer0#bs.hp), Aer0#bs.hp, Aer0#bs.hp_lim, Aer0#bs.rage, ?RAGE_LIM, 0, AerListState, []]};
        {true, Aer00} ->
            case check_use_skill(Aer00) of
                false ->
                    Der = get_target(Aer, AerList, DerList),
                    {Aer0, Der0, Hurt} = cale_hurt(Aer, Der, #skill{}),
                    {AerList1, DerList1} = update_user(Aer0, AerList, DerList),
                    {AerList2, DerList2} = update_user(Der0, AerList1, DerList1),
                    AerListState = get_state_list(Aer0, AerList2++DerList2),
                    Report = [Round, Aer0#bs.key, max(Aer#bs.hp - Aer0#bs.hp, 0), Aer0#bs.hp, Aer0#bs.hp_lim, Aer0#bs.rage, ?RAGE_LIM, 0, AerListState, [get_der_info_report(Der0, Hurt)]],
                    {AerList2, DerList2, Report};
                {NewAer, Skill} ->
                    TargetDerList = get_skill_target(NewAer, Skill#skill.att_type, AerList, DerList),
                    {NewAer0, AerList0, DerList0, TargetDerList0} = use_skill(NewAer, AerList, DerList, Skill, TargetDerList),
                    F = fun(Target, {AccAer, AccAerList, AccDerList, AccDerReportList}) ->
                        {Aer0, Der0, Hurt} = cale_hurt(AccAer, Target, Skill),
                        Der1 = pet_effect:last_active(Der0),
                        {AerList1, DerList1} = update_user(Aer0, AccAerList, AccDerList),
                        {AerList2, DerList2} = update_user(Der1, AerList1, DerList1),
                        Report = get_der_info_report(Der1, Hurt),
                        {Aer0, AerList2, DerList2, [Report | AccDerReportList]}
                    end,
                    {Aer3, AerList3, DerList3, DerReportList} = lists:foldl(F, {NewAer0, AerList0, DerList0, []}, TargetDerList0),
                    AerList4 = update_last_eff(AerList3),
                    DerList4 = update_last_eff(DerList3),
                    AerListState = get_state_list(Aer3, AerList4++DerList4),
                    {AerList4, DerList4, [Round, Aer3#bs.key, max(Aer#bs.hp - Aer3#bs.hp, 0), Aer3#bs.hp, Aer3#bs.hp_lim, Aer3#bs.rage, ?RAGE_LIM, Skill#skill.skillid, AerListState, lists:reverse(DerReportList)]}
            end
    end.

update_last_eff(AerList) ->
    F = fun(Bs) -> pet_effect:last_active(Bs) end,
    lists:map(F, AerList).

%% 出手前需要计算攻击者状态，譬如：受到伤害，灼伤等
%% 出手后需实时更新宠物状态
check_do_battle(Aer) ->
    {Flag, NAer} = check_do_battle(Aer, easy_hurt),
    StateList = get_battle_state(NAer),
    NewAer = NAer#bs{state_list = StateList},
    {Flag, NewAer}.

%% 易伤
check_do_battle(Aer, easy_hurt) ->
    case Aer#bs.eff_args#eff_args.easy_hurt_round > 0 of
        true ->
            EffArgs = Aer#bs.eff_args,
            NAer = Aer#bs{
                eff_args = EffArgs#eff_args{easy_hurt_round = EffArgs#eff_args.easy_hurt_round - 1}
            },
            check_do_battle(NAer, easy_hurt_p);
        false ->
            check_do_battle(Aer, easy_hurt_p)
    end;

%% 易伤百分比
check_do_battle(Aer, easy_hurt_p) ->
    case Aer#bs.eff_args#eff_args.easy_hurt_p_round > 0 of
        true ->
            EffArgs = Aer#bs.eff_args,
            NAer = Aer#bs{
                eff_args = EffArgs#eff_args{easy_hurt_p_round = EffArgs#eff_args.easy_hurt_p_round - 1}
            },
            check_do_battle(NAer, add_hurt_p);
        false ->
            check_do_battle(Aer, add_hurt_p)
    end;

%% 增伤百分比
check_do_battle(Aer, add_hurt_p) ->
    case Aer#bs.eff_args#eff_args.add_hurt_p_round > 0 of
        true ->
            EffArgs = Aer#bs.eff_args,
            NAer = Aer#bs{
                eff_args = EffArgs#eff_args{add_hurt_p_round = EffArgs#eff_args.add_hurt_p_round - 1}
            },
            check_do_battle(NAer, fire_add_p);
        false ->
            check_do_battle(Aer, fire_add_p)
    end;

%% 灼烧减百分比伤害
check_do_battle(Aer, fire_add_p) ->
    case Aer#bs.eff_args#eff_args.fire_add_p_round > 0 of
        true ->
            EffArgs = Aer#bs.eff_args,
            NAer = Aer#bs{
                eff_args = EffArgs#eff_args{fire_add_p_round = EffArgs#eff_args.fire_add_p_round - 1},
                hp = max(0, Aer#bs.hp - round(Aer#bs.hp * Aer#bs.eff_args#eff_args.fire_add_p / 10000))
            },
            check_do_battle(NAer, fire_add);
        false ->
            check_do_battle(Aer, fire_add)
    end;

%% 灼烧减固定伤害
check_do_battle(Aer, fire_add) ->
    case Aer#bs.eff_args#eff_args.fire_add_round > 0 of
        true ->
            EffArgs = Aer#bs.eff_args,
            NAer = Aer#bs{
                eff_args = EffArgs#eff_args{fire_add_round = EffArgs#eff_args.fire_add_round - 1},
                hp = max(0, Aer#bs.hp - Aer#bs.eff_args#eff_args.fire_add)
            },
            check_do_battle(NAer, dizzy);
        false ->
            check_do_battle(Aer, dizzy)
    end;

%% 检查眩晕
check_do_battle(Aer, dizzy) ->
    case Aer#bs.eff_args#eff_args.dizzy > 0 of
        true ->
            EffArgs = Aer#bs.eff_args,
            NAer =
                Aer#bs{
                    eff_args = EffArgs#eff_args{dizzy = EffArgs#eff_args.dizzy - 1}
                },
            {dizzy, NAer};
        false ->
            {true, Aer}
    end;
check_do_battle(Aer, _) -> {true, Aer}.

%% 这里解析技能使用
use_skill(Aer, AerList, DerList, Skill, TargetDerList) ->
    Aer1 = pet_effect:add_effect(Aer, Skill#skill.efflist, Skill#skill.skillid),
    Aer2 = pet_buff:skill_add_buff(Aer1, Skill#skill.bufflist, Skill#skill.skillid),
    Aer3 = pet_buff:buff_to_effect(Aer2),
    {Aer4, AerList4, DerList4, TargetDerList4} = pet_effect:active(Aer3, AerList, DerList, TargetDerList),
    {Aer4, AerList4, DerList4, TargetDerList4}.

get_der_info_report(Der, Hurt) ->
    #bs{key = K, state_list = StatusList, hp = H, hp_lim = HL, rage = Rage} = Der,
    [K, Hurt, H, HL, Rage, ?RAGE_LIM, util:list_filter_repeat(StatusList)].

%%更新数据
update_user(User, AerList, DerList) when User#bs.die_type == ?DIE_TYPE1 ->
    if
        User#bs.hp =< 0 ->   %%攻击方死亡
            if
                User#bs.war_sign == ?TEAM1 ->
                    AerList2 = lists:keydelete(User#bs.key, 2, AerList),
                    DerList2 = DerList;
                true ->
                    AerList2 = AerList,
                    DerList2 = lists:keydelete(User#bs.key, 2, DerList)
            end;
        true ->
            if
                User#bs.war_sign == ?TEAM1 ->
                    AerList2 = lists:keyreplace(User#bs.key, 2, AerList, User),
                    DerList2 = DerList;
                true ->
                    AerList2 = AerList,
                    DerList2 = lists:keyreplace(User#bs.key, 2, DerList, User)
            end
    end,
    {AerList2, DerList2};

update_user(User, AerList, DerList) when User#bs.die_type == ?DIE_TYPE2 ->
    if
        User#bs.war_sign == ?TEAM1 ->
            AerList2 = lists:keyreplace(User#bs.key, 2, AerList, User),
            DerList2 = DerList;
        true ->
            AerList2 = AerList,
            DerList2 = lists:keyreplace(User#bs.key, 2, DerList, User)
    end,
    {AerList2, DerList2}.

%% 检查释放技能
check_use_skill(Aer) ->
    UseSkillList = Aer#bs.skill,
    check_use_skill(Aer, UseSkillList).

check_use_skill(_Aer, []) ->
    false;

check_use_skill(Aer, [SkillInfo | SkillList]) ->
    case SkillInfo of
        {SkillId0, Condition} ->
            case get(pet_battle_skill_id) of
                SkillId when is_integer(SkillId) -> ok;
                _ -> SkillId = SkillId0
            end,
            case data_skill:get(SkillId) of
                [] ->
                    check_use_skill(Aer, SkillList);
                Skill ->
                    case Condition of
                        [{20001, ">=", Value}] ->
                            if  %% 检查怒气值符合条件
                                Aer#bs.rage >= Value ->
                                    {Aer#bs{rage = 0}, Skill};
                                true ->
                                    check_use_skill(Aer, SkillList)
                            end;
                        [] -> %% 正常发起攻击 普通攻击也加怒气
                            {Aer#bs{rage = Aer#bs.rage+1}, Skill};
                        _Other ->
                            check_use_skill(Aer, SkillList)
                    end
            end;
        _ ->
            check_use_skill(Aer, SkillList)
    end.

get_skill_target(Aer, AttType, AerList, DerList) ->
    if
        AttType == 1 -> %% 单体攻击
            [get_target(Aer, AerList, DerList)];
        AttType == 2 -> %% 横排攻击
            get_row_target(Aer, AerList, DerList);
        AttType == 3 -> %% 竖排
            get_column_target(Aer, AerList, DerList);
        AttType == 4 -> %% 全体
            ?IF_ELSE(Aer#bs.war_sign == ?TEAM1, DerList, AerList);
        true -> []
    end.

get_column_target(Aer, AerList, DerList) ->
    Der = get_target(Aer, AerList, DerList),
    TargetPosList = get_column_by_pos(Der#bs.pos),
    case Der#bs.war_sign of
        ?TEAM1 ->
            F = fun(Aer0) ->
                lists:member(Aer0#bs.pos, TargetPosList)
            end,
            lists:filter(F, AerList);
        ?TEAM2 ->
            F = fun(Aer0) ->
                lists:member(Aer0#bs.pos, TargetPosList)
            end,
            lists:filter(F, DerList)
    end.

get_row_target(Aer, AerList, DerList) ->
    Der = get_target(Aer, AerList, DerList),
    TargetPosList = get_row_by_pos(Der#bs.pos),
    case Der#bs.war_sign of
        ?TEAM1 ->
            F = fun(Aer0) ->
                lists:member(Aer0#bs.pos, TargetPosList)
            end,
            lists:filter(F, AerList);
        ?TEAM2 ->
            F = fun(Aer0) ->
                lists:member(Aer0#bs.pos, TargetPosList)
            end,
            lists:filter(F, DerList)
    end.

get_column_by_pos(Pos) when Pos == 1 orelse Pos == 4 orelse Pos == 7 -> [1, 4, 7];
get_column_by_pos(Pos) when Pos == 2 orelse Pos == 5 orelse Pos == 8 -> [2, 5, 8];
get_column_by_pos(Pos) when Pos == 3 orelse Pos == 6 orelse Pos == 9 -> [3, 6, 9].

get_row_by_pos(Pos) when Pos == 1 orelse Pos == 2 orelse Pos == 3 -> [1, 2, 3];
get_row_by_pos(Pos) when Pos == 4 orelse Pos == 5 orelse Pos == 6 -> [4, 5, 6];
get_row_by_pos(Pos) when Pos == 7 orelse Pos == 8 orelse Pos == 9 -> [7, 8, 9].

get_target(Aer, AerList, DerList) ->
    #bs{pos = AerPos, war_sign = WarSign} = Aer,
    case WarSign of
        ?TEAM1 -> %% 攻击方
            TargetPosList = get_target_pos_list(AerPos),
            Target = get_target(TargetPosList, DerList),
            Target;
        ?TEAM2 -> %% 防御方
            TargetPosList = get_target_pos_list(AerPos),
            Target = get_target(TargetPosList, AerList),
            Target
    end.

%% 普通攻击获取攻击目标
get_target_pos_list(AerPos) when AerPos == 1 orelse AerPos == 4 orelse AerPos == 7 -> [1, 4, 7, 2, 5, 8, 3, 6, 9];
get_target_pos_list(AerPos) when AerPos == 2 orelse AerPos == 5 orelse AerPos == 8 -> [2, 5, 8, 1, 4, 7, 3, 6, 9];
get_target_pos_list(AerPos) when AerPos == 3 orelse AerPos == 6 orelse AerPos == 9 -> [3, 6, 9, 2, 5, 8, 1, 4, 7].

get_target([], _DerList) ->
    ?ERR("###get_target err", []),
    #bs{};

get_target([Pos | List], DerList) ->
    case lists:keyfind(Pos, #bs.pos, DerList) of
        false ->
            get_target(List, DerList);
        Bs ->
            Bs
    end.

%%计算伤害
cale_hurt(Aer, Der, Skill) ->
    #bs{
        att = A_att,
        hit = A_hit,
        crit = A_crit,                  %%暴击率
        crit_inc = A_crit_inc,          %%暴击伤害
        hurt_inc = A_hurt_inc,
        hurt_fix = A_hurt_fix,
        bs_args = A_BsArgs
    } = Aer,
    #bs{
        hp = D_hp,
        mana = D_mana,
        ten = D_ten,
        def = D_def,
        crit_dec = D_crit_dec,          %%内力
        hurt_dec = D_hurt_dec,
        dodge = D_dodge,
        rage = Rage
    } = Der,
    #skill{
        param = SkillParam1,
        param2 = SkillParam2
    } = Skill,
    SkillId = Skill#skill.skillid,
    %%0.7 +max[(命中-闪避)/(命中/5 * 13.333333）,0]
    RealAHit = ?IF_ELSE(A_hit == 0, 1, A_hit),
    HitRatio = round((0.9 + max(-0.5, (RealAHit - D_dodge) / (RealAHit / 5 * 15))) * 100),
    %%0.1+max[(暴击-韧性)/(暴击/4 * 11.11111),0]
    RealCrit = ?IF_ELSE(A_crit == 0, 1, A_crit),
    CritRatio = round((0.2 + max(-0.2, (RealCrit - D_ten) / (RealCrit / 4 * (10 + 10 / 9)))) * 100),
    {Hurt, Dstate} =
        case util:odds(HitRatio, 100) orelse A_BsArgs#bs_args.fix_hit of
            true ->
                HurtMax = ?IF_ELSE(SkillId > 0, 0, 1),
                AttDef = ?IF_ELSE(A_att - D_def < 0.25 * A_att, 0.25 * A_att, A_att - D_def),
                RandomParam = util:rand(99, 101) / 100,
                case util:odds(CritRatio, 100) of
                    true -> %%暴击
                        CritParam = max(1.5, A_crit_inc / 1000 - D_crit_dec / 1000),
                        {max(HurtMax, round(AttDef * SkillParam1 * (1 + (A_hurt_inc - D_hurt_dec) / 1000) * CritParam * RandomParam + SkillParam2 + A_hurt_fix)), ?STATE_CRIT};
                    _ ->
                        {max(HurtMax, round(AttDef * SkillParam1 * (1 + (A_hurt_inc - D_hurt_dec) / 1000) * RandomParam + SkillParam2 + A_hurt_fix)), ?STATE_NORMAL}
                end;
            false ->
                {0, ?STATE_DODGE}
        end,
    Hurt0 = eff_hurt(Hurt, Aer#bs.eff_args, Der#bs.eff_args),
    {Hurt2, D_mana2} = ?IF_ELSE(D_mana > Hurt0, {0, D_mana - Hurt0}, {Hurt0 - D_mana, 0}),%%法盾减免伤害
    D_hp2 = ?IF_ELSE(D_hp > Hurt2, round(D_hp - Hurt2), 0),
    %% 收到怒气技能伤害，怒气不增加
    NewRage = ?IF_ELSE(Skill#skill.type == 11, Rage, min(Rage + 1, ?RAGE_LIM)),
    if
        Dstate == ?STATE_NORMAL ->
            {Aer, Der#bs{state_list = get_battle_state(Der), hp = D_hp2, mana = D_mana2, rage = NewRage}, max(0, D_hp - D_hp2)};
        true ->
            {Aer, Der#bs{state_list = [Dstate | get_battle_state(Der)], hp = D_hp2, mana = D_mana2, rage = NewRage}, max(0, D_hp - D_hp2)}
    end.


get_state_list(Aer, BsList) ->
    F = fun(Bs) ->
        if
            Aer#bs.war_sign == Bs#bs.war_sign ->
                [[Bs#bs.key, get_battle_state(Bs)]];
            true -> []
        end
    end,
    Data = lists:flatmap(F, BsList),
    Data.

%% 更新当前状态值
get_battle_state(Bs) ->
    #eff_args{
        fire_add_round = FireAddRound,
        fire_add_p_round = FireAddPRound,
        dizzy = Dizzy,
        easy_hurt_p_round = EasyHurtPRonud,
        easy_hurt_round = EasyHurtRound,
        add_hurt_p_round = AddHurtPRound
    } = Bs#bs.eff_args,
    IsDizzy = ?IF_ELSE(Dizzy > 0, [?STATE_DIZZZY], []),
    IsFiring = ?IF_ELSE(FireAddRound > 0, [?STATE_FIRING], []),
    IsFiringP = ?IF_ELSE(FireAddPRound > 0, [?STATE_FIRING_P], []),
    IsEasyHurt = ?IF_ELSE(EasyHurtRound > 0, [?STATE_EASY], []),
    IsEasyHurtP = ?IF_ELSE(EasyHurtPRonud > 0, [?STATE_EASY_P], []),
    IsAddHurtP = ?IF_ELSE(AddHurtPRound > 0, [?STATE_ADD_HURT], []),
    IsDizzy ++ IsFiring ++ IsFiringP ++ IsEasyHurt ++ IsEasyHurtP ++ IsAddHurtP.

%% 处理效果伤害相关
eff_hurt(Hurt, AerEffArgs, DerEffArgs) ->
    Hurt1 =
        case DerEffArgs#eff_args.easy_hurt_round > 0 of
            true ->
                DerEffArgs#eff_args.easy_hurt;
            false ->
                0
        end,
    Hurt2 =
        case DerEffArgs#eff_args.easy_hurt_p_round > 0 of
            true ->
                round(Hurt * DerEffArgs#eff_args.easy_hurt_p / 10000);
            false ->
                0
        end,
    Hurt3 =
        case AerEffArgs#eff_args.add_hurt_p_round > 0 of
            true ->
                round(Hurt * AerEffArgs#eff_args.add_hurt_p / 10000);
            false ->
                0
        end,
    Hurt+Hurt1+Hurt2+Hurt3.