%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-04-18 15:13:59
%%----------------------------------------------------
-module(pt_133).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"元宝不足"; 
err(3) ->"已达到今日购买上限"; 
err(4) ->"钻石vip玩家才可扫荡"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(13301, _B0) ->
    {ok, {}};

read(13302, _B0) ->
    {ok, {}};

read(13303, _B0) ->
    {ok, {}};

read(13304, _B0) ->
    {ok, {}};

read(13305, _B0) ->
    {ok, {}};

read(13306, _B0) ->
    {ok, {}};

read(13307, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_goods_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取元素副本列表 
write(13301, {P0_dun_list}) ->
    D_a_t_a = <<(length(P0_dun_list)):16, (list_to_binary([<<P1_dun_id:32, P1_state:8>> || [P1_dun_id, P1_state] <- P0_dun_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13301:16,0:8, D_a_t_a/binary>>};


%% 元素副本挑战结果 
write(13302, {P0_code, P0_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13302:16,0:8, D_a_t_a/binary>>};


%% 获取剑道副本列表 
write(13303, {P0_remain_num, P0_cost_remain_num, P0_max_cost_num, P0_goods_id, P0_goods_num, P0_goods_price, P0_dun_list}) ->
    D_a_t_a = <<P0_remain_num:8, P0_cost_remain_num:8, P0_max_cost_num:8, P0_goods_id:32, P0_goods_num:32, P0_goods_price:32, (length(P0_dun_list)):16, (list_to_binary([<<P1_dun_id:32, P1_state:8>> || [P1_dun_id, P1_state] <- P0_dun_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13303:16,0:8, D_a_t_a/binary>>};


%% 剑道副本目标 
write(13304, {P0_round, P0_mon, P0_max_mon, P0_remain_time, P0_score}) ->
    D_a_t_a = <<P0_round:8, P0_mon:16, P0_max_mon:16, P0_remain_time:32, P0_score:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13304:16,0:8, D_a_t_a/binary>>};


%% 剑道副本结算 
write(13305, {P0_code, P0_score, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8, P0_score:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13305:16,0:8, D_a_t_a/binary>>};


%% 元素副本扫荡 
write(13306, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13306:16,0:8, D_a_t_a/binary>>};


%% 剑道副本道具购买 
write(13307, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13307:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



