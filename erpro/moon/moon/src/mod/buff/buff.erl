%%----------------------------------------------------
%% Buff系统(跟战斗Buff不是同一种，战斗Buff特殊处理)
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(buff).
-export([
        init/0 %% 初始化角色
        ,add/2  %% 需计算角色属性
        ,add_pool/3 %% 增加血量法力存储
        ,del_buff_by_label/2 %% 带计算以及推送
        ,del_buff_by_label_no_push/2 %% 不带计算和推送
        ,del_by_id_no_push/2 %% 不带计算和推送
        ,has/2
        ,get/2
        ,search/2
        ,replace/2
        ,del_by_id/2 %% 带计算以及推送
        ,calc/1
        ,calc_ratio/1
        ,recalc_bufftime/1
        ,restart_buff/1
        ,bufflist_to_client/1
        ,shortcut_to_client/1
        ,check_buff/2
        ,do_buff_special_callback/2
        ,ver_parse/1
        ,has_effect/2
    ]
).
-include("buff.hrl").
-include("role.hrl").
-include("link.hrl").
-include("common.hrl").
-include("arena.hrl").
-include("offline_exp.hrl").

%% 角色初始化
init() ->
    #rbuff{shortcut_pool = [{hp, 0, open}, {mp, 0, open}]}.

%% 版本转换
ver_parse({rbuff, NextId, undefined, BuffList}) ->
    #rbuff{next_id = NextId, shortcut_pool = [{hp, 0, open}, {mp, 0, open}], buff_list = BuffList};
ver_parse(Rbuff) -> Rbuff.

%% 给角色添加一个Buff
%% @spec add(Role, Buff) -> {ok, NewRole} | {false, Reason}
%% @doc TODO 增加buff之后需要手动推送角色属性 role_api:push_attr
%% Role = NewRole = #rbuff{} 角色buff数据
%% Buff = #buff{} 待添加的Buff数据
%% Reason = binary() 处理失败原因
add(Role, BuffLabel) when is_atom(BuffLabel) ->
    case buff_data:get(BuffLabel) of
        {ok, BuffBase} ->
            add_buff(Role, BuffBase);
        {false, Reason} -> {false, Reason}
    end;
add(Role, Buff) when is_record(Buff, buff) ->
    add_buff(Role, Buff).

