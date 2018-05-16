%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 三月 2018 11:14
%%%-------------------------------------------------------------------
-module(element).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("element.hrl").
-include("battle.hrl").
-include("skill.hrl").

%% API
-export([
    get_jiandao_info/1, %% 读取剑道面板信息
    jiandao_up_lv/1, %% 剑道升级
    jiandao_up_stage/1, %% 剑道进阶
    get_element_list/1, %% 读取元素信息
    element_up_lv/2, %% 元素升级
    element_up_e_lv/2, %% 元素属性升级
    element_up_stage/2, %% 元素进阶
    wear_element/3, %% 穿戴元素
    off_element/3 %% 卸下元素
]).

-export([
    update_jiandao/1,
    cacl_element_hurt/2
]).

cacl_element_hurt(Aer, Der) ->
    #bs{
        fire_att = A_FireAtt, %% 火系元素攻击
        wood_att = A_WoodAtt, %% 木系元素攻击
        wind_att = A_WindAtt, %% 风系元素攻击
        water_att = A_WaterAtt, %% 水系元素攻击
        light_att = A_LightAtt, %% 光系元素攻击
        dark_att = A_DarkAtt %% 暗系元素攻击
    } = Aer,
    #bs{
        fire_def = D_FireDef, %% 火系元素防御
        wood_def = D_WoodDef, %% 木系元素防御
        wind_def = D_WindDef, %% 风系元素防御
        water_def = D_WaterDef, %% 水系元素防御
        light_def = D_LightDef, %% 光系元素防御
        dark_def = D_DarkDef %% 暗系元素防御
    } = Der,
    Mult = (A_FireAtt-D_FireDef)/500000 + (A_WoodAtt-D_WoodDef)/500000 + (A_WindAtt-D_WindDef)/500000 + (A_WaterAtt-D_WaterDef)/500000 + (A_LightAtt-D_LightDef)/250000 + (A_DarkAtt-D_DarkDef)/250000,
    if
        Mult < -0.6 -> -0.6;
        Mult > 0.6 -> 0.6;
        true -> Mult
    end.

