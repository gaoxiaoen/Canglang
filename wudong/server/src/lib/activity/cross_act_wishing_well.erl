%%%-------------------------------------------------------------------
%%% @author lbq
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 许愿池(跨服)
%%% @end
%%% Created : 26. 一月 2018 16:30
%%%-------------------------------------------------------------------
-module(cross_act_wishing_well).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    init_data/0,
    get_info/2,
    rank_list/3,
    add_score/2,
    get_state/1,
    get_info/3,
    get_rank_info/4,
    get_leave_time/0,
    add_charge/2,
    sort_rank/1,
    end_reward_local/3,
    midnight_refresh/1,
    sys_midnight_cacl/0,
    end_reward/2,
    add_score_apply/1,
    draw/4]).

-export([
    gm_send_mail/0
]).
-define(COST_GOODS_ID, 11702). %% 四叶草
-define(TYPE_ACT_GOLD, 1). %% 活动金币
-define(TYPE_GOLD, 2). %% 元宝


init_data() ->
    IsCenterAll = center:is_center_all(),
    IsCenterArea = center:is_center_area(),
    if
        IsCenterArea == true -> skip;
        IsCenterAll == true -> %% 中心服重启，通知单服汇总数据
            F = fun(Node) ->
                center:apply(Node, cross_act_wishing_well, init_data, [])
            end,
            lists:foreach(F, center:get_nodes());
        true ->
            case get_act() of
                [] ->
                    skip;
                Base -> %% 单服重启，汇总数据
                    Sql = io_lib:format("select pkey,nickname,score from player_cross_wishing_well where act_id = ~p and `score` > 0", [Base#base_cross_act_wishing_well.act_id]),
                    Sn = config:get_server_num(),
                    case db:get_all(Sql) of
                        Rows when is_list(Rows) ->
                            F = fun([Pkey, NickName, Score]) ->
                                [{Pkey, Sn, util:bitstring_to_term(NickName), Score}]
                            end,
                            List = lists:flatmap(F, Rows),
                            cross_all:apply(?MODULE, add_score_apply, [List]);
                        _ ->
                            []
                    end
            end
    end.

init(#player{key = Pkey, nickname = NickName} = Player) ->
    St =
        case player_util:is_new_role(Player) of
            true -> #st_cross_act_wishing_well{pkey = Pkey};
            false ->
                activity_load:dbget_cross_wishing_well(Pkey, NickName)
        end,
    lib_dict:put(?PROC_STATUS_CROSS_WISHING_WELL, St),
    update_cross_wishing_well(Player),
    Player.

midnight_refresh(Player) ->
    update_cross_wishing_well(Player),
    ok.

update_cross_wishing_well(Player) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_WISHING_WELL),
    #st_cross_act_wishing_well{
        pkey = Pkey,
        act_id = ActId
    } = St,
    case get_act() of
        [] ->
            NewSt = #st_cross_act_wishing_well{pkey = Pkey, nickname = Player#player.nickname};
        #base_cross_act_wishing_well{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewSt =
                        #st_cross_act_wishing_well{
                            pkey = Pkey,
                            nickname = Player#player.nickname,
                            act_id = BaseActId,
                            op_time = Now
                        };
                true ->
                    NewSt = St
            end
    end,
    lib_dict:put(?PROC_STATUS_CROSS_WISHING_WELL, NewSt).

add_charge(_Player, Val) ->
    case get_act() of
        [] -> _Player;
        Base ->
            St = lib_dict:get(?PROC_STATUS_CROSS_WISHING_WELL),
            #base_cross_act_wishing_well{next_list = NextList} = Base,
            {ChargeVal, ChargeCount, GoldCoin} = add_charge_help(St#st_cross_act_wishing_well.charge_val + Val, St#st_cross_act_wishing_well.charge_count, 0, NextList),
            NewSt = St#st_cross_act_wishing_well{
                charge_val = ChargeVal,
                charge_count = ChargeCount
            },
            NewPlayer = money:add_act_gold(_Player, GoldCoin),
            lib_dict:put(?PROC_STATUS_CROSS_WISHING_WELL, NewSt),
            activity_load:dbup_cross_wishing_well(NewSt),
            activity:get_notice(NewPlayer, [183], true),
            NewPlayer
    end.

