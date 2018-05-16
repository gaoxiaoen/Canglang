%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 三月 2015 上午10:07
%%%-------------------------------------------------------------------
-module(recharge).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("charge.hrl").
-include("mail.hrl").

%% API
-export([update/1]).

update(Player) ->
    Pkey = Player#player.key,
    Sql = io_lib:format("select id,jh_order_id,total_fee,product_id,pay_type from recharge where app_role_id = ~p and state = 1 and pay_result = 1", [Pkey]),
    Rows = db:get_all(Sql),
    Lan = version:get_lan_config(),
    recharge_helper(Rows, Player, Lan).


recharge_helper([], AccPlayer, _Lan) -> AccPlayer;
recharge_helper([[Id, Jh_order_id, TotalFee, InitProductId, PayType] | Tail], Player, Lan)
    when Lan == vietnam andalso InitProductId == 0 -> %%元宝充值
    %%paytype 1:APPLE|2:GOOGLD|3:card|4:BANK|5EWALLET
    Pf =
        if PayType == 1 -> 10000;
            PayType == 2 -> 0;
            true -> 10001
        end,
    %%以元为单位
    TotalPay = TotalFee,
    BaseCharge = data_charge:get_by_price(TotalPay, Pf),
    case BaseCharge of
        [] ->
            ?ERR("recharge handle err ~p~n", [{Id, Jh_order_id, TotalFee, InitProductId}]),
            recharge_helper(Tail, Player, Lan);
        _ ->

            #base_charge{
                id = ProductId,
                price = Price,
                get_gold = GetGold,
                first_get_gold = FirstGetGold,
                second_get_gold = SecondGetGold,
                goods_id = GoodsId
            } = BaseCharge,
            %%充值换元宝比例
            GoldPro = GetGold / Price,
            FirGoldPro = FirstGetGold / Price,
            SecGoldPro = SecondGetGold / Price,
            %%基础元宝
            BaseGetGold = round(TotalPay * GoldPro),

            %%首冲、多倍充值赠送
            OtherAddGold =
                case charge_mul:get_charge_mul(BaseGetGold) of
                    0 ->
                        %%首冲赠送元宝
                        IsFirst = charge:is_first_pay(ProductId),
                        case IsFirst of
                            true -> round(TotalPay * FirGoldPro);
                            false -> round(TotalPay * SecGoldPro)
                        end;
                    Mul ->
                        round(BaseGetGold * (Mul / 100 - 1))
                end,

            %%最终获得的元宝数
            ExtraGold = ?IF_ELSE(PayType == 3 orelse PayType == 5, round(BaseGetGold * 0.1), 0),
            FinalGetGold = round(BaseGetGold),
            set_recharge_ok(Id, ProductId, FinalGetGold, BaseGetGold, TotalFee, Pf, Lan),
            Player1 = money:add_gold(Player, FinalGetGold + ExtraGold, 121, 0, 0),
            NewPlayer = money:add_bind_gold(Player1, OtherAddGold, 121, 0, 0),
            GiveGoodsList =
                case GoodsId > 0 of
                    true -> [{GoodsId, 1}];
                    false -> []
                end,
            %%邮件
            recharge_mail(Player, TotalFee / 100, BaseGetGold, OtherAddGold, GiveGoodsList, false, Lan),
            self() ! {recharge, TotalFee, BaseGetGold, FinalGetGold},
            charge:add_charge(ProductId, TotalFee, FinalGetGold),
            recharge_helper(Tail, NewPlayer, Lan)
    end;
