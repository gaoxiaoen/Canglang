%%----------------------------------------------------
%% 后台管理对应进程的数据库操作
%%
%% @author yjbgwxf@gmail.com
%%----------------------------------------------------
-module(adm_sys_db).
-export([save_online_num/3
        ,calc_avg_day_online_num/1
        ,clean_online_num_realtime/0
        ,stats_churn_rate/0
        ,stats_role_active/0
        ,stats_reg_role_lost/0
        ,gold_stats/0
        ,gold_stats_first_charge/0
        ,lev_lost_stats/0
        ,mystery_consume_stats/0
        ,casino_stats/0
        ,coin_stats/0
        ,big_rmb_roles/0
        ,big_rmb_role_image/1
    ]
).

-include("adm_sys.hrl").
-include("common.hrl").

-define(UNIXDAYTIME, 86400).    %% unixtime 一天86400秒

%% @spec save_online_num(Time, Node, Num) -> true | false
%% Time = integer()
%% Node = atom()
%% Num = integer()
%% @doc 保存Time时间，结点Node上的在线人数Num到数据库中
save_online_num(Time, Node, Num) ->
    Sql = <<"insert into log_online_num_realtime(utime, node, num) values(~s,~s,~s)">>,
    case db:execute(Sql, [Time, atom_to_list(Node), Num]) of
        {error, _Why} ->
            ?ERR("[~w], 实时在线人数保存到数据库发生错误 [~s]", [?MODULE, _Why]),
            false;
        {ok, _Result} ->
            true
    end.

%% @spec calc_avg_day_online_num(Node) -> true | false
%% Node = atom()
%% @doc 计算时间 前一天 内节点上在线人数平均值, 以及峰值
calc_avg_day_online_num(Node) ->
    ZeroTime = util:unixtime({today, util:unixtime()}),
    LastZero = ZeroTime - ?UNIXDAYTIME,
    Sql1 = <<"select avg(num), max(num) from log_online_num_realtime where node = ~s and utime >= ~s and utime < ~s">>,
    NodeStr = atom_to_list(Node),
    case db:get_row(Sql1, [NodeStr, LastZero, ZeroTime]) of
        {error, _Why1} ->
            ?ERR("[~w], 计算前一天平均在线人数时数据库操作发生错误 [~s]", [?MODULE, _Why1]),
            false;
        {ok, [Avg, Max]} ->
            Sql2 = <<"insert into log_online_num_day(utime, node, num, peak) values(~s,~s,~s,~s)">>,
            case db:execute(Sql2, [((ZeroTime + LastZero) div 2), NodeStr, erlang:round(Avg), Max]) of
                {error, _Why2} ->
                    ?ERR("[~w], 将前一天平均在线人数保存到数据库时发生错误 [~s]", [?MODULE, _Why2]),
                    false;
                {ok, _Result} ->
                    true
            end
    end.

%% @spec clean_online_num_realtime() -> true | false
%% @doc 删除三天前的log_online_num_realtime表的数据
clean_online_num_realtime() ->
    Time = util:unixtime({today, util:unixtime()}) - (3*?UNIXDAYTIME),
    Sql = <<"delete from log_online_num_realtime where utime < ~s">>,
    case db:execute(Sql, [Time]) of
        {error, _Why} ->
            ?ERR("[~w], 清除3天前数据时，数据库操作发生错误 [~s]", [?MODULE, _Why]),
            false;
        {ok, _Result} ->
            true
    end.

