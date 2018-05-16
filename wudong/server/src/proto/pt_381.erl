%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-16 20:13:07
%%----------------------------------------------------
-module(pt_381).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"元宝不足"; 
err(3) ->"银两不足"; 
err(4) ->"会员等级不足"; 
err(5) ->"没有可找回的经验"; 
err(6) ->"参数错误"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(38100, _B0) ->
    {ok, {}};

read(38101, _B0) ->
    {P0_mul, _B1} = proto:read_uint8(_B0),
    {ok, {P0_mul}};

read(38110, _B0) ->
    {ok, {}};

read(38111, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_find_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_type, P0_find_type}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取离线经验找回信息 
write(38100, {P0_outline_time, P0_exp_info}) ->
    D_a_t_a = <<P0_outline_time:32, (length(P0_exp_info)):16, (list_to_binary([<<P1_mul:8, P1_need_vip:8, P1_get_exp:32, P1_get_state:8>> || [P1_mul, P1_need_vip, P1_get_exp, P1_get_state] <- P0_exp_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38100:16,0:8, D_a_t_a/binary>>};


%% 找回经验 
write(38101, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38101:16,0:8, D_a_t_a/binary>>};


%% 获取资源找回信息 
write(38110, {P0_dun_info}) ->
    D_a_t_a = <<(length(P0_dun_info)):16, (list_to_binary([<<P1_type:8, (proto:write_string(P1_name))/binary, P1_cost_gold:32, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_type, P1_name, P1_cost_gold, P1_goods_list] <- P0_dun_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38110:16,0:8, D_a_t_a/binary>>};


%% 功能找回 
write(38111, {P0_res, P0_type, P0_find_type, P0_goods_list}) ->
    D_a_t_a = <<P0_res:8, P0_type:8, P0_find_type:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38111:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



