%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 三月 2017 15:10
%%%-------------------------------------------------------------------
-module(act_invest).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("invest.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    midnight_refresh/0,

    get_act_info/1,
    get_state/1,
    recv/2,
    invest/1,
    notice/2,
    repair/0
]).

notice(Player, Lv) ->
    if
        Lv == 42 ->
            activity:get_notice(Player, [34], true),
            case get_state(Player) of
                -1 ->
                    ok;
                _ ->
                    {ok, Bin} = pt_433:write(43328, {1}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end;
        true ->
            ok
    end.

init(#player{key = Pkey} = Player) ->
    StActInvest =
        case player_util:is_new_role(Player) of
            true -> #st_act_invest{pkey = Pkey};
            false -> activity_load:dbget_act_invest(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_ACT_INVEST, StActInvest),
    update_invest(),
    Player.

update_invest() ->
    StActInvest = lib_dict:get(?PROC_STATUS_ACT_INVEST),
    #st_act_invest{
        act_num = ActNum,
        recv_list = RecvList,
        op_time = OpTime,
        invest_gold = InvestGold
    } = StActInvest,
    Now = util:unixtime(),
    case util:is_same_date(OpTime, Now) of
        true ->
            ok;
        false -> %% 跨天则处理
            NewActNum =
                if
                    length(RecvList) == 0 -> ActNum; %% 处理新号
                    length(RecvList) rem ?ACT_INVEST_DAY == 0 -> ActNum + 1;%% 处理老号
                    true -> ActNum
                end,
            NewRecvList =
                if
                    length(RecvList) rem ?ACT_INVEST_DAY == 0 -> [];
                    true -> RecvList
                end,
            NewInvestGold =
                if
                    RecvList == [] -> InvestGold;
                    length(RecvList) rem ?ACT_INVEST_DAY == 0 -> 0;
                    true -> InvestGold
                end,
            NewStActInvest =
                StActInvest#st_act_invest{
                    %% 处理掉数据重置
                    invest_gold = NewInvestGold,
                    act_num = min(NewActNum, data_act_invest:get_max_actNum()),
                    recv_list = NewRecvList,
                    op_time = util:unixtime()
                },
            lib_dict:put(?PROC_STATUS_ACT_INVEST, NewStActInvest)
    end.

midnight_refresh() ->
    update_invest().

get_act_info(_Player) ->
    update_invest(),
    StActInvest = lib_dict:get(?PROC_STATUS_ACT_INVEST),
    #st_act_invest{
        invest_gold = InvestGold,
        recv_list = RecvList,
        recv_time = RecvTime,
        act_num = ActNum
    } = StActInvest,
    ActCost = data_act_invest:get_cost_by_actNum(ActNum),
    F = fun(Day) ->
        NewDay = Day + (ActNum-1)*?ACT_INVEST_DAY,
        #base_act_invest{gift_id = GiftId} = data_act_invest:get(NewDay),
        Status = ?IF_ELSE(lists:member(NewDay, RecvList), 1, 0),
        [Day, GiftId, Status]
    end,
    BaseList = lists:map(F, lists:seq(1, ?ACT_INVEST_DAY)),
    LTime = max(0, 7 * ?ONE_DAY_SECONDS - (length(RecvList)) * ?ONE_DAY_SECONDS - util:get_seconds_from_midnight()),
    case util:is_same_date(util:unixtime(), RecvTime) of
        true ->
            {LTime, 2, ActCost, BaseList};
        false ->
            if
                InvestGold > 0 ->
                    {LTime, 1, ActCost, BaseList};
                true ->
                    {LTime, 0, ActCost, BaseList}
            end
    end.

get_state(_Player) ->
    StActInvest = lib_dict:get(?PROC_STATUS_ACT_INVEST),
    #st_act_invest{
        invest_gold = InvestGold,
        recv_time = RecvTime
    } = StActInvest,
    Flag = util:is_same_date(util:unixtime(), RecvTime),
    if
        InvestGold == 0 -> 0; %% 当前没有投资
        Flag == true -> 0; %% 今天领过了，红点消失
        true -> 1
    end.

recv(Player, 0) ->
    ?ERR("Err Clent Data 0", []),
    {0, Player};

recv(Player, Day) ->
    StActInvest = lib_dict:get(?PROC_STATUS_ACT_INVEST),
    #st_act_invest{
        invest_gold = InvestGold,
        recv_list = RecvList,
        recv_time = RecvTime,
        act_num = ActNum
    } = StActInvest,
    RecvDay = Day + (ActNum-1)*?ACT_INVEST_DAY,
    case util:is_same_date(util:unixtime(), RecvTime) of
        true ->
            {0, Player};
        false ->
            if
                InvestGold < 1 -> {0, Player};
                true ->
                    #base_act_invest{gift_id = GiftId} = data_act_invest:get(RecvDay),
                    GiveGoodsList = goods:make_give_goods_list(615, [{GiftId, 1}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    NewStActInvest =
                        StActInvest#st_act_invest{
                            recv_time = util:unixtime(),
                            op_time = util:unixtime(),
                            recv_list = [RecvDay | RecvList]
                        },
                    lib_dict:put(?PROC_STATUS_ACT_INVEST, NewStActInvest),
                    activity_load:dbup_act_invest(NewStActInvest),
                    activity:get_notice(Player, [34], true),
                    activity_log:log_get_invest(Player#player.key, ActNum, InvestGold, RecvDay, GiftId, 1),
                    {1, NewPlayer}
            end
    end.

invest(Player) ->
    StActInvest = lib_dict:get(?PROC_STATUS_ACT_INVEST),
    #st_act_invest{
        invest_gold = InvestGold,
        act_num = ActNum
    } = StActInvest,
    if
        InvestGold > 0 ->
            {6, Player}; %% 已投资
        true ->
            CostGold = data_act_invest:get_cost_by_actNum(ActNum),
            case money:is_enough(Player, CostGold, gold) of
                false ->
                    {5, Player}; %%钻石不足
                true ->
                    NewStActInvest =
                        StActInvest#st_act_invest{
                            invest_gold = CostGold,
                            op_time = util:unixtime()
                        },
                    lib_dict:put(?PROC_STATUS_ACT_INVEST, NewStActInvest),
                    activity_load:dbup_act_invest(NewStActInvest),
                    NewPlayer = money:add_no_bind_gold(Player, -CostGold, 610, 0, 0),
                    activity:get_notice(Player, [34], true),
                    notice_sys:add_notice(act_invest, Player),
                    {1, NewPlayer}
            end
    end.

repair() ->
    Sql = io_lib:format("select pkey, recv_list from player_act_invest", []),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Pkey, RecvListBin]) ->
                RecvList = util:bitstring_to_term(RecvListBin),
                case RecvList == [] of
                    true -> skip;
                    false ->
                        Min = lists:min(RecvList),
                        if
                            Min =< 6 -> skip;
                            true ->
                                F0 = fun(N) ->
                                    N /= 7
                                end,
                                LL = lists:filter(F0, RecvList),
                                Length = length(LL),
                                if
                                    Length >= 7 -> skip;
                                    true ->
                                        NewList = lists:seq(8, 7 + Length),
                                        Sql0 = io:format("update player_act_invest set pkey=~p, recv_list='~s'",
                                            [Pkey, util:term_to_bitstring(NewList)]),
                                        db:execute(Sql0)
                                end
                        end
                end
            end,
            lists:map(F, Rows);
        _ ->
            skip
    end.