%% @spec stats_churn_rate() -> true | false
%% @doc 统计在前一天注册的新角色数，老角色登陆数，以及在 今天凌晨 之前注册的所有角色数
stats_churn_rate() ->
    Zero = util:unixtime({today, util:unixtime()}),
    LastZero = Zero - ?UNIXDAYTIME,
    Sql1 = <<"select count(id) from role where reg_time < ~s">>,   %% 到统计当天凌晨已有注册角色
    Sql2 = <<"select count(id) from role where reg_time >= ~s and reg_time < ~s">>, %% 昨天注册的角色数
    Sql3 = <<"select count(id) from role where reg_time < ~s and login_time >= ~s and login_time < ~s">>,   %% 昨天之前注册的，昨天又有登录的
    Sql4 = <<"select total_roles from log_userlost_rate where ctime >= ~s and ctime < ~s">>,   %% 获取上上一天统计的累计角色数
    Sql5 = <<"select count(distinct login_ip) from role where login_time >= ~s and login_time < ~s">>, %% 一天内 登录IP数(最后一次登录)
    Sql = <<"insert into log_userlost_rate(new_roles, old_roles, total_roles, rate, login_ip_role_num, ctime) values(~s,~s,~s,~s,~s,~s)">>,
    case db:get_one(Sql1, [Zero]) of
        {error, _Why1} ->
            ?ERR("统计当天凌晨累计角色数发生错误 [~s]", [_Why1]),
            false;
        {ok, Total} ->
            case db:get_one(Sql2, [LastZero, Zero]) of
                {error, _Why2} ->
                    ?ERR("统计前一天注册角色数发生错误, [~s]", [_Why2]),
                    false;
                {ok, New} ->
                    case db:get_one(Sql3, [LastZero, LastZero, Zero]) of
                        {error, _Why3} ->
                            ?ERR("统计昨天之前注册且昨天又有登录的老玩家数"),
                            false;
                        {ok, Old} ->
                            Rate = case db:get_one(Sql4, [LastZero - ?UNIXDAYTIME, Zero - ?UNIXDAYTIME]) of
                                {error, _Why4} -> 0;
                                {ok, OldTotal} when OldTotal > 0 -> round((OldTotal - Old) * 100 / OldTotal);
                                _ -> 0
                            end,
                            Ips = case db:get_one(Sql5, [LastZero, Zero]) of
                                {ok, IpNum} -> IpNum;
                                _ -> 0
                            end,
                            case db:execute(Sql, [New, Old, Total, Rate, Ips, util:unixtime() - 86400]) of
                                {error, _Why} ->
                                    ?ERR("保存用户流失率统计结果到数据库中是发生错误，[~s]", [_Why]),
                                    false;
                                {ok, _Result} ->
                                    true
                            end
                    end
            end
    end.

%% @spec stats_role_active() -> true | false
%% @doc 统计玩家活跃度统计
stats_role_active() ->
    End = util:unixtime({today, util:unixtime()}),
    Mid = End - ?UNIXDAYTIME,
    Beg = Mid - ?UNIXDAYTIME, 
    Sql = <<"insert into log_role_activity(lv10,twodays, ctime) values(~s,~s,~s)">>,
    Sql1 = <<"select count(id) from role where lev >= 10">>,
    Sql2 = <<"select distinct role_id, srv_id 
            from log_role_login 
            where ctime >= ~s and ctime < ~s and log_type = 0
            and exists(
                    select distinct role_id, srv_id 
                    from log_role_login 
                    where ctime >= ~s and ctime < ~s and log_type = 0 group by role_id, srv_id) group by role_id, srv_id">>,
    case db:get_one(Sql1) of
        {error, _Why} ->
            ?ERR("进行十级以上人数统计时，数据库查询失败, [Reason: ~s]", [_Why]),
            false;
        {ok, Total} ->
            case db:get_all(Sql2, [Beg, Mid, Mid, End]) of
                {ok, Roles} -> 
                    case db:execute(Sql, [Total, length(Roles), util:unixtime() - 86400]) of
                        {error, _Why1} ->
                            ?ERR("玩家活跃度统计结果保存到数据库时，发生错误，[Reason: ~s]", [_Why1]),
                            false;
                        {ok, _Result} ->
                            true
                    end;
                {error, _Why2} ->
                    ?ERR("进行连续两天登录人数统计时，数据库查询失败, [Reason: ~s]", [_Why2]),
                    false
            end
    end.

