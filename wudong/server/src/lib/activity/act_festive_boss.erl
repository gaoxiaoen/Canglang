%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         节日首领
%%% @end
%%% Created : 23. 十月 2017 16:57
%%%-------------------------------------------------------------------
-module(act_festive_boss).
-author("lzx").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("scene.hrl").
-include("daily.hrl").
-include("battle.hrl").

%% Camp Timer API
-export([
    campaign_ready/0,
    campaign_start/0,
    campaign_end/0,
    get_open_time/1
]).


-export([
    send_boss_info/1,
    gm_open/0,
    gm_close/0,
    get_state/1,
    kill_boss/3,
    last_kill_reward_1/2,
    kill_festive_boss/2,
    is_act_festive_boss/1
]).

-define(END_TIME,camp_festive_boss_end_time).                    %% 活动结束时间戳
-define(GM_OPEN_TIME,camp_festive_boss_gm_open_time).             %% gm
-define(CAMP_FESTIVE_BOSS_STATE,camp_festive_boss_state).         %% boss 状态记录
-define(TV_TIMES,camp_festive_boss_tv_times).                     %% 10分钟发送一次传闻


%--------------------------------------------
%%  @doc 准备状态
%%--------------------------------------------
campaign_ready() -> ok.
%%    ReadyLongTime = get_type_long_time(ready),
%%    ?GLOBAL_DATA_RAM:set(?END_TIME,util:unixtime() + ReadyLongTime),
%%    activity:set_timer_open_state(?CAMP_ACT_FESTIVE_BOSS,?ACT_READY_STATE).


get_act() ->
    case activity:get_work_list(data_act_festive_boss) of
        [_Base | _] -> _Base;
        _ ->
            []
    end.


campaign_is_open() ->
    case get_act() of
        [] -> false;
        _ ->
            true
    end.

%%is_open(State) ->
%%    Con1 = campaign_is_open(),
%%    Con2 = activity:check_timer_state(?CAMP_ACT_FESTIVE_BOSS, State),
%%    Con1 andalso Con2.



get_open_time_list() ->
    #base_act_festive_boss{
        readytime = ReadyList,
        opentime = OpenList,
        endtime = EndList
    } = get_act(),
    Data = [ReadyList,OpenList,EndList],
%%    ?PRINT("get_open_time_list ~w",[Data]),
    Data.



%%--------------------------------------------
%%  @doc 活动开启
%%--------------------------------------------
campaign_start() ->
    case campaign_is_open() of
        true ->
%%            ?ERR("start_festive_boss"),
            start_festive_boss();
        false ->
            ?ERR("campaign_start fail"),
            ok
    end.


start_festive_boss() ->
    #base_act_festive_boss{
        monids = MonIds
    } = get_act(),
    SceneIds = data_act_festive_boss_pose:ids(),
    AllPosList =
        lists:foldl(fun(SceneId, AccPostList) ->
            #base_act_festive_boss_pos{pos = PosList} = data_act_festive_boss_pose:get(SceneId),
            [{SceneId, PosList} | AccPostList]
                    end, [], SceneIds),
    {MonStateList, ApearList} =
        lists:foldl(fun({MonKey,MonId}, {AccList, MonPosList}) ->
            {IsAlive, MonPid,SceneId, X, Y} = check_mon_alive(MonKey,MonId, SceneIds),
            NewMonPosList =
                case IsAlive of
                    1 ->
                        %% 删除已出现的坐标点
                        case lists:keyfind(SceneId, 1, MonPosList) of
                            {_, ScenePos} ->
                                NewPose = lists:delete({X, Y}, ScenePos),
                                lists:keystore(SceneId, 1, MonPosList, {SceneId,NewPose});
                            _ ->
                                MonPosList
                        end;
                    _ -> %% 创建怪物
                        MonPosList
                end,
            NewAccList = [{MonKey, IsAlive, MonPid, SceneId, X, Y} | AccList],
            {NewAccList, NewMonPosList}
                    end, {[], AllPosList}, MonIds),

    %% 创建怪物
    {MonState2,_} =
    lists:foldl(fun({MonKey, IsAlive, MonPid,_SceneId, _X, _Y}, {AccMonState,AccAPearList}) ->
        case IsAlive > 0 of
            true ->
                {[{MonKey,IsAlive,MonPid,_SceneId,_X,_Y} | AccMonState],AccAPearList};
            _ ->
                RandSId = util:list_rand(SceneIds),
                case lists:keyfind(RandSId, 1, AccAPearList) of
                    {_, PostList} ->
                        {X2, Y2} = util:list_rand(PostList),
                        {MonKey,MonId} = lists:keyfind(MonKey,1,MonIds),
                        MonPid2 = mon_agent:create_mon([MonId, RandSId, X2, Y2, 0, 1, [{index,MonKey},{return_pid, true}]]),
                        NewPose = lists:delete({X2, Y2}, PostList),
                        NewAccAPearList = lists:keystore(RandSId, 1, AccAPearList, {RandSId,NewPose}),
                        NewAccMonState = [{MonKey,1,MonPid2,RandSId,X2,Y2}|AccMonState],
                        {NewAccMonState,NewAccAPearList};
                    _ ->
                        {AccMonState,AccAPearList}
                end
        end
                end, {[],ApearList}, MonStateList),
