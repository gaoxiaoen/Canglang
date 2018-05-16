%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 七月 2017 13:39
%%%-------------------------------------------------------------------
-module(marry_designation).
-author("luobq").
-include("marry.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    init/1
    , get_info/0
    , get_marry_designation/2
    , get_marry_designation/0
    , get_state/1
]).

init(Player) ->
    case load_marry_designation(Player#player.key) of
        [] ->
            St = #st_marry_designation{pkey = Player#player.key},
            lib_dict:put(?PROC_STATUS_MARRY_DESIGNATION, St);
        [DesignationListtBin] ->
            DesignationList = util:bitstring_to_term(DesignationListtBin),
            St = #st_marry_designation{
                pkey = Player#player.key,
                designation = DesignationList
            },
            lib_dict:put(?PROC_STATUS_MARRY_DESIGNATION, St)
    end,
    Player.

get_info() ->
    RingLv = marry_ring:get_my_ring_lv(),
    HeartLv = marry_heart:get_my_heart_lv(),
    TreeLv = get_tree(),
    IdList = data_marry_designation:id_list(),
    F = fun(Id, List0) ->
        Base = data_marry_designation:get_id(Id),
        State = case check_designation(Id) of
                    {false, 31} ->
                        1; %% 已经领取
                    {false, _} ->
                        0; %% 不可领取
                    _ ->
                        2 %% 可领取
                end,
        [[Base#base_marry_designation.id,
            Base#base_marry_designation.goods_id,
            State,
            Base#base_marry_designation.ring_lv,
            Base#base_marry_designation.tree_lv,
            Base#base_marry_designation.heart_lv] | List0]
    end,
    List = lists:foldl(F, [], IdList),
    {RingLv, TreeLv, HeartLv, List}.

get_marry_designation(Player, Id) ->
    case check_designation(Id) of
        {false, Res} ->
            {false, Res};
        {ok, Base} ->
            StDesignation = lib_dict:get(?PROC_STATUS_MARRY_DESIGNATION),
            DeList = StDesignation#st_marry_designation.designation,
            lib_dict:put(?PROC_STATUS_MARRY_DESIGNATION, StDesignation#st_marry_designation{designation = [Id | DeList]}),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(290, [{Base#base_marry_designation.goods_id, 1}])),
            dbup_marry_designation(StDesignation#st_marry_designation{designation = [Id | DeList]}),
            activity:get_notice(NewPlayer, [139], true),
            {ok, NewPlayer}
    end.

check_designation(Id) ->
    StDesignation = lib_dict:get(?PROC_STATUS_MARRY_DESIGNATION),
    DeList = StDesignation#st_marry_designation.designation,
    case lists:member(Id, DeList) of
        true -> {false, 31}; %% 已经领取
        false ->
            Base = data_marry_designation:get_id(Id),
            RingLv = marry_ring:get_my_ring_lv(),
            HeartLv = marry_heart:get_my_heart_lv(),
            TreeLv = get_tree(),
            if
                RingLv < Base#base_marry_designation.ring_lv -> {false, 32};
                HeartLv < Base#base_marry_designation.heart_lv -> {false, 33};
                TreeLv < Base#base_marry_designation.tree_lv -> {false, 34};
                true ->
                    {ok, Base}
            end
    end.

get_tree() ->
    marry_tree:get_marry_tree_lv().

load_marry_designation(Pkey) ->
    Sql = io_lib:format("select designation from player_marry_designation  where pkey =~p", [Pkey]),
    db:get_row(Sql).

dbup_marry_designation(St) ->
    Sql = io_lib:format("replace into player_marry_designation set pkey=~p,designation='~s'",
        [St#st_marry_designation.pkey, util:term_to_bitstring(St#st_marry_designation.designation)]),
    db:execute(Sql).

get_marry_designation() ->
    IdList = data_marry_designation:id_list(),
    RingLv = marry_ring:get_my_ring_lv(),
    HeartLv = marry_heart:get_my_heart_lv(),
    TreeLv = get_tree(),
    F = fun(Id, List0) ->
        Base = data_marry_designation:get_id(Id),
        State = case check_designation(Id) of
                    {false, 31} ->
                        1; %% 已经领取
                    {false, _} ->
                        0; %% 不可领取
                    _ ->
                        2 %% 可领取
                end,
        if
            State == 0 andalso List0 == [] ->
                Ratio = get_marry_designation_help(Base, RingLv, HeartLv, TreeLv),
                {Base#base_marry_designation.designation_id, Ratio};
            true ->
                List0
        end
    end,
    List = lists:foldl(F, [], IdList),
    if
        List == [] ->
            Base = data_marry_designation:get_id(hd(lists:reverse(IdList))),
            {Base#base_marry_designation.designation_id, 100};
        true -> List
    end.

get_marry_designation_help(Base, RingLv, HeartLv, TreeLv) ->
    {Sum1, SumRatio1} =
        if Base#base_marry_designation.ring_lv == 0 ->
            {0, 0};
            true ->
                {1, util:floor(min(1, RingLv / Base#base_marry_designation.ring_lv) * 100)}
        end,
    {Sum2, SumRatio2} =
        if Base#base_marry_designation.heart_lv == 0 ->
            {Sum1, SumRatio1};
            true ->
                {Sum1 + 1, SumRatio1 + util:floor(min(1, HeartLv / Base#base_marry_designation.heart_lv) * 100)}
        end,
    {Sum3, SumRatio3} =
        if Base#base_marry_designation.tree_lv == 0 ->
            {Sum2, SumRatio2};
            true ->
                {Sum2 + 1, SumRatio2 + util:floor(min(1, TreeLv / Base#base_marry_designation.tree_lv) * 100)}
        end,

    util:floor(SumRatio3 / Sum3).

get_state(_Player) ->
    IdList = data_marry_designation:id_list(),
    F = fun(Id) ->
        State = case check_designation(Id) of
                    {false, 31} ->
                        false; %% 已经领取
                    {false, _} ->
                        false; %% 不可领取
                    _ ->
                        true %% 可领取
                end,
        State
    end,
    ?IF_ELSE(lists:any(F, IdList) == true, 1, 0).




