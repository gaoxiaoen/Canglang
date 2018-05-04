%%----------------------------------------------------
%% 宠物属性计算 
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(pet_attr).
-export([
        calc/2
        ,calc_grow_attr/2
        ,calc_avg_potential/1
        ,calc_eqm_attr_lev/1
        ,add_ext_attr/2
        ,get_ascend_attr/1
        ,get_add_attr/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("pet.hrl").
-include("item.hrl").

-define(calc_rate(Val, Rate), Val + Val * Rate / 100).

%% 计算宠物平均潜力
calc_avg_potential(#pet{attr = #pet_attr{xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal}}) ->
    Avg = (XlVal + TzVal + JsVal + LqVal) div 4,
    Avg.

%% 重新计算一个宠物的战斗属性
calc(Pet = #pet{eqm = Eqm, attr = Attr = #pet_attr{xl = Xl, tz = Tz, js = Js, lq = Lq, xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal, avg_val = Avg}, append_attr = AppendAttr, skill = Skills, evolve = Evo, ext_attr = ExtAttr}, Role) -> 
    NewSkills = [{SkillId, Exp, []} || {SkillId, Exp, _Args} <- Skills],
    {AddHp, AddMp, AddDmg, AddDef, AddCri, AddTen, AddHit, AddEva} = get_add_attr(Avg),
    Dmg = AddDmg + do_calc_base_attr(10, Xl, XlVal, 10),     %% 攻击
    Cri = AddCri + do_calc_base_attr(2, Xl, XlVal, 1.2),   %% 暴击
    Hp = AddHp + do_calc_base_attr(100, Tz, TzVal, 140),  %% 气血
    Mp = AddMp + do_calc_base_attr(50, Tz, TzVal, 16),   %% 法力
    Def = AddDef + do_calc_base_attr(100, Js, JsVal, 40),     %% 防御
    Ten = AddTen + do_calc_base_attr(5, Js, JsVal, 1.2),   %% 坚韧
    Hit = AddHit + do_calc_base_attr(5, Lq, LqVal, 1.2),   %% 命中
    Eva = AddEva + do_calc_base_attr(5, Lq, LqVal, 1.2),   %% 躲闪
    %% ?DEBUG("[攻击:~p][暴击:~p][气血:~p][法力:~p][防御:~p][坚韧:~p][命中:~p][躲闪:~p]", [Dmg, Cri, Hp, Mp, Def, Ten, Hit, Eva]),
    Attr0 = calc_clear(Attr),
    Attr1 = Attr0#pet_attr{
        hp = Hp, hp_max = Hp, mp = Mp, mp_max = Mp, dmg = Dmg, critrate = Cri
        ,defence = Def, tenacity = Ten, hitrate = Hit, evasion = Eva
    },
    Pet1 = Pet#pet{attr = Attr1, skill = NewSkills},
    Pet2 = calc_append_attr(AppendAttr, Pet1, []),
    EvoAttr = evolve_attr(Evo),
    Pet3 = do_calc_attr(EvoAttr, Pet2),
    Pet4 = calc_eqm_attr(Pet3, Eqm),
    EqmAttrLevEffect = eqm_attr_lev_effect(Eqm),
    Pet5 = do_calc_attr(EqmAttrLevEffect, Pet4),
    Pet6 = do_calc_attr(ExtAttr, Pet5),
    Pet7 = calc_buff(Pet6),
    [Pet8] = pet_ex:calc_cloud_attr([Pet7], []),
    Pet10 = do_calc_attr(soul_world:calc_pet(Role), Pet8),
    Pet11 = do_calc_attr(skins_attr(Role), Pet10),
    Pet12 = do_calc_attr(calc_ascend(Pet11), Pet11),
    Pet13 = do_calc_attr(pet_rb:calc_attr(Role), Pet12),
    NewPet = do_calc_attr(pet_collect:calc_attr(Role), Pet13),
    %% ?DEBUG("宠物技能数据[~w]", [NewPet#pet.skill]),
    %%--------------
    attr_round(NewPet). %% 结算结果取整处理

%% 计算宠物指定属性点数加成
calc_grow_attr(#pet{attr_sys = AttrSys, attr = #pet_attr{xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal}}, AttrVal) ->
    {Xl, Tz, Js, Lq} = pet_api:do_sys_attr(AttrVal, AttrSys),
    Dmg = do_calc_base_attr(attr_val, Xl, XlVal, 10),     %% 攻击
    Cri = do_calc_base_attr(attr_val, Xl, XlVal, 1.2),   %% 暴击
    Hp = do_calc_base_attr(attr_val, Tz, TzVal, 140),  %% 气血
    Mp = do_calc_base_attr(attr_val, Tz, TzVal, 16),   %% 法力
    Def = do_calc_base_attr(attr_val, Js, JsVal, 40),     %% 防御
    Ten = do_calc_base_attr(attr_val, Js, JsVal, 1.2),   %% 坚韧
    Hit = do_calc_base_attr(attr_val, Lq, LqVal, 1.2),   %% 命中
    Eva = do_calc_base_attr(attr_val, Lq, LqVal, 1.2),   %% 躲闪
    {AttrVal, Dmg, Cri, Hp, Mp, Def, Ten, Hit, Eva}.

%% 附加属性增加
add_ext_attr(Pet, []) -> Pet;
add_ext_attr(Pet = #pet{skin_grade = Grade}, [{base_id, BaseId} | T]) ->
    NewBaseId = pet_data:get_next_baseid(Grade, BaseId),
    NewPet = Pet#pet{skin_id = NewBaseId, base_id = NewBaseId},
    add_ext_attr(NewPet, T);
add_ext_attr(Pet = #pet{grow_val = Grow}, [{grow, Val} | T]) ->
    NewPet = Pet#pet{grow_val = Grow + Val},
    add_ext_attr(NewPet, T);
add_ext_attr(Pet, [{potential_rand, Val} | T]) ->
    case util:rand(1, 4) of
        1 -> add_ext_attr(Pet, [{potential_xl, Val} | T]);
        2 -> add_ext_attr(Pet, [{potential_tz, Val} | T]);
        3 -> add_ext_attr(Pet, [{potential_js, Val} | T]);
        _ -> add_ext_attr(Pet, [{potential_lq, Val} | T])
    end;
add_ext_attr(Pet = #pet{attr = Attr = #pet_attr{xl_val = XlVal, xl_max = XlMax}}, [{potential_xl, Val} | T]) ->
    NewPet = Pet#pet{attr = Attr#pet_attr{xl_val = XlVal + Val, xl_max = XlMax + Val}},
    add_ext_attr(NewPet, T);
add_ext_attr(Pet = #pet{attr = Attr = #pet_attr{tz_val = XlVal, tz_max = XlMax}}, [{potential_tz, Val} | T]) ->
    NewPet = Pet#pet{attr = Attr#pet_attr{tz_val = XlVal + Val, tz_max = XlMax + Val}},
    add_ext_attr(NewPet, T);
add_ext_attr(Pet = #pet{attr = Attr = #pet_attr{js_val = XlVal, js_max = XlMax}}, [{potential_js, Val} | T]) ->
    NewPet = Pet#pet{attr = Attr#pet_attr{js_val = XlVal + Val, js_max = XlMax + Val}},
    add_ext_attr(NewPet, T);
add_ext_attr(Pet = #pet{attr = Attr = #pet_attr{lq_val = XlVal, lq_max = XlMax}}, [{potential_lq, Val} | T]) ->
    NewPet = Pet#pet{attr = Attr#pet_attr{lq_val = XlVal + Val, lq_max = XlMax + Val}},
    add_ext_attr(NewPet, T);
add_ext_attr(Pet = #pet{ext_attr = ExtAttr}, [{Key, Val} | T]) ->
    NewExtAttr = case lists:keyfind(Key, 1, ExtAttr) of
        {_, N} -> lists:keyreplace(Key, 1, ExtAttr, {Key, Val + N});
        _ -> [{Key, Val} | ExtAttr]
    end,
    NewPet = Pet#pet{ext_attr = NewExtAttr},
    add_ext_attr(NewPet, T);
add_ext_attr(Pet, [_I | T]) ->
    ?ERR("宠物附加属性增加出现未知项：[~w]", [_I]),
    add_ext_attr(Pet, T).

%% 获取飞升属性
%% ROUND(Base*pow(0.92, Num - 1))
get_ascend_attr(AscendNum) when AscendNum > 0 ->
    UsedNum = min(AscendNum, 19),
    Base = [
        {?attr_pet_hp, 2000},
        {?attr_pet_dmg, 500},
        {?attr_pet_defence, 600},
        {?attr_pet_resist_metal, 200},
        {?attr_pet_resist_wood, 200},
        {?attr_pet_resist_water, 200},
        {?attr_pet_resist_fire, 200},
        {?attr_pet_resist_earth, 200}
    ],
    [{Flag, calc_ascend_factor(1, 0, Val, UsedNum)} || {Flag, Val} <- Base];
get_ascend_attr(_) ->
    [].


%%-----------------------------------------
%% 内部方法
%%-----------------------------------------

%% 按系数计算总飞升丹加成
calc_ascend_factor(Num, Val, Base, UsedNum) when UsedNum >= Num ->
    NewVal = Base + Val,
    NewBase = round((Base * 0.92) / 10) * 10,
    calc_ascend_factor(Num + 1, NewVal, NewBase, UsedNum);
calc_ascend_factor(_, Val, _, _) ->
    Val.

%% 计算飞升属性
calc_ascend(#pet{ascend_num = AscendNum}) ->
    [{Flag, 0, Val} || {Flag, Val} <- get_ascend_attr(AscendNum)].

%% 清空属性 重新计算
calc_clear(Attr) ->
    Attr#pet_attr{
        hp = 0, mp = 0, mp_max = 0, hp_max = 0, dmg = 0, critrate = 0, defence = 0, tenacity = 0
        ,hitrate = 0, evasion = 0, dmg_magic = 0
        ,anti_js = 0, anti_attack = 0, anti_seal = 0, anti_stone = 0, anti_stun = 0, anti_silent = 0
        ,anti_sleep = 0, anti_taunt = 0, anti_poison = 0, blood = 0, rebound = 0
        ,resist_metal = 0, resist_wood = 0, resist_water = 0, resist_fire = 0, resist_earth = 0
    }.

%% 计算结束 值取整
attr_round(Pet = #pet{skill = Skills, attr = Attr = #pet_attr{hp = Hp, mp = Mp, mp_max = MpMax, hp_max = HpMax, dmg = Dmg, critrate = Cri, defence = Def, tenacity = Ten
        ,hitrate = Hit, evasion = Eva, dmg_magic = DmgMagic
        ,anti_js = Js, anti_attack = Attack, anti_seal = Seal, anti_stone = Stone, anti_stun = Stun, anti_silent = Silent
        ,anti_sleep = Sleep, anti_taunt = Taunt, anti_poison = Posion, blood = Blood, rebound = Rebound
        ,resist_metal = Metal, resist_wood = Wood, resist_water = Water, resist_fire = Fire, resist_earth = Earth
    }}) ->
    NewAttr = Attr#pet_attr{
        hp = round(Hp), mp = round(Mp), mp_max = round(MpMax), hp_max = round(HpMax)
        ,dmg = round(Dmg), critrate = round(Cri), defence = round(Def), tenacity = round(Ten)
        ,hitrate = round(Hit), evasion = round(Eva), dmg_magic = round(DmgMagic)
        ,anti_js = round(Js), anti_attack = round(Attack), anti_seal = round(Seal), anti_stone = round(Stone)
        ,anti_stun = round(Stun), anti_silent = round(Silent), anti_sleep = round(Sleep)
        ,anti_taunt = round(Taunt), anti_poison = round(Posion), blood = round(Blood), rebound = round(Rebound)
        ,resist_metal = round(Metal), resist_wood = round(Wood), resist_water = round(Water), resist_fire = round(Fire), resist_earth = round(Earth)
    },
    NewSkills = [{SkillId, SkillExp, [{ArgType, round(Val)} || {ArgType, Val} <- Args]} || {SkillId, SkillExp, Args} <- Skills],
    Pet#pet{attr = NewAttr, skill = NewSkills}.

%% 属性算法公式
%% BaseVal = integer() 基础底值
%% N = integer() 点数
%% M = integer() 潜力
%% X = integer() 系数
do_calc_base_attr(attr_val, N, M, X) ->
    erlang:round(N * (M * 0.3 + 4) * X / 120);
do_calc_base_attr(BaseVal, N, M, X) ->
    BaseVal + erlang:round((N + M / 5) * (M * 0.3 + 4) * X / 120).


%% 获取附加属性{攻击, 暴击, 生命, 魔法,  防御,  坚韧, 精准，格挡}
get_add_attr(Avg) when Avg >= 600 -> {424,51,5937,684,1707,51,51,51};
get_add_attr(Avg) when Avg >= 550 -> {358,43,5010,578,1442,43,43,43};
get_add_attr(Avg) when Avg >= 500 -> {317,38,4440,513,1280,38,38,38};
get_add_attr(Avg) when Avg >= 420 -> {240,28,3355,389,970,29,29,29};
get_add_attr(Avg) when Avg >= 340 -> {184,22,2569,300,746,22,22,22};
get_add_attr(Avg) when Avg >= 260 -> {131,15,1833,216,536,16,16,16};
get_add_attr(Avg) when Avg >= 180 -> {79,9,1111,133,330,10,10,10};
get_add_attr(Avg) when Avg >= 100 -> {44,5,618,78,191,6,6,6};
get_add_attr(_Avg) -> {0, 0, 0, 0, 0, 0, 0, 0}.


%% 获取进化属性加成
evolve_attr(1) -> [{dmg, 200}, {defence, 300}, {hp, 2000}];
evolve_attr(2) -> [{dmg, 300}, {defence, 400}, {hp, 4000}];
evolve_attr(3) -> [{dmg, 400}, {defence, 500}, {hp, 6000}];
evolve_attr(_) -> [].

%% 获取图鉴属性
skins_attr(#role{pet = #pet_bag{skins = Skins}}) when length(Skins) >= 50 -> [{hp, 4000}];
skins_attr(#role{pet = #pet_bag{skins = Skins}}) when length(Skins) >= 40 -> [{hp, 3200}];
skins_attr(#role{pet = #pet_bag{skins = Skins}}) when length(Skins) >= 30 -> [{hp, 2400}];
skins_attr(#role{pet = #pet_bag{skins = Skins}}) when length(Skins) >= 20 -> [{hp, 1600}];
skins_attr(#role{pet = #pet_bag{skins = Skins}}) when length(Skins) >= 10 -> [{hp, 800}];
skins_attr(#role{pet = #pet_bag{skins = Skins}}) when length(Skins) >= 5 -> [{hp, 400}];
skins_attr(_Role) -> [].


%% 计算装备共鸣级别
calc_eqm_attr_lev(#pet{eqm = Eqm}) ->
    calc_eqm_attr_lev(Eqm);
calc_eqm_attr_lev(Eqm) when length(Eqm) < 6 -> 0;
calc_eqm_attr_lev(Eqm) ->
    Levs = calc_eqm_attr_lev(Eqm, []),
    {L12, L7} = {[Lev || Lev <- Levs, Lev >= 12], [Lev || Lev <- Levs, Lev >= 7]},
    case length(L12) >= 8 of
        true -> pet_magic_lev_to_effect_lev(8, 12);
        false ->
            SL7 = lists:sort(L7),
            case length(L7) >= 6 of
                true -> pet_magic_lev_to_effect_lev(6, lists:nth(6, lists:reverse(SL7)));
                false -> 0
            end
    end.

calc_eqm_attr_lev([], N) -> N;
calc_eqm_attr_lev([#item{quality = ?quality_orange, attr = Attr} | T], N) ->
    case lists:keyfind(?attr_pet_eqm_lev, 1, Attr) of
        {_Type, _Flag, Lev} -> calc_eqm_attr_lev(T, [Lev | N]);
        _ -> calc_eqm_attr_lev(T, N)
    end;
calc_eqm_attr_lev([_ | T], N) -> calc_eqm_attr_lev(T, N).

%% 计算共鸣级别
pet_magic_lev_to_effect_lev(8,12) -> 7;
pet_magic_lev_to_effect_lev(6,12) -> 6;
pet_magic_lev_to_effect_lev(6,11) -> 5;
pet_magic_lev_to_effect_lev(6,10) -> 4;
pet_magic_lev_to_effect_lev(6,9) -> 3;
pet_magic_lev_to_effect_lev(6,8) -> 2;
pet_magic_lev_to_effect_lev(6,7) -> 1;
pet_magic_lev_to_effect_lev(_,_) -> 0.

%% 装备共鸣效果
eqm_attr_lev_effect(Eqm) when is_list(Eqm) ->
    EqmAttrLev = calc_eqm_attr_lev(Eqm),
    eqm_attr_lev_effect(EqmAttrLev);
eqm_attr_lev_effect(1) -> [{hp_rate, 1}, {mp_rate, 1}, {defence_rate, 1}, {resist_all_rate, 1}];
eqm_attr_lev_effect(2) -> [{hp_rate, 2}, {mp_rate, 2}, {defence_rate, 2}, {resist_all_rate, 2}, {critrate, 10}, {tenacity, 10}];
eqm_attr_lev_effect(3) -> [{hp_rate, 3}, {mp_rate, 3}, {defence_rate, 3}, {resist_all_rate, 3}, {critrate, 15}, {tenacity, 15}, {hitrate, 10}, {evasion, 10}];
eqm_attr_lev_effect(4) -> [{hp_rate, 4}, {mp_rate, 4}, {defence_rate, 4}, {resist_all_rate, 4}, {critrate, 20}, {tenacity, 20}, {hitrate, 15}, {evasion, 15}, {anti_poison, 20}, {anti_all, 20}];
eqm_attr_lev_effect(5) -> [{hp_rate, 5}, {mp_rate, 5}, {defence_rate, 5}, {resist_all_rate, 5}, {critrate, 25}, {tenacity, 25}, {hitrate, 20}, {evasion, 20}, {anti_poison, 40}, {anti_all, 40}, {dmg_magic, 200}, {dmg, 200}];
eqm_attr_lev_effect(6) -> [{hp_rate, 7}, {mp_rate, 7}, {defence_rate, 7}, {resist_all_rate, 7}, {critrate, 30}, {tenacity, 30}, {hitrate, 25}, {evasion, 25}, {anti_poison, 80}, {anti_all, 80}, {dmg_magic, 500}, {dmg, 500}, {anti_attack_rate, 10}];
eqm_attr_lev_effect(7) -> [{hp_rate, 8}, {mp_rate, 8}, {defence_rate, 8}, {resist_all_rate, 8}, {critrate, 35}, {tenacity, 35}, {hitrate, 30}, {evasion, 30}, {anti_poison, 160}, {anti_all, 160}, {dmg_magic, 800}, {dmg, 800}, {anti_attack_rate, 12}];
eqm_attr_lev_effect(_) -> [].

%%---------------------------------------
%% 属性附加符使用计算
%%---------------------------------------

%% 计算宠物装备属性数据
calc_eqm_attr(Pet, []) -> 
    Pet;
calc_eqm_attr(Pet, [#item{attr = Attr} | T]) ->
    %% ?DEBUG("attr---------------------[~w]", [Attr]),
    NewPet = do_calc_attr(Attr, Pet),
    calc_eqm_attr(NewPet, T).

%% 计算宠物BUFF效果
calc_buff(Pet = #pet{buff = BuffList}) ->
    calc_buff(Pet, BuffList).
calc_buff(Pet, []) -> Pet;
calc_buff(Pet, [#pet_buff{effect = Effect} | T]) ->
    NewPet = do_calc_attr(Effect, Pet),
    calc_buff(NewPet, T);
calc_buff(Pet, [_ | T]) ->
    calc_buff(Pet, T).

%% 计算属性符附加数值
calc_append_attr([], Pet, AppendAttr) -> 
    Pet#pet{append_attr = AppendAttr};
calc_append_attr([{Type, Effect} | T], Pet, AppendAttr) when is_list(Effect) ->
    NewPet = do_calc_attr(Effect, Pet),
    NewEffect = lists:keydelete(baseid, 1, Effect),
    calc_append_attr(T, NewPet, [{Type, NewEffect} | AppendAttr]);
calc_append_attr(_, Pet, _AppendAttr) -> Pet.

%% 属性值类计算
do_calc_attr([{baseid, BaseId} | T], Pet = #pet{skin_grade = Grade}) -> %% 外观
    NewBaseId = pet_data:get_next_baseid(Grade, BaseId),
    NewPet = Pet#pet{skin_id = NewBaseId, base_id = NewBaseId},
    do_calc_attr(T, NewPet);
do_calc_attr([{hp, Val} | T], Pet = #pet{attr = Attr = #pet_attr{hp = Hp, hp_max = HpMax}}) -> %% 气血
    NewPet = Pet#pet{attr = Attr#pet_attr{hp = Hp + Val, hp_max = HpMax + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{mp, Val} | T], Pet = #pet{attr = Attr = #pet_attr{mp = Mp, mp_max = MpMax}}) -> %% 法力
    NewPet = Pet#pet{attr = Attr#pet_attr{mp = Mp + Val, mp_max = MpMax + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{dmg, Val} | T], Pet = #pet{attr = Attr = #pet_attr{dmg = Dmg}}) -> %% 攻击
    NewPet = Pet#pet{attr = Attr#pet_attr{dmg = Dmg + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{critrate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{critrate = Cri}}) -> %% 暴击
    NewPet = Pet#pet{attr = Attr#pet_attr{critrate = Cri + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{defence, Val} | T], Pet = #pet{attr = Attr = #pet_attr{defence = Def}}) -> %% 防御
    NewPet = Pet#pet{attr = Attr#pet_attr{defence = Def + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{tenacity, Val} | T], Pet = #pet{attr = Attr = #pet_attr{tenacity = Ten}}) -> %% 坚韧
    NewPet = Pet#pet{attr = Attr#pet_attr{tenacity = Ten + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{hitrate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{hitrate = Hit}}) -> %% 命中
    NewPet = Pet#pet{attr = Attr#pet_attr{hitrate = Hit + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{evasion, Val} | T], Pet = #pet{attr = Attr = #pet_attr{evasion = Eva}}) -> %% 闪躲
    NewPet = Pet#pet{attr = Attr#pet_attr{evasion = Eva + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{skill, Type, ArgType, Val} | T], Pet = #pet{skill = Skills}) -> %% 技能加成
    NewSkills = [do_skill_args(rate, Skill, Type, ArgType, Val) || Skill <- Skills],
    NewPet = Pet#pet{skill = NewSkills},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_poison, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_poison = Num}}) -> %% 抗中毒
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_poison = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_seal, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_seal = Num}}) -> %% 抗封印
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_seal = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_stone, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_stone = Num}}) -> %% 抗石化
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_stone = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_stun, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_stun = Num}}) -> %% 抗眩晕
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_stun = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_sleep, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_sleep = Num}}) -> %% 抗睡眠
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_sleep = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_taunt, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_taunt = Num}}) -> %% 抗嘲讽
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_taunt = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_silent, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_silent = Num}}) -> %% 抗遗忘
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_silent = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_all, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_seal = Seal, anti_stone = Stone, anti_stun = Stun, anti_sleep = Sleep, anti_taunt = Taunt, anti_silent = Silent}}) -> %% 抗控制
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_seal = Seal + Val, anti_stone = Stone + Val, anti_stun = Stun + Val, anti_sleep = Sleep + Val,  anti_taunt = Taunt + Val, anti_silent = Silent + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_metal, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_metal = Num}}) -> %% 金抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_metal = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_wood, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_wood = Num}}) -> %% 木抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_wood = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_water, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_water = Num}}) -> %% 水抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_water = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_fire, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_fire = Num}}) -> %% 火抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_fire = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_earth, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_earth = Num}}) -> %% 土抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_earth = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_all, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_metal = Metal, resist_wood = Wood, resist_water = Water, resist_fire = Fire, resist_earth = Earth}}) -> %% 全抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_metal = Metal + Val, resist_wood = Wood + Val, resist_water = Water + Val, resist_fire = Fire + Val, resist_earth = Earth + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{dmg_magic, Val} | T], Pet = #pet{attr = Attr = #pet_attr{dmg_magic = Num}}) -> %% 法伤
    NewPet = Pet#pet{attr = Attr#pet_attr{dmg_magic = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_js, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_js = Num}}) -> %% 精神
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_js = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{blood, Val} | T], Pet = #pet{attr = Attr = #pet_attr{blood = Num}}) -> %% 吸血
    NewPet = Pet#pet{attr = Attr#pet_attr{blood = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{rebound, Val} | T], Pet = #pet{attr = Attr = #pet_attr{rebound = Num}}) -> %% 反弹
    NewPet = Pet#pet{attr = Attr#pet_attr{rebound = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_attack, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_attack = Num}}) -> %% 反击
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_attack = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{skill_effect, Mutex, Val} | T], Pet = #pet{skill = Skills}) -> %% 技能效果
    NewSkills = [do_skill_args(mutex, Skill, Mutex, ?pet_skill_args_effect, Val) || Skill <- Skills],
    NewPet = Pet#pet{skill = NewSkills},
    do_calc_attr(T, NewPet);
