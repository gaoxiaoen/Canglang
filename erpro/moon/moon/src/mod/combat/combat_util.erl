%%----------------------------------------------------
%% 战斗相关工具
%% @author yankai@jieyou.com
%%----------------------------------------------------
-module(combat_util).
-export([
        check_range/3,
        is_die/1,
        is_all_die/1,
        update_role_combat/2,
        is_normal_skill/1,
        get_pid/1,
        get_world_boss_type/1,
        get_other_cost/2,
        match_param/3,
        is_all_npc/1,
        get_fighter_num/2,
        filter_fighters/2,
        calc_heal/2,
        is_auto_and_hook/4,
        count_skill_play/1,
        power_calc/2,
        update_attr/2
    ]
).
-include("common.hrl").
-include("combat.hrl").
-include("vip.hrl").
-include("attr.hrl").
-include("skill.hrl").

%% @spec check_range(Val, Min, Max) -> number()
%% Val = number()
%% Min = number()
%% Max = number()
%% @doc 取值范围限制
check_range(Val, Min, Max) ->
    if
        Val > Max -> Max;
        Val < Min -> Min;
        true -> Val
    end.

%% @spec is_die(Hp) -> ?true | ?false
%% Hp = number()
%% @doc 判断是否死亡
is_die(Hp) ->
    case Hp < 1 of 
        true -> ?true;
        false -> ?false
    end.

