%%----------------------------------------------------
%% NPC相关数据结构转换接口
%%
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(npc_convert).
-export([
        base_to_npc/3
        ,make_role_attr/2
        ,do/2
        ,do/4
        ,change_attr_mul/3
        ,change_attr_ext_mul/2
    ]
).
-include("common.hrl").
-include("npc.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("combat.hrl").
-include("role.hrl").
-include("boss.hrl").
-include("attr.hrl").

%% @spec base_to_npc(Id, #npc_base, #pos{}) -> #npc{}
%% Id = integer()
%% @doc 将#npc_base{} 转换成 #npc{}
%% 塔防类特殊NPC
base_to_npc(Id, Base = #npc_base{id = BaseId, type = Type, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax,
        lev = Lev, nature = Nature, t_trace = Ttrace, guard_range = GuardRange, off_trace_range = OffTraceRange, attr = Attr,
        slave = Slave, talk = Talk, speed = Speed, special_type = Stype, fun_type = FunType}, Pos)
when is_record(Pos, pos) andalso FunType =:= ?npc_fun_type_guild_td ->
    #npc{id = Id, base = Base, type = Type, base_id = BaseId, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax,
        lev = Lev, nature = Nature, slave = Slave, talk = Talk, t_trace = Ttrace, t_patrol = guild_td_data:get_patrol(BaseId),
        guard_range = GuardRange, off_trace_range = OffTraceRange, attr = Attr, speed = Speed, pos = Pos, special_type = Stype, fun_type = FunType};
base_to_npc(Id, Base = #npc_base{id = BaseId, type = Type, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax,
        lev = Lev, nature = Nature, t_trace = Ttrace, guard_range = GuardRange, off_trace_range = OffTraceRange, attr = Attr,
        slave = Slave, talk = Talk, speed = Speed, special_type = Stype, fun_type = ?npc_fun_type_guard}, Pos)
when is_record(Pos, pos) ->
    #npc{id = Id, base = Base, type = Type, base_id = BaseId, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax,
        lev = Lev, nature = Nature, slave = Slave, talk = Talk, t_trace = Ttrace, t_patrol = guard_data:get_patrol(BaseId),
        guard_range = GuardRange, off_trace_range = OffTraceRange, attr = Attr, speed = Speed, pos = Pos, special_type = Stype, fun_type = ?npc_fun_type_guard};

%% 洛水反击NPC
base_to_npc(Id, Base = #npc_base{id = BaseId, type = Type, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax,
        lev = Lev, nature = Nature, t_trace = Ttrace, guard_range = GuardRange, off_trace_range = OffTraceRange, attr = Attr,
        slave = Slave, talk = Talk, speed = Speed, special_type = Stype, fun_type = ?npc_fun_type_guard_counter}, Pos)
when is_record(Pos, pos) ->
    #npc{id = Id, base = Base, type = Type, base_id = BaseId, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax, lev = Lev, nature = Nature, slave = Slave, talk = Talk, t_trace = Ttrace, t_patrol = guard_counter:get_rand_patrol(), guard_range = GuardRange, off_trace_range = OffTraceRange, attr = Attr, speed = Speed, pos = Pos, special_type = Stype, fun_type = ?npc_fun_type_guard_counter};

%% 春节巡游npc
base_to_npc(Id, Base = #npc_base{id = BaseId, type = Type, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax,
        lev = Lev, nature = Nature, t_trace = Ttrace, guard_range = GuardRange, off_trace_range = OffTraceRange,
        attr = Attr, slave = Slave, talk = Talk, special_type = Stype, fun_type = FunType}, Pos)
when is_record(Pos, pos) andalso FunType =:= ?npc_fun_type_campaign_npc ->
    #npc{id = Id, base = Base, type = Type, base_id = BaseId, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax,
        lev = Lev, nature = Nature, slave = Slave, talk = Talk, t_trace = Ttrace, t_patrol = 3900,
        guard_range = GuardRange, off_trace_range = OffTraceRange, attr = Attr, speed = 80, pos = Pos, special_type = Stype, fun_type = FunType};

