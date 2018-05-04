%% @filename db_api.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-01-11 
%% @doc 
%% 数据库API，即操作数据库都必须通过此模块调用.
%% 游戏Mnesia数据库设计：
%% 1.在单节点下，使用Mnesia做为游戏数据库，不存放游戏的日志数据据
%% 2.使用脏读，脏写的方式来操作数据库
%% 3.少量的事务操作
%% 4.解决Mnesia使用dets为持久化操作的文件大少问题，即单表文件不能大于2G
%%   [自动创建分表的方式来处理，不使用mnesia fragmentation方式处理，不支持dirty_read or dirty_write]
%% 5.配置业务加载数据到内存，减少单服游戏运行内存占用过大问题

-module(db_api).

-include("db.hrl").

-export([
         transaction/1,
         abort/1,
         
         read/2,
         read/3,
         write/3,
         delete/3,
         delete_object/3,
         
         dirty_read/2,
         dirty_write/2,
         dirty_delete/2,
         dirty_select/2,
         dirty_match_object/2,
         
         dirty_all_read/2,
         dirty_all_write/2,
         dirty_all_delete/2,
         
         dirty_first/1,
         dirty_next/2,
         
         dirty_all_keys/1,
         table_info/2,
         dump_log/0,
         backup/1,
         
         transform_table/4,
         transform_table/3
        ]).


%% Mnesia事务执行数据库操作
%% 内部调用mnesia:transaction/1
-spec 
transaction(Fun) -> {atomic,Result} | {aborted,Reason} when
    Fun :: fun(),
    Result :: any(),
    Reason :: any().
transaction(Fun) ->
    common_transaction:on_transaction_begin(),
    common_role:on_transaction_begin(),
    case mnesia:transaction(Fun) of
        {atomic, Result} ->
            common_transaction:on_transaction_commit(),
            common_role:on_transaction_commit(),
            {atomic, Result};
        {aborted, Error} ->
            common_transaction:on_transaction_rollback(),
            common_role:on_transaction_rollback(),
            {aborted, Error}
    end.

%% 事务中执行过程中，抛出异常方法
%% 实际调用mnesia:abort/1函数处理
-spec abort(Reason) -> no_return() when Reason :: any().
abort(Reason) ->
    mnesia:abort(Reason).

%% 事务中读取记录信息，内部调用mnesia:read/3函数
%% mnesia:read(Tab,Key,read).
-spec 
read(Tab,Key) -> abort | [] | RecordList when 
   Tab :: atom(), 
   Key :: term(), 
   RecordList :: [term()].
read(Tab, Key) ->
    NewTab = db_misc:gen_active_tab_name(Tab,Key),
    mnesia:read(NewTab, Key, read).
%% 事务中读取记录信息，内部调用mnesia:read/3函数
-spec
read(Tab, Key, LockKind) -> abort | [] | RecordList when
    Tab :: atom(),
    Key :: term(),
    LockKind :: read | write | sticky_write,
    RecordList :: [term()].
read(Tab, Key, LockKind) ->
    NewTab = db_misc:gen_active_tab_name(Tab,Key),
    mnesia:read(NewTab, Key, LockKind).

%% 事务写入记录数据
-spec
write(Tab, Record, LockKind) -> abort | ok when
    Tab :: atom(),
    Record :: term(),
    LockKind :: write | sticky_write.
write(Tab, Record, LockKind) ->
    Key = erlang:element(2,Record),
    NewTab = db_misc:gen_active_tab_name(Tab,Key),
    mnesia:write(NewTab, Record, LockKind).

%% 事务删除记录
-spec 
delete(Tab, Key, LockKind) -> abort | ok when
    Tab :: atom(),
    Key :: term(),
    LockKind ::  write | sticky_write.
delete(Tab, Key, LockKind) ->
    NewTab = db_misc:gen_active_tab_name(Tab,Key),
    mnesia:delete(NewTab, Key, LockKind).

%% 事件删除记录
-spec 
delete_object(Tab, Record, LockKind) -> abort | ok when
    Tab :: atom(),
    Record :: term(),
    LockKind ::  write | sticky_write.
delete_object(Tab, Record, LockKind) ->
    Key = erlang:element(2,Record),
    NewTab = db_misc:gen_active_tab_name(Tab,Key),
    mnesia:delete_object(NewTab, Record, LockKind).

%% mnesia:dirty_read/2
-spec
dirty_read(Tab, Key) -> ValueList | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    ValueList :: [] | [term()],
    Reason :: term().
