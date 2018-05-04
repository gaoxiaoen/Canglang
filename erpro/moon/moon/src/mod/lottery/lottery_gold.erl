%%----------------------------------------------------
%% 晶钻转盘活动
%% @author jackguan@jieyou.cn
%% @end
%%----------------------------------------------------
-module(lottery_gold).

-export([
        get_info/1
        ,lottery/1
        ,login/1
        ,send_reward/1
        ,gm/1
    ]).

%% include files
-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("item.hrl").
-include("lottery.hrl").
-include("campaign.hrl").
-include("storage.hrl").

-define(lottery_id, 20130419). %% 当前活动Id 有新活动时需要修改此ID
-define(max_layer, 6). %% 转盘最大层数

-ifdef(debug).
%% 活动开始时间
-define(begin_time, util:datetime_to_seconds({{2013, 03, 25}, {0, 0, 1}})).
-else.
%% 活动开始时间
-define(begin_time, util:datetime_to_seconds({{2013, 03, 29}, {0, 0, 1}})).
-endif.

%% 活动结束时间
-define(end_time, util:datetime_to_seconds({{2013, 04, 02}, {23, 59, 59}})).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
%% 登录初始化
%% @spec login(Role) -> NewRole
%% Role | NewRole = #role{}
login(Role = #role{id = {_Rid, _SrvId}, pid = _Pid, name = _Name, campaign = Camp = #campaign_role{lottery_gold = CampGold = #campaign_lottery_gold{id = CampId, gold = Gold}}}) ->
    {AdmCampId, _AdmStartTime, _AdmEndTime} = get_camp_conf(),
    case Gold > 0 of %% 检测奖励是否已经发放
        true -> %% 未发
            case CampId =:= AdmCampId of %% 检测是否为当前活动
                true ->
                    case role_gain:do([#gain{label = gold, val = Gold}], Role) of
                        {ok, NewRole} ->
                            notice:inform(util:fbin(?L(<<"获得 ~w晶钻">>), [Gold])),
                            NewRole2 = NewRole#role{campaign = Camp#campaign_role{lottery_gold = CampGold#campaign_lottery_gold{gold = 0}}},
                            log:log(log_gold, {<<"晶钻转盘">>, <<"登陆:发放晶钻">>, <<"晶钻转盘">>, Role, NewRole}),
                            NewRole2;
                        _ -> Role
                    end;
                false -> %% 否，层数重置
                    case role_gain:do([#gain{label = gold, val = Gold}], Role) of
                        {ok, NewRole} ->
                            notice:inform(util:fbin(?L(<<"获得 ~w晶钻">>), [Gold])),
                            NewRole2 = NewRole#role{campaign = Camp#campaign_role{lottery_gold = CampGold#campaign_lottery_gold{id = AdmCampId, gold = 0, layer = 1}}},
                            log:log(log_gold, {<<"晶钻转盘">>, <<"登陆:发放晶钻">>, <<"晶钻转盘">>, Role, NewRole}),
                            NewRole2;
                        _ -> Role
                    end
            end;
        false -> %% 已发
            case CampId =:= AdmCampId of %% 检测是否为当前活动
                true-> Role;
                false ->
                    Role#role{campaign = Camp#campaign_role{lottery_gold = CampGold#campaign_lottery_gold{id = AdmCampId, layer = 1}}}
            end
    end;
login(Role) -> Role.

%% @spec get_info(Role) -> {ok, Data}
%% @doc
%% <pre>
%% Role = #role{} 角色信息
%% Data = tuple{} 面板信息
%% 获取转盘面板信息
%% </pre>
get_info(Role) ->
    Data = get_reward_info(Role),
    {ok, Data}.

%% @spec lottery(Role) -> {ok, NewRole} | {error, Error}
%% @doc
%% <pre>
%% Role = NewRole = #role{} 角色信息
%% Error = binary() 失败原因
%% 抽奖
%% </pre>
lottery(Role = #role{link = #link{conn_pid = ConnPid}, bag = #bag{items = Items}, campaign = Camp = #campaign_role{lottery_gold = CampGold = #campaign_lottery_gold{layer = Layer, gold = HasGold}}}) ->
    case is_valid_time() of
        false -> {false, ?L(<<"活动已结束，欢迎下次参加">>)};
        true ->
            {AdmCampId, _AdmStartTime, _AdmEndTime} = get_camp_conf(),
            NowLayer = check_layer(Layer, Items, AdmCampId),
            case NowLayer > ?max_layer of
                true -> {false, ?L(<<"您已参加完五轮抽奖，请期待下次活动开启">>)};
                false ->
                    case HasGold > 0 of
                        true ->
                            ?DEBUG("#####由于上次异常补发奖励 HasGold:~w", [HasGold]),
                            NRole = case role_gain:do([#gain{label = gold, val = HasGold}], Role) of
                                {ok, NewRole} ->
                                    notice:inform(util:fbin(?L(<<"获得 ~w晶钻">>), [HasGold])),
                                    NewRole2 = NewRole#role{campaign = Camp#campaign_role{lottery_gold = CampGold#campaign_lottery_gold{gold = 0}}},
                                    NewRole2;
                                _ -> Role
                            end,
                            ItemId = get_cost_item(NowLayer),
                            case role_gain:do([#loss{label = item, val = [ItemId, 0, 1]}], NRole) of
                                {ok, NRole1} ->
                                    {ok, ReGold} = get_rand_gold(NowLayer),
                                    sys_conn:pack_send(ConnPid, 14740, {ReGold}),
                                    NRole2 = NRole1#role{campaign = Camp#campaign_role{lottery_gold = CampGold#campaign_lottery_gold{layer = NowLayer + 1, gold = ReGold}}},
                                    {ok, NRole2};
                                _Err -> {false, ?L(<<"道具不足，无法开始，充值可获取相应道具">>)}
                            end;
                        false ->
                            ItemId = get_cost_item(NowLayer),
                            case role_gain:do([#loss{label = item, val = [ItemId, 0, 1]}], Role) of
                                {ok, NewRole} ->
                                    {ok, ReGold} = get_rand_gold(NowLayer),
                                    sys_conn:pack_send(ConnPid, 14740, {ReGold}),
                                    NewRole2 = NewRole#role{campaign = Camp#campaign_role{lottery_gold = CampGold#campaign_lottery_gold{layer = NowLayer + 1, gold = ReGold}}},
                                    {ok, NewRole2};
                                _Err -> {false, ?L(<<"道具不足，无法开始，充值可获取相应道具">>)}
                            end
                    end
            end
    end.

%% @spec send_reward(Role) -> {ok, ReGold, NewRole} | {error, Error}
%% @doc
%% <pre>
%% Role = NewRole = #role{} 角色信息
%% ReGold = interge() 晶钻奖金
%% Error = binary() 失败原因
%% 发送奖励
%% </pre>
send_reward(Role = #role{id = {Rid, SrvId}, name = Name, pid = _Pid, campaign = Camp = #campaign_role{lottery_gold = CampGold = #campaign_lottery_gold{gold = ReGold, layer = NLayer}}}) when ReGold > 0 ->
    case role_gain:do([#gain{label = gold, val = ReGold}], Role) of
        {ok, NewRole} ->
            notice:inform(util:fbin(?L(<<"获得 ~w晶钻">>), [ReGold])),
            case NLayer > 1 of
                true ->
                    notice:send(52, util:fbin(?L(<<"幸运大转盘，晶钻滚滚来。恭喜~s在<font color='#ffff00'>【晶钻转盘】</font>中喜得~w晶钻，真是鸿运当头。快来参与吧，更多惊喜等着您！{open, 65, 我要转盘, #00ff24}">>), [notice:role_to_msg({Rid, SrvId, Name}), ReGold]));
                false -> ignore
            end,
            NewRole2 = NewRole#role{campaign = Camp#campaign_role{lottery_gold = CampGold#campaign_lottery_gold{gold = 0}}},
            {ok, ReGold, NewRole2};
        _ -> {false, ?L(<<"背包已满">>)}
    end;
send_reward(_Role) ->
    {false, ?L(<<"">>)}.

gm(Role) ->
    NewRole = Role#role{campaign = #campaign_role{lottery_gold = #campaign_lottery_gold{layer = 1}}}, 
    {ok, NewRole}.

%%----------------------------------------------------
%% 内部处理函数 
%%----------------------------------------------------
%% 检查时间有效性
is_valid_time() ->
    Now = util:unixtime(),
    (Now >= ?begin_time andalso Now =< ?end_time) orelse campaign_adm:is_camp_time(lottery_gold).

%% 获取不同层需消耗的物品
%% return 物品ID
get_cost_item(Layer) ->
    case Layer of
        1 -> 33236;
        2 -> 33237;
        3 -> 33238;
        4 -> 33239;
        5 -> 33240;
        _Err -> ?ERR("获取不同层消耗的物品错误 ERR:~w", [_Err]), 33240
    end.

%% 获取面板奖励信息
%% return {Data}
get_reward_info(#role{campaign = #campaign_role{lottery_gold = #campaign_lottery_gold{layer = Layer}}}) ->
    Now = util:unixtime(),
    {ST6, ET6} = campaign_adm:get_camp_time(lottery_gold),
    NowLayer = case Now < ST6 orelse Now > ET6 of
        true -> 
            ?max_layer;  %% 6为关闭
        _ ->
             case Layer >= ?max_layer of
                true -> ?max_layer;
                false -> Layer
            end
    end,
    {ok, RewardList} = get_reward_list(NowLayer),
    {NowLayer, RewardList}.

%% 获取面板奖励物品列表
%% return {ok, ItemList}
get_reward_list(Layer) ->
    case lottery_gold_data:get_golds(Layer) of
        {ok, ItemList} ->
            Golds = [Gold || #lottery_gold{gold = Gold} <- ItemList, Gold > 0],
            {ok, Golds};
        {false, _Reason} ->
            %% ?ERR("获取面板奖励物品数据错误"),
            {ok, []}
    end.

%% 随机奖励
%% return {ok, interge()}
get_rand_gold(Layer) ->
    case lottery_gold_data:get_golds(Layer) of
        {ok, GoldList} ->
            RandL = [Rand || #lottery_gold{pro = Rand} <- GoldList, Rand > 0], %% 随机列表
            SumRand = lists:sum(RandL), %% 计算和
            RandVal = case SumRand > 0 of
                true -> util:rand(1, SumRand);
                false -> 1
            end,
            Gold = get_randlist_val(RandVal, GoldList), %% 从随机列表取相应的晶钻值
            {ok, Gold};
        {false, _Reason} ->
            ?ERR("随机获取面板奖励物品数据错误"),
            {ok, 0}
    end.

get_randlist_val(RandVal, [#lottery_gold{gold = Gold, pro = Rand} | T]) when RandVal =< Rand orelse T =:= [] ->
    Gold;
get_randlist_val(RandVal, [#lottery_gold{pro = Rand} | T]) ->
    get_randlist_val(RandVal - Rand, T).

%% 检查背包
check_layer(Layer, _Items, _Id) when Layer > ?max_layer -> Layer;
check_layer(Layer, Items, _Id) ->
    ItemId = get_cost_item(Layer),
    case storage:find(Items, #item.base_id, ItemId) of    
        {false, _Reason} -> check_item([{1, 33236}, {2, 33237}, {3, 33238}, {4, 33239}, {5, 33240}], Items, Layer);
        _ -> Layer 
    end.
check_item([], _Items, Layer) -> Layer;
check_item([{L, ItemId} | T], Items, Layer) ->
    case storage:find(Items, #item.base_id, ItemId) of    
        {false, _} ->
            check_item(T, Items, Layer);
        _ -> L
    end.

%% 获取活动信息
get_camp_conf() ->
    {CampId, StartTime, EndTime} = campaign_adm:get_camp_conf(?camp_type_play_lottery_gold, ?lottery_id, ?begin_time, ?end_time),
    {CampId, StartTime, EndTime}.
