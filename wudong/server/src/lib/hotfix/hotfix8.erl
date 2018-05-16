%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 九月 2017 17:37
%%%-------------------------------------------------------------------
-module(hotfix8).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("equip.hrl").


-export([make_bug_info/0,back_zero_time20/1,back_to_zero_time3/3]).

-define(BUG_KEY_ID_3(Key),{bug_key_id_3,Key}).


get_ids() ->
    [
        200101282,
        200100456,
        250103613,
        250101581,
        250301215,
        250601330,
        250601119,
        250600056,
        251202072,
        251601917,
        251900226,
        252501764,
        252500036,
        252500951,
        252500873,
        252600104,
        252600030,
        252900972,
        253000124,
        253002160,
        253302392,
        253302844,
        253301458,
        253300792,
        253300338,
        253301120,
        254101593,
        350100063,
        350800596
    ].

get_back_goods_id() -> [6602008,4103015,1015001,2014001,20340,8001054,2003000].


make_bug_info() ->
    IdPlayers = get_ids(),
    SaveIds =
        lists:foldl(fun(PlayerId,AccList2) ->
            BackGoodsId = get_back_goods_id(),
            NewAccList2 =
                lists:foldl(fun(BackId, AccList) ->
                    Sql = io_lib:format("SELECT goods_id,create_num FROM log_goods_use WHERE pkey = ~w AND goods_id = ~w AND `time` > 1505448000 AND `time` < 1505451600", [PlayerId, BackId]),
                    case db:get_all(Sql) of
                        List when is_list(List) ->
                            BackList2 = [{GoodsId, GoodsNum} || [GoodsId, GoodsNum] <- List],
                            BackList22 = goods:merge_goods(BackList2),
                            BackList22 ++ AccList;
                        _ ->
                            AccList
                    end
                            end, [], BackGoodsId),
            [{PlayerId, NewAccList2} | AccList2]
                    end, [], IdPlayers),
    back_zero_time20(SaveIds).


back_zero_time20(BackList) ->
    back_zero_time2(BackList),
    util:sleep(200),
    IdPlayers = get_ids(),
    lists:foreach(fun(Pkey) ->
        Sql = io_lib:format("update player_login set status = 0 where pkey = ~w", [Pkey]),
        db:execute(Sql)
                  end, IdPlayers).




back_zero_time2(BackList) ->
    lists:foreach(fun({PlayerId, RfGoods}) ->
        util:sleep(200),
        LastGoods = [{GoodsId, GoodsNum} || {GoodsId, GoodsNum} <- RfGoods, GoodsId == 2003000],
        PreGoods = [{GoodsId, GoodsNum} || {GoodsId, GoodsNum} <- RfGoods, GoodsId /= 2003000],
        NewGoodsList = PreGoods ++ LastGoods,
        [back_to_zero_time3(GoodsId, _GoodsNum, PlayerId) || {GoodsId, _GoodsNum} <- NewGoodsList]
                  end, BackList).


%% 无双斗神时装
back_to_zero_time3(6602008,_GoodsNum,_PlayerId) ->
    FashionId = 10008,
    Sql = io_lib:format("SELECT stage FROM log_fashion WHERE pkey = ~w AND fashion_id = ~w AND `time` >= 1505488800 ORDER BY `time` LIMIT 1",[_PlayerId,FashionId]),
    case db:get_one(Sql) of
        Stage when is_integer(Stage) ->
            GetSql = io_lib:format("select fashion_list from fashion where pkey = ~w",[_PlayerId]),
            case db:get_one(GetSql) of
                null -> ok;
                FashionList ->
                    FsionList = util:bitstring_to_term(FashionList),
                    NewFashion = case lists:keytake(FashionId,1,FsionList) of
                                     false -> FsionList;
                                     {value,{FashionId, Time, _OldStage, IsUse},T} ->
                                         [{FashionId,Time,Stage,IsUse}|T]
                                 end,
                    ?PRINT("PlayerId,NewFashion ~w ~w",[_PlayerId,NewFashion]),
                    UpdateSql = io_lib:format("update fashion set fashion_list = '~s' where pkey = ~w",[util:term_to_bitstring(NewFashion),_PlayerId]),
                    db:execute(UpdateSql)
            end;
        _ ->
            skip
    end,
    ok;


