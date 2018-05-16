%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 二月 2016 14:57
%%%-------------------------------------------------------------------
-module(invade_handle).
-author("hxming").

-include("common.hrl").
-include("invade.hrl").
-include("scene.hrl").
-include("battle.hrl").


%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).


handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

%%查询活动状态
handle_cast({check_state, Sid, Now}, State) ->
    if State#st_invade.open_state == ?INVADE_STATE_CLOSE -> skip;
        true ->
            {ok, Bin} = pt_610:write(61001, {State#st_invade.open_state, max(0, State#st_invade.time - Now)}),
            server_send:send_to_sid(Sid, Bin)
    end,
    {noreply, State};

%%击杀怪物
handle_cast({kill_mon, Pid, Mid, Copy, X, Y, Klist}, State) ->
    refresh_box(Pid, Mid, Copy, X, Y, Klist),
    erlang:send_after(10000, self(), {refresh, Copy, X, Y}),
    {noreply, State};

%%采集宝箱
%%handle_cast({collect, Mpid, Pkey}, State) ->
%%    NewState =
%%        case lists:keytake(Mpid, 1, State#st_invade.box_list) of
%%            false ->
%%                State;
%%            {value, {_, Owner, Color}, L1} ->
%%                case lists:member(Color, ?INVADE_COLLECT_LIMIT) of
%%                    true ->
%%                        [catch Pid ! {invade_collect_limit, Pkey} || {Pid, Owner1, _Color} <- L1, Owner == Owner1, lists:member(_Color, ?INVADE_COLLECT_LIMIT) == true];
%%                    false -> skip
%%                end,
%%                State#st_invade{box_list = L1}
%%        end,
%%    {noreply, NewState};


handle_cast(_Msg, State) ->
    {noreply, State}.


handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_invade.ref]),
    NewState = invade_proc:set_timer(State, Now),
    {noreply, NewState};

%%准备
handle_info({ready, ReadyTime, LastTime}, State) when State#st_invade.open_state == ?INVADE_STATE_CLOSE ->
    ?DEBUG("invade ready ~p~n", [ReadyTime]),
    util:cancel_ref([State#st_invade.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_610:write(61001, {?INVADE_STATE_READY, ReadyTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_invade{open_state = ?INVADE_STATE_READY, time = Now + ReadyTime, ref = Ref},
%%     notice_sys:add_notice(invade_ready, []),
    {noreply, NewState};

%%开始
handle_info({start, LastTime}, State) when State#st_invade.open_state /= ?INVADE_STATE_START ->
    util:cancel_ref([State#st_invade.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_610:write(61001, {?INVADE_STATE_START, LastTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    NewState = State#st_invade{
        open_state = ?INVADE_STATE_START,
        time = Now + LastTime,
        ref = Ref,
        round = 0,
        world_lv = rank:get_world_lv(),
        mon_pids = [],
        box_list = []
    },
%%     notice_sys:add_notice(invade_start, []),
    CopyList = scene_copy_proc:get_scene_copy_ids(?SCENE_ID_JJYJ),
    put(copy_list, CopyList),
    refresh_mon(NewState#st_invade.world_lv, CopyList),
    Ref1 = erlang:send_after(10000, self(), check_copy),
    put(check_copy, Ref1),
    ?DEBUG("invade start ~n"),
    {noreply, NewState};

%%关闭
handle_info(close, State) ->
    ?DEBUG("invade close ~n"),
    util:cancel_ref([State#st_invade.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_610:write(61001, {?INVADE_STATE_CLOSE, 0}),
    server_send:send_to_all(Bin),
    NewState = invade_proc:set_timer(State#st_invade{mon_pids = [], box_list = []}, Now),
%%     notice_sys:add_notice(invade_close, [NewState#st_invade.is_today, NewState#st_invade.next_time]),
    {noreply, NewState};

%%刷新怪物
handle_info({refresh, Copy, X, Y}, State) ->
    if State#st_invade.open_state == ?INVADE_STATE_START ->
        refresh_mon_single(State#st_invade.world_lv, Copy, X, Y);
        true -> skip
    end,
    {noreply, State};

handle_info(check_copy, State) ->
    misc:cancel_timer(check_copy),
    Ref1 = erlang:send_after(10000, self(), check_copy),
    put(check_copy, Ref1),
    CopyList = scene_copy_proc:get_scene_copy_ids(?SCENE_ID_JJYJ),
    OldList = case get(copy_list) of
                  undefined -> [];
                  Val -> Val
              end,
    put(copy_list, CopyList),
    NewCopyList = lists:filter(fun(Copy) -> lists:member(Copy, OldList) == false end, CopyList),
    refresh_mon(State#st_invade.world_lv, NewCopyList),
    {noreply, State};

handle_info(_msg, State) ->
    {noreply, State}.

%%刷新全部怪物
refresh_mon(WorldLv, CopyList) ->
    F = fun(Id) ->
        {X, Y} = data_invade_position:get(Id),
        F1 = fun(Copy) ->
            case get_mon(WorldLv) of
                false -> skip;
                MonId ->
                    mon_agent:create_mon_cast([MonId, ?SCENE_ID_JJYJ, X, Y, Copy, 1, []])
            end
             end,
        lists:foreach(F1, CopyList)
        end,
    lists:foreach(F, data_invade_position:ids()).

get_mon(WorldLv) ->
    case data_invade_mon:get(WorldLv) of
        [] -> false;
        MonList ->
            util:list_rand_ratio(MonList)
    end.

%%刷新单个怪物
refresh_mon_single(WorldLv, NowCopy, X, Y) ->
    case get_mon(WorldLv) of
        false -> skip;
        MonId ->
            mon_agent:create_mon_cast([MonId, ?SCENE_ID_JJYJ, X, Y, NowCopy, 1, []])
    end.

%%创建宝箱
refresh_box(Mpid, Mid, Copy, TarX, TarY, Klist) ->
    case data_invade_box:get(Mid) of
        [] -> ok;
        [Num, BoxList] ->
            PosList = scene:get_area_position_list(?SCENE_ID_JJYJ, TarX, TarY, 6),
            NewPosList = lists:sublist(PosList, Num),
            SortKlist = [Hatred#st_hatred.key || Hatred <- lists:reverse(lists:keysort(#st_hatred.hurt, Klist))],
            InvadeBox = #invade_box{owner = Mpid, top_three = lists:sublist(SortKlist, 3), join = SortKlist, time = util:unixtime()},
            F = fun({X, Y}) ->
                MonId = util:list_rand_ratio(BoxList),
                mon_agent:create_mon_cast([MonId, ?SCENE_ID_JJYJ, X, Y, Copy, 1, [{invade_box, InvadeBox}]])
                end,
            lists:foreach(F, NewPosList)
    end.

