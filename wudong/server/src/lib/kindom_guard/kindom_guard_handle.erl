%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 一月 2017 下午4:58
%%%-------------------------------------------------------------------
-module(kindom_guard_handle).
-author("fengzhenlin").
-include("kindom_guard.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("scene.hrl").
-include("rank.hrl").
-include("dungeon.hrl").

%% API
-export([
    handle_call/3, handle_cast/2, handle_info/2
]).

handle_call({get_enter_dun_copy, Pkey}, _From, State) ->
    Res =
        if
            State#kindom_guard.state == 0 -> ?T("活动还没开启");
            State#kindom_guard.state == 2 -> ?T("活动即将开始，请稍候");
            true ->
                case lists:keyfind(Pkey, 1, State#kindom_guard.player_list) of
                    false ->
                        case lists:keysort(2, State#kindom_guard.copy_list) of
                            [] -> ?T("活动还没开启");
                            [{Copy, _Num}|_] ->
                                case erlang:is_process_alive(Copy) of
                                    false -> ?T("活动还没开启");
                                    true -> Copy
                                end
                        end;
                    {_, DunPid} ->
                        case lists:keyfind(DunPid, 1, State#kindom_guard.copy_list) of
                            false -> ?T("今日已成功抵抗敌军，请少侠明日再来！");
                            _ ->
                                case erlang:is_process_alive(DunPid) of
                                    false -> ?T("今日已成功抵抗敌军，请少侠明日再来！");
                                    true -> DunPid
                                end
                        end
                end
        end,
    {reply, Res, State};

handle_call(get_buff_info, _From, State) ->
    F = fun(Type) ->
            case lists:keyfind(Type, 1, State#kindom_guard.buff_player) of
                false -> [Type, "", 0];
                {Type, _Pkey, Pname, State1} -> [Type, Pname, State1]
            end
        end,
    Res = lists:map(F, lists:seq(1,3)),
    {reply, Res, State};

handle_call(get_buff, _From, State) ->
    #kindom_guard{
        buff_player = BuffPlayer
    } = State,
    TypeList = [T||{T,_,_,S}<-BuffPlayer, S == 1],
    F = fun(Type) ->
            lists:nth(Type, ?KINDOM_BUFF_ID_LIST)
        end,
    BuffList = lists:map(F, TypeList),
    {reply, {ok, BuffList}, State};

handle_call(_Info,_From,State) ->
    ?ERR("kindom_guard_handle call info ~p~n",[_Info]),
    {reply,ok,State}.

handle_cast({get_kindom_guard_state, Sid}, State) ->
    Now = util:unixtime(),
    case State#kindom_guard.state =/= 0 of
        true ->
            {ok, Bin} = pt_122:write(12220, {State#kindom_guard.state, max(0, State#kindom_guard.end_time-Now)}),
            server_send:send_to_sid(Sid, Bin),
            ok;
        false ->
            {ok, Bin} = pt_122:write(12220, {0, 0}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end,
    {noreply, State};

handle_cast(_Info,State) ->
    ?ERR("kindom_guard_handle cast info ~p~n",[_Info]),
    {noreply, State}.

%%准备开启
handle_info(ready_open, State) ->
    kindom_guard:kindom_guard_state_notice(2, ?KINDOM_GUARD_DEFORE_NOTICE_TIME),
    NewState = State#kindom_guard{
        state = 2,
        end_time = util:unixtime() + ?KINDOM_GUARD_DEFORE_NOTICE_TIME
    },
    notice_sys:add_notice(kindom_guard_ready, []),
    {noreply, NewState};

%%开启王城守卫
handle_info(open_kindom_guard, State) ->
    if
        State#kindom_guard.state == 1 -> {noreply, State};
        true ->
            Now = util:unixtime(),
            %%开启副本
            DunPid = dungeon:start([], ?SCENE_ID_KINDOM_GUARD_ID, Now, []),
            ActTime = ?KINDOM_GUARD_OPEN_TIME,
            Ref = erlang:send_after(ActTime*1000, self(), end_kindom_guard),
            %%获取战意buff玩家
            BuffPlayer1 =
                case manor_war:get_scene_manor_guild(?SCENE_ID_MAIN) of
                    [] -> [];
                    Guild -> [{1, Guild#guild.pkey, Guild#guild.pname, 0}]
                end,
            BuffPlayer2 =
                case rank:get_rank_top_N(?RANK_TYPE_CBP, 1) of
                    [] -> [];
                    PowerList ->
                        RankCbp = hd(PowerList),
                        #a_rank{
                            rp = #rp{
                                pkey = PPkey,
                                nickname = PName
                            }
                        } = RankCbp,
                        [{2, PPkey, PName, 0}]
                end,
            BuffPlayer3 =
                case answer:get_answer_rank_top_n(1) of
                    [] -> [];
                    AnswerList when is_list(AnswerList) ->
                        {_AOrder, APkey, AName, _APoint, _RightNum} = hd(AnswerList),
                        [{3, APkey, AName, 0}];
                    _ -> []
                end,

            BuffPlayerList = BuffPlayer1 ++ BuffPlayer2 ++ BuffPlayer3,
            NewState = State#kindom_guard{
                state = 1,
                copy_list = [{DunPid, 0}],
                start_time = Now,
                end_time = Now+ActTime,
                end_ref = Ref,
                buff_player = BuffPlayerList
            },
            notice_sys:add_notice(kindom_guard_open, []),
            kindom_guard:kindom_guard_state_notice(1, max(0, NewState#kindom_guard.end_time-Now)),
            %%玩法找回
            findback_src:update_act_time(31, Now),
            {noreply, NewState}
    end;

%%结束王城守卫
handle_info(end_kindom_guard, State) ->
    util:cancel_ref([State#kindom_guard.end_ref]),
    F = fun({DunPid, _Num}) ->
            DunPid ! {kindom_finish, ?KINDOM_NOTICE_STATE_TIME_END}
        end,
    spawn(fun() -> lists:foreach(F, State#kindom_guard.copy_list) end),
    NewState = State#kindom_guard{
        state = 0,
        copy_list = [],
        player_list = [],
        start_time = 0,
        end_time = 0,
        end_ref = 0,
        buff_player = []
    },
    kindom_guard:kindom_guard_state_notice(0, 0),
    {noreply, NewState};

%%单个房间结束
handle_info({dungeon_end, Copy}, State) ->
    #kindom_guard{
        state = KState,
        copy_list = CopyList
    } = State,
    case KState == 1 of
        true ->
            NewCopyList = lists:keydelete(Copy, 1, CopyList),
            NewState = State#kindom_guard{
                copy_list = NewCopyList
            },
            case NewCopyList == [] of
                true -> self() ! end_kindom_guard;
                false -> skip
            end,
            {noreply, NewState};
        false ->
            {noreply, State}
    end;

%%同步副本数据
handle_info({sync_dun_data, DunPid, MemList, CurFloor, _NewMemPid}, State) ->
    #kindom_guard{
        copy_list = CopyList,
        player_list = PlayerList,
        buff_player = BuffPlayer,
        start_time = StartTime
    } = State,
    Len = length(MemList),
    NewCopyList =
        case lists:keyfind(DunPid, 1, CopyList) of
            false -> CopyList++[{CopyList, Len}];
            _ -> lists:keyreplace(DunPid, 1, CopyList, {DunPid, Len})
        end,
    F = fun(Pkey, AccPlayerList) ->
            [{Pkey, DunPid}|lists:keydelete(Pkey, 1, AccPlayerList)]
        end,
    NewPlayerList = lists:foldl(F, PlayerList, MemList),

    %%检查战意玩家
    Fb= fun(Pkey, {AccBuffPlayer,AddList}) ->
            case lists:keyfind(Pkey, 2, AccBuffPlayer) of
                false -> {AccBuffPlayer,AddList};
                {Type, _, Pname, BState} ->
                    AddList1 =
                        case CurFloor =/= 0 andalso BState == 0 of
                            true -> [[Type,Pname]|AddList];
                            false -> AddList
                        end,
                    {[{Type, Pkey, Pname, 1}|lists:keydelete(Pkey,2,AccBuffPlayer)], AddList1}
            end
        end,
    {NewBuffPlayerList, NewAddList} = lists:foldl(Fb, {BuffPlayer,[]}, MemList),
    Now = util:unixtime(),
    Base = data_dungeon_kindom_guard:get(1),
    Round1Time = Base#base_kindom_dun.round_time,
    case Now - StartTime >= Round1Time of
        true ->
            case NewAddList of
                [] ->
%%                     L = [[T,Pn]||{T, _, Pn, S}<-NewBuffPlayerList,S==1],
%%                     {ok, Bin} = pt_122:write(12222, {L}),
%%                     server_send:send_to_scene(?SCENE_ID_KINDOM_GUARD_ID, Bin);
                    ok;
                _ ->
                    {ok, Bin} = pt_122:write(12222, {NewAddList}),
                    server_send:send_to_scene(?SCENE_ID_KINDOM_GUARD_ID, Bin)
            end;
        false ->
            skip
    end,
    NewState = State#kindom_guard{
        copy_list = NewCopyList,
        player_list = NewPlayerList,
        buff_player = NewBuffPlayerList
    },
    %%检查是否需要新开房间
    {_, Num} = lists:last(NewCopyList),

    case Num >= ?MAX_DUN_NUM of
        true -> self() ! open_new_copy;
        false -> skip
    end,
    {noreply, NewState};

%%战斗前buff通知
handle_info(buff_notice_before_fight, State) ->
    BuffList0 = lists:sort(State#kindom_guard.buff_player),
    BuffList = [[Type, Pname]||{Type,_Pkey,Pname,BState}<-BuffList0,BState == 1],
    case BuffList of
        [] -> skip;
        _ ->
            {ok, Bin} = pt_122:write(12222, {BuffList}),
            server_send:send_to_scene(?SCENE_ID_KINDOM_GUARD_ID, Bin)
    end,
    {noreply, State};

%%开启新分线
handle_info(open_new_copy, State) ->
    {DunPid,_} = lists:last(State#kindom_guard.copy_list),
    MonList = mon_agent:get_scene_mon(?SCENE_ID_KINDOM_GUARD_ID, DunPid),
    case ?CALL(DunPid, get_kindom_dungeon_info) of
        [] -> {noreply, State};
        [KillFloor,CurFloor,KillList] ->
            Now = util:unixtime(),
            MonInfoList = [{M#mon.mid,M#mon.hp,M#mon.x,M#mon.y,M#mon.wave}||M<-MonList,M#mon.kind =/= ?MON_KIND_COLLECT],
            Pid = dungeon:start([], ?SCENE_ID_KINDOM_GUARD_ID, Now, [KillFloor,CurFloor, MonInfoList,KillList, State#kindom_guard.start_time]),
            NewCopyList = State#kindom_guard.copy_list ++ [{Pid, 0}],
            NewState = State#kindom_guard{
                copy_list = NewCopyList
            },
            {noreply, NewState}
    end;

handle_info(_Info,State) ->
    ?ERR("kindom_guard_handle info ~p~n",[_Info]),
    {noreply, State}.