%%    ?PRINT("MonStateList1 ~w ================= MonState2 ========== ~w",[MonStateList,MonState2]),
    ?GLOBAL_DATA_RAM:set(?CAMP_FESTIVE_BOSS_STATE, MonState2),
    NowTime = util:unixtime(),
    ?GLOBAL_DATA_RAM:set(?TV_TIMES,NowTime),
    send_tv_time(NowTime).



send_tv_time(UnixTime) ->
    case ?GLOBAL_DATA_RAM:get(?TV_TIMES, false) of
        false -> ok;
        TvTime ->
            {Hour, Min} = util:unixtime_hour_min(UnixTime),
            {TvHour, TvMin} = util:unixtime_hour_min(TvTime),
            TvMsg = get_tv_msg(),
            if
                Hour =:= TvHour andalso Min =:= TvMin ->
                    case length(TvMsg) > 0 of
                        true ->
                            notice_sys:add_notice(act_festive_boss, [TvMsg]);
                        _ -> ok
                    end,
                    NextTime = UnixTime + 10 * 60,
                    ?GLOBAL_DATA_RAM:set(?TV_TIMES, NextTime);
                true -> ok
            end
    end.


get_tv_msg() ->
   case campaign_is_open() of
       true ->
           MonStateList = ?GLOBAL_DATA_RAM:get(?CAMP_FESTIVE_BOSS_STATE, []),
           lists:foldl(fun({_MonKey, IsAlive, _MonPid, _SceneId, _X, _Y}, AccMsg) ->
               case IsAlive == 1 of
                   true ->
                       #scene{name = ScenName} = data_scene:get(_SceneId),
                       Msg1 = io_lib:format(?T("~s(~p,~p)、"), [ScenName, _X, _Y]),
                       AccMsg ++ Msg1;
                   _ ->
                       AccMsg
               end
                       end, "", MonStateList);
       _ ->
           ""
   end.



