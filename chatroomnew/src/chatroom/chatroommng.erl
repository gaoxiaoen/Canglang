%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 聊天房间管理
%%% @end
%%% Created : 11. 五月 2018 12:44
%%%-------------------------------------------------------------------
-module(chatroommng).
-author("Administrator").

-behaviour(gen_server).
%% API
-export([start_link/0,init/1,create_chatroom/1,login_room/2,exit_room/2,close_room/1,change_adm/3]).
-export([handle_info/2,handle_cast/2,handle_call/3,terminate/2,code_change/3,send_roommsg/2]).

-record(chatroom,{id,pid}).

start_link()->
    gen_server:start_link({local,?MODULE}, ?MODULE, [],[]).

%% 创建一个ets,保存所有登录玩家的数据
init([])->
%%    创建一个ets表保存进入房间的信息
    {ok,ets:new(chatroom,[set,public,named_table,{keypos,#chatroom.id}])}.


%% 根据Id开启一个客户端的进程信息，此ID可以标识为房间号id
handle_call({getpid,Id},From,State)->
    {ok,Pid}= chatroom:start_link(Id),
    io:format("[chat_mng]chat room create.ok Id =~p,Pid=~p ~n",[Id,Pid]),
    {reply,Pid,State};

%% 根据pid来删除数据
handle_call({remove_chatroom,Ref},From,State)->
    Key=Ref#chatroom.id,
    ets:delete(clientinfo, Key);

%% 房间内群发消息
handle_call({brocastmsg,id,Msg},From,State) ->
    [Record] = ets:lookup(chatroom,id),
    Pid = Record#chatroom.pid,
    Pid!{sendmsg,Msg},
    {reply,ok,State}.

%%process messages
handle_info(Request,State)->
    {noreply,State}.

handle_cast(_From,State)->
    {noreply,State}.

terminate(_Reason,_State)->ok.

code_change(_OldVersion,State,Ext)->
    {ok,State}.


%% 创建一个房间,玩家发送的id为房号id
create_chatroom(Id) ->
    Pid = gen_server:call(?MODULE,{getpid,Id}),
    NewRec =#chatroom{pid=Pid,id=Id},
    ets:insert(chatroom,NewRec),
    io:format("[chat_mng]creat room ok! pid=~p,Id=~p~n",[Pid,Id]).

%% 玩家进入房间
login_room(Id,RoleId) ->
    case ets:lookup(chatroom,Id) of
        [Record] ->
            Pid = Record#chatroom.pid,
            Pid !{enter,RoleId,Id},
            io:format("[chat_mng]loign room ok.Roleid=~p,roomId=~p~n",[RoleId,Id]);
        [] ->
            io:format("[chat_mng] creat room start.....Id=~p~n",[Id]),
            create_chatroom(Id),
            login_room(Id,RoleId)
    end.

%% 退出房间
exit_room(Id,RoleId) ->
    case ets:lookup(chatroom,Id) of
        [Record] ->
            Pid = Record#chatroom.pid,
            io:format("[chat_mng] role exit room ,id=~p,roleid~p",[Id,RoleId]),
            Pid !{exit,RoleId}
    end.

%% 关闭房间
close_room(Id) ->
    case ets:lookup(chatroom,Id) of
        [Record] ->
            Pid = Record#chatroom.pid,
            Pid !{closeroom,Id},
            ets:delete(chatroom,Id)
    end.

%% 转让管理员
change_adm(Id,SRoleID,DRoleID) ->
    case ets:lookup(chatroom,Id) of
        [Record] ->
            io:format("[chat_mng]change adm start....,roomId=~p,srId=~p,drId=~p",[Id,SRoleID,DRoleID]),
            Pid = Record#chatroom.pid,
            Pid !{changeadm,SRoleID,DRoleID}
    end.


send_roommsg(Id,Msg) ->
    io:format("roomid=~p,Msg=~p~n",[Id,Msg]),
    Chatroom = ets:tab2list(chatroom),
    io:format("chatroom=~p~n",[Chatroom]),
    case ets:lookup(chatroom,Id) of
        [Record] ->
            Pid = Record#chatroom.pid,
            Pid !{brocastmsg,Msg}
    end.
