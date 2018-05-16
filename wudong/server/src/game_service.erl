%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 游戏服务监督进程
%%% @end
%%% Created : 30. 七月 2015 下午3:23
%%%-------------------------------------------------------------------
-module(game_service).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("dungeon.hrl").
-include("team.hrl").
-include("g_daily.hrl").
-include("scene.hrl").
-include("evaluated.hrl").
-include("wish_tree.hrl").
-include("guild_war.hrl").
-include("task.hrl").
-include("count.hrl").
-include("taobao.hrl").
-include("cross_battlefield.hrl").
-include("cross_boss.hrl").
-include("cross_elite.hrl").
-include("cross_eliminate.hrl").
-include("pet.hrl").
-include("marry.hrl").
-include("cross_war.hrl").
-include("cross_dungeon.hrl").
-include("manor_war.hrl").
-include("cross_six_dragon.hrl").
-include("designation.hrl").
-include("guild_manor.hrl").
-include("answer.hrl").
-include("more_exp.hrl").
-include("month_card.hrl").
-include("findback.hrl").
-include("robot.hrl").
-include("cross_scuffle.hrl").
-include("activity.hrl").
-include("cross_scuffle_elite.hrl").
-include("cross_dungeon_guard.hrl").
-include("cross_mining.hrl").

-behaviour(supervisor).

%% API
-export([start_link/0, init_ets/0, init_data/0]).

%% Supervisor callbacks
-export([init/1, init_merge_sn/0]).

-define(SERVER, ?MODULE).


start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).



