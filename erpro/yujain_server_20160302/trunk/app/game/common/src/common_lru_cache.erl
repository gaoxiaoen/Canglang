%% Author: markycai<tomarky.cai@gmail.com>
%% Created: 2013-9-30
%% Description: TODO: LRU缓存算法
%% 最近最少使用 如果宗族战是即时数据，是比较适合的 
%% 竞技场也可以使用，因为同一个数据频繁挑战的可能性比较大
%% 双向链表
%% head_index =>N
%% tail_index =>N
%% key=>{index,value}
%% index=>{pre_index,next_index,key}

-module(common_lru_cache).

-record(r_lru_index,{prev_id=0,next_id=0,key=0}).
-record(r_lru_key_val,{id=0,value}).

-define(DEFAULT_CACHE_SIZE,5).
-define(DEFAULT_GC_SIZE,3).
-define(START_INDEX,0).
%%
%% Include files
%%
-include("common.hrl").
-include("common_server.hrl").
%%
%% Exported Functions
%%
-export([init/1,
         init/3,
         get_cache/2,
         set_cache/3,
         del_cache/2]).

%%
%% API Functions
%%

%% 初始化缓存
init(CacheId)->
    %% 默认值
    init(CacheId,?DEFAULT_CACHE_SIZE,?DEFAULT_GC_SIZE).

%% 初始化缓存
%% CacheId:缓存id
%% CacheSize:缓存大小
%% GCSize:回收大小
init(CacheId,CacheSize,GCSize)->
    %% 设置当前缓存大小
    set_cache_size(CacheId,0),
    %% 设置最大缓存大小
    set_max_cache_size(CacheId,CacheSize),
    %% 设置一次回收大小
    set_gc_size(CacheId,GCSize),
    %% 设置头指针
    set_head_index(CacheId,?START_INDEX),
    %% 设置尾指针
    set_tail_index(CacheId,?START_INDEX),
    %% 设置尾指针指向的节点的值
    set_index_info(CacheId,?START_INDEX,#r_lru_index{prev_id=?START_INDEX,next_id=?START_INDEX,key=0}).
    
%% 获取缓存
get_cache(CacheId,Key)->
    case get_key_info(CacheId,Key) of
        undefined->
            {error,not_found};
        #r_lru_key_val{value=Value}->
            {ok,Value}
    end.


%% 添加缓存数据
%% CacheId: 缓存id
%% Key: 缓存的数据 
set_cache(CacheId,Key,Value)->
    %% 获得尾指针
    TailIndex = get_tail_index(CacheId),
    %% 获得尾指针信息
    TailIndexInfo = get_index_info(CacheId,TailIndex),
    %% 新的尾指针
    NewTailIndex = TailIndex+1,
    %% 设置旧的尾指针信息
    set_index_info(CacheId,TailIndex,TailIndexInfo#r_lru_index{next_id=NewTailIndex}),
    %% 设置新的尾指针信息
    set_index_info(CacheId,NewTailIndex,#r_lru_index{prev_id=TailIndex,key=Key}),
    %% 设置新的尾指针
    set_tail_index(CacheId,NewTailIndex),
    %% 增加缓存大小
    add_cache_size(CacheId),
    %% 设置根据Key找到对应节点
    set_key_info(CacheId,Key,NewTailIndex,Value),
    %% GC
    gc_cache(CacheId).

del_cache(CacheId,Key)->
    case get_key_info(CacheId,Key) of
        undefined->
            ok;
        #r_lru_key_val{id=Id}->
            case get_index_info(CacheId,Id) of
                #r_lru_index{prev_id=PrevId,next_id=NextId} ->
                    PrevIndexInfo=get_index_info(CacheId,PrevId),
                    NextIndexInfo=get_index_info(CacheId,NextId),
                    set_index_info(CacheId,PrevId,PrevIndexInfo#r_lru_index{next_id=NextId}),
                    set_index_info(CacheId,NextId,NextIndexInfo#r_lru_index{prev_id=PrevId}),
                    erase_index_info(CacheId,Id),
                    erase_key_info(CacheId,Key),
                    del_cache_size(CacheId),
                    ok;
                _->
                    ok
            end
    end.

%% 缓存回收
gc_cache(CacheId)->
    CacheSize = get_cache_size(CacheId),
    MaxCacheSize = get_max_cache_size(CacheId),
    case MaxCacheSize < CacheSize of
        true->
            HeadIndex=get_head_index(CacheId),
            GCSize = get_gc_size(CacheId),
            HeadIndex2 =gc_cache2(CacheId,HeadIndex,GCSize),
            set_head_index(CacheId,HeadIndex2);
        false->
            next
    end.

gc_cache2(_CacheId,HeadIndex,0)->HeadIndex;
gc_cache2(CacheId,HeadIndex,GCSize)->
    case get_index_info(CacheId,HeadIndex) of
        #r_lru_index{next_id=NextId,key=Key}->
            erase_index_info(CacheId,HeadIndex),
            erase_key_info(CacheId,Key),
            del_cache_size(CacheId),
            gc_cache2(CacheId,NextId,GCSize-1);
        _->
            HeadIndex
    end.
    
%%
%% Local Functions
%%
%% 根据缓存的数据找到缓存节点
get_key_info(CacheId,Key)->
    erlang:get({lru_key_info,CacheId,Key}).

set_key_info(CacheId,Key,Index,Value)->
    erlang:put({lru_key_info,CacheId,Key},#r_lru_key_val{id=Index,value = Value}).

erase_key_info(CacheId,Key)->
    erlang:erase({lru_key_info,CacheId,Key}).

%% 缓存节点
%% 可以找到上一个和下一个
get_index_info(CacheId,Index)->
    erlang:get({lru_index_info,CacheId,Index}).

set_index_info(CacheId,Index,IndexInfo)->
    erlang:put({lru_index_info,CacheId,Index}, IndexInfo).

erase_index_info(CacheId,Index)->
    erlang:erase({lru_index_info,CacheId,Index}).

%% 缓存列表头部
get_head_index(CacheId)->
    erlang:get({lru_head_index,CacheId}).

set_head_index(CacheId,Index)->
    erlang:put({lru_head_index,CacheId}, Index).

%% 缓存列表尾部
get_tail_index(CacheId)->
    erlang:get({lru_tail_index,CacheId}).

set_tail_index(CacheId,Index)->
    erlang:put({lru_tail_index,CacheId},Index).

get_max_cache_size(CacheId)->
    erlang:get({lru_max_cache_size,CacheId}).

set_max_cache_size(CacheId,MaxSize)->
    erlang:set({lru_max_cache_size,CacheId},MaxSize).

%% 当前缓存列表长度
get_cache_size(CacheId)->
    erlang:get({lru_cache_size,CacheId}).

set_cache_size(CacheId,Size)->
    erlang:put({lru_cache_size,CacheId},Size).

add_cache_size(CacheId)->
    set_cache_size(CacheId,get_cache_size(CacheId)+1).

del_cache_size(CacheId)->
    set_cache_size(CacheId,get_cache_size(CacheId)-1).

%% 每次回收数据量
get_gc_size(CacheId)->
    erlang:get({lru_gc_size,CacheId}).
    
set_gc_size(CacheId,Size)->
    erlang:put({lru_gc_size,CacheId},Size).
    