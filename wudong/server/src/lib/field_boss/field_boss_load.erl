%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 十一月 2017 11:38
%%%-------------------------------------------------------------------
-module(field_boss_load).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("field_boss.hrl").

%% API
-export([
    load_all/0,
    update/1,
    load_all_buy/0,
    update_buy/1
]).

load_all() ->
    {StTime, _EndTime} = util:get_week_time(),
    Sql = io_lib:format("select pkey, sn, name, lv, cbp, point_list, update_time from player_field_point where update_time>~p", [StTime]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Pkey, Sn, Name, Lv, Cbp, PointListBin, UpdateTime]) ->
                #f_point{
                    pkey = Pkey,
                    sn = Sn,
                    name = Name,
                    lv = Lv,
                    cbp = Cbp,
                    point_list = util:bitstring_to_term(PointListBin),
                    update_time = UpdateTime
                }
            end,
            lists:map(F, Rows)
    end.

update(F_point) ->
    #f_point{
        pkey = Pkey,
        sn = Sn,
        name = Name,
        lv = Lv,
        cbp = Cbp,
        point_list = PointList,
        update_time = UpdateTime
    } = F_point,
    PointListBin = util:term_to_bitstring(PointList),
    Sql = io_lib:format("replace into player_field_point set pkey=~p, sn=~p, name='~s', lv=~p, cbp=~p, point_list='~s',update_time=~p",
        [Pkey, Sn, Name, Lv, Cbp, PointListBin, UpdateTime]),
    db:execute(Sql),
    ok.

load_all_buy() ->
    Sql = io_lib:format("select pkey,buy_num,op_time from player_field_boss_buy", []),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            Now = util:unixtime(),
            F = fun([Pkey, BuyNum, OpTime]) ->
                case util:is_same_date(Now, OpTime) of
                    true ->
                        #ets_field_boss_buy{pkey = Pkey, buy_num = BuyNum, op_time = OpTime};
                    false ->
                        #ets_field_boss_buy{pkey = Pkey}
                end
            end,
            lists:map(F, Rows);
        _ -> []
    end.

update_buy(Ets) ->
    #ets_field_boss_buy{pkey = Pkey, op_time = OpTime, buy_num = BuyNum} = Ets,
    Sql = io_lib:format("replace into player_field_boss_buy set pkey=~p,buy_num=~p,op_time=~p",
        [Pkey, BuyNum, OpTime]),
    db:execute(Sql),
    ok.