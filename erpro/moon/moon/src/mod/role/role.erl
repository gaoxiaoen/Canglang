%%----------------------------------------------------
%% 角色进程
%% 
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(role).
-behaviour(gen_server).
-export([
        create/4
        ,stop/1
        ,stop/3
        ,rpc/4
        ,connect/3
        ,disconnect/1
        ,pack_send/3
        ,c_pack_send/3
        ,apply/3
        ,c_apply/3
        ,check_cd/2
        ,get_dict/1
        ,get_dict/2
        ,put_dict/2
        ,put_dict/3
        ,erase_dict/1
        ,erase_dict/2
        ,convert/2
        ,element/2
        ,send_buff_begin/0
        ,send_buff_flush/0
        ,send_buff_clean/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, format_stats/2]).

-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("guild.hrl").
-include("conn.hrl").
-ifdef(debug).
%% -define(LAG, util:sleep(util:rand(100, 150))). %% 模拟网络延时
-define(LAG, null). %% 模拟网络延时
-else.
-define(LAG, null). %% 关闭网络延时模拟
-endif.

%% ----------------------------------------------------
%% 对外接口
%% ----------------------------------------------------

%% @spec create(Rid, SrvId, Account, Link) -> {ok, pid()} | ignore | {error, Error}
%% Rid = integer()
%% SrvId = binary()
%% Account = binary()
%% Link = #link{}
%% Error = term()
%% @doc 创建一个角色进程
create(Rid, SrvId, Account, Link) ->
    gen_server:start({global, {role, Rid, SrvId}}, ?MODULE, [Rid, SrvId, Account, Link], []).

%% @spec stop(RolePid) -> ok
%% RolePid = pid()
%% @doc 强制终止角色进程的运行，数据回写到DETS，但不回写数据库，只在系统关机时使用
stop(RolePid) ->
    catch gen_server:call(RolePid, {stop, fast}),
    ok.

%% @spec stop(Type, RolePid, Msg) -> ok
%% Type = sync | async
%% RolePid = pid()
%% Msg = bitstring()
%% @doc 强制终止角色进程的运行，可选择同步或异步方式
%% <div>注意:如果Msg为非空则需要等Msg发送完成后才有返回，当玩家网络不好时，这个时间可能会比较长</div>
stop(sync, RolePid, Msg) ->
    catch gen_server:call(RolePid, {stop, Msg}),
    ok;
stop(async, RolePid, Msg) ->
    RolePid ! {stop, Msg}.

%% 网络进程连接角色进程
connect(Pid, Link, Conn) ->
    gen_server:call(Pid, {connect, Link, Conn}, 60000). 

%% @spec disconnect(pid()) -> ok
%% @doc 连接器断开通知
disconnect(RolePid) ->
    RolePid ! disconnect.

%% @spec rpc(RolePid, Mod, Cmd, Data) -> ok
%% RolePid = pid()
%% Mod = atom()
%% Cmd = int()
%% Data = tuple()
%% @doc 客户端调用接口(socket事件处理)
rpc(RolePid, Mod, Cmd, Data) ->
    RolePid ! {rpc, Mod, Cmd, Data}.

%% @spec apply(async, RolePid, Mfa) -> ok
%% RolePid = pid()
%% Mfa = {F} | {F, A} | {M, F, A}
%% @doc 对指定角色应用MFA(异步方式)
%% <div>注意:F的返回值格式要求: F([State | A]) -> {ok} | {ok, NewState}</div>
apply(async, RolePid, {F}) ->
    RolePid ! {apply_async, {F}};
apply(async, RolePid, {F, A}) ->
    RolePid ! {apply_async, {F, A}};
apply(async, RolePid, {M, F, A}) ->
    RolePid ! {apply_async, {M, F, A}};

%% @spec apply(sync, RolePid, Mfa) -> Reply | {error, self_call}
%% RolePid = pid()
%% Mfa = {F} | {F, A} | {M, F, A}
%% Reply = term()
%% @doc 对指定角色应用MFA(同步方式)
%% <div>注意:F的返回值格式要求: F([State | A]) -> {ok, Reply} | {ok, Reply, NewState}</div>
apply(sync, RolePid, _Mfa) when not is_pid(RolePid) ->
    {error, not_pid};
