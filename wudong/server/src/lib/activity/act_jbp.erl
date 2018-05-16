%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 聚宝盆
%%% @end
%%% Created : 06. 十一月 2017 17:51
%%%-------------------------------------------------------------------
-module(act_jbp).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("goods.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act/0,
    get_act_info/1,
    recv/3,
    add_charge/2,
    get_notice_state/1
]).

-export([
    sys_back/0,
    gm_sys_back/0
]).

sys_back() ->
    {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
    if
        H == 23 andalso M == 58 -> sys_back2();
        true -> ok
    end.

sys_back2() ->
    case get_act() of
        [] -> skip;
        #base_act_jbp{open_info = OpenInfo} = Base ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            if
                LTime > 150 -> skip;
                true -> spawn(fun() -> timer:sleep(128000), sys_back2(Base) end)
            end
    end.

gm_sys_back() ->
    case get_act() of
        [] -> skip;
        Base ->
            sys_back2(Base)
    end.

sys_back2(Base) ->
    #base_act_jbp{act_id = ActId, list = BaseList} = Base,
    Sql = io_lib:format("select pkey, charge_list, recv_list from player_act_jbp where act_id=~p", [ActId]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Pkey, ChargeListBin, RecvListBin]) ->
                ChargeList = util:bitstring_to_term(ChargeListBin),
                RecvList = util:bitstring_to_term(RecvListBin),
                F0 = fun({ChargeGold, _ChargeTime}) ->
                    case lists:keyfind(ChargeGold, #base_act_jbp_sub.charge_gold, BaseList) of
                        false -> skip;
                        #base_act_jbp_sub{id = Id, list = DayInfoList} ->
                            F3 = fun({BaseDay, RewardList}) ->
                                case lists:keyfind({Id, BaseDay}, 1, RecvList) of
                                    false ->
                                        {Title, Content0} = t_mail:mail_content(147),
                                        Content = io_lib:format(Content0, [ChargeGold, BaseDay]),
                                        mail:sys_send_mail([Pkey], Title, Content, RewardList),
                                        Sql0 = io_lib:format("insert into log_act_jbp set pkey=~p, recv_day=~p, recv_id=~p, reward='~s', time=~p",[Pkey,BaseDay,Id,util:term_to_bitstring(RewardList),util:unixtime()]),
                                        log_proc:log(Sql0);
                                    _ ->
                                        skip
                                end
                            end,
                            lists:map(F3, DayInfoList)
                    end
                end,
                lists:map(F0, ChargeList)
            end,
            lists:map(F, Rows);
        _ -> skip
    end.

init(#player{key = Pkey} = Player) ->
    StActJbp =
        case player_util:is_new_role(Player) of
            true -> #st_act_jbp{pkey = Pkey};
            false -> activity_load:dbget_act_jbp(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_ACT_JBP, StActJbp),
    update_jbp(Player),
    Player.

update_jbp(Player) ->
    StActJbp = lib_dict:get(?PROC_STATUS_ACT_JBP),
    #st_act_jbp{
        pkey = Pkey,
        act_id = ActId,
        charge_list = OldChargeGoldList
    } = StActJbp,
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            NewStActJbp = #st_act_jbp{pkey = Pkey};
        {#base_act_jbp{act_id = BaseActId, open_info = OpenInfo}, BaseList} ->
            ChargeGoldList = act_charge:get_charge_list(),
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStActJbp =
                        #st_act_jbp{
                            pkey = Pkey,
                            act_id = BaseActId,
                            charge_list = init_data(util:list_filter_repeat(ChargeGoldList), BaseList, OpenInfo),
                            op_time = Now
                        };
                true ->
                    NewStActJbp =
                        StActJbp#st_act_jbp{
                            charge_list = OldChargeGoldList,
                            op_time = Now
                        }
            end
    end,
    lib_dict:put(?PROC_STATUS_ACT_JBP, NewStActJbp).

