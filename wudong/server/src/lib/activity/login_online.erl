%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 五月 2017 10:52
%%%-------------------------------------------------------------------
-module(login_online).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    add_charge/2,

    get_state/1,
    get_act/0,
    get_act_info/1,
    recv/2
]).

init(#player{key = Pkey} = Player) ->
    StLoginOnline =
        case player_util:is_new_role(Player) of
            true -> #st_login_online{pkey = Pkey};
            false -> activity_load:dbget_login_online(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_LOGIN_ONLINE, StLoginOnline),
    update_login_online(),
    Player.

update_login_online() ->
    StLoginOnline = lib_dict:get(?PROC_STATUS_LOGIN_ONLINE),
    #st_login_online{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StLoginOnline,
    case get_act() of
        [] ->
            NewStLoginOnline = #st_login_online{pkey = Pkey};
        #base_login_online{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(OpTime, Now),
            if
                BaseActId =/= ActId ->
                    NewStLoginOnline = #st_login_online{pkey = Pkey, act_id = BaseActId, op_time = Now};
                Flag == false ->
                    NewStLoginOnline = #st_login_online{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStLoginOnline = StLoginOnline
            end
    end,
    lib_dict:put(?PROC_STATUS_LOGIN_ONLINE, NewStLoginOnline).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_login_online().

add_charge(_Player, AddCharge) ->
    StLoginOnline = lib_dict:get(?PROC_STATUS_LOGIN_ONLINE),
    #st_login_online{charge_gold = ChargeGold} = StLoginOnline,
    NewStLoginOnline = StLoginOnline#st_login_online{charge_gold = ChargeGold + AddCharge},
    lib_dict:put(?PROC_STATUS_LOGIN_ONLINE, NewStLoginOnline),
    activity_load:dbup_login_online(NewStLoginOnline),
    ok.

%% {LTime, ChargeGold,LoginGift,LoginRecvStatus,OnlineTime,OnlineGift,OnlineRecvStatus}
get_act_info(_Player) ->
    case get_act() of
        [] ->
            {0, 0, 0, [], 0, 0, [], 0};
        #base_login_online{open_info = OpenInfo, login_gift = LoginGift, online_two_gift = OnlineTowGift, online_four_gift = OnlineFourGift, online_eight_gift = OnlineEightGift} ->
            StLoginOnline = lib_dict:get(?PROC_STATUS_LOGIN_ONLINE),
            #st_login_online{
                charge_gold = ChargeGold,
                is_recv_login = IsRecvLogin,
                recv_online_list = RecvOnlineList
            } = StLoginOnline,
            ActLeaveTime = activity:calc_act_leave_time(OpenInfo),
            online_time_gift:update_online_time(),
            OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
            #st_online_time_gift{online_time = OnlineTime} = OTGiftSt,
%%             ?DEBUG("RecvOnlineList:~p~n", [RecvOnlineList]),
            Len = length(RecvOnlineList),
            {OnlineGift, IsRecvOnline, OnlineHour} =
                if
                    Len == 0 ->
                        ?IF_ELSE(OnlineTime > ?LOGIN_ONLINE_TWO_HOUR, {OnlineTowGift, 1, 2}, {OnlineTowGift, 0, 2});
                    Len == 1 ->
                        ?IF_ELSE(OnlineTime > ?LOGIN_ONLINE_FOUR_HOUR, {OnlineFourGift, 1, 4}, {OnlineFourGift, 0, 4});
                    Len == 2 ->
                        ?IF_ELSE(OnlineTime > ?LOGIN_ONLINE_EIGHT_HOUR, {OnlineEightGift, 1, 8}, {OnlineEightGift, 0, 8});
                    true ->
                        {OnlineEightGift, 2, 8}
                end,
            {ActLeaveTime, OnlineHour, ChargeGold, LoginGift, IsRecvLogin, OnlineTime, OnlineGift, IsRecvOnline}
    end.

