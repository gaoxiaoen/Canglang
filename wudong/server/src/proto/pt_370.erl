%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-02-10 10:29:18
%%----------------------------------------------------
-module(pt_370).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"元宝不足"; 
err(3) ->"哎呀，偷取失败，下次再来吧！"; 
err(4) ->"还没有许愿，不能施肥"; 
err(5) ->"还没有许愿，不能浇水"; 
err(6) ->"冷却时间未到，请耐心等候"; 
err(7) ->"已经许愿成功，在收获之前不能刷新"; 
err(8) ->"已经许愿成功，在收获之前不能再次许愿"; 
err(9) ->"本轮施肥已经到了最大次数"; 
err(10) ->"成熟度已经满啦，无须再施肥"; 
err(11) ->"已经是可收获状态，无须再浇水"; 
err(12) ->"还未许愿，不能施肥"; 
err(13) ->"还未许愿，不能浇水"; 
err(14) ->"已经是可收获状态，无须再施肥"; 
err(15) ->"已经到了最大浇水次数"; 
err(16) ->"还未到收获时间"; 
err(17) ->"你们还不是好友"; 
err(18) ->"哎呀，偷取失败，下次再来吧"; 
err(19) ->"还未成熟，不能摘取"; 
err(20) ->"已经被摘取的差不多了，下次再来吧"; 
err(21) ->"已经采过啦，下次再来吧"; 
err(22) ->"该玩家没有访问过你，不能感谢"; 
err(23) ->"已经感谢过啦"; 
err(24) ->"该功能会员等级3开放"; 
err(25) ->"当前无好友需要浇水"; 
err(26) ->"已经感谢过了"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(37000, _B0) ->
    {ok, {}};

read(37001, _B0) ->
    {ok, {}};

read(37002, _B0) ->
    {ok, {}};

read(37003, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(37004, _B0) ->
    {ok, {}};

read(37005, _B0) ->
    {ok, {}};

read(37006, _B0) ->
    {ok, {}};

read(37007, _B0) ->
    {ok, {}};

read(37008, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(37009, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(37010, _B0) ->
    {ok, {}};

read(37011, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(37012, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(37013, _B0) ->
    {ok, {}};

read(37014, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(37015, _B0) ->
    {ok, {}};

read(37016, _B0) ->
    {ok, {}};

read(37017, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 好友列表 
write(37000, {P0_relations}) ->
    D_a_t_a = <<(length(P0_relations)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, (proto:write_string(P1_avatar))/binary, (proto:write_string(P1_career))/binary, P1_lv:8, P1_qinmidu:16, P1_is_wash:8, P1_can_fertilizer:8, P1_fertilizer_times:8, P1_can_water:8, P1_is_steal:8>> || [P1_pkey, P1_nickname, P1_avatar, P1_career, P1_lv, P1_qinmidu, P1_is_wash, P1_can_fertilizer, P1_fertilizer_times, P1_can_water, P1_is_steal] <- P0_relations]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37000:16,0:8, D_a_t_a/binary>>};


%% 到访记录 
write(37001, {P0_relations}) ->
    D_a_t_a = <<(length(P0_relations)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, (proto:write_string(P1_avatar))/binary, P1_career:8, P1_lv:8, P1_qinmidu:16, P1_is_thks:16, P1_is_water:8, P1_is_fertilizer:8>> || [P1_pkey, P1_nickname, P1_avatar, P1_career, P1_lv, P1_qinmidu, P1_is_thks, P1_is_water, P1_is_fertilizer] <- P0_relations]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37001:16,0:8, D_a_t_a/binary>>};


%% 获取自己许愿树信息 
write(37002, {P0_lv, P0_exp, P0_time, P0_maturity, P0_max_maturity, P0_watering_time, P0_fertilizer_money, P0_refresh_money, P0_remain_times, P0_sum_times, P0_refresh_progress, P0_client_rand_value, P0_goods_list}) ->
    D_a_t_a = <<P0_lv:8, P0_exp:16, P0_time:32/signed, P0_maturity:16, P0_max_maturity:16, P0_watering_time:32, P0_fertilizer_money:32, P0_refresh_money:32, P0_remain_times:8, P0_sum_times:8, P0_refresh_progress:16, P0_client_rand_value:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_value:32, P1_multiple:8>> || [P1_goods_id, P1_value, P1_multiple] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37002:16,0:8, D_a_t_a/binary>>};


%% 获取好友许愿树信息 
write(37003, {P0_error_code, P0_pkey, P0_avatar, P0_nickname, P0_career, P0_lv, P0_qinmidu, P0_tree_lv, P0_time, P0_maturity, P0_max_maturity, P0_is_water, P0_is_fertilizer, P0_client_rand_value, P0_is_steal, P0_is_remind, P0_goods_list}) ->
    D_a_t_a = <<P0_error_code:8, P0_pkey:32, (proto:write_string(P0_avatar))/binary, (proto:write_string(P0_nickname))/binary, P0_career:8, P0_lv:8, P0_qinmidu:16, P0_tree_lv:8, P0_time:32/signed, P0_maturity:16, P0_max_maturity:16, P0_is_water:8, P0_is_fertilizer:8, P0_client_rand_value:8, P0_is_steal:8, P0_is_remind:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_value:32, P1_multiple:8>> || [P1_goods_id, P1_value, P1_multiple] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37003:16,0:8, D_a_t_a/binary>>};


%% 刷新物品 
write(37004, {P0_code_error}) ->
    D_a_t_a = <<P0_code_error:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37004:16,0:8, D_a_t_a/binary>>};


%% 许愿 
write(37005, {P0_code_error}) ->
    D_a_t_a = <<P0_code_error:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37005:16,0:8, D_a_t_a/binary>>};


%% 给自己施肥 
write(37006, {P0_code_error, P0_add}) ->
    D_a_t_a = <<P0_code_error:8, P0_add:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37006:16,0:8, D_a_t_a/binary>>};


