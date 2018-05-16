%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-11-01 17:40:01
%%----------------------------------------------------
-module(pt_162).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"玩家等级不足,法身未开启"; 
err(3) ->"法身已满阶"; 
err(4) ->"自动购买价格异常"; 
err(5) ->"元宝不足"; 
err(6) ->"物品数量不足"; 
err(7) ->"成功进阶"; 
err(8) ->"法身不存在"; 
err(9) ->"法身未解锁"; 
err(10) ->"技能已激活"; 
err(11) ->"技能栏不存在"; 
err(12) ->"阶数不足"; 
err(13) ->"物品数量不足"; 
err(14) ->"技能不存在"; 
err(15) ->"技能已满级"; 
err(16) ->"装备不存在"; 
err(17) ->"法身阶数不足"; 
err(18) ->"该装备不能装备在法身上"; 
err(19) ->"成长丹已达到使用上限"; 
err(20) ->"未达到成长丹使用阶数"; 
err(21) ->"成长丹不足"; 
err(22) ->"灵脉已满级"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(16201, _B0) ->
    {ok, {}};

read(16202, _B0) ->
    {P0_is_auto, _B1} = proto:read_int8(_B0),
    {ok, {P0_is_auto}};

read(16203, _B0) ->
    {P0_figure, _B1} = proto:read_int32(_B0),
    {ok, {P0_figure}};

read(16204, _B0) ->
    {P0_cell, _B1} = proto:read_uint8(_B0),
    {ok, {P0_cell}};

read(16205, _B0) ->
    {P0_cell, _B1} = proto:read_uint8(_B0),
    {ok, {P0_cell}};

read(16206, _B0) ->
    {ok, {}};

read(16207, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16208, _B0) ->
    {ok, {}};

read(16209, _B0) ->
    {ok, {}};

read(16210, _B0) ->
    {ok, {}};

read(16211, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 法身信息 
write(16201, {P0_stage, P0_exp, P0_cd, P0_figure, P0_cbp, P0_grow_num, P0_attribute_list, P0_skill_list, P0_equip_list, P0_spirit_state}) ->
    D_a_t_a = <<P0_stage:16/signed, P0_exp:32/signed, P0_cd:32/signed, P0_figure:32/signed, P0_cbp:32/signed, P0_grow_num:16, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary, (length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8, P1_skill_id:32, P1_skill_state:8/signed>> || [P1_cell, P1_skill_id, P1_skill_state] <- P0_skill_list]))/binary, (length(P0_equip_list)):16, (list_to_binary([<<P1_subtype:16/signed, P1_equip_id:32>> || [P1_subtype, P1_equip_id] <- P0_equip_list]))/binary, P0_spirit_state:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16201:16,0:8, D_a_t_a/binary>>};


%% 升阶 
write(16202, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16202:16,0:8, D_a_t_a/binary>>};


%% 切换形象 
write(16203, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16203:16,0:8, D_a_t_a/binary>>};


%% 激活技能 
write(16204, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16204:16,0:8, D_a_t_a/binary>>};


%% 升级技能 
write(16205, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16205:16,0:8, D_a_t_a/binary>>};


%% 技能列表更新 
write(16206, {P0_skill_list}) ->
    D_a_t_a = <<(length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8, P1_skill_id:32, P1_skill_state:8/signed>> || [P1_cell, P1_skill_id, P1_skill_state] <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16206:16,0:8, D_a_t_a/binary>>};


%% 穿上装备 
write(16207, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16207:16,0:8, D_a_t_a/binary>>};


%% 使用法身成长丹 
write(16208, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16208:16,0:8, D_a_t_a/binary>>};


%% 领取法身 
write(16209, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16209:16,0:8, D_a_t_a/binary>>};


%% 灵脉信息 
write(16210, {P0_stage, P0_cur_type, P0_type_list, P0_cbp, P0_attr_list, P0_spirit}) ->
    D_a_t_a = <<P0_stage:8, P0_cur_type:32/signed, (length(P0_type_list)):16, (list_to_binary([<<P1_type:32/signed, P1_lv:32/signed>> || [P1_type, P1_lv] <- P0_type_list]))/binary, P0_cbp:32, (length(P0_attr_list)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_attr_list]))/binary, P0_spirit:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16210:16,0:8, D_a_t_a/binary>>};


%% 升级灵脉 
write(16211, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16211:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