init_data(ChargeGoldList, BaseList, OpenInfo) ->
    LTime = activity:calc_act_leave_time(OpenInfo),
    if
        LTime =< ?ONE_DAY_SECONDS * 2 -> [];
        true ->
            Now = util:unixtime(),
            F = fun(#base_act_jbp_sub{charge_gold = ChargeGold}) ->
                ?IF_ELSE(lists:member(ChargeGold, ChargeGoldList), [{ChargeGold, Now}], [])
            end,
            lists:flatmap(F, BaseList)
    end.

%% 凌晨重置不操作数据库
midnight_refresh(Player) ->
    update_jbp(Player).

get_act() ->
    case activity:get_work_list(data_act_jbp) of
        [] -> [];
        [Base | _] -> Base
    end.

get_act(LoginFlag) ->
    case get_act() of
        [] -> [];
        #base_act_jbp{list = BaseList} = BaseR ->
            F = fun(#base_act_jbp_sub{login_flag = BaseLoginFlag} = R) ->
                if
                    LoginFlag == BaseLoginFlag -> [R];
                    BaseLoginFlag == all -> [R];
                    true -> []
                end
            end,
            NewBaseList = lists:flatmap(F, BaseList),
            if
                NewBaseList == [] -> [];
                true -> {BaseR, NewBaseList}
            end
    end.

get_act_info(Player) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            {0, 2, []};
        {#base_act_jbp{open_info = OpenInfo}, BaseSubList} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            Status = ?IF_ELSE(LTime > ?ONE_DAY_SECONDS*2, 1, 2),
            St = lib_dict:get(?PROC_STATUS_ACT_JBP),
            #st_act_jbp{charge_list = ChargeList, recv_list = RecvList} = St,
            NowSec = util:unixdate(),
            F = fun(#base_act_jbp_sub{id = Id, charge_gold = BaseChargeGold, list = BaseList}) ->
                ChargeInfo = lists:keyfind(BaseChargeGold, 1, ChargeList),
                F0 = fun({Day, RewardList}) ->
                    IsRecv =
                        if
                            ChargeInfo == false -> 0; %% 未激活
                            true ->
                                case lists:keyfind({Id, Day}, 1, RecvList) of
                                    {{Id, Day}, _RecvTime} -> 2; %% 已领取
                                    false ->
                                        {BaseChargeGold, ChargeTime} = ChargeInfo,
                                        T = util:unixdate(ChargeTime) + ?ONE_DAY_SECONDS*(Day-1),
                                        if
                                            T =< NowSec -> 1; %% 当天可以领取
                                            true -> 0
                                        end
                                end
                        end,
                    [Day, IsRecv, util:list_tuple_to_list(RewardList)]
                end,
                DayInfoList = lists:map(F0, BaseList),
                [Id, BaseChargeGold, DayInfoList]
            end,
            List = lists:map(F, BaseSubList),
            {LTime, Status, List}
    end.

recv(Player, Id, Day) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            {0, Player};
        {_BaseR, BaseList} ->
            St = lib_dict:get(?PROC_STATUS_ACT_JBP),
            case check_recv(Id, Day, BaseList, St) of
                {fail, Code} -> {Code, Player};
                {true, RewardList} ->
                    Now = util:unixtime(),
                    NewSt =
                        St#st_act_jbp{
                            recv_list = [{{Id, Day}, Now} | St#st_act_jbp.recv_list],
                            op_time = util:unixtime()
                        },
                    lib_dict:put(?PROC_STATUS_ACT_JBP, NewSt),
                    activity_load:dbup_act_jbp(NewSt),
                    GiveGoodsList = goods:make_give_goods_list(730, RewardList),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity:get_notice(NewPlayer, [169], true),
                    Sql = io_lib:format("insert into log_act_jbp set pkey=~p, recv_day=~p, recv_id=~p, reward='~s', time=~p",
                        [Player#player.key,Day,Id,util:term_to_bitstring(RewardList),util:unixtime()]),
                    log_proc:log(Sql),
                    spawn(fun() ->
                        #base_act_jbp_sub{list = DayInfoList} = lists:keyfind(Id, #base_act_jbp_sub.id, BaseList),
                        FF =
                            fun({_Day0, Reward}) ->
                                {_Id0, Num0} = hd(Reward),
                                Num0
                            end,
                        SumGold = lists:sum(lists:map(FF, DayInfoList)),
                        [{_Gold, _GoldNum}, {GoodsId, _GoodsNum} | _] = RewardList,
                        #goods_type{goods_name = GoodsName} = data_goods:get(GoodsId),
                        notice_sys:add_notice(act_jbp, [Player#player.nickname, SumGold, GoodsName])
                    end),
                    {1, NewPlayer}
            end
    end.

check_recv(Id, Day, BaseList, St) ->
    #st_act_jbp{charge_list = ChargeList, recv_list = RecvList} = St,
    case lists:keyfind({Id, Day}, 1, RecvList) of
        {{Id, Day}, _RecvTime} -> {fail, 5};
        false ->
            case lists:keyfind(Id, #base_act_jbp_sub.id, BaseList) of
                false -> {fail, 0};
                #base_act_jbp_sub{charge_gold = BaseChargeGold, list = BaseDayList} ->
                    case lists:keyfind(BaseChargeGold, 1, ChargeList) of
                        false -> {fail, 17};
                        {BaseChargeGold, ChargeTime} ->
                            case lists:keyfind(Day, 1, BaseDayList) of
                                false -> {fail, 0};
                                {Day, RewardList} ->
                                    NowSec = util:unixdate(),
                                    T = util:unixdate(ChargeTime),
                                    case T+(Day-1)*?ONE_DAY_SECONDS =< NowSec of
                                        false -> {fail, 18};
                                        true -> {true, RewardList}
                                    end
                            end
                    end
            end
    end.

add_charge(Player, ChargeVal) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] -> skip;
        {#base_act_jbp{open_info = OpenInfo}, BaseList} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            case LTime < 2 * ?ONE_DAY_SECONDS of
                true -> skip;
                false ->
                    case lists:keyfind(ChargeVal, #base_act_jbp_sub.charge_gold, BaseList) of
                        false ->
                            skip;
                        _ ->
                            St = lib_dict:get(?PROC_STATUS_ACT_JBP),
                            #st_act_jbp{charge_list = ChargeList} = St,
                            case lists:keyfind(ChargeVal, 1, ChargeList) of
                                {ChargeVal, _ChargeTime} ->
                                    skip;
                                false ->
                                    NewSt =
                                        St#st_act_jbp{
                                            charge_list = [{ChargeVal, util:unixtime()} | ChargeList],
                                            op_time = util:unixtime()
                                        },
                                    lib_dict:put(?PROC_STATUS_ACT_JBP, NewSt),
                                    activity_load:dbup_act_jbp(NewSt)
                            end
                    end
            end
    end.

get_notice_state(Player) ->
    case get_act_info(Player) of
        {0, _, _} -> -1;
        {_LTime, Status, List} ->
            St = lib_dict:get(?PROC_STATUS_ACT_JBP),
            #st_act_jbp{charge_list = ChargeList} = St,
            if
                Status == 2 andalso ChargeList == [] ->
                    -1;
                true ->
                    F = fun([_Id, _BaseChargeGold, DayInfoList]) ->
                        F0 = fun([_Day, IsRecv, _RewardList]) ->
                            ?IF_ELSE(IsRecv == 1, [1], [])
                        end,
                        LL = lists:flatmap(F0, DayInfoList),
                        ?IF_ELSE(LL == [], [], [1])
                    end,
                    LLL = lists:flatmap(F, List),
                    ?IF_ELSE(LLL == [], 0, 1)
            end
    end.