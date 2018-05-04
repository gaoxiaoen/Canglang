%% @filename team_sup.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-02-15 
%% @doc 
%% 队伍进程监控树.

-module(team_sup).
-behaviour(supervisor).

-include("mgeew.hrl").

-export([init/1]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
         start/0,
         start_link/0
        ]).

start() ->
    supervisor:start_child(mgeew_sup,{?MODULE,{?MODULE, start_link, []},transient, infinity, supervisor, [?MODULE]}).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ====================================================================
%% Behavioural functions
%% ====================================================================

%% init/1
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/supervisor.html#Module:init-1">supervisor:init/1</a>
-spec init(Args :: term()) -> Result when
	Result :: {ok, {SupervisionPolicy, [ChildSpec]}} | ignore,
	SupervisionPolicy :: {RestartStrategy, MaxR :: non_neg_integer(), MaxT :: pos_integer()},
	RestartStrategy :: one_for_all
					 | one_for_one
					 | rest_for_one
					 | simple_one_for_one,
	ChildSpec :: {Id :: term(), StartFunc, RestartPolicy, Type :: worker | supervisor, Modules},
	StartFunc :: {M :: module(), F :: atom(), A :: [term()] | undefined},
	RestartPolicy :: permanent
				   | transient
				   | temporary,
	Modules :: [module()] | dynamic.
%% ====================================================================
init([]) ->
    {ok,{{one_for_one,1000,3600},[]}}.

%% ====================================================================
%% Internal functions
%% ====================================================================


