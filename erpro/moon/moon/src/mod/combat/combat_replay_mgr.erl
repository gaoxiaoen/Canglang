%%----------------------------------------------------
%% 战斗录像管理器
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(combat_replay_mgr).
-behaviour(gen_server).

-export([
        start_link/0,
        save_replay/1,
        playback/3,
        save_replay_inform/1,
        clear_all_replay/0
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("combat.hrl").

-record(state, {
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 保存录像
%% Id = 自定义的录像ID
save_replay({Id, CombatType, RP_10710, RP_10720, RP_10721}) ->
    gen_server:cast(?MODULE, {save_replay, Id, CombatType, RP_10710, RP_10720, RP_10721}).

%% 播放录像
playback(ReplayId, RolePid, ConnPid) ->
    gen_server:cast(?MODULE, {playback, ReplayId, RolePid, ConnPid}).

%% 中央服发过来的保存录像通知
save_replay_inform(ZipReplay) ->
    gen_server:cast(?MODULE, {save_replay_inform, ZipReplay}).

%% 清除本服保存的所有录像
clear_all_replay() ->
    gen_server:cast(?MODULE, clear_all_replay).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    dets:open_file(combat_replay, [{file, "../var/combat_replay.dets"}, {keypos, #combat_replay.id}, {type, set}]),
    ets:new(combat_replay_cache, [set, named_table, public, {keypos, #combat_replay.id}]),
    State = #state{},
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({save_replay, Id, CombatType, RP_10710, RP_10720, RP_10721}, State) ->
    Replay = #combat_replay{id = Id, combat_type = CombatType, create_time = util:unixtime(), rp_10710 = RP_10710, rp_10720 = RP_10720, rp_10721 = RP_10721},
    %% TODO:观察下要不要spawn一个进程来保存录像
    dets:insert(combat_replay, Replay),
    %% 如果是中央服保存的播报，则下发到每个服
    case center:is_cross_center() of
        true ->
            ZipReplay = term_to_binary([Replay], [compressed]),
            c_mirror_group:cast(all, combat_replay_mgr, save_replay_inform, [ZipReplay]);
        false ->
            ignore
    end,
    {noreply, State};

handle_cast({save_replay_inform, ZipReplay}, State) ->
    case binary_to_term(ZipReplay) of
        [Replay = #combat_replay{id = _ReplayId}] ->
            ?DEBUG("收到中央服发来的战斗录像[Id=~w]，保存在本地", [_ReplayId]),
            dets:insert(combat_replay, Replay);
        _ -> ?ERR("收到中央服发过来的战斗录像，不过解压后内容不正确!")
    end,
    {noreply, State};

handle_cast({playback, ReplayId, RolePid, ConnPid}, State) ->
    case get_replay(ReplayId) of
        Replay when is_record(Replay, combat_replay) ->
            combat_replay:start_link(RolePid, Replay);
        err_ver ->
            notice:alert(error, ConnPid, ?MSGID(<<"该录像版本过时，无法播放">>));
        _ ->
            notice:alert(error, ConnPid, ?MSGID(<<"暂时没有该录像信息">>))
    end,
    {noreply, State};

handle_cast(clear_all_replay, State) ->
    dets:delete_all_objects(combat_replay),
    ets:delete_all_objects(combat_replay_cache),
    ?INFO("已清除本地所有的战斗录像"),
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

handle_info(Info, State) ->
    ?ERR("收到未知消息: ~w", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 查找录像 -> #combat_replay{} | undefined
get_replay(Id) ->
    case ets:lookup(combat_replay_cache, Id) of
        [Replay = #combat_replay{id = Id}] -> Replay;
        _ ->
            case dets:lookup(combat_replay, Id) of
                [Replay1 = #combat_replay{id = Id, version = ?COMBAT_REPLAY_VER}] ->
                    ets:insert(combat_replay_cache, Replay1),
                    Replay1;
                [#combat_replay{version = Ver}] when Ver =/= ?COMBAT_REPLAY_VER ->
                    err_ver;
                _ -> undefined
            end
    end.
