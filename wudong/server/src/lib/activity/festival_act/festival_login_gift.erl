%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 节日活动之登陆有礼
%%% @end
%%% Created : 22. 九月 2017 14:15
%%%-------------------------------------------------------------------
-module(festival_login_gift).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act/0,
    add_charge/1,

    get_act_info/0,
    recv_day/2,
    get_state/0
]).

init(#player{key = Pkey} = Player) ->
    StFestivalLoginGift =
        case player_util:is_new_role(Player) of
            true -> #st_festival_login_gift{pkey = Pkey};
            false -> activity_load:dbget_festival_login_gift(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_FESTIVAL_LOGIN_GIFT, StFestivalLoginGift),
    update_festival_login_gift(),
    Player.

update_festival_login_gift() ->
    StFestivalLoginGift = lib_dict:get(?PROC_STATUS_FESTIVAL_LOGIN_GIFT),
    #st_festival_login_gift{
        pkey = Pkey,
        act_id = ActId,
        login_day_num = LoginDayNum,
        op_time = OpTime
    } = StFestivalLoginGift,
    case get_act() of
        [] ->
            NewStFestivalLoginGift = #st_festival_login_gift{pkey = Pkey};
        #base_festival_login_gift{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(OpTime, Now),
            if
                BaseActId =/= ActId ->
                    NewStFestivalLoginGift =
                        #st_festival_login_gift{
                            pkey = Pkey,
                            act_id = BaseActId,
                            op_time = Now
                        };
                Flag == false ->
                    NewStFestivalLoginGift =
                        StFestivalLoginGift#st_festival_login_gift{
                            pkey = Pkey,
                            act_id = BaseActId,
                            login_day_num = LoginDayNum + 1,
                            charge_gold = 0,
                            op_time = Now
                        };
                true ->
                    NewStFestivalLoginGift =
                        StFestivalLoginGift#st_festival_login_gift{
                            charge_gold = act_charge:get_charge_gold()
                        }
            end
    end,
    lib_dict:put(?PROC_STATUS_FESTIVAL_LOGIN_GIFT, NewStFestivalLoginGift).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_festival_login_gift().

get_act() ->
    case activity:get_work_list(data_festival_login_gift) of
        [] -> [];
        [Base | _] -> Base
    end.

add_charge(ChargeGold) ->
    St = lib_dict:get(?PROC_STATUS_FESTIVAL_LOGIN_GIFT),
    case get_act() of
        [] ->
            ok;
        _ ->
            NewSt = St#st_festival_login_gift{charge_gold = St#st_festival_login_gift.charge_gold + ChargeGold},
            lib_dict:put(?PROC_STATUS_FESTIVAL_LOGIN_GIFT, NewSt),
            activity_load:dbup_festival_login_gift(NewSt)
    end.

get_act_info() ->
    case get_act() of
        [] ->
            {0, []};
        #base_festival_login_gift{list = BaseList, open_info = OpenInfo} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            St = lib_dict:get(?PROC_STATUS_FESTIVAL_LOGIN_GIFT),
            #st_festival_login_gift{
                login_day_num = LoginDayNum,
                charge_gold = ChargeGold,
                recv_list = RecvList
            } = St,
            F = fun({BaseDay, RewardList}) ->
                if
                    BaseDay > LoginDayNum ->
                        [BaseDay, 0, util:list_tuple_to_list(RewardList)];
                    BaseDay == LoginDayNum ->
                        case lists:keyfind(BaseDay, 1, RecvList) of
                            false ->
                                [BaseDay, 1, util:list_tuple_to_list(RewardList)];
                            {BaseDay, RecvNum} ->
                                if
                                    ChargeGold == 0 andalso RecvNum < 2 -> %% 处理充值可再领
                                        [BaseDay, 2, util:list_tuple_to_list(RewardList)];
                                    ChargeGold > 0 andalso RecvNum < 2 -> %% 处理充值可再领
                                        [BaseDay, 1, util:list_tuple_to_list(RewardList)];
                                    true ->
                                        [BaseDay, 3, util:list_tuple_to_list(RewardList)]
                                end
                        end;
                    true ->
                        case lists:keyfind(BaseDay, 1, RecvList) of
                            false ->
                                [BaseDay, 1, util:list_tuple_to_list(RewardList)];
                            {BaseDay, _RecvNum} ->
                                [BaseDay, 3, util:list_tuple_to_list(RewardList)]
                        end
                end
            end,
            LL = lists:map(F, BaseList),
            {LTime, LL}
    end.

recv_day(Player, Day) ->
    case check_recv_day(Day) of
        {fail, Code} ->
            {Code, Player};
        {true, RewardList} ->
            St = lib_dict:get(?PROC_STATUS_FESTIVAL_LOGIN_GIFT),
            #st_festival_login_gift{recv_list = RecvList} = St,
            NewRecvList =
                case lists:keytake(Day, 1, RecvList) of
                    false ->
                        [{Day, 1} | RecvList];
                    {value, {Day, RecvNum}, Rest} ->
                        [{Day, RecvNum + 1} | Rest]
                end,
            NewSt =
                St#st_festival_login_gift{
                    recv_list = NewRecvList,
                    op_time = util:unixtime()
                },
            lib_dict:put(?PROC_STATUS_FESTIVAL_LOGIN_GIFT, NewSt),
            activity_load:dbup_festival_login_gift(NewSt),
            GiveGoodsList = goods:make_give_goods_list(709, RewardList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            Sql = io_lib:format("replace into log_festival_login_gift set pkey=~p, day=~p, recv_list='~s', time=~p",
                [Player#player.key, Day, util:term_to_bitstring(RewardList), util:unixtime()]),
            log_proc:log(Sql),
            {1, NewPlayer}
    end.

check_recv_day(Day) ->
    case get_act() of
        [] -> {fail, 0};
        #base_festival_login_gift{list = BaseList} ->
            St = lib_dict:get(?PROC_STATUS_FESTIVAL_LOGIN_GIFT),
            #st_festival_login_gift{
                login_day_num = LoginDayNum,
                charge_gold = ChargeGold,
                recv_list = RecvList
            } = St,
            if
                LoginDayNum < Day -> {fail, 7}; %% 不可越期领取
                true ->
                    case lists:keyfind(Day, 1, BaseList) of
                        false ->
                            {fail, 0};
                        {_BaseDay, RewardList} ->
                            case lists:keyfind(Day, 1, RecvList) of
                                false ->
                                    {true, RewardList};
                                {_Day, RecvNum} ->
                                    if
                                        RecvNum >= 2 -> {fail, 5}; %% 全部领取
                                        ChargeGold == 0 -> {fail, 12}; %% 充值可再领取一次
                                        ChargeGold > 0 andalso RecvNum < 2 andalso Day == LoginDayNum ->
                                            {true, RewardList};
                                        true ->
                                            {fail, 0}
                                    end
                            end
                    end
            end
    end.

get_state() ->
    case get_act() of
        [] -> -1;
        #base_festival_login_gift{list = BaseList} ->
            F = fun({Day, _RewardList}) ->
                case check_recv_day(Day) of
                    {true, _} -> [1];
                    _ -> []
                end
            end,
            LL = lists:flatmap(F, BaseList),
            ?IF_ELSE(LL == [], 0, 1)
    end.