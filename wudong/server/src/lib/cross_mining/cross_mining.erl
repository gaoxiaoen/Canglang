%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 四月 2018 上午10:23
%%%-------------------------------------------------------------------
-module(cross_mining).
-author("luobaqun").
-include("server.hrl").
-include("common.hrl").
-include("cross_mining.hrl").
-include("guild.hrl").
-include("daily.hrl").

%% API
-export([
    get_mine_info/6,
    get_my_mine_info/4,
    att_mine/15,
    att_thief/11,
    get_mine_reward/7,
    exit_mine/5,
    get_att_info/7,
    get_other_mine/3,
    get_mine_log/4,
    get_all_log/3,
    get_rank_info/3,
    update_guild_name/2,
    get_one_mine_info/5,
    help_friend/5,
    get_rank_info/1,
    att_mine_help/5,
    cross_help_friend/9
]).

%% 获取矿洞信息
get_mine_info(Node, Sid, Type, Page, Pid, Pkey) ->
    ?CAST(cross_mining_proc:get_server_pid(), {get_mine_info, Node, Sid, Type, Page, Pid, Pkey}).

%% 获取单个矿点信息
get_one_mine_info(Node, Sid, Type, Page, Id) ->
    case cross_mining_util:get_ets_by_key({Type, Page, Id}) of
        [] ->
            Data = cross_mining_util:make_mine_info_60409(#mineral_info{type = Type, page = Page, id = Id}),
            {ok, Bin} = pt_604:write(60409, Data),
            server_send:send_to_sid(Node, Sid, Bin);
        MineralInfo ->
            Data = cross_mining_util:make_mine_info_60409(MineralInfo),
            {ok, Bin} = pt_604:write(60409, Data),
            server_send:send_to_sid(Node, Sid, Bin)
    end.

%% 获取我的矿点
get_my_mine_info(Node, Sid, Pkey, AttTime) ->
    List = cross_mining_util:get_ets_by_pkey(Pkey),
    Now = util:unixtime(),
    F = fun(MineralInfo) ->
        Base = data_mineral_info:get(MineralInfo#mineral_info.mtype),
        [
            MineralInfo#mineral_info.mtype,
            MineralInfo#mineral_info.type,
            MineralInfo#mineral_info.page,
            MineralInfo#mineral_info.id,
            max(0, MineralInfo#mineral_info.ripe_time - Now),
            ?IF_ELSE(MineralInfo#mineral_info.meet_end_time == 0, 0, 1),
            cross_mining_util:get_hold_time_reward(Now - MineralInfo#mineral_info.last_hold_time, Base#base_mineral_info.reward)
        ]
        end,
    Data = lists:map(F, List),
    {ok, Bin} = pt_604:write(60402, {AttTime, Data}),
    server_send:send_to_sid(Node, Sid, Bin),
    ok.

get_other_mine(Node, Sid, Pkey) ->
    ?DEBUG("60413 ~n"),
    List = cross_mining_util:get_ets_by_pkey(Pkey),
    F = fun(MineralInfo) ->
        [
            MineralInfo#mineral_info.mtype,
            MineralInfo#mineral_info.type,
            MineralInfo#mineral_info.page,
            MineralInfo#mineral_info.id
        ]
        end,
    Data = lists:map(F, List),
    ?DEBUG("data ~p~n", [Data]),
    {ok, Bin} = pt_604:write(60413, {Data}),
    server_send:send_to_sid(Node, Sid, Bin),
    ok.

att_mine_help(Player,Type, Page, Id, Ids)->
    {Index, FreeEndTime} = daily:get_count(?DAILY_CROSS_MINE_ATT, {0, 0}),
    Now = util:unixtime(),
    Next = data_mining_cd:get(Index + 1),
    if
        FreeEndTime >= Now -> %% 冷却中
            {12, 0};
        Next == [] ->
            {13, 0};
        Ids == [] ->
            cross_all:apply(cross_mining, att_mine, [node(), Player#player.sid, Player#player.pid, Type, Page, Id, Player#player.key, Player#player.sn_cur, Player#player.cbp, Player#player.nickname, Player#player.guild#st_guild.guild_name, Player#player.sex, Player#player.avatar, Player#player.vip_lv, Player#player.d_vip#dvip.vip_type]),
            ok;
        true ->
            LenId = length(Ids),
            case data_mineral_vip_help:get(Player#player.vip_lv) of
                 [] ->{0,0};
                HelpBase ->
                    if
                        HelpBase#base_cross_mine_vip_help.att_num < LenId -> {23,0};
                        true ->
                            St = lib_dict:get(?PROC_STATUS_CROSS_MINE_HELP),
                            F = fun(Id0, {Flag0, List0, AllCbp0}) ->
                                case lists:keytake(Id0, #help_info.id, List0) of
                                    false -> {false, [], 0};
                                    {value, HelpInfo0, T} ->
                                        {Flag0, T, HelpInfo0#help_info.cbp + AllCbp0}
                                end
                            end,
                            {Flag, NewMyHelpList, AllCbp} = lists:foldl(F, {true, St#st_cross_mine_help.my_help_list, 0}, Ids),
                            if
                                Flag ->
                                    NewSt = St#st_cross_mine_help{my_help_list = NewMyHelpList},
                                    lib_dict:put(?PROC_STATUS_CROSS_MINE_HELP, NewSt),
                                    cross_mining_load:dbup_player_cross_mining_help(NewSt),
                                    cross_all:apply(cross_mining, att_mine, [node(), Player#player.sid, Player#player.pid, Type, Page, Id, Player#player.key, Player#player.sn_cur, Player#player.cbp + AllCbp, Player#player.nickname, Player#player.guild#st_guild.guild_name, Player#player.sex, Player#player.avatar, Player#player.vip_lv, Player#player.d_vip#dvip.vip_type]),
                                    ok;
                                true ->
                                    {0, 0}
                            end
                    end
            end
    end.
%% 进攻矿点
att_mine(Node, Sid, Pid, Type, Page, Id, Pkey, Sn, Cbp, Pname, GuildName, Sex, Avatar, Vip, Dvip) ->
    ?CAST(cross_mining_proc:get_server_pid(), {att_mine, Node, Sid, Pid, Type, Page, Id, Pkey, Sn, Cbp, Pname, GuildName, Sex, Avatar, Vip, Dvip}).

%% 进攻小偷
att_thief(Node, Sid, Type, Page, Id, Pkey, Pname, Cbp, Sn, Vip, Dvip) ->
    ?CAST(cross_mining_proc:get_server_pid(), {att_thief, Node, Sid, Type, Page, Id, Pkey, Pname, Cbp, Sn, Vip, Dvip}),
    ok.

%% 领取奖励
get_mine_reward(Node, Sid, Type, Page, Id, Pkey, Pid) ->
    ?CAST(cross_mining_proc:get_server_pid(), {get_mine_reward, Node, Sid, Type, Page, Id, Pkey, Pid}),
    ok.

%% 退出分矿
exit_mine(Node, Sid, Type, Page, Pkey) ->
    ?CAST(cross_mining_proc:get_server_pid(), {exit_mine, Node, Sid, Type, Page, Pkey}),
    ok.

%% 获取攻击信息
get_att_info(Node, Sid, Type, Page, Id, _Pkey, Cbp) ->
    case cross_mining_util:get_ets_by_key({Type, Page, Id}) of
        [] ->
            {ok, Bin} = pt_604:write(60408, {0, 0, 0, 0, [], 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, [], []}),
            server_send:send_to_sid(Node, Sid, Bin);
        MineralInfo ->
            Data = cross_mining_util:make_att_info(MineralInfo, Cbp),
            {ok, Bin} = pt_604:write(60408, Data),
            server_send:send_to_sid(Node, Sid, Bin)
    end.

get_mine_log(Node, Sid, Pkey, Count) ->
    Base1 = data_mining_event:get(?EVENT_TYPE_1),
    Base2 = data_mining_event:get(?EVENT_TYPE_2),

    MeetCount =
        case cross_mining_util:get_meet_ets_by_pkey(Pkey) of
            [] -> 0;
            Base3 ->
                Base3#ets_cross_mineral_daily_meet.count
        end,

    case cross_mining_util:get_log_ets_by_key(Pkey) of
        [] ->
            {ok, Bin} = pt_604:write(60410, {MeetCount, Base1#base_mining_event.daily_limit, Count, Base2#base_mining_event.daily_limit, [], [], []}),
            server_send:send_to_sid(Node, Sid, Bin);
        Log ->
            F = fun(CrossEventLog) ->
                [
                    CrossEventLog#cross_event_log.type,
                    CrossEventLog#cross_event_log.pkey,
                    CrossEventLog#cross_event_log.name,
                    CrossEventLog#cross_event_log.location_type,
                    CrossEventLog#cross_event_log.location_page,
                    CrossEventLog#cross_event_log.location_id,
                    CrossEventLog#cross_event_log.location_mtype,
                    CrossEventLog#cross_event_log.time,
                    goods:pack_goods(CrossEventLog#cross_event_log.reward)
                ]
                end,
            EventLog = lists:map(F, Log#ets_cross_mineral_log.event_log),

            F1 = fun(CrossEventLog) ->
                [
                    CrossEventLog#cross_att_log.pkey,
                    CrossEventLog#cross_att_log.pname,
                    CrossEventLog#cross_att_log.location_type,
                    CrossEventLog#cross_att_log.location_page,
                    CrossEventLog#cross_att_log.location_id,
                    CrossEventLog#cross_att_log.state,
                    CrossEventLog#cross_att_log.time,
                    goods:pack_goods(CrossEventLog#cross_att_log.reward)
                ]
                 end,
            AttLog = lists:map(F1, Log#ets_cross_mineral_log.att_log),

            F2 = fun(CrossEventLog) ->
                [
                    CrossEventLog#cross_att_log.pkey,
                    CrossEventLog#cross_att_log.pname,
                    CrossEventLog#cross_att_log.location_type,
                    CrossEventLog#cross_att_log.location_page,
                    CrossEventLog#cross_att_log.location_id,
                    CrossEventLog#cross_att_log.state,
                    CrossEventLog#cross_att_log.time,
                    goods:pack_goods(CrossEventLog#cross_att_log.reward)
                ]
                 end,
            DefLog = lists:map(F2, Log#ets_cross_mineral_log.def_log),
            {ok, Bin} = pt_604:write(60410, {MeetCount, Base1#base_mining_event.daily_limit, Count, Base2#base_mining_event.daily_limit, EventLog, AttLog, DefLog}),
            server_send:send_to_sid(Node, Sid, Bin)
    end.


get_all_log(Node, Sid, Pkey) ->
    EventLog =
        case ets:lookup(?ETS_CROSS_MINERAL_ALL_LOG, ets_cross_mineral_all_log) of
            [] -> [];
            [Ets | _] ->
                F = fun(Log) ->
                    [
                        Log#cross_event_log.type,
                        Log#cross_event_log.pkey,
                        Log#cross_event_log.name,
                        Log#cross_event_log.location_type,
                        Log#cross_event_log.location_page,
                        Log#cross_event_log.location_id,
                        Log#cross_event_log.location_mtype,
                        Log#cross_event_log.time,
                        goods:pack_goods(Log#cross_event_log.reward)
                    ]
                    end,
                lists:map(F, Ets#ets_cross_mineral_all_log.event_log)
        end,
    DefLog =
        case cross_mining_util:get_log_ets_by_key(Pkey) of
            [] ->
                [];
            Log ->
                F2 = fun(CrossEventLog) ->
                    [
                        CrossEventLog#cross_att_log.pkey,
                        CrossEventLog#cross_att_log.pname,
                        CrossEventLog#cross_att_log.location_type,
                        CrossEventLog#cross_att_log.location_page,
                        CrossEventLog#cross_att_log.location_id,
                        CrossEventLog#cross_att_log.state,
                        CrossEventLog#cross_att_log.time,
                        goods:pack_goods(CrossEventLog#cross_att_log.reward)
                    ]
                     end,
                lists:map(F2, Log#ets_cross_mineral_log.def_log)
        end,
    ?DEBUG("~p~n", [{EventLog, DefLog}]),
    {ok, Bin} = pt_604:write(60414, {EventLog, DefLog}),
    server_send:send_to_sid(Node, Sid, Bin),
    ok.

%% 修改公会名称
update_guild_name(Pkey, GuildName) ->
    List = cross_mining_util:get_ets_by_pkey(Pkey),
    F = fun(Info) ->
        cross_mining_util:insert_ets(Info#mineral_info{hold_guild_name = GuildName})
        end,
    lists:foreach(F, List),
    ok.


get_rank_info(Node, Sid, Pkey) ->
    ?CAST(cross_mining_proc:get_server_pid(), {get_rank_info, Node, Sid, Pkey}).



help_friend(Player, Type, Page, Id, Pkey) ->
    case relation:is_my_friend(Pkey) of
        false -> 19; %% 非好友
        true ->
            case guild_ets:get_guild_member(Pkey) of
                false -> 20; %% 非仙盟
                #g_member{gkey = Gkey} ->
                    if
                        Gkey =/= Player#player.guild#st_guild.guild_key -> 20; %% 非仙盟
                        true ->
                            {_Att, HelpCount, _ResetCount} = daily:get_count(?DAILY_CROSS_MINE_HELP, {0, 0, 0}),
                            case data_mineral_vip_help:get(Player#player.vip_lv) of
                                [] -> 0;
                                #base_cross_mine_vip_help{help_count = DailyVipLimit} ->
                                    if
                                        HelpCount >= DailyVipLimit -> 21; %% 次数不足
                                        true ->
                                            HelpInfo = cross_mining_util:make_help_info(Player),
                                            cross_all:apply(cross_mining, cross_help_friend, [node(), Player#player.sid, Player#player.pid, Player#player.key, Type, Page, Id, Pkey, HelpInfo]),
                                            1
                                    end
                            end
                    end
            end
    end.

cross_help_friend(Node, Sid, Pid, Key, Type, Page, Id, Pkey, HelpInfo) ->
    ?CAST(cross_mining_proc:get_server_pid(), {cross_help_friend, Node, Sid, Pid, Key, Type, Page, Id, Pkey, HelpInfo}).

get_rank_info(_Player) ->
    F = fun(Id)->
        {Top,Down,Reward} = data_cross_mining_rank:get_id(Id),
        [Top,Down,goods:pack_goods(Reward)]
        end,

    lists:map(F, data_cross_mining_rank:get_all()).
