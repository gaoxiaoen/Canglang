%%%-----------------------------------
%%% @Module  : misc
%%% @Created : 2011.07.14
%%% @Description: 公共函数
%%%-----------------------------------
-module(misc).
-compile(export_all).
-include("common.hrl").

whereis_name(local, Atom) ->
    erlang:whereis(Atom);

whereis_name(global, Atom) ->
    global:whereis_name(Atom).

register(local, Name, Pid) ->
        catch erlang:unregister(Name),
    erlang:register(Name, Pid);

register(global, Name, Pid) ->
    global:re_register_name(Name, Pid).

unregister(local, Name) ->
    erlang:unregister(Name);

unregister(global, Name) ->
    global:unregister_name(Name).

is_process_alive(Pid) ->
    try
        if is_pid(Pid) ->
            case node(Pid) =:= node() of
                true ->
                    erlang:is_process_alive(Pid);
                false ->
                    case rpc:call(node(Pid), erlang, is_process_alive, [Pid]) of
                        {badrpc, _Reason} -> false;
                        Res -> Res
                    end
            end;
            true -> false
        end
    catch
        _:_ -> false
    end.

%% 玩家进程名
player_process_name(Pkey) ->
    util:list_to_atom2(lists:concat([p_, Pkey])).

%% 获取玩家进程
get_player_process(Pkey) ->
    misc:whereis_name(local, player_process_name(Pkey)).

%% 场景进程名字
scene_process_name(SceneId, Copy) ->
    Name =
        case is_pid(Copy) of
            false ->
                lists:concat([scene_agent_, SceneId, "_", Copy]);
            true ->
                lists:concat([scene_agent_, SceneId, "_", pid_to_list(Copy)])
        end,
    util:list_to_atom2(Name).

%% 获取场景进程
get_scene_process(SceneId, Copy) ->
    case scene_pid:get_scene_pid(SceneId, Copy) of
        false ->
            none;
%%            Key = scene_process_name(SceneId, Copy),
%%            misc:whereis_name(local, Key);
        Pid ->
            Pid

    end.


scene_mark_name(SceneId) ->
    Name = lists:concat([scene_mark_, SceneId]),
    util:list_to_atom2(Name).


get_scene_mark_process(SceneId) ->
    Key = scene_mark_name(SceneId),
    misc:whereis_name(local, Key).


%%取消gen_server定时器
cancel_timer(TimerKey) ->
    case get(TimerKey) of
        undefined ->
            skip;
        Timer ->
            erlang:erase(TimerKey),
                catch erlang:cancel_timer(Timer)
    end.

%%获取gen_server定时器时间
read_timer(TimerKey) ->
    case get(TimerKey) of
        undefined ->
            false;
        TimerRef ->
            try
                erlang:read_timer(TimerRef)
            catch
                _:_ ->
                    false
            end
    end.


%% 生成唯一key 19位，使用bigint范围值
unique_key() ->
    keygen:get_unique_key().

%% 玩家key，11位，使用int范围值
player_key() ->
    keygen:get_player_key().

%%获取系统自增id,整型
unique_key_auto() ->
    keygen:get_auto_key().

test(N) ->
    timer:tc(?MODULE, t1, [N]).

test2(N) ->
    timer:tc(?MODULE, t2, [N]).

t1(0) -> ok;
t1(N) ->
    unique_key(),
    t1(N - 1).

t2(0) -> ok;
t2(N) ->
    keygen:priv_gen_key(19),
    t2(N - 1).


%% 获取pid
get_server_pid(CrossMode, Mod) -> get_server_pid(CrossMode, Mod, Mod).
get_server_pid(CrossMode, Key, Mod) ->
    case get(Key) of
        Pid when is_pid(Pid) -> Pid;
        _ ->
            Pid =
                case config:is_center_node() of
                    true ->
                        erlang:whereis(Mod);
                    _ ->
                        Node = apply(CrossMode, get_node, []),
                            catch rpc:call(Node, erlang, whereis, [Mod])
                end,
            case is_pid(Pid) of
                true ->
                    put(Mod, Pid),
                    Pid;
                false ->
                    warning_pid_fail(Mod, Pid),
                    undefined
            end
    end.


warning_pid_fail(Mod, Pid) ->
    case config:is_debug() of
        true ->
%%             ?PRINT("get_server_pid fail ~w/~w ", [Mod,Pid]);
            ok;
        _ ->
            ?WARNING("get_server_pid fail ~w/~w ", [Mod, Pid])
    end.














