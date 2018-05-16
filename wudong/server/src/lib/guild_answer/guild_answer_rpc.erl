%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2018 18:17
%%%-------------------------------------------------------------------
-module(guild_answer_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
%% API
-export([handle/3]).

handle(40501, Player, {}) ->
    if Player#player.guild#st_guild.guild_key == 0 -> ok;
        true ->
            gen_server:cast(guild_answer_proc:get_server_pid(), {check_state, Player#player.sid}),
            ok
    end;

handle(40502, Player, {}) ->
    if Player#player.guild#st_guild.guild_key == 0 -> ok;
        true ->
            gen_server:cast(guild_answer_proc:get_server_pid(), {check_question, Player#player.sid, Player#player.guild#st_guild.guild_key}),
            ok
    end;

handle(40503, Player, {Qid, Answer}) ->
    if Player#player.guild#st_guild.guild_key == 0 -> ok;
        true ->
            gen_server:cast(guild_answer_proc:get_server_pid(), {check_answer, Player#player.key,Player#player.pid,Player#player.nickname, Player#player.sid, Player#player.guild#st_guild.guild_key, Qid, Answer}),
            ok
    end;

handle(_cmd, _Player, _Data) ->
    ?DEBUG("cmd ~p ~p~n", [_cmd, _Data]),
    ok.
