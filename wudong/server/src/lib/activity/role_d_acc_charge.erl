%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 六月 2016 下午8:27
%%%-------------------------------------------------------------------
-module(role_d_acc_charge).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

-export([
    get_role_d_acc_charge_info/1,
    get_gift/2
]).

%% API
-export([
    init/1,
    update/1,
    add_charge_val/2,  %%增加累计充值额度
    get_state/1
]).

init(Player) ->
    RoleDAccChargeSt = activity_load:dbget_role_d_acc_charge(Player),
    put_dict(RoleDAccChargeSt),
    %%老服处理
    old_server_init(Player),
    update(Player),
    Player.

old_server_init(Player) ->
    RoleDAccChargeSt = get_dict(),
    #st_role_d_acc_charge{
        act_id = ActId
    } = RoleDAccChargeSt,
    case activity:get_work_list(data_role_d_acc_charge) of
        [] -> skip;
        [Base | _] ->
            OpenDay = config:get_open_days(),
            Now = util:unixtime(),
            case OpenDay >= 4 andalso Now < 1466092799 of
                false -> skip;
                true ->
                    case player_util:is_new_role(Player) of
                        true ->
                            update(Player),
                            NewRoleDAccChargeSt = get_dict(),
                            activity_load:dbup_role_d_acc_charge(NewRoleDAccChargeSt);
                        false ->
                            case ActId == 0 of
                                false -> skip;
                                true ->
                                    #base_role_d_acc_charge{
                                        act_id = BaseActId,
                                        goods_list = GoodsList
                                    } = Base,
                                    HdBase = hd(GoodsList),
                                    Len = length(HdBase#base_rdac_g.gift_list),
                                    Now = util:unixtime(),
                                    InitDay = 5,
                                    F = fun(Id) ->
                                        {Id, InitDay, 0}
                                        end,
                                    GetList = lists:map(F, lists:seq(1, Len)),
                                    NewRoleDAccChargeSt = RoleDAccChargeSt#st_role_d_acc_charge{
                                        act_id = BaseActId,
                                        update_time = Now,
                                        get_list = GetList,
                                        acc_val = 0
                                    },
                                    put_dict(NewRoleDAccChargeSt),
                                    activity_load:dbup_role_d_acc_charge(NewRoleDAccChargeSt)
                            end
                    end
            end
    end.

update(_Player) ->
    RoleDAccChargeSt = get_dict(),
    #st_role_d_acc_charge{
        update_time = UpdateTime,
        act_id = ActId
    } = RoleDAccChargeSt,
    NewRoleDAccChargeSt =
        case activity:get_work_list(data_role_d_acc_charge) of
            [] -> RoleDAccChargeSt;
            [Base | _] ->
                Now = util:unixtime(),
                case ActId =/= Base#base_role_d_acc_charge.act_id of
                    true ->
                        RoleDAccChargeSt#st_role_d_acc_charge{
                            act_id = Base#base_role_d_acc_charge.act_id,
                            update_time = Now,
                            acc_val = 0,
                            get_list = []
                        };
                    false ->
                        case util:is_same_date(Now, UpdateTime) of
                            true -> RoleDAccChargeSt;
                            false ->
                                RoleDAccChargeSt#st_role_d_acc_charge{
                                    update_time = Now,
                                    acc_val = 0
                                }
                        end
                end
        end,
    put_dict(NewRoleDAccChargeSt),
    ok.

