%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 三月 2016 17:16
%%%-------------------------------------------------------------------
-module(battlefield_rpc).
-author("hxming").

-include("scene.hrl").
-include("server.hrl").
-include("common.hrl").
-include("battlefield.hrl").

%% API
-export([handle/3]).

%%查询活动状态
handle(64001, Player, {}) ->
    if Player#player.lv < ?BATTLEFIELD_ENTER_LV -> ok;
        true ->
            cross_area:apply(battlefield, check_state, [node(), Player#player.sid, util:unixtime()]),
            ok
    end,
    ok;

%%请求进入战场
handle(64002, Player, {}) ->
    if
        Player#player.lv < 45 ->
            {ok, Bin} = pt_640:write(64002, {203}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        Player#player.convoy_state > 0 ->
            {ok, Bin} = pt_640:write(64002, {206}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        Player#player.match_state > 0 ->
            {ok, Bin} = pt_640:write(64002, {207}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            case scene:is_normal_scene(Player#player.scene) of
                false ->
                    {ok, Bin} = pt_640:write(64002, {205}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                true ->
                    Mb = battlefield:make_mb(Player),
                    cross_area:apply(battlefield, check_enter, [Mb]),
                    ok
            end
    end;

%%退出战场
handle(64003, Player, {}) ->
    case scene:is_battlefield_scene(Player#player.scene) of
        false ->
            {ok, Bin} = pt_640:write(64003, {301}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            {ok, Bin} = pt_640:write(64003, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            Player1 = buff:del_buff(Player, data_battlefield:buff_id()),
            Player2 = scene_change:change_scene_back(Player1),
            cross_area:apply(battlefield, check_quit, [Player#player.key]),
            {ok, Player2}
    end;


%%查看战场个人统计
handle(64004, Player, {}) ->
    cross_area:apply(battlefield, check_info, [node(), Player#player.key, Player#player.sid]),
    ok;

%%前十排名
handle(64005, Player, {}) ->
    cross_area:apply(battlefield, check_top_ten, [node(), Player#player.sid]),
    ok;

%%查看排行榜
handle(64006, Player, {Type, Page}) ->
    cross_area:apply(battlefield, check_rank, [node(), Player#player.sid, Type, Page]),
    ok;

%%查询宝箱信息
handle(64007, Player, {}) ->
    cross_area:apply(battlefield, check_box, [node(), Player#player.sid, Player#player.copy]),
    ok;

%%获取技能CD
handle(64009, Player, {}) ->
    Data = battlefield:get_skill_cd(Player#player.key),
    {ok, Bin} = pt_640:write(64009, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%报名战场
handle(64010, Player, {}) ->
    if Player#player.lv < 45 ->
        {ok, Bin} = pt_640:write(64010, {203}),
        server_send:send_to_sid(Player#player.sid, Bin),
        ok;
        true ->
            Mb = battlefield:make_mb(Player),
            cross_area:apply(battlefield, check_apply, [Mb#bf_mb{is_apply = 1}]),
            ok
    end;

handle(_cmd, _Player, _Data) ->
    ?ERR("battlefield bad cmd ~p _Data ~p ~n", [_cmd, _Data]),
    ok.