%% 宠物升星等级
back_to_zero_time3(4103015,_GoodsNum,_PlayerId) ->
    Sql = io_lib:format("SELECT pet_key,star,exp FROM log_pet_star WHERE pkey = ~w AND `time` >= 1505488800  AND pet_type_id = 10015 ORDER BY `time`",[_PlayerId]),
    case db:get_all(Sql) of
        StartList when is_list(StartList) ->
            BackPetStarList =
            lists:foldl(fun([PetKey,Star,Exp],AccList) ->
                case lists:keyfind(PetKey,1,AccList) of
                    false ->
                        [{PetKey,Star,Exp}|AccList];
                    _ ->
                        AccList
                end
                    end,[],StartList),
            lists:foreach(fun({PetKey,Star,Exp}) ->
                UpdateSql = io_lib:format("update pet set star = ~w,star_exp = ~w where pet_key = ~w and pkey = ~w",[Star,Exp,PetKey,_PlayerId]),
                db:execute(UpdateSql)
                    end,BackPetStarList);
        _R ->
            skip
    end,
    ok;


back_to_zero_time3(1015001, GoodsNum, PlayerId) ->
    Sql = io_lib:format("select magic_info from equip_magic where pkey = ~p", [PlayerId]),
    case db:get_row(Sql) of
        [Magic] ->
            MagicList = equip_magic:pack_equip_magic(util:bitstring_to_term(Magic)),
            F = fun(St, {List11, Num}) ->
                F0 = fun({Lv, Exp, SubType}, {List0, Num0}) ->
                    Sum = magic_help(Lv, Exp),
                    if
                        Sum < Num0 -> {[{0, 0, SubType} | List0], Num0 - Sum};
                        true -> {[{Lv, Exp, SubType}|List0], 0}
                    end
                     end,
                {Att_list, Num1} = lists:foldl(F0, {[], Num}, St#st_magic_info.att_list),
                ?DEBUG("Att_list ~p~n",[Att_list]),
                Q = max(0, Num1),
                {[#st_magic_info{att_list = Att_list, subtype = St#st_magic_info.subtype}|List11], Q}
%%                     Att_list = St#st_magic_info.att_list,
                end,
            {NewMagicList,_} = lists:foldl(F, {[], GoodsNum}, MagicList),
            Data = util:term_to_bitstring(equip_magic:format_equip_magic(NewMagicList)),
            Sql1 = io_lib:format("replace into equip_magic set pkey= ~p,magic_info='~s'", [PlayerId, Data]),
            db:execute(Sql1);
        _ ->
            skip
    end,
    ok;




%%神炼宝典 等级
back_to_zero_time3(2014001, _GoodsNum, PlayerId) ->
    Sql = io_lib:format(" SELECT pkey,goods_id,befor_lv FROM log_equip_god_forging WHERE pkey = ~p AND time > 1505488800 ORDER BY time ", [PlayerId]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([_Pkey, GoodsId, BeforLv], List) ->
                GoodsType = data_goods:get(GoodsId),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, List) of
                    false ->
                        [{GoodsType#goods_type.subtype, BeforLv} | List];
                    _ ->
                        List
                end
                end,
            List1 = lists:foldl(F, [], Rows),

            GoodsList = goods_load:load_player_goods(PlayerId, "goods"),
            PlayerGoodsList = goods_info_init(GoodsList),
            F0 = fun(Goods, {L1, L2}) ->
                if Goods#goods.location == ?GOODS_LOCATION_BODY ->
                    {L1, [Goods | L2]};
                    true ->
                        {[Goods | L1], L2}
                end
                 end,
            {_PlayerGoodsList1, EquipList} = lists:foldl(F0, {[], []}, PlayerGoodsList),
            F1 = fun(Goods) ->
                GoodsType0 = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType0#goods_type.subtype, 1, List1) of
                    false -> ok;
                    {_Subtype0, Lv0} ->
                        NewGoods = Goods#goods{god_forging = Lv0},
                        goods_load:dbup_goods_god_forging(NewGoods)
                end
                 end,
            lists:map(F1, EquipList),
            ok;
        _ ->
            []
    end,
    ok;


%%宠物进阶 等级
back_to_zero_time3(20340, _GoodsNum, _PlayerId) ->
    Sql = io_lib:format("SELECT stage,lv,exp FROM log_pet_stage WHERE pkey = ~w AND `time` >= 1505488800 ORDER BY `time`,`exp` limit 1", [_PlayerId]),
    case db:get_row(Sql) of
        [Stage, Lv,Exp] ->
            UpdateSql = io_lib:format("update pet_info set stage = ~w,stage_lv = ~w,stage_exp = ~w where pkey = ~w", [Stage,Lv,Exp,_PlayerId]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;



%% 进阶图纸礼包
back_to_zero_time3(8001054,_GoodsNum,_PlayerId) ->
    %% log_equip_upgrade
    Sql = io_lib:format("select gkey, min(after_goods_id) from log_equip_upgrade where pkey=~p and time > 1505488800  group by gkey", [_PlayerId]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Gkey, GoodsId]) ->
                Sql99 = io_lib:format("update goods set goods_id=~p where pkey=~p and gkey=~p ", [GoodsId, _PlayerId, Gkey]),
                db:execute(Sql99)
            end,
            lists:map(F, Rows);
        _ ->
            ?ERR("8001054", [])
    end;


%% 强化等级
back_to_zero_time3(2003000,_GoodsNum,_PlayerId) ->
    Sql = io_lib:format("select goods_id, min(after_lv) as lv from log_equip_streng where pkey=~p and time > 1505488800  group by goods_id", [_PlayerId]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([GoodsId, Lv]) ->
                Sql99 = io_lib:format("update goods set stren=~p where pkey=~p and goods_id=~p", [Lv, _PlayerId, GoodsId]),
                db:execute(Sql99)
            end,
            lists:map(F, Rows);
        _ ->
            ?ERR("2003000", [])
    end;


back_to_zero_time3(8002403,GoodsNum0,PlayerId) ->
    GoodsNum = GoodsNum0 * 4,
    Sql = io_lib:format("select soul_info from equip_soul where pkey = ~p", [PlayerId]),
    case db:get_row(Sql) of
        [] ->
            skip;
        [Soul] ->
            SoulList = equip_soul:pack_equip_soul(util:bitstring_to_term(Soul)),
            F = fun(St, {List11, Num}) ->
                F0 = fun({Location, State, GoodsId}, {List0, Num0}) ->
                    Base = data_equip_soul:get_gid(GoodsId),
                    Sum = get_lv(Base#base_equip_soul.lv),
                    if
                        Sum < Num0 ->{[{Location, State, 0} | List0], Num0 - Sum};
                        true -> {[{Location, State, GoodsId}|List0], Num0}
                    end
                     end,
                {Att_list, Num1} = lists:foldl(F0, {[], Num}, St#st_soul_info.info_list),
                Q = max(0, Num1),
                {[#st_soul_info{info_list = Att_list, subtype = St#st_soul_info.subtype}|List11], Q}
%%                     Att_list = St#st_magic_info.att_list,
                end,
            {NewSoulList,Num11} = lists:foldl(F, {[], GoodsNum}, SoulList),
            Data = util:term_to_bitstring(equip_soul:format_equip_soul(NewSoulList)),
            Sql1 = io_lib:format("replace into equip_soul set pkey= ~p,soul_info='~s'", [PlayerId, Data]),
            db:execute(Sql1),

            GoodsList = goods_load:load_player_goods(PlayerId, "goods"),
            PlayerGoodsList = goods_info_init(GoodsList),
            F0 = fun(Goods, {L1, L2}) ->
                if Goods#goods.location == ?GOODS_LOCATION_BAG ->
                    {L1, [Goods | L2]};
                    true ->
                        {[Goods | L1], L2}
                end
                 end,
            {_PlayerGoodsList1, GoodsList1} = lists:foldl(F0, {[], []}, PlayerGoodsList),
            F1 = fun(Goods,Num111) ->
                Base = data_equip_soul:get_gid(Goods#goods.goods_id),
                if
                    Base#base_equip_soul.lv == 0 -> Num111 ;
                    true ->
                        Sum = get_lv(Base#base_equip_soul.lv),
                        ?DEBUG("Goods#goods.num ~p~n",[Goods#goods.num]),
                        if
                            Goods#goods.num * Sum =< Num111 ->
                                NewGoods = Goods#goods{num = 0},
                                goods_load:dbup_goods_num(NewGoods),
                                ?DEBUG(" Num1111111 ~p~n",[Num111]),
                                ?DEBUG(" Sum11111 ~p~n",[Sum]),
                                max(0,Num111- Goods#goods.num * Sum);
                            true ->
                                ?DEBUG(" Num111 ~p~n",[Num111]),
                                ?DEBUG(" Sum ~p~n",[Sum]),
                                Count = Num111 div Sum,
                                NewGoods = Goods#goods{num = Goods#goods.num - Count},
                                goods_load:dbup_goods_num(NewGoods),
                                0
                        end
                end
                 end,
            lists:foldl(F1,Num11, GoodsList1)
    end,
    ok;

back_to_zero_time3(_,_,_PlayerId) -> ok.



get_lv(1)-> 1;
get_lv(2)-> 2;
get_lv(3)-> 4;
get_lv(4)-> 8;
get_lv(5)-> 24;
get_lv(6)-> 72;
get_lv(7)-> 216;
get_lv(8)-> 864;
get_lv(9)-> 4320;
get_lv(10)-> 21600;
get_lv(_)-> 21600.



goods_info_init(GoodsList) ->
    goods_info_init(util:unixtime(), GoodsList, []).

goods_info_init(_Now, [], GoodsList) ->
    GoodsList;

%%物品过期
%%goods_info_init(Now, [[_Gkey, Pkey, GoodsId, _Location, _Cell, Num, _Bind, Expiretime | _] | Tail], GoodsList) when Expiretime =/= 0 andalso Expiretime =< Now ->
%%    case data_goods:get(GoodsId) of
%%        [] ->
%%            ?ERR("goods_info_init goods ~p udef~n", [GoodsId]),
%%            goods_info_init(Now, Tail, GoodsList);
%%        _ ->
%%            Msg = io_lib:format(?T("您的物品~s*~p过期,系统删除,祝您游戏愉快!"), [goods_util:get_goods_name(GoodsId), Num]),
%%            spawn(fun() ->
%%                goods_load:dbdel_goods_by_gkey(_Gkey),
%%                util:sleep(3000),
%%                mail:sys_send_mail([Pkey], ?T("物品过期"), Msg)
%%                  end),
%%            goods_info_init(Now, Tail, GoodsList)
%%    end;


goods_info_init(Now, [[Gkey, Pkey, GoodsId, Location, Cell, Num, Bind, Expiretime, GoodsLv, Star, Stren, Color, Wash_luck_value, WashAttrs, GemstoneGroove, TotalAttrs, CombatPower, RefineAttr, Exp, GodForging, Lock, FixAttrs, RandomAttrs, Sex] | Tail], GoodsList) ->
    case data_goods:get(GoodsId) of
        [] ->
            ?ERR("goods_info_init goods ~p udef~n", [GoodsId]),
            goods_info_init(Now, Tail, GoodsList);
        _ ->
            GemstoneGrooveList = util:bitstring_to_term(GemstoneGroove),
            WashAttrsList = util:bitstring_to_term(WashAttrs),
            TotalAttrsList = util:bitstring_to_term(TotalAttrs),
            RefineAttrList = util:bitstring_to_term(RefineAttr),
            FixAttrsList = util:bitstring_to_term(FixAttrs),
            RandomAttrsList = util:bitstring_to_term(RandomAttrs),
            Goods = #goods{key = Gkey, pkey = Pkey, goods_id = GoodsId, location = Location, cell = Cell, num = Num,
                bind = Bind, expire_time = Expiretime, goods_lv = GoodsLv, star = Star, stren = Stren, color = Color, wash_luck_value = Wash_luck_value, gemstone_groove = GemstoneGrooveList,
                total_attrs = TotalAttrsList, wash_attr = WashAttrsList, combat_power = CombatPower, refine_attr = RefineAttrList, exp = Exp, god_forging = GodForging, lock = Lock,
                fix_attrs = FixAttrsList, random_attrs = RandomAttrsList, sex = Sex
            },
            goods_info_init(Now, Tail, [Goods | GoodsList])
    end.



magic_help(Lv, _Exp) ->
    F = fun(Lv0) ->
        Base = data_equip_magic:get(7, 1, Lv0),
        Base#base_equip_magic.exp
        end,
    if
        Lv >= 3 -> lists:sum(lists:map(F, lists:seq(3, Lv)));
        true -> 0
    end.




































