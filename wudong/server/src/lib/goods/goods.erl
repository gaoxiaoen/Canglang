%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 一月 2015 上午10:54
%%%-------------------------------------------------------------------
-module(goods).
-author("fancy").
-include("common.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("fashion.hrl").
-include("designation.hrl").
-include("head.hrl").
-include("bubble.hrl").
-include("tips.hrl").
-include("wing.hrl").
-include("mount.hrl").
-include("decoration.hrl").
-include("task.hrl").

%%公用接口
-export([
    change_goods_lv/2,   %%改变物品等级
    get_goods_list/1,     %%获取玩家物品列表
    get_unbind_goods_id_list/1, %%获取玩家身上的非绑定物品id
    give_goods/2,         %%增加物品
    subtract_good/3,     %%扣物品
    subtract_good/4,     %%扣物品
    give_goods_throw/2,
    subtract_good_throw/4,
    subtract_good_throw/3,
    make_give_goods_list/2,
    subtract_good_by_key/2,
    subtract_good_by_keys/1,
    pack_goods/1,
    merge_goods/1,
    merge_give_goods/1,
    goods_split/3,

    check_use_state/2,
    get_wing_dan_notice/1,
    get_mount_dan_notice/1,
    add_goods_act_task/1
]).

%%协议接口
-export([
    sell_goods/2,  %%卖出物品
    goods_lock/2,
    goods_unlock/2,
    goods_attr_info/2,
    test/1,
    new_role_gift/1,
    http_get_card_id/1
]).

check_use_state(_Player, Tips) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsList0 = goods_util:get_goods_list_by_expire_time(15 * 3600, GoodsStatus),
    Now = util:unixtime(),
    F = fun(Goods) -> %% 过滤掉已经过期的物品
        Goods#goods.expire_time - 60 > Now
        end,
    GoodsList = lists:filter(F, GoodsList0),
    Len = length(GoodsList),
    if
        Len == 0 ->
            Tips;
        Len == 1 ->
            [Goods] = GoodsList,
            Tips#tips{state = 1, args1 = Goods#goods.key};
        Len == 2 ->
            [Goods1, Goods2] = GoodsList,
            Tips#tips{state = 1, args1 = Goods1#goods.key, args2 = Goods2#goods.key};
        Len == 3 ->
            [Goods1, Goods2, Goods3] = GoodsList,
            Tips#tips{state = 1, args1 = Goods1#goods.key, args2 = Goods2#goods.key, args3 = Goods3#goods.key};
        true -> %% 最多推送4个不同的物品
            [Goods1, Goods2, Goods3, Goods4 | _] = GoodsList,
            Tips#tips{state = 1, args1 = Goods1#goods.key, args2 = Goods2#goods.key, args3 = Goods3#goods.key, args4 = Goods4#goods.key}
    end.

get_wing_dan_notice(Player) ->
    GoodsList = goods_util:get_goods_list_by_subtype_list(?GOODS_LOCATION_BAG, [432]),
    Wing = lib_dict:get(?PROC_STATUS_WING),
    LogOutTime = Player#player.logout_time,
    Time = util:unixtime() - LogOutTime,
    LoginFlag =
        case get(get_wing_dan_notice127) of
            1 -> 0;
            _ -> put(get_wing_dan_notice127, 1), 1
        end,
    if
        Time > 600 andalso LoginFlag == 0 ->
            case GoodsList /= [] of
                true -> 1;
                false ->
                    case version:get_lan_config() of
                        bt ->
                            ?IF_ELSE(Player#player.vip_lv < 6 andalso Wing#st_wing.stage > 2 andalso Wing#st_wing.stage < 6, 1, 0);
                        _ ->
                            ?IF_ELSE(Player#player.vip_lv < 5 andalso Wing#st_wing.stage > 2 andalso Wing#st_wing.stage < 6, 1, 0)
                    end
            end;
        LoginFlag == 1 ->
            case GoodsList /= [] of
                true -> 1;
                false ->
                    case version:get_lan_config() of
                        bt ->
                            ?IF_ELSE(Player#player.vip_lv < 6 andalso Wing#st_wing.stage > 2 andalso Wing#st_wing.stage < 6, 1, 0);
                        _ ->
                            ?IF_ELSE(Player#player.vip_lv < 5 andalso Wing#st_wing.stage > 2 andalso Wing#st_wing.stage < 6, 1, 0)
                    end
            end;
        true -> 0
    end.

get_mount_dan_notice(Player) ->
    GoodsList = goods_util:get_goods_list_by_subtype_list(?GOODS_LOCATION_BAG, [431]),
    Mount = lib_dict:get(?PROC_STATUS_MOUNT),
    LogOutTime = Player#player.logout_time,
    Time = util:unixtime() - LogOutTime,
    LoginFlag =
        case get(get_mount_dan_notice128) of
            1 -> 0;
            _ -> put(get_mount_dan_notice128, 1), 1
        end,
    if
        Time > 600 andalso LoginFlag == 0 ->
            case GoodsList /= [] of
                true -> 1;
                false ->
                    case version:get_lan_config() of
                        bt ->
                            ?IF_ELSE(Player#player.vip_lv < 5 andalso Mount#st_mount.stage > 2 andalso Mount#st_mount.stage < 7, 1, 0);
                        _ ->
                            ?IF_ELSE(Player#player.vip_lv < 3 andalso Mount#st_mount.stage > 2 andalso Mount#st_mount.stage < 7, 1, 0)
                    end
            end;
        LoginFlag == 1 ->
            case GoodsList /= [] of
                true -> 1;
                false ->
                    case version:get_lan_config() of
                        bt ->
                            ?IF_ELSE(Player#player.vip_lv < 5 andalso Mount#st_mount.stage > 2 andalso Mount#st_mount.stage < 7, 1, 0);
                        _ ->
                            ?IF_ELSE(Player#player.vip_lv < 3 andalso Mount#st_mount.stage > 2 andalso Mount#st_mount.stage < 7, 1, 0)
                    end
            end;
        true -> 0
    end.


%%改变物品等级,返回ok表示成功，如果GoodsKey不对，会返回{false,Code}的错误
change_goods_lv(GoodsKey, NewLv) ->
    case catch goods_util:get_goods(GoodsKey) of
        Goods when is_record(Goods, goods) ->
            NewGoods = Goods#goods{goods_lv = NewLv},
            GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
            NewGoodsStatus = goods_dict:update_goods(NewGoods, GoodsStatus),
            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
            goods_load:dbup_goods_lv(NewGoods),
            goods_pack:pack_send_goods_info(NewGoods, GoodsStatus#st_goods.sid),
            ok;
        {false, Code} ->
            {false, Code}
    end.

%% 获取玩家身上物品列表
%% Location 1穿在身上的物品，2背包中的物品
%% 返回 [Goods]
get_goods_list(Location) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    Dict1 = dict:filter(fun(_Key, [Goods]) ->
        Goods#goods.location =:= Location end, GoodsStatus#st_goods.dict),
    goods_dict:dict_to_list(Dict1).

%%获取玩家身上的非绑定物品id
get_unbind_goods_id_list(Location) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    Dict1 = dict:filter(fun(_Key, [Goods]) ->
        Goods#goods.location =:= Location andalso Goods#goods.bind == 0 end, GoodsStatus#st_goods.dict),
    [Goods#goods.goods_id || Goods <- goods_dict:dict_to_list(Dict1)].

%% 根据物品唯一key扣除物品，
%% 扣除成功返回ok
%% 如果key 不存在，返回{false,0}
%% 如果数量不足，会返回{false,1}
subtract_good_by_key(Gkey, Num) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    case do_subtract_goods(GoodsStatus, Gkey, Num) of
        {ok, NewGoodsStatus, Goods} ->
            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
            goods_pack:pack_send_goods_info([Goods], GoodsStatus#st_goods.sid),
            ok;
        Ret -> Ret
    end.

subtract_good_by_keys(KeyList) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    F = fun({Key, Num}, {Status, L}) ->
        case do_subtract_goods(Status, Key, Num) of
            {ok, Status1, Goods} ->
                {Status1, [Goods | L]};
            _ -> {Status, L}
        end
        end,
    {NewGoodsStatus, GoodsList} = lists:foldl(F, {GoodsStatus, []}, KeyList),
    goods_pack:pack_send_goods_info(GoodsList, GoodsStatus#st_goods.sid),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
    ok.

do_subtract_goods(GoodsStatus, Gkey, Num) ->
    case catch goods_util:get_goods(Gkey, GoodsStatus#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {false, 0};
        Goods when is_record(Goods, goods) andalso Goods#goods.num >= Num ->
            NewGoods = Goods#goods{num = Goods#goods.num - Num},
            goods_load:dbup_goods_num(NewGoods),
            NewDict = goods_dict:update_goods(NewGoods, GoodsStatus#st_goods.dict),
            GoodsType = data_goods:get(Goods#goods.goods_id),
            if
                Goods#goods.num =:= Num andalso GoodsType#goods_type.type =/= 3 -> %%碎片不占格子
                    NewGoodsStatus = GoodsStatus#st_goods{
                        dict = NewDict,
                        leftover_cell_num = GoodsStatus#st_goods.leftover_cell_num + 1};
                true ->
                    NewGoodsStatus = GoodsStatus#st_goods{dict = NewDict}
            end,
            {ok, NewGoodsStatus, NewGoods};
        _ ->
            {false, 1}
    end.

%% 扣除物品,优先扣除绑定物品
%% InfoList = [{物品类型id,数量},{物品类型id,数量}..]
%% 成功返回{ok,NewGoodsStatus}
%% 数量不够等原因返回{false,errorcode}
subtract_good(Player, InfoList, Reason) ->
    subtract_good(Player, InfoList, Reason, true).

subtract_good(Player, InfoList, Reason, NumnotEnoughIsNoticeClient) ->
    case catch subtract_good_throw(Player, InfoList, Reason, NumnotEnoughIsNoticeClient) of
        {ok, NewGoodsStatus} ->
            {ok, NewGoodsStatus};
        {false, Code} ->
            {false, Code};
        OtherError ->
            ?ERR("subtract_good error ~p ~n", [OtherError]),
            {false, 0}
    end.

subtract_good_throw(Player, InfoList, Reason) ->
    subtract_good_throw(Player, InfoList, Reason, true).

%%调用这个函数如果条件不足，会抛出异常{false,errorcode}
subtract_good_throw(Player, InfoList, Reason, NumnotEnoughIsNoticeClient) ->
    subtract_good_throw(Player, InfoList, Reason, NumnotEnoughIsNoticeClient, true).

subtract_good_throw(Player, InfoList0, Reason, NumnotEnoughIsNoticeClient, UpdataClient) ->
    %%去重
    InfoList =
        lists:foldl(
            fun({GoodsId, Num}, Out) ->
                case lists:keytake(GoodsId, 1, Out) of
                    false -> [{GoodsId, Num} | Out];
                    {value, {GoodsId, HaveNum}, T} ->
                        [{GoodsId, HaveNum + Num} | T]
                end
            end, [], InfoList0),
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    Fun = fun(Info, {UGoodsAcc, GoodsStatusAcc}) ->
        {UpdateGoodsList, NGoodsStatus} = do_subtract(Player, Info, Reason, GoodsStatusAcc, NumnotEnoughIsNoticeClient),
        {UpdateGoodsList ++ UGoodsAcc, NGoodsStatus}
          end,
    {UpdateGoodsList, NewGoodsStatus} = lists:foldl(Fun, {[], GoodsStatus}, InfoList),
    goods_load:dbup_goods_num(UpdateGoodsList),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
    if
        UpdataClient ->
            goods_warehouse:pack_send_goods_info([G || G <- UpdateGoodsList, G#goods.location =:= ?GOODS_LOCATION_WHOUSE], GoodsStatus#st_goods.sid),
            goods_pack:pack_send_goods_info([G || G <- UpdateGoodsList, G#goods.location =:= ?GOODS_LOCATION_BAG], GoodsStatus#st_goods.sid);
        true ->
            skip
    end,
%%    Time = util:unixtime(),
%%    [goods_util:log_goods_use(Player#player.key, Player#player.nickname, GoodsType, Num, Reason, Time, 0) || {GoodsType, Num} <- InfoList],
    {ok, NewGoodsStatus}.

do_subtract(Player, {GoodsId, Num}, Reason, GoodsStatus, IsNoticeClient) ->
    GoodsDict = GoodsStatus#st_goods.dict,
    {SumNum, GoodsList} = goods_util:get_goods_list_by_goods_id(GoodsId, GoodsDict),
    if Num > SumNum ->
        if IsNoticeClient ->
            goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, Reason);
            true ->
                skip
        end,
        throw({false, ?ER_NOT_ENOUGH_GOODS_NUM});
        true ->
            skip
    end,
    Fun = fun(Goods, {UpdateGoodsList, RemainNum, GoodsStatusOut}) ->
        if
            RemainNum =:= 0 ->
                {UpdateGoodsList, RemainNum, GoodsStatusOut};
            Goods#goods.num =< RemainNum ->
                NewGoods = Goods#goods{num = 0},
                case data_goods:get(Goods#goods.goods_id) of
                    GoodsTypeInfo when is_record(GoodsTypeInfo, goods_type) andalso GoodsTypeInfo#goods_type.type =:= 3 andalso Goods#goods.location =:= ?GOODS_LOCATION_BAG ->
                        GoodsStatus0 = GoodsStatusOut;    %%碎片不占玩家背包
                    _ ->
                        case Goods#goods.location of
                            ?GOODS_LOCATION_BAG ->
                                GoodsStatus0 = GoodsStatusOut#st_goods{leftover_cell_num = GoodsStatusOut#st_goods.leftover_cell_num + 1};
                            ?GOODS_LOCATION_WHOUSE ->
                                GoodsStatus0 = GoodsStatusOut#st_goods{warehouse_leftover_cell_num = GoodsStatusOut#st_goods.warehouse_leftover_cell_num + 1}
                        end
                end,
                goods_util:log_goods_use(Player#player.key, Player#player.nickname, Goods#goods.goods_id, Goods#goods.num, Reason, util:unixtime(), Goods#goods.expire_time),
                {[NewGoods | UpdateGoodsList], RemainNum - Goods#goods.num, GoodsStatus0};
            Goods#goods.num > RemainNum ->
                goods_util:log_goods_use(Player#player.key, Player#player.nickname, Goods#goods.goods_id, RemainNum, Reason, util:unixtime(), Goods#goods.expire_time),
                NewGoods = Goods#goods{num = Goods#goods.num - RemainNum},
                {[NewGoods | UpdateGoodsList], 0, GoodsStatusOut}
        end
          end,
    {UpdateGoodsList, 0, GoodsStatus1} = lists:foldl(Fun, {[], Num, GoodsStatus}, GoodsList),
    NewGoodsStatus = goods_dict:update_goods(UpdateGoodsList, GoodsStatus1),
    {UpdateGoodsList, NewGoodsStatus}.


%%================================================================新增物品==========================================================


%%@新增物品 ,默认给的物品是绑定的,给予物品前请格式化统一格式 goods:make_give_goods_list/2
%% InfoList = [#give_goods{}]
%%调用这个接口,如果背包格子不够，多出来的东西会发送至邮箱里面
give_goods(Player, AllInfoListAll) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:give_goods(GoodsStatus, Player, AllInfoListAll, true) of
        {ok, NewGoodsStatus, NewPlayer} ->
            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
            {ok, NewPlayer};
        Error ->
            ?ERR("give_goods error ~p AllInfoListAll :~p ~n", [Error, AllInfoListAll]),
            {ok, Player}
    end.

%%调用这个接口,如果背包格子不够，不会发送到邮件，会直接抛出一个{false,Errorcode}的异常，请自己在外面catch
give_goods_throw(Player, AllInfoListAll) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    {ok, NewGoodsStatus, NewPlayer} = goods_util:give_goods(GoodsStatus, Player, AllInfoListAll, false),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
    {ok, NewPlayer}.


%%================================================================新增物品结束==========================================================

%%拆分物品
goods_split(Player, GoodsKey, Num) ->
    case catch goods_util:get_goods(GoodsKey) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {?ER_VERIFY_FAILL_GOODS_NOT_EXIST, Player};
        Goods ->
            if Goods#goods.location /= ?GOODS_LOCATION_BAG -> {36, Player};
                Goods#goods.num < Num -> {38, Player};
                true ->
                    case data_goods:get(Goods#goods.goods_id) of
                        [] -> {6, Player};
                        GoodsType ->
                            case lists:member(GoodsType#goods_type.subtype, ?FASHION_SUBTYPE_LIST) of
                                false -> {37, Player};
                                true ->
                                    case get_split_num(GoodsType#goods_type.subtype, GoodsType#goods_type.special_param_list) of
                                        [] ->
                                            {39, Player};
                                        [GoodsId, GoodsNum] ->
                                            GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
                                            NewGoodsStatus = goods_util:reduce_goods_put_db(Player, GoodsStatus, Goods, Num, 566),
                                            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
                                            GoodsUpdateBin = goods_pack:pack_goods_info_bin([Goods#goods{num = Goods#goods.num - Num}]),
                                            server_send:send_to_sid(Player#player.sid, GoodsUpdateBin),
                                            GoodsList = [{GoodsId, round(GoodsNum * Num)}],
                                            {ok, NewPlayer} = give_goods(Player, make_give_goods_list(260, GoodsList)),
                                            {1, NewPlayer}
                                    end
                            end
                    end
            end
    end.




get_split_num(Subtype, GoodsId) ->
    if Subtype == ?GOODS_SUBTYPE_FASHION1 orelse Subtype == ?GOODS_SUBTYPE_FASHION2 orelse Subtype == ?GOODS_SUBTYPE_FASHION3 orelse Subtype == ?GOODS_SUBTYPE_FASHION4 ->
        case data_fashion:get(GoodsId) of
            [] -> [];
            Base ->
                ?IF_ELSE(Base#base_fashion.goods_id == 0, [], [Base#base_fashion.goods_id, Base#base_fashion.goods_num])
        end;
        Subtype == ?GOODS_SUBTYPE_HEAD1 orelse Subtype == ?GOODS_SUBTYPE_HEAD2 orelse Subtype == ?GOODS_SUBTYPE_HEAD3 orelse Subtype == ?GOODS_SUBTYPE_HEAD4 ->
            case data_head:get(GoodsId) of
                [] -> [];
                Base ->
                    ?IF_ELSE(Base#base_head.goods_id == 0, [], [Base#base_head.goods_id, Base#base_head.goods_num])
            end;
        Subtype == ?GOODS_SUBTYPE_BUBBLE1 orelse Subtype == ?GOODS_SUBTYPE_BUBBLE2 orelse Subtype == ?GOODS_SUBTYPE_BUBBLE3 orelse Subtype == ?GOODS_SUBTYPE_BUBBLE4 ->
            case data_bubble:get(GoodsId) of
                [] -> [];
                Base ->
                    ?IF_ELSE(Base#base_bubble.goods_id == 0, [], [Base#base_bubble.goods_id, Base#base_bubble.goods_num])
            end;
        Subtype == ?GOODS_SUBTYPE_DESIGNATION1 orelse Subtype == ?GOODS_SUBTYPE_DESIGNATION2 orelse Subtype == ?GOODS_SUBTYPE_DESIGNATION3 orelse Subtype == ?GOODS_SUBTYPE_DESIGNATION4 ->
            case data_designation:get(GoodsId) of
                [] -> [];
                Base ->
                    ?IF_ELSE(Base#base_designation.goods_id == 0, [], [Base#base_designation.goods_id, Base#base_designation.goods_num])
            end;
        Subtype == ?GOODS_SUBTYPE_DECORATION1 orelse Subtype == ?GOODS_SUBTYPE_DECORATION2 orelse Subtype == ?GOODS_SUBTYPE_DECORATION3 orelse Subtype == ?GOODS_SUBTYPE_DECORATION4 ->
            case data_decoration:get(GoodsId) of
                [] -> [];
                Base ->
                    ?IF_ELSE(Base#base_decoration.goods_id == 0, [], [Base#base_decoration.goods_id, Base#base_decoration.goods_num])
            end;

        true ->
            []
    end.

%%卖出物品
sell_goods(Player, GoodsList) ->
    %%     给予的物品
    BackGoodsList =
        lists:foldl(fun([GoodsKey, DelNum], AccGiveGoods) ->
            GoodsInfo = goods_util:get_goods(GoodsKey),
            case data_goods:get(GoodsInfo#goods.goods_id) of
                #goods_type{drop_give_list = DropGiveGoods} ->
                    GoodsList2 = [{GoodsId, GoodsNum * DelNum} || {GoodsId, GoodsNum} <- DropGiveGoods],
                    GoodsList2 ++ AccGiveGoods;
                _ ->
                    AccGiveGoods
            end
                    end, [], GoodsList),
    L = [{Key, DelNum} || [Key, DelNum] <- GoodsList],
    goods_util:reduce_goods_key_list(Player, L, 564),
    case BackGoodsList /= [] of
        true ->
            GiveGoodsList = goods:make_give_goods_list(571, BackGoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList);
        _ ->
            NewPlayer = Player
    end,
    {ok, NewPlayer}.


make_give_goods_list(From, List) ->
    Fun = fun(Tuple, Out) ->
        case Tuple of
            GiveGoods when is_record(GiveGoods, give_goods) ->
                [GiveGoods#give_goods{from = From, goods_type = #goods_type{}} | Out];
            {Id, Num} ->
                [#give_goods{goods_id = Id, num = Num, from = From} | Out];
            [Id, Num] ->
                [#give_goods{goods_id = Id, num = Num, from = From} | Out];
            {Id, Num, Bind} ->
                [#give_goods{goods_id = Id, num = Num, bind = Bind, from = From} | Out];
            {Id, Num, Bind, ExpireTime} ->
                [#give_goods{goods_id = Id, num = Num, bind = Bind, expire_time = ExpireTime, from = From} | Out];
            {GoodsType, Num, Location, Bind, Args} ->
                [#give_goods{goods_id = GoodsType, num = Num, bind = Bind, from = From, location = Location, args = Args} | Out];
            {GoodsType, Num, Location, Bind, ExpireTime, Args} ->
                [#give_goods{goods_id = GoodsType, num = Num, bind = Bind, expire_time = ExpireTime, from = From, location = Location, args = Args} | Out];
            OtherGoods ->
                ?ERR("make_give_goods_list ~p ~n", [OtherGoods]),
                Out
        end
          end,
    lists:foldl(Fun, [], List).


pack_goods(GoodsList) ->
    F = fun(Goods) ->
        case Goods of
            GiveGoods when is_record(GiveGoods, give_goods) ->
                [[GiveGoods#give_goods.goods_id, GiveGoods#give_goods.num]];
            {GoodsId, Num} -> [[GoodsId, Num]];
            {GoodsId, Num, _Bind} -> [[GoodsId, Num]];
            [GoodsId, Num] -> [[GoodsId, Num]];
            [GoodsId, Num, _Bind] -> [[GoodsId, Num]];
            Other -> ?ERR("pack_goods ~p ~n", [Other]), []
        end
        end,
    lists:flatmap(F, GoodsList).

merge_goods(GoodsList) ->
    F = fun({Gid, Num}, L) ->
        case lists:keyfind(Gid, 1, L) of
            false -> [{Gid, Num} | L];
            {_, Count} ->
                lists:keyreplace(Gid, 1, L, {Gid, Count + Num})
        end
        end,
    lists:foldl(F, [], GoodsList).


merge_give_goods(GoodsList) ->
    F = fun(GiveGoods, L) ->
        case lists:keytake(GiveGoods#give_goods.goods_id, #give_goods.goods_id, L) of
            false -> [GiveGoods | L];
            {value, GiveGoods1, T} ->
                if GiveGoods1#give_goods.bind == GiveGoods#give_goods.bind andalso GiveGoods1#give_goods.expire_time == GiveGoods#give_goods.expire_time ->
                    [GiveGoods1#give_goods{num = GiveGoods1#give_goods.num + GiveGoods#give_goods.num} | T];
                    true ->
                        [GiveGoods | L]
                end
        end
        end,
    lists:foldl(F, [], GoodsList).

%% 锁定物品
goods_lock(Player, GoodsKey) ->
    case catch goods_util:get_goods(GoodsKey) of
        Goods when is_record(Goods, goods) ->
            NewGoods = Goods#goods{lock = 1},
            GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
            NewGoodsStatus = goods_dict:update_goods(NewGoods, GoodsStatus),
            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
            goods_load:dbup_goods_lock(NewGoods),
            goods_pack:pack_send_goods_info(NewGoods, GoodsStatus#st_goods.sid),
            {1, Player};
        {false, Code} ->
            {Code, Player}
    end.

%% 解锁物品
goods_unlock(Player, GoodsKey) ->
    case catch goods_util:get_goods(GoodsKey) of
        Goods when is_record(Goods, goods) ->
            NewGoods = Goods#goods{lock = 0},
            GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
            NewGoodsStatus = goods_dict:update_goods(NewGoods, GoodsStatus),
            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
            goods_load:dbup_goods_lock(NewGoods),
            goods_pack:pack_send_goods_info(NewGoods, GoodsStatus#st_goods.sid),
            {1, Player};
        {false, Code} ->
            {Code, Player}
    end.


%% 物品随机属性
goods_attr_info(Player, GoodsKey) ->
    case catch goods_util:get_goods(GoodsKey) of
        Goods when is_record(Goods, goods) ->
            BinData = {
                Goods#goods.color,
                Goods#goods.sex,
                Goods#goods.combat_power,
                [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- Goods#goods.fix_attrs],
                [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- Goods#goods.random_attrs]
            },
            {ok, Bin} = pt_150:write(15028, BinData),
            server_send:send_to_sid(Player#player.sid, Bin);
        _ ->
            ok
    end.


test(_) ->
    ok.

add_goods_act_task(InfoList) ->
    F = fun(#give_goods{goods_id = GoodsId}) ->
        case data_goods:get(GoodsId) of
            #goods_type{type = Type} when Type == ?GOODS_TYPE_XIAN_LING ->
                Count = goods_util:get_goods_count(GoodsId),
                task_event:event(?TASK_ACT_GET_GOODS, {GoodsId, Count}),
                ok;
            _ ->
                skip
        end
        end,
    lists:map(F, InfoList).

%%新号礼品
new_role_gift(Player) ->
    case player_util:is_new_role(Player) andalso version:get_lan_config() == korea of
        true ->
            goods:give_goods(Player, goods:make_give_goods_list(0, [{8601000, 1}])),
            case http_get_card_id(Player#player.key) of
                false -> skip;
                CardId ->
                    Title = "크로스이벤트",
                    Content = "문피아 크로스 이벤트 기념
                               할인쿠폰 증정!
                               상세 내용은 공식카페에서 확인하세요!
                               ~s
                               ",
                    Content1 = io_lib:format(Content, [CardId]),
                    mail:sys_send_mail([Player#player.key], Title, Content1)
            end,
            ok;
        false -> skip
    end,
    ok.


http_get_card_id(Pkey) ->
    ApiUrl =
        config:get_api_url(),
    Url = lists:concat([ApiUrl, "/get_card.php"]),
    Now = util:unixtime(),
    Key = "gat_card_auth",
    Sign = util:md5(io_lib:format("~p~s", [Now, Key])),
    U0 = io_lib:format("?pkey=~p&time=~p&sign=~s", [Pkey, Now, Sign]),
    U = lists:concat([Url, U0]),
    Ret = httpc:request(get, {U, []}, [{timeout, 2000}], []),
    case Ret of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, Data}, _} ->
                    case lists:keyfind("card", 1, Data) of
                        {_, Card} ->
                            util:make_sure_list(Card);
                        _ -> false
                    end;
                _ -> false
            end;
        _ ->
            false
    end.

