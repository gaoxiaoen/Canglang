%%%-------------------------------------------------------------------
%%% File        :common_fifo_cache.erl
%%% Author      :markycai<tomarky.cai@gmail.com>
%%% Create Date :2013-9-4
%%% @doc
%%%     简单FIFO缓存
%%%     适合战报这种不重复的缓存
%%%     单向链表
%%% @end
%%%-------------------------------------------------------------------
-module(common_fifo_cache).

%%
%% Include files
%%
-include("common.hrl").
-include("common_server.hrl").

-define(DEFAULT_KEY_SIZE,50).
-define(DEFAULT_GC_SIZE,25).
%%
%% Exported Functions
%%
-export([init/1,
         init/3,
         add_cache/2,
         get_cache/2
         ]).

%%
%% API Functions
%%

%% CacheId 缓存唯一标识,可以是任意值

-spec init(CacheId :: any()) -> ok.

init(CacheId)->
    init(CacheId,?DEFAULT_KEY_SIZE,?DEFAULT_GC_SIZE).

init(CacheId,KeySize,GCSize)->
    set_min_index(CacheId,1),
    set_max_index(CacheId,1),
    set_key_size(CacheId,KeySize),
    set_gc_size(CacheId,GCSize),
    ok.
    
%% 向缓存写入数据

-spec add_cache(CacheId :: any(), CacheValue :: any()) -> CacheKey :: integer().

add_cache(CacheId,CacheValue)->
    MaxIndex = get_max_index(CacheId),
    set_value(CacheId,MaxIndex,CacheValue),
    set_max_index(CacheId,MaxIndex+1),
    ?TRY_CATCH(check_gc(CacheId),Err),
    MaxIndex.

-spec get_cache(CacheId :: any(), CacheKey :: integer())-> CacheValue :: any().
get_cache(CacheId,CacheKey)->
    case get_value(CacheId,CacheKey) of
        undefined->
            {error,not_found};
        CacheVal->
            {ok,CacheVal}
    end.

%%
%% Local Functions
%%

check_gc(CacheId)->
    MinIndex = get_min_index(CacheId),
    case get_max_index(CacheId) - MinIndex > get_key_size(CacheId) of
        true->
            ?ERROR_MSG("-------------------GC_from_index:~w",[MinIndex]),
            gc(CacheId,MinIndex);
        false->
            next
    end.

gc(CacheId,MinIndex)->
    gc2(CacheId,MinIndex,get_gc_size(CacheId)).

gc2(CacheId,CacheKey,Num) when Num > 0 ->
    erase_value(CacheId,CacheKey),
    gc2(CacheId,CacheKey+1,Num-1);
gc2(CacheId,CacheKey,_Num)->
    set_min_index(CacheId,CacheKey).

%% 缓存列表长度上限
-define(fifo_key_size,fifo_key_size).
get_key_size(CacheId)->
    erlang:get({?fifo_key_size,CacheId}).

set_key_size(CacheId,Size)->
    erlang:put({?fifo_key_size,CacheId},Size).

%% 每次回收数据常大虎
-define(fifo_gc_size,fifo_gc_size).
get_gc_size(CacheId)->
    erlang:get({?fifo_gc_size,CacheId}).
    
set_gc_size(CacheId,Size)->
    erlang:put({?fifo_gc_size,CacheId},Size).


%% 当前游标
-define(fifo_min_index,fifo_min_index).
get_min_index(CacheId)->
    erlang:get({?fifo_min_index,CacheId}).

set_min_index(CacheId,MinIndex)->
    erlang:put({?fifo_min_index,CacheId}, MinIndex).

%% 
-define(fifo_max_index,fifo_max_index).
get_max_index(CacheId)->
    erlang:get({?fifo_max_index,CacheId}).

set_max_index(CacheId,MaxIndex)->
    erlang:put({?fifo_max_index,CacheId}, MaxIndex).

-define(fifo_value,fifo_value).
set_value(CacheId,CacheKey,CacheValue)->
    erlang:put({?fifo_value,CacheId,CacheKey},CacheValue).

get_value(CacheId,CacheKey)->
    erlang:get({?fifo_value,CacheId,CacheKey}).

erase_value(CacheId,CacheKey)->
    erlang:erase({?fifo_value,CacheId,CacheKey}).