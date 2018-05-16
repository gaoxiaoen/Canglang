%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:19
%%----------------------------------------------------
-module(pt_410).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(401) ->"未加入仙盟"; 
err(402) ->"您的权限不足，呼叫有权限的仙盟伙伴报名吧"; 
err(403) ->"势力信息不符合"; 
err(404) ->"已报名仙盟战"; 
err(405) ->"可报名仙盟数量已达上限"; 
err(406) ->"仙盟战报名已结束"; 
err(701) ->"仙盟战未开启"; 
err(702) ->"所在仙盟未报名"; 
err(703) ->"变身信息不存在"; 
err(801) ->"不在仙盟战场景中"; 
err(802) ->"护送中,不能进入"; 
err(803) ->"等级不足45及,不能进入"; 
err(1201) ->"你没有指挥权"; 
err(1202) ->"指挥冷却中"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(41001, _B0) ->
    {ok, {}};

read(41002, _B0) ->
    {ok, {}};

read(41003, _B0) ->
    {P0_group, _B1} = proto:read_int8(_B0),
    {ok, {P0_group}};

read(41004, _B0) ->
    {P0_group, _B1} = proto:read_int8(_B0),
    {ok, {P0_group}};

read(41005, _B0) ->
    {ok, {}};

read(41006, _B0) ->
    {ok, {}};

read(41007, _B0) ->
    {P0_type, _B1} = proto:read_int32(_B0),
    {ok, {P0_type}};

read(41008, _B0) ->
    {ok, {}};

read(41009, _B0) ->
    {ok, {}};

read(41010, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_page, _B2} = proto:read_int8(_B1),
    {ok, {P0_type, P0_page}};

read(41011, _B0) ->
    {P0_type, _B1} = proto:read_int32(_B0),
    {ok, {P0_type}};

read(41012, _B0) ->
    {ok, {}};

read(41013, _B0) ->
    {ok, {}};

read(41014, _B0) ->
    {ok, {}};

read(41015, _B0) ->
    {ok, {}};

read(41016, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 仙盟战状态 
write(41001, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41001:16,0:8, D_a_t_a/binary>>};


%% 报名列表 
write(41002, {P0_state, P0_time, P0_apply_list}) ->
    D_a_t_a = <<P0_state:8, P0_time:32/signed, (length(P0_apply_list)):16, (list_to_binary([<<P1_group:8/signed, (proto:write_string(P1_gkey))/binary, (proto:write_string(P1_gname))/binary, (proto:write_string(P1_pname))/binary, P1_count:8/signed, P1_is_apply:8/signed>> || [P1_group, P1_gkey, P1_gname, P1_pname, P1_count, P1_is_apply] <- P0_apply_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41002:16,0:8, D_a_t_a/binary>>};


%% 势力报名仙盟列表 
write(41003, {P0_group, P0_apply_list}) ->
    D_a_t_a = <<P0_group:8/signed, (length(P0_apply_list)):16, (list_to_binary([<<(proto:write_string(P1_gkey))/binary, (proto:write_string(P1_gname))/binary>> || [P1_gkey, P1_gname] <- P0_apply_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41003:16,0:8, D_a_t_a/binary>>};


%% 仙盟战报名 
write(41004, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41004:16,0:8, D_a_t_a/binary>>};


%% 仙盟战开始，通知报名仙盟玩家参加仙盟战 
write(41005, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41005:16,0:8, D_a_t_a/binary>>};


%% 获取变身形象信息 
write(41006, {P0_apply_list}) ->
    D_a_t_a = <<(length(P0_apply_list)):16, (list_to_binary([<<P1_figure_id:32/signed, P1_lv:8/signed>> || [P1_figure_id, P1_lv] <- P0_apply_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41006:16,0:8, D_a_t_a/binary>>};


%% 请求进入仙盟战 
write(41007, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41007:16,0:8, D_a_t_a/binary>>};


%% 退出仙盟战 
write(41008, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41008:16,0:8, D_a_t_a/binary>>};


%% 获取仙盟战统计信息 
write(41009, {P0_iscmd, P0_cmd_cd, P0_timeleft, P0_figure_id, P0_point, P0_kill, P0_assists, P0_collect_list, P0_group_list}) ->
    D_a_t_a = <<P0_iscmd:8/signed, P0_cmd_cd:8/signed, P0_timeleft:16/signed, P0_figure_id:32/signed, P0_point:32/signed, P0_kill:16/signed, P0_assists:16/signed, (length(P0_collect_list)):16, (list_to_binary([<<P1_mon_id:32/signed, P1_num:8/signed>> || [P1_mon_id, P1_num] <- P0_collect_list]))/binary, (length(P0_group_list)):16, (list_to_binary([<<P1_group:8/signed, P1_res:32/signed>> || [P1_group, P1_res] <- P0_group_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41009:16,0:8, D_a_t_a/binary>>};


%% 查看排名 
write(41010, {P0_type, P0_page, P0_max_page, P0_rank_list}) ->
    D_a_t_a = <<P0_type:8/signed, P0_page:8/signed, P0_max_page:8/signed, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:16/signed, P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_career:8/signed, P1_vip:8/signed, P1_point:32/signed, (proto:write_string(P1_gname))/binary>> || [P1_rank, P1_pkey, P1_pname, P1_career, P1_vip, P1_point, P1_gname] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41010:16,0:8, D_a_t_a/binary>>};


%% 变身（场景广播见12025） 
write(41011, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41011:16,0:8, D_a_t_a/binary>>};


%% 指挥进攻 
write(41012, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41012:16,0:8, D_a_t_a/binary>>};


%% 收到进攻广播 
write(41013, {P0_nickname, P0_x, P0_y}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, P0_x:16/signed, P0_y:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41013:16,0:8, D_a_t_a/binary>>};


%%  仙盟战结算 
write(41014, {P0_contrib, P0_new_record, P0_rank, P0_exploit, P0_goods_list}) ->
    D_a_t_a = <<P0_contrib:32/signed, P0_new_record:8/signed, P0_rank:8/signed, P0_exploit:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41014:16,0:8, D_a_t_a/binary>>};


%%  查询水晶状态 
write(41015, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_mon_id:32/signed, P1_x:8/signed, P1_y:8/signed, P1_state:8/signed, P1_time:16/signed>> || [P1_mon_id, P1_x, P1_y, P1_state, P1_time] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41015:16,0:8, D_a_t_a/binary>>};


%% 获取水晶刷新信息 
write(41016, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_mon_id:32/signed, P1_x:8/signed, P1_y:8/signed, P1_state:8/signed, P1_time:16/signed>> || [P1_mon_id, P1_x, P1_y, P1_state, P1_time] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 41016:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



