%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_390).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"没有攻击次数了"; 
err(3) ->"怪物已死亡"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(39000, _B0) ->
    {ok, {}};

read(39001, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取怪物信息 
write(39000, {P0_mon}) ->
    D_a_t_a = <<(mon_info(P0_mon))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 39000:16,0:8, D_a_t_a/binary>>};


%% 攻击 
write(39001, {P0_res, P0_att_hurt, P0_mul, P0_add_coin, P0_add_exp, P0_mon_state, P0_drop_goods, P0_mon}) ->
    D_a_t_a = <<P0_res:8, P0_att_hurt:32, P0_mul:8, P0_add_coin:32, P0_add_exp:32, P0_mon_state:32, (length(P0_drop_goods)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_drop_goods]))/binary, (mon_info(P0_mon))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 39001:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

mon_info([P0_id, P0_hp, P0_max_hp, P0_att_times, P0_max_att_times, P0_cd_time]) ->
    D_a_t_a = <<P0_id:16, P0_hp:32, P0_max_hp:32, P0_att_times:16, P0_max_att_times:16, P0_cd_time:32>>,
    <<D_a_t_a/binary>>.




