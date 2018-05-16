%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 六月 2017 14:04
%%%-------------------------------------------------------------------
-module(cross_scuffle_rpc).
-author("hxming").
-include("common.hrl").
-include("server.hrl").
-include("cross_scuffle.hrl").
-include("daily.hrl").
%% API
-export([handle/3]).

%%检查状态
handle(58401, Player, {}) ->
    if Player#player.lv < ?CROSS_SCUFFLE_ENTER_LV -> ok;
        true ->
            cross_all:apply(cross_scuffle, check_state, [node(), Player#player.sid]),
            ok
    end;

%%获取活动匹配状态
handle(58402, Player, {}) ->
    Times = daily:get_count(?DAILY_CROSS_SCUFFLE_TIMES),
    cross_all:apply(cross_scuffle, check_match_state, [node(), Player#player.key, Player#player.sid, Times]),
    ok;

%%单人匹配
handle(58403, Player, {}) ->
    Ret = if Player#player.lv < ?CROSS_SCUFFLE_ENTER_LV -> 2;
              Player#player.convoy_state > 0 -> 3;
              Player#player.marry#marry.cruise_state > 0 -> 20;
              Player#player.match_state > 0 -> 7;
              true ->
                  case scene:is_normal_scene(Player#player.scene) of
                      false -> 4;
                      true ->
                          Mb = cross_scuffle:make_mb(Player, Player#player.key),
                          Times = daily:get_count(?DAILY_CROSS_SCUFFLE_TIMES),
                          cross_all:apply(cross_scuffle, match_single, [Mb#scuffle_mb{times = Times, match_time = util:unixtime()}]),
                          ok
                  end
          end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_584:write(58403, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%小队匹配
handle(58404, Player, {}) ->
    Ret =
        if Player#player.lv < ?CROSS_SCUFFLE_ENTER_LV -> 2;
            Player#player.convoy_state > 0 -> 3;
            Player#player.match_state > 0 -> 7;
            Player#player.marry#marry.cruise_state > 0 -> 20;
            Player#player.team_key == 0 -> 8;
            Player#player.team_leader /= 1 -> 9;
            true ->
                case scene:is_normal_scene(Player#player.scene) of
                    false -> 4;
                    true ->
                        case cross_scuffle:check_team_state(Player) of
                            {true, MbList} ->
                                cross_all:apply(cross_scuffle, match_team, [node(), Player#player.key, Player#player.sid, Player#player.team_key, MbList]),
                                ok;
                            Err -> Err
                        end
                end
        end,
    case Ret of
        ok -> ok;
        {false, Code, Name} ->
            {ok, Bin} = pt_584:write(58404, {Code, Name}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _ ->
            {ok, Bin} = pt_584:write(58404, {Ret, <<>>}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%队伍确认
handle(58406, Player, {IsAgree}) ->
    if Player#player.team_key /= 0 ->
        cross_all:apply(cross_scuffle, team_agree, [Player#player.key, Player#player.team_key, IsAgree]);
        true -> skip
    end,
    ok;

%%挑战列表58407(推送)

%%挑战统计58408
handle(58408, Player, {}) ->
    case scene:is_cross_scuffle_scene(Player#player.scene) of
        false -> ok;
        true ->
            cross_all:apply(cross_scuffle, scuffle_info, [Player#player.key, Player#player.copy]),
            ok
    end;

%%buff碰撞
handle(58409, Player, {Mkey}) ->
    case scene:is_cross_scuffle_scene(Player#player.scene) of
        false -> ok;
        true ->
            cross_all:apply(cross_scuffle, crash_buff, [node(), Player#player.pid, Player#player.sid, Mkey, Player#player.copy, Player#player.x, Player#player.y]),
            ok
    end;

%%58410陷阱通知

handle(58411, Player, {}) ->
    if Player#player.match_state == ?MATCH_STATE_CROSS_SCUFFLE ->
        {ok, Bin} = pt_584:write(58411, {1}),
        server_send:send_to_sid(Player#player.sid, Bin),
        cross_all:apply(cross_scuffle, cancel_match, [Player#player.key]),
        {ok, Player#player{match_state = 0}};
        true -> ok
    end;

%%退出战场
handle(58413, Player, {}) ->
    case scene:is_cross_scuffle_scene(Player#player.scene) of
        false -> ok;
        true ->
            Player0 = buff:del_buff_only(Player, ?SCUFFLE_COMBO_BUFF_ID),
            cross_all:apply(cross_scuffle, scuffle_quit, [Player#player.key, Player#player.copy]),
            Player1 = scene_change:change_scene_back(Player0),
            Player2 = Player1#player{group = 0, figure = 0},
            {ok, Bin} = pt_120:write(12027, {Player#player.key, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            NewPlayer = player_util:count_player_attribute(Player2, true),
            scene_agent_dispatch:figure(NewPlayer),
            scene_agent_dispatch:group_update(NewPlayer),
            {ok, NewPlayer}
    end;

%%快捷聊天
handle(58414, Player, {Type}) ->
    case scene:is_cross_scuffle_scene(Player#player.scene) of
        false -> ok;
        true ->
            {ok, Bin} = pt_584:write(58414, {Player#player.key, Type}),
            server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
            ok
    end;


handle(_Cmd, _Player, Msg) ->
    ?ERR("cmd ~p msg ~p undef~n", [_Cmd, Msg]),
    ok.

