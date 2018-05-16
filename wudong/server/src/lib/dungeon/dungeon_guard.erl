%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     守护副本
%%% @end
%%% Created : 15. 六月 2017 19:54
%%%-------------------------------------------------------------------
-module(dungeon_guard).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("dungeon.hrl").
-include("achieve.hrl").
-include("tips.hrl").

%% API
-export([init/2,
    midnight_refresh/1,
    timer_update/0,
    logout/0,
    get_dungeon_info/1,
    sweep/1,
    check_enter/2,
    get_enter_dungeon_extra/2,
    dungeon_guard_ret/4,
    get_notice_player/1,
    check_sweep/0,
    check_sweep_state/1,
    get_god_mon/0,
    start_init/3,
    dungeon_target/2,
    update_dun_guard_wave/4,
    guard_notice/2,
    dun_guard_ret/3,
    clean/0,
    init_rank/0,
    load_dun_guard_rank/0,
    get_save/1,
    get_state/0,
    is_dun_guard_td/1,
    get_can_sweep_round/0,
    gm_res/1,
    create_mon/4
]).

-define(DUN_GUARD_ID, 30401).

gm_res(Player) ->
    lib_dict:put(?PROC_STATUS_DUN_GUARD, #st_dun_guard{pkey = Player#player.key}).

init(Player, Now) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_DUN_GUARD, #st_dun_guard{pkey = Player#player.key, change_time = Now});
        false ->
            case dungeon_load:load_dun_guard(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_DUN_GUARD, #st_dun_guard{pkey = Player#player.key, change_time = Now});
                [Round, RoundMax, FirstRound, RewardList, ChangeTime, FirstTime, IsSweep, SweepRound] ->
                    SaveRound = max(Round, get_save(RoundMax)),
                    case util:is_same_date(Now, ChangeTime) of
                        true ->
                            lib_dict:put(?PROC_STATUS_DUN_GUARD, #st_dun_guard{
                                pkey = Player#player.key,
                                round = SaveRound,
                                round_max = RoundMax,
                                first_round = FirstRound,
                                reward_list = util:bitstring_to_term(RewardList),
                                change_time = ChangeTime,
                                first_time = FirstTime,
                                is_sweep = IsSweep,
                                sweep_round = SweepRound});
                        false ->
                            lib_dict:put(?PROC_STATUS_DUN_GUARD, #st_dun_guard{
                                pkey = Player#player.key,
                                round_max = RoundMax,
                                change_time = Now,
                                first_round = FirstRound,
                                is_change = 1,
                                round = SaveRound,
                                first_time = FirstTime,
                                sweep_round = get_save(RoundMax)})
                    end
            end
    end.

midnight_refresh(Now) ->
    St = lib_dict:get(?PROC_STATUS_DUN_GUARD),
    NewSt = St#st_dun_guard{change_time = Now, reward_list = [], is_change = 1, is_sweep = 0, sweep_round = get_save(St#st_dun_guard.round_max)},
    lib_dict:put(?PROC_STATUS_DUN_GUARD, NewSt),
    ok.

timer_update() ->
    St = lib_dict:get(?PROC_STATUS_DUN_GUARD),
    if St#st_dun_guard.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_DUN_GUARD, St#st_dun_guard{is_change = 0}),
        dungeon_load:replace_dun_guard(St);
        true -> ok
    end.

logout() ->
    St = lib_dict:get(?PROC_STATUS_DUN_GUARD),
    if St#st_dun_guard.is_change == 1 ->
        dungeon_load:replace_dun_guard(St);
        true -> ok
    end.


