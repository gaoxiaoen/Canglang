%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-03-16 10:35:13
%%----------------------------------------------------
-module(pt_560).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"野外普通场景才能进入首领场景"; 
err(3) ->"等级不足,不能进入"; 
err(4) ->"护送中,不能进入"; 
err(5) ->"首领场景未开放"; 
err(6) ->"场景人数爆满，不能进入"; 
err(7) ->"不在首领场景中"; 
err(8) ->"没有神行靴物品"; 
err(9) ->"已经"; 
err(10) ->"元宝不足"; 
err(11) ->"疲劳值已满，无法购买"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(56001, _B0) ->
    {ok, {}};

read(56002, _B0) ->
    {P0_sid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_sid}};

read(56003, _B0) ->
    {ok, {}};

read(56004, _B0) ->
    {ok, {}};

read(56005, _B0) ->
    {P0_scene, _B1} = proto:read_int32(_B0),
    {ok, {P0_scene}};

read(56006, _B0) ->
    {ok, {}};

read(56007, _B0) ->
    {P0_rkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_rkey}};

read(56010, _B0) ->
    {ok, {}};

read(56011, _B0) ->
    {ok, {}};

read(56021, _B0) ->
    {ok, {}};

read(56022, _B0) ->
    {P0_sid, _B1} = proto:read_uint32(_B0),
    {P0_copy, _B2} = proto:read_int8(_B1),
    {P0_mon_id, _B3} = proto:read_int32(_B2),
    {P0_x, _B4} = proto:read_int32(_B3),
    {P0_y, _B5} = proto:read_int32(_B4),
    {ok, {P0_sid, P0_copy, P0_mon_id, P0_x, P0_y}};

read(56023, _B0) ->
    {P0_buy_num, _B1} = proto:read_uint8(_B0),
    {ok, {P0_buy_num}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% boss列表 
write(56001, {P0_price, P0_remain_buy_num, P0_boss_list, P0_tired_val, P0_max_tired_val}) ->
    D_a_t_a = <<P0_price:32/signed, P0_remain_buy_num:32/signed, (length(P0_boss_list)):16, (list_to_binary([<<P1_scene:32/signed, P1_boss_id:32/signed, P1_type:8/signed, P1_lv:16/signed, P1_boss_state:8/signed, P1_is_pk:8/signed, P1_cd:32/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_scene, P1_boss_id, P1_type, P1_lv, P1_boss_state, P1_is_pk, P1_cd, P1_goods_list] <- P0_boss_list]))/binary, P0_tired_val:8/signed, P0_max_tired_val:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56001:16,0:8, D_a_t_a/binary>>};


%% 飞鞋进入boss场景 
write(56002, {P0_msg}) ->
    D_a_t_a = <<(proto:write_string(P0_msg))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56002:16,0:8, D_a_t_a/binary>>};


%% boss伤害数据 
write(56003, {P0_boss_id, P0_my_damage, P0_my_rank, P0_damage_list, P0_revive_time}) ->
    D_a_t_a = <<P0_boss_id:32, P0_my_damage:32/signed, P0_my_rank:16/signed, (length(P0_damage_list)):16, (list_to_binary([<<P1_sn:32/signed, (proto:write_string(P1_nickname))/binary, P1_damage:32/signed>> || [P1_sn, P1_nickname, P1_damage] <- P0_damage_list]))/binary, P0_revive_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56003:16,0:8, D_a_t_a/binary>>};


%% 周排行榜 
write(56004, {P0_rank_list}) ->
    D_a_t_a = <<(length(P0_rank_list)):16, (list_to_binary([<<P1_scene:32/signed, P1_mon_id:32/signed, P1_mon_lv:16/signed, P1_sn:32/signed, P1_pkey:32, (proto:write_string(P1_name))/binary, P1_career:8/signed, P1_sex:8, P1_vip:8/signed, P1_wing_id:32, P1_wepon_id:32, P1_clothing_id:32, P1_light_wepon_id:32, P1_fashion_cloth_id:32, P1_fashion_head_id:32/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_scene, P1_mon_id, P1_mon_lv, P1_sn, P1_pkey, P1_name, P1_career, P1_sex, P1_vip, P1_wing_id, P1_wepon_id, P1_clothing_id, P1_light_wepon_id, P1_fashion_cloth_id, P1_fashion_head_id, P1_goods_list] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56004:16,0:8, D_a_t_a/binary>>};


%% 具体榜单 
write(56005, {P0_mon_lv, P0_my_rank, P0_rank_list}) ->
    D_a_t_a = <<P0_mon_lv:16/signed, P0_my_rank:16/signed, (length(P0_rank_list)):16, (list_to_binary([<<P1_sn:32/signed, P1_pkey:32, (proto:write_string(P1_name))/binary, P1_lv:16/signed, P1_point:32/signed, P1_cbp:32/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_sn, P1_pkey, P1_name, P1_lv, P1_point, P1_cbp, P1_goods_list] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56005:16,0:8, D_a_t_a/binary>>};


%% roll信息 
write(56006, {P0_roll_id, P0_rkey, P0_gift_id, P0_leave_time, P0_max_point, P0_max_name, P0_my_point}) ->
    D_a_t_a = <<P0_roll_id:32, P0_rkey:32, P0_gift_id:32, P0_leave_time:32/signed, P0_max_point:16/signed, (proto:write_string(P0_max_name))/binary, P0_my_point:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56006:16,0:8, D_a_t_a/binary>>};


%% roll 
write(56007, {P0_res, P0_point}) ->
    D_a_t_a = <<P0_res:8/signed, P0_point:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56007:16,0:8, D_a_t_a/binary>>};


%% 击杀boss掉落 
write(56010, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56010:16,0:8, D_a_t_a/binary>>};


%% boss刷新通知 
write(56011, {P0_state, P0_leave_time}) ->
    D_a_t_a = <<P0_state:8/signed, P0_leave_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56011:16,0:8, D_a_t_a/binary>>};


%% 精英列表 
write(56021, {P0_tired_val, P0_max_tired_val, P0_mon_list}) ->
    D_a_t_a = <<P0_tired_val:8/signed, P0_max_tired_val:8/signed, (length(P0_mon_list)):16, (list_to_binary([<<P1_scene:32/signed, P1_mon_id:32/signed, P1_lv:16/signed, (length(P1_copy_list)):16, (list_to_binary([<<P2_copy:8/signed, P2_state:8/signed, P2_cd:32/signed, P2_x:32/signed, P2_y:32/signed>> || [P2_copy, P2_state, P2_cd, P2_x, P2_y] <- P1_copy_list]))/binary, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_scene, P1_mon_id, P1_lv, P1_copy_list, P1_goods_list] <- P0_mon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56021:16,0:8, D_a_t_a/binary>>};


%% 飞鞋进入精英场景 
write(56022, {P0_msg}) ->
    D_a_t_a = <<(proto:write_string(P0_msg))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56022:16,0:8, D_a_t_a/binary>>};


%% 购买挑战次数 
write(56023, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 56023:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