check_mon_alive(_,_, []) -> {0, 0, 0, 0, 0};
check_mon_alive(MonKey,MonId, [SceneId | T]) ->
    case mon_agent:get_scene_mon_by_mid(SceneId, 0, MonId) of
        [] ->
            check_mon_alive(MonKey,MonId, T);
        MonList ->
            MonList2 = [{1,Pid,SceneId,X,Y}||#mon{x = X,y = Y,pid = Pid,index = Index} <- MonList,Index == MonKey],
            case MonList2 of
                [H|_] -> H;
                _ ->
                    check_mon_alive(MonKey,MonId,T)
            end
    end.



%%--------------------------------------------
%%  @doc 开启时间
%%--------------------------------------------
get_open_time(_UnixTime) ->
    case campaign_is_open() of
        false ->
            {[],[[],[],[]]};
        true ->
            send_tv_time(_UnixTime),
            case ?GLOBAL_DATA_RAM:get(?GM_OPEN_TIME,false) of
                false ->
                    OpenTimeList =  get_open_time_list(),
                    {?OPEN_WEEK_LIST,OpenTimeList};
                {ReadyTimeList,StartTimeList,EndTimeList} ->
                    {?OPEN_WEEK_LIST,[ReadyTimeList,StartTimeList,EndTimeList]}
            end
    end.



%%--------------------------------------------
%%  @doc 活动结束
%%--------------------------------------------
campaign_end() -> ok.
%%    case is_open(?ACT_OPEN_STATE) of
%%        true ->
%%            ?GLOBAL_DATA_RAM:del(?GM_OPEN_TIME),
%%            end_festive_boss(),
%%            activity:set_timer_open_state(?CAMP_ACT_FESTIVE_BOSS, ?ACT_CLOSE_STATE);
%%        false -> ok
%%    end.
%%
%%%% 结束
%%end_festive_boss() -> ok.

get_next_refresh_time(_,[]) -> 0;
get_next_refresh_time(NowTime,[H|T]) ->
    case H > NowTime of
        true ->
            {Hour1,Min1} = H,
            {Hour2,Min2} = NowTime,
            Hour1 * 3600 + Min1 * 60 - (Hour2 * 3600 + Min2 * 60);
        _ ->
            get_next_refresh_time(NowTime,T)
    end.


%% =========================================
send_boss_info(_Player) ->
    case get_act() of
        #base_act_festive_boss{monids = MonIds,kill_award = KillAward,show_award = ShowAwards,maxtired = MaxTired} ->
            LeftTime = activity:get_leave_time(data_act_festive_boss),
            PLVal = min(daily:get_count(?DAILY_ACT_FESTIVE_BOSS,0),MaxTired),
            MonList = ?GLOBAL_DATA_RAM:get(?CAMP_FESTIVE_BOSS_STATE,[]),
            [_,OpenTimeList,_] = get_open_time_list(),
            NowTime = util:unixtime_hour_min(util:unixtime()),
            NextRTime = get_next_refresh_time(NowTime,OpenTimeList),
            PackMonIds = lists:map(fun({MonKye,MonId}) ->
                case lists:keyfind(MonKye, 1, MonList) of
                    {_,IsAlive,_MonPid,SceneId,X,Y} ->
                        [MonId, IsAlive, SceneId, X, Y, NextRTime];
                    _ ->
                        [MonId, 0, 0, 0, 0, NextRTime]
                end
                                   end, MonIds),
            KillList = [[GoodsId,GoodsNum] || {GoodsId,GoodsNum} <- KillAward],
            ShowList = [[GoodsId,GoodsNum] || {GoodsId,GoodsNum} <- ShowAwards],
            SendData = {LeftTime,PLVal,MaxTired,PackMonIds,KillList,ShowList},
            ?PRINT("NextRTime ~w",[NextRTime]),
            SendData;
        _ ->
            {0,0,0,[],[],[]}
    end.


is_act_festive_boss(Mid) ->
    lists:member(Mid,[52202,52201]).
%%    case campaign_is_open() of
%%        true ->
%%            #base_act_festive_boss{monids = MonIds} = get_act(),
%%            MonIdList = [MonId || {_,MonId} <- MonIds],
%%            lists:member(Mid,MonIdList);
%%        _ ->
%%            false
%%    end.


update_kill_state(MonIdex) ->
    MonList = ?GLOBAL_DATA_RAM:get(?CAMP_FESTIVE_BOSS_STATE,[]),
    case lists:keytake(MonIdex,1,MonList) of
        false -> ok;
        {value,{_MonIndex,_IsAlive,_Pid,_SceneId,_X,_Y},LeftMonList} ->
            NewMonList = [{MonIdex,2,0,0,0,0}|LeftMonList],
            ?GLOBAL_DATA_RAM:set(?CAMP_FESTIVE_BOSS_STATE,NewMonList),
            %% 通知红圈
            Sids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
            [player:apply_state(async, Pid, {activity, sys_notice, [161]}) || [Pid] <- Sids]
    end.

%%击杀野外精英怪
kill_boss(Mon, Klist, #attacker{key = AtterKey,name = AttName,scene = SceneId}) ->
    case is_act_festive_boss(Mon#mon.mid) of
        true ->
            update_kill_state(Mon#mon.index),
            last_kill_reward(Mon#mon.mid,AtterKey,SceneId,AttName),
            F = fun(StHurt) ->
                #st_hatred{
                    key = Pkey
                } = StHurt,
                case player_util:get_player_online(Pkey) of
                    [] -> %%离线处理
                        daily:increment_count_outline(Pkey, ?DAILY_ACT_FESTIVE_BOSS, 1);
                    Online ->
                        Online#ets_online.pid ! {apply_state, {act_festive_boss, kill_festive_boss, []}}
                end
                end,
            lists:foreach(F, Klist);
        _ ->
            ok
    end,
    ok.


kill_festive_boss([], _Player) ->
    daily:increment(?DAILY_ACT_FESTIVE_BOSS, 1),
    ok.



%%最后一刀击杀奖励
last_kill_reward(Mid,AtterKey,SceneId,AttName) ->
    Mon = data_mon:get(Mid),
    #base_act_festive_boss{maxtired = MaxTired,kill_award = KillGoods} = get_act(),
    case player_util:get_player_online(AtterKey) of
        [] -> %%离线处理
            Count = daily:get_count_outline(AtterKey, ?DAILY_ACT_FESTIVE_BOSS),
            case Count >= MaxTired of
                true ->
                    skip;
                false ->
                    #scene{name = SceneName} = data_scene:get(SceneId),
                    [{GoodsId,_}|_] = KillGoods,
                    notice_sys:add_notice(act_festive_boss_last_kill, [AttName,SceneName,Mon#mon.name,GoodsId]),
                    Now = util:unixtime(),
                    TimeStr =
                        case version:get_lan_config() of
                            vietnam ->
                                util:unixtime_to_time_string4(Now);
                            _ ->
                                util:unixtime_to_time_string3(Now)
                        end,

                    Title = ?T("节日首领击杀奖励"),
                    Content = io_lib:format(?T("你于~s对~s节日首领进行了最后一击，恭喜您获得了最后一击奖励。"), [TimeStr, Mon#mon.name]),
                    mail:sys_send_mail([AtterKey], Title, Content, KillGoods)
            end;
        Online -> %%在线处理
            Online#ets_online.pid ! {apply_state, {act_festive_boss, last_kill_reward_1, [KillGoods, Mon,MaxTired]}}
    end,
    ok.


last_kill_reward_1([KillGoods, Mon,MaxTired], Player) ->
    Count = daily:get_count(?DAILY_ACT_FESTIVE_BOSS),
    case Count >= MaxTired of
        true -> skip;
        false ->
            #scene{name = SceneName} = data_scene:get(Player#player.scene),
            [{GoodsId,_}|_] = KillGoods,
            notice_sys:add_notice(act_festive_boss_last_kill, [Player#player.nickname,SceneName,Mon#mon.name,GoodsId]),
            Now = util:unixtime(),
            TimeStr =
                case version:get_lan_config() of
                    vietnam ->
                        util:unixtime_to_time_string4(Now);
                    _ ->
                        util:unixtime_to_time_string3(Now)
                end,
            Title = ?T("节日首领击杀奖励"),
            Content = io_lib:format(?T("你于~s对~s节日首领进行了最后一击，恭喜您获得了最后一击奖励。"), [TimeStr, Mon#mon.name]),
            mail:sys_send_mail([Player#player.key], Title, Content, KillGoods)
    end,
    ok.




%%%===================================================================
%%% Gm API
%%%===================================================================
%% 开启
gm_open() ->
    campaign_start().



%% gm 关闭
gm_close() ->
    campaign_end().



get_state(_Player) ->
    case get_act() of
        [] -> -1;
        #base_act_festive_boss{maxtired = MaxTired} ->
            PLVal = daily:get_count(?DAILY_ACT_FESTIVE_BOSS,0),
            case PLVal < MaxTired of
                true ->
                    BossSateList = ?GLOBAL_DATA_RAM:get(?CAMP_FESTIVE_BOSS_STATE,[]),
                    Ret = lists:any(fun( {_,IsAlive,_MonPid,_SceneId,_X,_Y}) ->
                        IsAlive == 1
                                    end,BossSateList),
                    case Ret of
                        true -> 1;
                        _ ->
                            0
                    end;
                _ ->
                    0
            end
    end.





