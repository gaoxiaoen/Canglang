%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 一月 2017 下午5:02
%%%-------------------------------------------------------------------
-module(kindom_guard).
-author("fengzhenlin").
-include("server.hrl").
-include("kindom_guard.hrl").
-include("common.hrl").
-include("dungeon.hrl").

%% API
-compile(export_all).

%%检查开始时间
check_open_time(Now) ->
    WeekDay = util:get_day_of_week(Now),
    case lists:keyfind(WeekDay, 1, ?OPEN_TIME_LIST) of
        false -> skip;
        {_, {H1, M1}} ->
            Date = util:unixdate(Now),
            OpenTime = Date + H1 * 3600 + M1 * 60,
            NowMin = Now - Now rem 60,
            if
                OpenTime == NowMin + ?KINDOM_GUARD_DEFORE_NOTICE_TIME ->
                    %%即将开启
                    kindom_guard_proc:get_act_pid() ! ready_open,
                    ok;
                OpenTime == NowMin ->
                    %%开启
                    kindom_guard_proc:rpc_open_kindom_guard();
                true ->
                    skip
            end
    end.

%%获取王城守卫状态信息
get_kindom_guard_state(Player) ->
    ?CAST(kindom_guard_proc:get_act_pid(), {get_kindom_guard_state, Player#player.sid}),
    ok.
%%全服通知状态
kindom_guard_state_notice(State, Time) ->
    {ok, Bin} = pt_122:write(12220, {State, Time}),
    server_send:send_to_all(Bin).

%%怪物刷新通知
mon_refresh_notice(SceneId, Copy, Floor, Time) ->
    {ok, Bin} = pt_122:write(12221, {Floor, Time}),
    server_send:send_to_scene(SceneId, Copy, Bin),
    ok.

%%进入王城守卫
enter_kindom_guard(Player, DunPid) ->
    Now = util:unixtime(),
    Mb = dungeon_util:make_dungeon_mb(Player, Now),
    spawn(fun() ->
        timer:sleep(1000),
        DunPid ! {enter_kindom_guard, Mb},
        timer:sleep(500),
        ScenePlayerList = scene_agent:get_scene_player(?SCENE_ID_KINDOM_GUARD_ID),
        [ScenePlayer#scene_player.pid ! {apply_state, {kindom_guard, refresh_kindom_buff, []}} || ScenePlayer <- ScenePlayerList]
          end),
    %%玩法找回
    findback_src:fb_trigger_src(Player, 31, 1),
    ok.

%%退出王城守卫
exit_kindom_guard(Player) ->
    Player1 = buff:del_buff_list(Player, ?KINDOM_BUFF_ID_LIST, 1),
    {ok, Bin} = pt_200:write(20005, {1, Player#player.key, battle_pack:pack_buff_list(Player1#player.buff_list, util:unixtime())}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player1.

%%刷新守卫战意buff
refresh_kindom_buff([], Player) ->
    Player1 = buff:del_buff_list(Player, ?KINDOM_BUFF_ID_LIST, 1),
    case ?CALL(kindom_guard_proc:get_act_pid(), get_buff) of
        [] -> {ok, Player1};
        {ok, BuffList} ->
            Player2 = buff:add_buff_list_to_player(Player1, BuffList, 0),
            {ok, Player2}
    end.

is_kindom_guard_dun(SceneId) ->
    SceneId == ?SCENE_ID_KINDOM_GUARD_ID.

%%获取进入副本copy
get_enter_dun_copy(Pkey) ->
    case ?CALL(kindom_guard_proc:get_act_pid(), {get_enter_dun_copy, Pkey}) of
        [] -> [];
        Copy -> Copy
    end.

%%副本启动--复制副本怪物
start_init(StDungeon, [KillFloor, Floor, MonList, KillList, StartTime], DunId, IsBc) when Floor > 0 ->
    F = fun({MonId, Hp, X, Y, Wave}) ->
        Base = data_mon:get(MonId),
        case Base#mon.kind == ?MON_KIND_KINDOM_GUARD of
            true ->
                mon_agent:create_mon([MonId, DunId, X, Y, self(), IsBc, [{type, ?ATTACK_TENDENCY_MON}, {group, 9}, {hp, Hp}, {world_lv_mon, 1}]]);
            false ->
                Args = [{type, ?ATTACK_TENDENCY_MON}, {group, 1}, {wave, Wave}, {hp, Hp}, {world_lv_mon, 1}],
                mon_agent:create_mon([MonId, DunId, X, Y, self(), 1, Args])
        end
        end,
    lists:foreach(F, MonList),
    Base = data_dungeon_kindom_guard:get(Floor),
    RoundTime = Base#base_kindom_dun.round_time,
    Copy = self(),
    ReadyTime = 10,
    spawn(fun() ->
        timer:sleep((RoundTime - ReadyTime) * 1000),
        kindom_guard:mon_refresh_notice(?SCENE_ID_KINDOM_GUARD_ID, Copy, Floor, ReadyTime)
          end),
    RoundRef = erlang:send_after(RoundTime * 1000, Copy, {time_to_next_round}),
    Now = util:unixtime(),
    StDungeon#st_dungeon{
        begin_time = StartTime,
        next_round_timer = RoundRef,
        round_time = Now + RoundTime,
        kill_list = KillList,
        dun_kindom = #dun_kindom{
            cur_floor = Floor,
            kill_floor = KillFloor
        }
    };
%%副本启动--创建守卫怪物
start_init(StDungeon, _Extra, DunId, IsBc) ->
    BaseDun = data_dungeon:get(?SCENE_ID_KINDOM_GUARD_ID),
    F = fun({MonId, X, Y}) ->
        mon_agent:create_mon([MonId, DunId, X, Y, self(), IsBc, [{type, ?ATTACK_TENDENCY_MON}, {group, 9}, {world_lv_mon, 1}]])
        end,
    lists:foreach(F, BaseDun#dungeon.mon),
    Copy = self(),
    ReadyTime = 10,
    Base = data_dungeon_kindom_guard:get(1),
    RoundTime = Base#base_kindom_dun.round_time,
    spawn(fun() ->
        timer:sleep(max(1, (RoundTime - ReadyTime)) * 1000),
        kindom_guard:mon_refresh_notice(?SCENE_ID_KINDOM_GUARD_ID, Copy, 1, ReadyTime)
          end),
    RoundRef = erlang:send_after(RoundTime * 1000, Copy, {time_to_next_round}),
    Now = util:unixtime(),
    StDungeon#st_dungeon{
        next_round_timer = RoundRef,
        round_time = Now + RoundTime
    }.

%%判断是否是守卫
is_guard_mon(Mid) ->
    BaseDun = data_dungeon:get(?SCENE_ID_KINDOM_GUARD_ID),
    case lists:keyfind(Mid, 1, BaseDun#dungeon.mon) of
        false -> false;
        _ -> true
    end.

%%怪物被杀，创建怪物宝箱
create_mon_box(Mid, X, Y, Copy) ->
    Base = data_dungeon_kindom_guard_box:get(Mid),
    case Base of
        [] -> skip;
        _ ->
            BoxNum = get_box_num(),
            case BoxNum < 40 of %%最大只能存在40个宝箱
                true ->
                    #base_mon_drop_box{
                        ratio = Ratio
                    } = Base,
                    case util:odds(Ratio, 10000) of
                        true ->
                            Len = length(Base#base_mon_drop_box.box_list),
                            XYList = get_create_mon_box_xy_list(?SCENE_ID_KINDOM_GUARD_ID, X, Y, Len),
                            case XYList of
                                [] -> skip;
                                _ ->
                                    F1 = fun(Mid1, AccXYList) ->
                                        [{X1, Y1} | Tail] = AccXYList,
                                        mon_agent:create_mon_cast([Mid1, ?SCENE_ID_KINDOM_GUARD_ID, X1, Y1, Copy, 1, []]),
                                        Tail ++ [{X1, Y1}]
                                         end,
                                    lists:foldl(F1, XYList, Base#base_mon_drop_box.box_list)
                            end;
                        false ->
                            skip
                    end;
                false ->
                    skip
            end
    end.

get_create_mon_box_xy_list(SceneId, X, Y, GetNum) ->
    L = [{X, Y}, {X - 1, Y}, {X, Y - 1}, {X + 1, Y}, {X, Y + 1}, {X - 1, Y - 1}, {X + 1, Y + 1}, {X - 2, Y}, {X, Y - 2}, {X - 2, Y - 2}],
    get_create_mon_box_xy_list_1(GetNum, SceneId, L, []).
get_create_mon_box_xy_list_1(0, _SceneId, _XYList, AccList) -> AccList;
get_create_mon_box_xy_list_1(_GetNum, _SceneId, [], AccList) -> AccList;
get_create_mon_box_xy_list_1(GetNum, SceneId, [{X, Y} | Tail], AccList) ->
    case scene:can_moved(SceneId, X, Y) of
        false -> get_create_mon_box_xy_list_1(GetNum, SceneId, Tail, AccList);
        true -> get_create_mon_box_xy_list_1(GetNum - 1, SceneId, Tail, [{X, Y} | AccList])
    end.


get_box_num() ->
    Now = util:unixtime(),
    case get(kindom_box_num) of
        undefined ->
            Num = length(mon_agent:get_scene_mon_by_kind(?SCENE_ID_KINDOM_GUARD_ID, self(), ?MON_KIND_KINDOM_GUARD_BOX)),
            put(kindom_box_num, {Num, Now}),
            Num;
        {Num, Time} ->
            case Now - Time > 8 of
                true ->
                    put(kindom_box_num, undefined),
                    get_box_num();
                false ->
                    Num
            end
    end.

%%创建波数宝箱
create_floor_box(Floor, Copy) ->
    Base = data_dungeon_kindom_guard:get(Floor),
    case Base of
        [] -> skip;
        _ ->
            F1 = fun({Mid, X, Y}) ->
                mon_agent:create_mon_cast([Mid, ?SCENE_ID_KINDOM_GUARD_ID, X, Y, Copy, 1, []])
                 end,
            lists:foreach(F1, Base#base_kindom_dun.box_list)
    end.

%%击杀怪物公告
kill_mon_noitce(Mon, KillerName) ->
    #mon{
        mid = Mid,
        scene = Scene,
        copy = Copy
    } = Mon,
    Base = data_dungeon_kindom_guard_box:get(Mid),
    case Base of
        [] -> skip;
        _ ->
            case Base#base_mon_drop_box.is_notice of
                1 ->
                    notice_sys:add_notice(kindom_kill_boss, [KillerName, Mon#mon.name, Scene, Copy]),
                    ok;
                _ -> skip
            end
    end.