%% @spec gold_stats() -> true | false
%% @doc 晶钻数值统计
gold_stats() ->
    End = util:unixtime({today, util:unixtime()}),
    Beg = End - ?UNIXDAYTIME,
    Sql = <<"insert into log_gold_stats(utime, charge, issue, consume, stock, rate, asc_des, money, peoples, arup) values (~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)">>,
    Sql1 = <<"select sum(gold), sum(money), count(distinct account) from sys_charge where ts >= ~s and ts < ~s">>,
    Sql2 = <<"select sum(gold) from log_mail where sendtime >= ~s and sendtime < ~s">>,
    Sql3 = <<"select -sum(gold) from log_gold where gold < 0 and ctime >= ~s and ctime < ~s">>,
    Sql4 = <<"select sum(gold) from role_assets">>,
    Sql5 = <<"select charge from log_gold_stats where utime >= ~s and utime < ~s">>,
    case db:get_row(Sql1, [Beg, End]) of
        {error, _Why1} ->
            ?ERR("统计每日充值晶钻数时，数据库操作发生失败，[Reason: ~s]", [_Why1]),
            false;
        {ok, [Charge1, Money1, Num1]} ->
            case db:get_one(Sql2, [Beg, End]) of
                {error, _Why2} ->
                    ?ERR("统计每日发放晶钻数时，数据库操作发生失败，[Reason: ~s]", [_Why2]),
                    false;
                {ok, Issue1} ->
                    case db:get_one(Sql3, [Beg, End]) of
                        {error, _Why3} ->
                            ?ERR("统计每日消费晶钻数时，数据库操作发生失败，[Reason: ~s]", [_Why3]),
                            false;
                        {ok, Consume1} ->
                            case db:get_one(Sql4) of
                                {error, _Why4} ->
                                    ?ERR("统计每日库存晶钻数时，数据库操作发生失败，[Reason: ~s]", [_Why4]),
                                    false;
                                {ok, Stock1} ->
                                    [Charge, Money, Num, Issue, Consume, Stock] = lists:map(fun clear_undefined/1, [Charge1, Money1, Num1, Issue1, Consume1, Stock1]),
                                    case db:get_one(Sql5, [Beg - ?UNIXDAYTIME, End - ?UNIXDAYTIME]) of
                                        {error, _Why5} ->
                                            Rate = if Charge > 0 -> trunc(Consume * 100 / Charge); true -> 0 end,
                                            Arup = if Num > 0 -> trunc(Money/Num); true -> 0 end,
                                            case db:execute(Sql, [util:unixtime() - 86400, Charge, Issue, Consume, Stock, Rate, 0, Money, Num, Arup]) of
                                                {error, _Why} ->
                                                    ?ERR("保存晶钻数值统计结果时，数据库操作发生失败，[Reason: ~s]", [_Why]),
                                                    false;
                                                {ok, _Result} ->
                                                    true
                                            end;
                                        {ok, Golds} ->
                                            Rate = if Charge > 0 -> trunc(Consume * 100 / Charge); true -> 0 end,
                                            Arup = if Num > 0 -> trunc(Money/Num); true -> 0 end,
                                            AscDes = if Golds =< Charge -> 1; true -> 0 end,
                                            case db:execute(Sql, [util:unixtime() - 86400, Charge, Issue, Consume, Stock, Rate, AscDes, Money, Num, Arup]) of
                                                {error, _Why} ->
                                                    ?ERR("保存晶钻数值统计结果时，数据库操作发生失败，[Reason: ~s]", [_Why]),
                                                    false;
                                                {ok, _Result} ->
                                                    true
                                            end
                                    end
                            end
                    end
            end
    end.

%% @spec gold_stats_first_charge() -> true | false
%% @doc  首冲晶钻统计
gold_stats_first_charge() ->
    End = util:unixtime({today, util:unixtime()}),
    Beg = End - ?UNIXDAYTIME,
    Sql1 = <<"select money, gold, account from sys_charge where ts >= ~s and ts < ~s">>,
    Sql2 = <<"select distinct account from sys_charge where ts < ~s">>,
    Sql3 = <<"select gold from log_gold_first_charge where ctime >= ~s and ctime < ~s">>,
    Sql = <<"insert into log_gold_first_charge(ctime, money, gold, accs, arup, asc_des) values(~s,~s,~s,~s,~s,~s)">>,
    case db:get_all(Sql1, [Beg, End]) of
        {error, _Why1} ->
            ?ERR("获取上日充值记录发生错误【Reason: ~s】", [_Why1]),
            false;
        {ok, Charges} ->
            case db:get_all(Sql2, [Beg]) of
                {error, _Why2} ->
                    ?ERR("获取老充值玩家列表时发生错误【Reason: ~s】", [_Why2]),
                    false;
                {ok, Accounts} ->
                    {Money, Gold, AccNum} = analysis_first_charge(Charges, Accounts),
                    case db:get_one(Sql3, [Beg - ?UNIXDAYTIME, End - ?UNIXDAYTIME]) of
                        {error, _Why3} ->
                            Arup = case AccNum > 0 of
                                true -> trunc(Money/AccNum);
                                false -> 0
                            end,
                            case db:execute(Sql, [util:unixtime() - 86400, Money, Gold, AccNum, Arup, 0]) of
                                {error, _Why4} ->
                                    ?ERR("保存首冲晶钻统计结果到数据库中时发生错误，【~s】", [_Why4]),
                                    false;
                                {ok, _Result} ->
                                    true
                            end;
                        {ok, LastGold} ->
                            Arup = case AccNum > 0 of
                                true -> trunc(Money/AccNum);
                                false -> 0
                            end,
                            AscDes = if LastGold =< Gold -> 1; true -> 0 end,
                            case db:execute(Sql, [util:unixtime() - 86400, Money, Gold, AccNum, Arup, AscDes]) of
                                {error, _Why4} ->
                                    ?ERR("保存首冲晶钻统计结果到数据库中时发生错误，【~s】", [_Why4]),
                                    false;
                                {ok, _Result} ->
                                    true
                            end
                    end
            end
    end.

