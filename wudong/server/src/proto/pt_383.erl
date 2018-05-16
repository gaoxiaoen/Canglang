%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_383).
-export([read/2, write/2]).

-include("common.hrl").
-include("month_card.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"不能领取"; 
err(3) ->"没有可领取礼包"; 
err(4) ->"还没购买终身卡"; 
err(5) ->"已经领取过了"; 
err(6) ->"会员等级不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(38300, _B0) ->
    {ok, {}};

read(38301, _B0) ->
    {ok, {}};

read(38310, _B0) ->
    {ok, {}};

read(38311, _B0) ->
    {ok, {}};

read(38320, _B0) ->
    {ok, {}};

read(38321, _B0) ->
    {P0_buy_num, _B1} = proto:read_uint32(_B0),
    {ok, {P0_buy_num}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取月卡信息 
write(38300, {P0_price, P0_get_gold, P0_daily_get_gold, P0_daily_gift_id, P0_state, P0_can_get_day, P0_leave_day, P0_cur_day}) ->
    D_a_t_a = <<P0_price:32, P0_get_gold:32, P0_daily_get_gold:32, P0_daily_gift_id:32, P0_state:8, P0_can_get_day:8, P0_leave_day:8, P0_cur_day:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38300:16,0:8, D_a_t_a/binary>>};


%% 领取月卡奖励 
write(38301, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38301:16,0:8, D_a_t_a/binary>>};


%% 获取终身卡信息 
write(38310, {P0_price, P0_get_gold, P0_daily_get_gold, P0_daily_gift_id, P0_state, P0_can_get_day, P0_cur_get_day}) ->
    D_a_t_a = <<P0_price:32, P0_get_gold:32, P0_daily_get_gold:32, P0_daily_gift_id:32, P0_state:8, P0_can_get_day:8, P0_cur_get_day:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38310:16,0:8, D_a_t_a/binary>>};


%% 领取终身卡奖励 
write(38311, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38311:16,0:8, D_a_t_a/binary>>};


%% 获取全民福利信息 
write(38320, {P0_leave_time, P0_sum_num, P0_gift_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_sum_num:32, (length(P0_gift_list)):16, (list_to_binary([<<P1_buy_num:32, P1_gift_id:32, P1_state:8, P1_need_vip:8>> || [P1_buy_num, P1_gift_id, P1_state, P1_need_vip] <- P0_gift_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38320:16,0:8, D_a_t_a/binary>>};


%% 领取全民福利奖励 
write(38321, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38321:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



