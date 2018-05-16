%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-05-14 22:13:05
%%----------------------------------------------------
-module(pt_156).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"神器不存在"; 
err(3) ->"神器已激活"; 
err(4) ->"神器未达解锁条件"; 
err(5) ->"神器未激活"; 
err(6) ->"神器已幻化"; 
err(7) ->"没有技能切换"; 
err(8) ->"器灵已满级"; 
err(9) ->"物品数量不足"; 
err(10) ->"已达升阶上限"; 
err(11) ->"神器阶数不足"; 
err(12) ->"元宝不足"; 
err(13) ->"银币不足"; 
err(14) ->"材料不足"; 
err(15) ->"前置神器阶数不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(15601, _B0) ->
    {ok, {}};

read(15602, _B0) ->
    {P0_weapon_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_weapon_id}};

read(15603, _B0) ->
    {P0_weapon_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_weapon_id}};

read(15604, _B0) ->
    {P0_weapon_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_weapon_id}};

read(15605, _B0) ->
    {P0_weapon_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_weapon_id}};

read(15606, _B0) ->
    {P0_weapon_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_weapon_id}};

read(15607, _B0) ->
    {ok, {}};

read(15608, _B0) ->
    {ok, {}};

read(15609, _B0) ->
    {ok, {}};

read(15610, _B0) ->
    {P0_weapon_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_weapon_id}};

read(15611, _B0) ->
    {P0_weapon_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_weapon_id}};

read(15612, _B0) ->
    {P0_weapon_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_weapon_id}};

read(15613, _B0) ->
    {P0_weapon_id, _B1} = proto:read_int32(_B0),
    {P0_type, _B2} = proto:read_int32(_B1),
    {P0_id_list, _B5} = proto:read_array(_B2, fun(_B3) ->
        {P1_id, _B4} = proto:read_uint32(_B3),
        {P1_id, _B4}
    end),
    {P0_cost_id_list, _B8} = proto:read_array(_B5, fun(_B6) ->
        {P1_id, _B7} = proto:read_uint32(_B6),
        {P1_id, _B7}
    end),
    {ok, {P0_weapon_id, P0_type, P0_id_list, P0_cost_id_list}};

read(15614, _B0) ->
    {P0_weapon_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_weapon_id}};

read(15615, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 神器信息 
write(15601, {P0_weapon_list}) ->
    D_a_t_a = <<(length(P0_weapon_list)):16, (list_to_binary([<<P1_weapon_id:32/signed, P1_state:8/signed, P1_stage:16/signed, P1_skill_id:32/signed, P1_skill_state:8/signed, P1_is_rec:8/signed, P1_cbp:32/signed, (length(P1_attribute_list)):16, (list_to_binary([<<P2_type:32, P2_value:32/signed>> || [P2_type, P2_value] <- P1_attribute_list]))/binary>> || [P1_weapon_id, P1_state, P1_stage, P1_skill_id, P1_skill_state, P1_is_rec, P1_cbp, P1_attribute_list] <- P0_weapon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15601:16,0:8, D_a_t_a/binary>>};


%% 激活神器 
write(15602, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15602:16,0:8, D_a_t_a/binary>>};


%% 幻化 
write(15603, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15603:16,0:8, D_a_t_a/binary>>};


%% 切换技能 
write(15604, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15604:16,0:8, D_a_t_a/binary>>};


%% 器灵信息 
write(15605, {P0_weapon_id, P0_cur_type, P0_type_list}) ->
    D_a_t_a = <<P0_weapon_id:32/signed, P0_cur_type:32/signed, (length(P0_type_list)):16, (list_to_binary([<<P1_type:32/signed, P1_lv:32/signed>> || [P1_type, P1_lv] <- P0_type_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15605:16,0:8, D_a_t_a/binary>>};


%% 升级器灵 
write(15606, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15606:16,0:8, D_a_t_a/binary>>};


%% 获取神器技能列表 
write(15607, {P0_cur_skill_id, P0_skill_list}) ->
    D_a_t_a = <<P0_cur_skill_id:32/signed, (length(P0_skill_list)):16, (list_to_binary([<<P1_weapon_id:32/signed, P1_skill_id:32/signed>> || [P1_weapon_id, P1_skill_id] <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15607:16,0:8, D_a_t_a/binary>>};


%% 获取可以注灵神器列表 
write(15608, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_weapon_id:32/signed>> || P1_weapon_id <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15608:16,0:8, D_a_t_a/binary>>};


%% 获取神器列表 
write(15609, {P0_weapon_list}) ->
    D_a_t_a = <<(length(P0_weapon_list)):16, (list_to_binary([<<P1_weapon_id:32/signed, P1_weapon_star:32/signed, (length(P1_fix_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:32>> || [P2_attr_type, P2_value] <- P1_fix_attr]))/binary, (length(P1_wash_attr)):16, (list_to_binary([<<P2_id:8, P2_attr_type:8, P2_value:32, P2_star:32>> || [P2_id, P2_attr_type, P2_value, P2_star] <- P1_wash_attr]))/binary, (length(P1_need_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_need_list]))/binary>> || [P1_weapon_id, P1_weapon_star, P1_fix_attr, P1_wash_attr, P1_need_list] <- P0_weapon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15609:16,0:8, D_a_t_a/binary>>};


%% 获取十荒神器进阶信息 
write(15610, {P0_weapon_id, P0_weapon_star, P0_need_list, P0_fix_attr, P0_next_fix_attr}) ->
    D_a_t_a = <<P0_weapon_id:32/signed, P0_weapon_star:32/signed, (length(P0_need_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_need_list]))/binary, (length(P0_fix_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_fix_attr]))/binary, (length(P0_next_fix_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_next_fix_attr]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15610:16,0:8, D_a_t_a/binary>>};


%% 进阶神器 
write(15611, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15611:16,0:8, D_a_t_a/binary>>};


%% 获取十荒神器洗练信息 
write(15612, {P0_weapon_id, P0_weapon_star, P0_wash_attr, P0_next_wash_attr}) ->
    D_a_t_a = <<P0_weapon_id:32/signed, P0_weapon_star:32/signed, (length(P0_wash_attr)):16, (list_to_binary([<<P1_id:8, P1_attr_type:8, P1_value:32, P1_star:32>> || [P1_id, P1_attr_type, P1_value, P1_star] <- P0_wash_attr]))/binary, (length(P0_next_wash_attr)):16, (list_to_binary([<<P1_id:8, P1_attr_type:8, P1_value:32, P1_star:32>> || [P1_id, P1_attr_type, P1_value, P1_star] <- P0_next_wash_attr]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15612:16,0:8, D_a_t_a/binary>>};


%% 洗练神器 
write(15613, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15613:16,0:8, D_a_t_a/binary>>};


%% 替换洗练属性 
write(15614, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15614:16,0:8, D_a_t_a/binary>>};


%% 获取消耗信息 
write(15615, {P0_weapon_list}) ->
    D_a_t_a = <<(length(P0_weapon_list)):16, (list_to_binary([<<P1_weapon_id:32/signed, P1_weapon_star:32/signed, P1_wash_state:32/signed, P1_state:32/signed, (length(P1_need_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_need_list]))/binary, (length(P1_last_list)):16, (list_to_binary([<<P2_weapon_id:32/signed, P2_weapon_star:32/signed>> || [P2_weapon_id, P2_weapon_star] <- P1_last_list]))/binary>> || [P1_weapon_id, P1_weapon_star, P1_wash_state, P1_state, P1_need_list, P1_last_list] <- P0_weapon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15615:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



