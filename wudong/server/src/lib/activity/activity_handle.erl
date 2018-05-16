%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 一月 2016 下午4:53
%%%-------------------------------------------------------------------
-module(activity_handle).
-author("fengzhenlin").
-include("activity.hrl").
-include("common.hrl").

%% API
-export([
    handle_call/3, handle_cast/2, handle_info/2
]).

%%擂主商城配置
handle_call(get_cross_1vn_shop_base, _From, State) ->
    {reply, State#state.cross_1vn_shop_base, State};

%%获取抽奖记录
handle_call(get_daily_charge_record, _From, State) ->
    {reply, State#state.daily_charge_record, State};

%%获取抢购商店购买记录
handle_call(get_lim_shop_info, _From, State) ->
    {reply, State#state.lim_shop#lim_shop.dict, State};

%%获取累充转盘记录
handle_call(get_acc_charge_returntable_record, _From, State) ->
    Reply = State#state.acc_charge_turntable_record,
    {reply, Reply, State};

%%获取抢购商店默认天数
handle_call(get_lim_shop_default_day, _From, State) ->
    {reply, max(1, State#state.lim_shop#lim_shop.act_day), State};

%% 跨服幸运转盘
handle_call({cost_luck_turn_gold, CostRate}, _From, State) ->
    CostNum = act_lucky_turn:do_cost_luck_gold(CostRate),
    {reply, CostNum, State};

%% 本服幸运转盘
handle_call({cost_local_luck_turn_gold, CostRate}, _From, State) ->
    CostNum = act_local_lucky_turn:do_cost_local_luck_gold(CostRate),
    {reply, CostNum, State};

handle_call({one_gold_buy, buy_center, Args}, _From, State) ->
    R = act_one_gold_buy:buy_center_cast(State, Args),
    {reply, R, State};

handle_call(_Info, _From, State) ->
    ?ERR("activity_handle call info ~p~n", [_Info]),
    {reply, ok, State}.

%%充值触发开服活动团购首充
handle_cast({update_open_act_group_charge, {Pkey, ChargeGold}}, State) ->
    open_act_group_charge:up_charge_ets(Pkey, ChargeGold),
    {noreply, State};

%%充值触发合服活动团购首充
handle_cast({update_merge_act_group_charge, {Pkey, ChargeGold}}, State) ->
    merge_act_group_charge:up_charge_ets(Pkey, ChargeGold),
    {noreply, State};

%%全服目标激活
handle_cast({update_open_act_all_target, Pkey, ActType, Lv}, State) ->
    open_act_all_target:act_target_cast(Pkey, ActType, Lv),
    {noreply, State};

%%全服目标激活
handle_cast(act_target_init, State) ->
    open_act_all_target:act_target_init_cast(),
    {noreply, State};

%%全服目标激活
handle_cast({update_open_act_all_target2, Pkey, ActType, Lv}, State) ->
    open_act_all_target2:act_target_cast(Pkey, ActType, Lv),
    {noreply, State};

%%全服目标激活
handle_cast(act_target_init2, State) ->
    open_act_all_target2:act_target_init_cast(),
    {noreply, State};

%%全服目标激活
handle_cast({update_open_act_all_target3, Pkey, ActType, Lv}, State) ->
    open_act_all_target3:act_target_cast(Pkey, ActType, Lv),
    {noreply, State};

%%全服目标激活
handle_cast(act_target_init3, State) ->
    open_act_all_target3:act_target_init_cast(),
    {noreply, State};

%% 消费抽返利系统日志
handle_cast({update_consume_back_charge_log, Nickname, ChargeGold, Percent}, State) ->
    NewState = consume_back_charge:update_consume_back_charge_log(State, {Nickname, ChargeGold, Percent}),
    {noreply, NewState};

%% 消费抽返利系统日志
handle_cast({read_consume_back_charge_log, Pkey}, State) ->
    spawn(fun() ->
        consume_back_charge:read_consume_back_charge_log(Pkey, State#state.consume_back_charge_log_list) end),
    {noreply, State};

%% 更新开服活动返利抢购
handle_cast({update_act_back_buy, ActId, OrderId}, State) ->
    open_act_back_buy:update_act_back_buy_cast(ActId, OrderId),
    {noreply, State};

%% 更新合服活动返利抢购
handle_cast({update_merge_act_back_buy, ActId, OrderId}, State) ->
    merge_act_back_buy:update_act_back_buy_cast(ActId, OrderId),
    {noreply, State};

%% 更新节日活动返利抢购
handle_cast({update_festival_back_buy, ActId, OrderId}, State) ->
    festival_back_buy:update_festival_back_buy_cast(ActId, OrderId),
    {noreply, State};

%% 添加中奖信息
handle_cast({cast_cross_lucky_tv_msg3, [SnCur, NickNiame, GoodsId, GoodsNum, AddMoney]}, State) ->
    act_lucky_turn:cast_cross_lucky_tv_msg3(SnCur, NickNiame, GoodsId, GoodsNum, AddMoney),
    {noreply, State};

%% 添加中奖信息
handle_cast({cast_local_lucky_tv_msg3, [SnCur, NickNiame, GoodsId, GoodsNum, AddMoney]}, State) ->
    act_local_lucky_turn:cast_local_lucky_tv_msg3(SnCur, NickNiame, GoodsId, GoodsNum, AddMoney),
    {noreply, State};

%% 添加中奖信息
handle_cast({do_back_cross_gold3, BackGold}, State) ->
    act_lucky_turn:do_back_cross_gold3(BackGold),
    {noreply, State};

%% 添加中奖信息
handle_cast({do_back_local_gold3, BackGold}, State) ->
    act_local_lucky_turn:do_back_local_gold3(BackGold),
    {noreply, State};

%% 一元夺宝
handle_cast({act_one_gold_buy, sys_midnight_refresh}, State) ->
    NewState = act_one_gold_buy:sys_midnight_refresh_cast(State),
    {noreply, NewState};

%% 一元夺宝更新定时器
handle_cast({act_one_gold_buy, update_timer}, State) ->
    NewState = act_one_gold_buy:update_timer(State),
    {noreply, NewState};

handle_cast({get_act_info_center, PlayerLv, BuyNum, RecvList, Sid}, State) ->
    act_one_gold_buy:get_act_info_center_cast(State, PlayerLv, BuyNum, RecvList, Sid),
    {noreply, State};

handle_cast({get_cross_1vn_shop_center, Type, Floor, IsSign, List, Sid}, State) ->
    ?DEBUG("get_cross_1vn_shop_center ~n"),
    cross_1vn:get_cross_1vn_shop_center_cast(State#state.cross_1vn_shop, State#state.cross_1vn_shop_base, Type, Floor, IsSign, List, Sid),
    {noreply, State};

%% 重置商店配置
handle_cast(reset_shop_base, State) ->
    {NewBase, NewRound} = cross_1vn:reset_shop_base(?IF_ELSE(State#state.cross_1vn_shop_round==[],0,State#state.cross_1vn_shop_round)),
    activity_load:dbup_cross_1vn_shop(NewRound, NewBase, []),
    {noreply, State#state{cross_1vn_shop_base = NewBase, cross_1vn_shop_round = NewRound, cross_1vn_shop = []}};

handle_cast({cross_1vn_shop_add, Type, Id}, State) ->
    NewShop =
        case lists:keytake({Type, Id}, 1, State#state.cross_1vn_shop) of
            false -> [{{Type, Id}, 1} | State#state.cross_1vn_shop];
            {value, {{Type, Id}, Count1}, T} ->
                [{{Type, Id}, Count1 + 1} | T]
        end,
    activity_load:dbup_cross_1vn_shop(State#state.cross_1vn_shop_round, State#state.cross_1vn_shop_base, NewShop),
    {noreply, State#state{cross_1vn_shop = NewShop}};

handle_cast({one_gold_buy, buy_center, Args}, State) ->
    act_one_gold_buy:buy_center_cast(State, Args),
    {noreply, State};

handle_cast({festival_red_gift, sys_midnight_refresh}, State) ->
    NewState = festival_red_gift:sys_midnight_refresh_cast(State),
    {noreply, NewState};

handle_cast({festival_red_gift, add_charge_gold, ChargeGold}, State) ->
    NewState = festival_red_gift:add_charge_gold_cast(State, ChargeGold),
    {noreply, NewState};

handle_cast({festival_red_gift, update_timer}, State) ->
    NewState = festival_red_gift:update_timer(State),
    {noreply, NewState};

handle_cast({festival_red_gift, get_act_info, Sid}, State) ->
    festival_red_gift:get_act_info_cast(State, Sid),
    {noreply, State};

handle_cast({festival_red_gift, recv, [{Sid, Pkey, NickName, Sex, Career, Avatar, Sn, HeadId}, Id]}, State) ->
    NewState = festival_red_gift:recv_cast(State, {Sid, Pkey, NickName, Sex, Career, Avatar, Sn, HeadId}, Id),
    {noreply, NewState};

handle_cast({festival_red_gift, get_rank_list_center, Sid, Pkey}, State) ->
    festival_red_gift:get_rank_list_center_cast(State, Sid, Pkey),
    {noreply, State};

handle_cast({festival_red_gift, update_rank_1_key, Ets}, State) ->
    {noreply, State#state{festival_red_gift_1_key = Ets#ets_festival_red_gift.key}};

handle_cast({festival_red_gift, sys_notice_all_client}, State) ->
    festival_red_gift:sys_notice_all_client_cast(State),
    {noreply, State};

handle_cast({festival_red_gift, look_10_center, Sid}, State) ->
    festival_red_gift:look_10_center_cast(Sid),
    {noreply, State};

handle_cast({act_limit_xian, get_score_info_center, Args}, State) ->
    act_limit_xian:get_score_info_center_cast(Args),
    {noreply, State};

handle_cast({act_limit_xian, add_score, Args}, State) ->
    act_limit_xian:add_score_cast(Args),
    {noreply, State};

handle_cast({act_limit_xian, init_data, DataList}, State) ->
    act_limit_xian:init_data_cast(DataList),
    {noreply, State};

handle_cast({act_limit_pet, get_score_info_center, Args}, State) ->
    act_limit_pet:get_score_info_center_cast(Args),
    {noreply, State};

handle_cast({act_limit_pet, add_score, Args}, State) ->
    act_limit_pet:add_score_cast(Args),
    {noreply, State};

handle_cast({act_limit_pet, init_data, Args}, State) ->
    act_limit_pet:init_data_cast(Args),
    {noreply, State};

handle_cast({act_wishing_well, add_score, Args}, State) ->
    NewLog = act_wishing_well:add_score(State#state.act_wishing_well_log, Args),
    self() ! act_wishing_well_refresh,
    {noreply, State#state{act_wishing_well_log = NewLog}};

handle_cast({act_wishing_well, get_rank_info, Pkey, Sid}, State) ->
    act_wishing_well:get_rank_info(State#state.act_wishing_well_rank, Pkey, Sid),
    {noreply, State};

handle_cast({act_wishing_well, end_reward, Base}, State) ->
    act_wishing_well:end_reward(State#state.act_wishing_well_log, Base),
    {noreply, State#state{act_wishing_well_log = [], act_wishing_well_rank = []}};


handle_cast({cross_act_wishing_well, end_reward, Base, GroupIdList, GroupList}, State) ->
    Data0 = State#state.cross_act_wishing_well_log,
    NewRanks = cross_act_wishing_well:rank_list(Data0, GroupList, GroupIdList),
    cross_act_wishing_well:end_reward(NewRanks, Base),
    {noreply, State#state{cross_act_wishing_well_log = [], cross_act_wishing_well_rank = []}};

handle_cast({cross_act_wishing_well, add_score, Args}, State) ->
    NewLog = cross_act_wishing_well:add_score(State#state.cross_act_wishing_well_log, Args),
    self() ! cross_act_wishing_well_refresh,
    {noreply, State#state{cross_act_wishing_well_log = NewLog}};


handle_cast({cross_act_wishing_well, get_rank_info, Node, Pkey, Sid, Sn}, State) ->
    GroupList = activity_area_group:get_group_list(data_cross_act_wishing_well, cross_act_wishing_well),
    Group = activity_area_group:get_sn_group(Sn, GroupList),
    {Score, Rank, List1} = cross_act_wishing_well:get_info(Group, Pkey, State#state.cross_act_wishing_well_rank),
    {ok, Bin} = pt_439:write(43982, {Rank, Score, List1}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};


handle_cast(_Info, State) ->
    ?ERR("activity_handld cast info ~p~n", [_Info]),
    {noreply, State}.

%%http请求所有活动文件 --已弃用

handle_info(re_set_act_wishing_well, State) ->
    {noreply, State#state{act_wishing_well_log = []}};

handle_info(refresh_all_act, State) ->
    {noreply, State};

handle_info({act_one_gold_buy, timer_cacl, ActNum}, State) ->
    NewState = act_one_gold_buy:timer_cacl(State, ActNum),
    {noreply, NewState};

handle_info({cross_1vn, init_data}, State) ->
    {Round, Shop, Base} = activity_load:dbget_cross_1vn_shop(),
    {noreply, State#state{cross_1vn_shop_round = Round, cross_1vn_shop = Shop, cross_1vn_shop_base = Base}};

handle_info({festival_red_gift, timer_cacl}, State) ->
    NewState = festival_red_gift:timer_cacl(State),
    {noreply, NewState};

handle_info({festival_red_gift, init_data}, State) ->
    NewState = festival_red_gift:init_data(State),
    {noreply, NewState};


%%刷新许愿池(单)
handle_info(act_wishing_well_refresh, State) ->
    util:cancel_ref([State#state.act_wishing_well_ref]),
    Data0 = State#state.act_wishing_well_log,
    NewRanks = act_wishing_well:sort_rank(Data0),
    Ref = erlang:send_after(30 * 1000, self(), act_wishing_well_refresh),
    {noreply, State#state{act_wishing_well_ref = Ref, act_wishing_well_log = NewRanks, act_wishing_well_rank = NewRanks}};

%%刷新许愿池(跨)
handle_info(cross_act_wishing_well_refresh, State) ->
    util:cancel_ref([State#state.act_wishing_well_ref]),
    Data0 = State#state.cross_act_wishing_well_log,
    GroupIdList = activity_area_group:get_id_list(data_cross_act_wishing_well, cross_act_wishing_well),
    GroupList = activity_area_group:get_group_list(data_cross_act_wishing_well, cross_act_wishing_well),
    NewRanks = cross_act_wishing_well:rank_list(Data0, GroupList, GroupIdList),
    Ref = erlang:send_after(30 * 1000, self(), cross_act_wishing_well_refresh),
    {noreply, State#state{cross_act_wishing_well_ref = Ref, cross_act_wishing_well_rank = NewRanks}};


%%--------------冲榜活动-----------
%%gm 刷榜
handle_info(gm_act_rank_refresh, State) ->
    ActRank = State#state.act_rank,
    F = fun(Type, AccDict) ->
        case dict:find(Type, AccDict) of
            error ->
                AccDict;
            {ok, Ar} ->
                NewAr = Ar#ar{reward_list = []},
                dict:store(Type, NewAr, AccDict)
        end
    end,
    NewDict = lists:foldl(F, ActRank#rank_act.dict, lists:seq(1, 6)),
    NewActRank = ActRank#rank_act{dict = NewDict},
    NewState = State#state{
        act_rank = NewActRank
    },
    self() ! act_rank_refresh,
    {noreply, NewState};
%%刷新冲榜活动
handle_info(act_rank_refresh, State) ->
    util:cancel_ref([State#state.act_rank_ref]),
    act_rank:reload_rank(State#state.act_rank#rank_act.dict),
    RefTime = 600,
    Now = util:unixtime(),
    Date = util:unixdate(),
    NextDate = Date + ?ONE_DAY_SECONDS,
    NextRefTime =
        case Now + RefTime + 1 >= NextDate of
            true -> %%下次更新跨天，在跨天前10秒，重排
                min(RefTime, max(5, NextDate - Now - 10));
            false ->
                RefTime
        end,
    Ref = erlang:send_after(NextRefTime * 1000, self(), act_rank_refresh),
    {noreply, State#state{act_rank_ref = Ref}};

%%更新冲榜活动数据
handle_info({act_rank, Data}, State) ->
    {Type, L} = Data,
    ?DEBUG("********~n"),
    ?IF_ELSE(Type == 4, ?DEBUG("Data ~p~n", [Data]), skip),
    case is_list(L) of
        false -> {noreply, State};
        true ->
            ActRank = State#state.act_rank,
            NewDict =
                case dict:find(Type, ActRank#rank_act.dict) of
                    error ->
                        Ar = #ar{type = Type, rank = L},
                        dict:store(Type, Ar, ActRank#rank_act.dict);
                    {ok, Ar} ->
                        NewAr = Ar#ar{rank = L, reward_list = []},
                        dict:store(Type, NewAr, ActRank#rank_act.dict)
                end,
            NewActRank = ActRank#rank_act{dict = NewDict},
            NewState = State#state{
                act_rank = NewActRank
            },
            act_rank:notice_2(Type, NewDict, ActRank#rank_act.dict),
            {noreply, NewState}
    end;

%%获取冲榜活动信息
handle_info({get_act_rank, Sid, Pkey}, State) ->
    act_rank:get_act_rank_info(State#state.act_rank#rank_act.dict, Sid, Pkey),
    {noreply, State};

%%获取名人堂信息
handle_info({get_hof, Sid, Pkey}, State) ->
    act_rank:get_hof(State#state.act_rank#rank_act.dict, Sid, Pkey),
    {noreply, State};

%%获取冲榜排行玩家信息
handle_info({get_act_rank_player_info, Type, Sid, Pkey}, State) ->
    act_rank:get_rank_player(State#state.act_rank#rank_act.dict, Type, Sid, Pkey),
    {noreply, State};

%%晚上零点冲榜处理
handle_info(mignight_rank_handle, State) ->
    NewDict = act_rank:reward(State#state.act_rank#rank_act.dict),
    NewActRank = State#state.act_rank#rank_act{
        dict = NewDict
    },
    case NewDict == State#state.act_rank#rank_act.dict of
        true -> skip;
        false -> activity_load:dbup_act_rank(NewActRank)
    end,
    {noreply, State#state{act_rank = NewActRank}};

%%冲榜广播
handle_info(act_rank_notice, State) ->
    act_rank:notice(util:unixtime(), State#state.act_rank#rank_act.dict),
    {noreply, State};

%%---------结婚排行榜--------
%%获取结婚排行信息
handle_info({get_marry_rank_info, Node, Pid, Pkey, ReceiveState}, State) ->
    marry_rank:get_rank_player(Node, State#state.marry_rank_list, Pid, Pkey, ReceiveState),
    {noreply, State};

%%更新结婚排行信息
handle_info({update_marry_rank, Bkey, BName, BAvatar, Gkey, GName, GAvatar}, State) ->
    LeaveTime = activity:get_leave_time(data_marry_rank),
    if
        LeaveTime =< 0 ->
            NewMarryRankList = [];
        true ->
            MarryRankList = State#state.marry_rank_list,
            Now = util:unixtime(),
            NewPlayerInfo = #marry_rank_info{
                bpkey = Bkey,
                bname = BName,
                bavatar = BAvatar,
                gpkey = Gkey,
                gname = GName,
                gavatar = GAvatar,
                rank = 0,
                marry_time = Now
            },
            marry_rank:dbup_marry_rank(NewPlayerInfo),
            NewMarryRankList = marry_rank:sort_rank_list([NewPlayerInfo | MarryRankList])
    end,
    {noreply, State#state{marry_rank_list = NewMarryRankList}};

%%刷新结婚榜活动
handle_info(marry_rank_refresh, State) ->
    util:cancel_ref([State#state.marry_rank_ref]),
    Data = marry_rank:reload_rank(),
    RefTime = 600,
    Now = util:unixtime(),
    Date = util:unixdate(),
    NextDate = Date + ?ONE_DAY_SECONDS,
    NextRefTime =
        case Now + RefTime + 1 >= NextDate of
            true -> %%下次更新跨天，在跨天前10秒，重排
                min(RefTime, max(5, NextDate - Now - 10));
            false ->
                RefTime
        end,
    Ref = erlang:send_after(NextRefTime * 1000, self(), marry_rank_refresh),
    {noreply, State#state{marry_rank_ref = Ref, marry_rank_list = Data}};

%% 清数据
handle_info(marry_rank_reward, State) ->
    ?DEBUG("marry_rank_reward ~n"),
    marry_rank:delete_marry_rank(),
    self() ! marry_rank_refresh,
    {noreply, State#state{marry_rank_list = []}};

%%---------单服消费排行榜--------
%%获取消费排行信息
handle_info({get_consume_rank_info, Pid, Consume}, State) ->
    consume_rank:get_rank_player(lists:sublist(State#state.consume_rank_list, 100), Pid, Consume),
    {noreply, State};

%%更新消费排行信息
handle_info({update_consume_rank, Pkey, NickName, Consume, Lv}, State) ->
    ConsumeRankList = State#state.consume_rank_list,
    Now = util:unixtime(),
    case lists:keytake(Pkey, #consume_rank_info.pkey, ConsumeRankList) of
        false ->
            NewPlayerInfo = #consume_rank_info{
                pkey = Pkey,
                name = NickName,
                consume_gold = Consume,
                change_time = Now,
                rank = 0,
                lv = Lv
            },
            NewConsumeRankList0 = [NewPlayerInfo | ConsumeRankList];
        {value, PlayerInfo, List} ->
            CounsumeGold = PlayerInfo#consume_rank_info.consume_gold,
            NewPlayerInfo = PlayerInfo#consume_rank_info{consume_gold = CounsumeGold + Consume, change_time = Now, lv = Lv},
            NewConsumeRankList0 = [NewPlayerInfo | List]
    end,
    Base = consume_rank:get_act(),
    NewConsumeRankList = consume_rank:sort_rank_list(NewConsumeRankList0, Base),
    {noreply, State#state{consume_rank_list = NewConsumeRankList}};

%%刷新消费榜活动
handle_info(consume_rank_refresh, State) ->
    util:cancel_ref([State#state.consume_rank_ref]),
    case consume_rank:get_act() of
        [] ->
            Data = [];
        Base ->
            Data = consume_rank:reload_rank(Base)
    end,
    RefTime = 600,
    Now = util:unixtime(),
    Date = util:unixdate(),
    NextDate = Date + ?ONE_DAY_SECONDS,
    NextRefTime =
        case Now + RefTime + 1 >= NextDate of
            true -> %%下次更新跨天，在跨天前10秒，重排
                min(RefTime, max(5, NextDate - Now - 10));
            false ->
                RefTime
        end,
    Ref = erlang:send_after(NextRefTime * 1000, self(), consume_rank_refresh),
    {noreply, State#state{consume_rank_ref = Ref, consume_rank_list = Data}};

%%更新消费榜活动数据
handle_info({consume_rank, Data}, State) ->
    case is_list(Data) of
        false -> {noreply, State};
        true ->
            NewState = State#state{
                consume_rank_list = Data
            },
            {noreply, NewState}
    end;

%% 开奖
handle_info({consume_rank_reward, Base}, State) ->
    Data0 = consume_rank:reload_rank(Base),
    Data = consume_rank:sort_rank_list_limit(Data0, Base),
    consume_rank:reward(Data, Base),
    consume_rank:clean(),
    {noreply, State#state{consume_rank_list = []}};


%%---------单服充值排行榜--------
%%获取充值排行信息
handle_info({get_recharge_rank_info, Pid, Recharge}, State) ->
    recharge_rank:get_rank_player(State#state.recharge_rank_list, Pid, Recharge),
    {noreply, State};

%%更新充值排行信息
handle_info({update_recharge_rank, Pkey, NickName, Recharge, Lv}, State) ->
    RechargeRankList = State#state.recharge_rank_list,
    Now = util:unixtime(),
    case lists:keytake(Pkey, #recharge_rank_info.pkey, RechargeRankList) of
        false ->
            NewPlayerInfo = #recharge_rank_info{
                pkey = Pkey,
                name = NickName,
                recharge_gold = Recharge,
                lv = Lv,
                change_time = Now,
                rank = 0
            },
            NewRechargeRankList0 = [NewPlayerInfo | RechargeRankList];
        {value, PlayerInfo, List} ->
            RechargeGold = PlayerInfo#recharge_rank_info.recharge_gold,
            NewPlayerInfo = PlayerInfo#recharge_rank_info{recharge_gold = RechargeGold + Recharge, change_time = Now, lv = Lv},
            NewRechargeRankList0 = [NewPlayerInfo | List]
    end,
    case recharge_rank:get_act() of
        [] ->
            NewRechargeRankList = [];
        Base ->
            NewRechargeRankList = recharge_rank:sort_rank_list(NewRechargeRankList0, Base)
    end,
    {noreply, State#state{recharge_rank_list = NewRechargeRankList}};


%%刷新充值榜活动
handle_info(recharge_rank_refresh, State) ->
    util:cancel_ref([State#state.recharge_rank_ref]),
    case recharge_rank:get_act() of
        [] ->
            Data = [];
        Base ->
            Data = recharge_rank:reload_rank(Base)
    end,
    RefTime = 600,
    Now = util:unixtime(),
    Date = util:unixdate(),
    NextDate = Date + ?ONE_DAY_SECONDS,
    NextRefTime =
        case Now + RefTime + 1 >= NextDate of
            true -> %%下次更新跨天，在跨天前10秒，重排
                min(RefTime, max(5, NextDate - Now - 10));
            false ->
                RefTime
        end,
    Ref = erlang:send_after(NextRefTime * 1000, self(), recharge_rank_refresh),
    {noreply, State#state{recharge_rank_ref = Ref, recharge_rank_list = Data}};

%%更新消费榜活动数据
handle_info({recharge_rank, Data}, State) ->
    case is_list(Data) of
        false -> {noreply, State};
        true ->
            NewState = State#state{
                recharge_rank_list = Data
            },
            {noreply, NewState}
    end;

%% 开奖
handle_info({recharge_rank_reward, Base}, State) ->
    Data0 = recharge_rank:reload_rank(Base),
    Data = recharge_rank:sort_rank_list_limit(Data0, Base),
    recharge_rank:reward(Data, Base),
    recharge_rank:clean(),
    {noreply, State#state{recharge_rank_list = []}};


%%------------每日充值活动----------
%%初始化
handle_info(daily_charge_init, State) ->
    Sql = io_lib:format("select pkey,nickname,goods_id from log_daily_charge order by `time` desc limit 30", []),
    L = db:get_all(Sql),
    RecordList = [{Pkey, util:to_list(Name), GoodsId} || [Pkey, Name, GoodsId] <- L],
    {noreply, State#state{daily_charge_record = RecordList}};

%%记录抽奖记录
handle_info({add_daily_charge_record, Pkey, Name, GoodsId}, State) ->
    List = State#state.daily_charge_record ++ [{Pkey, Name, GoodsId}],
    Len = length(List),
    NewList = lists:sublist(List, max(1, Len - 29), 30),
    {noreply, State#state{daily_charge_record = NewList}};

%%------------累充转盘活动------------
handle_info(acc_charge_turntable_init, State) ->
    Sql = io_lib:format("select pkey,nickname,goods_id,goods_num from log_acc_charge_turntable order by `time` desc limit 30", []),
    L = db:get_all(Sql),
    RecordList = [{Pkey, util:to_list(Name), GoodsId, GoodsNum} || [Pkey, Name, GoodsId, GoodsNum] <- L],
    NewState = State#state{acc_charge_turntable_record = RecordList},
    {noreply, NewState};
%%记录抽奖记录
handle_info({add_acc_charge_return_record, Pkey, Name, GoodsList}, State) ->
    AddList = [{Pkey, Name, GoodsId, Num} || {GoodsId, Num} <- GoodsList],
    #state{
        acc_charge_turntable_record = List
    } = State,
    NewList = List ++ AddList,
    Len = length(NewList),
    NewList1 = lists:sublist(NewList, max(1, Len - 29), 30),
    NewState = State#state{
        acc_charge_turntable_record = NewList1
    },
    {noreply, NewState};

%%----------抢购商店-----------
%%增加全服购买记录
handle_info({add_lim_shop_buy, Id, AddTimes}, State) ->
    #lim_shop{
        dict = Dict
    } = State#state.lim_shop,
    NewDict =
        case dict:find(Id, Dict) of
            error -> dict:store(Id, {Id, AddTimes}, Dict);
            {ok, {_, BuyNum}} -> dict:store(Id, {Id, BuyNum + AddTimes}, Dict)
        end,
    NewLimShop = State#state.lim_shop#lim_shop{dict = NewDict},
    {noreply, State#state{lim_shop = NewLimShop}};

%%零点更新全服购买记录
handle_info(lim_shop_refresh, State) ->
    NewLimShop = lim_shop:night_refresh_global(State#state.lim_shop),
    {noreply, State#state{lim_shop = NewLimShop}};

%%定时减少全服商品可购买次数
handle_info(global_auto_del_buy_num, State) ->
    util:cancel_ref([State#state.lim_shop#lim_shop.auto_del_ref]),
    Time = util:rand(600, 900),
    NewRef = erlang:send_after(Time * 1000, self(), global_auto_del_buy_num),
    NewLimShop = lim_shop:auto_del_global_buy_num(State#state.lim_shop),
    NewLimShop1 = NewLimShop#lim_shop{auto_del_ref = NewRef},
    {noreply, State#state{lim_shop = NewLimShop1}};

%%打印
handle_info({info, Type}, State) ->
    case Type of
        lim_shop ->
            io:format("lim_shop ~p~n", [State#state.lim_shop]);
        _ ->
            skip
    end,
    {noreply, State};


%%-------------全民福利------------

handle_info(_Info, State) ->
    ?ERR("activity_handld info ~p~n", [_Info]),
    {noreply, State}.

