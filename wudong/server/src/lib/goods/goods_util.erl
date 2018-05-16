%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2015 下午7:29
%%%-------------------------------------------------------------------
-module(goods_util).
-author("fancy").
-include("common.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("equip.hrl").
-include("task.hrl").

%% 公用接口
-export([
    get_goods/2,                    %%获取物品
    get_goods/1,
    get_goods_list_by_goods_id/2,   %%获取物品
    get_goods_list_by_type/3,       %%获取物品
    reduce_goods_put_db/5,
    get_goods_count/1,        %%获取物品数量
    get_goods_name/1,
    get_goods_color/1,
    get_goods_list_by_location/1,
    get_goods_list_by_location/2,
    get_goods_list_by_type_list/2,
    get_goods_list_by_subtype_list/2,
    get_goods_list_by_expire_time/2,
    offline_save/0,
    log_goods_create/6,
    log_goods_use/7,
    cmd_clean/1,
    get_goods_count_by_subtype/1,
%%    vip_add_bag_cell/3,
    client_popup_goods_not_enough/4,
    client_popup_get_oods/3,
    check_enough_space/7,
    get_type_list_by_expire_time/1,
    check_gift/1
]).

%% 数据构造接口
-export([
    reduce_goods_key_list/3,
    reduce_goods_key_list/4,
    get_exist_not_full_goods/5,
    new_multi_goods/8,
    give_goods/4,
    do_add/3,
    tans_give_goods/1
]).

%%获取物品名称
get_goods_name(GoodsTypeId) ->
    case data_goods:get(GoodsTypeId) of
        [] -> <<>>;
        Goods -> Goods#goods_type.goods_name
    end.

%%获取物品品质
get_goods_color(GoodsTypeId) ->
    case data_goods:get(GoodsTypeId) of
        [] -> 0;
        Goods -> Goods#goods_type.color
    end.

%%获取指定位置的物品列表
get_goods_list_by_location(Location) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    Now = util:unixtime(),
    FilterDict = dict:filter(fun(_, [Goods]) ->
        Goods#goods.location == Location andalso (Goods#goods.expire_time == 0 orelse Goods#goods.expire_time > Now) end, GoodsSt#st_goods.dict),
    [Goods || {_, [Goods]} <- dict:to_list(FilterDict)].
get_goods_list_by_location(GoodsSt, Location) ->
    Now = util:unixtime(),
    FilterDict = dict:filter(fun(_, [Goods]) ->
        Goods#goods.location == Location andalso (Goods#goods.expire_time == 0 orelse Goods#goods.expire_time > Now) end, GoodsSt#st_goods.dict),
    [Goods || {_, [Goods]} <- dict:to_list(FilterDict)].

%%获取指定子类型的物品列表
get_goods_list_by_subtype_list(Location, SubtypeList) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    Now = util:unixtime(),
    FilterDict =
        dict:filter(
            fun(_, [Goods]) ->
                GoodsInfo = data_goods:get(Goods#goods.goods_id),
                Goods#goods.location == Location andalso (Goods#goods.expire_time == 0 orelse Goods#goods.expire_time > Now) andalso lists:member(GoodsInfo#goods_type.subtype, SubtypeList)
            end, GoodsSt#st_goods.dict),
    [Goods || {_, [Goods]} <- dict:to_list(FilterDict)].


get_goods_list_by_expire_time(RemainTime, GoodsSt) ->
    Now = util:unixtime(),
    FilterDict =
        dict:filter(
            fun(_, [Goods]) ->
%%                 ?IF_ELSE(Goods#goods.expire_time > 0, ?DEBUG("Goods#goods.expire_time:~p~n", [Goods#goods.expire_time]), ok),
                Goods#goods.expire_time - Now > 0 andalso Goods#goods.expire_time - Now < RemainTime
            end, GoodsSt#st_goods.dict),
    [Goods || {_, [Goods]} <- dict:to_list(FilterDict)].


%% 获取限时物品ID
get_type_list_by_expire_time(GoodsTypeId) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    Now = util:unixtime(),
    FilterDict =
        dict:filter(
            fun(_, [Goods]) ->
                Goods#goods.expire_time - Now > 0 andalso Goods#goods.goods_id == GoodsTypeId
            end, GoodsSt#st_goods.dict),
    [Goods || {_, [Goods]} <- dict:to_list(FilterDict)].


%%获取指定类型的物品列表
get_goods_list_by_type_list(Location, TypeList) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    Now = util:unixtime(),
    FilterDict =
        dict:filter(
            fun(_, [Goods]) ->
                GoodsInfo = data_goods:get(Goods#goods.goods_id),
                Goods#goods.location == Location andalso (Goods#goods.expire_time == 0 orelse Goods#goods.expire_time > Now) andalso lists:member(GoodsInfo#goods_type.type, TypeList)
            end, GoodsSt#st_goods.dict),
    [Goods || {_, [Goods]} <- dict:to_list(FilterDict)].


%%根据物品Key列表删除
reduce_goods_key_list(Player, List, Reason) ->
    reduce_goods_key_list(Player, List, Reason, true).
%% IsWriteDb false不删库true删库
reduce_goods_key_list(Player, List, Reason, IsWriteDb) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    Fun = fun({Key, Num}, {GoodsOut, GoodsStOut, AccDelGoodsList}) ->
        GoodsInfo = get_goods(Key),
        {NewGoodsSt00, DelGoods} = reduce_goods_put_db(Player, GoodsStOut, GoodsInfo, Num, Reason, IsWriteDb),
        {[GoodsInfo#goods{num = GoodsInfo#goods.num - Num} | GoodsOut], NewGoodsSt00, [DelGoods | AccDelGoodsList]}
          end,
    {GoodsList, NewGoodsSt, DelGoodsList} = lists:foldl(Fun, {[], GoodsSt, []}, List),
    goods_pack:pack_send_goods_info(GoodsList, GoodsSt#st_goods.sid),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
    DelGoodsList.

reduce_goods_put_db(Player, GoodsStatus, GoodsInfo, Num, Reason) ->
    {NewGoodsStatus, _DbDelGoods} = reduce_goods_put_db(Player, GoodsStatus, GoodsInfo, Num, Reason, true),
    NewGoodsStatus.

reduce_goods_put_db(Player, GoodsStatus, GoodsInfo, Num, Reason, IsWriteDb) ->
    ?ASSERT(Num > 0, {false, ?ER_USE_NUMM_ERR}),
    ?ASSERT(GoodsInfo#goods.num >= Num, {false, ?ER_NOT_ENOUGH_GOODS_NUM}),
    LeftoverCellNum = GoodsStatus#st_goods.leftover_cell_num,
    FuwenLeftCellNum = GoodsStatus#st_goods.leftfuwen_cell_num,
    FairyLeftCellNum = GoodsStatus#st_goods.left_fairy_soul_cell_num,
    XianLeftCellNum = GoodsStatus#st_goods.leftxian_cell_num,
    GodSoulLeftCellNum = GoodsStatus#st_goods.leftgod_soul_cell_num,
    if
        GoodsInfo#goods.location == ?GOODS_LOCATION_GOD_SOUL ->
            GodSoulLeftCellNum1 = GodSoulLeftCellNum+1,
            XianLeftCellNum1 = XianLeftCellNum,
            FuwenLeftCellNum1 = FuwenLeftCellNum,
            FairyLeftCellNum1 = FairyLeftCellNum,
            LeftoverCellNum1 = LeftoverCellNum;
        GoodsInfo#goods.location == ?GOODS_LOCATION_XIAN ->
            XianLeftCellNum1 = XianLeftCellNum + 1,
            FuwenLeftCellNum1 = FuwenLeftCellNum,
            FairyLeftCellNum1 = FairyLeftCellNum,
            LeftoverCellNum1 = LeftoverCellNum,
            GodSoulLeftCellNum1 = GodSoulLeftCellNum;
        GoodsInfo#goods.location == ?GOODS_LOCATION_FUWEN ->
            XianLeftCellNum1 = XianLeftCellNum,
            FuwenLeftCellNum1 = FuwenLeftCellNum + 1,
            FairyLeftCellNum1 = FairyLeftCellNum,
            LeftoverCellNum1 = LeftoverCellNum,
            GodSoulLeftCellNum1 = GodSoulLeftCellNum;
        GoodsInfo#goods.location == ?GOODS_LOCATION_FAIRY_SOUL ->
            XianLeftCellNum1 = XianLeftCellNum,
            FuwenLeftCellNum1 = FuwenLeftCellNum,
            FairyLeftCellNum1 = FairyLeftCellNum + 1,
            LeftoverCellNum1 = LeftoverCellNum,
            GodSoulLeftCellNum1 = GodSoulLeftCellNum;
        true ->
            LeftoverCellNum1 = ?IF_ELSE(GoodsInfo#goods.num =:= Num, LeftoverCellNum + 1, LeftoverCellNum),
            FairyLeftCellNum1 = FairyLeftCellNum,
            FuwenLeftCellNum1 = FuwenLeftCellNum,
            XianLeftCellNum1 = XianLeftCellNum,
            GodSoulLeftCellNum1 = GodSoulLeftCellNum
    end,
    NewGoodsInfo = GoodsInfo#goods{num = GoodsInfo#goods.num - Num},
    if
        IsWriteDb == true -> goods_load:dbup_goods_num(NewGoodsInfo);
        true -> skip
    end,
    NewDict = goods_dict:update_goods(NewGoodsInfo, GoodsStatus#st_goods.dict),
    goods_util:log_goods_use(Player#player.key, Player#player.nickname, GoodsInfo#goods.goods_id, Num, Reason, util:unixtime(),GoodsInfo#goods.expire_time),
    {GoodsStatus#st_goods{
        leftover_cell_num = LeftoverCellNum1,
        leftfuwen_cell_num = FuwenLeftCellNum1,
        left_fairy_soul_cell_num = FairyLeftCellNum1,
        leftxian_cell_num = XianLeftCellNum1,
        leftgod_soul_cell_num = GodSoulLeftCellNum1,
        dict = NewDict}, NewGoodsInfo}.

get_goods(GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    get_goods(GoodsKey, GoodsSt#st_goods.dict).
%% according goods key ,get goods dict goods info
get_goods(GoodsKey, GoodsDict) ->
    case dict:find(GoodsKey, GoodsDict) of
        {ok, [GoodsInfo | _]} ->
            GoodsInfo;
        _ ->
            throw({false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST})
    end.

%%获取玩家背包中特定goods_id的物品，返回结果按绑定、数量排序
%%返回{总数量，GoodsList}
get_goods_list_by_goods_id(GoodsId, GoodsDict) ->
    Now = util:unixtime(),
    Dict1 = dict:filter(fun(_Key, [Goods]) ->
        (Goods#goods.location =:= ?GOODS_LOCATION_BAG orelse Goods#goods.location =:= ?GOODS_LOCATION_WHOUSE) andalso Goods#goods.goods_id =:= GoodsId andalso (Goods#goods.expire_time == 0 orelse Goods#goods.expire_time > Now) end, GoodsDict),
    List = goods_dict:dict_to_list(Dict1),
    Count = lists:foldr(fun(Goods, Out) -> Goods#goods.num + Out end, 0, List),

    ExpireList = [Goods || Goods <- List, Goods#goods.expire_time > 0],
    F = fun(Goods1, Goods2) ->
        if
            Goods1#goods.location > Goods2#goods.location -> true;
            Goods1#goods.expire_time < Goods2#goods.expire_time -> true;
            true ->
                Goods1#goods.num < Goods2#goods.num
        end
        end,
    SortList1 = lists:sort(F, ExpireList),
    F1 = fun(Goods1, Goods2) ->
        if
            Goods1#goods.location > Goods2#goods.location -> true;
            Goods1#goods.bind > Goods2#goods.bind -> true;
            true ->
                Goods1#goods.num < Goods2#goods.num
        end
         end,
    SortList2 = lists:sort(F1, List -- ExpireList),
    {Count, SortList1 ++ SortList2}.

%%根据物品类型、子类型获取物品
get_goods_list_by_type(Type, SubType, GoodsDict) ->
    Now = util:unixtime(),
    Dict1 = dict:filter(fun(_Key, [Goods]) ->
        BaseGoods = data_goods:get(Goods#goods.goods_id),
        BaseGoods#goods_type.type =:= Type andalso BaseGoods#goods_type.subtype == SubType andalso (Goods#goods.expire_time == 0 orelse Goods#goods.expire_time > Now) end, GoodsDict),
    goods_dict:dict_to_list(Dict1).

%%获取背包中物品数量
get_goods_count(GoodsId) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    Now = util:unixtime(),
    Dict1 = dict:filter(fun(_Key, [Goods]) ->
        Goods#goods.goods_id =:= GoodsId andalso
            (Goods#goods.location =:= ?GOODS_LOCATION_BAG orelse Goods#goods.location =:= ?GOODS_LOCATION_WHOUSE)
            andalso (Goods#goods.expire_time == 0 orelse Goods#goods.expire_time > Now)
                        end, GoodsStatus#st_goods.dict),
    List = goods_dict:dict_to_list(Dict1),
    lists:foldr(fun(Goods, Out) -> Goods#goods.num + Out end, 0, List).

%%获取背包中子类型为SubType的物品数量
get_goods_count_by_subtype(SubType) ->
    Now = util:unixtime(),
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    Dict1 = dict:filter(fun(_Key, [Goods]) ->
        GoodsType = data_goods:get(Goods#goods.goods_id),
        GoodsType#goods_type.subtype == SubType andalso Goods#goods.location =:= ?GOODS_LOCATION_BAG andalso (Goods#goods.expire_time == 0 orelse Goods#goods.expire_time > Now) end, GoodsStatus#st_goods.dict),
    List = goods_dict:dict_to_list(Dict1),
    lists:foldr(fun(Goods, Out) -> Goods#goods.num + Out end, 0, List).

%%
goodstype_to_goods(GoodsTypeInfo, _Args) when GoodsTypeInfo#goods_type.type =:= ?GOODS_TYPE_EQUIP ->
    Key = misc:unique_key(),
    GemInfo =
        case lists:keyfind(gem, 1, _Args) of
            false -> equip_inlay:gem_default();
            {_, KeyVal} -> KeyVal
        end,
    RefineInfo = equip_refine:refine_default(),
    MagicInfo = equip_magic:magic_default(),
%%    人物身上的随机属性暂时不开放
%%    {Color,FixAttr,RandomAttr} = equip_random:gen_attr_api(GoodsTypeInfo,GoodsTypeInfo#goods_type.color),
    ExpireTime = ?IF_ELSE(GoodsTypeInfo#goods_type.expire_time > 0, GoodsTypeInfo#goods_type.expire_time + util:unixtime(), 0),
    GoodsInfo = #goods{
        key = Key,
        goods_id = GoodsTypeInfo#goods_type.goods_id,
        bind = GoodsTypeInfo#goods_type.bind,
        goods_lv = GoodsTypeInfo#goods_type.equip_lv,
        create_time = util:unixtime(),
        gemstone_groove = GemInfo,
        expire_time = ExpireTime,
        refine_attr = RefineInfo,
        magic_attrs = MagicInfo
%%        fix_attrs = FixAttr,
%%        random_attrs = RandomAttr,
%%        color = Color
    },
%%    ?DO_IF(GoodsTypeInfo#goods_type.type =:= ?GOODS_TYPE_EQUIP, erlang:send_after(10 * 1000, self(), {apply_state, {equip, auto_wear, Key}})),
    equip_attr:equip_combat_power(GoodsTypeInfo, GoodsInfo);

goodstype_to_goods(GoodsTypeInfo, _Args) ->
    Key = misc:unique_key(),
    Exp =
        case lists:keyfind(exp, 1, _Args) of
            false -> 0;
            {_, ExpVal} -> ExpVal
        end,
    GoodsLv00 =
        case lists:keyfind(back_fuwen_lv, 1, _Args) of
            false -> GoodsTypeInfo#goods_type.equip_lv;
            {_, FuwenLv0} -> FuwenLv0
        end,
    ExpireTime = ?IF_ELSE(GoodsTypeInfo#goods_type.expire_time > 0, GoodsTypeInfo#goods_type.expire_time + util:unixtime(), 0),
    %% TODO 为啥设置为0，暂时不改
    Color0 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_FUWEN, GoodsTypeInfo#goods_type.color, 0),
    Color1 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_FAIRL_SOUL, GoodsTypeInfo#goods_type.color, Color0),
    Color2 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_GOD_SOUL, GoodsTypeInfo#goods_type.color, Color1),
    Color = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_XIAN, GoodsTypeInfo#goods_type.color, Color2),
    GoodsLv1 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_FAIRL_SOUL, 1, GoodsLv00),
    GoodsLv = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_GOD_SOUL, 1, GoodsLv1),
    {Sex99, Color99, FixAttr, RandomAttr} = equip_random:gen_attr_api(GoodsTypeInfo, Color, _Args),
    XianWashAttrs = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_XIAN, xian:get_xian_lian(GoodsTypeInfo#goods_type.color), []),
    GodSoulAttrs = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_GOD_SOUL, godness_attr:calc_singleton_god_soul_attribute(GoodsTypeInfo#goods_type.type, GoodsTypeInfo#goods_type.attr_list, 1,  GoodsTypeInfo#goods_type.color), []),
    GoodsInfo = #goods{
        key = Key,
        goods_id = GoodsTypeInfo#goods_type.goods_id,
        stren = stren_init(GoodsTypeInfo),
        bind = GoodsTypeInfo#goods_type.bind,
        create_time = util:unixtime(),
        expire_time = ExpireTime,
        goods_lv = GoodsLv,
        exp = Exp,
        sex = Sex99,
        color = Color99,
        fix_attrs = FixAttr,
        random_attrs = RandomAttr,
        xian_wash_attr = XianWashAttrs,
        god_soul_attr = GodSoulAttrs
    },
    equip_attr:equip_combat_power(GoodsTypeInfo, GoodsInfo).


stren_init(GoodsTypeInfo) when GoodsTypeInfo#goods_type.subtype =:= ?GOODS_SUBTYPE_WEAPON ->
    10;
stren_init(_) ->
    0.

%%根据物本次增加物品总数量SumNum与最大允许叠加数量，计算出需要几个格子，每个格子分别生成一份GoodsInfo
new_multi_goods(GoodsTypeInfo, SumNum, Pkey, Bind, ExpireTime, From, Location, Args) ->
    %%SumNum个物品需要占据OccupyCellNum个格子
    OccupyCellNum = util:ceil(SumNum / GoodsTypeInfo#goods_type.max_overlap),
    Fun = fun(_, {LeftNum, GoodsList}) ->
        ThisNum = ?IF_ELSE(LeftNum > GoodsTypeInfo#goods_type.max_overlap, GoodsTypeInfo#goods_type.max_overlap, LeftNum),
        GoodsInfoTmp = goodstype_to_goods(GoodsTypeInfo, Args),
        Cell = ?IF_ELSE(Location == ?GOODS_LOCATION_BODY, GoodsTypeInfo#goods_type.subtype, 0),
        NewExpireTime = ?IF_ELSE(ExpireTime > 0, ExpireTime, GoodsInfoTmp#goods.expire_time),
        GoodsInfo = GoodsInfoTmp#goods{
            bind = Bind,
            expire_time = NewExpireTime,
            pkey = Pkey,
            origin = From,
            location = Location,
            cell = Cell,
            star = GoodsTypeInfo#goods_type.star},
        NewGoodsInfo = GoodsInfo#goods{num = ThisNum},
        {LeftNum - GoodsTypeInfo#goods_type.max_overlap, [NewGoodsInfo | GoodsList]}
          end,
    {_, GoodsList} = lists:foldl(Fun, {SumNum, []}, lists:duplicate(OccupyCellNum, 1)),
    GoodsList.


%%找出背包中叠加数量未满的物品
get_exist_not_full_goods(GoodsDict, GoodsTypeInfo, Location, Bind, ExpireTime) ->
    Now = util:unixtime(),
    GoodsDict2 = dict:filter(fun(_key, [Goods]) ->
        Goods#goods.location =:= Location andalso
            Goods#goods.bind =:= Bind andalso
            Goods#goods.expire_time == ExpireTime andalso
            Goods#goods.num < GoodsTypeInfo#goods_type.max_overlap andalso
            Goods#goods.goods_id =:= GoodsTypeInfo#goods_type.goods_id
            andalso (Goods#goods.expire_time == 0 orelse Goods#goods.expire_time > Now) end,
        GoodsDict),
    GoodsList = goods_dict:dict_to_list(GoodsDict2),
    if
        length(GoodsList) > 1 ->
            %?ERR("get_exist_not_full_goods ~p ~n",[[{Goods#goods.pkey,Goods#goods.goods_id,Goods#goods.num}||Goods<-GoodsList]]),
            [lists:nth(1, GoodsList)];
        true ->
            GoodsList
    end.


%% @goods_5101004_1
give_goods(GoodsStatus, Player, InfoListAll, IsMail) ->
    AllInfoListAll = tans_give_goods(InfoListAll),
%%     ?DEBUG("AllInfoListAll:~p~n", [AllInfoListAll]),

%%    AllInfoListAll0 = goods_use:filter_transform_goods(Player, AllInfoListAll),
    %%在完成任务时，有一部分奖励为经验，银币等虚拟数值物品，这部分物品直接发放给玩家
    {DirectGoodsList, InfoList} = goods_use:filter_goods_direct(AllInfoListAll),
    Fun = fun(Info, {AccCL, AccNL, MailAcc, GoodsStatusAcc}) ->
        %NumChangGoodsList 是物品数量发生变化格子GoodsInfo
        %%NewGoodsList     当一个格子放不下时，需要另外启用新格子，NewGoodsList是新格子GoodsInfo
        {NumChangGoodsList, NewGoodsList, MailGoodsList, NGoodsStatus} = do_add(Info, GoodsStatusAcc, IsMail),
        {NumChangGoodsList ++ AccCL, NewGoodsList ++ AccNL, MailGoodsList ++ MailAcc, NGoodsStatus}
          end,
    {ChangeGoodsList, NewGoodsList, MailGoodList, GoodsStatus0} = lists:foldl(Fun, {[], [], [], GoodsStatus}, InfoList),
    {NewPlayer, NewGoodsStatus} = goods_use:direct_use_virtual_goods(DirectGoodsList, Player, GoodsStatus0),%%在完成任务时，有一部分奖励为经验，银币等虚拟数值物品，这部分物品直接发放给玩家
    mail_goods(Player, MailGoodList),
    goods_load:dbup_goods_num(ChangeGoodsList),
    goods_load:dbadd_goods(NewGoodsList),
    goods_pack:pack_send_goods_info(ChangeGoodsList ++ NewGoodsList, NewGoodsStatus#st_goods.sid),
    %%物品获得统计
    cron_goods(Player, AllInfoListAll, MailGoodList),
    goods:add_goods_act_task(AllInfoListAll),
    {ok, NewGoodsStatus, NewPlayer}.


cron_goods(Player, GoodsList, MailList) ->
    F = fun(G, L) ->
        case lists:keytake(G#give_goods.goods_id, #give_goods.goods_id, L) of
            false -> L;
            {value, GiveGoods, T} ->
                if G#give_goods.num >= GiveGoods#give_goods.num -> T;
                    true ->
                        [GiveGoods#give_goods{num = GiveGoods#give_goods.num - G#give_goods.num} | T]
                end
        end
        end,
    NewGoodsList = lists:foldl(F, GoodsList, MailList),
    %%加日志
    Time = util:unixtime(),
    LogList = [log_goods_create(Player#player.key, Player#player.nickname, Info#give_goods.goods_id, Info#give_goods.num, Info#give_goods.from, Time) || Info <- NewGoodsList],
    log_proc:log_list(LogList),
    AddGoodsList = [{G#give_goods.goods_id, G#give_goods.num, G#give_goods.from, G#give_goods.goods_type} || G <- NewGoodsList],
    case config:is_debug() of
        true ->
%%            role_goods_count:add_count(AddGoodsList),
            skip;
        _ ->
            role_goods_count:add_count(AddGoodsList),
            goods_count:add_count(AddGoodsList)
    end,
    ok.

mail_goods(Player, MailGoodList) ->
    if
        MailGoodList =:= [] ->
            skip;
        true ->
            {Title, Content} =
                case hd(MailGoodList) of
                    #give_goods{goods_type = GoodsType} ->
                        #goods_type{type = Type} = GoodsType,
                        case Type of
                            ?GOODS_TYPE_FUWEN ->
                                t_mail:mail_content(101);
                            ?GOODS_TYPE_XIAN ->
                                t_mail:mail_content(135);
                            ?GOODS_TYPE_GOD_SOUL ->
                                t_mail:mail_content(158);
                            _ ->
                                t_mail:mail_content(6)
                        end;
                    _ ->
                        t_mail:mail_content(6)
                end,
            mail:sys_send_mail([Player#player.key], Title, Content, MailGoodList)
    end.


do_add(GiveGoods, GoodsStatus, IsMail) ->
    Num = GiveGoods#give_goods.num,
    Bind = GiveGoods#give_goods.bind,
    From = GiveGoods#give_goods.from,
    Pkey = GoodsStatus#st_goods.key,
    GoodsTypeInfo = GiveGoods#give_goods.goods_type,
    ExpireTime = GiveGoods#give_goods.expire_time,
    Location3 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_GOD_SOUL, ?GOODS_LOCATION_GOD_SOUL, GiveGoods#give_goods.location),
    Location2 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_XIAN, ?GOODS_LOCATION_XIAN, Location3),
    Location1 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_FUWEN, ?GOODS_LOCATION_FUWEN, Location2),
    Location = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_FAIRL_SOUL, ?GOODS_LOCATION_FAIRY_SOUL, Location1),
    GoodsDict = GoodsStatus#st_goods.dict,
    LeftOverCellNum3 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_GOD_SOUL, GoodsStatus#st_goods.leftgod_soul_cell_num, GoodsStatus#st_goods.leftover_cell_num),
    LeftOverCellNum2 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_XIAN, GoodsStatus#st_goods.leftxian_cell_num, LeftOverCellNum3),
    LeftOverCellNum1 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_FUWEN, GoodsStatus#st_goods.leftfuwen_cell_num, LeftOverCellNum2),
    LeftOverCellNum0 = ?IF_ELSE(GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_FAIRL_SOUL, GoodsStatus#st_goods.left_fairy_soul_cell_num, LeftOverCellNum1),

    %%检查下背包空间是否足够，如果不够，直接抛异常
    case catch check_enough_space(GoodsTypeInfo, Bind, ExpireTime, Num, Location, GoodsDict, LeftOverCellNum0) of
        newcell -> %%背包中没有该物品，而且格子数量是足够的，新加物品占用一个新格子
            MailGoodsList = [],
            ChangeGoodsList = [],
            NewGoodsList = goods_util:new_multi_goods(GoodsTypeInfo, Num, Pkey, Bind, ExpireTime, From, Location, GiveGoods#give_goods.args);
        {enough, ExistGoods} -> %%背包已经该物品了，而且最大叠加数量没满，直接叠加在现有的物品之上
            NewGoods = ExistGoods#goods{num = ExistGoods#goods.num + Num},
            ChangeGoodsList = [NewGoods],
            MailGoodsList = [],
            NewGoodsList = [];
        {overlap_and_newcell, ExistGoods, NewNum} -> %%背包已经该物品了，但是追加这个物品后，最大叠加数量已经满了，还需要使用新格子
            NewGoods = ExistGoods#goods{num = GoodsTypeInfo#goods_type.max_overlap},
            ChangeGoodsList = [NewGoods],
            MailGoodsList = [],
            NewGoodsList = goods_util:new_multi_goods(GoodsTypeInfo, NewNum, Pkey, Bind, ExpireTime, From, Location, GiveGoods#give_goods.args);
        {false, ?ER_NOT_ENOUGH_CELL} when IsMail == true -> %%背包格子不够，而且开启了邮件发送
            ChangeGoodsList = [],
            MailGoodsList = [GiveGoods],
            NewGoodsList = [];
        {false, ?ER_NOT_ENOUGH_CELL} when IsMail == false -> %%背包格子不够，而且没有开启邮件发送
            MailGoodsList = [],
            ChangeGoodsList = [],
            NewGoodsList = [],
            throw({false, ?ER_NOT_ENOUGH_CELL});
        Error ->
            ?ERR("do_add Error ~p ~n", [Error]),
            MailGoodsList = [],
            ChangeGoodsList = [],
            NewGoodsList = [],
            throw({false, 444})
    end,
    NewGoodsDict = goods_dict:update_goods(ChangeGoodsList ++ NewGoodsList, GoodsDict),
    if
        GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_GOD_SOUL ->
            NewGoodsStatus = GoodsStatus#st_goods{
                leftgod_soul_cell_num = GoodsStatus#st_goods.leftgod_soul_cell_num - length(NewGoodsList),
                dict = NewGoodsDict};
        GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_XIAN ->
            NewGoodsStatus = GoodsStatus#st_goods{
                leftxian_cell_num = GoodsStatus#st_goods.leftxian_cell_num - length(NewGoodsList),
                dict = NewGoodsDict};
        GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_FUWEN ->
            NewGoodsStatus = GoodsStatus#st_goods{
                leftfuwen_cell_num = GoodsStatus#st_goods.leftfuwen_cell_num - length(NewGoodsList),
                dict = NewGoodsDict};
        GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_FAIRL_SOUL ->
            NewGoodsStatus = GoodsStatus#st_goods{
                left_fairy_soul_cell_num = GoodsStatus#st_goods.left_fairy_soul_cell_num - length(NewGoodsList),
                dict = NewGoodsDict};
        true ->
            NewGoodsStatus = GoodsStatus#st_goods{
                leftover_cell_num = GoodsStatus#st_goods.leftover_cell_num - length(NewGoodsList),
                dict = NewGoodsDict}
    end,
    {ChangeGoodsList, NewGoodsList, MailGoodsList, NewGoodsStatus}.



check_enough_space(GoodsTypeInfo, Bind, ExpireTime, Num, Location, GoodsDict, LeftOverCellNum) ->
    %%物品时可以多个堆叠在一起的，先查看背包中是否已经存在这个物品
    case get_exist_not_full_goods(GoodsDict, GoodsTypeInfo, Location, Bind, ExpireTime) of
        [] -> %%背包不不存在新加的物品，启动用一个新格子
            NeedCellNum = util:ceil(Num / GoodsTypeInfo#goods_type.max_overlap),
            ?ASSERT(LeftOverCellNum >= NeedCellNum, {false, ?ER_NOT_ENOUGH_CELL}),
            newcell;
        [_Goods] when GoodsTypeInfo#goods_type.max_overlap =:= 1 ->  %%背包中已经有这个物品，而且剩余的可叠加数量足够放下新加的数量，不用启用新格子
            ?ASSERT(LeftOverCellNum >= Num, {false, ?ER_NOT_ENOUGH_CELL}),
            newcell;
        [Goods] when Num + Goods#goods.num =< GoodsTypeInfo#goods_type.max_overlap ->  %%背包中已经有这个物品，而且剩余的可叠加数量足够放下新加的数量，不用启用新格子
            {enough, Goods};
        [Goods] ->    %%背包中已经有这个物品，但是最大堆叠数量已经放不下了，需要启用新格子了
            ExistGoodsHoldNum = GoodsTypeInfo#goods_type.max_overlap - Goods#goods.num,
            NewNum = Num - ExistGoodsHoldNum,
            StillNeedCell = util:ceil(NewNum / GoodsTypeInfo#goods_type.max_overlap),
            ?ASSERT(LeftOverCellNum >= StillNeedCell, {false, ?ER_NOT_ENOUGH_CELL}),
            {overlap_and_newcell, Goods, NewNum}
    end.


give_goods_event(_Player, _AllInfoListAll) -> ok.
%%    case lists:keyfind(20704, #give_goods.goods_id, AllInfoListAll) of
%%        false ->
%%            ok;
%%        _ -> %%拿到了淘宝券，需要通知客户端加个小红点
%%            activity:get_notice(Player, [72], true)
%%    end.


offline_save() ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    goods_load:dbup_bag_cell_num(GoodsSt),
    ok.

log_goods_create(Pkey, Nickname, Goods_id, Num, From, Time) ->
    Sql = io_lib:format(<<"insert into log_goods_create set pkey = ~p,nickname='~s',goods_id =~p,goods_name='~s',create_num=~p,`from`=~p,time=~p">>,
        [Pkey, Nickname, Goods_id, goods_util:get_goods_name(Goods_id), Num, From, Time]),
    Sql.

log_goods_use(Pkey, Nickname, Goods_id, Num, Reason, Time, Expiretime) ->
    Sql = io_lib:format(<<"insert into log_goods_use set pkey = ~p,nickname='~s',goods_id =~p,goods_name='~s',create_num=~p,reason=~p,time=~p,expiretime =~p">>,
        [Pkey, Nickname, Goods_id, goods_util:get_goods_name(Goods_id), Num, Reason, Time, Expiretime]),
    log_proc:log(Sql),
    ok.

merge_goods_loop([], GiveGoods, L) -> [GiveGoods | L];
merge_goods_loop([OldGiveGoods | T], GiveGoods, L) ->
    if OldGiveGoods#give_goods.goods_id == GiveGoods#give_goods.goods_id andalso
        OldGiveGoods#give_goods.bind == GiveGoods#give_goods.bind andalso
        OldGiveGoods#give_goods.expire_time == GiveGoods#give_goods.expire_time ->
        [OldGiveGoods#give_goods{num = OldGiveGoods#give_goods.num + GiveGoods#give_goods.num} | T] ++ L;
        true ->
            merge_goods_loop(T, GiveGoods, [OldGiveGoods | L])
    end.


merge_goods(GiveGoods, List) ->
    merge_goods_loop(List, GiveGoods, []).

tans_give_goods(GoodsList) ->
    lists:foldl(fun(GiveGoods, Out) ->
        case GiveGoods of
            GiveGoods when is_record(GiveGoods, give_goods) andalso GiveGoods#give_goods.num > 0 ->
                case data_goods:get(GiveGoods#give_goods.goods_id) of
                    [] ->
                        ?ERR("undef goods_id ~p from ~p~n", [GiveGoods#give_goods.goods_id, GiveGoods#give_goods.from]),
                        Out;
                    GoodsType ->
                        ?DO_IF(GiveGoods#give_goods.location == ?GOODS_LOCATION_BODY, ?ERR("Givegoods log ~p~n", [GiveGoods])),
                        merge_goods(GiveGoods#give_goods{goods_type = GoodsType}, Out)
                end;
            _ ->
                ?ERR("tans_give_goods ~p ~n", [GiveGoods]),
                Out
        end end, [], GoodsList).

%%vip_add_bag_cell(Player, NewVipLv, OldVipLv) ->
%%    OldCell = data_vip_args:get(35, OldVipLv),
%%    NewCell = data_vip_args:get(35, NewVipLv),
%%    if
%%        NewCell > OldCell ->
%%            GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
%%            NewGoodsSt = GoodsSt#st_goods{max_cell = GoodsSt#st_goods.max_cell - OldCell + NewCell,
%%                leftover_cell_num = GoodsSt#st_goods.leftover_cell_num - OldCell + NewCell},
%%            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
%%            {ok, Bin1} = pt_150:write(15008, {NewGoodsSt#st_goods.max_cell}),
%%            server_send:send_to_sid(Player#player.sid, Bin1),
%%            ok;
%%        true ->
%%            ok
%%    end.

cmd_clean(Player) ->
    GoodsList = get_goods_list_by_location(?GOODS_LOCATION_BAG),
    List = [{Goods#goods.goods_id, Goods#goods.num} || Goods <- GoodsList],
    goods:subtract_good(Player, List, 0),
    ok.

%%让客户端弹出物品不足的面板
%%client_popup_goods_not_enough(Player, _, _, _) when Player#player.lv =< 20 ->
%%    ok;
client_popup_goods_not_enough(Player, GoodsId, Num, Reason) ->
    {ok, Bin} = pt_150:write(15006, {GoodsId, Num, Reason}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

client_popup_get_oods(Player, Type, Id) ->
    {ok, Bin} = pt_150:write(15011, {Type, Id}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.


%% 获取付费礼包
check_gift(Player) ->
    Now = util:unixtime(),
    if
        Now - Player#player.logout_time < 600 -> [];
        true ->
            GoodsList = goods_util:get_goods_list_by_subtype_list(?GOODS_LOCATION_BAG, [90]),
            F = fun(Goods) ->
                case data_gift_bag:get(Goods#goods.goods_id) of
                    [] -> [];
                    #base_gift{need_gold = NeedGold} ->
                        ?IF_ELSE(NeedGold > 0, [{Goods#goods.goods_id, Goods#goods.num}], [])
                end
                end,
            case lists:flatmap(F, GoodsList) of
                [] -> [];
                List ->
                    List2 = goods:merge_goods(List),
                    List3 = goods:pack_goods(List2),
                    List3
            end
    end.


