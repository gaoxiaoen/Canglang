%%----------------------------------------------------
%% 排行榜角色信息
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(rank_role_info).
-behaviour(gen_server).
-export([
        start_link/0
        ,async/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {}).
-include("common.hrl").
-include("role.hrl").
-include("rank.hrl").

%% 异步方式 请求
async(Args) ->
    gen_server:cast(?MODULE, Args).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    State = #state{},
    ets:new(sys_rank_ext, [set, named_table, protected, {keypos, #rank_role.id}]), %%sys_rank_ext 用于保存金币达人信息
    ?INFO("[~w] 启动完成...", [?MODULE]),  
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 角色登录
handle_cast({login, RoleId}, State) ->
    case lookup(RoleId) of
        false -> %% 未加载，进行加载
            RankRole = rank_dao:load_role_info(RoleId),
            update_ets(RankRole);
        _ -> %% 已加载 
            ok
    end,
    {noreply, State};

%% 角色信息变化 12点清0
handle_cast({update_info, Label, Role = #role{id = RoleId}, Val}, State) ->
    case lookup(RoleId) of
        false -> false;
        RankRole = #rank_role{info = InfoList} ->
            Now = util:unixtime(),
            {NewInfoList, NewVal} = case lists:keyfind(Label, 1, InfoList) of
                {Label, OldVal, Time} ->
                    case util:is_same_day2(Now, Time) of
                        true -> {lists:keyreplace(Label, 1, InfoList, {Label, OldVal + Val, Now}), OldVal + Val};
                        false -> {lists:keyreplace(Label, 1, InfoList, {Label, Val, Now}), Val}
                    end;
                _ ->
                    {[{Label, Val, Now} | InfoList], Val}
            end,
            NewRankRole = RankRole#rank_role{info = NewInfoList},
            update_ets_db(NewRankRole),
            rank:listener(Label, Role, NewVal)
    end,
    {noreply, State};

%% 删除指定角色信息
handle_cast({del, RoleId}, State) ->
    update_ets(#rank_role{id = RoleId}),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%-------------------------------------------
%% 内部方法
%%-------------------------------------------
%% 查询ets表
lookup(RoleId) ->
    case ets:lookup(sys_rank_ext, RoleId) of
        [RankRole = #rank_role{}] -> RankRole;
        _ -> false
    end.

%% 更新ets表
update_ets(RankRole) when is_record(RankRole, rank_role) ->
    ets:insert(sys_rank_ext, RankRole);
update_ets(_RankRole) -> ok.

%% 更新数据库和ETS表
update_ets_db(RankRole) ->
    update_ets(RankRole),
    rank_dao:save_role_info(RankRole).
