%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-09-13 23:49:51
%%----------------------------------------------------
-module(pt_404).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"还不是钻石vip"; 
err(3) ->"已经是钻石vip，购买失败"; 
err(4) ->"元宝不足"; 
err(5) ->"不是钻石vip或者永久vip，不能兑换"; 
err(6) ->"今日兑换已经达到上限"; 
err(7) ->"兑换绑定钻石不足"; 
err(8) ->"银币不足"; 
err(9) ->"元宝不足"; 
err(10) ->"绑定元宝不足"; 
err(11) ->"钻石不足"; 
err(12) ->"客户端请求有误"; 
err(13) ->"转换限时物品不足"; 
err(14) ->"非永久vip,不能领取两次"; 
err(15) ->"领取次数已达到上限了"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(40401, _B0) ->
    {ok, {}};

read(40402, _B0) ->
    {ok, {}};

read(40403, _B0) ->
    {ok, {}};

read(40404, _B0) ->
    {ok, {}};

read(40405, _B0) ->
    {ok, {}};

read(40406, _B0) ->
    {P0_index, _B1} = proto:read_uint8(_B0),
    {P0_num, _B2} = proto:read_uint8(_B1),
    {ok, {P0_index, P0_num}};

read(40407, _B0) ->
    {ok, {}};

read(40408, _B0) ->
    {P0_time, _B1} = proto:read_uint8(_B0),
    {ok, {P0_time}};

read(40409, _B0) ->
    {ok, {}};

read(40410, _B0) ->
    {P0_index_id, _B1} = proto:read_uint8(_B0),
    {P0_time, _B2} = proto:read_uint8(_B1),
    {ok, {P0_index_id, P0_time}};

read(40411, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% vip状态 
write(40401, {P0_state, P0_cost, P0_effect_time, P0_left_time, P0_award, P0_award_list}) ->
    D_a_t_a = <<P0_state:8, P0_cost:32, P0_effect_time:32, P0_left_time:32, P0_award:8, (length(P0_award_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_award_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40401:16,0:8, D_a_t_a/binary>>};


%% 请求成为永久vip信息 
write(40402, {P0_charge_today, P0_charge_list, P0_charge_now, P0_charge_total}) ->
    D_a_t_a = <<P0_charge_today:8, (length(P0_charge_list)):16, (list_to_binary([<<P1_day:8, P1_is_charge:8>> || [P1_day, P1_is_charge] <- P0_charge_list]))/binary, P0_charge_now:32, P0_charge_total:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40402:16,0:8, D_a_t_a/binary>>};


%% 领取钻石vip每日礼包 
write(40403, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40403:16,0:8, D_a_t_a/binary>>};


%% 购买钻石vip 
write(40404, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40404:16,0:8, D_a_t_a/binary>>};


%% 钻石商城信息 
write(40405, {P0_diamond, P0_market_list}) ->
    D_a_t_a = <<P0_diamond:32, (length(P0_market_list)):16, (list_to_binary([<<P1_index:8, P1_goods_id:32, P1_goods_num:32, P1_ex_type:8, P1_ex_cost:32, P1_ex_time:16, P1_is_onece:8>> || [P1_index, P1_goods_id, P1_goods_num, P1_ex_type, P1_ex_cost, P1_ex_time, P1_is_onece] <- P0_market_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40405:16,0:8, D_a_t_a/binary>>};


%% 兑换钻石商城物品 
write(40406, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40406:16,0:8, D_a_t_a/binary>>};


%% 元宝兑换界面信息 
write(40407, {P0_vip_lv, P0_add_cnt, P0_current, P0_max, P0_bgold, P0_gold}) ->
    D_a_t_a = <<P0_vip_lv:8, P0_add_cnt:8, P0_current:8, P0_max:8, P0_bgold:32, P0_gold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40407:16,0:8, D_a_t_a/binary>>};


%% 元宝兑换 
write(40408, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40408:16,0:8, D_a_t_a/binary>>};


%% 进阶丹兑换界面 
write(40409, {P0_vip_lv, P0_add_cnt, P0_current, P0_max, P0_ex_list}) ->
    D_a_t_a = <<P0_vip_lv:8, P0_add_cnt:8, P0_current:8, P0_max:8, (length(P0_ex_list)):16, (list_to_binary([<<P1_index_id:8, (proto:write_string(P1_ex_name))/binary, P1_goods_id:32/signed, P1_goods_num:32/signed, P1_gold:32/signed, P1_goods_id2:32/signed, P1_goods_num2:32/signed>> || [P1_index_id, P1_ex_name, P1_goods_id, P1_goods_num, P1_gold, P1_goods_id2, P1_goods_num2] <- P0_ex_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40409:16,0:8, D_a_t_a/binary>>};


%% 进阶丹转换 
write(40410, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40410:16,0:8, D_a_t_a/binary>>};


%% 状态推送 
write(40411, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40411:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



