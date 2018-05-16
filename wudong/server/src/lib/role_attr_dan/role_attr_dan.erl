%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 十一月 2017 13:38
%%%-------------------------------------------------------------------
-module(role_attr_dan).
-author("Administrator").
-include("daily.hrl").
-include("goods.hrl").
-include("player_mask.hrl").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    get_type_info/1,
    get_goods_info/2,
    use_attr_dan/2,
    get_attribute/0
]).

get_type_info(_Player) ->
    BaseList = get_all(),
    F = fun(Base) ->
        UseCount = player_mask:get(?PLAYER_ROLE_ATTR_DAN(Base#base_role_attr_dan.type, Base#base_role_attr_dan.id), 0),
        Attr = [{Attr, Val * UseCount} || {Attr, Val} <- Base#base_role_attr_dan.attr_list],
        [Base#base_role_attr_dan.type,
            Base#base_role_attr_dan.id,
            Base#base_role_attr_dan.goods_id,
            daily:get_count(?DAILY_ROLE_ATTR_DAN(Base#base_role_attr_dan.type, Base#base_role_attr_dan.id)),
            Base#base_role_attr_dan.daily_limit,
            UseCount,
            Base#base_role_attr_dan.max_count,
            attribute_util:calc_combat_power(attribute_util:make_attribute_by_key_val_list(Attr)),
            attribute_util:pack_attr(Attr)
        ]
    end,
    lists:map(F, BaseList).

get_goods_info(_Player, GoodsId) ->
    Base = data_role_attr_dan:get(GoodsId),
    {
        daily:get_count(?DAILY_ROLE_ATTR_DAN(Base#base_role_attr_dan.type, Base#base_role_attr_dan.id)),
        Base#base_role_attr_dan.daily_limit,
        Base#base_role_attr_dan.max_count
    }.

use_attr_dan(Player, Type) ->
    BaseList = get_by_type(Type),
    F = fun(Base) ->
        GoodsId = Base#base_role_attr_dan.goods_id,
        Id = Base#base_role_attr_dan.id,
        Count = goods_util:get_goods_count(GoodsId),
        if
            Count =< 0 -> skip;
            true ->
                TotalUse = player_mask:get(?PLAYER_ROLE_ATTR_DAN(Type, Id), 0),
                TotalCanUse = max(0, Base#base_role_attr_dan.max_count - TotalUse),
                DailyCanUse = max(0, Base#base_role_attr_dan.daily_limit - daily:get_count(?DAILY_ROLE_ATTR_DAN(Type, Id))),
                UseCount = max(0, min(DailyCanUse, min(Count, TotalCanUse))),
                player_mask:set(?PLAYER_ROLE_ATTR_DAN(Type, Id), TotalUse + UseCount),
                daily:increment(?DAILY_ROLE_ATTR_DAN(Type, Id), UseCount),
                ?DO_IF(UseCount > 0, log_role_attr_dan(Player#player.key, Player#player.nickname, Type, Id, GoodsId, UseCount)),
                goods:subtract_good(Player, [{GoodsId, UseCount}], 572) %% 扣除属性丹
        end
    end,
    lists:foreach(F, BaseList),
    NewPlayer = player_util:count_player_attribute(Player, true),
    {ok, NewPlayer}.

get_by_type(Type) ->
    GoodsIds = data_role_attr_dan:get_all(),
    F = fun(GoodsId) ->
        Base = data_role_attr_dan:get(GoodsId),
        if
            Base#base_role_attr_dan.type == Type -> [Base];
            true -> []
        end
    end,
    lists:flatmap(F, GoodsIds).

get_all() ->
    GoodsIds = data_role_attr_dan:get_all(),
    [data_role_attr_dan:get(X) || X <- GoodsIds].

get_attribute() ->
    BaseList = get_all(),
    F = fun(Base) ->
        UseCount = player_mask:get(?PLAYER_ROLE_ATTR_DAN(Base#base_role_attr_dan.type, Base#base_role_attr_dan.id), 0),
        [{Attr, Val * UseCount} || {Attr, Val} <- Base#base_role_attr_dan.attr_list]
    end,
    Attribute = lists:flatmap(F, BaseList),
    attribute_util:make_attribute_by_key_val_list(Attribute).

log_role_attr_dan(Pkey, Nickname, Type, NumId, GoodsId, UseCount) ->
    Sql = io_lib:format("insert into  log_role_attr_dan (pkey, nickname,type,num_id,goods_id,use_count,time) VALUES(~p,'~s',~p,~p,~p,~p,~p)",
        [Pkey, Nickname, Type, NumId, GoodsId, UseCount, util:unixtime()]),
    log_proc:log(Sql),
    ok.

