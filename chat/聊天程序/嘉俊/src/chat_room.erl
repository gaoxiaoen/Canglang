-module(chat_room).
-behaviour(gen_server).

-include("clientinfo.hrl").
-include("proto.hrl").
-include("chatroomstatus.hrl").

-export([start_link/0,init/1,newClient/0,bindPid/2]).
-export([handle_call/3,handle_info/2,handle_cast/2,code_change/3,terminate/2]).

%%
%% API Functions
%%
start_link()->
    gen_server:start_link({local,?MODULE}, ?MODULE, [],[]),

    %% 记录成功登录的玩家信息
    ets:new(clientinfo,[public, ordered_set, named_table, {keypos,#clientinfo.id}]),

    %% 连接数据库
    mysql:start_link(pollId, "localhost", "root", "root", "chatserver"),
    mysql:connect(pollId, "localhost", undefined, "root", "root", "chatserver", true).

init([])->
    {ok, #chatroomstatus{}}.

%% chat_room通知新建玩家进程
handle_call({newclient, Id}, _From, State)->
    {ok, Pid} = client_handler:start_link(Id),
    {reply, Pid, State};


%% 处理玩家新建房间请求
handle_call({create_room, #proto{id = PlyId}}, _From, State) ->
    Name = mod_room:get_name_by_id(PlyId),
    case mod_room:create_room({PlyId, Name}, State) of
        {ok, Ret, NewState} ->
            {reply, Ret, NewState};
        {error, Reason} ->
            {reply, Reason, State}
    end;


%% 处理玩家关闭房间请求
handle_call({close_room, #proto{id = PlyId}}, _From, State) ->
    case mod_room:close_room(PlyId, State) of
        {ok, Ret, NewState} ->
            {reply, Ret, NewState};
        {error, Reason} ->
            {reply, Reason, State}
    end;

%% 处理玩家获取房间列表请求
handle_call({get_room_list, #proto{id = PlyId}}, _From, State) ->
    case mod_room:get_room_list(PlyId, State) of
        {ok, RoomInfo} ->
            {reply, RoomInfo, State};
        {error, Reason} ->
            {reply, Reason, State}
    end;

%% 处理玩家加入房间列表请求
handle_call({join_room, #proto{id = PlyId, data = [RoomId | _]}}, _From, State) ->
    case mod_room:join_room({PlyId, RoomId}, State) of
        {ok, Ret, NewState} ->
            {reply, Ret, NewState};
        {error, Reason} ->
            {reply, Reason, State}
    end;

%% 处理玩家转移管理权限
handle_call({transform_admin, #proto{id = PlyId}}, _From, State) ->
    case mod_room:transform_admin(PlyId, State) of
        {ok, Ret, NewState} ->
            {reply, Ret, NewState};
        {error, Reason} ->
            {reply, Reason, State}
    end;

%% 处理玩家发送聊天消息请求
handle_call({chat, #proto{id = PlyId, data = Content}}, _From, State) ->
    case mod_room:chat({PlyId, Content}, State) of
        {ok, Ret} ->
            {reply, Ret, State};
        {error, Reason} ->
            {reply, Reason, State}
    end;


%% 处理玩家登录验证
handle_call({login, #proto{id = Id, data = Data}}, _From, State) ->
    [Name, PassWd] = Data,
    case mod_db:verify(Name, PassWd) of
        ok ->
            ets:update_element(clientinfo, Id, {#clientinfo.name, Name}),
            {reply, ok, State};
        _Other ->
            {reply, "name or passwd error", State}
    end;


%% 处理玩家注册
handle_call({register, #proto{id = Id, data = Data}}, _From, State) ->
    [Name, PassWd] = Data,
    case mod_db:register(Name, PassWd) of
        ok ->
            ets:update_element(clientinfo, Id, {#clientinfo.name, Name}),
            {reply, ok, State};
        _Other ->
            {reply, "username exist", State}
    end;

%% 处理玩家离开房间请求
handle_call({leave_room, #proto{id = PlyId}}, _From, State) ->
    case mod_room:leave_room(PlyId, State) of
        {ok, Ret, NewState} ->
            {reply, Ret, NewState};
        {error, Reason} ->
            {reply, Reason, State}
    end;

handle_call(_Request, _From, State) ->
    {reply, ok, State}.


handle_cast({offline, #proto{id = PlyId}}, State)->
    case mod_room:leave_room(PlyId, State) of
        {ok, _Ret, NewState} ->
            {noreply, NewState};
        {error, _Reason} ->
            {noreply, State}
    end;

handle_cast(_From,State)->
    {noreply,State}.


%% 新建客户端进程
newClient()->
    Id = random:uniform(10000),
    Pid = gen_server:call(?MODULE, {newclient, Id}),
    io:format("id generated ~w~n",[Id]),
    #clientinfo{id = Id, pid = Pid}.


%% 将Socket绑定到玩家进程,后面就直接由玩家进程负责收发消息
bindPid(Record, Socket)->
    case gen_tcp:controlling_process(Socket, Record#clientinfo.pid) of
        {error, Reason}->
            io:format("binding socket error. reason:~p~n", [Reason]);
        ok ->
            %% 加入到ets表
            NewRec =#clientinfo{id=Record#clientinfo.id,socket=Socket,pid=Record#clientinfo.pid},
            ets:insert(clientinfo, NewRec),
            %% 更新玩家进程Socket信息
            Pid = Record#clientinfo.pid,
            Pid ! {bind, Socket},
            io:format("clientBinded~n")
    end.



handle_info(_Request,State)->
    {noreply,State}.

terminate(_Reason,_State)->
    ok.

code_change(_OldVersion,State,_Ext)->
    {ok,State}.
