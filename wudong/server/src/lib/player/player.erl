%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 玩家进程
%%% @end
%%% Created : 04. 一月 2015 下午8:17
%%%-------------------------------------------------------------------
-module(player).
-author("fancy").

-behaviour(gen_server).
-export([
    start/1
    , stop/1
    , rpc/4
    , apply/3
    , apply_info/2
    , apply_state/3
    , get_dict/1
    , get_dict/2
    , put_dict/2
    , put_dict/3
    , erase_dict/1
    , erase_dict/2

]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, format_stats/2]).

-export([
    apply_chain/2
]).

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").

%% ----------------------------------------------------
%% 对外接口
%% ----------------------------------------------------

start(Args) ->
    gen_server:start_link(?MODULE, Args, []).


stop(RolePid) ->
    %%?PRINT("STOP!!~p~n",[RolePid]),
    ?CALL(RolePid, stop),
    ok.


%% @doc 客户端调用接口(socket事件处理)
rpc(RolePid, Mod, Cmd, Data) ->
    RolePid ! {rpc, Mod, Cmd, Data}.

%% 玩家进程调用函数

apply(async, RolePid, {M, F, A}) ->
    RolePid ! {apply, {M, F, A}};

apply(sync, RolePid, _Mfa) when not is_pid(RolePid) ->
    {error, not_pid};
apply(sync, RolePid, Mfa) when self() =:= RolePid ->
    ?ERR("执行apply时发生错误：调用了自身[~w, ~w]", [RolePid, Mfa]),
    {error, self_call};
apply(sync, RolePid, {M, F, A}) ->
    ?CALL(RolePid, {apply, {M, F, A}});

%% Timeout = int(), 毫秒
%% Callback = {F} | {F, A} | {M, F, A}
apply({timeout, Timeout}, RolePid, Callback) ->
    erlang:send_after(Timeout, RolePid, {apply_async, Callback}).

%% 玩家进程调用函数2
apply_state(async, RolePid, {M, F, A}) ->
    RolePid ! {apply_state, {M, F, A}};

apply_state(sync, RolePid, _Mfa) when not is_pid(RolePid) ->
    {error, not_pid};
apply_state(sync, RolePid, Mfa) when self() =:= RolePid ->
    ?ERR("执行apply时发生错误：调用了自身[~w, ~w]", [RolePid, Mfa]),
    {error, self_call};
apply_state(sync, RolePid, {M, F, A}) ->
    ?CALL(RolePid, {apply_state, {M, F, A}});

%% Timeout = int(), 毫秒
%% Callback = {F} | {F, A} | {M, F, A}
apply_state({timeout, Timeout}, RolePid, Callback) ->
    erlang:send_after(Timeout, RolePid, {apply_state, Callback}).


apply_info(RolePid, {M, F, A}) ->
    RolePid ! {apply_info, {M, F, A}}.

%% @spec get_dict(Key) -> {ok, Data} | {error, Reason}
%% Key = term()
%% Data = term()
%% Reason = atom()
%% @doc 获取当前角色的进程字典数据
get_dict(Key) ->
    case get(is_role_process) of
        true -> {ok, get(Key)};
        _ ->
            ?ERR("当前进程不是一个角色进程，不能使用get_dict/1"),
            {error, not_a_role_process}
    end.

%% @spec get_dict(RolePid, Key) -> {ok, Data} | {error, Reason}
%% Key = term()
%% Data = term()
%% Reason = atom()
%% @doc 获取当前角色的进程字典数据
get_dict(RolePid, _Key) when self() =:= RolePid ->
    {error, self_call};
get_dict(RolePid, Key) ->
    ?CALL(RolePid, {get_dict, Key}).

%% @spec put_dict(RKey, Val) -> {ok, LastData} | {error, Reason}
%% Key = term()
%% Val = term()
%% LastData = term()
%% Reason = atom()
%% @doc 写入数据到当前角色的进程字典
put_dict(Key, Val) ->
    case get(is_role_process) of
        true -> {ok, put(Key, Val)};
        _ ->
            ?ERR("当前进程不是一个角色进程，不用使用put_dict/2"),
            {error, not_a_role_process}
    end.

%% @spec put_dict(RolePid, Key, Val) -> {ok, LastData} | {error, Reason}
%% Key = term()
%% Val = term()
%% LastData = term()
%% Reason = atom()
%% @doc 写入数据到指定角色的进程字典
put_dict(RolePid, _Key, _Val) when self() =:= RolePid ->
    ?ERR("进行put_dict/3操作时调用了自身"),
    {error, self_call};
put_dict(RolePid, Key, Val) ->
    ?CALL(RolePid, {put_dict, Key, Val}).

