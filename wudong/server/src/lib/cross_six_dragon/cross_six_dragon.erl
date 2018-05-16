%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 二月 2017 下午2:25
%%%-------------------------------------------------------------------
-module(cross_six_dragon).
-author("fengzhenlin").
-include("common.hrl").
-include("cross_six_dragon.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("achieve.hrl").
%% API
-compile(export_all).

check_open_time(Now) ->
    WeekDay = util:get_day_of_week(Now),
    OpenList = data_six_dragon_time:get_all(),
    case lists:keyfind(WeekDay, 1, OpenList) of
        false -> skip;
        {_, {H1, M1}, Long, NoticeTime} ->
            Date = util:unixdate(Now),
            OpenTime = Date + H1 * 3600 + M1 * 60,
            NowMin = Now - Now rem 60,
            if
                OpenTime == NowMin + NoticeTime ->
                    %%即将开启
                    cross_six_dragon_proc:rpc_ready_open(OpenTime);
                OpenTime == NowMin ->
                    %%开启
                    cross_six_dragon_proc:rpc_open_six_dragon(Long);
                true ->
                    skip
            end
    end.

%%玩家下线
logout(Player) ->
    leave_wait_scene(Player, Player#player.scene),
    exit_six_dragon_battle(Player),
    ok.

%%更新ets操作
get_ets_kf_player(Pkey) ->
    case ets:lookup(?ETS_SIX_DRAGON_PLAYER, Pkey) of
        [] -> [];
        [P | _] -> P
    end.

update_ets_kf_player(P) ->
    ets:insert(?ETS_SIX_DRAGON_PLAYER, P).

get_ets_team(Copy) ->
    case ets:lookup(?ETS_SIX_DRAGON_TEAM, Copy) of
        [] -> [];
        [Team | _] -> Team
    end.

update_ets_team(Team) ->
    ets:insert(?ETS_SIX_DRAGON_TEAM, Team).

del_ets_team(Copy) ->
    ets:delete(?ETS_SIX_DRAGON_TEAM, Copy).

%%获取活动状态
get_state(Node, Sid) ->
    ?CAST(cross_six_dragon_proc:get_server_pid(), {get_state, Node, Sid}).

%%申请匹配
apply_match(Player) ->
    Res =
        if
            Player#player.scene =/= ?SCENE_ID_SIX_DRAGON -> {false, 3};
            true ->
                ok
        end,
    case Res of
        {false, Reason} ->
            {ok, Bin} = pt_581:write(58103, {Reason}),
            server_send:send_to_sid(Player#player.sid, Bin);
        ok ->
            %%玩法找回
            findback_src:fb_trigger_src(Player, 32, 1),
            SdPlayer = player_to_sd_player(Player),
            cross_area:apply(cross_six_dragon, apply_match_1, [SdPlayer])
    end,
    ok.
apply_match_1(SdPlayer) ->
    ?CAST(cross_six_dragon_proc:get_server_pid(), {apply_match, SdPlayer}),
    ok.

player_to_sd_player(Player) ->
    #sd_player{
        pkey = Player#player.key
        , sn = Player#player.sn_cur
        , pf = Player#player.pf
        , node = Player#player.node
        , name = Player#player.nickname
        , lv = Player#player.lv
        , cbp = Player#player.cbp
        , sid = Player#player.sid
        , sex = Player#player.sex
        , career = Player#player.career
        , avatar = Player#player.avatar
    }.

%%取消匹配
cancel_match(Pkey, Sid, Node) ->
    ?CAST(cross_six_dragon_proc:get_server_pid(), {cancel_match, Pkey, Sid, Node}),
    ok.

%%获取玩家个人比赛信息
get_fight_info(Pkey, Sid, Node) ->
    ?CAST(cross_six_dragon_proc:get_server_pid(), {get_fight_info, Pkey, Sid, Node}),
    ok.

%%获取当前比赛信息
get_fight_target(Pkey, Sid, Node) ->
    ?CAST(cross_six_dragon_proc:get_server_pid(), {get_fight_target, Pkey, Sid, Node}),
    ok.

%%退出战斗场景
exit_six_dragon_battle(Player) ->
    if
        Player#player.scene =/= ?SCENE_ID_SIX_DRAGON_FIGHT -> {false, 3};
        true ->
            sendout_scene(Player#player.key),
            cross_area:apply(cross_six_dragon, exit_six_dragon_battle_1, [Player#player.key]),
            NewPlayer = buff:del_buff_list(Player, [?SIX_DRAGON_BUFF_1, ?SIX_DRAGON_BUFF_2], 1),
            {ok, NewPlayer}
    end.
exit_six_dragon_battle_1(Pkey) ->
    ?CAST(cross_six_dragon_proc:get_server_pid(), {exit_six_dragon_battle, Pkey}),
    ok.

%%获取积分排行
get_point_rank(Pkey, Sid, Sn, Node) ->
    ?CAST(cross_six_dragon_proc:get_server_pid(), {get_point_rank, Pkey, Sid, Sn, Node}),
    ok.

%%查看积分奖励
get_rank_gift(Player) ->
    All = data_six_dragon_rank_reward:get_all(),
    F = fun(Rank) ->
        {St, Et, GoodsList} = data_six_dragon_rank_reward:get(Rank),
        [St, Et, util:list_tuple_to_list(GoodsList)]
        end,
    L = lists:map(F, All),
    {ok, Bin} = pt_581:write(58109, {L}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%退出等待场景
leave_wait_scene(Player, Scene) ->
    case Scene == ?SCENE_ID_SIX_DRAGON of
        true ->
            cross_area:apply(cross_six_dragon, cancel_match, [Player#player.key, Player#player.sid, Player#player.node]),
            ok;
        false ->
            skip
    end.

%%传送玩家进战斗场景
send_player_to_scene(Pkey, Copy, Group) ->
    case player_util:get_player_online(Pkey) of
        [] -> skip;
        Online ->
            {X, Y} = get_fight_scene_xy(Group),
            Online#ets_online.pid ! {enter_dungeon_scene, ?SCENE_ID_SIX_DRAGON_FIGHT, Copy, X, Y, Group},
            case Group of
                1 -> %%2人组
                    erlang:send_after(4000, Online#ets_online.pid, {buff, ?SIX_DRAGON_BUFF_1});
                _ -> %%4人组
                    erlang:send_after(4000, Online#ets_online.pid, {buff, ?SIX_DRAGON_BUFF_2})
            end
    end,
    ok.

%%获取战斗场景出生区
get_fight_scene_xy(Group) ->
    case Group == 1 of
        true -> hd(?FIGHT_SCENE_XY);
        false -> lists:last(?FIGHT_SCENE_XY)
    end.

%%传送玩家到等待场景
sendout_scene(Pkey) ->
    case player_util:get_player_online(Pkey) of
        [] -> skip;
        Online ->
            {X, Y} = get_wait_scene_xy(),
            Copy = scene_copy_proc:get_scene_copy(?SCENE_ID_SIX_DRAGON, 0),
            Online#ets_online.pid ! {enter_dungeon_scene, ?SCENE_ID_SIX_DRAGON, Copy, X, Y, 0},
            erlang:send_after(3000, Online#ets_online.pid, {del_buff, [?SIX_DRAGON_BUFF_1, ?SIX_DRAGON_BUFF_2]})
    end,
    ok.


%%传送所有玩家到主场景
sendout_scene_to_main(Pkey) ->
    case player_util:get_player_online(Pkey) of
        [] -> skip;
        Online ->
            Online#ets_online.pid ! change_scene_back
    end,
    ok.

%%玩家死亡
role_die(Copy, Pkey, KillerKey) ->
    cross_area:apply(cross_six_dragon, role_die_1, [Copy, Pkey, KillerKey]),
    ok.
role_die_1(Copy, Pkey, KillerKey) ->
    ?CAST(cross_six_dragon_proc:get_server_pid(), {role_die, Copy, Pkey, KillerKey}),
    ok.

%%单场战斗奖励
copy_reward(Pkey, IsMyWin, GoodsList) ->
    ?DO_IF(IsMyWin, achieve:trigger_achieve(Pkey, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3018, 0, 1)),
    case player_util:get_player_online(Pkey) of
        [] -> skip;
        Online ->
            Online#ets_online.pid ! {apply_state, {cross_six_dragon, copy_reward_1, GoodsList}}
    end.
copy_reward_1(GoodsList, Player) ->
    GoodsList1 = goods:make_give_goods_list(506, GoodsList),
    {ok, NewPlayer} = goods:give_goods(Player, GoodsList1),
    log_proc:log(io_lib:format("insert into log_cross_six_dragon_one_fight set pkey=~p,sn=~p,goods='~s',fight_times=~p,point=~p,time=~p",
        [Player#player.key, Player#player.sn, util:term_to_bitstring(GoodsList), 0, 0, util:unixtime()])),
    {ok, NewPlayer}.

%%积分排名奖励
point_rank_reward(RankList) ->
    point_rank_reward_1(RankList).
point_rank_reward_1([]) -> ok;
point_rank_reward_1([{Order, Pkey, _Name, Sn1, _Ftimes, Point} | Tail]) ->
    achieve:trigger_achieve(Pkey, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3019, 0, Order),
    GoodsList0 = data_six_dragon_rank_reward:get(Order),
    case GoodsList0 of
        [] -> skip;
        {_, _, GoodsList} ->
            Title = ?T("六龙争霸排名奖励"),
            Content = io_lib:format(?T("您在本次六龙争霸活动中，积分排行第~p名，这是您的排名奖励，请注意查收！"), [Order]),
            mail:sys_send_mail([Pkey], Title, Content, GoodsList),
            log_proc:log(io_lib:format("insert into log_cross_six_dragon set pkey=~p,sn=~p,goods='~s',rank=~p,point=~p,time=~p",
                [Pkey, Sn1, util:term_to_bitstring(GoodsList), Order, Point, util:unixtime()])),
            ok
    end,
    case Order of
        1 -> %%第一名称号奖励
            designation_proc:add_des(10020, [Pkey]);
        _ ->
            skip
    end,
    point_rank_reward_1(Tail).

%%检查进入六龙争霸等待场景
check_enter_six_dragon_wait_scene(_Player) ->
    get_wait_scene_xy().

%%后去进入等待场景xy
get_wait_scene_xy() ->
    L = [{8, 27}, {28, 27}, {18, 18}, {18, 37}, {18, 27}, {11, 20}, {24, 20}, {11, 34}, {25, 34}],
    util:list_rand(L).

%%gm 所有玩家报名
gm_all_match([], Player) ->
    cross_six_dragon_rpc:handle(58103, Player#player{scene = ?SCENE_ID_SIX_DRAGON}, []),
    ok.