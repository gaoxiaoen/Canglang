%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十月 2017 10:38
%%% -------------------------------------------------------------------
-module(cross_scuffle_elite_war_team_util).
-author("Administrator").
-include("cross_scuffle_elite.hrl").
-include("common.hrl").
-include("server.hrl").
%% API
-export([
    validate_name/2
    , get_war_team_name/1
    , war_team_apply/4
    , war_team_apply_list/3
    , war_team_approval/4
    , war_team_kickout/4
    , war_team_quit/2
    , invite/2
    , re_invite/4
    , get_war_team_list/4
    , refused_all/1
%%     , guild_apply_notice/1

]).

-define(PAGE_NUM, 10).
-define(PAGE_NUM1, 9).

%% 角色名合法性检测:长度
validate_name(len, Name) ->
    Len = util:char_len(xmerl_ucs:to_unicode(Name, 'utf-8')),
    case Len < 6 andalso Len > 0 of
        true ->
            validate_name(keyword, Name);
        false ->
            %%角色名称长度为2~6个汉字
            {false, 13}
    end;

%%判断是有敏感词
validate_name(keyword, Name) ->
    case util:check_keyword(Name) of
        true ->
            {false, 14};
        false ->
            true
    end.

%%获取战队名称
get_war_team_name(WarTeamKey) ->
    case cross_scuffle_elite_war_team_ets:get_war_team(WarTeamKey) of
        false -> <<>>;
        WarTeam -> WarTeam#war_team.name
    end.

