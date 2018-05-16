%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 二月 2017 15:08
%%%-------------------------------------------------------------------
-module(treasure_hourse).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    get_state/1,
    get_act/0,
    add_charge/2,
    midnight_refresh/1,
    update_treasure_hourse/1,

    get_act_info/1,
    recv_login_gift/1,
    buy_gift/2,
    gm/0
]).

init(#player{key = Pkey} = Player) ->
    StTreasureHourse =
        case player_util:is_new_role(Player) of
            true -> #st_treasure_hourse{pkey = Pkey};
            false -> activity_load:dbget_treasure_hourse(Pkey)
        end,
    NewSt = send_mail(StTreasureHourse),
    update_treasure_hourse(NewSt),
    Player.

send_mail(StTreasureHourse) ->
    #st_treasure_hourse{
        pkey = Pkey,
        act_id = ActId,
        recv_time = RecvTime,
        act_open_time = ActOpenTime
    } = StTreasureHourse,
    Now = util:unixtime(),
    Flag1 = util:is_same_date(RecvTime, util:unixdate() - 3600), %% 昨天未操作
    Flag2 = util:is_same_date(RecvTime, Now), %% 今天未操作
    Flag3 = util:is_same_date(Now, ActOpenTime), %% 不是今天新开活动
    Base = data_treasure_hourse:get(ActId),
    if
        Flag1 == false andalso Flag2 == false andalso Flag3 == false andalso ActOpenTime > 0 ->
            if
                RecvTime < ActOpenTime ->
                    ActOpenDay0 = 0;
                true ->  %% 活动上次领取已经过去的天数
                    ActOpenDay0 = (util:unixdate(RecvTime) - util:unixdate(ActOpenTime)) div ?ONE_DAY_SECONDS + 1
            end,
            %% 活动开启天数
            ActOpenDay = (util:unixdate() - util:unixdate(ActOpenTime)) div ?ONE_DAY_SECONDS + 1,
            BaseSubList = Base#base_treasure_hourse.treasure_hourse_sub_list,
            Min = max(ActOpenDay0 + 1, 0),
            Max = min(ActOpenDay - 1, length(BaseSubList)),
            if
                ActOpenDay - 1 < ActOpenDay0 + 1 -> StTreasureHourse;
                Min > Max -> StTreasureHourse;
                true ->
                    F = fun(ActDay) ->
                        #base_treasure_hourse_sub{login_gift = LoginGiftId} =
                            lists:keyfind(ActDay, #base_treasure_hourse_sub.act_open_day, BaseSubList),
                        {Title, Content0} = t_mail:mail_content(62),
                        Content = io_lib:format(Content0, [ActDay]),
                        log(Pkey, ActDay, LoginGiftId),
                        mail:sys_send_mail([Pkey], Title, Content, LoginGiftId)
                    end,
                    lists:map(F, lists:seq(max(ActOpenDay0 + 1, 0), min(ActOpenDay - 1, length(BaseSubList)))),
                    NewSt = StTreasureHourse#st_treasure_hourse{recv_time = util:unixdate() - 3600},
                    activity_load:dbup_treasure_hourse(NewSt),
                    NewSt
            end;
        true ->
            StTreasureHourse
    end.

log(Pkey, ActDay, LoginReward) ->
    {LoginGiftId, _} = hd(LoginReward),
    Sql = io_lib:format("insert into log_treasure_hourse set pkey=~p,act_day=~p,goods_id=~p,goods_num=~p,time=~p",
        [Pkey, ActDay, LoginGiftId, 1, util:unixtime()]),
    log_proc:log(Sql).

%% 更新玩家藏宝状态
update_treasure_hourse() ->
    StTreasureHourse = lib_dict:get(?PROC_STATUS_TREASURE_HOURSE),
    update_treasure_hourse(StTreasureHourse).

update_treasure_hourse(StTreasureHourse) ->
    #st_treasure_hourse{
        pkey = Pkey,
        act_id = ActId,
        charge_gold = ChargeGold,
        op_time = OpTime,
        recv_time = RecvTime,
        act_open_time = ActOpenTime
    } = StTreasureHourse,
    %% 先判断活动是否存在
    NewStTreasureHourse =
        case get_act() of
            [] ->
                #st_treasure_hourse{pkey = Pkey};
            #base_treasure_hourse{act_id = BaseActId, treasure_hourse_sub_list = BaseSubList} ->
                case BaseActId == ActId of
                    false -> %% 活动不同，则切换活动
                        #st_treasure_hourse{act_id = BaseActId, pkey = Pkey};
                    true ->
                        #base_treasure_hourse_sub{limit_charge_gold = LimitChargeGold} = hd(BaseSubList),
                        case ChargeGold >= LimitChargeGold of
                            false -> %% 活动相同，活动没有开启
                                #st_treasure_hourse{act_id = ActId, pkey = Pkey, charge_gold = ChargeGold, op_time = util:unixtime(), recv_time = RecvTime};
                            true -> %% 活动相同，活动有开启
                                ActOpenDay = (util:unixdate() - util:unixdate(ActOpenTime)) div ?ONE_DAY_SECONDS + 1,
                                case util:is_same_date(OpTime, util:unixtime()) of
                                    false -> %% 非同一天
                                        StTreasureHourse#st_treasure_hourse{buy_list = [], is_recv = 0, act_open_day = ActOpenDay, op_time = util:unixtime()};
                                    true -> %% 同一天
                                        StTreasureHourse#st_treasure_hourse{act_open_day = ActOpenDay}
                                end
                        end
                end
        end,
    lib_dict:put(?PROC_STATUS_TREASURE_HOURSE, NewStTreasureHourse),
    ok.

