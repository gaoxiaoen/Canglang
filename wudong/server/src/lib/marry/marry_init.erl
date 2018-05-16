%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 七月 2017 10:52
%%%-------------------------------------------------------------------
-module(marry_init).
-author("hxming").

-include("marry.hrl").

%% API
-export([
    init_marry/0
    , init_cruise/0
    , fix/0
]).

init() ->
    ok.

init_marry() ->
    F = fun([Mkey, Type, KeyBoy, KeyGirl, Time, Cruise, HeartLv, RingLv, CruiseNum]) ->
        StMarry = #st_marry{mkey = Mkey, type = Type, key_boy = KeyBoy, key_girl = KeyGirl, time = Time, cruise = Cruise, heart_lv = util:bitstring_to_term(HeartLv), ring_lv = util:bitstring_to_term(RingLv), cruise_num = CruiseNum},
        ets:insert(?ETS_MARRY, StMarry)
        end,
    lists:foreach(F, marry_load:get_all()),
    ok.


init_cruise() ->
    F = fun([Akey, Date, Time, Mkey]) ->
        #st_cruise{akey = Akey, date = Date, time = util:to_integer(Time), mkey = Mkey}
        end,
    lists:map(F, marry_load:load_cruise_all()).

fix()->
    marry_proc:get_server_pid() ! fix_cruise_list.