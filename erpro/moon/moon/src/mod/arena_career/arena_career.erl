%% --------------------------------------------------------------------
%% 中庭战神 
%% @author shawn 
%% --------------------------------------------------------------------
-module(arena_career).
-export([
        enter_map/1
        ,reenter_map/1
        ,leave_map/1
        ,get_range/1
        ,get_weakest/1
        ,calc_award/1
        %,c_get_range/3
        ,combat_start/3
        %,c_combat_start/4
        ,combat/2
        ,to_show/1
        ,get_role/2
        %,c_get_role/3
        ,get_role_rank/2
        ,get_role_wins/2
        %,c_get_role_info/3
        %,c_get_role_rank/3
        ,to_arena_role/21
        %,pack_16114/5
        ,login/1
        ,day_check/1
        ,get_hero/0
        ,get_wins_rank/0
        %,get_cross_hero/0
        %,call_center/3
        %,cast_center/3
        ,latest_wins/1
        ,log_result/2
        ,notice_client/3
        ,get_award/1
        ,combat_award/1
        ,to_fight_role/2
        ,get_expedition_partners/1
    ]
).

-include("arena_career.hrl").
-include("pos.hrl").
-include("role.hrl").
-include("common.hrl").
-include("combat.hrl").
-include("pet.hrl").
-include("attr.hrl").
-include("vip.hrl").
-include("link.hrl").
-include("skill.hrl").
-include("task.hrl").
-include("demon.hrl").
-include("gain.hrl").


%% -> #role{}
enter_map(Role = #role{id = {Rid, SrvId}, pid = RolePid, link = #link{conn_pid = ConnPid}, pos = Pos = #pos{map = MapId, map_pid = MapPid, x = X, y = Y}}) ->
    map:role_leave(MapPid, RolePid, Rid, SrvId, X, Y), 
    sys_conn:pack_send(ConnPid, 10110, {?arena_career_map_id, ?arena_career_left_pos_x, ?combat_upper_pos_y}),
    Role#role{
        event = ?event_arena_career, 
        pos = Pos#pos{
            last = {MapId, X, Y}, 
            map = ?arena_career_map_id,
            x = ?arena_career_left_pos_x, 
            y = ?combat_upper_pos_y
        } 
    }.

