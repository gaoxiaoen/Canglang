%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:19
%%----------------------------------------------------
-module(pt_620).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"普通野外场景才能进入"; 
err(3) ->"服务器繁忙,稍后重试"; 
err(4) ->"活动未开启"; 
err(5) ->"不在猎场中"; 
err(6) ->"等级不足45级,不能进入"; 
err(7) ->"场景人物爆满,不能进入"; 
err(8) ->"目标不存在"; 
err(9) ->"目标未达成"; 
err(10) ->"奖励已领取"; 
err(11) ->"护送中,不能进入"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(62001, _B0) ->
    {ok, {}};

read(62002, _B0) ->
    {ok, {}};

read(62003, _B0) ->
    {ok, {}};

read(62004, _B0) ->
    {ok, {}};

read(62005, _B0) ->
    {ok, {}};

read(62006, _B0) ->
    {ok, {}};

read(62007, _B0) ->
    {P0_copy, _B1} = proto:read_int8(_B0),
    {ok, {P0_copy}};

read(62008, _B0) ->
    {P0_goods_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_goods_id}};

read(62009, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 查询活动状态 
write(62001, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 62001:16,0:8, D_a_t_a/binary>>};


%% 请求进入 
write(62002, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 62002:16,0:8, D_a_t_a/binary>>};


%% 请求退出 
write(62003, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 62003:16,0:8, D_a_t_a/binary>>};


%% 任务目标信息 
write(62004, {P0_target_list}) ->
    D_a_t_a = <<(length(P0_target_list)):16, (list_to_binary([<<P1_mid:32/signed, P1_goods_id:32/signed, P1_num:8/signed, P1_cur:8/signed, P1_is_reward:8/signed>> || [P1_mid, P1_goods_id, P1_num, P1_cur, P1_is_reward] <- P0_target_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 62004:16,0:8, D_a_t_a/binary>>};


%% boss数据 
write(62005, {P0_state, P0_time, P0_mydamage, P0_myrank, P0_top_list}) ->
    D_a_t_a = <<P0_state:8/signed, P0_time:16/signed, P0_mydamage:32/signed, P0_myrank:16/signed, (length(P0_top_list)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_damage:32/signed, P1_rank:16/signed, (proto:write_string(P1_gkey))/binary>> || [P1_nickname, P1_damage, P1_rank, P1_gkey] <- P0_top_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 62005:16,0:8, D_a_t_a/binary>>};


%% 猎场线路 
write(62006, {P0_my_copy, P0_copy_list}) ->
    D_a_t_a = <<P0_my_copy:8/signed, (length(P0_copy_list)):16, (list_to_binary([<<P1_copy:8/signed, P1_cur_count:8/signed, P1_max_count:8/signed, P1_g_count:8/signed>> || [P1_copy, P1_cur_count, P1_max_count, P1_g_count] <- P0_copy_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 62006:16,0:8, D_a_t_a/binary>>};


%% 切换线路 
write(62007, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 62007:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(62008, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_r_gid:32/signed, P1_r_num:32/signed>> || [P1_r_gid, P1_r_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 62008:16,0:8, D_a_t_a/binary>>};


%% 获取已获得的奖励列表 
write(62009, {P0_state, P0_goods_list}) ->
    D_a_t_a = <<P0_state:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_r_gid:32/signed, P1_r_num:32/signed>> || [P1_r_gid, P1_r_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 62009:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



