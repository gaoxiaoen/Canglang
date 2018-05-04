%% *********************
%% 技能UI
%% wpf wprehard@qq.com
%% *********************
-module(skill_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("skill.hrl").
-include("gain.hrl").
-include("link.hrl").
%%
-include("ascend.hrl").

%% 获取当前角色的技能列表
handle(11500, {}, #role{skill = #skill_all{skill_list = SkillList}}) ->
    %?DUMP(SkillList),
    {reply, skill:pack_proto_msg(11500, SkillList)};
handle(11500, {}, _Role) ->
    ?DEBUG("角色[~s]技能列表没有初始化", [_Role#role.name]),
    {ok};

%% 学习&升级技能
handle(11501, {SkillId}, Role) ->
    case skill:study(SkillId, Role) of
        {ok, NewRole} -> 
            NRole = role_listener:acc_event(NewRole, {131, 1}), %%技能提升一级            
            {ok, NRole};
        {false, {_ErrCode, Reason}} ->
            {notice:alert(error, Role, Reason)};
        {false, Reason} ->
            {notice:alert(error, Role, Reason)}
    end;

%% 获取装备加级通知
handle(11504, {}, Role = #role{career= Career}) ->
    case eqm_api:find_skill_attr(Role) of
        [] ->
            {reply, {[]}};
        List -> %% 有加技能等级属性的额外加成效果
            NewList = [{(Type rem 100), Num} || {Type, Num} <- List, (Type div 100) =:= Career],%% 过滤非本职业的附加技能
            {reply, {NewList}}
    end;

%% 技能的熟练度更新
handle(11505, {}, #role{skill = #skill_all{skill_list = SkillList}}) ->
    List = [{Id, Skilled} || #skill{id = Id, skilled = Skilled} <- SkillList],
    {reply, {List}};

%% 购买技能熟练度
%% Num表示要购买的熟练度数
handle(11506, {Id, Num}, Role = #role{skill = SA = #skill_all{skill_list = SkillList}}) when Num > 0 ->
    case role:check_cd(skill_skilled, 2) of
        false ->
            {ok};
        true ->
            case lists:keyfind(Id, #skill.id, SkillList) of
                false -> {ok};
                S = #skill{skilled = Skilled} ->
                    Gold = pay:price(?MODULE, skill_exp, Num),
                    Loss = [#loss{label = gold, val = Gold, msg = ?L(<<"晶钻不足,无法提升熟练度">>)}],
                    role:send_buff_begin(),
                    case role_gain:do(Loss, Role) of
                        {ok, NewRole} ->
                            NewSL = lists:keyreplace(Id, #skill.id, SkillList, S#skill{skilled = Skilled + Num}),
                            notice:inform(util:fbin(?L(<<"提升熟练度\n消耗 ~w晶钻">>), [Gold])),
                            role:send_buff_flush(),
                            {reply, {1, <<>>}, NewRole#role{skill = SA#skill_all{skill_list = NewSL}}};
                        {false, #loss{label = gold, msg = Msg, err_code = ErrCode}} ->
                            role:send_buff_clean(),
                            {reply, {ErrCode, Msg}}; %% 确保只能是晶钻消耗失败
                        {false, #loss{msg = Msg}} ->
                            role:send_buff_clean(),
                            {reply, {0, Msg}} %% 确保只能是晶钻消耗失败，客户端弹窗消费
                    end
            end
    end;

%% 选择/取消阵法
handle(11510, {LineupId}, Role = #role{skill = #skill_all{lineup = LineupId}}) ->
    {ok, Role}; %% 已选择
handle(11510, {0}, Role = #role{skill = SA}) ->
    NewRole = Role#role{skill = SA#skill_all{lineup = 0}},
    team:update_lineup(NewRole),
    {reply, {?true, <<>>}, NewRole};
handle(11510, {LineupId}, Role = #role{skill = SA = #skill_all{skill_list = SL}}) ->
    case lists:keyfind(LineupId, #skill.id, SL) of
        false -> {ok};
        #skill{type = ?type_lineup} ->
            NewRole = Role#role{skill = SA#skill_all{lineup = LineupId}},
            team:update_lineup(NewRole),
            {reply, {?true, <<>>}, NewRole}
    end;
handle(11510, {_}, _) ->
    {ok};

%% 阵法更新信息
handle(11511, {}, #role{skill = #skill_all{lineup = LineupId}}) ->
    {reply, {LineupId}};

%% 快捷栏列表
handle(11540, {}, #role{skill = #skill_all{shortcuts = S}}) ->
    {reply, skill:pack_proto_msg(11540, S)};

%% 拖动技能快捷栏
handle(11541, {Index, 0}, Role = #role{link = #link{conn_pid = ConnPid},
        skill = SA = #skill_all{shortcuts = S}}) ->
    Ns = skill:change_shortcuts(S, Index, 0),
    sys_conn:pack_send(ConnPid, 11540, skill:pack_proto_msg(11540, Ns)),
    {ok, Role#role{skill = SA#skill_all{shortcuts = Ns}}};
handle(11541, {Index, SkillId}, Role = #role{link = #link{conn_pid = ConnPid},
        skill = SA = #skill_all{skill_list = L, shortcuts = S}})
when Index >= ?INDEX_MIN andalso Index =< ?INDEX_MAX ->
    case skill:has_skill(SkillId, [Skill || Skill = #skill{type = Type} <- L, Type =:= ?type_active]) of
        true -> %% 是主动技能或夫妻技能
            NewS1 = skill:del_shortcuts_id(S, SkillId),
            NewS2 = skill:change_shortcuts(NewS1, Index, SkillId),
            sys_conn:pack_send(ConnPid, 11540, skill:pack_proto_msg(11540, NewS2)),
            {ok, Role#role{skill = SA#skill_all{shortcuts = NewS2}}};
        false ->
            {reply, {0}}
    end;

%% 交换技能快捷栏
handle(11542, {Index1, Index2}, Role = #role{link = #link{conn_pid = ConnPid},
        skill = SA = #skill_all{shortcuts = S}}) ->
    SkillId1 = skill:get_shortcuts_skillid(S, Index1),
    SkillId2 = skill:get_shortcuts_skillid(S, Index2),
    NewS1 = skill:change_shortcuts(S, Index1, SkillId2),
    NewS2 = skill:change_shortcuts(NewS1, Index2, SkillId1),
    sys_conn:pack_send(ConnPid, 11540, skill:pack_proto_msg(11540, NewS2)),
    {ok, Role#role{skill = SA#skill_all{shortcuts = NewS2}}};

%% 职业进阶
handle(11560, {_AscendType}, #role{lev = Lev}) when Lev < 72 ->
    {reply, {?false, ?L(<<"等级不足72级，还无法获取仙灵之力进阶">>)}};
handle(11560, {_AscendType}, #role{status = Status}) when Status =/= ?status_normal ->
    {ok};
handle(11560, {AscendType}, Role = #role{career = Career, ascend = #ascend{direct = Directs}})
when AscendType =:= 1 orelse AscendType =:= 2 ->
    case achievement:check_career_step(Role) of
        true ->
            Now = util:unixtime(),
            case lists:keyfind(Career, 1, Directs) of
                {_, _, LastTime} when Now < (LastTime + 86400*7) ->
                    {reply, {?false, ?L(<<"距离你上次职业飞升还不够7天，请耐心等待。">>)}};
                {_, AscendType, _} ->
                    {reply, {?false, ?L(<<"您已经进阶过该方向">>)}};
                {_, OldAscendType, _} ->
                    LL = [#loss{label = gold, val = pay:price(skill_rpc, ascend, null), msg = ?L(<<"晶钻不足">>)}],
                    case role_gain:do(LL, Role) of
                        {false, #loss{err_code = ErrCode, msg = Msg}} ->
                            {reply, {ErrCode, Msg}};
                        {ok, Role1} ->
                            NewRole = ascend:career_ascend(AscendType, Role1),
                            notice:send(53, ascend:ascend_cast(Role, {OldAscendType, AscendType})),
                            notice:inform(<<"更换飞升方向~n消耗 1000晶钻">>),
                            {reply, {?true, ?L(<<"职业飞升成功，您已获得仙灵之力，快快尝试一下您的天赋能力吧。">>)}, NewRole}
                    end;
                false ->
                    LL = [#loss{label = coin_all, val = 3000000, msg = ?L(<<"金币不足">>)}],
                    case role_gain:do(LL, Role) of
                        {false, #loss{err_code = ErrCode, msg = Msg}} ->
                            {reply, {ErrCode, Msg}};
                        {ok, Role2} ->
                            NewRole = ascend:career_ascend(AscendType, Role2),
                            notice:send(53, ascend:ascend_cast(Role2, AscendType)),
                            notice:inform(<<"职业进阶飞升~n消耗 3000000金币">>),
                            log:log(log_coin, {<<"职业进阶">>, <<>>, Role, NewRole}),
                            {reply, {?true, ?L(<<"职业飞升成功，您已获得仙灵之力，快快尝试一下您的天赋能力吧。">>)}, NewRole}
                    end
            end;
        {false, Msg} ->
            {reply, {?false, Msg}}
    end;

handle(11561, {}, #role{career = Career, ascend = #ascend{direct = Directs}}) ->
    case lists:keyfind(Career, 1, Directs) of
        {_, AscendType, LastTime} ->
            {reply, {AscendType, LastTime}};
        _ ->
            {reply, {0, 0}}
    end;

%% 技能突破列表
handle(11562, {}, Role) ->
    skill:push_break_out(Role),
    {ok};

handle(_Cmd, _Args, _State) ->
    {error, unknow_command}.
