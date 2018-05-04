%%----------------------------------------------------
%% @doc 武神坛 
%% @author  shawn
%% @end
%%----------------------------------------------------
-module(cross_warlord).
-export([
        add_team/2
        ,sign_mail/4
        ,combat_over/4
        ,leave/1
        ,leave_match/1
        ,get_team_role/1
        ,role_leave/1         %% 报名区主动离开
        ,role_enter/2
        ,enter_match/1
        ,do_enter_match/3
        ,sign/2
        ,pack_to_team/3
        ,login/1
        ,logout/1
        ,get_zone_status/1
        ,get_trial_zone/2
        ,get_role_trial_info/1
        ,get_team/1
        ,get_war_list/1
        ,get_last_winer/1
        ,get_camp_status/0
        ,get_camp_date/0
        ,get_room_list/0
        ,pack_to_sign/3
        ,do_pack_to_sign/5
        ,check_in_open_time/0
        ,do_check_fight/4
        ,sign_notice/1
        ,lost_sign/4
        ,ready/3
        ,cancel_ready/3
        ,change_lineup/4
    ]
).

-include("cross_warlord.hrl").
-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("pet.hrl").
-include("team.hrl").
-include("pos.hrl").
-include("max_fc.hrl").
-include("skill.hrl").
-include("vip.hrl").

login(Role = #role{pos = Pos, event = ?event_cross_warlord_prepare}) ->
    {MapId, X, Y} = util:rand_list(?cross_warlord_exit),
    NewX = util:rand(X - 20, X + 20),
    NewY = util:rand(Y - 20, Y + 20),
    Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>};
    
login(Role = #role{id = Id, pid = Pid, pos = Pos, event = ?event_cross_warlord_match}) ->
    {MapId, X, Y} = util:rand_list(?cross_warlord_exit),
    NewX = util:rand(X - 20, X + 20),
    NewY = util:rand(Y - 20, Y + 20),
    case center:call(cross_warlord_mgr, login, [Id, Pid]) of
        {ok, NewMapId, ZonePid} ->
            Role#role{cross_srv_id = <<"center">>, pos = Pos#pos{map = NewMapId}, event_pid = ZonePid};
        false -> 
            Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>};
        _Any -> 
            Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>}
    end;
login(Role) ->
    Role.

