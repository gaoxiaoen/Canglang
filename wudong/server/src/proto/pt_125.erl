%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-01-09 15:58:24
%%----------------------------------------------------
-module(pt_125).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(12501, _B0) ->
    {ok, {}};

read(12502, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取符文塔 
write(12501, {P0_layer, P0_sub_layer}) ->
    D_a_t_a = <<P0_layer:8/signed, P0_sub_layer:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12501:16,0:8, D_a_t_a/binary>>};


%% 符文塔副本结算 
write(12502, {P0_code, P0_status, P0_dun_id, P0_layer, P0_sub_layer, P0_get_list}) ->
    D_a_t_a = <<P0_code:8/signed, P0_status:8/signed, P0_dun_id:32/signed, P0_layer:8/signed, P0_sub_layer:8/signed, (length(P0_get_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_get_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12502:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



