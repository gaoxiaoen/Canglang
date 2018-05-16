%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十一月 2015 下午8:16
%%%-------------------------------------------------------------------
-module(sign_in_init).
-author("fengzhenlin").
-include("common.hrl").
-include("sign_in.hrl").
-include("server.hrl").

%% API
-compile(export_all).

init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_SIGN_IN, #st_sign_in{pkey = Player#player.key, time = util:unixtime(), is_change = 1});
        false ->
            case sign_in_load:dbget_sign_in_info(Player) of
                [] ->
                    lib_dict:put(?PROC_STATUS_SIGN_IN, #st_sign_in{pkey = Player#player.key, time = util:unixtime(), is_change = 1});
                [Days, SignIn, AccReward, Time] ->
                    Now = util:unixtime(),
                    {{_, OldMonth, _OldDays}, _} = util:seconds_to_localtime(Time),
                    {{_, NewMonth, _NewDays}, _} = util:seconds_to_localtime(Now),
                    SignInSt =
                        if OldMonth == NewMonth ->
                            #st_sign_in{pkey = Player#player.key,
                                days = Days,
                                sign_in = util:bitstring_to_term(SignIn),
                                acc_reward = util:bitstring_to_term(AccReward),
                                time = Time};
                            true ->
                                #st_sign_in{pkey = Player#player.key, time = Now, is_change = 1}
                        end,
                    lib_dict:put(?PROC_STATUS_SIGN_IN, SignInSt)
            end
    end,
    Player.

%%定时更新
timer_update() ->
    St = lib_dict:get(?PROC_STATUS_SIGN_IN),
    if St#st_sign_in.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_SIGN_IN, St#st_sign_in{is_change = 0}),
        sign_in_load:dbup_sign_in(St);
        true -> ok
    end.
%%离线
logout() ->
    St = lib_dict:get(?PROC_STATUS_SIGN_IN),
    if St#st_sign_in.is_change == 1 ->
        sign_in_load:dbup_sign_in(St);
        true -> ok
    end.

midnight_refresh(Now) ->
    St = lib_dict:get(?PROC_STATUS_SIGN_IN),
    {{_, OldMonth, _OldDays}, _} = util:seconds_to_localtime(St#st_sign_in.time),
    {{_, NewMonth, _NewDays}, _} = util:seconds_to_localtime(Now),
    if OldMonth == NewMonth -> ok;
        true ->
            NewSt = #st_sign_in{pkey = St#st_sign_in.pkey, time = Now, is_change = 1},
            lib_dict:put(?PROC_STATUS_SIGN_IN, NewSt)
    end.

