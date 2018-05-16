%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2017 15:19
%%%-------------------------------------------------------------------
-module(mon_photo_load).
-author("hxming").

-include("mon_photo.hrl").
%% API
-compile(export_all).

load(Pkey) ->
    Sql = io_lib:format("select photo_list,mon_list from mon_photo where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace(StMonPhoto) ->
    PhotoList = mon_photo_init:photo2list(StMonPhoto#st_mon_photo.photo_list),
    Sql = io_lib:format("replace into mon_photo set pkey=~p,photo_list='~s',mon_list='~s'",
        [StMonPhoto#st_mon_photo.pkey, PhotoList, util:term_to_bitstring(StMonPhoto#st_mon_photo.mon_list)]),
    db:execute(Sql).


log_mon_photo(Pkey, Nicknam, Mid, Lv) ->
    Sql = io_lib:format("insert into log_mon_photo set pkey=~p,nickname='~s',mid=~p,lv=~p,time=~p",
        [Pkey, Nicknam, Mid, Lv, util:unixtime()]),
    log_proc:log(Sql),
    ok.
