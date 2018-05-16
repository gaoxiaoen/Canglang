%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 一月 2016 上午10:51
%%%-------------------------------------------------------------------
-module(activity_load).
-author("fengzhenlin").
-include("server.hrl").
-include("activity.hrl").
-include("common.hrl").
-include("invest.hrl").

%% API
-export([
    dbget_act_info/1,
    dbup_act_info/1,
    dbget_first_charge_info/1,
    dbup_first_charge/1,
    dbget_act_rank/0,
    dbup_act_rank/1,
    dbget_player_act_rank/1,
    dbup_player_act_rank/1,
    dbget_daily_charge/1,
    dbup_daily_charge/1,
    dbget_acc_charge_info/1,
    dbup_acc_charge_info/1,
    dbget_acc_consume_info/1,
    dbup_acc_consume_info/1,
    dbget_one_charge_info/1,
    dbup_one_charge_info/1,
    dbget_lim_shop/0,
    dbup_lim_shop/1,
    dbget_player_lim_shop/1,
    dbup_player_lim_shop/1,
    dbget_player_act_rank_goal/1,
    dbup_player_act_rank_goal/1,
    dbget_new_daily_charge/1,
    dbup_new_daily_charge/1,
    dbget_last_charge_time/1,
    dbget_new_one_charge/1,
    dbup_new_one_charge/1,
    dbget_online_gift/1,
    dbup_online_gift/1,
    dbget_exchange/1,
    dbup_exchange/1,
    dbget_online_time_gift/1,
    dbup_online_time_gift/1,
    dbget_last_charge_fee/1,
    dbget_daily_acc_charge_info/1,
    dbup_daily_acc_charge_info/1,
    dbget_acc_charge_turntable/1,
    dbup_acc_charge_turntable/1,
    dbget_d_fir_charge_return/1,
    dbup_d_fir_charge_return/1,
    dbget_acc_charge_gift/1,
    dbup_acc_charge_gift/1,
    dbget_goods_exchange/1,
    dbup_goods_exchange/1,
    dbget_role_d_acc_charge/1,
    dbup_role_d_acc_charge/1,
    dbget_con_charge/1,
    dbup_con_charge/1,
    dbget_open_egg/1,
    dbup_open_egg/1,
    dbget_merge_sign_in/1,
    dbup_merge_sign_in/1,
    dbget_target_act/1,
    dbup_target_act/1,
    dbget_vip_gift/1,
    dbup_vip_gift/1,
    dbget_treasure_hourse/1,
    dbup_treasure_hourse/1,
    dbget_hqg_daily_charge/1,
    dbup_hqg_daily_charge/1,
    dbget_open_act_jh_rank/1,
    dbup_open_act_jh_rank/1,
    dbget_open_act_up_target/1,
    dbup_open_act_up_target/1,
    dbget_open_act_up_target2/1,
    dbup_open_act_up_target2/1,
    dbget_open_act_up_target3/1,
    dbup_open_act_up_target3/1,
    dbget_open_act_group_charge/1,
    dbup_open_act_group_charge/1,
    dbget_all_open_act_group_charge/1,
    dbget_open_act_acc_charge/1,
    dbup_open_act_acc_charge/1,
    dbget_open_act_all_target/1,
    dbup_open_act_all_target/1,
    dbget_all_open_act_all_target/1,
    dbup_open_act_all_target_ets/1,
    dbget_open_act_all_target2/1,
    dbup_open_act_all_target2/1,
    dbget_all_open_act_all_target2/1,
    dbup_open_act_all_target_ets2/1,
    dbget_open_act_all_target3/1,
    dbup_open_act_all_target3/1,
    dbget_all_open_act_all_target3/1,
    dbup_open_act_all_target_ets3/1,
    dbget_open_act_all_rank/1,
    dbup_open_act_all_rank/1,
    dbget_open_act_all_rank2/1,
    dbup_open_act_all_rank2/1,
    dbget_open_act_all_rank3/1,
    dbup_open_act_all_rank3/1,
    dbup_act_invest/1,
    dbget_act_invest/1,
    dbup_act_map/1,
    dbget_act_map/1,
    dbget_all_act_map/1,
    dbget_uplv_box/1,
    dbget_draw_turntable/1,
    dbup_player_draw_turntable/1,
    dbup_uplv_box/1,
    dbget_limit_buy/1,
    dbup_limit_buy/1,
    dbget_all_limit_buy/1,
    dbup_all_limit_buy/1,
    dbget_fuwen_map/1,
    dbup_fuwen_map/1,

    dbget_jiandao_map/1,
    dbup_jiandao_map/1,

    dbup_hundred_return/1,
    dbget_hundred_return/1,
    dbget_login_online/1,
    dbup_login_online/1,
    dbget_new_exchange/1,
    dbup_new_exchange/1,
    dbget_equip_sell/1,
    dbup_equip_sell/1,
    dbget_act_convoy/1,
    dbup_act_convoy/1,
    dbget_acc_charge_d_info/1,
    dbup_acc_charge_d_info/1,
    dbget_consume_back_charge/1,
    dbup_consume_back_charge/1,
    dbget_consume_rank/1,
    dbup_consume_rank/1,
    dbget_recharge_rank/1,
    dbup_recharge_rank/1,
    dbget_xj_map/1,
    dbup_xj_map/1,
    dbget_act_con_charge/1,
    dbup_act_con_charge/1,
    dbget_gold_silver_tower/1,
    dbup_gold_silver_tower/1,
    dbup_gold_silver_tower_ets/1,
    dbget_gold_silver_tower_ets/1,
    dbget_open_act_back_buy/1,
    dbup_open_act_back_buy/1,
    dbget_all_back_buy/1,
    dbup_all_back_buy/1,
    dbreplace_activity_area_group/3,
    dbget_activity_area_group/1,
    dbget_player_marry_rank/1,
    dbup_player_marry_rank/1,
    dbget_buy_money/1,
    dbup_buy_money/1,
    dbget_merge_act_group_charge/1,
    dbup_merge_act_group_charge/1,
    dbget_all_merge_act_group_charge/1,
    dbget_merge_act_up_target/1,
    dbup_merge_act_up_target/1,
    dbget_merge_act_up_target2/1,
    dbup_merge_act_up_target2/1,
    dbget_merge_act_up_target3/1,
    dbup_merge_act_up_target3/1,
    dbget_merge_act_acc_charge/1,
    dbup_merge_act_acc_charge/1,
    dbget_merge_act_back_buy/1,
    dbup_merge_act_back_buy/1,
    dbget_all_merge_back_buy/1,
    dbup_all_merge_back_buy/1,
    dbget_merge_exchange/1,
    dbup_merge_exchange/1,
    dbget_new_wealth_cat/1,
    dbup_new_wealth_cat/1,
    dbget_lucky_turn/1,
    dbup_lucky_turn/1,
    dbget_lucky_turn_cross/1,
    dbup_lucky_turn_cross/1,
    dbget_mystery_shop/1,
    dbup_mystery_shop/1,
    dbget_limit_time_gift/1,
    dbup_limit_time_gift/1,
    dbget_act_throw_egg/1,
    dbup_act_throw_egg/1,
    dbget_act_throw_fruit/1,
    dbup_act_throw_fruit/1,
    dbget_act_welkin_hunt/1,
    dbup_act_welkin_hunt/1,
    dbget_local_lucky_turn/1,
    dbup_local_lucky_turn/1,
    dbget_lucky_turn_local/1,
    dbup_lucky_turn_local/1,
    dbget_small_charge/1,
    dbup_small_charge/1,
    dbget_one_gold_buy/1,
    dbup_one_gold_buy/1,
    dbget_all_one_gold_buy/2,
    dbup_ets_one_gold_buy/1,
    dbget_fruit_war/1,
    dbget_online_reward/1,
    dbup_online_reward/1,
    dbget_festival_login_gift/1,
    dbup_festival_login_gift/1,
    dbget_festival_act_acc_charge/1,
    dbup_festival_act_acc_charge/1,
    dbget_act_daily_task/1,
    dbup_act_daily_task/1,
    dbget_festival_act_back_buy/1,
    dbup_festival_act_back_buy/1,
    dbget_all_festival_back_buy/1,
    dbup_all_festival_back_buy/1,
    dbget_act_flip_card/1,
    dbup_act_flip_card/1,
    dbget_festival_exchange/1,
    dbup_festival_exchange/1,
    dbget_return_exchange/1,
    dbup_return_exchange/1,
    dbget_festival_red_gift/1,
    dbup_festival_red_gift/1,
    dbget_act_other_charge/1,
    dbup_act_other_charge/1,
    dbget_act_super_charge/1,
    dbup_act_super_charge/1,
    dbget_act_charge/1,
    dbup_act_charge/1,
    dbget_act_lv_back/2,
    dbup_act_lv_back/1,
    dbget_act_mystery_tree/2,
    dbup_act_mystery_tree/1,
    dbget_cs_charge_d/1,
    dbup_cs_charge_d/1,
    dbget_act_jbp/1,
    dbup_act_jbp/1,
    dbget_limit_xian/1,
    dbup_limit_xian/1,
    dbget_limit_pet/1,
    dbup_limit_pet/1,
    dbget_buy_red_equip/1,
    dbup_buy_red_equip/1,
    dbget_small_charge_d/1,
    dbup_small_charge_d/1,
    dbget_act_exp_dungeon/1,
    dbup_act_exp_dungeon/1,
    dbget_godness_limit_time_gift/1,
    dbup_godness_limit_time_gift/1,
    dbup_call_godness/1,
    dbget_call_godness/1,
    dbget_wishing_well/2,
    dbup_wishing_well/1,
    dbget_cross_wishing_well/2,
    dbup_cross_wishing_well/1,
    dbget_cross_1vn_shop/0,
    dbup_cross_1vn_shop/3,
    dbget_player_invite_code/2,
    dbup_player_invite_code/1,
    dbget_player_act_collection_hero/1,
    dbup_player_act_collection_hero/1,
    dbget_player_act_cbp_rank/1,
    dbup_player_act_cbp_rank/1,
    dbup_act_cbp_rank/2,
    dbget_player_act_meet_limit/1,
    dbup_player_act_meet_limit/1,
    dbget_act_consume_rebate/1,
    dbup_act_consume_rebate/1,
    dbget_merge_act_acc_consume/1,
    dbup_merge_act_acc_consume/1
]).

dbget_act_info(OpenDay) ->
    Sql = io_lib:format("select act_info from act_open_info where open_day = ~p", [OpenDay]),
    case db:get_row(Sql) of
        [] -> [];
        [ActInfoBin] ->
            util:bitstring_to_term(ActInfoBin)
    end.

dbup_act_info(#ets_act_info{open_day = OpenDay, act_info = ActInfo}) ->
    ActInfoBin = util:term_to_bitstring(ActInfo),
    Sql = io_lib:format("replace into act_open_info set act_info='~s',open_day=~p",
        [ActInfoBin, OpenDay]),
    db:execute(Sql),
    ok.

dbget_first_charge_info(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_first_charge{
        pkey = Pkey,
        get_list = [],
        charge_time = 0,
        last_get_time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select get_list,charge_time,last_get_time from player_first_charge where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [GetListBin, ChargeTime, LastGetTime] ->
                    #st_first_charge{
                        pkey = Pkey,
                        get_list = util:bitstring_to_term(GetListBin),
                        charge_time = ChargeTime,
                        last_get_time = LastGetTime
                    }
            end
    end.

dbup_first_charge(FirstChargeSt) ->
    #st_first_charge{
        pkey = Pkey,
        get_list = GetList,
        charge_time = ChargeTime,
        last_get_time = LastGetTime
    } = FirstChargeSt,
    Sql = io_lib:format("replace into player_first_charge set get_list='~s',charge_time=~p,last_get_time=~p,pkey=~p",
        [util:term_to_bitstring(GetList), ChargeTime, LastGetTime, Pkey]),
    db:execute(Sql),
    ok.

dbget_act_rank() ->
    Sql = io_lib:format("select data,update_time from act_rank order by update_time desc limit 1", []),
    case db:get_row(Sql) of
        [] ->
            dict:new();
        [DataBin, _UpdateTime] ->
            Data = util:bitstring_to_term(DataBin),
            F = fun({Type, PackRankList, RewardList}, AccDict) ->
                RankList = [unpack_pinfo(RankData) || RankData <- PackRankList],
                Ar = #ar{
                    type = Type,
                    rank = RankList,
                    reward_list = RewardList
                },
                dict:store(Type, Ar, AccDict)
                end,
            lists:foldl(F, dict:new(), Data)
    end.
dbup_act_rank(ActRank) ->
    #rank_act{
        dict = Dict
    } = ActRank,
    F = fun({Type, Ar}) ->
        #ar{
            rank = RankList,
            reward_list = RewardList
        } = Ar,
        PackRankList = [pack_pinfo(Pinfo) || Pinfo <- RankList],
        {Type, PackRankList, RewardList}
        end,
    List = lists:map(F, dict:to_list(Dict)),
    Now = util:unixtime(),
    Sql = io_lib:format("replace into act_rank set data='~s',update_time=~p", [util:term_to_bitstring(List), Now]),
    db:execute(Sql),
    ok.
pack_pinfo(Pinfo) ->
    #pinfo{
        rank = Rank,
        info = Info,
        pkey = Pkey,
        sn = Sn,
        pf = Pf,
        name = Name,
        lv = Lv,
        career = Career,
        vip = Vip,
        realm = Realm
    } = Pinfo,
    {Rank, Info, Pkey, Sn, Pf, Name, Lv, Career, Vip, Realm}.
unpack_pinfo({Rank, Info, Pkey, Sn, Pf, Name, Lv, Career, Vip, Realm}) ->
    #pinfo{
        rank = Rank,
        info = Info,
        pkey = Pkey,
        sn = Sn,
        pf = Pf,
        name = Name,
        lv = Lv,
        career = Career,
        vip = Vip,
        realm = Realm
    }.

dbget_player_act_rank(Player) ->
    NewSt = #st_act_rank{
        pkey = Player#player.key,
        equip_stren_lv = 0,
        equip_stren_lv_time = 0,
        baoshi_lv = 0,
        baoshi_lv_time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select equip_stren_lv,equip_stren_lv_time,baoshi_lv,baoshi_lv_time from player_act_rank where pkey=~p", [Player#player.key]),
            case db:get_row(Sql) of
                [] ->
                    NewSt;
                [ELv, ETime, BLv, BTime] ->
                    #st_act_rank{
                        pkey = Player#player.key,
                        equip_stren_lv = ELv,
                        equip_stren_lv_time = ETime,
                        baoshi_lv = BLv,
                        baoshi_lv_time = BTime
                    }
            end
    end.

dbup_player_act_rank(ActRankSt) ->
    #st_act_rank{
        pkey = PKey,
        equip_stren_lv = ELv,
        equip_stren_lv_time = ETime,
        baoshi_lv = BLv,
        baoshi_lv_time = BTime
    } = ActRankSt,
    UpSql = io_lib:format("replace into player_act_rank set equip_stren_lv=~p,equip_stren_lv_time=~p,baoshi_lv=~p,baoshi_lv_time=~p, pkey=~p",
        [ELv, ETime, BLv, BTime, PKey]),
    db:execute(UpSql),
    ok.


dbget_draw_turntable(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_draw_turntable{
        pkey = Pkey,
        act_id = 0,
        score = 0,
        exchange_list = [],
        turntable_id = 1,
        count = 0
    },
    case player_util:is_new_role(Player) of
        true ->
            NewSt;
        false ->
            Sql = io_lib:format("select act_id,score,turntable_id,exchange_list,location,count from player_draw_turntable where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, Score, TurnId, ExchangeList, Location, Count] ->
                    #st_draw_turntable{
                        pkey = Pkey,
                        act_id = ActId,
                        score = Score,
                        exchange_list = util:bitstring_to_term(ExchangeList),
                        turntable_id = TurnId,
                        location = Location,
                        count = Count
                    }
            end
    end.

dbup_player_draw_turntable(StLotteryTurn) ->
    #st_draw_turntable{
        pkey = Pkey,
        act_id = ActId,
        score = Score,
        exchange_list = ExchangeList,
        turntable_id = TurnId,
        location = Location,
        count = Count
    } = StLotteryTurn,
    UpSql = io_lib:format("replace into player_draw_turntable set act_id=~p,score=~p,turntable_id=~p,exchange_list='~s',Location = ~p, pkey=~p, count = ~p",
        [ActId, Score, TurnId, util:term_to_bitstring(ExchangeList), Location, Pkey, Count]),
    db:execute(UpSql),
    ok.



