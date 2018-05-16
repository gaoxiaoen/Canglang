%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 三月 2017 10:06
%%%-------------------------------------------------------------------
-module(manor_war_party).
-author("hxming").
-include("guild.hrl").
-include("manor_war.hrl").
-include("battle.hrl").
-include("common.hrl").
-include("scene.hrl").
%% API
-compile(export_all).

%%登陆检查是否有晚宴开启中
check_party_for_login(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] -> skip;
        [ManorWar] ->
            Now = util:unixtime(),
            if ManorWar#manor_war.party_time < Now -> skip;
                ManorWar#manor_war.party_close_time > Now ->
                    case data_manor_party:get(ManorWar#manor_war.party_scene) of
                        [] -> skip;
                        Base ->
                            {ok, Bin} = pt_402:write(40212, {ManorWar#manor_war.party_scene, Base#base_manor_party.x, Base#base_manor_party.y}),
                            server_send:send_to_sid(Player#player.sid, Bin)
                    end;
                true ->
                    skip
            end
    end.


%%晚宴信息
party_info(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] -> {0, 0, 0, 0, 0, 0, [], [], []};
        [ManorWar] ->
            ExpLim = data_manor_party_exp:get(ManorWar#manor_war.party_lv),
            Now = util:unixtime(),
            OpenState =
                if ManorWar#manor_war.party_time < Now -> 0;%%过期
                    ManorWar#manor_war.party_close_time > Now -> 2;%%进行中
                    true ->
                        case length(ManorWar#manor_war.scene_list) > 0 of
                            false -> 0;
                            true -> 1
                        end
                end,
            SortList = lists:reverse(lists:keysort(#manor_party_mb.gold, ManorWar#manor_war.party_mbs)),
            F = fun(Mb) ->
                [Mb#manor_party_mb.pkey, Mb#manor_party_mb.nickname, Mb#manor_party_mb.gold]
                end,
            ContribList = lists:map(F, SortList),
            SceneList = [SceneId || {SceneId, _} <- ManorWar#manor_war.scene_list],

            ExtraGoodsList =
                case data_manor_party_reward:get(ManorWar#manor_war.party_scene, ManorWar#manor_war.party_lv) of
                    [] -> [];
                    Base -> Base#base_manor_party_reward.extra_reward
                end,
            {OpenState,
                ManorWar#manor_war.party_lv,
                ManorWar#manor_war.party_exp,
                ExpLim,
                ManorWar#manor_war.party_scene,
                ManorWar#manor_war.party_full,
                ContribList,
                SceneList,
                goods:pack_goods(ExtraGoodsList)
            }
    end.

%%开启宴会
open_party(Player, SceneId) ->
    if Player#player.guild#st_guild.guild_key == 0 -> 2;
        Player#player.guild#st_guild.guild_position >= ?GUILD_POSITION_NORMAL -> 9;
        true ->
            case ets:lookup(?ETS_MANOR_WAR, Player#player.guild#st_guild.guild_key) of
                [] -> 10;
                [ManorWar] ->
                    Now = util:unixtime(),
                    if ManorWar#manor_war.scene_list == [] -> 10;
                        ManorWar#manor_war.party_time < Now -> 11;
                        ManorWar#manor_war.party_close_time > Now -> 12;
                        ManorWar#manor_war.party_scene /= 0 -> 13;
                        true ->
                            case lists:keymember(SceneId, 1, ManorWar#manor_war.scene_list) of
                                false -> 14;
                                true ->
                                    Timer = create_party(Player, SceneId, ManorWar#manor_war.gkey, ManorWar#manor_war.name),
                                    NewManorWar = ManorWar#manor_war{
                                        party_scene = SceneId,
                                        party_lv = 1,
                                        party_close_time = Now + ?MANOR_PARTY_TIME,
                                        party_drop_time = Now + Timer,
                                        is_change = 1},
                                    ets:insert(?ETS_MANOR_WAR, NewManorWar),
                                    1
                            end
                    end
            end
    end.

%%创建晚宴
create_party(Player, SceneId, Gkey, Name) ->
    case data_manor_party:get(SceneId) of
        [] -> 0;
        Base ->
            Now = util:unixtime(),
            F = fun({MonId, X, Y}) ->
                %%[MonId, Scene, X, Y, Copy, BroadCast, Args]
                case data_mon:get(MonId) of
                    [] -> ok;
                    Mon ->
                        if Mon#mon.kind == ?MON_KIND_MANOR_PARTY_TABLE ->
                            Name1 = mon_name(Name, 1),
                            mon_agent:create_mon_cast([MonId, SceneId, X, Y, 0, 1, [{guild_key, Gkey}, {mon_name, Name1}, {life, ?MANOR_PARTY_TIME}, {show_time, Now + ?MANOR_PARTY_TIME}]]);
                            true ->
                                mon_agent:create_mon_cast([MonId, SceneId, X, Y, 0, 1, [{guild_key, Gkey}, {life, ?MANOR_PARTY_TIME}]])
                        end
                end
                end,
            lists:foreach(F, Base#base_manor_party.table_list),

            Pids = guild_util:get_guild_member_pids_online(Gkey),
            {ok, Bin} = pt_402:write(40212, {SceneId, Base#base_manor_party.x, Base#base_manor_party.y}),
            [server_send:send_to_pid(Pid, Bin) || Pid <- Pids],
            manor_war_proc:get_server_pid() ! {party_drop, Gkey, Base#base_manor_party.x, Base#base_manor_party.y},
            notice_sys:add_notice(manor_war_party, [Player#player.key, Player#player.nickname, Player#player.vip_lv, SceneId, Base#base_manor_party.x, Base#base_manor_party.y]),
            ?MANOR_WAR_PARTY_DROP_TIME
    end.

cmd_create_party(SceneId) ->
    case data_manor_party:get(SceneId) of
        [] -> ok;
        Base ->
            F = fun({MonId, X, Y}) ->
                %%[MonId, Scene, X, Y, Copy, BroadCast, Args]
                ?DEBUG("x ~p y~p~n", [X, Y]),
                mon_agent:create_mon_cast([MonId, SceneId, X, Y, 0, 1, [{guild_key, 999}, {life, ?MANOR_PARTY_TIME}]]),
                ok
                end,
            lists:foreach(F, Base#base_manor_party.table_list),
            ok
    end,
    ok.

cmd_clean() ->
    F = fun(Sid) ->
        MonList = mon_agent:get_scene_mon_by_kind(Sid, 0, ?MON_KIND_MANOR_PARTY_TABLE) ++ mon_agent:get_scene_mon_by_kind(Sid, 0, ?MON_KIND_MANOR_PARTY_VIEW),
        [monster:stop_broadcast(Mon#mon.pid) || Mon <- MonList]
        end,
    lists:foreach(F, data_manor_war_scene:scene_list()).

mon_name(Name, Lv) ->
    io_lib:format(?T("~s的宴会.~p级"), [Name, Lv]).

%%晚宴贡献
party_contrib(Player, Gold) ->
    case ets:lookup(?ETS_MANOR_WAR, Player#player.guild#st_guild.guild_key) of
        [] -> {15, Player};
        [ManorWar] ->
            Now = util:unixtime(),
            MaxLv = data_manor_party_exp:max_lv(),
            if ManorWar#manor_war.party_close_time == 0 orelse ManorWar#manor_war.party_close_time < Now ->
                {15, Player};
                ManorWar#manor_war.party_lv >= MaxLv ->
                    {17, Player};
                true ->
                    case money:is_enough(Player, Gold, bgold) of
                        false -> {16, Player};
                        true ->
                            NewPlayer = money:add_gold(Player, -Gold, 210, 0, 0),
                            PartyMbs =
                                case lists:keytake(Player#player.key, #manor_party_mb.pkey, ManorWar#manor_war.party_mbs) of
                                    false ->
                                        [#manor_party_mb{pkey = Player#player.key, nickname = Player#player.nickname, gold = Gold} | ManorWar#manor_war.party_mbs];
                                    {value, Mb, T} ->
                                        [Mb#manor_party_mb{gold = Mb#manor_party_mb.gold + Gold} | T]
                                end,
                            ExpAdd = Gold,
                            {PartyLv, PartyExp} = party_exp(ManorWar#manor_war.party_exp, ManorWar#manor_war.party_lv, ExpAdd),
                            NewManorWar = ManorWar#manor_war{party_lv = PartyLv, party_exp = PartyExp, party_mbs = PartyMbs, is_change = 1},
                            ets:insert(?ETS_MANOR_WAR, NewManorWar),
                            update_party_name(ManorWar#manor_war.party_scene, PartyLv, ManorWar#manor_war.party_lv, ManorWar#manor_war.name),
                            {1, NewPlayer}
                    end
            end
    end.


party_exp(Exp, Lv, Add) ->
    ExpLim = data_manor_party_exp:get(Lv),
    NewExp = Exp + Add,
    if NewExp >= ExpLim -> {Lv + 1, NewExp - ExpLim};
        true ->
            {Lv, NewExp}
    end.

%%更新采集物昵称
update_party_name(SceneId, NewLv, OldLv, Name) ->
    if NewLv == OldLv -> ok;
        true ->
            MonList = mon_agent:get_scene_mon_by_kind(SceneId, 0, ?MON_KIND_MANOR_PARTY_TABLE),
            Name1 = mon_name(Name, NewLv),
            [Mon#mon.pid ! {mon_name, Name1} || Mon <- MonList],
            ok
    end.

%%检查采集次数
check_manor_party_table_collect_times(SceneId, Gkey, Pkey) ->
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] -> false;
        [ManorWar] ->
            case lists:keyfind(Pkey, #manor_party_mb.pkey, ManorWar#manor_war.party_mbs) of
                false -> true;
                Mb ->
                    case data_manor_party:get(SceneId) of
                        [] -> false;
                        Base ->
                            Mb#manor_party_mb.collect_times < Base#base_manor_party.collect_times
                    end
            end
    end.

%%晚宴采集奖励
party_collect(Mon, Pkey, Pid, Nickname) ->
    case ets:lookup(?ETS_MANOR_WAR, Mon#mon.guild_key) of
        [] -> ok;
        [ManorWar] ->
            MbList =
                case lists:keytake(Pkey, #manor_party_mb.pkey, ManorWar#manor_war.party_mbs) of
                    false ->
                        [#manor_party_mb{pkey = Pkey, nickname = Nickname, collect_times = 1} | ManorWar#manor_war.party_mbs];
                    {value, Mb, T} ->
                        [Mb#manor_party_mb{collect_times = Mb#manor_party_mb.collect_times + 1} | T]
                end,
            NewManorWar = ManorWar#manor_war{party_mbs = MbList, is_change = 1},
            ets:insert(?ETS_MANOR_WAR, NewManorWar),
            RatioList = [{1, 50}, {5, 30}, {10, 10}],
            Mult = util:list_rand_ratio(RatioList),
            case data_manor_party_reward:get(ManorWar#manor_war.party_scene, ManorWar#manor_war.party_lv) of
                [] -> ok;
                Base ->
                    GoodsList = [{Gid, round(Num * Mult)} || {Gid, Num} <- Base#base_manor_party_reward.collect_reward],
                    Pid ! {manor_party_reward, GoodsList},
                    ok
            end
    end.

%%晚宴奖励
manor_party_reward(Player, GoodsList) ->
    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(211, GoodsList)),
    NewPlayer.


%%晚宴额外掉落
party_drop(Gkey, X, Y) ->
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] ->
            false;
        [ManorWar] ->
            Now = util:unixtime(),
            if ManorWar#manor_war.party_close_time == 0 orelse ManorWar#manor_war.party_close_time < Now ->
                false;
                ManorWar#manor_war.party_full >= 100 ->
                    false;
                true ->
                    case do_party_drop(ManorWar#manor_war.party_scene, X, Y, Gkey, ManorWar#manor_war.party_lv) of
                        false ->
                            NewManorWar = ManorWar#manor_war{party_drop_time = Now + 30},
                            ets:insert(?ETS_MANOR_WAR, NewManorWar),
                            true;
                        true ->
                            NewManorWar = ManorWar#manor_war{party_full = ManorWar#manor_war.party_full + 10, party_drop_time = Now + 30, is_change = 1},
                            ets:insert(?ETS_MANOR_WAR, NewManorWar),
                            true
                    end
            end
    end.

do_party_drop(SceneId, X, Y, Gkey, Lv) ->
    case data_manor_party_reward:get(SceneId, Lv) of
        [] ->
            false;
        Base ->
            GoodsList = Base#base_manor_party_reward.extra_reward,
            ScenePlayerList = scene_agent:get_scene_player_for_manor_war(SceneId, X, Y, Gkey),
            [Pid ! {manor_party_reward, GoodsList} || Pid <- ScenePlayerList],
            true
    end.


%%敬酒
toast(Player, Pkey) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] -> {15, Player};
        [ManorWar] ->
            Now = util:unixtime(),
            if ManorWar#manor_war.party_close_time == 0 orelse ManorWar#manor_war.party_close_time < Now ->
                {15, Player};
                true ->
                    if Player#player.key == Pkey ->
                        Msg = io_lib:format(?T("~s举起酒杯,大吼一声,来,干了"), [Player#player.nickname]),
                        drink_msg(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Player#player.key, Msg),
                        Times = do_drink(ManorWar, Player, Now),
                        NewPlayer = drink_buff(Player, Times),
                        {1, NewPlayer};
                        true ->
                            case player_util:get_player(Pkey) of
                                [] -> {18, Player};
                                Player1 ->
                                    if Player1#player.guild#st_guild.guild_key /= Gkey -> {20, Player};
                                        true ->
                                            Msg = io_lib:format(?T("~s向~s举起了酒杯,先干为敬!"), [Player#player.nickname, Player1#player.nickname]),
                                            drink_msg(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Player#player.key, Msg),
                                            Player1#player.pid ! {drink, Now},
                                            Times = do_drink(ManorWar, Player, Now),
                                            NewPlayer = drink_buff(Player, Times),
                                            {1, NewPlayer}
                                    end
                            end
                    end
            end
    end.

%%敬酒信息
drink_msg(Scene, Copy, X, Y, Key, Msg) ->
    {ok, Bin} = pt_402:write(40217, {Key, Msg}),
    server_send:send_to_scene(Scene, Copy, X, Y, Bin),
    ok.


drink_buff(Player, Times) ->
    if Times == 3 ->
        Msg = io_lib:format(?T("~s揉了揉眼睛好像眼睛喝醉了!"), [Player#player.nickname]),
        drink_msg(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Player#player.key, Msg);
        Times == 5 ->
            Msg = io_lib:format(?T("~s已经酩酊大醉了,快去扶他一把!"), [Player#player.nickname]),
            drink_msg(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Player#player.key, Msg);
        Times == 7 ->
            Msg = io_lib:format(?T("~s喝得不省人事,大家不要再灌他了!"), [Player#player.nickname]),
            drink_msg(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Player#player.key, Msg);
        true ->
            ok
    end,
    case data_manor_party_drink:get(Times) of
        [] -> Player;
        BuffId ->
            buff:add_buff_to_player(Player, BuffId)
    end.

%%喝酒
drink(Player, Now) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] -> Player;
        [ManorWar] ->
            Times = do_drink(ManorWar, Player, Now),
            NewPlayer = drink_buff(Player, Times),
            NewPlayer
    end.

do_drink(ManorWar, Player, Now) ->
    {MbList, Times} =
        case lists:keytake(Player#player.key, #manor_party_mb.pkey, ManorWar#manor_war.party_mbs) of
            false ->
                {[#manor_party_mb{pkey = Player#player.key, nickname = Player#player.nickname, drink_times = 1, drink_time = Now} | ManorWar#manor_war.party_mbs], 1};
            {value, Mb, T} ->
                if
                    Now - Mb#manor_party_mb.drink_time > 16 ->
                        {[Mb#manor_party_mb{drink_times = 1, drink_time = Now} | T], 1};
                    true ->
                        DrinkTimes = Mb#manor_party_mb.drink_times + 1,
                        {[Mb#manor_party_mb{drink_times = DrinkTimes, drink_time = Now} | T], DrinkTimes}
                end
        end,
    NewManorWar = ManorWar#manor_war{party_mbs = MbList},
    ets:insert(?ETS_MANOR_WAR, NewManorWar),
    Times.

%%摇塞子
ratio_points(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] -> 15;
        [ManorWar] ->
            Now = util:unixtime(),
            if ManorWar#manor_war.party_close_time == 0 orelse ManorWar#manor_war.party_close_time < Now -> 15;
                ManorWar#manor_war.party_scene /= Player#player.scene -> 20;
                true ->
                    F = fun(_) -> util:rand(1, 6) end,
                    Points = lists:map(F, lists:seq(1, 3)),
                    IsSame = ?IF_ELSE(util:list_filter_repeat(Points) == 1, 1, 0),
                    {ok, Bin} = pt_402:write(40216, {Player#player.key, IsSame, Points}),
                    server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
                    1
            end
    end.
