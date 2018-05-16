%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 一月 2015 下午4:41
%%%-------------------------------------------------------------------
-module(battle_rpc).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("skill.hrl").
-include("daily.hrl").

%% API
-export([handle/3]).

%%战斗
handle(20001, Player, {SkillId, _AttType, Tx, Ty, TargetList}) ->
%%    ?DO_IF(Player#player.key==300010007,?PRINT("battle ~p/~p  ~p/~p longtime ~p~n", [Player#player.x,Player#player.y,Tx,Ty,util:longunixtime()])),
    SkillBattleList = Player#player.skill ++ Player#player.xian_skill,
%%     ?DEBUG("pkey ~p SkillId ~p TargetList ~p~n SkillBattleList:~p ~n",[Player#player.key,SkillId,TargetList, SkillBattleList]),
    LongTime = util:longunixtime(),
    %%可接模式下才能攻击
    if Player#player.is_view /= ?VIEW_MODE_ALL -> ok;
        true ->
            case LongTime - Player#player.att_time > 300 of
                true ->
                    Flag99 = lists:member(SkillId, Player#player.xian_skill),
                    NewSkillId =
                        if
                            Flag99 == true -> SkillId;
                            Player#player.scene == ?SCENE_ID_CROSS_ELIMINATE -> 0;
                            Player#player.scene == ?SCENE_ID_CROSS_SCUFFLE ->
                                DefaultSkillId = ?IF_ELSE(lists:member(SkillId, data_skill:career_skills(6)), SkillId, 0),
                                ?IF_ELSE(lists:member(SkillId, Player#player.scuffle_skill), SkillId, DefaultSkillId);
                            Player#player.scene == ?SCENE_ID_CROSS_SCUFFLE_ELITE ->
                                DefaultSkillId = ?IF_ELSE(lists:member(SkillId, data_skill:career_skills(6)), SkillId, 0),
                                ?IF_ELSE(lists:member(SkillId, Player#player.scuffle_skill), SkillId, DefaultSkillId);
                            Player#player.scene == ?SCENE_ID_CROSS_WAR ->
                                DefaultSkillId = ?IF_ELSE(lists:member(SkillId, data_skill:career_skills(6)), SkillId, 0),
                                ?IF_ELSE(lists:member(SkillId, data_cross_war_skill:get_all()), SkillId, DefaultSkillId);
                            true ->
                                IsEvilSkill = lists:member(SkillId, ?SKILL_EVIL_LIST),
                                IsGodnessSkill = lists:member(SkillId, godness:get_war_godness_skill()),
                                if
                                    IsEvilSkill orelse IsGodnessSkill -> ?IF_ELSE(Player#player.evil#pevil.evil == 1, SkillId, 0);
                                    true ->
                                        DefaultSkillId = ?IF_ELSE(lists:member(SkillId, data_skill:career_skills(6)), SkillId, 0),
                                        ?IF_ELSE(lists:member(SkillId, SkillBattleList), SkillId, DefaultSkillId)
                                end
                        end,
                    scene_agent:apply_cast(Player#player.scene, Player#player.copy, battle, battle, [?SIGN_PLAYER, Player#player.key, {NewSkillId, Tx, Ty}, TargetList]),
                    {ok, Player#player{att_time = LongTime}};
                false ->
                    {ok, Player#player{att_time = Player#player.att_time + 100}}
            end
    end;


%%采集
handle(20003, Player, {Mkey, Action}) ->
    PartyTimes = daily:get_count(?DAILY_PARTY_TIMES),
    scene_agent:apply_cast(Player#player.scene, Player#player.copy, battle, collect, [Player#player.key, Mkey, Action, Player#player.figure, Player#player.lv, PartyTimes]),
    ok;

handle(20005, Player, {}) ->
    BuffList = battle_pack:pack_buff_list(Player#player.buff_list, util:unixtime()),
    {ok, Bin} = pt_200:write(20005, {1, Player#player.key, BuffList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%复活
handle(20010, Player, {Rtype, S_Career}) ->
    Player2 = player_battle:revive(Player, Rtype, S_Career),
    {ok, Player2};


%%施法开始
handle(20012, Player, _) ->
    Player2 = player_battle:conjure(Player),
    {ok, Player2};


%%施法结束
handle(20013, Player, _) ->
    Player2 = player_battle:unconjure(Player),
    {ok, Player2};


%%pk状态修改
handle(20014, Player, {Pk}) ->
    Player2 = player_battle:pk_change(Player, Pk, 0),
    {ok, pk_val, Player2};

%%妖神变身
handle(20015, Player, _) when Player#player.scene /= ?SCENE_ID_CROSS_SCUFFLE andalso Player#player.scene /= ?SCENE_ID_CROSS_SCUFFLE_ELITE ->
    case player_evil:evil_trans(Player) of
        {false, Res} ->
            {ok, Bin} = pt_200:write(20015, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_200:write(20015, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, evil, NewPlayer}
    end;

%%妖神变身
handle(20017, Player, {Type}) when Player#player.scene /= ?SCENE_ID_CROSS_SCUFFLE andalso Player#player.scene /= ?SCENE_ID_CROSS_SCUFFLE_ELITE ->
    Res =
        case Type of
            1 -> player_evil:evil_trans(Player, true);
            _ -> player_evil:cancel_evil(Player)
        end,
    case Res of
        {false, Reason} ->
            {ok, Bin} = pt_200:write(20017, {Reason, Type}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_200:write(20017, {1, Type}),
            server_send:send_to_sid(Player#player.sid, Bin),
            case Type of
                1 -> {ok, evil, NewPlayer};
                _ -> {ok, NewPlayer}
            end
    end;

handle(_cmd, _Player, _Data) ->

    ok.

