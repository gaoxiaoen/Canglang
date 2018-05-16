%% @author and_me
%% @doc @todo Add description to mount.


-module(pray).
-include("common.hrl").
-include("pray.hrl").
-include("goods.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([extract/1,
    buy_fashion/1,
    quick_pray/1,
    open_cell/2]).


%% ====================================================================
%% Internal functions
%% ====================================================================

extract(Player) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    ?ASSERT(GoodsSt#st_goods.leftover_cell_num > 0, {false, 2}),
    StPRAY = lib_dict:get(?PROC_STATUS_PRAY),
    FinshNum = lists:foldl(fun(PrayGoods, Out) ->
        if PrayGoods#pray_goods.state == ?PRAY_STATE_FINSH -> Out + 1;
            true -> Out
        end
                           end, 0, StPRAY#st_pray.bag_list),
    GiveNum = ?IF_ELSE(FinshNum > GoodsSt#st_goods.leftover_cell_num, GoodsSt#st_goods.leftover_cell_num, FinshNum),
    ?ASSERT(GiveNum > 0, {false, 3}),
    GiveList = lists:sublist(StPRAY#st_pray.bag_list, GiveNum),
    PrayFinshList = [{PrayGoods#pray_goods.goods_id, PrayGoods#pray_goods.num, ?GOODS_LOCATION_BAG, ?BIND, 49, {PrayGoods#pray_goods.wash_attr, PrayGoods#pray_goods.gemstone_groove}} || PrayGoods <- GiveList],
    goods:give_goods_throw(Player, PrayFinshList),
    [pray_load:dbdel_pray_equip(PrayGoods) || PrayGoods <- GiveList],

    LeftGoodsList = StPRAY#st_pray.bag_list -- GiveList,
    if
        StPRAY#st_pray.equip_remain_time == 0 ->
            {AddGoodsList, EquipRemainTime, NewTimerRef} = pray_init:init_pray_bag(Player, 0, StPRAY#st_pray.fashion_id, StPRAY#st_pray.fashion_time, 25),
            NewBagList = LeftGoodsList ++ AddGoodsList;
        true ->
            NewTimerRef = StPRAY#st_pray.timerRef,
            EquipRemainTime = StPRAY#st_pray.equip_remain_time,
            NewBagList = LeftGoodsList
    end,
    NewStPRAY = StPRAY#st_pray{
        timerRef = NewTimerRef,
        equip_remain_time = EquipRemainTime,
        left_cell_num = StPRAY#st_pray.cell_num - length(NewBagList),
        bag_list = NewBagList},
    lib_dict:put(?PROC_STATUS_PRAY, NewStPRAY),
    pray_load:dbup_pray_equip_remain_time(NewStPRAY),
    pray_pack:send_pray_info(NewStPRAY, Player),
    ok.

buy_fashion(Player) ->
    StPRAY = lib_dict:get(?PROC_STATUS_PRAY),
    NewStPRAY = StPRAY#st_pray{fashion_id = 10001,
        fashion_time = util:unixtime() + 24 * 3600 * 10},
    put(?PROC_STATUS_PRAY, NewStPRAY),
    ?ASSERT(Player#player.bgold + Player#player.gold > 100, {false, 5}),
    Newplayer = money:add_gold(Player, -100, 10, 0, 0),
    pray_pack:send_pray_info(NewStPRAY, Player),

    pray_load:dbup_pray_fashid(NewStPRAY),
    {ok, Newplayer}.
quick_pray(Player) ->
    StPRAY = lib_dict:get(?PROC_STATUS_PRAY),
    ?ASSERT(StPRAY#st_pray.quick_times =< Player#player.vip_lv, {false, 8}),
    AddTime = 4 * 3600,
    Now = util:unixtime(),
    ?ASSERT(StPRAY#st_pray.left_cell_num >= 20, {false, 4}),
    ?ASSERT(StPRAY#st_pray.quick_times < data_quick_pray_gold:get_max_times(), {false, 6}),
    NeedGold = data_quick_pray_gold:get(StPRAY#st_pray.quick_times + 1),
    ?ASSERT(Player#player.gold + Player#player.bgold >= NeedGold, {false, 5}),
    if
        Now + AddTime >= StPRAY#st_pray.equip_remain_time ->
            MoreTime = Now + AddTime - StPRAY#st_pray.equip_remain_time,
            GoodsList1 = pray_util:pray_goods_finsh(StPRAY#st_pray.bag_list),
                catch erlang:cancel_timer(StPRAY#st_pray.timerRef),
            {NewGoodsList, EquipRemainTime, NewTimerRef} = pray_init:init_pray_bag(Player, MoreTime, StPRAY#st_pray.fashion_id, StPRAY#st_pray.fashion_time, StPRAY#st_pray.left_cell_num),
            NeBagList = GoodsList1 ++ NewGoodsList,
            NewStPRAY = StPRAY#st_pray{
                timerRef = NewTimerRef,
                quick_times = StPRAY#st_pray.quick_times + 1,
                left_cell_num = StPRAY#st_pray.cell_num - length(NeBagList),
                bag_list = NeBagList,
                equip_remain_time = EquipRemainTime};
        true ->
            NewStPRAY = StPRAY#st_pray{
                quick_times = StPRAY#st_pray.quick_times + 1,
                equip_remain_time = StPRAY#st_pray.equip_remain_time - AddTime}
    end,
    pray_pack:send_pray_info(NewStPRAY, Player),
    put(?PROC_STATUS_PRAY, NewStPRAY),
    pray_load:dbup_pray_equip_remain_time(NewStPRAY),
    ?ASSERT(Player#player.gold + Player#player.bgold > 100, {false, 5}),
    NewPlayer = money:add_gold(Player, -NeedGold, 28),
    {ok, NewPlayer}.

open_cell(Player, Cell) ->
    StPRAY = lib_dict:get(?PROC_STATUS_PRAY),
    if
        StPRAY#st_pray.cell_num >= Cell ->
            {false, 7};
        true ->
            Gold = lists:foldl(fun(CellNum, OUt) -> {NGold, _} = data_pray_bag:get(CellNum),
                OUt + NGold end, 0, lists:seq(StPRAY#st_pray.cell_num + 1, Cell)),
            ?ASSERT(Player#player.gold + Player#player.bgold >= Gold, {false, 5}),
            Newplayer = money:add_gold(Player, -Gold, 10, 0, 0),
            NewStPRAY = StPRAY#st_pray{cell_num = Cell,
                left_cell_num = Cell - length(StPRAY#st_pray.bag_list)},
            pray_load:dbup_pray_max_cell(NewStPRAY),
            %?PRINT("open_cell ~p ~n",[lists:seq(StPRAY#st_pray.cell_num+1, Cell)]),
            %?PRINT("equip_remain_time ~p ~n",[StPRAY#st_pray.equip_remain_time]),
            if
                StPRAY#st_pray.equip_remain_time =:= 0 -> %%原来背包是满的
                    pray_init:pray_new_equip(Player, NewStPRAY);
                true ->
                    put(?PROC_STATUS_PRAY, NewStPRAY),
                    pray_pack:send_pray_info(NewStPRAY, Player)
            end,
            {ok, Newplayer}
    end.

			
			
			
	
	

