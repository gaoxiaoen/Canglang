%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 十二月 2016 10:30
%%%-------------------------------------------------------------------
-module(dungeon_tower).
-author("hxming").

-include("server.hrl").
-include("dungeon.hrl").
-include("common.hrl").
-include("tips.hrl").
-include("achieve.hrl").
-include("task.hrl").

-define(PAGE_NUM, 8).
-define(DUN_STATE_LOCK, 0).
-define(DUN_STATE_UNLOCK, 1).
-define(DUN_STATE_FINISH, 2).
%% API
-compile(export_all).

%%初始化
init(Player, Now) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_TOWER_DUNGEON, #st_dun_tower{pkey = Player#player.key, time = Now});
        false ->
            case dungeon_load:select_dun_tower(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_TOWER_DUNGEON, #st_dun_tower{pkey = Player#player.key, time = Now});
                [DunList, Layer, UseTime, Click, Time] ->
                    DunList1 = list2record(util:bitstring_to_term(DunList)),
                    case util:is_same_date(Time, Now) of
                        true ->
                            lib_dict:put(?PROC_STATUS_TOWER_DUNGEON, #st_dun_tower{pkey = Player#player.key, dun_list = DunList1, layer = Layer, use_time = UseTime, click = Click, time = Time});
                        false ->
                            lib_dict:put(?PROC_STATUS_TOWER_DUNGEON, #st_dun_tower{pkey = Player#player.key, dun_list = DunList1, layer = Layer, use_time = UseTime, time = Now})
                    end
            end
    end.

list2record(L) ->
    F = fun({DunId, Star, UseTime, Time}) ->
        #dun_tower{dun_id = DunId, star = Star, use_time = UseTime, time = Time}
        end,
    lists:map(F, L).
record2list(L) ->
    F = fun(Dun) ->
        {Dun#dun_tower.dun_id, Dun#dun_tower.star, Dun#dun_tower.use_time, Dun#dun_tower.time}
        end,
    lists:map(F, L).

%%定时更新
timer_update() ->
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    if St#st_dun_tower.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_TOWER_DUNGEON, St#st_dun_tower{is_change = 0}),
        dungeon_load:replace_dun_tower(St);
        true -> ok
    end.

%%离线
logout() ->
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    if St#st_dun_tower.is_change == 1 ->
        dungeon_load:replace_dun_tower(St);
        true -> ok
    end.

%%零点刷新
midnight_refresh(Now) ->
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    lib_dict:put(?PROC_STATUS_TOWER_DUNGEON, St#st_dun_tower{click = 0, time = Now, is_change = 1}).


%%副本信息
dungeon_info(Page) ->
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    if St#st_dun_tower.click == 0 ->
        lib_dict:put(?PROC_STATUS_TOWER_DUNGEON, St#st_dun_tower{click = St#st_dun_tower.click + 1, is_change = 1});
        true -> ok
    end,
    Now = util:unixtime(),
    MaxLayer = data_dungeon_tower:max_layer(),
    MaxPage = max_layer(MaxLayer),
    NowPage = get_page(Page, St#st_dun_tower.layer, St#st_dun_tower.click, MaxPage, St#st_dun_tower.dun_list),
    LayerList = get_layer_list(NowPage),
    F = fun(Layer) ->
        case data_dungeon_tower:layer_to_scene(Layer) of
            [] -> [];
            DunId ->
                Base = data_dungeon_tower:get(DunId),
                Info =
                    case lists:keyfind(DunId, #dun_tower.dun_id, St#st_dun_tower.dun_list) of
                        false ->
                            if Layer == 1 ->
                                [Layer, DunId, ?DUN_STATE_UNLOCK, 0, ?DUN_STATE_LOCK];
                                true ->
                                    case lists:keymember(Base#base_dun_tower.pre_id, #dun_tower.dun_id, St#st_dun_tower.dun_list) of
                                        false ->
                                            [Layer, DunId, ?DUN_STATE_LOCK, 0, ?DUN_STATE_LOCK];
                                        true ->
                                            [Layer, DunId, ?DUN_STATE_UNLOCK, 0, ?DUN_STATE_LOCK]
                                    end
                            end;
                        DunTower ->
                            SweepState =
                                if DunTower#dun_tower.star >= Base#base_dun_tower.star ->
                                    case util:is_same_date(Now, DunTower#dun_tower.time) of
                                        true -> ?DUN_STATE_LOCK;
                                        false -> ?DUN_STATE_UNLOCK
                                    end;
                                    true ->
                                        ?DUN_STATE_LOCK
                                end,
                            PassState =
                                if DunTower#dun_tower.star >= Base#base_dun_tower.star -> ?DUN_STATE_FINISH;
                                    true ->
                                        ?DUN_STATE_UNLOCK
                                end,
                            [Layer, DunId, PassState, DunTower#dun_tower.star, SweepState]
                    end,
                [Info]
        end
        end,
    DunList = lists:flatmap(F, LayerList),
    LayerLim = get_can_sweep_max_layer(St#st_dun_tower.dun_list, Now),
    {NowPage, MaxPage, LayerLim, DunList}.


get_page(Page, Layer, Click, MaxPage, DunList) ->
    if Page == 0 ->
        if Click > 0 ->
            layer_to_page(Layer);
            true ->
                1
        end;
        Page == -1 ->
            F = fun(DunTower) ->
                Base = data_dungeon_tower:get(DunTower#dun_tower.dun_id),
                if DunTower#dun_tower.star >= Base#base_dun_tower.star -> false;
                    true -> true
                end
                end,
            case lists:filter(F, DunList) of
                [] -> layer_to_page(Layer);
                DunList1 ->
                    [Find | _] = lists:keysort(#dun_tower.dun_id, DunList1),
                    Base1 = data_dungeon_tower:get(Find#dun_tower.dun_id),
                    layer_to_page(Base1#base_dun_tower.layer)
            end;
        true ->
            ?IF_ELSE(Page =< 0 orelse Page >= MaxPage, 1, Page)
    end.

%%层数列表
get_layer_list(Page) ->
    lists:seq((Page - 1) * ?PAGE_NUM + 1, Page * ?PAGE_NUM).

layer_to_page(Layer) ->
    if Layer == 0 -> 1;
        true ->
            Layer div ?PAGE_NUM + 1
    end.

max_layer(Layer) ->
    if Layer == 0 -> 1;
        true ->
            case Layer rem ?PAGE_NUM of
                0 ->
                    Layer div ?PAGE_NUM;
                _ ->
                    Layer div ?PAGE_NUM + 1
            end
    end.

%%排行榜
check_rank() ->
    case cache:get(?PROC_STATUS_TOWER_DUNGEON_RANK) of
        [] ->
            %%d.pkey,p.nickname,d.layer,d.use_time
            Data = dungeon_load:load_dun_tower_rank(),
            cache:set(?PROC_STATUS_TOWER_DUNGEON_RANK, Data, ?ONE_HOUR_SECONDS),
            Data;
        Cache ->
            Cache
    end.


cmd_sweep_reset() ->
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    Date = util:unixdate() - ?ONE_DAY_SECONDS,
    F = fun(Dun) ->
        Dun#dun_tower{time = Date}
        end,
    DunList = lists:map(F, St#st_dun_tower.dun_list),
    NewSt = St#st_dun_tower{dun_list = DunList, is_change = 1},
    lib_dict:put(?PROC_STATUS_TOWER_DUNGEON, NewSt),
    ok.

check_saodang_state(_Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    Now = util:unixtime(),
    F = fun(DunTower, {DList, GList}) ->
        Base = data_dungeon_tower:get(DunTower#dun_tower.dun_id),
        if DunTower#dun_tower.star >= Base#base_dun_tower.star ->
            case util:is_same_date(DunTower#dun_tower.time, Now) of
                true ->
                    {[DunTower | DList], GList};
                false ->
                    {[DunTower#dun_tower{time = Now} | DList], GList ++ tuple_to_list(Base#base_dun_tower.sweep_goods)}
            end;
            true ->
                {[DunTower | DList], GList}
        end
        end,
    {_DunList, GoodsList} = lists:foldl(F, {[], []}, St#st_dun_tower.dun_list),
    case GoodsList of
        [] -> Tips;
        _ -> Tips#tips{state = 1, saodang_dungeon_list = [?TIPS_DUNGEON_TYPE_TOWER | Tips#tips.saodang_dungeon_list]}
    end.


%%获取今日可扫荡的最高层
get_can_sweep_max_layer(DunList, Now) ->
    F = fun(DunTower) ->
        Base = data_dungeon_tower:get(DunTower#dun_tower.dun_id),
        if DunTower#dun_tower.star >= Base#base_dun_tower.star ->
            case util:is_same_date(DunTower#dun_tower.time, Now) of
                true ->
                    [];
                false ->
                    [Base#base_dun_tower.layer]
            end;
            true ->
                []
        end
        end,
    case lists:flatmap(F, DunList) of
        [] -> 0;
        Ids -> lists:max(Ids)
    end.

%%扫荡
sweep(Player) ->
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    Now = util:unixtime(),
    F = fun(DunTower, {DList, GList, LayerIds}) ->
        Base = data_dungeon_tower:get(DunTower#dun_tower.dun_id),
        if DunTower#dun_tower.star >= Base#base_dun_tower.star ->
            case util:is_same_date(DunTower#dun_tower.time, Now) of
                true ->
                    {[DunTower | DList], GList, LayerIds};
                false ->
                    dungeon_util:add_dungeon_times(DunTower#dun_tower.dun_id),
                    task_event:event(?TASK_ACT_DUNGEON, {DunTower#dun_tower.dun_id, 1}),
                    findback_src:fb_trigger_src(Player, 12, [DunTower#dun_tower.dun_id]),
                    {[DunTower#dun_tower{time = Now} | DList], GList ++ tuple_to_list(Base#base_dun_tower.sweep_goods), [Base#base_dun_tower.layer | LayerIds]}
            end;
            true ->
                {[DunTower | DList], GList, LayerIds}
        end
        end,
    {DunList, GoodsList, LayerList} = lists:foldl(F, {[], [], []}, St#st_dun_tower.dun_list),
    case GoodsList of
        [] -> {26, 0, [], Player};
        _ ->
            NewSt = St#st_dun_tower{dun_list = DunList, is_change = 1},
            lib_dict:put(?PROC_STATUS_TOWER_DUNGEON, NewSt),
            GoodsList1 = goods:merge_goods(GoodsList),
            GoodsGoodsList = goods:make_give_goods_list(203, GoodsList1),
            {ok, NewPlayer} = goods:give_goods(Player, GoodsGoodsList),
            activity:get_notice(Player, [102], true),
            {1, lists:max(LayerList), goods:pack_goods(GoodsList1), NewPlayer}
    end.
%% 判断是否可以扫荡即可
get_notice_player(_Player) ->
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    Now = util:unixtime(),
    F = fun(DunTower, {DList, GList, LayerIds}) ->
        Base = data_dungeon_tower:get(DunTower#dun_tower.dun_id),
        if
            DunTower#dun_tower.star >= Base#base_dun_tower.star ->
                case util:is_same_date(DunTower#dun_tower.time, Now) of
                    true ->
                        {[DunTower | DList], GList, LayerIds};
                    false ->
                        {[DunTower#dun_tower{time = Now} | DList], GList ++ tuple_to_list(Base#base_dun_tower.sweep_goods), [Base#base_dun_tower.layer | LayerIds]}
                end;
            true ->
                {[DunTower | DList], GList, LayerIds}
        end
        end,
    {_DunList, GoodsList, _LayerList} = lists:foldl(F, {[], [], []}, St#st_dun_tower.dun_list),
    case GoodsList of
        [] -> 0;
        _ -> 1
    end.

%%进入检查
check_enter(_Player, DunId) ->
    case dungeon_util:is_dungeon_tower(DunId) of
        false -> true;
        true ->
            St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
            case data_dungeon_tower:get(DunId) of
                [] -> {false, ?T("关卡配置不存在")};
                Base ->
                    if Base#base_dun_tower.pre_id == 0 -> true;
                        true ->
                            case lists:keyfind(Base#base_dun_tower.pre_id, #dun_tower.dun_id, St#st_dun_tower.dun_list) of
                                false -> {false, ?T("前置关卡未通关")};
                                _DunTower ->
                                    case lists:keyfind(DunId, #dun_tower.dun_id, St#st_dun_tower.dun_list) of
                                        false -> true;
                                        DunTower ->
                                            if DunTower#dun_tower.star >= Base#base_dun_tower.star ->
                                                {false, ?T("副本已满星通关")};
                                                true ->
                                                    true
                                            end
                                    end
                            end
                    end
            end
    end.

%%副本结算
dun_tower_ret(1, Player, DunId, UseTime) ->
    Base = data_dungeon_tower:get(DunId),
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    Star = calc_star(Base#base_dun_tower.condition, UseTime),
    update_dungeon_list(St, Base#base_dun_tower.layer, DunId, Star, UseTime),
    GoodsList = star_goods_list(St, Star, Base),

    RewardList = goods:make_give_goods_list(204, goods:merge_goods(GoodsList)),
    {ok, NewPlayer} = goods:give_goods(Player, RewardList),
    {ok, Bin} = pt_121:write(12124, {1, DunId, Star, goods:pack_goods(RewardList)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    %%资源找回
    if
        Star >= Base#base_dun_tower.star ->
            findback_src:fb_trigger_src(Player, 12, [DunId]);
        true -> skip
    end,
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2009, 0, Base#base_dun_tower.layer),
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2010, 0, Star),
    activity:get_notice(Player, [102], true),
    dungeon_util:add_dungeon_times(DunId),
    NewPlayer;
dun_tower_ret(_, Player, DunId, _UseTime) ->
    {ok, Bin} = pt_121:write(12124, {0, DunId, 0, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player.


%%更新通过信息
update_dungeon_list(St, Layer, DunId, Star, UseTime) ->
    NewSt =
        case lists:keytake(DunId, #dun_tower.dun_id, St#st_dun_tower.dun_list) of
            false ->
                DunList = [#dun_tower{dun_id = DunId, star = Star, use_time = UseTime, time = util:unixtime()} | St#st_dun_tower.dun_list],
                St#st_dun_tower{dun_list = DunList, layer = Layer, use_time = UseTime, is_change = 1};
            {value, DunTower, T} ->
                if Star > DunTower#dun_tower.star ->
                    DunList = [DunTower#dun_tower{star = Star, use_time = UseTime, time = util:unixtime()} | T],
                    St#st_dun_tower{dun_list = DunList, is_change = 1};
                    Star == DunTower#dun_tower.star andalso UseTime < DunTower#dun_tower.use_time ->
                        DunList = [DunTower#dun_tower{use_time = UseTime} | T],
                        St#st_dun_tower{dun_list = DunList, is_change = 1};
                    true ->
                        St
                end
        end,
    lib_dict:put(?PROC_STATUS_TOWER_DUNGEON, NewSt),
    NewSt.

star_goods_list(St, Star, Base) ->
    case lists:keyfind(Base#base_dun_tower.dun_id, #dun_tower.dun_id, St#st_dun_tower.dun_list) of
        false ->
            if Star == 1 ->
                tuple_to_list(Base#base_dun_tower.star1_goods);
                Star == 2 ->
                    tuple_to_list(Base#base_dun_tower.star1_goods) ++ tuple_to_list(Base#base_dun_tower.star2_goods);
                true ->
                    tuple_to_list(Base#base_dun_tower.star1_goods) ++ tuple_to_list(Base#base_dun_tower.star2_goods) ++ tuple_to_list(Base#base_dun_tower.star3_goods)
            end;
        DunTower ->
            if Star =< DunTower#dun_tower.star -> [];
                true ->
                    F = fun({Star1, GoodsList}) ->
                        if Star1 > DunTower#dun_tower.star andalso Star1 =< Star -> GoodsList;
                            true -> []
                        end
                        end,
                    lists:flatmap(F, [{1, tuple_to_list(Base#base_dun_tower.star1_goods)}, {2, tuple_to_list(Base#base_dun_tower.star2_goods)}, {3, tuple_to_list(Base#base_dun_tower.star3_goods)}])
            end
    end.

%%计算星级
calc_star(Condition, UseTime) ->
    F = fun({_Star, Time}) ->
        if UseTime > Time -> false;
            true -> true
        end
        end,
    case lists:filter(F, tuple_to_list(Condition)) of
        [] -> 1;
        Condition1 ->
            lists:max([Star || {Star, _} <- Condition1])
    end.


%%获取扫荡波数
get_sweep_round(_Player) ->
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    Now = util:unixtime(),
    F = fun(DunTower) ->
        Base = data_dungeon_tower:get(DunTower#dun_tower.dun_id),
        if
            DunTower#dun_tower.star >= Base#base_dun_tower.star ->
                case util:is_same_date(DunTower#dun_tower.time, Now) of
                    true -> [];
                    false -> [DunTower#dun_tower.dun_id]
                end;
            true -> []
        end
        end,
    lists:flatmap(F, St#st_dun_tower.dun_list).

%%获取副本奖励
get_dun_pass_goods(DunId) ->
    case data_dungeon_tower:get(DunId) of
        [] -> [];
        Base ->
            #base_dun_tower{
                sweep_goods = GoodsList
            } = Base,
            tuple_to_list(GoodsList)
    end.

check_upcombat_dungeon_state(Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_TOWER_DUNGEON),
    #st_dun_tower{
        layer = Layer0
    } = St,
    Layer = Layer0 + 1,
    Scene = data_dungeon_tower:layer_to_scene(Layer),
    case data_dungeon_tower:get_combat_by_round(Layer) of
        {CombatMin, _CombatAdd} when Player#player.cbp >= CombatMin ->
            Tips#tips{state = 1, args1 = Layer, args2 = Scene, upcombat_dungeon_list = [?TIPS_DUNGEON_TYPE_TOWER | Tips#tips.upcombat_dungeon_list]};
        _ ->
            Tips
    end.


%%     case get(?TIPS_DUNGEON_TOWER_CACHE) of
%%         undefined ->
%%             case data_dungeon_tower:get_combat_by_round(Layer) of
%%                 {CombatMin, CombatAdd} when Player#player.cbp >= CombatMin ->
%%                     put(?TIPS_DUNGEON_TOWER_CACHE, {Layer, Player#player.cbp + CombatAdd, CombatAdd}),
%%                     Tips#tips{state = 1, args1 = Layer, args2 = Scene, upcombat_dungeon_list = [?DUNOGEON_TYPE_TOWER | Tips#tips.upcombat_dungeon_list]}; %% 第一次推送
%%                 {CombatMin, CombatAdd} ->
%%                     put(?TIPS_DUNGEON_TOWER_CACHE, {Layer, CombatMin, CombatAdd}),
%%                     Tips
%%             end;
%%         {OldLayer, CombatLimit, CombatAdd} ->
%% %%             ?DEBUG("OldLayer:~p, CombatLimit:~p, CombatAdd:~p~n", [OldLayer, CombatLimit, CombatAdd]),
%%             if
%%             %% 暂时先屏蔽
%%                 Layer == OldLayer andalso CombatLimit =< Player#player.cbp ->
%% %%                     io:format("@@@@~n", []),
%%                     {_CombatMin, BaseCombatAdd} = data_dungeon_tower:get_combat_by_round(Layer),
%%                     put(?TIPS_DUNGEON_TOWER_CACHE, {Layer, Player#player.cbp + CombatAdd, BaseCombatAdd}),
%%                     Tips#tips{state = 1, args1 = Layer, args2 = Scene, upcombat_dungeon_list = [?DUNOGEON_TYPE_TOWER | Tips#tips.upcombat_dungeon_list]};
%%                 Layer > OldLayer ->
%% %%                     io:format("####~n", []),
%%                     {_CombatMin, BaseCombatAdd} = data_dungeon_tower:get_combat_by_round(Layer),
%%                     put(?TIPS_DUNGEON_TOWER_CACHE, {Layer, Player#player.cbp + BaseCombatAdd, BaseCombatAdd}),
%%                     Tips#tips{state = 1, args1 = Layer, args2 = Scene, upcombat_dungeon_list = [?DUNOGEON_TYPE_TOWER | Tips#tips.upcombat_dungeon_list]};
%%                 true ->
%%                     Tips
%%             end
%%     end.