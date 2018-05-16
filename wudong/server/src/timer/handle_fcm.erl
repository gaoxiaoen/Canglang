%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2018 17:23
%%%-------------------------------------------------------------------
-module(handle_fcm).
-author("hxming").


-compile(export_all).
-include("common.hrl").

%%=========================================================================
%% 一些定义
%% TODO: 定义模块状态。
%%=========================================================================

%%=========================================================================
%% 回调接口
%% TODO: 实现回调接口。
%%=========================================================================

%% -----------------------------------------------------------------
%% @desc     启动回调函数，用来初始化资源。
%% @param
%% @return  {ok, State}     : 启动正常
%%           {ignore, Reason}: 启动异常，本模块将被忽略不执行
%%           {stop, Reason}  : 启动异常，需要停止所有后台定时模块
%% -----------------------------------------------------------------
init() ->
    {ok, ?MODULE}.

%% -----------------------------------------------------------------
%% @desc     服务回调函数，用来执行业务操作。
%% @param    State          : 初始化或者上一次服务返回的状态
%% @return  {ok, NewState}  : 服务正常，返回新状态
%%           {ignore, Reason}: 服务异常，本模块以后将被忽略不执行，模块的terminate函数将被回调
%%           {stop, Reason}  : 服务异常，需要停止所有后台定时模块，所有模块的terminate函数将被回调
%% -----------------------------------------------------------------
handle(State, _NowTime) ->
    case player_fcm:is_open_lan() of
        false -> skip;
        true ->
            check_fcm_state()
    end,
    {ok, State}.

%% -----------------------------------------------------------------
%% @desc     停止回调函数，用来销毁资源。
%% @param    Reason        : 停止原因
%% @param    State         : 初始化或者上一次服务返回的状态
%% @return   ok
%% -----------------------------------------------------------------
terminate(Reason, State) ->
    ?DEBUG("================Terming..., Reason=[~w], Statee = [~w]", [Reason, State]),
    ok.


%%检查防沉迷配置,如果没有则向中央服获取
check_fcm_state() ->
    case config:get_fcm_config() of
        [] ->
            http_set_fcm();
        _ -> skip
    end.

http_set_fcm() ->
    case http_get() of
        [] -> skip;
        Config ->
            set_fcm(util:term_to_string(Config))
    end.

http_get() ->
    ApiUrl =
%%        "http://localhost",
    config:get_api_url(),
    Url = lists:concat([ApiUrl, "/identity.php"]),
    Now = util:unixtime(),
    Key = "identity_auth",
    Sign = util:md5(io_lib:format("~p~s", [Now, Key])),
    Sn = config:get_server_num(),
    U0 = io_lib:format("?act=fcm_state&sn=~p&time=~p&key=~s", [Sn, Now, Sign]),
    U = lists:concat([Url, U0]),
    Ret = httpc:request(get, {U, []}, [{timeout, 2000}], []),
    case Ret of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, Data}, _} ->
                    ?DEBUG("Data ~p~n", [Data]),
                    IsOpen =
                        case lists:keyfind("is_addiction", 1, Data) of
                            false -> 1;
                            {_, Val} -> util:to_integer(Val)
                        end,
                    Notice =
                        case lists:keyfind("addiction_notify", 1, Data) of
                            false -> 1;
                            {_, Val1} -> util:to_integer(Val1)
                        end,
                    [IsOpen, Notice];
                _ -> []
            end;
        _ ->
            []
    end.

set_fcm(List) ->
    Code = "-module(dyc_fcm).
    -export([fcm_state/0]).
       fcm_state() ->
        " ++ List ++ ".
    ",
    {Mod2, Code2} = dynamic_compile:from_string(Code),
    code:load_binary(Mod2, "dyc_fcm.erl", Code2).

%%开启防沉迷
open_fcm() ->
    set_fcm("[1,0]").

%%关闭防沉迷
close_fcm() ->
    set_fcm("[0,0]").
