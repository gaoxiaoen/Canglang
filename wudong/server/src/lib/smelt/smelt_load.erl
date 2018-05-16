%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 二月 2017 17:44
%%%-------------------------------------------------------------------
-module(smelt_load).
-author("hxming").

-include("smelt.hrl").
%% API
-compile(export_all).


load_player_smelt(Pkey) ->
    Sql = io_lib:format("select stage,exp from player_smelt where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_player_smelt(St) ->
    Sql = io_lib:format("replace into player_smelt set pkey=~p,stage=~p,exp=~p",
        [St#st_smelt.pkey, St#st_smelt.stage, St#st_smelt.exp]),
    db:execute(Sql).

log_smelt(Pkey, Nickname, Lv, Exp, PartNum) ->
    Sql = io_lib:format("insert into log_smelt set pkey=~p,nickname='~s',lv=~p,exp=~p,equip_part=~p,time=~p",
        [Pkey, Nickname, Lv, Exp, PartNum, util:unixtime()]),
    log_proc:log(Sql).
