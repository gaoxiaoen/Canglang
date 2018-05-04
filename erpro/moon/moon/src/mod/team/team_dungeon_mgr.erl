%% ************************
%% 队伍副本招募管理进程
%% @author wpf wpf0208@jieyou.cn
%% ************************
-module(team_dungeon_mgr).
-export([
        get_dungeon_hall/1
    ]).
-export([start_link/0, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("team.hrl").

-record(dungeon_hall, {
        dung_id = 0
        ,hall_pid = 0
    }).

%% 一个副本NPC对应一个大厅进程
%% 玩家报名注册进入大厅，组队后生成房间

%% @spec get_dungeon_hall(DungId) -> {ok, Pid} | false
%% @doc 根据副本ID找到对应的大厅进程
get_dungeon_hall(DungId) ->
    %% TODO: 转换副本ID
    case ets:lookup(ets_dungeon_hall, DungId) of
        [#dungeon_hall{hall_pid = Pid}] -> {ok, Pid};
        _ -> false
    end.

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% @doc 创建副本招募管理进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% --------------------------------
%% 内部函数
%% --------------------------------
init_id() ->
    ?DUNGEON_HALL_ID.

%% 初始化副本大厅数据
init_hall() ->
    L = init_id(),
    do_init_hall(L).
do_init_hall([]) -> ok;
do_init_hall([DungBaseId | T]) ->
    case catch team_dungeon:start(DungBaseId) of
        {ok, Pid} -> 
            ets:insert(ets_dungeon_hall, #dungeon_hall{dung_id = DungBaseId, hall_pid = Pid});
        _ ->
            ignore
    end,
    do_init_hall(T).

%% ------------------------------
%% gen_server内部处理
%% ------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(ets_dungeon_hall, [public, named_table, {keypos, #dungeon_hall.dung_id}, set]),
    init_hall(),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, ok}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    ?DEBUG("忽略的异步消息：~w", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ?DEBUG("服务进程关闭"),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
