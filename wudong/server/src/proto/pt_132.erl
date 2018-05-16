%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_132).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"不能设置该百分比阈值"; 
err(3) ->"血包不存在"; 
err(4) ->"数量不足"; 
err(5) ->"银币不足，请前往副本获取"; 
err(6) ->"银币不足，请前往副本获取"; 
err(7) ->"该场景不能使用血池恢复血量"; 
err(8) ->"冷却中"; 
err(9) ->"血池没有血量了"; 
err(10) ->"当前血量未低于设置的百分比,无需恢复"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(13201, _B0) ->
    {ok, {}};

read(13202, _B0) ->
    {P0_recover, _B1} = proto:read_int8(_B0),
    {ok, {P0_recover}};

read(13203, _B0) ->
    {P0_goods_id, _B1} = proto:read_int32(_B0),
    {P0_num, _B2} = proto:read_int32(_B1),
    {ok, {P0_goods_id, P0_num}};

read(13204, _B0) ->
    {P0_goods_id, _B1} = proto:read_int32(_B0),
    {P0_num, _B2} = proto:read_int32(_B1),
    {ok, {P0_goods_id, P0_num}};

read(13205, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 血池信息 
write(13201, {P0_hp, P0_recover}) ->
    D_a_t_a = <<P0_hp:32/signed, P0_recover:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13201:16,0:8, D_a_t_a/binary>>};


%% 设置恢复阈值 
write(13202, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13202:16,0:8, D_a_t_a/binary>>};


%% 使用血包 
write(13203, {P0_code, P0_hp}) ->
    D_a_t_a = <<P0_code:8, P0_hp:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13203:16,0:8, D_a_t_a/binary>>};


%% 购买血包 
write(13204, {P0_code, P0_hp}) ->
    D_a_t_a = <<P0_code:8, P0_hp:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13204:16,0:8, D_a_t_a/binary>>};


%% 回血 
write(13205, {P0_code, P0_hp}) ->
    D_a_t_a = <<P0_code:8, P0_hp:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13205:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



