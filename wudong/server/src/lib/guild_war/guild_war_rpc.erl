%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 十二月 2015 14:22
%%%-------------------------------------------------------------------
-module(guild_war_rpc).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("guild_war.hrl").
%% API
-export([handle/3]).

%%获取仙盟战报名信息
handle(41002, Player, _) ->
    if Player#player.guild#st_guild.guild_key == 0 -> skip;
        true ->
            ?CAST(guild_war_proc:get_server_pid(), {apply_list, Player#player.guild#st_guild.guild_key, Player#player.sid})
    end;

%%获取势力报名信息
handle(41003, Player, {Group}) ->
    ?CAST(guild_war_proc:get_server_pid(), {group_list, Group, Player#player.sid});

%%仙盟战报名
handle(41004, Player, {Group}) ->
    ?CAST(guild_war_proc:get_server_pid(), {apply, Player#player.guild, Group, Player#player.sid});

%%获取仙盟战可变身信息
handle(41006, Player, {}) ->
    Data = guild_war_figure:get_figure_list(Player#player.key),
    {ok, Bin} = pt_410:write(41006, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%请求进入仙盟战
handle(41007, Player, {Figure}) ->
    case scene:is_guild_war_scene(Player#player.scene) of
        true -> ok;
        false ->
            {Ret, X, Y, Group} = ?CALL(guild_war_proc:get_server_pid(), {enter, Player, Figure}),
            {ok, Bin} = pt_410:write(41007, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            if Ret == 1 ->
                PlayerMount = mount_util:get_off(Player),
                PlayerPK = player_battle:pk_change_sys(PlayerMount, ?PK_TYPE_FIGHT, 1),
                Player1 = scene_change:change_scene(PlayerPK, ?SCENE_ID_GUILD_WAR, 0, X, Y, false),
                Player2 = Player1#player{figure = Figure, group = Group},
                Player3 = player_util:count_player_attribute(Player2, true),
                {ok, Bin1} = pt_120:write(12025, {Player#player.key, Figure, Group}),
                server_send:send_to_sid(Player#player.sid, Bin1),
                {ok, figure, Player3};
                true -> ok
            end
    end;

%%退出仙盟战场景
handle(41008, Player, _) ->
    case scene:is_guild_war_scene(Player#player.scene) of
        false ->
            {ok, Bin} = pt_410:write(41008, {801}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            {ok, Bin} = pt_410:write(41008, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {Scene, Copy, X, Y} = ?CALL(guild_war_proc:get_server_pid(), {quit, Player#player.key}),
%%            Figure = fashion:get_figure_by_fashion(Player),
            {ok, Bin1} = pt_120:write(12025, {Player#player.key, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin1),
            Player1 = player_util:count_player_attribute(Player#player{figure = 0}, true),
            NewCopy = scene_copy_proc:get_scene_copy(Scene, Copy),
            Player2 = scene_change:change_scene(Player1, Scene, NewCopy, X, Y, false),
            NewPlayer = player_battle:pk_change(Player2, Player#player.pk#pk.pk_old, 1),
            {ok, figure, NewPlayer}
    end;

%%仙盟战统计信息
handle(41009, Player, {}) ->
    ?CAST(guild_war_proc:get_server_pid(), {info, Player#player.key, Player#player.sid}),
    ok;

%%查看排行
handle(41010, Player, {Type, Page}) ->
    ?CAST(guild_war_proc:get_server_pid(), {rank, Player#player.sid, Type, Page}),
    ok;

%%变身选择
handle(41011, Player, {Figure}) ->
    Ret =
        case scene:is_guild_war_scene(Player#player.scene) of
            false -> 801;
            true ->
                case lists:member(Figure, data_guild_war_figure:ids()) of
                    false -> 703;
                    true -> 1
                end
        end,
    {ok, Bin} = pt_410:write(41011, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        ?CAST(guild_war_proc:get_server_pid(), {figure, Player#player.key, Figure}),
        Player1 = Player#player{figure = Figure},
        NewPlayer = player_util:count_player_attribute(Player1, true),
        {ok, figure, NewPlayer};
        true -> ok
    end;

%%指挥
handle(41012, Player, {}) ->
    ?CAST(guild_war_proc:get_server_pid(), {command, Player#player.key, Player#player.sid, Player#player.nickname, Player#player.x, Player#player.y}),
    ok;

%%个人仙盟战信息
handle(41014, Player, {}) ->
    ?CAST(guild_war_proc:get_server_pid(), {final, Player#player.key, Player#player.sid}),
    ok;


handle(41015, Player, {}) ->
    ?CAST(guild_war_proc:get_server_pid(), {crystal_list, Player#player.sid}),
    ok;

handle(41016, Player, {}) ->
    ?CAST(guild_war_proc:get_server_pid(), {crystal_refresh_list, Player#player.sid}),
    ok;

%%
handle(_cmd, _Player, _Data) ->
    ok.