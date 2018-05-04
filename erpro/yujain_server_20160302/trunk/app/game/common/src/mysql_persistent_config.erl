%%%-------------------------------------------------------------------
%%%
%%%
%%% @doc
%%%     Mysql持久化表的配置
%%% @end
%%% Created : 2010-10-25
%%%-------------------------------------------------------------------

-module(mysql_persistent_config).


%%
%% Include files
%%
-include("common.hrl").
-include("common_server.hrl").

%%
%% Exported Functions
%%
-export([table_define/1,tables/0]).
-export([is_mysql_table/1]).

%%
%% API Functions
%%

%% @spec is_mysql_table(DbTable::atom())-> boolean()
%% @doc 判断该表是否作为Mysql的持久化
is_mysql_table(DbTab) when is_atom(DbTab)->
    table_define(DbTab) =/= false.


%%@doc 所有的mysql持久化表列表
tables()->
    [].


%% mnesia和mysql数据库表的映射定义
    %% 注意——
    %% 1)对字段的顺序不能随便调整，因为erlang中，record只是一个带tag的tuple
    %% 2)支持的字段类型如下：
    %%      int :: integer()
    %%      bigint :: integer()
    %%      tinyint :: boolean()
    %%      varchar :: string()
    %%      binchar :: binary字段作为varchar类型来存储，例如role_name
    %%      tuplechar :: tuple字段作为varchar类型来存储，例如role_bag_key
    %%              tuple的每个元素必须是integer()或atom()
    %%      blob :: 该字段不写入mysql
    %%      tinyblob :: 该字段不写入mysql
    %%  目前一共65个表
    %%  [ ].

%% 定义表结构
table_define(_)->
    false.


