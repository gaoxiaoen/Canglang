%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 疯狂砸蛋
%%% @end
%%% Created : 25. 八月 2017 17:14
%%%-------------------------------------------------------------------
-module(act_throw_egg).
-author("luobq").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").

-define(DAILY_ONLINE_FREE_TIME, 1200).

%% API
-export([
    init/1,
    update/1,
    logout/1,
    get_act/0,
    get_info/1,
    init_ets/0,
    get_state/1,
    reset_info/1,
    draw_reward/2,
    count_reward/2,
    get_leave_time/0,
    update_online_time/1
]).

init(Player) ->
    St = activity_load:dbget_act_throw_egg(Player#player.key),
    put_dict(St),
    update(Player),
    Player.

update(Player) ->
    St = get_dict(),
    #st_act_throw_egg{
        act_id = ActId,
        last_login_time = UpdateTime
    } = St,
    Now = util:unixtime(),
    NewSt =
        case get_act() of
            [] ->
                back_find(Player, ActId),
                #st_act_throw_egg{pkey = Player#player.key, last_login_time = Now};
            Base ->
                #base_act_throw_egg{
                    act_id = BaseActId
                } = Base,
                EggInfo = init_egg_info(),
                case util:is_same_date(Now, UpdateTime) of
                    false ->
                        back_find(Player, ActId),
                        #st_act_throw_egg{
                            act_id = BaseActId,
                            pkey = Player#player.key,
                            last_login_time = Now,
                            egg_info = EggInfo
                        };
                    true ->
                        case ActId == BaseActId of
                            false ->
                                back_find(Player, ActId),
                                #st_act_throw_egg{
                                    act_id = BaseActId,
                                    pkey = Player#player.key,
                                    last_login_time = Now,
                                    egg_info = EggInfo
                                };
                            true ->
                                St
                        end
                end
        end,
    put_dict(NewSt),
    ok.

