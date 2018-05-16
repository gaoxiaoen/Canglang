%%%-------------------------------------------------------------------
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(baby_init).
-author("lzx").
-include("common.hrl").
-include("baby.hrl").
-include("server.hrl").

-export([
    init/1,
    init_baby/1,
    upgrade_lv/1,
    timer_update/0,
    logout/0
]).


init(Player) ->
    StBaby =
        case player_util:is_new_role(Player) of
            true ->
                #baby_st{pkey = Player#player.key};
            false ->
                init_baby(Player#player.key)
        end,
    StBaby1 = baby_attr:calc_baby_attrbute(Player, StBaby),
    lib_dict:put(?PROC_STATUS_PLAYER_BABY, StBaby1),
    NewPlayr = baby_attr:init_fight_baby(Player, StBaby1),
    %%计算阶数战力
    upgrade_lv(NewPlayr),
    NewPlayr.


upgrade_lv(Player) ->
    CoupleKey = Player#player.marry#marry.couple_key,
    case CoupleKey > 0 of
        true ->  %%已经结婚的
            baby_util:player_marriage(Player, CoupleKey);
        false ->
            ok
    end.


init_baby(PKey) ->
    case baby_load:load_baby(PKey) of
        [Type_id, Name, Figure, FigureListBin, StepLv, Step_exp, Lv, Lv_exp, State, _Time, Skill, EquipList] ->
            FigureList = util:bitstring_to_term(FigureListBin),
            NewFigureList = init_figure_list(FigureList, Figure, Name),
            IsChange = ?IF_ELSE(FigureList == NewFigureList, 1, 0),
            BabySt = #baby_st{
                pkey = PKey,
                type_id = Type_id,
                name = Name,
                figure_id = Figure,
                figure_list = NewFigureList,
                step = StepLv,
                step_exp = Step_exp,
                lv = Lv,
                lv_exp = Lv_exp,
                state = State,
                skill_list = util:bitstring_to_term(Skill),
                equip_list = util:bitstring_to_term(EquipList),
                born_time = _Time,
                is_change = IsChange
            },
            case lists:keyfind(1, 1, BabySt#baby_st.skill_list) of
                false -> %% 第一个技能默认开启
                    case data_baby:get(BabySt#baby_st.type_id) of
                        #base_baby{skill_list = SkillList} ->
                            case lists:keyfind(1, 1, SkillList) of
                                {_, _NeedLv, SkillId} ->
                                    BabySt#baby_st{
                                        skill_list = [{1, SkillId} | BabySt#baby_st.skill_list],
                                        is_change = 1
                                    };
                                _ ->
                                    BabySt

                            end;
                        _ ->
                            BabySt

                    end;
                _ ->
                    BabySt
            end;

        _R ->
            #baby_st{pkey = PKey}
    end.


timer_update() ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    if BabySt#baby_st.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_PLAYER_BABY, BabySt#baby_st{is_change = 0}),
        baby_load:replace_baby(BabySt);
        true -> ok
    end.


logout() ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    if BabySt#baby_st.is_change == 1 ->
        baby_load:replace_baby(BabySt);
        true -> ok
    end.


init_figure_list(FigureList, CurFigureId, CurName) ->
    F = fun(Item) ->
        case Item of
            {FigureId, Star, _Name, Acc} when FigureId == CurFigureId ->
                {FigureId, Star, CurName, Acc};
            {FigureId, Star, Name, Acc} ->
                {FigureId, Star, Name, Acc};
            _ ->
                {Item, 1, data_baby_pic:get_name(Item), 0}
        end
        end,
    lists:map(F, FigureList).
















