%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十一月 2015 10:23
%%%-------------------------------------------------------------------
-module(wish_tree).
-author("and_me").

%% API
-behaviour(gen_server).

-include("wish_tree.hrl").
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
-export([start_link/0,apply_call/3,apply_cast/3,apply_info/3,get_server_pid/0]).

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


apply_cast(Module,Function,Args)->
    ?CAST(?MODULE,{apply,{Module,Function,Args}}).

apply_info(Module,Function,Args)->
    ?MODULE ! {apply,{Module,Function,Args}}.

apply_call(Module,Function,Args)->
    ?CALL(?MODULE,{apply,{Module,Function,Args}}).

init([]) ->
    wish_tree_init:init_wish_tree(),
	Now = util:unixtime(),
	{_ToDayMidnighTime, NextDayMidnighTime} = util:get_midnight_seconds(Now),
	erlang:send_after((NextDayMidnighTime - Now)*1000,self(),midnight_refresh),
    {ok, ?MODULE}.



handle_call(Request, From, State) ->
    case catch wish_tree_handle:handle_call(Request, From, State) of
        {reply,Reply,NewState}->
            {reply,Reply,NewState};
        Reason ->
            ?ERR("wish_tree handle_call ~p~n",[Reason]),
            {reply,error,State}
    end.


handle_cast(Request, State) ->
    case catch wish_tree_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("wish_tree handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch wish_tree_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("wish_tree handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
