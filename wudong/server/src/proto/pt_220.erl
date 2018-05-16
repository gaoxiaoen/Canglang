%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-05-05 17:24:51
%%----------------------------------------------------
-module(pt_220).
-export([read/2, write/2]).

-include("common.hrl").
-include("team.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已经加入队伍"; 
err(3) ->"没有加入队伍"; 
err(4) ->"不是队长"; 
err(5) ->"队伍不存在"; 
err(6) ->"队伍成员不存在"; 
err(7) ->"队伍人数已满"; 
err(8) ->"不在同一队伍"; 
err(9) ->"你被请出了队伍"; 
err(10) ->"招募信息不存在"; 
err(11) ->"银两不足以支付发布招募费用"; 
err(12) ->"玩家离线"; 
err(13) ->"不能踢出自己"; 
err(14) ->"28级才可邀请组队"; 
err(15) ->"对方等级不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(22001, _B0) ->
    {ok, {}};

read(22002, _B0) ->
    {ok, {}};

read(22003, _B0) ->
    {ok, {}};

read(22004, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(22005, _B0) ->
    {ok, {}};

read(22006, _B0) ->
    {P0_ret, _B1} = proto:read_int8(_B0),
    {P0_tkey, _B2} = proto:read_key(_B1),
    {P0_pkey, _B3} = proto:read_uint32(_B2),
    {ok, {P0_ret, P0_tkey, P0_pkey}};

read(22007, _B0) ->
    {P0_tkey, _B1} = proto:read_key(_B0),
    {ok, {P0_tkey}};

read(22008, _B0) ->
    {ok, {}};

read(22009, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(22010, _B0) ->
    {ok, {}};

read(22011, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(22012, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(22013, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(22014, _B0) ->
    {ok, {}};

read(22015, _B0) ->
    {ok, {}};

read(22016, _B0) ->
    {ok, {}};

read(22017, _B0) ->
    {P0_ret, _B1} = proto:read_int8(_B0),
    {P0_pkey, _B2} = proto:read_uint32(_B1),
    {ok, {P0_ret, P0_pkey}};

read(22018, _B0) ->
    {ok, {}};

read(22019, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取场景队伍列表 
write(22001, {P0_team_list}) ->
    D_a_t_a = <<(length(P0_team_list)):16, (list_to_binary([<<(proto:write_string(P1_tkey))/binary, (proto:write_string(P1_tname))/binary, P1_pkey:32, P1_career:8/signed, P1_lv:16/signed, P1_cbp:32/signed, P1_num:8/signed, P1_max:8/signed, (proto:write_string(P1_avatar))/binary, (proto:write_string(P1_guild_name))/binary>> || [P1_tkey, P1_tname, P1_pkey, P1_career, P1_lv, P1_cbp, P1_num, P1_max, P1_avatar, P1_guild_name] <- P0_team_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22001:16,0:8, D_a_t_a/binary>>};


%% 创建队伍 
write(22002, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22002:16,0:8, D_a_t_a/binary>>};


%% 获取队伍成员信息 
write(22003, {P0_mb_list}) ->
    D_a_t_a = <<(length(P0_mb_list)):16, (list_to_binary([<<P1_pkey:32, P1_sn_cur:32, (proto:write_string(P1_pname))/binary, P1_realm:8/signed, P1_career:8/signed, P1_cbp:32/signed, P1_lv:16/signed, (proto:write_string(P1_guild_name))/binary, P1_vip:8/signed, P1_leader:8/signed, P1_is_online:8/signed, P1_scene:32/signed, P1_copy:8/signed, P1_x:8/signed, P1_y:8/signed, P1_hp:32/signed, P1_hp_lim:32/signed, P1_fashion_cloth_id:32/signed, P1_light_weaponid:32/signed, P1_wing_id:32/signed, P1_clothing_id:32/signed, P1_weapon_id:32/signed, P1_pet_type_id:32/signed, P1_petfigure:32/signed, (proto:write_string(P1_pet_name))/binary, (proto:write_string(P1_avatar))/binary, P1_fashion_head_id:32/signed, P1_sex:8/signed>> || [P1_pkey, P1_sn_cur, P1_pname, P1_realm, P1_career, P1_cbp, P1_lv, P1_guild_name, P1_vip, P1_leader, P1_is_online, P1_scene, P1_copy, P1_x, P1_y, P1_hp, P1_hp_lim, P1_fashion_cloth_id, P1_light_weaponid, P1_wing_id, P1_clothing_id, P1_weapon_id, P1_pet_type_id, P1_petfigure, P1_pet_name, P1_avatar, P1_fashion_head_id, P1_sex] <- P0_mb_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22003:16,0:8, D_a_t_a/binary>>};


%% 邀请玩家入队 
write(22004, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22004:16,0:8, D_a_t_a/binary>>};


%% 收到组队邀请 
write(22005, {P0_pkey, P0_name, P0_tkey}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_name))/binary, (proto:write_string(P0_tkey))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22005:16,0:8, D_a_t_a/binary>>};


%% 邀请确认 
write(22006, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22006:16,0:8, D_a_t_a/binary>>};


%% 申请进队 
write(22007, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22007:16,0:8, D_a_t_a/binary>>};


%% 退出队伍 
write(22008, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22008:16,0:8, D_a_t_a/binary>>};


%% 踢出队伍 
write(22009, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22009:16,0:8, D_a_t_a/binary>>};


%% 解散队伍 
write(22010, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22010:16,0:8, D_a_t_a/binary>>};


%% 转让队长 
write(22011, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22011:16,0:8, D_a_t_a/binary>>};


%% 可邀请玩家列表 
write(22012, {P0_player_list}) ->
    D_a_t_a = <<(length(P0_player_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_vip:8/signed, P1_lv:16/signed, P1_cbp:32/signed, (proto:write_string(P1_avatar))/binary, (proto:write_string(P1_guild_name))/binary, P1_sex:8/signed>> || [P1_pkey, P1_pname, P1_vip, P1_lv, P1_cbp, P1_avatar, P1_guild_name, P1_sex] <- P0_player_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22012:16,0:8, D_a_t_a/binary>>};


%% 发布队伍招募 
write(22013, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22013:16,0:8, D_a_t_a/binary>>};


%% 更新队伍成员位置信息 
write(22014, {P0_pkey, P0_scene, P0_copy, P0_x, P0_y, P0_hp, P0_hp_lim}) ->
    D_a_t_a = <<P0_pkey:32, P0_scene:32/signed, P0_copy:8/signed, P0_x:8/signed, P0_y:8/signed, P0_hp:32/signed, P0_hp_lim:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22014:16,0:8, D_a_t_a/binary>>};


%% 拒绝进队返回 
write(22015, {P0_pname}) ->
    D_a_t_a = <<(proto:write_string(P0_pname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22015:16,0:8, D_a_t_a/binary>>};


%% 收到组队申请 
write(22016, {P0_pkey, P0_pname, P0_guild_name, P0_lv, P0_cbp}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_pname))/binary, (proto:write_string(P0_guild_name))/binary, (proto:write_string(P0_lv))/binary, (proto:write_string(P0_cbp))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22016:16,0:8, D_a_t_a/binary>>};


%% 处理申请 
write(22017, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22017:16,0:8, D_a_t_a/binary>>};


%% 队伍人员变动 
write(22018, {P0_code, P0_pkey, P0_pname}) ->
    D_a_t_a = <<P0_code:8, P0_pkey:32, (proto:write_string(P0_pname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22018:16,0:8, D_a_t_a/binary>>};


%% 快速加入 
write(22019, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 22019:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