%%副本信息
get_dungeon_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_DUN_GUARD),
    #st_dun_guard{
        round = Round,
        round_max = RoundMax
    } = St,
    SaveRound = get_save(RoundMax),
    NextSaveRound = get_next_save(RoundMax),
    MyRank = get_my_dun_guard_rank(Player#player.key),
    RankList = get_dun_guard_rank(),
    {FirstRound, FirstList0} = get_first_round(RoundMax),
    FirstList = [[GoodsId0, GoodsNum0] || {GoodsId0, GoodsNum0} <- FirstList0],
    {ReRound, RewardList0} = get_round(Round),
    RewardList = [[GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- RewardList0],
    case check_sweep() of
        ok -> State = 1;
        _ -> State = 0
    end,
    {RoundMax, SaveRound, NextSaveRound, ReRound, State, RewardList, FirstRound, FirstList, MyRank, RankList}.

get_round(Round) ->
    RewardList0 = data_dungeon_guard:get_reward_list(Round + 1),
    if
        RewardList0 == [] ->
            {Round, data_dungeon_guard:get_reward_list(Round)};
        true ->
            {Round + 1, RewardList0}
    end.



get_first_round(Round) ->
    FirstList = data_dungeon_guard:get_first_list(),
    List = [X || X <- FirstList, X > Round],
    case List of
        [] -> {hd(lists:reverse(FirstList)), []};
        _ -> H = hd(List),
            {H, data_dungeon_guard:get_first_reward(H)}
    end.

get_save(MaxRound) ->
    List0 = data_dungeon_guard:get_save_list(),
    List = [X || X <- List0, X =< MaxRound],
    case lists:reverse(List) of
        [] -> 0;
        Other -> hd(Other)
    end.

get_next_save(Round) ->
    List0 = data_dungeon_guard:get_save_list(),
    List = [X || X <- List0, X > Round],
    case List of
        [] -> 0;
        _ -> hd(List)
    end.

%%扫荡
sweep(Player) ->
    case check_sweep() of
        {false, Res} -> {false, Res};
        ok ->
            St = lib_dict:get(?PROC_STATUS_DUN_GUARD),
            #st_dun_guard{
                reward_list = RewardList,
                sweep_round = SweepRound
            } = St,
            F = fun(Floor, {List, RewardList0}) ->
                case lists:member(Floor, RewardList) of
                    true ->
                        {List, RewardList0};
                    false ->
                        {data_dungeon_guard:get_reward_list(Floor) ++ List, [Floor | RewardList0]}
                end
            end,
            {GoodsList, NewRewardList} = lists:foldl(F, {[], []}, lists:seq(1, SweepRound)),
            NewSt = St#st_dun_guard{reward_list = NewRewardList, is_sweep = 1},
            put(?PROC_STATUS_DUN_GUARD, NewSt),
            dungeon_load:replace_dun_guard(NewSt),
            activity:get_notice(Player, [121], true),
            GiveGoodsList = goods:make_give_goods_list(270, GoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            findback_src:fb_trigger_src(Player, 17, SweepRound),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2014, 0, SweepRound),
            {ok, NewPlayer, SweepRound, GoodsList}
    end.

%%获取可扫荡
get_can_sweep_round() ->
    St = lib_dict:get(?PROC_STATUS_DUN_GUARD),
    #st_dun_guard{
        sweep_round = SweepRound
    } = St,
    SweepRound.

check_sweep() ->
    St = lib_dict:get(?PROC_STATUS_DUN_GUARD),
    #st_dun_guard{
        is_sweep = IsSweep,
        sweep_round = SweepRound
    } = St,
    if
        IsSweep == 1 -> {false, 15};
        SweepRound == 0 -> {false, 15};
        true -> ok
    end.

get_state() ->
    case dungeon_guard:check_sweep() of
        ok -> 1;
        _ -> 0
    end.

