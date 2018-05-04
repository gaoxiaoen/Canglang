%% --------------------------------------------------------------------
%% 试练数据
%% @author abu
%% @end
%% --------------------------------------------------------------------
-module(practice_data).

%% export
-export([get/1, all/0]).

%% include
-include("practice.hrl").


get(23000) ->
    #practice_round_data{
        round = 1
        ,npc_base_id = 23000
        ,score = 50
    };
get(23001) ->
    #practice_round_data{
        round = 2
        ,npc_base_id = 23001
        ,score = 55
    };
get(23002) ->
    #practice_round_data{
        round = 3
        ,npc_base_id = 23002
        ,score = 60
    };
get(23003) ->
    #practice_round_data{
        round = 4
        ,npc_base_id = 23003
        ,score = 65
    };
get(23004) ->
    #practice_round_data{
        round = 5
        ,npc_base_id = 23004
        ,score = 70
    };
get(23005) ->
    #practice_round_data{
        round = 6
        ,npc_base_id = 23005
        ,score = 75
    };
get(23006) ->
    #practice_round_data{
        round = 7
        ,npc_base_id = 23006
        ,score = 80
    };
get(23007) ->
    #practice_round_data{
        round = 8
        ,npc_base_id = 23007
        ,score = 84
    };
get(23008) ->
    #practice_round_data{
        round = 9
        ,npc_base_id = 23008
        ,score = 87
    };
get(23009) ->
    #practice_round_data{
        round = 10
        ,npc_base_id = 23009
        ,score = 89
    };
get(23010) ->
    #practice_round_data{
        round = 11
        ,npc_base_id = 23010
        ,score = 92
    };
get(23011) ->
    #practice_round_data{
        round = 12
        ,npc_base_id = 23011
        ,score = 94
    };
get(23012) ->
    #practice_round_data{
        round = 13
        ,npc_base_id = 23012
        ,score = 97
    };
get(23013) ->
    #practice_round_data{
        round = 14
        ,npc_base_id = 23013
        ,score = 99
    };
get(23014) ->
    #practice_round_data{
        round = 15
        ,npc_base_id = 23014
        ,score = 100
    };
get(23015) ->
    #practice_round_data{
        round = 16
        ,npc_base_id = 23015
        ,score = 100
    };
get(23016) ->
    #practice_round_data{
        round = 17
        ,npc_base_id = 23016
        ,score = 100
    };
get(23017) ->
    #practice_round_data{
        round = 18
        ,npc_base_id = 23017
        ,score = 100
    };
get(23018) ->
    #practice_round_data{
        round = 19
        ,npc_base_id = 23018
        ,score = 100
    };
get(23019) ->
    #practice_round_data{
        round = 20
        ,npc_base_id = 23019
        ,score = 100
    };
get(23020) ->
    #practice_round_data{
        round = 21
        ,npc_base_id = 23020
        ,score = 100
    };
get(23021) ->
    #practice_round_data{
        round = 22
        ,npc_base_id = 23021
        ,score = 100
    };
get(23022) ->
    #practice_round_data{
        round = 23
        ,npc_base_id = 23022
        ,score = 100
    };
get(23023) ->
    #practice_round_data{
        round = 24
        ,npc_base_id = 23023
        ,score = 100
    };
get(23024) ->
    #practice_round_data{
        round = 25
        ,npc_base_id = 23024
        ,score = 100
    };
get(23025) ->
    #practice_round_data{
        round = 26
        ,npc_base_id = 23025
        ,score = 100
    };
get(23026) ->
    #practice_round_data{
        round = 27
        ,npc_base_id = 23026
        ,score = 100
    };
get(23027) ->
    #practice_round_data{
        round = 28
        ,npc_base_id = 23027
        ,score = 100
    };
get(23028) ->
    #practice_round_data{
        round = 29
        ,npc_base_id = 23028
        ,score = 100
    };
get(23029) ->
    #practice_round_data{
        round = 30
        ,npc_base_id = 23029
        ,score = 100
    };
get(_) ->
     false.


all() ->
	[23000,23001,23002,23003,23004,23005,23006,23007,23008,23009,23010,23011,23012,23013,23014,23015,23016,23017,23018,23019,23020,23021,23022,23023,23024,23025,23026,23027,23028,23029]. 
