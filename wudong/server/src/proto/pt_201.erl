%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-04-13 19:34:20
%%----------------------------------------------------
-module(pt_201).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"图鉴不存在"; 
err(3) ->"数量不足"; 
err(4) ->"图鉴已满级"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(20101, _B0) ->
    {ok, {}};

read(20102, _B0) ->
    {P0_scene_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_scene_id}};

read(20103, _B0) ->
    {P0_mid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_mid}};

read(20104, _B0) ->
    {P0_mid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_mid}};

read(20105, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 图鉴总览 
write(20101, {P0_cbp, P0_attribute_list, P0_photo_list}) ->
    D_a_t_a = <<P0_cbp:32/signed, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary, (length(P0_photo_list)):16, (list_to_binary([<<P1_type:8/signed, (length(P1_scene_list)):16, (list_to_binary([<<P2_scene_id:32/signed, P2_state:8/signed>> || [P2_scene_id, P2_state] <- P1_scene_list]))/binary>> || [P1_type, P1_scene_list] <- P0_photo_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20101:16,0:8, D_a_t_a/binary>>};


%% 图鉴列表 
write(20102, {P0_mon_list}) ->
    D_a_t_a = <<(length(P0_mon_list)):16, (list_to_binary([<<P1_mon_id:32/signed, P1_lv:16/signed, P1_num:32/signed, P1_num_lim:32/signed, P1_state:8/signed>> || [P1_mon_id, P1_lv, P1_num, P1_num_lim, P1_state] <- P0_mon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20102:16,0:8, D_a_t_a/binary>>};


%% 升级 
write(20103, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20103:16,0:8, D_a_t_a/binary>>};


%% 升级更新单怪物信息(推送) 
write(20104, {P0_mid, P0_lv, P0_num, P0_num_lim, P0_state, P0_cbp, P0_attribute_list}) ->
    D_a_t_a = <<P0_mid:32, P0_lv:16/signed, P0_num:32/signed, P0_num_lim:32/signed, P0_state:8/signed, P0_cbp:32/signed, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20104:16,0:8, D_a_t_a/binary>>};


%% 图鉴获得通知 
write(20105, {P0_mid, P0_num}) ->
    D_a_t_a = <<P0_mid:32, P0_num:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20105:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



