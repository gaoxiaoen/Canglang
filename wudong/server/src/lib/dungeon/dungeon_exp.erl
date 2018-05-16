%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     经验副本
%%% @end
%%% Created : 12. 一月 2017 15:50
%%%-------------------------------------------------------------------
-module(dungeon_exp).
-author("hxming").

-include("server.hrl").
-include("dungeon.hrl").
-include("common.hrl").
-include("sword_pool.hrl").
-include("tips.hrl").
-include("achieve.hrl").
-include("task.hrl").

%% API
-compile(export_all).

init(Player, Now) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_DUN_EXP, #st_dun_exp{pkey = Player#player.key, time = Now});
        false ->
            case dungeon_load:load_dun_exp(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_DUN_EXP, #st_dun_exp{pkey = Player#player.key, time = Now});
                [RoundHighest, Round, Time] ->
                    case util:is_same_date(Now, Time) of
                        true ->
                            lib_dict:put(?PROC_STATUS_DUN_EXP, #st_dun_exp{pkey = Player#player.key, round_highest = RoundHighest, round = Round, time = Time});
                        false ->
                            lib_dict:put(?PROC_STATUS_DUN_EXP, #st_dun_exp{pkey = Player#player.key, round_highest = RoundHighest, round = 0, time = Now, is_change = 1})
                    end
            end
    end.

timer_update() ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    if St#st_dun_exp.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_DUN_EXP, St#st_dun_exp{is_change = 1}),
        dungeon_load:replace_dun_exp(St);
        true -> ok
    end.

logout() ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    if St#st_dun_exp.is_change == 1 ->
        dungeon_load:replace_dun_exp(St);
        true -> ok
    end.

midnight_refresh(Now) ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    lib_dict:put(?PROC_STATUS_DUN_EXP, St#st_dun_exp{round = 0, time = Now, is_change = 1}).


dungeon_list(_Player) ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    Round = ?IF_ELSE(St#st_dun_exp.round == 0, 1, St#st_dun_exp.round),
    RoundLim = data_dungeon_exp:max_round(),
    F1 = fun(DunId) ->
        [RoundMin, RoundMax] = data_dungeon_exp_round:get_round(DunId),
        State =
            if St#st_dun_exp.round >= RoundLim -> 2;
                true ->
                    ?IF_ELSE(data_dungeon_exp_round:check_round(DunId, Round), 1, 0)
            end,
        [DunId, RoundMin, RoundMax, State]
         end,
    DunList = lists:map(F1, data_dungeon_exp_round:dun_list()),
    {St#st_dun_exp.round, St#st_dun_exp.round_highest, DunList}.

%%扫荡
sweep(Player) ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    if St#st_dun_exp.round >= St#st_dun_exp.round_highest -> {10, [], Player};
        true ->
            case scene:is_dungeon_scene(Player#player.scene) of
                true -> {14, [], Player};
                false ->
                    F = fun(Round) ->
                        sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_DUN_EXP),
                        tuple_to_list(data_dungeon_exp:get_pass_goods(Round))
                        end,
                    GoodsList = goods:merge_goods(lists:flatmap(F, lists:seq(St#st_dun_exp.round + 1, St#st_dun_exp.round_highest))),
                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(213, GoodsList)),
                    NewSt = St#st_dun_exp{round = St#st_dun_exp.round_highest, is_change = 1},
                    lib_dict:put(?PROC_STATUS_DUN_EXP, NewSt),
%%                    act_hi_fan_tian:trigger_finish_api(Player,3,St#st_dun_exp.round_highest - St#st_dun_exp.round),
                    findback_src:fb_trigger_src(Player, 11, St#st_dun_exp.round_highest),
                    player:apply_state(async, self(), {activity, sys_notice, [98]}),
                    task_event:event(?TASK_ACT_DUN_EXP, {St#st_dun_exp.round_highest}),
                    {1, goods:pack_goods(GoodsList), NewPlayer}
            end
    end.

%%进入检查
check_enter(DunId) ->
    case dungeon_util:is_dungeon_exp(DunId) of
        false -> true;
        true ->
            St = lib_dict:get(?PROC_STATUS_DUN_EXP),
            case data_dungeon_exp_round:check_round(DunId, St#st_dun_exp.round + 1) of
                true -> true;
                false ->
                    {false, ?T("该副本已通关")}
            end
    end.

%%
get_enter_dungeon_extra(_DunId) ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    [{dun_exp_round_min, St#st_dun_exp.round + 1}, {dun_exp_round_max, data_dungeon_exp:max_round()}, {dun_exp_round_h, St#st_dun_exp.round_highest}].

get_enter_dungeon_round() ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    St#st_dun_exp.round.

%%波数奖励
update_dun_exp_round(Player, Round, PassGoodsList, FirstGoodsList) ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    NewSt = St#st_dun_exp{round = max(St#st_dun_exp.round, Round), round_highest = max(St#st_dun_exp.round_highest, Round), is_change = 1},
    lib_dict:put(?PROC_STATUS_DUN_EXP, NewSt),
    GoodsList = goods:make_give_goods_list(214, goods:merge_goods(PassGoodsList ++ FirstGoodsList)),
    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(214, GoodsList)),
    findback_src:fb_trigger_src(Player, 11, Round),
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2005, 0, Round),
    sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_DUN_EXP),
    task_event:event(?TASK_ACT_DUN_EXP, {Round}),
%%    dungeon_util:add_dungeon_times(Player#player.scene),
    NewPlayer.

%%副本结算
dungeon_exp_ret(Player, DunId, Round, GoodsList) ->
    {ok, Bin} = pt_121:write(12133, {DunId, Round, goods:pack_goods(GoodsList)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    player:apply_state(async, self(), {activity, sys_notice, [98]}),
    LogDungeon =
        #log_dungeon{
            pkey = Player#player.key,
            nickname = Player#player.nickname,
            cbp = Player#player.cbp,
            dungeon_id = DunId,
            dungeon_type = ?DUNGEON_TYPE_EXP,
            dungeon_desc = ?T("经验副本"),
            layer = Round,
            layer_desc = ?T(io_lib:format("第~p波", [Round])),
            sub_layer = 0,
            time = util:unixtime()
        },
    dungeon_log:log(LogDungeon).

%%获取扫荡波数
get_sweep_round(_Player) ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    St#st_dun_exp.round_highest.

%%检测是否扫荡
check_saodang_state(Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    if
        St#st_dun_exp.round >= St#st_dun_exp.round_highest -> Tips;
        true ->
            case scene:is_dungeon_scene(Player#player.scene) of
                true -> Tips;
                false ->
                    Tips#tips{state = 1, saodang_dungeon_list = [?TIPS_DUNGEON_TYPE_EXP | Tips#tips.saodang_dungeon_list]}
            end
    end.

get_notice_player(Player) ->
    Tips = check_saodang_state(Player, #tips{}),
    Tips2 = check_upcombat_dungeon_state(Player, Tips),
    ?IF_ELSE(Tips2#tips.state == 1, 1, 0).

check_upcombat_dungeon_state(Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_DUN_EXP),
    #st_dun_exp{
        round_highest = RoundHighest0
    } = St,
    RoundHighest = RoundHighest0 + 1,
    case data_dungeon_exp:get_combat_by_round(RoundHighest) of
        {CombatMin, _CombatAdd} when Player#player.cbp >= CombatMin ->
            DunId = data_dungeon_exp_round:get_scene(RoundHighest),
            Tips#tips{state = 1, args1 = DunId, args2 = RoundHighest, args3 = RoundHighest0, upcombat_dungeon_list = [?TIPS_DUNGEON_TYPE_EXP | Tips#tips.upcombat_dungeon_list]};
        _ ->
            Tips
    end.


%%     MaxRoundHighest = data_dungeon_exp:max_round(),
%%     if
%%         RoundHighest0 == MaxRoundHighest -> Tips;
%%         true ->
%%             RoundHighest = min(MaxRoundHighest, RoundHighest0 + 1),
%%             case get(?TIPS_DUNGEON_EXP_CACHE) of
%%                 undefined ->
%%                     case data_dungeon_exp:get_combat_by_round(RoundHighest) of
%%                         {CombatMin, CombatAdd} when Player#player.cbp >= CombatMin ->
%%                             put(?TIPS_DUNGEON_EXP_CACHE, {RoundHighest, Player#player.cbp + CombatAdd, CombatAdd}),
%%                             Tips#tips{state = 1, args1 = RoundHighest, args2 = RoundHighest0, upcombat_dungeon_list = [?DUNOGEON_TYPE_EXP | Tips#tips.upcombat_dungeon_list]}; %% 第一次推送;
%%                         {CombatMin, CombatAdd} ->
%%                             put(?TIPS_DUNGEON_EXP_CACHE, {RoundHighest, CombatMin, CombatAdd}),
%%                             Tips
%%                     end;
%%                 {OldRoundHighest, CombatLimit, CombatAdd} ->
%%                     if
%%                         RoundHighest == OldRoundHighest andalso CombatLimit =< Player#player.cbp ->
%%                             put(?TIPS_DUNGEON_EXP_CACHE, {RoundHighest, Player#player.cbp + CombatAdd, CombatAdd}),
%%                             Tips#tips{state = 1, args1 = RoundHighest, args2 = RoundHighest0, upcombat_dungeon_list = [?DUNOGEON_TYPE_EXP | Tips#tips.upcombat_dungeon_list]};
%%                         RoundHighest > OldRoundHighest ->
%%                             {_CombatMin, BaseCombatAdd} = data_dungeon_exp:get_combat_by_round(RoundHighest),
%%                             put(?TIPS_DUNGEON_EXP_CACHE, {RoundHighest, Player#player.cbp + BaseCombatAdd, BaseCombatAdd}),
%%                             Tips#tips{state = 1, args1 = RoundHighest, args2 = RoundHighest0, upcombat_dungeon_list = [?DUNOGEON_TYPE_EXP | Tips#tips.upcombat_dungeon_list]};
%%                         true ->
%%                             Tips
%%                     end;
%%                 _Other ->
%%                     io:format("#########_Other:~p~n", [_Other])
%%             end
%%     end.