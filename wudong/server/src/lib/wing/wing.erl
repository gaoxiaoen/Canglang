%% @author and_me
%% @doc @todo Add description to wing.


-module(wing).
-include("common.hrl").
-include("wing.hrl").
-include("new_shop.hrl").
-include("goods.hrl").
-include("tips.hrl").
-include("activity.hrl").
-include("achieve.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([
    select_image/2,
    activate_wing_by_goods/2,
    get_wing_power/0,
    check_upgrade_state/0,
    check_evolve_state/0,
    check_des_time/2,
    upgrade_star/2,
    get_stage_attr/0,
    have_wing/1,
    get_total_star/0,
    equip_goods/2,
    use_wing_dan/1,

    check_use_wing_dan_state/2,
    get_equip_smelt_state/0,
    check_upgrade_star/0,
    activation_stage_lv/2
]).


%% ====================================================================
%% Internal functions
%% ====================================================================
check_upgrade_star() ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    F = fun(WingId) ->
        {Star, _NewStarList} =
            case lists:keytake(WingId, 1, WingSt#st_wing.star_list) of
                {value, {WingId, OldStar}, L} ->
                    {OldStar, [{WingId, OldStar + 1} | L]};
                _ ->
                    {0, [{WingId, 1} | WingSt#st_wing.star_list]}
            end,
        case data_wing_star:get(WingId, Star + 1) of
            [] -> [];
            BaseWingStar ->
                case BaseWingStar#base_wing_star.need_goods of
                    [] -> [];
                    [{GoodsId, Num} | _] ->
                        GoodsCount = goods_util:get_goods_count(GoodsId),
                        if GoodsCount < Num -> [];
                            true -> [1]
                        end
                end
        end
    end,
    LL = lists:flatmap(F, data_wing_star:wing_list()),

    Wing = lib_dict:get(?PROC_STATUS_WING),
    F2 = fun(WingId) ->
        case lists:keyfind(WingId, 1, Wing#st_wing.star_list) of
            false ->
                [];
            {WingId, Stage} ->
                StageList = get_stage_list(WingId, Stage),
                case lists:keytake(WingId, 1, Wing#st_wing.activation_list) of
                    {value, {WingId, ActList}, _T} ->
                        NewActivationList = StageList -- ActList,
                        if
                            NewActivationList == [] -> [];
                            true ->
                                [1]
                        end;
                    false ->
                        if
                            StageList == [] -> [];
                            true ->
                                [1]
                        end
                end
        end
    end,
    LL2 = lists:flatmap(F2, data_wing_star:wing_list()),

    ?IF_ELSE(LL ++ LL2 == [], 0, 1).


upgrade_star(Player, WingId) ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    case lists:member(WingId, data_wing_star:wing_list()) of
        false -> {false, 45};
        true ->
            {Star, NewStarList} =
                case lists:keytake(WingId, 1, WingSt#st_wing.star_list) of
                    {value, {WingId, OldStar}, L} ->
                        {OldStar, [{WingId, OldStar + 1} | L]};
                    _ ->
                        {0, [{WingId, 1} | WingSt#st_wing.star_list]}
                end,
            case data_wing_star:get(WingId, Star + 1) of
                [] ->
                    {false, 10};
                BaseWingStar ->
                    case BaseWingStar#base_wing_star.need_goods of
                        [] -> {false, 10};
                        [{GoodsId, Num} | _] ->
                            GoodsCount = goods_util:get_goods_count(GoodsId),
                            if GoodsCount < Num ->
                                {false, 3};
                                true ->
                                    goods:subtract_good_throw(Player, [{GoodsId, Num}], 150),
                                    OwnSpecialImage = [{WingId, 0} | lists:keydelete(WingId, 1, WingSt#st_wing.own_special_image)],
                                    NewWingSt = WingSt#st_wing{star_list = NewStarList, own_special_image = OwnSpecialImage, is_change = 1},
                                    NewWingSt1 = wing_attr:calc_wing_attr(NewWingSt),
                                    lib_dict:put(?PROC_STATUS_WING, NewWingSt1),
                                    wing_pack:send_wing_info(NewWingSt1, Player),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_wing_star(Player#player.key, Player#player.nickname, WingId, Star + 1),
                                    {ok, NewPlayer}
                            end
                    end
            end
    end.


log_wing_star(Pkey, Nickname, MountId, Star) ->
    Sql = io_lib:format("insert into log_wing_star set pkey=~p,nickname='~s',wing_id=~p,star=~p,time=~p",
        [Pkey, Nickname, MountId, Star, util:unixtime()]),
    log_proc:log(Sql).

%%检查翅膀是否可升级
check_upgrade_state() ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    BaseData = data_wing_stage:get(WingSt#st_wing.stage),
    case WingSt#st_wing.stage >= data_wing_stage:max_stage() of
        true -> 0;
        false ->
            CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_wing_stage.goods_ids)],
            Num = BaseData#base_wing_stage.num,
            Awing = lists:sum([Val || {_, Val} <- CountList]),
            if Awing >= Num * 1 andalso BaseData#base_wing_stage.cd < 1 ->
                1;
                true -> 0
            end
    end.

%%检查翅膀是否可升阶
check_evolve_state() -> 0.

have_wing(WingId) ->
    StWing = lib_dict:get(?PROC_STATUS_WING),
    case lists:keyfind(WingId, 1, StWing#st_wing.star_list) of
        false -> {false, 0};
        {_, Lv} -> {true, Lv}
    end.


activate_wing_by_goods(Player, [WingId, Time]) ->
    StWing = lib_dict:get(?PROC_STATUS_WING),
    {ok, NewPlayer} = activate_wing(Player, StWing, WingId, Time),
    NewPlayer.


activate_wing(Player, StWing, WingId, Time) ->
    data_wing:get(WingId),
    case lists:keytake(WingId, 1, StWing#st_wing.own_special_image) of
        false when Time =:= 0 ->
            StWing1 = StWing#st_wing{
                star_list = [{WingId, 1} | StWing#st_wing.star_list],
                current_image_id = WingId, own_special_image = [{WingId, Time} | StWing#st_wing.own_special_image]},
            ok;
        false ->
            StWing1 = StWing#st_wing{
                star_list = [{WingId, 1} | StWing#st_wing.star_list],
                current_image_id = WingId, own_special_image = [{WingId, util:unixtime() + Time} | StWing#st_wing.own_special_image]},
            ok;
        {value, {WingId, 0}, _} -> %%已经是永久了
            StWing1 = StWing#st_wing{current_image_id = WingId};
        {value, {WingId, RTime}, OwnClothes} -> %%
            NewRTime = ?IF_ELSE(RTime > util:unixtime(), RTime, util:unixtime()),
            NewTime = ?IF_ELSE(Time == 0, Time, NewRTime + Time),
            StWing1 = StWing#st_wing{current_image_id = WingId, own_special_image = [{WingId, NewTime} | OwnClothes]}
    end,
    NewWingSt = wing_attr:calc_wing_attr(StWing1),
    wing_pack:send_wing_info(NewWingSt, Player),
    lib_dict:put(?PROC_STATUS_WING, NewWingSt#st_wing{is_change = 1}),
    wing_pack:send_wing_info(NewWingSt, Player),
    NewPlayer = player_util:count_player_attribute(Player, true),
    NewPlayer1 = NewPlayer#player{wing_id = WingId},
    player_util:update_notice(NewPlayer1),
    scene_agent_dispatch:wing_update(NewPlayer1),
    notice_sys:add_notice(wing, [Player, WingId]),
    {ok, Bin_wing} = pt_360:write(36007, {WingId}),
    server_send:send_to_sid(Player#player.sid, Bin_wing),
    open_act_all_target:act_target(Player#player.key, ?OPEN_ALL_TARGET_WING, 1),
    fashion_suit:active_icon_push(NewPlayer),
    {ok, NewPlayer1}.

select_image(Player, WingId) ->
    Now = util:unixtime(),
    StWing = lib_dict:get(?PROC_STATUS_WING),
    case lists:keyfind(WingId, 1, StWing#st_wing.own_special_image) of
        {WingId, Time} when Time == 0 orelse Time > Now ->
            NewStWing = StWing#st_wing{current_image_id = WingId, is_change = 1},
            lib_dict:put(?PROC_STATUS_WING, NewStWing),
            wing_pack:send_wing_info(NewStWing, Player),
            {ok, Player#player{wing_id = WingId}};
        _ ->
            {false, 9}
    end.


%%获取翅膀战力
get_wing_power() ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    attribute_util:calc_combat_power(WingSt#st_wing.wing_attribute).

%%翅膀皮肤过期检查
check_des_time(Player, Now) ->
    StWing = lib_dict:get(?PROC_STATUS_WING),
    case lists:keyfind(Player#player.wing_id, 1, StWing#st_wing.own_special_image) of
        {_WingId, 0} ->
            Player;
        {WingId, Time} when Now > Time ->
            {ok, Bin_wing} = pt_360:write(36008, {WingId}),
            server_send:send_to_sid(Player#player.sid, Bin_wing),
            Base = data_wing_stage:get(1),
            NewStWing = StWing#st_wing{current_image_id = Base#base_wing_stage.image, is_change = 1},
            wing_pack:send_wing_info(NewStWing, Player),
            NewStWing1 = wing_attr:calc_wing_attr(NewStWing),
            lib_dict:put(?PROC_STATUS_WING, NewStWing1),
            Player1 = Player#player{wing_id = Base#base_wing_stage.image},
            NewPlayer = player_util:count_player_attribute(Player1, true),
            scene_agent_dispatch:wing_update(NewPlayer),
            NewPlayer;
        _ ->
            Player
    end.

get_stage_attr() ->
    WingStatus = lib_dict:get(?PROC_STATUS_WING),
    case data_wing_stage:get(WingStatus#st_wing.stage) of
        [] -> #attribute{};
        BaseData ->
            attribute_util:make_attribute_by_key_val_list(BaseData#base_wing_stage.attrs)
    end.

get_total_star() ->
    WingStatus = lib_dict:get(?PROC_STATUS_WING),
    lists:sum([Star || {_, Star} <- WingStatus#st_wing.star_list]).


%%装备物品
equip_goods(Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {18, Player};
        Goods ->
            case data_goods:get(Goods#goods.goods_id) of
                [] -> {18, Player};
                GoodsType ->
                    Wing = lib_dict:get(?PROC_STATUS_WING),
                    if GoodsType#goods_type.need_lv > Wing#st_wing.stage -> {29, Player};
                        true ->
                            SubtypeList = [?GOODS_SUBTYPE_EQUIP_WING_1, ?GOODS_SUBTYPE_EQUIP_WING_2, ?GOODS_SUBTYPE_EQUIP_WING_3, ?GOODS_SUBTYPE_EQUIP_WING_4],
                            case lists:member(GoodsType#goods_type.subtype, SubtypeList) of
                                false -> {25, Player};
                                true ->
                                    NeedGoods = Goods#goods{location = ?GOODS_LOCATION_WING, cell = GoodsType#goods_type.subtype, bind = ?BIND},

                                    GoodsDict = goods_dict:update_goods(NeedGoods, GoodsSt#st_goods.dict),
                                    goods_pack:pack_send_goods_info([NeedGoods], GoodsSt#st_goods.sid),

                                    EquipList =
                                        case lists:keytake(GoodsType#goods_type.subtype, 1, Wing#st_wing.equip_list) of
                                            false ->
                                                _OldGoodsId = 0,
                                                NewGoodsSt = GoodsSt#st_goods{leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1, dict = GoodsDict},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | Wing#st_wing.equip_list];
                                            {value, {_, _OldGoodsId, OldGoodsKey}, T} ->
                                                case catch goods_util:get_goods(OldGoodsKey, GoodsSt#st_goods.dict) of
                                                    {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
                                                        GoodsDict1 = GoodsDict;
                                                    GoodsOld ->
                                                        NewGoodsOld = GoodsOld#goods{location = ?GOODS_LOCATION_BAG, cell = 0},
                                                        goods_pack:pack_send_goods_info([NewGoodsOld], GoodsSt#st_goods.sid),
                                                        goods_load:dbup_goods_cell_location(NewGoodsOld),
                                                        GoodsDict1 = goods_dict:update_goods(NewGoodsOld, GoodsDict)
                                                end,
                                                NewGoodsSt = GoodsSt#st_goods{dict = GoodsDict1},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | T]
                                        end,
                                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                                    goods_load:dbup_goods_cell_location(NeedGoods),
                                    Wing1 = Wing#st_wing{equip_list = EquipList, is_change = 1},
                                    NewWing = wing_attr:calc_wing_attr(Wing1),
                                    lib_dict:put(?PROC_STATUS_WING, NewWing),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_wing_equip(Player#player.key, Player#player.nickname, GoodsType#goods_type.subtype, _OldGoodsId, Goods#goods.goods_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

%% 检查是否有装备可以熔炼
get_equip_smelt_state() ->
    GoodsList = goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP10]),
    Wing = lib_dict:get(?PROC_STATUS_WING),
    F = fun(Goods) ->
        if
            Goods#goods.bind /= ?BIND -> false;
            true ->
                GoodsType = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, Wing#st_wing.equip_list) of
                    false -> false;
                    {_Subtype, _GoodsId, GoodsKey} ->
                        if
                            GoodsKey == Goods#goods.key -> false;
                            true ->
                                WearGoods = goods_util:get_goods(GoodsKey),
                                if
                                    Goods#goods.combat_power > WearGoods#goods.combat_power -> false;
                                    true -> true
                                end
                        end
                end
        end
    end,
    case lists:any(F, GoodsList) of
        false -> 0;
        true -> 1
    end.

log_wing_equip(Pkey, Nickname, Subtype, OldGid, NewGid) ->
    Sql = io_lib:format("insert into log_wing_equip set pkey=~p,nickname='~s',subtype=~p,old_gid=~p,new_gid=~p,time=~p",
        [Pkey, Nickname, Subtype, OldGid, NewGid, util:unixtime()]),
    log_proc:log(Sql).


%% 使用仙羽成长丹
use_wing_dan(Player) ->
    case data_grow_dan:get(?GOODS_GROW_ID_WING) of
        [] -> {false, 0}; %% 配表错误
        Base ->
            Wing = lib_dict:get(?PROC_STATUS_WING), %% 玩家仙羽
            case lists:keyfind(Wing#st_wing.stage, 1, Base#base_grow_dan.stage_max_num) of
                false -> {false, 0};
                {_, MaxNum} ->
                    if
                        Wing#st_wing.grow_num >= MaxNum ->
                            {false, 42}; %% 成长丹已达到使用上限
                        true ->
                            if
                                Base#base_grow_dan.step_lim > Wing#st_wing.stage ->
                                    {false, 43};  %% 未达到使用阶级
                                true ->
                                    GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_WING),
                                    if
                                        GrowNum == 0 ->
                                            goods_util:client_popup_goods_not_enough(Player, Base#base_grow_dan.goods_id, 0, 227),
                                            {false, 44}; %% 成长丹不足
                                        true ->
                                            DeleteGrowNum = min(MaxNum - Wing#st_wing.grow_num, GrowNum),
                                            goods:subtract_good(Player, [{?GOODS_GROW_ID_WING, DeleteGrowNum}], 227), %% 扣除成长丹
                                            NewWing = Wing#st_wing{grow_num = Wing#st_wing.grow_num + DeleteGrowNum}, %% 增加成长丹数量
                                            NewWing1 = wing_attr:calc_wing_attr(NewWing), %% 重新计算属性
                                            lib_dict:put(?PROC_STATUS_WING, NewWing1#st_wing{is_change = 1}),
                                            wing_pack:send_wing_info(NewWing, Player),
                                            NewPlayer = player_util:count_player_attribute(Player#player{wing_id = NewWing#st_wing.current_image_id}, true),
                                            scene_agent_dispatch:attribute_update(NewPlayer),
                                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1014, 0, DeleteGrowNum),
                                            {ok, NewPlayer}
                                    end
                            end
                    end
            end
    end.

%% 使用仙羽成长丹
check_use_wing_dan_state(_Player, Tips) ->
    case data_grow_dan:get(?GOODS_GROW_ID_WING) of
        [] -> Tips; %% 配表错误
        Base ->
            Wing = lib_dict:get(?PROC_STATUS_WING), %% 玩家仙羽
            {_, MaxNum} = lists:keyfind(Wing#st_wing.stage, 1, Base#base_grow_dan.stage_max_num),
            if
                Wing#st_wing.grow_num >= MaxNum ->
                    Tips; %% 成长丹已达到使用上限
                true ->
                    if
                        Base#base_grow_dan.step_lim > Wing#st_wing.stage ->
                            Tips;  %% 未达到使用阶级
                        true ->
                            GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_WING),
                            if
                                GrowNum == 0 ->
                                    Tips; %% 成长丹不足
                                true ->
                                    Tips#tips{state = 1}
                            end
                    end
            end
    end.

activation_stage_lv(Player, WingId) ->
    Wing = lib_dict:get(?PROC_STATUS_WING),
    case lists:keyfind(WingId, 1, Wing#st_wing.star_list) of
        false ->
            {45, Player};
        {WingId, Stage} ->
            StageList = get_stage_list(WingId, Stage),
            case lists:keytake(WingId, 1, Wing#st_wing.activation_list) of
                {value, {WingId, ActList}, T} ->
                    NewActivationList = StageList -- ActList,
                    if
                        NewActivationList == [] -> {50, Player};
                        true ->
                            Wing1 = Wing#st_wing{activation_list = [{WingId, NewActivationList ++ ActList} | T], is_change = 1},
                            NewWing1 = wing_attr:calc_wing_attr(Wing1),
                            lib_dict:put(?PROC_STATUS_WING, NewWing1),
                            wing_pack:send_wing_info(NewWing1, Player),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            {1, NewPlayer}
                    end;
                false ->
                    if
                        StageList == [] -> {50, Player};
                        true ->
                            Wing1 = Wing#st_wing{activation_list = [{WingId, StageList} | Wing#st_wing.activation_list], is_change = 1},
                            NewWing1 = wing_attr:calc_wing_attr(Wing1),
                            lib_dict:put(?PROC_STATUS_WING, NewWing1),
                            wing_pack:send_wing_info(NewWing1, Player),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            {1, NewPlayer}
                    end
            end
    end.

get_stage_list(Id, Stage) ->
    F = fun(Stage0, List) ->
        case data_wing_star:get(Id, Stage0) of
            [] -> List;
            #base_wing_star{lv_attr = LvAttr} ->
                if
                    LvAttr == [] -> List;
                    true -> [Stage0 | List]
                end
        end
    end,
    lists:foldl(F, [], lists:seq(1, Stage)).
