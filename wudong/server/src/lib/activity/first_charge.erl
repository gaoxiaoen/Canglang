%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 首充豪礼
%%% @end
%%% Created : 07. 一月 2016 上午10:43
%%%-------------------------------------------------------------------
-module(first_charge).
-author("fengzhenlin").
-include("server.hrl").
-include("activity.hrl").
-include("common.hrl").

%% API
-export([
    init/1,
    get_fir_charge_info/1,
    get_gift/2,
    get_state/0,
    update_charge/1,
    is_first_charge/0
]).

init(Player) ->
    FirstChargeSt = activity_load:dbget_first_charge_info(Player),
    lib_dict:put(?PROC_STATUS_FIRST_CHARGE, FirstChargeSt),
    Player.

%%获取玩家首充活动信息
get_fir_charge_info(Player) ->
    FirstChargeSt = lib_dict:get(?PROC_STATUS_FIRST_CHARGE),
    #st_first_charge{
        charge_time = ChargeTime
    } = FirstChargeSt,
    ActList = activity:get_work_list(data_fir_charge),
    if
        ActList == [] -> skip;
        true ->
            List = get_act_info(ActList),
            IsFirCharge =
                case ChargeTime > 0 of
                    true -> 1;
                    false -> 0
                end,
            {ok, Bin} = pt_430:write(43001,{IsFirCharge,List}),
            server_send:send_to_sid(Player#player.sid,Bin),
            ok
    end.

%%领取首充礼包
get_gift(Player,Days) ->
    case check_get_gift(Player,Days) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            GiveGoodsList = goods:make_give_goods_list(111,[{GiftId,1}]),
            case goods:give_goods(Player,GiveGoodsList) of
                {ok, NewPlayer} ->
                    FirstChargeSt = lib_dict:get(?PROC_STATUS_FIRST_CHARGE),
                    NewFirstChargeSt = FirstChargeSt#st_first_charge{
                        last_get_time = util:unixtime(),
                        get_list = FirstChargeSt#st_first_charge.get_list ++ [Days]
                    },
                    lib_dict:put(?PROC_STATUS_FIRST_CHARGE,NewFirstChargeSt),
                    activity_load:dbup_first_charge(NewFirstChargeSt),
                    activity_log:log_get_gift(Player#player.key,Player#player.nickname,GiftId,1,111),
                    activity:get_notice(Player,[1],true),
                    {ok,NewPlayer};
                _Err ->
                    {false, 0}
            end
    end.
check_get_gift(_Player,Days) ->
    ActList = activity:get_work_list(data_fir_charge),
    if
        ActList == [] -> {false, 0};
        true ->
            List = get_act_info(ActList),
            case catch lists:nth(Days,List) of
                [Days,GiftId,State] ->
                    if
                        State == 0 -> {false, 2};
                        State == 2 -> {false, 3};
                        State =/= 1 -> {false, 0};
                        true ->
                            {ok, GiftId}
                    end;
                _ ->
                    ?ERR("get_act_info err ~p~n",[{Days,List}]),
                    {false, 0}
            end
    end.

%%获取领取信息
get_act_info(ActList) ->
    FirstChargeSt = lib_dict:get(?PROC_STATUS_FIRST_CHARGE),
    #st_first_charge{
        get_list = GetList,
        charge_time = ChargeTime
    } = FirstChargeSt,
    [Act|_] = ActList,
    #base_first_charge{
        gift_list = GiftList
    } = Act,
    Now = util:unixtime(),
    F = fun(Days) ->
        GiftId = lists:nth(Days,GiftList),
        GetState =
            case ChargeTime == 0 of
                true -> 0;  %%还没充值
                false ->
                    case lists:member(Days,GetList) of
                        true -> 2;
                        false ->
                            DiffDay = util:get_diff_days(Now,ChargeTime),
                            if
                                DiffDay >= Days-1 -> 1;
                                true -> 0
                            end
                    end
            end,
        [Days,GiftId,GetState]
    end,
    lists:map(F,lists:seq(1,3)).

%%获取领取状态
%%返回 0没有可领取 1有可领取
get_state() ->
    ActList = activity:get_work_list(data_fir_charge),
    if
        ActList == [] -> -1;
        true ->
            List = get_act_info(ActList),
            [Act|_] = ActList,
            #base_first_charge{
                act_info = ActInfo
            } = Act,
            Args = activity:get_base_state(ActInfo),
            F = fun([_Days,_GiftId,GetState]) ->
                    ?IF_ELSE(GetState==1,1,0)
                end,
            case lists:sum(lists:map(F,List)) > 0 of
                true -> {1, Args};
                false ->
                    FirstChargeSt = lib_dict:get(?PROC_STATUS_FIRST_CHARGE),
                    #st_first_charge{
                        charge_time = ChargeTime
                    } = FirstChargeSt,
                    Now = util:unixtime(),
                    HaveGetList = [GetState||[_Days,_GiftId,GetState]<-List,GetState==2],
                    case length(HaveGetList) == 3 andalso util:get_diff_days(Now,ChargeTime) >= 3 of
                        true -> -1;
                        false -> {0, Args}
                    end
            end
    end.

%%充值更新
update_charge(Player) ->
    FirstChargeSt = lib_dict:get(?PROC_STATUS_FIRST_CHARGE),
    case FirstChargeSt#st_first_charge.charge_time > 0 of
        true -> ok;
        false ->
            NewFirstChargeSt = FirstChargeSt#st_first_charge{
                charge_time = util:unixtime()
            },
            lib_dict:put(?PROC_STATUS_FIRST_CHARGE,NewFirstChargeSt),
            activity_load:dbup_first_charge(NewFirstChargeSt),
            notice_sys:add_notice(first_charge,Player),
            ok
    end.

%%是否已首冲
is_first_charge() ->
    FirstChargeSt = lib_dict:get(?PROC_STATUS_FIRST_CHARGE),
    FirstChargeSt#st_first_charge.charge_time > 0.