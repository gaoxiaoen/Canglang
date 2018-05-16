%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 17:16
%%%-------------------------------------------------------------------
-module(wish_tree_rpc).

-include("server.hrl").
-include("common.hrl").
-include("wish_tree.hrl").
-include("relation.hrl").
-include("chat.hrl").


%% API
-export([handle/3]).


%%获取所有好友许愿树施肥概况
handle(37000, Player, _) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Now = util:unixtime(),
    Fun = fun(Relation, Out) ->
        case ets:lookup(?ETS_WISH_TREE, Relation#relation.pkey) of
            [] when Relation#relation.lv < 46 ->
                Out;
            [] ->
                IsWash = 0,
                CanFertilizer = 0,
                CanWater = 0,
                IsSteal = 0, FertilizerTimes = 1,
                [[Relation#relation.pkey, Relation#relation.nickname, Relation#relation.avatar, Relation#relation.career, Relation#relation.lv, Relation#relation.qinmidu, IsWash, CanFertilizer, FertilizerTimes, CanWater, IsSteal] | Out];
            [WishTreee] ->
                VisitRecord = lists:keyfind(Player#player.key, #visit_record.pkey, WishTreee#wish_tree.visit_record),
                IsWash = ?IF_ELSE(WishTreee#wish_tree.harvest_time =:= -1, 0, 1),
                if
                    WishTreee#wish_tree.harvest_time == -1 -> %%还未许愿
                        FertilizerTimes = 1, IsSteal = 0, CanFertilizer = 0, CanWater = 0;
                    WishTreee#wish_tree.harvest_time < Now -> %%已经成熟
                        %?PRINT("pick_goods  ~p is_pick ~p",[WishTreee#wish_tree.pick_goods,?IF_ELSE(VisitRecord == false,false,VisitRecord#visit_record.is_pick)]),
                        if
                            VisitRecord =/= false andalso VisitRecord#visit_record.is_pick == 1 ->
                                IsSteal = 2;
                            WishTreee#wish_tree.pick_goods =/= false andalso (VisitRecord == false orelse VisitRecord#visit_record.is_pick == 0) ->
                                IsSteal = 1;
                            true ->
                                IsSteal = 0
                        end,
                        FertilizerTimes = 1, CanFertilizer = 0, CanWater = 0;
                    VisitRecord == false -> %%还未成熟
                        IsSteal = 0, CanWater = 1,
                        FertilizerTimes = 1,
                        CanFertilizer = ?IF_ELSE(WishTreee#wish_tree.maturity_degree >= 100, 0, 1);
                    VisitRecord =/= false -> %%还未成熟
                        IsSteal = 0,
                        FertilizerTimes = VisitRecord#visit_record.fertilizer_times + 1,
                        CanFertilizer = ?IF_ELSE(VisitRecord#visit_record.fertilizer_times > 0 orelse WishTreee#wish_tree.maturity_degree >= 100, 0, 1),
                        CanWater = ?IF_ELSE(VisitRecord#visit_record.watering_time > 0, 0, 1);
                    true ->
                        ?ERR("VisitRecord ~p ~n", [VisitRecord]),
                        FertilizerTimes = 1,
                        IsSteal = 0,
                        CanFertilizer = 0,
                        CanWater = 0
                end,
                %?PRINT("IsSteal ~p IsWash ~p CanWater~p CanFertilizer ~p",[IsSteal,IsWash,CanWater,CanFertilizer]),
                [[Relation#relation.pkey, Relation#relation.nickname, Relation#relation.avatar, Relation#relation.career, Relation#relation.lv, Relation#relation.qinmidu, IsWash, CanFertilizer, FertilizerTimes, CanWater, IsSteal] | Out]
        end
          end,
    List = lists:foldl(Fun, [], RelationsSt#st_relation.friends),
    {ok, Bin} = pt_370:write(37000, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%到访记录
handle(37001, Player, _) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    case ets:lookup(?ETS_WISH_TREE, Player#player.key) of
        [] ->
            List = [];
        [WishTreee] ->
            Fun = fun(VisitRecord, Out) ->
                case lists:keyfind(VisitRecord#visit_record.pkey, #relation.pkey, RelationsSt#st_relation.friends) of
                    false ->
                        Out;
                    _Relation when VisitRecord#visit_record.fertilizer_times =:= 0 andalso VisitRecord#visit_record.watering_time =:= 0 ->
                        Out;
                    Relation ->
                        IsWatering = ?IF_ELSE(VisitRecord#visit_record.watering_time > 0, 1, 0),
                        IsFertilizer = ?IF_ELSE(VisitRecord#visit_record.fertilizer_times > 0, 1, 0),
                        [[Relation#relation.pkey, Relation#relation.nickname, Relation#relation.avatar, Relation#relation.career, Relation#relation.lv, Relation#relation.qinmidu, VisitRecord#visit_record.is_thks, IsWatering, IsFertilizer] | Out]
                end
                  end,
            List = lists:foldl(Fun, [], WishTreee#wish_tree.visit_record)
    end,
    {ok, Bin} = pt_370:write(37001, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%获取自己许愿树信息
handle(37002, Player, _) ->
    ?CAST(wish_tree:get_server_pid(), {get_self_tree_info, Player}),
    ok;

%%获取好友许愿树信息
handle(37003, Player, {Pkey}) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    case lists:keyfind(Pkey, #relation.pkey, RelationsSt#st_relation.friends) of
        false ->
            Avatar = "", IsRemind = 0,
            IsSteal = 0, P0_error_code = 17, P0_nickname = "", P0_career = 0, P0_lv = 0, P0_qinmidu = 0, P0_tree_lv = 1,
            P0_time = 0, P0_maturity = 0, P0_max_maturity = 0, P0_is_water = 0, P0_is_fertilizer = 0,
            P0_client_rand_value = 0, P0_goods_list = [],
            {ok, Bin} = pt_370:write(37003, {P0_error_code, Pkey, Avatar, P0_nickname, P0_career, P0_lv, P0_qinmidu, P0_tree_lv, P0_time, P0_maturity, P0_max_maturity, P0_is_water, P0_is_fertilizer, P0_client_rand_value, IsSteal, IsRemind, P0_goods_list}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        Relation ->
            case ets:lookup(?ETS_WISH_TREE, Pkey) of
                [] ->
                    IsRemind = 0,
                    P0_goods_list = [[28150, 6, 1], [20001, 3, 1], [28000, 3, 1], [20200, 1, 1], [10109, 20000, 1], [11117, 1, 1]],
                    IsSteal = 0, P0_error_code = 1, P0_tree_lv = 1, P0_time = 0, P0_maturity = 0, P0_max_maturity = 0,
                    P0_is_water = 0, P0_is_fertilizer = 0, P0_client_rand_value = 0,
                    {ok, Bin} = pt_370:write(37003, {P0_error_code, Pkey, Relation#relation.avatar, Relation#relation.nickname, Relation#relation.career, Relation#relation.lv, Relation#relation.qinmidu, P0_tree_lv, P0_time, P0_maturity, P0_max_maturity, P0_is_water, P0_is_fertilizer, P0_client_rand_value, IsSteal, IsRemind, P0_goods_list}),
                    server_send:send_to_sid(Player#player.sid, Bin);
                [WishTree] ->
                    VisitRecord = lists:keyfind(Player#player.key, #visit_record.pkey, WishTree#wish_tree.visit_record),
                    IsRemind = ?IF_ELSE(VisitRecord == false orelse VisitRecord#visit_record.is_remind =:= 0, 0, 1),
                    CanWater = ?IF_ELSE(VisitRecord == false orelse VisitRecord#visit_record.watering_time == 0, 1, 0),
                    CanFertilizer = ?IF_ELSE(WishTree#wish_tree.maturity_degree >= 100, 0, 1),
                    Now = util:unixtime(),
                    Time = ?IF_ELSE(WishTree#wish_tree.harvest_time == -1, -1, max(0, WishTree#wish_tree.harvest_time - Now)),
                    IsSteal = ?IF_ELSE(WishTree#wish_tree.pick_goods =/= false andalso (VisitRecord == false orelse VisitRecord#visit_record.is_pick == 0), 1, 0),
                    {ok, Bin} = pt_370:write(37003, {1, Pkey, Relation#relation.avatar, Relation#relation.nickname, Relation#relation.career, Relation#relation.lv, Relation#relation.qinmidu, WishTree#wish_tree.lv, Time, WishTree#wish_tree.maturity_degree, 100, CanWater, CanFertilizer,
                        WishTree#wish_tree.client_rank_value, IsSteal, IsRemind,
                        [[GoodsId, Num, Mul] || {GoodsId, Num, Mul} <- WishTree#wish_tree.goods_list]}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end,
            ok
    end;

%%刷新物品
handle(37004, Player, _) ->
    case ?CALL(wish_tree:get_server_pid(), {refresh_goods, Player}) of
        {false, ErrorCode} ->
            {ok, Bin} = pt_370:write(37004, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NeedMoney} ->
            NewPlayer = money:add_gold(Player, -NeedMoney, 165, 0, 0),
            {ok, Bin} = pt_370:write(37004, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        _other ->
            ?ERR("ErrorCode ~p ~n", [_other]),
            ok
    end;

%%许愿
handle(37005, Player, _) ->
    case ?CALL(wish_tree:get_server_pid(), {wish, Player}) of
        ok ->
            RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
            Conten = binary_to_list(?T("我许愿啦，快来帮我的许愿树浇水吧！")),
            Fun = fun(Relation) ->
                case ets:lookup(?ETS_ONLINE, Relation#relation.pkey) of
                    [] -> ok;
                    _ ->
                        chat:chat(Player, ?CHAT_TYPE_FRIEND, Conten, "", Relation#relation.pkey, Relation#relation.nickname)
                end
                  end,
            lists:foreach(Fun, RelationsSt#st_relation.friends),
            ok;
        _ ->
            ok
    end;

%%给自己施肥
handle(37006, Player, _) ->
    case ?CALL(wish_tree:get_server_pid(), {fertilization_self, Player}) of
        {false, ErrorCode} ->
            {ok, Bin} = pt_370:write(37006, {ErrorCode, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NeedMoney, Num} ->
            NewPlayer = money:add_gold(Player, -NeedMoney, 163, 0, 0),
            {ok, Bin} = pt_370:write(37006, {1, Num}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%给自己浇水
handle(37007, Player, _) ->
    ?CAST(wish_tree:get_server_pid(), {watering_self, Player}),
    ok;

%%给好友施肥
handle(37008, Player, {Pkey}) ->
    case ?CALL(wish_tree:get_server_pid(), {fertilizer_friends, Player, Pkey}) of
        {false, ErrorCode} ->
            {ok, Bin} = pt_370:write(37008, {ErrorCode, Pkey, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, AddIntimacy, NeedMoney, Num} ->
            NewPlayer = money:add_gold(Player, -NeedMoney, 163, 0, 0),
            {ok, Bin} = pt_370:write(37008, {1, Pkey, Num}),
            server_send:send_to_sid(Player#player.sid, Bin),
            relation:add_qinmidu({Pkey, AddIntimacy}, Player),
            {ok, NewPlayer};
        _other ->
            ?ERR("ErrorCode ~p ~n", [_other]),
            ok
    end;


%%给好友浇水
handle(37009, Player, {Pkey}) ->
    ?CAST(wish_tree:get_server_pid(), {watering_friends, Player, Pkey}),
    ok;

%%收获自己的物品
handle(37010, Player, _) ->
    ?CAST(wish_tree:get_server_pid(), {harvest_self, Player}),
    ok;

%%收获好友的物品
handle(37011, Player, {Pkey}) ->
    ?CAST(wish_tree:get_server_pid(), {harvest_friends, Player, Pkey}),
    ok;

%%提醒好友
handle(37012, Player, {Pkey}) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    case lists:keyfind(Pkey, #relation.pkey, RelationsSt#st_relation.friends) of
        false ->
            {ok, Bin} = pt_370:write(37012, {17}),
            server_send:send_to_sid(Player#player.sid, Bin);
        Relation ->
            case ets:lookup(?ETS_WISH_TREE, Pkey) of
                [] ->
                    ?CAST(wish_tree:get_server_pid(), {remind_wish, Player#player.key, Pkey}),
                    chat:chat(Player, ?CHAT_TYPE_FRIEND, binary_to_list(?T("你还没给许愿树许愿呢，快去许愿拿奖励吧")), "", Pkey, Relation#relation.nickname),
                    {ok, Bin} = pt_370:write(37012, {1}),
                    server_send:send_to_sid(Player#player.sid, Bin);
                [WishTree] ->
                    VisitRecord = lists:keyfind(Player#player.key, #visit_record.pkey, WishTree#wish_tree.visit_record),
                    if
                        VisitRecord#visit_record.is_remind =:= 1 ->
                            {ok, Bin} = pt_370:write(37012, {1}),
                            server_send:send_to_sid(Player#player.sid, Bin);
                        true ->
                            ?CAST(wish_tree:get_server_pid(), {remind_wish, Player#player.key, Pkey}),
                            chat:chat(Player, ?CHAT_TYPE_FRIEND, binary_to_list(?T("你还没给许愿树许愿呢，快去许愿拿奖励吧")), "", Pkey, Relation#relation.nickname),
                            {ok, Bin} = pt_370:write(37012, {1}),
                            server_send:send_to_sid(Player#player.sid, Bin)
                    end;
                _ ->
                    {ok, Bin} = pt_370:write(37012, {17}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end
    end,
    ok;


%%感谢一个好友
handle(37014, Player, {Pkey}) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    case lists:keyfind(Pkey, #relation.pkey, RelationsSt#st_relation.friends) of
        false ->
            {ok, Bin} = pt_370:write(37014, {17, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin);
        Relation ->
            ?CAST(wish_tree:get_server_pid(), {thks_friends, Player, Pkey}),
            chat:chat(Player, ?CHAT_TYPE_FRIEND, binary_to_list(?T("谢谢你来照看我的许愿树哦，么么哒")), "", Pkey, Relation#relation.nickname),
            {ok, Bin} = pt_370:write(37014, {1, 1, 5}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok;

%%感谢所有好友
handle(37015, Player, _) ->
    case Player#player.vip_lv < 3 of
        true ->
            {ok, Bin} = pt_370:write(37015, {24, 0, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin);
        _ ->
            ?CAST(wish_tree:get_server_pid(), {thks_all_friends, Player})
    end,
    ok;

%%一键浇水
handle(37016, Player, _) ->
    case Player#player.vip_lv < 3 of
        true ->
            {ok, Bin} = pt_370:write(37016, {24, 0, 0, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin);
        _ ->
            RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
            Now = util:unixtime(),
            Fun = fun(Relation, Out) ->
                case ets:lookup(?ETS_WISH_TREE, Relation#relation.pkey) of
                    [] -> Out;
                    [WishTreee] when WishTreee#wish_tree.harvest_time < Now -> Out;
                    [WishTreee] ->
                        VisitRecord = lists:keyfind(Player#player.key, #visit_record.pkey, WishTreee#wish_tree.visit_record),
                        if
                            VisitRecord == false orelse VisitRecord#visit_record.watering_time == 0 ->
                                [Relation#relation.pkey | Out];
                            true ->
                                Out
                        end
                end
                  end,
            PkeyList = lists:foldl(Fun, [], RelationsSt#st_relation.friends),
            if
                PkeyList == [] ->
                    {ok, Bin} = pt_370:write(37016, {25, 0, 0, 0, 0}),
                    server_send:send_to_sid(Player#player.sid, Bin);
                true ->
                    ?CAST(wish_tree:get_server_pid(), {all_watering, Player, PkeyList})
            end
    end,
    ok;

%%获取记录
handle(37017, Player, _) ->
    case ets:lookup(?ETS_WISH_TREE, Player#player.key) of
        [] ->
            {ok, Bin} = pt_370:write(37017, {[]}),
            server_send:send_to_sid(Player#player.sid, Bin);
        [WishTree] ->
            {ok, Bin} = pt_370:write(37017, {WishTree#wish_tree.pick_goods_record}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok;

handle(_cmd, _Player, _Data) ->
    ?PRINT("_cmd ~p _Data ~p ~n", [_cmd, _Data]),
    ok.