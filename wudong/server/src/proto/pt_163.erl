%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-03-05 22:07:53
%%----------------------------------------------------
-module(pt_163).
-export([read/2, write/2]).

-include("common.hrl").
-include("pet.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(4) ->"宝宝不存在"; 
err(5) ->"物品不足"; 
err(6) ->"名字不合法"; 
err(7) ->"宝宝技能不可激活"; 
err(8) ->"宝宝技能已满级"; 
err(9) ->"配置有误"; 
err(10) ->"宝宝阶级已满"; 
err(11) ->"元宝不足"; 
err(12) ->"商城无此物品出售"; 
err(13) ->"宝宝等级已满"; 
err(14) ->"宝宝变性失败"; 
err(15) ->"已经拥有宝宝了"; 
err(16) ->"性别错误"; 
err(17) ->"当前图鉴已经激活"; 
err(18) ->"已经是当前形象"; 
err(19) ->"该形象还没激活"; 
err(20) ->"背包不存在此装备物品"; 
err(21) ->"宝宝等级不足"; 
err(22) ->"装备物品不属于宝宝子类型"; 
err(23) ->"今日已签到"; 
err(24) ->"此天数不可签到"; 
err(25) ->"此击杀阶段已领取"; 
err(26) ->"击杀数量领取条件不满足"; 
err(27) ->"没结婚，不能领取双人签到"; 
err(28) ->"装备性别与宝宝性别不符合"; 
err(29) ->"宝宝已经诞生，无需再加速"; 
err(30) ->"金币不足"; 
err(31) ->"绑钻不足"; 
err(32) ->"星级已满"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(16301, _B0) ->
    {ok, {}};

read(16302, _B0) ->
    {ok, {}};

read(16303, _B0) ->
    {P0_figure_id, _B1} = proto:read_int32(_B0),
    {P0_babyname, _B2} = proto:read_string(_B1),
    {ok, {P0_figure_id, P0_babyname}};

read(16304, _B0) ->
    {P0_cell, _B1} = proto:read_int8(_B0),
    {ok, {P0_cell}};

read(16305, _B0) ->
    {P0_auto, _B1} = proto:read_uint8(_B0),
    {ok, {P0_auto}};

read(16306, _B0) ->
    {P0_auto, _B1} = proto:read_uint8(_B0),
    {ok, {P0_auto}};

read(16307, _B0) ->
    {ok, {}};

read(16308, _B0) ->
    {ok, {}};

read(16309, _B0) ->
    {ok, {}};

read(16310, _B0) ->
    {P0_sex, _B1} = proto:read_uint8(_B0),
    {P0_babyname, _B2} = proto:read_string(_B1),
    {ok, {P0_sex, P0_babyname}};

read(16311, _B0) ->
    {ok, {}};

read(16312, _B0) ->
    {P0_figure_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_figure_id}};

read(16313, _B0) ->
    {P0_figure_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_figure_id}};

read(16314, _B0) ->
    {ok, {}};

read(16315, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16316, _B0) ->
    {ok, {}};

read(16317, _B0) ->
    {P0_sign_type, _B1} = proto:read_uint8(_B0),
    {P0_day, _B2} = proto:read_uint8(_B1),
    {ok, {P0_sign_type, P0_day}};

read(16318, _B0) ->
    {P0_kill_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_kill_id}};

