%% --------------------------
%% 活动至尊金卡 
%% @author shawn
%% --------------------------

-module(campaign_card).
-export([
        listen/2
        ,random_card/1
        ,get_role_info/1
        ,reload/0
    ]
).

-include("role.hrl").
-include("campaign.hrl").
-include("common.hrl").
-include("mail.hrl").
-include("link.hrl").

-define(type_no, 1). %% 未抽取特权
-define(type_already, 2). %% 已触发特权
-define(type_1, 3). %% 1.1充值 
-define(type_2, 4). %% 1.2充值 
-define(type_3, 5). %% 幸运石 
-define(type_4, 6). %% 护神丹 
-define(type_5, 7). %% 八门保护 
-define(type_6, 8). %% 仙宠 
-define(type_7, 9). %% 魔晶 
-define(type_8, 10). %% 妖灵 
-define(type_9, 11). %% 法宝 
-define(type_10, 12). %% 再来一次 

%% 充值累积阶段 {活动标识，开始时间，结束时间}
%% TODO 累积阶段的标识要跟回馈阶段的一致。
camp_charge_time() ->
    {Start, End} = campaign_adm:get_camp_time(charge_card),
    {TotalID, _CampId, _CondId} = campaign_adm:get_camp_id(charge_card, {0, 0, 0}),
    [
       {TotalID, Start, End}
       %%,{label_4, util:datetime_to_seconds({{2013, 4, 18}, {0, 0, 1}}), util:datetime_to_seconds({{2013, 4, 18}, {23, 59, 0}})}
    ].

%% 充值回馈阶段 {活动标识，抽取特权触发线，开始时间，结束时间}
camp_reward_time() ->
    {Start, End} = campaign_adm:get_camp_time(charge_card_reward),
    {TotalID, _CampId, _CondId} = campaign_adm:get_camp_id(charge_card_reward, {0, 0, 0}),
    [
        {TotalID, 3000, Start, End}
        %%,{label_4, 3000, util:datetime_to_seconds({{2013, 4, 18}, {0, 0, 1}}), util:datetime_to_seconds({{2013, 4, 18}, {23, 59, 59}})}
    ].

reload() ->
    role_group:apply(all, {fun do_reload/1, []}).
do_reload(Role) ->
    push_info(Role),
    {ok}.

