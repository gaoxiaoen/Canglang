%%----------------------------------------------------
%% @doc 合服模块基础数据
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_data).

-export([
        tables/0
    ]
).

-include("common.hrl").
-include("merge.hrl").

tables() ->
    List = [
        #merge_table{table = <<"admin_assets_remain">>, name = <<"玩家剩余资产监控表">>, dao = merge_dao_admin_assets_remain}
        ,#merge_table{table = <<"admin_blockip">>, name = <<"封IP数据表">>, dao = merge_dao_admin_blockip}
        ,#merge_table{table = <<"admin_data_item">>, name = <<"物品数据对照表">>, dao = merge_dao_admin_data_item}
        ,#merge_table{table = <<"admin_data_petskill">>, name = <<"物品数据对照表">>, dao = merge_dao_admin_data_petskill}
        ,#merge_table{table = <<"admin_data_skill">>, name = <<"技能数据对照表">>, dao = merge_dao_admin_data_skill}
        ,#merge_table{table = <<"admin_feedback">>, name = <<"玩家意见反馈表">>, dao = merge_dao_admin_feedback}
        ,#merge_table{table = <<"admin_mail">>, name = <<"需审核邮件数据">>, dao = merge_dao_admin_mail}
        ,#merge_table{table = <<"admin_player">>, name = <<"账号表">>, dao = merge_dao_admin_player, process = merge_admin}
        ,#merge_table{table = <<"admin_user">>, name = <<"后台管理员帐号">>, dao = merge_dao_admin_user, process = merge_admin}
        ,#merge_table{table = <<"admin_unblockip">>, name = <<"白名单ip数据表">>, dao = merge_dao_admin_unblockip, process = merge_proc_log}
        ,#merge_table{table = <<"admin_role_monitor">>, name = <<"内部人员监控名单">>, dao = merge_dao_admin_role_monitor}
        ,#merge_table{table = <<"admin_srv_apply">>, name = <<"平台申请开服数据表">>, dao = merge_dao_admin_srv_apply}
        ,#merge_table{table = <<"admin_role_monitor_unlock">>, name = <<"内部玩家白名单数据表">>, dao = merge_dao_admin_role_monitor_unlock}
        ,#merge_table{table = <<"admin_role_monitor_rule">>, name = <<"内部玩家监控规则">>, dao = merge_dao_admin_role_monitor_rule}
        ,#merge_table{table = <<"charge_cache">>, name = <<"新浪充值缓存">>, dao = merge_dao_charge_cache}

        ,#merge_table{table = <<"log_gold">>, name = <<"晶钻统计日志">>, dao = merge_dao_log_gold, process = merge_proc_log}
        ,#merge_table{table = <<"log_shop_activity">>, name = <<"活动商城日志">>, dao = merge_dao_log_shop_activity, process = merge_proc_log}
        ,#merge_table{table = <<"log_pet_update">>, name = <<"宠物变化日志记录">>, dao = merge_dao_log_pet_update, process = merge_proc_log}
        ,#merge_table{table = <<"log_lock_role">>, name = <<"角色封号禁言操作日志">>, dao = merge_dao_log_lock_role, process = merge_proc_log}
        ,#merge_table{table = <<"log_campaign">>, name = <<"参加活动记录">>, dao = merge_dao_log_campaign, process = merge_proc_log}
        ,#merge_table{table = <<"log_campaign_adm">>, name = <<"参加后台活动记录">>, dao = merge_dao_log_campaign_adm, process = merge_proc_log}
        ,#merge_table{table = <<"log_item_del">>, name = <<"物品删除日志">>, dao = merge_dao_log_item_del, process = merge_proc_log}
        ,#merge_table{table = <<"log_all_total">>, name = <<"横向统计日志">>, dao = merge_dao_log_all_total, process = merge_proc_log}
        ,#merge_table{table = <<"log_role_retain">>, name = <<"游戏玩家留存率记录表">>, dao = merge_dao_log_role_retain, process = merge_proc_log}
        ,#merge_table{table = <<"log_online_num_realtime">>, name = <<"实时在线人数统计">>, dao = merge_dao_log_online_num_realtime, process = merge_proc_log}
        ,#merge_table{table = <<"log_online_time">>, name = <<"玩家在线时间日志">>, dao = merge_dao_log_online_time, process = merge_proc_log}
        ,#merge_table{table = <<"log_tshirt">>, name = <<"周年庆tshirt日志">>, dao = merge_dao_log_tshirt, process = merge_proc_log}

        ,#merge_table{table = <<"role">>, name = <<"角色信息表">>, dao = merge_dao_role}
        ,#merge_table{table = <<"role_assets">>, name = <<"角色资产表">>, dao = merge_dao_role_assets}
        ,#merge_table{table = <<"role_contact">>, name = <<"玩家通讯录">>, dao = merge_dao_role_contact}
        ,#merge_table{table = <<"role_ext">>, name = <<"角色数据">>, dao = merge_dao_role_ext}
        ,#merge_table{table = <<"role_friend_relation">>, name = <<"好友关系表">>, dao = merge_dao_role_friend_relation}
        ,#merge_table{table = <<"role_mail">>, name = <<"信件表">>, dao = merge_dao_role_mail}
        ,#merge_table{table = <<"role_task">>, name = <<"已接任务信息表">>, dao = merge_dao_role_task}
        ,#merge_table{table = <<"role_task_daily_log">>, name = <<"角色每日任务日志">>, dao = merge_dao_role_task_daily_log}
        ,#merge_table{table = <<"role_task_log">>, name = <<"角色任务日志(非日常任务)">>, dao = merge_dao_role_task_log, process = merge_task}
        ,#merge_table{table = <<"role_camp_repay_self">>, name = <<"活动返还信息表">>, dao = merge_dao_role_camp_repay_self}

        ,#merge_table{table = <<"sys_card_ext">>, name = <<"推广卡信息表">>, dao = merge_dao_sys_card_ext, process = merge_proc_card_ext}
        ,#merge_table{table = <<"sys_card_gift_log">>, name = <<"礼包卡记录">>, dao = merge_dao_sys_card_gift_log}
        ,#merge_table{table = <<"sys_casino">>, name = <<"仙境寻宝--开宝箱揭开信息">>, dao = merge_dao_sys_casino}
        ,#merge_table{table = <<"sys_charge">>, name = <<"充值记录">>, dao = merge_dao_sys_charge}
        ,#merge_table{table = <<"sys_disciple">>, name = <<"师徒数据">>, dao = merge_dao_sys_disciple}
        ,#merge_table{table = <<"sys_disciple_ext">>, name = <<"师门数据扩展以实现角色不在线情况操作">>, dao = merge_dao_sys_disciple_ext}
        ,#merge_table{table = <<"sys_drop">>, name = <<"极品装备掉落进程表">>, dao = merge_dao_sys_drop}
        ,#merge_table{table = <<"sys_dungeon_levdun">>, name = <<"副本首杀日志表">>, dao = merge_dao_sys_dungeon_levdun}
        ,#merge_table{table = <<"sys_dungeon_auto">>, name = <<"副本挂机记录表">>, dao = merge_dao_sys_dungeon_auto}
        ,#merge_table{table = <<"sys_env">>, name = <<"系统选项信息表">>, dao = merge_dao_sys_env}
        ,#merge_table{table = <<"sys_fcm">>, name = <<"账号防沉迷身份证信息">>, dao = merge_dao_sys_fcm}
        ,#merge_table{table = <<"sys_guard_rank">>, name = <<"守卫洛水排行榜">>, dao = merge_dao_sys_guard_rank}
        ,#merge_table{table = <<"sys_guild">>, name = <<"帮会">>, dao = merge_dao_sys_guild, process = merge_proc_guild}
        ,#merge_table{table = <<"sys_guild_practise">>, name = <<"帮会历练数据">>, dao = merge_dao_sys_guild_practise}
        ,#merge_table{table = <<"sys_guild_war">>, name = <<"帮战信息表">>, dao = merge_dao_sys_guild_war}
        ,#merge_table{table = <<"sys_guild_war_guild">>, name = <<"帮战信息表">>, dao = merge_dao_sys_guild_war_guild}
        ,#merge_table{table = <<"sys_guild_war_mgr">>, name = <<"帮会管理核算表">>, dao = merge_dao_sys_guild_war_mgr}
        ,#merge_table{table = <<"sys_guild_war_role">>, name = <<"帮战角色信息表">>, dao = merge_dao_sys_guild_war_role}
        ,#merge_table{table = <<"sys_guild_war_summary">>, name = <<"帮战汇总信息表">>, dao = merge_dao_sys_guild_war_summary}
        ,#merge_table{table = <<"sys_guild_war_union">>, name = <<"帮战汇总">>, dao = merge_dao_sys_guild_war_union}
        ,#merge_table{table = <<"sys_keyval">>, name = <<"主键键值表">>, dao = merge_dao_sys_keyval}
        ,#merge_table{table = <<"sys_lock_role_info">>, name = <<"角色封号禁言列表">>, dao = merge_dao_sys_lock_role_info}
        ,#merge_table{table = <<"sys_login">>, name = <<"账号在线信息">>, dao = merge_dao_sys_login}
        ,#merge_table{table = <<"sys_market_auto">>, name = <<"市场自动寄售物品配置表">>, dao = merge_dao_sys_market_auto}
        ,#merge_table{table = <<"sys_market_buy">>, name = <<"求购信息表">>, dao = merge_dao_sys_market_buy}
        ,#merge_table{table = <<"sys_market_sale">>, name = <<"市场拍卖信息表">>, dao = merge_dao_sys_market_sale}
        ,#merge_table{table = <<"sys_notice">>, name = <<"系统公告">>, dao = merge_dao_sys_notice}
        ,#merge_table{table = <<"sys_notice_board">>, name = <<"公告版内容">>, dao = merge_dao_sys_notice_board}
        ,#merge_table{table = <<"sys_npc_store_sm_refresh">>, name = <<"神秘商店全局刷新限制数据">>, dao = merge_dao_sys_npc_store_sm_refresh}
        ,#merge_table{table = <<"sys_npc_store_sm_role">>, name = <<"个人神秘商店刷新数据（过时清除）">>, dao = merge_dao_sys_npc_store_sm_role}
        ,#merge_table{table = <<"sys_rank">>, name = <<"排行榜数据(一类型一条记录)">>, dao = merge_dao_sys_rank}
        ,#merge_table{table = <<"sys_rank_celebrity">>, name = <<"名人榜数据">>, dao = merge_dao_sys_rank_celebrity}
        ,#merge_table{table = <<"sys_special_npc">>, name = <<"特殊npc记录">>, dao = merge_dao_sys_special_npc}
        ,#merge_table{table = <<"sys_special_role_guild">>, name = <<"角色的特殊帮会属性">>, dao = merge_dao_sys_special_role_guild}
        ,#merge_table{table = <<"sys_super_boss_rank">>, name = <<"超级boss排行榜">>, dao = merge_dao_sys_super_boss_rank}
        ,#merge_table{table = <<"sys_super_boss_summary">>, name = <<"超级boss汇总">>, dao = merge_dao_sys_super_boss_summary}
        ,#merge_table{table = <<"sys_wanted_rank">>, name = <<"通缉榜单">>, dao = merge_dao_sys_wanted_rank}
        ,#merge_table{table = <<"sys_role_sworn">>, name = <<"结拜系统数据">>, dao = merge_dao_sys_role_sworn}
        ,#merge_table{table = <<"sys_guild_boss">>, name = <<"帮派boss数据">>, dao = merge_dao_sys_guild_boss}
        ,#merge_table{table = <<"sys_media_card">>, name = <<"媒体卡数据">>, dao = merge_dao_sys_media_card}
        ,#merge_table{table = <<"sys_media_card_info">>, name = <<"媒体卡属性数据">>, dao = merge_dao_sys_media_card_info}
        ,#merge_table{table = <<"sys_train">>, name = <<"飞仙历练">>, dao = merge_dao_sys_train, process = merge_proc_train}
        ,#merge_table{table = <<"role_name_used">>, name = <<"角色曾用名">>, dao = merge_dao_role_name_used}
    ],
    {ok, List}.

