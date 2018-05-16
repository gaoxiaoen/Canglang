%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-05-18 23:04:41
%%----------------------------------------------------
-module(pt_401).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"未加入仙盟"; 
err(3) ->"建筑未解锁"; 
err(4) ->"任务不存在"; 
err(5) ->"随从不存在"; 
err(6) ->"有随从工作中"; 
err(7) ->"任务进行中"; 
err(8) ->"宝箱不存在"; 
err(9) ->"宝箱奖励已领取"; 
err(10) ->"该物品未解锁"; 
err(11) ->"购买的物品数量需要大于0"; 
err(12) ->"家园物资不足"; 
err(13) ->"随从卡不存在"; 
err(14) ->"随从已激活"; 
err(15) ->"随从不在工作中"; 
err(16) ->"该随从处于正常状态"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(40101, _B0) ->
    {ok, {}};

read(40102, _B0) ->
    {ok, {}};

read(40103, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(40104, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_task_id, _B2} = proto:read_int32(_B1),
    {P0_retinue_list, _B5} = proto:read_array(_B2, fun(_B3) ->
        {P1_key, _B4} = proto:read_key(_B3),
        {P1_key, _B4}
    end),
    {ok, {P0_type, P0_task_id, P0_retinue_list}};

read(40105, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_key, _B2} = proto:read_key(_B1),
    {ok, {P0_type, P0_key}};

read(40106, _B0) ->
    {ok, {}};

read(40107, _B0) ->
    {P0_goods_id, _B1} = proto:read_int32(_B0),
    {P0_num, _B2} = proto:read_int32(_B1),
    {ok, {P0_goods_id, P0_num}};

read(40108, _B0) ->
    {P0_goods_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_goods_id}};

read(40109, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 家园总览 
write(40101, {P0_contrib, P0_contrib_lim, P0_lv, P0_exp, P0_exp_lim, P0_building_list, P0_log_list}) ->
    D_a_t_a = <<P0_contrib:32/signed, P0_contrib_lim:32/signed, P0_lv:8/signed, P0_exp:32/signed, P0_exp_lim:32/signed, (length(P0_building_list)):16, (list_to_binary([<<P1_type:32/signed, P1_b_lv:8/signed, P1_b_exp:32/signed, P1_b_exp_lim:32/signed, P1_manor_lv:8/signed, (length(P1_box_list)):16, (list_to_binary([<<(proto:write_string(P2_box_key))/binary>> || P2_box_key <- P1_box_list]))/binary, (length(P1_retinue_list)):16, (list_to_binary([<<(proto:write_string(P2_r_key))/binary, P2_r_id:32/signed, P2_r_state:32/signed>> || [P2_r_key, P2_r_id, P2_r_state] <- P1_retinue_list]))/binary>> || [P1_type, P1_b_lv, P1_b_exp, P1_b_exp_lim, P1_manor_lv, P1_box_list, P1_retinue_list] <- P0_building_list]))/binary, (length(P0_log_list)):16, (list_to_binary([<<(proto:write_string(P1_msg))/binary, P1_time:32/signed>> || [P1_msg, P1_time] <- P0_log_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40101:16,0:8, D_a_t_a/binary>>};


%% 随从列表 
write(40102, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_type:8/signed, (length(P1_list)):16, (list_to_binary([<<(proto:write_string(P2_key))/binary, P2_id:32/signed, P2_state:8/signed, P2_work_state:8/signed>> || [P2_key, P2_id, P2_state, P2_work_state] <- P1_list]))/binary>> || [P1_type, P1_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40102:16,0:8, D_a_t_a/binary>>};


%% 建筑任务 
write(40103, {P0_refresh_time, P0_task_list}) ->
    D_a_t_a = <<P0_refresh_time:32/signed, (length(P0_task_list)):16, (list_to_binary([<<(proto:write_string(P1_task_id))/binary, P1_time:32/signed, P1_ratio:8/signed, (length(P1_retinue_list)):16, (list_to_binary([<<P2_id:32/signed>> || P2_id <- P1_retinue_list]))/binary, P1_team_ratio:8/signed, (length(P1_team_talent_list)):16, (list_to_binary([<<P2_talent_id:32/signed>> || P2_talent_id <- P1_team_talent_list]))/binary>> || [P1_task_id, P1_time, P1_ratio, P1_retinue_list, P1_team_ratio, P1_team_talent_list] <- P0_task_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40103:16,0:8, D_a_t_a/binary>>};


%% 开始任务 
write(40104, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40104:16,0:8, D_a_t_a/binary>>};


%% 宝箱奖励 
write(40105, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40105:16,0:8, D_a_t_a/binary>>};


%% 商店列表 
write(40106, {P0_manor_pt, P0_shop_list}) ->
    D_a_t_a = <<P0_manor_pt:32/signed, (length(P0_shop_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_price:32/signed, P1_state:8/signed>> || [P1_goods_id, P1_price, P1_state] <- P0_shop_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40106:16,0:8, D_a_t_a/binary>>};


%% 商店购买 
write(40107, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40107:16,0:8, D_a_t_a/binary>>};


%% 激活随从 
write(40108, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40108:16,0:8, D_a_t_a/binary>>};


%% 清除随从负面状态 
write(40109, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40109:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



