%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十二月 2015 21:49
%%%-------------------------------------------------------------------
-module(guild_war_util).
-author("hxming").

-include("guild.hrl").
-include("guild_war.hrl").
-include("scene.hrl").
-include("common.hrl").
%% API
-compile(export_all).

%%自动报名
auto_apply() ->
    Now = util:unixtime(),
    guild_war_load:clear(),
    {Title, Content} = t_mail:mail_content(19),
    GuildList = guild_util:get_guild_top_n_list(length(data_guild_war_position:group_list())),
    F = fun(Guild, {Dict, Group}) ->
        GuildWar = #guild_war{gkey = Guild#guild.gkey, group = Group, time = Now},
        guild_war_load:replace(GuildWar),
        Pkeys = [Mb#g_member.pkey || Mb <- guild_ets:get_guild_member_list(Guild#guild.gkey)],
        spawn(fun() -> util:sleep(Group * 100),
            mail:sys_send_mail(Pkeys, Title, Content) end),
        {dict:store(GuildWar#guild_war.gkey, GuildWar, Dict), Group + 1}
        end,
    {NewDict, _} = lists:foldl(F, {dict:new(), 1}, GuildList),
    NewDict.

%%邮件通知报名
notice_apply_by_mail(ApplyDict) ->
    GuildList = guild_ets:get_all_guild(),
    KeyList = dict:fetch_keys(ApplyDict),
    {Title, Content} = t_mail:mail_content(3),
    F = fun(Guild) ->
        case lists:member(Guild#guild.gkey, KeyList) of
            true -> skip;
            false ->
                MemberList = guild_ets:get_guild_member_list(Guild#guild.gkey),
                Pkeys = [Mb#g_member.pkey || Mb <- MemberList, Mb#g_member.position =< ?GUILD_POSITION_VICE_CHAIRMAN],
                mail:sys_send_mail(Pkeys, Title, Content)
        end
        end,
    lists:foreach(F, GuildList).

%%获取领导仙盟
get_group_guild_key(GDict, Group) ->
    Dict = dict:filter(fun(_Key, Apply) -> Apply#guild_war.group == Group end, GDict),
    Glist = [Apply || {_, Apply} <- dict:to_list(Dict)],
    case lists:keysort(#guild_war.time, Glist) of
        [] -> 0;
        [Apply | _] ->
            Apply#guild_war.gkey
    end.

%%通知玩家参加仙盟战
notice_join_war(KeyList) ->
    {ok, Bin} = pt_410:write(41005, {}),
    [server_send:send_to_guild(Key, Bin) || Key <- KeyList].

%%场景清玩家
clean_scene(Dict) ->
    F = fun({Key, Pid}) ->
        case dict:is_key(Key, Dict) of
            true ->
                Mb = dict:fetch(Key, Dict),
                Copy = scene_copy_proc:get_scene_copy(Mb#g_war_mb.scene, Mb#g_war_mb.copy),
                Pid ! {change_scene, Mb#g_war_mb.scene, Copy, Mb#g_war_mb.x, Mb#g_war_mb.y, false};
            false ->
                Scene = data_scene:get(?SCENE_ID_MAIN),
                Copy = scene_copy_proc:get_scene_copy(Scene#scene.id, 0),
                Pid ! {change_scene, Scene#scene.id, Copy, Scene#scene.x, Scene#scene.y, false}
        end
        end,
    lists:foreach(F, scene_agent:get_scene_player_key_pid(?SCENE_ID_GUILD_WAR, 0)),
    %%杀掉怪物
    [monster:stop_broadcast(Aid) || Aid <- mon_agent:get_scene_mon_pids(?SCENE_ID_GUILD_WAR, 0)],
    scene_agent:clean_scene_area(?SCENE_ID_GUILD_WAR, 0),
    ok.


%%势力点回血
recovery_hp(Player) ->
    case scene:is_guild_war_scene(Player#player.scene) of
        false -> Player;
        true ->
            case in_group_position(Player#player.group, Player#player.x, Player#player.y) of
                true ->
                    if Player#player.hp > 0 andalso Player#player.hp < Player#player.attribute#attribute.hp_lim ->
                        Rhp = round(Player#player.attribute#attribute.hp_lim * 0.2),
                        Hp = min(Player#player.attribute#attribute.hp_lim, Player#player.hp + Rhp),
                        {ok, Bin} = pt_200:write(20004, {[[?SIGN_PLAYER, Player#player.key, 1, Rhp, Hp]]}),
                        server_send:send_to_sid(Player#player.sid, Bin),
                        NewPlayer = Player#player{hp = Hp},
                        scene_agent_dispatch:hpmp_update(NewPlayer),
                        NewPlayer;
                        true -> Player
                    end;
                false ->
                    Player
            end
    end.

%%计算是否在势力点内
in_group_position(Group, X, Y) ->
    case data_guild_war_position:get(Group) of
        [] -> false;
        [{X1, Y1}, {X2, Y2} | _] ->
            X >= X1 andalso X =< X2 andalso Y >= Y1 andalso Y =< Y2
    end.

%%获取势力点
get_xy(Group) ->
    case data_guild_war_position:get(Group) of
        [] ->
            Scene = data_scene:get(?SCENE_ID_GUILD_WAR),
            {Scene#scene.x, Scene#scene.y};
        [{X1, Y1}, {X2, Y2} | _] ->
            {util:rand(X1, X2), util:rand(Y1, Y2)}
    end.

%%检查是否保护区
is_protect_area(SceneId, X, Y, Group) ->
    case scene:is_guild_war_scene(SceneId) of
        false -> false;
        true ->
            in_group_position(Group, X, Y)
    end.

%%刷新资源定时器
create_crystal_timer(Now) ->
    F = fun(Id) ->
        Base = data_guild_war_crystal:get(Id),
        {RefreshTime, RefList, NrefList} = set_timer(Id, Base#base_guild_war_crystal.refresh_time, Now, Base#base_guild_war_crystal.type),
        Base#base_guild_war_crystal{id = Id, ref = RefList, notice_ref = NrefList, refresh_time = lists:sort(RefreshTime)}
        end,
    lists:map(F, data_guild_war_crystal:ids()).

set_timer(Id, RefreshTime, Now, Type) ->
    F1 = fun(Time, {TList, RList, NList}) ->
        TimerHandle = erlang:send_after(Time * 1000, self(), {refresh_crystal, Id}),
        NoticeTimer = 30,
        if Time < NoticeTimer orelse Type == ?CRYSTAL_TYPE_LOW ->
            {[Time + Now | TList], [TimerHandle | RList], NList};
            true ->
                TimerHandle1 = erlang:send_after((Time - 30) * 1000, self(), {refresh_notice, Id}),
                {[Time + Now | TList], [TimerHandle | RList], [TimerHandle1 | NList]}

        end
         end,
    lists:foldl(F1, {[], [], []}, RefreshTime).

cancel_crystal_timer(Clist) ->
    [util:cancel_ref(Base#base_guild_war_crystal.ref) || Base <- Clist],
    [util:cancel_ref(Base#base_guild_war_crystal.notice_ref) || Base <- Clist].

%%创建防守怪
create_def_mon() ->
    F = fun(Group) ->
        case data_guild_war_def:get(Group) of
            [] -> skip;
            MonList ->
                [mon_agent:create_mon_cast([MonId, ?SCENE_ID_GUILD_WAR, X, Y, 0, 1, [{group, Group}]]) || {MonId, X, Y} <- MonList]

        end
        end,
    lists:foreach(F, data_guild_war_def:ids()).

%%刷新资源，同一地点如果存在的话，则不刷新
refresh_crystal(Id, PosList) ->
    case lists:keyfind(Id, #base_guild_war_crystal.id, PosList) of
        false -> PosList;
        Base ->
            if Base#base_guild_war_crystal.state == 1 -> PosList;
                true ->
                    MonList = mon_agent:get_scene_mon_by_mid(?SCENE_ID_GUILD_WAR, Base#base_guild_war_crystal.mon_id),
                    F = fun(Mon) ->
                        Mon#mon.d_x == Base#base_guild_war_crystal.x andalso Mon#mon.d_y == Base#base_guild_war_crystal.y
                        end,
                    case lists:any(F, MonList) of
                        true -> PosList;
                        false ->
                            NewBase = Base#base_guild_war_crystal{state = 1},
                            mon_agent:create_mon_cast([Base#base_guild_war_crystal.mon_id, ?SCENE_ID_GUILD_WAR, Base#base_guild_war_crystal.x, Base#base_guild_war_crystal.y, 0, 1, []]),
                            lists:keyreplace(Id, #base_guild_war_crystal.id, PosList, NewBase)
                    end
            end
    end.

%%水晶刷新通知
refresh_crystal_notice(Id, PosList) ->
    case lists:keyfind(Id, #base_guild_war_crystal.id, PosList) of
        false -> PosList;
        _Base -> skip
%%             if Base#base_guild_war_crystal.type == ?CRYSTAL_TYPE_HIGH orelse Base#base_guild_war_crystal.type == ?CRYSTAL_TYPE_MID ->
%%                 notice_sys:add_notice(guild_war_crystal, [Base#base_guild_war_crystal.notice, ?SCENE_ID_GUILD_WAR, Base#base_guild_war_crystal.x, Base#base_guild_war_crystal.y]);
%%                 true -> skip
%%             end
    end.

%%怪物死亡
collect(Mon, Pkey) ->
    guild_war_proc:get_server_pid() ! {collect, Mon#mon.mid, Mon#mon.x * 1000 + Mon#mon.y, Pkey, self()}.


get_state(Player) ->
    if Player#player.guild#st_guild.guild_position =< ?GUILD_POSITION_VICE_CHAIRMAN ->
        case ?CALL(guild_war_proc:get_server_pid(), {check_apply, Player#player.guild#st_guild.guild_key}) of
            [] -> 0;
            Val -> Val
        end;
        true -> 0
    end.