dbget_daily_charge(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_daily_charge{
        pkey = Pkey,
        get_list = [],
        last_charge_time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select get_list from player_daily_charge where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [GetListBin] ->
                    LastChargeTime = dbget_last_charge_time(Pkey),
                    #st_daily_charge{
                        pkey = Pkey,
                        get_list = util:bitstring_to_term(GetListBin),
                        last_charge_time = LastChargeTime
                    }
            end
    end.

dbup_daily_charge(DailyChargeSt) ->
    #st_daily_charge{
        pkey = Pkey,
        get_list = GetList
    } = DailyChargeSt,
    Sql = io_lib:format("replace into player_daily_charge set get_list='~s', pkey=~p",
        [util:term_to_bitstring(GetList), Pkey]),
    db:execute(Sql),
    ok.

dbget_acc_charge_info(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_acc_charge{
        pkey = Pkey,
        acc_val = 0,
        get_acc_ids = [],
        act_id = 0,
        time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select acc_val,get_acc_ids,act_id,`time` from player_acc_recharge where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [AccVal, GetAccIdsBin, ActId, Time] ->
                    Now = util:unixtime(),
                    case Now < 1504367999 of %% 修复当天活动数据，修改时间即可
                        true ->
                            case acc_charge:get_act() of
                                [] -> #st_acc_charge{pkey = Pkey};
                                #base_acc_charge{act_id = BaseActId} ->
                                    Sql2 = io_lib:format("select  sum(total_fee) as total_fee from recharge where app_role_id=~p and `time` > ~p", [Pkey, util:unixdate()]),
                                    ChargeGold =
                                        case db:get_row(Sql2) of
                                            [TotalFee] when is_integer(TotalFee) ->
                                                TotalFee div 10;
                                            _Other ->
                                                ?DEBUG("_Other:~p", [_Other]),
                                                0
                                        end,
                                    ?DEBUG("ChargeGold:~p", [ChargeGold]),
                                    if
                                        BaseActId == ActId ->
                                            #st_acc_charge{
                                                pkey = Pkey,
                                                acc_val = ChargeGold,
                                                get_acc_ids = util:bitstring_to_term(GetAccIdsBin),
                                                act_id = ActId,
                                                time = Time
                                            };
                                        true ->
                                            #st_acc_charge{
                                                pkey = Pkey,
                                                acc_val = ChargeGold,
                                                time = util:unixtime(),
                                                act_id = BaseActId
                                            }
                                    end
                            end;
                        false ->
                            #st_acc_charge{
                                pkey = Pkey,
                                acc_val = AccVal,
                                get_acc_ids = util:bitstring_to_term(GetAccIdsBin),
                                act_id = ActId,
                                time = Time
                            }
                    end
            end
    end.

dbup_acc_charge_info(AccChargeSt) ->
    #st_acc_charge{
        pkey = Pkey,
        acc_val = AccVal,
        get_acc_ids = GetAccIds,
        act_id = ActId,
        time = Time
    } = AccChargeSt,
    Sql = io_lib:format("replace into player_acc_recharge set acc_val=~p,get_acc_ids='~s',act_id=~p,`time`=~p, pkey=~p",
        [AccVal, util:term_to_bitstring(GetAccIds), ActId, Time, Pkey]),
    db:execute(Sql),
    ok.

dbget_acc_consume_info(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_acc_consume{
        pkey = Pkey,
        get_acc_ids = [],
        acc_val = 0,
        act_id = 0,
        time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select acc_val,get_acc_ids,act_id,`time` from player_acc_consume where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [AccVal, GetAccIdsBin, ActId, Time] ->
                    #st_acc_consume{
                        pkey = Pkey,
                        acc_val = AccVal,
                        act_id = ActId,
                        get_acc_ids = util:bitstring_to_term(GetAccIdsBin),
                        time = Time
                    }
            end
    end.

dbup_acc_consume_info(AccConsumeSt) ->
    #st_acc_consume{
        pkey = Pkey,
        acc_val = AccVal,
        act_id = ActId,
        get_acc_ids = GetAccIds,
        time = Time
    } = AccConsumeSt,
    Sql = io_lib:format("replace into player_acc_consume set acc_val=~p,get_acc_ids='~s',act_id=~p,`time`=~p, pkey=~p",
        [AccVal, util:term_to_bitstring(GetAccIds), ActId, Time, Pkey]),
    db:execute(Sql),
    ok.

dbget_one_charge_info(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_one_charge{
        pkey = Pkey,
        get_acc_ids = [],
        charge_list = [],
        act_id = 0,
        time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select charge_list,get_acc_ids,act_id,`time` from player_one_recharge where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ChargeListBin, GetAccIdsBin, ActId, Time] ->
                    #st_one_charge{
                        pkey = Pkey,
                        charge_list = util:bitstring_to_term(ChargeListBin),
                        act_id = ActId,
                        get_acc_ids = util:bitstring_to_term(GetAccIdsBin),
                        time = Time
                    }
            end
    end.

dbup_one_charge_info(OneChargeSt) ->
    #st_one_charge{
        pkey = Pkey,
        charge_list = ChargeList,
        act_id = ActId,
        get_acc_ids = GetAccIds,
        time = Time
    } = OneChargeSt,
    Sql = io_lib:format("replace into player_one_recharge set charge_list='~s',get_acc_ids='~s',act_id=~p,`time`=~p, pkey=~p",
        [util:term_to_bitstring(ChargeList), util:term_to_bitstring(GetAccIds), ActId, Time, Pkey]),
    db:execute(Sql),
    ok.

dbget_lim_shop() ->
    Sql = io_lib:format("select act_id,`data`,update_time,act_day from lim_shop order by update_time desc limit 1", []),
    case db:get_row(Sql) of
        [] ->
            #lim_shop{};
        [ActId, DataBin, _UpdateTime, ActDay] ->
            F = fun({Id, BuyTimes}, AccDict) ->
                dict:store(Id, {Id, BuyTimes}, AccDict)
                end,
            Dict = lists:foldl(F, dict:new(), util:bitstring_to_term(DataBin)),
            #lim_shop{act_id = ActId, dict = Dict, act_day = ActDay}
    end.

dbup_lim_shop(LimShop) ->
    #lim_shop{
        act_id = ActId,
        dict = Dict,
        act_day = ActDay
    } = LimShop,
    Now = util:unixtime(),
    F = fun({_, {Id, BuyTimes}}) ->
        {Id, BuyTimes}
        end,
    L = lists:map(F, dict:to_list(Dict)),
    Sql = io_lib:format("insert into lim_shop set act_id=~p,`data`='~s',update_time=~p,act_day=~p", [ActId, util:term_to_bitstring(L), Now, ActDay]),
    db:execute(Sql),
    ok.

dbget_player_lim_shop(Player) ->
    NewSt = #st_lim_shop{
        pkey = Player#player.key,
        act_id = 0,
        dict = dict:new()
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,`data`,update_time from player_lim_shop where pkey=~p", [Player#player.key]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, DataBin, UpdateTime] ->
                    F = fun({Id, BuyTimes}, AccDict) ->
                        dict:store(Id, {Id, BuyTimes}, AccDict)
                        end,
                    Dict = lists:foldl(F, dict:new(), util:bitstring_to_term(DataBin)),
                    #st_lim_shop{
                        pkey = Player#player.key,
                        act_id = ActId,
                        dict = Dict,
                        update_time = UpdateTime
                    }
            end
    end.

dbup_player_lim_shop(LimShopSt) ->
    #st_lim_shop{
        pkey = PKey,
        act_id = ActId,
        dict = Dict,
        update_time = UpdateTime
    } = LimShopSt,
    F = fun({_, {Id, BuyTimes}}) ->
        {Id, BuyTimes}
        end,
    L = lists:map(F, dict:to_list(Dict)),
    Sql = io_lib:format("replace into player_lim_shop set act_id=~p,`data`='~s',update_time=~p, pkey=~p",
        [ActId, util:term_to_bitstring(L), UpdateTime, PKey]),
    db:execute(Sql),
    ok.

dbget_player_act_rank_goal(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_act_rank_goal{
        pkey = Pkey,
        act_id = 0,
        get_list = []
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,get_list from player_act_rank_goal where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, GetList] ->
                    #st_act_rank_goal{
                        pkey = Pkey,
                        act_id = ActId,
                        get_list = util:bitstring_to_term(GetList)
                    }
            end
    end.

dbup_player_act_rank_goal(ActRankGoalSt) ->
    #st_act_rank_goal{
        pkey = Pkey,
        act_id = ActId,
        get_list = GetList
    } = ActRankGoalSt,
    Sql = io_lib:format("replace into player_act_rank_goal set act_id = ~p,get_list='~s', pkey = ~p", [ActId, util:term_to_bitstring(GetList), Pkey]),
    db:execute(Sql),
    ok.

dbget_new_daily_charge(Player) ->
    #player{
        key = Pkey
    } = Player,
    LastChargeTime = ?IF_ELSE(player_util:is_new_role(Player), 0, dbget_last_charge_time(Pkey)),
    NewSt = #st_new_daily_charge{
        pkey = Pkey,
        get_time = 0,
        last_charge_time = LastChargeTime
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select get_time from player_new_daily_charge where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [GetTime] ->
                    #st_new_daily_charge{
                        pkey = Pkey,
                        get_time = GetTime,
                        last_charge_time = LastChargeTime
                    }
            end
    end.

dbup_new_daily_charge(NewDailyChargeSt) ->
    #st_new_daily_charge{
        pkey = Pkey,
        get_time = GetTime
    } = NewDailyChargeSt,
    Sql = io_lib:format("replace into player_new_daily_charge set get_time=~p, pkey=~p",
        [GetTime, Pkey]),
    db:execute(Sql),
    ok.

dbget_last_charge_time(Pkey) ->
    ChargeSql = io_lib:format("select `time` from recharge where app_role_id = ~p and state = 0 order by `time` desc limit 1", [Pkey]),
    LastChargeTime =
        case db:get_row(ChargeSql) of
            [] -> 0;
            [ChargeTime] -> ChargeTime
        end,
    LastChargeTime.

dbget_last_charge_fee(Pkey) ->
    ChargeSql = io_lib:format("select `total_fee` from recharge where app_role_id = ~p and state = 0 order by `time` desc limit 1", [Pkey]),
    LastChargeFee =
        case db:get_row(ChargeSql) of
            [] -> 0;
            [ChargeFee] -> ChargeFee
        end,
    LastChargeFee.

dbget_new_one_charge(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_new_one_charge{
        pkey = Pkey,
        act_id = 0,
        get_time = 0,
        max_charge = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,get_time,max_charge from player_new_one_charge where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, GetTime, MaxCharge] ->
                    #st_new_one_charge{
                        pkey = Pkey,
                        act_id = ActId,
                        get_time = GetTime,
                        max_charge = MaxCharge
                    }
            end
    end.

dbup_new_one_charge(NewOneChargeSt) ->
    #st_new_one_charge{
        pkey = Pkey,
        act_id = ActId,
        get_time = GetTime,
        max_charge = MaxCharge
    } = NewOneChargeSt,
    Sql = io_lib:format("replace player_new_one_charge set act_id=~p,get_time=~p,max_charge=~p, pkey=~p",
        [ActId, GetTime, MaxCharge, Pkey]),
    db:execute(Sql),
    ok.

dbget_online_gift(Player) ->
    #player{key = Pkey} = Player,
    Now = util:unixtime(),
    NewSt = #st_online_gift{
        pkey = Pkey,
        get_list = [],
        get_time = Now
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select get_time,get_list from player_online_gift where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [GetTime, GetList] ->
                    #st_online_gift{
                        pkey = Pkey,
                        get_time = GetTime,
                        get_list = util:bitstring_to_term(GetList)
                    }
            end
    end.

dbup_online_gift(OnlineGiftSt) ->
    #st_online_gift{
        pkey = Pkey,
        get_time = GetTime,
        get_list = GetList
    } = OnlineGiftSt,
    Sql = io_lib:format("replace into player_online_gift set get_time=~p,get_list='~s', pkey=~p",
        [GetTime, util:term_to_bitstring(GetList), Pkey]),
    db:execute(Sql),
    ok.

dbget_exchange(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_exchange{
        pkey = Pkey,
        act_id = 0,
        get_list = []
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,get_list from player_exchange where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, GetList] ->
                    #st_exchange{
                        pkey = Pkey,
                        act_id = ActId,
                        get_list = util:bitstring_to_term(GetList)
                    }
            end
    end.

dbup_exchange(ExchangeSt) ->
    #st_exchange{
        pkey = Pkey,
        act_id = ActId,
        get_list = GetList
    } = ExchangeSt,
    Sql = io_lib:format("replace into player_exchange set act_id=~p,get_list='~s', pkey = ~p",
        [ActId, util:term_to_bitstring(GetList), Pkey]),
    db:execute(Sql),
    ok.

dbget_online_time_gift(Player) ->
    #player{key = Pkey} = Player,
    Now = util:unixtime(),
    NewSt = #st_online_time_gift{
        pkey = Pkey,
        act_id = 0,
        last_get_time = 0,
        get_list = [],
        online_time = 0,
        online_update_time = Now
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,get_list,last_get_time,online_time from player_online_time_gift where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, GetListBin, LastGetTime, OnlineTime] ->
                    #st_online_time_gift{
                        pkey = Pkey,
                        act_id = ActId,
                        last_get_time = LastGetTime,
                        get_list = util:bitstring_to_term(GetListBin),
                        online_time = OnlineTime,
                        online_update_time = Now
                    }
            end
    end.

dbup_online_time_gift(OTGiftSt) ->
    #st_online_time_gift{
        pkey = Pkey,
        act_id = ActId,
        get_list = GetList,
        last_get_time = LastGetTime,
        online_time = OnlineTime
    } = OTGiftSt,
    Sql = io_lib:format("replace into player_online_time_gift set act_id = ~p,get_list='~s',last_get_time=~p,online_time=~p, pkey = ~p",
        [ActId, util:term_to_bitstring(GetList), LastGetTime, OnlineTime, Pkey]),
    db:execute(Sql),
    ok.

dbget_daily_acc_charge_info(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_daily_acc_charge{
        pkey = Pkey,
        acc_val = 0,
        get_acc_ids = [],
        act_id = 0,
        time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select acc_val,get_acc_ids,act_id,`time` from player_daily_acc_recharge where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [AccVal, GetAccIdsBin, ActId, Time] ->
                    #st_daily_acc_charge{
                        pkey = Pkey,
                        acc_val = AccVal,
                        get_acc_ids = util:bitstring_to_term(GetAccIdsBin),
                        act_id = ActId,
                        time = Time
                    }
            end
    end.

dbup_daily_acc_charge_info(DailyAccChargeSt) ->
    #st_daily_acc_charge{
        pkey = Pkey,
        acc_val = AccVal,
        get_acc_ids = GetAccIds,
        act_id = ActId,
        time = Time
    } = DailyAccChargeSt,
    Sql = io_lib:format("replace into player_daily_acc_recharge set acc_val=~p,get_acc_ids='~s',act_id=~p,`time`=~p, pkey=~p",
        [AccVal, util:term_to_bitstring(GetAccIds), ActId, Time, Pkey]),
    db:execute(Sql),
    ok.

dbget_acc_charge_turntable(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_acc_charge_turntable{
        pkey = Pkey,
        act_id = 0,
        acc_val = 0,
        times = 0,
        luck_val = 0,
        update_time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,acc_val,times,luck_val,update_time from player_acc_charge_turntable where pkey = ~p", [Player#player.key]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, AccVal, Times, LuckVal, UpdateTime] ->
                    #st_acc_charge_turntable{
                        pkey = Pkey,
                        act_id = ActId,
                        acc_val = AccVal,
                        times = Times,
                        luck_val = LuckVal,
                        update_time = UpdateTime
                    }
            end
    end.

dbup_acc_charge_turntable(StAccChargeTurntable) ->
    #st_acc_charge_turntable{
        pkey = Pkey,
        act_id = ActId,
        acc_val = AccVal,
        times = Times,
        luck_val = LuckVal,
        update_time = UpdateTime
    } = StAccChargeTurntable,
    Sql = io_lib:format("replace into player_acc_charge_turntable set act_id=~p,acc_val=~p,times=~p,luck_val=~p,update_time=~p,pkey=~p",
        [ActId, AccVal, Times, LuckVal, UpdateTime, Pkey]),
    db:execute(Sql),
    ok.