war_team_apply(Player, WtKey, Key, Node) ->
    Ret =
        if
            Player#player.war_team#st_war_team.war_team_key /= 0 -> 2;
            true ->
                case cross_scuffle_elite_war_team_ets:get_war_team(WtKey) of
                    false -> 5;
                    WarTeam ->
                        ApplyList = cross_scuffle_elite_war_team_ets:get_war_team_apply_by_gkey(WtKey),
                        Len = length(ApplyList),
                        if
                            WarTeam#war_team.sn /= Player#player.sn_cur -> 8;
                            Len >= ?WAR_TEAM_APPLY_MAX -> 6;
                            true ->
                                case lists:keymember(Player#player.key, #wt_apply.pkey, ApplyList) of
                                    true ->
                                        7;
                                    false ->
                                        KeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(WtKey),
                                        {ok, Bin58515} = pt_585:write(58515, {}),
                                        F = fun(Key1) ->
                                            center:apply(Node, server_send, send_to_key, [Key1, Bin58515])
                                        end,
                                        lists:foreach(F, KeyList),
                                        make_apply(Player, WtKey, Key),
                                        1
                                end
                        end
                end
        end,
    {ok, Bin} = pt_585:write(58514, {Ret, WtKey}),
    server_send:send_to_sid(Node, Player#player.sid, Bin).

make_apply(Player, WtKey, Key) ->
    Now = util:unixtime(),
    Member = cross_scuffle_elite_war_team_ets:get_war_team_member(Player#player.key),
    Rank = ?IF_ELSE(Member /= false, Member#wt_member.rank, 0),
    Apply = #wt_apply{
        akey = Key,
        pkey = Player#player.key,
        wtkey = WtKey,
        nickname = Player#player.nickname,
        career = Player#player.career,
        lv = Player#player.lv,
        vip = Player#player.vip_lv,
        cbp = Player#player.cbp,
        timestamp = Now,
        rank = Rank
%%         rank = Player#player.cross_scuffle_elite#cross_scuffle_elite_info.rank
    },

    cross_scuffle_elite_war_team_ets:set_war_team_apply(Apply),
    cross_scuffle_elite_load:insert_war_team_apply(Apply),
    {1, Player}.

%%获取战队申请列表
war_team_apply_list(Player, Page, Node) ->
    List =
        case cross_scuffle_elite_war_team_ets:get_war_team(Player#player.war_team#st_war_team.war_team_key) of
            false -> [];
            _WarTeam ->
                cross_scuffle_elite_war_team_ets:get_war_team_apply_by_gkey(Player#player.war_team#st_war_team.war_team_key)
        end,
    MaxPage = length(List) div ?PAGE_NUM + 1,
    NowPage = if Page =< 0 orelse Page > MaxPage -> 1;true -> Page end,
    NewList = lists:sublist(List, NowPage * ?PAGE_NUM - ?PAGE_NUM1, ?PAGE_NUM),
    F = fun(Apply) ->
        [Apply#wt_apply.pkey, Apply#wt_apply.nickname, Apply#wt_apply.vip, Apply#wt_apply.career, Apply#wt_apply.lv, Apply#wt_apply.cbp, Apply#wt_apply.rank]
    end,
    Data = {Page, MaxPage, lists:map(F, NewList)},
    {ok, Bin} = pt_585:write(58510, Data),
    server_send:send_to_sid(Node, Player#player.sid, Bin).


%%战队审批
war_team_approval(Player, OtherPlayer, Result, Node) ->
    ?DEBUG("Node ~p~n", [Node]),
    KeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(Player#player.war_team#st_war_team.war_team_key),
    Ret =
        case cross_scuffle_elite_war_team_ets:get_war_team_apply_one(OtherPlayer#player.key, Player#player.war_team#st_war_team.war_team_key) of
            false -> 10;
            Apply ->
                case Result of
                    0 ->
                        cross_scuffle_elite_war_team_ets:del_war_team_apply(Apply#wt_apply.akey),
                        cross_scuffle_elite_load:del_war_team_apply(Apply#wt_apply.akey),
                        1;
                    1 ->
                        case cross_scuffle_elite_war_team_ets:get_war_team(Player#player.war_team#st_war_team.war_team_key) of
                            false -> 5;
                            WarTeam ->
                                Len = length(KeyList),
                                if Len >= 4 -> 9;
                                    true ->
                                        case cross_scuffle_elite_war_team_ets:get_war_team_member(Apply#wt_apply.pkey) of
                                            false ->
                                                cross_scuffle_elite_war_team_ets:del_war_team_apply_by_pkey(Apply#wt_apply.pkey),
                                                cross_scuffle_elite_load:del_war_team_apply_by_pkey(Apply#wt_apply.pkey),
                                                Now = util:unixtime(),
                                                NewWarTeam = WarTeam#war_team{num = WarTeam#war_team.num + 1},
                                                cross_scuffle_elite_war_team_ets:set_war_team(NewWarTeam),
                                                _Member = cross_scuffle_elite_war_team:make_apply_new_war_team_member(OtherPlayer, WarTeam, ?WAR_TEAM_POSITION_NORMAL, Now),
                                                center:apply(Node, server_send, send_node_pkey, [OtherPlayer#player.key, {update_war_team, [WarTeam#war_team.wtkey, WarTeam#war_team.name, ?WAR_TEAM_POSITION_NORMAL]}]),
                                                1;
                                            _ ->
                                                cross_scuffle_elite_war_team_ets:del_war_team_apply_by_pkey(Apply#wt_apply.pkey),
                                                cross_scuffle_elite_load:del_war_team_apply_by_pkey(Apply#wt_apply.pkey),
                                                Now = util:unixtime(),
                                                NewWarTeam = WarTeam#war_team{num = WarTeam#war_team.num + 1},
                                                cross_scuffle_elite_war_team_ets:set_war_team(NewWarTeam),
                                                _Member = cross_scuffle_elite_war_team:make_apply_new_war_team_member(OtherPlayer, WarTeam, ?WAR_TEAM_POSITION_NORMAL, Now),
                                                center:apply(Node, server_send, send_node_pkey, [OtherPlayer#player.key, {update_war_team, [WarTeam#war_team.wtkey, WarTeam#war_team.name, ?WAR_TEAM_POSITION_NORMAL]}]),
                                                cross_scuffle_elite_war_team_ets:del_war_team_apply(Apply#wt_apply.akey),
                                                cross_scuffle_elite_load:del_war_team_apply(Apply#wt_apply.akey),
                                                1
                                        end
                                end
                        end;
                    _ -> 16
                end
        end,
    if
        OtherPlayer#player.sid /= [] ->
            {ok, Bin58534} = pt_585:write(58534, {Player#player.war_team#st_war_team.war_team_key, Player#player.war_team#st_war_team.war_team_name, Result}),
            server_send:send_to_sid(OtherPlayer#player.sid, Bin58534);
        true -> skip
    end,
    %% 审批同步
    {ok, Bin58533} = pt_585:write(58533, {}),
    F0 = fun(Key) ->
        center:apply(Node, server_send, send_to_key, [Key, Bin58533])
    end,
    lists:foreach(F0, KeyList),
%%     KeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list( Player#player.war_team#st_war_team.war_team_key),
%%     {ok, Bin58515} = pt_585:write(58515, {}),
%%     F = fun(Key1) ->
%%         center:apply(Node, server_send, send_to_key, [Key1, Bin58515])
%%     end,
%%     lists:foreach(F, KeyList),
    {ok, Bin} = pt_585:write(58511, {Ret, OtherPlayer#player.key}),
    server_send:send_to_sid(Node, Player#player.sid, Bin).

%%踢出战队
war_team_kickout(Player, Pkey, OnlineState, Node) ->
    Ret =
        case cross_scuffle_elite_war_team_ets:get_war_team_member(Pkey) of
            false -> 5;
            Member ->
                if
                    Player#player.war_team#st_war_team.war_team_key /= Member#wt_member.wtkey -> 19;
                    Player#player.war_team#st_war_team.war_team_position /= ?WAR_TEAM_POSITION_CHAIRMAN -> 122;
                    true ->
                        case cross_scuffle_elite_war_team_ets:get_war_team(Player#player.war_team#st_war_team.war_team_key) of
                            false -> 4;
                            WarTeam ->
                                {State, _} = ?CALL(cross_scuffle_elite_proc:get_server_pid(), get_scfflie_elite_state),
                                if
                                    State /= ?CROSS_SCUFFLE_ELITE_STATE_CLOSE andalso OnlineState -> 29;
                                    true ->
                                        Num = max(0, WarTeam#war_team.num - 1),
                                        NewWarTeam = WarTeam#war_team{num = Num},
                                        cross_scuffle_elite_war_team:player_join_war_team(Member#wt_member.wtkey, Member#wt_member.name, 0),
                                        cross_scuffle_elite_war_team_ets:set_war_team(NewWarTeam),
                                        cross_scuffle_elite_load:replace_war_team(NewWarTeam),
                                        cross_scuffle_elite_war_team_ets:del_war_team_member(Pkey),
                                        cross_scuffle_elite_load:del_war_team_member_by_pkey(Pkey),
                                        center:apply(Node, server_send, send_node_pkey, [Pkey, {update_war_team, [0, <<>>, ?WAR_TEAM_POSITION_NORMAL]}]),
                                        1
                                end
                        end
                end
        end,
    {ok, Bin1} = pt_585:write(58513, {Ret}),
    center:apply(Node, server_send, send_to_pid, [Player#player.pid, Bin1]),
    ok.

%%退出战队
war_team_quit(Player, Node) ->
    case check_war_team_quit(Player, Node) of
        {false, Res} ->
            {ok, Bin1} = pt_585:write(58512, {Res}),
            server_send:send_to_sid(Node, Player#player.sid, Bin1);
        {ok, WarTeam, Member} ->
            Num = max(0, WarTeam#war_team.num - 1),
            case Num == 0 of
                true ->
                    cross_scuffle_elite_war_team:player_join_war_team(WarTeam#war_team.wtkey, Player#player.nickname, 0),
                    cross_scuffle_elite_war_team_ets:del_war_team(WarTeam#war_team.wtkey),
                    cross_scuffle_elite_load:del_war_team(WarTeam#war_team.wtkey),
                    cross_scuffle_elite_war_team_ets:del_war_team_member_list(WarTeam#war_team.wtkey),
                    cross_scuffle_elite_load:del_war_team_member(WarTeam#war_team.wtkey),
                    server_send:send_node_pid(Node, Player#player.pid, {update_war_team, [0, <<>>, ?WAR_TEAM_POSITION_NORMAL]}),
                    {ok, Bin1} = pt_585:write(58512, {1}),
                    server_send:send_to_sid(Node, Player#player.sid, Bin1);
%%                  guild_create:dismiss(Guild#guild.gkey, Guild#guild.name, Player#player.key, Player#player.nickname, 2);
                false ->
                    if  %% 转让队长
                        Member#wt_member.position == ?WAR_TEAM_POSITION_CHAIRMAN ->
                            MemberList = cross_scuffle_elite_war_team_ets:get_war_team_member_list(Player#player.war_team#st_war_team.war_team_key),
                            NewMemberList = lists:keydelete(Player#player.key, #wt_member.pkey, MemberList),
                            if
                                NewMemberList == [] ->
                                    NewWarTeam = WarTeam#war_team{num = Num};
                                true ->
                                    Member1 = hd(NewMemberList),
                                    cross_scuffle_elite_war_team_ets:set_war_team_member(Member1#wt_member{position = ?WAR_TEAM_POSITION_CHAIRMAN}),
                                    center:apply(Node, server_send, send_node_pkey, [Member1#wt_member.pkey, {update_war_team, [WarTeam#war_team.wtkey, WarTeam#war_team.name, ?WAR_TEAM_POSITION_CHAIRMAN]}]),
                                    NewWarTeam = WarTeam#war_team{num = Num,
                                        pkey = Member1#wt_member.pkey
                                        , pname = Member1#wt_member.name
                                        , pcareer = Member1#wt_member.career
                                        , pvip = Member1#wt_member.vip}
                            end;
                        true ->
                            NewWarTeam = WarTeam#war_team{num = Num}
                    end,
                    cross_scuffle_elite_war_team_ets:set_war_team(NewWarTeam),
                    cross_scuffle_elite_war_team_ets:del_war_team_member(Player#player.key),
                    cross_scuffle_elite_load:del_war_team_member_by_pkey(Player#player.key),
%%                  guild_create:player_quit_guild(Member),
                    cross_scuffle_elite_war_team:player_join_war_team(WarTeam#war_team.wtkey, Player#player.nickname, 0),
                    server_send:send_node_pid(Node, Player#player.pid, {update_war_team, [0, <<>>, ?WAR_TEAM_POSITION_NORMAL]}),
                    {ok, Bin1} = pt_585:write(58512, {1}),
                    server_send:send_to_sid(Node, Player#player.sid, Bin1)
            end,
            cross_scuffle_elite:quit_team(Player#player.key, Player#player.war_team#st_war_team.war_team_key)
    end,
    ok.

check_war_team_quit(Player, Node) ->
    if
        Player#player.war_team#st_war_team.war_team_key == 0 -> {false, 21};
        true ->
            case cross_scuffle_elite_war_team_ets:get_war_team(Player#player.war_team#st_war_team.war_team_key) of
                false -> {false, 5};
                WarTeam ->
                    case cross_scuffle_elite_war_team_ets:get_war_team_member(Player#player.key) of
                        false -> {false, 5};
                        Member ->
                            {State, _} = ?CALL(cross_scuffle_elite_proc:get_server_pid(), get_scfflie_elite_state),
                            if
                                State == ?CROSS_SCUFFLE_ELITE_STATE_CLOSE -> {ok, WarTeam, Member};
                                true ->
                                    case center:apply_call(Node, player_util, get_player_pid, [WarTeam#war_team.pkey]) of
                                        false -> {ok, WarTeam, Member};
                                        _ ->
                                            {false, 29}
                                    end
                            end
                    end
            end
    end.

invite(Player, PKey) ->
    case player_util:get_player(PKey) of
        [] -> 17;
        OtherPlayer ->
            if
                OtherPlayer#player.lv < 65 -> 33;
                OtherPlayer#player.war_team#st_war_team.war_team_key /= 0 -> 18;
                true ->
                    {ok, Bin} = pt_585:write(58507, {Player#player.nickname, Player#player.war_team#st_war_team.war_team_name, Player#player.war_team#st_war_team.war_team_key}),
                    server_send:send_to_pid(OtherPlayer#player.pid, Bin),
                    1
            end
    end.

re_invite(Player, WtKey, Result, Node) ->
    case Result of
        0 ->
            case cross_scuffle_elite_war_team_ets:get_war_team(WtKey) of
                false -> skip;
                WarTeam ->
                    {ok, Bin} = pt_585:write(58516, {Result, Player#player.key}),
                    center:apply(Node, server_send, send_to_key, [WarTeam#war_team.pkey, Bin]),
                    {ok, Bin1} = pt_585:write(58508, {1}),
                    center:apply(Node, server_send, send_to_pid, [Player#player.pid, Bin1])
            end;
        1 ->
            Ret =
                case cross_scuffle_elite_war_team_ets:get_war_team(WtKey) of
                    false -> 5;
                    WarTeam ->
                        KeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(WtKey),
                        Len = length(KeyList),
                        if
                            WarTeam#war_team.sn /= Player#player.sn_cur -> 8;
                            Len >= 4 -> 9;
                            Player#player.war_team#war_team.wtkey /= 0 -> 2;
                            true ->
                                cross_scuffle_elite_war_team_ets:del_war_team_apply_by_pkey(Player#player.key),
                                cross_scuffle_elite_load:del_war_team_apply_by_pkey(Player#player.key),
                                Now = util:unixtime(),
                                NewWarTeam = WarTeam#war_team{num = WarTeam#war_team.num + 1},
                                cross_scuffle_elite_war_team_ets:set_war_team(NewWarTeam),
                                _Member = cross_scuffle_elite_war_team:make_apply_new_war_team_member(Player, WarTeam, ?WAR_TEAM_POSITION_NORMAL, Now),
                                server_send:send_node_pid(Node, Player#player.pid, {update_war_team, [WarTeam#war_team.wtkey, WarTeam#war_team.name, ?WAR_TEAM_POSITION_NORMAL]}),
                                1
                        end
                end,
            if Ret == 1 -> skip;
%%                 {ok, Bin} = pt_585:write(58516, {Player#player.nickname, Result}),
%%                 center:apply(Node, server_send, send_to_key, [WtKey#war_team.pkey, Bin]);
                true -> skip
            end,
            {ok, Bin1} = pt_585:write(58508, {Ret}),
            center:apply(Node, server_send, send_to_pid, [Player#player.pid, Bin1])
    end,
    ok.

get_war_team_list(Player, Page, Type, Node) ->
    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {get_war_team_list, Player, Page, Type, Node}),
    ok.


refused_all(Player) ->
    cross_scuffle_elite_war_team_ets:del_war_team_apply_by_wtkey(Player#player.war_team#st_war_team.war_team_key),
    ok.