logout(Role = #role{id = RoleId, pid = Pid, event = ?event_cross_warlord_prepare, pos = Pos = #pos{map = MapId}}) ->
    center:cast(cross_warlord_mgr, role_leave, [RoleId, Pid, MapId]),
    team_api:quit(Role),
    {ok, Role#role{cross_srv_id = <<>>, event = ?event_no, pos = Pos#pos{map = 10003, x = 5160, y = 1440, map_base_id = 10003}}};
logout(Role) -> {ok, Role}.

%% 通知战区参赛选手
add_team(ZonePid, Team) when is_pid(ZonePid) -> ZonePid ! {add_team, Team};
add_team(_, _) -> skip.

%% 获取战场信息
get_zone_status(ZonePid) when is_pid(ZonePid) ->
    case gen_fsm:sync_send_all_state_event(ZonePid, get_status) of
        {ok, {Quality, Time, TeamList, ReadyList, Point}} ->
            {Quality, Time, TeamList, ReadyList, Point};
        _ -> false
    end;
get_zone_status(_) -> false.

%% 准备或者取消
ready({Rid, SrvId}, Pid, ZonePid) when is_pid(ZonePid) ->
    gen_fsm:send_all_state_event(ZonePid, {ready, {Rid, SrvId}, Pid}),
    ok;
ready(_, _, _)  -> false.

cancel_ready({Rid, SrvId}, Pid, ZonePid) when is_pid(ZonePid) ->
    gen_fsm:send_all_state_event(ZonePid, {cancel_ready, {Rid, SrvId}, Pid}),
    ok;
cancel_ready(_, _, _)  -> false.

%% 修改阵法
change_lineup({Rid, SrvId}, Pid, LineId, ZonePid) when is_pid(ZonePid) ->
    gen_fsm:send_all_state_event(ZonePid, {change_lineup, {Rid, SrvId}, Pid, LineId}),
    ok;
change_lineup(_, _, _, _) -> false.

%% 检测是否可以参与活动
%% 返回false则不可以 返回true则可以
check_in_open_time() ->
    case sys_env:get(srv_open_time) of
        T when is_integer(T) ->
            Openday = util:unixtime({today, T}),
            util:unixtime() > Openday + 19 * 86400;
        _ ->
            false
    end.

%% 获取选拔赛区
get_trial_zone(Seq, Label) ->
    case center:is_connect() of
        false -> false;
        _ ->
            case center:call(cross_warlord_mgr, get_trial_team, [Seq, Label]) of
                {TeamInfo, TeamCode, TeamName, TeamSrvId, Roles} when is_list(TeamInfo) ->
                    {TeamInfo, TeamCode, TeamName, TeamSrvId, Roles};
                _ -> false 
            end
    end.

%% 请求活动状态 
get_camp_status() ->
    case center:is_connect() of
        false -> {0, 0};
        _ ->
            case sys_env:get(cross_warlord_camp_status) of
                {Status, 0} when is_integer(Status) ->
                    {Status, 0};
                {Status, Time} when is_integer(Status) ->
                    {Status, util:time_left(55 * 60 * 1000, Time) div 1000};
                _ ->
                    case center:call(cross_warlord_mgr, get_camp_status, []) of
                        {ok, {Status, 0}} ->
                            {Status, 0};
                        {ok, {Status, Time}} ->
                            {Status, util:time_left(55 * 60 * 1000, Time) div 1000};
                        _ -> {0, 0}
                    end
            end
    end.

%% 请求活动状态 
get_camp_date() ->
    case center:is_connect() of
        false -> {3, 0, 0, 0, 0};
        _ ->
            case sys_env:get(cross_warlord_camp_date) of
                _T = {Flag, Status, UnixTime, NextStatus, NextUnixtime} when is_integer(Status) ->
                    {Flag, Status, UnixTime, NextStatus, NextUnixtime};
                _ ->
                    case center:call(cross_warlord_mgr, get_camp_date, []) of
                        {ok, _T = {Flag, Status, UnixTime, NextStatus, NextUnixtime}} ->
                            {Flag, Status, UnixTime, NextStatus, NextUnixtime};
                        _Err ->
                            {3, 0, 0, 0, 0}
                    end
            end
    end.

%% 公告
sign_notice(StateLev) ->
    case check_in_open_time() of
        true -> notice:send(54, util:fbin(?L(<<"第~w届武神坛之战火热报名中，请各路飞仙同道尽快报名参加。{open, 50, 我要报名, #00ff24}">>), [StateLev]));
        false -> skip
    end.

%% 获取角色选拔赛信息
get_role_trial_info(Id) ->
    case center:call(cross_warlord_mgr, get_role_trial_info, [Id]) of
        {Seq, Label} when is_integer(Seq) andalso is_integer(Label) ->
            {Seq, Label};
        _ -> {0, 0}
    end.

%% 获取房间列表
get_room_list() ->
    case center:call(cross_warlord_mgr, get_room_list, []) of
        {ok, RoomList} when is_list(RoomList) ->
            RoomList;
        _ ->
            []
    end.

%% 获取队伍信息
get_team(TeamCode) ->
    case center:call(cross_warlord_mgr, get_team, [TeamCode]) of
        {TeamName, Info} when is_list(Info) ->
            {TeamName, Info};
        _ -> false 
    end.

%% 获取榜单
get_war_list(Label) ->
    case sys_env:get(cross_warlord_last_state) of
        {StateLev, LastInfo} ->
            case center:call(cross_warlord_mgr, get_war_list, [Label]) of
                {InfoList, Code, Name, SrvId, Roles} ->
                    case lists:keyfind(Label, 1, LastInfo) of
                        {Label, LastName, LastSrvId} ->
                            {StateLev, ?true, LastName, LastSrvId, InfoList, Code, Name, SrvId, Roles};
                        _ ->
                            {StateLev, ?false, <<"">>, <<"">>, InfoList, Code, Name, SrvId, Roles}
                    end;
                _ -> false
            end;
        _ ->
            case center:call(cross_warlord_mgr, get_last_info, [Label]) of
                {StateLev, LastInfo, InfoList, Code, Name, SrvId, Roles} ->
                    sys_env:set(cross_warlord_last_state, {StateLev, LastInfo}),
                    case lists:keyfind(Label, 1, LastInfo) of
                        {Label, LastName, LastSrvId} ->
                            {StateLev, ?true, LastName, LastSrvId, InfoList, Code, Name, SrvId, Roles};
                        _ ->
                            {StateLev, ?false, <<"">>, <<"">>, InfoList, Code, Name, SrvId, Roles}
                    end;
                _ -> false
            end
    end.

%% 获取上届冠军
get_last_winer(?cross_warlord_label_sky) ->
    case sys_env:get(cross_warlord_last_winer_sky) of
        {TeamName, RoleList} ->
            {TeamName, RoleList};
        null ->
            false;
        _ ->
            case center:call(cross_warlord_mgr, get_last_winer, [?cross_warlord_label_sky]) of
                {TeamName, RoleList} when is_list(RoleList) ->
                    sys_env:set(cross_warlord_last_winer_sky, {TeamName, RoleList}),
                    {TeamName, RoleList};
                null ->
                    sys_env:set(cross_warlord_last_winer_sky, null),
                    false;
                _ ->
                    false
            end
    end;
get_last_winer(?cross_warlord_label_land) ->
    case sys_env:get(cross_warlord_last_winer_land) of
        {TeamName, RoleList} ->
            {TeamName, RoleList};
        null ->
            false;
        _ ->
            case center:call(cross_warlord_mgr, get_last_winer, [?cross_warlord_label_land]) of
                {TeamName, RoleList} when is_list(RoleList) ->
                    sys_env:set(cross_warlord_last_winer_land, {TeamName, RoleList}),
                    {TeamName, RoleList};
                null ->
                    sys_env:set(cross_warlord_label_land, null),
                    false;
                _ ->
                    false
            end
    end.

%% 战斗结束
combat_over(Referees, Winner, Loser, AddArgs) ->
    case lists:keyfind(common, 1, Referees) of
        {_, Pid} when is_pid(Pid) ->
            gen_fsm:send_all_state_event(Pid, {combat_over, Winner, Loser, AddArgs});
        _ -> skip
    end.

pack_to_team([], _Cmd, _Msg) -> ok;
pack_to_team([Pid | T], Cmd, Msg) when is_pid(Pid) ->
    role:pack_send(Pid, Cmd, Msg),
    pack_to_team(T, Cmd, Msg);
pack_to_team([_ | T], Cmd, Msg) ->
    pack_to_team(T, Cmd, Msg).

pack_to_sign(TeamName, TeamInfo, Day) ->
    Names = [Name || #cross_warlord_role{name = Name} <- TeamInfo],
    pack_to_sign(TeamName, TeamInfo, Names, Day).
pack_to_sign(_, [], _, _) -> ok;
pack_to_sign(TeamName, [#cross_warlord_role{id = {Rid, SrvId}, name = Name} | T], Names, Day) ->
    NewNames = Names -- [Name],
    Bin = to_bin_name(NewNames),
    c_mirror_group:cast(node, SrvId, cross_warlord, do_pack_to_sign, [{Rid, SrvId}, Bin, Name, TeamName, Day]),
    pack_to_sign(TeamName, T, Names, Day).

to_bin_name(Names) ->
    to_bin_name(Names, <<"">>).
to_bin_name([], Bin) -> Bin;
to_bin_name([Name | T], Bin) ->
    case Bin of
        <<"">> ->
            to_bin_name(T, util:fbin(<<"~s">>, [Name]));
        Bin ->
            to_bin_name(T, util:fbin(<<"~s、~s">>, [Bin, Name]))
    end.

do_pack_to_sign({Rid, SrvId}, Bin, Name, TeamName, Day) ->
    Fun = fun(0) -> ?L(<<"明天">>);
        (1) -> ?L(<<"后天">>)
    end,
    Subject = ?L(<<"武神坛选拔赛报名成功">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】报名成功，请等待系统审核最终的比赛资格。你的队友分别是~s，选拔赛第1轮比赛在~s的14:30开始，请拥有正式比赛资格的队伍准时参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。">>), [TeamName, Bin, Fun(Day)]),
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], []});
do_pack_to_sign(_, _, _, _, _) -> ok.

%% 报名
sign(#role{event = Event}, _TeamName) when Event =/= ?event_cross_warlord_prepare ->
    {false, ?L(<<"您需要先进入武神坛报名区域才能报名">>)};
sign(#role{team_pid = TeamPid}, _TeamName) when not is_pid(TeamPid) ->
    {false, ?L(<<"需要三人组队才能发起报名">>)};
sign(#role{attr = #attr{fight_capacity = FightCapacity}}, _TeamName) when FightCapacity < 18000 ->
    {false, ?L(<<"需要三人组队才能发起报名">>)};
sign(#role{team = #role_team{is_leader = ?false}}, _TeamName) ->
    {false, ?L(<<"需要三人组队由队长发起报名">>)};
sign(Role = #role{id = {_, SrvId}, pid = Pid, skill = Skill, team_pid = TeamPid, team = #role_team{is_leader = ?true}}, TeamName) ->
    case team_api:get_members_id(TeamPid) of
        IdList when is_list(IdList) ->
            case length(IdList) >= 2 of
                true ->
                    case get_team_info(IdList) of
                        {ok, TeamInfo, PidInfo, LineUpList} ->
                            Crole = convert(Role),
                            AllInfo = [Crole | TeamInfo],
                            TeamLineUpList = merge_lineup(LineUpList ++ get_all_lineup(Skill)),
                            case check_sign(TeamName, AllInfo) of
                                {false, Reason} -> {false, Reason};
                                {ok, TeamFight} ->
                                    center:cast(cross_warlord_mgr, sign, [TeamName, AllInfo, [Pid |PidInfo], SrvId, TeamFight, TeamLineUpList]),
                                    ok
                            end;
                        _ ->
                            {false, ?L(<<"获取队员信息有误, 请稍后重试">>)}
                    end;
                false ->
                    {false, ?L(<<"需要三人组队由队长发起报名">>)}
            end;
        _ ->
            {false, ?L(<<"需要三人组队由队长发起报名">>)}
    end;
sign(_, _) ->
    {false, ?L(<<"操作失败">>)}.

get_all_lineup(#skill_all{skill_list = SkillList}) ->
    [Id || #skill{id = Id, type = ?type_lineup} <- SkillList].

merge_lineup(LineUpList) ->
    L = [{Id div 100, Id rem 100} || Id <- LineUpList],
    merge_lineup(L, []).

merge_lineup([], Lines) -> 
    [Id * 100 + Lev || {Id, Lev} <- Lines, Lev =/= 0];
merge_lineup([{Id, Lev} | T], Lines) ->
    {GetId, NewT} = split(Id, Lev, T),
    merge_lineup(NewT, [GetId | Lines]).
    
split(Id, Lev, T) ->
    split(Id, Lev, T, []).
split(Id, Lev, [], NewT) -> {{Id, Lev}, NewT};
split(Id, Lev, [{Id, L} | T], NewT) when L > Lev ->
    split(Id, L, T, NewT);
split(Id, Lev, [{Id, _} | T], NewT) ->
    split(Id, Lev, T, NewT);
split(Id, Lev, [NewId | T], NewT) ->
    split(Id, Lev, T, [NewId | NewT]).

check_sign(TeamName, TeamInfo) ->
    case util:check_team_name(TeamName) of
        {false, Reason} -> {false, Reason};
        ok ->
            case check_team_info(TeamInfo) of
                {false, Reason} -> {false, Reason};
                {ok, TeamFight} -> {ok, TeamFight} 
            end
    end.

check_team_info(TeamInfo) ->
    case length(TeamInfo) of
        3 ->
            do_check_team_info(TeamInfo, [], 0);
        _ -> 
            {false, ?L(<<"获取队员信息有误,请稍后重试">>)}
    end.
do_check_team_info([], CareerList, TeamFight) ->
    case length(CareerList) of
        1 -> 
            {false, ?L(<<"三个相同的职业无法报名武神坛">>)};
        _ ->
            {ok, TeamFight}
    end;
do_check_team_info([#cross_warlord_role{name = Name, lev = Lev, career = Career, fight_capacity = FightCapacity} | T], CareerList, TeamFight) ->
    case Lev >= 65 of
        false ->
            {false, util:fbin(?L(<<"~w等级不足65, 无法报名武神坛">>), [Name])};
        true ->
            case FightCapacity >= 18000 of
                false ->
                    {false, util:fbin(?L(<<"~w战斗力不足18000, 无法报名武神坛">>), [Name])};
                true ->
                    NewCareerList = case lists:keyfind(Career, 1, CareerList) of
                        false -> [{Career, 1} | CareerList];
                        {Career, Num} ->
                            lists:keyreplace(Career, 1, CareerList, {Career, Num + 1})
                    end,
                    do_check_team_info(T, NewCareerList, TeamFight + round(math:pow(FightCapacity/500, 2)))
            end
    end.

%% 获取队员信息
get_team_info(IdList) ->
    get_team_info(IdList, [], [], []).
get_team_info([], TeamInfo, PidInfo, LineUpList) -> {ok, TeamInfo, PidInfo, LineUpList};
get_team_info([{Rid, SrvId} | T], TeamInfo, PidInfo, LineUpList) ->
    case role_api:c_lookup(by_id, {Rid, SrvId}, [#role.name, #role.lev, #role.sex, #role.career, #role.pet, #role.attr, #role.looks, #role.skill, #role.eqm, #role.hp_max, #role.mp_max, #role.demon, #role.pid, #role.vip, #role.ascend, #role.max_fc]) of
        {ok, _N, [Name, Lev, Sex, Career, PetBag = #pet_bag{active = Active}, Attr, Looks, Skill, Eqm, HpMax, MpMax, Demon, Pid, #vip{type = VipType, portrait_id = Face}, Ascend, #max_fc{max = FightCapacity}]} ->
            PetFight = case Active of
                #pet{fight_capacity = F} -> F;
                _ -> 0
            end,
            Info = #cross_warlord_role{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, lev = Lev, sex = Sex, career = Career, fight_capacity = FightCapacity, pet_fight = PetFight, vip = VipType, looks = Looks, face_id = Face, combat_cache = {Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, Demon, Looks, Ascend}},
            LineUp = get_all_lineup(Skill),
            get_team_info(T, [Info | TeamInfo], [Pid | PidInfo], LineUpList ++ LineUp);
        _ ->
            false
    end.

%% 发送报名邮件
sign_mail(land, {Rid, SrvId}, Name, TeamName) -> %% 报名邮件
    Subject = ?L(<<"武神坛入围选拔赛第一轮">>),
    Content = util:fbin(?L(<<"本次武神坛海选赛报名结束，您所在的队伍:【~s】成功入围玄虎赛区选拔赛, 请于明天下午14:30准时参加选拔赛第一轮比赛">>), [TeamName]),
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], []});

sign_mail(sky, {Rid, SrvId}, Name, TeamName) -> %% 报名邮件
    Subject = ?L(<<"武神坛入围选拔赛第一轮">>),
    Content = util:fbin(?L(<<"本次武神坛海选赛报名结束，您所在的队伍:【~s】成功入围天龙赛区选拔赛, 请于明天下午14:30准时参加选拔赛第一轮比赛">>), [TeamName]),
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], []});
sign_mail(_, _, _, _) -> skip.

%% 失败
lost_sign(Rid, SrvId, Name, TeamName) ->
    Subject = ?L(<<"武神坛未入选海选赛通知">>),
    Content = util:fbin(?L(<<"本次武神坛海选赛报名结束，您所在的队伍:【~s】很遗憾没有入选武神坛海选赛，感谢您的踊跃参与！">>), [TeamName]),
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], []}).

%% 进入报名区
role_enter(Role = #role{id = {Rid, SrvId}, pid = Pid}, RoomId) ->
    case check_enter_pre(Role) of
        {false, Reason} -> {false, Reason};
        ok ->
            PreRole = #cross_warlord_pre_role{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, pid = Pid},
            center:cast(cross_warlord_mgr, role_enter, [PreRole, RoomId]),
            {ok}
    end.

check_enter_pre(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"在队伍中,无法进入武神坛报名区">>)};
check_enter_pre(#role{status = Status}) when Status =/= ?status_normal ->
    {false, ?L(<<"当前状态不能进入武神坛报名区">>)};
check_enter_pre(#role{lev = Lev}) when Lev < 65 ->
    {false, ?L(<<"等级不足65级, 无法进入武神坛报名区">>)};
check_enter_pre(#role{attr = #attr{fight_capacity = FightCapacity}}) when FightCapacity < 18000 ->
    {false, ?L(<<"战力不足18000, 无法进入武神坛报名区">>)};
check_enter_pre(#role{event = ?event_no}) ->
    ok;
check_enter_pre(_) ->
    {false, ?L(<<"当前状态下,无法进入武神坛报名区">>)}.

check_enter_match(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"在队伍中,无法进入武神坛比赛">>)};
check_enter_match(#role{status = Status}) when Status =/= ?status_normal ->
    {false, ?L(<<"当前状态不能进入武神坛比赛">>)};
check_enter_match(#role{lev = Lev}) when Lev < 65 ->
    {false, ?L(<<"等级不足65级, 无法进入武神坛比赛">>)};
check_enter_match(#role{attr = #attr{fight_capacity = FightCapacity}}) when FightCapacity < 18000 ->
    {false, ?L(<<"战力不足18000, 无法进入武神坛比赛">>)};
check_enter_match(#role{event = ?event_no}) ->
    ok;
check_enter_match(_) ->
    {false, ?L(<<"当前状态下,无法进入武神坛比赛">>)}.

%% 进入正式区
enter_match(Role = #role{id = Id, pid = Pid, career = Career, attr = #attr{fight_capacity = FightCapacity}}) ->
    case check_enter_match(Role) of
        {false, Reason} -> {false, Reason};
        ok ->
            case center:call(cross_warlord_mgr, enter_match, [Id, Pid, Career, FightCapacity]) of
                {false, Reason} ->
                    {false, Reason};
                {ok, ZonePid, MapId} ->
                    role:apply(async, Pid, {cross_warlord, do_enter_match, [ZonePid, MapId]}),
                    {ok};
                _ -> {false, ?L(<<"时空隧道不稳定, 请稍后重试">>)}
            end
    end.

do_check_fight(?cross_warlord_label_land, Quality, SignFight, NowFight) ->
    case Quality of
        ?cross_warlord_quality_trial_1 -> NowFight >= SignFight + 2000;
        ?cross_warlord_quality_trial_2 -> NowFight >= SignFight + 2400;
        ?cross_warlord_quality_trial_3 -> NowFight >= SignFight + 2800;
        ?cross_warlord_quality_top_32 -> NowFight >= SignFight + 3200;
        ?cross_warlord_quality_top_16 -> NowFight >= SignFight + 3600;
        ?cross_warlord_quality_top_8 -> NowFight >= SignFight + 4000;
        ?cross_warlord_quality_top_4_1 -> NowFight >= SignFight + 4200;
        ?cross_warlord_quality_top_4_2 -> NowFight >= SignFight + 4500;
        ?cross_warlord_quality_semi_final -> NowFight >= SignFight + 4700;
        ?cross_warlord_quality_final -> NowFight >= SignFight + 4900;
        _ -> NowFight >= SignFight + 2000
    end;
do_check_fight(?cross_warlord_label_sky, _, _, _) -> false.

%% 退出报名区
role_leave(#role{combat_pid = CombatPid}) when is_pid(CombatPid) ->
    {false, ?L(<<"战斗中不能退出武神坛活动">>)};
role_leave(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"请退出队伍,再离开武神坛区域">>)};

role_leave(#role{pid = RolePid, event = ?event_cross_warlord_match}) ->
    role:apply(async, RolePid, {cross_warlord, leave_match, []}),
    {ok};
role_leave(#role{id = RoleId, pid = Pid, event = ?event_cross_warlord_prepare, pos = #pos{map = MapId}}) ->
    center:cast(cross_warlord_mgr, role_leave, [RoleId, Pid, MapId]),
    role:apply(async, Pid, {cross_warlord_mgr, async_leave_pre_map, []}),
    {ok};
role_leave(_Role) ->
    {false, ?L(<<"您当前不在武神坛活动里面">>)}.

%% 角色进入战区
do_enter_match(Role = #role{id = _Id, name = _Name}, ZonePid, MapId) ->
    {X, Y} = util:rand_list([{1920, 1350}, {3120, 1350}]),
    NewX = util:rand(X - 50, X + 50),
    NewY = util:rand(Y - 50, Y + 50),
    case map:role_enter(MapId, NewX, NewY, Role#role{cross_srv_id = <<"center">>, event = ?event_cross_warlord_match, event_pid = ZonePid}) of
        {ok, NewRole} ->
            ?DEBUG("~s成功进入正式区",[_Name]),
            {ok, NewRole};
        {false, _Why} ->
            ?ERR("~s进入正式区失败,原因:~w",[_Name, _Why]),
            {ok}
    end.

%% 比赛区玩家退出
leave([]) -> ok;
leave([#cross_warlord_role{pid = RolePid} | T]) when is_pid(RolePid) ->
    role:apply(async, RolePid, {cross_warlord, leave_match, []}),
    leave(T);
leave([_ | T]) ->
    leave(T).

%% 玩家离开
leave_match(Role = #role{hp_max = HpMax, mp_max = MpMax, name = _Name, event = ?event_cross_warlord_match}) ->
    ?DEBUG("角色退出场景[RoleName:~s]", [_Name]),
    {_MapId, X, Y} = util:rand_list(?cross_warlord_exit),
    XRand = util:rand(-20, 20),
    YRand = util:rand(-20, 20),
    team_api:quit(Role),
    case map:role_enter(10003, X+XRand, Y+YRand, Role#role{event = ?event_no, hp = HpMax, mp = MpMax, cross_srv_id = <<>>}) of
        {ok, NewRole} -> {ok, NewRole};
        {false, _Why} ->
            ?DEBUG("[~s]退出武神坛失败[Reason:~w]", [_Name, _Why]),
            {ok}
    end;
leave_match(_) -> {ok}.

%% 获取所有角色
get_team_role(Teams) ->
    get_team_role(Teams, []).
get_team_role([], Roles) -> Roles;
get_team_role([#cross_warlord_team{team_member = TeamMem} | T], Roles) ->
    get_team_role(T, Roles++ TeamMem).

%% 转换成跨服数据
convert(#role{id = {Rid, SrvId}, name = Name, lev = Lev, sex = Sex, vip = #vip{type = VipType, portrait_id = Face}, career = Career, eqm = Eqm, hp_max = HpMax, mp_max = MpMax, max_fc = #max_fc{max = FightCapacity}, attr = Attr, skill = Skill, demon = Demon, pet = PetBag = #pet_bag{active = Active}, looks = Looks, ascend = Ascend}) ->
    PetFight = case Active of
        #pet{fight_capacity = F} -> F;
        _ -> 0
    end,
    #cross_warlord_role{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, face_id = Face, name = Name, lev = Lev, sex = Sex, vip = VipType, career = Career, fight_capacity = FightCapacity, pet_fight = PetFight, looks = Looks, combat_cache = {Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, Demon, Looks, Ascend}}.
