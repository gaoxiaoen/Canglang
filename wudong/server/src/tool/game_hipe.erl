%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 转换beam成native模式 v1.0
%%% @end
%%% Created : 28. 十二月 2016 下午8:09
%%%-------------------------------------------------------------------
-module(game_hipe).
-author("fancy").
-include("common.hrl").

%% API
-define(HIPE_PROCESSES, 2).
-define(HIPE_COMPILE_INFO_KEY,"HIPE_COMPILE_COUNT").

-export([maybe_hipe_compile/0,log_hipe_result/1]).
-export([hipe/0,hipe/1,compile/0]).
-export([can_hipe_compile/0]).
-export([get_beam_files/0]).
-export([t1/1,t2/2]).

%% Compile and load during server startup sequence
maybe_hipe_compile() ->
    Want = config:is_use_hipe(),
    case {Want, can_hipe_compile()} of
        {true,  true}  -> hipe();
        {true,  false} -> false;
        {false, _}     -> {ok, disabled}
    end.

log_hipe_result({ok, disabled}) ->
    ok;
log_hipe_result({ok, already_compiled}) ->
    ?PRINT(
        "HiPE in use: modules already natively compiled.~n", []);
log_hipe_result({ok, Count, Duration}) ->
    ?PRINT(
        "HiPE in use: compiled ~B modules in ~Bs.~n", [Count, Duration]);
log_hipe_result(false) ->
    ?PRINT(
        "~nNot HiPE compiling: HiPE not found in this Erlang installation.~n"),
    ?PRINT(
        "Not HiPE compiling: HiPE not found in this Erlang installation.~n").

% ------- API ---------
hipe() ->
    hipe_compile(fun compile_and_load/1, false,base_hipe_mod()).

hipe(Mod) ->
    compile_and_load(Mod).

compile() ->
    compile_to_directory().

% ------- ++ ——————————

needs_compilation(Mod, Force) ->
    Exists = code:which(Mod) =/= non_existing,
    NotYetCompiled = not already_hipe_compiled(Mod),
    NotVersioned = not compiled_with_version_support(Mod),
    Exists andalso (Force orelse (NotYetCompiled andalso NotVersioned)).

hipe_compile(CompileFun, Force,TargetMod) ->
   %% HipeModulesAll = [battle,scene_agent,player],
    HipeModulesAll = ?IF_ELSE(TargetMod =/= [] ,TargetMod,get_beam_files()),
    HipeModules = lists:filter(fun(Mod) -> needs_compilation(Mod, Force) end, HipeModulesAll),
    case HipeModules of
        [] -> {ok, already_compiled};
        _  -> do_hipe_compile(HipeModules, CompileFun)
    end.

%%编译到ebin目录
compile_to_directory() ->
    hipe_compile(fun (Mod) -> compile_and_save(Mod, "../ebin/") end, true,[]).

compile_and_save(Module, Dir) ->
    case not lists:member(Module,get_sys_mod()) of
        true ->
            {Module, BeamCode, _} = code:get_object_code(Module),
            BeamName = filename:join([Dir, atom_to_list(Module) ++ ".beam"]),
            {ok, {Architecture, NativeCode}} = hipe:compile(Module, [], BeamCode, [o3]),
            {ok, _, Chunks0} = beam_lib:all_chunks(BeamCode),
            ChunkName = hipe_unified_loader:chunk_name(Architecture),
            Chunks1 = lists:keydelete(ChunkName, 1, Chunks0),
            Chunks = Chunks1 ++ [{ChunkName,NativeCode}],
            {ok, BeamPlusNative} = beam_lib:build_module(Chunks),
            ok = file:write_file(BeamName, BeamPlusNative),
            BeamName;
        false ->
            skip
    end.


already_hipe_compiled(Mod) ->
    try
        %% OTP 18.x or later
        Mod:module_info(native) =:= true
        %% OTP prior to 18.x
    catch error:badarg ->
        code:is_module_native(Mod) =:= true
    end.

compiled_with_version_support(Mod) ->
    proplists:get_value(erlang_version_support, Mod:module_info(attributes))
        =/= undefined.

do_hipe_compile(HipeModules, CompileFun) ->
    Count = length(HipeModules),
    io:format("~nHiPE compile files:~p~n", [Count]),
    reset_compile_info(),
    F = fun(Mod) ->
        CompileFun(Mod),
        show_compile_info(Count)
        end,
    lists:foreach(F,HipeModules),
    io:format("Compiled ~B modules~n", [Count]),
    ok.

