%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 六月 2016 10:48
%%%-------------------------------------------------------------------
-module(cross_arena_rpc).
-author("hxming").
-include("server.hrl").
-include("common.hrl").
-include("cross_arena.hrl").

%% API
-export([handle/3]).

%%获取竞技场信息
handle(23101, Player, _) ->
    if Player#player.lv < ?CROSS_ARENA_LV -> ok;
        true ->
            Arena = cross_arena:make_arena(Player, true),
            IsScoreReward = arena_score:check_score_reward(),
            cross_area:apply(cross_arena, check_arena, [node(), Player#player.sid, Arena, IsScoreReward]),
            ok
    end;

%%刷新我的可挑战对手
handle(23102, Player, _) ->
    if Player#player.lv < ?CROSS_ARENA_LV -> ok;
        true ->
            cross_area:apply(cross_arena, check_refresh, [node(), Player#player.sid, Player#player.key]),
            ok
    end;

%%购买竞技场次数
handle(23103, Player, _) ->
    {Ret, Times, HadBuy, Gold} = cross_arena:buy_times(Player),
    {ok, Bin} = pt_231:write(23103, {Ret, Times, HadBuy}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        NewPlayer = money:add_no_bind_gold(Player, -Gold, 13, 0, 0),
        {ok, NewPlayer};
        true -> ok
    end;

%%竞技场挑战
handle(23104, Player, {Pkey}) ->
    IsNormalScene = scene:is_normal_scene(Player#player.scene),
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    Now = util:unixtime(),
    Ret =
        if
            Player#player.key == Pkey -> 11;
            Mb#cross_arena_mb.times =< 0 -> 6;
            Player#player.convoy_state > 0 -> 14;
            Player#player.marry#marry.cruise_state > 0 -> 23;
            Player#player.match_state > 0 -> 22;
            IsNormalScene == false -> 15;
            Mb#cross_arena_mb.in_cd == 1 andalso Mb#cross_arena_mb.cd > Now -> 10;
            true ->
                Arena = cross_arena:make_arena(Player, true),
                cross_area:apply(cross_arena, check_challenge, [node(), Player, Arena, Pkey]),
                ok
        end,
    case Ret of
        ok -> ok;
        Ret ->
            {ok, Bin} = pt_231:write(23104, {Ret, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%%%获取积分奖励列表
%%handle(23106, Player, _) ->
%%    cross_area:apply(cross_arena_proc, get_score_reward_list, [node(), Player#player.key, Player#player.sid]),
%%    ok;
%%
%%%%领取奖励
%%handle(23107, Player, {Score}) ->
%%    cross_area:apply(cross_arena_proc, score_reward, [node(), Player#player.key, Player#player.pid, Score]),
%%    ok;

%%清除竞技场CD
handle(23108, Player, _) ->
    {Ret, NewPlayer} = cross_arena:clean_cd(Player),
    activity:get_notice(Player, [107], true),
    {ok, Bin} = pt_231:write(23108, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(23109, Player, {}) ->
    cross_area:apply(cross_arena_proc, arena_log, [node(), Player#player.key, Player#player.sid]),
    ok;

%%排行榜
handle(23110, Player, {Page}) ->
    cross_area:apply(cross_arena_proc, arena_rank, [node(), Player#player.key, Player#player.sid, Page]),
    ok;

handle(23111, Player, {Pkey}) ->
    IsNormalScene = scene:is_normal_scene(Player#player.scene),
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    Now = util:unixtime(),
    Ret =
        if
            Player#player.key == Pkey -> 11;
            Mb#cross_arena_mb.times =< 0 -> 6;
            Player#player.convoy_state > 0 -> 14;
            Player#player.marry#marry.cruise_state > 0 -> 23;
            Player#player.match_state > 0 -> 22;
            IsNormalScene == false -> 15;
            Mb#cross_arena_mb.in_cd == 1 andalso Mb#cross_arena_mb.cd > Now -> 10;
            true ->
                Arena = cross_arena:make_arena(Player, true),
                cross_area:apply(cross_arena, check_rank_challenge, [node(), Player, Arena, Pkey]),
                ok
        end,
    case Ret of
        ok -> ok;
        Ret ->
            {ok, Bin} = pt_231:write(23111, {Ret, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%获取目标
handle(23112, Player, _) ->
    case scene:is_cross_arena_scene(Player#player.scene) of
        false -> ok;
        true ->
            cross_area:apply(cross_arena_room, dungeon_target, [node(), Player#player.copy, Player#player.sid]),
            ok
    end;

handle(_cmd, _Player, _Data) ->
    ok.

