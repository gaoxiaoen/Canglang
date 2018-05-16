%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 五月 2016 14:41
%%%-------------------------------------------------------------------
-module(cross_battlefield_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("cross_battlefield.hrl").
%% API
-export([handle/3]).

%%获取活动状态
handle(55001, Player, {}) ->
    if Player#player.lv < ?CROSS_BATTLEFIELD_ENTER_LV -> ok;
        true ->
            cross_area:apply(cross_battlefield, check_state, [node(), Player#player.sid, util:unixtime()]),
            ok
    end;

%%请求进入跨服战场
handle(55002, Player, {}) ->
    Ret =
        if Player#player.lv < ?CROSS_BATTLEFIELD_ENTER_LV -> 5;
            Player#player.convoy_state > 0 -> 7;
            Player#player.match_state > 0 -> 9;
            Player#player.marry#marry.cruise_state > 0 -> 10;
            true ->
                case scene:is_normal_scene(Player#player.scene) of
                    false -> 6;
                    true ->
                        Mb = cross_battlefield:make_mb(Player),
                        cross_area:apply(cross_battlefield, check_enter, [Mb]),
                        %%玩法找回
                        findback_src:fb_trigger_src(Player, 34, 1),
                        ok
                end
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_550:write(55002, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%请求退出
handle(55003, Player, {}) ->
    {Ret, NewPlayer} =
        case scene:is_cross_battlefield_scene(Player#player.scene) of
            false ->
                {8, Player};
            true ->
                cross_area:apply(cross_battlefield, check_quit, [Player#player.key, quit]),
                Player2 = scene_change:change_scene_back(Player),
                Player3 = buff:del_buff_list(Player2, data_cross_battlefield_buff:buff_list(), 1),
                {1, Player3}
        end,
    {ok, Bin} = pt_550:write(55003, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取战场统计
handle(55004, Player, {}) ->
    case scene:is_cross_battlefield_scene(Player#player.scene) of
        false -> ok;
        true ->
            cross_area:apply(cross_battlefield, check_info, [Player#player.key]),
            ok
    end;

%%排行榜
handle(55007, Player, {Page}) ->
    case lists:member(Page, lists:seq(1, 5)) of
        true ->
            cross_area:apply(cross_battlefield, check_rank, [node(), Player#player.key, Player#player.sid, Page]);
        false -> ok
    end,
    ok;


handle(55013, Player, {Mkey}) ->
    case scene:is_cross_battlefield_scene(Player#player.scene) of
        false -> ok;
        true ->
            cross_area:apply(cross_battlefield, crash_buff, [node(), Player#player.pid, Player#player.sid, Mkey, Player#player.scene, Player#player.copy, Player#player.x, Player#player.y]),
            ok
    end;


handle(_cmd, _Player, _Data) ->
    ?ERR("kf_battlefield bad cmd ~p _Data ~p ~n", [_cmd, _Data]),
    ok.