%% 普通NPC
base_to_npc(Id, Base = #npc_base{id = BaseId, type = Type, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax,
        lev = Lev, nature = Nature, t_trace = Ttrace, t_patrol = {TpMin, TpMax}, guard_range = GuardRange, off_trace_range = OffTraceRange,
        attr = Attr, slave = Slave, talk = Talk, speed = Speed, special_type = Stype, fun_type = FunType}, Pos) when is_record(Pos, pos) ->
    #npc{id = Id, base = Base, type = Type, base_id = BaseId, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax,
        lev = Lev, nature = Nature, slave = Slave, talk = Talk, t_trace = Ttrace, t_patrol = util:rand(TpMin, TpMax),
        guard_range = GuardRange, off_trace_range = OffTraceRange, attr = Attr, speed = Speed, pos = Pos, special_type = Stype, fun_type = FunType}.

%%--------------------------------------------
%% 转换技能
%%--------------------------------------------
convert_skill(SkillIds) ->
    L = do_convert_skill([], SkillIds),
    lists:reverse(L).
do_convert_skill(L, []) -> L;
do_convert_skill(L, [SkillId|T]) ->
    case combat_data_skill:get(SkillId) of
        undefined -> ?ERR("没有找到这个技能的数据,ID=~w", [SkillId]), do_convert_skill(L, T);
        CSkill -> do_convert_skill([CSkill|L], T)
    end.