do_calc_attr([{skill_rate, Mutex, Val} | T], Pet = #pet{skill = Skills}) -> %% 技能触发概率
    NewSkills = [do_skill_args(mutex, Skill, Mutex, ?pet_skill_args_rate, Val) || Skill <- Skills],
    NewPet = Pet#pet{skill = NewSkills},
    do_calc_attr(T, NewPet);
%% 百分比属性
do_calc_attr([{hp_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{hp = Hp, hp_max = HpMax}}) -> %% 气血百分比
    NewPet = Pet#pet{attr = Attr#pet_attr{hp = ?calc_rate(Hp, Val), hp_max = ?calc_rate(HpMax, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{mp_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{mp = Mp, mp_max = MpMax}}) -> %% 法力
    NewPet = Pet#pet{attr = Attr#pet_attr{mp = ?calc_rate(Mp, Val), mp_max = MpMax + MpMax * Val / 100}},
    do_calc_attr(T, NewPet);
do_calc_attr([{dmg_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{dmg = Dmg}}) -> %% 攻击
    NewPet = Pet#pet{attr = Attr#pet_attr{dmg = ?calc_rate(Dmg, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{critrate_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{critrate = Cri}}) -> %% 暴击
    NewPet = Pet#pet{attr = Attr#pet_attr{critrate = ?calc_rate(Cri, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{defence_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{defence = Def}}) -> %% 防御
    NewPet = Pet#pet{attr = Attr#pet_attr{defence = ?calc_rate(Def, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{tenacity_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{tenacity = Ten}}) -> %% 坚韧
    NewPet = Pet#pet{attr = Attr#pet_attr{tenacity = ?calc_rate(Ten, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{hitrate_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{hitrate = Hit}}) -> %% 命中
    NewPet = Pet#pet{attr = Attr#pet_attr{hitrate = ?calc_rate(Hit, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{evasion_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{evasion = Eva}}) -> %% 闪躲
    NewPet = Pet#pet{attr = Attr#pet_attr{evasion = ?calc_rate(Eva, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_metal_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_metal = Num}}) -> %% 金抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_metal = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_wood_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_wood = Num}}) -> %% 木抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_wood = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_water_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_water = Num}}) -> %% 水抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_water = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_fire_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_fire = Num}}) -> %% 火抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_fire = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_earth_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_earth = Num}}) -> %% 土抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_earth = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{resist_all_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_metal = Metal, resist_wood = Wood, resist_water = Water, resist_fire = Fire, resist_earth = Earth}}) -> %% 全抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_metal = ?calc_rate(Metal, Val), resist_wood = ?calc_rate(Wood, Val), resist_water = ?calc_rate(Water, Val), resist_fire = ?calc_rate(Fire, Val), resist_earth = ?calc_rate(Earth, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{dmg_magic_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{dmg_magic = Num}}) -> %% 法伤
    NewPet = Pet#pet{attr = Attr#pet_attr{dmg_magic = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_js_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_js = Num}}) -> %% 精神
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_js = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{blood_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{blood = Num}}) -> %% 吸血
    NewPet = Pet#pet{attr = Attr#pet_attr{blood = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{rebound_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{rebound = Num}}) -> %% 反弹
    NewPet = Pet#pet{attr = Attr#pet_attr{rebound = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_attack_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_attack = Num}}) -> %% 反击
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_attack = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_poison_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_poison = Num}}) -> %% 抗中毒
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_poison = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_seal_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_seal = Num}}) -> %% 抗封印
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_seal = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_stone_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_stone = Num}}) -> %% 抗石化
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_stone = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_stun_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_stun = Num}}) -> %% 抗眩晕
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_stun = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_sleep_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_sleep = Num}}) -> %% 抗睡眠
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_sleep = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_taunt_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_taunt = Num}}) -> %% 抗嘲讽
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_taunt = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_silent_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_silent = Num}}) -> %% 抗遗忘
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_silent = ?calc_rate(Num, Val)}},
    do_calc_attr(T, NewPet);
