%%%-------------------------------------------------------------------
%%% File        :mgeeg_global_server.erl
%%% Author      :caochuncheng2002@gmail.com
%%% @doc
%%%     玩家状态服务
%%% @end
%%%-------------------------------------------------------------------
-module(mgeeg_global_server).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("mgeeg.hrl").

-define(ROLE_STATUS_LOGIN_GAME,1). %% 玩家进入游戏
-define(ROLE_STATUS_LOGOUT_GAME,2). %% 玩家退出出游戏

%% --------------------------------------------------------------------
%% External exports
-export([start/0,start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

start() ->
    case erlang:whereis(?MODULE) of
        undefined ->
            {ok, _} = supervisor:start_child(mgeeg_sup, {?MODULE, {?MODULE, start_link, []},
                                                         permanent, 10000, worker, [?MODULE]});
        _ ->
            ?ERROR_MSG("mgeeg_global_server process is created.",[]),
            ignore
    end.

start_link() ->
    gen_server:start_link({local,?MODULE},?MODULE, [], []).

init([]) ->
    {ok, #state{}}.
handle_call({get_role_status,RoleId}, _From, State) ->
    Reply = get_role_status(RoleId),
     {reply, Reply, State};
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    ?TRY_CATCH(do_handle_info(Info),CastError),
    {noreply, State}.
terminate(_Reason, _State) ->
    ok.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_info({set_role_status,RoleId,role_login_game,PId}) ->
    erlang:monitor(process, PId),
    erlang:put(PId, RoleId),
    case erase_role_timer(RoleId) of
        undefined->
            ignore;
        TimerRef->
            erlang:cancel_timer(TimerRef)
    end,
    set_role_status(RoleId,?ROLE_STATUS_LOGIN_GAME);

do_handle_info({set_role_status,RoleId,role_logout_game}) ->
    erase_role_status(RoleId);
do_handle_info({erase_role_status,RoleId}) ->
    erase_role_status(RoleId);

do_handle_info({check_role_status,RoleId}) ->
    case erlang:get(RoleId) of
        undefined ->
            ignore;
        ?ROLE_STATUS_LOGIN_GAME ->
            erase_role_status(RoleId),
            erase_role_timer(RoleId);
        _ ->
            ignore
    end;

do_handle_info({'DOWN', _MonitorRef, process, PId, _Info}) ->
    case erlang:erase(PId) of
        undefined ->
            next;
        RoleId ->
            case get_role_status(RoleId) of
                ?ROLE_STATUS_LOGOUT_GAME ->
                    next;
                _ ->
                    
                    TimerRef = erlang:send_after(10 * 1000, erlang:self(), {check_role_status, RoleId}),
                    set_role_timer(RoleId, TimerRef)
            end
    end;

do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;

do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).


get_role_status(RoleId) ->
    case erlang:get(RoleId) of
        undefined ->
            ?ROLE_STATUS_LOGOUT_GAME;
        RoleStatus ->
            RoleStatus
    end.
set_role_status(RoleId,RoleStatus) ->
    erlang:put(RoleId, RoleStatus).
erase_role_status(RoleId) ->
    erlang:erase(RoleId).

set_role_timer(RoleId,TimerRef)->
    erlang:put({waiting_timer,RoleId}, TimerRef).
erase_role_timer(RoleId)->
    erlang:erase({waiting_timer,RoleId}).
    

