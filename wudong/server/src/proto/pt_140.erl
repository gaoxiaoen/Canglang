%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_140).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"背包空间不足，不能提取"; 
err(3) ->"物品不足"; 
err(4) ->"祈祷背部空间不足，请预留20个位置"; 
err(5) ->"元宝不足"; 
err(6) ->"今日快速祈祷次数已经用完"; 
err(7) ->"该格子已经处于开启状态，无须再次开启"; 
err(8) ->"当前会员等级下快速祈祷次数已经使用完，每日次数不得大于会员等级"; 
err(15) ->"已经到了最大格子数量"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(14000, _B0) ->
    {ok, {}};

read(14001, _B0) ->
    {ok, {}};

read(14002, _B0) ->
    {ok, {}};

read(14003, _B0) ->
    {ok, {}};

read(14004, _B0) ->
    {ok, {}};

read(14005, _B0) ->
    {P0_open_cell, _B1} = proto:read_uint16(_B0),
    {ok, {P0_open_cell}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 奖励定时器 
write(14000, {P0_time}) ->
    D_a_t_a = <<P0_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 14000:16,0:8, D_a_t_a/binary>>};


%% 获取祈祷信息 
write(14001, {P0_fashion_id, P0_preview_fashion_id, P0_fashion_time, P0_quick_times, P0_quick_times_gold, P0_get_equip_time, P0_total_equip_time, P0_cell_num, P0_goods_list}) ->
    D_a_t_a = <<P0_fashion_id:32, P0_preview_fashion_id:32, P0_fashion_time:32, P0_quick_times:32, P0_quick_times_gold:32, P0_get_equip_time:32, P0_total_equip_time:32, P0_cell_num:16, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32, P1_state:8, (length(P1_wash_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_wash_attr]))/binary, (length(P1_stone_info)):16, (list_to_binary([<<P2_hole_type:8, P2_value:32>> || [P2_hole_type, P2_value] <- P1_stone_info]))/binary>> || [P1_goods_id, P1_num, P1_state, P1_wash_attr, P1_stone_info] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 14001:16,0:8, D_a_t_a/binary>>};


%% 提取祈祷装备 
write(14002, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 14002:16,0:8, D_a_t_a/binary>>};


%% 快速祈祷 
write(14003, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 14003:16,0:8, D_a_t_a/binary>>};


%% 购买时装 
write(14004, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 14004:16,0:8, D_a_t_a/binary>>};


%% 消耗元宝开格子 
write(14005, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 14005:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



