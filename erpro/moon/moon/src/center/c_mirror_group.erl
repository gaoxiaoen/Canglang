%%----------------------------------------------------
%% 远端服务器镜像分组管理
%% （提供广播等功能）
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(c_mirror_group).
-behaviour(gen_server).
-export([
        start_link/0,
        cast/4,
        cast/5,
        call/5,
        add_mirror/8,
        del_mirror/2,
        restart_mirror/1,
        list_all_data/0,
        get_all_platforms/0,
        get_platform/1,
        update_mirror_data/0,
        update_mirror_data/1,
        clear_mirror_data/0,
        get_all_mirror_data/0,
        print_disconnected_mirrors/0,
        get_all_connected_mirrors/0,
        get_merge_dest_srv_id/1,
        add_to_merge_srv_mapping/1,
        add_to_merge_srv_mapping/2,
        get_all_dest_srv_id/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("center.hrl").

-record(state, {
    }).

%% ----------------------------------------------------
%% 对外接口
%% ----------------------------------------------------
%% @spec start_link() -> {ok, Pid} | {error, Reason}
%% @doc 创建镜像服务器群组管理进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @spec add_mirror(SrvId, SrvIds, Platform, Name, Node, Host, Ver, Cookie) -> ok
%% @doc 增加一个镜像服务器
add_mirror(SrvId, SrvIds, Platform, Name, Node, Host, Ver, Cookie) ->
    Mirror = #mirror_data{
        srv_id = SrvId
        ,srv_ids = SrvIds
        ,platform = Platform
        ,name = Name
        ,node = Node
        ,host = Host
        ,ver = Ver
        ,cookie = Cookie
    },
    gen_server:cast(?MODULE, {add_mirror, Mirror}).

%% @spec del_mirror(srv_id, SrvId) -> ok
%% @doc 删除一个镜像服务器
del_mirror(srv_id, SrvId) ->
    gen_server:cast(?MODULE, {del_mirror, srv_id, SrvId});
%% @spec del_mirror(platform, Platform) -> ok
%% Platform = bitstring()
%% @doc 删除整个平台的镜像服务器
del_mirror(platform, Platform) ->
    gen_server:cast(?MODULE, {del_mirror, platform, Platform}).

%% @spec restart_mirror(SrvId) -> ok
%% SrvId = bitstring()
%% @doc 重启一个镜像服务器
restart_mirror(SrvId) ->
    gen_server:cast(?MODULE, {restart_mirror, SrvId}).

%% @spec all_data() -> ok
%% @doc 列出所有的镜像服务器
list_all_data() ->
    gen_server:cast(?MODULE, list_all_data).


%% @spec cast(all, M, F, A) -> ok
%% @doc 广播消息到所有远端服务器
cast(all, M, F, A) ->
    gen_server:cast(?MODULE, {cast, all, M, F, A}).

%% @spec cast(platform, Platforms, M, F, A) ->
%% Platforms = [Platform | ...]
%% Platform = bitstring()
%% @doc 广播消息到指定平台
cast(platform, Platforms, M, F, A) ->
    gen_server:cast(?MODULE, {cast, platform, Platforms, M, F, A});

%% @spec cast(node, SrvId, M, F, A) -> ok
%% @doc 发送异步消息到指定srv_id的远端服务器
cast(node, SrvId, M, F, A) ->
    DestSrvId = get_merge_dest_srv_id(SrvId),
    case ets:lookup(mirror_online, DestSrvId) of
        %% 目标服务器没连接到中央服
        [#mirror{node = Node, mpid = Mpid}] when is_pid(Mpid) ->
            rpc:cast(Node, M, F, A);
        _ -> ?DEBUG("中央服还没有连接上[~s]，无法发送该异步消息[~w, ~w, ~w]", [SrvId, M, F, A])
    end.

%% @spec call(node, SrvId, M, F, A) -> ok | {error, Reason}
%% @doc 发送同步消息到指定srv_id的远端服务器
call(node, SrvId, M, F, A) ->
    DestSrvId = get_merge_dest_srv_id(SrvId),
    case ets:lookup(mirror_online, DestSrvId) of
        %% 目标服务器没连接到中央服
        [#mirror{node = Node, mpid = Mpid}] when is_pid(Mpid) ->
            rpc:call(Node, M, F, A);
        _ ->
            ?ERR("中央服还没有连接上[~s]，无法发送该同步消息[~w, ~w, ~w]", [SrvId, M, F, A]),
            {error, not_connected}
    end.

%% 获取所有的镜像服务器所在平台 -> [<<"">>]
get_all_platforms() ->
    case sys_env:get(platform_list) of
        undefined -> [];
        L -> L
    end.

%% 根据srv_id获取平台id -> bitstring() | undefined
get_platform(SrvId) ->
    DestSrvId = get_merge_dest_srv_id(SrvId),
    L = get_all_mirror_data(),
    case lists:keyfind(DestSrvId, #mirror_data.srv_id, L) of
        false -> undefined;
        #mirror_data{platform = Platform} -> Platform
    end.

%% 获取合服后的目标srv_id（如果没有合服，则返回自己）
get_merge_dest_srv_id(SrvId) ->
    Mapping = get_merge_srv_mapping(),
    case lists:keyfind(SrvId, 1, Mapping) of
        {SrvId, DestSrvId} -> DestSrvId;
        _ -> SrvId
    end.

%% 添加合服映射
add_to_merge_srv_mapping(SrvId, DestSrvId) ->
    Mapping = get_merge_srv_mapping(),
    do_add_to_merge_srv_mapping(SrvId, DestSrvId, Mapping, []).
do_add_to_merge_srv_mapping(SrvId, DestSrvId, [], Left) ->
    sys_env:save(merge_srv_mapping, [{SrvId, DestSrvId}|Left]);
do_add_to_merge_srv_mapping(SrvId, DestSrvId, [{SrvId, _}|T], Left) ->
    do_add_to_merge_srv_mapping(SrvId, DestSrvId, T, Left);
do_add_to_merge_srv_mapping(SrvId, DestSrvId, [R|T], Left) ->
    do_add_to_merge_srv_mapping(SrvId, DestSrvId, T, [R|Left]).

%% 重新加载镜像服务器配置列表
%% MirrorDataList = [#mirror_data{}]
update_mirror_data(MirrorDataList) ->
    ?DEBUG("MirrorDataList=~w", [MirrorDataList]),
    gen_server:cast(?MODULE, {update_mirror_data, MirrorDataList}).

update_mirror_data() ->
    gen_server:cast(?MODULE, update_mirror_data).

%% 清空镜像服务器配置列表
clear_mirror_data() ->
    L = get_all_mirror_data(),
    lists:foreach(fun(#mirror_data{srv_id = SrvId}) ->
                case ets:lookup(mirror_online, SrvId) of
                    %% 目标服务器没连接到中央服
                    [#mirror{pid = Pid}] when is_pid(Pid) ->  Pid ! stop;
                    _ -> ignore
                end
        end, L),
    sys_env:save(mirror_list, []),
    sys_env:save(platform_list, []),
    sys_env:save(merge_srv_mapping, []).

%% 打印所有未连接上的镜像服务器
print_disconnected_mirrors() ->
    L = get_all_mirror_data(),
    ?INFO("目前没有连接上的节点有:"),
    do_print_disconnected_mirrors(L, []).
do_print_disconnected_mirrors([], Result) -> Result;
do_print_disconnected_mirrors([#mirror_data{srv_id = SrvId}|T], Result) ->
    case ets:lookup(mirror_online, SrvId) of
        [#mirror{mpid = Mpid}] when is_pid(Mpid) -> do_print_disconnected_mirrors(T, Result);
        _ -> 
            ?INFO("~s", [SrvId]),
            do_print_disconnected_mirrors(T, Result)
    end.

%% 获取所有已经连接上的镜像服务器 -> [#mirror{}]
get_all_connected_mirrors() ->
    L = ets:tab2list(mirror_online),
    [Mirror || Mirror = #mirror{mpid = Mpid} <- L, is_pid(Mpid)].

%% 批量增加合服映射信息
add_to_merge_srv_mapping(L) when is_list(L) ->
    gen_server:cast(?MODULE, {add_to_merge_srv_mapping, L}).

%% ----------------------------------------------------
%% 内部处理
%% ----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    %% sys_env:set(center, {node(), 0}),
    init_mirrors(),
    init_merge_srv_mapping(),
    init_platforms(),
    classify_platform_and_srv(),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(list_all_data, State) ->
    ?INFO("全部的镜像服务器:=================>"),
    lists:foreach(fun(#mirror_data{srv_id = SrvId, srv_ids = SrvIds, platform = Platform, name = Name, node = Node, host = Host, ver = Ver, cookie = Cookie}) ->
                ?INFO("镜像服务器[srv_id=~s]信息:[srv_ids=~w], [platform=~w], [name=~w], [node=~w], [host=~w], [ver=~w], [cookie=~w]", [SrvId, SrvIds, Platform, Name, Node, Host, Ver, Cookie])
            end, get_all_mirror_data()),
    ?INFO("全部的合服映射:==============>"),
    lists:foreach(fun({OriginSrvId, DestSrvId}) ->
                ?INFO("~s ==> ~s", [OriginSrvId, DestSrvId])
            end, get_merge_srv_mapping()),
    ?INFO("全部的平台:===============>"),
    lists:foreach(fun(PlatformName) ->
                ?INFO("~s", [PlatformName])
            end, get_all_platforms()),
    {noreply, State};

handle_cast({add_mirror, MirrorData = #mirror_data{srv_id = SrvId}}, State) ->
    L = get_all_mirror_data(),
    L1 = case lists:keyfind(SrvId, #mirror_data.srv_id, L) of
        false -> [MirrorData|L];
        #mirror_data{} -> lists:keyreplace(SrvId, #mirror_data.srv_id, L, MirrorData)
    end,
    case sys_env:save(mirror_list, L1) of
        ok ->
            init_merge_srv_mapping(),
            init_platforms(),
            classify_platform_and_srv(),
            case ets:lookup(mirror_online, SrvId) of
                %% 目标服务器没连接到中央服
                [#mirror{}] -> ignore;
                _ -> 
                    Mirror = mirror_data_to_mirror(MirrorData),
                    c_mirror:create(Mirror)
                    %% update_platforms(update, Platform)
            end;
        {error, _Why} ->
            ?ERR("添加镜像服务器失败:~s", [_Why]);
        _Other ->
            ?ERR("添加镜像服务器失败:~w", [_Other])
    end,
    {noreply, State};

handle_cast({del_mirror, srv_id, SrvId1}, State) ->
    SrvId = case is_list(SrvId1) of
        true -> list_to_bitstring(SrvId1);
        false -> SrvId1
    end,
    do_del_mirror(SrvId),
    {noreply, State};

handle_cast({del_mirror, platform, Platform1}, State) ->
    Platform = case is_list(Platform1) of
        true -> list_to_bitstring(Platform1);
        false -> Platform1
    end,
    ?INFO("删除镜像服务器:Platform=~s", [Platform]),
    L = get_all_mirror_data(),
    SrvIds = [SrvId || #mirror_data{srv_id = SrvId, platform = P} <- L, P =:= Platform],
    lists:foreach(fun(SrvId) -> do_del_mirror(SrvId) end, SrvIds),
    {noreply, State};

handle_cast({restart_mirror, SrvId1}, State) ->
    SrvId = case is_list(SrvId1) of
        true -> list_to_bitstring(SrvId1);
        false -> SrvId1
    end,
    case ets:lookup(mirror_online, SrvId) of
        [#mirror{pid = Pid}]  ->
            case is_pid(Pid) andalso is_process_alive(Pid) of
                true -> Pid ! stop;
                false -> ignore
            end,
            L = get_all_mirror_data(),
            case lists:keyfind(SrvId, #mirror_data.srv_id, L) of
                false -> undefined;
                MirrorData ->
                    Mirror = mirror_data_to_mirror(MirrorData),
                    c_mirror:create(Mirror)
            end;
        [] ->
            L = get_all_mirror_data(),
            case lists:keyfind(SrvId, #mirror_data.srv_id, L) of
                false -> undefined;
                MirrorData ->
                    Mirror = mirror_data_to_mirror(MirrorData),
                    c_mirror:create(Mirror)
            end;
        _ -> ignore
    end,
    {noreply, State};

handle_cast({cast, all, M, F, A}, State) ->
    L = get_all_mirror_data(),
    do_cast(L, M, F, A),
    {noreply, State};

handle_cast({cast, platform, Platforms, M, F, A}, State) ->
    L = get_platform_mirrors(Platforms),
    do_cast(L, M, F, A),
    {noreply, State};

handle_cast(update_mirror_data, State) ->
    ?INFO("从文件更新镜像服务器配置"),
    case file:open("../var/cross_center_cfg.dat",read) of
        {ok, Fp} ->
            try
                MirrorDataList = read_mirror_data(Fp),
                ?DEBUG("最新的镜像服务器配置:~w", [MirrorDataList]),
                update_mirror(MirrorDataList)
            catch A:B ->
                ?ERR("更新镜像服务器配置出错：~w, ~w",[A, B])
            after
                file:close(Fp)
            end;
        {error, _Err} ->
            ?ERR("打开cross_center_cfg.dat失败:~w", [_Err])
    end,
    {noreply, State};
    

handle_cast({update_mirror_data, MirrorDataList}, State) ->
    ?INFO("从外部传入参数更新镜像服务器配置"),
    update_mirror(MirrorDataList),
    {noreply, State};

handle_cast({add_to_merge_srv_mapping, Mapping}, State) ->
    lists:foreach(fun({SrvId, DestSrvId}) ->
                add_to_merge_srv_mapping(SrvId, DestSrvId)
        end, Mapping),
    trigger(update_cfg),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    %%?INFO("[~s]的镜像进程已经退出", [Node]),
    %%ets:delete(mirror_online, SrvId),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------
%% 初始化所有镜像服务器
init_mirrors() ->
    L = get_all_mirror_data(),
    lists:foreach(fun(MirrorData = #mirror_data{srv_id = SrvId}) ->
                Mirror = mirror_data_to_mirror(MirrorData),
                case c_mirror:create(Mirror) of
                    {ok, _Pid} -> ignore;
                    _Err -> ?ERR("初始化镜像服务器[SrvId=~s]出错:~w", [SrvId, _Err])
                end
        end, L).

%% 初始化合服映射
init_merge_srv_mapping() ->
    MirrorDataList = get_all_mirror_data(),
    Mapping = gen_merge_srv_mapping(MirrorDataList, []),
    sys_env:save(merge_srv_mapping, Mapping).

%% 初始化平台信息
init_platforms() ->
    L = get_all_mirror_data(),
    Platforms = do_init_platforms(L, []),
    sys_env:save(platform_list, Platforms).
do_init_platforms([], Platforms) -> Platforms;
do_init_platforms([#mirror_data{platform = Platform}|T], Platforms) ->
    case lists:member(Platform, Platforms) of
        true -> do_init_platforms(T, Platforms);
        false -> do_init_platforms(T, [Platform|Platforms])
    end.

%% 把所有平台以及所有属于这个平台的服归类
classify_platform_and_srv() ->
    case sys_env:get(platform_list) of
        Platforms = [_|_] ->
            do_classify_platform_and_srv(Platforms, get_all_mirror_data(), []);
        _ ->
            sys_env:save(platform_srv_list, [])
    end.
do_classify_platform_and_srv([], _, Result) -> sys_env:save(platform_srv_list, Result);
do_classify_platform_and_srv([Platform|T], L, Result) ->
    SrvIds = [SrvId || #mirror_data{srv_id = SrvId, platform = Platform1} <- L, Platform1 =:= Platform],
    do_classify_platform_and_srv(T, L, [{Platform, SrvIds}|Result]).


%% 更新所有镜像服务器
update_mirror(MirrorDataList) ->
    case sys_env:save(mirror_list, MirrorDataList) of
        ok ->
            do_update_mirror(MirrorDataList),
            init_merge_srv_mapping(),
            init_platforms(),
            classify_platform_and_srv(),
            trigger(update_cfg);
        {error, _Err} ->
            ?ERR("更新所有镜像服务器错误:~s", [_Err]),
            sys_env:save(mirror_list, [])
    end.
do_update_mirror([]) -> ok;
do_update_mirror([MirrorData = #mirror_data{srv_id = SrvId, platform = Platform, name = Name, node = Node, ver = Ver, cookie = Cookie}|T]) ->
    case ets:lookup(mirror_online, SrvId) of
        [OldMirror = #mirror{pid = Pid}] ->
            case mirror_to_mirror_data(OldMirror) of
                #mirror_data{node = Node, cookie = Cookie} -> %% 如果node和cookie没有变化，则只修改其他信息
                    ets:insert(mirror_online, OldMirror#mirror{platform = Platform, name = Name, ver = Ver});
                _ -> %% 如果node或者cookie变化，则要断开重连
                    case is_pid(Pid) andalso is_process_alive(Pid) of
                        true ->
                            Pid ! stop;
                        false -> ignore
                    end,
                    Mirror = mirror_data_to_mirror(MirrorData),
                    c_mirror:create(Mirror)
            end;
        [] ->
            Mirror = mirror_data_to_mirror(MirrorData),
            c_mirror:create(Mirror);
        _ -> ignore
    end,
    do_update_mirror(T);
do_update_mirror([MirrorData|T]) ->
    ?ERR("错误的镜像服务器配置数据:~w", [MirrorData]),
    do_update_mirror(T).
    
do_del_mirror(SrvId) ->
    L = get_all_mirror_data(),
    case lists:keyfind(SrvId, #mirror_data.srv_id, L) of
        #mirror_data{} ->
            L1 = lists:keydelete(SrvId, #mirror_data.srv_id, L),
            case sys_env:save(mirror_list, L1) of
                ok ->
                    init_merge_srv_mapping(),
                    init_platforms(),
                    classify_platform_and_srv(),
                    case ets:lookup(mirror_online, SrvId) of
                        [#mirror{pid = Pid}] when is_pid(Pid) ->
                            ?INFO("停止镜像服务器[~s]进程:~w，并从online列表中删除", [SrvId, Pid]),
                            Pid ! stop,
                            ets:delete(mirror_online, SrvId);
                        [#mirror{}] ->
                            ?INFO("把镜像服务器[~s]从online列表中删除", [SrvId]),
                            ets:delete(mirror_online, SrvId);
                        _ ->
                            ?INFO("这个镜像服务器[~s]不在online列表中", [SrvId])
                    end;
                    %% update_platforms(delete, Platform);
                {error, _Why} ->
                    ?ERR("删除镜像服务器失败:~s", [_Why]);
                _Other ->
                    ?ERR("删除镜像服务器失败:~w", [_Other])
            end;
        _ ->
            ?INFO("找不到这个镜像服务器[~s]", [SrvId])
    end.

%% 获取所有的镜像服务器（无论是否连接上的）-> [#mirror_data{}]
get_all_mirror_data() ->
    case sys_env:get(mirror_list) of
        undefined -> [];
        L -> L
    end.

%% 获取所有的合服映射
get_merge_srv_mapping() ->
    case sys_env:get(merge_srv_mapping) of
        undefined -> [];
        L -> L
    end.

%% 生成合服映射列表 -> [{被合并的SrvId, 合并到的目标SrvId}]
gen_merge_srv_mapping([], Mapping) -> Mapping;
gen_merge_srv_mapping([#mirror_data{srv_id = SrvId, srv_ids = SrvIds}|T], Mapping) ->
    L = [{util:to_binary(OriginSrvId), SrvId} || OriginSrvId <- SrvIds],
    case L of
        [] -> gen_merge_srv_mapping(T, [{SrvId, SrvId}|Mapping]);
        [_|_] -> gen_merge_srv_mapping(T, Mapping ++ L)
    end.

%% 获取所有的目标服务器id
get_all_dest_srv_id() ->
    case sys_env:get(merge_srv_mapping) of
        L = [_|_] -> 
            DestSrvIds = [SrvId || {_, SrvId} <- L],
            do_get_all_dest_srv_id(DestSrvIds, []);
        _ -> []
    end.
do_get_all_dest_srv_id([], Result) -> Result;
do_get_all_dest_srv_id([SrvId|T], Result) ->
    L1 = Result -- [SrvId],
    L2 = [SrvId|L1],
    do_get_all_dest_srv_id(T, L2).

%% 获取指定平台的镜像服务器（无论是否连接上的）
%% Platforms = [bitstring()]
get_platform_mirrors(Platforms) ->
    L = get_all_mirror_data(),
    do_get_platform_mirrors(Platforms, L, []).
do_get_platform_mirrors(_Platforms, [], Result) -> Result;
do_get_platform_mirrors(Platforms, [MirrorData = #mirror_data{platform = Platform}|T], Result) ->
    case lists:member(Platform, Platforms) of
        true ->
            do_get_platform_mirrors(Platforms, T, [MirrorData|Result]);
        false ->
            do_get_platform_mirrors(Platforms, T, Result)
    end.

%% 广播
do_cast([], _M, _F, _A) -> ok;
do_cast([#mirror_data{srv_id = SrvId}|T], M, F, A) ->
    case ets:lookup(mirror_online, SrvId) of
        [#mirror{pid = Pid}] when is_pid(Pid) ->
            Pid ! {cast, M, F, A};
        _ -> ignore
    end,
    do_cast(T, M, F, A);
do_cast([_|T], M, F, A) ->
    do_cast(T, M, F, A).

%% 镜像数据和镜像转换
mirror_data_to_mirror(#mirror_data{srv_id = SrvId, platform = Platform, name = Name, node = Node, host = Host, ver = Ver, cookie = Cookie}) ->
    %% 把node转成atom，如：'XXX@YYY.com'
    Node1 = case is_bitstring(Node) of
        true -> list_to_atom(bitstring_to_list(Node));
        false -> 
            case is_list(Node) of
                true -> list_to_atom(Node);
                false -> Node
            end
    end,
    %% 把cookie转成atom，如：'x1y2z3'
    Cookie1 = case is_bitstring(Cookie) of
        true -> list_to_atom(bitstring_to_list(Cookie));
        false -> 
            case is_list(Cookie) of
                true -> list_to_atom(Cookie);
                false -> Cookie
            end
    end,
    #mirror{srv_id = SrvId, platform = Platform, name = Name, node = Node1, host = Host, ver = Ver, cookie = Cookie1}.
mirror_to_mirror_data(#mirror{srv_id = SrvId, platform = Platform, name = Name, node = Node, host = Host, ver = Ver, cookie = Cookie}) ->
    Node1 = atom_to_list(Node),
    Cookie1 = atom_to_list(Cookie),
    #mirror_data{srv_id = SrvId, platform = Platform, name = Name, node = Node1, host = Host, ver = Ver, cookie = Cookie1}.

%% 从文件读取镜像服务器配置列表
read_mirror_data(Fp) ->
    do_read_mirror_data(Fp, []).
do_read_mirror_data(Fp, Result) ->
    case io:get_line(Fp, '') of
        eof -> Result;
        {error, _Reason} ->
            ?ERR("读取一行失败:~w", [_Reason]),
            [];
        Data when is_list(Data) ->
            %% 去掉行末的换行符
            Data1 = lists:sublist(Data, length(Data)-1),
            case util:string_to_term(Data1) of
                {ok, MirrorData = #mirror_data{}} ->
                    do_read_mirror_data(Fp, [MirrorData|Result]);
                _Reason ->
                    ?ERR("转换一行数据格式失败:~w, ~w", [Data1, _Reason]),
                    []
            end;
        _Other ->
            ?ERR("读取一行数据格式不正确:~w", [_Other]),
            []
    end.

%% 广播归类过的平台和所拥有的服的信息
cast_platform_and_srv() ->
    do_cast(get_all_mirror_data(), center, update_platform_and_srv, [sys_env:get(platform_srv_list)]).

%%---------------------------------------
%% 触发器
%%---------------------------------------
%% 节点配置或合服映射信息修改之后，向所有节点广播
trigger(update_cfg) ->
    case ?cross_trip_flag of
        1 ->
            MappingCfg = sys_env:get(merge_srv_mapping),
            MirrorCfg = ets:tab2list(mirror_online),
            AllCfg = term_to_binary([MappingCfg, MirrorCfg], [compressed]),
            L = get_all_mirror_data(),
            do_cast(L, gs_mirror_group, update_cfg, [AllCfg]);
        _ -> ignore
    end,
    cast_platform_and_srv(),
    ok.
