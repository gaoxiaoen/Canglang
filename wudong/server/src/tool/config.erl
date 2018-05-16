%% @Author:zj
%% @Email:1812338@gmail.com
%% 各种配置获取接口
%%
-module(config).
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-include("server.hrl").
-compile(export_all).

%%是否跨服节点
is_center_node() ->
    case get(is_center_node) of
        undefined ->
            Sn = get_server_num(),
            Ret = Sn > 50000,
            put(is_center_node, Ret),
            Ret;
        Data ->
            Data
    end.

%%
get_acceptor_num() ->
    10.

get_max_connections() ->
    50.

%%获取节点ip
get_config_ip() ->
    Args = init:get_plain_arguments(),
    lists:nth(2, Args).

%%获取节点号
get_config_node_id() ->
    1.

%%获取节点端口
get_config_port() ->
    Args = init:get_plain_arguments(),
    util:to_integer(lists:nth(3, Args)).


%% 日志等级
get_log_level() ->
    Args = init:get_plain_arguments(),
    util:to_integer(lists:nth(6, Args)).

%%日志目录
get_log_path() ->
    "../logs".

%% 私钥
get_ticket() ->
    Args = init:get_plain_arguments(),
    lists:nth(5, Args).


get_is_fcm() ->
    0.

%% 手机钱包开关(0关，1开)
get_phone_gift() ->
    0.

%% 获取运行平台
get_running_platform() ->
    try
        Args = init:get_plain_arguments(),
        Pf = lists:nth(13, Args),
        util:to_atom(Pf)
    catch
        _:_ ->
            linux
    end.

%% 获取mysql参数
get_mysql_config() ->
    Args = init:get_plain_arguments(),
    Host = lists:nth(8, Args),
    Port = util:to_integer(lists:nth(9, Args)),
    User = lists:nth(10, Args),
    Pass = lists:nth(11, Args),
    Name = lists:nth(12, Args),
    [Host, Port, User, Pass, Name, utf8].

%% 获取当前所在的服名
get_server_num() ->
    try
        dyc_server_num:server_num()
    catch
        _:_ ->
            Args = init:get_plain_arguments(),
            util:to_integer(lists:nth(1, Args))
    end.


get_act_server_num() ->
    case is_debug() of
        false -> get_server_num();
        true ->
            Sn0 = get_server_num(),
            case lists:member(Sn0, [30004, 30098, 50001]) of
                true -> Sn0;
                _ ->
                    case cache:get(act_server_num) of
                        [] ->
                            get_server_num();
                        Sn -> Sn
                    end
            end
    end.

set_act_server_num(Sn) ->
    cache:set(act_server_num, Sn, ?ONE_DAY_SECONDS).

%%获取当前服名称
get_server_name() ->
    get_server_name(get_server_num()).

get_server_name(Sn) ->
    case ets:lookup(?ETS_SN_NAME, Sn) of
        [] ->
            case do_get_server_name(Sn) of
                [] -> <<>>;
                Name ->
                    ets:insert(?ETS_SN_NAME, #ets_sn_name{sn = Sn, name = Name}),
                    Name
            end;
        [R] -> R#ets_sn_name.name
    end.

do_get_server_name(Sn) ->
    Url = lists:concat([config:get_api_url(), "/sn_name.php"]),
    PostData = io_lib:format("sn=~p", [Sn]),
    PostData2 = unicode:characters_to_list(PostData, unicode),
    Result = httpc:request(post, {Url, [], "application/x-www-form-urlencoded", PostData2}, [{timeout, 2000}], []),
    case Result of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, JsonList}, _} ->
                    case lists:keyfind("ret", 1, JsonList) of
                        {_, Name} ->
                            Name;
                        _ ->
                            ?ERR("get_server_name err bad json ~n"),
                            []
                    end;
                _ ->
                    []
            end;
        _ ->
            []
    end.

get_server_list() ->
    Url = lists:concat([config:get_api_url(), "/servers.php"]),
    Result = httpc:request(post, {Url, [], "application/x-www-form-urlencoded", ""}, [{timeout, 2000}], []),
    case Result of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, JsonList}, _} ->
                    case lists:keyfind("ret", 1, JsonList) of
                        {_, 1} -> 1;
                        {_, {obj, List}} ->
%%                            io:format("####L ~p~n",[List]),
                            [{util:to_integer(Sn), util:to_integer(Time)} || {Sn, Time} <- List];
                        {_, []} ->
                            [];
                        _ ->
                            ?ERR("get_center_notice err bad json ~n"),
                            []
                    end;
                _ ->
                    []
            end;
        _ ->
            []
    end.


%% 获取开服时间
get_opening_time() ->
    try
        dyc_config_time:opening_time()
    catch
        _:_ ->
            Args = init:get_plain_arguments(),
            util:to_integer(lists:nth(4, Args))
    end.


%% 获取真实注册时间
get_player_reg_time() ->
    try
        dyc_reg_time:player_reg_time()
    catch
        _:_ ->
            case db:get_one("select reg_time from player_login order by reg_time asc limit 10 , 1") of
                null ->
                    util:unixtime();
                RegTime ->
                    dynamic_src:set_dyc_reg_time(RegTime),
                    RegTime

            end
    end.

%% 获取服务器启动时间
get_start_time() ->
    try
        dyc_server_start:start_time()
    catch
        _:_ ->
            util:unixtime()
    end.

get_start_time2() ->
    util:unixtime_to_time_string3(get_start_time()).


