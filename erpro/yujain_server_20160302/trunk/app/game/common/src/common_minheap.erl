%%%-------------------------------------------------------------------
%%% @author  <>
%%% @copyright (C) 2011, 
%%% @doc
%%%       0
%%%    1     2
%%%   3 4   5 6
%%%   ...
%%%  节点:Index  父节点:trunc((Index - 1) / 2)
%%%  大顶堆和小顶堆取决于cmp_func
%%% @end
%%% Created : 15 Jul 2011 by  <>
%%%-------------------------------------------------------------------
-module(common_minheap).

-export([
         new_heap/3,
         new_heap/4,
         delete_heap/1,
         is_full/1,
         is_empty/1,
         get_heap_size/1,
         get_element_by_key/2
        ]).

-export([
         key_find/2,
         insert/3,
         update/3,
         update_db/5,
         delete_db/3,
         pop/1,
         copy_heap/2,
         update_or_insert/3
        ]).

-define(HEAP_CMP_FUNC, heap_cmp_func).
-define(HEAP_INDEX2ELEMENT, heap_index2element).
-define(HEAP_KEY2INDEX, heap_key2index).
-define(HEAP_MAX_SIZE, heap_max_size).
-define(HEAP_SIZE, heap_size).



%% 拷贝堆数据
copy_heap(HeapName,CopyHeapName)->
    set_max_heap_size(CopyHeapName,get_max_heap_size(HeapName)),
    HeapSize = get_heap_size(HeapName),
    set_heap_size(CopyHeapName,HeapSize),
    set_cmp_func(CopyHeapName,get_cmp_func(HeapName)),
    copy_heap2(HeapName,CopyHeapName,HeapSize-1).

copy_heap2(_HeapName,_CopyHeapName,Index) when Index < 0 ->
    ignore;
copy_heap2(HeapName,CopyHeapName,Index)->
    {Element, Key} = get_element_key_by_index(HeapName, Index),
    set_new_element(CopyHeapName, Index, Element, Key),
    copy_heap2(HeapName,CopyHeapName,Index-1).    

    
%% @doc 创建最小堆
new_heap(HeapName, HeapSize, CmpFunc) ->
    set_max_heap_size(HeapName, HeapSize),
    set_heap_size(HeapName, 0),
    set_cmp_func(HeapName, CmpFunc).

%% @doc 创建最小堆新并初始化一些元素
%% ElementList:list({Element,Key}) 这里的list千万要注意结构啊擦
new_heap(HeapName, HeapSize, CmpFunc, ElementList) ->
    new_heap(HeapName, HeapSize, CmpFunc),
    lists:foreach(fun({Element,Key}) -> insert(HeapName,Element,Key) end,ElementList).

%% @doc 删除最小堆
%% return {error,undefined} | ok
delete_heap(HeapName) ->
    case get_heap_size(HeapName) of
        undefined ->
            {error, undefined};
        HeapSize ->
            delete_heap2(HeapName, HeapSize, 0)
    end.
%% 循环删除堆元素
%% return ok
delete_heap2(HeapName, HeapSize, HeapSize) ->
    delete_element_by_index(HeapName, HeapSize),
    delete_heap_size(HeapName),
    delete_max_heap_size(HeapName),
    delete_cmp_func(HeapName),
    ok;
delete_heap2(HeapName, HeapSize, Count) ->
    delete_element_by_index(HeapName, Count),
    delete_heap2(HeapName, HeapSize, Count+1).

%%获取堆顶元素
%% 堆顶元素 节点号为0
%% return undefined | #%^$%$%&
get_top_element(HeapName) ->
    get_element_key_by_index(HeapName, 0). 

%%插入新的元素
%% return {error,heap_full}|OldHeapSize 
%% OldHeapSize 此次插入堆的元素是堆的第几个元素 即 当前堆的大小
insert(HeapName, Element, Key) ->
    case is_full(HeapName) of
        true ->
            {error, heap_full};
        false ->
            %% 获取最大值作为插入的节点key
            HeapSize = get_heap_size(HeapName),
            %% 设置节点key对应的节点值
            set_new_element(HeapName, HeapSize, Element, Key),
            filter_up(HeapName, HeapSize),
            set_heap_size(HeapName, HeapSize+1)
    end.

%% 更新一个键值对的值
%% 如果key本身不存在  则不更新
%% return {error,not_found} | undefined| Index
update(HeapName, Element, Key) ->
    case get_index_by_key(HeapName, Key) of  %% 查找key 的节点
        undefined ->
            {error, not_found};
        Index ->
            update(HeapName, Element, Key, Index)
    end.

