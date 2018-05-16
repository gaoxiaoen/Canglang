%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2018 16:37
%%%-------------------------------------------------------------------
-module(magic_face).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("face_card.hrl").

%% API
-export([
    send_face/4
]).

%% 发送魔法表情
send_face(Player, Id, Pkey, 1) ->
    case data_magic_face:get(Id) of
        [] -> {0, Player};
        #base_face_magic{add_val = AddQinmidu, consume2 = [{CostGoodsId, CostNum}], name = Name} ->
            case new_shop:get_goods_price(CostGoodsId) of
                false ->
                    {0, Player};
                {ok, Type, Price} ->
                    Money = Price * CostNum,
                    case money:is_enough(Player, Money, Type) of
                        false -> {2, Player};
                        true ->
                            NewPlayer = money:add_no_bind_gold(Player, -Money, 760, CostGoodsId, CostNum),
                            Shadow = shadow_proc:get_shadow(Pkey),
                            notice_sys:add_notice(magic_face, [Player#player.nickname, Shadow#player.nickname, Name]),
                            spawn(fun() -> notice_all(Id) end),
                            case lists:member(Pkey, relation:get_friend_list()) of
                                true -> relation:add_qinmidu({Pkey, AddQinmidu}, Player);
                                false -> ok
                            end,
                            {1, NewPlayer}
                    end
            end
    end;

send_face(Player, Id, Pkey, _IsAuto) ->
    case data_magic_face:get(Id) of
        [] -> {0, Player};
        #base_face_magic{add_val = AddQinmidu, consume1 = Consume1, consume2 = Consume2, name = Name} ->
            F = fun({GoodsId, GoodsNum}) ->
                HasNum = goods_util:get_goods_count(GoodsId),
                HasNum < GoodsNum
            end,
            case lists:any(F, Consume2) of
                true ->
                    case lists:any(F, Consume1) of
                        true ->
                            [{Gid, Gnum}] = Consume2,
                            goods_util:client_popup_goods_not_enough(Player, Gid, Gnum, 1),
                            {3, Player};
                        false ->
                            {ok, _} = goods:subtract_good(Player, Consume1, 761),
                            spawn(fun() -> notice_all(Id) end),
                            Shadow = shadow_proc:get_shadow(Pkey),
                            notice_sys:add_notice(magic_face, [Player#player.nickname, Shadow#player.nickname, Name]),
                            case lists:member(Pkey, relation:get_friend_list()) of
                                true -> relation:add_qinmidu({Pkey, AddQinmidu}, Player);
                                false -> ok
                            end,
                            {1, Player}
                    end;
                false ->
                    {ok, _} = goods:subtract_good(Player, Consume2, 761),
                    Shadow = shadow_proc:get_shadow(Pkey),
                    notice_sys:add_notice(magic_face, [Player#player.nickname, Shadow#player.nickname, Name]),
                    spawn(fun() -> notice_all(Id) end),
                    case lists:member(Pkey, relation:get_friend_list()) of
                        true -> relation:add_qinmidu({Pkey, AddQinmidu}, Player);
                        false -> ok
                    end,
                    {1, Player}
            end
    end.

notice_all(Id) ->
    OnlineList = ets:tab2list(ets_online),
    {ok, Bin} = pt_446:write(44603, {Id}),
    F = fun(#ets_online{sid = Sid}) ->
        server_send:send_to_sid(Sid, Bin)
    end,
    lists:map(F, OnlineList),
    ok.
