%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-04-09 11:36:10
%%----------------------------------------------------
-module(pt_400).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已经加入仙盟"; 
err(3) ->"未加入仙盟"; 
err(4) ->"仙盟不存在"; 
err(5) ->"仙盟成员不存在"; 
err(6) ->"参数错误"; 
err(7) ->"国家不符合"; 
err(8) ->"已有仙盟取该名字"; 
err(12) ->"等级不足"; 
err(13) ->"仙盟名字长度不符合"; 
err(14) ->"仙盟名字含有非法字符"; 
err(15) ->"元宝不足以支付创建帮派"; 
err(16) ->"选择的帮派图标不存在"; 
err(17) ->"您今日退出仙盟过于频繁,请稍后创建"; 
err(18) ->"掌门或者掌教才能修改"; 
err(21) ->"只有掌门才能解散仙盟"; 
err(22) ->"跨服boss活动期间不可退盟"; 
err(23) ->"跨服boss活动期间不可解散盟"; 
err(24) ->"攻城战活动期间不可退盟"; 
err(25) ->"攻城战活动期间不可解散盟"; 
err(26) ->"攻城战活动期间不可开除盟员"; 
err(51) ->"只有掌门或掌教才能改名"; 
err(52) ->"请%s后再试"; 
err(53) ->"元宝不足以支付仙盟改名"; 
err(54) ->"没有改名卡"; 
err(55) ->"24小时内改名不可再次修改"; 
err(71) ->"已经申请加入该仙盟"; 
err(72) ->"该帮派可申请名额已满"; 
err(73) ->"请%s后申请"; 
err(74) ->"等级不符合申请条件"; 
err(75) ->"战力不符合申请条件"; 
err(76) ->"该帮派拒绝申请"; 
err(77) ->"成功加入仙盟"; 
err(78) ->"物品不足"; 
err(79) ->"经验已满"; 
err(80) ->"已超过喂养时间"; 
err(81) ->"不可召唤"; 
err(82) ->"不在活动期间"; 
err(83) ->"每日道具喂养次数已满"; 
err(84) ->"每日元宝喂养次数已满"; 
err(85) ->"神兽已经出现，无需继续喂养"; 
err(90) ->"仙盟等级不足"; 
err(101) ->"您的职位不能审批仙盟申请"; 
err(102) ->"该玩家没有申请你所在的仙盟"; 
err(103) ->"审批参数错误"; 
err(104) ->"仙盟人数已满"; 
err(105) ->"该玩家已经加入了其他仙盟"; 
err(111) ->"需要移交掌门才可离开"; 
err(121) ->"该玩家和您不在同一仙盟"; 
err(122) ->"该玩家职位不在你之下"; 
err(131) ->"你不是掌门"; 
err(132) ->"被转让的玩家没有加入仙盟"; 
err(133) ->"被转让的玩家和你不在同一仙盟"; 
err(141) ->"你没有任命职位的权限"; 
err(142) ->"任命的职位不在你之下"; 
err(143) ->"被任命的玩家和你不在同一仙盟"; 
err(144) ->"该职位人数已达上限"; 
err(145) ->"不能任命自己"; 
err(151) ->"你的仙盟职位没有权限修改仙盟公告"; 
err(152) ->"仙盟公告含有敏感词"; 
err(153) ->"修改仙盟公告不够2分钟，请稍后再试"; 
err(161) ->"内容含义敏感词"; 
err(162) ->"你今天已经签到"; 
err(261) ->"签到奖励已领取"; 
err(262) ->"你今日未签到"; 
err(181) ->"没有签到奖励可领取"; 
err(251) ->"不能弹劾自己"; 
err(252) ->"会长超过3天不上线才能弹劾"; 
err(253) ->"系统工会不能弹劾"; 
err(254) ->"掌门需要超过三天不上线才能弹劾"; 
err(255) ->"%s正在发起弹劾，请耐心等待结果"; 
err(256) ->"元宝不足以支付弹劾"; 
err(311) ->"今日已经奉献"; 
err(312) ->"今日仙盟奉献值已满"; 
err(313) ->"银两不足以支付奉献"; 
err(314) ->"元宝不足以支付奉献"; 
err(315) ->"会员等级4才可以进行顶级奉献"; 
err(321) ->"该奉献进度未达成"; 
err(322) ->"该奉献奖励不存在"; 
err(323) ->"该奉献奖励已领取"; 
err(411) ->"该帮派技能信息不存在"; 
err(412) ->"该帮派技能已满级"; 
err(413) ->"仙盟等级不足，不能升级"; 
err(414) ->"玩家等级不足，不能升级"; 
err(415) ->"仙盟贡献不足，不能升级"; 
err(511) ->"今日仙盟任务数已达上限"; 
err(512) ->"提交的不是仙盟任务"; 
err(513) ->"仙盟任务不存在"; 
err(514) ->"仙盟任务未完成"; 
err(521) ->"该任务进度未达成"; 
err(522) ->"该任务进度奖励已领取"; 
err(523) ->"该任务进度奖励不存在"; 
err(641) ->"副本关卡不存在"; 
err(642) ->"改副本关卡通关奖励已领取"; 
err(643) ->"改副本关卡未通关"; 
err(651) ->"等级不足45级,不能挑战"; 
err(652) ->"挑战次数已用完,明日再来"; 
err(653) ->"副本未开启"; 
err(654) ->"副本已通关"; 
err(655) ->"其他仙盟成员正在挑战中，请稍后"; 
err(656) ->"副本今日可挑战次数已用完,明日再来"; 
err(657) ->"野外场景才能挑战"; 
err(700) ->"今日次数已用完"; 
err(701) ->"冷却中"; 
err(702) ->"宝箱已经被协助"; 
err(703) ->"宝箱已经不需要协助"; 
err(704) ->"宝箱已被领取"; 
err(705) ->"宝箱不可开启"; 
err(706) ->"未进入冷却，不需要清除"; 
err(707) ->"当前宝箱已达最高品质"; 
err(708) ->"该宝箱在求助冷却中"; 
err(800) ->"仙盟令物品不足"; 
err(801) ->"元宝不足"; 
err(802) ->"你不能领取"; 
err(803) ->"今天已经领取了"; 
err(804) ->"没有可加入的仙盟"; 
err(805) ->"今日元宝贡献已达上限"; 
err(806) ->"元宝贡献超过上限"; 
err(807) ->"今天的助威次数已达上限"; 
err(808) ->"被助威次数已达上限"; 
err(809) ->"已经助威过了"; 
err(810) ->"今天已经点赞了"; 
err(811) ->"今天已经请求助威了"; 
err(812) ->"不能助威自己"; 
err(813) ->"不能扫荡"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(40000, _B0) ->
    {ok, {}};