update_or_insert(HeapName,Element,Key)->
    %% 是否堆满  
    case is_full(HeapName) of
        true ->  
            %% 获取堆顶(最小)值
            case get_index_by_key(HeapName, Key) of
                undefined ->
                    %% 满堆更新   
                    {MinElement,_MinKey} = get_top_element(HeapName),
                    %% 如果堆里找不到要更新的值
                    CmpFunc = get_cmp_func(HeapName),
                    %% 连最小值都比不过  拉倒吧
                    case CmpFunc(Element,MinElement) of
                        true ->
                            {fail,out_of_rank};
                        false ->
                            delete_element_by_index(HeapName, 0),
                            %% 插入新值
                            update(HeapName,Element,Key,0)
                    end;
                Index ->
                    %% 如果找到要更新的值  则直接在堆中操作
                    update(HeapName,Element,Key,Index)
            end;
        false -> %% 不满插入
            case get_index_by_key(HeapName, Key) of
                undefined ->
                    insert(HeapName,Element,Key);
                Index->
                    update(HeapName,Element,Key,Index)
           end
    end.

%% 更新数据库的堆
update_db(HeapName, Element, Key, DBName,Value) ->  
    %% 是否堆满  
    case is_full(HeapName) of
        true ->  
            %% 获取堆顶(最小)值
            case get_index_by_key(HeapName, Key) of
                undefined ->
                    %% 满堆更新   
                    {MinElement,MinKey} = get_top_element(HeapName),
                    %% 如果堆里找不到要更新的值
                    CmpFunc = get_cmp_func(HeapName),
                    %% 连最小值都比不过  拉倒吧
                    case CmpFunc(Element,MinElement) of
                        true ->
                            {fail,out_of_rank};
                        false ->
                            db_api:dirty_delete(DBName,MinKey),
                            db_api:dirty_write(DBName,Value),
                            delete_element_by_index(HeapName, 0),
                            %% 插入新值
                            update(HeapName,Element,Key,0)
                    end;
                Index ->
                    %% 如果找到要更新的值  则直接在堆中操作
                    db_api:dirty_write(DBName,Value),
                    update(HeapName,Element,Key,Index)
            end;
        false->
            db_api:dirty_write(DBName,Value),
            case get_index_by_key(HeapName, Key) of
                undefined ->
                    insert(HeapName,Element,Key);
                Index->
                    update(HeapName,Element,Key,Index)
           end
    end.

%% %% 更新数据库的堆
%% update_db(HeapName, Element, Key, DBName,Value) ->  
%%     %% 是否堆满  
%%     case is_full(HeapName) of
%%         true ->  %% 满堆更新   
%%             {MinElement,MinKey} = get_top_element(HeapName),
%%             %% 获取堆顶(最小)值
%%             case get_index_by_key(HeapName, Key) of
%%                 undefined ->
%%                     %% 如果堆里找不到要更新的值
%%                  CmpFunc = get_cmp_func(HeapName),
%%                     %% 连最小值都比不过  拉倒吧
%%                     case CmpFunc(Element,MinElement) of
%%                         true ->
%%                             {fail,out_of_rank};
%%                         false ->
%%                             db_api:dirty_delete(DBName,MinKey),
%%                             db_api:dirty_write(DBName,Value),
%%                             delete_element_by_index(HeapName, 0),
%%                             %% 插入新值
%%                             update(HeapName,Element,Key,0)
%%                     end;
%%                 Index ->
%%                     %% 如果找到要更新的值  则直接在堆中操作
%%                     db_api:dirty_write(DBName,Value),
%%                     update(HeapName,Element,Key,Index)
%%             end;
%%         false -> %% 不满插入
%%             case get_index_by_key(HeapName,Key) of
%%                 undefined->
%%                     db_api:dirty_write(DBName,Value),
%%                     insert(HeapName,Element,Key);
%%                 Index ->
%%                     db_api:dirty_write(DBName,Value),
%%                     update(HeapName,Element,Key,Index)
%%             end
%%     end.

delete_db(HeapName,Key,DBName)->
    case is_empty(HeapName) of
        true ->
            {error, not_found};
        false->
            case get_index_by_key(HeapName,Key) of
                undefined->
                    {fail,out_of_rank};
                Index->
                    db_api:dirty_delete(DBName,Key),
                    LastIndex = get_heap_size(HeapName) - 1,
                    set_heap_size(HeapName, LastIndex),
                    case get_element_key_by_index(HeapName, LastIndex) of
                        {LastElement, LastKey}->
                            set_new_element(HeapName, Index, LastElement, LastKey),
                            filter(HeapName, Index, LastElement, LastKey);
                        _->
                            ignore
                    end
            end
    end.


