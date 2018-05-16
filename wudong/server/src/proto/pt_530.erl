%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-08-16 19:34:01
%%----------------------------------------------------
-module(pt_530).
-export([read/2, write/2]).

-include("common.hrl").
-include("lv_gift.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已经领取了"; 
err(3) ->"还不能领取"; 
err(10) ->"等级不足40级,不能领取"; 
err(11) ->"礼包已经领取"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(53000, _B0) ->
    {ok, {}};

read(53001, _B0) ->
    {P0_lv, _B1} = proto:read_uint16(_B0),
    {ok, {P0_lv}};

read(53002, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(53003, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(53004, _B0) ->
    {ok, {}};

read(53005, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取等级礼包信息 
write(53000, {P0_info_list}) ->
    D_a_t_a = <<(length(P0_info_list)):16, (list_to_binary([<<P1_lv:16, P1_state:8, P1_goods_id:32>> || [P1_lv, P1_state, P1_goods_id] <- P0_info_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 53000:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(53001, {P0_res, P0_days, P0_state}) ->
    D_a_t_a = <<P0_res:8, P0_days:8, P0_state:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 53001:16,0:8, D_a_t_a/binary>>};


%% 检查资源礼包是否已经领取 
write(53002, {P0_ret, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 53002:16,0:8, D_a_t_a/binary>>};


%% 领取资源包奖励 
write(53003, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 53003:16,0:8, D_a_t_a/binary>>};


%% 领取点赞奖励 
write(53004, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 53004:16,0:8, D_a_t_a/binary>>};


%% 下载完成 
write(53005, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 53005:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



