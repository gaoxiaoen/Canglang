%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_320).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(32001, _B0) ->
    {P0_npcid, _B1} = proto:read_uint16(_B0),
    {P0_taskid, _B2} = proto:read_uint32(_B1),
    {ok, {P0_npcid, P0_taskid}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% NPC对话 
write(32001, {P0_npcid, P0_talkid, P0_taskid, P0_state, P0_goods, P0_funlist}) ->
    D_a_t_a = <<P0_npcid:16, P0_talkid:32, P0_taskid:32, P0_state:8/signed, (length(P0_goods)):16, (list_to_binary([<<P1_goodstype:32, P1_num:32>> || [P1_goodstype, P1_num] <- P0_goods]))/binary, (length(P0_funlist)):16, (list_to_binary([<<P1_funid:8>> || P1_funid <- P0_funlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 32001:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



