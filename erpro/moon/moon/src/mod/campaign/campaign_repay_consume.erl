%%----------------------------------------------------
%% @doc 至尊消费特权
%%
%% 活动期间（可自由设置）玩家除市场以外的消费达到3000晶钻额度，便可获得消费返利特权。
%% 消费返利特权要求玩家活动期间内在商城（不包括抢购专区）再消费满3000晶钻，便可获得500非绑定晶钻的返利
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(campaign_repay_consume).

-export([
        listener/3
        ,get_info/1
        ,reward/1
    ]
).

%% 活动开始时间
-ifdef(debug).
-define(camp_repay_consume_start, util:datetime_to_seconds({{2013, 4, 9}, {0, 00, 01}})).
-define(camp_repay_consume_end, util:datetime_to_seconds({{2013, 4, 15}, {23, 59, 59}})).
-else.
-define(camp_repay_consume_start, util:datetime_to_seconds({{2013, 4, 13}, {0, 00, 01}})).
-define(camp_repay_consume_end, util:datetime_to_seconds({{2013, 4, 18}, {23, 59, 59}})).
-endif.
-define(camp_repay_consume_campid, 20130419).   %% 活动id

-define(camp_repay_consume_consume, 3000).      %% 达到特权晶钻数
-define(camp_repay_consume_shop, 3000).         %% 商城消费额度
-define(camp_repay_consume_reward, 500).        %% 奖励晶钻数

-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").
-include("mail.hrl").
-include("link.hrl").
-include("gain.hrl").

%%----------------------------------------------------
%% api
%%----------------------------------------------------

