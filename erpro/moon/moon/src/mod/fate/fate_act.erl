%%----------------------------------------------------
%% 缘分互动（猜拳/摇骰子）
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-module(fate_act).
-behaviour(gen_fsm).
-export(
    [
        start/4
        ,logout/1
        ,select_val/3
        ,act_over/1
        ,reward/1
        ,async_reward/4
        ,get_free_num/1
        ,act_call_for/3
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([select/2, play/2]).
-record(state, {
         from_pid               %% 发起方的角色进程ID
        ,from_rid               %% 发起方的角色ID
        ,from_srv_id            %% 发起方的服务器标识
        ,from_name              %% 发起方的服务器标识
        ,from_reward = false    %% 发起方播报完可发奖励
        ,from_val = 0           %% 发起方值
        ,to_pid                 %% 接受方的角色进程ID
        ,to_rid                 %% 接受方的角色ID
        ,to_srv_id              %% 接受方的服务器标识
        ,to_name                %% 接受方的名称
        ,to_reward = false      %% 接受方播报完可发奖励
        ,to_val = 0             %% 接受方值
        ,type = 0               %% 类型
        ,ts = 0      
        ,timeout_val = 0
    }
).

-include("common.hrl").
-include("role.hrl").
-include("fate.hrl").
-include("link.hrl").
-include("gain.hrl").

-define(fate_act_select_time_out, 11). %% 选择超时时间
-define(fate_act_play_time_out, 5).   %% 播报超时时间

%% 邀请对方互动
%% 异步邀请对方互动
act_call_for(_Role = #role{pid = Pid}, {FromRid, FromSrvid, FromName}, Type = ?fate_type_finger_guess) ->
    FromRoleMsg = notice:role_to_msg({FromRid, FromSrvid, FromName}),
    ChatMsg = util:fbin(?L(<<"~s向您发出了猜拳请求，一起玩么？{handle, 48, 同意, FFFF66, ~p, 1, ~p, ~s}，{handle, 48, 拒绝, FFFF66, ~p, 2, ~p, ~s}">>), [FromRoleMsg, Type, FromRid, FromSrvid, Type, FromRid, FromSrvid]),
    role:pack_send(Pid, 17712, {FromRid, FromSrvid, <<>>, 0, 0, 0, [], ChatMsg}),
    put({fate_act_call_for, FromRid, FromSrvid}, {Type, util:unixtime()}),
    {ok};
act_call_for(_Role = #role{pid = Pid}, {FromRid, FromSrvid, FromName}, Type = ?fate_type_dice) ->
    FromRoleMsg = notice:role_to_msg({FromRid, FromSrvid, FromName}),
    ChatMsg = util:fbin(?L(<<"~s向您发出了抛骰子请求，一起玩么？{handle, 48, 同意, FFFF66, ~p, 1, ~p, ~s}，{handle, 48, 拒绝, FFFF66, ~p, 2, ~p, ~s}">>), [FromRoleMsg, Type, FromRid, FromSrvid, Type, FromRid, FromSrvid]),
    role:pack_send(Pid, 17712, {FromRid, FromSrvid, <<>>, 0, 0, 0, [], ChatMsg}),
    put({fate_act_call_for, FromRid, FromSrvid}, {Type, util:unixtime()}),
    {ok};
act_call_for(_Role, _From, _Type) ->
    {ok}.

%% 下线
logout(_Role) ->
    ok.

%% 客户端通知可以发放奖励
reward(#role{id = RoleId, fate_pid = FatePid}) when is_pid(FatePid) ->
    FatePid ! {reward, RoleId};
reward(_Role) ->
    ok.

%% 选择值
select_val(#role{id = RoleId, pid = Pid, fate_pid = FatePid}, Type, Val) when is_pid(FatePid) ->
    case check_val(Type, Val) of
        {false, Reason} ->
            {false, Reason};
        {ok, NewVal} ->
            FatePid ! {select_val, RoleId, Pid, Type, NewVal}
    end;
select_val(_Role, _Type, _Val) ->
    {false, ?L(<<"您当前不在互动中">>)}.
check_val(?fate_type_dice, _Val) ->
    {ok, util:rand(1, 6)};
check_val(?fate_type_finger_guess, Val) when Val >= 1 andalso Val =< 3 ->
    {ok, Val};
check_val(_Type, _Val) ->
    {false, ?L(<<"无效选择">>)}.

%% 尝试开启互动进程
start({ToPid, ToRid, ToSrvId, ToName}, {FromPid, FromRid, FromSrvId, FromName}, Type, true)->
    %% ?DEBUG("1==================================~w", [node()]),
    gen_fsm:start_link(?MODULE, [{ToPid, ToRid, ToSrvId, ToName}, {FromPid, FromRid, FromSrvId, FromName}, Type], []);
start({ToPid, ToRid, ToSrvId, ToName}, {FromPid, FromRid, FromSrvId, FromName}, Type, false)->
    %% ?DEBUG("2==================================~w", [node()]),
    center:call(fate_act, start, [{ToPid, ToRid, ToSrvId, ToName}, {FromPid, FromRid, FromSrvId, FromName}, Type, true]).

init([{ToPid, ToRid, ToSrvId, ToName}, {FromPid, FromRid, FromSrvId, FromName}, Type])->
    case role:apply(sync, FromPid, {fun set_act_status/4, [self(), {ToRid, ToSrvId}, Type]}) of
        true ->
            State = #state{
                from_pid = FromPid, from_rid = FromRid, from_srv_id = FromSrvId, from_name = FromName
                ,to_pid = ToPid, to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName, type = Type
                ,ts = util:unixtime(), timeout_val = ?fate_act_select_time_out
            },
            open_client_panel(State),
            ?DEBUG("互动开始 ~s VS ~s", [ToName, FromName]),
            {ok, select, State, ?fate_act_select_time_out * 1000};
        _ ->
            {stop, failure}
    end.

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    continue(StateName, ok, State).

%% 对方未选择就下线停止
handle_info({logout_stop, {Rid, Srvid}}, _StateName, State = #state{from_rid = Rid, from_srv_id = Srvid, from_val = 0, to_pid = ToPid, type = Type}) ->  
    role:pack_send(ToPid, 17718, {Type, 0, 0, 0, ?L(<<"对方掉线，不能继续了哦">>)}),
    {stop, normal, State};
handle_info({logout_stop, {Rid, Srvid}}, _StateName, State = #state{to_rid = Rid, to_srv_id = Srvid, to_val = 0, from_pid = FromPid, type = Type}) ->  
    role:pack_send(FromPid, 17718, {Type, 0, 0, 0, ?L(<<"对方掉线，不能继续了哦">>)}),
    {stop, normal, State};

%% 选择
handle_info({select_val, RoleId, RolePid, Type, Val}, StateName = select, State = #state{type = Type}) ->
    case set_select_val(State, RoleId, Val) of
        {false, Reason} -> 
            role:pack_send(RolePid, 17717, {0, Reason}),
            continue(StateName, State);
        {ok, NewState = #state{from_val = FromVal, to_val = ToVal}} when FromVal > 0 andalso ToVal > 0 -> %% 双方都已选择
            refresh_client(NewState),
            continue(play, NewState#state{ts = util:unixtime(), timeout_val = ?fate_act_play_time_out});
        {ok, NewState} ->
            refresh_client(NewState),
            continue(StateName, NewState)
    end;

%% 播报完成 可以发奖励
handle_info({reward, {Rid, Srvid}}, StateName, State) ->
    NewState = case State of
        #state{from_rid = Rid, from_srv_id = Srvid} -> State#state{from_reward = true};
        _ -> State#state{to_reward = true}
    end,
    case NewState of
        #state{from_reward = true, to_reward = true} -> %% 双方都播报完成 开始发奖励
            do_reward(NewState),
            {stop, normal, NewState};
        _ ->
            continue(StateName, NewState)
    end;

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(_Reason, _StateName, _State = #state{from_pid = FromPid, to_pid = ToPid}) ->
    role:apply(async, FromPid, {fate_act, act_over, []}),
    role:apply(async, ToPid, {fate_act, act_over, []}),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% 选择状态超时
select(timeout, State) ->
    %% 时间到 系统自动选择
    ?DEBUG("选择超时，未选择玩家自动选择"),
    NewState = select_auto(State),
    refresh_client(NewState),
    continue(play, NewState#state{ts = util:unixtime(), timeout_val = ?fate_act_play_time_out});
select(_Event, State) ->
    continue(select, State).

%% 播报状态超时
play(timeout, State) ->
    %% 时间到 系统自动选择
    ?DEBUG("播报超时未通知发奖励"),
    do_reward(State),
    {stop, normal, State};
play(_Event, State) ->
    continue(play, State).

%%---------------------------------------------------
%% 内部函数
%%---------------------------------------------------

%% 继续下一个状态
continue(StateName, State) ->
    {next_state, StateName, State, time_left(State)}.

continue(StateName, Reply, State) ->
    {reply, Reply, StateName, State, time_left(State)}.

%% 重新计算剩余时间
time_left(#state{ts = Ts, timeout_val = TimeVal}) ->
    time_left(TimeVal, Ts).
time_left(TimeVal, Ts) ->
    EndTime = Ts + TimeVal,
    Now = util:unixtime(),
    case EndTime - Now of
        T when T > 0 -> T * 1000;
        _ -> 100
    end.

%% 更新对方状态
set_act_status(#role{status = ?status_fight}, _Pid, _OtherRoleId, _Type) ->
    {ok, false};  %% 战斗中不能
set_act_status(#role{fate_pid = FatePid}, _Pid, _OtherRoleId, _Type) when is_pid(FatePid) ->
    {ok, false}; %% 当前正在互动中
set_act_status(Role, Pid, {OtherRid, OtherSrvid}, Type) ->
    {Max, N, _Roles} = fate:get_log_info(Role, fate_act),
    case Max > N of 
        true -> %% 还有免费次数
            NewRole = fate:update_log_info(Role, fate_act, {OtherRid, OtherSrvid}),
            role:pack_send(Role#role.pid, 17720, get_free_num(NewRole)),
            {ok, true, NewRole#role{fate_pid = Pid}};
        false ->
            GL = [#loss{label = gold, val = pay:price(?MODULE, set_act_status, null)}],
            case role_gain:do(GL, Role) of
                {false, _} ->
                    role:pack_send(Role#role.pid, 17714, {?gold_less, ?L(<<"晶钻不足">>)}),
                    {ok, false};
                {ok, NRole} ->
                    log:log_gold(17714, {OtherRid, OtherSrvid, Type}, Role, NRole),
                    notice:inform(Role#role.pid, notice_inform:gain_loss(GL, ?L(<<"发起互动">>))),
                    {ok, true, NRole#role{fate_pid = Pid}}
            end
    end.

%% 获取免费次数
get_free_num(Role) ->
    {Max, N, _} = fate:get_log_info(Role, fate_act),
    Val = case Max > N of
        true -> Max - N;
        _ -> 0
    end,
    {Val, Val}.

%% 超时未选择 未选择玩家系统自动选择
select_auto(State = #state{from_val = 0, type = ?fate_type_finger_guess}) ->
    select_auto(State#state{from_val = util:rand(1, 3)});
select_auto(State = #state{from_val = 0, type = ?fate_type_dice}) ->
    select_auto(State#state{from_val = util:rand(1, 6)});
select_auto(State = #state{to_val = 0, type = ?fate_type_finger_guess}) ->
    select_auto(State#state{to_val = util:rand(1, 3)});
select_auto(State = #state{to_val = 0, type = ?fate_type_dice}) ->
    select_auto(State#state{to_val = util:rand(1, 6)});
select_auto(State) ->
    State.

%% 设置选择值
set_select_val(State = #state{from_rid = FromRid, from_srv_id = FromSrvId, from_val = 0}, {FromRid, FromSrvId}, Val) ->
    {ok, State#state{from_val = Val}};
set_select_val(State = #state{to_rid = ToRid, to_srv_id = ToSrvId, to_val = 0}, {ToRid, ToSrvId}, Val) ->
    {ok, State#state{to_val = Val}};
set_select_val(_State, _RoleId, _Val) ->
    {false, ?L(<<"不能重复选择的哦">>)}.

%% 判断胜利方
check_win(#state{from_val = 0}) -> {0, 0};
check_win(#state{to_val = 0}) -> {0, 0};
check_win(#state{from_val = Val, to_val = Val}) -> {0, 0};
check_win(#state{from_val = 1, to_val = 3, type = ?fate_type_finger_guess}) -> {1, 2};
check_win(#state{from_val = 3, to_val = 1, type = ?fate_type_finger_guess}) -> {2, 1};
check_win(#state{from_val = FromVal, to_val = ToVal}) when FromVal > ToVal -> {1, 2};
check_win(_State) -> {2, 1}.

%% 通知客户端打开相关面板
open_client_panel(#state{from_pid = FromPid, from_rid = FromRid, from_srv_id = FromSrvId
        ,to_pid = ToPid, to_rid = ToRid, to_srv_id = ToSrvId, type = Type}) ->
    role:pack_send(FromPid, 17716, {ToRid, ToSrvId, Type, ?fate_act_select_time_out - 1, 1, ?L(<<"互动开始">>)}),
    role:pack_send(ToPid, 17716, {FromRid, FromSrvId, Type, ?fate_act_select_time_out - 1, 1, ?L(<<"互动开始">>)}),
    ok.

%% 更新客户端
refresh_client(State = #state{from_pid = FromPid, from_val = FromVal
        ,to_pid = ToPid, to_val = ToVal, type = Type}) ->
    {FromWin, ToWin} = check_win(State),
    role:pack_send(FromPid, 17718, {Type, FromVal, ToVal, FromWin, <<>>}),
    role:pack_send(ToPid, 17718, {Type, ToVal, FromVal, ToWin, <<>>}),
    %% ?DEBUG("~p, ~p, ~p, ~p, ~p", [Type, FromVal, ToVal, FromWin, ToWin]),
    ok.

%% 奖励发放
do_reward(State = #state{from_pid = FromPid, from_rid = FromRid, from_srv_id = FromSrvId, from_name = FromName
        ,to_pid = ToPid, to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName, type = Type}) ->
    {FromWin, ToWin} = check_win(State),
    role:apply(async, FromPid, {fate_act, async_reward, [Type, FromWin, {ToRid, ToSrvId, ToName}]}),
    role:apply(async, ToPid, {fate_act, async_reward, [Type, ToWin, {FromRid, FromSrvId, FromName}]}).

%% 奖励发放
async_reward(Role = #role{pid = Pid}, Type, WinFlag, {OtherRid, OtherSrvid, OtherName}) ->
    MyRoleMsg = notice:role_to_msg(Role),
    OtherRoleMsg = notice:role_to_msg({OtherRid, OtherSrvid, OtherName}),
    case {Type, WinFlag} of
        {?fate_type_finger_guess, 1} -> %% 自己是胜利者
            ChatMsg = util:fbin(?L(<<"本次猜拳中~s轻松战胜~s, 个人魅力值增加{str,5,#fcff02}点">>), [MyRoleMsg, OtherRoleMsg]),
            role:pack_send(Pid, 17712, {OtherRid, OtherSrvid, <<>>, 0, 0, 0, [], ChatMsg});
        {?fate_type_finger_guess, 2} -> %% 对方是胜利者
            ChatMsg = util:fbin(?L(<<"本次猜拳中~s轻松战胜~s, 个人魅力值增加{str,5,#fcff02}点">>), [OtherRoleMsg, MyRoleMsg]),
            role:pack_send(Pid, 17712, {OtherRid, OtherSrvid, <<>>, 0, 0, 0, [], ChatMsg});
        {?fate_type_dice, 1} -> %% 自己是胜利者
            ChatMsg = util:fbin(?L(<<"本次抛骰子中~s轻松战胜~s, 个人魅力值增加{str,5,#fcff02}点">>), [MyRoleMsg, OtherRoleMsg]),
            role:pack_send(Pid, 17712, {OtherRid, OtherSrvid, <<>>, 0, 0, 0, [], ChatMsg});
        {?fate_type_dice, 2} -> %% 对方是胜利者
            ChatMsg = util:fbin(?L(<<"本次抛骰子中~s轻松战胜~s, 个人魅力值增加{str,5,#fcff02}点">>), [OtherRoleMsg, MyRoleMsg]),
            role:pack_send(Pid, 17712, {OtherRid, OtherSrvid, <<>>, 0, 0, 0, [], ChatMsg});
        _ ->
            ok
    end,
    case gain_data(Type, WinFlag) of
        {[], Msg} ->
            role:pack_send(Pid, 17719, {1, Msg}),
            {ok};
        {Gains, Msg} ->
            case role_gain:do(Gains, Role) of
                {false, _} -> 
                    {ok};
                {ok, NRole} ->
                    notice:inform(Pid, notice_inform:gain_loss(Gains, ?L(<<"缘分互动">>))),
                    role:pack_send(Pid, 17719, {1, Msg}),
                    {ok, NRole}
            end
    end.

%% 获取奖励数据
gain_data(?fate_type_finger_guess, 0) -> {[], ?L(<<"打成平局">>)};
gain_data(?fate_type_dice, 0) -> {[], ?L(<<"打成平局">>)};
gain_data(?fate_type_finger_guess, 1) -> {[#gain{label = charm, val = 5}], ?L(<<"恭喜您，胜利了">>)};
gain_data(?fate_type_dice, 1) -> {[#gain{label = charm, val = 5}], ?L(<<"恭喜您，胜利了">>)};
gain_data(?fate_type_finger_guess, 2) -> {[], ?L(<<"很遗憾，你输了">>)};
gain_data(?fate_type_dice, 2) -> {[], ?L(<<"很遗憾，您输了">>)};
gain_data(_Type, _Win) -> {[], <<>>}.

%% 互动结束
act_over(Role) ->
    ?DEBUG("互动结束了:~s", [Role#role.name]),
    {ok, Role#role{fate_pid = 0}}.
