%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%         %%跨服副本组队大厅
%%% @end
%%% Created : 28. 十一月 2016 14:02
%%%-------------------------------------------------------------------
-module(cross_dungeon_guard_proc).
-author("hxming").
%% API
-behaviour(gen_server).

-include("cross_dungeon_guard.hrl").
-include("common.hrl").

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-define(SERVER, ?MODULE).

%% API
-export([
    start_link/0
    , get_server_pid/0

]).

-export([
    room_list/7
    , create_room/5
    , room_info/4
    , quit_room/4
    , kickout/5
    , enter_room/4
    , ready_room/4
    , check_invite/4
    , invite_notice/4
    , open_dungeon/4
    , logout/2
    , back_room/6
    , send_info/4

]).
%%房间列表
room_list(Node, Sn, Sid, DunId, Pkey, Cbp, Lv) ->
    get_server_pid() ! {room_list, Node, Sn, Sid, DunId, Pkey, Cbp, Lv}.

%%创建房间
create_room(Mb, DunId, Lv, Password, FastOpen) ->
    get_server_pid() ! {create_room, Mb, DunId, Lv, Password, FastOpen}.

%%房间信息
room_info(Node, Sid, Key, PKey) ->
    get_server_pid() ! {room_info, Node, Sid, Key, PKey}.

%%退出房间
quit_room(Node, Sid, Key, PKey) ->
    get_server_pid() ! {quit_room, Node, Sid, Key, PKey}.

%%踢人
kickout(Node, Sid, Key, PKey, Dkey) ->
    get_server_pid() ! {kickout, Node, Sid, Key, PKey, Dkey}.

%%加入房间
enter_room(Mb, DunId, Key, Password) ->
    get_server_pid() ! {enter_room, Mb, DunId, Key, Password}.

%%准备房间
ready_room(Node, Sid, Key, Pkey) ->
    get_server_pid() ! {ready_room, Node, Sid, Key, Pkey}.

check_invite(Node, Key, Nickname, Pid) ->
    get_server_pid() ! {check_invite, Node, Key, Nickname, Pid}.

invite_notice(Node, Sid, Key, Nickname) ->
    get_server_pid() ! {invite_notice, Node, Sid, Key, Nickname}.

open_dungeon(Node, Sid, Key, Pkey) ->
    get_server_pid() ! {open_dungeon, Node, Sid, Key, Pkey}.

logout(Key, Pkey) ->
    get_server_pid() ! {logout, Key, Pkey}.
back_room(Mb, DunId, Lv, Key, Password, IsFast) ->
    get_server_pid() ! {back_room, Mb, DunId, Lv, Key, Password, IsFast}.
send_info(Key,Pkey, Nickname, Type) ->
    ?DEBUG("djsakldjksadjsalkds ~n"),
    get_server_pid() ! {send_info, Key, Pkey,Nickname, Type}.


%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%获取进程PID
get_server_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.


init([]) ->
    put(room_list, []),

    spawn(fun() -> cross_dungeon_guard_util:dbload_milestone_ets() end),
%%    erlang:send_after(?FIFTEEN_MIN_SECONDS * 1000, self(), clean),
    {ok, ?MODULE}.



handle_call(Request, From, State) ->
    case catch cross_dungeon_guard_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross dungeon handle_call ~p/~p~n", [Request, Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch cross_dungeon_guard_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross dungeon handle_cast ~p/ ~p~n", [Request, Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch cross_dungeon_guard_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross dungeon handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
