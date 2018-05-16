%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         转盘
%%% @end
%%%-------------------------------------------------------------------
-module(act_lucky_turn).
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").
-include("daily.hrl").
-include("goods.hrl").
-author("lzx").

-define(CROSS_LUCKY_TURN_KEY(ActId), {cross_lucky_turn_key, ActId}).
-define(PLAYER_LUCKY_TURN_KEY(PKey, ActId), {player_lucky_turn_key, PKey, ActId}).
-define(LUCKY_TURN_CACHE_IDS, lucky_turn_cache_ids).

%% API
-export([
    init/1,
    get_info/1,
    get_info2/6,
    get_act/0,
    get_state/1,
    lucky_turn/2,
    exchange_goods/3,
    cost_luck_turn_gold/1,
    do_cost_luck_gold/1,
    logout/1,
    get_cross_info2/0,
    cast_cross_lucky_tv_msg2/5,
    cast_cross_lucky_tv_msg3/5,
    do_back_cross_gold3/1,
    do_back_cross_gold2/1,
    send_gold_effect/5,
    do_client_refresh/1,
    notice_client_refresh/0,
    gm_clear_msg/0,
    gm_clear_msg2/0
]).


get_act() ->
    case activity:get_work_list(data_act_lucky_turn) of
        [Base | _] -> Base;
        _ ->
            []
    end.

init(Player) ->
    Player.


