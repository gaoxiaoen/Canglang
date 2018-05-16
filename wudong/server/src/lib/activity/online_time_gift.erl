%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 三月 2016 上午11:58
%%%-------------------------------------------------------------------
-module(online_time_gift).
-author("fengzhenlin").
-include("server.hrl").
-include("activity.hrl").
-include("common.hrl").
-include("tips.hrl").

%%协议接口
-export([
    get_online_time_gift_info/1,
    get_gift/1,
    log_online_time_gift_record/3
]).

%% API
-export([
    init/1,
    update/1,
    logout/0,
    get_state/1,
    get_notice_player/1,
    get_leave_time/0,
    check_get_state/1,
    update_online_time/0,
    gm/1
]).

-define(EXCHANGE_GOODS_ID, 29097).  %%兑换水晶id

check_get_state(_Player) ->
    case activity:get_work_list(data_online_time_gift) of
        [] -> #tips{};
        _ ->
            case get_next_gift_leave_time() of
                0 -> #tips{state = 1};
                _ -> #tips{}
            end
    end.

init(Player) ->
    OTGiftSt = activity_load:dbget_online_time_gift(Player),
    lib_dict:put(?PROC_STATUS_ONLINE_TIME_GIFT, OTGiftSt),
    update(Player),
    Player.

update(_Player) ->
    OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
    #st_online_time_gift{
        act_id = ActId,
        last_get_time = LastGetTime
    } = OTGiftSt,
    ActList = activity:get_work_list(data_online_time_gift),
    Now = util:unixtime(),
    NewOTGiftSt =
        if
            ActList == [] -> OTGiftSt;
            true ->
                Base = hd(ActList),
                #base_online_time_gift{
                    act_id = BaseActId
                } = Base,
                IsSameDate = util:is_same_date(Now, LastGetTime),
                if
                    BaseActId =/= ActId orelse (not IsSameDate) -> %%新活动或者新的一天
                        OTGiftSt#st_online_time_gift{
                            act_id = BaseActId,
                            get_list = [],
                            last_get_time = Now,
                            online_time = 0,
                            online_update_time = Now
                        };
                    true ->
                        OTGiftSt
                end
        end,
    lib_dict:put(?PROC_STATUS_ONLINE_TIME_GIFT, NewOTGiftSt),
    ok.

logout() ->
    update_online_time(),
    OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
    activity_load:dbup_online_time_gift(OTGiftSt),
    ok.

%%获取在线时长奖励信息
get_online_time_gift_info(Player) ->
    update_online_time(),
    ActList = activity:get_work_list(data_online_time_gift),
    if
        ActList == [] -> skip;
        true ->
            OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
            #st_online_time_gift{
                get_list = GetList,
                online_time = OnlineTime
            } = OTGiftSt,
            Base = hd(ActList),
            #base_online_time_gift{
                gift_list = BaseGiftList
            } = Base,
            Fb = fun(BaseOTGift) ->
                #base_ot_gift{
                    online_time = NeedOnlineTime,
                    goods_list = GoodsList
                } = BaseOTGift,
                F = fun({GoodsId, GoodsNum, _Pro}) ->
                    [GoodsId, GoodsNum]
                    end,
                GiftInfoList = lists:map(F, GoodsList),
                {GetState, GetGoodsId, GetGoodsnum} =
                    case lists:keyfind(NeedOnlineTime, 1, GetList) of
                        false -> {?IF_ELSE(OnlineTime >= NeedOnlineTime, 1, 0), 0, 0};
                        {_, Gid, Gnum} -> {2, Gid, Gnum}
                    end,
                [NeedOnlineTime, GetState, GetGoodsId, GetGoodsnum, GiftInfoList]
                 end,
            GiftList = lists:map(Fb, BaseGiftList),

            {ok, Bin} = pt_431:write(43111, {OnlineTime, GiftList}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end.

%%获取下一个时长奖励信息
%%返回 []|#base_ot_gift{}
get_next_gift_info() ->
    OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
    #st_online_time_gift{
        get_list = GetList,
        online_time = OnlineTime
    } = OTGiftSt,
    ActList = activity:get_work_list(data_online_time_gift),
    Base = hd(ActList),
    #base_online_time_gift{
        gift_list = GiftList
    } = Base,
    get_next_gift_info_helper(GiftList, GetList, OnlineTime).
get_next_gift_info_helper([], _GetList, _OnlineTime) -> [];
get_next_gift_info_helper([Base | Tail], GetList, OnlineTime) ->
    #base_ot_gift{
        online_time = NeedOnlineTime
    } = Base,
    case lists:keyfind(NeedOnlineTime, 1, GetList) of
        false ->
            Base;
        _ -> %%已领取
            get_next_gift_info_helper(Tail, GetList, OnlineTime)
    end.

%%获取下一奖励所需时间
get_next_gift_leave_time() ->
    OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
    #st_online_time_gift{
        online_time = OnlineTime
    } = OTGiftSt,
    case get_next_gift_info() of
        [] -> -1;
        Base ->
            #base_ot_gift{
                online_time = NeedOnlineTime
            } = Base,
            case OnlineTime >= NeedOnlineTime of
                true ->  %%可领取
                    0;
                false ->
                    NeedOnlineTime - OnlineTime
            end
    end.

