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

handle_info({bind,Socket,Id},State) ->
    io:format("client socket link server ok~n"),
    NewRole = #clientinfo{socket=Socket,id = Id},
    io:format("NewRole info ~p~n",[NewRole]),
    loop(Socket,Id),
    {noreply,NewRole};

%% 发送全房间消息到各个房间内的客户端
handle_info({stop},State) ->
    {stop,normal,State};


handle_info(Request,State)->
    {noreply,State}.

handle_cast(Request,State)->
    {noreply,State}.

terminate(_Reason,State)->

    ok.

code_change(_OldVersion,State,Ext)->
    {ok,State}.


%% 接受客户端发送的消息，试试看
loop(Socket,Id) ->
    receive
        {tcp,Socket,Bin} ->
            packmsg(Bin,Id);
        {sendmsg,Msg} ->
            gen_tcp:send(Socket,term_to_binary(Msg));
%%        登录成功
        {loginok,Msg} ->
            gen_tcp:send(Socket,term_to_binary(Msg));
        {tcp_closed,Socket} ->
            io:format("client close"),
            role_manage:delete_role(Id)

    end,
    loop(Socket,Id).

%% 处理消息包处理
packmsg(Bin,Id) ->
    [CType, Arg] = binary_to_term(Bin),
    if CType == "login" ->
            role_manage:check_name(Id,Arg);
        CType == "msg" ->
            io:format("pack,msg Id=~p~n",[Id]),
            role_manage:send_roommsg(Id,Arg);
        CType == "room" ->  %% 开启一个房间
%%            IntId = list_to_integer(Id),
            io:format("[role_socket] create room Id=~p,roomId=~p~n",[Id,Arg]),
            role_manage:enter_room(Arg,Id);
        CType == "adm" ->
            io:format("[role_socket] change adm start  ... srID=~p,DId=~p~n",[Id,Arg]),
%%            DId = list_to_integer(Arg),
            role_manage:change_adm(Id,Arg);
        true ->
            io:format("Can't not parse msg...Arg=~p,CType=~p~n",CType,Arg)
    end.



