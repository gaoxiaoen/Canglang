%%----------------------------------------------------
%% 帐号管理进程
%% 
%% @author
%% @end
%%----------------------------------------------------
-module(account_mgr).
-behaviour(gen_server).
-export([
    get_binding/1
    ,is_binded/1
    ,is_registered/2
    ,whereis/2
    ,register/3
    ,rename/3
    ,markRenamed/3
    ,rename_lookup/2
    ,rename_fix/1
    ,start_link/0
    ,reload_binding/0
]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
%%
-define(ETS_BIND_ACC, ets_bind_acc).
-define(ETS_BINDED_ACC, ets_binded_acc).
-record(state, {}).

%% 获取当前帐号绑定的另一个帐号
%% -> {bin(), bin()} | null
get_binding({GmAcc, GmPlatform}) ->
    case catch ets:lookup(?ETS_BIND_ACC, {GmAcc, GmPlatform}) of
        [] -> null;
        [{_, {PlayerAcc, PlayerPlatform}}|_] -> {PlayerAcc, PlayerPlatform};
        _ -> null
    end.

%% 当前帐号是否被其它帐号绑定
is_binded({PlayerAcc, PlayerPlatform}) ->
    case catch ets:lookup(?ETS_BINDED_ACC, {PlayerAcc, PlayerPlatform}) of
        [] -> false;
        [_|_] -> true;
        _ -> false
    end.    

%% (binary(), binary()) -> true | false
is_registered(Account, Platform) ->
    ets:member(?MODULE, {Account, Platform}).

%% -> undefined | pid()
whereis(Account, Platform) ->
    case ets:lookup(?MODULE, {Account, Platform}) of
        [] -> undefined;
        [{_, Pid}|_] -> Pid
    end.

register(Pid, Account, Platform) ->
    gen_server:cast(?MODULE, {register, Pid, Account, Platform}).

rename(OldAccount, NewAccount, Platform) ->
    gen_server:call(?MODULE, {rename, OldAccount, NewAccount, Platform}).

markRenamed(OldAccount, NewAccount, Platform) ->
    log_rename(OldAccount, NewAccount, Platform),
    db:execute("UPDATE `account_rename` SET `done`=1 WHERE `old`=~s AND `new`=~s", [OldAccount, NewAccount]).

rename_lookup(Account, Platform) ->
    case db:get_row("SELECT `old`, `done` FROM `account_rename` WHERE `new`=~s AND `platform`=~s ORDER BY id DESC LIMIT 1", [Account, Platform]) of
        {ok, [Old, Done]} ->
            case Done of 
                1 -> Account;
                0 -> Old   %% 有未完成的帐号绑定操作, 先登录旧的帐号
            end;
        _ ->
            Account
    end.

rename_fix(Role = #role{account = Account, platform = Platform}) ->
    case db:get_row("SELECT `new`, `done` FROM `account_rename` WHERE `old`=~s AND `platform`=~s ORDER BY id DESC LIMIT 1", [Account, Platform]) of
        {ok, [NewAccount, Done]} when is_binary(NewAccount) ->
            case Done of
                1 -> 
                    Role;
                0 ->
                    case role_api:bind_account(Role, Account, NewAccount, Platform) of
                        {ok, NewRole} -> NewRole;
                        _ -> Role
                    end
            end;
        _ ->
            Role
    end.

log_rename(OldAccount, NewAccount, Platform) ->
    db:execute("INSERT INTO `log_account_rename` (`old`, `new`, `platform`, `time`) VALUES (~s, ~s, ~s, ~s)", [OldAccount, NewAccount, Platform, util:unixtime()]).

reload_binding() ->
   ?MODULE ! load_binding.

%% @doc 启动分线管理器
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(?MODULE, [public, named_table, set]),
    ets:new(?ETS_BIND_ACC,  [public, named_table, set]),
    ets:new(?ETS_BINDED_ACC,  [public, named_table, set]),
    catch load_binding(),
    {ok, #state{}}.

handle_call({rename, OldAccount, NewAccount, Platform}, _From, State) ->
    ?INFO("收到重命令通知 ~s -> ~s ~s", [OldAccount, NewAccount, Platform]),
    case db:get_one("SELECT `done` FROM account_rename WHERE `old`=~s AND `new`=~s AND `platform`=~s LIMIT 1", [OldAccount, NewAccount, Platform]) of
        {ok, 0} -> 
            ?INFO("执行重命令"),
            case erase({OldAccount, Platform}) of
                Pid when is_pid(Pid) ->
                    ets:delete(?MODULE, {OldAccount, Platform}),
                    ets:insert(?MODULE, {{NewAccount, Platform}, Pid}),
                    put({NewAccount, Platform}, Pid),
                    put(Pid, {NewAccount, Platform}),
                    case db:get_all("SELECT `id`, `srv_id` FROM `role` WHERE `account`=~s AND `platform`=~s", [OldAccount, Platform]) of
                        {ok, List} ->
                            try lists:foreach(fun([RoleId, SrvId])->
                                    case global:whereis_name({role, RoleId, SrvId}) of
                                        RolePid when is_pid(RolePid) ->
                                            role:apply(async, RolePid, {role_api, bind_account, [OldAccount, NewAccount, Platform]});
                                        _ ->
                                            ignore
                                    end
                                end, List) 
                            catch T:X ->
                                ?ERR("~p:~p", [T, X])
                            end;
                        _ ->
                            ignore
                    end;
                _ ->
                    ignore
            end;
        _ -> ignore
    end,
    {reply, ok, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({register, Pid, Account, Platform}, State) ->
    case put({Account, Platform}, Pid) of
        undefined -> ignore;
        OldPid-> 
            erase(OldPid),
            do_demonitor(OldPid)
    end,
    do_monitor(Pid),
    put(Pid, {Account, Platform}),
    ets:insert(?MODULE, {{Account, Platform}, Pid}),
    {noreply, State};

handle_cast({unregister, Pid}, State) ->
    case erase(Pid) of
        undefined -> ignore;
        {Account, Platform} -> 
            do_demonitor(Pid),
            erase({Account, Platform}),
            ets:delete(?MODULE, {Account, Platform})
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(load_binding, State) ->
    catch load_binding(),
    {noreply, State};

%% 处理地图进程异常退出
handle_info({'EXIT', Pid, Why}, State) ->
    ?ELOG("连接的进程[~w]异常退出: ~w", [Pid, Why]),
    {noreply, State};

handle_info({'DOWN', Ref, _Type, _Object, _Info}, State) ->
    case do_demonitor(Ref) of
        undefined -> ignore;
        Pid ->
            case erase(Pid) of
                undefined -> ignore;
                {Account, Platform} -> 
                    erase({Account, Platform}),
                    ets:delete(?MODULE, {Account, Platform})
            end
    end,
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------

do_monitor(Pid) ->
    Ref = erlang:monitor(process, Pid),
    put({ref, Pid}, Ref),
    put({pid, Ref}, Pid).

%% -> ref() | undefined
do_demonitor(Pid) when is_pid(Pid) ->
    case erase({ref, Pid}) of
        undefined -> undefined;
        Ref -> 
            catch erlang:demonitor(Ref),
            erase({pid, Ref}), Ref
    end;
%% -> pid() | undefined
do_demonitor(Ref) ->
    case erase({pid, Ref}) of
        undefined -> undefined;
        Pid -> erase({ref, Pid}), Pid
    end.

%% -----
load_binding() ->
    case catch db:get_all("SELECT bind_acc, bind_platform, binded_acc, binded_platform FROM `binding_account`") of
        {ok, List} ->
            ets:delete_all_objects(?ETS_BIND_ACC),
            ets:delete_all_objects(?ETS_BINDED_ACC),
            lists:foreach(fun([BindAcc, BindPlatform, BindedAcc, BindedPlatform])->
                ets:insert(?ETS_BIND_ACC, {{BindAcc, BindPlatform}, {BindedAcc, BindedPlatform}}),
                ets:insert(?ETS_BINDED_ACC, {{BindedAcc, BindedPlatform}, {BindAcc, BindPlatform}})
            end, List),
            ok;
        _ -> ok
    end.

