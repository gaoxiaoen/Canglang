%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2017 14:37
%%%-------------------------------------------------------------------
-module(designation_load).

-include("designation.hrl").
-include("server.hrl").
-include("common.hrl").



-compile(export_all).

load_designation(Pkey) ->
    Sql = io_lib:format("select designation_list from designation where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_designation(StDesignation) ->
    DesignationList = designation_init:designation2string(StDesignation#st_designation.designation_list),
    Sql = io_lib:format("replace into designation set pkey=~p,designation_list = '~s'", [StDesignation#st_designation.pkey, DesignationList]),
    db:execute(Sql).


load_designation_global() ->
    Sql = "select dkey,des_id,pkey,get_time from designation_global",
    db:get_all(Sql).

insert_designation_global(DesignationGlobal) ->
    Sql = io_lib:format("insert into designation_global set dkey=~p,pkey=~p,des_id=~p,get_time=~p",
        [DesignationGlobal#designation_global.key,
            DesignationGlobal#designation_global.pkey,
            DesignationGlobal#designation_global.designation_id,
            DesignationGlobal#designation_global.get_time]),
    db:execute(Sql).

del_designation_global(Dkey) ->
    Sql = io_lib:format("delete from designation_global where dkey=~p", [Dkey]),
    db:execute(Sql).

log_designation(Pkey, Nickname, Type, DesignationId, Stage) ->
    Sql = io_lib:format("insert into log_designation set pkey=~p,nickname='~s',type=~p,designation_id=~p,stage=~p,time=~p",
        [Pkey, Nickname, Type, DesignationId, Stage, util:unixtime()]),
    log_proc:log(Sql).