%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 二月 2017 下午2:26
%%%-------------------------------------------------------------------
-module(handle_guild_boss).
-author("Administrator").


-include("common.hrl").
-include("server.hrl").
-include("guild.hrl").

%% API
-export([
    init/0,
    handle/2
]).

init() ->
    {ok, ok}.

handle(State, Time) ->
    {_, {Hour, Minute, _Second}} = util:seconds_to_localtime(Time),
    if
        Hour == ?GUILD_BOSS_OPEN_HOUR andalso Minute == ?GUILD_BOSS_OPEN_MINUTE ->
            guild_boss:create_boss(),
            LeaveTime = guild_boss:get_leave_time(),
            {ok, Bin} = pt_400:write(40053, {LeaveTime,1}),
            server_send:send_to_all(Bin);
        Hour == ?GUILD_BOSS_CLOSE_HOUR andalso Minute == ?GUILD_BOSS_CLOSE_MINUTE ->
            guild_boss:delete_boss(),
            guild_boss:reset_state(),
            LeaveTime = guild_boss:get_leave_time(),
            {ok, Bin} = pt_400:write(40053, {LeaveTime,0}),
            server_send:send_to_all(Bin);
        true -> skip
    end,
    {ok, State}.