%%删除堆顶的元素
%% return {error,not_found} | {堆顶值,对顶键}
%% 删除堆顶元素， 获取堆尾元素然后将其放在堆顶，然后向下更新
pop(HeapName) ->
    case is_empty(HeapName) of
        true ->
            {error, not_found};
        false ->
            {TopElement, TopKey} = get_element_key_by_index(HeapName, 0),
            delete_element(HeapName, 0, TopKey),
            LastIndex = get_heap_size(HeapName) - 1,
            set_heap_size(HeapName, LastIndex),
            case get_element_key_by_index(HeapName, LastIndex) of
                {LastElement, LastKey}->
                    set_new_element(HeapName, 0, LastElement, LastKey),
                    filter_down(HeapName, 0);
                _->
                    ignore
            end,
            {TopElement,TopKey}
    end.

%% %%删除堆中的某一元素然后维护堆
%% %% 将堆尾的元素放在删除的节点，然后更新
%% delete(HeapName, Key) ->
%%     case get_index_by_key(HeapName, Key) of
%%         undefined ->
%%             {error, undefined};
%%         Index ->
%%             delete_element(HeapName, Index, Key),
%%             LastIndex = get_heap_size(HeapName) - 1,
%%             {LastElement, LastKey} = get_element_key_by_index(HeapName, LastIndex),
%%             set_new_element(HeapName, Index, LastElement, LastKey),
%%             set_heap_size(HeapName, LastIndex),
%%             filter(HeapName, Index, LastElement, LastKey)
%%     end.

%%判断是否堆满      
is_full(HeapName) ->
    case get_max_heap_size(HeapName) of  %% 如果没有堆的最大值   堆满
        undefined ->
            true;
        MaxHeapSize ->                   %% 堆的节点数量大于等于最大值
            HeapSize = get_heap_size(HeapName),
            HeapSize >= MaxHeapSize
    end.

%%判断堆是否为空
is_empty(HeapName) ->       %% 堆是否空
    case get_heap_size(HeapName) of   %% 如果堆的节点数量为空 就返回空
        undefined ->
            true;
        HeapSize ->         %% 堆的节点数如果为零  就为空
            HeapSize =:= 0
    end.

%% 查找键对应的值
%% return undefined | 对应值
key_find(HeapName, Key) ->
    case get_index_by_key(HeapName, Key) of
        undefined ->
            undefined;
        Index ->
            case get_element_key_by_index(HeapName, Index) of
                undefined ->
                    undefined;
                {Element, _Key} ->
                    Element
            end
    end.

%%
%%================LOCAL FUCTION=======================
%%
%%更新堆中元素的值然后重新维护堆
update(HeapName, Element, Key, Index) ->
    set_new_element(HeapName, Index, Element, Key),
    filter(HeapName, Index, Element, Key).

filter(HeapName, Index, Element, _Key) ->
    ParentIndex = trunc((Index - 1) / 2),
    {ParentElement, _ParentKey} = get_element_key_by_index(HeapName, ParentIndex),
    CmpFunc = get_cmp_func(HeapName),
    case CmpFunc(ParentElement, Element) of
        false ->
            %%函数判断  父节点比现在的节点值更差 现在的节点就网上更新
            filter_up(HeapName, Index);
        true ->
            filter_down(HeapName, Index)
    end.

%% 元素往上更新 是否满足条件  满足条件就与父节点交换，交换后重复操作 
filter_up(HeapName, Index) ->
    CurrentIndex = Index,
    ParentIndex = trunc((Index - 1) / 2),
    {TargetElement, TargetKey} = get_element_key_by_index(HeapName, CurrentIndex),
    NewCurrentIndex = filter_up2(CurrentIndex, ParentIndex, TargetElement, HeapName),
    set_new_element(HeapName, NewCurrentIndex, TargetElement, TargetKey).

filter_up2(0, _, _, _) ->
    0;
filter_up2(CurrentIndex, ParentIndex, TargetElement, HeapName) ->
    {ParentElement,ParentKey} = get_element_key_by_index(HeapName, ParentIndex),
    CmpFunc = get_cmp_func(HeapName),
    case CmpFunc(ParentElement, TargetElement) of
        true ->
            CurrentIndex;
        false ->
            set_new_element(HeapName, CurrentIndex, ParentElement, ParentKey),
            filter_up2(ParentIndex, trunc((ParentIndex-1)/2), TargetElement, HeapName)
    end.

