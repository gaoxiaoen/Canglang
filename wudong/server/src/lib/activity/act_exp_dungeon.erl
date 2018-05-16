%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2018 13:39
%%%-------------------------------------------------------------------
-module(act_exp_dungeon).
-author("Administrator").
-include("activity.hrl").
-include("server.hrl").
-include("common.hrl").
-include("dungeon.hrl").
%% API
-export([init/1,
    get_info/1,
    buy/1,
    get_state/1,
    get_reward/2]).

-define(ACT_EXP_DUNGEON, erlang:element(1, data_version_different:get(9))).
-define(ACT_EXP_DUNGEON_RATIO, erlang:element(2, data_version_different:get(9))).

init(Player) ->
    St =
        case player_util:is_new_role(Player) of
            true ->
                #st_act_exp_dungeon{pkey = Player#player.key};
            false ->
                activity_load:dbget_act_exp_dungeon(Player#player.key)
        end,
    lib_dict:put(?PROC_STATUS_EXP_DUNGEON, St),
    Player.


get_info(_Player) ->
    St = lib_dict:get(?PROC_STATUS_EXP_DUNGEON),
    Ids = data_act_exp_dungeon:get_all(),
    StDunExp = lib_dict:get(?PROC_STATUS_DUN_EXP),
%%     ?DEBUG("StDunExp#st_dun_exp.round_highest ~p~n",[StDunExp#st_dun_exp.round_highest]),
%%     ?DEBUG("StDunExp#st_dun_exp.round_highest ~p~n",[St#st_act_exp_dungeon.is_buy ]),
    F = fun(Id) ->
        case data_act_exp_dungeon:get(Id) of
            [] -> [];
            Base ->
                State =
                    case lists:member(Base#base_act_exp_dungeon.id, St#st_act_exp_dungeon.get_list) of
                        false ->
                            ?IF_ELSE(StDunExp#st_dun_exp.round_highest >= Base#base_act_exp_dungeon.floor andalso St#st_act_exp_dungeon.is_buy == 1, 1, 0);
                        true -> %% 已经领取
                            2
                    end,
                [[
                    Base#base_act_exp_dungeon.id,
                    Base#base_act_exp_dungeon.floor,
                    State,
                    goods:pack_goods(Base#base_act_exp_dungeon.reward)
                ]]
        end
    end,
    List = lists:flatmap(F, Ids),
    {?ACT_EXP_DUNGEON, ?ACT_EXP_DUNGEON_RATIO, St#st_act_exp_dungeon.is_buy, List}.


buy(Player) ->
    St = lib_dict:get(?PROC_STATUS_EXP_DUNGEON),
    if
        St#st_act_exp_dungeon.is_buy == 1 -> {22, Player};
        true ->
            case money:is_enough(Player, ?ACT_EXP_DUNGEON, gold) of
                false -> {2, Player};
                true ->
                    NewPlayer = money:add_no_bind_gold(Player, -?ACT_EXP_DUNGEON, 339, 0, 0),
                    lib_dict:put(?PROC_STATUS_EXP_DUNGEON, St#st_act_exp_dungeon{is_buy = 1}),
                    activity_load:dbup_act_exp_dungeon(St#st_act_exp_dungeon{is_buy = 1}),
                    {1, NewPlayer}
            end
    end.

get_reward(Player, Id) ->
    case check_get_reward(Id) of
        {false, Res} -> {Res, Player};
        {ok, Base} ->
            St = lib_dict:get(?PROC_STATUS_EXP_DUNGEON),
            NewSt = St#st_act_exp_dungeon{get_list = [Base#base_act_exp_dungeon.id | St#st_act_exp_dungeon.get_list]},
            lib_dict:put(?PROC_STATUS_EXP_DUNGEON, NewSt),
            activity_load:dbup_act_exp_dungeon(NewSt),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(340, Base#base_act_exp_dungeon.reward)),
            {1, NewPlayer}
    end.

check_get_reward(Id) ->
    St = lib_dict:get(?PROC_STATUS_EXP_DUNGEON),
    if
        St#st_act_exp_dungeon.is_buy == 0 -> {false, 23};
        true ->
            case data_act_exp_dungeon:get(Id) of
                [] -> {false, 0};
                Base ->
                    case lists:member(Id, St#st_act_exp_dungeon.get_list) of
                        true ->
                            {false, 24};
                        false ->
                            {ok, Base}
                    end
            end
    end.


get_state(_Player) ->
    St = lib_dict:get(?PROC_STATUS_EXP_DUNGEON),
    Ids = data_act_exp_dungeon:get_all(),
    StDunExp = lib_dict:get(?PROC_STATUS_DUN_EXP),
    F = fun(Id) ->
        case data_act_exp_dungeon:get(Id) of
            [] -> false;
            Base ->
                case lists:member(Base#base_act_exp_dungeon.id, St#st_act_exp_dungeon.get_list) of
                    false ->
                        ?IF_ELSE(StDunExp#st_dun_exp.round_highest >= Base#base_act_exp_dungeon.floor andalso St#st_act_exp_dungeon.is_buy == 1, true, false);
                    true -> %% 已经领取
                        false
                end
        end
    end,
    case lists:any(F, Ids) of
        true -> 1;
        _ -> 0
    end.