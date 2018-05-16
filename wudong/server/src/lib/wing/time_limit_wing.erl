%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十月 2017 13:38
%%%-------------------------------------------------------------------
-module(time_limit_wing).
-author("Administrator").
-include("wing.hrl").
-include("common.hrl").
-include("server.hrl").
-include("player_mask.hrl").

%% API
-export([
    open_time_limit_wing/1
    , close_time_limit_wing/1
    , renewal/1
    , get_state/1
    , init/1
]).

init(Player) ->
    {LimitTime, State} = player_mask:get(?PLAYER_TIME_LIMIT_WING, {0, 0}),
    Now = util:unixtime(),
    OpenLv = data_menu_open:get(2),
    if
        LimitTime > Now andalso Player#player.lv < OpenLv andalso State == 0 ->
            Player;
        true ->
            StWing = lib_dict:get(?PROC_STATUS_WING),
%%            Base = data_time_limit_wing:get(),
%%         close_time_limit_wing(Player)
            if
                Player#player.lv < OpenLv-5 andalso StWing#st_wing.stage /= 0 andalso State /= 1 ->
                    NewStWing = #st_wing{pkey = Player#player.key,is_change=1},
                    lib_dict:put(?PROC_STATUS_WING, NewStWing),
                    Now = util:unixtime(),
                    get_state(Player),
                    NewPlayer = activate_wing(Player),
                    NewPlayer;
                true -> Player
            end
    end.



