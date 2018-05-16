%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2018 15:34
%%%-------------------------------------------------------------------
-module(guild_fight_handle).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("guild_fight.hrl").
-include("guild.hrl").
-include("scene.hrl").
-include("goods.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2, init_shadow/0]).

handle_call(_Msg, _from, State) ->
    ?ERR("handle call nomatch ~p~n", [_Msg]),
    {reply, ok, State}.

handle_cast({challenge_guild, MyGkey, Sid, GuildKey}, State) ->
    guild_fight:challenge_guild_cast(MyGkey, Sid, GuildKey),
    {noreply, State};

handle_cast({get_guild_fight_info, HasMedalNum, RecvList, Sid, Gkey, CdTime, ChallengeNum}, State) ->
    guild_fight:get_guild_fight_info_cast(HasMedalNum, RecvList, Sid, Gkey, CdTime, ChallengeNum, State),
    {noreply, State};

handle_cast(midnight_refresh, State) ->
    NewState = midnight_refresh(State),
    {noreply, NewState};

handle_cast({update_mon,Gkey,FlagLv}, State) ->
    NewState = update_mon(Gkey, FlagLv, State),
    {noreply, NewState};

handle_cast(_Msg, State) ->
    ?ERR("handle cast nomatch ~p~n", [_Msg]),
    {noreply, State}.

handle_info(init_data, _State) ->
    NewState = guild_fight_init:init_data(#st_guild_fight{}),
    MonPidList = guild_fight:create_flag_mon(),
    spawn(fun() -> init_shadow() end),
    {noreply, NewState#sys_guild_fight{flag_mon_list = MonPidList}};

handle_info({guild_fight_challenge_ret, AttPkey, AttName, DefPkey, DefName, Ret}, State) ->
    guild_fight:guild_fight_challenge_ret(AttPkey, AttName, DefPkey, DefName, Ret, State),
    NewState = log(State, AttPkey, DefPkey, Ret),
    {noreply, NewState};

handle_info(_Msg, State) ->
    ?ERR("handle info nomatch ~p~n", [_Msg]),
    {noreply, State}.

midnight_refresh(State) ->
    AllGuild = guild_ets:get_all_guild(),
    Sn = config:get_server_num(),
    Now = util:unixtime(),
    ets:delete_all_objects(?ETS_GUILD_FIGHT_SHADOW),
    F = fun(#guild{gkey = Gkey, name = Name, lv = Lv, cbp = Cbp, num = Num}) ->
        case guild_ets:get_guild_member_list(Gkey) of
            [] -> ok;
            AllMember ->
                F99 = fun(#g_member{pkey = Pkey}) -> Pkey end,
                AllKey = lists:map(F99, AllMember),
                NewGuildFightShadow =
                    #guild_fight_shadow{
                        gkey = Gkey
                        , g_sn = Sn
                        , g_name = Name
                        , g_lv = Lv
                        , g_cbp = Cbp
                        , g_num = Num
                        , member_list = AllKey},
                ets:insert(?ETS_GUILD_FIGHT_SHADOW, NewGuildFightShadow)
        end
    end,
    lists:map(F, AllGuild),
    AllEtsMember = ets:tab2list(?ETS_GUILD_MEMBER),
    F99 = fun(#g_member{pkey = Pkey, gkey = Gkey}) ->
        {Pkey, Gkey}
    end,
    ShadowPlayerPkeyList = lists:map(F99, AllEtsMember),
    AllList = ets:tab2list(?ETS_GUILD_FIGHT),
    IsDebug = config:is_debug(),
    F00 = fun(GuildFight) ->
        case guild_ets:get_guild(GuildFight#guild_fight.gkey) of
            false ->
                skip;
            _ ->
                NewGuildFight =
                    GuildFight#guild_fight{
                        guild_sum_lv = 0 %% 攻破仙盟等级总数
                        , guild_num = 0 %% 攻破仙盟数量
                        , fight_list = [] %% [{Index, Gkey, FightMemberList}]
                        , op_time = Now
                    },
                ets:insert(?ETS_GUILD_FIGHT, NewGuildFight),
                case IsDebug of
                    true -> guild_fight_load:update(NewGuildFight);
                    false -> skip
                end
        end
    end,
    lists:map(F00, AllList),
    #sys_guild_fight{shadow_player_key_list = ShadowPlayerPkeyList, flag_mon_list = State#sys_guild_fight.flag_mon_list}.

log(State, AttPkey, DefPkey, Ret) ->
    #sys_guild_fight{log_count = LogCount} = State,
    NewLog =
        #ets_guild_fight_log{
            count = LogCount + 1,
            att_pkey = AttPkey,
            def_pkey = DefPkey,
            result = Ret,
            challenge_time = util:unixtime()
        },
    ets:insert(?ETS_GUILD_FIGHT_LOG, NewLog),
    AttReward = ?IF_ELSE(Ret == 1, [{?GOODS_ID_MEDAL, guild_fight:get_medal(DefPkey)}], []),
    case guild_ets:get_guild_member(AttPkey) of
        false ->
            AttGname = ?T("name"),
            AttGkey = 0;
        #g_member{gkey = Gkey} ->
            AttGkey = Gkey,
            AttGname =
                case guild_ets:get_guild(AttGkey) of
                    false -> ?T("name");
                    #guild{name = AttGname0} -> AttGname0
                end
    end,
    DefReward = ?IF_ELSE(Ret == 0, [{?GOODS_ID_MEDAL, guild_fight:get_medal(AttPkey)}], []),
    case guild_ets:get_guild_member(DefPkey) of
        false ->
            DefGname = ?T("name"),
            DefGkey = 0;
        #g_member{gkey = Gkey1} ->
            DefGkey = Gkey1,
            DefGname =
                case guild_ets:get_guild(DefGkey) of
                    false -> ?T("name");
                    #guild{name = DefGname0} -> DefGname0
                end
    end,
    Sql = io_lib:format("replace into log_guild_fight set att_pkey=~p, att_gkey=~p, att_gname='~s', def_pkey=~p, def_gname='~s', def_gkey=~p, ret=~p, att_reward='~s', def_reward='~s', time=~p",
        [AttPkey, AttGkey, AttGname, DefPkey, DefGname, DefGkey, Ret, util:term_to_bitstring(AttReward), util:term_to_bitstring(DefReward), util:unixtime()]),
    log_proc:log(Sql),
    State#sys_guild_fight{log_count = LogCount+1}.

update_mon(Gkey, FlagLv, State) ->
    #sys_guild_fight{flag_mon_list = MonList} = State,
    NewList =
        case lists:keytake(Gkey, 1, MonList) of
            false ->
                {X, Y} = data_guild_fight_args:get_mon_xy(),
                #base_guild_flag{mon_id = MonId} = data_guild_flag:get(FlagLv),
                {Key, Pid} = mon_agent:create_mon([MonId, ?SCENE_ID_GUILD, X, Y, Gkey, 1, [{return_id_pid, true}]]),
                [{Gkey, Key, Pid} | MonList];
            {value, {Gkey, _OldKey, OldPid}, Rest} ->
                case misc:is_process_alive(OldPid) of
                    true -> %% 关闭当前还存活的怪物进程
                        monster:stop_broadcast(OldPid);
                    false ->
                        skip
                end,
                {X, Y} = data_guild_fight_args:get_mon_xy(),
                #base_guild_flag{mon_id = MonId} = data_guild_flag:get(FlagLv),
                {Key, Pid} = mon_agent:create_mon([MonId, ?SCENE_ID_GUILD, X, Y, Gkey, 1, [{return_id_pid, true}]]),
                [{Gkey, Key, Pid} | Rest]
        end,
    State#sys_guild_fight{flag_mon_list = NewList}.

init_shadow() ->
    AllGuild = guild_ets:get_all_guild(),
    F = fun(#guild{pkey = Pkey, last_hy_key = LastHyKey, gkey = Gkey}) ->
        Shadow1_1 = shadow_proc:get_shadow(Pkey),
        Shadow2_1 = shadow_proc:get_shadow(LastHyKey),
        MountId1 =
            case data_mount:get(Shadow1_1#player.mount_id) of
                [] ->
                    Sql1 = io_lib:format("select current_image_id from mount where pkey = ~p", [Pkey]),
                    case db:get_row(Sql1) of
                        [] -> 100001;
                        [CurMountId1] -> CurMountId1
                    end;
                _ ->
                    Shadow1_1#player.mount_id
            end,
        Shadow1 = shadow_init:init_shadow(Shadow1_1#player{nickname = Shadow1_1#player.nickname, mount_id = MountId1, pet = #fpet{}, cat_id = 0}),
        case mon_agent:get_scene_mon_by_mid(?SCENE_ID_GUILD, Gkey, 10001) of
            [] ->
                shadow:create_shadow_for_worship(Shadow1, 10001, ?SCENE_ID_GUILD, Gkey, 23, 56, [{mount_id, MountId1}]),
                MountId2 =
                    case data_mount:get(Shadow2_1#player.mount_id) of
                        [] ->
                            Sql2 = io_lib:format("select current_image_id from mount where pkey = ~p", [LastHyKey]),
                            case db:get_row(Sql2) of
                                [] -> 100001;
                                [CurMountId2] -> CurMountId2
                            end;
                        _ ->
                            Shadow2_1#player.mount_id
                    end,
                Shadow2 = shadow_init:init_shadow(Shadow2_1#player{nickname = Shadow2_1#player.nickname, mount_id = MountId2, pet = #fpet{}, cat_id = 0}),
                shadow:create_shadow_for_worship(Shadow2, 10001, ?SCENE_ID_GUILD, Gkey, 39, 72, [{mount_id, MountId2}]);
            _ ->
                skip
        end
    end,
    lists:map(F, AllGuild),
    ok.