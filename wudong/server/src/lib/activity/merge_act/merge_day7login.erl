%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 七月 2017 16:31
%%%-------------------------------------------------------------------
-module(merge_day7login).
-include("common.hrl").
-include("server.hrl").
-include("day7login.hrl").
-include("activity.hrl").
-include("daily.hrl").

%% 协议接口
-export([
    get_day7login_info/1,
    get_gift/1,
    get_state/1
]).

%% API
-export([
    init/1
]).

init(Player) ->
    Day7St = dbget_info(Player),
    lib_dict:put(?PROC_STATUS_MERGE_DAY7LOGIN, Day7St),
    Player.

%%获取7天登陆信息
get_day7login_info(Player) ->
    case get_act() of
        [] ->
            Data = {0, 0, []};
        Base ->
            LeaveTime = activity:get_leave_time(data_merge_day7login),
            Days = config:get_merge_days(),
            State = case check_get_gift(Player, Days) of
                        {false, _} -> 0;
                        _ -> 1
                    end,
            Data = {LeaveTime, State, [tuple_to_list(X) || X <- Base#base_merge_day7.reward]}
    end,
    {ok, Bin} = pt_437:write(43750, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%领取礼包
get_gift(Player) ->
    Days = config:get_merge_days(),
    case check_get_gift(Player, Days) of
        {false, Res} ->
            {false, Res};
        {ok, Base} ->
            GoodsList = Base#base_merge_day7.reward,
            GiveGoodsList = goods:make_give_goods_list(294, GoodsList),
            case goods:give_goods(Player, GiveGoodsList) of
                {ok, NewPlayer} ->
                    Day7St = lib_dict:get(?PROC_STATUS_MERGE_DAY7LOGIN),
                    case lists:keytake(Days, 1, Day7St#st_merge_day7.day_list) of
                        {value, {Days, Times}, List} ->
                            NewDaysList = [{Days, Times + 1} | List];
                        false ->
                            NewDaysList = [{Days, 1} | Day7St#st_merge_day7.day_list]
                    end,
                    NewDay7St = Day7St#st_merge_day7{
                        day_list = NewDaysList
                    },
                    lib_dict:put(?PROC_STATUS_MERGE_DAY7LOGIN, NewDay7St),
                    dbup_merge_day7login(NewDay7St),
                    %%更新可领取状态
                    activity:get_notice(Player, [46], true),
                    {ok, NewPlayer};
                {false, _} -> {false, 0}
            end;
        _ -> ?DEBUG("other~n")
    end.

check_get_gift(_Player, Days) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            Day7St = lib_dict:get(?PROC_STATUS_MERGE_DAY7LOGIN),
            #st_merge_day7{
                day_list = DayList
            } = Day7St,
            case lists:keyfind(Days, 1, DayList) of
                false -> {ok, Base};
                {_, Times} ->
                    if
                        Times >= 2 -> {false, 3};
                        Times == 0 -> {ok, Base};
                        true ->
                            AccCharge = daily:get_count(?DAILY_CHARGE_ACC),
                            if
                                AccCharge > 0 -> {ok, Base};
                                true -> {false, 3}
                            end
                    end
            end
    end.


%%获取活动领取状态
get_state(Player) ->
%%    Day7St = lib_dict:get(?PROC_STATUS_MERGE_DAY7LOGIN),
%%    #st_merge_day7{
%%        day_list = DayList
%%    } = Day7St,
    case get_act() of
        [] -> -1;
        _ ->
            Days = config:get_merge_days(),
            case check_get_gift(Player, Days) of
                {false, _} -> 0;
                _ -> 1
            end
    end.

get_act() ->
    case activity:get_work_list(data_merge_day7login) of
        [] -> [];
        [Base | _] -> Base
    end.

dbget_info(Player) ->
    NewSt = #st_merge_day7{
        pkey = Player#player.key,
        day_list = []
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select daysinfo from player_merge_day7login where pkey = ~p",
                [Player#player.key]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [DaysInfoBin] ->
                    Daysinfo = util:bitstring_to_term(DaysInfoBin),
                    #st_merge_day7{
                        pkey = Player#player.key,
                        day_list = Daysinfo
                    }
            end
    end.

dbup_merge_day7login(Day7St) ->
    #st_merge_day7{
        pkey = Pkey,
        day_list = DayList
    } = Day7St,
    Sql = io_lib:format("replace into player_merge_day7login set daysinfo='~s', pkey=~p",
        [util:term_to_bitstring(DayList), Pkey]),
    db:execute(Sql),
    ok.
