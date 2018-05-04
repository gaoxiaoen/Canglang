-module(energy_rpc).
-export([
        handle/3

    ]
).

-include("assets.hrl").
-include("energy.hrl").
-include("role.hrl").
-include("vip.hrl").
-include("common.hrl").
-include("gain.hrl").
-include("link.hrl").

%% 玩家查看在XXX秒后可恢复五点体力
handle(19600, {}, Role = #role{vip = #vip{type = Vip},energy = #energy{next_time = _NextTime, recover_time =  RTime, buy_times = BuyTimes}}) ->
    SumTime = energy_data:get(Vip),
    case RTime =/= 0 of
        true ->
            Remain = energy:get_auto_time(Role),
            {reply, {Remain, SumTime - BuyTimes}};
        false ->
            {reply, {0, SumTime - BuyTimes}}
    end;

%% 体力信息
handle(19602, {}, Role) ->
    energy:pack_send_energy_status(Role),
    {ok};

%% 领取体力
handle(19603, {Id}, Role = #role{energy = Eng = #energy{has_rcv_id = HasRcv}})when Id=:=?online2 orelse Id=:= ?online3 ->
    case lists:member(Id, HasRcv) of
        true ->
            {reply, {?false, ?MSGID(<<"不能重复领取">>)}};
        false ->
            Lst = energy:time2online_info(),
            case Lst of
                [CanGetId] ->
                    case CanGetId =:= Id of
                        true ->
                            {ok, NewRole} = role_gain:do([#gain{label = energy, val = ?give_energy}], Role),
                            {reply, {?true, ?MSGID(<<"领取成功">>)}, NewRole#role{energy = Eng#energy{has_rcv_id = [Id | HasRcv]}}};
                        false ->
                            {ok}
                    end;
                [] ->
                    {reply, {?false, ?MSGID(<<"在线时间不够，暂时不能领取">>)}}
            end
    end;

%% 购买体力
handle(19604, {1}, Role = #role{vip = #vip{type = Vip}, energy = #energy{buy_times = BuyTimes}}) ->
    case energy_data:get(Vip) of
        false ->
            notice:alert(error, Role, ?MSGID(<<"VIP等级不能购买">>)),
            {ok};
        Times ->
            case BuyTimes >= Times of
                false ->
                    Gold = energy_data:get_gold(BuyTimes + 1),
                    case role_gain:do([#loss{label = gold, val = Gold}], Role) of
                        {ok, Role1} ->
                            {ok, Role2 = #role{energy = Eng}} = role_gain:do([#gain{label=energy, val = ?buy_add_energy}], Role1),
                            Role3 = Role2#role{energy = Eng#energy{buy_times=BuyTimes+1}},
                            energy:pack_send_19605(Role3),
                            notice:alert(succ, Role3, ?MSGID(<<"体力增加100">>)),
                            {ok, Role3};
                        {false, _} ->
                            notice:alert(error, Role, ?MSGID(<<"晶钻不足">>)),
                            {ok}
                    end;
                true ->
                    notice:alert(error, Role, ?MSGID(<<"没有购买次数">>)),
                    {ok}
            end
    end;

%% 喝体力药水
handle(19604, {2}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case energy:use_energy_water(by_base_id, 201001, 1, Role) of
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok};
        Ret ->
            Ret
    end;

%% 请求在线时长
handle(19604, {}, Role = #role{}) ->
    {reply, {energy:get_online_time(Role)}};

%% 容错匹配
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.



