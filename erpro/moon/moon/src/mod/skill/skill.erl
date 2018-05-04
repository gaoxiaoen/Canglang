%% ***********************
%% 技能相关结构处理
%% @author wprehard@qq.com
%% ***********************
-module(skill).
-export([
        init/1
        ,ver_parse/1
        ,ver_parse_2/1
        ,calc/1
        ,study/2
        ,has_skill/2
        ,get_skill_name/1
        ,record2tuple/1
        ,tuple2record/1
        ,push_append_skill/2
        ,push_break_out/1
        ,update_achievement_data/2
        ,transfer_career/1
        ,get_combat_lineup/1       %% 战斗阵法
        ,get_combat_skill_list/1
        ,parse_combat_skill/2      %% 解析战斗上传的技能（附加装备洗练技能）
        ,convert_to_new_skill/2
        ,get_power_skill/2
        ,set_active_skill_0_to_1/1
        ,break_out/2
        %% 技能快捷栏
        ,get_shortcuts_skillid/2
        ,get_shortcuts_index/2
        ,change_shortcuts/3
        ,del_shortcuts_id/2
        ,clean_shortcuts_list/1
        ,is_set_shortcuts/1
        %% 职业进阶
        ,skill_ascend/2
        ,convert_polish_ascend_skill/2
        %% GM设技能等级
        ,gm_get/1
        ,gm_set_skill2/2
        ,gm_set_skill/2
        ,gm_break_out/1
        %% 消息打包
        ,pack_proto_msg/2
        ,calc_result_skill/1
        ,class_id/1
        ,which_career/1
    ]).
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("skill.hrl").
-include("combat.hrl").
-include("npc.hrl").
-include("team.hrl").
-include("attr.hrl").
%%
-include("ascend.hrl").
-include("soul_world.hrl").


%% @spec init_skill(Role) -> {SkillList, Shortcuts}.
%% @doc 创建角色时初始化技能数据: 技能列表和快捷栏列表
%% <div>注意：此函数要由角色进程调用</div>
init(Career) ->
    SkillList = [skill_data:get(Id) || Id <- get_init(Career)],
    %[ ?DUMP({Id, skill_data:get(Id)}) || Id <- get_init(Career)],
    #skill_all{
        skill_list = SkillList
        ,lineup = 0
        ,shortcuts = #skill_shortcuts{}
    }.

%% @spec ver_parse_2(Data) -> NewData
%% @doc 版本更新 -- 非角色本身数据转换：版本1中忽略了子项处理
ver_parse_2({skill_all, SkillList, Lineup, Shortcuts}) ->
    ver_parse_2({skill_all, 1, SkillList, Lineup, Shortcuts});
ver_parse_2({skill_all, Ver = 1, SkillList, Lineup, Shortcuts}) ->
    ver_parse_2({skill_all, Ver + 1, SkillList, Lineup, Shortcuts});
ver_parse_2({skill_all, Ver = 2, SkillList, Lineup, Shortcuts}) ->
    ver_parse_2({skill_all, Ver + 1, SkillList, Lineup, Shortcuts, []});
ver_parse_2({skill_all, Ver = 3, SkillList, Lineup, Shortcuts, Breaks}) ->
    ver_parse_2({skill_all, Ver + 1, SkillList, Lineup, Shortcuts, Breaks});
