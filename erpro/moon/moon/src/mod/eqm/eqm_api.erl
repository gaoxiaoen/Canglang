%%----------------------------------------------------
%% 装备系统接口
%% @author shawnoyc@163.com
%%----------------------------------------------------

-module(eqm_api).
-export([
        get_set_attr/1
       ,get_embed_attr/1
       ,get_all_reward/1
       ,get_suit_enchant/1
       ,get_enchant_reward/2
       ,find_skill_attr_push/1
       ,find_skill_attr/1
       ,find_skill_attr/2
       ,calc_fight_capacity/3
       ,calc_fight_capacity/1
       ,get_fightcapacity_point/1
       ,clean_suit/2
       %% ------后台使用-------
       ,adm_get_set_num/2
       ,get_hole_attr/1
       %% ------装备附魔-------
       ,clean_max_fc/2
       ,do_clean_max_fc/1
       ,get_max_fc/2
       ,do_get_max_fc/1

       %% 装备评分
       ,calc_point/2
       ,calc_all_enchant_add/2  %% 计算全身强化加成，存在ITEM SPECIAL里，全要用于客户端显示
       ,get_enchant_add/2
       ,calc_all_eqm_attr/1
       ,get_type_name/1
    ]
).

-include("max_fc.hrl").
-include("item.hrl").
-include("looks.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("assets.hrl").
-include("setting.hrl").
-include("buff.hrl").

%% 获取对应等级的套装件数(橙装)
adm_get_set_num(SetLev, #role{eqm = EqmList}) ->
    adm_get_set_num(SetLev, EqmList, 0).
adm_get_set_num(_SetLev, [], Num) -> Num;
adm_get_set_num(SetLev, [#item{type = Type, quality = ?quality_orange, require_lev = SetLev} | T], Num) ->
    case lists:member(Type, ?eqm_base_type) of
        true -> adm_get_set_num(SetLev, T, Num+1);
        _ -> adm_get_set_num(SetLev, T, Num)
    end;
adm_get_set_num(SetLev, [_ | T], Num) ->
    adm_get_set_num(SetLev, T, Num).

%% 清除防具套装
%% item_hu_shou,06 护手
%% item_hu_wan, 07 护腕
%% item_yao_dai,08 腰带
%% item_xie_zi, 09 鞋子
%% item_ku_zi,  10 裤子
%% item_yi_fu,  11 衣服
clean_suit(armor, EqmList) ->
    [Item || Item = #item{type = Type} <- EqmList, lists:member(Type, [6, 7, 8, 9, 10, 11]) =:= false];

%% 清除饰品套装
%% item_hu_fu,  12 护符
%% item_jie_zhi,13 戒指
clean_suit(jewelry, EqmList) -> 
    [Item || Item = #item{type = Type} <- EqmList, lists:member(Type, [12, 13]) =:= false]. 

%% 获取身上的套装属性加成
%% @spec get_set_attr(EqmList) -> AttrList.
%% EqmList = [#item{}...] 装备列表
%% AttList = [] | [{?attr, Value},...]
get_set_attr(EqmList) ->
    case get_set_attr(EqmList, []) of
        [] -> [];
        SetList ->
            do_attr(SetList, [], [])
    end.

%% 强化额外加的属性
get_enchant_add([], AttrList) -> AttrList;
get_enchant_add([#item{base_id = BaseId, enchant = Enchant}| T], AttrList) ->
    EqmType = eqm:eqm_type(BaseId),
    Weapon = lists:member(EqmType, ?eqm),
    Armor = lists:member(EqmType, ?armor),
    Jewelry = lists:member(EqmType, ?jewelry),
    if
        Weapon ->
            get_enchant_add(T, AttrList ++ enchant_data:get_attr(weapon, Enchant));
        Armor ->
            get_enchant_add(T, AttrList ++ enchant_data:get_attr(fang_ju, Enchant));
        Jewelry ->
            get_enchant_add(T, AttrList ++ enchant_data:get_attr(shou_shi, Enchant));
        true ->
            ?ERR("**** 未知装备类型  ****"),
            get_enchant_add(T, AttrList)
    end.


%% 计算身上的各套装数量
get_set_attr([], SetList) ->
   %% ?DEBUG("*********************  当前套装: ~p~n", [SetList]),
    SetList;
get_set_attr([Item = #item{base_id = BaseId, quality = Quality}| T], SetList) ->
    case get_set(Item) of
        0 ->
            get_set_attr(T, SetList);
        Id -> 
            EqmType = eqm:eqm_type(BaseId),
            SuitType = type_to_craft_type(EqmType),
            case lists:keyfind(SuitType, 3, SetList) of
                false ->
                    get_set_attr(T, [{Id, Quality, SuitType, 1} | SetList]);
                {SetId, Q, _SuitType, Num} ->
                    case Quality >= Q of
                        true -> 
                            get_set_attr(T, lists:keyreplace(SuitType, 3, SetList, {SetId, Q, SuitType, Num + 1}));
                        false ->
                            get_set_attr(T, lists:keyreplace(SuitType, 3, SetList, {Id, Quality, SuitType, Num + 1}))
                    end
            end
    end.

%% 获取宝石套装 
get_embed_attr(Eqm) ->
    case get_embed_lev(Eqm) of
        0 -> [];
        Lev when is_integer(Lev) ->
            embed_data:get_embed_lev(Lev);
        _ -> []
    end.

get_embed_lev(Eqm) ->
    List = ?eqm ++ ?armor ++ [?item_jie_zhi, ?item_hu_fu],
    NewLevList = get_embed_lev(Eqm, List, [{4, 0}, {5, 0}, {6, 0}, {7, 0}, {8, 0}, {9, 0}]),
    do_get_lev(NewLevList).
get_embed_lev([], _, LevList) -> LevList;
get_embed_lev([#item{type = Type, attr = Attr} | T], List, LevList) ->
    case lists:member(Type, List) of
        true ->
            StoneLev1 = get_stone_lev(?attr_hole1, Attr), 
            StoneLev2 = get_stone_lev(?attr_hole2, Attr), 
            StoneLev3 = get_stone_lev(?attr_hole3, Attr), 
            LevList1 = add_embed_num(StoneLev1, LevList),
            LevList2 = add_embed_num(StoneLev2, LevList1),
            LevList3 = add_embed_num(StoneLev3, LevList2),
            get_embed_lev(T, List, LevList3);
        false ->
            get_embed_lev(T, List, LevList)
    end.

add_embed_num(Lev, LevList) ->
    add_embed_num(Lev, LevList, []).
add_embed_num(_Lev, [], NewLevList) -> NewLevList;
add_embed_num(Lev, [{L, Num} | T], NewLevList) when Lev >= L ->
    add_embed_num(Lev, T, [{L, Num + 1} | NewLevList]);
add_embed_num(Lev, [{L, Num} | T], NewLevList) ->
    add_embed_num(Lev, T, [{L, Num} | NewLevList]).

do_get_lev(LevList) ->
    L = [Lev || {Lev, Num} <- LevList, Num =:= 33],
    case L =:= [] of
        true -> 0;
        false ->
            lists:max(L)
    end.

get_stone_lev(Label, Attr) ->
    case lists:keyfind(Label, 1, Attr) of
        {_, 101, 0} -> 0;
        {_, 101, BaseId} -> stone_data:lev(BaseId);
        _ -> 0
    end.


%% @spec get_hole_attr(Eqm) -> AttrList.
%% Eqm = [#item{}, ...]
%% AttrList = [{Name, Flag, Val}, ...]
%% @doc 获取装备打孔属性
get_hole_attr(Eqm) ->
    get_hole_attr(Eqm, []).

get_hole_attr([], AttrList) -> AttrList;
get_hole_attr([#item{attr = Attr} | T], AttrList) ->
    NewAttrList = sum_hole_attr(Attr, AttrList),
    get_hole_attr(T, NewAttrList).

sum_hole_attr([], AttrList) -> AttrList;
sum_hole_attr([{Name, FlagHole, GemId} | T], AttrList) when Name >= ?attr_hole1 andalso Name =< ?attr_hole5 andalso FlagHole =:= 101 andalso GemId > 0 ->
    #item_base{attr = Attr} = case item_data:get(GemId) of
        {false, ErrReason} ->
            ?ERR("宝石属性获取失败：~w~n", [ErrReason]),
            false;
        {ok, Ret} ->
            Ret
    end,
    NewAttrList = do_sum_hole_attr(Attr, AttrList),
    sum_hole_attr(T, NewAttrList);
sum_hole_attr([_H | T], AttrList) ->
    sum_hole_attr(T, AttrList).

do_sum_hole_attr([], AttrList) -> AttrList;
do_sum_hole_attr([Attr = {Name, Flag, Val} | T], AttrList) ->
    NewAttrList = case lists:keyfind(Name, 1, AttrList) of
        false ->
            [Attr | AttrList];
        {_, _, Value} ->
            lists:keyreplace(Name, 1, AttrList, {Name, Flag, Val + Value})
    end,
    do_sum_hole_attr(T, NewAttrList).

%% @spec find_skill_attr_push(Attr, Eqm) -> any()
%% @doc 在装备表中查找角色技能加级效果，并推送；穿脱装备或者洗练时触发
find_skill_attr_push(#role{eqm = [], link = #link{conn_pid = ConnPid}}) ->
    skill:push_append_skill(ConnPid, []);
find_skill_attr_push(Role = #role{career = Career, link = #link{conn_pid = ConnPid}}) ->
    case find_skill_attr(Role) of
        [] ->
            skill:push_append_skill(ConnPid, []);
        List ->
            %% 过滤非本职业的附加技能
            NewList = [{(Type rem 100), Num} || {Type, Num} <- List, (Type div 100) =:= Career],
            skill:update_achievement_data(Role, NewList),
            skill:push_append_skill(ConnPid, NewList)
    end.

%% @spec find_skill_attr(Role) -> list()
%% @doc 在装备表中查找当前职业对应的所有技能附加级列表
find_skill_attr(Role = #role{eqm = Eqm}) ->
    List = find_skill_attr(Eqm, []),
    skill:convert_polish_ascend_skill(Role, List).

%% @spec find_skill_attr(Eqm, L) -> list()
%% @doc 在装备表中查找当前职业对应的所有技能附加级列表
find_skill_attr([], List) ->
    List;
find_skill_attr([#item{durability = 0} | T], List) -> %% 屏蔽耐久为0
    find_skill_attr(T, List);
find_skill_attr([#item{id = Id, attr = Attr} | T], List)
when Id =:= 1 orelse Id =:= 11 orelse Id =:= 12 -> %% 武器/戒指 才会洗练出来加技能等级的属性
    NewList = case lists:keyfind(?attr_skill_lev, 1, Attr) of
        false -> List;
        {_, _, Type} -> %% 单个装备只能有一项
            case lists:keyfind(Type, 1, List) of
                false -> [{Type, 1} | List];
                {Type, Num} -> lists:keyreplace(Type, 1, List, {Type, Num + 1})
            end
    end,
    find_skill_attr(T, NewList);
find_skill_attr([_ | T], List) ->
    find_skill_attr(T, List).

%% 计算套装的属性放进Attr
do_attr([], Attr1, Attr2) ->
    Attr1 ++ Attr2;
do_attr([{Id, _Quality, 1, Num} | T], Attr1, Attr2) ->
    Attr = suit_data:get_attr(Id, Num),
    NewAttr1 = do_del_attr(Attr, Attr1),
    do_attr(T, NewAttr1, Attr2);
do_attr([{Id, _Quality, 2, Num} | T], Attr1, Attr2) ->
    Attr = suit_data:get_attr(Id, Num),
    NewAttr2 = do_del_attr(Attr, Attr2),
    do_attr(T, Attr1, NewAttr2).

do_del_attr([], AllAttr) -> AllAttr;
do_del_attr([{Name, Value} | T], AllAttr) ->
    case lists:keyfind(Name, 1, AllAttr) of
        false ->
            do_del_attr(T, [{Name, Value} | AllAttr]);
        {_, V} when Value > V ->
            do_del_attr(T, lists:keyreplace(Name, 1, AllAttr, {Name, Value}));
        _ ->
            do_del_attr(T, AllAttr)
    end.

%% 获取Item的set_id
get_set(#item{base_id = BaseId}) ->
    case item_data:get(BaseId) of
        {ok, BaseItem} ->
            BaseItem#item_base.set_id;
        {false, _R} ->
            0
    end.

%% 清空某个角色最高战力
clean_max_fc(Id, SrvId) ->
    case role_api:lookup(by_id, {Id, SrvId}, #role.pid) of
        {ok, _N, Pid} -> 
            role:apply(async, Pid, {fun do_clean_max_fc/1, []}),
            ok;
        _ -> 
            ?INFO("角色不在线"),
            ok
    end.

%% 获取某个角色的最高战力记录
get_max_fc(Id, SrvId) ->
    case role_api:lookup(by_id, {Id, SrvId}, #role.pid) of
        {ok, _N, Pid} -> 
            role:apply(async, Pid, {fun do_get_max_fc/1, []}),
            ok;
        _ -> 
            ?INFO("角色不在线"),
            ok
    end.

do_clean_max_fc(Role = #role{career = Career, name = Name, max_fc = MaxFc, attr = #attr{fight_capacity = FightCapacity}}) ->
    Now = util:unixtime(),
    NewMaxFc = MaxFc#max_fc{max = FightCapacity, fight_log = [{Career, FightCapacity, Now}]},
    ?INFO("[~s]执行清除最高战力,当前最高战力为:~w",[Name, FightCapacity]),
    {ok, Role#role{max_fc = NewMaxFc}}.

do_get_max_fc(#role{name = Name, career = Career, max_fc = #max_fc{max = Max, fight_log = FightLog}}) ->
    ?INFO("[~s]当前职业[~w]最高战力为:~w, 最高战力历史为:~w",[Name, Career, Max, FightLog]),
    {ok}.

%%
%%职业	敏捷	精神	攻击	防御	金抗	木抗	水抗	火抗	土抗	气血	法力	命中	躲闪	暴击	坚韧
%%真武	100	      1	    5.80 	2   	2.00 	2.00 	2.00 	2.00 	2.00 	1	     0.5	10.00 	10.00 	5.00 	5.00 
%%刺客	100	      1	    6.00 	2	    2.00 	2.00 	2.00 	2.00 	2.00 	1	     0.5	10.00 	10.00 	5.00 	5.00 
%%贤者	100	      2	    6.00 	2	    2.20 	2.20 	2.20 	2.20 	2.20 	1	     0.5	10.00 	11.00 	6.00 	6.00 
%%飞羽	100	      1	    5.50 	2	    2.00 	2.00 	2.00 	2.00 	2.00 	1	     0.5	10.00 	10.00 	5.00 	5.00 
%%骑士	100	      1	    6.00 	1.5	    1.80 	1.80 	1.80 	1.80 	1.80 	0.9	     0.5	9.00 	10.00 	5.00 	5.00 
%% 计算战斗力
%% 实际战斗力=战斗力总值-(∑(BUFF属性加值*属性对应价值因子)+∑((属性值-BUFF属性加值)*BUFF属性加成/(1+BUFF属性加成)*属性对应价值因子))/20
calc_fight_capacity(Role = #role{pid = Pid, max_fc = MaxFc, career = Career, hp_max = HpMax, mp_max = MpMax, attr = Attr = #attr{fight_capacity = FC, dmg_magic = DmgMagic, dmg_min = _DmgMin, dmg_max = DmgMax, aspd = Aspd, js = Js, defence = Defence, resist_metal = ResistMetal, resist_wood = ResistWood, resist_water = ResistWater, resist_earth = ResistEarth, resist_fire = ResistFire, hitrate = Hitrate, evasion = Evasion, critrate = Critrate, tenacity = Tenacity, anti_stun = Stun, anti_silent = Silent, anti_sleep = Sleep, anti_stone = Stone, anti_taunt = Taunt, anti_poison = Poison, anti_seal = Seal}}, RoleMax, RoleMin) ->
    {Paspd, Pjs, Pdmg, Pdefence, Pmetal, Pwood, Pwater, Pfire, Pearth, Php, Pmp, Phitrate, Peva, Pcri, Pten, Pmagic, Pstun, Psilent, Psleep, Pstone, Ptaunt, Ppoison, Pseal} = get_fightcapacity_point(Career),
    %% ?DEBUG("   ++++++++++++++  DmgMin: ~w, DmgMax: ~w", [_DmgMin, DmgMax]),
    FightCapacity = (DmgMax*Pdmg + Js*Pjs + Defence * Pdefence + ResistMetal * Pmetal + ResistWood * Pwood + ResistWater * Pwater + ResistFire * Pfire + ResistEarth * Pearth + HpMax * Php + MpMax * Pmp + Evasion * Peva + Critrate * Pcri + Tenacity * Pten + Stun * Pstun + Psilent * Silent + Psleep * Sleep + Pstone * Stone + Ptaunt * Taunt + Ppoison * Poison + Pseal * Seal + (Aspd - 30) * Paspd + Hitrate * Phitrate + DmgMagic * Pmagic) / 18,
    ?DEBUG("++++++++++++++++++++++  计算前战斗力 ~w  计算后  ~w", [FC, FightCapacity]),
    %%?DEBUG("((DmgMax:~p *Pdmg:~p  Js:~p Pjs:~p  Defence :~p  Pdefence:~p  ResistMetal:~p  Pmetal:~p
    %%    ResistWood:~p  Pwood:~p   ResistWater:~p  Pwater:~p  ResistFire:~p  Pfire:~p  ResistEarth:~p  Pearth:~p 
    %%    HpMax:~p  Php:~p  MpMax:~p  Pmp:~p  Evasion~p  Peva:~p  Critrate:~p  Pcri:~p  Tenacity:~p  Pten:~p  Stun:~p Pstun:~p
    %%    Psilent:~p Silent:~p Psleep:~p  Sleep:~p Pstone:~p Stone:~p  Ptaunt:~p  Taunt:~p  Ppoison:~p  Poison:~p  Pseal:~p Seal:~p
    %%    Aspd:~p Paspd:~p + Hitrate:~p  Phitrate:~p  DmgMagic:~p  Pmagic:~p",
    %%    [
    %%        DmgMax, Pdmg, Js, Pjs, Defence, Pdefence, ResistMetal, Pmetal, ResistWood, Pwood, ResistWater, Pwater, ResistFire, Pfire,
    %%        ResistEarth, Pearth, HpMax, Php, MpMax, Pmp, Evasion, Peva, Critrate, Pcri, Tenacity, Pten, Stun, Pstun, Psilent, Silent,
    %%        Psleep, Sleep, Pstone, Stone, Ptaunt, Taunt, Ppoison, Poison, Pseal, Seal, Aspd, Paspd, Hitrate, Phitrate, DmgMagic, Pmagic
    %%    ]
    %%),
    BuffFc = calc_buff_figth(fix(Role, RoleMax, RoleMin)),
    NewFc = erlang:round(FightCapacity + FC - BuffFc),
    NewMaxFc = modify_max_fc(MaxFc, Career, NewFc), 
    %% ?DEBUG("角色职业[~w]最高战力为:[~w],历史列表为:~w",[Career, NewMaxFc#max_fc.max, NewMaxFc#max_fc.fight_log]),
    NewRole = Role#role{attr = Attr#attr{fight_capacity = erlang:round(NewFc)}, max_fc = NewMaxFc},
    case is_pid(Pid) of
        true ->
            NR = role_listener:special_event(NewRole, {20015, NewRole#role.attr#attr.fight_capacity}),
            NR1 = role_listener:special_event(NR, {1025, NR#role.attr#attr.fight_capacity}), %% 战力提升
            guild_mem:update(fight, NR1),
            rank:listener(power, Role, NR1),
            medal:listener(fight_capacity, NR1);
        false -> NewRole
    end.
    % NR1.

%% 计算战力，简单计算，目前古诗大乱斗专用
calc_fight_capacity(Role = #role{career = Career, hp_max = HpMax, mp_max = MpMax, attr = Attr = #attr{fight_capacity = FC, dmg_magic = DmgMagic, dmg_min = DmgMin, dmg_max = DmgMax, aspd = Aspd, js = Js, defence = Defence, resist_metal = ResistMetal, resist_wood = ResistWood, resist_water = ResistWater, resist_earth = ResistEarth, resist_fire = ResistFire, hitrate = Hitrate, evasion = Evasion, critrate = Critrate, tenacity = Tenacity, anti_stun = Stun, anti_silent = Silent, anti_sleep = Sleep, anti_stone = Stone, anti_taunt = Taunt, anti_poison = Poison, anti_seal = Seal}}) ->
    {Paspd, Pjs, Pdmg, Pdefence, Pmetal, Pwood, Pwater, Pfire, Pearth, Php, Pmp, Phitrate, Peva, Pcri, Pten, Pmagic, Pstun, Psilent, Psleep, Pstone, Ptaunt, Ppoison, Pseal} = get_fightcapacity_point(Career),
    FightCapacity = ((DmgMax + DmgMin)/2*Pdmg + Js*Pjs + Defence * Pdefence + ResistMetal * Pmetal + ResistWood * Pwood + ResistWater * Pwater + ResistFire * Pfire + ResistEarth * Pearth + HpMax * Php + MpMax * Pmp + Evasion * Peva + Critrate * Pcri + Tenacity * Pten + Stun * Pstun + Psilent * Silent + Psleep * Sleep + Pstone * Stone + Ptaunt * Taunt + Ppoison * Poison + Pseal * Seal + (Aspd - 35) * Paspd + Hitrate * Phitrate + DmgMagic * Pmagic) / 18,
    NewFc = FightCapacity + FC,
    Role#role{attr = Attr#attr{fight_capacity = erlang:round(NewFc)}}.

fix(Role = #role{hp_max = HpMax, mp_max = MpMax, attr = Attr = #attr{dmg_magic = DmgMagic, dmg_min = DmgMin, dmg_max = DmgMax, aspd = Aspd, js = Js, defence = Defence, resist_metal = ResistMetal, resist_wood = ResistWood, resist_water = ResistWater, resist_earth = ResistEarth, resist_fire = ResistFire, hitrate = Hitrate, evasion = Evasion, critrate = Critrate, tenacity = Tenacity, anti_stun = Stun, anti_silent = Silent, anti_sleep = Sleep, anti_stone = Stone, anti_taunt = Taunt, anti_poison = Poison, anti_seal = Seal}},
    _RoleMax = #role{hp_max = HpMax2, mp_max = MpMax2, attr = #attr{dmg_magic = DmgMagic2, dmg_min = DmgMin2, dmg_max = DmgMax2, aspd = Aspd2, js = Js2, defence = Defence2, resist_metal = ResistMetal2, resist_wood = ResistWood2, resist_water = ResistWater2, resist_earth = ResistEarth2, resist_fire = ResistFire2, hitrate = Hitrate2, evasion = Evasion2, critrate = Critrate2, tenacity = Tenacity2, anti_stun = Stun2, anti_silent = Silent2, anti_sleep = Sleep2, anti_stone = Stone2, anti_taunt = Taunt2, anti_poison = Poison2, anti_seal = Seal2}},
    _RoleMin = #role{hp_max = HpMax1, mp_max = MpMax1, attr = #attr{dmg_magic = DmgMagic1, dmg_min = DmgMin1, dmg_max = DmgMax1, aspd = Aspd1, js = Js1, defence = Defence1, resist_metal = ResistMetal1, resist_wood = ResistWood1, resist_water = ResistWater1, resist_earth = ResistEarth1, resist_fire = ResistFire1, hitrate = Hitrate1, evasion = Evasion1, critrate = Critrate1, tenacity = Tenacity1, anti_stun = Stun1, anti_silent = Silent1, anti_sleep = Sleep1, anti_stone = Stone1, anti_taunt = Taunt1, anti_poison = Poison1, anti_seal = Seal1}}) ->
    Role#role{hp_max = HpMax - (HpMax2 - HpMax1), mp_max = MpMax - (MpMax2 - MpMax1), attr = Attr#attr{dmg_magic = DmgMagic - (DmgMagic2 - DmgMagic1), dmg_min = DmgMin - (DmgMin2 - DmgMin1), dmg_max = DmgMax - (DmgMax2 - DmgMax1), aspd = Aspd - (Aspd2 - Aspd1), js = Js - (Js2 - Js1), defence = Defence - (Defence2 - Defence1), resist_metal = ResistMetal - (ResistMetal2 - ResistMetal1), resist_wood = ResistWood - (ResistWood2 - ResistWood1), resist_water = ResistWater - (ResistWater2 - ResistWater1), resist_earth = ResistEarth - (ResistEarth2 - ResistEarth1), resist_fire = ResistFire - (ResistFire2 - ResistFire1), hitrate = Hitrate - (Hitrate2 - Hitrate1), evasion = Evasion - (Evasion2 - Evasion1), critrate = Critrate - (Critrate2 - Critrate1), tenacity = Tenacity - (Tenacity2 - Tenacity1), anti_stun = Stun - (Stun2 - Stun1), anti_silent = Silent - (Silent2 - Silent1), anti_sleep = Sleep - (Sleep2 - Sleep1), anti_stone = Stone - (Stone2 - Stone1), anti_taunt = Taunt - (Taunt2 - Taunt1), anti_poison = Poison - (Poison2 - Poison1), anti_seal = Seal - (Seal2 - Seal1)}}.

%% buff属性不计入战斗力
calc_buff_figth(Role = #role{career = Career, buff = #rbuff{buff_list = BuffList}}) ->
    Point = get_fightcapacity_point(Career),
    Fc1 = buff_effect:do_fight(BuffList, Point),
    Fc2 = buff_effect:do_ratio_fight(BuffList, Role, Point),
    (Fc1 + Fc2) / 18.

modify_max_fc(MaxFc = #max_fc{fight_log = FightLog}, Career, FightCapacity) ->
    Now = util:unixtime(),
    case lists:keyfind(Career, 1, FightLog) of
        {Career, Fc, Time} ->
            case FightCapacity > Fc of
                true -> %% 更新最高战力
                    NewFightLog = lists:keyreplace(Career, 1, FightLog, {Career, FightCapacity, Now}),
                    MaxFc#max_fc{max = FightCapacity, fight_log = NewFightLog};
                false -> %% 战力低,判断是否过期
                    case Now >= Time + (86400 * 10) of
                        true ->
                            NewFightLog = lists:keyreplace(Career, 1, FightLog, {Career, FightCapacity, Now}),
                            MaxFc#max_fc{max = FightCapacity, fight_log = NewFightLog};
                        false ->
                            MaxFc#max_fc{max = Fc}
                    end
            end;
        false ->
            MaxFc#max_fc{max = FightCapacity, fight_log = [{Career, FightCapacity, Now} | FightLog]};
        _ ->
            MaxFc
    end.

%% {Paspd, Pjs, Pdmg, Pdefence, Pmetal, Pwood, Pwater, Pfire, Pearth, Php, Pmp, Phitrate, Peva, Pcri, Pten, Pmagic, Pstun, Psilent, Psleep, Pstone, Ptaunt, Ppoison, Pseal}
get_fightcapacity_point(_Career) ->
    {200, 3,  7.70,	2,   1,   1,   1,   1,   1,   1,   0.1, 25.00, 25.00, 10.00, 10.00, 7.70, 3, 3, 3, 3, 3, 3, 3}.
%%    case Career of
%%        1 -> {200, 3,  7.70,	2,   1,   1,   1,   1,   1,   1,   0.1, 25.00, 25.00, 10.00, 10.00, 7.70, 3, 3, 3, 3, 3, 3, 3}; 
%%        2 -> {200,	3,	8.00,	2,	1.00,	1.00,	1.00,	1.00,	1.00,	1,	0.1,	25.00,	25.00,	10.00,	10.00,	8.00,	3,	3,	3,	3, 3, 3, 3};
%%        3 -> {200,	10,	8.00,	2,	1.10,	1.10,	1.10,	1.10,	1.10,	1,	0.3,	27.00,	27.00,	12.00,	12.00,	8.00,	3,	3,	3,	3,	3,	3,	3};
%%        4 -> {200,	3,  8.00,	2,   1,   1,   1,   1,   1,   1,   0.1, 25.00, 25.00, 10.00, 10.00, 8.00, 3, 3, 3, 3, 3, 3, 3};
%%        5 -> {200,	3,	8.00,	1.5,	0.9,	0.9,	0.9,	0.9,	0.9,	0.9,	0.1,	23.00,	25.00,	10.00,	10.00,	8.00,	3,	3,	3,	3, 3, 3, 3};
%%        6 -> {200,	3,	7.70,	2,	1,	1,   1,   1,   1,   1,   0.1, 25.00, 25.00, 10.00, 10.00, 7.70, 3, 3, 3, 3, 3, 3, 3}
%%    end.

get_all_reward(Eqm) ->
    get_all_reward(Eqm, 20, 0).
get_all_reward(_, Num, _) when Num =< 6 -> {[], 0};
get_all_reward([], Num, Flag) when Flag =:= 10 -> {suit_data:get_all(Num), Num};
get_all_reward([], _, _) -> {[], 0};
get_all_reward([#item{enchant = Enchant} | T], Num, Flag) ->
    case Enchant < Num of
        true -> get_all_reward(T, Enchant, Flag + 1);
        false -> get_all_reward(T, Num, Flag + 1)
    end;
get_all_reward([_ | T], Num, Flag) -> get_all_reward(T, Num, Flag).

%% 获取全身强化等级
get_suit_enchant(Eqm) ->
    get_suit_enchant(Eqm, 100, 0).
get_suit_enchant([], Num, Flag) when Flag =:= 10 -> Num;
get_suit_enchant([], _, _) -> 0;
get_suit_enchant([#item{enchant = Enchant} | T], Num, Flag) ->
    case Enchant < Num of
        true -> get_suit_enchant(T, Enchant, Flag + 1);
        false -> get_suit_enchant(T, Num, Flag + 1)
    end;
get_suit_enchant([_ | T], Num, Flag) -> get_suit_enchant(T, Num, Flag).

%% 强化奖励去掉
get_enchant_reward(_, _AttrList) -> []. %%AttrList;
%%get_enchant_reward([#item{base_id = BaseId, quality = Quality, enchant = Enchant}| T], AttrList) ->
%%    case Quality < ?quality_purple of
%%        true ->
%%            get_enchant_reward(T, AttrList);
%%        false ->
%%            SubType = eqm:eqm_type(BaseId),
%%            EqmInfo = lists:member(SubType, ?eqm),
%%            ArmorInfo = lists:member(SubType, ?armor),
%%            Jewelry = lists:member(SubType, ?jewelry),
%%            Type =
%%            if
%%                EqmInfo -> 1;
%%                ArmorInfo -> 2;
%%                Jewelry -> 3;
%%                true -> 
%%                    ?ERR("..... 未知装备类型"),
%%                    0
%%            end,
%%            Attr = get_part_enchant_reward(Type, Enchant), 
%%            get_enchant_reward(T, Attr ++ AttrList)
%%    end;
%%get_enchant_reward([_Eqm | T], AttrList) ->
%%    get_enchant_reward(T, AttrList).

%% 强化部件的奖励
%% 盔甲
%%get_part_enchant_reward(2, 17) -> [{?attr_hp_max_per, 2}, {?attr_defence_per, 2}];
%%get_part_enchant_reward(2, 18) -> [{?attr_hp_max_per, 3}, {?attr_defence_per,3}];
%%get_part_enchant_reward(2, 19) -> [{?attr_hp_max_per, 5}, {?attr_defence_per,5}];
%%get_part_enchant_reward(2, 20) -> [{?attr_hp_max_per, 8}, {?attr_defence_per,8}];
%%%% 首饰    
%%get_part_enchant_reward(3, 17) -> [{?attr_dmg_per, 2}];
%%get_part_enchant_reward(3, 18) -> [{?attr_dmg_per, 3}];
%%get_part_enchant_reward(3, 19) -> [{?attr_dmg_per, 5}];
%%get_part_enchant_reward(3, 20) -> [{?attr_dmg_per, 8}];
%%%% 武器
%%get_part_enchant_reward(1, 17) -> [{?attr_dmg_per, 2}, {?attr_aspd, 5}];
%%get_part_enchant_reward(1, 18) -> [{?attr_dmg_per, 3}, {?attr_aspd, 10}];
%%get_part_enchant_reward(1, 19) -> [{?attr_dmg_per, 5}, {?attr_aspd, 15}];
%%get_part_enchant_reward(1, 20) -> [{?attr_dmg_per, 8}, {?attr_aspd, 20}];
%%get_part_enchant_reward(_, _) -> [].

%% 防具
type_to_craft_type(?item_yi_fu) -> 1;
type_to_craft_type(?item_hu_shou) -> 1;
type_to_craft_type(?item_hu_wan) -> 1;
type_to_craft_type(?item_ku_zi) -> 1;
type_to_craft_type(?item_yao_dai) -> 1;
type_to_craft_type(?item_xie_zi) -> 1;

%% 饰品
type_to_craft_type(?item_hu_fu) -> 2;
type_to_craft_type(?item_jie_zhi) -> 2;
type_to_craft_type(?item_xiang_lian) -> 2;
type_to_craft_type(_) -> 1. %%

%% 计算装备栏所有装备的基础属性之和
calc_all_eqm_attr(Eqm) ->
    SetAttr = get_set_attr(Eqm),
    Attr = get_enchant_add(Eqm, []),
    Sum = Attr ++ SetAttr,
    Attr1 = [{L,100, V} ||{L,V} <- Sum],
    Acc1 = lists:foldl(fun(A, Acc) -> insert_attr(A, Acc) end, [], Attr1),
    calc_eqms_base_attr(Eqm, Acc1).

calc_eqms_base_attr([], Res) -> [{L,100, V} || {L,V} <- Res];
calc_eqms_base_attr([Item | T], Res) ->
    Res1 = calc_eqm_item(Item, Res),
    calc_eqms_base_attr(T, Res1).

calc_eqm_item(#item{attr = Attr}, Acc) ->
    Fun = fun(AttrItem = {_Label, Flag, V}, AccAttr) ->
            if
                Flag =:= 100 ->
                    insert_attr(AttrItem, AccAttr);
                Flag >= 1000 ->
                    insert_attr(AttrItem, AccAttr);
                Flag =:= 101 andalso V > 0 ->
                    case item_data:get(V) of 
                        {ok, #item_base{attr = StoneAttr}} ->
                            lists:foldl(fun(D={_L,F,_V}, A) -> case F =:= 100 of true -> insert_attr(D, A); false -> A end end, AccAttr, StoneAttr);
                        _ ->
                            AccAttr
                    end;
                true ->
                    AccAttr
            end end,
    lists:foldl(Fun, Acc, Attr).

insert_attr({Label, _F, V}, AttrList) ->
    case lists:keyfind(Label, 1, AttrList) of
        false ->
            [{Label, V} | AttrList];
        {Label, V1} ->
            lists:keyreplace(Label, 1, AttrList, {Label, V1+V})
    end.


% （等级颜色属性所加战斗力）*（1+强化等级*0.05）+鉴定属性所加战斗力+宝石属性所加战斗力
% -> #item{}
calc_point(Item = #item{attr = Attr, special = Spec}, Career) ->
    ?DEBUG("---calc --Attr:~w~n",[Attr]),
    %%计算等级颜色属性带来的属性加成
    BaseAttr = [{Label1,Value1} || {Label1,Flag1,Value1} <- Attr, Flag1 =:= 100],
    ?DEBUG("** BASE ATTR: ~w", [BaseAttr]),
    JdAttr = [{Label2,Value2}||{Label2,Flag2,Value2}<-Attr, Flag2 >= 1000],
    ?DEBUG("** JD ATTR: ~w", [JdAttr]),
    StoneIds = [ BaseId || {_,Flag3, BaseId} <- Attr, Flag3 =:= 101],
    BaseValue = calc_attr_value(BaseAttr, Career, 0),
    JdValue = calc_attr_value(JdAttr, Career, 0),
    StoneValue = calc_stone_value(StoneIds, Career,0),

    ?DEBUG("** BASE VALUE ~w, JdValue: ~w, StoneValue: ~w", [BaseValue, JdValue, StoneValue]),
    Score = round(BaseValue + JdValue + StoneValue),
    ?DEBUG("-------Score-------~w~n",[Score]),
    
    case lists:keyfind(?special_eqm_point, 1, Spec) of
        false ->
            Item#item{special = [{?special_eqm_point, Score} | Spec]};
        _ ->
            Spec1 = lists:keyreplace(?special_eqm_point, 1, Spec, {?special_eqm_point, Score}),
            Item#item{special = Spec1}
    end.



%%计算属性贡献的战斗力
calc_attr_value([], _Career, Value) -> Value/18;
calc_attr_value([{Label, Val}|T], Career, Value) -> 
    case lists:keyfind(Label, 1, attr_parm(Career)) of 
        {_, Parm} ->
            calc_attr_value(T, Career, Val * Parm + Value);
        _ ->
            calc_attr_value(T, Career, Value)
    end;
calc_attr_value([{Label, Flag, Val}|T], Career, Value) when Flag =:= 100 -> 
    case lists:keyfind(Label, 1, attr_parm(Career)) of 
        {_, Parm} ->
            calc_attr_value(T, Career, Val * Parm + Value);
        _ ->
            calc_attr_value(T, Career, Value)
    end;
calc_attr_value([{_Label, _Flag, _Val}|T], Career, Value) -> 
    calc_attr_value(T, Career, Value).

calc_stone_value([], _Career, Value) -> Value;
calc_stone_value([BaseId|T], Career, Value) ->
    case item_data:get(BaseId) of 
        {ok, #item_base{attr = Attr}} ->
            Value1 = calc_attr_value(Attr, Career, Value),
            calc_stone_value(T, Career, Value + Value1);
        _ ->
            calc_stone_value(T, Career, Value)
    end.

%%属性对应的参数
attr_parm(Career) ->
    case Career of
        2 ->
            [{?attr_aspd, 200}, {?attr_js, 3}, {?attr_dmg, 8.00}, {?attr_defence, 2}, {?attr_rst_all, 5.00}, {?attr_hp_max, 1}, {?attr_mp_max, 0.1}, 
            {?attr_hitrate, 25.00}, {?attr_evasion,25.00}, {?attr_critrate, 10.00}, {?attr_tenacity,10.00}, {?attr_dmg_magic, 8.00}];
        3 ->
            [{?attr_aspd, 200}, {?attr_js, 10}, {?attr_dmg, 8.00}, {?attr_defence, 2}, {?attr_rst_all, 5.00}, {?attr_hp_max, 1}, {?attr_mp_max, 0.3}, 
            {?attr_hitrate, 27.00}, {?attr_evasion,27.00}, {?attr_critrate, 12.00}, {?attr_tenacity,12.00}, {?attr_dmg_magic, 8.00}];
        5 ->
            [{?attr_aspd, 200}, {?attr_js, 3}, {?attr_dmg, 8.00}, {?attr_defence, 1.5}, {?attr_rst_all, 4.5}, {?attr_hp_max, 0.9}, {?attr_mp_max, 0.1}, 
            {?attr_hitrate, 23.00}, {?attr_evasion,25.00}, {?attr_critrate, 10.00}, {?attr_tenacity,10.00}, {?attr_dmg_magic, 8.00}]
    end.

calc_all_enchant_add(Item = #item{special = _Spec}, _Eqm) ->
%%    AttrList1 = get_enchant_reward(Eqm, []),
%%    AttrPer1 = [{Name, 100, Val} || {Name, Val} <- AttrList1, Name >= ?attr_xl_per, Name =< ?attr_dmg_magic_per], 
%%    {AttrList2, _AllNum} = eqm_api:get_all_reward(Eqm),
%%    AttrPer2 = [{Name, 100, Val} || {Name, Val} <- AttrList2, Name >= ?attr_xl_per andalso Name =< ?attr_dmg_magic_per],
%%    %% ?DEBUG("奖励属性 ~w", [AttrPer1 ++ AttrPer2]),
%%    SumEqmAttr = eqm_api:calc_all_eqm_attr(Eqm),
%%    Add = do_calc_all_enchant_add(AttrPer1++AttrPer2, SumEqmAttr, []),
%%    Spec1 = [A || A = {Name,_} <- Spec, Name =< 1000],
%%    Spec2 = [{Name + 1000, erlang:round(V)} || {Name, V} <- Add],
        Item#item{}.

%%do_calc_all_enchant_add([], _SumEqmAttr, Res) -> Res;
%%do_calc_all_enchant_add([Attr | T], SumEqmAttr, Res) ->
%%    do_calc_all_enchant_add(T, SumEqmAttr, eqm_effect:add_per(Attr, SumEqmAttr, Res)).

get_type_name(EqmBaseId) ->
    SubType = eqm:eqm_type(EqmBaseId),
    TypeEqm = lists:member(SubType, ?eqm),
    TypeArmor = lists:member(SubType, ?armor),
    TypeJew = lists:member(SubType, ?jewelry),
    if
        TypeEqm =:= true ->
            weapon;
        TypeArmor =:= true ->
            fang_ju;
        TypeJew =:= true ->
            shou_shi;
        true ->
            false
    end.