recharge_helper([[Id, _App_order_id, TotalFee, InitProductId, PayType] | Tail], Player, Lan) when Lan == vietnam andalso InitProductId >= 100 andalso InitProductId < 200 ->
    Pf =
        if PayType == 1 -> 10000;
            PayType == 2 -> 0;
            true -> 10001
        end,
    %%以元为单位
    TotalPay = TotalFee,
    Base = data_charge:get(InitProductId, Pf),
    case Base == [] orelse Base#base_charge.price =/= TotalPay of
        true -> %%充值的价格不对，直接算充值元宝
            recharge_helper([[Id, _App_order_id, TotalFee, 0, PayType] | Tail], Player, Lan);
        _ ->
            #base_charge{
                id = ProductId,
                price = Price,
                get_gold = GetGold,
                charge_gift_day = ChargeGiftDay,
                charge_gift_bgold = ChargeGiftBgold
            } = Base,
            %%充值换元宝比例
            GoldPro = GetGold / Price,
            %%基础元宝
            BaseGetGold = round(TotalPay * GoldPro),
            month_card_proc:set_card(Player#player.key, ProductId, ChargeGiftDay, ChargeGiftBgold),
            self() ! {recharge_gift, BaseGetGold},
            {Title, Content} = t_mail:mail_content(77),
            Msg = io_lib:format(Content, [TotalPay]),
            mail:sys_send_type_mail([Player#player.key], Title, Msg, [], ?MAIL_TYPE_CHARGE),
            set_recharge_ok(Id, ProductId, BaseGetGold, BaseGetGold, TotalFee, Pf, Lan),
            charge:add_charge(ProductId, 0, 0),
            NewPlayer = money:add_gold(Player, BaseGetGold, 121, 0, 0),
            recharge_helper(Tail, NewPlayer, Lan)
    end;
recharge_helper([[Id, Jh_order_id, TotalFee, InitProductId, _PayType] | Tail], Player, Lan)
    when Lan == korea andalso InitProductId == 0 -> %%元宝充值
    Sql = io_lib:format("select channel_id from recharge where id =~p", [Id]),
    Pf =
        case db:get_one(Sql) of
            null ->
                Player#player.pf;
            Val -> Val
        end,
    %%以元为单位
    TotalPay = TotalFee,
    BaseCharge = data_charge:get_by_price(TotalPay, Pf),
    case BaseCharge of
        [] ->
            ?ERR("recharge handle err ~p~n", [{Id, Jh_order_id, TotalFee, InitProductId}]),
            recharge_helper(Tail, Player, Lan);
        _ ->

            #base_charge{
                id = ProductId,
                price = Price,
                get_gold = GetGold,
                first_get_gold = FirstGetGold,
                second_get_gold = SecondGetGold,
                goods_id = GoodsId
            } = BaseCharge,
            %%充值换元宝比例
            GoldPro = GetGold / Price,
            FirGoldPro = FirstGetGold / Price,
            SecGoldPro = SecondGetGold / Price,
            %%基础元宝
            BaseGetGold = round(TotalPay * GoldPro),

            %%首冲、多倍充值赠送
            OtherAddGold =
                case charge_mul:get_charge_mul(BaseGetGold) of
                    0 ->
                        %%首冲赠送元宝
                        IsFirst = charge:is_first_pay(ProductId),
                        case IsFirst of
                            true -> round(TotalPay * FirGoldPro);
                            false -> round(TotalPay * SecGoldPro)
                        end;
                    Mul ->
                        round(BaseGetGold * (Mul / 100 - 1))
                end,

            %%最终获得的元宝数
            FinalGetGold = round(BaseGetGold),
            set_recharge_ok(Id, ProductId, FinalGetGold, BaseGetGold, TotalFee, Pf, Lan),
            Player1 = money:add_gold(Player, FinalGetGold, 121, 0, 0),
            NewPlayer = money:add_bind_gold(Player1, OtherAddGold, 121, 0, 0),
            GiveGoodsList =
                case GoodsId > 0 of
                    true -> [{GoodsId, 1}];
                    false -> []
                end,
            %%邮件
            recharge_mail(Player, TotalFee / 100, BaseGetGold, OtherAddGold, GiveGoodsList, false, Lan),
            self() ! {recharge, TotalFee, BaseGetGold, FinalGetGold},
            charge:add_charge(ProductId, TotalFee, FinalGetGold),
            recharge_helper(Tail, NewPlayer, Lan)
    end;
recharge_helper([[Id, Jh_order_id, TotalFee, InitProductId, PayType] | Tail], Player, Lan)
    when Lan == fanti andalso InitProductId == 0 -> %%元宝充值
    #player{
        pf = Pf
    } = Player,
    BaseCharge = data_charge:get_by_price(TotalFee, Pf),
    case BaseCharge of
        [] ->
            ?ERR("recharge handle err ~p~n", [{Id, Jh_order_id, TotalFee, InitProductId}]),
            recharge_helper(Tail, Player, Lan);
        _ ->
            %%以元为单位
            TotalPay = TotalFee,
            #base_charge{
                id = ProductId,
                price = Price,
                get_gold = GetGold,
                first_get_gold = FirstGetGold,
                second_get_gold = SecondGetGold,
                goods_id = GoodsId
            } = BaseCharge,
            %%充值换元宝比例
            GoldPro = GetGold / Price,
            FirGoldPro = FirstGetGold / Price,
            SecGoldPro = SecondGetGold / Price,
            %%PayType 1网页支付
            PayMult = ?IF_ELSE(PayType == 1, 0.1, 0),
            %%基础元宝
            BaseGetGold = round(TotalPay * GoldPro),
            ExtraGold = round(BaseGetGold * PayMult),

            %%首冲、多倍充值赠送
            OtherAddGold =
                case charge_mul:get_charge_mul(BaseGetGold) of
                    0 ->
                        %%首冲赠送元宝
                        IsFirst = charge:is_first_pay(ProductId),
                        case IsFirst of
                            true -> round(TotalPay * FirGoldPro);
                            false -> round(TotalPay * SecGoldPro)
                        end;
                    Mul ->
                        round(BaseGetGold * (Mul / 100 - 1))
                end,

            %%最终获得的元宝数
            FinalGetGold = round(BaseGetGold),
            set_recharge_ok(Id, ProductId, FinalGetGold, BaseGetGold, TotalFee, Pf, Lan),
            Player1 = money:add_gold(Player, FinalGetGold + ExtraGold, 121, 0, 0),
            NewPlayer = money:add_bind_gold(Player1, OtherAddGold, 121, 0, 0),
            GiveGoodsList =
                case GoodsId > 0 of
                    true -> [{GoodsId, 1}];
                    false -> []
                end,
            %%邮件
            recharge_mail(Player, TotalPay / 100, BaseGetGold, OtherAddGold, GiveGoodsList, false, Lan),
            self() ! {recharge, TotalFee, BaseGetGold, FinalGetGold},
            charge:add_charge(ProductId, TotalFee, FinalGetGold),
            recharge_helper(Tail, NewPlayer, Lan)
    end;
