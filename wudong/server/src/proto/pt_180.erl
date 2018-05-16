%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_180).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"购买次数超出限制"; 
err(3) ->"元宝不足"; 
err(4) ->"银两不足"; 
err(5) ->"黑店值不足"; 
err(6) ->"荣耀值不足"; 
err(7) ->"竞技值不足"; 
err(8) ->"背包空间不足"; 
err(9) ->"会员等级6级以上才能购买"; 
err(10) ->"功勋值不足"; 
err(11) ->"没有加入仙盟,不能购买"; 
err(12) ->"星运背包已满"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(18001, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(18002, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_shop_id, _B2} = proto:read_uint16(_B1),
    {ok, {P0_type, P0_shop_id}};

read(18003, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取商店的物品 
write(18001, {P0_type, P0_left_time, P0_r_type, P0_r_value, P0_goods_list}) ->
    D_a_t_a = <<P0_type:8, P0_left_time:32, P0_r_type:8, P0_r_value:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_shop_id:16, P1_goods_id:32, P1_num:32, (length(P1_wash_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_wash_attr]))/binary, (length(P1_stone_info)):16, (list_to_binary([<<P2_hole_type:8, P2_value:32>> || [P2_hole_type, P2_value] <- P1_stone_info]))/binary, P1_type:8, P1_value:32>> || [P1_shop_id, P1_goods_id, P1_num, P1_wash_attr, P1_stone_info, P1_type, P1_value] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 18001:16,0:8, D_a_t_a/binary>>};


%% 购买商店的物品 
write(18002, {P0_error_code, P0_shop_type, P0_shop_id, P0_left_num}) ->
    D_a_t_a = <<P0_error_code:8, P0_shop_type:8, P0_shop_id:16, P0_left_num:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 18002:16,0:8, D_a_t_a/binary>>};


%% 刷新商店 
write(18003, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 18003:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



