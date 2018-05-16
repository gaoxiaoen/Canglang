%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-11-20 14:54:45
%%----------------------------------------------------
-module(pt_501).
-export([read/2, write/2]).

-include("common.hrl").
-include("pet.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"银币不足"; 
err(3) ->"元宝不足"; 
err(4) ->"宠物不存在"; 
err(5) ->"该宠物已出战"; 
err(6) ->"技能未开放"; 
err(7) ->"技能不存在"; 
err(8) ->"技能已满级"; 
err(9) ->"配置异常"; 
err(10) ->"技能书不足"; 
err(11) ->"没有宠物"; 
err(12) ->"已满阶"; 
err(13) ->"升阶物品不足"; 
err(14) ->"自动购买价格异常"; 
err(15) ->"宠物已满星"; 
err(16) ->"物品数量不足"; 
err(17) ->"不能吞噬出战宠物"; 
err(18) ->"不能吞噬助战宠物"; 
err(19) ->"该宠物已经在助战中"; 
err(20) ->"该位置已经有宠物助战中"; 
err(21) ->"出战宠物不能助战"; 
err(22) ->"等级不足,助战栏位未开放"; 
err(23) ->"该宠物没有在助战中"; 
err(24) ->"该图鉴未激活"; 
err(25) ->"该图鉴已激活"; 
err(26) ->"宠物未出战"; 
err(27) ->"宠物蛋不存在"; 
err(28) ->"宠物蛋资质配置不存在"; 
err(29) ->"不能领取该宠物"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(50101, _B0) ->
    {ok, {}};

read(50102, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(50103, _B0) ->
    {P0_pkey, _B1} = proto:read_key(_B0),
    {ok, {P0_pkey}};

read(50104, _B0) ->
    {P0_pkey, _B1} = proto:read_key(_B0),
    {P0_cell, _B2} = proto:read_int8(_B1),
    {ok, {P0_pkey, P0_cell}};

read(50105, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_auto, _B2} = proto:read_uint8(_B1),
    {ok, {P0_type, P0_auto}};

read(50106, _B0) ->
    {P0_pkey, _B1} = proto:read_key(_B0),
    {P0_goods_list, _B5} = proto:read_array(_B1, fun(_B2) ->
        {P1_goods_id, _B3} = proto:read_int32(_B2),
        {P1_num, _B4} = proto:read_int16(_B3),
        {[P1_goods_id, P1_num], _B4}
    end),
    {P0_key_list, _B8} = proto:read_array(_B5, fun(_B6) ->
        {P1_pet_key, _B7} = proto:read_key(_B6),
        {P1_pet_key, _B7}
    end),
    {ok, {P0_pkey, P0_goods_list, P0_key_list}};

read(50107, _B0) ->
    {ok, {}};

read(50108, _B0) ->
    {P0_pos, _B1} = proto:read_uint8(_B0),
    {P0_pkey, _B2} = proto:read_key(_B1),
    {ok, {P0_pos, P0_pkey}};

read(50109, _B0) ->
    {P0_pkey, _B1} = proto:read_key(_B0),
    {ok, {P0_pkey}};

read(50110, _B0) ->
    {P0_pos1, _B1} = proto:read_uint8(_B0),
    {P0_pos2, _B2} = proto:read_uint8(_B1),
    {ok, {P0_pos1, P0_pos2}};

read(50111, _B0) ->
    {ok, {}};

read(50112, _B0) ->
    {P0_figure_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_figure_id}};

read(50113, _B0) ->
    {P0_figure_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_figure_id}};

read(50114, _B0) ->
    {ok, {}};

read(50115, _B0) ->
    {ok, {}};

