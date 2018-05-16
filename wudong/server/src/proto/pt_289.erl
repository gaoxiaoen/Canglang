%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-10-10 15:57:48
%%----------------------------------------------------
-module(pt_289).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"您未婚，不可领取奖励"; 
err(3) ->"奖励已领取"; 
err(4) ->"您未婚，还不可为TA购买"; 
err(5) ->"元宝不足"; 
err(6) ->"已经为TA购买过"; 
err(7) ->"香囊过期,需重新购买"; 
err(8) ->"对方离线状态"; 
err(9) ->"当前未婚状态"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(28901, _B0) ->
    {ok, {}};

read(28902, _B0) ->
    {ok, {}};

read(28903, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(28904, _B0) ->
    {ok, {}};

read(28905, _B0) ->
    {ok, {}};

read(28906, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 香囊面板信息 
write(28901, {P0_state, P0_pkey, P0_nickname, P0_career, P0_sex, P0_avatar, P0_lv, P0_wing_id, P0_wepon_id, P0_clothing_id, P0_light_wepon_id, P0_fashion_cloth_id, P0_fashion_head_id, P0_buy_type, P0_is_ta_buy, P0_recv_first, P0_daily_recv, P0_remain_time, P0_cost, P0_first_goods, P0_daily_goods}) ->
    D_a_t_a = <<P0_state:8, P0_pkey:32/signed, (proto:write_string(P0_nickname))/binary, P0_career:8, P0_sex:8, (proto:write_string(P0_avatar))/binary, P0_lv:16, P0_wing_id:32, P0_wepon_id:32, P0_clothing_id:32, P0_light_wepon_id:32, P0_fashion_cloth_id:32, P0_fashion_head_id:32/signed, P0_buy_type:8, P0_is_ta_buy:8, P0_recv_first:8, P0_daily_recv:8, P0_remain_time:32, P0_cost:32, (length(P0_first_goods)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_first_goods]))/binary, (length(P0_daily_goods)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_daily_goods]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28901:16,0:8, D_a_t_a/binary>>};


%% 香囊购买 
write(28902, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28902:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(28903, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28903:16,0:8, D_a_t_a/binary>>};


%% 请求赠送 
write(28904, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28904:16,0:8, D_a_t_a/binary>>};


%% 赠送通知 
write(28905, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28905:16,0:8, D_a_t_a/binary>>};


%% 获取购买价格 
write(28906, {P0_gold}) ->
    D_a_t_a = <<P0_gold:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28906:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



