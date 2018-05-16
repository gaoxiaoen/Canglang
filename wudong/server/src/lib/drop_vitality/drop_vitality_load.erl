%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 七月 2016 上午11:29
%%%-------------------------------------------------------------------
-module(drop_vitality_load).
-author("fengzhenlin").
-include("server.hrl").
-include("drop_vitality.hrl").

%% API
-export([
    dbget_drop_vitality/1,
    dbup_drop_vitality/1
]).

dbget_drop_vitality(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_drop_vitality{
        pkey = Pkey,
        task_list = [],
        history_list = []
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select task_list,history_list,sum_point,update_time from player_drop_vitality where pkey = ~p",[Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [TaskListBin, HistoryListBin,SumPoint,Time] ->
                    F = fun({Id,Arg1,Arg2,State,UpdateTime}) ->
                            #d_v{
                                id = Id,
                                arg1 = Arg1,
                                arg2 = Arg2,
                                state = State,
                                update_time = UpdateTime
                            }
                        end,
                    TaskList = lists:map(F, util:bitstring_to_term(TaskListBin)),
                    #st_drop_vitality{
                        pkey = Pkey,
                        task_list = TaskList,
                        history_list = util:bitstring_to_term(HistoryListBin),
                        sum_point = SumPoint,
                        update_time = Time
                    }
            end
    end.

dbup_drop_vitality(StDropVitaltiy) ->
    #st_drop_vitality{
        pkey = Pkey,
        task_list = TaskList,
        history_list = HistoryList,
        sum_point = SumPoint,
        update_time = Time
    } = StDropVitaltiy,
    F = fun(DV) ->
            #d_v{
                id = Id,
                arg1 = Arg1,
                arg2 = Arg2,
                state = State,
                update_time = UpdateTime
            } = DV,
            {Id,Arg1,Arg2,State,UpdateTime}
        end,
    TaskListInfo = lists:map(F, TaskList),
    Sql = io_lib:format("replace into player_drop_vitality set task_list='~s',history_list='~s',sum_point=~p,update_time=~p,pkey=~p",
        [util:term_to_bitstring(TaskListInfo),util:term_to_bitstring(HistoryList),SumPoint,Time,Pkey]),
    db:execute(Sql),
    ok.
