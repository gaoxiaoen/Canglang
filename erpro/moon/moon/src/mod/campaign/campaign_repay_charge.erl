%%----------------------------------------------------
%% @doc 单笔充值500以上返利
%% 
%% @author jackguan@jieyou.cn
%% @end
%%----------------------------------------------------
-module(campaign_repay_charge).
-export([
        repay_single/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("mail.hrl").

-ifdef(debug).
%% 活动开始时间
-define(camp_repay_time_start, util:datetime_to_seconds({{2013, 2, 13}, {12, 00, 00}})).
-else.
%% 活动开始时间
-define(camp_repay_time_start, util:datetime_to_seconds({{2013, 3, 9}, {00, 00, 01}})).
-endif.
%% 活动结束时间
-define(camp_repay_time_end, util:datetime_to_seconds({{2013, 3, 11}, {23, 59, 59}})).
-define(camp_repay_rela_single, 500). %% 充值多少返还晶钻

%% 邮件
-define(camp_repay_mail_content, <<"亲爱的玩家，飞仙周年庆活动期间，您单笔充值达到500晶钻以上，获得了15%非绑定晶钻返利，请注意查收！感谢您在过去的一年中对梦幻飞仙的鼎力支持，一路有你，精彩无限，您的支持将会是我们的无限动力，祝您游戏愉快！">>).

%% 单次充值返现
%% @spec repay_single(Role, Gold) -> ok
repay_single(_Role, Gold) when Gold < ?camp_repay_rela_single -> ok;
repay_single(_Role = #role{id = {RoleId, SrvId}, name = Name}, Gold) ->
    Now = util:unixtime(),
    Beg = ?camp_repay_time_start,
    End = ?camp_repay_time_end,
    case Now >= Beg andalso Now =< End of
        true ->
            SList = [{RoleId, SrvId, ?camp_repay_mail_content, Name}],
            do_send_mail(SList, Gold);
        false -> ok
    end.

do_send_mail([], _Gold) -> ok;
do_send_mail([{RoleId, SrvId, Content, _Name} | T], Gold) ->
    Subject = ?L(<<"现金返利，笔笔超值">>),
    G = round(Gold * 0.15),
    MailGold = [{?mail_gold, G}],
    mail_mgr:deliver({RoleId, SrvId}, {Subject, Content, MailGold, []}),
    do_send_mail(T, Gold).
