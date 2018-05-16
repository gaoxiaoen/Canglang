%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 14:26
%%%-------------------------------------------------------------------
-module(guild_war_load).
-author("hxming").

-include("guild_war.hrl").
%% API
-compile(export_all).

get_all()->
    db:get_all("select `gkey`,`group`,`time` from guild_war").


replace(GuildWar) ->
    Sql = io_lib:format(<<"replace into guild_war set `gkey`=~p,`group`=~p,`time`=~p">>,
        [GuildWar#guild_war.gkey, GuildWar#guild_war.group, GuildWar#guild_war.time]),
    db:execute(Sql).

clear() ->
    db:execute("truncate guild_war").

delete(Gkey) ->
    Sql = io_lib:format("delete from guild_war where `gkey`=~p ", [Gkey]),
    db:execute(Sql).

load_figure()->
    db:get_all("select `pkey`,`figure_list` from guild_war_figure").



select_figure(Pkey)->
    Sql = io_lib:format("select `figure_list` from guild_war_figure where pkey = ~p ", [Pkey]),
    db:get_one(Sql).

replace_figure(Figure)->
    FigureList = guild_war_figure:pack_figure(Figure#st_figure.figure_list),
    Sql = io_lib:format("replace into guild_war_figure set `pkey`=~p,`figure_list`= '~s'",
        [Figure#st_figure.pkey,util:term_to_bitstring(FigureList)]),
    db:execute(Sql).

log_guild_war(Pkey, Nickname, Gkey, Gname, Contrib, Group, GroupRank, Rank, GoodsList, Time) ->
    Sql = io_lib:format("insert into log_guild_war set pkey=~p,nickname = '~s',gkey=~p,gname = '~s',`contrib`='~p',`group`=~p,`group_rank`=~p,`rank`=~p,`reward` = '~s',time=~p",
        [Pkey, Nickname, Gkey, Gname, Contrib, Group, GroupRank, Rank, util:term_to_bitstring(GoodsList), Time]),
    log_proc:log(Sql),
    ok.