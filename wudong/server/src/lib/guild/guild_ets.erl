%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 20:02
%%%-------------------------------------------------------------------
-module(guild_ets).
-author("hxming").

-include("guild.hrl").
%% API
-compile(export_all).

%%获取仙盟信息
get_guild(GuildKey) ->
    case ets:lookup(?ETS_GUILD, GuildKey) of
        [] -> false;
        [Guild] ->
            Guild
    end.

get_guild_by_name(GName) ->
    ets:match_object(?ETS_GUILD, #guild{name = util:make_sure_list(GName), _ = '_'}).

%%获取全部仙盟
get_all_guild() ->
    ets:tab2list(?ETS_GUILD).


get_update_guild_list() ->
    ets:match_object(?ETS_GUILD, #guild{is_change = 1, _ = '_'}).

%%存储仙盟信息
set_guild(Guild) ->
    ets:insert(?ETS_GUILD, Guild#guild{is_change = 1}).

set_guild_new(Guild) ->
    ets:insert(?ETS_GUILD, Guild).


%%删除指定仙盟
del_guild(GKey) ->
    ets:delete(?ETS_GUILD, GKey).


set_guild_member(Member) ->
    spawn(fun() -> guild_box:update_player_list_gkey([Member#g_member.pkey], Member#g_member.gkey) end),    %% 更新公会宝箱
    ets:insert(?ETS_GUILD_MEMBER, Member#g_member{is_change = 1}).

set_guild_member_new(Member) ->
    spawn(fun() -> guild_box:update_player_list_gkey([Member#g_member.pkey], Member#g_member.gkey) end),    %% 更新公会宝箱
    ets:insert(?ETS_GUILD_MEMBER, Member).

%%获取仙盟成员
get_guild_member(PKey) ->
    case ets:lookup(?ETS_GUILD_MEMBER, PKey) of
        [] -> false;
        [Member] ->
            Member
    end.

get_all_guild_member() ->
    ets:tab2list(?ETS_GUILD_MEMBER).

get_update_guild_member_list() ->
    ets:match_object(?ETS_GUILD_MEMBER, #g_member{is_change = 1, _ = '_'}).

%%获取指定的仙盟成员列表
get_guild_member_list(GKey) ->
    ets:match_object(?ETS_GUILD_MEMBER, #g_member{gkey = GKey, _ = '_'}).

%%获取指定职位的人员数目
get_guild_position_count(GKey, Position) ->
    List = ets:match_object(?ETS_GUILD_MEMBER, #g_member{gkey = GKey, position = Position, _ = '_'}),
    length(List).


%%删除指定仙盟成员
del_guild_member(PKey) ->
    spawn(fun() -> guild_box:update_player_list_gkey([PKey], 0) end), %% 更新公会宝箱
    ets:delete(?ETS_GUILD_MEMBER, PKey).

%%删除仙盟全部成员
del_guild_member_list(GKey) ->
    List = ets:match_object(?ETS_GUILD_MEMBER, #g_member{gkey = GKey, _ = '_'}),
    F = fun(WtMember) ->
        WtMember#g_member.pkey
    end,
    KeyList = lists:map(F, List),
    spawn(fun() -> guild_box:update_player_list_gkey(KeyList, 0) end),    %% 更新公会宝箱
    ets:match_delete(?ETS_GUILD_MEMBER, #g_member{gkey = GKey, _ = '_'}).


%%存储玩家仙盟申请信息
set_guild_apply(Apply) ->
    ets:insert(?ETS_GUILD_APPLY, Apply).

%%获取指定的仙盟申请记录
get_guild_apply(Key) ->
    case ets:lookup(?ETS_GUILD_APPLY, Key) of
        [] -> false;
        [Apply] -> Apply
    end.

get_guild_apply_all() ->
    ets:tab2list(?ETS_GUILD_APPLY).

%%删除指定的仙盟申请记录
del_guild_apply(Key) ->
    ets:delete(?ETS_GUILD_APPLY, Key).

%%获取玩家指定仙盟申请记录
get_guild_apply_one(PKey, GKey) ->
    case ets:match_object(?ETS_GUILD_APPLY, #g_apply{pkey = PKey, gkey = GKey, _ = '_'}) of
        [] -> false;
        List -> hd(List)
    end.

%%获取指定玩家申请仙盟信息
get_guild_apply_by_pkey(PKey) ->
    ets:match_object(?ETS_GUILD_APPLY, #g_apply{pkey = PKey, _ = '_'}).

%%获取指定仙盟玩家申请信息
get_guild_apply_by_gkey(GKey) ->
    ets:match_object(?ETS_GUILD_APPLY, #g_apply{gkey = GKey, _ = '_'}).

%%删除指定玩家仙盟申请信息
del_guild_apply_by_pkey(PKey) ->
    ets:match_delete(?ETS_GUILD_APPLY, #g_apply{pkey = PKey, _ = '_'}).

%%删除指定仙盟玩家申请信息
del_guild_apply_by_gkey(GKey) ->
    ets:match_delete(?ETS_GUILD_APPLY, #g_apply{gkey = GKey, _ = '_'}).

get_guild_history(Pkey) ->
    case ets:lookup(?ETS_GUILD_HISTORY, Pkey) of
        [] -> false;
        [History] -> History
    end.

set_guild_history(History) ->
    ets:insert(?ETS_GUILD_HISTORY, History).
del_guild_history(Pkey) ->
    ets:delete(?ETS_GUILD_HISTORY, Pkey).



fix_vip() ->
    L = ets:tab2list(?ETS_GUILD_MEMBER),
    spawn(fun() -> fix_loop(L, 0) end),
    ok.

fix_loop([], _) -> ok;
fix_loop(L, 100) ->
    util:sleep(1000),
    fix_loop(L, 0);
fix_loop([Member | T], Acc) ->
    Sql = io_lib:format("select combat_power,highest_combat_power,vip_lv from player_state where pkey=~p", [Member#g_member.pkey]),
    case db:get_row(Sql) of
        [] -> ok;
        [Cbp, HCbp, Vip] ->
            ets:insert(?ETS_GUILD_MEMBER, Member#g_member{vip = Vip, cbp = Cbp, h_cbp = HCbp})
    end,
    fix_loop(T, Acc + 1).