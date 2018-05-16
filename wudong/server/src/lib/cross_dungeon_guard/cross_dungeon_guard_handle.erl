%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 十一月 2016 14:03
%%%-------------------------------------------------------------------
-module(cross_dungeon_guard_handle).
-author("hxming").

-include("common.hrl").
-include("cross_dungeon_guard.hrl").
-include("dungeon.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).


handle_call(_Msg, _From, State) ->
    {reply, ok, State}.


handle_cast(_msg, State) ->
    {noreply, State}.

%%房间列表
handle_info({room_list, Node, Sn, Sid, DunId, Pkey, Cbp, Lv}, State) ->
    InProRoomList = cross_dungeon_guard_util:get_in_pro_room_list(DunId, Pkey),
    KeyList = [R#ets_cross_dun_guard_room.pkey || R <- InProRoomList],
    RoomList = cross_dungeon_guard_util:fetch_room_list(DunId, Sn, [Pkey | KeyList], Cbp, Lv),
    F = fun(R, {L1, L2}) ->
        case R#ets_cross_dun_guard_room.sn == Sn of
            true -> {[R | L1], L2};
            false -> {L1, [R | L2]}
        end
    end,
    {RoomList1, RoomList2} = lists:foldl(F, {[], []}, RoomList),
    SortRoomList = lists:keysort(#ets_cross_dun_guard_room.create_time, RoomList1)
        ++ lists:keysort(#ets_cross_dun_guard_room.create_time, RoomList2),

    LenLim = 10,
    List =
        case length(SortRoomList) > LenLim of
            true ->
                SortRoomList;
            false ->
                lists:sublist(SortRoomList ++ InProRoomList, LenLim)
        end,
    F1 = fun(Room) ->
        MbLen = length(Room#ets_cross_dun_guard_room.mb_list),
        [Room#ets_cross_dun_guard_room.key,
            Room#ets_cross_dun_guard_room.sn,
            Room#ets_cross_dun_guard_room.nickname,
            Room#ets_cross_dun_guard_room.career,
            Room#ets_cross_dun_guard_room.sex,
            Room#ets_cross_dun_guard_room.password,
            Room#ets_cross_dun_guard_room.is_fast,
            MbLen, ?CROSS_DUNGEON_GUARD_Mb_LIM,
            Room#ets_cross_dun_guard_room.avatar,
            Room#ets_cross_dun_guard_room.state
        ]
    end,
    RoomInfoList = lists:map(F1, List),
    {ok, Bin} = pt_651:write(65101, {RoomInfoList}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%创建房间
handle_info({create_room, Mb, DunId, Lv, Password, FastOpen}, State) ->
    Room = #ets_cross_dun_guard_room{
        create_time = util:unixtime(),
        key = misc:unique_key_auto(),
        dun_id = DunId,
        lv = Lv,
        password = Password,
        mb_list = [Mb],
        sn = Mb#dungeon_mb.sn,
        pkey = Mb#dungeon_mb.pkey,
        nickname = Mb#dungeon_mb.nickname,
        avatar = Mb#dungeon_mb.avatar,
        career = Mb#dungeon_mb.career,
        sex = Mb#dungeon_mb.sex,
        is_fast = FastOpen,
        cbp = Mb#dungeon_mb.power,
        shadow_time = ?CROSS_DUNGEON_GUARD_SHADOW_TIME
    },
    cross_dungeon_guard_util:update_room(Room),
    %% 定时系统玩家加入
    ?DO_IF(Password == "", self() ! {check_add_shadow, Room#ets_cross_dun_guard_room.key, Room#ets_cross_dun_guard_room.shadow_time}),
    self() ! {set_timeout, Room#ets_cross_dun_guard_room.key},
    {ok, Bin} = pt_651:write(65102, {1}),
    server_send:send_to_sid(Mb#dungeon_mb.node, Mb#dungeon_mb.sid, Bin),
%%    center:apply(Mb#dungeon_mb.node, server_send, send_to_sid, [Mb#dungeon_mb.sid, Bin]),
    server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, {cross_dun_guard_state, Room#ets_cross_dun_guard_room.key}),
    {noreply, State};

%%房间信息
handle_info({room_info, Node, Sid, Key, PKey}, State) ->
    case cross_dungeon_guard_util:get_room(Key) of
        [] -> ok;
        Room ->
            case lists:keymember(PKey, #dungeon_mb.pkey, Room#ets_cross_dun_guard_room.mb_list) of
                false -> ok;
                true ->
                    Data = cross_dungeon_guard_util:pack_room(Room),
                    {ok, Bin} = pt_651:write(65104, Data),
                    server_send:send_to_sid(Node, Sid, Bin)
%%                    center:apply(Node, server_send, send_to_sid, [Sid, Bin])
            end
    end,
    {noreply, State};

%%退出房间
handle_info({quit_room, Node, Sid, Key, PKey}, State) ->
    Ret =
        case cross_dungeon_guard_util:get_room(Key) of
            [] -> 3;
            Room ->
                case lists:keymember(PKey, #dungeon_mb.pkey, Room#ets_cross_dun_guard_room.mb_list) of
                    false -> 3;
                    true ->
                        cross_dungeon_guard_util:do_quit(Room, PKey, true),
                        1
                end
        end,
    {ok, Bin} = pt_651:write(65105, {Ret}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%踢人
handle_info({kickout, Node, Sid, Key, PKey, Dkey}, State) ->
    Ret =
        case cross_dungeon_guard_util:get_room(Key) of
            [] -> 3;
            Room ->
                if PKey /= Room#ets_cross_dun_guard_room.pkey -> 12;
                    PKey == Dkey -> 23;
                    true ->
                        case lists:keytake(Dkey, #dungeon_mb.pkey, Room#ets_cross_dun_guard_room.mb_list) of
                            false -> 13;
                            {value, Mb, T} ->
                                ShadowTime = max(?CROSS_DUNGEON_GUARD_SHADOW_SUB, Room#ets_cross_dun_guard_room.shadow_time - ?CROSS_DUNGEON_GUARD_SHADOW_SUB),
                                ?DO_IF(Mb#dungeon_mb.node /= none, server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, {cross_dun_guard_state, 0})),
                                NewRoom = Room#ets_cross_dun_guard_room{mb_list = T, ready_ref = none, shadow_time = ShadowTime},
                                cross_dungeon_guard_util:update_room(NewRoom),
                                cross_dungeon_guard_util:refresh_room(NewRoom),
                                cross_dungeon_guard_util:check_cancel_ready(Room),
                                cross_dungeon_guard_util:notice_kickout(Mb),
                                ?DO_IF(Room#ets_cross_dun_guard_room.password == "", self() ! {check_add_shadow, Room#ets_cross_dun_guard_room.key, ShadowTime}),
                                1
                        end
                end
        end,
    {ok, Bin} = pt_651:write(65106, {Ret}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%进入房间
handle_info({enter_room, Mb, DunId, Key, Password}, State) ->
    Ret =
        case cross_dungeon_guard_util:get_room(Key) of
            [] -> 2;
            Room ->
                if Room#ets_cross_dun_guard_room.dun_id /= DunId -> 2;
                    Room#ets_cross_dun_guard_room.password /= Password -> 14;
                    true ->
                        case length(Room#ets_cross_dun_guard_room.mb_list) >= ?CROSS_DUNGEON_GUARD_Mb_LIM of
                            true -> 16;
                            false ->
                                MbList = [Mb | lists:keydelete(Mb#dungeon_mb.pkey, #dungeon_mb.pkey, Room#ets_cross_dun_guard_room.mb_list)],
                                NewRoom = Room#ets_cross_dun_guard_room{mb_list = MbList},
                                cross_dungeon_guard_util:update_room(NewRoom),
                                cross_dungeon_guard_util:refresh_room(NewRoom),
                                cross_dungeon_guard_util:check_open(NewRoom),
                                ?DO_IF(Room#ets_cross_dun_guard_room.password == "",
                                    self() ! {check_add_shadow, Room#ets_cross_dun_guard_room.key, Room#ets_cross_dun_guard_room.shadow_time}),
                                server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, {cross_dun_guard_state, Key}),
                                1
                        end
                end
        end,
    {ok, Bin} = pt_651:write(65108, {Ret}),
    server_send:send_to_sid(Mb#dungeon_mb.node, Mb#dungeon_mb.sid, Bin),
%%    center:apply(Mb#dungeon_mb.node, server_send, send_to_sid, [Mb#dungeon_mb.sid, Bin]),
    {noreply, State};


%%房间准备
handle_info({ready_room, Node, Sid, Key, Pkey}, State) ->
    Ret =
        case cross_dungeon_guard_util:get_room(Key) of
            [] -> 2;
            Room ->
                case lists:keytake(Pkey, #dungeon_mb.pkey, Room#ets_cross_dun_guard_room.mb_list) of
                    false -> 3;
                    {value, Mb, T} ->
                        MbList = [Mb#dungeon_mb{is_ready = 2} | T],
                        NewRoom = Room#ets_cross_dun_guard_room{mb_list = MbList},
                        cross_dungeon_guard_util:update_room(NewRoom),
                        cross_dungeon_guard_util:refresh_room(NewRoom),
                        cross_dungeon_guard_util:check_open(NewRoom),
                        1
                end
        end,
    {ok, Bin} = pt_651:write(65109, {Ret}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%邀请玩家
handle_info({check_invite, Node, Key, Nickname, Pid}, State) ->
    case cross_dungeon_guard_util:get_room(Key) of
        [] -> ok;
        Room ->
            server_send:send_node_pid(Node, Pid, {guard_invite_msg, Nickname, Room#ets_cross_dun_guard_room.dun_id, Key, Room#ets_cross_dun_guard_room.password})
    end,
    {noreply, State};


%%邀请公告
handle_info({invite_notice, Node, Sid, Key, Nickname}, State) ->
    Ret =
        case cross_dungeon_guard_util:get_room(Key) of
            [] -> 3;
            Room ->
                Now = util:unixtime(),
                if Room#ets_cross_dun_guard_room.cd > Now -> 19;
                    true ->
                        NewRoom = Room#ets_cross_dun_guard_room{cd = Now + 15},
                        cross_dungeon_guard_util:update_room(NewRoom),
                        cross_dungeon_guard_util:refresh_room(NewRoom),
                        center:apply(Node, notice_sys, add_notice, [cross_dun_invite_notice, [Nickname, Key, Room#ets_cross_dun_guard_room.dun_id, Room#ets_cross_dun_guard_room.password, 2]]),
                        1
                end
        end,
    {ok, Bin} = pt_651:write(65114, {Ret}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%开启副本
handle_info({open_dungeon, Node, Sid, Key, Pkey}, State) ->
    Ret =
        case cross_dungeon_guard_util:get_room(Key) of
            [] -> 3;
            Room ->
                if Room#ets_cross_dun_guard_room.pkey /= Pkey -> 21;
                    true ->
                        F = fun(Mb) -> Mb#dungeon_mb.is_ready > 0 end,
                        case lists:all(F, Room#ets_cross_dun_guard_room.mb_list) of
                            false ->
                                22;
                            true ->
                                self() ! {open_dungeon, Room#ets_cross_dun_guard_room.key},
                                ok
                        end
                end
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_651:write(65115, {Ret, 0}),
            server_send:send_to_sid(Node, Sid, Bin)
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
    end,
    {noreply, State};

%%离线
handle_info({logout, Key, Pkey}, State) ->
    case cross_dungeon_guard_util:get_room(Key) of
        [] -> ok;
        Room ->
            cross_dungeon_guard_util:do_quit(Room, Pkey, false)
    end,
    {noreply, State};

%%返回房间
handle_info({back_room, Mb, DunId, Lv, Key, Password, IsFast}, State) ->
    case cross_dungeon_guard_util:get_room(Key) of
        [] ->
            handle_info({create_room, Mb, DunId, Lv, Password, IsFast}, State);
        _ ->
            handle_info({enter_room, Mb, DunId, Key, Password}, State)
    end;

%%房间聊天
handle_info({send_info, Key,Pkey, Nickname, Type}, State) ->
    case cross_dungeon_guard_util:get_room(Key) of
        [] ->
            skip;
        Room ->
            F = fun(Mb) ->
                if
                    Mb#dungeon_mb.node == none -> skip;
                    true ->
                        {ok, Bin} = pt_651:write(65129, {Pkey, Nickname, Type}),
                        ?DEBUG("Mb#dungeon_mb.sid ~p~n",[Mb#dungeon_mb.sid]),
                        server_send:send_to_sid(Mb#dungeon_mb.sid, Bin)
                end
            end,
            ?DEBUG("Room#ets_cross_dun_guard_room.mb_list ~p~n",[Room#ets_cross_dun_guard_room.mb_list]),
            lists:foreach(F, Room#ets_cross_dun_guard_room.mb_list)
    end,
    {noreply, State};


%%设置房间超时
handle_info({set_timeout, Key}, State) ->
    Ref = erlang:send_after(?CROSS_DUNGEON_GUARD_ROOM_TIMEOUT * 1000, self(), {room_timeout, Key}),
    put({room_timeout, Key}, Ref),
    {noreply, State};

%%取消超时
handle_info({cancel_timeout, Key}, State) ->
    misc:cancel_timer({room_timeout, Key}),
    {noreply, State};

%%房间超时
handle_info({room_timeout, Key}, State) ->
    misc:cancel_timer({room_timeout, Key}),
    case cross_dungeon_guard_util:get_room(Key) of
        [] -> ok;
        Room ->
            {ok, Bin} = pt_651:write(65107, {20}),
            F1 = fun(Mb) ->
                if Mb#dungeon_mb.node == none -> ok;
                    true ->
                        server_send:send_to_sid(Mb#dungeon_mb.node, Mb#dungeon_mb.sid, Bin),
%%                        center:apply(Mb#dungeon_mb.node, server_send, send_to_sid, [Mb#dungeon_mb.sid, Bin]),
                        server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, {cross_dun_guard_state, 0})
                end
            end,
            lists:foreach(F1, Room#ets_cross_dun_guard_room.mb_list),
            cross_dungeon_guard_util:delete_room(Room#ets_cross_dun_guard_room.key)
    end,
    {noreply, State};

%%系统玩家加入计时
handle_info({check_add_shadow, Key, Time}, State) ->
    misc:cancel_timer({add_shadow, Key}),
    Ref = erlang:send_after(Time * 1000, self(), {add_shadow, Key}),
    put({add_shadow, Key}, Ref),
    {noreply, State};

%%添加机器人
handle_info({add_shadow, Key}, State) ->
    misc:cancel_timer({add_shadow, Key}),
    case cross_dungeon_guard_util:add_shadow(Key) of
        false -> ok;
        {true, Time} ->
            Ref = erlang:send_after(Time * 1000, self(), {add_shadow, Key}),
            put({add_shadow, Key}, Ref)
    end,
    {noreply, State};

%%取消准备
handle_info({cancel_ready, Ref}, State) ->
    util:cancel_ref([Ref]),
    {noreply, State};

%%准备
handle_info({ready_dungeon, Key}, State) ->
    case cross_dungeon_guard_util:get_room(Key) of
        [] -> ok;
        Room ->
            util:cancel_ref([Room#ets_cross_dun_guard_room.ready_ref]),
            if Room#ets_cross_dun_guard_room.is_fast == 1 ->
                self() ! {open_dungeon, Key};
                true ->
                    Timer = 8,
                    Ref = erlang:send_after(Timer * 1000, self(), {open_dungeon, Key}),
                    NewRoom = Room#ets_cross_dun_guard_room{ready_ref = Ref},
                    cross_dungeon_guard_util:update_room(NewRoom),
                    {ok, Bin} = pt_651:write(65110, {1, Timer}),
                    cross_dungeon_guard_util:send_to_leader(Room, Bin)
            end
    end,
    {noreply, State};

%%开启副本
handle_info({open_dungeon, Key}, State) ->
    cross_dungeon_guard_util:do_open_dungeon(Key),
    {noreply, State};

handle_info({del_in_pro_room, Key}, State) ->
    cross_dungeon_guard_util:delete_in_pro_room(Key),
    {noreply, State};

handle_info(clean, State) ->
    F = fun({Key, _Val}) ->
        case Key of
            {add_shadow, RoomKey} ->
                case cross_dungeon_guard_util:get_room(RoomKey) of
                    [] ->
                        erlang:erase({add_shadow, RoomKey});
                    _ -> ok
                end;
            {room_timeout, RoomKey} ->
                case cross_dungeon_guard_util:get_room(RoomKey) of
                    [] ->
                        erlang:erase({room_timeout, RoomKey});
                    _ -> ok
                end;
            _ -> ok
        end
    end,
    lists:foreach(F, get()),
%%    erlang:send_after(?FIFTEEN_MIN_SECONDS * 1000, self(), clean),
    {noreply, State};

handle_info(_Msg, State) ->
    {noreply, State}.

