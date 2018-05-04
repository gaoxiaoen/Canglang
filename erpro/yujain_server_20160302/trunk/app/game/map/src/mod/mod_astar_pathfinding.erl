%%%-------------------------------------------------------------------
%%% @author  Administrator
%%% @doc
%%%	a 星寻路模块
%%% @end
%%%-------------------------------------------------------------------
-module(mod_astar_pathfinding).

-include("mgeem.hrl").

-export([
         find_path/2,
         find_path/3]).

-record(r_map_node, {key, tx, ty, dir, g, f, p_parent}).

%% 默认a星寻路堆长150
-define(DEFAULT_HEAP_SIZE, 150).
-define(ASTAR_OPEN_HEAP, astar_open_heap).
-define(ASTAR_CLOSE_LIST, astar_close_list).
-define(ASTAR_CLOSE_LIST_ELEMENT, astar_close_list_element).

find_path(StartPos, EndPos) ->
    if StartPos#p_map_pos.tx =:= EndPos#p_map_pos.tx andalso 
       StartPos#p_map_pos.ty =:= EndPos#p_map_pos.ty ->
            [{StartPos#p_map_tile.tx, StartPos#p_map_tile.ty, StartPos#p_map_tile.dir}];
       true ->
            find_path(StartPos, EndPos, ?DEFAULT_HEAP_SIZE)
    end.

find_path(StartPos, EndPos, HeapSize) ->
    common_minheap:new_heap(?ASTAR_OPEN_HEAP, HeapSize, fun cmp/2),
    %%设置关闭列表为空
    set_close_list([]),
    %% 初始化其实位置
    StartNode = #r_map_node{key={StartPos#p_map_tile.tx, StartPos#p_map_tile.ty}, 
                            tx=StartPos#p_map_tile.tx, ty=StartPos#p_map_tile.ty, dir=StartPos#p_map_tile.dir, g=0},
    %% 起始位置插入列表
    close_list_insert(StartNode),
    find_path2(StartNode, EndPos#p_map_tile.tx, EndPos#p_map_tile.ty).

find_path2(CurNode, EndTX, EndTY) ->
    %% 插入当前格子周围的格子
    case catch insert_aound_map_nodes(CurNode, EndTX, EndTY) of
        ok ->
            case common_minheap:pop(?ASTAR_OPEN_HEAP) of
                {error,_} ->
                    false;
                {MinNode,_} ->
                    close_list_insert(MinNode),
                    find_path2(MinNode, EndTX, EndTY)
            end;
        {ok, get_it} ->  %% 在周围的格子中找到目标点
            Path = [{EndTX, EndTY, get_dir(CurNode, EndTX, EndTY)}],
            common_minheap:delete_heap(?ASTAR_OPEN_HEAP),
            find_path3(CurNode, Path);
        {error, _} ->    %% 找不到路径
            close_list_delete(),
            common_minheap:delete_heap(?ASTAR_OPEN_HEAP),
            false;
        Error ->
            ?ERROR_MSG("find_path error: ~w", [{Error}]),
            close_list_delete(),
            common_minheap:delete_heap(?ASTAR_OPEN_HEAP),
            false
    end.

find_path3(#r_map_node{p_parent=undefined}=MapNode, Path) ->
    close_list_delete(),
    [{MapNode#r_map_node.tx, MapNode#r_map_node.ty, MapNode#r_map_node.dir}|Path];
find_path3(CurNode, Path) ->
    ParentNode = get_close_list(CurNode#r_map_node.p_parent),
    find_path3(ParentNode, [{CurNode#r_map_node.tx, CurNode#r_map_node.ty, CurNode#r_map_node.dir}|Path]).

%% return {ok,get_it}|ok|{error,Error}
insert_aound_map_nodes(CurNode, EndTX, EndTY) ->
    #r_map_node{tx=CTX, ty=CTY} = CurNode,
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    lists:foreach(
      fun(TX) ->
              lists:foreach(
                fun(TY) ->
                        WalkTable = is_tile_walkable(McmModule, TX, TY),
                        if TX =:= EndTX andalso TY =:= EndTY ->
                               erlang:throw({ok, get_it});
                           TX =:= CTX andalso TY =:= CTY ->
                               ignore;
                           not WalkTable ->
                               ignore;
                           true ->
                               insert_aound_map_nodes2(CurNode, EndTX, EndTY, TX, TY, close_list_member({TX, TY}))
                        end
                end, lists:seq(CTY-1, CTY+1))
      end, lists:seq(CTX-1, CTX+1)).

%% args CurNode EndTX,EndTY,TX,TY,IsColse
%% IsColse:boolean 是否存在关闭列表中
%% return  ignore|{error,Reason}|ok
insert_aound_map_nodes2(_CurNode, _EndTX, _EndTY, _TX, _TY, true) ->
    ignore;
insert_aound_map_nodes2(CurNode, EndTX, EndTY, TX, TY, false) ->   %%不存在关闭列表中
    MapNode = get_map_node(TX, TY, CurNode, EndTX, EndTY),         %%
    case common_minheap:key_find(?ASTAR_OPEN_HEAP, {TX, TY}) of
        undefined ->
            case common_minheap:insert(?ASTAR_OPEN_HEAP, MapNode, {TX, TY}) of
                {error, Reason} ->
                    erlang:throw({error, Reason});
                _ ->
                    ok
            end;
        OldMapNode ->
            if MapNode#r_map_node.f >= OldMapNode#r_map_node.f ->
                    ignore;
               true ->
                   case common_minheap:update(?ASTAR_OPEN_HEAP, MapNode, {TX, TY}) of
                       {error, Reason} ->
                           erlang:throw({error, Reason});
                       _ ->
                           ok
                   end
            end
    end.

cmp(NodeA, NodeB) ->
    NodeA#r_map_node.f < NodeB#r_map_node.f.

get_map_node(TX, TY, CurNode, EndTX, EndTY) ->
    %% 上一个点到周围点的距离
    G = CurNode#r_map_node.g + 1,
    H = erlang:abs(TX-EndTX) + erlang:abs(TY-EndTY),
    #r_map_node{key={TX, TY}, tx=TX, ty=TY, g=G, f=G+H,
                p_parent={CurNode#r_map_node.tx, CurNode#r_map_node.ty},
                dir=get_dir(CurNode, TX, TY)}.

is_tile_walkable(McmModule, TX, TY) ->
    case McmModule:get_slice_name({TX,TY}) of
        [#r_map_slice{type=?MAP_REF_TYPE_WALK}] ->
            true;
        _ ->
            false
    end.
%% is_tile_walkable(TX, TY) ->
%%     case erlang:get({TX, TY}) of
%%         undefined ->
%%             false;
%%         _ ->
%%             true
%%     end.

get_dir(StartNode, TX, TY) ->
    #r_map_node{tx=STX, ty=STY} = StartNode,
    if TX > STX ->
            if TY > STY -> 1;
               TY =:= STY -> 2;
               true -> 3
            end;
       TX =:= STX ->
            if TY > STY -> 0;
               true -> 4
            end;
       true ->
            if TY > STY -> 7;
               TY =:= STY -> 6;
               true -> 5
            end
    end.

set_close_list(L) ->
    erlang:put(?ASTAR_CLOSE_LIST, L).

get_close_list(EKey) ->
    case erlang:get({?ASTAR_CLOSE_LIST_ELEMENT, EKey}) of
        undefined ->
            {error, not_found};
        Node ->
            Node
    end.

get_close_list() ->
    case erlang:get(?ASTAR_CLOSE_LIST) of
        undefined ->
            [];
        L ->
            L
    end.

%% 插入关闭列表
close_list_insert(MapNode) ->
    set_close_list([MapNode#r_map_node.key|get_close_list()]),
    erlang:put({?ASTAR_CLOSE_LIST_ELEMENT, MapNode#r_map_node.key}, MapNode).

close_list_delete() ->
    lists:foreach(
      fun(EKey) ->
              erlang:erase({?ASTAR_CLOSE_LIST_ELEMENT, EKey})
      end, get_close_list()),
    erlang:erase(?ASTAR_CLOSE_LIST).

close_list_member(EKey) ->
    case get_close_list(EKey) of
        {error, _} ->
            false;
        _ ->
            true
    end.
