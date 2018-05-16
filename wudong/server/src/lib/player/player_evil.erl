%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 妖神变身
%%% @end
%%% Created : 02. 三月 2017 下午6:23
%%%-------------------------------------------------------------------
-module(player_evil).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("battle.hrl").
-include("scene.hrl").

%% API
-compile([export_all]).

-define(PLAYER_EVIL_FIGURE_ID, 20005).  %%妖神外观id
-define(EVIL_EFFECT_TIME, 15).  %%变身有效时间
-define(EVIL_NEED_SIN_VAL, 170).  %%变身所需怒气值
-define(EVIL_OPEN_LV, 5).  %%妖神变身开放等级

%% ---- 妖神变身 ----
%%变身
evil_trans(Player) ->
    evil_trans(Player, false).
evil_trans(Player, IsMust) ->
    case check_evil_trans(Player, IsMust) of
        {false, Res} ->
            {false, Res};
        ok ->
            #player{
                evil = PEvil
            } = Player,
            Now = util:unixtime(),
            NewPEvil = PEvil#pevil{
                evil = 1,
                evil_time = Now + ?EVIL_EFFECT_TIME
            },
            FigureId =
                case godness:get_war_godness_icon() of
                    [] -> ?PLAYER_EVIL_FIGURE_ID;
                    Icon -> Icon
                end,
            NewPlayer = Player#player{
                evil = NewPEvil,
                sin = 0,
                figure = FigureId
            },
            erlang:send_after(?EVIL_EFFECT_TIME * 1000 + 100, Player#player.pid, check_evil),
            evil_chans_notice(NewPlayer),
            {ok, NewPlayer}
    end.
check_evil_trans(Player, IsMust) ->
    #player{
        evil = PEvil
    } = Player,
    if
        IsMust andalso Player#player.lv < 50 -> ok;  %%新手剧情必变身
        PEvil#pevil.evil == 1 -> {false, 34};
        Player#player.sin < ?EVIL_NEED_SIN_VAL -> {false, 6};
        Player#player.lv < ?EVIL_OPEN_LV -> {false, 35};
        true ->
            ok
    end.

%%取消变身
cancel_evil(Player) ->
    NewPlayer =
        case Player#player.evil#pevil.evil == 1 of
            true ->
                Player1 = Player#player{
                    evil = Player#player.evil#pevil{evil_time = 0}
                },
                Player#player.pid ! check_evil,
                Player1;
            false ->
                Player
        end,
    {ok, NewPlayer}.

%%变身过期检查
check_evil_time(Player) ->
    Now = util:unixtime(),
    case Player#player.evil#pevil.evil == 1 andalso Player#player.evil#pevil.evil_time =< Now of
        true ->
            Figure = ?IF_ELSE(Player#player.scene == ?SCENE_ID_CROSS_SCUFFLE, Player#player.figure, 0),
            NewPlayer = Player#player{
                evil = Player#player.evil#pevil{evil = 0, evil_time = 0},
                figure = Figure,
                sin = 0
            },
            evil_chans_notice(NewPlayer),
            NewPlayer;
        false -> Player
    end.

evil_chans_notice(Player) ->
    Data =
        case Player#player.evil#pevil.evil == 0 of
            true -> {0, Player#player.sin, Player#player.figure, 0};
            false ->
                Now = util:unixtime(),
                LeaveTime = max(0, Player#player.evil#pevil.evil_time - Now),
                {1, Player#player.sin, Player#player.figure, LeaveTime}
        end,
    {ok, Bin} = pt_200:write(20016, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%检查是否可加怒气
check_add_sin(Aer, DerList, SkillId) ->
    AddSin =
        if
            Aer#bs.lv < ?EVIL_OPEN_LV -> 0;
            Aer#bs.evil =/= 0 -> 0;
            Aer#bs.sign =/= ?SIGN_PLAYER -> 0;
            true ->
                case lists:member(Aer#bs.scene, [?SCENE_ID_ARENA, ?SCENE_ID_CROSS_ARENA, ?SCENE_ID_SIX_DRAGON, ?SCENE_ID_SIX_DRAGON_FIGHT]) of
                    true -> 0;
                    false ->
                        Scene = data_scene:get(Aer#bs.scene),
                        case lists:member(Scene#scene.type, [?SCENE_TYPE_CROSS_BATTLEFIELD]) of
                            true -> 0;
                            false ->
                                case [Ds#bs.sign == ?SIGN_MON || Ds <- DerList] of
                                    [] -> 0;
                                    _ -> ?IF_ELSE(SkillId > 0, 2, 1)
                                end
                        end
                end

        end,
    min(?EVIL_NEED_SIN_VAL, Aer#bs.sin + AddSin).

%%切换场景，取消妖神变身效果
change_scene(Player) ->
    {ok, NewPlayer} = cancel_evil(Player),
    NewPlayer.