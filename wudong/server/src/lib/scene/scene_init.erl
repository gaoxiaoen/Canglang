%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 场景agent初始化进程
%%% @end
%%% Created : 30. 七月 2015 下午7:58
%%%-------------------------------------------------------------------
-module(scene_init).
-author("fancy").

-behaviour(gen_server).

-include("common.hrl").
-include("scene.hrl").
%% API
-export([start_link/0]).
%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

-export([create_scene/2, stop_scene/2]).
-export([priv_create_scene/2, priv_stop_scene/2]).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

create_scene(SceneId, Copy) ->
    ?CALL(get_server_pid(), {create_scene, SceneId, Copy}).

stop_scene(SceneId, Copy) ->
    get_server_pid() ! {stop_scene, SceneId, Copy}.

%%获取进程PID
get_server_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    lists:foreach(fun(Scene) ->
%%      深渊魔宫直接启动两条线
        scene_mark:start_link(Scene),
        IsDark = scene:is_cross_dark_blibe(Scene),
        case IsDark of
            true ->
                scene_agent:start_link(Scene, 0, 0),
                scene_agent:start_link(Scene, 0, 1);
            _ ->
                scene_agent:start_link(Scene, 0, 0)
        end
                  end,
        data_scene:get_all_scene_id()),
    {ok, #state{}}.

handle_call({create_scene, SceneId, Copy}, _FROM, State) ->
    priv_create_scene(SceneId, Copy),
    {reply, ok, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.


handle_cast(_Request, State) ->
    {noreply, State}.



handle_info({stop_scene, SceneId, Copy}, State) ->
    priv_stop_scene(SceneId, Copy),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.


terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
priv_create_scene(SceneId, Copy) ->
    erase(?SCENE_PID(SceneId, Copy)),
%%    ?WARNING("create scene ~p copy ~p~n", [SceneId, Copy]),
    case scene:get_scene_pid(SceneId, Copy) of
        Pid when is_pid(Pid) ->
            ?ERR("create same scene fail ~p/~p~n", [SceneId, Copy]),
            ok;
        _ ->
            case is_pid(Copy) of
                false ->
                    scene_agent:start(SceneId, 0, Copy);
                true ->
                    case scene_pid:check_scene_pid(SceneId, Copy) of
                        false ->
                            scene_agent:start(SceneId, 0, Copy);
                        true ->
                            ok
                    end
            end
    end.

priv_stop_scene(SceneId, Copy) ->
    case scene:get_scene_pid(SceneId, Copy) of
        Pid when is_pid(Pid) andalso Copy /= 0 ->
            erase(?SCENE_PID(SceneId, Copy)),
            spawn(fun() -> util:sleep(1000), scene_pid:delete_scene_pid(SceneId, Copy) end),
            ok;
        _Err ->
            erase(?SCENE_PID(SceneId, Copy)),
            ?DEBUG("stop Err ~p~n", [_Err]),
            ok
    end.