read(50116, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(50117, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(50118, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(50119, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {P0_type_id, _B2} = proto:read_int32(_B1),
    {ok, {P0_key, P0_type_id}};

read(50120, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 宠物列表 
write(50101, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_type_id:32/signed, P1_figure_id:32/signed, P1_state:8/signed, P1_star:8/signed, P1_cbp:32/signed>> || [P1_key, P1_type_id, P1_figure_id, P1_state, P1_star, P1_cbp] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50101:16,0:8, D_a_t_a/binary>>};


%% 单个宠物信息 
write(50102, {P0_key, P0_type_id, P0_stage, P0_star, P0_star_exp, P0_star_exp_lim, P0_name, P0_figure_id, P0_use_figure_id, P0_state, P0_cbp, P0_attrlist, P0_skill_list}) ->
    D_a_t_a = <<(proto:write_string(P0_key))/binary, P0_type_id:32/signed, P0_stage:8/signed, P0_star:8/signed, P0_star_exp:32/signed, P0_star_exp_lim:32/signed, (proto:write_string(P0_name))/binary, P0_figure_id:32/signed, P0_use_figure_id:32/signed, P0_state:8/signed, P0_cbp:32/signed, (length(P0_attrlist)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_attrlist]))/binary, (length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8/signed, P1_skill_id:32/signed, P1_state:8/signed, P1_star:8/signed>> || [P1_cell, P1_skill_id, P1_state, P1_star] <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50102:16,0:8, D_a_t_a/binary>>};


%% 宠物出战/休息/出战替换 
write(50103, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50103:16,0:8, D_a_t_a/binary>>};


%% 技能升级 
write(50104, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50104:16,0:8, D_a_t_a/binary>>};


%% 宠物进阶 
write(50105, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50105:16,0:8, D_a_t_a/binary>>};


%% 宠物升星 
write(50106, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50106:16,0:8, D_a_t_a/binary>>};


%% 获取宠物助战信息 
write(50107, {P0_list, P0_active_list, P0_cbp, P0_assist_acc, P0_assist_acc_attribute, P0_assist_star, P0_assist_star_attribute}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_pos:8, P1_open_lv:16, (proto:write_string(P1_key))/binary, P1_figure_id:32/signed, P1_star:8/signed, (length(P1_attrlist)):16, (list_to_binary([<<P2_type:8, P2_val:32>> || [P2_type, P2_val] <- P1_attrlist]))/binary>> || [P1_pos, P1_open_lv, P1_key, P1_figure_id, P1_star, P1_attrlist] <- P0_list]))/binary, (length(P0_active_list)):16, (list_to_binary([<<P1_id:8, P1_star:8, P1_max_star:8, (length(P1_attrlist)):16, (list_to_binary([<<P2_type:8, P2_val:32>> || [P2_type, P2_val] <- P1_attrlist]))/binary>> || [P1_id, P1_star, P1_max_star, P1_attrlist] <- P0_active_list]))/binary, P0_cbp:32/signed, P0_assist_acc:8/signed, (length(P0_assist_acc_attribute)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_assist_acc_attribute]))/binary, P0_assist_star:8/signed, (length(P0_assist_star_attribute)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_assist_star_attribute]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50107:16,0:8, D_a_t_a/binary>>};


%% 宠物助战 
write(50108, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50108:16,0:8, D_a_t_a/binary>>};


%% 宠物助战卸下 
write(50109, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50109:16,0:8, D_a_t_a/binary>>};


%% 助战宠物位置互换 
write(50110, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50110:16,0:8, D_a_t_a/binary>>};


%% 图鉴列表 
write(50111, {P0_list, P0_acc_normal, P0_cbp_normal, P0_acc_normal_attribute, P0_acc_special, P0_cbp_special, P0_acc_special_attribute}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_figure_id:32/signed, P1_lv:8>> || [P1_figure_id, P1_lv] <- P0_list]))/binary, P0_acc_normal:8/signed, P0_cbp_normal:32/signed, (length(P0_acc_normal_attribute)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_acc_normal_attribute]))/binary, P0_acc_special:8/signed, P0_cbp_special:32/signed, (length(P0_acc_special_attribute)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_acc_special_attribute]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50111:16,0:8, D_a_t_a/binary>>};


%% 激活图鉴 
write(50112, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50112:16,0:8, D_a_t_a/binary>>};


%% 幻化 
write(50113, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50113:16,0:8, D_a_t_a/binary>>};


%% 图鉴获得通知 
write(50114, {P0_figure_id}) ->
    D_a_t_a = <<P0_figure_id:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50114:16,0:8, D_a_t_a/binary>>};


%% 获取进阶信息 
write(50115, {P0_stage, P0_stage_lv, P0_stage_exp, P0_stage_exp_lim}) ->
    D_a_t_a = <<P0_stage:8/signed, P0_stage_lv:8/signed, P0_stage_exp:32/signed, P0_stage_exp_lim:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50115:16,0:8, D_a_t_a/binary>>};


%% 宠物蛋预览 
write(50116, {P0_code, P0_type, P0_type_id, P0_star, P0_cbp, P0_figure_state, P0_attrlist}) ->
    D_a_t_a = <<P0_code:8/signed, P0_type:32/signed, P0_type_id:32/signed, P0_star:8/signed, P0_cbp:32/signed, P0_figure_state:8/signed, (length(P0_attrlist)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_attrlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50116:16,0:8, D_a_t_a/binary>>};


%% 领取宠物蛋宠物 
write(50117, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50117:16,0:8, D_a_t_a/binary>>};


%% 丢弃宠物蛋 
write(50118, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50118:16,0:8, D_a_t_a/binary>>};


%% 领取新手宠物蛋宠物 
write(50119, {P0_code, P0_type, P0_type_id, P0_star, P0_cbp, P0_figure_state, P0_attrlist}) ->
    D_a_t_a = <<P0_code:8/signed, P0_type:32/signed, P0_type_id:32/signed, P0_star:8/signed, P0_cbp:32/signed, P0_figure_state:8/signed, (length(P0_attrlist)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_attrlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50119:16,0:8, D_a_t_a/binary>>};


%% 宠物蛋十连开 
write(50120, {P0_code, P0_list}) ->
    D_a_t_a = <<P0_code:8/signed, (length(P0_list)):16, (list_to_binary([<<P1_type_id:32/signed, P1_star:8/signed>> || [P1_type_id, P1_star] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 50120:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



