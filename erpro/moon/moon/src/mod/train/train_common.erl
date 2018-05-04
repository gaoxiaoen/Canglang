%% --------------------------------------------------------------------
%% @doc 飞仙历练 (本服/跨服) 通用模块
%% @author weihua@jieyou.cn
%% --------------------------------------------------------------------
-module(train_common).
-export([info/2
        ,info/3
        ,login/1
        ,logout/1
        ,times/1
        ,async_reset/1
        ,reset/1
        ,able_times/1
        ,status/1
        ,leave/2
        ,train_info/2
        ,rob_info/2
        ,update_role_train/3
        ,to_train_role/1
        ,to_rob_role/2
        ,rob_clone_role/1
        ,arrest_clone_role/1
        ,condition/1
        ,pos/0
        ,init_xys/1
        ,train_gain/3
        ,count_new_pos/4
        ,rob_gain/3
        ,arrest_success_mail/4
        ,rob_success_mail/4
        ,notice/2
        ,rob_roles/2
        ,enter_specify/2
        ,enter_default/2
        ,assign_enter/3
        ,async_assign/2
        ,info_tp/2
        ,info_ctp/2
        ,sit/4
        ,rob/5
        ,async_rob/2
        ,rob_win/2
        ,rob_lose/1
        ,arrest/5
        ,async_arrest/2
        ,arrest_win/1
        ,arrest_lose/1
        ,combat_over/2
        ,is_full/1
        ,count_train_time/3
        ,distance/2
        ,rob_hearsay/4
        ,refresh_area_status/5
        ,lookup/5
        ,gen_train_process_name/2
        ,robot/4
        ,gen_robot/3
    ]).