%% mystery_consume_stats() -> true | false
mystery_consume_stats() ->
    End = util:unixtime({today, util:unixtime()}),
    Beg = End - ?UNIXDAYTIME,
    Sql1 = <<"select count(distinct rid), count(id), sum(gold) from log_gold where type = '神秘商店消费' and remark = '刷新神秘商店' and ctime >= ~s and ctime < ~s">>,
    Sql2 = <<"select gold from log_mystery_shop_stats where utime >= ~s and utime < ~s">>,
    Sql = <<"insert into log_mystery_shop_stats(utime, accs, sales, gold, avg, asc_des) values(~s,~s,~s,~s,~s,~s)">>,
    case db:get_row(Sql1, [Beg, End]) of
        {error, _Why1} ->
            ?ERR("进行神秘商店消费统计时，查询数据库操作失败, 【Reason: ~s】", [_Why1]),
            false;
        {ok, [Accs, Sales, SumGold]} ->
            Sum = if is_integer(SumGold) -> -SumGold; true -> 0 end,
            case db:get_one(Sql2, [Beg - ?UNIXDAYTIME, End - ?UNIXDAYTIME]) of
                {error, _Why2} ->
                    Avg = case Accs >0 of
                        true -> trunc(Sum/Accs);
                        false -> 0
                    end,
                    case db:execute(Sql, [util:unixtime() - 86400, Accs, Sales, Sum, Avg, 0]) of
                        {error, _Why} ->
                            ?ERR("保存神秘商店消费统计数据到数据发生失败【Reason: ~s】", [_Why]),
                            false;
                        {ok, _Result} ->
                            true
                    end;
                {ok, Gold} ->
                    Avg = case Accs >0 of
                        true -> trunc(Sum/Accs);
                        false -> 0
                    end,
                    AscDes = if Gold =< Sum -> 1; true -> 0 end,
                    case db:execute(Sql, [util:unixtime() - 86400, Accs, Sales, Sum, Avg, AscDes]) of
                        {error, _Why} ->
                            ?ERR("保存神秘商店消费统计数据到数据发生失败【Reason: ~s】", [_Why]),
                            false;
                        {ok, _Result} ->
                            true
                    end
            end
    end.

%% @spec casino_stats() -> true | false
%% @doc 仙境寻宝统计分析
casino_stats() ->
    End = util:unixtime({today, util:unixtime()}),
    Beg = End - ?UNIXDAYTIME, 
    Sql1 = <<"select rid, srv_id, open_times, price from log_casino_open where ct >= ~s and ct < ~s">>,
    Sql2 = <<"select total_gold from log_casino_stats where utime >= ~s and utime < ~s">>,
    Sql = <<"insert into log_casino_stats(accs, total, total_gold, one, one_per, one_gold, one_gold_per, ten, ten_per, ten_gold, ten_gold_per, fifty, fifty_per, fifty_gold,fifty_gold_per, asc_des, utime) values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)">>,
    case db:get_all(Sql1, [Beg, End]) of
        {error, _Why1} ->
            ?ERR("进行仙境寻宝统计分析时，查询数据库发生错误【~s】", [_Why1]),
            false;
        {ok, Casinos} ->
            {Accs, Total, TGold, One, OneGold, Ten, TenGold, Fifty, FiftyGold} = casino_stats_analysis(Casinos),
            AscDes = case db:get_one(Sql2, [Beg - ?UNIXDAYTIME, End - ?UNIXDAYTIME]) of
                {error, _Why2} -> 0;
                {ok, Line} when Line =< TGold -> 1;
                _ -> 0
            end,
            {OR, OGR, TR, TGR, FR, FGR} = case Total =:= 0 of
                true ->
                    {0,0,0,0,0,0};
                false ->
                    {round(100*One/Total), round(100*OneGold/TGold), round(100*Ten/Total), round(100*TenGold/TGold), round(100*Fifty/Total), round(100*FiftyGold/TGold)}
            end,
            case db:execute(Sql, [Accs, Total, TGold, One, OR, OneGold, OGR, Ten, TR, TenGold, TGR, Fifty, FR, FiftyGold, FGR, AscDes, util:unixtime() - 86400]) of
                {error, _Why} ->
                    ?ERR("保存仙境寻宝统计结果到数据库时发生错误【Reason: ~s】", [_Why]),
                    false;
                {ok, _Result} ->
                    true
            end
    end.

