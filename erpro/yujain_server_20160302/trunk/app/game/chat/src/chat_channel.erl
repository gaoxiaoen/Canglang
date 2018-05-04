%%% -------------------------------------------------------------------
%%% Author  :markycai<tomarky.cai@gmail.com>
%%% Description :
%%%
%%% Created : 2013-12-9
%%% -------------------------------------------------------------------
-module(chat_channel).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("chat.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start_link/2,
         start_link/3]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================

start_link(ChannelType,ChannelName)->
    gen_server:start_link({local, common_tool:to_atom(ChannelName)}, ?MODULE,[ChannelType,ChannelName], []).

start_link(ChannelType,ChannelName,ExtendNum)->
    gen_server:start_link({local, common_tool:to_atom(ChannelName)}, ?MODULE,[ChannelType,ChannelName,ExtendNum], []).

%% ====================================================================
%% Server functions
%% ====================================================================
init([ChannelType,ChannelName]) ->
    ExtendNum = cfg_chat:find({channel_extend,ChannelType}),
    init([ChannelType,ChannelName,ExtendNum]);
init([_ChannelType,ChannelName,ExtendNum]) ->
    erlang:process_flag(trap_exit, true),
    ExtendPidList = 
        lists:foldl(
          fun(ExtendId,Acc)->
                  ProcessName = chat_misc:get_extend_name(ChannelName,ExtendId),
                  case chat_channel_extend:start_link(ProcessName) of
                      {ok, Pid}->
                          [Pid|Acc];
                      {error,{already_started, Pid}}->
                          [Pid|Acc];
                      _->
                          Acc
                  end
          end, [], lists:seq(1, ExtendNum)),
    set_all_extend_pid_list(ExtendPidList),
    set_extend_pid_queue(ExtendPidList),
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

do_handle_info({broadcast,Module,Method,R})->
    lists:foreach(
      fun(PId)->
              catch erlang:send(PId, {broadcast_extend,Module,Method,R})      
      end, get_all_extend_pid_list());

do_handle_info({join_channel,RoleId,GatewayPid})->
    case get_role_extend_pid(RoleId) of
        undefined->
            Pid = dequeue_extend_pid_queue(),
            set_role_extend_pid(RoleId,Pid),
            catch erlang:send(Pid, {join_channel_extend,RoleId,GatewayPid});
        _->
            ignore
    end;
do_handle_info({leave_channel,RoleId})->
    Pid=erase_role_extend_pid(RoleId),
    catch erlang:send(Pid, {leave_channel_extend,RoleId});

do_handle_info({kill_process})->
    lists:foreach(
      fun(PId)->
              catch erlang:send(PId, {kill_process})      
      end, get_all_extend_pid_list()),
    erlang:exit(erlang:self(), channel_map_process_close);

do_handle_info(Info)->
	?ERROR_MSG("receive unknown message,Info=~w",[Info]).

set_all_extend_pid_list(ExtendPidList)->
    erlang:put(all_extend_pid_list,ExtendPidList).

get_all_extend_pid_list()->
    erlang:get(all_extend_pid_list).

set_extend_pid_queue(ExtendPidList)->
    erlang:put(extend_pid_queue,ExtendPidList).

dequeue_extend_pid_queue()->
    case erlang:get(extend_pid_queue) of
        [Pid|RestList]->
            set_extend_pid_queue(RestList),
            Pid;
        []->
            [Pid|RestList]=get_all_extend_pid_list(),
            set_extend_pid_queue(RestList),
            Pid
    end.
    
set_role_extend_pid(RoleId,Pid)->
    erlang:put({role_extend_pid,RoleId},Pid).

erase_role_extend_pid(RoleId)->
    erlang:erase({role_extend_pid,RoleId}).
    
get_role_extend_pid(RoleId)->
    erlang:get({role_extend_pid,RoleId}).
