%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2015 下午7:13
%%%-------------------------------------------------------------------
-module(goods_load).
-author("fancy").
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
-include("equip.hrl").
%% API
-export([
    load_player_goods/2,
    load_player_bag_info/1
]).

-export([
    dbadd_goods/1,
    dbdel_goods/1,
    dbup_goods_num/1,
    dbup_goods_cell_location/1,
    dbup_goods_stren/1,
    dbup_goods_refine/1,
    dbup_bag_cell_num/1,
    dbup_goods_attr/1,
%%    dbget_goods/2,
    dbup_wash_attrs/1,
    dbup_equip_inlay/1,
    dbup_goods_lv/1,
    dbup_goods_lv_exp/1,
    dbdel_goods_by_gkey/1,
    dbdel_goods_key_list/1,
    dbup_goods/1,
    dbup_goods_id/1,
    dbup_goods_level/1,
    dbup_goods_star/1,
    dbup_wash_luck_value/1,
    dbup_color/1,
    up_wash_recover/2,
    gem_exp_save/1,
    get_gem_exp/1,
    get_refine_info/1,
    str_exp_save/1,
    get_str_exp/1,
    db_equip_wash_info/1,
    db_replace_wash_info/3,
    db_save_refine_info/1,
    dbup_goods_god_forging/1,
    get_magic_info/1,
    db_save_magic_info/1,
    get_soul_info/1,
    db_save_soul_info/1,
    dbup_goods_lock/1,
    get_soul_list/2,
    get_magic_info/2,
    get_refine_info/2,
    dbup_equip_sex/1,
    dbup_goods_xian_wash_attr/1
]).


-define(GETS, "select gkey ,pkey ,goods_id,location ,cell ,num ,bind ,expiretime ,goods_lv,star,stren ,color, wear_key, wash_luck_value,wash_attrs,xian_wash_attrs,gemstone_groove,total_attrs,combat_power,exp from goods ").

%%-define(GET_PLAYER_GOODS_LOC(Pkey, Location), io_lib:format("~s where pkey = ~p and location = ~p", [?GETS, Pkey, Location])).

%%加载玩家所有物品信息
load_player_goods(Pkey, Table) ->
    SQL = io_lib:format("select gkey ,pkey ,goods_id,location ,cell ,num ,bind ,expiretime ,goods_lv,star,stren ,color, wear_key, wash_luck_value,wash_attrs,xian_wash_attrs,gemstone_groove,total_attrs,combat_power, refine_attr, exp, god_forging,lock_s,fix_attrs,random_attrs,sex,level from ~s where pkey = ~p", [Table, Pkey]),
    db:get_all(SQL).