%% @spec is_all_die(L) -> true | false
%% Hp = number()
%% @doc 检查指定组的成员是否已经全部阵亡(逃跑的也认定为阵亡)
is_all_die([]) -> true;
is_all_die([#fighter{type = ?fighter_type_pet} | T]) -> is_all_die(T);
is_all_die([#fighter{is_die = ?true} | T]) -> is_all_die(T);
is_all_die([#fighter{is_escape = ?true} | T]) -> is_all_die(T);
%% 未逃跑，同时血量也大于1，那么说明未阵亡
is_all_die([#fighter{is_escape = ?false, hp = Hp} | _T]) when Hp >= 1 -> false;
is_all_die([_H | T]) -> is_all_die(T).

%% @spec is_auto_and_hook(IsAuto, IsHook, ShortCutList, VipType) -> ?true | ?false 
%% @doc 判断是否帮助玩家选招
is_auto_and_hook(IsAuto, IsHook, ShortCutList, VipType) ->
    ShortcutListCheck = skill:is_set_shortcuts(ShortCutList),
    if
        IsAuto =:= ?true andalso IsHook =:= ?true andalso ShortcutListCheck =:= ?false ->
            ?true;
        IsAuto =:= ?true andalso IsHook =:= ?false ->
            ?true;
        IsAuto =:= ?true andalso IsHook =:= ?true andalso VipType =:= ?vip_no ->
            ?true;
        true -> ?false
    end.

%% @spec update_role_combat(NewParams, CombatParams) -> NewCombatParams
%% NewParams = [{Key, Value}]
%% CombatParams = [{Key, Value}]
%% @doc 用新的参数替代旧的参数
update_role_combat([], CombatParams) -> CombatParams;
update_role_combat([{Key, Val}|T], CombatParams) ->
    update_role_combat(T, [{Key, Val} | lists:keydelete(Key, 1, CombatParams)]).


%% @spec match_param(key, List, DefaultValue) -> any
%% Key = atom()
%% List = list()
%% DefaultValue = any
%% @doc 查找列表中的值，没有则返回默认值
match_param(Key, List, DefaultValue) ->
    case lists:keyfind(Key, 1, List) of
        false -> DefaultValue;
        {Key, Val} -> Val
    end.

%% @spec is_normal_skill(S) -> true | false
%% S = integer() | #c_skill{} | #c_pet_skill{}
%% @doc 判断是否常规技能
is_normal_skill(#c_skill{id = SkillId}) -> is_normal_skill(SkillId);
is_normal_skill(#c_pet_skill{id = SkillId}) -> is_normal_skill(SkillId);
is_normal_skill(?normal_atk_skill_cike) -> true;
is_normal_skill(?normal_atk_skill_xianzhe) -> true;
is_normal_skill(?normal_atk_skill_qishi) -> true;
is_normal_skill(?normal_atk_skill_zhenwu) -> true;
is_normal_skill(?normal_atk_skill_feiyu) -> true;
is_normal_skill(?normal_atk_skill_xinshou) -> true;
is_normal_skill(?skill_defence) -> true;  
is_normal_skill(?skill_item) -> true;
is_normal_skill(?skill_escape) -> true;
is_normal_skill(?skill_attack) -> true;
is_normal_skill(?skill_remote) -> true;
is_normal_skill(SkillId) when SkillId < 10000 -> true;
is_normal_skill(SkillId) -> %% 妖精普攻
    lists:member(SkillId, demon_skill_data:common_skills()).

%% @spec get_pid(F) -> pid
%% F = #fighter{}
%% @doc 获取参战者pid
get_pid(#fighter{pid = Pid}) -> Pid;
get_pid(_) -> undefined.

%% @spec get_world_boss_type(F) -> integer()
%% F = #fighter_ext_npc{}
%% @doc 获取参战者的世界boss类型
get_world_boss_type(#fighter_ext_npc{world_boss_type = WorldBossType}) -> WorldBossType;
get_world_boss_type(_) -> ?world_boss_type_none.

%% @spec get_other_cost(Key, L) -> integer()
%% Key = atom()
%% L -> list(), [{hp, integer()}...]
%% @doc 获取技能特殊消耗
get_other_cost(Key, OtherCost) when is_list(OtherCost) ->
    case lists:keyfind(Key, 1, OtherCost) of
        {Key, HpCost} -> HpCost;
        _ -> 0
    end;
get_other_cost(_, _) -> 0.

%% @spec is_all_npc(Fighters) -> true | false
%% Fighters = [#fighter{}] | [#converted_fighter{}]
%% @doc 判断参战者是否全部是npc
is_all_npc(Fighters) -> is_all_npc(Fighters, true).
is_all_npc([], Result) -> Result;
is_all_npc([#converted_fighter{fighter = #fighter{type = ?fighter_type_role}}|_T], _Result) -> false;
is_all_npc([#converted_fighter{fighter = #fighter{type = ?fighter_type_pet}}|_T], _Result) -> false;
is_all_npc([#fighter{type = ?fighter_type_role}|_T], _Result) -> false;
is_all_npc([#fighter{type = ?fighter_type_pet}|_T], _Result) -> false;
is_all_npc([_|T], Result) -> is_all_npc(T, Result).

%% @spec get_fighter_num(Type, Fighters) -> integer()
%% Type = ?fighter_type_npc...
%% Fighters = [#fighter{}] | [#converted_fighter{}]
%% @doc 获取指定参战者类型有多少个
get_fighter_num(Type, Fighters) ->
    do_get_fighter_num(Type, Fighters, 0).
do_get_fighter_num(_Type, [], Num) -> Num;
do_get_fighter_num(Type, [#converted_fighter{fighter = #fighter{type = FighterType}}|T], Num) when Type =:= FighterType ->
    do_get_fighter_num(Type, T, Num+1);
do_get_fighter_num(Type, [#fighter{type = FighterType}|T], Num) when Type =:= FighterType ->
    do_get_fighter_num(Type, T, Num+1);
do_get_fighter_num(Type, [_|T], Num) ->
    do_get_fighter_num(Type, T, Num).

%% 过滤掉参战者列表中的宠物 or NPC or 玩家
filter_fighters(FilterTypes, Fighters) when is_list(FilterTypes) ->
    [F || F = #fighter{type = Type} <- Fighters, not lists:member(Type, FilterTypes)];
filter_fighters(FilterType, Fighters) ->
    [F || F = #fighter{type = Type} <- Fighters, Type =/= FilterType].

%% @spec calc_heal(F, HealHp) -> integer()
%% F = #fighter{}
%% HealHp = integer()
%% @doc 计算最终治疗量
calc_heal(#fighter{heal_ratio = HealRatio}, HealHp) ->
    round(HealHp * HealRatio / 100).

%% @spec count_skill_play(SkillPlays) -> integer()
%% SkillPlays = [#skill_play{}]
%% @doc 计算播报数量，用来计算等待时间
count_skill_play(SkillPlays) ->
    do_count_skill_play(SkillPlays, 0, 1, 0).
do_count_skill_play([], _, _, Count) -> Count;
do_count_skill_play([#skill_play{order = Order, sub_order = SubOrder, id = Sid, target_id = Tid}|T], PrevOrder, PrevSubOrder, Count) ->
    if
        Order > PrevOrder ->
            case Sid =:= Tid of
                true -> do_count_skill_play(T, Order, 1, Count+0.7); %% 如果是自己对自己发动的技能，则削减等待时间
                false -> do_count_skill_play(T, Order, 1, Count+1)
            end;
        Order =:= PrevOrder -> %% 带多条子播报
            case SubOrder =:= PrevSubOrder of
                true -> %% 同时进行的就只计算第一条（比如反弹伤害）
                    do_count_skill_play(T, Order, SubOrder, Count);
                false ->
                    do_count_skill_play(T, Order, SubOrder, Count+1)
            end;
        true ->
            do_count_skill_play(T, Order, 1, Count)
    end.


%% @spec power_calc(Source, Dmg) -> integer()
%% Source = integer() | pid()
%% Dmg = integer()
%% @doc 天威计算（按千分率存储）
power_calc(HpMax, HpDmg) when is_integer(HpMax) ->
    round(HpDmg / HpMax * ?MAX_POWER);
power_calc(Pid, HpDmg) ->
    case combat:f(by_pid, Pid) of
        {_, #fighter{hp_max = HpMax, type = ?fighter_type_role}} ->
            power_calc(HpMax, HpDmg);
        _ -> 0
    end.

%% @spec update_attr(Fighter, Attrs) -> NewFighter
%% Fighter = NewFighter = #fighter{}
%% Attrs = [{k, V}]
%% @doc 更新参战者属性
update_attr(Fighter, []) ->
    Fighter;
update_attr(Fighter, [H | T]) ->
    case do_update_attr(H, Fighter) of
        {ok, NewFighter} ->
            update_attr(NewFighter, T);
        {false, _R} ->
            ?ERR("无效的战斗属性 ~w", [_R]),
            update_attr(Fighter, T)
    end.

%% --------------------- 内部方法 ---------------------------------
%% 增加气血上限
do_update_attr({hp_max, Val},  Fighter = #fighter{hp_max = V, hp = Hp}) ->
    NewHp = case Hp > 0 of
        true -> max(1, round(Hp * (1 + Val / V)));
        _ -> 0
    end,
    {ok, Fighter#fighter{hp_max = V + Val, hp = NewHp}};

%% 增加法术上限
do_update_attr({mp_max, Val},  Fighter = #fighter{mp_max = V}) ->
    {ok, Fighter#fighter{mp_max = V + Val}};

%% 增加精神
do_update_attr({js, Val},  Fighter = #fighter{attr = Attr = #attr{js = V}}) ->
    {ok, Fighter#fighter{attr = Attr#attr{js = V + Val}}};

%% 增加攻击力
do_update_attr({dmg, Val},  Fighter = #fighter{attr = Attr = #attr{dmg_min = Min, dmg_max = Max}}) ->
    {ok, Fighter#fighter{attr = Attr#attr{dmg_min = Val + Min, dmg_max = Val + Max}}};

%% 增加法伤
do_update_attr({dmg_magic, Val},  Fighter = #fighter{attr = Attr = #attr{dmg_magic = DmgMagic}}) ->
    {ok, Fighter#fighter{attr = Attr#attr{dmg_magic = DmgMagic + Val}}};

%% 增加防御
do_update_attr({defence, Val}, Fighter = #fighter{attr = Attr = #attr{defence = V}}) ->
    {ok, Fighter#fighter{attr = Attr#attr{defence = Val + V}}};

%% 增加闪躲
do_update_attr({evasion, Val}, Fighter = #fighter{attr = Attr = #attr{evasion = V}}) ->
    {ok, Fighter#fighter{attr = Attr#attr{evasion = Val + V}}};

%% 增加暴击
do_update_attr({critrate, Val}, Fighter = #fighter{attr = Attr = #attr{critrate = V}}) ->
    {ok, Fighter#fighter{attr = Attr#attr{critrate = Val + V}}};

%% 增加命中
do_update_attr({hitrate, Val}, Fighter = #fighter{attr = Attr = #attr{hitrate = V}}) ->
    {ok, Fighter#fighter{attr = Attr#attr{hitrate = Val + V}}};

%% 增加坚韧
do_update_attr({tenacity, Val}, Fighter = #fighter{attr = Attr = #attr{tenacity = V}}) ->
    {ok, Fighter#fighter{attr = Attr#attr{tenacity = Val + V}}};
do_update_attr(A, _Fighter) ->
    {false, A}.
