%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2016 17:31
%%%-------------------------------------------------------------------
-module(cross_hunt_load).
-author("hxming").

-include("cross_hunt.hrl").
%% API
-compile(export_all).

load_target(Pkey) ->
    Sql = io_lib:format(<<"select target,kill_count,time from hunt_target where pkey = ~p">>, [Pkey]),
    db:get_row(Sql).

replace_target(Target) ->
    Sql = io_lib:format(<<"replace into hunt_target set pkey = ~p,target = '~s',kill_count='~s',time = ~p">>,
        [Target#ch_mb_target.pkey,
            util:term_to_bitstring(cross_hunt_target:pack_target(Target#ch_mb_target.target)),
            util:term_to_bitstring(Target#ch_mb_target.kill_count),
            Target#ch_mb_target.time]),
    db:execute(Sql).


log_cross_hunt_reward(Pkey, Nickname, TargetId, GoodsList) ->
    Sql = io_lib:format(<<"insert into log_hunt_reward set pkey = ~p,nickname = '~s',target_id = ~p,goods_list = '~s',time = ~p ">>,
        [Pkey, Nickname, TargetId, util:term_to_string(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.