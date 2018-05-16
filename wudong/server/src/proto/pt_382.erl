%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-07-11 10:15:25
%%----------------------------------------------------
-module(pt_382).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"手速不够快，红包被抢完了"; 
err(3) ->"今天抢红包数已达上限"; 
err(4) ->"要30级才能领取红包"; 
err(5) ->"已经领取过该红包了"; 
err(6) ->"你不是该仙盟成员"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(38201, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(38202, _B0) ->
    {ok, {}};

read(38203, _B0) ->
    {ok, {}};

read(38211, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(38212, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(38213, _B0) ->
    {ok, {}};

read(38214, _B0) ->
    {ok, {}};

read(38215, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(38216, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(38217, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 领红包 
write(38201, {P0_res, P0_get_gold}) ->
    D_a_t_a = <<P0_res:8/signed, P0_get_gold:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38201:16,0:8, D_a_t_a/binary>>};


%% 抢红包反馈 
write(38202, {P0_msg}) ->
    D_a_t_a = <<(proto:write_string(P0_msg))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38202:16,0:8, D_a_t_a/binary>>};


%% 红包公告 
write(38203, {P0_key, P0_msg}) ->
    D_a_t_a = <<(proto:write_string(P0_key))/binary, (proto:write_string(P0_msg))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38203:16,0:8, D_a_t_a/binary>>};


%% 领帮派红包 
write(38211, {P0_res, P0_get_gold}) ->
    D_a_t_a = <<P0_res:8/signed, P0_get_gold:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38211:16,0:8, D_a_t_a/binary>>};


%% 查看帮派红包 
write(38212, {P0_pkey, P0_pname, P0_pcareer, P0_psex, P0_avatar, P0_get_gold, P0_my_rank, P0_player_list}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_pname))/binary, P0_pcareer:8, P0_psex:8, (proto:write_string(P0_avatar))/binary, P0_get_gold:32/signed, P0_my_rank:8/signed, (length(P0_player_list)):16, (list_to_binary([<<P1_rank:8, P1_rpkey:32, (proto:write_string(P1_rname))/binary, P1_rcareer:8, P1_rsex:8, (proto:write_string(P1_ravatar))/binary, P1_rget_gold:32/signed>> || [P1_rank, P1_rpkey, P1_rname, P1_rcareer, P1_rsex, P1_ravatar, P1_rget_gold] <- P0_player_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38212:16,0:8, D_a_t_a/binary>>};


%% 帮派红包通知 
write(38213, {P0_redbag_list}) ->
    D_a_t_a = <<(length(P0_redbag_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, (proto:write_string(P1_gkey))/binary, (proto:write_string(P1_name))/binary, (proto:write_string(P1_msg))/binary, P1_type:8/signed>> || [P1_key, P1_gkey, P1_name, P1_msg, P1_type] <- P0_redbag_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38213:16,0:8, D_a_t_a/binary>>};


%% 红包抢完反馈 
write(38214, {P0_key, P0_use_time}) ->
    D_a_t_a = <<(proto:write_string(P0_key))/binary, P0_use_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38214:16,0:8, D_a_t_a/binary>>};


%% 领结婚红包 
write(38215, {P0_res, P0_get_gold}) ->
    D_a_t_a = <<P0_res:8/signed, P0_get_gold:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38215:16,0:8, D_a_t_a/binary>>};


%% 查看结婚红包 
write(38216, {P0_pkey, P0_pname, P0_pcareer, P0_psex, P0_avatar, P0_couple_pkey, P0_couple_pname, P0_couple_pcareer, P0_couple_psex, P0_couple_avatar, P0_get_gold, P0_my_rank, P0_player_list}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_pname))/binary, P0_pcareer:8, P0_psex:8, (proto:write_string(P0_avatar))/binary, P0_couple_pkey:32, (proto:write_string(P0_couple_pname))/binary, P0_couple_pcareer:8, P0_couple_psex:8, (proto:write_string(P0_couple_avatar))/binary, P0_get_gold:32/signed, P0_my_rank:8/signed, (length(P0_player_list)):16, (list_to_binary([<<P1_rank:8, P1_rpkey:32, (proto:write_string(P1_rname))/binary, P1_rcareer:8, P1_rsex:8, (proto:write_string(P1_ravatar))/binary, P1_rget_gold:32/signed>> || [P1_rank, P1_rpkey, P1_rname, P1_rcareer, P1_rsex, P1_ravatar, P1_rget_gold] <- P0_player_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38216:16,0:8, D_a_t_a/binary>>};


%% 结婚红包通知 
write(38217, {P0_key, P0_pkey, P0_pname, P0_pcareer, P0_psex, P0_avatar, P0_couple_pkey, P0_couple_pname, P0_couple_pcareer, P0_couple_psex, P0_couple_avatar}) ->
    D_a_t_a = <<(proto:write_string(P0_key))/binary, P0_pkey:32, (proto:write_string(P0_pname))/binary, P0_pcareer:8, P0_psex:8, (proto:write_string(P0_avatar))/binary, P0_couple_pkey:32, (proto:write_string(P0_couple_pname))/binary, P0_couple_pcareer:8, P0_couple_psex:8, (proto:write_string(P0_couple_avatar))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 38217:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



