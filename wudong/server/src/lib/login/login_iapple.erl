%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2015 上午10:19
%%%-------------------------------------------------------------------
-module(login_iapple).
-author("fancy").
-include("common.hrl").

%% API
-export([login/0,login/1]).

login() ->
    login(["1231232","1231234"]).

login([UserId,Session]) ->
    Url = "http://ucenter.iiapple.com/foreign/oauth/verification.php",
    Gamekey = "057eadc5378ccbaf658eef924c76abee",
    SercetKey = "34ae14f14a119ad215ecbfb7d98623a9",
    SignStr = io_lib:format("game_id=~s&session=~s&user_id=~p",[Gamekey,Session,UserId]),
    SignStr2 = io_lib:format("~s~s",[util:md5(SignStr),SercetKey]),
    Sign = util:md5(SignStr2),
    Query=io_lib:format("~s?user_id=~p&session=~s&game_id=~s&_sign=~s",[Url,UserId,Session,Gamekey,Sign]),
    Query2= unicode:characters_to_list(Query,unicode),
    case httpc:request(Query2) of
        {ok,{_,_,Body}} ->
            case rfc4627:decode(Body) of
                {ok,{obj,JSONlist},_} ->
                    ?PRINT("JSONlist:~p~n",[JSONlist]),
                    case lists:keyfind("status",1,JSONlist) of
                        {_,1} ->
                            1;
                        {_,Code} ->
                            ?ERR("login iapple err code:~p~n",[util:to_integer(Code)]),
                            0
                    end;
                _ ->
                    0
            end;
        _ ->
            0
    end.