get_gift(Player) ->
    update_online_time(),
    case check_get_gift(Player) of
        {false, Res} ->
            {false, Res};
        {ok, BaseOTGfitList} ->
            F = fun(BaseOTGfit, {AccGoodsList, AccTimeList}) ->
                #base_ot_gift{
                    online_time = NeedOnlineTime,
                    goods_list = GoodsList
                } = BaseOTGfit,
                %%给抽到的物品和额外给的兑换物品
                ProList = [{{GoodsId, Num}, Pro} || {GoodsId, Num, Pro} <- GoodsList],
                {Gid, Gnum} = util:list_rand_ratio(ProList),
                {[{Gid, Gnum} | AccGoodsList], [{NeedOnlineTime, Gid, Gnum} | AccTimeList]}
                end,
            {GetGoodsList0, NewGetTimelist} = lists:foldl(F, {[], []}, BaseOTGfitList),
            GetGoodsList = lists:reverse(GetGoodsList0),
            GiveGoodsList = goods:make_give_goods_list(643, GetGoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),

            OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
            NewOTGiftSt = OTGiftSt#st_online_time_gift{
                get_list = OTGiftSt#st_online_time_gift.get_list ++ NewGetTimelist,
                last_get_time = util:unixtime()
            },
            lib_dict:put(?PROC_STATUS_ONLINE_TIME_GIFT, NewOTGiftSt),
            activity_load:dbup_online_time_gift(NewOTGiftSt),

            activity:get_notice(Player, [12], true),

            {ok, NewPlayer, goods:pack_goods(GetGoodsList)}
    end.
check_get_gift(Player) ->
    ActList = activity:get_work_list(data_online_time_gift),
    if
        ActList == [] -> {false, 0};
        true ->
            Base = hd(ActList),
            #base_online_time_gift{
                act_id = BaseActId,
                gift_list = BaseOTGfitList
            } = Base,
            OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
            #st_online_time_gift{
                act_id = ActId,
                get_list = GetList,
                online_time = OnlineTime
            } = OTGiftSt,
            F = fun(BaseOt) ->
                #base_ot_gift{
                    online_time = NeedOnlineTime
                } = BaseOt,
                case lists:keyfind(NeedOnlineTime, 1, GetList) of
                    false ->
                        case OnlineTime >= NeedOnlineTime of
                            true -> [BaseOt];
                            false -> []
                        end;
                    _ -> []
                end
                end,
            CanGetBaseList = lists:flatmap(F, BaseOTGfitList),
            if
                ActId =/= BaseActId -> update(Player), {false, 0};
                CanGetBaseList == [] -> {false, 14};
                true -> {ok, CanGetBaseList}
            end
    end.

%%更新今天累计在线时间
update_online_time() ->
    OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
    #st_online_time_gift{
        online_time = OnlineTime,
        online_update_time = OnlineUpdateTime
    } = OTGiftSt,
    Now = util:unixtime(),
    NewOTGiftSt = OTGiftSt#st_online_time_gift{
        online_time = OnlineTime + max(0, Now - OnlineUpdateTime),
        online_update_time = Now
    },
    lib_dict:put(?PROC_STATUS_ONLINE_TIME_GIFT, NewOTGiftSt),
    ok.

log_online_time_gift_record(Pkey, Name, GoodsId) ->
    Sql = io_lib:format("insert into log_online_time_record set pkey=~p,nickname='~s',goods_id=~p,time=~p",
        [Pkey, Name, GoodsId, util:unixtime()]),
    log_proc:log(Sql),
    ok.

get_state(_Player) ->
    case activity:get_work_list(data_online_time_gift) of
        [] -> {-1, [{time, 0}]};
        [Base | _] ->
            Args = activity:get_base_state(Base#base_online_time_gift.act_info),
            case get_next_gift_leave_time() of
                0 -> {1, [{time, 0}] ++ Args};
                -1 -> {0, [{time, 0}] ++ Args};
                Time -> {0, [{time, Time}] ++ Args}
            end
    end.

get_notice_player(_Player) ->
    case activity:get_work_list(data_online_time_gift) of
        [] -> -1;
        _ ->
            case get_next_gift_leave_time() of
                0 -> 1;
                -1 -> 0;
                _Time -> 0
            end
    end.

get_leave_time() ->
    ActList = activity:get_work_list(data_online_time_gift),
    if
        ActList == [] -> skip;
        true ->
            Base = hd(ActList),
            #base_online_time_gift{
                open_info = OpenInfo
            } = Base,
            activity:calc_act_leave_time(OpenInfo)
    end.
gm(Time) ->
    OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
    StNew = OTGiftSt#st_online_time_gift{
        online_time = Time
    },
    lib_dict:put(?PROC_STATUS_ONLINE_TIME_GIFT, StNew),
    ok.