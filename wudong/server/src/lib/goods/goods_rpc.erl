%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2015 下午3:55
%%%-------------------------------------------------------------------
-module(goods_rpc).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("equip.hrl").

%% API
-export([handle/3]).

%% 获取玩家背包基础信息
handle(15001, Player, _) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsInfoList = goods_dict:dict_to_list(GoodsSt#st_goods.dict),
    Len = length(GoodsInfoList),
    MaxLen = 1000,
    if Len =< MaxLen ->
        GoodsList = goods_pack:pack_goods_list(GoodsInfoList),
        {ok, Bin} = pt_150:write(15001, {GoodsSt#st_goods.max_cell, GoodsList}),
        server_send:send_to_sid(Player#player.sid, Bin),
        ok;
        true ->
            GoodsList = goods_pack:pack_goods_list(lists:sublist(GoodsInfoList, MaxLen)),
            {ok, Bin} = pt_150:write(15001, {GoodsSt#st_goods.max_cell, GoodsList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            GoodsList1 = lists:sublist(GoodsInfoList, MaxLen + 1, Len),
            goods_pack:pack_send_goods_info(GoodsList1, Player#player.sid),
            ok
    end;

%%使用物品
handle(15004, #player{sid = Sid} = Player, {GoodsKey, Num}) ->
    case catch goods_use:use_goods(Player, GoodsKey, Num) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_150:write(15004, {1}),
            server_send:send_to_sid(Sid, Bin),
            {ok, NewPlayer};
        {false, Res} ->
            {ok, Bin} = pt_150:write(15004, {Res}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end;

%%根据goods_id使用物品使用物品
handle(15018, #player{sid = Sid} = Player, {GoodsId, Num}) ->
    case catch goods_use:use_goods_by_goods_id(Player, util:to_integer(GoodsId), Num) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_150:write(15018, {1}),
            server_send:send_to_sid(Sid, Bin),
            {ok, NewPlayer};
        {false, Res} ->
            {ok, Bin} = pt_150:write(15018, {Res}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end;

%%删除物品
handle(15005, #player{sid = Sid} = Player, {GoodsList}) ->
    case catch goods:sell_goods(Player, GoodsList) of
        {false, Res} ->
            {ok, Bin} = pt_150:write(15005, {Res}),
            server_send:send_to_sid(Sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_150:write(15005, {1}),
            server_send:send_to_sid(Sid, Bin),
            {ok, NewPlayer}
    end;

%%元宝开格子
handle(15007, #player{sid = _Sid} = _Player, {_Cell}) ->
    ok;
%%    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
%%    if
%%        Cell =< GoodsSt#st_goods.max_cell ->
%%            {ok, Bin} = pt_150:write(15005, {5}),
%%            server_send:send_to_sid(Sid, Bin);
%%        true ->
%%            SumGold = lists:sum([begin
%%                                     case data_bag_cell:get(InCell) of
%%                                         {_, NeedGold} ->
%%                                             ok;
%%                                         [] ->
%%                                             ?ERR("InCell ~p ~n", [InCell]),
%%                                             NeedGold = 999999999999999999
%%                                     end,
%%                                     NeedGold
%%                                 end || InCell <- lists:seq(GoodsSt#st_goods.max_cell + 1, Cell)]),
%%            if
%%                SumGold > Player#player.gold + Player#player.bgold ->
%%                    {ok, Bin} = pt_150:write(15005, {4}),
%%                    server_send:send_to_sid(Sid, Bin),
%%                    ok;
%%                true ->
%%                    NewPlayer = money:add_gold(Player, -SumGold, 35, 0, 0),
%%                    NewGoodsSt = GoodsSt#st_goods{max_cell = Cell,
%%                        leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + Cell - GoodsSt#st_goods.max_cell},
%%                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
%%                    goods_load:dbup_bag_cell_num(NewGoodsSt),
%%                    {ok, Bin} = pt_150:write(15005, {1}),
%%                    server_send:send_to_sid(Sid, Bin),
%%                    {ok, Bin1} = pt_150:write(15008, {NewGoodsSt#st_goods.max_cell}),
%%                    server_send:send_to_sid(Sid, Bin1),
%%                    {ok, NewPlayer}
%%            end
%%    end;

%%查询已经开启的背包格子
handle(15008, Player, _) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    {ok, Bin} = pt_150:write(15008, {GoodsSt#st_goods.max_cell}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%礼包物品查询
handle(15009, #player{sid = Sid} = Player, {GoodsId}) ->
    case data_gift_bag:get(GoodsId) of
        [] -> ok;
        BaseGift ->
            List = BaseGift#base_gift.career0 ++ ?IF_ELSE(Player#player.career == 1, BaseGift#base_gift.career1, BaseGift#base_gift.career2),
            Fun = fun({GoodsId1, Num, _Bind, _Ratio}, Out) ->
                [[GoodsId1, Num] | Out]
                  end,
            AllGoodsList = lists:foldl(Fun, [], List),
            GoodsList1 = [[IGoodsId, Num] || {Career, IGoodsId, Num, _} <- BaseGift#base_gift.must_get, Career =:= Player#player.career orelse Career =:= 0],
            {ok, Bin1} = pt_150:write(15009, {GoodsId, GoodsList1, BaseGift#base_gift.random_num, AllGoodsList}),
            server_send:send_to_sid(Sid, Bin1),
            ok
    end;


%%查询物品详情
handle(15010, Player, {GoodsList}) ->
    Fun = fun(GoodsId, {Out, UdefIds}) ->
        case data_goods:get(GoodsId) of
            [] ->
                {Out, [GoodsId | UdefIds]};
            GoodsType ->
                case GoodsType#goods_type.special_param_list of
                    [A] ->
                        SpecialParamList = util:term_to_string({A});
                    Other ->
                        SpecialParamList = util:term_to_string(Other)
                end,
                Attr_list = [[util:term_to_string(T), V] || {T, V} <- GoodsType#goods_type.attr_list],
                NewGoodsType = [
                    GoodsType#goods_type.goods_id,
                    GoodsType#goods_type.display,
                    GoodsType#goods_type.goods_icon,
                    util:to_list(GoodsType#goods_type.goods_name),
                    util:to_list(data_goods:get_describe_by_id(GoodsId)),
                    GoodsType#goods_type.type,
                    GoodsType#goods_type.subtype,
                    GoodsType#goods_type.is_rarity,
                    GoodsType#goods_type.color,
                    GoodsType#goods_type.sex,
                    GoodsType#goods_type.career,
                    GoodsType#goods_type.need_lv,
                    GoodsType#goods_type.equip_lv,
                    0,
                    0,
                    GoodsType#goods_type.max_overlap,
                    GoodsType#goods_type.use_panel,
                    GoodsType#goods_type.sell_price,
                    GoodsType#goods_type.expire_time,
                    SpecialParamList,
                    GoodsType#goods_type.max_wash_hole,
                    GoodsType#goods_type.max_wash_hole,
                    Attr_list
                ],
                {[NewGoodsType | Out], UdefIds}
        end
          end,
    Data = lists:foldl(Fun, {[], []}, GoodsList),
    {ok, Bin} = pt_150:write(15010, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取玩家仓库基础信息
handle(15012, Player, _) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsInfoList = goods_dict:dict_to_list(GoodsSt#st_goods.dict),
    GoodsList = GoodsList = goods_pack:pack_whouse_goods_list(GoodsInfoList),
    %?PRINT("GoodsInfoList ~p  ~n",[[GoodsInfo#goods.key||GoodsInfo<-GoodsInfoList]]),
    {ok, Bin} = pt_150:write(15012, {GoodsSt#st_goods.warehouse_max_cell, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%仓库存入物品
handle(15014, #player{sid = Sid} = Player, {Key, Num}) ->
    case catch goods_warehouse:store_goods(Player, [{Key, Num}]) of
        {false, Res} ->
            {ok, Bin} = pt_150:write(15014, {Res}),
            server_send:send_to_sid(Sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_150:write(15005, {1}),
            server_send:send_to_sid(Sid, Bin),
            {ok, NewPlayer}
    end;

%%仓库取出物品
handle(15015, #player{sid = Sid} = Player, {Gkey, Num}) ->
    case catch goods_warehouse:fetch_good(Player, Gkey, Num) of
        {false, Res} ->
            {ok, Bin} = pt_150:write(15015, {Res}),
            server_send:send_to_sid(Sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_150:write(15005, {1}),
            server_send:send_to_sid(Sid, Bin),
            {ok, NewPlayer}
    end;

%%元宝开仓库格子
handle(15017, #player{sid = Sid} = Player, {Cell}) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    if
        Cell =< GoodsSt#st_goods.warehouse_max_cell ->
            {ok, Bin} = pt_150:write(15017, {5, 0}),
            server_send:send_to_sid(Sid, Bin),
            ok;
        true ->
            GoodsNum = goods_util:get_goods_count(20705),
            NeedNum = Cell - GoodsSt#st_goods.warehouse_max_cell,
            if
                NeedNum =< GoodsNum ->
                    {ok, GoodsSt1} = goods:subtract_good(Player, [{20705, NeedNum}], 4566),
                    NewGoodsSt = GoodsSt1#st_goods{warehouse_max_cell = Cell,
                        warehouse_leftover_cell_num = GoodsSt1#st_goods.warehouse_leftover_cell_num + Cell - GoodsSt1#st_goods.warehouse_max_cell},
                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                    goods_load:dbup_bag_cell_num(NewGoodsSt),
                    {ok, Bin} = pt_150:write(15017, {1, Cell}),
                    server_send:send_to_sid(Sid, Bin),
                    ok;
                true ->
                    SumGold = lists:sum([begin case data_warehouse_cell:get(InCell) of
                                                   [] -> ?ERR("InCell ~p ~n", [InCell]), 999999999999999999;
                                                   NeedGold -> NeedGold
                                               end
                                         end || InCell <- lists:seq(GoodsSt#st_goods.warehouse_max_cell + 1 + GoodsNum, Cell)]),
                    [Gold, BGold] = money:get_gold(Player#player.key),
                    if
                        SumGold > Gold + BGold ->
                            {ok, Bin} = pt_150:write(15017, {4, 0}),
                            server_send:send_to_sid(Sid, Bin),
                            ok;
                        true ->
                            if GoodsNum > 0 -> {ok, GoodsSt1} = goods:subtract_good(Player, [{20705, GoodsNum}], 4566);
                                true -> GoodsSt1 = GoodsSt
                            end,
                            NewPlayer = money:add_gold(Player, -SumGold, 35, 0, 0),
                            NewGoodsSt = GoodsSt1#st_goods{warehouse_max_cell = Cell,
                                warehouse_leftover_cell_num = GoodsSt1#st_goods.warehouse_leftover_cell_num + Cell - GoodsSt1#st_goods.warehouse_max_cell},
                            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                            goods_load:dbup_bag_cell_num(NewGoodsSt),
                            {ok, Bin} = pt_150:write(15017, {1, Cell}),
                            server_send:send_to_sid(Sid, Bin),
                            {ok, NewPlayer}
                    end
            end
    end;


%%查看装备详细信息
handle(15020, #player{sid = Sid}, {Gkey}) ->
    CacheKey = {goods_info, Gkey},
    case cache:get(CacheKey) of
        [] ->
            case db:get_row(io_lib:format("select pkey, goods_id,star,stren,wash_attrs,gemstone_groove,god_forging,color,sex,combat_power,fix_attrs,random_attrs,xian_wash_attrs from goods where gkey = ~p", [Gkey])) of
                [] ->
                    {ok, Bin} = pt_150:write(15020, {6, 0, 0, 0, 0, 0, [], [], [], [], [], 0, 0, 0, [], [], [], []}),
                    server_send:send_to_sid(Sid, Bin),
                    ok;
                [Pkey, GoodsId, Star, Stren, Wash_attrs, Gemstone_groove, GodForging, Color, Sex, Combat_power, Fix_attrs, Random_attrs, Xian_wash_attrs] ->
                    MagicAtt = goods_load:get_magic_info(GoodsId, Pkey),
                    SoulAtt = goods_load:get_soul_list(GoodsId, Pkey),
                    RefineAtt = goods_load:get_refine_info(GoodsId, Pkey),
                    BaseAttr = [[attribute_util:attr_tans_client(K), V] || {K, V} <- util:bitstring_to_term(Wash_attrs)],
                    FixAttrList = [[attribute_util:attr_tans_client(K), V] || {K, V} <- util:bitstring_to_term(Fix_attrs)],
                    RandomList = [[attribute_util:attr_tans_client(K), V] || {K, V} <- util:bitstring_to_term(Random_attrs)],
                    XianList = [[attribute_util:attr_tans_client(K), V, C] || {K, V, C} <- util:bitstring_to_term(Xian_wash_attrs)],
                    StoneInfo = [[K, V] || {K, V} <- util:bitstring_to_term(Gemstone_groove)],
                    {ok, Bin} = pt_150:write(15020, {1, GoodsId, Stren, Star, GodForging, BaseAttr, RefineAtt, StoneInfo, MagicAtt, SoulAtt, Color, Sex, Combat_power, FixAttrList, RandomList, XianList, []}),
                    cache:set(CacheKey, Bin, ?FIFTEEN_MIN_SECONDS),
                    server_send:send_to_sid(Sid, Bin),
                    ok
            end;
        Bin ->
            server_send:send_to_sid(Sid, Bin),
            ok
    end;


%%自动购买银币
handle(15021, #player{sid = Sid, key = Pkey} = Player, {N}) when N > 0 ->
    [Gold, _Bgold] = money:get_gold(Pkey),
    NeedGold = N * 29,
    if
        Gold < NeedGold ->
            {ok, Bin} = pt_150:write(15021, {4}),
            server_send:send_to_sid(Sid, Bin),
            ok;
        true ->
            Player1 = money:add_no_bind_gold(Player, -NeedGold, 188, 10101, N),
            Player2 = money:add_coin(Player1, 100000 * N, 188, 10101, N),
            {ok, Player2}
    end;

handle(15022, Player, {GoodsId, Num, PkeyList}) ->
    NewPlayer = guild_goods:use_goods_with_target(Player, GoodsId, Num, PkeyList),
    {ok, NewPlayer};

handle(15023, Player, {GoodsKey, Num}) ->
    {Ret, NewPlayer} = goods:goods_split(Player, GoodsKey, Num),
    {ok, Bin} = pt_150:write(15023, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 锁定物品
handle(15026, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = goods:goods_lock(Player, GoodsKey),
    {ok, Bin} = pt_150:write(15026, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 锁定物品
handle(15027, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = goods:goods_unlock(Player, GoodsKey),
    {ok, Bin} = pt_150:write(15027, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%
handle(15028, Player, {GoodsKey}) ->
    goods:goods_attr_info(Player, GoodsKey),
    ok;

%%使用物品
handle(15029, #player{sid = Sid} = Player, {GoodsKey, Num, SGoodList}) ->
    case catch goods_use:use_goods(Player, GoodsKey, Num, SGoodList) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_150:write(15029, {1}),
            server_send:send_to_sid(Sid, Bin),
            {ok, NewPlayer};
        {false, Res} ->
            {ok, Bin} = pt_150:write(15029, {Res}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end;


%%批量使用物品
handle(15031, #player{sid = Sid} = Player, {GoodsId, Num, SGoodList}) ->
    case catch goods_use:use_goods_by_goods_id(Player, GoodsId, Num, SGoodList) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_150:write(15031, {1}),
            server_send:send_to_sid(Sid, Bin),
            {ok, NewPlayer};
        {false, Res} ->
            {ok, Bin} = pt_150:write(15031, {Res}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end;

handle(15032, Player, {Location}) ->
    goods_clear_up:clear_up_bag(Player, Location),
    {ok, Bin} = pt_150:write(15032, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;




handle(_cmd, _Player, _Data) ->
    ?PRINT("handle ~p ~n", [{_cmd, _Data}]),
    ok.
