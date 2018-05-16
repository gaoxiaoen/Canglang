%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 九月 2015 上午11:01
%%%-------------------------------------------------------------------
-module(task_rpc).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("task.hrl").

%% API
-export([handle/3]).

%%获取任务列表
handle(30001, Player, _) ->
    PackTask = task:get_task_list(Player),
    {ok, Bin} = pt_300:write(30001, {PackTask}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%触发任务
handle(30002, Player, {TaskId}) ->
    case task:accept_task(Player, TaskId) of
        {ok, Bin} ->
            {ok, Bin1} = pt_300:write(30002, {1}),
            server_send:send_to_sid(Player#player.sid, <<Bin/binary, Bin1/binary>>),
            task_event:preact_finish(TaskId, Player);
        {_, ERR} ->
            {ok, Bin1} = pt_300:write(30002, {ERR}),
            server_send:send_to_sid(Player#player.sid, Bin1)
    end,
    ok;

%%完成任务
handle(30003, Player, {TaskId}) ->
    {_state, Code, NewPlayer} = task:finish_task(Player, TaskId),
    if _state == skip ->
        {ok, NewPlayer};
        true ->
            case Code of
                {ok, NewTaskId} ->
%%                    NewPlayer1 = ?IF_ELSE(TaskId == 10280, fashion:cancel_change_body(NewPlayer), NewPlayer),
                    {ok, Bin} = pt_300:write(30003, {1, TaskId}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    %%下一任务预处理
                    task_event:preact_finish(NewTaskId, NewPlayer),
                    {ok, NewPlayer};
                ok ->
%%                    NewPlayer1 = ?IF_ELSE(TaskId == 10280, fashion:cancel_change_body(NewPlayer), NewPlayer),
                    {ok, Bin} = pt_300:write(30003, {1, TaskId}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    {ok, NewPlayer};
                _ ->
                    {ok, Bin} = pt_300:write(30003, {Code, TaskId}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok
            end
    end;

%%剧情ID
handle(30007, Player, {Type, Key, Val}) ->
    task:story(Type, Key, Val, Player#player.sid),
    ok;

%%元宝立即完成当前悬赏任务
handle(30008, Player, {_TaskId}) ->
    {Ret, NewPlayer} = task_reward:finish_now(Player),
    {ok, Bin} = pt_300:write(30008, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(30009, Player, {}) ->
    {Ret, BGold, NewPlayer} = task_bet:bet(Player),
    {ok, Bin} = pt_300:write(30009, {Ret, BGold}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%跑环完成费用
handle(30010, Player, _) ->
    Data = task_cycle:finish_cost(Player),
    {ok, Bin} = pt_300:write(30010, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;
%%一键完成跑环任务
handle(30011, Player, _) ->
    {Ret, NewPlayer} = task_cycle:finish_all(Player),
    {ok, Bin} = pt_300:write(30011, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取护送加倍时间
handle(30020, Player, _) ->
    convoy_proc:check_convoy_state(Player#player.sid),
    ok;

%%获取护送信息
handle(30021, Player, _) ->
    Data = task_convoy:convoy_info(Player),
    {ok, Bin} = pt_300:write(30021, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%刷新护送品质
handle(30022, Player, {Color, Auto}) ->
    {Ret, NewColor, NewPlayer} =
        task_convoy:refresh_color(Player, Color, Auto),
    {ok, Bin} = pt_300:write(30022, {Ret, NewColor}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, NewPlayer};
        true ->
            ok
    end;

%%开始护送
handle(30023, Player, {}) ->
    {Ret, NewPlayer} =
        task_convoy:start_convoy(Player),
    {ok, Bin} = pt_300:write(30023, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        %%重新计算速度
        NewPlayer1 = player_util:count_player_speed(NewPlayer, true),
        {ok, convoy, NewPlayer1};
        true ->
            ok
    end;

%%获取护送中信息
handle(30024, Player, {}) ->
    Data = task_convoy:convoy_msg(),
    {ok, Bin} = pt_300:write(30024, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%使用保护
handle(30025, Player, {}) ->
    {Ret, NewPlayer} = task_convoy:use_protect(Player),
    {ok, Bin} = pt_300:write(30025, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, NewPlayer};
        true ->
            ok
    end;

%%请求帮助
handle(30026, Player, {}) ->
    Ret = task_convoy:call_for_help(Player),
    {ok, Bin} = pt_300:write(30026, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%协助
handle(30027, Player, {Pkey}) when Player#player.key /= Pkey ->
    {Ret, NewPlayer} = task_convoy:helping(Player, Pkey),
    {ok, Bin} = pt_300:write(30027, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%
%%%%获取天天任务信息
%%handle(30030, Player, {}) ->
%%    Data = task_daily:task_daily(Player),
%%    {ok, Bin} = pt_300:write(30030, Data),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ok;
%%
%%%%刷新星级
%%handle(30031, Player, {Type}) ->
%%    {Ret, NewPlayer} = task_daily:refresh_task(Player, Type),
%%    AnyMaxStar = task_daily:check_max_star(),
%%    {ok, Bin} = pt_300:write(30031, {Ret, AnyMaxStar}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ?IF_ELSE(Ret == 1, handle(30030, Player, {}), ok),
%%    {ok, NewPlayer};
%%
%%%%接受任务
%%handle(30032, Player, {Tid}) ->
%%    Ret = task_daily:trigger_task(Player, Tid),
%%    {ok, Bin} = pt_300:write(30032, {Ret}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ?IF_ELSE(Ret == 1, handle(30030, Player, {}), ok),
%%    ok;
%%
%%%%元宝完成
%%handle(30033, Player, {}) ->
%%    {Ret, NewPlayer} = task_daily:finish_now(Player),
%%    {ok, Bin} = pt_300:write(30033, {Ret}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ?IF_ELSE(Ret == 1, handle(30030, Player, {}), ok),
%%    {ok, NewPlayer};
%%
%%%%任务额外奖励
%%handle(30034, Player, {}) ->
%%    {Ret, NewPlayer} = task_daily:finish_reward(Player),
%%    {ok, Bin} = pt_300:write(30034, {Ret}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ?IF_ELSE(Ret == 1, handle(30030, Player, {}), ok),
%%    {ok, NewPlayer};
%%

%%跑环完成费用
handle(30040, Player, _) ->
    Data = task_guild:finish_cost(Player),
    {ok, Bin} = pt_300:write(30040, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;
%%一键完成跑环任务
handle(30041, Player, _) ->
    {Ret, NewPlayer} = task_guild:finish_all(Player),
    {ok, Bin} = pt_300:write(30041, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%转职任务完成
handle(30043, Player, _) ->
    {Res, Career, NewPlayer} = task_change_career:change_career(Player),
    {ok, Bin} = pt_300:write(30043, {Res, Career}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, change_career, NewPlayer};

%%元宝立即完成当前转职任务
handle(30044, Player, {TaskId}) ->
    {Ret, Career, NewPlayer} = task_change_career:finish_all_task(Player, TaskId),
    {ok, Bin} = pt_300:write(30044, {Ret, Career}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, change_career, NewPlayer};

handle(_, _Player, _) ->

    ok.


