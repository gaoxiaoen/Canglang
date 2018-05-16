%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-01-08 18:06:26
%%----------------------------------------------------
-module(pt_442).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"非仙装类，不可穿戴"; 
err(3) ->"该道具已佩戴"; 
err(4) ->"已穿有相同部位道具"; 
err(5) ->"材料不足"; 
err(6) ->"元宝不足"; 
err(7) ->"进阶成功"; 
err(8) ->"已经升至最高等级"; 
err(9) ->"击杀怪物数量不足"; 
err(10) ->"副本为通关"; 
err(11) ->"当前部位未觉醒"; 
err(12) ->"觉醒至最高等级"; 
err(13) ->"兑换次数不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(44201, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_goods_key, P0_type}};

read(44202, _B0) ->
    {P0_list, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_goods_key, _B2} = proto:read_key(_B1),
        {P1_goods_key, _B2}
    end),
    {ok, {P0_list}};

read(44203, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_auto, _B2} = proto:read_uint8(_B1),
    {P0_cost, _B3} = proto:read_uint16(_B2),
    {ok, {P0_goods_key, P0_auto, P0_cost}};

read(44204, _B0) ->
    {ok, {}};

read(44205, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_go_map_num, _B2} = proto:read_uint8(_B1),
    {ok, {P0_type, P0_go_map_num}};

read(44206, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_goods_key, P0_type}};

read(44207, _B0) ->
    {ok, {}};

read(44208, _B0) ->
    {P0_task_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_task_id}};

read(44209, _B0) ->
    {ok, {}};

read(44210, _B0) ->
    {ok, {}};

read(44211, _B0) ->
    {ok, {}};

read(44212, _B0) ->
    {P0_exchange_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_exchange_id}};

read(44213, _B0) ->
    {ok, {}};

read(44214, _B0) ->
    {P0_subtype, _B1} = proto:read_uint16(_B0),
    {ok, {P0_subtype}};

read(44215, _B0) ->
    {ok, {}};

read(44216, _B0) ->
    {P0_goods_key1, _B1} = proto:read_key(_B0),
    {P0_goods_key2, _B2} = proto:read_key(_B1),
    {P0_pos1, _B3} = proto:read_uint8(_B2),
    {P0_pos2, _B4} = proto:read_uint8(_B3),
    {ok, {P0_goods_key1, P0_goods_key2, P0_pos1, P0_pos2}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 穿戴仙装 
write(44201, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44201:16,0:8, D_a_t_a/binary>>};


%% 分解仙装 
write(44202, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44202:16,0:8, D_a_t_a/binary>>};


%% 进阶仙装 
write(44203, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44203:16,0:8, D_a_t_a/binary>>};


%% 仙装寻宝信息 
write(44204, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_type:8, P1_cost_one:32, P1_cost_ten:32, P1_remain_num:8, P1_base_num:8, P1_remain_time:32>> || [P1_type, P1_cost_one, P1_cost_ten, P1_remain_num, P1_base_num, P1_remain_time] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44204:16,0:8, D_a_t_a/binary>>};


%% 寻宝 
write(44205, {P0_error_code, P0_list, P0_list2}) ->
    D_a_t_a = <<P0_error_code:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44205:16,0:8, D_a_t_a/binary>>};


%% 一键升阶 
write(44206, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44206:16,0:8, D_a_t_a/binary>>};


%% 仙阶任务数据 
write(44207, {P0_stage, P0_list}) ->
    D_a_t_a = <<P0_stage:8, (length(P0_list)):16, (list_to_binary([<<P1_task_id:16, P1_num:32, P1_base_num:32, P1_statu:8>> || [P1_task_id, P1_num, P1_base_num, P1_statu] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44207:16,0:8, D_a_t_a/binary>>};


%% 提交仙阶任务 
write(44208, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44208:16,0:8, D_a_t_a/binary>>};


%% 仙阶升阶 
write(44209, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44209:16,0:8, D_a_t_a/binary>>};


%% 仙装副本结算 
write(44210, {P0_ret, P0_dun_id, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_dun_id:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_state:32/signed>> || [P1_goods_id, P1_num, P1_state] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44210:16,0:8, D_a_t_a/binary>>};


%% 获取仙装兑换信息 
write(44211, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_exchange_id:8, P1_num:32, P1_base_num:32, (length(P1_cost_list)):16, (list_to_binary([<<P2_cost_goods_id:32, P2_cost_num:32>> || [P2_cost_goods_id, P2_cost_num] <- P1_cost_list]))/binary, (length(P1_get_list)):16, (list_to_binary([<<P2_get_goods_id:32, P2_get_num:32>> || [P2_get_goods_id, P2_get_num] <- P1_get_list]))/binary>> || [P1_exchange_id, P1_num, P1_base_num, P1_cost_list, P1_get_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44211:16,0:8, D_a_t_a/binary>>};


%% 兑换 
write(44212, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44212:16,0:8, D_a_t_a/binary>>};


%% 获取觉醒信息 
write(44213, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_subtype:16, P1_lv:8>> || [P1_subtype, P1_lv] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44213:16,0:8, D_a_t_a/binary>>};


%% 觉醒 
write(44214, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44214:16,0:8, D_a_t_a/binary>>};


%% 觉醒技能 
write(44215, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_skill_id:8>> || P1_skill_id <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44215:16,0:8, D_a_t_a/binary>>};


%% 交换仙练属性 
write(44216, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44216:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



