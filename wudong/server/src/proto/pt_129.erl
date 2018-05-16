%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-01-31 15:08:32
%%----------------------------------------------------
-module(pt_129).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"元宝不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(12901, _B0) ->
    {ok, {}};

read(12902, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%%  副本信息 
write(12901, {P0_challenge_num, P0_vip_challenge_num}) ->
    D_a_t_a = <<P0_challenge_num:8/signed, P0_vip_challenge_num:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12901:16,0:8, D_a_t_a/binary>>};


%% 精英bossVip副本玩法结算 
write(12902, {P0_code, P0_dun_id, P0_list}) ->
    D_a_t_a = <<P0_code:8, P0_dun_id:32, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12902:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



