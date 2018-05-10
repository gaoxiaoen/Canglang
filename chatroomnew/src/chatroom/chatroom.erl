%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 房间信息，第一个进入的就是管理员
%%% @end
%%% Created : 10. 五月 2018 20:20
%%%-------------------------------------------------------------------
-module(chatroom).
-author("Administrator").
-behaviour(gen_server).

%% 管理员的信息
-record(adm,{pid,socket}).
-record(roleinfo,{pid}).
-record(roominfo,{id}).

%% API
-export([start_link/1,init/1]).
-export([handle_info/2,handle_cast/2,handle_call/3,terminate/2,code_change/3]).

start_link(Id)->
    gen_server:start_link({local,?MODULE}, ?MODULE, [Id],[]).

init(Id)->
%%    创建一个ets表保存进入房间的信息,保存房号
    #roominfo{id=Id},
    {ok,ets:new(roleinfo,[set,public,named_table,{keypos,#roleinfo.pid}])}.


handle_call(Request,From,State) ->
    {reply,From,State}.

%% 根据Id开启一个客户端的进程信息，此ID可以标识为房间号id
handle_info({login,Pid},From)->
    io:format("玩家Pid 进入 = ~p ~n",[Pid]),
    Size = ets:info(roleinfo,size),
    if Size =:= 0 ->
            io:format("第一个进入,set adm"),
            #adm{pid=Pid};
        ture ->
            io:format("no need adm")
    end,
%%    如果key为空，则此玩家为管理员
    NewRec =#roleinfo{pid=Pid},
    io:format("chat_room:insert record ~p~n",[NewRec]),
    ets:insert(roleinfo,NewRec),
    {reply,Pid};

%% 管理员转让管理员权限给其他玩家
handle_info({resetadm,FPid,DPid},From) ->
    if #adm.pid =:=FPid ->
            io:format("sure adm to change~n"),
            case ets:lookup(roleinfo,DPid) of
                [Record] ->
                    #adm{pid = DPid}
            end;
        true ->
            io:format("not allow resetadm ok,F:~p,D:~p~n",[FPid,DPid])
    end;
%%todo:通知客户端，管理员有改变


%% 根据pid来删除房间内的玩家
handle_info({remove_pid,Ref},From)->
    Key=Ref#roleinfo.pid,
%%     todo:通知房间内成员有成员退出
    ets:delete(roleinfo, Key);
%%    todo:if room player size is 0 then close room

%% 广播玩家信息，给这个房间里的玩家
handle_info({brocastmsg,Msg},From) ->
    Key = ets:first(roleinfo),
    io:format("feching talbe key is ~p~n",[Key]),
    sendMsg(Key,Msg),
    {reply,ok};

%% room clost notify
handle_info({closeroom},From) ->
%%    notify room play close
    Key = ets:first(roleinfo),
    sendMsg(Key,"close room").


%%process messages
handle_info(Request,State)->
    {noreply,State}.

%% 给房间内的人发消息通知
sendMsg(Key,Msg) ->
    case ets:lookup(roleinfo,Key) of
        [Record] ->
            io:format("Record found ~p~n",[Record]),
            Pid=Record#roleinfo.pid,
            io:format("send smg to role_socket ~p~n",[Pid]),
            Pid!{sendmsg,Msg},
            Next=ets:next(clientinfo, Key),
            sendMsg(Next,Msg);
        []->
            io:format("msg send end! ~n")
    end.

handle_cast(_From,State)->
    {noreply,State}.

terminate(_Reason,_State)->
    ok.

code_change(_OldVersion,State,Ext)->
    {ok,State}.

%% 先把这个当作一个房间来处理，所有登录的玩家都是在一个房间里，发送消息
%%broadcastmsg(Msg) ->
%%    gen_server:call(?MODULE,{brocastmsg,Msg}).

