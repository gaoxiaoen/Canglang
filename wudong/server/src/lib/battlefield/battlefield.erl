%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 三月 2016 17:07
%%%-------------------------------------------------------------------
-module(battlefield).
-author("hxming").

-include("server.hrl").
-include("battlefield.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("common.hrl").

%% API
-compile(export_all).

%%检查状态
check_state(Node, Sid, Now) ->
    ?CAST(battlefield_proc:get_server_pid(), {check_state, Node, Sid, Now}),
    ok.


%%玩家离线
logout(Player) ->
    case scene:is_battlefield_scene(Player#player.scene) of
        false -> skip;
        true ->
            cross_area:apply(battlefield, check_logout, [Player#player.key])
    end.

check_logout(Pkey) ->
    ?CAST(battlefield_proc:get_server_pid(), {check_logout, Pkey}),
    ok.

make_mb(Player) ->
    #bf_mb{
        sn = config:get_server_num(),
        node = node(),
        pkey = Player#player.key,
        pid = Player#player.pid,
        sid = Player#player.sid,
        nickname = Player#player.nickname,
        vip = Player#player.vip_lv,
        gname = Player#player.guild#st_guild.guild_name,
        cbp = Player#player.highest_cbp,%
        is_online = 1
    }.

%%战场预报名
check_apply(Mb) ->
    ?CAST(battlefield_proc:get_server_pid(), {check_apply, Mb}),
    ok.

%%检查进入
check_enter(Mb) ->
    ?CAST(battlefield_proc:get_server_pid(), {check_enter, Mb}),
    ok.

%%退出战场
check_quit(Pkey) ->
    ?CAST(battlefield_proc:get_server_pid(), {check_quit, Pkey}),
    ok.

%%战场信息
check_info(Node, Pkey, Sid) ->
    ?CAST(battlefield_proc:get_server_pid(), {check_info, Node, Pkey, Sid}),
    ok.

%%积分前十
check_top_ten(Node, Sid) ->
    ?CAST(battlefield_proc:get_server_pid(), {check_top_ten, Node, Sid}),
    ok.

%%排行榜
check_rank(Node, Sid, Type, Page) ->
    ?CAST(battlefield_proc:get_server_pid(), {check_rank, Node, Sid, Type, Page}),
    ok.

%%查看宝箱信息
check_box(Node, Sid, Copy) ->
    ?CAST(battlefield_proc:get_server_pid(), {check_box, Node, Sid, Copy}),
    ok.

%%查询技能CD信息
get_skill_cd(Pkey) ->
    SkillId = data_battlefield:skill_id(),
    Cd =
        case ets:lookup(?ETS_BF_SKILL, Pkey) of
            [] -> 0;
            [Skill] ->
                Now = util:unixtime(),
                NextTime = Skill#bf_skill.skill_cd + data_battlefield:skill_cd(),
                if Skill#bf_skill.skill_cd == 0 -> 0;
                    NextTime < Now -> 0;
                    true ->
                        NextTime - Now
                end
        end,
    {SkillId, Cd}.

%%检查技能CD
check_skill_cd(Pkey, Sid, SceneId, Now) ->
    if SceneId /= ?SCENE_ID_BATTLEFIELD -> false;
        true ->
            case ets:lookup(?ETS_BF_SKILL, Pkey) of
                [] ->
                    NewSkill = #bf_skill{pkey = Pkey, skill_cd = Now},
                    ets:insert(?ETS_BF_SKILL, NewSkill),
                    {ok, Bin} = pt_640:write(64009, {data_battlefield:skill_id(), data_battlefield:skill_cd()}),
                    server_send:send_to_sid(Sid, Bin),
                    true;
                [Skill] ->
                    Cd = data_battlefield:skill_cd(),
                    if Skill#bf_skill.skill_cd + Cd < Now ->
                        NewSkill = Skill#bf_skill{skill_cd = Now},
                        ets:insert(?ETS_BF_SKILL, NewSkill),
                        {ok, Bin} = pt_640:write(64009, {data_battlefield:skill_id(), data_battlefield:skill_cd()}),
                        server_send:send_to_sid(Sid, Bin),
                        true;
                        true ->
                            false
                    end
            end
    end.

%%清除技能CD
clean_bf_skill() ->
    ets:delete_all_objects(?ETS_BF_SKILL).

%%buff检查
check_buff(Pkey) ->
    ?CAST(battlefield_proc:get_server_pid(), {check_buff, Pkey}),
    ok.

%%计算是否在势力点内
in_group_position(Group, X, Y) ->
    case data_battlefield_position:get(Group) of
        [] -> false;
        [{X1, Y1}, {X2, Y2} | _] ->
            X >= X1 andalso X =< X2 andalso Y >= Y1 andalso Y =< Y2
    end.

%%获取势力点
get_position(Group) ->
    case data_battlefield_position:get(Group) of
        [] ->
            Scene = data_scene:get(?SCENE_ID_BATTLEFIELD),
            {Scene#scene.x, Scene#scene.y};
        [{X1, Y1}, {X2, Y2} | _] ->
            {util:rand(X1, X2), util:rand(Y1, Y2)}
    end.


%%势力点回血
recovery_hp(Player) ->
    case scene:is_battlefield_scene(Player#player.scene) of
        false -> Player;
        true ->
            case in_group_position(Player#player.group, Player#player.x, Player#player.y) of
                true ->
                    if Player#player.hp > 0 andalso Player#player.hp < Player#player.attribute#attribute.hp_lim div 2 ->
                        Rhp = round(Player#player.attribute#attribute.hp_lim * 0.1),
                        Hp = min(Player#player.attribute#attribute.hp_lim div 2, Player#player.hp + Rhp),
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


%%击杀玩家
kill(Player, Attacker) ->
    cross_area:apply(battlefield, check_kill, [Player#player.key, Attacker#attacker.key, Player#player.copy, Player#player.x, Player#player.y, Attacker#attacker.sign]),
    ok.

check_kill(Pkey, AttKey, Copy, X, Y, Sign) ->
    ?CAST(battlefield_proc:get_server_pid(), {kill, Pkey, AttKey, Copy, X, Y, Sign}),
    ok.


%%采集
collect(Mon, Pkey) ->
    ?CAST(battlefield_proc:get_server_pid(), {collect, Pkey, Mon#mon.pid, Mon#mon.copy}).


%%刷新资源定时器
create_box_timer(Now) ->
    F = fun(Id) ->
        Base = data_battlefield_box:get(Id),
        {RefreshTime, RefList, NrefList} = set_timer(Id, Base#base_battlefield_box.refresh_time, Now),
        Base#base_battlefield_box{id = Id, ref = RefList, notice_ref = NrefList, refresh_time = lists:sort(RefreshTime)}
        end,
    lists:map(F, data_battlefield_box:ids()).

set_timer(Id, RefreshTime, Now) ->
    F1 = fun(Time, {TList, RList, NList}) ->
        TimerHandle = erlang:send_after(Time * 1000, self(), {refresh_box, Id}),
        NoticeTimer = 30,
        if Time < NoticeTimer ->
            {[Time + Now | TList], [TimerHandle | RList], NList};
            true ->
                TimerHandle1 = erlang:send_after((Time - 30) * 1000, self(), {refresh_notice, Id}),
                {[Time + Now | TList], [TimerHandle | RList], [TimerHandle1 | NList]}

        end
         end,
    lists:foldl(F1, {[], [], []}, RefreshTime).

cancel_box_timer(BoxList) ->
    [util:cancel_ref(Base#base_battlefield_box.ref) || Base <- BoxList],
    [util:cancel_ref(Base#base_battlefield_box.notice_ref) || Base <- BoxList].

%%创建防守怪
create_def_mon(Copy) ->
    F = fun(Group) ->
        case data_battlefield_def:get(Group) of
            [] -> skip;
            MonList ->
                [mon_agent:create_mon_cast([MonId, ?SCENE_ID_BATTLEFIELD, X, Y, Copy, 1, [{group, Group}]]) || {MonId, X, Y} <- MonList]

        end
        end,
    lists:foreach(F, data_battlefield_position:group_list()).

%%创建buff怪
create_buff_mon(Copy) ->
    F = fun(Mid) ->
        case data_mon:get(Mid) of
            [] -> skip;
            _ ->
                [X, Y] = data_battlefield_buff:get(Mid),
                mon_agent:create_mon_cast([Mid, ?SCENE_ID_BATTLEFIELD, X, Y, Copy, 1, []])
        end
        end,
    lists:foreach(F, data_battlefield_buff:ids()).

%%刷新资源，同一地点如果存在的话，则不刷新
refresh_box(Id, PosList, CopyList) ->
    case lists:keyfind(Id, #base_battlefield_box.id, PosList) of
        false -> PosList;
        Base ->
            F = fun(Copy) ->
                case lists:keyfind(Copy, 1, Base#base_battlefield_box.pid_list) of
                    false ->
                        Pid = mon_agent:create_mon([Base#base_battlefield_box.mon_id, ?SCENE_ID_BATTLEFIELD, Base#base_battlefield_box.x, Base#base_battlefield_box.y, Copy, 1, [{return_pid, true}]]),
                        {Copy, Pid};
                    {_, Pid} ->
                        case misc:is_process_alive(Pid) of
                            true ->
                                {Copy, Pid};
                            false ->
                                Pid1 = mon_agent:create_mon([Base#base_battlefield_box.mon_id, ?SCENE_ID_BATTLEFIELD, Base#base_battlefield_box.x, Base#base_battlefield_box.y, Copy, 1, [{return_pid, true}]]),
                                {Copy, Pid1}
                        end
                end
                end,
            PidList = lists:map(F, CopyList),
            NewBase = Base#base_battlefield_box{pid_list = PidList},
            lists:keyreplace(Id, #base_battlefield_box.id, PosList, NewBase)
    end.

%%刷新通知
refresh_box_notice(Id, PosList) ->
    case lists:keyfind(Id, #base_battlefield_box.id, PosList) of
        false -> PosList;
        _Base ->
%%             F = fun(Node) ->
%%                 center:apply(Node, notice_sys, add_notice, [battlefield_box, [Base#base_battlefield_box.notice, ?SCENE_ID_BATTLEFIELD, Base#base_battlefield_box.x, Base#base_battlefield_box.y]])
%%                 end,
%%             lists:foreach(F, center:get_nodes())
            skip
    end.


%%场景清玩家
clean_scene(CopyList) ->
    scene_cross:send_out_cross(?SCENE_TYPE_BATTLEFIELD),
    %%杀掉怪物
    [monster:stop_broadcast(Aid) || Aid <- mon_agent:get_scene_mon_pids(?SCENE_ID_BATTLEFIELD)],
    [scene_agent:clean_scene_area(?SCENE_ID_BATTLEFIELD, Copy) || Copy <- CopyList],
    ok.

%%结算奖励信息
reward_msg(Pkey, NickName, Rank, Score, Honor, GoodsList) ->
    {Title, Content} = t_mail:mail_content(28),
    Content1 = io_lib:format(Content, [Rank]),
    mail:sys_send_mail([Pkey], Title, Content1, GoodsList),
    Now = util:unixtime(),
    log_battlefield(Pkey, NickName, Rank, GoodsList, Now),

    case player_util:get_player_pid(Pkey) of
        false ->
            spawn(fun() -> util:sleep(1000),
                battlefield_init:replace(#battlefield{pkey = Pkey, score = Score, rank = Rank, honor = Honor, time = Now})
                  end);
        Pid ->
            Pid ! {battlefield_msg, Score, Rank, Honor, GoodsList}
    end,
    ok.

%%战场结算信息
battlefield_msg(Player, Score, Rank, Honor, GoodsList) ->
    GoodsList1 = [tuple_to_list(Item) || Item <- GoodsList],
    IsNew = battlefield_init:is_new(Score),
    {ok, Bin} = pt_640:write(64008, {Score, IsNew, Rank, Honor, GoodsList1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    battlefield_init:refresh(Score, Rank, Honor),
    ok.

log_battlefield(Pkey, Nickname, Rank, Goods, Time) ->
    Sql = io_lib:format(<<"insert into log_battlefield set pkey = ~p,nickname = '~s',rank=~p,goods='~s',time =~p">>,
        [Pkey, Nickname, Rank, util:term_to_bitstring(Goods), Time]),
    log_proc:log(Sql).
