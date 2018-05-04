%%-------------------------------
%% 装备穿戴效果计算
%% wpf
%% 2011-07-27
%%-------------------------------
-module(eqm_effect).
-export([
        do_attr/2
        ,do_hole/2
        ,do_enchant/3
        ,do_enchant_add/2
        ,do_embed/2
        ,do_sets/2
        ,do_all/3
        ,add_per/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("ratio.hrl").
-include("item.hrl").
-include("soul_mark.hrl").

%% 穿戴属性效果; attr = [] 详见item.hrl
%% {Label, Flag, Value}

%% 装备物品的属性效果计算
%% @spec do_attr(EqmAttr, Role) -> NewRole
%% EqmAttr = [{Type, Value} | ...] 属性效果
%%  Type = int() 效果类型
%%  Value = int() 效果值    
%% Role = NewRole = #role{} 角色属性
do_attr([], Role) -> {ok, Role};
do_attr([H | T], Role) ->
    case do(H, Role) of
        {ok, NewRole} -> do_attr(T, NewRole);
        {skip, _Info} -> do_attr(T, Role);
        {false, Reason} -> {false, Reason}
    end.

do_enchant_add_per([], _, Role) -> {ok, Role}; 
do_enchant_add_per([H|T], SumEqmAttr, Role) ->
    case do(enchant_add_per, H, SumEqmAttr, Role) of
        {ok, Role1} ->
            do_enchant_add_per(T, SumEqmAttr, Role1);
        skip ->
            do_enchant_add_per(T, SumEqmAttr, Role)
    end.

%% 装备中的宝石效果计算
%% @spec do_hole(Eqm, Role) -> {ok, NewRole}
%%  Eqm = [#item{}, ...]
%% Role = NewRole = #role{} 角色属性
do_hole(Eqm, Role = #role{}) ->
    AttrList = eqm_api:get_hole_attr(Eqm),
    do_attr(AttrList, Role).

%% 强化部位附加奖励
do_enchant(Eqm, SumEqmAttr, Role) ->
    AttrList = eqm_api:get_enchant_reward(Eqm, []),
    %% ?DEBUG("=========>>> 强化额外加成奖励  ~p", [AttrList]),
    EnchantAttr = [{Name, 100, Val} || {Name, Val} <- AttrList, Name < ?attr_xl_per],
    EnchantAttrPer = [{Name, 100, Val} || {Name, Val} <- AttrList, Name >= ?attr_xl_per, Name =< ?attr_dmg_magic_per], 
    %% ?DEBUG("{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{  PER ~w", [EnchantAttrPer]),
    {ok, Role1} = do_enchant_add_per(EnchantAttrPer, SumEqmAttr, Role),
    do_attr(EnchantAttr, Role1).

%% 强化获得额外属性
do_enchant_add(Eqm, Role) ->
    AttrList = eqm_api:get_enchant_add(Eqm, []),
    %%?DEBUG("{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{  强化附加属性  ~w", [AttrList]),
    AttrList1 = [{Name, 100, Val} || {Name, Val} <- AttrList],
    do_attr(AttrList1, Role). 

%% 套装属性计算
%% 均未锁定,全部正常计算 
do_sets(Eqm, Role) ->
    AttrList = eqm_api:get_set_attr(Eqm),
    SetAttr = [{Name, 100, Val} || {Name, Val} <- AttrList],
    do_attr(SetAttr, Role).

%% 奖励全身属性
do_all(Eqm, SumEqmAttr, Role) ->
   {AttrList, AllNum} = eqm_api:get_all_reward(Eqm),
   rank_celebrity:listener(all_eqm, Role, AllNum),
   AllAttr = [{Name, 100, Val} || {Name, Val} <- AttrList, Name < ?attr_xl_per],
   PerAttr = [{Name, 100, Val} || {Name, Val} <- AttrList, Name >= ?attr_xl_per andalso Name =< ?attr_dmg_magic_per],
   {ok, Role1} = do_enchant_add_per(PerAttr, SumEqmAttr, Role),
   do_attr(AllAttr, Role1).

%% 宝石套装属性
do_embed(Eqm, Role) ->
    NormalAttrList = eqm_api:get_embed_attr(Eqm),
    AttrList = NormalAttrList,
    SetAttr = [{Name, 100, Val} || {Name, Val} <- AttrList],
    do_attr(SetAttr, Role).

%% ----------------------------------------------
%% 内部函数
%% ----------------------------------------------

%% 执行属性效果计算: 相关的宏定义见item.hrl
%% 增加气血上限
do({?attr_hp_max, Flag, Val},  Role = #role{hp_max = V}) when Flag > 0->
    {ok, Role#role{hp_max = V + Val}};

%% 增加法术上限
do({?attr_mp_max, Flag, Val},  Role = #role{mp_max = V}) when Flag > 0 ->
    {ok, Role#role{mp_max = V + Val}};

%% 增加精神
do({?attr_js, Flag, Val},  Role = #role{attr = Attr = #attr{js = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{js = V + Val}}};

%% 增加攻速
do({?attr_aspd, Flag, Val}, Role = #role{attr = Attr = #attr{aspd = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{aspd = V + Val}}};

%% 增加攻击力
do({?attr_dmg, Flag, Val},  Role = #role{attr = Attr = #attr{dmg_min = Min, dmg_max = Max}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{dmg_min = Val + Min, dmg_max = Val + Max}}};

%% 增加攻击力下限
do({?attr_dmg_min, Flag, Val},  Role = #role{attr = Attr = #attr{dmg_min = Min}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{dmg_min = Val + Min}}};

%% 增加攻击力上限
do({?attr_dmg_max, Flag, Val},  Role = #role{attr = Attr = #attr{dmg_max = Max}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{dmg_max = Val + Max}}};

%% 增加防御
do({?attr_defence, Flag, Val}, Role = #role{attr = Attr = #attr{defence = Def}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{defence = Val + Def}}};

%% 增加命中
do({?attr_hitrate, Flag, Val}, Role = #role{attr = Attr = #attr{hitrate = Hit}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{hitrate = Val + Hit}}};

%% 增加躲闪
do({?attr_evasion, Flag, Val}, Role = #role{attr = Attr = #attr{evasion = Eva}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{evasion = Val + Eva}}};

%% 增加暴击
do({?attr_critrate, Flag, Val}, Role = #role{attr = Attr = #attr{critrate = Crt}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{critrate = Val + Crt}}};

%% 增加坚韧
do({?attr_tenacity, Flag, Val}, Role = #role{attr = Attr = #attr{tenacity = Ten}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{tenacity = Val + Ten}}};

%% 增加全抗性
do({?attr_rst_all, Flag, Val}, Role = #role{attr = Attr = #attr{resist_metal = RM, resist_wood = RW, resist_water = RWa, resist_fire = RF, resist_earth = RE}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{resist_metal = Val + RM,
                resist_wood = Val + RW,
                resist_water = Val + RWa,
                resist_fire = Val + RF,
                resist_earth = Val + RE}}};

%% 增加抗性
do({?attr_rst_metal, Flag, Val}, Role = #role{attr = Attr = #attr{resist_metal = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{resist_metal = Val + V}}};
do({?attr_rst_wood, Flag, Val}, Role = #role{attr = Attr = #attr{resist_wood = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{resist_wood = Val + V}}};
do({?attr_rst_water, Flag, Val}, Role = #role{attr = Attr = #attr{resist_water = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{resist_water = Val + V}}};
do({?attr_rst_fire, Flag, Val}, Role = #role{attr = Attr = #attr{resist_fire = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{resist_fire = Val + V}}};
do({?attr_rst_earth, Flag, Val}, Role = #role{attr = Attr = #attr{resist_earth = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{resist_earth = Val + V}}};

%% 增加五行攻击属性: 根据职业判断
do({?attr_dmg_metal, Flag, Val}, Role = #role{career = Career, attr = Attr = #attr{dmg_wuxing = V}}) when Flag > 0 ->
    {ok, case Career =:= ?career_zhenwu orelse Career =:= ?career_xinshou of 
            true -> Role#role{attr = Attr#attr{dmg_wuxing = Val + V}};
            false -> Role end};
do({?attr_dmg_wood, Flag, Val}, Role = #role{career = Career, attr = Attr = #attr{dmg_wuxing = V}}) when Flag > 0 ->
    {ok, case Career =:= ?career_cike of 
            true -> Role#role{attr = Attr#attr{dmg_wuxing = Val + V}};
            false -> Role end};
do({?attr_dmg_water, Flag, Val}, Role = #role{career = Career, attr = Attr = #attr{dmg_wuxing = V}}) when Flag > 0 ->
    {ok, case Career =:= ?career_feiyu of 
            true -> Role#role{attr = Attr#attr{dmg_wuxing = Val + V}};
            false -> Role end};
do({?attr_dmg_fire, Flag, Val}, Role = #role{career = Career, attr = Attr = #attr{dmg_wuxing = V}}) when Flag > 0 ->
    {ok, case Career =:= ?career_xianzhe of 
            true -> Role#role{attr = Attr#attr{dmg_wuxing = Val + V}};
            false -> Role end};
do({?attr_dmg_earth, Flag, Val}, Role = #role{career = Career, attr = Attr = #attr{dmg_wuxing = V}}) when Flag > 0 ->
    {ok, case Career =:= ?career_qishi of 
            true -> Role#role{attr = Attr#attr{dmg_wuxing = Val + V}};
            false -> Role end};

%%移动速度
do({?attr_speed, Flag, Val}, Role = #role{speed = Speed}) when Flag > 0 ->
    {ok, Role#role{speed = Speed + Val}};

%% 增加五行伤害吸收
do({?attr_asb_all, Flag, Val}, Role = #role{attr = Attr = #attr{asb_metal = RM, asb_wood = RW, asb_water = RWa, asb_fire = RF, asb_earth = RE}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{
                asb_metal = Val + RM,
                asb_wood = Val + RW,
                asb_water = Val + RWa,
                asb_fire = Val + RF,
                asb_earth = Val + RE}}};

%% 增加五行伤害吸收
do({?attr_asb_metal, Flag, Val}, Role = #role{attr = Attr = #attr{asb_metal = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{asb_metal = Val + V}}};
do({?attr_asb_wood, Flag, Val}, Role = #role{attr = Attr = #attr{asb_wood = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{asb_wood = Val + V}}};
do({?attr_asb_water, Flag, Val}, Role = #role{attr = Attr = #attr{asb_water = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{asb_water = Val + V}}};
do({?attr_asb_fire, Flag, Val}, Role = #role{attr = Attr = #attr{asb_fire = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{asb_fire = Val + V}}};
do({?attr_asb_earth, Flag, Val}, Role = #role{attr = Attr = #attr{asb_earth = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{asb_earth = Val + V}}};

%% 增加法术伤害
do({?attr_dmg_magic, Flag, Val}, Role = #role{attr = Attr = #attr{dmg_magic = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{dmg_magic = Val + V}}};

%% 增加各种抗
do({?attr_anti_stun, Flag, Val}, Role = #role{attr = Attr = #attr{anti_stun = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{anti_stun = Val + V}}};
do({?attr_anti_sleep, Flag, Val}, Role = #role{attr = Attr = #attr{anti_sleep = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{anti_sleep = Val + V}}};
do({?attr_anti_silent, Flag, Val}, Role = #role{attr = Attr = #attr{anti_silent = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{anti_silent = Val + V}}};
do({?attr_anti_stone, Flag, Val}, Role = #role{attr = Attr = #attr{anti_stone = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{anti_stone = Val + V}}};
do({?attr_anti_taunt, Flag, Val}, Role = #role{attr = Attr = #attr{anti_taunt = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{anti_taunt = Val + V}}};
do({?attr_anti_seal, Flag, Val}, Role = #role{attr = Attr = #attr{anti_seal = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{anti_seal = Val + V}}};
do({?attr_anti_poison, Flag, Val}, Role = #role{attr = Attr = #attr{anti_poison = V}}) when Flag > 0 ->
    {ok, Role#role{attr = Attr#attr{anti_poison = Val + V}}};
do({?attr_enhance_stun, _Flag, Val}, Role = #role{attr = Attr = #attr{enhance_stun = V}}) -> 
    {ok, Role#role{attr = Attr#attr{enhance_stun = V + Val}}};
do({?attr_enhance_sleep, _Flag, Val}, Role = #role{attr = Attr = #attr{enhance_sleep = V}}) -> 
    {ok, Role#role{attr = Attr#attr{enhance_sleep = V + Val}}};
do({?attr_enhance_taunt, _Flag, Val}, Role = #role{attr = Attr = #attr{enhance_taunt = V}}) -> 
    {ok, Role#role{attr = Attr#attr{enhance_taunt = V + Val}}};
do({?attr_enhance_silent, _Flag, Val}, Role = #role{attr = Attr = #attr{enhance_silent = V}}) -> 
    {ok, Role#role{attr = Attr#attr{enhance_silent = V + Val}}};
do({?attr_enhance_stone, _Flag, Val}, Role = #role{attr = Attr = #attr{enhance_stone = V}}) -> 
    {ok, Role#role{attr = Attr#attr{enhance_stone = V + Val}}};
do({?attr_enhance_poison, _Flag, Val}, Role = #role{attr = Attr = #attr{enhance_poison = V}}) -> 
    {ok, Role#role{attr = Attr#attr{enhance_poison = V + Val}}};
do({?attr_enhance_seal, _Flag, Val}, Role = #role{attr = Attr = #attr{enhance_seal = V}}) -> 
    {ok, Role#role{attr = Attr#attr{enhance_seal = V + Val}}};

%% 增加慧根 （百分比）
do({?attr_js_per, Flag, Val},  Role = #role{ratio = Ratio = #ratio{js = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{js = V + Val}}};

%% 增加气血上限 （百分比）
do({?attr_hp_max_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{hp_max = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{hp_max = V + Val}}};

%% 增加法术上限 （百分比）
do({?attr_mp_max_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{mp_max = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{mp_max = V + Val}}};

%% 增加攻击 （百分比）
do({?attr_dmg_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{dmg = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{dmg = V + Val}}};

%% 增加防御 （百分比）
do({?attr_defence_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{defence = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{defence = V + Val}}};

%% 增加命中 （百分比）
do({?attr_hitrate_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{hitrate = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{hitrate = V + Val}}};

%% 增加躲闪 （百分比）
do({?attr_evasion_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{evasion = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{evasion = V + Val}}};

%% 增加暴击 （百分比）
do({?attr_critrate_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{critrate = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{critrate = V + Val}}};

%% 抗性加成 (百分比)
do({?attr_rst_all_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{resist_metal = RM, resist_wood = RW, resist_water = RWa, resist_fire = RF, resist_earth = RE}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{resist_metal = RM + Val,
                resist_wood = RW + Val,
                resist_water = RWa + Val,
                resist_fire = RF + Val,
                resist_earth = RE + Val}}};
do({?attr_rst_metal_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{resist_metal = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{resist_metal = V + Val}}};
do({?attr_rst_wood_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{resist_wood = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{resist_wood = V + Val}}};
do({?attr_rst_water_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{resist_water = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{resist_water = V + Val}}};
do({?attr_rst_fire_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{resist_fire = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{resist_fire = V + Val}}};
do({?attr_rst_earth_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{resist_earth = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{resist_earth = V + Val}}};

%% 绝对伤害加成
do({?attr_dmg_magic_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{dmg_magic = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{dmg_magic = V + Val}}};

%% 坚韧加成
do({?attr_tenacity_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{tenacity = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{tenacity = V + Val}}};

%% 移动速度 百分比加成
do({?attr_speed_per, Flag, Val}, Role = #role{ratio = Ratio = #ratio{speed = V}}) when Flag > 0 ->
    {ok, Role#role{ratio = Ratio#ratio{speed = V + Val}}};

%% 宝石效果
do({?attr_hole1, FlagHole, GemId}, _Role) when FlagHole =:= 101 andalso GemId > 0 ->
    {skip, ?L(<<"宝石另外计算">>)};
do({?attr_hole2, FlagHole, GemId}, _Role) when FlagHole =:= 101 andalso GemId > 0 ->
    {skip, ?L(<<"宝石另外计算">>)};
do({?attr_hole3, FlagHole, GemId}, _Role) when FlagHole =:= 101 andalso GemId > 0 ->
    {skip, ?L(<<"宝石另外计算">>)};
do({?attr_hole4, FlagHole, GemId}, _Role) when FlagHole =:= 101 andalso GemId > 0 ->
    {skip, ?L(<<"宝石另外计算">>)};
do({?attr_hole5, FlagHole, GemId}, _Role) when FlagHole =:= 101 andalso GemId > 0 ->
    {skip, ?L(<<"宝石另外计算">>)};

%% 技能属性过滤
do({?attr_skill_lev, _, _}, Role) -> {ok, Role};
do({?attr_skill, _, _}, Role) -> {ok, Role};


%% 容错处理
do({_Eff, Flag, _Val}, _Role) when Flag =:= 0 ->
    {skip, ?L(<<"隐藏属性，忽略计算">>)};
do({_Eff, Flag, Val}, _Role) when Flag =:= 101 andalso Val =:= 0 ->
    {skip, ?L(<<"打孔未镶嵌宝石，忽略计算">>)};
do(_Data, _Role) ->
    ?ERR("错误的装备属性:~w", [_Data]),
    {skip, ?L(<<"错误数据">>)}.

%%  装备强化百分比加成处理
%%  增加慧根 （百分比）
do(enchant_add_per, {?attr_js_per, Flag, Val},  SumEqmAttr, Role = #role{attr = Attr = #attr{js = V}}) when Flag > 0 ->
    case lists:keyfind(?attr_js, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_,Sum} ->    
            {ok, Role#role{attr = Attr#attr{js = V + Sum*(100+Val)/100}}}
    end;

%% 增加气血上限 （百分比）
do(enchant_add_per, {?attr_hp_max_per, Flag, Val}, SumEqmAttr, Role = #role{hp_max = V}) when Flag > 0 ->
    case lists:keyfind(?attr_hp_max, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_, Sum} ->
            {ok, Role#role{hp_max = V + Sum*Val/100}}
    end;

%% 增加法术上限 （百分比）
do(enchant_add_per, {?attr_mp_max_per, Flag, Val}, SumEqmAttr, Role = #role{mp_max = V}) when Flag > 0 ->
    case lists:keyfind(?attr_mp_max, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_,Sum} ->
            {ok, Role#role{mp_max = V + Sum*Val/100}}
    end;

%% 增加攻击 （百分比）
do(enchant_add_per, {?attr_dmg_per, Flag, Val}, SumEqmAttr, Role = #role{attr = Attr = #attr{dmg_max = V}}) when Flag > 0 ->
    case lists:keyfind(?attr_dmg, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_,Sum} ->
            {ok, Role#role{attr = Attr#attr{dmg_max = V + Sum*Val/100}}}
    end;

%% 增加防御 （百分比）
do(enchant_add_per, {?attr_defence_per, Flag, Val}, SumEqmAttr, Role = #role{attr = Attr = #attr{defence = V}}) when Flag > 0 ->
    case lists:keyfind(?attr_defence, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_,Sum} ->
            {ok, Role#role{attr = Attr#attr{defence = V + Sum*Val/100}}}
    end;

%% 增加命中 （百分比）
do(enchant_add_per, {?attr_hitrate_per, Flag, Val}, SumEqmAttr, Role = #role{attr = Attr = #attr{hitrate = V}}) when Flag > 0 ->
    case lists:keyfind(?attr_hitrate, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_,Sum} ->
            {ok, Role#role{attr = Attr#attr{hitrate = V + Sum*Val/100}}}
    end;
%% 增加躲闪 （百分比）
do(enchant_add_per, {?attr_evasion_per, Flag, Val}, SumEqmAttr, Role = #role{attr = Attr = #attr{evasion = V}}) when Flag > 0 ->
    case lists:keyfind(?attr_evasion, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_,Sum} ->
            {ok, Role#role{attr = Attr#attr{evasion = V + Sum*Val/100}}}
    end;
%% 增加暴击 （百分比）
do(enchant_add_per, {?attr_critrate_per, Flag, Val}, SumEqmAttr, Role = #role{attr = Attr = #attr{critrate = V}}) when Flag > 0 ->
    case lists:keyfind(?attr_critrate, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_,Sum} ->
            {ok, Role#role{attr = Attr#attr{critrate = V + Sum*Val/100}}}
    end;

%% 抗性加成 (百分比)
do(enchant_add_per, {?attr_rst_all_per, Flag, Val}, SumEqmAttr, Role = #role{attr = Attr = #attr{resist_metal = RM, resist_wood = RW, resist_water = RWa, resist_fire = RF, resist_earth = RE}}) when Flag > 0 ->
    case lists:keyfind(?attr_rst_all, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_,Sum} ->
            {ok, Role#role{attr = Attr#attr{resist_metal = RM + Sum*Val/100,
                        resist_wood = RW + Sum*Val/100,
                        resist_water = RWa + Sum*Val/100,
                        resist_fire = RF + Sum*Val/100,
                        resist_earth = RE + Sum*Val/100}}}
    end;

%% 绝对伤害加成
do(enchant_add_per, {?attr_dmg_magic_per, Flag, Val}, SumEqmAttr, Role = #role{attr = Attr = #attr{dmg_magic = V}}) when Flag > 0 ->
    case lists:keyfind(?attr_dmg_magic, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_,Sum} ->
            {ok, Role#role{attr = Attr#attr{dmg_magic = V + Sum*Val/100}}}
    end;

do(enchant_add_per, {?attr_tenacity_per, Flag, Val}, SumEqmAttr, Role = #role{attr = Attr = #attr{tenacity = V}}) when Flag > 0 ->
    case lists:keyfind(?attr_tenacity_per, 1, SumEqmAttr) of
        false ->
            {ok, Role};
        {_,_,Sum} ->
            {ok, Role#role{attr = Attr#attr{tenacity = V + Sum*Val/100}}}
    end;

do(enchant_add_per, {_Label, _Flag, _Val}, _SumEqmAttr, _Role) ->
    ?ERR("  无法处理的强化加成 LABLE:~w ", [_Label]),
    skip.

%% 百分比加成处理  算总和
add_per({?attr_js_per, Flag, Val},  SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_js, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_,Sum} ->    
            case lists:keyfind(?attr_js, 1, Res) of
                false ->
                    [{?attr_js, Sum*Val/100}];
                {?attr_js, Acc} ->
                    [{?attr_js, Acc + Sum * Val / 100}]
            end
    end;

%% 增加气血上限 （百分比）
add_per({?attr_hp_max_per, Flag, Val}, SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_hp_max, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_, Sum} ->
              case lists:keyfind(?attr_hp_max, 1, Res) of
                false ->
                    [{?attr_hp_max, Sum*Val / 100}];
                {?attr_hp_max, Acc} ->
                    [{?attr_hp_max, Acc + Sum * Val / 100}]
            end          
    end;

%% 增加法术上限 （百分比）
add_per({?attr_mp_max_per, Flag, Val}, SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_mp_max, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_,Sum} ->
              case lists:keyfind(?attr_mp_max, 1, Res) of
                false ->
                    [{?attr_mp_max, Sum*Val/100}];
                {?attr_mp_max, Acc} ->
                    [{?attr_mp_max, Acc + Sum * Val / 100}]
            end
    end;

%% 增加攻击 （百分比）
add_per({?attr_dmg_per, Flag, Val}, SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_dmg, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_,Sum} ->
              case lists:keyfind(?attr_dmg, 1, Res) of
                false ->
                    [{?attr_dmg, Sum*Val/100} | Res];
                {?attr_dmg, Acc} ->
                    [{?attr_dmg, Acc + Sum * Val / 100} | Res]
            end
    end;

%% 增加防御 （百分比）
add_per({?attr_defence_per, Flag, Val}, SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_defence, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_,Sum} ->
            case lists:keyfind(?attr_defence, 1, Res) of
                false ->
                    [{?attr_defence, Sum*Val/100} | Res];
                {?attr_defence, Acc} ->
                    [{?attr_defence, Acc + Sum * Val/100} | Res]
            end
    end;

%% 增加命中 （百分比）
add_per({?attr_hitrate_per, Flag, Val}, SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_hitrate, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_,Sum} ->
            case lists:keyfind(?attr_hitrate, 1, Res) of
                false ->
                    [{?attr_hitrate, Sum*Val/100} | Res];
                {?attr_hitrate, Acc} ->
                    [{?attr_hitrate, Acc + Sum * Val / 100} | Res]
            end
    end;
%% 增加躲闪 （百分比）
add_per({?attr_evasion_per, Flag, Val}, SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_evasion, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_,Sum} ->
            case lists:keyfind(?attr_evasion, 1, Res) of
                false ->
                    [{?attr_evasion, Sum*Val / 100} | Res];
                {?attr_evasion, Acc} ->
                    [{?attr_evasion, Acc + Sum * Val / 100} | Res]
            end
    end;

%% 增加暴击 （百分比）
add_per({?attr_critrate_per, Flag, Val}, SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_critrate, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_,Sum} ->
            case lists:keyfind(?attr_critrate, 1, Res) of
                false ->
                    [{?attr_critrate, Sum*Val/100} | Res];
                {?attr_critrate, Acc} ->
                    [{?attr_critrate, Acc + Sum * Val / 100} | Res]
            end
    end;

%% 抗性加成 (百分比)
add_per({?attr_rst_all_per, Flag, Val}, SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_rst_all, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_,Sum} ->
            case lists:keyfind(?attr_rst_all, 1, Res) of
                false ->
                    [{?attr_rst_metal, Sum*Val/100} | Res];
                {?attr_rst_all, Acc} ->
                    [{?attr_rst_all, Acc + Sum * Val / 100} | Res]
            end
    end;

%% 绝对伤害加成
add_per({?attr_dmg_magic_per, Flag, Val}, SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_dmg_magic, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_,Sum} ->
             case lists:keyfind(?attr_dmg_magic, 1, Res) of
                false ->
                    [{?attr_dmg_magic, Sum*Val / 100} | Res];
                {?attr_dmg_magic, Acc} ->
                    [{?attr_dmg_magic, Acc + Sum * Val / 100} | Res]
            end           
    end;

add_per({?attr_tenacity_per, Flag, Val}, SumEqmAttr, Res) when Flag > 0 ->
    case lists:keyfind(?attr_tenacity_per, 1, SumEqmAttr) of
        false ->
            Res;
        {_,_,Sum} ->
             case lists:keyfind(?attr_tenacity, 1, Res) of
                false ->
                    [{?attr_tenacity, Sum*Val/100} | Res];
                {?attr_tenacity, Acc} ->
                    [{?attr_tenacity, Acc + Sum * Val/100} | Res]
            end
    end;
add_per(_Idx, _SumEqmAttr, Res) ->
    ?DEBUG("无法处理的加成 ~w", [_Idx]),
    Res.
