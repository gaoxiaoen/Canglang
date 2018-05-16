%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%     提示大厅
%%% @end
%%% Created : 23. 十二月 2015 14:13
%%%-------------------------------------------------------------------
-module(tips).
-author("hxming").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("pray.hrl").
-include("tips.hrl").
-include("guild.hrl").
-include("mount.hrl").
-include("wing.hrl").
-include("magic_weapon.hrl").
-include("light_weapon.hrl").
-include("pet.hrl").
-include("pet_weapon.hrl").
-include("footprint_new.hrl").
-include("cat.hrl").
-include("golden_body.hrl").
-include("jade.hrl").
-include("god_treasure.hrl").
-include("baby_wing.hrl").

%% API
-export([
    get_tips/2,
    send_tips/2,
    cancel_tips/2,
    upgrade_refresh/1,
    timer_refresh/1,
    login_refresh/1,
    gm_tips/2,

    send_to_client/2
]).

gm_tips(Player, Id) ->
    get_tips(Player, [Id]).

login_refresh(Player) ->
    get_tips(Player, data_tips:login_tips()).

%%玩家升级,更新
upgrade_refresh(Player) ->
    get_tips(Player, data_tips:uplv_tips()).

%%定时器刷新
timer_refresh(Player) ->
    get_tips(Player, data_tips:timer_tips()).