recharge_helper([[Id, Jh_order_id, TotalFee, InitProductId, _PayType] | Tail], Player, Lan)
    when InitProductId == 0 andalso Lan == bt -> %%元宝充值
    #player{
        pf = Pf
    } = Player,
    BaseCharge = data_charge:get_by_price(TotalFee / 100, Pf),
    case BaseCharge of
        [] ->
            ?ERR("recharge handle err ~p~n", [{Id, Jh_order_id, TotalFee, InitProductId}]),
            recharge_helper(Tail, Player, Lan);
        _ ->
            %%以元为单位
            TotalPay = TotalFee / 100,
            #base_charge{
                id = ProductId,
                price = Price,
                get_gold = GetGold,
                first_get_gold = FirstGetGold,
                second_get_gold = SecondGetGold,
                goods_id = GoodsId
            } = BaseCharge,
            %%充值换元宝比例
            GoldPro = GetGold / Price,
            FirGoldPro = FirstGetGold / Price,
            SecGoldPro = SecondGetGold / Price,
            %%基础元宝
            BaseGetGold = round(TotalPay * GoldPro),

            %%首冲、多倍充值赠送
            OtherAddGold =
                case charge_mul:get_charge_mul(BaseGetGold) of
                    0 ->
                        %%首冲赠送元宝
                        IsFirst = charge:is_first_pay(ProductId),
                        case IsFirst of
                            true -> round(TotalPay * FirGoldPro);
                            false -> round(TotalPay * SecGoldPro)
                        end;
                    Mul ->
                        round(BaseGetGold * (Mul / 100 - 1))
                end,

            %%最终获得的元宝数
            FinalGetGold = round(BaseGetGold),
            set_recharge_ok(Id, ProductId, FinalGetGold, BaseGetGold, TotalFee, Pf, Lan),
            NewPlayer = money:add_gold(Player, FinalGetGold + OtherAddGold, 121, 0, 0),
            GiveGoodsList =
                case GoodsId > 0 of
                    true -> [{GoodsId, 1}];
                    false -> []
                end,
            %%邮件
            recharge_mail(Player, TotalPay, BaseGetGold, OtherAddGold, GiveGoodsList, false, Lan),
            self() ! {recharge, TotalFee, BaseGetGold, FinalGetGold},
            charge:add_charge(ProductId, TotalFee, FinalGetGold),
            recharge_helper(Tail, NewPlayer, Lan)
    end;
