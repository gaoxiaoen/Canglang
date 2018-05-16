%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 十二月 2017 10:48
%%%-------------------------------------------------------------------
-module(guild_box_init).
-author("Administrator").
-include("server.hrl").
-include("common.hrl").

%% API
-export([init/1]).


init([]) ->
    spawn(fun() ->
        timer:sleep(2000),
        ?CAST(guild_box_proc:get_server_pid(), init_state),

        timer:sleep(10000),
        guild_box_proc:get_server_pid() ! timer_delete %% 清除过期数据
    end),
    ok;

init(Player) ->
    PlayerGuildBox = guild_box_load:load_player_data(Player#player.key),
    lib_dict:put(?PROC_STATUS_GUILD_BOX, PlayerGuildBox),
    if
        Player#player.guild#st_guild.guild_key == 0 ->
            ?CAST(guild_box_proc:get_server_pid(), {get_box_reward_to_mail, Player});
        true ->
            skip
    end,
    Player.

