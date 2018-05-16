%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-03-08 17:54:46
%%----------------------------------------------------
-module(pt_310).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"您所在的平台集市系统暂时关闭,请稍后再来"; 
err(3) ->"未找到商品,购买失败"; 
err(4) ->"商品已过期"; 
err(5) ->"不能购买自己上架的商品"; 
err(6) ->"元宝不足以支付购买"; 
err(7) ->"物品不存在"; 
err(8) ->"该物品不能上架"; 
err(9) ->"物品数量不足"; 
err(10) ->"银币不足"; 
err(11) ->"上架时间不符合"; 
err(12) ->"你没有上架改商品"; 
err(13) ->"绑定商品不能上架"; 
err(14) ->"上架商品价格不能为0"; 
err(15) ->"限时道具不能上架"; 
err(16) ->"vip3或者等级>80级可以使用售卖功能，请快速升级吧！"; 
err(17) ->"您今天已用完卖出宝贝次数，请明天继续！"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(31001, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_sub_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_type, P0_sub_type}};

read(31002, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(31003, _B0) ->
    {ok, {}};

read(31004, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_num, _B2} = proto:read_uint32(_B1),
    {P0_price, _B3} = proto:read_uint32(_B2),
    {P0_sell_time, _B4} = proto:read_uint32(_B3),
    {ok, {P0_goods_key, P0_num, P0_price, P0_sell_time}};

read(31005, _B0) ->
    {P0_num, _B1} = proto:read_uint32(_B0),
    {P0_price, _B2} = proto:read_uint32(_B1),
    {P0_sell_time, _B3} = proto:read_uint32(_B2),
    {ok, {P0_num, P0_price, P0_sell_time}};

read(31006, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(31007, _B0) ->
    {P0_goods_name, _B1} = proto:read_string(_B0),
    {ok, {P0_goods_name}};

read(31008, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_goods_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 商品列表 
write(31001, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_goods_id:32, P1_num:32, P1_price:32, P1_cd:32, P1_color:8, P1_sex:8, P1_power:32/signed, (length(P1_fix_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_fix_attr]))/binary, (length(P1_random_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_random_attr]))/binary>> || [P1_key, P1_goods_id, P1_num, P1_price, P1_cd, P1_color, P1_sex, P1_power, P1_fix_attr, P1_random_attr] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 31001:16,0:8, D_a_t_a/binary>>};


%% 购买 
write(31002, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 31002:16,0:8, D_a_t_a/binary>>};


%% 我的上架 
write(31003, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_goods_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_goods_id:32, P1_num:32, P1_price:32, P1_cd:32, P1_color:8, P1_sex:8, P1_power:32/signed, (length(P1_fix_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_fix_attr]))/binary, (length(P1_random_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_random_attr]))/binary>> || [P1_key, P1_goods_id, P1_num, P1_price, P1_cd, P1_color, P1_sex, P1_power, P1_fix_attr, P1_random_attr] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 31003:16,0:8, D_a_t_a/binary>>};


%% 挂售物品 
write(31004, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 31004:16,0:8, D_a_t_a/binary>>};


%% 挂售银两 
write(31005, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 31005:16,0:8, D_a_t_a/binary>>};


%% 下架物品 
write(31006, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 31006:16,0:8, D_a_t_a/binary>>};


%% 商品搜索 
write(31007, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_goods_id:32, P1_num:32, P1_price:32, P1_cd:32, P1_color:8, P1_sex:8, P1_power:32/signed, (length(P1_fix_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_fix_attr]))/binary, (length(P1_random_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_random_attr]))/binary>> || [P1_key, P1_goods_id, P1_num, P1_price, P1_cd, P1_color, P1_sex, P1_power, P1_fix_attr, P1_random_attr] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 31007:16,0:8, D_a_t_a/binary>>};


%% 获取最低价格 
write(31008, {P0_goods_id, P0_price}) ->
    D_a_t_a = <<P0_goods_id:32, P0_price:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 31008:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



