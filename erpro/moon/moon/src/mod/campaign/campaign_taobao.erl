%%----------------------------------------------------
%% 淘宝10年活动
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(campaign_taobao).

-behaviour(gen_server).

-export([
        start_link/0
        ,reload/0
        ,get_status/2
        ,reward/2
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(camp_taobao_role, {
        id = {0, <<>>}      %% 角色id
        ,name = <<>>
        ,status = 0
    }
).
-record(state, {}).

-define(camp_taobao_campid, taobao20130425).   %% 活动id

-include("common.hrl").

%%----------------------------------------------------
%% API
%%----------------------------------------------------
%% 启动
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 重载
reload() ->
    gen_server:cast(?MODULE, {reload}).

%% @spec get_status(Rid::integer(), SrvId::binary()) -> Status::integer()
%% 获取个人状态
get_status(Rid, SrvId) ->
    case gen_server:call(?MODULE, {get_status, Rid, SrvId}) of
        Status when is_integer(Status) -> Status;
        _ -> 2
    end.

%% @spec reward(Rid::integer(), SrvId::binary()) -> {false, Reason::binary()} | ok
%% 领取
reward(Rid, SrvId) ->
    case catch gen_server:call(?MODULE, {reward, Rid, SrvId}) of
        {false, Reason} -> {false, Reason};
        ok -> ok;
        _ -> {false, <<"领取失败">>}
    end.
%%----------------------------------------------------
%% gen_server fun
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(ets_taobao10year, [set, named_table, public, {keypos, #camp_taobao_role.id}]),
    do_reload(),
    State = #state{},
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call({get_status, Rid, SrvId}, _From, State) ->
    Status = case ets:lookup(ets_taobao10year, {Rid, SrvId}) of
        [#camp_taobao_role{status = St}] -> St;
        _ -> 2
    end,
    {reply, Status, State};

handle_call({reward, Rid, SrvId}, _From, State) ->
    Reply = case ets:lookup(ets_taobao10year, {Rid, SrvId}) of
        [CampRole = #camp_taobao_role{status = 0}] ->
            case update_status(Rid, SrvId) of
                {ok, Affected} when Affected > 0 ->
                    ets:insert(ets_taobao10year, CampRole#camp_taobao_role{status = 1}),
                    ok;
                _ -> {false, <<"领取失败">>}
            end;
        _ -> {false, <<"不可以领取">>}
    end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({reload}, State) ->
    Now = util:unixtime(),
    case get(reload_time) of
        undefined ->
            do_reload(),
            put(reload_time, Now);
        Time when (Time + 3) < Now ->
            do_reload(),
            put(reload_time, Now);
        _ -> ignore
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% internal
%%----------------------------------------------------
%% 重载数据
do_reload() ->
    case get_all() of 
        {ok, Data} ->
            ets:delete_all_objects(ets_taobao10year),
            insert_ets(Data);
        {false, Reason} ->
            {false, Reason}
    end.

get_all() ->
    Sql = <<"select rid, srv_id, name, status from sys_camp_progress where type = 'taobao10year' and camp_id = ~s and status = 0">>,
    case db:get_all(Sql, [?camp_taobao_campid]) of
        {ok, Data} -> {ok, Data};
        {error, Msg} ->
            ?ERR("执行数据库出错了[Msg:~w]", [Msg]),
            {false, Msg}
    end.

insert_ets([]) -> ok;
insert_ets([[Rid, SrvId, Name, Status] | T]) ->
    ets:insert(ets_taobao10year, #camp_taobao_role{id = {Rid, SrvId}, name = Name, status = Status}),
    insert_ets(T).

update_status(Rid, SrvId) ->
    Sql = <<"update sys_camp_progress set status = 1 where rid = ~s and srv_id = ~s and type = 'taobao10year'">>,
    db:execute(Sql, [Rid, SrvId]).
