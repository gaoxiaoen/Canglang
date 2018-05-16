%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2018 17:36
%%%-------------------------------------------------------------------
-module(guild_answer_util).
-author("hxming").

-include("guild_answer.hrl").
-include("common.hrl").
-include("guild.hrl").
%% API
-compile(export_all).

init_answer() ->
    GuildList = guild_ets:get_all_guild(),
    Now = util:unixtime(),
    F = fun(Guild) ->
        Ref = timeout_ref(Guild#guild.gkey),
        #guild_answer{
            gkey = Guild#guild.gkey,
            gname = Guild#guild.name,
            question = init_question(),
            time = Now + ?GUILD_ANSWER_TIMEOUT,
            ref = Ref
        }
        end,
    lists:map(F, GuildList).


init_question() ->
    util:list_shuffle(data_guild_answer:ids()).
%%    util:get_random_list(data_guild_answer:ids(), 10).

get_question_num() ->
    length(data_guild_answer:ids()).

timeout_ref(Gkey) ->
    erlang:send_after(?GUILD_ANSWER_TIMEOUT * 1000, self(), {next, Gkey}).

refresh_question(GuildAnswer) ->
    case GuildAnswer#guild_answer.question of
        [] ->
            {ok, Bin} = pt_405:write(40502, {0, 0, 0, 0, 0, <<>>}),
            server_send:send_to_guild(GuildAnswer#guild_answer.gkey, Bin),
            ok;
        _ ->
            Qid = hd(GuildAnswer#guild_answer.question),
            Num = guild_answer_util:get_question_num() - length(GuildAnswer#guild_answer.question) + 1,
            {ok, Bin} = pt_405:write(40502, {1, Qid, ?GUILD_ANSWER_TIMEOUT, Num, GuildAnswer#guild_answer.pkey, GuildAnswer#guild_answer.nickname}),
            server_send:send_to_guild(GuildAnswer#guild_answer.gkey, Bin),
            ok
    end.