%% @spec erase_dict(Key) -> {ok, Data} | {error, Reason}
%% Key = term()
%% Data = term()
%% Reason = atom()
%% @doc 清除当前角色的进程字典数据
erase_dict(Key) ->
    case get(is_role_process) of
        true -> {ok, erase(Key)};
        _ -> {error, not_a_role_process}
    end.

%% @spec erase_dict(RolePid, Key) -> {ok, Data} | {error, Reason}
%% Key = term()
%% Data = term()
%% Reason = atom()
%% @doc 清除指定角色的进程字典数据
erase_dict(RolePid, _Key) when self() =:= RolePid ->
    {error, self_call};
erase_dict(RolePid, Key) ->
    ?CALL(RolePid, {erase_dict, Key}).

%% ----------------------------------------------------
%% 内部调用处理
%% ----------------------------------------------------
init([Key, Sn, Pf, Socket, Ip, LoginFlag]) ->
    %%?PRINT("player init start.~n"),
    ?PRINT("Key ~w", [Key]),
    put(is_role_process, true), %% 标识下这是一个角色进程
    lib_dict:init(send_buff),
    lib_dict:put(?LOGIN_FINISH, false),%%部分协议需要判断是否已经登录完成再推送给客户端
    Player = apply_chain(#player{key = Key, sn = Sn, pf = Pf, socket = Socket, last_login_ip = Ip, login_flag = LoginFlag}, [
        fun player_init:init/1,
        fun player_mask:init/1,
        fun fuwen_init:init/1,
        fun fairy_soul_init:init/1,
        fun skill_init:init/1,
        fun vip_init:init/1,
        fun goods_init:init/1,
        fun guild_init:init/1,
        fun dungeon_init:init/1,
        fun daily_init:init/1,
        fun goods_attr_dan:init/1,
        fun mount_init:init/1,
        fun random_shop_init:init/1,
        fun sign_in_init:init/1,
%%        fun treasure:init/1,
        fun fashion_init:init/1,
        fun bubble_init:init/1,
        fun decoration_init:init/1,
        fun day7login_init:init/1,
        fun lv_gift:init/1,
        fun wing_init:init/1,
        fun relation:init/1,
        fun charge_init:init/1,
        fun designation_init:init/1,
        fun player_guide:init/1,
        fun mail_init:init/1,
        fun return_act:init/1,
        fun activity_init:init/1,
        fun guild_box_init:init/1,
        fun gold_count:init/1,
        fun res_gift:init/1,
%%        fun crazy_click_init:init/1,
        fun taobao_init:init/1,
%%        fun yuanli_init:init/1,
%%        fun xiulian_init:init/1,
        fun role_goods_count:init/1,
        fun worship_init:init/1,
        fun findback_exp:init/1,
        fun findback_src:init/1,
        fun guild_skill:init/1,
        fun invest_init:init/1,
        fun star_luck_init:init/1,
        fun cross_hunt_target:init/1,
        fun battlefield_init:init/1,
        fun cross_arena_init:init/1,
        fun drop_vitality:init/1,
        fun meridian_init:init/1,
        fun achieve_init:init/1,
        fun sword_pool_init:init/1,
        fun cross_dungeon_init:init/1,
        fun cross_dungeon_guard_init:init/1,
        fun hp_pool:init/1,
        fun light_weapon_init:init/1,
        fun magic_weapon_init:init/1,
        fun god_weapon_init:init/1,
        fun mon_photo_init:init/1,
        fun smelt_init:init/1,
        fun buff_init:init/1,
        fun cross_elite_init:init/1,
        fun team_init:init/1,
        fun pet_weapon_init:init/1,
        fun footprint_init:init/1,
        fun more_exp:init/1,
        fun pet_init:init/1,
        fun act_draw_turntable:init/1,
        fun act_hi_fan_tian:init/1,
        fun cross_eliminate_init:init/1,
        fun cross_flower_init:init/1,
        fun flower_rank_init:init/1,
        fun cross_fruit:init/1,
        fun head_init:init/1,
        fun cat_init:init/1,
        fun golden_body_init:init/1,
        fun god_treasure_init:init/1,
        fun jade_init:init/1,
        fun marry:init/1,
        fun marry_heart:init/1,
        fun marry_ring:init/1,
        fun equip_part_shop:init/1,
        fun marry_designation:init/1,
        fun marry_room_init:init/1,
        fun marry_gift:init/1,
        fun marry_tree:init/1,
        fun act_buy_money:init/1,
        fun cross_1vn_init:init/1,
        fun act_daily_task:init/1,
        fun online_reward:init/1,
        fun task_change_career:init/1,
        fun cross_dark_bribe:init/1,
        fun baby_init:init/1,
        %%子女外观类初始化需放子女初始化后
        fun baby_mount_init:init/1,
        fun baby_weapon_init:init/1,
        fun baby_wing_init:init/1,
        fun cross_war_init:init/1,
        fun free_gift:init/1,
        fun new_free_gift:init/1,
        fun cross_boss_init:init/1,
        fun dvip:init/1,
        fun act_flip_card:init/1,
        fun cross_scuffle_elite_war_team_init:init/1,
        fun fashion_suit_init:init/1,
        fun xian_init:init/1,
       fun cross_mining_init:init/1,
        fun equip_suit:init/1,
        fun pet_war:init/1,
        fun godness_init:init/1,
        fun guild_fight_init:init/1,
        fun vip_face:init/1,
        fun element_init:init/1,
        fun time_limit_wing:init/1,
        fun limit_vip:init/1,
        fun player_awake:init/1,
        fun market_init:init/1,
        fun log_cbp:init/1,
        fun player_fcm:init/1,
        %%任务初始化放尾部
        fun task_init:init/1
    ]),


    player_play_point:init(Player),%%所有的初始化完成后，需要把副本次数等各种玩法次数集合起来，用于客户端的玩法面板显示
    Player2 = player_util:count_player_attribute(Player),
    Player3 = recharge:update(Player2),
    lib_dict:put(?LOGIN_FINISH, true),
    ProcName = misc:player_process_name(Key),
    Self = self(),
    misc:register(local, ProcName, Self),
    erlang:send_after(5000, Self, {timer, 0}),
    erlang:send_after(1000, Self, login_finish), %%登录完成，可在回调中做一些必要的登录刷新和通知
    player_init:save_online(Player3),
    put(?CMD_LOG, []),
    {ok, Player3}.


