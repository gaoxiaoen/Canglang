%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 七月 2016 下午3:08
%%%-------------------------------------------------------------------
-module(marry_load).
-author("fengzhenlin").
-include("server.hrl").
-include("marry.hrl").

%% API
-compile(export_all).

get_all() ->
    Sql = "select mkey,`type`,key_boy,key_girl,time,cruise,heart_lv,ring_lv,cruise_num from marry",
    db:get_all(Sql).


update_marry_key(Pkey, Mkey) ->
    Sql = io_lib:format("update player_state set mkey=~p where pkey=~p", [Mkey, Pkey]),
    db:execute(Sql).

replace_marry(StMarry) ->
    Sql = io_lib:format("replace into marry set mkey=~p,`type`=~p,key_boy=~p,key_girl=~p,time=~p,cruise=~p,heart_lv='~s',ring_lv='~s',cruise_num=~p",
        [StMarry#st_marry.mkey, StMarry#st_marry.type, StMarry#st_marry.key_boy, StMarry#st_marry.key_girl, StMarry#st_marry.time, StMarry#st_marry.cruise, util:term_to_bitstring(StMarry#st_marry.heart_lv), util:term_to_bitstring(StMarry#st_marry.ring_lv), StMarry#st_marry.cruise_num]),
    db:execute(Sql),
    ok.

del_marry(Mkey) ->
    Sql = io_lib:format("delete from marry where mkey=~p", [Mkey]),
    db:execute(Sql),
    ok.


load_cruise_all() ->
    Sql = "select akey,date,time,mkey from marry_cruise",
    db:get_all(Sql).

replace_cruise(StCruise) ->
    Sql = io_lib:format("replace into marry_cruise set akey=~p,date=~p,time=~p,mkey=~p",
        [StCruise#st_cruise.akey, StCruise#st_cruise.date, StCruise#st_cruise.time, StCruise#st_cruise.mkey]),
    db:execute(Sql).

del_cruise(Date) ->
    Sql = io_lib:format("delete from marry_cruise where date < ~p", [Date]),
    db:execute(Sql).

del_cruise_by_key(Akey) ->
    Sql = io_lib:format("delete from marry_cruise where akey = ~p", [Akey]),
    db:execute(Sql).



load_player_ring(Pkey) ->
    Sql = io_lib:format("select stage,exp,type from player_ring where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_player_ring(St) ->
    Sql = io_lib:format("replace into player_ring set pkey=~p,stage=~p,exp=~p,type = ~p",
        [St#st_ring.pkey, St#st_ring.stage, St#st_ring.exp, St#st_ring.type]),
    db:execute(Sql).

dbget_marry_gift_out_time(Pkey) ->
    Sql = io_lib:format("select buy_out_time from player_marry_gift where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [BuyOutTime] when is_integer(BuyOutTime) ->
            BuyOutTime;
        _ ->
            0
    end.

dbget_marry_gift(Pkey) ->
    Sql = io_lib:format("select buy_type,recv_first,daily_recv,op_time,buy_out_time,is_buy from player_marry_gift where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [BuyType, RecvFirst, DailyRecv, OpTime, BuyOutTime, IsBuy] ->
            #st_marry_gift{
                pkey = Pkey,
                buy_type = BuyType,
                recv_first = RecvFirst,
                daily_recv = DailyRecv,
                op_time = OpTime,
                buy_out_time = BuyOutTime,
                is_buy = IsBuy
            };
        _ ->
            #st_marry_gift{pkey = Pkey}
    end.

dbup_marry_gift(StMarryGift) ->
    #st_marry_gift{
        pkey = Pkey,
        buy_type = BuyType,
        recv_first = RecvFirst,
        daily_recv = DailyRecv,
        op_time = OpTime,
        buy_out_time = BuyOutTime,
        is_buy = IsBuy
    } = StMarryGift,
    Sql = io_lib:format("replace into player_marry_gift set pkey=~p, buy_type=~p, recv_first=~p, daily_recv=~p, op_time=~p, buy_out_time=~p, is_buy=~p",
        [Pkey, BuyType, RecvFirst, DailyRecv, OpTime, BuyOutTime, IsBuy]),
    db:execute(Sql).

dbdelete_marry_gift(Pkey) ->
    Sql = io_lib:format("delete from player_marry_gift where pkey=~p", [Pkey]),
    db:execute(Sql).

dbget_marry_tree(Pkey) ->
    Sql = io_lib:format("select lv,exp,cbp,tree_reward_list from player_marry_tree where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [Lv, Exp, Cbp, ListBin] ->
            #st_marry_tree{
                pkey = Pkey,
                lv = Lv,
                exp = Exp,
                cbp = Cbp,
                tree_reward_list = util:bitstring_to_term(ListBin)
            };
        _ ->
            #st_marry_tree{pkey = Pkey}
    end.

dbup_marry_tree(StMarryGift) ->
    #st_marry_tree{
        pkey = Pkey,
        lv = Lv,
        exp = Exp,
        cbp = Cbp,
        tree_reward_list = List
    } = StMarryGift,
    Sql = io_lib:format("replace into player_marry_tree set pkey=~p, lv=~p, exp=~p, cbp=~p, tree_reward_list='~s'",
        [Pkey, Lv, Exp, Cbp, util:term_to_bitstring(List)]),
    db:execute(Sql).


log_marry(Type, Pkey1, Nickname1, Pkey2, Nickname2, MarryType) ->
    Sql = io_lib:format("insert into log_marry set `type`=~p, pkey1=~p,nickname1='~s',pkey2=~p,nickname2='~s',marry_type=~p,time=~p",
        [Type, Pkey1, Nickname1, Pkey2, Nickname2, MarryType, util:unixtime()]),
    log_proc:log(Sql).