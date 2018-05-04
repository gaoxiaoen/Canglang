%% **************************************
%% 日志记录sql语句转换
%% @author wpf (wprehard@qq.com)
%% **************************************
-module(log_db).
-export([
        to_sql/1
    ]).

%% @spec to_sql(Type) -> bitstring()
%% @doc sql语句转换
to_sql(log_role_login) ->
    <<"insert into log_role_login (role_id, srv_id, platform, name, lev, career, log_type, ctime, ip, account, reg_time, device_id, online)
    values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_exchange) ->
    <<"insert into log_exchange (a_id, a_srv_id, a_name, a_coin, a_gold, a_item, b_id, b_srv_id, b_name, b_coin, b_gold, b_item, state, ctime)
    values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_shop) ->
    <<"insert into log_shop (item_id, item_name, s_type, num, g_type, g_num, rid, srv_id, name, ctime)
    values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_item_drop) ->
    <<"insert into log_item_drop (npc_id, npc_name, npc_type, item_id, item_name, item_quality, item_type, rid, srv_id, name, ctime)
    values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_storage_handle) ->
    <<"insert into log_storage_handle (rid, srv_id, name, type, item_id, item_name, item_info, ctime)
    values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_item_del) ->
    <<"insert into log_item_del (rid, srv_id, name, item_id, item_name, bind, del_type, pos, item_info, ctime)
    values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(get_del_item_log) ->
    <<"select rid, srv_id, name, item_id, item_name, bind, del_type, pos, item_info, recovered from log_item_del where id = ~p">>;
to_sql(update_del_item_log) ->
    <<"update log_item_del set recovered = recovered + 1 where id = ~p">>;
to_sql(log_coin) ->
    <<"insert into log_coin (rid, srv_id, name, type, bind_coin_b, coin_b, bind_coin, coin, remark, ctime)
    values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_stone) ->
    <<"insert into log_stone (rid, srv_id, name, type, stone_b, detstone, remark, ctime)
    values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_gold) ->
    <<"insert into log_gold (rid, srv_id, name, lev, type, gold_b, gold, remark, stat_key, ctime)
    values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_market) ->
    <<"insert into log_market (sale_id, sale_srvid, sale_name, sale_lev, buy_id, buy_srvid, buy_name, buy_lev, type, item_id, item_name, num, price, price_d, price_unit, fee, time, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_lottery) ->
    <<"insert into log_lottery (r_id, srv_id, name, type, award_id, award_name, award_num, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_role_up_lev) ->
    <<"insert into log_role_up_lev (rid, srv_id, acc, name, lev, exp, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_pet_update) ->
    <<"insert into log_pet_update (rid, srv_id, rname, pet_id, p_name, status, p_lev, p_exp, msg, pet, old_pet, old_pet_msg, new_pet_msg, ct) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(get_log_pet) ->
    <<"select rid, srv_id, rname, p_name, msg, pet, old_pet, recovered from log_pet_update where id= ~p">>;
to_sql(recovered_log_pet) ->
    <<"update log_pet_update set recovered = recovered + 1 where id = ~p">>;
to_sql(log_integral) ->
    <<"insert into log_integral (rid, srv_id, name, type, score_type, score_b, score, remark, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_bind_gold) ->
    <<"insert into log_bind_gold (rid, srv_id, name, type, bind_gold_b, bind_gold, remark, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_blacksmith) ->
    <<"insert into log_blacksmith (rid, srv_id, account, name, type, handle, result, coin, bind_coin, items, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_channel) ->
    <<"insert into log_channel (rid, name, srv_id, account, c_name, c_text, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_channel_state) ->
    <<"insert into log_channel_state (rid, srv_id, name, account, c_name, b_state, state, pellet, ret, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_activity) ->
    <<"insert into log_activity (rid, srv_id, name, account, lev, energy, b_energy, info, dot, maximum, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_gift_award) ->
    <<"insert into log_gift_award (rid, srv_id, name, gift, num, activity, remark, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_gift_open) ->
    <<"insert into log_gift_open (rid, srv_id, name, gift, items, ctime) values (~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_intimacy) ->
    <<"insert into log_intimacy (rid, srv_id, name, other_rid, other_srv_id, other_name, intimacy_before, intimacy, remark, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_mount_feed) ->
    <<"insert into log_mount_feed (rid, srv_id, name, items, add_exp, mount, old_lev, new_lev, old_exp, new_exp, old_feed, new_feed, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_npc_store_live) ->
    <<"insert into log_npc_store_live (coin, gold, num, price_1, price_2, coin_gold_per, num_per, ct) values (~s,~s,~s,~s,~s,~s,~s,~s)">>;