ver_parse_2(SkillAll = #skill_all{ver = ?VER_SKILL}) ->
    SkillAll.

%% @spec ver_parse(Data) -> NewData
%% @doc 版本更新
ver_parse({skill_all, SkillList, Lineup, Shortcuts}) ->
    %% 根据回风流雪的技能来判断职业，要求技能表填表注意，不能有别的id_type=0的技能出现
    Career = case lists:keyfind(0, #skill.id_type, SkillList) of
        false -> ?career_xinshou;
        #skill{id = Sid} -> (Sid div 10000)
    end,
    %% 怒气技能增加 2012/03/23
    NewSkillList1 = case lists:keyfind(?type_nuqi, #skill.type, SkillList) of
        false ->
            IdList1 = if
                Career =:= ?career_zhenwu -> ?nuqi_zhenwu;
                Career =:= ?career_cike -> ?nuqi_cike;
                Career =:= ?career_xianzhe -> ?nuqi_xianzhe;
                Career =:= ?career_feiyu -> ?nuqi_feiyu;
                Career =:= ?career_qishi -> ?nuqi_qishi;
                true -> ?nuqi_xinshou
            end,
            NuqiList = [skill_data:get(Id) || Id <- IdList1],
            SkillList ++ NuqiList;
        _ -> SkillList
    end,
    %% 怒气天赋技能 2012/04/12
    NewSkillList2 = case lists:keyfind(?type_nuqi_passive, #skill.type, NewSkillList1) of
        false ->
            IdList2 = if
                Career =:= ?career_zhenwu -> ?nuqi_passive_zhenwu;
                Career =:= ?career_cike -> ?nuqi_passive_cike;
                Career =:= ?career_xianzhe -> ?nuqi_passive_xianzhe;
                Career =:= ?career_feiyu -> ?nuqi_passive_feiyu;
                Career =:= ?career_qishi -> ?nuqi_passive_qishi;
                true -> ?nuqi_passive_xinshou
            end,
            NuqiPassList = [skill_data:get(Id) || Id <- IdList2],
            NewSkillList1 ++ NuqiPassList;
        _ -> NewSkillList1
   end,
   %% 65级技能 2012/07/06
   NewSkillList = case lists:keyfind(19, #skill.id_type, NewSkillList2) of
       false ->
           IdList3 = if
               Career =:= ?career_zhenwu -> [11900];
               Career =:= ?career_cike -> [21900];
               Career =:= ?career_xianzhe -> [31900];
               Career =:= ?career_feiyu -> [41900];
               Career =:= ?career_qishi -> [51900];
               true -> []
           end,
           S65List = [skill_data:get(Id) || Id <- IdList3],
           NewSkillList2 ++ S65List;
       _ -> NewSkillList2
   end,
   ver_parse({skill_all, 1, NewSkillList, Lineup, Shortcuts});
%% 70级技能 2013/04/07
ver_parse({skill_all, Ver = 1, SkillList, Lineup, Shortcuts}) ->
    %% 根据回风流雪的技能来判断职业，要求技能表填表注意，不能有别的id_type=0的技能出现
    Career = case lists:keyfind(0, #skill.id_type, SkillList) of
        false -> ?career_xinshou;
        #skill{id = Sid} -> (Sid div 10000)
    end,
   NewSkillList = case lists:keyfind(65, #skill.id_type, SkillList) of
       false ->
           IdList3 = if
               Career =:= ?career_zhenwu -> [16500];
               Career =:= ?career_cike -> [26500];
               Career =:= ?career_xianzhe -> [36500];
               Career =:= ?career_feiyu -> [46500];
               Career =:= ?career_qishi -> [56500];
               true -> []
           end,
           S70List = [skill_data:get(Id) || Id <- IdList3],
           SkillList ++ S70List;
       _ -> SkillList
   end,
   ver_parse({skill_all, Ver + 1, NewSkillList, Lineup, Shortcuts});
%% 技能突破丹
ver_parse({skill_all, Ver = 2, SkillList, Lineup, Shortcuts}) ->
    ver_parse({skill_all, Ver + 1, SkillList, Lineup, Shortcuts, []});

%% 遗忘抵抗技能
ver_parse({skill_all, Ver = 3, SkillList, Lineup, Shortcuts, Breaks}) ->
    %% 根据回风流雪的技能来判断职业，要求技能表填表注意，不能有别的id_type=0的技能出现
    Career = case lists:keyfind(0, #skill.id_type, SkillList) of
        false -> ?career_xinshou;
        #skill{id = Sid} -> (Sid div 10000)
    end,
   NewSkillList = case lists:keyfind(28, #skill.id_type, SkillList) of
       false ->
           IdList3 = if
               Career =:= ?career_zhenwu -> [12800];
               Career =:= ?career_cike -> [22800];
               Career =:= ?career_xianzhe -> [32800];
               Career =:= ?career_feiyu -> [42800];
               Career =:= ?career_qishi -> [52800];
               true -> []
           end,
           S70List = [skill_data:get(Id) || Id <- IdList3],
           SkillList ++ S70List;
       _ -> SkillList
   end,
   ver_parse({skill_all, Ver + 1, NewSkillList, Lineup, Shortcuts, Breaks});
ver_parse(SkillAll = #skill_all{ver = ?VER_SKILL}) ->
    SkillAll.

%% @spec calc_attr(Role) -> NewRole
%% @doc 计算被动技能的属性
calc(Role = #role{career = Career, skill = #skill_all{skill_list = L}}) ->
    SkillList = case eqm_api:find_skill_attr(Role) of
        [] -> L;
        TypeList ->
            NewTypeList = [{(Type rem 100), Num} || {Type, Num} <- TypeList, (Type div 100) =:= Career],
            do_change_append_skill(L, NewTypeList)
    end,
    Role1 = do_calc_skill_fighting(SkillList, Role),
    do_calc(SkillList, Role1).
do_calc([], Role) -> Role;
do_calc([#skill{type = ?type_passive, lev = Lev, attr = Attr} | T], Role) when Lev > 0 ->
    case role_attr:do_attr(Attr, Role) of
        {false, _} ->
            ?DEBUG("技能属性计算遇到错误"),
            do_calc(T, Role);
        {ok, NewRole} -> do_calc(T, NewRole)
    end;
do_calc([_ | T], Role) ->
    do_calc(T, Role).
%% 计算技能战斗力附加
do_calc_skill_fighting([], Role) -> Role;
do_calc_skill_fighting([#skill{id = Id, lev = Lev} | T], Role = #role{attr = Attr = #attr{fight_capacity = FC}})
when Lev > 0 ->
    CareerType = Id div 100,
    do_calc_skill_fighting(T, Role#role{attr = Attr#attr{fight_capacity = FC + skill_factor_data:get_factor(CareerType, Lev)}});
do_calc_skill_fighting([_ | T], Role) ->
    do_calc_skill_fighting(T, Role).

%% @spec send_achievement_data(Role, AppendList) -> NewRole
%% @doc 根据装备的洗练技能加级属性，更新全服成就榜数据（第一个达到13阶技能的玩家）
update_achievement_data(Role = #role{skill = #skill_all{skill_list = L}}, AppendList) ->
    NewList = do_change_append_skill(L, AppendList),
    send_achievement_data(Role, NewList).

%% @spec study(SkillList, Role) -> {ok, NewRole} | {ok, Msg, NewRole} | {false, Reason}
%% SkillId = integer() | list() 指定要学习/升阶/吃书的：技能ID 或者 技能ID列表
%% Role = #role{}
%% Msg = Reason = bitstring() 返回消息
%% @doc 学习或升级某技能；由角色进程调用
study(SkillId, Role = #role{skill = #skill_all{skill_list = SkillList}}) ->
    case lists:keyfind(SkillId, #skill.id, SkillList) of
        false -> {false, ?MSGID(<<"当前职业无法学习或者升阶">>)};
        #skill{next_id = 0} -> {false, ?MSGID(<<"此技能已经升阶到最高等级">>)};
        Skill ->
            case skill_data:get(SkillId) of
                #skill{lev = SkillLev} when SkillLev =:= 0 ->
                    do_study(Skill, Role); %% 学习
                #skill{} ->
                    do_study(Skill, Role); %% 升阶
                _ -> {false, ?MSGID(<<"操作失败">>)}
            end
    end.

%% 学习或升级技能
do_study(#skill{id = SkillId, next_id = NextId, type = Type},
    Role = #role{lev = Lev, link = #link{conn_pid = ConnPid}, skill = SA = #skill_all{skill_list = SkillList, lineup = LineupId, shortcuts = Shortcuts}}) ->
    case skill_data:get(NextId) of
        #skill{cond_lev = CondLev} when Lev < CondLev ->
            log:log_rollback(log_item_del_loss),
            role:send_buff_clean(),
            {false, ?MSGID(<<"等级不够">>)};
        NextSkill = #skill{id = NewId, name = _NewName, lev = Grade, cost_att = CostAtt, cost_coin = CostCoin, cost_item = CostItem, item_id= ItemId} ->
            LossList = case ItemId =:= 0 orelse CostItem =:= 0 of
                true -> 
                    [#loss{label = attainment, val = CostAtt, msg = ?MSGID(<<"技能点不足">>)},
                     #loss{label = coin_all, val = CostCoin, msg = ?MSGID(<<"金币不足">>)}];
                false ->
                    NeedItemMsg = case ItemId of
                        ?skill_book_frag -> ?MSGID(<<"技能残卷不足">>);
                        _ -> ?MSGID(<<"缺少技能书">>)
                    end,
                    [#loss{label = attainment, val = CostAtt, msg = ?MSGID(<<"技能点不足">>)},
                     #loss{label = item, val = [ItemId, 0, CostItem], msg = NeedItemMsg},
                     #loss{label = coin_all, val = CostCoin, msg = ?MSGID(<<"金币不足">>)}]
            end,
            %% 70级技能判断
            Study70Msg = check_70_skill(NextSkill, Role),
            case role_gain:do(LossList, Role) of
                _ when Study70Msg =/= true ->
                    {false, Study70Msg};
                {false, #loss{label = coin_all, msg = Msg, err_code = ErrCode}} ->
                    log:log_rollback(log_item_del_loss),
                    role:send_buff_clean(),
                    {false, {ErrCode, Msg}};
                {false, #loss{msg = Msg}} ->
                    log:log_rollback(log_item_del_loss),
                    role:send_buff_clean(),
                    {false, Msg};
                {ok, NewRole} -> %% 物品损益需要处理
                    role:send_buff_flush(),
                    log:log(log_item_del_loss, {<<"技能升阶">>, NewRole}),
                    log:log(log_coin, {<<"技能升阶">>, util:fbin(<<"优先绑定，共~w">>, [CostCoin]), Role, NewRole}),
                    log:log(log_attainment, {<<"技能升阶">>, <<>>, Role, NewRole}),
                    NewSL = lists:keyreplace(SkillId, #skill.id, SkillList, NextSkill),
                    sys_conn:pack_send(ConnPid, 11501, {NewId}),
                    NewRole1 = case Type =:= ?type_lineup of
                        true -> %% 阵法更新
                            NewRole0 = case SkillId =:= LineupId of
                                true -> NewRole#role{skill = SA#skill_all{skill_list = NewSL, lineup = NewId}};
                                false -> NewRole#role{skill = SA#skill_all{skill_list = NewSL}}
                            end,
                            team:update_lineup(NewRole0),
                            NewRole00 = role_listener:special_event(NewRole0, {20010, update}), %%阵法等级改变
                            NewRole00;
                        false ->
                            NR = case Type =:= ?type_passive of
                                true -> %% 被动技能属性计算
                                    NewRole#role{skill = SA#skill_all{skill_list = NewSL}};
                                false -> %% 主动技能
                                    %% 修改快捷栏，并通知
                                    NewShort = case skill:get_shortcuts_index(Shortcuts, SkillId) of
                                        0 -> Shortcuts;
                                        Index ->
                                            TmpShort = skill:change_shortcuts(Shortcuts, Index, NextId),
                                            sys_conn:pack_send(ConnPid, 11540, pack_proto_msg(11540, TmpShort)),
                                            TmpShort
                                    end,
                                    NewRole00 = setting:update_auto_skill(SkillId, NextId, NewRole),
                                    %% 更新战场自动战斗技能
                                    NewRole0 = combat:last_skill_update(NewRole00, SkillId, NewId),
                                    NewRole0#role{skill = SA#skill_all{skill_list = NewSL, shortcuts = NewShort}}
                            end,
                            role_listener:special_event(NR, {20013, update}) %%技能等级改变
                    end,
                    % notice:inform(util:fbin(?L(<<"技能学习升阶\n消耗 ~w金币">>), [CostCoin])),
                    NewRole2 = role_api:push_attr(NewRole1),
                    rank:listener(skill, NewRole2), %% 通知排行榜
                    NewRole3 = role_listener:special_event(NewRole2, {1019, finish}),
                    send_achievement_data(NewRole3), %% 更新全服成就榜
                    %% ?DEBUG("更新后的技能列表:~w", [NewRole1#role.skill#skill_all.skill_list]),
                    NewRole4 = case Grade of
                        1 ->
                            ?DEBUG("新学习的技能ID ~w", [SkillId]),
                            role_listener:special_event(NewRole3, {1061, SkillId});  %% 特殊任务: 学习技能
                        _ -> NewRole3
                    end,
                    NewRole5 = medal:listener(skill, NewRole4),
                    
                    random_award:skill(NewRole5, NewId rem 100),
                    random_award:skill_learn(NewRole5, NewId div 100, NewId rem 100),

                    {ok, NewRole5}
            end;
        _ ->
            role:send_buff_clean(),
            {false, ?MSGID(<<"操作失败">>)}
    end.

%% @spec transfer_career(Career, Role) -> {ok, NewRole} | error
%% @doc 转职切换技能列表, 返回转换后的技能列表; 由角色进程调用
%% <div>保留已学习技能的等级，赋予新职业的序号和职业标志</div>
transfer_career(Role = #role{career = Career, link = #link{conn_pid = ConnPid},
        skill = SA = #skill_all{skill_list = _OldList, shortcuts = Shortcuts}}) ->
    List = [skill_data:get(Id) || Id <- get_init(Career)],
    %% NewList = do_transfer_career(OldList, List),
    NewList = List,
    NewShort = do_transfer_career_shortcuts(Career, Shortcuts),
    sys_conn:pack_send(ConnPid, 11540, pack_proto_msg(11540, NewShort)),%% 清空并推送技能快捷栏
    sys_conn:pack_send(ConnPid, 11500, pack_proto_msg(11500, NewList)), %% 推送新的技能列表
    Role#role{skill = SA#skill_all{skill_list = NewList, shortcuts = NewShort}}.

%% @spec get_combat_lineup(Role) -> LineupId
%% LineupId = integer() 阵法ID，0:表示忽略不计算
%% Role = #role{}
%% @doc 根据战斗发起的角色的队伍数据，直接加载阵法ID至战场
get_combat_lineup(#role{name = _Name, team_pid = TeamPid, team = #role_team{follow = ?true, is_leader = ?true}, skill = #skill_all{lineup = LineupId}}) 
when is_pid(TeamPid) -> LineupId;
get_combat_lineup(_) -> 0.

%% @spec get_combat_skill_list(Fighter) -> SkillMappingList::list() | NpcSkillIdList:list()
%% Fighter = #role{} | #npc{}
%% MappingList = [{SkillId, AppendedId} | ...]
%% @doc 获取进入战斗时的技能,包括装备强化后的技能加等级的映射信息，返回 技能ID的映射列表
%% <div>
%% 1、由角色进程或npc进程调用
%% 2、战斗进程提取映射信息保存, 推送加等级后的AppendedId列表
%% </div>
get_combat_skill_list(Role = #role{career = Career, skill = #skill_all{skill_list = SkillList, break_out = Breaks}}) ->
    Fun = fun(Lev, _, Type) when Lev =< 0 orelse Type =:= ?type_lineup ->
            false;
        (_, _IdType, Type) when Type =:= ?type_passive ->
            %lists:member(IdType, get_filter(Career));   %% qingxuan 2013/10/18 为什么要过滤？
            true;
        (_, _, _) -> %% 主动技能、辅助技能、怒气技能、夫妻技能
            true
    end,
    Fun1 = fun(Id, _, []) ->
            {Id, Id};
        (Id, IdType, NewList) ->
            case lists:keyfind(IdType, 1, NewList) of
                {_, AppendNum} -> {Id, Id + AppendNum};
                _ -> {Id, Id}
            end
    end,
    %% 技能突破丹效果
    Fun2 = fun({Type, Num}, LL) when Type div 100 =:= Career ->
            Type1 = Type rem 100,
            case lists:keyfind(Type1, 1, LL) of
                {Type1, Num1} -> lists:keyreplace(Type1, 1, LL, {Type1, Num1 + Num});
                _ -> [{Type1, Num} | LL]
            end;
        (_, LL) ->
            LL
    end,
    Breaks1 = convert_polish_ascend_skill(Role, Breaks),
    Ldebug = case eqm_api:find_skill_attr(Role) of
        [] ->
            TypeList = lists:foldl(Fun2, [], Breaks1),
            NewList = [Fun1(Id, IdType, TypeList) || #skill{id = Id, lev = Lev, id_type = IdType, type = Type} <- SkillList, Fun(Lev, IdType, Type)],
            [{Id, AId div 100 * 100 + min(AId rem 100, 13)} || {Id, AId} <- NewList];
        TypeList ->
            %% TODO:附加技能必须是职业对应的主动技能，否则会有问题
            NewList1 = [{(Type rem 100), Num} || {Type, Num} <- TypeList, (Type div 100) =:= Career],
            NewList = lists:foldl(Fun2, NewList1, Breaks1),
            NewList2 = [Fun1(Id, IdType, NewList) || #skill{id = Id, lev = Lev, id_type = IdType, type = Type} <- SkillList, Fun(Lev, IdType, Type)],
            %% 技能突破丹后要确保技能没有超过13阶
            [{Id, AId div 100 * 100 + min(AId rem 100, 13)} || {Id, AId} <- NewList2]
    end,
    %% ?DEBUG("角色进战场前获取战斗技能ID列表:~w", [Ldebug]),
    Ldebug;
get_combat_skill_list(#npc{base_id = BaseId}) ->
    case npc_data:get(BaseId) of
        false -> [];
        {ok, #npc_base{skill = L}} -> L
    end.

%% @spec parse_combat_skill(Id, CombatList) -> NewSkillId
%% @doc 解析战斗技能，用于验证玩家出招技能并附加装备洗练加技能的效果
parse_combat_skill(Id, []) -> Id;
parse_combat_skill(Id, [{Id, AppendedId} | _]) -> AppendedId;
parse_combat_skill(Id, [{_, Id} | _]) -> Id;
parse_combat_skill(Id, [_ | T]) -> 
    parse_combat_skill(Id, T).

%% 转换Base数据值技能存储数据
%% 返回#skill{}
convert_to_new_skill(BaseId, #skill{skilled = Skilled}) ->
    case skill_data:get(BaseId) of
        NewSkill when is_record(NewSkill, skill) -> NewSkill#skill{skilled = Skilled};
        _ -> false
    end.

%% 根据等级获取对应天威技能
get_power_skill(SkillId, AbleLev) ->
    case skill_data:get(SkillId) of
        #skill{lev = Lev} when Lev > AbleLev ->
            get_power_skill(SkillId - 1, AbleLev);
        #skill{} ->
           combat_data_skill:get(SkillId);
        _ ->
            none
    end.

%% @spec push_append_skill(ConnPid, List) -> any()
%% @doc 推送 装备附加技能等级的效果
push_append_skill(ConnPid, List) when is_list(List) ->
    %% ?DEBUG("推送加等级列表：~w", [List]),
    sys_conn:pack_send(ConnPid, 11504, {List});
push_append_skill(_, _) -> ignore.

%% @spec push_break_out(Role::#role{}) -> any()
%% @doc 推送职业突破效果
push_break_out(Role = #role{skill = #skill_all{break_out = Breaks}, link = #link{conn_pid = ConnPid}, career = Career}) ->
    NewList1 = convert_polish_ascend_skill(Role, Breaks),
    NewList = [{(Type rem 100), Num} || {Type, Num} <- NewList1, (Type div 100) =:= Career],%% 过滤非本职业的附加技能
    sys_conn:pack_send(ConnPid, 11562, {NewList}).

%% @spec convert_polish_ascend_skill(Role, List) -> NewList
%% @doc 洗练技能附加信息 转换为 进阶后的技能类型
convert_polish_ascend_skill(#role{ascend = undefined}, L) ->
    L;
convert_polish_ascend_skill(#role{ascend = #ascend{direct = []}}, L) ->
    L;
convert_polish_ascend_skill(#role{career = Career, ascend = #ascend{direct = Directs}}, L) ->
    case lists:keyfind(Career, 1, Directs) of
        false -> L;
        {Career, AscendType, _} ->
            lists:map(fun({Type, Num})  ->
                        NewType = get_skill_ascend_type(AscendType, Type),
                        {NewType, Num}
                end, L)
    end.

%% @spec skill_ascend(AscendType, SkillList) -> NewList
%% @doc (职业进阶)技能升阶方向
skill_ascend(AscendType, SkillList) when is_list(SkillList) ->
    Fun = fun(S = #skill{type = Type}) when Type =:= ?type_active orelse Type =:= ?type_passive ->
            do_skill_ascend(AscendType, S);
        (S) -> S
    end,
    lists:map(Fun, SkillList).

do_skill_ascend(AscendType, S = #skill{skilled = Skilled, id = SkillId}) ->
    CareerType = SkillId div 100,
    Slev = SkillId rem 100,
    NewCareerType = get_skill_ascend_type(AscendType, CareerType),
    NewSkillId = NewCareerType*100 + Slev,
    case skill_data:get(NewSkillId) of
        NewS = #skill{} -> NewS#skill{skilled = Skilled};
        _ -> S
    end.


get_skill_ascend_type(#role{ascend = undefined}, Type) ->
    Type;
get_skill_ascend_type(#role{ascend = #ascend{direct = []}}, Type) ->
    Type;
get_skill_ascend_type(#role{career = Career, ascend = #ascend{direct = Directs}}, Type) ->
    case lists:keyfind(Career, 1, Directs) of
        false -> Type;
        {Career, AscendType, _} ->
            get_skill_ascend_type(AscendType, Type)
    end;

%% 根据进阶方向和当前职业ID类型获取进阶后的职业ID类型
%% 注意：同一个进阶方向需要2组转换数据
%% 表转换：=CONCATENATE("get_skill_ascend_type(",B2,", ",C2,") -> ",D2,";")
get_skill_ascend_type(1, 102) -> 150;
get_skill_ascend_type(1, 103) -> 151;
get_skill_ascend_type(1, 105) -> 152;
get_skill_ascend_type(1, 106) -> 153;
get_skill_ascend_type(1, 107) -> 154;
get_skill_ascend_type(1, 160) -> 152;
get_skill_ascend_type(1, 161) -> 109;
get_skill_ascend_type(1, 162) -> 111;
get_skill_ascend_type(1, 163) -> 112;
get_skill_ascend_type(1, 164) -> 113;
get_skill_ascend_type(2, 150) -> 102;
get_skill_ascend_type(2, 151) -> 103;
get_skill_ascend_type(2, 152) -> 160;
get_skill_ascend_type(2, 153) -> 106;
get_skill_ascend_type(2, 154) -> 107;
get_skill_ascend_type(2, 105) -> 160;
get_skill_ascend_type(2, 109) -> 161;
get_skill_ascend_type(2, 111) -> 162;
get_skill_ascend_type(2, 112) -> 163;
get_skill_ascend_type(2, 113) -> 164;
get_skill_ascend_type(1, 205) -> 250;
get_skill_ascend_type(1, 206) -> 251;
get_skill_ascend_type(1, 209) -> 252;
get_skill_ascend_type(1, 210) -> 253;
get_skill_ascend_type(1, 213) -> 254;
get_skill_ascend_type(1, 260) -> 250;
get_skill_ascend_type(1, 261) -> 207;
get_skill_ascend_type(1, 262) -> 211;
get_skill_ascend_type(1, 263) -> 212;
get_skill_ascend_type(1, 264) -> 219;
get_skill_ascend_type(2, 250) -> 260;
get_skill_ascend_type(2, 251) -> 206;
get_skill_ascend_type(2, 252) -> 209;
get_skill_ascend_type(2, 253) -> 210;
get_skill_ascend_type(2, 254) -> 213;
get_skill_ascend_type(2, 205) -> 260;
get_skill_ascend_type(2, 207) -> 261;
get_skill_ascend_type(2, 211) -> 262;
get_skill_ascend_type(2, 212) -> 263;
get_skill_ascend_type(2, 219) -> 264;
get_skill_ascend_type(1, 303) -> 350;
get_skill_ascend_type(1, 306) -> 351;
get_skill_ascend_type(1, 307) -> 352;
get_skill_ascend_type(1, 308) -> 353;
get_skill_ascend_type(1, 310) -> 354;
get_skill_ascend_type(1, 360) -> 302;
get_skill_ascend_type(1, 361) -> 304;
get_skill_ascend_type(1, 362) -> 312;
get_skill_ascend_type(1, 363) -> 313;
get_skill_ascend_type(1, 364) -> 319;
get_skill_ascend_type(2, 350) -> 303;
get_skill_ascend_type(2, 351) -> 306;
get_skill_ascend_type(2, 352) -> 307;
get_skill_ascend_type(2, 353) -> 308;
get_skill_ascend_type(2, 354) -> 310;
get_skill_ascend_type(2, 302) -> 360;
get_skill_ascend_type(2, 304) -> 361;
get_skill_ascend_type(2, 312) -> 362;
get_skill_ascend_type(2, 313) -> 363;
get_skill_ascend_type(2, 319) -> 364;
get_skill_ascend_type(1, 404) -> 450;
get_skill_ascend_type(1, 407) -> 451;
get_skill_ascend_type(1, 410) -> 452;
get_skill_ascend_type(1, 412) -> 453;
get_skill_ascend_type(1, 413) -> 454;
get_skill_ascend_type(1, 460) -> 402;
get_skill_ascend_type(1, 461) -> 405;
get_skill_ascend_type(1, 462) -> 408;
get_skill_ascend_type(1, 463) -> 409;
get_skill_ascend_type(1, 464) -> 411;
get_skill_ascend_type(2, 450) -> 404;
get_skill_ascend_type(2, 451) -> 407;
get_skill_ascend_type(2, 452) -> 410;
get_skill_ascend_type(2, 453) -> 412;
get_skill_ascend_type(2, 454) -> 413;
get_skill_ascend_type(2, 402) -> 460;
get_skill_ascend_type(2, 405) -> 461;
get_skill_ascend_type(2, 408) -> 462;
get_skill_ascend_type(2, 409) -> 463;
get_skill_ascend_type(2, 411) -> 464;
get_skill_ascend_type(1, 502) -> 550;
get_skill_ascend_type(1, 505) -> 551;
get_skill_ascend_type(1, 509) -> 552;
get_skill_ascend_type(1, 504) -> 553;
get_skill_ascend_type(1, 511) -> 554;
get_skill_ascend_type(1, 560) -> 503;
get_skill_ascend_type(1, 561) -> 510;
get_skill_ascend_type(1, 562) -> 512;
get_skill_ascend_type(1, 563) -> 513;
get_skill_ascend_type(1, 564) -> 519;
get_skill_ascend_type(2, 550) -> 502;
get_skill_ascend_type(2, 551) -> 505;
get_skill_ascend_type(2, 552) -> 509;
get_skill_ascend_type(2, 553) -> 504;
get_skill_ascend_type(2, 554) -> 511;
get_skill_ascend_type(2, 503) -> 560;
get_skill_ascend_type(2, 510) -> 561;
get_skill_ascend_type(2, 512) -> 562;
get_skill_ascend_type(2, 513) -> 563;
get_skill_ascend_type(2, 519) -> 564;
get_skill_ascend_type(_, CareerType) -> CareerType.

%% @spec get_shortcuts_skillid(ShortList, Index) -> SkillId:integer()
%% @doc 根据index编号获取技能ID
get_shortcuts_skillid(#skill_shortcuts{index_1 = SkillId}, 1) -> SkillId;
get_shortcuts_skillid(#skill_shortcuts{index_2 = SkillId}, 2) -> SkillId;
get_shortcuts_skillid(#skill_shortcuts{index_3 = SkillId}, 3) -> SkillId;
get_shortcuts_skillid(#skill_shortcuts{index_4 = SkillId}, 4) -> SkillId;
get_shortcuts_skillid(#skill_shortcuts{index_5 = SkillId}, 5) -> SkillId;
get_shortcuts_skillid(#skill_shortcuts{index_6 = SkillId}, 6) -> SkillId;
get_shortcuts_skillid(#skill_shortcuts{index_7 = SkillId}, 7) -> SkillId;
get_shortcuts_skillid(#skill_shortcuts{index_8 = SkillId}, 8) -> SkillId;
get_shortcuts_skillid(#skill_shortcuts{index_9 = SkillId}, 9) -> SkillId;
get_shortcuts_skillid(#skill_shortcuts{index_10 = SkillId}, 10) -> SkillId;
get_shortcuts_skillid(_, _) -> 0.

%% @spec get_shortcuts_index(ShortList, SkillId) -> Index:integer()
%% @doc 获取当前技能ID所在的快捷栏编号，若没有则返回0
get_shortcuts_index(#skill_shortcuts{index_1 = SkillId}, SkillId) -> 1;
get_shortcuts_index(#skill_shortcuts{index_2 = SkillId}, SkillId) -> 2;
get_shortcuts_index(#skill_shortcuts{index_3 = SkillId}, SkillId) -> 3;
get_shortcuts_index(#skill_shortcuts{index_4 = SkillId}, SkillId) -> 4;
get_shortcuts_index(#skill_shortcuts{index_5 = SkillId}, SkillId) -> 5;
get_shortcuts_index(#skill_shortcuts{index_6 = SkillId}, SkillId) -> 6;
get_shortcuts_index(#skill_shortcuts{index_7 = SkillId}, SkillId) -> 7;
get_shortcuts_index(#skill_shortcuts{index_8 = SkillId}, SkillId) -> 8;
get_shortcuts_index(#skill_shortcuts{index_9 = SkillId}, SkillId) -> 9;
get_shortcuts_index(#skill_shortcuts{index_10 = SkillId}, SkillId) -> 10;
get_shortcuts_index(_, _SkillId) -> 0.

%% @spec is_set_shortcuts(Shortcutlist) -> ?false | ?true
%% @doc 判断是否设置了挂机技能
is_set_shortcuts(#skill_shortcuts{index_1 = 0, index_2 = 0, index_3 = 0, index_4 = 0, index_5 = 0, index_6 = 0, index_7 = 0, index_8 = 0, index_9 = 0, index_10 = 0}) -> ?false;
is_set_shortcuts(_SkillShortCuts) -> ?true.

%% @spec del_shortcuts_id(ShortList, SkillId) -> ok
%% @doc 删除快捷栏中所有SkillId的记录
del_shortcuts_id(S, SkillId) ->
    case get_shortcuts_index(S, SkillId) of
        0 -> S;
        Index ->
            NewS = change_shortcuts(S, Index, 0),
            del_shortcuts_id(NewS, SkillId)
    end.

%% @spec change_shortcuts(ShortList, Index, SkillId) -> NewList
%% @doc 替换快捷栏列表中的某一个
change_shortcuts(ShortcutList, 1, SkillId) ->
    ShortcutList#skill_shortcuts{index_1 = SkillId};
change_shortcuts(ShortcutList, 2, SkillId) ->
    ShortcutList#skill_shortcuts{index_2 = SkillId};
change_shortcuts(ShortcutList, 3, SkillId) ->
    ShortcutList#skill_shortcuts{index_3 = SkillId};
change_shortcuts(ShortcutList, 4, SkillId) ->
    ShortcutList#skill_shortcuts{index_4 = SkillId};
change_shortcuts(ShortcutList, 5, SkillId) ->
    ShortcutList#skill_shortcuts{index_5 = SkillId};
change_shortcuts(ShortcutList, 6, SkillId) ->
    ShortcutList#skill_shortcuts{index_6 = SkillId};
change_shortcuts(ShortcutList, 7, SkillId) ->
    ShortcutList#skill_shortcuts{index_7 = SkillId};
change_shortcuts(ShortcutList, 8, SkillId) ->
    ShortcutList#skill_shortcuts{index_8 = SkillId};
change_shortcuts(ShortcutList, 9, SkillId) ->
    ShortcutList#skill_shortcuts{index_9 = SkillId};
change_shortcuts(ShortcutList, 10, SkillId) ->
    ShortcutList#skill_shortcuts{index_10 = SkillId};
change_shortcuts(ShortcutList, _Index, _SkillId) ->
    ShortcutList.

%% @spec clean_shortcuts_list(Role) -> NewRole
%% @doc 清空角色技能快捷栏
clean_shortcuts_list(Role = #role{link = #link{conn_pid = ConnPid}, skill = SA = #skill_all{shortcuts = _S}}) ->
    NewS = #skill_shortcuts{},
    sys_conn:pack_send(ConnPid, 11540, skill:pack_proto_msg(11540, NewS)),
    Role#role{skill = SA#skill_all{shortcuts = NewS}};
clean_shortcuts_list(SA = #skill_all{shortcuts = _S}) ->
    SA#skill_all{shortcuts = #skill_shortcuts{}}.

%% @spec has_skill(SkillId) -> true | false
%% @doc 判断当前角色是否已学习此技能
has_skill(SkillId, SkillList) ->
    case lists:keyfind(SkillId, #skill.id, SkillList) of
        false -> false;
        #skill{id = SkillId, lev = 0} -> false;
        #skill{id = SkillId} -> true
    end.

%% @spec get_skill_name(SkillId) -> true | false
%% @doc 判断当前角色是否已学习此技能
get_skill_name(SkillId) ->
    case skill_data:get(SkillId) of
        #skill{name = Name} -> Name;
        _ -> <<>> 
    end.

%% @spec record2list(Skill) -> list()
%% @doc 快捷栏列表转换
record2tuple(#skill_shortcuts{
        index_1= Index1, index_2 = Index2, index_3 = Index3, index_4 = Index4, 
        index_5 = Index5, index_6 = Index6, index_7 = Index7, index_8 = Index8,
        index_9 = Index9, index_10 = Index10}) ->
    {Index1, Index2, Index3, Index4, Index5, Index6, Index7, Index8, Index9, Index10}.

%% @spec record2list(Skill) -> list()
%% @doc 快捷栏列表转换
tuple2record({Index1, Index2, Index3, Index4, Index5, Index6, Index7, Index8, Index9, Index10}) ->
    #skill_shortcuts{
        index_1= Index1, index_2 = Index2, index_3 = Index3, index_4 = Index4, 
        index_5 = Index5, index_6 = Index6, index_7 = Index7, index_8 = Index8,
        index_9 = Index9, index_10 = Index10}.

%% @spec pack_proto_msg(Cmd, Val) -> Msg
%% @doc 打包函数
pack_proto_msg(11500, SkillList) ->
    {[{Id} || #skill{id = Id, skilled = _Skilled} <- SkillList, which_career(Id)=/=?career_none]};
pack_proto_msg(11505, List) -> %% 刷新技能熟练度
    {List};
pack_proto_msg(11540, Shortcuts) ->
    record2tuple(Shortcuts);
pack_proto_msg(_, _) ->
    ?DEBUG("协议打包参数错误"),
    {}.

%% @spec gm_set_skill(Role, Grade) -> NewRole
%% @doc 设技能等级( 变身命令 )
gm_set_skill(Role = #role{skill = SA = #skill_all{skill_list = SkillList, shortcuts = Shortcuts},
        link = #link{conn_pid = ConnPid}}, L) ->
    NewList = do_gm_set_skill(L, SkillList),
    %% ?DEBUG("GM设技能前技能列表：~w~n设完后：~w~n", [SkillList, NewList]),
    sys_conn:pack_send(ConnPid, 11500, pack_proto_msg(11500, NewList)),
    NewShort = do_gm_set_short(SkillList, NewList, Shortcuts),
    sys_conn:pack_send(ConnPid, 11540, pack_proto_msg(11540, NewShort)),%% 修改快捷栏，并通知
    Role#role{skill = SA#skill_all{skill_list = NewList, shortcuts = NewShort}}.
%% @doc 设技能等级( 学技能命令 )
gm_set_skill2(Role = #role{skill = SA = #skill_all{skill_list = SkillList, shortcuts = Shortcuts},
        link = #link{conn_pid = ConnPid}}, N) ->
    %TmpLev1 = case N > 7 of true -> 7; false -> N end,
    TmpLev2 = case N > 10 of true -> 10; false -> N end,
    TmpList1 = [skill_data:get(((Id div 100) * 100 + N)) || #skill{id = Id} <- SkillList,
        (Id div 100000) =:= 7 ],
    TmpList2 = [skill_data:get(((Id div 100) * 100 + N)) || #skill{id = Id, type = Type} <- SkillList,
        (Id div 100000) =/= 7 andalso (Type =:= ?type_active orelse Type =:= ?type_passive orelse Type=:=?type_assist)],
    TmpList3 = [skill_data:get(((Id div 100) * 100 + TmpLev2)) || #skill{id = Id, type = Type} <- SkillList,
        Type =:= ?type_lineup orelse Type =:= ?type_nuqi orelse Type =:= ?type_nuqi_passive],
    NewList = TmpList1 ++ TmpList2 ++ TmpList3,
    %% ?DEBUG("GM设技能前技能列表：~w~n设完后：~w~n", [SkillList, NewList]),
    sys_conn:pack_send(ConnPid, 11500, pack_proto_msg(11500, NewList)),
    NewShort = do_gm_set_short(SkillList, NewList, Shortcuts),
    sys_conn:pack_send(ConnPid, 11540, pack_proto_msg(11540, NewShort)),%% 修改快捷栏，并通知
    role_api:push_attr(Role#role{skill = SA#skill_all{skill_list = NewList, shortcuts = NewShort}}).
do_gm_set_skill([], SL) -> SL;
do_gm_set_skill([{IdType, Lev} | T], SL) ->
    NewSL = case lists:keyfind(IdType, #skill.id_type, SL) of
        false -> SL;
        #skill{id = Id} ->
            NS = skill_data:get(((Id div 100) * 100 + Lev)),
            lists:keyreplace(IdType, #skill.id_type, SL, NS)
    end,
    do_gm_set_skill(T, NewSL).
do_gm_set_short([], _, Shortcuts) -> Shortcuts;
do_gm_set_short([#skill{id = Id, id_type = IdType} | T], NewSL, Shortcuts) ->
    case skill:get_shortcuts_index(Shortcuts, Id) of
        0 -> do_gm_set_short(T, NewSL, Shortcuts);
        Index ->
            case lists:keyfind(IdType, #skill.id_type, NewSL) of
                false -> do_gm_set_short(T, NewSL, Shortcuts);
                #skill{id = NewId} ->
                    TmpShort = skill:change_shortcuts(Shortcuts, Index, NewId),
                    do_gm_set_short(T, NewSL, TmpShort)
            end
    end;
do_gm_set_short([_| T], NewSL, Shortcuts) ->
    do_gm_set_short(T, NewSL, Shortcuts).

%% @spec gm_break_out(Role) -> {ok, NewRole}
%% @doc gm命令设置技能突破
gm_break_out(Role = #role{skill = SkillAll = #skill_all{skill_list = SkillList}}) ->
    Breaks = [{Id div 100, 1} || #skill{id = Id} <- SkillList],
    NewRole = Role#role{skill = SkillAll#skill_all{break_out = Breaks}}, 
    skill:push_break_out(NewRole),
    {ok, NewRole}.

%% 计算返回附加装备后的技能 成就系统使用接口
calc_result_skill(Role = #role{career = Career, skill = #skill_all{skill_list = L}}) ->
    case eqm_api:find_skill_attr(Role) of
        [] -> L;
        TypeList ->
            %% 过滤非本职业的技能附加
            NewTypeList = [{(Type rem 100), Num} || {Type, Num} <- TypeList, (Type div 100) =:= Career],
            do_change_append_skill(L, NewTypeList)
    end.

%% @spec break_out(Role, IdType) -> {ok, NewRole} | {false, Reason}
%% Role = NewRole = #role{}
%% IdType = integer()
%% Reason = bitstring()
%% @doc 角色技能突破丹效果
break_out(Role = #role{skill = SkillAll = #skill_all{break_out = Breaks, skill_list = SkillList}, link = #link{conn_pid = ConnPid}}, IdType) ->
    TrueType = get_skill_ascend_type(Role, IdType),
    case lists:keyfind(TrueType rem 100, #skill.id_type, SkillList) of
        #skill{name = Name, lev = Lev} when Lev > 0 ->
            case lists:keyfind(IdType, 1, Breaks) of
                false ->
                    NewBreaks = [{IdType, 1} | Breaks],
                    NewRole = Role#role{
                        skill = SkillAll#skill_all{break_out = NewBreaks}
                    },
                    push_break_out(NewRole),
                        Msg = util:fbin(?L(<<"恭喜您的 ~s 技能成功突破到更高境界">>), [Name]),
                    sys_conn:pack_send(ConnPid, 10931, {57, Msg, []}),
                    {ok, NewRole};
                _ ->
                    {false, ?L(<<"你已使用过该技能的突破丹">>)}
            end;
        _ ->
            {false, ?L(<<"你还没学习对应技能无法领悟更高境界">>)}
    end.

class_id(SkillId) ->
    SkillId div 100.

which_career(SkillId) ->
    SkillId div 100000.

%% ****************************************
%% 内部函数
%% ****************************************
%% 70级技能附加条件检查
check_70_skill(#skill{id_type = IdType}, _Role) when IdType =/= 65 -> 
    true;
check_70_skill(#skill{lev = 1}, #role{eqm = Eqm, soul_world = #soul_world{array_lev = ArrayLev}}) -> 
    SuitEchant = eqm_api:get_suit_enchant(Eqm),
    if
        ArrayLev < 100 ->
            ?L(<<"神魔阵等级不够">>);
        SuitEchant < 9 ->
            ?L(<<"全身强化等级必须要+9以上">>);
        true ->
            true
    end;
check_70_skill(#skill{lev = Lev}, #role{soul_world = #soul_world{array_lev = ArrayLev}}) -> 
    NeedArrayLev = case Lev of
        2 -> 140;
        3 -> 180;
        4 -> 220;
        5 -> 260;
        6 -> 300;
        7 -> 340;
        8 -> 380;
        9 -> 420;
        _ -> 460
    end,
    if
        ArrayLev < NeedArrayLev ->
            ?L(<<"神魔阵等级不够">>);
        true ->
            true
    end.

%% 获取职业初始化技能列表
get_init(?career_zhenwu) -> ?skill_zhenwu;
get_init(?career_cike) -> ?skill_cike;
get_init(?career_feiyu) -> ?skill_feiyu;
get_init(?career_xianzhe) -> ?skill_xianzhe;
get_init(?career_qishi) -> ?skill_qishi;
get_init(?career_xinshou) -> ?skill_xinshou;
get_init(_) -> [].

%% 获取职业筛选被动技能列表
%% get_filter(?career_zhenwu) -> ?filter_type_zhenwu;
%% get_filter(?career_cike) -> ?filter_type_cike;
%% get_filter(?career_feiyu) -> ?filter_type_feiyu;
%% get_filter(?career_xianzhe) -> ?filter_type_xianzhe;
%% get_filter(?career_qishi) -> ?filter_type_qishi;
%% get_filter(?career_xinshou) -> ?filter_type_xinshou;
%% get_filter(_) -> [].

%% 更新有装备附加等级的技能，返回最新的技能列表
do_change_append_skill(SkillList, []) -> SkillList;
do_change_append_skill(SkillList, [{IdType, Num} | T]) ->
    NewList = case lists:keyfind(IdType, #skill.id_type, SkillList) of
        false -> SkillList;
        #skill{id = Id, lev = Lev} when Lev > 0 -> %% 等级大于0
            lists:keyreplace(Id, #skill.id, SkillList, skill_data:get(Id + Num));
        _ -> SkillList
    end,
    do_change_append_skill(NewList, T).

%% 更新技能成就榜
send_achievement_data(Role = #role{career = Career, skill = #skill_all{skill_list = L}}) ->
    SkillList = case eqm_api:find_skill_attr(Role) of
        [] -> L;
        TypeList ->
            %% 过滤非本职业的技能附加
            NewTypeList = [{(Type rem 100), Num} || {Type, Num} <- TypeList, (Type div 100) =:= Career],
            do_change_append_skill(L, NewTypeList)
    end,
    send_achievement_data(Role, SkillList).
send_achievement_data(_Role, []) -> ok;
send_achievement_data(Role, [#skill{id = Id, lev = Lev} | T]) when Lev >= 8 ->
    rank_celebrity:listener(skill_step, Role, {Id, Lev}),
    send_achievement_data(Role, T);
send_achievement_data(Role, [_ | T]) ->
    send_achievement_data(Role, T).

%% 新手转职切换技能列表: 已学技能保留等级，直接转换至转职后对应序号的技能
% do_transfer_career([], List) -> List;
% do_transfer_career([#skill{id = Id, skilled = Skilled, id_type = IdType} | T], List) ->
%     NewList = case lists:keyfind(IdType, #skill.id_type, List) of
%         false -> List;
%         #skill{id = Sid} ->
%             NewId = (Sid div 10000) * 10000 + (Id rem 10000),
%             NewSkill = skill_data:get(NewId),
%             lists:keyreplace(IdType, #skill.id_type, List, NewSkill#skill{skilled = Skilled})
%     end,
%     do_transfer_career(T, NewList).

%% 新手转职后快捷栏保留两个通用技能的快捷栏
do_transfer_career_shortcuts(Career, #skill_shortcuts{
        index_1 = Id1, index_2 = Id2, index_3 = Id3, index_4 = Id4,
        index_5 = Id5, index_6 = Id6, index_7 = Id7, index_8 = Id8,
        index_9 = Id9, index_10 = Id10}) ->
    Fun =
    fun(0) -> 0;
       (Id) ->
           IdType = (Id div 100) rem 100,
           Slev = Id rem 100,
           case IdType =:= 0 orelse IdType =:= 1 of
               true -> ((Career * 100) + IdType) * 100 + Slev;
               false -> 0
           end
    end,
    #skill_shortcuts{
        index_1 = Fun(Id1), index_2 = Fun(Id2), index_3 = Fun(Id3), index_4 = Fun(Id4),
        index_5 = Fun(Id5), index_6 = Fun(Id6), index_7 = Fun(Id7), index_8 = Fun(Id8),
        index_9 = Fun(Id9), index_10 = Fun(Id10)}.

%% @spec set_active_skill_0_to_1(SkillList) -> NewSkillList
%% SkillList = NewSkillList = list()
%% @doc 设置职业主动技能从0级到1级
set_active_skill_0_to_1(L) ->
    set_active_skill_0_to_1(L, []).
set_active_skill_0_to_1([], L) -> L;
set_active_skill_0_to_1([S = #skill{type = ?type_active, id = Id, id_type = IdType} | T], L) ->
    %% 只处理0级的主动技能
    NewSkill = case (Id rem 100) =:= 0 of
        true when IdType =/= 65 ->
            NewId = Id + 1,
            case skill_data:get(NewId) of
                NewS = #skill{} -> NewS;
                _ -> S
            end;
        _ -> %% 保留等级
            S
    end,
    set_active_skill_0_to_1(T, [NewSkill | L]);
set_active_skill_0_to_1([S | T], L) ->
    set_active_skill_0_to_1(T, [S | L]).

%% -------------------------------------------
%% GM数据 1 - 9个级别
gm_get(1) -> [{0,2},{1,2},{2,2},{3,2},{4,1},{5,1},{6,1},{7,1},{8,1},{9,1}];
gm_get(2) -> [{0,2},{1,3},{2,3},{3,3},{4,2},{5,2},{6,1},{7,1},{8,1},{9,1}];
gm_get(3) -> [{0,2},{1,4},{2,5},{3,4},{4,3},{5,3},{6,3},{7,1},{8,1},{9,1}];

gm_get(4) -> [{0,2},{1,3},{2,4},{3,3},{4,2},{5,2},{6,2},{7,1},{8,1},{9,1},{10,1}];
gm_get(5) -> [{0,2},{1,5},{2,5},{3,5},{4,4},{5,4},{6,4},{7,1},{8,1},{9,1},{10,1}];
gm_get(6) -> [{0,2},{1,7},{2,7},{3,7},{4,7},{5,7},{6,7},{7,3},{8,2},{9,2},{10,2},{11,2}];

gm_get(7) -> [{0,2},{1,7},{2,7},{3,7},{4,7},{5,7},{6,7},{7,5},{8,5},{9,5},{10,5},{11,5}];
gm_get(8) -> [{0,7},{1,9},{2,8},{3,8},{4,8},{5,8},{6,8},{7,8},{8,8},{9,8},{10,8},{11,6}];
gm_get(9) -> [{0,7},{1,10},{2,9},{3,9},{4,9},{5,9},{6,9},{7,9},{8,8},{9,8},{10,8},{11,7}];

gm_get(_) -> [].

