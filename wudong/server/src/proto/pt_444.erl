%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-01-15 20:34:30
%%----------------------------------------------------
-module(pt_444).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已激活"; 
err(3) ->"材料不足"; 
err(4) ->"未激活"; 
err(5) ->"已出战"; 
err(6) ->"已满级"; 
err(7) ->"非神魂"; 
err(8) ->"该神魂已经配戴"; 
err(9) ->"已满星"; 
err(10) ->"提升星级可提升等级上限"; 
err(11) ->"当前等级已满，提升神祇星级可提高技能上限"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(44401, _B0) ->
    {ok, {}};

read(44402, _B0) ->
    {P0_godness_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_godness_id}};

read(44403, _B0) ->
    {ok, {}};

read(44404, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(44405, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {P0_goods_id_list, _B5} = proto:read_array(_B1, fun(_B2) ->
        {P1_goods_id, _B3} = proto:read_key(_B2),
        {P1_num, _B4} = proto:read_key(_B3),
        {[P1_goods_id, P1_num], _B4}
    end),
    {ok, {P0_key, P0_goods_id_list}};

read(44406, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(44407, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(44408, _B0) ->
    {P0_pos, _B1} = proto:read_uint8(_B0),
    {P0_godness_key, _B2} = proto:read_key(_B1),
    {P0_goods_key, _B3} = proto:read_key(_B2),
    {ok, {P0_pos, P0_godness_key, P0_goods_key}};

read(44409, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_goods_key_list, _B4} = proto:read_array(_B1, fun(_B2) ->
        {P1_goods_key, _B3} = proto:read_key(_B2),
        {P1_goods_key, _B3}
    end),
    {ok, {P0_goods_key, P0_goods_key_list}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取当前所有神祇信息 
write(44401, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_godness_id:32, P1_lv:16, P1_is_war:8, P1_star:8, P1_exp:32, (length(P1_skill_list)):16, (list_to_binary([<<P2_skill_id:32>> || P2_skill_id <- P1_skill_list]))/binary, (length(P1_attr_list1)):16, (list_to_binary([<<P2_attr_type:8, P2_value:32>> || [P2_attr_type, P2_value] <- P1_attr_list1]))/binary, (length(P1_attr_list2)):16, (list_to_binary([<<P2_attr_type:8, P2_value:32>> || [P2_attr_type, P2_value] <- P1_attr_list2]))/binary, (length(P1_attr_list3)):16, (list_to_binary([<<P2_attr_type:8, P2_value:32>> || [P2_attr_type, P2_value] <- P1_attr_list3]))/binary, (length(P1_suit_skill_list)):16, (list_to_binary([<<P2_suit_id:32, P2_n:32, P2_skill_id:32>> || [P2_suit_id, P2_n, P2_skill_id] <- P1_suit_skill_list]))/binary, (length(P1_wear_key_list)):16, (list_to_binary([<<(proto:write_string(P2_goods_key))/binary>> || P2_goods_key <- P1_wear_key_list]))/binary, (length(P1_attr_list4)):16, (list_to_binary([<<P2_attr_type:8, P2_value:32>> || [P2_attr_type, P2_value] <- P1_attr_list4]))/binary, (length(P1_attr_list5)):16, (list_to_binary([<<P2_attr_type:8, P2_value:32>> || [P2_attr_type, P2_value] <- P1_attr_list5]))/binary>> || [P1_key, P1_godness_id, P1_lv, P1_is_war, P1_star, P1_exp, P1_skill_list, P1_attr_list1, P1_attr_list2, P1_attr_list3, P1_suit_skill_list, P1_wear_key_list, P1_attr_list4, P1_attr_list5] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44401:16,0:8, D_a_t_a/binary>>};


%% 激活神祇 
write(44402, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44402:16,0:8, D_a_t_a/binary>>};


%% 推送单个神祇信息 
write(44403, {P0_key, P0_godness_id, P0_lv, P0_is_war, P0_star, P0_exp, P0_skill_list, P0_attr_list1, P0_attr_list2, P0_attr_list3, P0_suit_skill_list, P0_wear_key_list, P0_attr_list4, P0_attr_list5}) ->
    D_a_t_a = <<(proto:write_string(P0_key))/binary, P0_godness_id:32, P0_lv:16, P0_is_war:8, P0_star:8, P0_exp:32, (length(P0_skill_list)):16, (list_to_binary([<<P1_skill_id:32>> || P1_skill_id <- P0_skill_list]))/binary, (length(P0_attr_list1)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_attr_list1]))/binary, (length(P0_attr_list2)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_attr_list2]))/binary, (length(P0_attr_list3)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_attr_list3]))/binary, (length(P0_suit_skill_list)):16, (list_to_binary([<<P1_suit_id:32, P1_n:32, P1_skill_id:32>> || [P1_suit_id, P1_n, P1_skill_id] <- P0_suit_skill_list]))/binary, (length(P0_wear_key_list)):16, (list_to_binary([<<(proto:write_string(P1_goods_key))/binary>> || P1_goods_key <- P0_wear_key_list]))/binary, (length(P0_attr_list4)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_attr_list4]))/binary, (length(P0_attr_list5)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_attr_list5]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44403:16,0:8, D_a_t_a/binary>>};


%% 神祇升星 
write(44404, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44404:16,0:8, D_a_t_a/binary>>};


%% 神祇升级 
write(44405, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44405:16,0:8, D_a_t_a/binary>>};


%% 神祇出战 
write(44406, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44406:16,0:8, D_a_t_a/binary>>};


%% 神祇通灵技能激活 
write(44407, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44407:16,0:8, D_a_t_a/binary>>};


%% 神魂上阵/替换 
write(44408, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44408:16,0:8, D_a_t_a/binary>>};


%% 神魂吞噬 
write(44409, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44409:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



