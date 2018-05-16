%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 副本
%%% @end
%%% Created : 21. 九月 2015 下午3:13
%%%-------------------------------------------------------------------
-module(dungeon).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("dungeon.hrl").
-include("scene.hrl").
-include("kindom_guard.hrl").
-include("tips.hrl").
-include("guild.hrl").

-behaviour(gen_server).

%% API
-export([
    start/4,
    check_enter/2,
    quit_dungeon/1,
    kill_mon/1,
    collect_mon/1,
    get_exp/2,
    get_coin/2,
    get_goods/2,
    get_mon_list/3,
    create_mon/5,
    logout/1
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    calc_kill_list/1,
    dungeon_record/3
]).

-define(SERVER, ?MODULE).


%%%===================================================================
%%% API
%%%===================================================================
%% playerlist [#dungeon_mb{}]
%% now 当前时间
%% dunid 副本id
%% Extra
start(DunPlayerList, DunId, Now, Extra) ->
    {ok, Pid} = gen_server:start(?MODULE, [DunPlayerList, DunId, Now, Extra], []),
    Pid.

%%检查进入
check_enter(SceneId, DunPid) ->
    ?CALL(DunPid, {check_enter, SceneId}).

%%退出副本
quit_dungeon(Player) ->
    if
        Player#player.scene == ?SCENE_ID_KINDOM_GUARD_ID ->
            catch Player#player.copy ! {out, Player#player.key};
        true ->
            catch Player#player.copy ! {quit, Player}
    end.

%%副本杀怪
kill_mon(Mon) ->
    cross_arena_room:kill_mon(Mon),
    case lists:member(Mon#mon.scene, data_dungeon:ids()) of
        true ->
            Mon#mon.copy ! {kill_mon, Mon#mon.mid, Mon#mon.shadow_key, [{scene, Mon#mon.scene}, {wave, Mon#mon.wave}, {xy, {Mon#mon.x, Mon#mon.y}}]};
        false -> skip
    end.

%%副本采集
collect_mon(Mon) ->
    case lists:member(Mon#mon.scene, data_dungeon:ids()) of
        true ->
            Mon#mon.copy ! {kill_mon, Mon#mon.mid, Mon#mon.shadow_key, [{wave, Mon#mon.wave}]};
        false -> skip
    end.

%%获得奖励
get_exp(DunPid, Exp) ->
    catch DunPid ! {exp, Exp}.

get_coin(DunPid, Coin) ->
    catch DunPid ! {coin, Coin}.

get_goods(DunPid, GoodsList) ->
    catch DunPid ! {goods, GoodsList}.

%%玩家下线
logout(Player) ->
    dungeon_tower:logout(),
    dungeon_material:logout(),
    dungeon_exp:logout(),
    dungeon_daily:logout(),
    dungeon_fuwen_tower:logout(),
    dungeon_equip:logout(),
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> skip;
        true ->
            catch Player#player.copy ! {logout, Player#player.key},
            ok
    end.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([DunPlayerList, DunId, Now, Extra]) ->
    SelfId = self(),
    scene_init:priv_create_scene(DunId, SelfId),
    Dungeon = data_dungeon:get(DunId),
    DunSceneList = dungeon_util:parse_dungeon_scene([{DunId, true} | Dungeon#dungeon.scenes], []),
    %%小黑板
    dungeon_record(Dungeon, DunPlayerList, Now),
    AddTime = 0,
    %%副本结束定时器
    Ref = erlang:send_after((Dungeon#dungeon.time * 1000 + AddTime), self(), dungeon_finish),
    StDungeon = match_extra(Extra, #st_dungeon{}),
    Round0 = ?IF_ELSE(StDungeon#st_dungeon.dun_exp#dun_exp.round_min == 0, 1, StDungeon#st_dungeon.dun_exp#dun_exp.round_min),
    Round1 = ?IF_ELSE(dungeon_util:is_dungeon_demon(DunId), StDungeon#st_dungeon.dun_demon#dun_demon.round_min, Round0),
    Round2 = ?IF_ELSE(dungeon_util:is_dungeon_guard(DunId), StDungeon#st_dungeon.dun_guard#dun_guard.round, Round1),
    Round3 = ?IF_ELSE(dungeon_util:is_dungeon_marry(DunId), 1, Round2),
    Round4 = ?IF_ELSE(dungeon_util:is_dungeon_jiandao(DunId), 1, Round3),
    Round = ?IF_ELSE(dungeon_util:is_dungeon_god_weapon(DunId), StDungeon#st_dungeon.dun_god_weapon#dun_god_weapon.round, Round4),
    MonList = get_mon_list(Dungeon, Round, DunPlayerList),
    ?DEBUG("MonList:~p ", [MonList]),
    MaxRound0 = ?IF_ELSE(StDungeon#st_dungeon.dun_exp#dun_exp.round_max == 0, length(MonList), StDungeon#st_dungeon.dun_exp#dun_exp.round_max),
    MaxRound1 = ?IF_ELSE(dungeon_util:is_dungeon_demon(DunId), StDungeon#st_dungeon.dun_demon#dun_demon.round_max, MaxRound0),
    MaxRound2 = ?IF_ELSE(dungeon_util:is_dungeon_jiandao(DunId), data_dun_jiandao_mon:get_max_round_by_dun_id(DunId), MaxRound1),
    MaxRound3 = ?IF_ELSE(dungeon_util:is_dungeon_element(DunId), data_dun_element_mon:get_max_round_by_dun_id(DunId), MaxRound2),
    MaxRound = ?IF_ELSE(dungeon_util:is_dungeon_god_weapon(DunId), StDungeon#st_dungeon.dun_god_weapon#dun_god_weapon.round_max, MaxRound3),
    {NeedKill, KillList} = create_mon(Dungeon#dungeon.type, DunId, Round, MonList, 1, DunPlayerList),
    MonCollectList = get_collect_list(DunId),
    create_collect_mon(MonCollectList, DunId),
    %%每波怪定时器
    RoundTime = ?IF_ELSE(Dungeon#dungeon.type == ?DUNGEON_TYPE_GUARD, 1, 0),
    RoundRef = ?IF_ELSE(RoundTime > 0, erlang:send_after(RoundTime * 1000, self(), {time_to_next_round}), 0),
    NewStDungeon = StDungeon#st_dungeon{
        type = Dungeon#dungeon.type,
        lv = Dungeon#dungeon.lv,
        round = Round,
        next_round_timer = RoundRef,
        round_time = Now + RoundTime,
        max_round = MaxRound,
        dungeon_id = DunId,
        time = Dungeon#dungeon.time,
        begin_time = Now,
        end_time = Now + Dungeon#dungeon.time + AddTime,
        close_timer = Ref,
        player_list = DunPlayerList,
        scene_list = DunSceneList,
        need_kill_num = NeedKill,
        kill_list = KillList,
        mon = MonList
    },
    NewStDungeon1 = ?IF_ELSE(Dungeon#dungeon.type == ?DUNGEON_TYPE_KINDOM_GUARD, kindom_guard:start_init(NewStDungeon, Extra, DunId, 0), NewStDungeon),
    ?IF_ELSE(Dungeon#dungeon.type == ?DUNGEON_TYPE_GUARD, dungeon_guard:start_init(Extra, DunId, 0), ok),
    ?PRINT("DUNGEON ~p INIT FINISH!~n", [DunId]),
    dungeon_record:set_history(self(), NewStDungeon#st_dungeon.end_time),
    ?IF_ELSE(Dungeon#dungeon.type == ?DUNGEON_TYPE_JIANDAO, spawn(fun() -> timer:sleep(500), SelfId ! jiandao_dungeon_target end), ok),
    {ok, NewStDungeon1}.

get_collect_list(DunId) ->
    case dungeon_util:is_dungeon_marry(DunId) of
        false -> [];
        true ->
            AllMonId = data_dungeon_marry_collect:get_all(),
            F = fun(Id) ->
                {MonId, XyList} = data_dungeon_marry_collect:get(Id),
                {X, Y} = util:list_rand(XyList),
                {MonId, X, Y}
            end,
            lists:map(F, AllMonId)
    end.

%%创建采集怪
create_collect_mon(MonCollectList, DunId) ->
    Pid = self(),
    F = fun({MonId, X, Y}) ->
        mon_agent:create_mon_cast([MonId, DunId, X, Y, Pid, 1, [{group, 1}]])
    end,
    lists:map(F, MonCollectList).

%%额外数据匹配赋值
match_extra([], StDun) -> StDun;
match_extra([{arena, Val} | T], StDun) ->
    NewStDun = StDun#st_dungeon{dun_arena = Val},
    match_extra(T, NewStDun);
match_extra([{first_pass, Val} | T], StDun) ->
    NewStDun = StDun#st_dungeon{first_pass = Val},
    match_extra(T, NewStDun);
match_extra([{dun_exp_round_min, Val} | T], StDun) ->
    DunExp = StDun#st_dungeon.dun_exp,
    NewDunExp = DunExp#dun_exp{round_min = Val},
    NewStDun = StDun#st_dungeon{dun_exp = NewDunExp},
    match_extra(T, NewStDun);
match_extra([{dun_exp_round_max, Val} | T], StDun) ->
    DunExp = StDun#st_dungeon.dun_exp,
    NewDunExp = DunExp#dun_exp{round_max = Val},
    NewStDun = StDun#st_dungeon{dun_exp = NewDunExp},
    match_extra(T, NewStDun);
match_extra([{dun_exp_round_h, Val} | T], StDun) ->
    DunExp = StDun#st_dungeon.dun_exp,
    NewDunExp = DunExp#dun_exp{round_h = Val},
    NewStDun = StDun#st_dungeon{dun_exp = NewDunExp},
    match_extra(T, NewStDun);
match_extra([{dun_demon_round_min, Val} | T], StDun) ->
    DunDemon = StDun#st_dungeon.dun_demon,
    NewDunDemon = DunDemon#dun_demon{round_min = Val},
    NewStDun = StDun#st_dungeon{dun_demon = NewDunDemon},
    match_extra(T, NewStDun);
match_extra([{dun_demon_round_max, Val} | T], StDun) ->
    DunDemon = StDun#st_dungeon.dun_demon,
    NewDunDemon = DunDemon#dun_demon{round_max = Val},
    NewStDun = StDun#st_dungeon{dun_demon = NewDunDemon},
    match_extra(T, NewStDun);
match_extra([{dun_demon_add, Val} | T], StDun) ->
    DunDemon = StDun#st_dungeon.dun_demon,
    NewDunDemon = DunDemon#dun_demon{add = Val},
    NewStDun = StDun#st_dungeon{dun_demon = NewDunDemon},
    match_extra(T, NewStDun);
match_extra([{dun_demon_pass_list, Val} | T], StDun) ->
    DunDemon = StDun#st_dungeon.dun_demon,
    NewDunDemon = DunDemon#dun_demon{pass_num = Val},
    NewStDun = StDun#st_dungeon{dun_demon = NewDunDemon},
    match_extra(T, NewStDun);
match_extra([{dun_demon_reduce, Val} | T], StDun) ->
    DunDemon = StDun#st_dungeon.dun_demon,
    NewDunDemon = DunDemon#dun_demon{reduce = Val},
    NewStDun = StDun#st_dungeon{dun_demon = NewDunDemon},
    match_extra(T, NewStDun);
match_extra([{dun_god_weapon_round, Round, MaxRound, LayerH, RoundH} | T], StDun) ->
    DunGodWeapon = StDun#st_dungeon.dun_god_weapon,
    NewDunGodWeapon = DunGodWeapon#dun_god_weapon{round = Round, round_max = MaxRound, layer_h = LayerH, round_h = RoundH},
    NewStDun = StDun#st_dungeon{dun_god_weapon = NewDunGodWeapon},
    match_extra(T, NewStDun);
match_extra([{dun_guard_round, Round, BossHp} | T], StDun) ->
    DunGuard = StDun#st_dungeon.dun_guard,
    NewDunGuard = DunGuard#dun_guard{round = Round, boss_hp = BossHp, kill_floor = Round},
    NewStDun = StDun#st_dungeon{dun_guard = NewDunGuard},
    match_extra(T, NewStDun);
match_extra([_ | T], StDun) ->
    match_extra(T, StDun).


%%小黑板：进入副本记录
dungeon_record(Dungeon, DunPlayerList, Now) ->
    F = fun(DunPlayer) ->
        DungeonRecord = #dungeon_record{
            pkey = DunPlayer#dungeon_mb.pkey,
            dun_id = Dungeon#dungeon.id,
            dungeon_pid = self(),
            timeout = Now + Dungeon#dungeon.time,
            benefit = 1,
            out = [DunPlayer#dungeon_mb.scene, DunPlayer#dungeon_mb.copy, DunPlayer#dungeon_mb.x, DunPlayer#dungeon_mb.y]
        },
        dungeon_record:set(DunPlayer#dungeon_mb.pkey, DungeonRecord)
    end,
    lists:foreach(F, DunPlayerList).

handle_call(Request, From, State) ->
    case catch dungeon_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("dungeon handle_call ~p~n", [Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch dungeon_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("dungeon handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch dungeon_handle:handle_info(Request, State) of
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("dungeon handle_info ~p/ ~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, State) ->
%%    scene_agent:clean_scene_area(State#st_dungeon.dungeon_id, self()),
    Now = util:unixtime(),
    %%LOG
    F = fun(Mb) ->
        if Mb#dungeon_mb.type == ?DUN_MB_TYPE_NORMAL ->
            if
                State#st_dungeon.is_pass == 1 andalso State#st_dungeon.type == ?DUNGEON_TYPE_TOWER ->
                    skip;
                true ->
                    dungeon_util:log_dungeon(Mb#dungeon_mb.pkey, Mb#dungeon_mb.nickname, State#st_dungeon.dungeon_id, State#st_dungeon.type, State#st_dungeon.is_pass, [], Now)
            end;
            true -> skip
        end
    end,
    lists:foreach(F, State#st_dungeon.player_list),
    dungeon_record:clean_history(self()),
    scene_init:priv_stop_scene(State#st_dungeon.dungeon_id, self()),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%获取怪物列表
get_mon_list(Dungeon, Round, _DunPlayerList) ->
    ?DEBUG("Dungeon#dungeon.type:~p", [Dungeon#dungeon.type]),
    if
        Dungeon#dungeon.type == ?DUNGEON_TYPE_EXP ->
            [{Round, data_dungeon_exp:get(Round)}];
        Dungeon#dungeon.type == ?DUNGEON_TYPE_GUILD_DEMON ->
            Base = data_dungeon_demon:get(Round),
            [{Round, Base#base_dun_demon.mon_list}];
        Dungeon#dungeon.type == ?DUNGEON_TYPE_GOD_WEAPON ->
            [{Round, data_dungeon_god_weapon:get_mon(Dungeon#dungeon.id, Round)}];
        Dungeon#dungeon.type == ?DUNGEON_TYPE_KINDOM_GUARD ->
            [];
        Dungeon#dungeon.type == ?DUNGEON_TYPE_CROSS_GUARD ->
            [];
        Dungeon#dungeon.type == ?DUNGEON_TYPE_GUARD ->
            [{Round, data_dungeon_guard:get_mon(Round)}];
        Dungeon#dungeon.type == ?DUNGEON_TYPE_MARRY ->
            [{Round, data_dungeon_marry:get_mon(Round)}];
        Dungeon#dungeon.type == ?DUNGEON_TYPE_JIANDAO ->
            [{Round, data_dun_jiandao_mon:get(Dungeon#dungeon.id, Round)}];
        Dungeon#dungeon.type == ?DUNGEON_TYPE_ELEMENT ->
            [{Round, data_dun_element_mon:get(Dungeon#dungeon.id, Round)}];
        true ->
            Dungeon#dungeon.mon
    end.

%% 副本创建怪物
create_mon(DunType, DunId, Round, MonList, IsBc) ->
    create_mon(DunType, DunId, Round, MonList, IsBc, []).
create_mon(DunType, DunId, Round, MonList, IsBc, DunPlayerList) ->
    if DunId == ?SCENE_ID_ARENA ->
        {1, []};
        true ->
            MonInfo = lists:keyfind(Round, 1, MonList),
            case MonInfo == false orelse DunType == ?DUNGEON_TYPE_KINDOM_GUARD of
                true ->
                    {0, []};
                false ->
                    case MonInfo == false orelse DunType == ?DUNGEON_TYPE_GUARD of
                        true ->
                            {0, []};
                        false ->
                            {_Round, RoundMonList} = MonInfo,
                            Pid = self(),
                            %%特定副本创怪延迟
                            SleepTime =
                                case DunType of
                                    ?DUNGEON_TYPE_GUILD_DEMON -> 4;
                                    _ -> 0
                                end,
                            IsBc1 =
                                case SleepTime > 0 of
                                    true -> 1;
                                    false -> IsBc
                                end,
                            F = fun({Mid, X, Y}) ->
                                case DunId == ?SCENE_ID_DUN_MARRY of
                                    true ->
                                        if
                                            DunPlayerList /= [] ->
                                                {Time, K1, K2} = data_dungeon_marry:get_k(Round),
                                                Att = lists:sum(lists:map(fun(#dungeon_mb{att = Att}) ->
                                                    Att end, DunPlayerList)),
                                                MonHpLim = round(Time * K1 * K2 * Att),
                                                ?DEBUG("MonHpLim:~p", [MonHpLim]),
                                                mon_agent:create_mon_cast([Mid, DunId, X, Y, Pid, IsBc1, [{group, 1}, {hp_lim, MonHpLim}, {hp, MonHpLim}]]);
                                            true ->
                                                mon_agent:create_mon_cast([Mid, DunId, X, Y, Pid, IsBc1, [{group, 1}]])
                                        end;
                                    false ->
                                        mon_agent:create_mon_cast([Mid, DunId, X, Y, Pid, IsBc1, [{group, 1}]])
                                end
                            end,
                            spawn(fun() -> timer:sleep(SleepTime * 1000), lists:foreach(F, RoundMonList) end),
                            KillList = calc_kill_list(RoundMonList),
                            {length(RoundMonList), KillList}
                    end
            end
    end.

%%统计详细击杀
calc_kill_list(MonList) ->
    F = fun({Mid, _, _}, List) ->
        case lists:keyfind(Mid, 1, List) of
            false ->
                [{Mid, 1, 0} | List];
            {_, Need, Cur} ->
                lists:keyreplace(Mid, 1, List, {Mid, Need + 1, Cur})
        end
    end,
    lists:foldl(F, [], MonList).