do_calc_attr([{anti_all_rate, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_seal = Seal, anti_stone = Stone, anti_stun = Stun, anti_sleep = Sleep, anti_taunt = Taunt, anti_silent = Silent}}) -> %% 抗控制
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_seal = ?calc_rate(Seal, Val), anti_stone = ?calc_rate(Stone, Val), anti_stun = ?calc_rate(Stun, Val), anti_sleep = ?calc_rate(Sleep, Val),  anti_taunt = ?calc_rate(Taunt, Val), anti_silent = ?calc_rate(Silent, Val)}},
    do_calc_attr(T, NewPet);
%% 来自装备属性
do_calc_attr([{?attr_pet_hp, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{hp = Hp, hp_max = HpMax}}) -> %% 气血
    NewPet = Pet#pet{attr = Attr#pet_attr{hp = Hp + Val, hp_max = HpMax + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_mp, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{mp = Mp, mp_max = MpMax}}) -> %% 法力
    NewPet = Pet#pet{attr = Attr#pet_attr{mp = Mp + Val, mp_max = MpMax + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_dmg, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{dmg = Dmg}}) -> %% 攻击
    NewPet = Pet#pet{attr = Attr#pet_attr{dmg = Dmg + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_critrate, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{critrate = Cri}}) -> %% 暴击
    NewPet = Pet#pet{attr = Attr#pet_attr{critrate = Cri + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_defence, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{defence = Def}}) -> %% 防御
    NewPet = Pet#pet{attr = Attr#pet_attr{defence = Def + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_tenacity, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{tenacity = Ten}}) -> %% 坚韧
    NewPet = Pet#pet{attr = Attr#pet_attr{tenacity = Ten + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_hitrate, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{hitrate = Hit}}) -> %% 命中
    NewPet = Pet#pet{attr = Attr#pet_attr{hitrate = Hit + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_evasion, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{evasion = Eva}}) -> %% 闪躲
    NewPet = Pet#pet{attr = Attr#pet_attr{evasion = Eva + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_dmg_magic, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{dmg_magic = Num}}) -> %% 法伤
    NewPet = Pet#pet{attr = Attr#pet_attr{dmg_magic = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_anti_js, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_js = Num}}) -> %% 精神
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_js = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_anti_attack, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_attack = Num}}) -> %% 反击
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_attack = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_anti_seal, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_seal = Num}}) -> %% 抗封印
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_seal = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_anti_stone, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_stone = Num}}) -> %% 抗石化
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_stone = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_anti_stun, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_stun = Num}}) -> %% 抗眩晕
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_stun = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_anti_sleep, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_sleep = Num}}) -> %% 抗睡眠
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_sleep = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_anti_taunt, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_taunt = Num}}) -> %% 抗嘲讽
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_taunt = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_anti_silent, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_silent = Num}}) -> %% 抗遗忘
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_silent = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_anti_poison, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{anti_poison = Num}}) -> %% 抗中毒
    NewPet = Pet#pet{attr = Attr#pet_attr{anti_poison = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_blood, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{blood = Num}}) -> %% 吸血
    NewPet = Pet#pet{attr = Attr#pet_attr{blood = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_rebound, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{rebound = Num}}) -> %% 反弹
    NewPet = Pet#pet{attr = Attr#pet_attr{rebound = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_resist_metal, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_metal = Num}}) -> %% 金抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_metal = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_resist_wood, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_wood = Num}}) -> %% 木抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_wood = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_resist_water, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_water = Num}}) -> %% 水抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_water = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_resist_fire, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_fire = Num}}) -> %% 火抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_fire = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_resist_earth, _Flag, Val} | T], Pet = #pet{attr = Attr = #pet_attr{resist_earth = Num}}) -> %% 土抗
    NewPet = Pet#pet{attr = Attr#pet_attr{resist_earth = Num + Val}},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_skill_kill, _Flag, Val} | T], Pet = #pet{skill = Skills}) -> %% 冲杀 攻击类技能加成
    NewSkills = [do_skill_args(rate, Skill, ?pet_skill_type_dmg, ?pet_skill_args_rate, Val) || Skill <- Skills],
    NewPet = Pet#pet{skill = NewSkills},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_skill_protect, _Flag, Val} | T], Pet = #pet{skill = Skills}) -> %% 护卫 防御类技能加成
    NewSkills = [do_skill_args(rate, Skill, ?pet_skill_type_def, ?pet_skill_args_rate, Val) || Skill <- Skills],
    NewPet = Pet#pet{skill = NewSkills},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_skill_anima, _Flag, Val} | T], Pet = #pet{skill = Skills}) -> %% 灵气 辅助类技能加成
    NewSkills = [do_skill_args(rate, Skill, ?pet_skill_type_help, ?pet_skill_args_rate, Val) || Skill <- Skills],
    NewPet = Pet#pet{skill = NewSkills},
    do_calc_attr(T, NewPet);
