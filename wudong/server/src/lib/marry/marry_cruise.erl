%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 七月 2017 20:02
%%%-------------------------------------------------------------------
-module(marry_cruise).
-author("hxming").
-include("marry.hrl").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("goods.hrl").
%% API
-export([
    get_cruise_state/1,
    cruise_time_list/3
    , cruise_appointment/4
    , get_cruise_line/0
    , app_mail/2
    , invite_mail/4
    , invite_mail_couple/4
    , update_weeding_car_position/3
    , weeding_car_move_end/1
    , cruise_act/2
    , gift_to_scene/4
    , get_notice_state/1
    , get_cruise_times/2
    , cruise_buy/1
]).
-export([reset/1,add_times/1]).

get_notice_state(Player) ->
    case get_cruise_state(Player) of
        0 -> 0;
        _ -> 1
    end.

get_cruise_state(Player) ->
    if Player#player.marry#marry.mkey == 0 -> 0;
        true ->
            case data_marry:get(Player#player.marry#marry.marry_type) of
                [] -> 0;
                Base ->
                    if Base#base_marry.cruise == 0 -> 0;
                        true ->
                            case ?CALL(marry_proc:get_server_pid(), {get_cruise_state, Player#player.key, Player#player.marry#marry.mkey}) of
                                [] -> 0;
                                Ret ->
                                    Ret
                            end
                    end
            end
    end.


reset(Mkey) ->
    case ets:lookup(?ETS_MARRY, Mkey) of
        [] -> skip;
        [StMarry] ->
            NewStMarry =
                StMarry#st_marry{
                    cruise_num = StMarry#st_marry.cruise_num + 1
                },
            ets:insert(?ETS_MARRY, NewStMarry),
            marry_load:replace_marry(NewStMarry)
    end.

%%巡游时间列表
cruise_time_list(Type, Mkey, CruiseList) ->
    Now = util:unixtime(),
    Midnight = util:get_today_midnight(Now),
    Date =
        case Type of
            1 -> Midnight;
            2 -> Midnight + ?ONE_DAY_SECONDS;
            _ -> Midnight + 2 * ?ONE_DAY_SECONDS
        end,
    BaseMarry = data_marry:get(Type),
    CruiseTimes = get_cruise_times(Mkey, CruiseList),
    F = fun(Id) ->
        {Hour, Min} = data_cruise_time:get(Id),
        Sec = Hour * ?ONE_HOUR_SECONDS + Min * 60,
        CruiseTime = Date + Sec,
        AppState = cruise_state(Mkey, CruiseList, CruiseTime, Now),
        [Id, Hour, Min, AppState]
        end,
    Data = lists:map(F, data_cruise_time:get_all()),
    {CruiseTimes, BaseMarry#base_marry.cruise_price, Data}.

%%当前时间点状态
cruise_state(MKey, AppList, Time, Now) ->
    if
        Time < Now -> 0;
        true ->
            case lists:keyfind(Time, #st_cruise.time, AppList) of
                false -> 1;
                StCruise ->
                    ?IF_ELSE(StCruise#st_cruise.mkey == MKey, 3, 2)
            end
    end.

%%巡游预约
cruise_appointment(Date, Id, Mkey, CruiseList) ->
    if Mkey == 0 -> 13;
        true ->
            case ets:lookup(?ETS_MARRY, Mkey) of
                [] -> 13;
                [StMarry] ->
                    ?DEBUG("StMarry#st_marry.cruise_num:~p Date:~p", [StMarry#st_marry.cruise_num, Date]),
                    if
                        StMarry#st_marry.cruise_num == 0 -> 45;
                        true ->
                            case data_marry:get(StMarry#st_marry.type) of
                                [] -> 7;
                                _Base ->

                                    F0 = fun(#st_cruise{mkey = Mkey0, time = Time0}) ->
                                        Flag0 = util:is_same_date(Date, Time0),
                                        Mkey0 == Mkey andalso Flag0 == true
                                         end,
                                    PlayerCruiseList = lists:filter(F0, CruiseList),
%%                                     case lists:keymember(Mkey, #st_cruise.mkey, CruiseList) of
                                    ?DEBUG("PlayerCruiseList:~p", [PlayerCruiseList]),
                                    case PlayerCruiseList == [] of
                                        false -> 16;
                                        true ->
                                            case data_cruise_time:get(Id) of
                                                [] -> 17;
                                                {Hour, Min} ->
                                                    Time = Date + Hour * ?ONE_HOUR_SECONDS + Min * 60,
                                                    case lists:keymember(Time, #st_cruise.time, CruiseList) of
                                                        true -> 18;
                                                        false ->
                                                            Akey1 = misc:unique_key(),
                                                            StCruise = #st_cruise{akey = Akey1, date = Date, time = Time, mkey = Mkey},
                                                            marry_load:replace_cruise(StCruise),
                                                            NewStMayy = StMarry#st_marry{cruise_num = max(0, StMarry#st_marry.cruise_num - 1)},
                                                            ets:insert(?ETS_MARRY, NewStMayy),
                                                            log_marry_cruise(StMarry#st_marry.key_boy, StMarry#st_marry.key_girl, Akey1, Time, Mkey, StMarry#st_marry.cruise_num, max(0, StMarry#st_marry.cruise_num - 1)),
                                                            marry_load:replace_marry(NewStMayy),
                                                            {true, Time, [StCruise | CruiseList]}
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.


%%获取巡游线路
get_cruise_line() ->
    lists:map(fun(Id) -> data_cruise_line:get(Id) end, data_cruise_line:get_all()).

%%获取可预约巡游次数
get_cruise_times(Mkey, _CruiseList) ->
    if
        Mkey == 0 -> 0;
        true ->
            case ets:lookup(?ETS_MARRY, Mkey) of
                [] -> 0;
                [StMarry] ->
                    StMarry#st_marry.cruise_num
            end
    end.

%%预约成功邮件
app_mail(Player, TimeString) ->
    {Title, Content} = t_mail:mail_content(103),
    Content1 = io_lib:format(Content, [Player#player.marry#marry.couple_name, TimeString]),
    mail:sys_send_mail([Player#player.key], Title, Content1),
    Content2 = io_lib:format(Content, [Player#player.nickname, TimeString]),
    mail:sys_send_mail([Player#player.marry#marry.couple_key], Title, Content2),
    ok.

%%邮件邀请亲朋好友
invite_mail(Player, TimeString, InviteGuild, InviteFriend) ->
    GuildKeyList = ?IF_ELSE(InviteGuild == 1, guild_util:get_guild_member_key_list(Player#player.guild#st_guild.guild_key), []),
    FriendKeyList = ?IF_ELSE(InviteFriend == 1, relation:get_friend_list(), []),
    case GuildKeyList ++ FriendKeyList of
        [] -> ok;
        KeyList ->
            KeyList1 = util:list_filter_repeat(lists:delete(Player#player.key, KeyList)),
            {Title, Content} = t_mail:mail_content(104),
            {BoyName, GirlName} = ?IF_ELSE(Player#player.marry#marry.couple_sex == 1, {Player#player.marry#marry.couple_name, Player#player.nickname}, {Player#player.nickname, Player#player.marry#marry.couple_name}),
            Content1 = io_lib:format(Content, [TimeString, BoyName, GirlName]),
            mail:sys_send_mail(KeyList1, Title, Content1, [{7205002, 3}])
    end.

invite_mail_couple(Player, TimeString, InviteGuild, InviteFriend) ->
    case player_util:get_player_pid(Player#player.marry#marry.couple_key) of
        false ->
            ok;
        Pid ->
            Pid ! {cruise_invite_mail, TimeString, InviteGuild, InviteFriend}
    end,
    ok.


%%更新婚车位置
update_weeding_car_position(MKey, X, Y) ->
    marry_proc:get_server_pid() ! {update_weeding_car_position, MKey, X, Y},
    ok.

%%婚车移动结束
weeding_car_move_end(Mkey) ->
    marry_proc:get_server_pid() ! {weeding_car_move_end, Mkey}.


%%发红包
cruise_act(1, Player) ->
    if Player#player.marry#marry.cruise_state == 0 -> {21, Player};
        true ->
            Base = data_cruise_act:get(1),
            PriceType = ?IF_ELSE(Base#base_cruise.price_type == 1, gold, bgold),
            case money:is_enough(Player, Base#base_cruise.price, PriceType) of
                false ->
                    {9, Player};
                true ->
                    NewPlayer =
                        if PriceType == bgold ->
                            money:add_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num);
                            true ->
                                money:add_no_bind_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num)
                        end,
                    Couple = shadow_proc:get_shadow(Player#player.marry#marry.couple_key),
                    red_bag_proc:add_marry_red_bag(Player, Couple, [Base#base_cruise.goods_id]),
                    {1, NewPlayer}
            end
    end;
%%撒糖果
cruise_act(2, Player) ->
    if Player#player.marry#marry.cruise_state == 0 -> {21, Player};
        true ->
            Base = data_cruise_act:get(2),
            PriceType = ?IF_ELSE(Base#base_cruise.price_type == 1, gold, bgold),
            case money:is_enough(Player, Base#base_cruise.price, PriceType) of
                false ->
                    {9, Player};
                true ->
                    NewPlayer =
                        if PriceType == bgold ->
                            money:add_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num);
                            true ->
                                money:add_no_bind_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num)
                        end,
                    gift_to_scene(Player#player.x, Player#player.y, Base#base_cruise.goods_id, Base#base_cruise.num),
                    {1, NewPlayer}
            end
    end;
%%抛绣球
cruise_act(3, Player) ->
    if Player#player.marry#marry.cruise_state =/= 2 -> {23, Player};
        true ->
            case ?CALL(marry_proc:get_server_pid(), {check_roll, Player#player.key}) of
                false ->
                    Base = data_cruise_act:get(3),
                    Roll = #cruise_roll{type = 3, pkey = Player#player.key, nickname = Player#player.nickname, time = util:unixtime() + 30, goods_id = Base#base_cruise.goods_id, goods_num = Base#base_cruise.num},
                    marry_proc:get_server_pid() ! {add_roll, Roll},
                    {1, Player};
                _ ->
                    {26, Player}
            end
    end;
%%抛酒壶
cruise_act(4, Player) ->
    if Player#player.marry#marry.cruise_state =/= 1 -> {24, Player};
        true ->
            case ?CALL(marry_proc:get_server_pid(), {check_roll, Player#player.key}) of
                false ->
                    Base = data_cruise_act:get(4),
                    Roll = #cruise_roll{type = 4, pkey = Player#player.key, nickname = Player#player.nickname, time = util:unixtime() + 30, goods_id = Base#base_cruise.goods_id, goods_num = Base#base_cruise.num},
                    marry_proc:get_server_pid() ! {add_roll, Roll},
                    {1, Player};
                _ ->
                    {27, Player}
            end
    end;
%%送红枣
cruise_act(5, Player) ->
    if Player#player.marry#marry.cruise_state =/= 0 -> {25, Player};
        true ->
            case ?CALL(marry_proc:get_server_pid(), check_cruise_state) of
                false -> {19, Player};
                true ->
                    Base = data_cruise_act:get(5),
                    PriceType = ?IF_ELSE(Base#base_cruise.price_type == 1, gold, bgold),
                    case money:is_enough(Player, Base#base_cruise.price, PriceType) of
                        false ->
                            {9, Player};
                        true ->
                            NewPlayer =
                                if PriceType == bgold ->
                                    money:add_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num);
                                    true ->
                                        money:add_no_bind_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num)
                                end,
                            marry_proc:get_server_pid() ! {guest_gift, Player#player.nickname, Base#base_cruise.goods_id, Base#base_cruise.num},
                            {1, NewPlayer}
                    end
            end
    end;
%%送花生
cruise_act(6, Player) ->
    if Player#player.marry#marry.cruise_state =/= 0 -> {25, Player};
        true ->
            case ?CALL(marry_proc:get_server_pid(), check_cruise_state) of
                false -> {19, Player};
                true ->
                    Base = data_cruise_act:get(6),
                    PriceType = ?IF_ELSE(Base#base_cruise.price_type == 1, gold, bgold),
                    case money:is_enough(Player, Base#base_cruise.price, PriceType) of
                        false ->
                            {9, Player};
                        true ->
                            NewPlayer =
                                if PriceType == bgold ->
                                    money:add_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num);
                                    true ->
                                        money:add_no_bind_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num)
                                end,
                            marry_proc:get_server_pid() ! {guest_gift, Player#player.nickname, Base#base_cruise.goods_id, Base#base_cruise.num},
                            {1, NewPlayer}
                    end
            end
    end;
%%送桂圆
cruise_act(7, Player) ->
    if Player#player.marry#marry.cruise_state =/= 0 -> {25, Player};
        true ->
            case ?CALL(marry_proc:get_server_pid(), check_cruise_state) of
                false -> {19, Player};
                true ->
                    Base = data_cruise_act:get(7),
                    PriceType = ?IF_ELSE(Base#base_cruise.price_type == 1, gold, bgold),
                    case money:is_enough(Player, Base#base_cruise.price, PriceType) of
                        false ->
                            {9, Player};
                        true ->
                            NewPlayer =
                                if PriceType == bgold ->
                                    money:add_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num);
                                    true ->
                                        money:add_no_bind_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num)
                                end,
                            marry_proc:get_server_pid() ! {guest_gift, Player#player.nickname, Base#base_cruise.goods_id, Base#base_cruise.num},
                            {1, NewPlayer}
                    end
            end
    end;
cruise_act(_, Player) ->
    {0, Player}.

cruise_buy(Player) ->
    #marry{
        mkey = MKey,
        marry_type = MarryType
    } = Player#player.marry,
    #base_marry{
        cruise_price = CruisePrice
    } = data_marry:get(MarryType),
    case money:is_enough(Player, CruisePrice, gold) of
        false -> {9, Player};
        true ->
            NewPlayer = money:add_no_bind_gold(Player, -CruisePrice, 694, 0, 0),
            case ets:lookup(?ETS_MARRY, MKey) of
                [] -> skip;
                [StMarry] ->
                    NewStMarry =
                        StMarry#st_marry{
                            cruise_num = StMarry#st_marry.cruise_num + 1
                        },
                    ets:insert(?ETS_MARRY, NewStMarry),
                    log_marry_cruise_buy(Player#player.key, Player#player.nickname, CruisePrice, StMarry#st_marry.cruise_num, StMarry#st_marry.cruise_num + 1),
                    marry_load:replace_marry(NewStMarry)
            end,
            {1, NewPlayer}
    end.

%%礼物掉落到场景
gift_to_scene(X, Y, GoodsId, Num) when GoodsId > 0 andalso Num > 0 ->
    PosList = scene:get_area_position_list(?SCENE_ID_MAIN, X, Y, 3),
    GiveGoods = #give_goods{goods_id = GoodsId, num = 1, from = 286},
    F = fun({X1, Y1}) ->
        drop:drop_to_scene(0, GiveGoods, 1, ?SCENE_ID_MAIN, 0, X1, Y1, [], none, 0)
        end,
    lists:foreach(F, util:get_random_list(PosList, Num));
gift_to_scene(_, _, _, _) -> ok.


log_marry_cruise_buy(Pkey, NickName, Cost, OldCruiseNum, NewCruiseNum) ->
    Sql = io_lib:format(" insert into log_marry_cruise_buy (pkey,nickname,cost,old_cruise_num,new_cruise_num,time) VALUES (~p,'~s',~p,~p,~p,~p)",
        [Pkey, NickName, Cost, OldCruiseNum, NewCruiseNum, util:unixtime()]),
    log_proc:log(Sql),
    ok.

log_marry_cruise(KeyBoy, KeyGirl, Akey, Date, Mkey, OldCruiseNum, NewCruiseNum) ->
    BoyName = shadow_proc:get_name(KeyBoy),
    GirlName = shadow_proc:get_name(KeyGirl),
    Sql = io_lib:format(" insert into log_marry_cruise (key_boy,nickname_boy,key_girl,nickname_girl,akey,date,mkey,old_cruise_num,new_cruise_num,time) VALUES (~p,'~s',~p,'~s',~p,~p,~p,~p,~p,~p)",
        [KeyBoy, BoyName, KeyGirl, GirlName, Akey, Date, Mkey, OldCruiseNum, NewCruiseNum, util:unixtime()]),
    log_proc:log(Sql),
    ok.

add_times(MKey) ->
    case ets:lookup(?ETS_MARRY, MKey) of
        [] -> skip;
        [StMarry] ->
            NewStMarry =
                StMarry#st_marry{
                    cruise_num = StMarry#st_marry.cruise_num + 1
                },
            ets:insert(?ETS_MARRY, NewStMarry),
            marry_load:replace_marry(NewStMarry)
    end.