%% do(T, #npc{}) -> Rec
%% T = to_fighter | to_map_npc
%% Rec = {ok, #converted_fighter{}} | undefined | #map_npc{}
%% @doc 将NPC数据结构转成其它类型的数据结构

%% NPC数据转成战斗者数据
do(to_fighter, Npc = #npc{id = NpcId,  pid = Pid, name = Name, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax, lev = Lev, base_id = BaseId, base = #npc_base{attr = Attr, rewards = Rewards, prepare_time = PrepareTime, attack_type = AttackType}, owner = OwerId, fun_type = FunType, pos = #pos{x = X, y = Y}}) ->
    %% 获取所有技能
    Cskills = convert_skill(skill:get_combat_skill_list(Npc)),
    %% 分离主动技能和被动技能
    ActiveSkills = lists:filter(fun(#c_skill{passive_type=PassiveType}) -> PassiveType=:=?passive_type_none end, Cskills),
    PassiveSkills = lists:filter(fun(#c_skill{passive_type=PassiveType}) -> PassiveType=/=?passive_type_none end, Cskills),
    %% 判断世界boss类型
    %%{WorldBossType, Hp1, HpMax1, Mp1, MpMax1, WorldBossCreateTime} = case super_boss:is_super_boss(BaseId) of
    %%    true -> 
    %%        case super_boss_data:get(BaseId) of
    %%            {ok, #super_boss_base{hp_max = SuperHpMax, mp_max = SuperMpMax}} ->
    %%                CreateTime = super_boss:get_boss_createtime(BaseId),
    %%                {?world_boss_type_super, SuperHpMax, SuperHpMax, SuperMpMax, SuperMpMax, CreateTime};
    %%            _ -> {?world_boss_type_none, Hp, HpMax, Mp, MpMax, 0}
    %%        end;
    %%    false -> {?world_boss_type_none, Hp, HpMax, Mp, MpMax, 0}
    %%end,
    HpRatio = case platform_cfg:get_cfg(hp_ratio) of
        false -> 1;
        Value -> Value / 100
    end,
    %% 把开出狂暴怪的玩家{id, srv_id}放这里
    GLflag = [{frenzy_owner, OwerId}],
    {WorldBossType, Hp1, HpMax1, Mp1, MpMax1, WorldBossCreateTime} = {?world_boss_type_none, Hp, HpMax, Mp, MpMax, 0},
    F = #fighter{pid = Pid, rid = NpcId, base_id = BaseId, type = ?fighter_type_npc, name = Name, hp = erlang:round(Hp1 * HpRatio), hp_max = erlang:round(HpMax1 * HpRatio), mp = Mp1, mp_max = MpMax1, attack_type = AttackType, attr = Attr, lev = Lev, gl_flag = GLflag, attr_ext = #attr_ext{}, x = X, y = Y},
    Fext = #fighter_ext_npc{skills = ActiveSkills, passive_skills = PassiveSkills, rewards = Rewards, npc_id = NpcId, npc_base_id = BaseId, prepare_time = PrepareTime, world_boss_type = WorldBossType, world_boss_createtime = WorldBossCreateTime, fun_type = FunType},
    CF = #converted_fighter{pid = Pid, fighter = F, fighter_ext = Fext},
    {ok, CF};

do(to_fighter, NpcBaseId) when is_integer(NpcBaseId) ->
    case npc_data:get(NpcBaseId) of
        false ->
            ?ERR("指定base_id[~w]的NPC不存在", [NpcBaseId]),
            undefined;
        {ok, NpcBase} ->
            Npc = npc_convert:base_to_npc(0, NpcBase, #pos{}),
            do(to_fighter, Npc)
    end;

%% 将#npc{}转成#map_npc{}
do(to_map_npc, #npc{id = Id, status = Status, type = Type, base_id = BaseId, name = Name, speed = Speed, lev = Lev, nature = Nature, pos = #pos{map = MapId, x = X, y = Y}}) ->
    #map_npc{id = Id, base_id = BaseId, type = Type, status = Status, name = Name, lev = Lev, speed = Speed, nature = Nature, map = MapId, x = X, y = Y}.


%% @spec do(Type, Npc, Master, MsRela)
%% Type = atom()
%% Npc = #npc{}
%% Master = #role{}
%% MsRela = integer(), 参考combat.hrl的?ms_rela_XXX
%% @doc 转换成参战者数据（需要设雇佣、护送关系时）
do(to_fighter, Npc, #role{pid = Pid}, MsRela) ->
    case do(to_fighter, Npc) of
        {ok, CF = #converted_fighter{fighter = F}} ->
            F1 = F#fighter{ms_rela = MsRela, ms_rela_master_pid = Pid},
            {ok, CF#converted_fighter{fighter = F1}};
        Other -> Other
    end;

do(to_fighter, Npc, _, _) ->
    do(to_fighter, Npc).

%% @spec make_role_attr(Npc, AtkList) -> NewNpc
%% Npc = NewNpc = #npc{}
%% AtkList = [#converted_fighter{}]
%% @doc 某些特殊npc要根据角色属性做变化 
make_role_attr(Npc, _) ->
    Npc.

%%梦溪古谈，心魔
%%@spec change_attr_mul(Attr::#attr{}, Mul::double, IsKeepAspd) -> NewAttr::#attr{}
%%@doc 属性 * 倍数
change_attr_mul(Attr, Mul, IsKeepAspd) when is_record(Attr, attr) ->
     AttrList = erlang:tuple_to_list(Attr),
     F = fun(Elem) ->
            case is_integer(Elem) of
                true ->
                    util:floor(Elem * Mul);
                _ ->
                    Elem
            end
     end,
     NewAttrList = lists:map(F, AttrList),
     TmpAttr = erlang:list_to_tuple(NewAttrList),
     case IsKeepAspd of
         true -> TmpAttr#attr{ver = Attr#attr.ver, aspd = Attr#attr.aspd};
         _ -> TmpAttr#attr{ver = Attr#attr.ver}
    end;
change_attr_mul(Attr, _, _) ->
    Attr.

%%@spec change_attr_ext_mul(AttrExt::#attr_ext{}, Mul::double) -> NewAttrExt::#attr_ext{}
%%拓展属性 * 倍数
change_attr_ext_mul(AttrExt, Mul) when is_record(AttrExt, attr_ext) ->
    AttrExt#attr_ext{
        anti_debuff_injure = AttrExt#attr_ext.anti_debuff_injure * Mul, 
        anti_debuff_atk = AttrExt#attr_ext.anti_debuff_atk * Mul,
        anti_debuff_hitrate = AttrExt#attr_ext.anti_debuff_hitrate * Mul,
        anti_debuff_evasion = AttrExt#attr_ext.anti_debuff_evasion * Mul,
        anti_debuff_critrate = AttrExt#attr_ext.anti_debuff_critrate * Mul          
    };
change_attr_ext_mul(AttrExt, _Mul) -> AttrExt.