read(16319, _B0) ->
    {P0_goods_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_goods_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 宝宝信息 
write(16301, {P0_type_id, P0_step, P0_step_exp, P0_lv, P0_lv_exp, P0_name, P0_use_figure_id, P0_state, P0_cbp, P0_attrlist, P0_skill_list, P0_equip_list, P0_my_love, P0_her_love, P0_tar_lv, P0_percent1, P0_percent2, P0_today_kill, P0_kill_list, P0_sign_award, P0_pic_active}) ->
    D_a_t_a = <<P0_type_id:32/signed, P0_step:16/signed, P0_step_exp:32/signed, P0_lv:16/signed, P0_lv_exp:32/signed, (proto:write_string(P0_name))/binary, P0_use_figure_id:32/signed, P0_state:8/signed, P0_cbp:32/signed, (length(P0_attrlist)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_attrlist]))/binary, (length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8/signed, P1_skill_id:32/signed, P1_state:8/signed, P1_step:8/signed>> || [P1_cell, P1_skill_id, P1_state, P1_step] <- P0_skill_list]))/binary, (length(P0_equip_list)):16, (list_to_binary([<<P1_subtype:16/signed, P1_equip_id:32>> || [P1_subtype, P1_equip_id] <- P0_equip_list]))/binary, P0_my_love:32/signed, P0_her_love:32/signed, P0_tar_lv:32/signed, P0_percent1:32/signed, P0_percent2:32/signed, P0_today_kill:32/signed, (length(P0_kill_list)):16, (list_to_binary([<<P1_kill_id:8, P1_get_state:8, P1_kill_num:32, (length(P1_goods)):16, (list_to_binary([<<P2_goods_id2:32/signed, P2_goods_num2:16/signed>> || [P2_goods_id2, P2_goods_num2] <- P1_goods]))/binary>> || [P1_kill_id, P1_get_state, P1_kill_num, P1_goods] <- P0_kill_list]))/binary, P0_sign_award:8, P0_pic_active:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16301:16,0:8, D_a_t_a/binary>>};


%% 宝宝出战/出战替换 
write(16302, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16302:16,0:8, D_a_t_a/binary>>};


%% 宝宝改名 
write(16303, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16303:16,0:8, D_a_t_a/binary>>};


%% 技能升级/激活 
write(16304, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16304:16,0:8, D_a_t_a/binary>>};


%% 宝宝进阶 
write(16305, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16305:16,0:8, D_a_t_a/binary>>};


%% 宝宝经验升级 
write(16306, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16306:16,0:8, D_a_t_a/binary>>};


%% 宝宝性别转换 
write(16307, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16307:16,0:8, D_a_t_a/binary>>};


%% 小图标提示 
write(16308, {P0_lefttime}) ->
    D_a_t_a = <<P0_lefttime:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16308:16,0:8, D_a_t_a/binary>>};


%% 宝宝出生提示 
write(16309, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16309:16,0:8, D_a_t_a/binary>>};


%% 创建宝宝 
write(16310, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16310:16,0:8, D_a_t_a/binary>>};


%% 图鉴列表 
write(16311, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_figure_id:32/signed, P1_active:8, P1_star:8, (proto:write_string(P1_name))/binary, P1_times:8>> || [P1_figure_id, P1_active, P1_star, P1_name, P1_times] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16311:16,0:8, D_a_t_a/binary>>};


%% 激活图鉴 
write(16312, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16312:16,0:8, D_a_t_a/binary>>};


%% 幻化 
write(16313, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16313:16,0:8, D_a_t_a/binary>>};


%% 图鉴获得通知 
write(16314, {P0_figure_id}) ->
    D_a_t_a = <<P0_figure_id:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16314:16,0:8, D_a_t_a/binary>>};


%% 穿上装备 
write(16315, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16315:16,0:8, D_a_t_a/binary>>};


%% 签到信息 
write(16316, {P0_single_sign_day, P0_single_sign, P0_double_sign_day, P0_double_sign}) ->
    D_a_t_a = <<P0_single_sign_day:8, (length(P0_single_sign)):16, (list_to_binary([<<P1_day:8, P1_sign:8, (length(P1_goods)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:16/signed>> || [P2_goods_id, P2_goods_num] <- P1_goods]))/binary>> || [P1_day, P1_sign, P1_goods] <- P0_single_sign]))/binary, P0_double_sign_day:8, (length(P0_double_sign)):16, (list_to_binary([<<P1_day2:8, P1_sign2:8, (length(P1_goods2)):16, (list_to_binary([<<P2_goods_id2:32/signed, P2_goods_num2:16/signed>> || [P2_goods_id2, P2_goods_num2] <- P1_goods2]))/binary>> || [P1_day2, P1_sign2, P1_goods2] <- P0_double_sign]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16316:16,0:8, D_a_t_a/binary>>};


%% 签到 
write(16317, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16317:16,0:8, D_a_t_a/binary>>};


%% 领取击杀数量奖励 
write(16318, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16318:16,0:8, D_a_t_a/binary>>};


%% 请求加速 
write(16319, {P0_error_code, P0_time}) ->
    D_a_t_a = <<P0_error_code:8, P0_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16319:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