gm() ->
    StTreasureHourse = lib_dict:get(?PROC_STATUS_TREASURE_HOURSE),
    NewStTreasureHourse = StTreasureHourse#st_treasure_hourse{buy_list = [], is_recv = 0},
    lib_dict:put(?PROC_STATUS_TREASURE_HOURSE, NewStTreasureHourse).

%% 购买限购礼包
buy_gift(Player, Id) ->
    update_treasure_hourse(),
    StTreasureHourse = lib_dict:get(?PROC_STATUS_TREASURE_HOURSE),
    #st_treasure_hourse{act_id = ActId, buy_list = BuyList, act_open_day = ActOpenDay} = StTreasureHourse,
    case data_treasure_hourse:get(ActId) of
        #base_treasure_hourse{treasure_hourse_sub_list = BaseSubList} when ActOpenDay =< length(BaseSubList) ->
            #base_treasure_hourse_sub{buy_gift_list = BaseBuyGiftList} =
                lists:keyfind(ActOpenDay, #base_treasure_hourse_sub.act_open_day, BaseSubList),
            %% 已经购买的次数
            BuyNum0 =
                case lists:keyfind(Id, 1, BuyList) of
                    false -> 0;
                    {Id, Num0} -> Num0
                end,
            %% 获取配置限购次数及配置价格
            {Price, BuyNum1, BuyReward} =
                case lists:keyfind(Id, 1, BaseBuyGiftList) of
                    false -> {0, 0, []};
                    {_Id, _BasePrice, Price1, BaseBuyNum1, GiftId0, _ShowType, _ShowStage} ->
                        {Price1, BaseBuyNum1, GiftId0}
                end,
            IsEnough = money:is_enough(Player, Price, gold),
            if
                BuyNum0 >= BuyNum1 -> {Player, 19}; %% 购买次数不足
                IsEnough == false -> {Player, 5}; %% 钻石不足
                true ->
                    NPlayer = money:add_no_bind_gold(Player, -Price, 601, 0, 0),
                    GiveGoodsList = goods:make_give_goods_list(602, BuyReward),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    NewR = {Id, BuyNum0 + 1},
                    NewBuyList =
                        if
                            BuyNum0 == 0 ->
                                [NewR | BuyList];
                            true ->
                                lists:keyreplace(Id, 1, BuyList, NewR)
                        end,
                    NewStTreasureHourse = StTreasureHourse#st_treasure_hourse{buy_list = NewBuyList, op_time = util:unixtime()},
                    lib_dict:put(?PROC_STATUS_TREASURE_HOURSE, NewStTreasureHourse),
                    activity_load:dbup_treasure_hourse(NewStTreasureHourse),
                    activity:get_notice(NewPlayer, [31], true),
                    {NewPlayer, 1}
            end;
        _ ->
            {Player, 4} %% 活动过期
    end.

%% 领取登陆礼包
recv_login_gift(Player) ->
    update_treasure_hourse(),
    StTreasureHourse = lib_dict:get(?PROC_STATUS_TREASURE_HOURSE),
    #st_treasure_hourse{
        act_id = ActId,
        is_recv = IsRecv,
        act_open_day = ActOpenDay
    } = StTreasureHourse,
    #base_treasure_hourse{treasure_hourse_sub_list = BaseSubList} =
        data_treasure_hourse:get(ActId),
    if
        IsRecv == 1 -> {3, Player}; %% 已经领取
        length(BaseSubList) < ActOpenDay -> {4, Player};
        ActOpenDay == 0 -> {4, Player}; %% 过期
        true ->
            #base_treasure_hourse_sub{login_gift = LoginGiftId} =
                lists:keyfind(ActOpenDay, #base_treasure_hourse_sub.act_open_day, BaseSubList),
            GiveGoodsList = goods:make_give_goods_list(600, LoginGiftId),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            NewStTreasureHourse =
                StTreasureHourse#st_treasure_hourse{
                    is_recv = 1,
                    op_time = util:unixtime(),
                    recv_time = util:unixtime()
                },
            lib_dict:put(?PROC_STATUS_TREASURE_HOURSE, NewStTreasureHourse),
            activity_load:dbup_treasure_hourse(NewStTreasureHourse),
            activity:get_notice(NewPlayer, [31], true),
            log(Player#player.key, ActOpenDay, LoginGiftId),
            {1, NewPlayer}
    end.

%% 读取面板信息
get_act_info(Player) ->
    case get_state(Player) of
        -1 ->
            {2, [], 0, 0, 0, []};
        _ ->
            get_act_info1(Player)
    end.

get_act_info1(_Player) ->
    StTreasureHourse = lib_dict:get(?PROC_STATUS_TREASURE_HOURSE),
    #st_treasure_hourse{
        act_id = ActId,
        is_recv = IsRecv,
        buy_list = BuyList,
        act_open_day = ActOpenDay
    } = StTreasureHourse,
    #base_treasure_hourse{treasure_hourse_sub_list = BaseSubList} = data_treasure_hourse:get(ActId),
    RemainRefreshTime = max(0, ?ONE_DAY_SECONDS - (util:unixtime() - util:unixdate())),
    #base_treasure_hourse_sub{login_gift = LoginReward, buy_gift_list = BaseBuyGiftList, show_day = ShowDay} =
        case lists:keyfind(ActOpenDay, #base_treasure_hourse_sub.act_open_day, BaseSubList) of
            false ->
                ?ERR("ActOpenDay:~p~n", [ActOpenDay]),
                hd(BaseSubList);
            Base ->
                Base
        end,
    RecvState = if
                    IsRecv == 0 ->
                        1; %% 协议可领
                    true ->
                        2  %% 协议已领
                end,
    F = fun({Id, BasePrice, Price, BaseBuyNum, GiftId, ShowType, ShowStage}) ->
        case lists:keyfind(Id, 1, BuyList) of
            false ->
                [Id, Price, BasePrice, BaseBuyNum, max(0, BaseBuyNum), ShowType, ShowStage, util:list_tuple_to_list(GiftId)];
            {Id, BuyNum} ->
                [Id, Price, BasePrice, BaseBuyNum, max(0, BaseBuyNum - BuyNum), ShowType, ShowStage, util:list_tuple_to_list(GiftId)]
        end
    end,
    BuyGoodsInfoList = lists:map(F, BaseBuyGiftList),
    {RecvState, util:list_tuple_to_list(LoginReward), ActOpenDay, RemainRefreshTime, ShowDay, BuyGoodsInfoList}.

%% 晚上12点重置，不操作数据库
midnight_refresh(_ResetTime) ->
    StTreasureHourse = lib_dict:get(?PROC_STATUS_TREASURE_HOURSE),
    case config:is_debug() of
        true ->
            NewSt = send_mail(StTreasureHourse),
            update_treasure_hourse(NewSt);
        false ->
            Rand = util:rand(5000, 10000),
            spawn(fun() -> timer:sleep(1000 + Rand), send_mail(StTreasureHourse) end),
            update_treasure_hourse(StTreasureHourse)
    end.

%% 获取活动状态
get_state(_Player) ->
    StTreasureHoure = lib_dict:get(?PROC_STATUS_TREASURE_HOURSE),
    #st_treasure_hourse{
        act_id = ActId,
        charge_gold = ChargeGold,
        act_open_day = ActOpenDay,
        is_recv = IsRecv
    } = StTreasureHoure,
    case get_act() of
        [] ->
            case data_treasure_hourse:get(ActId) of
                [] ->
                    -1;
                #base_treasure_hourse{treasure_hourse_sub_list = BaseSubList} ->
                    if
                        ActOpenDay == 0 -> -1; %% 玩家未开此活动
                        ActOpenDay > length(BaseSubList) -> -1; %% 持续活动结束
                        IsRecv == 0 -> 1; %% 可以领登陆礼包，红点提示
                        true ->
                            0
                    end
            end;
        #base_treasure_hourse{treasure_hourse_sub_list = BaseSubList} ->
            #base_treasure_hourse_sub{limit_charge_gold = LimitChargeGold} = hd(BaseSubList),
            if
                ActOpenDay > length(BaseSubList) -> -1; %% 持续活动结束
                ChargeGold < LimitChargeGold -> -1; %% 没有达到目标充值额度
                IsRecv == 0 -> 1; %% 可以领登陆礼包，红点提示
                true ->
                    0
            end
    end.

