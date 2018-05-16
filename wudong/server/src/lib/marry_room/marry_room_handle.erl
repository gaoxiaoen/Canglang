%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 七月 2017 20:24
%%%-------------------------------------------------------------------
-module(marry_room_handle).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("marry_room.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

handle_call(_msg, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {reply, ok, State}.

handle_cast(refresh_marry_room_list, State) ->
    KeyList = get_filter_list(),
    put(get_marry_room_list, {KeyList, util:unixtime()}),
    {noreply, State};

handle_cast({get_marry_room_list, Pid, Page}, State) ->
    Now = util:unixtime(),
    KeyList =
        case get(get_marry_room_list) of
            {KeyList0, Time} when Now - Time < 30 -> %% 15秒更新数据一次
                KeyList0;
            _ ->
                KeyList0 = get_filter_list(),
                put(get_marry_room_list, {KeyList0, util:unixtime()}),
                KeyList0
        end,
    Start = (Page - 1) * ?MARRY_PAGE_TOTAL_NUM + 1,
    if
        length(KeyList) < Start ->
            player:apply_state(async, Pid, {marry_room, get_marry_room_list, [[], 0]});
        true ->
            NewList = lists:sublist(KeyList, Start, ?MARRY_PAGE_TOTAL_NUM),
            player:apply_state(async, Pid, {marry_room, get_marry_room_list, [NewList, Page]})
    end,
    {noreply, State};

handle_cast(_msg, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {noreply, State}.

handle_info(sys_init, State) ->
    marry_room_init:sys_init(),
    {noreply, State};

handle_info(_msg, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {noreply, State}.

get_filter_list() ->
    Now = util:unixtime(),
    List0 = ets:tab2list(?ETS_MARRY_ROOM),
    F0 = fun(#ets_marry_room{love_desc = Desc0, love_desc_time = LoveDescTime}) ->
        %% 筛选有宣言 及 宣言未过期
        Desc0 /= <<>> andalso Now - LoveDescTime < 2*?ONE_DAY_SECONDS
%%         Desc0 /= <<>>
    end,
    List = lists:filter(F0, List0),
    marry_room:sort_list(List).


