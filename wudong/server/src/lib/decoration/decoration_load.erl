%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 七月 2017 11:59
%%%-------------------------------------------------------------------
-module(decoration_load).
-author("hxming").

-include("decoration.hrl").
-include("server.hrl").
-include("common.hrl").



-compile(export_all).

load_decoration(Pkey) ->
    Sql = io_lib:format("select decoration_list from decoration where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_decoration(StDecoration) ->
    DecorationList = decoration_init:decoration2string(StDecoration#st_decoration.decoration_list),
    Sql = io_lib:format("replace into decoration set pkey=~p,decoration_list = '~s'", [StDecoration#st_decoration.pkey, DecorationList]),
    db:execute(Sql).


log_decoration(Pkey,Nickname,Type,DecorationId,Stage)->
    Sql = io_lib:format("insert into log_decoration set pkey=~p,nickname='~s',type=~p,decoration_id=~p,stage=~p,time=~p",[Pkey,Nickname,Type,DecorationId,Stage,util:unixtime()]),
    log_proc:log(Sql).