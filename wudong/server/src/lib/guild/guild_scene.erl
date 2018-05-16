%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%      仙盟领地信息
%%% @end
%%% Created : 26. 二月 2018 15:13
%%%-------------------------------------------------------------------
-module(guild_scene).
-author("hxming").

-include("scene.hrl").
-include("guild.hrl").
-include("common.hrl").
%% API
-export([init_scene/0, create_scene/1, stop_scene/1, quit_guild_scene/1]).

init_scene() ->
    GuildList = guild_ets:get_all_guild(),
    F = fun(Guild) ->
        create_scene(Guild#guild.gkey)
        end,
    lists:foreach(F, GuildList),
    ok.

create_scene(GuildKey) ->
    scene_init:priv_create_scene(?SCENE_ID_GUILD, GuildKey),
    ok.

stop_scene(GuildKey) ->
    %T人
    L = scene_agent:get_copy_scene_player(?SCENE_ID_GUILD, GuildKey),
    F = fun(ScenePlayer) ->
        ScenePlayer#scene_player.pid ! quit_guild_scene
        end,
    lists:foreach(F, L),

    scene_init:stop_scene(?SCENE_ID_GUILD, GuildKey),
    ok.


quit_guild_scene(Player) ->
    spawn(fun() ->
        case Player#player.scene == ?SCENE_ID_GUILD of
            true ->
                util:sleep(200),
                Player#player.pid ! quit_guild_scene;
            false -> skip
        end
          end).