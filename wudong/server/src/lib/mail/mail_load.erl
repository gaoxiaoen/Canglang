%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 一月 2015 下午12:02
%%%-------------------------------------------------------------------
-module(mail_load).
-author("fancy").

%% API
-export([dbget_mail/1,
    dbinsert_mail_sql/9,
    dbdelete_mail/1,
    dbup_mail_state/2,
    dbup_mail_goods/1
]).

dbget_mail(Key) ->
    SQL = io_lib:format("select mkey,pkey,type,goodslist,title,content,time,state ,overtime from mail where pkey = ~p", [Key]),
    db:get_all(SQL).

dbinsert_mail_sql(Mkey, Key, Type, GoodsList, Title, Content, Time, State, OverTime) ->
    SQL = io_lib:format(<<"insert into mail set `mkey` = ~p ,`pkey` = ~p,`type` = ~p ,`goodslist` = '~s',`title` = '~s',`content` = '~s',`time` = ~p,`state` = ~p,overtime=~p">>,
        [Mkey, Key, Type, GoodsList, Title, Content, Time, State, OverTime]),
    SQL.

dbdelete_mail(Mkey) ->
    SQL = io_lib:format("delete from mail where mkey = ~p", [Mkey]),
    db:execute(SQL).

dbup_mail_state(Mkey, State) ->
    SQL = io_lib:format("update mail set state = ~p where mkey = ~p", [State, Mkey]),
    db:execute(SQL).


dbup_mail_goods(Mkey) ->
    SQL = io_lib:format("update mail set goodslist = '~s' where mkey = ~p", [util:term_to_bitstring([]), Mkey]),
    db:execute(SQL).