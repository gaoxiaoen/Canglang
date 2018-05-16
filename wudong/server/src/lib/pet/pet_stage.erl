%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 19:58
%%%-------------------------------------------------------------------
-module(pet_stage).
-author("hxming").
-include("pet.hrl").
-include("server.hrl").
-include("skill.hrl").
-include("common.hrl").
-include("achieve.hrl").
-include("task.hrl").
-include("tips.hrl").

%% API
-export([stage_info/0, upgrade_stage/3]).

-export([
    check_state_state/1,
    check_stage_state/2
]).

%%检查是否可升阶
check_state_state(Player) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case StPet#st_pet.pet_list == [] of
        true ->
            0;
        false ->
            case data_menu_open:get(8) of
                BaseLv when Player#player.lv >= BaseLv ->
                    case data_pet_stage:get(StPet#st_pet.stage, StPet#st_pet.stage_lv) of
                        [] -> 0;
                        BaseStage ->
                            if BaseStage#base_pet_stage.exp == 0 -> 0;
                                true ->
                                    case BaseStage#base_pet_stage.goods of
                                        {GoodsId, Num} ->
                                            Count = goods_util:get_goods_count(GoodsId),
                                            if Count >= Num -> 1;
                                                true -> 0
                                            end;
                                        _ -> 0
                                    end
                            end
                    end;
                _ ->
                    0
            end
    end.

check_stage_state(Player, Tips) ->
    State = check_state_state(Player),
    ?IF_ELSE(State == 1, Tips#tips{state = 1}, Tips).

stage_info() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    ExpLim =
        case data_pet_stage:get(StPet#st_pet.stage, StPet#st_pet.stage_lv) of
            [] -> 0;
            BaseStage ->
                BaseStage#base_pet_stage.exp
        end,
    {StPet#st_pet.stage, StPet#st_pet.stage_lv, StPet#st_pet.stage_exp, ExpLim}.

%%宠物进阶
upgrade_stage(Player, Type, Auto) ->
    if Player#player.pet#fpet.type_id == 0 -> {11, Player};
        true ->
            StPet = lib_dict:get(?PROC_STATUS_PET),
            case data_pet_stage:get(StPet#st_pet.stage, StPet#st_pet.stage_lv) of
                [] -> {9, Player};
                BaseStage ->
                    if BaseStage#base_pet_stage.exp == 0 -> {12, Player};
                        true ->
                            case Type of
                                0 ->
                                    upgrade_state_once(Player, StPet, Auto, BaseStage);
                                _ ->
                                    upgrade_stage_more(Player, StPet, Auto, BaseStage, 1)
                            end
                    end
            end
    end.

%%
upgrade_state_once(Player, StPet, Auto, BaseStage) ->
    case check_stage_once(Player, StPet, Auto, BaseStage) of
        {ok, Player1, NewStPet} ->
            lib_dict:put(?PROC_STATUS_PET, NewStPet),
            NewPlayer = player_util:count_player_attribute(Player1, true),
            task_event:event(?TASK_ACT_PET_STAGE, {1}),
            activity:get_notice(Player, [110, 33], true),
            {1, NewPlayer};
        {ok1, Player1, NewStPet} ->
            lib_dict:put(?PROC_STATUS_PET, NewStPet),
            NewPlayer = player_util:count_player_attribute(Player1, true),
            task_event:event(?TASK_ACT_PET_STAGE, {1}),
            activity:get_notice(Player, [110, 33], true),
            {1, NewPlayer};
        {Err, Player} ->
            {Err, Player}
    end.

upgrade_stage_more(Player, StPet, _Auto, _BaseStage, 11) ->
    lib_dict:put(?PROC_STATUS_PET, StPet),
    NewPlayer = player_util:count_player_attribute(Player, true),
    task_event:event(?TASK_ACT_PET_STAGE, {10}),
    activity:get_notice(Player, [110, 33], true),
    {1, NewPlayer};
upgrade_stage_more(Player, StPet, Auto, BaseStage, Times) ->
    case check_stage_once(Player, StPet, Auto, BaseStage) of
        {ok, Player1, NewStPet} ->
            lib_dict:put(?PROC_STATUS_PET, NewStPet),
            NewPlayer = player_util:count_player_attribute(Player1, true),
            task_event:event(?TASK_ACT_PET_STAGE, {Times}),
            activity:get_notice(Player, [110, 33], true),
            {1, NewPlayer};
        {ok1, Player1, NewStPet} ->
            case data_pet_stage:get(StPet#st_pet.stage, StPet#st_pet.stage_lv) of
                [] ->
                    lib_dict:put(?PROC_STATUS_PET, NewStPet),
                    NewPlayer = player_util:count_player_attribute(Player1, true),
                    task_event:event(?TASK_ACT_PET_STAGE, {Times}),
                    activity:get_notice(Player, [110, 33], true),
                    {1, NewPlayer};
                BaseStage1 ->
                    if BaseStage1#base_pet_stage.exp == 0 ->
                        lib_dict:put(?PROC_STATUS_PET, NewStPet),
                        NewPlayer = player_util:count_player_attribute(Player1, true),
                        {1, NewPlayer};
                        true ->
                            upgrade_stage_more(Player1, NewStPet, Auto, BaseStage1, Times + 1)
                    end
            end;
        {Err, Player} ->
            if Times == 1 ->
                {Err, Player};
                true ->
                    lib_dict:put(?PROC_STATUS_PET, StPet),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    task_event:event(?TASK_ACT_PET_STAGE, {Times}),
                    activity:get_notice(Player, [110, 33], true),
                    {1, NewPlayer}
            end

    end.


check_stage_once(Player, StPet, Auto, BaseStage) ->
    case BaseStage#base_pet_stage.goods of
        {GoodsId, Num} ->
            Count = goods_util:get_goods_count(GoodsId),
            if Count >= Num ->
                goods:subtract_good(Player, [{GoodsId, Num}], 122),
                do_stage(Player, StPet, BaseStage);
                Count =< Num andalso Auto == 1 ->
                    case new_shop:get_goods_price(GoodsId) of
                        false -> {14, Player};
                        {ok, Type, Price} ->
                            Money = Price * (Num - Count),
                            case money:is_enough(Player, Money, Type) of
                                false -> {3, Player};
                                true ->
                                    goods:subtract_good(Player, [{GoodsId, Count}], 122),
                                    Player1 = money:cost_money(Player, Type, -Money, 122, GoodsId, Num - Count),
                                    do_stage(Player1, StPet, BaseStage)
                            end
                    end;
                true ->
                    goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 122),
                    {13, Player}
            end;
        _ -> {9, Player}
    end.


%%升级处理
do_stage(Player, StPet, BaseStage) ->
    StPet1 = calc_stage_exp(StPet, BaseStage#base_pet_stage.exp, BaseStage#base_pet_stage.add_exp),
    pet_log:log_pet_stage(Player#player.key, Player#player.nickname, StPet1#st_pet.stage, StPet1#st_pet.stage_lv, StPet1#st_pet.stage_exp),
    if StPet1#st_pet.stage /= StPet#st_pet.stage orelse StPet1#st_pet.stage_lv /= StPet#st_pet.stage_lv ->
        %%升阶了,处理图鉴
        StPet2 =
            if StPet1#st_pet.stage /= StPet#st_pet.stage ->
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1011, 0, StPet1#st_pet.stage),
                pet_pic:activate_pic_all(Player, StPet1);
                true ->
                    StPet1
            end,
        StageAttribute = pet_attr:calc_pet_stage_attribute(StPet2#st_pet.stage, StPet2#st_pet.stage_lv),
        StPet3 = StPet2#st_pet{stage_attribute = StageAttribute},
        fashion_suit:active_icon_push(Player),
        {ok, Player, pet_attr:calc_attribute(StPet3)};
        true ->
            {ok1, Player, StPet1}
    end.

%%计算升阶经验
calc_stage_exp(StPet, ExpLim, Add) ->
    Exp = StPet#st_pet.stage_exp + Add,
    if ExpLim == 0 -> StPet;
        Exp >= ExpLim ->
            Lv = StPet#st_pet.stage_lv + 1,
            MaxLv = data_pet_stage:get_max_lv(StPet#st_pet.stage),
            if Lv > MaxLv ->
                StPet#st_pet{stage = StPet#st_pet.stage + 1, stage_lv = 0, stage_exp = 0, is_change = 1};
                true ->
                    StPet#st_pet{stage_lv = Lv, stage_exp = 0, is_change = 1}
            end;
        true ->
            StPet#st_pet{stage_exp = Exp, is_change = 1}
    end.
