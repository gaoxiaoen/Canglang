%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%  登录玩家管理
%%% @end
%%% Created : 10. 五月 2018 15:25
%%%-------------------------------------------------------------------
-module(role_manage).
-author("Administrator").

-behaviour(gen_server).
%% API
-export([start_link/0,init/1,bindsocket/1,broadcastmsg/1,check_name/2,send_roommsg/2,delete_role/1]).
-export([handle_info/2,handle_cast/2,handle_call/3,terminate/2,code_change/3,change_adm/2,enter_room/2]).

-record(clientinfo,{id,pid,socket,account,roomid=none}).
-record(roleid,{id=0}).

start_link()->
    gen_server:start_link({local,?MODULE}, ?MODULE, [],[]).

%% 创建一个ets,保存所有登录玩家的数据
init([])->
%%    生成一个唯一id生成器进程
    id_generator:start_link(),
%%    创建一个ets表保存进入房间的信息
    {ok,ets:new(clientinfo,[set,public,named_table,{keypos,#clientinfo.id}])}.


%% 根据Id开启一个客户端的进程信息，此ID可以标识为房间号id
handle_call({getpid,Id},From,State)->
    io:format(" Id = ~p ~n",[Id]),
    {ok,Pid}= role_socket:start_link(Id),
    io:format("new pid is create,~p~n",[Pid]),
    {reply,Pid,State};

%% 根据pid来删除数据
handle_call({remove_clientinfo,Ref},From,State)->
    Key=Ref#clientinfo.pid,
    ets:delete(clientinfo, Key);

handle_call({brocastmsg,Msg},From,State) ->
    Key = ets:first(clientinfo),
    io:format("feching talbe key is ~p~n",[Key]),
    sendMsg(Key,Msg),
    {reply,ok,State}.

sendMsg(Key,Msg) ->
    case ets:lookup(clientinfo,Key) of
        [Record] ->
            io:format("Record found ~p~n",[Record]),
            Pid=Record#clientinfo.pid,
            Socket = Record#clientinfo.socket,
            io:format("send smg to role_socket ~p,~p~n",[Pid,Socket]),
            Pid!{sendmsg,Msg},
            Next=ets:next(clientinfo, Key),
            sendMsg(Next,Msg);
        []->
            io:format("msg send end! ~n")
    end.

%%process messages
handle_info(Request,State)->
    {noreply,State}.

handle_cast(_From,State)->
    {noreply,State}.

terminate(_Reason,_State)->ok.

code_change(_OldVersion,State,Ext)->
    {ok,State}.


%% 绑定socket连接
bindsocket(Socket) ->
    Id=id_generator:getnewid(client),
    Pid = gen_server:call(?MODULE,{getpid,Id}),
    case gen_tcp:controlling_process(Socket,Pid) of
        {error,Reason}->
            io:format("binding socket...error~n");
        ok ->
            NewRec =#clientinfo{socket=Socket,pid=Pid,id=Id},
            put(NewRec#clientinfo.pid,NewRec),
            get(NewRec#clientinfo.pid),
            io:format("role_manage:insert record ~p~n",[NewRec]),
            ets:insert(clientinfo,NewRec),
            Pid!{bind,Socket,Id},
            io:format("clientBinded~n")
    end.

%% 玩家登录，验证玩家名是否已被注册
check_name(Id,Account) ->
    io:format("[role_mng]check role name is exist..,~p~n",[Account]),
    case ets:match_object(clientinfo, #clientinfo{account =Account,_='_'}) of
        [Record] ->
            io:format("[role_mng]name  already have,Account=~p~n",[Account]),
            [MInfo] = ets:lookup(clientinfo,Id),
            Pid = MInfo#clientinfo.pid,
            Pid!{loginok,"login failue,account already have "};
        [] ->
            ets:update_element(clientinfo,Id,{#clientinfo.account,Account}),
            io:format("[role_mng]role account update ok...Id=~p,Account=~p~n",[Id,Account]),
            [MInfo] = ets:lookup(clientinfo,Id),
            Pid = MInfo#clientinfo.pid,
            Cstr = io_lib:format("welcom ~p",[Account]),
            Pid !{loginok,Cstr}
    end.



%% 先把这个当作一个房间来处理，所有登录的玩家都是在一个房间里，发送消息
broadcastmsg(Msg) ->
    gen_server:call(?MODULE,{brocastmsg,Msg}).

%% send room msg
send_roommsg(Id,Msg) ->
    case ets:lookup(clientinfo,Id) of
        [RoleInfo] ->
            io:format("id send msg=~p,~p~n",[Msg,RoleInfo]),
            if
                RoleInfo#clientinfo.roomid==none ->
                    Pid = RoleInfo#clientinfo.pid,
                    Pid !{sendmsg,Msg};
                true ->
                    RoomId = RoleInfo#clientinfo.roomid,
                    ClientInfo = ets:tab2list(clientinfo),
                    io:format("id send msg=~p,~p,RoomId=~p,Id=~p~n",[Msg,RoleInfo,ClientInfo,Id]),
                    chatroommng:send_roommsg(RoomId,Msg)
            end
    end.

%% change adm info
change_adm(Id,Dst) ->
    case ets:lookup(clientinfo,Id) of
        [RoleInfo] ->
            io:format("[role_mng]change adm start...id=~p to change to Dst =~p~n",[Id,Dst]),
            if
                RoleInfo#clientinfo.roomid==none ->
                    Pid = RoleInfo#clientinfo.pid,
                    Pid !{sendmsg,"first to enter a room"};
                true ->
                    RoomId = RoleInfo#clientinfo.roomid,
                    chatroommng:change_adm(RoomId,Id,Dst)
            end
    end.

delete_role(Id) ->
    case ets:lookup(clientinfo,Id) of
        [RoleInfo] ->
            io:format("[role_manange]delete client,Id=~p~n",[Id]),
            ets:delete(clientinfo, Id),
            if
                RoleInfo#clientinfo.roomid==none ->
                    io:format("[role_manage]role not in room,Id=~p",Id);
                true ->
                    RoomId = RoleInfo#clientinfo.roomid,
                    chatroommng:exit_room(RoomId,Id)
            end
    end.

enter_room(Arg,Id) ->
    case ets:lookup(clientinfo,Id) of
        [RoleInfo] ->
            io:format("[role_manange]enter room Id=~p~n",[Id]),
            if
                RoleInfo#clientinfo.roomid==none ->
                    chatroommng:login_room(Arg,Id);
                true ->
                    Pid = RoleInfo#clientinfo.pid,
                    Pid!{sendmsg,"have room,dont allow enter other room"}
            end
    end.