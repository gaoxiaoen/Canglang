%%----------------------------------------------------
%% 活动版本转换
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(campaign_parse).
-export([do/1]).

-include("common.hrl").
-include("campaign.hrl").

do({campaign_role, Ver = 0, FirstCharge, DayOnline, AccGold, LastGold}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, undefined, []});
do({campaign_role, Ver = 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, []});
do({campaign_role, Ver = 2, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, []});
do({campaign_role, Ver = 3, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, {0, 0}});
do({campaign_role, Ver = 4, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, []});
do({campaign_role, Ver = 5, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, {label, 0, 0}});
do({campaign_role, Ver = 6, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, #campaign_spring_festive{}});
do({campaign_role, Ver = 7, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, SpringFestive}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, SpringFestive, #campaign_lottery_gold{}});
do({campaign_role, Ver = 8, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, SpringFestive, LotteryGold}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, SpringFestive, LotteryGold, #campaign_repay_consume{}});
do({campaign_role, Ver = 9, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, SpringFestive, LotteryGold, RepayConsume}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, SpringFestive, LotteryGold, RepayConsume, #campaign_suit{}});

do({campaign_role, Ver = 10, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, SpringFestive, LotteryGold, RepayConsume, Suit}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, SpringFestive, LotteryGold, RepayConsume, Suit, []});

do({campaign_role, Ver = 11, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, SpringFestive, LotteryGold, RepayConsume, Suit, Accumulative}) ->
    do({campaign_role, Ver + 1, FirstCharge, DayOnline, AccGold, LastGold, LossGold, RewardList, TaskList, SpecialList, KeepDays, MailList, CampCard, SpringFestive, LotteryGold, RepayConsume, Suit, Accumulative, #model_worker{}});


do(Camp = #campaign_role{ver = ?CAMP_VER}) ->
    {ok, Camp};
do(_) ->
    ?ERR("活动版本数据转换失败"),
    {false, ?L(<<"活动版本转换失败">>)}.