get_role_d_acc_charge_info(Player) ->
    case get_act() of
        [] -> skip;
        [Base | _] ->
            #base_role_d_acc_charge{
                goods_list = GoodsList
            } = Base,
            StRoleDAccCharge = get_dict(),
            #st_role_d_acc_charge{
                acc_val = AccVal,
                get_list = GetList
            } = StRoleDAccCharge,
            LeaveTime = ?ONE_DAY_SECONDS - (util:unixtime() - util:unixdate()),
            {CurItem, _St, _Et} = get_cur_item(GetList, GoodsList),
            GiftListInfo = get_state_info(),
            GiftListInfo1 = [Info || [_ | Info] <- GiftListInfo],
            Data = {LeaveTime, AccVal, CurItem, GiftListInfo1},
            {ok, Bin} = pt_431:write(43161, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

get_state_info() ->
    [Base | _] = get_act(),
    #base_role_d_acc_charge{
        goods_list = GoodsList
    } = Base,
    StRoleDAccCharge = get_dict(),
    #st_role_d_acc_charge{
        acc_val = AccVal,
        get_list = GetList
    } = StRoleDAccCharge,
    {_CurItem, St, Et} = get_cur_item(GetList, GoodsList),
    Now = util:unixtime(),
    F = fun(Id) ->
        case lists:keyfind(Id, 1, GetList) of
            false ->
                Base_rdac = lists:keyfind(1, #base_rdac_g.day, GoodsList),
                {Charge, GiftId} = lists:nth(Id, Base_rdac#base_rdac_g.gift_list),
                State = ?IF_ELSE(AccVal >= Charge, 1, 0),
                [1, Id, Charge, GiftId, State];
            {Id, Day, Time} ->
                Base_rdac = lists:keyfind(Day, #base_rdac_g.day, GoodsList),
                {Charge, GiftId} = lists:nth(Id, Base_rdac#base_rdac_g.gift_list),
                case util:is_same_date(Now, Time) of
                    true -> [Day, Id, Charge, GiftId, 2];
                    false ->
                        MaxDayBase = hd(lists:reverse(lists:keysort(#base_rdac_g.day, GoodsList))),
                        MaxDay = MaxDayBase#base_rdac_g.day,
                        NewDay =
                            case Time > 0 of
                                true -> Day + 1;
                                false -> Day
                            end,
                        case NewDay > MaxDay of
                            true -> [Day, Id, Charge, GiftId, 2];
                            false ->
                                Base_rdac1 = lists:keyfind(NewDay, #base_rdac_g.day, GoodsList),
                                {Charge1, GiftId1} = lists:nth(Id, Base_rdac1#base_rdac_g.gift_list),
                                State = ?IF_ELSE(AccVal >= Charge1, 1, 0),
                                [NewDay, Id, Charge1, GiftId1, State]
                        end
                end
        end
        end,
    lists:map(F, lists:seq(St, Et)).

get_gift(Player, Id) ->
    case check_get_gift(Player, Id) of
        {false, Res} ->
            {false, Res};
        {ok, CurItem, Day, GiftId} ->
            StRoleDAccCharge = get_dict(),
            NewGetList = lists:keydelete(Id, 1, StRoleDAccCharge#st_role_d_acc_charge.get_list) ++ [{Id, Day, util:unixtime()}],
            NewStRoleDAccCharge = StRoleDAccCharge#st_role_d_acc_charge{
                get_list = NewGetList
            },
            put_dict(NewStRoleDAccCharge),
            activity_load:dbup_role_d_acc_charge(NewStRoleDAccCharge),
            GiveGoodsList = goods:make_give_goods_list(162, [{GiftId, 1}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 162),
            activity:get_notice(Player, [20], true),
            {ok, NewPlayer, CurItem}
    end.
check_get_gift(_Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        _ ->
            [Base | _] = get_act(),
            #base_role_d_acc_charge{
                goods_list = GoodsList
            } = Base,
            StRoleDAccCharge = get_dict(),
            #st_role_d_acc_charge{
                get_list = GetList
            } = StRoleDAccCharge,
            {CurItem, _St, _Et} = get_cur_item(GetList, GoodsList),
            InfoList = get_state_info(),
            case lists:keyfind(Id, 2, [list_to_tuple(Info) || Info <- InfoList]) of
                false -> {false, 0};
                {Day, Id, _Charge, GiftId, State} ->
                    if
                        State == 2 -> {false, 3};
                        State == 0 -> {false, 2};
                        true ->
                            {ok, CurItem, Day, GiftId}
                    end
            end
    end.


get_cur_item(GetList, GoodsList) ->
    BaseDay1 = lists:keyfind(1, #base_rdac_g.day, GoodsList),
    Len = length(BaseDay1#base_rdac_g.gift_list),
    CurDay = get_cur_item_day(lists:seq(1, Len), GetList, 999),
    BaseCurDay = lists:keyfind(CurDay, #base_rdac_g.day, GoodsList),
    #base_rdac_g{
        show_list = ShowList
    } = BaseCurDay,
    Now = util:unixtime(),
    MaxDayBase = hd(lists:reverse(lists:keysort(#base_rdac_g.day, GoodsList))),
    GiftLen = length(MaxDayBase#base_rdac_g.gift_list),
    CurItem = get_cur_item_1(lists:seq(1, GiftLen), GetList, ShowList, Now, 1),
    {St, Et} = lists:nth(CurItem, ShowList),
    {CurItem, St, Et}.

get_cur_item_day([], _GetList, 999) -> 1;
get_cur_item_day([], _GetList, AccDay) -> AccDay;
get_cur_item_day([Id | Tail], GetList, AccDay) ->
    case lists:keyfind(Id, 1, GetList) of
        false -> 1;
        {Id, Day, _Time} ->
            get_cur_item_day(Tail, GetList, min(Day, AccDay))
    end.

get_cur_item_1([], _GetList, _ShowList, _Now, Item) -> Item;
get_cur_item_1([Id | Tail], GetList, ShowList, Now, _Item) ->
    CurItem = get_id_item(ShowList, Id, 1),
    case lists:keyfind(Id, 1, GetList) of
        false -> CurItem;
        {Id, _Day, Time} ->
            case util:is_same_date(Now, Time) of
                true -> get_cur_item_1(Tail, GetList, ShowList, Now, CurItem);
                false -> CurItem
            end
    end.

get_id_item([], _Id, Item) -> Item;
get_id_item([{St, Et} | Tail], Id, Item) ->
    case Id >= St andalso Id =< Et of
        true -> Item;
        false ->
            case Tail == [] of
                true -> get_id_item(Tail, Id, Item);
                false -> get_id_item(Tail, Id, Item + 1)
            end
    end.



get_dict() ->
    lib_dict:get(?PROC_STATUS_ROLE_D_ACC_CHARGE).

put_dict(StRoleDAccCharge) ->
    lib_dict:put(?PROC_STATUS_ROLE_D_ACC_CHARGE, StRoleDAccCharge).

get_act() ->
    activity:get_work_list(data_role_d_acc_charge).

%%增加充值额度
add_charge_val(Player, AddExp) ->
    update(Player),
    case get_state(Player) =/= -1 of
        true ->
            StRoleDAccCharge = get_dict(),
            NewStRoleDAccCharge = StRoleDAccCharge#st_role_d_acc_charge{
                acc_val = StRoleDAccCharge#st_role_d_acc_charge.acc_val + AddExp
            },
            put_dict(NewStRoleDAccCharge),
            activity_load:dbup_role_d_acc_charge(NewStRoleDAccCharge),
            ok;
        false ->
            ok
    end.

check_open() ->
    case get_act() of
        [] -> false;
        [Base | _] ->
            #base_role_d_acc_charge{
                goods_list = GoodsList
            } = Base,
            MaxDay = length(GoodsList),
            StRoleDAccCharge = get_dict(),
            #st_role_d_acc_charge{
                get_list = GetList
            } = StRoleDAccCharge,
            %%是否已全部领取
            F = fun({_Id, Day, _GetTime}) ->
                Day
                end,
            List = lists:map(F, GetList),
            %%领取的天数是否是最后一天
            case List =/= [] andalso lists:max(List) >= MaxDay of
                true ->
                    %%最后领取时间是否是今天
                    UpdateTime = lists:max([Time || {_Id, _Day, Time} <- GetList]),
                    util:is_same_date(util:unixtime(), UpdateTime);
                false -> true
            end
    end.

get_state(_Player) ->
    case check_open() of
        false -> -1;
        true ->
            St = get_dict(),
            #st_role_d_acc_charge{
                get_list = GetList
            } = St,
            [Base | _] = get_act(),
            #base_role_d_acc_charge{
                act_info = ActInfo,
                goods_list = GoodsList
            } = Base,
            {CurItem, _St, _Et} = get_cur_item(GetList, GoodsList),
            StateList = get_state_info(),
            Args =
                case CurItem == 1 of
                    true -> activity:get_base_state(ActInfo);
                    false -> []
                end,
            F = fun(Info) ->
                lists:last(Info) == 1
                end,
            case lists:any(F, StateList) of
                true -> {1, Args};
                false -> {0, Args}
            end
    end.
