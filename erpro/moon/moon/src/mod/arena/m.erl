%%----------------------------------------------------
%% Author yqhuang(QQ:19123767)
%% Create: 
%% Description: 
%%----------------------------------------------------
-module(m).
-export([
        s/0
        ,sall/0
        ,loss/4
        ,loss_item/3
        ,top/1
        ,top/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").

loss(RoleId, SrvId, ItemId, Q) ->
    case role_api:lookup(by_id, {RoleId, SrvId}, #role.pid) of
        {ok, _N, Pid} ->
            role:apply(async, Pid, {m, loss_item, [ItemId, Q]});
        _ -> not_found
    end.

loss_item(Role, ItemId, Q) ->
    LossList = [#loss{label = item, val = [ItemId, 0, Q]}],
    case role_gain:do(LossList, Role) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {ok} 
    end.

s() ->
    ok.

sall() ->
    ok.

top(mem) ->
    top(memory, 1, 10);
top(queue) ->
    top(message_queue_len, 1, 10);
top(reds) ->
    top(reductions, 1, 10).
top(Type, Start, Len) ->
    L = do_top(Type, Start, Len),
    util:cn(
        "~20s ~36s ~36s ~24s ~12s ~12s ~12s~n"
        , ["Pid", "initial_call", "cur_fun", "first_msg", "memory", "reductions", "msg_len"]
    ),
    print_top(lists:reverse(L)).

%% top辅助函数
do_top(Type, Start, Len) when is_integer(Start), is_integer(Len), Start > 0, Len > 0 ->
    L = do_top1(Type, erlang:processes(), []),
    NL = lists:sublist(L, Start, Len),
    top_detail(NL, []).
do_top1(_Type, [], L) ->
    lists:sort(fun top_sort/2, L);
do_top1(Type, [P | Pids], L) ->
    NL = case process_info(P, Type) of
        {_, V} -> [{P, V} | L];
        _ -> L
    end,
    do_top1(Type, Pids, NL).
top_detail([], L) -> L;
top_detail([{P, _} | T], L) ->
    Mem = case process_info(P, memory) of
        {_, V1} -> V1;
        _ -> undefined
    end,
    Reds = case process_info(P, reductions) of
        {_, V2} -> V2;
        _ -> undefined
    end,
    InitCall = case process_info(P, dictionary) of
        {dictionary, Dlist = [_|_]}  ->
            case lists:keyfind('$initial_call', 1, Dlist) of
                {'$initial_call', V3} -> V3;
                _ ->
                    case process_info(P, initial_call) of
                        {_, V3} -> V3;
                        _ -> undefined
                    end
            end;
        _ ->
            case process_info(P, initial_call) of
                {_, V3} -> V3;
                _ -> undefined
            end
    end,
    MsgLen = case process_info(P, message_queue_len) of
        {_, V4} -> V4;
        _ -> undefined
    end,
    _RegName = case process_info(P, registered_name) of
        {_, V5} -> V5;
        _ -> undefined
    end,
    CurFun = case process_info(P, current_function) of
        {_, V6} -> V6;
        _ -> undefined
    end,
    FirstMsg = case process_info(P, messages) of
        {messages,[K|_]} -> io_lib:write(K);
        {messages,[]} -> [];
        {messages, _} -> unknow_style;
        _ -> 
            null
    end,
    top_detail(T, [[P, InitCall, CurFun, FirstMsg, Mem, Reds, MsgLen] | L]).
top_sort({_, A}, {_, B}) when A =< B -> false;
top_sort(_, _) -> true.

%% 格式化打钱top信息
print_top([]) -> ok;
print_top([H | T]) ->
    io:format("~20w ~36w ~36w ~24s ~12w ~12w ~12w~n", H),
    print_top(T).
