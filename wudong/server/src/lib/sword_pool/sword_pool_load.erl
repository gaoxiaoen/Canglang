%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2016 10:04
%%%-------------------------------------------------------------------
-module(sword_pool_load).
-author("hxming").

-include("sword_pool.hrl").
%% API
-compile(export_all).


load(Pkey) ->
    Sql = io_lib:format("select figure,lv,exp,target_list,exp_daily,goods_daily,time,find_back_list from sword_pool where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace(St) ->
    Sql = io_lib:format("replace into sword_pool set pkey=~p,figure=~p,lv=~p,exp=~p,target_list='~s',exp_daily=~p,goods_daily=~p,time=~p,find_back_list='~s'",
        [St#st_sword_pool.pkey,
            St#st_sword_pool.figure,
            St#st_sword_pool.lv,
            St#st_sword_pool.exp,
            util:term_to_bitstring(St#st_sword_pool.target_list),
            St#st_sword_pool.exp_daily,
            St#st_sword_pool.goods_daily,
            St#st_sword_pool.time,
            util:term_to_bitstring(St#st_sword_pool.find_back_list)]),
    db:execute(Sql).


log_sword_pool(Pkey, Nickname, Type, Lv) ->
    Sql = io_lib:format("insert into log_sword_pool set pkey=~p,nickname='~s',type=~p,lv=~p,time=~p",
        [Pkey, Nickname, Type, Lv, util:unixtime()]),
    log_proc:log(Sql).