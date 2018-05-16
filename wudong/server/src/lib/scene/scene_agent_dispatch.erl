%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 八月 2015 下午2:38
%%%-------------------------------------------------------------------
-module(scene_agent_dispatch).
-author("fancy").
-include("server.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("scene.hrl").
%% API
-compile(export_all).

%%更新分类发送
dispatch(Scene, Copy, Data) ->
    case scene:get_scene_pid(Scene, Copy) of
        none ->
            skip;
        ?SCENE_TYPE_CROSS_AREA ->
            cross_area:apply(scene_agent_dispatch, dispatch, [Scene, Copy, Data]);
        ?SCENE_TYPE_CROSS_All ->
            cross_all:apply(scene_agent_dispatch, dispatch, [Scene, Copy, Data]);
        ?SCENE_TYPE_CROSS_WAR_AREA ->
            cross_area:war_apply(scene_agent_dispatch, dispatch, [Scene, Copy, Data]);
        Pid ->
            Pid ! Data
    end.


%%领地战名称
manor_name(SceneId, GuildName) ->
    Data =
        {
            manor_name, [GuildName]
        },
    F = fun(Copy) ->
        dispatch(SceneId, Copy, Data)
    end,
    lists:foreach(F, scene_copy_proc:get_scene_copy_ids(SceneId)).


%%移动
move(Player, X, Y, Type, NowTime) ->
    Data =
        {
            move, [Player#player.key, X, Y, Type, NowTime]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%复活
revive(Player, X, Y, Hp, Mp, Protect, ShowGoldenBody) ->
    Data =
        {
            revive, [Player#player.key, X, Y, Hp, Mp, Protect, ShowGoldenBody]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%加载场景
request_scene_data(Player) ->
    ScenePlayer = scene:player_to_scene_player(Player),
    Data =
        {
            request_scene_data, ScenePlayer
        },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%离开场景
leave_scene(Player) ->
    Data =
        {
            leave, [Player#player.key, Player#player.copy, Player#player.x, Player#player.y]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%移除模型
hide(Player) ->
    Data =
        {
            hide, [Player#player.key, Player#player.copy, Player#player.x, Player#player.y]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%仙盟数据变更
guild_update(Player) ->
    Data = {
        guild, [Player#player.key, Player#player.guild#st_guild.guild_key, Player#player.guild#st_guild.guild_name, Player#player.guild#st_guild.guild_position]
    },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%战队数据变更
war_team_update(Player) ->
    Data = {
        war_team, [Player#player.key, Player#player.war_team#st_war_team.war_team_key, Player#player.war_team#st_war_team.war_team_name, Player#player.war_team#st_war_team.war_team_position]
    },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%队伍数据变更
team_update(Player) ->
    Data = {
        team, [Player#player.key, Player#player.team_key, Player#player.team, Player#player.team_leader]
    },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%属性变动同步
attribute_update(Player) ->
    Data =
        {
            attribute, [Player#player.key, Player#player.attribute, Player#player.scuffle_attribute, Player#player.scuffle_elite_attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%坐骑形象变动同步
mount_id_update(Player) ->
    Data =
        {
            mount_id, [Player#player.key, Player#player.mount_id, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%速度变动同步
speed_update(Player) ->
    Data =
        {
            speed, [Player#player.key, Player#player.attribute#attribute.speed]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%装备信息同步
equip_update(Player) ->
    Data =
        {
            equip_figure, [Player#player.key, Player#player.equip_figure, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%翅膀形象同步
wing_update(Player) ->
    Data =
        {
            wing_figure, [Player#player.key, Player#player.wing_id, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%时装形象同步
fashion_update(Player) ->
    Data =
        {
            fashion_figure, [Player#player.key, Player#player.fashion, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%光武形象同步
light_weapon_update(Player) ->
    Data =
        {
            light_weapon_figure, [Player#player.key, Player#player.light_weaponid, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%妖灵形象同步
pet_weapon_update(Player) ->
    Data =
        {
            pet_weapon_figure, [Player#player.key, Player#player.pet_weaponid, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%变身形象同步
figure(Player) ->
    Data =
        {
            figure, [Player#player.key, Player#player.figure, Player#player.sid, Player#player.evil]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%变身形象同步
battlefield(Player) ->
    Data =
        {
            battlefield, [Player#player.key, Player#player.group, Player#player.combo, Player#player.bf_score]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%护送同步
convoy(Player) ->
    Data =
        {
            convoy, [Player#player.key, Player#player.convoy_state]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%设置保护
protect(Player) ->
    Data =
        {
            protect, [Player#player.key, Player#player.time_mark#time_mark.godt]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%护送抢劫次数同步
convoy_rob(Player, Times) ->
    Data =
        {
            convoy_rob, [Player#player.key, Times]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%宠物形象变动同步
pet_update(Player) ->
    #fpet{
        type_id = TypeId,
        figure = Figure,
        star = Star,
        stage = Stage,
        name = Name,
        att_param = AttParam,
        skill = Skill
    } = Player#player.pet,
    Data =
        {
            pet, [Player#player.key, TypeId, Star, Stage, Figure, Name, Skill, AttParam]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).


%% 宝宝数据场景同步
baby_update(Player) ->
    #fbaby{
        type_id = TypeId,
        figure = Figure,
        step = Step,
        lv = Lv,
        name = Name,
        skill = Skill
    } = Player#player.baby,
    Data =
        {
            baby, [Player#player.key, TypeId, Step, Lv, Figure, Name, Skill]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%称号同步
designation_update(Player) ->
    #player{
        key = Pkey,
        design = DesList
    } = Player,
    Data =
        {
            designation, [Pkey, DesList]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%buff 同步
buff_update(Player) ->
    Data = {
        skillbuff, [Player#player.key, Player#player.buff_list]
    },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%血量魔法同步
hpmp_update(Player) ->
    Data = {
        hpmp, [Player#player.key, Player#player.hp, Player#player.mp]
    },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%妖神变身同步
evil_update(Player) ->
    Data = {
        evil, [Player#player.key, Player#player.node, Player#player.sid, Player#player.sin, Player#player.figure, Player#player.evil]
    },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%采集标记
vip_update(Player) ->
    Data = {
        vip, [Player#player.key, Player#player.vip_lv, Player#player.vip_state]
    },
    dispatch(Player#player.scene, Player#player.copy, Data).

halo_update(Player) ->
    Data = {
        halo, [Player#player.key, Player#player.max_stren_lv]
    },
    dispatch(Player#player.scene, Player#player.copy, Data).

scene_face_update(Player) ->
    Data = {
        scene_face, [Player#player.key, Player#player.scene_face]
    },
    dispatch(Player#player.scene, Player#player.copy, Data).

change_name_update(Player) ->
    Data = {
        change_name, [Player#player.key, Player#player.nickname]
    },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%战场皇冠
crown(Player) ->
    Data =
        {
            crown, [Player#player.key, Player#player.crown]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%坐骑共乘
common_riding(Player) ->
    Data =
        {
            common_mount, Player#player.key, Player#player.common_riding
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

passive_skill(Player, SkillList) ->
    Data =
        {
            passive_skill, Player#player.key, SkillList
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

magic_weapon_skill(Player, SkillList) ->
    Data =
        {
            magic_weapon_skill, Player#player.key, SkillList
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

light_weapon_skill(Player, SkillList) ->
    Data =
        {
            light_weapon_skill, Player#player.key, SkillList
        },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%剑池形象
sword_pool_figure(Player) ->
    Data =
        {
            sword_pool_figure, Player#player.key, Player#player.sword_pool_figure
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%设置观战模式
set_view(Player) ->
    Data =
        {
            set_view, Player#player.key, Player#player.is_view
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%法宝形象
magic_weapon_id(Player) ->
    Data =
        {
            magic_weapon_id, Player#player.key, Player#player.magic_weapon_id, Player#player.attribute
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%十荒神器3
god_weapon_id(Player, WeaponId, SkillId) ->
    Data =
        {
            god_weapon_id, Player#player.key, WeaponId, SkillId
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%更新足迹
footprint_update(Player) ->
    Data =
        {
            footprint_id, Player#player.key, Player#player.footprint_id
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%罪恶更新
pk_value(Player) ->
    Data =
        {
            pk_value, Player#player.key, Player#player.pk
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%等级更新
lv_update(Player) ->
    Data =
        {
            lv_update, Player#player.key, Player#player.lv
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%分组更新
group_update(Player) ->
    Data =
        {
            group_update, Player#player.key, Player#player.group, Player#player.sid
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%温泉更新
hot_well_update(Player) ->
    Data =
        {
            hot_well_update, Player#player.key, Player#player.hot_well
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%传送保护修改
transport_update(Player, IsTransport) ->
    Data =
        {
            transport_update, Player#player.key, IsTransport
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%灵猫形象同步
cat_update(Player) ->
    Data =
        {
            cat_figure, [Player#player.key, Player#player.cat_id, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

golden_body_update(Player) ->
    Data =
        {
            golden_body_figure, [Player#player.key, Player#player.golden_body_id, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

jade_update(_Player) -> skip.
%%   预留场景同步
%%     Data =
%%         {
%%             jade_update, [Player#player.key, Player#player.jade_id, Player#player.attribute]
%%         },
%%     dispatch(Player#player.scene, Player#player.copy, Data).

god_treasure_update(_Player) -> skip.
%%   预留场景同步
%%     Data =
%%         {
%%             god_treasure_update, [Player#player.key, Player#player.god_treasure_id, Player#player.attribute]
%%         },
%%     dispatch(Player#player.scene, Player#player.copy, Data).

update_sit(Player) ->
    Data =
        {
            update_sit, [Player#player.key, Player#player.sit_state, Player#player.show_golden_body]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

update_career(Player) ->
    Data =
        {
            update_career, [Player#player.key, Player#player.new_career]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%婚姻同步
update_marry(Player) ->
    Data =
        {
            update_marry, [Player#player.key, Player#player.marry]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

update_cruise(Player) ->
    Data =
        {
            update_cruise, [Player#player.key, Player#player.marry#marry.cruise_state]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%性别更新
sex_update(Player) ->
    Data =
        {
            sex_update, Player#player.key, Player#player.sex
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%戒指更新
marry_ring_update(Player) ->
    Data =
        {
            marry_ring_update, Player#player.key, Player#player.marry_ring_lv
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%烟花广播
marry_fireworks(Player) ->
    Data =
        {
            marry_fireworks, Player#player.key, Player#player.x, Player#player.y
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%子女翅膀形象同步
baby_wing_update(Player) ->
    Data =
        {
            baby_wing_figure, [Player#player.key, Player#player.baby_wing_id, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%% 钻石vip 同步
update_d_vip(Player) ->
    Data =
        {
            d_vip, Player#player.key, Player#player.d_vip#dvip.vip_type
        },
    dispatch(Player#player.scene, Player#player.copy, Data).


%%子女坐骑同步
baby_mount_update(Player) ->
    Data =
        {
            baby_mount_figure, [Player#player.key, Player#player.baby_mount_id, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%子女武器同步
baby_weapon_update(Player) ->
    Data =
        {
            baby_weapon_figure, [Player#player.key, Player#player.baby_weapon_id, Player#player.attribute]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%更新主技能效果
update_skill_effect(Player) ->
    Data =
        {
            update_skill_effect, [Player#player.key, Player#player.skill_effect]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%更新仙阶
xian_stage_update(Player) ->
    Data =
        {
            xian_stage_update, [Player#player.key, Player#player.xian_stage]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%更新飞仙技能
xian_skill_update(Player) ->
    Data =
        {
            xian_skill_update, [Player#player.key, Player#player.xian_skill, Player#player.passive_skill]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%%更新世界boss次数
update_field_boss_times(Player, Times) ->
    Data =
        {
            field_boss_times, [Player#player.key, Times]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%% 更新剑道阶数
jiandao_stage_update(Player) ->
    Data =
        {
            jiandao_stage_update, [Player#player.key, Player#player.jiandao_stage]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).

%% 更新剑道阶数
wear_element_list(Player) ->
    Data =
        {
            wear_element_list, [Player#player.key, Player#player.wear_element_list]
        },
    dispatch(Player#player.scene, Player#player.copy, Data).