push_info(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case get_role_info(Role) of
        {true, Time, Type, ItemList} ->
            sys_conn:pack_send(ConnPid, 15816, {1, Time, Type, ItemList});  
        {not_ready, Time} ->
            sys_conn:pack_send(ConnPid, 15816, {2, Time, 0, []});  
        _Err ->
            ?DEBUG("_Err:~w",[_Err]),
            {ok}
    end.

get_role_info(#role{campaign = #campaign_role{camp_card = {Label, Gold, Type}}}) ->
    Now = util:unixtime(),
    RewardList = camp_reward_time(),
    case lists:keyfind(Label, 1, RewardList) of
        {Label, Line, StarTime, EndTime} ->
            if
                Now >= StarTime andalso Now < EndTime ->
                    case Gold >= Line of
                        true ->
                            ItemList = [{T, V, N} || {T, V, N, _} <- gain_list()],
                            {true, EndTime - Now, Type, ItemList};
                        false -> gold_less
                    end;
                Now < StarTime ->
                    {not_ready, StarTime - Now + 5};
                true ->
                    time_out
            end;
        _ ->
            find_camp(RewardList, Now)
    end.

%% 查找是否有在队列中的活动
find_camp([], _Now) -> null_camp;
find_camp([{_Label, _, StarTime, _EndTime} | _T], Now) when Now < StarTime -> {not_ready, StarTime - Now + 5};
find_camp([_ | T], Now) -> find_camp(T, Now).


%% 监听充值
listen(Role, Gold) ->
    Now = util:unixtime(),
    ChargeList = camp_charge_time(),
    RewardList = camp_reward_time(),
    NewRole = do_charge(Now, ChargeList, Role, Gold),
    push_info(NewRole),
    NewRole2 = do_reward(Now, RewardList, NewRole, Gold),
    NewRole2.

%% 抽取特权
random_card(Role = #role{campaign = Camp = #campaign_role{camp_card = {Label, Gold, Type}}}) ->
    Now = util:unixtime(),
    RewardList = camp_reward_time(),
    case lists:keyfind(Label, 1, RewardList) of
        {Label, Line, StarTime, EndTime} ->
            case Now >= StarTime andalso Now < EndTime of
                true ->
                    case Type of
                        %% 没有抽取过
                        ?type_no ->
                            case Gold >= Line of
                                true ->
                                    GetType = random_type(),
                                    log:log(log_handle_all, {15817, <<"至尊特权抽取">>, util:fbin("抽到特权:~w",[GetType]), Role}),
                                    NewRole = Role#role{campaign = Camp#campaign_role{camp_card = {Label, Gold, GetType}}},
                                    {ok, NewRole};
                                false ->
                                    {false, util:fbin(<<"活动期间累积没有达到~w晶钻，不能参与至尊特权活动">>, [Line])}
                            end;
                        %% 再来一次
                        ?type_10 ->
                            case Gold >= Line of
                                true ->
                                    GetType = random_type(),
                                    log:log(log_handle_all, {15817, <<"至尊特权抽取">>, util:fbin("再来一次抽到特权:~w",[GetType]), Role}),
                                    NewRole = Role#role{campaign = Camp#campaign_role{camp_card = {Label, Gold, GetType}}},
                                    {ok, NewRole};
                                false ->
                                    {false, util:fbin(<<"活动期间累积没有达到~w晶钻，不能参与至尊特权活动">>, [Line])}
                            end;
                        %% 已经享受过
                        ?type_already ->
                            {false, <<"您已经享受过至尊特权，不能再次抽取">>};
                        _ ->
                            {false, <<"您已经抽取了至尊特权，充值即可享受充值特权了">>}
                    end;
                false ->
                    {false, <<"不在活动期间，无法抽取特权">>}
            end;
        _ ->
            {false, <<"不存在该至尊特权活动">>}
    end.

%% 触发活动充值累计
do_charge(_Now, [], Role, _Gold) -> Role;
do_charge(Now, [{Label, StarTime, EndTime} | T], Role = #role{campaign = Camp}, Gold) when Now >= StarTime andalso Now < EndTime ->
    {Gold1, Type} =  case Camp of
        #campaign_role{camp_card = {Label, G, T1}} -> {G, T1};
        _ -> {0, ?type_no}
    end,
    NewGold = Gold1 + Gold,
    NewRole = Role#role{campaign = Camp#campaign_role{camp_card = {Label, NewGold, Type}}},
    do_charge(Now, T, NewRole, Gold);
do_charge(Now, [_ | T], Role, Gold) ->
    do_charge(Now, T, Role, Gold).

%% 触发至尊特权奖励发放
do_reward(_Now, [], Role, _Gold) -> Role;
do_reward(Now, [{Label, NeedGold, StarTime, EndTime} | T], Role = #role{campaign = Camp, link = #link{conn_pid = ConnPid}}, Gold) when Now >= StarTime andalso Now < EndTime ->
    case Camp of
        %% 属于当前至尊卡活动，并且累积充值数已达底线
        #campaign_role{camp_card = {Label, G, Type}} when G >= NeedGold andalso Type =/= ?type_no andalso Type =/= ?type_already andalso Type =/= ?type_10 ->
            do_send_mail(Role, Type, Gold),
            log:log(log_handle_all, {15817, <<"至尊特权兑换">>, util:fbin("兑换特权:~w",[Type]), Role}),
            NewRole = Role#role{campaign = Camp#campaign_role{camp_card = {Label, G, ?type_already}}},
            case get_role_info(NewRole) of
                {true, GetTime, GetType, ItemList} ->
                    sys_conn:pack_send(ConnPid, 15816, {1, GetTime, GetType, ItemList});
                _ -> skip
            end,
            do_reward(Now, T, NewRole, Gold);
        _ ->
            do_reward(Now, T, Role, Gold)
    end;
do_reward(Now, [_ | T], Role, Gold) ->
    do_reward(Now, T, Role, Gold).
            

%% 随机抽取特权
random_type() ->
    Max = lists:sum([S || {_, S} <- ratio_list()]),
    Seed = util:rand(1, Max),
    do_get_type(Seed, ratio_list()).

do_get_type(Seed, [{Type, Rate} | _T]) when Seed =< Rate -> Type;
do_get_type(Seed, [{_Type, Rate} | T]) -> do_get_type(Seed - Rate, T).

ratio_list() ->
    [
        {?type_1, 34}
        ,{?type_2, 50}
        ,{?type_3, 2} 
        ,{?type_4, 2} 
        ,{?type_5, 2} 
        ,{?type_6, 2}
        ,{?type_7, 2} 
        ,{?type_8, 2} 
        ,{?type_9, 2} 
        ,{?type_10, 2} 
    ].

gain_list() ->
    [
        {?type_10, 40117, 0, <<>>}
        ,{?type_3, 21021, 2, <<"精品幸运石*2">>}
        ,{?type_4, 32001, 5, <<"护神丹*5">>}
        ,{?type_1, 40118, 0, <<>>}
        ,{?type_5, 33109, 5, <<"八门保护符*5">>}
        ,{?type_6, 23003, 5, <<"仙宠潜力保护符*5">>}
        ,{?type_7, 33085, 3, <<"魔晶碎片*3">>}
        ,{?type_8, 33150, 3, <<"妖灵残魂*3">>}
        ,{?type_2, 40119, 0, <<>>}
        ,{?type_9, 33151, 8, <<"法宝进阶丹*8">>}
    ].

%% 根据类型兑换奖品
type_to_item(Type, Gold) ->
    case lists:keyfind(Type, 1, gain_list()) of
        false -> skip;
        {Type, 40118, _Num, _Msg} ->
            Val = erlang:trunc(Gold * 0.1),
            case Val > 0 of
                false -> {[], [], <<"0晶钻">>};
                true ->
                    case Val >= 2000 of
                        true -> {[{?mail_gold, 2000}], [], <<"2000晶钻">>};
                        false -> {[{?mail_gold, Val}], [], util:fbin(<<"~w晶钻">>,[Val])}
                    end
            end;
        {Type, 40119, _Num, _Msg} ->
            Val = erlang:trunc(Gold * 0.2),
            case Val > 0 of
                false -> {[], [], <<"0晶钻">>};
                true ->
                    case Val >= 2000 of
                        true -> {[{?mail_gold, 2000}], [], <<"2000晶钻">>};
                        false -> {[{?mail_gold, Val}], [], util:fbin(<<"~w晶钻">>,[Val])}
                    end
            end;
        {Type, Id, Num, Msg} ->
            {[], [{Id, 1, Num}], Msg};
        _ -> skip
    end.

%% 发送奖励
do_send_mail(Role, Type, Gold) ->
    case type_to_item(Type, Gold) of
        skip -> skip;
        {Assest, Items, GainMsg} ->
            Subject = <<"至尊特权活动奖励">>,
            Content = util:fbin(<<"亲爱的玩家，恭喜您使用至尊白金特权，充值~w晶钻，获得奖励~s">>, [Gold, GainMsg]),
            mail_mgr:deliver(Role, {Subject, Content, Assest, Items})
    end.
