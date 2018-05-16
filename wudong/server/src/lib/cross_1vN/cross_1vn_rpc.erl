%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2017 15:04
%%%-------------------------------------------------------------------
-module(cross_1vn_rpc).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("daily.hrl").
-include("cross_1vN.hrl").

%% API
-export([handle/3]).

%%获取活动信息
handle(64200, Player, {}) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_1VN_SHOP),
    ?DEBUG("St ~p~n", [St]),
    {State, Time} = cross_1vn_util:get_act_state_cache(),
    {ok, Bin} = pt_642:write(64200, {State, max(0, Time - util:unixtime())}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取报名信息
handle(64201, Player, {}) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_1VN_SHOP),
    ?DEBUG("St ~p~n", [St]),
    State = cross_1vn_util:get_act_state(),
    ?DEBUG("time ~p~n", [util:unixtime()]),
    if
        State == 0 ->
            {ok, Bin} = pt_642:write(64201, {0, 0, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            cross_area:apply(cross_1vn, get_sign_info, [Player#player.key, node(), Player#player.sid, Player#player.lv])
    end;


%%报名参加
handle(64202, Player, {}) ->
    State = cross_1vn_util:get_act_state(),
    if
        State == 0 ->
            {ok, Bin} = pt_642:write(64202, {2}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            cross_area:apply(cross_1vn, sign_up, [Player#player.key, node(), Player#player.sid, cross_1vn_util:make_player(Player)])
    end;


%%退出
handle(64207, Player, {}) ->
    case scene:is_cross_1vn_war_all_scene(Player#player.scene) of
        false -> ok;
        true ->
            cross_area:apply(cross_1vn, cross_1vn_quit, [Player#player.key, Player#player.copy]),
            Player#player.pid ! quit_cross_1vn,
            Player2 = Player#player{group = 0, figure = 0},
            {ok, Bin} = pt_120:write(12027, {Player#player.key, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            NewPlayer = player_util:count_player_attribute(Player2, true),
            scene_agent_dispatch:figure(NewPlayer),
            scene_agent_dispatch:group_update(NewPlayer),
            ok
    end;

%%获取准备场景信息
handle(64208, Player, _) ->
    Exp = daily:get_count(?DAILY_CROSS_1VN_EXP),
    cross_area:apply(cross_1vn, get_fight_info, [Player#player.key, Player#player.sid, node(), Exp]),
    ok;

%%获取资格赛排名列表
handle(64209, Player, {Group, Page}) ->
    ?DEBUG("64209 ~n"),
    cross_area:apply(cross_1vn, get_rank_info, [Group, Player#player.key, Player#player.sid, Page, node()]),
    ok;

%%获取擂主赛排名列表
handle(64211, Player, {Group, Page}) ->
    ?DEBUG("64211 ~p / ~p~n", [Group, Page]),
    cross_area:apply(cross_1vn, get_final_rank_info, [Group, Player#player.key, Player#player.sid, Page, node()]),
    ok;

%%膜拜擂主
handle(64212, Player, {}) ->
    {Res, NewPlayer} = cross_1vn:orz_winner_reward(Player),
    {ok, Bin} = pt_642:write(64212, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%领取擂主奖励
handle(64213, Player, {}) ->
    {Res, NewPlayer} = cross_1vn:get_winner_reward(Player),
    {ok, Bin} = pt_642:write(64213, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取决赛准备场景信息
handle(64214, Player, _) ->
    Exp = daily:get_count(?DAILY_CROSS_1VN_EXP),
    ExpUp =
        case cache:get({cross_1vn_winner_state, Player#player.key}) of
            [] -> 0;
            {State, ExpUp0} -> ?IF_ELSE(State == 0, 0, ExpUp0)
        end,
    cross_area:apply(cross_1vn, get_final_fight_info, [Player#player.key, Player#player.sid, node(), Exp, util:floor(ExpUp * 100)]),
    ok;

%%获取抢购商店列表
handle(64220, Player, {Type}) ->
    cross_1vn:get_shop_info(Player, Type),
    ok;

%%抢购商店购买
handle(64221, Player, {Type, Id}) ->
    {Res, NewPlayer} = cross_1vn:shop_buy(Player, Type, Id),
    {ok, Bin} = pt_642:write(64221, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%获取膜拜信息
handle(64223, Player, {Group}) ->
    Count = daily:get_count(?DAILY_CROSS_1VN_REWARD),
    St = lib_dict:get(?PROC_STATUS_CROSS_1VN_SHOP),
    State1 = ?IF_ELSE(St#st_cross_1vn_shop.floor < 1, 0, 1),
    cross_area:apply(cross_1vn, get_orz_info, [node(), Player#player.sid, Count, State1, Group]),
    ok;

%%获取历史记录
handle(64224, Player, _) ->
    cross_area:apply(cross_1vn, get_history_group, [node(), Player#player.sid]),
    ok;

%%历史守擂记录
handle(64225, Player, {Month, Day, Group}) ->
%%     cross_area:apply(cross_1vn, get_history_info, [Player#player.sid, node(), 1, 10, 1]),
    cross_area:apply(cross_1vn, get_history_info, [Player#player.sid, node(), Month, Day, Group]),
    ok;

%%获取下注信息
handle(64226, Player, {Group}) ->
    Exp = daily:get_count(?DAILY_CROSS_1VN_EXP),
    ExpUp =
        case cache:get({cross_1vn_winner_state, Player#player.key}) of
            [] -> 0;
            {State, ExpUp0} -> ?IF_ELSE(State == 0, 0, ExpUp0)
        end,
    ?DEBUG("get_bet_info ~n"),
    cross_area:apply(cross_1vn, get_bet_info, [Player#player.sid, node(), Player#player.key, Group, Exp, util:floor(ExpUp * 100)]),
    ok;

%% 中场投注
handle(64227, Player, {Group, Floor, CostId, Type}) ->
%% handle(64227, Player, {}) ->
    {Res, NewPlayer} = cross_1vn:player_bet(Player, Group, Floor, CostId, Type),
    ?DEBUG("res ~p~n", [Res]),
    {ok, Bin} = pt_642:write(64227, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取擂主竞猜信息
handle(64228, Player, {Group}) ->
    Count = daily:get_count(?DAILY_CROSS_1VN_WINNER_BET),
    cross_area:apply(cross_1vn, get_winner_bet_info, [Player#player.sid, node(), Player#player.key, Group, Count]),
    ok;

%% 擂主投注
handle(64229, Player, {Group, WinnerKey, CostId}) ->
    {Res, NewPlayer, Msg} = cross_1vn:winner_bet(Player, Group, WinnerKey, CostId),
    ?DEBUG("res ~p~n", [Res]),
    {ok, Bin} = pt_642:write(64229, {Res, Msg}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取擂主竞猜信息
handle(64230, Player, {}) ->
    cross_area:apply(cross_1vn, get_bet_history_info, [Player#player.sid, node(), Player#player.key]),
    ok;


%% 获取经验加成
handle(64232, Player, _) ->
    Ids = data_cross_1vn_fianl_floor_exp:get_all(),
    F = fun(Id) ->
        [Id, data_cross_1vn_fianl_floor_exp:get(Id)]
    end,
    Data = lists:map(F, Ids),
    {ok, Bin} = pt_642:write(64232, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(_cmd, _Player, _Data) ->
    ?DEBUG("cmd ~p err~n", [_cmd]),
    ok.
