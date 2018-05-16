%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十月 2017 10:30
%%%-------------------------------------------------------------------
-module(cross_scuffle_elite_war_team_ets).

-include("cross_scuffle_elite.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-compile(export_all).

%%获取战队信息
get_war_team(WarTeamKey) ->
    if
        WarTeamKey == 0 -> false;
        true ->
            case ets:lookup(?ETS_WAR_TEAM, WarTeamKey) of
                [] -> false;
                [WarTeam] ->
                    WarTeam
            end
    end.

war_final_update(WarTeamKey, Score, Win, Lose) ->
    case get_war_team(WarTeamKey) of
        false -> skip;
        WarTeam ->
            Now = util:unixtime(),
            ChangeTime = ?IF_ELSE(Score > 0, Now, WarTeam#war_team.score_change_time),
            set_war_team(WarTeam#war_team{score = WarTeam#war_team.score + Score, win = WarTeam#war_team.win + Win, lose = WarTeam#war_team.lose + Lose, score_change_time = ChangeTime}),
            ok
    end.

war_final_member_update(PKey, List) ->
    Member = get_war_team_member(PKey),
    F = fun({Key, Val}, Member0) ->
        case Key of
            att ->
                Member0#wt_member{att = Member0#wt_member.att + Val}; %% 伤害
            kill ->
                Member0#wt_member{kill = Member0#wt_member.kill + Val}; %% 杀人数
            der ->
                Member0#wt_member{der = Member0#wt_member.der + Val}; %% 承受伤害
            count ->
                Member0#wt_member{count = Member0#wt_member.count + Val}; %%参与次数
            use_role -> %%常用角色
                case lists:keytake(Val, 1, Member0#wt_member.use_role) of
                    false -> Member0#wt_member{use_role = [{Val, 1} | Member0#wt_member.use_role]};
                    {value, {Val, Count}, List1} ->
                        Member0#wt_member{use_role = [{Val, Count + 1} | List1]}
                end;
            rank -> %% 排名
                if
                    Val =< 0 orelse (Val > Member0#wt_member.rank andalso Member0#wt_member.rank /= 0) -> Member0;
                    true -> Member0#wt_member{rank = Val}
                end;
            _ ->
                Member0
        end
    end,
    NewMember = lists:foldl(F, Member, List),
    set_war_team_member(NewMember),
    ok.

%%获取全部战队
get_all_war_team() ->
    ets:tab2list(?ETS_WAR_TEAM).

%%存储战队信息
set_war_team(WarTeam) ->
    ets:insert(?ETS_WAR_TEAM, WarTeam#war_team{is_change = 1}).

set_war_team_new(WarTeam) ->
    ets:insert(?ETS_WAR_TEAM, WarTeam).

%%
%% %%存储战队信息 跨服节点
%% set_war_team_global(Guild) ->
%%     ets:insert(?ETS_WAR_TEAM, Guild#war_team{is_change = 1}),
%%     case center:is_center_all() of
%%         true ->
%%             center:apply_sn(Guild#war_team.sn, ?MODULE, set_war_team_global, [Guild]);
%%         _ -> skip
%%     end.



get_war_team_by_name(WtName) ->
    ets:match_object(?ETS_WAR_TEAM, #war_team{name = util:make_sure_list(WtName), _ = '_'}).

set_war_team_member(Member) ->
    ets:insert(?ETS_WAR_TEAM_MEMBER, Member#wt_member{is_change = 1}).

set_war_team_member_new(Member) ->
    ets:insert(?ETS_WAR_TEAM_MEMBER, Member#wt_member{is_change = 1}).

%%获取战队成员
get_war_team_member(PKey) ->
    case ets:lookup(?ETS_WAR_TEAM_MEMBER, PKey) of
        [] -> false;
        [Member] ->
            Member
    end.

%% %%获取指定的战队成员列表
%% get_war_team_member_list(WtKey) ->
%%     ets:match_object(?ETS_WAR_TEAM_MEMBER, #wt_member{wtkey = WtKey, _ = '_'}).
%%
%% %%获取指定的战队成员key列表
%% get_war_team_member_key_list(WtKey) ->
%%     List = ets:match_object(?ETS_WAR_TEAM_MEMBER, #wt_member{wtkey = WtKey, _ = '_'}),
%%     F = fun(WtMember) ->
%%         WtMember#wt_member.pkey
%%     end,
%%     lists:map(F, List).

%%获取指定的战队成员列表
get_war_team_member_list(WtKey) ->
    if
        WtKey == 0 -> [];
        true ->
            ets:match_object(?ETS_WAR_TEAM_MEMBER, #wt_member{wtkey = WtKey, _ = '_'})
    end.

%%获取指定的战队成员key列表
get_war_team_member_key_list(WtKey) ->
    if
        WtKey == 0 -> [];
        true ->
            List = ets:match_object(?ETS_WAR_TEAM_MEMBER, #wt_member{wtkey = WtKey, _ = '_'}),
            F = fun(WtMember) ->
                WtMember#wt_member.pkey
            end,
            lists:map(F, List)
    end.

%%删除指定的战队申请记录
del_war_team_apply(Key) ->
    ets:delete(?ETS_WAR_TEAM_APPLY, Key).

%%删除指定战队成员
del_war_team_member(PKey) ->
    ets:update_element(?ETS_WAR_TEAM_MEMBER, PKey, [{#wt_member.wtkey, 0}, {#wt_member.is_change, 1}]).
%%     ets:delete(?ETS_WAR_TEAM_MEMBER, PKey).


%%删除指定玩家战队申请信息
del_war_team_apply_by_pkey(PKey) ->
    ets:match_delete(?ETS_WAR_TEAM_APPLY, #wt_apply{pkey = PKey, _ = '_'}).

%%删除指定战队所有申请信息
del_war_team_apply_by_wtkey(WtKey) ->
    ets:match_delete(?ETS_WAR_TEAM_APPLY, #wt_apply{wtkey = WtKey, _ = '_'}).

%%删除指定战队
del_war_team(GKey) ->
    ets:delete(?ETS_WAR_TEAM, GKey).

%%获取指定战队玩家申请信息
get_war_team_apply_by_gkey(WtKey) ->
    ets:match_object(?ETS_WAR_TEAM_APPLY, #wt_apply{wtkey = WtKey, _ = '_'}).

%%存储玩家战队申请信息
set_war_team_apply(Apply) ->
    ets:insert(?ETS_WAR_TEAM_APPLY, Apply).

%%获取指定的战队申请记录
get_war_team_apply(Key) ->
    case ets:lookup(?ETS_WAR_TEAM_APPLY, Key) of
        [] -> false;
        [Apply] -> Apply
    end.

get_war_team_apply_all() ->
    ets:tab2list(?ETS_WAR_TEAM_APPLY).

%%获取玩家指定战队申请记录
get_war_team_apply_one(PKey, WtKey) ->
    case ets:match_object(?ETS_WAR_TEAM_APPLY, #wt_apply{pkey = PKey, wtkey = WtKey, _ = '_'}) of
        [] -> false;
        List -> hd(List)
    end.

%% 删除战队全部成员
del_war_team_member_list(WtKey) ->
    ets:update_element(?ETS_WAR_TEAM_MEMBER, WtKey, [{#wt_member.wtkey, 0}, {#wt_member.is_change, 1}]).
%%     ets:match_delete(?ETS_WAR_TEAM_MEMBER, #wt_member{wtkey = WtKey, _ = '_'}).

get_update_war_team_list() ->
    ets:match_object(?ETS_WAR_TEAM, #war_team{is_change = 1, _ = '_'}).

get_all_war_team_member() ->
    ets:tab2list(?ETS_WAR_TEAM_MEMBER).

get_update_war_team_member_list() ->
    ets:match_object(?ETS_WAR_TEAM_MEMBER, #wt_member{is_change = 1, _ = '_'}).


get_info(TeamKey) ->
    AllMember = cross_scuffle_elite_war_team_ets:get_war_team_member_list(TeamKey),
    WarTeam = cross_scuffle_elite_war_team_ets:get_war_team(TeamKey),
    {AllMember, WarTeam}.

re_set() ->
    AllWarTeam = get_all_war_team(),
    F = fun(WarTeam) ->
        ets:insert(?ETS_WAR_TEAM, WarTeam#war_team{win = 0, lose = 0, score = 0})
    end,
    lists:foreach(F, AllWarTeam),
    AllWarTeamMember = get_all_war_team_member(),
    F1 = fun(WarTeamMenber) ->
        ets:insert(?ETS_WAR_TEAM_MEMBER, WarTeamMenber#wt_member{use_role = [], att = 0, kill = 0, der = 0, count = 0})
    end,
    lists:foreach(F1, AllWarTeamMember),
    ok.
