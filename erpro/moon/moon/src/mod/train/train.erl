%% --------------------------------------------------------------------
%% @doc 飞仙历练进程
%% @author weihua@jieyou.cn
%% --------------------------------------------------------------------
-module(train).
-behavior(gen_server).
-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([info/2, call/2]).

-include("common.hrl").
-include("train.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("mail.hrl").
-include("combat.hrl").

%% ----------------------------------------------------------
%% API
%% ----------------------------------------------------------
%% @spec info(Ref, Data) -> ok
%% 向历练管理进程发送一个消息
%% @doc 异步消息
info(Pid, Msg) when is_pid(Pid) ->
    Pid ! Msg,
    ok;
info({Lid, Aid}, Msg) ->
    case ets:lookup(train_pid_id_mapping, {Lid, Aid}) of
        [{_Fid, Pid}] -> Pid ! Msg;
        _ -> ok
    end;
info(_Fid, _Msg) ->
    ?ERR("收到无效的飞仙历练进程消息[~w][~w]", [_Fid, _Msg]),
    ok.

%% @spec call(Msg) -> {error, Reason} | term()
%% Msg = term()
%% @doc 向帮会管理进程发送一个 handle_call 消息
call({Lid, Aid}, Msg) ->
    try gen_server:call({global, {train, Lid, Aid}}, Msg) of
        Reply -> Reply 
    catch
        exit:{timeout, _} -> 
            ?ERR("向飞仙历练第 ~w 段 ~w 区 发起的请求{~w}发生timeout", [Lid, Aid, Msg]),
            {error, timeout};
        exit:{noproc, _} -> 
            ?ERR("向飞仙历练第 ~w 段 ~w 区 发起的请求{~w}发生noproc", [Lid, Aid, Msg]),
            {error, noproc};
        Error:Info ->
            ?ERR("向飞仙历练第 ~w 段 ~w 区 发起的请求{~w}发生异常{~w:~w}", [Lid, Aid, Msg, Error, Info]),
            {error, Error}
    end.

%% --------------------------------------------------------------------------------------
%% 系统服务进程
% ---------------------------------------------------------------------------------------
%% 启动飞仙历练场区进程
start_link(TF = #train_field{id = {Lid, Aid}}) ->
    gen_server:start_link({global, {train, Lid, Aid}}, ?MODULE, [TF], []).

%% 飞仙历练场区进程初始化
init([Field = #train_field{id = {Lid, Aid}, roles = Roles}]) ->
    ?INFO("[飞仙历练 第 ~w 段 ~w 区] 正在启动...", [Lid, Aid]),
    erlang:register(list_to_atom(lists:concat(["train_", Lid, "_", Aid])), self()), 
    Xys = train_common:init_xys(Roles),
    ets:insert(train_pid_id_mapping, {{Lid, Aid}, self()}),    
    erlang:send_after(?check_train_gain * 1000, self(), check_train_gain),
    CVtime = case ?clear_visitor_time - calendar:time_to_seconds(time()) of
        Diff when Diff > 0  -> Diff;
        Diff -> Diff + 86400
    end,
    erlang:send_after(CVtime * 1000, self(), maintain),
    ?INFO("[飞仙历练 第 ~w 段 ~w 区] 启动完成", [Lid, Aid]),
    {ok, Field#train_field{pid = self(), xys = Xys}}.

%%-----------------------------------------------------------
%% 同步请求
%%-----------------------------------------------------------
handle_call({lookup, Fun, Args}, _Fro, State) ->
    try Fun([State | Args]) of
        Reply -> {reply, Reply, State}
    catch
        _E:_I -> {reply, {_E, _I}, State}
    end;

%% 战力发生变化，查看是否应该重新分配历练场
handle_call({check_need_assign, RoleId}, _From, State) ->
    Data = train_server:check_need_assign(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 进行历练
handle_call({sit, TR}, _From, State) ->
    Data = train_server:sit(?MODULE, TR, State),
    handle_outer_call(Data, State);

%% 查询是否可以进行历练(切换场区历练)
handle_call({if_sit_able, RoleId}, _From, State) ->
    Data = train_server:if_sit_able(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 检测是否可以更换段位
handle_call({if_change_grade_able, RoleId}, _From, State) ->
    Data = train_server:if_change_grade_able(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 请求打劫
handle_call({rob, RoleId}, _From, State) ->
    Data = train_server:rob(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 请求缉拿
handle_call({arrest, RoleId}, _From, State) ->
    Data = train_server:arrest(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

handle_call(_Data, _From, State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% 异步请求
%%-----------------------------------------------------------
handle_cast(_Data, State) ->
    ?DEBUG("error handle_cast ~n~w~n~w",[_Data, State]),
    {noreply, State}.

%% 产生机器人
handle_info({robot, Num}, State = #train_field{id = {Lid, Aid}, roles = [Role | Roles], xys = Xys}) ->
    RobotRoles = train_common:gen_robot(Role, Xys, Num),
    NewRoles = [Role | Roles] ++ RobotRoles,
    NewNum = length([ID || #train_role{id = ID, train_time = Time} <- NewRoles, Time > 0]),
    NewState = State#train_field{roles = NewRoles, num = NewNum, xys = []},
    train_mgr_common:update_area_num(?MODULE, Lid, Aid, NewNum),
    {noreply, NewState};

handle_info(rob_role, State = #train_field{roles = [Role | Roles], xys = Xys}) ->
    NewRoles = train_server:rob_roles(Role, Xys),
    NewState = State#train_field{roles = NewRoles ++ [Role | Roles]},
    {noreply, NewState};

%% 玩家离开历练场
handle_info({leave, RoleId}, State) ->
    Data = train_server:leave(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 打劫发起失败
handle_info({rob_failed, RoleId}, State) -> 
    Data = train_server:rob_failed(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 打劫主动方胜利了, 被动方输了
handle_info({i_am_the_won_rob, RobRole}, State) ->
    Data = train_server:i_am_the_won_rob(?MODULE, RobRole, State),
    handle_outer_call(Data, State);

%% 打劫被动方胜利了，主动方输了
handle_info({i_resist_the_rob, RoleId}, State) ->
    Data = train_server:i_resist_the_rob(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 打劫完成
handle_info({rob_complete, RoleId}, State) -> 
    Data = train_server:rob_complete(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 缉拿发起失败
handle_info({arrest_failed, RoleId}, State) -> 
    Data = train_server:arrest_failed(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 缉拿主动方胜利, 被动方失败
handle_info({arrest_success, Aname, ArrestId, RobId}, State) ->
    Data = train_server:arrest_success(?MODULE, Aname, ArrestId, RobId, State),
    handle_outer_call(Data, State);

%% 缉拿主动方失败, 被动方胜利
handle_info({arrest_resisted, _ArrestId, RobId}, State) ->
    Data = train_server:arrest_resisted(?MODULE, _ArrestId, RobId, State),
    handle_outer_call(Data, State);

%% 缉拿完成
handle_info({arrest_complete, RoleId}, State) -> 
    Data = train_server:arrest_complete(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 玩家登陆
handle_info({login, RoleId, Pid}, State) ->
    Data = train_server:login(?MODULE, RoleId, Pid, State),
    handle_outer_call(Data, State);

%% 玩家登出
handle_info({logout, RoleId}, State) ->
    Data = train_server:logout(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 获取角色修炼状态
handle_info({role_status, RoleId, ConnPid}, State) ->
    Data = train_server:role_status(?MODULE, RoleId, ConnPid, State),
    handle_outer_call(Data, State);

%% 获取指定场区历练者信息
handle_info({train_info, ConnPid}, State) ->
    Data = train_server:train_info(?MODULE, ConnPid, State),
    handle_outer_call(Data, State);

%% 获取历练者信息 劫匪
handle_info({rob_info, ConnPid}, State) ->
    Data = train_server:rob_info(?MODULE, ConnPid, State),
    handle_outer_call(Data, State);

%% 清除玩家的历练信息
handle_info({delete_sit_info, RoleId}, State) ->
    Data = train_server:delete_sit_info(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 进入默认历练场
handle_info({enter, RoleId, RolePid}, State) ->
    Data = train_server:enter(?MODULE, RoleId, RolePid, State),
    handle_outer_call(Data, State);

%% 玩家进入指定历练场
handle_info({visit, RoleId, RolePid}, State) ->
    Data = train_server:visit(?MODULE, RoleId, RolePid, State),
    handle_outer_call(Data, State);

%% 打劫
handle_info({rob, Rid, Srvid, Pid}, State) -> 
    Data = train_server:rob(?MODULE, Rid, Srvid, Pid, State),
    handle_outer_call(Data, State);

%% 缉拿
handle_info({arrest, Rid, Srvid, Pid}, State) -> 
    Data = train_server:arrest(?MODULE, Rid, Srvid, Pid, State),
    handle_outer_call(Data, State);

%% 清理异常一直处于被缉拿状态劫匪角色
handle_info({check_rob_dead_status, RobId}, State) ->
    Data = train_server:check_rob_dead_status(?MODULE, RobId, State),
    handle_outer_call(Data, State);

%% 清理异常一直处于打劫(缉拿)状态角色
handle_info({check_robbing_dead_status, RoleId}, State) ->
    Data = train_server:check_robbing_dead_status(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 清理异常一直处于被打劫状态状态历练者
handle_info({check_be_rob_dead_status, RoleId}, State) ->
    Data = train_server:check_be_rob_dead_status(?MODULE, RoleId, State),
    handle_outer_call(Data, State);

%% 结算奖励
handle_info(check_train_gain, State) ->
    erlang:send_after(?check_train_gain * 1000, self(), check_train_gain),
    Data = train_server:check_train_gain(?MODULE, State),
    handle_outer_call(Data, State);

%% 打劫交付, 系统
handle_info({rob_sale, RoleId, CheckTime}, State) ->
    Data = train_server:rob_sale(?MODULE, RoleId, CheckTime, State),
    handle_outer_call(Data, State);

%% 角色重新分配场区
handle_info({role_settle, TR}, State) ->
    Data = train_server:role_settle(?MODULE, TR, State),
    handle_outer_call(Data, State);

%% 广播场区状态
handle_info({uplas, {Lid, Aid, Num}}, State) ->
    Data = train_server:uplas(?MODULE, Lid, Aid, Num, State),
    handle_outer_call(Data, State);

%% 清理围观者
handle_info(maintain, State) ->
    erlang:send_after(86400 * 1000, self(), maintain),
    Data = train_server:maintain(?MODULE, State),
    handle_outer_call(Data, State);

handle_info(_Data, State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% 系统关闭
%%-----------------------------------------------------------
terminate(_Reason, _State) ->
    {noreply, _State}.

%%-----------------------------------------------------------
%% 热代码切换
%%-----------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ---------------------------------------------------------
%% 私有函数
%% ---------------------------------------------------------
handle_outer_call({ok}, State) ->
    {noreply, State};
handle_outer_call({ok, NewState}, _State) ->
    {noreply, NewState};
handle_outer_call({reply, Reply}, State) ->
    {reply, Reply, State};
handle_outer_call({reply, Reply, NewState}, _State) ->
    {reply, Reply, NewState};
handle_outer_call(_Data, State) ->
    ?ERR("飞仙历练进程返回错误的格式"),
    {noreply, State}.
