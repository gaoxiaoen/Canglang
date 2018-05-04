%% @filename team_misc.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-02-15 
%% @doc 
%% 队伍公用模块.

-module(team_misc).

-include("mgeew.hrl").

-export([
         start/0,
         get_team_process_name/1
        ]).

%% 启动队伍服务
-spec start() -> ok.
start() ->
    team_sup:start(),
    team_manager_server:start(),
    ok.


%% 获取队伍进程名
-spec 
get_team_process_name(TeamId) -> PName when 
    TeamId :: integer(), 
    PName :: atom().
get_team_process_name(TeamId) ->
    erlang:list_to_atom(lists:concat(["team_", TeamId])).