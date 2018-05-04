%% Author: caochuncheng2002@gmail.com
%% Created: 2013-11-28
%% Description: 地图slice计算模块

-module(mod_map_slice).

-include("mgeem.hrl").

-export([
		 gen_slice_name/2,
		 get_slice_name_by_txty/4,
		 get_slice_name_by_pxpy/2,
		 get_9_slice_by_txty/6,
         get_16_slice_by_txty/6
		]).

-export([
         to_tile_pos/2,
         to_pixel_pos/2,
         calc_ab_distance/2,
         calc_ab_distance/4,
         
         get_actor_by_half_circle/3,
         calc_direction_by_pos/2,
         get_random_pos_by_midpoint/6
        ]).

%% 生成slice名称
gen_slice_name(SliceX, SliceY) ->
    lists:concat(["slice_", SliceX, "_", SliceY]).

%% 原始坐标转换为格子坐标
to_tile_pos(Px,Py) ->
    Tx = floor((Px - (Px rem ?MAP_TILE_SIZE))/?MAP_TILE_SIZE),
    Ty = floor((Py - (Py rem ?MAP_TILE_SIZE))/?MAP_TILE_SIZE),
    {Tx,Ty}.
%% 格子坐标转换为原始坐标
to_pixel_pos(Tx,Ty) ->
    Px = floor(Tx * ?MAP_TILE_SIZE + ?MAP_TILE_SIZE_MIDDLE),
    Py = floor(Ty * ?MAP_TILE_SIZE + ?MAP_TILE_SIZE_MIDDLE),
    {Px,Py}.

%% 平台坐标系统，计算两点的距离，计算结果取整
-spec
calc_ab_distance(A,B) -> AB when
    A :: #p_pos{},
    B :: #p_pos{},
    AB :: integer().
