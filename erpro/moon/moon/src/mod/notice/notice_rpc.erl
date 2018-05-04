%% -------------------------------------
%% 
%% 
%% @author qingxuan
%% -------------------------------------
-module(notice_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("notification.hrl").

%% handle(integer(), tuple(), #role{}) -> Ret
%% Ret = {ok} | {ok, #role{}} | {reply, tuple()} | {reply, tuple(), #role{}}

%% 弹出通知调用
handle(11153, {Type, Args}, Role) ->
    case Type of
        ?notify_type_hall ->
            [HallId, RoomNo] = Args,
            case hall:direct_enter_room(HallId, RoomNo, Role) of
                ok ->
                    {reply, {0}};
                {false, ReasonId} ->
                    notice:alert(error, Role, ReasonId),
                    {ok}
            end;
        _ ->
            {ok}
    end;

%% 打开通知列表
handle(11154, {}, Role) ->
    List = notification:get_list(),
    {reply, {List}, Role};


handle(_Cmd, _Data, _) ->
    {error, unknow_cmd}.


%% --私有函数-------------------------------


