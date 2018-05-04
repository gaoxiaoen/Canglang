%% **************************
%% 抽奖系统
%% @author wpf(wprehard@qq.com)
%% **************************

-module(lottery_rpc).
-export([
        handle/3
    ]).

-include("common.hrl").
-include("role.hrl").
-include("lottery.hrl").
-include("lottery_camp.hrl").
-include("item.hrl").
%%
-include("lottery_secret.hrl").
-include("link.hrl").
-include("campaign.hrl").

%% 打开界面获取奖池信息
handle(14700, {}, Role) ->
    lottery:get_pool(Role),
    {ok};

handle(14701, {}, #role{lottery = #lottery{free = Free}, money_tree = MoneyTree, secret = #secret{num = Num}, vip = Vip}) ->
    RestTime = lottery_tree:get_rest_time(MoneyTree, Vip),
    SecretFree = lottery_secret:get_free_time(Num),
    {reply, {Free, RestTime, SecretFree}};

%% 抽奖一次
handle(14705, {}, #role{lev = Lev}) when Lev < ?LUCKY_LEV_MIN ->
    {reply, {?false, ?L(<<"需要等级达到40级才可以转动幸运转盘">>), 0, 0, 0, 0, 0}};
handle(14705, {}, Role) ->
    case storage_api:get_free_num(bag, Role) of
        Pos when Pos > 0 ->
            case lottery:lucky(Role) of
                {true, Type, LI = #lottery_item{base_id = BaseId, num = Num}, #lottery_state{bonus = Bonus},
                    Role0 = #role{lottery = NewLot = #lottery{free = Free, last_award = LastA}}} ->
                    log:log(log_coin, {<<"抽奖">>, <<"">>, Role, Role0}),
                    %% 抽中奖品
                    ?DEBUG("抽中[~w]", [BaseId]),
                    NewRole = role_listener:special_event(Role0, {1035, finish}), %% 嘉年华抽奖完成任务
                    {reply, {?true, <<"">>, Free, Bonus, BaseId, Num, ?false}, NewRole#role{lottery = NewLot#lottery{last_award = [{Type, LI} | LastA]}}};
                {false, Type, _LI, #lottery_state{bonus = Bonus}, Role0 = #role{lottery = NewLot = #lottery{free = Free, last_award = LastA}}} ->
                    log:log(log_coin, {<<"抽奖">>, <<"">>, Role, Role0}),
                    ?DEBUG("抽中[~w]后不可中 -> 给予安慰奖", [_LI#lottery_item.base_id]),
                    {ok, NewLI} = lottery_data:get(Type, ?LAST_PRIZE_ID),
                    NewRole = role_listener:special_event(Role0, {1035, finish}), %% 嘉年华抽奖完成任务
                    {reply, {?true, <<"">>, Free, Bonus, ?LAST_PRIZE_ID, 1, ?false}, NewRole#role{lottery = NewLot#lottery{last_award = [{Type, NewLI} | LastA]}}};
                {false, {ErrCode, Msg}} ->
                    {reply, {ErrCode, Msg, 0, 0, 0, 0, 0}};
                {false, Msg} ->
                    {reply, {?false, Msg, 0, 0, 0, 0, 0}};
                {_Ret, _Type, _LI, _LS, _R} ->
                    ?DEBUG("抽奖返回值异常[RET:~w, TYPE:~w, LI:~w, _R:~w]", [_Ret, _Type, _LI, is_record(_R, role)]),
                    {reply, {?false, <<"">>, 0, 0, 0, 0}}
            end;
        _ ->
            {reply, {?false, ?L(<<"背包已满，请整理背包后再来抽取幸运大奖">>), 0, 0, 0, 0, 0}}
    end;

%% 客户端转盘转完通知领奖；上线需要请求一次，防止抽奖中途掉线
handle(14706, {}, #role{lottery = #lottery{last_award = []}}) -> {ok};
handle(14706, {}, Role = #role{lottery = Lot = #lottery{last_award = AwardList}}) ->
    GL = awards_to_gain(AwardList, []),
    cast_info(Role, AwardList),
    case role_gain:do(GL, Role) of
        {false, _} ->
            ?ELOG("角色[NAME:~w]抽奖发奖励失败：~w", [Role#role.name, GL]),
            lottery:send_award_mail(Role),
            {reply, {?false, ?L(<<"背包已满，奖品发至您的邮箱">>)}, Role#role{lottery = Lot#lottery{last_award = []}}};
        {ok, NewRole} ->
            log(Role, AwardList),
            log:log(log_coin, {<<"抽奖">>, <<"">>, Role, NewRole}),
            Bin = return_info(AwardList, <<>>),
            {reply, {?true, util:fbin(?L(<<"您已获得~s">>), [Bin])}, NewRole#role{lottery = Lot#lottery{last_award = []}}}
    end;

%% 摇钱树界面信息
handle(14707, {}, Role) -> 
    Reply = lottery_tree:get_logs(Role),
    {reply, Reply};

%% 摇钱树摇一下
handle(14708, {}, Role) -> 
    case lottery_tree:shake(Role) of
        {ok, NewRole, RestTime, NewCoin, Double} ->
            log:log(log_coin, {<<"摇钱树">>, <<"摇钱一次">>, Role, NewRole}),
            notice:inform(util:fbin(?L(<<"获得 {str,绑定金币,#FFD700} ~w">>), [NewCoin])),
            {reply, {?true, util:fbin(?L(<<"恭喜您获得~w绑定金币，手气不错哦">>), [NewCoin]), RestTime, NewCoin, Double}, NewRole};
        over_time ->
            {reply, {?false, ?L(<<"你今天的摇钱树次数已经用完，请明天再来吧">>), 0, 0, 0}};
        lev_not ->
            {reply, {?false, ?L(<<"需要等级达到40级才可以使用摇钱树">>), 0, 0, 0}};
        gold_lack ->
            {reply, {?gold_less, ?L(<<"晶钻不够">>), 0, 0, 0}};
        _R ->
            ?DEBUG("摇钱意外结果 ~w", [_R]),
            {reply, {?false, ?L(<<"摇树失败">>), 0, 0, 0}}
    end;

%% 摇钱树一键摇完
handle(14709, {}, Role) -> 
    case lottery_tree:shake_all(Role) of
        {ok, NewRole, RestTime, NewCoin} ->
            notice:inform(util:fbin(?L(<<"获得 {str,绑定金币,#FFD700} ~w">>), [NewCoin])),
            log:log(log_coin, {<<"摇钱树">>, <<"一键摇钱">>, Role, NewRole}),
            {reply, {?true, util:fbin(?L(<<"恭喜您获得~w绑定金币，手气不错哦">>), [NewCoin]), RestTime, NewCoin}, NewRole};
        over_time ->
            {reply, {?false, ?L(<<"你今天的摇钱树次数已经用完，请明天再来吧">>), 0, 0}};
        lev_not ->
            {reply, {?false, ?L(<<"需要等级达到40级才可以使用摇钱树">>), 0, 0}};
        gold_lack ->
            {reply, {?gold_less, ?L(<<"晶钻不够">>), 0, 0}};
        _R ->
            ?DEBUG("摇钱意外结果 ~w", [_R]),
            {reply, {?false, ?L(<<"摇树失败">>), 0, 0}}
    end;

%% 获取转盘信息
handle(14720, {}, _Role) ->
    case lottery_camp:get_panel_info() of
        {ok, UseId, Items, Logs} ->
            {reply, {UseId, Items, Logs}};
        _ ->
            ok
    end;

%% 活动转盘
handle(14721, {}, Role) ->
    case lottery_camp:luck(Role) of
        {ok, BaseId, NewRole} ->
            {reply, {?true, <<>>, BaseId}, NewRole};
        {false, Reason} ->
            {reply, {?false, Reason, 0}}
    end;

%% 活动转盘奖励
handle(14722, {}, Role) ->
    case lottery_camp:reward(Role) of
        {ok, NewRole, #lottery_camp_item{name = Name}} ->
            {reply, {?true, util:fbin(?L(<<"您已获得~s">>), [Name])}, NewRole};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;

%% 获取幻灵秘境信息
handle(14723, {}, Role) ->
    {reply, lottery_secret:get_secret_info(Role)};

%% 采集仙果
handle(14724, {}, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {0, ?L(<<"组队状态无法采摘仙果">>)}};
handle(14724, {}, #role{event = ?event_dungeon}) ->
    {reply, {0, ?L(<<"副本中无法采摘仙果">>)}};
handle(14724, {}, #role{event = Event}) when Event =/= ?event_no andalso Event =/= ?event_guild ->
    {reply, {0, ?L(<<"活动中无法采摘仙果">>)}};
handle(14724, {}, Role) ->
    ?DEBUG("采集仙果"),
    case lottery_secret:combat_start(Role) of
        {false, Reason} ->
            {reply, {0, Reason}};
        {ok} ->
            {reply, {1, <<>>}}
    end;

%% 晶钻转盘面板信息
handle(14738, {}, Role) ->
    {ok, Data}=lottery_gold:get_info(Role),
    {reply, Data};

%% 晶钻转盘抽奖
handle(14739, {}, Role) ->
    case lottery_gold:lottery(Role) of
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"抽奖成功">>)}, NewRole};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;

%% 晶钻转盘发放奖金
handle(14741, {}, Role) ->
    case lottery_gold:send_reward(Role) of
        {ok, ReGold, NewRole = #role{campaign = #campaign_role{lottery_gold = #campaign_lottery_gold{layer = Layer}}}} ->
            case Layer > 5 of
                true -> {reply, {?true, util:fbin(?L(<<"恭喜您获得~w晶钻，您完成了所有转盘奖励，请期待下次活动开启">>), [ReGold])}, NewRole};
                false -> {reply, {?true, util:fbin(?L(<<"恭喜您获得~w晶钻，并获得进入下一轮转取更多晶钻的机会">>), [ReGold])}, NewRole}
            end;
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;

handle(_Cmd, _Data, _) ->
    {error, unknown_command}.

%% ----------------------------------------------------------------
%% 内部处理
%% ----------------------------------------------------------------
%% 奖品转换为消息事件
return_info([], Bin) -> Bin;
return_info([{_Type, #lottery_item{base_id = BaseId, num = Num}} | T], Bin) ->
    Msg = award2info(BaseId, Num),
    return_info(T, util:fbin(<<"~s~s">>,[Bin, Msg])).

award2info(?FIRST_PRIZE_ID, Num) ->
    util:fbin(?L(<<"~w金币">>), [Num]);
award2info(?SECOND_PRIZE_ID, Num) ->
    util:fbin(?L(<<"~w金币">>), [Num]);
award2info(?THIRD_PRIZE_ID, Num) ->
    util:fbin(?L(<<"~w金币">>), [Num]);
award2info(?LAST_PRIZE_ID, Num) ->
    util:fbin(?L(<<"~w绑定金币">>), [Num]);
award2info(ItemId, Num) ->
    case item_data:get(ItemId) of
        {ok, #item_base{name = Name}} ->
            util:fbin(<<"~sx~w">>,[Name, Num]);
        _ -> <<>>
    end.

award2msg(?FIRST_PRIZE_ID, Num) ->
    util:fbin(?L(<<"获得 ~w{str,金币,#ffe500}">>), [Num]);
award2msg(?SECOND_PRIZE_ID, Num) ->
    util:fbin(?L(<<"获得 ~w{str,金币,#ffe500}">>), [Num]);
award2msg(?THIRD_PRIZE_ID, Num) ->
    util:fbin(?L(<<"获得 ~w{str,金币,#ffe500}">>), [Num]);
award2msg(?LAST_PRIZE_ID, Num) ->
    util:fbin(?L(<<"获得 ~w{str,绑定金币,#ffe500}">>), [Num]);
award2msg(ItemId, Num) ->
    case item:make(ItemId, 0, Num) of
        {ok, Items} ->
            ItemMsg = notice:item3_to_inform(Items),
            util:fbin(?L(<<"获得 ~s">>), [ItemMsg]);
        _ -> <<>>
    end.

%% 奖品列表转换为[#gain{}, ...]
awards_to_gain([], GL) -> GL;
awards_to_gain([{Type, #lottery_item{base_id = BaseId, num = Num}} | T], GL) ->
    [G] = lottery:to_award_gain(Type, BaseId, Num),
    awards_to_gain(T, [G | GL]);
awards_to_gain([_ | T], GL) ->
    awards_to_gain(T, GL).

%% 奖品获取各种广播
cast_info(_Role, []) -> ok;
cast_info(Role, [{Type, LI = #lottery_item{base_id = ?FIRST_PRIZE_ID = BaseId, num = Num}} | T]) ->
    lottery:cast(Type, Role, LI),
    notice:inform(award2msg(BaseId, Num)),
    notice:effect(5, <<>>), %% 特效广播
    cast_info(Role, T);
cast_info(Role, [{Type, LI = #lottery_item{base_id = BaseId, num = Num}} | T]) ->
    lottery:cast(Type, Role, LI),
    notice:inform(award2msg(BaseId, Num)),
    cast_info(Role, T);
cast_info(_Role, _) -> ignore.

%% 日志记录
log(_Role, []) -> ok;
log(Role, [{Type, #lottery_item{base_id = BaseId = ?FIRST_PRIZE_ID, num = Num}} | T]) ->
    log:log(log_lottery, {Type, BaseId, ?L(<<"一等奖">>), Num, Role}),
    log(Role, T);
log(Role, [{Type, #lottery_item{base_id = BaseId = ?SECOND_PRIZE_ID, num = Num}} | T]) ->
    log:log(log_lottery, {Type, BaseId, ?L(<<"二等奖">>), Num, Role}),
    log(Role, T);
log(Role, [{Type, #lottery_item{base_id = BaseId = ?THIRD_PRIZE_ID, num = Num}} | T]) ->
    log:log(log_lottery, {Type, BaseId, ?L(<<"三等奖">>), Num, Role}),
    log(Role, T);
log(Role, [{Type, #lottery_item{base_id = BaseId = ?LAST_PRIZE_ID, num = Num}} | T]) ->
    log:log(log_lottery, {Type, BaseId, ?L(<<"安慰奖">>), Num, Role}),
    log(Role, T);
log(Role, [{Type, #lottery_item{base_id = BaseId, num = Num}} | T]) ->
    BaseName = case item_data:get(BaseId) of
        {ok, #item_base{name = Name}} -> Name;
        _ -> ?L(<<"未知物品">>)
    end,
    log:log(log_lottery, {Type, BaseId, BaseName, Num, Role}),
    log(Role, T);
log(_Role, _) -> ignore.


%% --------------------------------
%% pack_proto_msg(#lottery_state{bonus = Bonus, last_first = {Rid, SrvId, Rname}, log = LogList}) ->
%%     AwardList = case lettry_data:award_list_free() of
%%         L when is_list(L) -> L;
%%         _ -> []
%%     end,
%%     {Bonus, Rid, SrvId, Rname,
%%         [{Id, Srvid, Name, AwardId, AwardNum} || #lottery_log{rid = Id, srv_id = Srvid, name = Name, id = AwardId, num = AwardNum} <- LogList]
%%         ,[{BaseId, BaseNum} || #lottery_item{base_id = BaseId, num = BaseNum} <- AwardList]
%%     };
%% pack_proto_msg(_) ->
%%     {0, 0, <<>>, <<>>, [], []}.
