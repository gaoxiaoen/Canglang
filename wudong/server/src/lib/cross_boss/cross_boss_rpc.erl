%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 五月 2016 22:54
%%%-------------------------------------------------------------------
-module(cross_boss_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("cross_boss.hrl").
-include("guild.hrl").
-include("scene.hrl").

%% API
-export([handle/3]).

%%获取世界服状态
handle(57000, Player, {}) ->
    cross_area:apply(cross_boss, get_word_sn_list, [node(), Player#player.sid]),
    ok;

%%获取活动状态
handle(57001, Player, {}) ->
    if
        Player#player.lv < ?CROSS_BOSS_ENTER_LV -> ok;
        true ->
            cross_area:apply(cross_boss, check_state, [node(), Player#player.sid]),
            ok
    end;

%%请求进入跨服boss
handle(57003, Player, {Layer}) ->
    GuildMember = guild_ets:get_guild_member(Player#player.key),
%%     LimitLv = cross_boss:get_limit_lv_by_layer(Layer),
    Ret =
        if
            Player#player.lv < ?CROSS_BOSS_ENTER_LV -> 3;
%%             Player#player.lv < LimitLv -> 3;
            Player#player.convoy_state > 0 -> 4;
            Player#player.marry#marry.cruise_state > 0 -> 12;
            Player#player.match_state > 0 -> 11;
            GuildMember == false -> 0; %% 没有加入公会
            true ->
                case scene:is_normal_scene(Player#player.scene)
                    orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_ONE
                    orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_TWO
                    orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_THREE
                    orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_FOUR
                    orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_FIVE
                of
                    false -> 2;
                    true ->
                        Guild = guild_ets:get_guild(GuildMember#g_member.gkey),
                        StPlayerCrossBoss = lib_dict:get(?PROC_STATUS_CROSS_BOSS_DROP_NUM),
                        Mb = cross_boss:make_mb(Player, GuildMember, Guild, StPlayerCrossBoss, Layer),
                        cross_area:apply(cross_boss, check_enter, [Mb, Layer]),
                        ok
                end
        end,
    ?DEBUG("Ret:~p", [Ret]),
    case Ret of
        ok ->
            {ok, Bin} = pt_570:write(57003, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _ ->
            {ok, Bin} = pt_570:write(57003, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%请求退出
handle(57004, Player, {}) ->
    {Ret, NewPlayer} =
        case scene:is_cross_boss_scene(Player#player.scene) of
            false ->
                {8, Player};
            true ->
                cross_area:apply(cross_boss, check_quit, [Player#player.key]),
                Player1 = scene_change:change_scene_back(Player),
                {1, Player1}
        end,
    {ok, Bin} = pt_570:write(57004, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 数据统计
handle(57005, Player, _) ->
    cross_area:apply(cross_boss, get_tatal_data, [Player#player.key, node(), Player#player.sid]),
    ok;

%% 玩家界面数据
handle(57006, Player, _) ->
    cross_area:apply(cross_boss, get_self_data, [Player#player.key, node(), Player#player.sid]),
    ok;

%% 更新boss数据
handle(57007, _Player, _) ->
    ok;

%% 领取积分奖励
handle(57008, Player, {Score}) ->
    cross_area:apply(cross_boss, recv_score_reward, [Player#player.key, Score, node(), Player#player.pid, Player#player.sid]),
    ok;

%% 获取当前活动动态
handle(57009, Player, _) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_BOSS_DROP_NUM),
    BaseHasNum = data_cross_boss_has_num:get(),
    cross_boss:get_status(Player#player.sid, St#st_player_cross_boss.drop_num, BaseHasNum),
    ok;

handle(_cmd, _Player, _Data) ->
    ?ERR("cross boss bad cmd ~p _Data ~p ~n", [_cmd, _Data]),
    ok.