%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十月 2017 13:38
%%%-------------------------------------------------------------------
-module(limit_vip).
-author("Administrator").
-include("vip.hrl").
-include("common.hrl").
-include("server.hrl").
-include("player_mask.hrl").
-include("charge.hrl").

%% API
-export([
    get_state/1
    , init/1
    , get_attr/1
    , charge/2
    , open_time_limit_vip/1
    , close_time_limit_vip/1
]).

-define(RENEW_TIME, ?ONE_DAY_SECONDS * 2).
%% NewPlayer = player_util:count_player_attribute(Player2, true),

init(Player) ->
    {LimitTime, _RenewTime, State} = player_mask:get(?PLAYER_TIME_LIMIT_VIP, {0, 0, 0}),
    Now = util:unixtime(),
    Base = data_time_limit_vip:get(),
    if
        State == 1 ->
            Player#player{vip_state = 1};
        LimitTime > Now andalso Player#player.lv < Base#base_time_limit_vip.close_lv ->
            Player#player{vip_state = 1};
        true ->
            Player#player{vip_state = 0}
    end.


%% 开启限时vip
open_time_limit_vip(Player) ->
    ?DEBUG("open_time_limit_wing ~n"),
    Lan = version:get_lan_config(),
%%     IsDebug = config:is_debug(),
    if
        Lan == bt ->
            Base = data_time_limit_vip:get(),
            {LimitTime, _RenewTime, State} = player_mask:get(?PLAYER_TIME_LIMIT_VIP, {0, 0, 0}),
            Now = util:unixtime(),
            ?DEBUG("{LimitTime, _RenewTime, State} ~p~n", [{LimitTime, _RenewTime, State}]),
            if
                LimitTime /= 0 -> Player;
                State == 1 -> Player;
                Player#player.lv > Base#base_time_limit_vip.close_lv ->
                    Player;
                LimitTime /= 0 ->
                    Player;
                true ->
                    case task_in_finish() of
                        true ->
                            player_mask:set(?PLAYER_TIME_LIMIT_VIP, {Now + Base#base_time_limit_vip.time, Now + Base#base_time_limit_vip.re_time, 0}),
                            NewPlayer = vip:use_free_vip_card(Player#player{vip_state = 1}, [5, Base#base_time_limit_vip.time]),
                            self() ! send_13001,
                            NewPlayer;
                        false ->
                            Player
                    end
            end;
        true ->
            Player
    end.


close_time_limit_vip(Player) ->
    Lan = version:get_lan_config(),
%%     IsDebug = config:is_debug(),
    if
        Lan == bt ->
            Base = data_time_limit_vip:get(),
            {LimitTime, _RenewTime, State} = player_mask:get(?PLAYER_TIME_LIMIT_VIP, {0, 0, 0}),
            Now = util:unixtime(),
            if
                (Player#player.lv >= Base#base_time_limit_vip.close_lv orelse LimitTime < Now) andalso State /= 1 ->
                    Now = util:unixtime(),
                    NewPlayer1 = Player#player{vip_state = 0},
                    self() ! send_13001,
                    PlayerVip = close_vip(NewPlayer1),
                    get_state(PlayerVip),
                    PlayerVip;
                true -> Player
            end;
        true -> Player
    end.

close_vip(Player) ->
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    NewVipSt = VipSt#st_vip{
        free_lv = 0,
        free_time = 0
    },
    {ok, Bin} = pt_470:write(47003, {2, 0}),
    server_send:send_to_sid(Player#player.sid, Bin),
    lib_dict:put(?PROC_STATUS_VIP, NewVipSt),
    vip:get_player_vip(Player),
    vip_load:dbup_vip_info(NewVipSt),
    vip:calc_player_vip_lv(Player).

%%  State 0未续费 1已续费
get_state(Player) ->
    {LimitTime, RenewTime, State} = player_mask:get(?PLAYER_TIME_LIMIT_VIP, {0, 0, 0}),
    Now = util:unixtime(),
    Base = data_time_limit_vip:get(),
    Data =
        if
            LimitTime > Now andalso State == 0 andalso Player#player.lv < Base#base_time_limit_vip.close_lv ->
                {1, max(0, LimitTime - Now), 1};
            RenewTime > Now andalso State == 0 ->
                {2, max(0, RenewTime - Now), 1};
            true ->
                {-1, 0, 1}
        end,
    ?DEBUG("============write 47006===========  ~n~p~n", [Data]),
    {ok, Bin} = pt_470:write(47006, Data),
    server_send:send_to_sid(Player#player.sid, Bin).

%% 充值触发
charge(Player,_ChargeVal) ->
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    if
        ChargeSt#st_charge.total_gold < 2000 -> Player;
        true ->
            Lan = version:get_lan_config(),
%%     IsDebug = config:is_debug(),
            if
                Lan == bt ->
                    {LimitTime, RenewTime, State} = player_mask:get(?PLAYER_TIME_LIMIT_VIP, {0, 0, 0}),
%%                    Now = util:unixtime(),
                    if
                        State == 1 -> Player;
%%                         RenewTime < Now andalso LimitTime /= 0 -> Player;
                        true ->
                            player_mask:set(?PLAYER_TIME_LIMIT_VIP, {LimitTime, RenewTime, 1}),
                            self() ! {recharge_gift, data_vip_args:get(0, 5)},
                            self() ! send_13001,
                            get_state(Player#player{vip_state = 1}),
                            Player#player{vip_state = 1}
                    end;
                true ->
                    Player
            end
    end.

task_in_finish() ->
%%     task:in_finish(10230).
    State1 = task:in_trigger(10230),
    State2 = task:in_finish(10230),
    State1 orelse State2.

get_attr(Player) ->
    if
        Player#player.vip_state == 1 ->
            Base = data_time_limit_vip:get(),
            attribute_util:make_attribute_by_key_val_list(Base#base_time_limit_vip.att);
        true -> #attribute{}
    end.
