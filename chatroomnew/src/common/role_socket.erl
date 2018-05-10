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
-export([start_link/1,init/1]).
-export([handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

-record(clientinfo,{socket,account,id}).

start_link(Id) ->
    gen_server:start_link(?MODULE,[Id],[]).

init(Id) ->
    State = #clientinfo{id=Id},
    {ok,State}.

handle_call(Request,From,State)->
    {reply,ok,State}.

handle_info({bind,Socket},State) ->
    io:format("client socket link server ok~n"),
    NewRole = #clientinfo{socket=Socket},
    io:format("NewRole info ~p~n",[NewRole]),
    loop(Socket),
    {noreply,NewRole};

%% 发送全房间消息到各个房间内的客户端
handle_info({sendmsg,Msg,Socket},State) ->
    Str = binary_to_term(Msg),
    io:format("Server sendmsg: ~p ~p ~n",[Str,Socket]),
    CStr = Socket ++ ":welcome：" ++ [Str],
    gen_tcp:send(Socket,term_to_binary(CStr));

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
            io:format("[~p]say: ~p ~n",[Socket,Str]),
            CStr =io_lib:format("[~p]say: ~p ",[Socket,Str]),
            role_manage:broadcastmsg(CStr);
        {sendmsg,Msg} ->
%%            io:format("Server_loop sendmsg: ~p ~p ~n",[Socket,Msg]),
%%            CStr =io_lib:format("[~p]welcome:~p",[Socket,Msg]),
            gen_tcp:send(Socket,term_to_binary(Msg));
        {tcp_closed,Socket} ->
            io:format("client close")
    end,
    loop(Socket).


