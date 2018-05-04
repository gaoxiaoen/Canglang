%% @filename db_misc.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-01-14 
%% @doc 
%% 数据库公共模块.

-module(db_misc).

-include("db.hrl").

-export([
         do_each_dirty_read/3,
         
         gen_active_tab_name/2,
         get_active_tab/1,
         
         gen_inactive_tab_name/2,
         get_inactive_tab/1,
         
         get_all_tab/1,
         is_tab_inactive/1
        ]).

-export([
         gen_tab_inactive_name/1,
         gen_tab_inactive_frag_name/2
        ]).


%% 通过key方式，读取遍历数据库记录
%% SrcTabName 数据表
%% Func 记录操作函数 Func(Record),Record 数据库记录
%% ResultFlag 是否返回操作结果 true 返回 ,false不返回 
%% 注：Func返回值为undefined不加入到返回结果列表中
-spec 
do_each_dirty_read(SrcTabName,Func,ResultFlag) -> ok | ResultList when
    SrcTabName :: atom(),
    Func :: fun(),
    ResultFlag :: true | false,
    ResultList :: ok | [atom()].
do_each_dirty_read(SrcTabName,Func,ResultFlag) ->
    FirstKey = db_api:dirty_first(SrcTabName),
    do_each_dirty_read2(FirstKey,SrcTabName,Func,ResultFlag,[]).

do_each_dirty_read2('$end_of_table',_SrcTabName,_Func,ResultFlag,ResultList) ->
    case ResultFlag of
        true ->
            ResultList;
        _ ->
            ok
    end;
do_each_dirty_read2(Key,SrcTabName,Func,ResultFlag,ResultList) ->
    [KeyRecord] = db_api:dirty_read(SrcTabName,Key),
    Result = Func(KeyRecord),
    NextKey = db_api:dirty_next(SrcTabName,Key),
    case ResultFlag of
        true ->
            case Result of
                undefined ->
                    do_each_dirty_read2(NextKey,SrcTabName,Func,ResultFlag,ResultList);
                _ ->
                    do_each_dirty_read2(NextKey,SrcTabName,Func,ResultFlag,[Result|ResultList])
            end;
        _ ->
            do_each_dirty_read2(NextKey,SrcTabName,Func,ResultFlag,ResultList)
    end.

%% 获取分区表表名
-spec 
gen_tab_frag_name(Tab,Frag) -> TabFragName when
    Tab :: atom(),
    Frag :: integer(),
    TabFragName :: atom().
gen_tab_frag_name(Tab,Frag) ->
    erlang:list_to_atom(lists:concat([erlang:atom_to_list(Tab),"_frag",Frag])).

%% 获取不活跃表名
-spec 
gen_tab_inactive_name(Tab) -> InactiveTab when 
    Tab :: atom(), 
    InactiveTab :: atom().
gen_tab_inactive_name(Tab) ->
    erlang:list_to_atom(lists:concat([erlang:atom_to_list(Tab),"_p"])).
%% 获取不活跃分区表表名
-spec 
gen_tab_inactive_frag_name(Tab,Frag) -> TabFragName when
    Tab :: atom(),
    Frag :: integer(),
    TabFragName :: atom().
gen_tab_inactive_frag_name(Tab,Frag) ->
    erlang:list_to_atom(lists:concat([erlang:atom_to_list(Tab),"_frag",Frag,"_p"])).


%% 根据Key Hash获取真实的活跃的分区表名
-spec
gen_active_tab_name(Tab,Key) -> NewTab when
    Tab :: atom(),
    Key :: term(),
    NewTab :: atom().
gen_active_tab_name(Tab,Key) ->
    Frag = cfg_mnesia:tab_frag(Tab),
    case Frag > 1 of
        true -> %% 存在分区表
            KeyIndex = cfg_mnesia:key_hash(Tab, Key, Frag),
            case KeyIndex == 1 of
                true ->
                    Tab;
                _ ->
                    gen_tab_frag_name(Tab,KeyIndex)
            end;
        _ ->
            Tab
    end.

%% 获取所有活跃分区表
-spec 
get_active_tab(Tab) -> TabList when 
    Tab :: atom(),
    TabList :: [atom(),...].
get_active_tab(Tab) ->
    FragNumber = cfg_mnesia:tab_frag(Tab),
    case FragNumber > 1 of
        true ->
            FragNameList = [gen_tab_frag_name(Tab,FragIndex + 1)  || FragIndex <- lists:seq(1, FragNumber - 1)];
        _ ->
            FragNameList = []
    end,
    [Tab | FragNameList].


%% 判断数据库是否区分不活跃表存储
-spec is_tab_inactive(Tab) -> boolean() when Tab :: atom().
is_tab_inactive(Tab) ->
    case cfg_mnesia:is_inactive_storage() of
        true ->
                cfg_mnesia:is_tab_inactive(Tab);
        _ ->
            false
    end.


%% 根据Key Hash获取真实的不活跃的分区表名
-spec
gen_inactive_tab_name(Tab,Key) -> NewTab when
    Tab :: atom(),
    Key :: term(),
    NewTab :: atom().
gen_inactive_tab_name(Tab,Key) ->
    InactiveTab = gen_tab_inactive_name(Tab),
    Frag = cfg_mnesia:tab_inactive_frag(Tab),
    case Frag > 1 of
        true -> %% 存在分区表
            KeyIndex = cfg_mnesia:key_hash(Tab, Key, Frag),
            case KeyIndex == 1 of
                true ->
                    InactiveTab;
                _ ->
                    gen_tab_inactive_frag_name(Tab,KeyIndex)
            end;
        _ ->
            InactiveTab
    end.

%% 获取所有不活跃分区表
%% []：表示没有不活跃分区表
-spec 
get_inactive_tab(Tab) -> [] | TabList when
    Tab :: atom(),
    TabList :: [atom(),...].
get_inactive_tab(Tab) ->
    InactiveTab = gen_tab_inactive_name(Tab),
    case cfg_mnesia:is_tab_inactive(Tab) of
        true ->
            FragNumber = cfg_mnesia:tab_inactive_frag(Tab),
            case FragNumber > 1 of
                true ->
                    FragNameList = [gen_tab_inactive_frag_name(Tab,FragIndex + 1)  || FragIndex <- lists:seq(1, FragNumber - 1)],
                    [InactiveTab | FragNameList];
                _ ->
                    [InactiveTab]
            end;
        _ ->
            []
    end.

%% 获取所有分区表
-spec 
get_all_tab(Tab) -> TabList when
    Tab :: atom(),
    TabList :: [atom(),...].
get_all_tab(Tab) ->
    case cfg_mnesia:is_inactive_storage() of
        true ->
            get_active_tab(Tab) ++ get_inactive_tab(Tab);
        _ ->
            get_active_tab(Tab)
    end.
    