read(40001, _B0) ->
    {P0_name, _B1} = proto:read_string(_B0),
    {P0_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_name, P0_type}};

read(40002, _B0) ->
    {ok, {}};

read(40003, _B0) ->
    {ok, {}};

read(40004, _B0) ->
    {P0_page, _B1} = proto:read_int8(_B0),
    {ok, {P0_page}};

read(40005, _B0) ->
    {P0_name, _B1} = proto:read_string(_B0),
    {ok, {P0_name}};

read(40006, _B0) ->
    {P0_page, _B1} = proto:read_int8(_B0),
    {P0_type, _B2} = proto:read_int8(_B1),
    {ok, {P0_page, P0_type}};

read(40007, _B0) ->
    {P0_gkey, _B1} = proto:read_key(_B0),
    {ok, {P0_gkey}};

read(40008, _B0) ->
    {P0_gkey, _B1} = proto:read_key(_B0),
    {P0_from, _B2} = proto:read_int8(_B1),
    {ok, {P0_gkey, P0_from}};

read(40009, _B0) ->
    {P0_page, _B1} = proto:read_int8(_B0),
    {ok, {P0_page}};

read(40010, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_ret, _B2} = proto:read_int8(_B1),
    {ok, {P0_pkey, P0_ret}};

read(40011, _B0) ->
    {ok, {}};

