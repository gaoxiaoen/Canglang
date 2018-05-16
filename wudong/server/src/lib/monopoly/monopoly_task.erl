%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 七月 2016 上午11:40
%%%-------------------------------------------------------------------
-module(monopoly_task).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("monopoly.hrl").

%% API
-export([
    trigger_m_task/3
]).

%% 1	竞技场胜利
%% 3	护送橙色水晶
%% 4	完成跑环任务
%% 5	消耗强化石
%% 6	消耗宠物进阶水晶
%% 7	消耗光翼进阶水晶
%% 8	消耗坐骑经验水晶
%% 9	消耗精灵经验水晶
%% 10	装备升级
%% 11	装备进阶橙装
%% 12	宠物升星
%% 13	消耗银币(含绑和非绑)
%% 14	消耗元宝(含绑和非绑)
%% 15	充值元宝

trigger_m_task(Player, Id, Times) ->
    case monopoly:get_act() of
        [] -> ok;
        _B ->
            St = monopoly:get_dict(),
            #st_monopoly{
                task_list = TaskList
            } = St,
            Base = data_monopoly_task:get(Id),
            if
                Base == [] -> ok;
                true ->
                    MT =
                        case lists:keyfind(Id, #m_task.id, TaskList) of
                            false ->
                                #m_task{
                                    id = Id
                                };
                            MTask ->
                                case MTask#m_task.state =/= 0 of
                                    true -> [];
                                    false -> MTask
                                end
                        end,
                    case MT of
                        [] -> ok;
                        _ ->
                            do_m_task(Player, MT, Times)
                    end
            end
    end.
do_m_task(Player, MT, Times) ->
    Base = data_monopoly_task:get(MT#m_task.id),
    NewTimes = min(Base#base_monopoly_task.times,MT#m_task.do_times + Times),
    State = ?IF_ELSE(NewTimes >= Base#base_monopoly_task.times, 1, 0),
    NewMT = MT#m_task{
        do_times = NewTimes,
        state = State
    },
    St = monopoly:get_dict(),
    #st_monopoly{
        task_list = TaskList
    } = St,
    NewTaskList = lists:keydelete(MT#m_task.id, #m_task.id, TaskList) ++ [NewMT],
    NewSt = St#st_monopoly{
        task_list = NewTaskList
    },
    monopoly:put_dict(NewSt),
    monopoly_load:dbup_monopoly(NewSt),
    case NewMT#m_task.state >= 1 of
        true -> monopoly:get_task_info(Player);
        false -> skip
    end,
    ok.
