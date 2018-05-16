%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-05-15 15:26:08
%%----------------------------------------------------
-module(pt_582).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已经开始大作战"; 
err(3) ->"没有可领取奖励"; 
err(4) ->"已经领取过了"; 
err(5) ->"邀请太频繁了，先不用急"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(58201, _B0) ->
    {ok, {}};

read(58202, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(58203, _B0) ->
    {ok, {}};

read(58204, _B0) ->
    {ok, {}};

read(58205, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_pos, _B2} = proto:read_uint8(_B1),
    {ok, {P0_type, P0_pos}};

read(58206, _B0) ->
    {ok, {}};

read(58207, _B0) ->
    {ok, {}};

read(58210, _B0) ->
    {ok, {}};

read(58211, _B0) ->
    {ok, {}};

read(58212, _B0) ->
    {ok, {}};

read(58220, _B0) ->
    {P0_player_list, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_pkey, _B2} = proto:read_uint32(_B1),
        {P1_pkey, _B2}
    end),
    {ok, {P0_player_list}};

read(58221, _B0) ->
    {ok, {}};

read(58222, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_res, _B2} = proto:read_uint8(_B1),
    {ok, {P0_pkey, P0_res}};

read(58223, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取匹配信息 
write(58201, {P0_leave_times}) ->
    D_a_t_a = <<P0_leave_times:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58201:16,0:8, D_a_t_a/binary>>};


%% 开始匹配 
write(58202, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58202:16,0:8, D_a_t_a/binary>>};


%% 开始比赛通知 
write(58203, {P0_player2}) ->
    D_a_t_a = <<(pack_player(P0_player2))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58203:16,0:8, D_a_t_a/binary>>};


%% 当前比赛信息 改变时服务端推送 
write(58204, {P0_round, P0_target_fruit_list, P0_mypoint, P0_my_fruit_list, P0_point1, P0_fruit_list1, P0_player2}) ->
    D_a_t_a = <<P0_round:8, (length(P0_target_fruit_list)):16, (list_to_binary([<<P1_type:8>> || P1_type <- P0_target_fruit_list]))/binary, P0_mypoint:8, (length(P0_my_fruit_list)):16, (list_to_binary([<<P1_type:8, P1_click_times:8, P1_boom_leave_time:8, P1_change_type:8>> || [P1_type, P1_click_times, P1_boom_leave_time, P1_change_type] <- P0_my_fruit_list]))/binary, P0_point1:8, (length(P0_fruit_list1)):16, (list_to_binary([<<P1_type:8, P1_click_times:8, P1_boom_leave_time:8, P1_change_type:8>> || [P1_type, P1_click_times, P1_boom_leave_time, P1_change_type] <- P0_fruit_list1]))/binary, (pack_player(P0_player2))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58204:16,0:8, D_a_t_a/binary>>};


%% 操作 
write(58205, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58205:16,0:8, D_a_t_a/binary>>};


%% 结算 
write(58206, {P0_res, P0_goods_list}) ->
    D_a_t_a = <<P0_res:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58206:16,0:8, D_a_t_a/binary>>};


%% 退出比赛 
write(58207, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58207:16,0:8, D_a_t_a/binary>>};


%% 获取周排行奖励信息 
write(58210, {P0_week_rank_list}) ->
    D_a_t_a = <<(length(P0_week_rank_list)):16, (list_to_binary([<<P1_min_rank:16, P1_max_rank:16, P1_get_state:8, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_min_rank, P1_max_rank, P1_get_state, P1_goods_list] <- P0_week_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58210:16,0:8, D_a_t_a/binary>>};


%% 获取排行榜 
write(58211, {P0_my_wim_times, P0_my_order, P0_rank_list}) ->
    D_a_t_a = <<P0_my_wim_times:32, P0_my_order:32, (length(P0_rank_list)):16, (list_to_binary([<<P1_order:32, P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_sn:32, P1_win_times:32>> || [P1_order, P1_pkey, P1_pname, P1_sn, P1_win_times] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58211:16,0:8, D_a_t_a/binary>>};


%% 领取排行奖励 
write(58212, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58212:16,0:8, D_a_t_a/binary>>};


%% 邀请玩家 
write(58220, {P0_code, P0_res}) ->
    D_a_t_a = <<P0_code:8, (proto:write_string(P0_res))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58220:16,0:8, D_a_t_a/binary>>};


%% 邀请通知 
write(58221, {P0_player}) ->
    D_a_t_a = <<(pack_player(P0_player))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58221:16,0:8, D_a_t_a/binary>>};


%% 邀请回应 
write(58222, {P0_res}) ->
    D_a_t_a = <<(proto:write_string(P0_res))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58222:16,0:8, D_a_t_a/binary>>};


%% 继续 
write(58223, {P0_res}) ->
    D_a_t_a = <<(proto:write_string(P0_res))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58223:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_player([P0_pkey, P0_name, P0_sn, P0_career, P0_sex, P0_avatar]) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_name))/binary, P0_sn:32, P0_career:8, P0_sex:8, (proto:write_string(P0_avatar))/binary>>,
    <<D_a_t_a/binary>>.




