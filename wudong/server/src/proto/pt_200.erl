%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-03-27 10:40:48
%%----------------------------------------------------
-module(pt_200).
-export([read/2, write/2]).

-include("common.hrl").
-include("battle.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"元宝不足"; 
err(3) ->"采集成功"; 
err(4) ->"水晶正在被其他玩家采集"; 
err(5) ->"冷却中"; 
err(6) ->"怒气值不足"; 
err(7) ->"时间冷却中"; 
err(8) ->"护送中,不能切换全体模式"; 
err(9) ->"当前场景不允许切换全体模式"; 
err(10) ->"其他玩家正在打开该宝箱"; 
err(11) ->"还未能获得打开权限"; 
err(12) ->"同一只怪物的极品宝箱只能打开一个"; 
err(13) ->"未达到45级无法开启宝箱"; 
err(14) ->"未达到30级无法开启宝箱"; 
err(15) ->"一次活动只能开启20个宝箱"; 
err(16) ->"当前场景不能使用"; 
err(17) ->"您没有权限打开宝箱"; 
err(18) ->"您已经打开过宝箱"; 
err(19) ->"您今日首领宝箱采集已到上限"; 
err(20) ->"没有权限采集"; 
err(21) ->"当前场景不允许切换和平模式"; 
err(22) ->"采集次数已满，送红包可增加采集数"; 
err(23) ->"城战防守方不能采集炮车"; 
err(24) ->"城战防守方盟主才能采集皇冠"; 
err(25) ->"当前场景不允许切换模式"; 
err(26) ->"请先打破两个防御塔才能进攻水晶"; 
err(27) ->"不能攻击本方占领的旗帜"; 
err(28) ->"没加入仙盟,不能攻击"; 
err(29) ->"您所在的仙盟未报名活动,不能攻击"; 
err(30) ->"旗帜保护中,不能攻击"; 
err(31) ->"不能攻击本方盟友"; 
err(32) ->"您没有权值采集晚宴物资"; 
err(33) ->"您本次晚宴可采集次数已满"; 
err(34) ->"已经变身为妖神"; 
err(35) ->"等级不足"; 
err(36) ->"玩家处于首刀保护状态暂时无法攻击"; 
err(37) ->"没有复活药"; 
err(38) ->"当前场景不可使用该方式复活"; 
err(39) ->"你今日没有享用次数了"; 
err(40) ->"您已经享用过该席了"; 
err(41) ->"宝珠在王座时不可采集"; 
err(42) ->"仅可切换本服和仙盟模式"; 
err(43) ->"您的十六强宴会采集次数已经用完"; 
err(44) ->"您的八强宴会采集次数已经用完"; 
err(45) ->"您的四强宴会采集次数已经用完"; 
err(46) ->"您的决赛宴会采集次数已经用完"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(20001, _B0) ->
    {P0_skill, _B1} = proto:read_uint32(_B0),
    {P0_atttype, _B2} = proto:read_uint8(_B1),
    {P0_x, _B3} = proto:read_uint8(_B2),
    {P0_y, _B4} = proto:read_uint8(_B3),
    {P0_targetlist, _B8} = proto:read_array(_B4, fun(_B5) ->
        {P1_sign, _B6} = proto:read_uint8(_B5),
        {P1_key, _B7} = proto:read_uint32(_B6),
        {[P1_sign, P1_key], _B7}
    end),
    {ok, {P0_skill, P0_atttype, P0_x, P0_y, P0_targetlist}};

read(20002, _B0) ->
    {ok, {}};

read(20003, _B0) ->
    {P0_mkey, _B1} = proto:read_uint32(_B0),
    {P0_action, _B2} = proto:read_uint8(_B1),
    {ok, {P0_mkey, P0_action}};

read(20004, _B0) ->
    {ok, {}};

read(20005, _B0) ->
    {ok, {}};

read(20006, _B0) ->
    {ok, {}};

read(20010, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_s_career, _B2} = proto:read_uint8(_B1),
    {ok, {P0_type, P0_s_career}};

read(20011, _B0) ->
    {ok, {}};

read(20012, _B0) ->
    {ok, {}};

read(20013, _B0) ->
    {ok, {}};

read(20014, _B0) ->
    {P0_pk, _B1} = proto:read_uint8(_B0),
    {ok, {P0_pk}};

read(20015, _B0) ->
    {ok, {}};

read(20016, _B0) ->
    {ok, {}};

read(20017, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(20018, _B0) ->
    {ok, {}};

read(20019, _B0) ->
    {ok, {}};

read(20020, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 发起战斗 
write(20001, {P0_skillid, P0_playerlist, P0_skill_effect}) ->
    D_a_t_a = <<P0_skillid:32, (pack_battle_list(P0_playerlist))/binary, P0_skill_effect:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20001:16,0:8, D_a_t_a/binary>>};


%% 战斗发起失败提示 
write(20002, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20002:16,0:8, D_a_t_a/binary>>};


%% 怪物采集 
write(20003, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20003:16,0:8, D_a_t_a/binary>>};


%% 血量变化 
write(20004, {P0_changelist}) ->
    D_a_t_a = <<(length(P0_changelist)):16, (list_to_binary([<<P1_sign:8/signed, P1_key:32, P1_type:8/signed, P1_hp:32, P1_curHp:32>> || [P1_sign, P1_key, P1_type, P1_hp, P1_curHp] <- P0_changelist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20004:16,0:8, D_a_t_a/binary>>};


%% buff列表 
write(20005, {P0_sign, P0_key, P0_bufflist}) ->
    D_a_t_a = <<P0_sign:8/signed, P0_key:32, (pack_buff_list(P0_bufflist))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20005:16,0:8, D_a_t_a/binary>>};


%% 速度变化 
write(20006, {P0_sign, P0_key, P0_speed}) ->
    D_a_t_a = <<P0_sign:8/signed, P0_key:32, P0_speed:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20006:16,0:8, D_a_t_a/binary>>};


%% 复活 
write(20010, {P0_code, P0_type, P0_scene, P0_x, P0_y, P0_hp, P0_mp, P0_gold, P0_bgold, P0_protect}) ->
    D_a_t_a = <<P0_code:8, P0_type:8, P0_scene:16, P0_x:8, P0_y:8, P0_hp:32, P0_mp:32, P0_gold:32, P0_bgold:32, P0_protect:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20010:16,0:8, D_a_t_a/binary>>};


%% 击杀通知 
write(20011, {P0_pkey, P0_name, P0_gold, P0_sn, P0_s_career, P0_career_list}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_name))/binary, P0_gold:32, P0_sn:32, P0_s_career:32, (length(P0_career_list)):16, (list_to_binary([<<P1_s_career_id:8>> || P1_s_career_id <- P0_career_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20011:16,0:8, D_a_t_a/binary>>};


%% 施法开始 
write(20012, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20012:16,0:8, D_a_t_a/binary>>};


%% 结束施法 
write(20013, {P0_sign, P0_key}) ->
    D_a_t_a = <<P0_sign:8/signed, P0_key:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20013:16,0:8, D_a_t_a/binary>>};


%% pk状态切换 
write(20014, {P0_pkey, P0_pk, P0_rtime, P0_code}) ->
    D_a_t_a = <<P0_pkey:32, P0_pk:8, P0_rtime:16, P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20014:16,0:8, D_a_t_a/binary>>};


