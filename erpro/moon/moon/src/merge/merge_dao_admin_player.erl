%%----------------------------------------------------
%% @doc 账号表
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_admin_player).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

-record(merge_admin_player, {
        name 
        ,passwd
    }
).

do_init(Table = #merge_table{server = #merge_server{data_source = DataSource, index = Index}}) ->
    Sql = "select name, passwd from admin_player",
    case merge_db:get_all4page(DataSource, Sql, [], 3000) of
        {ok, Data} -> 
            case Index =:= 1 of
                true ->
                    ets:new(ets_merge_admin_player, [set, named_table, public, {keypos, #merge_admin_player.name}]);
                _ -> ignore
            end,
            {ok, Data, Table};
        {error, Reason} -> {error, Reason}
    end.

%% 处理数据
do_convert([], Table) -> {ok, Table};
do_convert([[Name, Passwd] | T], Table = #merge_table{server = #merge_server{index = 1}}) ->
    Sql = "insert into admin_player(name, passwd) values (~s, ~s)",
    case merge_db:execute(?merge_target, Sql, [Name, Passwd]) of
        {ok, 1} ->
            ets:insert(ets_merge_admin_player, #merge_admin_player{name = Name, passwd = Passwd}),
            do_convert(T, Table);
        {error, Reason} ->
            {error, Reason}
    end;
do_convert([[Name, Passwd] | T], Table = #merge_table{}) ->
    case ets:lookup(ets_merge_admin_player, Name) of
        [] ->
            Sql = "insert into admin_player (name, passwd) values (~s, ~s)",
            case merge_db:execute(?merge_target, Sql, [Name, Passwd]) of
                {ok, 1} -> 
                    ets:insert(ets_merge_admin_player, #merge_admin_player{name = Name, passwd = Passwd}),
                    do_convert(T, Table);
                {error, Reason} -> {error, Reason}
            end;
        _ -> 
            do_convert(T, Table)
    end.

%% 最后执行一下,释放资源
do_end(#merge_table{server = #merge_server{index = Index, size = Size}}) when Index =:= Size -> 
    ets:delete(ets_merge_admin_player),
    ignore;
do_end(_Table) -> ignore.
