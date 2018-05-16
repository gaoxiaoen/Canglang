%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 七月 2016 上午11:46
%%%-------------------------------------------------------------------
-module(marry_rpc).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("scene.hrl").
%% API
-export([
    handle/3
]).

%%我的婚姻信息
handle(28801, Player, {}) ->
    Data = marry:marry_info(Player),
    {ok, Bin} = pt_288:write(28801, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%结婚信息
handle(28802, Player, {}) ->
    Data = marry:marry_data(),
    RingLv = marry_ring:get_my_ring_lv(),
    Type = marry_ring:get_my_ring_type(),
    Type1 =
        if
            Type == 0 -> 0;
            Type == 1 andalso Player#player.marry#marry.couple_key == 0 -> 2;
            true -> 1
        end,
    {ok, Bin} = pt_288:write(28802, {RingLv, Type1, Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%发起结婚请求
handle(28803, Player, {Type, Pkey}) ->
    Ret = marry:marry_request(Player, Type, Pkey),
    Close = relation:get_friend_qmd(Pkey),
    {ok, Bin} = pt_288:write(28803, {Ret, Close}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%收到结婚请求28804

%%结婚应答
handle(28805, Player, {Type, Pkey, Ret}) ->
    Code = marry:marry_answer(Ret, Player, Type, Pkey),
    {ok, Bin} = pt_288:write(28805, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Bin1} = pt_130:write(13001, player_pack:trans13001(Player)),
    server_send:send_to_sid(Player#player.sid, Bin1),
    player:apply_state(async, self(), {activity, sys_notice, [136]}),
    ok;

%%离婚
handle(28806, Player, {}) ->
    Code = marry:divorce(Player),
    {ok, Bin} = pt_288:write(28806, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Bin1} = pt_130:write(13001, player_pack:trans13001(Player)),
    server_send:send_to_sid(Player#player.sid, Bin1),
    ok;


%%获取巡游时间列表
handle(28810, Player, {Type}) ->
    ?CAST(marry_proc:get_server_pid(), {cruise_time_list, Type, Player#player.sid, Player#player.marry#marry.mkey}),
    ok;

%%预约巡游
handle(28811, Player, {Type, Id, InviteGuild, InviteFriend}) ->
    Ret =
        case ?CALL(marry_proc:get_server_pid(), {cruise_appointment, Type, Id, Player#player.marry#marry.mkey}) of
            [] ->
                0;
            {ok, Time} ->
                TimeString =
                    case version:get_lan_config() of
                        vietnam ->
                            util:unixtime_to_time_string4(Time);
                        _ ->
                            util:unixtime_to_time_string3(Time)
                    end,
                marry_cruise:app_mail(Player, TimeString),
                marry_cruise:invite_mail(Player, TimeString, InviteGuild, InviteFriend),
                marry_cruise:invite_mail_couple(Player, TimeString, InviteGuild, InviteFriend),
                1;
            Err -> Err

        end,
    player:apply_state(async, self(), {activity, sys_notice, [136]}),
    {ok, Bin} = pt_288:write(28811, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    case ets:lookup(?ETS_ONLINE, [Player#player.marry#marry.couple_key]) of
        [] -> skip;
        [#ets_online{pid = Pid}] ->
            player:apply_state(async, Pid, {activity, sys_notice, [136]})
    end,
    ok;

%%查看巡游状态
handle(28812, Player, {}) ->
    ?CAST(marry_proc:get_server_pid(), {check_cruise_state, Player#player.sid, Player#player.key, Player#player.marry#marry.mkey}),
    ok;

%%查看当前巡游信息
handle(28814, Player, {}) ->
    ?CAST(marry_proc:get_server_pid(), {cruise_state, Player#player.sid}),
    ok;

%%前往巡游/观礼
handle(28815, Player, {}) ->
    {Ret, NewPlayer} =
        case scene:is_normal_scene(Player#player.scene) of
            false -> {20, Player};
            true ->
                if Player#player.marry#marry.cruise_state /= 0 -> {35, Player};
                    true ->
                        case ?CALL(marry_proc:get_server_pid(), {check_cruise, Player#player.key}) of
                            {ok, boy, X, Y} ->
                                Marry = Player#player.marry,
                                NewMarry = Marry#marry{cruise_state = 1},
                                {ok, Bin} = pt_120:write(12054, {Player#player.key, NewMarry#marry.cruise_state}),
                                server_send:send_to_sid(Player#player.sid, Bin),
                                Player1 = scene_change:change_scene(Player#player{marry = NewMarry}, ?SCENE_ID_MAIN, 0, X, Y, false),
                                scene_agent_dispatch:update_cruise(Player1),
                                {1, Player1};
                            {ok, girl, X, Y} ->
                                Marry = Player#player.marry,
                                NewMarry = Marry#marry{cruise_state = 2},
                                {ok, Bin} = pt_120:write(12054, {Player#player.key, NewMarry#marry.cruise_state}),
                                server_send:send_to_sid(Player#player.sid, Bin),
                                Player1 = scene_change:change_scene(Player#player{marry = NewMarry}, ?SCENE_ID_MAIN, 0, X, Y, false),
                                scene_agent_dispatch:update_cruise(Player1),
                                {1, Player1};
                            {ok, guest, X, Y} ->
                                if abs(X - Player#player.x) =< 10 andalso abs(Y - Player#player.y) =< 10
                                    andalso Player#player.scene == ?SCENE_ID_MAIN andalso Player#player.copy == 0 ->
                                    {0, Player};
                                    true ->
                                        Player1 = scene_change:change_scene(Player, ?SCENE_ID_MAIN, 0, X, Y, false),
                                        {1, Player1}
                                end;
                            {ok, Err} ->
                                {Err, Player}
                        end
                end
        end,
    {ok, Bin1} = pt_288:write(28815, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin1),
    {ok, NewPlayer};

%%巡游互动
handle(28816, Player, {Type}) ->
    {Ret, NewPlayer} = marry_cruise:cruise_act(Type, Player),
    {ok, Bin1} = pt_288:write(28816, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin1),
    {ok, NewPlayer};

handle(28818, Player, {Key}) ->
    marry_proc:get_server_pid() ! {roll, Player#player.sid, Player#player.key, Player#player.nickname, Key},
    ok;

%%巡游购买
handle(28822, Player, _) ->
    if
        Player#player.marry#marry.mkey == 0 -> ok;
        true ->
            {Ret, NewPlayer} = marry_cruise:cruise_buy(Player),
            {ok, Bin1} = pt_288:write(28822, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin1),
            {ok, NewPlayer}
    end;

%% 获取结婚排行榜信息
handle(28850, Player, {}) ->
    StMarryRank = lib_dict:get(?PROC_STATUS_MARRY_RANK),
    #st_marry_rank{
        state = State
    } = StMarryRank,
    cross_all:apply(marry_rank, cross_get_marry_info, [node(),  Player#player.key, Player#player.pid,State]),
%%     Pid = activity_proc:get_act_pid(),
%%     Pid ! {get_marry_rank_info, Player#player.sid, Player#player.key, State},
    ok;

%% 领取结婚排行榜奖励
handle(28851, Player, {}) ->
    case marry_rank:receive_reward(Player) of
        {false, Res} ->
            {ok, Bin} = pt_288:write(28851, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_288:write(28851, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 获取羁绊信息
handle(28852, Player, {}) ->
    Data = marry_heart:marry_heart_info(Player),
    {ok, Bin} = pt_288:write(28852, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%羁绊升级
handle(28853, Player, {}) ->
    {Ret, NewPlayer} = marry_heart:heart_upgrade(Player),
    {ok, Bin} = pt_288:write(28853, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;

%%戒指信息
handle(28855, Player, {}) ->
    case marry_ring:ring_info(Player) of
        [] -> ok;
        Data ->
            {ok, Bin} = pt_288:write(28855, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%戒指升级
handle(28856, Player, {}) ->
    {Ret, NewPlayer} = marry_ring:ring_up(Player),
    {ok, Bin} = pt_288:write(28856, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, marry_ring_lv, NewPlayer};


%%称号信息
handle(28858, Player, {}) ->
    Data = marry_designation:get_info(),
    {ok, Bin} = pt_288:write(28858, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 领取称号
handle(28859, Player, {Id}) ->
    case marry_designation:get_marry_designation(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_288:write(28859, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_288:write(28859, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 结婚烟花使用
handle(28860, Player, {}) ->
    case marry:marry_fireworks(Player) of
        {false, Res} ->
            {ok, Bin} = pt_288:write(28860, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin1} = pt_120:write(12057, {Player#player.x, Player#player.y}),
            server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin1),
            {ok, Bin} = pt_288:write(28860, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% %% 结婚戒指触发
%% handle(28861, Player, {}) ->
%%     {ok, Bin1} = pt_120:write(12058, {Player#player.x, Player#player.y}),
%%     server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin1),
%%     {ok, Bin} = pt_288:write(28860, {1}),
%%     server_send:send_to_sid(Player#player.sid, Bin),
%%     ok;
%%
%% %% 结婚戒指失效
%% handle(28861, Player, {}) ->
%%     {ok, Bin1} = pt_120:write(12058, {Player#player.x, Player#player.y}),
%%     server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin1),
%%     {ok, Bin} = pt_288:write(28860, {1}),
%%     server_send:send_to_sid(Player#player.sid, Bin),
%%     ok;

%% 获取香囊界面
handle(28901, Player, _) ->
    Tuple = marry_gift:get_info(Player),
    {ok, Bin} = pt_289:write(28901, Tuple),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 香囊购买
handle(28902, Player, _) ->
    {Code, NewPlayer} = marry_gift:buy(Player),
    {ok, Bin} = pt_289:write(28902, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 香囊领取
handle(28903, Player, {Type}) ->
    {Code, NewPlayer} = marry_gift:recv(Player, Type),
    {ok, Bin} = pt_289:write(28903, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 香囊请求赠送
handle(28904, Player, _) ->
    Code = marry_gift:get_send(Player),
    {ok, Bin} = pt_289:write(28904, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 香囊获取购买价格
handle(28906, Player, _) ->
    Gold = marry_gift:get_gift_gold(Player),
    {ok, Bin} = pt_289:write(28906, {Gold}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 爱情树面板信息
handle(29101, Player, _) ->
    Data = marry_tree:get_info(Player),
    {ok, Bin} = pt_291:write(29101, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 爱情树升阶
handle(29102, Player, {Type}) ->
    {Code, NewPlayer} =
        if
            Type == 0 ->
                marry_tree:upgrade_stage(Player, 1);
            true ->
                marry_tree:upgrade_stage(Player, 500)
        end,
    {ok, Bin} = pt_291:write(29102, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 种子奖励领取
handle(29103, Player, {RecvLv, Type}) ->
    ?DEBUG("29103 RecvLv:~p", [RecvLv]),
    {Code, NewPlayer} = marry_tree:recv_tree_reward(Player, RecvLv, Type),
    ?DEBUG("Code:~p", [Code]),
    {ok, Bin} = pt_291:write(29103, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
%%    ?ERR("marry_rpc cmd ~p~n", [_cmd]),
    ok.