%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2016 下午3:02
%%%-------------------------------------------------------------------
-module(merge_exp_double).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    get_info/1,
    get_exp_mul/1,
    update/1
]).

-define(MAX_DAY, 3).

get_info(Player) ->
    {_Mul, LeaveTime} = get_exp_mul(Player#player.sn),
    {ok, Bin} = pt_432:write(43241, {LeaveTime}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_exp_mul(Sn) ->
    MergeDay = config:get_merge_days(),
    case MergeDay > 0 andalso MergeDay =< ?MAX_DAY of
        false -> {0, 0};
        true ->
            DiffDay = config:get_diff_open_days(Sn),
            case DiffDay > 0 of
                true ->
                    EffDay = DiffDay div 2,
                    EffDay1 = min(?MAX_DAY, EffDay),
                    case MergeDay > EffDay1 of
                        true -> {0, 0};
                        false ->
                            LeaveTime = (EffDay1 - MergeDay + 1) * ?ONE_DAY_SECONDS + (util:unixtime() - util:unixdate()),
                            {2, LeaveTime}
                    end;
                false ->
                    {0,0}
            end
    end.

update(Player) ->
    {Mul, _LeaveTime} = get_exp_mul(Player#player.sn),
    NewPlayer = Player#player{merge_exp_mul = Mul},
    case Player#player.merge_exp_mul > 0 andalso Mul =< 0 of
        true -> get_info(Player);
        false -> skip
    end,
    NewPlayer.


