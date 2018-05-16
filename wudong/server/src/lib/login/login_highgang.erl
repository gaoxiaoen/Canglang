%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2015 上午10:19
%%%-------------------------------------------------------------------
-module(login_highgang).
-author("fancy").
-include("common.hrl").

%%API
-export([login/0,login/1]).

login() ->
    login(["1231234"]).

login([Token]) ->
    Url = "http://oauth.highgang.com/oauth/token",
    Time = util:unixtime(),
    App_secret = "a6baed273f35cecf5753e0abe677257c",
    App_key = 100000001,
    SignString = io_lib:format("authorize_code=~s&app_key=~p&hg_sign=~s&time=~p",[Token,App_key,App_secret,Time]),
    Sign = util:md5(SignString),
    PostData=io_lib:format("authorize_code=~s&app_key=~p&time=~p&sign=~s",[Token,App_key,Time,Sign]),
    PostData2= unicode:characters_to_list(PostData,unicode),
    case httpc:request(post,{Url,[],"application/x-www-form-urlencoded",PostData2},[],[]) of
        {ok,{_,_,Body}} ->
            %%?PRINT("~s~n",[Body]),
            case rfc4627:decode(Body) of
                {ok,{obj,JSONlist},_} ->
                    case lists:keyfind("ret",1,JSONlist) of
                        {_,<<"0">>} ->
                            {0,"0",""};
                        {_,<<"1">>} ->
                            case lists:keyfind("content",1,JSONlist) of
                                {_,ContentString} ->
                                    case rfc4627:decode(util:to_list(ContentString)) of
                                        {ok,{obj,ContentJSON},_} ->
                                            %%?PRINT("ContentJSON:~p~n",[ContentJSON]),
                                            {_,AccessToken} = lists:keyfind("access_token",1,ContentJSON),
                                            AccessToken2 = util:to_list(AccessToken),
                                            {_,[{obj,DataList}]} = lists:keyfind("data",1,ContentJSON),
                                            {_,LoginId} = lists:keyfind("login_id",1,DataList),
                                            LoginId2 = util:to_list(LoginId),
                                            {1,LoginId2,AccessToken2};
                                        _->
                                            {0,"0",""}
                                    end;
                                _ ->
                                    {0,"0",""}
                            end;
                        _ -> {0,"0",""}
                    end;
                _ ->
                    {0,"0",""}
            end;
        _ ->
            {0,"0",""}
    end.
