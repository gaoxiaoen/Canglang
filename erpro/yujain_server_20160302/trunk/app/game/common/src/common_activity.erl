%%%-------------------------------------------------------------------
%%% File        :common_activity.erl
%%% @doc
%%%     活动模块公共处理模块
%%%     主要是用来操作
%%%     玩家活动状态表
%%% @end
%%%-------------------------------------------------------------------
-module(common_activity).

-include("common.hrl").
-include("common_server.hrl").

-export([
         get_other_activity_multiple/1,
         get_other_activity_multiple_config/1
        ]).

%% 获取其它活动倍数配置
get_other_activity_multiple(Atom) ->
    case get_other_activity_multiple_config(Atom) of
        [{StartDate, EndDate, StartTime, EndTime, Multiple}] ->
            NowSeconds = common_tool:now(),
            StartSeconds = common_tool:datetime_to_seconds({StartDate, StartTime}),
            EndSeconds = common_tool:datetime_to_seconds({EndDate, EndTime}),
            case NowSeconds >= StartSeconds andalso NowSeconds =< EndSeconds of
                true ->
                    Multiple;
                _ ->
                    1
            end;
        _ ->
            1
    end.
get_other_activity_multiple_config(Atom) ->
    [ServerId] = common_config_dyn:find_common(server_id),
    case common_config_dyn:find(other_activity,{Atom,ServerId}) of
        [] ->
            case common_config_dyn:find(other_activity,{Atom,0}) of
                [] ->
                    [];
                Config ->
                    Config
            end;
        Config ->
            Config
    end.
