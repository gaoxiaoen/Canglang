%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 迷宫寻宝
%%% @end
%%% Created : 03. 三月 2017 13:43
%%%-------------------------------------------------------------------
-module(act_map).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init_ets/0,
    init/0,
    init/1,
    midnight_refresh/1,
    sys_midnight_refresh/1,
    get_act/0,
    gm_reset/1,
    gm49/0,

    get_state/1,
    get_act_info/1,
    get_base_reward/0,
    get_record/1,
    go_map/1
]).

gm49() ->
    StActMap = lib_dict:get(?PROC_STATUS_ACT_MAP),
    lib_dict:put(?PROC_STATUS_ACT_MAP, StActMap#st_act_map{step = 49}),
    update_act_map(),
    ok.

gm_reset(_Player) ->
    StActMap = lib_dict:get(?PROC_STATUS_ACT_MAP),
    lib_dict:put(?PROC_STATUS_ACT_MAP, StActMap#st_act_map{op_time = 0}),
    update_act_map().

init_ets() ->
    ets:new(?ETS_MAP_LOG, [{keypos, #ets_map_log.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_MAP_LOG_SYS, [{keypos, #ets_map_log_sys.act_id} | ?ETS_OPTIONS]),
    ok.

init() ->
    case get_act() of
        [] ->
            skip;
        #base_act_map{act_id = ActId} ->
            EtsActMapSys = activity_load:dbget_all_act_map(ActId),
            ets:insert(?ETS_MAP_LOG_SYS, EtsActMapSys),
            ok
    end.

init(#player{key = Pkey} = Player) ->
    StActMap =
        case player_util:is_new_role(Player) of
            true -> #st_act_map{pkey = Pkey};
            false -> activity_load:dbget_act_map(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_ACT_MAP, StActMap),
    update_act_map(),
    Player.

update_act_map() ->
    StActMap = lib_dict:get(?PROC_STATUS_ACT_MAP),
    #st_act_map{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpenTime
    } = StActMap,
    case get_act() of
        [] ->
            NewStActMap = #st_act_map{pkey = Pkey};
        #base_act_map{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(OpenTime, Now),
            if
                BaseActId =/= ActId ->
                    NewStActMap = #st_act_map{pkey = Pkey, act_id = BaseActId, op_time = Now};
                Flag == false ->
                    NewStActMap = #st_act_map{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStActMap = StActMap
            end
    end,
    lib_dict:put(?PROC_STATUS_ACT_MAP, NewStActMap).

lookup_sys_act_map(ActId) ->
    case ets:lookup(?ETS_MAP_LOG_SYS, ActId) of
        [] ->
            Ets = #ets_map_log_sys{act_id = ActId},
            ets:insert(?ETS_MAP_LOG_SYS, Ets),
            Ets;
        [Ets] ->
            Ets
    end.

lookup_act_map(Pkey) ->
    case ets:lookup(?ETS_MAP_LOG, Pkey) of
        [] ->
            Ets = #ets_map_log{pkey = Pkey},
            ets:insert(?ETS_MAP_LOG, Ets),
            Ets;
        [Ets] ->
            Ets
    end.

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_act_map().

sys_midnight_refresh(_ResetTime) ->
    ets:delete_all_objects(?ETS_MAP_LOG_SYS),
    ok.

get_state(_Player) ->
    StActMap = lib_dict:get(?PROC_STATUS_ACT_MAP),
    #st_act_map{
        use_free_num = UseFreeNum
    } = StActMap,
    case get_act() of
        [] ->
            -1;
        #base_act_map{act_id = BaseActId, act_info = ActInfo} ->
            Ets = lookup_sys_act_map(BaseActId),
            SysFreeNum = Ets#ets_map_log_sys.pass_num div ?ACT_MAP_PASS_NUM_FREE,
            Args = activity:get_base_state(ActInfo),
            if
                UseFreeNum >= 3 -> {0, Args};
                UseFreeNum < SysFreeNum -> {1, Args};
                true -> {0, Args}
            end
    end.

get_act_info(_Player) ->
    StActMap = lib_dict:get(?PROC_STATUS_ACT_MAP),
    #st_act_map{
        step = Step,
        use_free_num = UseFreeNum,
        recv_list = RecvList
    } = StActMap,
    case get_act() of
        [] ->
            {0, 0, 0, 0, 0, 0, []};
        #base_act_map{act_id = BaseActId, open_info = OpenInfo} ->
            EtsActMapSys = lookup_sys_act_map(BaseActId),
            LTime = activity:calc_act_leave_time(OpenInfo),
            SysPassNum = EtsActMapSys#ets_map_log_sys.pass_num,
            FreeNum = max(0, min(3, SysPassNum div ?ACT_MAP_PASS_NUM_FREE) - UseFreeNum),
            CostGold = ?IF_ELSE(FreeNum > 0, 0, ?ACT_MAP_STEP_COST),
            NeedNum = ?ACT_MAP_PASS_NUM_FREE - SysPassNum rem ?ACT_MAP_PASS_NUM_FREE,
            {LTime, Step, CostGold, FreeNum, SysPassNum, NeedNum, RecvList}
    end.

%% 获取面板奖励列表
get_base_reward() ->
    case get_act() of
        [] ->
            {[], []};
        #base_act_map{reward_type = RewardType} ->
            case data_act_map_reward:get_ids_by_reward_type(RewardType) of
                [] ->
                    {[], []};
                Ids ->
                    F = fun(Id, {AccList1, AccList2}) ->
                        #base_act_map_reward{goods_list = GoodsList, order_id = OrderId, type = Type} = data_act_map_reward:get(Id),
                        NewAccList1 = [[OrderId] ++ tuple_to_list(hd(GoodsList)) ++ [Type] | AccList1],
                        NewAccList2 = ?IF_ELSE(Type == ?ACT_MAP_REWARD_2, lists:map(fun({G, N}) ->
                            [G, N] end, GoodsList), AccList2),
                        {NewAccList1, NewAccList2}
                        end,
                    lists:foldl(F, {[], []}, Ids)
            end
    end.

%% 获取玩家日志记录
get_record(#player{key = Pkey}) ->
    case get_act() of
        [] ->
            {[], []};
        #base_act_map{act_id = BaseActId} ->
            EtsActMap = lookup_act_map(Pkey),
            EtsActMapSys = lookup_sys_act_map(BaseActId),
            LogList = EtsActMap#ets_map_log.log_list,
            NewLogList =
                if %% 记录取最新的15条
                    length(LogList) > 10 -> lists:sublist(LogList, 10);
                    true -> LogList
                end,
            SysLogList = EtsActMapSys#ets_map_log_sys.log_list,
            NewSysLogList =
                if
                    length(SysLogList) > 15 -> lists:sublist(SysLogList, 15);
                    true -> SysLogList
                end,
            {NewLogList, NewSysLogList}
    end.

check_go_map(#player{} = Player) ->
    StActMap = lib_dict:get(?PROC_STATUS_ACT_MAP),
    #st_act_map{
        step = Step,
        use_free_num = UseFreeNum
    } = StActMap,
    case get_act() of
        [] ->
            {fail, 0};
        #base_act_map{reward_type = RewardType, act_id = BaseActId} ->
            EtsActMapSys = lookup_sys_act_map(BaseActId),
            SumFreeNum = min(3, EtsActMapSys#ets_map_log_sys.pass_num div ?ACT_MAP_PASS_NUM_FREE),
            CostGold = ?IF_ELSE(SumFreeNum =< UseFreeNum, ?ACT_MAP_STEP_COST, 0),
            case money:is_enough(Player, CostGold, gold) of
                false ->
                    {fail, 5}; %% 元宝不足
                true ->
                    Ids = data_act_map_reward:get_ids_by_reward_type(RewardType),
                    if
                        Step >= length(Ids) -> {fail, 8}; %% 到终点了
                        true -> {true, Ids, CostGold, BaseActId}
                    end
            end
    end.


%% 寻宝
go_map(#player{key = Pkey} = Player) ->
    StActMap = lib_dict:get(?PROC_STATUS_ACT_MAP),
    #st_act_map{
        pass_num = PassNum,
        step = Step,
        use_free_num = UseFreeNum,
        recv_list = RecvList
    } = StActMap,
    case check_go_map(Player) of
        {fail, Res} ->
            {Player, Res, 0, []};
        {true, Ids, CostGold, BaseActId} ->
            NextStep = min(length(Ids), util:rand(1, 6) + Step),
            RandStep = NextStep - Step,
            %% 固定奖励
            NextId = lists:nth(NextStep, Ids),
            #base_act_map_reward{goods_list = GoodsList, type = Type} = data_act_map_reward:get(NextId),
            {GoodsType1, GoodsNum1} = ?IF_ELSE(Type == ?ACT_MAP_REWARD_1, hd(GoodsList), {0, 0}),
            %% 密保奖励
            {GoodsType2, GoodsNum2} = ?IF_ELSE(Type == ?ACT_MAP_REWARD_2, util:list_rand(GoodsList), {0, 0}),
            %% 标底奖励
            {GoodsType3, GoodsNum3} = ?IF_ELSE(Type == ?ACT_MAP_REWARD_3, get_reward_type3(PassNum, GoodsList), {0, 0}),
            F = fun({GType, GNum}) ->
                if
                    GType == 0 -> [];
                    true -> [{GType, GNum}]
                end
                end,
            RewardList = lists:flatmap(F, [{GoodsType1, GoodsNum1}, {GoodsType2, GoodsNum2}, {GoodsType3, GoodsNum3}]),
            RewardList2 = get_new_reward_list(Step + 1, NextStep - 1, Ids, PassNum),
%%             ?DEBUG("RewardList:~p RewardList2:~p~n", [RewardList, RewardList2]),
            NPlayer = money:add_no_bind_gold(Player, -CostGold, 611, GoodsType1, GoodsNum1),
            NewRecvList = lists:seq(Step + 1, NextStep) ++ RecvList,
            %% 处理玩家数据
            NStActMap =
                StActMap#st_act_map{
                    step = NextStep,
                    use_free_num = UseFreeNum + ?IF_ELSE(CostGold == 0, 1, 0),
                    recv_list = NewRecvList
                },
            if
                NextStep /= length(Ids) ->
                    AddSysPassNum = 0,
                    NewStActMap = NStActMap;
                true ->
                    AddSysPassNum = 1,
                    %% 重回至起点
                    NewStActMap = NStActMap#st_act_map{step = 0, pass_num = PassNum + 1, recv_list = []}
            end,
            %% 处理日志
            update_ets(Pkey, Player#player.nickname, BaseActId, RewardList, AddSysPassNum),
            lists:map(fun({GId, GNum}) ->
                update_ets(Pkey, Player#player.nickname, BaseActId, [{GId, GNum}], 0) end, RewardList2),
            lib_dict:put(?PROC_STATUS_ACT_MAP, NewStActMap),
            activity_load:dbup_act_map(NewStActMap),
            NewRewardList = lists:map(fun({GId99, GNum99}) ->
                {GId99, GNum99, Player#player.drop_bind} end, RewardList ++ RewardList2),
            GiveGoodsList = goods:make_give_goods_list(612, NewRewardList),
            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
            activity:get_notice(Player, [36], true),
            LL = lists:map(fun({GId, GNum}) -> [GId, GNum] end, RewardList ++ RewardList2),
            {NewPlayer, 1, RandStep, LL}
    end.

get_new_reward_list(Step, EndStep, Ids, PassNum) ->
    if
        EndStep < Step -> [];
        true ->
            F0 = fun(NextStep) ->
                NextId = lists:nth(NextStep, Ids),
                #base_act_map_reward{goods_list = GoodsList, type = Type} = data_act_map_reward:get(NextId),
                {GoodsType1, GoodsNum1} = ?IF_ELSE(Type == ?ACT_MAP_REWARD_1, hd(GoodsList), {0, 0}),
                %% 密保奖励
                {GoodsType2, GoodsNum2} = ?IF_ELSE(Type == ?ACT_MAP_REWARD_2, util:list_rand(GoodsList), {0, 0}),
                %% 标底奖励
                {GoodsType3, GoodsNum3} = ?IF_ELSE(Type == ?ACT_MAP_REWARD_3, get_reward_type3(PassNum, GoodsList), {0, 0}),
                F = fun({GType, GNum}) ->
                    if
                        GType == 0 -> [];
                        true -> [{GType, GNum}]
                    end
                    end,
                lists:flatmap(F, [{GoodsType1, GoodsNum1}, {GoodsType2, GoodsNum2}, {GoodsType3, GoodsNum3}])
                 end,
            lists:flatmap(F0, lists:seq(Step, EndStep))
    end.

%% 获取标底奖励
get_reward_type3(_Num, GoodsList3) ->
    if %% 暂时写死
%%         Num < 3 ->
%%             {0, 0};
%%         Num < 6 ->
%%             Rand = util:rand(1, 10000),
%%             if
%%                 Rand < 7000 ->
%%                     {0, 0};
%%                 true ->
%%                     util:list_rand(GoodsList3)
%%             end;
        true ->
            Rand = util:rand(1, 10000),
            if
                Rand < 9000 ->
                    {0, 0};
                true ->
                    util:list_rand(GoodsList3)
            end
    end.

%% 处理玩家日志
update_ets(Pkey, NickName, BaseActId, RewardList, AddSysPassNum) ->
    {GoodsType, GoodsNum} =
        if
            RewardList == [] ->
                {0, 0};
            true ->
                hd(RewardList)
        end,
    Now = util:unixtime(),
    EtsActMap = lookup_act_map(Pkey),
    EtsActMapSys = lookup_sys_act_map(BaseActId),
    LogList =
        if
            length(EtsActMap#ets_map_log.log_list) > 50 -> lists:sublist(EtsActMap#ets_map_log.log_list, 20);
            true -> EtsActMap#ets_map_log.log_list
        end,
    NewLog = [Now, GoodsType, GoodsNum],
    NewLogList = [NewLog | LogList],
    NewEtsActMap = EtsActMap#ets_map_log{log_list = NewLogList},
    ets:insert(?ETS_MAP_LOG, NewEtsActMap),
    %% 处理系统日志
    SysRecordList =
        if
            length(EtsActMapSys#ets_map_log_sys.log_list) > 100 ->
                lists:sublist(EtsActMapSys#ets_map_log_sys.log_list, 20);
            true -> EtsActMapSys#ets_map_log_sys.log_list
        end,
    NewSysLog = [NickName, Now, GoodsType, GoodsNum],
    NewSysRecordList = [NewSysLog | SysRecordList],
    NewEtsActMapSys =
        EtsActMapSys#ets_map_log_sys{
            log_list = NewSysRecordList,
            pass_num = AddSysPassNum + EtsActMapSys#ets_map_log_sys.pass_num
        },
    ets:insert(?ETS_MAP_LOG_SYS, NewEtsActMapSys).

get_act() ->
    case activity:get_work_list(data_act_map) of
        [] -> [];
        [Base | _] -> Base
    end.