%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 八月 2016 11:39
%%%-------------------------------------------------------------------
-module(shadow).
-author("hxming").
-include("server.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("pet.hrl").
-include("mount.hrl").
-include("light_weapon.hrl").
-include("magic_weapon.hrl").
-include("wing.hrl").
-include("pet_weapon.hrl").
-include("sword_pool.hrl").
-include("footprint_new.hrl").

%% API
-export([
    create_shadow_for_arena/6,
    create_shadow_for_cross_arena/6,
    create_shadow_for_treasure/7,
    create_shadow_for_dungeon_team/5,
    create_shadow_for_worship/7,
    create_shadow_for_eliminate/5,
    create_shadow_for_skill/7,
    create_shadow_for_cross_elite/5,
    create_shadow_for_cross_1vn/5,
    shadow_ai/1,
    shadow_ai_for_arena/2,
    shadow_ai_for_eliminate/1
]).


%% API
-export([
    cmd_shadow/5, cmd_shadow/3, scene_shadow/0
]).


scene_shadow() ->
    F = fun(Sid) ->
        Scene = data_scene:get(Sid),
        ShadowList = shadow_proc:match_shadow_by_cbp(50000, 30, [], 0),
        F1 = fun(Shadow) ->
            _AttType = util:list_rand_ratio([{?ATTACK_TENDENCY_RANDOM, 0}, {?ATTACK_TENDENCY_MON, 100}, {?ATTACK_TENDENCY_PLAYER, 0}]),
            cmd_shadow(Shadow, Sid, Scene#scene.x, Scene#scene.y, _AttType)
             end,
        lists:foreach(F1, ShadowList)
        end,
    lists:foreach(F, [10001, 10002, 10005]).

cmd_shadow(Player, Sid, X1, Y1, _AttType) ->
    X = abs(util:rand(-3, 3) + X1),
    Y = abs(util:rand(-3, 3) + Y1),
%%    _AttType = util:list_rand_ratio([{?ATTACK_TENDENCY_RANDOM, 0}, {?ATTACK_TENDENCY_MON, 100}, {?ATTACK_TENDENCY_PLAYER, 0}]),
    create_shadow(Player, Sid, Player#player.copy, X, Y, [{type, _AttType}, {is_att_by_player, 0}, {kind, ?MON_KIND_FRIEND}, {group, 1}, {mon_name, Player#player.nickname}, {retime, 5}]).


cmd_shadow(Player, Num, Type) ->
    F = fun(Shadow) ->
        cmd_shadow(Shadow, Player#player.scene, Player#player.x, Player#player.y, Type)
        end,
    lists:foreach(F, shadow_proc:match_shadow_by_cbp(Player#player.cbp, Num, [], 0)).


create_shadow(Player, SceneId, Copy, X, Y, Args) when is_record(Player, player) ->
    Shadow = shadow_init:init_shadow(Player),
    ShadowId =
        case lists:keyfind(shadow_id, 1, Args) of
            false ->
                if Player#player.shadow#st_shadow.shadow_id == 0 -> ?SHADOW_ID;
                    true ->
                        Player#player.shadow#st_shadow.shadow_id
                end;
            {_, Val} -> Val
        end,
    %%特殊参数处理
    MountId =
        case lists:keyfind(mount_id, 1, Args) of
            false ->
                case data_mount:get(Player#player.mount_id) of
                    [] -> Player#player.mount_id;
                    Base ->
                        Base#base_mount.sword_image
                end;
            {_, MountId0} -> MountId0
        end,
    NewShadow = Shadow#player{mount_id = MountId},
    NewArgs = lists:keydelete(shadow_id, 1, Args),
    NewArgs1 = lists:keydelete(mount_id, 1, NewArgs),
    mon_agent:create_mon_cast([ShadowId, SceneId, X, Y, Copy, 1, [{shadow, NewShadow}] ++ NewArgs1]),
%%    ?DEBUG("create shadow ~p ret ~p sid ~p x ~p y~p~n  Copy:~p", [ShadowId, _Ret, SceneId, X, Y, Copy]),
    ok;
create_shadow(Pkey, SceneId, Copy, X, Y, Args) ->
    Shadow = shadow_proc:get_shadow(Pkey),
    mon_agent:create_mon_cast([?SHADOW_ID, SceneId, X, Y, Copy, 1, [{shadow, Shadow}] ++ Args]).

%%竞技场对手
create_shadow_for_arena(Shadow, SceneId, Copy, X, Y, _SkillOrder) ->
    create_shadow(Shadow, SceneId, Copy, X, Y, [{type, ?ATTACK_TENDENCY_PEACE}, {mon_name, Shadow#player.nickname}, {retime, 0}, {change_type, 1.5, ?ATTACK_TENDENCY_MON}]).

%%跨服竞技场
create_shadow_for_cross_arena(Shadow, SceneId, Copy, X, Y, _SkillOrder) ->
    create_shadow(Shadow, SceneId, Copy, X, Y, [{type, ?ATTACK_TENDENCY_PEACE}, {mon_name, Shadow#player.nickname}, {retime, 0}, {change_type, 1.5, ?ATTACK_TENDENCY_MON}]).

%%藏宝图镜像
create_shadow_for_treasure(Shadow, MonId, SceneId, Copy, X, Y, Args) ->
    create_shadow(Shadow#player{pet = #fpet{}}, SceneId, Copy, X, Y, [{type, ?ATTACK_TENDENCY_PLAYER}, {mon_name, io_lib:format(<<"~s[~s]">>, [Shadow#player.nickname, ?T("分身")])}, {shadow_id, MonId}, {owner_key, Shadow#player.key}, {kind, ?MON_KIND_TREASURE_MON}] ++ Args).

%%组队副本
create_shadow_for_dungeon_team(Shadow, SceneId, Copy, X, Y) ->
    create_shadow(Shadow, SceneId, Copy, X, Y, [{group, ?GROUP_DUNGEON}, {type, ?ATTACK_TENDENCY_PEACE}, {mon_name, Shadow#player.nickname}, {kind, ?MON_KIND_FRIEND}, {retime, 3}, {change_type, 3, ?ATTACK_TENDENCY_MON}]).

%%跨服1vn
create_shadow_for_cross_1vn(Shadow, SceneId, Copy, X, Y) ->
    create_shadow(Shadow, SceneId, Copy, X, Y, [{group, Shadow#player.group}, {type, ?ATTACK_TENDENCY_PLAYER}, {mon_name, Shadow#player.nickname}, {change_type, 3, ?ATTACK_TENDENCY_PLAYER}]).


%%主城膜拜
create_shadow_for_worship(Shadow, MonId, SceneId, Copy, X, Y, Args) ->
    create_shadow(Shadow, SceneId, Copy, X, Y, [{type, ?ATTACK_TENDENCY_PEACE}, {mon_name, Shadow#player.nickname}, {shadow_id, MonId}, {kind, ?MON_KIND_FRIEND}, {retime, 1}] ++ Args).

%%消消乐AI
create_shadow_for_eliminate(Shadow, SceneId, Copy, X, Y) ->
    create_shadow(Shadow, SceneId, Copy, X, Y, [{type, ?ATTACK_TENDENCY_PEACE}, {mon_name, Shadow#player.nickname}, {kind, ?MON_KIND_FRIEND}]).

%%技能分身
create_shadow_for_skill(Pkey, SceneId, Copy, X, Y, Args, Group) ->
    Shadow = shadow_proc:get_shadow(Pkey),
    [AttPer, DefPer, HpPer, CritPer, TenPer, HitPer, DodgePer, LifeTime | _] = Args,
    Attribute = Shadow#player.attribute,
    NewAttribute = Attribute#attribute{
        att = round(Attribute#attribute.att * AttPer),
        def = round(Attribute#attribute.def * DefPer),
        hp_lim = round(Attribute#attribute.hp_lim * HpPer),
        crit = round(Attribute#attribute.crit * CritPer),
        hit = round(Attribute#attribute.hit * HitPer),
        dodge = round(Attribute#attribute.dodge * DodgePer),
        ten = round(Attribute#attribute.ten * TenPer)
    },
    Shadow1 = Shadow#player{hp = Attribute#attribute.hp_lim, attribute = NewAttribute},
    {X1, Y1} = scene:random_xy(SceneId, X, Y),
    create_shadow(Shadow1, SceneId, Copy, X1, Y1, [{mon_name, io_lib:format("~s.分身", [Shadow#player.nickname])}, {group, Group}, {life, LifeTime}]).

create_shadow_for_cross_elite(Shadow, SceneId, Copy, X, Y) ->
    create_shadow(Shadow, SceneId, Copy, X, Y, [{type, ?ATTACK_TENDENCY_PEACE}, {mon_name, Shadow#player.nickname}, {retime, 0}, {change_type, 5, ?ATTACK_TENDENCY_PLAYER}]).



shadow_ai(Career) ->

    PetId = util:list_rand(data_pet:get_all()),
    Pet = case data_pet:get(PetId) of
              [] ->
                  #fpet{};
              Base ->
                  #fpet{
                      type_id = Base#base_pet.id,
                      figure = util:list_rand([PetFigureId || {PetFigureId, _} <- tuple_to_list(Base#base_pet.figure)]),
                      name = Base#base_pet.name
                  }
          end,
    LightWeaponStage = util:rand(1, data_light_weapon_stage:max_stage()),
    LightWeapon = data_light_weapon_stage:get(LightWeaponStage),

    WingStage = util:rand(1, 5),
    Wing = data_wing_stage:get(WingStage),

    MagicWeaponStage = util:rand(1, data_magic_weapon_stage:max_stage()),
    MagicWeapon = data_magic_weapon_stage:get(MagicWeaponStage),

    PetWeaponStage = util:rand(1, data_pet_weapon_stage:max_stage()),
    PetWeapon = data_pet_weapon_stage:get(PetWeaponStage),

    SwordPoolStage = util:rand(1, 100),
    SwordPool = data_sword_pool_upgrade:get(SwordPoolStage),

    GodWeaponId = util:list_rand(data_god_weapon:id_list()),

    FootprintStage = util:rand(1, data_footprint_stage:max_stage()),
    Footprint = data_footprint_stage:get(FootprintStage),

    FashionId = util:list_rand(data_fashion:id_list()),
    #player{
        fashion = #fashion_figure{
            fashion_cloth_id = FashionId
        },    %%时装
        career = Career,
        sex = player_util:rand_sex(),
        skill = skill:shadow_skill(Career),
        light_weaponid = LightWeapon#base_light_weapon_stage.weapon_id,
        wing_id = Wing#base_wing_stage.image,
        mount_id = 0,
        magic_weapon_id = MagicWeapon#base_magic_weapon_stage.weapon_id,
        pet_weaponid = PetWeapon#base_pet_weapon_stage.weapon_id,
        sword_pool_figure = SwordPool#base_sword_pool.figure,
        god_weapon_id = GodWeaponId,
        pet = Pet,
        footprint_id = Footprint#base_footprint_stage.footprint_id,
        equip_figure = #equip_figure{
%%            clothing_id = ClothId,
            weapon_id = 2201001
        } %%装备形象

    }.



shadow_ai_for_arena(Career, Sex) ->
    PetId = hd(data_pet:get_all()),
    Pet = case data_pet:get(PetId) of
              [] ->
                  #fpet{};
              Base ->
                  #fpet{
                      type_id = Base#base_pet.id,
                      figure = hd([PetFigureId || {PetFigureId, _} <- tuple_to_list(Base#base_pet.figure)]),
                      name = Base#base_pet.name
                  }
          end,
    LightWeapon = data_light_weapon_stage:get(1),

    Wing = data_wing_stage:get(1),

    Mount = data_mount_stage:get(1),

    MagicWeapon = data_magic_weapon_stage:get(1),

    PetWeapon = data_pet_weapon_stage:get(1),

    SwordPool = data_sword_pool_upgrade:get(1),

    GodWeaponId = hd(data_god_weapon:id_list()),


    #player{
        career = Career,
        sex = Sex,
        skill = skill:shadow_skill(Career),
        light_weaponid = LightWeapon#base_light_weapon_stage.weapon_id,
        wing_id = Wing#base_wing_stage.image,
        mount_id = Mount#base_mount_stage.sword_image,
        magic_weapon_id = MagicWeapon#base_magic_weapon_stage.weapon_id,
        pet_weaponid = PetWeapon#base_pet_weapon_stage.weapon_id,
        sword_pool_figure = SwordPool#base_sword_pool.figure,
        god_weapon_id = GodWeaponId,
        pet = Pet,
        equip_figure = #equip_figure{
            weapon_id = 2201001
        } %%装备形象

    }.

shadow_ai_for_eliminate(Career) ->
    LightWeapon = data_light_weapon_stage:get(1),
    FashionId = util:list_rand(data_fashion:id_list()),
    #player{
        career = Career,
        sex = player_util:rand_sex(),
        fashion = #fashion_figure{fashion_cloth_id = FashionId},
        light_weaponid = LightWeapon#base_light_weapon_stage.weapon_id,
        equip_figure = #equip_figure{weapon_id = 2201001} %%装备形象

    }.