%% 增加额度
add_charge(_Player, AddChargeGold) ->
    StTreasureHourse = lib_dict:get(?PROC_STATUS_TREASURE_HOURSE),
    case get_act() of
        [] ->
            skip;
        #base_treasure_hourse{treasure_hourse_sub_list = BaseSubList} ->
            #base_treasure_hourse_sub{limit_charge_gold = LimitChargeGold} = hd(BaseSubList),
            NewStTreasureHoure =
                if
                    StTreasureHourse#st_treasure_hourse.charge_gold + AddChargeGold < LimitChargeGold ->
                        StTreasureHourse#st_treasure_hourse{
                            charge_gold = StTreasureHourse#st_treasure_hourse.charge_gold + AddChargeGold
                        };
                    StTreasureHourse#st_treasure_hourse.act_open_time > 0 ->
                        StTreasureHourse#st_treasure_hourse{
                            charge_gold = StTreasureHourse#st_treasure_hourse.charge_gold + AddChargeGold
                        };
                    true ->
                        StTreasureHourse#st_treasure_hourse{
                            charge_gold = StTreasureHourse#st_treasure_hourse.charge_gold + AddChargeGold,
                            act_open_time = util:unixtime()
                        }
                end,
            lib_dict:put(?PROC_STATUS_TREASURE_HOURSE, NewStTreasureHoure),
            update_treasure_hourse(),
            CastSt = lib_dict:get(?PROC_STATUS_TREASURE_HOURSE),
            activity_load:dbup_treasure_hourse(CastSt)
    end.


get_act() ->
    case activity:get_work_list(data_treasure_hourse) of
        [] -> [];
        [Base | _] -> Base
    end.