%% 给自己浇水 
write(37007, {P0_code_error, P0_time}) ->
    D_a_t_a = <<P0_code_error:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37007:16,0:8, D_a_t_a/binary>>};


%% 给好友施肥 
write(37008, {P0_error_code, P0_pkey, P0_add}) ->
    D_a_t_a = <<P0_error_code:8, P0_pkey:32, P0_add:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37008:16,0:8, D_a_t_a/binary>>};


%% 给好友浇水 
write(37009, {P0_error_code, P0_pkey, P0_time}) ->
    D_a_t_a = <<P0_error_code:8, P0_pkey:32, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37009:16,0:8, D_a_t_a/binary>>};


%% 收获自己的物品 
write(37010, {P0_code_error}) ->
    D_a_t_a = <<P0_code_error:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37010:16,0:8, D_a_t_a/binary>>};


%% 偷摘好友 
write(37011, {P0_code_error, P0_pkey}) ->
    D_a_t_a = <<P0_code_error:8, P0_pkey:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37011:16,0:8, D_a_t_a/binary>>};


%% 提醒好友许愿 
write(37012, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37012:16,0:8, D_a_t_a/binary>>};


%% 收到许愿提醒 
write(37013, {P0_pkey, P0_nickname}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37013:16,0:8, D_a_t_a/binary>>};


%% 感谢好友 
write(37014, {P0_error_code, P0_add_qinmidu, P0_add_exp}) ->
    D_a_t_a = <<P0_error_code:8, P0_add_qinmidu:8, P0_add_exp:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37014:16,0:8, D_a_t_a/binary>>};


%% 一键感谢所有好友 
write(37015, {P0_error_code, P0_num, P0_add_qinmidu, P0_add_exp}) ->
    D_a_t_a = <<P0_error_code:8, P0_num:8, P0_add_qinmidu:8, P0_add_exp:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37015:16,0:8, D_a_t_a/binary>>};


%% 一键浇水 
write(37016, {P0_error_code, P0_num, P0_add_qinmidu, P0_exp, P0_time}) ->
    D_a_t_a = <<P0_error_code:8, P0_num:8, P0_add_qinmidu:8, P0_exp:16, P0_time:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37016:16,0:8, D_a_t_a/binary>>};


%% 查看被偷记录 
write(37017, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_value:32>> || [P1_goods_id, P1_value] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 37017:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



