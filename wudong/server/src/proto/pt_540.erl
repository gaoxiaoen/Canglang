%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:19
%%----------------------------------------------------
-module(pt_540).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"次数不足"; 
err(3) ->"留言太长了"; 
err(4) ->"你不是城主"; 
err(5) ->"城主还没诞生"; 
err(6) ->"留言内容有敏感词"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(54000, _B0) ->
    {ok, {}};

read(54001, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(54003, _B0) ->
    {P0_msg, _B1} = proto:read_string(_B0),
    {ok, {P0_msg}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取膜拜信息信息 
write(54000, {P0_is_worship, P0_msg, P0_worship_times, P0_egg_times, P0_combatpower, P0_leave_times}) ->
    D_a_t_a = <<P0_is_worship:8, (proto:write_string(P0_msg))/binary, P0_worship_times:32, P0_egg_times:32, P0_combatpower:32, P0_leave_times:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 54000:16,0:8, D_a_t_a/binary>>};


%% 膜拜/扔鸡蛋 
write(54001, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 54001:16,0:8, D_a_t_a/binary>>};


%% 修改留言 
write(54003, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 54003:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



