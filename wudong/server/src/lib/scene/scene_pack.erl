%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 八月 2015 下午4:10
%%%-------------------------------------------------------------------
-module(scene_pack).
-author("fancy").
-include("common.hrl").
-include("scene.hrl").

%% API
-export([
    trans12003/1,
    pack_scene_player_helper/1,
    trans12006/2,
    pack_scene_mon_helper/1,
    pack_scene_npc/3
]).

pack_scene_player_helper(ScenePlayerList) ->
    [trans12003(ScenePlayer) || ScenePlayer <- ScenePlayerList, ScenePlayer#scene_player.hp > 0].

%%转换场景玩家信息
trans12003(ScenePlayer) ->
    #scene_player{
        key = Key,
        nickname = NickName,
        avatar = Avatar,
        sn = Sn,
        sn_cur = SnCur,
        sn_name = SnName,
        pf = Pf,
        scene = Scene,
        x = X,
        y = Y,
        hp = Hp,
        mp = Mp,
        attribute = SelfAttribute,
        scuffle_attribute = ScuffleAttribute,
        lv = Lv,
        vip = Vip,
        vip_state  = VipState,
        halo_id = HaloId,
        cbp = Cbp,
        group = Group,
        pk = #pk{pk = PkState, value = PkValue, kill_count = PkKillCount, chivalry = PkChivalry, protect_time = PkProtectTime},
        convoy_state = ConvoyState,
        teamkey = TeamKey,
        career = Career,
        sex = Sex,
        realm = Realm,
        mount_id = MountId,
        guild_key = GuildKey,
        guild_name = GuildName,
        guild_position = GuildPosition,
        pet = #scene_pet{
            type_id = PetTypeId,
            figure = PetFigure,
            name = PetName
        },
        baby = #scene_baby{
            type_id = BabyTypeId,
            figure = BabyFigure,
            name = BabyName
        },
        wing_id = Wing,
        equip_figure = #equip_figure{
            weapon_id = WeaponId,
            clothing_id = ClothingId
        },
        light_weapon_id = LightEeaponid,
        fashion = #fashion_figure{
            fashion_cloth_id = FashionCloth_id,
            fashion_head_id = FashionHeadId
        },
        sprite_lv = Sprite_lv,
        design = DesignList,
        figure = Figure,
        bf_score = BfScore,
        combo = Combo,
        scene_face = SceneFace,
        crown = Crown,
        commom_mount_pkey = CommomMountPkey,
        main_mount_pkey = MainMountPkey,
        commom_mount_state = CommomMountState,
        sword_pool_figure = SwordPoolFigure,
        magic_weapon_id = MagicWeaponFigure,
        god_weapon_id = GodWeaponId,
        pet_weapon_id = PetWeaponId,
        footprint_id = FootprintId,
        is_view = IsView,
        battle_info = #batt_info{buff_list = BuffList},
        hot_well = #phot_well{state = HwSt, pkey = HwPkey},
        cat_id = CatId,
        golden_body_id = GoldenBodyId,
        god_treasure_id = GodTreasureId,
        jade_id = JadeId,
        marry = Marry,
        marry_ring_lv = MyRingLv,
        sit_state = SitState,
        show_golden_body = ShowGoldenBody,
        baby_wing_id = BabyWing,
        baby_mount_id = BabyMountId,
        baby_weapon_id = BabyWeaponId,
        dvip_type = DvipType,
        xian_stage = XianStage0,
        war_team_key = WarTeamKey,
        war_team_name = WarTeamName,
        war_team_position = WarTeamPosition,
        jiandao_stage = JiandaoStage0,
        wear_element_list = WearElementList0
    } = ScenePlayer,
    JiandaoLv = data_menu_open:get(90),
    JiandaoStage = ?IF_ELSE(Lv < JiandaoLv, 0, JiandaoStage0),
    WearElementList = util:list_tuple_to_list(WearElementList0),
    XianOpenLv = data_menu_open:get(71),
    XianStage = ?IF_ELSE(Lv < XianOpenLv, 0, XianStage0),
    Attribute = ?IF_ELSE(Scene == ?SCENE_ID_CROSS_SCUFFLE, ScuffleAttribute, SelfAttribute),
    #attribute{
        hp_lim = Hplim,
        mp_lim = Mplim,
        speed = Speed
    } = Attribute,
    ShowName = ?IF_ELSE(Pf == 888, robot_act:robotname(Career), NickName),
    Now = util:unixtime(),
    PkProtectTime1 = max(0, PkProtectTime - Now),
    BuffListPack = battle_pack:pack_buff_list(BuffList, Now),
    MarryType = Marry#marry.marry_type,
    CoupleName = Marry#marry.couple_name,
    CoupleSex = Marry#marry.couple_sex,
    CoupleKey = Marry#marry.couple_key,
    CruiseState = Marry#marry.cruise_state,
    [
        Key, ShowName, Sn, SnCur, SnName, Pf, X, Y, Hplim, Hp, Mplim,
        Mp, Lv, Vip,VipState, HaloId, Speed, Cbp, Group, ConvoyState, TeamKey, Career,
        Sex, Realm, PkState, PkValue, Wing, WeaponId, ClothingId, LightEeaponid, FashionCloth_id, FootprintId,
        MountId, PetTypeId, PetFigure, PetName, GuildKey, GuildName, Figure, BfScore, Combo,
        GuildPosition, SceneFace, Sprite_lv, Crown, CommomMountState, MainMountPkey, CommomMountPkey, SwordPoolFigure, MagicWeaponFigure, GodWeaponId,
        FashionHeadId, PkKillCount, PkChivalry, PetWeaponId, PkProtectTime1, Avatar, IsView, HwSt, HwPkey, CatId, MarryType, CoupleName, CoupleSex, CoupleKey, MyRingLv, CruiseState,
        GoldenBodyId, JadeId,GodTreasureId, SitState, DvipType, BabyTypeId, BabyFigure, BabyName, BabyWing, BabyMountId, BabyWeaponId, XianStage, ShowGoldenBody, WarTeamKey, WarTeamName, WarTeamPosition,
        BuffListPack, DesignList, JiandaoStage, WearElementList
    ].


