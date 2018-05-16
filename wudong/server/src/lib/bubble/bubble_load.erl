%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 二月 2017 19:42
%%%-------------------------------------------------------------------
-module(bubble_load).

-include("bubble.hrl").
-include("server.hrl").
-include("common.hrl").



-compile(export_all).

load_bubble(Pkey) ->
    Sql = io_lib:format("select bubble_list from bubble where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_bubble(StBubble) ->
    BubbleList = bubble_init:bubble2string(StBubble#st_bubble.bubble_list),
    Sql = io_lib:format("replace into bubble set pkey=~p,bubble_list = '~s'", [StBubble#st_bubble.pkey, BubbleList]),
    db:execute(Sql).


log_bubble(Pkey,Nickname,Type,BubbleId,Stage)->
    Sql = io_lib:format("insert into log_bubble set pkey=~p,nickname='~s',type=~p,bubble_id=~p,stage=~p,time=~p",[Pkey,Nickname,Type,BubbleId,Stage,util:unixtime()]),
    log_proc:log(Sql).