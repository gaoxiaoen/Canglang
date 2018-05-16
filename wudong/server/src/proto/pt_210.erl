%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-10-23 15:25:46
%%----------------------------------------------------
-module(pt_210).
-export([read/2, write/2]).

-include("common.hrl").
-include("skill.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"学习等级不足"; 
err(3) ->"技能已学习"; 
err(4) ->"技能未学习"; 
err(5) ->"技能等级不能超过角色等级"; 
err(6) ->"银币不足"; 
err(7) ->"技能已满级"; 
err(8) ->"技能熟练度不足"; 
err(9) ->"只能学习1级技能"; 
err(10) ->"该技能不是被动技能"; 
err(11) ->"职业不符合"; 
err(12) ->"该技能不是主动技能"; 
err(13) ->"技能书配置异常"; 
err(14) ->"技能书数量不足"; 
err(15) ->"技能熟练度已满级"; 
err(16) ->"未满足人物等级"; 
err(17) ->"使用中,无需切换"; 
err(18) ->"您未通过神装副本,未激活技能效果"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(21001, _B0) ->
    {ok, {}};

read(21002, _B0) ->
    {P0_skillid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_skillid}};

read(21003, _B0) ->
    {P0_skillid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_skillid}};

read(21004, _B0) ->
    {P0_skillid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_skillid}};

read(21005, _B0) ->
    {P0_skillid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_skillid}};

read(21006, _B0) ->
    {P0_skillid, _B1} = proto:read_uint32(_B0),
    {ok, {P0_skillid}};

read(21007, _B0) ->
    {P0_skill_effect, _B1} = proto:read_uint8(_B0),
    {ok, {P0_skill_effect}};

read(21008, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取技能列表 
write(21001, {P0_skill_serial, P0_skill_list, P0_skill_passive_list, P0_skill_evil_list, P0_skill_effect, P0_skill_xian_list}) ->
    D_a_t_a = <<P0_skill_serial:8, (length(P0_skill_list)):16, (list_to_binary([<<P1_skillid:32, P1_state:8, P1_exp:32>> || [P1_skillid, P1_state, P1_exp] <- P0_skill_list]))/binary, (length(P0_skill_passive_list)):16, (list_to_binary([<<P1_skillid:32, P1_state:8>> || [P1_skillid, P1_state] <- P0_skill_passive_list]))/binary, (length(P0_skill_evil_list)):16, (list_to_binary([<<P1_skillid:32, P1_state:8>> || [P1_skillid, P1_state] <- P0_skill_evil_list]))/binary, P0_skill_effect:8, (length(P0_skill_xian_list)):16, (list_to_binary([<<P1_skillid:32>> || P1_skillid <- P0_skill_xian_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 21001:16,0:8, D_a_t_a/binary>>};


%% 技能学习 
write(21002, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 21002:16,0:8, D_a_t_a/binary>>};


%% 技能升级 
write(21003, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 21003:16,0:8, D_a_t_a/binary>>};


%% 被动技能学习 
write(21004, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 21004:16,0:8, D_a_t_a/binary>>};


%% 被动技能升级 
write(21005, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 21005:16,0:8, D_a_t_a/binary>>};


%% 职业技能熟练度升级 
write(21006, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 21006:16,0:8, D_a_t_a/binary>>};


%% 切换主技能效果 
write(21007, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 21007:16,0:8, D_a_t_a/binary>>};


%% 通知神装技能激活 
write(21008, {P0_skill_effect}) ->
    D_a_t_a = <<P0_skill_effect:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 21008:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

one_skill_info([P0_skillid, P0_state, P0_exp]) ->
    D_a_t_a = <<P0_skillid:32, P0_state:8, P0_exp:32>>,
    <<D_a_t_a/binary>>.




