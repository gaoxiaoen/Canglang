%% @author and_me
%% @doc @todo Add description to wing_init.


-module(wing_init).

-include("common.hrl").
-include("server.hrl").
-include("wing.hrl").

-export([init/1, timer_update/0, logout/0]).

-export([check_upgrade_lv/1, activate_wing/1]).
init(Player) ->
    StWing = init_wing(Player),
    NewStWing = wing_attr:calc_wing_attr(StWing),
    lib_dict:put(?PROC_STATUS_WING, NewStWing),
    SkillList = wing_skill:filter_skill_for_battle(NewStWing#st_wing.skill_list) ++ Player#player.passive_skill,
    Player#player{wing_id = NewStWing#st_wing.current_image_id, passive_skill = SkillList}.



timer_update() ->
    StWing = lib_dict:get(?PROC_STATUS_WING),
    if
        StWing#st_wing.is_change == 1 ->
            lib_dict:put(?PROC_STATUS_WING, StWing#st_wing{is_change = 0}),
            wing_load:replace_wing(StWing);
        true -> ok
    end.

logout() ->
    StWing = lib_dict:get(?PROC_STATUS_WING),
    if
        StWing#st_wing.is_change == 1 ->
            wing_load:replace_wing(StWing);
        true -> ok
    end.

init_wing(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            #st_wing{pkey = Player#player.key};
        false ->
            case wing_load:load_wing(Player#player.key) of
                [] ->
                    #st_wing{pkey = Player#player.key};
                [Stage, Exp, BlessCd, CurrentImage, OwnSpecialImage, Star_listBin, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit, Spirit, ActivationListBin] ->
                    NewStar_list = util:bitstring_to_term(Star_listBin),
                    Own_special_image = fix_image(util:bitstring_to_term(OwnSpecialImage),Stage),
                    SkillList = util:bitstring_to_term(SkillListBin),
                    EquipList = util:bitstring_to_term(EquipListBin),
                    SpiritList = util:bitstring_to_term(SpiritListBin),
                    ActivationList = ?IF_ELSE(ActivationListBin == null, [], util:bitstring_to_term(ActivationListBin)),
                    Now = util:unixtime(),
                    {NewCd, NewExp, IsChange} =
                        if BlessCd == 0 ->
                            {BlessCd, Exp, 0};
                            BlessCd > Now ->
                                {BlessCd, Exp, 0};
                            true ->
                                %% 经验清0
                                spawn(fun() ->
                                    wing_stage:mail_bless_reset(Player#player.key, Stage),
                                    wing_stage:log_wing_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                end),
                                {0, 0, 1}
                        end,
                    #st_wing{
                        pkey = Player#player.key,
                        stage = Stage,
                        exp = NewExp,
                        bless_cd = NewCd,
                        bless_notice = Now,
                        activation_list = ActivationList,
                        current_image_id = CurrentImage,
                        star_list = NewStar_list,
                        own_special_image = Own_special_image,
                        skill_list = SkillList,
                        equip_list = EquipList,
                        grow_num = GrowNum,
                        spirit_list = SpiritList,
                        last_spirit = LastSpirit,
                        spirit = Spirit,
                        is_change = IsChange
                    }
            end
    end.

new_wing(Key) ->
    Base = data_wing_stage:get(1),
    #st_wing{
        pkey = Key,
        stage = 1,
        current_image_id = Base#base_wing_stage.image,
        own_special_image = [{Base#base_wing_stage.image, 0}],
        is_change = 1
    }.


check_upgrade_lv(Player) ->
    case Player#player.lv >= ?WING_OPEN_LV andalso task_in_finish() of
        false -> Player;
        true ->
            _StWing = lib_dict:get(?PROC_STATUS_WING),
            if _StWing#st_wing.stage == 0 ->
                NewStWing = new_wing(Player#player.key),
                lib_dict:put(?PROC_STATUS_WING, NewStWing),
                player_util:func_open_tips(Player, 2, NewStWing#st_wing.current_image_id),
                Player;
                true ->
                    Player
            end
    end.

task_in_finish() ->
    case data_menu_open:get_task(2) of
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


activate_wing(Player) ->
    StWing = lib_dict:get(?PROC_STATUS_WING),
    NewStWing = wing_attr:calc_wing_attr(StWing),
    lib_dict:put(?PROC_STATUS_WING, NewStWing),
    NewPlayer = player_util:count_player_attribute(Player#player{wing_id = NewStWing#st_wing.current_image_id}, true),
    scene_agent_dispatch:wing_update(NewPlayer),
    NewPlayer.


fix_image(ImageList, 0) -> ImageList;
fix_image(ImageList, Stage) ->
    F = fun(CurStage, L) ->
        case data_wing_stage:get(CurStage) of
            [] -> L;
            Base ->
                case lists:keymember(Base#base_wing_stage.image, 1, L) of
                    true -> L;
                    false ->
                        [{Base#base_wing_stage.image, 0} | L]
                end
        end
        end,
    lists:foldl(F, ImageList, lists:seq(1, Stage)).