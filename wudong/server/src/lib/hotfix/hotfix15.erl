%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2017 15:40
%%%-------------------------------------------------------------------
-module(hotfix15).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
%% API
-compile(export_all).


%%log
make_bug_info() ->
    case center:is_center_all() of
        true ->
            Nodes = center:get_all_nodes(),
            F = fun(#ets_kf_nodes{node = Node}, AccIn) ->
                try
                    case rpc:call(Node, ?MODULE, get_bug_list, []) of
                        BugList when is_list(BugList) ->
                            BugList ++ AccIn;
                        _R ->
                            AccIn
                    end
                catch
                    _:_ ->
                        ?WARNING("rpc get log  fail,node:~s", [Node]),
                        AccIn
                end
                end,
            L = lists:foldl(F, [], Nodes),
            write_to_text(L);
        _ ->
            skip
    end.


-define(BUG_KEY_ID(Key), {bug_key_id, Key}).
%% 统计bug list
get_bug_list() ->
    ServerNum = config:get_server_num(),
    RegAcc = get_reg(),
    BabyAcc = get_baby(),
    ZBAcc = get_equip(0),
    ChengAcc = get_equip(3),
    HongAcc = get_equip(4),
    [{ServerNum, BabyAcc, ZBAcc, ChengAcc, HongAcc, RegAcc}].

get_reg() ->
    Sql = "select count(*) from player_login",
    db:get_one(Sql).

get_baby() ->
    Sql = "select count(*) from baby",
    db:get_one(Sql).


get_equip(Star) ->
    Sql =
        if Star == 0 ->
            io_lib:format("select pkey from goods where location = 1 ", []);
            true ->
                io_lib:format("select pkey from goods where location = 1 and star >= ~p ", [Star])
        end,
    F = fun([Pkey], L) ->
        case lists:keytake(Pkey, 1, L) of
            false ->
                [{Pkey, 1} | L];
            {value, {_, Acc}, T} ->
                [{Pkey, Acc + 1} | T]
        end
        end,
    AccList = lists:foldl(F, [], db:get_all(Sql)),
    length([true || {_, Acc} <- AccList, Acc == 8]).

%% 写入文本
write_to_text(List) ->
    FileName = io_lib:format("../server_calc.txt", []),
    {ok, S} = file:open(FileName, write),
    lists:foreach(fun({ServerNum, BabyAcc, ZBAcc, ChengAcc, HongAcc, RegAcc}) ->
        io:format(S, "~w    ~w  ~w  ~w ~w ~w~n", [ServerNum, BabyAcc, ZBAcc, ChengAcc, HongAcc, RegAcc])
                  end, List),
    file:close(S).
