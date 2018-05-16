%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 战斗统计相关
%%% @end
%%% Created : 09. 八月 2017 16:33
%%%-------------------------------------------------------------------
-module(cross_war_battle).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("guild.hrl").
-include("cross_war.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("skill.hrl").

%% API
-export([
    kill_mon/4,
    kill_mon_cast/4,
    kill_player/2,
    kill_player_cast/3,
    set_crown/2,
    collect/1,
    collect_cast/2,
    send_to_client_reward/3,
    recv_reward/2,

    cacl_hurt/2, %% 城战攻击造成伤害
    cacl_hurt2/2, %% 处理攻城车受到玩家攻击的伤害
    cacl_hurt3/2  %% 处理攻城车受到野怪的伤害
]).

kill_mon(Mon, Attacker, Klist, _TotalHurt) ->
    case scene:is_cross_war_scene(Mon#mon.scene) of
        false -> skip;
        true ->
            ?CAST(cross_war_proc:get_server_pid(), {kill_mon, Mon, Attacker, Klist})
    end.

kill_mon_cast(State, Mon, Attacker, _Klist) ->
    #attacker{sign = Sign, key = Pkey, gkey = Gkey} = Attacker,
    State99 =
        if
            Sign == 0 ->
                State;
            true ->
                CrossWarGuild = cross_war_util:get_by_g_key(Gkey),
                case Mon#mon.kind of
                    ?MON_KIND_CROSS_WAR_DOOR -> %% 攻破城门
                        [{kill_door, AddScore}] = data_cross_war_score_condition:get(2),
                        [{kill_door, AddMarteris}] = data_cross_war_materis_condition:get(2),
                        if
                            length(State#sys_cross_war.kill_war_door_list) == 0 ->
                                spawn(fun() -> cross_war_util:sys_cross_notice(cross_war_kill_door_1, []) end);
                            true ->
                                spawn(fun() -> cross_war_util:sys_cross_notice(cross_war_kill_door_2, []) end)
                        end,
                        if
                            CrossWarGuild#cross_war_guild.sign == ?CROSS_WAR_TYPE_ATT ->
                                cross_war_util:add_guild_score(Gkey, AddScore),
                                cross_war_util:add_player_score(Pkey, AddScore),
                                cross_war_util:add_materis_player(Pkey, AddMarteris),
                                CrossWarLog = make_cross_war_log(Pkey),
                                NewState = State#sys_cross_war{kill_war_door_list = [CrossWarLog | State#sys_cross_war.kill_war_door_list]},
                                spawn(fun() -> cross_war:notice_client_update_score(NewState) end),
                                KillDoorReward = data_cross_war_other_reward:get_door_reward(),
                                spawn(fun() ->
                                    center:apply(CrossWarGuild#cross_war_guild.node, ?MODULE, send_to_client_reward, [Pkey, KillDoorReward, 679]) end),
                                NewState;
                            true ->
                                State
                        end;
                    ?MON_KIND_CROSS_WAR_KING_DOOR -> %% 攻破王城城门
                        [{kill_insidedoor, AddScore}] = data_cross_war_score_condition:get(5),
                        [{kill_insidedoor, AddMarteris}] = data_cross_war_materis_condition:get(5),
                        spawn(fun() -> cross_war_util:sys_cross_notice(cross_war_kill_king_door, []) end),
                        if
                            CrossWarGuild#cross_war_guild.sign == ?CROSS_WAR_TYPE_ATT ->
                                cross_war_util:add_guild_score(Gkey, AddScore),
                                cross_war_util:add_player_score(Pkey, AddScore),
                                cross_war_util:add_materis_player(Pkey, AddMarteris),
                                CrossWarLog = make_cross_war_log(Pkey),
                                NewState = State#sys_cross_war{kill_king_door_list = [CrossWarLog | State#sys_cross_war.kill_king_door_list]},
                                spawn(fun() -> cross_war:notice_client_update_score(NewState) end),
                                KillDoorReward = data_cross_war_other_reward:get_door_reward(),
                                spawn(fun() ->
                                    center:apply(CrossWarGuild#cross_war_guild.node, ?MODULE, send_to_client_reward, [Pkey, KillDoorReward, 680]) end),
                                NewState;
                            true ->
                                State
                        end;
                    ?MON_KIND_CROSS_WAR_TOWER -> %% 攻破箭塔
                        [{kill_bartizan, AddScore}] = data_cross_war_score_condition:get(3),
                        [{kill_bartizan, AddMarteris}] = data_cross_war_materis_condition:get(3),
                        if
                            CrossWarGuild#cross_war_guild.sign == ?CROSS_WAR_TYPE_ATT ->
                                cross_war_util:add_guild_score(Gkey, AddScore),
                                cross_war_util:add_player_score(Pkey, AddScore),
                                cross_war_util:add_materis_player(Pkey, AddMarteris),
                                spawn(fun() -> cross_war:notice_client_update_score(State) end),
                                cross_war_map:update(State, Mon);
                            true ->
                                cross_war_map:update(State, Mon)
                        end;
                    ?MON_KIND_CROSS_WAR_BANNER -> %% 攻破旗子
                        if
                            CrossWarGuild#cross_war_guild.sign == ?CROSS_WAR_TYPE_ATT ->
                                spawn(fun() -> cross_war_util:sys_cross_notice(cross_war_kill_banner, []) end);
                            true -> skip
                        end,
                        {MonKey, MonPid} = mon_agent:create_mon([50109, ?SCENE_ID_CROSS_WAR, Mon#mon.x, Mon#mon.y, 0, 1, [{return_id_pid, true}, {godt, util:unixtime() + 60}, {group, CrossWarGuild#cross_war_guild.sign}, {show_time, util:unixtime() + 60}]]),
                        NewMon = Mon#mon{hp = Mon#mon.hp_lim, group = CrossWarGuild#cross_war_guild.sign},
                        NewState =
                            State#sys_cross_war{
                                kill_banner_sign = CrossWarGuild#cross_war_guild.sign,
                                kill_banner_time = util:unixtime(),
                                mon_list = [{MonKey, MonPid, NewMon} | State#sys_cross_war.mon_list]
                            },
                        cross_war_map:update(NewState, NewMon);
                    _ ->
                        [{kill_base_mon, AddMarteris}] = data_cross_war_materis_condition:get(6),
                        case lists:member(Mon#mon.mid, [50102, 50103, 50104, 50105, 50106, 50115, 50116, 50117]) of
                            true -> cross_war_util:add_materis_player(Pkey, AddMarteris);
                            false -> ok
                        end,
                        State
                end
        end,
    update_hp(State99, Mon).

update_hp(State, Mon) ->
    MonList = State#sys_cross_war.mon_list,
    NewMonList =
        case lists:keytake(Mon#mon.key, 1, MonList) of
            false -> MonList;
            {value, {MonKey, MonId, OldMon}, Rest} ->
                [{MonKey, MonId, OldMon#mon{hp = 0}} | Rest]
        end,
    State#sys_cross_war{mon_list = NewMonList}.

set_crown(Pkey, IsCrown) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] -> skip;
        [#ets_online{pid = Pid}] ->
            Pid ! {cross_war_set_crown, IsCrown}
    end.

make_cross_war_log(Pkey) ->
    CrossWarPlayer = cross_war_util:get_by_pkey(Pkey),
    #cross_war_player{
        nickname = NickName,
        sex = Sex,
        g_name = GuildName,
        sn = Sn,
        sn_name = SnName,
        wing_id = WingId,
        wepon_id = WeponId,
        clothing_id = ClothingId,
        light_wepon_id = LightWeponId,
        fashion_cloth_id = FashionClothId,
        fashion_head_id = FashionHeadId,
        score_rank = AttScoreRank
    } = CrossWarPlayer,
    CrossWarLog =
        #cross_war_log{
            pkey = Pkey,
            nickname = NickName,
            sex = Sex,
            g_name = GuildName,
            sn = Sn,
            sn_name = SnName,
            wing_id = WingId,
            wepon_id = WeponId,
            clothing_id = ClothingId,
            light_wepon_id = LightWeponId,
            fashion_cloth_id = FashionClothId,
            fashion_head_id = FashionHeadId,
            rank = AttScoreRank
        },
    CrossWarLog.

kill_player(Player, Attacker) ->
    ?CAST(cross_war_proc:get_server_pid(), {kill_player, Player, Attacker}).

kill_player_cast(State, Player, Attacker) ->
    #attacker{sign = AttSign, key = AttPkey, gkey = AttGkey, node = Node, x = X, y = Y} = Attacker,
    if
        AttSign == 0 ->
            cross_war_util:clean_player_kill_num(Player#player.key),
            if
                Player#player.crown == 1 ->
                    {MonKey, MonPid} = mon_agent:create_mon([?CROSS_WAR_MON_ID_KING_GOLD, ?SCENE_ID_CROSS_WAR, X, Y, 0, 1, [{return_id_pid, true}]]),
                    NewMap = cross_war_map:update_king_gold(State#sys_cross_war.map, X, Y, 0),
                    State#sys_cross_war{map = NewMap, mon_list = [{MonKey, MonPid, #mon{}} | State]};
                true ->
                    State
            end;
        true ->
            [{kill_player, AddMarteris}] = data_cross_war_materis_condition:get(1),
            cross_war_util:add_materis_player(AttPkey, AddMarteris),
            %% 处理掉玩家身上的皇冠
            if
                Player#player.crown == 1 ->
                    center:apply(Player#player.node, cross_war_battle, set_crown, [Player#player.key, 0]),
                    cross_war_util:set_player_crown(Player#player.key, 0),
                    center:apply(Node, cross_war_battle, set_crown, [AttPkey, 1]),
                    cross_war_util:set_player_crown(AttPkey, 1);
                true -> skip
            end,
            %% 处理掉玩家连杀
            cross_war_util:update_player_kill_num(AttPkey, 1),
            AttCrossWarGuild = cross_war_util:get_by_g_key(AttGkey),
            DefCrossWarPlayer = cross_war_util:get_by_pkey(Player#player.key),
            DefCrossWarGuild = cross_war_util:get_by_g_key(Player#player.guild#st_guild.guild_key),
            cross_war_util:clean_player_kill_num(Player#player.key),
            %% 终结玩家连杀公告
            if
                DefCrossWarPlayer#cross_war_player.acc_kill_num >= 2 ->
                    spawn(fun() ->
                        AttCrossWarPlayer = cross_war_util:get_by_pkey(AttPkey),
                        #cross_war_player{nickname = AttNickName} = AttCrossWarPlayer,
                        #cross_war_player{nickname = DefNickName, acc_kill_num = AccKillNum} = DefCrossWarPlayer,
                        if
                            AttCrossWarGuild#cross_war_guild.sign == ?CROSS_WAR_TYPE_DEF ->
                                AttSignName = ?T("防御方"),
                                DefSignName = ?T("攻击方");
                            true ->
                                DefSignName = ?T("防御方"),
                                AttSignName = ?T("攻击方")
                        end,
                        cross_war_util:sys_cross_notice(end_kill_acc_win, [AttSignName, AttNickName, DefSignName, DefNickName, AccKillNum])
                    end);
                true ->
                    ok
            end,
            %% 击杀玩家加积分
            [{kill_player, AddScore0}] = data_cross_war_score_condition:get(1),
            AttCrossWarPlayer = cross_war_util:get_by_pkey(AttPkey),
            AddScore1 = data_cross_war_acc_kill:get(AttCrossWarPlayer#cross_war_player.acc_kill_num),
            AddScore = AddScore0 + AddScore1,
            cross_war_util:add_guild_score(AttGkey, AddScore),
            cross_war_util:add_player_score(AttPkey, AddScore),
            %% 处理攻击者连杀公告
            spawn(fun() -> kill_player_notice(Attacker) end),
            %% 玩家死亡处理炸弹
            NewR = cross_war_util:get_by_pkey(Player#player.key),
            if
                NewR#cross_war_player.has_bomb > 0 ->
                    cross_war_util:update_war_player(NewR#cross_war_player{has_bomb = 0}),
                    mon_agent:create_mon([?CROSS_WAR_MON_ID_BOMB, ?SCENE_ID_CROSS_WAR, Player#player.x, Player#player.y, 0, 1, [{group, DefCrossWarGuild#cross_war_guild.sign}]]),
                    ok;
                true -> skip
            end,
            %% 处理系统皇冠信息
            if
                Player#player.crown == 1 ->
                    NewMap = cross_war_map:update_king_gold(State#sys_cross_war.map, X, Y, AttPkey),
                    State#sys_cross_war{map = NewMap, king_gold = {AttGkey, AttPkey}};
                true ->
                    State
            end
    end.

%% 击杀玩家公告
kill_player_notice(Attacker) ->
    AttCrossWarPlayer = cross_war_util:get_by_pkey(Attacker#attacker.key),
    #cross_war_player{nickname = AttNickName, acc_kill_num = AccKillNum} = AttCrossWarPlayer,
    #cross_war_guild{sign = Sign} = cross_war_util:get_by_g_key(Attacker#attacker.gkey),
    if
        Sign == ?CROSS_WAR_TYPE_DEF ->
            AttSignName = ?T("防御方");
        true ->
            AttSignName = ?T("攻击方")
    end,
    ?IF_ELSE(AttCrossWarPlayer#cross_war_player.acc_kill_num rem 10 == 0, cross_war_util:sys_cross_notice(kill_acc_win_2, [AttSignName, AttNickName, AccKillNum]), skip),
    ?IF_ELSE(AttCrossWarPlayer#cross_war_player.acc_kill_num rem 5 == 0, cross_war_util:sys_cross_notice(kill_acc_win, [AttSignName, AttNickName, AccKillNum]), skip).

%% 采集王珠
collect(Pkey) ->
    ?CAST(cross_war_proc:get_server_pid(), {collect, Pkey}).

collect_cast(State, Pkey) ->
    CrossWarPlayer = cross_war_util:get_by_pkey(Pkey),
    CrossWarGuild = cross_war_util:get_by_g_key(CrossWarPlayer#cross_war_player.g_key),
    [{kill_sarah, AddScore}] = data_cross_war_score_condition:get(4),
    cross_war_util:add_guild_score(CrossWarPlayer#cross_war_player.g_key, AddScore),
    cross_war_util:add_player_score(Pkey, AddScore),
    cross_war_util:set_player_crown(Pkey, 1),
    center:apply(CrossWarGuild#cross_war_guild.node, cross_war_battle, set_crown, [Pkey, 1]),
    CollectReward = data_cross_war_other_reward:get_king_gold_reward(),
    NewMap = State#sys_cross_war.map#cross_war_map{king_gold_pkey = Pkey},
    if
        State#sys_cross_war.collect_num > 0 -> skip;
        true -> spawn(fun() ->
            center:apply(CrossWarGuild#cross_war_guild.node, ?MODULE, send_to_client_reward, [Pkey, CollectReward, 681]) end)
    end,
    State#sys_cross_war{
        map = NewMap,
        king_gold = {CrossWarPlayer#cross_war_player.g_key, Pkey},
        collect_num = State#sys_cross_war.collect_num + 1
    }.

send_to_client_reward(Pkey, RewardList, From) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] -> skip;
        [#ets_online{pid = Pid}] -> player:apply_state(async, Pid, {cross_war_battle, recv_reward, [RewardList, From]})
    end.

recv_reward([RewardList, From], Player) ->
    GiveGoodsList = goods:make_give_goods_list(From, RewardList),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    {ok, NewPlayer}.

%% 城战攻击造成伤害
cacl_hurt(Aer, Der) ->
    #bs{
        buff_list = BuffList,
        sign = A_sign
    } = Aer,
    IsFlag = lists:keyfind(154, #skillbuff.buffid, BuffList),
    #bs{
        kind = D_Kind,
        sign = D_sign,
        hp_lim = HpLimt
    } = Der,
    if
        %% 玩家攻击城门、箭塔
        IsFlag == false andalso (D_Kind == ?MON_KIND_CROSS_WAR_KING_DOOR orelse D_Kind == ?MON_KIND_CROSS_WAR_DOOR orelse D_Kind == ?MON_KIND_CROSS_WAR_TOWER) ->
            BaseHurt = data_cross_war_mon_hurt:get(D_Kind),
            BaseHurt;
        true ->
            if
                %% 攻城车对箭塔，城门伤害
                IsFlag /= false andalso (D_Kind == ?MON_KIND_CROSS_WAR_KING_DOOR orelse D_Kind == ?MON_KIND_CROSS_WAR_DOOR orelse D_Kind == ?MON_KIND_CROSS_WAR_TOWER) ->
                    BaseHurt = data_cross_war_car_hurt:get(D_Kind),
                    BaseHurt;
                %% 攻城车攻击玩家
                IsFlag /= false andalso D_sign == ?SIGN_PLAYER andalso A_sign == ?SIGN_PLAYER ->
                    Mult = data_cross_war_car_hurt:get(999),
                    round(HpLimt*Mult/10000);
                true ->
                    1000
            end
    end.
%% 处理攻城车受到玩家攻击的伤害
cacl_hurt2(_Aer, Der) ->
    #bs{hp_lim = HpLimt} = Der,
    Mult = data_cross_war_car_def_hurt:get(999),
    round(HpLimt*Mult/10000).

%% 处理攻城车受到野怪的伤害
cacl_hurt3(_Aer, Der) ->
    #bs{hp_lim = HpLimt} = Der,
    Mult = data_cross_war_car_def_hurt:get(0),
    round(HpLimt*Mult/10000).