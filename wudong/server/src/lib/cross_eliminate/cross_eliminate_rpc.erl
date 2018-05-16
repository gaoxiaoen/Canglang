%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 六月 2016 10:38
%%%-------------------------------------------------------------------
-module(cross_eliminate_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("cross_eliminate.hrl").
%% API
-export([handle/3]).


%%排行榜
handle(59001, Player, {Page}) ->
    cross_all:apply(cross_eliminate, check_rank, [node(), Player#player.key, Player#player.sid, Page]),
    ok;

%%个人匹配
handle(59002, Player, {}) ->
    case scene:is_normal_scene(Player#player.scene) of
        false ->
            {ok, Bin} = pt_590:write(59002, {2}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            if Player#player.convoy_state > 0 ->
                {ok, Bin} = pt_590:write(59002, {3}),
                server_send:send_to_sid(Player#player.sid, Bin),
                ok;
                Player#player.match_state > 0 ->
                    {ok, Bin} = pt_590:write(59002, {9}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                Player#player.marry#marry.cruise_state > 0 ->
                    {ok, Bin} = pt_590:write(59002, {10}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                Player#player.lv < ?CROSS_ELIMINATE_LV ->
                    {ok, Bin} = pt_590:write(59002, {7}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                true ->
                    Mb = cross_eliminate:make_mb(Player, 0),
                    ets:insert(?ETS_CROSS_ELIMINATE, Mb),
                    cross_all:apply(cross_eliminate, check_match, [Mb]),
                    ok
            end,
            activity:get_notice(Player, [126], true),
            ok
    end;

handle(59003, Player, {}) ->
    cross_all:apply(cross_eliminate, check_cancel, [node(), Player#player.key, Player#player.sid]),
    {ok, Player#player{match_state = ?MATCH_STATE_NO}};

%%邀请好友
handle(59004, Player, {KeyList}) ->
    F = fun(Key) ->
        case ets:lookup(?ETS_ONLINE, Key) of
            [] ->
                {ok, Bin} = pt_590:write(59004, {5}),
                server_send:send_to_sid(Player#player.sid, Bin),
                ok;
            [Online] ->
                Online#ets_online.pid ! {eliminate_invite, Player#player.key, Player#player.nickname, Player#player.avatar, Player#player.sex},
                ok
        end
        end,
    lists:foreach(F, KeyList),
    Mb = cross_eliminate:make_mb(Player, 1),
    ets:insert(?ETS_CROSS_ELIMINATE, Mb),
    cross_all:apply(cross_eliminate, check_match, [Mb]),
    ok;


%%好友回应邀请
handle(59006, Player, {Pkey}) ->
    case scene:is_normal_scene(Player#player.scene) of
        false ->
            {ok, Bin} = pt_590:write(59006, {2}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            if Player#player.convoy_state > 0 ->
                {ok, Bin} = pt_590:write(59006, {3}),
                server_send:send_to_sid(Player#player.sid, Bin),
                ok;
                Player#player.match_state > 0 ->
                    {ok, Bin} = pt_590:write(59002, {9}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                Player#player.marry#marry.cruise_state > 0 ->
                    {ok, Bin} = pt_590:write(59002, {10}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                Player#player.lv < ?CROSS_ELIMINATE_LV ->
                    {ok, Bin} = pt_590:write(59006, {7}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                true ->
                    Mb = cross_eliminate:make_mb(Player, 1),
                    ets:insert(?ETS_CROSS_ELIMINATE, Mb),
                    cross_all:apply(cross_eliminate, check_respond, [Mb, Pkey]),
                    ok
            end
    end;


%%查询VS数据
handle(59008, Player, {}) ->
    cross_all:apply(cross_eliminate_play, check_info, [Player#player.key, Player#player.copy]),
    ok;


%%请求退出
handle(59013, Player, {}) ->
    {Ret, NewPlayer} =
        case scene:is_cross_eliminate_scene(Player#player.scene) of
            false ->
                {6, Player};
            true ->
                cross_all:apply(cross_eliminate, check_logout, [Player#player.key]),
                Player1 = scene_change:change_scene_back(Player#player{eliminate_group = 0}),
                {1, Player1}
        end,
    {ok, Bin} = pt_590:write(59013, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取次数
handle(59015, Player, {}) ->
    Times = cross_eliminate:get_eliminate_times(),
    {ok, Bin} = pt_590:write(59015, {Times, ?CROSS_ELIMINATE_MAX_TIMES}),
    server_send:send_to_sid(Player#player.sid, Bin),
%%     activity:get_notice(Player, [126], true),
    ok;

handle(59016, Player, {}) ->
    cross_all:apply(cross_eliminate, get_last_week_reward, [node(), Player#player.key, Player#player.pid]),
    ok;

%%拒绝邀请
handle(59017, Player, {Pkey}) ->
    {ok, Bin} = pt_590:write(59017, {Player#player.nickname}),
    server_send:send_to_key(Pkey, Bin),
    ok;

handle(_cmd, _Player, _Data) ->
    ?DEBUG("cmd ~p err~n", [_cmd]),
    ok.


