%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2015 上午10:19
%%%-------------------------------------------------------------------
-module(login_junhai).
-author("fancy").
-include("common.hrl").

%% API
-export([login/0,login/1,login2/1]).

login() ->
    login(["1231232","1231234"]).

login([Uid,SessionId,ChannelId,GameId]) ->
    Url = "http://agent.ijunhai.com/login/token",
    PostData=io_lib:format("channel_id=~s&game_id=~p&uid=~s&session_id=~s",[ChannelId,GameId,Uid,SessionId]),
    PostData2= unicode:characters_to_list(PostData,unicode),
    %%?ERR(PostData2),
    case httpc:request(post,{Url,[],"application/x-www-form-urlencoded",PostData2},[],[]) of
        {ok,{_,_,Body}} ->
            %%?ERR(Body),
            case rfc4627:decode(Body) of
                {ok,{obj,JSONlist},_} ->
                    case lists:keyfind("ret",1,JSONlist) of
                        {_,<<"0">>} ->
                            [0,"0",Body];
                        {_,<<"1">>} ->
                            case lists:keyfind("content",1,JSONlist) of
                                {_,{obj,ContentJSON}} ->
                                    {_,UserId} = lists:keyfind("user_id",1,ContentJSON),
                                    UserId2 = util:to_list(UserId) ,
                                    case UserId2 of
                                        [] ->
                                            ?ERR("userid:~p/uid:~p/session_id:~p/channelid:~p/~n",[UserId,Uid,SessionId,ChannelId]),
                                            [0,"0",Body];
                                        _ ->
                                            %%?ERR("Body:~p~n",[Body]),
                                            [1,UserId2,Body]
                                    end;
                                _ ->
                                    [0,"0",Body]
                            end;
                        _ -> [0,"0",Body]
                    end;
                _ ->
                    [0,"0",Body]
            end;
        _ ->
            [0,"0",[]]
    end.

get_sign(App_key) ->
    case App_key of
        100000045 -> "24bcf52f69d45d8db29ef2a3630637e2";
        100000072 -> "c87ce17a4ee63c76771a36e9e8b58398";
        _ -> "000000"
    end.

login2([App_key,Authorize_code,_ChannelId]) ->
    Url = "http://oauth.ijunhai.com/oauth/token",
    Jh_sign = get_sign(App_key),
    Time = util:unixtime(),
    SignString = unicode:characters_to_list(io_lib:format("authorize_code=~s&app_key=~p&jh_sign=~s&time=~p",[Authorize_code,App_key,Jh_sign,Time])),
    Sign = util:md5(SignString),
    PostData=io_lib:format("app_key=~p&authorize_code=~s&sign=~s&time=~p",[App_key,Authorize_code,Sign,Time]),
    PostData2= unicode:characters_to_list(PostData,unicode),
    %%?ERR(PostData2),
    case httpc:request(post,{Url,[],"application/x-www-form-urlencoded",PostData2},[],[]) of
        {ok,{_,_,Body}} ->
            case rfc4627:decode(Body) of
                {ok,{obj,JSONlist},_} ->
                    case lists:keyfind("ret",1,JSONlist) of
                        {_,<<"0">>} ->
                            [0,"0","0"];
                        {_,<<"1">>} ->
                            case lists:keyfind("content",1,JSONlist) of
                                {_,ContentString} ->
                                    case rfc4627:decode(ContentString) of
                                        {ok,{obj,ContentJSON},_} ->
                                            case lists:keyfind("data",1,ContentJSON) of
                                                {_,[{obj,[{"user_id",UserId}|_]}]} ->
                                                    Account = util:to_list(UserId),
                                                    [1,Account,Body];
                                                _ ->
                                                    [0,"0","0"]
                                            end;
                                        _ ->
                                            [0,"0","0"]
                                    end;
                                _ ->
                                    [0,"0","0"]
                            end;
                        _ -> [0,"0","0"]
                    end;
                _ ->
                    [0,"0","0"]
            end;
        _ ->
            [0,"0","0"]
    end.
