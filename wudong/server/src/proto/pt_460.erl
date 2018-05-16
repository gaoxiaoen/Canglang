%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-11-17 11:11:11
%%----------------------------------------------------
-module(pt_460).
-export([read/2, write/2]).

-include("common.hrl").
-include("vip.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(46000, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 充值信息 
write(46000, {P0_info_list}) ->
    D_a_t_a = zlib:compress(<<(length(P0_info_list)):16, (list_to_binary([<<P1_id:8, P1_type:8, P1_price:32, P1_get_gold:32, P1_free_gold:32, P1_lim_give_times:8/signed, P1_goods_id:32, P1_is_month_card:8, P1_month_card_leave_day:16, P1_commend:8, P1_charge_gift_day:16, P1_charge_gift_bgold:16/signed, P1_percent:16>> || [P1_id, P1_type, P1_price, P1_get_gold, P1_free_gold, P1_lim_give_times, P1_goods_id, P1_is_month_card, P1_month_card_leave_day, P1_commend, P1_charge_gift_day, P1_charge_gift_bgold, P1_percent] <- P0_info_list]))/binary>>),
    {ok, <<(byte_size(D_a_t_a) + 7):32, 46000:16,1:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



