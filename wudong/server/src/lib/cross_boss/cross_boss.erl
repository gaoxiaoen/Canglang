%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 五月 2016 22:54
%%%-------------------------------------------------------------------
-module(cross_boss).
-author("hxming").

-include("cross_boss.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("common.hrl").
-include("guild.hrl").
%%场景人数限制
-define(CROSS_BOSS_SCENE_LIMIT, 10).

%% API
-compile(export_all).

-export([
    get_act_state/0, %%获取活动状态
    get_word_sn_list/2, %%获取世界服状态
    check_state/2, %%检查活动是否开启
    get_tatal_data/3, %% 数据统计
    get_self_data/3, %% 玩家界面数据
    check_enter/2, %%请求进入跨服boss
    check_quit/1, %% 活动退出
    logout/1, %% 下线逻辑处理
    clean_cross_player/1, %% 清理玩家数据
    get_cross_node_lv/0, %% 世界等级
    recv_score_reward/5, %% 领取积分奖励
    recv_score_reward/2, %% 领取积分奖励
    get_status/3, %% 读取活动状态
    get_state_remain_time/3, %% 剩余时间
    update_player_cross_boss/0, %% 更新玩家掉落归属次数数据
    update_player_data/2, %% 更新玩家数据
    add_player_cross_boss/2, %% 更新玩家掉落归属次数数据
    midnight_refresh/1,  %% 凌晨刷新

    gm_start/0,
    gm_stop/0,
    gm_box_mon/0
]).

get_word_sn_list(Node, Sid) ->
    Now = util:unixtime(),
    Nodes = ets:tab2list(?ETS_KF_NODES),
    F = fun(#ets_kf_nodes{sn_name = SnName0, sn = Sn, type = Type, open_time = Time}) ->
        if Time > Now -> [];
            true ->
                if
                    SnName0 == null ->
                        SnName = ?T("武动九天测试");
                    true ->
                        SnName = SnName0
                end,
                ?IF_ELSE(Type == 0, [[SnName, Sn]], [])
        end
    end,
    LL = lists:flatmap(F, Nodes),
    {ok, Bin} = pt_570:write(57000, {LL}),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    ok.

%%检查活动状态
check_state(Node, Sid) ->
    ?CAST(cross_boss_proc:get_server_pid(), {check_state, Node, Sid}),
    ok.

get_tatal_data(Pkey, Node, Sid) ->
    ?CAST(cross_boss_proc:get_server_pid(), {get_tatal_data, Pkey, Node, Sid}),
    ok.

get_self_data(Pkey, Node, Sid) ->
    ?CAST(cross_boss_proc:get_server_pid(), {get_self_data, Pkey, Node, Sid}),
    ok.

check_state_self(Node, Sid, Now, IsMultiple) ->
    ?CAST(cross_boss_proc:get_server_pid(), {check_state_self, Node, Sid, Now, IsMultiple}),
    ok.

%%检查进入
check_enter(Mb, Layer) ->
    ?CAST(cross_boss_proc:get_server_pid(), {check_enter, Mb, Layer}),
    ok.

%%退出
check_quit(Pkey) ->
    ?CAST(cross_boss_proc:get_server_pid(), {check_quit, Pkey}),
    ok.

%%战场统计
check_info(Node, Pkey, Sid) ->
    ?CAST(cross_boss_proc:get_server_pid(), {check_info, Node, Pkey, Sid}),
    ok.

%%离线
logout(Player) ->
    case scene:is_cross_boss_scene(Player#player.scene) of
        false ->
            skip;
        true ->
            cross_area:apply(cross_boss, check_quit, [Player#player.key])
    end.

update_guild(Mb, MbGuildList) ->
    case lists:keytake(Mb#cb_damage.guild_key, #cb_guild_damage.guild_key, MbGuildList) of
        false ->
            NewMbGuild =
                #cb_guild_damage{
                    guild_key = Mb#cb_damage.guild_key,
                    guild_name = Mb#cb_damage.guild_name,
                    node = Mb#cb_damage.node,
                    player_num = 1,
                    guild_main_name = Mb#cb_damage.guild_main_name
                },
            [NewMbGuild | MbGuildList];
        {value, MbGuild, Rest} ->
            [MbGuild#cb_guild_damage{player_num = MbGuild#cb_guild_damage.player_num + 1} | Rest]
    end.


update_mb(OldMb, Mb, Layer) ->
    OldMb#cb_damage{
        pid = Mb#cb_damage.pid,
        sid = Mb#cb_damage.sid,
        name = Mb#cb_damage.name,
        lv = Mb#cb_damage.lv,
        layer = Layer,
        avatar = Mb#cb_damage.avatar,
        node = Mb#cb_damage.node,
        is_online = Mb#cb_damage.is_online,
        guild_key = Mb#cb_damage.guild_key,
        guild_name = Mb#cb_damage.guild_name,
        guild_main = Mb#cb_damage.guild_main,
        enter_time = Mb#cb_damage.enter_time,
        guild_main_name = Mb#cb_damage.guild_main_name
    }.

%%
make_mb(Player, GuildMember, Guild, StPlayerCrossBoss, Layer) ->
    #cb_damage{
        sn = Player#player.sn,
        sn_name = Player#player.sn_name,
        key = Player#player.key,
        pid = Player#player.pid,
        sid = Player#player.sid,
        name = Player#player.nickname,
        lv = Player#player.lv,
        sex = Player#player.sex,
        avatar = Player#player.avatar,
        layer = Layer,
        node = node(),
        is_online = 1,
        guild_key = GuildMember#g_member.gkey,  %%公会Key
        guild_name = Guild#guild.name, %%公会昵称
        guild_main = GuildMember#g_member.position, %% 职位 1会长 2副会长 3普通成员
        guild_main_name = Guild#guild.pname, %%会长昵称
        enter_time = util:unixtime(),
        boss_drop_num = StPlayerCrossBoss#st_player_cross_boss.drop_num
    }.

%%创建boss
create_boss(BossId, Copy) ->
    case data_mon:get(BossId) of
        [] -> [];
        _Mon ->
            #base_cross_boss{x = X, y = Y, layer = Layer} = data_cross_boss:get(BossId),
            {Key, Pid} = mon_agent:create_mon([BossId, get_scene_id_by_layer(Layer), X, Y, Copy, 1, [{return_id_pid, true}]]),
            [{Key, Pid}]
    end.

%%世界boss日志
log_cross_boss(Pkey, NickName, Damage, Rank, GoodsList) ->
    Sql = io_lib:format("insert into log_cross_boss set pkey = ~p,nickname = '~s',damage = ~p,rank=~p,goods = '~s',time =~p",
        [Pkey, NickName, Damage, Rank, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql).


%%修改名字
change_name(Pkey, NickName) ->
    catch cross_area:apply(cross_boss, change_name_local, [Pkey, NickName]).

change_name_local(Pkey, NickName) ->
    ?CAST(cross_boss_proc:get_server_pid(), {change_name, [Pkey, NickName]}).

%% 击杀boss
kill_boss(Mon, Attacker, _Klist, _TotalHurt) ->
    case scene:is_cross_boss_scene(Mon#mon.scene) of
        false -> skip;
        true -> ?CAST(cross_boss_proc:get_server_pid(), {kill_boss, Mon, Attacker, _Klist})
    end.

%% 击杀玩家
kill_player(Player, Attacker) ->
    cross_area:apply(cross_boss, cross_kill_player, [Player, Attacker]),
    ok.

cross_kill_player(Player, Attacker) ->
    ?CAST(cross_boss_proc:get_server_pid(), {kill_player, Player, Attacker}),
    ok.

update_online() ->
    case config:is_center_node() of
        true ->
            ?CAST(cross_boss_proc:get_server_pid(), update_online);
        false ->
            skip
    end.

midnight_clean() ->
    case config:is_center_node() of
        true ->
            ?CAST(cross_boss_proc:get_server_pid(), midnight_clean);
        false ->
            skip
    end.

to_client_reward(GuildKey, Rank, Reward1, Reward2) ->
    Guild = guild_ets:get_guild(GuildKey),
    #guild{pkey = Pkey} = Guild,
    {Title, Content0} = t_mail:mail_content(99),
    Content = io_lib:format(Content0, [Rank]),
    %% 盟主邮件奖励
    mail:sys_send_mail([Pkey], Title, Content, Reward2 ++ Reward1),
    to_client_reward2(GuildKey, Rank, Reward1, Reward2, Pkey).

to_client_reward2(GuildKey, Rank, Reward1, _Reward2, Pkey) ->
    MemberList = guild_ets:get_guild_member_list(GuildKey),
    F = fun(#g_member{pkey = MemberPkey}) ->
        if
            Pkey == MemberPkey -> [];
            true -> [MemberPkey]
        end
    end,
    KeyList = lists:flatmap(F, MemberList),
    {Title, Content0} = t_mail:mail_content(100),
    Content = io_lib:format(Content0, [Rank]),
    %% 成员邮件奖励
    mail:sys_send_mail(KeyList, Title, Content, Reward1),
    ok.

gm_start() ->
    cross_area:apply(cross_boss_proc, gm_start, []).

gm_stop() ->
    cross_area:apply(cross_boss_proc, gm_stop, []).

gm_box_mon() ->
    cross_area:apply(cross_boss_proc, gm_box_mon, []).

clean_cross_player(Pkey) ->
    cross_area:apply(cross_boss_proc, clean_cross_player, [Pkey]).

update_cross_boss_klist(Mon, _KList, _AttKey, _AttNode) ->
    IsCrossScene = scene:is_cross_boss_scene(Mon#mon.scene),
    if
        IsCrossScene == false -> skip;
        Mon#mon.hp =< 0 ->
            cross_boss_proc:get_server_pid() ! {update_cross_boss, Mon, _KList};
        true ->
            Now = util:unixtime(),
            Key = update_cross_boss_klist,
            case get(Key) of
                undefined ->
                    put(Key, Now),
                    cross_boss_proc:get_server_pid() ! {update_cross_boss, Mon, _KList};
                Time ->
                    case Now - Time >= 2 of
                        true ->
                            put(Key, Now),
                            cross_boss_proc:get_server_pid() ! {update_cross_boss, Mon, _KList};
                        false -> false
                    end
            end
    end.

get_act_state() ->
    ?CALL(cross_boss_proc:get_server_pid(), get_act_state).

get_cross_node_lv() ->
    center:world_lv().

recv_score_reward(Pkey, Score, Node, Pid, Sid) ->
    ?CAST(cross_boss_proc:get_server_pid(), {recv_score_reward, Pkey, Score, Node, Pid, Sid}).

recv_score_reward(Player, Score) ->
    case data_cross_boss_score_reward:get(Score) of
        [] ->
            Player;
        GoodsInfo ->
            GiveGoodsList = goods:make_give_goods_list(0, GoodsInfo),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            NewPlayer
    end.

get_status(Sid, DropNum, BaseHasNum) ->
    cross_area:apply(cross_boss, get_state_remain_time, [Sid, DropNum, BaseHasNum]).

get_state_remain_time(Sid, DropNum, BaseHasNum) ->
    ?CAST(cross_boss_proc:get_server_pid(), {get_state_remain_time, Sid, DropNum, BaseHasNum}).

get_state_remain_time_cast(Sid, DropNum, BaseHasNum, OpenState, RemainTime) ->
    {ok, Bin} = pt_570:write(57009, {OpenState, RemainTime, DropNum, BaseHasNum}),
    server_send:send_to_sid(Sid, Bin).

time_list(Now) ->
    Week = util:get_day_of_week(Now),
    F = fun(Id) ->
        {WeekList, TimeList} = data_cross_boss_time:get(Id),
        case lists:member(Week, WeekList) of
            false -> [];
            true ->
                [[SH * 3600 + SM * 60, EH * 3600 + EM * 60] || {{SH, SM}, {EH, EM}} <- TimeList]
        end
    end,
    lists:flatmap(F, data_cross_boss_time:ids()).

update_player_cross_boss() ->
    St = lib_dict:get(?PROC_STATUS_CROSS_BOSS_DROP_NUM),
    #st_player_cross_boss{op_time = OpTime} = St,
    Now = util:unixtime(),
    case util:is_same_date(OpTime, Now) of
        true ->
            skip;
        false ->
            NewSt = St#st_player_cross_boss{drop_num = 0, op_time = Now},
            lib_dict:put(?PROC_STATUS_CROSS_BOSS_DROP_NUM, NewSt)
    end.

midnight_refresh(_) ->
    update_player_cross_boss().

update_player_data(Pkey, MonId) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [Ets] ->
            Ets#ets_online.pid ! {add_player_cross_boss, MonId};
        _ ->
            ok
    end.

add_player_cross_boss(Player, MonId) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_BOSS_DROP_NUM),
    NewSt = St#st_player_cross_boss{drop_num = St#st_player_cross_boss.drop_num+1, op_time = util:unixtime()},
    lib_dict:put(?PROC_STATUS_CROSS_BOSS_DROP_NUM, NewSt),
    cross_boss_load:update(NewSt),
    #mon{name = MonDesc} = data_mon:get(MonId),
    #base_cross_boss{layer = Layer} = data_cross_boss:get(MonId),
    Sql = io_lib:format("insert into log_cross_boss_has set pkey=~p, mon_id=~p, mon_desc='~s', layer=~p, time=~p",
        [Player#player.key, MonId, MonDesc, Layer, util:unixtime()]),
    log_proc:log(Sql).

get_scene_id_by_layer(1) ->
    ?SCENE_ID_CROSS_BOSS_ONE;
get_scene_id_by_layer(2) ->
    ?SCENE_ID_CROSS_BOSS_TWO;
get_scene_id_by_layer(3) ->
    ?SCENE_ID_CROSS_BOSS_THREE;
get_scene_id_by_layer(4) ->
    ?SCENE_ID_CROSS_BOSS_FOUR;
get_scene_id_by_layer(5) ->
    ?SCENE_ID_CROSS_BOSS_FIVE.

get_scene_id_by_mon(MonId) ->
    case data_cross_boss:get(MonId) of
        [] ->
            ?SCENE_ID_CROSS_BOSS_ONE;
        #base_cross_boss{layer = Layer} ->
            get_scene_id_by_layer(Layer)
    end.

get_layer_by_mon(MonId) ->
    case data_cross_boss:get(MonId) of
        [] -> 1;
        #base_cross_boss{layer = Layer} -> Layer
    end.

get_limit_lv_by_layer(Layer) ->
    SceneId = get_scene_id_by_layer(Layer),
    #scene{require = Require} = data_scene:get(SceneId),
    case lists:keyfind(lv, 1, Require) of
        false -> 100;
        {lv, Lv} -> Lv
    end.
