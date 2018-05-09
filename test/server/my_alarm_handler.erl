%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 五月 2018 13:51
%%%-------------------------------------------------------------------
-module(my_alarm_handler).
-author("Administrator").
-behaviour(gen_event).

%% API
-export([init/1,handle_event/2,handle_call/2,handle_info/2,code_change/3,terminate/2]).

%% init(Args)必须返回{ok，state}
init(Args) ->
    io:format("*** my_alarm_handler init:~p~n",[Args]).

handle_event({set_alarm,tooHot},N) ->
    error_logger:error_msg("*** tell the Enginer to turn on the fan ~n"),
    {ok,N+1};
handle_event({clear_alarm,tooHot},N) ->
    error_logger:error_msg("*** Danger over.Turn off the fan ~n"),
    {ok,N};
handle_event(Event,N) ->
    io:format("*** unmatched event:~p~n",[Event]),
    {ok,N}.


handle_call(_Request,N) ->
    Reply = N,{ok,Reply,N}.

handle_info(_Info,N) -> {ok,N}.

terminate(_Reason,_N) ->ok.

code_change(_OldVsn,State,_Extra) ->{ok,State}.




