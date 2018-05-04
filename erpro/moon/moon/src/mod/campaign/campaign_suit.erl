%%----------------------------------------------------
%% @doc 套装活动
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(campaign_suit).

-export([
        login/1
        ,charge/2
        ,reward/3
        ,get_suit_info/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").
-include("mail.hrl").
-include("gain.hrl").
-include("link.hrl").

%% 活动开始时间
-ifdef(debug).
-define(camp_suit_start, util:datetime_to_seconds({{2013, 4, 10}, {0, 00, 01}})).
-define(camp_suit_end, util:datetime_to_seconds({{2013, 4, 13}, {15, 40, 59}})).
-else.
-define(camp_suit_start, util:datetime_to_seconds({{2013, 4, 13}, {0, 00, 01}})).
-define(camp_suit_end, util:datetime_to_seconds({{2013, 4, 13}, {23, 59, 59}})).
-endif.
-define(camp_suit_campid, 20130408).   %% 活动id
-define(camp_suit_index1, 888).   %% 第一件
-define(camp_suit_index2, 1888).   %% 第二件
-define(camp_suit_index3, 3888).   %% 第三件


%%----------------------------------------------------
%% api
%%----------------------------------------------------
%% @spec login(Role::#role{}) -> NewRole::#role{}
%% 活动登陆事件
login(Role = #role{id = {RoleId, SrvId}, campaign = Campaign = #campaign_role{suit = Suit}}) ->
    NewSuit = init_suit({RoleId, SrvId}, Suit),
    Role#role{campaign = Campaign#campaign_role{suit = NewSuit}}.

%% @spec charge(Role::#role{}, Gold::integer()) -> NewRole
%% 充值
charge(Role = #role{link = #link{conn_pid = ConnPid}, id = {RoleId, SrvId}, campaign = Campaign = #campaign_role{suit = Suit}}, Gold) ->
    Now = util:unixtime(),
    Start = ?camp_suit_start,
    End = ?camp_suit_end,
    case Now >= Start andalso Now =< End of
        true ->
            NewSuit = init_suit({RoleId, SrvId}, Suit),
            NewSuit2 = #campaign_suit{target_list = TargetList, fill_list = FillList} = do_charge(NewSuit, Gold),
            {ok, SuitData} = get_suit_info(TargetList, FillList),
            sys_conn:pack_send(ConnPid, 15874, SuitData),
            Role#role{campaign = Campaign#campaign_role{suit = NewSuit2}};
        false -> Role
    end.

%% @spec reward(Role::#role{}, Step, Index) -> {ok, NewRole} | {false, Reason}
%% 领奖励
reward(Role = #role{id = {RoleId, SrvId}, campaign = Campaign = #campaign_role{suit = Suit = #campaign_suit{fill_list = FillList}}}, Step, Index) ->
    case do_reward(FillList, Step, Index) of
        {ok, ItemId, NewFillList} ->
            NewRole = Role#role{campaign = Campaign#campaign_role{suit = Suit#campaign_suit{fill_list = NewFillList}}},
            case role_gain:do([#gain{label = item, val = [ItemId, 1, 1]}], NewRole) of
                {ok, NewRole2} ->
                    Str = notice:gain_to_item3_inform([#gain{label = item, val = [ItemId, 1, 1]}]),
                    notice:inform(util:fbin(?L(<<"获得~s">>), [Str])),
                    case [D || D = {6, 3, _, _} <- NewFillList] of
                        [] -> ignore;
                        [{6, 3, Status, _Gold}] when Status =:= 2 ->
                            Subject = ?L(<<"时装套装，华美巨献">>),
                            Content = util:fbin(?L(<<"亲爱的仙友，您在活动期间，集齐了六件精美时装部件，组成了完整的时装套装，除享受额外属性加成以外，您还获得了【强者争霸礼包】*2，请注意查收！">>), []),
                            ItemList = [{29526, 1, 2}],
                            mail_mgr:deliver({RoleId, SrvId}, {Subject, Content, [], ItemList});
                        [{6, 3, _Status, _Gold}] -> ignore
                    end,
                    {ok, NewRole2};
                _Reason -> 
                    ?DEBUG("==================Reason:~w", [_Reason]),
                    {false, ?L(<<"背包满了">>)}
            end;
        {false,Reason} ->
            {false, Reason}
    end.

%% @spec get_suit_info(TargetList, FillList) -> {ok, SuitData}
%% 获取套装活动界面信息
get_suit_info(TargetList = [{Step, Index, _Status, GoldVal} | _T], FillList) ->
    SuitGifts = parse_suit_gifts(TargetList ++ FillList),
    NewVal = case Index of
        1 -> GoldVal;
        2 -> ?camp_suit_index1 + GoldVal;
        3 -> ?camp_suit_index2 + GoldVal
    end,
    {ok, {Step, Index, NewVal, ?camp_suit_start, ?camp_suit_end, SuitGifts}};
get_suit_info([], FillList) ->
    SuitGifts = parse_suit_gifts(FillList),
    {ok, {6, 3, ?camp_suit_index3, ?camp_suit_start, ?camp_suit_end, SuitGifts}};
get_suit_info(_TargetList, _FillList) ->
    {ok, {1,1,0, ?camp_suit_start, ?camp_suit_end, []}}.

%%----------------------------------------------------
%% internal
%%----------------------------------------------------
init_suit({RoleId, SrvId}, Suit = #campaign_suit{camp_id = ?camp_suit_campid, fill_list = FillList}) ->
    Now = util:unixtime(),
    End = ?camp_suit_end,
    case End > Now of
        true -> %% 活动没有结束
            Suit;
        false -> %% 已经结束
            NewFillList = do_fill({RoleId, SrvId}, FillList),
            Suit#campaign_suit{camp_id = 0, fill_list = NewFillList}
    end;
init_suit({_RoleId, _SrvId}, Suit = #campaign_suit{}) -> %% CampId 不一样
    Now = util:unixtime(),
    Start = ?camp_suit_start,
    End = ?camp_suit_end,
    case {End > Now, Now > Start} of
        {true, true} -> %% 活动期间
            TargetList = new_target_list(1, 1),
            Suit#campaign_suit{camp_id = ?camp_suit_campid, fill_list = [], target_list = TargetList};
        {false, _} -> %% 活动结束
            Suit;
        {_,  false} -> %% 活动还没有开始
            Suit
    end.

%% @spec new_target_list(Step, Index) -> [{Step, Index, Status, Val}]
%% 初始化
new_target_list(6, 3) -> [{6, 3, 0, 0}];
new_target_list(Step, Index) ->
    {NewStep, NewIndex} = case Index =:= 3 of
        true -> {Step + 1, 1};
        false -> {Step, Index + 1}
    end,
    [{Step, Index, 0, 0} | new_target_list(NewStep, NewIndex)].
index_val(1) -> ?camp_suit_index1;
index_val(2) -> ?camp_suit_index2;
index_val(3) -> ?camp_suit_index3.

%% 物品信息
get_item_id(1, 1) -> 29570;
get_item_id(1, 2) -> 29571;
get_item_id(1, 3) -> 29574;
get_item_id(2, 1) -> 29570;
get_item_id(2, 2) -> 29571;
get_item_id(2, 3) -> 29573;
get_item_id(3, 1) -> 29570;
get_item_id(3, 2) -> 29571;
get_item_id(3, 3) -> 29576;
get_item_id(4, 1) -> 29570;
get_item_id(4, 2) -> 29571;
get_item_id(4, 3) -> 29577;
get_item_id(5, 1) -> 29570;
get_item_id(5, 2) -> 29571;
get_item_id(5, 3) -> 29575;
get_item_id(6, 1) -> 29570;
get_item_id(6, 2) -> 29571;
get_item_id(6, 3) -> 29572;
get_item_id(_Step, _Index) -> 1.

%% 过期，补发没领取奖励
do_fill({_RoleId, _SrvId}, []) -> [];
do_fill({RoleId, SrvId}, [{Step, Index, 1, Val} | T]) ->
    Subject = ?L(<<"套装">>),
    Content = util:fbin(?L(<<"亲好的仙友，套装补发，请注意查收！">>), []),
    ItemList = [{get_item_id(Step, Index), 1, 1}],
    mail_mgr:deliver({RoleId, SrvId}, {Subject, Content, [], ItemList}),
    [{Step, Index, 2, Val} | do_fill({RoleId, SrvId}, T)];
do_fill({RoleId, SrvId}, [H | T]) ->
    [H | do_fill({RoleId, SrvId}, T)].

%% 充值
do_charge(Suit = #campaign_suit{target_list = []}, _Gold) -> Suit;
do_charge(Suit, Gold) when Gold =< 0 -> Suit;
do_charge(Suit = #campaign_suit{fill_list = FillList, target_list = _TarL = [{Step, Index, 0, Val} | T]}, Gold) ->
    TargetVal = case Index of
        1 -> index_val(Index);
        2 -> index_val(Index) - index_val(Index - 1);
        3 -> index_val(Index) - index_val(Index - 1)
    end,
    Now = util:unixtime(),
    Start = ?camp_suit_start + 1,
    NowStep = util:ceil(((Now - util:unixtime({today, Start})) / 86400)),
    case NowStep >= Step of
        true -> %% 有效
            case (Gold + Val) >= TargetVal of
                true ->
                    RFillList = [{Step, Index, 1, TargetVal} | lists:reverse(FillList)],
                    do_charge(Suit#campaign_suit{fill_list = lists:reverse(RFillList), target_list = T}, (Gold + Val - TargetVal));
                false ->
                    Suit#campaign_suit{target_list = [{Step, Index, 0, (Val + Gold)} | T]}
            end;
        false -> %% 超出日期了
            Suit
    end.

%% 奖励
do_reward([], _Step, _Index) -> {false, ?L(<<"该礼包不可以领取">>)};
do_reward([{Step, Index, 2, _Val} | _T], Step, Index) -> {false, ?L(<<"礼包已经领取">>)};
do_reward([{Step, Index, 1, Val} | T], Step, Index) ->
    ItemId = get_item_id(Step, Index),
    {ok, ItemId, [{Step, Index, 2, Val} | T]};
do_reward([{Step, Index, _Status, _Val} | _T], Step, Index) -> {false, ?L(<<"礼包不可领取">>)};
do_reward([H | T], Step, Index) ->
    case do_reward(T, Step, Index) of
        {ok, ItemId, List} ->
            {ok, ItemId, [H | List]};
        {false, Reason} -> {false, Reason}
    end.

%% 获取界面礼包信息
parse_suit_gifts(SuitList) ->
    parse_suit_gifts(SuitList, []).
parse_suit_gifts([], SuitGifts) ->
    lists:reverse(SuitGifts);
parse_suit_gifts([{Step, Index, Status, _Val} | T], SuitGifts) ->
    ItemId = get_item_id(Step, Index),
    parse_suit_gifts(T, [{Step, Index, Status, ItemId} | SuitGifts]).