read(40012, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(40013, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(40014, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_position, _B2} = proto:read_int8(_B1),
    {ok, {P0_pkey, P0_position}};

read(40015, _B0) ->
    {P0_msg, _B1} = proto:read_string(_B0),
    {ok, {P0_msg}};

read(40016, _B0) ->
    {ok, {}};

read(40020, _B0) ->
    {P0_name, _B1} = proto:read_string(_B0),
    {ok, {P0_name}};

read(40021, _B0) ->
    {ok, {}};

read(40022, _B0) ->
    {ok, {}};

read(40023, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_lv, _B2} = proto:read_int16(_B1),
    {P0_cbp, _B3} = proto:read_int32(_B2),
    {ok, {P0_type, P0_lv, P0_cbp}};

read(40024, _B0) ->
    {P0_name, _B1} = proto:read_string(_B0),
    {ok, {P0_name}};

read(40025, _B0) ->
    {ok, {}};

read(40030, _B0) ->
    {ok, {}};

read(40031, _B0) ->
    {P0_goods_num, _B1} = proto:read_uint32(_B0),
    {P0_gold, _B2} = proto:read_uint32(_B1),
    {ok, {P0_goods_num, P0_gold}};

read(40032, _B0) ->
    {P0_dedicate_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_dedicate_id}};

read(40033, _B0) ->
    {ok, {}};

read(40040, _B0) ->
    {ok, {}};

read(40041, _B0) ->
    {P0_sid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_sid}};

read(40050, _B0) ->
    {ok, {}};

read(40051, _B0) ->
    {P0_tpye, _B1} = proto:read_uint32(_B0),
    {ok, {P0_tpye}};

read(40052, _B0) ->
    {ok, {}};

read(40053, _B0) ->
    {ok, {}};

read(40054, _B0) ->
    {ok, {}};

read(40055, _B0) ->
    {ok, {}};

read(40056, _B0) ->
    {ok, {}};

read(40057, _B0) ->
    {ok, {}};

read(40060, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(40061, _B0) ->
    {ok, {}};

read(40071, _B0) ->
    {ok, {}};

read(40072, _B0) ->
    {ok, {}};

read(40073, _B0) ->
    {ok, {}};

read(40075, _B0) ->
    {ok, {}};

read(40076, _B0) ->
    {ok, {}};

read(40080, _B0) ->
    {ok, {}};

read(40081, _B0) ->
    {P0_floor, _B1} = proto:read_uint8(_B0),
    {ok, {P0_floor}};

read(40082, _B0) ->
    {ok, {}};

read(40083, _B0) ->
    {ok, {}};

read(40084, _B0) ->
    {ok, {}};

read(40085, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(40086, _B0) ->
    {ok, {}};

read(40087, _B0) ->
    {ok, {}};

read(40090, _B0) ->
    {ok, {}};

read(40091, _B0) ->
    {ok, {}};

read(40092, _B0) ->
    {ok, {}};

read(40093, _B0) ->
    {ok, {}};

read(40094, _B0) ->
    {P0_type, _B1} = proto:read_int16(_B0),
    {ok, {P0_type}};

read(40095, _B0) ->
    {P0_box_key, _B1} = proto:read_key(_B0),
    {ok, {P0_box_key}};

read(40096, _B0) ->
    {ok, {}};

read(40097, _B0) ->
    {ok, {}};

read(40098, _B0) ->
    {P0_box_key, _B1} = proto:read_key(_B0),
    {ok, {P0_box_key}};

read(40099, _B0) ->
    {P0_box_key, _B1} = proto:read_key(_B0),
    {ok, {P0_box_key}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取创建帮派信息 
write(40000, {P0_type_list}) ->
    D_a_t_a = <<(length(P0_type_list)):16, (list_to_binary([<<P1_type:8/signed, P1_lv:32/signed, P1_gold:32, P1_bgold:32, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_type, P1_lv, P1_gold, P1_bgold, P1_goods_list] <- P0_type_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40000:16,0:8, D_a_t_a/binary>>};


%% 创建帮派 
write(40001, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40001:16,0:8, D_a_t_a/binary>>};


%% 解散帮派 
write(40002, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40002:16,0:8, D_a_t_a/binary>>};


%% 获取帮派信息 
write(40003, {P0_code, P0_g_name, P0_p_name, P0_p_vip, P0_g_lv, P0_g_num, P0_g_max_num, P0_g_rank, P0_g_dedciate, P0_g_max_dedciate, P0_g_notice, P0_key, P0_name, P0_career, P0_sex, P0_wing_id, P0_wepon_id, P0_clothing_id, P0_light_wepon_id, P0_fashion_cloth_id, P0_fashion_head_id, P0_vip, P0_hy_val, P0_can_get_gift, P0_gift_id, P0_like_times, P0_guild_medal, P0_guild_icon}) ->
    D_a_t_a = <<P0_code:16/signed, (proto:write_string(P0_g_name))/binary, (proto:write_string(P0_p_name))/binary, P0_p_vip:8/signed, P0_g_lv:8/signed, P0_g_num:8/signed, P0_g_max_num:8/signed, P0_g_rank:16/signed, P0_g_dedciate:32/signed, P0_g_max_dedciate:32/signed, (proto:write_string(P0_g_notice))/binary, P0_key:32, (proto:write_string(P0_name))/binary, P0_career:32/signed, P0_sex:8, P0_wing_id:32, P0_wepon_id:32, P0_clothing_id:32, P0_light_wepon_id:32, P0_fashion_cloth_id:32, P0_fashion_head_id:32/signed, P0_vip:8/signed, P0_hy_val:32/signed, P0_can_get_gift:8/signed, P0_gift_id:32/signed, P0_like_times:32/signed, P0_guild_medal:32/signed, P0_guild_icon:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40003:16,0:8, D_a_t_a/binary>>};


%% 获取帮派日志 
write(40004, {P0_page, P0_max_page, P0_log_list}) ->
    D_a_t_a = <<P0_page:8/signed, P0_max_page:8/signed, (pack_guild_log_list(P0_log_list))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40004:16,0:8, D_a_t_a/binary>>};


%% 帮派改名 
write(40005, {P0_code, P0_cd}) ->
    D_a_t_a = <<P0_code:16/signed, P0_cd:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40005:16,0:8, D_a_t_a/binary>>};


%% 获取帮派列表 
write(40006, {P0_page, P0_max_page, P0_guild_list}) ->
    D_a_t_a = <<P0_page:8/signed, P0_max_page:8/signed, (pack_guild_list(P0_guild_list))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40006:16,0:8, D_a_t_a/binary>>};


