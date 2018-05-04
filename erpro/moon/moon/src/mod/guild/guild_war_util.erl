%% --------------------------------------------------------------------
%% 帮战util方法
%% @author abu@jieyou.cn
%% --------------------------------------------------------------------
-module(guild_war_util).

-export([
        send_notice/3
        ,get_team_roles/3
        ,get_team_rids/2
        ,get_team_members/2
        ,is_leader/1
        ,asyn_apply/3
        ,to_guild_war_guild/2
        ,to_guild_war_role/1
        ,compare_fight_capacity/3
        ,check/1
        ,select_roles/3
        ,get_guild_leader/1
        ,handle_buff/2
        ,handle_honor/2
        ,day_diff/2
    ]).

%% include files
-include("common.hrl").
-include("team.hrl").
-include("guild_war.hrl").
%%
-include("guild.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("looks.hrl").

%% @spec send_notice(Pid, Msg, Type) 
%% Pid = pid()
%% Msg = bitstring()
%% Type = integer()
%% 发送提示信息
send_notice(Pid, Msg, 1) ->
    role:pack_send(Pid, 10931, {55, Msg, []});

send_notice(Pid, Msg, _) ->
    role:pack_send(Pid, 10931, {55, Msg, []}).

%% @spec asyn_apply(Pid, F, Para)
%% 检查Rpid并执行 role:apply
asyn_apply(Rpid, F, Para) ->
    case check([{is_pid_alive, Rpid}]) of
        ok ->
            role:apply(async, Rpid, {F, Para});
        _ ->
            ok
    end.

%% @spec get_team_rids(by_id, Rid)
%% Rid = rid()
%% 获取队伍里的玩家的rid 
get_team_rids(by_id, Rid) ->
    case role_api:lookup(by_id, Rid, [#role.team_pid, #role.team]) of
        {ok, _, [TeamPid, #role_team{is_leader = 1}]} when is_pid(TeamPid) ->
            case team:get_team_info(TeamPid) of
                {ok, #team{member = Members}} ->
                    Rids = [R || #team_member{id = R, mode = M} <- Members, M =:= 0],
                    [Rid | Rids];
                _ ->
                    [Rid]
            end;
        _ ->
            [Rid]
    end.

%% @spec get_team_roles(Rid) 
%% Rid = {integer(), binary()}
%% 取得所在队伍的玩家
get_team_roles(by_id, Rid, all) ->
    case role_api:lookup(by_id, Rid) of
        {ok, _, Role = #role{team_pid = Tpid}} ->
            [Role | get_team_members(Tpid, all)];
        _ ->
            []
    end;
get_team_roles(by_id, Rid, Mode) ->
    case role_api:lookup(by_id, Rid) of
        {ok, _, Role = #role{team_pid = Tpid, team = #role_team{is_leader = 1}}} ->
            [Role | get_team_members(Tpid, Mode)];
        {ok, _, Role} ->
            [Role];
        _ ->
            []
    end.

%% @spec get_team_members(Tpid, Mode) 
%% 获取组员
get_team_members(Tpid, Mode) ->
    case is_pid(Tpid) andalso is_process_alive(Tpid) of
        true ->
            do_get_team_members(Tpid, Mode);
        false ->
            []
    end.
do_get_team_members(Tpid, all) ->
    case team:get_team_info(Tpid) of
        {ok, #team{member = Members, leader = #team_member{id = Lid}}} ->
            Rids = [Rid || #team_member{id = Rid} <- Members] ++ [Lid],
            get_roles(Rids, []);
        _ ->
            []
    end;
do_get_team_members(Tpid, Mode) ->
    case team:get_team_info(Tpid) of
        {ok, #team{member = Members}} ->
            Rids = [Rid || #team_member{id = Rid, mode = M} <- Members, Mode =:= M],
            get_roles(Rids, []);
        _ ->
            []
    end.

%% @spec is_leader(Role) -> false | true
%% 判断是否为队长
is_leader(Role = #role{}) ->
    case team_api:is_leader(Role) of
        {true, _} ->
            true;
        false ->
            false
    end;
is_leader(#role_team{is_leader = 1}) ->
    true;
is_leader(_) ->
    false.

%% @spec compare_fight_capacity(Rid, Fc, Tpid, Tpid2) -> false | true
%% Rid = {integer(), bitstring}
%% Fc = integer()
%% Tpid = Tpid2 = pid()
%% 比较两个队伍的战斗力
compare_fight_capacity(Fc, Tpid, Tpid2) ->
    Fc1 = get_fight_capacity(get_team_members(Tpid, 0)),
    Fc2 = get_fight_capacity(get_team_roles(by_team_pid, Tpid2, 0)),
    ?DEBUG("~w, ~w, ~w", [Fc, Fc1, Fc2]),
    Fc1 + Fc - Fc2 > 0.

%% @spec check(CheckList) ->
%% CheckList = term()
%% 检测条件
check([]) ->
    ok;
check([H | T]) ->
    case check(H) of
        false ->
            {false, H};
        true ->
            check(T)
    end;

%% 进程是否存活
check({is_pid_alive, Pid}) ->
    case is_pid(Pid) andalso is_process_alive(Pid) of
        true ->
            true;
        false ->
            false
    end;
%% 是否跟随
check({is_not_follow, #role{team = #role_team{is_leader = 1}}}) ->
    true;
check({is_not_follow, #role{team = #role_team{follow = 1}}}) ->
    false;
check({is_not_follow, _}) ->
    true;
%% 是否飞行
check({is_not_fly, #role{ride = ?ride_fly}}) ->
    false;
check({is_not_fly, _}) ->
    true;
%% 判断是否跨服中
check({is_not_in_cross, #role{cross_srv_id = <<>>}}) ->
    true;
check({is_not_in_cross, #role{}}) ->
    false;
%% 是否为队长
check({is_leader, Role}) ->
    is_leader(Role);
check(_) ->
    true.

%% 将帮会信息转换为帮战里的帮会信息
to_guild_war_guild(#guild{pid = Pid, id = Id, name = Name, realm = Realm}, Union) ->
    #guild_war_guild{pid = Pid, id = Id, name = Name, realm = Realm, union = Union, is_union_chief = ?false};
to_guild_war_guild(#role_guild{gid = Gid, srv_id = SrvId, pid = Pid, name = Name}, Union) ->
    #guild_war_guild{pid = Pid, id = {Gid, SrvId}, name = Name, union = Union, is_union_chief = ?false}.

%% 将玩家转换为帮战玩家信息
to_guild_war_role(#role{id = Id, pid = Pid, name = Name, lev = Lev, guild = #role_guild{gid = Gid, srv_id = SrvId, position = Pos, name = Gname}, realm = Realm}) ->
    #guild_war_role{id = Id, pid = Pid, name = Name, lev = Lev, is_online = ?true, is_inwar = ?true, guild_id = {Gid, SrvId}, position = Pos, guild_name = Gname, realm = Realm}.

%% @spec select_roles(Conds, Groles, State) -> true | false
%% Conds = [term(), ...]
%% Groles = [#guild_war_role(), ...]
%% State = #guild_war{}
%% 根据条件选择帮战中玩家
select_roles(Cons, Roles, State) ->
    select_roles(Cons, Roles, State, []).
select_roles(_Cons, [], _State, Back) ->
    Back;
select_roles(Cons, [H | T], State, Back) ->
    case select_roles_cons(Cons, H, State) of
        true ->
            select_roles(Cons, T, State, [H | Back]);
        false ->
            select_roles(Cons, T, State, Back)
    end.
select_roles_cons([], _, _) ->
    true;
select_roles_cons([in_war | T], Grole = #guild_war_role{is_inwar = ?true}, State) ->
    select_roles_cons(T, Grole, State);
select_roles_cons([not_in_compete | T], Grole = #guild_war_role{is_compete = ?false}, State) ->
    select_roles_cons(T, Grole, State);
select_roles_cons([attacker | T], Grole = #guild_war_role{union = Union}, State = #guild_war{opp_flag = OppFlag}) ->
    case ?is_attacker(Union, OppFlag) of
        true ->
            select_roles_cons(T, Grole, State);
        false ->
            false
    end;
select_roles_cons(_, _, _) ->
    false.

%% 从帮会成员里找出帮主
get_guild_leader([]) ->
    false;
get_guild_leader([#guild_member{id = Id, position = ?guild_chief} | _]) ->
    Id;
get_guild_leader([_ | T]) ->
    get_guild_leader(T).

%% 处理帮战守护帮会buff
handle_buff(_, undefined) ->
    ok;
handle_buff(Type, Owner) ->
    case guild_mgr:lookup(by_id, Owner) of
        #guild{members = Members} ->
            handle_buff(role, Type, Members);
        _ ->
            ok
    end.

handle_buff(role, _, []) ->
    ok;
handle_buff(role, Type, [#guild_member{pid = Rpid} | T]) ->
    case guild_war_util:check([{is_pid_alive, Rpid}]) of
        ok ->
            role:apply(async, Rpid, {fun apply_handle_buff/2, [Type]}),
            handle_buff(role, Type, T);
        _ ->
            handle_buff(role, Type, T)
    end;
handle_buff(role, _, _) ->
    ok.

apply_handle_buff(Role, del) ->
    case buff:del_buff_by_label(Role, ?guild_war_winner_buffer) of
        false ->
            {ok};
        {ok, NewRole} ->
            ?debug_log([del_buff_success, {}]),
            {ok, NewRole}
    end;
apply_handle_buff(Role, add) ->
    case buff:add(Role, ?guild_war_winner_buffer) of
        {false, _Reason} ->
            {ok};
        {ok, NewRole} ->
            ?debug_log([add_buff_success, {}]),
            Nr2 = role_api:push_attr(NewRole),
            {ok, Nr2}
    end.

%% 处理称号
handle_honor(_Type, undefined) ->
    ok;
handle_honor(Type, Gid) ->
    case guild_mgr:lookup(by_id, Gid) of
        #guild{members = Members} ->
            handle_honor_guild(role, Type, Members);
        _ ->
            ok
    end.

handle_honor_guild(role, _Type, []) ->
    ok;
handle_honor_guild(role, Type, [#guild_member{pid = Rpid} | T]) ->
    case guild_war_util:check([{is_pid_alive, Rpid}]) of
        ok ->
            role:apply(async, Rpid, {fun apply_handle_honor/2, [Type]}),
            handle_honor_guild(role, Type, T);
        _ ->
            handle_honor_guild(role, Type, T)
    end;
handle_honor_guild(role, _, _) ->
    ok.

apply_handle_honor(Role = #role{looks = Looks}, del) ->
    ?debug_log([apply_handle_honor, del]),
    NewRole = Role#role{looks = lists:keydelete(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks)},
    map:role_update(NewRole),
    {ok, NewRole};
apply_handle_honor(Role = #role{guild = #role_guild{position = Pos}, looks = Looks}, add) ->
    ?debug_log([apply_handle_honor, add]),
    case Pos of
        ?guild_chief ->
            {ok};
        _ ->
            Glooks = {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_MEMBER},
            NewLooks = case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
                false ->
                    [Glooks | Looks];
                _ ->
                    lists:keyreplace(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks, Glooks)
            end,
            NewRole = Role#role{looks = NewLooks},
            map:role_update(NewRole),
            {ok, NewRole}
    end.

%% @spec day_diff(UnixTime, UnixTime) -> int()
%% @doc 两个unixtime相差的天数,相邻2天返回1
%% return int() 相差的天数
day_diff(FromTime, ToTime) when ToTime > FromTime ->
    FromDate = util:unixtime({today, FromTime}),
    ToDate = util:unixtime({today, ToTime}),
    case (ToDate - FromDate) / (3600 * 24) of
        Diff when Diff < 0 -> 0;
        Diff -> round(Diff)
    end;

day_diff(_FromTime, _ToTime) ->
    0.

%% --------------------------------------------------------------------
%% Internal funs
%% --------------------------------------------------------------------
%% 根据pid取角色
get_roles([], Back) ->
    Back;
get_roles([H | T], Back) ->
    case role_api:lookup(by_id, H) of
        {ok, _, Role} ->
            get_roles(T, [Role | Back]);
        _ ->
            get_roles(T, Back)
    end.

%% 取得多个玩家的总战斗力
get_fight_capacity(Roles) ->
    get_fight_capacity(Roles, 0).
get_fight_capacity([], Back) ->
    Back;
get_fight_capacity([#role{attr = #attr{fight_capacity = Fc}} | T], Back) ->
    get_fight_capacity(T, Back + Fc);
get_fight_capacity([_ | T], Back) ->
    get_fight_capacity(T, Back).


