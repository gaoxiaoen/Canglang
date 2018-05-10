%% Description:
%% 1.客户端进程，保留客户端进程的数据
%% 2.客户端连接的唯一地方，该客户端连接的房间号和其他的信息
-module(client_session).
-behavior(gen_server).

-record(clientinfo,{pid,socket}).
-record(message,{type,from,content}).

-export([init/1,start_link/0,handle_info/2,handle_call/3,terminate/2,handle_cast/2,code_change/3]).
-export([process_msg/1]).
%%
%% API Functions
%%
start_link()->
    gen_server:start_link({local,?MODULE}, ?MODULE, [],[])
.

%% 创建的id应该是该客户端的pid信息
init([])->
    State=#clientinfo{},
    {ok,State}.

%% 发送给房间内的所有玩家，该房间内有玩家发言了
%% State 是一个 clientinfo 的记录
handle_info({dwmsg,Message},State)->
    io:format("client_session dwmsg recived ~p~n",[Message]),
    case gen_tcp:send(State#clientinfo.socket, Message#message.content)of
        ok->
            io:format("client_session dwmsg sended ~n");
        {error,Reason}->
            io:format("client_session dwmsg sended error ~p ~n",Reason)
    end,
    {noreply,State};

%%handle 绑定客户端的连接信息
handle_info({bind,Socket},State)->
    io:format("client_session bind socket ~n"),
    NewState=State#clientinfo{socket=Socket},
    io:format("NewState ~p~n",[NewState]),
    {noreply,NewState};

%%to 接收到有房间的人说话了，广播该人的消息到所有房间内的人
handle_info({tcp,Socket,Data},State)->
    io:format("client_session tcp data recived ~p~n",[Data]),
    NewMsg=#message{type=msg,from=State#clientinfo.socket,content=Data},
    chat_room:broadCastMsg(NewMsg),
    {noreply,State};

%% tcp退出，断掉了tcp连接
handle_info({tcp_closed,Socket},State)->
    chat_room:logout(State);

%%
handle_info(Request,State)->
    io:format("client_session handle else ~p~n",[Request]),
    {noreply,State}
.

handle_call(Request,From,State)->
    {reply,ok,State}.

handle_cast(Request,State)->
    {noreply,State}.

terminate(_Reason,State)->
    ok.

code_change(_OldVersion,State,Ext)->
    {ok,State}.

%%
%% 循环函数，接受来自客户端的消息
%%
process_msg(State)->
    io:format("client_session:process_msg SOCKET:~p ~n",[State#clientinfo.socket]),
    case gen_tcp:recv(State#clientinfo.socket, 0) of
        {ok,Message}->
            io:format("recived ~p ~n",[Message]),
            %io:format("msg recived ~p~n",[Message]),
            NewMsg=#message{type=msg,from=State#clientinfo.socket,content=Message},
            chat_room:broadCastMsg(NewMsg),
            process_msg(State);
        {error,closed}->
            io:format("client_session:recive error ~n"),
            process_msg(State);
        Any->
            io:format("client_session:recive any ~n"),
            process_msg(State)
    end
.

