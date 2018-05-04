%%----------------------------------------------------
%% @doc 系统选项表
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_env).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
        ,update_srv_id/1
    ]
).

-include("common.hrl").
-include("merge.hrl").
-include("lottery.hrl").

-record(merge_sys_env, {
        name
        ,list = []      %% [{Index, Val}]
    }
).

%%----------------------------------------------------
%% API
%%----------------------------------------------------
do_init(Table = #merge_table{server = #merge_server{data_source = DataSource, index = Index}}) ->
    case Index =:= 1 of
        true -> ets:new(ets_merge_sys_env, [set, named_table, public, {keypos, #merge_sys_env.name}]);
        false -> ignore
    end,
    Sql = "select name, val from sys_env",
    case merge_db:get_all(DataSource, Sql, []) of
        {ok, Data} -> 
            case insert(Data, Index) of
                {error, Reason} -> {error, Reason};
                ok -> {ok, [], Table}
            end;
        {error, Reason} -> {error, Reason}
    end.

%% 处理数据
do_convert([], Table = #merge_table{server = #merge_server{index = Size, size = Size}}) -> 
    List = ets:tab2list(ets_merge_sys_env),
    case deal(List) of
        ok -> {ok, Table};
        {error, Reason} -> {error, Reason}
    end;
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table = #merge_table{server = #merge_server{index = Size, size = Size}}) -> 
    ets:delete(ets_merge_sys_env),
    ignore;
do_end(_Table) -> ignore.

%% 转换SrvId
update_srv_id(_Table = #merge_table{server = #merge_server{data_source = DataSource}, old_srv_id = OldSrvId, new_srv_id = NewSrvId}) ->
    Sql = "select name, val from sys_env",
    case merge_db:get_all(DataSource, Sql, []) of
        {ok, Data} -> 
            NewData = [[list_to_atom(util:to_list(Name)), Val] || [Name, Val] <- Data],
            do_update_srv_id(NewData, DataSource, OldSrvId, NewSrvId);
        {error, Reason} -> {error, Reason}
    end.

%%----------------------------------------------------
%%----------------------------------------------------
insert([], _) -> ok;
insert([[Name, Val] | T], Index) ->
    case ets:lookup(ets_merge_sys_env, list_to_atom(util:to_list(Name))) of
        [] -> 
            case util:bitstring_to_term(Val) of
                {ok, Term} ->
                    ets:insert(ets_merge_sys_env, #merge_sys_env{name = list_to_atom(util:to_list(Name)), list = [{Index, Term}]}),
                    insert(T, Index);
                {error, Reason} -> {error, Reason}
            end;
        [Env = #merge_sys_env{list = List}] ->
            case util:bitstring_to_term(Val) of
                {ok, Term} ->
                    ets:insert(ets_merge_sys_env, Env#merge_sys_env{list = [{Index, Term} | List]}),
                    insert(T, Index);
                {error, Reason} -> {error, Reason}
            end
    end.
%% insert([[Name, Val] | T], ?merge_db_slave) ->
%%     case ets:lookup(ets_merge_sys_env, list_to_atom(util:to_list(Name))) of
%%         [] -> 
%%             case util:bitstring_to_term(Val) of
%%                 {ok, Term} ->
%%                     ets:insert(ets_merge_sys_env, #merge_sys_env{name = list_to_atom(util:to_list(Name)), val_slave= Term}),
%%                     insert(T, ?merge_db_slave);
%%                 {error, Reason} -> {error, Reason}
%%             end;
%%         [Env] ->
%%             case util:bitstring_to_term(Val) of
%%                 {ok, Term} ->
%%                     ets:insert(ets_merge_sys_env, Env#merge_sys_env{val_slave= Term}),
%%                     insert(T, ?merge_db_slave);
%%                 {error, Reason} -> {error, Reason}
%%             end
%%     end.

deal([]) -> ok;
deal([#merge_sys_env{name = guild_td_state, list = List} | T]) ->
    NewVal = merge_td(List),
    deal_insert(T, guild_td_state, NewVal);
deal([#merge_sys_env{name = lottery_state, list = List} | T]) ->
    case merge_lottery(List) of
        ignore -> deal(T);
        NewVal -> deal_insert(T, lottery_state, NewVal)
    end;
deal([#merge_sys_env{name = market_average_price, list = List} | T]) ->
    case List of
        [{_Index, Val} | _] -> deal_insert(T, market_average_price, Val);
        _ -> deal(T)
    end;
deal([#merge_sys_env{name = rank_reward_flag_3, list = List} | T]) ->
    case List of
        [{_Index, Val} | _] -> deal_insert(T, rank_reward_flag_3, Val);
        _ -> deal(T)
    end;
deal([#merge_sys_env{name = rank_reward_flag_5, list = List} | T]) ->
    case List of
        [{_Index, Val} | _] -> deal_insert(T, rank_reward_flag_5, Val);
        _ -> deal(T)
    end;
deal([#merge_sys_env{name = guild_arena_mgr_state, list = List} | T]) ->
    ?DEBUG("开始合并 ~w", [List]),
    NewVal = merge_guild_arena_mgr(List),
    deal_insert(T, guild_arena_mgr_state, NewVal);
deal([#merge_sys_env{name = kuafu_friend_roles, list = List} | T]) ->
    NewList = merge_list_of_list(List),
    deal_insert(T, kuafu_friend_roles, NewList);
deal([#merge_sys_env{name = ascened_role_list, list = List} | T]) ->
    NewList = merge_list_of_list(List),
    deal_insert(T, ascened_role_list, NewList);
deal([#merge_sys_env{name = pandora_box, list = List} | T]) ->
    case merge_pandora_box(List) of
        ignore -> deal(T);
        NewVal -> deal_insert(T, pandora_box, NewVal)
    end;
deal([_Env | T]) ->
    deal(T).

deal_insert(T, Name, Val) ->
    Sql = "insert into sys_env(name, val) values (~s, ~s)",
    case merge_db:execute(?merge_target, Sql, [Name, util:term_to_string(Val)]) of
        {ok, _} ->
            deal(T);
        {error, Reason} ->
            {error, Reason}
    end.

merge_td([]) -> [];
merge_td([{_Index, Val} | T]) when is_list(Val) ->
    Val ++ merge_td(T);
merge_td([{_Index, Val} | T]) ->
    ?ERR("sys_env guild_td_state error val:~w", [Val]),
    merge_td(T).

merge_lottery([]) -> ignore;
merge_lottery([{_Index, Val} | T]) ->
    case merge_lottery(T) of
        ignore -> Val;
        NewVal -> 
            lottery:adm_merge(Val, NewVal)
    end.

merge_pandora_box([]) -> ignore;
merge_pandora_box([{_, Val} | T]) ->
    merge_pandora_box(Val, T).
merge_pandora_box(Val, []) -> Val;
merge_pandora_box(Val, [{_, V} | T]) ->
    NewVal = pandora_box:srv_merge(Val, V),
    merge_pandora_box(NewVal, T).

merge_guild_arena_mgr([]) -> ignore;
merge_guild_arena_mgr([{_, One}]) -> One;
merge_guild_arena_mgr([{_, A}, {_, B} | T]) ->
    merge_guild_arena_mgr([{ok, guild_arena_mgr:adm_merge(A, B)} | T]).

%% 合并lists
merge_list_of_list([]) -> [];
merge_list_of_list(List) ->
    merge_list_of_list(List, []).
merge_list_of_list([], Back) -> Back;
merge_list_of_list([H | T], Back) when is_list(H) ->
    merge_list_of_list(T, H ++ Back);
merge_list_of_list([_H | T], Back) ->
    merge_list_of_list(T, Back).

%% 修改SrvId
do_update_srv_id([], _DataSource, _OldSrvId, _NewSrvId) -> ok;
do_update_srv_id([[guild_td_state, Val] | T], DataSource, OldSrvId, NewSrvId) ->
    case util:bitstring_to_term(Val) of
        {ok, Term} when is_list(Term) ->
            Fun = fun({{Gid, GsrvId}, NowMode, Tmr}) ->
                NewSrvId = case GsrvId =:= OldSrvId of
                    true -> NewSrvId;
                    false -> GsrvId
                end,
                {{Gid, NewSrvId}, NowMode, Tmr}
            end,
            NewList = lists:map(Fun, Term),
            update(DataSource, guild_td_state, NewList, T, OldSrvId, NewSrvId);
        {error, Reason} -> {error, Reason}
    end;
do_update_srv_id([[lottery_state, _Val] | T], DataSource, OldSrvId, NewSrvId) ->
    %% case util:bitstring_to_term(Val) of
    %%     {ok, Term = #lottery_state{last_first = {Rid, SrvId, Name, Num}, log = LogList}} ->
    %%         NewSrvId = case SrvId =:= OldSrvId of
    %%             true -> NewSrvId;
    %%             false -> SrvId
    %%         end,
    %%         NewLogList = convert_log(LogList, OldSrvId, NewSrvId),
    %%         update(DataSource, lottery_state, Term#lottery_state{last_first = {Rid, NewSrvId, Name, Num}, log = NewLogList}, T, OldSrvId, NewSrvId);
    %%     _ -> {error, lottery_state_error}
    %% end;
    Sql = "delete from sys_env where name = ~s",
    case merge_db:execute(DataSource, Sql, [util:term_to_string(lottery_state)]) of
        {ok, _} -> ok;
        {error, Reason} ->
            ?ERR("删除sys_env lottery_log 出错了:~w", [Reason]),
            continue
    end,
    do_update_srv_id(T, DataSource, OldSrvId, NewSrvId);
do_update_srv_id([[_Name, _Val] | T], DataSource, OldSrvId, NewSrvId) ->
    do_update_srv_id(T, DataSource, OldSrvId, NewSrvId).

update(DataSource, Name, Val, T, OldSrvId, NewSrvId) ->
    Sql = "update sys_env set val = ~s where name = ~s",
    case merge_db:execute(DataSource, Sql, [util:term_to_string(Val), Name]) of
        {ok, _} ->
            do_update_srv_id(T, DataSource, OldSrvId, NewSrvId);
        {error, Reason} ->
            {error, Reason}
    end.

%% convert_log([], _OldSrvId, _NewSrvId) -> [];
%% convert_log([Log = #lottery_log{srv_id = OldSrvId} | T], OldSrvId, NewSrvId) ->
%%     [Log#lottery_log{srv_id = NewSrvId} | convert_log(T, OldSrvId, NewSrvId)];
%% convert_log([Log | T], OldSrvId, NewSrvId) ->
%%     [Log | convert_log(T, OldSrvId, NewSrvId)].

