%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十一月 2017 18:14
%%%-------------------------------------------------------------------
-module(pet_war_load).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("pet.hrl").
-include("pet_war.hrl").

%% API
-export([
    load_map/1,
    update_map/1,
    load_pet_dun/1,
    update_pet_dun/1
]).

load_map(Pkey) ->
    Sql = io_lib:format("select map,use_map from player_pet_map where pkey = ~p", [Pkey]),
    case db:get_row(Sql) of
        [MapBin, UseMapId] ->
            {util:bitstring_to_term(MapBin), UseMapId};
        _ ->
            {[], 1}
    end.

update_map(Map) ->
    #st_pet_map{
        pkey = Pkey,
        map_list = MapList,
        use_map_id = UseMapId
    } = Map,
    Sql = io_lib:format("replace into player_pet_map set pkey=~p, map='~s', use_map=~p", [Pkey, util:term_to_bitstring(MapList), UseMapId]),
    db:execute(Sql),
    ok.

load_pet_dun(Pkey) ->
    Sql = io_lib:format("select dun_id, recv_star_list, saodang_list, op_time from player_pet_dun where pkey = ~p", [Pkey]),
    case db:get_row(Sql) of
        [DunId, RecvStarListBin, SaodangListBin, OpTime] ->
            RecvStarList = util:bitstring_to_term(RecvStarListBin),
            SaodangList = util:bitstring_to_term(SaodangListBin),
            #st_pet_war_dun{pkey = Pkey, dun_id = DunId, recv_star_list = RecvStarList, saodang_list = SaodangList, op_time = OpTime};
        _ ->
            #st_pet_war_dun{pkey = Pkey}
    end.

update_pet_dun(StPetDun) ->
    #st_pet_war_dun{
        pkey = Pkey,
        dun_id = DunId,
        recv_star_list = RecvStarList,
        saodang_list = SaodangList,
        op_time = OpTime
    } = StPetDun,
    RecvStarListBin = util:term_to_bitstring(RecvStarList),
    SaodangListBin = util:term_to_bitstring(SaodangList),
    Sql = io_lib:format("replace into player_pet_dun set pkey=~p, dun_id=~p, recv_star_list='~s', saodang_list='~s', op_time=~p",
        [Pkey, DunId, RecvStarListBin, SaodangListBin, OpTime]),
    db:execute(Sql),
    ok.