dbget_d_fir_charge_return(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_d_f_charge_return{
        pkey = Pkey,
        get_time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select get_time from player_daily_fir_charge_return where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [GetTime] ->
                    #st_d_f_charge_return{
                        pkey = Pkey,
                        get_time = GetTime
                    }
            end
    end.

dbup_d_fir_charge_return(DFChargeReturnSt) ->
    #st_d_f_charge_return{
        pkey = Pkey,
        get_time = GetTime
    } = DFChargeReturnSt,
    Sql = io_lib:format("replace into player_daily_fir_charge_return set get_time=~p,pkey=~p", [GetTime, Pkey]),
    db:execute(Sql),
    ok.

dbget_acc_charge_gift(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_acc_charge_gift{
        pkey = Pkey,
        act_id = 0,
        acc_val = 0,
        times = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,acc_val,times from player_acc_charge_gift where pkey = ~p", [Player#player.key]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, AccVal, Times] ->
                    #st_acc_charge_gift{
                        pkey = Pkey,
                        act_id = ActId,
                        acc_val = AccVal,
                        times = Times
                    }
            end
    end.

dbup_acc_charge_gift(StAccChargeGift) ->
    #st_acc_charge_gift{
        pkey = Pkey,
        act_id = ActId,
        acc_val = AccVal,
        times = Times
    } = StAccChargeGift,
    Sql = io_lib:format("replace into player_acc_charge_gift set act_id=~p,acc_val=~p,times=~p,pkey=~p",
        [ActId, AccVal, Times, Pkey]),
    db:execute(Sql),
    ok.



dbget_goods_exchange(Player) ->
    #player{key = Pkey} = Player,
    Now = util:unixtime(),
    InitSt = #st_goods_exchange{
        pkey = Pkey,
        act_id = 0,
        get_list = [],
        get_time = Now
    },
    case player_util:is_new_role(Player) of
        true -> InitSt;
        false ->
            Sql = io_lib:format("select act_id,get_list,get_time from player_goods_exchange where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> InitSt;
                [ActId, GetListBin, GetTime] ->
                    #st_goods_exchange{
                        pkey = Pkey,
                        act_id = ActId,
                        get_list = util:bitstring_to_term(GetListBin),
                        get_time = GetTime
                    }
            end
    end.

dbup_goods_exchange(StGoodsExchange) ->
    #st_goods_exchange{
        pkey = Pkey,
        act_id = ActId,
        get_list = GetList,
        get_time = GetTime
    } = StGoodsExchange,
    Sql = io_lib:format("replace into player_goods_exchange set act_id=~p,get_list='~s',get_time=~p,pkey=~p",
        [ActId, util:term_to_bitstring(GetList), GetTime, Pkey]),
    db:execute(Sql),
    ok.

dbget_role_d_acc_charge(Player) ->
    #player{key = Pkey} = Player,
    Now = util:unixtime(),
    InitSt = #st_role_d_acc_charge{
        pkey = Pkey,
        act_id = 0,
        update_time = Now,
        get_list = [],
        acc_val = 0
    },
    case player_util:is_new_role(Player) of
        true -> InitSt;
        false ->
            Sql = io_lib:format("select acc_val,act_id,update_time,get_list from player_role_d_acc_charge where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> InitSt;
                [AccVal, ActId, UpdateTime, GetListBin] ->
                    #st_role_d_acc_charge{
                        pkey = Pkey,
                        act_id = ActId,
                        update_time = UpdateTime,
                        acc_val = AccVal,
                        get_list = util:bitstring_to_term(GetListBin)
                    }
            end
    end.

dbup_role_d_acc_charge(StRoleDAccCharge) ->
    #st_role_d_acc_charge{
        pkey = Pkey,
        act_id = ActId,
        update_time = UpdateTime,
        acc_val = AccVal,
        get_list = GetList
    } = StRoleDAccCharge,
    Sql = io_lib:format("replace into player_role_d_acc_charge set act_id=~p,update_time=~p,acc_val=~p,get_list='~s',pkey=~p",
        [ActId, UpdateTime, AccVal, util:term_to_bitstring(GetList), Pkey]),
    db:execute(Sql),
    ok.

dbget_con_charge(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_con_charge{
        pkey = Pkey,
        act_id = 0,
        charge_list = [],
        get_list = [],
        update_time = 0,
        get_gift_time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,charge_list,get_list,update_time,get_gift_time from player_con_charge where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, ChargeListBin, GetListBin, UpdateTime, GetGiftTime] ->
                    #st_con_charge{
                        pkey = Pkey,
                        act_id = ActId,
                        charge_list = util:bitstring_to_term(ChargeListBin),
                        get_list = util:bitstring_to_term(GetListBin),
                        update_time = UpdateTime,
                        get_gift_time = GetGiftTime
                    }
            end
    end.

dbup_con_charge(StConCharge) ->
    #st_con_charge{
        pkey = Pkey,
        act_id = ActId,
        charge_list = ChargeList,
        get_list = GetList,
        update_time = UpdateTime,
        get_gift_time = GetGiftTime
    } = StConCharge,
    Sql = io_lib:format("replace into player_con_charge set act_id=~p,charge_list='~s',get_list='~s',update_time=~p,get_gift_time=~p,pkey=~p",
        [ActId, util:term_to_bitstring(ChargeList), util:term_to_bitstring(GetList), UpdateTime, GetGiftTime, Pkey]),
    db:execute(Sql),
    ok.

dbget_open_egg(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_open_egg{
        pkey = Pkey,
        act_id = 0,
        charge_val = 0,
        use_times = 0,
        get_list = [],
        goods_list = [],
        update_time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,charge_val,use_times,get_list,goods_list,update_time from player_open_egg where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, ChargeVal, UseTimes, GetListBin, GoodsListBin, UpdateTime] ->
                    #st_open_egg{
                        pkey = Pkey,
                        act_id = ActId,
                        charge_val = ChargeVal,
                        use_times = UseTimes,
                        get_list = util:bitstring_to_term(GetListBin),
                        goods_list = util:bitstring_to_term(GoodsListBin),
                        update_time = UpdateTime
                    }
            end
    end.

dbup_open_egg(StOpenEgg) ->
    #st_open_egg{
        pkey = Pkey,
        act_id = ActId,
        charge_val = ChargeVal,
        use_times = UseTimes,
        get_list = GetList,
        goods_list = GoodsList,
        update_time = UpdateTime
    } = StOpenEgg,
    Sql = io_lib:format("replace into player_open_egg set act_id=~p,charge_val=~p,use_times=~p,get_list='~s',goods_list='~s',update_time=~p,pkey=~p",
        [ActId, ChargeVal, UseTimes, util:term_to_bitstring(GetList), util:term_to_bitstring(GoodsList), UpdateTime, Pkey]),
    db:execute(Sql),
    ok.

dbget_merge_sign_in(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_merge_sign_in{
        pkey = Pkey
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,get_list,get_gift_time,charge_list,charge_get_list,charge_gift_time,update_time from player_merge_sign_in where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, GetListBin, GetGiftTime, ChargeListBin, ChargeGetListBin, ChargeGiftTime, UpdateTime] ->
                    #st_merge_sign_in{
                        pkey = Pkey,
                        act_id = ActId,
                        get_list = util:bitstring_to_term(GetListBin),
                        get_gift_time = GetGiftTime,
                        charge_list = util:bitstring_to_term(ChargeListBin),
                        charge_get_list = util:bitstring_to_term(ChargeGetListBin),
                        charge_gift_time = ChargeGiftTime,
                        update_time = UpdateTime
                    }
            end
    end.

dbup_merge_sign_in(StMergeSignIn) ->
    #st_merge_sign_in{
        pkey = Pkey,
        act_id = ActId,
        get_list = GetList,
        get_gift_time = GetGiftTime,
        charge_list = ChargeList,
        charge_get_list = ChargeGetList,
        charge_gift_time = ChargeGiftTime,
        update_time = UpdateTime
    } = StMergeSignIn,
    Sql = io_lib:format("replace into player_merge_sign_in set act_id=~p,get_list='~s',get_gift_time=~p,charge_list='~s',charge_get_list='~s',charge_gift_time=~p,update_time=~p,pkey=~p",
        [ActId, util:term_to_bitstring(GetList), GetGiftTime, util:term_to_bitstring(ChargeList), util:term_to_bitstring(ChargeGetList), ChargeGiftTime, UpdateTime, Pkey]),
    db:execute(Sql),
    ok.

dbget_target_act(Player) ->
    #player{key = Pkey} = Player,
    St = #st_target_act{
        pkey = Pkey
    },
    case player_util:is_new_role(Player) of
        true -> St;
        false ->
            Sql = io_lib:format("select act_id,target_list from player_target_act where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] ->
                    St;
                [ActId, TargetListBin] ->
                    F = fun({Type, CurVal, GetList}) ->
                        #tar_act{
                            type = Type,
                            cur_val = CurVal,
                            get_list = GetList
                        }
                        end,
                    TargetList = lists:map(F, util:bitstring_to_term(TargetListBin)),
                    #st_target_act{
                        pkey = Pkey,
                        act_id = ActId,
                        target_list = TargetList
                    }
            end
    end.

dbup_target_act(St) ->
    #st_target_act{
        pkey = Pkey,
        act_id = ActId,
        target_list = TargetList
    } = St,
    F = fun(TarAct) ->
        #tar_act{
            type = Type,
            cur_val = CurVal,
            get_list = GetList
        } = TarAct,
        {Type, CurVal, GetList}
        end,
    List = lists:map(F, TargetList),
    Sql = io_lib:format("replace into player_target_act set act_id=~p,target_list='~s',pkey=~p",
        [ActId, util:term_to_bitstring(List), Pkey]),
    db:execute(Sql),
    ok.

dbget_vip_gift(Player) ->
    #player{key = Pkey} = Player,
    St = #st_vip_gift{
        pkey = Pkey
    },
    case player_util:is_new_role(Player) of
        true -> St;
        false ->
            Sql = io_lib:format("select act_id,buy_list,update_time from player_vip_gift where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> St;
                [ActId, BuyListBin, UpdateTime] ->
                    St#st_vip_gift{
                        act_id = ActId,
                        buy_list = util:bitstring_to_term(BuyListBin),
                        update_time = UpdateTime
                    }

            end
    end.

dbup_vip_gift(St) ->
    #st_vip_gift{
        pkey = Pkey,
        act_id = ActId,
        buy_list = BuyList,
        update_time = UpdateTime
    } = St,
    Sql = io_lib:format("replace into player_vip_gift set act_id=~p,buy_list='~s',update_time=~p,pkey=~p",
        [ActId, util:term_to_bitstring(BuyList), UpdateTime, Pkey]),
    db:execute(Sql),
    ok.

dbget_treasure_hourse(Pkey) ->
    Sql = io_lib:format("select charge_gold, act_id, is_recv, buy_list, op_time, recv_time, act_open_time from player_treasure_hourse where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ChargeGold, ActId, IsRecv, BuyListBin, OpTime, RecvTime, ActOpenTime] ->
            BuyList = util:bitstring_to_term(BuyListBin),
            #st_treasure_hourse{
                pkey = Pkey,
                act_id = ActId,
                charge_gold = ChargeGold,
                is_recv = IsRecv,
                buy_list = BuyList,
                op_time = OpTime,
                recv_time = ?IF_ELSE(RecvTime == 0, OpTime, RecvTime),
                act_open_time = ActOpenTime
            };
        _ ->
            #st_treasure_hourse{pkey = Pkey}
    end.

