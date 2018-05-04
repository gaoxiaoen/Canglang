%%----------------------------------------------------
%%  特殊npc
%%
%% @author qingxuan
%%----------------------------------------------------
-module(special_npc).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([start_link/0]).
-export([
]).
-include("common.hrl").
-include("map.hrl").
-include("npc.hrl").
-compile(export_all).

-record(state, {}).

%% --------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% -----------------------------------------------------
%% 内部处理
%% -----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    try add_helper() 
    catch T:X ->
        ?ERR("~p : ~p", [{T,X}, erlang:get_stacktrace()])
    end,
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Data, State) ->
    {noreply, State}.

%% 容错
handle_info(_Data, State) ->
    ?ELOG("错误的异步消息处理：DATA:~p, State:~p", [_Data, State]),
    {noreply, State}.

terminate(_Reason, _State) ->
    {noreply, _State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


% add_helper() ->
%     LeftX = 500,
%     Paths1 = [[
%         {LeftX, ?helper_def_pos_y},
%         {LeftX + 360, ?helper_def_pos_y},
%         {LeftX + 720, ?helper_def_pos_y},
%         {LeftX + 1080, ?helper_def_pos_y},
%         {LeftX + 1440, ?helper_def_pos_y},
%         {LeftX + 1800, ?helper_def_pos_y},
%         {LeftX + 2160, ?helper_def_pos_y},
%         {LeftX + 1800, ?helper_def_pos_y},
%         {LeftX + 1440, ?helper_def_pos_y},
%         {LeftX + 1080, ?helper_def_pos_y},
%         {LeftX + 720, ?helper_def_pos_y},
%         {LeftX + 360, ?helper_def_pos_y},
%         {LeftX, ?helper_def_pos_y}
%     ]],
%     Paths2 = [[
%         {LeftX, ?helper_def_pos_y},
%         {LeftX + 360, ?helper_def_pos_y},
%         {LeftX + 720, ?helper_def_pos_y},
%         {LeftX + 1080, ?helper_def_pos_y},
%         {LeftX + 1440, ?helper_def_pos_y},
%         {LeftX + 1800, ?helper_def_pos_y},
%         {LeftX + 2160, ?helper_def_pos_y},
%         {LeftX + 2520, ?helper_def_pos_y},
%         {LeftX + 2880, ?helper_def_pos_y},
%         {LeftX + 3240, ?helper_def_pos_y},
%         {LeftX + 2880, ?helper_def_pos_y},
%         {LeftX + 2520, ?helper_def_pos_y},
%         {LeftX + 2160, ?helper_def_pos_y},
%         {LeftX + 1800, ?helper_def_pos_y},
%         {LeftX + 1440, ?helper_def_pos_y},
%         {LeftX + 1080, ?helper_def_pos_y},
%         {LeftX + 720, ?helper_def_pos_y},
%         {LeftX + 360, ?helper_def_pos_y},
%         {LeftX, ?helper_def_pos_y}
%     ]],
%     npc_mgr:create(#npc_base{id = 10053, type = 1, t_patrol = {2000, 2000}}, ?capital_map_id, LeftX, ?helper_def_pos_y, <<>>, Paths1, <<>>),
%     npc_mgr:create(#npc_base{id = 10053, type = 1, t_patrol = {2000, 2000}}, ?capital_map_id2, LeftX, ?helper_def_pos_y, <<>>, Paths2, <<>>),
%     npc_mgr:create(#npc_base{id = 10053, type = 1, t_patrol = {2000, 2000}}, ?capital_map_id3, LeftX, ?helper_def_pos_y, <<>>, Paths1, <<>>),
%     npc_mgr:create(#npc_base{id = 10053, type = 1, t_patrol = {2000, 2000}}, ?capital_map_id4, LeftX, ?helper_def_pos_y, <<>>, Paths1, <<>>).

add_helper() ->
    create_helper(?capital_map_id2, 10053),
    create_helper(?capital_map_id3, 10053),
    create_helper(?capital_map_id4, 10053),
    create_helper(?capital_map_id5, 10053).

-define(helper_def_pos_y, 500).
create_helper(MapId, NpcBaseId) ->
    %StartX = 500,
    MoveInterval = 2,   %% 2秒移动一步
    case npc_data:get(NpcBaseId) of
        {ok, NpcBase = #npc_base{speed = Speed}} ->
            #map_data{width = Width} = map_data:get(MapId),
            StepDist = Speed * MoveInterval,  %% 一步的距离
            {StartX, Steps} = case (Width rem StepDist) div 2 of  %% {开始位置, 步数}
                Sx when Sx > 300 ->  %% 起始位置必须大于300
                    {Sx, Width div StepDist + 1};
                Sx ->
                    {Sx + (StepDist div 2), Width div StepDist}
            end,
            Tpatrol = MoveInterval * 1000,
            NewNpcBase = NpcBase#npc_base{
                type = 1 %% 中立 
                ,t_patrol = {Tpatrol, Tpatrol}
            },  
            Path = helper_path(StartX, StepDist, Steps),
            map_line:each_line(fun(Line) ->
                npc_mgr:create(NewNpcBase, {Line, MapId}, StartX, ?helper_def_pos_y, <<>>, [Path], <<>>)
            end);
        Other ->
            ?ERR("~p", [Other])
    end.

helper_path(StartX, StepDist, Steps) ->
    PathAsc = for(0, Steps, fun(I, Acc)->
       Acc ++ [{StartX + I * StepDist, ?helper_def_pos_y}]
    end, []),
    [_|PathDesc] = lists:reverse(PathAsc),
    PathAsc ++ PathDesc.
    
for(From, To, _Fun, Acc) when From > To -> Acc;
for(To, To, _Fun, Acc) -> Acc;
for(From, To, Fun, Acc) -> 
    Acc1 = Fun(From, Acc),
    for(From + 1, To, Fun, Acc1).

