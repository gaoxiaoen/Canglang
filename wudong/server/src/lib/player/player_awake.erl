%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 天命觉醒
%%% @end
%%% Created : 21. 三月 2018 下午2:03
%%%-------------------------------------------------------------------
-module(player_awake).
-author("luobaqun").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("awake.hrl").
-include("goods.hrl").

-define(LIMIT_LV, 1).  %% 等级限制
-define(EQUIP_SUIT, 2). %% 套装等级
-define(FEIXIAN_LV, 3). %% 飞仙等级
-define(EQUIP_SUIT_LV, 4). %% 套装阶级
-define(EXP_GOODS_ID, 10108).%%经验物品id
-define(GOLD_GOODS_ID, 10199).%%元宝物品id
-define(BGOLD_GOODS_ID, 10106).%%绑定元宝物品id
%% API
-export([
    get_info/1,
    init/1,
    up_awake/1,
    up_type_awake/1,
    get_attribute/0,
    get_equip_strength_lv/0,
    check_up_type_awake/1,
    dbup_player_awake/1]).

init(Player) ->
    St = dbget_player_awake(Player),
    Type = St#st_awake.type,
    Cell = St#st_awake.cell,
    lib_dict:put(?PROC_STATUS_AWAKE, St#st_awake{attr =attribute_util:make_attribute_by_key_val_list(get_base_attr(Type,Cell) ++  get_awake_attr(Type,Cell))}),
    Player.

get_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_AWAKE),
    Type = St#st_awake.type,
    Cell = St#st_awake.cell,
    AwakeLimit =
        case data_awake:get(Type + 1, max(1, Cell)) of
            [] -> [];
            Base ->
                get_awake_limit_info(Player, Base#base_awake.awake_limit)
        end,
    F1 = fun(Cell0,{LaseBase0,AwakeList0}) ->
        case data_awake:get(Type + 1, Cell0) of
            [] -> [];
            Base0 ->
               AttrList =
                   case LaseBase0 of
                     [] -> [[attribute_util:attr_tans_client(K), V] || {K, V} <- Base0#base_awake.attr];
                    _ ->
                        F2 = fun({Key,Val})->
                            case lists:keyfind(Key,1,LaseBase0#base_awake.attr) of
                                 false ->[{Key,Val}];
                                {Key,Val0}->
                                    if
                                        Val - Val0 > 0-> [{Key, Val - Val0 }];
                                        true ->[]
                                    end
                            end
                            end,
                        [[attribute_util:attr_tans_client(K), V] || {K, V} <-  lists:flatmap(F2,Base0#base_awake.attr)]
                end,
                {
                    Base0,
                    [[
                    Base0#base_awake.cell,
                    [tuple_to_list(X) || X <- Base0#base_awake.up_limit1],
                    [tuple_to_list(X) || X <- Base0#base_awake.up_limit2],
                        AttrList]] ++ AwakeList0
                }
        end
    end,
    LaseBase = if
                   Type == 0 -> [];
                   true ->
                      data_awake:get(Type, lists:max(data_awake:get_all_by_type(Type)))
               end,
    {_,AwakeList} = lists:foldl(F1,{LaseBase,[]} ,data_awake:get_all_by_type(Type + 1)),
    {St#st_awake.type, St#st_awake.cell, AwakeLimit, AwakeList}.

get_max_type() ->
    case data_awake:get_all_type() of
        [] -> 0;
        Types -> lists:max(Types)
    end.

get_equip_suit_lv() ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    EquipList = GoodsSt#st_goods.weared_equip,
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    F2 = fun(#weared_equip{goods_key = GoodsKey}) ->
        Equip = goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict),
        Equip#goods.level
    end,
    case lists:map(F2, EquipList) of
        [] -> 0;
        HasList ->
            lists:min(HasList)
    end.


get_equip_strength_lv() ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    EquipList = GoodsSt#st_goods.weared_equip,
    F2 = fun(#weared_equip{goods_key = GoodsKey}) ->
        Equip = goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict),
        [max(Equip#goods.star-3,0)]
    end,
    HasList = lists:flatmap(F2, EquipList),
    case HasList of
         [] ->0;
        _ -> lists:min(HasList)
    end.

%% 激活
up_awake(Player) ->
    St = lib_dict:get(?PROC_STATUS_AWAKE),
    MaxType = get_max_type(),
    if
        St#st_awake.type >= MaxType -> {14, Player};
        true ->
            {NewType, NewCell} = get_next_type(St#st_awake.type, St#st_awake.cell),
            MaxCell = lists:max(data_awake:get_all_by_type(St#st_awake.type + 1)),
            if
                St#st_awake.cell >= MaxCell ->%% 觉醒
                    {17, Player};
                true -> %%激活
                    case data_awake:get(St#st_awake.type + 1, St#st_awake.cell + 1) of
                        [] -> {0, Player};
                        #base_awake{up_limit1 = UpLimit1, up_limit2 = UpLimit2} ->
                            case check_up_limit(Player, UpLimit1) of
                                true ->
                                    NewSt = St#st_awake{type = NewType, cell = NewCell},
                                    lib_dict:put(?PROC_STATUS_AWAKE, NewSt#st_awake{attr =  attribute_util:make_attribute_by_key_val_list(get_base_attr(NewType,NewCell) ++ get_awake_attr(NewType,NewCell))}),
                                    dbup_player_awake(NewSt),
                                    NewPlayer = subtract_good(Player, UpLimit1),
                                    NewPlayer1 = player_util:count_player_attribute(NewPlayer, true),
                                    {1, NewPlayer1};
                                false ->
                                    case check_up_limit(Player, UpLimit2) of
                                        true ->
                                            NewSt = St#st_awake{type = NewType, cell = NewCell},
                                            lib_dict:put(?PROC_STATUS_AWAKE, NewSt#st_awake{attr =  attribute_util:make_attribute_by_key_val_list(get_base_attr(NewType,NewCell) ++ get_awake_attr(NewType,NewCell))}),
                                            dbup_player_awake(NewSt),
                                            NewPlayer = subtract_good(Player, UpLimit2),
                                            NewPlayer1 = player_util:count_player_attribute(NewPlayer, true),
                                            {1, NewPlayer1};
                                        false ->
                                            {15, Player}
                                    end
                            end
                    end
            end
    end.

%% 觉醒
up_type_awake(Player) ->
    case check_up_type_awake(Player) of
        {Res,NewPlayer} ->{Res,NewPlayer};
        ok ->
            St = lib_dict:get(?PROC_STATUS_AWAKE),
            {NewType, NewCell} = get_next_type(St#st_awake.type, St#st_awake.cell),
            NewSt = St#st_awake{type = NewType, cell = NewCell},
            lib_dict:put(?PROC_STATUS_AWAKE, NewSt#st_awake{attr =  attribute_util:make_attribute_by_key_val_list(get_base_attr(NewType,NewCell) ++ get_awake_attr(NewType,NewCell))}),
            dbup_player_awake(NewSt),
            StCareer = lib_dict:get(?PROC_STATUS_TASK_CHANGE_CAREER),
            NewPlayer1 = Player#player{new_career = StCareer#st_change_career.new_career + NewSt#st_awake.type},
            player_load:dbup_player_new_career(NewPlayer1),
            {ok, Bin} = pt_130:write(13001, player_pack:trans13001(NewPlayer1)),
            server_send:send_to_sid(Player#player.sid, Bin),
            NewPlayer2 = player_util:count_player_attribute(NewPlayer1, true),
            activity:get_notice(NewPlayer2, [147], true),
            {1, NewPlayer2}
    end.

check_up_type_awake(Player)->
    St = lib_dict:get(?PROC_STATUS_AWAKE),
    MaxType = get_max_type(),
    if
        St#st_awake.type >= MaxType -> {14, Player};
        true ->
            MaxCell = lists:max(data_awake:get_all_by_type(St#st_awake.type + 1)),
            if
                St#st_awake.cell == MaxCell ->%% 觉醒
                    case data_awake:get(St#st_awake.type + 1, St#st_awake.cell) of
                        [] -> {0, Player};
                        #base_awake{awake_limit = AwakeLimit} ->
                            AwakeLimitInfo = get_awake_limit_info(Player, AwakeLimit),
                            case [1 || [_, Now, Limit] <- AwakeLimitInfo, Now < Limit] of
                                [] -> %% 全部满足
                                    ok;
                                _ ->
                                    {16, Player}
                            end
                    end;
                true->
                    {0,Player}
            end
    end.


get_next_type(Type, Cell) ->
    MaxCell = lists:max(data_awake:get_all_by_type(Type + 1)),
    NewCell = ?IF_ELSE(Cell >= MaxCell, 0, Cell + 1),
    NewType = ?IF_ELSE(Cell < MaxCell, Type, Type + 1),
    {NewType, NewCell}.

check_up_limit(Player, UpLimit) ->
    F = fun({GoodsId, GoodsNum}) ->
        if
            GoodsId == ?EXP_GOODS_ID ->
                if
                    Player#player.exp >= GoodsNum -> true;
                    true -> false
                end;
            GoodsId == ?GOLD_GOODS_ID ->
                money:is_enough(Player,GoodsNum,gold);
            GoodsId == ?BGOLD_GOODS_ID ->
                money:is_enough(Player,GoodsNum,bgold);
            true ->
                Count = goods_util:get_goods_count(GoodsId),
                if
                    Count >= GoodsNum -> true;
                    true -> false
                end
        end
    end,
    lists:all(F, UpLimit).

get_awake_limit_info(Player, AwakeLimit) ->
    F = fun({Key, Val}) ->
        case Key of
            lv -> [[?LIMIT_LV, Player#player.lv, Val]];
            equip_suit -> [[?EQUIP_SUIT, get_equip_suit_lv(), Val]];
            feixian -> [[?FEIXIAN_LV, Player#player.xian_stage, Val]];
            equip_suit_lv -> [[?EQUIP_SUIT_LV,get_equip_strength_lv(), Val]];
            Other ->
                ?ERR("Other ~p~n", [Other]),
                []
        end
    end,
    lists:flatmap(F, AwakeLimit).


dbget_player_awake(#player{key = Pkey} = Player) ->
    NewSt = #st_awake{pkey = Player#player.key},
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select type,cell from player_awake where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [Type, Cell] ->
                    #st_awake{
                        pkey = Pkey,
                        type = Type,
                        cell = Cell
                    }
            end
    end.

dbup_player_awake(St) ->
    #st_awake{
        pkey = Pkey,
        type = Type, %%
        cell = Cell
    } = St,
    Sql = io_lib:format("replace into player_awake set pkey=~p,type=~p,cell=~p",
        [Pkey, Type, Cell]),
    db:execute(Sql),
    ok.

subtract_good(Player, List) ->
    F = fun({GoodsId, GoodsNum}, Player0) ->
        if
            GoodsId == ?EXP_GOODS_ID ->
                Player0#player{exp = max(0, Player0#player.exp - GoodsNum)};
            GoodsId == ?GOLD_GOODS_ID ->
                money:add_no_bind_gold(Player0,-GoodsNum,355,0,0);
            GoodsId == ?BGOLD_GOODS_ID ->
                money:add_bind_gold(Player0,-GoodsNum,355,0,0);
            true ->
                goods:subtract_good(Player0, [{GoodsId, GoodsNum}], 355),
                Player0
        end
    end,
    NewPlayer = lists:foldl(F, Player, List),
    NewPlayer.

get_attribute() ->
    St = lib_dict:get(?PROC_STATUS_AWAKE),
    St#st_awake.attr.

get_base_attr(Type,Cell) ->
    if
        Type == 0 andalso Cell ==0 -> [];
        true ->
            MaxType = lists:max(data_awake:get_all_type()),
            MaxCell = lists:max(data_awake:get_all_by_type(min(Type + 1, MaxType))),
            LaseCell = (Cell - 1 + MaxCell) rem MaxCell + 1,
            case data_awake:get(min(Type + 1, MaxType), LaseCell) of
                [] -> [];
                Base -> Base#base_awake.attr
            end
    end.

get_awake_attr(Type,Cell) ->
    if
        Type == 0 andalso Cell == 0 -> [];
        true ->
           case data_awake:get(Type, 1) of
                [] -> [];
                Base ->
                    Base#base_awake.awake_attr
            end
    end.