add_charge_help(ChargeVal, ChargeCount, GoldCoin, NextList) ->
    ?DEBUG("~p", [{ChargeVal, ChargeCount, GoldCoin}]),
    NextCharge = get_next_charge(0, ChargeCount, NextList),
    if
        NextCharge > ChargeVal ->
            {ChargeVal, ChargeCount, GoldCoin};
        true ->
            add_charge_help(ChargeVal - NextCharge, ChargeCount + 1, GoldCoin + 1, NextList)
    end.

%% 金币
get_info(Player, ?TYPE_ACT_GOLD) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_WISHING_WELL),
    LeaveTime = get_leave_time(),
    case get_act() of
        [] -> {0, 0, 0, 0, 0, 0, 0, 0, [], []};
        Base0 ->
            Base = Base0#base_cross_act_wishing_well.coin_draw,
            RankList = Base0#base_cross_act_wishing_well.rank_list,
            NextList = Base0#base_cross_act_wishing_well.next_list,
            {
                ?TYPE_ACT_GOLD,
                LeaveTime,
                ?COST_GOODS_ID,
                Base#base_cross_act_wishing_well_gold.one_cost,
                Base#base_cross_act_wishing_well_gold.one_score,
                Base#base_cross_act_wishing_well_gold.ten_score,
                Player#player.act_gold,
                get_next_charge(St#st_cross_act_wishing_well.charge_val, St#st_cross_act_wishing_well.charge_count, NextList),%% 下一阶段充值数
                make_rank_list(RankList),
                get_reward_list0(1, St#st_cross_act_wishing_well.count_list, Base#base_cross_act_wishing_well_gold.reward_list)
            }
    end;

%% 元宝
get_info(_Player, ?TYPE_GOLD) ->
    LeaveTime = get_leave_time(),
    St = lib_dict:get(?PROC_STATUS_CROSS_WISHING_WELL),
    case get_act() of
        [] -> {0, 0, 0, 0, 0, 0, 0, 0, [], []};
        Base0 ->
            Base = Base0#base_cross_act_wishing_well.gold_draw,
            RankList = Base0#base_cross_act_wishing_well.rank_list,
            {
                ?TYPE_GOLD,
                LeaveTime,
                ?COST_GOODS_ID,
                Base#base_cross_act_wishing_well_gold.one_cost,
                Base#base_cross_act_wishing_well_gold.one_score,
                Base#base_cross_act_wishing_well_gold.ten_score,
                0,
                0,
                make_rank_list(RankList),
                get_reward_list0(2, St#st_cross_act_wishing_well.count_list, Base#base_cross_act_wishing_well_gold.reward_list)
            }
    end;

get_info(_Player, _) ->
    {0, 0, 0, 0, 0, 0, 0, 0, [], []}.


draw(Player, Type, Id, IsAuto) ->
    ?DEBUG("Type, Id ~p~n", [{Type, Id}]),
    St = lib_dict:get(?PROC_STATUS_CROSS_WISHING_WELL),
    case get_act() of
        [] -> {0, [], Player};
        Base ->
            case check(Player, Base, Type, Id, IsAuto) of
                {false, Res} -> {Res, [], Player};
                {ok, NewCountList, NewScore, AddScore, Reward, CoinCost, GoldCost, CostGoodsNum} ->
                    ?DO_IF(CostGoodsNum > 0, goods:subtract_good(Player, [{?COST_GOODS_ID, CostGoodsNum}], 348)),
                    NewSt = St#st_cross_act_wishing_well{
                        count_list = NewCountList,
                        score = NewScore
                    },
                    lib_dict:put(?PROC_STATUS_CROSS_WISHING_WELL, NewSt),
                    activity_load:dbup_cross_wishing_well(NewSt),
                    NewPlayer = money:add_no_bind_gold(Player, -GoldCost, 348, 0, 0),
                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(348, Reward)),
                    cross_all:apply(?MODULE, add_score_apply, [[{Player#player.key, Player#player.sn_cur, Player#player.nickname, NewScore}]]),
                    NewPlayer2 = money:add_act_gold(NewPlayer1, -CoinCost),
                    activity:get_notice(Player, [184], true),
                    log_cross_act_well_draw(Player#player.key, Player#player.nickname, Type, GoldCost, CoinCost, AddScore, Reward),
                    {1, goods:pack_goods(Reward), NewPlayer2}
            end
    end.

add_score_apply(List) ->
    ?CAST(activity_proc:get_act_pid(), {cross_act_wishing_well, add_score, List}),
    ok.

%% 金币抽奖
check(Player, Base, ?TYPE_ACT_GOLD, _, _IsAuto) ->
    #base_cross_act_wishing_well{coin_draw = CoinDraw} = Base,
    St = lib_dict:get(?PROC_STATUS_CROSS_WISHING_WELL),
    if
        Player#player.act_gold >= CoinDraw#base_cross_act_wishing_well_gold.one_cost ->
            {Count, Other} =
                case lists:keytake(?TYPE_ACT_GOLD, 1, St#st_cross_act_wishing_well.count_list) of
                    false -> {0, St#st_cross_act_wishing_well.count_list};
                    {value, {_, Count0}, Other0} -> {Count0, Other0}
                end,
            Score1 = St#st_cross_act_wishing_well.score,
            RatioList = [{{GoodsId0, GoodsNum0, IsSp0}, Ratio} || {GoodsId0, GoodsNum0, Ratio, IsSp0} <- get_reward_list(Count, CoinDraw#base_cross_act_wishing_well_gold.reward_list)],
            {GoodsId, GoodsNum, IsSp} = util:list_rand_ratio(RatioList),
            %%?DO_IF(IsSp == 1, spawn(fun() -> notice_sys(Player, GoodsId) end)),
            NewCount = ?IF_ELSE(IsSp == 1, 0, Count + 1),
            {ok, [{?TYPE_ACT_GOLD, NewCount} | Other], Score1 + CoinDraw#base_cross_act_wishing_well_gold.one_score, CoinDraw#base_cross_act_wishing_well_gold.one_score, [{GoodsId, GoodsNum}], CoinDraw#base_cross_act_wishing_well_gold.one_cost, 0, 0};
        true ->
            {false, 25} %% 金币不足
    end;

%% 元宝单次抽奖
check(Player, Base, ?TYPE_GOLD, 1, IsAuto) ->
    #base_cross_act_wishing_well{gold_draw = CoinDraw} = Base,
    St = lib_dict:get(?PROC_STATUS_CROSS_WISHING_WELL),
    GoodsCount = goods_util:get_goods_count(?COST_GOODS_ID),
    if
        GoodsCount >= 1 ->
            {Count, Other} =
                case lists:keytake(?TYPE_GOLD, 1, St#st_cross_act_wishing_well.count_list) of
                    false -> {0, St#st_cross_act_wishing_well.count_list};
                    {value, {_, Count0}, Other0} -> {Count0, Other0}
                end,
            Score1 = St#st_cross_act_wishing_well.score,
            RatioList = [{{GoodsId0, GoodsNum0, IsSp0}, Ratio} || {GoodsId0, GoodsNum0, Ratio, IsSp0} <- get_reward_list(Count, CoinDraw#base_cross_act_wishing_well_gold.reward_list)],
            {GoodsId, GoodsNum, IsSp} = util:list_rand_ratio(RatioList),
            NewCount = ?IF_ELSE(IsSp == 1, 0, Count + 1),
            %%?DO_IF(IsSp == 1, spawn(fun() -> notice_sys(Player, GoodsId) end)),
            {ok, [{?TYPE_GOLD, NewCount} | Other], Score1 + CoinDraw#base_cross_act_wishing_well_gold.one_score, CoinDraw#base_cross_act_wishing_well_gold.one_score, [{GoodsId, GoodsNum}], 0, 0, 1};
        IsAuto == 1 ->
            case money:is_enough(Player, CoinDraw#base_cross_act_wishing_well_gold.one_cost, gold) of
                true ->
                    {Count, Other} =
                        case lists:keytake(?TYPE_GOLD, 1, St#st_cross_act_wishing_well.count_list) of
                            false -> {0, St#st_cross_act_wishing_well.count_list};
                            {value, {_, Count0}, Other0} -> {Count0, Other0}
                        end,
                    Score1 = St#st_cross_act_wishing_well.score,
                    RatioList = [{{GoodsId0, GoodsNum0, IsSp0}, Ratio} || {GoodsId0, GoodsNum0, Ratio, IsSp0} <- get_reward_list(Count, CoinDraw#base_cross_act_wishing_well_gold.reward_list)],
                    {GoodsId, GoodsNum, IsSp} = util:list_rand_ratio(RatioList),
                    NewCount = ?IF_ELSE(IsSp == 1, 0, Count + 1),
                    %%?DO_IF(IsSp == 1, spawn(fun() -> notice_sys(Player, GoodsId) end)),
                    {ok, [{?TYPE_GOLD, NewCount} | Other], Score1 + CoinDraw#base_cross_act_wishing_well_gold.one_score, CoinDraw#base_cross_act_wishing_well_gold.one_score, [{GoodsId, GoodsNum}], 0, CoinDraw#base_cross_act_wishing_well_gold.one_cost, 0};
                false ->
                    {false, 2} %% 元宝不足
            end;
        true ->
            {false, 15}
    end;

%% 元宝十次抽奖
check(Player, Base, ?TYPE_GOLD, 10, IsAuto) ->
    #base_cross_act_wishing_well{gold_draw = CoinDraw} = Base,
    St = lib_dict:get(?PROC_STATUS_CROSS_WISHING_WELL),
    GoodsCount = goods_util:get_goods_count(?COST_GOODS_ID),
    if
        GoodsCount >= 10 ->
            {Count1, Other} =
                case lists:keytake(?TYPE_GOLD, 1, St#st_cross_act_wishing_well.count_list) of
                    false -> {0, St#st_cross_act_wishing_well.count_list};
                    {value, {_, Count0}, Other0} -> {Count0, Other0}
                end,
            Score1 = St#st_cross_act_wishing_well.score,
            F = fun(_, {Count, Reward0}) ->
                RatioList = [{{GoodsId0, GoodsNum0, IsSp0}, Ratio} || {GoodsId0, GoodsNum0, Ratio, IsSp0} <- get_reward_list(Count, CoinDraw#base_cross_act_wishing_well_gold.reward_list)],
                {GoodsId, GoodsNum, IsSp} = util:list_rand_ratio(RatioList),
                NewCount0 = ?IF_ELSE(IsSp == 1, 0, Count + 1),
                %%?DO_IF(IsSp == 1, spawn(fun() -> notice_sys(Player, GoodsId) end)),
                {NewCount0, [{GoodsId, GoodsNum} | Reward0]}
            end,
            {NewCount, Reward} = lists:foldl(F, {Count1, []}, lists:seq(1, 10)),
            {ok, [{?TYPE_GOLD, NewCount} | Other], Score1 + CoinDraw#base_cross_act_wishing_well_gold.ten_score, CoinDraw#base_cross_act_wishing_well_gold.ten_score, Reward, 0, 0, 10};
        IsAuto == 1 ->
            case money:is_enough(Player, CoinDraw#base_cross_act_wishing_well_gold.one_cost * (10 - GoodsCount), gold) of
                true ->
                    {Count1, Other} =
                        case lists:keytake(?TYPE_GOLD, 1, St#st_cross_act_wishing_well.count_list) of
                            false -> {0, St#st_cross_act_wishing_well.count_list};
                            {value, {_, Count0}, Other0} -> {Count0, Other0}
                        end,
                    Score1 = St#st_cross_act_wishing_well.score,
                    F = fun(_, {Count, Reward0}) ->
                        RatioList = [{{GoodsId0, GoodsNum0, IsSp0}, Ratio} || {GoodsId0, GoodsNum0, Ratio, IsSp0} <- get_reward_list(Count, CoinDraw#base_cross_act_wishing_well_gold.reward_list)],
                        {GoodsId, GoodsNum, IsSp} = util:list_rand_ratio(RatioList),
                        NewCount0 = ?IF_ELSE(IsSp == 1, 0, Count + 1),
                        %%?DO_IF(IsSp == 1, spawn(fun() -> notice_sys(Player, GoodsId) end)),
                        {NewCount0, [{GoodsId, GoodsNum} | Reward0]}
                    end,
                    {NewCount, Reward} = lists:foldl(F, {Count1, []}, lists:seq(1, 10)),
                    {ok,
                        [{?TYPE_GOLD, NewCount} | Other],
                        Score1 + CoinDraw#base_cross_act_wishing_well_gold.ten_score,
                        CoinDraw#base_cross_act_wishing_well_gold.ten_score,
                        Reward,
                        0,
                        max(0, CoinDraw#base_cross_act_wishing_well_gold.one_cost * (10 - GoodsCount)),
                        GoodsCount};
                false ->
                    {false, 2} %% 元宝不足
            end;
        true ->
            {false, 15}
    end.

add_score(Logs0, List) ->
    F = fun({Pkey, Sn, NickName, DrawNum}, Logs) ->
        case lists:keytake(Pkey, #cross_act_wishing_well_mb.pkey, Logs) of
            false ->
                NewMb = #cross_act_wishing_well_mb{pkey = Pkey, sn = Sn, nickname = NickName, score = DrawNum, add_time = util:unixtime()},
                [NewMb | Logs];
            {value, Mb, T0} ->
                NewMb = Mb#cross_act_wishing_well_mb{pkey = Pkey, sn = Sn, nickname = NickName, score = DrawNum, add_time = util:unixtime()},
                [NewMb | T0]
        end
    end,
    lists:foldl(F, Logs0, List).

get_rank_info(Node, Pkey, Sid, Sn) ->
    ?CAST(activity_proc:get_act_pid(), {cross_act_wishing_well, get_rank_info, Node, Pkey, Sid, Sn}),
    ok.

make_rank_info(RankList) ->
    F = fun(Ets) ->
        {
            Ets#cross_act_wishing_well_mb.pkey,
            Ets#cross_act_wishing_well_mb.rank,
            Ets#cross_act_wishing_well_mb.sn,
            Ets#cross_act_wishing_well_mb.nickname,
            Ets#cross_act_wishing_well_mb.score,
            0
        }
    end,
    lists:map(F, RankList).

make_rank_list(RankList) ->
    F = fun({RankTop, RankLimit, RewardList}) ->
        [RankTop, RankLimit, goods:pack_goods(RewardList)]
    end,
    lists:map(F, RankList).

get_next_charge(ChargeVal, ChargeCount, NextList) ->
    Val = [Val || {Count, Val} <- NextList, ChargeCount =< Count],
    case Val of
        [] ->
            {_Count, Val0} = lists:max(NextList),
            max(0, Val0 - ChargeVal);
        _ ->
            ?DEBUG("Val ~p~n", [Val]),
            Val0 = hd(Val),
            max(0, Val0 - ChargeVal)
    end.

get_reward_list0(Type, CountList, RewardList) ->
    Count =
        case lists:keyfind(Type, 1, CountList) of
            false -> 0;
            {Type, Count0} -> Count0
        end,
    RewardList0 = get_reward_list(Count, RewardList),
    goods:pack_goods([{GoodsId, GoodsNum} || {GoodsId, GoodsNum, _, _} <- RewardList0]).


get_reward_list(Count, RewardList) ->
    F = fun({Top, Down, Reward}, Reward0) ->
        if
            Count >= Top andalso Count =< Down -> Reward;
            true -> Reward0
        end
    end,
    lists:foldl(F, [], RewardList).

get_act() ->
    case activity:get_work_list(data_cross_act_wishing_well) of
        [] -> [];
        [Base | _] -> Base
    end.

get_leave_time() ->
    activity:get_leave_time(data_cross_act_wishing_well).

get_state(Player) ->
    case get_act() of
        [] -> -1;
        _ ->
            ?IF_ELSE(Player#player.act_gold > 0, 1, 0)
    end.


rank_list(LogList, GroupList, GroupIdList) ->
    LogSortList = sort_log_list_by_group(LogList, GroupList),
    %%分类排行
    F = fun(Group) ->
        case lists:keyfind(Group, 1, LogSortList) of
            false -> {Group, []};
            {_, L} ->
                {Group, sort_rank_list(L)}
        end
    end,
    lists:map(F, ?IF_ELSE(GroupIdList == [], [0], GroupIdList)).

%%根据划分的服务器组分类
sort_log_list_by_group(LogList, GroupList) ->
    F = fun(Log, L) ->
        Group = activity_area_group:get_sn_group(Log#cross_act_wishing_well_mb.sn, GroupList),
        case lists:keytake(Group, 1, L) of
            false -> [{Group, [Log]} | L];
            {value, {_, L1}, T} ->
                [{Group, [Log | L1]} | T]
        end
    end,
    lists:foldl(F, [], LogList).

%% 刷新排行榜
sort_rank_list(LogList) ->
    F0 = fun(Info1, Info2) ->
        if
            Info1#cross_act_wishing_well_mb.score > Info2#cross_act_wishing_well_mb.score -> true;
            Info1#cross_act_wishing_well_mb.score < Info2#cross_act_wishing_well_mb.score -> false;
            Info1#cross_act_wishing_well_mb.add_time < Info2#cross_act_wishing_well_mb.add_time -> true;
            Info1#cross_act_wishing_well_mb.add_time > Info2#cross_act_wishing_well_mb.add_time -> false;
            true -> true
        end
    end,
    LogList1 = lists:sort(F0, LogList),
    F = fun(Log, {Rank0, L}) ->
        {Rank0 + 1, L ++ [Log#cross_act_wishing_well_mb{rank = Rank0}]}
    end,
    {_, RankList} = lists:foldl(F, {1, []}, [X || X <- LogList1]),
    RankList.

sort_rank(Data0) ->
    F0 = fun(Info1, Info2) ->
        if
            Info1#cross_act_wishing_well_mb.score > Info2#cross_act_wishing_well_mb.score -> true;
            Info1#cross_act_wishing_well_mb.score < Info2#cross_act_wishing_well_mb.score -> false;
            Info1#cross_act_wishing_well_mb.add_time < Info2#cross_act_wishing_well_mb.add_time -> true;
            Info1#cross_act_wishing_well_mb.add_time > Info2#cross_act_wishing_well_mb.add_time -> false;
            true -> true
        end
    end,
    NewLogs = lists:sort(F0, Data0),
    F1 = fun(Info, {List1, Rank}) ->
        {[Info#cross_act_wishing_well_mb{rank = Rank} | List1], Rank + 1}
    end,
    {NewRanks, _} = lists:foldl(F1, {[], 1}, NewLogs),
    NewRanks.

end_reward(Ranks, #base_cross_act_wishing_well{rank_list = RankList}) ->
    F = fun({Group, List}) ->
        F0 = fun(Mb) ->
            Reward = get_rank_reward(Mb#cross_act_wishing_well_mb.rank, RankList),
            log_cross_act_well_final(Mb#cross_act_wishing_well_mb.pkey, Mb#cross_act_wishing_well_mb.nickname, Mb#cross_act_wishing_well_mb.rank, Mb#cross_act_wishing_well_mb.score, Mb#cross_act_wishing_well_mb.sn, Group, Reward),
            center:apply_sn(Mb#cross_act_wishing_well_mb.sn, cross_act_wishing_well, end_reward_local, [Mb#cross_act_wishing_well_mb.pkey, Mb#cross_act_wishing_well_mb.rank, Reward])
        end,
        lists:foreach(F0, List)
    end,
    lists:foreach(F, Ranks).

end_reward_local(Pkey, Rank, Reward) ->
    {Title, Content0} = t_mail:mail_content(166),
    Content = io_lib:format(Content0, [Rank]),
    mail:sys_send_mail([Pkey], Title, Content, Reward),
    ok.

get_rank_reward(Rank, RankList) ->
    case [Reward || {Top, Down, Reward} <- RankList, Rank >= Top, Rank =< Down] of
        [] -> [];
        Other -> hd(Other)
    end.


%% 凌晨邮件结算
sys_midnight_cacl() ->
    {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
    if
        H == 23 andalso M == 58 -> sys_midnight_cacl2();
        true -> ok
    end.

sys_midnight_cacl2() ->
    case get_act() of
        [] ->
            ok;
        Base ->
%%            Pid = activity_proc:get_act_pid(),
            LTime = get_leave_time(),
            if
                LTime > 150 -> skip;
                true ->
                    GroupIdList = activity_area_group:get_id_list(data_cross_act_wishing_well, cross_act_wishing_well),
                    GroupList = activity_area_group:get_group_list(data_cross_act_wishing_well, cross_act_wishing_well),
                    spawn(fun() -> timer:sleep(110000),
                        ?CAST(activity_proc:get_act_pid(), {cross_act_wishing_well, end_reward, Base, GroupIdList, GroupList}) end)
            end
    end.

gm_send_mail() ->
    case get_act() of
        [] -> skip;
        Base ->
            GroupIdList = activity_area_group:get_id_list(data_cross_act_wishing_well, cross_act_wishing_well),
            GroupList = activity_area_group:get_group_list(data_cross_act_wishing_well, cross_act_wishing_well),
            ?CAST(activity_proc:get_act_pid(), {cross_act_wishing_well, end_reward, Base, GroupIdList, GroupList})
    end.

get_info(Group, Pkey, List) ->
    List0 =
        case lists:keyfind(Group, 1, List) of
            false -> [];
            {_, L} -> L
        end,
    {Recharge, Rank} =
        case lists:keyfind(Pkey, #cross_act_wishing_well_mb.pkey, List0) of
            false ->
                {0, 0};
            GetLog ->
                {GetLog#cross_act_wishing_well_mb.score, GetLog#cross_act_wishing_well_mb.rank}
        end,
    List1 = lists:sublist(make_rank_info(List0), ?AREA_RECHARGE_RANK_LIMIT),
    ReRankList = [[Rank1, Sn1, Nickname1, Score1, Limit1] || {_Pkey1, Rank1, Sn1, Nickname1, Score1, Limit1} <- List1],
    {Recharge, Rank, ReRankList}.


%% 抽奖日志
log_cross_act_well_draw(Pkey, Nickname, Type, GoldCost, CoinCost, Score, GoodsList) ->
    Sql = io_lib:format("insert into log_cross_act_well_draw set pkey=~p,nickname='~s',type=~p,gold_cost = ~p,coin_cost=~p, score=~p, goods_list='~s',time=~p",
        [Pkey, Nickname, Type, GoldCost, CoinCost, Score, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql).


%% 结算日志
log_cross_act_well_final(Pkey, Nickname, Rank, Score, Sn, Group, GoodsList) ->
    Sql = io_lib:format("insert into log_cross_act_well_final set pkey=~p,nickname='~s',rank=~p, score=~p, sn=~p,sn_group=~p, goods_list='~s',time=~p",
        [Pkey, Nickname, Rank, Score, Sn, Group, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql).

%%notice_sys(Player, GoodsId) -> ok.
%% spawn(fun() ->
%%     Msg = io_lib:format(t_tv:get(296), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
%%     notice:add_sys_notice(Msg, 296)
%%  end).
