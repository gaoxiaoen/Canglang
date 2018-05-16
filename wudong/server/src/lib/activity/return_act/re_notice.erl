%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十二月 2017 14:53
%%%-------------------------------------------------------------------
-module(re_notice).
-author("Administrator").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    get_act/0,
    get_info/1,
    get_state/1
]).

get_info(Player) ->
    case return_act:get_re_state(Player) of
        true ->
            case get_act() of
                [] -> [];
                #base_re_notice{notice_list = NoticeList} ->
                    F = fun(Info) ->
                        [
                            Info#base_re_notice_info.id,
                            Info#base_re_notice_info.title,
                            Info#base_re_notice_info.content,
                            Info#base_re_notice_info.skip_id,
                            Info#base_re_notice_info.page_id
                        ]
                    end,
                    lists:map(F, NoticeList)
            end;
        _ ->
            []
    end.

get_act() ->
    case activity:get_work_list(data_re_notice) of
        [] -> [];
        [Base | _] -> Base
    end.

get_state(Player) ->
    case return_act:get_re_state(Player) of
        true ->
            case get_act() of
                [] -> -1;
                _ -> 0
            end;
        _ ->
            -1
    end.