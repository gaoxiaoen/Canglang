%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 八月 2016 下午8:10
%%%-------------------------------------------------------------------
-module(vip_gift).
-author("fengzhenlin").
-include("activity.hrl").
-include("server.hrl").
-include("common.hrl").

%%协议接口
-export([
    get_info/1,
    buy_gift/2
]).

%% API
-export([
    init/1,
    update/1,
    get_state/1
]).

init(Player) ->
    St = activity_load:dbget_vip_gift(Player),
    put_dict(St),
    update(Player),
    Player.

update(_Player) ->
    St = get_dict(),
    #st_vip_gift{
        act_id = ActId
    } = St,
    NewSt =
        case get_act() of
            [] -> St;
            Base ->
                #base_vip_gift{
                    act_id = BaseActId
                } = Base,
                case BaseActId == ActId of
                    true -> St;
                    false ->
                        St#st_vip_gift{
                            act_id = BaseActId,
                            buy_list = []
                        }
                end
        end,
    put_dict(NewSt),
    ok.

get_info(Player) ->
    case get_act() of
        [] -> skip;
        Base ->
            St = get_dict(),
            #st_vip_gift{
                buy_list = BuyList
            } = St,
            LeaveTime = activity:calc_act_leave_time(Base#base_vip_gift.open_info),
            F = fun(B) ->
                #base_vg{
                    vip_lv = VipLv,
                    gift_id = GiftId,
                    times = Times,
                    gold = Gold,
                    old_gold = OldGold
                } = B,
                BuyTimes =
                    case lists:keyfind(VipLv, 1, BuyList) of
                        false -> 0;
                        {_, BuyTimes1} -> BuyTimes1
                    end,
                [VipLv, GiftId, Gold, OldGold, Times, BuyTimes]
                end,
            L = lists:map(F, Base#base_vip_gift.gift_list),
            {ok, Bin} = pt_432:write(43261, {LeaveTime, L}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

buy_gift(Player, VipLv) ->
    case check_buy_gift(Player, VipLv) of
        {false, Res} -> {false, Res};
        {ok, B} ->
            #base_vg{
                gift_id = GiftId,
                gold = Gold
            } = B,
            NewPlayer = money:add_no_bind_gold(Player, -Gold, 184, GiftId, 1),
            GiveGoodsList = goods:make_give_goods_list(184, [{GiftId, 1}]),
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, GiveGoodsList),
            St = get_dict(),
            #st_vip_gift{
                buy_list = BuyList
            } = St,
            NewBuyList =
                case lists:keyfind(VipLv, 1, BuyList) of
                    false -> [{VipLv, 1} | BuyList];
                    {_, OldTimes} -> lists:keydelete(VipLv, 1, BuyList) ++ [{VipLv, OldTimes + 1}]
                end,
            NewSt = St#st_vip_gift{
                buy_list = NewBuyList,
                update_time = util:unixtime()
            },
            put_dict(NewSt),
            activity_load:dbup_vip_gift(NewSt),
            activity:get_notice(Player, [30], true),
            {ok, NewPlayer1}
    end.
check_buy_gift(Player, VipLv) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            St = get_dict(),
            #st_vip_gift{
                buy_list = BuyList
            } = St,
            #base_vip_gift{
                gift_list = GiftList
            } = Base,
            case lists:keyfind(VipLv, #base_vg.vip_lv, GiftList) of
                false -> {false, 0};
                B ->
                    #base_vg{
                        gold = Gold,
                        times = Times
                    } = B,
                    IsEnough = money:is_enough(Player, Gold, gold),
                    if
                        not IsEnough -> {false, 5};
                        Player#player.vip_lv < VipLv -> {false, 9};
                        true ->
                            OldTimes =
                                case lists:keyfind(VipLv, 1, BuyList) of
                                    false -> 0;
                                    {_, BuyTimes} -> BuyTimes
                                end,
                            if
                                OldTimes >= Times -> {false, 10};
                                true ->
                                    {ok, B}
                            end
                    end
            end
    end.


get_dict() ->
    lib_dict:get(?PROC_STATUS_VPI_GIFT).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_VPI_GIFT, St).

get_act() ->
    case activity:get_work_list(data_vip_gift) of
        [] -> [];
        [Base | _] -> Base
    end.

get_state(Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            #base_vip_gift{
                act_info = ActInfo,
                gift_list = GiftList
            } = Base,
            F = fun(B) ->
                case check_buy_gift(Player, B#base_vg.vip_lv) of
                    {false, _Res} -> 0;
                    _ -> 1
                end
                end,
            Args = activity:get_base_state(ActInfo),
            case lists:sum(lists:map(F, GiftList)) > 0 of
                true -> {1, Args};
                false -> {0, Args}
            end
    end.