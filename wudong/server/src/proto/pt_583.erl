%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-06-29 19:48:54
%%----------------------------------------------------
-module(pt_583).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"只能从普通场景才能进入"; 
err(3) ->"活动还没开启"; 
err(4) ->"你没有参与温泉"; 
err(5) ->"已经在双修"; 
err(6) ->"没有整蛊次数了"; 
err(7) ->"cd中，请稍等"; 
err(8) ->"对方不在温泉"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(58301, _B0) ->
    {ok, {}};

read(58302, _B0) ->
    {ok, {}};

read(58303, _B0) ->
    {ok, {}};

read(58304, _B0) ->
    {ok, {}};

read(58305, _B0) ->
    {ok, {}};

read(58306, _B0) ->
    {ok, {}};

read(58307, _B0) ->
    {ok, {}};

read(58308, _B0) ->
    {ok, {}};

read(58309, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(58310, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(58311, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 活动状态 
write(58301, {P0_state, P0_leave_time}) ->
    D_a_t_a = <<P0_state:8, P0_leave_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58301:16,0:8, D_a_t_a/binary>>};


%% 进入温泉 
write(58302, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58302:16,0:8, D_a_t_a/binary>>};


%% 退出温泉 
write(58303, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58303:16,0:8, D_a_t_a/binary>>};


%% 温泉信息 
write(58304, {P0_leave_time, P0_sum_exp, P0_vip_lv, P0_vip_add, P0_sx_state, P0_pkey, P0_joke_times, P0_max_joke_times, P0_joke_cd, P0_joke_exp}) ->
    D_a_t_a = <<P0_leave_time:32, P0_sum_exp:32, P0_vip_lv:8, P0_vip_add:16, P0_sx_state:8, P0_pkey:32, P0_joke_times:8, P0_max_joke_times:8, P0_joke_cd:16, P0_joke_exp:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58304:16,0:8, D_a_t_a/binary>>};


%% 申请双修 
write(58305, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58305:16,0:8, D_a_t_a/binary>>};


%% 双修匹配通知 
write(58306, {P0_state, P0_pkey, P0_x, P0_y}) ->
    D_a_t_a = <<P0_state:8, P0_pkey:32, P0_x:32, P0_y:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58306:16,0:8, D_a_t_a/binary>>};


%% 结束双修 
write(58307, {P0_res, P0_state}) ->
    D_a_t_a = <<P0_res:8, P0_state:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58307:16,0:8, D_a_t_a/binary>>};


%% 进行双修 
write(58308, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58308:16,0:8, D_a_t_a/binary>>};


%% 发起双修 
write(58309, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58309:16,0:8, D_a_t_a/binary>>};


%% 发起整蛊 
write(58310, {P0_res, P0_pkey}) ->
    D_a_t_a = <<P0_res:8, P0_pkey:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58310:16,0:8, D_a_t_a/binary>>};


%% 被整蛊通知 
write(58311, {P0_pkey}) ->
    D_a_t_a = <<P0_pkey:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58311:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