%% @spec listener(Label::atom(), Role::#role{}, Gold::internal()) -> NewRole::#role{}
%% 晶钻消费
listener(Role = #role{campaign = Campaign = #campaign_role{repay_consume = RepayConsume = #campaign_repay_consume{camp_id = CampId}}}, Label, Gold) ->
    Now = util:unixtime(),
    %% {Begin, End} = camp_time(),
    {AdmCampId, Begin, End} = get_camp_conf(),
    NewRepayConsume = case CampId =/= AdmCampId of
        true -> RepayConsume#campaign_repay_consume{camp_id = AdmCampId, status = 0, consume_all = 0, consume_shop = 0};
        _ -> RepayConsume
    end,
    case Now >= Begin andalso Now =< End of
        true -> do_consume(Label, Role#role{campaign = Campaign#campaign_role{repay_consume = NewRepayConsume}}, Gold);
        _ -> Role
    end.

%% @spec reward(Role::#role{}) -> {ok, NewRole::role{}} | {false, Reason::binary()}
%% 领取奖励
reward(Role = #role{link = #link{conn_pid = ConnPid}, campaign = Campaign = #campaign_role{repay_consume = RepayConsume = #campaign_repay_consume{camp_id = RoleCampId, status = 2, consume_shop = Shop}}}) ->
    Now = util:unixtime(),
    %% {Begin, End} = camp_time(),
    {AdmCampId, Begin, End} = get_camp_conf(),
    case AdmCampId =:= RoleCampId of
        true ->
            case Now >= Begin andalso Now =< End of
                true ->
                    case role_gain:do([#gain{label = gold, val = ?camp_repay_consume_reward}], Role) of
                        {ok, NewRole} ->
                            sys_conn:pack_send(ConnPid, 15872, {3, ?camp_repay_consume_consume, Shop, Now, End}),
                            notice:inform(util:fbin(?L(<<"获得 ~w晶钻">>), [?camp_repay_consume_reward])),
                            {ok, NewRole#role{campaign = Campaign#campaign_role{repay_consume = RepayConsume#campaign_repay_consume{status = 3}}}};
                        _ ->
                            {false, error}
                    end;
                false ->
                    {false, ?L(<<"活动已经结束">>)}
            end;
        false -> {false, ?L(<<"当前状态不可领取">>)}
    end;
reward(_Role) -> {false, ?L(<<"当前状态不可领取">>)}.

%% @spec get_info(Role) -> {Status, All, Shop}
%% 获取奖励
get_info(Role = #role{id = {RoleId, SrvId}, campaign = Campaign = #campaign_role{repay_consume = RepayConsume = #campaign_repay_consume{camp_id = CampId, status = Status, consume_all = All, consume_shop = Shop}}}) ->
    Now = util:unixtime(),
    %% {Begin, End} = camp_time(),
    {AdmCampId, Begin, End} = get_camp_conf(),
    case Now >= Begin andalso Now =< End of
        true ->
            case CampId =:= AdmCampId of
                true -> {Role, {Status, All, Shop, Now, End}};
                false -> {Role, {0, 0, 0, Now, End}}
            end;
        false ->
            case CampId =:= AdmCampId of
                true ->
                    case Status of
                        2 ->
                            Subject = ?L(<<"至尊消费特权奖励">>),
                            Content = util:fbin(?L(<<"亲好的仙友，您在活动期间参加了至尊消费特权活动，获得了如下奖励，请注意查收！">>), []),
                            MailGold = [{?mail_gold, ?camp_repay_consume_reward}],
                            mail_mgr:deliver({RoleId, SrvId}, {Subject, Content, MailGold, []}),
                            NewRole = Role#role{campaign = Campaign#campaign_role{repay_consume = RepayConsume#campaign_repay_consume{status = 3}}},
                            {NewRole, {4, 0, 0, Now, End}};
                        _ ->
                            {Role, {4, 0, 0, Now, End}}
                    end;
                false -> {Role, {0, 0, 0, Now, End}}
            end
    end.

%%----------------------------------------------------
%% internal
%%----------------------------------------------------
%% 消费事件
do_consume(_Label, Role = #role{campaign = #campaign_role{repay_consume = #campaign_repay_consume{status = Status}}}, _Gold) when Status =:= 2 orelse Status =:= 3 ->
    Role;
do_consume(Label, Role = #role{link = #link{conn_pid = ConnPid}, campaign = Campaign = #campaign_role{repay_consume = RepayConsume = #campaign_repay_consume{status = 0, consume_all = All, consume_shop = Shop}}}, Gold) ->
    {_Begin, End} = camp_time(),
    case (All + Gold) >= ?camp_repay_consume_consume of
        true ->
            sys_conn:pack_send(ConnPid, 15872, {1, ?camp_repay_consume_consume, Shop, util:unixtime(), End}),
            NewRole = Role#role{campaign = Campaign#campaign_role{repay_consume = RepayConsume#campaign_repay_consume{status = 1, consume_all = ?camp_repay_consume_consume}}},
            case Label of
                shop ->
                    Diff = (All + Gold) - ?camp_repay_consume_consume,
                    do_consume(Label, NewRole, Diff);
                _ -> NewRole
            end;
        _ -> 
            Role#role{campaign = Campaign#campaign_role{repay_consume = RepayConsume#campaign_repay_consume{consume_all = (All + Gold)}}}
    end;
do_consume(shop, Role = #role{link = #link{conn_pid = ConnPid}, campaign = Campaign = #campaign_role{repay_consume = RepayConsume = #campaign_repay_consume{status = 1, consume_all = All, consume_shop = Shop}}}, Gold) ->
    {_Begin, End} = camp_time(),
    case (Shop + Gold) >= ?camp_repay_consume_shop of
        true ->
            sys_conn:pack_send(ConnPid, 15872, {2, All, ?camp_repay_consume_shop, util:unixtime(), End}),
            Role#role{campaign = Campaign#campaign_role{repay_consume = RepayConsume#campaign_repay_consume{status = 2, consume_shop = ?camp_repay_consume_shop}}};
        _ ->
            sys_conn:pack_send(ConnPid, 15872, {1, ?camp_repay_consume_shop, (Shop + Gold), util:unixtime(), End}),
            Role#role{campaign = Campaign#campaign_role{repay_consume = RepayConsume#campaign_repay_consume{consume_shop = (Shop + Gold)}}}
    end;
do_consume(_Label, Role, _Gold) -> Role.

%% 活动时间
camp_time() ->
    campaign_adm:get_camp_time(repay_consume, {?camp_repay_consume_start, ?camp_repay_consume_end}).

%% 获取活动信息
get_camp_conf() ->
    {CampId, StartTime, EndTime} = campaign_adm:get_camp_conf(?camp_type_play_repay_consume, ?camp_repay_consume_campid, ?camp_repay_consume_start, ?camp_repay_consume_end),
    {CampId, StartTime, EndTime}.
