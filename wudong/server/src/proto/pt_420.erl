%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:19
%%----------------------------------------------------
-module(pt_420).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"经脉不存在"; 
err(3) ->"经脉已激活"; 
err(4) ->"前置经脉修炼等级不足"; 
err(5) ->"经脉未激活"; 
err(6) ->"经脉修炼满级"; 
err(7) ->"经骨等级不足 "; 
err(8) ->"灵气不足"; 
err(9) ->"经骨提升物品不足,请前往经脉副本获取"; 
err(10) ->"修炼冷却中"; 
err(11) ->"没有经骨可提升"; 
err(12) ->"经骨已满级"; 
err(13) ->"银两不足"; 
err(14) ->"元宝不足"; 
err(15) ->"玩家等级不足"; 
err(16) ->"无法获取自动购买价格"; 
err(17) ->"没有修炼冷却可清除"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(42001, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(42002, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(42003, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(42004, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {P0_is_auto, _B2} = proto:read_uint8(_B1),
    {ok, {P0_id, P0_is_auto}};

read(42005, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取玩家经脉信息(UI上面协议没有包含的可以读配置表) 
write(42001, {P0_xinghun, P0_meridian_list}) ->
    D_a_t_a = zlib:compress(<<P0_xinghun:32/signed, (length(P0_meridian_list)):16, (list_to_binary([<<P1_id:8, P1_state:8, P1_lv:16/signed, P1_break_lv:16/signed, P1_in_cd:8/signed, P1_cd:16/signed, P1_cd_price:32/signed, (length(P1_subtype_list)):16, (list_to_binary([<<P2_subtype:8, P2_subtype_lv:8/signed, P2_subtype_state:8/signed>> || [P2_subtype, P2_subtype_lv, P2_subtype_state] <- P1_subtype_list]))/binary, (pack_attr(P1_act_attr_list))/binary>> || [P1_id, P1_state, P1_lv, P1_break_lv, P1_in_cd, P1_cd, P1_cd_price, P1_subtype_list, P1_act_attr_list] <- P0_meridian_list]))/binary>>),
    {ok, <<(byte_size(D_a_t_a) + 7):32, 42001:16,1:8, D_a_t_a/binary>>};


%% 激活 
write(42002, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 42002:16,0:8, D_a_t_a/binary>>};


%% 升级 
write(42003, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 42003:16,0:8, D_a_t_a/binary>>};


%% 经骨提升 
write(42004, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 42004:16,0:8, D_a_t_a/binary>>};


%% 清除星辰升级cd 
write(42005, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 42005:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_attr(P0_attrlist) ->
    D_a_t_a = <<(length(P0_attrlist)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_attrlist]))/binary>>,
    <<D_a_t_a/binary>>.




