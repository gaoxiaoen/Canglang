%%----------------------------------------------------
%% 世界树相关远程调用
%%
%% @author mobin
%%----------------------------------------------------
-module(tree_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("tree.hrl").
-include("pos.hrl").
-include("unlock_lev.hrl").


%% 请求进入世界树
handle(13600, {}, Role = #role{pid = RolePid, lev = Lev, event = Event, id = {RoleId, SrvId}, pos = #pos{map_pid = MapPid, x = X, y = Y}}) when Event =/= ?event_tree ->
    case Lev < ?tree_unlock_lev of
        false ->
            map:role_leave(MapPid, RolePid, RoleId, SrvId, X, Y), %% 离开上一个地图
            Role2 = tree_api:enter(Role),
            {ok, Role2};
        true -> 
            {ok}
    end;

%% 请求退出世界树
handle(13601, {}, Role = #role{pos = #pos{map = MapId, x = X, y = Y}}) ->
    case map:role_enter(MapId, X, Y, Role) of
        {false, _Reason} ->
            {ok};
        {ok, Role2} -> 
            {reply, {}, Role2#role{event = ?event_no}}
    end;

%% 请求前进
handle(13602, {}, Role) ->
    #tree_role{status = Status} = get(tree_role),
    case Status =:= ?forward orelse Status =:= ?charge  of
        true ->
            case tree_api:forward(Role) of
                {NewStatus, NRole} ->
                    {reply, {NewStatus}, NRole};
                _ ->
                    {reply, {?limit}}
            end;
        false ->
            {ok}
    end;

%% 请求冲锋
handle(13603, {}, Role) ->
    #tree_role{status = Status} = get(tree_role),
    case Status =:= ?charge  of
        true ->
            {Reply, NRole} = tree_api:charge(Role),
            {reply, Reply, NRole};
        false ->
            {ok}
    end;

%% 请求打开宝箱
handle(13604, {}, Role) ->
    #tree_role{status = Status} = get(tree_role),
    case Status =:= ?box  of
        true ->
            {Reply, Role2} = tree_api:open(Role),
            log:log(log_coin, {<<"世界树">>, <<"世界树">>, Role, Role2}),
            {reply, Reply, Role2};
        false ->
            {ok}
    end;

%% 请求进攻
handle(13605, {}, Role) ->
    #tree_role{status = Status} = get(tree_role),
    case Status =:= ?boss orelse Status =:= ?lose of
        true ->
            Role2 = tree_api:attack(Role),
            {ok, Role2};
        false ->
            {ok}
    end;

handle(13608, {}, _Role = #role{id = Rid}) ->
    #tree_role{floor = Floor} = tree_api:get_tree_role(Rid),
    {reply, {Floor}};

handle(13611, {IsBuy}, Role) ->
    {IsBuy2, Role2} = tree_api:exit_lose(Role, IsBuy),
    {reply, {IsBuy2}, Role2};

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
