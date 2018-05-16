%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十月 2017 17:53
%%%-------------------------------------------------------------------
-module(cross_scuffle_elite_rpc).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("daily.hrl").
-include("cross_scuffle_elite.hrl").
%% API
-export([handle/3]).

%%检查状态
handle(58501, Player, {}) ->
    cross_all:apply(cross_scuffle_elite, check_state, [node(), Player#player.sid]),
    ok;

%%获取精英赛页面信息
handle(58502, Player, {}) ->
    if
        Player#player.war_team#st_war_team.war_team_key == 0 ->
            Role = case cross_all:apply_call(cross_scuffle_elite_war_team_ets, get_war_team_member, [Player#player.key]) of
                       false -> #wt_member{};
                       [] -> #wt_member{};
                       Other -> Other
                   end,
            Data = {Player#player.match_state, 0, <<>>, 0, 0, 0, 0, [cross_scuffle_elite:get_player_info(Player, Player#player.key, 0, Role, node)]},
            {ok, Bin} = pt_585:write(58502, Data),
            server_send:send_to_sid(Player#player.sid, Bin);
        true ->
            ?DEBUG("Player#player.war_team#st_war_team.war_team_key ~p~n", [Player#player.war_team#st_war_team.war_team_key]),
            {AllMember, WarTeam} = cross_all:apply_call(cross_scuffle_elite_war_team_ets, get_info, [Player#player.war_team#st_war_team.war_team_key]),

            IsRecord = is_record(WarTeam, war_team),
            if
                IsRecord -> WarTeam1 = WarTeam;
                true -> WarTeam1 = #war_team{}
            end,
            cross_scuffle_elite:get_info(Player, AllMember, WarTeam1)
    end,
    ok;

%%获取创建战队信息
handle(58503, Player, _) ->
    {ok, Bin} = pt_585:write(58503, {?CREAT_COST}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%创建战队
handle(58504, Player, {WarTeamName}) ->
    ?DEBUG("58504 ~n"),
    WarTeamKey = misc:unique_key(),
    case money:is_enough(Player, ?CREAT_COST, bgold) of
        false ->
            {ok, Bin} = pt_585:write(58504, {4}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _ ->
            case cross_all:apply_call(cross_scuffle_elite_war_team, create_war_team, [Player, WarTeamName, WarTeamKey]) of
                {false, Res} ->
                    {ok, Bin} = pt_585:write(58504, {Res}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                {Ret, WarTeam} ->
                    ?DEBUG("arTeam#war_team.wtkey ~p~n", [WarTeam#war_team.wtkey]),
                    Player0 = money:add_bind_gold(Player, -?CREAT_COST, 307, 0, 0),
                    StWarTeam = #st_war_team{war_team_key = WarTeam#war_team.wtkey, war_team_name = WarTeamName, war_team_position = ?WAR_TEAM_POSITION_CHAIRMAN},
                    Player2 = Player0#player{war_team = StWarTeam},
                    shadow_proc:set(Player),
                    {ok, Bin} = pt_585:write(58504, {Ret}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    cross_scuffle_elite_log:log_guild(WarTeam#war_team.wtkey, WarTeam#war_team.name, WarTeam#war_team.pkey, WarTeam#war_team.pname, 1, util:unixtime()),
                    {ok, war_team, Player2};
                _Err ->
                    ?ERR("creat war team _Err ~p~n", [_Err]),
                    {ok, Bin} = pt_585:write(58504, {0}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok
            end
    end;

%%获取可邀请列表
handle(58505, Player, {Type}) ->
    Data = cross_scuffle_elite:get_invite_list(Player, Type),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_585:write(58505, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%邀请加入战队
handle(58506, Player, {Pkey}) ->
    Ret = cross_scuffle_elite_war_team_util:invite(Player, Pkey),
    ?DEBUG("Ret ~p~n", [Ret]),
    {ok, Bin} = pt_585:write(58506, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%战队邀请回应
handle(58508, Player, {WtKey, Result}) ->
    cross_all:apply(cross_scuffle_elite_war_team_util, re_invite, [Player, WtKey, Result, node()]),
    ok;

%%获取战队申请列表
handle(58510, Player, {Page}) ->
    cross_all:apply(cross_scuffle_elite_war_team_util, war_team_apply_list, [Player, Page, node()]),
    ok;

%%战队申请审批
handle(58511, Player, {Pkey, Result}) ->
    OtherPlayer =
        case player_util:get_player(Pkey) of
            [] ->
                shadow_proc:get_shadow(Pkey);
            OtherPlayer1 -> OtherPlayer1
        end,
    cross_all:apply(cross_scuffle_elite_war_team_util, war_team_approval, [Player, OtherPlayer, Result, node()]),
    ok;

%%退出战队
handle(58512, Player, {}) ->
    cross_all:apply(cross_scuffle_elite_war_team_util, war_team_quit, [Player, node()]),
    ok;

%%踢出战队
handle(58513, Player, {PKey}) ->
    OnlineState =
        case player_util:get_player_online(PKey) of
            [] -> false;
            _ -> true
        end,

    cross_all:apply(cross_scuffle_elite_war_team_util, war_team_kickout, [Player, PKey,OnlineState, node()]),
    ok;

%% 申请加入战队
handle(58514, Player, {WtKey}) ->
    Key = misc:unique_key(),
    DailyApply = daily:get_count(?DAILY_WAR_TEAM_APPLY),
    if
        DailyApply =< 5 ->
            daily:increment(?DAILY_WAR_TEAM_APPLY, 1),
            cross_all:apply(cross_scuffle_elite_war_team_util, war_team_apply, [Player, WtKey, Key, node()]);
        true ->
            {ok, Bin} = pt_585:write(58514, {32, WtKey}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok;

%%发起匹配
handle(58517, Player, {}) ->
    OpenDay = config:get_open_days(),
    Ret =
        if
            Player#player.convoy_state > 0 -> 22;
            Player#player.match_state > 0 -> 23;
            Player#player.marry#marry.cruise_state > 0 -> 24;
            Player#player.war_team#st_war_team.war_team_key == 0 -> 21;
            OpenDay =< 3 -> 30;
            true ->
                case scene:is_normal_scene(Player#player.scene) of
                    false -> 25;
                    true ->
                        case cross_scuffle_elite:check_team_state(Player) of
                            {true, MbList} ->
                                cross_all:apply(cross_scuffle_elite, match_team, [node(), Player#player.key, Player#player.sid, Player#player.war_team#st_war_team.war_team_key, MbList]),
                                ok;
                            Err -> Err
                        end
                end
        end,
    case Ret of
        ok -> ok;
        {false, Code, Name} ->
            {ok, Bin} = pt_585:write(58517, {Code, Name}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _ ->
            {ok, Bin} = pt_585:write(58517, {Ret, <<>>}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%获取战队列表
handle(58518, Player, {Page, Type}) ->
    cross_all:apply(cross_scuffle_elite_war_team_util, get_war_team_list, [Player, Page, Type, node()]),
    ok;

%%挑战统计58408
handle(58520, Player, {}) ->
    case scene:is_cross_scuffle_elite_scene(Player#player.scene) of
        false -> ok;
        true ->
            cross_all:apply(cross_scuffle_elite, scuffle_elite_info, [Player#player.key, Player#player.copy]),
            ok
    end;


%%buff碰撞
handle(58521, Player, {Mkey}) ->
    case scene:is_cross_scuffle_elite_scene(Player#player.scene) of
        false -> ok;
        true ->
            cross_all:apply(cross_scuffle_elite, crash_buff, [node(), Player#player.pid, Player#player.sid, Mkey, Player#player.copy, Player#player.x, Player#player.y]),
            ok
    end;

handle(58524, Player, {}) ->
    case scene:is_cross_scuffle_elite_scene(Player#player.scene) of
        false -> ok;
        true ->
            Player0 = buff:del_buff_only(Player, ?SCUFFLE_ELITE_COMBO_BUFF_ID),
            cross_all:apply(cross_scuffle_elite, scuffle_elite_quit, [Player#player.key, Player#player.copy]),
            Player1 = cross_scuffle_elite:sendout_scene(Player0),
            Player2 = Player1#player{group = 0, figure = 0},
            {ok, Bin} = pt_120:write(12027, {Player#player.key, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            NewPlayer = player_util:count_player_attribute(Player2, true),
            scene_agent_dispatch:figure(NewPlayer),
            scene_agent_dispatch:group_update(NewPlayer),
            {ok, NewPlayer}
    end;


%%快捷聊天
handle(58525, Player, {Type}) ->
    case scene:is_cross_scuffle_elite_scene(Player#player.scene) of
        false -> ok;
        true ->
            {ok, Bin} = pt_585:write(58525, {Player#player.key, Type}),
            server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
            ok
    end;

%%一键拒绝
handle(58528, Player, {}) ->
    cross_all:apply(cross_scuffle_elite_war_team_util, refused_all, [Player]),
    {ok, Bin} = pt_585:write(58528, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;
%%获取精英赛奖励
handle(58529, Player, {}) ->
    F = fun(Id) ->
        GoodsList = data_cross_scuffle_elite_final_reward:get(Id),
        [Id, goods:pack_goods(GoodsList)]
    end,
    Data = lists:map(F, [1, 2, 3, 4, 5, 7]),
    {ok, Bin} = pt_585:write(58529, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%查看赛程
handle(58530, Player, {}) ->
    cross_all:apply(cross_scuffle_elite, get_war_map, [Player#player.sid, node()]),
    ok;

%%准备场景信息
handle(58531, Player, {}) ->
    cross_all:apply(cross_scuffle_elite, get_ready_info, [Player#player.sid, node()]),
    ok;

%%进入准备场景
handle(58532, Player, {}) ->
    cross_all:apply(cross_scuffle_elite, get_ready_info, [Player#player.sid, node()]),
    ok;

%%查看投注信息
handle(58535, Player, {FightNum}) ->
    cross_all:apply(cross_scuffle_elite, get_bet_info, [Player#player.sid, node(), FightNum, Player#player.key]),
    ok;

%%赛程下注
handle(58536, Player, {FightNum, WtKey, Id}) ->
    ?DEBUG("58536 ~p~n", [{FightNum, Id}]),
    case cross_scuffle_elite:get_bet_base(FightNum, Id) of
        [] -> ok;
        Base ->
            Ret =
                case Base#base_cross_scuffle_elite_bet.goods_id of
                    10101 ->  %% 银币
                        IsEnough = money:is_enough(Player, Base#base_cross_scuffle_elite_bet.num, coin),
                        if IsEnough -> 1;
                            true -> 36
                        end;
                    10106 -> %% 绑定元宝
                        IsEnough = money:is_enough(Player, Base#base_cross_scuffle_elite_bet.num, bgold),
                        if IsEnough -> 1;
                            true -> 4
                        end;
                    _ -> 0
                end,
            NewPlayer =
                if Ret == 1 ->
                    Ret1 = cross_all:apply_call(cross_scuffle_elite, bet_war_team, [Player#player.sid, node(), Player#player.key, FightNum, WtKey, Id]),
                    if Ret1 == 1 ->
                        {ok, Bin} = pt_585:write(58536, {Ret1}),
                        server_send:send_to_sid(Player#player.sid, Bin),
                        case Base#base_cross_scuffle_elite_bet.goods_id of
                            10101 ->
                                money:add_coin(Player, -Base#base_cross_scuffle_elite_bet.num, 314, 0, 0);
                            10106 ->
                                money:add_gold(Player, -Base#base_cross_scuffle_elite_bet.num, 314, 0, 0);
                            _ ->
                                Player
                        end;
                        true ->
                            ?DEBUG("Ret1 ~p~n", [Ret1]),
                            {ok, Bin} = pt_585:write(58536, {Ret1}),
                            server_send:send_to_sid(Player#player.sid, Bin),
                            Player
                    end;
                    true ->
                        {ok, Bin} = pt_585:write(58536, {Ret}),
                        server_send:send_to_sid(Player#player.sid, Bin),
                        Player
                end,
            {ok, NewPlayer}
    end;

handle(_Cmd, _Player, Msg) ->
    ?ERR("cmd ~p msg ~p undef~n", [_Cmd, Msg]),
    ok.