%% 领取登陆奖励
recv(Player, 1) ->
    case get_act() of
        [] ->
            {0, Player};
        #base_login_online{login_gift = LoginGift} ->
            StLoginOnline = lib_dict:get(?PROC_STATUS_LOGIN_ONLINE),
            #st_login_online{
                charge_gold = ChargeGold,
                is_recv_login = IsRecvLogin
            } = StLoginOnline,
            if
                IsRecvLogin == 2 -> {3, Player};
                IsRecvLogin == 1 andalso ChargeGold == 0 -> {17, Player}; %% 今日还未充值
                true ->
                    IsCanRecv =
                        if
                            IsRecvLogin == 0 ->
                                true;
                            IsRecvLogin == 1 andalso ChargeGold > 0 ->
                                true;
                            true ->
                                false
                        end,
                    case IsCanRecv of
                        false ->
                            {3, Player}; %% 今日已领完
                        true ->
                            NewIsRecvLogin = IsRecvLogin + 1,
                            NewStLoginOnline =
                                StLoginOnline#st_login_online{
                                    is_recv_login = NewIsRecvLogin,
                                    op_time = util:unixtime()
                                },
                            lib_dict:put(?PROC_STATUS_LOGIN_ONLINE, NewStLoginOnline),
                            activity_load:dbup_login_online(NewStLoginOnline),
                            GiveGoodsList = goods:make_give_goods_list(624, LoginGift),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            activity:get_notice(NewPlayer, [39], true),
                            {1, NewPlayer}
                    end
            end
    end;

%% 领取在线奖励
recv(Player, 2) ->
    case get_act() of
        [] ->
            {0, Player};
        #base_login_online{} ->
            StLoginOnline = lib_dict:get(?PROC_STATUS_LOGIN_ONLINE),
            #st_login_online{
                recv_online_list = ListRecvOnline
            } = StLoginOnline,
            Len = length(ListRecvOnline),
            if
                Len >= 3 ->
                    {3, Player}; %% 已经领取
                true ->
                    {_ActLeaveTime, _OnlineHour, _ChargeGold, _LoginGift, _IsRecvLogin, _OnlineTime, OnlineGift, IsRecvOnline} = get_act_info(Player),
                    if
                        IsRecvOnline == 0 ->
                            {0, Player}; %% 没达到条件
                        IsRecvOnline == 2 ->
                            {0, Player}; %% 已经领取完
                        true ->
                            NewStLoginOnline =
                                StLoginOnline#st_login_online{
                                    recv_online_list = [OnlineGift | ListRecvOnline],
                                    op_time = util:unixtime()
                                },
                            lib_dict:put(?PROC_STATUS_LOGIN_ONLINE, NewStLoginOnline),
                            activity_load:dbup_login_online(NewStLoginOnline),
                            GiveGoodsList = goods:make_give_goods_list(625, OnlineGift),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            activity:get_notice(NewPlayer, [39, 119], true),
                            {1, NewPlayer}
                    end
            end
    end.

get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        #base_login_online{act_info = ActInfo} ->
            StLoginOnline = lib_dict:get(?PROC_STATUS_LOGIN_ONLINE),
            #st_login_online{
                charge_gold = ChargeGold,
                is_recv_login = IsRecvLogin
            } = StLoginOnline,
            IsCanRecv =
                if
                    IsRecvLogin == 0 ->
                        true;
                    IsRecvLogin == 1 andalso ChargeGold > 0 ->
                        true;
                    true ->
                        false
                end,
            Args = activity:get_base_state(ActInfo),
            case IsCanRecv of
                false -> get_state2(_Player, Args);
                true -> {1, Args}
            end
    end.

get_state2(_Player, Args) ->
    StLoginOnline = lib_dict:get(?PROC_STATUS_LOGIN_ONLINE),
    #st_login_online{
        recv_online_list = ListRecvOnline
    } = StLoginOnline,
    Len = length(ListRecvOnline),
    if
        Len >= 3 -> 0;
        true ->
            online_time_gift:update_online_time(),
            OTGiftSt = lib_dict:get(?PROC_STATUS_ONLINE_TIME_GIFT),
            #st_online_time_gift{online_time = OnlineTime} = OTGiftSt,
            IsRecvOnline =
                if
                    Len == 0 ->
                        ?IF_ELSE(OnlineTime > ?LOGIN_ONLINE_TWO_HOUR, 1, 0);
                    Len == 1 ->
                        ?IF_ELSE(OnlineTime > ?LOGIN_ONLINE_FOUR_HOUR, 1, 0);
                    Len == 2 ->
                        ?IF_ELSE(OnlineTime > ?LOGIN_ONLINE_EIGHT_HOUR, 1, 0);
                    true -> 0
                end,
            if
                IsRecvOnline == 0 -> {0, Args};
                IsRecvOnline == 2 -> {0, Args};
                true -> {1, Args}
            end
    end.

get_act() ->
    case activity:get_work_list(data_login_online) of
        [] -> [];
        [Base | _] -> Base
    end.