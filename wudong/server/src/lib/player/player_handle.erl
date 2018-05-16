%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 二月 2015 下午4:28
%%%-------------------------------------------------------------------
-module(player_handle).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("daily.hrl").
-include("guild.hrl").
-include("task.hrl").
-include("dungeon.hrl").
-include("drop.hrl").
-include("cross_battlefield.hrl").
-include("cross_war.hrl").
-include("activity.hrl").
-include("mount.hrl").
-include("more_exp.hrl").
-include("achieve.hrl").
-include("sword_pool.hrl").
-include("relation.hrl").
-include("robot.hrl").
-include("chat.hrl").
-include("cross_scuffle.hrl").
-include("cross_scuffle_elite.hrl").
-include("fashion.hrl").
-include("marry.hrl").
-include("cross_boss.hrl").
-include("cross_dungeon_guard.hrl").
-include("cross_1vN.hrl").
%% API
-export([
    handle_cast/2, handle_info/2, handle_call/3, print/1, ets_cmd/2, daily_login_reward/1, gm/1, repair_act_recharge/1, sync_data/2
]).

ets_cmd(Cmd, Data) ->
    case ets:lookup(?ETS_ROBOT_STEP, 9999) of
        [] ->
            NewEts = #robot_step{scene = 9999, step_list = [{Cmd, Data}]},
            ets:insert(?ETS_ROBOT_STEP, NewEts);
        [Ets] ->
            NewEts = Ets#robot_step{step_list = [{Cmd, Data} | Ets#robot_step.step_list]},
            ets:insert(?ETS_ROBOT_STEP, NewEts)
    end.

print(Scene) ->
    [Ets] = ets:lookup(?ETS_ROBOT_STEP, Scene),
    F = fun({_Cmd, _Data} = Step) ->
        io:format(",~p", [Step])
        end,
