%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-03-17 17:02:08
%%----------------------------------------------------
-module(pt_402).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"未加入仙盟"; 
err(3) ->"请联系长老及以上成员进行报名"; 
err(4) ->"当前非领地战报名时间"; 
err(5) ->"已经报名"; 
err(6) ->"任务目标未达成"; 
err(7) ->"任务目标奖励已领取"; 
err(8) ->"任务目标奖励不存在"; 
err(9) ->"请联系长老及以上成员开启晚宴"; 
err(10) ->"您所在的仙盟没有占领领地,没有晚宴可开启"; 
err(11) ->"开启晚宴过期,下次请早"; 
err(12) ->"晚宴开启中"; 
err(13) ->"晚宴已开启过"; 
err(14) ->"不能在该场景开启晚宴"; 
err(15) ->"你所在的仙盟没有开启晚宴"; 
err(16) ->"元宝不足"; 
err(17) ->"晚宴等级已满"; 
err(18) ->"玩家不在线"; 
err(19) ->"不能向自己敬酒"; 
err(20) ->"只能向本仙盟玩家敬酒"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(40201, _B0) ->
    {ok, {}};

read(40202, _B0) ->
    {ok, {}};

read(40203, _B0) ->
    {ok, {}};

read(40204, _B0) ->
    {ok, {}};

read(40205, _B0) ->
    {ok, {}};

read(40206, _B0) ->
    {ok, {}};

read(40207, _B0) ->
    {P0_target_id, _B1} = proto:read_int32(_B0),
    {P0_stage, _B2} = proto:read_int8(_B1),
    {ok, {P0_target_id, P0_stage}};

read(40210, _B0) ->
    {ok, {}};

read(40211, _B0) ->
    {P0_scene, _B1} = proto:read_int32(_B0),
    {ok, {P0_scene}};

read(40212, _B0) ->
    {ok, {}};

read(40213, _B0) ->
    {P0_gold, _B1} = proto:read_int32(_B0),
    {ok, {P0_gold}};

read(40214, _B0) ->
    {P0_pkey, _B1} = proto:read_int32(_B0),
    {ok, {P0_pkey}};

read(40215, _B0) ->
    {ok, {}};

read(40216, _B0) ->
    {ok, {}};

read(40217, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 领地战状态 
write(40201, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40201:16,0:8, D_a_t_a/binary>>};


%% 获取领地占领列表 
write(40202, {P0_state, P0_time, P0_is_apply, P0_list}) ->
    D_a_t_a = <<P0_state:8, P0_time:16/signed, P0_is_apply:8/signed, (length(P0_list)):16, (list_to_binary([<<P1_scene_id:32/signed, (proto:write_string(P1_g_name))/binary>> || [P1_scene_id, P1_g_name] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40202:16,0:8, D_a_t_a/binary>>};


%% 领地战报名 
write(40203, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40203:16,0:8, D_a_t_a/binary>>};


%% 领地战积分排行榜 
write(40204, {P0_my_score, P0_my_rank, P0_rank_list}) ->
    D_a_t_a = <<P0_my_score:32/signed, P0_my_rank:32/signed, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:32/signed, (proto:write_string(P1_g_name))/binary, (proto:write_string(P1_nickname))/binary, P1_score:32/signed>> || [P1_rank, P1_g_name, P1_nickname, P1_score] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40204:16,0:8, D_a_t_a/binary>>};


%% 获取我的目标 
write(40205, {P0_code, P0_target_list}) ->
    D_a_t_a = <<P0_code:8/signed, (length(P0_target_list)):16, (list_to_binary([<<P1_target_id:32/signed, P1_stage:8/signed, P1_times:32/signed, P1_times_lim:32/signed, P1_is_reward:8/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_num:32/signed>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_target_id, P1_stage, P1_times, P1_times_lim, P1_is_reward, P1_goods_list] <- P0_target_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40205:16,0:8, D_a_t_a/binary>>};


%% 目标达成通知 
write(40206, {P0_target_id, P0_stage}) ->
    D_a_t_a = <<P0_target_id:32/signed, P0_stage:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40206:16,0:8, D_a_t_a/binary>>};


%% 领取目标奖励 
write(40207, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40207:16,0:8, D_a_t_a/binary>>};


%% 查询晚宴信息 
write(40210, {P0_state, P0_lv, P0_exp, P0_exp_lim, P0_scene, P0_full, P0_contribute_list, P0_manor_list, P0_goods_list}) ->
    D_a_t_a = <<P0_state:8/signed, P0_lv:16/signed, P0_exp:32/signed, P0_exp_lim:32/signed, P0_scene:32/signed, P0_full:8/signed, (length(P0_contribute_list)):16, (list_to_binary([<<P1_pkey:32/signed, (proto:write_string(P1_nickname))/binary, P1_gold:32/signed>> || [P1_pkey, P1_nickname, P1_gold] <- P0_contribute_list]))/binary, (length(P0_manor_list)):16, (list_to_binary([<<P1_sid:32/signed>> || P1_sid <- P0_manor_list]))/binary, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40210:16,0:8, D_a_t_a/binary>>};


%% 开启晚宴 
write(40211, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40211:16,0:8, D_a_t_a/binary>>};


%% 通知晚宴开启 
write(40212, {P0_scene, P0_x, P0_y}) ->
    D_a_t_a = <<P0_scene:32/signed, P0_x:8/signed, P0_y:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40212:16,0:8, D_a_t_a/binary>>};


%% 晚宴贡献 
write(40213, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40213:16,0:8, D_a_t_a/binary>>};


%% 敬酒 
write(40214, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40214:16,0:8, D_a_t_a/binary>>};


%% 摇塞子 
write(40215, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40215:16,0:8, D_a_t_a/binary>>};


%% 塞子信息 
write(40216, {P0_pkey, P0_is_same, P0_list}) ->
    D_a_t_a = <<P0_pkey:32/signed, P0_is_same:8/signed, (length(P0_list)):16, (list_to_binary([<<P1_num:8/signed>> || P1_num <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40216:16,0:8, D_a_t_a/binary>>};


%% 敬酒信息 
write(40217, {P0_key, P0_msg}) ->
    D_a_t_a = <<P0_key:32, (proto:write_string(P0_msg))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40217:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



