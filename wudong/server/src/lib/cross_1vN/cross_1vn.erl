%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2017 15:03
%%%-------------------------------------------------------------------
-module(cross_1vn).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("cross_1vN.hrl").
-include("daily.hrl").
-include("chat.hrl").
-include("notice.hrl").
%% API
-export([
    get_sign_info/4,
    sign_up/4,
    kill_role/3,
    do_kill_role/4,
    cross_1vn_quit/2,
    logout/1,
    cross_1vn_logout/3,
    get_fight_info/4,
    get_final_fight_info/5,
    get_history_info/5,
    get_history_group/2,
    get_rank_info/5,
    get_final_rank_info/5,
    get_shop_info/2,
    sys_midnight_cacl/1,
    shop_buy/3,
    get_orz_info/5,
    orz_winner/0,
    get_winner_reward/1,
    orz_winner_reward/1,
    cross_1vn_shop_add/2,
    get_cross_1vn_shop_center/5,
    get_cross_1vn_shop_center_cast/7,
    set_cross_1vn_winner_state/3,
    get_wait_scene_xy1/0,
    get_wait_scene_xy2/0,
    player_bet/5,
    get_bet_info/6,
    reset_shop_base/1,
    cmd_reset_shop_base/0,
    get_winner_bet_info/5,
    player_bet_call/6,
    player_bet_case/6,
    player_winner_bet_call/5,
    player_winner_bet_case/5,
    get_bet_history_info/3,
    winner_bet/4
]).

-define(SHOP_TYPE_0, 0).
-define(SHOP_TYPE_1, 1).

get_bet_info(Sid, Node, Pkey, Group, Exp, ExpUp) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_bet_info, Sid, Node, Pkey, Group, Exp, ExpUp}),
    ok.

get_bet_history_info(Sid, Node, Pkey) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_bet_history_info, Sid, Node, Pkey}),
    ok.

get_winner_bet_info(Sid, Node, Pkey, Group, Count) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_winner_bet_info, Sid, Node, Pkey, Group, Count}),
    ok.

player_bet(Player, Group, Floor, CostId, Type) ->
    case data_cross_1vn_bet_cost:get(CostId) of
        [] ->
            {0, Player};
        Cost ->
            case money:is_enough(Player, Cost, bgold) of
                false -> {5, Player}; %% 元宝不足
                true ->
                    case cross_area:apply_call(cross_1vn, player_bet_call, [Player#player.key, Player#player.sn_cur, Group, Floor, Cost, Type]) of
                        {false, Res} ->
                            {Res, Player};
                        ok ->
                            NewPlayer = money:add_bind_gold(Player, -Cost, 341, 0, 0),
                            cross_area:apply(cross_1vn, player_bet_case, [Player#player.key, Player#player.sn_cur, Group, Floor, Cost, Type]),
                            log_cross_1vn_bet(Player#player.key, Group, Floor, Cost, Type, 1),
                            {1, NewPlayer};
                        _ ->
                            {0, Player}
                    end
            end
    end.

player_bet_call(PKey, Sn, Group, Floor, Cost, Type) ->
    ?CALL(cross_1vn_proc:get_server_pid(), {player_bet, PKey, Sn, Group, Floor, Cost, Type}).

player_bet_case(PKey, Sn, Group, Floor, Cost, Type) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {player_bet, PKey, Sn, Group, Floor, Cost, Type}),
    ok.

get_sign_info(Pkey, Node, Sid, Lv) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_sign_info, Pkey, Node, Sid, Lv}),
    ok.

get_orz_info(Node, Sid, Count, State1, Group) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_orz_info, Node, Sid, Count, State1, Group}),
    ok.

set_cross_1vn_winner_state(Pkey, State, ExpUp) ->
    cache:set({cross_1vn_winner_state, Pkey}, {State, ExpUp}),
    ok.

sign_up(Pkey, Node, Sid, Mb) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {sign_up, Pkey, Node, Sid, Mb}),
    ok.