recharge_helper([[Id, Jh_order_id, TotalFee, InitProductId, _PayType] | Tail], Player, Lan)
    when InitProductId == 0 -> %%元宝充值
    #player{
        pf = Pf
    } = Player,
    BaseCharge = data_charge:get_by_price(TotalFee / 100, Pf),
    case BaseCharge of
        [] ->
            ?ERR("recharge handle err ~p~n", [{Id, Jh_order_id, TotalFee, InitProductId}]),
            recharge_helper(Tail, Player, Lan);
        _ ->
            %%以元为单位
            TotalPay = TotalFee / 100,
            #base_charge{
                id = ProductId,
                price = Price,
                get_gold = GetGold,
                first_get_gold = FirstGetGold,
                second_get_gold = SecondGetGold,
                goods_id = GoodsId
            } = BaseCharge,
            %%充值换元宝比例
            GoldPro = GetGold / Price,
            FirGoldPro = FirstGetGold / Price,
            SecGoldPro = SecondGetGold / Price,
            %%基础元宝
            BaseGetGold = round(TotalPay * GoldPro),

            %%首冲、多倍充值赠送
            OtherAddGold =
                case charge_mul:get_charge_mul(BaseGetGold) of
                    0 ->
                        %%首冲赠送元宝
                        IsFirst = charge:is_first_pay(ProductId),
                        case IsFirst of
                            true -> round(TotalPay * FirGoldPro);
                            false -> round(TotalPay * SecGoldPro)
                        end;
                    Mul ->
                        round(BaseGetGold * (Mul / 100 - 1))
                end,

            %%最终获得的元宝数
            FinalGetGold = round(BaseGetGold),
            set_recharge_ok(Id, ProductId, FinalGetGold, BaseGetGold, TotalFee, Pf, Lan),
            Player1 = money:add_gold(Player, FinalGetGold, 121, 0, 0),
            NewPlayer = money:add_bind_gold(Player1, OtherAddGold, 121, 0, 0),
            GiveGoodsList =
                case GoodsId > 0 of
                    true -> [{GoodsId, 1}];
                    false -> []
                end,
            %%邮件
            recharge_mail(Player, TotalPay, BaseGetGold, OtherAddGold, GiveGoodsList, false, Lan),
            self() ! {recharge, TotalFee, BaseGetGold, FinalGetGold},
            charge:add_charge(ProductId, TotalFee, FinalGetGold),
            recharge_helper(Tail, NewPlayer, Lan)
    end;
