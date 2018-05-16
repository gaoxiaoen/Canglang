%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-13 11:22:05
%%----------------------------------------------------
-module(pt_154).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"配置不存在"; 
err(3) ->"已满级"; 
err(4) ->"当前经验不足以升级"; 
err(5) ->"形象不存在"; 
err(6) ->"该形象未激活"; 
err(7) ->"奖励已领取"; 
err(8) ->"奖励未达成"; 
err(9) ->"没有次数可找回"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(15401, _B0) ->
    {ok, {}};

read(15402, _B0) ->
    {ok, {}};

read(15403, _B0) ->
    {P0_figure, _B1} = proto:read_int32(_B0),
    {ok, {P0_figure}};

read(15404, _B0) ->
    {ok, {}};

read(15405, _B0) ->
    {ok, {}};

read(15406, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 剑池信息 
write(15401, {P0_lv, P0_exp, P0_figure, P0_exp_daily, P0_goods_daily, P0_cbp, P0_attrlist, P0_type_list}) ->
    D_a_t_a = <<P0_lv:16/signed, P0_exp:32/signed, P0_figure:32/signed, P0_exp_daily:32/signed, P0_goods_daily:8, P0_cbp:32/signed, (length(P0_attrlist)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_attrlist]))/binary, (length(P0_type_list)):16, (list_to_binary([<<P1_type:32/signed, P1_finish_times:8/signed, P1_buy_times:8/signed>> || [P1_type, P1_finish_times, P1_buy_times] <- P0_type_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15401:16,0:8, D_a_t_a/binary>>};


%% 升级 
write(15402, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15402:16,0:8, D_a_t_a/binary>>};


%% 切换形象 
write(15403, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15403:16,0:8, D_a_t_a/binary>>};


%% 领取每日奖励 
write(15404, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15404:16,0:8, D_a_t_a/binary>>};


%% 获取找回列表 
write(15405, {P0_price, P0_type_list}) ->
    D_a_t_a = <<P0_price:32/signed, (length(P0_type_list)):16, (list_to_binary([<<P1_type:32/signed, P1_times:8/signed>> || [P1_type, P1_times] <- P0_type_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15405:16,0:8, D_a_t_a/binary>>};


%% 次数找回 
write(15406, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15406:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



