%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 一月 2018 15:21
%%%-------------------------------------------------------------------
-module(elite_boss).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("elite_boss.hrl").
-include("scene.hrl").
-include("dungeon.hrl").

%% API
-export([
    enter_elite_boss/2, %% 进入精英boss副本
    check_enter/3,
    check_quit/2, %% 退出游戏
    center_check_enter/2,
    center_check_quit/2,
    logout/1,

    get_act_into/1, %% 面板信息
    get_cross_act_info/4,
    get_boss_data/3, %% 读取精英boss伤害数据
    center_get_boss_data/3,
    center_get_enter_info/2,
    recv_daily/1 %% 领取每日令牌福利
]).

-export([
    update_boss_klist/4, %% 更新boss击杀数据
    kill_boss/4, %% 击杀boss
    midnight_refresh/0, %% 凌晨数据刷新
    cacl_back/1, %% 计算返还
    get_buy_info/1, %% 玩家购买次数数据
    buy/2 %% 购买金令牌
]).

buy(Player, Num) when Num == 1 ->
    {BuyNum, Price} = get_buy_info(Player),
    case money:is_enough(Player, Num * Price, gold) of
        false ->
            {6, Player};
        true ->
            VipBuyNum = data_vip_args:get(59, Player#player.vip_lv),
            if
                BuyNum >= VipBuyNum -> {7, Player};
                true ->
                    NPlayer = money:add_no_bind_gold(Player, -Num * Price, 758, 0, 0),
                    GiveGoodsList = goods:make_give_goods_list(759, [{7600002, 3}]),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    St = lib_dict:get(?PROC_STATUS_ELITE_BOSS_DUN),
                    NewSt = St#st_dun_elite_boss{buy_num = BuyNum + Num, op_time = util:unixtime()},
                    lib_dict:put(?PROC_STATUS_ELITE_BOSS_DUN, NewSt),
                    dungeon_elite_boss:update_db(NewSt),
                    {1, NewPlayer}
            end
    end;
buy(Player, _) -> {0, Player}.

get_buy_info(_Player) ->
    St = lib_dict:get(?PROC_STATUS_ELITE_BOSS_DUN),
    BuyNum = St#st_dun_elite_boss.buy_num,
    Price = data_elite_boss_goods:get(BuyNum+1),
    {BuyNum, Price}.

cacl_back(State) ->
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    Now = util:unixtime(),
    F = fun(#elite_boss{damage_list = DamageList, scene_id = SceneId, consume = Back}) ->
        F0 = fun(Fdamage) ->
            if
                Fdamage#f_damage.online == 1 ->
                    elite_boss_load:update(Fdamage, SceneId, Back, Now);
                true ->
                    skip
            end
        end,
        lists:map(F0, DamageList)
    end,
    lists:map(F, EliteBossList),
    ok.

midnight_refresh() ->
    case config:is_center_node() of
        false -> ok;
        true ->
            WeekDay = util:get_day_of_week(),
            if
                WeekDay == 1 ->
                    ?CAST(elite_boss_proc:get_server_pid(), midnight_refresh);
                true ->
                    ok
            end
    end.

get_boss_data(SceneId, Pkey, Sid) ->
    case scene:is_elite_boss_scene(SceneId) of
        true ->
            ?CAST(elite_boss_proc:get_server_pid(), {get_boss_data, SceneId, Pkey, Sid});
        false ->
            case scene:is_cross_elite_boss_scene(SceneId) of
                true ->
                    cross_area:apply(?MODULE, center_get_boss_data, [SceneId, Pkey, Sid]);
                false ->
                    skip
            end
    end.

center_get_boss_data(SceneId, Pkey, Sid) ->
    ?CAST(elite_boss_proc:get_server_pid(), {get_boss_data, SceneId, Pkey, Sid}).

get_cross_act_info(SnList, Sid, IsRecv, VipDunIdList) ->
    ?CAST(elite_boss_proc:get_server_pid(), {get_cross_act_info, SnList, Sid, IsRecv, VipDunIdList}),
    ok.

get_act_into(Player) ->
    St = lib_dict:get(?PROC_STATUS_ELITE_BOSS_DUN),
    IsRecv = St#st_dun_elite_boss.is_recv,
    AllDunId =  data_elite_boss_dun:get_all(),
    F = fun(DunId) ->
        #dungeon{mon = Mon} = data_dungeon:get(DunId),
        [{_r, [{Mid, _X, _Y}|_]}|_] = Mon,
        [DunId, Mid]
    end,
    VipDunIdList = lists:map(F, AllDunId),
    ?CAST(elite_boss_proc:get_server_pid(), {get_act_into, Player#player.sid, IsRecv, VipDunIdList}),
    ok.

logout(Player) ->
    check_quit(Player#player.key, Player#player.scene).

enter_elite_boss(Player, SceneId) ->
    WeekDay = util:get_day_of_week(),
    {_, {H, Min, _S}} = erlang:localtime(),
    IsCenterScene = scene:is_cross_elite_boss_scene(SceneId),
    if
        IsCenterScene == true andalso WeekDay == 7 andalso H == 23 andalso Min >= 30 ->
            IsEnter = false;
        true ->
            IsEnter = true
    end,
    case IsEnter of
        false ->
            {ok, Bin} = pt_445:write(44502, {2}),
            server_send:send_to_sid(Player#player.sid, Bin);
        true ->
            #scene{require = Require} = data_scene:get(SceneId),
            IsLvLimit =
                case lists:keyfind(lv, 1, Require) of
                    false ->
                        true;
                    {lv, LvLimit} ->
                        LvLimit =< Player#player.lv
                end,
            if
                IsLvLimit == false ->
                    {ok, Bin} = pt_445:write(44502, {5}),
                    server_send:send_to_sid(Player#player.sid, Bin);
                true ->
                    check_enter(Player,
                        #f_damage{
                            node = Player#player.node,
                            pkey = Player#player.key,
                            sn = Player#player.sn,
                            name = Player#player.nickname,
                            lv = Player#player.lv,
                            gkey = Player#player.guild#st_guild.guild_key,
                            damage = 0,  %%个人伤害
                            damage_ratio = 0,  %%伤害比例
                            cbp = Player#player.cbp,
                            rank = 0,
                            online = 1,
                            sid = Player#player.sid,
                            pid = Player#player.pid
                        }, SceneId)
            end
    end.

check_enter(Player, Mb, SceneId) ->
    case scene:is_elite_boss_scene(SceneId) of
        true ->
            IsEnter = ?CALL(elite_boss_proc:get_server_pid(), {get_enter_info, Mb#f_damage.pkey, SceneId});
        false ->
            IsEnter =
                case scene:is_cross_elite_boss_scene(SceneId) of
                    true -> cross_area:apply_call(?MODULE, center_get_enter_info, [Mb#f_damage.pkey, SceneId]);
                    false -> false
                end
    end,
    case IsEnter of
        1 -> check_enter2(Mb, SceneId);
        0 ->
            #elite_boss{consume = Consume} = data_elite_boss:get_by_scene(SceneId),
            case check_consume(Consume) of
                {true, NewConsume} ->
                    Sql = io_lib:format("insert into log_elite_boss_enter set pkey=~p,scene_id=~p,consume='~s',`time`=~p",
                        [Player#player.key, SceneId, util:term_to_bitstring(NewConsume), util:unixtime()]),
                    log_proc:log(Sql),
                    {ok, _} = goods:subtract_good(Player, NewConsume, 752),
                    check_enter2(Mb, SceneId);
                false ->
                    {ok, Bin} = pt_445:write(44502, {3}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end;
        Code when is_integer(Code) ->
            {ok, Bin} = pt_445:write(44502, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _ ->
            ok
    end.

check_consume([]) ->
    false;
check_consume([{7600001, Num}]) ->
    Count1 = goods_util:get_goods_count(7600001),
    Count2 = goods_util:get_goods_count(7600002),
    if
        Count1+Count2 < Num -> false;
        true ->
            if
                Count1 >= Num -> {true, [{7600001, Num}]};
                Count1 == 0 -> {true, [{7600002, Num}]};
                true -> {true, [{7600001, Count1}, {7600002, Num-Count1}]}
            end
    end.

check_enter2(Mb, SceneId) ->
    case scene:is_elite_boss_scene(SceneId) of
        true ->
            ?CAST(elite_boss_proc:get_server_pid(), {check_enter, Mb, SceneId});
        false ->
            case scene:is_cross_elite_boss_scene(SceneId) of
                true ->
                    cross_area:apply(?MODULE, center_check_enter, [Mb, SceneId]);
                false ->
                    skip
            end
    end.

center_get_enter_info(Pkey, SceneId) ->
    ?CALL(elite_boss_proc:get_server_pid(), {get_enter_info, Pkey, SceneId}).

center_check_enter(Mb, SceneId) ->
    ?CAST(elite_boss_proc:get_server_pid(), {check_enter, Mb, SceneId}).

check_quit(Pkey, SceneId) ->
    case scene:is_elite_boss_scene(SceneId) of
        true ->
            ?CAST(elite_boss_proc:get_server_pid(), {check_quit, Pkey, SceneId});
        false ->
            case scene:is_cross_elite_boss_scene(SceneId) of
                true ->
                    cross_area:apply(?MODULE, center_check_quit, [Pkey, SceneId]);
                false ->
                    skip
            end
    end.

center_check_quit(Mb, SceneId) ->
    ?CAST(elite_boss_proc:get_server_pid(), {check_quit, Mb, SceneId}).

update_boss_klist(Mon, KList, _AttKey, _AttNode) ->
    IsEiliteBossScene = scene:is_elite_boss_scene(Mon#mon.scene),
    IsCrossEiliteBossScene = scene:is_cross_elite_boss_scene(Mon#mon.scene),
    if
        IsEiliteBossScene == false andalso IsCrossEiliteBossScene == false -> skip;
        Mon#mon.hp =< 0 ->
            elite_boss_proc:get_server_pid() ! {update_elite_boss, Mon, KList};
        true ->
            Now = util:unixtime(),
            Key = update_elite_boss_klist,
            case get(Key) of
                undefined ->
                    put(Key, Now),
                    elite_boss_proc:get_server_pid() ! {update_elite_boss, Mon, KList};
                Time ->
                    case Now - Time >= 2 of
                        true ->
                            put(Key, Now),
                            elite_boss_proc:get_server_pid() ! {update_elite_boss, Mon, KList};
                        false -> false
                    end
            end
    end.

%% 击杀boss
kill_boss(Mon, Attacker, _Klist, _TotalHurt) ->
    IsEiliteBossScene = scene:is_elite_boss_scene(Mon#mon.scene),
    IsCrossEiliteBossScene = scene:is_cross_elite_boss_scene(Mon#mon.scene),
    case IsEiliteBossScene == false andalso IsCrossEiliteBossScene == false of
        true -> skip;
        false -> ?CAST(elite_boss_proc:get_server_pid(), {kill_boss, Mon, Attacker, _Klist})
    end.

%% 领取每日令牌福利
recv_daily(Player) ->
    St = lib_dict:get(?PROC_STATUS_ELITE_BOSS_DUN),
    #st_dun_elite_boss{is_recv = IsRecv} = St,
    if
        IsRecv == 1 -> {0, Player};
        true ->
            NewSt = St#st_dun_elite_boss{is_recv = 1, op_time = util:unixtime()},
            lib_dict:put(?PROC_STATUS_ELITE_BOSS_DUN, NewSt),
            dungeon_elite_boss:update_db(NewSt),
            Reward = data_elite_daily_reward:get_daily_reward(),
            GiveGoodsList = goods:make_give_goods_list(753, Reward),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            {1, NewPlayer}
    end.