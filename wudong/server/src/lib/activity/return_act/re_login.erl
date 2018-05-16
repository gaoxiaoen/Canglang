%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 十二月 2017 15:50
%%%-------------------------------------------------------------------
-module(re_login).
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("daily.hrl").

%% 协议接口
-export([
    get_day7login_info/1,
    get_gift/2,
    get_state/1,
    init/1

]).


init(Player) ->
    Day7St = dbget_info(Player),
    lib_dict:put(?PROC_STATUS_RE_LOGIN, Day7St),
    Player.

%%获取回归登陆信息
get_day7login_info(Player) ->
    case get_act() of
        [] ->
            Data = [];
        Base ->
            F = fun(Days, List) ->
                State =
                    case check_get_gift(Player, Days) of
                        {false, Res} -> Res;
                        _ -> 2
                    end,
                Reward =
                    case lists:keyfind(Days, 1, Base#base_re_login.reward) of
                        false -> [];
                        {_, Reward0} -> Reward0
                    end,
                [[Days, State, goods:pack_goods(Reward)] | List]
            end,
            DayList = [Day0 || {Day0, _} <- Base#base_re_login.reward],
            Data = lists:foldl(F, [], DayList)
    end,
    ?DEBUG("data ~p~n", [Data]),
    {ok, Bin} = pt_439:write(43959, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%领取礼包
get_gift(Player, Day) ->
%%     Days = activity:get_start_day(data_re_login),
    case check_get_gift(Player, Day) of
        {false, Res} ->
            case Res of
                1 -> {false, 5};%% 已领取
                3 -> {false, 20};%% 不可领取
                4 -> {false, 21}%% 已过期
            end;
        {ok, GoodsList} ->
            GiveGoodsList = goods:make_give_goods_list(294, GoodsList),
            case goods:give_goods(Player, GiveGoodsList) of
                {ok, NewPlayer} ->
                    Day7St = lib_dict:get(?PROC_STATUS_RE_LOGIN),
                    case lists:keytake(Day, 1, Day7St#st_re_login.day_list) of
                        {value, {Day, Times}, List} ->
                            NewDaysList = [{Day, Times + 1} | List];
                        false ->
                            NewDaysList = [{Day, 1} | Day7St#st_re_login.day_list]
                    end,
                    NewDay7St = Day7St#st_re_login{
                        day_list = NewDaysList
                    },
                    lib_dict:put(?PROC_STATUS_RE_LOGIN, NewDay7St),
                    dbup_re_login(NewDay7St),
                    %%更新可领取状态
                    activity:get_notice(Player, [177], true),
                    {ok, NewPlayer};
                {false, _} -> {false, 0}
            end;
        _ -> ?DEBUG("other~n")
    end.

check_get_gift(_Player, Days) ->
    NowDay = activity:get_start_day(data_re_login),
    case get_act() of
        [] -> {false, 0};
        Base ->
            Day7St = lib_dict:get(?PROC_STATUS_RE_LOGIN),
            #st_re_login{
                day_list = DayList
            } = Day7St,
            case lists:keyfind(Days, 1, Base#base_re_login.reward) of
                false -> {false, 0};
                {_, Reward} ->
                    if
                        Days < NowDay -> {false, 4};
                        Days > NowDay -> {false, 3};
                        true ->
                            case lists:keyfind(Days, 1, DayList) of
                                false ->
                                    {ok, Reward};
                                {_, Times} ->
                                    if
                                        Times >= 1 -> {false, 1};
                                        true ->
                                            {ok, Reward}
                                    end
                            end
                    end
            end
    end.

%%获取活动领取状态
get_state(Player) ->
    case get_act() of
        [] -> -1;
        _ ->
            Days = activity:get_start_day(data_re_login),
            case check_get_gift(Player, Days) of
                {false, _} -> 0;
                _ -> 1
            end
    end.

get_act() ->
    case activity:get_work_list(data_re_login) of
        [] -> [];
        [Base | _] -> Base
    end.

dbget_info(Player) ->
    NewSt = #st_re_login{
        pkey = Player#player.key,
        day_list = []
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select daysinfo from player_re_login  where pkey = ~p",
                [Player#player.key]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [DaysInfoBin] ->
                    Daysinfo = util:bitstring_to_term(DaysInfoBin),
                    #st_re_login{
                        pkey = Player#player.key,
                        day_list = Daysinfo
                    }
            end
    end.

dbup_re_login(Day7St) ->
    #st_re_login{
        pkey = Pkey,
        day_list = DayList
    } = Day7St,
    Sql = io_lib:format("replace into player_re_login set daysinfo='~s', pkey=~p",
        [util:term_to_bitstring(DayList), Pkey]),
    db:execute(Sql),
    ok.
