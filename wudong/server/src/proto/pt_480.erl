%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-09-21 11:50:07
%%----------------------------------------------------
-module(pt_480).
-export([read/2, write/2]).

-include("common.hrl").
-include("rank.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"今日膜拜次数已达上限"; 
err(3) ->"已经膜拜过该玩家了"; 
err(4) ->"不能膜拜自己"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(48001, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_page, _B2} = proto:read_uint8(_B1),
    {ok, {P0_type, P0_page}};

read(48002, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_player_key, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_player_key}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取排行榜 
write(48001, {P0_type, P0_page, P0_myrank, P0_mywp_times, P0_sumline, P0_info_list}) ->
    D_a_t_a = <<P0_type:8, P0_page:8, P0_myrank:8, P0_mywp_times:8, P0_sumline:8, (length(P0_info_list)):16, (list_to_binary([<<P1_rank:8, P1_data:32, P1_data2:32, P1_data3:32, (pack_player(P1_player_info))/binary>> || [P1_rank, P1_data, P1_data2, P1_data3, P1_player_info] <- P0_info_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 48001:16,0:8, D_a_t_a/binary>>};


%% 膜拜 
write(48002, {P0_res, P0_wp_times, P0_mywp_times}) ->
    D_a_t_a = <<P0_res:8, P0_wp_times:32/signed, P0_mywp_times:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 48002:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_player([P0_player_key, P0_sn, P0_pf, P0_name, P0_lv, P0_career, P0_vip, P0_realm, P0_guild_name, P0_guild_key, P0_cbp, P0_dvip, P0_wp_times, P0_is_wp]) ->
    D_a_t_a = <<P0_player_key:32, P0_sn:32, P0_pf:32, (proto:write_string(P0_name))/binary, P0_lv:32, P0_career:8, P0_vip:32, P0_realm:32, (proto:write_string(P0_guild_name))/binary, (proto:write_string(P0_guild_key))/binary, P0_cbp:32/signed, P0_dvip:32/signed, P0_wp_times:32/signed, P0_is_wp:8/signed>>,
    <<D_a_t_a/binary>>.