%% 获取帮派成员列表 
write(40007, {P0_guild_member_list}) ->
    D_a_t_a = <<(pack_guild_member_list(P0_guild_member_list))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40007:16,0:8, D_a_t_a/binary>>};


%% 申请帮派 
write(40008, {P0_code, P0_gkey, P0_cd}) ->
    D_a_t_a = <<P0_code:16/signed, (proto:write_string(P0_gkey))/binary, P0_cd:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40008:16,0:8, D_a_t_a/binary>>};


%% 获取帮派申请列表 
write(40009, {P0_page, P0_max_page, P0_guild_apply_list}) ->
    D_a_t_a = <<P0_page:8/signed, P0_max_page:8/signed, (pack_guild_apply_list(P0_guild_apply_list))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40009:16,0:8, D_a_t_a/binary>>};


%% 帮派审批 
write(40010, {P0_code, P0_pkey}) ->
    D_a_t_a = <<P0_code:16/signed, P0_pkey:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40010:16,0:8, D_a_t_a/binary>>};


%% 退出帮派 
write(40011, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40011:16,0:8, D_a_t_a/binary>>};


%% 开除帮派成员 
write(40012, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40012:16,0:8, D_a_t_a/binary>>};


%% 转让会长 
write(40013, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40013:16,0:8, D_a_t_a/binary>>};


%% 任命职位 
write(40014, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40014:16,0:8, D_a_t_a/binary>>};


%% 修改帮派公告 
write(40015, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40015:16,0:8, D_a_t_a/binary>>};


%% 申请通知 
write(40016, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40016:16,0:8, D_a_t_a/binary>>};


%% 搜索帮派(模糊查询) 
write(40020, {P0_guild_list}) ->
    D_a_t_a = <<(pack_guild_list(P0_guild_list))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40020:16,0:8, D_a_t_a/binary>>};


%% 一键申请帮派 
write(40021, {P0_code, P0_cd}) ->
    D_a_t_a = <<P0_code:16/signed, P0_cd:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40021:16,0:8, D_a_t_a/binary>>};


%% 获取入会条件 
write(40022, {P0_type, P0_lv, P0_cbp}) ->
    D_a_t_a = <<P0_type:8/signed, P0_lv:16/signed, P0_cbp:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40022:16,0:8, D_a_t_a/binary>>};


%% 设置入会条件 
write(40023, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40023:16,0:8, D_a_t_a/binary>>};


%% 帮派改名卡改名(20160706) 
write(40024, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40024:16,0:8, D_a_t_a/binary>>};


%% 发起弹劾 
write(40025, {P0_code, P0_name}) ->
    D_a_t_a = <<P0_code:16/signed, (proto:write_string(P0_name))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40025:16,0:8, D_a_t_a/binary>>};


