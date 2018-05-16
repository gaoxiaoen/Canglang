%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2015 下午7:13
%%%-------------------------------------------------------------------
-module(fashion_load).
-include("fashion.hrl").
-include("server.hrl").
-include("common.hrl").



-compile(export_all).

load_fashion(Pkey) ->
    Sql = io_lib:format("select fashion_list from fashion where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_fashion(StFashion) ->
    FashionList = fashion_init:fashion2string(StFashion#st_fashion.fashion_list),
    Sql = io_lib:format("replace into fashion set pkey=~p,fashion_list = '~s'", [StFashion#st_fashion.pkey, FashionList]),
    db:execute(Sql).

log_fashion(Pkey,Nickname,Type,FashionId,Stage)->
    Sql = io_lib:format("insert into log_fashion set pkey=~p,nickname='~s',type=~p,fashion_id=~p,stage=~p,time=~p",
        [Pkey,Nickname,Type,FashionId,Stage,util:unixtime()]),
    log_proc:log(Sql).

log_present_fashion(Pkey1,Nickname1,Pkey2,Nickname2,FashionId,FashionName)->
    ?DEBUG("log_present_fashion ~n"),
    Sql = io_lib:format("insert into log_present_fashion set pkey1=~p,nickname1='~s',pkey2=~p,nickname2='~s',fashion_id=~p,fashion_name='~s',time=~p",
        [Pkey1,Nickname1,Pkey2,Nickname2,FashionId,FashionName,util:unixtime()]),

    log_proc:log(Sql).

