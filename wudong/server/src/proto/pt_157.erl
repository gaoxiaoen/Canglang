%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 16:17:30
%%----------------------------------------------------
-module(pt_157).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已满级"; 
err(3) ->"没有装备可熔炼"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(15701, _B0) ->
    {ok, {}};

read(15702, _B0) ->
    {P0_equip_list, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_goods_key, _B2} = proto:read_key(_B1),
        {P1_goods_key, _B2}
    end),
    {ok, {P0_equip_list}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 熔炼信息  
write(15701, {P0_stage, P0_exp, P0_max_exp, P0_cbp, P0_attribute_list}) ->
    D_a_t_a = <<P0_stage:16/signed, P0_exp:16/signed, P0_max_exp:32/signed, P0_cbp:32/signed, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15701:16,0:8, D_a_t_a/binary>>};


%% 熔炼装备 
write(15702, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15702:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



