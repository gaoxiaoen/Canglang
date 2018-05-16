%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:19
%%----------------------------------------------------
-module(pt_600).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"野外普通场景才能进入首领场景"; 
err(3) ->"45级才会开放世界首领挑战"; 
err(4) ->" 护送中,不能进入"; 
err(5) ->"首领场景未开放"; 
err(6) ->"场景人数爆满，不能进入"; 
err(7) ->"不在首领场景中"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(60001, _B0) ->
    {ok, {}};

read(60002, _B0) ->
    {ok, {}};

read(60003, _B0) ->
    {ok, {}};

read(60004, _B0) ->
    {P0_scene_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_scene_id}};

read(60005, _B0) ->
    {ok, {}};

read(60006, _B0) ->
    {P0_scene_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_scene_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 世界boss状态 
write(60001, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60001:16,0:8, D_a_t_a/binary>>};


%% boss列表 
write(60002, {P0_state, P0_time, P0_boss_list}) ->
    D_a_t_a = <<P0_state:8, P0_time:32/signed, (length(P0_boss_list)):16, (list_to_binary([<<P1_scene:32/signed, P1_boss_id:32/signed, P1_type:8/signed, P1_boss_state:8/signed, P1_door:32/signed, P1_x:32/signed, P1_y:32/signed, P1_refresh_time:32/signed>> || [P1_scene, P1_boss_id, P1_type, P1_boss_state, P1_door, P1_x, P1_y, P1_refresh_time] <- P0_boss_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60002:16,0:8, D_a_t_a/binary>>};


%% boss伤害数据 
write(60003, {P0_my_damage, P0_my_rank, P0_my_gkey, P0_damage_list}) ->
    D_a_t_a = <<P0_my_damage:32/signed, P0_my_rank:16/signed, (proto:write_string(P0_my_gkey))/binary, (length(P0_damage_list)):16, (list_to_binary([<<P1_sn:32/signed, (proto:write_string(P1_nickname))/binary, P1_damage:32/signed, (proto:write_string(P1_gkey))/binary>> || [P1_sn, P1_nickname, P1_damage, P1_gkey] <- P0_damage_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60003:16,0:8, D_a_t_a/binary>>};


%% 进入boss场景 
write(60004, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60004:16,0:8, D_a_t_a/binary>>};


%% 退出boss场景 
write(60005, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60005:16,0:8, D_a_t_a/binary>>};


%% boss伤害排行榜 
write(60006, {P0_sn, P0_nickname}) ->
    D_a_t_a = <<P0_sn:32/signed, (proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60006:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



