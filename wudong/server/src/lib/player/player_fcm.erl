%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 四月 2018 15:46
%%%-------------------------------------------------------------------
-module(player_fcm).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("daily.hrl").

%% API
-export([
    init/1
    , logout/0
    , refresh_online/3
    , get_fcm/1
    , get_identity_state/1
    , auth_identity/3
]).

-export([get_identity/1, set_identity/2, check_identity_card/1, is_open_lan/0]).

-export([gm_set_logout/2, gm_set_online/2, refresh_fcm/0, refresh_fcm_close/0]).

-record(st_fcm, {pkey = 0, acc_online = 0, acc_logout = 0, identity = 0, state = 0}).


-define(FCM_TIME_WARNING, ?ONE_HOUR_SECONDS * 3).
-define(FCM_TIME_START, ?ONE_HOUR_SECONDS * 5).

-define(IDENTITY_UNAUTH, 0).
-define(IDENTITY_ADULT, 1).
-define(IDENTITY_CHILD, 2).

-define(FCM_STATE_UN, 0).
-define(FCM_STATE_WARNING, 1).
-define(FCM_STATE_START, 2).

is_open_lan() ->
    Lan = version:get_lan_config(),
    lists:member(Lan, [chn, bt]).

%%是否防沉迷
is_open_fcm() ->
    case is_open_lan() of
        true ->
            case config:get_fcm_config() of
                [] -> false;
                [IsFcm | _] -> IsFcm > 0
            end;
        false -> false
    end.


%%初始化
init(Player) ->
    StFcm = load_player_fcm(Player),
    lib_dict:put(?PROC_STATUS_FCM, StFcm),
    Player.

