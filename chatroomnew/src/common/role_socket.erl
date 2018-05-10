%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 这个模块专门处理玩家的信息，包括，创建房间，收发消息，都走这里
%%% @end
%%% Created : 10. 五月 2018 14:34
%%%-------------------------------------------------------------------
-module(role_socket).
-author("Administrator").
-behaviour(gen_server).

%% API
-export([start_link/0,init/1]).
-export([handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

-record(roleinfo,{socket,account,name,pid}).

start_link() ->
    gen_server:start_link({local,?MODULE},?MODULE,[],[]).

init([]) ->
    State = #roleinfo{},
    {ok,State}.

handle_call(Request,From,State)->
    {reply,ok,State}.

handle_info({bind,Socket},State) ->
    io:format("client socket link server ok"),
    NewRole = #roleinfo{socket=Socket},
    io:format("NewRole info ~p~n",NewRole),
    loop(Socket),
    {noreply,NewRole};

handle_info(Request,State)->
    {noreply,State}.

handle_cast(Request,State)->
    {noreply,State}.

terminate(_Reason,State)->
    ok.

code_change(_OldVersion,State,Ext)->
    {ok,State}.


%% 接受客户端发送的消息，试试看
loop(Socket) ->
    receive
        {tcp,Socket,Bin} ->
            Str = binary_to_term(Bin),
            io:format("Server login: ~p ~n",[Str]),
            CStr = io_lib:format("welcome ~p",[Str]),
            gen_tcp:send(Socket,term_to_binary(CStr))
    end,
    loop(Socket).


