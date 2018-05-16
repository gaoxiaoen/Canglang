%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     每日活跃统计
%%% @end
%%% Created : 10. 十月 2017 10:03
%%%-------------------------------------------------------------------
-module(cron_login).
-author("hxming").

-include("common.hrl").
%% API
-export([cron_login/1, cron_login/0, get_cron_login/0]).


cron_login() ->
    cron_login(util:unixtime()),
    ok.

cron_login(Now) ->
    spawn(fun() -> util:sleep(5000), do_cron_login(Now) end),
    ok.

do_cron_login(Now) ->
    case config:is_center_node() of
        true -> ok;
        false ->
            Time = util:get_today_midnight(Now) - ?ONE_DAY_SECONDS,
            Sql = io_lib:format("select ps.pkey,ps.lv,ps.combat_power from player_state as ps left join player_login as pl on pl.pkey=ps.pkey where pl.last_login_time > ~p and ps.lv > 50 ", [Time]),
            case db:get_all(Sql) of
                [] -> ok;
                Data ->
                    AccLogin = length(Data),
                    Cbp = round(lists:sum([Cbp1 || [_Key, _Lv, Cbp1] <- Data]) / AccLogin),
                    Lv = round(lists:sum([Lv1 || [_Key, Lv1, _Cbp] <- Data]) / AccLogin),
                    AccCharge = cron_charge(Time),
                    cache:set(?MODULE, {AccLogin, Cbp}, ?ONE_DAY_SECONDS),
                    Sn = config:get_server_num(),
                    Sql1 = io_lib:format("replace into cron_login set time =~p,sn=~p,acc_login =~p,lv =~p,cbp=~p,acc_charge=~p", [Time, Sn, AccLogin, Lv, Cbp, AccCharge]),
                    db:execute(Sql1),
                    ?DEBUG("cron login ok"),
                    {AccLogin, Cbp}
            end
    end.

cron_charge(Time) ->
    Sql = io_lib:format("select sum(total_fee) from recharge where time > ~p", [Time]),
    case db:get_row(Sql) of
        [null]->0;
        [Acc] when is_integer(Acc) -> Acc;
        _ -> 0
    end.


get_cron_login() ->
    Now = util:unixtime(),
    Time = util:get_today_midnight(Now) - ?ONE_DAY_SECONDS,
    case cache:get(?MODULE) of
        [] ->
            Sql = io_lib:format("select acc_login,cbp from cron_login where time =~p", [Time]),
            case db:get_row(Sql) of
                [] ->
                    case do_cron_login(Now) of
                        ok ->
                            cache:set(?MODULE, {0, 0}, ?FIFTEEN_MIN_SECONDS),
                            {0, 0};
                        {AccLogin, Cbp} ->
                            {AccLogin, Cbp}
                    end;
                [AccLogin, Cbp] ->
                    cache:set(?MODULE, {AccLogin, Cbp}, ?ONE_DAY_SECONDS),
                    {AccLogin, Cbp}
            end;
        Val -> Val
    end.
