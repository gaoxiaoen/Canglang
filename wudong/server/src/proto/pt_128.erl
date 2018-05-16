%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-01-10 12:14:07
%%----------------------------------------------------
-module(pt_128).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"元宝不足"; 
err(3) ->"扫荡次数不足"; 
err(4) ->"先通关后，可扫荡"; 
err(5) ->"购买次数不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(12801, _B0) ->
    {ok, {}};

read(12802, _B0) ->
    {ok, {}};

read(12803, _B0) ->
    {P0_layer, _B1} = proto:read_int8(_B0),
    {ok, {P0_layer}};

read(12804, _B0) ->
    {P0_dun_id, _B1} = proto:read_int32(_B0),
    {P0_num, _B2} = proto:read_int8(_B1),
    {ok, {P0_dun_id, P0_num}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%%  副本列表 
write(12801, {P0_layer_list}) ->
    D_a_t_a = <<(length(P0_layer_list)):16, (list_to_binary([<<P1_layer:8, P1_left_godsoul_num:32/signed, P1_left_godness_num:32/signed, P1_right_godsoul_num:32/signed, P1_right_godness_num:32/signed, P1_buy_price:16, P1_buy_num:8, P1_is_rest:8, (length(P1_list)):16, (list_to_binary([<<P2_type:8, P2_dun_id:32, P2_is_first:8, P2_is_saodang:8, P2_state:8>> || [P2_type, P2_dun_id, P2_is_first, P2_is_saodang, P2_state] <- P1_list]))/binary>> || [P1_layer, P1_left_godsoul_num, P1_left_godness_num, P1_right_godsoul_num, P1_right_godness_num, P1_buy_price, P1_buy_num, P1_is_rest, P1_list] <- P0_layer_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12801:16,0:8, D_a_t_a/binary>>};


%% 副本结算 
write(12802, {P0_code, P0_dun_id, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8/signed, P0_dun_id:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_state:32/signed>> || [P1_goods_id, P1_num, P1_state] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12802:16,0:8, D_a_t_a/binary>>};


%% 右边高级副本重置 
write(12803, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12803:16,0:8, D_a_t_a/binary>>};


%% 副本一键扫荡 
write(12804, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12804:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



