%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-02-05 19:54:45
%%----------------------------------------------------
-module(pt_445).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"系统跨服节点维护，暂时不能进入"; 
err(3) ->"材料不足"; 
err(4) ->"首领尚未复活"; 
err(5) ->"等级不足"; 
err(6) ->"元宝不足"; 
err(7) ->"vip等级不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(44501, _B0) ->
    {ok, {}};

read(44502, _B0) ->
    {P0_scene_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_scene_id}};

read(44503, _B0) ->
    {P0_scene_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_scene_id}};

read(44504, _B0) ->
    {P0_scene_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_scene_id}};

read(44505, _B0) ->
    {ok, {}};

read(44506, _B0) ->
    {ok, {}};

read(44507, _B0) ->
    {ok, {}};

read(44508, _B0) ->
    {P0_buy_num, _B1} = proto:read_uint32(_B0),
    {ok, {P0_buy_num}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取精英boss面板信息 
write(44501, {P0_is_recv, P0_list, P0_vip_dun_list}) ->
    D_a_t_a = <<P0_is_recv:8, (length(P0_list)):16, (list_to_binary([<<P1_scene_id:32, P1_state:8, P1_refresh_cd_time:32>> || [P1_scene_id, P1_state, P1_refresh_cd_time] <- P0_list]))/binary, (length(P0_vip_dun_list)):16, (list_to_binary([<<P1_dun_id:32, P1_boss_id:32>> || [P1_dun_id, P1_boss_id] <- P0_vip_dun_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44501:16,0:8, D_a_t_a/binary>>};


%% 进入精英boss玩法 
write(44502, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44502:16,0:8, D_a_t_a/binary>>};


%% 退出精英boss玩法 
write(44503, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44503:16,0:8, D_a_t_a/binary>>};


%% 读取精英boss伤害数据 
write(44504, {P0_boss_state, P0_refresh_cd_time, P0_myrank, P0_mypercent, P0_list}) ->
    D_a_t_a = <<P0_boss_state:8, P0_refresh_cd_time:32, P0_myrank:16, P0_mypercent:32, (length(P0_list)):16, (list_to_binary([<<P1_rank:16, (proto:write_string(P1_nickname))/binary, P1_percent:32>> || [P1_rank, P1_nickname, P1_percent] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44504:16,0:8, D_a_t_a/binary>>};


%% 每日福利领取 
write(44505, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44505:16,0:8, D_a_t_a/binary>>};


%% 普通房间boss阵亡时间通知 
write(44506, {P0_CdTime}) ->
    D_a_t_a = <<P0_CdTime:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44506:16,0:8, D_a_t_a/binary>>};


%% 金令牌购买次数 
write(44507, {P0_buy_num, P0_price}) ->
    D_a_t_a = <<P0_buy_num:32, P0_price:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44507:16,0:8, D_a_t_a/binary>>};


%% 金令牌购买 
write(44508, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44508:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



