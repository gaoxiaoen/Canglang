%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 六月 2016 19:06
%%%-------------------------------------------------------------------
-module(cross_elite_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("cross_elite.hrl").
%% API
-export([handle/3]).

%%检查状态
handle(58001, Player, {}) ->
    if Player#player.lv < ?CROSS_ELITE_ENTER_LV -> ok;
        true ->
            cross_area:apply(cross_elite, check_state, [node(), Player#player.sid, util:unixtime()]),
            ok
    end;

%%比赛信息
handle(58002, Player, {}) ->
    Data = cross_elite:check_info(),
    {ok, Bin} = pt_580:write(58002, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%匹配比赛
handle(58003, Player, {}) ->
    Ret = if Player#player.lv < ?CROSS_ELITE_ENTER_LV -> 2;
              Player#player.convoy_state > 0 -> 3;
              Player#player.marry#marry.cruise_state > 0 -> 11;
              Player#player.match_state > 0 -> 10;
              true ->
                  case scene:is_normal_scene(Player#player.scene) of
                      false -> 4;
                      true ->
                          Mb = cross_elite:make_mb(Player),
                          ets:insert(?ETS_CROSS_ELITE, Mb),
                          cross_area:apply(cross_elite, check_match, [Mb]),
                          %%玩法找回
                          findback_src:fb_trigger_src(Player, 33, 1),
                          ok
                  end
          end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_580:write(58003, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%取消匹配
handle(58004, Player, {}) ->
    cross_area:apply(cross_elite, check_cancel, [node(), Player#player.key, Player#player.sid]),
    {ok, Player#player{match_state = ?MATCH_STATE_NO}};

%%排行榜
handle(58005, Player, {Page}) ->
    cross_area:apply(cross_elite, check_rank, [node(), Player#player.key, Player#player.sid, Page]),
    ok;

%%查询场景挑战数据
handle(58007, Player, {}) ->
    cross_area:apply(cross_elite, check_vs_info, [Player#player.key, Player#player.copy]),
    ok;

%%请求退出
handle(58009, Player, {}) ->
    {Ret, NewPlayer} =
        case scene:is_cross_elite_scene(Player#player.scene) of
            false ->
                {9, Player};
            true ->
                cross_area:apply(cross_elite, quit, [Player#player.copy, Player#player.key]),
                Player1 = scene_change:change_scene_back(Player),
                {1, Player1}
        end,
    {ok, Bin} = pt_580:write(58009, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%领取每日段位奖励
handle(58011, Player, {}) ->
    {Ret, GoodsList, NewPlayer} = cross_elite:daily_reward(Player),
    {ok, Bin} = pt_580:write(58011, {Ret, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%领取每日挑战奖励
handle(58012, Player, {Id}) ->
    {Ret, GoodsList, NewPlayer} = cross_elite:times_reward(Player, Id),
    {ok, Bin} = pt_580:write(58012, {Ret, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ?ERR("cross elite bad cmd ~p _Data ~p ~n", [_cmd, _Data]),
    ok.