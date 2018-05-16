%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-24 10:10:40
%%----------------------------------------------------
-module(pt_520).
-export([read/2, write/2]).

-include("common.hrl").
-include("day7login.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已经领取了"; 
err(3) ->"还不能领取"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(52000, _B0) ->
    {ok, {}};

read(52001, _B0) ->
    {P0_days, _B1} = proto:read_uint8(_B0),
    {ok, {P0_days}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取7天登陆信息 
write(52000, {P0_info_list}) ->
    D_a_t_a = <<(length(P0_info_list)):16, (list_to_binary([<<P1_days:8, P1_state:8, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_days, P1_state, P1_goods_list] <- P0_info_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 52000:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(52001, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 52001:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