add_buff(Role, BuffBase)->
    Buff = modify_duration(BuffBase),
    case add_to_role(Role, Buff) of
        {ok, AddId, NewRole = #role{buff = #rbuff{buff_list = _BuffList}}} ->
            BuffRole = do_add_buff_timer(AddId, Buff, NewRole),
            % BuffRole1 = do_buff_special(BuffRole, Buff),
            % SendData = buff:bufflist_to_client(BuffList),
            % sys_conn:pack_send(ConnPid, 10400, {SendData}),
            {ok, BuffRole};
        {false, Reason} -> {false, Reason}
    end.

%% @spec del_buff_by_label(Role, BuffLabel) -> {ok, NewRole} | false
%% @doc 根据Bufflabel删除人物身上某个BUFF,成功返回NewRole,不存在该Buff则返回false
del_buff_by_label(Role = #role{buff = #rbuff{buff_list = BuffList}}, BuffLabel) ->
    case has(BuffList, BuffLabel) of
        false -> false;
        {ok, #buff{id = Id}} ->
            Nrole = case role_timer:del_timer(BuffLabel, Role) of
                {ok, {_, _}, NewRole} -> NewRole;
                false -> Role
            end,
            del_by_id(Nrole, Id)
    end.

%% @spec has_cover(BuffList, CoverList, CoverBuff) -> {true, NewBuffList, DelBuffLabel} | false
%% @doc  判断Bufflist是否存在CoverList里面的BUff,存在 则替换, 不存在 直接添加
has_cover(_BuffList, [], _CoverBuff) -> false;
has_cover([], _CoverList, _CoverBuff) -> false;
has_cover(BuffList, [Label | T], CoverBuff) ->
    case lists:keyfind(Label, #buff.label, BuffList) of
        false -> 
            has_cover(BuffList, T, CoverBuff);
        _ ->
            {true, lists:keydelete(Label, #buff.label, BuffList), Label}
    end.

%% @spec has_conflict(BuffList, ConflictBuffList, ConflictBuff) -> true | false
%% @doc  判断Bufflist是否存在ConflictBuffList里面的BUff,存在则冲突, 不存在则可添加
has_conflict(_BuffList, [], _ConflictBuff) -> true;
has_conflict([], _ConflictBuffList, _ConflictBuff) -> true;
has_conflict(BuffList, [Label | T], ConflictBuff) ->
    case lists:keyfind(Label, #buff.label, BuffList) of
        false -> 
            has_conflict(BuffList, T, ConflictBuff);
        _ ->
            false
    end.

%% @spec recalc_bufftime(BuffList) -> NewBuffList;
%% @doc 重新计算Buff的剩余时间,用于下线保存用
recalc_bufftime(Role = #role{buff = #rbuff{buff_list = BuffList}}) ->
    recalc_bufftime(Role, BuffList, []).
recalc_bufftime(Role = #role{buff = Buff}, [], NewBuffList) ->
    {ok, Role#role{buff = Buff#rbuff{buff_list = NewBuffList}}};
recalc_bufftime(Role, [Buff = #buff{type = 2, endtime = EndTime} | T], NewBuffList) ->
    Last = (EndTime - util:unixtime()), %%离终止时间
    case Last > 0 of
        false ->
            recalc_bufftime(Role, T, NewBuffList);
        true ->
            recalc_bufftime(Role, T, [Buff | NewBuffList])
    end;
recalc_bufftime(Role, [Buff = #buff{endtime = EndTime, type = Type, duration = Duration} | T], NewBuffList)
when Type =:= 1 andalso Duration =/= -1 ->
    Last = (EndTime - util:unixtime()), %%离终止时间
    ?DEBUG("EndTime:~w, Last:~w",[EndTime, Last]),
    case Last > 0 of
        false ->
            recalc_bufftime(Role, T, NewBuffList);
        true ->
            recalc_bufftime(Role, T, [Buff#buff{duration = Last} | NewBuffList])
    end;
recalc_bufftime(Role, [Buff | T], NewBuffList) ->
    recalc_bufftime(Role, T, [Buff | NewBuffList]).

%% @spec restart_buff(Role) -> NewRole;
%% @doc 重新登录开启buff定时
restart_buff(Role = #role{buff = #rbuff{buff_list = BuffList}})->
    ?DEBUG("BUFF:~w", [BuffList]),
    NewBuffList = clear_bufflist(BuffList),
    ?DEBUG("BUFF:~w", [NewBuffList]),
    restart_buff(Role, NewBuffList, []).
restart_buff(Role = #role{buff = Rbuff}, [], ReBuff) ->
    Role#role{buff = Rbuff#rbuff{buff_list = ReBuff}};
restart_buff(Role, [#buff{label = guild_arena_score_buff, type = 0} | T], ReBuff) ->
    restart_buff(Role, T, ReBuff);
restart_buff(Role, [#buff{label = guard_honor} | T], ReBuff) ->
    restart_buff(Role, T, ReBuff);
restart_buff(Role, [Buff = #buff{endtime = EndTime, type = 2} | T], ReBuff) ->
    %% 离线计时类型
    Now = util:unixtime(),
    NewRole = do_buff_offline(Now, Buff, Role),
    case EndTime - Now > 0 of
        true -> 
            restart_buff(NewRole, T, [Buff | ReBuff]);
        false -> %% 已过期
            restart_buff(NewRole, T, ReBuff)
    end;
restart_buff(Role, [Buff = #buff{id = Id, label = Label, type = Type, duration = Duration} | T], ReBuff)
when Type =:= 1 andalso Duration =/= -1 -> %% 离线不计时的buff
    EndTime = util:unixtime() + Duration,
    Role1 = do_buff_special(Role, Buff),
    NewRole = role_timer:set_timer(Label, Duration * 1000, {buff, del_by_id, [Id]}, 1, Role1),
    restart_buff(NewRole, T, [Buff#buff{endtime = EndTime} | ReBuff]);
restart_buff(Role, [Buff | T], ReBuff) ->
    restart_buff(Role, T, [Buff | ReBuff]).

%% 处理要特殊的buff;
%% buff开启或者上线时检测
do_buff_special(Role, #buff{type = 1, id = Id, label = Label, duration = Duration})
when Label =:= fly_buff_1 orelse Label =:= fly_buff_2 orelse Label =:= fly_buff_3 ->
    %% 玄光翼buff结束前10秒提示
    role_timer:set_timer({special_buff, Label}, ((Duration - 10) * 1000), {buff, do_buff_special_callback, [{Id, Label}]}, 1, Role),
    Role;
%% do_buff_special(Role, #buff{label = Label})
%% when Label =:= demon_1 orelse Label =:= demon_2 orelse Label =:= demon_3 orelse Label =:= demon_4 ->
%%     demon:add_follow_looks(Role); %% 守护跟随buff
do_buff_special(Role, _) ->
    Role.
%% 特殊处理的回调函数
do_buff_special_callback(#role{link = #link{conn_pid = ConnPid}, buff = #rbuff{buff_list = BuffList}}, {_Id, Label})
when Label =:= fly_buff_1 orelse Label =:= fly_buff_2 orelse Label =:= fly_buff_3 ->
    case has(BuffList, Label) of
        false -> ignore;
        {ok, _Buff} ->
            sys_conn:pack_send(ConnPid, 10402, {1, 10, <<>>})
    end,
    {ok};
do_buff_special_callback(_, _) ->
    {ok}.

%% 获取指定id的Buff
%% @spec get(BuffList, Id) -> {ok, Buff} | false
%% BuffList =  [#buff{} | ...] Buff列表
%% Id = Buff Id
%% Buff = #buff{} 找到的Buff数据
get(BuffList, Id) ->
    case lists:keyfind(Id, #buff.id, BuffList) of
        false -> false;
        Buff -> {ok, Buff}
    end.

%% 是否存在某种Buff，跟search/2所不同的是，只返回第一个找到的结果
%% @spec has(BuffList, Label) -> {ok, Buff} | false
%% BuffList = [#buff{} | ...] Buff列表
%% Label = Buff标签
%% Buff = #buff{} Buff数据
has(BuffList, Label) ->
    case lists:keyfind(Label, #buff.label, BuffList) of
        false -> false;
        Buff -> {ok, Buff} 
    end.

%% 查找特定效果的buff, 并返回该类型的最终效果
%% @spec has_effect(BuffList, Label) -> false | {Label, Val}
has_effect(BuffList, Label) ->
    has_effect(BuffList, Label, []).
has_effect([], _, []) -> false;
has_effect([], Label, EffectList) -> do_add_effect(Label, EffectList);
has_effect([#buff{effect = Effect} | T], Label, EffectList) ->
    case lists:keyfind(Label, 1, Effect) of
        {Label, Val} ->
            has_effect(T, Label, [{Label, Val} | EffectList]);
        _ ->
            has_effect(T, Label, EffectList)
    end.

do_add_effect(Label, EffectList) ->
    do_add_effect(Label, EffectList, {Label, 0}).
do_add_effect(_, [], {Label, Val}) -> {Label, Val};
do_add_effect(Label, [{Label, V} | T], {Label, Val}) ->
    do_add_effect(Label, T, {Label, Val + V}).

%% 找出所有相同标签的Buff
%% @spec search(BuffList, Label) -> {ok, List} | false
%% BuffList = List = [#buff{} | ...] Buff列表
%% Label = Buff标签
search(BuffList, Label) -> search(BuffList, Label, []).
search([], _Label, Rtn) -> Rtn;
search([B = #buff{label = L} | T], Label, Rtn) when L =:= Label ->
    search(T, Label, [B | Rtn]);
search([_ | T], Label, Rtn) -> search(T, Label, Rtn).

%% 替换BUFF，以#buff.id作主键
%% @spec replace(BuffList, Buff) -> List
%% BuffList = List = [#buff{} | ...] Buff列表
replace(BuffList, Buff) ->
    lists:keyreplace(Buff#buff.id, #buff.id, BuffList, Buff).

%% 删除角色指定ID的buff
%% @spec del_buff_by_label_no_push(Role, Lable) -> {ok, NewRole} | false
%% @doc TODO 删除之后需要计算角色属性
del_buff_by_label_no_push(Role = #role{buff = #rbuff{buff_list = BuffList}}, BuffLabel) ->
    case has(BuffList, BuffLabel) of
        false -> false;
        {ok, #buff{id = Id}} ->
            Nrole = case role_timer:del_timer(BuffLabel, Role) of
                {ok, {_, _}, NewRole} -> NewRole;
                false -> Role
            end,
            del_by_id_no_push(Nrole, Id)
    end.

%% 删除角色身上指定ID的Buff
%% TODO 不带计算角色属性 
%% @spec del_by_id_no_push(Role, Id) -> {ok, NewRole}
%% Role= NewRole= #role{} 角色buff数据
%% Id = integer() 数字ID
del_by_id_no_push(Role = #role{id = {RoleId, SrvId}, buff = Rbuff = #rbuff{buff_list = BuffList}, event = ?event_arena_match, event_pid = EventPid}, Id) ->
    case lists:keyfind(Id, #buff.id, BuffList) of
        #buff{label = ?arena_buff_label} ->
            arena:delete_buff(EventPid, RoleId, SrvId); %% 通知竞技场
        _Buff -> ignore
    end,
    NewBuffList = lists:keydelete(Id, #buff.id, BuffList), 
    % SendData = bufflist_to_client(NewBuffList),
    % sys_conn:pack_send(ConnPid, 10400, {SendData}),
    {ok, Role#role{buff = Rbuff#rbuff{buff_list = NewBuffList}}};
del_by_id_no_push(Role = #role{buff = Rbuff = #rbuff{buff_list = BuffList}}, Id) ->
    NewBuffList = lists:keydelete(Id, #buff.id, BuffList), 
    % SendData = bufflist_to_client(NewBuffList),
    % sys_conn:pack_send(ConnPid, 10400, {SendData}),
    {ok, Role#role{buff = Rbuff#rbuff{buff_list = NewBuffList}}}.

%% 删除角色身上指定ID的Buff
%% 删除Buff需要重新计算角色属性
%% @spec del_by_id(Role, Id) -> {ok, NewRole}
%% Role= NewRole= #role{} 角色buff数据
%% Id = integer() 数字ID
del_by_id(Role = #role{id = {RoleId, SrvId}, event = Event, event_pid = EventPid, link = #link{conn_pid = ConnPid}, buff = Rbuff = #rbuff{buff_list = BuffList}}, Id) ->
    Role1 = case lists:keyfind(Id, #buff.id, BuffList) of
        #buff{label = ?arena_buff_label} when Event =:= ?event_arena_match ->
            arena:delete_buff(EventPid, RoleId, SrvId),  %% 通知竞技场
            Role;
        #buff{label = Label} when Label =:= fly_buff_1 orelse Label =:= fly_buff_2 orelse Label =:= fly_buff_3 ->
            fly_api:fly_sign_over(Role); %% 飞行取消
        #buff{label = Label} when Label =:= demon_1 orelse Label =:= demon_2 orelse Label =:= demon_3 orelse Label =:= demon_4 ->
            demon:unfollow(Role); %% 精灵守护跟随取消
        #buff{label = Label} ->
            case buff_data:get_mount_look_id(Label) of %% 清除坐骑变身卡外观
                null ->
                    Role;
                LookId ->
                    mount:del_buff_skin(LookId, Role)
            end;
        _ ->
            Role
    end,
    NewBuffList = lists:keydelete(Id, #buff.id, BuffList), 
    SendData = bufflist_to_client(NewBuffList),
    sys_conn:pack_send(ConnPid, 10400, {SendData}),
    Nr = looks:calc(Role1#role{buff = Rbuff#rbuff{buff_list = NewBuffList}}),
    NewRole = role_api:push_attr(Nr),
    looks:refresh(Role, NewRole),
    {ok, NewRole}.


%% @spec calc(Role) -> NewRole
%% @doc 重新计算BUFF效果，当某些BUFF被删除或失效时需要调用
%% <div>注意：此函数不能直接调用，必须由role_api:calc_attr/1来调用</div>
%% Role = NewRole = #role{} 角色数据
calc(Role = #role{buff = #rbuff{buff_list = BuffList}}) ->
    calc(BuffList, Role).
calc([], Role) -> Role;
calc([#buff{effect = Effect} | T], Role) ->
    case buff_effect:do(Effect, Role) of
        {false, _} -> calc(T, Role);
        {ok, NewRole} -> calc(T, NewRole)
    end.

%% @spec calc_ratio(Role) -> NewRole
%% @doc 计算BUFF的加成效果
%% <div>注意：此函数不能直接调用，必须由role_api:calc_attr/1来调用</div>
calc_ratio(Role = #role{buff = #rbuff{buff_list = BuffList}}) ->
    calc_ratio(BuffList, Role).
calc_ratio([], Role) -> Role;
calc_ratio([#buff{effect = Effect} | T], Role) ->
    case buff_effect:do_ratio(Effect, Role) of
        {false, _} -> calc_ratio(T, Role);
        {ok, NewRole} -> calc_ratio(T, NewRole)
    end.

%% @spec  add_pool(Label, Num, Role) -> {false, Reason} | {ok, NewRole}
%% @doc 增加储存池的气血和法力
add_pool(hp_pool, Pool, _Role) when Pool =< 0 -> {false, ?L(<<"配置参数有误, 无法增加">>)};
add_pool(hp_pool, Pool, Role = #role{id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}, buff = Rbuff = #rbuff{shortcut_pool = ShortCutPool}}) ->
    case lists:keyfind(hp, 1, ShortCutPool) of
        false ->
            ?ERR("角色[id:~w, SrvId:~s]数据错误,无法发现快捷回复属性", [Rid, SrvId]),
            {?false, <<"">>};
        {hp, HpPool, _} when HpPool > 100000000 -> {?false, ?L(<<"气血储存已经满满的啦，再补就要溢出了">>)};
        {hp, HpPool, Flag} ->
            NewHpPool = {hp, HpPool + Pool, Flag},
            NewShortCutPool = lists:keyreplace(hp, 1, ShortCutPool, NewHpPool),
            Msg2 = buff:shortcut_to_client(NewShortCutPool),
            sys_conn:pack_send(ConnPid, 10403, {Msg2}),
            {ok, role_api:push_attr(Role#role{buff = Rbuff#rbuff{shortcut_pool = NewShortCutPool}})}
    end;
add_pool(mp_pool, Pool, _Role) when Pool =< 0 -> {false, ?L(<<"配置参数有误, 无法增加">>)};
add_pool(mp_pool, Pool, Role = #role{id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}, buff = Rbuff = #rbuff{shortcut_pool = ShortCutPool}}) ->
    case lists:keyfind(mp, 1, ShortCutPool) of
        false ->
            ?ERR("角色[id:~w, SrvId:~s]数据错误,无法发现快捷回复属性", [Rid, SrvId]),
            {?false, <<"">>};
        {mp, MpPool, _} when MpPool > 100000000 -> {?false, ?L(<<"法力储存已经满满的啦，再补就要溢出了">>)};
        {mp, MpPool, Flag} ->
            NewMpPool = {mp, MpPool + Pool, Flag},
            NewShortCutPool = lists:keyreplace(mp, 1, ShortCutPool, NewMpPool),
            Msg2 = buff:shortcut_to_client(NewShortCutPool),
            sys_conn:pack_send(ConnPid, 10403, {Msg2}),
            {ok, role_api:push_attr(Role#role{buff = Rbuff#rbuff{shortcut_pool = NewShortCutPool}})}
    end;
add_pool(_, _, _) -> {false, ?L(<<"配置错误, 无法增加">>)}.

%% -----------------------------------------------
%% 内部函数
%% -----------------------------------------------

%% 执行添加操作
do_add(Role, Buff = #buff{label = _Label, effect = Effect, duration = Duration}) ->
    case do_use(Effect, Role) of
        {false, Reason} -> {false, Reason};
        %% skip表示不要再添加此Buff
        {skip, Id, NewRole} -> 
            {ok, Id, NewRole};
        {ok, NewRole = #role{buff = Rbuff = #rbuff{next_id = Id, buff_list = BuffList}}, BuffLabel} -> 
            %% 强制转换Buff的label为BuffLabel
            {ok, Id, NewRole#role{buff = Rbuff#rbuff{next_id = Id + 1,
                        buff_list = [Buff#buff{id = Id, label = BuffLabel, endtime = util:unixtime() + Duration, effect = Effect} | BuffList]}}};
        {ok, NewRole = #role{buff = Rbuff = #rbuff{next_id = Id, buff_list = BuffList}}} ->
            {ok, Id, NewRole#role{buff = Rbuff#rbuff{next_id = Id + 1,
                        buff_list = [Buff#buff{id = Id, endtime = util:unixtime() + Duration, effect = Effect} | BuffList]}}}
    end.

%% 增加气血包存量
do_use([{hp_pool, Val}], Role = #role{buff = Rbuff = #rbuff{buff_list = BuffList}}) ->
    case has(BuffList, hp_pool) of
        {ok, B = #buff{id = Id, duration = Duration}} -> %% 已有气血包在使用中，增加存量
            L = replace(BuffList, B#buff{label = hp_pool, duration = Duration + Val}),
            {skip, Id, Role#role{buff = Rbuff#rbuff{buff_list = L}}};
        false -> %% 没有气血包存在
            {ok, Role, hp_pool};
        _Err ->
            {false, ?L(<<"气血包数据异常">>)}
    end;

do_use([{mp_pool, Val}], Role = #role{buff = Rbuff = #rbuff{buff_list = BuffList}}) ->
    case has(BuffList, mp_pool) of
        {ok, B = #buff{id = Id, duration = Duration}} -> %% 已有法力包在使用中，增加存量
            L = replace(BuffList, B#buff{label = mp_pool, duration = Duration + Val}),
            {skip, Id, Role#role{buff = Rbuff#rbuff{buff_list = L}}};
        false -> %% 没有法力包存在
            {ok, Role, mp_pool};
        _Err ->
            {false, ?L(<<"气血包数据异常">>)}
    end;

do_use(_All, Role) ->
    {ok, Role}.

%% 增加仙宠经验加成
%%do_use({xcexp_time, Val},  Role = #role{ratio = Ratio = #ratio{xcexp = V}}) ->
%%    {ok, Role#role{ratio = Ratio#ratio{xcexp = V - Val}}};

%% 容错处理
%%do_use(_Eff, _Role) ->
%%    ?ELOG("无法处理的BUFF效果: ~w", [_Eff]),
%%    {false, <<"处理BUFF效果失败">>}.

%% 检查互斥关系
check_exclude(_, []) -> true;
check_exclude([], _) -> true;
check_exclude([#buff{label = L} | T], Exclude) ->
    case lists:member(L, Exclude) of
        true -> false;
        false -> check_exclude(T, Exclude)
    end.

bufflist_to_client(BuffList) ->
    bufflist_to_client(BuffList, []).
bufflist_to_client([], SendData) -> SendData;
bufflist_to_client([#buff{id = Id, baseid = BaseId, icon = Icon, type = 2, duration = Duration, endtime = EndTime} | T], SendData)
when Duration =/= -1 ->
    bufflist_to_client(T, [{Id, BaseId, Icon, EndTime} | SendData]);
bufflist_to_client([#buff{id = Id, baseid = BaseId, icon = Icon, type = Type, duration = Duration, endtime = EndTime} | T], SendData)
when Type =:= 1 andalso Duration =/= -1 ->
    bufflist_to_client(T, [{Id, BaseId, Icon, EndTime} | SendData]);
bufflist_to_client([#buff{id = Id, baseid = BaseId, icon = Icon, duration = Duration} | T], SendData) ->
    bufflist_to_client(T, [{Id, BaseId, Icon, Duration} | SendData]).

%% 组装格式
shortcut_to_client(ShortCutList) ->
    shortcut_to_client(ShortCutList, []).
shortcut_to_client([], SendData) -> SendData;
shortcut_to_client([{Label, Pool, Switch} | T], SendData) ->
    case Label of
        hp ->
            Flag = case Switch of
                open -> 1;
                close -> 0
            end,
            shortcut_to_client(T, [{1, Flag, Pool} | SendData]);  
        mp ->
            Flag = case Switch of
                open -> 1;
                close -> 0
            end,
            shortcut_to_client(T, [{2, Flag, Pool} | SendData]);  
        _ ->
            shortcut_to_client(T, SendData)
    end;
shortcut_to_client([_ | T], SendData) -> shortcut_to_client(T, SendData).
            

%% 设置buff的定时器
do_add_buff_timer(_AddId, #buff{duration = -1}, Role) -> Role;
do_add_buff_timer(AddId, #buff{label = Label, type = 1, duration = Duration}, Role) ->
    role_timer:set_timer(Label, Duration * 1000, {buff, del_by_id, [AddId]}, 1, Role);
do_add_buff_timer(AddId, #buff{label = Label, type = 2, duration = Duration}, Role) ->
    role_timer:set_timer(Label, Duration * 1000, {buff, del_by_id, [AddId]}, 1, Role);
do_add_buff_timer(_AddId, _Buff, Role) ->
    Role.

%% 向角色信息中加入新的buff
add_to_role(Role = #role{buff = Rbuff =#rbuff{buff_list = BuffList}}, Buff = #buff{label = Label, multi = M, msg = Msg}) ->
    if
        M =:= 0 -> %% 不允许多个共存
            case lists:keyfind(Label, #buff.label, BuffList) of
                false -> do_add(Role, Buff);
                _ -> {false, Msg}
            end;
        M =:= 1 -> %% 需要查找互斥设置
            case check_exclude(BuffList, buff_data:exclude(Label)) of
                true -> do_add(Role, Buff);
                false -> {false, Msg}
            end;
        M =:= 3 -> %% 同类高级覆盖
            CoverList = buff_data:cover(Label),
            ConflictList = buff_data:conflict(Label),
            case has_conflict(BuffList, ConflictList, Buff) of
                false -> {false, ?L(<<"不能替换同类效果">>)};
                true ->
                    case has_cover(BuffList, CoverList, Buff) of
                        false ->
                            do_add(Role, Buff);
                        {true, NewBuffList, DelBuffLabel} ->
                            NRole = Role#role{buff = Rbuff#rbuff{buff_list = NewBuffList}},
                            NewRole = case role_timer:del_timer(DelBuffLabel, NRole) of
                                {ok, {_, _}, BackRole} ->  
                                    BackRole;
                                false -> NRole
                            end,
                            do_add(NewRole, Buff)
                    end
            end;
        true ->
            case check_exclude(BuffList, buff_data:exclude(Label)) of
                true -> do_add(Role, Buff);
                false -> {false, Msg}
            end
    end.

%% 离线计时类型的BUFF，离线效果处理
do_buff_offline(_Now, #buff{type = 2}, Role = #role{offline_exp = #offline_exp{last_logout_time = LastTime}}) when LastTime =< 0 ->
    Role;
do_buff_offline(Now, #buff{id = BuffId, label = Label, endtime = EndTime, type = 2}, Role = #role{offline_exp = #offline_exp{last_logout_time = LastTime}}) ->
    case (Dt = (EndTime - Now)) > 0 of
        true ->
            NewRole = do_calc_buff_offline(Label, Now - LastTime, Role),
            role_timer:set_timer(Label, Dt * 1000, {buff, del_by_id, [BuffId]}, 1, NewRole);
        false -> %% 已过期
            NewRole = do_calc_buff_offline(Label, EndTime - LastTime, Role),
            case buff_data:get_mount_look_id(Label) of  %% 清除坐骑变身卡外观
                null -> NewRole;
                SkinId -> mount:del_buff_skin(SkinId, NewRole)
            end
    end.
do_calc_buff_offline(Label, Dtime, Role = #role{lev = Lev, offline_exp = Off = #offline_exp{all_exp = AllExp}}) 
when Label =:= sit_exp5_1 orelse Label =:= sit_exp5_3 ->
    ExpAdd = case Dtime > 0 of
        true ->
            erlang:round(Dtime * role_exp_data:get_sit_exp(Lev) * 4 / 60);
        false -> 0
    end,
    Role#role{offline_exp = Off#offline_exp{all_exp = ExpAdd + AllExp}};
do_calc_buff_offline(_Label, _, Role) -> Role.    

%% 上线清除或者修正过期buff列表（不包括离线计时类型的）
clear_bufflist(BuffList) ->
    clear_bufflist(BuffList, []).
clear_bufflist([], NewBuffList) -> NewBuffList;
clear_bufflist([Buff = #buff{end_date = EndDate} | T], NewBuffList)
when EndDate =/= 0 ->
    Now = util:unixtime(),
    case util:datetime_to_seconds(EndDate) of
        false -> clear_bufflist(T, NewBuffList);
        EndSecond ->
            case Now >= EndSecond of
                true -> clear_bufflist(T, NewBuffList);
                false ->
                    clear_bufflist(T, [get_duration(Buff, EndSecond, Now) | NewBuffList])
            end
    end;
clear_bufflist([Buff | T], NewBuffList) ->
    clear_bufflist(T, [Buff | NewBuffList]).

%% 获取新的duration
get_duration(Buff = #buff{duration = Duration, type = Type}, NewTime, Now)
when Type =:= 1 andalso Duration =/= -1 ->
    Old = Now + Duration, 
    case Old > NewTime of
        true -> Buff#buff{duration = NewTime - Now};
        false -> Buff#buff{duration = Duration}
    end;
get_duration(Buff, _NewTime, _) ->
    Buff.

%% 修正开启的duration
modify_duration(Buff = #buff{duration = Duration, end_date = EndDate}) when EndDate =/= 0 ->
    Now = util:unixtime(),
    Old = Now + Duration,
    case util:datetime_to_seconds(EndDate) of
        false -> Buff#buff{duration = Duration};
        EndSecond ->
            case Old > EndSecond of
                true -> Buff#buff{duration = EndSecond - Now};
                false -> Buff#buff{duration = Duration}
            end
    end;
modify_duration(Buff) -> Buff.

%% @spec check_buff(Role, BuffLabel) ->  
%% 检测玩家是否拥有某buff
check_buff(#role{buff = #rbuff{buff_list = BuffList}}, BuffLabel) ->
    case lists:keyfind(BuffLabel, #buff.label, BuffList) of
        false -> false;
        Buff -> Buff
    end.
