%%%-------------------------------------------------------------------
%%% File        :mod_walk.erl
%%% @doc
%%%     地图走路，寻路
%%% @end
%%%-------------------------------------------------------------------
-module(mod_walk).

-include("mgeem.hrl").

-export([
         get_walk_path/2,
         get_straight_line_path/3,
         get_senior_path/2
        ]).


%%----------------------------------------------------------------
%% 获得走路路径  先采用直线，不行再走高级寻路
%% @CurrentPos 当前位置#p_map_tile
%% @GotoPos 要前往的位置#p_map_tile
%%----------------------------------------------------------------
-spec
get_walk_path(CurrentPos, GotoPos) -> PathList when
    CurrentPos :: #p_map_tile{},
    GotoPos :: #p_map_tile{},
    PathList :: [#p_map_tile{},...].
get_walk_path(CurrentPos, GotoPos) ->
    case get_straight_line_path(CurrentPos, GotoPos, []) of
        false ->
            case get_senior_path(CurrentPos, GotoPos) of
                false ->
                    undefined;
                {ok,Path} ->
                    [#p_map_tile{tx=Tx,ty=Ty,dir=Dir} || {Tx,Ty,Dir} <- Path]
            end;
        {ok,Path} ->
            [#p_map_tile{tx=Tx,ty=Ty,dir=Dir} || {Tx,Ty,Dir} <- Path]
    end.


%%----------------------------------------------------------------
%% 直线寻路
%% @CurrentPos 当前位置#p_map_tile
%% @GotoPos 要前往的位置#p_map_tile
%% @Path路径信息
%%----------------------------------------------------------------
get_straight_line_path(CurrentPos,GotoPos,Path) ->
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    get_straight_line_path(CurrentPos,GotoPos,Path,McmModule,{-10000,-10000}).

%% return false|{ok,PathList}
get_straight_line_path(CurrentPos,GotoPos,Path,McmModule,{LastTx,LastTy}) ->
    #p_map_tile{tx = Tx1, ty = Ty1, dir=Dir1} = CurrentPos,
    #p_map_tile{tx = Tx2, ty = Ty2, dir = Dir2} = GotoPos,
    case Tx1 =:= Tx2 andalso Ty1 =:= Ty2 of
        true ->
            {ok,lists:reverse([{Tx2,Ty2,Dir2}|Path])};
        false ->
            PosList = get_straight_line_pos_list(Tx1, Ty1, Tx2, Ty2),
            case get_empty_grid(PosList,McmModule) of
                false ->
                    false;
               #p_map_tile{tx=Tx,ty=Ty} = NextPos ->
                    case Tx =:= LastTx andalso Ty =:= LastTy of
                        true ->
                            false;
                        false ->
                            get_straight_line_path(NextPos,GotoPos,[{Tx1,Ty1,Dir1}|Path],McmModule,{Tx1,Ty1})
                    end
            end
    end.

%%----------------------------------------------------------------
%% 高级寻路，目前用的使用A*寻路
%% @CurrentPos 当前位置#p_map_tile
%% @GotoPos 要前往的位置#p_map_tile
%%----------------------------------------------------------------
get_senior_path(CurrentPos, GotoPos)->
   case mod_astar_pathfinding:find_path(CurrentPos, GotoPos) of
       false ->
           false;
       Path ->
           {ok,Path}
    end.

get_empty_grid([],_McmModule) ->
    false;
get_empty_grid([{X,Y,Dir}|List],McmModule) ->
    case McmModule:get_slice_name({X,Y}) of
        [#r_map_slice{type=?MAP_REF_TYPE_WALK}] ->
            #p_map_tile{tx = X, ty = Y, dir = Dir};
        _ ->
            get_empty_grid(List,McmModule)
    end.

get_straight_line_pos_list(Tx1, Ty1, Tx2, Ty2) ->
    case Tx1 < Tx2 of
        true ->
            case Ty1 < Ty2 of
                true ->
                    [{Tx1+1, Ty1+1, 4}, {Tx1+1, Ty1, 3}, {Tx1, Ty1+1, 5}];
                false ->
                    case Ty1 > Ty2 of
                        true ->
                            [{Tx1+1, Ty1-1, 2}, {Tx1+1, Ty1, 3}, {Tx1, Ty1-1, 1}];
                        false ->
                            [{Tx1+1, Ty1, 3}, {Tx1+1, Ty1-1, 2}, {Tx1+1, Ty1+1, 4}]
                    end
            end;
        false ->
            case Tx1 > Tx2 of
                true ->
                    case Ty1 < Ty2 of
                        true ->
                            [{Tx1-1, Ty1+1, 6}, {Tx1-1, Ty1, 7}, {Tx1, Ty1+1, 5}];
                        false ->
                            case Ty1 > Ty2 of
                                true ->
                                    [{Tx1-1, Ty1-1, 0}, {Tx1, Ty1-1, 1}, {Tx1-1, Ty1, 7}];
                                false ->
                                    [{Tx1-1, Ty1, 7}, {Tx1-1, Ty1-1, 0}, {Tx1-1, Ty1+1, 6}]
                            end
                    end;
                false ->
                    case Ty1 < Ty2 of
                        true ->
                            [{Tx1, Ty1+1, 5}, {Tx1+1, Ty1+1, 4}, {Tx1-1, Ty1+1, 6}];
                        false ->
                            [{Tx1, Ty1-1, 1}, {Tx1-1, Ty1-1, 0}, {Tx1+1, Ty1-1, 2}]
                    end
            end
    end.
