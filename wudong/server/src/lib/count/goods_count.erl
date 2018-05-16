%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 当天获得的物品统计 (全服)
%%% @end
%%% Created : 13. 一月 2016 下午8:44
%%%-------------------------------------------------------------------
-module(goods_count).
-author("fengzhenlin").
-include("count.hrl").
-include("goods.hrl").

%% API
-export([
    init/0,
    add_count/1,
    log_goods_count/2,
    night_refresh/0
]).

init() ->
    Sql = io_lib:format("select goods_id,num from cron_goods_count where num > 1000", []),
    L = db:get_all(Sql),
    F = fun([GoodsId, Num]) ->
        Cg = #cgoods{
            goods_id = GoodsId,
            num = Num,
            add_num = 0
        },
        ets:insert(?ETS_GOODS_COUNT, Cg)
        end,
    lists:foreach(F, L).

%%增加计数
%%GoodsList: [{物品类型Id,数量,...}]
add_count(GoodsList) ->
    spawn(fun() -> add_count_helper(GoodsList) end).
add_count_helper([]) -> skip;
add_count_helper([{GoodsId, Num, _, GoodsType} | Tail]) ->
    case GoodsId < 20000 of %%虚拟物品不统计 如元宝等
        true -> skip;
        false ->
            case ets:lookup(?ETS_GOODS_COUNT, GoodsId) of
                [] ->
                    NewNum = Num,
                    Cg = #cgoods{
                        goods_id = GoodsId,
                        num = Num,
                        add_num = Num
                    },
                    check_log(Cg),
                    ets:insert(?ETS_GOODS_COUNT, Cg);
                [Cg | _] ->
                    NewNum = Cg#cgoods.num + Num,
                    NewCg = Cg#cgoods{
                        num = NewNum,
                        add_num = Cg#cgoods.add_num + Num
                    },
                    check_log(NewCg),
                    ets:insert(?ETS_GOODS_COUNT, NewCg)
            end,

            #goods_type{
                server_warning_num = ServerWargingNum
            } = GoodsType,
            case ServerWargingNum > 0 andalso NewNum >= ServerWargingNum of
                true -> %%报警
                    %role_goods_count:http_post("",GoodsId,NewNum,2),
                    ok;
                false ->
                    skip
            end
    end,
    add_count_helper(Tail).

check_log(Cg) ->
    case Cg#cgoods.add_num > 300 of
        true ->
            NewCg = Cg#cgoods{
                add_num = 0
            },
            ets:insert(?ETS_GOODS_COUNT, NewCg),
            goods_count:log_goods_count(Cg#cgoods.goods_id, Cg#cgoods.num);
        false ->
            skip
    end.

log_goods_count(GoodsId, Num) ->
    Base = data_goods:get(GoodsId),
    Sql = io_lib:format("replace into cron_goods_count set goods_id=~p,num=~p,goods_name='~s'", [GoodsId, Num, Base#goods_type.goods_name]),
    log_proc:log(Sql),
    ok.

%%晚上清数据
night_refresh() ->
    ets:delete_all_objects(?ETS_GOODS_COUNT),
    Sql = io_lib:format("truncate cron_goods_count", []),
    db:execute(Sql),
    ok.