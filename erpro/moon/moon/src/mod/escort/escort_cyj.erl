%%----------------------------------------------------
%% @doc 其他护送任务活动进程，包括：
%%      1，重阳节护送美女登高
%%      2，圣诞节护送圣诞老人
%%
%% @author yankai
%% @end
%%----------------------------------------------------
-module(escort_cyj).

-export([
        open_panel/1
        ,refresh/2
        ,accept/2
        ,giveup/1
        ,finish/1
        ,check_combat_start/2
        ,combat_start/2
        ,combat_over/1
        ,login/1
        ,apply_deal_with_winner/1
        ,apply_deal_with_loser/2
        ,apply_assign_rob_coin/2
        ,get_task_leave/1
        ,check_finger_guessing_result/2
        ,choose_question/0
        ,check_question_result/3
        ,check_roll_dice_result/2
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

-define(FINGER_GUESSING_PAPER, 1).  %% 猜拳游戏-布
-define(FINGER_GUESSING_SCISSORS, 2).  %% 猜拳游戏-剪刀
-define(FINGER_GUESSING_STONE, 3).  %% 猜拳游戏-石头
-define(FINGER_GUESSING_RESULT_WIN, 1).   %% 猜拳游戏结果-玩家赢
-define(FINGER_GUESSING_RESULT_LOSE, 2).  %% 猜拳游戏结果-玩家输
-define(FINGER_GUESSING_RESULT_DRAW, 3).       %% 猜拳游戏结果-平局


%%----------------------------------------------------
%% API
%%----------------------------------------------------

%% @spec open_panel(Role::#role{}) -> {ok, NewRole::#role{}, Quality::integer(), Times::integer()} | {false, Reason::binary()}
%% @doc
%% <pre>
%% 打开护送界面
%% </pre>
open_panel(_Role = #role{lev = Lev}) when Lev < 40 ->
    {false, ?L(<<"只有40级以上才可以做护送任务">>)};
open_panel(Role = #role{escort_child = EscortChild = #escort_child{refresh_time = RefreshTime, quality = Quality}}) ->
    NewQuality = case util:unixtime({today, RefreshTime}) =:= util:unixtime(today) of
        true -> Quality;
        false -> ?escort_quality_white
    end,
    {ok, FinishRc} = role:get_dict(task_finish_rc),
    Times = get_escort_cyj_num(FinishRc),
    NewRole = Role#role{escort_child = EscortChild#escort_child{quality = NewQuality, refresh_time = RefreshTime}},
    push_preview_award(NewRole),
    {ok, NewRole, NewQuality, Times}.

%% @spec open_panel(Role::#role{}, RefreshType::integer()) -> {ok, NewRole::#role{}, Quality::integer()} | {false, Reason::binary()}
%% @doc
%% <pre>
%% 刷美女
%% </pre>
refresh(_Role = #role{lev = Lev}, _RefreshType) when Lev < 40 ->
    {false, ?L(<<"只有40级以上才可以做护送任务">>)};
refresh(Role, RefreshType) ->
    case do_refresh(Role, RefreshType) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole, Quality} ->
            push_preview_award(NewRole),
            {ok, NewRole, Quality}
    end.

%% @spec accept(Role, EscortType) -> {ok, NewRole} | {false, Reason}
%% 接镖
accept(Role, EscortType) ->
    case do_accept([status], Role, EscortType) of
        {ok, NewRole} -> {ok, NewRole};
        {false, Reason} -> {false, Reason}
    end.

%% @spec finish(Role) -> {ok, NewRole} | {false, Reason}
%% @doc
%% <pre>
%% Role = NewRole = #role{} 角色记录
%% Reason = binary() 失败原因
%% 交镖
%% </pre>
finish(Role = #role{looks = Looks, event = Event, escort_child = EscortChild, buff = #rbuff{buff_list = BuffList}}) ->
    case Event =/= ?event_escort_cyj of
        true ->
            {false, ?L(<<"你没有护送任务">>)};
        false ->
            %% 删除运镖buff
            {ok, NewRole} = case lists:keyfind(?escort_cyj_buff_label, #buff.label, BuffList) of
                false -> {ok, Role};
                #buff{id = BuffId} -> buff:del_by_id(Role, BuffId)
            end,
            NewLooks = lists:keydelete(?LOOKS_TYPE_ACT, 1, Looks),
            NewRole1 = NewRole#role{event = ?event_no, looks = NewLooks, escort_child = EscortChild#escort_child{accept_time = 0, refresh_time = util:unixtime(), quality = ?escort_quality_white}},
            NewRole2 = looks:calc(NewRole1),
            map:role_update(NewRole2),
            {ok, NewRole2}
    end.

%% @spec giveup(Role) -> {ok, NewRole} | {false, Reason}
%% 放弃护送
giveup(Role = #role{event = Event, looks = Looks, escort_child = EscortChild, task = TaskList, buff = #rbuff{buff_list = BuffList}}) ->
    Result = case Event =/= ?event_escort_cyj of
        true ->
            EscortTask = [Task || Task = #task{type = Type, sec_type = SecType} <- TaskList, Type =:= ?task_type_rc, SecType =:= 27],
            case length(EscortTask) > 0 of
                true -> true;
                false -> {false, ?L(<<"你目前没有护送任务">>)}
            end;
        false -> true
    end,
    case Result of
        true ->
            %% 删除运镖buff
            {ok, NewRole} = case lists:keyfind(?escort_cyj_buff_label, #buff.label, BuffList) of
                false ->
                    {ok, Role};
                #buff{id = BuffId} ->
                    buff:del_by_id(Role, BuffId)
            end,
            NewLooks = lists:keydelete(?LOOKS_TYPE_ACT, 1, Looks),
            NewRole1 = NewRole#role{event = ?event_no, looks = NewLooks, escort_child = EscortChild#escort_child{accept_time = 0, refresh_time = util:unixtime(), quality = ?escort_quality_white}},
            NewRole2 = looks:calc(NewRole1),
            map:role_update(NewRole2),
            {ok, NewRole2};
        _ -> Result
    end.

%% 劫镖检查
check_combat_start(_Attacker = #role{event = ?event_escort_cyj}, _Defender) -> {false, get_talk(1)};
check_combat_start(_Attacker, _Defender = #role{escort_child = #escort_child{type = ?escort_type_bind_coin}}) ->
    {false, ?L(<<"对方选择的是“低调护送”，这么低调，不劫也罢！">>)};
check_combat_start(_Attacker = #role{name = _Name, escort_child = #escort_child{rob = {PDate, PTime}}}, _Defender = #role{escort_child = #escort_child{lose = {LDate, LTime}}}) ->
    Today = today(),
    case PDate =:= Today andalso PTime >= 8 of
        true -> {false, get_talk(2)};
        false ->
            case LDate =:= Today andalso LTime >= 3 of
                true -> {false, get_talk(3)};
                false -> 
                    ok
            end
    end.

%% 打劫
combat_start(Attacker, Defender) ->
    case {defender_fighter(Attacker), defender_fighter(Defender)} of
        {{ok, APNC}, {ok, DNPC}} ->
            combat:start(?combat_type_rob_escort_cyj, [APNC | role_api:fighter_group(Attacker)], [DNPC| role_api:fighter_group(Defender)]);
        {{ok, APNC}, {false, _}} ->
            combat:start(?combat_type_rob_escort_cyj, [APNC | role_api:fighter_group(Attacker)], role_api:fighter_group(Defender));
        {{false, _}, {ok, DNPC}} ->
            combat:start(?combat_type_rob_escort_cyj, role_api:fighter_group(Attacker), [DNPC| role_api:fighter_group(Defender)]);
        {{false, _}, {false, _Reason}} ->
            ?DEBUG("[劫镖]找不到美女npc:~w", [_Reason]),
            combat:start(?combat_type_rob_escort_cyj, role_api:fighter_group(Attacker), role_api:fighter_group(Defender))
    end.

%% 劫镖结束
combat_over(#combat{winner = Winner, loser = Loser, type = ?combat_type_rob_escort_cyj}) ->
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
                    mail:send_system({LRoleId, LSrvId}, {?L(<<"系统邮件">>), util:fbin(get_talk(4), [WName]), [], []}),
                    ok;
                false -> ignore
            end,
            W = fighter_to_msg(Winner2),
            L = fighter_to_msg(Loser2),
            notice:send(53, util:fbin(get_talk(5), [W, L]));
        false -> ignore
    end;
combat_over(_Combat) ->
    ok.

%% 推送界面奖励显示，默认按照金币奖励
push_preview_award(#role{link = #link{conn_pid = ConnPid}, lev = RoleLev, escort_child = #escort_child{quality = Quality, type = EscortType}}) ->
    {Exp, Coin, BindCoin} = escort:get_escort_award(RoleLev, EscortType, Quality, util:unixtime()),
    sys_conn:pack_send(ConnPid, 13105, {Exp, Coin, BindCoin}).

%% 登录
login(Role = #role{event = ?event_escort_cyj, task = TaskList, escort_child = #escort_child{quality = Quality, type = EscortType}, looks = Looks, buff = #rbuff{buff_list = BuffList}}) ->
    EscortTask = [Task || Task = #task{type = Type, sec_type = SecType} <- TaskList, Type =:= ?task_type_rc, SecType =:= 27],
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
            {ok, NewRole} = case lists:keyfind(?escort_cyj_buff_label, #buff.label, BuffList) of
                false ->
                    {ok, Role};
                #buff{id = BuffId} ->
                    buff:del_by_id(Role, BuffId)
            end,
            NewRole#role{event = ?event_no}
    end;
login(Role) -> Role.

%% 获取运镖任务剩余次数
get_task_leave(#role{event = ?event_escort_cyj}) -> {false, ?L(<<"正在护送">>)};
get_task_leave(_Role) ->
    {ok, FinishRc} = role:get_dict(task_finish_rc), %% [#task_finish{}]
    {ok, AcceptableRc} = role:get_dict(task_acceptable_rc),
    case has_escort_task(AcceptableRc) of
        true ->
            Total = escort_finish_total(FinishRc),
            case Total > 2 of
                true -> {ok, 0};
                false -> {ok, 2 - Total}
            end;
        false -> {ok, 0}
    end.
%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------
get_escort_cyj_num(undefined) -> 0;
get_escort_cyj_num(FinishRc) ->
    case [Task || Task = #task_finish{type = ?task_type_rc, sec_type = 27} <- FinishRc] of
        [] -> ?escort_child_total_times;
        [#task_finish{finish_time = FinishTime} | _] ->
            case ?escort_child_total_times > FinishTime of
                true -> ?escort_child_total_times - FinishTime;
                false -> 0
            end;
        _ -> 0
    end.

%% 刷美女
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
                    case role_gain:do([#loss{label = gold, val = pay:price(?MODULE, beauty, null)}], Role) of
                        {ok, NewRole} ->
                            gen_quality(NewRole);
                        {false, _Any} ->
                            {false, ?L(<<"扣除晶钻失败">>)}
                    end;
                false ->
                    {false, ?L(<<"晶钻不足">>)}
            end
    end.

%% 接镖
do_accept([], Role = #role{name = _RoleName, escort_child = EscortChild = #escort_child{quality = Quality}}, EscortType) ->
    NewRoleBuff = case buff:del_buff_by_label(Role, ?escort_cyj_buff_label) of
        {ok, NewRoleBuff2} ->
            NewRoleBuff2;
        false ->
            Role 
    end,
    case buff:add(NewRoleBuff, ?escort_cyj_buff_label) of
        {ok, NR = #role{looks = Looks}} ->
            NewRole2 = role_api:push_attr(NR),
            {LooksVal, LooksMod} = quality_to_looks_val(Quality, EscortType),
            NewLooks = case lists:keyfind(?LOOKS_TYPE_ACT, 1, Looks) of
                false ->
                    [{?LOOKS_TYPE_ACT, LooksMod, LooksVal} | Looks];
                _Other ->
                    lists:keyreplace(?LOOKS_TYPE_ACT, 1, Looks, {?LOOKS_TYPE_ACT, LooksMod, LooksVal})
            end,
            NewRole3 = NewRole2#role{event = ?event_escort_cyj, looks = NewLooks},
            NewRole4 = looks:calc(NewRole3),
            map:role_update(NewRole4),
            {ok, NewRole4#role{escort_child = EscortChild#escort_child{accept_time = util:unixtime(), type = EscortType, lose = {today(), 0}}}};
        {false, Reason} ->
            {false, Reason}
    end;
%% 检查状态
do_accept([status | T], Role = #role{lev = Lev, event = Event, team_pid = TeamPid, status = Status, ride = Ride, mod = {_Mod1, _}, task = TaskList}, EscortType) ->
    case Status =:= ?status_fight of
        true -> {false, ?L(<<"大哥,你在打架也要做护送任务啊">>)};
        false ->
            case Lev < 1 of
                true -> {false, ?L(<<"需要32级才可以参与护送任务">>)};
                false ->
                    case Event =/= ?event_no of
                        true -> {false, util:fbin(?L(<<"你好像正在做某些事，不可以做护送任务">>), [])};
                        false ->
                            %% TODO: 检查是否为杀戮
                            %% case Mod1 =:= 1 of
                            %%     true -> {false, ?L(<<"和平模式不可以护送">>)};
                            %%     false -> 
                                    case Ride =/= ?ride_no of
                                        true -> {false, ?L(<<"飞行状态不可以护送">>)};
                                        false -> 
                                            case is_pid(TeamPid) of
                                                true -> {false, ?L(<<"组队状态不可以护送!">>)};
                                                false ->
                                                    OtherEscortTasks = [Task || Task = #task{type = ?task_type_rc, sec_type = SecType} <- TaskList, SecType=:=1],
                                                    case OtherEscortTasks of
                                                        [_|_] ->
                                                            {false, ?L(<<"不能同时接多个护送任务">>)};
                                                        _ ->
                                                            do_accept(T, Role, EscortType)
                                                    end
                                            end
                                    end
                           %% end
                    end
            end
    end.

%% 根据概率产生镖车品质
gen_quality(Role = #role{id = {Rid, SrvId}, name = Name, escort_child = EscortChild}) ->
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
            notice:send(53, util:fbin(get_talk(14), [RoleName])),
            ?escort_quality_orange
    end,
    {ok, Role#role{escort_child = EscortChild#escort_child{refresh_time = util:unixtime(), quality = Quality}}, Quality}.

%% 镖车品质对应的外观效果值
quality_to_looks_val(Quality, EscortType) ->
    case escort_cyj_mgr:get_escort_act_type() of
        ?escort_act_type_chrismas -> quality_to_looks_val_chrismas(Quality, EscortType);
        _ -> quality_to_looks_val_cyj(Quality, EscortType)
    end.

quality_to_looks_val_cyj(Quality, EscortType) ->
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
quality_to_looks_val_chrismas(Quality, EscortType) ->
    LooksVal = case Quality of
        ?escort_quality_white ->
            ?LOOKS_VAL_ACT_ESCORTCHILD_WHITE;
        ?escort_quality_green ->
            ?LOOKS_VAL_ACT_ESCORTCHILD_GREEN;
        ?escort_quality_blue ->
            ?LOOKS_VAL_ACT_ESCORTCHILD_BLUE;
        ?escort_quality_purple ->
            ?LOOKS_VAL_ACT_ESCORTCHILD_PURPLE;
        ?escort_quality_orange ->
            ?LOOKS_VAL_ACT_ESCORTCHILD_ORANGE;
        _ ->
            ?LOOKS_VAL_ACT_ESCORTCHILD_WHITE
    end,
    LooksMod = case EscortType of
        ?escort_type_coin -> 0;
        _ -> 1
    end,
    {LooksVal, LooksMod}.

%% 获取日期信息 
today() ->
    {Y, M, D} = erlang:date(),
    (Y * 10000 + M * 100 + D).

%% 获取参战NPC
defender_fighter(Role = #role{lev = Lev, event = ?event_escort_cyj, pos = #pos{map = MapId}, escort_child = #escort_child{quality = Quality}}) ->
    %% NpcId = 10092, %% 小屁孩
    NpcId = defender_fighter_npc(Lev, Quality),
    case npc_data:get(NpcId) of
        false -> {false, util:fbin(?L(<<"找不到NPC~w">>), [NpcId])};
        {ok, BaseRela} ->
            NpcRela = npc_convert:base_to_npc(0, BaseRela, #pos{map = MapId}),
            {ok, FighterRela} = npc_convert:do(to_fighter, NpcRela, Role, ?ms_rela_escort),
            {ok, FighterRela}
    end;
defender_fighter(_Role) ->
    {false, get_talk(6)}.


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

%% 劫镖:处理劫镖失败方
deal_with_loser([#fighter{pid = Pid, type = ?fighter_type_role, is_escape = IsEscape} | T]) ->
    case role:apply(sync, Pid, {escort_cyj, apply_deal_with_loser, [IsEscape]}) of
        {true, RobCoin} ->
            [RobCoin | deal_with_loser(T)];
        _Other ->
            deal_with_loser(T)
    end;
deal_with_loser([_Fighter | T]) ->
    deal_with_loser(T);
deal_with_loser([]) ->
    [].

%% 劫镖:胜方
deal_with_winner([#fighter{pid = Pid, type = ?fighter_type_role} | T]) ->
    case role:apply(sync, Pid, {escort_cyj, apply_deal_with_winner, []}) of
        {RoleId, SrvId, Name} -> [{RoleId, SrvId, Name, Pid} | deal_with_winner(T)];
        _ -> deal_with_winner(T)
    end;
deal_with_winner([_Fighter | T]) ->
    deal_with_winner(T);
deal_with_winner([]) ->
    [].

%% 劫镖:角色进程处理战败情况
apply_deal_with_loser(Role = #role{pid = Pid, name = _Name, lev = Lev, event = ?event_escort_cyj, escort_child = EscortChild = #escort_child{quality = Quality, type = Type, lose = {Time, Num}}, link = #link{conn_pid = ConnPid}}, IsEscape) ->
    case Type of
        ?escort_type_coin ->
            case task_giveup(Role) of
                {false, Reason} ->
                    {ok, {false, Reason}};
                {ok, NewRole} ->
                    sys_conn:pack_send(ConnPid, 13103, {?true, <<>>}),
                    _Lose = case today() =:= Time of
                        true -> {Time, (Num + 1)};
                        false -> {today(), 0}
                    end,
                    case IsEscape of
                        1 -> sys_conn:pack_send(ConnPid, 10931, {55, get_talk(7), []});
                        _ -> ignore
                    end,
                    {Exp, Coin, _Tax} = escort_data:escort_award(Lev),
                    CMul = escort_data:multiple(coin, Quality),
                    EMul = escort_data:multiple(exp, Quality),
                    {NewExp, NewCoin} = {round(Exp * EMul * 10), round(Coin * CMul)},
                    NewRole2 = NewRole#role{escort_child = EscortChild#escort_child{accept_time = 0, refresh_time = util:unixtime(), quality = ?escort_quality_white, lose = {today(), 0}}},
                    case role_gain:do([#gain{label = coin_bind, val = round(NewCoin/2)}, #gain{label = exp, val = NewExp}], NewRole2) of
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

%% 劫镖:角色进程胜方
%% 防方
apply_deal_with_winner(Role = #role{id = {RoleId, SrvId}, event = Event, name = Name, escort_child = EscortChild = #escort_child{rob = {Time, Num}, lose = {LTime, LNum}}}) ->
    %% 被劫多少次
    Lose = case today() =:= LTime of
        true -> {LTime, (LNum + 1)};
        false -> {today(), 1}
    end,
    {NewRole, NewTime, NewNum} = case Event =/= ?event_escort_cyj of
        true -> 
            case today() =:= Time of
                true -> {Role, Time, (Num + 1)};
                false -> {Role, today(), 1}
            end;
        false -> {Role, Time, Num}
    end,
    case NewNum > 8 of
        true -> {ok, ignore, NewRole#role{escort_child = EscortChild#escort_child{rob = {NewTime, NewNum}, lose = Lose}}};
        false -> {ok, {RoleId, SrvId, Name}, NewRole#role{escort_child = EscortChild#escort_child{rob = {NewTime, NewNum}, lose = Lose}}}
    end.

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
notice_inform(Pid, [{item, ItemBaseId} | T]) ->
    ItemStr = notice:item_to_msg({ItemBaseId, 1, 1}),
    notice:inform(Pid, util:fbin(?L(<<"获得 ~s">>), [ItemStr])),
    notice_inform(Pid, T);
notice_inform(Pid, [_NoMatch | T]) ->
    notice_inform(Pid, T);
notice_inform(_Pid, []) ->
    ok.

%% 发镖银
assign_rob_coin([Coin | T], WinnerList) ->
    case util:rand_list(WinnerList) of
        null -> 
            assign_rob_coin(T, WinnerList);
        {_RoleId, _SrvId, _Name, RolePid} ->
            role:apply(async, RolePid, {escort_cyj, apply_assign_rob_coin, [Coin]}),
            assign_rob_coin(T, WinnerList)
    end;
assign_rob_coin([], _WinnerList) ->
    ok.

%% 劫到镖银
apply_assign_rob_coin(Role = #role{pid = Pid, assets = Assets = #assets{coin = Coin}}, RobCoin) ->
    notice:inform(Pid, util:fbin(?L(<<"你打劫成功,获得了{str,金币,#FFD700} ~w">>), [RobCoin])),
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


task_giveup(Role = #role{task = TaskList}) ->
    Fun = fun(#task{task_id = TaskId}) ->
        {ok, #task_base{type = Type, sec_type = SecType}} = task_data:get(TaskId),
        case Type =:= ?task_type_rc andalso SecType =:= 27 of
            true -> true;
            _ -> false
        end
    end,
    NewTaskList = lists:filter(Fun, TaskList),
    case length(NewTaskList) > 0 of
        true ->
            [#task{task_id = TaskId} | _T] = NewTaskList,
            TaskParamGiveup = #task_param_giveup{role = Role, task_id = TaskId},
            role:send_buff_begin(),
            case task:giveup_chain(TaskParamGiveup) of
                {ok, #task_param_giveup{role = NewRole}} ->
                    role:send_buff_flush(),
                    {ok, NewRole};
                {false, Reason} ->
                    role:send_buff_clean(),
                    {false, Reason}
            end;
        false ->
            {false, ?L(<<"没有护送任务">>)}
    end.

%% 完成运镖任务次数
escort_finish_total([]) -> 0;
escort_finish_total([#task_finish{type = ?task_type_rc, sec_type = 27, finish_num = FinishNum} | T]) ->
    FinishNum + escort_finish_total(T);
escort_finish_total([_TaskFinish | T]) ->
    escort_finish_total(T).

%% 运镖任务
has_escort_task([]) -> false;
has_escort_task([TaskId | T]) ->
    case task_data:get(TaskId) of
        {ok, #task_base{type = ?task_type_rc, sec_type = 27}} ->
            true;
        _ -> has_escort_task(T)
    end.


%%------------------------------------------
%% 中途小游戏
%%------------------------------------------
%% 猜拳游戏结果判定
%% Finger = integer() 1|2|3
check_finger_guessing_result(Role, Finger) ->
    NpcFinger = util:rand(1, 3),
    Result = if
        NpcFinger =:= Finger -> ?FINGER_GUESSING_RESULT_DRAW;
        NpcFinger =:= ?FINGER_GUESSING_PAPER andalso Finger =:= ?FINGER_GUESSING_STONE -> ?FINGER_GUESSING_RESULT_LOSE;
        NpcFinger =:= ?FINGER_GUESSING_SCISSORS andalso Finger =:= ?FINGER_GUESSING_PAPER -> ?FINGER_GUESSING_RESULT_LOSE;
        NpcFinger =:= ?FINGER_GUESSING_STONE andalso Finger =:= ?FINGER_GUESSING_SCISSORS -> ?FINGER_GUESSING_RESULT_LOSE;
        true -> ?FINGER_GUESSING_RESULT_WIN
    end,
    %% Result = ?FINGER_GUESSING_RESULT_WIN,
    NewRole = case Result of
        ?FINGER_GUESSING_RESULT_WIN ->
            game_finish(Role, finger_guessing);
        ?FINGER_GUESSING_RESULT_LOSE ->
            game_failed(Role, finger_guessing);
        _ -> Role
    end,
    {reply, {NpcFinger, Result}, NewRole}.

%% 对诗游戏选题
choose_question() ->
    All = get_all_question(),
    Len = length(All),
    Idx = util:rand(1, Len),
    {Id, Question, Opt1, Opt2, _Answer} = lists:nth(Idx, All),
    {Id, Question, Opt1, Opt2}.

%% 获取全部对诗问题和答案
get_all_question() ->
    get_all_question(escort_cyj_mgr:get_escort_act_type()).
get_all_question(?escort_act_type_cyj) ->
    [
        {1, ?L(<<"“独在异乡为异客”的下一句是：">>), ?L(<<"每逢佳节倍思亲">>), ?L(<<"归心归望积风烟">>), 1},
        {2, ?L(<<"“遥知兄弟登高处”的下一句是：">>), ?L(<<"每逢佳节倍思亲">>), ?L(<<"遍插茱萸少一人">>), 2},
        {3, ?L(<<"“人生易老天难老”的下一句是：">>), ?L(<<"岁岁重阳，今又重阳">>), ?L(<<"一年一度秋风劲">>), 1},
        {4, ?L(<<"“他席他乡送客杯”的上一句是：">>), ?L(<<"鸿雁那从北地来">>), ?L(<<"九月九日望乡台">>), 2},
        {5, ?L(<<"“今日登高樽酒里”的下一句是：">>), ?L(<<"不知能有菊花无">>), ?L(<<"鸿雁那从北地来">>), 1},
        {6, ?L(<<"“尘世难逢开口笑”的下一句是：">>), ?L(<<"菊花须插满头归">>), ?L(<<"古往今来只如此">>), 1},
        {7, ?L(<<"“菊花何太苦”的下一句是：">>), ?L(<<"今朝再举觞">>), ?L(<<"遭此两重阳">>), 2},
        {8, ?L(<<"“还来就菊花”的上一句是：">>), ?L(<<"待到重阳日">>), ?L(<<"把酒话桑麻">>), 1},
        {9, ?L(<<"“何当载酒来”的下一句是：">>), ?L(<<"还来就菊花">>), ?L(<<"共醉重阳节">>), 2},
        {10, ?L(<<"“思量却也有悲时”的下一句是：">>), ?L(<<"问他有甚堪悲处">>), ?L(<<"重阳节近多风雨">>), 2}
    ];
get_all_question(?escort_act_type_chrismas) ->
    [
        {1, ?L(<<"“圣诞老人的原名是：">>), ?L(<<"圣·尼古拉">>), ?L(<<"圣·斯科拉">>), 1},
        {2, ?L(<<"“圣诞节时小孩的礼物一般用什么装：">>), ?L(<<"帽子">>), ?L(<<"袜子">>), 2},
        {3, ?L(<<"“圣诞餐桌上不可或缺的是什么：">>), ?L(<<"火鸡">>), ?L(<<"袜子">>), 1},
        {4, ?L(<<"“圣诞老人怎样悄悄进屋把礼物塞进挂在床头的袜子里：">>), ?L(<<"从窗户翻进屋">>), ?L(<<"从烟囱爬进屋">>), 2},
        {5, ?L(<<"“圣诞老人是哪国人：">>), ?L(<<"芬兰">>), ?L(<<"美国">>), 1},
        {6, ?L(<<"“圣诞老人坐什么车：">>), ?L(<<"马车">>), ?L(<<"麋鹿车">>), 2},
        {7, ?L(<<"“平安夜是几月几号：">>), ?L(<<"12月24号">>), ?L(<<"12月25号">>), 1},
        {8, ?L(<<"“中国内地圣诞节法定假日放几天：">>), ?L(<<"0天">>), ?L(<<"2天">>), 1},
        {9, ?L(<<"“圣诞树顶放什么：">>), ?L(<<"月亮">>), ?L(<<"星星">>), 2},
        {10, ?L(<<"““平安果”是什么水果：">>), ?L(<<"火龙果">>), ?L(<<"苹果">>), 2}
    ];
get_all_question(?escort_act_type_gen) ->
    [
        {1, ?L(<<"“游戏中觉醒技能书哪里来？">>), ?L(<<"挑战远古巨龙">>), ?L(<<"击杀世界BOSS">>), 1},
        {2, ?L(<<"“同一种宠物魔晶最多装备多少个:">>), ?L(<<"3个">>), ?L(<<"2个">>), 2},
        {3, ?L(<<"“洛水殿中哪种难度获得的只能是绑定金币:">>), ?L(<<"普通级别">>), ?L(<<"王者级别">>), 1},
        {4, ?L(<<"“仙宠阁位于哪里？">>), ?L(<<"洛水城">>), ?L(<<"起源圣城">>), 2},
        {5, ?L(<<"“师门竞技排名前几可以获得跨服竞技资格？">>), ?L(<<"前五">>), ?L(<<"前三">>), 1},
        {6, ?L(<<"“不能镶嵌特殊抗性宝石的装备是？">>), ?L(<<"武器">>), ?L(<<"时装">>), 1},
        {7, ?L(<<"“戒指宝盒可用哪种积分兑换而来？">>), ?L(<<"帮战积分">>), ?L(<<"竞技积分">>), 2},
        {8, ?L(<<"“护符宝盒可用哪种积分兑换而来？">>), ?L(<<"帮战积分">>), ?L(<<"竞技积分">>), 1},
        {9, ?L(<<"“祈福卷轴可在哪里使用？">>), ?L(<<"仙境寻宝">>), ?L(<<"天官赐福">>), 2},
        {10, ?L(<<"“灵幻石有什么用？">>), ?L(<<"生产装备">>), ?L(<<"生产宠物真身卡">>), 2},
        {11, ?L(<<"“装备洗炼无法洗出的属性是？">>), ?L(<<"抗石化">>), ?L(<<"抗遗忘">>), 2},
        {12, ?L(<<"“争夺仙府活动的开启的时间是？">>), ?L(<<"周二至周四">>), ?L(<<"周一至周三">>), 2},
        {13, ?L(<<"“提升八门遁甲等级的主要途径是什么？">>), ?L(<<"参加仙道会">>), ?L(<<"参加仙法竞技">>), 1}
    ];
get_all_question(_) -> [].


%% 对诗结果判定 -> ?true|?false
check_question_result(Role, Id, Answer) ->
    All = get_all_question(),
    Len = length(All),
    Result = case Id > 0 andalso Id =< Len of
        true -> 
            case lists:nth(Id, All) of
                {_, _, _, _, Answer} -> ?true;
                _ -> ?false
            end;
        false -> ?false
    end,
    NewRole = case Result of
        ?true ->
            game_finish(Role, question);
        ?false ->
            game_failed(Role, question)
    end,
    {reply, {Id, Result}, NewRole}.


%% 丢骰子游戏
%% RolePoint = integer()  玩家扔出的点数
check_roll_dice_result(Role, RolePoint) ->
    NpcPoint = util:rand(1, 6),
    {Result, NewRole} = if
        RolePoint > NpcPoint ->
            Role1 = game_finish(Role, {roll_dice, RolePoint, NpcPoint}),
            {?FINGER_GUESSING_RESULT_WIN, Role1};
        RolePoint < NpcPoint ->
            Role1 = game_failed(Role, roll_dice),
            {?FINGER_GUESSING_RESULT_LOSE, Role1};
        true ->
            {?FINGER_GUESSING_RESULT_DRAW, Role}
    end,
    {reply, {NpcPoint, Result}, NewRole}.

%% 小游戏完成触发事件 -> #role{}
game_finish(Role, Type) when Type =:= finger_guessing orelse Type =:= question ->
    role_listener:special_event(Role, {1056, 1});
game_finish(Role = #role{pid = Pid, id = {Rid, SrvId}, name = Name, escort_child = #escort_child{type = EscortType}}, {roll_dice, RolePoint, NpcPoint}) ->
    Role1 = role_listener:special_event(Role, {1056, 1}),
    %% 发常规奖品
    {NewExp, NewCoin} = calc_base_award(Role, roll_dice),
    {CoinGain, MsgCoin, MsgCoinBind} = case EscortType of
        ?escort_type_coin -> {#gain{label = coin, val = NewCoin}, NewCoin, 0};
        _ -> {#gain{label = coin_bind, val = NewCoin}, 0, NewCoin}
    end,
    ExpGain = #gain{label = exp, val = NewExp},
    NewRole = case role_gain:do([CoinGain, ExpGain], Role1) of
        {ok, Role2} ->
            notice_inform(Pid, [{coin, MsgCoin}, {bind_coin, MsgCoinBind}, {exp, NewExp}]),
            case MsgCoin > 0 of
                true -> npc_store_live:apply(async, {coin, MsgCoin});
                false -> ignore
            end,
            Role2;
        {false, _Reason} ->
            ?ERR("重阳节护送发放常规奖品失败:~w", [_Reason]),
            Role1
    end,
    %% 发额外奖品
    AwardNum = RolePoint - NpcPoint,
    case AwardNum > 0 of
        true ->
            {AwardItemBaseId1, AwardItemBaseId2} = get_other_award(),
            %% 额外奖品1
            case item:make(AwardItemBaseId1, 1, AwardNum) of
                {ok, [Item1]} ->
                    Msg = util:fbin(get_talk(8), [AwardNum]),
                    mail:send_system(Role, {get_talk(9), Msg, [], [Item1]});
                false -> 
                    ?ERR("创建重阳节护送美女奖品出错:~w", [AwardItemBaseId1])
            end,
            %% 额外奖品2
            RoleName = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [Rid, SrvId, Name]),
            if
                AwardNum =:= 3 ->
                    notice:send(53, util:fbin(get_talk(10), [RoleName]));
                AwardNum =:= 4 ->
                    notice:send(53, util:fbin(get_talk(11), [RoleName]));
                AwardNum =:= 5 ->
                    notice:send(53, util:fbin(get_talk(12), [RoleName])),
                    case item:make(AwardItemBaseId2, 1, 5) of
                        {ok, [Item2]} ->
                            mail:send_system(Role, {get_talk(9), get_talk(13), [], [Item2]});
                        false -> 
                            ?ERR("创建重阳节护送美女奖品出错:~w", [AwardItemBaseId2])
                    end;
                true -> ignore
            end;
        false -> ignore
    end,
    NewRole;
game_finish(Role, _Type) ->
    ?ERR("错误的小游戏类型:~w", [_Type]),
    Role.


%% 小游戏失败触发事件 -> #role{}
game_failed(Role = #role{pid = Pid, name = _Name, event = ?event_escort_cyj, escort_child = #escort_child{type = Type}, link = #link{conn_pid = ConnPid}}, GameType) ->
    %% 计算得益
    {NewExp, NewCoin} = calc_base_award(Role, GameType),
    case task_giveup(Role) of
        {false, _Reason} ->
            ?ERR("重阳节护送任务放弃失败:~w", [_Reason]),
            Role;
        {ok, NewRole} ->
            sys_conn:pack_send(ConnPid, 13103, {?true, <<>>}),
            case Type of
                ?escort_type_coin ->
                    Gains = [#gain{label = coin, val = NewCoin}, #gain{label = exp, val = NewExp}],
                    case role_gain:do(Gains, NewRole) of
                        {ok, NewRole1 = #role{event = _Event3}} ->
                            notice_inform(Pid, [{coin, NewCoin}, {exp, NewExp}]),
                            NewRole1;
                        {false, _Reason} ->
                            ?ERR("重阳节玩小游戏失败后发放奖品失败:~w", [_Reason]),
                            NewRole
                    end;
                ?escort_type_bind_coin -> 
                    Gains = [#gain{label = coin_bind, val = NewCoin}, #gain{label = exp, val = NewExp}],
                    case role_gain:do(Gains, NewRole) of
                        {ok, NewRole1 = #role{event = _Event3}} ->
                            notice_inform(Pid, [{bind_coin, NewCoin}, {exp, NewExp}]),
                            NewRole1;
                        {false, _Reason} ->
                            ?ERR("重阳节玩小游戏失败后发放奖品失败:~w", [_Reason]),
                            NewRole
                    end
            end
    end;
game_failed(Role, _) ->
    Role.

%% 计算基础奖励
calc_base_award(#role{name = _Name, lev = Lev, event = ?event_escort_cyj, escort_child = #escort_child{accept_time = AcceptTime, quality = Quality}}, GameType) ->
    {Exp, Coin, _Tax} = escort_data:escort_award(Lev),
    CMul = escort_data:multiple(coin, Quality),
    EMul = escort_data:multiple(exp, Quality),
    Ratio = calc_base_award_ratio(GameType, AcceptTime),
    {round(Exp * EMul * Ratio), round(Coin * CMul * Ratio)}.

%% 计算基础奖励倍率
calc_base_award_ratio(GameType, AcceptTime) ->
    IsDoubleAward = escort_mgr:is_double_award(AcceptTime),
    case GameType of
        finger_guessing ->
            case IsDoubleAward of
                {ok, true} -> 2;
                _ -> 1
            end;
        question ->
            case IsDoubleAward of
                {ok, true} -> 3;
                _ -> 2
            end;
        roll_dice ->
            case IsDoubleAward of
                {ok, true} -> 4;
                _ -> 3
            end;
        _ -> 1
    end.

%% 根据活动类型返回不同的对话
get_talk(Id) ->
    get_talk(escort_cyj_mgr:get_escort_act_type(), Id).

%% 重阳节
get_talk(?escort_act_type_cyj, 1) -> ?L(<<"你正在护送美女中，不可以劫别人哦！">>);
get_talk(?escort_act_type_cyj, 2) -> ?L(<<"你打劫已经达到8次，放过那些可怜的美女吧！">>);
get_talk(?escort_act_type_cyj, 3) -> ?L(<<"该护送美女的英雄已经被劫3次了，放过他吧！">>);
get_talk(?escort_act_type_cyj, 4) -> ?L(<<"很遗憾，您护送的美女被<font color=\"#ff0000\">【~s】</font>打劫了，没能成功护送。你仍能获得经验奖励，以及一半金币，但变为绑定金币。">>);
get_talk(?escort_act_type_cyj, 5) -> ?L(<<"~s不顾~s苦口婆心劝说，强行抢走了重阳节美女">>);
get_talk(?escort_act_type_cyj, 6) -> ?L(<<"你没有在护送美女">>);
get_talk(?escort_act_type_cyj, 7) -> ?L(<<"您竟然丢下美女在深山，吊丝们向您投来了哀怨的目光。任务失败！">>);
get_talk(?escort_act_type_cyj, 8) -> ?L(<<"恭喜你，在此次重阳节护送美女活动中表现出色。获得【晴空玉露礼包】*~w，请查收。">>);
get_talk(?escort_act_type_cyj, 9) -> ?L(<<"重阳节护送美女大礼">>);
get_talk(?escort_act_type_cyj, 10) -> ?L(<<"~s人品爆发，与粉面输生对骰比拼时大胜3点，获得【晴空玉露礼包】*3！{open, 23, 我要采菊, #00ff00}">>);
get_talk(?escort_act_type_cyj, 11) -> ?L(<<"~s人品爆发，与粉面输生对骰比拼时大胜4点，获得【晴空玉露礼包】*4！{open, 23, 我要采菊, #00ff00}">>);
get_talk(?escort_act_type_cyj, 12) -> ?L(<<"~s人品爆发，与粉面输生对骰比拼时大胜5点，获得【晴空玉露礼包】*5以及幸运骰子*5！{open, 23, 我要采菊, #00ff00}">>);
get_talk(?escort_act_type_cyj, 13) -> ?L(<<"恭喜你，在此次重阳节护送美女活动中运气极佳。获得【幸运骰子】* 5，请查收。">>);
get_talk(?escort_act_type_cyj, 14) -> ?L(<<"~s桃花红运，竟得【帝姬】公主亲睐，一同踏上了登高采菊之行。{open, 23, 我要采菊, #00ff00}">>);

%% 圣诞节
get_talk(?escort_act_type_chrismas, 1) -> ?L(<<"你正在护送圣诞老人中，不可以劫别人哦！">>);
get_talk(?escort_act_type_chrismas, 2) -> ?L(<<"你打劫已经达到8次，放过那些可怜的圣诞老人吧！">>);
get_talk(?escort_act_type_chrismas, 3) -> ?L(<<"该护送圣诞老人的英雄已经被劫3次了，放过他吧！">>);
get_talk(?escort_act_type_chrismas, 4) -> ?L(<<"很遗憾，您护送的圣诞老人被<font color=\"#ff0000\">【~s】</font>打劫了，没能成功护送。你仍能获得经验奖励，以及一半金币，但变为绑定金币。">>);
get_talk(?escort_act_type_chrismas, 5) -> ?L(<<"~s不顾~s苦口婆心劝说，强行抢走了圣诞老人">>);
get_talk(?escort_act_type_chrismas, 6) -> ?L(<<"你没有在护送圣诞老人">>);
get_talk(?escort_act_type_chrismas, 7) -> ?L(<<"您竟然丢下圣诞老人在深山，吊丝们向您投来了哀怨的目光。任务失败！">>);
get_talk(?escort_act_type_chrismas, 8) -> ?L(<<"恭喜你，在此次护送圣诞老人活动中表现出色。获得【圣诞糖果】*~w，请查收。">>);
get_talk(?escort_act_type_chrismas, 9) -> ?L(<<"圣诞节护送圣诞老人大礼">>);
get_talk(?escort_act_type_chrismas, 10) -> ?L(<<"~s人品爆发，与小屁孩对骰比拼时大胜3点，获得【圣诞糖果】*3！{open, 23, 我要护送, #00ff00}">>);
get_talk(?escort_act_type_chrismas, 11) -> ?L(<<"~s人品爆发，与小屁孩对骰比拼时大胜4点，获得【圣诞糖果】*4！{open, 23, 我要护送, #00ff00}">>);
get_talk(?escort_act_type_chrismas, 12) -> ?L(<<"~s人品爆发，与小屁孩对骰比拼时大胜5点，获得【圣诞糖果】*5以及【幸运金币】*5！{open, 23, 我要护送, #00ff00}">>);
get_talk(?escort_act_type_chrismas, 13) -> ?L(<<"恭喜你，在此次圣诞节护送圣诞老人活动中运气极佳。获得【幸运金币】* 5，请查收。">>);
get_talk(?escort_act_type_chrismas, 14) -> ?L(<<"~s鸿运当头，竟得携带最大礼物的圣诞老人的青睐。{open, 23, 我要护送, #00ff00}">>);

%% 通用版
get_talk(?escort_act_type_gen, 1) -> ?L(<<"你正在护送中，不可以劫别人哦！">>);
get_talk(?escort_act_type_gen, 2) -> ?L(<<"你打劫已经达到8次，放过那些可怜的人家吧！">>);
get_talk(?escort_act_type_gen, 3) -> ?L(<<"人家的英雄已经被劫3次了，放过他吧！">>);
get_talk(?escort_act_type_gen, 4) -> ?L(<<"很遗憾，您护送的美女被<font color=\"#ff0000\">【~s】</font>打劫了，没能成功护送。你仍能获得经验奖励，以及一半金币，但变为绑定金币。">>);
get_talk(?escort_act_type_gen, 5) -> ?L(<<"~s不顾~s苦口婆心劝说，强行抢走了">>);
get_talk(?escort_act_type_gen, 6) -> ?L(<<"你没有在护送">>);
get_talk(?escort_act_type_gen, 7) -> ?L(<<"您竟然丢下公主殿下在城外，吊丝们向您投来了哀怨的目光。任务失败！">>);
get_talk(?escort_act_type_gen, 8) -> ?L(<<"恭喜你，在此次趣味护送活动中表现出色。获得【趣味护送礼包】*~w，请查收。">>);
get_talk(?escort_act_type_gen, 9) -> ?L(<<"趣味护送大礼">>);
get_talk(?escort_act_type_gen, 10) -> ?L(<<"~s人品爆发，与粉面输生对骰比拼时大胜3点，获得【趣味护送礼包】*3！{open, 23, 我要护送, #00ff00}">>);
get_talk(?escort_act_type_gen, 11) -> ?L(<<"~s人品爆发，与粉面输生对骰比拼时大胜4点，获得【趣味护送礼包】*4！{open, 23, 我要护送, #00ff00}">>);
get_talk(?escort_act_type_gen, 12) -> ?L(<<"~s人品爆发，与粉面输生对骰比拼时大胜5点，获得【趣味护送礼包】*5以及【幸运金币】*5！{open, 23, 我要护送, #00ff00}">>);
get_talk(?escort_act_type_gen, 13) -> ?L(<<"恭喜你，在此次趣味护送活动中运气极佳。获得【幸运金币】* 5，请查收。">>);
get_talk(?escort_act_type_gen, 14) -> ?L(<<"~s桃花运大发，竟得帝姬公主的青睐，将陪同公主开始一段美好的旅程。{open, 23, 我要护送, #00ff00}">>).

%% 根据活动类型返回不同的额外奖品
get_other_award() ->
    get_other_award(escort_cyj_mgr:get_escort_act_type()).
get_other_award(?escort_act_type_cyj) -> {29084, 33116};
get_other_award(?escort_act_type_chrismas) -> {33177, 33118};
get_other_award(?escort_act_type_gen) -> {29498, 33118}.