%% 获取帮派奉献信息 
write(40030, {P0_dedicate, P0_g_dedicate, P0_g_lv_dedicate, P0_rank_list, P0_goods2ded, P0_gold2ded, P0_max_daily_gold, P0_daily_gold}) ->
    D_a_t_a = <<P0_dedicate:32, P0_g_dedicate:32, P0_g_lv_dedicate:32, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:16, P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_r_dedicate:32>> || [P1_rank, P1_pkey, P1_nickname, P1_r_dedicate] <- P0_rank_list]))/binary, P0_goods2ded:32, P0_gold2ded:32, P0_max_daily_gold:32, P0_daily_gold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40030:16,0:8, D_a_t_a/binary>>};


%% 帮派奉献 
write(40031, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40031:16,0:8, D_a_t_a/binary>>};


%% 领取奉献进度奖励 
write(40032, {P0_code, P0_dedicate_id}) ->
    D_a_t_a = <<P0_code:16/signed, P0_dedicate_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40032:16,0:8, D_a_t_a/binary>>};


%% 奉献日志 
write(40033, {P0_log_list}) ->
    D_a_t_a = <<(length(P0_log_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_type:8, P1_dedicate:32, P1_time:32/signed>> || [P1_pkey, P1_nickname, P1_type, P1_dedicate, P1_time] <- P0_log_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40033:16,0:8, D_a_t_a/binary>>};


%% 查看帮派技能列表信息 
write(40040, {P0_contrib, P0_skill_list, P0_attribute_list}) ->
    D_a_t_a = <<P0_contrib:32, (pack_skill_list(P0_skill_list))/binary, (pack_skill_attribute_list(P0_attribute_list))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40040:16,0:8, D_a_t_a/binary>>};


%% 提升帮派等级 
write(40041, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40041:16,0:8, D_a_t_a/binary>>};


%% 查看仙盟神兽信息 
write(40050, {P0_boss_star, P0_boss_exp, P0_boss_exp_limit, P0_goods_exp, P0_mon_id, P0_gold_cost, P0_gold_exp, P0_sp_boos_cost, P0_sp_boos_star, P0_sp_boos_mon_id, P0_last_name, P0_sp_call_list}) ->
    D_a_t_a = <<P0_boss_star:32/signed, P0_boss_exp:32/signed, P0_boss_exp_limit:32/signed, P0_goods_exp:32/signed, P0_mon_id:32/signed, P0_gold_cost:32/signed, P0_gold_exp:32/signed, P0_sp_boos_cost:32/signed, P0_sp_boos_star:32/signed, P0_sp_boos_mon_id:32/signed, (proto:write_string(P0_last_name))/binary, (length(P0_sp_call_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_sp_call_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40050:16,0:8, D_a_t_a/binary>>};


%% 仙盟神兽喂养 
write(40051, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40051:16,0:8, D_a_t_a/binary>>};


%% 仙盟神兽特殊召唤 
write(40052, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40052:16,0:8, D_a_t_a/binary>>};


%% 仙盟神兽活动状态 
write(40053, {P0_state, P0_leave_time}) ->
    D_a_t_a = <<P0_state:16/signed, P0_leave_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40053:16,0:8, D_a_t_a/binary>>};


%% 仙盟神兽获取伤害排名 
write(40054, {P0_my_rank, P0_my_damage, P0_damage_list}) ->
    D_a_t_a = <<P0_my_rank:16/signed, P0_my_damage:32/signed, (length(P0_damage_list)):16, (list_to_binary([<<P1_rank:32, (proto:write_string(P1_nickname))/binary, P1_damage:32>> || [P1_rank, P1_nickname, P1_damage] <- P0_damage_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40054:16,0:8, D_a_t_a/binary>>};


%% 仙盟神兽奖励 
write(40055, {P0_leave_time, P0_kill_list, P0_rank_list}) ->
    D_a_t_a = <<P0_leave_time:32/signed, (length(P0_kill_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_kill_list]))/binary, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank_up:32, P1_rank_down:32, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_rank_up, P1_rank_down, P1_reward_list] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40055:16,0:8, D_a_t_a/binary>>};


%% 仙盟神兽神兽状态 
write(40056, {P0_state}) ->
    D_a_t_a = <<P0_state:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40056:16,0:8, D_a_t_a/binary>>};


%% 仙盟神兽神兽血量 
write(40057, {P0_hp, P0_hp_lim}) ->
    D_a_t_a = <<P0_hp:32/signed, P0_hp_lim:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40057:16,0:8, D_a_t_a/binary>>};


