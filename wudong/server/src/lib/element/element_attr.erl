%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 三月 2018 13:49
%%%-------------------------------------------------------------------
-module(element_attr).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("element.hrl").

%% API
-export([
    cacl_jiandao_attr/1,
    cacl_element_attr/1,
    cacl_all_element_attr/1,
    cacl_st_element_attr/1,
    get_jiandao_attr/0,
    get_element_attr/0
]).

get_jiandao_attr() ->
    StJianDao = lib_dict:get(?PROC_STATUS_JIANDAO),
    #st_jiandao{attr = Attr} = StJianDao,
    Attr.

get_element_attr() ->
    StElement = lib_dict:get(?PROC_STATUS_ELEMENT),
    #st_element{attr = Attr} = StElement,
    Attr.


%% 计算玩家剑道属性
cacl_jiandao_attr(StJianDao) ->
    #st_jiandao{
        lv = Lv,
        point_id = PointId,
        stage = Stage
    } = StJianDao,
    BaseUpLvAttrs =
        if
            Lv == 0 ->
                case data_jiandao_uplv:get_by_stage_point_lv(Stage, PointId, Lv+1) of
                    [] -> [];
                    #base_jiandao_uplv{id = Id} ->
                        case data_jiandao_uplv:get(Id-1) of
                            [] -> [];
                            #base_jiandao_uplv{attrs = BaseUpLvAttrs0} -> BaseUpLvAttrs0
                        end
                end;
            true ->
                case data_jiandao_uplv:get_by_stage_point_lv(Stage, PointId, Lv) of
                    [] -> [];
                    #base_jiandao_uplv{id = Id} ->
                        case data_jiandao_uplv:get(Id) of
                            [] -> [];
                            #base_jiandao_uplv{attrs = BaseUpLvAttrs0} -> BaseUpLvAttrs0
                        end
                end
        end,
    #base_jiandao_stage{attrs = BaseStageAttrs} = data_jiandao_upstage:get(Stage),
    UpLvAttrs = attribute_util:make_attribute_by_key_val_list(BaseUpLvAttrs),
    StageAttrs = attribute_util:make_attribute_by_key_val_list(BaseStageAttrs),
    StJianDao#st_jiandao{
        attr = attribute_util:sum_attribute([UpLvAttrs, StageAttrs])
    }.

%% 计算单个元素属性
cacl_element_attr(Element) ->
    ?DEBUG("##########################################", []),
    #element{
        race = Race,
        lv = Lv,
        e_lv = ELv,
        stage = Stage
    } = Element,
    #base_element_up_lv{attrs = BaseAttrs} = data_element_uplv:get_by_race_lv(Race, Lv),
    Attrs = attribute_util:make_attribute_by_key_val_list(BaseAttrs),
    BaseEAttrs =
        case data_element_up_elv:get_by_race_elv(Race, ELv) of
            [] -> [];
            #base_element_up_elv{attrs = BaseEAttrs0} -> BaseEAttrs0
        end,
    EAttrs = attribute_util:make_attribute_by_key_val_list(BaseEAttrs),
    F = fun(BaseStage) ->
        data_element_tupo:get_attrs_by_stage_race(BaseStage, Race)
    end,
    BaseStageAttrs = lists:flatmap(F, lists:seq(0, Stage)),
    ?DEBUG("############BaseStageAttrs:~p", [BaseStageAttrs]),
    StageAttrs = attribute_util:make_attribute_by_key_val_list(BaseStageAttrs),
    Element#element{
        attr = Attrs,
        e_attr = EAttrs,
        stage_attr = StageAttrs
    }.

%% 计算玩家所有元素属性
cacl_all_element_attr(ElementList) ->
    F = fun(Element) ->
        #element{
            is_wear = IsWear,
            attr = Attr,
            e_attr = EAttr,
            stage_attr = StageAttr
        } = Element,
        if
            IsWear == 1 ->
                attribute_util:sum_attribute([Attr, EAttr, StageAttr]);
            true ->
                Attr
        end
    end,
    AttrList = lists:map(F, ElementList),
    attribute_util:sum_attribute(AttrList).

cacl_st_element_attr(StElement) ->
    #st_element{element_list = ElementList} = StElement,
    Attr = cacl_all_element_attr(ElementList),
    StElement#st_element{attr = Attr}.