init([]) ->
    {ok, {{one_for_one, 10, 10},
        [
            %% --注意服务初始化顺序，优先初始化基础服务 -- %%
            %% key服务
            {keygen, {keygen, start_link, []}, permanent, 10000, worker, [keygen]}
            %% 缓存管理
            , {cache, {cache, start_link, []}, permanent, 10000, worker, [cache]}
            %% 定时器管理
            , {timer_second, {timer_second, start_link, []}, permanent, 10000, worker, [timer_second]}
            , {timer_minute, {timer_minute, start_link, []}, permanent, 10000, worker, [timer_minute]}
            , {timer_hour, {timer_hour, start_link, []}, permanent, 10000, worker, [timer_hour]}
            , {timer_day, {timer_day, start_link, []}, permanent, 10000, worker, [timer_day]}
            %% 日志管理
            , {log_proc, {log_proc, start_link, []}, permanent, 10000, worker, [log_proc]}
            %% 阻挡区
%%            , {scene_mark, {scene_mark, start_link, []}, permanent, 10000, worker, [scene_mark]}
            %%场景线路
            , {scene_copy_proc, {scene_copy_proc, start_link, []}, permanent, 10000, worker, [scene_copy_proc]}
            %% 怪物代理
            , {mon_agent, {mon_agent, start_link, []}, permanent, 10000, worker, [mon_agent]}
            %% 场景初始化
            , {scene_init, {scene_init, start_link, []}, permanent, 10000, worker, [scene_init]}
            %% 场景掉落
            , {drop_scene, {drop_scene, start_link, []}, permanent, 10000, worker, [drop_scene]}
            %% 副本记录
            , {dungeon_record, {dungeon_record, start_link, []}, permanent, 10000, worker, [dungeon_record]}
            %%仙盟管理
            , {guild, {guild, start_link, []}, permanent, 10000, worker, [guild]}
            %%玩家镜像管理
            , {shadow_proc, {shadow_proc, start_link, []}, permanent, 10000, worker, [shadow_proc]}
            %%竞技场管理
            , {arena_proc, {arena_proc, start_link, []}, permanent, 10000, worker, [arena_proc]}
            %%我要变强
            , {wybq_proc, {wybq_proc, start_link, []}, permanent, 10000, worker, [wybq_proc]}
            %%交易所
            , {market_proc, {market_proc, start_link, []}, permanent, 10000, worker, [market_proc]}
            %% 活动管理
            , {activity_proc, {activity_proc, start_link, []}, permanent, 10000, worker, [activity_proc]}
            %% 广播管理
            , {notice_proc, {notice_proc, start_link, []}, permanent, 10000, worker, [notice_proc]}
            %%聊天管理
            , {chat_proc, {chat_proc, start_link, []}, permanent, 10000, worker, [chat_proc]}
            %%排行榜管理
            , {rank_proc, {rank_proc, start_link, []}, permanent, 10000, worker, [rank_proc]}
            %%工会战管理
            , {guild_war_proc, {guild_war_proc, start_link, []}, permanent, 10000, worker, [guild_war_proc]}
            %%许愿树
            , {wish_tree, {wish_tree, start_link, []}, permanent, 10000, worker, [wish_tree]}
            %%称号
            , {designation_proc, {designation_proc, start_link, []}, permanent, 10000, worker, [designation_proc]}
            %%功能推送管理
            , {psh, {psh, start_link, []}, permanent, 10000, worker, [psh]}
            %%双倍护送
            , {convoy_proc, {convoy_proc, start_link, []}, permanent, 10000, worker, [convoy_proc]}
            %%多倍经验
            , {exp_activity_proc, {exp_activity_proc, start_link, []}, permanent, 10000, worker, [exp_activity_proc]}
            %%任务统计
            , {task_cron, {task_cron, start_link, []}, permanent, 10000, worker, [task_cron]}
            %%魔物入侵
            , {invade_proc, {invade_proc, start_link, []}, permanent, 10000, worker, [invade_proc]}
            %%猎场
            , {cross_hunt_proc, {cross_hunt_proc, start_link, []}, permanent, 10000, worker, [cross_hunt_proc]}
            %%神谕恩泽
            , {grace_proc, {grace_proc, start_link, []}, permanent, 10000, worker, [grace_proc]}
            %%战场
            , {battlefield_proc, {battlefield_proc, start_link, []}, permanent, 10000, worker, [battlefield_proc]}
            %%膜拜
            , {worship_proc, {worship_proc, start_link, []}, permanent, 10000, worker, [worship_proc]}
            %%货币统计
            , {global_money_create, {global_money_create, start_link, []}, permanent, 10000, worker, [global_money_create]}
            %%货币统计
            , {red_bag_proc, {red_bag_proc, start_link, []}, permanent, 10000, worker, [red_bag_proc]}
            %%跨服巅峰争霸赛
            , {cross_battlefield_proc, {cross_battlefield_proc, start_link, []}, permanent, 10000, worker, [cross_battlefield_proc]}
            %%跨服boss
            , {cross_boss_proc, {cross_boss_proc, start_link, []}, permanent, 10000, worker, [cross_boss_proc]}
            %%跨服elite
            , {cross_elite_proc, {cross_elite_proc, start_link, []}, permanent, 10000, worker, [cross_elite_proc]}
            %%野外boss
            , {field_boss_proc, {field_boss_proc, start_link, []}, permanent, 10000, worker, [field_boss_proc]}
            %%跨服竞技场
            , {cross_arena_proc, {cross_arena_proc, start_link, []}, permanent, 10000, worker, [cross_arena_proc]}
            %%跨服消消乐
            , {cross_eliminate_proc, {cross_eliminate_proc, start_link, []}, permanent, 10000, worker, [cross_eliminate_proc]}
            %%跨服鲜花榜
            , {cross_flower_proc, {cross_flower_proc, start_link, []}, permanent, 10000, worker, [cross_flower_proc]}
            %%单服鲜花榜
            , {flower_rank_proc, {flower_rank_proc, start_link, []}, permanent, 10000, worker, [flower_rank_proc]}
            %%跨服消费榜
            , {cross_consume_rank_proc, {cross_consume_rank_proc, start_link, []}, permanent, 10000, worker, [cross_consume_rank_proc]}
            %%区域跨服消费榜
            , {area_consume_rank_proc, {area_consume_rank_proc, start_link, []}, permanent, 10000, worker, [area_consume_rank_proc]}
            %%跨服充值榜
            , {cross_recharge_rank_proc, {cross_recharge_rank_proc, start_link, []}, permanent, 10000, worker, [cross_recharge_rank_proc]}
            %%区域跨服充值榜
            , {area_recharge_rank_proc, {area_recharge_rank_proc, start_link, []}, permanent, 10000, worker, [area_recharge_rank_proc]}
            %%结婚
            , {marry_proc, {marry_proc, start_link, []}, permanent, 10000, worker, [marry_proc]}
            %%城战
            , {cross_war_proc, {cross_war_proc, start_link, []}, permanent, 10000, worker, [cross_war_proc]}
            %%跨服副本
            , {cross_dungeon_proc, {cross_dungeon_proc, start_link, []}, permanent, 10000, worker, [cross_dungeon_proc]}
            %%跨服试炼副本
            , {cross_dungeon_guard_proc, {cross_dungeon_guard_proc, start_link, []}, permanent, 10000, worker, [cross_dungeon_guard_proc]}
            %%领地战
            , {manor_war_proc, {manor_war_proc, start_link, []}, permanent, 10000, worker, [manor_war_proc]}
            %%王城守卫
            , {kindom_guard_proc, {kindom_guard_proc, start_link, []}, permanent, 10000, worker, [kindom_guard_proc]}
            %%王城守卫
            , {cross_six_dragon_proc, {cross_six_dragon_proc, start_link, []}, permanent, 10000, worker, [cross_six_dragon_proc]}
            %%答题
            , {answer_proc, {answer_proc, start_link, []}, permanent, 10000, worker, [answer_proc]}
            %%buff超时管理
            , {buff_proc, {buff_proc, start_link, []}, permanent, 10000, worker, [buff_proc]}
            %%答题
            , {cross_fruit_proc, {cross_fruit_proc, start_link, []}, permanent, 10000, worker, [cross_fruit_proc]}
            %%绑元礼包
            , {charge_gift_proc, {charge_gift_proc, start_link, []}, permanent, 10000, worker, [charge_gift_proc]}
            , {month_card_proc, {month_card_proc, start_link, []}, permanent, 10000, worker, [month_card_proc]}
            %%温泉
            , {hot_well_proc, {hot_well_proc, start_link, []}, permanent, 10000, worker, [hot_well_proc]}
            %%跨服乱斗
            , {cross_scuffle_proc, {cross_scuffle_proc, start_link, []}, permanent, 10000, worker, [cross_scuffle_proc]}
            %%跨服乱斗精英赛
            , {cross_scuffle_elite_proc, {cross_scuffle_elite_proc, start_link, []}, permanent, 10000, worker, [cross_scuffle_elite_proc]}
            %%跨服1vn
            , {cross_1vn_proc, {cross_1vn_proc, start_link, []}, permanent, 10000, worker, [cross_1vn_proc]}
            %%种花
            , {plant_proc, {plant_proc, start_link, []}, permanent, 10000, worker, [plant_proc]}
            %%仙侣大厅
            , {marry_room_proc, {marry_room_proc, start_link, []}, permanent, 10000, worker, [marry_room_proc]}
            %%宴会
            , {party_proc, {party_proc, start_link, []}, permanent, 10000, worker, [party_proc]}
            %%仙盟宝箱
            , {guild_box_proc, {guild_box_proc, start_link, []}, permanent, 10000, worker, [guild_box_proc]}
            %%跨服深渊
            , {cross_dark_bribe_proc, {cross_dark_bribe_proc, start_link, []}, permanent, 10000, worker, [cross_dark_bribe_proc]}
            %%
            , {active_proc, {active_proc, start_link, []}, permanent, 10000, worker, [active_proc]}
            %% 登陆在线队列
            , {online_queue_proc, {online_queue_proc, start_link, []}, permanent, 10000, worker, [online_queue_proc]}
            %% 精英boss
            , {elite_boss_proc, {elite_boss_proc, start_link, []}, permanent, 10000, worker, [elite_boss_proc]}
            %% 公会对战
            , {guild_fight_proc, {guild_fight_proc, start_link, []}, permanent, 10000, worker, [guild_fight_proc]}
            %% 仙晶矿洞
            , {cross_mining_proc, {cross_mining_proc, start_link, []}, permanent, 10000, worker, [cross_mining_proc]}
            %%仙盟答题
            , {guild_answer_proc, {guild_answer_proc, start_link, []}, permanent, 10000, worker, [guild_answer_proc]}
        ]}
    }.

