%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十一月 2016 13:44
%%%-------------------------------------------------------------------
-module(meridian_load).
-author("hxming").

-include("meridian.hrl").
%% API
-export([load/1, replace/1, log_meridian/5]).


load(Pkey) ->
    Sql = io_lib:format("select meridian_list from meridian where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace(StMeridian) ->
    MeridianList = util:term_to_bitstring(meridian_init:record2list(StMeridian#st_meridian.meridian_list)),
    Sql = io_lib:format("replace into meridian set pkey=~p,meridian_list='~s'",
        [StMeridian#st_meridian.pkey, MeridianList]),
    db:execute(Sql).

log_meridian(Pkey, Nickname, Type, Subtype, Lv) ->
    Sql = io_lib:format("insert into log_meridian set pkey=~p,nickname='~s',type= ~p,subtype=~p,lv=~p,time=~p",
        [Pkey, Nickname, Type, Subtype, Lv, util:unixtime()]),
    log_proc:log(Sql).