to_sql(log_pet_del) ->
    <<"insert into log_pet_del (rid, srv_id, name, title, pet_id, pet_name, pet_lev, grow, avg_potential, evolve, pet_msg, pet, ct) values (~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)">>;
to_sql(log_attainment) ->
    <<"insert into log_attainment (rid, srv_id, name, handle, val_b, val, remark, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_xd_lilian) ->
    <<"insert into log_xd_lilian (rid, srv_id, name, handle, val_b, val, remark, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_mount_handle) ->
    <<"insert into log_mount_handle (rid, srv_id, name, mount_name, handle, del_items, mount_b, mount_a, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_handle_all) ->
    <<"insert into log_handle_all (rid, srv_id, name, title, proto, msg, record_info, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_demon_update) ->
    <<"insert into log_demon_update (rid, srv_id, rname, handle_type, handle_cont, demon_b, demon_a, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_task_wanted) ->
    <<"insert into log_task_wanted (rid, srv_id, rname, task_type, cost_activity, accepted, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_dungeon_box) ->
    <<"insert into log_dungeon_box (rid, srv_id, name, dun_id, dun_name, item_id, item_name, item_quality, item_num, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_soul_world) ->
    <<"insert into log_soul_world (rid, srv_id, name, items, handle_type, before_handle, after_handle, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_item_output) ->
    <<"insert into log_item_output (item_id, item_name, num, get_type, ctime) values (~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_world_compete_section) ->
    <<"insert into log_world_compete_section (rid, srv_id, name, val_b, val, remark, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_shop_activity) ->
    <<"insert into log_shop_activity (rid, srv_id, name, lev, item_name, item_num, gold_b, gold, ctime, item_id)
    values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_soul) ->
    <<"insert into log_soul(rid, srv_id, name, type, old, diff, new,remark, ctime) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_taobao) ->
    <<"insert into log_taobao(rid, srv_id, name, remark, items, type, item_num, bombs, ctime) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_demon2) ->
    <<"insert into log_demon2(rid, srv_id, name, remark, demons, add_grow, add_exp, ctime) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_guild_wishshop) ->
    <<"insert into log_guild_wishshop(type, item_baseid, item_name, num, devote, rid, srv_id, name, ctime) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_pet_dragon) ->
    <<"insert into log_pet_dragon(rid, srv_id, name, remark, items, cost, ctime) values(~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_super_boss) ->
    <<"insert into log_super_boss(rid, srv_id, name, remark, bossid, ctime) values(~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_activity_activeness) ->
    <<"insert into log_activity_activeness(rid, srv_id, name, remark, type, ctime) values(~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_pet2) ->
    <<"insert into log_pet2(rid, srv_id, name, remark, result, ctime, current_pet) values(~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_medal) ->
    <<"insert into log_medal(rid, srv_id, name, remark, result, ctime) values(~s, ~s, ~s, ~s, ~s, ~s)">>;
to_sql(log_dungeon_drop) ->
    <<"insert into log_dungeon_drop(rid, srv_id, dungeon_id, name, remark, ctime, result) values(~s, ~s, ~s, ~s, ~s, ~s, ~s)">>;

%% 容错
to_sql(_) -> <<>>.
