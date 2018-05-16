%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_153).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"夺宝未开启"; 
err(3) ->"您所在是服务器为开启夺宝"; 
err(4) ->"元宝不足以支付"; 
err(5) ->"物品不存在"; 
err(6) ->"该物品已经过了抢购时间"; 
err(7) ->"购买数量超过可购入上限"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(15301, _B0) ->
    {ok, {}};

read(15302, _B0) ->
    {ok, {}};

read(15303, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_page, _B2} = proto:read_int16(_B1),
    {ok, {P0_type, P0_page}};

read(15304, _B0) ->
    {P0_page, _B1} = proto:read_int16(_B0),
    {ok, {P0_page}};

read(15305, _B0) ->
    {P0_id, _B1} = proto:read_int32(_B0),
    {P0_num, _B2} = proto:read_int32(_B1),
    {ok, {P0_id, P0_num}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 活动状态 
write(15301, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15301:16,0:8, D_a_t_a/binary>>};


%% 夺宝物品列表 
write(15302, {P0_code, P0_time, P0_list}) ->
    D_a_t_a = <<P0_code:8, P0_time:32, (length(P0_list)):16, (list_to_binary([<<P1_id:32/signed, P1_type:8/signed, P1_date:16/signed, P1_goods_id:32/signed, P1_num:32/signed, P1_had_buy:32/signed, P1_buy_lim:32/signed, P1_my_buy:32/signed, P1_state:8/signed, P1_g_time:32/signed>> || [P1_id, P1_type, P1_date, P1_goods_id, P1_num, P1_had_buy, P1_buy_lim, P1_my_buy, P1_state, P1_g_time] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15302:16,0:8, D_a_t_a/binary>>};


%% 查看已开奖记录 
write(15303, {P0_page, P0_max_page, P0_list}) ->
    D_a_t_a = <<P0_page:16/signed, P0_max_page:16/signed, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_date:16/signed, P1_sn:32/signed, (proto:write_string(P1_nickname))/binary, P1_buy_times:32/signed, P1_lucky_id:32/signed>> || [P1_goods_id, P1_num, P1_date, P1_sn, P1_nickname, P1_buy_times, P1_lucky_id] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15303:16,0:8, D_a_t_a/binary>>};


%% 查看我的购买记录 
write(15304, {P0_page, P0_max_page, P0_list}) ->
    D_a_t_a = <<P0_page:16/signed, P0_max_page:16/signed, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_date:16/signed, P1_time:32/signed, P1_buy_times:32/signed, P1_state:8/signed, P1_is_lucky:8/signed, P1_lucky_id:32/signed, (length(P1_id_list)):16, (list_to_binary([<<P2_id:32/signed>> || P2_id <- P1_id_list]))/binary>> || [P1_goods_id, P1_num, P1_date, P1_time, P1_buy_times, P1_state, P1_is_lucky, P1_lucky_id, P1_id_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15304:16,0:8, D_a_t_a/binary>>};


%% 买入 
write(15305, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15305:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



