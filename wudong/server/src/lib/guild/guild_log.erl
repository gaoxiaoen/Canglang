%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 帮派日记
%%% @end
%%% Created : 23. 一月 2017 下午5:45
%%%-------------------------------------------------------------------
-module(guild_log).
-author("fengzhenlin").
-include("server.hrl").
-include("guild.hrl").
-include("server.hrl").

%% API
-compile(export_all).


%%增加工会日志
add_log(Log, Type, NowTime, Msg) ->
    NewLog = [{Type, NowTime, Msg} | Log],
    lists:sublist(NewLog, ?GUILD_LOG_LEN).