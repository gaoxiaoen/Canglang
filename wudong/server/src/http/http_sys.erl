%% @author zj
%% @doc http 系统命令


-module(http_sys).
-include("common.hrl").
-include("server.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([
    stop/1,
    hotfix/1,
    kf_hotfix/0,
    hotfun/1,
    config/1,
    reboot_warning/1
]).

stop(_QueryParam) ->
    spawn(fun() -> game:server_stop() end),
    {ok, 1}.

hotfix(QueryParam) ->
    MinStr = proplists:get_value("min", QueryParam),
    FileList = u:u(util:to_integer(MinStr)),
    FileList2 = [util:term_to_string(File) || File <- FileList],
    {ok, string:join(FileList2, ",")}.

kf_hotfix() ->
    cross_node:u(),
    {ok, 1}.

hotfun(QueryParam) ->
    Module = util:to_atom(proplists:get_value("module", QueryParam)),
    Method = util:to_atom(proplists:get_value("method", QueryParam)),
    try
        Ret = Module:Method(),
        {ok, util:term_to_string(Ret)}
    catch
        _:_ ->
            {ok, 0}
    end.

%%设置开服时间
config(QueryParam) ->
    %%Ret = os:cmd("cd /data/ctl/ && chmod 777 init.sh && ./init.sh"),
    Time = util:to_integer(proplists:get_value("time", QueryParam)),
    ?ERR("reset openning time ~p~n",[Time]),
    case Time of
        0 ->
            {ok, "set time fail"};
        _ ->
            config:set_dyc_config_time(Time),
            os:cmd(io_lib:format("cd ../script &&  sed -i 's/OPENTIME=.*/OPENTIME=~p/' config.sh", [Time])),
            {ok, util:unixtime_to_time_string3(Time)}
    end.


reboot_warning(_QueryParam) ->
    cache:set(reboot_warning, true),
    {ok, Bin} = pt_100:write(10011, {1}),
    server_send:send_to_all(Bin),
    ?DEBUG("set reboot warning ~p ~n", [util:unixtime()]),
    {ok, "set reboot ok"}.

%% ====================================================================
%% Internal functions
%% ====================================================================


