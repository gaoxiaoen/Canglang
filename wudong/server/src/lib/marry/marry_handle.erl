%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 七月 2016 上午11:40
%%%-------------------------------------------------------------------
-module(marry_handle).
-author("fengzhenlin").

-include("common.hrl").
-include("marry.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("scene.hrl").

%% API
-export([
    handle_call/3, handle_cast/2, handle_info/2
]).

-include_lib("stdlib/include/ms_transform.hrl").

-define(EXP_TIMER, 30).
-define(GIFT_TIMER, 30).

%%巡游预约
handle_call({cruise_appointment, Type, Id, Mkey}, _From, State) ->
    Midnight = util:get_today_midnight(),
    Date =
        case Type of
            1 -> Midnight;
            2 -> Midnight + ?ONE_DAY_SECONDS;
            _ -> Midnight + 2 * ?ONE_DAY_SECONDS
        end,
    case marry_cruise:cruise_appointment(Date, Id, Mkey, State#marry_state.cruise_list) of
        {true, Time, CruiseList} ->
            {reply, {ok, Time}, State#marry_state{cruise_list = CruiseList}};
        Err ->
            ?DEBUG("Err:~p", [Err]),
            {reply, Err, State}

    end;

handle_call({check_cruise, Pkey}, _From, State) ->
    Reply =
        if State#marry_state.cruise_state == 0 -> {ok, 19};
            State#marry_state.car#wedding_car.boy#player.key == Pkey ->
                {ok, boy, State#marry_state.car#wedding_car.x, State#marry_state.car#wedding_car.y};
            State#marry_state.car#wedding_car.girl#player.key == Pkey ->
                {ok, girl, State#marry_state.car#wedding_car.x, State#marry_state.car#wedding_car.y};
            true ->
                {ok, guest, State#marry_state.car#wedding_car.x, State#marry_state.car#wedding_car.y}
        end,
    {reply, Reply, State};

handle_call({check_roll, Pkey}, _From, State) ->
    Ret = lists:keymember(Pkey, #cruise_roll.pkey, State#marry_state.roll_list),
    {reply, Ret, State};

handle_call(check_cruise_state, _From, State) ->
    Ret = State#marry_state.cruise_state == 1,
    {reply, Ret, State};

handle_call({check_cruise_state_mkey, Mkey}, _FRom, State) ->
    Ret = Mkey == State#marry_state.car#wedding_car.marry_key,
    {reply, Ret, State};

handle_call({get_cruise_state, _Pkey, Mkey}, _from, State) ->
    Ret =
        case marry_cruise:get_cruise_times(Mkey, State#marry_state.cruise_list) of
            0 -> 0;
            _ ->
                1
        end,
    {reply, Ret, State};

handle_call(_Info, _From, State) ->
    ?DEBUG("marry_handle call info ~p~n", [_Info]),
    {reply, ok, State}.

%%巡游时间表
handle_cast({cruise_time_list, Type, Sid, Mkey}, State) ->
    Data = marry_cruise:cruise_time_list(Type, Mkey, State#marry_state.cruise_list),
    {ok, Bin} = pt_288:write(28810, Data),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};


handle_cast({cruise_state, Sid}, State) ->
    Now = util:unixtime(),
    Data =
        if State#marry_state.cruise_state == 0 -> {0, 0, []};
            true ->
                F = fun(Player) ->
                    [Player#player.key, Player#player.nickname, Player#player.career, Player#player.sex, Player#player.avatar]
                    end,
                L = lists:map(F, [State#marry_state.car#wedding_car.boy, State#marry_state.car#wedding_car.girl]),
                {1, max(0, State#marry_state.cruise_time - Now), L}
        end,
    {ok, Bin} = pt_288:write(28814, Data),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_cast({check_cruise_state, Sid, Pkey, Mkey}, State) ->
    Now = util:unixtime(),
    if State#marry_state.cruise_state == 0 -> ok;
        true ->
            {ok, Bin} = pt_288:write(28812, {1, max(0, State#marry_state.cruise_time - Now)}),
            server_send:send_to_sid(Sid, Bin),
            if State#marry_state.car#wedding_car.marry_key == Mkey ->
                Nickname = ?IF_ELSE(State#marry_state.car#wedding_car.boy#player.key == Pkey, State#marry_state.car#wedding_car.girl#player.nickname, State#marry_state.car#wedding_car.boy#player.nickname),
                {ok, BinNotice} = pt_288:write(28813, {Nickname}),
                server_send:send_to_sid(Sid, BinNotice),
                ok;
                true ->
                    ok
            end
    end,
    {noreply, State};

handle_cast(_Info, State) ->
    ?DEBUG("marry_handle cast info ~p~n", [_Info]),
    {noreply, State}.

handle_info(init, State) ->
    marry_tree:init_ets(),
    marry_init:init_marry(),
    CruiseList = marry_init:init_cruise(),
    {noreply, State#marry_state{cruise_list = CruiseList}};

%%重置
handle_info({reset, Now}, State) ->
    Midnight = util:get_today_midnight(Now),
    marry_load:del_cruise(Midnight),
    F = fun(StCruise) ->
        ?IF_ELSE(StCruise#st_cruise.date < Midnight, [], [StCruise])
        end,
    CruiseList = lists:flatmap(F, State#marry_state.cruise_list),
    {noreply, State#marry_state{cruise_list = CruiseList}};

handle_info({cruise_timer, Now}, State) ->
    if State#marry_state.cruise_state == 0 ->
        case [StCruise || StCruise <- State#marry_state.cruise_list, StCruise#st_cruise.time >= Now - 10 andalso StCruise#st_cruise.time < Now + 10] of
            [] -> ok;
            [Val | _] ->
                self() ! {start_cruise, Val#st_cruise.akey}
        end;
        true -> ok
    end,
    {noreply, State};

handle_info(cmd_start, State) ->
    if State#marry_state.cruise_state == 0 ->
        Now = util:unixtime(),
        F = fun(StCruise) ->
            if StCruise#st_cruise.time >= Now ->
                case ets:lookup(?ETS_MARRY, StCruise#st_cruise.mkey) of
                    [] ->
                        [];
                    [StMarry] ->
                        if StMarry#st_marry.cruise == 0 ->
                            [StCruise];
                            true -> []
                        end
                end;
                true -> []
            end
            end,
        case lists:flatmap(F, State#marry_state.cruise_list) of
            [] -> ok;
            [Val | _] ->
                self() ! {start_cruise, Val#st_cruise.akey}
        end;
        true -> ok
    end,
    {noreply, State};

handle_info(cmd_end, State) ->
    if State#marry_state.cruise_state == 1 ->
        Mon = mon_agent:get_mon(?SCENE_ID_MAIN, 0, State#marry_state.car#wedding_car.mon_key),
        monster:stop_broadcast(Mon#mon.pid),
        handle_info({weeding_car_move_end, State#marry_state.car#wedding_car.mon_key}, State);
        true -> {noreply, State}
    end;

handle_info({start_cruise, Akey}, State) ->
    case lists:keyfind(Akey, #st_cruise.akey, State#marry_state.cruise_list) of
        false ->
            {noreply, State};
        StCruise ->
            case ets:lookup(?ETS_MARRY, StCruise#st_cruise.mkey) of
                [] ->
                    {noreply, State};
                [StMarry] ->
                    NewStMarry =
                        StMarry#st_marry{
                            cruise = StCruise#st_cruise.time
                        },
                    marry_load:replace_marry(NewStMarry),
                    ets:insert(?ETS_MARRY, NewStMarry),
                    [{X, Y, _} | LineList] = marry_cruise:get_cruise_line(),
                    MonKey = mon_agent:create_mon([?WEEDING_CAR_MID, ?SCENE_ID_MAIN, X, Y, 0, 1, [{walk, LineList}]]),
                    Ref = erlang:send_after(?EXP_TIMER * 1000, self(), exp_timer),
                    put(exp_timer, Ref),
                    Ref1 = erlang:send_after(?GIFT_TIMER * 1000, self(), gift_timer),
                    put(gift_timer, Ref1),
                    scene_copy_proc:set_default(?SCENE_ID_MAIN, true),
                    {ok, Bin} = pt_288:write(28812, {1, ?FIFTEEN_MIN_SECONDS}),
                    server_send:send_to_all(Bin),
                    Boy = shadow_proc:get_shadow(StMarry#st_marry.key_boy),
                    Girl = shadow_proc:get_shadow(StMarry#st_marry.key_girl),
                    Car = #wedding_car{mon_key = MonKey, marry_key = StMarry#st_marry.mkey, x = X, y = Y, boy = Boy, girl = Girl},
%%                    notice_sys:add_notice(weeding_cruise, [Boy, Girl]),
                    self() ! {cruise_notice, Boy, Girl},
                    msg_cruise_start(Boy, Girl),
                    {noreply, State#marry_state{cruise_time = util:unixtime() + ?FIFTEEN_MIN_SECONDS, cruise_state = 1, car = Car, roll_list = []}}
            end
    end;

handle_info({cruise_notice, Boy, Girl}, State) when State#marry_state.cruise_state == 1 ->
    notice_sys:add_notice(weeding_cruise, [Boy, Girl]),
    Ref = erlang:send_after(4 * 60 * 1000, self(), {cruise_notice, Boy, Girl}),
    put(cruise_notice, Ref),
    {noreply, State};

%%定时加经验
handle_info(exp_timer, State) ->
    misc:cancel_timer(exp_timer),
    Ref = erlang:send_after(?EXP_TIMER * 1000, self(), exp_timer),
    put(exp_timer, Ref),
    L = scene_agent:get_scene_player_pids(?SCENE_ID_MAIN, 0),
    F = fun(Pid) -> Pid ! weedding_car_exp end,
    lists:foreach(F, L),
    {noreply, State};

%%定时掉礼盒
handle_info(gift_timer, State) ->
    misc:cancel_timer(gift_timer),
    Ref = erlang:send_after(?GIFT_TIMER * 1000, self(), gift_timer),
    put(gift_timer, Ref),
    marry_cruise:gift_to_scene(State#marry_state.car#wedding_car.x, State#marry_state.car#wedding_car.y, ?WEEDING_CAR_GIFT_ID, 5),
    {noreply, State};


handle_info({update_weeding_car_position, MKey, X, Y}, State) ->
    Car = State#marry_state.car,
    if Car#wedding_car.mon_key == MKey ->
        NewCar = Car#wedding_car{x = X, y = Y},
        {ok, Bin} = pt_288:write(28821, {X, Y}),
        F = fun(Role) ->
            case player_util:get_player_pid(Role#player.key) of
                false -> ok;
                Pid ->
                    server_send:send_to_pid(Pid, Bin)
            end
            end,
        lists:foreach(F, [State#marry_state.car#wedding_car.boy, State#marry_state.car#wedding_car.girl]),
        {noreply, State#marry_state{car = NewCar}};
        true ->
            {noreply, State}
    end;

handle_info({weeding_car_move_end, MKey}, State) ->
    Car = State#marry_state.car,
    if Car#wedding_car.mon_key == MKey ->
        scene_copy_proc:set_default(?SCENE_ID_MAIN, false),
        misc:cancel_timer(exp_timer),
        misc:cancel_timer(gift_timer),
        {ok, Bin} = pt_288:write(28812, {0, 0}),
        server_send:send_to_all(Bin),
        F = fun(Role) ->
            case player_util:get_player_pid(Role#player.key) of
                false -> ok;
                Pid ->
                    Pid ! {cruise_state, 0}
            end
            end,
        lists:foreach(F, [State#marry_state.car#wedding_car.boy, State#marry_state.car#wedding_car.girl]),
        {noreply, State#marry_state{car = #wedding_car{}, roll_list = [], cruise_time = 0, cruise_state = 0}};
        true ->
            {noreply, State}
    end;


handle_info({add_roll, Roll}, State) ->
    Now = util:unixtime(),
    Ref = erlang:send_after((Roll#cruise_roll.time - Now) * 1000, self(), {roll_gift, Roll#cruise_roll.pkey}),
    put({roll_gift, Roll#cruise_roll.pkey}, Ref),
    L = L = scene_agent:get_area_scene_pkeys(?SCENE_ID_MAIN, 0, State#marry_state.car#wedding_car.x, State#marry_state.car#wedding_car.y),
    RollPlist = [{Key, 0} || Key <- L],
    NewRoll = Roll#cruise_roll{roll_plist = RollPlist},
    RollList = [NewRoll | State#marry_state.roll_list],
    spawn(fun() -> refresh_roll(NewRoll) end),
    {noreply, State#marry_state{roll_list = RollList}};

handle_info({roll, Sid, Pkey, Nickname, Key}, State) ->
    {Ret, RollList} =
        case lists:keytake(Key, #cruise_roll.pkey, State#marry_state.roll_list) of
            false ->
                {28, State#marry_state.roll_list};
            {value, Roll, T} ->
                Now = util:unixtime(),
                if Roll#cruise_roll.time < Now -> {29, State#marry_state.roll_list};
                    true ->
                        case lists:keytake(Pkey, 1, Roll#cruise_roll.roll_plist) of
                            false ->
                                Point = lists:delete(Roll#cruise_roll.point_h, lists:seq(1, 100)),
                                NewRoll =
                                    if Point > Roll#cruise_roll.point_h ->
                                        Roll#cruise_roll{point_h = Point, nickname_h = Nickname, pkey_h = Pkey, roll_plist = [{Pkey, Point} | Roll#cruise_roll.roll_plist]};
                                        true ->
                                            Roll#cruise_roll{roll_plist = [{Pkey, Point} | Roll#cruise_roll.roll_plist]}
                                    end,
                                spawn(fun() -> refresh_roll(NewRoll) end),
                                {1, [NewRoll | T]};
                            {value, {_, OldPoint}, L} ->
                                if OldPoint > 0 ->
                                    {30, State#marry_state.roll_list};
                                    true ->
                                        Point = util:list_rand(lists:delete(Roll#cruise_roll.point_h, lists:seq(1, 100))),
                                        NewRoll =
                                            if Point > Roll#cruise_roll.point_h ->
                                                Roll#cruise_roll{point_h = Point, nickname_h = Nickname, pkey_h = Pkey, roll_plist = [{Pkey, Point} | L]};
                                                true ->
                                                    Roll#cruise_roll{roll_plist = [{Pkey, Point} | L]}
                                            end,
                                        spawn(fun() -> refresh_roll(NewRoll) end),
                                        {1, [NewRoll | T]}
                                end
                        end
                end
        end,
    {ok, Bin} = pt_288:write(28818, {Ret}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State#marry_state{roll_list = RollList}};

handle_info({roll_gift, Key}, State) ->
    misc:cancel_timer({roll_gift, Key}),
    case lists:keyfind(Key, #cruise_roll.pkey, State#marry_state.roll_list) of
        false -> ok;
        Roll ->
            if Roll#cruise_roll.pkey_h == 0 -> ok;
                true ->
                    case player_util:get_player_pid(Roll#cruise_roll.pkey_h) of
                        false ->
                            {Title, Content} = ?IF_ELSE(Roll#cruise_roll.type == 3, t_mail:mail_content(105), t_mail:mail_content(106)),
                            NewContent = io_lib:format(Content, [Roll#cruise_roll.nickname]),
                            mail:sys_send_mail([Roll#cruise_roll.pkey_h], Title, NewContent, [{Roll#cruise_roll.goods_id, Roll#cruise_roll.goods_num}]),
                            ok;
                        Pid ->
                            Pid ! {give_goods, [{Roll#cruise_roll.goods_id, Roll#cruise_roll.goods_num}], 286}
                    end,
                    {ok, Bin} = pt_288:write(28819, {Roll#cruise_roll.pkey, Roll#cruise_roll.point_h, Roll#cruise_roll.nickname_h}),
                    F = fun({Pkey, _}) ->
                        server_send:send_to_key(Pkey, Bin)
                        end,
                    lists:foreach(F, Roll#cruise_roll.roll_plist),
                    notice_sys:add_notice(marry_roll, [Roll#cruise_roll.type, Roll#cruise_roll.pkey, Roll#cruise_roll.nickname, Roll#cruise_roll.pkey_h, Roll#cruise_roll.nickname_h]),
                    ok
            end
    end,
    {noreply, State};

handle_info({guest_gift, Nickname, GoodsId, Num}, State) ->
    {ok, Bin} = pt_288:write(28820, {Nickname, GoodsId}),
    server_send:send_to_scene(?SCENE_ID_MAIN, 0, State#marry_state.car#wedding_car.x, State#marry_state.car#wedding_car.y, Bin),
    F = fun(Role) ->
        case player_util:get_player_pid(Role#player.key) of
            false ->
                {Title, Content} = t_mail:mail_content(107),
                mail:sys_send_mail([Role#player.key], Title, io_lib:format(Content, [Nickname]), [{GoodsId, Num}]);
            Pid ->
                Pid ! {give_goods, [{GoodsId, Num}], 286}
        end
        end,
    lists:foreach(F, [State#marry_state.car#wedding_car.boy, State#marry_state.car#wedding_car.girl]),
    {noreply, State};

%%离婚,删除预约
handle_info({divorce, Mkey}, State) ->
    CruiseList =
        case lists:keytake(Mkey, #st_cruise.mkey, State#marry_state.cruise_list) of
            false -> State#marry_state.cruise_list;
            {value, StCruise, T} ->
                marry_load:del_cruise_by_key(StCruise#st_cruise.akey),
                T
        end,
    {noreply, State#marry_state{cruise_list = CruiseList}};

handle_info(cruise_list, State) ->
    Midnight = util:get_today_midnight(),
    ?WARNING("Midnight ~p cruise_list ~p~n", [Midnight, State#marry_state.cruise_list]),
    {noreply, State};

handle_info(fix_cruise_list, State) ->
    F = fun(StCruise) ->
        StCruise#st_cruise{time = util:to_integer(StCruise#st_cruise.time)}
        end,
    CruiseList =
        lists:map(F, State#marry_state.cruise_list),
    {noreply, State#marry_state{cruise_list = CruiseList}};

handle_info(_Info, State) ->
    ?DEBUG("marry_handle info ~p~n", [_Info]),
    {noreply, State}.


msg_cruise_start(Boy, Girl) ->
    {ok, BinBoy} = pt_288:write(28813, {Girl#player.nickname}),
    server_send:send_to_key(Boy#player.key, BinBoy),
    {ok, BinGirl} = pt_288:write(28813, {Boy#player.nickname}),
    server_send:send_to_key(Girl#player.key, BinGirl),
    ok.


refresh_roll(Roll) ->
    Now = util:unixtime(),
    LeftTime = max(0, Roll#cruise_roll.time - Now),
    F = fun({Pkey, Point}) ->
        {ok, Bin} = pt_288:write(28817, {Roll#cruise_roll.type, Roll#cruise_roll.nickname,
            Roll#cruise_roll.pkey, LeftTime, Roll#cruise_roll.goods_id, Roll#cruise_roll.goods_num,
            Roll#cruise_roll.point_h,
            Roll#cruise_roll.nickname_h,
            Point}),
        server_send:send_to_key(Pkey, Bin)
        end,
    lists:foreach(F, Roll#cruise_roll.roll_plist),
    ok.

