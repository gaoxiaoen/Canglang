%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 五月 2016 15:24
%%%-------------------------------------------------------------------
-module(log).
-author("hxming").

-include("common.hrl").

%% API
-compile(export_all).

log_boss_join(BossId, Name, Pkey, NickName, Gkey, Hurt, Time) ->
    Sql = io_lib:format("insert into log_boss_join set boss_id = ~p,name = '~s',pkey = ~p,nickname = '~s',gkey =~p,hurt=~p,time=~p",
        [BossId, Name, Pkey, NickName, Gkey, Hurt, Time]),
    log_proc:log(Sql).
