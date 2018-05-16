%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 九月 2016 下午6:04
%%%-------------------------------------------------------------------
-module(facebook).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("daily.hrl").

%% API
-export([reward/2,facebook_check_invite/1,fackbook_invite_num/1]).

reward(Player,1) ->
    ?DEBUG("DAILY_FACEBOOK_REG_REWARD_1"),
    if
        Player#player.lv < 10 ->
            ?DEBUG("DAILY_FACEBOOK_REG_REWARD_2"),
            Count = daily:get_count(?DAILY_FACEBOOK_REG_REWARD),
            if
                Count == 0 ->
                    ?DEBUG("DAILY_FACEBOOK_REG_REWARD_3"),
                    Title = ?T("FackBook专属福利"),
                    Content = ?T("欢迎来到【武动九天】的幻想世界，小小见面礼，助你畅玩游戏！如果您喜欢我们的游戏，请分享更多的朋友，祝游戏愉快！"),
                    mail:sys_send_mail([Player#player.key],Title,Content,[{10106,100},{20001,20},{20704,3},{10109,200000}]),
                    daily:set_count(?DAILY_FACEBOOK_REG_REWARD,1);
                true ->
                    skip
            end;
        true ->
            skip
    end,
    ok;

reward(Player,2) ->
    Count = daily:get_count(?DAILY_FACEBOOK_SHARE_REWARD),
    Lv = Player#player.lv,
    if
        Count == 0 ->
            GoodsList = if
                            Lv =< 30 ->
                                [{10106,30},{20001,20},{20704,2},{10109,30000}];
                            Lv =< 40 ->
                                [{10106,40},{20001,20},{20704,3},{10109,50000}];
                            Lv =< 50 ->
                                [{10106,50},{20001,50},{20704,4},{10109,100000}];
                            Lv =< 60 ->
                                [{10106,60},{20001,50},{20704,5},{10109,100000}];
                            true ->
                                [{10106,100},{20001,80},{20704,5},{10109,200000}]
                end,
            Title = ?T("分享福利"),
            Content = ?T("如果您喜欢我们的游戏，请分享更多的朋友，祝游戏愉快！"),
            mail:sys_send_mail([Player#player.key],Title,Content,GoodsList),
            daily:set_count(?DAILY_FACEBOOK_SHARE_REWARD,1);
        true ->
            skip

    end,
    ok;

reward(Player,3) ->
    Count = daily:get_count(?DAILY_FACEBOOK_INVITE_REWARD),
    Lv = Player#player.lv,
    if
        Count == 0 ->
            GoodsList = if
                            Lv =< 30 ->
                                [{20340,10},{20001,20},{10109,30000}];
                            Lv =< 40 ->
                                [{20340,10},{20001,20},{10109,50000}];
                            Lv =< 50 ->
                                [{20340,20},{20001,50},{10109,100000}];
                            Lv =< 60 ->
                                [{20340,20},{20001,50},{10109,100000}];
                            true ->
                                [{20340,20},{20001,80},{10109,200000}]
                        end,
            Title = ?T("邀请福利"),
            Content = ?T("如果您喜欢我们的游戏，请邀请更多的朋友，祝游戏愉快！"),
            mail:sys_send_mail([Player#player.key],Title,Content,GoodsList),
            daily:set_count(?DAILY_FACEBOOK_INVITE_REWARD,1);
        true ->
            skip
    end,
    ok;

reward(_Player,_) ->
    ok.

%%获取已成功邀请数量
fackbook_invite_num(Player) ->
    Sql = io_lib:format("select invite_num from facebook_invite where pkey = ~p",[Player#player.key]),
    case db:get_row(Sql) of
        [] ->
            0;
        [InviteNum] ->
            util:to_integer(InviteNum)

    end.

%%成功邀请奖励
facebook_check_invite(Player) ->
    Url = lists:concat([config:get_api_url(),"/fb.php?act=check&from_uid=",Player#player.accname]),
    ?DEBUG("Url:~p~n",[Url]),
    case catch httpc:request(Url) of
        {ok, {_, _, Num}} ->
            Invited = util:to_integer(Num),
            Sql = io_lib:format("select invite_num from facebook_invite where pkey = ~p",[Player#player.key]),
            RewardNum =
                case db:get_row(Sql) of
                    [] ->
                        Invited;
                    [InviteNum] ->
                        Invited - InviteNum
                end,
            ?DEBUG("FB:~p/~p/~p~n",[Num,Invited,RewardNum]),
            if
                RewardNum > 0 ->
                    Title = ?T("好友助战"),
                    Content = ?T("你成功邀请了~p位好友来到【武动九天】的幻想世界，有您和好友的帮助，消灭大魔王，维护幻想世界的和平指日可待！小小礼物，请笑纳！如果你喜欢我们的游戏，请分享给更多的朋友，祝游戏愉快！"),
                    Content2 = io_lib:format(Content,[RewardNum]),
                    mail:sys_send_mail([Player#player.key],Title,Content2,[{10106,10 * RewardNum},{20340,10 * RewardNum},{20001,10 * RewardNum}]),
                    Sql2 = io_lib:format("replace into facebook_invite set pkey = ~p , invite_num = ~p ",[Player#player.key,Invited]),
                    db:execute(Sql2),
                    if
                        Invited == 5 orelse Invited == 10 orelse Invited == 20 ->
                            GList = case Invited of
                                       5 -> [{10106,500}];
                                       10 -> [{10106,500},{42004,1}];
                                       _ -> [{10106,500},{20177,1}]
                                   end,
                            T = ?T("邀请成就"),
                            C = ?T("恭喜你已成功邀请~p位好友来到【武动九天】的幻想世界，有您和好友的帮助，消灭大魔王，维护幻想世界的和平指日可待！小小礼物，请笑纳！如果你喜欢我们的游戏，请分享给更多的朋友，祝游戏愉快！"),
                            C2 = io_lib:format(C,[Invited]),
                            mail:sys_send_mail([Player#player.key],T,C2,GList);
                        true ->
                            skip
                    end ;
                true ->
                    skip

            end;
        _ ->
            skip
    end,
    ok.




