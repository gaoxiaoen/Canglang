%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-16 13:49:15
%%----------------------------------------------------
-module(pt_630).
-export([read/2, write/2]).

-include("common.hrl").
-include("grace.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(63001, _B0) ->
    {ok, {}};

read(63002, _B0) ->
    {ok, {}};

read(63003, _B0) ->
    {ok, {}};

read(63004, _B0) ->
    {ok, {}};

read(63005, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 查询活动状态 
write(63001, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 63001:16,0:8, D_a_t_a/binary>>};


%% 宝箱刷新倒计时 
write(63002, {P0_time}) ->
    D_a_t_a = <<P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 63002:16,0:8, D_a_t_a/binary>>};


%% 目标 
write(63003, {P0_time, P0_refresh_time, P0_count, P0_count_lim, P0_round}) ->
    D_a_t_a = <<P0_time:16, P0_refresh_time:16, P0_count:16, P0_count_lim:16, P0_round:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 63003:16,0:8, D_a_t_a/binary>>};


%% 宝箱采集数更新 
write(63004, {P0_count}) ->
    D_a_t_a = <<P0_count:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 63004:16,0:8, D_a_t_a/binary>>};


%% 宝箱刷新时间更新 
write(63005, {P0_refresh_time}) ->
    D_a_t_a = <<P0_refresh_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 63005:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



