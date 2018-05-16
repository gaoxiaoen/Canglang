%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-12-07 12:52:43
%%----------------------------------------------------
-module(pt_441).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已激活"; 
err(3) ->"激活条件不足"; 
err(4) ->"当前暂无可激活，请提升强化等级"; 
err(5) ->"当前套装已满级"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(44101, _B0) ->
    {ok, {}};

read(44102, _B0) ->
    {P0_suit_id2, _B1} = proto:read_uint32(_B0),
    {ok, {P0_suit_id2}};

read(44103, _B0) ->
    {ok, {}};

read(44104, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_goods_id}};

read(44105, _B0) ->
    {P0_suit_id2, _B1} = proto:read_uint32(_B0),
    {ok, {P0_suit_id2}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 时装套装 
write(44101, {P0_cbp, P0_attribute_list, P0_act_suit_ids, P0_un_act_suit_ids}) ->
    D_a_t_a = <<P0_cbp:32, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary, (length(P0_act_suit_ids)):16, (list_to_binary([<<P1_suit_id:32, P1_lv:32, P1_act_lv:32, P1_is_upgrade:8, (length(P1_suit_id_list)):16, (list_to_binary([<<P2_id_type:8, P2_icon_id:32, P2_is_hd:8, P2_fun_id:32, P2_fun_id_2:32, P2_lv0:32>> || [P2_id_type, P2_icon_id, P2_is_hd, P2_fun_id, P2_fun_id_2, P2_lv0] <- P1_suit_id_list]))/binary>> || [P1_suit_id, P1_lv, P1_act_lv, P1_is_upgrade, P1_suit_id_list] <- P0_act_suit_ids]))/binary, (length(P0_un_act_suit_ids)):16, (list_to_binary([<<P1_suit_id2:32, P1_lv:32, P1_act_lv:32, P1_is_active:8, (length(P1_suit_id_list)):16, (list_to_binary([<<P2_id_type:8, P2_icon_id:32, P2_is_has:32, P2_is_hd:8, P2_fun_id:32, P2_fun_id_2:32, P2_lv0:32>> || [P2_id_type, P2_icon_id, P2_is_has, P2_is_hd, P2_fun_id, P2_fun_id_2, P2_lv0] <- P1_suit_id_list]))/binary>> || [P1_suit_id2, P1_lv, P1_act_lv, P1_is_active, P1_suit_id_list] <- P0_un_act_suit_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44101:16,0:8, D_a_t_a/binary>>};


%% 激活时装套装ID 
write(44102, {P0_err_code}) ->
    D_a_t_a = <<P0_err_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44102:16,0:8, D_a_t_a/binary>>};


%% 可激活套装图标推送 
write(44103, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44103:16,0:8, D_a_t_a/binary>>};


%% 请求套装激活信息 
write(44104, {P0_goods_fashion_suit}) ->
    D_a_t_a = <<(length(P0_goods_fashion_suit)):16, (list_to_binary([<<P1_suit_id2:32, P1_lv:32, P1_act_lv:32, P1_is_active:8, (length(P1_suit_id_list)):16, (list_to_binary([<<P2_id_type:8, P2_icon_id:32, P2_is_has:32, P2_lv0:32>> || [P2_id_type, P2_icon_id, P2_is_has, P2_lv0] <- P1_suit_id_list]))/binary>> || [P1_suit_id2, P1_lv, P1_act_lv, P1_is_active, P1_suit_id_list] <- P0_goods_fashion_suit]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44104:16,0:8, D_a_t_a/binary>>};


%% 激活时装套装等级加成 
write(44105, {P0_err_code}) ->
    D_a_t_a = <<P0_err_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44105:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