%%发送单个提示
send_tips(Player, Id) when is_record(Player, player) ->
    {ok, Bin} = pt_130:write(13010, {[[Id, 1, 0, 0, 0, 0, 0, 0, 0, 0, []]]}),
    server_send:send_to_sid(Player#player.sid, Bin);
send_tips(Pid, Id) when is_pid(Pid) ->
    {ok, Bin} = pt_130:write(13010, {[[Id, 1, 0, 0, 0, 0, 0, 0, 0, 0, []]]}),
    server_send:send_to_pid(Pid, Bin);
send_tips(Key, Id) ->
    {ok, Bin} = pt_130:write(13010, {[[Id, 1, 0, 0, 0, 0, 0, 0, 0, 0, []]]}),
    server_send:send_to_key(Key, Bin).

%%取消提示
cancel_tips(Player, Id) when is_record(Player, player) ->
    {ok, Bin} = pt_130:write(13010, {[[Id, 0, 0, 0, 0, 0, 0, 0, 0, 0, []]]}),
    server_send:send_to_sid(Player#player.sid, Bin);
cancel_tips(Pid, Id) when is_pid(Pid) ->
    {ok, Bin} = pt_130:write(13010, {[[Id, 0, 0, 0, 0, 0, 0, 0, 0, 0, []]]}),
    server_send:send_to_pid(Pid, Bin);
cancel_tips(Key, Id) ->
    {ok, Bin} = pt_130:write(13010, {[[Id, 0, 0, 0, 0, 0, 0, 0, 0, 0, []]]}),
    server_send:send_to_key(Key, Bin).

send_to_client(Player, Tips) ->
    #tips{
        state = State,
        args1 = Args1,
        args2 = Args2,
        args3 = Args3,
        args4 = Args4,
        args5 = Args5,
        args6 = Args6,
        args7 = Args7,
        args8 = Args8,
        saodang_dungeon_list = SaoDangList,
        uplv_dungeon_list = UpLvList,
        upcombat_dungeon_list = UpCombatList
    } = Tips,
    Tips1 = [138, State, Args1, Args2, Args3, Args4, Args5, Args6, Args7, Args8, SaoDangList ++ UpLvList ++ UpCombatList],
    {ok, Bin} = pt_130:write(13010, {[Tips1]}),
    server_send:send_to_sid(Player#player.sid, Bin).

%%获取提示信息
%%RETURN [{id,state}]
get_tips(Player, Ids) ->
    F = fun(Id) ->
        case data_tips:get(Id) of
            [] -> [];
            Base ->
                if
                    Base#base_tips.lv_lim > Player#player.lv -> [];
                    true ->
                        case catch tips(Id, Player) of
                            #tips{
                                state = State,
                                args1 = Args1,
                                args2 = Args2,
                                args3 = Args3,
                                args4 = Args4,
                                args5 = Args5,
                                args6 = Args6,
                                args7 = Args7,
                                args8 = Args8,
                                saodang_dungeon_list = SaoDangList,
                                uplv_dungeon_list = UpLvList,
                                upcombat_dungeon_list = UpCombatList
                            } = _T ->
%%                                 ?IF_ELSE(State == 1, ?DEBUG("Id:~p T:~p~n", [Id, _T]), ok),
                                [[Id, State, Args1, Args2, Args3, Args4, Args5, Args6, Args7, Args8, SaoDangList ++ UpLvList ++ UpCombatList]];
                            _TipsError ->
                                []
                        end
                end
        end
    end,
    TipsList = lists:flatmap(F, Ids),
    {ok, Bin} = pt_130:write(13010, {TipsList}),
    server_send:send_to_sid(Player#player.sid, Bin).

%%---------花千骨系列---------------

%% 福利大厅 检查签到通知
tips(100, Player) ->
    sign_in:check_sign_in_state(Player);

%% 福利大厅 检查在线累积时长奖励
tips(101, Player) ->
    online_time_gift:check_get_state(Player);

%% 福利大厅 检查找回离线经验
tips(102, _Player) ->
    findback_exp:check_find_state();

%% 福利大厅 检查资源找回
tips(103, Player) ->
    findback_src:check_find_state(Player);

%% 福利大厅 检查签到再领一次
tips(104, Player) ->
    sign_in:check_sign_in_state(Player);

%% 福利大厅 检查累积签到天数
tips(105, Player) ->
    sign_in:check_sign_in_state(Player);

%% 检查在线累积时长奖励
tips(106, Player) ->
    online_time_gift:check_get_state(Player);

%% 检查签到再领一次
tips(107, Player) ->
    sign_in:check_sign_in_state(Player);

%% 检查副本扫荡
tips(108, Player) ->
    %% 检查经验副本扫荡
    Tips0 = dungeon_exp:check_saodang_state(Player, #tips{}),
    %% 检查单人副本扫荡
    Tips1 = dungeon_daily:check_saodang_state(Player, Tips0),
    %% 检查神器副本扫荡
    Tips2 = dungeon_god_weapon:check_sweep_state(Tips1),
    %% 检查九霄塔副本扫荡
%%     Tips2 = dungeon_tower:check_saodang_state(Player, Tips1),
    %% 检查守护副本扫荡
    Tips3 = dungeon_guard:check_sweep_state(Tips2),
    Tips3;
%%     Tips2;
tips(109, Player) ->
    %% 玩家升级检查可挑战副本
    Tips0 = dungeon_material:check_uplv_dungeon_state(Player, #tips{}),
    %% 玩家升级检查单人可挑战副本
    Tips1 = dungeon_daily:check_uplv_dungeon_state(Player, Tips0),
    %% 玩家升级检查神器可挑战副本
    Tips2 = dungeon_god_weapon:check_enter_state(Player, Tips1),
    Tips2;

%% 定时检查玩家提升 可挑战经验副本
tips(110, Player) ->
    Tips0 = dungeon_exp:check_saodang_state(Player, #tips{}),
    if
        Tips0#tips.state == 1 -> #tips{};
        true ->
            Tips = dungeon_exp:check_upcombat_dungeon_state(Player, #tips{}),
            Tips
    end;

%% 升级检测符文塔
tips(111, _Player) ->
    Tips = dungeon_fuwen_tower:check_uplv_dungeon_state(_Player, #tips{}),
    Tips;

%% 定时检查坐骑升级(升阶)
tips(115, _Player) ->
    mount:check_upgrade_state(#tips{});

%% 定时检查坐骑技能升级
tips(116, _Player) ->
    mount_skill:check_upgrade_skill_state(_Player, #tips{});

%% 定时检查坐骑精魄升级
tips(117, _Player) ->
    Mount = mount_util:get_mount(),
    if
        Mount#st_mount.stage < 2 -> #tips{};
        true ->
            Tips0 = mount:check_upgrade_jp_state(_Player, #tips{}, data_goods:get(3104000)),
            Tips1 = mount:check_upgrade_jp_state(_Player, Tips0, data_goods:get(3105000)),
            Tips2 = mount:check_upgrade_jp_state(_Player, Tips1, data_goods:get(3106000)),
            Tips2
    end;

%% 定时检查坐骑成长升级
tips(118, _Player) ->
    Mount = mount_util:get_mount(),
    if
        Mount#st_mount.stage < 2 -> #tips{};
        true ->
            Tips = mount:check_use_mount_dan_state(_Player, #tips{}),
            Tips
    end;

%% 定时检查仙羽升级(升阶)
tips(119, _Player) ->
    State = wing:check_upgrade_state(),
    #tips{state = State};

%% 定时检查仙羽技能升级
tips(120, _Player) ->
    wing_skill:check_upgrade_skill_state(_Player, #tips{});

%% 定时检查仙羽精魄升级
tips(121, _Player) ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    if
        WingSt#st_wing.stage < 2 -> #tips{};
        true ->
            Tips0 = mount:check_upgrade_jp_state(_Player, #tips{}, data_goods:get(3204000)),
            Tips1 = mount:check_upgrade_jp_state(_Player, Tips0, data_goods:get(3205000)),
            Tips2 = mount:check_upgrade_jp_state(_Player, Tips1, data_goods:get(3206000)),
            Tips2
    end;

%% 定时检查仙羽成长升级
tips(122, _Player) ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    if
        WingSt#st_wing.stage < 2 -> #tips{};
        true ->
            Tips = wing:check_use_wing_dan_state(_Player, #tips{}),
            Tips
    end;

%% 定时检查法器升级(升阶)
tips(123, _Player) ->
    Tips = magic_weapon:check_upgrade_stage_state(_Player, #tips{}),
    Tips;

%% 定时检查法器技能升级
tips(124, _Player) ->
    State = magic_weapon_skill:check_upgrade_skill_state(_Player, #tips{}),
    State;

%% 定时检查法器精魄升级
tips(125, _Player) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    if
        MagicWeapon#st_magic_weapon.stage < 2 -> #tips{};
        true ->
            Tips0 = mount:check_upgrade_jp_state(_Player, #tips{}, data_goods:get(3304000)),
            Tips1 = mount:check_upgrade_jp_state(_Player, Tips0, data_goods:get(3305000)),
            Tips2 = mount:check_upgrade_jp_state(_Player, Tips1, data_goods:get(3306000)),
            Tips2
    end;

%% 定时检查法器成长升级
tips(126, _Player) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    if
        MagicWeapon#st_magic_weapon.stage < 2 -> #tips{};
        true ->
            Tips = magic_weapon:check_use_magic_weapon_dan_state(_Player, #tips{}),
            Tips
    end;

%% 定时检查神兵升级(升阶)
tips(127, _Player) ->
    Tips = light_weapon:check_upgrade_stage_state(_Player, #tips{}),
    Tips;

%% 定时检查神兵技能升级
tips(128, _Player) ->
    State = light_weapon_skill:check_upgrade_skill_state(_Player, #tips{}),
    State;

%% 定时检查神兵精魄升级
tips(129, _Player) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    if
        LightWeapon#st_light_weapon.stage < 2 -> #tips{};
        true ->
            Tips0 = mount:check_upgrade_jp_state(_Player, #tips{}, data_goods:get(3404000)),
            Tips1 = mount:check_upgrade_jp_state(_Player, Tips0, data_goods:get(3405000)),
            Tips2 = mount:check_upgrade_jp_state(_Player, Tips1, data_goods:get(3406000)),
            Tips2
    end;

%% 定时检查神兵成长升级
tips(130, _Player) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    if
        LightWeapon#st_light_weapon.stage < 2 -> #tips{};
        true ->
            Tips = light_weapon:check_use_light_weapon_dan_state(_Player, #tips{}),
            Tips
    end;

%% 检查经脉激活
tips(131, _Player) ->
    Tips = meridian:check_activate_state(_Player, #tips{}),
    Tips;

%% 检查经脉升级
tips(132, _Player) ->
    Tips = meridian:check_upgrade_state(_Player, #tips{}),
    Tips;

%% 检查经脉突破
tips(133, _Player) ->
    Tips = meridian:check_break_state(_Player, #tips{}),
    Tips;

%% 检查图鉴激活
tips(134, _Player) ->
    #tips{};

%% 检查图鉴升级
tips(135, Player) ->
    Tips = mon_photo:check_upgrade_state(Player, #tips{}),
    Tips;

%% 检查剑池升级
tips(136, Player) ->
    Tips = sword_pool:check_upgrade_state(Player, #tips{}),
    Tips;

%% 检查十方神器升级
tips(137, Player) ->
    Tips = god_weapon:check_upgrade_spirit_state(Player, #tips{}),
    Tips;

%% 竞技场积分奖励
tips(138, _Player) ->
    Tips = arena_score:get_score_reward_state(),
    Tips;

%%锻造装备可以强化
tips(139, Player) ->
    State = equip_stren:check_equip_stren_state(Player),
    if
        State == 1 -> #tips{state = 1};
        true -> #tips{}
    end;

%%锻造装备升级
tips(140, Player) ->
    State = equip:check_equip_up_state(Player),
    if
        State == 1 -> #tips{state = 1};
        true -> #tips{}
    end;

%%锻造装备镶嵌
tips(141, _Player) ->
    State = equip_inlay:check_stone_inlay_state(),
    if
        State == 1 -> #tips{state = 1};
        true -> #tips{}
    end;

%%锻造装备洗练
tips(142, _Player) ->
    State = equip_wash:check_wash_state(),
    if
        State == 1 -> #tips{state = 1};
        true -> #tips{}
    end;

%%锻造装备精炼
tips(143, _Player) ->
    State = equip_refine:check_equip_refine_state(_Player),
    if
        State == 1 -> #tips{state = 1};
        true -> #tips{}
    end;

%% 定时检查坐骑技能激活
tips(144, _Player) ->
    mount_skill:check_activate_skill_state(_Player, #tips{});

%% 定时检查仙羽技能激活
tips(145, _Player) ->
    wing_skill:check_activate_skill_state(_Player, #tips{});

%% 定时检查法器技能激活
tips(146, _Player) ->
    magic_weapon_skill:check_activate_skill_state(_Player, #tips{});

%% 定时检查神兵技能激活
tips(147, _Player) ->
    light_weapon_skill:check_activate_skill_state(_Player, #tips{});

%% 定时检查十方神器激活
tips(148, _Player) ->
    Tips = god_weapon:check_activate_state(_Player, #tips{}),
%%     ?DEBUG("Tips:~p~n", [Tips]),
    Tips;

%% 技能升级
tips(149, _Player) ->
    Tips = skill:check_skill_up_state(_Player, #tips{}),
    Tips;

%% 妖灵升阶
tips(150, _Player) ->
    Tips = pet_weapon:check_upgrade_stage_state(_Player, #tips{}),
    Tips;

%%妖灵技能升级
tips(151, _Player) ->
    Tips = pet_weapon_skill:check_upgrade_skill_state(_Player, #tips{}),
    Tips;

%%妖灵精魄升级
tips(152, _Player) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    if
        PetWeapon#st_pet_weapon.stage < 2 -> #tips{};
        true ->
            Tips0 = pet_weapon:check_upgrade_jp_state(_Player, #tips{}, data_goods:get(3504000)),
            Tips1 = pet_weapon:check_upgrade_jp_state(_Player, Tips0, data_goods:get(3505000)),
            Tips2 = pet_weapon:check_upgrade_jp_state(_Player, Tips1, data_goods:get(3506000)),
            Tips2
    end;

%%妖灵成长升级
tips(153, _Player) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    if
        PetWeapon#st_pet_weapon.stage < 2 -> #tips{};
        true ->
            Tips = pet_weapon:check_use_pet_weapon_dan_state(_Player, #tips{}),
            Tips
    end;

%%妖灵技能激活
tips(154, _Player) ->
    Tips = pet_weapon_skill:check_activate_skill_state(_Player, #tips{}),
    Tips;

%% 足迹升阶
tips(155, _Player) ->
    Tips = footprint:check_upgrade_stage_state(_Player, #tips{}),
    Tips;

%%足迹技能升级
tips(156, _Player) ->
    Tips = footprint_skill:check_upgrade_skill_state(_Player, #tips{}),
    Tips;

%%足迹精魄升级
tips(157, _Player) ->
    FootPrint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    if
        FootPrint#st_footprint.stage < 2 -> #tips{};
        true ->
            Tips0 = footprint:check_upgrade_jp_state(_Player, #tips{}, data_goods:get(3604000)),
            Tips1 = footprint:check_upgrade_jp_state(_Player, Tips0, data_goods:get(3605000)),
            Tips2 = footprint:check_upgrade_jp_state(_Player, Tips1, data_goods:get(3606000)),
            Tips2
    end;

%%足迹成长升级
tips(158, _Player) ->
    FootPrint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    if
        FootPrint#st_footprint.stage < 2 -> #tips{};
        true ->
            Tips = footprint:check_use_footprint_dan_state(_Player, #tips{}),
            Tips
    end;

%%足迹技能激活
tips(159, _Player) ->
    Tips = footprint_skill:check_activate_skill_state(_Player, #tips{}),
    Tips;

%%定期检查是否有过期的物品
tips(160, _Player) ->
    Tips = goods:check_use_state(_Player, #tips{}),
    Tips;

%%坐骑祝福信息
tips(161, _Player) ->
    Now = util:unixtime(),
    case mount_stage:check_bless_state(Now) of
        [] -> #tips{};
        [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
    end;
%%翅膀祝福信息
tips(162, _Player) ->
    Now = util:unixtime(),
    case wing_stage:check_bless_state(Now) of
        [] -> #tips{};
        [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
    end;
%%法宝祝福
tips(163, _Player) ->
    Now = util:unixtime(),
    case magic_weapon:check_bless_state(Now) of
        [] -> #tips{};
        [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
    end;
%%神兵祝福
tips(164, _Player) ->
    Now = util:unixtime(),
    case light_weapon:check_bless_state(Now) of
        [] -> #tips{};
        [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
    end;
%%妖灵祝福
tips(165, _Player) ->
    Now = util:unixtime(),
    case pet_weapon:check_bless_state(Now) of
        [] -> #tips{};
        [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
    end;
%%足迹祝福
tips(166, _Player) ->
    Now = util:unixtime(),
    case footprint:check_bless_state(Now) of
        [] -> #tips{};
        [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
    end;

%% 检查有新符文孔可以开
tips(168, _Player) ->
    fuwen:check_state(_Player, #tips{});

%% 检查宠物技能升级
tips(169, Player) ->
    pet:check_skill_state_tips(Player, #tips{});

%% 检查宠物进阶
tips(170, _Player) ->
    Tips = pet_stage:check_stage_state(_Player, #tips{}),
    Tips;

%% 检查宠物升星
tips(171, _Player) ->
    State = pet_star:check_star_state(_Player),
    #tips{state = State};

%% 检查宠物助战
tips(172, _Player) ->
    pet_assist:check_pet_assist_state(_Player, #tips{});

%% 检查灵猫升阶
tips(173, _Player) ->
    Tips = cat:check_upgrade_stage_state(_Player, #tips{}),
    Tips;

%% 灵猫技能升级
tips(174, _Player) ->
    Tips = cat_skill:check_upgrade_skill_state(_Player, #tips{}),
    Tips;

%% 灵猫精魄升级
tips(175, _Player) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    if
        Cat#st_cat.stage < 2 -> #tips{};
        true ->
            Tips0 = cat:check_upgrade_jp_state(_Player, #tips{}, data_goods:get(3704000)),
            Tips1 = cat:check_upgrade_jp_state(_Player, Tips0, data_goods:get(3705000)),
            Tips2 = cat:check_upgrade_jp_state(_Player, Tips1, data_goods:get(3706000)),
            Tips2
    end;

%% 灵猫成长升级
tips(176, _Player) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    if
        Cat#st_cat.stage < 2 -> #tips{};
        true ->
            Tips = cat:check_use_cat_dan_state(_Player, #tips{}),
            Tips
    end;

%% 灵猫技能激活
tips(177, _Player) ->
    Tips = cat_skill:check_activate_skill_state(_Player, #tips{}),
    Tips;

%% 灵猫祝福
tips(178, _Player) ->
    Now = util:unixtime(),
    case cat:check_bless_state(Now) of
        [] -> #tips{};
        [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
    end;

%% 熔炼
tips(179, _Player) ->
    State = lists:max([
        mount:get_equip_smelt_state(),
        wing:get_equip_smelt_state(),
        light_weapon:get_equip_smelt_state(),
        magic_weapon:get_equip_smelt_state(),
        cat:get_equip_smelt_state(),
        footprint:get_equip_smelt_state(),
        pet_weapon:get_equip_smelt_state(),
        golden_body:get_equip_smelt_state(),
        jade:get_equip_smelt_state(),
        god_treasure:get_equip_smelt_state()
    ]),
    #tips{state = State};

%% 检查法身升阶
tips(180, _Player) ->
    Tips = golden_body:check_upgrade_stage_state(_Player, #tips{}),
    Tips;


%% 法身技能升级
tips(181, _Player) ->
    Tips = golden_body_skill:check_upgrade_skill_state(_Player, #tips{}),
    Tips;

%% 法身精魄升级
tips(182, _Player) ->
    GoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
    if
        GoldenBody#st_golden_body.stage < 2 -> #tips{};
        true ->
            Tips0 = golden_body:check_upgrade_jp_state(_Player, #tips{}, data_goods:get(3804000)),
            Tips1 = golden_body:check_upgrade_jp_state(_Player, Tips0, data_goods:get(3805000)),
            Tips2 = golden_body:check_upgrade_jp_state(_Player, Tips1, data_goods:get(3806000)),
            Tips2
    end;

%% 法身成长升级
tips(183, _Player) ->
    GoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
    if
        GoldenBody#st_golden_body.stage < 2 -> #tips{};
        true ->
            Tips = golden_body:check_use_golden_body_dan_state(_Player, #tips{}),
            Tips
    end;

%% 法身技能激活
tips(184, _Player) ->
    Tips = golden_body_skill:check_activate_skill_state(_Player, #tips{}),
    Tips;

%% 法身祝福
tips(185, _Player) ->
    Now = util:unixtime(),
    case golden_body:check_bless_state(Now) of
        [] -> #tips{};
        [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
    end;


%% 定时检查灵羽升级(升阶)
tips(186, Player) ->
    if
        Player#player.baby#fbaby.figure == 0 -> #tips{};
        true ->
            State = baby_wing:check_upgrade_state(),
            #tips{state = State}
    end;

%% 定时检查灵羽技能升级
tips(187, Player) ->
    if
        Player#player.baby#fbaby.figure == 0 -> #tips{};
        true ->
            baby_wing_skill:check_upgrade_skill_state(Player, #tips{})
    end;

%% 定时检查仙羽精魄升级
tips(188, Player) ->
    WingSt = lib_dict:get(?PROC_STATUS_BABY_WING),
    if
        WingSt#st_baby_wing.stage < 2 -> #tips{};
        Player#player.baby#fbaby.figure == 0 -> #tips{};
        true ->
            Tips0 = baby_wing:check_upgrade_jp_state(Player, #tips{}, data_goods:get(3904000)),
            Tips1 = baby_wing:check_upgrade_jp_state(Player, Tips0, data_goods:get(3905000)),
            Tips2 = baby_wing:check_upgrade_jp_state(Player, Tips1, data_goods:get(3906000)),
            Tips2
    end;

%% 定时检查灵羽成长升级
tips(189, Player) ->
    WingSt = lib_dict:get(?PROC_STATUS_BABY_WING),
    if
        WingSt#st_baby_wing.stage < 2 -> #tips{};
        Player#player.baby#fbaby.figure == 0 -> #tips{};
        true ->
            Tips = baby_wing:check_use_wing_dan_state(Player, #tips{}),
            Tips
    end;

%% 定时检查仙羽技能激活
tips(190, Player) ->
    if
        Player#player.baby#fbaby.figure == 0 -> #tips{};
        true ->
            baby_wing_skill:check_activate_skill_state(Player, #tips{})
    end;


%%仙羽祝福信息
tips(191, Player) ->
    Now = util:unixtime(),
    if
        Player#player.baby#fbaby.figure == 0 -> #tips{};
        true ->
            case baby_wing_stage:check_bless_state(Now) of
                [] -> #tips{};
                [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
            end
    end;


%% 检查仙宝升阶
tips(204, _Player) ->
    Tips = god_treasure:check_upgrade_stage_state(_Player, #tips{}),
    Tips;

%% 仙宝技能升级
tips(205, _Player) ->
    Tips = god_treasure_skill:check_upgrade_skill_state(_Player, #tips{}),
    Tips;

%% 仙宝精魄升级
tips(206, _Player) ->
    GodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    if
        GodTreasure#st_god_treasure.stage < 2 -> #tips{};
        true ->
            Tips0 = god_treasure:check_upgrade_jp_state(_Player, #tips{}, data_goods:get(6104000)),
            Tips1 = god_treasure:check_upgrade_jp_state(_Player, Tips0, data_goods:get(6105000)),
            Tips2 = god_treasure:check_upgrade_jp_state(_Player, Tips1, data_goods:get(6106000)),
            Tips2
    end;

%% 仙宝成长升级
tips(207, _Player) ->
    GodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    if
        GodTreasure#st_god_treasure.stage < 2 -> #tips{};
        true ->
            Tips = god_treasure:check_use_god_treasure_dan_state(_Player, #tips{}),
            Tips
    end;

%% 仙宝技能激活
tips(208, _Player) ->
    Tips = god_treasure_skill:check_activate_skill_state(_Player, #tips{}),
    Tips;

%% 仙宝祝福
tips(209, _Player) ->
    Now = util:unixtime(),
    case god_treasure:check_bless_state(Now) of
        [] -> #tips{};
        [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
    end;

%% 检查灵佩升阶
tips(210, _Player) ->
    Tips = jade:check_upgrade_stage_state(_Player, #tips{}),
    Tips;

%% 灵佩技能升级
tips(211, _Player) ->
    Tips = jade_skill:check_upgrade_skill_state(_Player, #tips{}),
    Tips;

%% 灵佩精魄升级
tips(212, _Player) ->
    Jade = lib_dict:get(?PROC_STATUS_JADE),
    if
        Jade#st_jade.stage < 2 -> #tips{};
        true ->
            Tips0 = jade:check_upgrade_jp_state(_Player, #tips{}, data_goods:get(6204000)),
            Tips1 = jade:check_upgrade_jp_state(_Player, Tips0, data_goods:get(6205000)),
            Tips2 = jade:check_upgrade_jp_state(_Player, Tips1, data_goods:get(6206000)),
            Tips2
    end;

%% 灵佩成长升级
tips(213, _Player) ->
    Jade = lib_dict:get(?PROC_STATUS_JADE),
    if
        Jade#st_jade.stage < 2 -> #tips{};
        true ->
            Tips = jade:check_use_jade_dan_state(_Player, #tips{}),
            Tips
    end;

%% 灵佩技能激活
tips(214, _Player) ->
    Tips = jade_skill:check_activate_skill_state(_Player, #tips{}),
    Tips;

%% 灵佩祝福
tips(215, _Player) ->
    Now = util:unixtime(),
    case jade:check_bless_state(Now) of
        [] -> #tips{};
        [[_, CdTime]] -> #tips{state = 1, args1 = CdTime}
    end;


%%---------花千骨系列(完)---------------
%%
%%%%技能是否可升级
%%tips(1, Player) ->
%%    skill:check_has_skill_up(Player);
%%%%翅膀可升级
%%tips(2, _Player) ->
%%    wing:check_upgrade_state();
%%%%翅膀可进阶
%%tips(3, _Player) ->
%%    wing:check_evolve_state();
%%%%光武解封
%%%%tips(4, Player) ->
%%%%    light_weapon:check_activate_state(Player#player.career);
%%%%%%光武升级
%%%%tips(5, _Player) ->
%%%%    light_weapon:check_upgrade_state();
%%%%背包满
%%tips(6, _Player) ->
%%    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
%%    if GoodsSt#st_goods.leftover_cell_num == 0 -> 1;
%%        true -> 0
%%    end;
%%%%女神祈祷装备
%%tips(7, _Player) ->
%%    StPRAY = lib_dict:get(?PROC_STATUS_PRAY),
%%    if StPRAY#st_pray.left_cell_num =< 5 -> 1;
%%        true -> 0
%%    end;
%%%%宝石镶嵌
%%tips(8, _Player) ->
%%    equip_inlay:check_stone_inlay_state();
%%
%%%%坐骑升级
%%tips(11, _Player) ->
%%    mount:check_upgrade_state();
%%%%好友申请
%%%%tips(12, _Player) ->
%%%%    0;
%%%%邮件信息
%%tips(13, _Player) ->
%%    mail:check_mail_state();
%%%%私聊信息
%%%%tips(15, _Player) ->
%%%%    0;
%%tips(20, _Player) ->
%%    0;
%%tips(21, _Player) ->
%%    0;
%%%%装备洗练
%%tips(22, _Player) ->
%%    equip_wash:check_wash_state();
%%%%装备可熔炼
%%tips(23, _Player) ->
%%    equip_smelt:check_smelt_state();
%%%%等级礼包可领取
%%tips(24, Player) ->
%%    lv_gift:check_lv_gift_state(Player#player.lv);
%%%%七日礼包可领取
%%tips(25, _Player) ->
%%    day7login:check_day7gift_state();
%%%%装备可以强化
%%tips(26, Player) ->
%%    equip_stren:check_equip_stren_state(Player);
%%%%寻宝
%%%%tips(27, Player) ->
%%%%    case goods_util:get_goods_list_by_subtype_list(?GOODS_LOCATION_BAG, [?GOODS_SUBTYPE_TREASURE]) of
%%%%        [] -> 0;
%%%%        _ ->
%%%%            treasure:check_treasure_times(Player)
%%%%    end;
%%%%竞技场
%%tips(28, Player) ->
%%    ?CAST(arena_proc:get_server_pid(), {check_arena_state, Player, 28}),
%%    0;
%%%%仙盟战报名
%%tips(29, _Player) -> 0;
%%%%    guild_war_util:get_state(Player);
%%%%星座升级
%%tips(30, Player) ->
%%    meridian:check_meridian_state(Player);
%%%%原力培养
%%%%tips(31, Player) ->
%%%%    yuanli:check_yuanli_state(Player);
%%%%觉醒培养
%%%%tips(32, Player) ->
%%%%    xiulian:check_xiulian_state(Player);
%%%%宠物光环
%%%%tips(33, Player) ->
%%%%    pet_halo:check_halo_state(Player);
%%%%装备升级
%%tips(34, Player) ->
%%    equip:check_equip_up_state(Player);
%%%%装备升星
%%tips(35, Player) ->
%%    equip:check_equip_star_state(Player);
%%%%材料副本
%%tips(37, _Player) ->
%%    dungeon_material:check_dungeon_state();
%%%%疯狂点击
%%%%tips(38, _Player) ->
%%%%    crazy_click:check_click_state(_Player);
%%
%%%%宠物升星
%%%%tips(39, _Player) ->
%%%%    pet_star:check_star_up_state();
%%%%宠物助战
%%%%tips(40, _Player) ->
%%%%    pet_merge:check_pet_merge_state(_Player);
%%%%仙盟申请
%%tips(41, _Player) ->
%%    guild_util:check_guild_apply_state(_Player);
%%%%坐骑装备洗练
%%%%tips(44, _Player) ->
%%%%    mount_equip:check_smelt_state();
%%%%许愿树
%%tips(48,Player) ->
%%	wish_tree_util:check_upgrade_state(Player);

tips(_, _Player) ->
    ok.