%% @spec coin_stats() -> ture | false
%% @doc 金币分析
coin_stats() ->
    End = util:unixtime({today, util:unixtime()}),
    Beg = End - ?UNIXDAYTIME,
    Sql1 = <<"select bind_coin, coin from log_coin where ctime >= ~s and ctime < ~s">>,
    Sql2 = <<"select sum(coin), sum(coin_bind) from role_assets">>,
    Sql = <<"insert into log_coin_stats(gb_coin, cb_coin, sb_coin, g_coin, c_coin, s_coin, utime) values(~s,~s,~s,~s,~s,~s,~s)">>,
    case db:get_all(Sql1, [Beg, End]) of
        {error, _Why1} ->
            ?ERR("进行金币分析时，查询数据库操作失败，【~s】", [_Why1]),
            false;
        {ok, Coins} ->
            case db:get_row(Sql2) of
                {error, _Why2} ->
                    ?ERR("查询库存金币和库存绑定金币时，发生数据库错误【~s】", [_Why2]),
                    false;
                {ok, [SumCoin, SumBindCoin]} ->
                    {GB, CB, G, C} = stats_coin_analysis(Coins),
                    case db:execute(Sql, [GB, CB, SumBindCoin, G, C, SumCoin, util:unixtime() - 86400]) of
                        {error, _Why} ->
                            ?ERR("保存金币的统计结果到数据库时发生错误，【~s】", [_Why]),
                            false;
                        {ok, _Result} ->
                            true
                    end
            end
    end.

%% @spec lev_lost_stats() -> true | false
%% @doc 统计等级流失率
lev_lost_stats() ->
    Zero = util:unixtime({today, util:unixtime()}),
    OneDayLine = Zero - ?UNIXDAYTIME,
    ThreeDayLine = Zero - 3 * ?UNIXDAYTIME,
    Sql = <<"insert into log_lev_lost(utime, lev, num, rate, day3, live_rate, hour, live_rate_hour) values (~s,~s,~s,~s,~s,~s, ~s, ~s)">>,
    Sql1 = <<"select lev, login_time from role">>,
    case db:get_all(Sql1) of
        {error, _Why1} ->
            ?ERR("进行等级流失率统计时，查询数据库操作失败，【Reason: ~s】", [_Why1]),
            false;
        {ok, Levs} ->
            Total = length(Levs),
            Result = lev_lost_analysis(ThreeDayLine, OneDayLine, Levs),
            insert_lev_lost_data(util:unixtime() - 86400, Sql, Total, Result)
    end.

%% @spec stats_reg_role_lost() -> true | false
%% @doc 新注册玩家流失率统计
stats_reg_role_lost() ->
    Zero = util:unixtime({today, util:unixtime()}),
    End = Zero - 2 * ?UNIXDAYTIME,
    Beg = Zero - 3 * ?UNIXDAYTIME,
    Sql = <<"insert into log_new_role_lost(utime, segment, num, rate) values(~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s), (~s,~s,~s,~s)">>,
    Sql1 = <<"select count(id) from role">>,
    Sql2 = <<"select login_time - reg_time as diff from role where reg_time >= ~s and reg_time < ~s">>,
    case db:get_one(Sql1) of
        {error, _Why} ->
            ?ERR("进行玩家总数统计时数据库操作发生错误，【Reason: ~s】", [_Why]),
            false;
        {ok, Total} ->
            case db:get_all(Sql2, [Beg, End]) of
                {error, _Why1} ->
                    ?ERR("查询三天前注册的玩家数据时发生错误，【Reason: ~s】", [_Why1]),
                    false;
                {ok, Diffs} ->
                    Result = reg_stats_analysis(util:unixtime() - 86400, Diffs, Total),
                    case db:execute(Sql, Result) of
                        {error, _Why2} ->
                            ?ERR("保存新注册玩家流失率时，数据库操作发生失败，【Reason: ~s】", [_Why2]),
                            false;
                        {ok, _Result} ->
                            true
                    end
            end
    end.

%% @spec big_rmb_roles() -> IdList::list()
%% @doc获取充值yb>1w的rmb玩家ID列表
big_rmb_roles() ->
    Sql = <<"select rid, srv_id from sys_charge where gold > 0 group by rid, srv_id">>,
    %% 一下SQL语句可得到同样的效果：
    %% Sql = <<"select distinct rid, srv_id from sys_charge where gold > 0 order by rid">>
    case db:get_all(Sql) of
        {error, _Why} -> [];
        {ok, List} ->
            big_rmb_roles(List, [])
    end.
