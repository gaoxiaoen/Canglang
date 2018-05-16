%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-05-14 16:01:16
%%----------------------------------------------------
-module(pt_100).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"限制登陆"; 
err(3) ->"验证错误"; 
err(4) ->"角色不存在"; 
err(5) ->"非法字符串"; 
err(6) ->"请输入6-12字节内的玩家昵称"; 
err(7) ->"名字已存在"; 
err(8) ->"请求过于频繁"; 
err(9) ->"包含敏感词"; 
err(10) ->"账号重复登陆"; 
err(11) ->"系统踢出请联系游戏管理员"; 
err(12) ->"服务器维护中，请稍后再登录。"; 
err(13) ->"重要更新 "; 
err(14) ->"角色初始化失败"; 
err(15) ->"登陆账号不一致"; 
err(16) ->"玩家信息不存在"; 
err(17) ->"网络异常,请重新登录"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(10000, _B0) ->
    {P0_ts, _B1} = proto:read_uint32(_B0),
    {P0_accname, _B2} = proto:read_string(_B1),
    {P0_pf, _B3} = proto:read_uint32(_B2),
    {P0_ticket, _B4} = proto:read_string(_B3),
    {ok, {P0_ts, P0_accname, P0_pf, P0_ticket}};

read(10002, _B0) ->
    {ok, {}};

read(10003, _B0) ->
    {P0_career, _B1} = proto:read_uint8(_B0),
    {P0_sex, _B2} = proto:read_uint8(_B1),
    {P0_nickname, _B3} = proto:read_string(_B2),
    {P0_source, _B4} = proto:read_string(_B3),
    {P0_pf, _B5} = proto:read_int32(_B4),
    {P0_phoneId, _B6} = proto:read_string(_B5),
    {P0_os, _B7} = proto:read_string(_B6),
    {P0_game_channel_id, _B8} = proto:read_int32(_B7),
    {P0_game_id, _B9} = proto:read_int32(_B8),
    {ok, {P0_career, P0_sex, P0_nickname, P0_source, P0_pf, P0_phoneId, P0_os, P0_game_channel_id, P0_game_id}};

read(10004, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_ts, _B2} = proto:read_uint32(_B1),
    {P0_ticket, _B3} = proto:read_string(_B2),
    {P0_login_flag, _B4} = proto:read_string(_B3),
    {ok, {P0_pkey, P0_ts, P0_ticket, P0_login_flag}};

read(10008, _B0) ->
    {ok, {}};

read(10009, _B0) ->
    {ok, {}};

read(10010, _B0) ->
    {P0_accname, _B1} = proto:read_string(_B0),
    {P0_pf, _B2} = proto:read_int32(_B1),
    {ok, {P0_accname, P0_pf}};

read(10011, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 登陆游戏 
write(10000, {P0_code, P0_ts}) ->
    D_a_t_a = <<P0_code:8/signed, P0_ts:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 10000:16,0:8, D_a_t_a/binary>>};


%% 获取角色列表 
write(10002, {P0_plist}) ->
    D_a_t_a = <<(length(P0_plist)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8, P1_sex:8, P1_lv:16, P1_mount_id:32, P1_wing_id:32, P1_wepon_id:32, P1_clothing_id:32, P1_light_wepon_id:32, P1_fashion_cloth_id:32, P1_footprint_id:32, P1_cbp:32, P1_fashion_head_id:32, P1_vip_lv:32, P1_dvip:32, P1_sn:32, (proto:write_string(P1_sn_name))/binary>> || [P1_pkey, P1_nickname, P1_career, P1_sex, P1_lv, P1_mount_id, P1_wing_id, P1_wepon_id, P1_clothing_id, P1_light_wepon_id, P1_fashion_cloth_id, P1_footprint_id, P1_cbp, P1_fashion_head_id, P1_vip_lv, P1_dvip, P1_sn, P1_sn_name] <- P0_plist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 10002:16,0:8, D_a_t_a/binary>>};


%% 创建角色 
write(10003, {P0_code, P0_pkey}) ->
    D_a_t_a = <<P0_code:8/signed, P0_pkey:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 10003:16,0:8, D_a_t_a/binary>>};


%% 进入游戏 
write(10004, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 10004:16,0:8, D_a_t_a/binary>>};


%% 游戏断开提示 
write(10008, {P0_code, P0_allow}) ->
    D_a_t_a = <<P0_code:8/signed, P0_allow:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 10008:16,0:8, D_a_t_a/binary>>};


%% 心跳包 
write(10009, {P0_ts}) ->
    D_a_t_a = <<P0_ts:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 10009:16,0:8, D_a_t_a/binary>>};


%% 获取排队信息 
write(10010, {P0_queue_num, P0_status}) ->
    D_a_t_a = <<P0_queue_num:32/signed, P0_status:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 10010:16,0:8, D_a_t_a/binary>>};


%% 服务器重启通知 
write(10011, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 10011:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



