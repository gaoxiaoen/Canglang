%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 四月 2016 下午3:13
%%%-------------------------------------------------------------------
-module(red_bag).
-author("fengzhenlin").
-include("server.hrl").
-include("red_bag.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("goods.hrl").

%% API
-export([
    open_red_bag/2,
    open_red_bag_guild/2,
    open_red_bag_marry/2
]).

-export([
    open_result/2,
    use_red_bag/2,
    charge_add_red_bag/2,
    use_red_bag_guild/2,
    login_get_guild_red_bag/1,
    use_red_bag_marry/2
]).

-define(MAX_GET_RED_BAG_TIMES, 30).  %%每天最多抢红包数

%%开红包
open_red_bag(Player, RedBagKey) ->
    OpenTimes = daily:get_count(?DAILY_RED_BAG_GET_NUM),
    Res =
        if
            OpenTimes >= ?MAX_GET_RED_BAG_TIMES -> {false, 3};
        %Player#player.lv =< 30 -> {false, 4};
            true -> true
        end,
    case Res of
        {false, Reason} ->
            {ok, Bin} = pt_382:write(38201, {Reason, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            red_bag_proc:open_red_bag(RedBagKey, [Player#player.key, Player#player.sid, Player#player.nickname, Player#player.pid,
                Player#player.career, Player#player.sex, Player#player.avatar]),
            ok
    end.

%%开红包结果处理
open_result([Res, GetGold], Player) ->
    case Res of
        1 ->
            daily:increment(?DAILY_RED_BAG_GET_NUM, 1),
            NewPlayer = money:add_bind_gold(Player, GetGold, 143, 0, 0),
            {ok, NewPlayer};
        _ ->
            ok
    end.

%%打开帮派红包
open_red_bag_guild(Player, RedBagKey) ->
    OpenTimes = daily:get_count(?DAILY_RED_BAG_GET_NUM),
    Res =
        if
            OpenTimes >= ?MAX_GET_RED_BAG_TIMES -> {false, 3};
            true -> true
        end,
    case Res of
        {false, Reason} ->
            {ok, Bin} = pt_382:write(38211, {Reason, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            Info = {Player#player.key, Player#player.nickname, Player#player.career, Player#player.sex, Player#player.avatar, Player#player.sid, Player#player.pid, Player#player.guild#st_guild.guild_key},
            red_bag_proc:open_red_bag_guild(RedBagKey, Info),
            ok
    end.

%%打开结婚红包
open_red_bag_marry(Player, RedBagKey) ->
    OpenTimes = daily:get_count(?DAILY_RED_BAG_GET_NUM),
    Res =
        if
            OpenTimes >= ?MAX_GET_RED_BAG_TIMES -> {false, 3};
            true -> true
        end,
    case Res of
        {false, Reason} ->
            {ok, Bin} = pt_382:write(38215, {Reason, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            Info = {Player#player.key, Player#player.nickname, Player#player.career, Player#player.sex, Player#player.avatar, Player#player.sid, Player#player.pid},
            red_bag_proc:open_red_bag_marry(RedBagKey, Info),
            ok
    end.

%%使用普通红包
use_red_bag(Player, GoodsId) ->
    red_bag_proc:add_red_bag(Player, [GoodsId]),
    ok.

%%充值送红包
charge_add_red_bag(Player, ChargeVal) ->
    case data_red_bag_charge:get(ChargeVal) of
        [] -> Player;
        Base ->
            #base_red_bag_charge{
                charge = _Charge,
                goods_id = GoodsId,
                num = Num
            } = Base,
            GetNum = Num,
            GiveGoodsList = goods:make_give_goods_list(142, [{GoodsId, GetNum}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            NewPlayer
    end.

%%使用帮派红包
use_red_bag_guild(Player, GoodsId) ->
    red_bag_proc:add_red_bag_guild(Player, GoodsId),
    ok.

%%使用结婚红包
use_red_bag_marry(Player, GoodsId) ->
    Couple = shadow_proc:get_shadow(Player#player.marry#marry.couple_key),
    red_bag_proc:add_marry_red_bag(Player, Couple, [GoodsId]).

%%登陆检查有效的帮派红包
login_get_guild_red_bag(Player) ->
    if
        Player#player.guild#st_guild.guild_key == 0 -> skip;
        true ->
            case ets:match_object(?RED_BAG_ETS, #red_bag{gkey = Player#player.guild#st_guild.guild_key, _ = '_'}) of
                [] -> skip;
                RedbagList ->
                    F = fun(RedBag) ->
                        case lists:keyfind(Player#player.key, #red_bag_g_p.pkey, RedBag#red_bag.guild_get_list) of
                            false ->
                                #red_bag{
                                    key = Key,
                                    gkey = Gkey,
                                    name = Name,
                                    guild_red_type = GuildRedType,
                                    goods_id = GoodsId,
                                    get_num = GetNum
                                } = RedBag,
                                Base = data_red_bag_guild:get(GoodsId),
                                #base_red_bag_guild{
                                    max_num = MaxNum
                                } = Base,
                                case GetNum >= MaxNum of
                                    true ->
                                        [];
                                    false ->
                                        [[Key, Gkey, Name, "", GuildRedType]]
                                end;
                            _ -> []
                        end
                        end,
                    CanGetList = lists:flatmap(F, RedbagList),
                    {ok, Bin} = pt_382:write(38213, {CanGetList}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end
    end.