%%加载玩家背包信息
load_player_bag_info(Player) ->
    case player_util:is_new_role(Player) of
        false ->
            Sql = io_lib:format("select max_cell,warehouse_cell, fuwen_cell, xian_cell, god_soul_cell, fairy_cell from player_bag where pkey = ~p", [Player#player.key]),
            case db:get_row(Sql) of
                [] ->
                    [data_bag_cell:get(Player#player.lv), ?DEFAULT_WAREHOUSE_NUM, ?DEFAULT_FUWEN_NUM, ?DEFAULT_XIAN_NUM, ?DEFAULT_GOD_SOUL_NUM, ?DEFAULT_FAIRY_SOUL_NUM];
                [MaxCell, WarehouseCell, FuwenCell, XianCell, GodSoulCell, FairyCell] ->
                    [max(data_bag_cell:get(Player#player.lv), MaxCell), max(?DEFAULT_WAREHOUSE_NUM, WarehouseCell), max(?DEFAULT_FUWEN_NUM, FuwenCell), max(?DEFAULT_XIAN_NUM, XianCell), max(?DEFAULT_GOD_SOUL_NUM, GodSoulCell), max(?DEFAULT_FAIRY_SOUL_NUM, FairyCell)]
            end;
        _ -> %%新玩家
            [data_bag_cell:get(Player#player.lv), ?DEFAULT_WAREHOUSE_NUM, ?DEFAULT_FUWEN_NUM, ?DEFAULT_XIAN_NUM, ?DEFAULT_GOD_SOUL_NUM, ?DEFAULT_FAIRY_SOUL_NUM]
    end.

dbadd_goods(GoodsInfoList) when is_list(GoodsInfoList) ->
    [dbadd_goods(GoodsInfo) || GoodsInfo <- GoodsInfoList];

dbadd_goods(GoodsInfo) ->
    #goods{
        key = Key,
        pkey = Pkey,
        goods_id = GoodsId,
        location = Location,
        cell = Cell,
        num = Num,
        bind = Bind,
        expire_time = ExpireTime,
        %create_time = CreateTime,
        origin = Origin,
        lock = Lock,
        goods_lv = GoodsLv,
        stren = Stren,
        star = Star,
        wear_key = WearKey,
        wash_attr = WashSttrs,
        xian_wash_attr = XianWashAttrs,
        total_attrs = TotalAttrs,
        gemstone_groove = BaseGemstoneGroove,
        combat_power = CombatPower,
        refine_attr = RefineAttr,
        exp = Exp,
        color = Color,
        god_forging = GodForging,
        level = Level,
        fix_attrs = FixAttrs,
        random_attrs = RandomAttrs,
        sex = Sex
    } = GoodsInfo,
    CreateTime = util:unixtime(),
    TotalAttrsS = util:term_to_bitstring(TotalAttrs),
    WashSttrsString = util:term_to_bitstring(WashSttrs),
    XianWashAttrsString = util:term_to_bitstring(XianWashAttrs),
    RefineAttrString = util:term_to_bitstring(RefineAttr),
    GemstoneGroove = util:term_to_bitstring(BaseGemstoneGroove),
    FixAttrsString = util:term_to_bitstring(FixAttrs),
    RandomAttrsString = util:term_to_bitstring(RandomAttrs),
    SQL = io_lib:format("insert into ~s (gkey ,pkey ,goods_id,location ,cell ,num ,bind ,expiretime ,createtime, origin,goods_lv,star, stren , wear_key, wash_attrs, xian_wash_attrs, gemstone_groove,total_attrs,combat_power,refine_attr,exp,color,god_forging,level,lock_s,fix_attrs,random_attrs,sex) values
    (~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,'~s','~s','~s','~s',~p,'~s',~p,~p,~p,~p,~p,'~s','~s',~p)",
        [get_table(GoodsInfo), Key, Pkey, GoodsId, Location, Cell, Num, Bind, ExpireTime, CreateTime, Origin, GoodsLv, Star, Stren, WearKey, WashSttrsString, XianWashAttrsString, GemstoneGroove, TotalAttrsS, CombatPower, RefineAttrString, Exp, Color, GodForging, Level, Lock, FixAttrsString, RandomAttrsString, Sex]),
    db:execute(SQL),
    GoodsInfo#goods{key = Key}.

dbup_goods(Goods) ->
    Cell = Goods#goods.cell,
    Location = Goods#goods.location,
    Gkey = Goods#goods.key,
    Stren = Goods#goods.stren,
    Color = Goods#goods.color,
    GemAttrsStr = util:term_to_bitstring(Goods#goods.gemstone_groove),
    WashAttrsStr = util:term_to_bitstring(Goods#goods.wash_attr),
    RefineAttrsStr = util:term_to_bitstring(Goods#goods.refine_attr),
    CombatPower = Goods#goods.combat_power,
    Star = Goods#goods.star,
    Bind = Goods#goods.bind,
    Level = Goods#goods.level,
    Exp = Goods#goods.exp,
    Sql = io_lib:format("update ~s set goods_id = ~p, exp=~p, star = ~p,stren = ~p,color = ~p,cell = ~p, location = ~p ,gemstone_groove = '~s' ,wash_attrs = '~s' ,combat_power = ~p,refine_attr = '~s', bind = ~p,level = ~p where gkey = ~p", [get_table(Goods), Goods#goods.goods_id, Exp, Star, Stren, Color, Cell, Location, GemAttrsStr, WashAttrsStr, CombatPower, RefineAttrsStr, Bind, Level, Gkey]),
    db:execute(Sql),
    ok.

dbup_goods_num(GoodsInfoList) when is_list(GoodsInfoList) ->
    [dbup_goods_num(GoodsInfo) || GoodsInfo <- GoodsInfoList],
    ok;

dbup_goods_num(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Num = GoodsInfo#goods.num,
    if
        is_integer(Num) andalso Num > 0 ->
            SQL = io_lib:format("update ~s set num = ~p where gkey = ~p", [get_table(GoodsInfo), Num, Gkey]),
            db:execute(SQL);
        is_integer(Num) andalso Num =:= 0 ->
            dbdel_goods(GoodsInfo);
        true ->
            throw({dbup_goods_num, Num}),
            skip
    end.

dbdel_goods_key_list(GoodsKeyList) ->
    F = fun(GoodsKey, {AccStr, Count}) ->
        if
            Count == 0 ->
                NewAccStr = lists:concat([AccStr, GoodsKey]);
            true ->
                NewAccStr = lists:concat([AccStr, ",", GoodsKey])
        end,
        {NewAccStr, Count + 1}
        end,
    {DelStr, _} = lists:foldl(F, {"DELETE FROM goods where gkey in (", 0}, GoodsKeyList),
    NewDelStr = lists:concat([DelStr, ")"]),
    SQL = io_lib:format(NewDelStr, []),
    db:execute(SQL).

dbdel_goods(GoodsInfoList) when is_list(GoodsInfoList) ->
    [dbdel_goods(GoodsInfo) || GoodsInfo <- GoodsInfoList];

dbdel_goods(GoodsInfo) ->
    SQL = io_lib:format("DELETE FROM ~s where gkey = ~p", [get_table(GoodsInfo), GoodsInfo#goods.key]),
    db:execute(SQL).

dbdel_goods_by_gkey(Gkey) ->
    SQL = io_lib:format("DELETE FROM goods where gkey = ~p", [Gkey]),
    db:execute(SQL).

dbup_goods_cell_location(GoodsInfoList) when is_list(GoodsInfoList) ->
    [dbup_goods_cell_location(GoodsInfo) || GoodsInfo <- GoodsInfoList],
    ok;

dbup_goods_cell_location(GoodsInfo) ->
    Cell = GoodsInfo#goods.cell,
    Location = GoodsInfo#goods.location,
    Gkey = GoodsInfo#goods.key,
    WearKey = GoodsInfo#goods.wear_key,
    Sql = io_lib:format("update ~s set cell = ~p, location = ~p, wear_key=~p where gkey = ~p", [get_table(GoodsInfo), Cell, Location, WearKey, Gkey]),
    db:execute(Sql),
    ok.

dbup_goods_stren(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Stren = GoodsInfo#goods.stren,
    Sql = io_lib:format("update ~s set stren = ~p,combat_power = ~p,bind = ~p where gkey = ~p ", [get_table(GoodsInfo), Stren, GoodsInfo#goods.combat_power, GoodsInfo#goods.bind, Gkey]),
    db:execute(Sql),
    ok.

dbup_goods_god_forging(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Stren = GoodsInfo#goods.god_forging,
    Sql = io_lib:format("update ~s set god_forging = ~p,combat_power = ~p,bind = ~p where gkey = ~p ", [get_table(GoodsInfo), Stren, GoodsInfo#goods.combat_power, GoodsInfo#goods.bind, Gkey]),
    db:execute(Sql),
    ok.

dbup_goods_lock(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Lock = GoodsInfo#goods.lock,
    Sql = io_lib:format("update ~s set god_forging = ~p,combat_power = ~p,bind = ~p where gkey = ~p ", [get_table(GoodsInfo), Lock, GoodsInfo#goods.combat_power, GoodsInfo#goods.bind, Gkey]),
    db:execute(Sql),
    ok.

dbup_goods_refine(GoodsInfo) ->
    Attrs = GoodsInfo#goods.refine_attr,
    AttrsStr = util:term_to_bitstring(Attrs),
    Sql = io_lib:format("update goods set refine_attr='~s',combat_power = ~p,bind = ~p where gkey = ~p",
        [AttrsStr, GoodsInfo#goods.combat_power, GoodsInfo#goods.bind, GoodsInfo#goods.key]),
    db:execute(Sql),
    ok.

dbup_goods_lv(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Sql = io_lib:format("update ~s set goods_lv = ~p,combat_power = ~p where gkey = ~p ", [get_table(GoodsInfo), GoodsInfo#goods.goods_lv, GoodsInfo#goods.combat_power, Gkey]),
    db:execute(Sql),
    ok.

dbup_goods_lv_exp(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Sql = io_lib:format("update ~s set goods_lv = ~p,combat_power = ~p, exp = ~p where gkey = ~p ", [get_table(GoodsInfo), GoodsInfo#goods.goods_lv, GoodsInfo#goods.combat_power, GoodsInfo#goods.exp, Gkey]),
    db:execute(Sql),
    ok.

dbup_goods_xian_wash_attr(GoodsInfo) ->
    XianWashAttr = GoodsInfo#goods.xian_wash_attr,
    XianWashAttrBin = util:term_to_bitstring(XianWashAttr),
    Sql = io_lib:format("update ~s set xian_wash_attrs = '~s' where gkey = ~p ", [get_table(GoodsInfo), XianWashAttrBin, GoodsInfo#goods.key]),
    db:execute(Sql),
    ok.

dbup_bag_cell_num(GoodsSt) ->
    Key = GoodsSt#st_goods.key,
    MaxSellNum = GoodsSt#st_goods.max_cell,
    MaxWaSellNum = GoodsSt#st_goods.warehouse_max_cell,
    MaxFuwenNum = GoodsSt#st_goods.maxfuwen_cell_num,
    MaxXianNum = GoodsSt#st_goods.maxxian_cell_num,
    MaxGodSoulNum = GoodsSt#st_goods.maxgod_soul_cell_num,
    Sql = io_lib:format("replace into player_bag set max_cell = ~p,warehouse_cell = ~p,fuwen_cell=~p, xian_cell=~p, god_soul_cell=~p, pkey =~p", [MaxSellNum, MaxWaSellNum, MaxFuwenNum, MaxXianNum, MaxGodSoulNum, Key]),
    db:execute(Sql),
    ok.


dbup_goods_level(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Sql = io_lib:format("update ~s set level = ~p,combat_power = ~p  where gkey = ~p ", [get_table(GoodsInfo), GoodsInfo#goods.level, GoodsInfo#goods.combat_power, Gkey]),
    db:execute(Sql),
    ok.

dbup_goods_id(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Sql = io_lib:format("update ~s set goods_id = ~p,goods_lv = ~p,star = ~p,combat_power = ~p  where gkey = ~p ", [get_table(GoodsInfo), GoodsInfo#goods.goods_id, GoodsInfo#goods.goods_lv, GoodsInfo#goods.star, GoodsInfo#goods.combat_power, Gkey]),
    db:execute(Sql),
    ok.


dbup_goods_star(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Sql = io_lib:format("update ~s set star = ~p,combat_power = ~p where gkey = ~p ", [get_table(GoodsInfo), GoodsInfo#goods.star, GoodsInfo#goods.combat_power, Gkey]),
    db:execute(Sql),
    ok.



dbup_goods_attr(GoodsInfo) ->
    Attrs = GoodsInfo#goods.total_attrs,
    Gkey = GoodsInfo#goods.key,
    HpLim = Attrs#attribute.hp_lim,
    Crit = Attrs#attribute.crit,
    Ten = Attrs#attribute.ten,
    MpLim = Attrs#attribute.mp_lim,
    Def = Attrs#attribute.def,
    Att = Attrs#attribute.att,
    Hit = Attrs#attribute.hit,
    Dodge = Attrs#attribute.dodge,
    AttrsStr = util:term_to_bitstring([{att, Att}, {def, Def}, {hit, Hit}, {dodge, Dodge}, {crit, Crit}, {ten, Ten}, {hp_lim, HpLim}, {mp_lim, MpLim}]),
    Sql = io_lib:format("update ~s set total_attrs='~s' where gkey = ~p",
        [get_table(GoodsInfo), AttrsStr, Gkey]),
    db:execute(Sql),
    ok.


dbup_wash_luck_value(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Sql = io_lib:format("update goods set wash_luck_value = ~p where gkey = ~p ", [GoodsInfo#goods.wash_luck_value, Gkey]),
    db:execute(Sql),
    ok.

dbup_color(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Sql = io_lib:format("update ~s set stren = ~p,color = ~p,combat_power = ~p where gkey = ~p ", [get_table(GoodsInfo), GoodsInfo#goods.stren, GoodsInfo#goods.color, GoodsInfo#goods.combat_power, Gkey]),
    db:execute(Sql),
    ok.

up_wash_recover(Pkey, V) ->
    Sql = io_lib:format("update wash_recover set wash_attr = '~s' where pkey = ~p ", [util:term_to_bitstring(V), Pkey]),
    db:execute(Sql),
    ok.


dbup_wash_attrs(GoodsInfo) ->
    Attrs = GoodsInfo#goods.wash_attr,
    AttrsStr = util:term_to_bitstring(Attrs),
    Sql = io_lib:format("update goods set wash_attrs='~s',combat_power = ~p,bind = ~p where gkey = ~p",
        [AttrsStr, GoodsInfo#goods.combat_power, GoodsInfo#goods.bind, GoodsInfo#goods.key]),
    db:execute(Sql),
    ok.

dbup_equip_inlay(GoodsInfo) ->
    Attrs = GoodsInfo#goods.gemstone_groove,
    AttrsStr = util:term_to_bitstring(Attrs),
    Sql = io_lib:format("update goods set gemstone_groove='~s',combat_power = ~p,bind = ~p where gkey = ~p",
        [AttrsStr, GoodsInfo#goods.combat_power, GoodsInfo#goods.bind, GoodsInfo#goods.key]),
    db:execute(Sql),
    ok.

dbup_equip_sex(GoodsInfo) ->
    Gkey = GoodsInfo#goods.key,
    Sex = GoodsInfo#goods.sex,
    Sql = io_lib:format("update ~s set sex = ~p where gkey = ~p ", [get_table(GoodsInfo), Sex, Gkey]),
    db:execute(Sql),
    ok.


%%获取物品信息
%%dbget_goods(Pkey, Location) ->
%%    Sql = ?GET_PLAYER_GOODS_LOC(Pkey, Location),
%%    case db:get_all(Sql) of
%%        [] ->
%%            dict:new();
%%        GoodsList when is_list(GoodsList) ->
%%            goods_dict:insert_goods_dict(GoodsList, dict:new())
%%    end.

get_table(_Goods) -> "goods".


gem_exp_save(Player) ->
    StGemExp = lib_dict:get(?PROC_STATUS_GEM_EXP),
    if
        StGemExp#st_gemstone.is_change == 1 ->
            Data = util:term_to_bitstring(StGemExp#st_gemstone.gem_list),
            Sql = io_lib:format("replace into gemstone set gem_list = '~s' ,pkey =~p", [Data, Player#player.key]),
            db:execute(Sql);
        true ->
            ok
    end,
    ok.


get_gem_exp(Player) ->
    Sql = io_lib:format("select gem_list from gemstone where pkey = ~p", [Player#player.key]),
    case db:get_row(Sql) of
        [] ->
            #st_gemstone{is_change = 0, gem_list = []};
        [GemList] ->
            #st_gemstone{is_change = 0, gem_list = util:bitstring_to_term(GemList)}
    end.

str_exp_save(Player) ->
    StGemExp = lib_dict:get(?PROC_STATUS_EQUIP_STRENTH),
    if
        StGemExp#st_strength_exp.is_change == 1 ->
            Data = util:term_to_bitstring(equip_stren:format_equip_exp(StGemExp#st_strength_exp.exp_list)),
            Sql = io_lib:format("replace into strength_exp set exp_string = '~s' ,pkey =~p", [Data, Player#player.key]),
            db:execute(Sql);
        true ->
            ok
    end,
    ok.

get_str_exp(Player) ->
    Sql = io_lib:format("select exp_string from strength_exp where pkey = ~p", [Player#player.key]),
    case db:get_row(Sql) of
        [] ->
            #st_strength_exp{is_change = 0, exp_list = []};
        [Exp] ->
            #st_strength_exp{is_change = 0, exp_list = equip_stren:pack_equip_exp(util:bitstring_to_term(Exp))}
    end.

%% 获取精炼属性
get_refine_info(Player) ->
    Sql = io_lib:format("select refine_info from equip_refine where pkey = ~p", [Player#player.key]),
    case db:get_row(Sql) of
        [] ->
            #st_refine{is_change = 0, refin_list = []};
        [Refine] ->
            RefinList = equip_refine:pack_equip_refine(util:bitstring_to_term(Refine)),
            Attribute = equip_refine:total_attribute(RefinList),
            #st_refine{is_change = 0, refin_list = RefinList, attribute = Attribute}
    end.

%% 获取精炼属性
get_refine_info(GoodsId, Key) ->
    GoodsType = data_goods:get(GoodsId),
    Sql = io_lib:format("select refine_info from equip_refine where pkey = ~p", [Key]),
    StRefine = case db:get_row(Sql) of
                   [] ->
                       #st_refine{is_change = 0, refin_list = []};
                   [Refine] ->
                       RefinList = equip_refine:pack_equip_refine(util:bitstring_to_term(Refine)),
                       Attribute = equip_refine:total_attribute(RefinList),
                       #st_refine{is_change = 0, refin_list = RefinList, attribute = Attribute}
               end,
    case lists:keyfind(GoodsType#goods_type.subtype, #st_refine_info.subtype, StRefine#st_refine.refin_list) of
        false ->
            NewRefine = #st_refine_info{subtype = GoodsType#goods_type.subtype};
        Refine0 ->
            NewRefine = Refine0
    end,
    Att = equip_refine:total_attribute([NewRefine]),
    [[attribute_util:attr_tans_client(Type), Value, equip_refine:get_count(Type, Value)] || {Type, Value} <- Att].

%% 保存精炼属性
db_save_refine_info(Player) ->
    StEquipRefine = lib_dict:get(?PROC_STATUS_EQUIP_REFINE),
    if
        StEquipRefine#st_refine.is_change == 1 ->
            Data = util:term_to_bitstring(equip_refine:format_equip_refine(StEquipRefine#st_refine.refin_list)),
            Sql = io_lib:format("replace into equip_refine set pkey= ~p,refine_info='~s'", [Player#player.key, Data]),
            db:execute(Sql);
        true ->
            ok
    end.

%% 获取附魔属性
get_magic_info(Player) ->
    Sql = io_lib:format("select magic_info from equip_magic where pkey = ~p", [Player#player.key]),
    case db:get_row(Sql) of
        [] ->
            #st_magic{is_change = 0, magic_list = []};
        [Magic] ->
            MagicList = equip_magic:pack_equip_magic(util:bitstring_to_term(Magic)),
            Attribute = equip_magic:total_attribute(MagicList),
            #st_magic{is_change = 0, magic_list = MagicList, attribute = Attribute}
    end.

%% 获取附魔属性
get_magic_info(GoodsId, Key) ->
    GoodsType = data_goods:get(GoodsId),
    Sql = io_lib:format("select magic_info from equip_magic where pkey = ~p", [Key]),
    StMagic = case db:get_row(Sql) of
                  [] ->
                      #st_magic{is_change = 0, magic_list = []};
                  [Magic] ->
                      MagicList = equip_magic:pack_equip_magic(util:bitstring_to_term(Magic)),
                      Attribute = equip_magic:total_attribute(MagicList),
                      #st_magic{is_change = 0, magic_list = MagicList, attribute = Attribute}
              end,
    NewMagic = case lists:keyfind(GoodsType#goods_type.subtype, #st_magic_info.subtype, StMagic#st_magic.magic_list) of
                   false ->
                       #st_magic_info{subtype = GoodsType#goods_type.subtype};
                   Magic0 ->
                       Magic0
               end,
    MagicAtt = [tuple_to_list(X) || X <- NewMagic#st_magic_info.att_list],
    MagicAtt.


%% 保存附魔属性
db_save_magic_info(Player) ->
    StEquipMagic = lib_dict:get(?PROC_STATUS_EQUIP_MAGIC),
    if
        StEquipMagic#st_magic.is_change == 1 ->
            Data = util:term_to_bitstring(equip_magic:format_equip_magic(StEquipMagic#st_magic.magic_list)),
            Sql = io_lib:format("replace into equip_magic set pkey= ~p,magic_info='~s'", [Player#player.key, Data]),
            db:execute(Sql);
        true ->
            ok
    end.

%% 获取武魂属性
get_soul_info(Player) ->
    Sql = io_lib:format("select soul_info from equip_soul where pkey = ~p", [Player#player.key]),
    case db:get_row(Sql) of
        [] ->
            equip_soul:init_soul_list();
        [Soul] ->
            SoulList = equip_soul:pack_equip_soul(util:bitstring_to_term(Soul)),
            Attribute = equip_soul:total_attribute(SoulList),
            #st_soul{is_change = 0, soul_list = SoulList, attribute = Attribute}
    end.

%% 获取武魂属性
get_soul_list(GoodsId, Key) ->
    GoodsType = data_goods:get(GoodsId),
    Sql = io_lib:format("select soul_info from equip_soul where pkey = ~p", [Key]),
    StSoul = case db:get_row(Sql) of
                 [] ->
                     equip_soul:init_soul_list();
                 [Soul] ->
                     SoulList = equip_soul:pack_equip_soul(util:bitstring_to_term(Soul)),
                     Attribute = equip_soul:total_attribute(SoulList),
                     #st_soul{is_change = 0, soul_list = SoulList, attribute = Attribute}
             end,
    case lists:keyfind(GoodsType#goods_type.subtype, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
        false -> NewSoul = #st_soul_info{subtype = GoodsType#goods_type.subtype};
        Soul0 -> NewSoul = Soul0
    end,
    SoulAtt = [tuple_to_list(X) || X <- NewSoul#st_soul_info.info_list],
    SoulAtt.

%% 保存武魂属性
db_save_soul_info(Player) ->
    StEquipSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
    Data = util:term_to_bitstring(equip_soul:format_equip_soul(StEquipSoul#st_soul.soul_list)),
    Sql = io_lib:format("replace into equip_soul set pkey= ~p,soul_info='~s'", [Player#player.key, Data]),
    db:execute(Sql),
    ok.

%%获取洗练信息
db_equip_wash_info(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            #st_equip_wash{pkey = Player#player.key};
        false ->
            Sql = io_lib:format("select wash,wash_attr from equip_wash where pkey=~p", [Player#player.key]),
            case db:get_row(Sql) of
                [] ->
                    #st_equip_wash{pkey = Player#player.key};
                [Wash, WashAttr] ->
                    #st_equip_wash{pkey = Player#player.key, wash = util:bitstring_to_term(Wash), wash_attr = util:bitstring_to_term(WashAttr)}
            end
    end.

db_replace_wash_info(Pkey, Wash, WashAttr) ->
    Sql = io_lib:format("replace into equip_wash set pkey=~p,wash='~s',wash_attr='~s' ", [Pkey, util:term_to_bitstring(Wash), util:term_to_bitstring(WashAttr)]),
    db:execute(Sql).