filter_down(HeapName, Index) ->
    CurrentIndex = Index,
    ChildIndex = 2 * Index + 1,
    {TargetElement, TargetKey} = get_element_key_by_index(HeapName, CurrentIndex),
    HeapSize = get_heap_size(HeapName),
    NewCurrentIndex = filter_down2(CurrentIndex, ChildIndex, TargetElement, HeapSize, HeapName),
    set_new_element(HeapName, NewCurrentIndex, TargetElement, TargetKey).
    
%% CurrentIndex 当前节点
%% ChildIndex 子节点
%% TargetElement 当前节点的值
%% HeapSize 堆的大小
filter_down2(CurrentIndex, ChildIndex, TargetElement, HeapSize, HeapName) ->
    case ChildIndex < HeapSize of  %% 左子节点是否存在
        true ->
            CmpFunc = get_cmp_func(HeapName),
            case ChildIndex + 1 < HeapSize of  %% 右子节点是否存在
                true ->
                    {Element1, _Key1} = get_element_key_by_index(HeapName, ChildIndex+1),
                    {Element2, _Key2} = get_element_key_by_index(HeapName, ChildIndex),
                    case CmpFunc(Element1, Element2) of
                        true ->
                            NewChildIndex = ChildIndex + 1;
                        false ->
                            NewChildIndex = ChildIndex
                    end;
                false -> %% 右节点是堆尾
                    NewChildIndex = ChildIndex
            end,
            {ChildElement, ChildKey} = get_element_key_by_index(HeapName, NewChildIndex),
            case CmpFunc(TargetElement, ChildElement) of
                true ->
                    CurrentIndex;
                false ->
                    set_new_element(HeapName, CurrentIndex, ChildElement, ChildKey),
                    filter_down2(NewChildIndex, NewChildIndex*2+1, TargetElement, HeapSize, HeapName)
            end;
        false -> 
            CurrentIndex
    end.
        
set_cmp_func(HeapName, CmpFunc) ->
    erlang:put({?HEAP_CMP_FUNC, HeapName}, CmpFunc).

get_cmp_func(HeapName) ->
    erlang:get({?HEAP_CMP_FUNC, HeapName}).

delete_cmp_func(HeapName) ->
    erlang:erase({?HEAP_CMP_FUNC, HeapName}).


delete_element_by_index(HeapName, Index) ->
    case get_element_key_by_index(HeapName, Index) of
        undefined ->
            {error, undefined};
        {_Element, Key} ->
            delete_element(HeapName, Index, Key)
    end.

delete_element(HeapName, Index, Key) ->
    erlang:erase({?HEAP_INDEX2ELEMENT, HeapName, Index}),
    erlang:erase({?HEAP_KEY2INDEX, HeapName, Key}).

get_element_by_key(HeapName,Key)->
    case get_index_by_key(HeapName, Key) of
        undefined->
            {error,not_found};
        Index->
            case get_element_key_by_index(HeapName,Index) of
                {Element,_}->
                    {ok,Element};
                _->
                    {error,not_found}
            end
    end.

%% 设置新的元素 
%% HeapName 堆名
%% Index 第几个节点
set_new_element(HeapName, Index, Element, Key) ->
    %% 设置堆节点对应的键值对
    erlang:put({?HEAP_INDEX2ELEMENT, HeapName, Index}, {Element, Key}),
    %% 设置键值对应的节点
    erlang:put({?HEAP_KEY2INDEX, HeapName, Key}, Index).

%% 获取节点对应的键值对
get_element_key_by_index(HeapName, Index) ->
    erlang:get({?HEAP_INDEX2ELEMENT, HeapName, Index}).
%% 根据键值获取节点id
get_index_by_key(HeapName, Key) ->
    erlang:get({?HEAP_KEY2INDEX, HeapName, Key}).
%% 堆的大小
set_heap_size(HeapName, HeapSize) ->
    erlang:put({?HEAP_SIZE, HeapName}, HeapSize).

delete_heap_size(HeapName) ->
    erlang:erase({?HEAP_SIZE, HeapName}).

get_heap_size(HeapName) ->
    erlang:get({?HEAP_SIZE, HeapName}).
%% 堆的最大值
set_max_heap_size(HeapName, HeapSize) ->
    erlang:put({?HEAP_MAX_SIZE, HeapName}, HeapSize).

get_max_heap_size(HeapName) ->
    erlang:get({?HEAP_MAX_SIZE, HeapName}).

delete_max_heap_size(HeapName) ->
    erlang:erase({?HEAP_MAX_SIZE, HeapName}).
