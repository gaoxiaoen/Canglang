%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2017 15:33
%%%-------------------------------------------------------------------
-module(party_load).
-author("hxming").
-include("common.hrl").
-include("party.hrl").
%% API
-compile(export_all).


load_party_all() ->
    Sql = "select akey,date,time,pkey,type,status,price_type,price from party",
    db:get_all(Sql).


replace_party(Party) ->
    Sql = io_lib:format("replace into party set  akey =~p,date=~p,time=~p,pkey=~p,type=~p, status =~p,price_type=~p,price=~p",
        [Party#party.akey, Party#party.date, Party#party.time, Party#party.pkey, Party#party.type, Party#party.status, Party#party.price_type, Party#party.price]),
    db:execute(Sql).

delete_party(Akey) ->
    Sql = io_lib:format("delete from party where akey=~p", [Akey]),
    db:execute(Sql).

log_party(Pkey, Nickname, Lv, Desc, TimeString, Time, PriceType, Price) ->
    Type = case PriceType of
               bgold -> ?T("绑定元宝");
               _ -> ?T("元宝")
           end,

    Sql = io_lib:format("insert into log_party set pkey = ~p,nickname='~s',lv = ~p,`desc` ='~s',app_time_string='~s',app_time =~p,time=~p,type = '~s',price = ~p",
        [Pkey, Nickname, Lv, Desc, TimeString, Time, util:unixtime(), Type, Price]),
    log_proc:log(Sql),
%%     db:execute(Sql),
    ok.



load_party_state() ->
    Sql = "select party_key,pkey,price_type,price from party_state ",
    db:get_all(Sql).

replace_party_state(PartyState) ->
    Sql = io_lib:format("replace into party_state set party_key=~p,pkey=~p,price_type=~p,price=~p",
        [PartyState#party_state.party_key, PartyState#party_state.pkey, PartyState#party_state.price_type, PartyState#party_state.price]),
    db:execute(Sql).

delete_party_state(PartyKey)->
    Sql = io_lib:format("delete from party_state where party_key=~p", [PartyKey]),
    db:execute(Sql).