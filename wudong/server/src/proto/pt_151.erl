%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_151).
-export([read/2, write/2]).

-include("common.hrl").
-include("treasure.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"藏宝图配置不存在"; 
err(3) ->"藏宝图信息不符合，不能传送"; 
err(4) ->"会员等级不足，不能传送"; 
err(5) ->"普通野外场景才能传送"; 
err(6) ->"藏宝图信息不符合，不能挖宝"; 
err(7) ->"场景不符合，不能挖宝"; 
err(8) ->"位置不符合，不能挖宝"; 
err(9) ->"没有藏宝图，不能挖宝"; 
err(10) ->"当前会员等级每日击杀精英怪次数已达上限"; 
err(11) ->"当前会员等级每日挖宝次数已达上限"; 
err(12) ->"击杀自己的镜像只有银两收益"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(15101, _B0) ->
    {P0_map_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_map_id}};

read(15102, _B0) ->
    {P0_map_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_map_id}};

read(15103, _B0) ->
    {P0_map_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_map_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取藏宝图信息 
write(15101, {P0_code, P0_map_id, P0_scene, P0_x, P0_y}) ->
    D_a_t_a = <<P0_code:8/signed, P0_map_id:32/signed, P0_scene:32/signed, P0_x:8/signed, P0_y:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15101:16,0:8, D_a_t_a/binary>>};


%% 藏宝图传送 
write(15102, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15102:16,0:8, D_a_t_a/binary>>};


%% 挖宝 
write(15103, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15103:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



