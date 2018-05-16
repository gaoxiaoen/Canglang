%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 下午1:57
%%%-------------------------------------------------------------------
-module(vip_load).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("vip.hrl").

%% API
-export([
    dbget_player_vip/1,
    dbup_vip_info/1
]).

dbget_player_vip(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_vip{
        pkey = Pkey,
        charge_val = 0,
        other_val = 0,
        buy_list = [],
        free_lv = 0,
        free_time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select charge_val,other_val,buy_list,free_lv,free_time,week_num,week_get_time from player_vip where pkey=~p",[Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [ChargeVal,OtherVal,BuyListBin,FreeLv,FreeTime,WeekNum,WeekGetTime] ->
                    #st_vip{
                        pkey = Pkey,
                        charge_val = ChargeVal,
                        other_val = OtherVal,
                        sum_val = ChargeVal+OtherVal,
                        buy_list = util:bitstring_to_term(BuyListBin),
                        free_lv = FreeLv,
                        free_time = FreeTime,
                        week_num = WeekNum,
                        week_get_time = WeekGetTime
                    }
            end
    end.

dbup_vip_info(VipSt) ->
    #st_vip{
        pkey = Pkey,
        charge_val = CVal,
        other_val = OVal,
        buy_list = BuyList,
        free_lv = FreeLv,
        free_time = FreeTime,
        week_num = WeekNum,
        week_get_time = WeekGetTime
    } = VipSt,
    Sql = io_lib:format("replace into player_vip set charge_val=~p,other_val=~p,buy_list='~s',free_lv=~p,free_time=~p,week_num=~p,week_get_time=~p, pkey=~p",
        [CVal,OVal,util:term_to_bitstring(BuyList),FreeLv,FreeTime,WeekNum,WeekGetTime,Pkey]),
    db:execute(Sql),
    ok.