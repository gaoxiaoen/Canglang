%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_290).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"突破水晶不足"; 
err(3) ->"银两不足"; 
err(4) ->"冷却中"; 
err(5) ->"元宝不足"; 
err(6) ->"已满级"; 
err(7) ->"不能超过人物等级"; 
err(8) ->"人物等级不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(29000, _B0) ->
    {ok, {}};

read(29001, _B0) ->
    {P0_is_auto, _B1} = proto:read_uint8(_B0),
    {ok, {P0_is_auto}};

read(29002, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取原力信息 
write(29000, {P0_yl_list, P0_attr_list, P0_combatpower, P0_min_lv, P0_is_tupo, P0_tupo_pro, P0_cost_goods, P0_cur_tupo_lv, P0_tupo_attr_list, P0_next_tupo_lv, P0_next_tupo_attr_list, P0_need_lv, P0_cur_id, P0_cur_attr_list, P0_next_attr_list, P0_cost_coin, P0_cd_time, P0_clear_cd_cost, P0_have_goods_num, P0_vip_lv, P0_max_times, P0_leave_times}) ->
    D_a_t_a = <<(length(P0_yl_list)):16, (list_to_binary([<<P1_id:8, P1_lv:16>> || [P1_id, P1_lv] <- P0_yl_list]))/binary, (pack_attr(P0_attr_list))/binary, P0_combatpower:32, P0_min_lv:16, P0_is_tupo:8, P0_tupo_pro:8, P0_cost_goods:32, P0_cur_tupo_lv:16, (pack_attr(P0_tupo_attr_list))/binary, P0_next_tupo_lv:16, (pack_attr(P0_next_tupo_attr_list))/binary, P0_need_lv:16, P0_cur_id:8, (pack_attr(P0_cur_attr_list))/binary, (pack_attr(P0_next_attr_list))/binary, P0_cost_coin:32, P0_cd_time:32, P0_clear_cd_cost:32, P0_have_goods_num:32, P0_vip_lv:16, P0_max_times:16, P0_leave_times:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 29000:16,0:8, D_a_t_a/binary>>};


%% 提升/突破 
write(29001, {P0_res, P0_tupo_res}) ->
    D_a_t_a = <<P0_res:8, P0_tupo_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 29001:16,0:8, D_a_t_a/binary>>};


%% 清CD 
write(29002, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 29002:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_attr(P0_attrlist) ->
    D_a_t_a = <<(length(P0_attrlist)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_attrlist]))/binary>>,
    <<D_a_t_a/binary>>.




