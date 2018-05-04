%%----------------------------------------------------
%% 主节点监控树
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(sup_master).
-behaviour(supervisor).
-export([start_link/1, init/1]).
-include("common.hrl").

start_link(Args) ->
    ?INFO("[~w] 正在启动监控树...", [?MODULE]),
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init([Host, Port]) ->
    List = [
         {u, {u, start_link, []}, transient, 10000, worker, [u]}
        ,{sys_env, {sys_env, start_link, [?MODULE]}, transient, 10000, worker, [sys_env]}
        ,{sys_node_mgr, {sys_node_mgr, start_link, [Host, Port]}, transient, 10000, worker, [sys_node_mgr]}
        ,{sys_rand, {sys_rand, start_link, []}, transient, 10000, worker, [sys_rand]}
        ,{sys_flash_843, {sys_flash_843, start_link, []}, transient, 10000, worker, [sys_flash_843]}
        ,{log_mgr, {log_mgr, start_link, []}, transient, 10000, worker, [log_mgr]}
        ,{role_num_counter, {role_num_counter, start_link, []}, transient, 10000, worker, [role_num_counter]}
        ,{mail_id_mgr, {mail_id_mgr, start_link, []}, transient, 10000, worker, [mail_id_mgr]}
        ,{mail_mgr, {mail_mgr, start_link, []}, transient, 10000, worker, [mail_mgr]}
        % ,{honor_mgr, {honor_mgr, start_link, []}, transient, 10000, worker, [honor_mgr]}
        ,{rank_mgr, {rank_mgr, start_link, []}, transient, 10000, worker, [rank_mgr]}
        ,{trial_mgr, {trial_mgr, start_link, []}, transient, 10000, worker, [trial_mgr]}
        ,{rank_role_info, {rank_role_info, start_link, []}, transient, 10000, worker, [rank_role_info]}
        ,{map_line, {map_line, start_link, []}, transient, 10000, worker, [map_line]}
        ,{role_group, {role_group, start_link, []}, transient, 10000, worker, [role_group]}
        ,{npc_mgr, {npc_mgr, start_link, []}, transient, 10000, worker, [npc_mgr]}
        ,{map_mgr, {map_mgr, start_link, []}, transient, 10000, worker, [map_mgr]}
        ,{hall_mgr, {hall_mgr, start_link, []}, transient, 10000, worker, [hall_mgr]}
        ,{drop_mgr, {drop_mgr, start_link, []}, transient, 10000, worker, [drop_mgr]}
        ,{dungeon_auto_mgr, {dungeon_auto_mgr, start_link, []}, transient, 10000, worker, [dungeon_auto_mgr]}
        %,{team_mgr, {team_mgr, start_link, []}, transient, 10000, worker, [team_mgr]}
        %,{sit_both_mgr, {sit_both_mgr, start_link, []}, transient, 10000, worker, [sit_both_mgr]}
        ,{shop, {shop, start_link, []}, transient, 10000, worker, [shop]}
        ,{market, {market, start_link, []}, transient, 10000, worker, [market]}
        ,{notice, {notice, start_link, []}, permanent, 10000, worker, [notice]}
        %,{guild_practise_mgr, {guild_practise_mgr, start_link, []}, permanent, 10000, worker, [guild_practise_mgr]}
        %,{guild_boss, {guild_boss, start_link, []}, transient, 10000, worker, [guild_boss]}
        ,{guild_mgr, {guild_mgr, start_link, []}, permanent, 10000, worker, [guild_mgr]}
        %,{guild_pool, {guild_pool, start_link, []}, permanent, 10000, worker, [guild_pool]}
        %,{guild_war_mgr, {guild_war_mgr, start_link, []}, permanent, 10000, worker, [guild_war_mgr]}
        %,{guild_arena, {guild_arena, start_link, []}, permanent, 10000, worker, [guild_arena]}
        %,{guild_arena_mgr, {guild_arena_mgr, start_link, []}, permanent, 10000, worker, [guild_arena_mgr]}
        %,{guild_td_mgr, {guild_td_mgr, start_link, []}, permanent, 10000, worker, [guild_td_mgr]}
        %,{guard_mgr, {guard_mgr, start_link, []}, transient, 10000, worker, [guard_mgr]}
        %% ,{boss, {boss, start_link, []}, transient, 10000, worker, [boss]}
        %%,{boss_unlock, {boss_unlock, start_link, []}, transient, 10000, worker, [boss_unlock]}
        ,{super_boss_mgr, {super_boss_mgr, start_link, []}, transient, 10000, worker, [super_boss_mgr]}
        ,{super_boss_change, {change, start_link, [super_boss_change]}, transient, 10000, worker, [super_boss_change]}
        ,{mail_adm_mgr, {mail_adm_mgr, start_link, []}, transient, 10000, worker, [mail_adm_mgr]}
        ,{item_srv_cache, {item_srv_cache, start_link, []}, transient, 10000, worker, [item_srv_cache]}
        ,{item_srv_gift, {item_srv_gift, start_link, []}, transient, 10000, worker, [item_srv_gift]}
        %,{arena_mgr, {arena_mgr, start_link, []}, transient, 10000, worker, [arena_mgr]}
        ,{campaign, {campaign, start_link, []}, transient, 10000, worker, [campaign]}
        ,{npc_store_sm, {npc_store_sm, start_link, []}, transient, 10000, worker, [npc_store_sm]}
        % ,{npc_store_live, {npc_store_live, start_link, []}, transient, 10000, worker, [npc_store_live]}
        ,{tree_mgr, {tree_mgr, start_link, []}, transient, 10000, worker, [tree_mgr]}
        %,{jail_mgr, {jail_mgr, start_link, []}, transient, 10000, worker, [jail_mgr]}
        ,{dungeon_mgr, {dungeon_mgr, start_link, []}, transient, 10000, worker, [dungeon_mgr]}
        ,{expedition, {expedition, start_link, []}, transient, 10000, worker, [expedition]}
        ,{expedition_change, {change, start_link, [expedition_change]}, transient, 10000, worker, [expedition_change]}
        %,{escort_mgr, {escort_mgr, start_link, []}, transient, 10000, worker, [escort_mgr]}
        ,{casino, {casino, start_link, []}, transient, 10000, worker, [casino]}
        ,{adm_sys, {adm_sys, start_link, []}, permanent, 10000, worker, [adm_sys]}
        ,{log_client, {log_client, start_link, []}, transient, 10000, worker, [log_client]}
        ,{key_mgr, {key_mgr, start_link, []}, transient, 10000, worker, [key_mgr]}
        %,{wish, {wish, start_link, []}, transient, 10000, worker, [wish]}
        %,{award_mgr, {award_mgr, start_link, []}, transient, 10000, worker, [award_mgr]}
        % ,{lottery, {lottery, start_link, []}, transient, 10000, worker, [lottery]}
        %%,{team_dungeon_mgr, {team_dungeon_mgr, start_link, []}, transient, 10000, worker, [team_dungeon_mgr]}
        ,{misc_mgr, {misc_mgr, start_link, []}, transient, 10000, worker, [misc_mgr]}
        ,{wanted_mgr, {wanted_mgr, start_link, []}, transient, 10000, worker, [wanted_mgr]}
        % ,{market_auto, {market_auto, start_link, []}, transient, 10000, worker, [market_auto]}
        ,{arena_career_mgr, {arena_career_mgr, start_link, []}, transient, 10000, worker, [arena_career_mgr]}
        ,{arena_career_lock, {arena_career_lock, start_link, []}, transient, 10000, worker, [arena_career_lock]}
        %% ,{npc_employ_mgr, {npc_employ_mgr, start_link, []}, transient, 10000, worker, [npc_employ_mgr]}
        ,{ip_block, {ip_block, start_link, []}, transient, 10000, worker, [ip_block]}
        ,{last_ip_cache, {last_ip_cache, start_link, []}, transient, 10000, worker, [last_ip_cache]}
        %,{escort_child_mgr, {escort_child_mgr, start_link, []}, transient, 10000, worker, [escort_child_mgr]}
        %,{escort_cyj_mgr, {escort_cyj_mgr, start_link, []}, transient, 10000, worker, [escort_cyj_mgr]}
        %,{world_compete_mgr, {world_compete_mgr, start_link, []}, transient, 10000, worker, [world_compete_mgr]}
        ,{super_boss_casino, {super_boss_casino, start_link, []}, transient, 10000, worker, [super_boss_casino]}
        ,{npc_store_dung, {npc_store_dung, start_link, []}, transient, 10000, worker, [npc_store_dung]}
        %,{sworn, {sworn, start_link, []}, transient, 10000, worker, [sworn]}
        %,{campaign_plant, {campaign_plant, start_link, []}, transient, 10000, worker, [campaign_plant]}
        %,{practice_mgr, {practice_mgr, start_link, []}, transient, 10000, worker, [practice_mgr]}
        ,{campaign_adm, {campaign_adm, start_link, []}, transient, 10000, worker, [campaign_adm]}
        %,{lottery_tree, {lottery_tree, start_link, []}, transient, 10000, worker, [lottery_tree]}
        % ,{lottery_camp, {lottery_camp, start_link, []}, transient, 10000, worker, [lottery_camp]}
        %,{task_wanted, {task_wanted, start_link, []}, transient, 10000, worker, [task_wanted]}
        %,{top_fight_mgr, {top_fight_mgr, start_link, []}, transient, 10000, worker, [top_fight_mgr]}
        ,{camp_update_notice, {camp_update_notice, start_link, []}, transient, 10000, worker, [camp_update_notice]}
        %,{soul_world, {soul_world, start_link, []}, transient, 10000, worker, [soul_world]}
        %,{combat_replay_mgr, {combat_replay_mgr, start_link, []}, transient, 10000, worker, [combat_replay_mgr]}
        %,{fireworks, {fireworks, start_link, []}, transient, 10000, worker, [fireworks]}
        %,{wish_wall, {wish_wall, start_link, []}, transient, 10000, worker, [wish_wall]}
        %,{cross_trip, {cross_trip, start_link, []}, transient, 10000, worker, [cross_trip]}
        %,{trip_mgr, {trip_mgr, start_link, []}, transient, 10000, worker, [trip_mgr]}
        ,{activity2_log, {activity2_log, start_link, []}, transient, 10000, worker, [activity2_log]}
        %,{pandora_box, {pandora_box, start_link, []}, transient, 10000, worker, [pandora_box]}
        %% ,{campaign_npc_mgr, {campaign_npc_mgr, start_link, []}, transient, 10000, worker, [campaign_npc_mgr]}
        % ,{rank_collect_mgr, {rank_collect_mgr, start_link, []}, transient, 10000, worker, [rank_collect_mgr]}
        %,{campaign_repay_self, {campaign_repay_self, start_link, []}, transient, 10000, worker, [campaign_repay_self]}
        %,{train_mgr, {train_mgr, start_link, []}, transient, 10000, worker, [train_mgr]}
        %,{campaign_repay_bystages, {campaign_repay_bystages, start_link, []}, transient, 10000, worker, [campaign_repay_bystages]}
        %% ,{campaign_repay_bystages2, {campaign_repay_bystages2, start_link, []}, transient, 10000, worker, [campaign_repay_bystages2]}
        %% ,{campaign_repay_bystages3, {campaign_repay_bystages3, start_link, []}, transient, 10000, worker, [campaign_repay_bystages3]}
        %,{campaign_tree, {campaign_tree, start_link, []}, transient, 10000, worker, [campaign_tree]}
        %,{combat_live_mgr, {combat_live_mgr, start_link, []}, transient, 10000, worker, [combat_live_mgr]}
        %,{campaign_taobao, {campaign_taobao, start_link, []}, transient, 10000, worker, [campaign_taobao]}
        %,{hunter_mgr, {hunter_mgr, start_link, []}, transient, 10000, worker, [hunter_mgr]}
        %,{campaign_model_worker, {campaign_model_worker, start_link, []}, transient, 10000, worker, [campaign_model_worker]}
        %,{campaign_taobao_tjb, {campaign_taobao_tjb, start_link, []}, transient, 10000, worker, [campaign_taobao_tjb]}
        ,{award, {award, start_link, []}, transient, 10000, worker, [award]}
        ,{adventure, {adventure, start_link, []}, transient, 10000, worker, [adventure]}
        %,{compete_mgr, {compete_mgr, start_link, []}, transient, 10000, worker, [compete_mgr]}
        %%竞技场排名要放在award后，停服更新时启动时要用award发奖励
        %,{compete_rank, {compete_rank, start_link, []}, transient, 10000, worker, [compete_rank]}
        %,{compete_change, {change, start_link, [compete_change]}, transient, 10000, worker, [compete_change]}
        %,{daily_task_delegate_mgr, {daily_task_delegate_mgr, start_link, []}, transient, 10000, worker, [daily_task_delegate_mgr]}
        ,{pet_mgr, {pet_mgr, start_link, []}, transient, 10000, worker, [pet_mgr]}
        ,{medal_mgr, {medal_mgr, start_link, []}, transient, 10000, worker, [medal_mgr]}
        ,{demon_debris_mgr, {demon_debris_mgr, start_link, []}, transient, 10000, worker, [demon_debris_mgr]}
        ,{gaussrand_mgr, {gaussrand_mgr, start_link, []}, transient, 10000, worker, [gaussrand_mgr]}
        ,{notification, {notification, start_link, []}, transient, 10000, worker, [notification]}
        ,{special_npc, {special_npc, start_link, []}, transient, 10000, worker, [special_npc]}
        ,{forbid_word_filter, {forbid_word_filter, start_link, [5]}, transient, 10000, worker, [forbid_word_filter]}
        ,{forbid_name, {forbid_name, start_link, [5]}, transient, 10000, worker, [forbid_name]}
        ,{invitation, {invitation, start_link, []}, transient, 10000, worker, [invitation]}

        % ,{random_award_mgr, {random_award_mgr, start_link, []}, transient, 10000, worker, [random_award_mgr]}
        % ,{beer_mgr, {beer_mgr, start_link, []}, transient, 10000, worker, [beer_mgr]}
        % ,{beer, {beer, start_link, []}, transient, 10000, worker, [beer]}

        %% 注意:acceptor和listener必须是最后才启动的
        ,{account_mgr, {account_mgr, start_link, []}, permanent, 10000, worker, [account_mgr]}
        ,{role_mgr, {role_mgr, start_link, []}, permanent, 10000, worker, [role_mgr]}
        %,{center, {center, start_link, []}, transient, 10000, worker, [center]}
        %,{gs_mirror_group, {gs_mirror_group, start_link, []}, transient, 10000, worker, [gs_mirror_group]}
        ,{sys_stat, {sys_stat, start_link, []}, transient, 10000, worker, [sys_stat]}
        ,{sup_acceptor, {sup_acceptor, start_link, []}, permanent, 10000, supervisor, [sup_acceptor]}
        ,{sys_listener, {sys_listener, start_link, [Port]}, transient, 10000, worker, [sys_listener]}
    ],
    {ok, {{one_for_one, 50, 1}, List}}.