handle_call(_Request, _From, State) ->
    case config:is_catch_err() of
        true ->
            case catch player_handle:handle_call(_Request, _From, State) of
                {reply, Reply, NewState} when is_record(NewState, player) ->
                    {reply, Reply, NewState};
                {stop, _Reason, NewState} ->
                    {stop, _Reason, NewState};
                Other ->
                    ?ERR("handle_call ~p ~n error ~p ~n", [_Request, Other]),
                    {reply, ok, State}
            end;
        false ->
            player_handle:handle_call(_Request, _From, State)
    end.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------

handle_cast(_Request, State) ->
    case config:is_catch_err() of
        true ->
            case catch player_handle:handle_cast(_Request, State) of
                {noreply, NewState} when is_record(NewState, player) ->
                    {noreply, NewState};
                {stop, _Reason, NewState} ->
                    {stop, _Reason, NewState};
                Other ->
                    ?ERR("handle_cast ~p ~n error ~p ~n", [_Request, Other]),
                    {noreply, State}
            end;
        false ->
            player_handle:handle_cast(_Request, State)
    end.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------

handle_info(_Info, State) ->
    case config:is_catch_err() of
        true ->
            case catch player_handle:handle_info(_Info, State) of
                {noreply, NewState} when is_record(NewState, player) ->
                    {noreply, NewState};
                {stop, _Reason, NewState} ->
                    {stop, _Reason, NewState};
                Other ->
                    ?ERR("handle_info ~p ~n error ~p ~n", [_Info, Other]),
                    {noreply, State}

            end;
        false ->
            player_handle:handle_info(_Info, State)
    end.



terminate(Reason, State) ->
    player_init:stop(State),
    ?DO_IF(Reason == normal, exit(self(), logout)),
    ok.

code_change(_OldVsn, State, _Extra) ->
    ?DEBUG("代码热更新[OldVsn:~w~n State:~w~n Extra:~w]", [_OldVsn, State, _Extra]),
    %% [_ | S] = tuple_to_list(State),
    %% S1 = S ++ [abcabc],
    %% NewState = list_to_tuple([role | S1]),
    %% {ok, NewState}.
    {ok, State}.

format_stats(_, _) ->
    state.

%-ifdef(debug).
%format_status(terminate, {_Dict, State}) ->
%    io:format("~p", [State]),
%    State.
%-else.
%format_status(terminate, {_Dict, State}) ->
%    io:format("~p", [State]),
%    State.
%-endif.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------
apply_chain(Player, []) ->
    Player;
apply_chain(Player = #player{}, [Fun | T]) ->
    case Fun(Player) of
        NewPlayer when is_record(NewPlayer, player) ->
            apply_chain(NewPlayer, T);
        Error ->
            ?ERR("apply_chain error ~p/ ~p ~n", [Fun, Error]),
            apply_chain(Player, T)
    end.
    