big_rmb_roles([], L) -> L;
big_rmb_roles([[Rid, SrvId] | T], L) ->
    Sql = <<"select sum(gold) from sys_charge where rid = ~s and srv_id = ~s">>,
    case db:get_one(Sql, [Rid, SrvId]) of
        {ok, SumGold} when SumGold >= 10000 ->
            Data = [Rid, SrvId, SumGold],
            big_rmb_roles(T, [Data | L]);
        _E ->
            big_rmb_roles(T, L)
    end;
big_rmb_roles([_H | T], L) ->
    big_rmb_roles(T, L).

%% @doc 插入记录
big_rmb_role_image([]) -> ok;
big_rmb_role_image(InfoList) ->
    Sql = <<"replace into log_big_rmb_images (rid, srv_id, name, mount_val, wing_val, pet_grow, pet_avg, channel_state, forty_suit, fifty_suit, sixty_suit, seventy_suit, eighty_suit, demon_lev, info, ctime) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    TmpL = lists:reverse([util:unixtime() | lists:reverse(InfoList)]),
    db:execute(Sql, TmpL),
    ok.

%%-----------------------------------------------------
%% 私有函数
%%----------------------------------------------------
%% 新注册玩家24小时内的流失率分析
reg_stats_analysis(Utime, Diffs, Total) ->
    pack_reg_stats_analysis_result(Utime, stats_reg_segment(Diffs), Total).

pack_reg_stats_analysis_result(Utime, #new_reg_role_segment{m_1 = M1, m_2 = M2 ,m_3 = M3 ,m_4 = M4, m_5 = M5
        ,h_1 = H1 ,h_2 = H2 ,h_3 = H3 ,h_4 = H4 ,h_5 = H5 ,h_6 = H6 ,h_7 = H7 ,h_8 = H8 ,h_9 = H9 ,h_10 = H10
        ,h_11 = H11 ,h_12 = H12 ,h_13 = H13 ,h_14 = H14 ,h_15 = H15 ,h_16 = H16 ,h_17 = H17 ,h_18 = H18 ,h_19 = H19 ,h_20 = H20
        ,h_21 = H21 ,h_22 = H22 ,h_23 = H23 ,h_24 = H24}, Total) ->
    [Utime, 1, M1, trunc(M1*100/Total)
    ,Utime, 2, M2, trunc(M2*100/Total)
    ,Utime, 3, M3, trunc(M3*100/Total)
    ,Utime, 4, M4, trunc(M4*100/Total)
    ,Utime, 5, M5, trunc(M5*100/Total)
    ,Utime, 6, H1, trunc(H1*100/Total)
    ,Utime, 12, H2, trunc(H2*100/Total)
    ,Utime, 18, H3, trunc(H3*100/Total)
    ,Utime, 24, H4, trunc(H4*100/Total)
    ,Utime, 30, H5, trunc(H5*100/Total)
    ,Utime, 36, H6, trunc(H6*100/Total)
    ,Utime, 42, H7, trunc(H7*100/Total)
    ,Utime, 48, H8, trunc(H8*100/Total)
    ,Utime, 54, H9, trunc(H9*100/Total)
    ,Utime, 60, H10, trunc(H10*100/Total)
    ,Utime, 66, H11, trunc(H11*100/Total)
    ,Utime, 72, H12, trunc(H12*100/Total)
    ,Utime, 78, H13, trunc(H13*100/Total)
    ,Utime, 84, H14, trunc(H14*100/Total)
    ,Utime, 90, H15, trunc(H15*100/Total)
    ,Utime, 96, H16, trunc(H16*100/Total)
    ,Utime, 102, H17, trunc(H17*100/Total)
    ,Utime, 108, H18, trunc(H18*100/Total)
    ,Utime, 114, H19, trunc(H19*100/Total)
    ,Utime, 120, H20, trunc(H20*100/Total)
    ,Utime, 126, H21, trunc(H21*100/Total)
    ,Utime, 132, H22, trunc(H22*100/Total)
    ,Utime, 138, H23, trunc(H23*100/Total)
    ,Utime, 144, H24, trunc(H24*100/Total)].

