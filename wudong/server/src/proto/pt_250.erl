%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_250).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"背包空间不够"; 
err(3) ->"冷却时间未到"; 
err(4) ->"淘宝背包不足"; 
err(5) ->"元宝不足"; 
err(6) ->"物品不存在"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(25001, _B0) ->
    {ok, {}};

read(25002, _B0) ->
    {ok, {}};

read(25003, _B0) ->
    {P0_times, _B1} = proto:read_int8(_B0),
    {ok, {P0_times}};

read(25004, _B0) ->
    {ok, {}};

read(25005, _B0) ->
    {ok, {}};

read(25006, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(25007, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取玩家淘宝背包基础信息 
write(25001, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_goods_id:32, P1_num:32, P1_is_bind:8>> || [P1_key, P1_goods_id, P1_num, P1_is_bind] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 25001:16,0:8, D_a_t_a/binary>>};


%% 淘宝物品列表更新 
write(25002, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_goods_id:32, P1_num:32, P1_is_bind:8>> || [P1_key, P1_goods_id, P1_num, P1_is_bind] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 25002:16,0:8, D_a_t_a/binary>>};


%% 淘宝 
write(25003, {P0_error_code, P0_goods_id_list}) ->
    D_a_t_a = <<P0_error_code:8, (length(P0_goods_id_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:16, P1_is_luck:8>> || [P1_goods_id, P1_num, P1_is_luck] <- P0_goods_id_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 25003:16,0:8, D_a_t_a/binary>>};


%% 获取自己淘出的物品记录 
write(25004, {P0_goods_id_list}) ->
    D_a_t_a = <<(length(P0_goods_id_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_goods_id_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 25004:16,0:8, D_a_t_a/binary>>};


%% 获取最近公共淘出的物品记录 
write(25005, {P0_goods_id_list}) ->
    D_a_t_a = <<(length(P0_goods_id_list)):16, (list_to_binary([<<(proto:write_string(P1_name))/binary, P1_goods_id:32>> || [P1_name, P1_goods_id] <- P0_goods_id_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 25005:16,0:8, D_a_t_a/binary>>};


%% 从淘宝仓库转移物品到玩家背包 
write(25006, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 25006:16,0:8, D_a_t_a/binary>>};


%% 淘宝面板信息更新 
write(25007, {P0_luck_value, P0_goods_num, P0_today_free_times}) ->
    D_a_t_a = <<P0_luck_value:16, P0_goods_num:16, (length(P0_today_free_times)):16, (list_to_binary([<<P1_type:8, P1_times:8, P1_count_down:32, P1_money:16>> || [P1_type, P1_times, P1_count_down, P1_money] <- P0_today_free_times]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 25007:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



