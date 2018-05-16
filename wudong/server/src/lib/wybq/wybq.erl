%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 三月 2017 16:40
%%%-------------------------------------------------------------------
-module(wybq).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("wybq.hrl").

%% API
-export([
    get_my_wybq/1,
    log_out/1,
    update_player/1,

    get_info/1, %% 读取面板信息
    compare/2 %% 做比较
]).

%% 下线时做更新处理
get_my_wybq(#player{key = Pkey, cbp = Cbp, lv = Lv} = Player) ->
    F = fun(Type) ->
        Attr =
            case Type of
                1 -> %% 等级
                    #attribute{}; %% 需求更改
                2 -> %% 装备
                    Att1 = equip_attr:get_equip_all_attribute(),
                    Att2 = smelt_init:get_attribute(),
                    attribute_util:sum_attribute([Att1, Att2]);
                3 -> %% 宠物
                    pet_attr:get_pet_attribute();
                4 -> %% 坐骑
                    mount_attr:get_mount_attr();
                5 -> %% 仙羽
                    wing_attr:get_wing_attr();
                6 -> %% 神兵
                    light_weapon_init:get_attribute();
                7 -> %% 法器
                    magic_weapon_init:get_attribute();
                8 -> %% 十方神器
                    god_weapon_init:get_attribute();
                9 -> %% 经脉
                    meridian:get_meridian_attribute();
                10 -> %% 剑池
                    sword_pool_init:get_sword_pool_attribute();
                11 -> %% 图鉴
                    mon_photo_init:get_attribute();
                12 -> %% 仙盟技能
                    guild_skill:get_guild_skill_attribute();
                13 -> %% 个人技能
                    skill_init:get_skill_passive_attribute();
                14 -> %% 妖灵数据
                    pet_weapon_init:get_attribute();
                15 -> %% 足迹系统
                    footprint:get_attribute();
                16 -> %% 灵猫
                    cat_init:get_attribute();
                17 -> %% 法身
                    golden_body_init:get_attribute();
                18 -> %% 符文
                    fuwen_attr:get_fuwen_all_attribute();
                19 -> %% 姻缘
                    marry:get_attr(Player);
                20 -> %% 宝宝
                    baby_attr:get_baby_attribute();
                21 -> %% 灵羽
                    baby_wing_attr:get_wing_attr();
                22 -> %% 灵骑
                    baby_mount_init:get_attribute();
                23 -> %% 灵弓
                    baby_weapon_init:get_attribute();
                24 -> %% 玉佩
                    jade_init:get_attribute();
                25 -> %% 仙宝
                    god_treasure_init:get_attribute();
                _ ->
                    #attribute{}
            end,
        CombatPower =
            case Type == 1 of %% 等级特殊处理
                true ->
                    Lv;
                false ->
                    attribute_util:calc_combat_power(Attr)
            end,
        {Type, CombatPower}
    end,
    CbpList = lists:map(F, data_wybq:get_all()),
    StWybq = #st_wybq{pkey = Pkey, cbp = Cbp, cbp_list = CbpList, lv = Lv},
    StWybq.

log_out(Player) ->
    StWybq = get_my_wybq(Player),
    wybq_load:update(StWybq),
    ?CAST(wybq_proc:get_server_pid(), {update_ets, StWybq}),
    ok.

update_player(Player) ->
    StWybq = get_my_wybq(Player),
    case player_util:is_new_role(Player) of
        true ->
            wybq_load:update(StWybq);
        _ ->
            ok
    end,
    ?CAST(wybq_proc:get_server_pid(), {update_ets, StWybq}),
    ok.

get_info(Player) ->
    StWybq = get_my_wybq(Player),
    ?CAST(wybq_proc:get_server_pid(), {get_data, StWybq, Player}),
    ok.

compare(Player, OtherKey) ->
    StWybq = get_my_wybq(Player),
    ?CAST(wybq_proc:get_server_pid(), {compare, StWybq, Player, OtherKey}),
    ok.