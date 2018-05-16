%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十一月 2015 下午8:17
%%%-------------------------------------------------------------------
-module(sign_in_load).
-author("fengzhenlin").
-include("sign_in.hrl").
-include("server.hrl").

%% API
-export([
    dbget_sign_in_info/1,
    dbup_sign_in/1,
    log_sign_in/4
]).

dbget_sign_in_info(Player) ->
    Sql = io_lib:format("select days,sign_in,acc_reward,time from player_sign_in where pkey=~p", [Player#player.key]),
    db:get_row(Sql).

dbup_sign_in(SignInSt) ->
    #st_sign_in{
        pkey = Pkey,
        days = Days,
        sign_in = SignIn,
        acc_reward = AccReward,
        time = Time
    } = SignInSt,
    Sql = io_lib:format("replace into player_sign_in set pkey=~p,days = ~p,sign_in = '~s',acc_reward='~s',time=~p ",
        [Pkey, Days, util:term_to_bitstring(SignIn), util:term_to_bitstring(AccReward), Time]),
    db:execute(Sql),
    ok.

log_sign_in(Pkey, Nickname, Type, Day) ->
    Sql = io_lib:format("insert into log_sign_in set pkey=~p,nickname='~s',type=~p,day=~p,time=~p",
        [Pkey, Nickname, Type, Day, util:unixtime()]),
    log_proc:log(Sql).