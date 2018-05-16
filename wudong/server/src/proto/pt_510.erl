%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:19
%%----------------------------------------------------
-module(pt_510).
-export([read/2, write/2]).

-include("common.hrl").
-include("sign_in.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已经签到过"; 
err(3) ->"还不能领取"; 
err(4) ->"充值任意金额则可再领取一次奖励"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(51000, _B0) ->
    {ok, {}};

read(51001, _B0) ->
    {ok, {}};

read(51002, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取签到信息 
write(51000, {P0_today, P0_acc_day, P0_info_list, P0_acc_list}) ->
    D_a_t_a = <<P0_today:8, P0_acc_day:8, (length(P0_info_list)):16, (list_to_binary([<<P1_days:8, P1_state:8, P1_goods_id:32, P1_goods_num:32, P1_icon:32>> || [P1_days, P1_state, P1_goods_id, P1_goods_num, P1_icon] <- P0_info_list]))/binary, (length(P0_acc_list)):16, (list_to_binary([<<P1_id:32, P1_days:8, P1_state:8, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_id, P1_days, P1_state, P1_goods_list] <- P0_acc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 51000:16,0:8, D_a_t_a/binary>>};


%% 签到 
write(51001, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 51001:16,0:8, D_a_t_a/binary>>};


%% 领取累登奖励 
write(51002, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 51002:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