-include("common.hrl").
-include("train.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("mail.hrl").
-include("combat.hrl").

-define(train_tag_to_mod(Center), case Center of ?true -> train_center; ?false -> train end).

%% ----------------------------------------------------------
%% API
%% ----------------------------------------------------------
%% @spec info(Role, Msg) -> ok
%% Role = #role{}
%% Msg = term()
%% @doc 转发信息
info(#role{train = #role_train{center = ?true, id = Fid}}, Msg) ->
    info_ctp(Fid, Msg);
info(#role{train = #role_train{center = ?false, id = Fid}}, Msg) ->
    info_tp(Fid, Msg);
info(_Role, _Msg) ->
    ok.

%% @spec info(Mod, Fid, Msg) -> ok
%% Mod :: train|train_center
%% Fid = {intege(), integer()}
%% @doc 转发信息
info(train, Fid, Msg) ->
    info_tp(Fid, Msg);
info(train_center, Fid, Msg) ->
    info_ctp(Fid, Msg);
info(?true, Fid, Msg) ->
    info_ctp(Fid, Msg);
info(?false, Fid, Msg) ->
    info_tp(Fid, Msg);
info(_Mod, _Fid, _Msg) ->
    ok.

%% @spec info_tp(Fid, Msg) -> ok
%% Fid = {integer(), integer()} | pid()
%% Msg = term()
%% @doc 向本地服飞仙历练发信息
info_tp(Fid, Msg) ->
    train:info(Fid, Msg).

%% @spec info_ctp(Fid, Msg) -> ok
%% Fid = {integer(), integer()}
%% Msg = term()
%% @doc 向中央服飞仙历练发信息
info_ctp(Fid, Msg) ->
    train_center:info(Fid, Msg).

%% @spec lookup(Type, Fid, Aid, Fun, Args) ->
%% Type = local || center
%% Fid = Aid = integer()
%% Fun = fun()
%% Args = list()
%% @doc 查找数据
lookup(Type, Fid, Aid, Fun, Args) ->
    Mod = case Type of
        local -> train;
        center -> train_center
    end,
    Mod:call({Fid, Aid}, {lookup, Fun, Args}).

%% @spec login(Role) -> NewRole;
%% @doc 角色登陆
login(Role = #role{train = Train = #role_train{stamp = 0}}) ->
    login(Role#role{train = Train#role_train{stamp = util:unixtime()}});    %% 初始化的，避免当天无限重置
login(Role = #role{id = RoleId, pid = Pid, train = Train = #role_train{stamp = Stamp}}) ->
    info(Role, {login, RoleId, Pid}),
    Now = util:unixtime(),
    Today = util:unixtime({today, Now}) + ?clear_time,  %% 当天将要重置时间
    Last = Today - 86400, %% 上一天重置时间
    Next = Today + 86400, %% 下一天重置时间
    case Now < Today of
        true -> %% 当天重置时间还没有过
            R1 = role_timer:set_timer(train_reset, (Today - Now) * 1000, {?MODULE, async_reset, []}, 1, Role),
            case Stamp > Last of
                true -> %% 上一次角色重置时间大于上一天计划重置时间， 针对上一天历练，角色已经重置过了
                    R1;
                false -> %% 上一次角色重置时间小于上一天计划重置时间，针对上一天历练， 角色还没有重置
                    R1#role{train = Train#role_train{train = ?train_role_times, rob = ?train_role_rob, arrest = ?train_role_arrest, stamp = Now}}
            end;
        false -> %% 当前重置时间已经过了
            R1 = role_timer:set_timer(train_reset, (Next - Now) * 1000, {?MODULE, async_reset, []}, 1, Role),
            case Stamp > Today of
                true -> %% 上一次角色重置时间大于当天计划重置时间，针对当天历练，角色已经重置过了
                    R1;
                false -> %% 上一次角色重置时间小于当天计划重置时间，针对当天历练，角色还没有重置
                    R1#role{train = Train#role_train{train = ?train_role_times, rob = ?train_role_rob, arrest = ?train_role_arrest, stamp = Now}}
            end
    end;
login(Role) ->
    Role#role{train = #role_train{}}.

%% @spec logout(Role) -> ok
%% @doc 角色下线
logout(Role = #role{id = RoleId, train = #role_train{}}) ->
    info(Role, {logout, RoleId});
logout(_) -> ok.

%% @spec times(Role) -> integer()
%% @doc 查询飞仙历练次数
times(#role{train = #role_train{train = T, rob = R, arrest = A}}) -> T+R+A;
times(_) -> 0.

%% @spec async_reset() -> {ok, NewRole}
%% @doc 重置角色历练次数
async_reset(Role = #role{train = Train}) ->
    Role1 = role_timer:set_timer(train_reset, 86400 * 1000, {?MODULE, async_reset, []}, 1, Role),
    NewRole = Role1#role{train = Train#role_train{train = ?train_role_times, rob = ?train_role_rob, arrest = ?train_role_arrest, stamp = util:unixtime() + 6}},
    refresh_all_times(NewRole),
    {ok, NewRole}.

%% @spec reset() -> {ok, NewRole}
%% @doc 重置角色历练次数
reset(Role = #role{train = Train}) ->
    NewRole = Role#role{train = Train#role_train{train = ?train_role_times, rob = ?train_role_rob, arrest = ?train_role_arrest, stamp = util:unixtime() + 6}},
    refresh_all_times(NewRole),
    {ok, NewRole}.

%% @spec able_times(Role) -> {ok, Reply} | ok
%% Role = #role{}
%% @doc 获取可行的场区各种次数
able_times(#role{train = #role_train{train = Train, rob = Rob, arrest = Arrest, fight = Fc}}) ->
    {Train, Rob, Arrest, Fc}.

%% @spec status(Role) -> {ok, Reply} | ok
%% Role = #role{}
%% @doc 修炼状态
status(#role{train = #role_train{id = {0, 0}}}) ->
    {ok, {0, 0, 0, 0}};
status(Role = #role{id = RoleId, link = #link{conn_pid = ConnPid}}) ->
    info(Role, {role_status, RoleId, ConnPid}).

%% @spec leave(Role) -> ok
%% Role = #role{}
%% @doc 离开指定场区
leave(#role{id = RoleId, train = #role_train{center = ?true}}, Fid) ->
    info_ctp(Fid, {leave, RoleId});
leave(#role{id = RoleId, train = #role_train{center = ?false}}, Fid) ->
    info_tp(Fid, {leave, RoleId});
leave(_Role, _Fid) -> ok.

%% @spec enter(Role) -> ok | {false, Reason}
%% Role = #role{}
%% @doc 第一次进入自己的历练场 默认
enter_default(Type, Role = #role{id = RoleId, pid = RolePid, train = #role_train{id = {Lid, Aid}}, attr = #attr{fight_capacity = FC}}) when Lid =/= 0 andalso Aid =/= 0 ->
    case condition(Role) of
        true ->
            case is_laid_exist(Type, {Lid, Aid}) of
                false -> train_mgr_common:assign(Type, Role);
                true ->
                    case Lid =:= train_mgr_common:assign_lid(FC) of
                        true when Type =:= center -> info_ctp({Lid, Aid}, {enter, RoleId, RolePid});
                        true -> info_tp({Lid, Aid}, {enter, RoleId, RolePid});
                        false when Type =:= center ->
                            case train_center:call({Lid, Aid}, {check_need_assign, RoleId}) of
                                {ok, grade} -> train_mgr_common:assign(Type, Role, change_grade);    %% 战斗力变化，重新分配
                                {ok, pass} -> info_ctp({Lid, Aid}, {enter, RoleId, RolePid}); %% 给予进入
                                _ -> {false, ?L(<<"请稍后再试">>)}
                            end;
                        false ->
                            case train:call({Lid, Aid}, {check_need_assign, RoleId}) of
                                {ok, grade} -> train_mgr_common:assign(Type, Role, change_grade);    %% 战斗力变化，重新分配
                                {ok, pass} -> info_tp({Lid, Aid}, {enter, RoleId, RolePid}); %% 给予进入
                                _ -> {false, ?L(<<"请稍后再试">>)}
                            end
                    end
            end;
        {false, Reason} ->
            {false, Reason}
    end;
enter_default(Type, Role) ->
    case condition(Role) of
        true -> train_mgr_common:assign(Type, Role);
        {false, Reason} -> {false, Reason}
    end.

%% @spec enter(Role, Fid) -> ok | {false, Reason}
%% Role = #role{}
%% Fid = {integer(), integer()}
%% @doc 进入指定历练场
enter_specify(Role = #role{id = RoleId, pid = RolePid, train = #role_train{center = Center}}, Fid) ->
    case condition(Role) of
        true when Center =:= ?true -> info_ctp(Fid, {visit, RoleId, RolePid});
        true -> info_tp(Fid, {visit, RoleId, RolePid});
        {false, Reason} -> {false, Reason}
    end.

%% @spec assign_enter(Role, Fid) -> {ok}
%% Role = #role{}
%% Fid = {integer(), integer}
%% @doc 第一次默认分配后 管理进程异步调用进入分配的历练场
assign_enter(#role{link = #link{conn_pid = ConnPid}, cross_srv_id = CSI}, _, train_mgr) when CSI =/= <<>> ->
    sys_conn:pack_send(ConnPid, 18901, {0, 0, <<>>, []}),
    {ok};
assign_enter(Role = #role{id = RoleId, link = #link{conn_pid = ConnPid}, train = #role_train{id = OldFid}}, {change_grade, Fid}, CenterMod) ->
    case condition(Role) of
        true ->
            Mod = case CenterMod of
                train_mgr_center -> train_center;
                _ -> train
            end,
            case Mod:call(OldFid, {if_change_grade_able, RoleId}) of
                true ->
                    TrainRole = to_train_role(Role),
                    case CenterMod of
                        train_mgr_center ->
                            info_ctp(Fid, {role_settle, TrainRole}),
                            info_ctp(OldFid, {delete_sit_info, RoleId});
                        _ ->
                            info_tp(Fid, {role_settle, TrainRole}),
                            info_tp(OldFid, {delete_sit_info, RoleId})
                    end,
                    {ok};
                _ ->
                    sys_conn:pack_send(ConnPid, 18901, {0, 0, ?L(<<"请稍候再试!">>), []}),
                    {ok}
            end;
        {false, Reason} ->
            sys_conn:pack_send(ConnPid, 18901, {0, 0, Reason, []}),
            {ok}
    end;

%% @spec assign_enter(Role, Fid) -> {ok}
%% Role = #role{}
%% Fid = {integer(), integer}
%% @doc 第一次默认分配后 管理进程异步调用进入分配的历练场
assign_enter(Role = #role{link = #link{conn_pid = ConnPid}}, Fid, CenterMod) ->
    case condition(Role) of
        true ->
            TrainRole = to_train_role(Role),
            case CenterMod of
                train_mgr_center -> info_ctp(Fid, {role_settle, TrainRole});
                _ -> info_tp(Fid, {role_settle, TrainRole})
            end,
            {ok};
        {false, Reason} ->
            sys_conn:pack_send(ConnPid, 18901, {0, 0, Reason, []}),
            {ok}
    end.

%% @spec async_assign(Role) -> {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 玩家身上飞仙历练数据过期，需要重新分配场区
async_assign(Role = #role{train = Train}, TrainMod) ->
    NRole = Role#role{train = Train#role_train{id = {0, 0}}},
    case TrainMod of
        train_center -> train_mgr_common:assign(center, NRole);
        train -> train_mgr_common:assign(local, NRole)
    end,
    {ok, NRole}.

%% @spec is_laid_exist({integer(), integer()}) -> boolean()
%% @doc 查看场区是否存在
is_laid_exist(center, Fid) ->
    case center:call(ets,lookup,[train_pid_id_mapping, Fid]) of
        [{_Fid, _Pid}] -> true;
        _ -> false
    end;
is_laid_exist(_, Fid) ->
    case ets:lookup(train_pid_id_mapping, Fid) of
        [{_Fid, _Pid}] -> true;
        _ -> false
    end.

%% @spec train_info(Role) -> ok
%% Role = #role{}
%% @doc 获取指定场区修炼者信息
train_info(#role{link = #link{conn_pid = ConnPid}, train = #role_train{center = ?true}}, Fid) ->
    info_ctp(Fid, {train_info, ConnPid});
train_info(#role{link = #link{conn_pid = ConnPid}, train = #role_train{center = ?false}}, Fid) ->
    info_tp(Fid, {train_info, ConnPid});
train_info(_Role, _Fid) -> ok.

%% @spec rob_info(Role) -> ok
%% Role = #role{}
%% @doc 获取指定场区劫匪信息
rob_info(#role{link = #link{conn_pid = ConnPid}, train = #role_train{center = ?true}}, Fid) ->
    info_ctp(Fid, {rob_info, ConnPid});
rob_info(#role{link = #link{conn_pid = ConnPid}, train = #role_train{center = ?false}}, Fid) ->
    info_tp(Fid, {rob_info, ConnPid});
rob_info(_Role, _Fid) -> ok.

%% @spec update_role_train(Role, {integer(), integer()}) -> {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 角色入住历练场，异步回调更新role_train数据
update_role_train(Role = #role{train = Train}, Fid, train_center) ->
    NewRole = Role#role{train = Train#role_train{id = Fid, center = ?true}},
    {ok, NewRole};
update_role_train(Role = #role{train = Train}, Fid, _Where) ->
    NewRole = Role#role{train = Train#role_train{id = Fid, center = ?false}},
    {ok, NewRole}.

%% @spec sit(Role) -> {ok, NewRole}
%% Role = #role{}
%% @doc 开始历练
sit(#role{train = #role_train{train = Tt}}, _Lid, _Aid, _Type) when Tt =< 0 ->
    {false, ?L(<<"您没有历练次数了">>)};
sit(Role = #role{attr =  #attr{fight_capacity = FC}}, Lid, Aid, Type) ->
    case Lid =:= train_mgr_common:assign_lid(FC) of
        true ->
            Gold = pay:price(?MODULE, sit, Type),
            Loss = [#loss{label = gold, val = Gold}],
            role:send_buff_begin(),
            case role_gain:do(Loss, Role) of
                {ok, NRole} ->
                    case do_sit(NRole, Lid, Aid, Type) of
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {false, Reason};
                        {ok, NewRole} ->
                            refresh_all_times(NewRole),
                            role:send_buff_flush(),
                            {ok, NewRole}
                    end;
                {false, _} ->
                    role:send_buff_clean(),
                    {false, gold_less}
            end;
        _ ->
            {false, ?L(<<"您不可以在该段位进行历练">>)}
    end.

%% 开始历练 
do_sit(Role = #role{train = Train = #role_train{id = Fid, train = Tt, center = Center}}, Lid, Aid, Type)  when Fid =:= {0, 0} orelse Fid =:= {Lid, Aid} ->
    TrainRole = to_train_role(Role),
    TrainMod = ?train_tag_to_mod(Center),
    case TrainMod:call({Lid, Aid}, {sit, TrainRole#train_role{type = Type}}) of
        {false, Reason} ->
            {false, Reason};
        {ok, {Lid, Aid}} ->
            NewRole = Role#role{train = Train#role_train{train = Tt - 1, fight = TrainRole#train_role.fight}},
            {ok, NewRole};
        _D ->
            {false, ?L(<<"系统繁忙，请稍候!">>)}
    end;
%% 切换场区历练
do_sit(Role = #role{id = RoleId, train = Train = #role_train{id = OldFid, train = Tt, center  = Center}}, Lid, Aid, Type) ->
    NewFid = {Lid, Aid},
    TrainMod = ?train_tag_to_mod(Center),
    case TrainMod:call(OldFid, {if_sit_able, RoleId}) of
        true ->
            TrainRole = to_train_role(Role),
            case TrainMod:call(NewFid, {sit, TrainRole#train_role{type = Type}}) of
                {false, Reason} ->
                    {false, Reason};
                {ok, NewFid} ->
                    info(TrainMod, OldFid, {delete_sit_info, RoleId}),
                    NewRole = Role#role{train = Train#role_train{id = NewFid, train = Tt - 1, fight = TrainRole#train_role.fight}},
                    {ok, NewRole};
                _ ->
                    {false, ?L(<<"系统繁忙，请稍候!">>)}
            end;
        {false, Reason} ->
            {false, Reason};
        _ ->
            {false, ?L(<<"系统繁忙，请稍候!">>)}
    end.

%% @spec rob(Role, integer(), integer(), integer(), binary()) -> ok | {false, Reason}
%% Role = #role{}
%% Reason = binary()
%% @doc 打劫
rob(#role{train = #role_train{id = {0, 0}}}, _Lid, _Aid, _Rid, _Srvid) ->
    {false, ?L(<<"需要进入飞仙历练场区">>)};
rob(#role{train = #role_train{rob = Rob}}, _Lid, _Aid, _Rid, _Srvid) when Rob =< 0 ->
    {false, ?L(<<"仙友，打家劫舍有风险，明日再来吧!">>)};
rob(Role = #role{id = RoleId, pid = Pid, train = Train = #role_train{id = {SLid, SAid}, rob = Rob, center = Center}}, Lid, Aid, Rid, Srvid) ->
    TrainMod = ?train_tag_to_mod(Center),
    case TrainMod:call({SLid, SAid}, {rob,  RoleId}) of
        ok ->
            info(TrainMod, {Lid, Aid}, {rob, Rid, Srvid, Pid}),
            NewRole = Role#role{train = Train#role_train{rob = Rob - 1}},
            refresh_all_times(NewRole),
            {ok, NewRole};
        {false, Reason} ->
            {false, Reason};
        _ ->
            {false, ?L(<<"系统繁忙，请稍候!">>)}
    end.

%% @spec async_rob(Role, T) -> {ok}
%% Role = #role{}
%% T = #train_role{} | false
%% @doc 打劫异步回调
async_rob(Role = #role{id = RoleId, train = Train = #role_train{id = Fid, rob = Rob, center = Center}}, false) ->
    info(Center, Fid, {rob_failed, RoleId}),
    NewRob = case Rob < ?train_role_rob of
        true -> Rob + 1;
        _ -> Rob
    end,
    NewRole = Role#role{train = Train#role_train{rob = NewRob}},
    refresh_all_times(NewRole),
    {ok, NewRole};

async_rob(Role, TrainRole) ->
    Rob = rob_clone_role(TrainRole),
    combat_type:check(?combat_type_train_rob, Role, Rob),
    {ok}.

%% @spec rob_win(Role, {Fid, RoleId}) -> {ok}
%% Role = #role{}
%% Fid = {integer(), integer()}
%% RoleId = {integer(), binary()}
%% @doc 打劫成功
rob_win(Role = #role{link = #link{conn_pid = ConnPid}, train = #role_train{center = Center}}, {{Lid, Aid}, RoleId}) ->
    RobRole = to_rob_role(Role, RoleId),
    info(Center, {Lid, Aid}, {i_am_the_won_rob, RobRole}),
    sys_conn:pack_send(ConnPid, 18908, {?true, ?L(<<"你绑上这家伙火速奔向人贩子！">>)}),
    {ok}.

%% @spec rob_lose(Role) -> {ok}
%% Role = #role{}
%% @doc 打劫失败 解锁打劫状态
rob_lose(#role{id = RoleId, train = #role_train{id = Fid, center = Center}, link = #link{conn_pid = ConnPid}}) ->
    info(Center, Fid, {rob_complete, RoleId}),
    sys_conn:pack_send(ConnPid, 18908, {?false, ?L(<<"对方有点狠，打劫需谨慎！">>)}),
    {ok}.

%% @spec arrest(Role, integer(), integer(), integer(), binary()) -> ok | {false, Reason}
%% Role = #role{}
%% Reason = binary()
%% @doc 缉拿
arrest(#role{train = #role_train{id = {0, 0}}}, _Lid, _Aid, _Rid, _Srvid) ->
    {false, ?L(<<"需要进入飞仙历练场区">>)};
arrest(#role{train = #role_train{arrest = Arrest}}, _Lid, _Aid, _Rid, _Srvid) when Arrest =< 0 ->
    {false, ?L(<<"仙友，除暴安良虽好，可也要注意身体!">>)};
arrest(Role = #role{id = RoleId, pid = Pid, train = Train = #role_train{id = {SLid, SAid}, arrest = Arrest, center = Center}}, Lid, Aid, Rid, Srvid) ->
    TrainMod = ?train_tag_to_mod(Center),
    case TrainMod:call({SLid, SAid}, {arrest,  RoleId}) of
        ok ->
            info(Center, {Lid, Aid}, {arrest, Rid, Srvid, Pid}),
            NewRole = Role#role{train = Train#role_train{arrest = Arrest - 1}},
            refresh_all_times(NewRole),
            {ok, NewRole};
        {false, Reason} ->
            {false, Reason};
        _ ->
            {false, ?L(<<"系统繁忙，请稍候!">>)}
    end.

%% @spec async_arrest(Role, T) -> {ok}
%% Role = #role{}
%% T = #train_role{} | false
%% @doc 缉拿异步回调
async_arrest(Role = #role{id = RoleId, train = Train = #role_train{id = Fid, arrest = Arrest, center = Center}}, false) ->
    info(Center, Fid, {arrest_failed, RoleId}),
    NewArrest = case Arrest < ?train_role_arrest of
        true -> Arrest + 1;
        _ -> Arrest
    end,
    NewRole = Role#role{train = Train#role_train{arrest = NewArrest}},
    refresh_all_times(NewRole),
    {ok, NewRole};

async_arrest(Role, TrainRole) ->
    Rob = arrest_clone_role(TrainRole),
    combat_type:check(?combat_type_train_arrest, Role, Rob),
    {ok}.

%% @spec arrest_lose(Role) -> {ok}
%% Role = #role{}
%% @doc 缉拿失败 解锁缉拿状态
arrest_lose(#role{id = RoleId, train = #role_train{id = Fid, center = Center}, link = #link{conn_pid = ConnPid}}) ->
    info(Center, Fid, {arrest_complete, RoleId}),
    sys_conn:pack_send(ConnPid, 18908, {?false, ?L(<<"这个劫匪有点猛！">>)}),
    {ok}.

%% @spec arrest_win(Role) -> {ok}
%% Role = #role{}
%% @doc 缉拿完成 解锁缉拿状态
arrest_win(#role{id = RoleId, train = #role_train{id = Fid, center = Center}, link = #link{conn_pid = ConnPid}}) ->
    info(Center, Fid, {arrest_complete, RoleId}),
    sys_conn:pack_send(ConnPid, 18908, {?false, ?L(<<"小小劫匪手到擒来啊！">>)}),
    {ok}.

%% @spec combat_over(Type, {Referee, Winners, Losers}) -> ok
%% Type = rob | arrest
%% Referee = Fid = {integer(), integer()}
%% Winners = Losers = [#fighter{} | ..]
%% @doc 战斗结束
%% 打劫者胜利
combat_over(rob, {{_Center, Fid}, [#fighter{pid = Pid}], [#fighter{rid = RoleId, srv_id = Srvid}]}) when is_pid(Pid) ->
    role:apply(async, Pid, {?MODULE, rob_win, [{Fid, {RoleId, Srvid}}]});
%% 被劫者胜利
combat_over(rob, {{Center, Fid}, [#fighter{rid = RoleId, srv_id = Srvid}], [#fighter{pid = Pid}]}) when is_pid(Pid) ->
    role:apply(async, Pid, {?MODULE, rob_lose, []}),
    info(Center, Fid, {i_resist_the_rob, {RoleId, Srvid}});
%% 缉拿者胜利
combat_over(arrest, {{Center, Fid}, [#fighter{rid = ArrestId, srv_id = Asrvid, pid = Pid, name = Name}], [#fighter{rid = RobId, srv_id = Srvid}]}) when is_pid(Pid) ->
    role:apply(async, Pid, {?MODULE, arrest_win, []}),
    info(Center, Fid, {arrest_success, Name, {ArrestId, Asrvid}, {RobId, Srvid}});
%% 被缉拿者胜利
combat_over(arrest, {{Center, Fid}, [#fighter{rid = RobId, srv_id = Srvid}], [#fighter{rid = ArrestId, srv_id = Asrvid, pid = Pid}]}) when is_pid(Pid) ->
    role:apply(async, Pid, {?MODULE, arrest_lose, []}),
    info(Center, Fid, {arrest_resisted, {ArrestId, Asrvid}, {RobId, Srvid}});
combat_over(_, _) -> ok.

%% @spec is_full(TrainRole) -> true | false
%% @doc 查看是否满人
is_full(TrainRole) ->
    is_full(TrainRole, 0).
is_full([], Num) ->
    Num >= ?train_field_max_num;
is_full([#train_role{train_time = 0} | Roles], Num) ->
    is_full(Roles, Num);
is_full([_ | Roles], Num) ->
    is_full(Roles, Num + 1).

%% @spec to_train_role(#role{}) -> #train_role{}
%% @doc 转换历练者数据
to_train_role(#role{id = RoleId, sex = Sex, career = Career, lev = Lev, hp_max = HM, mp_max = MM, pid = Pid, name = Name, 
        attr = Attr = #attr{fight_capacity = FC}, eqm = Eqm, skill = Skill, looks = Looks, demon = Demon, pet = PetBag, ascend = Ascend}) ->
    NewAttr = convert_attr(Attr, FC),
    NewFC = case FC > 5000 of
        true ->trunc(FC * (1 - 1/100 * math:pow(FC-5000,1.02)/math:pow(10000-5000, 1.02)));
        false -> FC
    end,
    #train_role{id = RoleId, pid = Pid ,name = Name , sex = Sex, career = Career, lev = Lev, hp_max = HM, mp_max = MM, 
        attr = NewAttr, eqm = Eqm, skill = Skill, pet_bag = PetBag, demon = Demon, looks = Looks, fight = NewFC, ascend = Ascend}.

%% @spec to_rob_role(#role{}) -> #train_rob{}
%% @doc 转换打劫者数据
to_rob_role(#role{id = RoleId, sex = Sex, career = Career, lev = Lev, hp_max = HM, mp_max = MM, pid = Pid, name = Name, train = #role_train{id = Fid},
        attr = Attr = #attr{fight_capacity = FC}, eqm = Eqm, skill = Skill, looks = Looks, demon = Demon, pet = PetBag, ascend = Ascend}, ORoleId) ->
    NewAttr = convert_attr(Attr, FC),
    NewFC = case FC > 5000 of
        true ->trunc(FC * (1 - 1/100 * math:pow(FC-5000,1.02)/math:pow(10000-5000, 1.02)));
        false -> FC
    end,
    #train_rob{id = RoleId, oid = ORoleId, pid = Pid, name = Name, sex = Sex, lev = Lev, career = Career, hp_max = HM, mp_max = MM, fid = Fid,
        eqm = Eqm, skill = Skill, attr = NewAttr, pet_bag = PetBag, demon = Demon, looks = Looks, fight = NewFC, ascend = Ascend}.

%% @spec rob_clone_role(#train_role{}) -> #role{}
%% @doc 复制 role 数据
rob_clone_role(#train_role{id = {Rid, Srvid}, name = Name, sex = Sex, lev = Lev, career = Career, hp_max = HpMax, mp_max = MpMax, eqm = Eqm, skill = Skill, attr = Attr, pet_bag = PetBag, demon = Demon, looks = Looks, ascend = Ascend, grade = Lid, area = Aid}) ->
    #role{id = {Rid, Srvid}, name = Name, sex = Sex, career = Career, lev = Lev, hp = HpMax, mp = MpMax, hp_max = HpMax, mp_max = MpMax, attr = Attr, looks = Looks, pet = PetBag, skill = Skill, eqm = Eqm, demon = Demon, ascend = Ascend, train = #role_train{id = {Lid, Aid}}}.

%% @spec arrest_clone_role(#train_rob{}) -> #role{}
%% @doc 复制 role 数据
arrest_clone_role(#train_rob{id = {Rid, Srvid}, name = Name, sex = Sex, lev = Lev, career = Career, hp_max = HpMax, mp_max = MpMax, eqm = Eqm, skill = Skill, attr = Attr, pet_bag = PetBag, demon = Demon, looks = Looks, ascend = Ascend, grade = Lid, area = Aid}) ->
    #role{id = {Rid, Srvid}, name = Name, sex = Sex, career = Career, lev = Lev, hp = HpMax, mp = MpMax, hp_max = HpMax, mp_max = MpMax, attr = Attr, looks = Looks, pet = PetBag, skill = Skill, eqm = Eqm, demon = Demon, ascend = Ascend, train = #role_train{id = {Lid, Aid}}}.

%% @spec condition(#role{}) -> true | {false, Reason}
%% @doc 活动参加限制
condition(#role{lev = Lev}) when Lev < ?train_lev_limit ->
    {false, ?L(<<"等级不足，不可以参加该活动!">>)};
condition(#role{cross_srv_id = CSI}) when CSI =/= <<>> ->
    {false, ?L(<<"跨服场景中不可以参加该活动!">>)};
condition(#role{status = ?status_die}) ->
    {false, ?L(<<"死亡状态下不可以参加该活动!">>)};
condition(#role{status = ?status_fight}) ->
    {false, ?L(<<"战斗状态下不可以参加该活动!">>)};
condition(#role{status = ?status_transfer}) ->
    {false, ?L(<<"传送状态下不可以参加该活动!">>)};
condition(_) ->
    true.

%% 生产机器人
robot(local, Lid, Aid, Num) when Lid =/=0 andalso Aid =/= 0 ->
    info_tp({Lid, Aid}, {robot, Num});
robot(center, Lid, Aid, Num) when Lid =/=0 andalso Aid =/= 0 ->
    info_ctp({Lid, Aid}, {robot, Num}).

%% 拼接进程名字
gen_train_process_name(Lid, Aid) ->
    Str = lists:concat(["train_", Lid, "_", Aid]),
    try erlang:list_to_existing_atom(Str) of
        Name -> Name
    catch 
        _:_ -> erlang:list_to_atom(Str)
    end.

%% @spec pos() -> ok
%% @doc 重新生成 train_pos 文件
pos() ->
    X = 400, 
    Y = 150,
    MinX = 750 - X,
    MaxX = 750 + X,
    MinY = 500 - Y, 
    MaxY = 500 + Y,
    pos(MinX, MaxX, MinY, MaxY, X, Y).

pos(MinX, MaxX, MinY, MaxY, X, Y) ->
    posx(MaxX, MinY, MaxY, X, Y, MinX, []).

posx(MaxX, _MinY, _MaxY, _X, _Y, Index, Acc) when Index > MaxX ->
    {ok, IoDev} = file:open("d:/mhfx/server/src/mod/train/train_pos.erl", [write]),
    file:write(IoDev, "%% ----------------------------\n%% 历练位置\n%% -----------------------------\n"),
    file:write(IoDev, "-module(train_pos).\n-export([list/0]).\n"),
    file:write(IoDev, "list() ->\n\t[\n\t\t"),
    DisOrderAcc = disOrder(Acc),
    pos_write(IoDev, DisOrderAcc),
    file:write(IoDev, "\n\t]."),
    file:close(IoDev),
    Acc;
posx(MaxX, MinY, MaxY, X, Y, Index, Acc) ->
    Re = posy(MaxY, X, Y, Index, MinY, []),
    NewAcc = lists:foldl(fun(Elem, Ac) -> [Elem|Ac] end, Acc, Re),
    posx(MaxX, MinY, MaxY, X, Y, Index + 30, NewAcc).

posy(MaxY, _X, _Y, _CurX, Index, Acc) when Index > MaxY ->
    Acc;
posy(MaxY, X, Y, CurX, Index, Acc) ->
    case round(math:pow(CurX - 750, 2)/math:pow(X, 2) + math:pow(Index - 500, 2)/math:pow(Y, 2)) =< 1 of
        true ->
            posy(MaxY, X, Y, CurX, Index + 30, [{CurX, Index} | Acc]);
        false ->
            posy(MaxY, X, Y, CurX, Index + 30, Acc)
    end.

pos_write(IoDev, Acc) ->
    pos_write(IoDev, Acc, 0).
pos_write(_IoDev, [], _) ->
    ok;
pos_write(IoDev, Acc, Index) when Index >= 10 ->
    file:write(IoDev, "\n\t\t"),
    pos_write(IoDev, Acc, 0);
pos_write(IoDev, [H | []], _Index) ->
    file:write(IoDev, io_lib:format("~w", [H])),
    ok;
pos_write(IoDev, [H | T], Index) ->
    file:write(IoDev, io_lib:format("~w,", [H])),
    pos_write(IoDev, T, Index + 1).

%% 初始化随机位置
init_xys(Roles) ->
    Used = [{X, Y} || #train_role{x = X, y = Y} <- Roles, X =/=0 andalso Y =/= 0],
    Poses = train_pos:list(),
    Poses -- Used.

%% 定期结算
train_gain(Mod, Roles, Xys) ->
    Now = util:unixtime(),
    train_gain(Mod, Now, Roles, [], Xys, [], []).
train_gain(_Mod, _Now, [], Roles, Xys, DoneRole, NeedUpdateRole) ->
    {Roles, Xys, DoneRole, NeedUpdateRole};
train_gain(Mod, Now, [Role = #train_role{train_time = 0} | Roles], NewRoles, Xys, DoneRole, NeedUpdateRole) ->
    train_gain(Mod, Now, Roles, [Role | NewRoles], Xys, DoneRole, NeedUpdateRole);
train_gain(Mod, Now, [Role = #train_role{id = {Rid, Srvid}, name = Rname, pid = Pid, train_time = Beg, rob_time = Rtime, pause_time = Ptime, type = Type, x = X, y = Y, lev = Lev, loss = Loss} | Roles], NewRoles, Xys, DoneRole, NeedUpdateRole) when Rtime =:= 0 ->
    case Beg + Ptime + ?train_time_cost =< Now of
        true ->
            Gap = count_train_time(Beg, util:unixtime(), Ptime),
            Soul = fx_train_data:soul(Lev, Type),
            GainSoul = ?train_soul_gain(Gap, Soul) - Loss,
            train_gain_mail(Mod, {Rid, Srvid}, Rname, GainSoul),
            NewRole = Role#train_role{train_time = 0, rob_time = 0, pause_time = 0, x = 0, y = 0, type = 0},
            catch role:pack_send(Pid, 18903, {0, 0, 0, 0}),
            NewXys = case lists:member({X, Y}, Xys) of
                true -> Xys;
                false -> [{X, Y} | Xys]
            end,
            train_gain(Mod, Now, Roles, [NewRole | NewRoles], NewXys, [NewRole | DoneRole], NeedUpdateRole);
        false ->
            train_gain(Mod, Now, Roles, [Role | NewRoles], Xys, DoneRole, NeedUpdateRole)
    end;
train_gain(Mod, Now, [Role = #train_role{rob_time = Rtime} | Roles], NewRoles, Xys, DoneRole, NeedUpdateRole) ->
    case util:unixtime() - Rtime > ?dead_status_gap of
        false -> train_gain(Mod, Now, Roles, [Role | NewRoles], Xys, DoneRole, NeedUpdateRole);
        _ ->
            NewRole = Role#train_role{rob_time = 0},
            train_gain(Mod, Now, Roles, [NewRole | NewRoles], Xys, DoneRole, [NewRole | NeedUpdateRole])
    end.

convert_attr(Attr, FC) when is_record(Attr, attr) ->
    [_ | L] = erlang:tuple_to_list(Attr),
    Fun = fun(Elem) ->
            if
                FC > 5000 -> trunc(Elem * (1 - 1/100 * math:pow(FC - 5000, 1.02)/math:pow(10000-5000, 1.02)));
                true -> Elem
            end
    end,
    NewAttr = erlang:list_to_tuple([attr | lists:map(Fun, L)]),
    case is_record(NewAttr, attr) of
        true -> NewAttr;
        _ -> Attr
    end;
convert_attr(Attr, _FC) ->
    ?ERR("角色战斗属性折算错误【~w】", [Attr]),
    Attr.

%% 计算劫匪位置
count_new_pos(Pos, Viaxy, Desxy, Time) ->
    Distance = Time * ?rob_speed,
    D1 = distance(Pos, Viaxy),
    D2 = distance(Viaxy, Desxy),
    case Distance > D1 of
        true ->
            case Distance >= D1 + D2 of
                true ->
                    Desxy;
                false ->
                    RemD = Distance - D1,
                    do_count_new_pos(RemD, D2, Viaxy, Desxy)
            end;
        false ->
            do_count_new_pos(Distance, D1, Pos, Viaxy)
    end.

%% 计算点位置
do_count_new_pos(D1, D, {Bx, By}, {Ex, Ey})->
    NewX = if
        Ex > Bx ->
            round(D1 * (Ex - Bx)/D) + Bx;
        Ex < Bx ->
            Bx - round(D1 * (Bx-Ex)/D);
        true ->
            Bx
    end,
    NewY = if
        Ey > By ->
            round(D1 * (Ey - By)/D) + By;
        Ey < By ->
            By - round(D1 * (By-Ey)/D);
        true ->
            By
    end,
    {NewX, NewY}.

%% 计算两点位置
distance({X1, Y1}, {X2, Y2}) ->
    round(math:sqrt(math:pow(X2 - X1, 2) + math:pow(Y2 - Y1, 2))).

%% 历练奖励邮件
train_gain_mail(Mod, {Rid, Srvid}, Rname, GainSoul) ->
    Sub = <<"飞仙历练收获">>,
    Text = <<"您经过辛苦历练，获得了以下奖励，请注意查收!">>,
    MailInfo = {Sub, Text, [{?mail_soul, GainSoul}], []},
    pack_send_mail(Mod, {Rid, Srvid, Rname}, MailInfo).

%% 计算打劫后奖励
rob_gain(Mod, #train_rob{id = {RobId, RobSrvId}, soul = RobSoul, name = RobName}, #train_role{id = {RoleId, RoleSrvId}, name = RoleName, type = Type, lev  = Lev, train_time = Beg, rob_time = Rtime, pause_time = Ptime, loss = Loss}) ->
    rob_success_mail(Mod, {RobId, RobSrvId}, RobName, RobSoul),
    Gap = count_train_time(Beg, Rtime, Ptime),
    Soul = fx_train_data:soul(Lev, Type),
    GainSoul = ?train_soul_gain(Gap, Soul) - Loss,
    Subject = <<"飞仙历练被打劫收获">>,
    MailText = case Mod of
        train_center ->
            RobPlatform = srv_id_mapping:platform(RobSrvId),
            RolePlatform = srv_id_mapping:platform(RoleSrvId),
            RobServerNo = srv_id_mapping:srv_sn(RobSrvId),
            case RobPlatform =:= RolePlatform of
                true -> 
                    util:fbin(<<"真是不幸，当您正辛苦历练时，被江洋大盗【~s.~w服.~s】击晕卖给了人贩子，您辛苦历练的经验被劫持了大半，您只获得了以下奖励">>, [RobPlatform, RobServerNo, RobName]);
                false -> 
                    util:fbin(<<"真是不幸，当您正辛苦历练时，被江洋大盗【域外时空.~s】击晕卖给了人贩子，您辛苦历练的经验被劫持了大半，您只获得了以下奖励">>, [RobName])
            end;
        train ->
            util:fbin(<<"真是不幸，当您正辛苦历练时，被江洋大盗【~s】击晕卖给了人贩子，您辛苦历练的经验被劫持了大半，您只获得了以下奖励">>, [RobName])
    end,
    MailInfo = {Subject, MailText, [{?mail_soul, GainSoul}], []},
    pack_send_mail(Mod, {RoleId, RoleSrvId, RoleName}, MailInfo).


%% 打劫奖励邮件
arrest_success_mail(Mod, {{Aid, Asrvid}, Aname}, {{Rid, Rsrvid}, RobName}, Soul) ->
    Sub = <<"飞仙历练缉拿收获">>,
    Text = <<"今日出行居然遇到一拐卖妇女儿童的家伙，您成功救下人质，获得以下奖励。">>,
    MailInfo = {Sub, Text, [{?mail_soul, Soul}], []},
    pack_send_mail(Mod, {Aid, Asrvid, Aname}, MailInfo),
    Sub1 = <<"飞仙历练被缉拿通知">>,
    Text1 = util:fbin(<<"您辛苦劫来的一肥镖，居然被【~s】给解救了，致使您一无所获，真是可惜！">>, [Aname]),
    MailInfo1 = {Sub1, Text1, [], []},
    pack_send_mail(Mod, {Rid, Rsrvid, RobName}, MailInfo1).

%% rob_success_mail
rob_success_mail(Mod, {Rid, Rsrvid}, RobName, Soul) ->
    Sub = <<"飞仙历练打劫收获">>,
    MailInfo = case Soul > 0 of
        true ->
            Text = <<"今日豁出去拦路干了一票，成功劫得以下奖励。">>,
            {Sub, Text, [{?mail_soul, Soul}], []};
        _ ->
            Text = <<"这位仙友，很不幸的告诉你，你这一次白忙活啦！劫持奖励为 0，下次劫持请务必看清楚哦！">>,
            {Sub, Text, [], []}
    end,
    pack_send_mail(Mod, {Rid, Rsrvid, RobName}, MailInfo).

%% 发生奖励邮件
pack_send_mail(train_center, {Rid, SrvId, Name}, MailInfo) ->
    c_mirror_group:cast(node, SrvId, mail_mgr, deliver, [{Rid, SrvId, Name}, MailInfo]);
pack_send_mail(train, {Rid, SrvId, Name}, MailInfo) ->
    mail_mgr:deliver({Rid, SrvId, Name}, MailInfo);
pack_send_mail(train_center, {Rid, SrvId}, MailInfo) ->
    c_mirror_group:cast(node, SrvId, mail_mgr, deliver, [{Rid, SrvId}, MailInfo]);
pack_send_mail(train, {Rid, SrvId}, MailInfo) ->
    mail_mgr:deliver({Rid, SrvId}, MailInfo);
pack_send_mail(_Mod, _RoleInfo, _MailInfo) -> ok.

%% 乱序列表
disOrder([]) -> [];
disOrder(List) ->
    Len = length(List),
    Poses = lists:seq(1,Len),
    NewAllocs = alloc_pos(List, Poses, Len),
    [Elem || {_, Elem} <- lists:keysort(1, NewAllocs)].

alloc_pos(List, Poses, Len) ->
    alloc_pos(List, Poses, Len, []).

alloc_pos([], [], _Len, List) ->
    List;
alloc_pos([_H | _T], [], _Len, List) ->
    ?ERR("重新给列表元素分配位置时，元素数目与位置数目不匹配"),
    List;
alloc_pos([], [_H | _T], _Len, List) ->
    ?ERR("重新给列表元素分配位置时，元素数目与位置数目不匹配"),
    List;
alloc_pos([H | T], Poses, Len, List) ->
    Pos = util:rand(1, Len),
    {AllocPos, RemPoses} = takeAwayElem(Poses, Pos),
    alloc_pos(T, RemPoses, Len - 1, [{AllocPos, H} | List]).

takeAwayElem(List, Pos) ->
    takeAwayElem(List, Pos, 1, []).

takeAwayElem([H | T], Pos, Pos, List) ->
    NewList = lists:reverse(takeAwayElemRem(T, List)),
    {H, NewList};
takeAwayElem([H | T], Pos, Index, List) ->
    takeAwayElem(T, Pos, Index + 1, [H|List]).

takeAwayElemRem([], Acc) ->
    Acc;
takeAwayElemRem([H | T], Acc) ->
    takeAwayElemRem(T, [H|Acc]).

rob_roles(Role, Xys) ->
    rob_roles(Role, Xys, [], 1000).
rob_roles(_Role, [], Roles, _Index) ->
    Roles;
rob_roles(Role, [{X, Y} | T], Roles, Index) ->
    R = Role#train_role{x = X, y = Y, id = {Index, <<"test_1">>}},
    rob_roles(Role, T, [R |Roles], Index + 1).

%% 计算历练时长 未被打劫状态
count_train_time(Beg, Rtime, Ptime) ->
    case Rtime - Beg - Ptime of
        Diff when Diff >= ?train_time_cost ->
            ?train_time_cost;
        Diff when Diff >= 0 ->
            Diff;
        _ -> 0
    end.

%% refresh_all_times(Role) -> ok
refresh_all_times(#role{link = #link{conn_pid = ConnPid}, train = #role_train{train = Train, rob = Rob, arrest = Arrest, fight = Fc}}) ->
    sys_conn:pack_send(ConnPid, 18902, {Train, Rob, Arrest, Fc}).

%% 历练事件通知
notice(train, {Name, Visitors}) ->
    Fun = fun(#train_visitor{pid = Pid}) ->
            case is_pid(Pid) of
                true -> role:pack_send(Pid, 18917, {util:fbin(?L(<<"玩家 ~s 加入历练">>), [Name])});
                _ -> ok
            end
    end,
    lists:foreach(Fun, Visitors);

%% 劫持事件通知
notice(rob, {RobName, RobedName, Visitors}) ->
    Fun = fun(#train_visitor{pid = Pid}) ->
            case is_pid(Pid) of
                true -> role:pack_send(Pid, 18917, {util:fbin(?L(<<"玩家 ~s 劫持了玩家 ~s">>), [RobName, RobedName])});
                _ -> ok
            end
    end,
    lists:foreach(Fun, Visitors);

%% 劫持事件通知
notice(arrest, {ArrestName, ArrestedName, Visitors}) ->
    Fun = fun(#train_visitor{pid = Pid}) ->
            case is_pid(Pid) of
                true -> role:pack_send(Pid, 18917, {util:fbin(?L(<<"玩家 ~s 缉拿了玩家 ~s">>), [ArrestName, ArrestedName])});
                _ -> ok
            end
    end,
    lists:foreach(Fun, Visitors).

%% 打劫公告
%% train_common:notice(rob_world, {Lid, Aid, {RobId, RobName}, {ORoleId, RoleName}}),
rob_hearsay(train, {Lid, Aid}, {{_RobId, _RobSrvid}, RobName}, {{_RoleId, _RoleSrvId}, RoleName}) ->
    Name = fx_train_data:lid_to_name(Lid),
    Msg = util:fbin(<<"飞仙历练 ~s {str, ~s, #00DEFF} 胆大包天，青天白日下居然劫持了 {str, ~s, #00DEFF}，请得道仙友{handle, 61, 速去缉拿, FFFF66, ~w, ~w}！">>, [Name, RobName, RoleName, Lid, Aid]),
    notice:send(53, Msg);
rob_hearsay(train_center, {Lid, Aid}, {{_RobId, RobSrvId}, RobName}, {{_RoleId, RoleSrvId}, RoleName}) ->
    Name = fx_train_data:lid_to_name(Lid),
    RobPlatform = srv_id_mapping:platform(RobSrvId),
    RolePlatform = srv_id_mapping:platform(RoleSrvId),
    RobServerNo = srv_id_mapping:srv_sn(RobSrvId),
    Msg = case RobPlatform =:= RolePlatform of
        true -> util:fbin(<<"飞仙历练 ~s 中, 本服玩家【{str, ~s, #00DEFF}】被 【~s.~w服】玩家【{str, ~s, #00DEFF}】 所劫持 ，请本服得道仙友{handle, 61, 速去缉拿, FFFF66, ~w, ~w}！">>, [Name, RoleName, RobPlatform, RobServerNo, RobName, Lid, Aid]);
        false -> util:fbin(<<"飞仙历练 ~s 中, 本服玩家【{str, ~s, #00DEFF}】被 【域外时空】玩家【{str, ~s, #00DEFF}】 所劫持 ，请本服得道仙友{handle, 61, 速去缉拿, FFFF66, ~w, ~w}！">>, [Name, RoleName, RobName, Lid, Aid])
    end,
    c_mirror_group:cast(node, RoleSrvId, notice, send, [53, Msg]).

%% 广播场区状态
refresh_area_status(_Mod, Lid, Aid, Num, Visitors) ->
    Status = case Num >= ?train_field_max_num of
        true -> 1;
        false -> 0
    end,
    Fun = fun(#train_visitor{pid = Pid}) ->
            case is_pid(Pid) of
                true -> role:pack_send(Pid, 18911, {Lid, Aid, Status});
                _ -> ok
            end
    end,
    lists:foreach(Fun, Visitors).

%% 生成机器人
gen_robot(Role, Xys, Num) ->
    Time = util:unixtime() - 200,
    gen_robot(Role, Xys, [], 1, Time, Num).
gen_robot(_Role, [], Roles, _Index, _Now, _Num) ->
    Roles;
gen_robot(_Role, _, Roles, Index, _Now, Num) when Index >= Num ->
    Roles;
gen_robot(Role = #train_role{id = {_, Srvid}}, [{X, Y} | T], Roles, Index, Now, Num) ->
    R = Role#train_role{x = X, y = Y, id = {Index, Srvid}, name = <<"robot">>, train_time = Now + Index},
    gen_robot(Role, T, [R |Roles], Index + 1, Now, Num).
