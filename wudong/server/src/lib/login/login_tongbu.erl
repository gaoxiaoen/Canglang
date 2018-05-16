%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2015 上午10:19
%%%-------------------------------------------------------------------
-module(login_tongbu).
-author("fancy").
-include("common.hrl").

%% API
-export([login/0,login/1]).

login() ->
    login(["1231234"]).

login([Token]) ->
    Url = "http://tgi.tongbu.com/api/LoginCheck.ashx",
    AppId = 150362,
    Query=io_lib:format("~s?session=~s&appid=~p",[Url,Token,AppId]),
    Query2= unicode:characters_to_list(Query,unicode),
    case httpc:request(Query2) of
        {ok,{_,_,Body}} ->
            case util:to_integer(Body) of
                0 ->
                    {0,false} ;
                UserId ->
                    {1,util:to_list(UserId)}
            end;
        _ ->
            {0,false}
    end.
