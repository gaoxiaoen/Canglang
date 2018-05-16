%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-03-12 14:42:21
%%----------------------------------------------------
-module(pt_405).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"未加入仙盟"; 
err(3) ->"您所在仙盟没有题可回答"; 
err(4) ->"题目不存在"; 
err(5) ->"答案错误"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(40501, _B0) ->
    {ok, {}};

read(40502, _B0) ->
    {ok, {}};

read(40503, _B0) ->
    {P0_qid, _B1} = proto:read_int16(_B0),
    {P0_answer, _B2} = proto:read_string(_B1),
    {ok, {P0_qid, P0_answer}};

read(40504, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 活动状态 
write(40501, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40501:16,0:8, D_a_t_a/binary>>};


%% 获取题目信息 
write(40502, {P0_state, P0_qid, P0_time, P0_num, P0_pkey, P0_nickname}) ->
    D_a_t_a = <<P0_state:8/signed, P0_qid:16/signed, P0_time:8/signed, P0_num:8/signed, P0_pkey:32/signed, (proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40502:16,0:8, D_a_t_a/binary>>};


%% 答题 
write(40503, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40503:16,0:8, D_a_t_a/binary>>};


%% 通知答题结果 
write(40504, {P0_qid, P0_answer, P0_pkey, P0_nickname}) ->
    D_a_t_a = <<P0_qid:16/signed, (proto:write_string(P0_answer))/binary, P0_pkey:32/signed, (proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40504:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



