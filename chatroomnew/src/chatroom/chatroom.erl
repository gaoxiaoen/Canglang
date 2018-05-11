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

%% 房间信息
-record(roominfo,{id=0,admid=none,rolelist=[]}).
-record(clientinfo,{id,pid,socket,account,roomid}).
%% API
-export([start_link/1,init/1]).
-export([handle_info/2,handle_cast/2,handle_call/3,terminate/2,code_change/3]).

start_link(Id)->
    gen_server:start_link(?MODULE, [Id],[]).

init(Id)->
%%    创建一个ets表保存进入房间的信息,保存房号
    State = #roominfo{id=Id},
    io:format("[chat_room] create room pro.Id=~p,State=~p~n",[Id,State]),
    {ok,State}.

handle_call(Request,From,State) ->
    {reply,From,State}.

dismissrole(X) ->
    ets:update_element(clientinfo,X,{#clientinfo.roomid,none}).

%% close room
handle_info({closeroom,Id},State) ->
    io:format("[chat_room]close room .id=~p~n",[Id]),
    Msg = "Note:adm have level,room dismiss",
    handle_info({brocastmsg,Msg},State),
    RoleList = State#roominfo.rolelist,
    lists:foreach(fun(X)->dismissrole(X) end,RoleList),
    {stop,normal,State};

%% 根据Id开启一个客户端的进程信息，此ID可以标识为房间号id
%% Dic 是该房间创建的字典
handle_info({enter,RoleId,RoomId},State)->
    if
        State#roominfo.rolelist == [] ->
            NewStat = State#roominfo{admid =RoleId,id = RoomId};
        true ->
            NewStat = State
    end,
    OldList = NewStat#roominfo.rolelist,
    NewList = [RoleId|OldList],
    NNewStat = NewStat#roominfo{rolelist =NewList},
    Msg = "new role comming!!",
    ets:update_element(clientinfo,RoleId,{#clientinfo.roomid,RoomId}),
    handle_info({brocastmsg,Msg},NNewStat),
    io:format("[chat_room]role enter ok ... roomid=~p,roleid=~p,newrolelist=~p,State=~p ~n",[RoomId,RoleId,NewList,NNewStat]),
    {noreply,NewStat#roominfo{rolelist =NewList}};


%% 管理员转让管理员权限给其他玩家
handle_info({changeadm,SId,DId},State) ->
    AdmId = State#roominfo.admid,
    if
        SId == AdmId ->
            io:format("[chat_room]change adm begin..SID=~p,DID=~p~n",[SId,DId]),
            RoleList = State#roominfo.rolelist,
            IsMem = lists:member(DId,RoleList),
            if
                IsMem ==true ->
                    NewStat = State#roominfo{admid = DId},
                    Msg = "Admin change",
                    handle_info({brocastmsg,Msg},NewStat),
                    RoomId = NewStat#roominfo.id,
                    AmdId = NewStat#roominfo.admid,
                    io:format("[chat_room]change adm success,roomid=~p,newAdm=~p~n",[RoomId,AmdId]);
                true ->
                    NewStat = State,
                    io:format("[chat_room]drId is not a room role,drId=~p~n",[DId])
            end;
        true ->
            NewStat = State,
            io:format("[chat_room]sid is not a admin,srId=~p~n",[SId])
    end,
    {noreply,NewStat};


%% 根据pid来删除房间内的玩家
handle_info({exit,RoleId},State)->
    RoleList = State#roominfo.rolelist,
    IsMem = lists:member(RoleId,RoleList),
%%            from list to match DId
    if
        IsMem ==true ->
            NewRoleList = lists:delete(RoleId,RoleList),
            NewStat = State#roominfo{rolelist =NewRoleList },
            ets:update_element(clientinfo,RoleId,{#clientinfo.roomid,none}),
            Msg = "Have role leavel",
            handle_info({brocastmsg,Msg},NewStat);
        true ->
            NewStat = State
    end,
    NRoleList = NewStat#roominfo.rolelist,
    io:format("[chat_room] role level ok,roleid=~p,rolelist=~p~n",[RoleId,NRoleList]),
    RoomId =NewStat#roominfo.id,
    AdmId = NewStat#roominfo.admid,
    if
        NRoleList==[] ->
            chatroommng:close_room(RoomId);
        AdmId == RoleId ->  %% 管理员离开，则整个房间关闭
            chatroommng:close_room(RoomId);
        true ->
            io:format("")
    end,
    {noreply,NewStat};



%% 广播玩家信息，给这个房间里的玩家
handle_info({brocastmsg,Msg},State) ->
    RoleList = State#roominfo.rolelist,
    lists:foreach(fun(X)->sendMsg(X,Msg) end,RoleList),
    {noreply,State};

%%process messages
handle_info(Request,State)->
    {noreply,State}.

%% 给房间内的人发消息通知
sendMsg(Key,Msg) ->
    case ets:lookup(clientinfo,Key) of
        [Record] ->
            io:format("[chat_room] send msg to key=~p~n",[Key]),
            Pid=Record#clientinfo.pid,
            Pid!{sendmsg,Msg};
        []->
            io:format("not match id=~p! ~n",[Key])
    end.

handle_cast(_From,State)->
    {noreply,State}.

terminate(_Reason,_State)->
    ok.

code_change(_OldVersion,State,Ext)->
    {ok,State}.