apply(sync, RolePid, Mfa) when self() =:= RolePid ->
    ?ERR("执行apply时发生错误：调用了自身[~w, ~w]", [RolePid, Mfa]),
    {error, self_call};
apply(sync, RolePid, {F}) ->
    ?CALL(RolePid, {apply_sync, F});
apply(sync, RolePid, {F, A}) ->
    ?CALL(RolePid, {apply_sync, {F, A}});
apply(sync, RolePid, {M, F, A}) ->
    ?CALL(RolePid, {apply_sync, {M, F, A}});

%% Timeout = int(), 毫秒
%% Callback = {F} | {F, A} | {M, F, A}
apply({timeout, Timeout}, RolePid, Callback) ->
    erlang:send_after(Timeout, RolePid, {apply_async, Callback}).

%% @spec c_apply(Type, RolePid, Mfa) -> Reply | {error, Reason} | {badrpc, ReasonRpc}
%% Type = async | sync
%% RolePid = pid()
%% Mfa = {F} | {F, A} | {M, F, A}
%% Reply = term()
%% ReasonRpc = timeout | any()
%% @doc 针对跨服角色通过中央服代理对指定的角色进程应用MFA，返回值和MFA格式参考apply/3
c_apply(_Type, RolePid, _Mfa) when not is_pid(RolePid) ->
    {error, not_pid};
c_apply(Type = sync, RolePid, Mfa) ->
    case node(RolePid) =:= node() of
        true ->
            role:apply(Type, RolePid, Mfa);
        false ->
            center:call(role, apply, [Type, RolePid, Mfa])
    end;
c_apply(Type = async, RolePid, Mfa) ->
    case node(RolePid) =:= node() of
        true ->
            role:apply(Type, RolePid, Mfa);
        false ->
            center:cast(role, apply, [Type, RolePid, Mfa])
    end.

%% @spec get_dict(Key) -> {ok, Data} | {error, Reason}
%% Key = term()
%% Data = term()
%% Reason = atom()
%% @doc 获取当前角色的进程字典数据
get_dict(Key) ->
    case get(is_role_process) of
        true -> {ok, get(Key)};
        _ ->
            ?ERR("当前进程不是一个角色进程，不能使用get_dict/1"),
            {error, not_a_role_process}
    end.

%% @spec get_dict(RolePid, Key) -> {ok, Data} | {error, Reason}
%% Key = term()
%% Data = term()
%% Reason = atom()
%% @doc 获取当前角色的进程字典数据
get_dict(RolePid, _Key) when self() =:= RolePid ->
    {error, self_call};
get_dict(RolePid, Key) ->
    ?CALL(RolePid, {get_dict, Key}).

%% @spec put_dict(RKey, Val) -> {ok, LastData} | {error, Reason}
%% Key = term()
%% Val = term()
%% LastData = term()
%% Reason = atom()
%% @doc 写入数据到当前角色的进程字典
put_dict(Key, Val) ->
    case get(is_role_process) of
        true -> {ok, put(Key, Val)};
        _ ->
            ?ERR("当前进程不是一个角色进程，不用使用put_dict/2"),
            {error, not_a_role_process}
    end.

%% @spec put_dict(RolePid, Key, Val) -> {ok, LastData} | {error, Reason}
%% Key = term()
%% Val = term()
%% LastData = term()
%% Reason = atom()
%% @doc 写入数据到指定角色的进程字典
put_dict(RolePid, _Key, _Val) when self() =:= RolePid ->
    ?ERR("进行put_dict/3操作时调用了自身"),
    {error, self_call};
put_dict(RolePid, Key, Val) ->
    ?CALL(RolePid, {put_dict, Key, Val}).

%% @spec erase_dict(Key) -> {ok, Data} | {error, Reason}
%% Key = term()
%% Data = term()
%% Reason = atom()
%% @doc 清除当前角色的进程字典数据
erase_dict(Key) ->
    case get(is_role_process) of
        true -> {ok, erase(Key)};
        _ -> {error, not_a_role_process}
    end.

%% @spec erase_dict(RolePid, Key) -> {ok, Data} | {error, Reason}
%% Key = term()
%% Data = term()
%% Reason = atom()
%% @doc 清除指定角色的进程字典数据
erase_dict(RolePid, _Key) when self() =:= RolePid ->
    {error, self_call};
