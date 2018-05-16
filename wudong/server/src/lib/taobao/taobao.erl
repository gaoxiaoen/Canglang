%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十一月 2015 10:23
%%%-------------------------------------------------------------------
-module(taobao).
-author("and_me").


-include("taobao.hrl").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
%% gen_server callbacks
-export([
    taobao/2,
    merge_recently_goods/2,
    get_notice_state/1
]).


taobao(Player, Type) ->
    Binfo = lib_dict:get(?PROC_STATUS_TAOBAO_INFO),
    {NeedGold, CostNum, IsBind} = check_money(Player, Type, Binfo),
    {Luck, GoodsList} = gen_tao(IsBind, get_times(Type), Binfo#taobao_info.luck_value, []),
    RecentlyGoods = lists:foldl(fun({G, _}, Out) ->
        Gtype = data_goods:get(G#give_goods.goods_id),
        if Gtype#goods_type.is_rarity > 0 -> [[G#give_goods.goods_id, G#give_goods.num] | Out];
            true -> Out
        end
                                end, [], GoodsList),
    NewBinfo = Binfo#taobao_info{luck_value = Luck, recently_goods = lists:sublist(merge_recently_goods(Binfo#taobao_info.recently_goods, RecentlyGoods), 10)},
    Record = lists:foldl(fun({G, _}, Out) ->
        Gtype = data_goods:get(G#give_goods.goods_id),
        if Gtype#goods_type.is_rarity > 0 ->
            if
                Type =/= 3 ->
                    Msg1 = io_lib:format(t_tv:get(101), [Player#player.nickname, Gtype#goods_type.goods_name]),
                    notice:add_sys_notice(Msg1, 101);
                true ->
                    skip
            end,
            [{Player#player.key, Player#player.nickname, G#give_goods.goods_id} | Out];
            true -> Out
        end
                         end, [], GoodsList),
    case ets:lookup(?ETS_TAOBAO_RECORD, record) of
        [] ->
            ets:insert(?ETS_TAOBAO_RECORD, {record, Record});
        [{record, ORecord}] ->
            ets:insert(?ETS_TAOBAO_RECORD, {record, lists:sublist(Record ++ ORecord, 30)})
    end,
    if
        NeedGold > 0 ->
            target_act:trigger_tar_act(Player, 3, get_times(Type)),
            NewPlayer = money:add_no_bind_gold(Player, -NeedGold, 70, 20704, CostNum);
        true ->
            NewPlayer = Player
    end,
    ?DO_IF(CostNum > 0, goods:subtract_good(Player, [{20704, CostNum}], 70)),
    taobao_util:give_goods(Player, [G || {G, _} <- GoodsList]),
    taobao_load:updata_taobao_info_luck(NewBinfo, Player#player.key),
    lib_dict:put(?PROC_STATUS_TAOBAO_INFO, NewBinfo),
    taobao_rpc:handle(25007, Player, 0),
    taobao_rpc:handle(25004, Player, 0),
    taobao_util:cron_taobao(Player#player.key, Player#player.nickname, Type, NeedGold, util:term_to_bitstring([{G#give_goods.goods_id, G#give_goods.num} || {G, _} <- GoodsList]), util:unixtime()),
    if
        Type == 3 ->
            NameRe = lists:foldl(fun({G, _}, Out) ->
                Gtype = data_goods:get(G#give_goods.goods_id),
                if Gtype#goods_type.is_rarity > 0 ->
                    util:to_list(Gtype#goods_type.goods_name) ++ " " ++ Out;
                    true -> Out
                end end, "", GoodsList),
            Msg2 = io_lib:format(t_tv:get(102), [Player#player.nickname, NameRe]),
            notice:add_sys_notice(Msg2, 102);
        true ->
            ok
    end,
    {ok, NewPlayer, GoodsList}.

gen_tao(_IsBind, N, Luck, GoodsList) when N =< 0 ->
    {Luck, GoodsList};

gen_tao(IsBind, N, Luck, GoodsList) ->
    Storage = ?IF_ELSE(Luck >= 100, 10002, 10001),
    {_, Id} = util:get_weight_item(1, data_taobao:get_probability(Storage)),
    BaseTaobao = data_taobao:get(Id),
    [{GoodsId, Num}] = BaseTaobao#base_taobao.goods_id,
    NewLuck = Luck + BaseTaobao#base_taobao.luck_value,
    NewGoodsList = [{#give_goods{goods_id = GoodsId, num = Num, bind = IsBind}, ?IF_ELSE(Luck >= 100, 1, 0)} | GoodsList],
    gen_tao(IsBind, N - 1, NewLuck, NewGoodsList).

get_times(Type) ->
    case Type of
        1 -> 1;
        2 -> 10;
        3 -> 50
    end.

check_money(Player, Type, TaoBaoInfo) ->
    [Gold, _Bgold] = money:get_gold(Player#player.key),
    NeedNum = get_times(Type),
    BaseTaobaoConfig = data_taobao_config:get(Type),
    NeedMoney = BaseTaobaoConfig#base_taobao_config.gold,
    TaoBaoInfo = lib_dict:get(?PROC_STATUS_TAOBAO_INFO),
    TicketNum = goods_util:get_goods_count(20704),
    if
        NeedNum > TicketNum andalso NeedMoney > Gold ->
            throw({false, 5});
        NeedNum > TicketNum andalso NeedMoney =< Gold ->
            CostNum = 0,
            {NeedMoney, CostNum, ?NO_BIND};
        NeedNum =< TicketNum ->
            NeedGold = 0,
            {NeedGold, NeedNum, ?BIND}
    end.


merge_recently_goods(RecentlyGoods, [[GoodsId, Num] | L]) ->
    merge_recently_goods(merge_recently_goods1([], RecentlyGoods, [GoodsId, Num]), L);

merge_recently_goods(RecentlyGoods, []) ->
    RecentlyGoods.

merge_recently_goods1(HList, [], [GoodsId, Num]) ->
    lists:reverse([[GoodsId, Num] | HList]);

merge_recently_goods1(HList, [[GoodsId, HNum] | L], [GoodsId, Num]) ->
    lists:reverse([[GoodsId, HNum + Num] | HList]) ++ L;

merge_recently_goods1(HList, [[GoodsId, HNum] | L], [NewGoodsId, NewNum]) ->
    merge_recently_goods1([[GoodsId, HNum] | HList], L, [NewGoodsId, NewNum]).


get_notice_state(_Player) ->
    TicketNum = goods_util:get_goods_count(20704),
    ?IF_ELSE(TicketNum > 0, 1, 0).



