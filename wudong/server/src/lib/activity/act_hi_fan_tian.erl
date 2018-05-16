%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         全名hi翻天
%%% @end
%%% Created : 02. 八月 2017 11:39
%%%-------------------------------------------------------------------
-module(act_hi_fan_tian).
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").
-include("daily.hrl").
-author("lzx").

%% API
-export([get_info/1,
    get_award/2,
    get_act/0,
    get_state/1,
    trigger_finish/3,
    trigger_finish_api/3,
    trigger_finish_api/4,
    trigger_charge_money/2
]).


%% API
-export([
    init/1,
    update/1,
    log_out/0
]).

init(Player) ->
    Val0 = daily:get_count(?DAILY_HI_FAN_TIAN_POINT),
    List0 = daily:get_count(?DAILY_HI_FAN_TIAN_GET_LIST, []),
    NewSt = #st_hi_fan{
        pkey = Player#player.key,
        act_id = 0,
        val = Val0, %% hi点
        list = List0
    },
    Sql = io_lib:format("select list,val,act_id,last_login_time from player_hi_fan where pkey = ~p", [Player#player.key]),
    St = case db:get_row(Sql) of
             [] -> NewSt;
             [List, Val, ActId, LastTime] ->
                 #st_hi_fan{
                     pkey = Player#player.key,
                     act_id = ActId,
                     last_login_time = LastTime,
                     val = Val,
                     list = util:bitstring_to_term(List)
                 }
         end,
    put_dict(St),
    update(Player),
    Player.

log_out() ->
    St = get_dict(),
    #st_hi_fan{
        pkey = Pkey,
        act_id = ActId,
        val = Val, %% hi点
        list = List,
        last_login_time = LastTime
    } = St,
    UpSql = io_lib:format("replace into player_hi_fan set act_id=~p,val=~p,list='~s',last_login_time = ~p, pkey=~p",
        [ActId, Val, util:term_to_bitstring(List), LastTime, Pkey]),
    db:execute(UpSql),
    ok.

