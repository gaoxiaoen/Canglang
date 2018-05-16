%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2018 10:50
%%%-------------------------------------------------------------------
-module(god_soul).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("godness.hrl").

%% API
-export([
    put_on/4, %% 穿戴神魂
    tunsi/3 %% 吞噬
]).

%% 上阵
put_on(Player, _Pos, GodnessKey, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {0, Player}; %% 系统物品不存在
        GodSoul ->
            case check_put_on(GodSoul, GoodsSt#st_goods.weared_god_soul) of
                {false, Code} ->
                    {Code, Player};
                true ->
                    GoodsType = data_goods:get(GodSoul#goods.goods_id),
                    Pos = get_pos(GoodsType#goods_type.subtype),
                    F = fun(#weared_god_soul{pos = Pos0, wear_key = WearKey0} = WearGodSoul) ->
                        ?IF_ELSE(Pos0 == Pos andalso GodnessKey == WearKey0, [WearGodSoul], [])
                    end,
                    case lists:flatmap(F, GoodsSt#st_goods.weared_god_soul) of
                        [] -> %% 新穿上神魂
                            NewGodSoul = GodSoul#goods{
                                cell = Pos,
                                wear_key = GodnessKey,
                                location = ?GOODS_LOCATION_BODY_GOD_SOUL
                            },
                            goods_load:dbup_goods_cell_location(NewGodSoul),
                            NewGoodsDict = goods_dict:update_goods(NewGodSoul, GoodsSt#st_goods.dict),
                            goods_pack:pack_send_goods_info([NewGodSoul], GoodsSt#st_goods.sid),
                            log(Player,GodnessKey,NewGodSoul),
                            GoodsSt1 = GoodsSt#st_goods{
                                leftgod_soul_cell_num = GoodsSt#st_goods.leftgod_soul_cell_num + 1,
                                dict = NewGoodsDict
                            };
                        [OldWearedGodSoul] -> %% 替换旧的神魂
                            OldGodSoul = goods_util:get_goods(OldWearedGodSoul#weared_god_soul.goods_key, GoodsSt#st_goods.dict),
                            OldGodSoul2 = OldGodSoul#goods{
                                cell = 0,
                                wear_key = 0,
                                location = ?GOODS_LOCATION_GOD_SOUL
                            },
                            goods_load:dbup_goods_cell_location(OldGodSoul2),
                            NewGodSoul = GodSoul#goods{
                                cell = Pos,
                                wear_key = GodnessKey,
                                location = ?GOODS_LOCATION_BODY_GOD_SOUL
                            },
                            GoodsSt1 = goods_dict:update_goods([OldGodSoul2, NewGodSoul], GoodsSt),
                            goods_load:dbup_goods_cell_location(NewGodSoul),
                            log(Player,GodnessKey,OldGodSoul2),
                            log(Player,GodnessKey,NewGodSoul),
                            goods_pack:pack_send_goods_info([OldGodSoul2, NewGodSoul], GoodsSt#st_goods.sid)
                    end,
                    NewGoodsSt = godness_attr:god_soul_change_recalc_attribute(GoodsSt1, NewGodSoul),
                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                    godness:recalc_godness_suit(GodnessKey),
                    StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
                    Godness = lists:keyfind(GodnessKey, #godness.key, StGodness#st_godness.godness_list),
                    NGodness = godness_attr:cacl_singleton_godness_attribute(Godness),
                    StGodness00 =
                        StGodness#st_godness{
                            godness_list = lists:keyreplace(GodnessKey,#godness.key,StGodness#st_godness.godness_list,NGodness)
                        },
                    NStGodness = godness_attr:calc_godness_all_attribute(StGodness00),
                    NewStGodness = godness:update_skill(NStGodness),
                    ?DEBUG("NewStGodness:~p", [NewStGodness]),
                    lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    NewGodness = lists:keyfind(GodnessKey, #godness.key, NewStGodness#st_godness.godness_list),
                    godness:send_godness_to_client(NewPlayer#player.sid, NewGodness),
                    {1, NewPlayer#player{
                            godness_skill = NewStGodness#st_godness.skill_list,
                            passive_skill = NewStGodness#st_godness.godsoul_skill_list ++ Player#player.passive_skill
                        }}
            end
    end.

log(Player, GodnessKey, Godsoul) ->
    Sql = io_lib:format("insert into log_godsoul_put_on set pkey=~p,goods_key=~p,goods_id=~p,pos=~p,godness_key=~p,time=~p",
        [Player#player.key, Godsoul#goods.key, Godsoul#goods.goods_id,Godsoul#goods.cell,GodnessKey,util:unixtime()]),
    log_proc:log(Sql).

check_put_on(GodSoul, _WearGodSoulList) ->
    GoodsTypeInfo = data_goods:get(GodSoul#goods.goods_id),
    if
        GoodsTypeInfo#goods_type.type /= ?GOODS_TYPE_GOD_SOUL -> {false, 7}; %% 非神魂
        GodSoul#goods.cell > 0 -> {false, 8}; %% 该神魂已经配戴
        true -> true
    end.

get_pos(?GOODS_SUBTYPE_GOD_SOUL_1) -> 1;
get_pos(?GOODS_SUBTYPE_GOD_SOUL_2) -> 2;
get_pos(?GOODS_SUBTYPE_GOD_SOUL_3) -> 3;
get_pos(?GOODS_SUBTYPE_GOD_SOUL_4) -> 4;
get_pos(?GOODS_SUBTYPE_GOD_SOUL_5) -> 5;
get_pos(?GOODS_SUBTYPE_GOD_SOUL_6) -> 6.

tunsi(Player, 0, _) -> {0, Player};
tunsi(Player, _, []) -> {0, Player};

tunsi(Player, GoodsKey, TunsiGoodsKeyList) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {0, Player}; %% 系统物品不存在
        GodSoul ->
            case GodSoul#goods.wear_key == 0 of
                true -> {0, Player};
                false ->
                    F = fun(TunsiGoodsKey) ->
                        case catch goods_util:get_goods(TunsiGoodsKey, GoodsSt#st_goods.dict) of
                            {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} -> [];
                            #goods{location = Location, cell = Cell} = TunsiGoods ->
                                if
                                    Location == ?GOODS_LOCATION_GOD_SOUL orelse Cell == 0 -> [TunsiGoods];
                                    TunsiGoodsKey == GoodsKey -> [];
                                    true -> []
                                end
                        end
                    end,
                    case lists:flatmap(F, TunsiGoodsKeyList) of
                        [] ->
                            {0, Player};
                        TunsiGoodsList ->
                            tunsi(Player, GodSoul, TunsiGoodsList, 0, [])
                    end
            end
    end.

tunsi(Player, GodSoul, [], AddExp, DelGoodsList) ->
    goods_util:reduce_goods_key_list(Player,[{Goods#goods.key, 1} || Goods <- DelGoodsList],747),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    NGodSoul = re_cacl_lv(GodSoul, AddExp),
    NewGodSoul = NGodSoul#goods{god_soul_attr = attribute_util:make_attribute_to_key_val(godness_attr:calc_singleton_god_soul_attribute(NGodSoul))},
    goods_load:dbup_goods_lv_exp(NewGodSoul),
    goods_pack:pack_send_goods_info([NewGodSoul], GoodsSt#st_goods.sid),
    NewGoodsSt00 = goods_dict:update_goods([NewGodSoul], GoodsSt),
    NewGoodsSt = godness_attr:god_soul_change_recalc_attribute(NewGoodsSt00, NewGodSoul),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
    StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
    NewStGodness = godness_attr:calc_godness_all_attribute(StGodness),
    lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness),
    NewPlayer = player_util:count_player_attribute(Player, true),
    Godness = lists:keyfind(GodSoul#goods.wear_key, #godness.key, NewStGodness#st_godness.godness_list),
    godness:send_godness_to_client(NewPlayer#player.sid, Godness),
    F = fun(DelGodsoul) ->
        Sql = io_lib:format("insert into log_godsoul_tunsi set pkey=~p,goods_key=~p,goods_id=~p,lv=~p,exp=~p,time=~p",
            [Player#player.key,GodSoul#goods.key,DelGodsoul#goods.goods_id,DelGodsoul#goods.goods_lv,DelGodsoul#goods.exp,util:unixtime()]),
        log_proc:log(Sql)
    end,
    lists:map(F, DelGoodsList),
    Sql99 = io_lib:format("insert into log_godsoul_uplv set pkey=~p,goods_key=~p,goods_id=~p,befor_lv=~p,befor_exp=~p,after_lv=~p,after_exp=~p,time=~p",
        [Player#player.key,GodSoul#goods.key,GodSoul#goods.goods_id,GodSoul#goods.goods_lv,GodSoul#goods.exp, NewGodSoul#goods.goods_lv,NewGodSoul#goods.exp,util:unixtime()]),
    log_proc:log(Sql99),
    {1, NewPlayer};

tunsi(Player, GodSoul, [Goods | TunsiGoodsList], AccExp, DelGoodsList) ->
    #goods{goods_id = GoodsId, goods_lv = GoodsLv, exp = Exp} = Goods,
    #goods_type{special_param_list = InitExp} = data_goods:get(GoodsId),
    if
        GoodsLv =< 1 -> AddExp = InitExp+Exp;
        true ->
            F = fun(Lv) ->
                data_god_soul_uplv:get(Lv)
            end,
            AddExp = InitExp+Exp+lists:sum(lists:map(F, lists:seq(1, GoodsLv-1)))
    end,
    tunsi(Player, GodSoul, TunsiGoodsList, AccExp+AddExp, [Goods | DelGoodsList]).

re_cacl_lv(GodSoul, 0) -> GodSoul;
re_cacl_lv(GodSoul, AddExp) ->
    #goods{goods_lv = GoodsLv, exp = Exp} = GodSoul,
    NeedExp = data_god_soul_uplv:get(GoodsLv),
    if
        AddExp + Exp < NeedExp -> GodSoul#goods{exp = AddExp+Exp};
        true ->
            re_cacl_lv(GodSoul#goods{goods_lv = GoodsLv+1, exp = 0}, AddExp + Exp - NeedExp)
    end.