%% 修改仙盟图标 
write(40060, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40060:16,0:8, D_a_t_a/binary>>};


%% 获取仙盟图标信息 
write(40061, {P0_reward_list}) ->
    D_a_t_a = <<(length(P0_reward_list)):16, (list_to_binary([<<P1_id:16, P1_icon:32, P1_limit:16>> || [P1_id, P1_icon, P1_limit] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40061:16,0:8, D_a_t_a/binary>>};


%% 查看活跃排名 
write(40071, {P0_rank_list, P0_my_hy_val}) ->
    D_a_t_a = <<(length(P0_rank_list)):16, (list_to_binary([<<(proto:write_string(P1_pname))/binary, P1_position:8, P1_hy_val:32>> || [P1_pname, P1_position, P1_hy_val] <- P0_rank_list]))/binary, P0_my_hy_val:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40071:16,0:8, D_a_t_a/binary>>};


%% 领取每日活跃奖励 
write(40072, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40072:16,0:8, D_a_t_a/binary>>};


%% 点赞 
write(40073, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40073:16,0:8, D_a_t_a/binary>>};


%% 查看福利信息 
write(40075, {P0_get_state, P0_lv, P0_goods_list, P0_next_lv, P0_next_goods_list}) ->
    D_a_t_a = <<P0_get_state:8, P0_lv:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary, P0_next_lv:32, (length(P0_next_goods_list)):16, (list_to_binary([<<P1_next_goods_id:32, P1_next_goods_num:32>> || [P1_next_goods_id, P1_next_goods_num] <- P0_next_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40075:16,0:8, D_a_t_a/binary>>};


%% 领取每日福利 
write(40076, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40076:16,0:8, D_a_t_a/binary>>};


%% 获取妖魔入侵面板信息 
write(40080, {P0_floor, P0_max_floor, P0_need_lv, P0_reduce, P0_pname, P0_pcareer, P0_psex, P0_avatar, P0_pfloor, P0_add, P0_times, P0_pass_gift_list, P0_cur_dun_id, P0_dun_list, P0_can_sweep}) ->
    D_a_t_a = <<P0_floor:8, P0_max_floor:8, P0_need_lv:16, P0_reduce:16, (proto:write_string(P0_pname))/binary, P0_pcareer:8/signed, P0_psex:8/signed, (proto:write_string(P0_avatar))/binary, P0_pfloor:8, P0_add:16, P0_times:8, (length(P0_pass_gift_list)):16, (list_to_binary([<<P1_need_floor:32, P1_pass_num:32, (length(P1_gift_list)):16, (list_to_binary([<<P2_gift_id:32, P2_pass_num:16, P2_state:8>> || [P2_gift_id, P2_pass_num, P2_state] <- P1_gift_list]))/binary>> || [P1_need_floor, P1_pass_num, P1_gift_list] <- P0_pass_gift_list]))/binary, P0_cur_dun_id:32, (length(P0_dun_list)):16, (list_to_binary([<<P1_dun_id:32/signed, P1_round_min:16/signed, P1_round_max:16/signed>> || [P1_dun_id, P1_round_min, P1_round_max] <- P0_dun_list]))/binary, P0_can_sweep:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40080:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(40081, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40081:16,0:8, D_a_t_a/binary>>};


%% 一键扫荡 
write(40082, {P0_res, P0_floor, P0_goods_list}) ->
    D_a_t_a = <<P0_res:16, P0_floor:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40082:16,0:8, D_a_t_a/binary>>};


%% 获取今日助威 
write(40083, {P0_cheer_add, P0_be_cheer_times, P0_max_be_cheer_times, P0_leave_cheer_times, P0_cheer_help, P0_list}) ->
    D_a_t_a = <<P0_cheer_add:16, P0_be_cheer_times:8, P0_max_be_cheer_times:8, P0_leave_cheer_times:8, P0_cheer_help:8, (length(P0_list)):16, (list_to_binary([<<(proto:write_string(P1_pname))/binary, P1_pkey:32, P1_cbp:32, P1_lv:8, P1_last_login_time:32, P1_cheer_times:8, P1_max_cheer_times:8, P1_cheer_add:16, P1_is_cheer:8>> || [P1_pname, P1_pkey, P1_cbp, P1_lv, P1_last_login_time, P1_cheer_times, P1_max_cheer_times, P1_cheer_add, P1_is_cheer] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40083:16,0:8, D_a_t_a/binary>>};


%% 获取我的助威 
write(40084, {P0_cheer_add, P0_be_cheer_times, P0_max_be_cheer_times, P0_leave_cheer_times, P0_cheer_help, P0_list}) ->
    D_a_t_a = <<P0_cheer_add:16, P0_be_cheer_times:8, P0_max_be_cheer_times:8, P0_leave_cheer_times:8, P0_cheer_help:8, (length(P0_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_cbp:32, P1_lv:16, P1_last_login_time:32, P1_cheer_times:8, P1_is_friend:8>> || [P1_pkey, P1_pname, P1_cbp, P1_lv, P1_last_login_time, P1_cheer_times, P1_is_friend] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40084:16,0:8, D_a_t_a/binary>>};


%% 助威 
write(40085, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40085:16,0:8, D_a_t_a/binary>>};


%% 请求助威 
write(40086, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40086:16,0:8, D_a_t_a/binary>>};


%% 请求助威通知 
write(40087, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_name))/binary, P1_career:8, P1_sex:8, (proto:write_string(P1_avatar))/binary>> || [P1_pkey, P1_name, P1_career, P1_sex, P1_avatar] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40087:16,0:8, D_a_t_a/binary>>};


%% 获取仙盟宝箱信息 
write(40090, {P0_free_count, P0_free_count_all, P0_get_count, P0_get_count_all, P0_cd_time, P0_is_cd, P0_index_box_id, P0_up_cost, P0_other_reward, P0_clean_get_cd_cost, P0_clean_help_cd_cost, P0_my_box}) ->
    D_a_t_a = <<P0_free_count:32, P0_free_count_all:32, P0_get_count:32, P0_get_count_all:32, P0_cd_time:32, P0_is_cd:32, P0_index_box_id:32, P0_up_cost:32, P0_other_reward:32, P0_clean_get_cd_cost:32, P0_clean_help_cd_cost:32, (length(P0_my_box)):16, (list_to_binary([<<(proto:write_string(P1_box_key))/binary, P1_base_id:32, P1_state:32, P1_leavetime:32, P1_hkey:32, (proto:write_string(P1_hname))/binary, (length(P1_box_reward)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_box_reward]))/binary>> || [P1_box_key, P1_base_id, P1_state, P1_leavetime, P1_hkey, P1_hname, P1_box_reward] <- P0_my_box]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40090:16,0:8, D_a_t_a/binary>>};


%% 获取已协助列表 
write(40091, {P0_my_box}) ->
    D_a_t_a = <<(length(P0_my_box)):16, (list_to_binary([<<(proto:write_string(P1_box_key))/binary, P1_base_id:32, P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_hkey:32, (proto:write_string(P1_hname))/binary, P1_leavetime:32, (length(P1_box_reward)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_box_reward]))/binary, (length(P1_box_help_reward)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_box_help_reward]))/binary>> || [P1_box_key, P1_base_id, P1_pkey, P1_pname, P1_hkey, P1_hname, P1_leavetime, P1_box_reward, P1_box_help_reward] <- P0_my_box]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40091:16,0:8, D_a_t_a/binary>>};


