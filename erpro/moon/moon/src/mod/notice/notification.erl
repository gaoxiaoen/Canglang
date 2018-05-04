%%----------------------------------------------------
%% 弹出式消息通知（在线+离线） 
%%
%% @author qingxuan
%%----------------------------------------------------
-module(notification).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([start_link/0]).
-export([
    load/1
    ,login/1
    ,send/3
    ,send/5
    ,send/6
    %,read/2
    ,get_list/0
]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("notification.hrl").

-record(state, {}).

%% --------------------------
%read(#role{link=#link{conn_pid = ConnPid}}, Id) ->
%    case erase({?MODULE, Id}) of
%        undefined -> ignore;
%        {Type, Msg, Args, _Expire, _OnlineOrOffline} ->
%            sys_conn:pack_send(ConnPid, 11152, {Type, Msg, Args})
%    end.

send(OnLineOrOffline, ToWho, #notification{type=Type, msg=Msg, args=Args}) ->
    send(OnLineOrOffline, ToWho, Type, Msg, Args).

%% @spec send(OnLineOrOffline, ToWho, Type, Msg, Args) -> any()
%% OnLineOrOffline = online | offline
%% ToWho = RolePid::pid() | {RoleId, SrvId}
%% Type = int()
%% Msg = binary()
%% Args = [int()]
send(OnLineOrOffline, ToWho, Type, Msg, Args) ->
    send(OnLineOrOffline, ToWho, Type, Msg, Args, 0).

send(online, {RoleId, SrvId}, Type, Msg, Args, Expire) ->
    case role_api:get_pid({RoleId, SrvId}) of
        undefined -> ignore;
        RolePid -> send(online, RolePid, Type, Msg, Args, Expire)
    end;
send(online, RolePid, Type, Msg, Args, Expire) ->
    Id = counter:next(?MODULE),
    role:apply(async, RolePid, {fun recv/6, [Id, Type, Msg, Args, Expire]});
    
send(offline, {RoleId, SrvId}, Type, Msg, Args, Expire) ->
    case role_api:get_pid({RoleId, SrvId}) of
        undefined -> send_to_db({RoleId, SrvId}, Type, Msg, Args, Expire);
        RolePid -> send(online, RolePid, Type, Msg, Args, Expire)
    end.
 
send_to_db({RoleId, SrvId}, Type, Msg, Args, Expire) ->
    Id = counter:next(?MODULE),
    db:execute("INSERT INTO `role_notification` (`id`, `role_id`, `srv_id`, `type`, `msg`, `args`, `expire`, `ctime`, `read`) VALUES (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)", [Id, RoleId, SrvId, Type, Msg, util:term_to_bitstring({Args}), Expire, util:unixtime(), 0]).

%% 加载到进程
load(Role = #role{id = {RoleId, SrvId}}) ->
    Now = util:unixtime(),
    case db:get_all("SELECT `id`, `type`, `msg`, `args`, `expire` FROM `role_notification` WHERE `role_id`=~s AND `srv_id`=~s AND `read`=0 AND (`expire`>~s OR `expire`=0)", [RoleId, SrvId, Now]) of
        {ok, L} ->
            Ids = lists:map(fun([Id, Type, Msg, Args0, Expire]) ->
                Args = case util:bitstring_to_term(Args0) of
                    {Args1} -> Args1; 
                    _ -> []
                end,
                put({?MODULE, Id}, {Type, Msg, Args, Expire, offline}), 
                Id
            end, L),
            put(?MODULE, Ids);
        _ ->
            ok
    end,
    Role.

%% 登录通知
login(Role = #role{id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}}) ->
    load(Role),
    case get(?MODULE) of
        undefined -> ignore;
        [] -> ignore;
        _L ->
            % Data = [ begin {Type, _Msg, _Args, _Expire, _Offline} = get({?MODULE, Id}), [Id, Type] end || Id <- L ],
            db:execute("UPDATE `role_notification` SET `read`=1 WHERE `role_id`=~s AND `srv_id`=~s", [RoleId, SrvId]),
            % sys_conn:pack_send(ConnPid, 11150, {Data})
            sys_conn:pack_send(ConnPid, 11150, {})
    end,
    Role.

%% -> [{}]
get_list() ->
    case erase(?MODULE) of
        undefined -> [];
        List -> 
            lists:foldr(fun(Id, Acc) ->
                case erase({?MODULE, Id}) of
                    undefined -> Acc;
                    {Type, Msg, Args, _Expire, _OnOffline} -> [{Type, Msg, Args}|Acc];
                    _ -> Acc
                end
            end, [], List)
    end.

%% -------------------------
recv(#role{link=#link{conn_pid=ConnPid}}, Id, Type, Msg, Args, Expire) ->
    put({?MODULE, Id}, {Type, Msg, Args, Expire, online}),
    case get(?MODULE) of
        undefined -> put(?MODULE, [Id]);
        L -> put(?MODULE, [Id|L])
    end,
    sys_conn:pack_send(ConnPid, 11150, {}),
    {ok}.

%% --------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% -----------------------------------------------------
%% 内部处理
%% -----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    case db:get_one(?DB_SYS, "SELECT IFNULL(max(id), 0) FROM `role_notification`") of
        {ok, MaxId} -> 
            counter:new(?MODULE, MaxId),
            {ok, #state{}};
        {error, undefined} -> 
            counter:new(?MODULE, 0),
            {ok, #state{}};
        Error ->
            {stop, Error}
    end.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Data, State) ->
    {noreply, State}.

%% 容错
handle_info(_Data, State) ->
    ?ELOG("错误的异步消息处理：DATA:~p, State:~p", [_Data, State]),
    {noreply, State}.

terminate(_Reason, _State) ->
    {noreply, _State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

