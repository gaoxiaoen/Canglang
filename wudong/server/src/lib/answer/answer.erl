%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 二月 2017 下午1:40
%%%-------------------------------------------------------------------
-module(answer).
-author("fengzhenlin").
-include("common.hrl").
-include("answer.hrl").
-include("server.hrl").
-include("scene.hrl").

%% API
-compile(export_all).

%%检查开启
check_open_answer(Now) ->
    WeekDay = util:get_day_of_week(Now),
    OpenList = data_question_open_time:get(),
    case lists:keyfind(WeekDay, 1, OpenList) of
        false -> skip;
        {_, {H1, M1}, Long, NoticeTime} ->
            Date = util:unixdate(Now),
            OpenTime = Date + H1*3600 + M1*60,
            NowMin = Now - Now rem 60,
            if
                OpenTime == NowMin + NoticeTime ->
                    %%即将开启
                    answer_proc:rpc_ready_open(OpenTime);
                OpenTime == NowMin ->
                    %%开启
                    answer_proc:rpc_open_answer(Long);
                true ->
                    skip
            end
    end.

make_player_to_apinfo(Player) ->
    #player{
        key = Pkey,
        node = Node,
        nickname = Name,
        lv = Lv,
        career = Career,
        sex = Sex,
        guild = #st_guild{guild_key = Gkey},
        sid = Sid,
        copy = Copy
    } = Player,
    #a_pinfo{
        pkey = Pkey,
        name = Name,
        lv = Lv,
        career = Career,
        sex = Sex,
        gkey = Gkey,
        node = Node,
        sid = Sid,
        copy = Copy
    }.

%%检查进入答题场景
check_enter_answer_scene(APinfo, CurScene) ->
    ?CAST(answer_proc:get_server_pid(), {check_enter_answer_scene, APinfo, CurScene}),
    ok.

%%传送玩家进答题场景 [中心服->单服]
send_enter_answer_scene(Pkey, Copy, X, Y) ->
    case player_util:get_player_online(Pkey) of
        [] -> skip;
        Online ->
            Online#ets_online.pid ! {apply_state, {answer, enter_answer_scene, [Copy, X, Y]}},
            ok
    end.
enter_answer_scene([Copy, X, Y], Player) ->
    Player1 = scene_change:change_scene(Player, ?SCENE_ID_ANSWER, Copy, X, Y, true),
%%     Player2 = player_battle:pk_change_sys(Player1, ?PK_TYPE_PEACE, 1),
    Pinfo = make_player_to_apinfo(Player1),
    cross_area:apply(answer, enter_answer_scene_1, [Pinfo]),
    {ok, Bin} = pt_260:write(26001, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player1}.
enter_answer_scene_1(Pinfo) ->
    ?CAST(answer_proc:get_server_pid(), {enter_answer_scene, Pinfo}),
    ok.

%%答题加经验
answer_add_exp(Pkey, AddExp) ->
    case player_util:get_player_online(Pkey) of
        [] -> skip;
        Online ->
            Online#ets_online.pid ! {add_exp, AddExp, 19},
            ok
    end.

%%结算奖励
reward(Pkey, MaxQNum, RightNum, Point, Order, AddExp, GoodsList, RankList) ->
    case player_util:get_player_online(Pkey) of
        [] ->
            Title = ?T("答题"),
            Content =
                case GoodsList of
                    [] -> io_lib:format(?T("你的本次答题活动。积分~p，总榜排名：未上榜，获得经验~p"),[Point,AddExp]);
                    _ -> io_lib:format(?T("你的本次答题活动。积分~p，总榜排名：~p，获得经验~p，获得奖励："),[Point,Order,AddExp])
                end,
            mail:sys_send_mail([Pkey], Title, Content, GoodsList);
        Online ->
            Online#ets_online.pid ! {apply_state, {answer, reward_1, {MaxQNum, RightNum, Point, Order, AddExp, GoodsList, RankList}}},
            ok
    end,
    %%称号
    {DesId, DesName} =
        case Order of
            1 -> {10007, ?T("状元")};
            2 -> {10008, ?T("榜眼")};
            3 -> {10009, ?T("探花")};
            _ -> {0, ""}
        end,
    case DesId > 0 of
        true ->
            designation_proc:add_des(DesId, [Pkey]),
            Title1 = ?T("答题奖励"),
            Content1 = io_lib:format(?T("本次答题活动中，你以非凡的智慧和勇气名列总榜第~p，获得~s称号"),[Order, DesName]),
            mail:sys_send_mail([Pkey], Title1, Content1),
            ok;
        false ->
            skip
    end,
    ok.
reward_1({MaxQNum, RightNum, Point, Order, AddExp, GoodsList, RankList}, Player) ->
    GoodsList1 = util:list_tuple_to_list(GoodsList ++ [{10108, AddExp}]),
    {ok, Bin} = pt_260:write(26009, {MaxQNum, RightNum, Point, Order, GoodsList1, RankList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    case GoodsList of
        [] -> ok;
        _ ->
            GiveList = goods:make_give_goods_list(508, GoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveList),
            {ok, NewPlayer}
    end.

%%获取活动状态
get_answer_state(Sid, Node) ->
    ?CAST(answer_proc:get_server_pid(), {get_answer_state, Sid, Node}),
    ok.

%%答题
select_answer(Pkey, Select) ->
    ?CAST(answer_proc:get_server_pid(), {select_answer, Pkey, Select}),
    ok.

%%使用道具
use_daoju(Pkey, Type) ->
    ?CAST(answer_proc:get_server_pid(), {use_daoju, Pkey, Type}),
    ok.

%%查看排名
get_rank(Pkey, Node, Sid) ->
    ?CAST(answer_proc:get_server_pid(), {get_rank, Pkey, Node, Sid}),
    ok.

%%传送玩家出去
sendout_scene_to_main(Pkey) ->
    case player_util:get_player_online(Pkey) of
        [] -> skip;
        Online ->
            Online#ets_online.pid ! {apply_state, {answer, sendout_scene_to_main_1, []}}
    end,
    ok.
sendout_scene_to_main_1([], Player) ->
    Player1 = scene_change:change_scene(Player, Player#player.scene_old, Player#player.copy_old, Player#player.x_old, Player#player.y_old, true),
    {ok, Player1}.

%%玩家退出答题
exit_answer(Player) ->
    IsAnswerScene = scene:is_answer_scene(Player#player.scene),
    if
        not IsAnswerScene -> {false, 0};
        true ->
            Player1 = scene_change:change_scene(Player, Player#player.scene_old, Player#player.copy_old, Player#player.x_old, Player#player.y_old, true),
            exit_scene(Player),
            {ok, Player1}
    end.

%%玩家退出答题
exit_scene(Player) ->
    case scene:is_answer_scene(Player#player.scene) of
        true ->
            cross_area:apply(answer, exit_scene_cross, [Player#player.key]);
        false ->
            skip
    end.
exit_scene_cross(Pkey) ->
    ?CAST(answer_proc:get_server_pid(), {exit_scene, Pkey}),
    ok.

get_answer_rank_top_n(N) ->
    cross_area:apply_call(answer, get_answer_rank_top_n_1, [N]).

get_answer_rank_top_n_1(N) ->
    ?CALL(answer_proc:get_server_pid(), {get_anwer_rank_top_n, N}).