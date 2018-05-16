%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十月 2017 20:28
%%%-------------------------------------------------------------------
-module(cross_scuffle_elite_war_team_init).
-author("luobq").
-include("common.hrl").
-include("server.hrl").
-include("cross_scuffle_elite.hrl").


%% API
-export([
    init/1
    , cross_init/4
    , timer_update/0
    , init_war_team_data/0
    , init_war_team/0
    , init_war_team_member/0
    , init_war_team_apply/0
]).


%%玩家登陆初始化战队信息
init(Player) ->
    if
        Player#player.lv < 60 -> skip;
        true ->
            cross_all:apply(cross_scuffle_elite_war_team_init, cross_init, [Player#player.key, Player#player.pid, Player#player.lv, Player#player.avatar])
    end,
    %% 修复战队名字问题
    spawn(fun() -> util:sleep(3000), cross_scuffle_elite:repair_name(Player) end),
    Player.

%%玩家登陆初始化战队信息
cross_init(Pkey, Pid, Lv, Avatar) ->
    case cross_scuffle_elite_war_team_ets:get_war_team_member(Pkey) of
        false -> skip;
        Member ->
            cross_scuffle_elite,
            case cross_scuffle_elite_war_team_ets:get_war_team(Member#wt_member.wtkey) of
                false ->
                    Pid ! {update_war_team, [0, <<>>, ?WAR_TEAM_POSITION_NORMAL]},
                    St1 = #cross_scuffle_elite_info{
                        role_list = Member#wt_member.use_role,
                        att = Member#wt_member.kill,   %% 击杀数
                        der = Member#wt_member.der,
                        rank = Member#wt_member.rank,
                        count = Member#wt_member.count
                    },
                    Pid ! {cross_scuffle_elite, [St1]},
                    skip;
                _WarTeam ->
                    Now = util:unixtime(),
                    WarTeamName = cross_scuffle_elite_war_team_util:get_war_team_name(Member#wt_member.wtkey),
                    NewMember = Member#wt_member{is_online = 1, pid = Pid, lv = Lv, avatar = Avatar, last_login_time = Now},
                    %%登录更新
                    cross_scuffle_elite_war_team_ets:set_war_team_member(NewMember),
%%                     StWarTeam = #st_war_team{
%%                         war_team_key = Member#wt_member.wtkey,
%%                         war_team_name = WarTeamName,
%%                         war_team_position = Member#wt_member.position
%%                     },
%%                     case Player#player.key == WarTeam#war_team.pkey of
%%                         true ->
%%                             croutil:guild_apply_notice(WarTeam#war_team.wtkey);
%%                         false ->
%%                             skip
%%                     end,
%%                     case Member#wt_member.position == ?WAR_TEAM_POSITION_CHAIRMAN of
%%                         true -> guild_util:change_mb_attr(Player#player.key, [{vip, Player#player.vip_lv}]);
%%                         false -> skp
%%                     end,
                    Pid ! {update_war_team, [Member#wt_member.wtkey, WarTeamName, Member#wt_member.position]}
            end
    end.

%%玩家离线，更新离线状态
logout(Player, _NowTime) ->
    case cross_scuffle_elite_war_team_ets:get_war_team_member(Player#player.key) of
        false -> skip;
        Member ->
            NewMember = Member#wt_member{is_online = 0, pid = undefined, cbp = Player#player.cbp},
            cross_scuffle_elite_war_team_ets:set_war_team_member(NewMember)
    end.

timer_update() ->
    F = fun(WarTeam) ->
        if WarTeam#war_team.is_change == 1 ->
            cross_scuffle_elite_war_team_ets:set_war_team_new(WarTeam#war_team{is_change = 0}),
            cross_scuffle_elite_load:replace_war_team(WarTeam);
            true -> ok
        end
    end,
    lists:foreach(F, cross_scuffle_elite_war_team_ets:get_update_war_team_list()),

    F1 = fun(Member) ->
        if Member#wt_member.is_change == 1 ->
            cross_scuffle_elite_war_team_ets:set_war_team_member_new(Member#wt_member{is_change = 0}),
            cross_scuffle_elite_load:replace_war_team_member(Member);
            true -> ok
        end
    end,
    lists:foreach(F1, cross_scuffle_elite_war_team_ets:get_update_war_team_member_list()),

    ok.

%%初始化战队系统数据
init_war_team_data() ->
    init_war_team(),
    init_war_team_member(),
    init_war_team_apply(),
    ok.

%%初始化战队数据
init_war_team() ->
    Data = cross_scuffle_elite_load:select_war_team(),
    F = fun([Key, Name, Num, PKey, PName, PCareer, PVip, CreateTime, Sn, _Win, _Lose, _Score]) ->
        Guild = #war_team{
            wtkey = Key,
            name = Name,
            num = Num,
            pkey = PKey,
            pname = PName,
            pcareer = PCareer,
            pvip = PVip,
            create_time = CreateTime,
            sn = Sn
%%             win = Win,
%%             lose = Lose,
%%             score = Score
        },
        cross_scuffle_elite_war_team_ets:set_war_team_new(Guild)
    end,
    lists:foreach(F, Data),
    ok.
%%
%% %%初始化战队成员数据
init_war_team_member() ->
    Data = cross_scuffle_elite_load:select_war_team_member(),
%%      `pkey`,wtkey,position, career, sex,lv,vip,join_time,att,der,rank,count,name,use_role,`kill`
    F = fun([Pkey, Wtkey, Position, Career, Sex, Lv, Vip, JoinTime, _Att, _Der, Rank, _Count, Name, _UseRole, _Kill]) ->
        GMember = #wt_member{
            pkey = Pkey
            , wtkey = Wtkey
            , position = Position
            , name = Name
            , career = Career
            , sex = Sex
            , lv = Lv
            , vip = Vip
%%             , use_role = util:bitstring_to_term(UseRole)   %% 重启清数据
            , join_time = JoinTime
%%             , att = Att
%%             , der = Der
            , rank = Rank
%%             , count = Count
%%             , kill = Kill
        },
        cross_scuffle_elite_war_team_ets:set_war_team_member_new(GMember)
    end,
    lists:foreach(F, Data),
    ok.
%%
%% 初始化战队申请列表
init_war_team_apply() ->
    Data = cross_scuffle_elite_load:select_war_team_apply(),
    F = fun([Key, PKey, WtKey, Name, Career, Lv, Cbp, Vip, Timestamp, Rank]) ->
        Apply = #wt_apply{
            akey = Key
            , pkey = PKey
            , wtkey = WtKey
            , nickname = Name
            , career = Career
            , lv = Lv
            , cbp = Cbp
            , vip = Vip
            , timestamp = Timestamp
            , rank = Rank
        },
        cross_scuffle_elite_war_team_ets:set_war_team_apply(Apply)
    end,
    lists:foreach(F, Data),
    ok.



