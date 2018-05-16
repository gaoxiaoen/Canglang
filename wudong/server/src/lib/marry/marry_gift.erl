%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 爱情香囊
%%% @end
%%% Created : 06. 七月 2017 17:17
%%%-------------------------------------------------------------------
-module(marry_gift).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("marry.hrl").
-include("marry_room.hrl").

%% API
-export([
    init/1,
    get_info/1,
    buy/1,
    recv/2,

    update_buy/2,
    get_state/0,
    get_ta_state/1,
    divorce/1,
    divorce/2,
    midnight_refresh/1,
    get_notice_state/1,
    get_send/1,
    get_gift_gold/1
]).

get_send(Player) ->
    if
        Player#player.marry#marry.couple_key == 0 -> 9; %% 当前未婚
        true ->
            CoupleKey = Player#player.marry#marry.couple_key,
            case ets:lookup(?ETS_ONLINE, CoupleKey) of
                [] -> 8; %% 对方不在线
                [#ets_online{sid = Sid, pid = _Pid}] ->
                    {ok, Bin} = pt_289:write(28905, {1}),
                    server_send:send_to_sid(Sid, Bin),
                    1
            end
    end.

get_state() ->
    StMarryGift = lib_dict:get(?PROC_STATUS_MARRY_GIFT),
    StMarryGift#st_marry_gift.buy_type.

get_ta_state(Pkey) ->
    if
        Pkey == 0 -> 0;
        true ->
            StMarryGift = lib_dict:get(?PROC_STATUS_MARRY_GIFT),
            StMarryGift#st_marry_gift.is_buy
    end.

init(#player{key = Pkey} = Player) ->
    IsMarry = ?IF_ELSE(Player#player.marry#marry.mkey == 0, 0, 1),
    StMarryGift =
        case player_util:is_new_role(Player) of
            true ->
                #st_marry_gift{pkey = Pkey};
            false ->
                if
                    IsMarry == 0 ->
                        #st_marry_gift{pkey = Pkey};
                    true ->
                        BuyOutTime = marry_load:dbget_marry_gift_out_time(Player#player.marry#marry.couple_key),
                        St0 = marry_load:dbget_marry_gift(Pkey),
                        Now = util:unixtime(),
                        if
                            BuyOutTime == 0 -> St0#st_marry_gift{is_buy = 0};
                            BuyOutTime < Now -> St0#st_marry_gift{is_buy = 0};
                            true -> St0
                        end
                end
        end,
    lib_dict:put(?PROC_STATUS_MARRY_GIFT, StMarryGift),
    update_marry_gift(),
    Player.

update_marry_gift() ->
    St = lib_dict:get(?PROC_STATUS_MARRY_GIFT),
    Now = util:unixtime(),
    if
        St#st_marry_gift.buy_out_time =< Now ->
            lib_dict:put(?PROC_STATUS_MARRY_GIFT, #st_marry_gift{pkey = St#st_marry_gift.pkey, is_buy = St#st_marry_gift.is_buy});
        true ->
            case util:is_same_date(Now, St#st_marry_gift.op_time) of
                true ->
                    skip;
                false ->
                    NewSt = St#st_marry_gift{op_time = Now, daily_recv = 0},
                    lib_dict:put(?PROC_STATUS_MARRY_GIFT, NewSt)
            end
    end.

midnight_refresh(_) ->
    update_marry_gift().

get_info(Player) ->
    if
        Player#player.marry#marry.mkey == 0 ->
            RemainTime = 0,
            #base_marry_gift{cost = Cost, first_goods = FirstGoods, daily_goods = RecvGoods} = data_marry_gift:get(1),
            ProFirstGoods = lists:map(fun({Id, Num}) -> [Id, Num] end, FirstGoods),
            ProRecvGoods = lists:map(fun({Id, Num}) -> [Id, Num] end, RecvGoods),
            {0, 0, <<>>, 0, 0, <<>>, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, RemainTime, Cost, ProFirstGoods, ProRecvGoods};
        true ->
            IsMarry = 1,
            Pkey = Player#player.marry#marry.couple_key,
            MarryType = Player#player.marry#marry.marry_type,
            #base_marry_gift{cost = Cost, first_goods = FirstGoods, daily_goods = RecvGoods} = data_marry_gift:get(MarryType),
            Shadow = shadow_proc:get_shadow(Pkey),
            NickName = Shadow#player.nickname,
            Career = Shadow#player.career,
            Sex = Shadow#player.sex,
            Avatar = Shadow#player.avatar,

            StMarryGift = lib_dict:get(?PROC_STATUS_MARRY_GIFT),
            #st_marry_gift{
                buy_type = BuyType,
                recv_first = RecvFirst,
                daily_recv = DailyRecv,
                buy_out_time = BuyOutTime,
                is_buy = IsBuy
            } = StMarryGift,
            RemainTime = max(0, BuyOutTime - util:unixtime()),
            ProFirstGoods = lists:map(fun({Id, Num}) -> [Id, Num] end, FirstGoods),
            ProRecvGoods = lists:map(fun({Id, Num}) -> [Id, Num] end, RecvGoods),

            RecvFirstStatus =
                if
                    RecvFirst == 1 -> 2;
                    BuyType > 0 -> 1;
                    true -> 0
                end,
            DailyRecvStatus =
                if
                    DailyRecv == 1 -> 2;
                    BuyType > 0 -> 1;
                    true -> 0
                end,

            {IsMarry,
                Pkey,
                NickName,
                Career,
                Sex,
                Avatar,
                Shadow#player.lv,
                Shadow#player.wing_id,
                Shadow#player.equip_figure#equip_figure.weapon_id,
                Shadow#player.equip_figure#equip_figure.clothing_id,
                Shadow#player.light_weaponid,
                Shadow#player.fashion#fashion_figure.fashion_cloth_id,
                Shadow#player.fashion#fashion_figure.fashion_head_id,

                BuyType, IsBuy, RecvFirstStatus, DailyRecvStatus, RemainTime, Cost, ProFirstGoods, ProRecvGoods}
    end.

buy(Player) ->
    case check_buy(Player) of
        {fail, Code} -> {Code, Player};
        {true, Pkey, Cost} ->
            StMarryGift = lib_dict:get(?PROC_STATUS_MARRY_GIFT),
            MarryType = Player#player.marry#marry.marry_type,
            #base_marry_gift{time = Days} = data_marry_gift:get(MarryType),
            NewPlayer = money:add_no_bind_gold(Player, -Cost, 646, 0, 0),
            case ets:lookup(?ETS_ONLINE, Pkey) of
                [#ets_online{pid = Pid}] ->
                    player:apply_state(async, Pid, {marry_gift, update_buy, []}),
                    Pid ! {marry_gift, 28901};
                _ ->
                    %% 修改另一个玩家数据
                    TaSt = marry_load:dbget_marry_gift(Pkey),
                    NewTaSt = TaSt#st_marry_gift{recv_first=0, daily_recv=0,buy_type = 1, buy_out_time = util:unixdate() + Days * ?ONE_DAY_SECONDS - 1, op_time = util:unixtime()},
                    marry_load:dbup_marry_gift(NewTaSt)
            end,
            NewStMarryGift = StMarryGift#st_marry_gift{is_buy = 1, op_time = util:unixtime()},
            lib_dict:put(?PROC_STATUS_MARRY_GIFT, NewStMarryGift),
            marry_load:dbup_marry_gift(NewStMarryGift),
            activity:get_notice(Player, [135], true),
            {1, NewPlayer}
    end.

update_buy(_, Player) ->
    StMarryGift = lib_dict:get(?PROC_STATUS_MARRY_GIFT),
    MarryType = Player#player.marry#marry.marry_type,
    #base_marry_gift{time = Days} = data_marry_gift:get(MarryType),
    NewStMarryGift = StMarryGift#st_marry_gift{recv_first=0, daily_recv=0, buy_type = 1, op_time = util:unixtime(), buy_out_time = util:unixdate() + Days * ?ONE_DAY_SECONDS},
    lib_dict:put(?PROC_STATUS_MARRY_GIFT, NewStMarryGift),
    marry_load:dbup_marry_gift(NewStMarryGift),
    activity:get_notice(Player, [135], true),
    {ok, Player}.

check_buy(Player) ->
    MarryType = Player#player.marry#marry.marry_type,
    StMarryGift = lib_dict:get(?PROC_STATUS_MARRY_GIFT),
    if
        Player#player.marry#marry.mkey == 0 -> {fail, 4}; %% 没有介乎对象
        StMarryGift#st_marry_gift.is_buy == 1 -> {fail, 6}; %% 已经为对方购买
        true ->
            #base_marry_gift{cost = Cost} = data_marry_gift:get(MarryType),
            Flag = money:is_enough(Player, Cost, gold),
            if
                Flag == false -> {fail, 5}; %% 元宝不足
                true ->
                    {true, Player#player.marry#marry.couple_key, Cost}
            end
    end.

recv(Player, Type) ->
    case check_recv(Player, Type) of
        {fail, Code} ->
            {Code, Player};
        {true, GoodsList} ->
            StMarryGift = lib_dict:get(?PROC_STATUS_MARRY_GIFT),
            if
                Type == 1 ->
                    GiveGoodsList = goods:make_give_goods_list(647, GoodsList),
                    NewStMarryGift = StMarryGift#st_marry_gift{recv_first = 1, op_time = util:unixtime()};
                true ->
                    GiveGoodsList = goods:make_give_goods_list(648, GoodsList),
                    NewStMarryGift = StMarryGift#st_marry_gift{daily_recv = 1, op_time = util:unixtime()}
            end,
            lib_dict:put(?PROC_STATUS_MARRY_GIFT, NewStMarryGift),
            marry_load:dbup_marry_gift(NewStMarryGift),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            activity:get_notice(Player, [135], true),
            {1, NewPlayer}
    end.

check_recv(Player, Type) ->
    StMarryGift = lib_dict:get(?PROC_STATUS_MARRY_GIFT),
    MarryType = Player#player.marry#marry.marry_type,
    Now = util:unixtime(),
    if
        Player#player.marry#marry.mkey == 0 ->
            {fail, 2}; %% 未婚状态
        StMarryGift#st_marry_gift.buy_out_time < Now -> {fail, 7}; %% 香囊过期
        true ->
            #base_marry_gift{first_goods = FirstGoods, daily_goods = DailyGoods} = data_marry_gift:get(MarryType),
            case Type of
                1 -> %% 判断固定奖励是否被领取
                    ?IF_ELSE(StMarryGift#st_marry_gift.recv_first == 1, {fail, 3}, {true, FirstGoods});
                2 -> %% 判断每日奖励是否被领取
                    ?IF_ELSE(StMarryGift#st_marry_gift.daily_recv == 1, {fail, 3}, {true, DailyGoods})
            end
    end.

%% 离婚处理
divorce(Player) ->
    lib_dict:put(?PROC_STATUS_MARRY_GIFT, #st_marry_gift{pkey = Player#player.key}),
    marry_load:dbdelete_marry_gift(Player#player.key),
    activity:get_notice(Player, [135], true),
    MarryPkey = Player#player.marry#marry.couple_key,
    case ets:lookup(?ETS_ONLINE, MarryPkey) of
        [#ets_online{pid = Pid}] ->
            player:apply_state(async, Pid, {marry_gift, divorce, []});
        _ ->
            %% 修改另一个玩家数据
            marry_load:dbdelete_marry_gift(MarryPkey)
    end.

divorce(_, Player) ->
    lib_dict:put(?PROC_STATUS_MARRY_GIFT, #st_marry_gift{pkey = Player#player.key}),
    marry_load:dbdelete_marry_gift(Player#player.key),
    activity:get_notice(Player, [135], true),
    {ok, Player}.

get_notice_state(Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_GIFT),
    #st_marry_gift{recv_first = RecvFirst, daily_recv = DailyRecv, buy_type = BuyType} = St,
    if
        Player#player.marry#marry.couple_key == 0 -> 0;
        BuyType == 0 -> 0;
        RecvFirst == 1 andalso DailyRecv == 1 -> 0;
        true -> 1
    end.

get_gift_gold(Player) ->
    case Player#player.marry#marry.couple_key == 0 of
        true -> 0;
        false ->
            MarryType = Player#player.marry#marry.marry_type,
            #base_marry_gift{cost = Cost} = data_marry_gift:get(MarryType),
            Cost
    end.