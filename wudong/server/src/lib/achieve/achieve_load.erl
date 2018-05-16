%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2016 10:02
%%%-------------------------------------------------------------------
-module(achieve_load).
-author("hxming").

-include("achieve.hrl").
%% API
-compile(export_all).



select_achieve(Pkey) ->
    Sql = io_lib:format("select lv,score,achieve_list,log,rec_log from achieve where pkey=~p", [Pkey]),
    db:get_row(Sql).

%%更新
replace_achieve(StAchieve) ->
    AchieveList = achieve_init:record2list(StAchieve#st_achieve.achieve_list),
    Sql = io_lib:format("replace into achieve set pkey=~p,lv=~p,score=~p,achieve_list='~s',log='~s',rec_log='~s'",
        [StAchieve#st_achieve.pkey,
            StAchieve#st_achieve.lv,
            StAchieve#st_achieve.score,
            util:term_to_bitstring(AchieveList),
            util:term_to_bitstring(StAchieve#st_achieve.log),
            util:term_to_bitstring(StAchieve#st_achieve.rec_log)
        ]),
    db:execute(Sql),
    ok.

log_achieve(Pkey, Nickname, Type, AchId) ->
    Sql = io_lib:format("insert into log_achieve set pkey=~p,nickname='~s',type=~p,ach_id=~p,time=~p",
        [Pkey, Nickname, Type, AchId, util:unixtime()]),
    log_proc:log(Sql).



