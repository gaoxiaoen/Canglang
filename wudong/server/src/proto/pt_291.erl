%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-11-14 16:40:16
%%----------------------------------------------------
-module(pt_291).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"种子不足"; 
err(3) ->"已是最高阶级"; 
err(4) ->"当前未婚状态,不可升级"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(29101, _B0) ->
    {ok, {}};

read(29102, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(29103, _B0) ->
    {P0_lv, _B1} = proto:read_uint16(_B0),
    {P0_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_lv, P0_type}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 爱情树面板信息 
write(29101, {P0_lv1, P0_lv2, P0_lv3, P0_percent1, P0_percent2, P0_cost, P0_total_exp, P0_cbp, P0_reward_list, P0_attribute_list, P0_tree_reward_list}) ->
    D_a_t_a = <<P0_lv1:16, P0_lv2:16, P0_lv3:16, P0_percent1:16, P0_percent2:16, P0_cost:16, P0_total_exp:32, P0_cbp:32, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary, (length(P0_tree_reward_list)):16, (list_to_binary([<<P1_lv:16, P1_cd_time:32>> || [P1_lv, P1_cd_time] <- P0_tree_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 29101:16,0:8, D_a_t_a/binary>>};


%% 爱情树升阶 
write(29102, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 29102:16,0:8, D_a_t_a/binary>>};


%% 爱情树种子奖励领取 
write(29103, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 29103:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