do_calc_attr([{?attr_pet_skill_id, Flag, Mutex} | T], Pet = #pet{skill = Skills}) -> %% 洗炼技能天赋
    Star = Flag div 100000,
    NewSkills = [do_skill_args(talent, Skill, Mutex, ?pet_skill_args_talent, Star) || Skill <- Skills],
    NewPet = Pet#pet{skill = NewSkills},
    do_calc_attr(T, NewPet);
do_calc_attr([_ | T], Pet) ->
    do_calc_attr(T, Pet);
do_calc_attr(_, Pet) -> Pet.

%% 技能参数附加效果处理
do_skill_args(rate, Skill = {SkillId, Exp, Args}, Type, ArgType, Val) -> %% 技能触发概率
    case pet_data_skill:get(SkillId) of  
        {ok, #pet_skill{type = Type}} -> %% 指定类型技能
            case lists:keyfind(ArgType, 1, Args) of
                {ArgType, N} ->
                    NewArgs = lists:keyreplace(ArgType, 1, Args, {ArgType, N + Val}),
                    {SkillId, Exp, NewArgs};
                _ ->
                    {SkillId, Exp, [{ArgType, Val} | Args]}
            end;
        _ ->
            Skill 
    end;
do_skill_args(talent, Skill = {SkillId, Exp, Args}, Mutex, ArgType, Val) -> %% 技能天赋 只对三阶技能起作用
    case pet_data_skill:get(SkillId) of
        {ok, #pet_skill{mutex = Mutex, step = Step}} when Step >= 3 ->
            case lists:keyfind(ArgType, 1, Args) of
                {ArgType, N} ->
                    NewArgs = lists:keyreplace(ArgType, 1, Args, {ArgType, N + Val}),
                    {SkillId, Exp, NewArgs};
                _ ->
                    {SkillId, Exp, [{ArgType, Val} | Args]}
            end;
        _ ->
            Skill 
    end;
do_skill_args(mutex, Skill = {SkillId, Exp, Args}, Mutex, ArgType, Val) -> %% 指定类型技能
    case pet_data_skill:get(SkillId) of
        {ok, #pet_skill{mutex = Mutex, step = Step}} ->
            NewVal = case Step of
                _ when Step >= 3 -> Val;
                2 -> Val / 2;
                _ -> Val / 4
            end,
            case lists:keyfind(ArgType, 1, Args) of
                {ArgType, N} ->
                    NewArgs = lists:keyreplace(ArgType, 1, Args, {ArgType, N + NewVal}),
                    {SkillId, Exp, NewArgs};
                _ ->
                    {SkillId, Exp, [{ArgType, NewVal} | Args]}
            end;
        _ ->
            Skill 
    end;
do_skill_args(_Label, Skill, _Type, _ArgType, _Val) -> Skill.
