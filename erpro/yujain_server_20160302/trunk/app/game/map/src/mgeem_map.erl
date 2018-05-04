%%%----------------------------------------------------------------------
%%% Author  : caochuncheng2002@gmail.com
%%% Created : 2013-05-14
%%% Description: 地图进程
%%%----------------------------------------------------------------------

-module(mgeem_map).

-behaviour(gen_server).

-include("mgeem.hrl").

-export([
         start_link/1,
         init/1, 
         handle_call/3, 
         handle_cast/2, 
         handle_info/2, 
         terminate/2, 
         code_change/3
        ]).
-export([
         get_now/0,
         get_now2/0,
         get_map_state/0,
         set_map_state/1,
         get_map_type/0,
         get_map_type/1,
         is_kf_map/0,
         is_kf_map/1
        ]).

get_now() ->
    erlang:get(now).

get_now2() ->
    erlang:get(now2).

get_map_state() ->
    erlang:get(map_state).
set_map_state(MapState) ->
    erlang:put(map_state, MapState).

%% 当前地图是否上跨服地图
is_kf_map() ->
    case get_map_type() of
        ?MAP_TYPE_CROSS ->
            true;
        _ ->
            false
    end.
is_kf_map(MapId) ->
    case cfg_map:get_map_info(MapId) of
        [#r_map_info{map_type = ?MAP_TYPE_CROSS}] ->
            true;
        _ ->
            false
    end.

%% 获取当前进程的地图类型
get_map_type() ->
    case mgeem_map:get_map_state() of
        #r_map_state{map_type = MapType} ->
            MapType;
        _ ->
            undefined
    end.

%% 根据配置读取地图的类型
get_map_type(MapId) ->
    case cfg_map:get_map_info(MapId) of
        [#r_map_info{map_type = MapType}] ->
            MapType;
        _ ->
            undefined
    end.
start_link({MapProcessName,MapId}) ->
    start_link({MapProcessName,MapId,0});
start_link({MapProcessName,MapId,FbId}) ->
    case get_map_type(MapId) of 
        ?MAP_TYPE_NORMAL ->
            gen_server:start_link({local,MapProcessName},?MODULE,[MapProcessName,MapId,FbId],[{spawn_opt,[{min_heap_size, 10*1024},{min_bin_vheap_size, 10*1024}]}]);
        ?MAP_TYPE_FB ->
            gen_server:start_link({local,MapProcessName},?MODULE,[MapProcessName,MapId,FbId],[{spawn_opt,[{min_heap_size, 2*1024},{min_bin_vheap_size, 2*1024}]}]);
        ErrMapType ->
            erlang:throw({error,map_type_error,ErrMapType})
    end.

%% --------------------------------------------------------------------
%% API for state lookup
%% --------------------------------------------------------------------


init([MapProcessName,MapId,FbId]) ->
    erlang:process_flag(trap_exit, true),
    erlang:put(now2, common_tool:now2()),
    erlang:put(now, common_tool:now()),
    init2(MapId,MapProcessName,FbId).
init2(MapId,MapProcessName,FbId)->
    %% 读取地图数据
    [#r_map_info{map_type=MapType,
				 offset_x=OffsetX,offset_y=OffsetY,
				 mcm_module=McmModule}] = cfg_map:get_map_info(MapId),
	%% 初始化地图可走格子数据
	mod_map:init_map_tile(MapId),
	%% 初始化地图九宫格数据
	mod_map:init_map_slice(MapId),
	%% 初始化地图进程State
    CreateTime = get_now(),
	MapState = #r_map_state{map_id=MapId,map_type = MapType,
                            map_pid=erlang:self(),
                            fb_id=FbId,
							offset_x=OffsetX,offset_y=OffsetY,
							map_process_name = MapProcessName,mcm_module=McmModule,
                            status = ?MAP_PROCESS_STATUS_INIT,
                            create_time=CreateTime},
    set_map_state(MapState),
    %%地图循环功能
    erlang:self() ! loop,
    erlang:self() ! loop_ms,
    %% 初始化进程字典数据 
    hook_map:init(MapId,MapProcessName,MapType,FbId,CreateTime),
    {ok, undefined}.
    
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({'EXIT', _PId, _Reason}, State) ->
    {stop, normal, State};

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State),
    {noreply, State}.

terminate(Reason, _State) ->
    hook_map:terminate(),
    ?TRY_CATCH(do_terminate(Reason),ExitErr),
    case Reason =:= normal of
        true ->
            ignore;
        false ->
            ?ERROR_MSG("~ts,Reason=~w,MapState=~w", [?_LANG_MAP_008,Reason,get_map_state()])
    end,
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


-define(MODULE_HANDLE_INFO(Module,HandleModule),
    do_handle_info({Module, Method, DataRecord, RoleId, PId, Line}) ->
    HandleModule:handle({Module, Method, DataRecord, RoleId, PId, Line})).
-define(MODULE_HANDLE_INFO(Module,Method,HandleModule),
    do_handle_info({Module, Method, DataRecord, RoleId, PId, Line}) ->
    HandleModule:handle({Module, Method, DataRecord, RoleId, PId, Line})).

do_handle_info(loop_ms) -> 
    erlang:send_after(200, self(), loop_ms),
    erlang:put(now2, common_tool:now2()),
    hook_map:loop_ms(),
    ok;
%%地图每秒大循环
do_handle_info(loop) ->
    erlang:send_after(1000, self(), loop),
    erlang:put(now, common_tool:now()),
    #r_map_state{map_id=MapId,map_type=MapType,fb_id=FbId,status=MapStatus} = MapState = get_map_state(),
    case MapType == ?MAP_TYPE_NORMAL andalso MapStatus == ?MAP_PROCESS_STATUS_INIT of
        true ->
            set_map_state(MapState#r_map_state{status=?MAP_PROCESS_STATUS_RUNNING});
        _ ->
            next
    end,
    hook_map:loop(MapId,MapType,FbId),
    case MapStatus of
        ?MAP_PROCESS_STATUS_CLOSE ->
            erlang:exit(erlang:self(), map_process_close);
        _ ->
            next
    end,
    ok;

do_handle_info({mod,Module,Info}) ->
    Module:handle(Info);

?MODULE_HANDLE_INFO(?MOVE,mod_move);
?MODULE_HANDLE_INFO(?MAP,?MAP_UPDATE_MAPINFO,mod_map_actor);
?MODULE_HANDLE_INFO(?MAP,mod_map_role);

%% 玩家网关进程关闭通知地图进程
do_handle_info({role_offline, RoleId, PId, Reason}) -> 
    mod_map_role:do_role_offline(RoleId,PId,Reason);

%% 异步执行函数
do_handle_info({async_exec, Fun, Args}) ->
    ?ERROR_MSG("Fun=~w,Args=~w",[Fun,Args]),
    ?TRY_CATCH(apply(Fun,Args),ErrFun),
    ok;

%% 执行函数处理
do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("Fun=~w,Args=~w,Ret=~w",[Fun,Args,Ret]),
    ok;
do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

%% 地图进程销毁处理
do_terminate(Reason) ->
    ?ERROR_MSG("map process terminate.Reason=~w,MapState=~w",[Reason,get_map_state()]).