get_player_info(#player{key = Pkey}) ->
    #base_act_lucky_turn{act_id = ActId} = get_act(),
    case ?GLOBAL_DATA_RAM:get(?PLAYER_LUCKY_TURN_KEY(Pkey, ActId), false) of
        false ->
            PlayerInfo =
                case activity_load:dbget_lucky_turn(Pkey) of
                    #st_luck_turn{act_id = ActId} = StLucky -> StLucky;
                    _ ->
                        #st_luck_turn{act_id = ActId,pkey = Pkey}
                end,
            case get(?LUCKY_TURN_CACHE_IDS) of
                undefined ->
                    [];
                ActList ->
                    put(?LUCKY_TURN_CACHE_IDS, [ActId | lists:delete(ActId, ActList)])
            end,
            ?GLOBAL_DATA_RAM:set(?PLAYER_LUCKY_TURN_KEY(Pkey, ActId), PlayerInfo),
            PlayerInfo;
        PlayerInfo -> PlayerInfo
    end.


%% 退出删除缓存
logout(#player{key = PKey}) ->
    ActIdList = case get(?LUCKY_TURN_CACHE_IDS) of
                    undefined -> [];
                    KeyList -> KeyList
                end,
    [?GLOBAL_DATA_RAM:del(?PLAYER_LUCKY_TURN_KEY(PKey, ActId)) || ActId <- ActIdList].



set_player_info(Pkey, #st_luck_turn{act_id = ActId} = LuckySt) ->
    ?GLOBAL_DATA_RAM:set(?PLAYER_LUCKY_TURN_KEY(Pkey, ActId), LuckySt),
    activity_load:dbup_lucky_turn(LuckySt).


%% 获取
get_cross() ->
    case get_act() of
        #base_act_lucky_turn{act_id = ActId, initgold = InitGold} ->
            case ?GLOBAL_DATA_RAM:get(?CROSS_LUCKY_TURN_KEY(ActId), false) of
                false ->
                    CrossServer =
                        case activity_load:dbget_lucky_turn_cross(ActId) of
                            #cross_st_luck_turn{act_id = ActId} = CrossSt -> CrossSt;
                            _ ->
                                #cross_st_luck_turn{act_id = ActId, gold = InitGold}
                        end,
                    ?GLOBAL_DATA_RAM:set(?CROSS_LUCKY_TURN_KEY(ActId), CrossServer),
                    CrossServer;
                LuckServer -> LuckServer
            end;
        _ ->
            false
    end.


%% @doc 获取开启状态
get_state(_Player) ->
    case get_act() of
        #base_act_lucky_turn{score_list = ScoreList, one_score = _One, ten_score = _TenScore, free_time = FreeTime, act_info = ActInfo} ->
            TodayFree = daily:get_count(?DAILY_ACT_LUCKY_TURN, 0),
            LeftFreeTime = max(FreeTime - TodayFree, 0),
            #st_luck_turn{score = CurScore, ex_list = ExList} = get_player_info(_Player),
            {IndexScoreLs, _} =
                lists:mapfoldl(fun({GoodsId, GoodsNum, ExScore, Limit}, AccIn) ->
                    {{AccIn, GoodsId, GoodsNum, ExScore, Limit}, AccIn + 1}
                               end, 1, ScoreList),
            Ret =
                lists:any(fun({Index, _GoodsId, _GoodsNum, NeedScore, Limit}) ->
                    case lists:keyfind(Index, 1, ExList) of
                        {_, ExNum} -> LeftLimit = max(Limit - ExNum, 0);
                        _ ->
                            LeftLimit = Limit
                    end,
                    CurScore >= NeedScore andalso LeftLimit > 0
                          end, IndexScoreLs),
            Ret2 = Ret orelse LeftFreeTime > 0,
            Args = activity:get_base_state(ActInfo),
            case Ret2 of
                true -> {1, Args};
                false -> {0, Args}
            end;
        _ ->
            -1
    end.


%% @doc  面板信息
get_info(_Player) ->
    case get_act() of
        #base_act_lucky_turn{free_time = FreeTime} ->
            LeaveTime = activity:get_leave_time(data_act_lucky_turn),
            TodayFree = daily:get_count(?DAILY_ACT_LUCKY_TURN, 0),
            LeftFreeTime = max(FreeTime - TodayFree, 0),
            #st_luck_turn{draw_time = DrawTime0, score = CurScore, ex_list = ExList} = get_player_info(_Player),
            DrawTime = max(1, DrawTime0),
            cross_all:apply(?MODULE, get_info2, [_Player#player.sid, LeaveTime, LeftFreeTime, DrawTime, CurScore, ExList]);
        _ ->
            Data = {0, 0, [], 0, 0, 0, 0, [], []},
            {ok, Bin} = pt_438:write(43803, Data),
            server_send:send_to_sid(_Player#player.sid, Bin)
    end.


get_info2(Sid, LeaveTime, LeftFreeTime, DrawTime, CurScore, ExList) ->
    Data =
        case get_act() of
            #base_act_lucky_turn{award_list = AwardIds, score_list = ScoreList, one_cost = OneCost, ten_cost = TenCost,
                one_score = _One, ten_score = _TenScore} ->
                SelectGoods = case [GoodsList || {{Range1, Range2}, GoodsList} <- AwardIds, DrawTime >= Range1, DrawTime =< Range2] of
                                  [HList | _] -> HList;
                                  _ -> []
                              end,
                {GoodsPackList, _} =
                    lists:mapfoldl(fun({GoodsId, GoodsNum, _, _, _}, AccIn) ->
                        {[AccIn, GoodsId, GoodsNum], AccIn + 1}
                                   end, 1, SelectGoods),
                {ScorePackList, _} =
                    lists:mapfoldl(fun({GoodsId, GoodsNum, ExScore, Limit}, AccIn) ->
                        case lists:keyfind(AccIn, 1, ExList) of
                            {_, ExNum} -> LeftLimit = max(Limit - ExNum, 0);
                            _ ->
                                LeftLimit = Limit
                        end,
                        {[AccIn, GoodsId, GoodsNum, ExScore, LeftLimit], AccIn + 1}
                                   end, 1, ScoreList),
                #cross_st_luck_turn{gold = LeftGold, log_list = ActMsg} = get_cross_info2(),
                {LeaveTime, LeftGold, ActMsg, LeftFreeTime, CurScore, OneCost, TenCost, GoodsPackList, ScorePackList};
            _ ->
                {0, 0, [], 0, 0, 0, 0, [], []}
        end,
    {ok, Bin} = pt_438:write(43803, Data),
    server_send:send_to_sid(Sid, Bin).


%% @doc 开始转转盘
lucky_turn(_Player, Type) ->
    case get_act() of
        #base_act_lucky_turn{act_id = ActId} = BaseAct ->
            case get_cross_info() of
                #cross_st_luck_turn{act_id = ActId} -> %% 活动ID对不上，直接不给抽奖了
                    case Type of
                        1 ->
                            lucky_turn_one_time(_Player, BaseAct);
                        _ ->
                            lucky_turn_ten_time(_Player, BaseAct)
                    end;
                _ ->
                    {fail, 4}
            end;
        _ ->
            {fail, 4}
    end.


lucky_turn_one_time(_Player, #base_act_lucky_turn{free_time = FreeTime, one_cost = OneCost, one_score = OneScore, one_back = OneBack} = BaseAct) ->
    TodayFree = daily:get_count(?DAILY_ACT_LUCKY_TURN, 0),
    LeftFreeTime = max(FreeTime - TodayFree, 0),
    case LeftFreeTime > 0 of
        true ->
            %% 有免费次数
            daily:increment(?DAILY_ACT_LUCKY_TURN, 1),
            NewPlayer = _Player;
        false ->
            ?ASSERT(money:is_enough(_Player, OneCost, gold), {fail, 5}),
            NewPlayer = money:cost_money(_Player, gold, -OneCost, 542, 0, 0)
    end,
    {NewPlayer1, AwardCellList, GetGoodsList, GetMoney, TvList} = do_luck_turn(NewPlayer, 1, BaseAct, [], [], 0, []),
    NewPlayer20 = ?IF_ELSE(GetMoney > 0, money:add_gold(NewPlayer1, GetMoney, 542, 0, 0), NewPlayer1),
    GiveGoodsList = goods:make_give_goods_list(542, GetGoodsList),
    {ok, NewPlayer2} = goods:give_goods(NewPlayer20, GiveGoodsList),
    BackCost = ?IF_ELSE(LeftFreeTime > 0, 0, OneCost),
    do_back_cross_gold(NewPlayer2, BackCost, OneBack),
    StLucky = get_player_info(_Player),
    NewStLucky = StLucky#st_luck_turn{score = StLucky#st_luck_turn.score + OneScore},
    log_act_lucky_turn(_Player, GetGoodsList, GetMoney, BackCost, NewStLucky#st_luck_turn.score, 1),
    set_player_info(_Player#player.key, NewStLucky),
    cross_all:apply(?MODULE, notice_client_refresh, []),
    lists:foreach(fun({TvGoodId, TvNum, TvMoney}) ->
        cast_cross_lucky_tv_msg(_Player, TvGoodId, TvNum, TvMoney)
                  end, TvList),
    {ok, Bin} = pt_438:write(43808, {NewStLucky#st_luck_turn.score}),
    server_send:send_to_sid(_Player#player.sid, Bin),
    {ok, NewPlayer2, AwardCellList}.


%% 抽奖十次
lucky_turn_ten_time(_Player, #base_act_lucky_turn{ten_cost = TenCost, ten_score = TenScore, ten_back = TenBackRate} = BaseAct) ->
    ?ASSERT(money:is_enough(_Player, TenCost, gold), {fail, 5}),
    {NewPlayer0, AwardCellList, GetGoodsList, GetMoney, TvList} = do_luck_turn(_Player, 10, BaseAct, [], [], 0, []),
    NewPlayer = money:cost_money(NewPlayer0, gold, -TenCost, 542, 0, 0),
    NewPlayer20 = ?IF_ELSE(GetMoney > 0, money:add_gold(NewPlayer, GetMoney, 542, 0, 0), NewPlayer),
    GiveGoodsList = goods:make_give_goods_list(542, GetGoodsList),
    {ok, NewPlayer2} = goods:give_goods(NewPlayer20, GiveGoodsList),
    do_back_cross_gold(NewPlayer2, TenCost, TenBackRate),
    StLucky = get_player_info(_Player),
    NewStLucky = StLucky#st_luck_turn{score = StLucky#st_luck_turn.score + TenScore},
    log_act_lucky_turn(_Player, GetGoodsList, GetMoney, TenCost, NewStLucky#st_luck_turn.score, 2),
    set_player_info(_Player#player.key, NewStLucky),
    cross_all:apply(?MODULE, notice_client_refresh, []),
    lists:foreach(fun({TvGoodId, TvNum, TvMoney}) ->
        cast_cross_lucky_tv_msg(_Player, TvGoodId, TvNum, TvMoney)
                  end, TvList),
    {ok, Bin} = pt_438:write(43808, {NewStLucky#st_luck_turn.score}),
    server_send:send_to_sid(_Player#player.sid, Bin),
    {ok, NewPlayer2, AwardCellList}.



do_luck_turn(_Player, 0, _, CellList, GetGoods, GetMoney, TvList) ->
    {_Player, lists:reverse(CellList), lists:reverse(GetGoods), GetMoney, lists:reverse(TvList)};
do_luck_turn(_Player, Time, #base_act_lucky_turn{award_list = AwardList} = BaseAct, CellList, GetGoods, GetMoney, TvList) ->
    #st_luck_turn{draw_time = DrawTime0} = StLucky = get_player_info(_Player),
    DrawTime = max(1, DrawTime0),
    SelectGoods = case [GoodsList || {{Range1, Range2}, GoodsList} <- AwardList, DrawTime >= Range1, DrawTime =< Range2] of
                      [HList | _] -> HList;
                      _ -> []
                  end,

    {WeightList, _} =
        lists:mapfoldl(fun({_GoodsId, _GoodsNum, Weight, _, _}, AccIn) ->
            {{AccIn, Weight}, AccIn + 1}
                       end, 1, SelectGoods),
    case util:list_rand_ratio(WeightList) of
        Index when Index > 0 ->
            {GoodsId, GoodsNum, _, IsRareGoods, IsSendTv} = lists:nth(Index, SelectGoods),
            #goods_type{type = GoodsType, subtype = SubType} = data_goods:get(GoodsId),
            case GoodsType == 51 andalso SubType == 773 of
                true -> %% 随机到金币了
                    AddMoney = call_cross_all_add_money(_Player, GoodsNum),
%%                    NewPlayer = money:add_gold(_Player, AddMoney, 542, 0, 0),
                    NewCellList = [[Index, GoodsId, AddMoney] | CellList],
                    NewGetGoods = GetGoods,
                    NewGetMoney = GetMoney + AddMoney;
                _ -> %% 给予玩家物品
%%                    GiveGoodsList = goods:make_give_goods_list(542, [{GoodsId,GoodsNum}]),
%%                    {ok, NewPlayer} = goods:give_goods(_Player, GiveGoodsList),
                    NewCellList = [[Index, GoodsId, GoodsNum] | CellList],
                    NewGetGoods = [{GoodsId, GoodsNum} | GetGoods],
                    NewGetMoney = GetMoney,
                    AddMoney = 0
            end,
            NewTvList =
                case IsSendTv > 0 of
                    true -> [{GoodsId, GoodsNum, AddMoney} | TvList];
%%                    cast_cross_lucky_tv_msg(_Player,GoodsId,GoodsNum,AddMoney);
                    false ->
                        TvList
                end,
            case IsRareGoods > 0 of
                true ->
                    NewDraw = 1;
                false ->
                    NewDraw = DrawTime + 1
            end,
            NewStLucky = StLucky#st_luck_turn{draw_time = NewDraw},
            ?GLOBAL_DATA_RAM:set(?PLAYER_LUCKY_TURN_KEY(_Player#player.key, NewStLucky#st_luck_turn.act_id), NewStLucky);
        _ ->
            ?WARNING("do_lucky_turn_get not index pkey:~w SelectGoods:~w", [_Player#player.key, SelectGoods]),
            NewCellList = CellList,
            NewGetGoods = GetGoods,
            NewGetMoney = GetMoney,
            NewTvList = TvList
    end,
    do_luck_turn(_Player, Time - 1, BaseAct, NewCellList, NewGetGoods, NewGetMoney, NewTvList).


%% 请求跨服扣金币 中奖比例
call_cross_all_add_money(_Player, _CostRate) ->
    case catch cross_all:apply_call(?MODULE, cost_luck_turn_gold, [_CostRate]) of
        Gold when is_integer(Gold) ->
            Gold;
        _R ->
            ?ERR("apply call cost lucky turn fail ~w", [_R]),
            throw({fail, 4})
    end.


%% 扣取金币
cost_luck_turn_gold(CrossRate) ->
    ?CALL(activity_proc:get_act_pid(), {cost_luck_turn_gold, CrossRate}).



do_cost_luck_gold(CrossRate) ->
    case get_cross() of
        #cross_st_luck_turn{act_id = ActId, gold = Gold, log_list = _LogList} = CrossLucky ->
            #base_act_lucky_turn{initgold = InitGold} = get_act(),
            GiveGold = round(Gold * CrossRate / 100),
            LeftGold = max(Gold - GiveGold, InitGold),
%%            ?PRINT("GiveGold : ~w,LeftGold :~w",[GiveGold,LeftGold]),
            NewCrossLucky = CrossLucky#cross_st_luck_turn{gold = LeftGold},
            ?GLOBAL_DATA_RAM:set(?CROSS_LUCKY_TURN_KEY(ActId), NewCrossLucky),
            activity_load:dbup_lucky_turn_cross(NewCrossLucky),
            GiveGold;
        _ ->
            {fail, 4}
    end.


%% 请求跨服信息
get_cross_info() ->
    case catch cross_all:apply_call(?MODULE, get_cross_info2, []) of
        #cross_st_luck_turn{} = ServerCross -> ServerCross;
        _R ->
            ?ERR("get cross info2 err  ~w", [_R]),
            #cross_st_luck_turn{}
    end.



get_cross_info2() ->
    case get_cross() of
        false -> #cross_st_luck_turn{};
        CrossSt -> CrossSt
    end.

%% 跨服信息
cast_cross_lucky_tv_msg(#player{sn_cur = SnCur, nickname = NickNiame}, GoodsId, GoodsNum, AddMoney) ->
    cross_all:apply(?MODULE, cast_cross_lucky_tv_msg2, [SnCur, NickNiame, GoodsId, GoodsNum, AddMoney]).

cast_cross_lucky_tv_msg2(SnCur, NickNiame, GoodsId, GoodsNum, AddMoney) ->
    ?CAST(activity_proc:get_act_pid(), {cast_cross_lucky_tv_msg3, [SnCur, NickNiame, GoodsId, GoodsNum, AddMoney]}).

cast_cross_lucky_tv_msg3(SnCur, NickNiame, GoodsId, GoodsNum, AddMoney) ->
    case get_cross() of
        #cross_st_luck_turn{log_list = LogMsg, gold = Gold, act_id = ActId} = CrossSt ->
            NewLogList = lists:sublist([[SnCur, NickNiame, GoodsId, GoodsNum, AddMoney, Gold] | LogMsg], 20),
            NewCross = CrossSt#cross_st_luck_turn{log_list = NewLogList},
            ?GLOBAL_DATA_RAM:set(?CROSS_LUCKY_TURN_KEY(ActId), NewCross),
            #goods_type{type = GoodsType, subtype = SubType} = data_goods:get(GoodsId),
            case GoodsType == 51 andalso SubType == 773 of %% 抽到比例，全服公告
                true ->
                    F = fun(Node) ->
                        center:apply(Node, ?MODULE, send_gold_effect, [SnCur, NickNiame, GoodsNum, AddMoney, Gold])
                        end,
                    lists:foreach(F, center:get_nodes());
                false ->
                    ok
            end;
        _ ->
            ok
    end.

%% 发送元宝特效
send_gold_effect(SnCur, NickNiame, GoodsNum, AddMoney, Gold) ->
    case get_act() of
        #base_act_lucky_turn{} ->
            notice_sys:add_notice(act_lucky_turn, [SnCur, NickNiame, GoodsNum, AddMoney, Gold]),
            {ok, Bin} = pt_438:write(43806, {}),
            Sids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
            [server_send:send_to_pid(Pid, Bin) || [Pid] <- Sids];
        _ ->
            ok
    end.


do_back_cross_gold(_Player, Cost, _BackRate) ->
%%    BackGold = round(Cost * BackRate / 100),
        catch cross_all:apply(?MODULE, do_back_cross_gold2, [Cost]).


%% 返还钻石
do_back_cross_gold2(BackGold) ->
    ?CAST(activity_proc:get_act_pid(), {do_back_cross_gold3, BackGold}).


%% 返还给奖池库
do_back_cross_gold3(_BackGold) ->
    case get_cross() of
        #cross_st_luck_turn{act_id = ActId, gold = Gold} = CrossLucky ->
            #base_act_lucky_turn{backlist = BackList} = get_act(),
            case [BackRate || {Range1, Range2, BackRate} <- BackList, Range1 =< Gold, Gold =< Range2] of
                [BackRate1 | _] ->
                    BackGold = round(_BackGold * BackRate1 / 100),
                    NewGold = BackGold + Gold,
                    NewCrossLucky = CrossLucky#cross_st_luck_turn{gold = NewGold},
                    ?GLOBAL_DATA_RAM:set(?CROSS_LUCKY_TURN_KEY(ActId), NewCrossLucky),
                    activity_load:dbup_lucky_turn_cross(NewCrossLucky);
                _ ->
                    ok
            end;
        _ ->
            0
    end.


notice_client_refresh() ->
    case get_cross() of
        #cross_st_luck_turn{gold = NowGold} ->
            F = fun(Node) ->
                center:apply(Node, ?MODULE, do_client_refresh, [NowGold])
                end,
            lists:foreach(F, center:get_nodes());
        _ ->
            ok
    end.



do_client_refresh(NowGold) ->
    {ok, Bin} = pt_438:write(43807, {NowGold}),
    Sids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
    [server_send:send_to_pid(Pid, Bin) || [Pid] <- Sids].


%% @doc 兑换
exchange_goods(_Player, _ExCellId, ExNum) ->
    case get_act() of
        #base_act_lucky_turn{score_list = ScoreList} ->
            ?ASSERT_TRUE(_ExCellId > length(ScoreList), {fail, 6}),
            {GoodsId, GoodsNum, NeedScore, LimitNum} = lists:nth(_ExCellId, ScoreList),
            #st_luck_turn{ex_list = ExList, score = MyScore} = StLucky = get_player_info(_Player),
            case lists:keyfind(_ExCellId, 1, ExList) of
                {_, HasEx} -> ok;
                _ -> HasEx = 0
            end,
            ?ASSERT_TRUE(HasEx + ExNum > LimitNum, {fail, 7}), %%兑换已达到上限
            CostScore = (ExNum * NeedScore), %%总花费积分
            ?ASSERT_TRUE(CostScore > MyScore, {fail, 8}),   %% 积分不足
            GiveGoodsNum = ExNum * GoodsNum,
            ExList2 = lists:keystore(_ExCellId, 1, ExList, {_ExCellId, ExNum + HasEx}),
            NewStLucky = StLucky#st_luck_turn{ex_list = ExList2, score = MyScore - CostScore},
            set_player_info(_Player#player.key, NewStLucky),
            GiveGoodsList = goods:make_give_goods_list(551, [{GoodsId, GiveGoodsNum}]),
            {ok, NewPlayer} = goods:give_goods(_Player, GiveGoodsList),
            log_act_lucky_turn(_Player, [{GoodsId, GiveGoodsNum}], 0, 0, NewStLucky#st_luck_turn.score, 3),
            {ok, Bin} = pt_438:write(43808, {NewStLucky#st_luck_turn.score}),
            server_send:send_to_sid(_Player#player.sid, Bin),
            {ok, NewPlayer};
        _ ->
            {fail, 4}
    end.

%% @doc gm 清除中奖信息
gm_clear_msg() ->
        catch cross_all:apply(?MODULE, gm_clear_msg2, []).

gm_clear_msg2() ->
    case get_cross() of
        #cross_st_luck_turn{act_id = ActId} = CrossSt ->
            NewCrossSt = CrossSt#cross_st_luck_turn{log_list = []},
            ?GLOBAL_DATA_RAM:set(?CROSS_LUCKY_TURN_KEY(ActId), NewCrossSt);
        _ ->
            ok
    end.


%% 日志
log_act_lucky_turn(#player{key = Pkey, nickname = NickName}, GoodsList, Gold, CostGold, Score, Opera) ->
    Sql = io_lib:format("insert into log_act_lucky_turn set pkey=~p,nickname = '~s',goods='~s',gold = ~p,cost_gold = ~p,score = ~p,opera = ~p,time=~p",
        [Pkey, NickName, util:term_to_bitstring(GoodsList), Gold, CostGold, Score, Opera, util:unixtime()]),
    log_proc:log(Sql).


