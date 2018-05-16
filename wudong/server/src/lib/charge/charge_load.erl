%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 下午5:22
%%%-------------------------------------------------------------------
-module(charge_load).
-author("fengzhenlin").
-include("server.hrl").
-include("charge.hrl").

%% API
-export([
    dbget_charge_info/1,
    dbup_charge_info/1,
    get_charge_return/2,
    dbup_chage_return/3
]).

dbget_charge_info(Player) ->
    #player{
        key = Pkey,
        pf = Pf
    } = Player,
    NewSt = #st_charge{
        pkey = Pkey,
        pf = Pf,
        dict = dict:new(),
        return_time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select total_fee,total_gold,charge_list,return_time from player_recharge where pkey=~p", [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [TotalFee, TotalGold, ChargeListBin, ReturnTime] ->
                    ChargeList = util:bitstring_to_term(ChargeListBin),
                    F = fun({Id, Times, LastTime}, AccDict) ->
                        C = #charge{
                            id = Id, times = Times, last_time = LastTime
                        },
                        dict:store(Id, C, AccDict)
                        end,
                    Dict = lists:foldl(F, dict:new(), ChargeList),
                    #st_charge{
                        pkey = Pkey,
                        pf = Pf,
                        total_fee = TotalFee,
                        total_gold = TotalGold,
                        dict = Dict,
                        return_time = ReturnTime
                    }
            end
    end.

dbup_charge_info(ChargeSt) ->
    #st_charge{
        pkey = Pkey,
        total_fee = TotalFee,
        total_gold = TotalGold,
        dict = Dict,
        return_time = ReturnTime
    } = ChargeSt,
    F = fun({_Key, Val}) ->
        #charge{
            id = Id,
            times = Times,
            last_time = LastTime
        } = Val,
        {Id, Times, LastTime}
        end,
    List = lists:map(F, dict:to_list(Dict)),
    Sql = io_lib:format("replace into player_recharge set total_fee=~p,total_gold=~p,charge_list='~s',return_time=~p, pkey=~p",
        [TotalFee, TotalGold, util:term_to_bitstring(List), ReturnTime, Pkey]),
    db:execute(Sql),
    ok.


get_charge_return(Accname, Pf) ->
    Sql = io_lib:format("select total_fee,state from player_charge_return where accname='~s' and pf=~p", [Accname, Pf]),
    db:get_row(Sql).

dbup_chage_return(Accname, Pf, Now) ->
    Sql = io_lib:format("update player_charge_return set state = 1,time=~p where accname='~s' and pf=~p ", [Now, Accname, Pf]),
    db:execute(Sql).