back_find(Player, ActId) ->
    St = get_dict(),
    Base = data_act_throw_egg:get(ActId),
    if
        Base == [] -> skip;
        true ->
            OldCountList = St#st_act_throw_egg.count_list,
            OldCount = St#st_act_throw_egg.count,
            Base#base_act_throw_egg.count_reward,
            F = fun({Id, Count, GoodsId, GoodsNum}, List) ->
                case lists:keyfind(Id, 1, OldCountList) of
                    {Id, _, _State} -> List;
                    false ->
                        ?IF_ELSE(Count =< OldCount, [{GoodsId, GoodsNum} | List], List)
                end
            end,
            MailGoodsList = lists:foldl(F, [], Base#base_act_throw_egg.count_reward),
            if
                MailGoodsList == [] -> skip;
                true -> Content = io_lib:format(?T("上仙，这是您未领取的疯狂砸蛋奖励，不要忘了查收附件哦"), []),
                    mail:sys_send_mail([Player#player.key], ?T("疯狂砸蛋奖励发送"), Content, MailGoodsList)
            end
    end,
    ok.

init_ets() ->
    ets:new(?ETS_ACT_THROW_EGG_LOG, [{keypos, #act_throw_egg_log.act_id} | ?ETS_OPTIONS]),
    ok.

init_egg_info() ->
    case get_act() of
        [] -> [];
        #base_act_throw_egg{egg_ratio = Ratio} ->
            F = fun(Id, List) ->
                Ratio0 = util:random(1, 100),
                if
                    Ratio0 =< Ratio -> State = 1;
                    true -> State = 0
                end,
                [{Id, 0, State, 0, 0} | List]
            end,
            lists:foldl(F, [], lists:seq(1, 6))
    end.

get_info(Player) ->
    update_online_time(Player),
    St = get_dict(),
    case get_act() of
        [] -> {0, 0, 0, 0, 0, 0, [], [], [], []};
        Base ->
            #base_act_throw_egg{
                cost = Cost
                , re_cost = ReCost
                , count_reward = CountReward0
                , general_reward = GeneralReward0
                , free_reset_count = FreeResetCount
                , online_time_reward = OnlineTimeReward
            } = Base,
            LeaveTime = get_leave_time(),
            GeneralReward = [[GoodsId0, GoodsNum0] || {GoodsId0, GoodsNum0, _} <- GeneralReward0],
            CountList = St#st_act_throw_egg.count_list,
            Count = St#st_act_throw_egg.count,
            F = fun({Id1, Count1, GoodsId1, GoodsNum1}, List) ->
                case lists:keyfind(Id1, 1, CountList) of
                    false ->
                        State0 = ?IF_ELSE(Count >= Count1, 1, 0),
                        [[Id1, Count1, State0, GoodsId1, GoodsNum1] | List];
                    {Id1, Count1, State} ->
                        State0 = ?IF_ELSE(Count >= Count1 andalso State == 0, 1, State),
                        [[Id1, Count1, State0, GoodsId1, GoodsNum1] | List]
                end
            end,
            CountReward = lists:foldl(F, [], CountReward0),
            EggInfo = [tuple_to_list(X) || X <- St#st_act_throw_egg.egg_info],
            LogList = get_log(),
            FreeTime = max(0, OnlineTimeReward - St#st_act_throw_egg.online_time),
            FreeCount = ?IF_ELSE(FreeTime == 0 andalso St#st_act_throw_egg.is_free == 0, 1, 0),
            ReCost1 = ?IF_ELSE(St#st_act_throw_egg.re_set_count < FreeResetCount, 0, ReCost),
            {LeaveTime, St#st_act_throw_egg.count, FreeCount, Cost, ReCost1, FreeTime, GeneralReward, CountReward, EggInfo, LogList}
    end.

reset_info(Player) ->
    case get_act() of
        [] -> {0, Player};
        #base_act_throw_egg{re_cost = Cost0, free_reset_count = FreeResetCount} ->
            St = get_dict(),
            Cost = ?IF_ELSE(St#st_act_throw_egg.re_set_count < FreeResetCount, 0, Cost0),
            case money:is_enough(Player, Cost, gold) of
                false -> {5, Player};
                _ ->
                    EggInfo = init_egg_info(),
                    NewSt = St#st_act_throw_egg{egg_info = EggInfo, re_set_count = St#st_act_throw_egg.re_set_count + 1},
                    NewPlayer = money:add_no_bind_gold(Player, -Cost, 538, 0, 0),
                    put_dict(NewSt),
                    activity_load:dbup_act_throw_egg(NewSt),
                    {1, NewPlayer}
            end
    end.

draw_reward(Player, Id) ->
    case Id of
        0 -> draw_reward_all(Player);
        _ -> draw_reward_one(Player, Id)
    end.

draw_reward_all(Player) ->
    case check_draw_reward_all(Player) of
        {false, Res} ->
            St = get_dict(),
            {Res, Player, [tuple_to_list(X) || X <- St#st_act_throw_egg.egg_info]};
        {ok, Cost, IsFree, TypeList} ->
            NewPlayer = money:add_no_bind_gold(Player, -Cost, 539, 0, 0),
            St = get_dict(),
            Base = get_act(),
            F = fun({Id, Type}, {RewaedList, InfoList0}) ->
                Reward =
                    if Type == 1 -> Base#base_act_throw_egg.sp_reward;
                        true -> Base#base_act_throw_egg.general_reward
                    end,
                RatioList = [{{GoodsId1, GoodsNum1}, Ratio} || {GoodsId1, GoodsNum1, Ratio} <- Reward],
                {GoodsId, GoodsNum} = util:list_rand_ratio(RatioList),
                InfoList1 = lists:keydelete(Id, 1, InfoList0),
                {[{GoodsId, GoodsNum} | RewaedList], [{Id, 1, Type, GoodsId, GoodsNum} | InfoList1]}
            end,
            {GoodsList, InfoList} = lists:foldl(F, {[], St#st_act_throw_egg.egg_info}, TypeList),
            %%  NewEggInfo = init_egg_info(),
            NewSt = St#st_act_throw_egg{egg_info = InfoList, count = St#st_act_throw_egg.count + length(TypeList), is_free = IsFree},
            put_dict(NewSt),
            activity_load:dbup_act_throw_egg(NewSt),
            insert(Base#base_act_throw_egg.act_id, Player#player.nickname, GoodsList),
            notice(Player, GoodsList),
            log_throw_egg(Player#player.key, Player#player.nickname, Cost, GoodsList),
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(539, GoodsList)),
            {1, NewPlayer1, [tuple_to_list(X) || X <- InfoList]}
    end.

check_draw_reward_all(Player) ->
    case get_act() of
        [] -> {false, 0};
        #base_act_throw_egg{cost = Cost0, online_time_reward = OnlineTimeReward} ->
            St = get_dict(),
            TypeList = [{Id, Type} || {Id, State, Type, _, _} <- St#st_act_throw_egg.egg_info, State == 0],
            {IsFree, Reduce} = ?IF_ELSE(St#st_act_throw_egg.online_time > OnlineTimeReward andalso St#st_act_throw_egg.is_free == 0, {1, 1}, {St#st_act_throw_egg.is_free, 0}),
            Len = length(TypeList),
            Cost = max(0, (Len - Reduce) * Cost0),
            case money:is_enough(Player, Cost, gold) of
                false ->
                    {false, 5};
                true ->
                    if
                        Len == 0 -> {false, 20};
                        true ->
                            {ok, Cost, IsFree, TypeList}
                    end
            end
    end.

draw_reward_one(Player, Id) ->
    case check_draw_reward(Player, Id) of
        {false, Res} ->
            St = get_dict(),
            {Res, Player, [tuple_to_list(X) || X <- St#st_act_throw_egg.egg_info]};
        {ok, Cost, IsFree} ->
            Base = get_act(),
            NewPlayer = money:add_no_bind_gold(Player, -Cost, 539, 0, 0),
            St = get_dict(),
            {value, {Id, _State, Type, _GoodsId0, _GoodsNum0}, List} = lists:keytake(Id, 1, St#st_act_throw_egg.egg_info),
            Reward = if
                         Type == 1 -> Base#base_act_throw_egg.sp_reward;
                         true -> Base#base_act_throw_egg.general_reward
                     end,
            RatioList = [{{GoodsId1, GoodsNum1}, Ratio} || {GoodsId1, GoodsNum1, Ratio} <- Reward],
            {GoodsId, GoodsNum} = util:list_rand_ratio(RatioList),
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(539, [{GoodsId, GoodsNum}])),
            EggInfo = [{Id, 1, Type, GoodsId, GoodsNum} | List],
            NewSt = St#st_act_throw_egg{egg_info = EggInfo, count = St#st_act_throw_egg.count + 1, is_free = IsFree},
            put_dict(NewSt),
            activity_load:dbup_act_throw_egg(NewSt),
            insert(Base#base_act_throw_egg.act_id, Player#player.nickname, [{GoodsId, GoodsNum}]),
            log_throw_egg(Player#player.key, Player#player.nickname, Cost, [{GoodsId, GoodsNum}]),
            notice(Player, [{GoodsId, GoodsNum}]),
            {1, NewPlayer1, [tuple_to_list(X) || X <- EggInfo]}
    end.

notice(Player, GoodsList) ->
    Base = get_act(),
    List0 = lists:sublist(Base#base_act_throw_egg.general_reward, 5) ++ lists:sublist(Base#base_act_throw_egg.sp_reward, 5),
    List = [GoodsId0 || {GoodsId0, _, _} <- List0],
    F = fun({GoodsId, GoodsNum}) ->
        case lists:member(GoodsId, List) of
            true ->
                if
                    GoodsId == 10199 -> %% 元宝特殊公告
                        Content = io_lib:format(t_tv:get(257), [t_tv:pn(Player), gn(GoodsId, GoodsNum)]),
                        notice:add_sys_notice(Content, 257);
                    true ->
                        Content = io_lib:format(t_tv:get(257), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
                        notice:add_sys_notice(Content, 257)
                end;
            false ->
                skip
        end
    end,
    lists:foreach(F, GoodsList),
    ok.

gn(GoodsId, GoodsNum) ->
    BaseGoods = data_goods:get(GoodsId),
    #goods_type{
        goods_name = Name,
        color = Color
    } = BaseGoods,
    io_lib:format("[#$a type=3 color=~p ]~p~s[#$/a]", [Color, GoodsNum, util:to_list(Name)]).

check_draw_reward(Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        #base_act_throw_egg{cost = Cost, online_time_reward = OnlineTimeReward} ->
            St = get_dict(),
            case lists:keyfind(Id, 1, St#st_act_throw_egg.egg_info) of
                false -> {false, 0};
                {Id, State, _Type, _GoodsId, _GoodsNum} ->
                    if
                        State == 1 -> {false, 18};
                        true ->
                            if
                                St#st_act_throw_egg.online_time > OnlineTimeReward andalso St#st_act_throw_egg.is_free == 0 ->
                                    {ok, 0, 2};
                                true ->
                                    case money:is_enough(Player, Cost, gold) of
                                        false -> {false, 5};
                                        true -> {ok, Cost, St#st_act_throw_egg.is_free}
                                    end
                            end
                    end
            end
    end.

count_reward(Player, Id) ->
    case get_act() of
        [] -> {0, Player};
        Base ->
            St = get_dict(),
            Base#base_act_throw_egg.count_reward,
            case lists:keyfind(Id, 1, Base#base_act_throw_egg.count_reward) of
                false -> {0, Player};
                {Id, Count, GoodsId, GoodsNum} ->
                    if
                        St#st_act_throw_egg.count < Count -> {19, Player};
                        true ->
                            case lists:keyfind(Id, 1, St#st_act_throw_egg.count_list) of
                                false ->
                                    NewSt = St#st_act_throw_egg{count_list = [{Id, Count, 2} | St#st_act_throw_egg.count_list]},
                                    put_dict(NewSt),
                                    activity_log:log_get_goods([{GoodsId, GoodsNum}], Player#player.key, Player#player.nickname, 540),
                                    activity_load:dbup_act_throw_egg(NewSt),
                                    log_throw_egg_count(Player#player.key, Player#player.nickname, Count, [{GoodsId, GoodsNum}]),
                                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(540, [{GoodsId, GoodsNum}])),
                                    {1, NewPlayer};
                                _ ->
                                    {3, Player}
                            end
                    end
            end
    end.

update_online_time(Player) ->
    Now = util:unixtime(),
    St = get_dict(),
    Flag = util:is_same_date(Now, St#st_act_throw_egg.last_login_time),
    #st_act_throw_egg{
        online_time = OnlineTime,
        last_login_time = LastLoginTime
    } = St,
    if
        Flag == true ->
            NewOnlineTime = OnlineTime + (Now - LastLoginTime),
            NewSt = St#st_act_throw_egg{pkey = Player#player.key, last_login_time = Now, online_time = NewOnlineTime},
            put_dict(NewSt);
        true ->
            update(Player)
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        #base_act_throw_egg{online_time_reward = OnlineTimeReward,act_info = ActInfo} ->
            St = get_dict(),
            FreeTime = max(0, OnlineTimeReward - St#st_act_throw_egg.online_time),
            State = ?IF_ELSE(FreeTime == 0 andalso St#st_act_throw_egg.is_free == 0, 1, 0),
            Args = activity:get_base_state(ActInfo),
            {State,Args}
    end.

logout(Player) ->
    update_online_time(Player),
    St = get_dict(),
    activity_load:dbup_act_throw_egg(St).


get_log() ->
    case get_act() of
        [] ->
            [];
        #base_act_throw_egg{act_id = BaseActId} ->
            Ets = look_up(BaseActId),
            LogList = Ets#act_throw_egg_log.log,
            lists:sublist(LogList, 15)
    end.

look_up(ActId) ->
    case ets:lookup(?ETS_ACT_THROW_EGG_LOG, ActId) of
        [] ->
            ets:insert(?ETS_ACT_THROW_EGG_LOG, #act_throw_egg_log{act_id = ActId}),
            #act_throw_egg_log{act_id = ActId};
        [Ets] ->
            Ets
    end.

insert(ActId, Nickname, GoodsList) ->
    Ets = look_up(ActId),
    NewLog = [[Nickname, GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- GoodsList] ++ Ets#act_throw_egg_log.log,
    NewEts = Ets#act_throw_egg_log{log = NewLog},
    ets:insert(?ETS_ACT_THROW_EGG_LOG, NewEts),
    ok.

get_act() ->
    case activity:get_work_list(data_act_throw_egg) of
        [] -> [];
        [Base | _] -> Base
    end.

get_leave_time() ->
    LeaveTime = activity:get_leave_time(data_act_throw_egg),
    ?IF_ELSE(LeaveTime < 0, 0, LeaveTime).

get_dict() ->
    lib_dict:get(?PROC_STATUS_ACT_THROW_EGG).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_ACT_THROW_EGG, St).

log_throw_egg(Pkey, Nickname, Gold, GoodsList) ->
    Sql = io_lib:format("insert into log_throw_egg set pkey=~p,nickname='~s',gold=~p,goods_list = '~s',time=~p", [Pkey, Nickname, Gold, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql).

log_throw_egg_count(Pkey, Nickname, Count, GoodsList) ->
    Sql = io_lib:format("insert into log_throw_egg_count set pkey=~p,nickname='~s',count=~p,goods_list = '~s',time=~p", [Pkey, Nickname, Count, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql).



