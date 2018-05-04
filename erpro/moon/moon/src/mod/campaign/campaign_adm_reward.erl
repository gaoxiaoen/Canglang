%%----------------------------------------------------
%% 后台活动奖励模块
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(campaign_adm_reward).
-export([
        %send_mail/5
        do_send_mail/5
        ,exchange/5
        ,do_exchange_card/5
        ,check_reward/4
        ,merge_reward/4
        ,send_reward/5
        ,get_rewards/3
        ,get_reward/4
        ,rewards_to_gains/1
        ,has_reward/4
        ,return_reward/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").
-include("mail.hrl").
-include("gain.hrl").
-include("pet.hrl").
-include("item.hrl").
-include("link.hrl").
-include("vip.hrl").
-include("task.hrl").

-define(camp_assets_max_val, 99999999).

%% 邮件奖励发放
%send_mail(Cond, Camp, TotalCamp, {Rid, SrvId, Name}, Args) ->
%    send_mail(Cond, Camp, TotalCamp, #role{id = {Rid, SrvId}, name = Name}, Args);
%send_mail(Cond, Camp, TotalCamp, Role = #role{id = {Rid, SrvId}}, Args) ->
%    case role_api:is_local_role(SrvId) of
%        false -> false;
%        true ->
%            case check_reward(TotalCamp, Camp, Cond, Role) of
%                true -> %% 奖励可发放
%                    do_send_mail(Cond, Camp, TotalCamp, Role, Args),
%                    campaign_dao:add_camp_log(TotalCamp, Camp, Cond, Role),
%                    campaign_adm:apply(async, {rewarded, {Rid, SrvId}, Cond}),
%                    do_reward_finish(Role, TotalCamp, Camp, Cond, Args),
%                    ok;
%                false ->
%                    false
%            end
%    end.
do_send_mail(_Cond = #campaign_cond{sec_type = ?camp_type_play_task_xx_double}, _Camp, _TotalCamp, Role, #task{attr_list = Rewards}) ->
    Subject = ?L(<<"双倍修行，奖励满满">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。活动期间，您参加双倍修行任务活动，获得了下列额外奖励！请注意查收，祝您游戏愉快！">>),
    Fun = fun(#gain{label = exp, val = Val1}, L1) -> [{?mail_exp, Val1} | L1]; 
        (#gain{label = attainment, val = Val1}, L1) -> [{?mail_attainment, Val1} | L1];
        (#gain{label = coin_bind, val = Val1}, L1) -> [{?mail_coin_bind, Val1} | L1];
        (_, L1) -> L1
    end,
    Assets = lists:foldl(Fun, [], Rewards),
    mail_mgr:deliver(Role, {Subject, Content, Assets, []}),
    ok;
do_send_mail(_Cond = #campaign_cond{sec_type = SecType, mail_subject = Subject, mail_content = Content, coin = Coin, coin_bind = CoinBind, gold = Gold, gold_bind = GoldBind, items = Items}, _Camp, _TotalCamp, Role, Args) ->
    Assets0 = case Coin > 0 andalso Coin < ?camp_assets_max_val of
        true -> [{?mail_coin, Coin}];
        _ -> []
    end,
    Assets1 = case CoinBind > 0 andalso CoinBind < ?camp_assets_max_val of
        true -> [{?mail_coin_bind, CoinBind} | Assets0];
        _ -> Assets0
    end,
    Assets2 = case Gold > 0 andalso Gold < ?camp_assets_max_val of
        true when SecType =:= ?camp_type_pay_rate -> [{?mail_gold, Args * Gold div 100} | Assets1];
        true -> [{?mail_gold, Gold} | Assets1];
        _ -> Assets1
    end,
    Assets = case GoldBind > 0 andalso GoldBind < ?camp_assets_max_val of
        true -> [{?mail_gold_bind, GoldBind} | Assets2];
        _ -> Assets2
    end,
    mail_mgr:deliver(Role, {Subject, Content, Assets, Items}),
    ok;
do_send_mail(_Cond, _Camp, _TotalCamp, _Role, _Args) ->
    ok.

% %% 后台活动奖励完成后处理公告/更新客户端等
% do_reward_finish(#role{id = {Rid, SrvId}, name = RName}, #campaign_total{name = CampName}, _Camp, #campaign_cond{sec_type = ?camp_type_pay_rate, settlement_type = ?camp_settlement_type_everyday, gold = GoldRate}, _Args) ->
%     Msg = util:fbin(?L(<<"{role, ~w, ~s, ~s, #3ad6f0}在~s期间进行首次充值，获得了~p%返利，活动期间，每日首次进行充值均可获得~p%返利哦。">>), [Rid, SrvId, RName, CampName, GoldRate, GoldRate]),
%     notice:send(62, Msg);
% do_reward_finish(#role{id = {Rid, SrvId}, name = RName}, _TotalCamp, _Camp, #campaign_cond{sec_type = ?camp_type_pay_updatefirst}, _Args) ->
%     Msg = util:fbin(?L(<<"福利满满，返利不断。{role, ~w, ~s, ~s, #3ad6f0}参加了精彩活动，获得了活动首充奖励，超值好礼，诱惑人心。">>), [Rid, SrvId, RName]),
%     notice:send(62, Msg);
% %%do_reward_finish(#role{link = #link{conn_pid = ConnPid}}, _TotalCamp, _Camp, #campaign_cond{sec_type = ?camp_type_pay_each_task}, _Args) when is_pid(ConnPid) ->
% %%    sys_conn:pack_send(ConnPid, 15853, {1}); %% 通知客户端更新任务列表数据
% %%do_reward_finish(#role{link = #link{conn_pid = ConnPid}}, _TotalCamp, _Camp, #campaign_cond{sec_type = ?camp_type_pay_acc_task}, _Args) when is_pid(ConnPid) ->
% %%    sys_conn:pack_send(ConnPid, 15853, {1}); %% 通知客户端更新任务列表数据
% do_reward_finish(_Role, _TotalCamp, _Camp, _Cond, _Args) ->
%     ok.

%% 兑换、购买
exchange(Role = #role{id = {RoleId, SrvId}, lev = RoleLev}, TotalId, CampId, CondId, Card) ->
    Now = util:unixtime(),
    case campaign_adm:lookup_open(Role, TotalId) of
        false -> {false, ?MSGID(<<"查找不到总活动数据">>)};
        TotalCamp = #campaign_total{camp_list = CampList} ->
            case lists:keyfind(CampId, #campaign_adm.id, CampList) of
                false -> {false, ?MSGID(<<"查找不到相关活动数据">>)};
                Camp = #campaign_adm{conds = Conds, start_time = StartTime, end_time = EndTime} when StartTime =< Now andalso (Now < EndTime orelse EndTime =:= 0) ->
                    case CondId of
                        0 -> %% 奖励合并领取
                            #campaign_cond{button = Button} = hd(Conds),
                            case Button =:= ?camp_button_type_hand of
                                true ->
                                    Rewards = campaign_adm_reward:get_rewards(RoleId, SrvId, Camp),
                                    case Rewards of
                                        [] -> {false, ?MSGID(<<"没有奖励可以领取">>)};
                                        _ -> 
                                            do_fetch_rewards(Role, Rewards)
                                    end;
                                _ ->
                                    {false, ?MSGID(<<"没有奖励可以领取">>)}
                            end;
                        _ ->
                            case lists:keyfind(CondId, #campaign_cond.id, Conds) of
                                false -> {false, ?MSGID(<<"查找不到相关兑换数据">>)};
                                Cond = #campaign_cond{button = Button, min_lev = MinLev, max_lev = MaxLev, sec_type = SecType} when MinLev =< RoleLev andalso (RoleLev =< MaxLev orelse MaxLev =:= 0) ->
                                    case lists:member(SecType, ?camp_can_hand_reward) of
                                        true when Button =:= ?camp_button_type_buy 
                                        orelse Button =:= ?camp_button_type_exchange 
                                        orelse Button =:= ?camp_button_type_item_exchange ->
                                            CheckConds = case SecType of 
                                                ?camp_type_pay_acc_ico3 -> 
                                                    PayL1 = campaign_adm:list_type(now, SecType),
                                                    [Cond1 || {_, _, Cond1} <- PayL1];
                                                _ -> 
                                                    Cond
                                            end,
                                            case check_reward(TotalCamp, Camp, CheckConds, Role) of
                                                false -> {false, ?MSGID(<<"您兑换次数已用完，敬请关注下一次活动，谢谢！">>)};
                                                true when SecType =:= ?camp_type_play_card ->
                                                    campaign_adm:apply(sync, {exchange, Role, TotalCamp, Camp, Cond, Card});
                                                true ->
                                                    do_exchange(Role, TotalCamp, Camp, Cond)
                                            end;
                                        true when Button =:= ?camp_button_type_hand ->
                                            Rewards = campaign_adm_reward:get_rewards(RoleId, SrvId, Camp),
                                            case Rewards of
                                                [] -> {false, ?MSGID(<<"没有奖励可以领取">>)};
                                                _ -> 
                                                    do_fetch_rewards(Role, Rewards)
                                            end;
                                        _ -> 
                                            {false, ?MSGID(<<"活动类型不正确，无法兑换">>)}
                                    end;
                                _ ->
                                    {false, ?MSGID(<<"等级不符，不能参与本次活动！">>)}
                            end
                    end;
                _ ->
                    {false, ?MSGID(<<"活动已过期，敬请关注下一次活动，谢谢！">>)}
            end 
    end.

%% 激活码兑换处理
do_exchange_card(_Role, _TotalCamp, _Camp, _Cond, Card) when byte_size(Card) < 16 ->
    {false, ?MSGID(<<"卡号不存在，无法兑换">>)};
do_exchange_card(Role = #role{platform = Platfrom}, TotalCamp, Camp, Cond = #campaign_cond{id = CondId}, Card) ->
    HadExchL = case get(had_exchange_cards) of
        L when is_list(L) -> L;
        _ -> []
    end,
    ?DEBUG("已领取激活码[~w]", [HadExchL]),
    case lists:member({CondId, Card}, HadExchL) of %% 增加字典存储方式 防止非法玩家同时兑换一个激活号 数据库更新不及时造成一号多领情况发生
        true -> %% 缓存字典里这个卡号已领取，不能继续
            {false, ?MSGID(<<"卡号不存在，无法兑换">>)};
        false ->
            case campaign_dao:check_camp_card(Role, Cond, Card) of
                false -> 
                    {false, ?MSGID(<<"卡号不存在，无法兑换">>)};
                _ ->
                    {Items, AllowPlatform} = case db:get_one("SELECT create_time FROM sys_campaign_card WHERE card_num=~s LIMIT 1", [Card]) of
                        {ok, CreateTime} when CreateTime >= 1409906724 andalso CreateTime =< 1409906725  ->
                            {{536112, 1, 1}, <<"dl">>};
                        {ok, CreateTime} when CreateTime =:= 1409906744 ->
                            {{536114, 1, 1}, <<"dl">>};
                        {ok, CreateTime} when CreateTime >= 1409906765 andalso CreateTime =< 1409906767  ->
                            {{536116, 1, 1}, <<"dl">>};                       
                        {ok, CreateTime} when CreateTime =:= 1409906698 ->
                            {{536110, 1, 1}, <<"dl">>};
                        {ok, CreateTime} when CreateTime >= 1409906861 andalso CreateTime =< 1409906864  ->
                            {{536118, 1, 1}, <<"dl">>};  
                        {ok, CreateTime} when CreateTime >= 1409906620 andalso CreateTime =< 1409906621  ->
                            {{536108, 1, 1}, <<"dl">>};  
                        {ok, CreateTime} when CreateTime >= 1409908860 andalso CreateTime =< 1409908861  ->
                            {{536111, 1, 1}, <<"uc">>};  
                        {ok, CreateTime} when CreateTime =:= 1409908882 ->
                            {{536113, 1, 1}, <<"uc">>};
                        {ok, CreateTime} when CreateTime >= 1409908902 andalso CreateTime =< 1409908904  ->
                            {{536115, 1, 1}, <<"uc">>};  
                        {ok, CreateTime} when CreateTime =:= 1409908704 ->
                            {{536109, 1, 1}, <<"uc">>};
                        {ok, CreateTime} when CreateTime >= 1409908933 andalso CreateTime =< 1409908935  ->
                            {{536117, 1, 1}, <<"uc">>};  
                        {ok, CreateTime} when CreateTime >= 1409908455 andalso CreateTime =< 1409908456  ->
                            {{536107, 1, 1}, <<"uc">>};  
                        _ ->
                            {undefined, undefined}
                    end,
                    case AllowPlatform =:= Platfrom orelse AllowPlatform =:= undefined of
                        false ->
                            {false, ?MSGID(<<"没有奖励可以领取">>)};
                        true ->
                            Cond1 = case Items of
                                undefined -> Cond;
                                _ -> Cond#campaign_cond{items = [Items]}
                            end,
                            case do_exchange(Role, TotalCamp, Camp, Cond1) of
                                {false, Reason} -> {false, Reason};
                                {ok, NRole} -> 
                                    NewHadExchL = lists:sublist([{CondId, Card} | HadExchL], 20),
                                    put(had_exchange_cards, NewHadExchL),
                                    campaign_dao:update_camp_card(Role, Cond1, Card),
                                    {ok, NRole}
                            end
                    end
            end
    end.

%% 兑换过程处理
do_exchange(Role = #role{link = #link{conn_pid = ConnPid}}, TotalCamp, Camp, Cond = #campaign_cond{conds = Conds, coin = Coin, coin_bind = CoinBind, gold = Gold, gold_bind = GoldBind, items = Items, sec_type = SecType}) ->
    Args = get_cond_args(Cond, Role),
    case campaign_cond:do(Role, TotalCamp, Camp, Cond, Args, Conds) of
        {false, Reason} -> {false, Reason};
        {ok, NRole} -> 
            GL0 = case Coin > 0 andalso Coin < ?camp_assets_max_val of
                true -> [#gain{label = coin, val = Coin}];
                false -> []
            end,
            GL1 = case CoinBind > 0 andalso CoinBind < ?camp_assets_max_val of
                true -> [#gain{label = coin_bind, val = CoinBind} | GL0];
                _ -> GL0
            end,
            GL2 = case Gold > 0 andalso Gold < ?camp_assets_max_val of
                true -> [#gain{label = gold, val = Gold} | GL1];
                false -> GL1
            end,
            GL = case GoldBind > 0 andalso GoldBind < ?camp_assets_max_val of
                true -> [#gain{label = gold_bind, val = GoldBind} | GL2];
                false -> GL2
            end,
            ItemGL = [#gain{label = item, val = [BaseId, Bind, Num]} || {BaseId, Bind, Num} <- Items],
            TotalGL = GL ++ ItemGL,
            case role_gain:do(TotalGL, NRole) of
                {false, _} -> {false, ?MSGID(<<"请检查背包是否已满">>)};
                {ok, NewRole} ->
                    %Msg = notice_inform:gain_loss(TotalGL, ?L(<<"参与活动">>)),
                    %notice:inform(Role#role.pid, Msg),
                    campaign_dao:add_camp_log(TotalCamp, Camp, Cond, Role),
                    campaign_adm:apply(async, {rewarded, NewRole#role.id, Cond}),
                    case SecType of
                        ?camp_type_pay_acc_ico3 -> 
                            sys_conn:pack_send(ConnPid, 15853, {2}); %% 通知客户端更新充值任务列表数据
                        _ ->
                            skip
                    end,
                    {ok, NewRole}
            end
    end.

do_fetch_rewards(Role = #role{id= {RoleId, SrvId}}, Rewards) ->
    Gains = campaign_adm_reward:rewards_to_gains(Rewards),
    case role_gain:do(Gains, Role) of
        {false, _} -> {false, ?MSGID(<<"请检查背包是否已满">>)};
        {ok, NewRole} -> 
            try gen_server:call(campaign_adm, {fetch_reward, RoleId, SrvId, Rewards}, 30000) of  %% 30秒超时
                _ -> {ok, NewRole}
            catch A:B ->
                ?ERR("err ~p : ~p", [A, B]),
                {false, ?MSGID(<<"领取奖励超时">>)}
            end
    end.

%mark_rewards_fetched() ->
%    ok.

%%------------------------------------
%% 判断奖励是否已发放 限制发放重复
%%------------------------------------

check_reward(_TotalCamp, _Camp, [], _Role) ->
    true;
check_reward(TotalCamp, Camp, [Cond | T], Role) ->
    case check_reward(TotalCamp, Camp, Cond, Role) of
        false -> false;
        true -> check_reward(TotalCamp, Camp, T, Role)
    end;
check_reward(_TotalCamp, _Camp, #campaign_cond{reward_num = 0}, _Role) -> %% 0表示无限制
    true;
check_reward(TotalCamp, Camp, Cond = #campaign_cond{id = CondId, reward_num = Num, settlement_type = SettType}, #role{id = {Rid, SrvId}, campaign = #campaign_role{mail_list = MailList}}) ->
    Val = case lists:keyfind(CondId, 1, MailList) of
        {_, N, Time} when SettType =:= ?camp_settlement_type_everyday ->
            case util:is_today(Time) of
                true -> N;
                _ -> 0
            end;
        {_, N, _} -> N;
        _ -> 0
    end,
    %% ?DEBUG("===========================~p/~p", [Val, Num]),
    case Val < Num of
        true -> check_reward(TotalCamp, Camp, Cond, {Rid, SrvId});
        _ -> false
    end;
check_reward(TotalCamp, Camp, Cond, #role{id = {Rid, SrvId}}) ->
    check_reward(TotalCamp, Camp, Cond, {Rid, SrvId});
check_reward(TotalCamp, Camp, Cond, {Rid, SrvId, _Name}) ->
    check_reward(TotalCamp, Camp, Cond, {Rid, SrvId});
check_reward(TotalCamp, Camp, Cond = #campaign_cond{sec_type = SecType}, {Rid, SrvId}) ->
    case lists:member(SecType, ?camp_reward_each_out_check) of %% 检测是否每次都需要发奖励类型
        true -> true;
        false ->
            case campaign_adm:check_can_reward({Rid, SrvId}, Cond) of
                false -> false;
                true -> check_can_reward_db(TotalCamp, Camp, Cond, {Rid, SrvId})
            end
    end.

%% 奖励已发放过滤
check_can_reward_db(_TotalCamp, _Camp, Cond = #campaign_cond{id = CondId, reward_num = RewardNum, settlement_type = ?camp_settlement_type_everyday}, {Rid, SrvId}) ->
    DayStart = util:unixtime(today),
    N = campaign_dao:reward_camp_num(Rid, SrvId, CondId, DayStart),
    case N < RewardNum andalso N =/= -1 of
        false when N > 0 -> 
            campaign_adm:apply(async, {rewarded, {Rid, SrvId}, Cond, N, DayStart}), %% 线程重启时重置奖励次数
            false;
        false -> false;
        true -> true
    end;
check_can_reward_db(_TotalCamp, _Camp, Cond = #campaign_cond{id = CondId, reward_num = RewardNum}, {Rid, SrvId}) ->
    N = campaign_dao:reward_camp_num(Rid, SrvId, CondId, 0),
    case N < RewardNum andalso N =/= -1 of
        false when N > 0 -> 
            campaign_adm:apply(async, {rewarded, {Rid, SrvId}, Cond, N, 0}), %% 线程重启时重置奖励次数
            false;
        false -> false;
        true -> true
    end;
check_can_reward_db(_TotalCamp, _Camp, _Cond, _RoleInfo) -> false.

%% -> #campaign_cond{}
merge_reward(TotalCamp, Camp, Conds, Role = #role{id = {RoleId, SrvId}}) ->
    lists:foldl(fun(Cond, AccCond)->
        case check_reward(TotalCamp, Camp, Cond, Role) of
            true -> 
                #campaign_cond{
                    id = CondId
                    ,coin = Coin
                    ,gold = Gold 
                    ,gold_bind = GoldBind
                    ,items = Items
                } = Cond,
                N = campaign_dao:reward_camp_num(RoleId, SrvId, CondId, 0),
                #campaign_cond{
                    coin = AccCoin
                    ,gold = AccGold 
                    ,gold_bind = AccGoldBind
                    ,items = AccItems
                } = AccCond,
                AccCond#campaign_cond{
                    coin = AccCoin + Coin * N
                    ,gold = AccGold + Gold * N
                    ,gold_bind = AccGoldBind + GoldBind * N
                    ,items = AccItems ++ lists:concat(lists:duplicate(N, Items))
                };
            _ ->
                AccCond
        end
    end, #campaign_cond{}, Conds).

%%--------------------------------------
%% 获取各规则参数
%%--------------------------------------

get_cond_args(#campaign_cond{sec_type = ?camp_type_game_petpower}, Role = #role{pet = #pet_bag{active = ActPet}}) ->
    case ActPet of
        undefined -> pet_api:get_max(#pet.fight_capacity, Role);
        _ -> ActPet
    end;
get_cond_args(_Cond, _Role) -> 0.
    

%% ---------------------------------------
%% 奖励暂时发送/保存/查询/领取机制(新) by qingxuan 2014/2/17
%% ---------------------------------------
%% -> [#campaign_role_reward{}]
get_rewards(RoleId, SrvId, _Camp = #campaign_adm{id = CampId, conds = Conds}) ->
    Rewards = [ get_reward(RoleId, SrvId, CampId, CondId) || #campaign_cond{id = CondId} <- Conds ],
    [ Reward || Reward <- Rewards, is_record(Reward, campaign_role_reward), Reward#campaign_role_reward.num > 0].

rewards_to_gains(Rewards) ->
    rewards_to_gains(Rewards, []).

rewards_to_gains([#campaign_role_reward{gains = Gains}|T], L) ->
    rewards_to_gains(T, rewards_to_gains(Gains, L));
rewards_to_gains([], L) ->
    L;
rewards_to_gains([Gain = #gain{label = item, val = [_ItemId, _Bind, _Num]}|T], L) ->
    NL = rewards_to_gains(Gain, L, []),
    rewards_to_gains(T, NL);
rewards_to_gains([Gain = #gain{label = Key, val = Val}|T], L) ->
    NL = case lists:keyfind(Key, #gain.label, L) of
        false -> [Gain|L];
        G = #gain{val = OldVal} -> 
            NewGain = G#gain{val = OldVal + Val},
            lists:keyreplace(Key, #gain.label, L, NewGain)
    end,
    rewards_to_gains(T, NL).

rewards_to_gains(Gain, [], L) ->
   [Gain|L];
rewards_to_gains(Gain = #gain{val = [Item, Bind, Num1]}, [#gain{label = item, val = [Item, Bind, Num2]}|T], L) ->
   L ++ [Gain#gain{val = [Item, Bind, Num1 + Num2]}|T];
rewards_to_gains(Gain = #gain{}, [H=#gain{}|T], L) ->
   rewards_to_gains(Gain, T, [H|L]).


%% -> error | undefined | #campaign_role_reward{}
get_reward(RoleId, SrvId, CampId, CondId) ->
    case get_reward_in_ets(RoleId, SrvId, CampId, CondId) of
        undefined ->
            case gen_server:call(campaign_adm, {get_reward, RoleId, SrvId, CampId, CondId}) of
                undefined -> undefined;
                Reward = #campaign_role_reward{} -> Reward;
                _ -> error
            end;
        Reward ->
            Reward
    end.

%% -> undefined | #campaign_role_reward{}
get_reward_in_ets(RoleId, SrvId, _CampId, CondId) ->
    case ets:lookup(campaign_role_reward, {{RoleId, SrvId}, CondId}) of
        [Reward = #campaign_role_reward{}|_] -> Reward;
        _ -> undefined
    end.

%% -> true | false
has_reward(RoleId, SrvId, CampId, CondId) ->
    case get_reward(RoleId, SrvId, CampId, CondId) of
        #campaign_role_reward{num = Num} when Num > 0 -> true;
        _ -> false
    end.

send_reward(Cond, Camp, TotalCamp, {Rid, SrvId, Name}, Args) ->
    send_reward(Cond, Camp, TotalCamp, #role{id = {Rid, SrvId}, name = Name}, Args);
send_reward(Cond, Camp = #campaign_adm{id = CampId}, TotalCamp, Role = #role{id = {RoleId, SrvId}}, _Args) ->
    case role_api:is_local_role(SrvId) of
        false -> false;
        true ->
            case check_reward(TotalCamp, Camp, Cond, Role) of
                true -> %% 奖励可发放
                    #campaign_cond{id = CondId, coin = Coin, gold = Gold, gold_bind = GoldBind, items = Items} = Cond,
                    Gain1 = case Coin > 0 andalso Coin < ?camp_assets_max_val of
                        true -> [#gain{label = coin, val = Coin}];
                        _ -> []
                    end,
                    Gain2 = case Gold > 0 andalso Gold < ?camp_assets_max_val of
                        true -> [#gain{label = gold, val = Gold}];
                        _ -> []
                    end,
                    Gain3 = case GoldBind > 0 andalso GoldBind < ?camp_assets_max_val of
                        true -> [#gain{label = gold_bind, val = GoldBind}];
                        _ -> []
                    end,
                    Gain4 = [ #gain{label = item, val = [ItemId, ItemBind, ItemNum]} || {ItemId, ItemBind, ItemNum} <- Items], 
                    Gains = Gain1 ++ Gain2 ++ Gain3 ++ Gain4,
                    Num = 1,
                    gen_server:cast(campaign_adm, {send_reward, RoleId, SrvId, CampId, CondId, Gains, Num}),
                    campaign_dao:add_camp_log(TotalCamp, Camp, Cond, Role),
                    campaign_adm:apply(async, {rewarded, {RoleId, SrvId}, Cond});
                false ->
                    ok
            end
            %case check_reward(TotalCamp, Camp, Cond, Role) of
            %    true -> %% 奖励可发放
            %        do_send_mail(Cond, Camp, TotalCamp, Role, Args),
            %        campaign_dao:add_camp_log(TotalCamp, Camp, Cond, Role),
            %        campaign_adm:apply(async, {rewarded, {Rid, SrvId}, Cond}),
            %        do_reward_finish(Role, TotalCamp, Camp, Cond, Args),
            %        ok;
            %    false ->
            %        false
            %end
    end.

%% 返还活动奖励(发到玩家的奖励大厅)
%% 活动结束，玩家未领取的奖励统一发放
%% （或用于特殊情况，手动调用, 比如活动非正常关闭，导致玩家奖励未领取）
return_reward(CampId) ->
    case db:get_all("SELECT `role_id`, `srv_id`, `camp_id`, `cond_id`, `num` FROM `role_campaign_reward` WHERE `camp_id`=~s AND `num` > 0", [CampId]) of
        {ok, List} ->
            lists:foreach(fun([RoleId, SrvId, _CampId, CondId, _Num]) ->
                ?INFO("活动返还奖励 ~p ~s ~p ~p ~p", [RoleId, SrvId, CampId, CondId, _Num]),
                case get_reward(RoleId, SrvId, CampId, CondId) of
                    Reward = #campaign_role_reward{} ->
                        Gains = rewards_to_gains([Reward]),
                        award:send({RoleId, SrvId}, ?camp_return_reward_base_id, Gains),
                        try gen_server:call(campaign_adm, {fetch_reward, RoleId, SrvId, [Reward]}, 30000) of  %% 30秒超时
                            _ -> ok
                        catch A:B ->
                            ?ERR("err ~p : ~p", [A, B])
                        end;
                    _ ->
                        ignore
                end 
            end, List);
        _ ->
            ok
    end.
