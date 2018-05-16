%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-03-23 15:09:30
%%----------------------------------------------------
-module(pt_448).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已是最高等级"; 
err(3) ->"材料不足"; 
err(4) ->"请先升级"; 
err(5) ->"已满阶"; 
err(6) ->"等级不足"; 
err(7) ->"该位置已有穿戴元素"; 
err(8) ->"元素暂未激活"; 
err(9) ->"已满级"; 
err(10) ->"元素暂未解锁"; 
err(11) ->"装备位置已满,请先升阶"; 
err(12) ->"该元素已穿戴在身上"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(44801, _B0) ->
    {ok, {}};

read(44802, _B0) ->
    {ok, {}};

read(44803, _B0) ->
    {ok, {}};

read(44804, _B0) ->
    {ok, {}};

read(44805, _B0) ->
    {P0_rece, _B1} = proto:read_uint8(_B0),
    {ok, {P0_rece}};

read(44806, _B0) ->
    {P0_rece, _B1} = proto:read_uint8(_B0),
    {ok, {P0_rece}};

read(44807, _B0) ->
    {P0_rece, _B1} = proto:read_uint8(_B0),
    {ok, {P0_rece}};

read(44808, _B0) ->
    {P0_rece, _B1} = proto:read_uint8(_B0),
    {P0_pos, _B2} = proto:read_uint8(_B1),
    {ok, {P0_rece, P0_pos}};

read(44809, _B0) ->
    {P0_rece, _B1} = proto:read_uint8(_B0),
    {P0_pos, _B2} = proto:read_uint8(_B1),
    {ok, {P0_rece, P0_pos}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取当前剑道信息 
write(44801, {P0_stage, P0_point_id, P0_lv, P0_unlock_hole_num, P0_list, P0_attr_list1, P0_attr_list2}) ->
    D_a_t_a = <<P0_stage:8, P0_point_id:8, P0_lv:8, P0_unlock_hole_num:8, (length(P0_list)):16, (list_to_binary([<<P1_race:8, P1_pos:8>> || [P1_race, P1_pos] <- P0_list]))/binary, (length(P0_attr_list1)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_attr_list1]))/binary, (length(P0_attr_list2)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_attr_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44801:16,0:8, D_a_t_a/binary>>};


%% 剑道升级 
write(44802, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44802:16,0:8, D_a_t_a/binary>>};


%% 剑道升阶 
write(44803, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44803:16,0:8, D_a_t_a/binary>>};


%% 元素列表 
write(44804, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_race:8, P1_lv:16, P1_e_lv:16, P1_stage:8, (length(P1_attr_list1)):16, (list_to_binary([<<P2_attr_type:8, P2_value:32>> || [P2_attr_type, P2_value] <- P1_attr_list1]))/binary, (length(P1_attr_list2)):16, (list_to_binary([<<P2_attr_type:8, P2_value:32>> || [P2_attr_type, P2_value] <- P1_attr_list2]))/binary, (length(P1_attr_list3)):16, (list_to_binary([<<P2_attr_type:8, P2_value:32>> || [P2_attr_type, P2_value] <- P1_attr_list3]))/binary>> || [P1_race, P1_lv, P1_e_lv, P1_stage, P1_attr_list1, P1_attr_list2, P1_attr_list3] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44804:16,0:8, D_a_t_a/binary>>};


%% 元素升级/激活 
write(44805, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44805:16,0:8, D_a_t_a/binary>>};


%% 元素属性升级 
write(44806, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44806:16,0:8, D_a_t_a/binary>>};


%% 元素升阶 
write(44807, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44807:16,0:8, D_a_t_a/binary>>};


%% 元素装备 
write(44808, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44808:16,0:8, D_a_t_a/binary>>};


%% 元素卸下 
write(44809, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44809:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



