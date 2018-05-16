%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     每日副本 剧情,神器,灵脉,仙器
%%% @end
%%% Created : 13. 一月 2017 10:53
%%%-------------------------------------------------------------------
-module(dungeon_daily).
-author("hxming").

-include("dungeon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("tips.hrl").
-include("achieve.hrl").
-include("sword_pool.hrl").
-include("task.hrl").
%% API
-compile(export_all).

init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_DUN_DAILY, #st_dun_daily{pkey = Player#player.key});
        false ->
            case dungeon_load:load_dun_daily(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_DUN_DAILY, #st_dun_daily{pkey = Player#player.key});
                [DunList] ->
                    lib_dict:put(?PROC_STATUS_DUN_DAILY, #st_dun_daily{pkey = Player#player.key, dun_list = util:bitstring_to_term(DunList)})
            end

    end.

timer_update() ->
    St = lib_dict:get(?PROC_STATUS_DUN_DAILY),
    if St#st_dun_daily.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_DUN_DAILY, St#st_dun_daily{is_change = 0}),
        dungeon_load:replace_dun_daily(St);
        true -> ok
    end.

logout() ->
    St = lib_dict:get(?PROC_STATUS_DUN_DAILY),
    if St#st_dun_daily.is_change == 1 ->
        dungeon_load:replace_dun_daily(St);
        true -> ok
    end.

%%副本列表
dungeon_list(Player, Type) ->
    St = lib_dict:get(?PROC_STATUS_DUN_DAILY),
    F = fun(DunId, {IsSweep, L}) ->
        case data_dungeon:get(DunId) of
            [] -> {IsSweep, L};
            Base ->
                Count = dungeon_util:get_dungeon_times(DunId),
                State =
                    if Player#player.lv < Base#dungeon.lv -> 0;
                        Base#dungeon.count =< Count -> 2;
                        true ->
                            1
                    end,
                IsPass = lists:member(DunId, St#st_dun_daily.dun_list),
                IsSweep1 =
                    case IsPass of
                        true ->
                            if Base#dungeon.count =< Count -> 0;
                                true ->
                                    1
                            end;
                        false -> 0
                    end,
                NewIsSweep = max(IsSweep, IsSweep1),
                PassState = ?IF_ELSE(IsPass, 1, 0),
                {NewIsSweep, [[DunId, State, PassState] | L]}
        end
        end,
    lists:foldl(F, {daily:get_count(?DAILY_DUN_DAILY_SWEEP(Type)), []}, data_dungeon_daily:get(Type)).

%%扫荡
sweep(Player, Type) ->
    St = lib_dict:get(?PROC_STATUS_DUN_DAILY),
    F = fun(DunId) ->
        case lists:member(DunId, St#st_dun_daily.dun_list) of
            false -> [];
            true ->
                case data_dungeon:get(DunId) of
                    [] -> [];
                    Base ->
                        Count = dungeon_util:get_dungeon_times(DunId),
                        if Base#dungeon.lv > Player#player.lv -> [];
                            Count >= Base#dungeon.count -> [];
                            true ->
                                dungeon_util:add_dungeon_times(DunId),
                                PassGoods = [[Gid, Num, ?DROP_TYPE_PASS] || {Gid, Num} <- get_pass_goods(DunId)],
                                DropGoods = [[Gid, Num, ?DROP_TYPE_RATIO] || {Gid, Num} <- get_drop_goods(DunId)],
                                fb_trigger(Player, DunId),
                                achieve_type(Player, DunId),
                                task_event:event(?TASK_ACT_DUNGEON, {DunId, 1}),
                                act_hi_fan_tian:trigger_finish_api(Player,2,1),
                                [[DunId, PassGoods ++ DropGoods]]
                        end
                end
        end
        end,
    case lists:flatmap(F, data_dungeon_daily:get(Type)) of
        [] -> {15, [], Player};
        InfoList ->
            GoodsList = lists:flatmap(fun([_, L]) -> [{Gid, Num} || [Gid, Num, _] <- L] end, InfoList),
            GoodsList1 = goods:merge_goods(GoodsList),
            GiveGoodsList = goods:make_give_goods_list(216, GoodsList1),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            daily:increment(?DAILY_DUN_DAILY_SWEEP(Type), 2),
            activity:get_notice(Player, [99, 101, 115], true),
            {1, InfoList, NewPlayer}
    end.


%%首通奖励
get_first_goods(DunId) ->
    case data_dungeon_daily:first_goods(DunId) of
        [] -> [];
        Goods -> tuple_to_list(Goods)
    end.
%%通关奖励
get_pass_goods(DunId) ->
    case data_dungeon_daily:pass_goods(DunId) of
        [] -> [];
        Goods -> tuple_to_list(Goods)
    end.
%%掉落
get_drop_goods(DunId) ->
    case data_dungeon_daily:drop_goods(DunId) of
        [] -> [];
        GoodsList ->
            RatioList = [{Gid, Ratio} || {Gid, _, Ratio} <- GoodsList],
            case util:list_rand_ratio(RatioList) of
                0 -> [];
                Gid ->
                    case lists:keyfind(Gid, 1, GoodsList) of
                        false -> [];
                        {_, Num, _} ->
                            [{Gid, Num}]
                    end
            end
    end.

get_enter_dungeon_extra(DunId) ->
    St = lib_dict:get(?PROC_STATUS_DUN_DAILY),
    case lists:member(DunId, St#st_dun_daily.dun_list) of
        false -> [{first_pass, 1}];
        true -> []
    end.

%%副本结算
dun_daily_ret(1, Player, DunId) ->
    dungeon_util:add_dungeon_times(DunId),
    St = lib_dict:get(?PROC_STATUS_DUN_DAILY),
    IsFirst =
        case lists:member(DunId, St#st_dun_daily.dun_list) of
            true -> false;
            false ->
                NewSt = St#st_dun_daily{dun_list = [DunId | St#st_dun_daily.dun_list], is_change = 1},
                lib_dict:put(?PROC_STATUS_DUN_DAILY, NewSt),
                true
        end,
    PassGoods = get_pass_goods(DunId),
    DropGoods = get_drop_goods(DunId),
    FirstGoods = ?IF_ELSE(IsFirst, get_first_goods(DunId), []),
    GoodsList = PassGoods ++ DropGoods ++ FirstGoods,
    GoodsList1 = goods:merge_goods(GoodsList),
    GiveGoodsList = goods:make_give_goods_list(217, GoodsList1),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    PackGoodsList = [[Gid, Num, ?DROP_TYPE_PASS] || {Gid, Num} <- PassGoods] ++ [[Gid, Num, ?DROP_TYPE_RATIO] || {Gid, Num} <- DropGoods] ++ [[Gid, Num, ?DROP_TYPE_FIRST] || {Gid, Num} <- FirstGoods],
    {ok, Bin} = pt_121:write(12143, {1, DunId, PackGoodsList}),
    fb_trigger(Player, DunId),
    server_send:send_to_sid(Player#player.sid, Bin),
    achieve_type(Player, DunId),
    activity:get_notice(Player, [99, 101, 115], true),
    NewPlayer;
dun_daily_ret(_, Player, DunId) ->
    {ok, Bin} = pt_121:write(12143, {0, DunId, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player.

%%获取可扫荡波数
get_sweep_round(_Player, Type) ->
    St = lib_dict:get(?PROC_STATUS_DUN_DAILY),
    F = fun(DunId) ->
        case lists:member(DunId, St#st_dun_daily.dun_list) of
            true -> [DunId];
            false -> []
        end
        end,
    lists:flatmap(F, data_dungeon_daily:get(Type)).

%%经验找回
fb_trigger(Player, DunId) ->
    Type = data_dungeon_daily:get_type(DunId),
    fb_trigger(Player, Type, DunId).
fb_trigger(Player, Type, DunId) ->
    case Type of
        1 -> %%剧情副本
            findback_src:fb_trigger_src(Player, 13, [DunId]);
        2 -> %%神器
            findback_src:fb_trigger_src(Player, 14, [DunId]);
        3 ->
            findback_src:fb_trigger_src(Player, 15, [DunId]);
        4 ->
            findback_src:fb_trigger_src(Player, 16, [DunId]);
        _ ->
            skip
    end.

%%触发成就
achieve_type(Player, DunId) ->
    case data_dungeon_daily:get_type(DunId) of
        1 ->
            sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_DUN_STORY),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2004, 0, 1);
        2 ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2006, 0, 1);
        3 ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2008, 0, 1);
        4 ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2007, 0, 1);
        _ -> ok
    end.

check_saodang_state(Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_DUN_DAILY),
    F = fun(Type, AccTips) ->
        F = fun(DunId) ->
            case lists:member(DunId, St#st_dun_daily.dun_list) of
                false -> [];
                true ->
                    case data_dungeon:get(DunId) of
                        [] -> [];
                        Base ->
                            Count = dungeon_util:get_dungeon_times(DunId),
                            if Base#dungeon.lv > Player#player.lv -> [];
                                Count >= Base#dungeon.count -> [];
                                true -> [DunId]
                            end
                    end
            end
            end,
        case lists:flatmap(F, data_dungeon_daily:get(Type)) of
            [] -> AccTips;
            _ ->
                AccTips#tips{
                    state = 1,
                    saodang_dungeon_list = [Type | AccTips#tips.saodang_dungeon_list]
                }
        end
        end,
    lists:foldl(F, Tips, ?DUNGEON_TYPE_DAILY_LIST).

%%查询升级是否有可挑战
check_uplv_dungeon_state(Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_DUN_DAILY),
    F = fun(Type, AccTips) ->
        F1 = fun(DunId) ->
            case data_dungeon:get(DunId) of
                [] ->
                    [];
                Base ->
                    case lists:member(DunId, St#st_dun_daily.dun_list) of
                        true ->
                            [];
                        false ->
                            if
                                Base#dungeon.lv > Player#player.lv -> [];
                                true -> [DunId]
                            end
                    end
            end
             end,
        case lists:flatmap(F1, data_dungeon_daily:get(Type)) of
            [] -> AccTips;
            DunIdList ->
                [DunId | _] = lists:sort(DunIdList),
                NAccTips =
                    AccTips#tips{
                        state = 1,
                        uplv_dungeon_list = [Type | AccTips#tips.uplv_dungeon_list]
                    },
                case Type of
                    ?TIPS_DUNGEON_TYPE_DAILY_ONE -> NAccTips#tips{args1 = DunId};
%%                     ?TIPS_DUNGEON_TYPE_DAILY_TWO -> NAccTips#tips{args2 = DunId};
%%                     ?TIPS_DUNGEON_TYPE_DAILY_THREE -> NAccTips#tips{args3 = DunId};
                    ?TIPS_DUNGEON_TYPE_DAILY_FOUR -> NAccTips#tips{args4 = DunId};
                    _ ->
                        NAccTips
                end
        end
        end,
    lists:foldl(F, Tips, ?DUNGEON_TYPE_DAILY_LIST).

get_notice_player(Player, DunType) ->
    F1 = fun(DunId) ->
        case data_dungeon:get(DunId) of
            [] ->
                [];
            Base ->
                Count = dungeon_util:get_dungeon_times(DunId),
                if
                    Player#player.lv < Base#dungeon.lv -> [];
                    Count > 0 -> [];
                    true ->
                        [1]
                end
        end
    end,
    List = lists:flatmap(F1, data_dungeon_daily:get(DunType)),
    ?IF_ELSE(List == [], 0, 1).