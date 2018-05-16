%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2015 上午10:19
%%%-------------------------------------------------------------------
-module(login_itools).
-author("fancy").
-include("common.hrl").

%%API
-export([login/0,login/1]).

login() ->
    login(["1231234"]).

login([Token]) ->
    Appid = 1016,
    %%Appkey = "ED01EBD63D8744BE84323577A406E466",
    Url = "https://pay.slooti.com/?r=auth/verify",
    SignContent = io_lib:format("appid=~p&sessionid=~s",[Appid,Token]),
    Sign = util:md5(SignContent),
    Query=io_lib:format("~s&appid=~p&sessionid=~s&sign=~s",[Url,Appid,Token,Sign]),
    Query2= unicode:characters_to_list(Query,unicode),
    case httpc:request(Query2) of
        {ok,{_,_,Body}} ->
            ?PRINT("~s~n",[Body]),
            case rfc4627:decode(Body) of
                {ok,{obj,JSONlist},_} ->
                    case lists:keyfind("status",1,JSONlist) of
                        {_,<<"success">>} ->
                            [UserId,_] = string:tokens(Token,"_"),
                            {1,util:to_list(UserId)};
                        _ ->
                            %%?ERR("login 91sdk err code:~p~n",[util:to_integer(Code)]),
                            {0,false}
                    end;
                _ ->
                    {0,false}
            end;
        _ ->
            {0,false}
    end.