off_element(Player, _Race, Pos) ->
    StJiandao = lib_dict:get(?PROC_STATUS_JIANDAO),
    #st_jiandao{wear_list = WearList} = StJiandao,
    StElement = lib_dict:get(?PROC_STATUS_ELEMENT),
    #st_element{element_list = ElementList} = StElement,
    case lists:keytake(Pos, 2, WearList) of
        false -> {1, Player};
        {value, {Race, Pos}, Rest} ->
            NewStJiandao = StJiandao#st_jiandao{wear_list = Rest},
            case lists:keytake(Race, #element.race, ElementList) of
                false -> {1, Player};
                {value, Element, Rest99} ->
                    NewElement = Element#element{pos = 0, is_wear = 0},
                    NewStElement = StElement#st_element{element_list = [NewElement | Rest99]},
                    NewStElement99 = element_attr:cacl_st_element_attr(NewStElement),
                    NewStJiandao99 = element_attr:cacl_jiandao_attr(NewStJiandao),
                    lib_dict:put(?PROC_STATUS_JIANDAO, NewStJiandao99),
                    lib_dict:put(?PROC_STATUS_ELEMENT, NewStElement99),
                    element_load:update_element(NewElement),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    F = fun(#element{race = Race0, is_wear = IsWear0, pos = Pos0}) -> ?IF_ELSE(IsWear0 == 1, [{Race0, Pos0}], []) end,
                    WearElementRaceList = lists:flatmap(F, NewStElement99#st_element.element_list),
                    NewPlayer99 = NewPlayer#player{wear_element_list = WearElementRaceList},
                    player_handle:sync_data(wear_element_list, NewPlayer99),
                    {1, NewPlayer99}
            end
    end.

wear_element(Player, 0, _pos) -> {0, Player};
wear_element(Player, _Race, 0) -> {0, Player};
wear_element(Player, Race, Pos) ->
    StJiandao = lib_dict:get(?PROC_STATUS_JIANDAO),
    #st_jiandao{wear_list = WearList, stage = Stage} = StJiandao,
    StElement = lib_dict:get(?PROC_STATUS_ELEMENT),
    #st_element{element_list = ElementList} = StElement,
    case lists:keytake(Pos, 2, WearList) of
        false ->
            Base = data_jiandao_upstage:get(Stage),
            if
                Base#base_jiandao_stage.wear_element_max == length(WearList) -> {11, Player};
                true ->
                    case lists:keytake(Race, #element.race, ElementList) of
                        false ->
                            {8, Player}; %% 还未激活
                        {value, Element, Rest} ->
                            NewElement = Element#element{pos = Pos, is_wear = 1},
                            NewStElement = StElement#st_element{element_list = [NewElement | Rest]},
                            NewWearList = [{Race, Pos} | WearList],
                            NewStJiandao = StJiandao#st_jiandao{wear_list = NewWearList},
                            NewStElement99 = element_attr:cacl_st_element_attr(NewStElement),
                            NewStJiandao99 = element_attr:cacl_jiandao_attr(NewStJiandao),
                            lib_dict:put(?PROC_STATUS_JIANDAO, NewStJiandao99),
                            lib_dict:put(?PROC_STATUS_ELEMENT, NewStElement99),
                            element_load:update_element(NewElement),
                            log(Element, NewElement),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            F = fun(#element{race = Race0, is_wear = IsWear0, pos = Pos0}) -> ?IF_ELSE(IsWear0 == 1, [{Race0, Pos0}], []) end,
                            WearElementRaceList = lists:flatmap(F, NewStElement99#st_element.element_list),
                            NewPlayer99 = NewPlayer#player{wear_element_list = WearElementRaceList},
                            player_handle:sync_data(wear_element_list, NewPlayer99),
                            {1, NewPlayer99}
                    end
            end;
        {value, {OldRace, _Index}, RestWearList} ->
            if
                Race == OldRace ->
                    {7, Player}; %% 已穿戴
                true ->
                    case lists:keytake(Race, #element.race, ElementList) of
                        false ->
                            {8, Player}; %% 还未激活
                        {value, Element, Rest} ->
                            if
                                Element#element.is_wear > 0 -> {12, Player};
                                true ->
                                    case lists:keytake(OldRace, #element.race, Rest) of
                                        false -> NewRest = Rest;
                                        {value, OldElement, NewRest0} ->
                                            OldElement99 = OldElement#element{pos = 0, is_wear = 0},
                                            element_load:update_element(OldElement99),
                                            log(OldElement, OldElement99),
                                            NewRest = [OldElement99 | NewRest0]
                                    end,
                                    NewElement = Element#element{pos = Pos, is_wear = 1},
                                    NewStElement = StElement#st_element{element_list = [NewElement | NewRest]},
                                    NewWearList = [{Race, Pos} | RestWearList],
                                    NewStJiandao = StJiandao#st_jiandao{wear_list = NewWearList},
                                    NewStElement99 = element_attr:cacl_st_element_attr(NewStElement),
                                    NewStJiandao99 = element_attr:cacl_jiandao_attr(NewStJiandao),
                                    lib_dict:put(?PROC_STATUS_JIANDAO, NewStJiandao99),
                                    lib_dict:put(?PROC_STATUS_ELEMENT, NewStElement99),
                                    element_load:update_element(NewElement),
                                    log(Element, NewElement),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    F = fun(#element{race = Race0, is_wear = IsWear0, pos = Pos0}) ->
                                        ?IF_ELSE(IsWear0 == 1, [{Race0, Pos0}], []) end,
                                    WearElementRaceList = lists:flatmap(F, NewStElement99#st_element.element_list),
                                    NewPlayer99 = NewPlayer#player{wear_element_list = WearElementRaceList},
                                    player_handle:sync_data(wear_element_list, NewPlayer99),
                                    {1, NewPlayer99}
                            end
                    end
            end
    end.

log(OldElement, NewElement) ->
    #element{pos = OldPos} = OldElement,
    #element{pos = NewPos, pkey = Pkey, race = Race} = NewElement,
    Now = util:unixtime(),
    Sql = io_lib:format("replace into log_element_wear set pkey=~p, race=~p, old_pos=~p, new_pos=~p, `time`=~p",
        [Pkey, Race, OldPos, NewPos, Now]),
    log_proc:log(Sql),
    ok.

element_up_stage(Player, 0) -> {0, Player};
element_up_stage(Player, Race) ->
    StElement = lib_dict:get(?PROC_STATUS_ELEMENT),
    #st_element{element_list = ElementList} = StElement,
    case lists:keytake(Race, #element.race, ElementList) of
        false -> {8, Player}; %% 还未激活
        {value, Element, Rest} ->
            #element{race = Race, stage = Stage, e_lv = Elv} = Element,
            case Elv < data_element_tupo:get_limit_lv_by_stage_race(Stage + 1, Race) of
                true ->
                    {6, Player};
                false ->
                    case data_element_tupo:get_consume_by_stage_race(Stage + 1, Race) of
                        [] -> {5, Player}; %% 已满阶
                        Consume ->
                            case check_consume(Player, Consume) of
                                false -> {3, Player};
                                true ->
                                    {ok, _} = goods:subtract_good(Player, Consume, 770),
                                    NElement = Element#element{stage = Stage + 1},
                                    NewElement = element_attr:cacl_element_attr(NElement),
                                    NStElement = StElement#st_element{element_list = [NewElement | Rest]},
                                    NewStElement = element_attr:cacl_st_element_attr(NStElement),
                                    lib_dict:put(?PROC_STATUS_ELEMENT, NewStElement),
                                    element_load:update_element(NewElement),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    Sql = io_lib:format("replace into log_element_up_stage set pkey=~p,race=~p,stage=~p,cost='~s',`time`=~p",
                                        [Player#player.key, Race, Stage + 1, util:term_to_bitstring(Consume), util:unixtime()]),
                                    log_proc:log(Sql),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

element_up_e_lv(Player, 0) ->
    {0, Player};
element_up_e_lv(Player, Race) ->
    StElement = lib_dict:get(?PROC_STATUS_ELEMENT),
    #st_element{element_list = ElementList} = StElement,
    case lists:keytake(Race, #element.race, ElementList) of
        false -> {8, Player}; %% 还未激活
        {value, Element, Rest} ->
            #element{race = Race, e_lv = ELv, stage = Stage} = Element,
            case data_element_up_elv:get_by_race_elv(Race, ELv + 1) of
                [] -> {5, Player}; %% 已满级
                #base_element_up_elv{
                    consume = Consume,
                    stage_limit = StageLimit
                } ->
                    if
                        Stage < StageLimit -> {13, Player};
                        true ->
                            case check_consume(Player, Consume) of
                                false -> {3, Player};
                                true ->
                                    {ok, _} = goods:subtract_good(Player, Consume, 771),
                                    NElement = Element#element{e_lv = ELv + 1},
                                    NewElement = element_attr:cacl_element_attr(NElement),
                                    NStElement = StElement#st_element{element_list = [NewElement | Rest]},
                                    NewStElement = element_attr:cacl_st_element_attr(NStElement),
                                    lib_dict:put(?PROC_STATUS_ELEMENT, NewStElement),
                                    element_load:update_element(NewElement),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    Sql = io_lib:format("replace into log_element_up_e_lv set pkey=~p,race=~p,e_lv=~p,cost='~s',`time`=~p",
                                        [Player#player.key, Race, ELv + 1, util:term_to_bitstring(Consume), util:unixtime()]),
                                    log_proc:log(Sql),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

element_up_lv(Player, 0) -> {0, Player};
element_up_lv(Player, Race) ->
    StElement = lib_dict:get(?PROC_STATUS_ELEMENT),
    #st_element{element_list = ElementList} = StElement,
    case lists:keytake(Race, #element.race, ElementList) of
        false ->
            act_element(Player, Race);
        {value, Element, Rest} ->
            #element{race = Race, lv = Lv} = Element,
            case data_element_uplv:get_by_race_lv(Race, Lv + 1) of
                [] -> {9, Player}; %% 已经满级
                #base_element_up_lv{consume = Consume} ->
                    case check_consume(Player, Consume) of
                        false -> {3, Player};
                        true ->
                            {ok, _} = goods:subtract_good(Player, Consume, 769),
                            NElement = Element#element{lv = Lv + 1},
                            NewElement = element_attr:cacl_element_attr(NElement),
                            NStElement = StElement#st_element{element_list = [NewElement | Rest]},
                            NewStElement = element_attr:cacl_st_element_attr(NStElement),
                            lib_dict:put(?PROC_STATUS_ELEMENT, NewStElement),
                            element_load:update_element(NewElement),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            Sql = io_lib:format("replace into log_element_up_lv set pkey=~p,race=~p,lv=~p,cost='~s',`time`=~p",
                                [Player#player.key, Race, Lv + 1, util:term_to_bitstring(Consume), util:unixtime()]),
                            log_proc:log(Sql),
                            {1, NewPlayer}
                    end
            end
    end.

act_element(Player, Race) ->
    UnlockStage = data_element_unlock:get(Race),
    StJiandao = lib_dict:get(?PROC_STATUS_JIANDAO),
    #st_jiandao{stage = Stage} = StJiandao,
    #base_element_up_lv{consume = Consume} = data_element_uplv:get_by_race_lv(Race, 1),
    if
        Stage < UnlockStage -> {10, Player};
        true ->
            case check_consume(Player, Consume) of
                false -> {3, Player};
                true ->
                    StElement = lib_dict:get(?PROC_STATUS_ELEMENT),
                    #st_element{element_list = ElementList} = StElement,
                    Element =
                        #element{
                            pkey = Player#player.key,
                            race = Race,
                            lv = 1
                        },
                    NewElement = element_attr:cacl_element_attr(Element),
                    NStElement = StElement#st_element{element_list = [NewElement | ElementList]},
                    NewStElement = element_attr:cacl_st_element_attr(NStElement),
                    lib_dict:put(?PROC_STATUS_ELEMENT, NewStElement),
                    element_load:update_element(NewElement),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    {1, NewPlayer}
            end
    end.

get_element_list(_Player) ->
    StElement = lib_dict:get(?PROC_STATUS_ELEMENT),
    #st_element{element_list = ElementList} = StElement,
    F = fun(Element) ->
        #element{
            race = Race,
            lv = Lv,
            e_lv = ELv,
            stage = Stage,
            attr = Attr,
            e_attr = EAttr,
            stage_attr = StageAttr
        } = Element,
        ProAttr = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- attribute_util:make_attribute_to_key_val(Attr)],
        ProEAttr = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- attribute_util:make_attribute_to_key_val(EAttr)],
        ProStageAttr = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- attribute_util:make_attribute_to_key_val(StageAttr)],
        [Race, Lv, ELv, Stage, ProAttr, ProEAttr, ProStageAttr]
    end,
    lists:map(F, ElementList).

jiandao_up_lv(Player) ->
    StJiandao = lib_dict:get(?PROC_STATUS_JIANDAO),
    #st_jiandao{stage = Stage, lv = Lv, point_id = PointId} = StJiandao,
    case data_jiandao_uplv:get_by_stage_point_lv(Stage, PointId, Lv + 1) of
        [] -> {2, Player}; %%已是最高等级
        #base_jiandao_uplv{consume = Consume} ->
            case check_consume(Player, Consume) of
                false -> {3, Player}; %% 材料不足
                true ->
                    {ok, _} = goods:subtract_good(Player, Consume, 767),
                    MaxLv = data_jiandao_uplv:get_max_lv(),
                    MaxPointId = data_jiandao_uplv:get_max_pointId(),
                    NStJianDao =
                        if
                            PointId == MaxPointId andalso Lv + 1 == MaxLv ->
                                StJiandao#st_jiandao{
                                    lv = Lv + 1,
                                    point_id = PointId
                                };
                            true ->
                                StJiandao#st_jiandao{
                                    lv = ?IF_ELSE(Lv + 1 == MaxLv, 0, Lv + 1),
                                    point_id = ?IF_ELSE(Lv + 1 == MaxLv, PointId + 1, PointId)
                                }
                        end,
                    NewStJianDao = element_attr:cacl_jiandao_attr(NStJianDao),
                    lib_dict:put(?PROC_STATUS_JIANDAO, NewStJianDao),
                    element_load:update_jiandao(NewStJianDao),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    Sql = io_lib:format("replace into log_jiandao_up_lv set pkey=~p,point_id=~p,lv=~p, cost='~s',`time`=~p",
                        [Player#player.key, PointId, Lv + 1, util:term_to_bitstring(Consume), util:unixtime()]),
                    log_proc:log(Sql),
                    {1, NewPlayer}
            end
    end.

check_consume(_Player, Consume) ->
    F = fun({GId, GNum}) ->
        goods_util:get_goods_count(GId) < GNum
    end,
    case lists:any(F, Consume) of
        true -> false;
        false -> true
    end.

jiandao_up_stage(Player) ->
    StJiandao = lib_dict:get(?PROC_STATUS_JIANDAO),
    #st_jiandao{stage = Stage, lv = Lv} = StJiandao,
    case Lv == data_jiandao_uplv:get_max_lv() of
        false -> {4, Player}; %% 等级不足
        true ->
            case data_jiandao_upstage:get(Stage + 1) of
                [] -> {5, Player}; %% 已经满阶
                #base_jiandao_stage{consume = Consume} ->
                    case check_consume(Player, Consume) of
                        false -> {3, Player}; %% 材料不足
                        true ->
                            {ok, _} = goods:subtract_good(Player, Consume, 768),
                            NStJianDao =
                                StJiandao#st_jiandao{
                                    stage = Stage + 1,
                                    point_id = 1,
                                    lv = 0
                                },
                            NewStJianDao = element_attr:cacl_jiandao_attr(NStJianDao),
                            lib_dict:put(?PROC_STATUS_JIANDAO, NewStJianDao),
                            element_load:update_jiandao(NewStJianDao),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            Sql = io_lib:format("replace into log_jiandao_up_stage set pkey=~p,stage=~p,cost='~s',`time`=~p",
                                [Player#player.key, Stage + 1, util:term_to_bitstring(Consume), util:unixtime()]),
                            log_proc:log(Sql),
                            NewPlayer99 = NewPlayer#player{jiandao_stage = Stage+1},
                            player_handle:sync_data(jiandao_stage, NewPlayer99),
                            #base_jiandao_stage{skill_list = SkillList} = data_jiandao_upstage:get(Stage + 1),
                            JianDaoSkillList = lists:map(fun(SkillId) -> {SkillId, ?PASSIVE_SKILL_TYPE_JIANDAO} end, SkillList),
                            {1, NewPlayer99#player{
                                passive_skill = util:list_filter_repeat(JianDaoSkillList ++ Player#player.passive_skill)
                            }}
                    end
            end
    end.

get_jiandao_info(_Player) ->
    StJianDao = lib_dict:get(?PROC_STATUS_JIANDAO),
    #st_jiandao{
        stage = Stage,
        lv = Lv,
        point_id = PointId,
        wear_list = WearList,
        attr = Attr
    } = StJianDao,
    #base_jiandao_stage{wear_element_max = WearMaxNum} = data_jiandao_upstage:get(Stage),
    ProWearList = util:list_tuple_to_list(WearList),
    ProAttr = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- attribute_util:make_attribute_to_key_val(Attr)],
    ElementAttr = get_wear_element_attr(),
    ProElementAttr = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- attribute_util:make_attribute_to_key_val(ElementAttr)],
    {Stage, PointId, Lv, WearMaxNum, ProWearList, ProAttr, ProElementAttr}.

get_wear_element_attr() ->
    StElement = lib_dict:get(?PROC_STATUS_ELEMENT),
    #st_element{
        element_list = ElementList
    } = StElement,
    F = fun(Element) ->
        #element{
            e_attr = EAttr,
            stage_attr = StageAttr,
            is_wear = IsWear
        } = Element,
        if
            IsWear == 1 ->
                attribute_util:sum_attribute([EAttr, StageAttr]);
            true ->
                #attribute{}
        end
    end,
    attribute_util:sum_attribute(lists:map(F, ElementList)).

update_jiandao(StJiandao) ->
    StElement = lib_dict:get(?PROC_STATUS_ELEMENT),
    #st_jiandao{stage = Stage} = StJiandao,
    #st_element{
        element_list = ElementList
    } = StElement,
    F = fun(Element) ->
        #element{is_wear = IsWear, pos = Pos, race = Race} = Element,
        ?IF_ELSE(IsWear == 1, [{Race, Pos}], [])
    end,
    WearList = lists:flatmap(F, ElementList),
    #base_jiandao_stage{skill_list = BaseSkillList} = data_jiandao_upstage:get(Stage),
    StJiandao#st_jiandao{
        wear_list = WearList,
        skill_list = BaseSkillList
    }.