%% -> 重入地图
reenter_map(Role = #role{link = #link{conn_pid = ConnPid}, event = Event}) ->
    case Event of
        ?event_arena_career ->
            sys_conn:pack_send(ConnPid, 10110, {?arena_career_map_id, ?arena_career_left_pos_x, ?combat_upper_pos_y});
        _ ->
            ignore
    end,
    Role.

%% -> #role{}
leave_map(Role = #role{pos = #pos{map = ?arena_career_map_id, last = {LastMapId, LastX, LastY}}}) ->
    NewRole = case map:role_enter(LastMapId, LastX, LastY, Role) of
        {ok, NewR} -> 
            NewR;
        {false, 'bad_pos'} -> 
            notice:alert(error, Role, ?MSGID(<<"进入地图失败:无效的坐标">>)),
            Role;
        {false, 'bad_map' } -> 
            notice:alert(error, Role, ?MSGID(<<"进入地图失败:不存在的地图">>)),
            Role;
        {false, _Reason } -> 
            notice:alert(error, Role, ?MSGID(<<"进入地图失败">>)),
            Role
    end,
    clear_target(NewRole#role{
        event = ?event_no
    });
leave_map(Role) ->
    Role.

login(Role = #role{lev = Lev}) when Lev < ?arena_career_lev -> Role;
login(Role = #role{pid = Pid, event = Event, pos = #pos{map = MapBaseId}, link = #link{conn_pid = _ConnPid}, arena_career = ArenaCareer = #arena_career{last_time = LastTime, target = _Target}}) ->
    Today = util:unixtime(today),
    Tomorrow = Today + 86401,
    Now = util:unixtime(),
    TempRole = case LastTime < Today of
        false -> Role;
        true ->
            NewArenaCareer = ArenaCareer#arena_career{free_count = ?award_career_times, pay_time = 0, pay_count = 0},
            Role#role{arena_career = NewArenaCareer}
    end,
    NewRole = case Event =:= ?event_arena_career andalso MapBaseId =/= ?arena_career_map_id of
        true -> %% 防止数据错误
            TempRole#role{event = ?event_no};
        _ ->
            TempRole
    end,
    %%NewRole = case Event of
    %%    ?event_arena_career -> %% 正在挑战
    %%        case LastTarget of
    %%            {TargetRid, TargetSrvId} ->
    %%                case get_role(TargetRid, TargetSrvId) of
    %%                    false ->
    %%                        leave_map(TempRole);
    %%                    ARole ->
    %%                        TargetRole = to_fight_role(ARole, TempRole#role.pos),
    %%                        {ok, TargetMR} = role_convert:do(to_map_role, TargetRole),
    %%                        map:send_enter_msg(ConnPid, TargetMR),
    %%                        TempRole
    %%                end;
    %%            _ ->
    %%                leave_map(TempRole)
    %%        end;
    %%    _ -> 
    %%        TempRole
    %%end,
    role_timer:set_timer(arena_career, (Tomorrow - Now) * 1000, {arena_career, day_check, []}, 1, NewRole),
    role:apply(async, Pid, {fun sign/1, []}),
    NewRole.

sign(Role) ->
    arena_career_mgr:sign(Role),
    {ok, Role}.

get_hero() ->
    Hero = arena_career_dao:get_hero(),
    to_show_rank(Hero).

get_wins_rank() ->
    Data = arena_career_dao:get_wins_rank(),
    [ list_to_tuple(Row) || Row <- Data].

% get_cross_hero() ->
%     case call_center(c_arena_career_dao, get_cross_hero, []) of
%         HeroRole when is_list(HeroRole) ->
%             HeroRole;
%         {error, center_not_ready} ->
%             ?DEBUG("未连接中央服, 请求失败"),
%             [];
%         _X ->
%             ?ERR("获取跨服排行数据失败:~w",[_X]),
%             []
%     end.

%% 日期检测,异步调用,返回格式 {ok, NewRole}
day_check(Role = #role{career = _Career, link = #link{conn_pid = ConnPid}, arena_career = ArenaCareer = #arena_career{last_time = _LastTime}}) ->
    NewArenaCareer = ArenaCareer#arena_career{free_count = ?award_career_times, pay_time = 0, pay_count = 0},
    NewRole = Role#role{arena_career = NewArenaCareer},
    notice_client(all, ConnPid, NewRole),
    role_timer:set_timer(arena_career, 86400 * 1000, {arena_career, day_check, []}, 1, NewRole),
    {ok, NewRole}.

%% 推送个人信息
% pack_16114(Rid, SrvId, Career, ConnPid, #arena_career{free_count = Count1, pay_count = Count2, cooldown = CoolDown}) ->
%     case arena_career_mgr:check_center(Rid, SrvId, Career) of
%         true ->
%             case arena_career:c_get_role_info(Rid, SrvId, Career) of
%                 false -> {ok};
%                 {Rank, GetLev} ->
%                     Now = util:unixtime(),
%                     Cd = case CoolDown =:= 0 of
%                         true -> 0;
%                         false ->
%                             case CoolDown - Now > 0 of
%                                 true -> CoolDown - Now;
%                                 false -> 0
%                             end
%                     end,
%                     D = case arena_career_mgr:get_center_award() of
%                         Day when is_integer(Day) -> Day;
%                         _X ->
%                             ?DEBUG("获取奖励发放时间错误:~w",[_X]),
%                             3
%                     end,
%                     sys_conn:pack_send(ConnPid, 16114, {?true, Rank, GetLev, Count1 + Count2, Cd, D})
%             end;
%         false -> {ok}
%     end.

%% 获取角色信息
get_role(Rid, SrvId) ->
    case arena_career_dao:get_role(Rid, SrvId) of
        {true, Arole} -> Arole;
        _ -> false
    end.

% c_get_role(Rid, SrvId, Career) ->
%     case call_center(c_arena_career_dao, get_role, [Rid, SrvId, Career]) of
%         {true, Crole} when is_record(Crole, c_arena_career_role) ->
%             Crole;
%         {error, center_not_ready} ->
%             ?DEBUG("未连接中央服, 请求失败"),
%             false;
%         _X ->
%             ?DEBUG("_X:~w",[_X]),
%             false
%     end.

%% 获取角色排名
get_role_rank(Rid, SrvId) ->
    case arena_career_dao:get_role_rank(Rid, SrvId) of
        Rank when is_integer(Rank) -> 
            Rank;
        _X ->
            ?ERR("Rid:~w, SrvId:~s获取角色排名出错~w",[Rid, SrvId, _X]),
            false
    end.

%% 获取连胜次数
get_role_wins(Rid, SrvId) ->
    case arena_career_dao:get_role_wins(Rid, SrvId) of
        Wins when is_integer(Wins) -> 
            Wins;
        _X ->
            ?ERR("Rid:~w, SrvId:~s获取角色排名出错~w",[Rid, SrvId, _X]),
            false
    end.

%% 获取角色跨服排名
% c_get_role_rank(Rid, SrvId, Career) ->
%     case call_center(c_arena_career_dao, get_role_rank, [Rid, SrvId, Career]) of
%         Rank when is_integer(Rank) -> 
%             Rank;
%         {error, center_not_ready} ->
%             ?DEBUG("未连接中央服, 请求失败"),
%             false;
%         _X ->
%             ?ERR("Rid:~w, SrvId:~s获取角色排名出错~w",[Rid, SrvId, _X]),
%             false
%     end.

%% 获取角色部分信息
% c_get_role_info(Rid, SrvId, Career) ->
%     case call_center(c_arena_career_dao, get_role_info, [Rid, SrvId, Career]) of
%         {Rank, Lev} when is_integer(Rank) andalso is_integer(Lev) -> 
%             {Rank, Lev};
%         {error, center_not_ready} ->
%             ?DEBUG("未连接中央服, 请求失败"),
%             false;
%         _X ->
%             ?ERR("Rid:~w, SrvId:~s获取角色排名出错~w",[Rid, SrvId, _X]),
%             false
%     end.

%% cast中央服
% cast_center(Mod, Func, Args) ->
%     center:cast(Mod, Func, Args).
%% call中央服
% call_center(Mod, Func, Args) ->
%     center:call(Mod, Func, Args).

%% 获取角色范围数据
get_range(Role = #role{id = {Rid, SrvId}}) ->
    LatestWins = latest_wins(Role),
    RangeRole = arena_career_dao:get_range(Rid, SrvId, LatestWins),
    to_range_role(RangeRole).

%% 获取最弱角色
get_weakest(Role = #role{id = {Rid, SrvId}}) ->
    LatestWins = latest_wins(Role),
    case arena_career_dao:get_weakest(Rid, SrvId, LatestWins) of
        null -> null;
        TargetRole ->
            [TargetRole1] = to_range_role([TargetRole]),
            TargetRole1            
    end.

%% -> {CanFetch::boolean(), Stone, Coin, AwardRank}
get_award({Rid, SrvId}) ->
    case arena_career_dao:get_award_rank(Rid, SrvId) of
        false -> {?false, 0, 0, 0};
        {AwardRank, Rank} ->
            {CanFetch, R} = case AwardRank of
                0 -> {?false, Rank};
                _ -> {?true, AwardRank}
            end,
            {Stone, Coin} = calc_award(R),
            {CanFetch, Stone, Coin, R}
    end.

combat_award(winner) -> ?arena_career_combat_winner_award;
combat_award(loser) -> ?arena_career_combat_loser_award.

% c_get_range(Rid, SrvId, Career) ->
%     case call_center(c_arena_career_dao, get_range, [Rid, SrvId, Career]) of
%         RangeRole when is_list(RangeRole) ->
%             RangeRole;
%         {error, center_not_ready} ->
%             ?DEBUG("未连接中央服, 请求失败"),
%             [];
%         _X ->
%             ?ERR("获取跨服排行范围数据失败:~w",[_X]),
%             []
%     end.

%% -> {null, RangeRole} | {ok, #role{}} | {error, Reason, Role}
combat_start(ToRid, ToSrvId, Role = #role{task = TaskList, link = #link{conn_pid = ConnPid}}) ->
    case get_role(ToRid, ToSrvId) of
        false ->
            RangeRole = get_range(Role),
            {null, RangeRole};
        Arole ->
            Role1 = arena_career:enter_map(Role),
            NARole = case [Task || Task = #task{task_id = 26010, status = 0} <- TaskList] of
                [] -> Arole;
                _ -> task_util:convert_arena_career_role(Arole) %% 新手引导
            end,
            TargetRole = to_fight_role(NARole, Role1#role.pos),
            {ok, TargetMR} = role_convert:do(to_map_role, TargetRole),
            map:send_enter_msg(ConnPid, TargetMR),
            case combat_type:check(?combat_type_arena_career, Role1, TargetRole) of
                true ->
                    Role2 = save_target(Role1, {ToRid, ToSrvId}),
                    arena_career_mgr:combat_start(Role2),
                    {ok, Role2};
                {false, ErrMsg} ->
                    {error, ErrMsg, arena_career:leave_map(Role1)}
            end
    end.

% c_combat_start(ToRid, ToSrvId, ToCareer, Role = #role{id = {Rid, SrvId}, career = Career, name = Name, sex = Sex, lev = Lev, vip = #vip{portrait_id = Face}, eqm = Eqm, looks = Looks, pet = PetBag, hp_max = HpMax, mp_max = MpMax, attr = Attr = #attr{fight_capacity = FightCapacity}, skill = Skill, ascend = Ascend, arena_career = ArenaCareer = #arena_career{free_count = Count1, pay_count = Count2}}) ->
%     case c_get_role(ToRid, ToSrvId, ToCareer) of
%         false ->
%             null;
%         Crole ->
%             Now = util:unixtime(),
%             combat_type:check(?combat_type_c_arena_career, Role, to_fight_role(Crole, Role#role.pos)),
%             RoleInfo = {Rid, SrvId, Name, Career, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag#pet_bag{pets = []}, Skill, FightCapacity, Ascend},
%             cast_center(c_arena_career_mgr, combat_start, [RoleInfo]),
%             {NewCount1, NewCount2} = case Count1 =:= 0 of
%                 true -> {0, Count2 - 1};
%                 false -> {Count1 - 1, Count2}
%             end,
%             {ok, Role#role{arena_career = ArenaCareer#arena_career{free_count = NewCount1, pay_count = NewCount2, cooldown = Now + 600, last_time = Now}}}
%     end.

combat(combat_over, {_, Winner, Loser}) ->
    [#fighter{rid = FromRid, srv_id = FromSrvId, name = FromName, career = FromCareer}] = [F || F <- Winner ++ Loser, F#fighter.group =:= group_atk],
    [#fighter{rid = ToRid, srv_id = ToSrvId, name = ToName, career = ToCareer}] = [F || F <- Winner ++ Loser, F#fighter.group =:= group_dfd],
    Result = case [F || F <- Winner, F#fighter.is_clone =:= 0] of
        [] -> ?arena_career_lose;
        _ -> ?arena_career_win
    end,
    CombatResult = #arena_career_result{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_name = FromName, fight_career = FromCareer, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_name = ToName, to_fight_career = ToCareer, result = Result},
    arena_career_mgr:combat_over(CombatResult).

% combat(c_combat_over, {_, Winner, Loser}) ->
%     [#fighter{rid = FromRid, srv_id = FromSrvId, name = FromName, career = FromCareer}] = [F || F <- Winner ++ Loser, F#fighter.group =:= group_atk],
%     [#fighter{rid = ToRid, srv_id = ToSrvId, name = ToName, career = ToCareer}] = [F || F <- Winner ++ Loser, F#fighter.group =:= group_dfd],
%     Result = case [F || F <- Winner, F#fighter.is_clone =:= 0] of
%         [] -> ?arena_career_lose;
%         _ -> ?arena_career_win
%     end,
%     CombatResult = #arena_career_result{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_name = FromName, fight_career = FromCareer, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_name = ToName, to_fight_career = ToCareer, result = Result},
%     cast_center(c_arena_career_mgr, combat_over, [CombatResult]).

to_arena_role(Roles) when is_list(Roles) ->
    to_arena_role(Roles, []).
to_arena_role([], ArenaRoles) -> ArenaRoles;
to_arena_role([{Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend, ConWins, AwardRank, MaxConWins, LastSignTime} | T], ArenaRoles) ->
    Arole = to_arena_role(Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend, ConWins, AwardRank, MaxConWins, LastSignTime),
    to_arena_role(T, [Arole | ArenaRoles]).

to_arena_role(Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend, ConWins, AwardRank, MaxConWins, LastSignTime) ->
    Looks2 = case util:bitstring_to_term(Looks) of
        {ok, Looks1} -> 
            case Looks1 of
                [_|_] -> Looks1;
                _ -> []
            end;
        {error, _Why1} -> 
            ?ERR("中庭战神获取外观出错:~w", [_Why1]),
            []
    end,
    Eqm2 = case util:bitstring_to_term(Eqm) of
        {ok, Eqm1} ->
            case Eqm1 of
                [_|_] ->
                    case item_parse:do(Eqm1) of
                        {ok, Eqm3} -> Eqm3;
                        _ -> 
                            ?ERR("中庭战神装备列表转换错误"),
                            []
                    end;
                _ -> []
            end;
        {error, _Why2} ->
            ?ERR("中庭战神获取装备列表错误:~w", [_Why2]),
            []
    end,
    Attr2 = case util:bitstring_to_term(Attr) of
        {ok, Attr1} ->
            role_attr:ver_parse(Attr1);
        _Why3 ->
            ?ERR("中庭战神获取角色属性出错:~w",[_Why3]),
            #attr{}
    end,
    PetBag2 = case util:bitstring_to_term(PetBag) of
        {ok, PetBag1} ->
            case pet_parse:do(PetBag1) of
                {ok, NewPetPag1} -> 
                    NewPetPag1;
                _ ->
                    ?ERR("宠物数据版本转换失败"),
                    #pet_bag{}
            end;
        _Why4 ->
            ?ERR("中庭战神获取宠物背包出错:~w",[_Why4]),
            #pet_bag{}
    end,
    Skill2 = case util:bitstring_to_term(Skill) of
        {ok, Skill1} ->
            case skill:ver_parse_2(Skill1) of
                NewSkill when is_record(NewSkill, skill_all) ->
                    NewSkill;
                _Why6 ->
                    ?ERR("中庭战神获取技能出错:~w",[_Why6]),
                    #skill_all{}
            end;
        _Why5 ->
            ?ERR("中庭战神获取技能出错:~w",[_Why5]),
            #skill_all{}
    end,
    NewAscend = case util:bitstring_to_term(Ascend) of
        {ok, CA} -> ascend:ver_parse(CA);
        _ -> ascend:init()
    end,
    #arena_career_role{rid = Rid, srv_id = SrvId, name = Name, career = Career, rank = Rank, sex = Sex, lev = Lev, face = Face, hp_max = HpMax, mp_max = MpMax, attr = Attr2, looks = Looks2, eqm = Eqm2, pet_bag = PetBag2, skill = Skill2, fight_capacity = FightCapacity, ascend = NewAscend, con_wins = ConWins, award_rank = AwardRank, max_con_wins = MaxConWins, last_sign_time = LastSignTime}.

%% -------------------------
to_fight_role(#arena_career_role{rid = Rid, srv_id = SrvId, name = Name, sex = Sex, career = Career, lev = Lev, hp_max = HpMax, mp_max = MpMax, attr = Attr, looks = Looks, pet_bag = PetBag, eqm = Eqm, skill = Skill, ascend = Ascend}, Pos) ->
    Special = case PetBag#pet_bag.active of
        undefined -> [];
        ActPet -> [{?special_pet, ActPet#pet.base_id, ActPet#pet.name}]
    end,
    #role{id = {Rid, SrvId}, name = Name, sex = Sex, career = Career, lev = Lev, hp = HpMax, mp = MpMax, hp_max = HpMax, mp_max = MpMax, attr = Attr, looks = Looks, pet = PetBag, skill = Skill, eqm = Eqm, demon = #role_demon{}, ascend = Ascend, pos = Pos#pos{x = ?arena_career_right_pos_x, y = ?combat_upper_pos_y}, special = Special}.
% to_fight_role(#c_arena_career_role{rid = Rid, srv_id = SrvId, name = Name, sex = Sex, career = Career, lev = Lev, hp_max = HpMax, mp_max = MpMax, attr = Attr, looks = Looks, pet_bag = PetBag, eqm = Eqm, skill = Skill, ascend = Ascend}, Pos) ->
%     #role{id = {Rid, SrvId}, name = Name, sex = Sex, career = Career, lev = Lev, hp = HpMax, mp = MpMax, hp_max = HpMax, mp_max = MpMax, attr = Attr, looks = Looks, pet = PetBag, skill = Skill, eqm = Eqm, demon = #role_demon{}, ascend = Ascend, pos = Pos#pos{x = ?arena_career_right_pos_x, y = ?combat_upper_pos_y}}.

%% find(_Rid, _SrvId, []) -> false;
%% find(Rid, SrvId, [Arole = #arena_career_role{rid = Rid, srv_id = SrvId} | _T]) -> {true, Arole};
%% find(Rid, SrvId, [Crole = #c_arena_career_role{rid = Rid, srv_id = SrvId} | _T]) -> {true, Crole};
%% find(Rid, SrvId, [_ | T]) -> find(Rid, SrvId, T).

to_range_role(RangeRole) ->
    to_range_role(RangeRole, []).
to_range_role([], NewRange) ->
    to_arena_role(NewRange);
to_range_role([L | T], NewRange) ->
    to_range_role(T, [list_to_tuple(L) | NewRange]).

to_show(Roles) ->
    to_show(Roles, <<"">>).
to_show([], Info) -> Info;
% to_show([#c_arena_career_role{rid = Rid, srv_id = SrvId, sex = Sex, lev = Lev, fight_capacity = FightCapacity, name = Name, rank = Rank} | T], Info) ->
%     M = util:fbin("Rid:~w,SrvId:~s,名字:~s,性别:~w,等级:~w,战斗力:~w,排名:~w",[Rid, SrvId, Name, Sex, Lev, FightCapacity, Rank]),
%     to_show(T, util:fbin("~s\n~s",[Info, M]));
to_show([#arena_career_role{rid = Rid, srv_id = SrvId, sex = Sex, lev = Lev, fight_capacity = FightCapacity, name = Name, rank = Rank} | T], Info) ->
    M = util:fbin("Rid:~w,SrvId:~s,名字:~s,性别:~w,等级:~w,战斗力:~w,排名:~w",[Rid, SrvId, Name, Sex, Lev, FightCapacity, Rank]),
    to_show(T, util:fbin("~s\n~s",[Info, M])).

to_show_rank(Hero) ->
    to_show_rank(Hero, []).
to_show_rank([], NewHero) ->
    do_to_show(NewHero);
to_show_rank([L | T], NewHero) ->
    to_show_rank(T, [list_to_tuple(L) | NewHero]).

do_to_show(Hero) ->
    do_to_show(Hero, []).
do_to_show([], NewHero) -> NewHero;
do_to_show([{Rid, SrvId, Name, Rank, Lev, FightCapacity, Career} | T], NewHero) ->
    Log = arena_career_mgr:query_data(Rid, SrvId),
    Trend = trend_log(Log),
    do_to_show(T, [{Rank, Rid, SrvId, Name, Lev, FightCapacity, Career, Trend} | NewHero]).

trend_log(Log) ->
    trend_log(Log, 0).
trend_log([], 0) -> ?arena_career_rank_normal;
trend_log([], #arena_career_log{up_or_down = UpOrDown}) -> UpOrDown;
trend_log([L | T], 0) ->
    trend_log(T, L);
trend_log([L = #arena_career_log{ctime = Time1} | T], #arena_career_log{ctime = Time2}) 
when Time1 > Time2 ->
    trend_log(T, L);
trend_log([_ | T], L) -> trend_log(T, L).


%% 最近5场挑战胜利次数
latest_wins(Role) ->
    length([ ?arena_career_win || ?arena_career_win <- Role#role.arena_career#arena_career.latest_result]).

log_result(Role = #role{arena_career = ArenaCareer}, Result) ->
    LatestResult = ArenaCareer#arena_career.latest_result,
    NewL = case LatestResult of
        [] ->
            [Result];
        [R1, R2, R3, R4, _R5|_] -> %% 已打5场及以上
            [Result, R1, R2, R3, R4];
        [_ | _] ->
            [Result|LatestResult]
    end,
    clear_target(Role#role{
        arena_career = ArenaCareer#arena_career{
            latest_result = NewL
        }
    }).
    

notice_client(cooldown, ConnPid, Cd) ->
    sys_conn:pack_send(ConnPid, 16105, {Cd});
notice_client(times, ConnPid, Times) ->
    sys_conn:pack_send(ConnPid, 16104, {Times});

notice_client(all, ConnPid, Role = #role{id = {Rid, SrvId}, arena_career = #arena_career{free_count = Count1, pay_count = Count2, cooldown = CoolDown, pay_time = PayTime}}) ->
    case arena_career:get_role_rank(Rid, SrvId) of
        false -> {ok};
        Rank ->
            ConWins = case get_role_wins(Rid, SrvId) of
                false -> 0;
                _Wins -> _Wins
            end,
            Now = util:unixtime(),
            Cd = case CoolDown =:= 0 orelse vip:arena_loss(Role) of
                true -> 0;
                false ->
                    case CoolDown - Now > 0 of
                        true -> CoolDown - Now;
                        false -> 0
                    end
            end,
            VipNoCd = case vip:arena_loss(Role) of
                true -> 1;
                _ -> 0
            end,
            {CanFetch, Stone, Coin, AwardRank} = arena_career:get_award({Rid, SrvId}),
            Time = arena_career_mgr:remain_award_time(),
            sys_conn:pack_send(ConnPid, 16103, {Count1 + Count2, Cd, VipNoCd, Rank, ConWins, CanFetch, Stone, Coin, Time, AwardRank, PayTime})
    end.

%% 记住上一个挑战对手
save_target(Role = #role{arena_career = ArenaCareer}, {RoleId, SrvId}) ->
    Role#role{arena_career = ArenaCareer#arena_career{target = {RoleId, SrvId}}}.
%% 清除记录的对手
clear_target(Role = #role{arena_career = ArenaCareer}) ->
    Role#role{arena_career = ArenaCareer#arena_career{target = undefined}}.

%% 计算奖励
%% -> {Stone, Gold} 
calc_award(Rank) -> 
    {round(100000/math:pow(Rank, 0.5)/3),
    round(1000000/math:pow(Rank, 0.3)/5000)}.

%% 获取远征王军伙伴 
get_expedition_partners(#role{id = {RoleId, SrvId}}) ->
    case get_role_rank(RoleId, SrvId) of
        false -> [];
        Rank ->
            Roles = arena_career_dao:get_expedition_partners(Rank),
            to_range_role(Roles)
    end.
    