check_sweep_state(Tips) ->
    Ret = get_state(),
    ?IF_ELSE(Ret == 0, Tips, Tips#tips{state = 1, saodang_dungeon_list = [?TIPS_DUNGEON_TYPE_GUARD | Tips#tips.saodang_dungeon_list]}).


%%副本进入检查
check_enter(_Player, DunId) ->
    case dungeon_util:is_dungeon_guard(DunId) of
        false -> true;
        true ->
            case data_dungeon_guard:get_max_floor() of
                0 ->
                    {false, ?T("波数配置错误")};
                GuardMax ->
                    St = lib_dict:get(?PROC_STATUS_DUN_GUARD),
                    #st_dun_guard{round = Round} = St,
                    if Round >= GuardMax ->
                        {false, ?T("已通关")};
                        true ->
                            true
                    end
            end

    end.



get_notice_player(_Player) ->
%%     Tips = check_enter_state(_Player, #tips{}),
    State = check_sweep(),
    if
        State == 1 -> 1;
%%         Tips#tips.state > 0 -> 1;
        true ->
%%             St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
%%             MaxRound = data_dungeon_god_weapon:max_round(St#st_dun_god_weapon.layer),
%%             ?IF_ELSE(St#st_dun_god_weapon.round < MaxRound, 1, 0)
            0
    end.

%%获取进入副本额外参数
get_enter_dungeon_extra(Player, _DunId) ->
    St = lib_dict:get(?PROC_STATUS_DUN_GUARD),
    #st_dun_guard{
        round_max = Round
    } = St,
    BossHp = data_dungeon_guard_boss_hp:get(Player#player.lv),
    [{dun_guard_round, get_save(Round), BossHp}].


%%副本结算
dungeon_guard_ret(Player, DunId, Round, GoodsList) ->
    Layer = data_dungeon_god_weapon:scene2layer(DunId),
    MaxRound = data_dungeon_god_weapon:max_round(Layer),
    NextDunId =
        if Round < MaxRound -> 0;
            true ->
                data_dungeon_god_weapon:layer2scene(Layer + 1)
        end,
    {ok, Bin} = pt_121:write(12152, {DunId, NextDunId, goods:pack_goods(GoodsList)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [100, 109], true),
    ok.

get_god_mon() ->
    {43001, 7, 14}.

start_init(Extra, DunId, IsBc) ->
    %% 创建守护怪
    case lists:keyfind(dun_guard_round, 1, Extra) of
        false -> skip;
        {_, _, BossHp} ->
            {GodMonId, GodX, GodY} = get_god_mon(),
            mon_agent:create_mon_cast([GodMonId, DunId, GodX, GodY, self(), IsBc, [{group, 0}, {hp, BossHp}, {hp_lim, BossHp}]])
    end,
    ok.

dungeon_target(State, SendType) ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.round_time - Now),
    EndTime = max(0, State#st_dungeon.end_time - Now),
    #st_dungeon{
        dun_guard = #dun_guard{round = Round}
        , kill_list = KillList
    } = State,
    MonCount = get_mon_count(KillList),
    RoundReward = [[GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- data_dungeon_guard:get_reward_list(Round)],
    {ok, Bin} = pt_121:write(12181, {Round, MonCount, EndTime, LeftTime, RoundReward}),
    case is_pid(SendType) of
        true -> server_send:send_to_pid(SendType, Bin);
        false -> server_send:send_to_sid(SendType, Bin)
    end,
    ok.

get_mon_count(KillList) ->
    F = fun({_, MonList}, Sum) ->
        List = [Need - Cur || {_MonId, Need, Cur} <- MonList],
        Sum + lists:sum(List)
    end,
    lists:foldl(F, 0, KillList).

%%更新通关波数
update_dun_guard_wave(Player, MinFloor, Wave, _StartFloor) ->
    DunGuardSt = lib_dict:get(?PROC_STATUS_DUN_GUARD),
    #st_dun_guard{
        round_max = MyMaxFloor,
        first_time = FirstTime,
        reward_list = RewardList,
        first_round = FirstRound,
        show_list = ShowList
    } = DunGuardSt,
    Now = util:unixtime(),
    if
        MinFloor > MyMaxFloor ->
            NewMyMaxFloor = MinFloor,
            NewFirstTime = Now;
        true ->
            NewMyMaxFloor = MyMaxFloor,
            NewFirstTime = FirstTime
    end,
    {NewRewardList, GoodsList, ShowList0} = get_new_reward_list(Wave, RewardList),
    NewFirstFloor = update_first_round(Player#player.key, MinFloor, FirstRound),
    NewDunGuardSt = DunGuardSt#st_dun_guard{
        round_max = NewMyMaxFloor,
        round = MinFloor,
        first_time = NewFirstTime,
        change_time = Now,
        reward_list = NewRewardList,
        first_round = NewFirstFloor,
        show_list = ShowList ++ ShowList0
    },
    lib_dict:put(?PROC_STATUS_DUN_GUARD, NewDunGuardSt),
    dungeon_load:replace_dun_guard(NewDunGuardSt),
    GiveGoods = goods:make_give_goods_list(269, GoodsList),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoods),
    findback_src:fb_trigger_src(Player, 17, NewMyMaxFloor),
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2014, 0, MinFloor),
    NewPlayer.


get_new_reward_list(Wave, RewardList) ->
    case lists:member(Wave, RewardList) of
        true -> {RewardList, [], []};
        false -> {[Wave | RewardList], data_dungeon_guard:get_reward_list(Wave), [Wave]}
    end.

update_first_round(Pkey, NewFloor, FirstRound) ->
    if
        NewFloor > FirstRound ->
            F = fun(Floor) ->
                GoodsList = data_dungeon_guard:get_first_reward_one(Floor),
                ?IF_ELSE(GoodsList == [], skip, reward_msg(Pkey, Floor, GoodsList, 98))
            end,
            lists:foreach(F, lists:seq(FirstRound + 1, NewFloor)),
            NewFloor;
        true -> FirstRound
    end.

reward_msg(Pkey, Floor, GoodsList, Type) ->
    {Title, Content} = t_mail:mail_content(Type),
    NewContent = io_lib:format(Content, [Floor]),
    mail:sys_send_mail([Pkey], Title, NewContent, GoodsList),
    ok.


guard_notice(Sid, Floor) ->
    Info = data_dungeon_guard:get(Floor),
    NewInfoList = [[MonId, Type] || {MonId, Type} <- Info#base_guard_dun.info],
    {ok, Bin} = pt_121:write(12195, {NewInfoList}),
    server_send:send_to_sid(Sid, Bin),
    ok.


dun_guard_ret(Player, _IsPass, PassFloor) ->
    St = lib_dict:get(?PROC_STATUS_DUN_GUARD),
    #st_dun_guard{
        show_list = ShowList
    } = St,
    GoodsList0 = lists:append(lists:map(fun data_dungeon_guard:get_reward_list/1, ShowList)),
    F = fun({GoodsId, _GoodsNum}, {List, SumList}) ->
        case lists:member(GoodsId, List) of
            true -> {List, SumList};
            false ->
                {[GoodsId | List], [{GoodsId, lists:sum(proplists:append_values(GoodsId, GoodsList0))} | SumList]}
        end
    end,
    {_, GoodsList1} = lists:foldl(F, {[], []}, GoodsList0),
    GoodsList = [[GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- GoodsList1],
    put(?PROC_STATUS_DUN_GUARD, St#st_dun_guard{show_list = []}),
    {ok, Bin} = pt_121:write(12184, {1, PassFloor, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    LogDungeon =
        #log_dungeon{
            pkey = Player#player.key,
            nickname = Player#player.nickname,
            cbp = Player#player.cbp,
            dungeon_id = ?DUNGEON_ID_GUARD,
            dungeon_type = ?DUNGEON_TYPE_GUARD,
            dungeon_desc = ?T("守护副本"),
            layer = PassFloor,
            layer_desc = ?T(io_lib:format("第~p波", [PassFloor])),
            sub_layer = 0,
            time = util:unixtime()
        },
    ?IF_ELSE(GoodsList /= [], dungeon_log:log(LogDungeon), skip),
    Player.

clean() ->
    lib_dict:put(?PROC_STATUS_DUN_GUARD, #st_dun_guard{}),
    ok.

init_rank() ->
    load_dun_guard_rank(),
    ok.

get_my_dun_guard_rank(GKey) ->
    case ets:lookup(ets_rank_dun_guard, GKey) of
        [] -> 0;
        [Rank | _] -> Rank#ets_rank_dun_guard.rank
    end.

get_dun_guard_rank() ->
    AllRankList = ets:tab2list(ets_rank_dun_guard),
    SortRankList = lists:sort(fun(R1, R2) -> R1#ets_rank_dun_guard.rank < R2#ets_rank_dun_guard.rank end, AllRankList),
    RankList = lists:sublist(SortRankList, ?DUN_GUARD_RANK_LIMIT),
    F = fun(Rank) ->
        #ets_rank_dun_guard{
            pkey = Pkey,
            nickname = NickName,
            rank = Order,
            floor = Floor
        } = Rank,
        [Order, Pkey, NickName, Floor]
    end,
    lists:map(F, RankList).

load_dun_guard_rank() ->
    ets:delete_all_objects(ets_rank_dun_guard),
    SQL = io_lib:format("select g.pkey, g.round_max, g.pass_time, p.nickname from player_dun_guard_td g right join player_state p on g.pkey = p.pkey where  round_max > 0 ", []),
    case db:get_all(SQL) of
        [] ->
            ok;
        Rows when is_list(Rows) ->

            F0 = fun([_AKey, ARoundMax, APassTime, _ANickname], [_BKey, BRoundMax, BPassTime, _BNickname]) ->
                if
                    ARoundMax > BRoundMax -> true;
                    ARoundMax < BRoundMax -> false;
                    APassTime < BPassTime -> true;
                    APassTime > BPassTime -> false;
                    true -> true
                end
            end,
            List = lists:sort(F0, Rows),
            F = fun([Pkey0, RoundMax, PassTime, Nickname], Order) ->
                R = #ets_rank_dun_guard{
                    pkey = Pkey0,
                    nickname = Nickname,
                    rank = Order,
                    floor = RoundMax,
                    pass_time = PassTime
                },
                ets:insert(ets_rank_dun_guard, R),
                Order + 1
            end,
            lists:foldl(F, 1, List),
            ok;
        _ ->
            err
    end.

is_dun_guard_td(SceneId) ->
    SceneId == ?SCENE_ID_DUN_GUARD.

create_mon(State, Args, RoundMonList, Did) ->
%%
%%     F0 = fun({Mid, X, Y}, {Flag, List0}) ->
%%         List1 = [{Mid, X, Y} | List0],
%%         F = fun({Mid0, X0, Y0}) ->
%%             mon_agent:create_mon_cast([Mid0, State#st_dungeon.dungeon_id, X0, Y0, Did, 1, Args])
%%         end,
%%         if
%%             Flag rem 3 == 0 ->
%%                 lists:foreach(F, List1),
%%                 util:sleep(2000),
%%                 {Flag + 1, []};
%%             true ->
%%                 {Flag + 1, List1}
%%         end
%%     end,
%%     lists:foldl(F0, {0, []}, RoundMonList).
    MonList = create_mon_help(RoundMonList, []),
    F0 = fun({MonList0}) ->
        F = fun({Mid0, X0, Y0}) ->
            mon_agent:create_mon_cast([Mid0, State#st_dungeon.dungeon_id, X0, Y0, Did, 1, Args])
        end,
        lists:foreach(F, MonList0),
        util:sleep(2000)
    end,
    lists:foreach(F0, MonList).


create_mon_help([], List) -> lists:reverse(List);
create_mon_help(RoundMonList, List) ->
    Len = length(RoundMonList),
    if
        Len < 3 ->
            [{RoundMonList} | List];
        true ->
            {List1, List2} = lists:split(3, RoundMonList),
            create_mon_help(List2, [{List1} | List])
    end.


