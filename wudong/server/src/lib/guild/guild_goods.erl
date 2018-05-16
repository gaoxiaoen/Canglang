%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 家园特殊效果物品
%%% @end
%%% Created : 05. 五月 2017 上午10:42
%%%-------------------------------------------------------------------
-module(guild_goods).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("guild.hrl").
-include("scene.hrl").

%% API
-export([
    use_goods/3,
    use_goods_with_target/4
]).

use_goods(Player, GoodsTypeId, Num) ->
    Base = data_goods_effect:get(GoodsTypeId),
    case Base of
        [] ->
            ?ERR("can not find guild_goods_effect data ~p~n",[ GoodsTypeId]),
            Player;
        _ ->
            case do_use_goods(Player, Base, Num, []) of
                {ok, NewPlayer} -> NewPlayer;
                _ -> Player
            end

    end.

%%使用有目标的特效物品
use_goods_with_target(Player, GoodsId, Num, PkeyList) ->
    case check_use_goods_with_target(Player, GoodsId, Num, PkeyList) of
        {false, Res} ->
            {ok, Bin} = pt_150:write(15022, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            Player;
        ok ->
            goods:subtract_good(Player, [{GoodsId, Num}], 515),
            {ok, Bin} = pt_150:write(15022, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, Bin1} = pt_120:write(12048, {Player#player.key, GoodsId, PkeyList}),
            server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin1),
            Player
    end.
check_use_goods_with_target(_Player, GoodsId, Num, _PkeyList) ->
    Base = data_goods_effect:get(GoodsId),
    GoodsCount = goods_util:get_goods_count(GoodsId),
    if
        Base == [] ->
            {false, 0};
        GoodsCount < Num orelse GoodsCount =< 0 ->
            {false, 9};
        true ->
            #base_goods_effect{
                target_num = TargetNum
            } = Base,
            if
                TargetNum =< 0 -> {false, 0};
                true ->
                    ok
            end
    end.

%%增加buff
do_use_goods(Player, Base, _Num, _Args) when Base#base_goods_effect.buff_id =/= 0 ->
    BuffId =
        case Base#base_goods_effect.buff_id of
            Tuple when is_tuple(Base#base_goods_effect.buff_id) ->
                util:list_rand(tuple_to_list(Tuple));
            Id -> Id
        end,
    case data_buff:get(BuffId) of
        [] ->
            ?ERR("can not find buff when use effect_goods ~p~n",
                [{Base#base_goods_effect.goods_id, BuffId}]),
            ok;
        _ ->
            buff_init:add_buff(BuffId),
            NewPlayer = buff:add_buff_to_player(Player, BuffId),
            {ok, NewPlayer}
    end;
%%创建怪物
do_use_goods(Player, Base, Num, _Args) when Base#base_goods_effect.mon_id > 0 ->
    #base_goods_effect{
        mon_id = MonId,
        goods_id = GoodsId
    } = Base,
    case data_mon:get(MonId) of
        [] ->
            ?ERR("can not find mon when use effect_goods ~p~n",
                [{GoodsId, MonId}]),
            ok;
        _ ->
            XYList = scene:get_area_position_list(Player#player.scene, Player#player.x, Player#player.y),
            F = fun(_N, [{X, Y}|Tail]) ->
                    mon_agent:create_mon_cast([MonId, Player#player.scene, X, Y, Player#player.copy, 1, []]),
                    Tail
                end,
            lists:foldl(F, XYList, lists:seq(1, Num)),
            ok
    end.