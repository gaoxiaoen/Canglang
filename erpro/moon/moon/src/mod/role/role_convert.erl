%%----------------------------------------------------
%% 角色数据结构转换接口
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(role_convert).
-export([
        do/2
    ]
).
-include("common.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("map.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("attr.hrl").
-include("vip.hrl").
-include("team.hrl").
-include("rank.hrl").
-include("assets.hrl").
-include("skill.hrl").
-include("guild.hrl").
-include("pet.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("channel.hrl").
-include("achievement.hrl").
-include("wanted.hrl").
-include("dungeon.hrl").
-include("boss.hrl").
-include("cross_pk.hrl").
-include("practice.hrl").
-include("buff.hrl").
-include("fate.hrl").
-include("story.hrl").
-include("demon.hrl").

%% @spec do(Type, Role) -> {ok, Record} | {error, term()}
%% Type = to_fighter | to_map_role | to_team_member
%% Role = #role{}
%% Record = record()
%% @doc 将角色转换为指定的数据类型

%%--------------------------------------------
%% 转换技能
%%--------------------------------------------
%% convert_skill(SkillIds) -> {[#c_skill{}], [{SkillId, AppendedId}]}
convert_skill(SkillIds) ->
    {L1, L2} = do_convert_skill([], [], SkillIds),
    NL1 = lists:reverse(L1),
    {NL1, L2}.
do_convert_skill(L1, L2, []) -> {L1, L2};
do_convert_skill(L1, L2, [{SkillId, AppendedId}|T]) ->
    case combat_data_skill:get(AppendedId) of
        undefined -> ?ERR("没有找到这个技能的数据,ID=~w", [AppendedId]), do_convert_skill(L1, L2, T);
        CSkill -> do_convert_skill([CSkill|L1], [{SkillId, AppendedId}|L2], T)
    end.

%% convert_demon_skill(Role) -> {[#c_skill{}], [#c_pet_skill{}]}
convert_demon_skill(Role) ->
    L = demon_api:get_combat_skills(Role),
    do_convert_demon_skill(L, [], []).
do_convert_demon_skill([], Cskills, PetSkills) -> {Cskills, PetSkills};
do_convert_demon_skill([false|T], Cskills, PetSkills) -> do_convert_demon_skill(T, Cskills, PetSkills);
do_convert_demon_skill([CombatSkill|T], Cskills, PetSkills) ->
    case combat_script_skill:convert(to_c_skill, CombatSkill) of
        undefined ->
            case combat_script_pet:convert(to_cpet_skill, CombatSkill) of
                undefined ->
                    ?ERR("无法转换这个守护技能:~w", [CombatSkill]),
                    do_convert_demon_skill(T, Cskills, PetSkills);
                PetSkill ->
                    do_convert_demon_skill(T, Cskills, [PetSkill|PetSkills])
            end;
        Cskill ->
            do_convert_demon_skill(T, [Cskill|Cskills], PetSkills)
    end.

%% convert_demon_shape_skill(Role) -> {[#c_skill{}], Dmg, DmgMagic}
convert_demon_shape_skill(Role) ->
    case demon_api:get_shape_combat_info(Role) of
        {Dmg, DmgMagic, SkillId} when SkillId>0 ->
            case combat_data_skill:get(SkillId) of
                undefined ->
                    {[], 0, 0};
                CSkill ->
                    {[CSkill], Dmg, DmgMagic}
            end;
        _ -> {[], 0, 0}
    end.

%% 转换成参战者数据
do(to_fighter, Role = #role{event = Event}) ->
    NRole = 
    case Event of 
        ?event_compete -> 
            medal_compete:add_medal_attr(Role);
        _ -> Role
    end,
    #role{
        pid = Pid, id = {Rid, SrvId}, name = Name, sex = Sex, career = Career,
        lev = Lev, hp = Hp, hp_max = HpMax, mp = Mp, mp_max = MpMax, attr = Attr, vip = Vip,
        looks = Looks, pet = PetBag, combat = CombatParams, event_pid = EventPid, team_pid = TeamPid, auto = Auto, 
        setting = Setting, pos = #pos{x = X, y = Y}, story = Story, demon = RoleDemon} = NRole,


    StoryNpcs = case Story of
        #story{npcs = StoryNpcs_} -> StoryNpcs_;
        _ -> []
    end,
    Demon = case RoleDemon of
        #role_demon{active = ActiveDemon = #demon2{}} -> ActiveDemon;
        _ -> undefined
    end,
    %% 获取所有技能
    {Cskills1, SkillMapping} = convert_skill(skill:get_combat_skill_list(Role) ++ wing_skill:get_combat_skill_list(Role)),
    %% 获取守护技能
    {Cskills2, PetSkills2} = convert_demon_skill(Role),
    %% 获取守护精灵化形技能
    {Cskills3, DemonShapeDmg, DemonShapeDmgMagic} = convert_demon_shape_skill(Role),
    ?DEBUG("[~s]的化形技能:~w, ~w, ~w", [Name, Cskills3, DemonShapeDmg, DemonShapeDmgMagic]),
    Cskills = Cskills1 ++ Cskills2 ++ Cskills3,
    %% 分离主动技能和被动技能
    ActiveSkills = lists:filter(fun(#c_skill{skill_type = SkillType}) -> (SkillType=:=?skill_type_active orelse SkillType=:=?skill_type_assist orelse SkillType =:= ?skill_type_partner) end, Cskills),
    PassiveSkills = lists:filter(fun(#c_skill{skill_type = SkillType}) -> (SkillType=:=?skill_type_passive orelse SkillType =:= ?skill_type_shape) end, Cskills),
    AngerSkills = lists:filter(fun(#c_skill{skill_type = SkillType}) -> SkillType=:=?skill_type_anger end, Cskills),
    AngerPassiveSkills = lists:filter(fun(#c_skill{skill_type = SkillType}) -> SkillType=:=?skill_type_anger_passive end, Cskills),
    %% ?DEBUG("[~s]的主动战斗技能:~w~n被动战斗技能:~w~n怒气技能:~w", [Name, ActiveSkills, PassiveSkills, AngerSkills]),
    %% 转换战斗中可以使用的物品
    CombatItems = [],
    %% ?DEBUG("[~s]的战斗物品:~w", [Name, CombatItems]),
    %% 转换当前参战的战斗宠物和备战宠物
    {ActivePet, BackupPets, PetTotalNum, PetSpeak} = case PetBag of
        undefined -> {undefined, [], 0, []};
        #pet_bag{active = Active, pets = OtherPets, custom_speak = CustomSpeak, pet_limit_num = PLN} -> 
            {A, ActiveNum} = case Active of
                undefined -> {undefined, 0};
                P = #pet{mod = Mod} ->
                    case Mod of
                        1 -> 
                            case combat_script_pet:get(P) of
                                undefined -> {undefined, 0};
                                CP = #c_pet{skills = OldSkills} -> {CP#c_pet{master_pid = Pid, skills = OldSkills ++ PetSkills2}, 1}
                            end;
                        _ -> {undefined, 0}
                    end
            end,
            B = [P2#c_pet{master_pid = Pid, skills = OldSkills ++ PetSkills2} || P2 = #c_pet{skills = OldSkills} <- [combat_script_pet:get(P1) || P1 <- OtherPets]],
            C = if ActiveNum + length(OtherPets) < PLN -> 1;true -> 0 end,
            {A, B, C, CustomSpeak}
    end,
    %% ?DEBUG("[~s]的战斗宠物:~w~n备用宠物:~w", [Name, ActivePet, BackupPets]),
    %% 转换战斗相关参数
    LastSkill = combat_util:match_param(last_skill, CombatParams, 0),
    LastCombatTime = combat_util:match_param(last_combat_time, CombatParams, 0),
    LastCombatResult = combat_util:match_param(last_combat_result, CombatParams, ?combat_result_lost),
    SpecialNpcKilledCount = combat_util:match_param(special_npc_killed_count, CombatParams, 0),
    %%雇佣NPC
    EmployNpc = case is_pid(TeamPid) of
        true -> undefined;  %% 有队伍，无论队员是否暂离，npc都不参战
        false -> npc_employ_mgr:get_combat_employee(Role)
    end,
    %% 获取阵法
    LineupId = skill:get_combat_lineup(Role),
    %% 新帮战加积分buff处理
    GuildArenaScore = guild_arena:get_score_buff(Role),
    GLflag = [{guild_arena_score_buff, GuildArenaScore}],
    %% 转换成参战者
    AngerMax = combat_script_skill:anger_calc_max(?MAX_ANGER, AngerPassiveSkills),
    %% 挂机状态
    IsHook = hook:get_hook_status(Auto),
    %% 挂机技能列表
    ShortCutList = setting:get_shortcuts(Setting),
    %% 头像
    PortraitId = case Vip of
        #vip{portrait_id = PortraitId1} -> PortraitId1;
        _ -> 0
    end,
    VipType = case Vip of
        #vip{type = VipType1} -> VipType1;
        _ -> 0
    end,

    {Attr2, AttrExt2} = {Attr, #attr_ext{}},

    ?DEBUG("role_convert attr ~n~w", [Attr2]),
    F = #fighter{pid = Pid, rid = Rid, srv_id = SrvId, name = Name, type = ?fighter_type_role, career = Career, sex = Sex, lev = Lev, portrait_id = PortraitId, vip_type = VipType, attr = Attr2, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, anger_max = AngerMax, last_skill = LastSkill, last_combat_time = LastCombatTime, last_combat_result = LastCombatResult, special_npc_killed_count = SpecialNpcKilledCount, gl_flag = GLflag, is_hook = IsHook, shortcutlist = ShortCutList, pet_speak = PetSpeak, attr_ext = AttrExt2, x = X, y = Y},
    Fext = #fighter_ext_role {
        looks = Looks, skills = ActiveSkills, passive_skills = PassiveSkills, anger_skills = AngerSkills, 
        anger_passive_skills = AngerPassiveSkills, lineup_id = LineupId, 
        active_pet = ActivePet, backup_pets = BackupPets, rewards = [], pet_num = PetTotalNum, items = CombatItems,
        event = Event, event_pid = EventPid, demon_shape_dmg = DemonShapeDmg, demon_shape_dmg_magic = DemonShapeDmgMagic
    },
    CF = #converted_fighter{pid = Pid, fighter = F, fighter_ext = Fext, skill_mapping = SkillMapping, employ_npc = EmployNpc, story_npcs = StoryNpcs, demon = Demon},
    {ok, CF};

%% 把克隆角色转换成参战者数据
do(to_fighter, {Role = #role{hp_max = HpMax, mp_max = MpMax, pos = Pos}, clone}) ->
    Pos1 = case is_record(Pos, pos) of
        true -> Pos;
        false -> #pos{}
    end,
    Role1 = Role#role{hp = HpMax, mp = MpMax, bag = #bag{}, pos = Pos1, combat = []},
    {ok, CF = #converted_fighter{fighter = F}} = do(to_fighter, Role1),
    F1 = F#fighter{is_clone = ?true, is_auto = ?true},
    {ok, CF#converted_fighter{fighter = F1}};

%% 把幻灵秘境克隆角色转换成参战者数据
do(to_fighter, {Role = #role{hp_max = HpMax, mp_max = MpMax, secret = AI}, lottery_secret}) ->
    Role1 = Role#role{hp = HpMax, mp = MpMax, bag = #bag{}, combat = []},
    {ok, CF = #converted_fighter{fighter = F}} = do(to_fighter, Role1),
    F1 = F#fighter{is_clone = ?true, is_auto = ?true, secret_ai = AI},
    {ok, CF#converted_fighter{fighter = F1}};

%% 克隆角色转换成参战者数据（不带宠物）
do(to_fighter, {Role = #role{hp_max = HpMax, mp_max = MpMax}, clone_no_pet}) ->
    Role1 = Role#role{id = {0, <<>>}, hp = HpMax, mp = MpMax, pet = #pet_bag{}},
    do(to_fighter, {Role1, clone});

%% 克隆角色转换成参战者数据（复制最强的宠物）
do(to_fighter, {Role, clone_strongest_pet}) ->
    CF1 = case do(to_fighter, {Role, clone}) of
        {ok, CF = #converted_fighter{fighter_ext = Ext = #fighter_ext_role{active_pet = undefined, backup_pets = BackupPets}}} ->
            ActivePet = pick_strongest_pet(BackupPets, undefined, 0),
            CF#converted_fighter{fighter_ext = Ext#fighter_ext_role{active_pet = ActivePet}};
        {ok, CF = #converted_fighter{fighter_ext = Ext = #fighter_ext_role{active_pet = ActivePet, backup_pets = BackupPets}}} ->
            ActivePet1 = pick_strongest_pet([ActivePet|BackupPets], undefined, 0),
            CF#converted_fighter{fighter_ext = Ext#fighter_ext_role{active_pet = ActivePet1}};
        _Other -> _Other
    end,
    {ok, CF1};

%% 克隆角色缓存数据转为参战者数据(跨服仙府)
do(to_fighter, {{RoleId, Name, Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, Ascend}, clone_ore}) ->
    CloneRole = #role{id = RoleId, name = Name, sex = Sex, career = Career, lev = Lev, hp = HpMax, mp = MpMax, hp_max = HpMax, mp_max = MpMax, attr = Attr, eqm = Eqm, skill = Skill, pet = PetBag, demon = RoleDemon, looks = Looks, ascend = Ascend},
    do(to_fighter, {CloneRole, clone});

%% (武神坛)
do(to_fighter, {{RoleId, Name, Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, Ascend}, cross_warlord}) ->
    CloneRole = #role{id = RoleId, name = Name, sex = Sex, career = Career, lev = Lev, hp = HpMax, mp = MpMax, hp_max = HpMax, mp_max = MpMax, attr = Attr, eqm = Eqm, skill = Skill, pet = PetBag, demon = RoleDemon, looks = Looks, ascend = Ascend},
    do(to_fighter, {CloneRole, clone});

%% 转换成map_role数据
do(to_map_role, Role = #role{
        pid = Pid, id = {Id, SrvId}, name = Name, link = #link{conn_pid = ConnPid},
        hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax,
        speed = Speed, status = Status, action = Action, ride = Ride, event = Event, vip = #vip{type = VipLev},
        mod = {Mod, _}, label = Label, lev = Lev, sex = Sex, career = Career, realm = Realm, exchange_pid = ExPid,
        pos = #pos{x = X, y = Y, map = MapId, hidden = Hidden, dir = Dir}, 
        team = RoleTeam = #role_team{team_id = TeamId, follow = ?false},
        attr = #attr{fight_capacity = FightCapacity}, looks = Looks, special = Special, cross_srv_id = CrossSrvId
    }
) ->
    {ok, #map_role{
            pid = Pid, rid = Id, srv_id = SrvId, name = Name, conn_pid = ConnPid,
            speed = speed_redefine(Action, Event, Speed, RoleTeam), status = Status, action = Action, ride = Ride, event = Event,
            exchange = is_exchange(ExPid), mod = Mod, label = Label, hidden = Hidden,
            lev = Lev, sex = Sex, career = Career, realm = Realm, hp = Hp, mp = Mp, hp_max = HpMax, guild = guild:role_guild_name(Role),
            mp_max = MpMax, team_id = TeamId, looks = Looks, special = Special, x = X, y = Y,
            map = MapId, dir = Dir, fight_capacity = FightCapacity, cross_srv_id = CrossSrvId, vip_type = VipLev
        }
    };
do(to_map_role, Role = #role{
        pid = Pid, id = {Id, SrvId}, name = Name, link = #link{conn_pid = ConnPid},
        hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax,
        status = Status, action = Action, ride = Ride, event = Event,
        mod = {Mod, _}, label = Label, lev = Lev, sex = Sex, career = Career, realm = Realm, exchange_pid = ExPid,
        pos = #pos{x = X, y = Y, map = MapId, hidden = Hidden, dir = Dir}, vip = #vip{type = VipLev},
        team = RoleTeam = #role_team{team_id = TeamId, follow = ?true, speed = TeamSpeed},
        attr = #attr{fight_capacity = FightCapacity}, looks = Looks, special = Special, cross_srv_id = CrossSrvId
    }
) ->
    {ok, #map_role{
            pid = Pid, rid = Id, srv_id = SrvId, name = Name, conn_pid = ConnPid,
            speed = speed_redefine(Action, Event, TeamSpeed, RoleTeam), status = Status, action = Action, ride = Ride, event = Event,
            exchange = is_exchange(ExPid), mod = Mod, label = Label, hidden = Hidden,
            lev = Lev, sex = Sex, career = Career, realm = Realm, hp = Hp, mp = Mp, hp_max = HpMax, guild = guild:role_guild_name(Role),
            mp_max = MpMax, team_id = TeamId, looks = Looks, special = Special, x = X, y = Y,
            map = MapId, dir = Dir, fight_capacity = FightCapacity, cross_srv_id = CrossSrvId, vip_type = VipLev
        }
    };
%% 无队伍转map_role
do(to_map_role, Role = #role{
        pid = Pid, id = {Id, SrvId}, name = Name, link = #link{conn_pid = ConnPid},
        hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax,
        speed = Speed, status = Status, action = Action, ride = Ride, event = Event,
        mod = {Mod, _}, label = Label, lev = Lev, sex = Sex, career = Career, realm = Realm, exchange_pid = ExPid,
        pos = #pos{x = X, y = Y, map = MapId, hidden = Hidden, dir = Dir}, team = RoleTeam, vip = #vip{type = VipLev},
        attr = #attr{fight_capacity = FightCapacity}, looks = Looks, special = Special, cross_srv_id = CrossSrvId
    }
) ->
    {ok, #map_role{
            pid = Pid, rid = Id, srv_id = SrvId, name = Name, conn_pid = ConnPid,
            speed = speed_redefine(Action, Event, Speed, RoleTeam), status = Status, action = Action, ride = Ride, event = Event,
            exchange = is_exchange(ExPid), mod = Mod, label = Label, hidden = Hidden,
            lev = Lev, sex = Sex, career = Career, realm = Realm, hp = Hp, mp = Mp, hp_max = HpMax, 
            mp_max = MpMax, looks = Looks, special = Special, x = X, y = Y, guild = guild:role_guild_name(Role),
            map = MapId, dir = Dir, fight_capacity = FightCapacity, cross_srv_id = CrossSrvId, vip_type = VipLev
        }
    };
%% 其它转化
do(to_map_role, #role{
        pid = Pid, id = Id, name = Name, link = Link,
        hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax,
        speed = Speed, status = Status, action = Action, ride = Ride, event = Event,
        mod = RawMod, label = Label, lev = Lev, sex = Sex, career = Career, realm = Realm, exchange_pid = ExPid,
        pos = #pos{x = X, y = Y, map = MapId, hidden = Hidden, dir = Dir}, team = RoleTeam,
        attr = Attr, looks = Looks, special = Special, cross_srv_id = CrossSrvId, vip = Vip
    }
) ->
    {Rid, SrvId} = case Id of
        {_Rid, _SrvId} -> {_Rid, _SrvId};
        _ -> {undefined, undefined}
    end,
    ConnPid = case Link of
        #link{conn_pid = _ConnPid} -> _ConnPid;
        _ -> undefined
    end,
    Mod = case RawMod of 
        {_Mod, _} -> _Mod;
        _ -> undefined
    end,
    VipLev = case Vip of
        #vip{type = VipLev_} -> VipLev_;
        _ -> 0
    end,
    FightCapacity = case Attr of
        #attr{fight_capacity = _FightCapacity} -> _FightCapacity;
        _ -> 0
    end,
    {ok, #map_role{
            pid = Pid, rid = Rid, srv_id = SrvId, name = Name, conn_pid = ConnPid,
            speed = speed_redefine(Action, Event, Speed, RoleTeam), status = Status, action = Action, ride = Ride, event = Event,
            exchange = is_exchange(ExPid), mod = Mod, label = Label, hidden = Hidden,
            lev = Lev, sex = Sex, career = Career, realm = Realm, hp = Hp, mp = Mp, hp_max = HpMax, 
            mp_max = MpMax, looks = Looks, special = Special, x = X, y = Y,
            map = MapId, dir = Dir, fight_capacity = FightCapacity, cross_srv_id = CrossSrvId, vip_type = VipLev
        }
    };
%% 转换成map_role数据(调试用)
do(to_map_role, #role{
        id = _Id,  link = _Link,
        vip = _Vip,
        mod = _Mod, 
        pos = _Pos, 
        team = _RoleTeam,
        attr = _Attr
    }
) ->
    ?DUMP({_Id, _Link, _Vip, _Mod, _Pos, _RoleTeam, _Attr}),
    {error, unknow_type};

%% 转换成队伍成员
do(to_team_member, #role{
        pid = Pid, id = Id, name = Name, career = Career, lev = Lev, sex = Sex,
        hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, speed = Speed,
        attr = #attr{fight_capacity = Fight}, pet = Pet,
        link = #link{conn_pid = ConnPid}, skill = #skill_all{lineup = Lineup},
        vip = #vip{type = VipType, portrait_id = PortraitId}
    }
) ->
    PetFight = pet_api:active_power(Pet),
    {ok, #team_member{
            id = Id ,name = Name, pid = Pid, conn_pid = ConnPid, lev = Lev ,career = Career, sex = Sex,
            hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, fight = Fight, pet_fight = PetFight,
            vip_type = VipType, face_id = PortraitId, speed = Speed, lineup = Lineup
        }
    };

%% 转换成队伍邀请/申请数据
do(to_team_apply_msg, #role{
        pid = Pid, id = Id, name = Name, link = #link{conn_pid = ConnPid}
    }
) ->
    {ok, #team_apply_msg{
            id = Id ,pid = Pid, name = Name, conn_pid = ConnPid
        }
    };

%% TODO 2012/07/12 搭车宠物战斗力同步一次角色帮会贡献问题
%% 转换成角色入帮会时需要的数据
do(to_guild_role, #role{
        pid = Pid, id = {Rid, SrvId}, name = Name, lev = Lev, sex = Sex, pet = #pet_bag{pets = Pets, active = Active, deposit = {Deposit, _, _}}, 
        career = Career, vip = #vip{type = Vip, portrait_id = Gravatar}, realm = Realm,
        link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, quit_date = Date, donation = Do}, attr = #attr{fight_capacity = FC}
    }
) ->
    PetFight = lists:max([if is_record(Pet, pet) -> Pet#pet.fight_capacity; true -> 0 end || Pet <- [Active, Deposit |Pets] ]),
    {ok, #guild_role{
            rid = Rid ,srv_id = SrvId ,lev = Lev ,name = Name ,sex = Sex, donation = Do
            ,career = Career ,vip = Vip ,gravatar = Gravatar ,pid = Pid, pet_fight = PetFight
            ,conn_pid = ConnPid ,gid = Gid ,date = Date, fight = FC, realm = Realm}
    };

%% 转换成跨服比武场角色信息
do(to_cross_pk_role, Role = #role{id = {Rid, SrvId}, name = Name, lev = Lev, sex = Sex, career = Career, vip = #vip{type = Vip}, guild = #role_guild{name = Gname}, attr = Attr, team_pid = TeamPid, status = Status, event = Event}) ->
    PetFight = case pet_api:get_max(#pet.fight_capacity, Role) of
        #pet{fight_capacity = PetPower} -> PetPower;
        _ -> 0
    end,
    FC = case Attr of
        #attr{fight_capacity = FC1} -> FC1;
        _ -> 0
    end,
    {ok, #cross_pk_role{id = {Rid, SrvId}, name = Name, lev = Lev, sex = Sex, career = Career, vip = Vip, guild = Gname, fight_capacity = FC, pet_fight = PetFight, status = Status, event = Event, team_pid = TeamPid}
    };

do(to_fate_base, #role{id = RoleId, name = Name, sex = Sex, link = #link{ip = IP}, attr = #attr{fight_capacity = FC}}) ->
    Msg = util:rand_list([?L(<<"找我聊天吧。">>)
            ,?L(<<"你能用什么打动我呢？">>), ?L(<<"缘分摇一摇是一个神奇的东西。">>)
            ,?L(<<"今天你摇了么？">>), ?L(<<"加好友送鲜花哦。">>)]),
    {ok, #fate_role_base_info{id = RoleId, name = Name, sex = Sex, power = FC, ip = IP, msg = Msg}};

%%----------------------------------
%% 其它
%%----------------------------------

%% 转换成后台邮件数据
do(to_mail, #role{id = {Rid, Srvid}, name = Name}) ->
    {ok, {Rid, Srvid, Name}};

%% 容错
do(_Type, _R) ->
    {error, unknow_type}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 场景速度广播重定义
speed_redefine(?action_ride_both, _Event, Speed, #role_team{is_leader = IsLeader}) ->
    ?DEBUG("IsLeader:~w, Speed:~w", [IsLeader, Speed]),
    %% 双人坐骑速度降低
    case IsLeader =:= ?true orelse IsLeader =:= ?false of
        true ->
            case Speed > 250 of
                true -> 250;
                false -> Speed
            end;
        false -> Speed
    end;
speed_redefine(_, _Event, Speed, _) ->
    Speed.

%% 是否交易中
is_exchange(ExcPid) when is_pid(ExcPid) -> ?true;
is_exchange(_) -> ?false.

%% 选出最强的宠物
pick_strongest_pet([], Result, _) -> Result;
pick_strongest_pet([Pet = #c_pet{lev = Lev}|T], _Result, TopLev) when Lev > TopLev ->
    pick_strongest_pet(T, Pet, Lev);
pick_strongest_pet([#c_pet{}|T], Result, TopLev) ->
    pick_strongest_pet(T, Result, TopLev);
pick_strongest_pet(_, _Result, _) -> undefined.
