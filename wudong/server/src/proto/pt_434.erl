%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-03-30 17:19:56
%%----------------------------------------------------
-module(pt_434).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(43401, _B0) ->
    {ok, {}};

read(43402, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取系统评分数据 
write(43401, {P0_cbp, P0_percent, P0_TotalNum, P0_Num1, P0_Num2, P0_Num3, P0_type, P0_lv, P0_lv2, P0_list1, P0_list2}) ->
    D_a_t_a = <<P0_cbp:32, P0_percent:8, P0_TotalNum:8, P0_Num1:8, P0_Num2:8, P0_Num3:8, P0_type:8, P0_lv:16, P0_lv2:16, (length(P0_list1)):16, (list_to_binary([<<P1_type1:8, P1_val1:32>> || [P1_type1, P1_val1] <- P0_list1]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_type2:8, P1_val2:32, P1_score2:32>> || [P1_type2, P1_val2, P1_score2] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43401:16,0:8, D_a_t_a/binary>>};


%% 战力对比 
write(43402, {P0_nickname, P0_creer, P0_sex, P0_cbp, P0_lv, P0_avatar, P0_list, P0_list2}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, P0_creer:8, P0_sex:8, P0_cbp:32, P0_lv:16, (proto:write_string(P0_avatar))/binary, (length(P0_list)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_list]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_type2:8, P1_val2:32>> || [P1_type2, P1_val2] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43402:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



