%% @filename db_inactive_api.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-01-15 
%% @doc 
%% 不活跃数据库操作接口模块.

-module(db_inactive_api).

-include("db.hrl").


-export([
         dirty_read/2,
         dirty_write/2,
         dirty_delete/2,
         dirty_select/2,
         dirty_match_object/2,
         
         dirty_first/1,
         dirty_next/2,
         
         dirty_all_keys/1,
         table_info/2,
         
         transform_table/4,
         transform_table/3
        ]).

%% mnesia:dirty_read/2
-spec
dirty_read(Tab, Key) -> ValueList | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    ValueList :: [] | [term()],
    Reason :: term().
dirty_read(Tab, Key) ->
    NewTab = db_misc:gen_inactive_tab_name(Tab,Key),
    mnesia:dirty_read(NewTab, Key).

%% mnesia:dirty_write/2
-spec
dirty_write(Tab, Record) -> ok | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Record :: term(),
    Reason :: term().
dirty_write(Tab, Record) ->
    Key = erlang:element(2,Record),
    NewTab = db_misc:gen_inactive_tab_name(Tab,Key),
    mnesia:dirty_write(NewTab, Record).

%% mnesia:dirty_delete/2
-spec 
dirty_delete(Tab, Key) -> ok | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    Reason :: term().
dirty_delete(Tab, Key) ->
    NewTab = db_misc:gen_inactive_tab_name(Tab,Key),
    mnesia:dirty_delete(NewTab, Key).

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
    case db_misc:get_inactive_tab(Tab) of
        [InactiveTab] ->
            mnesia:dirty_select(InactiveTab, MatchSpec);
        TabList ->
            lists:foldl(
              fun(NewTab,AccValueList) -> 
                      ValueList = mnesia:dirty_select(NewTab, MatchSpec),
                      ValueList ++ AccValueList
              end,[],TabList)
    end.

%% mnesia:dirty_match_object/2
-spec
dirty_match_object(Tab, Pattern) -> RecordList | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Pattern :: term(),
    RecordList :: [] | [term()],
    Reason :: term().
dirty_match_object(Tab, Pattern) ->
    case db_misc:get_inactive_tab(Tab) of
        [InactiveTab] ->
            mnesia:dirty_match_object(InactiveTab, Pattern);
        TabList ->
            lists:foldl(
              fun(NewTab,AccRecordList) -> 
                      RecordList = mnesia:dirty_match_object(NewTab, Pattern),
                      RecordList ++ AccRecordList
              end,[],TabList)
    end.

%% mnesia:dirty_first/1
-spec 
dirty_first(Tab) -> Key | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    Reason :: term().
dirty_first(Tab) ->
    InactiveTab = db_misc:gen_tab_inactive_name(Tab),
    mnesia:dirty_first(InactiveTab).

%% mnesia:dirty_next/2
-spec 
dirty_next(Tab, Key) -> Key | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    Key :: term(),
    Reason :: term().
dirty_next(Tab, Key) ->
    case db_misc:get_inactive_tab(Tab) of
        [InactiveTab] ->
            mnesia:dirty_next(InactiveTab, Key);
        TabList ->
            NewTab = db_misc:gen_inactive_tab_name(Tab,Key),
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
    case db_misc:get_inactive_tab(Tab) of
        [InactiveTab] ->
            mnesia:dirty_all_keys(InactiveTab);
        TabList ->
            lists:foldl(
              fun(NewTab,AccKeyList) -> 
                      KeyList = mnesia:dirty_all_keys(NewTab),
                      KeyList ++ AccKeyList
              end,[],TabList)
    end.

%% mnesia:table_info/2
-spec
table_info(Tab, InfoKey) -> Info | erlang:exit({aborted, Reason}) when
    Tab :: atom(),
    InfoKey :: atom(),
    Info :: term(),
    Reason :: term().
table_info(Tab, InfoKey) ->
    case db_misc:get_inactive_tab(Tab) of
        [InactiveTab] ->
            mnesia:table_info(InactiveTab, InfoKey);
        TabList ->
            lists:foldl(
              fun(NewTab,AccInfoList) -> 
                      Info = mnesia:table_info(NewTab, InfoKey),
                      [Info | AccInfoList]
              end,[],TabList)
    end.


%% Mnesia数据库结构更新操作
-spec 
transform_table(Tab, Fun, NewAttributeList, NewRecordName) -> {aborted, R} | {atomic, ok} when
    Tab :: atom(),
    Fun :: fun(),
    NewAttributeList :: [atom(),...],
    NewRecordName :: atom(),
    R :: term().
transform_table(Tab, Fun, NewAttributeList, NewRecordName) ->
    TabList = db_misc:get_inactive_tab(Tab),
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
    TabList = db_misc:get_inactive_tab(Tab),
    do_transform_table(TabList, {atomic,ok}, Fun, NewAttributeList).
do_transform_table([], {atomic,ok}, _Fun, _NewAttributeList) ->
    {atomic,ok};
do_transform_table([Tab | TabList], {atomic,ok}, Fun, NewAttributeList) ->
    Result = mnesia:transform_table(Tab, Fun, NewAttributeList),
    do_transform_table(TabList, Result, Fun, NewAttributeList);
do_transform_table(_TabList, Result, _Fun, _NewAttributeList) ->
    Result.

