%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:19
%%----------------------------------------------------
-module(pt_650).
-export([read/2, write/2]).

-include("common.hrl").
-include("lucky_pool.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(65001, _B0) ->
    {ok, {}};

read(65002, _B0) ->
    {ok, {}};

read(65003, _B0) ->
    {P0_times, _B1} = proto:read_int8(_B0),
    {ok, {P0_times}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 查询活动状态 
write(65001, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 65001:16,0:8, D_a_t_a/binary>>};


%% 获取奖池信息 
write(65002, {P0_state, P0_time, P0_coin, P0_log_coin, P0_log_goods, P0_pos_list}) ->
    D_a_t_a = <<P0_state:8, P0_time:16, P0_coin:32/signed, (length(P0_log_coin)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_coin:32/signed>> || [P1_pkey, P1_nickname, P1_career, P1_coin] <- P0_log_coin]))/binary, (length(P0_log_goods)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_goods_id:32/signed, P1_num:32/signed>> || [P1_pkey, P1_nickname, P1_career, P1_goods_id, P1_num] <- P0_log_goods]))/binary, (length(P0_pos_list)):16, (list_to_binary([<<P1_pos:8/signed, P1_type:8/signed, P1_goods_id:32/signed, P1_num:32/signed>> || [P1_pos, P1_type, P1_goods_id, P1_num] <- P0_pos_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 65002:16,0:8, D_a_t_a/binary>>};


%% 抽奖 
write(65003, {P0_code, P0_times, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8, P0_times:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_pos:8/signed, P1_goods_id:32/signed, P1_num:32/signed, P1_is_show:8/signed>> || [P1_pos, P1_goods_id, P1_num, P1_is_show] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 65003:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