pack_scene_mon_helper(MonList) ->
    Now = util:unixtime(),
    [trans12006(Mon, Now) || Mon <- MonList, Mon#mon.hp > 0].

%%转换场景怪物信息
trans12006(Mon, Now) ->
    #mon{
        key = Mkey,
        mid = Mid,
        x = X,
        y = Y,
        hp_lim = Hplim,
        hp = Hp,
        lv = Lv,
        name = Name,
        speed = Speed,
        icon = Icon,
        kind = Kind,
        color = Color,
        group = Group,
        boss = Boss,
        collect_time = CollectTime,
        shadow_key = ShadowKey,
        shadow_status = Shadow,
        show_time = ShowTime,
        guild_key = GuildKey,
        party_key = PartyKey,
        collect_count = CollectCount,
        collect_num = CollectNum
    } = Mon,
    Group2 = util:to_integer(Group),
    Group3 = ?IF_ELSE(Group2 > ?GROUP_MAX, ?GROUP_CALLER, Group2),
    NewShowTime = max(0, ShowTime - Now),
    if
        ShadowKey == 0 ->
            [Mkey, Mid, X, Y, Hplim, Hp, Lv, Name, Speed, Icon, Kind, Color, Group3, Boss, CollectTime, GuildKey, NewShowTime, PartyKey, CollectCount, CollectNum, 0, []];
        true ->
            OpenLv = data_menu_open:get(71),
            XianStage = ?IF_ELSE(Lv < OpenLv, 0, Shadow#player.xian_stage),
            [Mkey, Mid, X, Y, Hplim, Hp, Lv, Name, Speed, Icon, Kind, Color, Group3, Boss, CollectTime, GuildKey, NewShowTime, PartyKey, 0, 0,
                ShadowKey,
                [[
                    Shadow#player.mount_id,
                    Shadow#player.career,
                    Shadow#player.vip_lv,
                    Shadow#player.guild#st_guild.guild_name,
                    Shadow#player.wing_id,
                    Shadow#player.equip_figure#equip_figure.weapon_id,
                    Shadow#player.equip_figure#equip_figure.clothing_id,
                    Shadow#player.light_weaponid,
                    Shadow#player.fashion#fashion_figure.fashion_cloth_id,
                    Shadow#player.footprint_id,
                    Shadow#player.max_stren_lv,
                    Shadow#player.pet#fpet.type_id,
                    Shadow#player.pet#fpet.figure,
                    Shadow#player.pet#fpet.name,
                    Shadow#player.design,
                    Shadow#player.fashion#fashion_figure.fashion_head_id,
                    Shadow#player.sword_pool_figure,
                    Shadow#player.magic_weapon_id,
                    Shadow#player.god_weapon_id,
                    Shadow#player.sex,
                    Shadow#player.pet_weaponid,
                    Shadow#player.cat_id,
                    Shadow#player.golden_body_id,
                    Shadow#player.jade_id,
                    Shadow#player.god_treasure_id,
                    Shadow#player.baby#fbaby.type_id,
                    Shadow#player.baby#fbaby.figure,
                    Shadow#player.baby#fbaby.name,
                    XianStage
                ]]
            ]
    end.


%%打包npc列表
pack_scene_npc(Scene, NpcList, ManorGuildName) ->
    F = fun([Key, NpcId, X, Y, NpcName, Icon, Image, Realm]) ->
        if
            Scene == ?SCENE_ID_MAIN ->
                [Key, NpcId, X, Y, NpcName, Icon, Image, Realm, ManorGuildName];
            true ->
                [Key, NpcId, X, Y, NpcName, Icon, Image, Realm, <<>>]
        end
    end,
    lists:map(F, NpcList).
