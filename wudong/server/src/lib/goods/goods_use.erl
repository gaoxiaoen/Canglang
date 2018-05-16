%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 物品使用
%%% @end
%%% Created : 16. 一月 2015 19:50
%%%-------------------------------------------------------------------
-module(goods_use).
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("equip.hrl").
-include("mount.hrl").
-include("fashion.hrl").
-include("bubble.hrl").
-include("wing.hrl").
-include("designation.hrl").
-include("head.hrl").
-include("dungeon.hrl").
-include("magic_weapon.hrl").
-include("light_weapon.hrl").
-include("pet_weapon.hrl").
-include("footprint_new.hrl").
-include("cat.hrl").
-include("golden_body.hrl").
-include("baby_wing.hrl").
-include("baby_mount.hrl").
-include("baby_weapon.hrl").
-include("jade.hrl").
-include("god_treasure.hrl").
%% API
-export([
%%    filter_transform_goods/2,
    direct_use_virtual_goods/3,
    filter_goods_direct/1,  %%直接使用物品
    use_goods/3,             %%物品使用
    use_goods/4,             %%物品使用
    use_goods_by_goods_id/3, %%物品使用
    use_goods_by_goods_id/4, %%物品使用
    open_gift_bag/4,
    sub_goods_before_use/2
]).


