%% @author and_me
%% @doc @todo Add description to wing_attr.


-module(wing_attr).
-include("common.hrl").
-include("wing.hrl").
-include("goods.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([calc_wing_attr/1,
    get_wing_attr/0,
    get_wing_state_attr/0,
    calc_spirit_attribute/1]).


calc_wing_attr(WingStatus) ->
    Now = util:unixtime(),
    StarAttr = lists:foldr(fun({WingId, Star}, AttrStar) ->
        case data_wing_star:get(WingId, Star) of
            [] ->
                AttrStar;
            WingStar ->
                SAttr = attribute_util:make_attribute_by_key_val_list(WingStar#base_wing_star.attr_list),
                attribute_util:sum_attribute([AttrStar, SAttr])
        end end,
        #attribute{}, WingStatus#st_wing.star_list),
    Percent = get_grow_dan(WingStatus),
    StageAttr =
        case data_wing_stage:get(WingStatus#st_wing.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(WingStatus#st_wing.exp, BaseData#base_wing_stage.exp, BaseData#base_wing_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_wing_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,

    ImageAttr = lists:foldr(fun(InWingId, AttrOut) ->
        case data_wing:get(InWingId) of
            BaseWing when is_record(BaseWing, base_wing) ->
                Attr = attribute_util:make_attribute_by_key_val_list(BaseWing#base_wing.add_attr),
                attribute_util:sum_attribute([AttrOut, Attr]);
            _ ->
                AttrOut
        end
    end,
        #attribute{},
        [WingId || {WingId, Time} <- WingStatus#st_wing.own_special_image, Time == 0 orelse Time > Now]),

    SkillAttribute = wing_skill:calc_wing_skill_attribute(WingStatus#st_wing.skill_list),
    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_WING),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, WingStatus#st_wing.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),
    %%灵脉属性
    SpiritAttribute = calc_spirit_attribute(WingStatus#st_wing.spirit_list),

    %% 图鉴等级属性
    F = fun({WingId0, ActList}) ->
        F0 = fun(Lv) ->
            case data_wing_star:get(WingId0, Lv) of
                [] -> [];
                #base_wing_star{lv_attr = LvAttr} ->
                    LvAttr
            end
        end,
        lists:flatmap(F0, ActList)
    end,
    Attr3 = attribute_util:make_attribute_by_key_val_list(lists:flatmap(F, WingStatus#st_wing.activation_list)),

    Attribute = attribute_util:sum_attribute([StarAttr, StageAttr, ImageAttr, SkillAttribute, EquipAttribute, DanAttr, SpiritAttribute, Attr3]),
    %%  ?DEBUG("WingStatus ~p~n",[WingStatus#st_wing.wing_attribute]),
    %% ?DEBUG("Attribute ~p~n",[Attribute]),
    WingStatus#st_wing{
        cbp = attribute_util:calc_combat_power(Attribute),
        wing_attribute = Attribute}.

%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_wing_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_wing_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case wing_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_wing_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_wing_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).


get_grow_dan(Wing) ->
    case data_grow_dan:get(?GOODS_GROW_ID_WING) of
        [] -> 0;
        Base ->
            Wing#st_wing.grow_num * Base#base_grow_dan.attr_percent
    end.


get_wing_attr() ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    WingSt#st_wing.wing_attribute.

get_wing_state_attr() ->
    #attribute{}.

%% ====================================================================@lv
%% Internal functions
%% ====================================================================


