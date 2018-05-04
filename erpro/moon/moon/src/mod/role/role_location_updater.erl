%% --------------------
%% 角色位置更新
%% @author qingxuan
%% --------------------
-module(role_location_updater).
-export([
    activate/1
    ,update/2
    ,deactivate/0
]).
-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").

-define(interval, 1000).  %% 1秒

%% -> ref()
activate(MapPid) ->
    case get(location_updater) of
        undefined ->
            Ref = erlang:start_timer(?interval, self(), {location_updater, MapPid}),
            put(location_updater, Ref),
            Ref;
        Ref ->
            case erlang:read_timer(Ref) of
                false -> %% 已被cancel或timeout消息已发往消息队列
                    NewRef = erlang:start_timer(?interval, self(), {location_updater, MapPid}),
                    put(location_updater, NewRef),
                    NewRef;
                _ -> %% 时间未到
                    Ref
            end
    end.

%% -> #role{}
update(Ref, Role = #role{pos = Pos = #pos{x = X, y = Y, dest_x = DestX, dest_y = DestY, map_pid = MapPid}, speed = Speed, pid = RolePid}) ->
    ?DEBUG("update...."),
    case Ref =:= get(location_updater) of 
        false -> %% 已被deactivate
            Role;
        _ ->
            Dx = DestX - X,
            Dy = DestY - Y,
            N = math:sqrt(math:pow(Dx, 2) + math:pow(Dy, 2)),
            case erlang:is_number(N) andalso N /= 0 of %% 必须是/=，不能是=/=，因为结果有可能是浮点数0.0，而不是0
                true ->
                    K = Speed / N,
                    {NewX, NewY} = case K >= 1 of
                        true ->
                            deactivate(),
                            {DestX, DestY};
                        false ->
                            NewRef = erlang:start_timer(?interval, self(), {location_updater, MapPid}),
                            put(location_updater, NewRef),
                            {X + round(Dx * K), Y + round(Dy * K)}
                    end,
                    map:role_move_step(MapPid, RolePid, X, Y, NewX, NewY),
                    Role#role{pos = Pos#pos{x = NewX, y = NewY}};
                false ->
                    deactivate(),
                    Role
            end
    end.

%% -> ref() | undefined
deactivate() ->
    case erase(location_updater) of
        undefined ->
            undefined;
        Ref ->
            erlang:cancel_timer(Ref),
            Ref
    end.

