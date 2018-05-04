%% @filename db_sup.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-01-15
%% @doc 
%% 数据库监控树.

-module(db_sup).
-behaviour(supervisor).
-export([init/1]).

-include("db.hrl").
-export([start_link/0]).


init([]) ->
    {ok,{{one_for_one,10,10}, []}}.


start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


