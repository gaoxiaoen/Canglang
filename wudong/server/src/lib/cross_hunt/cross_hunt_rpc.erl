%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2016 17:32
%%%-------------------------------------------------------------------
-module(cross_hunt_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("cross_hunt.hrl").
%% API
-export([handle/3]).

%%获取活动状态
handle(62001, Player, {}) ->
    cross_area:apply(cross_hunt, check_state, [node(), Player#player.sid, util:unixtime()]),
    ok;

%%请求进入猎场
handle(62002, Player, {}) ->
    case scene:is_normal_scene(Player#player.scene) of
        false ->
            {ok, Bin} = pt_620:write(62002, {2}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            if Player#player.convoy_state > 0 ->
                {ok, Bin} = pt_620:write(62002, {11}),
                server_send:send_to_sid(Player#player.sid, Bin),
                ok;
                Player#player.match_state > 0 ->
                    {ok, Bin} = pt_620:write(62002, {12}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                Player#player.lv < ?CROSS_HUNT_OPEN_LV ->
                    {ok, Bin} = pt_620:write(62002, {6}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                true ->
                    Mb = cross_hunt:make_mb(Player),
                    cross_area:apply(cross_hunt, check_enter, [Mb]),
                    ok
            end
    end;

%%请求退出
handle(62003, Player, {}) ->
    {Ret, NewPlayer} =
        case scene:is_hunt_scene(Player#player.scene) of
            false ->
                {5, Player};
            true ->
                cross_area:apply(cross_hunt, check_quit, [Player#player.key]),
                Player1 = scene_change:change_scene_back(Player),
                {1, Player1}
        end,
    {ok, Bin} = pt_620:write(62003, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取猎场目标信息
handle(62004, Player, {}) ->
    case scene:is_hunt_scene(Player#player.scene) of
        false ->
            {ok, Bin} = pt_620:write(62003, {5}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            cross_hunt_target:check_target(Player#player.sid),
            ok
    end;

%%获取boss信息
handle(62005, Player, {}) ->
    case scene:is_hunt_scene(Player#player.scene) of
        false ->
            {ok, Bin} = pt_620:write(62003, {5}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            cross_area:apply(cross_hunt, check_boss, [node(), Player#player.key, Player#player.sid]),
            ok
    end;

%%获取猎场线路信息
handle(62006, Player, {}) ->
    case scene:is_hunt_scene(Player#player.scene) of
        false ->
            {ok, Bin} = pt_620:write(62003, {5}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            cross_area:apply(cross_hunt, check_copy, [node(), Player#player.copy, Player#player.guild#st_guild.guild_key, Player#player.sid]),
            ok
    end;

%%切换线路
handle(62007, Player, {Copy}) ->
    case scene:is_hunt_scene(Player#player.scene) of
        false ->
            {ok, Bin} = pt_620:write(62007, {5}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            cross_area:apply(cross_hunt, change_copy, [node(), Player#player.key, Player#player.pid, Copy]),
            ok
    end;


%%查询奖励的物品
handle(62009, Player, {}) ->
    HTarget = cross_hunt_target:get_target(),
    Data = cross_hunt_target:reward_list(HTarget),
    {ok, Bin} = pt_620:write(62009, {1, Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;



handle(_cmd, _Player, _Data) ->
    ?ERR("hunt bad cmd ~p~n", [_cmd]),
    ok.
