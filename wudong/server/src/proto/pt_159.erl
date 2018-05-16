%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-06-12 14:14:43
%%----------------------------------------------------
-module(pt_159).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"种子不存在"; 
err(3) ->"种子已过期"; 
err(4) ->"植物不存在"; 
err(5) ->"当前不是缺水期"; 
err(6) ->"您今日浇水次数已达上限"; 
err(7) ->"果实未成熟"; 
err(8) ->"该果实正在被别的玩家采集"; 
err(9) ->"您本次活动可采集次数已满"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(15901, _B0) ->
    {ok, {}};

read(15902, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_x, _B2} = proto:read_int16(_B1),
    {P0_y, _B3} = proto:read_int16(_B2),
    {ok, {P0_goods_key, P0_x, P0_y}};

read(15903, _B0) ->
    {ok, {}};

read(15904, _B0) ->
    {ok, {}};

read(15905, _B0) ->
    {P0_key, _B1} = proto:read_int32(_B0),
    {ok, {P0_key}};

read(15906, _B0) ->
    {P0_key, _B1} = proto:read_int32(_B0),
    {ok, {P0_key}};

read(15907, _B0) ->
    {P0_key, _B1} = proto:read_int32(_B0),
    {P0_type, _B2} = proto:read_int8(_B1),
    {ok, {P0_key, P0_type}};

read(15908, _B0) ->
    {ok, {}};

read(15907, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 植物列表 
write(15901, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_goods_id:32/signed, P1_x:16/signed, P1_y:16/signed, P1_state:8/signed>> || [P1_key, P1_goods_id, P1_x, P1_y, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15901:16,0:8, D_a_t_a/binary>>};


%% 种植 
write(15902, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15902:16,0:8, D_a_t_a/binary>>};


%% 刷新/新增植物 
write(15903, {P0_key, P0_goods_id, P0_x, P0_y, P0_state}) ->
    D_a_t_a = <<(proto:write_string(P0_key))/binary, P0_goods_id:32/signed, P0_x:16/signed, P0_y:16/signed, P0_state:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15903:16,0:8, D_a_t_a/binary>>};


%% 删除植物 
write(15904, {P0_key}) ->
    D_a_t_a = <<P0_key:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15904:16,0:8, D_a_t_a/binary>>};


%% 查询植物信息 
write(15905, {P0_key, P0_goods_id, P0_state, P0_time, P0_water_times, P0_water_times_lim, P0_water_lim, P0_collect_times, P0_collect_times_lim, P0_can_collect, P0_log_list}) ->
    D_a_t_a = <<P0_key:32/signed, P0_goods_id:32/signed, P0_state:8/signed, P0_time:32/signed, P0_water_times:8/signed, P0_water_times_lim:8/signed, P0_water_lim:8/signed, P0_collect_times:8/signed, P0_collect_times_lim:8/signed, P0_can_collect:8/signed, (length(P0_log_list)):16, (list_to_binary([<<(proto:write_string(P1_msg))/binary, P1_time:32/signed>> || [P1_msg, P1_time] <- P0_log_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15905:16,0:8, D_a_t_a/binary>>};


%% 浇水 
write(15906, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15906:16,0:8, D_a_t_a/binary>>};


%% 采集 
write(15907, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15907:16,0:8, D_a_t_a/binary>>};


%% 我的种植信息 
write(15908, {P0_water_times, P0_water_times_lim, P0_collect_times, P0_collect_times_lim, P0_plant_list, P0_log_list}) ->
    D_a_t_a = <<P0_water_times:8/signed, P0_water_times_lim:8/signed, P0_collect_times:8/signed, P0_collect_times_lim:8/signed, (length(P0_plant_list)):16, (list_to_binary([<<P1_key:32/signed, P1_goods_id:32/signed, P1_state:8/signed, P1_time:32/signed, P1_water_times1:8/signed, P1_water_times_lim1:8/signed, P1_collect_times1:8/signed, P1_collect_times_lim1:8/signed>> || [P1_key, P1_goods_id, P1_state, P1_time, P1_water_times1, P1_water_times_lim1, P1_collect_times1, P1_collect_times_lim1] <- P0_plant_list]))/binary, (length(P0_log_list)):16, (list_to_binary([<<(proto:write_string(P1_msg))/binary, P1_time:32/signed>> || [P1_msg, P1_time] <- P0_log_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15908:16,0:8, D_a_t_a/binary>>};


%% 我的种植状态 
write(15907, {P0_state}) ->
    D_a_t_a = <<P0_state:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15907:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



