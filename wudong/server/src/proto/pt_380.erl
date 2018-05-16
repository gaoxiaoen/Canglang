%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-06-28 17:32:47
%%----------------------------------------------------
-module(pt_380).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"商品不存在"; 
err(3) ->"商品所在的商店类型不正确"; 
err(4) ->"非绑定元宝不足"; 
err(5) ->"元宝不足"; 
err(6) ->"银币不足"; 
err(12) ->"商品不存在"; 
err(13) ->"活动已过期"; 
err(14) ->"已经抢购道具，下次再来哦"; 
err(15) ->"非绑定元宝不足"; 
err(16) ->"抢购道具已售罄，下次提早来抢哦"; 
err(17) ->"消耗不足"; 
err(18) ->"购买数量不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(38000, _B0) ->
    {P0_shop_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_shop_type}};

read(38001, _B0) ->
    {P0_shop_type, _B1} = proto:read_uint8(_B0),
    {P0_goods_id, _B2} = proto:read_uint32(_B1),
    {P0_buy_num, _B3} = proto:read_uint32(_B2),
    {ok, {P0_shop_type, P0_goods_id, P0_buy_num}};

read(38010, _B0) ->
    {ok, {}};

read(38011, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {P0_goods_id, _B2} = proto:read_uint32(_B1),
    {ok, {P0_id, P0_goods_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取普通商店信息 
write(38000, {P0_shop_type, P0_goods_info}) ->
    D_a_t_a = <<P0_shop_type:8, (length(P0_goods_info)):16, (list_to_binary([<<P1_id:32, P1_goods_id:32, P1_goods_num:32/signed, P1_icon_type:32, P1_cost:32, P1_discount:32, P1_base:32, P1_max_num:32>> || [P1_id, P1_goods_id, P1_goods_num, P1_icon_type, P1_cost, P1_discount, P1_base, P1_max_num] <- P0_goods_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38000:16,0:8, D_a_t_a/binary>>};


%% 购买普通商店商品 
write(38001, {P0_id}) ->
    D_a_t_a = <<P0_id:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38001:16,0:8, D_a_t_a/binary>>};


%% 获取抢购商店信息 
write(38010, {P0_leave_time, P0_goods_info}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_goods_info)):16, (list_to_binary([<<P1_id:32, P1_goods_id:32, P1_goods_num:32, P1_global_can_buy_num:32, P1_global_buy_num:32, P1_can_buy_num:32, P1_buy_num:32, P1_cost_gold:32, P1_cost_bgold:32, P1_old_price:32>> || [P1_id, P1_goods_id, P1_goods_num, P1_global_can_buy_num, P1_global_buy_num, P1_can_buy_num, P1_buy_num, P1_cost_gold, P1_cost_bgold, P1_old_price] <- P0_goods_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38010:16,0:8, D_a_t_a/binary>>};


%% 购买抢购商店 
write(38011, {P0_id}) ->
    D_a_t_a = <<P0_id:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38011:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



