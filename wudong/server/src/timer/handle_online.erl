%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2015 18:20
%%%-------------------------------------------------------------------
-module(handle_online).
-author("fzl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    init/0,
    handle/2,
    cm/0,
    online_apply/3,
    online_apply_state/3,
    online_send_info/1
]).

init() ->
    {ok, ok}.

handle(State, Time) ->
    spawn(fun() -> check_mem() end),
    spawn(fun() -> save_online() end),
    spawn(fun() -> online_gift:check_get_online_gift(Time) end),
    spawn(fun() -> cross_boss:update_online() end),
    spawn(fun() -> act_open_info:time() end),
    spawn(fun() ->
        case config:is_debug() of
            true ->
                cross_war_repair:timer();
            false ->
                skip
        end
          end),
    {ok, State}.

save_online() ->
    case config:is_center_node() of
        false ->
            player_util:check_player_online(),
            Now = util:unixtime(),
            Size = ets:info(?ETS_ONLINE, size),
            Sql = io_lib:format("insert into online set num=~p,time=~p", [Size, Now]),
            db:execute(Sql);
        _ ->
            skip
    end.



cm() ->
    spawn(fun() ->
        timer:sleep(util:rand(1, 10) * 1000),
        check_mem(1000000)
          end).

%% 检查内存消耗
%% 默认设置凌晨4点查一次
%% 内存大于5M做一次手动gc
check_mem() ->
    {_, {_H, I, _S}} = erlang:localtime(),
%%    ?DO_IF(config:is_center_node() andalso I rem 30 == 0 andalso version:get_lan_config() == chn, tool:gc()),
    case I rem 50 =:= 0 of
        true ->
            timer:sleep(util:rand(1, 10) * 1000),
            check_mem(1000000);
        false ->
            skip
    end,
    ok.

%% 检查溢出的内存，强制gc
check_mem(MemLim) ->
    lists:foreach(
        fun(P) ->
            case is_pid(P) andalso is_process_alive(P) of
                true ->
                    case erlang:process_info(P, memory) of
                        {memory, Mem} ->
                            case Mem > MemLim of
                                true ->
                                    erlang:garbage_collect(P);
                                false ->
                                    []
                            end;
                        _ -> []
                    end;
                false ->
                    []
            end
        end, erlang:processes()).

%%给每个在线的玩家发送cast消息，调用Module:Fun(Args)
online_apply(Module, Fun, Args) ->
    Pids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
    Len = length(Pids) div 50 + 1,
    F = fun(N) ->
        timer:sleep(2000),
        Star = 50 * (N - 1) + 1,
        Ps = lists:sublist(Pids, Star, 50),
        F = fun([P]) ->
            P ! {apply, {Module, Fun, Args}}
            end,
        [F(Pid) || Pid <- Ps]
        end,
    spawn(fun() -> lists:foreach(F, lists:seq(1, Len)) end).

%%给每个在线的玩家发送cast消息，调用Module:Fun(Args,PlayerState)
online_apply_state(Module, Fun, Args) ->
    Pids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
    Len = length(Pids) div 50 + 1,
    F = fun(N) ->
        timer:sleep(2000),
        Star = 50 * (N - 1) + 1,
        Ps = lists:sublist(Pids, Star, 50),
        F = fun([P]) ->
            P ! {apply_state, {Module, Fun, Args}}
            end,
        [F(Pid) || Pid <- Ps]
        end,
    spawn(fun() -> lists:foreach(F, lists:seq(1, Len)) end).


%%给每个在线玩家发送info信息
online_send_info(Info) ->
    Pids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
    F = fun([P]) ->
        P ! Info
        end,
    [F(Pid) || Pid <- Pids].
