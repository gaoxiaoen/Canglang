%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 八月 2016 16:51
%%%-------------------------------------------------------------------
-module(panic_buying_init).
-author("hxming").

-include("panic_buying.hrl").
-include("common.hrl").
%% API
-compile(export_all).

init(Now) ->
    case panic_buying:check_activity_time(Now) of
        false ->
            panic_buying_load:clean_db(),
            [];
        true ->
            case panic_buying_load:load_all() of
                [] ->
                    default_list(Now);
                Data ->
                    F = fun([Id, Type, Date, GoodsId, Num, Times, BugLog, Time, State, LuckyNum, Pkey]) ->
                        Timer = ?IF_ELSE(Time > Now, Time - Now, 60),
                        if State == ?PANIC_BUYING_STATE_BUY ->
                            Ref = erlang:send_after(Timer * 1000, self(), {ready, Id});
                            State == ?PANIC_BUYING_STATE_REWARD ->
                                Ref = erlang:send_after(Timer * 1000, self(), {reward, Id});
                            true ->
                                Ref = 0
                        end,
                        #pb_goods{
                            id = Id,
                            type = Type,
                            date = Date,
                            goods_id = GoodsId,
                            num = Num,
                            times = Times,
                            buy_log = buy_log_to_record(BugLog),
                            time = Time,
                            ref = Ref,
                            state = State,
                            lucky_num = LuckyNum,
                            pkey = Pkey
                        }
                        end,
                    lists:map(F, Data)
            end
    end.

%%中奖纪录
init_log() ->
    ok.

%%默认
default_list(Now) ->
    F = fun(Type) ->
        Record = new_buying_goods(Type, 1, Now),
        panic_buying_load:replace(Record),
        Record
        end,
    lists:map(F, lists:seq(1, 3)).

new_buying_goods(Type, Date, Now) ->
    case panic_buying:is_activity_time(Now) of
        false -> #pb_goods{type = Type, state = 3, time = Now};
        {true, EndTime} ->
            if EndTime < ?ONE_HOUR_SECONDS ->
                #pb_goods{type = Type, state = 3, time = Now};
                true ->
                    F = fun(Id) ->
                        Base = data_panic_buying:get(Id),
                        if Base#base_panic_buying.type == Type ->
                            [{Base, Base#base_panic_buying.ratio}];
                            true -> []
                        end
                        end,
                    RatioList = lists:flatmap(F, data_panic_buying:ids()),
                    Goods = util:list_rand_ratio(RatioList),
                    %%物品超时在活动结束前15分钟
                    LastTime = min(Now, EndTime - 15 * 60),
                    Ref = erlang:send_after(LastTime * 1000, self(), {timeout, Type}),
                    #pb_goods{
                        id = Type * 1000000 + Date,
                        type = Type,
                        date = Date,
                        goods_id = Goods#base_panic_buying.goods_id,
                        num = Goods#base_panic_buying.num,
                        times = Goods#base_panic_buying.times,
                        time = Goods#base_panic_buying.time + LastTime,
                        ref = Ref
                    }
            end
    end.


%%(精品,特供,特价 分别对应 1  2  3) + 期数 (3位 如:001) + 随机号  ( 随机号随机范围为  1 到 商品拥有的号码总数. )
number_list(Type, Date, Start, Len) ->
    F = fun(Id) ->
        Type * 100000000 + Date * 100000 + Id
        end,
    lists:map(F, lists:seq(Start + 1, Start + Len)).


buy_log_to_list(BugLog) ->
    F = fun(Log) ->
        [Log#pb_mb.sn, Log#pb_mb.pkey, Log#pb_mb.nickname, util:term_to_bitstring(Log#pb_mb.num_list), Log#pb_mb.time]
        end,
    lists:map(F, BugLog).

buy_log_to_record(BugLog) ->
    F = fun([Sn, Pkey, Nickname, Numbers, Time]) ->
        #pb_mb{sn = Sn, pkey = Pkey, nickname = Nickname, num_list = util:bitstring_to_term(Numbers), time = Time}
        end,
    lists:map(F, util:bitstring_to_term(BugLog)).

