%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 八月 2016 16:51
%%%-------------------------------------------------------------------
-module(panic_buying_load).
-author("hxming").

-include("panic_buying.hrl").

%% API
-compile(export_all).

load_all() ->
    Sql = "select id,type,date,goods_id,num,times,buy_log,time,state,lucky_num ,pkey from panic_buying",
    db:get_all(Sql).


replace(Goods) ->
    BugLog = panic_buying_init:buy_log_to_list(Goods#pb_goods.buy_log),
    Sql = io_lib:format("replace into panic_buying set id=~p,`type`=~p,`date` =~p,goods_id=~p,num=~p,times=~p,buy_log='~s',time=~p,`state`=~p,lucky_num=~p,pkey=~p",
        [Goods#pb_goods.id,
            Goods#pb_goods.type,
            Goods#pb_goods.date,
            Goods#pb_goods.goods_id,
            Goods#pb_goods.num,
            Goods#pb_goods.times,
            util:term_to_bitstring(BugLog),
            Goods#pb_goods.time,
            Goods#pb_goods.state,
            Goods#pb_goods.lucky_num,
            Goods#pb_goods.pkey
        ]),
    db:execute(Sql).

clean_db() ->
    db:execute("truncate panic_buying"),
    ok.