%%获取玩家个人比赛信息
get_fight_info(Pkey, Sid, Node, Exp) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_fight_info, Pkey, Sid, Node, Exp}),
    ok.

%%获取决赛玩家个人比赛信息
get_final_fight_info(Pkey, Sid, Node, Exp, ExpUp) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_final_fight_info, Pkey, Sid, Node, Exp, ExpUp}),
    ok.

%%历史守擂记录
get_history_info(Sid, Node, Month, Day, Group) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_history_info, Sid, Node, Month, Day, Group}),
    ok.

%%历史守擂记录
get_history_group(Node, Sid) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_history_group, Node, Sid}),
    ok.

%%获取资格赛排名信息
get_rank_info(Group, Pkey, Sid, Page, Node) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_rank_info, Group, Pkey, Sid, Page, Node}),
    ok.

%%获取擂台赛排名信息
get_final_rank_info(Group, Pkey, Sid, Page, Node) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {get_final_rank_info, Group, Pkey, Sid, Page, Node}),
    ok.

%%击杀玩家
kill_role(Player, Attacker, AccDamage) ->
    if Attacker#attacker.sign == ?SIGN_PLAYER ->
        cross_area:apply(cross_1vn, do_kill_role, [Player#player.copy, Player#player.key, Attacker#attacker.key, AccDamage]);
        true ->
            cross_area:apply(cross_1vn, do_kill_role, [Player#player.copy, Player#player.key, Attacker#attacker.shadow_key, AccDamage])
    end.

do_kill_role(Copy, DieKey, AttackKey, AccDamage) ->
    ?DEBUG("AttackKey ~p~n", [AttackKey]),
    catch Copy ! {role_die, DieKey, AttackKey, AccDamage},
    ok.

%%退出
cross_1vn_quit(Pkey, Copy) ->
    catch Copy ! {quit, Pkey},
    ok.


%%离线
logout(Player) ->
%%     cross_six_dragon:leave_wait_scene(Player, Player#player.scene),
    cross_area:apply(cross_1vn, cross_1vn_logout, [Player#player.key, Player#player.scene, Player#player.copy]),
%%     exit_cross_1vn_battle(Player),
    ok.

%%退出战斗场景
cross_1vn_logout(Pkey, Scene, Copy) ->
    if
        Scene == ?SCENE_ID_CROSS_1VN_WAR -> %% 资格赛战斗场景
            catch Copy ! {quit, Pkey},
            ok;
        Scene == ?SCENE_ID_CROSS_1VN_FINAL_WAR -> %% 决赛战斗场景
            catch Copy ! {quit, Pkey},
            ok;
        true ->
            ok
    end.

%%资格赛准备场景坐标
get_wait_scene_xy1() ->
    L = [{14, 21}, {10, 17}, {19, 20}, {17, 25}, {11, 24}],
    util:list_rand(L).

%%守擂赛场景坐标
get_wait_scene_xy2() ->
    L = [{20, 40}, {24, 34}, {27, 39}, {21, 47}, {13, 42}, {14, 37}],
    util:list_rand(L).


get_shop_info(Player, Type) ->
%%     All = data_cross_1vn_shop:get_all(Type),
    St = lib_dict:get(?PROC_STATUS_CROSS_1VN_SHOP),
    %% 改为单服
    ?CAST(activity_proc:get_act_pid(), {get_cross_1vn_shop_center, Type, St#st_cross_1vn_shop.floor, St#st_cross_1vn_shop.is_sign, St#st_cross_1vn_shop.shop, Player#player.sid}),
    ok.

get_cross_1vn_shop_center(Type, Floor, IsSign, List, Sid) ->
    ?CAST(activity_proc:get_act_pid(), {get_cross_1vn_shop_center, Type, Floor, IsSign, List, Sid}),
    ok.

get_cross_1vn_shop_center_cast(CrossShop, Cross1vnShopBase, Type, _Floor, _IsSign, List, Sid) ->
    ?DEBUG("Type ~p~n", [Type]),
    F = fun(Base0) ->
        if Base0 == [] -> [];
            true ->
                case lists:keyfind({Type, Base0#base_cross_1vn_shop.id}, 1, List) of
                    false -> [{{Type, Base0#base_cross_1vn_shop.id}, 0}];
                    {{Type, Id}, Count} ->
                        [{{Type, Id}, Count}]
                end
        end
    end,
    List1 = lists:flatmap(F, Cross1vnShopBase),

    F1 = fun(Base) ->
        if
            Base == [] -> [];
            true ->
                {MyCount, AllCount} =
                    case lists:keyfind({Type, Base#base_cross_1vn_shop.id}, 1, CrossShop) of
                        false ->
                            {Base#base_cross_1vn_shop.my_count,
                                Base#base_cross_1vn_shop.all_count};
                        {{Type, Id}, Count} ->
                            case lists:keyfind({Type, Id}, 1, List1) of
                                false ->
                                    {Base#base_cross_1vn_shop.my_count,
                                        max(50, Base#base_cross_1vn_shop.all_count - Count)};
                                {{Type, Id}, Count1} ->
                                    {max(0, Base#base_cross_1vn_shop.my_count - Count1),
                                        max(50, Base#base_cross_1vn_shop.all_count - Count)
                                    }
                            end
                    end,
                [[Base#base_cross_1vn_shop.id,
                    Base#base_cross_1vn_shop.goods_id,
                    Base#base_cross_1vn_shop.goods_num,
                    Base#base_cross_1vn_shop.old_cost,
                    Base#base_cross_1vn_shop.now_cost,
                    Base#base_cross_1vn_shop.ratio,
                    MyCount,
                    Base#base_cross_1vn_shop.my_count,
                    AllCount,
                    Base#base_cross_1vn_shop.all_count]]
        end
    end,
    Data = lists:flatmap(F1, [X || X <- Cross1vnShopBase, X#base_cross_1vn_shop.type == Type]),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_642:write(64220, {Data}),
    server_send:send_to_sid(Sid, Bin),
    ok.

shop_buy(Player, Type, Id) ->
    case cross_1vn_util:get_shop_state(Player) of
        -1 -> {2, Player};
        _O ->
            case check_shop_buy(Type, Id, Player) of
                {false, Res} ->
                    {Res, Player};
                {ok, Base, NewShopList} ->
                    NewPlayer = money:add_no_bind_gold(Player, -Base#base_cross_1vn_shop.now_cost, 336, 0, 0),
                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(336, [{Base#base_cross_1vn_shop.goods_id, Base#base_cross_1vn_shop.goods_num}])),
                    St = lib_dict:get(?PROC_STATUS_CROSS_1VN_SHOP),
                    NewSt = St#st_cross_1vn_shop{shop = NewShopList},
                    lib_dict:put(?PROC_STATUS_CROSS_1VN_SHOP, NewSt),
                    cross_1vn_init:dbup_cross_1vn_shop(NewSt),
                    log_cross_1vn_shop(Player#player.key, Type, Id, Base#base_cross_1vn_shop.now_cost, Base#base_cross_1vn_shop.goods_id, Base#base_cross_1vn_shop.goods_num),
%%                     cross_area:apply(?MODULE, cross_1vn_shop_add, [Type, Id]),
                    ?CAST(activity_proc:get_act_pid(), {cross_1vn_shop_add, Type, Id}),
                    {1, NewPlayer1}
            end
    end.

cross_1vn_shop_add(Type, Id) ->
    ?CAST(activity_proc:get_act_pid(), {cross_1vn_shop_add, Type, Id}),
    ok.

check_shop_buy(Type, Id, Player) ->
    BaseAll = ?CALL(activity_proc:get_act_pid(), get_cross_1vn_shop_base),
    F = fun(Base0, Base) ->
        if
            Base0#base_cross_1vn_shop.type == Type andalso Base0#base_cross_1vn_shop.id == Id -> Base0;
            true -> Base
        end
    end,

    case lists:foldl(F, [], BaseAll) of
        [] -> {false, 0};
        Base ->
            if
                Base#base_cross_1vn_shop.now_cost =< 0 -> {false, 0};
                true ->
                    case money:is_enough(Player, Base#base_cross_1vn_shop.now_cost, gold) of
                        false -> {false, 5};
                        true ->
                            St = lib_dict:get(?PROC_STATUS_CROSS_1VN_SHOP),
                            if
                                Type == 1 andalso (St#st_cross_1vn_shop.floor =< 0 orelse St#st_cross_1vn_shop.is_sign /= 1) ->
                                    {false, 9};
                                Type == 0 andalso St#st_cross_1vn_shop.is_sign /= 1 -> {false, 10};
                                true ->
                                    case lists:keytake({Type, Id}, 1, St#st_cross_1vn_shop.shop) of
                                        false ->
                                            {ok, Base, [{{Type, Id}, 1} | St#st_cross_1vn_shop.shop]};
                                        {value, {{Type, Id}, Count1}, T} ->
                                            Count = max(0, Base#base_cross_1vn_shop.my_count - Count1),
                                            if
                                                Count =< 0 -> {false, 6};
                                                true ->
                                                    {ok, Base, [{{Type, Id}, Count1 + 1} | T]}
                                            end
                                    end
                            end
                    end
            end
    end.

get_winner_reward(Player) ->
    Count = daily:get_count(?DAILY_CROSS_1VN_REWARD),
    if
        Count > 0 -> {7, Player};
        true ->
            St = lib_dict:get(?PROC_STATUS_CROSS_1VN_SHOP),
            if
                St#st_cross_1vn_shop.floor < 1 -> {8, Player};
                true ->
                    case data_cross_1vn_final_rank_reward:get_daily(St#st_cross_1vn_shop.lv_group, St#st_cross_1vn_shop.rank) of
                        [] -> {0, Player};
                        Reward ->
                            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(337, tuple_to_list(Reward))),
                            daily:set_count(?DAILY_CROSS_1VN_REWARD, 1),
                            cross_area:apply(?MODULE, orz_winner, []),
                            {1, NewPlayer}
                    end
            end
    end.

orz_winner_reward(Player) ->
    case cross_1vn_util:get_shop_state(Player) of
        -1 -> {2, Player};
        _ ->
            Count = daily:get_count(?DAILY_CROSS_1VN_REWARD),
            if
                Count > 0 -> {7, Player};
                true ->
                    case data_cross_1vn_orz_reward:get(Player#player.lv) of
                        [] -> {0, Player};
                        Reward0 ->
                            Reward = tuple_to_list(Reward0),
                            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(338, Reward)),
                            daily:set_count(?DAILY_CROSS_1VN_REWARD, 1),
                            cross_area:apply(?MODULE, orz_winner, []),
                            {1, NewPlayer}
                    end
            end
    end.

orz_winner() ->
    ?CAST(cross_1vn_proc:get_server_pid(), orz_winner),
    ok.



winner_bet(Player, Group, WinnerKey, CostId) ->
    Count = daily:get_count(?DAILY_CROSS_1VN_WINNER_BET),
    if
        Count >= 3 -> {14, Player, ""};
        true ->
            case data_cross_1vn_bet_winner_cost:get(CostId) of
                [] ->
                    {0, Player, ""};
                Cost ->
                    case money:is_enough(Player, Cost, bgold) of
                        false -> {5, Player, ""}; %% 元宝不足
                        true ->
                            case cross_area:apply_call(cross_1vn, player_winner_bet_call, [Player#player.key, Player#player.sn_cur, Group, WinnerKey, Cost]) of
                                {false, Res} ->
                                    {Res, Player, ""};
                                {ok, WinName, Ratio} ->
                                    daily:increment(?DAILY_CROSS_1VN_WINNER_BET, 1),
                                    NewPlayer = money:add_no_bind_gold(Player, -Cost, 341, 0, 0),
                                    cross_area:apply(cross_1vn, player_winner_bet_case, [Player#player.key, Player#player.sn_cur, Group, WinnerKey, Cost]),
                                    Notice = data_notice_sys:get(293),
                                    #base_notice{content = Content} = Notice,
                                    Msg = io_lib:format(Content, [t_tv:cl(Player#player.nickname, 1), t_tv:cl(WinName, 1), Cost, Ratio, util:floor(Cost * Ratio)]),
                                    log_cross_1vn_bet(Player#player.key, Group, 0, Cost, 1, 2),
                                    {1, NewPlayer, Msg};
                                Other ->
                                    ?ERR("Other ~p~n", [Other]),
                                    {0, Player, ""}
                            end
                    end
            end
    end.

player_winner_bet_case(PKey, Sn, Group, WinnerKey, Cost) ->
    ?CAST(cross_1vn_proc:get_server_pid(), {player_winner_bet, PKey, Sn, Group, WinnerKey, Cost}),
    ok.

player_winner_bet_call(PKey, Sn, Group, WinnerKey, Cost) ->
    ?CALL(cross_1vn_proc:get_server_pid(), {player_winner_bet, PKey, Sn, Group, WinnerKey, Cost}).


log_cross_1vn_bet(Pkey, Group, Floor, Cost, Type, Type1) ->
    ?DEBUG("~p~n", [{Pkey, Group, Floor, Cost, Type, Type1}]),
    Sql = io_lib:format("insert into  log_cross_1vn_bet (pkey,`group`,floor,cost,type,type1,time) VALUES(~p,~p,~p,~p,~p,~p,~p)",
        [Pkey, Group, Floor, Cost, Type, Type1, util:unixtime()]),
    log_proc:log(Sql),
    ok.


log_cross_1vn_shop(Pkey, Type, Cid, Cost, GoodsId, GoodsNum) ->
    Sql = io_lib:format("insert into log_cross_1vn_shop (pkey,`type`,`cid`,cost,goods_id,goods_num,time) VALUES(~p,~p,~p,~p,~p,~p,~p)",
        [Pkey, Type, Cid, Cost, GoodsId, GoodsNum, util:unixtime()]),
    log_proc:log(Sql),
    ok.

cmd_reset_shop_base() ->
    ?CAST(activity_proc:get_act_pid(), reset_shop_base),
    ok.

reset_shop_base(Round) ->
    ?DEBUG("Round ~p~n", [Round]),
    Times = config:get_merge_times(),
    {Ids01, NewRound01} =
        case data_cross_1vn_shop:get_all(?SHOP_TYPE_0, Round + 1, Times) of
            [] ->
                {data_cross_1vn_shop:get_all(?SHOP_TYPE_0, 1, Times), 1};
            Ids0 ->
                {Ids0, Round + 1}
        end,

    F = fun(Id) ->
        case data_cross_1vn_shop:get(?SHOP_TYPE_0, Id, NewRound01, Times) of
            [] -> [];
            Base -> [Base]
        end
    end,
    List1 = lists:flatmap(F, Ids01),

    {Ids11, NewRound11} =
        case data_cross_1vn_shop:get_all(?SHOP_TYPE_1, Round + 1, Times) of
            [] ->
                {data_cross_1vn_shop:get_all(?SHOP_TYPE_1, 1, Times), 1};
            Ids1 ->
                {Ids1, Round + 1}
        end,

    F1 = fun(Id) ->
        case data_cross_1vn_shop:get(?SHOP_TYPE_1, Id, NewRound11, Times) of
            [] -> [];
            Base -> [Base]
        end
    end,
    List2 = lists:flatmap(F1, Ids11),
    {List1 ++ List2, NewRound01}.


sys_midnight_cacl(_NowTime) ->
    NowWeek = util:get_day_of_week(_NowTime),
    if
        NowWeek == 1 ->
            {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
            if
                H == 0 andalso M == 1 ->
                    cmd_reset_shop_base();
                true -> ok
            end;
        true -> skip
    end.