%% 获取可协助列表 
write(40092, {P0_help_count, P0_help_count_all, P0_help_cd_time, P0_is_help_cd, P0_my_box}) ->
    D_a_t_a = <<P0_help_count:32, P0_help_count_all:32, P0_help_cd_time:32, P0_is_help_cd:32, (length(P0_my_box)):16, (list_to_binary([<<(proto:write_string(P1_box_key))/binary, P1_base_id:32, P1_leavetime:32, P1_pkey:32, (proto:write_string(P1_pname))/binary, (length(P1_box_reward)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_box_reward]))/binary, (length(P1_box_help_reward)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_box_help_reward]))/binary>> || [P1_box_key, P1_base_id, P1_leavetime, P1_pkey, P1_pname, P1_box_reward, P1_box_help_reward] <- P0_my_box]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40092:16,0:8, D_a_t_a/binary>>};


%% 获取新宝箱 
write(40093, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40093:16,0:8, D_a_t_a/binary>>};


%% 提升宝箱品质 
write(40094, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40094:16,0:8, D_a_t_a/binary>>};


%% 协助宝箱 
write(40095, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40095:16,0:8, D_a_t_a/binary>>};


%% 清除获取cd 
write(40096, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40096:16,0:8, D_a_t_a/binary>>};


%% 清除协助cd 
write(40097, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40097:16,0:8, D_a_t_a/binary>>};


