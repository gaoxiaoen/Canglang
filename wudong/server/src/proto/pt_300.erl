%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-08-22 19:32:26
%%----------------------------------------------------
-module(pt_300).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(3) ->"当前任务不可接"; 
err(4) ->"当前任务已接"; 
err(5) ->"等级不足"; 
err(6) ->"任务未完成"; 
err(7) ->"任务未接"; 
err(8) ->"上一任务未完成"; 
err(9) ->"今日跑环任务已全部完成"; 
err(10) ->"元宝不足以支付一键完成"; 
err(11) ->"任务配置错误"; 
err(12) ->"跑环任务满环奖励已领取"; 
err(13) ->"跑环任务未满环，不能领取"; 
err(14) ->"今日跑环任务已全部完成"; 
err(15) ->"当前任务已是五星喔"; 
err(16) ->"任务已经领取,不能刷星"; 
err(17) ->"您的元宝不足以支付刷星"; 
err(18) ->"任务不存在"; 
err(20) ->"您今日可护送次数已满"; 
err(21) ->"您已经接了护送任务"; 
err(22) ->"该品质的护送任务不存在"; 
err(23) ->"护送任务配置错误"; 
err(24) ->"您的元宝不足以支付护送"; 
err(25) ->"你没有领取护送任务"; 
err(26) ->"神佑已经使用"; 
err(27) ->"你在护送中,不能协助"; 
err(28) ->"会员等级不足"; 
err(29) ->"您离npc太远了，不能和他对话"; 
err(30) ->"元宝不足以支付刷新"; 
err(31) ->"护送任务已经领取,不能刷新"; 
err(32) ->"无需刷新，已经是橙色最高品质"; 
err(33) ->"当前品质更高,无需刷新"; 
err(34) ->"已接受任务,不能刷星"; 
err(35) ->"元宝不足以支付刷新"; 
err(36) ->"等级不足"; 
err(37) ->"已接受任务,不能重复接"; 
err(38) ->"请先接受任务"; 
err(39) ->"元宝不足以支付完成"; 
err(40) ->"任务未全部完成 "; 
err(41) ->"奖励已领取"; 
err(42) ->"今日任务已全部完成"; 
err(43) ->"未加入仙盟"; 
err(44) ->"美女令不足,无法刷新"; 
err(45) ->"自动购买价格配置异常"; 
err(46) ->"玩家已经离线"; 
err(47) ->"普通野外场景才能前往协助"; 
err(48) ->"对方没有在护送中"; 
err(49) ->"已发送求救信息"; 
err(50) ->"任务已完成"; 
err(51) ->"元宝不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(30001, _B0) ->
    {ok, {}};

read(30002, _B0) ->
    {P0_taskid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_taskid}};

read(30003, _B0) ->
    {P0_taskid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_taskid}};

read(30004, _B0) ->
    {ok, {}};

read(30005, _B0) ->
    {ok, {}};

read(30006, _B0) ->
    {ok, {}};

read(30007, _B0) ->
    {P0_story_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_story_id}};

read(30008, _B0) ->
    {P0_taskid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_taskid}};

read(30009, _B0) ->
    {ok, {}};

read(30010, _B0) ->
    {ok, {}};

read(30011, _B0) ->
    {ok, {}};

read(30020, _B0) ->
    {ok, {}};

read(30021, _B0) ->
    {ok, {}};

read(30022, _B0) ->
    {P0_color, _B1} = proto:read_int8(_B0),
    {P0_auto, _B2} = proto:read_int8(_B1),
    {ok, {P0_color, P0_auto}};

read(30023, _B0) ->
    {ok, {}};

read(30024, _B0) ->
    {ok, {}};

read(30025, _B0) ->
    {ok, {}};

read(30026, _B0) ->
    {ok, {}};

