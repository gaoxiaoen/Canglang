%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%     每日零点数据重置调用
%%% @end
%%% Created : 04. 十一月 2015 14:24
%%%-------------------------------------------------------------------
-module(handle_midnight).
-author("hxming").
-compile(export_all).
-include("server.hrl").
-include("common.hrl").

%%=========================================================================
%% 一些定义
%% TODO: 定义模块状态。
%%=========================================================================

%%=========================================================================
%% 回调接口
%% TODO: 实现回调接口。
%%=========================================================================

cmd_midnight() ->
    handle(?MODULE, util:unixtime()).

%% -----------------------------------------------------------------
%% @desc     启动回调函数，用来初始化资源。
%% @param
%% @return  {ok, State}     : 启动正常
%%           {ignore, Reason}: 启动异常，本模块将被忽略不执行
%%           {stop, Reason}  : 启动异常，需要停止所有后台定时模块
%% -----------------------------------------------------------------
init() ->
    {ok, ?MODULE}.

%% -----------------------------------------------------------------
%% @desc     服务回调函数，用来执行业务操作。
%% @param    State          : 初始化或者上一次服务返回的状态
%% @return  {ok, NewState}  : 服务正常，返回新状态
%%           {ignore, Reason}: 服务异常，本模块以后将被忽略不执行，模块的terminate函数将被回调
%%           {stop, Reason}  : 服务异常，需要停止所有后台定时模块，所有模块的terminate函数将被回调
%% -----------------------------------------------------------------
handle(State, NowTime) ->
    %%全局计数
    catch g_daily:night_clear(),
    %%清除日常
    catch daily_load:dbclear_daily_data(),
    %%仙盟战
%%        catch guild_war_proc:get_server_pid() ! {reset, NowTime},
%%    护送重置
    catch convoy_proc:reset(NowTime),
    %%帮派
    catch spawn(fun() -> guild_midnight:guild_midnight_handle() end),
    %%冲榜活动
%%        catch spawn(fun() ->
%%        P = activity_proc:get_act_pid(),
%%        P ! act_rank_refresh,
%%        timer:sleep(3000),
%%        P ! mignight_rank_handle
%%                    end),
    %%物品统计
    catch goods_count:night_refresh(),
    catch role_goods_count:night_refresh(),
    catch gold_count:night_refresh(),
    catch global_money_create:get_pid() ! night_refresh,
    %%抢购商店
%%    activity_proc:get_act_pid() ! lim_shop_refresh,
    %%魔物入侵
%%        catch invade_proc:get_server_pid() ! {reset, NowTime},
    %%百兽猎场
%%        catch cross_hunt_proc:get_server_pid() ! {reset, NowTime},
%%    神谕恩泽
    catch grace_proc:get_server_pid() ! {reset, NowTime},
    %%战场
%%        catch battlefield_proc:get_server_pid() ! {reset, NowTime},
    %%跨服巅峰战场
    catch cross_battlefield_proc:get_server_pid() ! {reset, NowTime},
    %%跨服boss
%%        catch cross_boss_proc:get_server_pid() ! {reset, NowTime},
    %%跨服1v1
    catch cross_elite_proc:get_server_pid() ! {reset, NowTime},
    %%领地战
    catch manor_war_proc:get_server_pid() ! {reset, NowTime},
    %%乱斗
    catch cross_scuffle_proc:get_server_pid() ! {reset, NowTime},
    %%乱斗精英
    catch cross_scuffle_elite_proc:get_server_pid() ! {reset, NowTime},
    %%跨服1vN
    catch cross_1vn_proc:get_server_pid() ! {reset, NowTime},

    %%跨服1vN
    catch cross_1vn_proc:get_server_pid() ! {reset, NowTime},

    %%排行榜分区刷新
    spawn(fun() -> util:sleep(5000), activity_area_group:midnight_refresh_area_list() end),

    %%合服仙盟排行
%%    guild_rank:reward(),
    %%排行榜膜拜
    spawn(fun() -> rank_handle:wp_update() end),
    dungeon_record:midnight(),
    %% 循环活动每日凌晨重置
    spawn(fun() -> act_open_info:sys_midnight_refresh() end),
    %%玩家自身数据重置
    OnlineList = ets:tab2list(?ETS_ONLINE),
    F = fun(Online) ->
        Online#ets_online.pid ! {midnight_refresh, NowTime}
    end,
    lists:foreach(F, OnlineList),
    %%清理宠物缓存