dirty_read(Tab, Key) ->
    NewTab = db_misc:gen_active_tab_name(Tab,Key),
    mnesia:dirty_read(NewTab, Key).

%% 脏读数据，自动区分活跃表和不活跃表
-spec
dirty_all_read(Tab, Key) -> ValueList | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    ValueList :: [] | [term()],
    Reason :: term().
dirty_all_read(Tab, Key) ->
    case cfg_mnesia:is_inactive_storage() == true andalso cfg_mnesia:is_tab_inactive(Tab) == true of
        true ->
            case dirty_read(Tab, Key) of
                [Value] ->
                    [Value];
                _ ->
                    db_inactive_api:dirty_read(Tab, Key)
            end;
        _ ->
            dirty_read(Tab, Key)
    end.

%% mnesia:dirty_write/2
-spec
dirty_write(Tab, Record) -> ok | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Record :: term(),
    Reason :: term().
dirty_write(Tab, Record) ->
    Key = erlang:element(2,Record),
    NewTab = db_misc:gen_active_tab_name(Tab,Key),
    mnesia:dirty_write(NewTab, Record).

%% 脏写数据，自动区分活跃表和不活跃表
-spec
dirty_all_write(Tab, Record) -> ok | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Record :: term(),
    Reason :: term().
dirty_all_write(Tab, Record) ->
    case cfg_mnesia:is_inactive_storage() == true andalso cfg_mnesia:is_tab_inactive(Tab) == true of
        true ->
            Key = erlang:element(2,Record),
            NewTab = db_misc:gen_active_tab_name(Tab,Key),
            case mnesia:dirty_read(NewTab, Key) of
                [_Value] ->
                    mnesia:dirty_write(NewTab, Record);
                _ ->
                    db_inactive_api:dirty_write(Tab, Record)
            end;
        _ ->
            dirty_write(Tab, Record)
    end.

%% mnesia:dirty_delete/2
-spec 
dirty_delete(Tab, Key) -> ok | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    Reason :: term().
dirty_delete(Tab, Key) ->
    NewTab = db_misc:gen_active_tab_name(Tab,Key),
    mnesia:dirty_delete(NewTab, Key).

%% 脏删除记录，自动区分活跃表和不活跃表
-spec 
dirty_all_delete(Tab, Key) -> ok | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    Reason :: term().
dirty_all_delete(Tab, Key) ->
    case cfg_mnesia:is_inactive_storage() == true andalso cfg_mnesia:is_tab_inactive(Tab) == true of
        true ->
            dirty_delete(Tab, Key),
            db_inactive_api:dirty_delete(Tab, Key);
        _ ->
            dirty_delete(Tab, Key)
    end.

%% mnesia:dirty_select/2
-spec
dirty_select(Tab, MatchSpec) -> ValueList | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    MatchSpec :: [MatchFunction],
    MatchFunction :: {MatchHead, [Guard], [Result]},
    MatchHead :: tuple() | term(),
    Guard :: term(),
    Result :: term(),
    ValueList :: [term(),...],
    Reason :: term().
dirty_select(Tab, MatchSpec) ->
    case db_misc:is_tab_inactive(Tab) of
        true ->
            db_active_api:dirty_select(Tab, MatchSpec) ++ db_inactive_api:dirty_select(Tab, MatchSpec);
        _ ->
            db_active_api:dirty_select(Tab, MatchSpec)
    end.

%% mnesia:dirty_match_object/2
-spec
dirty_match_object(Tab, Pattern) -> RecordList | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Pattern :: term(),
    RecordList :: [] | [term()],
    Reason :: term().
dirty_match_object(Tab, Pattern) ->
    case db_misc:is_tab_inactive(Tab) of
        true ->
            db_active_api:dirty_match_object(Tab, Pattern) ++ db_inactive_api:dirty_match_object(Tab, Pattern);
        _ ->
            db_active_api:dirty_match_object(Tab, Pattern)
    end.

%% mnesia:dirty_first/1
-spec 
dirty_first(Tab) -> Key | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    Reason :: term().
dirty_first(Tab) ->
    mnesia:dirty_first(Tab).

%% mnesia:dirty_next/2
-spec 
dirty_next(Tab, Key) -> Key | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    Reason :: term().
dirty_next(Tab, Key) ->
    TabList = db_misc:get_all_tab(Tab),
    case TabList of
        [Tab] ->
            mnesia:dirty_next(Tab, Key);
        _ ->
            NewTab = db_misc:gen_active_tab_name(Tab,Key),
            Len = erlang:length(TabList),
            Index = common_tool:index_of(NewTab, TabList),
            dirty_next(Index, NewTab, Key, Len, TabList)
    end.
