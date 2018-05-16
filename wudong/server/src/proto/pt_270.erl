%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_270).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"元宝不足"; 
err(3) ->"背包空间不足"; 
err(4) ->"已经领取过了，不能再领取了"; 
err(5) ->"只能投资一次哦"; 
err(6) ->"配置错误"; 
err(7) ->"等级不够"; 
err(8) ->"投资总人数不够"; 
err(9) ->"还没有购买该投资，不能领取"; 
err(10) ->"会员等级不足，不能领取"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(27000, _B0) ->
    {ok, {}};

read(27001, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(27002, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_award_id, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_award_id}};

read(27003, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 投资计划信息 
write(27000, {P0_level_time, P0_is_buy_luxury, P0_is_buy_extreme, P0_invest_num, P0_award_list, P0_luxury_award, P0_extreme_award, P0_invest_award}) ->
    D_a_t_a = <<P0_level_time:32, P0_is_buy_luxury:8, P0_is_buy_extreme:8, P0_invest_num:32, (length(P0_award_list)):16, (list_to_binary([<<P1_type:32, P1_is_get:8>> || [P1_type, P1_is_get] <- P0_award_list]))/binary, (length(P0_luxury_award)):16, (list_to_binary([<<P1_award_id:32, P1_is_get:8>> || [P1_award_id, P1_is_get] <- P0_luxury_award]))/binary, (length(P0_extreme_award)):16, (list_to_binary([<<P1_award_id:32, P1_is_get:8>> || [P1_award_id, P1_is_get] <- P0_extreme_award]))/binary, (length(P0_invest_award)):16, (list_to_binary([<<P1_award_id:32, P1_is_get:8>> || [P1_award_id, P1_is_get] <- P0_invest_award]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 27000:16,0:8, D_a_t_a/binary>>};


%% 购买投资 
write(27001, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 27001:16,0:8, D_a_t_a/binary>>};


%% 领取投资奖励 
write(27002, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 27002:16,0:8, D_a_t_a/binary>>};


%% 购买投资总人数更新 
write(27003, {P0_player_num}) ->
    D_a_t_a = <<P0_player_num:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 27003:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