%% 领取宝箱 
write(40098, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40098:16,0:8, D_a_t_a/binary>>};


%% 求助 
write(40099, {P0_res}) ->
    D_a_t_a = <<P0_res:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40099:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_guild_log_list(P0_log_list) ->
    D_a_t_a = <<(length(P0_log_list)):16, (list_to_binary([<<P1_time:32, (proto:write_string(P1_msg))/binary>> || [P1_time, P1_msg] <- P0_log_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_guild_chat(P0_chat_list) ->
    D_a_t_a = <<(length(P0_chat_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_career:8/signed, (proto:write_string(P1_content))/binary, P1_time:32/signed>> || [P1_pkey, P1_pname, P1_career, P1_content, P1_time] <- P0_chat_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_guild_star(P0_star_list) ->
    D_a_t_a = <<(length(P0_star_list)):16, (list_to_binary([<<P1_type:8/signed, (proto:write_string(P1_pname))/binary>> || [P1_type, P1_pname] <- P0_star_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_guild_list(P0_guild_list) ->
    D_a_t_a = <<(length(P0_guild_list)):16, (list_to_binary([<<P1_rank:16/signed, (proto:write_string(P1_gkey))/binary, (proto:write_string(P1_gname))/binary, P1_realm:8, (proto:write_string(P1_nickname))/binary, P1_pvip:8, P1_lv:8/signed, P1_cbp:32, P1_num:8/signed, P1_max_num:32, (proto:write_string(P1_notice))/binary, P1_is_apply:8/signed, P1_from:8/signed, P1_join_type:8/signed, P1_join_lv:16/signed, P1_join_cbp:32/signed, P1_guild_icon:32/signed, (pack_guild_star(P1_g_star))/binary>> || [P1_rank, P1_gkey, P1_gname, P1_realm, P1_nickname, P1_pvip, P1_lv, P1_cbp, P1_num, P1_max_num, P1_notice, P1_is_apply, P1_from, P1_join_type, P1_join_lv, P1_join_cbp, P1_guild_icon, P1_g_star] <- P0_guild_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_guild_member_list(P0_guild_member_list) ->
    D_a_t_a = <<(length(P0_guild_member_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_career:8, P1_sex:8, P1_position:8, P1_acc_contrib:32, P1_lv:16, P1_power:32, P1_is_online:8/signed, P1_last_login_time:32/signed, P1_vip:8, (proto:write_string(P1_comefrom))/binary, P1_is_friend:8, (proto:write_string(P1_avatar))/binary>> || [P1_pkey, P1_pname, P1_career, P1_sex, P1_position, P1_acc_contrib, P1_lv, P1_power, P1_is_online, P1_last_login_time, P1_vip, P1_comefrom, P1_is_friend, P1_avatar] <- P0_guild_member_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_guild_apply_list(P0_apply_list) ->
    D_a_t_a = <<(length(P0_apply_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_vip:8, P1_career:8, P1_lv:8, P1_power:32>> || [P1_pkey, P1_pname, P1_vip, P1_career, P1_lv, P1_power] <- P0_apply_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_skill_list(P0_skill_list) ->
    D_a_t_a = <<(length(P0_skill_list)):16, (list_to_binary([<<P1_sid:32, (proto:write_string(P1_name))/binary, (proto:write_string(P1_desc))/binary, P1_lv:8/signed, P1_max_lv:8/signed, P1_attribute:16, P1_next_lv:8/signed, P1_next_attribute:16, (proto:write_string(P1_next_desc))/binary, P1_is_up:8/signed, P1_glv:8/signed, P1_plv:8/signed, P1_contrib:32>> || [P1_sid, P1_name, P1_desc, P1_lv, P1_max_lv, P1_attribute, P1_next_lv, P1_next_attribute, P1_next_desc, P1_is_up, P1_glv, P1_plv, P1_contrib] <- P0_skill_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_skill_attribute_list(P0_attribute_list) ->
    D_a_t_a = <<(length(P0_attribute_list)):16, (list_to_binary([<<P1_type:8, P1_val:32/signed>> || [P1_type, P1_val] <- P0_attribute_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_task_progress_list(P0_progress_list) ->
    D_a_t_a = <<(length(P0_progress_list)):16, (list_to_binary([<<P1_process:32, P1_is_award:8, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_process, P1_is_award, P1_goods_list] <- P0_progress_list]))/binary>>,
    <<D_a_t_a/binary>>.




