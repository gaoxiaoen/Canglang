%% Description:
%% 创建一个房间，
%% 1.房间里需要设置管理员，
%% 2，需要其他玩家可以进入房间
%% 3.房间内成员发言，可以广播给所有进入房间内的成员
%% 4.管理员可以禅位给其他房间内成员
%% 5.房间内最后一个成员离开，销毁房间

-module(chat_room).
-behaviour(gen_server).

-record(state,{}).

-record(clientinfo,{id,socket,pid}).
-record(message,{type,from,content}).


-export([start_link/0,init/1,getPid/0,bindPid/2,broadCastMsg/1,logout/1]).
-export([handle_call/3,handle_info/2,handle_cast/2,code_change/3,terminate/2]).


start_link()->
    gen_server:start_link({local,?MODULE}, ?MODULE, [],[]).

%% 创建一个ets,保存房间内的玩家数据
init([])->
%%    io:format("client = ~p~n",[#clientinfo]),
%%    id_generator:start_link(),
%%    创建一个ets表保存进入房间的信息
    ets:new(clientinfo,  %% 原子，通过原子来来判断表存不存在
        [
            public,  %% 创建一个公共表，任何知道此表进程的都能读取和写入
            ordered_set   %% 有序异键
        ]
    ),
    {ok,#state{}}
.

%% 根据Id开启一个客户端的进程信息，此ID可以标识为房间号id
handle_call({getpid,Id},From,State)->
    {ok,Pid}= client_session:start_link(),
    {reply,Pid,State};

handle_call({remove_clientinfo,Ref},From,State)->
    Key=Ref#clientinfo.id,
    ets:delete(clientinfo, Key)

%% todo:如果房间里面没有人了，则关闭整个房间进程
;
handle_call({sendmsg,Msg},From,State)->
    Key=ets:first(clientinfo),
    io:format("feching talbe key is ~p~n",[Key]),
    sendMsg(Key,Msg),
    {reply,ok,State}
.

%%process messages
handle_info(Request,State)->
    {noreply,State}.

handle_cast(_From,State)->
    {noreply,State}.

terminate(_Reason,_State)->
    ok.

code_change(_OldVersion,State,Ext)->
    {ok,State}.

%% 获取服务器开的客户端连接进程pid
getPid()->
    Pid=gen_server:call(?MODULE,{getpid}),
    io:format("generated new client socket ~n"),
    #clientinfo{pid=Pid}
.

%%绑定新的连接
bindPid(Record,Socket)->
    io:format("binding socket...~n"),
    case gen_tcp:controlling_process(Socket, Record#clientinfo.pid) of
        {error,Reason}->
            io:format("binding socket...error~n");
        ok ->
            NewRec =#clientinfo{socket=Socket,pid=Record#clientinfo.pid},
            io:format("chat_room:insert record ~p~n",[NewRec]),
            ets:insert(clientinfo, NewRec),
            Pid=Record#clientinfo.pid,
            Pid!{bind,Socket},
            io:format("clientBinded~n")
    end
.

%% 广播消息
broadCastMsg(Msg)->
    gen_server:call(?MODULE, {sendmsg,Msg}).

%% 广播给房间里的所有人消息
sendMsg(Key,Msg)->
    case ets:lookup(clientinfo, Key)of
        [Record]->   %% 返回信息
            io:format("Record found ~p~n",[Record]),
            Pid=Record#clientinfo.pid,
            %while send down we change msg type to dwmsg
            io:format("send smg to client_session ~p~n",[Pid]),
            Pid!{dwmsg,Msg},
            Next=ets:next(clientinfo, Key),
            sendMsg(Next,Msg);
        []->
            io:format("no clientinfo found~n")
    end;
sendMsg([],Msg)->
    ok.

%% 返回所有连接到该房间的人员名单
getMembers(From)->
    ok.

%% 有人退出房间
logout(Ref)->
    gen_server:call(?MODULE, {remove_clientinfo,Ref}),
    ok.