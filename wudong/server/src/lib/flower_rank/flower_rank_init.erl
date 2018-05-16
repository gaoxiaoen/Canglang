%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 五月 2017 11:19
%%%-------------------------------------------------------------------
-module(flower_rank_init).
-author("luobq").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    init/1
    , test/0
    , update/1
]).

init(Player) ->
    StFlower = flower_rank_load:dbget_flower_rank_achieve(Player#player.key),
    lib_dict:put(?PROC_STATUS_FLOWER_RANK, StFlower),
    update(Player#player.key),
    Player.

update(Pkey) ->
    St = lib_dict:get(?PROC_STATUS_FLOWER_RANK),
    #player_flower_rank_log{
        act_id = ActId
    } = St,
    NewSt0 = #player_flower_rank_log{
        pkey = Pkey,
        act_id = 0,
        give = 0,
        get = 0,
        give_list = [],
        get_list = []
    },
    NewSt =
        case activity:get_work_list(data_flower_rank) of
            [] -> St;
            [Base | _] ->
                #base_act_flower_rank{
                    act_id = BaseActId
                } = Base,
                case BaseActId =/= ActId of
                    true ->
                        NewSt0#player_flower_rank_log{
                            act_id = BaseActId
                        };
                    false ->
                        St
                end
        end,
    lib_dict:put(?PROC_STATUS_FLOWER_RANK, NewSt),
    ok.


test() ->
    St = lib_dict:get(?PROC_STATUS_FLOWER_RANK),
    ?DEBUG("St ~p~n", [St]),
    ok.
