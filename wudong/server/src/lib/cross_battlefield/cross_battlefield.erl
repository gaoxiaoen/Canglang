%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 五月 2016 14:37
%%%-------------------------------------------------------------------
-module(cross_battlefield).
-author("hxming").

-include("common.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("cross_battlefield.hrl").
%% API
-compile(export_all).

%%检查活动状态
check_state(Node, Sid, Now) ->
    ?CAST(cross_battlefield_proc:get_server_pid(), {check_state, Node, Sid, Now}),
    ok.

%%检查进入
check_enter(Mb) ->
    ?CAST(cross_battlefield_proc:get_server_pid(), {check_enter, Mb}),
    ok.

%%退出
check_quit(Pkey, Type) ->
    ?CAST(cross_battlefield_proc:get_server_pid(), {check_quit, Pkey, Type}),
    ok.

%%战场统计
check_info(Pkey) ->
    ?CAST(cross_battlefield_proc:get_server_pid(), {check_info, Pkey}),
    ok.

%%离线
logout(Player) ->
    case scene:is_cross_battlefield_scene(Player#player.scene) of
        false ->
            skip;
        true ->
            cross_area:apply(cross_battlefield, check_quit, [Player#player.key, logout])
    end.

%%检查是否跳层
check_layer(Pkey, Rtype) ->
    ?CAST(cross_battlefield_proc:get_server_pid(), {check_layer, Pkey, Rtype}),
    ok.

%%排行榜
check_rank(Node, Pkey, Sid, Page) ->
    ?CAST(cross_battlefield_proc:get_server_pid(), {check_rank, Node, Pkey, Sid, Page}),
    ok.

%%玩家被击杀
role_die(SceneId, Copy, DieKey, KillerKey) ->
    cross_area:apply(cross_battlefield, check_die, [SceneId, Copy, DieKey, KillerKey]),
    ok.

check_die(SceneId, Copy, DieKey, KillerKey) ->
    ?CAST(cross_battlefield_proc:get_server_pid(), {kill, SceneId, Copy, DieKey, KillerKey}),
    ok.

%%buff碰撞
crash_buff(Node, Pid, Sid, Mkey, SceneId, Copy, X, Y) ->
    ?CAST(cross_battlefield_proc:get_server_pid(), {crash_buff, Node, Pid, Sid, Mkey, SceneId, Copy, X, Y}),
    ok.


%%计算怪物
kill_mon(Mon, Pkey) ->
    case scene:is_cross_battlefield_scene(Mon#mon.scene) of
        false -> skip;
        true ->
            if Mon#mon.kind == ?MON_KIND_CROSS_BATTLEFIELD_MON andalso Pkey /= 0 ->
                    catch ?CAST(cross_battlefield_proc:get_server_pid(), {check_kill_mon, Mon#mon.scene, Pkey});
                true -> ok
            end
    end.

%%采集宝箱
collect_box(Mon, Pkey) ->
    case scene:is_cross_battlefield_scene(Mon#mon.scene) of
        false -> skip;
        true ->
                catch ?CAST(cross_battlefield_proc:get_server_pid(), {check_collect_box, Pkey, Mon#mon.copy})
    end.


make_mb(Player) ->
    #cross_bf_mb{
        node = node(),
        pf = Player#player.pf,
        sn = Player#player.sn,
        pkey = Player#player.key,
        pid = Player#player.pid,
        sid = Player#player.sid,
        nickname = Player#player.nickname,
        career = Player#player.career,
        sex = Player#player.sex,
        vip = Player#player.vip_lv,
        cbp = Player#player.cbp,
        layer = 1,
        layer_h = 1,
        score = 0
    }.

%%重新计算积分,退出会扣除积分的
calc_score_for_quit(Score, Layer, QuitTime) ->
    if QuitTime == 0 -> Score;
        true ->
            Now = util:unixtime(),
            max(0, Score - util:ceil((Now - QuitTime) / 30) * data_cross_battlefield:quit_score(Layer))
    end.


max_layer() ->
    lists:max(data_cross_battlefield:ids()).


%%升级所需击杀数
upgrade_kill(Layer) -> data_cross_battlefield:up_layer_kill(Layer).

%%分配线路
match_copy(Layer, Dict) ->
    Filter = dict:filter(fun(_Key, Mb) ->
        Mb#cross_bf_mb.layer == Layer andalso Mb#cross_bf_mb.pid =/= none end, Dict),
    F = fun({_, Mb}, L) ->
        case lists:keytake(Mb#cross_bf_mb.copy, 1, L) of
            false -> [{Mb#cross_bf_mb.copy, 1} | L];
            {value, {Copy, Count}, T} ->
                [{Copy, Count + 1} | T]
        end
        end,
    CopyList = lists:foldl(F, [], dict:to_list(Filter)),
    case lists:keysort(2, CopyList) of
        [] ->
            NewCopy = Layer * 100,
            SceneId = data_cross_battlefield:scene(Layer),
            scene_init:create_scene(SceneId, NewCopy),
            self() ! {refresh_mon_layer, Layer, NewCopy},
            NewCopy;
        CopyList1 ->
            case [Copy || {Copy, Count} <- CopyList1, Count < ?CROSS_BATTLEFIELD_COPY_NUM] of
                [] ->
                    NewCopy = lists:max([Copy || {Copy, _} <- CopyList1]) + 1,
                    SceneId = data_cross_battlefield:scene(Layer),
                    scene_init:create_scene(SceneId, NewCopy),
                    self() ! {refresh_mon_layer, Layer, NewCopy},
                    NewCopy;
                CopyList2 ->
                    hd(CopyList2)
            end
    end.

%%刷新线路怪物
refresh_mon_layer(Layer, Copy) ->
    case data_cross_battlefield:scene(Layer) of
        [] -> [];
        SceneId ->
            F = fun({Mid, X, Y}) ->
                mon_agent:create_mon_cast([Mid, SceneId, X, Y, Copy, 1, []])
                end,
            lists:foreach(F, data_cross_battlefield:mon_list(Layer))
    end.


%%刷新线路buff怪物
refresh_buff_layer(Layer, Copy) ->
    case data_cross_battlefield:scene(Layer) of
        [] -> [];
        SceneId ->
            case data_cross_battlefield:buff_list(SceneId) of
                [] ->
                    [];
                BuffIds ->
                    F = fun({X, Y}) ->
                        Mid = util:list_rand(BuffIds),
                        {Mkey, Mpid} = mon_agent:create_mon([Mid, SceneId, X, Y, Copy, 1, [{return_id_pid, true}]]),
                        {Mkey, Mpid, Mid, SceneId, Copy, X, Y}
                        end,
                    lists:map(F, data_cross_battlefield:buff_pos_list(Layer))
            end
    end.

%%刷新顶层宝箱
refresh_top_layer_box(Layer, Copyist) ->
    case data_cross_battlefield:scene(Layer) of
        [] -> [];
        SceneId ->
            [Mid, X, Y] = data_cross_battlefield_top:mon_list(),
            F = fun(Copy) ->
                mon_agent:create_mon_cast([Mid, SceneId, X, Y, Copy, 1, []])
                end,
            lists:foreach(F, Copyist)
    end.

%%获取战场出生点
get_revive(Layer) ->
    case data_cross_battlefield:revive(Layer) of
        [] ->
            Sid = data_cross_battlefield:scene(Layer),
            Scene = data_scene:get(Sid),
            {Scene#scene.x, Scene#scene.y};
        List ->
            util:list_rand(List)
    end.

%%目标奖励
target_reward_msg(Pkey, Score, GoodsList) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
            {Title, Content} = t_mail:mail_content(63),
            Content1 = io_lib:format(Content, [Score]),
            mail:sys_send_mail([Pkey], Title, Content1, GoodsList);
        [OnLine] ->
            OnLine#ets_online.pid ! {cross_bf_target_reward_msg, Score, GoodsList}
    end.

target_reward_msg_online(State, Score, GoodsList) ->
    {ok, Bin} = pt_550:write(55008, {Score, goods:pack_goods(GoodsList)}),
    server_send:send_to_sid(State#player.sid, Bin),
    goods:give_goods(State, goods:make_give_goods_list(85, GoodsList)).

%%进入奖励
enter_reward_msg(Pkey, Layer, GoodsList) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
            {Title, Content} = t_mail:mail_content(64),
            Content1 = io_lib:format(Content, [Layer]),
            mail:sys_send_mail([Pkey], Title, Content1, GoodsList);
        [OnLine] ->
            OnLine#ets_online.pid ! {cross_bf_enter_reward_msg, Layer, GoodsList}
    end.

enter_reward_msg_online(State, Layer, GoodsList) ->
    {ok, Bin} = pt_550:write(55009, {Layer, goods:pack_goods(GoodsList)}),
    server_send:send_to_sid(State#player.sid, Bin),
    goods:give_goods(State, goods:make_give_goods_list(85, GoodsList)).


%%宝箱奖励
box_reward_msg(Pkey, GoodsList) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
            {Title, Content} = t_mail:mail_content(65),
            mail:sys_send_mail([Pkey], Title, Content, GoodsList);
        [OnLine] ->
            OnLine#ets_online.pid ! {cross_bf_box_reward_msg, GoodsList}
    end.

box_reward_msg_online(State, GoodsList) ->
    {ok, Bin} = pt_550:write(55010, {goods:pack_goods(GoodsList)}),
    server_send:send_to_sid(State#player.sid, Bin),
    goods:give_goods(State, goods:make_give_goods_list(85, GoodsList)).


%%首位登顶
first_reward_msg(Pkey, GoodsList) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
            {Title, Content} = t_mail:mail_content(66),
            mail:sys_send_mail([Pkey], Title, Content, GoodsList);
        [OnLine] ->
            OnLine#ets_online.pid ! {cross_bf_first_reward_msg, GoodsList}
    end.

first_reward_msg_online(State, GoodsList) ->
    {ok, Bin} = pt_550:write(55011, {goods:pack_goods(GoodsList)}),
    server_send:send_to_sid(State#player.sid, Bin),
    goods:give_goods(State, goods:make_give_goods_list(85, GoodsList)).

%%奖励信息
reward_msg(Pkey, Nickname, Rank, _Layer, Score, GoodsList) ->
    {Title, Content} = t_mail:mail_content(38),
    Content1 = io_lib:format(Content, [Score, Rank]),
    mail:sys_send_mail([Pkey], Title, Content1, GoodsList),
    log_cross_battlefield(Pkey, Nickname, Score, Rank, GoodsList, util:unixtime()),
    case data_cross_battlefield_reward:get_des(Rank) of
        0 -> ok;
        DesId ->
            designation_proc:add_des(DesId, [Pkey])
    end,
%%    {ok, Bin} = pt_550:write(55006, {Score, Rank, Layer, goods:pack_goods(GoodsList)}),
%%    server_send:send_to_key(Pkey, Bin),
    ok.

get_reward_list(Rank) ->
    case data_cross_battlefield_reward:get(Rank) of
        [] -> [];
        GoodsList -> tuple_to_list(GoodsList)
    end.


log_cross_battlefield(Pkey, Nickname, Score, Rank, Goods, Time) ->
    Sql = io_lib:format(<<"insert into log_cross_battlefield set pkey = ~p,nickname = '~s',score=~p,rank=~p,goods='~s',time=~p">>,
        [Pkey, Nickname, Score, Rank, util:term_to_bitstring(Goods), Time]),
    log_proc:log(Sql).


notice() ->
%%     F = fun(Node) ->
%%         center:apply(Node, notice_sys, add_notice, [cross_battlefield_notice, []])
%%         end,
%%     lists:foreach(F, center:get_nodes()).
    ok.

