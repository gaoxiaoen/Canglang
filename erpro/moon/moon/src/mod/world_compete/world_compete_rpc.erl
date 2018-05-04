%% *************************
%% 仙道会的协议处理
%% @author yankai
%% *************************
-module(world_compete_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("link.hrl").
-include("team.hrl").
%%
-include("world_compete.hrl").
-include("pet.hrl").
-include("pos.hrl").
-include("assets.hrl").
-include("max_fc.hrl").
-include("gain.hrl").
-include("skill.hrl").

-define(WORLD_COMPETE_MIN_POWER, 6500). %% 最低战斗力要求
-define(WORLD_COMPETE_MIN_LEV, 52).     %% 最低等级要求

%% 获取当前活动状态
handle(16000, _, #role{pid = Pid}) ->
    world_compete_mgr:get_current_status(Pid),
    {ok};

%%-------------------------------------------------
%% 报名
%%-------------------------------------------------
handle(16001, {WorldCompeteType}, #role{attr = #attr{fight_capacity = RolePower}}) when RolePower < ?WORLD_COMPETE_MIN_POWER ->
    {reply, {WorldCompeteType, ?false, util:fbin(?L(<<"你的战斗力未达到~w，不能报名">>), [?WORLD_COMPETE_MIN_POWER])}};

handle(16001, {WorldCompeteType}, #role{lev = Lev}) when Lev < ?WORLD_COMPETE_MIN_LEV ->
    {reply, {WorldCompeteType, ?false, util:fbin(?L(<<"必须达到~w等级才能报名">>), [?WORLD_COMPETE_MIN_LEV])}};

handle(16001, {WorldCompeteType}, #role{event = Event}) when Event =/= ?event_no ->
    {reply, {WorldCompeteType, ?false, ?L(<<"当前状态下不能报名参加仙道会">>)}};

%% 1v1
handle(16001, {?WORLD_COMPETE_TYPE_11}, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {?WORLD_COMPETE_TYPE_11, ?false, ?L(<<"参加仙道会1v1不能组队">>)}};

handle(16001, {?WORLD_COMPETE_TYPE_11}, #role{id = RoleId, name = Name, lev = Lev, career = Career, sex = Sex, attr = Attr, looks = Looks, eqm = Eqm, pet = PetBag, max_fc = #max_fc{max = MaxFc}, skill = _Skills}) ->
    PetPower = get_active_pet_power(PetBag),
    %% 测试：
    %% Lineups = get_all_lineup(_Skills),
    Lineups = [],
    SignupRole = #sign_up_role{id = RoleId, name = Name, career = Career, sex = Sex, lev = Lev, attr = Attr#attr{fight_capacity = MaxFc}, looks = Looks, eqm = Eqm, pet_power =PetPower, lineups = Lineups},
    world_compete_mgr:sign_up(?WORLD_COMPETE_TYPE_11, [SignupRole]),
    {ok};

%% 2v2
%%handle(16001, {?WORLD_COMPETE_TYPE_22}, #role{team_pid = TeamPid}) when not is_pid(TeamPid) ->
%%    {reply, {?WORLD_COMPETE_TYPE_22, ?false, ?L(<<"参加仙道会2v2组队状态下报名失败">>)}};
handle(16001, {?WORLD_COMPETE_TYPE_22}, #role{id = RoleId1, name = Name1, lev = Lev1, career = Career1, sex = Sex1, event = ?event_no, looks = Looks1, eqm = Eqm1, pet = PetBag1, attr = Attr1, team_pid = TeamPid, skill = Skills1, max_fc = #max_fc{max = MaxFc1}}) when not is_pid(TeamPid) ->
    SignupRole = #sign_up_role{id = RoleId1, name = Name1, career = Career1, sex = Sex1, lev = Lev1, attr = Attr1#attr{fight_capacity = MaxFc1}, looks = Looks1, eqm = Eqm1, pet_power = get_active_pet_power(PetBag1), lineups = get_all_lineup(Skills1)},
    world_compete_mgr:sign_up(?WORLD_COMPETE_TYPE_22, [SignupRole]),
    {ok};

handle(16001, {?WORLD_COMPETE_TYPE_22}, #role{id = LeaderRoleId, name = Name1, lev = Lev1, career = Career1, sex = Sex1, event = ?event_no, team_pid = TeamPid, attr = Attr1, looks = Looks1, eqm = Eqm1, pet = PetBag1, skill = Skills1, max_fc = #max_fc{max = MaxFc1}}) when is_pid(TeamPid) ->
    case team:get_team_info(TeamPid) of
        {ok, #team{leader = #team_member{id = LeaderRoleId}, member = Members}} -> %% 队长可以报名
            case Members of
                [#team_member{id = MemberRoleId}] ->
                    case role_api:c_lookup(by_id, MemberRoleId, [#role.name, #role.lev, #role.career, #role.sex, #role.attr, #role.looks, #role.eqm, #role.pet, #role.event, #role.max_fc, #role.skill]) of
                        {ok, _, [_, _, _, _, _, _, _, _, _, #max_fc{max = MaxFc2}, _]} when MaxFc2 < ?WORLD_COMPETE_MIN_POWER ->
                            {reply, {?WORLD_COMPETE_TYPE_22, ?false, util:fbin(?L(<<"队友战斗力未达到~w，不能报名">>), [?WORLD_COMPETE_MIN_POWER])}};
                        {ok, _, [_, Lev2, _, _, _, _, _, _, _, _, _]} when Lev2 < ?WORLD_COMPETE_MIN_LEV ->
                            {reply, {?WORLD_COMPETE_TYPE_22, ?false, util:fbin(?L(<<"必须达到~w等级才能报名">>), [?WORLD_COMPETE_MIN_LEV])}};
                        {ok, _, [Name2, Lev2, Career2, Sex2, Attr2, Looks2, Eqm2, PetBag2, ?event_no, #max_fc{max = MaxFc2}, Skills2]} when is_record(Attr2, attr) ->
                            case world_compete_mgr:is_cross_teammate_reached_signup_limit(?WORLD_COMPETE_TYPE_22, MemberRoleId) of
                                true ->
                                    {reply, {?WORLD_COMPETE_TYPE_22, ?false, util:fbin(?L(<<"队友今天的报名次数已满~w次">>), [?SIGN_UP_MAX_NUM])}};
                                false ->
                                    SignupRole1 = #sign_up_role{id = LeaderRoleId, name = Name1, career = Career1, sex = Sex1, lev = Lev1, attr = Attr1#attr{fight_capacity = MaxFc1}, looks = Looks1, eqm = Eqm1, pet_power = get_active_pet_power(PetBag1), origin_teammate_ids = [MemberRoleId], lineups = get_all_lineup(Skills1)},
                                    SignupRole2 = #sign_up_role{id = MemberRoleId, name = Name2, career = Career2, sex = Sex2, lev = Lev2, attr = Attr2#attr{fight_capacity = MaxFc2}, looks = Looks2, eqm = Eqm2, pet_power = get_active_pet_power(PetBag2), origin_teammate_ids = [LeaderRoleId], lineups = get_all_lineup(Skills2)},
                                    world_compete_mgr:sign_up(?WORLD_COMPETE_TYPE_22, [SignupRole1, SignupRole2]),
                                    {ok}
                            end;
                        _ ->
                            {reply, {?WORLD_COMPETE_TYPE_22, ?false, ?L(<<"查找不到你的队友，不能报名">>)}}
                    end;
                [] -> 
                    SignupRole = #sign_up_role{id = LeaderRoleId, name = Name1, career = Career1, sex = Sex1, lev = Lev1, attr = Attr1#attr{fight_capacity = MaxFc1}, looks = Looks1, eqm = Eqm1, pet_power = get_active_pet_power(PetBag1), lineups = get_all_lineup(Skills1)},
                    world_compete_mgr:sign_up(?WORLD_COMPETE_TYPE_22, [SignupRole]),
                    {ok};
                _ -> {reply, {?WORLD_COMPETE_TYPE_22, ?false, ?L(<<"参加仙道会2v2组队状态下报名失败">>)}}
            end;
        {ok, #team{member = _Members}} -> %% 非队长不可以报名
            {reply, {?WORLD_COMPETE_TYPE_22, ?false, ?L(<<"只有队长才能报名">>)}};
        _ ->
            {reply, {?WORLD_COMPETE_TYPE_22, ?false, ?L(<<"参加仙道会2v2组队状态下报名失败">>)}}
    end;

%% 3v3
%%handle(16001, {?WORLD_COMPETE_TYPE_33}, #role{team_pid = TeamPid}) when not is_pid(TeamPid) ->
%%    {reply, {?WORLD_COMPETE_TYPE_33, ?false, ?L(<<"参加仙道会3v3组队状态下报名失败">>)}};
handle(16001, {?WORLD_COMPETE_TYPE_33}, #role{id = RoleId1, name = Name1, lev = Lev1, career = Career1, sex = Sex1, event = ?event_no, looks = Looks1, eqm = Eqm1, pet = PetBag1, attr = Attr1, team_pid = TeamPid, skill = Skills1, max_fc = #max_fc{max = MaxFc1}}) when not is_pid(TeamPid) ->
    SignupRole = #sign_up_role{id = RoleId1, name = Name1, career = Career1, sex = Sex1, lev = Lev1, attr = Attr1#attr{fight_capacity = MaxFc1}, looks = Looks1, eqm = Eqm1, pet_power = get_active_pet_power(PetBag1), lineups = get_all_lineup(Skills1)},
    world_compete_mgr:sign_up(?WORLD_COMPETE_TYPE_33, [SignupRole]),
    {ok};

handle(16001, {?WORLD_COMPETE_TYPE_33}, #role{id = LeaderRoleId, name = Name1, lev = Lev1, career = Career1, sex = Sex1, event = ?event_no, team_pid = TeamPid, attr = Attr1, looks = Looks1, eqm = Eqm1, pet = PetBag1, skill = Skills1, max_fc = #max_fc{max = MaxFc1}}) when is_pid(TeamPid) ->
    case team:get_team_info(TeamPid) of
        {ok, #team{leader = #team_member{id = LeaderRoleId}, member = Members}} -> %% 队长可以报名
            case Members of
                [#team_member{id = MemberRoleId1}] -> %% 一个队友
                    {Result1, Rec1} = case role_api:c_lookup(by_id, MemberRoleId1, [#role.name, #role.lev, #role.career, #role.sex, #role.attr, #role.looks, #role.eqm, #role.pet, #role.event, #role.max_fc, #role.skill]) of
                        {ok, _, [_, _, _, _, _, _, _, _, _, #max_fc{max = MaxFc2}, _]} when MaxFc2 < ?WORLD_COMPETE_MIN_POWER ->
                            {false, util:fbin(?L(<<"队友战斗力未达到~w，不能报名">>), [?WORLD_COMPETE_MIN_POWER])};
                        {ok, _, [_, Lev2, _, _, _, _, _, _, _, _, _]} when Lev2 < ?WORLD_COMPETE_MIN_LEV ->
                            {false, util:fbin(?L(<<"必须达到~w等级才能报名">>), [?WORLD_COMPETE_MIN_LEV])};
                        {ok, _, [_, _, _, _, _, _, _, _, Event2, _, _]} when Event2 =/= ?event_no ->
                            {false, ?L(<<"你的队友当前状态无法参加仙道会">>)};
                        {ok, _, [Name2, Lev2, Career2, Sex2, Attr2, Looks2, Eqm2, PetBag2, _, #max_fc{max = MaxFc2}, Skills2]} when is_record(Attr2, attr) ->
                            {true, #sign_up_role{id = MemberRoleId1, name = Name2, career = Career2, sex = Sex2, lev = Lev2, attr = Attr2#attr{fight_capacity = MaxFc2}, looks = Looks2, eqm = Eqm2, pet_power = get_active_pet_power(PetBag2), lineups = get_all_lineup(Skills2), origin_teammate_ids = [LeaderRoleId]}};
                        _ ->
                            {false, ?L(<<"查找不到你的队友，不能报名">>)}
                    end,
                    if
                        Result1 =:= false ->
                            {reply, {?WORLD_COMPETE_TYPE_33, ?false, Rec1}};
                        true ->
                            case world_compete_mgr:is_cross_teammate_reached_signup_limit(?WORLD_COMPETE_TYPE_33, MemberRoleId1) of
                                true ->
                                    {reply, {?WORLD_COMPETE_TYPE_33, ?false, util:fbin(?L(<<"队友今天的报名次数已满~w次">>), [?SIGN_UP_MAX_NUM])}};
                                false ->
                                    SignupRole1 = #sign_up_role{id = LeaderRoleId, name = Name1, career = Career1, sex = Sex1, lev = Lev1, attr = Attr1#attr{fight_capacity = MaxFc1}, looks = Looks1, eqm = Eqm1, pet_power = get_active_pet_power(PetBag1), lineups = get_all_lineup(Skills1), origin_teammate_ids = [MemberRoleId1]},
                                    world_compete_mgr:sign_up(?WORLD_COMPETE_TYPE_33, [SignupRole1, Rec1]),
                                    {ok}
                            end
                    end;
                [#team_member{id = MemberRoleId1}, #team_member{id = MemberRoleId2}] -> %% 两个队友
                    %% 检查队员1
                    {Result1, Rec1} = case role_api:c_lookup(by_id, MemberRoleId1, [#role.name, #role.lev, #role.career, #role.sex, #role.attr, #role.looks, #role.eqm, #role.pet, #role.event, #role.max_fc, #role.skill]) of
                        {ok, _, [_, _, _, _, _, _, _, _, _, #max_fc{max = MaxFc2}, _]} when MaxFc2 < ?WORLD_COMPETE_MIN_POWER ->
                            {false, util:fbin(?L(<<"队友战斗力未达到~w，不能报名">>), [?WORLD_COMPETE_MIN_POWER])};
                        {ok, _, [_, Lev2, _, _, _, _, _, _, _, _, _]} when Lev2 < ?WORLD_COMPETE_MIN_LEV ->
                            {false, util:fbin(?L(<<"必须达到~w等级才能报名">>), [?WORLD_COMPETE_MIN_LEV])};
                        {ok, _, [_, _, _, _, _, _, _, _, Event2, _, _]} when Event2 =/= ?event_no ->
                            {false, ?L(<<"你的队友当前状态无法参加仙道会">>)};
                        {ok, _, [Name2, Lev2, Career2, Sex2, Attr2, Looks2, Eqm2, PetBag2, _, #max_fc{max = MaxFc2}, Skills2]} when is_record(Attr2, attr) ->
                            {true, #sign_up_role{id = MemberRoleId1, name = Name2, career = Career2, sex = Sex2, lev = Lev2, attr = Attr2#attr{fight_capacity = MaxFc2}, looks = Looks2, eqm = Eqm2, pet_power = get_active_pet_power(PetBag2), lineups = get_all_lineup(Skills2), origin_teammate_ids = [LeaderRoleId, MemberRoleId2]}};
                        _ ->
                            {false, ?L(<<"查找不到你的队友，不能报名">>)}
                    end,
                    %% 检查队员2
                    {Result2, Rec2} = case role_api:c_lookup(by_id, MemberRoleId2, [#role.name, #role.lev, #role.career, #role.sex, #role.attr, #role.looks, #role.eqm, #role.pet, #role.event, #role.max_fc, #role.skill]) of
                        {ok, _, [_, _, _, _, _, _, _, _, _, #max_fc{max = MaxFc3}, _]} when MaxFc3 < ?WORLD_COMPETE_MIN_POWER ->
                            {false, util:fbin(?L(<<"队友战斗力未达到~w，不能报名">>), [?WORLD_COMPETE_MIN_POWER])};
                        {ok, _, [_, Lev3, _, _, _, _, _, _, _, _, _]} when Lev3 < ?WORLD_COMPETE_MIN_LEV ->
                            {false, util:fbin(?L(<<"必须达到~w等级才能报名">>), [?WORLD_COMPETE_MIN_LEV])};
                        {ok, _, [_, _, _, _, _, _, _, _, Event3, _, _]} when Event3 =/= ?event_no ->
                            {false, ?L(<<"你的队友当前状态无法参加仙道会">>)};
                        {ok, _, [Name3, Lev3, Career3, Sex3, Attr3, Looks3, Eqm3, PetBag3, _, #max_fc{max = MaxFc3}, Skills3]} when is_record(Attr3, attr) ->
                            {true, #sign_up_role{id = MemberRoleId2, name = Name3, career = Career3, sex = Sex3, lev = Lev3, attr = Attr3#attr{fight_capacity = MaxFc3}, looks = Looks3, eqm = Eqm3, pet_power = get_active_pet_power(PetBag3), lineups = get_all_lineup(Skills3), origin_teammate_ids = [LeaderRoleId, MemberRoleId1]}};
                        _ ->
                            {false, ?L(<<"查找不到你的队友，不能报名">>)}
                    end,
                    if
                        Result1 =:= false ->
                            {reply, {?false, Rec1}};
                        Result2 =:= false ->
                            {reply, {?false, Rec2}};
                        Result1 =:= true andalso Result2 =:= true andalso Career1 =:= Rec1#sign_up_role.career andalso Rec1#sign_up_role.career =:= Rec2#sign_up_role.career ->
                            {reply, {?false, ?L(<<"三人模式不允许三个相同职业报名">>)}};
                        true ->
                            SignupRole1 = #sign_up_role{id = LeaderRoleId, name = Name1, career = Career1, sex = Sex1, lev = Lev1, attr = Attr1#attr{fight_capacity = MaxFc1}, looks = Looks1, eqm = Eqm1, pet_power = get_active_pet_power(PetBag1), lineups = get_all_lineup(Skills1), origin_teammate_ids = [MemberRoleId1, MemberRoleId2]},
                            if
                                SignupRole1#sign_up_role.career =:= Rec1#sign_up_role.career andalso Rec1#sign_up_role.career =:= Rec2#sign_up_role.career ->
                                    {reply, {?WORLD_COMPETE_TYPE_33, ?false, ?L(<<"参加仙道会3v3相同职业不能超过2个">>)}};
                                true ->
                                    LimitResult1 = world_compete_mgr:is_cross_teammate_reached_signup_limit(?WORLD_COMPETE_TYPE_33, MemberRoleId1),
                                    LimitResult2 = world_compete_mgr:is_cross_teammate_reached_signup_limit(?WORLD_COMPETE_TYPE_33, MemberRoleId2),
                                    if
                                        LimitResult1=:=true orelse LimitResult2=:=true ->
                                            {reply, {?WORLD_COMPETE_TYPE_33, ?false, util:fbin(?L(<<"队友今天的报名次数已满~w次">>), [?SIGN_UP_MAX_NUM])}};
                                        true ->
                                            world_compete_mgr:sign_up(?WORLD_COMPETE_TYPE_33, [SignupRole1, Rec1, Rec2]),
                                            {ok}
                                    end
                            end
                    end;
                [] ->
                    SignupRole = #sign_up_role{id = LeaderRoleId, name = Name1, career = Career1, sex = Sex1, lev = Lev1, attr = Attr1#attr{fight_capacity = MaxFc1}, looks = Looks1, eqm = Eqm1, pet_power = get_active_pet_power(PetBag1), lineups = get_all_lineup(Skills1)},
                    world_compete_mgr:sign_up(?WORLD_COMPETE_TYPE_33, [SignupRole]),
                    {ok};
                _ -> {reply, {?WORLD_COMPETE_TYPE_33, ?false, ?L(<<"参加仙道会3v3组队状态下报名失败">>)}}
            end;
        {ok, #team{member = _Members}} -> %% 非队长不可以报名
            {reply, {?WORLD_COMPETE_TYPE_33, ?false, ?L(<<"只有队长才能报名">>)}};
        _ ->
            {reply, {?WORLD_COMPETE_TYPE_33, ?false, ?L(<<"参加仙道会3v3组队状态下报名失败">>)}}
    end;

%% 取消匹配（无论队长还是队员都可以）
handle(16002, {0}, #role{id = RoleId, event = Event = ?event_c_world_compete_11}) ->
    WorldCompeteType = world_compete_mgr:event_to_world_compete_type(Event),
    world_compete_mgr:cancel_match(WorldCompeteType, [RoleId]),
    {ok};
handle(16002, {0}, #role{id = RoleId, event = Event, team_pid = TeamPid}) when Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    WorldCompeteType = world_compete_mgr:event_to_world_compete_type(Event),
    case is_pid(TeamPid) andalso util:is_process_alive(TeamPid) of
        true ->
            case team:get_team_info(TeamPid) of
                {ok, #team{leader = #team_member{id = RoleId}, member = Members}} ->
                    MemberRoleIds = case Members of
                        [#team_member{id = MemberRoleId}] -> [MemberRoleId];
                        [#team_member{id = MemberRoleId1}, #team_member{id = MemberRoleId2}] -> [MemberRoleId1, MemberRoleId2];
                        _ -> []
                    end,
                    world_compete_mgr:cancel_match(WorldCompeteType, [RoleId|MemberRoleIds]);
                _ ->
                    world_compete_mgr:cancel_match(WorldCompeteType, [RoleId])
            end;
        false ->
            world_compete_mgr:cancel_match(WorldCompeteType, [RoleId])
    end,
    {ok};
handle(16002, {0}, _Role) ->
    {reply, {0, ?false, ?L(<<"取消报名失败">>)}};

%% 重新匹配（无论队长还是队员都可以）
handle(16002, {1}, #role{id = RoleId, event = ?event_c_world_compete_11}) ->
    world_compete_mgr:retry_match([RoleId]),
    {ok};
handle(16002, {1}, #role{id = RoleId1, event = Event, team_pid = TeamPid}) when (Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33) andalso is_pid(TeamPid) ->
    case team:get_team_info(TeamPid) of
        {ok, #team{leader = #team_member{id = RoleId1}, member = Members}} -> %% 队长可以报名
            MemberRoleIds = case Members of
                [#team_member{id = MemberRoleId}] -> [MemberRoleId];
                [#team_member{id = MemberRoleId1}, #team_member{id = MemberRoleId2}] -> [MemberRoleId1, MemberRoleId2];
                _ -> []
            end,
            world_compete_mgr:retry_match([RoleId1|MemberRoleIds]),
            {ok};
        _ ->
            {reply, {1, ?false, ?L(<<"组队状态下只有队长才能重新匹配">>)}}
    end;
handle(16002, {1}, #role{id = RoleId, event = Event}) when (Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33) ->
    world_compete_mgr:retry_match([RoleId]),
    {ok};
handle(16002, {1}, _Role) ->
    {ok};

%% 请求匹配好后进入战区的信息
handle(16003, _, #role{id = RoleId, event = Event}) when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    world_compete_mgr:reinform_enter_combat_area(RoleId),
    {ok};
handle(16003, _, _Role) ->
    {ok};

%% 退出战斗区域
handle(16005, _, #role{combat_pid = CombatPid}) when is_pid(CombatPid) ->
    {ok};
%%handle(16005, _, #role{id = RoleId, pid = Pid, event = Event}) when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
%%    world_compete_mgr:leave_area(RoleId, Pid),
%%    {ok};
%% TODO:因为查不到为何有些退不出去，所以暂时先这样处理
handle(16005, _, #role{id = RoleId, pid = Pid}) ->
    world_compete_mgr:leave_area(RoleId, Pid),
    {ok};

%% 获取仙道会已参与次数
handle(16006, _, #role{id = RoleId}) ->
    world_compete_mgr:get_signup_counts(RoleId),
    {ok};

%% 获取仙道会战绩相关数据
handle(16010, _, Role) ->
    case role:check_cd(proto_16010, 1) of
        true ->
            case world_compete_medal:get_world_compete_data(Role) of
                {ok, Msg, NewRole} ->
                    {reply, Msg, NewRole};
                {ok, Msg} ->
                    {reply, Msg};
                _ -> 
                    {ok}
            end;
        _ -> {ok}
    end;

%% 获取仙道会别人的战绩信息
handle(16011, {Rid, SrvId}, #role{id = RoleId = {Rid, SrvId}, assets = #assets{wc_lev = WcLev}}) ->
    case world_compete_medal:get_other_world_compete_data(WcLev, RoleId) of
        error -> {ok};
        Msg ->
            {reply, Msg}
    end;
handle(16011, {Rid, SrvId}, _Role) ->
    case world_compete_medal:get_other_world_compete_data({Rid, SrvId}) of
        error -> {ok};
        Msg ->
            {reply, Msg}
    end;

%% 获取仙道会每日最佳战绩
handle(16012, _, #role{pid = Pid}) ->
    world_compete_mgr:get_mark_day(Pid),
    {ok};

%% 领取每日段位奖励
handle(16013, _, #role{id = RoleId, pid = Pid}) ->
    world_compete_mgr:get_day_section_reward(RoleId, Pid),
    {ok};

%% 选择阵法
handle(16014, {LineupId}, #role{id = RoleId, event = ?event_c_world_compete_11}) ->
    world_compete_mgr:change_lineup(?WORLD_COMPETE_TYPE_11, RoleId, LineupId),
    {ok};
handle(16014, {LineupId}, #role{id = RoleId, event = ?event_c_world_compete_22}) ->
    world_compete_mgr:change_lineup(?WORLD_COMPETE_TYPE_22, RoleId, LineupId),
    {ok};
handle(16014, {LineupId}, #role{id = RoleId, event = ?event_c_world_compete_33}) ->
    world_compete_mgr:change_lineup(?WORLD_COMPETE_TYPE_33, RoleId, LineupId),
    {ok};

%% 查询段位赛奖励是否可以领取
handle(16015, _, #role{id = RoleId}) ->
    {_DayLilian, _DayAttainment, CanDrawDayRewards} = world_compete_mgr:get_day_section_reward_info(RoleId),
    {reply, {CanDrawDayRewards}};

%% 容错
handle(_Cmd, _Data, _Role = #role{name = _Name}) ->
    ?ERR("收到[~s]发送的无效信息[Cmd:~w Data:...]", [_Name, _Cmd]),
    {ok}.

%% 获取主战宠的战斗力
get_active_pet_power(PetBag) ->
    case PetBag of
        #pet_bag{active = #pet{fight_capacity = PetPower}} -> PetPower;
        _ -> 0
    end.

%% 获取所有的阵法
get_all_lineup(#skill_all{skill_list = SkillList}) ->
    [Id || #skill{id = Id, type = ?type_lineup} <- SkillList].
