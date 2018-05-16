%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 五月 2017 10:18
%%%-------------------------------------------------------------------
-module(dungeon_fuwen_tower).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("fuwen.hrl").
-include("dungeon.hrl").
-include("tips.hrl").
-include("goods.hrl").
-include("achieve.hrl").

%% API
-export([
    init/1,
    check_enter/2,
    dun_ret/3,
    daily_reward/1,
    logout/0,
    midnight_refresh/1,

    get_dun_info/1,
    check_uplv_dungeon_state/2,
    get_notice_player/1,
    gm/2,
    gm_unlock/0
]).

gm_unlock() ->
    St = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    L1 = lists:seq(?GOODS_SUBTYPE_FUWEN_1, ?GOODS_SUBTYPE_FUWEN_16),
    L2 = lists:seq(?GOODS_SUBTYPE_DOUBLE_FUWEN_1, ?GOODS_SUBTYPE_DOUBLE_FUWEN_8),
    NewSt = St#st_dun_fuwen_tower{unlock_fuwen_subtype = L1++L2},
    lib_dict:put(?PROC_STATUS_DUN_FUWEN_TOWER, NewSt).

gm(Layer, SubLayer) ->
    St = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),

    F = fun(N) ->
        #base_dun_fuwen_tower{unlock_fuwen_subtype = SubType} = data_dungeon_fuwen_tower:get_by_layer_sublayer(N, 1),
        SubType
        end,
    UnlockFuwenSubtype = lists:map(F, lists:seq(1, Layer)),
    #base_dun_fuwen_tower{dun_id = DunId} = data_dungeon_fuwen_tower:get_by_layer_sublayer(Layer, SubLayer),
    NewSt =
        St#st_dun_fuwen_tower{
            op_time = util:unixtime(),
            layer_highest = Layer,
            sub_layer = SubLayer,
            unlock_fuwen_subtype = UnlockFuwenSubtype,
            dun_list = [DunId]
        },
    ?DEBUG("NewSt:~p~n", [NewSt]),
    lib_dict:put(?PROC_STATUS_DUN_FUWEN_TOWER, NewSt).

midnight_refresh(Player) ->
    daily_reward(Player),
    St = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    NewSt = St#st_dun_fuwen_tower{op_time = util:unixtime()},
    lib_dict:put(?PROC_STATUS_DUN_FUWEN_TOWER, NewSt),
    ok.

logout() ->
    St = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    dungeon_load:replace_dun_fuwen_tower(St).

%%初始化
init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_DUN_FUWEN_TOWER, #st_dun_fuwen_tower{pkey = Player#player.key, op_time = util:unixtime()});
        false ->
            case dungeon_load:load_dun_fuwen_tower(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_DUN_FUWEN_TOWER, #st_dun_fuwen_tower{pkey = Player#player.key, op_time = util:unixtime()});
                [DunListBin, LayerHighest, SubLayer, UnlockPos, UnlockFuwenSubtypeBin, Optime] ->
                    DunList1 = util:bitstring_to_term(DunListBin),
                    UnlockFuwenSubtype = util:bitstring_to_term(UnlockFuwenSubtypeBin),
                    Now = util:unixtime(),
                    case util:is_same_date(Optime, Now) of
                        true ->
                            lib_dict:put(?PROC_STATUS_DUN_FUWEN_TOWER,
                                #st_dun_fuwen_tower{
                                    pkey = Player#player.key,
                                    dun_list = DunList1,
                                    sub_layer = SubLayer,
                                    layer_highest = LayerHighest,
                                    unlock_pos = UnlockPos,
                                    unlock_fuwen_subtype = UnlockFuwenSubtype,
                                    op_time = Optime
                                });
                        false ->
                            lib_dict:put(?PROC_STATUS_DUN_FUWEN_TOWER,
                                #st_dun_fuwen_tower{
                                    pkey = Player#player.key,
                                    dun_list = DunList1,
                                    sub_layer = SubLayer,
                                    layer_highest = LayerHighest,
                                    unlock_pos = UnlockPos,
                                    unlock_fuwen_subtype = UnlockFuwenSubtype,
                                    op_time = Now
                                }),
                            daily_reward(Player)
                    end
            end
    end.

