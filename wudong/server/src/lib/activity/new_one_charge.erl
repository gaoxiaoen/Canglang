%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 三月 2016 下午2:52
%%%-------------------------------------------------------------------
-module(new_one_charge).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").
-include("goods.hrl").

%%协议接口
-export([
    get_new_one_charge_info/1,
    get_gift/1
]).

%% API
-export([
    init/1,
    update_charge_val/2,
    get_state/1,
    update/1,
    get_leave_time/0
]).

init(Player) ->
    NewOCSt = activity_load:dbget_new_one_charge(Player),
    lib_dict:put(?PROC_STATUS_NEW_ONE_CHARGE, NewOCSt),
    update(Player),
    Player.

update(_Player) ->
    NewOCSt = lib_dict:get(?PROC_STATUS_NEW_ONE_CHARGE),
    #st_new_one_charge{
        act_id = ActId
    } = NewOCSt,
    NewOCSt1 =
        case activity:get_work_list(data_new_one_charge) of
            [] -> NewOCSt;
            [Base | _] ->
                case Base#base_new_one_charge.act_id == ActId of
                    true -> NewOCSt;
                    false ->
                        NewOCSt#st_new_one_charge{
                            act_id = Base#base_new_one_charge.act_id,
                            get_time = 0,
                            max_charge = 0
                        }
                end
        end,
    lib_dict:put(?PROC_STATUS_NEW_ONE_CHARGE, NewOCSt1),
    ok.

get_new_one_charge_info(Player) ->
    State = get_act_state(Player),
    {GiftId, LeaveTime, NeedCharge} =
        case activity:get_work_list(data_new_one_charge) of
            [] -> {0, 0, 0};
            [Base | _] ->
                #base_new_one_charge{
                    open_info = OpenInfo,
                    gift_id = GiftId0,
                    charge_val = NCharge
                } = Base,
                LTime = activity:calc_act_leave_time(OpenInfo),
                {GiftId0, LTime, NCharge}
        end,
    {ok, Bin} = pt_430:write(43091, {State, GiftId, LeaveTime, NeedCharge}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_gift(Player) ->
    case check_get_gift(Player) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            NewOCSt = lib_dict:get(?PROC_STATUS_NEW_ONE_CHARGE),
            Now = util:unixtime(),
            NewOCSt1 = NewOCSt#st_new_one_charge{
                get_time = Now
            },
            lib_dict:put(?PROC_STATUS_NEW_ONE_CHARGE, NewOCSt1),
            activity_load:dbup_new_one_charge(NewOCSt1),
            GiveGoodsList = goods:make_give_goods_list(133,[{GiftId,1}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 133),
            activity:get_notice(Player, [8], true),
            F = fun() ->
                case data_gift_bag:get(GiftId) of
                    [] -> skip;
                    BaseGift ->
                        {_, GoodsId, _, _} = hd(BaseGift#base_gift.must_get),
                        BaseGoods = data_goods:get(GoodsId),
                        case BaseGoods of
                            [] -> skip;
                            _ ->
                                skip%notice_sys:add_notice(one_charge, [Player, BaseGoods#goods_type.goods_name])
                        end
                end
                end,
            spawn(F),
            {ok, NewPlayer}
    end.

check_get_gift(Player) ->
    NewOCSt = lib_dict:get(?PROC_STATUS_NEW_ONE_CHARGE),
    #st_new_one_charge{
        act_id = ActId,
        get_time = GetTime,
        max_charge = MaxCharge
    } = NewOCSt,
    case activity:get_work_list(data_new_one_charge) of
        [] -> {false, 0};
        [Base | _] ->
            #base_new_one_charge{
                act_id = BaseActId,
                charge_val = ChargeVal,
                gift_id = GiftId
            } = Base,
            if
                BaseActId =/= ActId -> update(Player), {false, 0};
                GetTime > 0 -> {false, 3};
                MaxCharge < ChargeVal -> {false, 2};
                true ->
                    {ok, GiftId}
            end
    end.

get_act_state(Player) ->
    case check_get_gift(Player) of
        {false, 3} -> 2;
        {ok, _GiftId} -> 1;
        _ -> 0
    end.

%%增加充值额度
update_charge_val(Player, ChargeVal) ->
    case get_state(Player) of
        -1 -> ok;
        _ ->
            update(Player),
            NewOCSt = lib_dict:get(?PROC_STATUS_NEW_ONE_CHARGE),
            NewOCSt1 = NewOCSt#st_new_one_charge{
                max_charge = max(NewOCSt#st_new_one_charge.max_charge, ChargeVal)
            },
            lib_dict:put(?PROC_STATUS_NEW_ONE_CHARGE, NewOCSt1),
            activity_load:dbup_new_one_charge(NewOCSt1),
            ok
    end.

get_state(Player) ->
    case activity:get_work_list(data_new_one_charge) of
        [] -> -1;
        [Base | _] ->
            #base_new_one_charge{
                act_info = ActInfo
            } = Base,
            Args = activity:get_base_state(ActInfo),
            case get_act_state(Player) of
                1 -> {1, Args};
                _ -> {0, Args}
            end
    end.

get_leave_time() ->
    case activity:get_work_list(data_new_one_charge) of
        [] -> -1;
        [Base | _] ->
            activity:calc_act_leave_time(Base#base_new_one_charge.open_info)
    end.