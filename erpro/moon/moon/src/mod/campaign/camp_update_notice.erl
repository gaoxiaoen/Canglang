%%----------------------------------------------------
%% 更新公告
%% 
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-module(camp_update_notice).
-behaviour(gen_server).
-export([
        reload/0
        ,cast/1
        ,list_all/0
        ,list_all/1
        ,start_link/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("campaign.hrl").

-record(state, {}).

%% 所有更新公告
list_all() ->
    case catch ets:tab2list(camp_update_notice_list) of
        L when is_list(L) -> L;
        _ -> []
    end.

%% 获取所有当前时间有效更新公告
list_all(Now) ->
    L = list_all(),
    list_all(Now, L).
list_all(Now, L) ->
    [Notice || Notice = #camp_update_notice{start_time = StartTime, end_time = EndTime} <- L, StartTime =< Now, Now < EndTime].

%% 重载数据
reload() ->
    gen_server:cast(?MODULE, reload).

%% 异步信息
cast(Args) ->
    gen_server:cast(?MODULE, Args).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    State = #state{},
    ets:new(camp_update_notice_list, [set, named_table, protected, {keypos, #camp_update_notice.id}]),
    do_reload(),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 重载数据
handle_cast(reload, State) ->
    L = do_reload(),
    refresh_client(L),
    {noreply, State};

%% 清空所有公告
handle_cast(clear, State) ->
    ets:delete_all_objects(camp_update_notice_list),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 刷新客户端更新公告数据
handle_info(refresh_client, State) ->
    ?DEBUG("开始更新客户端更新信息"),
    L = list_all(),
    refresh_client(L),
    reg_time_refresh_client(L),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------
%% 内部方法
%%----------------------------------------

%% 执行加载
do_reload() ->
    OldL = list_all(),
    L = load_all(),
    ?INFO("重载更新公告数据成功...[~p] -> [~p]", [length(OldL), length(L)]),
    ets:delete_all_objects(camp_update_notice_list),
    ets:insert(camp_update_notice_list, L),
    reg_time_refresh_client(L),
    L.

%% 更新客户端
refresh_client(L) ->
    Now = util:unixtime(),
    NowL = list_all(Now, L),
    ?DEBUG("重新广播更新公告数据列表给客户端...[~p]", [length(NowL)]),
    role_group:pack_cast(world, 15820, {NowL}).

%% 注册下一次客户端更新时间
reg_time_refresh_client(L) ->
    Now = util:unixtime(),
    case get_next_refresh_time(L, Now, 0) of
        NextTime when NextTime > Now ->
            T = lists:min([NextTime - Now, 10 * 24 * 3600]),
            ?DEBUG("更新公告开启/关闭时间注册，定时更新客户端数据[~p]", [T]),
            NewRef = erlang:send_after(T * 1000, self(), refresh_client),
            reset_send_after(refresh_client, NewRef);
        _ ->
            ok
    end.

%% 获取下一次更新的最近时间(失效、开启)
get_next_refresh_time([], _Now, Time) -> Time;
get_next_refresh_time([#camp_update_notice{start_time = StartTime} | T], Now, Time) when StartTime > Now -> %% 当前未开始
    case StartTime < Time orelse Time < Now of
        true -> get_next_refresh_time(T, Now, StartTime); %% 当前开始时间最接近当前时间
        _ -> get_next_refresh_time(T, Now, Time)
    end;
get_next_refresh_time([#camp_update_notice{end_time = EndTime} | T], Now, Time) when EndTime > Now -> %% 当前未结束
    case EndTime < Time orelse Time < Now of
        true -> get_next_refresh_time(T, Now, EndTime); %% 当前结束时间最接近当前时间
        _ -> get_next_refresh_time(T, Now, Time)
    end;
get_next_refresh_time([_ | T], Now, Time) ->
    get_next_refresh_time(T, Now, Time).

%% 重置定时器
reset_send_after(Key, NewRef) ->
    case get(Key) of
        undefined -> ok;
        Ref -> catch erlang:cancel_timer(Ref)
    end,
    put(Key, NewRef).

%% 加载数据
load_all() ->
    Sql = "select id, new_content, update_content, bug_content, start_time, end_time from sys_update_notice where status = 2 and end_time > ~s",
    Now = util:unixtime(),
    case db:get_all(Sql, [Now]) of
        {ok, Rows} ->
            Fun = fun([Id, NewContent, UpdateContent, BugContent, StartTime, EndTime]) -> 
                    #camp_update_notice{id = Id, new_content = NewContent, update_content = UpdateContent, bug_content = BugContent, start_time = StartTime, end_time = EndTime} 
            end,
            lists:map(Fun, Rows);
        _ -> 
            ?ERR("加载更新公告数据失败"),
            []
    end.