calc_ab_distance(#p_pos{x=Xa,y=Ya},#p_pos{x=Xb,y=Yb}) ->
    calc_ab_distance(Xa,Ya,Xb,Yb).
calc_ab_distance(Xa,Ya,Xb,Yb) ->
    erlang:trunc(math:sqrt((Xb - Xa) * (Xb - Xa) + (Yb - Ya) * (Yb - Ya))).
%% 算法坐标转换计算
get_iso_index_mid_vertex(X, Y) ->
    X2 = X * ?MAP_TILE_SIZE + ?MAP_TILE_SIZE_MIDDLE,
    Y2 = Y * ?MAP_TILE_SIZE + ?MAP_TILE_SIZE_MIDDLE,
    {X2, Y2}.

%%根据格子或者像素位置获得所在的slice名称
get_slice_name_by_txty(TileX, TileY, OffsetX, OffsetY) ->
    {PixelX, PixelY} = get_iso_index_mid_vertex(TileX,TileY),
     CorrectPixelX = PixelX + OffsetX,
    CorrectPixelY = PixelY + OffsetY,
    get_slice_name_by_pxpy(CorrectPixelX, CorrectPixelY).

get_slice_name_by_pxpy(PixelX, PixelY) ->
    SliceX = floor(PixelX/?MAP_SLICE_WIDTH),
    SliceY = floor(PixelY/?MAP_SLICE_HEIGHT),
    gen_slice_name(SliceX, SliceY).

%% 以一个中心点，以A点中，以Radius为半径的圆，面向B点半圆
%% Radius 半径，单位：厘米
-spec 
get_actor_by_half_circle(A,B,Radius) -> ActorList when
    A :: #p_pos{},
    B :: #p_pos{},
    Radius :: integer(),
    ActorList :: [] | [{ActorType,ActorId}],
    ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER,
    ActorId :: role_id | pet_id | monster_id | integer().
get_actor_by_half_circle(#p_pos{x=Xa,y=Ya}=APos,#p_pos{x=_Xb,y=_Yb}=BPos,Radius) ->
    Step = Radius div ?MAP_TILE_SIZE + 2,
    Dir = calc_direction_by_pos(APos, BPos),
    {Tx, Ty} = mod_map_slice:to_tile_pos(Xa, Ya),
    if Dir == 1 orelse Dir == 2->
           TileList = [{A, B} || A <- lists:seq(Tx - Step, Tx + Step), B <- lists:seq(Ty, Ty + Step), A > 0, B > 0] ++
                          [{A, B} || A <- lists:seq(Tx, Tx + Step), B <- lists:seq(Ty - Step,Ty), A > 0, B > 0];
       Dir == 3 orelse Dir == 4 ->
           TileList = [{A, B} || A <- lists:seq(Tx - Step, Tx + Step), B <- lists:seq(Ty - Step, Ty), A > 0, B > 0] ++
                          [{A, B} || A <- lists:seq(Tx, Tx + Step), B <- lists:seq(Ty,Ty + Step), A > 0, B > 0];
       Dir == 5 orelse Dir == 6 ->
           TileList = [{A, B} || A <- lists:seq(Tx - Step, Tx + Step), B <- lists:seq(Ty - Step, Ty), A > 0, B > 0] ++
                          [{A, B} || A <- lists:seq(Tx - Step, Tx), B <- lists:seq(Ty,Ty + Step), A > 0, B > 0];
       true ->
           TileList = [{A, B} || A <- lists:seq(Tx - Step, Tx + Step), B <- lists:seq(Ty, Ty + Step), A > 0, B > 0] ++
                          [{A, B} || A <- lists:seq(Tx - Step, Tx), B <- lists:seq(Ty - Step,Ty), A > 0, B > 0]
    end,
    lists:flatten([mod_map:get_tile_pos(A, B)||{A, B} <- TileList]).

%% 以A点为原点，计算相对于原点的B点所在的方向
%% 8个方向如下所示:
%%           |
%%       8   |   1
%%           |
%%    7      |       2
%% -----------------------
%%    6      |      3
%%           |
%%       5   |   4
%%           |
%%           |
-spec
calc_direction_by_pos(APos,BPos) -> Direction | 0 when
    APos :: #p_pos{},
    BPos :: #p_pos{},
    Direction :: integer.
calc_direction_by_pos(#p_pos{x=Xa,y=Ya},#p_pos{x=Xb,y=Yb}) ->
    if Xb >= Xa andalso Yb >= Ya ->
           case erlang:abs(Yb - Ya) >= erlang:abs(Xb - Xa) of
               true -> 1;
               _ -> 2
           end;
       Xb >=Xa andalso Yb < Ya ->
           case erlang:abs(Yb - Ya) >= erlang:abs(Xb - Xa) of
               true -> 4;
               _ -> 3
           end;
       Xb < Xa andalso Yb < Ya ->
           case erlang:abs(Yb - Ya) >= erlang:abs(Xb - Xa) of
               true -> 5;
               _ -> 6
           end;
       Xb < Xa andalso Yb >= Ya ->
            case erlang:abs(Yb - Ya) >= erlang:abs(Xb - Xa) of
               true -> 8;
               _ -> 7
           end;
       true ->
           0
    end.

%% 根据中心点，半径，随机搜索多个小区域中心点，小区域半径MinRadius
-spec 
get_random_pos_by_midpoint(X,Y,MaxRadius,MinRadius,SubRadius,Number) -> PosList when
    X :: integer(),
    Y :: integer(),
    MaxRadius :: integer(),
    MinRadius :: integer(),
    SubRadius :: integer(),
    Number :: integer(),
    PosList :: [] | [#p_pos{}].
get_random_pos_by_midpoint(X,Y,MaxRadius,MinRadius,SubRadius,Number) ->
    MaxStep = MaxRadius div ?MAP_TILE_SIZE + 1,
    MinStep = MinRadius div ?MAP_TILE_SIZE,
    SubStep = SubRadius div ?MAP_TILE_SIZE,
    {Tx, Ty} = mod_map_slice:to_tile_pos(X, Y),
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    TileListT = [{A, B} || A <- lists:seq(Tx - MaxStep, Tx + MaxStep), 
                          B <- lists:seq(Ty - MaxStep, Ty + MaxStep), 
                          A > 0, B > 0,
                          mod_map:check_tile_pos(McmModule, A, B) == true],
    FilterTileList = [{A, B} || A <- lists:seq(Tx - MinStep, Tx + MinStep), B <- lists:seq(Ty - MinStep, Ty + MinStep)],
    TileList = lists:foldl(
                 fun(Key,AccTileList) ->
                         lists:delete(Key, AccTileList)
                 end, TileListT, FilterTileList),
    get_random_pos_by_midpoint2(Number,SubStep,TileList,[]).
get_random_pos_by_midpoint2(0,_SubStep,_TileList,PosList) ->
    PosList;
get_random_pos_by_midpoint2(_Number,_SubStep,[],PosList) ->
    PosList;
get_random_pos_by_midpoint2(Number,SubStep,TileList,PosList) ->
    Len = erlang:length(TileList),
    Index = common_tool:random(1, Len),
    random:seed(erlang:now()),
    {Tx,Ty} = lists:nth(Index, TileList),
    DelTileList = [{A, B} || A <- lists:seq(Tx - SubStep - SubStep, Tx + SubStep + SubStep),
                             B <- lists:seq(Ty - SubStep - SubStep, Ty + SubStep + SubStep), 
                             A > 0, B > 0],
    NewTileList = lists:foldl(
                    fun(Key,AccTileList) -> 
                            lists:delete(Key, AccTileList)
                    end, TileList, DelTileList),
    {X,Y} = to_pixel_pos(Tx, Ty),
    get_random_pos_by_midpoint2(Number - 1,SubStep,NewTileList,[#p_pos{x=X,y=Y} | PosList]).

    

%%根据格子所在位置获得九宫格slice
get_9_slice_by_txty(TileX,TileY,OffsetX,OffsetY,Width,Height) ->
    {PixelX, PixelY} = get_iso_index_mid_vertex(TileX,TileY),
    CorrectPixelX = PixelX + OffsetX,
    CorrectPixelY = PixelY + OffsetY,
    
    SliceX = floor(CorrectPixelX/?MAP_SLICE_WIDTH),
    SliceY = floor(CorrectPixelY/?MAP_SLICE_HEIGHT),
    
    MaxSliceX = ceil(Width/?MAP_SLICE_WIDTH) - 1,
    MaxSliceY = ceil(Height/?MAP_SLICE_HEIGHT) - 1,
    get_9_slice_list(MaxSliceX,MaxSliceY,SliceX,SliceY).

%% 九宫格计算
get_9_slice_list(SliceWidthMaxValue,SliceHeightMaxValue, SX, SY) ->
    if SX > 0 ->
            BeginX = SX - 1;
        true ->
            BeginX = 0
    end,
    if SY > 0 ->
            BeginY = SY - 1;
        true ->
            BeginY = 0
    end,
    if SX >= SliceWidthMaxValue ->
            EndX = SliceWidthMaxValue;
        true ->
            EndX = SX + 1
    end,
    if SY >= SliceHeightMaxValue ->
            EndY = SliceHeightMaxValue;
        true ->
            EndY = SY + 1
    end,
    get_9_slice_list2(BeginX, BeginY, EndX, EndY).
get_9_slice_list2(BeginX, BeginY, EndX, EndY) ->
	lists:foldl(
	  fun(TempSX, Acc) ->
			  lists:foldl(
				fun(TempSY, AccSub) ->
						Temp = gen_slice_name(TempSX, TempSY),
						[Temp|AccSub]
				end,
				Acc,lists:seq(BeginY, EndY))
	  end, [], lists:seq(BeginX, EndX)).

%%根据格子所在位置获得九宫格slice
get_16_slice_by_txty(TileX,TileY,OffsetX,OffsetY,Width,Height) ->
    {PixelX, PixelY} = get_iso_index_mid_vertex(TileX,TileY),
    CorrectPixelX = PixelX + OffsetX,
    CorrectPixelY = PixelY + OffsetY,
    
    SliceX = floor(CorrectPixelX/?MAP_SLICE_WIDTH),
    SliceY = floor(CorrectPixelY/?MAP_SLICE_HEIGHT),
    
    MaxSliceX = ceil(Width/?MAP_SLICE_WIDTH) - 1,
    MaxSliceY = ceil(Height/?MAP_SLICE_HEIGHT) - 1,
    get_16_slice_list(MaxSliceX,MaxSliceY,SliceX,SliceY).

%% 16宫格计算
get_16_slice_list(SliceWidthMaxValue,SliceHeightMaxValue, SX, SY) ->
    if SX > 0 ->
           if SX > 1 ->
                  BeginX = SX - 2;
              true ->
                  BeginX = SX - 1
           end;
        true ->
            BeginX = 0
    end,
    if SY > 0 ->
           if SY > 1 ->
                  BeginY = SY - 2;
              true ->
                  BeginY = SY - 1
           end;
        true ->
            BeginY = 0
    end,
    if SX >= SliceWidthMaxValue ->
            EndX = SliceWidthMaxValue;
        true ->
            EndX = SX + 2
    end,
    if SY >= SliceHeightMaxValue ->
            EndY = SliceHeightMaxValue;
        true ->
            EndY = SY + 2
    end,
    get_16_slice_list2(BeginX, BeginY, EndX, EndY).
get_16_slice_list2(BeginX, BeginY, EndX, EndY) ->
    lists:foldl(
      fun(TempSX, Acc) ->
              lists:foldl(
                fun(TempSY, AccSub) ->
                        Temp = gen_slice_name(TempSX, TempSY),
                        [Temp|AccSub]
                end,
                Acc,lists:seq(BeginY, EndY))
      end, [], lists:seq(BeginX, EndX)).

%% 向下取整
floor(X) ->
	T = trunc(X),
	if X - T == 0 ->
		   T;
	   true ->
		   if X > 0 ->
				  T;
			  true ->
				  T-1
		   end
	end.
%% 向上取整
ceil(X) ->
	T = trunc(X),
	if X - T == 0 ->
		   T;
	   true ->
		   if X > 0 ->
				  T + 1;
			  true ->
				  T
		   end			
	end.
