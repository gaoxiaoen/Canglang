%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 七月 2016 上午11:48
%%%-------------------------------------------------------------------
-module(monopoly).
-author("fengzhenlin").
-include("activity.hrl").
-include("monopoly.hrl").
-include("server.hrl").

%% 协议接口
-export([
    get_monopoly_info/1,
    player_dice/2,
    player_morra/2,
    get_task_info/1,
    get_task_gift/2,
    get_round_gift/2
]).

%% API
-export([
    get_dict/0,
    put_dict/1,
    get_act/0,
    get_state/1
]).

get_dict() ->
    lib_dict:get(?PROC_STATUS_MONOPOLY).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_MONOPOLY, St).

get_monopoly_info(Player) ->
    case get_act() of
        [] -> skip;
        Base ->
            LeaveTime = activity:calc_act_leave_time(Base#base_act_monopoly.open_info),
            IconId = Base#base_act_monopoly.icon,
            St = get_dict(),
            #st_monopoly{
                finish_times = FinishTimes,
                dice_num = SumDiceNum,
                use_dice_num = UseDiceNum,
                buy_dice_times = BuyDiceTimes,
                cell_list = CellList,
                step_history = StepHistory,
                cur_step = CurStep,
                cur_step_state = CurStepState,
                gift_get_list = GiftGetList
            } = St,
            LeaveDiceNum = max(0, SumDiceNum - UseDiceNum),
            BuyCostGold = data_monopoly_cost:get(BuyDiceTimes + 1),
            F = fun(Id, AccStep) ->
                BType = data_monopoly:get(Id),
                Type = BType#base_monopoly.type,
                StepData =
                    case lists:member(AccStep, StepHistory) of
                        true -> [AccStep, Type, 2];
                        false ->
                            case AccStep == CurStep of
                                true -> [AccStep, Type, CurStepState];
                                false -> [AccStep, Type, 0]
                            end
                    end,
                {StepData, AccStep + 1}
                end,
            {StepList, _} = lists:mapfoldl(F, 1, CellList),
            F1 = fun({Round, GiftId}) ->
                State =
                    case lists:member(Round, GiftGetList) of
                        true -> 2;
                        false -> ?IF_ELSE(FinishTimes >= Round, 1, 0)
                    end,
                [Round, GiftId, State]
                 end,
            GiftList = lists:map(F1, Base#base_act_monopoly.gift_list),
            Data = {LeaveTime, IconId, LeaveDiceNum, BuyCostGold, StepList, CurStep, GiftList},
            {ok, Bin} = pt_432:write(43251, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

player_dice(Player, AutoBuy) ->
    case check_player_dice(Player, AutoBuy) of
        {false, Res} ->
            {false, Res};
        {ok, CostGold} ->
            NewPlayer = money:add_no_bind_gold(Player, -CostGold, 180, 0, 0),
            All = data_monopoly_pro:get_all(),
            F = fun(N) ->
                B = data_monopoly_pro:get(N),
                {B#base_monopoly_pro.num, B#base_monopoly_pro.pro}
                end,
            ProList = lists:map(F, All),
            Point =
                case get(gm_monopoly_point) of
                    GmPoint when is_integer(GmPoint) -> max(1, min(6, GmPoint));
                    _ -> util:list_rand_ratio(ProList)
                end,
            St = get_dict(),
            #st_monopoly{
                cur_step = CurStep,
                finish_times = FinishTimes,
                buy_dice_times = BuyTimes,
                use_dice_num = UseTimes
            } = St,
            SumStep = CurStep + Point,
            case SumStep >= ?CELL_NUM of
                true -> %%完成一圈
                    monopoly_init:refresh_cell_list(Player),
                    NewStep = max(1, SumStep - ?CELL_NUM),
                    NewFinishTimes = FinishTimes + 1,
                    IsPass = false,
                    Id =
                        case SumStep == ?CELL_NUM of
                            true ->
                                lists:last(St#st_monopoly.cell_list);
                            false ->
                                Str = get_dict(),
                                lists:nth(NewStep, Str#st_monopoly.cell_list)
                        end;
                false ->
                    NewStep = SumStep,
                    NewFinishTimes = FinishTimes,
                    IsPass = lists:member(NewStep, St#st_monopoly.step_history),
                    Id = lists:nth(NewStep, St#st_monopoly.cell_list)
            end,
            NewBuyTimes = ?IF_ELSE(CostGold > 0, BuyTimes + 1, BuyTimes),
            NewUseTimes = ?IF_ELSE(CostGold > 0, UseTimes, UseTimes + 1),

            St1 = get_dict(),
            IsNewRound = ?IF_ELSE(NewFinishTimes > FinishTimes, 1, 0),

            Base = data_monopoly:get(Id),
            StepState = ?IF_ELSE(Base#base_monopoly.type == 6, 1, 2),
            NewStepHistory = St1#st_monopoly.step_history ++ [NewStep],
            NewSt = St1#st_monopoly{
                step_history = NewStepHistory,
                cur_step = NewStep,
                cur_step_state = StepState,
                finish_times = NewFinishTimes,
                buy_dice_times = NewBuyTimes,
                use_dice_num = NewUseTimes
            },
            put_dict(NewSt),

            NewPlayer99 =
                %case IsPass == false orelse Base#base_monopoly.type == 5 of
            case IsPass == false of
                true ->
                    case Base#base_monopoly.type of
                        1 -> %%给银币
                            money:add_coin(NewPlayer, Base#base_monopoly.args, 180, 0, 0);
                        2 -> %%再抛一次
                            St2 = get_dict(),
                            NewSt2 = St2#st_monopoly{use_dice_num = St2#st_monopoly.use_dice_num - 1},
                            put_dict(NewSt2),
                            NewPlayer;
                        3 -> %%扣银币
                            CostCoin = min(Base#base_monopoly.args, Player#player.coin),
                            money:add_coin(NewPlayer, -CostCoin, 180, 0, 0);
                        4 -> %%给绑钻
                            money:add_bind_gold(NewPlayer, Base#base_monopoly.args, 180, 0, 0);
                        5 -> %%黑洞
                            St2 = get_dict(),
                            Fh = fun(CellNum) ->
                                HId = lists:nth(CellNum, St2#st_monopoly.cell_list),
                                case CellNum =/= NewStep of
                                    true ->
                                        B = data_monopoly:get(HId),
                                        case B#base_monopoly.type == Base#base_monopoly.type of
                                            true -> CellNum;
                                            false -> []
                                        end;
                                    false ->
                                        []
                                end
                                 end,
                            case lists:flatten(lists:map(Fh, lists:seq(1, ?CELL_NUM))) of
                                [] -> NewPlayer;
                                [BackStep | _] ->
                                    NewSt2 = St2#st_monopoly{cur_step = BackStep},
                                    put_dict(NewSt2),
                                    NewPlayer
                            end;
                        7 -> %%招财卡
                            GiveGoodsList = goods:make_give_goods_list(180, [{Base#base_monopoly.args, 1}]),
                            {ok, NewPlayer1} = goods:give_goods(Player, GiveGoodsList),
                            NewPlayer1;
                        _ ->
                            NewPlayer
                    end;
                false ->
                    NewPlayer
            end,
            St99 = get_dict(),
            monopoly_load:dbup_monopoly(St99),
            #st_monopoly{
                cur_step = CurStep99,
                cell_list = CellList
            } = St99,
            StepId = lists:nth(CurStep99, CellList),
            Base99 = data_monopoly:get(StepId),
            BuyCostGold = data_monopoly_cost:get(St99#st_monopoly.buy_dice_times + 1),
            activity:get_notice(Player, [29], true),
            StepType = ?IF_ELSE(IsPass, 0, Base99#base_monopoly.type),
            {ok, NewPlayer99, Point, IsNewRound, CurStep99, StepType, Base99#base_monopoly.msg, BuyCostGold}
    end.
check_player_dice(Player, AutoBuy) ->
    St = get_dict(),
    case get_act() of
        [] -> {false, 0};
        _Base ->
            #st_monopoly{
                dice_num = Times,
                use_dice_num = UseTimes,
                buy_dice_times = BuyTimes
            } = St,
            if
                UseTimes >= Times andalso AutoBuy == 0 -> {false, 7};
                true ->
                    case UseTimes >= Times of
                        true ->
                            CostGold = data_monopoly_cost:get(BuyTimes + 1),
                            IsEnough = money:is_enough(Player, CostGold, gold),
                            if
                                not IsEnough -> {false, 5};
                                true ->
                                    {ok, CostGold}
                            end;
                        false ->
                            {ok, 0}
                    end
            end
    end.

player_morra(Player, Type) ->
    case check_player_morra(Player, Type) of
        {false, Res} ->
            {false, Res};
        ok ->
            SysType = util:rand(1, 3),
            Result =
                if
                    Type == SysType -> 3;
                    Type == 1 andalso SysType == 2 -> 1;
                    Type == 1 andalso SysType == 3 -> 2;
                    Type == 2 andalso SysType == 1 -> 2;
                    Type == 2 andalso SysType == 3 -> 1;
                    Type == 3 andalso SysType == 1 -> 1;
                    Type == 3 andalso SysType == 2 -> 2;
                    true -> 2
                end,
            Base = data_monopoly:get(6),
            {Coin1, Coin2, Coin3} = Base#base_monopoly.args,
            Coin =
                case Result of
                    1 -> Coin1;
                    2 -> Coin2;
                    _ -> Coin3
                end,
            NewPlayer = money:add_coin(Player, Coin, 181, 0, 0),
            St = get_dict(),
            NewSt = St#st_monopoly{
                cur_step_state = 2
            },
            put_dict(NewSt),
            monopoly_load:dbup_monopoly(NewSt),
            {ok, NewPlayer, Type, SysType, Coin}
    end.
check_player_morra(_Player, _Type) ->
    St = get_dict(),
    #st_monopoly{
        cur_step = CurStep,
        cur_step_state = CurStepState,
        cell_list = CellList
    } = St,
    if
        CurStepState =/= 1 -> {false, 8};
        true ->
            Id = lists:nth(CurStep, CellList),
            Base = data_monopoly:get(Id),
            if
                Base#base_monopoly.type =/= 6 -> {false, 8};
                true ->
                    ok
            end
    end.

get_task_info(Player) ->
    St = get_dict(),
    #st_monopoly{
        task_list = TaskList
    } = St,
    All = data_monopoly_task:get_all(),
    F = fun(Id) ->
        Base = data_monopoly_task:get(Id),
        #base_monopoly_task{
            times = Times,
            get_num = GetNum,
            msg = Msg
        } = Base,
        case lists:keyfind(Id, #m_task.id, TaskList) of
            false -> [Id, Msg, Times, 0, GetNum, 0];
            MTask ->
                #m_task{
                    do_times = Dotimes,
                    state = State
                } = MTask,
                [Id, Msg, Times, Dotimes, GetNum, State]
        end
        end,
    InfoList = lists:map(F, All),
    {ok, Bin} = pt_432:write(43254, {InfoList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_task_gift(Player, Id) ->
    case check_get_task_gift(Player, Id) of
        {false, Res} ->
            {false, Res};
        ok ->
            St = get_dict(),
            #st_monopoly{
                dice_num = DiceNum,
                use_dice_num = UseDiceNum,
                task_list = TaskList
            } = St,
            MTask = lists:keyfind(Id, #m_task.id, TaskList),
            NewMTask = MTask#m_task{state = 2},
            Base = data_monopoly_task:get(Id),
            NewTaskList = lists:keydelete(Id, #m_task.id, TaskList) ++ [NewMTask],
            NewSt = St#st_monopoly{
                dice_num = DiceNum + Base#base_monopoly_task.get_num,
                task_list = NewTaskList
            },
            put_dict(NewSt),
            monopoly_load:dbup_monopoly(NewSt),
            LeaveDiceNum = max(0, NewSt#st_monopoly.dice_num - UseDiceNum),
            activity:get_notice(Player, [29], true),
            {ok, Player, LeaveDiceNum}
    end.
check_get_task_gift(_Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        _B ->
            St = get_dict(),
            #st_monopoly{
                task_list = TaskList
            } = St,
            case lists:keyfind(Id, #m_task.id, TaskList) of
                false -> {false, 2};
                MTask ->
                    case MTask#m_task.state == 1 of
                        false -> {false, 2};
                        true -> ok
                    end
            end
    end.

get_round_gift(Player, Round) ->
    case check_get_round_gift(Player, Round) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            St = get_dict(),
            NewSt = St#st_monopoly{gift_get_list = St#st_monopoly.gift_get_list ++ [Round]},
            put_dict(NewSt),
            monopoly_load:dbup_monopoly(NewSt),
            GiveGoodsList = goods:make_give_goods_list(181, [{GiftId, 1}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            activity:get_notice(Player, [29], true),
            activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 181),
            {ok, NewPlayer}
    end.
check_get_round_gift(_Player, Round) ->
    St = get_dict(),
    case get_act() of
        [] -> {false, 0};
        B ->
            #st_monopoly{
                finish_times = FinishTimes,
                gift_get_list = GetList
            } = St,
            case lists:member(Round, GetList) of
                true -> {false, 3};
                false ->
                    case FinishTimes < Round of
                        true -> {false, 2};
                        false ->
                            case Round > length(B#base_act_monopoly.gift_list) orelse Round =< 0 of
                                true -> {false, 0};
                                false ->
                                    {_Round, GiftId} = lists:nth(Round, B#base_act_monopoly.gift_list),
                                    {ok, GiftId}
                            end
                    end
            end
    end.

get_act() ->
    case activity:get_work_list(data_act_monopoly) of
        [] -> [];
        [Base | _] -> Base
    end.

get_state(Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            St = get_dict(),
            LeaveDiceNum = max(0, St#st_monopoly.dice_num - St#st_monopoly.use_dice_num),
            Args = activity:get_base_state(Base#base_act_monopoly.act_info),
            case LeaveDiceNum > 0 of
                true -> {1, Args};
                false ->
                    F = fun({R, _GiftId}) ->
                        case check_get_round_gift(Player, R) of
                            {false, _} -> 0;
                            _ -> 1
                        end
                        end,
                    case lists:sum(lists:map(F, Base#base_act_monopoly.gift_list)) > 0 of
                        true -> {1, Args};
                        false ->
                            F1 = fun(T) ->
                                case T#m_task.state == 1 of
                                    true -> 1;
                                    false -> 0
                                end
                                 end,
                            case lists:sum(lists:map(F1, St#st_monopoly.task_list)) > 0 of
                                true -> {1, Args};
                                false -> {0, Args}
                            end
                    end
            end
    end.