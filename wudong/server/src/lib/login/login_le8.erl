%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2015 上午10:19
%%%-------------------------------------------------------------------
-module(login_le8).
-author("fancy").
-include("common.hrl").

%%API
-export([login/0,login/1]).

login() ->
    login(["1231234"]).

login([Token]) ->
    Url = "http://121.43.227.16:8080/login.php?f=le8",
    %%Url = "http://192.168.1.222:8000/login.php?f=le8",
    PostData=io_lib:format("token=~s",[Token]),
    PostData2= unicode:characters_to_list(PostData,unicode),
    case httpc:request(post,{Url,[],"application/x-www-form-urlencoded",PostData2},[],[]) of
        {ok,{_,_,Body}} ->
            case rfc4627:decode(Body) of
                {ok,{obj,JSONlist},_} ->
                    case lists:keyfind("ret",1,JSONlist) of
                        {_,<<"success">>} ->
                            1;
                        _ ->
                            %%?ERR("login 91sdk err code:~p~n",[util:to_integer(Code)]),
                            false
                    end;
                _ ->
                    false
            end;
        _ ->
            false
    end.
