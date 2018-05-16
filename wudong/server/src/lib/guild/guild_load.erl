%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 17:17
%%%-------------------------------------------------------------------
-module(guild_load).
-author("hxming").

-include("guild.hrl").
%% API
-compile(export_all).

cmd() ->
    replace_guild(#guild{}).

%%加载仙盟数据
select_guild() ->
    db:get_all("select `gkey`,`name`,cn_time,icon,icon_list,realm,lv,num,pkey,pname,pcareer,pvip,notice,log,dedicate,acc_task,`type`,sys_id,`condition`,create_time,last_hy_key,last_hy_val,like_times,hy_gift_time,max_pass_floor,pass_pkey,pass_floor_list,pass_update_time,boss_star,boss_exp,boss_state,last_name from guild").

%%更新仙盟数据
replace_guild(G) ->
    Notice =
        case util:filter_utf8(G#guild.notice) == G#guild.notice of
            false -> "";
            true -> G#guild.notice
        end,
    Sql = io_lib:format("replace into guild set `gkey` = ~p,name = '~s',cn_time = ~p,icon = ~p,icon_list = '~s',realm = ~p,lv = ~p,num = ~p,pkey = ~p,pname = '~s',pcareer=~p,pvip=~p,notice = '~s',log = '~s',dedicate = ~p,acc_task = ~p,`type`=~p,sys_id =~p,`condition`= '~s',create_time=~p,last_hy_key=~p,last_hy_val=~p,like_times=~p,hy_gift_time=~p,max_pass_floor=~p,pass_pkey=~p,pass_floor_list='~s',pass_update_time=~p,boss_star=~p,boss_exp=~p,boss_state=~p,last_name='~s'",
        [G#guild.gkey,
            util:filter_utf8(G#guild.name),
            G#guild.cn_time,
            G#guild.icon,
            util:term_to_bitstring(G#guild.icon_list),
            G#guild.realm,
            G#guild.lv,
            G#guild.num,
            G#guild.pkey,
            G#guild.pname,
            G#guild.pcareer,
            G#guild.pvip,
            Notice,
            util:term_to_bitstring(lists:sublist(G#guild.log, ?GUILD_LOG_LEN)),
            G#guild.dedicate,
            G#guild.acc_task,
            G#guild.type,
            G#guild.sys_id,
            util:term_to_bitstring(G#guild.condition),
            G#guild.create_time,

            G#guild.last_hy_key,
            G#guild.last_hy_val,
            G#guild.like_times,
            G#guild.hy_gift_time,

            G#guild.max_pass_floor,
            G#guild.pass_pkey,
            util:term_to_bitstring(G#guild.pass_floor_list),
            G#guild.pass_update_time,

            G#guild.boss_star,
            G#guild.boss_exp,
            G#guild.boss_state,
            util:filter_utf8(G#guild.last_name)
        ]),
    db:execute(Sql).

%%删除仙盟
del_guild(GuildKey) ->
    Sql = io_lib:format("delete from guild where `gkey` = ~p", [GuildKey]),
    db:execute(Sql).

%%加载仙盟成员数据
select_guild_member() ->
    Sql = "select m.pkey,m.gkey,m.position,
    m.acc_dedicate,m.leave_dedicate,m.daily_dedicate,m.dedicate_time,
    m.jc_hy_val,m.jc_hy_time,m.sum_hy_val,m.like_time,
    m.daily_gift_get_time,
    m.highest_pass_floor,m.pass_floor,m.cheer_times,m.cheer_keys,m.be_cheer_times,m.cheer_me_keys,m.demon_update_time,m.get_demon_gift_list,m.help_cheer_list,m.help_cheer_time,
    m.acc_task,m.task_log,m.task_time,m.timestamp,m.war_p,m.h_war_p,p.nickname,p.career,p.sex,p.lv,p.realm,p.combat_power,p.highest_combat_power,p.vip_lv,l.last_login_time,l.avatar
    from guild_member AS m
    left join player_state as p on m.pkey = p.pkey left join player_login as l on m.pkey=l.pkey",
    db:get_all(Sql).

%%更新仙盟成员数据
replace_guild_member(M) ->
    Sql = io_lib:format(<<"replace into guild_member set pkey = ~p,gkey = ~p,position = ~p,
        acc_dedicate=~p,leave_dedicate=~p,daily_dedicate=~p,dedicate_time=~p,
        jc_hy_val=~p,jc_hy_time=~p,sum_hy_val=~p,like_time=~p,
        daily_gift_get_time=~p,
        highest_pass_floor=~p,pass_floor=~p,cheer_times=~p,cheer_keys='~s',be_cheer_times=~p,cheer_me_keys='~s',
        demon_update_time=~p,get_demon_gift_list='~s',help_cheer_list='~s',help_cheer_time=~p,
        acc_task = ~p,task_log = '~s',task_time =~p,timestamp=~p,war_p=~p,h_war_p=~p">>,
        [M#g_member.pkey,
            M#g_member.gkey,
            M#g_member.position,
            M#g_member.acc_dedicate,
            M#g_member.leave_dedicate,
            M#g_member.daily_dedicate,
            M#g_member.dedicate_time,

            M#g_member.jc_hy_val,
            M#g_member.jc_hy_time,
            M#g_member.sum_hy_val,
            M#g_member.like_time,

            M#g_member.daily_gift_get_time,

            M#g_member.highest_pass_floor,
            M#g_member.pass_floor,
            M#g_member.cheer_times,
            util:term_to_bitstring(M#g_member.cheer_keys),
            M#g_member.be_cheer_times,
            util:term_to_bitstring(M#g_member.cheer_me_keys),
            M#g_member.demon_update_time,
            util:term_to_bitstring(M#g_member.get_demon_gift_list),
            util:term_to_bitstring(M#g_member.help_cheer_list),
            M#g_member.help_cheer_time,

            M#g_member.acc_task,
            util:term_to_bitstring(M#g_member.task_log),
            M#g_member.task_time,
            M#g_member.timestamp,
            M#g_member.war_p,
            M#g_member.h_war_p
        ]),
    db:execute(Sql).


%%删除指定的玩家仙盟
del_guild_member(GKey) ->
    Sql = io_lib:format("delete from guild_member where gkey = ~p", [GKey]),
    db:execute(Sql).

del_guild_member_by_pkey(PKey) ->
    Sql = io_lib:format("delete from guild_member where pkey = ~p", [PKey]),
    db:execute(Sql).


%%加载仙盟申请数据
select_guild_apply() ->
    Sql = "select a.akey,a.pkey,a.gkey,a.from,a.timestamp,p.nickname,p.career,p.lv,p.combat_power from guild_apply AS a left join player_state as p on a.pkey=p.pkey",
    db:get_all(Sql).

%%增加仙盟申请
insert_guild_apply(Apply) ->
    Sql = io_lib:format(<<"insert into guild_apply set `akey` =~p,`pkey` = ~p,`gkey` = ~p,`from` = ~p,timestamp =~p">>,
        [Apply#g_apply.akey, Apply#g_apply.pkey, Apply#g_apply.gkey, Apply#g_apply.from, Apply#g_apply.timestamp]),
    db:execute(Sql).

%%删除指定的申请记录
del_guild_apply(Key) ->
    Sql = io_lib:format("delete from guild_apply where `akey`=~p", [Key]),
    db:execute(Sql).

%%删除玩家仙盟申请
del_guild_apply_by_pkey(PKey) ->
    Sql = io_lib:format("delete from guild_apply where pkey=~p", [PKey]),
    db:execute(Sql).

%%删除仙盟申请
del_guild_apply_by_gkey(GKey) ->
    Sql = io_lib:format("delete from guild_apply where gkey=~p", [GKey]),
    db:execute(Sql).

%%增加仙盟技能
replace_guild_skill(Skill) ->
    Sql = io_lib:format("replace into guild_skill set pkey = ~p,skill_list = '~s'", [Skill#g_skill.pkey, util:term_to_bitstring(Skill#g_skill.skill_list)]),
    db:execute(Sql).

%%加载仙盟技能
select_guild_skill(Pkey) ->
    Sql = io_lib:format("select skill_list from guild_skill where pkey = ~p ", [Pkey]),
    db:get_row(Sql).

%%加载玩家仙盟历史
load_guild_history() ->
    Sql = "select pkey,time ,q_time,q_times,daily_gift_get_time,pass_floor,cheer_times,cheer_keys,be_cheer_times,demon_update_time,get_demon_gift_list  from guild_history",
    db:get_all(Sql).

%%更新玩家仙盟历史
replace_guild_history(History) ->
    #g_history{
        pkey = Pkey,
        time = Time,
        q_times = Qtimes,
        q_time = Qtime

        , daily_gift_get_time = DailyGiftGetTime

        , pass_floor = PassFloor
        , cheer_times = CheerTimes
        , cheer_keys = CheerKeys
        , be_cheer_times = BeCheerTimes
        , demon_update_time = DemonUpdateTime
        , get_demon_gift_list = GetDemonGiftList
    } = History,
    Sql = io_lib:format("replace into guild_history set pkey=~p,time=~p,q_time=~p,q_times=~p,daily_gift_get_time=~p,pass_floor=~p,cheer_times=~p,cheer_keys='~s',be_cheer_times=~p,demon_update_time=~p,get_demon_gift_list='~s'",
        [Pkey, Time, Qtime, Qtimes, DailyGiftGetTime, PassFloor, CheerTimes, util:term_to_bitstring(CheerKeys),
            BeCheerTimes, DemonUpdateTime, util:term_to_bitstring(GetDemonGiftList)]),
    db:execute(Sql),
    ok.

del_guild_history(Pkey) ->
    Sql = io_lib:format("delete from guild_history where pkey = ~p", [Pkey]),
    db:execute(Sql).

log_guild(Gkey, Gname, Pkey, Pname, Type, Time) ->
    Sql = io_lib:format("insert into log_guild set pkey=~p,nickname = '~s',gkey=~p,gname = '~s',type=~p,time=~p",
        [Pkey, Pname, Gkey, Gname, Type, Time]),
    log_proc:log(Sql),
    ok.

log_guild_mb(Gkey, Gname, Pkey, Pname, Type, Time, Posold, Posnew) ->
    Sql = io_lib:format("insert into log_guild_mb set pkey=~p,nickname = '~s',gkey=~p,gname = '~s',type=~p,pos_old = ~p,pos_new=~p,time=~p",
        [Pkey, Pname, Gkey, Gname, Type, Posold, Posnew, Time]),
    log_proc:log(Sql),
    ok.


log_guild_skill(Pkey, Nickname, Id, OldLv, NewLv, Time) ->
    Sql = io_lib:format("insert into log_guild_skill set pkey=~p,nickname = '~s',sid=~p,old_lv=~p,new_lv=~p,time=~p",
        [Pkey, Nickname, Id, OldLv, NewLv, Time]),
    log_proc:log(Sql),
    ok.

log_guild_dedicate(Pkey, Nickname, Gkey, GoodsNum, GoldNum, Time, Dedicate, AccDedicate, LeaveDedicate, Msg) ->
    Sql = io_lib:format("insert into log_guild_dedicate set pkey=~p,nickname = '~s',gkey=~p,goods_num=~p,gold_num=~p,dedicate = ~p, acc_dedicate = ~p, leave_dedicate = ~p,time=~p, Msg='~s'",
        [Pkey, Nickname, Gkey, GoodsNum, GoldNum, Dedicate, AccDedicate, LeaveDedicate, Time, Msg]),
    log_proc:log(Sql),
    ok.

log_guild_name(Gkey, NameOld, NameNew, Pkey, Time) ->
    Sql = io_lib:format("insert into log_guild_name set gkey=~p,name_old='~s',name_new='~s',pkey = ~p,time=~p",
        [Gkey, NameOld, NameNew, Pkey, Time]),
    log_proc:log(Sql),
    ok.
