%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-10-12 10:29:34
%%----------------------------------------------------
-module(pt_127).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(12701, _B0) ->
    {ok, {}};

read(12702, _B0) ->
    {ok, {}};

read(12703, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%%  副本列表 
write(12701, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_dun_id:32/signed, P1_state:8/signed>> || [P1_dun_id, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12701:16,0:8, D_a_t_a/binary>>};


%% 副本目标 
write(12702, {P0_time}) ->
    D_a_t_a = <<P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12702:16,0:8, D_a_t_a/binary>>};


%% 副本结算 
write(12703, {P0_code, P0_dun_id, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8/signed, P0_dun_id:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12703:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



