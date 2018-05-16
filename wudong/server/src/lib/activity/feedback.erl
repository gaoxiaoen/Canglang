%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 二月 2017 17:54
%%%-------------------------------------------------------------------
-module(feedback).
-include("server.hrl").
-include("activity.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("goods.hrl").

%% API
-export([
    draw_award/1,
    get_state/0,
    feedback_succeed/1
]).

feedback_succeed(Player) ->
    AccCharge = daily:get_count(?DAILY_FEEDBACK),
    if
        AccCharge == 0 ->
            daily:increment(?DAILY_FEEDBACK, 1),
            case draw_award(Player) of
                {ok, NewPlayer} ->
                    {ok, NewPlayer};
                _ -> {ok, Player}
            end;
        true -> {ok, Player}
    end.

draw_award(Player) ->
    {AccCharge, Award} = get_state(),
    if
        AccCharge == 0 -> {false, 2}; %% 还不能领取
        AccCharge == 2 -> {false, 3}; %% 已经领取
        true ->
            case data_gift_bag:get(8001001) of
                [] -> {false, 0};
                _BaseGift ->
                    GoodsList = goods:make_give_goods_list(231,Award),
                    {ok, NewPlayer2} = goods:give_goods(Player, GoodsList),
                    daily:increment(?DAILY_FEEDBACK, 1),
                    {ok, NewPlayer2}
            end
    end.

get_state() ->
    Award = get_award(),
    AccCharge = daily:get_count(?DAILY_FEEDBACK),
    {AccCharge, Award}.

get_award() ->
    case data_gift_bag:get(8001001) of
        [] -> [];
        BaseGift ->
            analysis_gift_to_client(BaseGift#base_gift.must_get, [])
    end.

analysis_gift_to_client([], List) -> List;
analysis_gift_to_client([Hd | T], List) ->
    case Hd of
        {_, Id, Num, _} ->
            analysis_gift_to_client(T, [[Id, Num] | List]);
        {_, Id, Num} ->
            analysis_gift_to_client(T, [[Id, Num] | List])
    end.

