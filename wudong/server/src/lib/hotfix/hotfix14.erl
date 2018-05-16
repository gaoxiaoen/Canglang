%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十一月 2017 16:35
%%%-------------------------------------------------------------------
-module(hotfix14).
-author("hxming").
-include("fashion.hrl").

%% API
-compile(export_all).

-define(FASHION_ID, 10017).

key_list() ->
    Sql = "SELECT pkey from log_cs_charge_d WHERE `time` > 1510848000 and `time` < 1510908300",
%%    Sql = "SELECT pkey from log_cs_charge_d WHERE `time` > 1510848000 ",
    PkeyList = [Pkey || [Pkey] <- db:get_all(Sql)],
    PkeyList.

fix() ->
    PkeyList = key_list(),
    ban(PkeyList),
    loop_fix(PkeyList),
    ok.


loop_fix([]) -> ok;
loop_fix([Pkey | T]) ->
    offline(Pkey),
    util:sleep(100),
    loop_fix(T).

offline(Pkey) ->
    StFashion = init(Pkey),
    IsUse =
        case lists:keytake(?FASHION_ID, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
            false -> false;
            {value, Fashion, T} ->
                FashionList = [Fashion#fashion{stage = 1} | T],
                NewStFashion = StFashion#st_fashion{fashion_list = FashionList},
                fashion_load:replace_fashion(NewStFashion),
                true
        end,
    case IsUse of
        true ->
            del_goods_out_line(Pkey, 6601017, 10);
        false ->
            del_goods_out_line(Pkey, 6601017, 9)
    end,
    SQL = io_lib:format("select sum(create_num) from log_goods_create where pkey=~p and goods_id = 6602017 and `time` >1510848000", [Pkey]),
    case db:get_one(SQL) of
        Acc when is_integer(Acc) ->
            case IsUse of
                false ->
                    del_goods_out_line(Pkey, 6602017, Acc - 10);
                true ->
                    del_goods_out_line(Pkey, 6602017, Acc)
            end;
        _ -> ok
    end,
    %%解封
    Sql = io_lib:format("update player_login set status = 0 where pkey = ~w", [Pkey]),
    db:execute(Sql),
    ok.


%% 离线删玩家数据
del_goods_out_line(_, _, 0) -> ok;
del_goods_out_line(Pkey, GoodsId, DelGoodsNum) ->
    ?PRINT("GoodsId =========~w, GoodsNum ~w", [GoodsId, DelGoodsNum]),
    Sql = io_lib:format("select gkey,goods_id,num from goods where pkey = ~w  and goods_id = ~w", [Pkey, GoodsId]),
    Data = db:get_all(Sql),
    loop_del(DelGoodsNum, Data, Pkey).

loop_del(0, _, _) -> ok;
loop_del(_, [], _) -> ok;
loop_del(DelGoodsNum, [[Gkey, _GoodsId, GoodsNum2] | T], Pkey) ->
    case DelGoodsNum >= GoodsNum2 of
        true ->
            DeleteSql = io_lib:format("delete from goods where gkey = ~w limit 1", [Gkey]),
            db:execute(DeleteSql),
            loop_del(DelGoodsNum - GoodsNum2, T, Pkey);
        _ ->
            LeftGoods = GoodsNum2 - DelGoodsNum,
            Sql2 = io_lib:format("update goods set num = ~p where gkey = ~w", [LeftGoods, Gkey]),
            db:execute(Sql2)
    end.

init(Pkey) ->
    Now = util:unixtime(),
    case fashion_load:load_fashion(Pkey) of
        [] ->
            #st_fashion{pkey = Pkey};
        [FashionList] ->
            NewFashionList = fashion2list(FashionList, Now),
            #st_fashion{pkey = Pkey, fashion_list = NewFashionList}
    end.


fashion2list(FashionList, Now) ->
    F = fun({FashionId, Time, Stage, IsUse}) ->
        NewIsUse =
            if IsUse == 1 ->
                if Time > 0 andalso Time < Now -> 0;
                    true -> IsUse
                end;
                true -> IsUse
            end,
        IsEnable = ?IF_ELSE(Time == 0 orelse Time > Now, true, false),
        #fashion{fashion_id = FashionId, time = Time, stage = Stage, is_use = NewIsUse, is_enable = IsEnable}
        end,
    lists:map(F, util:bitstring_to_term(FashionList)).
fashion2string(FashionList) ->
    F = fun(Fashion) ->
        {Fashion#fashion.fashion_id, Fashion#fashion.time, Fashion#fashion.stage, Fashion#fashion.is_use}
        end,
    util:term_to_bitstring(lists:map(F, FashionList)).


ban(PkeyList) ->
    lists:foreach(fun(Pkey) ->
        Sql = io_lib:format("update player_login set status = 1 where pkey = ~w", [Pkey]),
        db:execute(Sql),
        case misc:get_player_process(Pkey) of
            Pid when is_pid(Pid) ->
                player:stop(Pid);
            _ ->
                skip
        end
                  end, PkeyList),

    util:sleep(2000).


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
    PkeyList = key_list(),
    [{ServerNum, PkeyList}].


%% 写入文本
write_to_text(List) ->
    lists:foreach(fun({ServerId, KeyList}) ->
        case KeyList of
            [] -> ok;
            _ ->
                FileName = io_lib:format("../server_~w.txt", [ServerId]),
                {ok, S} = file:open(FileName, write),
                io:format(S, "~w ~n", [KeyList]),
                file:close(S)
        end
                  end, List).