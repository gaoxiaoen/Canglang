%%----------------------------------------------------
%% 跨服中央服务器监控树
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(sup_center).
-behaviour(supervisor).
-export([start_link/1, init/1]).
-include("common.hrl").

start_link(Args) ->
    ?INFO("[~w] 正在启动中央服监控树...", [?MODULE]),
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init([]) ->
    List = [
         {sys_env, {sys_env, start_link, [?MODULE]}, transient, 10000, worker, [sys_env]}
        ,{sys_rand, {sys_rand, start_link, []}, transient, 10000, worker, [sys_rand]}
        ,{c_init, {c_init, start_link, []}, transient, 10000, worker, [c_init]} %% 必须在sys_env启动后才启动
        ,{npc_mgr, {npc_mgr, start_link, []}, transient, 10000, worker, [npc_mgr]}
        ,{map_mgr, {map_mgr, start_link, [true]}, transient, 10000, worker, [map_mgr]}
        ,{c_rank_mgr, {c_rank_mgr, start_link, []}, transient, 10000, worker, [c_rank_mgr]}
        ,{c_arena_career_mgr, {c_arena_career_mgr, start_link, []}, transient, 10000, worker, [c_arena_career_mgr]}
        ,{c_world_compete_mgr, {c_world_compete_mgr, start_link, []}, transient, 10000, worker, [c_world_compete_mgr]}
        ,{hall_mgr, {hall_mgr, start_link, []}, transient, 10000, worker, [hall_mgr]}
        ,{drop_mgr, {drop_mgr, start_link, []}, transient, 10000, worker, [drop_mgr]}
        ,{arena_center_mgr, {arena_center_mgr, start_link, []}, transient, 10000, worker, [arena_center_mgr]}
        ,{team_mgr, {team_mgr, start_link, []}, transient, 10000, worker, [team_mgr]}
        ,{cross_boss_mgr, {cross_boss_mgr, start_link, []}, transient, 10000, worker, [cross_boss_mgr]}
        ,{cross_king_mgr, {cross_king_mgr, start_link, []}, transient, 10000, worker, [cross_king_mgr]}
        ,{c_cross_pk_mgr, {c_cross_pk_mgr, start_link, []}, transient, 10000, worker, [c_cross_pk_mgr]}
        ,{c_combat_mgr, {c_combat_mgr, start_link, []}, transient, 10000, worker, [c_combat_mgr]}
        ,{dungeon_mgr_center, {dungeon_mgr_center, start_link, []}, transient, 10000, worker, [dungeon_mgr_center]}        
        ,{dungeon_tower_hall_mgr_center, {dungeon_tower_hall_mgr_center, start_link, []}, transient, 10000, worker, [dungeon_tower_hall_mgr_center]}        
        ,{guild_arena_center_mgr, {guild_arena_center_mgr, start_link, []}, transient, 10000, worker, [guild_arena_center_mgr]}
        ,{npc_store_dung, {npc_store_dung, start_link, []}, transient, 10000, worker, [npc_store_dung]}
        ,{top_fight_center_mgr, {top_fight_center_mgr, start_link, []}, transient, 10000, worker, [top_fight_center_mgr]}
        ,{cross_ore_mgr, {cross_ore_mgr, start_link, []}, transient, 10000, worker, [cross_ore_mgr]}
        ,{c_fate_mgr, {c_fate_mgr, start_link, []}, transient, 10000, worker, [c_fate_mgr]}
        ,{wish_wall, {wish_wall, start_link, []}, transient, 10000, worker, [wish_wall]}
        ,{combat_replay_mgr, {combat_replay_mgr, start_link, []}, transient, 10000, worker, [combat_replay_mgr]}
        ,{cross_warlord_mgr, {cross_warlord_mgr, start_link, []}, transient, 10000, worker, [cross_warlord_mgr]}
        ,{practice_mgr, {practice_mgr, start_link, []}, transient, 10000, worker, [practice_mgr]}
        ,{c_trip_mgr, {c_trip_mgr, start_link, []}, transient, 10000, worker, [c_trip_mgr]}
        ,{train_mgr_center, {train_mgr_center, start_link, []}, transient, 10000, worker, [train_mgr_center]}

        ,{c_mirror_group, {c_mirror_group, start_link, []}, transient, 10000, worker, [c_mirror_group]}
    ],
    {ok, {{one_for_one, 50, 1}, List}}.
