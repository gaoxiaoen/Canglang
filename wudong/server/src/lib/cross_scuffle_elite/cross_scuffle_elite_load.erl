%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十月 2017 11:53
%%%-------------------------------------------------------------------
-module(cross_scuffle_elite_load).
-author("Administrator").
-include("cross_scuffle_elite.hrl").

%% API
-export([
    select_war_team_apply/0,
    insert_war_team_apply/1,
    del_war_team_apply/1,
    del_war_team_apply_by_pkey/1,
    del_war_team_apply_by_wtkey/1,
    del_war_team_member_by_pkey/1,
    del_war_team_member/1,
    del_war_team/1,
    replace_war_team/1,
    replace_war_team_member/1,
    select_war_team/0,
    select_war_team_member/0
]).

%%-----------------战队部分----------------------

%%加载战队数据
select_war_team() ->
%%     Key, Name, Num, PKey, PName, PCareer, PVip, CreateTime, Sn, Win, Lose, Score
    db:get_all("select `wtkey`,`name`,num,pkey,pname,pcareer,pvip,create_time,sn,win,lose,score  from war_team").


%%删除指定的玩家战队
del_war_team_member(WtKey) ->
    Sql = io_lib:format("update war_team_member set wtkey = 0 WHERE wtkey  = ~p", [WtKey]),
    db:execute(Sql).

%%加载战队申请数据
select_war_team_apply() ->
    db:get_all("select `akey`,pkey,wtkey,nickname,career,lv,cbp,vip,timestamp,rank from war_team_apply").

%%增加战队申请
insert_war_team_apply(Apply) ->
    Sql = io_lib:format(<<"insert into war_team_apply set `akey` =~p,`pkey` = ~p,`wtkey` = ~p,timestamp =~p">>,
        [Apply#wt_apply.akey, Apply#wt_apply.pkey, Apply#wt_apply.wtkey, Apply#wt_apply.timestamp]),
    db:execute(Sql).

%%删除指定的申请记录
del_war_team_apply(Key) ->
    Sql = io_lib:format("delete from war_team_apply where `akey`=~p", [Key]),
    db:execute(Sql).

%%删除玩家战队申请
del_war_team_apply_by_pkey(PKey) ->
    Sql = io_lib:format("delete from war_team_apply where pkey=~p", [PKey]),
    db:execute(Sql).

%%删除战队申请
del_war_team_apply_by_wtkey(WtKey) ->
    Sql = io_lib:format("delete from war_team_apply where wtkey=~p", [WtKey]),
    db:execute(Sql).

del_war_team_member_by_pkey(PKey) ->
    Sql = io_lib:format("update war_team_member set wtkey = 0 WHERE pkey  = ~p", [PKey]),
    db:execute(Sql).

%%删除战队
del_war_team(GuildKey) ->
    Sql = io_lib:format("delete from war_team where `wtkey` = ~p", [GuildKey]),
    db:execute(Sql).

%%更新战队数据
replace_war_team(G) ->
    Sql = io_lib:format(<<"replace into war_team set `wtkey` = ~p,name = '~s',num = ~p,pkey = ~p,pname = '~s',pcareer=~p,pvip=~p,create_time=~p,sn = ~p,win = ~p,lose = ~p,score = ~p">>,
        [
            G#war_team.wtkey
            , G#war_team.name
            , G#war_team.num
            , G#war_team.pkey
            , G#war_team.pname
            , G#war_team.pcareer
            , G#war_team.pvip
            , G#war_team.create_time
            , G#war_team.sn
            , G#war_team.win
            , G#war_team.lose
            , G#war_team.score
        ]),
    db:execute(Sql).

%%更新战队成员数据
replace_war_team_member(M) ->
    Sql = io_lib:format(<<"replace into war_team_member set
    pkey = ~p,wtkey = ~p,position = ~p,name = '~s',career = ~p,sex = ~p,lv = ~p,vip= ~p,join_time = ~p,att = ~p,der=~p,rank=~p,count=~p,use_role = '~s',`kill` = ~p">>,
        [
            M#wt_member.pkey
            , M#wt_member.wtkey
            , M#wt_member.position
            , M#wt_member.name
            , M#wt_member.career
            , M#wt_member.sex
            , M#wt_member.lv
%%             , M#wt_member.avatar = ""            %%头像
            , M#wt_member.vip
            , M#wt_member.join_time
            , M#wt_member.att
            , M#wt_member.der
            , M#wt_member.rank
            , M#wt_member.count
            , util:term_to_bitstring(M#wt_member.use_role)
            , M#wt_member.kill
        ]),
    db:execute(Sql).


%%加载战队成员数据
select_war_team_member() ->
    db:get_all("select `pkey`,wtkey,position, career, sex,lv,vip,join_time,att,der,rank,count,name,use_role,`kill` from war_team_member").
