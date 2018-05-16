%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:19
%%----------------------------------------------------
-module(pt_640).
-export([read/2, write/2]).

-include("common.hrl").
-include("battlefield.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"战场已报名"; 
err(3) ->"当前不是战场报名时间"; 
err(201) ->"服务器繁忙,稍后重试"; 
err(202) ->"战场未开启"; 
err(203) ->"等级不足45,不能参加战场"; 
err(204) ->"你刚才从战场逃跑了，暂时无法进入战场"; 
err(205) ->"野外场景才能进入战场"; 
err(206) ->"护送中,不能进入"; 
err(301) ->"不在战场中"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(64001, _B0) ->
    {ok, {}};

read(64002, _B0) ->
    {ok, {}};

read(64003, _B0) ->
    {ok, {}};

read(64004, _B0) ->
    {ok, {}};

read(64005, _B0) ->
    {ok, {}};

read(64006, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_page, _B2} = proto:read_int8(_B1),
    {ok, {P0_type, P0_page}};

read(64007, _B0) ->
    {ok, {}};

read(64008, _B0) ->
    {ok, {}};

read(64009, _B0) ->
    {ok, {}};

read(64010, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 查询活动状态 
write(64001, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64001:16,0:8, D_a_t_a/binary>>};


%% 请求加入 
write(64002, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64002:16,0:8, D_a_t_a/binary>>};


%% 退出 
write(64003, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64003:16,0:8, D_a_t_a/binary>>};


%% 个人数据统计 
write(64004, {P0_kill, P0_assists, P0_double_hit, P0_energy, P0_energy_lim, P0_score, P0_time}) ->
    D_a_t_a = <<P0_kill:16/signed, P0_assists:16/signed, P0_double_hit:16/signed, P0_energy:8/signed, P0_energy_lim:8/signed, P0_score:16/signed, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64004:16,0:8, D_a_t_a/binary>>};


%% 前十排行 
write(64005, {P0_sortlist}) ->
    D_a_t_a = <<(length(P0_sortlist)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_kill:16/signed, P1_score:16/signed>> || [P1_nickname, P1_kill, P1_score] <- P0_sortlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64005:16,0:8, D_a_t_a/binary>>};


%% 排行榜 
write(64006, {P0_type, P0_page, P0_max_page, P0_rank_list}) ->
    D_a_t_a = <<P0_type:8/signed, P0_page:8/signed, P0_max_page:8/signed, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:16/signed, P1_pkey:32, (proto:write_string(P1_pname))/binary, (proto:write_string(P1_vip))/binary, P1_val:16/signed, (proto:write_string(P1_gname))/binary>> || [P1_rank, P1_pkey, P1_pname, P1_vip, P1_val, P1_gname] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64006:16,0:8, D_a_t_a/binary>>};


%% 宝箱位置信息 
write(64007, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_mon_id:32/signed, P1_x:8/signed, P1_y:8/signed, P1_state:8/signed, P1_time:16/signed>> || [P1_mon_id, P1_x, P1_y, P1_state, P1_time] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64007:16,0:8, D_a_t_a/binary>>};


%% 结算 
write(64008, {P0_score, P0_isnew, P0_rank, P0_honor, P0_goods_list}) ->
    D_a_t_a = <<P0_score:32/signed, P0_isnew:8/signed, P0_rank:32/signed, P0_honor:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64008:16,0:8, D_a_t_a/binary>>};


%% 战场技能CD 
write(64009, {P0_sid, P0_cd}) ->
    D_a_t_a = <<P0_sid:32/signed, P0_cd:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64009:16,0:8, D_a_t_a/binary>>};


%% 战场报名 
write(64010, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64010:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