%% 妖神变身 
write(20015, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20015:16,0:8, D_a_t_a/binary>>};


%% 妖神变身通知 
write(20016, {P0_state, P0_sin, P0_figure, P0_leave_time}) ->
    D_a_t_a = <<P0_state:8, P0_sin:16, P0_figure:32, P0_leave_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20016:16,0:8, D_a_t_a/binary>>};


%% 妖神变身（新手剧情） 
write(20017, {P0_code, P0_type}) ->
    D_a_t_a = <<P0_code:8, P0_type:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20017:16,0:8, D_a_t_a/binary>>};


%% 进入吟唱状态(能被20013打断) 
write(20018, {P0_mkey, P0_skillid, P0_time, P0_effid, P0_efftarget, P0_x, P0_y}) ->
    D_a_t_a = <<P0_mkey:32, P0_skillid:32, P0_time:8, P0_effid:32, P0_efftarget:8, P0_x:8, P0_y:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20018:16,0:8, D_a_t_a/binary>>};


%% 被动技能触发通知 
write(20019, {P0_type, P0_skill_id}) ->
    D_a_t_a = <<P0_type:8/signed, P0_skill_id:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20019:16,0:8, D_a_t_a/binary>>};


%% 嘲讽通知 
write(20020, {P0_pkey}) ->
    D_a_t_a = <<P0_pkey:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 20020:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_battle_list(P0_battle_info_list) ->
    D_a_t_a = <<(length(P0_battle_info_list)):16, (list_to_binary([<<P1_actor:8/signed, P1_sign:8/signed, P1_sign2:8/signed, P1_key:32, P1_hp_lim:32, P1_hp:32, P1_is_restore_hp:8/signed, P1_mp_lim:32, P1_mp:32, P1_mana_lim:32, P1_mana:32, P1_sin:16, P1_x:8, P1_y:8, P1_is_move:8, P1_state:8, P1_element_hurt:32/signed, (length(P1_hurtlist)):16, (list_to_binary([<<P2_hurttype:8, P2_hurtval:32>> || [P2_hurttype, P2_hurtval] <- P1_hurtlist]))/binary, (pack_buff_list(P1_bufflist))/binary>> || [P1_actor, P1_sign, P1_sign2, P1_key, P1_hp_lim, P1_hp, P1_is_restore_hp, P1_mp_lim, P1_mp, P1_mana_lim, P1_mana, P1_sin, P1_x, P1_y, P1_is_move, P1_state, P1_element_hurt, P1_hurtlist, P1_bufflist] <- P0_battle_info_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_effect_list(P0_effect_list) ->
    D_a_t_a = <<(length(P0_effect_list)):16, (list_to_binary([<<P1_type:8>> || P1_type <- P0_effect_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_buff_list(P0_buff_list) ->
    D_a_t_a = <<(length(P0_buff_list)):16, (list_to_binary([<<P1_buffid:16, P1_skillid:32, P1_stack:8, P1_time:32>> || [P1_buffid, P1_skillid, P1_stack, P1_time] <- P0_buff_list]))/binary>>,
    <<D_a_t_a/binary>>.




