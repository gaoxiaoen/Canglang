%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 八月 2017 14:02
%%%-------------------------------------------------------------------
-module(task_change_career).
-author("Administrator").
-include("task.hrl").
-include("common.hrl").
-include("server.hrl").
-include("awake.hrl").

%% API
-export([
    init/1,
    dbget_change_career/1,
    finish_task/2,
    dbup_change_career/1,
    change_career/1,
    get_career_attribute/1,
    finish_all_task/2,
    get_state/1,
    gm_notice/1
]).

init(Player) ->
    case dbget_change_career(Player#player.key) of
        [] ->
            lib_dict:put(?PROC_STATUS_TASK_CHANGE_CAREER, #st_change_career{pkey = Player#player.key});
        [Career, IsCareer] ->
            lib_dict:put(?PROC_STATUS_TASK_CHANGE_CAREER, #st_change_career{pkey = Player#player.key, new_career = Career, is_career = IsCareer})
    end,
    Player.

finish_task(Player, Task) ->
    if
        Task#task.next == 0 ->
            F = fun(Extra) ->
                case Extra of
                    {career, Career0} -> [Career0];
                    _ ->
                        []
                end
            end,
            List = lists:flatmap(F, Task#task.extra),
            case List of
                [Career] ->
                    St = lib_dict:get(?PROC_STATUS_TASK_CHANGE_CAREER),
                    NewSt = St#st_change_career{new_career = Career, is_career = 1},
                    lib_dict:put(?PROC_STATUS_TASK_CHANGE_CAREER, NewSt),
                    dbup_change_career(NewSt),
                    activity:get_notice(Player, [147], true),
%%                     task:auto_accept_task(Player),
                    %% 转职完成
                    Player;
                _ ->
                    ?ERR("task_change_career 'extra' err !! extra: ~p~n", [Task#task.extra]),
                    Player
            end;
        true -> Player
    end.

change_career(Player) ->
    St = lib_dict:get(?PROC_STATUS_TASK_CHANGE_CAREER),
    if
        St#st_change_career.is_career == 0 -> {0, St#st_change_career.new_career, Player};
        true ->
            NewSt = St#st_change_career{is_career = 0},
            lib_dict:put(?PROC_STATUS_TASK_CHANGE_CAREER, NewSt),
            dbup_change_career(NewSt),
            Reward = data_change_career:get_reward(St#st_change_career.new_career),
            {ok, NewPlayer00} = goods:give_goods(Player, goods:make_give_goods_list(535, Reward)),
            NewPlayer0 = NewPlayer00#player{new_career = St#st_change_career.new_career},
            NewPlayer1 = player_util:count_player_attribute(NewPlayer0, true),
            player_load:dbup_player_new_career(NewPlayer1),
            {ok, Bin} = pt_130:write(13001, player_pack:trans13001(NewPlayer1)),
            server_send:send_to_sid(Player#player.sid, Bin),
            Career = St#st_change_career.new_career,
            data_change_career:get(Career),
            Content = io_lib:format(t_tv:get(256), [t_tv:pn(Player), t_tv:cl(get_career_name(Player#player.sex, Career), 11)]),
            notice:add_sys_notice(Content, 256),
            task:auto_accept_task(NewPlayer1),
            activity:sys_notice([147], Player),
            {1, St#st_change_career.new_career, NewPlayer1}
    end.

get_career_attribute(Player) ->
    Career = Player#player.new_career,
    data_change_career:get(Career).


get_state(Player) ->
    StTask = task_init:get_task_st(),
    Activelist = StTask#st_task.activelist,
    St = lib_dict:get(?PROC_STATUS_TASK_CHANGE_CAREER),
    F = fun(Id) ->
        case lists:keyfind(Id, #task.taskid, Activelist) of
            false -> false;
            _Task ->
                true
        end
    end,
    Flag = lists:any(F, data_task_change_career:task_ids()),
    if
        St#st_change_career.is_career =/= 0 -> 1;
        Flag -> 0;
        true ->
            MaxType = lists:max(data_awake:get_all_type()),
            StAwake = lib_dict:get(?PROC_STATUS_AWAKE),
            if
                StAwake#st_awake.type < MaxType andalso St#st_change_career.new_career >= 3 ->
                    case player_awake:check_up_type_awake(Player) of
                         ok ->1;
                        _ -> 0
                    end;
                true ->
                    -1
            end
    end.

%%一键完成任务
finish_all_task(Player, TaskId) ->
    StTask = task_init:get_task_st(),
    ActiveList = StTask#st_task.activelist,
    LogList = StTask#st_task.loglist,
    case lists:keyfind(TaskId, #task.taskid, ActiveList) of
        false ->
            {7, 0, Player};
        Task ->
            case lists:keyfind(career, 1, Task#task.extra) of
                false ->
                    ?DEBUG("not is change career  task !! talkid : ~p ~n", [Task#task.talkid]),
                    {0, 0, Player};
                {career, Career} ->
                    case money:is_enough(Player, Task#task.finish_price, gold) of
                        false -> {10, 0, Player};
                        true ->
                            task:del_task_by_type(?TASK_TYPE_CHARGE_CRAEER, Player#player.sid),
                            ActiveList2 = lists:keydelete(TaskId, #task.taskid, ActiveList),
                            task:refresh_client_del_task(Player#player.sid, TaskId),
                            LogList2 = finish_task_help(Task, LogList),
                            NewStTask = StTask#st_task{activelist = ActiveList2, loglist = LogList2},
                            task_init:set_task_st(NewStTask),
                            St = lib_dict:get(?PROC_STATUS_TASK_CHANGE_CAREER),
                            NewSt = St#st_change_career{is_career = 1, new_career = Career},
                            lib_dict:put(?PROC_STATUS_TASK_CHANGE_CAREER, NewSt),
                            dbup_change_career(NewSt),
                            NewPlayer = money:add_no_bind_gold(Player, -Task#task.finish_price, 534, 0, 0),
                            {Res, Career, NewPlayer1} = change_career(NewPlayer),
                            activity:sys_notice([147], NewPlayer1),
                            task:refresh_task(NewPlayer1),
                            {Res, Career, NewPlayer1}
                    end
            end
    end.

finish_task_help(Task, LogList) ->
    case data_task_change_career:get(Task#task.next) of
        [] ->
            [Task#task.taskid | LogList];
        Task0 ->
            finish_task_help(Task0, [Task#task.taskid | LogList])
    end.

dbget_change_career(Pkey) ->
    Sql = io_lib:format("select career,is_career from player_change_career where pkey=~p", [Pkey]),
    db:get_row(Sql).

dbup_change_career(#st_change_career{new_career = Career, is_career = IsCareer, pkey = Pkey}) ->
    Sql = io_lib:format("replace into player_change_career set pkey=~p,  career=~p, is_career=~p",
        [Pkey, Career, IsCareer]),
    db:execute(Sql),
    ok.

gm_reset_task() ->

    ok.

%%
%% %%刷新任务
%% refresh_task(Player, IsNotice) ->
%%     case task:get_task_by_type(?TASK_TYPE_BET) of
%%         [] ->
%%             check_task(Player, IsNotice);
%%         [Task | _] ->
%%             task:del_task_by_type(?TASK_TYPE_BET, Player#player.sid),
%%             check_task(Player, IsNotice)
%%     end.
%%
%%


gm_notice(Player) ->
    Content = io_lib:format(t_tv:get(256), [t_tv:pn(Player), get_career_name(Player#player.sex, 2)]),
    notice:add_sys_notice(Content, 256), ok.

get_career_name(1, 0) -> ?T("赤火剑者");
get_career_name(1, 2) -> ?T("星罗剑君");
get_career_name(1, 3) -> ?T("夺日剑君");
get_career_name(1, 4) -> ?T("诛仙剑主");
get_career_name(1, 5) -> ?T("天玄真君");
get_career_name(2, 0) -> ?T("苍冰剑姬");
get_career_name(2, 2) -> ?T("霜火剑姬");
get_career_name(2, 3) -> ?T("玄凰仙子");
get_career_name(2, 4) -> ?T("广寒仙子");
get_career_name(2, 5) -> ?T("紫薇星君");
get_career_name(_, _) -> ?T("").