dirty_next(Index, Tab, Key, Len, _TabList) when Index == Len ->
    mnesia:dirty_next(Tab, Key);
dirty_next(Index, Tab, Key, Len, TabList) ->
    case mnesia:dirty_next(Tab, Key) of
        '$end_of_table' -> %% 此分区表已经没有数据，在下一个分区分查找
            NewTab = lists:nth(Index + 1,TabList),
            dirty_next(Index + 1, NewTab, Len, TabList);
        NewKey ->
            NewKey
    end.
dirty_next(Index, Tab, Len, _TabList) when Index == Len ->
    mnesia:dirty_first(Tab);
dirty_next(Index, Tab, Len, TabList) ->
    case mnesia:dirty_first(Tab) of
        '$end_of_table' ->
            NewTab = lists:nth(Index + 1,TabList),
            dirty_next(Index + 1, NewTab, Len, TabList);
        NewKey ->
            NewKey
    end.

%% mnesia:dirty_all_keys/1
-spec 
dirty_all_keys(Tab) -> KeyList | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    KeyList :: [term(),...],
    Reason :: term().
dirty_all_keys(Tab) ->
    case db_misc:is_tab_inactive(Tab) of
        true ->
            db_active_api:dirty_all_keys(Tab) ++ db_inactive_api:dirty_all_keys(Tab);
        _ ->
            db_active_api:dirty_all_keys(Tab)
    end.

%% mnesia:table_info/2
-spec
table_info(Tab, InfoKey) -> Info | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    InfoKey :: atom(),
    Info :: term(),
    Reason :: term().
table_info(Tab, InfoKey) ->
    TabList = db_misc:get_all_tab(Tab),
    case TabList of
        [Tab] ->
            mnesia:table_info(Tab, InfoKey);
        _ ->
            lists:foldl(
              fun(NewTab,AccInfoList) -> 
                      Info = mnesia:table_info(NewTab, InfoKey),
                      [Info | AccInfoList]
              end,[],lists:reverse(TabList))
    end.

%% mnesia dump log 
-spec dump_log() -> dumped.
dump_log() ->
    mnesia:dump_log().

%% mnesia:backup/1
-spec 
backup(Opaque) -> ok | {error,Reason} when
    Opaque :: string(),
    Reason :: term().
backup(Opaque) ->
    mnesia:backup(Opaque).

%% Mnesia数据库结构更新操作
-spec 
transform_table(Tab, Fun, NewAttributeList, NewRecordName) -> {aborted, R} | {atomic, ok} when
    Tab :: atom(),
    Fun :: fun(),
    NewAttributeList :: [atom(),...],
    NewRecordName :: atom(),
    R :: term().
transform_table(Tab, Fun, NewAttributeList, NewRecordName) ->
    TabList = db_misc:get_all_tab(Tab),
    do_transform_table(TabList, {atomic,ok}, Fun, NewAttributeList, NewRecordName).
do_transform_table([], {atomic,ok}, _Fun, _NewAttributeList, _NewRecordName) ->
    {atomic,ok};
do_transform_table([Tab | TabList], {atomic,ok}, Fun, NewAttributeList, NewRecordName) ->
    Result = mnesia:transform_table(Tab, Fun, NewAttributeList, NewRecordName),
    do_transform_table(TabList, Result, Fun, NewAttributeList, NewRecordName);
do_transform_table(_TabList, Result, _Fun, _NewAttributeList, _NewRecordName) ->
    Result.

%% Mnesia数据库结构更新操作
-spec
transform_table(Tab, Fun, NewAttributeList) -> {aborted, R} | {atomic, ok} when
    Tab :: atom(),
    Fun :: fun(),
    NewAttributeList :: [atom(),...],
    R :: term().
transform_table(Tab, Fun, NewAttributeList) ->
    TabList = db_misc:get_all_tab(Tab),
    do_transform_table(TabList, {atomic,ok}, Fun, NewAttributeList).
do_transform_table([], {atomic,ok}, _Fun, _NewAttributeList) ->
    {atomic,ok};
do_transform_table([Tab | TabList], {atomic,ok}, Fun, NewAttributeList) ->
    Result = mnesia:transform_table(Tab, Fun, NewAttributeList),
    do_transform_table(TabList, Result, Fun, NewAttributeList);
do_transform_table(_TabList, Result, _Fun, _NewAttributeList) ->
    Result.
