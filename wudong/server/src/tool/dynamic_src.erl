%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 动态编译模块  [规范所有动态编码模块都以dyc_***开头]
%%% @end
%%% Created : 08. 十月 2015 下午5:38
%%%-------------------------------------------------------------------
-module(dynamic_src).
-author("fancy").
-include("common.hrl").

%% API
-export([
    make/0,
    set_dyc_config_time/1,
    set_dyc_config_debug/1,
    set_dyc_server_num/1,
    set_dyc_reg_time/1,
    set_dyc_cross_platform/1,
    set_fcm/1
]).

%%编译动态模块
make() ->
    OpenTime = config:get_opening_time(),
    set_dyc_config_time(OpenTime),

    Debug = ?IF_ELSE(config:is_debug(), 1, 0),
    set_dyc_config_debug(Debug),

    Sn = config:get_server_num(),
    set_dyc_server_num(Sn),

    RunningPlatform = config:get_running_platform(),
    set_dyc_cross_platform(RunningPlatform),

    set_dyc_start_time(util:unixtime()),

    set_fcm("[]"),
    ok.

%%动态设置开服时间
set_dyc_config_time(Time) ->
    Code = "-module(dyc_config_time).
    -export([opening_time/0]).
    opening_time() ->
        " ++ util:to_list(Time) ++ ".
    ",
    {Mod2, Code2} = dynamic_compile:from_string(Code),
    code:load_binary(Mod2, "dyc_config_time.erl", Code2).

%%动态设置导入玩家时间
set_dyc_reg_time(Time) ->
    Code = "-module(dyc_reg_time).
    -export([player_reg_time/0]).
    player_reg_time() ->
        " ++ util:to_list(Time) ++ ".
    ",
    {Mod2, Code2} = dynamic_compile:from_string(Code),
    code:load_binary(Mod2, "dyc_reg_time.erl", Code2).

%%动态设置测试模式
set_dyc_config_debug(Bool) ->
    Code = "-module(dyc_config_debug).
    -export([is_debug/0]).
    is_debug() ->",
    Code2 =
        if
            Bool > 0 ->
                Code ++ "true .
                ";
            true ->
                Code ++ "false .
                "
        end,
    {Mod2, Code3} = dynamic_compile:from_string(Code2),
    code:load_binary(Mod2, "dyc_config_debug.erl", Code3).

%%动态设置服务器号
set_dyc_server_num(N) ->
    Code = "-module(dyc_server_num).
    -export([server_num/0]).
    server_num() ->
        " ++ util:to_list(N) ++ ".
    ",
    {Mod2, Code2} = dynamic_compile:from_string(Code),
    code:load_binary(Mod2, "dyc_server_num.erl", Code2).

%%多平台下接口差异动态编译
set_dyc_cross_platform(Platform) ->
    Code = "-module(dyc_cross_platform).
    -export([system_time/0]).
    system_time() ->
        " ++ ?IF_ELSE(Platform == 'win', "erlang:system_time(1000000000) + abs(erlang:unique_integer()) rem 100000000 .", "erlang:system_time().") ++ "
    ",
    {Mod2, Code2} = dynamic_compile:from_string(Code),
    code:load_binary(Mod2, "dyc_cross_platform.erl", Code2).


%%服务器启动时间
set_dyc_start_time(N) ->
    Code = "-module(dyc_server_start).
    -export([start_time/0]).
       start_time() ->
        " ++ util:to_list(N) ++ ".
    ",
    {Mod2, Code2} = dynamic_compile:from_string(Code),
    code:load_binary(Mod2, "dyc_server_start.erl", Code2).

set_fcm(List) ->
    Code = "-module(dyc_fcm).
    -export([fcm_state/0]).
       fcm_state() ->
        " ++ util:to_list(List) ++ ".
    ",
    {Mod2, Code2} = dynamic_compile:from_string(Code),
    code:load_binary(Mod2, "dyc_fcm.erl", Code2).