%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 二月 2016 15:31
%%%-------------------------------------------------------------------
-module(grace_handle).
-author("hxming").

-include("grace.hrl").
-include("common.hrl").
-include("scene.hrl").
%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).


%%获取采集数量
handle_call({collect_count, Pkey}, _From, State) ->
    Ret =
        case dict:is_key(Pkey, State#st_grace.collect_count) of
            false -> false;
            true ->
                dict:fetch(Pkey, State#st_grace.collect_count) >= ?GRACE_MAX_COLLECT
        end,
    {reply, Ret, State};

handle_call(_Msg, _From, State) ->
    {reply, ok, State}.


%%查询活动状态
handle_cast({check_state, Sid, Now}, State) ->
    if State#st_grace.open_state == ?GRACE_STATE_CLOSE -> skip;
        true ->
            {ok, Bin} = pt_630:write(63001, {State#st_grace.open_state, max(0, State#st_grace.time - Now)}),
            server_send:send_to_sid(Sid, Bin)
    end,
    {noreply, State};

handle_cast({get_target, Pkey, Sid, Now}, State) ->
    if State#st_grace.open_state =/= ?GRACE_STATE_START -> skip;
        true ->
            LeftTime = max(0, State#st_grace.time - Now),
            RefreshTime = max(0, State#st_grace.refresh_time - Now),
            Count =
                case dict:is_key(Pkey, State#st_grace.collect_count) of
                    false -> 0;
                    true ->
                        dict:fetch(Pkey, State#st_grace.collect_count)
                end,
            {ok, Bin} = pt_630:write(63003, {LeftTime, RefreshTime, Count, ?GRACE_MAX_COLLECT, State#st_grace.round}),
            server_send:send_to_sid(Sid, Bin)
    end,
    {noreply, State};


handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_grace.ref]),
    NewState = grace_proc:set_timer(State, Now),
    {noreply, NewState};

%%准备
handle_info({ready, ReadyTime, LastTime}, State) when State#st_grace.open_state == ?GRACE_STATE_CLOSE ->
    ?DEBUG("grace ready ~p~n", [ReadyTime]),
    util:cancel_ref([State#st_grace.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_630:write(63001, {?GRACE_STATE_READY, ReadyTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_grace{open_state = ?GRACE_STATE_READY, time = Now + ReadyTime, ref = Ref},
    {noreply, NewState};

%%开始
handle_info({start, LastTime}, State) when State#st_grace.open_state /= ?GRACE_STATE_START ->
    util:cancel_ref([State#st_grace.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_630:write(63001, {?GRACE_STATE_START, LastTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    NewState = State#st_grace{
        open_state = ?GRACE_STATE_START,
        time = Now + LastTime,
        ref = Ref,
        round = 1,
        collect_count = dict:new(),
        collect_list = []
    },
    ?DEBUG("grace start ~n"),
    Ref1 = erlang:send_after(1000, self(), refresh),
    put(refresh, Ref1),
    {noreply, NewState};

%%关闭
handle_info(close, State) ->
    ?DEBUG("grace close ~n"),
    util:cancel_ref([State#st_grace.ref]),
    misc:cancel_timer(refresh),
    misc:cancel_timer(notice),
    Now = util:unixtime(),
    {ok, Bin} = pt_630:write(63001, {?GRACE_STATE_CLOSE, 0}),
    server_send:send_to_all(Bin),
    NewState = grace_proc:set_timer(State#st_grace{}, Now),
%%    scene_copy_proc:set_default(?SCENE_ID_MAIN, false),
    {noreply, NewState};

%%刷新怪物
handle_info(refresh, State) when State#st_grace.open_state == ?GRACE_STATE_START ->
    misc:cancel_timer(refresh),
    RefreshTime =
        case data_grace_box:get(State#st_grace.round) of
            [] -> 0;
            Base ->
                refresh_box(Base),
                Ref = erlang:send_after(Base#base_grace.refresh_time * 1000, self(), refresh),
                put(refresh, Ref),
                Ref1 = erlang:send_after((Base#base_grace.refresh_time - ?GRACE_NOTICE_TIME) * 1000, self(), notice),
                put(notice, Ref1),
                Base#base_grace.refresh_time
        end,
    if RefreshTime > 0 ->
        {ok, Bin} = pt_630:write(63005, {RefreshTime}),
        server_send:send_to_scene(?SCENE_ID_MAIN, Bin);
        true ->
            ok
    end,
    Round = State#st_grace.round + 1,
    {noreply, State#st_grace{round = Round, refresh_time = util:unixtime() + RefreshTime}};

handle_info(notice, State) ->
    misc:cancel_timer(notice),
    {ok, Bin} = pt_630:write(63002, {?GRACE_NOTICE_TIME}),
    server_send:send_to_scene(?SCENE_ID_MAIN, Bin),
    {noreply, State};

%%采集一个,计数
handle_info({update_collect_count, Pkey}, State) ->
    CollectDict = dict:update_counter(Pkey, 1, State#st_grace.collect_count),
    Count = dict:fetch(Pkey, CollectDict),
    {ok, Bin} = pt_630:write(63004, {Count}),
    server_send:send_to_key(Pkey, Bin),
    {noreply, State#st_grace{collect_count = CollectDict}};

handle_info(cmd_count, State) ->
    L = dict:to_list(State#st_grace.collect_count),
    ?WARNING("L ~p~n", [L]),
    {noreply, State};

handle_info(_Msg, State) ->
    {noreply, State}.


refresh_box(BaseData) ->
    CopyList = scene_copy_proc:get_scene_copy_ids(?SCENE_ID_MAIN),
    F = fun({Mid, Num}) -> lists:duplicate(Num, Mid) end,
    BoxList = lists:flatmap(F, BaseData#base_grace.box_list),
%%    BoxCount = length(BoxList),
%%    PosList = util:get_random_list(BaseData#base_grace.pos_list, BoxCount),
    PosList = util:list_shuffle(BaseData#base_grace.pos_list),
    refresh_loop(BoxList, PosList, CopyList).

refresh_loop([], _, _CopyList) ->
    ok;
refresh_loop(_, [], _CopyList) ->
    ok;
refresh_loop([Mid | T], [{X, Y} | L], CopyList) ->
    [mon_agent:create_mon_cast([Mid, ?SCENE_ID_MAIN, X, Y, Copy, 1, []]) || Copy <- CopyList],
    refresh_loop(T, L, CopyList).

