%%% -------------------------------------------------------------------
%%% Author  :markycai<tomarky.cai@gmail.com>
%%% Description :
%%%
%%% Created : 2013-12-9
%%% -------------------------------------------------------------------
-module(chat_channel_extend).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("chat.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link(ProcessName)->
    gen_server:start_link({local,ProcessName}, ?MODULE, [],[]).

%% ====================================================================
%% External functions
%% ====================================================================


%% ====================================================================
%% Server functions
%% ====================================================================

init([]) ->
    {ok, []}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({'EXIT', _PId, _Reason}, State) ->
    {stop, normal, State};

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info,State),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

do_handle_info({broadcast_extend,Module,Method,R})->
    lists:foreach(
      fun({{role,_RoleId},GatewayPid})->
              common_misc:unicast(GatewayPid,Module,Method,R);
         (_)->ignore
      end, get());

do_handle_info({join_channel_extend,RoleId,GatewayPid})->
    set_role(RoleId,GatewayPid);
do_handle_info({leave_channel_extend,RoleId})->
    erase_role(RoleId);

do_handle_info({kill_process})->
    erlang:exit(erlang:self(), channel_map_extend_process_close);

do_handle_info(Info)->
	?ERROR_MSG("receive unknown message,Info=~w",[Info]).

set_role(RoleId,GatewayPid)->
    erlang:put({role,RoleId},GatewayPid).

erase_role(RoleId)->
    erlang:erase({role,RoleId}).