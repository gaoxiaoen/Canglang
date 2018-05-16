%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-07-20 13:48:05
%%----------------------------------------------------
-module(pt_287).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"宴席类型不存在"; 
err(3) ->"该时间段不能预约宴席"; 
err(4) ->"改时间的宴席已被预约"; 
err(5) ->"您今日已预约过同类型宴席"; 
err(6) ->"元宝不足"; 
err(7) ->"等级不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(28701, _B0) ->
    {ok, {}};

read(28702, _B0) ->
    {ok, {}};

read(28703, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_day_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_type, P0_day_type}};

read(28704, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_day_type, _B2} = proto:read_uint8(_B1),
    {P0_id, _B3} = proto:read_int8(_B2),
    {P0_invite_guild, _B4} = proto:read_int8(_B3),
    {P0_invite_friend, _B5} = proto:read_int8(_B4),
    {ok, {P0_type, P0_day_type, P0_id, P0_invite_guild, P0_invite_friend}};

read(28705, _B0) ->
    {P0_party_key, _B1} = proto:read_key(_B0),
    {ok, {P0_party_key}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 晚宴状态(图标) 
write(28701, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8/signed, P0_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28701:16,0:8, D_a_t_a/binary>>};


%% 当前开启的晚宴列表 
write(28702, {P0_time, P0_list}) ->
    D_a_t_a = <<P0_time:32/signed, (length(P0_list)):16, (list_to_binary([<<P1_id:8, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, (proto:write_string(P1_avatar))/binary, P1_scene:32/signed, P1_x:8/signed, P1_y:8/signed, P1_is_enjoy:8/signed>> || [P1_id, P1_nickname, P1_career, P1_sex, P1_avatar, P1_scene, P1_x, P1_y, P1_is_enjoy] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28702:16,0:8, D_a_t_a/binary>>};


%% 晚宴预约列表 
write(28703, {P0_times, P0_time_list}) ->
    D_a_t_a = <<P0_times:8/signed, (length(P0_time_list)):16, (list_to_binary([<<P1_id:8/signed, P1_hour:8/signed, P1_min:8/signed, P1_state:8/signed>> || [P1_id, P1_hour, P1_min, P1_state] <- P0_time_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28703:16,0:8, D_a_t_a/binary>>};


%% 预约 
write(28704, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28704:16,0:8, D_a_t_a/binary>>};


%% 查看单场宴会信息 
write(28705, {P0_code, P0_type, P0_pkey, P0_nickname, P0_career, P0_sex, P0_avatar, P0_exp, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8/signed, P0_type:8/signed, P0_pkey:32/signed, (proto:write_string(P0_nickname))/binary, P0_career:8/signed, P0_sex:8/signed, (proto:write_string(P0_avatar))/binary, P0_exp:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28705:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