dbup_treasure_hourse(#st_treasure_hourse{pkey = Pkey, act_id = ActId, charge_gold = ChargeGold, is_recv = IsRecv, buy_list = BuyList, op_time = OpTime, recv_time = RecvTime, act_open_time = ActOpenTime}) ->
    BuyListBin = util:term_to_bitstring(BuyList),
    Sql = io_lib:format("replace into player_treasure_hourse set pkey=~p, act_id=~p, is_recv=~p, charge_gold=~p, buy_list='~s', op_time=~p, recv_time=~p, act_open_time=~p",
        [Pkey, ActId, IsRecv, ChargeGold, BuyListBin, OpTime, RecvTime, ActOpenTime]),
    db:execute(Sql),
    ok.

dbget_hqg_daily_charge(Pkey) ->
    Sql = io_lib:format("select act_id, acc_charge_gold, recv_acc, op_time, type1, type2, recv_first_list from player_hqg_daily_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, AccChargeGold, RecvAccBin, OpTime, Type1, Type2, RecvFirstListBin] ->
            RecvAcc = util:bitstring_to_term(RecvAccBin),
            RecvFirstList = util:bitstring_to_term(RecvFirstListBin),
            L1 = ?IF_ELSE(Type1 > 0, [{10, util:unixtime() - ?ONE_DAY_SECONDS}], []),
            L2 = ?IF_ELSE(Type2 > 0, [{99, util:unixtime() - ?ONE_DAY_SECONDS}], []),
            NewRecvFirstList = L1 ++ L2 ++ RecvFirstList,
            F = fun(ChargeGold) ->
                if
                    ChargeGold == 10 -> 1;
                    ChargeGold == 99 -> 2;
                    ChargeGold == 880 -> 3;
                    ChargeGold == 120 -> 2;
                    ChargeGold == 720 -> 3;
                    true -> ChargeGold
                end
                end,
            NewRecvAcc = lists:map(F, RecvAcc),
            F2 = fun({ChargeGold, Time}) ->
                NewChargeGold =
                    if
                        ChargeGold == 10 -> 1;
                        ChargeGold == 99 -> 2;
                        ChargeGold == 880 -> 3;
                        ChargeGold == 120 -> 2;
                        ChargeGold == 720 -> 3;
                        true -> ChargeGold
                    end,
                {NewChargeGold, Time}
                 end,
            NewRecvFirstList99 = lists:map(F2, NewRecvFirstList),
            #st_hqg_daily_charge{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                acc_charge = AccChargeGold,
                recv_acc = NewRecvAcc,
                recv_first_list = NewRecvFirstList99
            };
        _ ->
            #st_hqg_daily_charge{pkey = Pkey}
    end.

dbup_hqg_daily_charge(#st_hqg_daily_charge{pkey = Pkey, act_id = ActId, acc_charge = AccChargeGold, recv_acc = RecvAcc, op_time = OpTime, type1 = Type1, type2 = Type2, recv_first_list = RecvFirstList}) ->
    RecvAccBin = util:term_to_bitstring(util:list_filter_repeat(RecvAcc)),
    RecvFirstListBin = util:term_to_bitstring(RecvFirstList),
    Sql = io_lib:format("replace into player_hqg_daily_charge set pkey=~p, act_id=~p, acc_charge_gold=~p, recv_acc='~s', op_time=~p, type1=~p, type2=~p, recv_first_list='~s'",
        [Pkey, ActId, AccChargeGold, RecvAccBin, OpTime, Type1, Type2, RecvFirstListBin]),
    db:execute(Sql),
    ok.

dbget_open_act_jh_rank(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, op_time from player_open_act_jh_rank where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_jh_rank{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList
            };
        _ ->
            #st_open_act_jh_rank{pkey = Pkey}
    end.

dbup_open_act_jh_rank(#st_open_act_jh_rank{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_jh_rank set pkey=~p, act_id=~p,  recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_open_act_up_target(Pkey) ->
    Sql = io_lib:format("select open_day, recv_list, op_time from player_open_act_up_target where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [OpenDay, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_up_target{
                pkey = Pkey,
                open_day = OpenDay,
                op_time = OpTime,
                recv_list = RecvList
            };
        _ ->
            #st_open_act_up_target{pkey = Pkey}
    end.

dbup_open_act_up_target(#st_open_act_up_target{pkey = Pkey, open_day = OpenDay, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_up_target set pkey=~p, open_day=~p, recv_list='~s', op_time=~p",
        [Pkey, OpenDay, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_open_act_up_target2(Pkey) ->
    Sql = io_lib:format("select open_day, recv_list, op_time from player_open_act_up_target2 where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [OpenDay, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_up_target2{
                pkey = Pkey,
                open_day = OpenDay,
                op_time = OpTime,
                recv_list = RecvList
            };
        _ ->
            #st_open_act_up_target2{pkey = Pkey}
    end.

dbup_open_act_up_target2(#st_open_act_up_target2{pkey = Pkey, open_day = OpenDay, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_up_target2 set pkey=~p, open_day=~p,  recv_list='~s', op_time=~p",
        [Pkey, OpenDay, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_open_act_up_target3(Pkey) ->
    Sql = io_lib:format("select open_day, recv_list, op_time from player_open_act_up_target3 where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [OpenDay, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_up_target3{
                pkey = Pkey,
                open_day = OpenDay,
                op_time = OpTime,
                recv_list = RecvList
            };
        _ ->
            #st_open_act_up_target3{pkey = Pkey}
    end.

dbup_open_act_up_target3(#st_open_act_up_target3{pkey = Pkey, open_day = OpenDay, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_up_target3 set pkey=~p, open_day=~p,  recv_list='~s', op_time=~p",
        [Pkey, OpenDay, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_open_act_group_charge(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, charge_list, op_time from player_open_act_group_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, ChargeListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            ChargeList = util:bitstring_to_term(ChargeListBin),
            #st_open_act_group_charge{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList,
                charge_list = ChargeList
            };
        _ ->
            #st_open_act_group_charge{pkey = Pkey}
    end.

dbup_open_act_group_charge(#st_open_act_group_charge{pkey = Pkey, act_id = ActId, recv_list = RecvList, charge_list = ChargeList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    ChargeListBin = util:term_to_bitstring(ChargeList),
    Sql = io_lib:format("replace into player_open_act_group_charge set pkey=~p, act_id=~p,  recv_list='~s', charge_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, ChargeListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_all_open_act_group_charge(ActId) ->
    Sql = io_lib:format("select pkey, charge_list from player_open_act_group_charge where act_id=~p", [ActId]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Pkey, ChargeListBin]) ->
                ChargeList = util:bitstring_to_term(ChargeListBin),
                case ChargeList == [] of
                    true ->
                        [];
                    _ ->
                        [{Pkey, lists:sum(ChargeList)}]
                end
                end,
            lists:flatmap(F, Rows);
        _ ->
            []
    end.

dbget_open_act_acc_charge(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, acc_charge_gold, op_time from player_open_act_acc_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, AccChargeGold, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_acc_charge{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList,
                acc_charge_gold = AccChargeGold
            };
        _ ->
            #st_open_act_acc_charge{pkey = Pkey}
    end.

dbup_open_act_acc_charge(#st_open_act_acc_charge{pkey = Pkey, act_id = ActId, recv_list = RecvList, acc_charge_gold = AccChargeGold, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_acc_charge set pkey=~p, act_id=~p, recv_list='~s', acc_charge_gold=~p, op_time=~p",
        [Pkey, ActId, RecvListBin, AccChargeGold, OpTime]),
    db:execute(Sql),
    ok.

dbget_open_act_all_target(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, op_time from player_open_act_all_target where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_all_target{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList
            };
        _ ->
            #st_open_act_all_target{pkey = Pkey}
    end.

dbup_open_act_all_target(#st_open_act_all_target{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_all_target set pkey=~p, act_id=~p,  recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_all_open_act_all_target(ActId0) ->
    Sql = io_lib:format("select act_id,act_type,base_lv,base_num,num from open_act_all_target where act_id=~p", [ActId0]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([ActId, ActType, BaseLv, BaseNum, Num]) ->
                [{ActId, ActType, BaseLv, BaseNum, Num}]
                end,
            lists:flatmap(F, Rows);
        _ ->
            []
    end.

dbup_open_act_all_target_ets(#ets_open_all_target{act_id = ActId, act_type = ActType, base_lv = BaseLv, base_num = BaseNum, num = Num}) ->
    Sql = io_lib:format("replace into open_act_all_target set act_id=~p,  act_type=~p, base_lv=~p, base_num=~p, num=~p",
        [ActId, ActType, BaseLv, BaseNum, Num]),
    db:execute(Sql),
    ok.

dbget_open_act_all_target2(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, op_time from player_open_act_all_target2 where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_all_target2{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList
            };
        _ ->
            #st_open_act_all_target2{pkey = Pkey}
    end.

dbup_open_act_all_target2(#st_open_act_all_target2{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_all_target2 set pkey=~p, act_id=~p,  recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_all_open_act_all_target2(ActId0) ->
    Sql = io_lib:format("select act_id,act_type,base_lv,base_num,num from open_act_all_target2 where act_id=~p", [ActId0]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([ActId, ActType, BaseLv, BaseNum, Num]) ->
                [{ActId, ActType, BaseLv, BaseNum, Num}]
                end,
            lists:flatmap(F, Rows);
        _ ->
            []
    end.

dbup_open_act_all_target_ets2(#ets_open_all_target{act_id = ActId, act_type = ActType, base_lv = BaseLv, base_num = BaseNum, num = Num}) ->
    Sql = io_lib:format("replace into open_act_all_target2 set act_id=~p,  act_type=~p, base_lv=~p, base_num=~p, num=~p",
        [ActId, ActType, BaseLv, BaseNum, Num]),
    db:execute(Sql),
    ok.

dbget_open_act_all_target3(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, op_time from player_open_act_all_target3 where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_all_target3{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList
            };
        _ ->
            #st_open_act_all_target3{pkey = Pkey}
    end.

dbup_open_act_all_target3(#st_open_act_all_target3{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_all_target3 set pkey=~p, act_id=~p,  recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_all_open_act_all_target3(ActId0) ->
    Sql = io_lib:format("select act_id,act_type,base_lv,base_num,num from open_act_all_target3 where act_id=~p", [ActId0]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([ActId, ActType, BaseLv, BaseNum, Num]) ->
                [{ActId, ActType, BaseLv, BaseNum, Num}]
                end,
            lists:flatmap(F, Rows);
        _ ->
            []
    end.

dbup_open_act_all_target_ets3(#ets_open_all_target{act_id = ActId, act_type = ActType, base_lv = BaseLv, base_num = BaseNum, num = Num}) ->
    Sql = io_lib:format("replace into open_act_all_target3 set act_id=~p,  act_type=~p, base_lv=~p, base_num=~p, num=~p",
        [ActId, ActType, BaseLv, BaseNum, Num]),
    db:execute(Sql),
    ok.

dbget_open_act_all_rank(Pkey) ->
    %% 暂时这样写
    Sql = io_lib:format("select act_id, recv_list, op_time from player_open_act_all_rank where pkey=~p group by act_id desc limit 1", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_all_rank{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList
            };
        _Other ->
            #st_open_act_all_rank{pkey = Pkey}
    end.

dbup_open_act_all_rank(#st_open_act_all_rank{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_all_rank set pkey=~p, act_id=~p,  recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_open_act_all_rank2(Pkey) ->
    %% 暂时这样写
    Sql = io_lib:format("select act_id, recv_list, op_time from player_open_act_all_rank2 where pkey=~p group by act_id desc limit 1", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_all_rank2{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList
            };
        _Other ->
            #st_open_act_all_rank2{pkey = Pkey}
    end.

dbup_open_act_all_rank2(#st_open_act_all_rank2{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_all_rank2 set pkey=~p, act_id=~p,  recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_open_act_all_rank3(Pkey) ->
    %% 暂时这样写
    Sql = io_lib:format("select act_id, recv_list, op_time from player_open_act_all_rank3 where pkey=~p group by act_id desc limit 1", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_open_act_all_rank3{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList
            };
        _Other ->
            #st_open_act_all_rank3{pkey = Pkey}
    end.

dbup_open_act_all_rank3(#st_open_act_all_rank3{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_open_act_all_rank3 set pkey=~p, act_id=~p,  recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_act_invest(Pkey) ->
    Sql = io_lib:format("select invest_gold, recv_list, act_num, recv_time, op_time from player_act_invest where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [InvestGold, RecvListBin, ActNum, RecvTime, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_act_invest{
                pkey = Pkey,
                invest_gold = InvestGold,
                op_time = OpTime,
                recv_list = RecvList,
                act_num = ?IF_ELSE(ActNum == 0, 1, ActNum), %% 这个字段首次上线，修复数据
                recv_time = ?IF_ELSE(RecvTime == 0, OpTime, RecvTime) %% 这个字段首次上线，修复数据
            };
        _ ->
            #st_act_invest{pkey = Pkey}
    end.

dbup_act_invest(#st_act_invest{pkey = Pkey, invest_gold = InvestGold, recv_list = RecvList, op_time = OpTime, act_num = ActNum, recv_time = RecvTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_act_invest set pkey=~p, invest_gold=~p,  recv_list='~s', op_time=~p, act_num=~p, recv_time=~p",
        [Pkey, InvestGold, RecvListBin, OpTime, ActNum, RecvTime]),
    db:execute(Sql),
    ok.

dbget_act_map(Pkey) ->
    Sql = io_lib:format("select act_id, step, pass_num, use_free_num, recv_list, op_time from player_act_map where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, Step, PassNum, UseFreeNum, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_act_map{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                step = Step,
                pass_num = PassNum,
                recv_list = RecvList,
                use_free_num = UseFreeNum
            };
        _ ->
            #st_act_map{pkey = Pkey}
    end.

dbup_act_map(#st_act_map{pkey = Pkey, act_id = ActId, pass_num = PassNum, step = Step, use_free_num = UseFreeNum, op_time = OpTime, recv_list = RecvList}) ->
    Sql = io_lib:format("replace into player_act_map set pkey=~p, act_id=~p, step=~p, pass_num=~p, use_free_num=~p, op_time=~p, recv_list='~s'",
        [Pkey, ActId, Step, PassNum, UseFreeNum, OpTime, util:term_to_bitstring(RecvList)]),
    db:execute(Sql),
    ok.

dbget_all_act_map(ActId) ->
    Time = util:unixdate(),
    Sql = io_lib:format("select sum(pass_num) from player_act_map where act_id=~p and op_time>~p and op_time<~p", [ActId, Time, Time + ?ONE_DAY_SECONDS]),
    case db:get_row(Sql) of
        [null] ->
            #ets_map_log_sys{act_id = ActId};
        [PassNum] ->
            #ets_map_log_sys{
                act_id = ActId,
                pass_num = PassNum
            };
        _ ->
            #ets_map_log_sys{act_id = ActId}
    end.



dbget_uplv_box(Pkey) ->
    Sql = io_lib:format("select open_day, recv_list, use_free_num, op_time, online_time from player_uplv_box where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [OpenDay, RecvListBin, UseFreeNum, OpTime, OnlineTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_uplv_box{
                pkey = Pkey,
                open_day = OpenDay,
                op_time = OpTime,
                recv_list = RecvList,
                use_free_num = UseFreeNum,
                online_time = OnlineTime,
                last_login_time = util:unixtime()
            };
        _ ->
            #st_uplv_box{pkey = Pkey}
    end.

dbup_uplv_box(#st_uplv_box{pkey = Pkey, open_day = OpenDay, recv_list = RecvList, use_free_num = UseFreeNum, op_time = OpTime, online_time = OnlineTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_uplv_box set pkey=~p, open_day=~p, recv_list='~s', use_free_num=~p, op_time=~p, online_time=~p",
        [Pkey, OpenDay, RecvListBin, UseFreeNum, OpTime, OnlineTime]),
    db:execute(Sql),
    ok.

dbget_limit_buy(Pkey) ->
    Sql = io_lib:format("select act_id, buy_list, recv_list, op_time from player_limit_buy where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, BuyListBin, RecvListBin, OpTime] ->
            BuyList = util:bitstring_to_term(BuyListBin),
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_limit_buy{
                pkey = Pkey,
                act_id = ActId,
                buy_list = BuyList,
                recv_list = RecvList,
                op_time = OpTime
            };
        _ ->
            #st_limit_buy{pkey = Pkey}
    end.

dbup_limit_buy(#st_limit_buy{pkey = Pkey, act_id = ActId, buy_list = BuyList, recv_list = RecvList, op_time = OpTime}) ->
    BuyListBin = util:term_to_bitstring(BuyList),
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_limit_buy set pkey=~p, act_id=~p, buy_list='~s', recv_list='~s', op_time=~p",
        [Pkey, ActId, BuyListBin, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_all_limit_buy(ActId) ->
    Sql = io_lib:format("select sys_buy_list from sys_limit_buy where act_id=~p", [ActId]),
    case db:get_row(Sql) of
        [null] ->
            #ets_limit_buy{act_id = ActId};
        [BuyListBin] ->
            BuyList = util:bitstring_to_term(BuyListBin),
            #ets_limit_buy{
                act_id = ActId,
                buy_list = BuyList
            };
        _ ->
            #ets_limit_buy{act_id = ActId}
    end.

dbup_all_limit_buy(#ets_limit_buy{act_id = ActId, buy_list = BuyList}) ->
    BuyListBin = util:term_to_bitstring(BuyList),
    Sql = io_lib:format("replace into sys_limit_buy set act_id=~p, sys_buy_list='~s'", [ActId, BuyListBin]),
    db:execute(Sql),
    ok.

dbget_fuwen_map(Pkey) ->
    Sql = io_lib:format("select act_id, luck_value, fuwen_bag_id, last_free_time, op_time from player_fuwen_map where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, LuckValue, FuwenBagId, LastFreeTime, OpTime] ->
            #st_fuwen_map{
                pkey = Pkey,
                act_id = ActId,
                luck_value = LuckValue,
                fuwen_bag_id = FuwenBagId,
                last_free_time = LastFreeTime,
                op_time = OpTime
            };
        _ ->
            #st_fuwen_map{pkey = Pkey}
    end.

dbup_fuwen_map(#st_fuwen_map{pkey = Pkey, act_id = ActId, luck_value = LuckValue, fuwen_bag_id = FuwenBagId, last_free_time = LastFreeTime, op_time = OpTime}) ->
    Sql = io_lib:format("replace into player_fuwen_map set pkey=~p, act_id=~p, luck_value=~p, fuwen_bag_id=~p, last_free_time=~p, op_time=~p",
        [Pkey, ActId, LuckValue, FuwenBagId, LastFreeTime, OpTime]),
    db:execute(Sql),
    ok.

dbget_jiandao_map(Pkey) ->
    Sql = io_lib:format("select act_id, luck_value, jiandao_bag_id, last_free_time, op_time from player_jiandao_map where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, LuckValue, FuwenBagId, LastFreeTime, OpTime] ->
            #st_jiandao_map{
                pkey = Pkey,
                act_id = ActId,
                luck_value = LuckValue,
                jiandao_bag_id = FuwenBagId,
                last_free_time = LastFreeTime,
                op_time = OpTime
            };
        _ ->
            #st_jiandao_map{pkey = Pkey}
    end.

dbup_jiandao_map(#st_jiandao_map{pkey = Pkey, act_id = ActId, luck_value = LuckValue, jiandao_bag_id = FuwenBagId, last_free_time = LastFreeTime, op_time = OpTime}) ->
    Sql = io_lib:format("replace into player_jiandao_map set pkey=~p, act_id=~p, luck_value=~p, jiandao_bag_id=~p, last_free_time=~p, op_time=~p",
        [Pkey, ActId, LuckValue, FuwenBagId, LastFreeTime, OpTime]),
    db:execute(Sql),
    ok.

dbget_hundred_return(Player) ->
    #player{key = Pkey} = Player,
    InitSt = #st_hundred_return{
        pkey = Pkey,
        act_id = 0,
        state = 0
    },
    case player_util:is_new_role(Player) of
        true -> InitSt;
        false ->
            Sql = io_lib:format("select act_id,state from player_hundred_return where pkey = ~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> InitSt;
                [ActId, State] ->
                    #st_hundred_return{
                        pkey = Pkey,
                        act_id = ActId,
                        state = State
                    }
            end
    end.

dbup_hundred_return(St) ->
    #st_hundred_return{
        pkey = Pkey,
        act_id = ActId,
        state = State
    } = St,
    Sql = io_lib:format("replace into player_hundred_return set act_id=~p,state=~p,pkey=~p",
        [ActId, State, Pkey]),
    db:execute(Sql),
    ok.

dbget_login_online(Pkey) ->
    Sql = io_lib:format("select act_id, charge_gold, login_gift, online_gift_list, op_time from player_login_online where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, ChargeGold, LoginGift, OnlineGiftListBin, OpTime] ->
            OnlineGiftList = util:bitstring_to_term(OnlineGiftListBin),
            #st_login_online{
                pkey = Pkey,
                act_id = ActId,
                charge_gold = ChargeGold,
                is_recv_login = LoginGift,
                recv_online_list = OnlineGiftList,
                op_time = OpTime
            };
        _ ->
            #st_login_online{pkey = Pkey}
    end.

dbup_login_online(#st_login_online{pkey = Pkey, charge_gold = ChargeGold, act_id = ActId, is_recv_login = IsRecvLogin, recv_online_list = OnlineGiftList, op_time = OpTime}) ->
    OnlineGiftListBin = util:term_to_bitstring(OnlineGiftList),
    Sql = io_lib:format("replace into player_login_online set pkey=~p, charge_gold=~p, act_id=~p, login_gift=~p, online_gift_list='~s', op_time=~p",
        [Pkey, ChargeGold, ActId, IsRecvLogin, OnlineGiftListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_new_exchange(Pkey) ->
    Sql = io_lib:format("select act_id, exchange_list, op_time from player_new_exchange where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, ExchangeListBin, OpTime] ->
            ExchangeList = util:bitstring_to_term(ExchangeListBin),
            #st_new_exchange{
                pkey = Pkey,
                act_id = ActId,
                exchange_list = ExchangeList,
                op_time = OpTime
            };
        _ ->
            #st_new_exchange{pkey = Pkey}
    end.

dbup_new_exchange(#st_new_exchange{pkey = Pkey, act_id = ActId, exchange_list = ExchangeList, op_time = OpTime}) ->
    ExchangeListBin = util:term_to_bitstring(ExchangeList),
    Sql = io_lib:format("replace into player_new_exchange set pkey=~p, act_id=~p, exchange_list='~s', op_time=~p",
        [Pkey, ActId, ExchangeListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_equip_sell(Pkey) ->
    Sql = io_lib:format("select act_id, buy_list from player_act_equip_sell where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, BuyListBin] ->
            BuyList = util:bitstring_to_term(BuyListBin),
            #st_equip_sell{
                pkey = Pkey,
                act_id = ActId,
                buy_list = BuyList
            };
        _ ->
            #st_equip_sell{pkey = Pkey}
    end.

dbup_equip_sell(#st_equip_sell{pkey = Pkey, act_id = ActId, buy_list = BuyList}) ->
    BuyListBin = util:term_to_bitstring(BuyList),
    Sql = io_lib:format("replace into player_act_equip_sell set pkey=~p, act_id=~p, buy_list='~s'",
        [Pkey, ActId, BuyListBin]),
    db:execute(Sql),
    ok.

dbget_act_convoy(Pkey) ->
    Sql = io_lib:format("select act_id, convoy_num, op_time, is_recv from player_act_convoy where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, ConvoyNum, OpTime, IsRecv] ->
            #st_act_convoy{
                pkey = Pkey,
                act_id = ActId,
                convoy_num = ConvoyNum,
                is_recv = IsRecv,
                op_time = OpTime
            };
        _ ->
            #st_act_convoy{pkey = Pkey}
    end.

dbup_act_convoy(#st_act_convoy{pkey = Pkey, act_id = ActId, convoy_num = ConvoyNum, is_recv = IsRecv, op_time = OpTime}) ->
    Sql = io_lib:format("replace into player_act_convoy set pkey=~p, act_id=~p,  convoy_num=~p, is_recv=~p, op_time=~p",
        [Pkey, ActId, ConvoyNum, IsRecv, OpTime]),
    db:execute(Sql),
    ok.


dbget_acc_charge_d_info(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_acc_charge_d{
        pkey = Pkey,
        acc_val = 0,
        get_acc_ids = [],
        act_id = 0,
        time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select acc_val,get_acc_ids,act_id,`time` from player_acc_recharge_d where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [AccVal, GetAccIdsBin, ActId, Time] ->
                    #st_acc_charge_d{
                        pkey = Pkey,
                        acc_val = AccVal,
                        get_acc_ids = util:bitstring_to_term(GetAccIdsBin),
                        act_id = ActId,
                        time = Time
                    }
            end
    end.

dbup_acc_charge_d_info(AccChargeSt) ->
    #st_acc_charge_d{
        pkey = Pkey,
        acc_val = AccVal,
        get_acc_ids = GetAccIds,
        act_id = ActId,
        time = Time
    } = AccChargeSt,
    Sql = io_lib:format("replace into player_acc_recharge_d set acc_val=~p,get_acc_ids='~s',act_id=~p,`time`=~p, pkey=~p",
        [AccVal, util:term_to_bitstring(GetAccIds), ActId, Time, Pkey]),
    db:execute(Sql),
    ok.

dbget_consume_back_charge(Pkey) ->
    Sql = io_lib:format("select act_id, consume_gold, back_num, back_gold, back_list, log, op_time from player_consume_back_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, ConsumeGold, BackNum, BackGold, BackListBin, LogBin, OpTime] ->
            BackList = util:bitstring_to_term(BackListBin),
            Log = util:bitstring_to_term(LogBin),
            #st_consume_back_charge{
                pkey = Pkey,
                act_id = ActId,
                consume_gold = ConsumeGold,
                back_gold = BackGold,
                back_num = BackNum,
                back_list = BackList,
                log = Log,
                op_time = OpTime
            };
        _ ->
            #st_consume_back_charge{pkey = Pkey}
    end.

dbup_consume_back_charge(#st_consume_back_charge{pkey = Pkey, act_id = ActId, consume_gold = ConsumeGold, back_gold = BackGold, back_num = BackNum, back_list = BackList, log = Log, op_time = OpTime}) ->
    BackListBin = util:term_to_bitstring(BackList),
    LogBin = util:term_to_bitstring(Log),
    Sql = io_lib:format("replace into player_consume_back_charge set pkey=~p, act_id=~p, consume_gold=~p, back_num=~p, back_gold=~p, back_list='~s', log='~s', op_time=~p",
        [Pkey, ActId, ConsumeGold, BackNum, BackGold, BackListBin, LogBin, OpTime]),
    db:execute(Sql),
    ok.


dbup_consume_rank(#st_consume_rank{pkey = Pkey, act_id = ActId, consume_gold = Consumer, change_time = Now, name = NickName, lv = Lv}) ->
    Sql = io_lib:format("replace into player_consume_rank set pkey=~p, act_id=~p,  consume_gold=~p,nickname = '~s',change_time = ~p,lv =~p",
        [Pkey, ActId, Consumer, NickName, Now, Lv]),
    db:execute(Sql),
    ok.

dbget_consume_rank(#player{key = Pkey, nickname = Name, lv = Lv} = _Player) ->
    NewSt = #st_consume_rank{
        pkey = Pkey,
        act_id = 0,
        consume_gold = 0,
        name = Name,
        lv = Lv
    },
    Sql = io_lib:format("select consume_gold,act_id,change_time,nickname,lv from player_consume_rank where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [] -> NewSt;
        [ConsumeValues, ActId, ChangeTime, NickName, Lv0] ->
            #st_consume_rank{
                pkey = Pkey,
                act_id = ActId,
                consume_gold = ConsumeValues,
                change_time = ChangeTime,
                name = NickName,
                lv = Lv0
            }
    end.


dbget_player_marry_rank(#player{key = Pkey} = _Player) ->
    NewSt = #st_marry_rank{
        pkey = Pkey,
        act_id = 0,
        rank = 0,
        record_time = 0
    },
    Sql = io_lib:format("select act_id,record_time,re_state from player_marry_rank where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [] -> NewSt;
        [ActId, RecordTime, ReState] ->
            #st_marry_rank{
                pkey = Pkey,
                act_id = ActId,
                record_time = RecordTime,
                state = ReState
            }
    end.

dbup_player_marry_rank(#st_marry_rank{pkey = Pkey, act_id = ActId, state = State, record_time = RecordTime}) ->
    Sql = io_lib:format("replace into player_marry_rank set pkey=~p, act_id=~p,re_state = ~p,record_time = ~p",
        [Pkey, ActId, State, RecordTime]),
    db:execute(Sql),
    ok.

dbup_recharge_rank(#st_recharge_rank{pkey = Pkey, act_id = ActId, recharge_gold = Recharge, change_time = Now, name = NickName, lv = Lv}) ->
    Sql = io_lib:format("replace into player_recharge_rank set pkey=~p, act_id=~p,  recharge_gold=~p,nickname = '~s',change_time = ~p,lv = ~p",
        [Pkey, ActId, Recharge, NickName, Now, Lv]),
    db:execute(Sql),
    ok.

dbget_recharge_rank(#player{key = Pkey, nickname = Name, lv = Lv} = _Player) ->
    NewSt = #st_recharge_rank{
        pkey = Pkey,
        act_id = 0,
        recharge_gold = 0,
        name = Name,
        lv = Lv
    },
    Sql = io_lib:format("select recharge_gold,act_id,change_time,nickname,lv from player_recharge_rank where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [] -> NewSt;
        [RechargeValues, ActId, ChangeTime, NickName, Lv0] ->
            #st_recharge_rank{
                pkey = Pkey,
                act_id = ActId,
                recharge_gold = RechargeValues,
                change_time = ChangeTime,
                name = NickName,
                lv = Lv0
            }
    end.

dbget_xj_map(Pkey) ->
    Sql = io_lib:format("select act_id, step, use_free_num, use_reset_num, op_time from player_xj_map where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, Step, UseFreeNum, UseResetNum, OpTime] ->
            #st_xj_map{
                pkey = Pkey,
                act_id = ActId,
                step = Step,
                use_free_num = UseFreeNum,
                use_reset_num = UseResetNum,
                op_time = OpTime
            };
        _ ->
            #st_xj_map{pkey = Pkey}
    end.

dbup_xj_map(#st_xj_map{pkey = Pkey, act_id = ActId, step = Step, use_free_num = UseFreeNum, use_reset_num = UseResetNum, op_time = OpTime}) ->
    Sql = io_lib:format("replace into player_xj_map set pkey=~p, act_id=~p, step=~p, use_free_num=~p, use_reset_num=~p, op_time=~p",
        [Pkey, ActId, Step, UseFreeNum, UseResetNum, OpTime]),
    db:execute(Sql),
    ok.


dbget_act_con_charge(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_con_recharge{
        pkey = Pkey
        , act_id = 0
        , recharge_list = []
        , award_list = []
        , daily_list = []
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,recharge_list,award_list,daily_list,act_list,change_time  from player_act_con_recharge where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, RechargeList, AwardList, DailyList0, ActList, ChangeTime] ->
                    Now = util:unixtime(),
                    case util:is_same_date(ChangeTime, Now) of
                        true -> DailyList = util:bitstring_to_term(DailyList0);
                        _ -> DailyList = []
                    end,
                    #st_con_recharge{
                        pkey = Pkey
                        , act_id = ActId
                        , recharge_list = util:bitstring_to_term(RechargeList)
                        , award_list = util:bitstring_to_term(AwardList)
                        , act_list = util:bitstring_to_term(ActList)
                        , daily_list = DailyList
                        , change_time = Now
                    }
            end
    end.


dbup_act_con_charge(AccChargeSt) ->
    #st_con_recharge{
        pkey = Pkey
        , act_id = ActId
        , recharge_list = RechargeList
        , award_list = AwardList
        , daily_list = DailyList
        , change_time = ChangeTime
        , act_list = ActList
    } = AccChargeSt,
    Sql = io_lib:format("replace into player_act_con_recharge set act_id=~p,recharge_list='~s',award_list='~s',daily_list='~s',act_list = '~s',  pkey=~p,change_time = ~p",
        [ActId,
            util:term_to_bitstring(RechargeList),
            util:term_to_bitstring(AwardList),
            util:term_to_bitstring(DailyList),
            util:term_to_bitstring(ActList),
            Pkey,
            ChangeTime]),
    db:execute(Sql),
    ok.

dbget_gold_silver_tower(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_gold_silver_tower{
        pkey = Pkey
        , act_id = 0
        , count_list = []
        , index_floor = 1
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select act_id,count_list,index_floor from player_gold_silver_tower where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ActId, CountList, Index] ->
                    #st_gold_silver_tower{
                        pkey = Pkey
                        , act_id = ActId
                        , count_list = util:bitstring_to_term(CountList)
                        , index_floor = Index
                    }
            end
    end.

dbup_gold_silver_tower(#st_gold_silver_tower{pkey = Pkey, act_id = ActId, count_list = CountList, index_floor = IndesFloor}) ->
    Sql = io_lib:format("replace into player_gold_silver_tower set pkey = ~p,act_id=~p, count_list='~s',  index_floor=~p",
        [Pkey, ActId, util:term_to_bitstring(CountList), IndesFloor]),
    db:execute(Sql),
    ok.

dbget_gold_silver_tower_ets(ActId) ->
    Sql = io_lib:format("select sys_buy_list from gold_silver_tower_ets where act_id=~p", [ActId]),
    case db:get_row(Sql) of
        [null] ->
            #ets_gold_silver_tower{act_id = ActId};
        [BuyListBin] ->
            BuyList = util:bitstring_to_term(BuyListBin),
            #ets_gold_silver_tower{
                act_id = ActId,
                buy_list = BuyList
            };
        _ ->
            #ets_gold_silver_tower{act_id = ActId}
    end.

dbup_gold_silver_tower_ets(#ets_gold_silver_tower{act_id = ActId, buy_list = BuyList}) ->
    BuyListBin = util:term_to_bitstring(BuyList),
    Sql = io_lib:format("replace into gold_silver_tower_ets set act_id=~p, sys_buy_list='~s'", [ActId, BuyListBin]),
    db:execute(Sql),
    ok.

dbget_open_act_back_buy(Pkey) ->
    Sql = io_lib:format("select open_day, buy_list, op_time from player_open_act_back_buy where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [OpenDay, BuyListBin, OpTime] ->
            #st_act_back_buy{
                pkey = Pkey,
                open_day = OpenDay,
                buy_list = util:bitstring_to_term(BuyListBin),
                op_time = OpTime
            };
        _ ->
            #st_act_back_buy{pkey = Pkey}
    end.

dbup_open_act_back_buy(#st_act_back_buy{pkey = Pkey, open_day = OpenDay, buy_list = BuyList, op_time = OpTime}) ->
    BuyListBin = util:term_to_bitstring(BuyList),
    Sql = io_lib:format("replace into player_open_act_back_buy set pkey=~p, open_day=~p, buy_list='~s', op_time=~p",
        [Pkey, OpenDay, BuyListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_all_back_buy(OpenDay) ->
    Sql = io_lib:format("select id, total_num from act_back_buy where open_day=~p", [OpenDay]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            Rows;
        _ ->
            []
    end.

dbup_all_back_buy(#ets_open_back_buy{open_day = OpenDay, order_id = Id, total_num = TotalNum}) ->
    Sql = io_lib:format("replace into act_back_buy set open_day=~p, id=~p, total_num=~p", [OpenDay, Id, TotalNum]),
    db:execute(Sql),
    ok.

dbreplace_activity_area_group(ActivityName, IdList, GroupLsit) ->
    Sql = io_lib:format("replace into activity_area_group set activity_name = '~s',id_list='~s',group_list='~s'",
        [ActivityName, util:term_to_bitstring(IdList), util:term_to_bitstring(GroupLsit)]),
    db:execute(Sql).

dbget_activity_area_group(ActivityName) ->
    Sql = io_lib:format("select id_list,group_list from activity_area_group where activity_name = '~s'", [ActivityName]),
    case db:get_row(Sql) of
        [] ->
            {[], []};
        [IdList, GroupLsit] ->
            {util:list_filter_repeat(util:bitstring_to_term(IdList)), util:bitstring_to_term(GroupLsit)}
    end.

dbget_buy_money(Pkey) ->
    Sql = io_lib:format("select coin_free_num,coin_all_num,xinghun_free_num,xinghun_all_num,online_time,last_login_time from player_buy_money where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [CoinFreeNum, CoinAllNum, XinghunFreeNum, XinghunAllNum, OnlineTime, LastLoginTime] ->
            #st_buy_money{
                pkey = Pkey
                , coin_free_num = CoinFreeNum
                , coin_all_num = CoinAllNum
                , xinghun_free_num = XinghunFreeNum
                , xinghun_all_num = XinghunAllNum
                , online_time = OnlineTime
                , last_login_time = LastLoginTime
            };
        _ ->
            #st_buy_money{pkey = Pkey}
    end.

dbup_buy_money(#st_buy_money{pkey = Pkey, coin_free_num = CoinFreeNum, coin_all_num = CoinAllNum, xinghun_free_num = XinghunFreeNum, xinghun_all_num = XinghunAllNum, online_time = OnlineTime, last_login_time = LastLoginTime}) ->
    Sql = io_lib:format("replace into player_buy_money set pkey=~p, coin_free_num=~p, coin_all_num=~p, xinghun_free_num=~p, xinghun_all_num=~p, online_time=~p,last_login_time=~p",
        [Pkey, CoinFreeNum, CoinAllNum, XinghunFreeNum, XinghunAllNum, OnlineTime, LastLoginTime]),
    db:execute(Sql),
    ok.

dbget_act_daily_task(Pkey) ->
    Sql = io_lib:format("select trigger_list,get_list,last_login_time from player_act_daily_task where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [TriggerList, GetList, LastLoginTime] ->
            #st_act_daily_task{
                pkey = Pkey
                , trigger_list = util:bitstring_to_term(TriggerList)
                , get_list = util:bitstring_to_term(GetList)
                , last_login_time = LastLoginTime
            };
        _ ->
            #st_act_daily_task{pkey = Pkey}
    end.

dbup_act_daily_task(#st_act_daily_task{pkey = Pkey, last_login_time = LastLoginTime, trigger_list = TriggerList, get_list = GetList}) ->
    Sql = io_lib:format("replace into player_act_daily_task set pkey=~p,last_login_time=~p,trigger_list='~s',get_list='~s'",
        [Pkey, LastLoginTime, util:term_to_bitstring(TriggerList), util:term_to_bitstring(GetList)]),
    db:execute(Sql),
    ok.

dbget_act_flip_card(Pkey) ->
    Sql = io_lib:format("select same_flag,card_list,last_login_time,log_list from player_act_flip_card where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [SameFlag, CardList, LastLoginTime, LogList] ->
            #st_act_flip_card{
                pkey = Pkey
                , same_flag = SameFlag
                , card_list = util:bitstring_to_term(CardList)
                , last_login_time = LastLoginTime
                , log_list = util:bitstring_to_term(LogList)
            };
        _ ->
            #st_act_flip_card{pkey = Pkey}
    end.

dbup_act_flip_card(#st_act_flip_card{pkey = Pkey, card_list = CardList, same_flag = SameFlag, last_login_time = LastLoginTime, log_list = LogList}) ->
    Sql = io_lib:format("replace into player_act_flip_card set pkey=~p,card_list = '~s',  same_flag=~p,last_login_time=~p,log_list='~s'",
        [Pkey, util:term_to_bitstring(CardList), SameFlag, LastLoginTime, util:term_to_bitstring(LogList)]),
    db:execute(Sql),
    ok.

dbget_online_reward(Pkey) ->
    Sql = io_lib:format("select use_count,online_time,reward,last_login_time from player_online_reward where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [UseCount, OnlineTime, Reward, LastLoginTime] ->
            #st_online_reward{
                pkey = Pkey
                , use_count = UseCount
                , online_time = OnlineTime
                , reward = util:bitstring_to_term(Reward)
                , last_login_time = LastLoginTime
            };
        _ ->
            #st_online_reward{pkey = Pkey}
    end.

dbup_online_reward(#st_online_reward{pkey = Pkey, reward = Reward, use_count = UseCount, online_time = OnlineTime, last_login_time = LastLoginTime}) ->
    Sql = io_lib:format("replace into player_online_reward set pkey=~p,use_count = ~p, reward='~s', online_time=~p,last_login_time=~p",
        [Pkey, UseCount, util:term_to_bitstring(Reward), OnlineTime, LastLoginTime]),
    db:execute(Sql),
    ok.

dbget_merge_act_group_charge(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, charge_list, op_time from player_merge_act_group_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, ChargeListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            ChargeList = util:bitstring_to_term(ChargeListBin),
            #st_merge_act_group_charge{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList,
                charge_list = ChargeList
            };
        _ ->
            #st_merge_act_group_charge{pkey = Pkey}
    end.

dbup_merge_act_group_charge(#st_merge_act_group_charge{pkey = Pkey, act_id = ActId, recv_list = RecvList, charge_list = ChargeList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    ChargeListBin = util:term_to_bitstring(ChargeList),
    Sql = io_lib:format("replace into player_merge_act_group_charge set pkey=~p, act_id=~p,  recv_list='~s', charge_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, ChargeListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_all_merge_act_group_charge(ActId) ->
    Sql = io_lib:format("select pkey, charge_list from player_merge_act_group_charge where act_id=~p", [ActId]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Pkey, ChargeListBin]) ->
                ChargeList = util:bitstring_to_term(ChargeListBin),
                case ChargeList == [] of
                    true ->
                        [];
                    _ ->
                        [{Pkey, lists:sum(ChargeList)}]
                end
                end,
            lists:flatmap(F, Rows);
        _ ->
            []
    end.

dbget_merge_act_up_target(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, op_time from player_merge_act_up_target where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_merge_act_up_target{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList
            };
        _ ->
            #st_merge_act_up_target{pkey = Pkey}
    end.

dbup_merge_act_up_target(#st_merge_act_up_target{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_merge_act_up_target set pkey=~p, act_id=~p,  recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_merge_act_up_target2(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, op_time from player_merge_act_up_target2 where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_merge_act_up_target2{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList
            };
        _ ->
            #st_merge_act_up_target2{pkey = Pkey}
    end.

dbup_merge_act_up_target2(#st_merge_act_up_target2{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_merge_act_up_target2 set pkey=~p, act_id=~p,  recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_merge_act_up_target3(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, op_time from player_merge_act_up_target3 where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_merge_act_up_target3{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList
            };
        _ ->
            #st_merge_act_up_target3{pkey = Pkey}
    end.

dbup_merge_act_up_target3(#st_merge_act_up_target3{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_merge_act_up_target3 set pkey=~p, act_id=~p,  recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_merge_act_acc_charge(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, acc_charge_gold, op_time from player_merge_act_acc_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, AccChargeGold, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_merge_act_acc_charge{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList,
                acc_charge_gold = AccChargeGold
            };
        _ ->
            #st_merge_act_acc_charge{pkey = Pkey}
    end.

dbup_merge_act_acc_charge(#st_merge_act_acc_charge{pkey = Pkey, act_id = ActId, recv_list = RecvList, acc_charge_gold = AccChargeGold, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_merge_act_acc_charge set pkey=~p, act_id=~p, recv_list='~s', acc_charge_gold=~p, op_time=~p",
        [Pkey, ActId, RecvListBin, AccChargeGold, OpTime]),
    db:execute(Sql),
    ok.

dbget_act_other_charge(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, acc_charge_gold, op_time from player_act_other_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, AccChargeGold, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_act_other_charge{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList,
                acc_charge_gold = AccChargeGold
            };
        _ ->
            #st_act_other_charge{pkey = Pkey}
    end.

dbup_act_other_charge(#st_act_other_charge{pkey = Pkey, act_id = ActId, recv_list = RecvList, acc_charge_gold = AccChargeGold, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_act_other_charge set pkey=~p, act_id=~p, recv_list='~s', acc_charge_gold=~p, op_time=~p",
        [Pkey, ActId, RecvListBin, AccChargeGold, OpTime]),
    db:execute(Sql),
    ok.

dbget_act_super_charge(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, acc_charge_gold, op_time from player_act_super_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, AccChargeGold, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_act_super_charge{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList,
                acc_charge_gold = AccChargeGold
            };
        _ ->
            #st_act_super_charge{pkey = Pkey}
    end.

dbup_act_super_charge(#st_act_super_charge{pkey = Pkey, act_id = ActId, recv_list = RecvList, acc_charge_gold = AccChargeGold, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_act_super_charge set pkey=~p, act_id=~p, recv_list='~s', acc_charge_gold=~p, op_time=~p",
        [Pkey, ActId, RecvListBin, AccChargeGold, OpTime]),
    db:execute(Sql),
    ok.

dbget_merge_act_back_buy(Pkey) ->
    Sql = io_lib:format("select act_id, buy_list, op_time from player_merge_act_back_buy where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, BuyListBin, OpTime] ->
            #st_merge_back_buy{
                pkey = Pkey,
                act_id = ActId,
                buy_list = util:bitstring_to_term(BuyListBin),
                op_time = OpTime
            };
        _ ->
            #st_merge_back_buy{pkey = Pkey}
    end.

dbup_merge_act_back_buy(#st_merge_back_buy{pkey = Pkey, act_id = ActId, buy_list = BuyList, op_time = OpTime}) ->
    BuyListBin = util:term_to_bitstring(BuyList),
    Sql = io_lib:format("replace into player_merge_act_back_buy set pkey=~p, act_id=~p, buy_list='~s', op_time=~p",
        [Pkey, ActId, BuyListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_all_merge_back_buy(ActId) ->
    Sql = io_lib:format("select id, total_num from merge_act_back_buy where act_id=~p", [ActId]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            Rows;
        _ ->
            []
    end.

dbup_all_merge_back_buy(#ets_merge_back_buy{act_id = ActId, order_id = Id, total_num = TotalNum}) ->
    Sql = io_lib:format("replace into merge_act_back_buy set act_id=~p, id=~p, total_num=~p", [ActId, Id, TotalNum]),
    db:execute(Sql),
    ok.

dbget_merge_exchange(Pkey) ->
    Sql = io_lib:format("select act_id, exchange_list, op_time from player_merge_exchange where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, ExchangeListBin, OpTime] ->
            ExchangeList = util:bitstring_to_term(ExchangeListBin),
            #st_merge_exchange{
                pkey = Pkey,
                act_id = ActId,
                exchange_list = ExchangeList,
                op_time = OpTime
            };
        _ ->
            #st_merge_exchange{pkey = Pkey}
    end.

dbup_merge_exchange(#st_merge_exchange{pkey = Pkey, act_id = ActId, exchange_list = ExchangeList, op_time = OpTime}) ->
    ExchangeListBin = util:term_to_bitstring(ExchangeList),
    Sql = io_lib:format("replace into player_merge_exchange set pkey=~p, act_id=~p, exchange_list='~s', op_time=~p",
        [Pkey, ActId, ExchangeListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_new_wealth_cat(Pkey) ->
    Sql = io_lib:format("select act_id, id from player_new_wealth_cat where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, Id] ->
            #st_new_wealth_cat{
                pkey = Pkey,
                act_id = ActId,
                id = Id

            };
        _ ->
            #st_new_wealth_cat{pkey = Pkey}
    end.

dbup_new_wealth_cat(#st_new_wealth_cat{pkey = Pkey, act_id = ActId, id = Id}) ->
    Sql = io_lib:format("replace into player_new_wealth_cat set pkey=~p, act_id=~p,  id=~p",
        [Pkey, ActId, Id]),
    db:execute(Sql),
    ok.

dbget_mystery_shop(Pkey) ->
    Sql = io_lib:format("select act_id, shop_info, refresh_time, refresh_num, recv_refresh_reward, buy_num, op_time from player_mystery_shop where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, ShopInfoBin, RefreshTime, RefreshNum, RecvFreshRewardBin, BuyNum, OpTime] ->
            #st_mystery_shop{
                pkey = Pkey,
                act_id = ActId,
                shop_info = util:bitstring_to_term(ShopInfoBin),
                refresh_time = RefreshTime,
                refresh_num = RefreshNum,
                recv_refresh_reward = util:bitstring_to_term(RecvFreshRewardBin),
                op_time = OpTime,
                buy_num = BuyNum
            };
        _ ->
            #st_mystery_shop{pkey = Pkey}
    end.

dbget_lucky_turn(Pkey) ->
    Sql = io_lib:format("select act_id,score,ex_list,draw_time from player_lucky_turn where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, Score, ExList, DrawTime] ->
            #st_luck_turn{
                pkey = Pkey,
                act_id = ActId,
                score = Score,
                ex_list = util:bitstring_to_term(ExList),
                draw_time = DrawTime
            };
        _ ->
            #st_luck_turn{pkey = Pkey}
    end.
dbup_mystery_shop(St) ->
    #st_mystery_shop{
        pkey = Pkey,
        act_id = ActId,
        shop_info = ShopInfo,
        refresh_time = RefreshTime,
        refresh_num = RefreshNum,
        recv_refresh_reward = RecvFreshReward,
        op_time = OpTime,
        buy_num = BuyNum
    } = St,
    ShopInfoBin = util:term_to_bitstring(ShopInfo),
    RecvFreshRewardBin = util:term_to_bitstring(RecvFreshReward),
    Sql = io_lib:format("replace into player_mystery_shop set pkey=~p, buy_num=~p, act_id=~p, shop_info='~s', refresh_time=~p, refresh_num=~p, recv_refresh_reward='~s', op_time=~p",
        [Pkey, BuyNum, ActId, ShopInfoBin, RefreshTime, RefreshNum, RecvFreshRewardBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_limit_time_gift(Pkey) ->
    Sql = io_lib:format("select act_id, buy_list, op_time from player_limit_time_gift where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, BuyListBin, OpTime] ->
            #st_limit_time_gift{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                buy_list = util:bitstring_to_term(BuyListBin)
            };
        _ ->
            #st_limit_time_gift{pkey = Pkey}
    end.
dbup_lucky_turn(#st_luck_turn{pkey = Pkey, act_id = ActId, score = Score, ex_list = ExList, draw_time = DrawTime}) ->
    Sql = io_lib:format("replace into player_lucky_turn set pkey=~p, act_id=~p, score =~p,ex_list = '~s',draw_time = ~p",
        [Pkey, ActId, Score, util:term_to_bitstring(ExList), DrawTime]),
    db:execute(Sql),
    ok.

dbup_limit_time_gift(St) ->
    #st_limit_time_gift{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime,
        buy_list = BuyList
    } = St,
    BuyListBin = util:term_to_bitstring(BuyList),
    Sql = io_lib:format("replace into player_limit_time_gift set pkey=~p, act_id=~p, buy_list='~s',op_time=~p",
        [Pkey, ActId, BuyListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_act_throw_egg(Pkey) ->
    Sql = io_lib:format("select act_id,count,count_list,is_free,re_set_count,egg_info,last_login_time,online_time from player_throw_egg where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, Count, CountList, IsFree, ReSetCount, RggInfo, LastLoginTime, OnlineTime] ->
            #st_act_throw_egg{
                pkey = Pkey,
                act_id = ActId,
                count = Count,
                count_list = util:bitstring_to_term(CountList),
                is_free = IsFree,
                re_set_count = ReSetCount,
                egg_info = util:bitstring_to_term(RggInfo),
                last_login_time = LastLoginTime,
                online_time = OnlineTime
            };
        _ ->
            #st_act_throw_egg{pkey = Pkey, last_login_time = util:unixtime()}
    end.
dbget_act_throw_fruit(Pkey) ->
    Sql = io_lib:format("select act_id,count,count_list,is_free,re_set_count,fruit_info,last_login_time,online_time from player_throw_fruit where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, Count, CountList, IsFree, ReSetCount, RggInfo, LastLoginTime, OnlineTime] ->
            #st_act_throw_fruit{
                pkey = Pkey,
                act_id = ActId,
                count = Count,
                count_list = util:bitstring_to_term(CountList),
                is_free = IsFree,
                re_set_count = ReSetCount,
                fruit_info = util:bitstring_to_term(RggInfo),
                last_login_time = LastLoginTime,
                online_time = OnlineTime
            };
        _ ->
            #st_act_throw_fruit{pkey = Pkey, last_login_time = util:unixtime()}
    end.


dbget_fruit_war(Pkey) ->
    Sql = io_lib:format("select act_id,count,count_list,is_free,re_set_count,egg_info,last_login_time,online_time from player_fruit_war where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, Count, CountList, IsFree, ReSetCount, RggInfo, LastLoginTime, OnlineTime] ->
            #st_act_throw_egg{
                pkey = Pkey,
                act_id = ActId,
                count = Count,
                count_list = util:bitstring_to_term(CountList),
                is_free = IsFree,
                re_set_count = ReSetCount,
                egg_info = util:bitstring_to_term(RggInfo),
                last_login_time = LastLoginTime,
                online_time = OnlineTime
            };
        _ ->
            #st_act_throw_egg{pkey = Pkey, last_login_time = util:unixtime()}
    end.

%% 跨服上的数据
dbget_lucky_turn_cross(ActId) ->
    Sql = io_lib:format("select act_id,gold from cross_lucky_turn where act_id=~p", [ActId]),
    case db:get_row(Sql) of
        [ActId, Gold] ->
            #cross_st_luck_turn{act_id = ActId, gold = Gold};
        _ ->
            #cross_st_luck_turn{}
    end.

dbup_act_throw_egg(St) ->
    #st_act_throw_egg{
        pkey = Pkey,
        act_id = ActId,
        count = Count,
        count_list = CountList,
        is_free = IsFree,
        re_set_count = ReSetCount,
        egg_info = RggInfo,
        last_login_time = LastLoginTime,
        online_time = OnlineTime
    } = St,
    Sql = io_lib:format("replace into player_throw_egg set pkey=~p, act_id=~p,  count=~p,count_list = '~s',is_free = ~p,re_set_count = ~p,egg_info='~s',online_time=~p,last_login_time=~p",
        [Pkey, ActId, Count, util:term_to_bitstring(CountList), IsFree, ReSetCount, util:term_to_bitstring(RggInfo), OnlineTime, LastLoginTime]),
    db:execute(Sql),
    ok.
dbup_act_throw_fruit(St) ->
    #st_act_throw_fruit{
        pkey = Pkey,
        act_id = ActId,
        count = Count,
        count_list = CountList,
        is_free = IsFree,
        re_set_count = ReSetCount,
        fruit_info = RggInfo,
        last_login_time = LastLoginTime,
        online_time = OnlineTime
    } = St,
    Sql = io_lib:format("replace into player_throw_fruit set pkey=~p, act_id=~p,  count=~p,count_list = '~s',is_free = ~p,re_set_count = ~p,fruit_info='~s',online_time=~p,last_login_time=~p",
        [Pkey, ActId, Count, util:term_to_bitstring(CountList), IsFree, ReSetCount, util:term_to_bitstring(RggInfo), OnlineTime, LastLoginTime]),
    db:execute(Sql),
    ok.

dbget_act_welkin_hunt(Pkey) ->
    Sql = io_lib:format("select act_id,score,count,log_list from player_welkin_hunt where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, Score, Count, LogList] ->
            #st_act_welkin_hunt{
                pkey = Pkey,
                act_id = ActId,
                score = Score,
                count = Count,
                log_list = util:bitstring_to_term(LogList)
            };
        _ ->
            #st_act_welkin_hunt{pkey = Pkey}
    end.

dbup_act_welkin_hunt(St) ->
    #st_act_welkin_hunt{
        pkey = Pkey,
        act_id = ActId,
        score = Score,
        log_list = LogList,
        count = Count
    } = St,
    Sql = io_lib:format("replace into player_welkin_hunt set pkey=~p, act_id=~p,  score=~p,count = ~p,log_list = '~s'",
        [Pkey, ActId, Score, Count, util:term_to_bitstring(LogList)]),
    db:execute(Sql),
    ok.

dbget_buy_red_equip(Pkey) ->
    Sql = io_lib:format("select act_id,info_list,re_count from player_buy_red_equip where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, InfoList, ReCount] ->
            #st_buy_red_equip{
                pkey = Pkey,
                act_id = ActId,
                re_count = ReCount,
                info_list = util:bitstring_to_term(InfoList)
            };
        _ ->
            #st_buy_red_equip{pkey = Pkey}
    end.

dbup_buy_red_equip(St) ->
    #st_buy_red_equip{
        pkey = Pkey,
        act_id = ActId,
        re_count = ReCount,
        info_list = InfoList
    } = St,
    Sql = io_lib:format("replace into player_buy_red_equip set pkey=~p, act_id=~p,re_count = ~p, info_list = '~s'",
        [Pkey, ActId, ReCount, util:term_to_bitstring(InfoList)]),
    db:execute(Sql),
    ok.


dbup_lucky_turn_cross(#cross_st_luck_turn{act_id = ActId, gold = Gold}) ->
    Sql = io_lib:format("replace into cross_lucky_turn set act_id=~p, gold =~p", [ActId, Gold]),
    db:execute(Sql),
    ok.


dbget_local_lucky_turn(Pkey) ->
    Sql = io_lib:format("select act_id,score,ex_list,draw_time from player_local_lucky_turn where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, Score, ExList, DrawTime] ->
            #st_luck_turn{
                pkey = Pkey,
                act_id = ActId,
                score = Score,
                ex_list = util:bitstring_to_term(ExList),
                draw_time = DrawTime
            };
        _ ->
            #st_luck_turn{pkey = Pkey}
    end.


dbup_local_lucky_turn(#st_luck_turn{pkey = Pkey, act_id = ActId, score = Score, ex_list = ExList, draw_time = DrawTime}) ->
    Sql = io_lib:format("replace into player_local_lucky_turn set pkey=~p, act_id=~p, score =~p,ex_list = '~s',draw_time = ~p",
        [Pkey, ActId, Score, util:term_to_bitstring(ExList), DrawTime]),
    db:execute(Sql),
    ok.

%% 本服的数据
dbget_lucky_turn_local(ActId) ->
    Sql = io_lib:format("select act_id,gold from local_lucky_turn where act_id=~p", [ActId]),
    case db:get_row(Sql) of
        [ActId, Gold] ->
            #cross_st_luck_turn{act_id = ActId, gold = Gold};
        _ ->
            #cross_st_luck_turn{}
    end.

dbup_lucky_turn_local(#cross_st_luck_turn{act_id = ActId, gold = Gold}) ->
    Sql = io_lib:format("replace into local_lucky_turn set act_id=~p, gold =~p", [ActId, Gold]),
    db:execute(Sql),
    ok.

dbget_small_charge(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, charge_list, buy_num, op_time from player_act_small_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, ChargeListBin, BuyNum, OpTime] ->
            #st_act_small_charge{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = util:bitstring_to_term(RecvListBin),
                charge_list = util:bitstring_to_term(ChargeListBin),
                buy_num = BuyNum
            };
        _ ->
            #st_act_small_charge{pkey = Pkey}
    end.

dbup_small_charge(St) ->
    #st_act_small_charge{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime,
        recv_list = RecvList,
        charge_list = ChargeList,
        buy_num = BuyNum
    } = St,
    RecvListBin = util:term_to_bitstring(RecvList),
    ChargeListBin = util:term_to_bitstring(ChargeList),
    Sql = io_lib:format("replace into player_act_small_charge set pkey=~p, act_id=~p, recv_list='~s', charge_list='~s', buy_num = ~p, op_time=~p",
        [Pkey, ActId, RecvListBin, ChargeListBin, BuyNum, OpTime]),
    db:execute(Sql),
    ok.

dbget_one_gold_buy(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, buy_num, op_time from player_act_one_gold_buy where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, BuyNum, OpTime] ->
            #st_one_gold_buy{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = util:bitstring_to_term(RecvListBin),
                buy_num = BuyNum
            };
        _ ->
            #st_one_gold_buy{pkey = Pkey}
    end.

dbup_one_gold_buy(St) ->
    #st_one_gold_buy{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime,
        recv_list = RecvList,
        buy_num = BuyNum
    } = St,
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_act_one_gold_buy set pkey=~p, act_id=~p, recv_list='~s', buy_num = ~p, op_time=~p",
        [Pkey, ActId, RecvListBin, BuyNum, OpTime]),
    db:execute(Sql),
    ok.

dbget_all_one_gold_buy(Node, ActId) ->
    Sql = io_lib:format("select act_num, act_type, order_id, goods_id, goods_num, total_num, log, buy_list, op_time from one_gold_buy where node='~s' and act_id=~p", [Node, ActId]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            Now = util:unixtime(),
            F = fun([ActNum, ActType, OrderId, GoodsId, GoodsNum, TotalNum, LogBin, BuyListBin, OpTime]) ->
                case util:is_same_date(Now, OpTime) of
                    true ->
                        [#ets_one_gold_goods{
                            key = {ActId, ActType, ActNum, OrderId},
                            act_id = ActId,
                            act_type = ActType,
                            act_num = ActNum,
                            order_id = OrderId,
                            goods_id = GoodsId,
                            goods_num = GoodsNum,
                            total_num = TotalNum,
                            buy_list = util:bitstring_to_term(BuyListBin),
                            log = util:bitstring_to_term(LogBin),
                            op_time = OpTime
                        }];
                    false ->
                        []
                end
                end,
            lists:flatmap(F, Rows);
        _ ->
            []
    end.

dbup_ets_one_gold_buy(Ets) ->
    #ets_one_gold_goods{
        key = {ActId, ActType, ActNum, OrderId},
        act_type = ActType,
        goods_id = GoodsId,
        goods_num = GoodsNum,
        total_num = TotalNum,
        buy_list = BuyList,
        log = LogList,
        op_time = OpTime
    } = Ets,
    LogBin = util:term_to_bitstring(LogList),
    BuyListBin = util:term_to_bitstring(BuyList),
    Sql = io_lib:format("replace into one_gold_buy set act_id=~p, act_num=~p, act_type=~p, order_id=~p, goods_id=~p, goods_num=~p, total_num=~p, log='~s', buy_list='~s', node='~s', op_time=~p",
        [ActId, ActNum, ActType, OrderId, GoodsId, GoodsNum, TotalNum, LogBin, BuyListBin, node(), OpTime]),
    db:execute(Sql),
    ok.

dbget_festival_login_gift(Pkey) ->
    Sql = io_lib:format("select act_id, login_day, charge_gold, recv_list, op_time from player_act_festival_login_gift where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, LoginDay, ChargeGold, RecvListBin, OpTime] ->
            #st_festival_login_gift{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                login_day_num = LoginDay,
                charge_gold = ChargeGold,
                recv_list = util:bitstring_to_term(RecvListBin)
            };
        _ ->
            #st_festival_login_gift{pkey = Pkey}
    end.

dbup_festival_login_gift(St) ->
    #st_festival_login_gift{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime,
        login_day_num = LoginDay,
        charge_gold = ChargeGold,
        recv_list = RecvList
    } = St,
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_act_festival_login_gift set pkey=~p, act_id=~p, recv_list='~s', charge_gold = ~p, login_day=~p, op_time=~p",
        [Pkey, ActId, RecvListBin, ChargeGold, LoginDay, OpTime]),
    db:execute(Sql),
    ok.


dbget_festival_act_acc_charge(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, acc_charge_gold, op_time from player_act_festival_acc_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, AccChargeGold, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_festival_act_acc_charge{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList,
                acc_charge_gold = AccChargeGold
            };
        _ ->
            #st_festival_act_acc_charge{pkey = Pkey}
    end.

dbup_festival_act_acc_charge(#st_festival_act_acc_charge{pkey = Pkey, act_id = ActId, recv_list = RecvList, acc_charge_gold = AccChargeGold, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_act_festival_acc_charge set pkey=~p, act_id=~p, recv_list='~s', acc_charge_gold=~p, op_time=~p",
        [Pkey, ActId, RecvListBin, AccChargeGold, OpTime]),
    db:execute(Sql),
    ok.

dbget_festival_act_back_buy(Pkey) ->
    Sql = io_lib:format("select open_day, buy_list, op_time from player_act_festival_back_buy where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [OpenDay, BuyListBin, OpTime] ->
            #st_festival_back_buy{
                pkey = Pkey,
                open_day = OpenDay,
                buy_list = util:bitstring_to_term(BuyListBin),
                op_time = OpTime
            };
        _ ->
            #st_festival_back_buy{pkey = Pkey}
    end.

dbup_festival_act_back_buy(#st_festival_back_buy{pkey = Pkey, open_day = OpenDay, buy_list = BuyList, op_time = OpTime}) ->
    BuyListBin = util:term_to_bitstring(BuyList),
    Sql = io_lib:format("replace into player_act_festival_back_buy set pkey=~p, open_day=~p, buy_list='~s', op_time=~p",
        [Pkey, OpenDay, BuyListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_all_festival_back_buy(OpenDay) ->
    Sql = io_lib:format("select id, total_num from festival_back_buy where open_day=~p", [OpenDay]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            Rows;
        _ ->
            []
    end.

dbup_all_festival_back_buy(#ets_festival_back_buy{open_day = OpenDay, order_id = Id, total_num = TotalNum}) ->
    Sql = io_lib:format("replace into festival_back_buy set open_day=~p, id=~p, total_num=~p", [OpenDay, Id, TotalNum]),
    db:execute(Sql),
    ok.

dbget_festival_exchange(Pkey) ->
    Sql = io_lib:format("select act_id, exchange_list, op_time from player_festival_exchange where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, ExchangeListBin, OpTime] ->
            ExchangeList = util:bitstring_to_term(ExchangeListBin),
            #st_festival_exchange{
                pkey = Pkey,
                act_id = ActId,
                exchange_list = ExchangeList,
                op_time = OpTime
            };
        _ ->
            #st_festival_exchange{pkey = Pkey}
    end.

dbup_festival_exchange(#st_festival_exchange{pkey = Pkey, act_id = ActId, exchange_list = ExchangeList, op_time = OpTime}) ->
    ExchangeListBin = util:term_to_bitstring(ExchangeList),
    Sql = io_lib:format("replace into player_festival_exchange set pkey=~p, act_id=~p, exchange_list='~s', op_time=~p",
        [Pkey, ActId, ExchangeListBin, OpTime]),
    db:execute(Sql),
    ok.


dbget_return_exchange(Pkey) ->
    Sql = io_lib:format("select act_id, exchange_list, op_time from player_return_exchange where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, ExchangeListBin, OpTime] ->
            ExchangeList = util:bitstring_to_term(ExchangeListBin),
            #st_return_exchange{
                pkey = Pkey,
                act_id = ActId,
                exchange_list = ExchangeList,
                op_time = OpTime
            };
        _ ->
            #st_return_exchange{pkey = Pkey}
    end.

dbup_return_exchange(#st_return_exchange{pkey = Pkey, act_id = ActId, exchange_list = ExchangeList, op_time = OpTime}) ->
    ExchangeListBin = util:term_to_bitstring(ExchangeList),
    Sql = io_lib:format("replace into player_return_exchange set pkey=~p, act_id=~p, exchange_list='~s', op_time=~p",
        [Pkey, ActId, ExchangeListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_festival_red_gift(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, op_time from player_festival_red_gift where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_festival_red_gift{
                pkey = Pkey,
                act_id = ActId,
                recv_list = RecvList,
                op_time = OpTime
            };
        _ ->
            #st_festival_red_gift{pkey = Pkey}
    end.

dbup_festival_red_gift(#st_festival_red_gift{pkey = Pkey, act_id = ActId, recv_list = RecvList, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_festival_red_gift set pkey=~p, act_id=~p, recv_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_act_charge(Pkey) ->
    Sql = io_lib:format("select charge_list, op_time from player_act_charge where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ChargeListBin, OpTime] ->
            ChargeList = util:bitstring_to_term(ChargeListBin),
            #st_act_charge{
                pkey = Pkey,
                charge_list = ChargeList,
                op_time = OpTime
            };
        _ ->
            #st_act_charge{pkey = Pkey}
    end.

dbup_act_charge(#st_act_charge{pkey = Pkey, charge_list = ChargeList, op_time = OpTime}) ->
    ChargeListBin = util:term_to_bitstring(ChargeList),
    Sql = io_lib:format("replace into player_act_charge set pkey=~p, charge_list='~s', op_time=~p",
        [Pkey, ChargeListBin, OpTime]),
    db:execute(Sql),
    ok.


%% 等级返利
dbget_act_lv_back(Pkey, ActId) ->
    Sql = io_lib:format("select buy_id,get_award_id from act_lv_back where pkey=~p and act_id = ~p limit 1", [Pkey, ActId]),
    case db:get_row(Sql) of
        [BuyId, Get_award_id] ->
            GetIDList = util:bitstring_to_term(Get_award_id),
            #st_lv_back{
                pkey = Pkey,
                act_id = ActId,
                buy_id = BuyId,
                get_award_id = GetIDList
            };
        _ ->
            #st_lv_back{pkey = Pkey, act_id = ActId}
    end.

dbup_act_lv_back(#st_lv_back{pkey = Pkey, act_id = ActId, buy_id = BuyId, get_award_id = GetIDList}) ->
    GetIDList2 = util:term_to_bitstring(GetIDList),
    Sql = io_lib:format("replace into act_lv_back set pkey=~p, act_id = ~p,buy_id=~p, get_award_id='~s'",
        [Pkey, ActId, BuyId, GetIDList2]),
    db:execute(Sql),
    ok.


dbget_act_mystery_tree(Pkey, ActId) ->
    Sql = io_lib:format("select score,count,log_list from player_mystery_tree where pkey=~p and act_id = ~p limit 1", [Pkey, ActId]),
    case db:get_row(Sql) of
        [Score, Count, LogList] ->
            #st_act_mystery_tree{
                pkey = Pkey,
                act_id = ActId,
                score = Score,
                count = Count,
                log_list = util:bitstring_to_term(LogList)
            };
        _ ->
            #st_act_mystery_tree{pkey = Pkey, act_id = ActId}
    end.

dbup_act_mystery_tree(St) ->
    #st_act_mystery_tree{
        pkey = Pkey,
        act_id = ActId,
        score = Score,
        log_list = LogList,
        count = Count
    } = St,
    Sql = io_lib:format("replace into player_mystery_tree set pkey=~p, act_id=~p,  score=~p,count = ~p,log_list = '~s'",
        [Pkey, ActId, Score, Count, util:term_to_bitstring(LogList)]),
    db:execute(Sql),
    ok.

dbget_cs_charge_d(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, charge_list, op_time from player_cs_charge_d where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, ChargeListBin, OpTime] ->
            #st_cs_charge_d{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = util:bitstring_to_term(RecvListBin),
                charge_list = util:bitstring_to_term(ChargeListBin)
            };
        _ ->
            #st_cs_charge_d{pkey = Pkey}
    end.

dbup_cs_charge_d(St) ->
    #st_cs_charge_d{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime,
        recv_list = RecvList,
        charge_list = ChargeList
    } = St,
    RecvListBin = util:term_to_bitstring(RecvList),
    ChargeListBin = util:term_to_bitstring(ChargeList),
    Sql = io_lib:format("replace into player_cs_charge_d set pkey=~p, act_id=~p, recv_list='~s', charge_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, ChargeListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_small_charge_d(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, charge_list, op_time from player_small_charge_d where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, ChargeListBin, OpTime] ->
            #st_small_charge_d{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = util:bitstring_to_term(RecvListBin),
                charge_list = util:bitstring_to_term(ChargeListBin)
            };
        _ ->
            #st_small_charge_d{pkey = Pkey}
    end.

dbup_small_charge_d(St) ->
    #st_small_charge_d{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime,
        recv_list = RecvList,
        charge_list = ChargeList
    } = St,
    RecvListBin = util:term_to_bitstring(RecvList),
    ChargeListBin = util:term_to_bitstring(ChargeList),
    Sql = io_lib:format("replace into player_small_charge_d set pkey=~p, act_id=~p, recv_list='~s', charge_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, ChargeListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_act_jbp(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, charge_list, op_time from player_act_jbp where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, ChargeListBin, OpTime] ->
            #st_act_jbp{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = util:bitstring_to_term(RecvListBin),
                charge_list = util:bitstring_to_term(ChargeListBin)
            };
        _ ->
            #st_act_jbp{pkey = Pkey}
    end.

dbup_act_jbp(St) ->
    #st_act_jbp{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime,
        recv_list = RecvList,
        charge_list = ChargeList
    } = St,
    RecvListBin = util:term_to_bitstring(RecvList),
    ChargeListBin = util:term_to_bitstring(ChargeList),
    Sql = io_lib:format("replace into player_act_jbp set pkey=~p, act_id=~p, recv_list='~s', charge_list='~s', op_time=~p",
        [Pkey, ActId, RecvListBin, ChargeListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_limit_xian(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, score, op_time from player_act_limit_xian where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, Score, OpTime] ->
            #st_act_limit_xian{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                score = Score,
                recv_list = util:bitstring_to_term(RecvListBin)
            };
        _ ->
            #st_act_limit_xian{pkey = Pkey}
    end.

dbup_limit_xian(St) ->
    #st_act_limit_xian{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime,
        recv_list = RecvList,
        score = Score
    } = St,
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_act_limit_xian set pkey=~p, act_id=~p, recv_list='~s', score=~p, op_time=~p",
        [Pkey, ActId, RecvListBin, Score, OpTime]),
    db:execute(Sql),
    ok.


dbget_limit_pet(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, score, op_time from player_act_limit_pet where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, Score, OpTime] ->
            #st_act_limit_pet{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                score = Score,
                recv_list = util:bitstring_to_term(RecvListBin)
            };
        _ ->
            #st_act_limit_pet{pkey = Pkey}
    end.

dbup_limit_pet(St) ->
    #st_act_limit_pet{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime,
        recv_list = RecvList,
        score = Score
    } = St,
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_act_limit_pet set pkey=~p, act_id=~p, recv_list='~s', score=~p, op_time=~p",
        [Pkey, ActId, RecvListBin, Score, OpTime]),
    db:execute(Sql),
    ok.

dbget_act_exp_dungeon(Pkey) ->
    Sql = io_lib:format("select get_list,op_time,is_buy from player_act_exp_dungeon where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [GetList, OpTime, IsBuy] ->
            #st_act_exp_dungeon{
                pkey = Pkey
                , get_list = util:bitstring_to_term(GetList)
                , is_buy = IsBuy
                , op_time = OpTime
            };
        _ ->
            #st_act_exp_dungeon{pkey = Pkey}
    end.

dbup_act_exp_dungeon(#st_act_exp_dungeon{pkey = Pkey, get_list = GetList, is_buy = IsBuy, op_time = OpTime}) ->
    Sql = io_lib:format("replace into player_act_exp_dungeon set pkey=~p, get_list='~s',  is_buy=~p, op_time=~p",
        [Pkey, util:term_to_bitstring(GetList), IsBuy, OpTime]),
    db:execute(Sql),
    ok.


dbget_godness_limit_time_gift(Pkey) ->
    Sql = io_lib:format("select act_id, buy_list, op_time from player_godness_limit where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, BuyListBin, OpTime] ->
            #st_godness_limit{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                buy_list = util:bitstring_to_term(BuyListBin)
            };
        _ ->
            #st_godness_limit{pkey = Pkey}
    end.


dbup_godness_limit_time_gift(St) ->
    #st_godness_limit{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime,
        buy_list = BuyList
    } = St,
    BuyListBin = util:term_to_bitstring(BuyList),
    Sql = io_lib:format("replace into player_godness_limit set pkey=~p, act_id=~p, buy_list='~s',op_time=~p",
        [Pkey, ActId, BuyListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_call_godness(Pkey) ->
    Sql = io_lib:format("select act_id, get_list, op_time,value,count,free_count from player_call_godness where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, GetListBin, OpTime, Value, Count, FreeCount] ->
            #st_call_godnesst{
                pkey = Pkey,
                act_id = ActId,
                value = Value,
                op_time = OpTime,
                count = Count,
                free_count = FreeCount,
                get_list = util:bitstring_to_term(GetListBin)
            };
        _ ->
            #st_call_godnesst{pkey = Pkey}
    end.

dbup_call_godness(St) ->
    #st_call_godnesst{
        pkey = Pkey,
        act_id = ActId,
        value = Value,
        count = Count,
        free_count = FreeCount,
        get_list = List
    } = St,
    ListBin = util:term_to_bitstring(List),
    Sql = io_lib:format("replace into player_call_godness set pkey=~p, act_id=~p, get_list='~s',op_time=~p,value = ~p,count = ~p,free_count=~p",
        [Pkey, ActId, ListBin, util:unixtime(), Value, Count, FreeCount]),
    db:execute(Sql),
    ok.

dbget_wishing_well(Pkey, NickName) ->
    Sql = io_lib:format("select act_id,count_list,score,charge_val,charge_count,op_time from player_wishing_well where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, CountListBin, Score, ChargeVal, ChargeCount, OpTime] ->
            #st_act_wishing_well{
                pkey = Pkey
                , nickname = NickName
                , act_id = ActId
                , count_list = util:bitstring_to_term(CountListBin)
                , score = Score
                , op_time = OpTime
                , charge_val = ChargeVal
                , charge_count = ChargeCount
            };
        _ ->
            #st_act_wishing_well{pkey = Pkey, nickname = NickName}
    end.


dbup_wishing_well(St) ->
    #st_act_wishing_well{
        pkey = Pkey
        , act_id = ActId
        , nickname = NickName
        , charge_val = ChargeVal
        , charge_count = ChargeCount
        , count_list = CountList
        , score = Score
%%         , op_time = OpTime
    } = St,
    CountListBin = util:term_to_bitstring(CountList),
    NickNameBin = util:term_to_bitstring(NickName),
    Sql = io_lib:format("replace into player_wishing_well set pkey=~p, act_id=~p,charge_val=~p,charge_count=~p,count_list='~s',nickname='~s',score=~p,op_time=~p",
        [Pkey, ActId, ChargeVal, ChargeCount, CountListBin, NickNameBin, Score, util:unixtime()]),
    db:execute(Sql),
    ok.

dbget_cross_wishing_well(Pkey, NickName) ->
    Sql = io_lib:format("select act_id,count_list,score,charge_val,charge_count,op_time from player_cross_wishing_well where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, CountListBin, Score, ChargeVal, ChargeCount, OpTime] ->
            #st_cross_act_wishing_well{
                pkey = Pkey
                , nickname = NickName
                , act_id = ActId
                , count_list = util:bitstring_to_term(CountListBin)
                , score = Score
                , op_time = OpTime
                , charge_val = ChargeVal
                , charge_count = ChargeCount
            };
        _ ->
            #st_cross_act_wishing_well{pkey = Pkey, nickname = NickName}
    end.

dbup_cross_wishing_well(St) ->
    #st_cross_act_wishing_well{
        pkey = Pkey
        , act_id = ActId
        , nickname = NickName
        , charge_val = ChargeVal
        , charge_count = ChargeCount
        , count_list = CountList
        , score = Score
    } = St,
    CountListBin = util:term_to_bitstring(CountList),
    NickNameBin = util:term_to_bitstring(NickName),
    Sql = io_lib:format("replace into player_cross_wishing_well set pkey=~p, act_id=~p,charge_val=~p,charge_count=~p,count_list='~s',nickname='~s',score=~p,op_time=~p",
        [Pkey, ActId, ChargeVal, ChargeCount, CountListBin, NickNameBin, Score, util:unixtime()]),
    db:execute(Sql),
    ok.




dbget_cross_1vn_shop() ->
    Sql = io_lib:format("select shop,shop_base,shop_round,op_time from cross_1vn_shop where sn=~p", [config:get_server_num()]),
    case db:get_row(Sql) of
        [Shop, Base, Round, _OpTime] ->
            {
                Round,
                util:bitstring_to_term(Shop),
                util:bitstring_to_term(Base)
            };
        _ ->
            {NewBase, NewRound} = cross_1vn:reset_shop_base(0),
            {NewRound, [], NewBase}
    end.

dbup_cross_1vn_shop(Round, Base, Shop) ->
    BaseBin = util:term_to_bitstring(Base),
    ShopBin = util:term_to_bitstring(Shop),
    Sql = io_lib:format("replace into cross_1vn_shop set sn=~p,shop='~s',shop_base='~s',shop_round=~p,op_time=~p",
        [config:get_server_num(), ShopBin, BaseBin, Round, util:unixtime()]),
    db:execute(Sql),
    ok.



dbget_player_invite_code(Pkey, NickName) ->
    Sql = io_lib:format("select invite_code,be_invited,get_list,invite_num,key_list,use_invited_code,use_invited_key,nickname from player_invite_code where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [InviteCode, BeInvited, GetList, InviteNum, KeyList, UseInvitedCode, UseInvitedKey, NickName0] ->
            #st_act_invitation{
                pkey = Pkey,
                invite_num = InviteNum,
                nickname = NickName0,
                invite_code = util:bitstring_to_term(InviteCode),
                get_list = util:bitstring_to_term(GetList),
                be_invited = BeInvited,
                key_list = util:bitstring_to_term(KeyList),
                use_invited_code = util:bitstring_to_term(UseInvitedCode),
                use_invited_key = UseInvitedKey
            };
        _ ->

            NewInviteCode = act_invitation:get_new_invite_code(Pkey),
            St = #st_act_invitation{
                pkey = Pkey,
                nickname = NickName,
                invite_code = NewInviteCode},
            dbup_player_invite_code(St),
            St
    end.

dbup_player_invite_code(St) ->
    #st_act_invitation{
        pkey = Pkey,
        invite_num = InviteNum,
        invite_code = InviteCode,
        get_list = GetList,
        be_invited = BeInvited,
        key_list = KeyList,
        nickname = Nickname,
        use_invited_code = UseInvitedCode,
        use_invited_key = UseInvitedKey
    } = St,
    Sql = io_lib:format("replace into player_invite_code set pkey =~p,invite_code='~s',get_list='~s',be_invited=~p,invite_num=~p,key_list = '~s',use_invited_code='~s',use_invited_key=~p,nickname='~s'",
        [Pkey, util:term_to_string(InviteCode), util:term_to_bitstring(GetList), BeInvited, InviteNum, util:term_to_bitstring(KeyList), util:term_to_string(UseInvitedCode), UseInvitedKey, Nickname]),
    db:execute(Sql).



dbget_player_act_collection_hero(AccName) ->
    Sql = io_lib:format("select state0 from player_act_collection_hero where accname='~s'", [AccName]),
    case db:get_row(Sql) of
        [State0] ->
            State0;
        _ ->
            0
    end.

dbup_player_act_collection_hero(AccName) ->
    Sql = io_lib:format("replace into player_act_collection_hero set accname ='~s',state0=~p",
        [AccName, 1]),
    db:execute(Sql).


dbget_player_act_cbp_rank(#player{key = Pkey, nickname = Nickname0}) ->
    Sql = io_lib:format("select act_id,nickname,vip,get_list,start_cbp,high_cbp from player_act_cbp_rank where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, _Nickname, Vip, GetList, StartCbp, HighCbp] ->
            #st_act_cbp_rank{
                pkey = Pkey,
                act_id = ActId,
                nickname = Nickname0,
                vip = Vip,
                get_list = util:bitstring_to_term(GetList),
                start_cbp = StartCbp,
                high_cbp = HighCbp
            };
        O ->
            ?DEBUG("o ~p~n", [O]),
            #st_act_cbp_rank{
                pkey = Pkey,
                nickname = Nickname0
            }
    end.

dbup_player_act_cbp_rank(St) ->
    #st_act_cbp_rank{
        pkey = Pkey,
        act_id = ActId,
        nickname = NickName,
        vip = Vip,
        get_list = GetList,
        start_cbp = StartCbp,
        high_cbp = HighCbp
    } = St,
    Sql = io_lib:format("replace into player_act_cbp_rank set pkey =~p,act_id=~p,nickname='~s',vip=~p,get_list='~s',start_cbp=~p,high_cbp=~p",
        [Pkey, ActId, NickName, Vip, util:term_to_bitstring(GetList), StartCbp, HighCbp]),
    db:execute(Sql).



dbup_act_cbp_rank(Ets, Sn) ->
    #ets_act_cbp_rank{
        pkey = Pkey,
        act_id = ActId,
        nickname = Nickname,
        vip = Vip,
        cbp_change = CbpChange
    } = Ets,
    Sql = io_lib:format("replace into act_cbp_rank set pkey =~p,act_id=~p,nickname='~s',vip=~p,cbp_change=~p,sn = ~p",
        [Pkey, ActId, Nickname, Vip, CbpChange, Sn]),
    db:execute(Sql).

dbget_player_act_meet_limit(Pkey) ->
    Sql = io_lib:format("select child_list,act_id,get_list from player_act_meet_limit where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ChildList, ActId, GetList] ->
            #st_act_meet_limit{
                pkey = Pkey,
                act_id = ActId,
                get_list = util:bitstring_to_term(GetList),
                child_list = act_meet_limit:lists_to_record(util:bitstring_to_term(ChildList))
            };
        _ ->
            #st_act_meet_limit{
                pkey = Pkey
            }
    end.

dbup_player_act_meet_limit(St) ->
    ?DEBUG("11 time ~p~n", [util:unixtime()]),
    #st_act_meet_limit{
        pkey = Pkey,
        get_list = GetList,
        act_id = ActId,
        child_list = ChildList
    } = St,
    ChildList1 = act_meet_limit:record_to_lists(ChildList),
    Sql = io_lib:format("replace into player_act_meet_limit set pkey =~p,act_id=~p,child_list='~s',get_list='~s'",
        [Pkey, ActId, util:term_to_bitstring(ChildList1), util:term_to_bitstring(util:list_filter_repeat(GetList))]),
    db:execute(Sql).



dbget_act_consume_rebate(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, acc_consume, op_time from player_act_consume_rebate where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, AccConsume, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_act_consume_rebate{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList,
                acc_consume = AccConsume
            };
        _ ->
            #st_act_consume_rebate{pkey = Pkey}
    end.

dbup_act_consume_rebate(#st_act_consume_rebate{pkey = Pkey, act_id = ActId, recv_list = RecvList, acc_consume = AccConsume, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_act_consume_rebate set pkey=~p, act_id=~p, recv_list='~s', acc_consume=~p, op_time=~p",
        [Pkey, ActId, RecvListBin, AccConsume, OpTime]),
    db:execute(Sql),
    ok.



dbget_merge_act_acc_consume(Pkey) ->
    Sql = io_lib:format("select act_id, recv_list, acc_consume, op_time from player_merge_act_acc_consume where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ActId, RecvListBin, AccConsume, OpTime] ->
            RecvList = util:bitstring_to_term(RecvListBin),
            #st_merge_act_acc_consume{
                pkey = Pkey,
                act_id = ActId,
                op_time = OpTime,
                recv_list = RecvList,
                acc_consume = AccConsume
            };
        _ ->
            #st_merge_act_acc_consume{pkey = Pkey}
    end.

dbup_merge_act_acc_consume(#st_merge_act_acc_consume{pkey = Pkey, act_id = ActId, recv_list = RecvList, acc_consume = AccConsume, op_time = OpTime}) ->
    RecvListBin = util:term_to_bitstring(RecvList),
    Sql = io_lib:format("replace into player_merge_act_acc_consume set pkey=~p, act_id=~p, recv_list='~s', acc_consume=~p, op_time=~p",
        [Pkey, ActId, RecvListBin, AccConsume, OpTime]),
    db:execute(Sql),
    ok.