check_enter(Player, DunId) ->
    case dungeon_util:is_dungeon_fuwen_tower(DunId) of
        false -> true;
        true ->
            St = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
            case data_dungeon_fuwen_tower:get_by_dunid(DunId) of
                [] -> {false, ?T("关卡配置不存在")};
                Base ->
                    if
                        Base#base_dun_fuwen_tower.limit_lv > Player#player.lv -> {false, ?T("关卡等级限制")};
                        Base#base_dun_fuwen_tower.layer < St#st_dun_fuwen_tower.layer_highest -> {false, ?T("当前关卡已通关")};
                        Base#base_dun_fuwen_tower.layer == St#st_dun_fuwen_tower.layer_highest andalso Base#base_dun_fuwen_tower.sub_layer =< St#st_dun_fuwen_tower.sub_layer ->
                            {false, ?T("当前关卡已通关")};
                        Base#base_dun_fuwen_tower.pre_dun_id == 0 -> true;
                        true ->
                            case lists:member(Base#base_dun_fuwen_tower.pre_dun_id, St#st_dun_fuwen_tower.dun_list) of
                                false -> {false, ?T("前置关卡未通关")};
                                true -> true
                            end
                    end
            end
    end.

get_dun_info(_Player) ->
    StDunFuwenTower = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    DunList = StDunFuwenTower#st_dun_fuwen_tower.dun_list,
    #base_dun_fuwen_tower{layer = Layer0, sub_layer = SubLayer0} = data_dungeon_fuwen_tower:get(1),
    if
        DunList == [] -> {Layer0, SubLayer0};
        true ->
            MaxDunId = lists:max(DunList),
            case data_dungeon_fuwen_tower:get_by_dunid(MaxDunId + 1) of
                #base_dun_fuwen_tower{layer = Layer1, sub_layer = SubLayer1} ->
                    {Layer1, SubLayer1};
                _ ->
                    {StDunFuwenTower#st_dun_fuwen_tower.layer_highest, StDunFuwenTower#st_dun_fuwen_tower.sub_layer}
            end
    end.

dun_ret(DunId, 0, Player) ->
    #base_dun_fuwen_tower{layer = BaseLayer, sub_layer = BaseSubLayer} = data_dungeon_fuwen_tower:get_by_dunid(DunId),
    {ok, Bin} = pt_125:write(12502, {0, 0, DunId, BaseLayer, BaseSubLayer, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player;

dun_ret(DunId, 1, Player) ->
    StDunFuwenTower = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    #base_dun_fuwen_tower{id = Id, name = DunName, layer = BaseLayer, sub_layer = BaseSubLayer, first_reward = FirstReward, unlock_pos = UnLockPos, unlock_fuwen_subtype = FuwenSubtype} = data_dungeon_fuwen_tower:get_by_dunid(DunId),
    #st_dun_fuwen_tower{dun_list = DunList, layer_highest = LayerHighest, sub_layer = SubLayer, unlock_pos = Pos, unlock_fuwen_subtype = UnlockFuwenSubtype} = StDunFuwenTower,
    {NewLayerHighest, NewSubLayer} =
        if
            BaseLayer > LayerHighest ->
                {BaseLayer, BaseSubLayer};
            BaseLayer == LayerHighest ->
                {BaseLayer, max(BaseSubLayer, SubLayer)};
            true ->
                {LayerHighest, SubLayer}
        end,
    NewDunList =
        case lists:member(DunId, DunList) of
            true ->
                DunList;
            false ->
                [DunId | DunList]
        end,
    NewStDunFuwenTower =
        StDunFuwenTower#st_dun_fuwen_tower{
            layer_highest = NewLayerHighest,
            sub_layer = NewSubLayer,
            dun_list = NewDunList,
            unlock_pos = max(UnLockPos, Pos),
            unlock_fuwen_subtype = util:list_filter_repeat([FuwenSubtype | UnlockFuwenSubtype])
        },
    fuwen:update_pos(UnLockPos),
    lib_dict:put(?PROC_STATUS_DUN_FUWEN_TOWER, NewStDunFuwenTower),
    dungeon_load:replace_dun_fuwen_tower(NewStDunFuwenTower),
    {Status, NewPlayer, GetList} =
        if
            BaseLayer > LayerHighest ->
                {GiftId, 1} = lists:nth(2, FirstReward),
                {NPlayer0, GiveGoodsList0} = goods_use:open_gift_bag(Player, GiftId, true, 633),
                NewT = FirstReward -- [{GiftId, 1}],
                GiveGoodsList = goods:make_give_goods_list(633, GiveGoodsList0 ++ NewT),
                {ok, NPlayer} = goods:give_goods(NPlayer0, GiveGoodsList),
                {1, NPlayer, GiveGoodsList};
            BaseLayer == LayerHighest andalso BaseSubLayer > SubLayer ->
                {GiftId, 1} = lists:nth(2, FirstReward),
                {NPlayer0, GiveGoodsList0} = goods_use:open_gift_bag(Player, GiftId, true, 633),
                NewT = FirstReward -- [{GiftId, 1}],
                GiveGoodsList = goods:make_give_goods_list(633, GiveGoodsList0 ++ NewT),
                {ok, NPlayer} = goods:give_goods(NPlayer0, GiveGoodsList),
                {1, NPlayer, GiveGoodsList};
            true ->
                {0, Player, []}
        end,
    NewGetList = lists:map(fun(#give_goods{goods_id = GoodsId, num = GoodsNum}) -> [GoodsId, GoodsNum] end, GetList),
    {ok, Bin} = pt_125:write(12502, {1, Status, DunId, BaseLayer, BaseSubLayer, NewGetList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [102, 118], true),
    dungeon_util:add_dungeon_times(DunId),
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2015, 0, Id),
    LogDungeon =
        #log_dungeon{
            pkey = Player#player.key,
            nickname = Player#player.nickname,
            cbp = Player#player.cbp,
            dungeon_id = DunId,
            dungeon_type = ?DUNGEON_TYPE_FUWEN_TOWER,
            dungeon_desc = ?T("符文塔"),
            layer = BaseLayer,
            layer_desc = ?T(DunName ++ io_lib:format("第~p层", [BaseSubLayer])),
            sub_layer = BaseSubLayer,
            time = util:unixtime()
        },
    dungeon_log:log(LogDungeon),
    NewPlayer.

daily_reward(Player) ->
    StDunFuwenTower = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    #st_dun_fuwen_tower{layer_highest = LayerHighest, sub_layer = SubLayer} = StDunFuwenTower,
    Rand = util:rand(30000, 300000),
    spawn(fun() -> timer:sleep(Rand), daily_reward_mail(Player#player.key, LayerHighest, SubLayer) end),
    ok.

daily_reward_mail(_Pkey, 0, _) ->
    ok;

daily_reward_mail(Pkey, LayerHighest, SubLayer) ->
    #base_dun_fuwen_tower{name = Name, daily_reward = DailyReward} = data_dungeon_fuwen_tower:get_by_layer_sublayer(LayerHighest, SubLayer),
    {Title, Content0} = t_mail:mail_content(78),
    Content = io_lib:format(Content0, [?T(Name), SubLayer]),
    mail:sys_send_mail([Pkey], Title, Content, [{DailyReward, 3}]),
    ok.

%% 等级提升检察是否存在可挑战
check_uplv_dungeon_state(Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    #st_dun_fuwen_tower{
        layer_highest = Layer0,
        sub_layer = SubLayer0
    } = St,
    case data_dungeon_fuwen_tower:get_by_layer_sublayer(Layer0, SubLayer0 + 1) of
        [] ->
            case data_dungeon_fuwen_tower:get_by_layer_sublayer(Layer0 + 1, 1) of
                [] ->
                    Tips;
                #base_dun_fuwen_tower{limit_lv = LimitLv, dun_id = DunId, layer = Layer, sub_layer = SubLayer, cbp_min = CbpMin} ->
                    ?IF_ELSE(Player#player.lv >= LimitLv andalso Player#player.cbp >= CbpMin, Tips#tips{state = 1, args1 = DunId, args2 = Layer, args3 = SubLayer, upcombat_dungeon_list = [?TIPS_DUNGEON_TYPE_FUWEN_TOWER | Tips#tips.upcombat_dungeon_list]}, Tips)
            end;
        #base_dun_fuwen_tower{limit_lv = LimitLv, dun_id = DunId, layer = Layer, sub_layer = SubLayer, cbp_min = CbpMin} ->
            ?IF_ELSE(Player#player.lv >= LimitLv andalso Player#player.cbp >= CbpMin, Tips#tips{state = 1, args1 = DunId, args2 = Layer, args3 = SubLayer, upcombat_dungeon_list = [?TIPS_DUNGEON_TYPE_FUWEN_TOWER | Tips#tips.upcombat_dungeon_list]}, Tips)
    end.

get_notice_player(Player) ->
    Tips = check_uplv_dungeon_state(Player, #tips{}),
    ?IF_ELSE(Tips#tips.state == 1, 1, 0).