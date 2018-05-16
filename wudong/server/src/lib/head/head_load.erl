%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 10:18
%%%-------------------------------------------------------------------
-module(head_load).
-author("hxming").


-include("head.hrl").
-include("server.hrl").
-include("common.hrl").



-compile(export_all).

load_head(Pkey) ->
    Sql = io_lib:format("select head_list from head where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_head(StHead) ->
    HeadList = head_init:head2string(StHead#st_head.head_list),
    Sql = io_lib:format("replace into head set pkey=~p,head_list = '~s'", [StHead#st_head.pkey, HeadList]),
    db:execute(Sql).


log_head(Pkey,Nickname,Type,HeadId,Stage)->
    Sql = io_lib:format("insert into log_head set pkey=~p,nickname='~s',type=~p,head_id=~p,stage=~p,time=~p",
        [Pkey,Nickname,Type,HeadId,Stage,util:unixtime()]),
    log_proc:log(Sql).