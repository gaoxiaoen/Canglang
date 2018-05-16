%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-01-20 13:17:50
%%----------------------------------------------------
-module(pt_470).
-export([read/2, write/2]).

-include("common.hrl").
-include("vip.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"会员等级不足"; 
err(3) ->"元宝不足"; 
err(4) ->"已经领取"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(47001, _B0) ->
    {ok, {}};

read(47002, _B0) ->
    {P0_vip_lv, _B1} = proto:read_uint8(_B0),
    {ok, {P0_vip_lv}};

read(47003, _B0) ->
    {ok, {}};

read(47005, _B0) ->
    {ok, {}};

read(47006, _B0) ->
    {ok, {}};

read(47007, _B0) ->
    {ok, {}};

read(47008, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 玩家vip信息 
write(47001, {P0_vip_lv, P0_exp, P0_buy_list, P0_week_state, P0_feelvip_lv, P0_left_time}) ->
    D_a_t_a = <<P0_vip_lv:8, P0_exp:32, (length(P0_buy_list)):16, (list_to_binary([<<P1_vip_lv:8, P1_state:8>> || [P1_vip_lv, P1_state] <- P0_buy_list]))/binary, P0_week_state:8, P0_feelvip_lv:8, P0_left_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 47001:16,0:8, D_a_t_a/binary>>};


%% 领取vip奖励 
write(47002, {P0_res, P0_vip_lv}) ->
    D_a_t_a = <<P0_res:8, P0_vip_lv:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 47002:16,0:8, D_a_t_a/binary>>};


%% 体验vip状态变化通知 
write(47003, {P0_state, P0_vip_lv}) ->
    D_a_t_a = <<P0_state:8, P0_vip_lv:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 47003:16,0:8, D_a_t_a/binary>>};


%% 领取每周领取礼包 
write(47005, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 47005:16,0:8, D_a_t_a/binary>>};


%% 一元vip状态 
write(47006, {P0_state, P0_leave_time, P0_cost}) ->
    D_a_t_a = <<P0_state:8/signed, P0_leave_time:32/signed, P0_cost:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 47006:16,0:8, D_a_t_a/binary>>};


%% 一元vip续费 
write(47007, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 47007:16,0:8, D_a_t_a/binary>>};


%% 一元vip开启 
write(47008, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 47008:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



