%%-------------------------------------------------------------------
%% File              :cfg_packet_log.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-09-25
%% @doc
%%     用于跟踪玩家发包日志
%% @end
%%-------------------------------------------------------------------


-module(cfg_packet_log).

-include("mm_define.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([track/3,
         is_statistics/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================

%% track_role(600100000001) ->
%%     {0,1546185600,[?AUTH,?MAP],[?MISSION_DO]};

track_role(_RoleId) ->
    all.%% all:打印所有发包日志,undefined:不打印


%% 是否需要跟踪角色发包日志
track(RoleId,Module,Method) ->
    catch track2(RoleId,Module,Method).

track2(RoleId,Module,Method) ->
    case track_role(RoleId) of
        {StartSeconds,EndSeconds,FilterModules, FilterMethods} ->
            Now = now_seconds(),
            case Now >= StartSeconds andalso Now =< EndSeconds of
                true -> %% 是记录的时间
                    next;
                _ ->
                    erlang:throw(false)
            end,
            case lists:member(Module, FilterModules) of
                true -> %% 这个包的module不用记录
                    erlang:throw(false); 
                _ ->
                    next
            end,
            case lists:member(Method, FilterMethods) of
                true -> %%这个包的method不用记录
                    erlang:throw(false); 
                _ -> 
                    erlang:throw(true)
            end;
        all ->
            erlang:throw(true);
        _ ->
            erlang:throw(false)
    end.


now_seconds() ->
    {A, B, _} = erlang:now(),
    A * 1000000 + B.


is_statistics() ->
    common_config:is_debug().
