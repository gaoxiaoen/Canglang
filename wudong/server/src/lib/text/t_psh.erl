%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 十二月 2015 15:05
%%%-------------------------------------------------------------------
-module(t_psh).
-author("hxming").

-include("common.hrl").
%% API
-export([get/1]).

get(Type)->
    case Type of
        1->
            ?T("邪恶势力扩展，幻想神迹大陆危在旦夕，我急需你的帮助---蒂法");
        2->
            ?T("主人主人，我发现一个好玩的东西，你来看看嘛");

        _->false
    end.