%%    spawn(fun() -> timer:sleep(?ONE_HOUR_SECONDS), pet:clean_pet_shadow() end),
    %%开服活动之团购首充(不操作数据库)
    spawn(fun() -> open_act_group_charge:sys_midnight_refresh() end),
    %%合服活动之团购首充(不操作数据库)
    spawn(fun() -> merge_act_group_charge:sys_midnight_refresh() end),
    %%迷宫寻宝系统重置(不操作数据库)
    spawn(fun() -> act_map:sys_midnight_refresh(NowTime) end),
    spawn(fun() -> worship_proc:get_worship_pid() ! check_change_people end),
    spawn(fun() -> limit_buy:sys_midnight_refresh() end),
    %%绑元礼包
    catch charge_gift_proc:get_server_pid() ! {midnight, NowTime},
    catch month_card_proc:get_server_pid() ! {midnight, NowTime},
    %% 消费排行榜
    spawn(fun() -> consume_rank:night_refresh_all() end),
    %% 充值排行榜
    spawn(fun() -> recharge_rank:night_refresh_all() end),
    %% 结婚排行榜
    spawn(fun() -> marry_rank:night_refresh_all() end),
    %% 跨天清除数据，不操作数据库
    spawn(fun() -> cross_boss:midnight_clean() end),
    %% 开服活动之返利抢购
    spawn(fun() -> open_act_back_buy:sys_midnight_refresh() end),
    %% 合服活动之返利抢购
    spawn(fun() -> merge_act_back_buy:sys_midnight_refresh() end),
    %% 开服活动之全服目标1
    spawn(fun() -> open_act_all_target:sys_midnight_refresh() end),
    %% 开服活动之全服目标2
    spawn(fun() -> open_act_all_target2:sys_midnight_refresh() end),
    %% 开服活动之全服目标3
    spawn(fun() -> open_act_all_target3:sys_midnight_refresh() end),
    %% 一元抢购活动
    spawn(fun() -> act_one_gold_buy:sys_midnight_refresh() end),
    %% 节日活动之红包雨
    spawn(fun() -> festival_red_gift:sys_midnight_refresh() end),
    %% 攻城战凌晨刷新
    spawn(fun() -> cross_war:sys_midnight_refresh() end),
    %% 晚上12点补发财神单笔活动奖励
    spawn(fun() -> cs_charge_d:sys_cacl() end),
    %% 晚上12点补发小额单笔活动奖励
    spawn(fun() -> small_charge_d:sys_cacl() end),
    %% 中心服周一凌晨，精英boss刷新
    spawn(fun() -> elite_boss:midnight_refresh() end),
    %% 凌晨，公会对战刷新
    spawn(fun() -> guild_fight:sys_midnight_refresh() end),
    %% 清除战败奖励计数
    spawn(fun() -> guild_fight:clean_fail_reward() end),
    %% 清除集市出售计数
    spawn(fun() -> market:clean_fail_reward() end),
    %% 凌晨清除购买数据
    spawn(fun() -> field_boss:midnight_refresh() end),
    %%婚礼
    catch marry_proc:get_server_pid() ! {reset, NowTime},
    %%宴席
    catch party_proc:get_server_pid() ! {reset, NowTime},
    %%跨服深渊
    catch cross_dark_bribe_proc:get_server_pid() ! {reset, NowTime},
    catch active_proc:get_server_pid() ! {reset, NowTime},
    catch cron_login:cron_login(NowTime),
    catch guild_answer_proc:get_server_pid() !{reset,NowTime},
    {ok, State}.

%% -----------------------------------------------------------------
%% @desc     停止回调函数，用来销毁资源。
%% @param    Reason        : 停止原因
%% @param    State         : 初始化或者上一次服务返回的状态
%% @return   ok
%% -----------------------------------------------------------------
terminate(Reason, State) ->
    ?DEBUG("================Terming..., Reason=[~w], Statee = [~w]", [Reason, State]),
    ok.