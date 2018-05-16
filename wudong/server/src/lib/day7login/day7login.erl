%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 7天登陆
%%% @end
%%% Created : 30. 十一月 2015 下午4:36
%%%-------------------------------------------------------------------
-module(day7login).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("day7login.hrl").

%% 协议接口
-export([
    get_day7login_info/1,
    get_gift/2,
    check_day7gift_state/0,
    get_state/1
]).

%%获取7天登陆信息
get_day7login_info(Player) ->
    Day7St = lib_dict:get(?PROC_STATUS_DAY7LOGIN),
    F = fun({Days, State, _Time}, {AccList, Flag0}) ->
        case data_day7login:get(Days) of
            [] ->
                {AccList, Flag0};
            BaseD ->
                #base_day7{
                    goods_list = GoodsList
                } = BaseD,
                if
                    Days =< 7 andalso (State == 2 orelse State == 3) -> Flag1 = true;
                    true -> Flag1 = Flag0
                end,
                {AccList ++ [[Days, State, goods:pack_goods(GoodsList)]], Flag1}
        end
    end,
    {List, Flag} = lists:foldl(F, {[], false}, Day7St#st_day7.day_list),
    if
        Flag ->
            List1 = lists:sublist(List, 7);
        true ->
            List1 = lists:sublist(List, 8, 14)
    end,
    {ok, Bin} = pt_520:write(52000, {List1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%领取礼包
get_gift(Player, Days) ->
    case check_get_gift(Player, Days) of
        {false, Res} ->
            {false, Res};
        ok ->
            BaseD = data_day7login:get(Days),
            #base_day7{
                goods_list = GoodsList
            } = BaseD,
            GiveGoodsList = goods:make_give_goods_list(198, GoodsList),
            case goods:give_goods(Player, GiveGoodsList) of
                {ok, NewPlayer} ->
                    Now = util:unixtime(),
                    Day7St = lib_dict:get(?PROC_STATUS_DAY7LOGIN),
                    NewDaysInfo = {Days, 1, Now},
                    NewDaysList = lists:keyreplace(Days, 1, Day7St#st_day7.day_list, NewDaysInfo),
                    NewDaysList1 = NewDaysList,
                    NewDay7St = Day7St#st_day7{
                        day_list = NewDaysList1
                    },
                    lib_dict:put(?PROC_STATUS_DAY7LOGIN, NewDay7St),
                    day7login_load:dbup_day7login(NewDay7St),
                    %%activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 108),
                    %%更新可领取状态
                    activity:get_notice(Player, [52], true),
                    {ok, NewPlayer};
                {false, _} -> {false, 0}
            end;
        _ -> ?DEBUG("other~n")
    end.

check_get_gift(_Player, Days) ->
    Day7St = lib_dict:get(?PROC_STATUS_DAY7LOGIN),
    #st_day7{
        day_list = DayList
    } = Day7St,
    case lists:keyfind(Days, 1, DayList) of
        false -> {false, 0};
        {Days, State, _Time} ->
            if
                State == 1 -> {false, 2};
                State == 3 -> {false, 3};
                true ->
                    ok
            end
    end.

check_day7gift_state() ->
    Day7St = lib_dict:get(?PROC_STATUS_DAY7LOGIN),
    Len = length(data_day7login:get_all()),
    F = fun({Days, State, _}) ->
        State == 2 andalso Days =< Len
    end,
    case lists:any(F, Day7St#st_day7.day_list) of
        true -> 1;
        false -> 0
    end.


%%获取活动领取状态
get_state(_Player) ->
    Day7St = lib_dict:get(?PROC_STATUS_DAY7LOGIN),
    #st_day7{
        day_list = DayList
    } = Day7St,
    F = fun({_Day, State, _Time}, {Get, CanGet}) ->
        case State of
            2 -> {Get, CanGet + 1};
            1 -> {Get + 1, CanGet};
            _ -> {Get, CanGet}
        end
    end,
    {HaveGet, CanGet1} = lists:foldl(F, {0, 0}, DayList),
    Len = length(data_day7login:get_all()),
    if
        HaveGet >= Len -> -1;
        CanGet1 > 0 -> 1;
        true -> 0
    end.

%%
%%analysis_goods_list(GoodsList) ->
%%    analysis_goods_list_help(GoodsList, 108, []).
%%analysis_goods_list_help([], _From, List) -> List;
%%analysis_goods_list_help([{GoodsId, Num} | T], From, List) ->
%%    analysis_goods_list_help(T, From, [{GoodsId, Num, From} | List]).