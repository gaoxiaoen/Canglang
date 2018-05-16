%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 下午9:10
%%%-------------------------------------------------------------------
-module(xiulian_init).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("xiulian.hrl").

%% API
-export([
    init/1,
    update/0,
    logout/0
]).

init(Player) ->
    XiulianSt = xiulian_load:dbget_xiulian_info(Player),
    lib_dict:put(?PROC_STATUS_XIULIAN,XiulianSt),
    update(),
    Player.

logout() ->
    xiulian:timer_update(),
    ok.

update() ->
    XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    #st_xiulian{
        spec_update_time = SpecUpdateTime
    } = XiulianSt,
    Now = util:unixtime(),
    NewXiulianSt =
        case util:is_same_date(Now, SpecUpdateTime) of
            true -> XiulianSt;
            false ->
                XiulianSt#st_xiulian{
                    spec_update_time = Now,
                    spec_times = 0
                }
        end,
    lib_dict:put(?PROC_STATUS_XIULIAN,NewXiulianSt).