%%     lists:map(F, lists:sublist(lists:reverse(Ets#robot_step.step_list), 1, length(Ets#robot_step.step_list) div 2)).
    lists:map(F, lists:sublist(lists:reverse(Ets#robot_step.step_list), length(Ets#robot_step.step_list) div 2, length(Ets#robot_step.step_list))).

%%查询协议频率
check_cmd(Cmd) ->
    case lists:member(Cmd, [20001, 20003, 12001, 10009, 24000]) of
        true ->
            true;
        false ->
            LongTime = util:longunixtime(),
            CmdLog = get(?CMD_LOG),
            case lists:keytake(Cmd, 1, CmdLog) of
                false ->
                    put(?CMD_LOG, [{Cmd, LongTime} | CmdLog]),
                    true;
                {value, {_, LastTime}, T} ->
                    TimeLimit = LongTime - LastTime,
                    if TimeLimit > 100 ->
                        put(?CMD_LOG, [{Cmd, LongTime} | T]),
                        true;
                        true ->
%%                             ?DEBUG("cmd ~p time ~p limit ~n", [Cmd, TimeLimit]),
                            false
                    end
            end
    end.
%% -------------cast -----------------
handle_cast(stop, State) ->
    {ok, Bin} = pt_100:write(10008, {11, 1}),
    server_send:send_to_sid(State#player.sid, Bin),
    util:sleep(3000),
    {stop, normal, State};

handle_cast({'SOCKET_EVENT', Cmd, RPC_module, Data}, State) ->
%%     io:format("Cmd:~p Data:~p~n", [Cmd, Data]),
%%     ets_cmd(Cmd, Data),
%%     robot_util:clear(Cmd),
    case check_cmd(Cmd) of
        false ->
            {noreply, State};
        true ->
            case catch RPC_module:handle(Cmd, State, Data) of
                {ok, Type, State1} when is_record(State1, player) ->
                    sync_data(Type, State1),
                    {noreply, State1};
                {ok, State1} when is_record(State1, player) ->
                    {noreply, State1};
                ok ->
                    {noreply, State};
                _err ->
                    ?ERR("~p socket event error:~p/~p~n", [State#player.key, Cmd, _err]),
                    {noreply, State}
            end
    end;

%% 跨服深渊击杀其他玩家
handle_cast({cross_dark_bribe_kill_person, AddVal}, State) ->
    cross_dark_bribe:cross_dark_bribe_kill_person(State, AddVal),
    {noreply, State};

%% 跨服深渊击杀怪物
%% 跨服深渊击杀其他玩家
handle_cast({cross_dark_bribe_kill_mon, SceneId, AddVal}, State) ->
    cross_dark_bribe:cross_dark_bribe_kill_mon(State, SceneId, AddVal),
    {noreply, State};

%%
handle_cast(couple_upgrade, State) ->
    Player = baby:couple_upgrade(State),
    Player1 = baby_wing_init:check_upgrade_lv(Player),
    Player2 = baby_mount_init:upgrade_lv(Player1),
    NewPlayer = baby_weapon_init:upgrade_lv(Player2),
    sync_data(attr, NewPlayer),
    {noreply, NewPlayer};

handle_cast(_Request, State) ->
    ?DEBUG("_Request:~p", [_Request]),
    {noreply, State}.

%%数据同步到场景
sync_data(Type, Player) ->
    case Type of
        attr ->
            scene_agent_dispatch:attribute_update(Player);
        guild ->
            scene_agent_dispatch:guild_update(Player);
        war_team ->
            scene_agent_dispatch:war_team_update(Player);
        equip ->
            scene_agent_dispatch:equip_update(Player);
        team ->
            scene_agent_dispatch:team_update(Player);
        pet ->
            scene_agent_dispatch:pet_update(Player);
        pk_val ->
            scene_agent_dispatch:pk_value(Player);
        mount ->
            scene_agent_dispatch:mount_id_update(Player);
        wing ->
            scene_agent_dispatch:wing_update(Player);
        baby_wing ->
            scene_agent_dispatch:baby_wing_update(Player);
        fashion ->
            scene_agent_dispatch:fashion_update(Player);
        light_weapon ->
            scene_agent_dispatch:light_weapon_update(Player);
        pet_weapon ->
            scene_agent_dispatch:pet_weapon_update(Player);
        figure ->
            scene_agent_dispatch:figure(Player);
        convoy ->
            scene_agent_dispatch:convoy(Player);
        buff ->
            scene_agent_dispatch:buff_update(Player);
        designation ->
            scene_agent_dispatch:designation_update(Player);
        evil ->
            scene_agent_dispatch:evil_update(Player);
        speed ->
            scene_agent_dispatch:speed_update(Player);
        vip ->
            scene_agent_dispatch:vip_update(Player);
        halo ->
            scene_agent_dispatch:halo_update(Player);
        scene_face ->
            scene_agent_dispatch:scene_face_update(Player);
        change_name ->
            scene_agent_dispatch:change_name_update(Player);
        sword_pool_figure ->
            scene_agent_dispatch:sword_pool_figure(Player);
        protect ->
            scene_agent_dispatch:protect(Player);
        group ->
            scene_agent_dispatch:group_update(Player);
        footprint ->
            scene_agent_dispatch:footprint_update(Player);
        cat ->
            scene_agent_dispatch:cat_update(Player);
        sex_update ->
            scene_agent_dispatch:sex_update(Player);
        golden_body ->
            scene_agent_dispatch:golden_body_update(Player);
        god_treasure ->
            scene_agent_dispatch:god_treasure_update(Player);
        jade ->
            scene_agent_dispatch:jade_update(Player);
        sit ->
            scene_agent_dispatch:update_sit(Player);
        change_career ->
            scene_agent_dispatch:update_career(Player);
        baby_mount ->
            scene_agent_dispatch:baby_mount_update(Player);
        baby_weapon ->
            scene_agent_dispatch:baby_weapon_update(Player);
        xian_stage ->
            scene_agent_dispatch:xian_stage_update(Player);
        xian_skill ->
            scene_agent_dispatch:xian_skill_update(Player);
        jiandao_stage ->
            scene_agent_dispatch:jiandao_stage_update(Player);
        wear_element_list ->
            scene_agent_dispatch:wear_element_list(Player);
        _ ->
            skip
    end.

%% ---------call ------------
%% 调用函数应返回：ok|{ok,NewPlayer}
%% 调用接口 player:apply_state
handle_call({apply_state, {Module, Function, Args}}, _From, State) ->
    case Module:Function(Args, State) of
        {ok, Reply, NewState} ->
            {reply, Reply, NewState};
        ok ->
            {reply, State};
        _Err ->
            ?ERR("apply unkonw return val ~p~n", [_Err]),
            {noreply, State}
    end;
%% 调用接口 player:apply
handle_call({apply, {Module, Function, Args}}, _From, State) ->
    ?DEBUG("apply ~n"),
    case Module:Function(Args) of
        {ok, Reply} ->
            {reply, Reply, State};
        ok ->
            {reply, State};
        _Err ->
            ?ERR("apply unkonw return val ~p~n", [_Err]),
            {noreply, State}
    end;
handle_call({get_dict, Key}, _From, State) ->
    {reply, {ok, get(Key)}, State};

handle_call({is_black, Key}, _From, State) ->
    {reply, relation:is_my_black(Key), State};

handle_call({put_dict, Key, Val}, _From, State) ->
    {reply, {ok, put(Key, Val)}, State};

handle_call({erase_dict, Key}, _From, State) ->
    {reply, {ok, erase(Key)}, State};

%%获取玩家state
handle_call({get_player}, _From, State) ->
    {reply, {ok, State}, State};

handle_call(stop, _From, State) ->
    player_init:do_stop(State, util:unixtime()),
    {stop, normal, State};

%%获取今日抢劫次数
handle_call({get_rob_times}, _From, State) ->
    Times = task_convoy:get_rob_times(),
    {reply, Times, State};

%%获取玩家好友数量
handle_call({get_friend_count}, _From, State) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Friends = RelationsSt#st_relation.friends,
    Code =
        case length(Friends) >= ?FRIENDS_LIMIT of
            true ->
                false;
            false -> true
        end,
    {reply, Code, State};

%%获取玩家属性
handle_call({get_player_info, Type}, _From, State) ->
    Reply =
        case Type of
            scene -> State#player.scene;
            scene_copy -> [State#player.scene, State#player.copy];
            guildkey -> State#player.guild#st_guild.guild_key;
            lv -> State#player.lv;
            _ -> []
        end,
    {reply, Reply, State};

%% 将角色踢下线(同步操作)
handle_call({stop, _Msg}, _From, State) ->
    {stop, normal, State};

%%获取乱斗次数
handle_call(get_scuffle_times, _FROM, State) ->
    {reply, daily:get_count(?DAILY_CROSS_SCUFFLE_TIMES), State};

handle_call({marry_cost_gold, PriceType, Price}, _From, State) ->
    {Ret, Player} =
        case money:is_enough(State, Price, PriceType) of
            true ->
                P =
                    case PriceType of
                        gold ->
                            money:add_no_bind_gold(State, -Price, 285, 0, 0);
                        _ ->
                            money:add_gold(State, -Price, 285, 0, 0)
                    end,
                {true, P};
            false ->
                {false, State}
        end,
    {reply, Ret, Player};

handle_call({daily_times, Type}, _FROM, State) ->
    {reply, daily:get_count(Type), State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.


%% -----------info -------------
handle_info({send, Bin}, State) ->
    server_send:send_to_sid(State#player.sid, Bin),
    {noreply, State};

%%玩家定时器,每5秒触发一次,
handle_info({timer, Seconds}, State) ->
    NewSeconds = Seconds + 5,
    ?IF_ELSE(State#player.lv < 15, ok, activity:timer_min_notice(State, NewSeconds)),
    Player = player_util:timer(State, NewSeconds),
    erlang:send_after(5000, self(), {timer, NewSeconds}),
    online_time_reward(Player, NewSeconds),
    online_time_notice(Player),
    put(?CMD_LOG, []),
    {noreply, Player};

handle_info(update_ref_43099, State) ->
    util:cancel_ref([State#player.ref_43099]),
    NewRef = erlang:send_after(2000, State#player.pid, timer_notice_43099),
    {noreply, State#player{ref_43099 = NewRef}};

handle_info(timer_notice_43099, State) ->
    util:cancel_ref([State#player.ref_43099]),
    activity:timer_notice(State),
    {noreply, State#player{ref_43099 = null}};

%%玩家数据刷新--零点调用
handle_info({midnight_refresh, NowTime}, State) ->
    %% 每日充值数据重置
    act_charge:midnight_refresh(State),

    %%每日计数清除
    daily:daily_refresh(NowTime),
    %%藏宝图刷新
%%    treasure:refresh_midnight(NowTime),
    %%签到
%%    sign_in_init:update(State),
    %%7天登陆
    day7login_init:update(State),
    %%充值
    charge_init:update(),
    %%累计充值
    acc_charge:midnight_refresh(State),
    %%每日累计充值
    daily_acc_charge:update_daily_acc_charge(State),
    %%单笔充值
    one_charge:update_one_charge(State),
    %%抢购商店
    lim_shop:night_refresh_player(),
    %%新单笔充值
    new_one_charge:update(State),
    %%疯狂点击
%%    crazy_click_init:update(State),
    %%兑换活动
    exchange:update(),
    %%在线时长奖励
    online_time_gift:update(State),
    %%在线奖励
    online_gift:update(State),
    %%物品获得统计
    role_goods_count:player_night_refresh(),
    gold_count:player_night_refresh(),
    %%淘宝每日免费次数刷新
%%     taobao_init:times_reset(State),
    %%原力优惠次数
%%    yuanli_init:update(),
    %%修炼优惠次数
%%    xiulian_init:update(),
    %%宠物光环双倍次数
%%    pet_halo:update(),
    %%好友互赞次数每日刷新
%%     friend_like:times_reset(State),
    %%vip
    vip_init:update_week(),
    %%累充抽奖
    acc_charge_turntable:update(State),
    %%每日首冲返利
    daily_fir_charge_return:update(),
    %%累充礼包
    acc_charge_gift:update(),
    %%累计消费
    acc_consume:update_acc_consume(),
    %%物品兑换
    goods_exchange:update(State),
    role_d_acc_charge:update(State),
    %%连续充值
    con_charge:update(State),
    %%合服签到
    merge_sign_in:update(State),
    %%砸蛋
    open_egg:update(State),
    cross_arena_init:refresh_midnight(NowTime),
    %%掉落活跃
    drop_vitality:update(State),
    %%目标福利
    target_act:update(State),
    %%神秘商店刷新次数更新
%%     random_shop:times_refresh_midnight(State),
    %%剑池
    sword_pool_init:midnight_refresh(State, NowTime),
    %%跨服副本
    cross_dungeon_init:midnight_refresh(NowTime),
    %%跨服副本
    cross_dungeon_guard_init:midnight_refresh(State#player.lv, NowTime),
    %%九霄塔副本
    dungeon_tower:midnight_refresh(NowTime),
    %%签到
    sign_in_init:midnight_refresh(NowTime),
    %%材料副本
    dungeon_material:midnight_refresh(NowTime),
    %%经验副本
    dungeon_exp:midnight_refresh(NowTime),
    %%藏宝阁
    treasure_hourse:midnight_refresh(NowTime),
    %%花千骨每日充值
    hqg_daily_charge:midnight_refresh(NowTime),
    %%开服活动之江湖榜
    open_act_jh_rank:midnight_refresh(NowTime),
    %%开服活动之进阶目标
    open_act_up_target:midnight_refresh(NowTime),
    %%开服活动之进阶目标2
    open_act_up_target2:midnight_refresh(NowTime),
    %%开服活动之进阶目标3
    open_act_up_target3:midnight_refresh(NowTime),
    %%开服活动之累积充值
    open_act_acc_charge:midnight_refresh(NowTime),
    %%开服活动之全服目标
    open_act_all_target:midnight_refresh(NowTime),
    %%开服活动之全服目标2
    open_act_all_target2:midnight_refresh(NowTime),
    %%开服活动之全服目标3
    open_act_all_target3:midnight_refresh(NowTime),
    %%开服活动之全民冲榜
    open_act_all_rank:midnight_refresh(NowTime),
    %%开服活动之全民冲榜2
    open_act_all_rank2:midnight_refresh(NowTime),
    %%开服活动之全民冲榜3
    open_act_all_rank3:midnight_refresh(NowTime),
    %%开服活动之返利抢购
    open_act_back_buy:midnight_refresh(NowTime),
    open_act_other_charge:midnight_refresh(NowTime),
    open_act_super_charge:midnight_refresh(NowTime),
    %%地图寻宝
    act_map:midnight_refresh(NowTime),
    %%进阶宝箱
    uplv_box:midnight_refresh(NowTime),
    %%资源找回
    findback_src:update(State),
    %%1v1
    cross_elite_init:midnight_refresh(NowTime),
    %%消消乐
    cross_eliminate_init:midnight_refresh(NowTime),
    %%水果大作战
    cross_fruit:update(State),
    %%限制抢购
    limit_buy:midnight_refresh(State),
    %%符文寻宝
    fuwen_map:midnight_refresh(State),
    %%剑道寻宝
    jiandao_map:midnight_refresh(State),
    %%符文塔每日奖励
    dungeon_fuwen_tower:midnight_refresh(State),
    %%登陆有礼
    login_online:midnight_refresh(State),
    %%兑换活动
    new_exchange:midnight_refresh(State),
    %%神器副本
    dungeon_god_weapon:midnight_refresh(NowTime),
    %%护送活动
    act_convoy:midnight_refresh(NowTime),
    %%大额累积充值活动
    acc_charge_d:midnight_refresh(NowTime),
    %%消费抽返利
    consume_back_charge:midnight_refresh(NowTime),
    %%守护副本
    dungeon_guard:midnight_refresh(NowTime),
    %%仙境寻宝
    xj_map:midnight_refresh(NowTime),
    %% 连续充值
    act_con_charge:midnight_refresh(State),
    %% 推送消费充值榜状态
    consume_rank:recharge_consume_rank_state(State),
    %% 抽奖转盘
    act_draw_turntable:update(State),
    %% 结婚排行榜
    marry_rank:night_refresh(clean, State),
    %% 爱情试炼副本
    dungeon_marry:midnight_refresh(State),
    %% 爱情香囊
    marry_gift:midnight_refresh(State),
    %% 招财进宝
    act_buy_money:midnight_refresh(NowTime),
    %% 在线有礼
    online_reward:midnight_refresh(NowTime),
    %%合服活动之进阶目标
    merge_act_up_target:midnight_refresh(NowTime),
    %%合服活动之进阶目标2
    merge_act_up_target2:midnight_refresh(NowTime),
    %%合服活动之进阶目标3
    merge_act_up_target3:midnight_refresh(NowTime),
    %%合服活动之返利抢购
    merge_act_back_buy:midnight_refresh(NowTime),
    %%合服活动之累积充值
    merge_act_acc_charge:midnight_refresh(NowTime),
    %%合服活动兑换重置
    merge_exchange:midnight_refresh(NowTime),
    %魔宫
    cross_dark_bribe:midnight_refresh(State, NowTime),
    %% 跨服攻城战
    cross_war:midnight_refresh(NowTime),
    %% 零元礼包更新
    free_gift:init(State),
    %% 新零元礼包更新
    new_free_gift:init(State),
    %% 新招财猫刷新
    act_new_wealth_cat:update(State),
    %% 神秘商城
    mystery_shop:midnight_refresh(State),
    %% 限时礼包
    limit_time_gift:midnight_refresh(State),
    %% 神邸唤神
    act_call_godness:update(),
    %% 神邸限购
    act_godness_limit:midnight_refresh(State),
    %% 跨服boss掉落归属次数重置
    cross_boss:midnight_refresh(State),
    %% 疯狂砸蛋
    act_throw_egg:update(State),
    %% 水果大战
    act_throw_fruit:update(State),
    %% 小额充值活动
    act_small_charge:midnight_refresh(State),
    %% 投资计划
    act_invest:midnight_refresh(),
    %% 单服鲜花榜
    flower_rank_init:update(State#player.key),
    %% 跨服鲜花榜
    cross_flower_init:update(State#player.key),
    %% hi翻天
    act_hi_fan_tian:update(State),
    %% 节日活动之登陆有礼
    festival_login_gift:midnight_refresh(State),
    %% 节日活动之登陆有礼
    festival_acc_charge:midnight_refresh(State),
    %% 节日活动之返利抢购
    festival_back_buy:midnight_refresh(State),
    %% 节日活动之兑换
    festival_exchange:midnight_refresh(State),
    %% 节日活动-在线有礼
    online_reward:update(),
    %% 节日活动之红包雨
    festival_red_gift:midnight_refresh(State),
    %% 节日活动-幸运翻牌
    act_flip_card:update(),
    %% 节日活动-每日任务
    act_daily_task:update(),
    %% 回归活动之兑换
    re_exchange:midnight_refresh(State),

    %% 仙装兑换
    xian_exchange:midnight_refresh(State),
    %% 仙装寻宝12点重置
    xian_map:midnight_refresh(State),
    %% 财神单笔充值
    cs_charge_d:midnight_refresh(State),
    %% 聚宝盆
    act_jbp:midnight_refresh(State),
    %% 红装抢购
    buy_red_equip:update(State),
    %% 限时仙装
    act_limit_xian:midnight_refresh(State),
    %% 限时仙宠
    act_limit_pet:midnight_refresh(State),
    %% 宠物回合战
    pet_war_dun:midnight_refresh(),
    %% 公会对战
    guild_fight:midnight_refresh(),
    %% 集市
    market:midnight_refresh(),
    %% 小额单笔充值
    small_charge_d:midnight_refresh(State),
    %% 跨服1vn商城刷新
    cross_1vn_init:init(State),
    %% 许愿池(单服)
    act_wishing_well:midnight_refresh(State),
    %% 许愿池(跨服)
    cross_act_wishing_well:midnight_refresh(State),
    %% 天宫寻宝
    act_welkin_hunt:update(State),
    %% 跃升冲榜
    act_cbp_rank:update(State),
    %% 奇遇宝箱
    act_meet_limit:update(State),
    %% 回归活动
    NewPlayer0 = return_act:update(State),

    NewPlayer =
        player:apply_chain(NewPlayer0, [
            fun merge_exp_double:update/1
%%            fun monopoly_init:update/1
        ]),
    achieve:trigger_achieve(NewPlayer, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4002, 0, 1),
    dungeon_equip:midnight_refresh(NowTime),
    dungeon_godness:midnight_refresh(NowTime),
    dungeon_elite_boss:midnight_refresh(NowTime),
    dungeon_element:midnight_refresh(),
    dungeon_jiandao:midnight_refresh(),
    scene_agent_dispatch:update_field_boss_times(NewPlayer, 0),
    act_consume_rebate:midnight_refresh(NowTime),
    merge_act_acc_consume:midnight_refresh(NowTime),
    %%TODO 任务刷新放尾部
    task:midnight_refresh(State, NowTime),
    %% 最后刷新
    activity:get_all_act_state(State),
    {noreply, NewPlayer#player{login_days = NewPlayer#player.login_days + 1}};

handle_info(fix_midnight, State) ->
    consume_rank:recharge_consume_rank_state(State),
    activity:get_all_act_state(State),
    NewPlayer =
        player:apply_chain(State, [
            fun merge_exp_double:update/1
        ]),
    {noreply, NewPlayer#player{login_days = max(2, NewPlayer#player.login_days + 1)}};

handle_info({change_scene, Scene, Copy, X, Y, Back}, State) ->
    Player = scene_change:change_scene(State, Scene, Copy, X, Y, Back),
    case dungeon_util:is_dungeon_exp(State#player.scene) of
        true ->
            task_event:event(?TASK_ACT_DUNGEON, {State#player.scene, 1});
        false -> ok
    end,
    ?DO_IF(Scene == ?SCENE_ID_ARENA, dungeon_util:add_dungeon_times(Scene)),
    IsView = ?IF_ELSE(Scene == ?SCENE_ID_ARENA orelse Scene == ?SCENE_ID_CROSS_ARENA, ?VIEW_MODE_HIDE, ?VIEW_MODE_ALL),
    {ok, Bin} = pt_120:write(12043, {?SIGN_PLAYER, Player#player.key, IsView}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {noreply, Player#player{is_view = IsView}};

handle_info(change_scene_back, State) ->
    Player = scene_change:change_scene_back(State),
    {noreply, Player};

handle_info({set_daily, Type, Val}, State) ->
    daily:set_count(Type, Val),
    {noreply, State};


%%进出副本传送用
handle_info({quit_dungeon_scene, DunId, DunCopy, Scene, Copy, X, Y, Group}, State) when Scene /= 0 ->
    if State#player.scene == DunId andalso State#player.copy == DunCopy ->
        NewCopy = scene_copy_proc:get_scene_copy(Scene, Copy),
        ?DEBUG("Scene:~p, X:~p, Y:~p", [Scene, X, Y]),
        Player = scene_change:change_scene(State, Scene, NewCopy, X, Y, false),
        Player1 = Player#player{group = Group},
        scene_agent_dispatch:group_update(Player1),
        IsView = ?IF_ELSE(Scene == ?SCENE_ID_ARENA orelse Scene == ?SCENE_ID_CROSS_ARENA, ?VIEW_MODE_HIDE, ?VIEW_MODE_ALL),
        {ok, Bin} = pt_120:write(12043, {?SIGN_PLAYER, Player#player.key, IsView}),
        server_send:send_to_sid(Player#player.sid, Bin),
        ets:delete(?ETS_DUN_MB_POS, Player#player.key),
        {noreply, Player1#player{is_view = IsView}};
        true ->
            {noreply, State}
    end;

handle_info({enter_dungeon_scene, Scene, _Copy, _X, _Y, _Group}, State) when State#player.scene == Scene ->
    {noreply, State};
handle_info({enter_dungeon_scene, Scene, Copy, X, Y, Group}, State) when Scene /= 0 ->
    Player = scene_change:change_scene(State, Scene, Copy, X, Y, false),
    NewPlayer = player_util:count_player_attribute(Player, true),
    Player1 = NewPlayer#player{group = Group},
    scene_agent_dispatch:group_update(Player1),
    {noreply, Player1};


handle_info({battle_info, Msg}, State) ->
    Player = player_battle:update_battle_info(State#player{sit_state = 0}, Msg),
    ?DO_IF(State#player.sit_state == 1, scene_agent_dispatch:update_sit(Player)),
    {noreply, Player};

handle_info({update_invitation_num, Pkey}, State) ->
    ?DEBUG("update_invitation_num ~n"),
    St = lib_dict:get(?PROC_STATUS_ACT_INVITATION),
    NewSt = St#st_act_invitation{invite_num = St#st_act_invitation.invite_num + 1, key_list = [Pkey | St#st_act_invitation.key_list]},
    lib_dict:put(?PROC_STATUS_ACT_INVITATION, NewSt),
    activity_load:dbup_player_invite_code(NewSt),
    {noreply, State};

handle_info({battle_die, Msg}, State) ->
    Player =
        ?IF_ELSE(State#player.hp > 0, player_battle:update_battle_die(State, Msg), State),
    {noreply, Player};

handle_info({task_add_exp, Num, AddReason}, State) ->
    NewPlayer = player_util:add_exp(State, Num, AddReason),
    {noreply, NewPlayer};

handle_info({add_exp, Num, AddReason}, State) ->
    NewPlayer = player_util:add_exp(State, Num, AddReason),
    {noreply, NewPlayer};

handle_info({enter_team, Team}, State) ->
    NewPlayer = team_util:enter_team(State, Team),
    scene_agent_dispatch:team_update(NewPlayer),
    {noreply, NewPlayer};

handle_info({check_team}, State) ->
    NewPlayer =
        if State#player.team_key == 0 -> team_util:create_team(State);
            true -> State
        end,
    scene_agent_dispatch:team_update(NewPlayer),
    {noreply, NewPlayer};

handle_info({add_exp_extra, Num, AddReason, AddTypeList}, State) ->
    NewPlayer = player_util:add_exp(State, Num, AddReason, AddTypeList),
    {noreply, NewPlayer};

handle_info({add_coin, Num, AddReason}, State) ->
    NewPlayer = money:add_coin(State, Num, AddReason, 0, 0),
    {noreply, NewPlayer};

handle_info({kill_mon_exp, Mid, Mlv, Percent}, State) ->
    NewPlayer = player_battle:kill_mon_exp(State, Mid, Mlv, Percent),
    {noreply, NewPlayer};

handle_info({cross_war_kill_mon_exp, Mid, Percent}, State) ->
    NewPlayer = player_battle:kill_mon_exp(State, Mid, State#player.lv, Percent),
    {noreply, NewPlayer};

%%handle_info({add_bcoin, Num, AddReason}, State) ->
%%    NewPlayer = money:add_coin(State, Num, AddReason),
%%    {noreply, NewPlayer};

handle_info({add_bgold, Num, AddReason}, State) ->
    NewPlayer = money:add_bind_gold(State, Num, AddReason, 0, 0),
    {noreply, NewPlayer};

handle_info({drop, DropRuleList, DropInfo}, State) ->
    case scene:is_normal_scene(State#player.scene) orelse scene:is_cross_dark_blibe(State#player.scene) of
        true ->
            CurDrop = daily:get_count(?DAILY_DROP_LIMIT),
            Limit = data_drop_limit:get(State#player.lv),
            IsFestiveBoss = act_festive_boss:is_act_festive_boss(DropInfo#drop_info.mon#drop_mon_info.mon_id),
            %%掉落限制
            if
                CurDrop >= Limit andalso not IsFestiveBoss andalso
                    DropInfo#drop_info.mon#drop_mon_info.mon_kind /= ?MON_KIND_GRACE_COLLECT ->
                    {noreply, State};
                true ->
                    Career = State#player.career,
                    Lv = State#player.lv,
                    Player2 = drop:drop(State, DropRuleList, 0, DropInfo#drop_info{lvdown = Lv, lvup = Lv, career = Career}),
                    {noreply, Player2}
            end;
        false ->
            Career = State#player.career,
            Lv = State#player.lv,
            Player2 = drop:drop(State, DropRuleList, 0, DropInfo#drop_info{lvdown = Lv, lvup = Lv, career = Career}),
            {noreply, Player2}
    end;



handle_info({insert_mail, Mail}, State) ->
    mail:add_dict_mail(Mail),
%%      tips:send_tips(State, 13),
    %% 推送奖励通知
    activity:get_notice(State, [73], true),
    {noreply, State};

handle_info(reload_mail, State) ->
    mail_init:init(State),
%%     tips:send_tips(State, 13),
    activity:get_notice(State, [73], true),
    {noreply, State};

%%设置减速效果标记
handle_info({set_speed_eff, Key}, State) ->
    put(speed_eff, Key),
    {noreply, State};

%%取消减速
handle_info({cancel_speed_eff, _Key}, State) ->
    case get(speed_eff) of
        undefined ->
            {noreply, State};
        _OldKey ->
            handle_info({speed_reset, true}, State)
    end;

%%恢复速度
handle_info({speed_reset, Notice}, State) ->
    erlang:erase(speed_eff),
    Player2 = player_util:count_player_speed(State, Notice),
    {noreply, Player2};

%%血量变化
handle_info({hp, Hp, _AddHp}, State) ->
    AccDamage = ?IF_ELSE(_AddHp > 0, State#player.acc_damage, State#player.acc_damage + abs(_AddHp)),
    {noreply, State#player{hp = Hp, acc_damage = AccDamage}};

%%好友请求
handle_info({add_friend_request, ReqData}, State) ->
    relation:handle_add_friend_request(State, ReqData),
    {noreply, State};

%%被删除好友
handle_info({del_frined_inform, [Pkey]}, State) ->
    relation:del_friend_help(Pkey),
    relation:update_relation_list(State, 1),
    {noreply, State};

%%添加进最近联系人
handle_info({put_recently_contacts, [Player]}, State) ->
    relation:put_recently_contacts(Player),
    {noreply, State};

%%好友确认
handle_info({add_frined_cofirm, ConfirmData, Key, NickName}, State) ->
    relation:handle_add_friend_confirm(State, ConfirmData),
    relation:send_chat(State, State#player.lv, Key, NickName),
    {noreply, State};

%%战队精英赛采集奖励
handle_info({cross_scuffle_elite_party_collect, FightNum}, State) ->
    Reward = data_cross_scuffle_elite_party_collect:get(State#player.lv, FightNum),
    {ok, NewState} = goods:give_goods(State, goods:make_give_goods_list(316, Reward)),
    {noreply, NewState};

%% 进攻成功，增加cd
handle_info(cross_mine_add_att_cd, State) ->
    {Index, _FreeEndTime} = daily:get_count(?DAILY_CROSS_MINE_ATT, {0, 0}),
    Next = data_mining_cd:get(Index + 1),
    daily:set_count(?DAILY_CROSS_MINE_ATT, {Index + 1, Next + util:unixtime()}),
    {noreply, State};

handle_info({guild_chat, Pkey, Bin}, State) ->
    case relation:is_my_black(Pkey) of
        true -> skip;
        false ->
            server_send:send_to_sid(State#player.sid, Bin)
    end,
    {noreply, State};

%% 强制GC
handle_info(gc, State) ->
    garbage_collect(),
    erlang:send_after(180000, self(), gc),
    {noreply, State};

%%仙盟数据更新
handle_info({update_guild, [GuildKey, GuildName, Position]}, State) ->
    StGuild = #st_guild{guild_key = GuildKey, guild_name = GuildName, guild_position = Position},
    if State#player.guild#st_guild.guild_key == GuildKey ->
        NewPlayer = State#player{guild = StGuild};
        true ->
            if GuildKey == 0 ->
                guild_skill:reset_guild_kill_attribute(),
                Player1 = State#player{guild = StGuild},
                guild_scene:quit_guild_scene(Player1),
                task_guild:quit_guild(Player1);
                true ->
                    task_guild:enter_guild(State),
                    guild_skill:load_player_guild_skill(State#player.lv, GuildKey),
                    achieve:trigger_achieve(State, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4008, 0, 1),
                    Player1 = State#player{guild = StGuild}
            end,
            NewPlayer = player_util:count_player_attribute(Player1, true)
    end,
    scene_agent_dispatch:guild_update(NewPlayer),
    {noreply, NewPlayer};


%%战队数据更新
handle_info({update_war_team, [WarTeamKey, WarTeamName, Position]}, State) ->
    StWarTeam = #st_war_team{war_team_key = WarTeamKey, war_team_name = WarTeamName, war_team_position = Position},
    if State#player.war_team#st_war_team.war_team_key == WarTeamKey ->
        NewPlayer = State#player{war_team = StWarTeam};
        true ->
            Player1 = State#player{war_team = StWarTeam},
            NewPlayer = player_util:count_player_attribute(Player1, true)
    end,
    scene_agent_dispatch:war_team_update(NewPlayer),
    {noreply, NewPlayer};

%%战队数据更新
handle_info({cross_scuffle_elite, [CrossScuffleEliteInfo]}, State) ->
    {noreply, State#player{cross_scuffle_elite = CrossScuffleEliteInfo}};

handle_info({task_event_collect, [Mid]}, State) ->
    case is_pid(State#player.team) of
        false ->
            task_event:event(?TASK_ACT_COLLECT, Mid);
        true ->
            task_event:event(?TASK_ACT_COLLECT, Mid),
            State#player.team ! {task_event_collect, [Mid, State#player.key]}
    end,
    {noreply, State};

%%触发任务事件
handle_info({task_event, [Act, ParamList]}, State) ->
    task_event:event(Act, ParamList),
    {noreply, State};

%%杀人任务
handle_info({task_kmb, Sn}, State) ->
    task_kill:task_kmb(State, Sn),
    {noreply, State};

%%删除任务
handle_info({delete_task, TaskId}, State) ->
    task_init:delete_task(State#player.sid, TaskId),
    {noreply, State};

%%任务预完成处理
handle_info({preact_finish, Task}, State) ->
    task_event:preact_finish(Task, State),
    {noreply, State};

handle_info(cmd_refresh_task, State) ->
    F = fun(_) ->
        task_event:event(?TASK_ACT_COLLECT, 12203)
        end,
    lists:foreach(F, lists:seq(1, 3)),
    {noreply, State};

%%%%护送完成
%%handle_info({finish_convoy},State)->
%%    Player = State#player{convoy_state = 0,show_convoy = 0},
%%    Player1 = player_util:count_player_speed(Player,true),
%%    scene_agent_dispatch:convoy(Player1),
%%    {noreply,Player1};

handle_info(convoy_timeout, State) ->
    Player = task_convoy:convoy_timeout(State),
    {noreply, Player};

%%护送抢夺奖励
handle_info({convoy_rob_reward, GoodsList, Nickname}, State) ->
    Player = task_convoy:convoy_rob_reward(State, GoodsList, Nickname),
    {noreply, Player};

%%协助记录
handle_info({convoy_helping, Pkey}, State) ->
    task_convoy:convoy_helping(State, Pkey),
    {noreply, State};

%%护送帮助奖励
handle_info(convoy_help_reward, State) ->
    Player = task_convoy:convoy_help_reward(State),
    {noreply, Player};


%%材料副本挑战结果
handle_info({dungeon_material_ret, DungeonId, IsPass}, State) ->
    NewPlayer = dungeon_material:dungeon_material_ret(IsPass, State, DungeonId),
    {noreply, NewPlayer};

%%vip副本挑战结果
handle_info({dungeon_vip_ret, DungeonId, IsPass}, State) ->
    NewPlayer = dungeon_vip:dungeon_vip_ret(IsPass, State, DungeonId),
    {noreply, NewPlayer};

%%仙装副本挑战结果
handle_info({dun_xian_ret, DungeonId, IsPass}, State) ->
    NewPlayer = dungeon_xian:dungeon_xian_ret(IsPass, State, DungeonId),
    {noreply, NewPlayer};

%%神祇副本挑战结果
handle_info({dun_godness_ret, DungeonId, IsPass}, State) ->
    NewPlayer = dungeon_godness:dungeon_godness_ret(IsPass, State, DungeonId),
    {noreply, NewPlayer};

%%神祇副本挑战结果
handle_info({dun_element_ret, DungeonId, IsPass}, State) ->
    NewPlayer = dungeon_element:dungeon_element_ret(IsPass, State, DungeonId),
    {noreply, NewPlayer};

handle_info({dun_jiandao_ret, DungeonId, Score, Mult}, State) ->
    NewPlayer = dungeon_jiandao:dun_jiandao_ret(State, DungeonId, Score, Mult),
    {noreply, NewPlayer};

%%精英boss副本挑战结果
handle_info({dun_elite_boss_ret, DungeonId, IsPass}, State) ->
    NewPlayer = dungeon_elite_boss:dun_elite_boss_ret(IsPass, State, DungeonId),
    {noreply, NewPlayer};

%%转职副本挑战结果
handle_info({dungeon_change_career_ret, DungeonId, IsPass}, State) ->
    NewPlayer = dungeon_change_career:dungeon_change_career_ret(IsPass, State, DungeonId),
    {noreply, NewPlayer};

%%九霄塔挑战结算
handle_info({dun_tower_ret, DunId, IsPass, UseTime}, State) ->
    Player = dungeon_tower:dun_tower_ret(IsPass, State, DunId, UseTime),
    {noreply, Player};

handle_info({dun_equip_ret, DunId, IsPass}, State) ->
    Player = dungeon_equip:dun_equip_ret(IsPass, State, DunId),
    {noreply, Player};

%%经验副本通关
handle_info({update_dun_exp_round, Round, PassGoodsList, FirstGoodsList}, State) ->
    Player = dungeon_exp:update_dun_exp_round(State, Round, PassGoodsList, FirstGoodsList),
    {noreply, Player};

%%经验副本结算
handle_info({dungeon_exp_ret, DunId, Round, GoodsList}, State) ->
    dungeon_exp:dungeon_exp_ret(State, DunId, Round, GoodsList),
    {noreply, State};

%%每日副本结算
handle_info({dun_daily_ret, DunId, Ret}, State) ->
    Player = dungeon_daily:dun_daily_ret(Ret, State, DunId),
    {noreply, Player};

%%帮派妖魔入侵副本结算
handle_info({dungeon_guild_demon_ret, Ret, GoodsList, Round}, State) ->
    NewPlayer = guild_demon:dungeon_ret(State, Ret, GoodsList, Round),
    {noreply, NewPlayer};

handle_info({dungeon_fuwen_tower_ret, DunId, Ret}, State) ->
    Player = dungeon_fuwen_tower:dun_ret(DunId, Ret, State),
    {noreply, Player};

%%更新神器副本波数
handle_info({update_dun_god_weapon_layer, DunId, Round, GoodsList}, State) ->
    Player = dungeon_god_weapon:update_dun_god_weapon_layer(State, DunId, Round, GoodsList),
    {noreply, Player};

handle_info({dungeon_god_weapon_ret, DunId, Round, GoodsList}, State) ->
    dungeon_god_weapon:dungeon_god_weapon_ret(State, DunId, Round, GoodsList),
    {noreply, State};

handle_info({update_guard_pass_wave, MinFloor, PassFloor, StartFloor}, State) ->
    NewPlayer = dungeon_guard:update_dun_guard_wave(State, MinFloor, PassFloor, StartFloor),
    {noreply, NewPlayer};

handle_info({guard_notice, Floor}, State) ->
    dungeon_guard:guard_notice(State#player.sid, Floor),
    {noreply, State};

%%守护副本挑战结果
handle_info({dun_guard_ret, IsPass, PassFloor, _GoodsList}, State) ->
    NewPlayer = dungeon_guard:dun_guard_ret(State, IsPass, PassFloor),
    {noreply, NewPlayer};

handle_info({dungeon_marry_ret, _DunId, Ret, CollectList, DunProblem}, State) ->
    ?DEBUG("_DunId:~p, Ret:~p, CollectList:~p, DunProblem:~p", [_DunId, Ret, CollectList, DunProblem]),
    NewPlayer = dungeon_marry:dun_ret(State, Ret, CollectList, DunProblem),
    {noreply, NewPlayer};

handle_info({dun_elite_boss, Consume, CostGold, DunId}, State) ->
    NewPlayer = dungeon_elite_boss:consume(State, Consume, CostGold, DunId),
    {noreply, NewPlayer};

handle_info({guild_fight_challenge_ret, _AttPkey, _AttName, DefPkey, _DefName, Ret}, State) ->
    guild_fight:guild_fight_challenge_player_ret(State, _AttName, DefPkey, _DefName, Ret),
    {noreply, State};

handle_info({add_fail_medal, _AttName, AddMedal, AttPkey}, State) ->
    guild_fight:add_fail_medal(State, _AttName, AddMedal, AttPkey),
    {noreply, State};

handle_info(clean_elite_dun_goods, State) ->
    dungeon_elite_boss:clean_elite_dun_goods(State),
    {noreply, State};

%%异步加亲密度
handle_info({add_qinmidu, Pkey, AddValue}, State) ->
    ?DEBUG("qinmidu AddValue ~p~n", [AddValue]),
    case AddValue of
        {no_db, AddValue0} ->
            flower_rank:update_get(AddValue0),
            cross_flower:update_get(State, AddValue0);
        AddValue when is_integer(AddValue) ->
            flower_rank:update_get(AddValue),
            cross_flower:update_get(State, AddValue);
        _ -> ok
    end,
    relation:add_qinmidu({Pkey, AddValue}, State),
    {noreply, State};

%%异步加亲密度
handle_info({add_qinmidu, Id, Pkey, AddValue}, State) ->
    relation:add_qinmidu({Id, Pkey, AddValue}, State),
    {noreply, State};

%%更新试炼副本
handle_info({update_milestone, DunId, Floor, NewTime}, State) ->
    ?DEBUG("update_milestone ~n"),
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    NewMilestoneList =
        case lists:keytake({DunId, Floor}, 1, St#st_cross_dun_guard.milestone_list) of
            false ->
                [{{DunId, Floor}, 0, NewTime} | St#st_cross_dun_guard.milestone_list];
            {value, {{DunId, Floor}, State0, OldTime}, List} ->
                if
                    OldTime >= NewTime ->
                        [{{DunId, Floor}, State0, NewTime} | List];
                    true ->
                        [{{DunId, Floor}, State0, OldTime} | List]
                end
        end,
    NewSt = St#st_cross_dun_guard{milestone_list = NewMilestoneList, is_change = 1},
    lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, NewSt),
    cross_dungeon_guard_util:log_cross_dungeon_guard(State#player.key, State#player.nickname, DunId, Floor, NewTime),
    {noreply, State};


%%异步加甜蜜值
handle_info({add_sweet, Sweet}, State) ->
    Player = money:add_sweet(State, Sweet),
    {noreply, Player};

%%跨服副本触发亲密度增加
handle_info({cross_dungeon_add_qinmidu, PlayerKeyList}, State) ->
    Base = data_qinmidu_args:get(1),
    F = fun(Pkey) ->
        relation:add_qinmidu({1, Pkey, Base#qinmidu.value}, State),
        case ets:lookup(?ETS_ONLINE, Pkey) of
            [] -> ok;
            [Online] ->
                Online#ets_online.pid ! {add_qinmidu, 1, State#player.key, {no_db, Base#qinmidu.value}}
        end
        end,
    lists:foreach(F, PlayerKeyList),
    {noreply, State};

%%跨服消消乐触发亲密度增加
handle_info({cross_eliminate_add_qinmidu, Pkey}, State) ->
    Base = data_qinmidu_args:get(0),
    relation:add_qinmidu({0, Pkey, Base#qinmidu.value}, State),
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] -> ok;
        [Online] ->
            Online#ets_online.pid ! {add_qinmidu, 0, State#player.key, {no_db, Base#qinmidu.value}}
    end,
    {noreply, State};

%%收到赠送时装
handle_info({present_fashion, Pkey, Avatar, Nickname, Sex, GoodsId, Content}, State) ->
    {ok, Bin} = pt_330:write(33008, {Pkey, Nickname, Sex, Avatar, GoodsId, Content}),
    server_send:send_to_sid(State#player.sid, Bin),
    {ok, Player} = goods:give_goods(State, goods:make_give_goods_list(278, [{GoodsId, 1}])),

    {noreply, Player};

%%异步给物品
handle_info({give_goods, GoodsList, Reason}, State) ->
    {ok, Player} = goods:give_goods(State, goods:make_give_goods_list(Reason, GoodsList)),
    {noreply, Player};

%% 协助成功
handle_info({update_cross_help_att, Att0, Help0}, State) ->
    {AttCount, HelpCount, _ResetCount} = daily:get_count(?DAILY_CROSS_MINE_HELP, {0, 0, 0}),
    daily:set_count(?DAILY_CROSS_MINE_HELP, {AttCount + Att0, HelpCount + Help0, _ResetCount}),
    {noreply, State};

%%公会宝箱协助成功
handle_info({help_box, GoodsList}, State) ->
    daily:increment(?DAILY_GUILD_HELP, 1),
    St = lib_dict:get(?PROC_STATUS_GUILD_BOX),
    Now = util:unixtime(),
    NewHelpCd = ?IF_ELSE(St#player_guild_box.help_cd < Now, Now + ?GUILD_BOX_HELP_BOX_CD, St#player_guild_box.help_cd + ?GUILD_BOX_HELP_BOX_CD),
    IsHelpCd = ?IF_ELSE(NewHelpCd - Now >= ?GUILD_BOX_HELP_BOX_IN_CD, 1, St#player_guild_box.is_help_cd),
    NewSt = St#player_guild_box{
        help_cd = NewHelpCd,
        is_help_cd = IsHelpCd
    },
    lib_dict:put(?PROC_STATUS_GUILD_BOX, NewSt),
    guild_box_load:update_player_data(NewSt),
    {ok, Player} = goods:give_goods(State, goods:make_give_goods_list(311, GoodsList)),
    {noreply, Player};

%%异步给物品
handle_info({use_goods_by_goods_id, GoodsId, Num}, State) ->
    ?DEBUG("GoodsId ~p~n", [GoodsId]),
    ?DEBUG("Num ~p~n", [Num]),
    case catch goods_use:use_goods_by_goods_id(State, GoodsId, Num) of
        {ok, NewPlayer} ->
            Player = NewPlayer;
        {false, _Res} ->
            Player = State
    end,
    {noreply, Player};

%%副本捡取
handle_info({dungeon_pickup, GoodsList}, State) ->
    {ok, Player} = goods:give_goods(State, goods:make_give_goods_list(83, GoodsList)),
    {noreply, Player};

%%更新队伍数据
handle_info({update_team, TeamKey, TeamPid, TeamLeader}, State) ->
    NewState = State#player{team = TeamPid, team_key = TeamKey, team_leader = TeamLeader},
    scene_agent_dispatch:team_update(NewState),
    {noreply, NewState};

%%更新多倍经验信息
handle_info({update_more_exp_info, ActState, Reward, EndTime}, State) ->
    MoreExp = #more_exp{state = ActState, reward = Reward, end_time = EndTime},
    lib_dict:put(?PROC_STATUS_MORE_EXP, MoreExp),
    {noreply, State};


%%组队人数变更
handle_info({update_team_num, TeamNum}, State) ->
    NewState = State#player{team_num = TeamNum},
    {noreply, NewState};

%%好友申请返回
handle_info({friend_return, Player, Code}, State) ->
    {ok, Bin} = pt_240:write(24023, {Code, Player#player.nickname}),
    server_send:send_to_sid(State#player.sid, Bin),
    relation:update_relation_list(State, 1),
    {noreply, State};

%%发送消费排行榜信息
handle_info({consume_rank_send, List, MyVal}, State) ->
    case consume_rank:get_act() of
        [] -> skip;
        Base ->
            {Rank, RankList} = consume_rank:make_to_client(State#player.key, consume_rank:sort_rank_list_limit(List, Base)),
            LeaveTime = activity:get_leave_time(data_consume_rank),
            Reward = consume_rank:get_reward_list(),
            {ok, Bin} = pt_432:write(43283, {LeaveTime, MyVal, Rank, lists:sublist(RankList, 50), Reward}),
            server_send:send_to_sid(State#player.sid, Bin)
    end,
    {noreply, State};

%%发送充值排行榜信息
handle_info({recharge_rank_send, RechargeRankList, MyRecharge}, State) ->
    case recharge_rank:get_act() of
        [] -> skip;
        Base ->
            {Rank, RankList} = recharge_rank:make_to_client(State#player.key, recharge_rank:sort_rank_list_limit(RechargeRankList, Base)),
            LeaveTime = activity:get_leave_time(data_recharge_rank),
            Reward = recharge_rank:get_reward_list(),
            {ok, Bin} = pt_432:write(43284, {LeaveTime, MyRecharge, Rank, lists:sublist(RankList, 50), Reward}),
            server_send:send_to_sid(State#player.sid, Bin)
    end,
    {noreply, State};

%%发送鲜花排行榜信息
handle_info({flower_rank_send, GiveList, GetList}, State) ->
    {Give, GiveRank, GiveList1} = flower_rank_handle:give_info(State#player.key, GiveList),
    {Get, GetRank, GetList1} = flower_rank_handle:get_info(State#player.key, GetList),
    LeaveTime = flower_rank:get_leave_time(),
    GetReward = flower_rank:get_reward_list(),
    GiveReward = flower_rank:give_reward_list(),
    LimitList = flower_rank:get_limit_all(),
    {ok, Bin} = pt_603:write(60300, {LeaveTime, Give, GiveRank, GiveList1, GiveReward, Get, GetRank, GetList1, GetReward, LimitList, LimitList}),
    server_send:send_to_sid(State#player.sid, Bin),
    {noreply, State};


%%发送结婚排行榜信息
handle_info({marry_rank_send, Rank, RankList, ReceiveState}, State) ->
    LeaveTime = activity:get_leave_time(data_marry_rank),
    RewardList =
        case marry_rank:get_act() of
            [] -> [];
            Base ->
                [tuple_to_list(X) || X <- Base#base_marry_rank.reward_list]
        end,
    {ok, Bin} = pt_288:write(28850, {LeaveTime, Rank, ReceiveState, RankList, RewardList}),
    server_send:send_to_sid(State#player.sid, Bin),
    {noreply, State};


%% %%发送跨服消费排行榜信息
%% handle_info({cross_consume_rank_send, LeaveTime, MyRecharge, Rank, RankList, Reward}, State) ->
%%     {ok, Bin} = pt_432:write(43285, {LeaveTime, MyRecharge, Rank, RankList, Reward}),
%%     server_send:send_to_sid(State#player.sid, Bin),
%%     {noreply, State};
%%
%% %%发送跨服充值排行榜信息
%% handle_info({cross_recharge_rank_send, LeaveTime, MyRecharge, Rank, RankList, Reward}, State) ->
%%     {ok, Bin} = pt_432:write(43286, {LeaveTime, MyRecharge, Rank, RankList, Reward}),
%%     server_send:send_to_sid(State#player.sid, Bin),
%%     {noreply, State};

%%竞技场挑战奖励
handle_info({arena_reward, Ret, GoodsList, Rank, _Wins, Combo, Score}, State) ->
    {ok, NewPlayer} = goods:give_goods(State, goods:make_give_goods_list(14, GoodsList)),
    ?DO_IF(Rank /= 0, achieve:trigger_achieve(State, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3001, 0, Rank)),
    ?DO_IF(Ret == 1, achieve:trigger_achieve(State, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3002, 0, 1)),
    ?DO_IF(Combo > 0, achieve:trigger_achieve(State, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3003, 0, Combo)),
    ?DO_IF(Ret == 1, sword_pool:add_exp_by_type(State#player.lv, ?SWORD_POOL_TYPE_ARENA)),
    arena_score:update_arena_score(Score),
    activity:get_notice(State, [105, 106], true),
    {noreply, NewPlayer};

%%%%宠物出战
%%handle_info({fight_pet, PetKey}, State) ->
%%    case pet_rpc:handle(50002, State, {PetKey}) of
%%        {ok, _pet, NewPlayer} ->
%%            sync_data(pet, NewPlayer),
%%            {noreply, NewPlayer};
%%        _ ->
%%            {noreply, State}
%%    end;

%%宠物属性改变，同步场景
handle_info(pet_sync_scene, State) ->
    sync_data(pet, State),
    {noreply, State};

%%%%宠物升级同步
%%handle_info(pet_lv_up, State) ->
%%    NewPlayer = pet:pet_lv_up(State),
%%    {noreply, NewPlayer};

%%掉落活跃度触发
handle_info({d_v_trigger, Type, Args}, State) ->
    NewPlayer = drop_vitality:d_trigger(State, Type, Args),
    {noreply, NewPlayer};

%%升级触发红点
handle_info({activity_lv_notice}, Player) ->
    activity:get_notice(Player, [144, 147], true),
    ?IF_ELSE(Player#player.lv == 20, spawn(fun() -> create_role_mail(Player#player.key) end), ok),
%% 副本相关
    ?IF_ELSE(Player#player.lv >= 10, activity:get_notice(Player, [97, 99, 100, 101, 102, 115], true), ok),
%% 开服活动
    ?IF_ELSE(Player#player.lv == 10 orelse Player#player.lv == 11 orelse Player#player.lv >= 30, activity:get_notice(Player, [33], true), ok),
%% 进阶宝箱
    ?IF_ELSE(Player#player.lv == 48, activity:get_notice(Player, [35], true), ok),
%% 符文寻宝
    ?IF_ELSE(Player#player.lv == 46, activity:get_notice(Player, [38], true), ok),
    {noreply, Player};

%%大富翁任务触发
handle_info({m_task_trigger, Id, Times}, State) ->
    monopoly_task:trigger_m_task(State, Id, Times),
    {noreply, State};

%%通过副本
handle_info({succeed_pass_dungeon, DunType, [DunId]}, State) ->
    case DunType of
        ?DUNGEON_TYPE_EXP -> %%经验副本
%%            act_hi_fan_tian:trigger_finish_api(State,3,1),
            {noreply, State};
        ?DUNGEON_TYPE_TOWER -> %%九霄塔
            {noreply, State};
        ?DUNGEON_TYPE_DAILY -> %%
            act_hi_fan_tian:trigger_finish_api(State, 2, 1),
            {noreply, State};
        ?DUNGEON_TYPE_MATERIAL -> %%材料副本
            act_hi_fan_tian:trigger_finish_api(State, 1, 1),
            case DunId of
                50001 -> %%坐骑副本
                    findback_src:fb_trigger_src(State, 1, 1),
                    ok;
                50002 -> %%仙羽副本
                    findback_src:fb_trigger_src(State, 2, 1),
                    ok;
                50003 -> %%法器副本
                    findback_src:fb_trigger_src(State, 3, 1),
                    ok;
                50004 -> %%神兵副本
                    findback_src:fb_trigger_src(State, 4, 1),
                    ok;
                50005 -> %%宠物副本
                    findback_src:fb_trigger_src(State, 5, 1),
                    ok;
                50006 -> %%妖灵副本
                    findback_src:fb_trigger_src(State, 6, 1),
                    ok;
                50007 -> %%足迹副本
                    findback_src:fb_trigger_src(State, 7, 1),
                    ok;
                50008 -> %%灵猫副本
                    findback_src:fb_trigger_src(State, 8, 1),
                    ok;
                50009 -> %%法身副本
                    findback_src:fb_trigger_src(State, 9, 1),
                    ok;
                50010 -> %%天罡副本
                    findback_src:fb_trigger_src(State, 10, 1),
                    ok;
                50011 ->%%灵羽副本
                    findback_src:fb_trigger_src(State, 41, 1),
                    ok;
                50012 ->%%灵骑副本
                    findback_src:fb_trigger_src(State, 42, 1),
                    ok;
                50013 ->%%灵弓副本
                    findback_src:fb_trigger_src(State, 43, 1),
                    ok;
                50015 ->%%仙宝副本
                    findback_src:fb_trigger_src(State, 45, 1),
                    ok;
                50014 ->%%灵佩副本
                    findback_src:fb_trigger_src(State, 46, 1),
                    ok;
                _ -> skip
            end,
            {noreply, State};
        _ ->
            {noreply, State}
    end;


%%充值通知
handle_info('recharge_notice', State) ->
    State2 = recharge:update(State),
    {noreply, State2};

%%充值完成 每充值完成一单，都会触发这里
handle_info({recharge_gift, BaseGetGold}, State) ->
    Player = vip:add_vip_exp(State, BaseGetGold),
    {noreply, Player};
handle_info({recharge, TotalFee, BaseGetGold, _FinalGetGold}, State) ->
%%兑换成充值额度 基本元宝数
    ChargeVal = BaseGetGold,
%%兑换成充值货币数
    ChargePrice = round(TotalFee / 100),

%%需要更新玩家state的都统一在这里处理
    FunList = [
        {vip, add_vip_exp, ChargeVal},  %%vip
        {red_bag, charge_add_red_bag, ChargeVal}  %%充值红包
    ],
    F = fun({Mod, Fun, Args}, AccPlayer) ->
        case catch Mod:Fun(AccPlayer, Args) of
            NewPlayer when is_record(NewPlayer, player) ->
                NewPlayer;
            _Err ->
                ?ERR("recharge finish, update player activity err ~p~n", [_Err]),
                AccPlayer
        end
        end,
    Player1 = lists:foldl(F, State, FunList),
%%增加每日充值数据
    act_charge:add_charge(ChargeVal),
%%角色每日累充
    role_d_acc_charge:add_charge_val(Player1, ChargeVal),  %%注意这个活动需要放在首冲前
%%首冲
    first_charge:update_charge(State),
%%每日充值
    daily_charge:update_charge(),
%%累计充值
    acc_charge:add_charge_val(Player1, ChargeVal),
%%连续充值
    act_con_charge:add_charge_val(Player1, ChargeVal),
%%每日累计充值
    daily_acc_charge:add_charge_val(Player1, ChargeVal),
%%单笔充值
    one_charge:add_charge_val(Player1, ChargeVal),
%%新每日充值
    new_daily_charge:update_charge(),
%%新单笔充值
    new_one_charge:update_charge_val(Player1, ChargePrice),
%%累充转盘
    acc_charge_turntable:add_charge_val(Player1, ChargeVal),
%%首冲返利
    daily_fir_charge_return:add_charge_val(Player1, ChargeVal, ChargePrice),
%%累充礼包
    acc_charge_gift:add_charge_val(Player1, ChargeVal),
%%连续充值
    con_charge:add_charge(Player1, ChargeVal),
%%砸蛋
    open_egg:add_charge(Player1, ChargeVal),
%%合服签到
    merge_sign_in:add_charge(Player1, ChargeVal),
%%藏宝阁
    treasure_hourse:add_charge(Player1, ChargeVal),
%%花千骨每日充值
    hqg_daily_charge:add_charge(Player1, ChargeVal),
%%开服活动之团购首充
    open_act_group_charge:add_charge(Player1, ChargeVal),
%%开服活动之累积充值
    open_act_acc_charge:add_charge(Player1, ChargeVal),
%%登陆有礼
    login_online:add_charge(Player1, ChargeVal),
%%大额累积充值
    acc_charge_d:add_charge_val(Player1, ChargeVal),
%%消费充返利
    consume_back_charge:get_reward(Player1, ChargeVal),
%%单服充值活动
    recharge_rank:add_recharge_val(Player1, ChargeVal),
%%跨服充值活动
    cross_recharge_rank:add_recharge_val(Player1, ChargeVal),
%%区域跨服充值排行榜
    area_recharge_rank:add_recharge_val(Player1, ChargeVal),
%%合服活动之团购首充
    merge_act_group_charge:add_charge(Player1, ChargeVal),
%%合服活动之累积充值
    merge_act_acc_charge:add_charge(Player1, ChargeVal),
%%小额充值活动
    act_small_charge:add_charge(Player1, ChargeVal),
%%节日活动之登陆有礼
    festival_login_gift:add_charge(ChargeVal),
%%节日活动之累积充值
    festival_acc_charge:add_charge(Player1, ChargeVal),
%%节日活动之红包雨
    festival_red_gift:add_charge(ChargeVal),
%%每日充值活动
    recharge_inf:add_recharge(Player1, ChargeVal),
%%回归每日充值活动
    re_recharge_inf:add_recharge(Player1, ChargeVal),
%%双倍充值活动
    double_gold:add_recharge(Player1, ChargeVal),
%%双倍充值活动
    new_double_gold:add_recharge(Player1, ChargeVal),
%%额外特惠活动
    open_act_other_charge:add_charge(Player1, ChargeVal),
%%超值特惠活动
    open_act_super_charge:add_charge(Player1, ChargeVal),
%%财神单笔充值活动
    cs_charge_d:add_charge(Player1, ChargeVal),
%% 聚宝盆
    act_jbp:add_charge(Player1, ChargeVal),
%% 亲友聚集
    act_invitation:add_charge(Player1, ChargeVal),
%% 奇遇礼包
    act_meet_limit:add_recharge_val(Player1, ChargeVal),
    %% 小额单笔充值
    small_charge_d:add_charge(Player1, ChargeVal),
    self() ! {m_task_trigger, 15, ChargeVal},
    daily:increment(?DAILY_CHARGE_ACC, ChargeVal),
    task_event:event(?TASK_ACT_CHARGE, {1}),
    act_hi_fan_tian:trigger_finish_api(Player1, 18, 1),
    act_hi_fan_tian:trigger_finish_api(Player1, 19, 1, [{charge, ChargeVal}]),
    Player2 = dvip:charge(Player1, ChargeVal),
    Player3 = limit_vip:charge(Player2, ChargeVal),
    Player4 = act_wishing_well:add_charge(Player3, ChargeVal),%% 许愿池(单)
    Player5 = cross_act_wishing_well:add_charge(Player4, ChargeVal),%% 许愿池(跨)
%%总活动列表更新 ---放在最后
    activity:get_all_act_state(Player5),
    {noreply, Player5};

handle_info({repair_act_recharge, _ChargeVal}, State) ->
%%兑换成充值货币数
%%    ChargePrice = ChargeVal div 10,
%%需要更新玩家state的都统一在这里处理
%%    Player1 = State,
%% 角色每日累充
%%     role_d_acc_charge:add_charge_val(Player1, ChargeVal),  %%注意这个活动需要放在首冲前
%% %%首冲
%%     first_charge:update_charge(State),
%% %%每日充值
%%     daily_charge:update_charge(),
%% %%累计充值
%%     acc_charge:add_charge_val(Player1, ChargeVal),
%% %%连续充值
%%     act_con_charge:add_charge_val(Player1, ChargeVal),
%% %%每日累计充值
%%     daily_acc_charge:add_charge_val(Player1, ChargeVal),
%% %%单笔充值
%%     one_charge:add_charge_val(Player1, ChargeVal),
%% %%新每日充值
%%     new_daily_charge:update_charge(),
%% %%新单笔充值
%%     new_one_charge:update_charge_val(Player1, ChargePrice),
%% %%累充转盘
%%     acc_charge_turntable:add_charge_val(Player1, ChargeVal),
%% %%首冲返利
%%     daily_fir_charge_return:add_charge_val(Player1, ChargeVal, ChargePrice),
%% %%累充礼包
%%     acc_charge_gift:add_charge_val(Player1, ChargeVal),
%% %%连续充值
%%     con_charge:add_charge(Player1, ChargeVal),
%% %%砸蛋
%%     open_egg:add_charge(Player1, ChargeVal),
%% %%合服签到
%%     merge_sign_in:add_charge(Player1, ChargeVal),
%% %%藏宝阁
%%     treasure_hourse:add_charge(Player1, ChargeVal),
%%花千骨每日充值
%%     hqg_daily_charge:add_charge(Player1, ChargeVal),
%% %%开服活动之团购首充
%%     open_act_group_charge:add_charge(Player1, ChargeVal),
%% %%开服活动之累积充值
%%     open_act_acc_charge:add_charge(Player1, ChargeVal),
%% %%登陆有礼
%%     login_online:add_charge(Player1, ChargeVal),
%% %%大额累积充值
%%     acc_charge_d:add_charge_val(Player1, ChargeVal),
%% %%消费充返利
%%     consume_back_charge:get_reward(Player1, ChargeVal),
%% %%单服充值活动
%%     recharge_rank:add_recharge_val(Player1, ChargeVal),
%% %%跨服充值活动
%%     cross_recharge_rank:add_recharge_val(Player1, ChargeVal),
%% %%合服活动之团购首充
%%     merge_act_group_charge:add_charge(Player1, ChargeVal),
%% %%合服活动之累积充值
%%     merge_act_acc_charge:add_charge(Player1, ChargeVal),
%%     self() ! {m_task_trigger, 15, ChargeVal},
%%     daily:increment(?DAILY_CHARGE_ACC, ChargeVal),
%%     task_event:event(?TASK_ACT_CHARGE, {1}),
%%     act_hi_fan_tian:trigger_finish_api(Player1, 18, 1),
%%     %%总活动列表更新 ---放在最后
%%     activity:get_all_act_state(Player1),
    {noreply, State};

%%vip改变，更新场景
handle_info(sync_vip_data, State) ->
    sync_data(vip, State),
    activity:get_notice(State, [77], true),
    if
        State#player.vip_lv > 2 ->
            notice_sys:add_notice(vip_gift, State);
        true -> skip
    end,
    self() ! {d_v_trigger, 1, []},
    guild_util:change_mb_attr(State#player.key, [{vip, State#player.vip_lv}]),
    {noreply, State};

%%登录完成回调
handle_info(login_finish, State) ->
    case data_vip_args:get(22, State#player.vip_lv) > 0 of
        true -> notice_sys:add_notice(vip_login, State);
        false -> skip
    end,
    activity:timer_notice(State),
    lim_shop:update_lim_shop(),
%%充值返还
    NewPlayer = charge:charge_return(State),
%%开服广告
%%    ad:get_ad_list(State),
%%为旧版本的玩家激活已有宠物
%%    pet_pic:activity_pic_init(State),
    target_act:trigger_tar_act(State, 1, State#player.lv),
%%合服经验
    merge_exp_double:get_info(State),
    act_rank:update_player_rank_data(State, ?ACT_RANK_EQUIP_STREN, true),
    case State#player.lv > 30 of
        true -> self() ! {d_v_trigger, 13, []};
        false -> skip
    end,
    self() ! {d_v_trigger, 1, []},
    self() ! {d_v_trigger, 2, []},
%%妖魔入侵
    guild_demon:help_cheer_notice(State),
%%活动检查
    activity:check_activity_state(State),
%%存储镜像
    shadow_proc:set(State),
    tips:login_refresh(State),
%%帮派红包检查
    red_bag:login_get_guild_red_bag(State),
%%领地战晚宴检查
    manor_war_party:check_party_for_login(NewPlayer),
%%更新我要变强数据
    wybq:update_player(NewPlayer),

    marry_ring:notice_couple(NewPlayer),
%%     %%发周卡奖励
%%     charge_week_card:send_reward(NewPlayer),
%%     %%每日登陆奖励
%%     daily_login_reward(NewPlayer),
    chat:init_lim(State),
    chat:init_lim_sp(State),
    baby:time_icon_push(State),
    fashion_suit:active_icon_push(State),
%%  钻石vip 超时邮件推送
    dvip_util:vip_time_out_mail(State),
%% 更新登陆标识
    player_load:dbup_login_flag(State),
    ?DEBUG("Now ~p last ~p~n", [util:unixtime(), State#player.logout_time]),
    case util:is_same_date(util:unixtime(), State#player.logout_time) of
        true -> ok;
        false ->
            active_proc:login(),
            achieve:trigger_achieve(State, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4002, 0, 1)
    end,
    %%新手礼包
    goods:new_role_gift(State),
    player_fcm:get_identity_state(State),
    player_login:check_reboot_warning(State),
    {noreply, NewPlayer};

handle_info(identity_state, State) ->
    player_fcm:get_identity_state(State),
    {noreply, State};

%%新号登录
handle_info(new_role, State) ->
%%     Title = ?T("创号福利"),
%%     Content = ?T("欢迎来到幻想大陆，创号即送1000钻，请您笑纳！"),
%%     mail:sys_send_mail([State#player.key], Title, Content, [{10199, 1000}]),
    {noreply, State};

%%重置任务次数
handle_info(reset_task_times, State) ->
    task:reset_task_times(State),
    {noreply, State};

%%活动提醒回调
handle_info({activity_notice, Type}, State) ->
    activity:get_notice(State, [Type], true),
    {noreply, State};


%%检查妖魔变身
handle_info(check_evil, State) ->
    NewState = player_evil:check_evil_time(State),
    scene_agent_dispatch:evil_update(NewState),
    case buff:get_buff_by_subtype(State, 5) of
        [] -> skip;
        _ -> %%有变身buff，重新广播
            Now = util:unixtime(),
            {ok, Bin} = pt_200:write(20005, {1, State#player.key, battle_pack:pack_buff_list(State#player.buff_list, Now)}),
            server_send:send_to_scene(State#player.scene, State#player.copy, State#player.x, State#player.y, Bin),
            scene_agent_dispatch:buff_update(State),
            ok
    end,
    {noreply, NewState};

%%进入温泉
handle_info({enter_hot_well, Copy}, State) ->
    case scene:is_hot_well_scene(State#player.scene) of
        true -> {noreply, State};
        false ->
            {X, Y} = util:list_rand(data_hot_well_pose:get()),
            NewPlayer = scene_change:change_scene(State, ?SCENE_ID_HOT_WELL, Copy, X, Y, true),
            {noreply, NewPlayer}
    end;

handle_info({enter_cross_battlefield, Layer, Copy}, State) ->
    case scene:is_cross_battlefield_scene(State#player.scene) of
        true -> {noreply, State};
        false ->
            {X, Y} = cross_battlefield:get_revive(Layer),
            SceneId = data_cross_battlefield:scene(Layer),
            Player = scene_change:change_scene(State#player{cross_bf_layer = Layer}, SceneId, Copy, X, Y, false),
            NewPlayer = player_battle:pk_change_sys(Player, ?PK_TYPE_FIGHT, 1),
            achieve:trigger_achieve(State, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3015, 0, Layer),
            {noreply, NewPlayer}
    end;

%%跨服巅峰塔切层
handle_info({change_cross_battlefield, Layer, Copy, Type}, State) ->
    case scene:is_cross_battlefield_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            {ok, Bin} = pt_550:write(55005, {Type, Layer}),
            server_send:send_to_sid(State#player.sid, Bin),
            {X, Y} = cross_battlefield:get_revive(Layer),
            SceneId = data_cross_battlefield:scene(Layer),
            Player = scene_change:change_scene(State#player{cross_bf_layer = Layer}, SceneId, Copy, X, Y, false),
            NewPlayer = player_battle:pk_change_sys(Player, ?PK_TYPE_FIGHT, 1),
            achieve:trigger_achieve(State, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3015, 0, Layer),
            {noreply, NewPlayer}
    end;
%%退出跨服战场
handle_info(quit_cross_battlefield, State) ->
    case scene:is_cross_battlefield_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player1 = scene_change:change_scene_back(State#player{cross_bf_layer = 0}),
            Player2 = buff:del_buff_list(Player1, data_cross_battlefield_buff:buff_list(), 1),
            {noreply, Player2}
    end;

%%跨服战场目标奖励
handle_info({cross_bf_target_reward_msg, Score, GoodsList}, State) ->
    {ok, Player} = cross_battlefield:target_reward_msg_online(State, Score, GoodsList),
    {noreply, Player};

%%跨服战场首次进入奖励
handle_info({cross_bf_enter_reward_msg, Layer, GoodsList}, State) ->
    {ok, Player} = cross_battlefield:enter_reward_msg_online(State, Layer, GoodsList),
    {noreply, Player};

%%跨服战场宝箱奖励
handle_info({cross_bf_box_reward_msg, GoodsList}, State) ->
    {ok, Player} = cross_battlefield:box_reward_msg_online(State, GoodsList),
    {noreply, Player};

%%跨服战场首位登顶
handle_info({cross_bf_first_reward_msg, GoodsList}, State) ->
    {ok, Player} = cross_battlefield:first_reward_msg_online(State, GoodsList),
    {noreply, Player};

%%跨服战场buff
handle_info({cross_bf_buff, BuffId, OldBuffId}, State) ->
    ?DO_IF(BuffId /= 0, achieve:trigger_achieve(State, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3014, 0, 1)),
    Player = ?IF_ELSE(OldBuffId == 0, State, buff:del_buff(State, OldBuffId)),
    NewPlayer = ?IF_ELSE(BuffId == 0, Player, buff:add_buff_to_player(Player, BuffId)),
    {noreply, NewPlayer};

handle_info({buff, BuffId}, State) ->
    ?DEBUG("buff ~p~n", [BuffId]),
    Player = buff:add_buff_to_player(State, BuffId),
    {noreply, Player};

handle_info({buff_list, BuffList, Attacker}, State) ->
    Player = buff:add_buff_list_to_player(State, BuffList, true, Attacker),
    {noreply, Player};

handle_info({del_buff, BuffList}, State) ->
    Player = buff:del_buff_list(State, BuffList, 0),
    {noreply, Player};

%%进入跨服boss场景
handle_info({enter_cross_boss, Copy, X, Y, Layer}, State) ->
    ?DEBUG("enter_cross_boss X:~p, Y:~p", [X, Y]),
    Scene = data_scene:get(cross_boss:get_scene_id_by_layer(Layer)),
    case State#player.scene == Scene of
        true -> {noreply, State};
        false ->
            ?DEBUG("Scene:~p", [Scene]),
            Player1 = scene_change:change_scene(State, Scene#scene.id, Copy, X, Y, false),
            Player2 = player_battle:pk_change_sys(Player1, ?PK_TYPE_GUILD, 1),
            {noreply, Player2}
    end;

%%退出跨服boss场景
handle_info(quit_cross_boss, State) ->
    case scene:is_cross_boss_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player1 = scene_change:change_scene_back(State),
            {noreply, Player1}
    end;

%%进入精英boss场景
handle_info({enter_elite_boss, Copy, X, Y, SceneId}, State) ->
    ?DEBUG("enter_elite_boss, Copy:~p, SceneId:~p", [Copy, SceneId]),
    Scene = data_scene:get(SceneId),
    case State#player.scene == Scene of
        true -> {noreply, State};
        false ->
            ?DEBUG("Scene:~p", [Scene]),
            Player = scene_change:change_scene(State, SceneId, Copy, X, Y, false),
            Player2 = player_battle:pk_change_sys(Player, ?PK_TYPE_FIGHT, 1),
            {noreply, Player2}
    end;

%%退出精英boss场景
handle_info(quit_elite_boss, State) ->
    ?DEBUG("#######quit_elite_boss", []),
    Player1 = scene_change:change_scene_back(State),
    {noreply, Player1};

%%进入攻城战场景
handle_info({enter_cross_war, Copy, X, Y, Group}, State) ->
    case scene:is_cross_war_scene(State#player.scene) of
        true -> {noreply, State};
        false ->
            Scene = data_scene:get(?SCENE_ID_CROSS_WAR),
            Player1 = scene_change:change_scene(State, Scene#scene.id, Copy, X, Y, false),
            Player2 = player_battle:pk_change_sys(Player1, ?PK_TYPE_FIGHT, 1),
            Player3 = Player2#player{group = Group},
            {ok, Bin} = pt_120:write(12027, {Player3#player.key, Group}),
            server_send:send_to_sid(Player3#player.sid, Bin),
            {noreply, Player3}
    end;

%%退出攻城战场景
handle_info(quit_cross_war, State) ->
    case scene:is_cross_war_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player1 = scene_change:change_scene_back(State),
            Player2 = player_battle:pk_change_sys(Player1, ?PK_TYPE_PEACE, 1),
            Player3 = buff:del_buff_list(Player2, [154], 1),
            {noreply, Player3#player{group = 0, crown = 0}}
    end;

%% 设置城战皇冠
handle_info({cross_war_set_crown, IsCrown}, State) ->
    ?DEBUG("cross_war_set_crown key :~p", [State#player.key]),
    NewState = State#player{crown = IsCrown},
    scene_agent_dispatch:crown(NewState),
    {noreply, NewState};

handle_info(gm_cross_war_clean_data, State) ->
    cross_war_gm:gm_midnight_refresh(),
    {noreply, State};

%%刷新buff
handle_info(refresh_cb_buff, State) ->
    case scene:is_cross_boss_scene(State#player.scene) of
        true ->
            {noreply, State};
        false ->
            {noreply, State}
    end;


%%进入跨服精英场景
handle_info({enter_cross_elite, Copy, X, Y}, State) ->
    case scene:is_cross_elite_scene(State#player.scene) of
        true -> {noreply, State};
        false ->
            Player1 = scene_change:change_scene(State, ?SCENE_ID_CROSS_ELITE, Copy, X, Y, false),
            Player2 = player_battle:pk_change_sys(Player1, ?PK_TYPE_FIGHT, 1),
            achieve:trigger_achieve(State, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3016, 0, 1),
            {noreply, Player2#player{match_state = ?MATCH_STATE_NO}}
    end;

%%退出跨服精英赛场景
handle_info(quit_cross_elite, State) ->
    case scene:is_cross_elite_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player1 = scene_change:change_scene_back(State),
            {noreply, Player1}
    end;

%%跨服1vn商店状态更新
handle_info(update_cross_1vn_shop, State) ->
    NewState = cross_1vn_init:init(State),
    {noreply, NewState};


%%退出跨服1vn初赛
handle_info(quit_cross_1vn, State) ->
    case scene:is_cross_1vn_war_scene(State#player.scene) of
        true ->
            {X, Y} = cross_1vn:get_wait_scene_xy1(),
            Copy = scene_copy_proc:get_scene_copy(?SCENE_ID_CROSS_1VN_READY, 0),
            State#player.pid ! {enter_dungeon_scene, ?SCENE_ID_CROSS_1VN_READY, Copy, X, Y, 0},
            {noreply, State};
        _ ->
            case scene:is_cross_1vn_final_war_scene(State#player.scene) of
                true ->
                    {X, Y} = cross_1vn:get_wait_scene_xy2(),
                    Copy = scene_copy_proc:get_scene_copy(?SCENE_ID_CROSS_1VN_FINAL_READY, 0),
                    State#player.pid ! {enter_dungeon_scene, ?SCENE_ID_CROSS_1VN_FINAL_READY, Copy, X, Y, 0},
                    {noreply, State};
                _ ->
                    {noreply, State}
            end
    end;

handle_info({cross_elite_msg_online, Ret}, State) ->
    cross_elite:cross_elite_msg_online(State, Ret),
    {noreply, State};

%%进入猎场
handle_info({enter_cross_hunt, Copy}, State) ->
    case scene:is_hunt_scene(State#player.scene) of
        true -> {noreply, State};
        false ->
            Scene = data_scene:get(?SCENE_ID_HUNT),
            Player1 = scene_change:change_scene(State, Scene#scene.id, Copy, Scene#scene.x, Scene#scene.y, false),
            Player2 = player_battle:pk_change_sys(Player1, ?PK_TYPE_FIGHT, 1),
            {noreply, Player2}
    end;


%%退出跨服猎场场景
handle_info(quit_cross_hunt, State) ->
    case scene:is_hunt_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player1 = scene_change:change_scene_back(State),
            {noreply, Player1}
    end;

%%猎场获得物品
handle_info({cross_hunt_get, GoodsId, KillCount}, State) ->
    Player = cross_hunt_target:cross_hunt_get(State, GoodsId, KillCount),
    {noreply, Player};

%%猎场失去物品
handle_info({cross_hunt_lose, GoodsId, NickName}, State) ->
    cross_hunt_target:cross_hunt_lose(State, GoodsId, NickName),
    {noreply, State};

%%跨服捡取掉落
handle_info({cross_pickup, DropGoods}, State) ->
    Player = drop:pickup(State, DropGoods#drop_goods.mid, DropGoods#drop_goods.goodstype, DropGoods#drop_goods.num, DropGoods#drop_goods.bindtype, DropGoods#drop_goods.from, DropGoods#drop_goods.args),
    {ok, Bin} = pt_120:write(12023, {1, DropGoods#drop_goods.key, DropGoods#drop_goods.goodstype, DropGoods#drop_goods.x, DropGoods#drop_goods.y}),
    server_send:send_to_sid(Player#player.sid, Bin),
    case State#player.scene == ?SCENE_ID_CROSS_BOSS_ONE orelse State#player.scene == ?SCENE_ID_CROSS_BOSS_TWO orelse State#player.scene == ?SCENE_ID_CROSS_BOSS_THREE orelse State#player.scene == ?SCENE_ID_CROSS_BOSS_FOUR orelse State#player.scene == ?SCENE_ID_CROSS_BOSS_FIVE of
        true ->
            case data_mon:get(DropGoods#drop_goods.mid) of
                #mon{name = Name} ->
                    case data_cross_boss:get(DropGoods#drop_goods.mid) of
                        #base_cross_boss{layer = Layer} ->
                            Sql = io_lib:format("insert into log_cross_boss_drop set pkey=~p, mon_id=~p, mon_desc='~s', goods_id=~p, goods_num=~p, layer=~p, `time`=~p",
                                [Player#player.key, DropGoods#drop_goods.mid, Name, DropGoods#drop_goods.goodstype, DropGoods#drop_goods.num, Layer, util:unixtime()]),
                            log_proc:log(Sql);
                        _ -> skip
                    end;
                _ ->
                    ok
            end;
        false ->
            ok
    end,
    {noreply, Player};


%%进入战场
handle_info({enter_battlefield, Copy, Group, Combo, Score}, State) ->
    case scene:is_battlefield_scene(State#player.scene) of
        true -> {noreply, State};
        false ->
            {X, Y} = battlefield:get_position(Group),
            PlayerMount = mount_util:get_off(State),
            PlayerPK = player_battle:pk_change_sys(PlayerMount, ?PK_TYPE_FIGHT, 1),
            Player1 = scene_change:change_scene(PlayerPK, ?SCENE_ID_BATTLEFIELD, Copy, X, Y, false),
            Player2 = Player1#player{group = Group, combo = Combo, bf_score = Score},
            {ok, Bin1} = pt_120:write(12032, {Player2#player.key, Group, Score, Combo}),
            server_send:send_to_sid(Player2#player.sid, Bin1),
            {noreply, Player2}
    end;

%%离开战场
handle_info(quit_battlefild, State) ->
    case scene:is_battlefield_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player1 = scene_change:change_scene_back(State),
            {noreply, Player1}
    end;

%%战场结算信息
handle_info({battlefield_msg, Score, Rank, Honor, GoodsList}, State) ->
    battlefield:battlefield_msg(State, Score, Rank, Honor, GoodsList),
    {noreply, State};

%%战场更新
handle_info({battlefield, Score, Combo}, State) ->
    Player = State#player{bf_score = Score, combo = Combo},
    scene_agent_dispatch:battlefield(Player),
    {noreply, Player};

%%战场获得buff
handle_info({bf_buff, BuffId}, State) ->
    Player = buff:add_buff_to_player(State, BuffId),
    {noreply, Player};

%%退出跨服普通地图
handle_info(quit_cross_normal, State) ->
    case scene:is_cross_normal_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player1 = scene_change:change_scene_back(State),
            {noreply, Player1}
    end;

%%进入跨服竞技场场景
handle_info({enter_cross_arena, Copy, X, Y}, State) ->
    case scene:is_cross_arena_scene(State#player.scene) of
        true -> {noreply, State};
        false ->
            Player1 = scene_change:change_scene(State#player{is_view = ?VIEW_MODE_HIDE}, ?SCENE_ID_CROSS_ARENA, Copy, X, Y, false),
            Player2 = player_battle:pk_change_sys(Player1, ?PK_TYPE_FIGHT, 1),
            {ok, Bin} = pt_120:write(12043, {?SIGN_PLAYER, Player1#player.key, ?VIEW_MODE_HIDE}),
            server_send:send_to_sid(Player1#player.sid, Bin),
            {noreply, Player2}
    end;

%%退出跨服竞技场
handle_info(quit_cross_arena, State) ->
    case scene:is_cross_arena_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player1 = scene_change:change_scene_back(State#player{is_view = ?VIEW_MODE_ALL}),
            {ok, Bin} = pt_120:write(12043, {?SIGN_PLAYER, Player1#player.key, ?VIEW_MODE_ALL}),
            server_send:send_to_sid(Player1#player.sid, Bin),
            {noreply, Player1}
    end;

%%跨服竞技场奖励
handle_info({cross_arena_reward, GoodsList, Rank, Score}, State) ->
    {ok, NewPlayer} = goods:give_goods(State, goods:make_give_goods_list(14, GoodsList)),
    cross_arena_init:update_arena_times(),
    achieve:trigger_achieve(State, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3020, 0, Rank),
    arena_score:update_arena_score(Score),
    {noreply, NewPlayer};


%%进入跨服消消乐场景
handle_info({enter_cross_eliminate, Copy, X, Y, Group}, State) ->
    case scene:is_cross_eliminate_scene(State#player.scene) of
        true -> {noreply, State};
        false ->
            PlayerMount = mount_util:get_off(State),
            Player1 = scene_change:change_scene(PlayerMount#player{eliminate_group = Group}, ?SCENE_ID_CROSS_ELIMINATE, Copy, X, Y, false),
            Player2 = player_battle:pk_change_sys(Player1, ?PK_TYPE_PEACE, 1),
            {noreply, Player2#player{match_state = ?MATCH_STATE_NO}}
    end;

%%退出跨服消消乐
handle_info(quit_cross_eliminate, State) ->
    case scene:is_cross_eliminate_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player1 = scene_change:change_scene_back(State#player{eliminate_group = 0}),
            {noreply, Player1}
    end;

%%消消乐邀请
handle_info({eliminate_invite, Key, Name, Avatar, Sex}, State) ->
    cross_eliminate:check_invite(State, Key, Name, Avatar, Sex),
    {noreply, State};

%%增加次数
handle_info(eliminate_times, State) ->
    cross_eliminate:add_eliminate_times(State),
    {noreply, State};

%%消消乐奖励
handle_info({eliminate_reward, Ret, GoodsList, IsMail}, State) ->
    Player = cross_eliminate:eliminate_reward(State, Ret, GoodsList, IsMail),
    {noreply, Player};

handle_info({update_eliminate_online, Ret}, State) ->
    cross_eliminate:update_eliminate_online(State, Ret),
    {noreply, State};

handle_info({eliminate_week_reward, GoodsList}, State) ->
    Player = cross_eliminate:eliminate_week_reward(State, GoodsList),
    {noreply, Player};

%%消消乐buff
handle_info({eliminate_buff, BuffList}, State) ->
    NewPlayer = buff:add_buff_list_to_player(State, BuffList, 0),
    {noreply, NewPlayer};

%%退出场景到主城
handle_info({normal_send_out_scene, SceneId, X, Y}, State) ->
    case State#player.scene =/= SceneId of
        true ->
            Copy = scene_copy_proc:get_scene_copy(SceneId, 0),
            Player1 = scene_change:change_scene(State, SceneId, Copy, X, Y, false),
            {noreply, Player1};
        false ->
            {noreply, State}
    end;

%%设置gm
handle_info({set_gm, GM}, State) ->
    NewPlayer = State#player{gm = GM},
%%    case GM == ?GM_GUIDE of
%%        true ->
%%            DesId = 4018,
%%            designation:add_des(DesId);
%%        false ->
%%            skip
%%    end,
    {noreply, NewPlayer};

%%推送13001
handle_info(send_13001, State) ->
    {ok, Bin13001} = pt_130:write(13001, player_pack:trans13001(State)),
    server_send:send_to_sid(State#player.sid, Bin13001),
    NewPlayer = player_util:count_player_attribute(State, true),
    {noreply, NewPlayer};

%%被送花
handle_info({send_flower, Pkey, Nick, Career, Avarta, GoodsId, Num, ChatString, AddCharm, Sex}, State) ->
    NewPlayer = State#player{charm = State#player.charm + AddCharm * Num},
    player_load:dbup_player_charm(NewPlayer),
    {ok, Bin} = pt_240:write(24015, {Nick, Pkey, Career, Avarta, ChatString, GoodsId, Num, Sex}),
    server_send:send_to_sid(State#player.sid, Bin),
    {ok, Bin13001} = pt_130:write(13001, player_pack:trans13001(NewPlayer)),
    server_send:send_to_sid(State#player.sid, Bin13001),
    {noreply, NewPlayer};

%%收到共乘请求
handle_info({invite_double_mount, OtherPkey, Nickname, Sid, Type}, State) ->
%?PRINT("state ~p ~n",[State#player.time_mark#time_mark.lat]),
    NowTime = util:unixtime(),
    case catch data_mount:get(State#player.mount_id) of
        _ when State#player.common_riding#common_riding.state > 0 ->
            {ok, Bin} = pt_170:write(17017, {32}),
            server_send:send_to_sid(Sid, Bin);
        _ when State#player.convoy_state > 0 ->
            {ok, Bin} = pt_170:write(17017, {33}),
            server_send:send_to_sid(Sid, Bin);
        _ when State#player.time_mark#time_mark.lat > 0 andalso State#player.time_mark#time_mark.lat + 3 > NowTime ->
            {ok, Bin} = pt_170:write(17017, {33}),
            server_send:send_to_sid(Sid, Bin);
        {false, _} when Type == 2 ->
            {ok, Bin1} = pt_170:write(17017, {29}),
            server_send:send_to_sid(Sid, Bin1);
        BaseMount when Type == 2 ->
            if BaseMount#base_mount.is_double =:= 1 ->
                {ok, Bin} = pt_170:write(17018, {OtherPkey, Nickname, Type}),
                server_send:send_to_sid(State#player.sid, Bin),
                {ok, Bin1} = pt_170:write(17017, {1}),
                server_send:send_to_sid(Sid, Bin1);
                true ->
                    skip
            end;
        _ when Type == 1 ->
            case player_util:get_player(OtherPkey) of
                [] ->
                    skip;
                Player2 ->
                    BaseMount2 = data_mount:get(Player2#player.mount_id),
                    if
                        BaseMount2#base_mount.is_double =:= 1 ->
                            {ok, Bin} = pt_170:write(17018, {OtherPkey, Nickname, Type}),
                            server_send:send_to_sid(State#player.sid, Bin),
                            {ok, Bin1} = pt_170:write(17017, {1}),
                            server_send:send_to_sid(Sid, Bin1);
                        true ->
                            skip
                    end
            end;
        _ ->
            {ok, Bin} = pt_170:write(17017, {30}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end,
    {noreply, State};


%%开始共乘
handle_info({accept_commom_mount, CommonRiding, X2, Y2}, State) ->
    Player1 = State#player{common_riding = CommonRiding},
    scene_agent_dispatch:move(Player1, X2, Y2, 1, ut),
    NewPlayer = Player1#player{x = X2, y = Y2},
    scene_agent_dispatch:common_riding(Player1),
    {ok, Bin12307} = pt_120:write(12037, {CommonRiding#common_riding.main_pkey, CommonRiding#common_riding.common_pkey, CommonRiding#common_riding.state}),
    server_send:send_to_sid(State#player.sid, Bin12307),
    if
        Player1#player.mount_id == 0 ->
            Mount = mount_util:get_mount(),
            NewPlayer1 = NewPlayer#player{mount_id = Mount#st_mount.current_image_id},
            {ok, Bin17006} = pt_170:write(17006, {?ER_SUCCEED, Mount#st_mount.current_image_id}),
            server_send:send_to_sid(Player1#player.sid, Bin17006);
        true ->
            NewPlayer1 = NewPlayer
    end,
    {noreply, NewPlayer1};

%%取消共乘
handle_info(cancel_commom_mount, State) ->
    CommonRiding = State#player.common_riding,
    Player1 = State#player{common_riding = CommonRiding#common_riding{state = 0}},
    scene_agent_dispatch:common_riding(Player1),
    {ok, Bin12307} = pt_120:write(12037, {CommonRiding#common_riding.main_pkey, CommonRiding#common_riding.common_pkey, 0}),
    server_send:send_to_sid(State#player.sid, Bin12307),
    {ok, Bin20} = pt_170:write(17020, {1}),
    server_send:send_to_sid(State#player.sid, Bin20),
    {noreply, Player1};


%%共乘跟随走路
handle_info({commom_mount_follow, X2, Y2}, State) ->
    scene_agent_dispatch:move(State, X2, Y2, 1, util:unixtime()),
    NewPlayer = State#player{x = X2, y = Y2},
    {noreply, NewPlayer};

%%共乘跟随跳转
handle_info({commom_mount_leave_scene, SceneId, Copy, X, Y}, State) ->
    Scene = data_scene:get(SceneId),
    case lists:keyfind(lv, 1, Scene#scene.require) of
        false ->
            NewPlayer = scene_change:change_scene(State, SceneId, Copy, X, Y, false);
        {_, Lv} when State#player.lv < Lv ->
            CommonRiding = State#player.common_riding,
            CommonRiding#common_riding.common_pid ! cancel_commom_mount,
            NewPlayer = State#player{common_riding = CommonRiding#common_riding{state = 0}},
            scene_agent_dispatch:common_riding(NewPlayer),
            {ok, Bin12307} = pt_120:write(12037, {CommonRiding#common_riding.main_pkey, CommonRiding#common_riding.common_pkey, 0}),
            server_send:send_to_sid(State#player.sid, Bin12307);
        _ ->
            NewPlayer = scene_change:change_scene(State, SceneId, Copy, X, Y, false)
    end,
    {noreply, NewPlayer};


%%全民夺宝付款
handle_info({panic_buying, PayList}, State) ->
    F = fun(Action, P) ->
        case Action of
            {goods, GoodsId, Num} ->
                catch goods:subtract_good(P, [{GoodsId, Num}], 190),
                P;
            {gold, Gold} ->
                money:add_no_bind_gold(P, -Gold, 190, 0, 0);
            _ -> P
        end
        end,
    Player =
        lists:foldl(F, State, PayList),
    {noreply, Player};

%%更新跨服组队房间状态
handle_info({cross_dun_state, RoomState}, State) ->
    Player = State#player{cross_dun_state = RoomState},
    {ok, Bin} = pt_123:write(12303, {RoomState}),
    server_send:send_to_sid(Player#player.sid, Bin),
    MatchState = ?IF_ELSE(RoomState /= 0, ?MATCH_STATE_CROSS_DUNGEON, ?MATCH_STATE_NO),
    {noreply, Player#player{match_state = MatchState}};

%%更新跨服组队房间状态
handle_info({cross_dun_guard_state, RoomState}, State) ->
    Player = State#player{cross_dun_guard_state = RoomState},
    {ok, Bin} = pt_651:write(65103, {RoomState}),
    server_send:send_to_sid(Player#player.sid, Bin),
    MatchState = ?IF_ELSE(RoomState /= 0, ?MATCH_STATE_CROSS_DUNGEON_GUARD, ?MATCH_STATE_NO),
    {noreply, Player#player{match_state = MatchState}};


%%收到邀请
handle_info({invite_msg, Nickname, DunId, Key, Password}, State) ->
    cross_dungeon_util:invite_msg(State, Nickname, DunId, Key, Password),
    {noreply, State};

%%收到邀请
handle_info({guard_invite_msg, Nickname, DunId, Key, Password}, State) ->
    cross_dungeon_guard_util:invite_msg(State, Nickname, DunId, Key, Password),
    {noreply, State};


%%进入跨服副本
handle_info({enter_cross_dungeon_scene, Scene, Copy, X, Y, Group, BuffId}, State) when Scene /= 0 ->
    if State#player.scene == Scene -> {noreply, State};
        true ->
            State1 = ?IF_ELSE(BuffId > 0, buff:add_buff_to_player(State, BuffId), State),
            Player = scene_change:change_scene(State1, Scene, Copy, X, Y, false),
            ?DEBUG("scene ~p~n", [State1#player.scene]),
            ?DEBUG("copy ~p~n", [State1#player.copy]),
            ?DEBUG("Player#player.scene ~p~n", [Player#player.scene]),
            ?DEBUG("Player#player.copy ~p~n", [Player#player.copy]),
            Player1 = Player#player{group = Group},
            scene_agent_dispatch:group_update(Player1),
            Dungeon = data_dungeon:get(Scene),
            DungeonRecord = #dungeon_record{
                pkey = Player#player.key,
                dun_id = Scene,
                dungeon_pid = Copy,
                timeout = util:unixtime() + Dungeon#dungeon.time,
                benefit = 1,
                out = [Player#player.scene, Player#player.copy, Player#player.x, Player#player.y]
            },
            dungeon_record:set(Player#player.key, DungeonRecord),
            handle_info({cross_dun_state, 0}, Player1)
    end;

%%退出跨服副本
handle_info({quit_cross_dungeon_scene, DunId, BuffId}, State) when DunId /= 0 ->
    if State#player.scene == DunId ->
        State1 = ?IF_ELSE(BuffId > 0, buff:del_buff(State, BuffId), State),
        Player = scene_change:change_scene_back(State1),
        Player1 = Player#player{group = 0},
        {ok, Bin} = pt_120:write(12027, {Player#player.key, 0}),
        server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
        dungeon_record:erase(Player#player.key),
        {noreply, Player1};
        true ->
            {noreply, State}
    end;

%%跨服副本奖励
handle_info({dun_cross_ret, IsPass, DunId, Key, Password, IsFast, AutoReady, IsExtraPt}, State) ->
    NewPlayer = cross_dungeon_util:dun_cross_ret(IsPass, DunId, State, Key, Password, IsFast, AutoReady, IsExtraPt),
    {noreply, NewPlayer};

%%进入跨服试炼副本
handle_info({enter_cross_dungeon_guard_scene, Scene, Copy, X, Y, Group, BuffId}, State) when Scene /= 0 ->
    if State#player.scene == Scene ->
        {noreply, State};
        true ->
            State1 = ?IF_ELSE(BuffId > 0, buff:add_buff_to_player(State, BuffId), State),
            Player = scene_change:change_scene(State1, Scene, Copy, X, Y, false),
            Player1 = Player#player{group = Group},
            scene_agent_dispatch:group_update(Player1),
            Dungeon = data_dungeon:get(Scene),
            DungeonRecord = #dungeon_record{
                pkey = Player#player.key,
                dun_id = Scene,
                dungeon_pid = Copy,
                timeout = util:unixtime() + Dungeon#dungeon.time,
                benefit = 1,
                out = [Player#player.scene, Player#player.copy, Player#player.x, Player#player.y]
            },
            dungeon_record:set(Player#player.key, DungeonRecord),

            St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
            DunList =
                case lists:keytake(Scene, 1, St#st_cross_dun_guard.dun_list) of
                    false ->
                        [{Scene, 1, 1, 0, 0, []} | St#st_cross_dun_guard.dun_list];
                    {value, {Scene, Times, Floor10, Time10, State11, CountList}, T} ->
                        [{Scene, Times + 1, Floor10, Time10, State11, CountList} | T]
                end,
            NewSt = St#st_cross_dun_guard{dun_list = DunList, is_change = 1},
            lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, NewSt),
            handle_info({cross_dun_guard_state, 0}, Player1)
    end;

%%退出跨服试炼副本
handle_info({quit_cross_dungeon_guard_scene, DunId, BuffId}, State) when DunId /= 0 ->
    if State#player.scene == DunId ->
        State1 = ?IF_ELSE(BuffId > 0, buff:del_buff(State, BuffId), State),
        Player = scene_change:change_scene_back(State1),
        Player1 = Player#player{group = 0},
        {ok, Bin} = pt_120:write(12027, {Player#player.key, 0}),
        server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
        dungeon_record:erase(Player#player.key),
        {noreply, Player1};
        true ->
            {noreply, State}
    end;

%%跨服试炼副本奖励
handle_info({dun_cross_guard_ret, IsPass, DunId, Key, Password, IsFast, AutoReady, IsExtraPt, Floor, BoxCount, PassGoodslist}, State) ->
    Now = util:unixtime(),
    ?DEBUG("dun_cross_guard_ret ~n"),
    NewPlayer = cross_dungeon_guard_util:dun_cross_ret(IsPass, DunId, State, Key, Password, IsFast, AutoReady, IsExtraPt, Floor, Now, BoxCount, PassGoodslist),
    {noreply, NewPlayer};

handle_info(cacl_attr_guild_fight, State) ->
    NewPlayer = player_util:count_player_attribute(State, true),
    {noreply, NewPlayer};


%%设置显示模式
handle_info({set_view, View}, State) ->
    Player = State#player{is_view = View},
    scene_agent_dispatch:set_view(Player),
    {noreply, Player};

handle_info(manor_war_pk, State) ->
    NewPlayer =
        case scene:is_normal_scene(State#player.scene) of
            false -> State;
            true ->
                player_battle:pk_change_sys(State, ?PK_TYPE_GUILD, 0)
        end,
    {noreply, NewPlayer};

%%领地站晚宴奖励
handle_info({manor_party_reward, GoodsList}, State) ->
    Player = manor_war_party:manor_party_reward(State, GoodsList),
    {noreply, Player};

handle_info({drink, Now}, State) ->
    Player = manor_war_party:drink(State, Now),
    {noreply, Player};

handle_info({accept_manor_task, TaskList}, State) ->
    task:accept_manor_task(State, TaskList),
    {noreply, State};

handle_info({act_one_gold_buy, notice}, State) ->
    activity_rpc:handle(43942, State, {}),
    {noreply, State};

%%帮派妖魔入侵
handle_info({pass_dun_demon_round, EnterTime, Round, Exp}, State) ->
    NewPlayer = player_util:add_exp(State, Exp, 18),
    Now = util:unixtime(),
    case util:is_same_date(EnterTime, Now) of
        true -> guild_demon:pass_dun_round(State, Round);
        false -> skip
    end,
    {noreply, NewPlayer};

%%王城守卫波数奖励
handle_info({kindom_guard_add_goods, GoodsList}, State) ->
    GiveGoodsList = goods:make_give_goods_list(505, GoodsList),
    {ok, NewPlayer} = goods:give_goods(State, GiveGoodsList),
    {noreply, NewPlayer};

%%增加个人称号
handle_info({add_des, DesId}, State) ->
    Player = designation:add_designation(State, DesId),
    {noreply, Player};

%%增加全局称号
handle_info({add_des_global, DesId}, State) ->
    Player = designation:add_designation_global(State, DesId),
    {noreply, Player};

%%删除全局称号
handle_info({del_des_global, DesId}, State) ->
    Player = designation:del_designation_global(State, DesId),
    {noreply, Player};

%%登陆初始化全服目标
handle_info(new_day_login, State) ->
    open_act_all_target:init_login(State),
    {noreply, State};
%%增加罪恶值
handle_info({add_evil, Key}, State) ->
    Player = prison:add_evil(State, Key),
    {noreply, Player};

%%增加侠义值
handle_info({add_chivalry, Key, Evil}, State) ->
    Player = prison:add_chivalry(State, Key, Evil),
    {noreply, Player};

handle_info({buff_timeout, BuffId}, State) ->
    Player = buff:buff_timeout(?SIGN_PLAYER, State, BuffId, []),
    {noreply, Player};

%%触发成就
handle_info({achieve, Type, Subtype, Val1, Val2}, State) ->
    achieve:trigger_achieve(State, Type, Subtype, Val1, Val2),
    {noreply, State};

%%活动匹配状态
handle_info({match_state, MatchState}, State) ->
    {noreply, State#player{match_state = MatchState}};

handle_info({cmd_position, X, Y}, State) ->
    ?DEBUG("key ~p myxy ~p/~p scene ~p/~p~n", [State#player.key, State#player.x, State#player.y, X, Y]),
    {noreply, State};

handle_info({activity_gm_print, Id}, State) ->
    activity:activity_gm_print(State, Id),
    {noreply, State};

handle_info(login_days, State) ->
    {noreply, State#player{login_days = config:get_open_days()}};

%%温泉
handle_info({hot_well, HotWellSt, Pkey}, State) ->
    HotWell = #phot_well{
        state = HotWellSt,
        pkey = Pkey
    },
    NewState = State#player{
        hot_well = HotWell
    },
    scene_agent_dispatch:hot_well_update(NewState),
    {noreply, NewState};


%%进入跨服1vN初赛场景
handle_info({enter_cross_1vn, 0, _Floor, Copy, Group}, State) ->
    {X, Y} = ?IF_ELSE(Group == 1, {9, 22}, {19, 22}),
    Player = scene_change:change_scene(State, ?SCENE_ID_CROSS_1VN_WAR, Copy, X, Y, false),
    Player1 = player_battle:pk_change_sys(Player, ?PK_TYPE_FIGHT, 1),
    Player2 = Player1#player{group = Group},
    NewPlayer = player_util:count_player_attribute(Player2, true),
    scene_agent_dispatch:figure(NewPlayer),
    scene_agent_dispatch:group_update(NewPlayer),
    {noreply, NewPlayer#player{match_state = ?MATCH_STATE_NO}};

%%进入跨服1vN决赛场景
handle_info({enter_cross_1vn, 1, Floor, Copy, Group}, State) ->
    {X, Y} =
        if
            Group == ?CROSS_1VN_GROUP_RED -> {25, 36};
            true -> L = data_cross_1vn_final_wait:get(Floor),
                util:list_rand(L)
        end,
    Player = scene_change:change_scene(State, ?SCENE_ID_CROSS_1VN_FINAL_WAR, Copy, X, Y, false),
    Player1 = player_battle:pk_change_sys(Player, ?PK_TYPE_FIGHT, 1),
    Player2 = Player1#player{group = Group},
    NewPlayer = player_util:count_player_attribute(Player2, true),
    scene_agent_dispatch:figure(NewPlayer),
    scene_agent_dispatch:group_update(NewPlayer),
    {noreply, NewPlayer#player{match_state = ?MATCH_STATE_NO}};


%%进入乱斗场景
handle_info({enter_cross_scuffle, Copy, Group, S_Career}, State) ->
    State1 = buff:clean_buff_by_subtype(State, 5),
    Figure = cross_scuffle:career2figure(S_Career, 0),
    {X, Y} = cross_scuffle:get_revive(Group),
    Player = scene_change:change_scene(State1, ?SCENE_ID_CROSS_SCUFFLE, Copy, X, Y, false),
    Player1 = player_battle:pk_change_sys(Player, ?PK_TYPE_FIGHT, 1),
    Player2 = Player1#player{group = Group, figure = Figure, scuffle_state = true},
    NewPlayer = player_util:count_player_attribute(Player2, true),
    scene_agent_dispatch:figure(NewPlayer),
    scene_agent_dispatch:group_update(NewPlayer),
    Record = #ets_cross_scuffle_record{
        pkey = Player#player.key,
        pid = Copy,
        figure = Figure,
        group = Group,
        time = util:unixtime() + ?CROSS_SCUFFLE_PLAY_TIME
    },
    ets:insert(?ETS_CROSS_SCUFFLE_RECORD, Record),
    {noreply, NewPlayer#player{match_state = ?MATCH_STATE_NO}};


%%退出乱斗场景
handle_info(quit_cross_scuffle, State) ->
    case scene:is_cross_scuffle_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player0 = buff:del_buff_only(State, ?SCUFFLE_COMBO_BUFF_ID),
            Player = scene_change:change_scene_back(Player0),
            Player1 = Player#player{group = 0, figure = 0},
            {ok, Bin} = pt_120:write(12027, {Player#player.key, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            NewPlayer = player_util:count_player_attribute(Player1, true),
            scene_agent_dispatch:figure(NewPlayer),
            scene_agent_dispatch:group_update(NewPlayer),
            {noreply, NewPlayer}
    end;

handle_info({scuffle_reward, GoodsList}, State) ->
    Player = cross_scuffle:scuffle_reward(State, GoodsList),
    {noreply, Player};


%%进入乱斗精英赛场景
handle_info({enter_cross_scuffle_elite, Copy, Group, S_Career}, State) ->
    ?DEBUG("enter_cross_scuffle_elite ~p~n", [{Copy, Group, S_Career}]),
    State1 = buff:clean_buff_by_subtype(State, 5),
    Figure = cross_scuffle_elite:career2figure(S_Career, 0),
    {X, Y} = cross_scuffle_elite:get_revive(Group),
    Player = scene_change:change_scene(State1, ?SCENE_ID_CROSS_SCUFFLE_ELITE, Copy, X, Y, false),
    Player1 = player_battle:pk_change_sys(Player, ?PK_TYPE_FIGHT, 1),
    Player2 = Player1#player{group = Group, figure = Figure, scuffle_elite_state = true},
    NewPlayer = player_util:count_player_attribute(Player2, true),
    scene_agent_dispatch:figure(NewPlayer),
    scene_agent_dispatch:group_update(NewPlayer),
    Record = #ets_cross_scuffle_elite_record{
        pkey = Player#player.key,
        pid = Copy,
        figure = Figure,
        group = Group,
        time = util:unixtime() + ?CROSS_SCUFFLE_ELITE_PLAY_TIME
    },
    ets:insert(?ETS_CROSS_SCUFFLE_ELITE_RECORD, Record),
    {noreply, NewPlayer#player{match_state = ?MATCH_STATE_NO}};


%%退出乱斗精英赛场景
handle_info(quit_cross_scuffle_elite, State) ->
    case scene:is_cross_scuffle_elite_scene(State#player.scene) of
        false -> {noreply, State};
        true ->
            Player0 = buff:del_buff_only(State, ?SCUFFLE_ELITE_COMBO_BUFF_ID),
            cross_all:apply(cross_scuffle_elite, scuffle_elite_quit, [State#player.key, State#player.copy]),
            Player1 = cross_scuffle_elite:sendout_scene(Player0),
            Player2 = Player1#player{group = 0, figure = 0},
            {ok, Bin} = pt_120:write(12027, {State#player.key, 0}),
            server_send:send_to_sid(State#player.sid, Bin),
            NewPlayer = player_util:count_player_attribute(Player2, true),
            scene_agent_dispatch:figure(NewPlayer),
            scene_agent_dispatch:group_update(NewPlayer),
            {noreply, NewPlayer}
    end;



handle_info({scuffle_elite_reward, GoodsList}, State) ->
    Player = cross_scuffle_elite:scuffle_reward(State, GoodsList),
    {noreply, Player};

%%通知客户端重新进入场景
handle_info(check_enter_scene, State) ->
    scene_agent_dispatch:leave_scene(State),
    NewCopy = scene_copy_proc:get_scene_copy(State#player.scene, State#player.copy),
    SceneData = data_scene:get(State#player.scene),
    {ok, Bin} = pt_120:write(12005, {State#player.scene, State#player.x, State#player.y, SceneData#scene.sid, SceneData#scene.name}),
    server_send:send_to_sid(State#player.sid, Bin),
%%    case get(msg_re_enter_scene) of
%%        fail ->
%%            ?CAST(self(), stop),
%%            ?ERR("scene err player ~p pid stop ~n", [State#player.key]);
%%        _ -> ok
%%    end,
%%    put(msg_re_enter_scene, fail),
%%    ?ERR("player  ~p re enter sid ~p/~p~n", [State#player.key, State#player.scene, NewCopy]),
    {noreply, State#player{copy = NewCopy, enter_sid_time = util:unixtime()}};

handle_info(fix_task, State) ->
    chat_gm:do_fix_task(State),
    {noreply, State};
%% 机器人相关
%%handle_info({robot_add_monkey, L}, State) ->
%%    if
%%        State#player.pf == 888 ->
%%            robot_util:add_monkey_list(L);
%%        true ->
%%            ok
%%    end,
%%    {noreply, State};
%%
%%handle_info({robot_sub_monkey, L}, State) ->
%%    if
%%        State#player.pf == 888 ->
%%            robot_util:sub_monkey_list(L);
%%        true ->
%%            ok
%%    end,
%%    {noreply, State};
%%
%%handle_info(robot_add_goods, Player) ->
%%    %% 机器人测试，定时给礼包物品
%%    Rand = util:rand(1, 20000),
%%    if
%%        Player#player.pf =/= 888 ->
%%            NewPlayer = Player;
%%        Rand < 3000 -> %% 随机加物品
%%            GiftIdList = data_gift_bag:get_all(),
%%            GiveGoodsList = goods:make_give_goods_list(616, [{util:list_rand(GiftIdList), 1}]),
%%            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList);
%%        Rand < 4000 -> %% 随机删除物品
%%            GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
%%            GoodsList = dict:to_list(GoodsSt#st_goods.dict),
%%            case GoodsList of
%%                [] ->
%%                    NewPlayer = Player;
%%                _ ->
%%                    {_, [Goods]} = util:list_rand(GoodsList),
%%                    goods:subtract_good(Player, [{Goods#goods.key, Goods#goods.num}], 1),
%%                    NewPlayer = Player
%%            end;
%%        Rand < 4020 -> %% 升级
%%            NewPlayer = robot_act:act(Player, 2, 0);
%%        Rand < 4300 -> %% 完成任务
%%            NewPlayer = robot_act:act(Player, 4, 0);
%%        Rand < 4320 ->
%%%%         true ->
%%            MsgList = [
%%                "问世间情为何物,直教人生死相许? ",
%%                "天南地北双飞客,老翅几回寒暑. ",
%%                "欢乐趣,离别苦,",
%%                "就中更有痴儿女,君应有语.",
%%                "渺万里层云,千山暮雪,只影向谁去? ",
%%                "横汾路,寂寞当年箫鼓,荒烟依旧平楚.",
%%                "招魂楚些何嗟及,山鬼暗啼风雨.",
%%                "天地妒,未信与, ",
%%                "莺儿燕子俱黄土,千秋万古.",
%%                "为留待骚人,狂歌痛饮,来访雁丘处.",
%%                "相思相见知何日？此时此夜难为情.",
%%                "相思树底说相思，思郎恨郎郎不知.",
%%                "落红不是无情物，化作春泥更护花.",
%%                "关关雎鸠，在河之洲.窈宨淑女，君子好逑.",
%%                "人生自是有情痴，此恨不关风与月.",
%%                "梧桐树，三更雨，不道离情正苦.一叶叶，一声声，空阶滴到明.",
%%                "落花人独立，微雨燕双飞.",
%%                "执手相看泪眼，竟无语凝噎.",
%%                "天涯地角有穷时，只有相思无尽处.",
%%                "多情只有春庭月，犹为离人照落花."
%%            ],
%%            Msg = util:list_rand(MsgList),
%%            chat:chat(Player, ?CHAT_TYPE_PUBLIC, ?T(Msg), "", Player#player.key, Player#player.nickname),
%%            NewPlayer = Player;
%%        true ->
%%            NewPlayer = Player
%%    end,
%%    {noreply, NewPlayer};


handle_info({cross_boss_score_reward, Score}, State) ->
    NewPlayer = cross_boss:recv_score_reward(State, Score),
    {noreply, NewPlayer};

%%更新婚姻信息
handle_info({update_marry, Marry}, State) ->
    Player = State#player{marry = Marry},
    scene_agent_dispatch:update_marry(Player),
    marry_load:update_marry_key(Player#player.key, Marry#marry.mkey),
    Type = marry_ring:marry_trigger(Player),
    NewPlayer = player_util:count_player_attribute(Player, true),
    baby_util:check_player_marray(State, Marry),
    activity:get_notice(Player, [133, 134, 135], true),
    CouplePlayer = shadow_proc:get_shadow(Marry#marry.couple_key),
    spawn(fun() -> cross_war:update_couple_info(NewPlayer, CouplePlayer) end),
    {noreply, NewPlayer#player{marry_ring_type = Type}};

%%上线添加buff
handle_info(add_ring_buff, State) ->
    Lv = marry_ring:get_my_ring_lv(),
    Type = marry_ring:get_my_ring_type(),
    Base = data_ring:get(Lv, Type),
    NewPlayer = buff:add_buff_to_player(State, Base#base_marry_ring.buff_id),
    NewPlayer1 = buff:add_buff_to_player(NewPlayer, 56850),
    {noreply, NewPlayer1};


%%更新结婚排行榜领取状态
handle_info(update_marry_rank, State) ->
    StMarryRank = lib_dict:get(?PROC_STATUS_MARRY_RANK),
    lib_dict:put(?PROC_STATUS_MARRY_RANK, StMarryRank#st_marry_rank{state = 1}),
    activity_load:dbup_player_marry_rank(StMarryRank#st_marry_rank{state = 1}),
    activity:get_notice(State, [131], true),
    {noreply, State};

%%离线去除buff
handle_info(del_ring_buff, State) ->
    Lv = marry_ring:get_my_ring_lv(),
    Type = marry_ring:get_my_ring_type(),
    Base = data_ring:get(Lv, Type),
    NewPlayer = buff:del_buff(State, Base#base_marry_ring.buff_id),
    NewPlayer1 = buff:del_buff(NewPlayer, 56850),
    {noreply, NewPlayer1};

handle_info(refresh_marry_heart, State) ->
    NewPlayer = player_util:count_player_attribute(State, true),
    {noreply, NewPlayer};

handle_info(refresh_marry_ring, State) ->
    NewPlayer = player_util:count_player_attribute(State, true),
    {noreply, NewPlayer};

handle_info({reset_awake, _HighCbp}, State) ->
    St = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
    NewSt = St#st_act_cbp_rank{high_cbp = max(0, St#st_act_cbp_rank.high_cbp - 306000)},
    ?DEBUG("NewSt ~p~n", [NewSt]),
    lib_dict:put(?PROC_STATUS_ACT_CBP_RANK, NewSt),
    activity_load:dbup_player_act_cbp_rank(NewSt),
    NewPlayer0 = player_awake:init(State),
    NewPlayer = player_util:count_player_attribute(NewPlayer0#player{highest_cbp = NewPlayer0#player.highest_cbp - 306000}, true),
    Sql = io_lib:format("update player_state set combat_power=~p, highest_combat_power = ~p  where pkey = ~p",
        [NewPlayer#player.cbp, NewPlayer#player.highest_cbp, State#player.key]),
    db:execute(Sql),
    St1 = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
    ?DEBUG("St1 ~p~n", [St1]),


    {noreply, NewPlayer};

handle_info(weedding_car_exp, State) ->
%% [(等级-39)^2*50+40000] * 6/3600  * 30
    Exp = round((math:sqrt(max(0, State#player.lv - 39)) * 50 + 40000) * 6 / 3600 * 30),
    Player = player_util:add_exp(State, Exp, 21),
    {noreply, Player};

handle_info({cruise_state, CruiseState}, State) ->
    Marry = State#player.marry,
    NewMarry = Marry#marry{cruise_state = CruiseState},
    Player = State#player{marry = NewMarry},
    scene_agent_dispatch:update_cruise(Player),
    {noreply, Player};

handle_info({cruise_invite_mail, TimeString, InviteGuild, InviteFriend}, State) ->
    marry_cruise:invite_mail(State, TimeString, InviteGuild, InviteFriend),
    {noreply, State};

handle_info({dungeon_marry_change_scene, TarScene, TarCopy}, State) ->
    ?DEBUG("dungeon_marry_change_scene", []),
    Player = scene_change:change_scene(State, TarScene, TarCopy),
    {noreply, Player};

handle_info({party_exp, ExpMult}, State) ->
%% [(等级-39)^2*50+40000] * 6/3600  * 1800*系数
    Exp = party:party_exp(State#player.lv, ExpMult),
    Player = player_util:add_exp(State, Exp, 22),
    daily:increment(?DAILY_PARTY_TIMES, 1),
    {noreply, Player};

handle_info({cmd_change_scene, Sid}, State) ->
    Player =
        if State#player.scene == Sid ->
            scene_change:change_scene(State, ?SCENE_ID_MAIN, 0);
            true ->
                State
        end,
    {noreply, Player};

%%魔宫刷新buff
handle_info({refresh_dark_buff, OldBuffList, NewBuffList}, State) ->
    NewPlayer =
        case scene:is_cross_dark_blibe(State#player.scene) of
            false -> State;
            true ->
                Player0 = buff:del_buff_list(State, OldBuffList, 0),
                buff:add_buff_list_to_player(Player0, NewBuffList, 0)
        end,
    {noreply, NewPlayer};

handle_info(quit_cross_dark, State) ->
    NewPlayer =
        case scene:is_cross_dark_blibe(State#player.scene) of
            true ->
                Player0 = cross_dark_bribe:del_buff_quit(State),
                Player1 = scene_change:change_scene_back(Player0),
                Player2 = player_battle:pk_change(Player1, State#player.pk#pk.pk_old, 1),
                Player2;
            _ ->
                State
        end,
    {noreply, NewPlayer};

handle_info(refresh_task_dark, State) ->
    Player = task_dark:refresh_task(State, true),
    {noreply, Player};

%% 红圈通知
handle_info(refresh_darak_task_tisp, State) ->
    activity:get_notice(State, [141], true),
    {noreply, State};

handle_info(cross_war_43099, State) ->
    activity:get_notice(State, [143, 149], true),
    {noreply, State};

handle_info({add_player_cross_boss, MonId}, State) ->
    cross_boss:add_player_cross_boss(State, MonId),
    {noreply, State};

handle_info({festival_red_gift, recv_red_gift, GoodsList}, State) ->
    NewState = festival_red_gift:recv_red_gift(State, GoodsList),
    {noreply, NewState};

handle_info({festival_challenge_cs, bgold, Bgold}, State) ->
    NewPlayer = money:add_bind_gold(State, Bgold, 702, 0, 0),
    {noreply, NewPlayer};

handle_info({festival_challenge_cs, gold, Gold}, State) ->
    NewPlayer = money:add_no_bind_gold(State, Gold, 703, 0, 0),
    {noreply, NewPlayer};

handle_info({marry_gift, 28901}, State) ->
    ?DEBUG("marry_gift 28901", []),
    marry_rpc:handle(28901, State, {}),
    {noreply, State};

handle_info({xian_kill_mon, Mid}, State) ->
    xian_upgrade:kill_mon(Mid),
    {noreply, State};

handle_info({add_kill_count, Key}, State) ->
    Player = prison:add_kill_count(State, Key),
    {noreply, Player};

handle_info(quit_guild_scene, State) ->
    Player = ?IF_ELSE(State#player.scene == ?SCENE_ID_GUILD, scene_change:change_scene_back(State), State),
    {noreply, Player};

handle_info({guild_answer, GoodsList}, State) ->
    {ok, Player} = goods:give_goods(State, goods:make_give_goods_list(349, GoodsList)),
    {noreply, Player};

handle_info(print, State) ->
    ?WARNING("dict ~p~n", [get()]),
    ?WARNING("player ~p~n", [State]),
    {noreply, State};
%%apply cast调用
%%调用函数应返回：ok|{ok,NewPlayer}
%%调用接口 player:apply_state
handle_info({apply_state, {Module, Function, Args}}, State) ->
    case catch Module:Function(Args, State) of
        {ok, NewState} ->
            {noreply, NewState};
        ok ->
            {noreply, State};
        _Err ->
            ?ERR("apply unkonw return val ~p/~p/~p~n", [Module, Function, _Err]),
            {noreply, State}
    end;

%% 调用接口 player:apply
handle_info({apply, {Module, Function, Args}}, State) ->
    ?DEBUG("cast apply ~n"),
    case catch Module:Function(Args) of
        {ok, NewState} ->
            {noreply, NewState};
        ok ->
            {noreply, State};
        _Err ->
            ?ERR("apply unkonw return val ~p/~p/~p~n", [Module, Function, _Err]),
            {noreply, State}
    end;

%% 调用接口 player:apply
handle_info({apply_info, {Module, Function, Args}}, State) ->
    case catch apply(Module, Function, Args) of
        ok ->
            {noreply, State};
        {ok, _} ->
            {noreply, State};
        _Err ->
            ?ERR("apply unkonw return val ~p/~p/~p~n", [Module, Function, _Err]),
            {noreply, State}
    end;

handle_info(_Info, State) ->
    _Len = length(tuple_to_list(_Info)),
    ?DEBUG("len ~p~n", [_Len]),
    ?ERR("player_handle not match info ~p~n", [_Info]),
    {noreply, State}.

daily_login_reward(_State) ->
    ok.
%%     case config:get_open_days() < 8 of
%%         false -> ok;
%%         true ->
%%             case util:is_same_date(util:unixtime(), State#player.logout_time) of
%%                 true -> ok;
%%                 false ->
%%                     {Title, Content} = t_mail:mail_content(72),
%%                     mail:sys_send_mail([State#player.key], Title, Content, [{10199, 200}])
%%             end
%%     end.

online_time_reward(_State, _Seconds) ->
%%     online_time_gift:update_online_time(),
%%     OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
%%     #st_online_time_gift{online_time = OnlineTime} = OTGiftSt,
%%     if
%%         OnlineTime > 90 * 60 + 5 -> skip;
%%         OnlineTime > 90 * 60 ->
%%             {Title, Content0} = t_mail:mail_content(73),
%%             Content = io_lib:format(Content0, [90]),
%%             mail:sys_send_mail([State#player.key], Title, Content, [{10199, 2000}, {1040003, 1}]);
%%         OnlineTime > 75 * 60 + 5 -> skip;
%%         OnlineTime > 75 * 60 ->
%%             {Title, Content0} = t_mail:mail_content(73),
%%             Content = io_lib:format(Content0, [75]),
%%             mail:sys_send_mail([State#player.key], Title, Content, [{10199, 1000}, {1040002, 1}]);
%%         OnlineTime > 60 * 60 + 5 -> skip;
%%         OnlineTime > 60 * 60 ->
%%             {Title, Content0} = t_mail:mail_content(73),
%%             Content = io_lib:format(Content0, [60]),
%%             mail:sys_send_mail([State#player.key], Title, Content, [{10199, 500}, {1040002, 1}]);
%%         OnlineTime > 40 * 60 + 5 -> skip;
%%         OnlineTime > 40 * 60 ->
%%             {Title, Content0} = t_mail:mail_content(73),
%%             Content = io_lib:format(Content0, [40]),
%%             mail:sys_send_mail([State#player.key], Title, Content, [{10199, 500}, {1040001, 1}]);
%%         OnlineTime > 20 * 60 + 5 -> skip;
%%         OnlineTime > 20 * 60 ->
%%             {Title, Content0} = t_mail:mail_content(73),
%%             Content = io_lib:format(Content0, [20]),
%%             mail:sys_send_mail([State#player.key], Title, Content, [{10199, 300}, {1040001, 1}]);
%%         OnlineTime > 10 * 60 + 5 -> skip;
%%         OnlineTime > 10 * 60 ->
%%             {Title, Content0} = t_mail:mail_content(73),
%%             Content = io_lib:format(Content0, [10]),
%%             mail:sys_send_mail([State#player.key], Title, Content, [{10199, 300}, {1040001, 1}]);
%%         OnlineTime > 5 * 60 + 5 -> skip;
%%         OnlineTime > 5 * 60 ->
%%             {Title, Content0} = t_mail:mail_content(73),
%%             Content = io_lib:format(Content0, [5]),
%%             mail:sys_send_mail([State#player.key], Title, Content, [{10199, 60}, {1040001, 1}]);
%%         true ->
%%             skip
%%     end.
    ok.

online_time_notice(Player) ->
    online_time_gift:update_online_time(),
    OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
    #st_online_time_gift{online_time = OnlineTime} = OTGiftSt,
    if
        OnlineTime < 100 -> skip;
        OnlineTime rem 90 > 5 -> skip;
        true ->
            {ok, Bin} = pt_130:write(13040, {1}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end.

create_role_mail(_Pkey) ->
    ok.

gm(Pkey) -> create_role_mail(Pkey).

repair_act_recharge(Player) ->
    case Player#player.sn == 3002 orelse config:is_debug() of
        false -> skip;
        true ->
            case util:unixtime() < 0 of %% 先屏蔽
                false -> skip;
                true ->
                    case cache:get({repair_act_recharge, Player#player.key}) of
                        Flag when is_integer(Flag) -> skip;
                        _ ->
                            cache:set({repair_act_recharge, Player#player.key}, 1, ?ONE_DAY_SECONDS),
                            Sql = io_lib:format("select total_fee from recharge where `time` > 1504368000 and `time` < 1504423800 and app_role_id=~p", [Player#player.key]),
                            case db:get_all(Sql) of
                                Rows when is_list(Rows) ->
                                    F = fun([TotalFee]) ->
                                        case is_integer(TotalFee) of
                                            false -> ok;
                                            true ->
                                                self() ! {repair_act_recharge, TotalFee div 10}
                                        end;
                                        (_) -> ok
                                        end,
                                    lists:map(F, Rows);
                                _ -> ok
                            end
                    end
            end
    end.





