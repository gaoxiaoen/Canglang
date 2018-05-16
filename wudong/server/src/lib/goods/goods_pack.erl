%% @author and_me
%% @doc @todo Add description to goods_pack.


-module(goods_pack).
-include("common.hrl").
-include("goods.hrl").


%%打包并且推送消息
-export([pack_send_goods_info/2,
    pack_send_all_goods_info/3]).

%%仅仅是打包数据
-export([pack_goods_info_bin/1,
    pack_goods_list/1,
    pack_whouse_goods_list/1]).

pack_send_goods_info(_, undefined) ->
    ok;

pack_send_goods_info(GoodsInfo, Sid) when is_record(GoodsInfo, goods) ->
    pack_send_goods_info([GoodsInfo], Sid);

pack_send_goods_info([], _Sid) ->
    ok;
pack_send_goods_info(GoodsInfoList, Sid) ->
    GoodsUpdateBin = pack_goods_info_bin(GoodsInfoList),
    server_send:send_to_sid(Sid, GoodsUpdateBin).

%% 打包物品信息
pack_goods_info_bin(GoodsInfoList) ->
    GoodsList = pack_goods_list(GoodsInfoList),
    {ok, Bin} = pt_150:write(15002, {GoodsList}),
    Bin.


pack_goods_list(GoodsList) ->
    Now = util:unixtime(),
    F = fun(Goods) ->
            if Goods#goods.location =< 0 -> [];
    %%            Goods#goods.expire_time > 0 andalso Goods#goods.expire_time < Now -> [];
                true ->
                    [pack_goods(Goods, Now)]
            end
        end,
    lists:flatmap(F, GoodsList).

pack_whouse_goods_list(GoodsList) ->
    Now = util:unixtime(),
    F = fun(Goods) ->
        if
            Goods#goods.location > 0 -> [];
%%            Goods#goods.expire_time > 0 andalso Goods#goods.expire_time < Now -> [];
            true ->
                [pack_goods(Goods, Now)]
        end
        end,
    lists:flatmap(F, GoodsList).

pack_goods(Goods, _Now) ->
%%    ExpireTime = ?IF_ELSE(Goods#goods.expire_time > Now, Goods#goods.expire_time - Now, 0),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    [Goods#goods.key,
        Goods#goods.location,
        Goods#goods.goods_id,
        Goods#goods.num,
        Goods#goods.bind,
        Goods#goods.expire_time,
        Goods#goods.goods_lv,
        Goods#goods.stren,
        Goods#goods.star,
        Goods#goods.exp, %% 经验类
        Goods#goods.god_forging, %% 神炼等级
        Goods#goods.level, %% 升级等级
        Goods#goods.cell, %% 位置类
        Goods#goods.lock, %% 锁定状态
        Goods#goods.wear_key, %% 附属在某一宠物或者神祇上
        [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- Goods#goods.wash_attr],
        [[attribute_util:attr_tans_client(Type), Value, equip_refine:get_count(Type, Value)] || {Type, Value} <- Goods#goods.refine_attr],
        [[Type, Value] || {Type, Value} <- Goods#goods.gemstone_groove],
        equip_magic:get_magic_info(GoodsType#goods_type.subtype),
        equip_soul:get_soul_info(GoodsType#goods_type.subtype),
        ?IF_ELSE(Goods#goods.color == 0, GoodsType#goods_type.color, Goods#goods.color),
        ?IF_ELSE(Goods#goods.sex == 0, GoodsType#goods_type.sex, Goods#goods.sex),
        Goods#goods.combat_power,
        [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- Goods#goods.fix_attrs],
        [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- Goods#goods.random_attrs],
        [[attribute_util:attr_tans_client(Type), Value, Color] || {Type, Value, Color} <- Goods#goods.xian_wash_attr],
        [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- Goods#goods.god_soul_attr]
    ].

pack_send_all_goods_info(_Lo, _, _) ->
    io:format("pack_send_all_goods_info ~p ~n", [_Lo]),
    ok.
