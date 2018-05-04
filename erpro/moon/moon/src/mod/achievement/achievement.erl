%%----------------------------------------------------
%% 成就系统 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(achievement).
-export([
        login/1
        ,gm/2
        ,gm_set_value/3
        ,calc/1
        ,lev_up/1
        ,combat_over/1
        ,loser_combat_over/1
        ,check_finish/2
        ,add_honor/2
        ,add_honor_no_push/2
        ,del_honor/2
        ,del_honor_no_push/2
        ,modify_honor/3
        ,add_new_accept/1
        ,reward/3
        ,list/2
        ,honors/1
        ,use_honor/2
        ,use_honor_no_push/2
        ,add_and_use_honor/2
        ,add_and_use_honor_no_push/2
        ,cancel_honor/2
        ,push_info/3
        ,is_finish_all/1
        ,check_honor/1
        ,use_card/2
        ,get_target_val/1
        ,update_career/1
        ,check_accept/2
        ,add_trigger/3
        ,check_career_step/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("condition.hrl").
-include("achievement.hrl").
-include("link.hrl").
-include("combat.hrl").
-include("looks.hrl").
-include("gain.hrl").

gm(set, {Role = #role{achievement = Ach = #role_achievement{d_list = DList}}, AId, N}) ->
    case lists:keyfind(AId, #achievement.id, DList) of
        A = #achievement{status = 0, progress = [Prog = #achievement_progress{target_value = TV}]} ->
            {Val, Status} = case N >= TV of
                true -> {TV, 1};
                false -> {N, 0}
            end,
            NewProg = Prog#achievement_progress{value = Val, status = Status},
            NewA = A#achievement{progress = [NewProg], status = Status},
            NewDList = lists:keyreplace(AId, #achievement.id, DList, NewA),
            Role1 = Role#role{achievement = Ach#role_achievement{d_list = NewDList}},
            push_info(refresh, NewA, Role1),
            {ok, NRole} = add_new_accept(Role1),
            case Status =:= 1 of
                true -> role_listener:special_event(NRole, {20016, AId});
                false -> NRole
            end;
        _ -> 
            Role
    end;
gm(finish_all, Role = #role{achievement = Ach}) ->
    Role#role{achievement = Ach#role_achievement{finish_list = achievement_data:list(), d_list = []}};
gm(value, {Role = #role{achievement = Ach = #role_achievement{d_list = DList}}, Value}) ->
    case [A || A <- DList, A#achievement.system_type =:= ?achievement_system_type] of
        [I | _] ->
            push_info(refresh, I, Role);
        _ ->
            ok
    end,
    NRole = Role#role{achievement = Ach#role_achievement{value = Value}},
    role_api:push_attr(NRole);
gm(clear, Role) ->
    Role#role{achievement = #role_achievement{}}.

%% 通过控制台完成特殊成就目标事件
gm_set_value(Role, special_event, Args) when is_record(Role, role) ->
    {ok, role_listener:special_event(Role, Args)};
gm_set_value(Role, acc_event, Args) when is_record(Role, role) ->
    {ok, role_listener:acc_event(Role, Args)};
gm_set_value(Role, AId, N) when is_record(Role, role) ->
    {ok, gm(set, {Role, AId, N})};
gm_set_value({Rid, SrvId}, AId, N) ->
    case role_api:lookup(by_id, {Rid, SrvId}, #role.pid) of
        {ok, _N, Pid} -> %% 角色在线 通过异步方式发放称号
            role:apply(async, Pid, {fun  gm_set_value/3, [AId, N]});
        _ -> %% 角色不在线 通过更新数据库发放称号
            ok
    end;
gm_set_value(Name, AId, N) ->
    case role_api:lookup(by_name, Name, #role.pid) of
        {ok, _N, Pid} -> %% 角色在线 通过异步方式发放称号
            role:apply(async, Pid, {fun  gm_set_value/3, [AId, N]});
        _ -> %% 角色不在线 通过更新数据库发放称号
            ok
    end.

%% @spec check_career_step(Role) -> true | {false, Reason}
%% @doc 判断职业进阶
check_career_step(#role{achievement = #role_achievement{value = Value}}) when Value < 2300 ->
    {false, ?L(<<"总成就点数不足2300点，请继续努力。">>)};
check_career_step(#role{achievement = #role_achievement{finish_list = FinishList}}) ->
    AllTargetList = achievement_data:list(?target_system_type),
    case [Id || Id <- AllTargetList, lists:member(Id, FinishList) =:= false] of
        [] -> %% 全部完成
            true;
        _ ->
            {false, ?L(<<"您还未完成全部【长期目标】，请继续努力">>)}
    end.    
%% check_career_step(_) -> true.

%% 角色换职业
update_career(Role = #role{achievement = Ach = #role_achievement{honor_use = Use}}) ->
    NewUse = [HonorId || HonorId <- Use, check_honor_use_cond(Role, HonorId) =:= true],
    NewRole = Role#role{achievement = Ach#role_achievement{honor_use = NewUse}},
    push_info(refresh, honor, NewRole),
    broadcast_honor(NewRole).

%% 角色登录处理
%% 更新目标完成状态，对完成且自动发放奖励的进行奖励发放
%% 对没完成的进行触发器注册
%% @spec login(Role) -> NewRole
login(Role) ->
    Role0 = honor_mgr:login(Role),
    Role1 = rank_reward:login(Role0),
    NRole = #role{special = Special, looks = Looks, achievement = #role_achievement{honor_use = Use, honor_all = All, d_list = DList, finish_list = FList}} = achievement_revise:to_update_new(Role1),
    HadList = [Id || #achievement{id = Id} <- DList] ++ FList,
    ?DEBUG("[~s]已接成就列表[~w]", [Role#role.name, HadList]),
    AllList = achievement_data:list(),
    NoStartList = AllList -- HadList,
    NewAcceptList = do_new_accpet(NRole, NoStartList, []),
    NewDList = DList ++ NewAcceptList,
    {ok, NewRole = #role{achievement = Ach}, NDList} = add_trigger(NRole, NewDList, []),
    %% ?DEBUG("trigger[~w]", [NRole#role.trigger]),
    NewUse = [Honor || Honor <- Use, lists:keyfind(Honor, 1, All) =/= false],
    DelHonor = Use -- NewUse,
    AddLooks = looks_honor(All, NewUse, []),
    NewLooks = case lists:member(60006, NewUse) of
        true -> [{?LOOKS_TYPE_CAMP_DRESS, 19999, 0} | Looks];
        false -> Looks
    end,
    NR = NewRole#role{special = Special ++ AddLooks, looks = NewLooks, achievement = Ach#role_achievement{honor_use = NewUse, d_list = NDList}},
    NewRole0 = del_honor_buff_no_push(DelHonor, NR),
    NewRole1 = add_honor_timer(NewRole0),
    NewRole2 = achievement_everyday:login(NewRole1),
    achievement_7day:login(NewRole2).

%% 增加称号检查定时器
add_honor_timer(Role = #role{achievement = #role_achievement{honor_all = All}}) ->
    NRole = case role_timer:del_timer(check_honor, Role) of
        {ok, _, NR} -> NR;
        false -> Role
    end,
    Now = util:unixtime(),
    case [Time || {_HonorId, _HonorName, Time} <- All, Time > Now] of
        [] -> NRole;
        Times ->
            MinTime = lists:min(Times),
            NextCheckTime = MinTime - Now,
            role_timer:set_timer(check_honor, NextCheckTime * 1000, {achievement, check_honor, []}, 1, NRole)
    end.

%% 定时检查称号过期
check_honor(Role = #role{achievement = Ach = #role_achievement{honor_all = All, honor_use = Use}}) ->
    Now = util:unixtime(),
    NewAll = [Honor || Honor <- All, honor_mgr:check_honor_time(Honor, Now)],
    NewUse = [HonorId || HonorId <- Use, lists:keyfind(HonorId, 1, NewAll) =/= false],
    Role1 = Role#role{achievement = Ach#role_achievement{honor_all = NewAll, honor_use = NewUse}},
    Role2 = del_honor_buff(Use -- NewUse, Role1),
    NewRole = add_honor_timer(Role2),
    push_info(refresh, honor, NewRole),
    {ok, broadcast_honor(NewRole)}.

%% 等级改变
lev_up(Role) ->
    case catch add_new_accept(Role) of
        {ok, NewRole} when is_record(NewRole, role) ->
            achievement_everyday:lev_up(NewRole);
        _ ->
            achievement_everyday:lev_up(Role) 
    end.

%% 战斗结束回调
combat_over(#combat{type = ?combat_type_kill, loser = Loser}) ->
    [role:apply(async, Pid, {fun loser_combat_over/1, []}) 
        || #fighter{type = Type, pid = Pid, is_die = IsDie} <- Loser, IsDie =:= 1, Type =:= ?fighter_type_role];
combat_over(_Combat) ->
    ok.

%% 失败回调
loser_combat_over(Role) ->
    NewRole = role_listener:acc_event(Role, {110, 1}),
    {ok, NewRole}.

%% 判断指定目标是否完成
check_finish(#role{achievement = #role_achievement{d_list = DList, finish_list = FList}}, Id) ->
    case lists:keyfind(Id, #achievement.id, DList) of
        #achievement{status = Status} when Status =:= ?achievement_status_rewarded orelse Status =:= ?achievement_status_finish -> true;
        _ -> lists:member(Id, FList)
    end;
check_finish(_Role, _Id) -> false.

%% 成就人物属性处理
calc(Role = #role{hp_max = MpMax, achievement = #role_achievement{value = Value}}) ->
    %% ?DEBUG("mp_max:[~p] value[~p]", [MpMax, Value]),
    Role#role{hp_max = MpMax + Value}.

%% 称号卡使用
use_card(Role = #role{achievement = Ach = #role_achievement{honor_all = All, honor_use = Use}}, {HonorId, HonorName, Time}) ->
    case achievement_data_honor:get(HonorId) of
        {ok, #honor_base{type = ?honor_card}} -> %% 称号卡称号
            HonorIds = type_honors(?honor_card, All, []),
            NewAll = [{HId, HName, HTime} || {HId, HName, HTime} <- All, lists:member(HId, HonorIds) =:= false],
            NewUse = Use -- HonorIds,
            Role1 = Role#role{achievement = Ach#role_achievement{honor_all = [{HonorId, util:to_binary(HonorName), Time + util:unixtime()} | NewAll], honor_use = [HonorId | NewUse]}},
            Role2 = del_honor_buff(HonorIds, Role1),
            Role3 = add_honor_buff(HonorId, Role2),
            Role4 = add_honor_timer(Role3),
            NewRole = role_api:push_attr(Role4),
            push_info(refresh, honor, NewRole),
            {ok, broadcast_honor(NewRole)};
        _ ->
            {false, ?L(<<"称号数据不存在">>)}
    end.

%% @spec add_honor(Role, {HonorId, HonorName, Time}) -> {ok} | {ok, NRole} 
%% @doc 给指定ID角色增加称号
%% Role = #role{}
%% HonorId = integer()    称号ID标志
%% HonorName = binary()   称号名称 <<"<font color='#ff0000'>结婚称号</font>">>
%% Time = integer()       称号到期时间unixtime() 永久或不定时称号用0
add_honor(Role = #role{}, Honor) when is_integer(Honor) ->
    add_honor(Role, {Honor, <<>>, 0});
add_honor(Role = #role{achievement = Ach = #role_achievement{honor_all = All}}, {HonorId, HonorName, Time}) ->
    case lists:keyfind(HonorId, 1, All) of
        false -> 
            NRole = Role#role{achievement = Ach#role_achievement{honor_all = [{HonorId, util:to_binary(HonorName), Time} | All]}},
            push_info(refresh, honor, NRole),
            {ok, add_honor_timer(NRole)};
        _ ->
            {ok}
    end;
add_honor(Rid, Honor) ->
    case role_api:lookup(by_id, Rid, #role.pid) of
        {ok, _N, Pid} -> %% 角色在线 通过异步方式发放称号
            role:apply(async, Pid, {fun add_honor/2, [Honor]});
        _ -> %% 角色不在线 通过更新数据库发放称号
            ok
    end,
    {ok}.

%% 增加称号 不推送
add_honor_no_push(Role, Honor) when is_integer(Honor) ->
    add_honor_no_push(Role, {Honor, <<>>, 0});
add_honor_no_push(Role = #role{achievement = Ach = #role_achievement{honor_all = All}}, {HonorId, HonorName, Time}) ->
    case lists:keyfind(HonorId, 1, All) of
        false -> 
            NRole = Role#role{achievement = Ach#role_achievement{honor_all = [{HonorId, util:to_binary(HonorName), Time} | All]}},
            {ok, add_honor_timer(NRole)};
        _ ->
            {ok}
    end.

%% @spec add_and_use_honor(Role, {HonorId, HonorName, Time}) -> {ok, NewRole}
%% @doc 增加并使用称号
%% Role = #role{}
%% HonorId = integer()    称号ID标志
%% HonorName = binary()   称号名称 <<"<font color='#ff0000'>结婚称号</font>">>
%% Time = integer()       称号到期时间unixtime() 永久或不定时称号用0
add_and_use_honor({Rid, SrvId}, Honor) ->
    case role_api:lookup(by_id, {Rid, SrvId}, #role.pid) of
        {ok, _N, Pid} -> %% 角色在线 通过异步方式发放称号
            role:apply(async, Pid, {fun add_and_use_honor/2, [Honor]});
        _ -> %% 角色不在线 通过更新数据库发放称号
            ok
    end,
    {ok};
add_and_use_honor(Role, HonorId) when is_integer(HonorId) ->
    add_and_use_honor(Role, {HonorId, <<>>, 0});
add_and_use_honor(Role, {HonorId, HonorName, Time}) ->
    case add_honor(Role, {HonorId, HonorName, Time}) of
        {ok, NRole} ->
            case use_honor(false, HonorId, NRole) of
                {ok, NewRole} -> {ok, NewRole};
                _ -> {ok, NRole}
            end;
        _ ->
            {ok, Role}
    end.

%% @spec add_and_use_honor_no_push(Role, {HonorId, HonorName, Time}) -> {ok, NewRole}
%% @doc 增加并使用称号
%% Role = #role{}
%% HonorId = integer()    称号ID标志
%% HonorName = binary()   称号名称 <<"<font color='#ff0000'>结婚称号</font>">>
%% Time = integer()       称号到期时间unixtime() 永久或不定时称号用0
add_and_use_honor_no_push(Role, HonorId) when is_integer(HonorId) ->
    add_and_use_honor_no_push(Role, {HonorId, <<>>, 0});
add_and_use_honor_no_push(Role, {HonorId, HonorName, Time}) ->
    case add_honor_no_push(Role, {HonorId, HonorName, Time}) of
        {ok, NRole} ->
            case use_honor_no_push(false, HonorId, NRole) of
                {ok, NewRole} -> {ok, NewRole};
                _ -> {ok, NRole}
            end;
        _ ->
            {ok, Role}
    end.

%% @spec del_honor(Role, HonorId) -> {ok, NRole} | {ok}
%% @doc 删除指定ID角色相关称号
%% Role = #role{}
%% HonorId = integer() 称号Id标志
del_honor(Role = #role{achievement = Ach = #role_achievement{honor_use = Use, honor_all = All}}, HonorId) ->
    case lists:keyfind(HonorId, 1, All) of
        false -> {ok};
        _ -> 
            case lists:member(HonorId, Use) of
                true -> %% 称号正在使用显示
                    NewUse = Use -- [HonorId],
                    NewAll = lists:keydelete(HonorId, 1, All),
                    NRole = Role#role{achievement = Ach#role_achievement{honor_use = NewUse, honor_all = NewAll}},
                    push_info(refresh, honor, NRole),
                    NewRole = del_honor_buff([HonorId], NRole),
                    {ok, broadcast_honor(NewRole)};
                false ->
                    NRole = Role#role{achievement = Ach#role_achievement{honor_all = lists:keydelete(HonorId, 1, All)}},
                    push_info(refresh, honor, NRole),
                    {ok, NRole}
            end
    end;
del_honor(Rid, Honor) ->
    case role_api:lookup(by_id, Rid, #role.pid) of
        {ok, _N, Pid} -> %% 角色在线 通过异步方式发放称号
            role:apply(async, Pid, {fun del_honor/2, [Honor]});
        _ -> %% 角色不在线 通过更新数据库发放称号
            ok
    end,
    {ok}.

%% @spec del_honor_no_push(Role, HonorId) -> {ok, NRole} | {ok}
%% @doc 删除指定ID角色相关称号
%% Role = #role{}
%% HonorId = integer() 称号Id标志
del_honor_no_push(Role = #role{special = Special, achievement = Ach = #role_achievement{honor_use = Use, honor_all = All}}, HonorId) ->
    case lists:keyfind(HonorId, 1, All) of
        false -> {ok};
        _ -> 
            case lists:member(HonorId, Use) of
                true -> %% 称号正在使用显示
                    NewUse = Use -- [HonorId],
                    NewAll = lists:keydelete(HonorId, 1, All),
                    NewSpecial = [Look || Look = {Type, HonorId1, _} <- Special, Type =/= ?special_honor, HonorId1 =/= HonorId],
                    NRole = Role#role{special = NewSpecial, achievement = Ach#role_achievement{honor_use = NewUse, honor_all = NewAll}},
                    NewRole = del_honor_buff_no_push([HonorId], NRole),
                    {ok, NewRole};
                false ->
                    NRole = Role#role{achievement = Ach#role_achievement{honor_all = lists:keydelete(HonorId, 1, All)}},
                    {ok, NRole}
            end
    end.

%% 修改称号
modify_honor(Role = #role{achievement = Ach = #role_achievement{honor_all = All, honor_use = Use}}, HonorId, HonorName) ->
    case achievement_data_honor:get(HonorId) of
        {ok, #honor_base{modify = 1}} ->
            case lists:keyfind(HonorId, 1, All) of
                false -> {false, ?L(<<"当前没有获得此称号">>)};
                {_, _, Time} ->
                    NewAll = lists:keyreplace(HonorId, 1, All, {HonorId, util:to_binary(HonorName), Time}),
                    NRole = Role#role{achievement = Ach#role_achievement{honor_all = NewAll}},
                    push_info(refresh, honor, NRole),
                    case lists:member(HonorId, Use) of
                        false -> %% 当前不在使用
                            {ok, NRole};
                        true -> %% 当前在使用 更新场境
                            {ok, broadcast_honor(NRole)}
                    end
            end;
        _ ->
            {false, ?L(<<"此称号不支持修改">>)}
    end.

%% 增加新的可接受的新成就数据
add_new_accept(Role = #role{name = _Name, achievement = #role_achievement{d_list = DList, finish_list = FList}}) ->
    HadList = [Id || #achievement{id = Id} <- DList] ++ FList,
    AllList = achievement_data:list(),
    NewList = AllList -- HadList,
    NewAcceptList = do_new_accpet(Role, NewList, []),
    ?DEBUG("[~s]新增成就数据列表[~w]", [_Name, [Id || #achievement{id = Id} <- NewAcceptList]]),
    push_info(add, NewAcceptList, Role),
    {ok, NRole = #role{achievement = Ach}, L} = add_trigger(Role, NewAcceptList, []),
    {ok, NRole#role{achievement = Ach#role_achievement{d_list = DList ++ L}}}.


%% 目标系统:奖励领取
reward(?target_system_type, Id, Role = #role{achievement = #role_achievement{d_list = DList, finish_list = FList}}) ->
    Flag = lists:member(Id, FList),
    case lists:keyfind(Id, #achievement.id, DList) of
        false when Flag =:= true -> {false, ?L(<<"不能重复领取奖励哦">>)};
        false -> {false, ?L(<<"目标不存在">>)};
        #achievement{status = ?achievement_status_progress} ->
            {false, ?L(<<"目标没有完成，不能领取奖励">>)};
        Target ->
            case do_reward(Target, Role) of
                {false, Reason} -> {false, Reason};
                {ok, _NewTarget, NRole = #role{achievement = Ach}} ->
                    NDList = lists:keydelete(Id, #achievement.id, DList),
                    {ok, NRole#role{achievement = Ach#role_achievement{d_list = NDList, finish_list = [Id | FList]}}}
            end
    end;
reward(?achievement_system_type, Id, Role = #role{achievement = #role_achievement{d_list = DList, finish_list = FList}}) ->
    Flag = lists:member(Id, FList),
    case lists:keyfind(Id, #achievement.id, DList) of
        false when Flag =:= true -> {false, ?L(<<"不能重复领取奖励哦">>)};
        false -> {false, ?L(<<"成就数据不存在">>)};
        #achievement{status = ?achievement_status_rewarded} ->
            {false, ?L(<<"不能重复领取奖励哦">>)};
        #achievement{status = ?achievement_status_progress} ->
            {false, ?L(<<"成就没有完成，不能领取奖励">>)};
        A ->
            case do_reward(A, Role) of
                {false, Reason} ->
                    {false, Reason};
                {ok, _NewA, NRole = #role{achievement = Ach}} ->
                    push_info(refresh, honor, NRole),
                    NDList = lists:keydelete(Id, #achievement.id, DList),
                    NewRole = NRole#role{achievement = Ach#role_achievement{d_list = NDList, finish_list = [Id | FList]}},
                    NR = role_api:push_attr(NewRole),
                    add_new_accept(NR) 
            end
    end.

%% 成就系统:列表信息
list(Type = ?achievement_system_type, #role{achievement = #role_achievement{value = Val, d_list = DList, finish_list = FList}}) ->
    Achs = [A || A <- DList, A#achievement.system_type =:= Type],
    CFList = [{Id, ?achievement_status_rewarded, get_target_val(Id)} || Id <- FList, Id < 90000],
    {Val, list_to_client(Achs, CFList)};
%% 目标系统:列表信息
list(Type = ?target_system_type, #role{achievement = #role_achievement{d_list = DList, finish_list = FList}}) ->
    Targets = [A || A <- DList, A#achievement.system_type =:= Type],
    CFList = [{Id, ?achievement_status_rewarded} || Id <- FList, Id >= 90000],
    list_to_client(Targets, CFList).

%% 成就系统:已获取称号列表
honors(#role{name = _Name, achievement = #role_achievement{honor_use = Use, honor_all = All}}) ->
    ?DEBUG("角色[~s]称号[use:~w, all:~w]", [_Name, Use, All]),
    {Use, All}.

%% 成就系统:称号更换
use_honor(Id, Role) ->
    use_honor(replace, Id, Role).
use_honor(Mod, Id, Role = #role{achievement = Ach = #role_achievement{honor_use = Use, honor_all = All}}) ->
    ?DEBUG("id:~p,use:~w,all:~w", [Id, Use, All]),
    case check_honor_use(Role, Mod, Id, Use, All) of
        {false, Reason} -> {false, Reason};
        {ok, NewUse} -> 
            NRole = Role#role{achievement = Ach#role_achievement{honor_use = NewUse}},
            NRole1 = del_honor_buff_no_push(Use -- NewUse, NRole),
            NRole2 = add_honor_buff(Id, NRole1),
            NewRole = role_api:push_attr(NRole2),
            push_info(refresh, honor, NewRole),
            {ok, broadcast_honor(NewRole)}
    end.
use_honor_no_push(Id, Role) ->
    use_honor_no_push(replace, Id, Role).
use_honor_no_push(Mod,  Id, Role = #role{achievement = Ach = #role_achievement{honor_use = Use, honor_all = All}}) ->
    ?DEBUG("id:~p,use:~w,all:~w", [Id, Use, All]),
    case check_honor_use(Role, Mod, Id, Use, All) of
        {false, Reason} -> {false, Reason};
        {ok, NewUse} -> 
            NRole = Role#role{achievement = Ach#role_achievement{honor_use = NewUse}},
            NRole1 = del_honor_buff_no_push(Use -- NewUse, NRole),
            NewRole = add_honor_buff(Id, NRole1),
            {ok, NewRole}
    end.

%% 成就系统:取消使用称号
cancel_honor(Id, Role = #role{achievement = Ach = #role_achievement{honor_use = Use}}) ->
    case lists:member(Id, Use) of
        false -> {false, <<>>};
        true ->
            NewUse = Use -- [Id],
            NRole = Role#role{achievement = Ach#role_achievement{honor_use = NewUse}},
            NewRole = del_honor_buff([Id], NRole),
            {ok, broadcast_honor(NewRole)}
    end.

%% 成就系统:向客户端推送新增数据
push_info(add, _As, _Role) ->
    % Achs = [A || A <- As, A#achievement.system_type =:= ?achievement_system_type],
    % push_info(add_achievement, Achs, Role);
    ok;
push_info(add_achievement, [], _Role) ->
    ok;
push_info(add_achievement, _Achs, #role{link = #link{conn_pid = _ConnPid}}) ->
    % SendL = list_to_client(Achs, []),
    % ?DEBUG("新增成就数据:[~w]", [SendL]),
    % sys_conn:pack_send(ConnPid, 13012, {SendL});
    ok;
%% 称号数据更新
push_info(refresh, honor, _Role = #role{link = #link{conn_pid = _ConnPid}}) ->
    % Data = honors(Role),
    % sys_conn:pack_send(ConnPid, 13001, Data);
    ok;
%% 成就系统:向客户端推送更新信息
push_info(refresh, _A = #achievement{system_type = ?achievement_system_type}, #role{achievement = #role_achievement{value = _Val}, link = #link{conn_pid = _ConnPid}}) ->
    % {Id, Status, Value} = to_client(A),
    % sys_conn:pack_send(ConnPid, 13011, {Val, Id, Status, Value});
    ok;

%% 日常目标系统:向客户端推送更新信息
push_info(refresh, #achievement{system_type = ?target_type_everyday, id = _Id, status = _Status}, #role{link = #link{conn_pid = _ConnPid}}) ->
    % sys_conn:pack_send(ConnPid, 13052, {Id, Status});
    ok;

%% 目标系统:向客户端推送更新信息
push_info(refresh, _Target, #role{link = #link{conn_pid = _ConnPid}}) ->
    % Send = to_client(Target),
    % sys_conn:pack_send(ConnPid, 13022, Send);
    ok;

%% 推送成就获得信息 右下角
push_info(inform, {_Type, _Rewards}, #role{pid = _Pid}) ->
    % Msg = case Type of
    %     ?achievement_system_type -> notice_inform:gain_loss(Rewards, ?L(<<"完成成就">>));
    %     _ -> notice_inform:gain_loss(Rewards, ?L(<<"完成目标">>))
    % end,
    % notice:inform(Pid, Msg);
    ok;
push_info(reset_day_target, _, #role{link = #link{conn_pid = _ConnPid}, achievement = #role_achievement{day_reward = _DayReward, day_list = _DayList}}) ->
     % L = [{Id, Status} || #achievement{id = Id, status = Status} <- DayList],
     % sys_conn:pack_send(ConnPid, 13050, {DayReward, L});
     ok;
push_info(_, _, _) ->
    % ?DEBUG("推送信息参数设置不正确").
    ok.

%% @spec is_finish_all() -> bool()
%% @doc 检查是否领取了所有目标奖励
%% @author Jange 2012/4/12
is_finish_all(#role{achievement = #role_achievement{d_list = DList, finish_list = FList}}) ->
    Targets = [A || A <- DList, A#achievement.system_type =:= ?target_system_type andalso A#achievement.status =/= ?achievement_status_rewarded],
    case Targets of
        [] -> 
            %% 看看还有没有未接的目标
            AllList = achievement_data:list(),
            NoStartList = (AllList -- [Id || #achievement{id = Id} <- DList]) -- FList,
            NoStartTarget = [achievement_data:get(TId) || TId <- NoStartList],
            case [BaseA || BaseA <- NoStartTarget, BaseA#achievement_base.system_type =:= ?target_system_type] of
                [] -> true;
                _ -> false
            end;
        _ -> false
    end.

%%----------------------------------------------------
%% 内部方法
%%----------------------------------------------------

%% 找出指定类型的称号
type_honors(_Type, [], HonorIdL) -> HonorIdL;
type_honors(Type, [{HonorId, _HonorName, _Time} | T], HonorIdL) ->
    case achievement_data_honor:get(HonorId) of
        {ok, #honor_base{type = Type}} ->
            type_honors(Type, T, [HonorId | HonorIdL]);
        _ ->
            type_honors(Type, T, HonorIdL)
    end.

%% 广播称号外观
broadcast_honor(Role = #role{looks = Looks, special = Special, achievement = #role_achievement{honor_all = All, honor_use = Use}}) ->
    NewSpecial = [Look || Look = {Type, _, _} <- Special, Type =/= ?special_honor],
    NewLooks0 = [Look || Look = {Type, _, _} <- Looks, Type =/= ?LOOKS_TYPE_CAMP_DRESS],
    NewLooks = case lists:member(60006, Use) of
        true -> [{?LOOKS_TYPE_CAMP_DRESS, 19999, 0} | NewLooks0];
        false -> NewLooks0
    end,
    AddLooks = looks_honor(All, Use, []),
    ?DEBUG("looks[~w]", [AddLooks]),
    NRole = Role#role{special = NewSpecial ++ AddLooks, looks = NewLooks},
    map:role_update(NRole),
    NRole.

%% 称号转换成外观
looks_honor(_All, [], L) -> L;
%% looks_honor(N, [HonorId | T], L) ->
%%    looks_honor(N - 1, T, [{?LOOKS_TYPE_HONOR, HonorId, N} | L]).
looks_honor(All, [HonorId | T], L) when is_integer(HonorId) ->
    case lists:keyfind(HonorId, 1, All) of
        false -> looks_honor(All, T, L);
        {_, HonorName, _} ->
            looks_honor(All, T, [{?special_honor, HonorId, HonorName} | L])
    end;
looks_honor(All, [_ | T], L) ->
    looks_honor(All, T, L).

%% 判断称号是否合法
check_honor_use(Role, Mod, Id, Use, All) -> 
    case lists:member(Id, Use) of
        true -> {false, <<>>};
        false ->
            case lists:keyfind(Id, 1, All) of
                false -> 
                    {false, ?L(<<"当前没有获得此称号">>)};
                _ -> %% 
                    case check_honor_use_cond(Role, Id) of
                        {false, Reason} -> {false, Reason};
                        true ->
                            case achievement_data_honor:get(Id) of
                                {false, Reason} -> {false, Reason};
                                {ok, #honor_base{type = Type}} -> 
                                    HBases = [achievement_data_honor:get(H) || H <- Use],
                                    HL = [H#honor_base.id || {ok, H} <- HBases, H#honor_base.type =:= Type],
                                    case honor_limit_num(Type) of
                                        {Max, _Msg} when length(HL) < Max orelse Max =:= 0 -> %% 当前称号可用
                                            {ok, [Id | Use]};
                                        {_Max, _Msg} when Mod =:= replace -> %% 数量达 采用顶替方式
                                            [DId | _] = HL,
                                            {ok, [Id | Use] -- [DId]};
                                        {_Max, Msg} -> %% 当前称号使用超出限制范围
                                            {false, Msg}
                                    end
                            end
                    end
            end
    end.

%% 检查指定称号是否可以使用
check_honor_use_cond(#role{career = Career, sex = Sex}, HonorId) ->
    case achievement_data_honor:get(HonorId) of
        {false, Reason} -> 
            {false, Reason};
        {ok, #honor_base{career = NeedCareer}} when NeedCareer =/= 0 andalso NeedCareer =/= Career ->
            {false, ?L(<<"职业不匹配，使用失败">>)};
        {ok, #honor_base{sex = NeedSex}} when NeedSex =/= 99 andalso NeedSex =/= Sex ->
            {false, ?L(<<"性别不匹配，使用失败">>)};
        _ -> true
    end.


%% 不同类型称号限制数量
honor_limit_num(?honor_common) -> {1, ?L(<<"普通称号同时只能使用一个">>)};
honor_limit_num(?honor_celebrity) -> {1, ?L(<<"名人称号同时只能使用一个">>)};
honor_limit_num(?honor_rank) -> {1, ?L(<<"十大称号同时只能使用一个">>)};
honor_limit_num(?honor_society) -> {1, <<>>};
honor_limit_num(?honor_glory) -> {0, <<>>}.

%% 列表转换辅助函数
list_to_client([], L) -> L;
list_to_client([I | T], L) ->
    list_to_client(T, [to_client(I) | L]).

%% 转化为传输到客户端信息 
to_client(#achievement{id = Id, system_type = ?achievement_system_type, status = Status, progress = [#achievement_progress{value = Value}]}) ->
    {Id, Status, Value};
to_client(#achievement{id = Id, system_type = ?target_system_type, status = Status, progress = _Progs}) ->
    {Id, Status}.

%% 对一个成就发放奖励
do_reward(A = #achievement{id = Id}, Role) ->
    case achievement_data:get(Id) of
        {false, Reason} -> {false, Reason};
        {ok, #achievement_base{rewards = Rewards}} ->
            case role_gain:do(Rewards, Role) of
                {false, _} ->
                    {false, ?L(<<"领取奖励失败，请检查背包是否已满">>)};
                {ok, NRole} ->
                    rank:listener(achieve, Role, NRole), 
                    NewA = A#achievement{status = ?achievement_status_rewarded, reward_time = util:unixtime()},
                    push_info(refresh, NewA, NRole),
                    push_info(inform, {A#achievement.system_type, Rewards}, NRole),
                    {ok, NewA, NRole}
            end
    end.

%% 处理新的可接受的成就目标基础数据为正常数据
%% Role的改变不需返回，只作条件判断使用 现主要用于成就存在前置开启条件 部分成就一开启即已完成 需继续开启下一个成就
do_new_accpet(_Role, [], List) -> List;
do_new_accpet(Role = #role{achievement = Ach = #role_achievement{d_list = DList}}, [Id | T], List) ->
    case achievement_data:get(Id) of
        {false, _Reason} -> %% 不存在此成就数据
            do_new_accpet(Role, T, List);
        {ok, #achievement_base{system_type = SType, accept_cond = AConds, finish_cond = FConds}} ->
            case check_accept(AConds, Role) of
                false -> %% 不符合接受条件
                    do_new_accpet(Role, T, List);
                true ->
                    Progs = achievement_progress:convert(FConds, Role),
                    PL = [P || P <- Progs, P#achievement_progress.status =:= 0],
                    {FT, Status} = case PL of %% 判断条件是否已完成
                        [] -> {util:unixtime(), 1};
                        _ -> {0, 0}
                    end,
                    A = #achievement{
                        id = Id
                        ,status = Status
                        ,system_type = SType
                        ,progress = get_prev_value(Role, AConds, Progs)
                        ,accept_time = util:unixtime()
                        ,finish_time = FT
                    },
                    do_new_accpet(Role#role{achievement = Ach#role_achievement{d_list = [A | DList]}}, T, [A | List])
            end
    end.

%% 获取前置任务的进度值
get_prev_value(#role{achievement = #role_achievement{d_list = DList}}, [#condition{label = prev_val, target_value = AId}], [Prog]) ->
    case lists:keyfind(AId, #achievement.id, DList) of
        #achievement{progress = [#achievement_progress{value = Val}]} -> 
            [Prog#achievement_progress{value = Val}];
        _ -> 
            case get_target_val(AId) of
                Val when Val > 0 -> 
                    [Prog#achievement_progress{value = Val}];
                _ ->
                    [Prog]
            end
    end;
get_prev_value(_Role, _, Progs) -> Progs.

%% 获取指定数据目标值
get_target_val(Id) ->
    case achievement_data:get(Id) of
        {ok, #achievement_base{finish_cond = [#condition{target_value = Val}]}} -> Val;
        _ ->
            0
    end.

%% 判断是否为可接受成就/目标
check_accept([], _Role) -> true;
check_accept([Cond | T], Role) ->
    case achievement_progress:convert(Cond, Role) of
        #achievement_progress{status = ?achievement_status_finish} -> 
            check_accept(T, Role);
        _ -> false
    end.

%% 更新成就信息
%% 未完成的注册触发器
%% 已完成且未发送奖励的成就发送奖励
add_trigger(Role, [], L) -> {ok, Role, L};
add_trigger(Role, [A = #achievement{status = ?achievement_status_rewarded} | T], L) -> %% 已领取奖励
    add_trigger(Role, T, [A | L]);
add_trigger(Role, [A = #achievement{status = ?achievement_status_finish} | T], L) -> %% 已完成
    add_trigger(Role, T, [A | L]);
add_trigger(Role = #role{trigger = Trigger}, [A = #achievement{status = ?achievement_status_progress, id = Id, progress = Progs} | T], L) -> %% 未完成所有进度 注册触发器
    {ok, NewProgs, NewTrigger} = reg_trigger(Progs, [], Id, Trigger, Role),
    NewA = A#achievement{progress = NewProgs},
    add_trigger(Role#role{trigger = NewTrigger}, T, [NewA | L]);
add_trigger(Role, [A | T], L) -> %% 容错处理
    add_trigger(Role, T, [A | L]).

%% 注册触发器，监控成就目标进度
reg_trigger([], Progs, _AId, Trigger, _Role) -> {ok, Progs, Trigger};
reg_trigger([P = #achievement_progress{status = 0, cond_label = CLabel, trg_label = TrgLabel, target = Target} | T], Progs, AId, Trigger, Role) -> %% 未完成进度且没有注册过触发器
    case role_trigger:add(TrgLabel, Trigger, {achievement_callback, CLabel, [AId, Target]}) of 
        {ok, Id, NewTrigger} ->
            reg_trigger(T, [P#achievement_progress{id = Id} | Progs], AId, NewTrigger, Role);
        _ ->
            ?DEBUG("创建成就进度信息出错:TrgLabel~w, progress:~w", [TrgLabel, P]),
            reg_trigger(T, [P | Progs], AId, Trigger, Role)
    end;
reg_trigger([P | T], Progs, AId, Trigger, Role) -> %% 容错
    reg_trigger(T, [P | Progs], AId, Trigger, Role).

%%-------------------------------------
%% 称号BUFF处理
%%-------------------------------------

%% 删除称号BUSS
del_honor_buff_no_push([], Role) -> Role;
del_honor_buff_no_push([Honor | T], Role) ->
    case achievement_data_honor:get(Honor) of
        {ok, #honor_base{buff = Label}} when Label =/= false ->
            case buff:del_buff_by_label_no_push(Role, Label) of
                {ok, NRole} -> 
                    del_honor_buff_no_push(T, NRole);
                _ -> 
                    del_honor_buff_no_push(T, Role)
            end;
        _ ->
            del_honor_buff_no_push(T, Role)
    end.
%% 删除称号BUSS
del_honor_buff([], Role) -> Role;
del_honor_buff([Honor | T], Role) ->
    case achievement_data_honor:get(Honor) of
        {ok, #honor_base{buff = Label}} when Label =/= false ->
            case buff:del_buff_by_label(Role, Label) of
                {ok, NRole} -> 
                    del_honor_buff(T, NRole);
                _ -> 
                    del_honor_buff(T, Role)
            end;
        _ ->
            del_honor_buff(T, Role)
    end.

%% 增加称号BUFF
add_honor_buff(Honor, Role) ->
    case achievement_data_honor:get(Honor) of
        {ok, #honor_base{buff = Label}} when Label =/= false ->
            case buff:add(Role, Label) of
                {ok, NRole} -> NRole;
                _ -> Role
            end;
        _ -> Role
    end.
