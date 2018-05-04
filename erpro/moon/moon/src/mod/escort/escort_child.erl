%%----------------------------------------------------
%% @doc 护送小屁孩
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(escort_child).

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
%% API
%%----------------------------------------------------

%% @spec open_panel(Role::#role{}) -> {ok, NewRole::#role{}, Quality::integer(), Times::integer()} | {false, Reason::binary()}
%% @doc
%% <pre>
%% 打开护送界面
%% </pre>
open_panel(_Role = #role{lev = Lev}) when Lev < 45->
    {false, ?L(<<"只有45级以上才可以做护送任务">>)};
open_panel(Role = #role{escort_child = EscortChild = #escort_child{refresh_time = RefreshTime, quality = Quality}}) ->
    NewQuality = case util:unixtime({today, RefreshTime}) =:= util:unixtime(today) of
        true -> Quality;
        false -> ?escort_quality_white
    end,
    {ok, FinishRc} = role:get_dict(task_finish_rc),
    Times = get_escort_child_num(FinishRc),
    NewRole = Role#role{escort_child = EscortChild#escort_child{quality = NewQuality, refresh_time = RefreshTime}},
    push_preview_award(NewRole),
    {ok, NewRole, NewQuality, Times}.

%% @spec refresh(Role::#role{}, RefreshType::integer()) -> {ok, NewRole::#role{}, Quality::integer()} | {false, Reason::binary()}
%% @doc
%% <pre>
%% 刷小屁孩
%% </pre>
refresh(_Role = #role{lev = Lev}, _RefreshType) when Lev < 45 ->
    {false, ?L(<<"只有45级以上才可以做护送任务">>)};
refresh(Role, RefreshType) ->
    case do_refresh([quality, item], Role, RefreshType) of
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
finish(Role = #role{pid = Pid, lev = Lev, looks = Looks, event = Event, escort_child = EscortChild = #escort_child{quality = Quality, type = EscortType}, buff = #rbuff{buff_list = BuffList}}) ->
    case Event =/= ?event_escort_child of
        true ->
            {false, ?L(<<"你没有护送任务">>)};
        false ->
            %% 删除除运镖buff
            {ok, NewRole} = case lists:keyfind(?escort_child_buff_label, #buff.label, BuffList) of
                false -> {ok, Role};
                #buff{id = BuffId} -> buff:del_by_id(Role, BuffId)
            end,
            NewLooks = lists:keydelete(?LOOKS_TYPE_ACT, 1, Looks),
            case lists:member(Quality, [?escort_quality_purple, ?task_quality_orange]) of
                false -> ignore;
                _ -> 
                    case item:make(?escort_child_award_item, 1, 1) of
                        {ok, [Item]} ->
                            mail:send_system(Role, {?L(<<"护送火炬送大礼">>), ?L(<<"恭喜你，在本次护送火炬手活动中，完成紫色火炬手，橙色火炬手护送。获得【奥运吉祥物】变身卡*1，请查收。">>), [], [Item]});
                        false -> 
                            ?ERR("创建小屁王奖品出错:~w", [?escort_child_award_item])
                    end
            end,
            {Exp, Coin, _Tax} = escort_data:escort_award(Lev),
            MulCoin = escort_data:multiple(coin, Quality),
            MulExp = escort_data:multiple(exp, Quality),
            {NewExp, NewCoin} = {round(Exp * MulExp * 10), round(Coin * MulCoin)},
            {CoinGain, MsgCoin, MsgCoinBind} = case EscortType of
                ?escort_type_coin -> {#gain{label = coin, val = NewCoin}, NewCoin, 0};
                _ -> {#gain{label = coin_bind, val = NewCoin}, 0, NewCoin}
            end,
            ExpGain = #gain{label = exp, val = NewExp},
            NewRole1 = NewRole#role{event = ?event_no, looks = NewLooks, escort_child = EscortChild#escort_child{accept_time = 0, refresh_time = util:unixtime(), quality = ?escort_quality_white}},
            NewRole2 = looks:calc(NewRole1),
            map:role_update(NewRole2),
            case role_gain:do([CoinGain, ExpGain], NewRole2) of
                {ok, NewRole3} ->
                    notice_inform(Pid, [{coin, MsgCoin}, {bind_coin, MsgCoinBind}, {exp, NewExp}]),
                    case MsgCoin > 0 of
                        true -> npc_store_live:apply(async, {coin, MsgCoin});
                        false -> ignore
                    end,
                    {ok, NewRole3};
                {false, Reason} ->
                    {false, Reason}
            end
    end.

%% @spec giveup(Role) -> {ok, NewRole} | {false, Reason}
%% 弃婴
giveup(Role = #role{event = Event, looks = Looks, escort_child = EscortChild, buff = #rbuff{buff_list = BuffList}}) ->
    case Event =/= ?event_escort_child of
        true ->
            {false, ?L(<<"你目前没有护送任务">>)};
        false ->
            %% 删除运镖buff
            {ok, NewRole} = case lists:keyfind(?escort_child_buff_label, #buff.label, BuffList) of
                false ->
                    {ok, Role};
                #buff{id = BuffId} ->
                    buff:del_by_id(Role, BuffId)
            end,
            NewLooks = lists:keydelete(?LOOKS_TYPE_ACT, 1, Looks),
            NewRole1 = NewRole#role{event = ?event_no, looks = NewLooks, escort_child = EscortChild#escort_child{accept_time = 0, refresh_time = util:unixtime(), quality = ?escort_quality_white}},
            NewRole2 = looks:calc(NewRole1),
            map:role_update(NewRole2),
            {ok, NewRole2}
    end.

%% 劫镖检查
check_combat_start(_Attacker = #role{event = ?event_escort_child}, _Defender) -> {false, ?L(<<"你正在护送火炬中，不可以劫别人哦！">>)};
check_combat_start(_Attacker, _Defender = #role{escort_child = #escort_child{type = ?escort_type_bind_coin}}) ->
    {false, ?L(<<"对方选择的是“低调护送”，这么低调，不劫也罢！">>)};
check_combat_start(_Attacker = #role{name = _Name, escort_child = #escort_child{rob = {PDate, PTime}}}, _Defender = #role{escort_child = #escort_child{lose = {LDate, LTime}}}) ->
    Today = today(),
    case PDate =:= Today andalso PTime >= 8 of
        true -> {false, ?L(<<"你打劫已经达到8次，放过那些可怜的火炬手吧！">>)};
        false ->
            case LDate =:= Today andalso LTime >= 3 of
                true -> {false, ?L(<<"该火炬手已经被劫3次了，放过他吧！">>)};
                false -> 
                    ok
            end
    end.

%% 打劫
combat_start(Attacker, Defender) ->
    case {defender_fighter(Attacker), defender_fighter(Defender)} of
        {{ok, APNC}, {ok, DNPC}} ->
            combat:start(?combat_type_rob_escort_child, [APNC | role_api:fighter_group(Attacker)], [DNPC| role_api:fighter_group(Defender)]);
        {{ok, APNC}, {false, _}} ->
            combat:start(?combat_type_rob_escort_child, [APNC | role_api:fighter_group(Attacker)], role_api:fighter_group(Defender));
        {{false, _}, {ok, DNPC}} ->
            combat:start(?combat_type_rob_escort_child, role_api:fighter_group(Attacker), [DNPC| role_api:fighter_group(Defender)]);
        {{false, _}, {false, _Reason}} ->
            ?DEBUG("[劫镖]找不到美女npc:~w", [_Reason]),
            combat:start(?combat_type_rob_escort_child, role_api:fighter_group(Attacker), role_api:fighter_group(Defender))
    end.

%% 劫镖结束
combat_over(#combat{winner = Winner, loser = Loser, type = ?combat_type_rob_escort_child}) ->
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
                    mail:send_system({LRoleId, LSrvId}, {?L(<<"系统邮件">>), util:fbin(?L(<<"很遗憾，您护送的火炬手被<font color=\"#ff0000\">【~s】</font>打劫了，没能成功护送。你仍能获得经验奖励，以及一半金币，但变为绑定金币。">>), [WName]), [], []}),
                    ok;
                false -> ignore
            end,
            W = fighter_to_msg(Winner2),
            L = fighter_to_msg(Loser2),
            notice:send(53, util:fbin(?L(<<"~s不顾~s苦口婆心劝说，强行夺走火炬手手中的火炬，把小屁孩吓得大哭不止。">>), [W, L]));
        false -> ignore
    end;
combat_over(_Combat) ->
    ok.

%% 推送界面奖励显示，默认按照金币奖励
push_preview_award(#role{link = #link{conn_pid = ConnPid}, lev = RoleLev, escort_child = #escort_child{quality = Quality, type = EscortType}}) ->
    {Exp, Coin, BindCoin} = escort:get_escort_award(RoleLev, EscortType, Quality, util:unixtime()),
    sys_conn:pack_send(ConnPid, 13105, {Exp, Coin, BindCoin}).

%% 登录
login(Role = #role{event = ?event_escort_child, task = TaskList, escort_child = #escort_child{quality = Quality, type = EscortType}, looks = Looks, buff = #rbuff{buff_list = BuffList}}) ->
    EscortTask = [Task || Task = #task{type = Type, sec_type = SecType} <- TaskList, Type =:= ?task_type_rc, SecType =:= 22],
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
            {ok, NewRole} = case lists:keyfind(?escort_child_buff_label, #buff.label, BuffList) of
                false ->
                    {ok, Role};
                #buff{id = BuffId} ->
                    buff:del_by_id(Role, BuffId)
            end,
            NewRole#role{event = ?event_no}
    end;
login(Role) ->
    Role.

%% 获取运镖任务剩余次数
get_task_leave(#role{event = ?event_escort_child}) -> {false, ?L(<<"正在护送">>)};
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
get_escort_child_num(undefined) -> 0;
get_escort_child_num(FinishRc) ->
    case [Task || Task = #task_finish{type = ?task_type_rc, sec_type = 22} <- FinishRc] of
        [] -> ?escort_child_total_times;
        [#task_finish{finish_time = FinishTime} | _] ->
            case ?escort_child_total_times > FinishTime of
                true -> ?escort_child_total_times - FinishTime;
                false -> 0
            end;
        _ -> 0
    end.

%% 刷小屁孩
do_refresh([], Role = #role{assets = #assets{gold = Gold}}, RefreshType) ->
    case RefreshType of
        1 -> %% 普通刷镖
            case role_gain:do([#loss{label = item, val = [?escort_child_refresh_item, 0, 1]}], Role) of
                {ok, NewRole} ->
                    gen_quality(NewRole);
                {false, _Any} ->
                    {false, ?L(<<"扣除火炬失败">>)}
            end;
        2 -> %% 晶钻刷镖
            case Gold >= 8 of
                true ->
                    case role_gain:do([#loss{label = gold, val = pay:price(?MODULE, do_refresh, null)}], Role) of
                        {ok, NewRole} ->
                            gen_quality(NewRole);
                        {false, _Any} ->
                            {false, ?L(<<"扣除晶钻失败">>)}
                    end;
                false ->
                    {false, gold_notenough}
            end
    end;
do_refresh([quality | T], Role = #role{escort_child = #escort_child{refresh_time = RefreshTime, quality = Quality}}, RefreshType) ->
    case util:unixtime(today) < RefreshTime andalso Quality =:= ?escort_quality_orange of
        true ->
            {false, ?L(<<"你已经刷到最好的火炬了，不需要再刷了">>)};
        false ->
            do_refresh(T, Role, RefreshType)
    end;
do_refresh([item | T], Role = #role{bag = Bag, assets = #assets{gold = Gold}}, RefreshType) ->
    case RefreshType of
        1 -> %% 普通刷镖
            case storage:find(Bag#bag.items, #item.base_id, ?escort_child_refresh_item) of
                {ok, _Num, _List, _, _} ->
                    do_refresh(T, Role, RefreshType);
                {false, _Reason} ->
                    {false, ?L(<<"你没有奥运火炬">>)}
            end;
        2 -> %% 晶钻刷镖
            case Gold >= 8 of
                true ->
                    do_refresh(T, Role, RefreshType);
                false ->
                    {false, gold_notenough} %% 晶钻不足
            end
    end.

%% 接镖
do_accept([], Role = #role{name = _RoleName, escort_child = EscortChild = #escort_child{quality = Quality}}, EscortType) ->
    NewRoleBuff = case buff:del_buff_by_label(Role, ?escort_child_buff_label) of
        {ok, NewRoleBuff2} ->
            NewRoleBuff2;
        false ->
            Role 
    end,
    case buff:add(NewRoleBuff, ?escort_child_buff_label) of
        {ok, NR = #role{looks = Looks}} ->
            NewRole2 = role_api:push_attr(NR),
            {LooksVal, LooksMod} = quality_to_looks_val(Quality, EscortType),
            NewLooks = case lists:keyfind(?LOOKS_TYPE_ACT, 1, Looks) of
                false ->
                    [{?LOOKS_TYPE_ACT, LooksMod, LooksVal} | Looks];
                _Other ->
                    lists:keyreplace(?LOOKS_TYPE_ACT, 1, Looks, {?LOOKS_TYPE_ACT, LooksMod, LooksVal})
            end,
            NewRole3 = NewRole2#role{event = ?event_escort_child, looks = NewLooks},
            NewRole4 = looks:calc(NewRole3),
            map:role_update(NewRole4),
            {ok, NewRole4#role{escort_child = EscortChild#escort_child{accept_time = util:unixtime(), type = EscortType, lose = {today(), 0}}}};
        {false, Reason} ->
            {false, Reason}
    end;
%% 检查状态
do_accept([status | T], Role = #role{lev = Lev, event = Event, team_pid = TeamPid, status = Status, ride = Ride, mod = {Mod1, _}}, EscortType) ->
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
                            case Mod1 =:= 1 of
                                true -> {false, ?L(<<"和平模式不可以护送">>)};
                                false -> 
                                    case Ride =/= ?ride_no of
                                        true -> {false, ?L(<<"飞行状态不可以护送">>)};
                                        false -> 
                                            case is_pid(TeamPid) of
                                                true -> {false, ?L(<<"组队状态不可以护送!">>)};
                                                false -> do_accept(T, Role, EscortType) 
                                            end
                                    end
                            end
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
            notice:send(53, util:fbin(?L(<<"~s品修兼备，孝悌无双，应小屁孩要求，决定亲自护送火炬手，传递奥运精神。{open, 23, 我要护送, #00ff00}">>), [RoleName])),
            ?escort_quality_orange
    end,
    %% NewRole2 = case Quality =:= ?escort_quality_orange of
    %%     true ->
    %%         case item:make(33079, 1, 1) of
    %%             {ok, [Item]} ->
    %%                 mail:send_system(Role, {?L(<<"护送小孩送大礼">>), ?L(<<"恭喜你，在本次活动中，刷新到橙色品质的小孩。获得父爱黄月季99朵，请查收。">>), [], [Item]});
    %%             false -> 
    %%                 ?ERR("创建小屁王奖品出错:~w", [33055])
    %%         end,
    %%         Role;
    %%     false -> Role
    %% end,
    {ok, Role#role{escort_child = EscortChild#escort_child{refresh_time = util:unixtime(), quality = Quality}}, Quality}.

%% 镖车品质对应的外观效果值
quality_to_looks_val(Quality, EscortType) ->
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
defender_fighter(Role = #role{lev = Lev, event = ?event_escort_child, pos = #pos{map = MapId}, escort_child = #escort_child{quality = Quality}}) ->
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
    {false, ?L(<<"你没有在护送美女">>)}.

defender_fighter_npc(_Lev, ?escort_quality_white)  -> 10093;
defender_fighter_npc(_Lev, ?escort_quality_green)  -> 10094;
defender_fighter_npc(_Lev, ?escort_quality_blue)   -> 10095;
defender_fighter_npc(_Lev, ?escort_quality_purple) -> 10096;
defender_fighter_npc(_Lev, ?escort_quality_orange) -> 10097.

%% 劫镖:处理劫镖失败方
deal_with_loser([#fighter{pid = Pid, type = ?fighter_type_role, is_escape = IsEscape} | T]) ->
    case role:apply(sync, Pid, {escort_child, apply_deal_with_loser, [IsEscape]}) of
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
    case role:apply(sync, Pid, {escort_child, apply_deal_with_winner, []}) of
        {RoleId, SrvId, Name} -> [{RoleId, SrvId, Name, Pid} | deal_with_winner(T)];
        _ -> deal_with_winner(T)
    end;
deal_with_winner([_Fighter | T]) ->
    deal_with_winner(T);
deal_with_winner([]) ->
    [].

%% 劫镖:角色进程处理战败情况
apply_deal_with_loser(Role = #role{pid = Pid, name = _Name, lev = Lev, event = ?event_escort_child, escort_child = EscortChild = #escort_child{quality = Quality, type = Type, lose = {Time, Num}}, link = #link{conn_pid = ConnPid}}, IsEscape) ->
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
                        1 -> sys_conn:pack_send(ConnPid, 10931, {55, ?L(<<"您竟然丢下火炬，吊丝们向您投来了哀怨的目光。任务失败！">>), []});
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
    {NewRole, NewTime, NewNum} = case Event =/= ?event_escort_child of
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
            role:apply(async, RolePid, {escort_child, apply_assign_rob_coin, [Coin]}),
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
        {ok, #task_base{type = Type, sec_type = SecType}} = task_data:get_conf(TaskId),
        case Type =:= ?task_type_rc andalso SecType =:= 22 of
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
escort_finish_total([#task_finish{type = ?task_type_rc, sec_type = 22, finish_num = FinishNum} | T]) ->
    FinishNum + escort_finish_total(T);
escort_finish_total([_TaskFinish | T]) ->
    escort_finish_total(T).

%% 运镖任务
has_escort_task([]) -> false;
has_escort_task([TaskId | T]) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{type = ?task_type_rc, sec_type = 22}} ->
            true;
        _ -> has_escort_task(T)
    end.
