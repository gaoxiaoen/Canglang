%% ******************************
%%  附加、其他附属功能 管理模块
%% @author wpf wpf0208@jieyou.cn
%% ******************************
-module(misc_mgr).
-behaviour(gen_server).
-export([
        login/1
        ,check_chat_circle/2
        ,get_realm_change_cnt/0
        ,add_realm_change_cnt/0
        ,clean_realm_change_cnt/0
        ,lock/2
        ,lock/4
    ]).
-export([start_link/0, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("role.hrl").
-include("chat_rpc.hrl").
-include("misc.hrl").

%% @spec login(Role) -> ok
%% @doc 登陆检查并处理附加项数
%% <div> 不返回NewRole，不保存数据 </div>
login(Role) ->
    do_login(chat_limit, Role).
% do_login(chat_limit, #role{id = Id, lev = Lev}) when Lev =< 15 ->
%     case catch ets:lookup(ets_chat_circle_limit, Id) of
%         [CL = #chat_circle_limit{last = LastTime}] ->
%             case util:unixtime(today) < LastTime of
%                 true -> %% 同一天
%                     ignore;
%                 false ->
%                     catch ets:insert(ets_chat_circle_limit, CL#chat_circle_limit{last = util:unixtime(), list = []})
%             end;
%         _ ->
%             catch ets:insert(ets_chat_circle_limit, #chat_circle_limit{id = Id, last = util:unixtime(), list = []})
%     end;
% do_login(chat_limit, #role{id = Id}) ->
%     case catch ets:lookup(ets_chat_circle_limit, Id) of
%         [CL = #chat_circle_limit{last = LastTime}] ->
%             case util:unixtime(today) < LastTime of
%                 true -> %% 同一天
%                     ignore;
%                 false ->
%                     catch ets:insert(ets_chat_circle_limit, CL#chat_circle_limit{last = util:unixtime(), list = []})
%             end;
%         _ ->
%             catch ets:insert(ets_chat_circle_limit, #chat_circle_limit{id = Id, last = util:unixtime(), list = []})
%     end;
do_login(_, _) -> ignore.
                    

%% @spec check_chat_circle(Role, OtherId) -> ok | false
%% @doc 检查是否可以发送私聊
%% <div> 限制15级以下,当天只能与10个人私聊 </div>
check_chat_circle(#role{lev = Lev}, _OtherId) 
when Lev > 15 ->
    ok;
check_chat_circle(#role{id = Id}, OtherId) ->
    case ets:lookup(ets_chat_circle_limit, Id) of
        [CL = #chat_circle_limit{list = []}] ->
            ets:insert(ets_chat_circle_limit, CL#chat_circle_limit{list = [OtherId]}),
            ok;
        [CL = #chat_circle_limit{list = L}] when is_list(L) ->
            case lists:member(OtherId, L) of
                true -> ok;
                false ->
                    case length(L) of
                        Len when Len > 10 -> false;
                        _ ->
                            ets:insert(ets_chat_circle_limit, CL#chat_circle_limit{list = [OtherId | L]}),
                            ok
                    end
            end;
        _ ->
            ets:insert(ets_chat_circle_limit, #chat_circle_limit{id = Id, last = util:unixtime(), list = [OtherId]}),
            ok
    end;
check_chat_circle(_, _) -> false.

%% @spec get_realm_change_cnt() -> integer()
%% @doc 增加当天阵营转换
get_realm_change_cnt() ->
    case ets:lookup(ets_change_realm_log, date()) of
        [] -> 0;
        [{_, Cnt}] -> Cnt;
        _ -> 0
    end.

%% @spec add_realm_change_cnt() -> any()
%% @doc 增加当天阵营转换
add_realm_change_cnt() ->
    case ets:lookup(ets_change_realm_log, date()) of
        [] ->
            ets:insert(ets_change_realm_log, {date(), 1});
        [{_, Cnt}] ->
            ets:insert(ets_change_realm_log, {date(), Cnt+1});
        _ -> ignore
    end,
    ok.

%% @spec clean_realm_change_cnt() -> any()
%% @doc 清除当天阵营转换人数信息
clean_realm_change_cnt() ->
    ets:insert(ets_change_realm_log, {date(), 0}),
    ok.

%% 封号
%% Rid = 角色ID
%% SrvId = 服务器标识
%% TIme = 禁言时间, 0表示永久
%% Msg = 备注
%% Adminname = 管理员名字
lock(#role{id = {RoleId, SrvId}, name = RoleName, anticrack = #anticrack{escort = Escort}}, escort) ->
    Now = util:unixtime(),
    case (Now -  Escort) < 40 of
        true -> 
            case filter_lock({RoleId, SrvId}, RoleName, <<"运镖速度异常">>, (Now - Escort)) of
                lock -> lock([{RoleId, SrvId}], 0, <<"运镖速度异常">>, <<"server">>);
                _ -> ignore
            end;
        false -> ignore
    end;
lock(#role{id = {RoleId, SrvId}, name = RoleName, anticrack = #anticrack{dungeon = Dungeon}}, dungeon) ->
    %% ignore.
    Now = util:unixtime(),
    ?DEBUG("=========================:~w, ~s", [(Now - Dungeon), RoleName]),
    case (Now -  Dungeon) < 60 of
        true -> 
            case filter_lock({RoleId, SrvId}, RoleName, <<"洛水殿速度异常">>, (Now - Dungeon)) of
                lock -> lock([{RoleId, SrvId}], 0, <<"洛水殿速度异常">>, <<"server">>);
                _ -> ignore
            end;
        false -> ignore
    end.
lock(RoleList, Time, Msg, AdminName) ->
    erlang:send_after(60 * 1000, ?MODULE, {lock, RoleList, Time, Msg, AdminName}).

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% @doc 创建附加杂项管理进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% --------------------------------
%% 内部函数
%% --------------------------------
do_init() ->
    %% -------------------
    %% 私聊限制
    ets:new(ets_chat_circle_limit, [public, named_table, {keypos, #chat_circle_limit.id}, set]),
    %% -------------------
    %% -------------------
    %% 跨服聊天筛选列表: {{Rid, SrvId}, IsOpen, Lasttime, Num}
    ets:new(ets_kuafu_friend_roles, [public, named_table, set, {keypos, 1}]),
    %% -------------------
    %% 阵营转换每天记录人数
    ets:new(ets_change_realm_log, [public, named_table, set, {keypos, 1}]),
    %% -------------------
    %% 神龙召唤活动兑换次数: [{RoleId, Cnt, Lasttime} | ...]
    ets:new(ets_bragon_boss_cnt, [public, named_table, set, {keypos, 1}]),
    %% -------------------
    %% 职业进阶记录：[{RoleId, LastTime} | ...]
    ets:new(ets_ascened_roles_log, [public, named_table, set, {keypos, 1}]),
    %% 角色改名记录[{RoleId, LastTime} | ...]
    ets:new(ets_role_name_used, [public, named_table, set, {keypos, #role_name_used.id}]),
    ok.

do_load() ->
    %% 跨服聊天筛选列表: {{Rid, SrvId}, IsOpen, Lasttime, Num}
    case sys_env:get(kuafu_friend_roles) of
        L1 when is_list(L1) ->
            lists:foreach(fun(X) -> ets:insert(ets_kuafu_friend_roles, X) end, L1);
        _ ->
            ?DEBUG("导入跨服聊天筛选角色列表"),
            ignore
    end,
    %% 职业进阶记录
    case sys_env:get(ascened_role_list) of
        L2 when is_list(L2) ->
            lists:foreach(fun(X) -> ets:insert(ets_ascened_roles_log, X) end, L2);
        _ ->
            ?DEBUG("导入跨服聊天筛选角色列表"),
            ignore
    end,
    %% 从mysql加载角色曾用名
    Sql = "select * from role_name_used",
    case db:get_all(Sql) of
        {error, undefined} -> ok;
        {error, Why} ->
            ?ERR("fetch_name_used时发生异常: ~s", [Why]),
            ok;
        {ok, Datas} ->
            F = fun([_Id, Rid, SrvId, Name, NewName, Sex, Career, Realm, Vip, Ctime]) ->
                    #role_name_used{
                        id = {Rid, SrvId}
                        ,name = Name
                        ,new_name = NewName
                        ,sex = Sex
                        ,career = Career
                        ,realm = Realm
                        ,vip = Vip
                        ,ctime = Ctime
                    }
            end,
            ets:insert(ets_role_name_used, [F(O) || O <- Datas])
    end,
    ok.

do_save() ->
    L = ets:tab2list(ets_kuafu_friend_roles),
    sys_env:save(kuafu_friend_roles, L),
    ok.

%% ------------------------------
%% gen_server内部处理
%% ------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    do_init(),
    do_load(),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, ok}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({lock, RoleList, Time, Msg, AdminName}, State) ->
    catch gm_adm:lock(RoleList, Time, Msg, AdminName),
    {noreply, State};

handle_info(_Info, State) ->
    ?DEBUG("忽略的异步消息：~w", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    do_save(),
    ?DEBUG("misc服务进程关闭"),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------
%% interval fun
%% ------------------------------
filter_lock({RoleId, SrvId}, RoleName, Type, Time) ->
    case ets:lookup(charge_info_for_notice,  {RoleId, SrvId}) of
        [{_, Gold}] when Gold > 1000 -> 
            ?ERR("账号异常但不封号[RoleId:~w, SrvId:~s, RoleName:~s][类型:~s][Gold:~w][Time:~w]", [RoleId, SrvId, RoleName, Type, Gold, Time]),
            ignore;
        _ -> lock
    end.
