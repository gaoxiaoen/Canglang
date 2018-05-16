%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_384).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"星运不存在"; 
err(3) ->"该星运已佩戴在其他位置"; 
err(4) ->"该位置已配置了其他星运"; 
err(5) ->"星运背包已满"; 
err(6) ->"该星运不在星运背包"; 
err(7) ->"该位置还没开启"; 
err(8) ->"星运背包没有可合成的物品"; 
err(9) ->"元宝不足"; 
err(10) ->"占星背包已满"; 
err(11) ->"改占星操作还没激活"; 
err(12) ->"已全部拾取完"; 
err(13) ->"被吞噬的星运不存在"; 
err(14) ->"被吞噬的星运重复"; 
err(15) ->"不可操作经验星运"; 
err(16) ->"银两不足"; 
err(17) ->"已佩戴相同类型的星运"; 
err(18) ->"会员等级不足"; 
err(19) ->"该星运已经满级"; 
err(20) ->"占星背包格子不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(38401, _B0) ->
    {ok, {}};

read(38402, _B0) ->
    {P0_pos, _B1} = proto:read_uint8(_B0),
    {P0_gkey, _B2} = proto:read_key(_B1),
    {ok, {P0_pos, P0_gkey}};

read(38403, _B0) ->
    {P0_gkey, _B1} = proto:read_key(_B0),
    {ok, {P0_gkey}};

read(38404, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(38405, _B0) ->
    {P0_gkey, _B1} = proto:read_key(_B0),
    {P0_gkey_list, _B4} = proto:read_array(_B1, fun(_B2) ->
        {P1_ts_gkey, _B3} = proto:read_key(_B2),
        {P1_ts_gkey, _B3}
    end),
    {ok, {P0_gkey, P0_gkey_list}};

read(38406, _B0) ->
    {P0_open_num, _B1} = proto:read_int8(_B0),
    {ok, {P0_open_num}};

read(38407, _B0) ->
    {P0_open_num, _B1} = proto:read_int8(_B0),
    {ok, {P0_open_num}};

read(38408, _B0) ->
    {ok, {}};

read(38409, _B0) ->
    {P0_opt, _B1} = proto:read_int8(_B0),
    {P0_type, _B2} = proto:read_int8(_B1),
    {ok, {P0_opt, P0_type}};

read(38410, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_gkey, _B2} = proto:read_key(_B1),
    {ok, {P0_type, P0_gkey}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取星运信息 
write(38401, {P0_player_list, P0_puton_list, P0_sum_attr_list, P0_combatpower, P0_open_bag_num, P0_bag_list}) ->
    D_a_t_a = <<(length(P0_player_list)):16, (list_to_binary([<<P1_pos:8, P1_state:8, P1_need_lv:16>> || [P1_pos, P1_state, P1_need_lv] <- P0_player_list]))/binary, (length(P0_puton_list)):16, (list_to_binary([<<P1_pos:8, (pack_star(P1_star_info))/binary>> || [P1_pos, P1_star_info] <- P0_puton_list]))/binary, (pack_attr(P0_sum_attr_list))/binary, P0_combatpower:32/signed, P0_open_bag_num:8, (length(P0_bag_list)):16, (list_to_binary([<<(pack_star(P1_star_info))/binary>> || P1_star_info <- P0_bag_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38401:16,0:8, D_a_t_a/binary>>};


%% 佩戴/卸下星运 
write(38402, {P0_res}) ->
    D_a_t_a = <<P0_res:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38402:16,0:8, D_a_t_a/binary>>};


%% 锁定/解锁 
write(38403, {P0_res, P0_gkey}) ->
    D_a_t_a = <<P0_res:8/signed, (proto:write_string(P0_gkey))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38403:16,0:8, D_a_t_a/binary>>};


%% 一键合成 
write(38404, {P0_res, P0_type, P0_star_info}) ->
    D_a_t_a = <<P0_res:8/signed, P0_type:8/signed, (pack_star(P0_star_info))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38404:16,0:8, D_a_t_a/binary>>};


%% 吞噬 
write(38405, {P0_res, P0_star_info}) ->
    D_a_t_a = <<P0_res:8/signed, (pack_star(P0_star_info))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38405:16,0:8, D_a_t_a/binary>>};


%% 开启格子消耗 
write(38406, {P0_cost_gold, P0_open_num}) ->
    D_a_t_a = <<P0_cost_gold:32/signed, P0_open_num:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38406:16,0:8, D_a_t_a/binary>>};


%% 开启格子 
write(38407, {P0_res}) ->
    D_a_t_a = <<P0_res:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38407:16,0:8, D_a_t_a/binary>>};


%% 获取占星信息 
write(38408, {P0_point, P0_leave_times, P0_free_times, P0_cost_gold, P0_cur_vip, P0_need_vip, P0_leave_double, P0_max_double, P0_act_type_list, P0_zx_bag_list}) ->
    D_a_t_a = <<P0_point:32/signed, P0_leave_times:32/signed, P0_free_times:32/signed, P0_cost_gold:32/signed, P0_cur_vip:8, P0_need_vip:8, P0_leave_double:8, P0_max_double:8, (length(P0_act_type_list)):16, (list_to_binary([<<P1_type:8/signed, P1_cost_bgold:32/signed, P1_cost_coin:32/signed>> || [P1_type, P1_cost_bgold, P1_cost_coin] <- P0_act_type_list]))/binary, (length(P0_zx_bag_list)):16, (list_to_binary([<<(pack_star(P1_star_info))/binary>> || P1_star_info <- P0_zx_bag_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38408:16,0:8, D_a_t_a/binary>>};


%% 占星 
write(38409, {P0_res, P0_opt, P0_type, P0_zx_get_list}) ->
    D_a_t_a = <<P0_res:8/signed, P0_opt:8/signed, P0_type:8/signed, (length(P0_zx_get_list)):16, (list_to_binary([<<(pack_star(P1_star_info))/binary>> || P1_star_info <- P0_zx_get_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38409:16,0:8, D_a_t_a/binary>>};


%% 拾取 
write(38410, {P0_res, P0_get_list}) ->
    D_a_t_a = <<P0_res:8/signed, (length(P0_get_list)):16, (list_to_binary([<<(pack_star(P1_star_info))/binary>> || P1_star_info <- P0_get_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38410:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_attr(P0_attrlist) ->
    D_a_t_a = <<(length(P0_attrlist)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_attrlist]))/binary>>,
    <<D_a_t_a/binary>>.


pack_star([P0_gkey, P0_pkey, P0_goods_id, P0_lv, P0_exp, P0_max_exp, P0_lock, P0_cbp, P0_attr_list, P0_next_attr_list]) ->
    D_a_t_a = <<(proto:write_string(P0_gkey))/binary, P0_pkey:32, P0_goods_id:32, P0_lv:8, P0_exp:32, P0_max_exp:32, P0_lock:8, P0_cbp:32, (pack_attr(P0_attr_list))/binary, (pack_attr(P0_next_attr_list))/binary>>,
    <<D_a_t_a/binary>>.




