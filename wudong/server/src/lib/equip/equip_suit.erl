%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 装备套装
%%% @end
%%% Created : 20. 十一月 2017 10:28
%%%-------------------------------------------------------------------
-module(equip_suit).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("equip.hrl").

%% API
-export([
    init/1,
    get_attr/0,
    re_cacl_attr/0,
    get_ids/0,
    cacl_attr_by_ids/1,
    act/2
]).

init(#player{key = Pkey} = Player) ->
    Sql = io_lib:format("select act_ids from player_equip_suit where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActIdsBin] ->
            ActIds = util:bitstring_to_term(ActIdsBin),
            Attr = attribute_util:sum_attribute(cacl_attr_by_ids(ActIds)),
            StEquipSuit =
                #st_equip_suit{
                    pkey = Pkey,
                    attr = Attr,
                    act_ids = ActIds
                },
            lib_dict:put(?PROC_STATUS_EQUIP_SUIT, StEquipSuit);
        _ ->
            StEquipSuit = #st_equip_suit{pkey = Pkey},
            lib_dict:put(?PROC_STATUS_EQUIP_SUIT, StEquipSuit)
    end,
    Player.

get_attr() ->
    St = lib_dict:get(?PROC_STATUS_EQUIP_SUIT),
    St#st_equip_suit.attr.

get_ids() ->
    St = lib_dict:get(?PROC_STATUS_EQUIP_SUIT),
    St#st_equip_suit.act_ids.

re_cacl_attr() ->
    ok.

get_by_color(2, _Star) ->
    1;
get_by_color(3, _Star) ->
    1;
get_by_color(4, _Star) ->
    1;
get_by_color(5, Star) ->
    max(1, Star - 3);
get_by_color(_Color, _Star) ->
    1.

check_act(EquipList, Id) ->
    case data_equip_suit:get(Id) of
        [] -> false;
        Base ->
            check_act_by_type(EquipList, Base, Base#base_equip_suit.type)
    end.

%% 品质套装
check_act_by_type(EquipList, Base, 1) ->
    #base_equip_suit{
        level = Level,
        has_num = HasNum
    } = Base,
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    F2 = fun(#weared_equip{goods_key = GoodsKey}) ->
        Equip = goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict),
        if
            Equip#goods.level >= Level -> [1];
            true -> []
        end
    end,
    HasList = lists:flatmap(F2, EquipList),
    if
        length(HasList) >= HasNum -> true;
        true -> false
    end;

%% 等级套装
check_act_by_type(EquipList, Base, 2) ->
    #base_equip_suit{
        color = Color,
        stage = Stage,
        has_num = HasNum
    } = Base,
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    F2 = fun(#weared_equip{goods_id = GoodsId, goods_key = GoodsKey}) ->
        Equip = goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict),
        #goods_type{color = Color2} = data_goods:get(GoodsId),
        Stage2 = get_by_color(Color2, Equip#goods.star),
        if
            Color =< Color2 andalso Stage =< Stage2 -> [1];
            true -> []
        end
    end,
    HasList = lists:flatmap(F2, EquipList),
    if
        length(HasList) >= HasNum -> true;
        true -> false
    end;

check_act_by_type(_EquipList, _Base, Type) ->
    ?ERR("equip_suit type err !! ~p~n", [Type]),
    false.



cacl_attr_by_ids(Ids) ->
    F1 = fun(Id) ->
        case data_equip_suit:get(Id) of
            [] -> [];
            #base_equip_suit{attrs = Attr} ->
                [attribute_util:make_attribute_by_key_val_list(Attr)]
        end
    end,
    lists:flatmap(F1, Ids).

act(Player, ActId) ->
    St = lib_dict:get(?PROC_STATUS_EQUIP_SUIT),
    #st_equip_suit{act_ids = ActIds} = St,
    case lists:member(ActId, ActIds) of
        true -> %% 已经激活
            {55, Player};
        false ->
            GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
            case check_act(GoodsSt#st_goods.weared_equip, ActId) of
                false -> {54, Player}; %% 不符合条件
                true ->
                    NewActIds = [ActId | ActIds],
                    NewSt =
                        St#st_equip_suit{
                            act_ids = NewActIds,
                            attr = attribute_util:sum_attribute(cacl_attr_by_ids(NewActIds))
                        },
                    lib_dict:put(?PROC_STATUS_EQUIP_SUIT, NewSt),
                    db_up(NewSt),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    {1, NewPlayer}
            end
    end.

db_up(NewSt) ->
    #st_equip_suit{act_ids = ActIds, pkey = Pkey} = NewSt,
    Sql = io_lib:format("replace into player_equip_suit set pkey=~p,act_ids='~s'", [Pkey, util:term_to_bitstring(ActIds)]),
    db:execute(Sql),
    ok.