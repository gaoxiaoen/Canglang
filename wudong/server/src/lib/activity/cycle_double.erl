%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2016 下午7:43
%%%-------------------------------------------------------------------
-module(cycle_double).
-author("fengzhenlin").
-include("activity.hrl").

%% API
-export([
    get_mul/0
]).

get_mul() ->
    case activity:get_work_list(data_cycle_double) of
        [] -> false;
        [Base|_] ->
            #base_cycle_double{
                mul = Mul
            } = Base,
            Mul
    end.