%%loaddb
load_player_fcm(Player) ->
    Sql = io_lib:format("select acc_online,acc_logout,identity from player_fcm where pkey = ~p", [Player#player.key]),
    case db:get_row(Sql) of
        [] ->
            #st_fcm{pkey = Player#player.key};
        [AccOnline, OldAccLogout, Identity] ->
            NewIdentity = ?IF_ELSE(Identity == 0, get_identity(Player#player.accname), Identity),
            if NewIdentity == 1 ->
                #st_fcm{pkey = Player#player.key, identity = NewIdentity};
                true ->
                    Now = util:unixtime(),
                    AccLogout = Now - Player#player.logout_time + OldAccLogout,
                    {NewAccOnline, NewAccLogout} =
                        if AccLogout > ?FCM_TIME_START -> {0, 0};
                            true -> {AccOnline, ?IF_ELSE(AccOnline > ?FCM_TIME_START, AccLogout, OldAccLogout)}
                        end,
                    State = check_fcm_state(NewAccOnline),
                    #st_fcm{pkey = Player#player.key, acc_online = NewAccOnline, acc_logout = NewAccLogout, identity = NewIdentity, state = State}
            end
    end.

get_identity(AccId) ->
    ApiUrl =
%%        "http://localhost",
    config:get_api_url(),
    Url = lists:concat([ApiUrl, "/identity.php"]),
    Now = util:unixtime(),
    Key = "identity_auth",
    Sign = util:md5(io_lib:format("~p~s", [Now, Key])),
    U0 = io_lib:format("?act=get&acc_id=~s&time=~p&key=~s", [AccId, Now, Sign]),
    U = lists:concat([Url, U0]),
    Ret = httpc:request(get, {U, []}, [{timeout, 2000}], []),
    case Ret of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, Data}, _} ->
                    case lists:keyfind("status", 1, Data) of
                        {_, Identity} ->
                            util:to_integer(Identity);
                        _ -> 0
                    end;
                _ -> 0
            end;
        _ ->
            0
    end.

set_identity(AccId, Identity) ->
    ApiUrl =
%%        "http://localhost",
    config:get_api_url(),
    Url = lists:concat([ApiUrl, "/identity.php"]),
    Now = util:unixtime(),
    Key = "identity_auth",
    Sign = util:md5(io_lib:format("~p~s", [Now, Key])),
    U0 = io_lib:format("?act=set&acc_id=~s&identity=~p&time=~p&key=~s", [AccId, Identity, Now, Sign]),
    U = lists:concat([Url, U0]),
    httpc:request(get, {U, []}, [{timeout, 2000}], []),
    ok.

%%获取信息,没有则加载
get_st_fcm(Player) ->
    case get(?PROC_STATUS_FCM) of
        undefined ->
            StFcm = load_player_fcm(Player),
            lib_dict:put(?PROC_STATUS_FCM, StFcm),
            StFcm;
        StFcm -> StFcm
    end.

%%离线更新
logout() ->
    case get(?PROC_STATUS_FCM) of
        undefined -> skip;
        StFcm ->
            replace(StFcm)
    end.

replace(StFcm) ->
    Sql = io_lib:format("replace into player_fcm set pkey = ~p,acc_online=~p,acc_logout =~p,identity = ~p",
        [StFcm#st_fcm.pkey, StFcm#st_fcm.acc_online, StFcm#st_fcm.acc_logout, StFcm#st_fcm.identity]),
    db:execute(Sql).


%%检查每日在线时间
%%处理防沉迷状态
refresh_online(Player, _Now, Seconds) ->
    case config:get_fcm_config() of
        [] -> skip;
        [IsFcm, Notice | _] ->
            StFcm = get_st_fcm(Player),
            if IsFcm == 0 -> skip;
                StFcm#st_fcm.identity == ?IDENTITY_ADULT -> skip;
                true ->
                    AccOnline = StFcm#st_fcm.acc_online + 5,
                    State = check_fcm_state(AccOnline),
                    NewStFcm = StFcm#st_fcm{acc_online = AccOnline, state = State},
                    lib_dict:put(?PROC_STATUS_FCM, NewStFcm),
                    warning(Notice, Player, StFcm#st_fcm.acc_online, AccOnline, Seconds)
            end
    end.

%%通知客户端
warning(1, Player, _OldTime, NewTime, _Seconds) ->
    if NewTime > ?FCM_TIME_START ->
        case daily:get_count(?DAILY_FCM) > 0 of
            true -> skip;
            false ->
                daily:increment(?DAILY_FCM, 1),
                mail:sys_send_mail([Player#player.key], ?T("防沉迷信息"), ?T("亲爱的玩家,您游戏时间已累计超过5小时,请合理安排游戏时间哦!"))

        end;
        true ->
            ok
    end;
warning(_, Player, OldTime, NewTime, Seconds) ->
    Type =
        if OldTime < ?ONE_HOUR_SECONDS andalso NewTime >= ?ONE_HOUR_SECONDS -> 1;
            OldTime < ?ONE_HOUR_SECONDS * 2 andalso NewTime >= ?ONE_HOUR_SECONDS * 2 -> 2;
            OldTime < ?ONE_HOUR_SECONDS * 3 andalso NewTime >= ?ONE_HOUR_SECONDS * 3 -> 3;
            OldTime < ?ONE_HOUR_SECONDS * 3 + 1800 andalso NewTime >= ?ONE_HOUR_SECONDS * 3 + 1800 -> 4;
            OldTime < ?ONE_HOUR_SECONDS * 4 andalso NewTime >= ?ONE_HOUR_SECONDS * 4 -> 4;
            OldTime < ?ONE_HOUR_SECONDS * 4 + 1800 andalso NewTime >= ?ONE_HOUR_SECONDS * 4 + 1800 -> 4;
            OldTime < ?ONE_HOUR_SECONDS * 5 andalso NewTime >= ?ONE_HOUR_SECONDS * 5 -> 4;
            OldTime < ?ONE_HOUR_SECONDS * 5 + 1800 andalso NewTime >= ?ONE_HOUR_SECONDS * 5 + 1800 -> 4;
            NewTime >= ?FCM_TIME_START ->
                case Seconds rem 900 of
                    0 -> 5;
                    _ -> ok
                end;
            true ->
                ok
        end,
    case Type of
        ok -> skip;
        _ ->
            {ok, Bin} = pt_130:write(13047, {Type}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok.

check_fcm_state(DailyOnlineTime) ->
    OnlineHour = DailyOnlineTime / 3600,
    if OnlineHour < ?FCM_TIME_WARNING -> ?FCM_STATE_UN;
        OnlineHour > ?FCM_TIME_START -> ?FCM_STATE_START;
        true -> ?FCM_STATE_WARNING
    end.

%%防沉迷收益
get_fcm(Player) ->
    case is_open_fcm() of
        false -> 1;
        true ->
            StFcm = get_st_fcm(Player),
            case StFcm#st_fcm.state of
                ?FCM_STATE_WARNING -> 0.5;
                ?FCM_STATE_START -> 0;
                _ -> 1
            end
    end.

%%获取身份认证状态
get_identity_state(Player) ->
    case is_open_fcm() of
        false -> skip;
        true ->
            StFcm = get_st_fcm(Player),
            case StFcm#st_fcm.identity == ?FCM_STATE_UN of
                false -> skip;
                true ->
                    {ok, Bin} = pt_130:write(13045, {?FCM_STATE_UN}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end
    end,
    ok.

refresh_fcm() ->
    F = fun(Online) ->
        Online#ets_online.pid ! identity_state
        end,
    lists:foreach(F, ets:tab2list(?ETS_ONLINE)),
    ok.


refresh_fcm_close() ->
    {ok, Bin} = pt_130:write(13045, {1}),
    server_send:send_to_all(Bin).

%%身份认证
auth_identity(Player, CardId, Name) ->
    StFcm = get_st_fcm(Player),
    if StFcm#st_fcm.identity /= 0 -> 18;
        true ->
            case check_junhai(Player, CardId, Name) of
                false ->
                    19;
                true ->
                    case check_identity_card(CardId) of
                        false -> 19;
                        ?IDENTITY_ADULT ->
                            NewStFcm = StFcm#st_fcm{identity = ?IDENTITY_ADULT, acc_online = 0, acc_logout = 0, state = 0},
                            lib_dict:put(?PROC_STATUS_FCM, NewStFcm),
                            replace(StFcm),
                            set_identity(Player#player.accname, ?IDENTITY_ADULT),
                            1;
                        ?IDENTITY_CHILD ->
                            NewStFcm = StFcm#st_fcm{identity = ?IDENTITY_CHILD},
                            lib_dict:put(?PROC_STATUS_FCM, NewStFcm),
                            replace(StFcm),
                            set_identity(Player#player.accname, ?IDENTITY_CHILD),
                            1
                    end
            end
    end.

%%身份证校验 ok 成年,false未成年,fail无效证件
check_identity_card(CardId) ->
    Len = string:len(CardId),
    if Len =:= 18 -> identity_card18(CardId);
        Len =:= 15 -> identity_card15(CardId);
        true ->
            false
    end.

check_junhai(Player, CardId, Name) ->
    GameId = Player#player.game_id,
    ChannelId = Player#player.pf,
    GameChannelId = Player#player.game_channel_id,
    UserId = Player#player.accname,
    AreaCode = "CN",
    ApiUrl =
%%        "http://localhost",
    config:get_api_url(),
    Url = lists:concat([ApiUrl, "/identity.php"]),
    U0 = io_lib:format("?act=check&game_id=~p&channel_id=~p&game_channel_id=~p&user_id=~s&area_code=~s&id_card=~s&real_name=~s", [GameId, ChannelId, GameChannelId, UserId, AreaCode, CardId, Name]),
    U = lists:concat([Url, U0]),
    Ret = httpc:request(get, {U, []}, [{timeout, 2000}], []),
    case Ret of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, Data}, _} ->
                    case lists:keyfind("ret", 1, Data) of
                        {_, Identity} ->
                            case util:to_integer(Identity) of
                                1 -> true;
                                _ -> false
                            end;
                        _ -> false
                    end;
                _ -> false
            end;
        _ ->
            false
    end.


identity_card15(CardId) ->
    {Bir_day, []} = string:to_integer(string:sub_string(CardId, 7, 12)),
    {{Year, Month, Day}, {_Hour, _Min, _Sec}} = calendar:local_time(),
    if ((Year rem 100 + 100) * 10000 + Month * 100 + Day - Bir_day) div 10000 >= 18 -> ?IDENTITY_ADULT;
        true -> ?IDENTITY_CHILD
    end.

identity_card18(CardId) ->
    Int_v1 = util:to_integer(string:sub_string(CardId, 1, 1)) * 7,
    Int_v2 = util:to_integer(string:sub_string(CardId, 2, 2)) * 9,
    Int_v3 = util:to_integer(string:sub_string(CardId, 3, 3)) * 10,
    Int_v4 = util:to_integer(string:sub_string(CardId, 4, 4)) * 5,
    Int_v5 = util:to_integer(string:sub_string(CardId, 5, 5)) * 8,
    Int_v6 = util:to_integer(string:sub_string(CardId, 6, 6)) * 4,
    Int_v7 = util:to_integer(string:sub_string(CardId, 7, 7)) * 2,
    Int_v8 = util:to_integer(string:sub_string(CardId, 8, 8)) * 1,
    Int_v9 = util:to_integer(string:sub_string(CardId, 9, 9)) * 6,
    Int_v10 = util:to_integer(string:sub_string(CardId, 10, 10)) * 3,
    Int_v11 = util:to_integer(string:sub_string(CardId, 11, 11)) * 7,
    Int_v12 = util:to_integer(string:sub_string(CardId, 12, 12)) * 9,
    Int_v13 = util:to_integer(string:sub_string(CardId, 13, 13)) * 10,
    Int_v14 = util:to_integer(string:sub_string(CardId, 14, 14)) * 5,
    Int_v15 = util:to_integer(string:sub_string(CardId, 15, 15)) * 8,
    Int_v16 = util:to_integer(string:sub_string(CardId, 16, 16)) * 4,
    Int_v17 = util:to_integer(string:sub_string(CardId, 17, 17)) * 2,

    case (Int_v1 + Int_v2 + Int_v3 + Int_v4 + Int_v5 + Int_v6 + Int_v7 + Int_v8 + Int_v9 + Int_v10 + Int_v11 + Int_v12 + Int_v13 + Int_v14 + Int_v15 + Int_v16 + Int_v17) rem 11 of
        0 -> Str_v18 = "1";
        1 -> Str_v18 = "0";
        2 -> Str_v18 = "X";
        3 -> Str_v18 = "9";
        4 -> Str_v18 = "8";
        5 -> Str_v18 = "7";
        6 -> Str_v18 = "6";
        7 -> Str_v18 = "5";
        8 -> Str_v18 = "4";
        9 -> Str_v18 = "3";
        10 -> Str_v18 = "2"
    end,

    Str_tmp = string:to_upper(string:sub_string(CardId, 18, 18)),
    if Str_tmp =:= Str_v18 ->
        {{Year, Month, Day}, {_Hour, _Min, _Sec}} = calendar:local_time(),
        Bir_day = util:to_integer(string:sub_string(CardId, 7, 14)),
        if (Year * 10000 + Month * 100 + Day - Bir_day) div 10000 >= 18 -> ?IDENTITY_ADULT;
            true -> ?IDENTITY_CHILD
        end;
        true -> false
    end.

gm_set_online(Player, Seconds) ->
    StFcm = get_st_fcm(Player),
    State = check_fcm_state(Seconds),
    NewStFcm = StFcm#st_fcm{acc_online = Seconds, state = State, acc_logout = 0},
    lib_dict:put(?PROC_STATUS_FCM, NewStFcm).

gm_set_logout(Player, Seconds) ->
    StFcm = get_st_fcm(Player),
    NewStFcm = StFcm#st_fcm{acc_logout = Seconds},
    lib_dict:put(?PROC_STATUS_FCM, NewStFcm).

