%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2017 15:46
%%%-------------------------------------------------------------------
-module(dungeon_vip).
-author("luobq").
-include("server.hrl").
-include("dungeon.hrl").
-include("common.hrl").
-include("skill.hrl").
-include("daily.hrl").
-include("player_mask.hrl").
%% API
-export([
    dungeon_list/1,
    dungeon_vip_ret/3,
    update_vip_dungeon_target/1,
    check_enter/2,
    get_notice_player/1,
    vip_sweep/2
]).

%%副本列表
dungeon_list(_Player) ->
    F = fun(DunId) ->
        case data_dungeon:get(DunId) of
            [] ->
                [];
            Base ->
                BaseDunVip = data_dungeon_vip:get(DunId),
                Count = dungeon_util:get_dungeon_times(DunId),
                RemainCount = max(0, (Base#dungeon.count - Count)),
                AllCount = player_mask:get(?PLAYER_DUNGEON_COUNT(DunId), 0),
                SweepState = ?IF_ELSE(AllCount > 0 andalso RemainCount > 0, 1, 0),
                [[DunId, BaseDunVip#base_dun_vip.vip_lv, RemainCount, SweepState]] %% 副本id，vip等级、剩余次数
        end
    end,
    lists:flatmap(F, data_dungeon_vip:ids()).


%%副本挑战结果
dungeon_vip_ret(1, Player, DunId) ->
    dungeon_util:add_dungeon_times(DunId),
    player_mask:set(?PLAYER_DUNGEON_COUNT(DunId), 1),
    BaseDunVip = data_dungeon_vip:get(DunId),
    PassGoods = tuple_to_list(BaseDunVip#base_dun_vip.pass_goods),
    DropGoods = drop_goods(tuple_to_list(BaseDunVip#base_dun_vip.drop_goods)),
    GoodsList = goods:merge_goods(PassGoods ++ DropGoods),
    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(315, GoodsList)),
    PackGoodsList = [[Gid, Num, ?DROP_TYPE_PASS] || {Gid, Num} <- PassGoods] ++ [[Gid, Num, ?DROP_TYPE_RATIO] || {Gid, Num} <- DropGoods],
    {ok, Bin} = pt_121:write(12163, {1, DunId, PackGoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    %% sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_DUN_MATERIAL),
    activity:get_notice(Player, [103], true),
    NewPlayer;

dungeon_vip_ret(0, Player, DunId) ->
    {ok, Bin} = pt_121:write(12163, {0, DunId, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player.

drop_goods(GoodsList) ->
    RatioList = [{Gid, Ratio} || {Gid, _, Ratio} <- GoodsList],
    case util:list_rand_ratio(RatioList) of
        0 -> [];
        Gid ->
            case lists:keyfind(Gid, 1, GoodsList) of
                false -> [];
                {_, Num, _} ->
                    [{Gid, Num}]
            end
    end.

%%更新vip副本目标信息
update_vip_dungeon_target(StDun) ->
    Now = util:unixtime(),
    LeftTime = max(0, StDun#st_dungeon.end_time - Now),
    KillList = [[mon_util:get_mon_name(Mid), Cur, Need] || {Mid, Need, Cur} <- StDun#st_dungeon.kill_list],
    {ok, Bin} = pt_121:write(12164, {LeftTime, KillList}),
    [server_send:send_to_key(Mb#dungeon_mb.pkey, Bin) || Mb <- StDun#st_dungeon.player_list].

check_enter(#player{vip_lv = VipLv}, Sid) ->
    case dungeon_util:is_dungeon_vip(Sid) of
        false -> true;
        true ->
            Count = dungeon_util:get_dungeon_times(Sid),
            BaseDunVip = data_dungeon_vip:get(Sid),
            if
                BaseDunVip#base_dun_vip.count =< Count ->
                    {false, ?T("您今日挑战次数已用完")};
                true ->
                    if
                        VipLv < BaseDunVip#base_dun_vip.vip_lv ->
                            {false, ?T("您vip等级不足")};
                        true ->
                            true
                    end
            end
    end.

get_notice_player(Player) ->
    IdList = data_dungeon_vip:ids(),
    F = fun(DunId) ->
        case check_enter(Player, DunId) of
            true -> [1];
            _ -> []
        end
    end,
    List = lists:flatmap(F, IdList),
    ?IF_ELSE(List == [], 0, 1).

vip_sweep(Player, DunId) ->
    case check_sweep(DunId) of
        false -> {0, Player,[]};
        true ->
            dungeon_util:add_dungeon_times(DunId),
            BaseDunVip = data_dungeon_vip:get(DunId),
            PassGoods = tuple_to_list(BaseDunVip#base_dun_vip.pass_goods),
            DropGoods = drop_goods(tuple_to_list(BaseDunVip#base_dun_vip.drop_goods)),
            GoodsList = goods:merge_goods(PassGoods ++ DropGoods),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(315, GoodsList)),
            PackGoodsList = [[Gid, Num, ?DROP_TYPE_PASS] || {Gid, Num} <- PassGoods] ++ [[Gid, Num, ?DROP_TYPE_RATIO] || {Gid, Num} <- DropGoods],
            {1, NewPlayer,PackGoodsList}
    end.

check_sweep(DunId) ->
    case data_dungeon:get(DunId) of
        [] ->
            false;
        Base ->
            if
                Base#dungeon.type /= 17 -> false;
                true ->
                    Count = dungeon_util:get_dungeon_times(DunId),
                    RemainCount = max(0, (Base#dungeon.count - Count)),
                    AllCount = player_mask:get(?PLAYER_DUNGEON_COUNT(DunId), 0),
                    SweepState = ?IF_ELSE(AllCount > 0 andalso RemainCount > 0, 1, 0),
                    ?IF_ELSE(SweepState == 1, true, false)
            end
    end.
