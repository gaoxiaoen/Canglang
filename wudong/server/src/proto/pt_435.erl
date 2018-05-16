%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-12-18 17:26:55
%%----------------------------------------------------
-module(pt_435).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"当前位置没有激活"; 
err(3) ->"白色符文不可配带"; 
err(4) ->"非符文"; 
err(5) ->"该类型符文已经配带"; 
err(6) ->"物品不存在"; 
err(7) ->"满级了"; 
err(8) ->"升级消耗符文经验，不足"; 
err(9) ->"符文碎片不足"; 
err(10) ->"白色符文不能升级"; 
err(11) ->"当前符文未解锁"; 
err(12) ->"同类型低品质符文不可替换"; 
err(13) ->"材料不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(43500, _B0) ->
    {ok, {}};

read(43501, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_pos, _B2} = proto:read_uint8(_B1),
    {ok, {P0_goods_key, P0_pos}};

read(43502, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(43503, _B0) ->
    {P0_list, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_goods_key, _B2} = proto:read_key(_B1),
        {P1_goods_key, _B2}
    end),
    {ok, {P0_list}};

read(43504, _B0) ->
    {P0_goods_type, _B1} = proto:read_uint32(_B0),
    {ok, {P0_goods_type}};

read(43505, _B0) ->
    {P0_goods_key1, _B1} = proto:read_key(_B0),
    {P0_goods_key2, _B2} = proto:read_key(_B1),
    {ok, {P0_goods_key1, P0_goods_key2}};

read(43506, _B0) ->
    {ok, {}};

read(43507, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {P0_goods_key_list, _B4} = proto:read_array(_B1, fun(_B2) ->
        {P1_goods_key, _B3} = proto:read_key(_B2),
        {P1_goods_key, _B3}
    end),
    {ok, {P0_goods_id, P0_goods_key_list}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 玩家系统信息 
write(43500, {P0_fuwen_exp, P0_fuwen_chips, P0_act_pos, P0_layer, P0_sub_layer, P0_list}) ->
    D_a_t_a = <<P0_fuwen_exp:32, P0_fuwen_chips:32, P0_act_pos:8, P0_layer:8, P0_sub_layer:8, (length(P0_list)):16, (list_to_binary([<<P1_subtype:32>> || P1_subtype <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43500:16,0:8, D_a_t_a/binary>>};


%% 镶嵌符文 
write(43501, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43501:16,0:8, D_a_t_a/binary>>};


%% 升级符文 
write(43502, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43502:16,0:8, D_a_t_a/binary>>};


%% 分解符文 
write(43503, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43503:16,0:8, D_a_t_a/binary>>};


%% 兑换符文 
write(43504, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43504:16,0:8, D_a_t_a/binary>>};


%% 符文预览 
write(43505, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<(proto:write_string(P1_goods_key1))/binary, P1_cbp:32, P1_lv:8, P1_val:32>> || [P1_goods_key1, P1_cbp, P1_lv, P1_val] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43505:16,0:8, D_a_t_a/binary>>};


%% 符文预览提示 
write(43506, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_pos:8, (proto:write_string(P1_goods_key1))/binary, (proto:write_string(P1_goods_key2))/binary>> || [P1_pos, P1_goods_key1, P1_goods_key2] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43506:16,0:8, D_a_t_a/binary>>};


%% 合成双属性符文 
write(43507, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43507:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



