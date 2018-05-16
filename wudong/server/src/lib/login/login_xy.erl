%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2015 上午10:19
%%%-------------------------------------------------------------------
-module(login_xy).
-author("fancy").
-include("common.hrl").

%% API
-export([login/0,login/1]).

login() ->
    login(["1231232","1231234"]).

login([Uid,Token]) ->
    Url = "http://passport.xyzs.com/checkLogin.php",
    AppId = 100005881,
    PostData=io_lib:format("uid=~p&appid=~p&token=~s",[Uid,AppId,Token]),
    PostData2= unicode:characters_to_list(PostData,unicode),
    case httpc:request(post,{Url,[],"application/x-www-form-urlencoded",PostData2},[],[]) of
        {ok,{_,_,Body}} ->
            case rfc4627:decode(Body) of
                {ok,{obj,JSONlist},_} ->
                    ?PRINT("JSONlist:~p~n",[JSONlist]),
                    case lists:keyfind("ret",1,JSONlist) of
                        {_,0} ->
                            1;
                        {_,Code} ->
                            ?ERR("login xy err code:~p~n",[util:to_integer(Code)]),
                            0
                    end;
                _ ->
                    0
            end;
        _ ->
            0
    end.
