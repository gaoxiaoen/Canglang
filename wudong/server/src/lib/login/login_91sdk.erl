%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2015 上午10:19
%%%-------------------------------------------------------------------
-module(login_91sdk).
-author("fancy").
-include("common.hrl").

%% API
-export([login/0,login/1]).

login() ->
    login(["1231232","1231234"]).

login([Uin,SessionId]) ->
    Url = "http://service.sj.91.com/usercenter/AP.aspx",
    AppId = 116700,
    AppKey = "b73fe9654fc0313008bcda3b96a7b1542d3972db78fd7034",
    SignStr =  io_lib:format("~p~p~p~s~s",[AppId,4,Uin,SessionId,AppKey]),
    Sign = util:md5(SignStr),
    PostData=io_lib:format("AppId=~p&Act=4&Uin=~p&Sign=~s&SessionID=~s",[AppId,Uin,Sign,SessionId]),
    PostData2= unicode:characters_to_list(PostData,unicode),
    case httpc:request(post,{Url,[],"application/x-www-form-urlencoded",PostData2},[],[]) of
        {ok,{_,_,Body}} ->
            case rfc4627:decode(Body) of
                {ok,{obj,JSONlist},_} ->
                    case lists:keyfind("ErrorCode",1,JSONlist) of
                        {_,<<"1">>} ->
                            1;
                        {_,_Code} ->
                            %%?ERR("login 91sdk err code:~p~n",[util:to_integer(Code)]),
                            0
                    end;
                _ ->
                    0
            end;
        _ ->
            0
    end.
