%%----------------------------------------------------
%% @doc 运镖系统主逻辑模块
%%
%% <pre>
%% 运镖系统主逻辑模块
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(escort).

-export([
        accept/1
        ,refresh/2
        ,escort_begin/2
        ,giveup/1
        ,finish/1
        ,login/1
        ,check_combat_start/2
        ,check_is_rob/2
        ,apply_check_is_rob_member/1
        ,combat_start/2
        ,combat_over/1
        ,apply_deal_with_loser/2
        ,apply_deal_with_winner/1
        ,apply_assign_rob_coin/2
        ,get_task_leave/1
        ,push_preview_award/1
        ,get_escort_award/4
    ]
).

-include("common.hrl").
-include("escort.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("gain.hrl").
-include("buff.hrl").
-include("looks.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("task.hrl").
-include("activity.hrl").
-include("team.hrl").
-include("combat.hrl").
%%

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% @spec accept(Role) -> {ok, NewRole, Quality} | {false, Reason}
%% @doc
%% <pre>
%% Role = NewRole = #role{} 角色信息
%% Quality = integer() 上一次刷镖的镖车品质
%% Reason = binary() 失败原因
%% 接取镖车
%% </pre>
accept(Role = #role{lev = Lev, task = TaskList, assets = #assets{coin = _Coin}, escort = Escort = #escort{refresh_time = RefreshTime, quality = Quality, escort_times = {Date, Times}}}) ->
    case Lev < 32 of
        true ->
            {false, ?L(<<"需要达到32级才可以护送美女">>)};
        false ->
            OtherEscortTasks = [Task || Task = #task{type = ?task_type_rc, sec_type = SecType} <- TaskList, SecType=:=27],
            case OtherEscortTasks of
                [_|_] ->
                    {false, ?L(<<"不能同时接多个护送任务">>)};
                _ ->
                    NewQuality = case RefreshTime > util:unixtime(today) of
                        true ->
                            Quality;
                        false ->
                            ?escort_quality_white
                    end,
                    NewTimes = case Date =:= today() of
                        true ->
                            ?escort_times - Times;
                        false ->
                            ?escort_times
                    end,
                    NewRole = Role#role{escort = Escort#escort{quality = NewQuality, refresh_time = util:unixtime()}},
                    push_preview_award(NewRole),
                    {ok, NewRole, NewQuality, NewTimes}
            end
    end.

%% @spec refresh(Role, RefreshType) -> {ok, NewRole, Quality} | {false, Reason}
%% @doc
%% <pre>
%% Role = NewRole = #role{} 角色信息
%% Quality = integer() 镖车品质
%% Reason = binary() 失败原因
%% 刷镖
%% </pre>
refresh(Role, RefreshType) ->
    case check(refresh_quality, Role, {RefreshType}) of
        ok ->
            case do_refresh(Role, RefreshType) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole, Quality} ->
                    push_preview_award(NewRole),
                    {ok, NewRole, Quality}
            end;
        {false, Reason} ->
            {false, Reason}
    end.

%% @spec escort_begin(Role, EscortType) -> {ok, NewRole, MapId, NpcId} | {false, Reason}
%% @doc
%% <pre>
%% Role = NewRole = #role{} 角色记录
%% EscortType = integer() = ?escort_type_coin | ?escort_type_bind_coin 镖车类型
%% MapId = integer() 交镖头的场景Id
%% NpcId = integer() 交镖头Id
%% Reason = binary() 失败原因
%% 开始运镖
%% </pre>
escort_begin(Role, EscortType) ->
    case check(begin_status, Role, {EscortType}) of
        ok ->
            do_escort_begin(Role, EscortType);
        {false, Reason} ->
            {false, Reason}
    end.

%% @spec giveup(Role) -> {ok, NewRole} | {false, Reason}
%% @doc
%% <pre>
%% Role = NewRole = #role{} 角色记录
%% Reason = binary() 失败原因
%% 放弃运镖
%% </pre>
giveup(Role = #role{event = Event, looks = Looks, escort = Escort, buff = #rbuff{buff_list = BuffList}}) ->
    case Event =/= ?event_escort of
        true ->
            {false, ?L(<<"你目前没有护送美女">>)};
        false ->
            %% 删除运镖buff
            {ok, NewRole} = case lists:keyfind(escort, #buff.label, BuffList) of
                false ->
                    {ok, Role};
                #buff{id = BuffId} ->
                    buff:del_by_id(Role, BuffId)
            end,
            NewLooks = lists:keydelete(?LOOKS_TYPE_ACT, 1, Looks),
            NewRole1 = NewRole#role{event = ?event_no, looks = NewLooks, escort = Escort#escort{accept_time = 0, refresh_time = util:unixtime(), quality = ?escort_quality_white}},
            NewRole2 = looks:calc(NewRole1),
            map:role_update(NewRole2),
            {ok, NewRole2}
    end.

%% @spec finish(Role) -> {ok, NewRole} | {false, Reason}
%% @doc
%% <pre>
%% Role = NewRole = #role{} 角色记录
%% Reason = binary() 失败原因
%% 交镖
%% </pre>
finish(Role = #role{pid = Pid, lev = Lev, looks = Looks, event = Event, escort = Escort = #escort{accept_time = AcceptTime, quality = Quality, type = EscortType}, buff = #rbuff{buff_list = BuffList}}) ->
    case Event =/= ?event_escort of
        true ->
            {false, ?L(<<"你目前没有护送美女">>)};
        false ->
            %% 删除除运镖buff
            {ok, NewRole} = case lists:keyfind(escort, #buff.label, BuffList) of
                false -> {ok, Role};
                #buff{id = BuffId} -> buff:del_by_id(Role, BuffId)
            end,
            NewLooks = lists:keydelete(?LOOKS_TYPE_ACT, 1, Looks),
            {NewExp, NewCoin, NewCoinBind} = get_escort_award(Lev, EscortType, Quality, AcceptTime),
            GainList = [#gain{label = coin, val = NewCoin}
                ,#gain{label = exp, val = NewExp}
                ,#gain{label = coin_bind, val = NewCoinBind}],
            NewRole1 = NewRole#role{event = ?event_no, looks = NewLooks, escort = Escort#escort{accept_time = 0, refresh_time = util:unixtime(), quality = ?escort_quality_white}},
            NewRole2 = looks:calc(NewRole1),
            map:role_update(NewRole2),
            case role_gain:do(GainList, NewRole2) of
                {ok, NewRole3} ->
                    notice_inform(Pid, [{coin, NewCoin}, {bind_coin, NewCoinBind}, {exp, NewExp}]),
                    case NewCoin > 0 of
                        true -> npc_store_live:apply(async, {coin, NewCoin});
                        false -> ignore
                    end,
                    campaign_task:listener(Role, escort, EscortType),
                    campaign_listener:handle(escort, Role, {EscortType, Quality}),
                    push_preview_award(NewRole3, {NewExp, NewCoin, NewCoinBind}),
                    {ok, NewRole3};
                {false, Reason} ->
                    {false, Reason}
            end
    end.

%% 推送界面奖励显示，默认按照金币奖励
push_preview_award(#role{link = #link{conn_pid = ConnPid}, lev = RoleLev, escort = #escort{quality = Quality, type = EscortType}}) ->
    {Exp, Coin, BindCoin} = get_escort_award(RoleLev, EscortType, Quality, util:unixtime()),
    sys_conn:pack_send(ConnPid, 13105, {Exp, Coin, BindCoin}).

push_preview_award(#role{link = #link{conn_pid = ConnPid}}, {Exp, Coin, BindCoin}) ->
    sys_conn:pack_send(ConnPid, 13105, {Exp, Coin, BindCoin}).

%% 登录
login(Role = #role{event = ?event_escort, task = TaskList, escort = #escort{quality = Quality, type = EscortType}, looks = Looks, buff = #rbuff{buff_list = BuffList}}) ->
    EscortTask = [Task || Task = #task{type = Type, sec_type = SecType} <- TaskList, Type =:= ?task_type_rc, SecType =:= 1],
    case length(EscortTask) > 0 of
        true ->
            {LooksVal, LooksMod} = quality_to_looks_val(Quality, EscortType),
            NewLooks = case lists:keyfind(?LOOKS_TYPE_ACT, 1, Looks) of
                false ->
                    [{?LOOKS_TYPE_ACT, LooksMod, LooksVal} | Looks];
                _Other ->
                    lists:keyreplace(?LOOKS_TYPE_ACT, 1, Looks, {?LOOKS_TYPE_ACT, LooksMod, LooksVal})
            end,
            looks:calc(Role#role{looks = NewLooks});
        false ->
            {ok, NewRole} = case lists:keyfind(escort, #buff.label, BuffList) of
                false ->
                    {ok, Role};
                #buff{id = BuffId} ->
                    buff:del_by_id(Role, BuffId)
            end,
            NewRole#role{event = ?event_no}
    end;
login(Role = #role{event = ?event_escort_child}) ->
    escort_child:login(Role);
login(Role = #role{event = ?event_escort_cyj}) ->
    escort_cyj:login(Role);
login(Role = #role{event = _Event}) ->
    Role.

%% 劫镖检查
check_combat_start(_Attacker = #role{event = ?event_escort}, _Defender) -> {false, ?L(<<"你正在护送美女中，不可以劫别人的色哦！">>)};
check_combat_start(_Attacker, _Defender = #role{escort = #escort{type = ?escort_type_bind_coin}}) ->
    {false, ?L(<<"对方选择的是“低调护送”，这么低调，不劫也罢！">>)};
check_combat_start(_Attacker = #role{name = _Name, escort = #escort{rob = {PDate, PTime}}}, _Defender = #role{escort = #escort{lose = {LDate, LTime}}}) ->
    Today = today(),
    case PDate =:= Today andalso PTime >= 8 of
        true -> {false, ?L(<<"你劫色次数已经达到8次，还继续劫色？放过那些可怜的美女们吧！">>)};
        false ->
            case LDate =:= Today andalso LTime >= 3 of
                true -> {false, ?L(<<"该美女已经被劫3次了，放过她吧！要懂得怜香惜玉啊！">>)};
                false -> ok
            end
    end.

%% 判断是否为劫镖
check_is_rob(_Attacker = #role{event = ?event_escort}, _Defender) ->
    true;
check_is_rob(_Attacker, _Defender = #role{event = ?event_escort}) ->
    true;
check_is_rob(Attacker, Defender) ->
    case check_is_rob_team(Attacker) of
        true -> true;
        false ->
            check_is_rob_team(Defender)
    end.

%% 劫镖结束
combat_over(#combat{winner = Winner, loser = Loser, type = ?combat_type_rob_escort}) ->
    CoinList = deal_with_loser(Loser),
    WinnerList = deal_with_winner(Winner),
    assign_rob_coin(CoinList, WinnerList), %% 发镖银
    case length(CoinList) > 0 andalso length(WinnerList) > 0 of
        true ->
            Winner2 = [F || F = #fighter{type = ?fighter_type_role} <- Winner],
            Loser2 = [F || F = #fighter{type = ?fighter_type_role} <- Loser],
            case length(Winner2) > 0 andalso length(Loser2) > 0 of
                true ->
                    [#fighter{rid = _WRoleId, srv_id = _WSrvId, name = WName} | _ ] = Winner2,
                    [#fighter{rid = LRoleId, srv_id = LSrvId, name = _LName} | _ ] = Loser2,
                    mail:send_system({LRoleId, LSrvId}, {?L(<<"系统邮件">>), util:fbin(?L(<<"很遗憾，您被<font color=\"#ff0000\">【~s】</font>劫财劫色，没能成功护送美女。你仍能获得经验奖励，以及一半金币，但变为绑定金币。">>), [WName]), [], []}),
                    ok;
                false -> ignore
            end,
            W = fighter_to_msg(Winner2),
            L = fighter_to_msg(Loser2),
            fighter_to_interface(Winner2, Loser2),
            notice:send(53, util:fbin(?L(<<"光天化日之下，~s劫了~s的财和色，太残忍了，什么世道啊！">>), [W, L]));
        false -> ignore
    end;
combat_over(_Combat) ->
    ok.

%% 发起劫镖操作
combat_start(Attacker, Defender) ->
    case {defender_fighter(Attacker), defender_fighter(Defender)} of
        {{ok, APNC}, {ok, DNPC}} ->
            combat:start(?combat_type_rob_escort, [APNC | role_api:fighter_group(Attacker)], [DNPC| role_api:fighter_group(Defender)]);
        {{ok, APNC}, {false, _}} ->
            combat:start(?combat_type_rob_escort, [APNC | role_api:fighter_group(Attacker)], role_api:fighter_group(Defender));
        {{false, _}, {ok, DNPC}} ->
            combat:start(?combat_type_rob_escort, role_api:fighter_group(Attacker), [DNPC| role_api:fighter_group(Defender)]);
        {{false, _}, {false, _Reason}} ->
            ?DEBUG("[劫镖]找不到美女npc:~w", [_Reason]),
            combat:start(?combat_type_rob_escort, role_api:fighter_group(Attacker), role_api:fighter_group(Defender))
    end.

%% 获取运镖任务剩余次数
get_task_leave(#role{event = ?event_escort}) -> {false, ?L(<<"正在护送">>)};
get_task_leave(_Role) ->
    {ok, FinishRc} = role:get_dict(task_finish_rc), %% [#task_finish{}]
    {ok, AcceptableRc} = role:get_dict(task_acceptable_rc),
    case has_escort_task(AcceptableRc) of
        true ->
            Total = escort_finish_total(FinishRc),
            case Total > 3 of
                true -> {ok, 0};
                false -> {ok, 3 - Total}
            end;
        false -> {ok, 0}
    end.
%%----------------------------------------------------
%% 内部处理 
%%----------------------------------------------------

%% 检查现有镖车品质
check(refresh_quality, Role = #role{escort = #escort{refresh_time = RefreshTime, quality = Quality}}, {RefreshType}) ->
    case util:unixtime(today) < RefreshTime of
        true ->
            case Quality =:= ?escort_quality_orange of
                true ->
                    {false, ?L(<<"你已经刷到最好的美女了，不需要再刷了">>)};
                false ->
                    check(refresh_item, Role, {RefreshType})
            end;
        false ->
            check(refresh_item, Role, {RefreshType})
    end; 

%% 查检刷镖所需要的物品是否存在
check(refresh_item, _Role = #role{bag = Bag, assets = #assets{gold = Gold}}, {RefreshType}) ->
    case RefreshType of
        1 -> %% 普通刷镖
            case storage:find(Bag#bag.items, #item.base_id, ?escort_token_green) of
                {ok, _Num, _List, _, _} ->
                    ok;
                {false, _Reason} ->
                    {false, ?L(<<"你已没有令牌了">>)}
            end;
        2 -> %% 晶钻刷镖
            case Gold >= 2 of
                true ->
                    ok;
                false ->
                    {false, gold_notenough} %% 晶钻不足
            end
    end;

%% 开始运镖:检查角色状态是否合法
check(begin_status, #role{lev = Lev, event = Event, team_pid = TeamPid, status = Status, ride = Ride, mod = {Mod1, _}}, {EscortType}) ->
    case Status =:= ?status_fight of
        true -> {false, ?L(<<"大哥,你在打架也要护送美女啊">>)};
        false ->
            case Lev < 1 of
                true -> {false, ?L(<<"需要32级才可以参与护送美女">>)};
                false ->
                    case Event =/= ?event_no of
                        true -> {false, util:fbin(?L(<<"你好像正在做某些事，不可以护送美女[event:~w]">>), [Event])};
                        false ->
                            %% TODO: 检查是否为杀戮
                            case {Mod1 =:= 1, EscortType} of
                                {true, ?escort_type_coin} -> {false, ?L(<<"和平模式不可以护送美女">>)};
                                _ -> 
                                    case Ride =/= ?ride_no of
                                        true -> {false, ?L(<<"飞行状态不可以护送美女">>)};
                                        false -> 
                                            case is_pid(TeamPid) of
                                                true -> {false, ?L(<<"组队状态不可以护送美女!">>)};
                                                false -> ok
                                            end
                                    end
                            end
                    end
            end
    end.

%% @spec do_refresh(Role, RefreshType) -> {ok, NewRole, NewQuality} | {false, Reason}
%% 刷镖
do_refresh(Role = #role{assets = #assets{gold = Gold}}, RefreshType) ->
    case RefreshType of
        1 -> %% 普通刷镖
            case role_gain:do([#loss{label = item, val = [?escort_token_green, 0, 1]}], Role) of
                {ok, NewRole} ->
                    gen_quality(NewRole);
                {false, _Any} ->
                    {false, ?L(<<"扣除令牌失败">>)}
            end;
        2 -> %% 晶钻刷镖
            case Gold >= 2 of
                true ->
                    case role_gain:do([#loss{label = gold, val = pay:price(?MODULE, refresh, null)}], Role) of
                        {ok, NewRole} ->
                            gen_quality(NewRole);
                        {false, _Any} ->
                            {false, ?L(<<"扣除晶钻失败">>)}
                    end;
                false ->
                    {false, ?L(<<"晶钻不足">>)}
            end
    end.

%% 根据概率产生镖车品质
gen_quality(Role = #role{id = {Rid, SrvId}, name = Name, escort = Escort}) ->
    {GreenProb, BlueProb, PurpleProb, _OrangeProb} = escort_data:prob(),
    Num = util:rand(1, 100),
    Quality = if
        Num =< GreenProb ->
            ?escort_quality_green;
        Num =< (BlueProb + GreenProb) ->
            ?escort_quality_blue;
        Num =< (PurpleProb + BlueProb + GreenProb) ->
            ?escort_quality_purple;
        true ->
            RoleName = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [Rid, SrvId, Name]),
            notice:send(53, util:fbin(?L(<<"~s人品大爆发，得到“{str, 帝姬, #ff8400}”的眷顾，绝世美女相伴，你也可以。{open, 5, 我要护送, #00ff00}">>), [RoleName])),
            ?escort_quality_orange
    end,
    NewRole = Role#role{escort = Escort#escort{refresh_time = util:unixtime(), quality = Quality}},
    {ok, NewRole, Quality}.

%% @spec do_escort_begin(Role, EscortType) -> {ok, NewRole, MapId, NpcId} | {false, Reason}
%% 开始运镖
do_escort_begin(Role = #role{lev = Lev, escort = Escort = #escort{quality = Quality, escort_times = {Date, Times}}}, EscortType) ->
    %% TODO 查找交镖头的场景Id和NpcId
    {MapId, NpcId} = {1001, 10025}, %% 已经没有用了，使用任务那边的处理
    {NewDate, NewTimes} = case Date =:= today() of
        true ->
            {Date, Times + 1};
        false ->
            {today(), 1}
    end, 
    {_Exp, _Coin, _Tax} = escort_data:escort_award(Lev),
    %% case role_gain:do([#loss{label = coin, val = Tax}], Role) of
    %%     {ok, NewRole} ->
            %% 增加运镖buff
            NewRoleBuff = case buff:del_buff_by_label(Role, escort) of
                {ok, NewRoleBuff2} ->
                    NewRoleBuff2;
                false ->
                    Role 
            end,
            case buff:add(NewRoleBuff, escort) of
                {ok, NR = #role{looks = Looks}} ->
                    NewRole2 = role_api:push_attr(NR),
                    {LooksVal, LooksMod} = quality_to_looks_val(Quality, EscortType),
                    NewLooks = case lists:keyfind(?LOOKS_TYPE_ACT, 1, Looks) of
                        false ->
                            [{?LOOKS_TYPE_ACT, LooksMod, LooksVal} | Looks];
                        _Other ->
                            lists:keyreplace(?LOOKS_TYPE_ACT, 1, Looks, {?LOOKS_TYPE_ACT, LooksMod, LooksVal})
                    end,
                    NewRole3 = NewRole2#role{event = ?event_escort, looks = NewLooks},
                    NewRole4 = looks:calc(NewRole3),
                    map:role_update(NewRole4),
                    {ok, NewRole4#role{escort = Escort#escort{accept_time = util:unixtime(), escort_times = {NewDate, NewTimes}, type = EscortType, lose = {today(), 0}}}, MapId, NpcId};
                {false, Reason} ->
                    {false, Reason}
            end.
    %%     {false, _Any} ->
    %%         {false, ?L(<<"扣除押金失败">>)}
    %% end.

%% 发送奖励信息
notice_inform(Pid, [{exp, Val} | T]) when Val > 0 ->
    notice:inform(Pid, util:fbin(?L(<<"获得{str,经验,#00ff24} ~w">>), [Val])),
    notice_inform(Pid, T);
notice_inform(Pid, [{coin, Val} | T]) when Val > 0 ->
    notice:inform(Pid, util:fbin(?L(<<"获得{str,金币,#FFD700} ~w">>), [Val])),
    notice_inform(Pid, T);
notice_inform(Pid, [{bind_coin, Val} | T]) when Val > 0 ->
    notice:inform(Pid, util:fbin(?L(<<"获得{str,绑定金币,#FFD700} ~w">>), [Val])),
    notice_inform(Pid, T);
notice_inform(Pid, [_NoMatch | T]) ->
    notice_inform(Pid, T);
notice_inform(_Pid, []) ->
    ok.
    
%% 是否为双倍运镖时间
is_double_award(AcceptTime) ->
    case escort_mgr:is_double_award(AcceptTime) of
        {ok, Rst} -> Rst;
        _ -> false
    end.

%% 判断是否为活动时间
campaign_award(IsDouble, Exp, Coin, BindCoin) ->
    Tb = util:datetime_to_seconds({{2013, 1, 29}, {0, 0, 1}}),
    Te = util:datetime_to_seconds({{2013, 2, 1}, {23, 59, 59}}),
    Now = util:unixtime(),
    CampAdmFlag = campaign_adm:is_camp_time(escort_double), %% 后台活动
    case (Now >= Tb andalso Now =< Te) orelse CampAdmFlag =:= true of
        false when IsDouble =:= false ->
            %% 非活动时间
            {Exp, Coin, BindCoin};
        false when IsDouble =:= true ->
            %% 非活动时间，双倍阶段
            {2 * Exp, 2 * Coin, 2 * BindCoin};
        true when IsDouble =:= false ->
            %% 活动时间 TODO: 
            {2 * Exp, 2 * Coin, BindCoin};
        true when IsDouble =:= true ->
            %% 活动时间，双倍阶段 TODO:
            {3 * Exp, 3 * Coin, 3 * BindCoin};
        _ -> {0, 0, 0}
    end.

%% 奖励处理，返回{Exp, Coin, BindCoin}
get_escort_award(RoleLev, EscortType, EscortQua, AcceptTime) ->
    {Exp, Coin, _Tax} = escort_data:escort_award(RoleLev),
    MulCoin = escort_data:multiple(coin, EscortQua),
    MulExp = escort_data:multiple(exp, EscortQua),
    {E, C, BC} = case EscortType of
        ?escort_type_coin -> {MulExp*Exp, Coin*MulCoin, 0};
        _ -> {MulExp*Exp, 0, Coin*MulCoin}
    end,
    {NewE, NewC, NewBC} = campaign_award(is_double_award(AcceptTime), E, C, BC),
    {round(NewE), round(NewC), round(NewBC)}.

%% 获取当天0时0分0秒的时间戳
%% unixtime(today) ->
%%     {M, S, MS} = now(),
%%     {_, Time} = now_to_datetime({M, S, MS}),
%%     M * 1000000 + S - calendar:time_to_seconds(Time).
%% now_to_datetime({MSec, Sec, _uSec}) ->
%%     Sec0 = MSec*1000000 + Sec + 719528 * 86400 + 8 * 3600, %为时区打补丁 8小时的毫秒
%%     calendar:gregorian_seconds_to_datetime(Sec0).

%% 获取日期信息 
today() ->
    {Y, M, D} = erlang:date(),
    (Y * 10000 + M * 100 + D).

%% 镖车品质对应的外观效果值
quality_to_looks_val(Quality, EscortType) ->
    LooksVal = case Quality of
        ?escort_quality_white ->
            ?LOOKS_VAL_ACT_ESCORT_WHITE;
        ?escort_quality_green ->
            ?LOOKS_VAL_ACT_ESCORT_GREEN;
        ?escort_quality_blue ->
            ?LOOKS_VAL_ACT_ESCORT_BLUE;
        ?escort_quality_purple ->
            ?LOOKS_VAL_ACT_ESCORT_PURPLE;
        ?escort_quality_orange ->
            ?LOOKS_VAL_ACT_ESCORT_ORANGE;
        _ ->
            ?LOOKS_VAL_ACT_ESCORT_WHITE
    end,
    LooksMod = case EscortType of
        ?escort_type_coin -> 0;
        _ -> 1
    end,
    {LooksVal, LooksMod}.


%% 判断角色队伍是否有运镖人
check_is_rob_team(#role{pid = Pid, team_pid = TeamPid}) when is_pid(TeamPid) ->
    case team:get_team_info(TeamPid) of
        #team{leader = Leader, member = MemberList} ->
            check_is_rob_member([Leader | MemberList], Pid);
        _Any -> false
    end;
check_is_rob_team(_Role) ->
    false.

%% 组员是否为运镖状态
check_is_rob_member([], _SrcPid) ->
    false;
check_is_rob_member([#team_member{pid = Pid, mode = 0} | T], SrcPid) when Pid =/= SrcPid ->
    case role:apply(sync, Pid, {escort, apply_check_is_rob_member, []}) of
        true -> true;
        false ->
            check_is_rob_member(T, SrcPid)
    end;
check_is_rob_member([#team_member{} | T], SrcPid) ->
    check_is_rob_member(T, SrcPid).
%% 角色进程判断是否运镖
apply_check_is_rob_member(#role{event = ?event_escort}) ->
    {ok, true};
apply_check_is_rob_member(_Role) ->
    {ok, false}.

%% 劫镖:处理劫镖失败方
deal_with_loser([#fighter{pid = Pid, type = ?fighter_type_role, is_escape = IsEscape} | T]) ->
    case role:apply(sync, Pid, {escort, apply_deal_with_loser, [IsEscape]}) of
        {true, RobCoin} ->
            [RobCoin | deal_with_loser(T)];
        _Other ->
            deal_with_loser(T)
    end;
deal_with_loser([_Fighter | T]) ->
    deal_with_loser(T);
deal_with_loser([]) ->
    [].

%% 劫镖:角色进程处理战败情况
apply_deal_with_loser(Role = #role{pid = Pid, name = _Name, lev = Lev, event = ?event_escort, escort = Escort = #escort{accept_time = AcceptTime, quality = Quality, type = EscortType, lose = {Time, Num}}, link = #link{conn_pid = ConnPid}}, IsEscape) ->
    case EscortType of
        ?escort_type_coin ->
            case escort_rpc:handle(13103, {}, Role) of
                {reply, {_Rs, Reason}} ->
                    {ok, {false, Reason}};
                {reply, _Reply, NewRole = #role{event = _Event}} ->
                    sys_conn:pack_send(ConnPid, 13103, {?true, <<>>}),
                    _Lose = case today() =:= Time of
                        true -> {Time, (Num + 1)};
                        false -> {today(), 0}
                    end,
                    case IsEscape of
                        1 -> sys_conn:pack_send(ConnPid, 10931, {55, ?L(<<"您竟然丢下美女任人劫色，美女向您投来了哀怨的目光。任务失败！">>), []});
                        _ -> ignore
                    end,
                    {NewExp, NewCoin, _NewCoinBind} = get_escort_award(Lev, EscortType, Quality, AcceptTime),
                    NewRole2 = NewRole#role{escort = Escort#escort{accept_time = 0, refresh_time = util:unixtime(), quality = ?escort_quality_white, lose = {today(), 0}}},
                    GL = [#gain{label = coin_bind, val = round(NewCoin/2)}
                        ,#gain{label = exp, val = NewExp}],
                    case role_gain:do(GL, NewRole2) of
                        {ok, NewRole3 = #role{event = _Event3}} ->
                            notice_inform(Pid, [{bind_coin, round(NewCoin/2)}, {exp, NewExp}]),
                            {ok, {true, round(NewCoin/2)}, NewRole3};
                        {false, Reason} ->
                            {ok, {false, Reason}}
                    end
            end;
        ?escort_type_bind_coin ->
            {ok, {false, ?L(<<"绑定金币不可以劫">>)}}
    end;
apply_deal_with_loser(_Role, _IsEscape) ->
    {ok, {false, ignore}}.

%% 劫镖:胜方
deal_with_winner([#fighter{pid = Pid, type = ?fighter_type_role} | T]) ->
    case role:apply(sync, Pid, {escort, apply_deal_with_winner, []}) of
        {RoleId, SrvId, Name} -> [{RoleId, SrvId, Name, Pid} | deal_with_winner(T)];
        _ -> deal_with_winner(T)
    end;
deal_with_winner([_Fighter | T]) ->
    deal_with_winner(T);
deal_with_winner([]) ->
    [].
%% 劫镖:角色进程胜方
%% 防方
apply_deal_with_winner(Role = #role{id = {RoleId, SrvId}, event = Event, name = Name, escort = Escort = #escort{rob = {Time, Num}, lose = {LTime, LNum}}}) ->
    %% 被劫多少次
    Lose = case today() =:= LTime of
        true -> {LTime, (LNum + 1)};
        false -> {today(), 1}
    end,
    {NewRole, NewTime, NewNum} = case Event =/= ?event_escort of
        true -> 
            {Time2, Num2}  = case today() =:= Time of
                true -> {Time, (Num + 1)};
                false -> {today(), 1}
            end,
            {role_listener:acc_event(Role, {105, 1}), Time2, Num2};
        false -> {Role, Time, Num}
    end,
    case NewNum > 8 of
        true -> {ok, ignore, NewRole#role{escort = Escort#escort{rob = {NewTime, NewNum}, lose = Lose}}};
        false -> {ok, {RoleId, SrvId, Name}, NewRole#role{escort = Escort#escort{rob = {NewTime, NewNum}, lose = Lose}}}
    end.

%% 发镖银
assign_rob_coin([Coin | T], WinnerList) ->
    case util:rand_list(WinnerList) of
        null -> 
            assign_rob_coin(T, WinnerList);
        {_RoleId, _SrvId, _Name, RolePid} ->
            role:apply(async, RolePid, {escort, apply_assign_rob_coin, [Coin]}),
            assign_rob_coin(T, WinnerList)
    end;
assign_rob_coin([], _WinnerList) ->
    ok.

%% 劫到镖银
apply_assign_rob_coin(Role = #role{pid = Pid, assets = Assets = #assets{coin = Coin}}, RobCoin) ->
    notice:inform(Pid, util:fbin(?L(<<"你劫财劫色成功,获得了{str,金币,#FFD700} ~w">>), [RobCoin])),
    NewRole = Role#role{assets = Assets#assets{coin = (Coin + RobCoin)}},
    role_api:push_assets(Role, NewRole),
    {ok, NewRole}.

%% 公告
fighter_to_msg([#fighter{type = ?fighter_type_role, rid = RoleId1, srv_id = SrvId1, name = Name1}]) ->
    util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [RoleId1, SrvId1, Name1]);
fighter_to_msg([#fighter{type = ?fighter_type_role, rid = RoleId1, srv_id = SrvId1, name = Name1},
        #fighter{type = ?fighter_type_role, rid = RoleId2, srv_id = SrvId2, name = Name2}]) ->
    Rname1 = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [RoleId1, SrvId1, Name1]),
    Rname2 = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [RoleId2, SrvId2, Name2]),
    util:fbin(<<"~s~s">>, [Rname1, Rname2]);
fighter_to_msg([#fighter{type = ?fighter_type_role, rid = RoleId1, srv_id = SrvId1, name = Name1},
        #fighter{type = ?fighter_type_role, rid = RoleId2, srv_id = SrvId2, name = Name2},
        #fighter{type = ?fighter_type_role, rid = RoleId3, srv_id = SrvId3, name = Name3} | _]) ->
    Rname1 = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [RoleId1, SrvId1, Name1]),
    Rname2 = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [RoleId2, SrvId2, Name2]),
    Rname3 = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [RoleId3, SrvId3, Name3]),
    util:fbin(<<"~s~s~s">>, [Rname1, Rname2, Rname3]).

fighter_to_interface(Winner, Loser) ->
    fighter_to_interface(Winner, Loser, <<"">>).
fighter_to_interface(Winner, [], LoserName) ->
    do_fighter_to_interface(Winner, LoserName);
fighter_to_interface(Winner, [#fighter{type = ?fighter_type_role, name = Name} | T], LoserName) ->
    NewLoserName = case LoserName =:= <<"">> of
        true ->
            util:fbin(<<"~s">>, [Name]);
        false ->
            util:fbin(<<"~s、~s">>, [LoserName, Name])
    end,
    fighter_to_interface(Winner, T, NewLoserName);
fighter_to_interface(Winner, [_ | T], LoserName) ->
    fighter_to_interface(Winner, T, LoserName).

do_fighter_to_interface([], _LoserName) -> ok;
do_fighter_to_interface([#fighter{type = ?fighter_type_role, rid = Rid, srv_id = SrvId, name = Name} | T], LoserName) ->
    notice:send_interface({role_id, {Rid, SrvId}}, 5, Name, LoserName, <<"">>, []),
    do_fighter_to_interface(T, LoserName);
do_fighter_to_interface([_ | T], LoserName) ->
    do_fighter_to_interface(T, LoserName).

%% 获取参战NPC百炼精魄
defender_fighter(Role = #role{event = ?event_escort, lev = Lev, pos = #pos{map = MapId}, escort = #escort{quality = Quality}}) ->
    NpcId = defender_fighter_npc(Lev, Quality),
    case npc_data:get(NpcId) of
        false -> {false, util:fbin(?L(<<"找不到NPC~w">>), [NpcId])};
        {ok, BaseRela} ->
            NpcRela = npc_convert:base_to_npc(0, BaseRela, #pos{map = MapId}),
            {ok, FighterRela} = npc_convert:do(to_fighter, NpcRela, Role, ?ms_rela_escort),
            {ok, FighterRela}
    end;
defender_fighter(_Role) ->
    {false, ?L(<<"你没有在护送美女">>)}.
defender_fighter_npc(Lev, ?escort_quality_white)  when Lev < 49 -> 10050;
defender_fighter_npc(Lev, ?escort_quality_green)  when Lev < 49 -> 10051;
defender_fighter_npc(Lev, ?escort_quality_blue)   when Lev < 49 -> 10052;
defender_fighter_npc(Lev, ?escort_quality_purple) when Lev < 49 -> 10053;
defender_fighter_npc(Lev, ?escort_quality_orange) when Lev < 49 -> 10054;
defender_fighter_npc(Lev, ?escort_quality_white)  when Lev < 59 -> 10060;
defender_fighter_npc(Lev, ?escort_quality_green)  when Lev < 59 -> 10061;
defender_fighter_npc(Lev, ?escort_quality_blue)   when Lev < 59 -> 10062;
defender_fighter_npc(Lev, ?escort_quality_purple) when Lev < 59 -> 10063;
defender_fighter_npc(Lev, ?escort_quality_orange) when Lev < 59 -> 10064;
defender_fighter_npc(_Lev, ?escort_quality_white)  -> 10065;
defender_fighter_npc(_Lev, ?escort_quality_green)  -> 10066;
defender_fighter_npc(_Lev, ?escort_quality_blue)   -> 10067;
defender_fighter_npc(_Lev, ?escort_quality_purple) -> 10068;
defender_fighter_npc(_Lev, ?escort_quality_orange) -> 10069.

%% 完成运镖任务次数
escort_finish_total([]) -> 0;
escort_finish_total([#task_finish{type = ?task_type_rc, sec_type = 1, finish_num = FinishNum} | T]) ->
    FinishNum + escort_finish_total(T);
escort_finish_total([_TaskFinish | T]) ->
    escort_finish_total(T).

%% 运镖任务
has_escort_task([]) -> false;
has_escort_task([TaskId | T]) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{type = ?task_type_rc, sec_type = 1}} ->
            true;
        _ -> has_escort_task(T)
    end.

