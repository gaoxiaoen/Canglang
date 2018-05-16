%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 十一月 2015 11:17
%%%-------------------------------------------------------------------
-module(task_convoy).
-author("hxming").
-include("task.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("achieve.hrl").
-include("sword_pool.hrl").


-define(COLOR_GREEN, 1).%%绿
-define(COLOR_BLUE, 2).%%蓝
-define(COLOR_PURPLE, 3).%%紫
-define(COLOR_ORANGE, 4).%%橙
-define(MAX_COLOR, 4).%%最高颜色
-define(REFRESH_FREE, 3).%%免费刷新次数

-define(EXTRA_TIMES, 0).

-define(GOD_BUFF_ID, 56601).

-define(VIP_ORANGE, 4).

%% API
-export([
    init/2
    , logout/0
    , timer_update/0
    , midnight_refresh/2
    , convoy_task/1
    , convoy_info/1
    , refresh_color/3
    , start_convoy/1
    , convoy_goods/1
    , finish_convoy/1
    , get_rob_times/0
    , convoy_rob_reward/3
    , convoy_die/2
    , task_lv/0
    , get_convoy/0
    , cmd_reset/1
    , get_notice_state/1
    , convoy_bin2kf/3
    , convoy_msg2kf/2
    , convoy_reward2kf/3
    , convoy_help_reward/1
    , convoy_timeout/1
    , convoy_msg/0
    , use_protect/1
    , call_for_help/1
    , helping/2
    , convoy_helping/2
]).

cmd_reset(Player) ->
    Convoy = #task_convoy{pkey = Player#player.key, time = util:unixtime(), color = ?COLOR_GREEN, times = 0, is_change = 1},
    set_convoy(Convoy),
    task:del_task_by_type(?TASK_TYPE_CONVOY, Player#player.sid),
    task_rpc:handle(30001, Player, {}),
    Player#player{convoy_state = 0}.


init(Player, Now) ->
    case player_util:is_new_role(Player) of
        true ->
            Convoy = #task_convoy{pkey = Player#player.key, times = 0, time = Now, color = ?COLOR_GREEN, extra_times = ?EXTRA_TIMES},
            set_convoy(Convoy),
            Player;
        false ->
            case task_load:select_task_convoy(Player#player.key) of
                [] ->
                    Convoy = #task_convoy{pkey = Player#player.key, times = 0, time = Now, color = ?COLOR_GREEN, extra_times = ?EXTRA_TIMES},
                    set_convoy(Convoy),
                    Player;
                [Color, Times, _ExtraTimes, TimesTotal, RobTimes, Time, RefreshFree, Godt, HelpTimes] ->
                    {NewColor, IsTask} = check_color(Player#player.key, Color, Player#player.lv, Now, Player#player.vip_lv),
                    case util:is_same_date(Now, Time) of
                        true ->
                            Convoy = #task_convoy{
                                pkey = Player#player.key,
                                color = NewColor,
                                times_total = TimesTotal,
                                times = Times,
                                rob_times = RobTimes,
                                time = Time,
                                refresh_free = RefreshFree,
                                godt = Godt,
                                help_times = HelpTimes
                            },
                            set_convoy(Convoy),
                            Player#player{convoy_state = ?IF_ELSE(IsTask, 0, NewColor)};
                        false ->
                            Convoy = #task_convoy{
                                pkey = Player#player.key,
                                color = NewColor,
                                times_total = TimesTotal,
                                time = Now,
                                godt = Godt,
                                is_change = 1
                            },
                            set_convoy(Convoy),
                            Player#player{convoy_state = ?IF_ELSE(IsTask, 0, NewColor)}
                    end
            end
    end.

check_color(Pkey, Color, Plv, Now, Vip) ->
    case task:get_task_by_type(?TASK_TYPE_CONVOY) of
        [] ->
            {Color, true};
        [Task | _] ->
            if Task#task.accept_time + ?TASK_CONVOY_TIMEOUT < Now ->
                task:del_task_by_type(?TASK_TYPE_CONVOY),
                GoodsList = get_finish_reward(timeout, Color, Plv, Vip),
                mail:sys_send_mail([Pkey], ?T("美女护送超时"), ?T("您护送的美女超时,奖励请查收!"), GoodsList),
                {?COLOR_GREEN, true};
                true ->
                    Ref = erlang:send_after((Task#task.accept_time + ?TASK_CONVOY_TIMEOUT - Now) * 1000, self(), convoy_timeout),
                    put(convoy_timeout, Ref),
                    {Color, false}
            end
    end.

%%玩家离线，回写数据
logout() ->
    Convoy = get_convoy(),
    if Convoy#task_convoy.is_change /= 0 ->
        task_load:update_task_convoy(Convoy);
        true -> skip
    end.

timer_update() ->
    Convoy = get_convoy(),
    if Convoy#task_convoy.is_change /= 0 ->
        task_load:update_task_convoy(Convoy),
        set_convoy(Convoy#task_convoy{is_change = 0});
        true -> skip
    end.

%%零点刷新
midnight_refresh(Player, Now) ->
    Convoy = get_convoy(),
    if Player#player.convoy_state > 0 ->
        NewConvoy = Convoy#task_convoy{times = 1, rob_times = 0, help_times = 0, time = Now, extra_times = 0, is_change = 1};
        true ->
            NewConvoy = Convoy#task_convoy{times = 0, rob_times = 0, help_times = 0, time = Now, is_change = 1}
    end,
    set_convoy(NewConvoy),
    if NewConvoy#task_convoy.times == 0 andalso Player#player.convoy_state == 0 ->
        [task:refresh_client_new_task(Player#player.sid, Task) || Task <- check_task(Player, NewConvoy)],
        ok;
        true -> skip
    end.

set_convoy(Convoy) ->
    lib_dict:put(?PROC_STATUS_CONVOY, Convoy).

get_convoy() ->
    lib_dict:get(?PROC_STATUS_CONVOY).


%%获取护送任务基础信息
convoy_task(Player) ->
    Convoy = get_convoy(),
    TaskList = check_task(Player, Convoy),
    TaskList.

check_task(Player, Convoy) ->
    MaxTimes = ?TASK_CONVOY_TIMES(Player#player.vip_lv) + Convoy#task_convoy.extra_times,
    if Player#player.convoy_state > 0 orelse Convoy#task_convoy.times >= MaxTimes -> [];
        true ->
            F = fun(Tid) ->
                case task_init:task_data(Tid, ?TASK_TYPE_CONVOY) of
                    [] -> [];
                    Task ->
                        case lists:keyfind(lv, 1, Task#task.accept) of
                            false ->
                                [];
                            {_, Lv} ->
                                if Player#player.lv >= Lv ->
                                    [Task#task{state = ?TASK_ST_ACTIVE}];
                                    true ->
                                        []
                                end
                        end
                end
                end,
            lists:flatmap(F, data_task_convoy:task_ids())
    end.

task_lv() ->
    F = fun(Tid) ->
        case task_init:task_data(Tid, ?TASK_TYPE_CONVOY) of
            [] -> [];
            Task ->
                case lists:keyfind(lv, 1, Task#task.accept) of
                    false ->
                        [];
                    {_, Lv} ->
                        [Lv]
                end
        end
        end,
    case lists:flatmap(F, data_task_convoy:task_ids()) of
        [] -> 0;
        List -> hd(List)
    end.

%%护送信息
convoy_info(Player) ->
    Convoy = get_convoy(),
    Mult = convoy_proc:convoy_reward(),
    MaxTimes = ?TASK_CONVOY_TIMES(Player#player.vip_lv) + Convoy#task_convoy.extra_times,
    Times = max(0, MaxTimes - Convoy#task_convoy.times),
    IsDouble = ?IF_ELSE(Mult == 1, 0, 1),
    Goods = get_finish_reward(normal, Convoy#task_convoy.color, Player#player.lv, Player#player.vip_lv),
    {Convoy#task_convoy.color, Times, IsDouble, ?TASK_CONVOY_TIMEOUT, goods:pack_goods(Goods)}.


%%开始护送
start_convoy(Player) ->
    Convoy = get_convoy(),
    Color = Convoy#task_convoy.color,
    MaxTimes = ?TASK_CONVOY_TIMES(Player#player.vip_lv) + Convoy#task_convoy.extra_times,
    if Convoy#task_convoy.times >= MaxTimes ->
        {20, Player};
        Player#player.convoy_state > 0 ->
            {21, Player};
        Player#player.match_state > 0 ->
            {0, Player};
        true ->
            Now = util:unixtime(),
            case accept_task(Player) of
                false -> {23, Player};
                pos_fail -> {29, Player};
                lv_fail -> {5, Player};
                true ->
                    NewConvoy = Convoy#task_convoy{
                        times = Convoy#task_convoy.times + 1,
                        times_total = Convoy#task_convoy.times_total + 1,
                        color = Color,
                        godt = 0,
                        help_list = [],
                        is_change = 1
                    },
                    set_convoy(NewConvoy),
                    activity:get_notice(Player, [59], true),
%%                    if Color >= 4 andalso NewConvoy#task_convoy.times_total > 1 ->
%%                        notice_sys:add_notice(convoy_get, [Player]);
%%                        true -> skip
%%                    end,
                    task_load:log_convoy(Player#player.key, Player#player.nickname, Color, Now),
                    %%切换成PK模式
                    Player1 = ?IF_ELSE(Player#player.lv =< 50, Player, player_battle:pk_change_sys(Player, ?PK_TYPE_FIGHT, 0)),
                    BGold = case version:get_lan_config() of
                                bt -> 1200;
                                _ -> 60
                            end,
                    Player2 = ?IF_ELSE(Color >= ?COLOR_ORANGE, money:add_bind_gold(Player1, BGold, 57, 0, 0), Player1),
                    misc:cancel_timer(convoy_timeout),
                    Ref = erlang:send_after(?TASK_CONVOY_TIMEOUT * 1000, self(), convoy_timeout),
                    put(convoy_timeout, Ref),
                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4012, Color, 1),
                    sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_CONVOY),
                    {1, Player2#player{convoy_state = Color}}
            end
    end.

accept_task(Player) ->
    case data_task_convoy:task_ids() of
        [] -> false;
        Ids ->
            TaskId = hd(Ids),
            case task_init:task_data(TaskId, ?TASK_TYPE_CONVOY) of
                [] -> false;
                Task ->
                    case lists:keyfind(lv, 1, Task#task.accept) of
                        false -> lv_fail;
                        {lv, Lv} ->
                            if Player#player.lv < Lv -> lv_fail;
                                true ->
                                    case check_npc_position(Task#task.remote, Task#task.npcid, Player#player.scene, Player#player.x, Player#player.y) of
                                        true ->
                                            task:refresh_client_del_task(Player#player.sid, TaskId),
                                            task:accept_special_task(Player#player.sid, Task, true),
                                            true;
                                        false ->
                                            pos_fail
                                    end
                            end
                    end
            end
    end.


%%检查位置
check_npc_position(PosType, NpcId, TarScene, TarX, TarY) ->
    if PosType /= 0 -> true;
        true ->
            case data_npc_transport:get(NpcId) of
                [] -> true;
                [Sid, X, Y] ->
                    TarScene == Sid andalso abs(TarX - X) =< 3 andalso abs(TarY - Y) =< 3
            end
    end.

%%护送奖励列表
convoy_goods(Player) ->
    Convoy = get_convoy(),
    get_finish_reward(normal, Convoy, Player#player.lv, Player#player.vip_lv).

get_finish_reward(Type, Color, Plv, Vip) ->
    GoodsList =
        case Type of
            normal ->
                get_base_reward(Color, Plv);
            rob ->
                get_rob_reward(Color, Plv);
            be_rob ->
                get_be_rob_reward(Color, Plv);
            timeout ->
                get_timeout_reward(Color, Plv)
        end,
    Mult = convoy_proc:convoy_reward(),
    VipMult =
        case data_vip_args:get(56, Vip) of
            [] -> 0;
            Val -> Val
        end,
    F = fun({GoodsId, Num}) -> {GoodsId, round(Num * Mult * (1 + VipMult / 100))} end,
    lists:map(F, GoodsList).

%%护送奖励
finish_convoy(Player) ->
    misc:cancel_timer(convoy_timeout),
    Player1 = Player#player{convoy_state = 0},
    %%恢复PK
    Player2 = player_battle:pk_change(Player1, Player1#player.pk#pk.pk_old, 0),
    Player3 = player_util:count_player_speed(Player2, true),
    NewPlayer = buff:del_buff(Player3, ?GOD_BUFF_ID),
    scene_agent_dispatch:convoy(NewPlayer),

    Convoy = get_convoy(),
    NewConvoy = Convoy#task_convoy{color = ?COLOR_GREEN, is_change = 1},
    set_convoy(NewConvoy),
    refresh_task(NewPlayer, NewConvoy),
    check_help_reward(Convoy#task_convoy.help_list),
    GoodsList = get_finish_reward(normal, Convoy#task_convoy.color, Player#player.lv, Player#player.vip_lv),
    MaxTimes = ?TASK_CONVOY_TIMES(Player#player.vip_lv) + Convoy#task_convoy.extra_times,
    convoy_ret(Player, 1, max(0, MaxTimes - Convoy#task_convoy.times), GoodsList),
    ?DO_IF(Player#player.convoy_state == ?MAX_COLOR, act_convoy:add_convoy(Player)),
    goods:give_goods(NewPlayer, goods:make_give_goods_list(57, GoodsList)).

check_help_reward(HelpList) ->
    F = fun(Key) ->
        case ets:lookup(?ETS_ONLINE, Key) of
            [] -> ok;
            [OnLine] -> OnLine#ets_online.pid ! convoy_help_reward
        end
        end,
    lists:foreach(F, HelpList).

convoy_help_reward(Player) ->
    Convoy = get_convoy(),
    if Convoy#task_convoy.help_times >= ?TASK_CONVOY_HELP_TIMES -> Player;
        true ->
            NewConvoy = Convoy#task_convoy{help_times = Convoy#task_convoy.help_times + 1, is_change = 1},
            set_convoy(NewConvoy),
            GoodsList = get_help_reward(Player#player.lv),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(57, GoodsList)),
            NewPlayer
    end.


refresh_task(Player, Convoy) ->
    TaskList = check_task(Player, Convoy),
    case TaskList of
        [] -> skip;
        _ ->
            MaxTimes = ?TASK_CONVOY_TIMES(Player#player.vip_lv) + Convoy#task_convoy.extra_times,
            Times = max(0, MaxTimes - Convoy#task_convoy.times),
            {ok, Bin} = pt_300:write(30026, {Times}),
            server_send:send_to_sid(Player#player.sid, Bin),
            F = fun(Task) ->
                spawn(fun() ->
                    util:sleep(1000),
                    task:refresh_client_new_task(Player#player.sid, Task) end)
                end,
            [F(Task) || Task <- TaskList]
    end.

get_base_reward(Color, Lv) ->
    Base = data_convoy_reward:get(Lv),
    case Color of
        1 ->
            Base#base_convoy_reward.color1;
        2 ->
            Base#base_convoy_reward.color2;
        3 ->
            Base#base_convoy_reward.color3;
        4 ->
            Base#base_convoy_reward.color4;
        _ -> []
    end.

get_timeout_reward(Color, Lv) ->
    Base = data_convoy_reward:get(Lv),
    case Color of
        1 ->
            Base#base_convoy_reward.color1_timeout;
        2 ->
            Base#base_convoy_reward.color2_timeout;
        3 ->
            Base#base_convoy_reward.color3_timeout;
        4 ->
            Base#base_convoy_reward.color4_timeout;
        _ -> []
    end.

get_be_rob_reward(Color, Lv) ->
    Base = data_convoy_reward:get(Lv),
    case Color of
        1 ->
            Base#base_convoy_reward.color1_be_rob;
        2 ->
            Base#base_convoy_reward.color2_be_rob;
        3 ->
            Base#base_convoy_reward.color3_be_rob;
        4 ->
            Base#base_convoy_reward.color4_be_rob;
        _ -> []
    end.

get_rob_reward(Color, Lv) ->
    Base = data_convoy_reward:get(Lv),
    case Color of
        1 -> Base#base_convoy_reward.color1_rob;
        2 -> Base#base_convoy_reward.color2_rob;
        3 -> Base#base_convoy_reward.color3_rob;
        4 -> Base#base_convoy_reward.color4_rob;
        _ -> []
    end.

get_help_reward(Lv) ->
    data_convoy_help:get(Lv).


%%获取今日抢劫次数
get_rob_times() ->
    Convoy = get_convoy(),
    Convoy#task_convoy.rob_times.

%%玩家护送中死亡
convoy_die(Player, Attacker) ->
    if Player#player.convoy_state == 0 ->
        Player;
        true ->
            Convoy = get_convoy(),
            IsCross = Attacker#attacker.node /= none andalso Attacker#attacker.node =/= node(),
            rob_success(Player, Attacker, Convoy, IsCross)
    end.

%%劫镖成功
rob_success(Player, Attacker, Convoy, IsCross) ->
    misc:cancel_timer(convoy_timeout),
    RobGoodsList = get_finish_reward(rob, Convoy#task_convoy.color, Player#player.lv, Player#player.vip_lv),
    case IsCross of
        false ->
            Attacker#attacker.pid ! {convoy_rob_reward, RobGoodsList, Player#player.nickname};
        true ->
            cross_area:apply(task_convoy, convoy_reward2kf, [Attacker#attacker.node, Attacker#attacker.pid, {convoy_rob_reward, RobGoodsList, Player#player.nickname}])
    end,
    rob_msg(Player, Attacker, IsCross),
    %%删除任务
    task:del_task_by_type(?TASK_TYPE_CONVOY, Player#player.sid),
    FinishGoodsList = get_finish_reward(be_rob, Convoy#task_convoy.color, Player#player.lv, Player#player.vip_lv),
    {ok, Player1} = goods:give_goods(Player, goods:make_give_goods_list(57, FinishGoodsList)),

    MaxTimes = ?TASK_CONVOY_TIMES(Player#player.vip_lv) + Convoy#task_convoy.extra_times,
    convoy_ret(Player, 3, max(0, MaxTimes - Convoy#task_convoy.times), FinishGoodsList),

    NewConvoy = Convoy#task_convoy{color = ?COLOR_GREEN, is_change = 1},
    set_convoy(NewConvoy),
    Player2 = Player1#player{convoy_state = 0},
    %%恢复PK
    Player3 = player_battle:pk_change(Player2, Player2#player.pk#pk.pk_old, 0),
    Player4 = player_util:count_player_speed(Player3, true),
    scene_agent_dispatch:convoy(Player4),
    refresh_task(Player4, NewConvoy),
    Player5 = buff:del_buff(Player4, ?GOD_BUFF_ID),
    Player5.

%%护送超时
convoy_timeout(Player) ->
    if Player#player.convoy_state == 0 -> Player;
        true ->
            Convoy = get_convoy(),
            misc:cancel_timer(convoy_timeout),
            %%删除任务
            task:del_task_by_type(?TASK_TYPE_CONVOY, Player#player.sid),
            FinishGoodsList = get_finish_reward(timeout, Convoy#task_convoy.color, Player#player.lv, Player#player.vip_lv),
            {ok, Player1} = goods:give_goods(Player, goods:make_give_goods_list(57, FinishGoodsList)),
            MaxTimes = ?TASK_CONVOY_TIMES(Player#player.vip_lv) + Convoy#task_convoy.extra_times,
            convoy_ret(Player, 2, max(0, MaxTimes - Convoy#task_convoy.times), FinishGoodsList),
            NewConvoy = Convoy#task_convoy{color = ?COLOR_GREEN, is_change = 1},
            set_convoy(NewConvoy),
            Player2 = Player1#player{convoy_state = 0},
            %%恢复PK
            Player3 = player_battle:pk_change(Player2, Player2#player.pk#pk.pk_old, 0),
            scene_agent_dispatch:convoy(Player3),
            refresh_task(Player3, NewConvoy),
            Player4 = buff:del_buff(Player3, ?GOD_BUFF_ID),
            Player5 = player_util:count_player_speed(Player4, true),
            Player5
    end.

%%抢劫信息
rob_msg(Player, Attacker, IsCross) ->
    case IsCross of
        false ->
            notice_sys:add_notice(convoy_rob, [Player, #player{nickname = Attacker#attacker.name, key = Attacker#attacker.key, vip_lv = Attacker#attacker.vip}]);
        true ->
            cross_area:apply(task_convoy, convoy_msg2kf, [Player, #player{nickname = Attacker#attacker.name, key = Attacker#attacker.key, vip_lv = Attacker#attacker.vip}])
    end.

%%护送抢劫奖励
convoy_rob_reward(Player, GoodsList, _Nickname) ->
    Convoy = get_convoy(),
    if Convoy#task_convoy.rob_times >= ?TASK_CONVOY_ROB_TIMES -> Player;
        true ->
            NewConvoy = Convoy#task_convoy{rob_times = Convoy#task_convoy.rob_times + 1, is_change = 1},
            set_convoy(NewConvoy),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(34, GoodsList)),
            scene_agent_dispatch:convoy_rob(Player, NewConvoy#task_convoy.rob_times),
            {ok, Bin} = pt_300:write(30029, {_Nickname, goods:pack_goods(GoodsList)}),
            server_send:send_to_sid(Player#player.sid, Bin),
            NewPlayer
    end.

convoy_msg2kf(P1, P2) ->
    F = fun(Node) ->
        center:apply(Node, notice_sys, add_notice, [convoy_rob, [P1, P2]])
        end,
    lists:foreach(F, center:get_nodes()).

convoy_bin2kf(Node, Pid, Bin) ->
    center:apply(Node, server_send, send_to_pid, [Pid, Bin]).
convoy_reward2kf(Node, Pid, Msg) ->
    server_send:send_node_pid(Node, Pid, Msg).


%%刷新品质
refresh_color(Player, Color, Auto) ->
    Convoy = get_convoy(),
    MaxTimes = ?TASK_CONVOY_TIMES(Player#player.vip_lv) + Convoy#task_convoy.extra_times,
    if Player#player.convoy_state > 0 ->
        {31, Convoy#task_convoy.color, Player};
        Convoy#task_convoy.color >= ?COLOR_ORANGE ->
            {32, Convoy#task_convoy.color, Player};
        Color > 0 andalso Convoy#task_convoy.color >= Color ->
            {33, Convoy#task_convoy.color, Player};
        Convoy#task_convoy.times >= MaxTimes ->
            {20, Convoy#task_convoy.color, Player};
        true ->
            color_refresh(Color, Auto, Player, Convoy, 0)
    end.

color_refresh(0, Auto, Player, Convoy, _Times) ->
    case refresh_once(Player, Convoy#task_convoy.color, Auto) of
        {ok, NewPlayer} ->
            NewConvoy = Convoy#task_convoy{color = Convoy#task_convoy.color + 1, is_change = 1},
            set_convoy(NewConvoy),
            {1, NewConvoy#task_convoy.color, NewPlayer};
        {false, Err} ->
            {Err, Convoy#task_convoy.color, Player}

    end;
color_refresh(Color, Auto, Player, Convoy, Times) ->
    case refresh_once(Player, Convoy#task_convoy.color, Auto) of
        {ok, NewPlayer} ->
            NewColor = Convoy#task_convoy.color + 1,
            NewConvoy = Convoy#task_convoy{color = Convoy#task_convoy.color + 1, is_change = 1},
            set_convoy(NewConvoy),
            if NewColor == Color ->
                {1, NewConvoy#task_convoy.color, NewPlayer};
                true ->
                    color_refresh(Color, Auto, NewPlayer, NewConvoy, Times + 1)
            end;
        {false, Err} ->
            if Times == 0 ->
                {Err, Convoy#task_convoy.color, Player};
                true ->
                    {1, Convoy#task_convoy.color, Player}
            end

    end.

refresh_once(Player, Color, Auto) ->
    [GoodsId, Num] = data_convoy_refresh:get(Color),
    GoodsCount = goods_util:get_goods_count(GoodsId),
    if GoodsCount >= Num ->
        goods:subtract_good(Player, [{GoodsId, Num}], 65),
        {ok, Player};
        Auto == 0 ->
            {false, 44};
        true ->
            NumNeed = Num - GoodsCount,
            case new_shop:auto_buy(Player, GoodsId, NumNeed, 65) of
                {false, 1} -> {false, 45};
                {ok, NewPlayer, _} ->
                    ?DO_IF(GoodsCount > 0, goods:subtract_good(Player, [{GoodsId, GoodsCount}], 65)),
                    {ok, NewPlayer};
                _ ->
                    {false, 30}
            end

    end.


get_notice_state(Player) ->
    case get_convoy() of
        [] -> {0, [{time, 0}]};
        Convoy ->
            MaxTimes = ?TASK_CONVOY_TIMES(Player#player.vip_lv) + Convoy#task_convoy.extra_times,
            LeTimes = MaxTimes - Convoy#task_convoy.times,
            ?IF_ELSE(LeTimes > 0, {1, [{time, LeTimes}]}, {0, [{time, 0}]})
    end.

convoy_msg() ->
    Convoy = get_convoy(),
    IsProtect = ?IF_ELSE(Convoy#task_convoy.godt == 0, 1, 0),
    Time =
        case task:get_task_by_type(?TASK_TYPE_CONVOY) of
            [] ->
                0;
            [Task | _] ->
                max(0, Task#task.accept_time + ?TASK_CONVOY_TIMEOUT - util:unixtime())
        end,
    {Time, IsProtect}.

%%使用保护
use_protect(Player) ->
    if Player#player.convoy_state == 0 -> {25, Player};
        true ->
            Convoy = get_convoy(),
            if Convoy#task_convoy.godt > 0 -> {26, Player};
                true ->
                    Now = util:unixtime(),
                    NewConvoy = Convoy#task_convoy{godt = Now, is_change = 1},
                    set_convoy(NewConvoy),
                    NewPlayer = buff:add_buff_to_player(Player, ?GOD_BUFF_ID),
                    {1, NewPlayer}
            end
    end.

%%护送结果
convoy_ret(Player, Ret, Times, GoodsList) ->
    {ok, Bin} = pt_300:write(30028, {Ret, Times, goods:pack_goods(GoodsList)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%请求帮助
call_for_help(Player) ->
    if Player#player.convoy_state == 0 -> 25;
        Player#player.guild#st_guild.guild_key == 0 -> 43;
        true ->
            notice_sys:add_notice(convoy_help, [Player]),
            49
    end.

%%协助了
helping(Player, Pkey) ->
    if Player#player.convoy_state > 0 -> {27, Player};
        true ->
            case scene:is_normal_scene(Player#player.scene) of
                false -> {47, Player};
                true ->
                    case player_util:get_player(Pkey) of
                        [] -> {46, Player};
                        Role ->
                            if Role#player.convoy_state == 0 -> {48, Player};
                                true ->
                                    NewPlayer = scene_change:change_scene(Player, Role#player.scene, Role#player.copy, Role#player.x, Role#player.y, false),
                                    Role#player.pid ! {convoy_helping, Player#player.key},
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

convoy_helping(Player, Pkey) ->
    if Player#player.convoy_state == 0 -> ok;
        true ->
            Convoy = get_convoy(),
            NewConvoy = Convoy#task_convoy{help_list = [Pkey | lists:delete(Pkey, Convoy#task_convoy.help_list)]},
            set_convoy(NewConvoy)
    end.