split(L, N) -> split0(L, [[] || _ <- lists:seq(1, N)]).

split0([],       Ls)       -> Ls;
split0([I | Is], [L | Ls]) -> split0(Is, Ls ++ [[I | L]]).

compile_and_load(Mod) ->
    {Mod, Beam, _} = code:get_object_code(Mod),
    {ok, _} = hipe:compile(Mod, [], Beam, [o3, load]).


can_hipe_compile() ->
    code:which(hipe) =/= non_existing.


get_beam_files() ->
    case file:list_dir("../ebin") of
        {ok,FileList} ->
            F = fun(File,List) ->
                case string:tokens(File,".") of
                    [Mod,"beam"] ->
                           [util:to_atom(Mod)|List];
                    _ ->
                        List
                end
            end,
            lists:foldl(F,[],FileList);
        _ ->
            []
    end.

reset_compile_info() ->
    erase(?HIPE_COMPILE_INFO_KEY).

show_compile_info(Total) ->
    Compiled =
        case get(?HIPE_COMPILE_INFO_KEY) of
            undefined ->
                put(?HIPE_COMPILE_INFO_KEY,1),
                1;
            N ->
                put(?HIPE_COMPILE_INFO_KEY,N + 1)
        end,
    io:format("|+++|Compiled: ~s~n", [lists:concat([Compiled,"/",Total])]).


%%性能测试函数
t1(N) ->
    T1 = util:longunixtime(),
    f(N,0),
    T2 = util:longunixtime(),
    Total = T2 - T1,
    io:format("sum:~p~n",[Total]).

t2(N,Porcess) ->
    PidMRefs = [spawn_monitor(fun () -> [begin
                                             f(N,0)
                                         end || _M <- Ms]
    end) ||
        Ms <- split(lists:seq(1,Porcess), Porcess)],
    T1 = util:longunixtime(),
    [receive
         {'DOWN', MRef, process, _, normal} -> ok;
         {'DOWN', MRef, process, _, Reason} -> exit(Reason)
     end || {_Pid, MRef} <- PidMRefs],
    T2 = util:longunixtime(),
    Total = T2 - T1,
    io:format("sum:~p~n",[Total]).

f(0,_Sum) -> ok;
f(N,Sum) ->
    Sum0 = N + 100000 + N*100 - N/10,
    f(N - 1,Sum + Sum0).

%%不编译游戏系统模块成native
get_sys_mod() ->
    [
        db,game,game_alarm_handler,game_db_sup,game_http,game_http_routing,game_http_sup,game_secure,game_server_app,game_sup,game_tcp_acceptor,
        game_tcp_acceptor_sup,game_tcp_client,game_tcp_client_sup,game_tcp_listener,game_tcp_listener_sup,mochifmt,mochifmt_records,mochifmt_std,
        mochiglobal,mochihex,mochijson,mochjson2,mochilists,mochilogfile2,mochinum,mochitemp,mochiutf8,mochiweb,mochiweb_acceptor,mochiweb_base64url,
        mochiweb_charref,mochiweb_cookies,mochiweb_cover,mochiweb_echo,mochiweb_headers,mochiweb_html,mochiweb_http,mochiweb_io,mochiweb_mime,
        mochiweb_multipart,mochiweb_request,mochiweb_request_tests,mochiweb_response,mochiweb_session,mochiweb_socket,mochiweb_socket_server,
        mochiweb_util,mysql,mysql_cache,mysql_encode,mysql_poolboy,mysql_poolboy_sup,mysql_protocol,poolboy,poolboy_sup,poolboy_worker,proto,reloader,
        rand_compat,time_compat,code_version
    ].

%%基础hipe模块
base_hipe_mod() ->
    [
        %%系统模块
        lists,io_lib,io,timer,gen_server,
        %%sys模块
        db,game,poolboy,mysql_poolboy,mysql,
        %%游戏模块
        player,player_util,player_rpc,player_handle,player_battle,player_init,player_login,player_load,player_pack,player_view,
        goods,goods_init,goods_load,goods_use,goods_util,goods_rpc,goods_dict,goods_pack,
        scene,scene_agent,scene_agent_info,scene_agent_dispatch,scene_mark,scene_calc,scene_pack,mon_agent,
        battle,battle_pack,battle_util,battle_rpc,
        arena_proc,arena,
        timer_hour,timer_day,timer_minute ,
        util,misc,
        monster
    ].

