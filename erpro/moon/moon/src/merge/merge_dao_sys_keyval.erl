%%----------------------------------------------------
%% @doc 角色数据
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_keyval).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

-record(merge_sys_keyval, {
        key_type = <<>>
        ,value = 0
    }
).

do_init(Table = #merge_table{server = #merge_server{data_source = DataSource, index = Index}}) ->
    case Index =:= 1 of
        true -> ets:new(ets_merge_sys_keyval, [set, named_table, public, {keypos, #merge_sys_keyval.key_type}]);
        false -> ignore
    end,
    Sql = "select key_type, value from sys_keyval",
    case merge_db:get_all(DataSource, Sql, []) of
        {ok, Data} -> 
            do_load(Data, Index),
            {ok, [], Table};
        {error, Reason} -> {error, Reason}
    end.

%% 处理数据
do_convert([], Table = #merge_table{server = #merge_server{index = Size, size = Size}}) -> 
    List = ets:tab2list(ets_merge_sys_keyval),
    case deal(List) of
        ok -> {ok, Table};
        {error, Reason} -> {error, Reason}
    end;
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(#merge_table{server = #merge_server{index = Size, size = Size}}) -> 
    ets:delete(ets_merge_sys_keyval),
    ignore;
do_end(_Table) -> ignore.

do_load([], _Index) -> ok;
do_load([[KeyType, Value] | T], Index) ->
    case ets:lookup(ets_merge_sys_keyval, KeyType) of
        [] -> ets:insert(ets_merge_sys_keyval, #merge_sys_keyval{key_type = KeyType, value = Value});
        [Msk = #merge_sys_keyval{value = Val}] ->
            ets:insert(ets_merge_sys_keyval, Msk#merge_sys_keyval{value = Value + Val})
    end,
    do_load(T, Index).

deal([]) -> ok;
deal([#merge_sys_keyval{key_type = KeyType, value = Value} | T]) ->
    Sql = "insert into sys_keyval (key_type, value) values (~s, ~s)",
    case merge_db:execute(?merge_target, Sql, [KeyType, Value]) of
        {ok, 1} ->
            deal(T);
        {error, Reason} ->
            {error, Reason}
    end.


