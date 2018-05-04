%%----------------------------------------------------
%% BUFF作用效果处理
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(buff_effect).
-export([
        do/2
        ,do_ratio/2
        ,use_pool/1
        ,do_fight/2
        ,do_ratio_fight/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("buff.hrl").
-include("ratio.hrl").
-include("link.hrl").
%%
-include("pet.hrl").

%% ****************************************************
%% BUFF的属性计算需要分开加值和加比率两部分计算
%% 需要注意容错处理时的匹配问题
%% ****************************************************

%% @spec use_pool(Role) -> NewRole
%% Role = tuple()
%% @doc 判断并结算气血包
%% </div>注意:死亡状态不做计算</div>
use_pool(Role = #role{status = ?status_die}) ->
    Role; %% 死亡
use_pool(Role = #role{event = ?event_arena_match}) ->
    Role; %% 竞技中
use_pool(Role = #role{event = ?event_top_fight_match}) ->
    Role; %% 巅峰对决
use_pool(Role = #role{event = ?event_cross_king_match}) ->
    Role; %% 竞技中
use_pool(Role = #role{event = ?event_guild_arena}) ->
    Role; %% 帮战中
use_pool(Role = #role{hp = HpMax, mp = MpMax, hp_max = HpMax, mp_max = MpMax}) ->
    Role;
use_pool(Role = #role{hp = Hp}) when Hp =< 0 ->
    Role;
use_pool(Role = #role{hp = Hp, mp = Mp, link = #link{conn_pid = ConnPid}}) ->
    NR = do_pool(hp_pool, Role),
    R2 = #role{hp = BuffHp, mp = BuffMp} = case do_pool(mp_pool, NR) of
        R0 = #role{hp = Hp, mp = Mp} ->
            R0;
        R1 = #role{buff = #rbuff{buff_list = Buff}} ->
            Msg = buff:bufflist_to_client(Buff),
            sys_conn:pack_send(ConnPid, 10400, {Msg}),
            R1
    end,
    R3 = do_pool(hp_shortcut, R2),
    case do_pool(mp_shortcut, R3) of
        R4 = #role{hp = BuffHp, mp = BuffMp} ->
            R4;
        R5 = #role{buff = #rbuff{shortcut_pool = ShortCutPool}} ->
            Msg2 = buff:shortcut_to_client(ShortCutPool),
            sys_conn:pack_send(ConnPid, 10403, {Msg2}),
            R5
    end.

%% @spec do(Effect, Role) -> {ok, NewRole} | {false, Reason}
%% @doc 添加Buff加值效果
%% Effect = list()  BUFF效果配置数据
%% Role = NewRole = #role{} 角色数据
%% Reason = binary() 处理失败原因
do([], Role) -> {ok, Role};
do([H | T], Role) ->
    case do(H, Role) of
        %% skip表明此Buff已经处理完成，跳过其它的处理
        {skip, NewRole} -> do(T, NewRole);
        {ok, NewRole} -> do(T, NewRole);
        {false, Reason} -> {false, Reason}
    end;

%% 增加气血上限
do({hp_max, Val},  Role = #role{hp_max = V}) ->
    {ok, Role#role{hp_max = V + Val}};

%% 增加法术上限
do({mp_max, Val},  Role = #role{mp_max = V}) ->
    {ok, Role#role{mp_max = V + Val}};

%% 增加精神
do({js, Val},  Role = #role{attr = Attr = #attr{js = V}}) ->
    {ok, Role#role{attr = Attr#attr{js = V + Val}}};

%% 增加攻击力
do({dmg, Val},  Role = #role{attr = Attr = #attr{dmg_min = Min, dmg_max = Max}}) ->
    {ok, Role#role{attr = Attr#attr{dmg_min = Val + Min, dmg_max = Val + Max}}};

%% 增加防御
do({defence, Val}, Role = #role{attr = Attr = #attr{defence = V}}) ->
    {ok, Role#role{attr = Attr#attr{defence = Val + V}}};

%% 增加命中
do({hitrate, Val}, Role = #role{attr = Attr = #attr{hitrate = V}}) ->
    {ok, Role#role{attr = Attr#attr{hitrate = Val + V}}};

%% 增加躲闪
do({evasion, Val}, Role = #role{attr = Attr = #attr{evasion = V}}) ->
    {ok, Role#role{attr = Attr#attr{evasion = Val + V}}};

%% 增加暴击
do({critrate, Val}, Role = #role{attr = Attr = #attr{critrate = V}}) ->
    {ok, Role#role{attr = Attr#attr{critrate = Val + V}}};

%% 增加坚韧
do({tenacity, Val}, Role = #role{attr = Attr = #attr{tenacity = V}}) ->
    {ok, Role#role{attr = Attr#attr{tenacity = Val + V}}};

%% 增加抗眩晕
do({anti_stun, Val}, Role = #role{attr = Attr = #attr{anti_stun = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_stun = Val + V}}};

%% 增加抗睡眠
do({anti_sleep, Val}, Role = #role{attr = Attr = #attr{anti_sleep = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_sleep = Val + V}}};

%% 增加抗遗忘
do({anti_silent, Val}, Role = #role{attr = Attr = #attr{anti_silent = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_silent = Val + V}}};

%% 增加抗石化
do({anti_stone, Val}, Role = #role{attr = Attr = #attr{anti_stone = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_stone = Val + V}}};

%% 增加抗嘲讽
do({anti_taunt, Val}, Role = #role{attr = Attr = #attr{anti_taunt = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_taunt = Val + V}}};

%% 增加抗中毒
do({anti_poison, Val}, Role = #role{attr = Attr = #attr{anti_poison = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_poison = Val + V}}};

%% 增加抗封印
do({anti_seal, Val}, Role = #role{attr = Attr = #attr{anti_seal = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_seal = Val + V}}};

%% 增加金抗
do({resist_metal, Val}, Role = #role{attr = Attr = #attr{resist_metal = RM}}) ->
    {ok, Role#role{attr = Attr#attr{resist_metal = RM + Val}}};

%% 增加木抗
do({resist_wood, Val}, Role = #role{attr = Attr = #attr{resist_wood = RM}}) ->
    {ok, Role#role{attr = Attr#attr{resist_wood = RM + Val}}};

%% 增加水抗
do({resist_water, Val}, Role = #role{attr = Attr = #attr{resist_water = RM}}) ->
    {ok, Role#role{attr = Attr#attr{resist_water = RM + Val}}};

%% 增加火抗
do({resist_fire, Val}, Role = #role{attr = Attr = #attr{resist_fire = RM}}) ->
    {ok, Role#role{attr = Attr#attr{resist_fire = RM + Val}}};

%% 增加土抗
do({resist_earth, Val}, Role = #role{attr = Attr = #attr{resist_earth = RM}}) ->
    {ok, Role#role{attr = Attr#attr{resist_earth = RM + Val}}};

%% 增加全抗
do({resist_all, Val}, Role = #role{attr = Attr = #attr{resist_metal = RM, resist_wood = RW, resist_water = RWa, resist_fire = RF, resist_earth = RE}}) ->
    {ok, Role#role{attr = Attr#attr{resist_metal = RM + Val, resist_wood = RW + Val, resist_water = RWa + Val, resist_fire = RF + Val, resist_earth = RE + Val}}};

%% 增加移动速度
do({speed, Val},  Role = #role{speed = V}) ->
    {ok, Role#role{speed = V + Val}};

%% 降低移动速度
do({speed_reduce, Val},  Role = #role{speed = V}) ->
    {ok, Role#role{speed = V - Val}};

%% 增加法伤
do({dmg_magic, Val}, Role = #role{attr = Attr = #attr{dmg_magic = V}}) ->
    {ok, Role#role{attr = Attr#attr{dmg_magic = V + Val}}};

%% 增加敏捷
do({aspd, Val}, Role = #role{attr = Attr = #attr{aspd = V}}) ->
    {ok, Role#role{attr = Attr#attr{aspd = V + Val}}};

%% 增加反击
do({anti_attack, Val}, Role = #role{attr = Attr = #attr{anti_attack = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_attack = V + Val}}};

%% 匹配处理
do(_Eff, Role) ->
    {skip, Role}.

%% -------------------------------------------------------------------------
%% @spec do(Effect, Role) -> {ok, NewRole} | {false, Reason}
%% @doc 添加Buff百分比加成效果
%% Effect = list()  BUFF效果配置数据
%% Role = NewRole = #role{} 角色数据
%% Reason = binary() 处理失败原因
do_ratio([], Role) -> {ok, Role};
do_ratio([H | T], Role) ->
    case do_ratio(H, Role) of
        {skip, NewRole} -> do_ratio(T, NewRole);
        {ok, NewRole} -> do_ratio(T, NewRole);
        {false, Reason} -> {false, Reason}
    end;

%% 增加经验加成
do_ratio({exp_time, Val}, Role = #role{ratio = Ratio = #ratio{exp = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{exp = V + Val}}};

%% 增加灵力加成
do_ratio({spirit_time, Val}, Role = #role{ratio = Ratio = #ratio{psychic = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{psychic = V + Val}}};

%% 加气血上限百分比
do_ratio({hp_max_per, Val}, Role = #role{ratio = Ratio = #ratio{hp_max = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{hp_max = V + Val}}};

%% 加法力上限百分比
do_ratio({mp_max_per, Val}, Role = #role{ratio = Ratio = #ratio{mp_max = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{mp_max = V + Val}}};

%% 加命中百分比
do_ratio({hitrate_per, Val}, Role = #role{ratio = Ratio = #ratio{hitrate = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{hitrate = V + Val}}};

%% 加躲闪百分比
do_ratio({evasion_per, Val}, Role = #role{ratio = Ratio = #ratio{evasion = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{evasion = V + Val}}};

%% 加防御百分比
do_ratio({df_max_per, Val}, Role = #role{ratio = Ratio = #ratio{defence = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{defence = V + Val}}};

%% 加攻击百分比
do_ratio({dmg_per, Val}, Role = #role{ratio = Ratio = #ratio{dmg = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{dmg = V + Val}}};

%% 加坚韧百分比
do_ratio({tenacity_per, Val}, Role = #role{ratio = Ratio = #ratio{tenacity = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{tenacity = V + Val}}};

%% 加暴怒百分比
do_ratio({critrate_per, Val}, Role = #role{ratio = Ratio = #ratio{critrate = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{critrate = V + Val}}};

%% 增加慧根 （百分比）
do_ratio({js_per, Val},  Role = #role{ratio = Ratio = #ratio{js = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{js = V + Val}}};

%% 绝对伤害加成
do_ratio({dmg_magic_per, Val},  Role = #role{ratio = Ratio = #ratio{dmg_magic = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{dmg_magic = V + Val}}};

%% 抗性加成 (百分比)
do_ratio({rst_all_per, Val}, Role = #role{ratio = Ratio = #ratio{resist_metal = RM, resist_wood = RW, resist_water = RWa, resist_fire = RF, resist_earth = RE}}) ->
    {ok, Role#role{ratio = Ratio#ratio{resist_metal = RM + Val,
                resist_wood = RW + Val,
                resist_water = RWa + Val,
                resist_fire = RF + Val,
                resist_earth = RE + Val}}};

%% 增加移动速度百分比
do_ratio({speed_per, Val},  Role = #role{ratio = Ratio = #ratio{speed = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{speed = V + Val}}};

%% 降低移动速度百分比
do_ratio({speed_per_reduce, Val},  Role = #role{ratio = Ratio = #ratio{speed = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{speed = V - Val}}};

%% 增加木抗百分比
do_ratio({resist_wood_per, Val}, Role = #role{ratio = Ratio = #ratio{resist_wood = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{resist_wood = V + Val}}};

%% 增加水抗百分比
do_ratio({resist_water_per, Val}, Role = #role{ratio = Ratio = #ratio{resist_water = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{resist_water = V + Val}}};

%% 增加火抗百分比
do_ratio({resist_fire_per, Val}, Role = #role{ratio = Ratio = #ratio{resist_fire = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{resist_fire = V + Val}}};

%% 增加土抗百分比
do_ratio({resist_earth_per, Val}, Role = #role{ratio = Ratio = #ratio{resist_earth = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{resist_earth = V + Val}}};

%% 增加金抗百分比
do_ratio({resist_metal_per, Val}, Role = #role{ratio = Ratio = #ratio{resist_metal = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{resist_metal = V + Val}}};

%% 增加抗眩晕
do_ratio({anti_stun_per, Val}, Role = #role{attr = Ratio = #ratio{anti_stun = V}}) ->
    {ok, Role#role{ratio = Ratio = #ratio{anti_stun = Val + V}}};

%% 增加抗睡眠
do_ratio({anti_sleep_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_sleep = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_sleep = Val + V}}};

%% 增加抗遗忘
do_ratio({anti_silent_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_silent = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_silent = Val + V}}};

%% 增加抗石化
do_ratio({anti_stone_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_stone = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_stone = Val + V}}};

%% 增加抗嘲讽
do_ratio({anti_taunt_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_taunt = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_taunt = Val + V}}};

%% 增加抗中毒
do_ratio({anti_poison_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_poison = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_poison = Val + V}}};

%% 增加抗封印
do_ratio({anti_seal_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_seal = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_seal = Val + V}}};

%% 增加宠物经验加成
do_ratio({xcexp_time, Val}, Role = #role{pet = PetBag = #pet_bag{exp_time = ExpTime}}) ->
    {ok, Role#role{pet = PetBag#pet_bag{exp_time = ExpTime + Val}}};

%% 增加打坐经验
do_ratio({sit_exp, Val}, Role = #role{ratio = Ratio = #ratio{sit_exp = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{sit_exp = Val + V}}};

%% 增加打坐灵力
do_ratio({sit_psychic, Val}, Role = #role{ratio = Ratio = #ratio{sit_psychic = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{sit_psychic = Val + V}}};

%% 匹配处理
do_ratio(_, Role) ->
    {skip, Role}.

%%--------------------------------
%% 血包或者法力包效果
do_pool(hp_pool, Role = #role{hp = HpMax, hp_max = HpMax}) -> Role;
do_pool(hp_pool, Role = #role{hp = Hp, hp_max = HpMax, buff = Buffs = #rbuff{buff_list = BuffList}}) ->
    case lists:keyfind(hp_pool, #buff.label, BuffList) of
        false ->
            Role;
        Buff = #buff{label = hp_pool, duration = Pool} ->
            Diff = HpMax - Hp,
            case Pool > Diff of
                true ->
                    NewBuff = Buff#buff{duration = Pool - Diff},
                    NewBuffList = lists:keyreplace(hp_pool, #buff.label, BuffList, NewBuff),
                    Role#role{hp = HpMax, buff = Buffs#rbuff{buff_list = NewBuffList}};
                false ->
                    NewBuffList = lists:keydelete(hp_pool, #buff.label, BuffList),
                    Role#role{hp = Hp + Pool, buff = Buffs#rbuff{buff_list = NewBuffList}}
            end
    end;
do_pool(mp_hool, Role = #role{mp = MpMax, mp_max = MpMax}) -> Role;
do_pool(mp_pool, Role = #role{mp = Mp, mp_max = MpMax, buff = Buffs = #rbuff{buff_list = BuffList}}) ->
    case lists:keyfind(mp_pool, #buff.label, BuffList) of
        false ->
            Role;
        Buff = #buff{label = mp_pool, duration = Pool} ->
            Diff = MpMax - Mp,
            case Pool > Diff of
                true ->
                    NewBuff = Buff#buff{duration = Pool - Diff},
                    NewBuffList = lists:keyreplace(mp_pool, #buff.label, BuffList, NewBuff),
                    Role#role{mp = MpMax, buff = Buffs#rbuff{buff_list = NewBuffList}};
                false ->
                    NewBuffList = lists:keydelete(mp_pool, #buff.label, BuffList),
                    Role#role{mp = Mp + Pool, buff = Buffs#rbuff{buff_list = NewBuffList}}
            end
    end;

do_pool(hp_shortcut, Role = #role{hp = HpMax, hp_max = HpMax}) -> Role;
do_pool(hp_shortcut, Role = #role{hp = Hp, hp_max = HpMax, buff = Rbuff = #rbuff{shortcut_pool = ShortCutPool}}) ->
    case lists:keyfind(hp, 1, ShortCutPool) of
        false -> Role;
        {hp, _, close} -> Role;
        {hp, 0, _} -> Role;
        {hp, HpPool, open} when HpPool > 0 ->
            Diff = HpMax - Hp,
            {AddHp, NewHpPool} = case HpPool > Diff of
                true -> {Diff, HpPool - Diff};
                false -> {HpPool, 0}
            end,
            NewShortCutPool = lists:keyreplace(hp, 1, ShortCutPool, {hp, NewHpPool, open}),
            Role#role{hp = Hp + AddHp, buff = Rbuff#rbuff{shortcut_pool = NewShortCutPool}};
        _Err ->
            ?ERR("发现未知快捷血量回复配置:~w",[_Err]),
            Role
    end;

do_pool(mp_shortcut, Role = #role{mp = MpMax, mp_max = MpMax}) -> Role;
do_pool(mp_shortcut, Role = #role{mp = Mp, mp_max = MpMax, buff = Rbuff = #rbuff{shortcut_pool = ShortCutPool}}) ->
    case lists:keyfind(mp, 1, ShortCutPool) of
        false -> Role;
        {mp, _, close} -> Role;
        {mp, 0, _} -> Role;
        {mp, MpPool, open} ->
            Diff = MpMax - Mp,
            {AddMp, NewMpPool} = case MpPool > Diff of
                true -> {Diff, MpPool - Diff};
                false -> {MpPool, 0}
            end,
            NewShortCutPool = lists:keyreplace(mp, 1, ShortCutPool, {mp, NewMpPool, open}),
            Role#role{mp = Mp + AddMp, buff = Rbuff#rbuff{shortcut_pool = NewShortCutPool}};
        _Err ->
            ?ERR("发现未知快捷法力回复配置:~w",[_Err]),
            Role
    end;
do_pool(_Type, Role) ->
    Role.

%% ----------------------------
%% buff战斗力扣除
%% ---------------------------
do_fight(BuffList, Point) ->
    List = get_all_list(BuffList, []),
    do_fight_capacity(List, Point, 0).

do_ratio_fight(BuffList, Role, Point) ->
    List = get_all_list(BuffList, []),
    do_ratio_fight_capacity(List, Role, List, Point, 0).

get_all_list([], List) -> List;
get_all_list([#buff{effect = Effect, cancel = Cancel} | T], List) ->
    NewList = 
    case Cancel =:= 0 of %% 只计算那些不计入战力的，而不是那些需要附加到战力的 
        true ->
            get_effect(Effect, List);
        false -> List
    end,
    get_all_list(T, NewList).

get_effect([], List) -> List;
get_effect([{Flag, Val} | T], List) ->
    NewList = case lists:keyfind(Flag, 1, List) of
        false -> [{Flag, Val} | List];
        {Flag, V} -> lists:keyreplace(Flag, 1, List, {Flag, Val + V})
    end,
    get_effect(T, NewList).
        
do_fight_capacity([], _Point, Fc) -> Fc;
do_fight_capacity([H | T], Point, Fc) ->
    case do_fight_capacity(H, Point) of
        {skip, 0} -> do_fight_capacity(T, Point, Fc);
        {ok, NewFc} -> do_fight_capacity(T, Point, Fc + NewFc);
        {false, _Reason} -> do_fight_capacity(T, Point, Fc)
    end.

do_ratio_fight_capacity(_List, _Role, [], _Point, Fc) -> Fc;
do_ratio_fight_capacity(List, Role, [H | T], Point, Fc) ->
    case do_ratio_fight_capacity(List, Role, H, Point) of
        {skip, 0} -> do_ratio_fight_capacity(List, Role, T, Point, Fc);
        {ok, NewFc} -> do_ratio_fight_capacity(List, Role, T, Point, Fc + NewFc);
        {false, _Reason} -> do_ratio_fight_capacity(List, Role, T, Point, Fc)
    end.

%% 增加气血上限
do_fight_capacity({hp_max, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Php};

%% 增加法术上限
do_fight_capacity({mp_max, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pmp};

%% 增加精神
do_fight_capacity({js, Val}, {_Paspd, Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pjs};

%% 增加攻击力
do_fight_capacity({dmg, Val}, {_Paspd, _Pjs, Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pdmg};

%% 增加防御
do_fight_capacity({defence, Val}, {_Paspd, _Pjs, _Pdmg, Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pdefence};

%% 增加命中
do_fight_capacity({hitrate, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Phitrate};

%% 增加躲闪
do_fight_capacity({evasion, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Peva};

%% 增加暴击
do_fight_capacity({critrate, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pcri};

%% 增加坚韧
do_fight_capacity({tenacity, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pten};

%% 增加金抗
do_fight_capacity({resist_metal, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pmetal};

%% 增加木抗
do_fight_capacity({resist_wood, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pwood};

%% 增加火抗
do_fight_capacity({resist_fire, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pfire};

%% 增加水抗
do_fight_capacity({resist_water, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pwater};

%% 增加土抗
do_fight_capacity({resist_earth, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pearth};

%% 增加抗眩晕
do_fight_capacity({anti_stun, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pstun};

%% 增加抗睡眠
do_fight_capacity({anti_sleep, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Psleep};

%% 增加抗遗忘
do_fight_capacity({anti_silent, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Psilent};

%% 增加抗石化
do_fight_capacity({anti_stone, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pstone};

%% 增加抗嘲讽
do_fight_capacity({anti_taunt, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Ptaunt};

%% 增加抗中毒
do_fight_capacity({anti_poison, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, Ppoison, _Pseal}) ->
    {ok, Val * Ppoison};

%% 增加抗封印
do_fight_capacity({anti_seal, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, Pseal}) ->
    {ok, Val * Pseal};

%% 增加全抗
do_fight_capacity({resist_all, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, Pmetal, Pwood, Pwater, Pfire, Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    {ok, Val * Pmetal + Val * Pwood + Val * Pfire + Val * Pearth + Val * Pwater};

%% 匹配处理
do_fight_capacity(_, _) ->
    {skip, 0}.

%% -------比例性buff
%% 实际战斗力=战斗力总值-(∑(BUFF属性加值*属性对应价值因子)+∑((属性值-BUFF属性加值)*BUFF属性加成/(1+BUFF属性加成)*属性对应价值因子))/20

%% 增加气血上限
do_ratio_fight_capacity(List, #role{hp_max = HpMax, ratio = #ratio{hp_max = V1}}, {hp_max_per, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(hp_max, 1, List) of
        false -> 0;
        {hp_max, V} -> V
    end,
    {ok, (HpMax - G) * (Val/100) / (V1/100) * Php};

%% 增加法术上限
do_ratio_fight_capacity(List, #role{mp_max = MpMax, ratio = #ratio{mp_max = V1}}, {mp_max_per, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(mp_max, 1, List) of
        false -> 0;
        {mp_max, V} -> V
    end,
    {ok, (MpMax - G) * (Val/100) / (V1/100) * Pmp};

%% 增加攻击力
do_ratio_fight_capacity(List, #role{attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}, ratio = #ratio{dmg = V1}}, {dmg_per, Val}, {_Paspd, _Pjs, Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(dmg, 1, List) of
        false -> 0;
        {dmg, V} -> V
    end,
    {ok, ((DmgMax + DmgMin)/2 - G) * (Val/100) / (V1/100) * Pdmg};

%% 增加防御
do_ratio_fight_capacity(List, #role{attr = #attr{defence = Defence}, ratio = #ratio{defence = V1}}, {df_max_per, Val}, {_Paspd, _Pjs, _Pdmg, Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(defence, 1, List) of
        false -> 0;
        {defence, V} -> V
    end,
    {ok, (Defence - G) * (Val/100) / (V1/100) * Pdefence};

%% 增加命中
do_ratio_fight_capacity(List, #role{attr = #attr{hitrate = Hitrate}, ratio = #ratio{hitrate = V1}}, {hitrate_per, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(hitrate, 1, List) of
        false -> 0;
        {hitrate, V} -> V
    end,
    {ok, (Hitrate - G) * (Val/100) / (V1/100) * Phitrate};

%% 增加躲闪
do_ratio_fight_capacity(List, #role{attr = #attr{evasion = Evasion}, ratio = #ratio{evasion = V1}}, {evasion_per, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(evasion, 1, List) of
        false -> 0;
        {evasion, V} -> V
    end,
    {ok, (Evasion - G) * (Val/100) / (V1/100) * Peva};

%% 增加金抗性
do_ratio_fight_capacity(List, #role{attr = #attr{resist_metal = ResistMetal}, ratio = #ratio{resist_metal = V1}}, {resist_metal_per, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, Pmetal, _Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(resist_metal, 1, List) of
        false -> 0;
        {_, V} -> V
    end,
    {ok, (ResistMetal - G) * (Val/100) / (V1/100) * Pmetal};

%% 增加土抗性
do_ratio_fight_capacity(List, #role{attr = #attr{resist_earth = ResistEarth}, ratio = #ratio{resist_earth = V1}}, {resist_earth_per, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, _Pfire, Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(resist_earth, 1, List) of
        false -> 0;
        {_, V} -> V
    end,
    {ok, (ResistEarth - G) * (Val/100) / (V1/100) * Pearth};

%% 增加木抗性
do_ratio_fight_capacity(List, #role{attr = #attr{resist_wood = ResistWood}, ratio = #ratio{resist_wood = V1}}, {resist_wood_per, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, Pwood, _Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(resist_wood, 1, List) of
        false -> 0;
        {_, V} -> V
    end,
    {ok, (ResistWood - G) * (Val/100) / (V1/100) * Pwood};

%% 增加水抗性
do_ratio_fight_capacity(List, #role{attr = #attr{resist_water = ResistWater}, ratio = #ratio{resist_water = V1}}, {resist_water_per, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, Pwater, _Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(resist_water, 1, List) of
        false -> 0;
        {_, V} -> V
    end,
    {ok, (ResistWater - G) * (Val/100) / (V1/100) * Pwater};

%% 增加火抗性
do_ratio_fight_capacity(List, #role{attr = #attr{resist_fire = ResistFire}, ratio = #ratio{resist_fire = V1}}, {resist_fire_per, Val}, {_Paspd, _Pjs, _Pdmg, _Pdefence, _Pmetal, _Pwood, _Pwater, Pfire, _Pearth, _Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, _Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal}) ->
    G = case lists:keyfind(resist_fire, 1, List) of
        false -> 0;
        {_, V} -> V
    end,
    {ok, (ResistFire - G) * (Val/100) / (V1/100) * Pfire};

%% 匹配处理
do_ratio_fight_capacity(_, _, _, _) ->
    {skip, 0}.