init_ets() ->
    ets:new(?ETS_ONLINE, [{keypos, #player.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_SCENE_ACC, [{keypos, #ets_scene_acc.pid} | ?ETS_OPTIONS]),
    ets:new(?ETS_SCENE_PID, [{keypos, #ets_scene_pid.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_GUILD, [{keypos, #guild.gkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_GUILD_BOSS_DAMAGE, [{keypos, #ets_g_boss.gkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_GUILD_MEMBER, [{keypos, #g_member.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_GUILD_APPLY, [{keypos, #g_apply.akey} | ?ETS_OPTIONS]),
    ets:new(?ETS_GUILD_MANOR, [{keypos, #g_manor.gkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_TEAM, [{keypos, #team.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_TEAM_MB, [{keypos, #t_mb.pkey} | ?ETS_OPTIONS]),
    ets:new(?G_DAILY_ETS, [{keypos, #g_daily.type} | ?ETS_OPTIONS]),
    ets:new(?G_FOREVER_ETS, [{keypos, #g_daily.type} | ?ETS_OPTIONS]),
    ets:new(?ETS_SCENE_COPY, [{keypos, #scene_copy.scene_id} | ?ETS_OPTIONS]),
    ets:new(?ETS_CBP_EVALUATED, [{keypos, #ets_cbp_evaluated.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_WISH_TREE, [{keypos, #wish_tree.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_ST_FIGURE, [{keypos, #st_figure.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_REVIVE, [{keypos, #st_revive.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_SHADOW, [{keypos, #player.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_TASK_FILTER, [{keypos, #task_filter.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_MORE_EXP, [{keypos, #base_more_exp_time.id} | ?ETS_OPTIONS]),
    ets:new(?ETS_GOODS_COUNT, [{keypos, #cgoods.goods_id} | ?ETS_OPTIONS]),
    ets:new(?ETS_TAOBAO_RECORD, [{keypos, 1} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_ELITE, [{keypos, #ce_mb.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_ELIMINATE, [{keypos, #eliminate_mb.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_MARRY, [{keypos, #st_marry.mkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_KF_NODES, [{keypos, #ets_kf_nodes.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_NODE, [{keypos, #ets_cross_node.sn} | ?ETS_OPTIONS]),
    ets:new(?ETS_WAR_NODES, [{keypos, #ets_war_nodes.sn} | ?ETS_OPTIONS]),
    ets:new(?ETS_DUN_MB_POS, [{keypos, #ets_dun_mb_pos.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_MANOR, [{keypos, #manor.scene_id} | ?ETS_OPTIONS]),
    ets:new(?ETS_MANOR_WAR, [{keypos, #manor_war.gkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_MANOR_WAR_STATE, [{keypos, 1} | ?ETS_OPTIONS]),
    ets:new(?ETS_SIX_DRAGON_PLAYER, [{keypos, #sd_player.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_SIX_DRAGON_TEAM, [{keypos, #sd_team.copy} | ?ETS_OPTIONS]),
    ets:new(?ETS_DESIGNATION_GLOBAL, [{keypos, #designation_global.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_ANSWER_PLAYER, [{keypos, #a_pinfo.pkey} | ?ETS_OPTIONS]),
    ets:new(?MONTH_CARD_ETS, [{keypos, 1} | ?ETS_OPTIONS]),
    ets:new(?ETS_FINDBACK_ACT_TIME, [{keypos, #fd_act_time.type} | ?ETS_OPTIONS]),
    ets:new(?ETS_MERGE_SN, [{keypos, #merge_sn.sn} | ?ETS_OPTIONS]),
    ets:new(?ETS_ROBOT_STEP, [{keypos, #robot_step.scene} | ?ETS_OPTIONS]),
    ets:new(ets_scene_msg, [{keypos, 1} | ?ETS_OPTIONS]),
    ets:new(?ETS_KF_MERGE_SN, [{keypos, #ets_kf_merge_sn.sn} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_SCUFFLE_RECORD, [{keypos, #ets_cross_scuffle_record.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_SCUFFLE_ELITE_RECORD, [{keypos, #ets_cross_scuffle_elite_record.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_SN_NAME, [{keypos, #ets_sn_name.sn} | ?ETS_OPTIONS]),
    ets:new(ets_rank_dun_guard, [{keypos, #ets_rank_dun_guard.pkey} | ?ETS_OPTIONS]),
    ets:new(ets_gold_silver_tower, [{keypos, #ets_gold_silver_tower.act_id} | ?ETS_OPTIONS]),
    ets:new(?ETS_AREA_GROUP, [{keypos, #ets_area_group.activity_name} | ?ETS_OPTIONS]),
    ets:new(?ETS_ACT_TIME, [{keypos, #ets_act_time.local_time} | ?ETS_OPTIONS]),
    ets:new(?ETS_WAR_TEAM, [{keypos, #war_team.wtkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_WAR_TEAM_MEMBER, [{keypos, #wt_member.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_WAR_TEAM_APPLY, [{keypos, #wt_apply.akey} | ?ETS_OPTIONS]),
    ets:new(?ETS_ACT_CBP_RANK, [{keypos, #ets_act_cbp_rank.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_ACT_CBP_INFO, [{keypos, #ets_act_cbp_info.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_ACT_CBP_LOG, [{keypos, #ets_act_cbp_log.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_MINERAL_INFO, [{keypos, #mineral_info.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_MINERAL_LOG, [{keypos, #ets_cross_mineral_log.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_MINERAL_ALL_LOG, [{keypos, #ets_cross_mineral_all_log.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_DUNGEON_GUARD_MILESTONE, [{keypos, #cross_guard_milestone.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_MINERAL_DAILY_MEET, [{keypos, #ets_cross_mineral_daily_meet.pkey} | ?ETS_OPTIONS]),

    ok.

init_data() ->
    ?GLOBAL_DATA_RAM:init(),
    word:init(),
    g_daily_init:init(),
    g_forever_init:init(),
%%    task_init:init_delete_task(),
    goods_from:init(),
    init_server_info(),
    findback_src:game_init(),
    handle_merge(),
%%    ?DO_IF(config:is_debug(), reloader:start()),
%%    ?DO_IF(config:is_debug(), spawn(fun() -> util:sleep(15000), shadow:scene_shadow() end)),
%%    tool:memcheck(),
    init_merge_sn(),
    init_online(),
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% 写入服务器信息
init_server_info() ->
    Sn = config:get_server_num(),
    OpenTime = config:get_opening_time(),
    db:execute(io_lib:format("replace into server_info set sn = ~p ,opentime = ~p", [Sn, OpenTime])),
    ok.

%% 处理合服邮件
handle_merge() ->
    Sql = "select id,pkey ,goodstype from merge_mail where state = 0",
    Rows = db:get_all(Sql),
    case Rows of
        [] -> skip;
        _ ->
            F = fun([ID, Pkey, GoodsType]) ->
                mail:sys_send_mail([util:to_list(Pkey)], ?T("合服改名"), ?T("亲爱的玩家由于合服过程中存在同名，您获得改名卡进行更名"), [{GoodsType, 1}]),
                db:execute(io_lib:format("update merge_mail set state = 1 where id = ~p", [ID]))
                end,
            lists:foreach(F, Rows)
    end,
    ok.

%%合服服号
init_merge_sn() ->
    Sql = io_lib:format("select sn from player_state group by sn", []),
    case db:get_all(Sql) of
        [] ->
            ok;
        L ->
            F = fun([Sn]) ->
                ets:insert(?ETS_MERGE_SN, #merge_sn{sn = Sn})
                end,
            lists:foreach(F, L)
    end,
    ets:insert(?ETS_MERGE_SN, #merge_sn{sn = config:get_server_num()}),
    ok.

init_online() ->
    Sql = "update player_login set online = 0",
    db:execute(Sql).



