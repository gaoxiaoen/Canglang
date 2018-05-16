%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-08-09 14:41:02
%%----------------------------------------------------
-module(pt_641).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"当前位置没有激活"; 
err(3) ->"该位置没有仙魂"; 
err(4) ->"非仙魂"; 
err(5) ->"该类型仙魂已经配带"; 
err(6) ->"物品不存在"; 
err(7) ->"满级了"; 
err(8) ->"升级消耗仙魂经验不足"; 
err(9) ->"仙魂碎片不足"; 
err(10) ->"银币不足"; 
err(11) ->"元宝不足"; 
err(12) ->"当前层数更高"; 
err(13) ->"请先领取仙魂再召唤"; 
err(14) ->"没有该仙魂"; 
err(15) ->"仙魂背包已满"; 
err(16) ->"同类仙魂只可佩戴一个"; 
err(17) ->"vip等级不足"; 
err(18) ->"今日召唤已到达上限（10/10）"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(64100, _B0) ->
    {ok, {}};

read(64101, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_pos, _B2} = proto:read_uint8(_B1),
    {ok, {P0_goods_key, P0_pos}};

read(64102, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(64103, _B0) ->
    {P0_list, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_goods_key, _B2} = proto:read_key(_B1),
        {P1_goods_key, _B2}
    end),
    {ok, {P0_list}};

read(64104, _B0) ->
    {P0_goods_type, _B1} = proto:read_uint32(_B0),
    {ok, {P0_goods_type}};

read(64105, _B0) ->
    {P0_pos, _B1} = proto:read_uint8(_B0),
    {ok, {P0_pos}};

read(64106, _B0) ->
    {ok, {}};

read(64107, _B0) ->
    {P0_color, _B1} = proto:read_uint8(_B0),
    {ok, {P0_color}};

read(64108, _B0) ->
    {ok, {}};

read(64109, _B0) ->
    {ok, {}};

read(64110, _B0) ->
    {P0_color, _B1} = proto:read_uint8(_B0),
    {ok, {P0_color}};

read(64111, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_goods_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 玩家系统信息 
write(64100, {P0_exp, P0_chips, P0_act_pos, P0_type_id, P0_figure_id, P0_star, P0_stage, P0_name, P0_cbp, P0_attrlist}) ->
    D_a_t_a = <<P0_exp:32, P0_chips:32, P0_act_pos:8, P0_type_id:32/signed, P0_figure_id:32/signed, P0_star:8/signed, P0_stage:8/signed, (proto:write_string(P0_name))/binary, P0_cbp:32/signed, (length(P0_attrlist)):16, (list_to_binary([<<P1_type:8, P1_val:32>> || [P1_type, P1_val] <- P0_attrlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64100:16,0:8, D_a_t_a/binary>>};


%% 镶嵌仙魂 
write(64101, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64101:16,0:8, D_a_t_a/binary>>};


%% 升级仙魂 
write(64102, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64102:16,0:8, D_a_t_a/binary>>};


%% 分解仙魂 
write(64103, {P0_error_code, P0_exp}) ->
    D_a_t_a = <<P0_error_code:8, P0_exp:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64103:16,0:8, D_a_t_a/binary>>};


%% 兑换仙魂 
write(64104, {P0_error_code, P0_goods_type}) ->
    D_a_t_a = <<P0_error_code:8, P0_goods_type:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64104:16,0:8, D_a_t_a/binary>>};


%% 卸下仙魂 
write(64105, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64105:16,0:8, D_a_t_a/binary>>};


%% 获取猎魂信息 
write(64106, {P0_floor, P0_max_floor, P0_exp, P0_chips, P0_cost, P0_goods_list}) ->
    D_a_t_a = <<P0_floor:16, P0_max_floor:16, P0_exp:32, P0_chips:32, P0_cost:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed>> || P1_goods_id <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64106:16,0:8, D_a_t_a/binary>>};


%% 猎取仙魂 
write(64107, {P0_error_code, P0_goods_id, P0_is_resolved}) ->
    D_a_t_a = <<P0_error_code:8, P0_goods_id:32/signed, P0_is_resolved:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64107:16,0:8, D_a_t_a/binary>>};


%% 付费开启 
write(64108, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64108:16,0:8, D_a_t_a/binary>>};


%% 一键获取 
write(64109, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64109:16,0:8, D_a_t_a/binary>>};


%% 一键猎魂 
write(64110, {P0_error_code, P0_befor_goods_list, P0_goods_list, P0_get_goods_list}) ->
    D_a_t_a = <<P0_error_code:8, (length(P0_befor_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed>> || P1_goods_id <- P0_befor_goods_list]))/binary, (length(P0_goods_list)):16, (list_to_binary([<<P1_later_goods_id:32/signed>> || P1_later_goods_id <- P0_goods_list]))/binary, (length(P0_get_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed>> || P1_goods_id <- P0_get_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64110:16,0:8, D_a_t_a/binary>>};


%% 获取仙魂 
write(64111, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64111:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



