%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 九月 2017 13:04
%%%-------------------------------------------------------------------
-module(hotfix3).
-include("common.hrl").
-author("Administrator").
-include("server.hrl").

%% API
-export([
    make_bug_info/0,
    get_bug_list/0
]).



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
                        ?WARNING("rpc get rank fail,node:~s", [Node]),
                        AccIn
                end
                end,
            L = lists:foldl(F, [], Nodes),
            write_to_text(L);
        _ ->
            skip
    end.


-define(BUG_KEY_ID(Key),{bug_key_id,Key}).
%% 统计bug list
get_bug_list() ->
    ServerNum = config:get_server_num(),
    BugList =
    case db:get_all("SELECT pkey,nickname,goods FROM log_act_lucky_turn WHERE opera = 3 AND `time` >= 1505404800 order by `time`") of
        List when is_list(List) ->
            lists:foldl(fun([Pkey, NickName,Goods], AccList) ->
                GoodsList = util:bitstring_to_term(Goods),
                case get(?BUG_KEY_ID(Pkey)) of
                    undefined ->
                        put(?BUG_KEY_ID(Pkey), 1),
                        AccList;
                    _ ->
                        case lists:keytake(Pkey, 1, AccList) of
                            false ->
                                [{Pkey, NickName,GoodsList} | AccList];
                            {value, {Pkey, _, OldGoodsList}, T} ->
                                NewGoods = OldGoodsList ++ GoodsList,
                                [{Pkey, NickName,NewGoods} | T]
                        end
                end
                                  end, [], List);
        _ ->
            []
    end,
    ?PRINT("BugList ~w",[BugList]),
    BugList2 =
    lists:map(fun({Key, NickName,RfGoods}) ->
        RfGoods2 = goods:merge_goods(RfGoods),
        Sql = io_lib:format("select vip_lv from player_state where pkey = ~w",[Key]),
        VipLv = db:get_one(Sql),
        ChargeSql = io_lib:format("SELECT SUM(total_fee) FROM recharge WHERE app_role_id = ~w AND pay_result = 1",[Key]),
        ChargeTotal = db:get_one(ChargeSql),
        {Key, NickName,VipLv,ChargeTotal,RfGoods2}
              end, BugList),
    [{ServerNum,BugList2}].


%% 写入文本
write_to_text(List) ->
    lists:foreach(fun({ServerId, BugPlayerList}) ->
        FileName = io_lib:format("../server_~w.txt", [ServerId]),
        {ok, S} = file:open(FileName, write),
        lists:foreach(fun({Pkey,NickName,VipLv,ChargeTotal,GoodsList}) ->
            io:format(S, "~w      ~s     ~w     ~w      ~w~n", [Pkey,bitstring_to_list(NickName),VipLv,ChargeTotal,GoodsList])
                      end, BugPlayerList),
        file:close(S)
                  end, List).













