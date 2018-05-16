%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_101).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(10101, _B0) ->
    {P0_uid, _B1} = proto:read_string(_B0),
    {P0_sessionid, _B2} = proto:read_string(_B1),
    {P0_channelid, _B3} = proto:read_string(_B2),
    {ok, {P0_uid, P0_sessionid, P0_channelid}};

read(10102, _B0) ->
    {P0_appkey, _B1} = proto:read_uint32(_B0),
    {P0_authorizecode, _B2} = proto:read_string(_B1),
    {P0_channelid, _B3} = proto:read_string(_B2),
    {ok, {P0_appkey, P0_authorizecode, P0_channelid}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 登陆君海sdk 
write(10101, {P0_code, P0_ts, P0_accname, P0_json}) ->
    D_a_t_a = <<P0_code:8/signed, P0_ts:32, (proto:write_string(P0_accname))/binary, (proto:write_string(P0_json))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 10101:16,0:8, D_a_t_a/binary>>};


%% 登陆君海sdk正版 
write(10102, {P0_code, P0_ts, P0_accname, P0_json}) ->
    D_a_t_a = <<P0_code:8/signed, P0_ts:32, (proto:write_string(P0_accname))/binary, (proto:write_string(P0_json))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 10102:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



