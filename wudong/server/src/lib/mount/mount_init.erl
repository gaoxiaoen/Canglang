%% @author and_me
%% @doc @todo Add description to mount_init.


-module(mount_init).

-include("common.hrl").
-include("server.hrl").
-include("mount.hrl").
-include("goods.hrl").

-export([init/1, check_upgrade_lv/1, activate_mount/1, mount_activate/1]).

-define(NEW_MAX_MOUNT_CELL_NUM, 100).


init(Player) ->
    Mount = init_mount(Player),
    NewMount = mount_attr:calc_mount_attr(Mount),
    lib_dict:put(?PROC_STATUS_MOUNT, NewMount),
    PassiveSkillList = mount_skill:filter_skill_for_battle(Mount#st_mount.skill_list) ++ Player#player.passive_skill,
    Player#player{passive_skill = PassiveSkillList, common_riding = #common_riding{}}.

init_mount(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            #st_mount{pkey = Player#player.key};
        false ->
            case mount_load:load_mount(Player#player.key) of
                [] ->
                    #st_mount{pkey = Player#player.key};
                [Stage, Exp, BlessCd, Current_image_id, CurrentSwordId, Own_special_imageBin, Star_listBin, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit, OldCurrentImageId, Spirit, ActivationListBin] ->
                    Own_special_image = util:bitstring_to_term(Own_special_imageBin),
                    NewStar_list = util:bitstring_to_term(Star_listBin),
                    SkillList = util:bitstring_to_term(SkillListBin),
                    EquipList = util:bitstring_to_term(EquipListBin),
                    SpiritList = util:bitstring_to_term(SpiritListBin),
                    ActivationList = ?IF_ELSE(ActivationListBin == null, [], util:bitstring_to_term(ActivationListBin)),
                    Now = util:unixtime(),
                    {NewCd, NewExp, IsChange} = check_bless(Player, Exp, BlessCd, Stage, Now),
                    #st_mount{
                        pkey = Player#player.key,
                        stage = Stage,
                        exp = NewExp,
                        bless_cd = NewCd,
                        bless_notice = Now,
                        star_list = NewStar_list,
                        current_image_id = Current_image_id,
                        current_sword_id = CurrentSwordId,
                        old_current_image_id = ?IF_ELSE(OldCurrentImageId == 0, Current_image_id, OldCurrentImageId),
                        own_special_image = Own_special_image,
                        skill_list = SkillList,
                        equip_list = EquipList,
                        grow_num = GrowNum,
                        spirit_list = SpiritList,
                        activation_list = ActivationList,
                        last_spirit = LastSpirit,
                        spirit = Spirit,
                        is_change = IsChange
                    }
            end
    end.

check_bless(Player, Exp, BlessCd, Stage, Now) ->
    if BlessCd == 0 ->
        {BlessCd, Exp, 0};
        BlessCd > Now ->
            {BlessCd, Exp, 0};
        true ->
            %%经验清0
            spawn(fun() ->
                mount_stage:mail_bless_reset(Player#player.key, Stage),
                mount_stage:log_mount_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
            end),
            {0, 0, 1}
    end.
%%新坐骑
new_mount(Key) ->
    BaseData = data_mount_stage:get(1),
    #st_mount{
        pkey = Key,
        stage = 1,
        own_special_image = [{BaseData#base_mount_stage.image, 0}],
        current_image_id = BaseData#base_mount_stage.image,
        old_current_image_id = BaseData#base_mount_stage.image,
        current_sword_id = BaseData#base_mount_stage.sword_image,
        is_change = 1
    }.


check_upgrade_lv(Player) ->
    case Player#player.lv >= ?MOUNT_OPEN_LV andalso task_in_finish() of
        false -> Player;
        true ->
            StMount = lib_dict:get(?PROC_STATUS_MOUNT),
            if StMount#st_mount.stage == 0 ->
                NewStMount = new_mount(Player#player.key),
                lib_dict:put(?PROC_STATUS_MOUNT, NewStMount),
                player_util:func_open_tips(Player, 1, NewStMount#st_mount.current_image_id),
                Player;
                true ->
                    Player
            end
    end.

task_in_finish() ->
    case data_menu_open:get_task(1) of
        [] -> true;
        {0, _} -> true;
        {Tid, 3} ->
            task:in_finish(Tid);
        {Tid, 2} ->
            task:in_trigger(Tid);
        {Tid, 1} ->
            task:in_can_trigger(Tid);
        _ -> false
    end.

mount_activate(Player) ->
    StMount = lib_dict:get(?PROC_STATUS_MOUNT),
    NewStMount = mount_attr:calc_mount_attr(StMount),
    mount_pack:send_mount_info(NewStMount, Player),
    lib_dict:put(?PROC_STATUS_MOUNT, NewStMount),
    MountId =
        case data_mount_stage:get(NewStMount#st_mount.stage) of
            [] ->
                StMount#st_mount.current_image_id;
            _ ->
                StMount#st_mount.current_sword_id

        end,
    NewPlayer = player_util:count_player_attribute(Player#player{mount_id = MountId}, true),
    scene_agent_dispatch:mount_id_update(NewPlayer),

    NewPlayer.


activate_mount(Player) ->
    StMount = lib_dict:get(?PROC_STATUS_MOUNT),
    if StMount#st_mount.stage == 0 ->
        NewStMount = new_mount(Player#player.key),
        NewStMount1 = mount_attr:calc_mount_attr(NewStMount),
        mount_pack:send_mount_info(NewStMount1, Player),
        lib_dict:put(?PROC_STATUS_MOUNT, NewStMount1),
        MountId =
            case data_mount_stage:get(NewStMount#st_mount.stage) of
                [] ->
                    NewStMount#st_mount.current_image_id;
                BaseData ->
                    BaseData#base_mount_stage.sword_image

            end,
        NewPlayer = Player#player{mount_id = MountId},
        player_util:func_open_tips(Player, 1, NewStMount#st_mount.current_image_id),
        scene_agent_dispatch:mount_id_update(NewPlayer),
        NewPlayer;
        true ->
            Player
    end.