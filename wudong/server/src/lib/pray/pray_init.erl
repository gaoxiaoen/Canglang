%% @author and_me
%% @doc @todo Add description to pray_init.


-module(pray_init).

-include("common.hrl").
-include("server.hrl").
-include("pray.hrl").



-export([init/1, loop/1, init_pray_bag/5, get_new_equip/3, player_loop/2, pray_quick_times_init/1, pray_new_equip/2]).

init(Player) ->
%%	{CellNum,EquipRemainTime,QuickTimes,FashionId,FashionTime} = pray_load:load_pary_info(Player#player.key),
%%	GoodsList = pray_load:load_pray_bag(Player),
%%	Now = util:unixtime(),
%%	%?PRINT("GoodsList ~p ~p ~p ~n",[GoodsList,EquipRemainTime,Now - EquipRemainTime]),
%%	if
%%		GoodsList =:= [] andalso EquipRemainTime =:= 0-> %%初始状态
%%			{NewGoodsList,NewEquipRemainTime,TimerRef} = init_pray_bag(Player,0,FashionId,FashionTime,CellNum);
%%		EquipRemainTime > 0 andalso Now >= EquipRemainTime->
%%			GoodsList1 =  pray_util:pray_goods_finsh(GoodsList),
%%			MoreTime = Now - EquipRemainTime,
%%			LeftCell = CellNum - length(GoodsList1),
%%			{GoodsList2,NewEquipRemainTime,TimerRef} = init_pray_bag(Player,MoreTime,FashionId,FashionTime,LeftCell),
%%			NewGoodsList = GoodsList1 ++ GoodsList2;
%%		EquipRemainTime > 0 andalso EquipRemainTime >= Now->
%%			TimerRef = erlang:send_after((EquipRemainTime - Now)*1000, self(), {apply_state,{?MODULE,player_loop,[]}}),
%%			NewGoodsList = GoodsList,
%%			NewEquipRemainTime = EquipRemainTime;
%%		true->
%%			%?PRINT("pray_bag boom ~p ~n",[length(GoodsList)]),
%%			TimerRef = 0,
%%			NewGoodsList = GoodsList,
%%			NewEquipRemainTime = EquipRemainTime
%%	end,
%%	PrayStatus = #st_pray{
%%	  pkey = Player#player.key,
%%	  quick_times = QuickTimes,
%%	  fashion_time = FashionTime,
%%	  fashion_id = FashionId,
%%	  equip_remain_time = NewEquipRemainTime,
%%      cell_num = CellNum,
%%	  left_cell_num = CellNum - length(NewGoodsList),
%%	  bag_list = NewGoodsList,
%%	  timerRef = TimerRef},

    lib_dict:put(?PROC_STATUS_PRAY, #st_pray{}),
%%	%?PRINT("NewEquipRemainTime ~p ~n",[NewEquipRemainTime]),
%%	pray_load:dbup_pray_equip_remain_time(PrayStatus),
%%	case util:is_same_date(Player#player.logout_time, util:unixtime()) of
%%		false->
%%			pray_quick_times_init(Player);
%%		_->
%%			skip
%%	end,
    Player.


init_pray_bag(Player, MoreTime, _FashionId, _FashionTime, LeftCellNum) ->
    case data_pray_equip:get(Player#player.lv) of
        [] ->
            {[], 0, undefined};
        PrayEquip ->
            FinishNum = trunc(MoreTime / PrayEquip#base_pray_equip.need_time),
            if
                LeftCellNum > FinishNum ->
                    Now = util:unixtime(),
                    GoodsList2 = get_new_equip(FinishNum, Player, ?PRAY_STATE_FINSH),
                    GoodsList3 = get_new_equip(1, Player, ?PRAY_STATE_ING),
                    NewEquipRremainTime = Now + PrayEquip#base_pray_equip.need_time - (MoreTime rem PrayEquip#base_pray_equip.need_time),
                    %?PRINT("init_pray_bag LeftCellNum ~p NewEquipRremainTime ~p ~p ~n",[LeftCellNum,NewEquipRremainTime,NewEquipRremainTime - util:unixtime()]),
                    TimerRef = erlang:send_after((NewEquipRremainTime - Now) * 1000, self(), {apply_state, {?MODULE, player_loop, []}}),
                    {GoodsList2 ++ GoodsList3, NewEquipRremainTime, TimerRef};
                true ->
                    GoodsList2 = get_new_equip(LeftCellNum, Player, ?PRAY_STATE_FINSH),
                    {GoodsList2, 0, undefined}
            end
    end.



get_new_equip(N, Player, State) ->
    case catch get_new_equip(N, Player, [], State) of
        List when is_list(List) ->
            List;
        Other ->
            ?ERR("get_new_equip error ~p ~n", [Other]),
            []
    end.


get_new_equip(N, Player, OutList, State) when N > 0 ->
    BasePrayEquip = data_pray_equip:get(Player#player.lv),
    {Color, _} = lists:nth(util:probability_list_nth([P || {_, P} <- BasePrayEquip#base_pray_equip.color]), BasePrayEquip#base_pray_equip.color),
    {Level, _} = lists:nth(util:probability_list_nth([P || {_, P} <- BasePrayEquip#base_pray_equip.level]), BasePrayEquip#base_pray_equip.level),
    {SubType, _} = lists:nth(util:probability_list_nth([P || {_, P} <- BasePrayEquip#base_pray_equip.sub_type]), BasePrayEquip#base_pray_equip.sub_type),
    Career = Player#player.career,
    case data_smelt:get({SubType, Career, Level, Color}) of
        GoodsId when is_integer(GoodsId) ->
            PrayGoods = #pray_goods{
                state = State,
                key = misc:unique_key(),
                pkey = Player#player.key,
                goods_id = GoodsId,
                num = 1
            },
            pray_load:add_pray_equip(PrayGoods),
            get_new_equip(N - 1, Player, [PrayGoods | OutList], State);
        _ ->
            get_new_equip(N - 1, Player, OutList, State)
    end;

get_new_equip(_N, _Player, OutList, _State) ->
    OutList.


player_loop(_, Player) ->
    loop(Player),
    ok.

loop(Player) ->
    Now = util:unixtime(),
    StPRAY = lib_dict:get(?PROC_STATUS_PRAY),
    if
        StPRAY#st_pray.equip_remain_time =< 0 ->
            0;
        Now >= StPRAY#st_pray.equip_remain_time ->
            %%时间到，让背包里面正在祈祷的物品完成祈祷
            BagList = pray_util:pray_goods_finsh(StPRAY#st_pray.bag_list),
            NewStPRAY0 = StPRAY#st_pray{bag_list = BagList},
            if
                StPRAY#st_pray.left_cell_num =< 0 -> %%已经没有空格子放东西了
                    NewStPRAY = NewStPRAY0#st_pray{
                        equip_remain_time = 0},
                    lib_dict:put(?PROC_STATUS_PRAY, NewStPRAY),
                    pray_load:dbup_pray_equip_remain_time(NewStPRAY),
                    0;
                true ->
                    pray_new_equip(Player, NewStPRAY0)
            end;
        true ->
            StPRAY#st_pray.equip_remain_time - Now
    end.


pray_quick_times_init(_Player) ->
    PrayStatus = lib_dict:get(?PROC_STATUS_PRAY),
    NewPrayStatus = PrayStatus#st_pray{quick_times = 0},
    lib_dict:put(?PROC_STATUS_PRAY, NewPrayStatus),
    pray_load:dbup_pray_equip_remain_time(NewPrayStatus).

pray_new_equip(Player, StPRAY) ->
    case data_pray_equip:get(Player#player.lv) of
        [] ->
            0;
        PrayEquip ->
            Now = util:unixtime(),
                catch erlang:cancel_timer(StPRAY#st_pray.timerRef),
            TimerRef = erlang:send_after(PrayEquip#base_pray_equip.need_time * 1000, self(), {apply_state, {?MODULE, player_loop, []}}),
            NewGoodsNum = ?IF_ELSE(StPRAY#st_pray.fashion_id == 10001, 1, 1),
            AddNum = ?IF_ELSE(StPRAY#st_pray.left_cell_num >= NewGoodsNum, NewGoodsNum, StPRAY#st_pray.left_cell_num),
            NewPrayGoodsList = get_new_equip(AddNum, Player, ?PRAY_STATE_ING),
            NewStPRAY = StPRAY#st_pray{
                timerRef = TimerRef,
                equip_remain_time = Now + PrayEquip#base_pray_equip.need_time,
                left_cell_num = StPRAY#st_pray.left_cell_num - length(NewPrayGoodsList),
                bag_list = StPRAY#st_pray.bag_list ++ NewPrayGoodsList},
            lib_dict:put(?PROC_STATUS_PRAY, NewStPRAY),
            pray_load:dbup_pray_equip_remain_time(NewStPRAY),
            pray_pack:send_pray_info(NewStPRAY, Player),
            {ok, Bin} = pt_140:write(14000, {PrayEquip#base_pray_equip.need_time}),
            server_send:send_to_sid(Player#player.sid, Bin),
            PrayEquip#base_pray_equip.need_time
    end.
	
