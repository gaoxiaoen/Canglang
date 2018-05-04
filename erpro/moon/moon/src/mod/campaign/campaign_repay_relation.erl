%%----------------------------------------------------
%% @doc 充值返现，惠及好友家人
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(campaign_repay_relation).
-export([
        repay_single/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("mail.hrl").
-include("sworn.hrl").

-ifdef(debug).
%% 活动开始时间
-define(camp_repay_time_start, util:datetime_to_seconds({{2013, 2, 13}, {12, 00, 00}})).
-else.
%% 活动开始时间
-define(camp_repay_time_start, util:datetime_to_seconds({{2013, 3, 12}, {00, 00, 01}})).
-endif.
%% 活动结束时间
-define(camp_repay_time_end, util:datetime_to_seconds({{2013, 3, 15}, {23, 59, 59}})).
-define(camp_repay_rela_single, 1000). %% 充值多少返还晶钻

%% 邮件
-define(camp_repay_mail_content1, <<"亲爱的玩家，活动期间，您的结拜好友~s单笔充值了~w晶钻，您获得了充值金额3%绑定晶钻返现，请注意查收！感谢您的支持，祝您游戏愉快！">>). %% 结拜
-define(camp_repay_mail_content2, <<"亲爱的玩家，活动期间，您的夫君~s单笔充值了~w晶钻，您获得了充值金额3%绑定晶钻返现，请注意查收！感谢您的支持，祝您游戏愉快！">>).
-define(camp_repay_mail_content3, <<"亲爱的玩家，活动期间，您的娘子~s单笔充值了~w晶钻，您获得了充值金额3%绑定晶钻返现，请注意查收！感谢您的支持，祝您游戏愉快！">>).

%% 单次充值返现
%% @spec repay_single(Role, Gold) -> ok
repay_single(_Role, Gold) when Gold < ?camp_repay_rela_single -> ok;
repay_single(_Role = #role{id = {RoleId, SrvId}, name = Name}, Gold) ->
    Now = util:unixtime(),
    Beg = ?camp_repay_time_start,
    End = ?camp_repay_time_end,
    case Now >= Beg andalso Now =< End of
        true ->
            SList = case ets:lookup(ets_role_sworn, {RoleId, SrvId}) of
                [#sworn_info{member = Memberlist}] when Memberlist =/= [] ->
                    case length(Memberlist) =< 2 of
                        true ->
                             [{MRid, MSrvId, ?camp_repay_mail_content1, Name} || #sworn_member{id = {MRid, MSrvId}} <- Memberlist];
                        false -> []
                    end;
                _ -> [] 
            end,
            do_send_mail(SList, Gold);
        false -> ok
    end.

do_send_mail([], _Gold) -> ok;
do_send_mail([{RoleId, SrvId, Ct, Name} | T], Gold) ->
    Subject = ?L(<<"充值返现，惠及好友家人">>),
    G = round(Gold * 0.03),
    Content = util:fbin(Ct, [Name, Gold]),
    MailGold = [{?mail_gold_bind, G}],
    mail_mgr:deliver({RoleId, SrvId}, {Subject, Content, MailGold, []}),
    do_send_mail(T, Gold).
