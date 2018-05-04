%%----------------------------------------------------
%% NPC AI 数据
%% @author mobin
%%----------------------------------------------------
-module(leisure_ai_data).
-include("common.hrl").
-include("npc.hrl").
-include("attr.hrl").
-include("leisure.hrl").
-export([
        get/2
    ]
).
get(ai_rule, 100001) ->
    {ok, 
        #npc_ai_rule{
            id = 100001
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, hit, <<"=">>, 0},{self_side, hit, <<"=">>, 0}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100002) ->
    {ok, 
        #npc_ai_rule{
            id = 100002
            ,repeat = 1
            ,prob = 50
            ,condition = [{opp_side, hit, <<"=">>, 0},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100003) ->
    {ok, 
        #npc_ai_rule{
            id = 100003
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, hit, <<"=">>, 0}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100021) ->
    {ok, 
        #npc_ai_rule{
            id = 100021
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, attack}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100022) ->
    {ok, 
        #npc_ai_rule{
            id = 100022
            ,repeat = 1
            ,prob = 70
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?defence			
        }
    };
get(ai_rule, 100023) ->
    {ok, 
        #npc_ai_rule{
            id = 100023
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100024) ->
    {ok, 
        #npc_ai_rule{
            id = 100024
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, block},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100025) ->
    {ok, 
        #npc_ai_rule{
            id = 100025
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100031) ->
    {ok, 
        #npc_ai_rule{
            id = 100031
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, attack}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100032) ->
    {ok, 
        #npc_ai_rule{
            id = 100032
            ,repeat = 1
            ,prob = 70
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?defence			
        }
    };
get(ai_rule, 100033) ->
    {ok, 
        #npc_ai_rule{
            id = 100033
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100034) ->
    {ok, 
        #npc_ai_rule{
            id = 100034
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, block},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100035) ->
    {ok, 
        #npc_ai_rule{
            id = 100035
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100041) ->
    {ok, 
        #npc_ai_rule{
            id = 100041
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 3},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100042) ->
    {ok, 
        #npc_ai_rule{
            id = 100042
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, attack}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100043) ->
    {ok, 
        #npc_ai_rule{
            id = 100043
            ,repeat = 1
            ,prob = 70
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?defence			
        }
    };
get(ai_rule, 100044) ->
    {ok, 
        #npc_ai_rule{
            id = 100044
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100045) ->
    {ok, 
        #npc_ai_rule{
            id = 100045
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, block},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100046) ->
    {ok, 
        #npc_ai_rule{
            id = 100046
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100051) ->
    {ok, 
        #npc_ai_rule{
            id = 100051
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 3},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100052) ->
    {ok, 
        #npc_ai_rule{
            id = 100052
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 5},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100053) ->
    {ok, 
        #npc_ai_rule{
            id = 100053
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, attack}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100054) ->
    {ok, 
        #npc_ai_rule{
            id = 100054
            ,repeat = 1
            ,prob = 70
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?defence			
        }
    };
get(ai_rule, 100055) ->
    {ok, 
        #npc_ai_rule{
            id = 100055
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100056) ->
    {ok, 
        #npc_ai_rule{
            id = 100056
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, block},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100057) ->
    {ok, 
        #npc_ai_rule{
            id = 100057
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100061) ->
    {ok, 
        #npc_ai_rule{
            id = 100061
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 2},{self_side, hit, <<"=">>, 0}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100062) ->
    {ok, 
        #npc_ai_rule{
            id = 100062
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 3},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100063) ->
    {ok, 
        #npc_ai_rule{
            id = 100063
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 5},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100064) ->
    {ok, 
        #npc_ai_rule{
            id = 100064
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, attack}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100065) ->
    {ok, 
        #npc_ai_rule{
            id = 100065
            ,repeat = 1
            ,prob = 70
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?defence			
        }
    };
