%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 九月 2017 19:29
%%%-------------------------------------------------------------------
-module(hotfix11).
-author("hxming").
-include("designation.hrl").
%% API
-export([fix/1]).

fix(Key) ->
    Sql = io_lib:format("select designation_id ,stage from log_designation where pkey = ~p", [Key]),
    F = fun([DesId, Stage], L) ->
        case lists:keytake(DesId, 1, L) of
            false ->
                [{DesId, Stage} | L];
            {value, {_, Stage1}, T} ->
                [{DesId, max(Stage, Stage1)} | T]
        end
        end,
    DesList = lists:foldl(F, [], db:get_all(Sql)),
    offline(Key, DesList),
    ok.

pack_list(DesList) ->
    Now = util:unixtime(),
    F = fun({DesId, Stage}) ->
        Base = data_designation:get(DesId),
        Time = ?IF_ELSE(Base#base_designation.time_bar == 0, 0, Base#base_designation.time_bar + Now),
        #designation{designation_id = DesId, time = Time, stage = Stage}
        end,
    lists:map(F, DesList).

offline(Pkey, DesList) ->
    Now = util:unixtime(),
    List = pack_list(DesList),
    case designation_load:load_designation(Pkey) of
        [] ->
            StDesignation = #st_designation{pkey = Pkey, designation_list = List, is_change = 1},
            designation_load:replace_designation(StDesignation),
            ok;
        [DesignationList] ->
            NewDesignationList = designation_init:designation2list(DesignationList, Now),
            F = fun(Des, L) ->
                case lists:keytake(Des#designation.designation_id, #designation.designation_id, L) of
                    false ->
                        [Des | L];
                    {value, Old, T} ->
                        if Old#designation.stage > Des#designation.stage ->
                            [Old | T];
                            true ->
                                [Des | T]
                        end
                end
                end,
            NewDesignationList1 = lists:foldl(F, List, NewDesignationList),
            StDesignation = #st_designation{pkey = Pkey, designation_list = NewDesignationList1, is_change = 1},
            designation_load:replace_designation(StDesignation)

    end.