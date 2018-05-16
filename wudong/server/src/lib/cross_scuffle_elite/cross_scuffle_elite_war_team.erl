%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十月 2017 10:05
%%%-------------------------------------------------------------------
-module(cross_scuffle_elite_war_team).
-include("cross_scuffle_elite.hrl").
-include("common.hrl").
-include("server.hrl").

-export([
    create_war_team/3
    , make_apply_new_war_team_member/4
    , make_war_team_member/1
    , player_join_war_team/3
]).


%%创建战队
create_war_team(Player, Name0, WarTeamKey) ->
    case check_create_war_team(Player, Name0) of
        {false, Res} ->
            ?DEBUG("Res  ~p~n", [Res]),
            {false, Res};
        {ok, Name} ->
            Now = util:unixtime(),
            WarTeam = make_new_war_team(Player, Name, Now, WarTeamKey),
            _Member = make_new_war_team_member(Player, WarTeam, ?WAR_TEAM_POSITION_CHAIRMAN, Now),
            cross_scuffle_elite_war_team_ets:del_war_team_apply_by_pkey(Player#player.key),
            cross_scuffle_elite_load:del_war_team_apply_by_pkey(Player#player.key),
            {1, WarTeam}
    end.

check_create_war_team(Player, Name0) ->
    Name = util:filter_utf8(Name0),
    if
        Player#player.war_team#st_war_team.war_team_key =/= 0 -> {false, 2};
        true ->
            case cross_scuffle_elite_war_team_ets:get_war_team_by_name(Name) of
                [_] -> {false, 3};
                [] ->
                    case cross_scuffle_elite_war_team_util:validate_name(len, Name) of
                        {false, Err} ->
                            {false, Err};
                        true ->
                            {ok, Name}
                    end
            end
    end.

%%新的战队
make_new_war_team(Player, Name, Now, WarTeamKey) ->
    WarTeam = #war_team{
        wtkey = WarTeamKey
        , name = Name
        , pkey = Player#player.key
        , pname = Player#player.nickname
        , pcareer = Player#player.career
        , pvip = Player#player.vip_lv
        , create_time = Now
        , sn = Player#player.sn_cur
        , is_change = 0
    },
    cross_scuffle_elite_war_team_ets:set_war_team(WarTeam),
    cross_scuffle_elite_load:replace_war_team(WarTeam),
    WarTeam.

%%新的战队成员
make_new_war_team_member(Player, WarTeam, Position, _Now) ->
    ?DEBUG("Player#player.cross_scuffle_elite ~p~n", [Player#player.cross_scuffle_elite]),
    Member = make_war_team_member([
        Player#player.key,
        Player#player.pid,
        WarTeam#war_team.wtkey,
        Position,
        Player#player.nickname,
        Player#player.career,
        Player#player.sex,
        Player#player.lv,
        1,
        Player#player.cbp,
        Player#player.last_login_time,
        Player#player.avatar,
        Player#player.vip_lv,
        Player#player.cross_scuffle_elite#cross_scuffle_elite_info.att,
        Player#player.cross_scuffle_elite#cross_scuffle_elite_info.rank,
        Player#player.cross_scuffle_elite#cross_scuffle_elite_info.der,
        Player#player.cross_scuffle_elite#cross_scuffle_elite_info.count
    ]),
    cross_scuffle_elite_war_team_ets:set_war_team_member(Member),
    Member.

make_war_team_member([Pkey, Pid, Wtkey, Position, Name, Career, Sex, Lv, IsOnline, Cbp, LastloginTime, Avatar, VipLv, Att, Rank, Der, Count]) ->
    Now = util:unixtime(),
    #wt_member{
        pkey = Pkey,
        pid = Pid,
        wtkey = Wtkey,
        position = Position,
        name = Name,
        career = Career,
        sex = Sex,
        lv = Lv,
        is_online = IsOnline,
        cbp = Cbp,
        last_login_time = LastloginTime,
        avatar = Avatar,
        vip = VipLv,
        join_time = Now,
        att = Att,
        rank = Rank,
        der = Der,
        count = Count
    }.

%% 玩家加入战队
%% player_join_war_team(Member) ->
%%     WarTeam = cross_scuffle_elite_war_team_ets:get_war_team(Member#wt_member.wtkey),
%%     ok.

make_apply_new_war_team_member(Player, WarTeam, Position, _Now) ->
%%     Player = shadow_proc:get_shadow(Pkey),
    Member =
        make_war_team_member([
            Player#player.key,
            none,
            WarTeam#war_team.wtkey,
            Position,
            Player#player.nickname,
            Player#player.career,
            Player#player.sex,
            Player#player.lv,
            0,
            Player#player.cbp,
            Player#player.last_login_time,
            Player#player.avatar,
            Player#player.vip_lv,
            Player#player.cross_scuffle_elite#cross_scuffle_elite_info.att,
            Player#player.cross_scuffle_elite#cross_scuffle_elite_info.rank,
            Player#player.cross_scuffle_elite#cross_scuffle_elite_info.der,
            Player#player.cross_scuffle_elite#cross_scuffle_elite_info.count
        ]),
    cross_scuffle_elite_war_team_ets:set_war_team_member(Member),
    player_join_war_team(Member#wt_member.wtkey, Member#wt_member.name, 1),
    Member,
    ok.

player_join_war_team(TeamKey, Name, Type) ->
    KeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(TeamKey),
    ?DEBUG("KeyList ~p~n", [KeyList]),
    WarTeam =
        case cross_scuffle_elite_war_team_ets:get_war_team(TeamKey) of
            false -> #war_team{};
            Other -> Other
        end,
    case center:get_node_by_sn(WarTeam#war_team.sn) of
        false ->
            skip;
        Node ->
            ?DEBUG("Type ~p~n", [Type]),
            {ok, Bin} = pt_585:write(58509, {Name, Type}),
            F = fun(Key) ->
                center:apply(Node, server_send, send_to_key, [Key, Bin])
            end,
            lists:foreach(F, KeyList)
    end,
    ok.