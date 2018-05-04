%% ************************
%% 组队管理进程
%% wpf wpf0208@jieyou.cn
%% ************************
-module(team_mgr).
-behaviour(gen_server).
-export([
        start_link/0
        ,create_team/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("role.hrl").
-include("team.hrl").
%%

-record(state, {
        auto_id = 1         %% 用于获取队伍ID，自增
    }).

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Pid = pid()
%% Error = string()
%% @doc 创建队伍管理器
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @spec create_team(Member) -> Pid | {fasle, Reason}
%% Member = #team_member{} | #role{}
%% @doc 创建队伍
create_team(Role = #role{ride = Ride}) ->
    {ok, Member} = role_convert:do(to_team_member, Role),
    Team = #team{
        ride = Ride
        ,leader = Member#team_member{mode = ?MODE_NORMAL}
    },
    gen_server:call(?MODULE, {create_team, Team});
create_team(Team) when is_record(Team, team) ->
    gen_server:call(?MODULE, {create_team, Team});
create_team(_) ->
    ?ERR("创建队伍传入参数是错误的"),
    {false, ?L(<<"创建队伍失败">>)}.

%% *****************************
%% 内部接口
%% *****************************

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(ets_team_member, [{keypos, #member_global.member_id}, named_table, public, set]),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% 创建队伍进程
handle_call({create_team, Team}, _From, State = #state{auto_id = TeamId}) ->
    NewTeam = Team#team{team_id = TeamId},
    case catch team:start(NewTeam) of
        {ok, Pid} -> {reply, Pid, State#state{auto_id = TeamId + 1}};
        _ -> {reply, {false, ?L(<<"创建队伍失败">>)}, State}
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% TODO: 暂时不能捕获信息
handle_info({'EXIT', Pid, Why}, State) ->
    ?ERR("队伍进程[~w]异常挂掉: ~w", [Pid, Why]),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
