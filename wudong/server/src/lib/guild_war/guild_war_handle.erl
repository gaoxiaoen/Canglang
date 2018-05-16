%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十二月 2015 17:26
%%%-------------------------------------------------------------------
-module(guild_war_handle).
-author("hxming").
-include("guild_war.hrl").
-include("server.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("designation.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).
-export([get_group_reward/2]).

-define(GUILD_WAR_TIME_SEC, 1200).

%%请求进入仙盟站
handle_call({enter, Player, Figure}, _From, State) ->
    {Ret, NewX, NewY, Group, NewState} =
        if
            State#st_guild_war.war_state /= ?GUILD_WAR_STATE_START ->
                {701, 0, 0, 0, State};
            Player#player.convoy_state > 0 ->
                {802, 0, 0, 0, State};
            Player#player.match_state > 0 ->
                {804, 0, 0, 0, State};
            Player#player.lv < 45 ->
                {803, 0, 0, 0, State};
            true ->
                case dict:is_key(Player#player.guild#st_guild.guild_key, State#st_guild_war.g_dict) of
                    false -> {702, 0, 0, 0, State};
                    true ->
                        case lists:member(Figure, data_guild_war_figure:ids()) of
                            false -> {703, 0, 0, 0, State};
                            true ->
                                case dict:is_key(Player#player.key, State#st_guild_war.p_dict) of
                                    true ->
                                        Mb = dict:fetch(Player#player.key, State#st_guild_war.p_dict),
                                        {X, Y} = guild_war_util:get_xy(Mb#g_war_mb.group),
                                        NewMb = Mb#g_war_mb{figure = Figure, scene = Player#player.scene, copy = Player#player.copy, x = Player#player.x, y = Player#player.y},
                                        PDict = dict:store(Player#player.key, NewMb, State#st_guild_war.p_dict),
                                        {1, X, Y, Mb#g_war_mb.group, State#st_guild_war{p_dict = PDict}};
                                    false ->
                                        Apply = dict:fetch(Player#player.guild#st_guild.guild_key, State#st_guild_war.g_dict),
                                        {X, Y} = guild_war_util:get_xy(Apply#guild_war.group),
                                        GroupGKey = guild_war_util:get_group_guild_key(State#st_guild_war.g_dict, Apply#guild_war.group),
                                        IsCmd =
                                            if
                                                GroupGKey == Player#player.guild#st_guild.guild_key andalso Player#player.guild#st_guild.guild_position == ?GUILD_POSITION_CHAIRMAN ->
                                                    1;
                                                true -> 0
                                            end,
                                        Mb =
                                            #g_war_mb{
                                                pkey = Player#player.key,
                                                nickname = Player#player.nickname,
                                                career = Player#player.career,
                                                realm = Player#player.realm,
                                                vip = Player#player.vip_lv,
                                                scene = Player#player.scene,
                                                copy = Player#player.copy,
                                                x = Player#player.x,
                                                y = Player#player.y,
                                                gkey = Player#player.guild#st_guild.guild_key,
                                                gname = Player#player.guild#st_guild.guild_name,
                                                group = Apply#guild_war.group,
                                                figure = Figure,
                                                is_cmd = IsCmd
                                            },
                                        PDict = dict:store(Player#player.key, Mb, State#st_guild_war.p_dict),
                                        {1, X, Y, Apply#guild_war.group, State#st_guild_war{p_dict = PDict}}
                                end
                        end
                end
        end,
    {reply, {Ret, NewX, NewY, Group}, NewState};

handle_call({quit, Key}, _From, State) ->
    Data =
        case dict:is_key(Key, State#st_guild_war.p_dict) of
            false ->
                Scene = data_scene:get(?SCENE_ID_MAIN),
                {Scene#scene.id, 0, Scene#scene.x, Scene#scene.y};
            true ->
                Mb = dict:fetch(Key, State#st_guild_war.p_dict),
                case scene:is_guild_war_scene(Mb#g_war_mb.scene) of
                    false ->
                        {Mb#g_war_mb.scene, Mb#g_war_mb.copy, Mb#g_war_mb.x, Mb#g_war_mb.y};
                    true ->
                        Scene = data_scene:get(?SCENE_ID_MAIN),
                        {Scene#scene.id, 0, Scene#scene.x, Scene#scene.y}
                end
        end,
    {reply, Data, State};

handle_call({back, Pkey}, _From, State) ->
    Data =
        case dict:is_key(Pkey, State#st_guild_war.p_dict) of
            false ->
                Scene = data_scene:get(?SCENE_ID_MAIN),
                {false, Scene#scene.id, 0, Scene#scene.x, Scene#scene.y};
            true ->
                Mb = dict:fetch(Pkey, State#st_guild_war.p_dict),
                case State#st_guild_war.war_state == ?GUILD_WAR_STATE_START of
                    false ->
                        case scene:is_guild_war_scene(Mb#g_war_mb.scene) of
                            false ->
                                {false, Mb#g_war_mb.scene, Mb#g_war_mb.copy, Mb#g_war_mb.x, Mb#g_war_mb.y};
                            true ->
                                Scene = data_scene:get(?SCENE_ID_MAIN),
                                {false, Scene#scene.id, 0, Scene#scene.x, Scene#scene.y}
                        end;
                    true ->
                        {true, Mb#g_war_mb.figure, Mb#g_war_mb.group}
                end
        end,
    {reply, Data, State};

%%查询是否可报名仙盟战
handle_call({check_apply, Gkey}, _From, State) ->
    Ret =
        if State#st_guild_war.war_state == ?GUILD_WAR_STATE_APPLY ->
            ApplyLen = length(data_guild_war_position:group_list()) * 5,
            case dict:size(State#st_guild_war.g_dict) >= ApplyLen of
                true ->
                    0;
                false ->
                    case dict:is_key(Gkey, State#st_guild_war.g_dict) of
                        false -> 1;
                        true -> 0
                    end
            end;
            true -> 0
        end,
    {reply, Ret, State};

handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

%%获取仙盟战状态
handle_cast({check_state, Sid, Now}, State) ->
    if State#st_guild_war.war_state == ?GUILD_WAR_STATE_APPLY -> skip;
        true ->
            LiftTime = max(0, State#st_guild_war.end_time - Now),
            {ok, Bin} = pt_410:write(41001, {State#st_guild_war.war_state, LiftTime}),
            server_send:send_to_sid(Sid, Bin)
    end,
    {noreply, State};

%%删除报名
handle_cast({del_apply, Gkey}, State) ->
    case dict:is_key(Gkey, State#st_guild_war.g_dict) of
        false ->
            {noreply, State};
        true ->
            Dict = dict:erase(Gkey, State#st_guild_war.g_dict),
            guild_war_load:delete(Gkey),
            {noreply, State#st_guild_war{g_dict = Dict}}
    end;

%%获取报名列表
handle_cast({apply_list, Gkey, Sid}, State) ->
    F = fun(Group) ->
        Dict = dict:filter(fun(_Key, Apply) -> Apply#guild_war.group == Group end, State#st_guild_war.g_dict),
        case [Apply || {_, Apply} <- dict:to_list(Dict)] of
            [] ->
                [Group, 0, <<>>, <<>>, 0, 0];
            Glist ->
                SortList = lists:keysort(#guild_war.time, Glist),
                Apply = hd(SortList),
                {GName, PName} = guild_util:get_name(Apply#guild_war.gkey),
                IsApply =
                    case dict:is_key(Gkey, Dict) of
                        false -> 0;
                        true -> 1
                    end,
                [Group, Apply#guild_war.gkey, GName, PName, length(SortList), IsApply]
        end
        end,
    List = lists:map(F, data_guild_war_position:group_list()),
    LeftTime = max(0, State#st_guild_war.end_time - util:unixtime()),
    {ok, Bin} = pt_410:write(41002, {State#st_guild_war.war_state, LeftTime, List}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%势力报名列表
handle_cast({group_list, Group, Sid}, State) ->
    Dict = dict:filter(fun(_Key, Apply) -> Apply#guild_war.group == Group end, State#st_guild_war.g_dict),
    Glist = [Apply || {_, Apply} <- dict:to_list(Dict)],
    NewGlist =
        case lists:keysort(#guild_war.time, Glist) of
            [] -> [];
            [_ | L] ->
                L
        end,
    F = fun(Apply) ->
        {GName, _PName} = guild_util:get_name(Apply#guild_war.gkey),
        [Apply#guild_war.gkey, GName]
        end,
    List = lists:map(F, lists:keysort(#guild_war.time, NewGlist)),
    {ok, Bin} = pt_410:write(41003, {Group, List}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%仙盟战报名
handle_cast({apply, StGuild, _Group, Sid}, State) ->
    {Ret, NewState} =
        if StGuild#st_guild.guild_key == 0 -> {401, State};
%%            State#st_guild_war.war_state /= ?GUILD_WAR_STATE_APPLY -> {406, State};
            StGuild#st_guild.guild_position > ?GUILD_POSITION_VICE_CHAIRMAN -> {402, State};
            true ->
                case dict:is_key(StGuild#st_guild.guild_key, State#st_guild_war.g_dict) of
                    true -> {404, State};
                    false ->
                        %%总报名仙盟数限制
                        case dict:size(State#st_guild_war.g_dict) >= 30 of
                            true ->
                                {405, State};
                            false ->
                                Group = apply_match_group(State#st_guild_war.g_dict),
                                GuildWar = #guild_war{gkey = StGuild#st_guild.guild_key, group = Group, time = util:unixtime()},
                                GDict = dict:store(StGuild#st_guild.guild_key, GuildWar, State#st_guild_war.g_dict),
                                guild_war_load:replace(GuildWar),
                                case guild_ets:get_guild(StGuild#st_guild.guild_key) of
                                    false -> skip;
                                    Guild ->
                                        {Title, Content} = t_mail:mail_content(19),
                                        MemberList = guild_ets:get_guild_member_list(Guild#guild.gkey),
                                        Pkeys = [Mb#g_member.pkey || Mb <- MemberList],
                                        mail:sys_send_mail(Pkeys, Title, Content),
                                        F = fun(Mb) ->
                                            if Mb#g_member.position =< ?GUILD_POSITION_VICE_CHAIRMAN andalso Mb#g_member.is_online == 1 ->
                                                    catch Mb#g_member.pid ! {activity_notice, 57};
                                                true -> skip
                                            end
                                            end,
                                        lists:foreach(F, MemberList)
                                end,
                                {1, State#st_guild_war{g_dict = GDict}}
                        end
                end
        end,
    {ok, Bin} = pt_410:write(41004, {Ret}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, NewState};

%%变身更改
handle_cast({figure, Key, Figure}, State) ->
    PDict =
        case dict:is_key(Key, State#st_guild_war.p_dict) of
            false ->
                State#st_guild_war.p_dict;
            true ->
                Mb = dict:fetch(Key, State#st_guild_war.p_dict),
                dict:store(Key, Mb#g_war_mb{figure = Figure}, State#st_guild_war.p_dict)
        end,
    {noreply, State#st_guild_war{p_dict = PDict}};

%%数据统计
handle_cast({info, Pkey, Sid}, State) ->
    Now = util:unixtime(),
    TimeLeft = max(0, State#st_guild_war.end_time - Now),
    Data =
        case dict:is_key(Pkey, State#st_guild_war.p_dict) of
            false ->
                {0, 0, TimeLeft, 0, 0, 0, 0, [], []};
            true ->
                ResList = calc_resource(State#st_guild_war.g_dict),
                Mb = dict:fetch(Pkey, State#st_guild_war.p_dict),
                Collect = [tuple_to_list(Item) || Item <- Mb#g_war_mb.collect_count],
                CmdCd =
                    case lists:keyfind(Mb#g_war_mb.group, 1, State#st_guild_war.cmd_cd) of
                        false -> 0;
                        {_, LastTime} ->
                            ?IF_ELSE(Now > LastTime, 0, LastTime - Now)
                    end,
                {Mb#g_war_mb.is_cmd, CmdCd, TimeLeft, Mb#g_war_mb.figure, Mb#g_war_mb.contrib,
                    Mb#g_war_mb.kill_count, Mb#g_war_mb.assists_count, Collect, ResList}
        end,
    {ok, Bin} = pt_410:write(41009, Data),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%查看排行
handle_cast({rank, Sid, Type, Page}, State) ->
    RankList = calc_mb_rank(Type, State#st_guild_war.p_dict),
    MaxPage = length(RankList) div 10 + 1,
    NowPage = ?IF_ELSE(Page =< 0 orelse Page > MaxPage, 1, Page),
    Rank = NowPage * 10 - 9,
    NewRankList =
        case RankList of
            [] -> [];
            _ ->
                lists:sublist(RankList, Rank, 10)
        end,
    F = fun(Mb) ->
        [Mb#g_war_mb.rank_id, Mb#g_war_mb.pkey, Mb#g_war_mb.nickname, Mb#g_war_mb.career, Mb#g_war_mb.vip, Mb#g_war_mb.rank_val, Mb#g_war_mb.gname]
        end,
    Data = lists:map(F, NewRankList),
    {ok, Bin} = pt_410:write(41010, {Type, NowPage, MaxPage, Data}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%指挥
handle_cast({command, PKey, Sid, Nickname, X, Y}, State) ->
    {Ret, NewState} =
        case dict:is_key(PKey, State#st_guild_war.p_dict) of
            false -> {1201, State};
            true ->
                Mb = dict:fetch(PKey, State#st_guild_war.p_dict),
                if Mb#g_war_mb.is_cmd /= 1 ->
                    {1201, State};
                    true ->
                        Now = util:unixtime(),
                        case check_cmd_cd(Mb#g_war_mb.group, State#st_guild_war.cmd_cd, Now) of
                            false ->
                                {1202, State};
                            true ->
                                List = scene_agent:get_pids_by_group(?SCENE_ID_GUILD_WAR, 0, Mb#g_war_mb.group),
                                {ok, Bin} = pt_410:write(41013, {Nickname, X, Y}),
                                F = fun({Key, Pid}) ->
                                    if Key /= PKey ->
                                        server_send:send_to_pid(Pid, Bin);
                                        true -> skip
                                    end
                                    end,
                                lists:foreach(F, List),
                                CdList = [{Mb#g_war_mb.group, Now + 60} | lists:keydelete(Mb#g_war_mb.group, 1, State#st_guild_war.cmd_cd)],
                                {1, State#st_guild_war{cmd_cd = CdList}}
                        end
                end
        end,
    {ok, Bin1} = pt_410:write(41012, {Ret}),
    server_send:send_to_sid(Sid, Bin1),
    {noreply, NewState};

handle_cast({crystal_list, Sid}, State) ->
    Bin = crystal_list(State#st_guild_war.pos_list),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_cast({crystal_refresh_list, Sid}, State) ->
    Bin = crystal_refresh_list(State#st_guild_war.pos_list),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_cast({final, Key, Sid}, State) ->
    Mb =
        case dict:is_key(Key, State#st_guild_war.p_dict) of
            false ->
                #g_war_mb{};
            true ->
                dict:fetch(Key, State#st_guild_war.p_dict)
        end,
    {ok, Bin} = pt_410:write(41014, {Mb#g_war_mb.contrib, Mb#g_war_mb.is_new, Mb#g_war_mb.rank_id, Mb#g_war_mb.exploit, [tuple_to_list(Item) || Item <- Mb#g_war_mb.goods_list]}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%%每日定时器重置
handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_guild_war.ref]),
    NewState = guild_war_proc:set_timer(Now, State),
    {noreply, NewState};

%%自动报名
handle_info({auto_apply}, State) ->
    Dict = guild_war_util:auto_apply(),
    NewState = State#st_guild_war{g_dict = Dict},
    {noreply, NewState};

%%提前公告
handle_info({notice, _Type}, State) ->
%%     case Type of
%%         g_war_notice_30 ->
%%             notice_sys:add_notice(g_war_notice_30, []);
%%         g_war_notice_10 ->
%%             notice_sys:add_notice(g_war_notice_10, []);
%%         _ -> skip
%%     end,
    {noreply, State};

%%准备通知
handle_info({ready, ReadyTime, LastTime}, State) when State#st_guild_war.war_state == ?GUILD_WAR_STATE_APPLY ->
    util:cancel_ref([State#st_guild_war.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_410:write(41001, {?GUILD_WAR_STATE_READY, ReadyTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_guild_war{war_state = ?GUILD_WAR_STATE_READY, end_time = Now + ReadyTime, ref = Ref},
%%     notice_sys:add_notice(guild_war_ready, []),
    {noreply, NewState};

%%仙盟战开始
handle_info({start, LastTime}, State) when State#st_guild_war.war_state /= ?GUILD_WAR_STATE_START ->
    util:cancel_ref([State#st_guild_war.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_410:write(41001, {?GUILD_WAR_STATE_START, LastTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(LastTime * 1000, self(), {close}),
    guild_war_util:notice_join_war(dict:fetch_keys(State#st_guild_war.g_dict)),
    %%防守怪
    guild_war_util:create_def_mon(),
    %%水晶定时器
    Position = guild_war_util:create_crystal_timer(Now),
    NewState = State#st_guild_war{war_state = ?GUILD_WAR_STATE_START, end_time = Now + LastTime, ref = Ref, p_dict = dict:new(), pos_list = Position},
%%     notice_sys:add_notice(guild_war_start, []),
    {noreply, NewState};

%%仙盟战结束
handle_info({close}, State) ->
    util:cancel_ref([State#st_guild_war.ref]),
    guild_war_util:cancel_crystal_timer(State#st_guild_war.pos_list),
    {ok, Bin} = pt_410:write(41001, {?GUILD_WAR_STATE_APPLY, 0}),
    server_send:send_to_all(Bin),
    %%结算
    PDict = guild_war_finish(State#st_guild_war.g_dict, State#st_guild_war.p_dict),
    erlang:send_after(5000, self(), {clean, State#st_guild_war.p_dict}),
    Dict = guild_war_util:auto_apply(),
    Now = util:unixtime(),
    NowSec = util:get_seconds_from_midnight(Now),
    StartTime = ?GUILD_WAR_START_TIME,
    NewState = State#st_guild_war{war_state = ?GUILD_WAR_STATE_APPLY, end_time = util:unixtime() + ?ONE_DAY_SECONDS - NowSec + StartTime, g_dict = Dict, p_dict = PDict},
    {noreply, NewState};

%%清除工会战数据--譬如踢人
handle_info({clean, MbDict}, State) ->
    guild_war_util:clean_scene(MbDict),
    {noreply, State};

%%刷新资源
handle_info({refresh_crystal, Id}, State) ->
    NewPosList = guild_war_util:refresh_crystal(Id, State#st_guild_war.pos_list),
    update_crystal_list(NewPosList),
    {noreply, State#st_guild_war{pos_list = NewPosList}};

handle_info({refresh_notice, Id}, State) ->
    guild_war_util:refresh_crystal_notice(Id, State#st_guild_war.pos_list),
    {noreply, State};

%%采集到资源
handle_info({collect, Mid, Id, Pkey, MonPid}, State) ->
    case lists:keyfind(Id, #base_guild_war_crystal.id, State#st_guild_war.pos_list) of
        false ->
            {noreply, State};
        Base ->
            NewBase = Base#base_guild_war_crystal{state = 0},
            PosList = lists:keyreplace(Id, #base_guild_war_crystal.id, State#st_guild_war.pos_list, NewBase),
            {Pdict, GDict} = collect(Mid, Pkey, State#st_guild_war.p_dict, State#st_guild_war.g_dict),
            CollectList = lists:keydelete(MonPid, 1, State#st_guild_war.collect_list),
            NewState = State#st_guild_war{pos_list = PosList, p_dict = Pdict, g_dict = GDict, collect_list = CollectList},
            spawn(fun() ->
                update_to_client(NewState),
                update_crystal_list(PosList)
                  end),
            {noreply, NewState}
    end;


%%仙盟战玩家死亡
handle_info({role_die, _Pkey, AttackerKey, X, Y}, State) ->
    %%击杀加分
    Dict1 = kill(AttackerKey, State#st_guild_war.p_dict),
    %%助攻加分
    KeyList = scene_agent:get_area_scene_pkeys(?SCENE_ID_GUILD_WAR, 0, X, Y),
    Dict2 = assists(lists:delete(AttackerKey, KeyList), _Pkey, Dict1),
    NewState = State#st_guild_war{p_dict = Dict2},
    spawn(fun() -> update_to_client(NewState) end),
    {noreply, NewState};

handle_info(_msg, State) ->
    {noreply, State}.

%%报名分配势力
apply_match_group(GDict) ->
    F = fun(Group) ->
        Filter = dict:filter(fun(_, Apply) -> Apply#guild_war.group == Group end, GDict),
        {Group, dict:size(Filter)}
        end,
    List = lists:map(F, data_guild_war_position:group_list()),
    {Match, _} = hd(lists:keysort(2, List)),
    Match.


%%击杀玩家
kill(Pkey, Dict) ->
    case dict:is_key(Pkey, Dict) of
        false ->
            Dict;
        true ->
            Contrib = data_guild_war_contrib:contrib(4),
            Mb = dict:fetch(Pkey, Dict),
            NewContrib = guild_war_figure:add_contrib(Pkey, Mb#g_war_mb.figure, Contrib, 3),
            NewMb = Mb#g_war_mb{contrib = Mb#g_war_mb.contrib + NewContrib, kill_count = Mb#g_war_mb.kill_count + 1},
            dict:store(Pkey, NewMb, Dict)
    end.
%%助攻
assists(KeyList, Pkey, Dict) ->
    Contrib = data_guild_war_contrib:contrib(5),
    F = fun(Key, D) ->
        case dict:is_key(Key, D) of
            false -> D;
            true ->
                if Key == Pkey -> D;
                    true ->
                        Mb = dict:fetch(Key, D),
                        NewContrib = guild_war_figure:add_contrib(Key, Mb#g_war_mb.figure, Contrib, 2),
                        NewMb = Mb#g_war_mb{contrib = Mb#g_war_mb.contrib + NewContrib, assists_count = Mb#g_war_mb.assists_count + 1},
                        dict:store(Key, NewMb, Dict)
                end
        end
        end,
    lists:foldl(F, Dict, KeyList).

%%采集收益
collect(Mid, Pkey, Pdict, GDict) ->
    case dict:is_key(Pkey, Pdict) of
        false ->
            {Pdict, GDict};
        true ->
            Contrib =
                case Mid of
                    11407 ->
                        data_guild_war_contrib:contrib(3);
                    11406 ->
                        data_guild_war_contrib:contrib(2);
                    _ ->
                        data_guild_war_contrib:contrib(1)
                end,
            Mb = dict:fetch(Pkey, Pdict),
            NewContrib = guild_war_figure:add_contrib(Pkey, Mb#g_war_mb.figure, Contrib, 1),
            CollectCount =
                case lists:keyfind(Mid, 1, Mb#g_war_mb.collect_count) of
                    false -> [{Mid, 1} | Mb#g_war_mb.collect_count];
                    {_, N} ->
                        lists:keyreplace(Mid, 1, Mb#g_war_mb.collect_count, {Mid, N + 1})
                end,
            NewMb = Mb#g_war_mb{contrib = Mb#g_war_mb.contrib + NewContrib, collect_contrib = Mb#g_war_mb.collect_contrib + NewContrib, collect_count = CollectCount},
            NewPdict = dict:store(Pkey, NewMb, Pdict),
            NewGDict = add_res(Mb#g_war_mb.gkey, GDict, Mid),
            {NewPdict, NewGDict}
    end.

%%增加仙盟资源
add_res(Key, Dict, Mid) ->
    case dict:is_key(Key, Dict) of
        false -> Dict;
        true ->
            Res = data_guild_war_contrib:contrib(Mid),
            G = dict:fetch(Key, Dict),
            NewG = G#guild_war{resource = G#guild_war.resource + Res},
            dict:store(Key, NewG, Dict)
    end.

%%水晶位置信息
crystal_list(PosList) ->
    Now = util:unixtime(),
    F = fun(Base) ->
        if Base#base_guild_war_crystal.state == 1 ->
            [];
            true ->
                case [T || T <- Base#base_guild_war_crystal.refresh_time, T > Now] of
                    [] -> [];
                    [Time | _] ->
                        [[Base#base_guild_war_crystal.mon_id, Base#base_guild_war_crystal.x, Base#base_guild_war_crystal.y, 0, Time - Now]]
                end
        end
        end,
    Data = lists:flatmap(F, PosList),
    {ok, Bin} = pt_410:write(41015, {Data}),
    Bin.


%%水晶刷新信息
crystal_refresh_list(PosList) ->
    Now = util:unixtime(),
    F = fun(Base) ->
        if Base#base_guild_war_crystal.type == ?CRYSTAL_TYPE_HIGH orelse Base#base_guild_war_crystal.type == ?CRYSTAL_TYPE_MID ->
            if Base#base_guild_war_crystal.state == 1 ->
                [[Base#base_guild_war_crystal.mon_id, Base#base_guild_war_crystal.x, Base#base_guild_war_crystal.y, 1, 0]];
                true ->

                    case [T || T <- Base#base_guild_war_crystal.refresh_time, T > Now] of
                        [] -> [];
                        [Time | _] ->
                            [[Base#base_guild_war_crystal.mon_id, Base#base_guild_war_crystal.x, Base#base_guild_war_crystal.y, 0, Time - Now]]
                    end
            end;
            true -> []
        end
        end,
    Data = lists:flatmap(F, lists:keysort(#base_guild_war_crystal.type, PosList)),
    {ok, Bin} = pt_410:write(41016, {Data}),
    Bin.

%%更新水晶信息
update_crystal_list(PosList) ->
    Bin = crystal_list(PosList),
    server_send:send_to_scene(?SCENE_ID_GUILD_WAR, Bin),
    Bin1 = crystal_refresh_list(PosList),
    server_send:send_to_scene(?SCENE_ID_GUILD_WAR, Bin1),
    ok.


%%更新到客户端
update_to_client(State) ->
    Now = util:unixtime(),
    TimeLeft = max(0, State#st_guild_war.end_time - Now),
    KeyList = scene_agent:get_scene_player_key_pid(?SCENE_ID_GUILD_WAR, 0),
    ResList = calc_resource(State#st_guild_war.g_dict),
    F = fun({Pkey, Pid}) ->
        case dict:is_key(Pkey, State#st_guild_war.p_dict) of
            false ->
                skip;
            true ->
                Mb = dict:fetch(Pkey, State#st_guild_war.p_dict),
                Collect = [tuple_to_list(Item) || Item <- Mb#g_war_mb.collect_count],
                CmdCd =
                    case lists:keyfind(Mb#g_war_mb.group, 1, State#st_guild_war.cmd_cd) of
                        false -> 0;
                        {_, LastTime} ->
                            ?IF_ELSE(Now > LastTime, 0, LastTime - Now)
                    end,
                Data = {Mb#g_war_mb.is_cmd, CmdCd, TimeLeft, Mb#g_war_mb.figure, Mb#g_war_mb.contrib, Mb#g_war_mb.kill_count, Mb#g_war_mb.assists_count, Collect, ResList},
                {ok, Bin} = pt_410:write(41009, Data),
                server_send:send_to_pid(Pid, Bin)
        end
        end,
    lists:foreach(F, KeyList),
    ok.

%%计算仙盟势力分组资源值
calc_resource(Dict) ->
    F = fun(Group) ->
        GroupDict = dict:filter(fun(_, G) -> G#guild_war.group == Group end, Dict),
        Res = lists:sum([G#guild_war.resource || {_, G} <- dict:to_list(GroupDict)]),
        [Group, Res]
        end,
    lists:map(F, data_guild_war_position:group_list()).


%%检查指挥进攻CD
check_cmd_cd(Group, CdList, NowTime) ->
    case lists:keyfind(Group, 1, CdList) of
        false ->
            true;
        {_, LastTime} ->
            NowTime > LastTime
    end.

%%计算排名

%%积分排名
calc_mb_rank(1, PDict) ->
    PList = lists:keysort(#g_war_mb.contrib, [Mb || {_, Mb} <- dict:to_list(PDict)]),
    F = fun(Mb, {List, RankId}) ->
        {[Mb#g_war_mb{rank_id = RankId, rank_val = Mb#g_war_mb.contrib} | List], RankId + 1}
        end,
    {NewPList, _} = lists:foldl(F, {[], 1}, lists:reverse(PList)),
    lists:reverse(NewPList);
%%击杀排名
calc_mb_rank(2, PDict) ->
    PList = lists:keysort(#g_war_mb.kill_count, [Mb || {_, Mb} <- dict:to_list(PDict)]),
    F = fun(Mb, {List, RankId}) ->
        {[Mb#g_war_mb{rank_id = RankId, rank_val = Mb#g_war_mb.kill_count} | List], RankId + 1}
        end,
    {NewPList, _} = lists:foldl(F, {[], 1}, lists:reverse(PList)),
    lists:reverse(NewPList);
%%采集排名
calc_mb_rank(3, PDict) ->
    PList = lists:keysort(#g_war_mb.collect_contrib, [Mb || {_, Mb} <- dict:to_list(PDict)]),
    F = fun(Mb, {List, RankId}) ->
        {[Mb#g_war_mb{rank_id = RankId, rank_val = Mb#g_war_mb.collect_contrib} | List], RankId + 1}
        end,
    {NewPList, _} = lists:foldl(F, {[], 1}, lists:reverse(PList)),
    lists:reverse(NewPList);
calc_mb_rank(_, _PDict) ->
    [].


%%仙盟战结算
guild_war_finish(GDict, PDict) ->
    [guild_util:reset_guild_war_data(GKey) || GKey <- dict:fetch_keys(GDict)],
    GroupList = lists:reverse(lists:keysort(2, [list_to_tuple(Item) || Item <- calc_resource(GDict)])),
    PList = calc_mb_rank(1, PDict),

    {Title, Content} = t_mail:mail_content(4),
    Now = util:unixtime(),
    F = fun({Group, _}, {RankId, D}) ->
        MbList = [Mb || Mb <- PList, Mb#g_war_mb.group == Group],
        get_title(GDict, Group, RankId, MbList),
        NewD = send_reward(MbList, 1, RankId, Title, Content, Now, D),
        {RankId + 1, NewD}
        end,
    {_, NewPDict} = lists:foldl(F, {1, PDict}, GroupList),
    _PList2 = calc_mb_rank(2, PDict),
    _PList3 = calc_mb_rank(3, PDict),
%%    spawn(fun() -> single_title([{1, PList}, {2, PList2}, {3, PList3}]) end),
    NewPDict.

send_reward([], _Rank, _GroupRank, _Title, _Content, _Now, Dict) -> Dict;
send_reward([Mb | T], Rank, GroupRank, Title, Content, Now, Dict) ->
    Exploit = round(40 * math:pow(Mb#g_war_mb.contrib, 1 / 2)),
    GroupGoodsList = get_group_reward(GroupRank, Rank),
    ExtraGoods = [],
    ActivityGoods = data_activity_dun_drop:get(10),
    spawn(fun() -> util:sleep(Rank * 100),
        NewContent = io_lib:format(Content, [GroupRank, Rank]),
        mail:sys_send_mail([Mb#g_war_mb.pkey], Title, NewContent, GroupGoodsList ++ ExtraGoods ++ ActivityGoods) end),
    IsNew = is_new_record(Mb#g_war_mb.pkey, Mb#g_war_mb.contrib),
    NewMb = Mb#g_war_mb{exploit = Exploit, is_new = IsNew, goods_list = GroupGoodsList},
    NewDict = dict:store(Mb#g_war_mb.pkey, NewMb, Dict),
    {ok, Bin} = pt_410:write(41014, {Mb#g_war_mb.contrib, IsNew, Mb#g_war_mb.rank_id, Exploit, [tuple_to_list(Item) || Item <- GroupGoodsList]}),
    server_send:send_to_key(Mb#g_war_mb.pkey, Bin),
    guild_war_load:log_guild_war(Mb#g_war_mb.pkey, Mb#g_war_mb.nickname, Mb#g_war_mb.gkey, Mb#g_war_mb.gname, Mb#g_war_mb.contrib, Mb#g_war_mb.group, GroupRank, Rank, GroupGoodsList ++ ExtraGoods, Now),
    send_reward(T, Rank + 1, GroupRank, Title, Content, Now, NewDict).

%%获得称号
get_title(GDict, Group, RankId, MbList) when RankId == 1 ->
    case [G || {_, G} <- dict:to_list(GDict), G#guild_war.group == Group] of
        [] -> skip;
        GuildList ->
            _TitleId = 4014,
            GWar = hd(lists:keysort(#guild_war.time, GuildList)),
            case guild_ets:get_guild(GWar#guild_war.gkey) of
                false -> skip;
                _Guild ->
                    case MbList of
                        [] -> skip;
                        [_M | _] -> skip
%%                             notice_sys:add_notice(guild_war_finish, [M#g_war_mb.nickname, Guild#guild.name, GWar#guild_war.group])
                    end
            end,
            ok
    end;
get_title(_, _, _, _) -> skip.

single_title([]) -> skip;
single_title([{_Type, _PList} | T]) ->
    single_title(T).

%%是否新纪录
is_new_record(Pkey, Contrib) ->
    case guild_ets:get_guild_member(Pkey) of
        false -> 0;
        Mb ->
            if Mb#g_member.h_war_p < Contrib ->
                NewMb = Mb#g_member{war_p = Contrib, h_war_p = Contrib},
                guild_ets:set_guild_member(NewMb),
%%                guild_load:replace_guild_member(NewMb),
                1;
                true ->
                    NewMb = Mb#g_member{war_p = Contrib},
                    guild_ets:set_guild_member(NewMb),
%%                    guild_load:replace_guild_member(NewMb),
                    0
            end
    end.

%%获取势力排名奖励
get_group_reward(GroupRank, RankId) ->
    RankList = data_guild_war_reward:group_rank(GroupRank),
    %% [[1,15,1001015],[16,40,1016040],[41,0,1041000]];
    F = fun([MaxRank, MinRank, Id]) ->
        if RankId >= MaxRank andalso (RankId =< MinRank orelse MinRank == 0) ->
            [Id];
            true -> []
        end
        end,
    case lists:flatmap(F, RankList) of
        [] ->
            [];
        Ids ->
            data_guild_war_reward:get(hd(Ids))
    end.

%%
%%%%贡献换算成功勋
%%%%a1=1;a2=0.8;a3=0.6;a4=0.3;a5=0.1
%%contrib_to_exploit(Contribute) ->
%%    A1 = 1, A2 = 0.8, A3 = 0.6, A4 = 0.3, A5 = 0.1,
%%    Val = if Contribute < 1000 -> A1 * 1000;
%%              Contribute >= 1000 andalso Contribute < 2000 ->
%%                  1000 * A1 + (Contribute - 1000) * A2;
%%              Contribute >= 2000 andalso Contribute < 3000 ->
%%                  1000 * (A1 + A2) + (Contribute - 2000) * A3;
%%              Contribute >= 3000 andalso Contribute < 4000 ->
%%                  1000 * (A1 + A2 + A3) + (Contribute - 3000) * A4;
%%              true ->
%%                  1000 * (A1 + A3 + A3 + A4) + (Contribute - 4000) * A5
%%          end,
%%    round(Val).
%%
%%rank_contrib(Rank) ->
%%    if Rank =< 1 -> 800;
%%        Rank =< 3 -> 600;
%%        Rank =< 10 -> 500;
%%        Rank =< 20 -> 400;
%%        Rank =< 50 -> 300;
%%        Rank =< 100 -> 200;
%%        true -> 100
%%    end.