read(30027, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(30028, _B0) ->
    {ok, {}};

read(30029, _B0) ->
    {ok, {}};

read(30030, _B0) ->
    {ok, {}};

read(30031, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(30032, _B0) ->
    {P0_tid, _B1} = proto:read_int32(_B0),
    {ok, {P0_tid}};

read(30033, _B0) ->
    {ok, {}};

read(30034, _B0) ->
    {ok, {}};

read(30035, _B0) ->
    {ok, {}};

read(30040, _B0) ->
    {ok, {}};

read(30041, _B0) ->
    {ok, {}};

read(30043, _B0) ->
    {ok, {}};

read(30044, _B0) ->
    {P0_task_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_task_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 任务列表 
write(30001, {P0_tasklist}) ->
    D_a_t_a = <<(length(P0_tasklist)):16, (list_to_binary([<<P1_taskid:32, P1_state:8/signed, P1_act:8, P1_times:16, P1_times_lim:16, (length(P1_actinfo)):16, (list_to_binary([<<P2_monid:32, P2_targetnum:16, P2_curnum:16>> || [P2_monid, P2_targetnum, P2_curnum] <- P1_actinfo]))/binary>> || [P1_taskid, P1_state, P1_act, P1_times, P1_times_lim, P1_actinfo] <- P0_tasklist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30001:16,0:8, D_a_t_a/binary>>};


%% 触发任务 
write(30002, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30002:16,0:8, D_a_t_a/binary>>};


%% 完成任务 
write(30003, {P0_code, P0_taskid}) ->
    D_a_t_a = <<P0_code:8, P0_taskid:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30003:16,0:8, D_a_t_a/binary>>};


%% 更新单个任务数据 
write(30004, {P0_taskid, P0_state, P0_act, P0_times, P0_times_lim, P0_actinfo}) ->
    D_a_t_a = <<P0_taskid:32, P0_state:8/signed, P0_act:8, P0_times:16, P0_times_lim:16, (length(P0_actinfo)):16, (list_to_binary([<<P1_monid:32, P1_targetnum:16, P1_curnum:16>> || [P1_monid, P1_targetnum, P1_curnum] <- P0_actinfo]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30004:16,0:8, D_a_t_a/binary>>};


%% 新增任务数据 
write(30005, {P0_taskid, P0_state, P0_act, P0_times, P0_times_lim, P0_actinfo}) ->
    D_a_t_a = <<P0_taskid:32, P0_state:8/signed, P0_act:8, P0_times:16, P0_times_lim:16, (length(P0_actinfo)):16, (list_to_binary([<<P1_monid:32, P1_targetnum:16, P1_curnum:16>> || [P1_monid, P1_targetnum, P1_curnum] <- P0_actinfo]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30005:16,0:8, D_a_t_a/binary>>};


%% 删除的任务 
write(30006, {P0_taskid}) ->
    D_a_t_a = <<P0_taskid:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30006:16,0:8, D_a_t_a/binary>>};


%% 剧情ID存储 
write(30007, {P0_story_id}) ->
    D_a_t_a = <<P0_story_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30007:16,0:8, D_a_t_a/binary>>};


%% 元宝立即完成当前悬赏任务 
write(30008, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30008:16,0:8, D_a_t_a/binary>>};


%% 点金任务-点金 
write(30009, {P0_code, P0_bgold}) ->
    D_a_t_a = <<P0_code:8, P0_bgold:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30009:16,0:8, D_a_t_a/binary>>};


%% 获取跑环任务一键完成费用 
write(30010, {P0_state, P0_price, P0_back, P0_goods, P0_goods_extra}) ->
    D_a_t_a = <<P0_state:8, P0_price:32, P0_back:32, (length(P0_goods)):16, (list_to_binary([<<P1_goodstype:32, P1_num:32>> || [P1_goodstype, P1_num] <- P0_goods]))/binary, (length(P0_goods_extra)):16, (list_to_binary([<<P1_goodstype:32, P1_num:32>> || [P1_goodstype, P1_num] <- P0_goods_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30010:16,0:8, D_a_t_a/binary>>};


%% 快速完成跑环任务 
write(30011, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30011:16,0:8, D_a_t_a/binary>>};


%% 护送任务活动时间通知 
write(30020, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30020:16,0:8, D_a_t_a/binary>>};


%% 获取护送信息 
write(30021, {P0_color, P0_times, P0_isdouble, P0_timeout, P0_goods_list}) ->
    D_a_t_a = <<P0_color:8, P0_times:8, P0_isdouble:8/signed, P0_timeout:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30021:16,0:8, D_a_t_a/binary>>};


%% 刷新护送品质 
write(30022, {P0_code, P0_color}) ->
    D_a_t_a = <<P0_code:8/signed, P0_color:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30022:16,0:8, D_a_t_a/binary>>};


%% 领取护送（提交护送任务走30003） 
write(30023, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30023:16,0:8, D_a_t_a/binary>>};


%% 获取护送中信息 
write(30024, {P0_time, P0_use_protest}) ->
    D_a_t_a = <<P0_time:16/signed, P0_use_protest:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30024:16,0:8, D_a_t_a/binary>>};


%% 使用神佑 
write(30025, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30025:16,0:8, D_a_t_a/binary>>};


%% 请求帮助 
write(30026, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30026:16,0:8, D_a_t_a/binary>>};


%% 护送协助 
write(30027, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30027:16,0:8, D_a_t_a/binary>>};


%% 护送结果 
write(30028, {P0_type, P0_times, P0_goods_list}) ->
    D_a_t_a = <<P0_type:8/signed, P0_times:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30028:16,0:8, D_a_t_a/binary>>};


%% 劫镖信息 
write(30029, {P0_nickname, P0_goods_list}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30029:16,0:8, D_a_t_a/binary>>};


%% 天天任务信息 
write(30030, {P0_times, P0_times_lim, P0_refresh_free, P0_goods_id, P0_goods_num, P0_refresh_gold, P0_finish_gold, P0_finish_reward, P0_goods_list, P0_task_list}) ->
    D_a_t_a = <<P0_times:8/signed, P0_times_lim:8/signed, P0_refresh_free:8/signed, P0_goods_id:32/signed, P0_goods_num:32/signed, P0_refresh_gold:8/signed, P0_finish_gold:8/signed, P0_finish_reward:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary, (length(P0_task_list)):16, (list_to_binary([<<P1_type:8/signed, P1_star:8/signed, P1_taskid:32, P1_state:8/signed, P1_act:8, (length(P1_actinfo)):16, (list_to_binary([<<P2_monid:32, P2_targetnum:16, P2_curnum:16>> || [P2_monid, P2_targetnum, P2_curnum] <- P1_actinfo]))/binary>> || [P1_type, P1_star, P1_taskid, P1_state, P1_act, P1_actinfo] <- P0_task_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30030:16,0:8, D_a_t_a/binary>>};


%% 刷新星级 
write(30031, {P0_code, P0_is_max}) ->
    D_a_t_a = <<P0_code:8/signed, P0_is_max:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30031:16,0:8, D_a_t_a/binary>>};


%% 接受任务 
write(30032, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30032:16,0:8, D_a_t_a/binary>>};


%% 元宝完成任务 
write(30033, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30033:16,0:8, D_a_t_a/binary>>};


%% 领取任务全部完成奖励 
write(30034, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30034:16,0:8, D_a_t_a/binary>>};


%% 天天任务状态 
write(30035, {P0_state}) ->
    D_a_t_a = <<P0_state:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30035:16,0:8, D_a_t_a/binary>>};


%% 获取仙盟任务一键完成费用 
write(30040, {P0_state, P0_price, P0_back, P0_goods, P0_goods_extra}) ->
    D_a_t_a = <<P0_state:8, P0_price:32, P0_back:32, (length(P0_goods)):16, (list_to_binary([<<P1_goodstype:32, P1_num:32>> || [P1_goodstype, P1_num] <- P0_goods]))/binary, (length(P0_goods_extra)):16, (list_to_binary([<<P1_goodstype:32, P1_num:32>> || [P1_goodstype, P1_num] <- P0_goods_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30040:16,0:8, D_a_t_a/binary>>};


%% 快速完成仙盟任务 
write(30041, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30041:16,0:8, D_a_t_a/binary>>};


%% 转职任务完成 
write(30043, {P0_code, P0_new_career}) ->
    D_a_t_a = <<P0_code:8, P0_new_career:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30043:16,0:8, D_a_t_a/binary>>};


%% 元宝一键转职任务完成 
write(30044, {P0_code, P0_new_career}) ->
    D_a_t_a = <<P0_code:8, P0_new_career:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 30044:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



