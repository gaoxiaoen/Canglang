%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%        %%宠物属性的计算
%%% @end
%%% Created : 07. 八月 2017 15:07
%%%-------------------------------------------------------------------
-module(baby_attr).
-author("lzx").
-include("server.hrl").
-include("baby.hrl").
-include("common.hrl").
-include("skill.hrl").
-include("goods.hrl").


%% API
-export([
    init_fight_baby/2,
    get_baby_attribute/0,
    calc_baby_attrbute/2,
    update_baby_attr/3
]).


%% @doc 获取宝宝属性
get_baby_attribute() ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    BabySt#baby_st.attribute.


%% @doc 计算阶数属性
calc_baby_stage_attribute(BabyId, Step) ->
    case data_baby_step:get(BabyId, Step) of
        #base_baby_step{attrs = AttrList} ->
            attribute_util:make_attribute_by_key_val_list(AttrList);
        _ -> #attribute{}
    end.


%% @doc 计算等级属性
calc_baby_lv_attribute(Lv) ->
    case data_baby_exp:get(Lv) of
        #base_baby_exp{attrs = AttrList} ->
            attribute_util:make_attribute_by_key_val_list(AttrList);
        _ -> #attribute{}
    end.


%% 计算宝宝属性
calc_baby_attrbute(Player, StBaby) ->
    FigureAttrList = cal_baby_pic_attribute(StBaby),
    StageAttribute = calc_baby_stage_attribute(StBaby#baby_st.type_id, StBaby#baby_st.step),
    LvAttribute0 = calc_baby_lv_attribute(StBaby#baby_st.lv),
    LvAttribute = cal_baby_couple_attrbute(Player, StBaby, LvAttribute0),
    SKillAttriBute = calc_baby_skill_attribute(StBaby),
    EquipAttribute = cal_baby_equip_attribute(StBaby),
    AttributeList = [FigureAttrList, StageAttribute, LvAttribute, SKillAttriBute, EquipAttribute],
    Attribute = attribute_util:sum_attribute(AttributeList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    StBaby#baby_st{
        attribute = Attribute,
        cbp = Cbp
    }.

cal_baby_couple_attrbute(Player, StBaby, SumAttrButeList) ->
    case Player#player.marry#marry.mkey == 0 of
        true ->
            SumAttrButeList;
        false ->
            Pkey = Player#player.marry#marry.couple_key,
            CoupleLv = baby_util:get_couple_lv(Pkey),
            Lv2 = StBaby#baby_st.lv,
            P1 = data_baby_love_attri:get(CoupleLv),
            P2 = data_baby_love_attri:get(Lv2),
            BasePercent = min(P1, P2),
            case BasePercent > 0 of
                true ->
                    ?PRINT("BasePercent ~w =========", [BasePercent]),
                    SumAttrButeList2 = attribute_util:make_attribute_to_key_val(SumAttrButeList),
                    F = fun({Key, Val}) -> {Key, round(Val * (10000 + BasePercent) / 10000)} end,
                    NewAttri = lists:map(F, SumAttrButeList2),
                    attribute_util:make_attribute_by_key_val_list(NewAttri);
                false ->
                    SumAttrButeList
            end
    end.


%% @doc 重新计算宠物属性
update_baby_attr(Player, StBaby, _Type) ->
    IsChangeAttr = lists:member(_Type, [upgrade_step, feed_baby, crate_baby, upgrade_skill, active_pic, equip_goods, change_sex, couple_upgrade]),%%会改变玩家属性的
    IsSceneUpdate = lists:member(_Type, [change_name, change_figure]),
    if IsChangeAttr ->
        %% 计算战力同步场景信息
        StBaby1 = calc_baby_attrbute(Player, StBaby),
        lib_dict:put(?PROC_STATUS_PLAYER_BABY, StBaby1),
        NewPlayer = player_util:count_player_attribute(Player, true),
        NewPlayer2 = init_fight_baby(NewPlayer, StBaby1),
        scene_agent_dispatch:baby_update(NewPlayer2),
        NewPlayer2;
        IsSceneUpdate -> %%不改变战力
            lib_dict:put(?PROC_STATUS_PLAYER_BABY, StBaby),
            NewPlayer = init_fight_baby(Player, StBaby),
            scene_agent_dispatch:baby_update(NewPlayer),
            NewPlayer;
        true ->
            lib_dict:put(?PROC_STATUS_PLAYER_BABY, StBaby),
            NewPlayer = init_fight_baby(Player, StBaby),
            NewPlayer
    end.


%%计算技能属性
calc_baby_skill_attribute(BabySt) ->
    F = fun({_, SkillId}) ->
        case data_skill:get(SkillId) of
            [] -> [];
            Skill ->
                Skill#skill.attrs
        end
        end,
    AttrList = lists:flatmap(F, BabySt#baby_st.skill_list),
    attribute_util:make_attribute_by_key_val_list(AttrList).


%%计算装备属性
cal_baby_equip_attribute(BabySt) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    EquipAttrList = lists:flatmap(
        fun({_, EquipId, GoodsKey}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    AttrList1 =
                        case goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
                            #goods{fix_attrs = FixAttrs, random_attrs = RandomAttrs} ->
                                FixAttrs ++ RandomAttrs;
                            _ ->
                                []
                        end,
                    GoodsType#goods_type.attr_list ++ AttrList1
            end
        end, BabySt#baby_st.equip_list),
    attribute_util:make_attribute_by_key_val_list(EquipAttrList).


%% @doc 计算宝宝图鉴加成
cal_baby_pic_attribute(#baby_st{figure_list = FigureList}) ->
    lists:foldl(fun({FigureId, _Star, _, _}, SumAttrList) ->
        case data_baby_pic:get(FigureId, _Star) of
            #base_baby_pic{attrs = AttrList, skill_id = SkillId} ->
                SKillAttr =
                    case data_skill:get(SkillId) of
                        [] -> [];
                        Skill ->
                            Skill#skill.attrs
                    end,
                Attrs = attribute_util:make_attribute_by_key_val_list(AttrList ++ SKillAttr),
                attribute_util:sum_attribute([SumAttrList, Attrs]);
            _ ->
                SumAttrList
        end
                end, #attribute{}, FigureList).


%% @doc
init_fight_baby(Player, #baby_st{type_id = TypeId, figure_id = FigureId, name = BabyName,
    step = Step, lv = Lv, skill_list = SkillList, attribute = Attr}) ->
    FBaby = #fbaby{
        type_id = TypeId,
        name = BabyName,
        figure = FigureId,
        step = Step,
        lv = Lv,
        att = Attr,
        skill = SkillList
    },
    Player#player{baby = FBaby}.

