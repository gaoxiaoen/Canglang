%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 十一月 2016 17:42
%%%-------------------------------------------------------------------
-module(cross_dungeon_init).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("cross_dungeon.hrl").

%% API
-export([init/1, logout/0, timer_update/0, midnight_refresh/1, get_dungeon_times/0, update_dungeon_times/2]).

%%登陆初始化
init(Player) ->
    Now = util:unixtime(),
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_CROSS_DUNGEON, #st_cross_dun{pkey = Player#player.key, time = Now});
        false ->
            case load(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_CROSS_DUNGEON, #st_cross_dun{pkey = Player#player.key, time = Now});
                [DunList, Times, Time] ->
                    case util:is_same_date(Now, Time) of
                        true ->
                            lib_dict:put(?PROC_STATUS_CROSS_DUNGEON, #st_cross_dun{pkey = Player#player.key, dun_list = util:bitstring_to_term(DunList), times = Times, time = Time});
                        false ->
                            lib_dict:put(?PROC_STATUS_CROSS_DUNGEON, #st_cross_dun{pkey = Player#player.key, dun_list = util:bitstring_to_term(DunList), time = Now, is_change = 1})
                    end
            end
    end,
    Player.

%%离线
logout() ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON),
    if St#st_cross_dun.is_change == 1 ->
        replace(St);
        true -> ok
    end.

%%定时更新
timer_update() ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON),
    if St#st_cross_dun.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_CROSS_DUNGEON, St#st_cross_dun{is_change = 0}),
        replace(St);
        true -> ok
    end.

%%零点
midnight_refresh(Now) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON),
    lib_dict:put(?PROC_STATUS_CROSS_DUNGEON, St#st_cross_dun{time = Now, times = 0, is_change = 0}).
%%     if St#st_cross_dun.is_change == 1 ->
%%         lib_dict:put(?PROC_STATUS_CROSS_DUNGEON, St#st_cross_dun{time = Now, times = 0, is_change = 0});
%%         true -> ok
%%     end.


%%获取今日副本挑战次数
get_dungeon_times() ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON),
    St#st_cross_dun.times.

%%更新副本挑战次数
update_dungeon_times(St, DunId) ->
    DunList =
        case lists:keytake(DunId, 1, St#st_cross_dun.dun_list) of
            false -> [{DunId, 1} | St#st_cross_dun.dun_list];
            {value, {_, Times}, T} ->
                [{DunId, Times + 1} | T]
        end,
    NewSt = St#st_cross_dun{dun_list = DunList, times = St#st_cross_dun.times + 1, is_change = 1},
    lib_dict:put(?PROC_STATUS_CROSS_DUNGEON, NewSt),
    NewSt.


load(Pkey) ->
    Sql = io_lib:format("select dun_list,times,time from player_dun_cross where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace(CrossDun) ->
    Sql = io_lib:format("replace into player_dun_cross set pkey=~p, dun_list='~s',times=~p,time=~p",
        [CrossDun#st_cross_dun.pkey, util:term_to_bitstring(CrossDun#st_cross_dun.dun_list), CrossDun#st_cross_dun.times, CrossDun#st_cross_dun.time]),
    db:execute(Sql),
    ok.
