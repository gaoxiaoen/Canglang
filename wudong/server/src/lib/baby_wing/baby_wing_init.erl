%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 8月 2017 10:00
%%%-------------------------------------------------------------------

-module(baby_wing_init).

-include("common.hrl").
-include("server.hrl").
-include("baby_wing.hrl").

-export([init/1, timer_update/0, logout/0]).

-export([check_upgrade_lv/1, activate_wing/1]).
init(Player) ->
    StWing = init_wing(Player),
    NewStWing = baby_wing_attr:calc_wing_attr(StWing),
    lib_dict:put(?PROC_STATUS_BABY_WING, NewStWing),
    SkillList = baby_wing_skill:filter_skill_for_battle(NewStWing#st_baby_wing.skill_list) ++ Player#player.passive_skill,
    Player#player{baby_wing_id = NewStWing#st_baby_wing.current_image_id, passive_skill = SkillList}.



timer_update() ->
    StWing = lib_dict:get(?PROC_STATUS_BABY_WING),
    if
        StWing#st_baby_wing.is_change == 1 ->
            lib_dict:put(?PROC_STATUS_BABY_WING, StWing#st_baby_wing{is_change = 0}),
            baby_wing_load:replace_wing(StWing);
        true -> ok
    end.

logout() ->
    StWing = lib_dict:get(?PROC_STATUS_BABY_WING),
    if
        StWing#st_baby_wing.is_change == 1 ->
            baby_wing_load:replace_wing(StWing);
        true -> ok
    end.

init_wing(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            #st_baby_wing{pkey = Player#player.key};
        false ->
            case baby_wing_load:load_wing(Player#player.key) of
                [] ->
                    #st_baby_wing{pkey = Player#player.key};
                [Stage, Exp, BlessCd, CurrentImage, OwnSpecialImage, Star_listBin, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit, Spirit] ->
                    NewStar_list = util:bitstring_to_term(Star_listBin),
                    Own_special_image = util:bitstring_to_term(OwnSpecialImage),
                    SkillList = util:bitstring_to_term(SkillListBin),
                    EquipList = util:bitstring_to_term(EquipListBin),
                    SpiritList = util:bitstring_to_term(SpiritListBin),
                    Now = util:unixtime(),
                    {NewCd, NewExp, IsChange} =
                        if BlessCd == 0 ->
                            {BlessCd, Exp, 0};
                            BlessCd > Now ->
                                {BlessCd, Exp, 0};
                            true ->
                                %% 经验清0
                                spawn(fun() ->
                                    baby_wing_stage:mail_bless_reset(Player#player.key, Stage),
                                    baby_wing_stage:log_wing_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                end),
                                {0, 0, 1}
                        end,
                    Own_special_image1 =
                        if
                            Own_special_image == [] -> Own_special_image;
                            true ->
                                {BabyWingId, _} = hd(Own_special_image),
                                case data_baby_wing:get(BabyWingId) of
                                    [] ->
                                        F = fun(Star) ->
                                            Base = data_baby_wing_stage:get(Star),
                                            {Base#base_baby_wing_stage.image, 0}
                                        end,
                                        lists:map(F, lists:seq(1, Stage));
                                    _ ->
                                        Own_special_image
                                end
                        end,

                    NewCurrentImage =
                        case data_baby_wing:get(CurrentImage) of
                            [] ->
                                Base0 = data_baby_wing_stage:get(Stage),
                                Base0#base_baby_wing_stage.image;
                            _ -> CurrentImage
                        end,

                    #st_baby_wing{
                        pkey = Player#player.key,
                        stage = Stage,
                        exp = NewExp,
                        bless_cd = NewCd,
                        bless_notice = Now,
                        current_image_id = NewCurrentImage,
                        star_list = NewStar_list,
                        own_special_image = Own_special_image1,
                        skill_list = SkillList,
                        equip_list = EquipList,
                        grow_num = GrowNum,
                        spirit_list = SpiritList,
                        last_spirit = LastSpirit,
                        is_change = IsChange,
                        spirit = Spirit
                    }
            end
    end.

new_wing(Key) ->
    Base = data_baby_wing_stage:get(1),
    #st_baby_wing{
        pkey = Key,
        stage = 1,
        current_image_id = Base#base_baby_wing_stage.image,
        own_special_image = [{Base#base_baby_wing_stage.image, 0}],
        is_change = 1
    }.

check_upgrade_lv(Player) ->
    case Player#player.lv >= 59 of
%%     case Player#player.lv >= ?BABY_WING_OPEN_LV of
        false -> Player;
        true ->
            _StWing = lib_dict:get(?PROC_STATUS_BABY_WING),
            if _StWing#st_baby_wing.stage == 0 ->
                StWing = new_wing(Player#player.key),
                NewStWing = baby_wing_attr:calc_wing_attr(StWing),
                lib_dict:put(?PROC_STATUS_BABY_WING, NewStWing),
                Player;
                true ->
                    Player
            end
    end.

task_in_finish() ->
    case data_menu_open:get_task(56) of
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
    StWing = lib_dict:get(?PROC_STATUS_BABY_WING),
    NewStWing = baby_wing_attr:calc_wing_attr(StWing),
    lib_dict:put(?PROC_STATUS_BABY_WING, NewStWing),
    NewPlayer = player_util:count_player_attribute(Player#player{baby_wing_id = NewStWing#st_baby_wing.current_image_id}, true),
    scene_agent_dispatch:baby_wing_update(NewPlayer),
    NewPlayer.
