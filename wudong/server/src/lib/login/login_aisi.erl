%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2015 上午10:19
%%%-------------------------------------------------------------------
-module(login_aisi).
-author("fancy").
-include("common.hrl").

%% API
-export([login/0,login/1]).

login() ->
    login([1231234]).

login([Token]) ->
    Url = "https://pay.i4.cn/member_third.action",
%    AppId = 815,
    PostData=io_lib:format("token=~s",[Token]),
    PostData2= unicode:characters_to_list(PostData,unicode),
    case httpc:request(post,{Url,[],"application/x-www-form-urlencoded",PostData2},[],[]) of
        {ok,{_,_,Body}} ->
            case rfc4627:decode(Body) of
                {ok,{obj,JSONlist},_} ->
                    ?PRINT("JSONlist:~p~n",[JSONlist]),
                    case lists:keyfind("status",1,JSONlist) of
                        {_,0} ->
                            {_,Accname} = lists:keyfind("userid",1,JSONlist),
                            {1,util:to_list(Accname)};
                        {_,Code} ->
                            ?ERR("login aisi err code:~p~n",[util:to_integer(Code)]),
                            {0,false}
                    end;
                _ ->
                    {0,false}
            end;
        _ ->
            {0,false}
    end.