%%  {LimitTime,State} = player_mask:get(?PLAYER_TIME_LIMIT_WING, {0,0}),
%%  State 0未续费 1已续费
get_state(Player) ->
    {LimitTime, State} = player_mask:get(?PLAYER_TIME_LIMIT_WING, {0, 0}),
    Now = util:unixtime(),
    Base = data_time_limit_wing:get(),
    OpenLv = data_menu_open:get(2),
    Data =
        if
            LimitTime > Now andalso Player#player.lv < OpenLv andalso State == 0 ->
                {1, max(0, LimitTime - Now), Base#base_time_limit_wing.cost};
            true ->
                {-1, 0, Base#base_time_limit_wing.cost}
        end,
    ?DEBUG("============write 36028===========~n"),
    {ok, Bin} = pt_360:write(36028, Data),
    server_send:send_to_sid(Player#player.sid, Bin).

%% 开启限时翅膀
open_time_limit_wing(Player) ->
    ?DEBUG("open_time_limit_wing ~n"),
    Lan = version:get_lan_config(),
%%     IsDebug = config:is_debug(),
    if
        Lan == fanti ->
            WingSt = lib_dict:get(?PROC_STATUS_WING),
            Base = data_time_limit_wing:get(),
            if
                WingSt#st_wing.stage > 0 -> Player;
                true ->
                    {LimitTime, _} = player_mask:get(?PLAYER_TIME_LIMIT_WING, {0, 0}),
                    if
                        Player#player.lv > Base#base_time_limit_wing.close_lv ->
                            Player;
                        LimitTime /= 0 ->
                            Player;
                        true ->
                            _StWing = lib_dict:get(?PROC_STATUS_WING),
                            Q = task_in_finish(),
                            ?DEBUG("QQ ~p~n", [Q]),
                            ?DEBUG("_StWing#st_wing.stage == 0 ~p~n", [_StWing#st_wing.stage]),
                            case _StWing#st_wing.stage == 0 andalso task_in_finish() of
                                true ->
                                    NewStWing = new_wing(Player#player.key),
                                    lib_dict:put(?PROC_STATUS_WING, NewStWing),
                                    player_util:func_open_tips(Player, 2, NewStWing#st_wing.current_image_id),
                                    Now = util:unixtime(),
                                    player_mask:set(?PLAYER_TIME_LIMIT_WING, {Now + Base#base_time_limit_wing.time, 0}),
                                    get_state(Player),
                                    NewPlayer = activate_wing(Player),
                                    NewPlayer;
                                false ->
                                    Player
                            end
                    end
            end;
        true ->
            Player
    end.

%% 关闭限时翅膀
close_time_limit_wing(Player) ->
    Lan = version:get_lan_config(),
%%     IsDebug = config:is_debug(),
    if
        Lan == fanti ->
            Base = data_time_limit_wing:get(),
            WingOpenLv = data_menu_open:get(2),
            StWing = lib_dict:get(?PROC_STATUS_WING),
            {_LimitWingTime, State} = player_mask:get(?PLAYER_TIME_LIMIT_WING, {0, 0}),
            if
                Player#player.lv >= Base#base_time_limit_wing.close_lv andalso Player#player.lv < WingOpenLv andalso StWing#st_wing.stage /= 0 andalso State /= 1 ->
                    ?DEBUG("***************************** ~n"),
                    NewStWing = #st_wing{pkey = Player#player.key, is_change = 1},
                    lib_dict:put(?PROC_STATUS_WING, NewStWing),
%%             player_util:func_open_tips(Player, 2, NewStWing#st_wing.current_image_id),
                    Now = util:unixtime(),
                    player_mask:set(?PLAYER_TIME_LIMIT_WING, {Now + Base#base_time_limit_wing.time, 0}),
                    get_state(Player),
                    ?DEBUG("***************************** ~n"),
                    NewPlayer = activate_wing(Player),
                    NewPlayer;
                true -> Player
            end;
        true -> Player
    end.

%% 翅膀续费
renewal(Player) ->
    Lan = version:get_lan_config(),
%%     IsDebug = config:is_debug(),
    if
        Lan == fanti ->
            Base = data_time_limit_wing:get(),
            IsEnough = money:is_enough(Player, Base#base_time_limit_wing.cost, gold),
            {LimitWingTime, State} = player_mask:get(?PLAYER_TIME_LIMIT_WING, {0, 0}),
            _StWing = lib_dict:get(?PROC_STATUS_WING),
            Now = util:unixtime(),
            if
                not IsEnough -> {5, Player};
                true ->
                    WingOpenLv = data_menu_open:get(2),
                    if
                        Player#player.lv >= WingOpenLv -> {47, Player};
                        LimitWingTime < Now -> {48, Player};
                        true ->
                            _StWing = lib_dict:get(?PROC_STATUS_WING),
                            if _StWing#st_wing.stage == 0 orelse State == 0 ->
                                NewPlayer1 = money:add_no_bind_gold(Player, -Base#base_time_limit_wing.cost, 308, 0, 0),
                                NewStWing = new_wing(Player#player.key),
                                lib_dict:put(?PROC_STATUS_WING, NewStWing),
                                player_util:func_open_tips(Player, 2, NewStWing#st_wing.current_image_id),
                                NewPlayer = activate_wing(NewPlayer1),
                                player_mask:set(?PLAYER_TIME_LIMIT_WING, {LimitWingTime, 1}),
                                {1, NewPlayer};
                                true ->
                                    {47, Player}
                            end
                    end
            end;
        true -> {0, Player}
    end.

new_wing(Key) ->
    Base1 = data_wing_stage:get(1),
    Base2 = data_wing_stage:get(2),
    Base3 = data_wing_stage:get(3),
    #st_wing{
        pkey = Key,
        stage = 3,
        current_image_id = Base3#base_wing_stage.image,
        own_special_image = [{Base1#base_wing_stage.image, 0}, {Base2#base_wing_stage.image, 0}, {Base3#base_wing_stage.image, 0}],
        is_change = 1
    }.

task_in_finish() ->
%%     task:in_finish(10230).
    State1 =
        case {10230, 2} of
            [] -> true;
            {0, _} -> true;
            {Tid, 3} ->
                task:in_finish(Tid);
            {Tid, 2} ->
                task:in_trigger(Tid);
            {Tid, 1} ->
                task:in_can_trigger(Tid);
            _ -> false
        end,
    State2 =
        case {10230, 3} of
            [] -> true;
            {0, _} -> true;
            {Tid2, 3} ->
                task:in_finish(Tid2);
            {Tid2, 2} ->
                task:in_trigger(Tid2);
            {Tid2, 1} ->
                task:in_can_trigger(Tid2);
            _ -> false
        end,
    State1 orelse State2.


activate_wing(Player) ->
    StWing = lib_dict:get(?PROC_STATUS_WING),
    NewStWing = wing_attr:calc_wing_attr(StWing),
    lib_dict:put(?PROC_STATUS_WING, NewStWing),
    NewPlayer = player_util:count_player_attribute(Player#player{wing_id = NewStWing#st_wing.current_image_id}, true),
    scene_agent_dispatch:wing_update(NewPlayer),
    NewPlayer.
