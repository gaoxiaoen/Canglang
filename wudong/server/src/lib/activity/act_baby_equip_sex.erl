%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 九月 2017 17:30
%%%-------------------------------------------------------------------
-module(act_baby_equip_sex).
-author("lzx").

%% API
-export([is_open/0]).

%% 是否开放
is_open() ->
    case activity:get_work_list(data_act_baby_equip_sex) of
        [_Base | _] -> true;
        _ ->
            false
    end.