%%filter_transform_goods(_Player, GoodsList) ->
%%    Fun = fun(AddGoods, GiveGoodsOut) ->
%%        case data_goods:get(AddGoods#give_goods.goods_id) of
%%            [] -> GiveGoodsOut;
%%            GoodsType ->
%%                [AddGoods#give_goods{goods_type = GoodsType}]
%%        end
%%          end,
%%    lists:foldl(Fun, [], GoodsList).

filter_goods_direct(GoodsList) ->
    Fun = fun(AddGoods, {DirectUseGoodsList, NotDirectUseGoodsList}) ->
        case AddGoods#give_goods.goods_type#goods_type.use_panel =:= ?GOODS_USE_DIRECT of
            true ->
                {[AddGoods | DirectUseGoodsList], NotDirectUseGoodsList};
            false ->
                {DirectUseGoodsList, [AddGoods | NotDirectUseGoodsList]}
        end
    end,
    lists:foldl(Fun, {[], []}, GoodsList).


direct_use_virtual_goods([], Player, GoodsSt) ->


    {Player, GoodsSt};
direct_use_virtual_goods([GiveGoods | DirectGoodsList], Player, GoodsSt) ->
    GoodsTypeInfo = GiveGoods#give_goods.goods_type,
    case catch use_goods_routing(GoodsSt, Player, GoodsTypeInfo, GiveGoods#give_goods.num, [], GiveGoods#give_goods.from) of
        {ok, NewGoodsSt, NewPlayer} ->
            direct_use_virtual_goods(DirectGoodsList, NewPlayer, NewGoodsSt);
        Other ->
            ?ERR("direct_use_virtual_goods error ~p ~n : ~p ~n", [GiveGoods#give_goods.goods_id, Other]),
            direct_use_virtual_goods(DirectGoodsList, Player, GoodsSt)
    end.


%%%%使用物品（在做任务时，经验，银币等虚拟物品将会直接转化为数值）
%%可调用进程：玩家进程
%%返回值：抛 {false, Res}形式异常|{ok,Player}

use_goods(Player, GoodsKey, Num0) ->
    use_goods(Player, GoodsKey, Num0, []).

use_goods(Player, GoodsKey, Num0, SGoodsList) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsInfo = goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict),
    Now = util:unixtime(),
    Time = GoodsInfo#goods.expire_time,
    if
        Time < Now andalso Time /= 0 ->
            {false, 48};
        true ->
            %% 800001
            GoodsType = data_goods:get(GoodsInfo#goods.goods_id),
            Num = check_goods_use(Player, GoodsType, Num0),
            {GoodsInfo1, GoodsSt1} = use_reduce_goods_num(GoodsSt, GoodsInfo, Num), %%扣除物品，use_goods_routing中如果有任何错误发生，将会抛出异常，扣除的物品不会保存进数据库
            use_goods_db_update(GoodsInfo1),
            goods_pack:pack_send_goods_info([GoodsInfo1], Player#player.sid),
            goods_util:log_goods_use(Player#player.key, Player#player.nickname, GoodsType#goods_type.goods_id, Num, 1547, Now, Time),
            case catch use_goods_routing(GoodsSt1, Player, GoodsType, Num, SGoodsList, 54) of
                {ok, GoodsSt2, NewPlayer} ->
                    lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
                    {ok, NewPlayer};
                {false, Err} ->
                    {false, Err};
                Other ->
                    ?ERR("use_goods error ~p ~p ~n", [GoodsInfo#goods.goods_id, Other]),
                    {ok, Player}
            end
    end.

use_goods_by_goods_id(Player, GoodsId, Num0) ->
    use_goods_by_goods_id(Player, GoodsId, Num0, []).

use_goods_by_goods_id(Player, GoodsId, Num0, SGoodsList) ->
    GoodsType = data_goods:get(GoodsId),
    ?DEBUG("GoodsId ~p~n", [GoodsId]),
    Num = check_goods_use(Player, GoodsType, Num0),
    goods:subtract_good_throw(Player, [{GoodsId, Num}], 1549),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch use_goods_routing(GoodsSt, Player, GoodsType, Num, SGoodsList, 54) of
        {ok, GoodsSt2, NewPlayer} ->
            lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
            {ok, NewPlayer};
        Other ->
            ?ERR("use_goods error ~p ~p ~n", [GoodsType#goods_type.goods_id, Other]),
            {ok, Player}
    end.

%%============================================内部函数============================================================

%%use_goods_routing本身在goods:give_goods中被调用
%%在这个函数里面如果要给玩家增加物品，不要要再调用goods:give_goods
%%而是参考礼包的实现方式，调用goods_util:give_goods 返回相应的新状态

use_goods_routing(GoodsSt, Player, GoodsTypeInfo, Num, SGoodsList, AddReason) ->
    case GoodsTypeInfo#goods_type.subtype of
        ?GOODS_SUBTYPE_EXP ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = player_util:add_exp(Player, AddNum, AddReason),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_BCOIN ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_coin(Player, AddNum, AddReason, 0, 0),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_COIN ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_coin(Player, AddNum, AddReason, 0, 0),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_FAIRY_CRYSTAL ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:fairy_crystal(Player, AddNum),
            {ok, GoodsSt, NewPlayer};

        ?GOODS_SUBTYPE_GOLD ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_gold(Player, AddNum, AddReason, 0, 0),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_SWEET ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_sweet(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_EQUIP_PART ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_equip_part(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ACT_GOLD ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_act_gold(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_BGOLD ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_bind_gold(Player, AddNum, AddReason, 0, 0),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_XINGHUN ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_xinghun(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_REIKI ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_reiki(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_GUILD_CONTRIB_GOODS ->
            guild_dedicate:sys_add_guild_dedicate(Player, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_GUILD_VIGOR ->
%%            Vigor = GoodsTypeInfo#goods_type.special_param_list * Num,
%%            guild_util:add_vigor_by_key(Player#player.guild#st_guild.guild_key, Player#player.key, Vigor, 3),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_PET_CARD ->
            Args = GoodsTypeInfo#goods_type.special_param_list,
            case lists:keyfind(petid, 1, Args) of
                false ->
                    ?ERR("create pet by use goods err ~p~n", [Args]),
                    {ok, GoodsSt, Player};
                {_, PetTypeId} ->
                    F = fun(_N, P) ->
                        goods_util:client_popup_get_oods(Player, 1, PetTypeId),
                        case lists:keyfind(lv, 1, Args) of
                            false -> Star = 0;
                            {_, Star} -> ok
                        end,
                        pet_util:create_pet(P, PetTypeId, Star)
                    end,
                    NewPlayer = lists:foldl(F, Player, lists:seq(1, Num)),
                    {ok, GoodsSt, NewPlayer}
            end;
        ?GOODS_SUBTYPE_EXPLOIT_PRI ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_exploit_pri(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_MANOR_PT ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_manor_pt(Player, AddNum, 1, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_FASHION1 ->
            NewPlayer = fashion:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_FASHION2 ->
            NewPlayer = fashion:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_FASHION3 ->
            NewPlayer = fashion:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_FASHION4 ->
            NewPlayer = fashion:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_HEAD1 ->
            NewPlayer = head:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_HEAD2 ->
            NewPlayer = head:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_HEAD3 ->
            NewPlayer = head:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_HEAD4 ->
            NewPlayer = head:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_BUBBLE1 ->
            NewPlayer = bubble:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_BUBBLE2 ->
            NewPlayer = bubble:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_BUBBLE3 ->
            NewPlayer = bubble:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_BUBBLE4 ->
            NewPlayer = bubble:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_DECORATION1 ->
            NewPlayer = decoration:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_DECORATION2 ->
            NewPlayer = decoration:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_DECORATION3 ->
            NewPlayer = decoration:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_DECORATION4 ->
            NewPlayer = decoration:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_GIFT_BAG ->
            {Player1, GiveGoodsList} = open_gift_bag_loop(Player, [{GoodsTypeInfo#goods_type.goods_id, Num, SGoodsList}], AddReason, []),
            {ok, NewGoodsSt, NewPlayer} = goods_util:give_goods(GoodsSt, Player1, GiveGoodsList, true),
            {ok, NewGoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_FUWEN_GIFT_BAG ->
            {Player1, GiveGoodsList} = open_gift_bag_loop(Player, [{GoodsTypeInfo#goods_type.goods_id, Num}], AddReason, []),
            {ok, NewGoodsSt, NewPlayer} = goods_util:give_goods(GoodsSt, Player1, GiveGoodsList, true),
            fuwen:notice_client(NewPlayer, GiveGoodsList, GoodsTypeInfo#goods_type.goods_id),
            {ok, NewGoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_VIP_CARD ->
            NewPlayer = vip:use_vip_card(Player, GoodsTypeInfo, Num),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_WEEK_CARD ->
            NewPlayer = charge_week_card:use_week_card(Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ARENA_PT ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_arena_pt(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_DIVINE ->
            AddNum = GoodsTypeInfo#goods_type.special_param_list * Num,
            NewPlayer = money:add_arena_pt(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
%%        ?GOODS_SUBTYPE_MOUNT_CARD ->
%%            {ok, NewPlayer} = mount:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
%%            {ok, GoodsSt, NewPlayer};
%%         ?GOODS_SUBTYPE_PET_HALO_EXP ->
%%             NewPlayer = pet_halo:use_goods_add_exp(Player, GoodsTypeInfo, Num),
%%             {ok, GoodsSt, NewPlayer};
%%        ?GOODS_SUBTYPE_SIN ->
%%            NewPlayer = player_util:add_sin(GoodsTypeInfo#goods_type.special_param_list * Num, Player),
%%            scene_agent_dispatch:exskill_update(NewPlayer),
%%            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ADD_WING ->
            NewPlayer = wing:activate_wing_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            scene_agent_dispatch:wing_update(NewPlayer),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_DESIGNATION1 ->
            NewPlayer = designation:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_DESIGNATION2 ->
            NewPlayer = designation:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_DESIGNATION3 ->
            NewPlayer = designation:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_DESIGNATION4 ->
            NewPlayer = designation:activate_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_UP_LV ->
            F = fun(_, AccPlayer) ->
                player_util:goods_add_lv(AccPlayer, GoodsTypeInfo#goods_type.special_param_list)
            end,
            NewPlayer = lists:foldl(F, Player, lists:seq(1, Num)),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_UP_TO_LV ->
            F = fun(_, AccPlayer) ->
                player_util:goods_add_to_lv(AccPlayer, GoodsTypeInfo#goods_type.special_param_list)
            end,
            NewPlayer = lists:foldl(F, Player, lists:seq(1, Num)),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_UP_STAGE_MOUNT ->
            F = fun(_, {AccPlayer, L}) ->
                mount_stage:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(222, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_MOUNT ->
            F = fun(_, {AccPlayer, L}) ->
                mount_stage:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(222, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_MOUNT_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                mount_stage:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(222, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_WING ->
            F = fun(_, {AccPlayer, L}) ->
                wing_stage:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(223, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_BABY_WING ->
            F = fun(_, {AccPlayer, L}) ->
                baby_wing_stage:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(223, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_WING_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                wing_stage:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(223, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_BABY_WING_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                baby_wing_stage:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(223, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_WING ->
            F = fun(_, {AccPlayer, L}) ->
                wing_stage:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(223, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_BABY_WING ->
            F = fun(_, {AccPlayer, L}) ->
                baby_wing_stage:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(223, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_MAGIC_WEAPON ->
            F = fun(_, {AccPlayer, L}) ->
                magic_weapon:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(224, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_MAGIC_WEAPON ->
            F = fun(_, {AccPlayer, L}) ->
                magic_weapon:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(224, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_MAGIC_WEAPON_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                magic_weapon:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(224, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_LIGHT_WEAPON ->
            F = fun(_, {AccPlayer, L}) ->
                light_weapon:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(225, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_LIGHT_WEAPON_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                light_weapon:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(225, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_LIGHT_WEAPON ->
            F = fun(_, {AccPlayer, L}) ->
                light_weapon:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(225, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_PET_WEAPON ->
            F = fun(_, {AccPlayer, L}) ->
                pet_weapon:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(226, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_PET_WEAPON_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                pet_weapon:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(226, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_PET_WEAPON ->
            F = fun(_, {AccPlayer, L}) ->
                pet_weapon:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(226, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_FOOTPRINT ->
            F = fun(_, {AccPlayer, L}) ->
                footprint:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(246, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_FOOTPRINT_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                footprint:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(246, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_FOOTPRINT ->
            F = fun(_, {AccPlayer, L}) ->
                footprint:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(246, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_CAT ->
            F = fun(_, {AccPlayer, L}) ->
                cat:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(271, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_CAT_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                cat:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(271, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_CAT ->
            F = fun(_, {AccPlayer, L}) ->
                cat:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(271, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};

        ?GOODS_SUBTYPE_UP_STAGE_GOLDEN_BODY ->
            F = fun(_, {AccPlayer, L}) ->
                golden_body:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(281, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
%%         ?GOODS_SUBTYPE_UP_TO_STAGE_GOD_TREASURE ->
%%             F = fun(_, {AccPlayer, L}) ->
%%                 god_treasure:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
%%             end,
%%             {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
%%             {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(323, GoodsList), true),
%%             {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_JADE ->
            F = fun(_, {AccPlayer, L}) ->
                jade:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(322, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_GOD_TREASURE ->
            F = fun(_, {AccPlayer, L}) ->
                jade:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(323, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_GOLDEN_BODY_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                golden_body:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(281, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_GOD_TREASURE_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                god_treasure:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(323, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_JADE_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                jade:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(322, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_GOLDEN_BODY ->
            F = fun(_, {AccPlayer, L}) ->
                golden_body:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(281, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
%%         ?GOODS_SUBTYPE_UP_TO_STAGE_JADE ->
%%             F = fun(_, {AccPlayer, L}) ->
%%                 jade:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
%%             end,
%%             {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
%%             {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(322, GoodsList), true),
%%             {ok, NewGoodsSt, NewPlayer1};

        ?GOODS_SUBTYPE_UP_STAGE_BABY_MOUNT ->
            F = fun(_, {AccPlayer, L}) ->
                baby_mount:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(553, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_BABY_MOUNT_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                baby_mount:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(553, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_BABY_MOUNT ->
            F = fun(_, {AccPlayer, L}) ->
                baby_mount:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(553, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};

        ?GOODS_SUBTYPE_UP_STAGE_BABY_WEAPON ->
            F = fun(_, {AccPlayer, L}) ->
                baby_weapon:goods_add_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(557, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_STAGE_BABY_WEAPON_LIMIT ->
            F = fun(_, {AccPlayer, L}) ->
                baby_weapon:goods_add_stage_limit(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(557, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_UP_TO_STAGE_BABY_WEAPON ->
            F = fun(_, {AccPlayer, L}) ->
                baby_weapon:goods_add_to_stage(AccPlayer, GoodsTypeInfo#goods_type.special_param_list, L)
            end,
            {NewPlayer, GoodsList} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {ok, NewGoodsSt, NewPlayer1} = goods_util:give_goods(GoodsSt, NewPlayer, goods:make_give_goods_list(557, GoodsList), true),
            {ok, NewGoodsSt, NewPlayer1};
        ?GOODS_SUBTYPE_FREE_VIP_CARD ->
            NewPlayer = vip:use_free_vip_card(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_HONOUR ->
            AddNum = 1 * Num,
            NewPlayer = money:add_honor(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_REPUTE ->
            AddNum = 1 * Num,
            NewPlayer = money:add_repute(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_SD ->
            AddNum = 1 * Num,
            NewPlayer = money:add_sd_pt(Player, AddNum),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_INVEST_1 ->
            invest:buy_invest(Player, 1),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_INVEST_2 ->
            invest:buy_invest(Player, 2),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_RED_BAG ->
            F = fun(_) ->
                red_bag:use_red_bag(Player, GoodsTypeInfo#goods_type.goods_id)
            end,
            lists:foreach(F, lists:seq(1, Num)),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_RED_BAG_GUILD ->
            F = fun(_) ->
                red_bag:use_red_bag_guild(Player, GoodsTypeInfo#goods_type.goods_id)
            end,
            lists:foreach(F, lists:seq(1, Num)),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_RED_BAG_MARRY ->
            F = fun(_) ->
                red_bag:use_red_bag_marry(Player, GoodsTypeInfo#goods_type.goods_id)
            end,
            lists:foreach(F, lists:seq(1, Num)),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_ATTR_DAN ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_1 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_2 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_3 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_4 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_5 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_6 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_7 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_8 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_9 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_10 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_11 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_ATTR_DAN_12 ->
            {ok, NewPlayer} = goods_attr_dan:use_goods_add_attr(GoodsTypeInfo#goods_type.goods_id, Num, Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_CHARGE_CARD ->
            {ok, NewPlayer} = charge:use_recharge_card(Player, GoodsTypeInfo#goods_type.special_param_list, Num),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_MON_PHOTO ->
            mon_photo:add_by_goods(Player, GoodsTypeInfo#goods_type.special_param_list, Num),
            {ok, GoodsSt, Player};
%%        ?GOODS_SUBTYPE_CANCAL_CHANGE ->
%%            NewPlayer = fashion:cancel_change_body(Player),
%%            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_HP_POOL ->
            hp_pool:add_hp(GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_BUFF ->
            NewPlayer = buff:goods_add_buff(Player, GoodsTypeInfo#goods_type.special_param_list),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_FUWEN_EXP ->
            fuwen:goods_add_exp(Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_FUWEN_CHIP ->
            fuwen:goods_add_chip(Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_FAIRY_SOUL_EXP ->
            fairy_soul:goods_add_exp(Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_FAIRY_SOUL_CHIP ->
            fairy_soul:goods_add_chip(Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_UP_CHANGE_SEX ->
            NewPlayer = player_util:change_sex(Player),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_EFFECT_GOODS ->
            NewPlayer = guild_goods:use_goods(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, NewPlayer};
        ?GOODS_SUBTYPE_CREATE_BABY ->
            baby_util:player_marriage(Player, Player#player.marry#marry.couple_key),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_MOUNT_SPIRIT ->
            mount_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_WING_SPIRIT ->
            wing_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_MAGIC_WEAPON_SPIRIT ->
            magic_weapon_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_LIGHT_WEAPON_SPIRIT ->
            light_weapon_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_PET_WEAPON_SPIRIT ->
            pet_weapon_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_FOOTPRINT_SPIRIT ->
            footprint_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_CAT_SPIRIT ->
            cat_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_GOLDEN_BODY_SPIRIT ->
            golden_body_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_GOD_TREASURE_SPIRIT ->
            god_treasure_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_JADE_SPIRIT ->
            jade_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_BABY_WING_SPIRIT ->
            baby_wing_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_BABY_MOUNT_SPIRIT ->
            baby_mount_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_BABY_WEAPON_SPIRIT ->
            baby_weapon_spirit:add_spirit(Player, GoodsTypeInfo#goods_type.goods_id, Num),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_VIP_FACE_CARD ->
            vip_face:use_card(Player, GoodsTypeInfo#goods_type.goods_id),
            {ok, GoodsSt, Player};
        ?GOODS_SUBTYPE_GUILD_MEDAL ->
            guild_fight:add_guild_medal(Player#player.guild#st_guild.guild_key, Num),
            {ok, GoodsSt, Player};
        _ ->
            case GoodsTypeInfo#goods_type.subtype >= ?GOODS_SUBTYPE_STAR_LUCK_1
                andalso GoodsTypeInfo#goods_type.subtype =< ?GOODS_SUBTYPE_STAR_LUCK_9 of
                true ->
                    F = fun(_) ->
                        star_luck:add_xingyun_by_goods(Player, GoodsTypeInfo)
                    end,
                    lists:foreach(F, lists:seq(1, Num)),
                    {ok, GoodsSt, Player};
                false ->
                    {ok, GoodsSt, Player}
            end
    end.


use_reduce_goods_num(GoodsSt, GoodsInfo, Num) ->
    if
        Num =< 0 -> throw({false, ?ER_NOT_ENOUGH_GOODS_NUM});
        GoodsInfo#goods.num =:= Num -> %%数量刚好,直接删除物品
            NewDict = goods_dict:del_dict_goods(GoodsInfo, GoodsSt#st_goods.dict),
            NewGoodsSt = GoodsSt#st_goods{dict = NewDict, leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1},
            {GoodsInfo#goods{num = 0}, NewGoodsSt};
        GoodsInfo#goods.num > Num -> %%
            NewGoodsInfo = GoodsInfo#goods{num = GoodsInfo#goods.num - Num},
            NewDict = goods_dict:update_goods(NewGoodsInfo, GoodsSt#st_goods.dict),
            NewGoodsSt = GoodsSt#st_goods{dict = NewDict},
            {NewGoodsInfo, NewGoodsSt};
        true ->
            throw({false, ?ER_NOT_ENOUGH_GOODS_NUM})
    end.


use_goods_db_update(GoodsInfo) ->
    if
        GoodsInfo#goods.num > 0 ->
            goods_load:dbup_goods_num(GoodsInfo);
        GoodsInfo#goods.num =:= 0 ->%%如果数量为0，直接从数据库里面删除
            goods_load:dbdel_goods(GoodsInfo)
    end.


%%物品使用检查
check_goods_use(Player, GoodsType, Num) ->
    Subtype = GoodsType#goods_type.subtype,
    if
        GoodsType#goods_type.goods_id == 7304001 -> Res = 50;
        true -> Res = 27
    end,
    ?ASSERT(Player#player.lv >= GoodsType#goods_type.need_lv, {false, Res}),
    if
        Subtype =:= ?GOODS_SUBTYPE_GIFT_BAG -> %%有些礼包需要消耗元宝，所以需要事先验证元宝是否足够
            case data_gift_bag:get(GoodsType#goods_type.goods_id) of
                [] ->
                    ?ERR("gift_bag check_goods_use Error ~p ~n", [GoodsType#goods_type.goods_id]),
                    throw({false, 0}),
                    0;
                BaseGift ->
                    [Gold, _] = money:get_gold(Player#player.key),
                    ?ASSERT(Gold >= BaseGift#base_gift.need_gold * Num, {false, ?ER_NOT_ENOUGH_GOLD}),
                    %% 物品使用需要判断是否物品
                    case BaseGift#base_gift.need_goods of
                        [] ->
                            Num;
                        NeedGoodsList ->
                            lists:foreach(fun({NeedGoodsId, GoodsNum}) ->
                                Count = goods_util:get_goods_count(NeedGoodsId),
                                ?ASSERT(Count >= GoodsNum * Num, {false, ?ER_NOT_ENOUGH_NEED_GOODS_NUM})
                            end, NeedGoodsList),
                            Num
                    end
            end;
        Subtype =:= ?GOODS_SUBTYPE_ATTR_DAN orelse Subtype =:= ?GOODS_SUBTYPE_ATTR_DAN_1 orelse Subtype =:= ?GOODS_SUBTYPE_ATTR_DAN_2 orelse Subtype =:= ?GOODS_SUBTYPE_ATTR_DAN_3 orelse Subtype =:= ?GOODS_SUBTYPE_ATTR_DAN_4 orelse Subtype =:= ?GOODS_SUBTYPE_ATTR_DAN_5 orelse Subtype =:= ?GOODS_SUBTYPE_ATTR_DAN_6 orelse Subtype =:= ?GOODS_SUBTYPE_ATTR_DAN_7 orelse Subtype =:= ?GOODS_SUBTYPE_ATTR_DAN_8 ->
            NewNum = goods_attr_dan:use_goods_check(GoodsType#goods_type.goods_id, goods_util:get_goods_count(GoodsType#goods_type.goods_id), Player),
            NewNum;
        Subtype =:= ?GOODS_SUBTYPE_FASHION1 orelse Subtype =:= ?GOODS_SUBTYPE_FASHION2 orelse Subtype =:= ?GOODS_SUBTYPE_FASHION3 orelse Subtype =:= ?GOODS_SUBTYPE_FASHION4 ->
            case fashion:check_activate_by_goods(Player, GoodsType#goods_type.special_param_list) of
                true -> 1;
                Err -> throw(Err)
            end;
        Subtype =:= ?GOODS_SUBTYPE_HEAD1 orelse Subtype =:= ?GOODS_SUBTYPE_HEAD2 orelse Subtype =:= ?GOODS_SUBTYPE_HEAD3 orelse Subtype =:= ?GOODS_SUBTYPE_HEAD4 ->
            case head:check_activate_by_goods(Player, GoodsType#goods_type.special_param_list) of
                true -> 1;
                Err -> throw(Err)
            end;
        Subtype =:= ?GOODS_SUBTYPE_BUBBLE1 orelse Subtype =:= ?GOODS_SUBTYPE_BUBBLE2 orelse Subtype =:= ?GOODS_SUBTYPE_BUBBLE3 orelse Subtype =:= ?GOODS_SUBTYPE_BUBBLE4 ->
            case bubble:check_activate_by_goods(Player, GoodsType#goods_type.special_param_list) of
                true -> 1;
                Err -> throw(Err)
            end;
        Subtype =:= ?GOODS_SUBTYPE_DECORATION1 orelse Subtype =:= ?GOODS_SUBTYPE_DECORATION2 orelse Subtype =:= ?GOODS_SUBTYPE_DECORATION3 orelse Subtype =:= ?GOODS_SUBTYPE_DECORATION4 ->
            case decoration:check_activate_by_goods(Player, GoodsType#goods_type.special_param_list) of
                true -> 1;
                Err -> throw(Err)
            end;
        Subtype =:= ?GOODS_SUBTYPE_RED_BAG_GUILD ->
            case Player#player.guild#st_guild.guild_key == 0 of
                true -> throw({false, 35});
                false -> Num
            end;
        Subtype == ?GOODS_SUBTYPE_RED_BAG_MARRY ->
            if Player#player.marry#marry.mkey == 0 ->
                throw({false, 42});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_DESIGNATION1 orelse Subtype =:= ?GOODS_SUBTYPE_DESIGNATION2 orelse Subtype =:= ?GOODS_SUBTYPE_DESIGNATION3 orelse Subtype =:= ?GOODS_SUBTYPE_DESIGNATION4 ->
            case designation:check_activate_by_goods(Player, GoodsType#goods_type.special_param_list) of
                true -> 1;
                Err -> throw(Err)
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_MOUNT orelse Subtype =:= ?GOODS_SUBTYPE_UP_TO_STAGE_MOUNT ->
            Mount = lib_dict:get(?PROC_STATUS_MOUNT),
            if Mount#st_mount.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_GOD_TREASURE ->
            Mount = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
            if Mount#st_god_treasure.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_JADE ->
            Mount = lib_dict:get(?PROC_STATUS_JADE),
            if Mount#st_jade.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_MOUNT_LIMIT ->
            Mount = lib_dict:get(?PROC_STATUS_MOUNT),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if Mount#st_mount.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_WING orelse Subtype =:= ?GOODS_SUBTYPE_UP_TO_STAGE_WING ->
            Wing = lib_dict:get(?PROC_STATUS_WING),
            if Wing#st_wing.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_WING_LIMIT ->
            Wing = lib_dict:get(?PROC_STATUS_WING),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if Wing#st_wing.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_MAGIC_WEAPON orelse Subtype =:= ?GOODS_SUBTYPE_UP_TO_STAGE_MAGIC_WEAPON ->
            MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
            if MagicWeapon#st_magic_weapon.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_MAGIC_WEAPON_LIMIT ->
            MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if MagicWeapon#st_magic_weapon.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_LIGHT_WEAPON orelse Subtype =:= ?GOODS_SUBTYPE_UP_TO_STAGE_LIGHT_WEAPON ->
            LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
            if LightWeapon#st_light_weapon.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_LIGHT_WEAPON_LIMIT ->
            LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if LightWeapon#st_light_weapon.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_PET_WEAPON orelse Subtype =:= ?GOODS_SUBTYPE_UP_TO_STAGE_PET_WEAPON ->
            PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
            if PetWeapon#st_pet_weapon.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_PET_WEAPON_LIMIT ->
            PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if PetWeapon#st_pet_weapon.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_FOOTPRINT orelse Subtype =:= ?GOODS_SUBTYPE_UP_TO_STAGE_FOOTPRINT ->
            Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
            if Footprint#st_footprint.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_FOOTPRINT_LIMIT ->
            Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if Footprint#st_footprint.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_CAT_LIMIT ->
            Footprint = lib_dict:get(?PROC_STATUS_CAT),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if Footprint#st_cat.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_GOLDEN_BODY_LIMIT ->
            GoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if GoldenBody#st_golden_body.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_GOD_TREASURE_LIMIT ->
            GodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if GodTreasure#st_god_treasure.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_JADE_LIMIT ->
            Jade = lib_dict:get(?PROC_STATUS_JADE),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if Jade#st_jade.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_BABY_WING orelse Subtype =:= ?GOODS_SUBTYPE_UP_TO_STAGE_BABY_WING ->
            BabyWing = lib_dict:get(?PROC_STATUS_BABY_WING),
            if BabyWing#st_baby_wing.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_BABY_WING_LIMIT ->
            BabyWing = lib_dict:get(?PROC_STATUS_BABY_WING),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if BabyWing#st_baby_wing.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_CREATE_BABY ->
            case baby_util:is_has_baby(Player) of
                false -> Num;
                _ ->
                    throw({false, 47})
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_BABY_MOUNT orelse Subtype =:= ?GOODS_SUBTYPE_UP_TO_STAGE_BABY_MOUNT ->
            BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
            if BabyMount#st_baby_mount.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_BABY_MOUNT_LIMIT ->
            BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if BabyMount#st_baby_mount.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_BABY_WEAPON orelse Subtype =:= ?GOODS_SUBTYPE_UP_TO_STAGE_BABY_WEAPON ->
            BabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
            if BabyWeapon#st_baby_weapon.stage == 0 ->
                throw({false, 0});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_UP_STAGE_BABY_WEAPON_LIMIT ->
            BabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
            [{Stage, _}] = GoodsType#goods_type.special_param_list,
            if BabyWeapon#st_baby_weapon.stage < Stage ->
                throw({false, 40});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_MOUNT_SPIRIT ->
            Mount = lib_dict:get(?PROC_STATUS_MOUNT),
            if Mount#st_mount.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_WING_SPIRIT ->
            Wing = lib_dict:get(?PROC_STATUS_WING),
            if Wing#st_wing.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_MAGIC_WEAPON_SPIRIT ->
            MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
            if MagicWeapon#st_magic_weapon.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_LIGHT_WEAPON_SPIRIT ->
            LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
            if LightWeapon#st_light_weapon.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_PET_WEAPON_SPIRIT ->
            PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
            if PetWeapon#st_pet_weapon.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_FOOTPRINT_SPIRIT ->
            Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
            if Footprint#st_footprint.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_CAT_SPIRIT ->
            Cat = lib_dict:get(?PROC_STATUS_CAT),
            if Cat#st_cat.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_GOLDEN_BODY_SPIRIT ->
            GoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
            if GoldenBody#st_golden_body.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_GOD_TREASURE_SPIRIT ->
            GoldenBody = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
            if GoldenBody#st_god_treasure.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_JADE_SPIRIT ->
            Jade = lib_dict:get(?PROC_STATUS_JADE),
            if Jade#st_jade.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_BABY_WING_SPIRIT ->
            BabyWing = lib_dict:get(?PROC_STATUS_BABY_WING),
            if BabyWing#st_baby_wing.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_BABY_MOUNT_SPIRIT ->
            BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
            if BabyMount#st_baby_mount.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
        Subtype =:= ?GOODS_SUBTYPE_BABY_WEAPON_SPIRIT ->
            BabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
            if BabyWeapon#st_baby_weapon.stage == 0 ->
                throw({false, 27});
                true -> Num
            end;
%%         Subtype =:= ?GOODS_SUBTYPE_UP_CHANGE_SEX ->
%%
%%             [{Stage,_}] = GoodsType#goods_type.special_param_list,
%%             if Footprint#st_cat.stage < Stage ->
%%                 throw({false, 40});
%%                 true -> Num
%%             end;
        true ->
            Num
    end.


filter_gift_goods(GiveGoodsList) ->
    lists:foldr(fun(GiveGoods, {G1, G2}) ->
        case data_goods:get(GiveGoods#give_goods.goods_id) of
            GoodsType when GoodsType#goods_type.subtype =:= ?GOODS_SUBTYPE_GIFT_BAG andalso GoodsType#goods_type.use_panel =:= 0 ->
                {G1, [{GiveGoods#give_goods.goods_id, GiveGoods#give_goods.num} | G2]};
            _ -> {[GiveGoods | G1], G2}
        end
    end, {[], []}, GiveGoodsList).

open_gift_bag_loop(Player, [], _AddReason, GoodsOutList) ->
    {Player, GoodsOutList};

open_gift_bag_loop(Player, [{GoodsId, Num, []} | Tail], AddReason, GoodsOutList) ->
    open_gift_bag_loop(Player, [{GoodsId, Num} | Tail], AddReason, GoodsOutList);

%% 非可选礼包
open_gift_bag_loop(Player, [{GoodsId, Num} | Tail], AddReason, GoodsOutList) ->
    {Player2, GoodsList} = lists:foldr(fun(_, {PlayerO, GoodsListO}) ->
        {Player1, GiveGoodsList1} = open_gift_bag(PlayerO, GoodsId, false, AddReason),
        {Player1, GiveGoodsList1 ++ GoodsListO}
    end, {Player, []}, lists:seq(1, Num)),
    case filter_gift_goods(GoodsList) of
        {GiveGoodsList, []} ->
            open_gift_bag_loop(Player2, Tail, AddReason, GiveGoodsList ++ GoodsOutList);
        {GiveGoodsList, GiftGoodsListOut} ->
            open_gift_bag_loop(Player2, GiftGoodsListOut ++ Tail, AddReason, GoodsOutList ++ GiveGoodsList)
    end;

%% 可选礼包
open_gift_bag_loop(Player, [{GoodsId, Num, SGoodsList} | Tail], AddReason, GoodsOutList) ->
    BaseGift = data_gift_bag:get(GoodsId),
    Args = [{from_gift_id, GoodsId}],
    FSFun = fun([DidGoods1, DistriGoodnum1], {DistriNumAcc, GoodsAcc}) ->
        case lists:keyfind(DidGoods1, 2, BaseGift#base_gift.choose_get) of
            {_, DidGoods1, GoodsGiftNum1, IsBind} -> ok;
            _ ->
                ?ERR("DidGoods1 not in config ~w, gift_id:~w", [DidGoods1, GoodsId]),
                throw({false, ?ER_FAIL}),
                GoodsGiftNum1 = 1, IsBind = 0
        end,
        GiveGoods = #give_goods{goods_id = DidGoods1, num = DistriGoodnum1 * GoodsGiftNum1, location = ?GOODS_LOCATION_BAG, bind = IsBind, from = AddReason, args = Args},
        {DistriNumAcc + DistriGoodnum1, [GiveGoods | GoodsAcc]}
    end,
    {DistriNum, GiveGoodsList} = lists:foldl(FSFun, {0, []}, SGoodsList),
    ?ASSERT_TRUE(DistriNum /= Num, {false, ?ER_USE_NUMM_ERR}),

    %%有些礼包打开需要消耗元宝,元宝是否足够在前面已经判断
    if
        BaseGift#base_gift.need_gold > 0 ->
            [Gold, _] = money:get_gold(Player#player.key),
            ?ASSERT(Gold >= BaseGift#base_gift.need_gold * Num, {false, ?ER_NOT_ENOUGH_GOLD}),
            NewPlayer = money:add_no_bind_gold(Player, -BaseGift#base_gift.need_gold * Num, 58, GoodsId, 1);
        true ->
            NewPlayer = Player
    end,
    %% 开启礼包需要消耗相关物品
    case BaseGift#base_gift.need_goods of
        [] ->
            ok;
        NeedGoodsList ->
            lists:foreach(fun({NeedGoodsId, GoodsNum}) ->
                Count = goods_util:get_goods_count(NeedGoodsId),
                ?ASSERT(Count >= GoodsNum * Num, {false, ?ER_NOT_ENOUGH_NEED_GOODS_NUM})
            end, NeedGoodsList),
            [player:apply_state(async, Player#player.pid, {goods_use, sub_goods_before_use, {NeedGoodsId, GoodsNum * Num}}) || {NeedGoodsId, GoodsNum} <- NeedGoodsList],
            Num
    end,

    log_open_gift(Player#player.key, Player#player.nickname, Player#player.lv, GoodsId, GiveGoodsList),
    notice_gift(NewPlayer, BaseGift, GiveGoodsList),
    case filter_gift_goods(GiveGoodsList) of
        {GiveGoodsList, []} ->
            open_gift_bag_loop(NewPlayer, Tail, AddReason, GiveGoodsList ++ GoodsOutList);
        {GiveGoodsList, GiftGoodsListOut} ->
            open_gift_bag_loop(NewPlayer, GiftGoodsListOut ++ Tail, AddReason, GoodsOutList ++ GiveGoodsList)
    end.

%% 扣物品
sub_goods_before_use({NeedGoodsId, GoodsNum}, NewPlayer) ->
    goods:subtract_good(NewPlayer, [{NeedGoodsId, GoodsNum}], 311),
    ok.

%%开礼包
open_gift_bag(Player, GiveGoodsId, IsFuwenPass, AddReason) ->
    BaseGift0 = data_gift_bag:get(GiveGoodsId),
    BaseGift = ?IF_ELSE(IsFuwenPass == false, BaseGift0, fuwen_pass_gift(BaseGift0)),
    %%有些礼包打开需要消耗元宝,元宝是否足够在前面已经判断
    if
        BaseGift#base_gift.need_gold > 0 ->
            [Gold, _] = money:get_gold(Player#player.key),
            ?ASSERT(Gold >= BaseGift#base_gift.need_gold, {false, ?ER_NOT_ENOUGH_GOLD}),
            NewPlayer = money:add_no_bind_gold(Player, -BaseGift#base_gift.need_gold, 58, GiveGoodsId, 1);
        true ->
            NewPlayer = Player
    end,
    %% 开启礼包需要消耗相关物品
    case BaseGift#base_gift.need_goods of
        [] ->
            ok;
        NeedGoodsList ->
            lists:foreach(fun({NeedGoodsId, GoodsNum}) ->
                Count = goods_util:get_goods_count(NeedGoodsId),
                ?ASSERT(Count >= GoodsNum, {false, ?ER_NOT_ENOUGH_NEED_GOODS_NUM})
            end, NeedGoodsList),
            [player:apply_state(async, Player#player.pid, {goods_use, sub_goods_before_use, {NeedGoodsId, GoodsNum}}) || {NeedGoodsId, GoodsNum} <- NeedGoodsList]
    end,

    %%根据职业选出本次要随机的物品列表
    List = BaseGift#base_gift.career0 ++ ?IF_ELSE(Player#player.career == 1, BaseGift#base_gift.career1, BaseGift#base_gift.career2),
    %%根据配的权重选出本次随机到的物品
    if
        BaseGift#base_gift.random_num >= 1 ->
            RandomGoodsList = random_gift_goods(BaseGift#base_gift.random_repeat, BaseGift#base_gift.random_num, List);
        true ->
            RandomGoodsList = []
    end,

    %%根据职业选出本次必得的物品
    F1 = fun
        ({Career, GoodsId, InNum, Bind}) when Career =:= Player#player.career orelse Career == 0 ->
            [{GoodsId, InNum, Bind}];
        ({Career, GoodsId, InNum, Bind, ExpireTime}) when Career =:= Player#player.career orelse Career == 0 ->
            [{GoodsId, InNum, Bind, ExpireTime}];
        (_) -> []
    end,
    FixedGoodsList = lists:flatmap(F1, BaseGift#base_gift.must_get),

    Args = [{from_gift_id, GiveGoodsId}],
    Now = util:unixtime(),
    F2 = fun
        ({GoodsId, InNum, Bind}, Out) ->
            NewBind = ?IF_ELSE(lists:member(Bind, [?BIND, ?NO_BIND]), Bind, ?BIND),
            [#give_goods{goods_id = GoodsId, num = InNum, location = ?GOODS_LOCATION_BAG, bind = NewBind, from = AddReason, args = Args} | Out];
        ({GoodsId, InNum, Bind, ExpireTime}, Out) ->
            NewBind = ?IF_ELSE(lists:member(Bind, [?BIND, ?NO_BIND]), Bind, ?BIND),
            [#give_goods{goods_id = GoodsId, num = InNum, location = ?GOODS_LOCATION_BAG, bind = NewBind, from = AddReason, args = Args, expire_time = Now + ExpireTime} | Out]
    end,
    GiveGoodsList = lists:foldr(F2, [], RandomGoodsList ++ FixedGoodsList),
    log_open_gift(Player#player.key, Player#player.nickname, Player#player.lv, GiveGoodsId, GiveGoodsList),
    notice_gift(Player, BaseGift0, GiveGoodsList),
    {NewPlayer, GiveGoodsList}.

random_gift_goods(1, Num, GoodsList) ->
    F = fun(_, Out) ->
        case util:get_weight_item(4, GoodsList) of
            {InGoods, InNum, Bind, _} ->
                [{InGoods, InNum, Bind} | Out];
            {InGoods, InNum, Bind, _, ExpireTime} ->
                [{InGoods, InNum, Bind, ExpireTime} | Out]
        end
    end,
    lists:foldl(F, [], lists:seq(1, Num));
random_gift_goods(_, Num, GoodsList) ->
    {GetList, _} =
        lists:foldl(
            fun(_, {Out, GoodsList1}) ->
                case GoodsList1 of
                    [] -> Out;
                    _ ->
                        case util:get_weight_item(4, GoodsList1) of
                            {InGoods, InNum, Bind, Ratio} ->
                                {[{InGoods, InNum, Bind} | Out], lists:delete({InGoods, InNum, Bind, Ratio}, GoodsList1)};
                            {InGoods, InNum, Bind, Ratio, ExpireTime} ->
                                {[{InGoods, InNum, Bind, ExpireTime} | Out], lists:delete({InGoods, InNum, Bind, Ratio, ExpireTime}, GoodsList1)}
                        end
                end
            end, {[], GoodsList}, lists:seq(1, Num)),
    GetList.

fuwen_pass_gift(BaseGift) ->
    #base_gift{career0 = Career0, career1 = Career1, career2 = Career2, random_num = RandomNum} = BaseGift,
    StFuwenDungeon = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    #st_dun_fuwen_tower{unlock_fuwen_subtype = UnlockFuwenSubtype} = StFuwenDungeon,
    F0 = fun(Tuple) ->
        List = tuple_to_list(Tuple),
        InGoods = hd(List),
        case data_goods:get(InGoods) of
            [] ->
                false;
            #goods_type{subtype = SubType} ->
                lists:member(SubType, UnlockFuwenSubtype)
        end
    end,
    NewCareer0 = lists:filter(F0, Career0),
    F1 = fun(Tuple) ->
        List = tuple_to_list(Tuple),
        InGoods = hd(List),
        case data_goods:get(InGoods) of
            [] ->
                false;
            #goods_type{subtype = SubType} ->
                lists:member(SubType, UnlockFuwenSubtype)
        end
    end,
    NewCareer1 = lists:filter(F1, Career1),
    F2 = fun(Tuple) ->
        List = tuple_to_list(Tuple),
        InGoods = hd(List),
        case data_goods:get(InGoods) of
            [] ->
                false;
            #goods_type{subtype = SubType} ->
                lists:member(SubType, UnlockFuwenSubtype)
        end
    end,
    NewCareer2 = lists:filter(F2, Career2),
    BaseGift#base_gift{
        career0 = NewCareer0,
        career1 = NewCareer1,
        career2 = NewCareer2,
        random_num = min(RandomNum, length(NewCareer0 ++ NewCareer1 ++ NewCareer2))
    }.

notice_gift(_Player, BaseGift, _GiveGoodsList) when BaseGift#base_gift.cherish_list == [] ->
    ok;

notice_gift(Player, BaseGift, GiveGoodsList) ->
    F = fun(#give_goods{goods_id = Gid, num = Num}) ->
        case lists:member({Gid, Num}, BaseGift#base_gift.cherish_list) of
            false -> ok;
            true ->
                notice_sys:add_notice(open_gift_bag, [Player, BaseGift#base_gift.goods_id, Gid, Num])
        end
    end,
    lists:map(F, GiveGoodsList),
    skip.

log_open_gift(Key, Nickname, Lv, GiveGoodsId, GiveGoodsList) ->
    GoodsList = goods:merge_goods([{GiveGoods#give_goods.goods_id, GiveGoods#give_goods.num} || GiveGoods <- GiveGoodsList]),
    Sql = io_lib:format("insert into  log_open_gift (pkey, nickname,lv,gift_id,goods_list,time) VALUES(~p,'~s',~p,~p,'~s',~p)",
        [Key, Nickname, Lv, GiveGoodsId, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.