get(ai_rule, 100066) ->
    {ok, 
        #npc_ai_rule{
            id = 100066
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100067) ->
    {ok, 
        #npc_ai_rule{
            id = 100067
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, block},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100068) ->
    {ok, 
        #npc_ai_rule{
            id = 100068
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100071) ->
    {ok, 
        #npc_ai_rule{
            id = 100071
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, attack}]
            ,action = ?defence			
        }
    };
get(ai_rule, 100072) ->
    {ok, 
        #npc_ai_rule{
            id = 100072
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, block}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100073) ->
    {ok, 
        #npc_ai_rule{
            id = 100073
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 3},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100074) ->
    {ok, 
        #npc_ai_rule{
            id = 100074
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 5},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100075) ->
    {ok, 
        #npc_ai_rule{
            id = 100075
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, attack}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100076) ->
    {ok, 
        #npc_ai_rule{
            id = 100076
            ,repeat = 1
            ,prob = 70
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?defence			
        }
    };
get(ai_rule, 100077) ->
    {ok, 
        #npc_ai_rule{
            id = 100077
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100078) ->
    {ok, 
        #npc_ai_rule{
            id = 100078
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, block},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100079) ->
    {ok, 
        #npc_ai_rule{
            id = 100079
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100091) ->
    {ok, 
        #npc_ai_rule{
            id = 100091
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat, round, <<">=">>, 1},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100092) ->
    {ok, 
        #npc_ai_rule{
            id = 100092
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 1},{self_side, hit, <<">=">>, 2}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100093) ->
    {ok, 
        #npc_ai_rule{
            id = 100093
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 1},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100094) ->
    {ok, 
        #npc_ai_rule{
            id = 100094
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, attack}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100095) ->
    {ok, 
        #npc_ai_rule{
            id = 100095
            ,repeat = 1
            ,prob = 70
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?defence			
        }
    };
get(ai_rule, 100096) ->
    {ok, 
        #npc_ai_rule{
            id = 100096
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, focus},{opp_side, hit, <<">=">>, 1}]
            ,action = ?energy			
        }
    };
get(ai_rule, 100097) ->
    {ok, 
        #npc_ai_rule{
            id = 100097
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side, choice, <<"=">>, block},{self_side, hit, <<">=">>, 1}]
            ,action = ?attack			
        }
    };
get(ai_rule, 100098) ->
    {ok, 
        #npc_ai_rule{
            id = 100098
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat, round, <<">=">>, 1}]
            ,action = ?energy			
        }
    };

get(ai, 2) ->
    {ok, [[1,100001,100002,100003]]};
get(ai, 3) ->
    {ok, [[1,100001,100002,100003]]};
get(ai, 5) ->
    {ok, [[1,100001,100002,100003]]};
get(ai, 10332) ->
    {ok, [[1,100021,100022,100023,100024,100025]]};
get(ai, 11332) ->
    {ok, [[1,100031,100032,100033,100034,100035]]};
get(ai, 10350) ->
    {ok, [[1,100041,100042,100043,100044,100045,100046]]};
get(ai, 11350) ->
    {ok, [[1,100051,100052,100053,100054,100055,100056,100057]]};
get(ai, 10380) ->
    {ok, [[1,100061,100062,100063,100064,100065,100066,100067,100068]]};
get(ai, 11380) ->
    {ok, [[1,100071,100072,100073,100074,100075,100076,100077,100078,100079]]};
get(ai, 10410) ->
    {ok, [[1,100061,100062,100063,100064,100065,100066,100067,100068]]};
get(ai, 11410) ->
    {ok, [[1,100071,100072,100073,100074,100075,100076,100077,100078,100079]]};
get(ai, 10674) ->
    {ok, [[1,100061,100062,100063,100064,100065,100066,100067,100068]]};
get(ai, 11674) ->
    {ok, [[1,100071,100072,100073,100074,100075,100076,100077,100078,100079]]};

get(_I, _X) ->
    false.    

