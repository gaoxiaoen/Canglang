%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 05. 三月 2015 20:24
%%%-------------------------------------------------------------------
-module(charge).
-author("fzl").
-include("charge.hrl").
-include("server.hrl").
-include("common.hrl").
-include("vip.hrl").
-include("goods.hrl").
%% 协议接口
-export([
    get_charge_info/1
]).

-define(CHARGE_CARD_RATIO, data_version_different:get(10)).
%% api
-export([
    is_first_pay/1,  %%是否首冲
    add_charge/3,  %%增加充值
    charge_gold/1
]).

-export([
    cmd_charge_return/0,
    init_charge_return/1,
    cmd_charge_return1/0,
    init_charge_return_bg/0,
    charge_return/1  %%充值返还
]).

-export([
    use_recharge_card/3,
    get_charge_acc_times/0
]).

charge_gold(Val) ->
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    ChargeSt#st_charge.total_gold >= Val orelse ChargeSt#st_charge.total_fee >= Val orelse ChargeSt#st_charge.return_time > 0.

%%获取充值信息
get_charge_info(Player) ->
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    Lan = version:get_lan_config(),
    F = fun(Id) ->
        case data_charge:get(Id, Player#player.pf) of
            [] -> [];
            BaseCharge ->
                #base_charge{
                    type = Type,
                    price = Price,
                    get_gold = GetGold,
                    first_get_gold = FirstGetGold,
                    second_get_gold = SecondGetGold,
                    goods_id = GoodsId,
                    is_month_card = IsMonthCard,
                    commend = Commend,
                    refresh_time = RefreshTimeList,
                    charge_gift_day = ChargeGiftDay,
                    charge_gift_bgold = ChargeGiftBgold
                } = BaseCharge,
                ChargeItem = get_charge_item(Id, ChargeSt#st_charge.dict),
                LimGiveTime =
                    case RefreshTimeList =/= [] of
                        true -> -1;
                        false -> 0
                    end,
                FreeGold =
                    case ChargeItem#charge.times == 0 of
                        true -> FirstGetGold;
                        false -> SecondGetGold
                    end,
                MonthCardLeaveDay =
                    case ChargeGiftDay > 0 of
                        false -> 0;
                        true ->
                            case Lan of
                                bt ->
                                    month_card_proc:get_left_day(Player#player.key, Id);
                                vietnam ->
                                    month_card_proc:get_left_day(Player#player.key, Id);
                                _ ->
                                    charge_gift_proc:get_left_day(Player)
                            end
                    end,
                BackPercent = consume_back_charge:get_back_percent(GetGold),
                [[Id, Type, Price, GetGold, FreeGold, LimGiveTime, GoodsId, IsMonthCard, MonthCardLeaveDay, Commend, ChargeGiftDay, ChargeGiftBgold, BackPercent]]
        end
        end,
    IdList =
        case Lan of
            bt ->
                [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 101, 102];
            _ ->
                case Player#player.pf of
                    10133 ->
                        %%%%大蓝正版1,2 102189
                        if Player#player.game_channel_id == 102189 ->
                            [1, 2, 4, 6, 7, 8, 9, 100];
                            true ->
                                [1, 2, 3, 4, 5, 6, 7, 8, 9, 100]
                        end;
                    _ ->
                        case util:to_atom(Player#player.login_flag) of
                            ios ->
                                [1, 2, 3, 4, 5, 6, 7, 8, 9, 100];
                            _ ->
                                [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 100]
                        end
                end
        end,
    List = lists:flatmap(F, IdList),
    {ok, Bin} = pt_460:write(46000, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%是否首冲
is_first_pay(Id) ->
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    Charge = get_charge_item(Id, ChargeSt#st_charge.dict),
    Charge#charge.times == 0.

%%增加充值
add_charge(Id, TotalFee, TotalGold) ->
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    Charge = get_charge_item(Id, ChargeSt#st_charge.dict),
    NewCharge = Charge#charge{
        times = Charge#charge.times + 1,
        last_time = util:unixtime()
    },
    NewDict = dict:store(Id, NewCharge, ChargeSt#st_charge.dict),
    NewChargeSt = ChargeSt#st_charge{
        dict = NewDict,
        total_fee = ChargeSt#st_charge.total_fee + TotalFee,
        total_gold = ChargeSt#st_charge.total_gold + TotalGold
    },
    lib_dict:put(?PROC_STATUS_CHARGE, NewChargeSt),
    charge_load:dbup_charge_info(NewChargeSt),
    charge_init:update(),
    ok.

%%获取总充值次数
get_charge_acc_times() ->
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    lists:sum([Charge#charge.times || {_, Charge} <- dict:to_list(ChargeSt#st_charge.dict)]).

%%获取单项充值信息
get_charge_item(Id, Dict) ->
    case dict:find(Id, Dict) of
        error ->
            #charge{
                id = Id
            };
        {_, Charge} -> Charge
    end.

%%开服充值返还
charge_return(Player) ->
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    ServerNum = config:get_server_num(),
    case lists:member(ServerNum, [2501, 3001, 3501, 2506]) of
        true ->
            do_charge_return_bg(Player),
            case ChargeSt#st_charge.return_time > 0 of
                true ->
                    Player;
                false ->
                    do_charge_return(Player)
            end;
        false ->
            Player
    end.

do_charge_return(Player) ->
    case charge_load:get_charge_return(Player#player.accname, Player#player.pf) of
        [] -> Player;
        [TotalFee, State] ->
            if State == 1 -> Player;
                true ->
                    Now = util:unixtime(),
                    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
                    NewChargeSt = ChargeSt#st_charge{return_time = Now},
                    lib_dict:put(?PROC_STATUS_CHARGE, NewChargeSt),
                    charge_load:dbup_charge_info(NewChargeSt),
                    charge_load:dbup_chage_return(Player#player.accname, Player#player.pf, Now),
                    Money = round(TotalFee / 100),
                    ChargeGold = round(TotalFee / 10),

                    Player1 = money:add_gold(Player, ChargeGold, 121, 0, 0),
                    self() ! {recharge, TotalFee, ChargeGold, ChargeGold},
                    Title = ?T("充值返还"),
                    case calc_bgold(Money, ChargeGold) of
                        0 -> ok;
                        BGold ->
                            Msg = io_lib:format(?T("亲爱的玩家：您好，感谢您一直以来对我们的支持，《武动九天》不删档测试强势归来，您于删档计费测试期间的充值金额已全额返还到您的账号，额外赠送部分的绑定元宝请于邮件附件中提取，祝您游戏愉快。"), []),
                            mail:sys_send_mail([Player#player.key], Title, Msg, [{?GOODS_ID_BGOLD, BGold}])
                    end,
                    Player1
            end
    end.

calc_bgold(Money, Gold) ->
    if Money =< 500 -> util:ceil(Gold * 0.6);
        Money =< 2000 -> util:ceil(Gold * 0.7);
        Money =< 4999 -> util:ceil(Gold * 0.8);
        Money =< 10000 -> util:ceil(Gold * 0.9);
        true -> util:ceil(Gold * 1)
    end.

do_charge_return_bg(Player) ->
    Sql = io_lib:format("select bgold,state from player_charge_return_bg where accname='~s' and pf=~p", [Player#player.accname, Player#player.pf]),
    case db:get_row(Sql) of
        [] -> skip;
        [Bgold, State] ->
            if State == 1 -> skip;
                true ->
                    Title = ?T("充值返还"),
                    Msg = io_lib:format(?T("亲爱的玩家：您好，感谢您一直以来对我们的支持，《武动九天》不删档测试强势归来，您于删档计费测试期间的充值金额已全额返还到您的账号，首充赠送的绑定元宝请于邮件附件中提取，祝您游戏愉快。"), []),
                    mail:sys_send_mail([Player#player.key], Title, Msg, [{?GOODS_ID_BGOLD, Bgold}]),
                    Sql1 = io_lib:format("update player_charge_return_bg set state = 1,time=~p where accname='~s' and pf=~p ", [util:unixtime(), Player#player.accname, Player#player.pf]),
                    db:execute(Sql1)
            end
    end.


%%do_charge_reward(Player) ->
%%    Url = lists:concat([config:get_api_url(), "/charge_reward.php"]),
%%    PostData = io_lib:format("accname=~s&pf=~p", [Player#player.accname, Player#player.pf]),
%%    %开发服test
%%    %Url = "http://120.27.140.254:8080/charge_reward.php",
%%    %PostData=io_lib:format("accname=~s&pf=~p",["00642f41aae3cf38c1d79eefd1f04378",13]),
%%    PostData2 = unicode:characters_to_list(PostData, unicode),
%%    case httpc:request(post, {Url, [], "application/x-www-form-urlencoded", PostData2}, [], []) of
%%        {ok, {_, _, Body}} ->
%%            case rfc4627:decode(Body) of
%%                {ok, {obj, JSONlist}, _} ->
%%                    case lists:keyfind("ret", 1, JSONlist) of
%%                        {_, 1} ->
%%                            ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
%%                            NewChargeSt = ChargeSt#st_charge{return_time = util:unixtime()},
%%                            lib_dict:put(?PROC_STATUS_CHARGE, NewChargeSt),
%%                            charge_load:dbup_charge_info(NewChargeSt),
%%
%%                            {_, TotalFeeBin} = lists:keyfind("totalfee", 1, JSONlist),
%%                            TotalFee = util:to_integer(TotalFeeBin),
%%                            Money = round(TotalFee / 100),
%%                            ChargeGold = round(TotalFee / 10),
%%                            Gold = ChargeGold,
%%                            Title = ?T("充值返还"),
%%                            case calc_bgold(Money, Gold) of
%%                                0 -> ok;
%%                                BGold ->
%%                                    Msg = io_lib:format(?T("亲爱的玩家：您好，感谢您一直以来对我们的支持，《武动九天》不删档测试强势归来，您于删档计费测试期间的充值金额已全额返还到您的账号，额外赠送部分的绑定元宝请于邮件附件中提取，祝您游戏愉快。"), []),
%%                                    mail:sys_send_mail([Player#player.key], Title, Msg, [{?GOODS_ID_BGOLD, BGold}])
%%                            end,
%%                            Player1 = money:add_no_bind_gold(Player, Gold, 301, 0, 0),
%%                            vip:add_vip_exp(Player1, ChargeGold);
%%                        {_, 0} ->
%%                            ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
%%                            NewChargeSt = ChargeSt#st_charge{return_time = 1},
%%                            lib_dict:put(?PROC_STATUS_CHARGE, NewChargeSt),
%%                            charge_load:dbup_charge_info(NewChargeSt),
%%                            Player;
%%                        _Err ->
%%                            Player
%%                    end;
%%                _Err ->
%%                    Player
%%            end;
%%        _Err ->
%%            Player
%%    end.



use_recharge_card(Player, Pay, Num) ->
    %%首冲、多倍充值赠送
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    case data_charge:get_by_price(Pay, Player#player.pf) of
        [] -> {ok, Player};
        BaseCharge ->
            #base_charge{
                id = ProductId,
                price = Price,
                get_gold = GetGold,
                first_get_gold = FirstGetGold,
                second_get_gold = SecondGetGold
            } = BaseCharge,
            %%充值换元宝比例
            GoldPro = GetGold / Price,
            FirGoldPro = FirstGetGold / Price,
            SecGoldPro = SecondGetGold / Price,
            %%基础元宝
            BaseGetGold = round(Pay * GoldPro),
            FinalGetGold = BaseGetGold * Num,

            Player#player.pid ! {recharge, Pay * ?CHARGE_CARD_RATIO, FinalGetGold, FinalGetGold},
            OtherAddGold =
                case charge_mul:get_charge_mul(BaseGetGold) of
                    0 ->
                        %%首冲赠送元宝
                        Charge = get_charge_item(ProductId, ChargeSt#st_charge.dict),
                        case Charge#charge.times == 0 of
                            true -> round(Pay * FirGoldPro);
                            false -> round(Pay * SecGoldPro)
                        end;
                    Mul ->
                        round(BaseGetGold * (Mul / ?CHARGE_CARD_RATIO - 1))
                end,
            Player1 = money:add_gold(Player, FinalGetGold, 161, 0, 0),
            IsBt = version:get_lan_config(),
            case IsBt of
                bt -> NewPlayer = money:add_gold(Player1, OtherAddGold, 121, 0, 0);
                _ ->
                    NewPlayer = money:add_bind_gold(Player1, OtherAddGold, 121, 0, 0)
            end,
            charge:add_charge(ProductId, Pay * ?CHARGE_CARD_RATIO, FinalGetGold),
            {ok, NewPlayer}
    end.

init_charge_return(Data) ->
    F = fun([AccName, Pf, TotalFee], L) ->
        Key = {AccName, Pf},
        case lists:keytake(Key, 1, L) of
            false ->
                [{Key, TotalFee} | L];
            {value, {_, Val}, T} ->
                [{Key, TotalFee + Val} | T]
        end
        end,
    ChargeList = lists:foldl(F, [], Data),
    db:execute("truncate player_charge_return"),
    F1 = fun({{AccName, Pf}, TotalFee}) ->
        Sql1 = io_lib:format("insert into player_charge_return set accname='~s',pf=~p,total_fee=~p,state=~p,time=~p",
            [AccName, Pf, TotalFee, 0, 0]),
        db:execute(Sql1)
         end,
    lists:foreach(F1, ChargeList),
    ok.


cmd_charge_return() ->
    Sql = io_lib:format("select user_id,channel_id,total_fee from recharge where state =~p", [0]),
    Data = db:get_all(Sql),
    init_charge_return(Data),
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    NewChargeSt = ChargeSt#st_charge{return_time = 0},
    lib_dict:put(?PROC_STATUS_CHARGE, NewChargeSt),
    charge_load:dbup_charge_info(NewChargeSt),
    ok.


cmd_charge_return1() ->
    F = fun(Sn) ->
        Table = list_to_atom(lists:concat(["recharge", Sn])),
        ?DEBUG("table ~p~n", [Table]),
        Sql = io_lib:format("select user_id,channel_id,total_fee from ~w where state =~p", [Table, 0]),
        db:get_all(Sql)
        end,
    Data = lists:flatmap(F, [2501, 2502, 2503, 2504, 2505]),
    init_charge_return(Data).


init_charge_return_bg() ->
    db:execute("truncate player_charge_return_bg"),
    F = fun(Sn) ->
        Table = list_to_atom(lists:concat(["recharge", Sn])),
        ?DEBUG("table ~p~n", [Table]),
        Sql = io_lib:format("select user_id,channel_id,total_fee from ~w where state =~p", [Table, 0]),
        db:get_all(Sql)
        end,
    Data = lists:flatmap(F, [2501, 2502, 2503, 2504, 2505]),

    F1 = fun([AccName, Pf, TotalFee], L) ->
        Key = {AccName, Pf},
        case lists:keytake(Key, 1, L) of
            false ->
                [{Key, [TotalFee]} | L];
            {value, {_, Log}, T} ->
                [{Key, [TotalFee | Log]} | T]
        end
         end,
    ChargeList = lists:foldl(F1, [], Data),

    F2 = fun({{AccName, Pf}, Log}) ->
        case lists:sum(util:list_filter_repeat(Log)) of
            0 -> skip;
            Money ->
                Bgold = round(Money / 10),
                Sql1 = io_lib:format("insert into player_charge_return_bg set accname='~s',pf=~p,bgold=~p,state=~p,time=~p",
                    [AccName, Pf, Bgold, 0, 0]),
                db:execute(Sql1)
        end
         end,
    lists:foreach(F2, ChargeList),
    ok.
