%%%-------------------------------------------------------------------
%%% @author and_me
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 三月 2016 11:03
%%%-------------------------------------------------------------------
-module(equip_compound).
-author("and_me").
-include("common.hrl").
-include("server.hrl").
-include("equip.hrl").
-include("goods.hrl").
-include("mount.hrl").
-include("wing.hrl").
%% API
-export([compound/3]).

compound(Id, CompoundNum, Player) ->
    BaseCompound = data_compound:get(Id),
    check(BaseCompound, CompoundNum),
    ?ASSERT(money:is_enough(Player, BaseCompound#base_compound.need_coin * CompoundNum, coin), {false, 5}),
    lists:foreach(fun({GoodsId, Num}) ->
        HaveNum = goods_util:get_goods_count(GoodsId),
        ?ASSERT(HaveNum >= Num * CompoundNum, {false, 3})
                  end, BaseCompound#base_compound.material),
    goods:subtract_good_throw(Player, [{G, N * CompoundNum} || {G, N} <- BaseCompound#base_compound.material], 77),
    {ok, Player1} = goods:give_goods(Player, goods:make_give_goods_list(77, [{G, N * CompoundNum} || {G, N} <- BaseCompound#base_compound.goods])),
    notice(Player, BaseCompound),
    {ok, money:add_coin(Player1, -BaseCompound#base_compound.need_coin * CompoundNum, 77, 0, 0)}.

check(BaseCompound, CompoundNum) ->
    if
        (BaseCompound#base_compound.type == 4 orelse BaseCompound#base_compound.type == 5) andalso CompoundNum > 1 ->
            throw({false, 27});
        (BaseCompound#base_compound.type == 4 orelse BaseCompound#base_compound.type == 5) ->
            [{GoodsId, _}] = BaseCompound#base_compound.goods,
            GoodsType = data_goods:get(GoodsId),
            case GoodsType#goods_type.subtype of
                ?GOODS_SUBTYPE_MOUNT_CARD ->
                    [MountId, _] = GoodsType#goods_type.special_param_list,
                    case mount:have_mount(MountId) of
                        false -> ok;
                        _ -> throw({false, 28})
                    end;
%%				?GOODS_SUBTYPE_ADD_WING->
%%					[WingId,_] = GoodsType#goods_type.special_param_list,
%%					case wing:have_wing(WingId) of
%%						false-> ok;
%%						_-> throw({false,29	})
%%					end;
                ?GOODS_SUBTYPE_FASHION1 -> ok
%%					{FashionId, _Time} = data_fashion_goods:get(GoodsId),
%%					case fashion:have_fashion(FashionId) of
%%						false-> ok;
%%						_-> throw({false,27})
%%					end;
%%				_ when GoodsId == 39999->
%%					case lists:any(fun fashion:have_fashion/1,[41101,41201,41301,41401]) of
%%						true->
%%							throw({false,27});
%%						_-> ok
%%						end;
%%				_ when GoodsId == 40039->
%%					case lists:any(fun fashion:have_fashion/1,[41102,41202,41302,41402]) of
%%						true->
%%							throw({false,27});
%%						_-> ok
%%					end;
%%				_->
%%					ok
            end;
        true ->
            ok
    end.

%%广播
notice(_Player, BaseCompound) ->
    #base_compound{
        type = Type,
        goods = GoodsList
    } = BaseCompound,
    {GoodsId, _Num} = hd(GoodsList),
    IsNotice =
        case Type of
            5 -> %%宠物
                lists:member(GoodsId, [22913, 22522]);
            6 -> true;
            7 -> true;
            8 -> true;
            _ -> false
        end,
    case IsNotice of
        true ->
            GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
            ComGoodsList = goods_util:get_goods_list_by_goods_id(GoodsId, GoodsSt#st_goods.dict),
            case ComGoodsList of
                {0, []} -> skip;
                {_, [_Goods1 | _]} ->
                    skip%notice_sys:add_notice(goods_compound, [Goods1, Player])
            end;
        false ->
            skip
    end.

