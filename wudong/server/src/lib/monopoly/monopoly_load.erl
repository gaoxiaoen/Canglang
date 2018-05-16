%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 七月 2016 上午11:48
%%%-------------------------------------------------------------------
-module(monopoly_load).
-author("fengzhenlin").
-include("server.hrl").
-include("monopoly.hrl").

%% API
-export([
    dbget_monopoly/1,
    dbup_monopoly/1
]).

dbget_monopoly(Player) ->
    #player{key = Pkey} = Player,
    St = #st_monopoly{
        pkey = Pkey
    },
    case player_util:is_new_role(Player) of
        true -> St;
        false ->
            Sql = io_lib:format("select act_id,finish_times,cell_list,cur_step,cur_step_state,dice_num,use_dice_num,buy_dice_num,update_time,gift_get_list,task_list,step_history from player_monopoly where pkey = ~p",[Pkey]),
            case db:get_row(Sql) of
                [] -> St;
                [ActId,FinishTimes,CellListBin,CurStep,CurStepState,DiceNum,UseDiceNum,BuyDiceNum,UpdateTime,GiftGetListBin,TaskListBin,StepHistoryBin] ->
                    F = fun({Id, DoTimes,State}) ->
                            #m_task{id=Id,do_times=DoTimes,state=State}
                        end,
                    TaskList = lists:map(F, util:bitstring_to_term(TaskListBin)),
                    St#st_monopoly{
                        pkey = Pkey,
                        act_id = ActId,
                        finish_times = FinishTimes,
                        cell_list = util:bitstring_to_term(CellListBin),
                        cur_step = CurStep,
                        cur_step_state = CurStepState,
                        dice_num = DiceNum,
                        use_dice_num = UseDiceNum,
                        buy_dice_times = BuyDiceNum,
                        update_time = UpdateTime,
                        gift_get_list = util:bitstring_to_term(GiftGetListBin),
                        task_list = TaskList,
                        step_history = util:bitstring_to_term(StepHistoryBin)
                    }
            end
    end.

dbup_monopoly(St) ->
    #st_monopoly{
        pkey = Pkey,
        act_id = ActId,
        finish_times = FinishTimes,
        cell_list = CellList,
        cur_step = CurStep,
        cur_step_state = CurStepState,
        dice_num = DiceNum,
        use_dice_num = UseDiceNum,
        buy_dice_times = BuyDiceNum,
        update_time = UpdateTime,
        gift_get_list = GiftGetList,
        task_list = TaskList,
        step_history = StepHistory
    } = St,
    F = fun(MT) ->
        #m_task{id=Id,do_times=DoTimes,state=State} = MT,
        {Id, DoTimes,State}
    end,
    TaskList1 = lists:map(F, TaskList),

    Sql = io_lib:format("replace into player_monopoly set act_id=~p,finish_times=~p,cell_list='~s',cur_step=~p,cur_step_state=~p,dice_num=~p,use_dice_num=~p,buy_dice_num=~p,update_time=~p,gift_get_list='~s',task_list='~s',step_history='~s',pkey=~p",
        [ActId,FinishTimes,util:term_to_bitstring(CellList),CurStep,CurStepState,DiceNum,UseDiceNum,BuyDiceNum,UpdateTime,util:term_to_bitstring(GiftGetList),util:term_to_bitstring(TaskList1),util:term_to_bitstring(StepHistory),Pkey]),
    db:execute(Sql),
    ok.