erase_dict(RolePid, Key) ->
    ?CALL(RolePid, {erase_dict, Key}).

%% @spec check_cd(Type, Cd) -> true | false
%% Type = atom() 检查类型
%% Cd = integer() 间隔时间单位秒
%% @doc 角色进程操作检查CD时间，判断是否满足CD间隔要求，true表示可以通过
%% <div> 由角色进程调用有效 </div>
check_cd(Type, Cd) ->
    Now = util:unixtime(),
    case get(Type) of
        T when is_integer(T) andalso T + Cd =< Now ->
            put(Type, Now),
            true;
        undefined ->
            put(Type, Now),
            true;
        _ ->
            false
    end.

%% @spec convert(Type, RolePid) -> {ok, record()} | {error, timeout} | {error, noproc} | {error, term()}
%% Type = atom()
%% RolePid = pid()
%% @doc 将角色转换为指定的数据类型
%% <div>此接口在跨节点访问时可以节省大量的数据传输</div>
convert(_Type, RolePid) when self() =:= RolePid ->
    {error, self_call};
convert(Type, RolePid) ->
    ?CALL(RolePid, {convert, Type}).

%% @spec element(RolePid, ElemPos) -> {error, self_call} | {error, not_alive} | [term()] | term()
%% RolePid = pid()
%% ElemPos = integer() | [integer()]
%% @doc 获取指定角色的某一个或多个属性
%% <div>示例:Event = role:prop(RolePid, #role.event)</div>
%% <div>示例:[Event, Status] = role:element(RolePid, [#role.event, #role.status])</div>
element(RolePid, _ElemPos) when self() =:= RolePid ->
    {error, self_call};
element(RolePid, ElemPos) when is_integer(ElemPos) ->
    case catch gen_server:call(RolePid, {element, [ElemPos]}) of
        {'EXIT', {timeout, _}} -> {error, timeout};
        [E] -> {ok, E};
        Err -> {error, Err}
    end;
element(RolePid, ElemPos) when is_list(ElemPos) ->
    case catch gen_server:call(RolePid, {element, ElemPos}) of
        {'EXIT', {timeout, _}} -> {error, timeout};
        {'EXIT', Reason} -> {error, Reason};
        EL -> {ok, EL}
    end.

%% @spec send_buff_begin() -> ok
%% @doc 开启发送缓冲区(需要进行事务性处理时使用)
%% <div>注意:send_buff_begin/0必须跟send_buff_flush/0或send_buff_clean/0配对使用</div>
%% <div>否则将会导致数据一直发送到缓冲区，因此客户端会一直收不到数据</div>
%% <div>此函数支持嵌套使用，只是必须保证成对出现</div>
send_buff_begin() ->
    case get(is_role_process) of
        true ->
            %% ?DEBUG("开始新事务: ~w", [get(send_buff)]);
            put(send_buff, [[] | get(send_buff)]);
        _ ->
            ?ERR("不能在非角色进程内使用发送缓冲区"),
            ignore
    end,
    ok.

%% @spec send_buff_flush() -> ok
%% @doc 立即发送缓冲区中的数据并关闭缓冲区(只会关闭一层)
send_buff_flush() ->
     case get(is_role_process) of
        true ->
            case get(send_buff) of
                undefined -> ?ERR("发送缓冲区数据时发生异常:没有建立缓冲区");
                [] -> ?ERR("发送缓冲区数据时发生异常:缓冲区为空");
                [[]] -> %% 没有数据，不需要发送
                    put(send_buff, []);
                [H] -> %% 已经是最后一层的事务了，可以直接发送
                    get(conn_pid) ! {send_data, lists:reverse(H)}, %% 注意:必须直接发送到连接器
                    put(send_buff, []);
                [H | [H1 | T]] ->
                    put(send_buff, [[lists:reverse(H) | H1] | T]);
                [H | T] ->
                    put(send_buff, [[lists:reverse(H) | T]])
            end;
        _ ->
            ?ERR("不能在非角色进程内使用发送缓冲区"),
            ignore
    end,
    ok.

%% @spec send_buff_clean() -> ok
%% @doc 清空发送缓冲区并关闭缓冲区(只会关闭一层)
send_buff_clean() ->
    case get(is_role_process) of
        true ->
            case get(send_buff) of
                undefined -> ?ERR("发送缓冲区数据时发生异常:没有建立缓冲区");
                [] -> ?ERR("清空缓冲区数据时发生异常:缓冲区为空");
                [_H] ->
                    put(send_buff, []);
                [_H | T] ->
                    put(send_buff, T)
            end;
        _ ->
            ?ERR("不能在非角色进程内使用发送缓冲区"),
            ignore
    end,
    ok.

%% @spec pack_send(RolePid, Cmd, Data) -> ok
%% RolePid = pid()
%% Cmd = int()
%% Data = tuple()
%% @doc 打包并发送消息到角色进程(由角色进程转发到连接器进程)
%% <div>出于性能考虑，只能用于无法直接获取连接器Pid时使用</div>
pack_send(RolePid, Cmd, Data) ->
    case mapping:module(game_server, Cmd) of
        {ok, _Auth, _Caller, Proto, _ModName} ->
            case Proto:pack(srv, Cmd, Data) of
                {ok, Bin} ->
                    RolePid ! {socket_proxy, Bin};
                {error, Reason} ->
                    ?ERR("打包数据出错[Cmd:~w][Reason:~w]", [Cmd, Reason])
            end;
        {error, _Code} ->
            ?ERR("模块影射失败[~w]:~w", [Cmd, Data])
    end.

%% @spec c_pack_send(RolePid, Cmd, Data) -> ok
%% RolePid = pid()
%% Cmd = int()
%% Data = tuple()
%% @doc 打包并发送消息到角色进程(由角色进程转发到连接器进程)
c_pack_send(RolePid, Cmd, Data) ->
    case node(RolePid) =:= node() of
        true ->
            pack_send(RolePid, Cmd, Data);
        false ->
            center:cast(role, pack_send, [RolePid, Cmd, Data])
    end.

%% ----------------------------------------------------
%% 内部调用处理
%% ----------------------------------------------------

init([Rid, SrvId, Account, Link]) ->
    put(is_role_process, true), %% 标识下这是一个角色进程
    put(already_handle_stop, false), %% 是否已经执行过退出处理
    put(role_info, {Rid, SrvId, Account}), %% 将角色帐号信息放入进程字典
    put(send_buff, []),
    put(sync_counter, 1), %% 数据同步记数器
    put(confirm_idx, lists:seq(1, 10)), %% 最多能有10个confirm同时发起
    put(prompt_idx, lists:seq(1, 5)), %% 最多能有5个prompt同时发起
    put(data_uninit, true),    %% 角色数据未加载
    case catch role_data:load_role(Rid, SrvId) of
        {false, not_exists} -> {stop, not_exists};
        {false, Reason} -> {stop, Reason};
        {ok, Role = #role{account = Acc}} -> % when Acc =:= Account ->
            case string:to_lower(binary_to_list(Acc)) =:= string:to_lower(binary_to_list(Account)) of
                true ->
                    process_flag(trap_exit, true),
                    %link(ConnPid),
                    %erlang:register(list_to_atom(lists:concat(["role_", Rid, "_", binary_to_list(SrvId)])), self()), %% 注册一个名字，方便查看角色信息
                    self() ! init,
                    {ok, Role#role{pid = self(), link = Link}};
                false ->
                    ?ERR("帐号名不匹配 [~s] [~s]", [string:to_lower(binary_to_list(Acc)), string:to_lower(binary_to_list(Account))]),
                    {stop, ?MSGID(<<"账号名不匹配">>)}
            end;
        Throw = {'EXIT', _} ->
            ?ERR("~p", [Throw]),
            throw(Throw)
    end.

handle_call({connect, Link, Conn}, From, State) ->
    case get(data_uninit) of
        true ->
            put(connect_from, {From, Link, Conn}),
            {noreply, State};
        _ ->
            NewState = do_connect(State, Link, Conn),
            {reply, ok, NewState}
   end; 

handle_call({apply_sync, {F}}, _From, State) ->
    handle_apply_sync_return(catch erlang:apply(F, [State]), {undefined, F, []}, State);

handle_call({apply_sync, {F, A}}, _From, State) ->
    handle_apply_sync_return(catch erlang:apply(F, [State | A]), {undefined, F, A}, State);

handle_call({apply_sync, {M, F, A}}, _From, State) ->
    handle_apply_sync_return(catch erlang:apply(M, F, [State | A]), {M, F, A}, State);

handle_call({get_dict, Key}, _From, State) ->
    {reply, {ok, get(Key)}, State};

handle_call({put_dict, Key, Val}, _From, State) ->
    {reply, {ok, put(Key, Val)}, State};

handle_call({erase_dict, Key}, _From, State) ->
    {reply, {ok, erase(Key)}, State};

handle_call({convert, to_role}, _From, State) ->
    {reply, {ok, State}, State};

handle_call({convert, Type}, _From, State) ->
    {reply, role_convert:do(Type, State), State};

handle_call({element, Pos}, _From, State) when is_list(Pos) ->
    {reply, lists:reverse(do_element(Pos, State, tuple_size(State), [])), State};

%% 将角色踢下线，不回写数据库，只回写到DETS
handle_call({stop, fast}, _From, State) ->
    do_stop(State),
    {stop, normal, State};

%% 将角色踢下线(同步操作)
handle_call({stop, Msg}, _From, State) ->
    do_stop(State, Msg),
    {stop, normal, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(init, State) ->
    self() ! gc,
    NewState = role_listener:login(State),
    role_group:join(all, State),
    erase(data_uninit),
    case erase(connect_from) of
        undefined -> 
            {noreply, NewState};
        {From, Link, Conn} -> 
            NewState1 = do_connect(NewState, Link, Conn),
            gen_server:reply(From, ok),
            {noreply, NewState1}
    end;

%% 强制GC
handle_info(gc, State) ->
    garbage_collect(),
    erlang:send_after(180000, self(), gc),
    {noreply, State};

handle_info({apply_async, {F}}, State) ->
    handle_apply_async_return(catch erlang:apply(F, [State]), {undefined, F, []}, State);

handle_info({apply_async, {F, A}}, State) ->
    handle_apply_async_return(catch erlang:apply(F, [State | A]), {undefined, F, A}, State);

handle_info({apply_async, {M, F, A}}, State) ->
    handle_apply_async_return(catch erlang:apply(M, F, [State | A]), {M, F, A}, State);

%% 定时器消息处理
handle_info({timing, TimingId, {M, F, A}}, State) ->
    handle_timer_return(catch erlang:apply(M, F, [State | A]), TimingId, State);

%% 定时器消息处理
handle_info({clear_dungeon, {M, F, A}}, State) ->
    {ok, NewState} = erlang:apply(M, F, [State | A]),
    {noreply, NewState};

handle_info({rpc, Mod, Cmd, Data}, State = #role{name = Name, link = #link{conn_pid = ConnPid}}) ->
    ?LAG,
    case setting:check(Mod, Cmd, Data, State) of
        false -> read_next(ConnPid, State);
        ok -> 
            case catch Mod:handle(Cmd, Data, State) of
                {ok} ->
                    read_next(ConnPid, State);
                {ok, NState} when is_record(NState, role) ->
                    NewState = campaign_listener:loss_gold(State, NState, Mod, Cmd, Data), %% 晶钻消费活动
                    rank:role_update(Cmd, Data, State, NewState), %% 排行榜监听接口
                    sync(NewState),
                    log:log_gold(Cmd, Data, State, NewState), %% 晶钻日志
                    read_next(ConnPid, NewState);
                {reply, Reply} ->
                    sys_conn:pack_send(ConnPid, Cmd, Reply),
                    read_next(ConnPid, State);
                {reply, Reply, NState} when is_record(NState, role) ->
                    NewState = campaign_listener:loss_gold(State, NState, Mod, Cmd, Data), %% 晶钻消费活动
                    rank:role_update(Cmd, Data, State, NewState), %% 排行榜监听接口
                    sync(NewState),
                    sys_conn:pack_send(ConnPid, Cmd, Reply),
                    log:log_gold(Cmd, Data, State, NewState), %% 晶钻日志
                    read_next(ConnPid, NewState);
                {nosync, NState} when is_record(NState, role) -> %% 不需要同步角色数据
                    NewState = campaign_listener:loss_gold(State, NState, Mod, Cmd, Data), %% 晶钻消费活动
                    rank:role_update(Cmd, Data, State, NewState), %% 排行榜监听接口
                    log:log_gold(Cmd, Data, State, NewState), %% 晶钻日志
                    read_next(ConnPid, NewState);
                _Reason ->
                    ?ERR("[~s]的角色进程处理命令时出错:~w [Cmd:~w Data:~w]", [Name, _Reason, Cmd, Data]),
                    read_next(ConnPid, State)
            end
    end;

%% 转发数据到连接进程
handle_info({send_data, Bin}, State = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:send(ConnPid, Bin),
    {noreply, State};

%% 转发数据到连接进程 %% TODO 改为用send_data
handle_info({socket_proxy, Bin}, State = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:send(ConnPid, Bin),
    {noreply, State};

%% 角色在地图上位置定期更新
handle_info({timeout, Ref, {location_updater, MovingMapPid}}, State = #role{pos = #pos{map_pid = MapPid}}) ->
    case MovingMapPid =:= MapPid of
        false ->
            {noreply, State};
        true ->
            State1 = role_location_updater:update(Ref, State),
            {noreply, State1}
    end;

%% 连接器进程异常退出，协助处理收尾工作
handle_info({'EXIT', Pid, Why}, State = #role{name = Name, link = #link{socket = Socket, conn_pid = ConnPid}}) when Pid =:= ConnPid ->
    case Why of
        normal -> ignore;
        _ -> ?ERR("角色[~s]的连接器进程[~w]异常退出，原因:~w", [Name, Pid, Why])
    end,
    catch gen_tcp:close(Socket),
    self() ! disconnect,
    {noreply, State};

handle_info(disconnect, State = #role{combat_pid = CombatPid, link = #link{socket = Socket, conn_pid = ConnPid}}) ->
    case erlang:port_info(Socket)=/=undefined andalso is_pid(ConnPid) andalso util:is_process_alive(ConnPid) of
        true -> %% 连接器进程还在连接状态中
            {noreply, State};
        false -> %% 连接器进程已退出
            case is_pid(CombatPid) andalso util:is_process_alive(CombatPid) of
                true -> %% 目前正在战斗中，不能退出角色进程，5秒后再尝试
                    case get(ref_timer_disconnect) of
                        undefined -> ignore;
                        %% 如果之前存在有disconnect定时器则先清除掉
                        Ref -> erlang:cancel_timer(Ref)
                    end,
                    put(ref_timer_disconnect, erlang:send_after(5000, self(), disconnect)),
                    combat:role_disconnect(State),
                    {noreply, State};
                false ->
                    stop(async, self(), <<>>),
                    {noreply, role_listener:disconnect(State)}
        end
    end;

%% 将角色踢下线(异步操作)
handle_info({stop, Msg}, State) ->
    do_stop(State, Msg),
    {stop, normal, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    ?DEBUG("role terminate"),
    case get(already_handle_stop) of
        true -> ignore;
        _ ->
            do_stop(State, <<>>)
    end,
    ok.

code_change(_OldVsn, State, _Extra) ->
    ?DEBUG("代码热更新[OldVsn:~w~n State:~w~n Extra:~w]", [_OldVsn, State, _Extra]),
    %% [_ | S] = tuple_to_list(State),
    %% S1 = S ++ [abcabc],
    %% NewState = list_to_tuple([role | S1]),
    %% {ok, NewState}.
    {ok, State}.

format_stats(_, _) ->
    state.

%-ifdef(debug).
%format_status(terminate, {_Dict, State}) ->
%    io:format("~p", [State]),
%    State.
%-else.
%format_status(terminate, {_Dict, State}) ->
%    io:format("~p", [State]),
%    State.
%-endif.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------
%% -> State
do_connect(State, Link, _Conn) ->
    ConnPid = Link#link.conn_pid,
    case Link =/= State#role.link of
        true -> do_close_conn(State);
        _ -> ignore
    end,
    link(ConnPid),
    State1 = State#role{link = Link},
    State2 = role_listener:connect(State1),
    State3 = case put(conn_pid, ConnPid) of %% 缓存连接器进程，以供缓冲区发送时直接调用
        undefined -> State2;  %% 首次连接
        _ -> role_listener:switch(State2)  %% 重连接
    end,
    State3.
   
do_close_conn(#role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 1024, {?disconn_login_conflict, <<>>}),
    timer:sleep(20),
    unlink(ConnPid),
    sys_conn:close(ConnPid).

%% 处理快速退出操作，暂不回写数据到mysql，快速关机时使用
do_stop(State) ->
    put(already_handle_stop, true),
    role_mgr:sync(State),
    role_listener:logout(State).
%% 处理正常退出操作，并将角色数据回写到mysql
do_stop(State = #role{id = Id}, <<>>) ->
    put(already_handle_stop, true),
    role_mgr:sync(State),
    role_listener:logout(State),
    role_mgr:sync_to_db(Id);
do_stop(State = #role{id = Id, link = #link{socket = Socket}}, Msg) ->
    put(already_handle_stop, true),
    role_mgr:sync(State),
    {ok, Bin} = sys_conn:pack(1024, {?disconn_kick, Msg}),
    catch gen_tcp:send(Socket, Bin), %% 无视所有错误，注意当玩家网络很差时这里执行时间会比较长
    role_listener:logout(State),
    role_mgr:sync_to_db(Id).    

%% 同步处理
sync(Role) ->
    N = get(sync_counter),
    case N > 10 of
        true ->
            role_mgr:sync(Role),
            put(sync_counter, 1);
        _ ->
            put(sync_counter, N + 1)
    end.

%% 获取#role{}中的某些属性
do_element([], _State, _MaxPos, L) -> L;
do_element([H | T], State, MaxPos, L) when H > 0 andalso H =< MaxPos  ->
    do_element(T, State, MaxPos, [erlang:element(H, State) | L]);
do_element([H | T], State, MaxPos, L) ->
    ?ERR("传给role:element/2的参数不正确: ~w", [H]),
    do_element(T, State, MaxPos, L).

%% 通知连接器读取下一条指令
read_next(ConnPid, State) ->
    ConnPid ! read_next,
    {noreply, State}.

%% 处理异步apply的返回值
handle_apply_async_return({ok, NewState}, _Mfa, State) when is_record(NewState, role) ->
    rank:role_update(0, {}, State, NewState), %% 排行榜监听接口
    NState = campaign_listener:loss_gold(State, NewState, role_async, 0, {_Mfa}), %% 晶钻消费活动
    {noreply, NState};
handle_apply_async_return({ok}, _Mfa, State) ->
    {noreply, State};
handle_apply_async_return(Else, {M, F, A}, State) ->
    ?ERR("角色[~s]执行{~w, ~w, ~w}时得到错误的返回值格式:~w", [State#role.name, M, F, A, Else]),
    {noreply, State}.

%% 处理同步apply的返回值
handle_apply_sync_return({ok, Reply, NewState}, _Mfa, State) when is_record(NewState, role) ->
    rank:role_update(0, {}, State, NewState), %% 排行榜监听接口
    NState = campaign_listener:loss_gold(State, NewState, role_sync, 0, {_Mfa}), %% 晶钻消费活动
    {reply, Reply, NState};
handle_apply_sync_return({ok, Reply}, _Mfa, State) ->
    {reply, Reply, State};
handle_apply_sync_return(Else, {M, F, A}, State) ->
    ?ERR("角色[~s]同步执行{~w, ~w, ~w}时得到错误的返回值格式:~w", [State#role.name, M, F, A, Else]),
    {reply, Else, State}.

%% 处理定时器apply的返回值
handle_timer_return({ok, NewState}, TimingId, State) when is_record(NewState, role) ->
    rank:role_update(0, {}, State, NewState), %% 排行榜监听接口
    NState = campaign_listener:loss_gold(State, NewState, role_timer, 0, {TimingId}), %% 晶钻消费活动
    {noreply, role_timer:handle_timer(NState, TimingId)};
handle_timer_return({ok}, TimingId, State) ->
    {noreply, role_timer:handle_timer(State, TimingId)};
handle_timer_return(Else, TimingId, State) ->
    ?ERR("角色[~s]执行定时器{~w}时得到错误的返回值格式:~w", [State#role.name, TimingId, Else]),
    {noreply, State}.
