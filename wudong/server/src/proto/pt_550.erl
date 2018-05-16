%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-04-01 16:38:15
%%----------------------------------------------------
-module(pt_550).
-export([read/2, write/2]).

-include("common.hrl").
-include("cross_battlefield.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(3) ->"服务器繁忙,稍后重试"; 
err(4) ->"巅峰争霸赛未开启"; 
err(5) ->"等级不足50,不能进入"; 
err(6) ->"野外场景才能进入"; 
err(7) ->"护送中,不能进入"; 
err(8) ->"不在战场中"; 
err(9) ->"您正处于匹配队列中无法进入"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(55001, _B0) ->
    {ok, {}};

read(55002, _B0) ->
    {ok, {}};

read(55003, _B0) ->
    {ok, {}};

read(55004, _B0) ->
    {ok, {}};

read(55005, _B0) ->
    {ok, {}};

read(55006, _B0) ->
    {ok, {}};

read(55007, _B0) ->
    {P0_page, _B1} = proto:read_int8(_B0),
    {ok, {P0_page}};

read(55008, _B0) ->
    {ok, {}};

read(55009, _B0) ->
    {ok, {}};

read(55010, _B0) ->
    {ok, {}};

read(55011, _B0) ->
    {ok, {}};

read(55012, _B0) ->
    {ok, {}};

read(55013, _B0) ->
    {P0_mkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_mkey}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 查询活动状态 
write(55001, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55001:16,0:8, D_a_t_a/binary>>};


%% 请求加入 
write(55002, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55002:16,0:8, D_a_t_a/binary>>};


%% 退出 
write(55003, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55003:16,0:8, D_a_t_a/binary>>};


%% 个人数据统计 
write(55004, {P0_layer, P0_score, P0_kill, P0_time, P0_sn, P0_nickname, P0_box_time, P0_box_nickname, P0_buff_id, P0_acc_die, P0_die_lim}) ->
    D_a_t_a = <<P0_layer:8/signed, P0_score:32/signed, P0_kill:32/signed, P0_time:16/signed, P0_sn:32/signed, (proto:write_string(P0_nickname))/binary, P0_box_time:16/signed, (proto:write_string(P0_box_nickname))/binary, P0_buff_id:32/signed, P0_acc_die:8/signed, P0_die_lim:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55004:16,0:8, D_a_t_a/binary>>};


%% 通知切层 
write(55005, {P0_type, P0_layer}) ->
    D_a_t_a = <<P0_type:8/signed, P0_layer:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55005:16,0:8, D_a_t_a/binary>>};


%% 结算 
write(55006, {P0_layer, P0_score, P0_rank}) ->
    D_a_t_a = <<P0_layer:8/signed, P0_score:32/signed, P0_rank:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55006:16,0:8, D_a_t_a/binary>>};


%% 排行榜 
write(55007, {P0_page, P0_max_page, P0_my_score, P0_my_rank, P0_my_layer, P0_my_kill, P0_my_combo_kill, P0_rank_list}) ->
    D_a_t_a = <<P0_page:8/signed, P0_max_page:8/signed, P0_my_score:32/signed, P0_my_rank:32/signed, P0_my_layer:8/signed, P0_my_kill:32/signed, P0_my_combo_kill:32/signed, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:32/signed, P1_pf:32/signed, P1_sn:16/signed, (proto:write_string(P1_nickname))/binary, P1_score:32/signed, P1_layer:8/signed, P1_kill:32/signed, P1_combo_kill:32/signed>> || [P1_rank, P1_pf, P1_sn, P1_nickname, P1_score, P1_layer, P1_kill, P1_combo_kill] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55007:16,0:8, D_a_t_a/binary>>};


%% 目标达成 
write(55008, {P0_score, P0_goods_list}) ->
    D_a_t_a = <<P0_score:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55008:16,0:8, D_a_t_a/binary>>};


%% 首次升入层数达成 
write(55009, {P0_layer, P0_goods_list}) ->
    D_a_t_a = <<P0_layer:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55009:16,0:8, D_a_t_a/binary>>};


%% 顶层秘宝奖励 
write(55010, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55010:16,0:8, D_a_t_a/binary>>};


%% 首位登顶达成奖励 
write(55011, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55011:16,0:8, D_a_t_a/binary>>};


%% 连杀信息 
write(55012, {P0_combo, P0_time}) ->
    D_a_t_a = <<P0_combo:16/signed, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55012:16,0:8, D_a_t_a/binary>>};


%% buff碰撞 
write(55013, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 55013:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