%%绑元礼包
recharge_helper([[Id, _App_order_id, TotalFee, InitProductId, _PayType] | Tail], Player, Lan) when Lan == fanti andalso InitProductId >= 100 andalso InitProductId < 200 ->
    #player{
        pf = Pf
    } = Player,
    Base = data_charge:get(InitProductId, Pf),
    case Base == [] orelse Base#base_charge.price =/= TotalFee of
        true -> %%充值的价格不对，直接算充值元宝
            recharge_helper([[Id, _App_order_id, TotalFee, 0, _PayType] | Tail], Player, Lan);
        _ ->
            TotalPay = TotalFee,
            #base_charge{
                id = ProductId,
                price = Price,
                get_gold = GetGold,
                charge_gift_day = ChargeGiftDay,
                charge_gift_bgold = ChargeGiftBgold
            } = Base,
            %%充值换元宝比例
            GoldPro = GetGold / Price,
            %%基础元宝
            BaseGetGold = round(TotalPay * GoldPro),
            charge_gift_proc:set_charge_gift(Player#player.key, ChargeGiftDay, ChargeGiftBgold),
            self() ! {recharge_gift, BaseGetGold},
            {Title, Content} = t_mail:mail_content(77),
            Msg = io_lib:format(Content, [TotalPay / 100]),
            mail:sys_send_type_mail([Player#player.key], Title, Msg, [], ?MAIL_TYPE_CHARGE),
            set_recharge_ok(Id, ProductId, BaseGetGold, BaseGetGold, TotalFee, Pf, Lan),
            charge:add_charge(ProductId, 0, 0),
            NewPlayer = Player,
            recharge_helper(Tail, NewPlayer, Lan)
    end;
recharge_helper([[Id, _App_order_id, TotalFee, InitProductId, PayType] | Tail], Player, Lan) when Lan == bt andalso InitProductId >= 100 andalso InitProductId < 200 ->
    #player{
        pf = Pf
    } = Player,
    Base = data_charge:get(InitProductId, Pf),
    TotalPay = round(TotalFee / 100),
    case Base == [] orelse Base#base_charge.price =/= TotalPay of
        true -> %%充值的价格不对，直接算充值元宝
            recharge_helper([[Id, _App_order_id, TotalFee, 0, PayType] | Tail], Player, Lan);
        _ ->
            #base_charge{
                id = ProductId,
                price = Price,
                get_gold = GetGold,
                charge_gift_day = ChargeGiftDay,
                charge_gift_bgold = ChargeGiftBgold
            } = Base,
            %%充值换元宝比例
            GoldPro = GetGold / Price,
            %%基础元宝
            BaseGetGold = round(TotalPay * GoldPro),
%%            charge_gift_proc:set_charge_gift(Player#player.key, ChargeGiftDay, ChargeGiftBgold),
            month_card_proc:set_card(Player#player.key, ProductId, ChargeGiftDay, ChargeGiftBgold),
            self() ! {recharge_gift, BaseGetGold},
            {Title, Content} = t_mail:mail_content(77),
            Msg = io_lib:format(Content, [TotalPay]),
            mail:sys_send_type_mail([Player#player.key], Title, Msg, [], ?MAIL_TYPE_CHARGE),
            set_recharge_ok(Id, ProductId, BaseGetGold, BaseGetGold, TotalFee, Pf, Lan),
            charge:add_charge(ProductId, 0, 0),
            NewPlayer = money:add_gold(Player, BaseGetGold, 121, 0, 0),
            recharge_helper(Tail, NewPlayer, Lan)
    end;
recharge_helper([[Id, _App_order_id, TotalFee, InitProductId, PayType] | Tail], Player, Lan) when InitProductId >= 100 andalso InitProductId < 200 ->
    #player{
        pf = Pf
    } = Player,
    Base = data_charge:get(InitProductId, Pf),
    TotalPay = round(TotalFee / 100),
    case Base == [] orelse Base#base_charge.price =/= TotalPay of
        true -> %%充值的价格不对，直接算充值元宝
            recharge_helper([[Id, _App_order_id, TotalFee, 0, PayType] | Tail], Player, Lan);
        _ ->
            #base_charge{
                id = ProductId,
                price = Price,
                get_gold = GetGold,
                charge_gift_day = ChargeGiftDay,
                charge_gift_bgold = ChargeGiftBgold
            } = Base,
            %%充值换元宝比例
            GoldPro = GetGold / Price,
            %%基础元宝
            BaseGetGold = round(TotalPay * GoldPro),
            charge_gift_proc:set_charge_gift(Player#player.key, ChargeGiftDay, ChargeGiftBgold),
            self() ! {recharge_gift, BaseGetGold},
            {Title, Content} = t_mail:mail_content(77),
            Msg = io_lib:format(Content, [TotalPay]),
            mail:sys_send_type_mail([Player#player.key], Title, Msg, [], ?MAIL_TYPE_CHARGE),
            set_recharge_ok(Id, ProductId, BaseGetGold, BaseGetGold, TotalFee, Pf, Lan),
            charge:add_charge(ProductId, 0, 0),
            NewPlayer = Player,
            recharge_helper(Tail, NewPlayer, Lan)
    end;
recharge_helper([[Id, _App_order_id, TotalFee, InitProductId, PayType] | Tail], Player, Lan)
    when InitProductId > 0 -> %%物品
    #player{
        pf = Pf
    } = Player,
    ProductId =
        case InitProductId of
            1 -> 90;  %%月卡的充值ID
            2 -> 91;  %%终身卡充值ID
            3 -> 92;  %%豪华投资
            4 -> 93;  %%至尊投资
            _ -> -1   %%未知
        end,
%%以元为单位
    TotalPay = round(TotalFee / 100),
    Base = data_charge:get(ProductId, Pf),
    case Base == [] orelse Base#base_charge.price =/= TotalPay of
        true -> %%充值的价格不对，直接算充值元宝
            recharge_helper([[Id, _App_order_id, TotalFee, 0, PayType] | Tail], Player, Lan);
        false ->
            #base_charge{
                goods_id = GoodsId,
                get_gold = GetGold  %%购买物品的，不给元宝
            } = Base,
            %%改状态
            set_recharge_ok(Id, ProductId, 0, 0, TotalFee, Pf, Lan),
            %%给物品
            GiveGoodsList = goods:make_give_goods_list(121, [{GoodsId, 1}]),
            NewPlayer =
                case goods:give_goods(Player, GiveGoodsList) of
                    {ok, Player1} -> Player1;
                    _ -> Player
                end,
            %%邮件
            recharge_mail(Player, TotalPay, 0, 0, [], false, Lan),
            self() ! {recharge, TotalFee, GetGold, GetGold}, %%需要计算累计充值额度等
            recharge_helper(Tail, NewPlayer, Lan)
    end;
recharge_helper([Info | Tail], Player, Lan) ->
    ?ERR("recharge_helper handle err ~p~n", [Info]),
    recharge_helper(Tail, Player, Lan).

%%标记已领取
set_recharge_ok(Id, ResProductId, FinalGetGold, BaseGetGold, TotalFee, Pf, Lan) ->
    NewTotalFee =
        case Lan of
            korea ->
                ?IF_ELSE(Pf == 1, round(TotalFee * 6.634), round(TotalFee * 0.005965 * 100));
            _ -> TotalFee
        end,
    Sql = io_lib:format("update recharge set state = 0,res_product_id = ~p,total_gold=~p,base_gold=~p,total_fee =~p where id = ~p", [ResProductId, FinalGetGold, BaseGetGold, NewTotalFee, Id]),
    db:execute(Sql).

%%充值邮件
recharge_mail(Player, TotalPay0, GetGold, AddGold, GiveGoodsList, IsMonthCard, Lan) ->
    %%是整数就取整
    TotalPay =
        case TotalPay0 == util:to_integer(TotalPay0) of
            true -> util:to_integer(TotalPay0);
            false -> TotalPay0
        end,
    case Lan of
        bt ->
            if AddGold > 0 ->
                {Title, Content} = t_mail:mail_content(150),
                Msg = io_lib:format(Content, [TotalPay, GetGold, AddGold]);
                true ->
                    {Title, Content} = t_mail:mail_content(87),
                    Msg = io_lib:format(Content, [TotalPay, GetGold])
            end;
        _ ->
            case IsMonthCard of
                true ->
                    {Title, Content} = t_mail:mail_content(10),
                    Msg = io_lib:format(Content, [TotalPay, GetGold, AddGold]);
                false ->
                    if AddGold > 0 ->
                        {Title, Content} = t_mail:mail_content(11),
                        Msg = io_lib:format(Content, [TotalPay, GetGold, AddGold]);
                        true ->
                            {Title, Content} = t_mail:mail_content(87),
                            Msg = io_lib:format(Content, [TotalPay, GetGold])
                    end

            end
    end,
    ?DO_IF(Lan /= korea, mail:sys_send_type_mail([Player#player.key], Title, Msg, GiveGoodsList, ?MAIL_TYPE_CHARGE)).