update(Player) ->
    St = get_dict(),
    #st_hi_fan{
        val = CurHiPoint,
        list = GetList,
        act_id = ActId,
        last_login_time = LastTime
    } = St,
    Now = util:unixtime(),
    Flag = util:is_same_date(Now, LastTime),
    if
        Flag == false ->
            Base = data_act_hi_fan_tian:get(ActId),
            if
                Base == [] -> skip;
                true ->
                    AwardIds = Base#base_hi_fan_tian.award_list,
                    F = fun({Id, Point, GoodsList}, List0) ->
                        case lists:member(Id, GetList) of
                            true -> List0;%%以领取
                            false ->
                                if
                                    CurHiPoint >= Point -> GoodsList ++ List0;
                                    true -> List0
                                end
                        end
                        end,
                    MailGoodsList = lists:foldl(F, [], AwardIds),
                    if
                        MailGoodsList == [] -> skip;
                        true ->
                            spawn(fun() ->
                                SleepTime = util:random(10, 20),
                                util:sleep(SleepTime * 1000),
                                Content = io_lib:format(?T("上仙，这是您未领取的嗨翻奖励，不要忘了查收附件哦"), []),
                                mail:sys_send_mail([Player#player.key], ?T("全民嗨翻奖励发送"), Content, MailGoodsList)
                                  end
                            )
                    end

            end,
            case get_act() of
                [] -> NewActId = 0;
                Base0 -> NewActId = Base0#base_hi_fan_tian.act_id
            end,
            NewSt = #st_hi_fan{pkey = Player#player.key, last_login_time = Now, act_id = NewActId};
        true ->
            NewSt = St#st_hi_fan{last_login_time = Now}
    end,
    put_dict(NewSt),
    ok.

put_dict(StLotteryTurn) ->
    lib_dict:put(?PROC_STATUS_HI_FAN_TIAN, StLotteryTurn).

get_dict() ->
    case lib_dict:get(?PROC_STATUS_HI_FAN_TIAN) of
        St when is_record(St, st_hi_fan) ->
            St;
        _ ->
            #st_hi_fan{}
    end.

get_act() ->
    case activity:get_work_list(data_act_hi_fan_tian) of
        [Base | _] -> Base;
        _ ->
            []
    end.

is_open() ->
    case get_act() of
        [] -> false;
        _ -> true
    end.

trigger_finish_api(Player, Hid, Time) ->
    trigger_finish_api(Player, Hid, Time, []).

trigger_finish_api(#player{pid = Pid}, Hid, Time, ConditionList) ->
    case self() == Pid of
        true ->
            trigger_finish(Hid, Time, ConditionList);
        _ ->
            player:apply_info(Pid, {?MODULE, trigger_finish, [Hid, Time, ConditionList]})
    end.

%% @doc 触发
trigger_finish(HType, Time, Conds1) ->
    case is_open() of
        true ->
            TypeList = data_hi_config:id_types(HType),
            lists:foreach(fun(Hid) ->
                case data_hi_config:get(Hid) of
                    #base_hi_config{val = Val, time_limit = TimeLimit, condition = Cond2} ->
                        case Cond2 of
                            [] ->
                                finish_count(Hid, Time, Val, TimeLimit);
                            Cond2List ->
                                case match_cond(Hid, Conds1, Cond2List) of
                                    true ->
                                        finish_count(Hid, Time, Val, TimeLimit);
                                    _ ->
                                        skip
                                end
                        end;
                    _ ->
                        skip
                end
                          end, TypeList);
        _ ->
            skip
    end,
    ok.

%%CondList = [{826,[{18,[]},{19,[{charge,99690}]},{20,[{charge,99490}]},{21,[{charge,99010}]}]},{819,33},{119,99990},{818,[{19,1},{20,1},{21,1}]}]


match_cond(Hid, Conds1, Cond2List) ->
    CondList = daily:get_count(?DAILY_HI_FAN_TIAN_GET_CON, []),
    %%以达成条件列表
    case lists:keyfind(Hid, 1, CondList) of
        {_, Cons} -> ok;
        _ ->
            Cons = []
    end,
    %% 筛选符合配置的条件
    MatchList =
        lists:foldl(fun({Key, Val}, AccList) ->
            case lists:keyfind(Key, 1, Cond2List) of
                false ->
                    AccList;
                {_, _} ->
                    [{Key, Val} | AccList]
            end
                    end, [], Conds1),

    SumConList = sum_con_list(MatchList, Cons),
    %%比较下条件是否满足了
    case compare_con(Cond2List, SumConList, []) of
        {ok, NewConList} -> %%满足条件了
            NewTimeList = lists:keystore(Hid, 1, CondList, {Hid, NewConList}),
            daily:set_count(?DAILY_HI_FAN_TIAN_GET_CON, NewTimeList),
            true;
        _ ->
            NewTimeList = lists:keystore(Hid, 1, CondList, {Hid, SumConList}),
            daily:set_count(?DAILY_HI_FAN_TIAN_GET_CON, NewTimeList),
            false
    end.

sum_con_list([], _Conds) -> _Conds;
sum_con_list([{Key, Val} | T], Cons) ->
    case lists:keytake(Key, 1, Cons) of
        {value, {_, Val2}, ConsList} ->
            sum_con_list(T, [{Key, Val + Val2} | ConsList]);
        false ->
            sum_con_list(T, [{Key, Val} | Cons])
    end.

compare_con([], _, NewConList) -> {ok, NewConList};
compare_con([{Key, Val} | T], SumConList, NewConList) ->
    case lists:keytake(Key, 1, SumConList) of
        {value, {_, Val2}, _ConsList} when Val2 >= Val ->
            compare_con(T, SumConList, NewConList);
        _ ->
            false
    end.


finish_count(Hid, Time, Val, TimeLimit) ->
    TimeCntList = daily:get_count(?DAILY_HI_FAN_TIAN_TIME, []),
    TodayPoint = daily:get_count(?DAILY_HI_FAN_TIAN_POINT, 0),
    case lists:keyfind(Hid, 1, TimeCntList) of
        {_, CurTime} -> ok;
        _ ->
            CurTime = 0
    end,
    case CurTime >= TimeLimit of
        true -> skip;
        false ->
            NewTime = min(CurTime + Time, TimeLimit),
            NewPoint = (NewTime - CurTime) * Val + TodayPoint,
            NewTimeList = lists:keystore(Hid, 1, TimeCntList, {Hid, NewTime}),
            daily:set_count(?DAILY_HI_FAN_TIAN_TIME, NewTimeList),
            daily:set_count(?DAILY_HI_FAN_TIAN_POINT, NewPoint),
            St = get_dict(),
            put_dict(St#st_hi_fan{val = NewPoint}),
            log_act_hi_fan_point(St, Hid, NewTime, NewPoint)
    end.


%% @doc 获取开启状态
get_state(_Player) ->
    case get_act() of
        #base_hi_fan_tian{award_list = AwardIds, act_info = ActInfo} ->
            GetList = daily:get_count(?DAILY_HI_FAN_TIAN_GET_LIST, []),
            CurHiPoint = daily:get_count(?DAILY_HI_FAN_TIAN_POINT, 0),
            State =
                lists:any(fun({ActId, Point, _GoodsList}) ->
                    case lists:member(ActId, GetList) of
                        true -> false;%%以领取
                        false ->
                            CurHiPoint >= Point
                    end
                          end, AwardIds),
            Args = activity:get_base_state(ActInfo),
            ?IF_ELSE(State, {1, Args}, {0, Args});
        _ ->
            -1
    end.


%% @doc  获取全民hi翻天面板信息
get_info(_Player) ->
    case get_act() of
        #base_hi_fan_tian{award_list = AwardIds} ->
            LeaveTime = activity:get_leave_time(data_act_hi_fan_tian),
            GetList = daily:get_count(?DAILY_HI_FAN_TIAN_GET_LIST, []),
            CurHiPoint = daily:get_count(?DAILY_HI_FAN_TIAN_POINT, 0),
            TimeCntList = daily:get_count(?DAILY_HI_FAN_TIAN_TIME, []),
            AwardPackList =
                lists:map(fun({ActId, Point, GoodsList}) ->
                    NewGoodsList = [[GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- GoodsList],
                    State = case lists:member(ActId, GetList) of
                                true -> 2;%%以领取
                                false ->
                                    case CurHiPoint >= Point of
                                        true -> 1; %%可领取
                                        false -> 0 %%0未达成
                                    end
                            end,
                    [ActId, Point, State, NewGoodsList]
                          end, AwardIds),
            ConfigList = data_hi_config:ids(),
            HiPackList =
                lists:map(fun(HiId) ->
                    #base_hi_config{fun_id = {FunID, FunSubId}, val = GetNum, time_limit = TarVal, desc = DescName, condition = Condition} = data_hi_config:get(HiId),
                    case lists:keyfind(HiId, 1, TimeCntList) of
                        {_, CurHiNum} -> ok;
                        _ ->
                            CurHiNum = 0
                    end,
                    ArgList = [Args || {_, Args} <- Condition],
                    [HiId, CurHiNum, TarVal, GetNum, FunID, FunSubId, DescName, ArgList]
                          end, ConfigList),
            {LeaveTime, AwardPackList, CurHiPoint, HiPackList};
        _ ->
            {0, [], 0, []}
    end.


%% 领取奖励 2没达到领取条件，3ID不存在，4活动未开启
get_award(Player, _ActId) ->
    case get_act() of
        #base_hi_fan_tian{award_list = AwardList} ->
            case lists:keyfind(_ActId, 1, AwardList) of
                {_, NeedPoint, GoodsList} ->
                    CurHiPoint = daily:get_count(?DAILY_HI_FAN_TIAN_POINT, 0),
                    GetList = daily:get_count(?DAILY_HI_FAN_TIAN_GET_LIST, []),
                    case not lists:member(_ActId, GetList) andalso CurHiPoint >= NeedPoint of
                        true ->
                            NewGetList = [_ActId | GetList],
                            daily:set_count(?DAILY_HI_FAN_TIAN_GET_LIST, NewGetList),
                            log_act_hi_fan_tian(Player, _ActId, GoodsList),
                            GiveGoodsList = goods:make_give_goods_list(674, GoodsList),
                            St = get_dict(),
                            put_dict(St#st_hi_fan{list = NewGetList}),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            {ok, NewPlayer};
                        false ->
                            {fail, 2}
                    end;
                _ ->
                    {fail, 3}
            end;
        _ ->
            {fail, 4}
    end.

%% 领取日志
log_act_hi_fan_tian(#player{key = Pkey, nickname = NickName}, ActId, GoodsList) ->
    Sql = io_lib:format("insert into log_act_hi_fan_tian set pkey=~p,nickname = '~s',hi_id=~p,goods_list='~s',time=~p",
        [Pkey, NickName, ActId, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql).


%% 增加日志
log_act_hi_fan_point(#st_hi_fan{pkey = Pkey, act_id = ActId}, Hid, NewTime, NewPoint) ->
    #base_hi_config{desc = Desc} = data_hi_config:get(Hid),
    Sql = io_lib:format("insert into log_act_hi_fan_point set pkey = ~w,act_id = ~w,hi_id = ~w,`desc` = '~s',curtime = ~w,hi_point = ~w,`time` = ~w", [
        Pkey, ActId, Hid, Desc
        , NewTime, NewPoint, util:unixtime()
    ]),
    log_proc:log(Sql).


%% TODO 这里没用了
%% 触发充值条件
trigger_charge_money(_Player, _ChargeVal) -> ok.
%%    ChargeIds = [19, 20, 21, 22, 23],
%%    lists:foreach(fun(ActId) ->
%%        case data_hi_config:get(ActId) of
%%            #base_hi_config{} ->
%%                trigger_finish_api(Player, ActId, 1, [{charge, ChargeVal}]);
%%            _ ->
%%                ok
%%        end
%%    end, ChargeIds).