stats_reg_segment(Diffs) ->
    stats_reg_segment(Diffs, #new_reg_role_segment{}).
stats_reg_segment([], Segment) ->
    Segment;
stats_reg_segment([[Diff] | Diffs], Segment) when Diff < 0 ->
    stats_reg_segment(Diffs, Segment);
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{m_1 = Num}) when Diff =< 600 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{m_1 = Num + 1});
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{m_2 = Num}) when Diff =< 1200 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{m_2 = Num + 1});
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{m_3 = Num}) when Diff =< 1800 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{m_3 = Num + 1});
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{m_4 = Num}) when Diff =< 2400 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{m_4 = Num + 1});
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{m_5 = Num}) when Diff =< 3000 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{m_5 = Num + 1});
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_1 = Num}) when Diff =< 3600 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_1 = Num + 1});
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_2 = Num}) when Diff =< 7200 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_2 = Num + 1});                          
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_3 = Num}) when Diff =< 10800 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_3 = Num + 1});                          
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_4 = Num}) when Diff =< 14400 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_4 = Num + 1});                          
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_5 = Num}) when Diff =< 18000 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_5 = Num + 1});                          
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_6 = Num}) when Diff =< 21600 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_6 = Num + 1});                          
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_7 = Num}) when Diff =< 25200 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_7 = Num + 1});                          
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_8 = Num}) when Diff =< 28800 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_8 = Num + 1});
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_9 = Num}) when Diff =< 32400 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_9 = Num + 1});
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_10 = Num}) when Diff =< 36000 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_10 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_11 = Num}) when Diff =< 39600 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_11 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_12 = Num}) when Diff =< 43200 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_12 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_13 = Num}) when Diff =< 46800 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_13 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_14 = Num}) when Diff =< 50400 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_14 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_15 = Num}) when Diff =< 54000 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_15 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_16 = Num}) when Diff =< 57600 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_16 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_17 = Num}) when Diff =< 61200 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_17 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_18 = Num}) when Diff =< 64800 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_18 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_19 = Num}) when Diff =< 68400 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_19 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_20 = Num}) when Diff =< 72000 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_20 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_21 = Num}) when Diff =< 75600 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_21 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_22 = Num}) when Diff =< 79200 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_22 = Num + 1});                           
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_23 = Num}) when Diff =< 82800 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_23 = Num + 1});
stats_reg_segment([[Diff] | Diffs], Segment = #new_reg_role_segment{h_24 = Num}) when Diff =< 86400 ->
    stats_reg_segment(Diffs, Segment#new_reg_role_segment{h_24 = Num + 1});
stats_reg_segment([[_Diff] | Diffs], Segment) ->
    stats_reg_segment(Diffs, Segment).

%% 等级流失率分析
lev_lost_analysis(TDL, ODL, Levs) ->
    lev_lost_analysis(TDL, ODL, Levs, []).
lev_lost_analysis(_TDL, _ODL, [], Result) ->
    lists:keysort(1, Result);
lev_lost_analysis(TDL, _ODL, [[Lev, Time] | Levs], Datas) when Time =< TDL -> %% 三天未登陆
    case lists:keyfind(Lev, 1, Datas) of
        false ->
            lev_lost_analysis(TDL, _ODL, Levs, [{Lev, 1, 1, 1} | Datas]);   %% {当前等级, 当前等级总人数，当前等级三天没有登录的，当前等级24小时没有登录的}
        {Lev, Num, TDL_Num, ODL_Num} ->
            lev_lost_analysis(TDL, _ODL, Levs, lists:keyreplace(Lev, 1, Datas, {Lev, Num + 1, TDL_Num + 1, ODL_Num + 1}))
    end;
lev_lost_analysis(_TDL, ODL, [[Lev, Time] | Levs], Datas) when Time =< ODL -> %% 24小时未登陆
    case lists:keyfind(Lev, 1, Datas) of
        false ->
            lev_lost_analysis(_TDL, ODL, Levs, [{Lev, 1, 0, 1} | Datas]);
        {Lev, Num, TDL_Num, ODL_Num} ->
            lev_lost_analysis(_TDL, ODL, Levs, lists:keyreplace(Lev, 1, Datas, {Lev, Num + 1, TDL_Num, ODL_Num + 1}))
    end;
lev_lost_analysis(TDL, ODL, [[Lev, _Time] | Levs], Datas) -> 
    case lists:keyfind(Lev, 1, Datas) of
        false ->
            lev_lost_analysis(TDL, ODL, Levs, [{Lev, 1, 0, 0} | Datas]);
        {Lev, Num, TDL_Num, ODL_Num} ->
            lev_lost_analysis(TDL, ODL, Levs, lists:keyreplace(Lev, 1, Datas, {Lev, Num + 1, TDL_Num, ODL_Num}))
    end.

insert_lev_lost_data(_Time, _Sql, _Total, []) ->
    true;
insert_lev_lost_data(Time, Sql, Total, [{Lev, Num, TDL_Num, ODL_Num} | List]) ->
    case db:execute(Sql, [Time, Lev, Num, trunc(Num * 100 / Total), TDL_Num, trunc(100*(1 - TDL_Num / Num)), ODL_Num, trunc(100*(1 - ODL_Num / Num))]) of
        {error, _Why} ->
            ?ERR("保存等级流失率统计结果时，数据库操作发生失败，【Reason: ~s】", [_Why]),
            insert_lev_lost_data(Time, Sql, Total, List);
        {ok, _Result} ->
            insert_lev_lost_data(Time, Sql, Total, List)
    end.

%% 晶钻首冲分析
analysis_first_charge(Charges, Accounts) ->
    analysis_first_charge(Charges, [Account || [Account] <- Accounts], 0, 0, []).
analysis_first_charge([], _, Money, Gold, NewAccs) ->
    {Money, Gold, length(lists:usort(NewAccs))};
analysis_first_charge([[M, G, Acc]| T], Accounts, Money, Gold, Accs) ->
    case lists:member(Acc, Accounts) of
        false ->
            analysis_first_charge(T, Accounts, Money + M, Gold + G, [Acc | Accs]);
        true ->
            analysis_first_charge(T, Accounts, Money, Gold, Accs)
    end.

%% 仙境寻宝分析
casino_stats_analysis(Casinos) ->
    casino_stats_analysis(Casinos, {[], 0, 0, 0, 0, 0, 0, 0, 0}).
casino_stats_analysis([], {Accs, Total, TGold, One, OneGold, Ten, TenGold, Fifty, FiftyGold}) ->
    {length(Accs), Total, TGold, One, OneGold, Ten, TenGold, Fifty, FiftyGold};
casino_stats_analysis([[Rid, Srvid, 1, Gold]|T], {Accs, Total, TGold, One, OneGold, Ten, TenGold, Fifty, FiftyGold}) ->
    casino_stats_analysis(T, {lists:usort([{Rid, Srvid}|Accs]), Total + 1, TGold + Gold, One + 1, OneGold + Gold, Ten, TenGold, Fifty, FiftyGold});
casino_stats_analysis([[Rid, Srvid, 10, Gold]|T], {Accs, Total, TGold, One, OneGold, Ten, TenGold, Fifty, FiftyGold}) ->
    casino_stats_analysis(T, {lists:usort([{Rid, Srvid}|Accs]), Total + 1, TGold + Gold, One, OneGold, Ten + 1, TenGold + Gold, Fifty, FiftyGold});
casino_stats_analysis([[Rid, Srvid, 50, Gold]|T], {Accs, Total, TGold, One, OneGold, Ten, TenGold, Fifty, FiftyGold}) ->
    casino_stats_analysis(T, {lists:usort([{Rid, Srvid}|Accs]), Total + 1, TGold + Gold, One, OneGold, Ten, TenGold, Fifty + 1, FiftyGold + Gold});
casino_stats_analysis([[_Rid, _Srvid, OpenTimes, _Gold]|T], {Accs, Total, TGold, One, OneGold, Ten, TenGold, Fifty, FiftyGold}) ->
    ?ERR("非法的仙境寻宝类型【寻宝 ~w 次】", [OpenTimes]),
    casino_stats_analysis(T, {Accs, Total, TGold, One, OneGold, Ten, TenGold, Fifty, FiftyGold}).

%% 统计分析
stats_coin_analysis(Coins) ->
    stats_coin_analysis(Coins, 0, 0, 0, 0).
stats_coin_analysis([], GainBind, ConsumeBind, Gain, Consume) ->
    {GainBind, -ConsumeBind, Gain, -Consume};
stats_coin_analysis([[BindCoin, Coin] | T], GainBind, ConsumeBind, Gain, Consume) ->
    case {BindCoin > 0, Coin > 0} of
        {true, true} ->
            stats_coin_analysis(T, GainBind + BindCoin, ConsumeBind, Gain + Coin, Consume);
        {true, false} ->
            stats_coin_analysis(T, GainBind + BindCoin, ConsumeBind, Gain, Consume + Coin);
        {false, true} ->
            stats_coin_analysis(T, GainBind, ConsumeBind + BindCoin, Gain + Coin, Consume);
        {false, false} ->
            stats_coin_analysis(T, GainBind, ConsumeBind + BindCoin, Gain, Consume + Coin)
    end.

%% clear_undefined
%% @doc 有很多从数据库查出来是 undefined 值，这里用于清除
clear_undefined(X) when is_integer(X) -> X;
clear_undefined(_X) -> 0.
