%% ************************
%% 队伍副本招募
%% @author wpf wpf0208@jieyou.cn
%% ************************
-module(team_dungeon).
-export([
        register_to_hall/2
        ,cancel_register/2
        ,cancel_register/1
        ,get_team_list/1
        ,get_role_list/1
        ,pack_proto_msg/3
    ]).
-export([start/1, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("role.hrl").
-include("team.hrl").
-include("attr.hrl").
%%

%% 玩家注册：1、有队伍，注册队伍放假; 2、无队伍注册单人房间
%% 进入队伍：取消单人报名，进入队伍房间（房主注册，成员不注册）

%% @spec register_to_hall(Role, DungId) -> ok | {false, Msg}
%% @doc 报名注册到一个副本大厅
%% 注册 某个队伍/玩家 到副本大厅
register_to_hall(Role = #role{team_pid = TeamPid, team = #role_team{team_id = TeamId, is_leader = ?true}, dungeon = Dung}, DungId) ->
    DungGroupId = map_dungeon_id(DungId),
    {EnterCount, LimitCount} = dungeon_api:get_dungeon_count_and_limit(Dung, DungId),
    case EnterCount < LimitCount of
        true ->
            case team_api:get_team_info(TeamPid) of
                {ok, TeamInfo = #team{team_id = TeamId, leader = Leader, member = Members}} ->
                    case length([Leader | Members]) of
                        Num when Num < 3 ->
                            TeamRoom = convert(Role, TeamInfo, EnterCount),
                            case team_dungeon_mgr:get_dungeon_hall(DungGroupId) of
                                {ok, Pid} ->
                                    ?DEBUG("[Name: ~s]选择副本~w注册", [Role#role.name, DungGroupId]),
                                    Pid ! {register, TeamRoom};
                                _ ->
                                    ?DEBUG("未找到副本~w", [DungGroupId]),
                                    ignore
                            end;
                        _ -> ignore
                    end,
                    ok;
                _ -> {false, ?L(<<"你还没有队伍，不能报名房间">>)}
            end;
        false ->
            {false, ?L(<<"您当天进入该副本次数已满">>)}
    end;
register_to_hall(#role{team = #role_team{is_leader = ?false}}, _DungId) ->
    ok;
register_to_hall(Role = #role{dungeon = Dung}, DungId) -> %% 附近玩家注册
    DungGroupId = map_dungeon_id(DungId),
    {EnterCount, LimitCount} = dungeon_api:get_dungeon_count_and_limit(Dung, DungId),
    case EnterCount < LimitCount of
        true ->
            RoleInfo = convert(Role, EnterCount),
            case team_dungeon_mgr:get_dungeon_hall(DungGroupId) of
                {ok, Pid} ->
                    ?DEBUG("[Name:~s]选择副本~w注册", [Role#role.name, DungId]),
                    Pid ! {register, RoleInfo};
                _ ->
                    ?DEBUG("未找到副本~w", [DungId]),
                    ignore
            end;
        false ->
            ignore
    end,
    ok.

%% @spec cancel_register(Role, DungId) -> ok | {false, Reason}
%% @spec cancel_register(Team) -> ok | {false, Reason}
%% @doc 取消一个注册
%% <div>
%% 队伍房间的注销由队长客户端控制请求
%% 队员请求取消时，要清掉其个人房间的信息
%% </div>
cancel_register(_R = #role{team_pid = TeamPid, team = #role_team{team_id = TeamId, is_leader = ?true}}, Id)
when is_pid(TeamPid) ->
    %% ?DEBUG("[Name:~s]请求取消报名", [_R#role.name]),
    DungId = map_dungeon_id(Id),
    case team_dungeon_mgr:get_dungeon_hall(DungId) of
        {ok, Pid} ->
            Pid ! {cancel, {team, TeamId}},
            ok;
        _ -> {false, ?L(<<"该副本招募大厅已关闭">>)}
    end;
cancel_register(_R = #role{id = RoleId}, Id) ->
    %% ?DEBUG("[Name:~s]请求取消报名, 其没有队伍或者不是队长", [_R#role.name]),
    DungId = map_dungeon_id(Id),
    case team_dungeon_mgr:get_dungeon_hall(DungId) of
        {ok, Pid} ->
            Pid ! {cancel, {role, RoleId}},
            ok;
        _ -> {false, ?L(<<"该副本招募大厅已关闭">>)}
    end.
%% 队伍解散，通知注销
cancel_register(#team{dung_id = 0}) -> ignore;
cancel_register(#team{team_id = TeamId, dung_id = DungId}) ->
    ToDungId = map_dungeon_id(DungId),
    case team_dungeon_mgr:get_dungeon_hall(ToDungId) of
        {ok, Pid} ->
            Pid ! {cancel, {team, TeamId}};
        _ ->
            {false, <<>>}
    end.

%% @spec get_role_list(DungId) -> list()
%% @doc 获取对应副本大厅的报名玩家列表
get_role_list(Id) ->
    DungId = map_dungeon_id(Id),
    case team_dungeon_mgr:get_dungeon_hall(DungId) of
        {ok, Pid} ->
            %% ?DEBUG("找到副本ID:~w", [DungId]),
            gen_server:call(Pid, get_role_list);
        _ ->
            ?DEBUG("未找到请求副本ID:~w", [DungId]),
            []
    end.

%% @spec get_team_list(DungId) -> list()
%% @doc 获取对应副本大厅的报名玩家列表
get_team_list(Id) ->
    DungId = map_dungeon_id(Id),
    case team_dungeon_mgr:get_dungeon_hall(DungId) of
        {ok, Pid} ->
            %% ?DEBUG("找到副本ID:~w", [DungId]),
            gen_server:call(Pid, get_team_list);
        _ ->
            ?DEBUG("未找到请求副本ID:~w", [DungId]),
            []
    end.

%% @spec pack_proto_msg(Proto, Msg) -> Data
%% @doc 打包消息
pack_proto_msg(10855, #role{team = #role_team{team_id = TeamId}}, TeamList) ->
    Fun = fun(#team_room{leader = #role_regist{id = {Id, SrvId}, name = Name, fight = Fight, lev = Lev, sex = Sex, count = Cnt}, num = Num}) ->
            {Id, SrvId, Name, Fight, Lev, Sex, Num, Cnt};
        (_) ->
            {0, <<>>, <<>>, 0, 0, 0, 0, 0}
    end,
    Fun1 = fun(#team_room{team_id = Tid}) when Tid =:= TeamId ->
            false;
        (_) -> true
    end,
    {[Fun(X) || X <- TeamList, Fun1(X)]};
pack_proto_msg(10855, _, TeamList) ->
    Fun = fun(#team_room{leader = #role_regist{id = {Id, SrvId}, name = Name, fight = Fight, lev = Lev, sex = Sex, count = Cnt}, num = Num}) ->
            {Id, SrvId, Name, Fight, Lev, Sex, Num, Cnt};
        (_) ->
            {0, <<>>, <<>>, 0, 0, 0, 0, 0}
    end,
    {[Fun(X) || X <- TeamList]};
pack_proto_msg(10856, #role{id = Rid}, RoleList) ->
    Fun = fun(#role_regist{id = {Id, SrvId}, name = Name, fight = Fight, lev = Lev, sex = Sex, career = Career, count = Cnt}) ->
            {Id, SrvId, Name, Fight, Lev, Sex, Career, Cnt};
        (_) ->
            {0, <<>>, <<>>, 0, 0, 0, 0, 0}
    end,
    Fun1 = fun(#role_regist{id = Id}) when Id =:= Rid ->
            false;
        (_) -> true
    end,
    {[Fun(X) || X <- RoleList, Fun1(X)]};
pack_proto_msg(_P, _R, _L) ->
    ?ERR("协议生成出错[Proto:~w, RoleTeam:~w, List:~w]", [_P, _R#role.team, _L]),
    {[]}.

%% @spec start() -> {ok,Pid} | ignore | {error,Error}
%% @doc 创建副本招募管理进程
start(DungId) ->
    gen_server:start(?MODULE, [DungId], []).

%% --------------------------------
%% 内部函数
%% --------------------------------
%% 映射副本组ID
map_dungeon_id(20001) -> 20000;
map_dungeon_id(20002) -> 20000;
map_dungeon_id(20003) -> 20000;
map_dungeon_id(20004) -> 20000;
map_dungeon_id(20005) -> 20000;
map_dungeon_id(DungId) -> DungId.

%% 注册
do_register(TR = #team_room{team_id = TeamId, team_pid = TeamPid, leader = #role_regist{id = Id}},
    State = #team_hall{dung_id = DungId, role_list = RoleList, team_list = TeamList}) ->
    NewTeamList = case lists:keyfind(TeamId, #team_room.team_id, TeamList) of
        false ->
            [TR | TeamList];
        #team_room{} ->
            lists:keyreplace(TeamId, #team_room.team_id, TeamList, TR)
    end,
    NewRoleList = lists:keydelete(Id, #role_regist.id, RoleList), %% 先清掉个人房间的报名
    team:update_dungeon_hall(TeamPid, DungId, ?true),
    State#team_hall{role_list = NewRoleList, team_list = NewTeamList};
do_register(RR = #role_regist{id = Id}, State = #team_hall{role_list = List}) ->
    NewRoleList = case lists:keyfind(Id, #role_regist.id, List) of
        false ->
            [RR | List];
        #role_regist{} ->
            lists:keyreplace(Id, #role_regist.id, List, RR)
    end,
    State#team_hall{role_list = NewRoleList};
do_register(_, State) ->
    State.

%% 注销
do_cancel({team, TeamId}, State = #team_hall{dung_id = DungId, team_list = List}) ->
    NewList = case lists:keyfind(TeamId, #team_room.team_id, List) of
        false -> List;
        #team_room{team_pid = TeamPid} ->
            team:update_dungeon_hall(TeamPid, DungId, ?false),
            lists:keydelete(TeamId, #team_room.team_id, List)
    end,
    State#team_hall{team_list = NewList};
do_cancel({role, Id}, State = #team_hall{role_list = List}) ->
    NewList = lists:keydelete(Id, #role_regist.id, List),
    State#team_hall{role_list = NewList};
do_cancel(_, State) ->
    State.

%% 信息转换
convert(#role{pid = Pid, id = Id, name = Name, lev = Lev, career = Career, attr = #attr{fight_capacity = Fight}}, EnterCount) ->
    #role_regist{
        id = Id, name = Name, fight = Fight, lev = Lev, career = Career,
        count = EnterCount, pid = Pid
    }.
convert(Role, #team{team_id = TeamId, team_pid = TeamPid, member = Members}, EnterCount) ->
    #team_room{
        team_id = TeamId, team_pid = TeamPid
        ,leader = convert(Role, EnterCount)
        ,num = length(Members) + 1
    }.

%% 冗余数据检查
check_gc(State = #team_hall{team_list = TeamList, role_list = RoleList}) ->
    erlang:send_after(10 * 1000, self(), check_gc),
    NewTeamList = do_check(TeamList, []),
    NewRoleList = do_check(RoleList, []),
    State#team_hall{team_list = NewTeamList, role_list = NewRoleList}.
do_check([], L) -> lists:reverse(L);
do_check([H = #team_room{team_pid = TeamPid} | T], L) ->
    NewL = case is_pid(TeamPid) andalso is_process_alive(TeamPid) of
        true ->
            [H | L];
        false ->
            L
    end,
    do_check(T, NewL);
do_check([H = #role_regist{pid = Pid} | T], L) ->
    NewL = case is_pid(Pid) andalso is_process_alive(Pid) of
        true ->
            [H | L];
        false ->
            L
    end,
    do_check(T, NewL);
do_check([_ | T], L) ->
    do_check(T, L).


%% ------------------------------
%% gen_server内部处理
%% ------------------------------

init([DungId]) ->
    %% ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    State = #team_hall{dung_id = DungId},
    check_gc(State),
    %% ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

%% 获取大厅房间信息
handle_call(get_role_list, _, State = #team_hall{role_list = L}) ->
    {reply, L, State};
handle_call(get_team_list, _, State = #team_hall{team_list = L}) ->
    {reply, L, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 注册
handle_info({register, Info}, State) ->
    NewState = do_register(Info, State),
    %% ?DEBUG("注册成功：~w", [NewState]),
    {noreply, NewState};
% 取消注册
handle_info({cancel, Info}, State) ->
    %% ?DEBUG("取消报名：~w", [Info]),
    NewState = do_cancel(Info, State),
    %% ?DEBUG("取消成功：~w", [NewState]),
    {noreply, NewState};

%% 检查
handle_info(check_gc, State) ->
    NewState = check_gc(State),
    {noreply, NewState};

handle_info(_Info, State) ->
    ?DEBUG("忽略的异步消息：~w", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
