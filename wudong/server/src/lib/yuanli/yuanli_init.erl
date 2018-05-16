%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 下午2:25
%%%-------------------------------------------------------------------
-module(yuanli_init).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("yuanli.hrl").

%% API
-export([
    init/1,
    update/0,
    logout/0
]).

init(Player) ->
    YuanliSt = yuanli_load:dbget_yuanli_info(Player),
    lib_dict:put(?PROC_STATUS_YUANLI,YuanliSt),
    update(),
    Player.

logout() ->
    yuanli:timer_update(),
    ok.

update() ->
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    #st_yuanli{
        spec_update_time = SpecUpdateTime
    } = YuanliSt,
    Now = util:unixtime(),
    NewYuanliSt =
        case util:is_same_date(Now, SpecUpdateTime) of
            true -> YuanliSt;
            false ->
                YuanliSt#st_yuanli{
                    spec_update_time = Now,
                    spec_times = 0
                }
        end,
    lib_dict:put(?PROC_STATUS_YUANLI,NewYuanliSt).