%% 获取已开服天数
get_open_days() ->
    OpenTime = get_opening_time(),
    OpenDate = util:unixdate(OpenTime),
    Today = util:unixdate(),
    OpenDay = round((Today - OpenDate) / ?ONE_DAY_SECONDS + 1),
    case OpenDay =< 0 of
        true -> 1;
        false -> OpenDay
    end.


%% 获取已合服天数
get_merge_days() ->
    case config:is_debug() of
        true ->
            Sn0 = get_server_num(),
            %%暂时这么写 有需要测试再开
            case lists:member(Sn0, [30004]) of
                true ->
                    0;
                _ ->
                    case g_forever:get_count(9999999) of
                        0 ->
                            Sn = get_server_num(),
                            get_target_merge_days(Sn);
                        Day -> Day
                    end
            end;
        false ->
            Sn = get_server_num(),
            get_target_merge_days(Sn)
    end.

get_merge_times() ->
    Key = get_merge_times,
    case cache:get(Key) of
        [] ->
            Sql = "select max(times) from merge_info ",
            case db:get_one(Sql) of
                null -> Times = 0;
                Times -> Times
            end,
            cache:set(Key, Times, ?ONE_DAY_SECONDS),
            Times;
        Val -> Val
    end.

%% 获取指定服的合服天数
get_target_merge_days(Sn) ->
    Key = io_lib:format("get_merge_time_~p", [Sn]),
    case cache:get(Key) of
        [] ->
            MergeDays =
                case db:get_one(io_lib:format("select time from merge_info where sn = ~p order by time desc limit 1", [Sn])) of
                    null ->
                        cache:set(Key, 0, 1800),
                        0;
                    MergeTime ->
                        cache:set(Key, MergeTime, 1800),
                        MergeDate = util:unixdate(MergeTime),
                        Today = util:unixdate(),
                        Days = round((Today - MergeDate) / ?ONE_DAY_SECONDS + 1),
                        ?IF_ELSE(Days =< 0, 1, Days)
                end,
            MergeDays;
        0 ->
            0;
        MergeTime ->
            MergeDate = util:unixdate(MergeTime),
            Today = util:unixdate(),
            Days = round((Today - MergeDate) / ?ONE_DAY_SECONDS + 1),
            ?IF_ELSE(Days =< 0, 1, Days)
    end.

%% 获取指定服与合服主服的开服相差天数
get_diff_open_days(TarSn) ->
    OldestKey = "get_oldest_open_time",
    D1 =
        case cache:get(OldestKey) of
            [] ->
                OldestDays =
                    case db:get_one("select opentime from server_info order by opentime asc limit 1") of
                        null ->
                            cache:set(OldestKey, 1, 1800),
                            1;
                        OpenTime ->
                            cache:set(OldestKey, OpenTime, 1800),
                            OpenDate = util:unixdate(OpenTime),
                            Today = util:unixdate(),
                            Days = round((Today - OpenDate) / ?ONE_DAY_SECONDS + 1),
                            ?IF_ELSE(Days =< 0, 1, Days)
                    end,
                OldestDays;
            1 ->
                1;
            OpenTime ->
                OpenDate = util:unixdate(OpenTime),
                Today = util:unixdate(),
                Days = round((Today - OpenDate) / ?ONE_DAY_SECONDS + 1),
                ?IF_ELSE(Days =< 0, 1, Days)
        end,
    D2 = get_target_open_days(TarSn),
    ?IF_ELSE(D2 == 0, 0, max(0, D1 - D2)).

get_target_open_days(Sn) ->
    Key = io_lib:format("get_open_time_~p", [Sn]),
    case cache:get(Key) of
        [] ->
            OpenDays =
                case db:get_one(io_lib:format("select opentime from server_info where sn = ~p limit 1", [Sn])) of
                    null ->
                        cache:set(Key, 0, 1800),
                        0;
                    OpenTime ->
                        cache:set(Key, OpenTime, 1800),
                        OpenDate = util:unixdate(OpenTime),
                        Today = util:unixdate(),
                        Days = round((Today - OpenDate) / ?ONE_DAY_SECONDS + 1),
                        ?IF_ELSE(Days =< 0, 1, Days)
                end,
            OpenDays;
        0 ->
            0;
        OpenTime ->
            OpenDate = util:unixdate(OpenTime),
            Today = util:unixdate(),
            Days = round((Today - OpenDate) / ?ONE_DAY_SECONDS + 1),
            ?IF_ELSE(Days =< 0, 1, Days)
    end.


%% 是否开发模式 true/false
is_debug() ->
    try
        dyc_config_debug:is_debug()
    catch
        _:_ ->
            Args = init:get_plain_arguments(),
            Int = util:to_integer(lists:nth(7, Args)),
            ?IF_ELSE(Int > 0, true, false)
    end.

%%是否打印sql
is_trace_sql() ->
    false.

%%是否catch 保护
is_catch_err() ->
    true.

%%是否启用hipe
is_use_hipe() ->
    false.

%%动态设置开服时间
set_dyc_config_time(Time) ->
    Code = "-module(dyc_config_time).
    -export([opening_time/0]).
    opening_time() ->
        " ++ util:to_list(Time) ++ ".
    ",
    {Mod2, Code2} = dynamic_compile:from_string(Code),
    code:load_binary(Mod2, "dyc_config_time.erl", Code2).

%% 获取卡号礼包验证URL
get_api_url() ->
    case application:get_env(server, api_url) of
        {ok, URL} ->
            URL;
        _ ->
            ""
    end.


%%获取防沉迷配置 [是否开启(1是0否),通知信息(0邮件,1弹窗)]
get_fcm_config() ->
    try
        dyc_fcm:fcm_state()
    catch
        _:_ ->
            []
    end.


