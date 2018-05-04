%%----------------------------------------------------
%% NPC AI 数据
%% @author mobin
%%----------------------------------------------------
-module(npc_ai_data).
-include("common.hrl").
-include("npc.hrl").
-include("attr.hrl").
-export([
        get/2, get/3
    ]
).
get(ai_rule, 100001) ->
    {ok, 
        #npc_ai_rule{
            id = 100001
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100002) ->
    {ok, 
        #npc_ai_rule{
            id = 100002
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600002}]
        }
    };
get(ai_rule, 100003) ->
    {ok, 
        #npc_ai_rule{
            id = 100003
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100004) ->
    {ok, 
        #npc_ai_rule{
            id = 100004
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600004}]
        }
    };
get(ai_rule, 100005) ->
    {ok, 
        #npc_ai_rule{
            id = 100005
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600005}]
        }
    };
get(ai_rule, 100006) ->
    {ok, 
        #npc_ai_rule{
            id = 100006
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,16,1}]
            ,action = [{opp_side,skill,600379}]
        }
    };
get(ai_rule, 100007) ->
    {ok, 
        #npc_ai_rule{
            id = 100007
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,15,1}]
            ,action = [{opp_side,skill,600378}]
        }
    };
get(ai_rule, 100008) ->
    {ok, 
        #npc_ai_rule{
            id = 100008
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,14,1}]
            ,action = [{opp_side,skill,600377}]
        }
    };
get(ai_rule, 100009) ->
    {ok, 
        #npc_ai_rule{
            id = 100009
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,13,1}]
            ,action = [{opp_side,skill,600376}]
        }
    };
get(ai_rule, 100010) ->
    {ok, 
        #npc_ai_rule{
            id = 100010
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,12,1}]
            ,action = [{opp_side,skill,600375}]
        }
    };
get(ai_rule, 100011) ->
    {ok, 
        #npc_ai_rule{
            id = 100011
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,11,1}]
            ,action = [{opp_side,skill,600374}]
        }
    };
get(ai_rule, 100012) ->
    {ok, 
        #npc_ai_rule{
            id = 100012
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,10,1}]
            ,action = [{opp_side,skill,600373}]
        }
    };
get(ai_rule, 100013) ->
    {ok, 
        #npc_ai_rule{
            id = 100013
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,9,1}]
            ,action = [{opp_side,skill,600372}]
        }
    };
get(ai_rule, 100014) ->
    {ok, 
        #npc_ai_rule{
            id = 100014
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,8,1}]
            ,action = [{opp_side,skill,600371}]
        }
    };
get(ai_rule, 100015) ->
    {ok, 
        #npc_ai_rule{
            id = 100015
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,7,1}]
            ,action = [{opp_side,skill,600370}]
        }
    };
get(ai_rule, 100016) ->
    {ok, 
        #npc_ai_rule{
            id = 100016
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,6,1}]
            ,action = [{opp_side,skill,600369}]
        }
    };
get(ai_rule, 100017) ->
    {ok, 
        #npc_ai_rule{
            id = 100017
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,600368}]
        }
    };
get(ai_rule, 100018) ->
    {ok, 
        #npc_ai_rule{
            id = 100018
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1}]
            ,action = [{opp_side,skill,600367}]
        }
    };
get(ai_rule, 100019) ->
    {ok, 
        #npc_ai_rule{
            id = 100019
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{opp_side,skill,600366}]
        }
    };
get(ai_rule, 100020) ->
    {ok, 
        #npc_ai_rule{
            id = 100020
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,2,1}]
            ,action = [{opp_side,skill,600365}]
        }
    };
get(ai_rule, 100021) ->
    {ok, 
        #npc_ai_rule{
            id = 100021
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600364}]
        }
    };
get(ai_rule, 90000) ->
    {ok, 
        #npc_ai_rule{
            id = 90000
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,2101,1},{opp_side,buff,<<"include">>,201101,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,base_skill,2101}]
        }
    };
get(ai_rule, 90001) ->
    {ok, 
        #npc_ai_rule{
            id = 90001
            ,type = 1
            ,repeat = 1
            ,prob = 60
            ,condition = [{self,base_skill,<<"include">>,2205,1},{self_side,hp,<<"<">>,70,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,base_skill,2205}]
        }
    };
get(ai_rule, 90002) ->
    {ok, 
        #npc_ai_rule{
            id = 90002
            ,type = 1
            ,repeat = 1
            ,prob = 20
            ,condition = [{self,base_skill,<<"include">>,2102,1}]
            ,action = [{opp_side,base_skill,2102}]
        }
    };
get(ai_rule, 90003) ->
    {ok, 
        #npc_ai_rule{
            id = 90003
            ,type = 1
            ,repeat = 1
            ,prob = 90
            ,condition = [{self,base_skill,<<"include">>,2102,1},{opp_side,hp,<<"<">>,20,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,base_skill,2102}]
        }
    };
get(ai_rule, 90004) ->
    {ok, 
        #npc_ai_rule{
            id = 90004
            ,type = 1
            ,repeat = 1
            ,prob = 60
            ,condition = [{self,base_skill,<<"include">>,2103,1}]
            ,action = [{opp_side,base_skill,2103}]
        }
    };
get(ai_rule, 90005) ->
    {ok, 
        #npc_ai_rule{
            id = 90005
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,2104,1}]
            ,action = [{opp_side,base_skill,2104}]
        }
    };
get(ai_rule, 90006) ->
    {ok, 
        #npc_ai_rule{
            id = 90006
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,2103,1}]
            ,action = [{opp_side,base_skill,2103}]
        }
    };
get(ai_rule, 90007) ->
    {ok, 
        #npc_ai_rule{
            id = 90007
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,2101,1}]
            ,action = [{opp_side,base_skill,2101}]
        }
    };
get(ai_rule, 90008) ->
    {ok, 
        #npc_ai_rule{
            id = 90008
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,2102,1}]
            ,action = [{opp_side,base_skill,2102}]
        }
    };
get(ai_rule, 90009) ->
    {ok, 
        #npc_ai_rule{
            id = 90009
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,2100,1}]
            ,action = [{opp_side,base_skill,2100}]
        }
    };
get(ai_rule, 90010) ->
    {ok, 
        #npc_ai_rule{
            id = 90010
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,3104,1},{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,base_skill,3104}]
        }
    };
get(ai_rule, 90011) ->
    {ok, 
        #npc_ai_rule{
            id = 90011
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,3102,1},{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,base_skill,3102}]
        }
    };
get(ai_rule, 90012) ->
    {ok, 
        #npc_ai_rule{
            id = 90012
            ,type = 1
            ,repeat = 1
            ,prob = 80
            ,condition = [{self,base_skill,<<"include">>,3205,1},{self_side,hp,<<"<">>,50,1}]
            ,action = [{suit_tar,base_skill,3205}]
        }
    };
get(ai_rule, 90013) ->
    {ok, 
        #npc_ai_rule{
            id = 90013
            ,type = 1
            ,repeat = 1
            ,prob = 80
            ,condition = [{self,base_skill,<<"include">>,3103,1}]
            ,action = [{opp_side,base_skill,3103}]
        }
    };
get(ai_rule, 90014) ->
    {ok, 
        #npc_ai_rule{
            id = 90014
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,3101,1}]
            ,action = [{opp_side,base_skill,3101}]
        }
    };
get(ai_rule, 90015) ->
    {ok, 
        #npc_ai_rule{
            id = 90015
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,3102,1}]
            ,action = [{opp_side,base_skill,3102}]
        }
    };
get(ai_rule, 90016) ->
    {ok, 
        #npc_ai_rule{
            id = 90016
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,3101,1}]
            ,action = [{opp_side,base_skill,3101}]
        }
    };
get(ai_rule, 90017) ->
    {ok, 
        #npc_ai_rule{
            id = 90017
            ,type = 1
            ,repeat = 1
            ,prob = 30
            ,condition = [{self,base_skill,<<"include">>,3104,1}]
            ,action = [{opp_side,base_skill,3104}]
        }
    };
get(ai_rule, 90018) ->
    {ok, 
        #npc_ai_rule{
            id = 90018
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,3100,1}]
            ,action = [{opp_side,base_skill,3100}]
        }
    };
get(ai_rule, 90019) ->
    {ok, 
        #npc_ai_rule{
            id = 90019
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,5101,1},{opp_side,buff,<<"include">>,202140,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{opp_side,base_skill,5101}]
        }
    };
get(ai_rule, 90020) ->
    {ok, 
        #npc_ai_rule{
            id = 90020
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,5102,1},{self,buff,<<"include">>,101400,1}]
            ,action = [{opp_side,base_skill,5102}]
        }
    };
get(ai_rule, 90021) ->
    {ok, 
        #npc_ai_rule{
            id = 90021
            ,type = 1
            ,repeat = 1
            ,prob = 60
            ,condition = [{self,base_skill,<<"include">>,5205,1},{self_side,hp,<<"<">>,50,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,base_skill,5205}]
        }
    };
get(ai_rule, 90022) ->
    {ok, 
        #npc_ai_rule{
            id = 90022
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,5104,1}]
            ,action = [{opp_side,base_skill,5104}]
        }
    };
get(ai_rule, 90023) ->
    {ok, 
        #npc_ai_rule{
            id = 90023
            ,type = 1
            ,repeat = 1
            ,prob = 40
            ,condition = [{self,base_skill,<<"include">>,5103,1}]
            ,action = [{opp_side,base_skill,5103}]
        }
    };
get(ai_rule, 90024) ->
    {ok, 
        #npc_ai_rule{
            id = 90024
            ,type = 1
            ,repeat = 1
            ,prob = 20
            ,condition = [{self,base_skill,<<"include">>,5102,1},{self,base_skill,<<"not_in">>,5205,1}]
            ,action = [{opp_side,base_skill,5102}]
        }
    };
get(ai_rule, 90025) ->
    {ok, 
        #npc_ai_rule{
            id = 90025
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,5205,1}]
            ,action = [{self,base_skill,5205}]
        }
    };
get(ai_rule, 90026) ->
    {ok, 
        #npc_ai_rule{
            id = 90026
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,5103,1}]
            ,action = [{opp_side,base_skill,5103}]
        }
    };
get(ai_rule, 90027) ->
    {ok, 
        #npc_ai_rule{
            id = 90027
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,5101,1}]
            ,action = [{opp_side,base_skill,5101}]
        }
    };
get(ai_rule, 90028) ->
    {ok, 
        #npc_ai_rule{
            id = 90028
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,5100,1}]
            ,action = [{opp_side,base_skill,5100}]
        }
    };
get(ai_rule, 90029) ->
    {ok, 
        #npc_ai_rule{
            id = 90029
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,2102,1},{opp_side,hp,<<"<">>,20,1}]
            ,action = [{suit_tar,base_skill,2102}]
        }
    };
get(ai_rule, 90030) ->
    {ok, 
        #npc_ai_rule{
            id = 90030
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,3205,1},{self,hp,<<"<">>,30,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,hp,<<">">>,60,1}]
            ,action = [{self,base_skill,3205}]
        }
    };
get(ai_rule, 90031) ->
    {ok, 
        #npc_ai_rule{
            id = 90031
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,3103,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,hp,<<">">>,20,1}]
            ,action = [{suit_tar,base_skill,3103}]
        }
    };
get(ai_rule, 90032) ->
    {ok, 
        #npc_ai_rule{
            id = 90032
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,3104,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,hp,<<">">>,20,1}]
            ,action = [{suit_tar,base_skill,3104}]
        }
    };
get(ai_rule, 90033) ->
    {ok, 
        #npc_ai_rule{
            id = 90033
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,5205,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,hp,<<">">>,20,1}]
            ,action = [{self,base_skill,5205}]
        }
    };
get(ai_rule, 90034) ->
    {ok, 
        #npc_ai_rule{
            id = 90034
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,5102,1},{self,buff,<<"include">>,101400,1}]
            ,action = [{opp_side,base_skill,5102}]
        }
    };
get(ai_rule, 90035) ->
    {ok, 
        #npc_ai_rule{
            id = 90035
            ,type = 1
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,base_skill,<<"include">>,5102,1},{self,hp,<<">=">>,40,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,hp,<<">">>,20,1}]
            ,action = [{opp_side,base_skill,5102}]
        }
    };
get(ai_rule, 100040) ->
    {ok, 
        #npc_ai_rule{
            id = 100040
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,706650},{self,talk,[<<"当海盗的感觉就是爽！">>]}]
        }
    };
get(ai_rule, 100041) ->
    {ok, 
        #npc_ai_rule{
            id = 100041
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600015}]
        }
    };
get(ai_rule, 110000) ->
    {ok, 
        #npc_ai_rule{
            id = 110000
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601004}]
        }
    };
get(ai_rule, 110001) ->
    {ok, 
        #npc_ai_rule{
            id = 110001
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601005}]
        }
    };
get(ai_rule, 110002) ->
    {ok, 
        #npc_ai_rule{
            id = 110002
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601006}]
        }
    };
get(ai_rule, 110003) ->
    {ok, 
        #npc_ai_rule{
            id = 110003
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601007}]
        }
    };
get(ai_rule, 110004) ->
    {ok, 
        #npc_ai_rule{
            id = 110004
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601008}]
        }
    };
get(ai_rule, 110005) ->
    {ok, 
        #npc_ai_rule{
            id = 110005
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601009}]
        }
    };
get(ai_rule, 110006) ->
    {ok, 
        #npc_ai_rule{
            id = 110006
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601010}]
        }
    };
get(ai_rule, 110007) ->
    {ok, 
        #npc_ai_rule{
            id = 110007
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601011}]
        }
    };
get(ai_rule, 110008) ->
    {ok, 
        #npc_ai_rule{
            id = 110008
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601012}]
        }
    };
get(ai_rule, 110009) ->
    {ok, 
        #npc_ai_rule{
            id = 110009
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601013}]
        }
    };
get(ai_rule, 110010) ->
    {ok, 
        #npc_ai_rule{
            id = 110010
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601014}]
        }
    };
get(ai_rule, 110011) ->
    {ok, 
        #npc_ai_rule{
            id = 110011
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601015}]
        }
    };
get(ai_rule, 110012) ->
    {ok, 
        #npc_ai_rule{
            id = 110012
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601016}]
        }
    };
get(ai_rule, 110013) ->
    {ok, 
        #npc_ai_rule{
            id = 110013
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601017}]
        }
    };
get(ai_rule, 110014) ->
    {ok, 
        #npc_ai_rule{
            id = 110014
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601018}]
        }
    };
get(ai_rule, 110015) ->
    {ok, 
        #npc_ai_rule{
            id = 110015
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601019}]
        }
    };
get(ai_rule, 110016) ->
    {ok, 
        #npc_ai_rule{
            id = 110016
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601020}]
        }
    };
get(ai_rule, 110017) ->
    {ok, 
        #npc_ai_rule{
            id = 110017
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601021}]
        }
    };
get(ai_rule, 110018) ->
    {ok, 
        #npc_ai_rule{
            id = 110018
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601022}]
        }
    };
get(ai_rule, 110019) ->
    {ok, 
        #npc_ai_rule{
            id = 110019
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601023}]
        }
    };
get(ai_rule, 110020) ->
    {ok, 
        #npc_ai_rule{
            id = 110020
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601024}]
        }
    };
get(ai_rule, 110021) ->
    {ok, 
        #npc_ai_rule{
            id = 110021
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601025}]
        }
    };
get(ai_rule, 110022) ->
    {ok, 
        #npc_ai_rule{
            id = 110022
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601026}]
        }
    };
get(ai_rule, 110023) ->
    {ok, 
        #npc_ai_rule{
            id = 110023
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod9">>,1,1}]
            ,action = [{self,skill,70193},{self,talk,[<<"螃蟹可不是随便煮的喔">>]}]
        }
    };
get(ai_rule, 110024) ->
    {ok, 
        #npc_ai_rule{
            id = 110024
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self_side,skill,70204},{self,talk,[<<"出现吧，我的仰慕者们">>]}]
        }
    };
get(ai_rule, 110025) ->
    {ok, 
        #npc_ai_rule{
            id = 110025
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{self_side,skill,70296},{self,talk,[<<"女王需要你们的牺牲">>]}]
        }
    };
get(ai_rule, 110026) ->
    {ok, 
        #npc_ai_rule{
            id = 110026
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{self_side,skill,70297},{self,talk,[<<"女王需要你们的牺牲">>]}]
        }
    };
get(ai_rule, 110027) ->
    {ok, 
        #npc_ai_rule{
            id = 110027
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,1,1}]
            ,action = [{opp_side,skill,70585},{self,talk,[<<"来，无知的人类，尝尝大爷的黑墨汁">>]}]
        }
    };
get(ai_rule, 100042) ->
    {ok, 
        #npc_ai_rule{
            id = 100042
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100043) ->
    {ok, 
        #npc_ai_rule{
            id = 100043
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100044) ->
    {ok, 
        #npc_ai_rule{
            id = 100044
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100045) ->
    {ok, 
        #npc_ai_rule{
            id = 100045
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100046) ->
    {ok, 
        #npc_ai_rule{
            id = 100046
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600001},{self,talk,[<<"别想过去！">>]}]
        }
    };
get(ai_rule, 100047) ->
    {ok, 
        #npc_ai_rule{
            id = 100047
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"让我打死吧！">>]},{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100048) ->
    {ok, 
        #npc_ai_rule{
            id = 100048
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600001},{self,talk,[<<"让我来教训教训你">>]}]
        }
    };
get(ai_rule, 100049) ->
    {ok, 
        #npc_ai_rule{
            id = 100049
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100050) ->
    {ok, 
        #npc_ai_rule{
            id = 100050
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600003},{self,talk,[<<"别想打败我！">>]}]
        }
    };
get(ai_rule, 100051) ->
    {ok, 
        #npc_ai_rule{
            id = 100051
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"有本事你咬我啊">>]},{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100052) ->
    {ok, 
        #npc_ai_rule{
            id = 100052
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600003},{self,talk,[<<"我越战越勇！">>]}]
        }
    };
get(ai_rule, 100053) ->
    {ok, 
        #npc_ai_rule{
            id = 100053
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100054) ->
    {ok, 
        #npc_ai_rule{
            id = 100054
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"你让我准备准备！">>]},{self,skill,600006}]
        }
    };
get(ai_rule, 100055) ->
    {ok, 
        #npc_ai_rule{
            id = 100055
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"士兵永远不退缩！">>]},{opp_side,skill,600007}]
        }
    };
get(ai_rule, 100056) ->
    {ok, 
        #npc_ai_rule{
            id = 100056
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600004}]
        }
    };
get(ai_rule, 100057) ->
    {ok, 
        #npc_ai_rule{
            id = 100057
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"嘿嘿我还会魔法~">>]},{opp_side,skill,600005}]
        }
    };
get(ai_rule, 100058) ->
    {ok, 
        #npc_ai_rule{
            id = 100058
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"我要抓你回去！">>]},{opp_side,skill,600004}]
        }
    };
get(ai_rule, 100059) ->
    {ok, 
        #npc_ai_rule{
            id = 100059
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,fighter_type,<<"=">>,2,1}]
            ,action = [{suit_tar,skill,600008},{self,talk,[<<"先收拾完你的伙伴再收拾你！">>]}]
        }
    };
get(ai_rule, 100060) ->
    {ok, 
        #npc_ai_rule{
            id = 100060
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,sex,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,600009},{self,talk,[<<"女孩子就不要那么大火气嘛~">>]}]
        }
    };
get(ai_rule, 100061) ->
    {ok, 
        #npc_ai_rule{
            id = 100061
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,sex,<<"=">>,1,1}]
            ,action = [{suit_tar,skill,600009},{self,talk,[<<"这么可爱的一定是个男孩~">>]}]
        }
    };
get(ai_rule, 100062) ->
    {ok, 
        #npc_ai_rule{
            id = 100062
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,600010},{self,talk,[<<"快出来吧，我的孩子">>]}]
        }
    };
get(ai_rule, 100063) ->
    {ok, 
        #npc_ai_rule{
            id = 100063
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600011},{self,talk,[<<"和你的朋友在地狱里见吧！">>]}]
        }
    };
get(ai_rule, 100064) ->
    {ok, 
        #npc_ai_rule{
            id = 100064
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,10,1},{suit_tar,hp,<<">=">>,0,1}]
            ,action = [{self,talk,[<<"我不甘心被小鬼头打败！">>]},{opp_side,skill,600008}]
        }
    };
get(ai_rule, 100065) ->
    {ok, 
        #npc_ai_rule{
            id = 100065
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600008}]
        }
    };
get(ai_rule, 100066) ->
    {ok, 
        #npc_ai_rule{
            id = 100066
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"不要被眼前所见蒙蔽了双眼。">>]},{self,skill,600012}]
        }
    };
get(ai_rule, 100067) ->
    {ok, 
        #npc_ai_rule{
            id = 100067
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"权力会使人堕落。">>]},{self,skill,600013}]
        }
    };
get(ai_rule, 100068) ->
    {ok, 
        #npc_ai_rule{
            id = 100068
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600015}]
        }
    };
get(ai_rule, 100069) ->
    {ok, 
        #npc_ai_rule{
            id = 100069
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"别再执迷不悟了人类。">>]},{self,skill,600014}]
        }
    };
get(ai_rule, 100070) ->
    {ok, 
        #npc_ai_rule{
            id = 100070
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600015}]
        }
    };
get(ai_rule, 100071) ->
    {ok, 
        #npc_ai_rule{
            id = 100071
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"可怜的人类，我只能帮你到这。">>]},{opp_side,skill,600016}]
        }
    };
get(ai_rule, 100072) ->
    {ok, 
        #npc_ai_rule{
            id = 100072
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600009}]
        }
    };
get(ai_rule, 100073) ->
    {ok, 
        #npc_ai_rule{
            id = 100073
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600015}]
        }
    };
get(ai_rule, 100074) ->
    {ok, 
        #npc_ai_rule{
            id = 100074
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"人类啊，睁开迷雾中的双眼吧">>]},{opp_side,skill,600015}]
        }
    };
get(ai_rule, 100075) ->
    {ok, 
        #npc_ai_rule{
            id = 100075
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"被你发现啦~~">>]},{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100076) ->
    {ok, 
        #npc_ai_rule{
            id = 100076
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"这里全是财富和宝藏哦~">>]},{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100077) ->
    {ok, 
        #npc_ai_rule{
            id = 100077
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"你发现它们了吗~宝藏哦！">>]},{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100078) ->
    {ok, 
        #npc_ai_rule{
            id = 100078
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"以后要常来看我们哦~">>]},{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100079) ->
    {ok, 
        #npc_ai_rule{
            id = 100079
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"你找到宝藏了吗？嘻嘻">>]},{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100080) ->
    {ok, 
        #npc_ai_rule{
            id = 100080
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"加油~看好你哦！">>]},{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100081) ->
    {ok, 
        #npc_ai_rule{
            id = 100081
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self,talk,[<<"伙计，你踩到我的头了！">>]},{opp_side,skill,600017}]
        }
    };
get(ai_rule, 100082) ->
    {ok, 
        #npc_ai_rule{
            id = 100082
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"我卑贱的身体里满是愤怒！">>]},{opp_side,skill,600018}]
        }
    };
get(ai_rule, 100083) ->
    {ok, 
        #npc_ai_rule{
            id = 100083
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600019}]
        }
    };
get(ai_rule, 100084) ->
    {ok, 
        #npc_ai_rule{
            id = 100084
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600014},{self,talk,[<<"恶魔会赐予我力量！">>]}]
        }
    };
get(ai_rule, 100085) ->
    {ok, 
        #npc_ai_rule{
            id = 100085
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,career,<<"=">>,2,1}]
            ,action = [{self,talk,[<<"听说刺客的肉总是特别好吃">>]},{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100086) ->
    {ok, 
        #npc_ai_rule{
            id = 100086
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,career,<<"=">>,3,1}]
            ,action = [{self,talk,[<<"我最讨厌多管闲事的贤者！">>]},{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100087) ->
    {ok, 
        #npc_ai_rule{
            id = 100087
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,career,<<"=">>,5,1}]
            ,action = [{self,talk,[<<"我看到了，铠甲下面你已经发抖的身体……">>]},{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100088) ->
    {ok, 
        #npc_ai_rule{
            id = 100088
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600020}]
        }
    };
get(ai_rule, 100089) ->
    {ok, 
        #npc_ai_rule{
            id = 100089
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"我的怒火将布满荒野！">>]},{self_side,skill,600021}]
        }
    };
get(ai_rule, 100090) ->
    {ok, 
        #npc_ai_rule{
            id = 100090
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"黑暗将笼罩着你！">>]},{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100091) ->
    {ok, 
        #npc_ai_rule{
            id = 100091
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self,talk,[<<"邪恶的力量正待复苏……">>]},{opp_side,skill,600022}]
        }
    };
get(ai_rule, 100092) ->
    {ok, 
        #npc_ai_rule{
            id = 100092
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"恐惧会让你闭嘴！">>]},{opp_side,skill,600023}]
        }
    };
get(ai_rule, 100093) ->
    {ok, 
        #npc_ai_rule{
            id = 100093
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600024}]
        }
    };
get(ai_rule, 100094) ->
    {ok, 
        #npc_ai_rule{
            id = 100094
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600014},{self,talk,[<<"来吧！力量！！">>]}]
        }
    };
get(ai_rule, 100095) ->
    {ok, 
        #npc_ai_rule{
            id = 100095
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"从你的眼里，我看到了我年轻时的样子">>]},{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100096) ->
    {ok, 
        #npc_ai_rule{
            id = 100096
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"我要把你捏得粉碎！">>]},{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100097) ->
    {ok, 
        #npc_ai_rule{
            id = 100097
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"臣服于我吧，或者受死！">>]},{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100098) ->
    {ok, 
        #npc_ai_rule{
            id = 100098
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600026}]
        }
    };
get(ai_rule, 100099) ->
    {ok, 
        #npc_ai_rule{
            id = 100099
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"有朝一日，我们会占领整个世界">>]},{self_side,skill,600021}]
        }
    };
get(ai_rule, 100100) ->
    {ok, 
        #npc_ai_rule{
            id = 100100
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100101) ->
    {ok, 
        #npc_ai_rule{
            id = 100101
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self,talk,[<<"希芙女神真的抛弃我们了吗……">>]},{self,skill,600027}]
        }
    };
get(ai_rule, 100102) ->
    {ok, 
        #npc_ai_rule{
            id = 100102
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"大地啊，颤抖吧！">>]},{opp_side,skill,600028}]
        }
    };
get(ai_rule, 100103) ->
    {ok, 
        #npc_ai_rule{
            id = 100103
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600029}]
        }
    };
get(ai_rule, 100104) ->
    {ok, 
        #npc_ai_rule{
            id = 100104
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600014},{self,talk,[<<"希芙的力量是不会消失的！">>]}]
        }
    };
get(ai_rule, 100105) ->
    {ok, 
        #npc_ai_rule{
            id = 100105
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"绝不能让石灵兵的尊严受损！">>]},{opp_side,skill,600030}]
        }
    };
get(ai_rule, 100106) ->
    {ok, 
        #npc_ai_rule{
            id = 100106
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"誓死也要捍卫希芙的神坛！">>]},{opp_side,skill,600030}]
        }
    };
get(ai_rule, 100107) ->
    {ok, 
        #npc_ai_rule{
            id = 100107
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"我的神已经离开我们太久了……">>]},{opp_side,skill,600030}]
        }
    };
get(ai_rule, 100108) ->
    {ok, 
        #npc_ai_rule{
            id = 100108
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600031}]
        }
    };
get(ai_rule, 100109) ->
    {ok, 
        #npc_ai_rule{
            id = 100109
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"年轻人，你很迷茫啊……">>]},{self_side,skill,600021}]
        }
    };
get(ai_rule, 100110) ->
    {ok, 
        #npc_ai_rule{
            id = 100110
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600030}]
        }
    };
get(ai_rule, 100111) ->
    {ok, 
        #npc_ai_rule{
            id = 100111
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"人类，你们为何打扰我？">>]},{opp_side,skill,600032}]
        }
    };
get(ai_rule, 100112) ->
    {ok, 
        #npc_ai_rule{
            id = 100112
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,talk,[<<"你们为何如此暴躁？">>]},{self,skill,600033}]
        }
    };
get(ai_rule, 100113) ->
    {ok, 
        #npc_ai_rule{
            id = 100113
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,10,1}]
            ,action = [{self,talk,[<<"愚蠢的人类啊，你们已经忘记神的存在了">>]},{opp_side,skill,600034}]
        }
    };
get(ai_rule, 100114) ->
    {ok, 
        #npc_ai_rule{
            id = 100114
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16109,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{self,talk,[<<"不可饶恕！">>]},{opp_side,skill,600035}]
        }
    };
get(ai_rule, 100115) ->
    {ok, 
        #npc_ai_rule{
            id = 100115
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16110,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{self,talk,[<<"告诉你，你激怒我了！">>]},{self,skill,600036}]
        }
    };
get(ai_rule, 100116) ->
    {ok, 
        #npc_ai_rule{
            id = 100116
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{self,talk,[<<"那我就代表希芙惩罚你！">>]},{opp_side,skill,600034}]
        }
    };
get(ai_rule, 100117) ->
    {ok, 
        #npc_ai_rule{
            id = 100117
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,25,1}]
            ,action = [{opp_side,skill,600035}]
        }
    };
get(ai_rule, 100118) ->
    {ok, 
        #npc_ai_rule{
            id = 100118
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{self,skill,600027},{self,talk,[<<"你感受下守护者的力量吧！">>]}]
        }
    };
get(ai_rule, 100119) ->
    {ok, 
        #npc_ai_rule{
            id = 100119
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod2">>,0,1}]
            ,action = [{opp_side,skill,600032},{self,talk,[<<"希芙的神坛不容你们亵渎！">>]}]
        }
    };
get(ai_rule, 100120) ->
    {ok, 
        #npc_ai_rule{
            id = 100120
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16110,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{self,talk,[<<"你竟然打死了我的小伙伴！">>]},{opp_side,skill,600037}]
        }
    };
get(ai_rule, 100121) ->
    {ok, 
        #npc_ai_rule{
            id = 100121
            ,type = 0
            ,repeat = 1
            ,prob = 15
            ,condition = [{self_side,id,<<"=">>,16110,1},{suit_tar,hp,<<">=">>,0,1}]
            ,action = [{self_side,skill,600038}]
        }
    };
get(ai_rule, 100122) ->
    {ok, 
        #npc_ai_rule{
            id = 100122
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,10332,1},{suit_tar,hp,<<"<=">>,20,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{self,talk,[<<"你们休想伤害神的守卫者！">>]},{suit_tar,skill,720001}]
        }
    };
get(ai_rule, 100123) ->
    {ok, 
        #npc_ai_rule{
            id = 100123
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16109,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{self,talk,[<<"你们竟然打死了我的小伙伴！我要报仇！！">>]},{self,skill,600039}]
        }
    };
get(ai_rule, 100124) ->
    {ok, 
        #npc_ai_rule{
            id = 100124
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600032}]
        }
    };
get(ai_rule, 100125) ->
    {ok, 
        #npc_ai_rule{
            id = 100125
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{self_side,id,<<"=">>,10332,1},{suit_tar,hp,<<">=">>,0,1}]
            ,action = [{opp_side,talk,[<<"你们是怎么闯进来的！？">>]},{opp_side,skill,600040}]
        }
    };
get(ai_rule, 100126) ->
    {ok, 
        #npc_ai_rule{
            id = 100126
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,talk,[<<"吃我的无敌大群杀啦！！！！">>]},{opp_side,skill,600041}]
        }
    };
get(ai_rule, 100127) ->
    {ok, 
        #npc_ai_rule{
            id = 100127
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,sex,<<"=">>,0,1}]
            ,action = [{self,talk,[<<"又有送上门来的女女哦">>]},{self,skill,600042}]
        }
    };
get(ai_rule, 100128) ->
    {ok, 
        #npc_ai_rule{
            id = 100128
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,sex,<<"=">>,1,1}]
            ,action = [{self,talk,[<<"我看到男的就不爽！">>]},{self,skill,600043}]
        }
    };
get(ai_rule, 100129) ->
    {ok, 
        #npc_ai_rule{
            id = 100129
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"嘶嘶-嘶嘶-">>]},{opp_side,skill,600044}]
        }
    };
get(ai_rule, 100130) ->
    {ok, 
        #npc_ai_rule{
            id = 100130
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"吱吱-吱吱-">>]},{opp_side,skill,600045}]
        }
    };
get(ai_rule, 100131) ->
    {ok, 
        #npc_ai_rule{
            id = 100131
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600045}]
        }
    };
get(ai_rule, 100132) ->
    {ok, 
        #npc_ai_rule{
            id = 100132
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"我就是看不惯你这张嘲讽脸！">>]},{opp_side,skill,600046}]
        }
    };
get(ai_rule, 100133) ->
    {ok, 
        #npc_ai_rule{
            id = 100133
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600047},{self,talk,[<<"去吧！瞌睡虫！">>]}]
        }
    };
get(ai_rule, 100134) ->
    {ok, 
        #npc_ai_rule{
            id = 100134
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{self,skill,600048}]
        }
    };
get(ai_rule, 100135) ->
    {ok, 
        #npc_ai_rule{
            id = 100135
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"唧唧-唧唧-">>]},{opp_side,skill,600045}]
        }
    };
get(ai_rule, 100136) ->
    {ok, 
        #npc_ai_rule{
            id = 100136
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{self,hp,<<">=">>,20,1}]
            ,action = [{self,talk,[<<"等我休息会儿在和你们打">>]},{self,skill,600049}]
        }
    };
get(ai_rule, 100137) ->
    {ok, 
        #npc_ai_rule{
            id = 100137
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600045}]
        }
    };
get(ai_rule, 100138) ->
    {ok, 
        #npc_ai_rule{
            id = 100138
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,talk,[<<"这下你可躲不掉了……">>]},{opp_side,skill,600050}]
        }
    };
get(ai_rule, 100139) ->
    {ok, 
        #npc_ai_rule{
            id = 100139
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"不要怪我，我只是想更好的活下去……">>]},{self,skill,600051}]
        }
    };
get(ai_rule, 100140) ->
    {ok, 
        #npc_ai_rule{
            id = 100140
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"别打我…… ">>]},{self,skill,600052}]
        }
    };
get(ai_rule, 100141) ->
    {ok, 
        #npc_ai_rule{
            id = 100141
            ,type = 0
            ,repeat = 1
            ,prob = 65
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"秒杀！">>]},{opp_side,skill,600053}]
        }
    };
get(ai_rule, 100142) ->
    {ok, 
        #npc_ai_rule{
            id = 100142
            ,type = 0
            ,repeat = 1
            ,prob = 45
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"求我我会让你们死得爽一点">>]},{opp_side,skill,600054}]
        }
    };
get(ai_rule, 100143) ->
    {ok, 
        #npc_ai_rule{
            id = 100143
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600054}]
        }
    };
get(ai_rule, 100144) ->
    {ok, 
        #npc_ai_rule{
            id = 100144
            ,type = 0
            ,repeat = 1
            ,prob = 75
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"我就是长了一张嘲讽脸！">>]},{opp_side,skill,600046}]
        }
    };
get(ai_rule, 100145) ->
    {ok, 
        #npc_ai_rule{
            id = 100145
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600047},{self,talk,[<<"哼，你们爽完了该我爽了！">>]}]
        }
    };
get(ai_rule, 100146) ->
    {ok, 
        #npc_ai_rule{
            id = 100146
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{self,skill,600048}]
        }
    };
get(ai_rule, 100147) ->
    {ok, 
        #npc_ai_rule{
            id = 100147
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600054}]
        }
    };
get(ai_rule, 100148) ->
    {ok, 
        #npc_ai_rule{
            id = 100148
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{self,hp,<<">=">>,20,1}]
            ,action = [{self,talk,[<<"我是这沙漠中的骄子！">>]},{self,skill,600049}]
        }
    };
get(ai_rule, 100149) ->
    {ok, 
        #npc_ai_rule{
            id = 100149
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600054}]
        }
    };
get(ai_rule, 100150) ->
    {ok, 
        #npc_ai_rule{
            id = 100150
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,talk,[<<"沙漠中的死灵在召唤你！">>]},{opp_side,skill,600055}]
        }
    };
get(ai_rule, 100151) ->
    {ok, 
        #npc_ai_rule{
            id = 100151
            ,type = 0
            ,repeat = 0
            ,prob = 45
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,600048}]
        }
    };
get(ai_rule, 100152) ->
    {ok, 
        #npc_ai_rule{
            id = 100152
            ,type = 0
            ,repeat = 0
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"别打我…… ">>]},{opp_side,skill,600055}]
        }
    };
get(ai_rule, 100153) ->
    {ok, 
        #npc_ai_rule{
            id = 100153
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"秒杀！">>]},{opp_side,skill,600056}]
        }
    };
get(ai_rule, 100154) ->
    {ok, 
        #npc_ai_rule{
            id = 100154
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"求我我会让你们死得爽一点">>]},{opp_side,skill,600057}]
        }
    };
get(ai_rule, 100155) ->
    {ok, 
        #npc_ai_rule{
            id = 100155
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600057}]
        }
    };
get(ai_rule, 100156) ->
    {ok, 
        #npc_ai_rule{
            id = 100156
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"我就是长了一张嘲讽脸！">>]},{opp_side,skill,600046}]
        }
    };
get(ai_rule, 100157) ->
    {ok, 
        #npc_ai_rule{
            id = 100157
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600058},{self,talk,[<<"哼，你们爽完了该我爽了！">>]}]
        }
    };
get(ai_rule, 100158) ->
    {ok, 
        #npc_ai_rule{
            id = 100158
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{self,skill,600048}]
        }
    };
get(ai_rule, 100159) ->
    {ok, 
        #npc_ai_rule{
            id = 100159
            ,type = 0
            ,repeat = 0
            ,prob = 75
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600057}]
        }
    };
get(ai_rule, 100160) ->
    {ok, 
        #npc_ai_rule{
            id = 100160
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{self,hp,<<">=">>,20,1}]
            ,action = [{self,talk,[<<"我是这沙漠中的骄子！">>]},{self,skill,600049}]
        }
    };
get(ai_rule, 100161) ->
    {ok, 
        #npc_ai_rule{
            id = 100161
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600057}]
        }
    };
get(ai_rule, 100162) ->
    {ok, 
        #npc_ai_rule{
            id = 100162
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,talk,[<<"我要让毒液渗透你们的心脏！">>]},{opp_side,skill,600059}]
        }
    };
get(ai_rule, 100163) ->
    {ok, 
        #npc_ai_rule{
            id = 100163
            ,type = 0
            ,repeat = 0
            ,prob = 45
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"我听到你的心脏还在跳动？">>]},{self,skill,600048}]
        }
    };
get(ai_rule, 100164) ->
    {ok, 
        #npc_ai_rule{
            id = 100164
            ,type = 0
            ,repeat = 0
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"尝尝我的毒物吧！">>]},{opp_side,skill,600060}]
        }
    };
get(ai_rule, 100165) ->
    {ok, 
        #npc_ai_rule{
            id = 100165
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"让你们看看我的力量">>]},{opp_side,skill,600061}]
        }
    };
get(ai_rule, 100166) ->
    {ok, 
        #npc_ai_rule{
            id = 100166
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600062}]
        }
    };
get(ai_rule, 100167) ->
    {ok, 
        #npc_ai_rule{
            id = 100167
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600062}]
        }
    };
get(ai_rule, 100168) ->
    {ok, 
        #npc_ai_rule{
            id = 100168
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"我看到你虚弱的身体，在苟延馋喘……">>]},{opp_side,skill,600063}]
        }
    };
get(ai_rule, 100169) ->
    {ok, 
        #npc_ai_rule{
            id = 100169
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600058}]
        }
    };
get(ai_rule, 100170) ->
    {ok, 
        #npc_ai_rule{
            id = 100170
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{self,skill,600048}]
        }
    };
get(ai_rule, 100171) ->
    {ok, 
        #npc_ai_rule{
            id = 100171
            ,type = 0
            ,repeat = 0
            ,prob = 75
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600062}]
        }
    };
get(ai_rule, 100172) ->
    {ok, 
        #npc_ai_rule{
            id = 100172
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{self,hp,<<">=">>,20,1}]
            ,action = [{self,talk,[<<"我要让你们的血液充满我的身体！">>]},{self,skill,600049}]
        }
    };
get(ai_rule, 100173) ->
    {ok, 
        #npc_ai_rule{
            id = 100173
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600062}]
        }
    };
get(ai_rule, 100174) ->
    {ok, 
        #npc_ai_rule{
            id = 100174
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200080,1}]
            ,action = [{self,talk,[<<"靠近我吧！让我的炽热温暖你~">>]},{self,skill,600064}]
        }
    };
get(ai_rule, 100175) ->
    {ok, 
        #npc_ai_rule{
            id = 100175
            ,type = 0
            ,repeat = 0
            ,prob = 45
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"火焰啊，燃起来吧！">>]},{opp_side,skill,600063}]
        }
    };
get(ai_rule, 100176) ->
    {ok, 
        #npc_ai_rule{
            id = 100176
            ,type = 0
            ,repeat = 0
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"好久没舒展筋骨了！">>]},{opp_side,skill,600060}]
        }
    };
get(ai_rule, 100177) ->
    {ok, 
        #npc_ai_rule{
            id = 100177
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"试试看我的宝贝吧！">>]},{opp_side,skill,600065}]
        }
    };
get(ai_rule, 100178) ->
    {ok, 
        #npc_ai_rule{
            id = 100178
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600066}]
        }
    };
get(ai_rule, 100179) ->
    {ok, 
        #npc_ai_rule{
            id = 100179
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600066}]
        }
    };
get(ai_rule, 100180) ->
    {ok, 
        #npc_ai_rule{
            id = 100180
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"谁让你们惹到毒蝎一族……">>]},{opp_side,skill,600063}]
        }
    };
get(ai_rule, 100181) ->
    {ok, 
        #npc_ai_rule{
            id = 100181
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600058}]
        }
    };
get(ai_rule, 100182) ->
    {ok, 
        #npc_ai_rule{
            id = 100182
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{self,skill,600048}]
        }
    };
get(ai_rule, 100183) ->
    {ok, 
        #npc_ai_rule{
            id = 100183
            ,type = 0
            ,repeat = 0
            ,prob = 75
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600066}]
        }
    };
get(ai_rule, 100184) ->
    {ok, 
        #npc_ai_rule{
            id = 100184
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{self,hp,<<">=">>,20,1}]
            ,action = [{self,talk,[<<"我感觉全身又充满了力量！">>]},{self,skill,600067}]
        }
    };
get(ai_rule, 100185) ->
    {ok, 
        #npc_ai_rule{
            id = 100185
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600066}]
        }
    };
get(ai_rule, 100186) ->
    {ok, 
        #npc_ai_rule{
            id = 100186
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">">>,22,1}]
            ,action = [{opp_side,skill,600068},{self,talk,[<<"就让这风沙把你们化成尸骨吧！">>]}]
        }
    };
get(ai_rule, 100187) ->
    {ok, 
        #npc_ai_rule{
            id = 100187
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,11,1}]
            ,action = [{opp_side,skill,600068}]
        }
    };
get(ai_rule, 100188) ->
    {ok, 
        #npc_ai_rule{
            id = 100188
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,21,1}]
            ,action = [{opp_side,skill,600068}]
        }
    };
get(ai_rule, 100189) ->
    {ok, 
        #npc_ai_rule{
            id = 100189
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,600069}]
        }
    };
get(ai_rule, 100190) ->
    {ok, 
        #npc_ai_rule{
            id = 100190
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1},{opp_side,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,200080,1}]
            ,action = [{self,talk,[<<"我又坚硬起来了！">>]},{suit_tar,skill,600070}]
        }
    };
get(ai_rule, 100191) ->
    {ok, 
        #npc_ai_rule{
            id = 100191
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600071}]
        }
    };
get(ai_rule, 100192) ->
    {ok, 
        #npc_ai_rule{
            id = 100192
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{opp_side,skill,600072},{self,talk,[<<"在我的毒液里沉醉吧！">>]}]
        }
    };
get(ai_rule, 100193) ->
    {ok, 
        #npc_ai_rule{
            id = 100193
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,7,1}]
            ,action = [{self,skill,600073}]
        }
    };
get(ai_rule, 100194) ->
    {ok, 
        #npc_ai_rule{
            id = 100194
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,16,1}]
            ,action = [{opp_side,skill,600074}]
        }
    };
get(ai_rule, 100195) ->
    {ok, 
        #npc_ai_rule{
            id = 100195
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1}]
            ,action = [{self,skill,600075},{self,talk,[<<"我有不死之身，哈哈哈哈……">>]}]
        }
    };
get(ai_rule, 100196) ->
    {ok, 
        #npc_ai_rule{
            id = 100196
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,45,1},{opp_side,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,200080,1}]
            ,action = [{self,talk,[<<"尽情的厮杀吧！">>]},{suit_tar,skill,600058}]
        }
    };
get(ai_rule, 100197) ->
    {ok, 
        #npc_ai_rule{
            id = 100197
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,talk,[<<"哭吧，崩溃吧，放弃吧！">>]},{self,skill,600076}]
        }
    };
get(ai_rule, 100198) ->
    {ok, 
        #npc_ai_rule{
            id = 100198
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{opp_side,skill,600077}]
        }
    };
get(ai_rule, 100199) ->
    {ok, 
        #npc_ai_rule{
            id = 100199
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self,hp,<<">=">>,50,1}]
            ,action = [{opp_side,skill,600077},{self,talk,[<<"轮到我出手了！">>]}]
        }
    };
get(ai_rule, 100200) ->
    {ok, 
        #npc_ai_rule{
            id = 100200
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{self,hp,<<"<=">>,50,1},{self,hp,<<">=">>,20,1}]
            ,action = [{opp_side,skill,600078},{self,talk,[<<"请接受来自沙漠的馈赠吧！哈哈哈哈……">>]}]
        }
    };
get(ai_rule, 100201) ->
    {ok, 
        #npc_ai_rule{
            id = 100201
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{opp_side,skill,600078}]
        }
    };
get(ai_rule, 100202) ->
    {ok, 
        #npc_ai_rule{
            id = 100202
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod2">>,1,1},{opp_side,buff,<<"include">>,200080,1}]
            ,action = [{opp_side,skill,600079}]
        }
    };
get(ai_rule, 100203) ->
    {ok, 
        #npc_ai_rule{
            id = 100203
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{self,talk,[<<"怎么？打不动了吗？">>]},{opp_side,skill,600080}]
        }
    };
get(ai_rule, 100204) ->
    {ok, 
        #npc_ai_rule{
            id = 100204
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,0,1},{opp_side,buff,<<"include">>,200080,1}]
            ,action = [{self,talk,[<<"说说看，你到底厉害在哪里啊？">>]},{self,skill,600058}]
        }
    };
get(ai_rule, 100205) ->
    {ok, 
        #npc_ai_rule{
            id = 100205
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod2">>,0,1}]
            ,action = [{opp_side,skill,600081}]
        }
    };
get(ai_rule, 100206) ->
    {ok, 
        #npc_ai_rule{
            id = 100206
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{self,talk,[<<"你为什么放弃治疗？">>]},{opp_side,skill,600082}]
        }
    };
get(ai_rule, 100207) ->
    {ok, 
        #npc_ai_rule{
            id = 100207
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{self,talk,[<<"夜晚就是为了让人安睡的！">>]},{opp_side,skill,600047}]
        }
    };
get(ai_rule, 100208) ->
    {ok, 
        #npc_ai_rule{
            id = 100208
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600082}]
        }
    };
get(ai_rule, 100209) ->
    {ok, 
        #npc_ai_rule{
            id = 100209
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600083}]
        }
    };
get(ai_rule, 100210) ->
    {ok, 
        #npc_ai_rule{
            id = 100210
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,talk,[<<"为了捍卫这片安静的树林！">>]},{opp_side,skill,600084}]
        }
    };
get(ai_rule, 100211) ->
    {ok, 
        #npc_ai_rule{
            id = 100211
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,talk,[<<"快给我安静下来！">>]},{opp_side,skill,600085}]
        }
    };
get(ai_rule, 100212) ->
    {ok, 
        #npc_ai_rule{
            id = 100212
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,skill,600086}]
        }
    };
get(ai_rule, 100213) ->
    {ok, 
        #npc_ai_rule{
            id = 100213
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,talk,[<<"树根之中蕴含着万物复苏的能量……">>]},{self,skill,600097}]
        }
    };
get(ai_rule, 100214) ->
    {ok, 
        #npc_ai_rule{
            id = 100214
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{self,hp,<<"<=">>,10,1}]
            ,action = [{self,talk,[<<"我还会再生的！">>]},{self,skill,600097}]
        }
    };
get(ai_rule, 100215) ->
    {ok, 
        #npc_ai_rule{
            id = 100215
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self,skill,600087}]
        }
    };
get(ai_rule, 100216) ->
    {ok, 
        #npc_ai_rule{
            id = 100216
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,600088}]
        }
    };
get(ai_rule, 100217) ->
    {ok, 
        #npc_ai_rule{
            id = 100217
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600089}]
        }
    };
get(ai_rule, 100218) ->
    {ok, 
        #npc_ai_rule{
            id = 100218
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{self,talk,[<<"侏儒之国不需要神的怜悯！">>]},{self,skill,600090}]
        }
    };
get(ai_rule, 100219) ->
    {ok, 
        #npc_ai_rule{
            id = 100219
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,0,1}]
            ,action = [{self,talk,[<<"难道神真的已经抛弃我们了吗……">>]},{opp_side,skill,600083}]
        }
    };
get(ai_rule, 100220) ->
    {ok, 
        #npc_ai_rule{
            id = 100220
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600091}]
        }
    };
get(ai_rule, 100221) ->
    {ok, 
        #npc_ai_rule{
            id = 100221
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"我再也不相信所谓的信仰了！">>]},{opp_side,skill,600084}]
        }
    };
get(ai_rule, 100222) ->
    {ok, 
        #npc_ai_rule{
            id = 100222
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600089}]
        }
    };
get(ai_rule, 100223) ->
    {ok, 
        #npc_ai_rule{
            id = 100223
            ,type = 0
            ,repeat = 0
            ,prob = 70
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{opp_side,skill,600092}]
        }
    };
get(ai_rule, 100224) ->
    {ok, 
        #npc_ai_rule{
            id = 100224
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,600047}]
        }
    };
get(ai_rule, 100225) ->
    {ok, 
        #npc_ai_rule{
            id = 100225
            ,type = 0
            ,repeat = 0
            ,prob = 55
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,talk,[<<"我从不拒绝主动送上门来的猎物">>]},{opp_side,skill,600092}]
        }
    };
get(ai_rule, 100226) ->
    {ok, 
        #npc_ai_rule{
            id = 100226
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600093}]
        }
    };
get(ai_rule, 100227) ->
    {ok, 
        #npc_ai_rule{
            id = 100227
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,talk,[<<"这下我要让你疼了！">>]},{opp_side,skill,600094}]
        }
    };
get(ai_rule, 100228) ->
    {ok, 
        #npc_ai_rule{
            id = 100228
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,talk,[<<"还熬得住吗？">>]},{opp_side,skill,600095}]
        }
    };
get(ai_rule, 100229) ->
    {ok, 
        #npc_ai_rule{
            id = 100229
            ,type = 0
            ,repeat = 0
            ,prob = 45
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,skill,600096}]
        }
    };
get(ai_rule, 100230) ->
    {ok, 
        #npc_ai_rule{
            id = 100230
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,talk,[<<"我的潜力是无穷无尽的！">>]},{self,skill,600098}]
        }
    };
get(ai_rule, 100231) ->
    {ok, 
        #npc_ai_rule{
            id = 100231
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{self,hp,<<"<=">>,10,1}]
            ,action = [{self,talk,[<<"我的潜力是无穷无尽的！">>]},{self,skill,600098}]
        }
    };
get(ai_rule, 100232) ->
    {ok, 
        #npc_ai_rule{
            id = 100232
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self,skill,600099}]
        }
    };
get(ai_rule, 100233) ->
    {ok, 
        #npc_ai_rule{
            id = 100233
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,600100}]
        }
    };
get(ai_rule, 100234) ->
    {ok, 
        #npc_ai_rule{
            id = 100234
            ,type = 0
            ,repeat = 1
            ,prob = 55
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600101}]
        }
    };
get(ai_rule, 100235) ->
    {ok, 
        #npc_ai_rule{
            id = 100235
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{self,talk,[<<"绝不妥协！">>]},{self,skill,600102}]
        }
    };
get(ai_rule, 100236) ->
    {ok, 
        #npc_ai_rule{
            id = 100236
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,0,1}]
            ,action = [{self,talk,[<<"战斗应该结束了……">>]},{opp_side,skill,600093}]
        }
    };
get(ai_rule, 100237) ->
    {ok, 
        #npc_ai_rule{
            id = 100237
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600103}]
        }
    };
get(ai_rule, 100238) ->
    {ok, 
        #npc_ai_rule{
            id = 100238
            ,type = 0
            ,repeat = 0
            ,prob = 55
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"今天我就要你死！">>]},{opp_side,skill,600094}]
        }
    };
get(ai_rule, 100239) ->
    {ok, 
        #npc_ai_rule{
            id = 100239
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600101}]
        }
    };
get(ai_rule, 100240) ->
    {ok, 
        #npc_ai_rule{
            id = 100240
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{self,talk,[<<"你是不是看不起我这样的女孩子！">>]},{opp_side,skill,600104}]
        }
    };
get(ai_rule, 100241) ->
    {ok, 
        #npc_ai_rule{
            id = 100241
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{self,talk,[<<"在我的怀抱里睡去吧……">>]},{opp_side,skill,600047}]
        }
    };
get(ai_rule, 100242) ->
    {ok, 
        #npc_ai_rule{
            id = 100242
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600105}]
        }
    };
get(ai_rule, 100243) ->
    {ok, 
        #npc_ai_rule{
            id = 100243
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600104}]
        }
    };
get(ai_rule, 100244) ->
    {ok, 
        #npc_ai_rule{
            id = 100244
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,talk,[<<"你相信爱情吗？">>]},{opp_side,skill,600106}]
        }
    };
get(ai_rule, 100245) ->
    {ok, 
        #npc_ai_rule{
            id = 100245
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,talk,[<<"哭哭……你怎么忍心对我下这么重的手？">>]},{opp_side,skill,600107}]
        }
    };
get(ai_rule, 100246) ->
    {ok, 
        #npc_ai_rule{
            id = 100246
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,skill,600108}]
        }
    };
get(ai_rule, 100247) ->
    {ok, 
        #npc_ai_rule{
            id = 100247
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,talk,[<<"看我如何永葆青春">>]},{self,skill,600109}]
        }
    };
get(ai_rule, 100248) ->
    {ok, 
        #npc_ai_rule{
            id = 100248
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{self,hp,<<"<=">>,10,1}]
            ,action = [{self,talk,[<<"我的美貌与力量同在！">>]},{self,skill,600109}]
        }
    };
get(ai_rule, 100249) ->
    {ok, 
        #npc_ai_rule{
            id = 100249
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self,skill,600123}]
        }
    };
get(ai_rule, 100250) ->
    {ok, 
        #npc_ai_rule{
            id = 100250
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,600124}]
        }
    };
get(ai_rule, 100251) ->
    {ok, 
        #npc_ai_rule{
            id = 100251
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600106}]
        }
    };
get(ai_rule, 100252) ->
    {ok, 
        #npc_ai_rule{
            id = 100252
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{self,talk,[<<"别再和我说相不相信爱情的话了！">>]},{self,skill,600123}]
        }
    };
get(ai_rule, 100253) ->
    {ok, 
        #npc_ai_rule{
            id = 100253
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,0,1}]
            ,action = [{self,talk,[<<"放心吧，我的毒见效很快的……">>]},{opp_side,skill,600125}]
        }
    };
get(ai_rule, 100254) ->
    {ok, 
        #npc_ai_rule{
            id = 100254
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600126}]
        }
    };
get(ai_rule, 100255) ->
    {ok, 
        #npc_ai_rule{
            id = 100255
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"我对你太失望了！">>]},{opp_side,skill,600127}]
        }
    };
get(ai_rule, 100256) ->
    {ok, 
        #npc_ai_rule{
            id = 100256
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600128}]
        }
    };
get(ai_rule, 100257) ->
    {ok, 
        #npc_ai_rule{
            id = 100257
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{self,talk,[<<"愿黑暗笼罩着你！">>]},{opp_side,skill,600129}]
        }
    };
get(ai_rule, 100258) ->
    {ok, 
        #npc_ai_rule{
            id = 100258
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,600047}]
        }
    };
get(ai_rule, 100259) ->
    {ok, 
        #npc_ai_rule{
            id = 100259
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600130}]
        }
    };
get(ai_rule, 100260) ->
    {ok, 
        #npc_ai_rule{
            id = 100260
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600131}]
        }
    };
get(ai_rule, 100261) ->
    {ok, 
        #npc_ai_rule{
            id = 100261
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,talk,[<<"我就是看你不爽！">>]},{opp_side,skill,600132}]
        }
    };
get(ai_rule, 100262) ->
    {ok, 
        #npc_ai_rule{
            id = 100262
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,talk,[<<"让我看看你脆弱的灵魂">>]},{opp_side,skill,600131}]
        }
    };
get(ai_rule, 100263) ->
    {ok, 
        #npc_ai_rule{
            id = 100263
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,skill,600133}]
        }
    };
get(ai_rule, 100264) ->
    {ok, 
        #npc_ai_rule{
            id = 100264
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600134}]
        }
    };
get(ai_rule, 100265) ->
    {ok, 
        #npc_ai_rule{
            id = 100265
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{self,hp,<<"<=">>,10,1}]
            ,action = [{self,talk,[<<"我觉得有点冷……">>]},{self,skill,600134}]
        }
    };
get(ai_rule, 100266) ->
    {ok, 
        #npc_ai_rule{
            id = 100266
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self,skill,600135}]
        }
    };
get(ai_rule, 100267) ->
    {ok, 
        #npc_ai_rule{
            id = 100267
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,600136}]
        }
    };
get(ai_rule, 100268) ->
    {ok, 
        #npc_ai_rule{
            id = 100268
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600131}]
        }
    };
get(ai_rule, 100269) ->
    {ok, 
        #npc_ai_rule{
            id = 100269
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{self,talk,[<<"快从我的领地里离开！">>]},{self,skill,600137}]
        }
    };
get(ai_rule, 100270) ->
    {ok, 
        #npc_ai_rule{
            id = 100270
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,0,1}]
            ,action = [{self,talk,[<<"别逼我发火！">>]},{opp_side,skill,600138}]
        }
    };
get(ai_rule, 100271) ->
    {ok, 
        #npc_ai_rule{
            id = 100271
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600139}]
        }
    };
get(ai_rule, 100272) ->
    {ok, 
        #npc_ai_rule{
            id = 100272
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600140}]
        }
    };
get(ai_rule, 100273) ->
    {ok, 
        #npc_ai_rule{
            id = 100273
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600142}]
        }
    };
get(ai_rule, 100274) ->
    {ok, 
        #npc_ai_rule{
            id = 100274
            ,type = 0
            ,repeat = 0
            ,prob = 70
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{opp_side,skill,600142}]
        }
    };
get(ai_rule, 100275) ->
    {ok, 
        #npc_ai_rule{
            id = 100275
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,600047}]
        }
    };
get(ai_rule, 100276) ->
    {ok, 
        #npc_ai_rule{
            id = 100276
            ,type = 0
            ,repeat = 0
            ,prob = 55
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,talk,[<<"我们……需要你……">>]},{opp_side,skill,600142}]
        }
    };
get(ai_rule, 100277) ->
    {ok, 
        #npc_ai_rule{
            id = 100277
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600143}]
        }
    };
get(ai_rule, 100278) ->
    {ok, 
        #npc_ai_rule{
            id = 100278
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,talk,[<<"让你看看来自深渊的力量！">>]},{opp_side,skill,600144}]
        }
    };
get(ai_rule, 100279) ->
    {ok, 
        #npc_ai_rule{
            id = 100279
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{opp_side,skill,600145}]
        }
    };
get(ai_rule, 100280) ->
    {ok, 
        #npc_ai_rule{
            id = 100280
            ,type = 0
            ,repeat = 0
            ,prob = 45
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,skill,600146}]
        }
    };
get(ai_rule, 100281) ->
    {ok, 
        #npc_ai_rule{
            id = 100281
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,talk,[<<"绝望吧！少年！">>]},{self,skill,600147}]
        }
    };
get(ai_rule, 100282) ->
    {ok, 
        #npc_ai_rule{
            id = 100282
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{self,hp,<<"<=">>,10,1}]
            ,action = [{self,talk,[<<"绝望吧！少年！">>]},{self,skill,600147}]
        }
    };
get(ai_rule, 100283) ->
    {ok, 
        #npc_ai_rule{
            id = 100283
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self,skill,600148}]
        }
    };
get(ai_rule, 100284) ->
    {ok, 
        #npc_ai_rule{
            id = 100284
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,600149}]
        }
    };
get(ai_rule, 100285) ->
    {ok, 
        #npc_ai_rule{
            id = 100285
            ,type = 0
            ,repeat = 1
            ,prob = 55
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600150}]
        }
    };
get(ai_rule, 100286) ->
    {ok, 
        #npc_ai_rule{
            id = 100286
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{self,talk,[<<"深渊的力量笼罩着我！">>]},{self,skill,600151}]
        }
    };
get(ai_rule, 100287) ->
    {ok, 
        #npc_ai_rule{
            id = 100287
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,0,1}]
            ,action = [{self,talk,[<<"受死吧！">>]},{opp_side,skill,600143}]
        }
    };
get(ai_rule, 100288) ->
    {ok, 
        #npc_ai_rule{
            id = 100288
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600152}]
        }
    };
get(ai_rule, 100289) ->
    {ok, 
        #npc_ai_rule{
            id = 100289
            ,type = 0
            ,repeat = 0
            ,prob = 55
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"受…死…吧……">>]},{opp_side,skill,600144}]
        }
    };
get(ai_rule, 100290) ->
    {ok, 
        #npc_ai_rule{
            id = 100290
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600150}]
        }
    };
get(ai_rule, 100291) ->
    {ok, 
        #npc_ai_rule{
            id = 100291
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{combat,round,<<">=">>,8,1},{opp_side,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,200060,1}]
            ,action = [{suit_tar,skill,600153}]
        }
    };
get(ai_rule, 100292) ->
    {ok, 
        #npc_ai_rule{
            id = 100292
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{combat,round,<<">=">>,16,1},{opp_side,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,200060,1}]
            ,action = [{suit_tar,skill,600153}]
        }
    };
get(ai_rule, 100293) ->
    {ok, 
        #npc_ai_rule{
            id = 100293
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">">>,25,1}]
            ,action = [{opp_side,skill,600154},{self,talk,[<<"现在……是该结束的时候了">>]}]
        }
    };
get(ai_rule, 100294) ->
    {ok, 
        #npc_ai_rule{
            id = 100294
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,10,1},{opp_side,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,200060,1}]
            ,action = [{suit_tar,skill,600153},{self,talk,[<<"你比我想象中的更强大……">>]}]
        }
    };
get(ai_rule, 100295) ->
    {ok, 
        #npc_ai_rule{
            id = 100295
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,10,1}]
            ,action = [{opp_side,skill,600155}]
        }
    };
get(ai_rule, 100296) ->
    {ok, 
        #npc_ai_rule{
            id = 100296
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16111,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{self,talk,[<<"回来吧，我的孩子！">>]},{self,skill,600156}]
        }
    };
get(ai_rule, 100297) ->
    {ok, 
        #npc_ai_rule{
            id = 100297
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,talk,[<<"呵呵呵，看来又有小孩子来找死了">>]},{opp_side,skill,600157}]
        }
    };
get(ai_rule, 100298) ->
    {ok, 
        #npc_ai_rule{
            id = 100298
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{self,talk,[<<"这次就让姐姐我给你们点教训！">>]},{opp_side,skill,600158}]
        }
    };
get(ai_rule, 100299) ->
    {ok, 
        #npc_ai_rule{
            id = 100299
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16111,1},{suit_tar,hp,<<"<=">>,50,1}]
            ,action = [{self,talk,[<<"谁敢动她一下试试？！">>]},{opp_side,skill,600159}]
        }
    };
get(ai_rule, 100300) ->
    {ok, 
        #npc_ai_rule{
            id = 100300
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16111,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{self,talk,[<<"你们要承受的将是我无尽的怒火！">>]},{self,skill,600160}]
        }
    };
get(ai_rule, 100301) ->
    {ok, 
        #npc_ai_rule{
            id = 100301
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,80,1}]
            ,action = [{opp_side,skill,600161}]
        }
    };
get(ai_rule, 100302) ->
    {ok, 
        #npc_ai_rule{
            id = 100302
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1}]
            ,action = [{opp_side,skill,600162}]
        }
    };
get(ai_rule, 100303) ->
    {ok, 
        #npc_ai_rule{
            id = 100303
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,30,1},{opp_side,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,200060,1}]
            ,action = [{suit_tar,skill,600163}]
        }
    };
get(ai_rule, 100304) ->
    {ok, 
        #npc_ai_rule{
            id = 100304
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{opp_side,skill,600164},{self,talk,[<<"休想玷污了我的权威！">>]}]
        }
    };
get(ai_rule, 100305) ->
    {ok, 
        #npc_ai_rule{
            id = 100305
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1},{opp_side,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,200060,1}]
            ,action = [{suit_tar,skill,600165}]
        }
    };
get(ai_rule, 100306) ->
    {ok, 
        #npc_ai_rule{
            id = 100306
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod2">>,0,1},{self,hp,<<"<=">>,50,1}]
            ,action = [{self,skill,600166}]
        }
    };
get(ai_rule, 100307) ->
    {ok, 
        #npc_ai_rule{
            id = 100307
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,1,1}]
            ,action = [{opp_side,skill,600167}]
        }
    };
get(ai_rule, 100308) ->
    {ok, 
        #npc_ai_rule{
            id = 100308
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1},{self_side,id,<<"=">>,10359,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{self,skill,600168},{self,talk,[<<"主人，我会尽全力保护你！">>]}]
        }
    };
get(ai_rule, 100309) ->
    {ok, 
        #npc_ai_rule{
            id = 100309
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10359,1},{suit_tar,buff,<<"include">>,200060,1}]
            ,action = [{suit_tar,skill,600169}]
        }
    };
get(ai_rule, 100310) ->
    {ok, 
        #npc_ai_rule{
            id = 100310
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10359,1},{suit_tar,buff,<<"include">>,200051,1}]
            ,action = [{suit_tar,skill,600169}]
        }
    };
get(ai_rule, 100311) ->
    {ok, 
        #npc_ai_rule{
            id = 100311
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10359,1},{suit_tar,buff,<<"include">>,200080,1}]
            ,action = [{suit_tar,skill,600169}]
        }
    };
get(ai_rule, 100312) ->
    {ok, 
        #npc_ai_rule{
            id = 100312
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<">=">>,1,1},{combat,round,<<"mod2">>,1,1}]
            ,action = [{self,skill,600170}]
        }
    };
get(ai_rule, 100313) ->
    {ok, 
        #npc_ai_rule{
            id = 100313
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1},{combat,round,<<"mod2">>,0,1}]
            ,action = [{self_side,skill,600171}]
        }
    };
get(ai_rule, 100314) ->
    {ok, 
        #npc_ai_rule{
            id = 100314
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,talk,[<<"我不会让你们得逞的！">>]},{opp_side,skill,600172}]
        }
    };
get(ai_rule, 100315) ->
    {ok, 
        #npc_ai_rule{
            id = 100315
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,talk,[<<"你们只能踩着我的尸体过去！">>]},{opp_side,skill,600173}]
        }
    };
get(ai_rule, 100316) ->
    {ok, 
        #npc_ai_rule{
            id = 100316
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{self,skill,600174}]
        }
    };
get(ai_rule, 100317) ->
    {ok, 
        #npc_ai_rule{
            id = 100317
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,talk,[<<"你们为何来打扰我？">>]},{opp_side,skill,600175}]
        }
    };
get(ai_rule, 100318) ->
    {ok, 
        #npc_ai_rule{
            id = 100318
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600176}]
        }
    };
get(ai_rule, 100319) ->
    {ok, 
        #npc_ai_rule{
            id = 100319
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{self,skill,600177}]
        }
    };
get(ai_rule, 100320) ->
    {ok, 
        #npc_ai_rule{
            id = 100320
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{self,talk,[<<"处置你，以蜥蜴之王的名义！">>]},{opp_side,skill,600178}]
        }
    };
get(ai_rule, 100321) ->
    {ok, 
        #npc_ai_rule{
            id = 100321
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{combat,round,<<"=">>,10,1}]
            ,action = [{self,talk,[<<"你们感受到我的怒火了吗！">>]},{opp_side,skill,600179}]
        }
    };
get(ai_rule, 100322) ->
    {ok, 
        #npc_ai_rule{
            id = 100322
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,11,1}]
            ,action = [{opp_side,skill,600180}]
        }
    };
get(ai_rule, 100323) ->
    {ok, 
        #npc_ai_rule{
            id = 100323
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,12,1}]
            ,action = [{self,skill,600147}]
        }
    };
get(ai_rule, 100324) ->
    {ok, 
        #npc_ai_rule{
            id = 100324
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{combat,round,<<"=">>,13,1}]
            ,action = [{opp_side,skill,600178}]
        }
    };
get(ai_rule, 100325) ->
    {ok, 
        #npc_ai_rule{
            id = 100325
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{combat,round,<<"=">>,14,1}]
            ,action = [{opp_side,skill,600181}]
        }
    };
get(ai_rule, 100326) ->
    {ok, 
        #npc_ai_rule{
            id = 100326
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<"=">>,16,1}]
            ,action = [{self,skill,600182}]
        }
    };
get(ai_rule, 100327) ->
    {ok, 
        #npc_ai_rule{
            id = 100327
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<"=">>,17,1}]
            ,action = [{opp_side,skill,600183}]
        }
    };
get(ai_rule, 100328) ->
    {ok, 
        #npc_ai_rule{
            id = 100328
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1},{opp_side,hp,<<">=">>,10,1}]
            ,action = [{opp_side,skill,600180}]
        }
    };
get(ai_rule, 100329) ->
    {ok, 
        #npc_ai_rule{
            id = 100329
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{self,talk,[<<"只有我的武器能让你闭嘴！">>]},{opp_side,skill,600184}]
        }
    };
get(ai_rule, 100330) ->
    {ok, 
        #npc_ai_rule{
            id = 100330
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,talk,[<<"诸神只能被我踩在脚下！">>]},{opp_side,skill,600185}]
        }
    };
get(ai_rule, 100331) ->
    {ok, 
        #npc_ai_rule{
            id = 100331
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,talk,[<<"不！我绝不甘心！！！">>]},{opp_side,skill,600186}]
        }
    };
get(ai_rule, 100332) ->
    {ok, 
        #npc_ai_rule{
            id = 100332
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{self,talk,[<<"渺小的人类，你是来瞻仰我的吗？">>]},{self,skill,600187}]
        }
    };
get(ai_rule, 100333) ->
    {ok, 
        #npc_ai_rule{
            id = 100333
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,talk,[<<"我是黑暗之神--霍德尔！">>]},{opp_side,skill,600188}]
        }
    };
get(ai_rule, 100334) ->
    {ok, 
        #npc_ai_rule{
            id = 100334
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600189}]
        }
    };
get(ai_rule, 100335) ->
    {ok, 
        #npc_ai_rule{
            id = 100335
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{self,skill,600190}]
        }
    };
get(ai_rule, 100336) ->
    {ok, 
        #npc_ai_rule{
            id = 100336
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{self,talk,[<<"服从我，成为我的奴隶！">>]},{opp_side,skill,600191}]
        }
    };
get(ai_rule, 100337) ->
    {ok, 
        #npc_ai_rule{
            id = 100337
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{combat,round,<<"=">>,10,1}]
            ,action = [{self,talk,[<<"诸神只能被我踩在脚下！">>]},{opp_side,skill,600192}]
        }
    };
get(ai_rule, 100338) ->
    {ok, 
        #npc_ai_rule{
            id = 100338
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,11,1}]
            ,action = [{self,talk,[<<"我就是你们唯一的信仰！">>]},{opp_side,skill,600193}]
        }
    };
get(ai_rule, 100339) ->
    {ok, 
        #npc_ai_rule{
            id = 100339
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,12,1}]
            ,action = [{self,skill,600147}]
        }
    };
get(ai_rule, 100340) ->
    {ok, 
        #npc_ai_rule{
            id = 100340
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{combat,round,<<"=">>,13,1}]
            ,action = [{opp_side,skill,600191}]
        }
    };
get(ai_rule, 100341) ->
    {ok, 
        #npc_ai_rule{
            id = 100341
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{combat,round,<<"=">>,14,1}]
            ,action = [{opp_side,skill,600194}]
        }
    };
get(ai_rule, 100342) ->
    {ok, 
        #npc_ai_rule{
            id = 100342
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<"=">>,16,1}]
            ,action = [{self,skill,600195}]
        }
    };
get(ai_rule, 100343) ->
    {ok, 
        #npc_ai_rule{
            id = 100343
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<"=">>,17,1}]
            ,action = [{self,talk,[<<"只有死亡和我能让你们恐惧">>]},{opp_side,skill,600196}]
        }
    };
get(ai_rule, 100344) ->
    {ok, 
        #npc_ai_rule{
            id = 100344
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1},{opp_side,hp,<<">=">>,10,1}]
            ,action = [{opp_side,skill,600197}]
        }
    };
get(ai_rule, 100345) ->
    {ok, 
        #npc_ai_rule{
            id = 100345
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{self,talk,[<<"记住我的名字--霍德尔！">>]},{opp_side,skill,600198}]
        }
    };
get(ai_rule, 100346) ->
    {ok, 
        #npc_ai_rule{
            id = 100346
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"干嘛打扰我闲逛！">>]},{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100347) ->
    {ok, 
        #npc_ai_rule{
            id = 100347
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"再吵我就要你好看！">>]},{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100348) ->
    {ok, 
        #npc_ai_rule{
            id = 100348
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100349) ->
    {ok, 
        #npc_ai_rule{
            id = 100349
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"别逼我发火！">>]},{self,skill,600002}]
        }
    };
get(ai_rule, 100350) ->
    {ok, 
        #npc_ai_rule{
            id = 100350
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600001},{self,talk,[<<"哼！">>]}]
        }
    };
get(ai_rule, 100351) ->
    {ok, 
        #npc_ai_rule{
            id = 100351
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600199}]
        }
    };
get(ai_rule, 100352) ->
    {ok, 
        #npc_ai_rule{
            id = 100352
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600200}]
        }
    };
get(ai_rule, 100353) ->
    {ok, 
        #npc_ai_rule{
            id = 100353
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600201},{self,talk,[<<"再往前你会很危险的">>]}]
        }
    };
get(ai_rule, 100354) ->
    {ok, 
        #npc_ai_rule{
            id = 100354
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600202},{self,talk,[<<"是时候做个了结了">>]}]
        }
    };
get(ai_rule, 100355) ->
    {ok, 
        #npc_ai_rule{
            id = 100355
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,14,1}]
            ,action = [{self,skill,600203},{self,talk,[<<"我又要沉默你哦">>]}]
        }
    };
get(ai_rule, 100356) ->
    {ok, 
        #npc_ai_rule{
            id = 100356
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,15,1}]
            ,action = [{opp_side,skill,600204}]
        }
    };
get(ai_rule, 100357) ->
    {ok, 
        #npc_ai_rule{
            id = 100357
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<">>,20,1}]
            ,action = [{self,skill,600205}]
        }
    };
get(ai_rule, 100358) ->
    {ok, 
        #npc_ai_rule{
            id = 100358
            ,type = 0
            ,repeat = 1
            ,prob = 10
            ,condition = [{combat,round,<<">=">>,10,1}]
            ,action = [{opp_side,skill,600206},{self,talk,[<<"不打败我是拿不到宝藏的哦~">>]}]
        }
    };
get(ai_rule, 100359) ->
    {ok, 
        #npc_ai_rule{
            id = 100359
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,13,1}]
            ,action = [{opp_side,skill,600207}]
        }
    };
get(ai_rule, 100360) ->
    {ok, 
        #npc_ai_rule{
            id = 100360
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,12,1}]
            ,action = [{opp_side,skill,600208},{self,talk,[<<"在世界树可以获得精练材料哦~">>]}]
        }
    };
get(ai_rule, 100361) ->
    {ok, 
        #npc_ai_rule{
            id = 100361
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,10,1}]
            ,action = [{opp_side,skill,600209}]
        }
    };
get(ai_rule, 100362) ->
    {ok, 
        #npc_ai_rule{
            id = 100362
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,10,1}]
            ,action = [{opp_side,skill,600210},{self,talk,[<<"让你知难而退！">>]}]
        }
    };
get(ai_rule, 100363) ->
    {ok, 
        #npc_ai_rule{
            id = 100363
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"=">>,9,1}]
            ,action = [{opp_side,skill,600211}]
        }
    };
get(ai_rule, 100364) ->
    {ok, 
        #npc_ai_rule{
            id = 100364
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,8,1},{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{opp_side,skill,600212},{self,talk,[<<"跟你说了要沉默，你还中招啊">>]}]
        }
    };
get(ai_rule, 100365) ->
    {ok, 
        #npc_ai_rule{
            id = 100365
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,8,1},{opp_side,buff,<<"not_in">>,200060,1}]
            ,action = [{opp_side,skill,600213},{self,talk,[<<"你还挺聪明，居然没中招！">>]}]
        }
    };
get(ai_rule, 100366) ->
    {ok, 
        #npc_ai_rule{
            id = 100366
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{opp_side,skill,600214}]
        }
    };
get(ai_rule, 100367) ->
    {ok, 
        #npc_ai_rule{
            id = 100367
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{self,skill,600215},{self,talk,[<<"下回合我要沉默你哦">>]}]
        }
    };
get(ai_rule, 100368) ->
    {ok, 
        #npc_ai_rule{
            id = 100368
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,600216}]
        }
    };
get(ai_rule, 100369) ->
    {ok, 
        #npc_ai_rule{
            id = 100369
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600217},{self,talk,[<<"能不能拿到宝藏就看你的实力了！">>]}]
        }
    };
get(ai_rule, 100370) ->
    {ok, 
        #npc_ai_rule{
            id = 100370
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600218},{self,talk,[<<"但有像我一样的守卫把守">>]}]
        }
    };
get(ai_rule, 100371) ->
    {ok, 
        #npc_ai_rule{
            id = 100371
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600219},{self,talk,[<<"这里有丰富的神源宝藏~">>]}]
        }
    };
get(ai_rule, 100372) ->
    {ok, 
        #npc_ai_rule{
            id = 100372
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,600220},{self,talk,[<<"欢迎来到世界树~">>]}]
        }
    };
get(ai_rule, 100373) ->
    {ok, 
        #npc_ai_rule{
            id = 100373
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600221}]
        }
    };
get(ai_rule, 100374) ->
    {ok, 
        #npc_ai_rule{
            id = 100374
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600222}]
        }
    };
get(ai_rule, 100375) ->
    {ok, 
        #npc_ai_rule{
            id = 100375
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600223},{self,talk,[<<"等你更强了再来吧">>]}]
        }
    };
get(ai_rule, 100376) ->
    {ok, 
        #npc_ai_rule{
            id = 100376
            ,type = 0
            ,repeat = 0
            ,prob = 10
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600224},{self,talk,[<<"树精天生有很强恢复力">>]}]
        }
    };
get(ai_rule, 100377) ->
    {ok, 
        #npc_ai_rule{
            id = 100377
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600225},{self,talk,[<<"快回去吧不要逼我！">>]}]
        }
    };
get(ai_rule, 100378) ->
    {ok, 
        #npc_ai_rule{
            id = 100378
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,12,1}]
            ,action = [{self,skill,600226}]
        }
    };
get(ai_rule, 100379) ->
    {ok, 
        #npc_ai_rule{
            id = 100379
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600227}]
        }
    };
get(ai_rule, 100380) ->
    {ok, 
        #npc_ai_rule{
            id = 100380
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600228},{self,talk,[<<"你是来抓我的吗？">>]}]
        }
    };
get(ai_rule, 100381) ->
    {ok, 
        #npc_ai_rule{
            id = 100381
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600229},{self,talk,[<<"你是谁？">>]}]
        }
    };
get(ai_rule, 100382) ->
    {ok, 
        #npc_ai_rule{
            id = 100382
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600230}]
        }
    };
get(ai_rule, 100383) ->
    {ok, 
        #npc_ai_rule{
            id = 100383
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600231},{self,talk,[<<"看你可怜给你加个血">>]}]
        }
    };
get(ai_rule, 100384) ->
    {ok, 
        #npc_ai_rule{
            id = 100384
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600232},{self,talk,[<<"别来伤害我！">>]}]
        }
    };
get(ai_rule, 100385) ->
    {ok, 
        #npc_ai_rule{
            id = 100385
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600233},{self,talk,[<<"我可没这么好说话">>]}]
        }
    };
get(ai_rule, 100386) ->
    {ok, 
        #npc_ai_rule{
            id = 100386
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600234}]
        }
    };
get(ai_rule, 100387) ->
    {ok, 
        #npc_ai_rule{
            id = 100387
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">">>,18,1},{self,hp,<<">">>,0,1}]
            ,action = [{opp_side,skill,600235}]
        }
    };
get(ai_rule, 100388) ->
    {ok, 
        #npc_ai_rule{
            id = 100388
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600236},{self,talk,[<<"只有我能够拥有神源">>]}]
        }
    };
get(ai_rule, 100389) ->
    {ok, 
        #npc_ai_rule{
            id = 100389
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,hp,<<"<">>,20,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,600237},{self,talk,[<<"你好像快不行了哦">>]}]
        }
    };
get(ai_rule, 100390) ->
    {ok, 
        #npc_ai_rule{
            id = 100390
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600238}]
        }
    };
get(ai_rule, 100391) ->
    {ok, 
        #npc_ai_rule{
            id = 100391
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600239}]
        }
    };
get(ai_rule, 100392) ->
    {ok, 
        #npc_ai_rule{
            id = 100392
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600240},{self,talk,[<<"又有人要来抢我的神源了吗？">>]}]
        }
    };
get(ai_rule, 100393) ->
    {ok, 
        #npc_ai_rule{
            id = 100393
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600241}]
        }
    };
get(ai_rule, 100394) ->
    {ok, 
        #npc_ai_rule{
            id = 100394
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600242}]
        }
    };
get(ai_rule, 100395) ->
    {ok, 
        #npc_ai_rule{
            id = 100395
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600243}]
        }
    };
get(ai_rule, 100396) ->
    {ok, 
        #npc_ai_rule{
            id = 100396
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600244},{self,talk,[<<"我不想伤害你的">>]}]
        }
    };
get(ai_rule, 100397) ->
    {ok, 
        #npc_ai_rule{
            id = 100397
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600245},{self,talk,[<<"考验结束，看来你不能过去">>]}]
        }
    };
get(ai_rule, 100398) ->
    {ok, 
        #npc_ai_rule{
            id = 100398
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,14,1}]
            ,action = [{opp_side,skill,600246}]
        }
    };
get(ai_rule, 100399) ->
    {ok, 
        #npc_ai_rule{
            id = 100399
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,13,1}]
            ,action = [{self,skill,600247}]
        }
    };
get(ai_rule, 100400) ->
    {ok, 
        #npc_ai_rule{
            id = 100400
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<">>,50,1}]
            ,action = [{self,skill,600248},{self,talk,[<<"补个血吧">>]}]
        }
    };
get(ai_rule, 100401) ->
    {ok, 
        #npc_ai_rule{
            id = 100401
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600249}]
        }
    };
get(ai_rule, 100402) ->
    {ok, 
        #npc_ai_rule{
            id = 100402
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,0,1},{combat,round,<<">=">>,7,1}]
            ,action = [{opp_side,skill,600250}]
        }
    };
get(ai_rule, 100403) ->
    {ok, 
        #npc_ai_rule{
            id = 100403
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,2,1},{combat,round,<<">=">>,7,1}]
            ,action = [{self,skill,600251}]
        }
    };
get(ai_rule, 100404) ->
    {ok, 
        #npc_ai_rule{
            id = 100404
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1},{combat,round,<<">=">>,7,1}]
            ,action = [{opp_side,skill,600252}]
        }
    };
get(ai_rule, 100405) ->
    {ok, 
        #npc_ai_rule{
            id = 100405
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{opp_side,skill,600253}]
        }
    };
get(ai_rule, 100406) ->
    {ok, 
        #npc_ai_rule{
            id = 100406
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{self,skill,600254}]
        }
    };
get(ai_rule, 100407) ->
    {ok, 
        #npc_ai_rule{
            id = 100407
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{self,skill,600255},{self,talk,[<<"你打我一下试试">>]}]
        }
    };
get(ai_rule, 100408) ->
    {ok, 
        #npc_ai_rule{
            id = 100408
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{self,skill,600256},{self,talk,[<<"如果你能很快地打败我，我就让你过去">>]}]
        }
    };
get(ai_rule, 100409) ->
    {ok, 
        #npc_ai_rule{
            id = 100409
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600257}]
        }
    };
get(ai_rule, 100410) ->
    {ok, 
        #npc_ai_rule{
            id = 100410
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600258},{self,talk,[<<" 我弟弟就是被迷惑了">>]}]
        }
    };
get(ai_rule, 100411) ->
    {ok, 
        #npc_ai_rule{
            id = 100411
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,600259},{self,talk,[<<"这里很危险，你不该来的">>]}]
        }
    };
get(ai_rule, 100412) ->
    {ok, 
        #npc_ai_rule{
            id = 100412
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,22,1}]
            ,action = [{opp_side,skill,600260},{self,talk,[<<"我不准你再靠近了！">>]}]
        }
    };
get(ai_rule, 100413) ->
    {ok, 
        #npc_ai_rule{
            id = 100413
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,20,1}]
            ,action = [{opp_side,skill,600261}]
        }
    };
get(ai_rule, 100414) ->
    {ok, 
        #npc_ai_rule{
            id = 100414
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600262},{self,talk,[<<"一直向前会痛的！">>]}]
        }
    };
get(ai_rule, 100415) ->
    {ok, 
        #npc_ai_rule{
            id = 100415
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600263},{self,talk,[<<"得和你说再见了">>]}]
        }
    };
get(ai_rule, 100416) ->
    {ok, 
        #npc_ai_rule{
            id = 100416
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{self,skill,600264},{self,talk,[<<"是不是也为了爱情？">>]}]
        }
    };
get(ai_rule, 100417) ->
    {ok, 
        #npc_ai_rule{
            id = 100417
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,600265},{self,talk,[<<"你为何迷失在世界树？">>]}]
        }
    };
get(ai_rule, 100418) ->
    {ok, 
        #npc_ai_rule{
            id = 100418
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,0,1}]
            ,action = [{opp_side,skill,600266}]
        }
    };
get(ai_rule, 100419) ->
    {ok, 
        #npc_ai_rule{
            id = 100419
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1},{self,hp,<<">">>,0,1}]
            ,action = [{self,skill,600267}]
        }
    };
get(ai_rule, 100420) ->
    {ok, 
        #npc_ai_rule{
            id = 100420
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1},{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,skill,600268},{self,talk,[<<"我不会打扰你的">>]}]
        }
    };
get(ai_rule, 100421) ->
    {ok, 
        #npc_ai_rule{
            id = 100421
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600269},{self,talk,[<<"睡一下吧">>]}]
        }
    };
get(ai_rule, 100422) ->
    {ok, 
        #npc_ai_rule{
            id = 100422
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600270},{self,talk,[<<"龙形态！">>]}]
        }
    };
get(ai_rule, 100423) ->
    {ok, 
        #npc_ai_rule{
            id = 100423
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600271}]
        }
    };
get(ai_rule, 100424) ->
    {ok, 
        #npc_ai_rule{
            id = 100424
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<">>,20,1}]
            ,action = [{self,skill,600272},{self,talk,[<<"鹿形态！">>]}]
        }
    };
get(ai_rule, 100425) ->
    {ok, 
        #npc_ai_rule{
            id = 100425
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{self,hp,<<"<">>,20,1}]
            ,action = [{self,skill,600273},{self,talk,[<<"鹿形态！">>]}]
        }
    };
get(ai_rule, 100426) ->
    {ok, 
        #npc_ai_rule{
            id = 100426
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600274},{self,talk,[<<"有我兽神守卫你别想过去！">>]}]
        }
    };
get(ai_rule, 100427) ->
    {ok, 
        #npc_ai_rule{
            id = 100427
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{self,skill,600275},{self,talk,[<<"龟形态！">>]}]
        }
    };
get(ai_rule, 100428) ->
    {ok, 
        #npc_ai_rule{
            id = 100428
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600276},{self,talk,[<<"熊形态！">>]}]
        }
    };
get(ai_rule, 100429) ->
    {ok, 
        #npc_ai_rule{
            id = 100429
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600277},{self,talk,[<<"豹形态！">>]}]
        }
    };
get(ai_rule, 100430) ->
    {ok, 
        #npc_ai_rule{
            id = 100430
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,600278}]
        }
    };
get(ai_rule, 100431) ->
    {ok, 
        #npc_ai_rule{
            id = 100431
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{opp_side,skill,600279},{self,talk,[<<"鹿形态！">>]}]
        }
    };
get(ai_rule, 100432) ->
    {ok, 
        #npc_ai_rule{
            id = 100432
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{opp_side,skill,600280},{self,talk,[<<"豹形态！">>]}]
        }
    };
get(ai_rule, 100433) ->
    {ok, 
        #npc_ai_rule{
            id = 100433
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,8,1}]
            ,action = [{self,skill,600281},{self,talk,[<<"龟形态！">>]}]
        }
    };
get(ai_rule, 100434) ->
    {ok, 
        #npc_ai_rule{
            id = 100434
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,9,1}]
            ,action = [{opp_side,skill,600282},{self,talk,[<<"熊形态！">>]}]
        }
    };
get(ai_rule, 100435) ->
    {ok, 
        #npc_ai_rule{
            id = 100435
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,10,1}]
            ,action = [{opp_side,skill,600283}]
        }
    };
get(ai_rule, 100436) ->
    {ok, 
        #npc_ai_rule{
            id = 100436
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,11,1}]
            ,action = [{opp_side,skill,600284}]
        }
    };
get(ai_rule, 100437) ->
    {ok, 
        #npc_ai_rule{
            id = 100437
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600285},{self,talk,[<<"终极形态！">>]}]
        }
    };
get(ai_rule, 100438) ->
    {ok, 
        #npc_ai_rule{
            id = 100438
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{self,skill,600286},{self,talk,[<<"龟形态！">>]}]
        }
    };
get(ai_rule, 100439) ->
    {ok, 
        #npc_ai_rule{
            id = 100439
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600287},{self,talk,[<<"熊形态！">>]}]
        }
    };
get(ai_rule, 100440) ->
    {ok, 
        #npc_ai_rule{
            id = 100440
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600288},{self,talk,[<<"豹形态！">>]}]
        }
    };
get(ai_rule, 100441) ->
    {ok, 
        #npc_ai_rule{
            id = 100441
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,22,1}]
            ,action = [{opp_side,skill,600289},{self,talk,[<<"让这场战斗结束吧！">>]}]
        }
    };
get(ai_rule, 100442) ->
    {ok, 
        #npc_ai_rule{
            id = 100442
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600290}]
        }
    };
get(ai_rule, 100443) ->
    {ok, 
        #npc_ai_rule{
            id = 100443
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600291}]
        }
    };
get(ai_rule, 100444) ->
    {ok, 
        #npc_ai_rule{
            id = 100444
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,600292},{self,talk,[<<"咦又有人来挨揍了~">>]}]
        }
    };
get(ai_rule, 100445) ->
    {ok, 
        #npc_ai_rule{
            id = 100445
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600293},{self,talk,[<<"一斧头砸晕你！">>]}]
        }
    };
get(ai_rule, 100446) ->
    {ok, 
        #npc_ai_rule{
            id = 100446
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,talk,[<<"好累啊歇会~">>]}]
        }
    };
get(ai_rule, 100447) ->
    {ok, 
        #npc_ai_rule{
            id = 100447
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600295},{self,talk,[<<"我要大爆发了！">>]}]
        }
    };
get(ai_rule, 100448) ->
    {ok, 
        #npc_ai_rule{
            id = 100448
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,skill,600296},{self,talk,[<<"我又要爆发了！">>]}]
        }
    };
get(ai_rule, 100449) ->
    {ok, 
        #npc_ai_rule{
            id = 100449
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600297}]
        }
    };
get(ai_rule, 100450) ->
    {ok, 
        #npc_ai_rule{
            id = 100450
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{self,talk,[<<"好累啊歇会~">>]}]
        }
    };
get(ai_rule, 100451) ->
    {ok, 
        #npc_ai_rule{
            id = 100451
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,22,1}]
            ,action = [{opp_side,skill,600299}]
        }
    };
get(ai_rule, 100452) ->
    {ok, 
        #npc_ai_rule{
            id = 100452
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">">>,20,1}]
            ,action = [{opp_side,skill,600300}]
        }
    };
get(ai_rule, 100453) ->
    {ok, 
        #npc_ai_rule{
            id = 100453
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600301},{self,talk,[<<"世界树由我来守卫！">>]}]
        }
    };
get(ai_rule, 100454) ->
    {ok, 
        #npc_ai_rule{
            id = 100454
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600302}]
        }
    };
get(ai_rule, 100455) ->
    {ok, 
        #npc_ai_rule{
            id = 100455
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,15,1}]
            ,action = [{opp_side,skill,600303},{self,talk,[<<"守卫兵必杀技！">>]}]
        }
    };
get(ai_rule, 100456) ->
    {ok, 
        #npc_ai_rule{
            id = 100456
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1},{self_side,id,<<"=">>,16117,2},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self,skill,600308},{self,talk,[<<"我们是绿革守卫军！">>]}]
        }
    };
get(ai_rule, 100457) ->
    {ok, 
        #npc_ai_rule{
            id = 100457
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1}]
            ,action = [{opp_side,skill,600305}]
        }
    };
get(ai_rule, 100458) ->
    {ok, 
        #npc_ai_rule{
            id = 100458
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,600306}]
        }
    };
get(ai_rule, 100459) ->
    {ok, 
        #npc_ai_rule{
            id = 100459
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1},{self_side,id,<<"=">>,16117,1},{suit_tar,hp,<<">">>,0,1},{self_side,id,<<"=">>,16117,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{self,skill,600307},{self,talk,[<<"我们是绿革守卫军！">>]}]
        }
    };
get(ai_rule, 100460) ->
    {ok, 
        #npc_ai_rule{
            id = 100460
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1},{self_side,id,<<"=">>,16117,0}]
            ,action = [{self,skill,600308},{self,talk,[<<"我们是绿革守卫军！">>]}]
        }
    };
get(ai_rule, 100461) ->
    {ok, 
        #npc_ai_rule{
            id = 100461
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600309}]
        }
    };
get(ai_rule, 100462) ->
    {ok, 
        #npc_ai_rule{
            id = 100462
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,22,1}]
            ,action = [{opp_side,skill,600310},{self,talk,[<<"终结吧！">>]}]
        }
    };
get(ai_rule, 100463) ->
    {ok, 
        #npc_ai_rule{
            id = 100463
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600311}]
        }
    };
get(ai_rule, 100464) ->
    {ok, 
        #npc_ai_rule{
            id = 100464
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600312}]
        }
    };
get(ai_rule, 100465) ->
    {ok, 
        #npc_ai_rule{
            id = 100465
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600313},{self,talk,[<<"决斗的时候到了~">>]}]
        }
    };
get(ai_rule, 100466) ->
    {ok, 
        #npc_ai_rule{
            id = 100466
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600314},{self,talk,[<<"你也是王国的战士？">>]}]
        }
    };
get(ai_rule, 100467) ->
    {ok, 
        #npc_ai_rule{
            id = 100467
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600315},{self,talk,[<<"我曾经也是圆桌骑士团的战士">>]}]
        }
    };
get(ai_rule, 100468) ->
    {ok, 
        #npc_ai_rule{
            id = 100468
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,skill,600316},{self,talk,[<<"光之屏障！">>]}]
        }
    };
get(ai_rule, 100469) ->
    {ok, 
        #npc_ai_rule{
            id = 100469
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600317},{self,talk,[<<"愤怒咆哮！">>]}]
        }
    };
get(ai_rule, 100470) ->
    {ok, 
        #npc_ai_rule{
            id = 100470
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,600318}]
        }
    };
get(ai_rule, 100471) ->
    {ok, 
        #npc_ai_rule{
            id = 100471
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{opp_side,skill,600319},{self,talk,[<<"正义审判！">>]}]
        }
    };
get(ai_rule, 100472) ->
    {ok, 
        #npc_ai_rule{
            id = 100472
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,0,1}]
            ,action = [{self,skill,600320}]
        }
    };
get(ai_rule, 100473) ->
    {ok, 
        #npc_ai_rule{
            id = 100473
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600321}]
        }
    };
get(ai_rule, 100474) ->
    {ok, 
        #npc_ai_rule{
            id = 100474
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{self,skill,600322}]
        }
    };
get(ai_rule, 100475) ->
    {ok, 
        #npc_ai_rule{
            id = 100475
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1}]
            ,action = [{opp_side,skill,600323}]
        }
    };
get(ai_rule, 100476) ->
    {ok, 
        #npc_ai_rule{
            id = 100476
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,22,1}]
            ,action = [{opp_side,skill,600324},{self,talk,[<<"兔子是不可欺负的！">>]}]
        }
    };
get(ai_rule, 100477) ->
    {ok, 
        #npc_ai_rule{
            id = 100477
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600325}]
        }
    };
get(ai_rule, 100478) ->
    {ok, 
        #npc_ai_rule{
            id = 100478
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600326}]
        }
    };
get(ai_rule, 100479) ->
    {ok, 
        #npc_ai_rule{
            id = 100479
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{opp_side,skill,600327},{self,talk,[<<"不陪你玩了~">>]}]
        }
    };
get(ai_rule, 100480) ->
    {ok, 
        #npc_ai_rule{
            id = 100480
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,600328},{self,talk,[<<"咦这不是人类吗？">>]}]
        }
    };
get(ai_rule, 100481) ->
    {ok, 
        #npc_ai_rule{
            id = 100481
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600329},{self,talk,[<<"我的剑可是很快的！">>]}]
        }
    };
get(ai_rule, 100482) ->
    {ok, 
        #npc_ai_rule{
            id = 100482
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600330},{self,talk,[<<"你觉得你能打得着我吗？">>]}]
        }
    };
get(ai_rule, 100483) ->
    {ok, 
        #npc_ai_rule{
            id = 100483
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600331}]
        }
    };
get(ai_rule, 100484) ->
    {ok, 
        #npc_ai_rule{
            id = 100484
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,600332}]
        }
    };
get(ai_rule, 100485) ->
    {ok, 
        #npc_ai_rule{
            id = 100485
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{opp_side,skill,600333},{self,talk,[<<"你又要打不着我了~">>]}]
        }
    };
get(ai_rule, 100486) ->
    {ok, 
        #npc_ai_rule{
            id = 100486
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600334}]
        }
    };
get(ai_rule, 100487) ->
    {ok, 
        #npc_ai_rule{
            id = 100487
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600335}]
        }
    };
get(ai_rule, 100488) ->
    {ok, 
        #npc_ai_rule{
            id = 100488
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600336},{self,talk,[<<"兔兔连环刺！">>]}]
        }
    };
get(ai_rule, 100489) ->
    {ok, 
        #npc_ai_rule{
            id = 100489
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<">>,20,1}]
            ,action = [{self,skill,600337},{self,talk,[<<"要死要死，赶紧套个盾~">>]}]
        }
    };
get(ai_rule, 100490) ->
    {ok, 
        #npc_ai_rule{
            id = 100490
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,22,1}]
            ,action = [{opp_side,skill,600338}]
        }
    };
get(ai_rule, 100491) ->
    {ok, 
        #npc_ai_rule{
            id = 100491
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600339},{self,talk,[<<"再见了勇士~">>]}]
        }
    };
get(ai_rule, 100492) ->
    {ok, 
        #npc_ai_rule{
            id = 100492
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600340}]
        }
    };
get(ai_rule, 100493) ->
    {ok, 
        #npc_ai_rule{
            id = 100493
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{opp_side,skill,600341}]
        }
    };
get(ai_rule, 100494) ->
    {ok, 
        #npc_ai_rule{
            id = 100494
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600342},{self,talk,[<<"我是狂躁的人马！">>]}]
        }
    };
get(ai_rule, 100495) ->
    {ok, 
        #npc_ai_rule{
            id = 100495
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600343},{self,talk,[<<"怎么老是打不中呢？">>]}]
        }
    };
get(ai_rule, 100496) ->
    {ok, 
        #npc_ai_rule{
            id = 100496
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600344},{self,talk,[<<"我要发疯了！">>]}]
        }
    };
get(ai_rule, 100497) ->
    {ok, 
        #npc_ai_rule{
            id = 100497
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600345},{self,talk,[<<"啊！">>]}]
        }
    };
get(ai_rule, 100498) ->
    {ok, 
        #npc_ai_rule{
            id = 100498
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{self,skill,600346}]
        }
    };
get(ai_rule, 100499) ->
    {ok, 
        #npc_ai_rule{
            id = 100499
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{opp_side,skill,600347}]
        }
    };
get(ai_rule, 100500) ->
    {ok, 
        #npc_ai_rule{
            id = 100500
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600348}]
        }
    };
get(ai_rule, 100501) ->
    {ok, 
        #npc_ai_rule{
            id = 100501
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{self,skill,600349}]
        }
    };
get(ai_rule, 100502) ->
    {ok, 
        #npc_ai_rule{
            id = 100502
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600350},{self,talk,[<<"白马王子来了~">>]}]
        }
    };
get(ai_rule, 100503) ->
    {ok, 
        #npc_ai_rule{
            id = 100503
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<">>,20,1}]
            ,action = [{self,skill,600351}]
        }
    };
get(ai_rule, 100504) ->
    {ok, 
        #npc_ai_rule{
            id = 100504
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<">>,20,1}]
            ,action = [{self,skill,600352}]
        }
    };
get(ai_rule, 100505) ->
    {ok, 
        #npc_ai_rule{
            id = 100505
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,22,1}]
            ,action = [{opp_side,skill,600353}]
        }
    };
get(ai_rule, 100506) ->
    {ok, 
        #npc_ai_rule{
            id = 100506
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600354}]
        }
    };
get(ai_rule, 100507) ->
    {ok, 
        #npc_ai_rule{
            id = 100507
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600355}]
        }
    };
get(ai_rule, 100508) ->
    {ok, 
        #npc_ai_rule{
            id = 100508
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600356},{self,talk,[<<"神会指引你的方向">>]}]
        }
    };
get(ai_rule, 100509) ->
    {ok, 
        #npc_ai_rule{
            id = 100509
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600357},{self,talk,[<<"你进入过翡翠梦境吗？">>]}]
        }
    };
get(ai_rule, 100510) ->
    {ok, 
        #npc_ai_rule{
            id = 100510
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,2,1},{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600358},{self,talk,[<<"从梦境中被惊醒是最危险的">>]}]
        }
    };
get(ai_rule, 100511) ->
    {ok, 
        #npc_ai_rule{
            id = 100511
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,skill,600359}]
        }
    };
get(ai_rule, 100512) ->
    {ok, 
        #npc_ai_rule{
            id = 100512
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600360},{self,talk,[<<"再次进入梦境吧">>]}]
        }
    };
get(ai_rule, 100513) ->
    {ok, 
        #npc_ai_rule{
            id = 100513
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600361}]
        }
    };
get(ai_rule, 100514) ->
    {ok, 
        #npc_ai_rule{
            id = 100514
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600362}]
        }
    };
get(ai_rule, 100515) ->
    {ok, 
        #npc_ai_rule{
            id = 100515
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{self,skill,600363}]
        }
    };
get(ai_rule, 100516) ->
    {ok, 
        #npc_ai_rule{
            id = 100516
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600364},{self,talk,[<<"荆棘缠绕！">>]}]
        }
    };
get(ai_rule, 100517) ->
    {ok, 
        #npc_ai_rule{
            id = 100517
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,22,1}]
            ,action = [{opp_side,skill,600365}]
        }
    };
get(ai_rule, 100518) ->
    {ok, 
        #npc_ai_rule{
            id = 100518
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600366}]
        }
    };
get(ai_rule, 100519) ->
    {ok, 
        #npc_ai_rule{
            id = 100519
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600367}]
        }
    };
get(ai_rule, 100520) ->
    {ok, 
        #npc_ai_rule{
            id = 100520
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600368},{self,talk,[<<"命运之轮开始转动">>]}]
        }
    };
get(ai_rule, 100521) ->
    {ok, 
        #npc_ai_rule{
            id = 100521
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600369},{self,talk,[<<"年轻人，你为何而来？">>]}]
        }
    };
get(ai_rule, 100522) ->
    {ok, 
        #npc_ai_rule{
            id = 100522
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,2,1}]
            ,action = [{opp_side,skill,600370},{self,talk,[<<"你遇到我，很不幸">>]}]
        }
    };
get(ai_rule, 100523) ->
    {ok, 
        #npc_ai_rule{
            id = 100523
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,skill,600371}]
        }
    };
get(ai_rule, 100524) ->
    {ok, 
        #npc_ai_rule{
            id = 100524
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600372},{self,talk,[<<"沉默会带来和平。">>]}]
        }
    };
get(ai_rule, 100525) ->
    {ok, 
        #npc_ai_rule{
            id = 100525
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600373}]
        }
    };
get(ai_rule, 100526) ->
    {ok, 
        #npc_ai_rule{
            id = 100526
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600374},{self,talk,[<<"毒液会慢慢侵蚀你的梦想~">>]}]
        }
    };
get(ai_rule, 100527) ->
    {ok, 
        #npc_ai_rule{
            id = 100527
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self,skill,600375}]
        }
    };
get(ai_rule, 100528) ->
    {ok, 
        #npc_ai_rule{
            id = 100528
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600376}]
        }
    };
get(ai_rule, 100529) ->
    {ok, 
        #npc_ai_rule{
            id = 100529
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,22,1}]
            ,action = [{opp_side,skill,600377},{self,talk,[<<"可爱的人类，就此睡去吧~">>]}]
        }
    };
get(ai_rule, 100530) ->
    {ok, 
        #npc_ai_rule{
            id = 100530
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600378}]
        }
    };
get(ai_rule, 100531) ->
    {ok, 
        #npc_ai_rule{
            id = 100531
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600379}]
        }
    };
get(ai_rule, 100532) ->
    {ok, 
        #npc_ai_rule{
            id = 100532
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,600380},{self,talk,[<<"嘤嘤，可爱的人类哟~">>]}]
        }
    };
get(ai_rule, 100533) ->
    {ok, 
        #npc_ai_rule{
            id = 100533
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,2,1}]
            ,action = [{self,skill,600381},{self,talk,[<<"我们是不是很可爱~">>]}]
        }
    };
get(ai_rule, 100534) ->
    {ok, 
        #npc_ai_rule{
            id = 100534
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600382}]
        }
    };
get(ai_rule, 100535) ->
    {ok, 
        #npc_ai_rule{
            id = 100535
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,id,<<"=">>,16118,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{opp_side,skill,600383},{self,talk,[<<"姐妹花的献礼~">>]}]
        }
    };
get(ai_rule, 100536) ->
    {ok, 
        #npc_ai_rule{
            id = 100536
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,12,1},{self_side,id,<<"=">>,16118,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{opp_side,skill,600384},{self,talk,[<<"花之三姐妹~">>]}]
        }
    };
get(ai_rule, 100537) ->
    {ok, 
        #npc_ai_rule{
            id = 100537
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,12,1},{self_side,id,<<"=">>,16118,0}]
            ,action = [{opp_side,skill,600385},{self,talk,[<<"花之三姐妹~">>]}]
        }
    };
get(ai_rule, 100538) ->
    {ok, 
        #npc_ai_rule{
            id = 100538
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600386}]
        }
    };
get(ai_rule, 100539) ->
    {ok, 
        #npc_ai_rule{
            id = 100539
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,600387}]
        }
    };
get(ai_rule, 100540) ->
    {ok, 
        #npc_ai_rule{
            id = 100540
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1}]
            ,action = [{self,skill,600388}]
        }
    };
get(ai_rule, 100541) ->
    {ok, 
        #npc_ai_rule{
            id = 100541
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,0,1},{self_side,id,<<"=">>,16118,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{opp_side,skill,600389},{self,talk,[<<"姐妹花的献礼~">>]}]
        }
    };
get(ai_rule, 100542) ->
    {ok, 
        #npc_ai_rule{
            id = 100542
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod2">>,1,1},{self_side,id,<<"=">>,14024,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{opp_side,skill,600390},{self,talk,[<<"姐妹花的献礼~">>]}]
        }
    };
get(ai_rule, 100543) ->
    {ok, 
        #npc_ai_rule{
            id = 100543
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600391}]
        }
    };
get(ai_rule, 100544) ->
    {ok, 
        #npc_ai_rule{
            id = 100544
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1},{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600392},{self,talk,[<<"火之沉默！">>]}]
        }
    };
get(ai_rule, 100545) ->
    {ok, 
        #npc_ai_rule{
            id = 100545
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1},{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600393},{self,talk,[<<"火之消亡！">>]}]
        }
    };
get(ai_rule, 100546) ->
    {ok, 
        #npc_ai_rule{
            id = 100546
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1},{combat,round,<<">">>,18,1}]
            ,action = [{opp_side,skill,600394},{self,talk,[<<"火之压制！">>]}]
        }
    };
get(ai_rule, 100547) ->
    {ok, 
        #npc_ai_rule{
            id = 100547
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{self,skill,600395},{self,talk,[<<"火之意志全开！">>]}]
        }
    };
get(ai_rule, 100548) ->
    {ok, 
        #npc_ai_rule{
            id = 100548
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600396},{self,talk,[<<"如果让我蓄力成功我可要爆发的哦~">>]}]
        }
    };
get(ai_rule, 100549) ->
    {ok, 
        #npc_ai_rule{
            id = 100549
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600397}]
        }
    };
get(ai_rule, 100550) ->
    {ok, 
        #npc_ai_rule{
            id = 100550
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,skill,600398}]
        }
    };
get(ai_rule, 100551) ->
    {ok, 
        #npc_ai_rule{
            id = 100551
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1},{self,buff,<<"not_in">>,104140,1}]
            ,action = [{opp_side,skill,600399},{self,talk,[<<"蓄力不成功55~">>]}]
        }
    };
get(ai_rule, 100552) ->
    {ok, 
        #npc_ai_rule{
            id = 100552
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1},{self,buff,<<"not_in">>,104140,1}]
            ,action = [{opp_side,skill,600400}]
        }
    };
get(ai_rule, 100553) ->
    {ok, 
        #npc_ai_rule{
            id = 100553
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1},{self,buff,<<"not_in">>,104140,1}]
            ,action = [{opp_side,skill,600401}]
        }
    };
get(ai_rule, 100554) ->
    {ok, 
        #npc_ai_rule{
            id = 100554
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1},{self,buff,<<"include">>,104140,1}]
            ,action = [{opp_side,skill,600402},{self,talk,[<<"火之沉默！">>]}]
        }
    };
get(ai_rule, 100555) ->
    {ok, 
        #npc_ai_rule{
            id = 100555
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1},{self,buff,<<"include">>,104140,1}]
            ,action = [{opp_side,skill,600403},{self,talk,[<<"火之消亡！">>]}]
        }
    };
get(ai_rule, 100556) ->
    {ok, 
        #npc_ai_rule{
            id = 100556
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1},{self,buff,<<"include">>,104140,1}]
            ,action = [{opp_side,skill,600404},{self,talk,[<<"火之压制！">>]}]
        }
    };
get(ai_rule, 100557) ->
    {ok, 
        #npc_ai_rule{
            id = 100557
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,0,1}]
            ,action = [{opp_side,skill,600405},{self,talk,[<<"蓄力！">>]}]
        }
    };
get(ai_rule, 100558) ->
    {ok, 
        #npc_ai_rule{
            id = 100558
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,22,1}]
            ,action = [{opp_side,skill,600406}]
        }
    };
get(ai_rule, 100559) ->
    {ok, 
        #npc_ai_rule{
            id = 100559
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,18,1}]
            ,action = [{opp_side,skill,600407}]
        }
    };
get(ai_rule, 100560) ->
    {ok, 
        #npc_ai_rule{
            id = 100560
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{opp_side,skill,600408}]
        }
    };
get(ai_rule, 100561) ->
    {ok, 
        #npc_ai_rule{
            id = 100561
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,buff,<<"not_in">>,200060,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1}]
            ,action = [{opp_side,skill,600409},{self,talk,[<<"要同时打败我们两个才行哦~">>]}]
        }
    };
get(ai_rule, 100562) ->
    {ok, 
        #npc_ai_rule{
            id = 100562
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,buff,<<"not_in">>,200060,1},{self_side,id,<<"=">>,16119,1},{suit_tar,hp,<<">">>,0,0},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1}]
            ,action = [{opp_side,skill,600410},{self,talk,[<<"双生水精灵~">>]}]
        }
    };
get(ai_rule, 100563) ->
    {ok, 
        #npc_ai_rule{
            id = 100563
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600411}]
        }
    };
get(ai_rule, 100564) ->
    {ok, 
        #npc_ai_rule{
            id = 100564
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,600412}]
        }
    };
get(ai_rule, 100565) ->
    {ok, 
        #npc_ai_rule{
            id = 100565
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1}]
            ,action = [{self,skill,600413}]
        }
    };
get(ai_rule, 100566) ->
    {ok, 
        #npc_ai_rule{
            id = 100566
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,0,1}]
            ,action = [{opp_side,skill,600414}]
        }
    };
get(ai_rule, 100567) ->
    {ok, 
        #npc_ai_rule{
            id = 100567
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,buff,<<"not_in">>,200060,1},{self_side,id,<<"=">>,16119,1},{suit_tar,hp,<<">">>,0,0},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1}]
            ,action = [{opp_side,skill,600415},{self,talk,[<<"不一起打败的话会复活的哦~">>]}]
        }
    };
get(ai_rule, 100568) ->
    {ok, 
        #npc_ai_rule{
            id = 100568
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600416}]
        }
    };
get(ai_rule, 100569) ->
    {ok, 
        #npc_ai_rule{
            id = 100569
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,600417}]
        }
    };
get(ai_rule, 100570) ->
    {ok, 
        #npc_ai_rule{
            id = 100570
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1}]
            ,action = [{self,skill,600418}]
        }
    };
get(ai_rule, 100571) ->
    {ok, 
        #npc_ai_rule{
            id = 100571
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,0,1}]
            ,action = [{opp_side,skill,600419}]
        }
    };
get(ai_rule, 100572) ->
    {ok, 
        #npc_ai_rule{
            id = 100572
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,hp,<<"<=">>,30,1}]
            ,action = [{opp_side,skill,600340}]
        }
    };
get(ai_rule, 100573) ->
    {ok, 
        #npc_ai_rule{
            id = 100573
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600001},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 100574) ->
    {ok, 
        #npc_ai_rule{
            id = 100574
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601004},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 100575) ->
    {ok, 
        #npc_ai_rule{
            id = 100575
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601029},{self,talk,[<<"你们休想过去！">>]}]
        }
    };
get(ai_rule, 100576) ->
    {ok, 
        #npc_ai_rule{
            id = 100576
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,2,1}]
            ,action = [{opp_side,skill,601029}]
        }
    };
get(ai_rule, 100577) ->
    {ok, 
        #npc_ai_rule{
            id = 100577
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1},{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,600003},{self,talk,[<<"你怎么长得那么好看？">>]}]
        }
    };
get(ai_rule, 100578) ->
    {ok, 
        #npc_ai_rule{
            id = 100578
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,1,1},{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{self,talk,[<<"别打我，哭哭哦">>]},{suit_tar,skill,600003}]
        }
    };
get(ai_rule, 100579) ->
    {ok, 
        #npc_ai_rule{
            id = 100579
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,600003},{self,talk,[<<"我怎么长得这么丑！">>]}]
        }
    };
get(ai_rule, 100580) ->
    {ok, 
        #npc_ai_rule{
            id = 100580
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,600003}]
        }
    };
get(ai_rule, 100581) ->
    {ok, 
        #npc_ai_rule{
            id = 100581
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1},{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,600003},{self,talk,[<<"我的能耐可大着呢">>]}]
        }
    };
get(ai_rule, 100582) ->
    {ok, 
        #npc_ai_rule{
            id = 100582
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,1,1},{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{self,talk,[<<"有本事你咬我啊">>]},{suit_tar,skill,600003}]
        }
    };
get(ai_rule, 100583) ->
    {ok, 
        #npc_ai_rule{
            id = 100583
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,600003},{self,talk,[<<"呜呜呜~哭哭哦">>]}]
        }
    };
get(ai_rule, 100584) ->
    {ok, 
        #npc_ai_rule{
            id = 100584
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,600003}]
        }
    };
get(ai_rule, 100585) ->
    {ok, 
        #npc_ai_rule{
            id = 100585
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self,talk,[<<"好久没有人敢来挑战我了！">>]},{opp_side,skill,600022}]
        }
    };
get(ai_rule, 100586) ->
    {ok, 
        #npc_ai_rule{
            id = 100586
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,talk,[<<"让你听听骨头断裂的声音！">>]},{opp_side,skill,600023}]
        }
    };
get(ai_rule, 100587) ->
    {ok, 
        #npc_ai_rule{
            id = 100587
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600024}]
        }
    };
get(ai_rule, 100588) ->
    {ok, 
        #npc_ai_rule{
            id = 100588
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600014},{self,talk,[<<"我要发疯了！">>]}]
        }
    };
get(ai_rule, 100589) ->
    {ok, 
        #npc_ai_rule{
            id = 100589
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"一榔头砸死你！">>]},{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100590) ->
    {ok, 
        #npc_ai_rule{
            id = 100590
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"我最喜欢捏死小蚂蚁了！">>]},{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100591) ->
    {ok, 
        #npc_ai_rule{
            id = 100591
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"臣服于我吧，或者受死！">>]},{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100592) ->
    {ok, 
        #npc_ai_rule{
            id = 100592
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600026}]
        }
    };
get(ai_rule, 100593) ->
    {ok, 
        #npc_ai_rule{
            id = 100593
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,talk,[<<"世界是我们的！">>]},{self_side,skill,600021}]
        }
    };
get(ai_rule, 100594) ->
    {ok, 
        #npc_ai_rule{
            id = 100594
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100595) ->
    {ok, 
        #npc_ai_rule{
            id = 100595
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,skill,601027}]
        }
    };
get(ai_rule, 100596) ->
    {ok, 
        #npc_ai_rule{
            id = 100596
            ,type = 0
            ,repeat = 0
            ,prob = 10
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,skill,601028}]
        }
    };
get(ai_rule, 100597) ->
    {ok, 
        #npc_ai_rule{
            id = 100597
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601014},{self,talk,[<<"打死我可以拿到好多好多金币哟~">>]}]
        }
    };
get(ai_rule, 100598) ->
    {ok, 
        #npc_ai_rule{
            id = 100598
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,601014},{self,talk,[<<"我是一只黄金大苹果~">>]}]
        }
    };
get(ai_rule, 100599) ->
    {ok, 
        #npc_ai_rule{
            id = 100599
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601014},{self,talk,[<<"打我丫打我丫~">>]}]
        }
    };
get(ai_rule, 100600) ->
    {ok, 
        #npc_ai_rule{
            id = 100600
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601029},{self,talk,[<<"你们休想过去！">>]}]
        }
    };
get(ai_rule, 100601) ->
    {ok, 
        #npc_ai_rule{
            id = 100601
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600001},{self,talk,[<<"哟又有玩家要打我们了~">>]}]
        }
    };
get(ai_rule, 100602) ->
    {ok, 
        #npc_ai_rule{
            id = 100602
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100603) ->
    {ok, 
        #npc_ai_rule{
            id = 100603
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600001}]
        }
    };
get(ai_rule, 100604) ->
    {ok, 
        #npc_ai_rule{
            id = 100604
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601004},{self,talk,[<<"这已经是第34627个了！">>]}]
        }
    };
get(ai_rule, 100605) ->
    {ok, 
        #npc_ai_rule{
            id = 100605
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601004}]
        }
    };
get(ai_rule, 100606) ->
    {ok, 
        #npc_ai_rule{
            id = 100606
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600022},{self,talk,[<<"邪恶的力量正待复苏……">>]}]
        }
    };
get(ai_rule, 100607) ->
    {ok, 
        #npc_ai_rule{
            id = 100607
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600023},{self,talk,[<<"恐惧会让你闭嘴！">>]}]
        }
    };
get(ai_rule, 100608) ->
    {ok, 
        #npc_ai_rule{
            id = 100608
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600024}]
        }
    };
get(ai_rule, 100609) ->
    {ok, 
        #npc_ai_rule{
            id = 100609
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600341},{self,talk,[<<"来吧！力量！！">>]}]
        }
    };
get(ai_rule, 100610) ->
    {ok, 
        #npc_ai_rule{
            id = 100610
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025},{self,talk,[<<"从你的眼里，我看到了我年轻时的样子">>]}]
        }
    };
get(ai_rule, 100611) ->
    {ok, 
        #npc_ai_rule{
            id = 100611
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600408},{self,talk,[<<"睡着了就不会感到痛了">>]}]
        }
    };
get(ai_rule, 100612) ->
    {ok, 
        #npc_ai_rule{
            id = 100612
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025},{self,talk,[<<"臣服于我吧，或者受死！">>]}]
        }
    };
get(ai_rule, 100613) ->
    {ok, 
        #npc_ai_rule{
            id = 100613
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600026}]
        }
    };
get(ai_rule, 100614) ->
    {ok, 
        #npc_ai_rule{
            id = 100614
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self_side,skill,600021},{self,talk,[<<"有朝一日，我们会占领整个世界">>]}]
        }
    };
get(ai_rule, 100615) ->
    {ok, 
        #npc_ai_rule{
            id = 100615
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100616) ->
    {ok, 
        #npc_ai_rule{
            id = 100616
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self_side,id,<<"=">>,16120,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{opp_side,skill,600044},{self,talk,[<<"你居然杀了我的宠物！">>]}]
        }
    };
get(ai_rule, 100617) ->
    {ok, 
        #npc_ai_rule{
            id = 100617
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self_side,id,<<"=">>,16121,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{opp_side,skill,600044},{self,talk,[<<"你居然杀了我的宠物！">>]}]
        }
    };
get(ai_rule, 100618) ->
    {ok, 
        #npc_ai_rule{
            id = 100618
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self_side,id,<<"=">>,16120,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,16121,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{opp_side,skill,600041},{self,talk,[<<"我要为宠物报仇！">>]}]
        }
    };
get(ai_rule, 100619) ->
    {ok, 
        #npc_ai_rule{
            id = 100619
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,skill,600049},{self,talk,[<<"等我休息会儿在和你们打">>]}]
        }
    };
get(ai_rule, 100620) ->
    {ok, 
        #npc_ai_rule{
            id = 100620
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{opp_side,skill,600041},{self,talk,[<<"吃我的无敌大群杀啦！！！！">>]}]
        }
    };
get(ai_rule, 100621) ->
    {ok, 
        #npc_ai_rule{
            id = 100621
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,sex,<<"=">>,0,1}]
            ,action = [{self,skill,600042},{self,talk,[<<"我最喜欢打女孩子了~">>]}]
        }
    };
get(ai_rule, 100622) ->
    {ok, 
        #npc_ai_rule{
            id = 100622
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,sex,<<"=">>,1,1}]
            ,action = [{self,skill,600043},{self,talk,[<<"我最喜欢打男孩子了~">>]}]
        }
    };
get(ai_rule, 100623) ->
    {ok, 
        #npc_ai_rule{
            id = 100623
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600044},{self,talk,[<<"哟哟！切克闹！">>]}]
        }
    };
get(ai_rule, 100624) ->
    {ok, 
        #npc_ai_rule{
            id = 100624
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600045},{self,talk,[<<"哇呀呀呀！">>]}]
        }
    };
get(ai_rule, 100625) ->
    {ok, 
        #npc_ai_rule{
            id = 100625
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600047},{self,talk,[<<"去吧！瞌睡虫！">>]}]
        }
    };
get(ai_rule, 100626) ->
    {ok, 
        #npc_ai_rule{
            id = 100626
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{self,skill,600048}]
        }
    };
get(ai_rule, 100627) ->
    {ok, 
        #npc_ai_rule{
            id = 100627
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,600343},{self,talk,[<<"出来吧我的宠物！">>]}]
        }
    };
get(ai_rule, 100628) ->
    {ok, 
        #npc_ai_rule{
            id = 100628
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600045}]
        }
    };
get(ai_rule, 100629) ->
    {ok, 
        #npc_ai_rule{
            id = 100629
            ,type = 0
            ,repeat = 1
            ,prob = 90
            ,condition = [{combat,round,<<">=">>,1,1},{self_side,id,<<"=">>,10338,1},{suit_tar,hp,<<"<=">>,70,1}]
            ,action = [{suit_tar,skill,600341},{self,talk,[<<"别想伤老大一根毫毛！">>]}]
        }
    };
get(ai_rule, 100630) ->
    {ok, 
        #npc_ai_rule{
            id = 100630
            ,type = 0
            ,repeat = 1
            ,prob = 90
            ,condition = [{combat,round,<<">=">>,1,1},{self_side,id,<<"=">>,11338,1},{suit_tar,hp,<<"<=">>,70,1}]
            ,action = [{suit_tar,skill,600341},{self,talk,[<<"别想伤老大一根毫毛！">>]}]
        }
    };
get(ai_rule, 100631) ->
    {ok, 
        #npc_ai_rule{
            id = 100631
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601009}]
        }
    };
get(ai_rule, 100632) ->
    {ok, 
        #npc_ai_rule{
            id = 100632
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601000},{self,talk,[<<"整天被打，我很愤怒！">>]}]
        }
    };
get(ai_rule, 100633) ->
    {ok, 
        #npc_ai_rule{
            id = 100633
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{self,skill,600292}]
        }
    };
get(ai_rule, 100634) ->
    {ok, 
        #npc_ai_rule{
            id = 100634
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1},{opp_side,career,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600344},{self,talk,[<<"被打到连技能都学会了">>]}]
        }
    };
get(ai_rule, 100635) ->
    {ok, 
        #npc_ai_rule{
            id = 100635
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1},{opp_side,career,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600345},{self,talk,[<<"被打到连技能都学会了">>]}]
        }
    };
get(ai_rule, 100636) ->
    {ok, 
        #npc_ai_rule{
            id = 100636
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1},{opp_side,career,<<"=">>,5,1}]
            ,action = [{opp_side,skill,600346},{self,talk,[<<"被打到连技能都学会了">>]}]
        }
    };
get(ai_rule, 100637) ->
    {ok, 
        #npc_ai_rule{
            id = 100637
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,600023},{self,talk,[<<"看我这招！">>]}]
        }
    };
get(ai_rule, 100638) ->
    {ok, 
        #npc_ai_rule{
            id = 100638
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,601016}]
        }
    };
get(ai_rule, 100639) ->
    {ok, 
        #npc_ai_rule{
            id = 100639
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601006}]
        }
    };
get(ai_rule, 100640) ->
    {ok, 
        #npc_ai_rule{
            id = 100640
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601006}]
        }
    };
get(ai_rule, 100641) ->
    {ok, 
        #npc_ai_rule{
            id = 100641
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601009}]
        }
    };
get(ai_rule, 100642) ->
    {ok, 
        #npc_ai_rule{
            id = 100642
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601009}]
        }
    };
get(ai_rule, 100643) ->
    {ok, 
        #npc_ai_rule{
            id = 100643
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601009}]
        }
    };
get(ai_rule, 100644) ->
    {ok, 
        #npc_ai_rule{
            id = 100644
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601009}]
        }
    };
get(ai_rule, 100645) ->
    {ok, 
        #npc_ai_rule{
            id = 100645
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601015}]
        }
    };
get(ai_rule, 100646) ->
    {ok, 
        #npc_ai_rule{
            id = 100646
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601015}]
        }
    };
get(ai_rule, 100647) ->
    {ok, 
        #npc_ai_rule{
            id = 100647
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601015}]
        }
    };
get(ai_rule, 100648) ->
    {ok, 
        #npc_ai_rule{
            id = 100648
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601015}]
        }
    };
get(ai_rule, 100649) ->
    {ok, 
        #npc_ai_rule{
            id = 100649
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600003},{self,talk,[<<"刚磨的斧头，拿你试试！">>]}]
        }
    };
get(ai_rule, 100650) ->
    {ok, 
        #npc_ai_rule{
            id = 100650
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600003},{self,talk,[<<"让我的斧头沾染点血气吧！">>]}]
        }
    };
get(ai_rule, 100651) ->
    {ok, 
        #npc_ai_rule{
            id = 100651
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100652) ->
    {ok, 
        #npc_ai_rule{
            id = 100652
            ,type = 0
            ,repeat = 1
            ,prob = 33
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,hp,<<"<=">>,30,1}]
            ,action = [{opp_side,skill,600348}]
        }
    };
get(ai_rule, 100653) ->
    {ok, 
        #npc_ai_rule{
            id = 100653
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,hp,<<"<=">>,30,1}]
            ,action = [{opp_side,skill,600349}]
        }
    };
get(ai_rule, 100654) ->
    {ok, 
        #npc_ai_rule{
            id = 100654
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,hp,<<"<=">>,30,1}]
            ,action = [{self_side,skill,600350}]
        }
    };
get(ai_rule, 100655) ->
    {ok, 
        #npc_ai_rule{
            id = 100655
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600022}]
        }
    };
get(ai_rule, 100656) ->
    {ok, 
        #npc_ai_rule{
            id = 100656
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600024}]
        }
    };
get(ai_rule, 100657) ->
    {ok, 
        #npc_ai_rule{
            id = 100657
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600014}]
        }
    };
get(ai_rule, 100658) ->
    {ok, 
        #npc_ai_rule{
            id = 100658
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100659) ->
    {ok, 
        #npc_ai_rule{
            id = 100659
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100660) ->
    {ok, 
        #npc_ai_rule{
            id = 100660
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100661) ->
    {ok, 
        #npc_ai_rule{
            id = 100661
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600026}]
        }
    };
get(ai_rule, 100662) ->
    {ok, 
        #npc_ai_rule{
            id = 100662
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self_side,skill,600021}]
        }
    };
get(ai_rule, 100663) ->
    {ok, 
        #npc_ai_rule{
            id = 100663
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100669) ->
    {ok, 
        #npc_ai_rule{
            id = 100669
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1},{opp_side,sex,<<"=">>,0,1}]
            ,action = [{opp_side,skill,601005},{self,talk,[<<"我要开始欺负你了，小菇凉">>]}]
        }
    };
get(ai_rule, 100670) ->
    {ok, 
        #npc_ai_rule{
            id = 100670
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1},{opp_side,sex,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601005},{self,talk,[<<"我要开始欺负你了，小伙子">>]}]
        }
    };
get(ai_rule, 100671) ->
    {ok, 
        #npc_ai_rule{
            id = 100671
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600419},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 100672) ->
    {ok, 
        #npc_ai_rule{
            id = 100672
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600161},{self,talk,[<<"我要开始糊你一脸了">>]}]
        }
    };
get(ai_rule, 100673) ->
    {ok, 
        #npc_ai_rule{
            id = 100673
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600162},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 100674) ->
    {ok, 
        #npc_ai_rule{
            id = 100674
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,14,1}]
            ,action = [{opp_side,skill,601005},{self,talk,[<<"呜呜，难道勋章真的要给你了吗">>]}]
        }
    };
get(ai_rule, 100675) ->
    {ok, 
        #npc_ai_rule{
            id = 100675
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{self,skill,600033},{self,talk,[<<"我可是坚硬如磐石的男人">>]}]
        }
    };
get(ai_rule, 100676) ->
    {ok, 
        #npc_ai_rule{
            id = 100676
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,2,1}]
            ,action = [{self,skill,600086}]
        }
    };
get(ai_rule, 100677) ->
    {ok, 
        #npc_ai_rule{
            id = 100677
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,3,1}]
            ,action = [{opp_side,skill,600210}]
        }
    };
get(ai_rule, 100678) ->
    {ok, 
        #npc_ai_rule{
            id = 100678
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,4,1}]
            ,action = [{opp_side,skill,600068},{self,talk,[<<"哼，妈妈说最毒魔人心">>]}]
        }
    };
get(ai_rule, 100679) ->
    {ok, 
        #npc_ai_rule{
            id = 100679
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,0,1}]
            ,action = [{opp_side,skill,600003},{self,talk,[<<"想要过关吗，总感觉你不够强啊">>]}]
        }
    };
get(ai_rule, 100680) ->
    {ok, 
        #npc_ai_rule{
            id = 100680
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,930001},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 100681) ->
    {ok, 
        #npc_ai_rule{
            id = 100681
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,930002},{self,talk,[<<"先把你们脱光光">>]}]
        }
    };
get(ai_rule, 100682) ->
    {ok, 
        #npc_ai_rule{
            id = 100682
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,skill,930003},{self,talk,[<<"燃起我的蓝焰之火">>]}]
        }
    };
get(ai_rule, 100683) ->
    {ok, 
        #npc_ai_rule{
            id = 100683
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,930004},{self,talk,[<<"接下来我可是会越来越强喔">>]}]
        }
    };
get(ai_rule, 100684) ->
    {ok, 
        #npc_ai_rule{
            id = 100684
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,930005},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 100685) ->
    {ok, 
        #npc_ai_rule{
            id = 100685
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{opp_side,skill,930006},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 100686) ->
    {ok, 
        #npc_ai_rule{
            id = 100686
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{opp_side,skill,930007},{self,talk,[<<"你再不制止我，你就没有机会了">>]}]
        }
    };
get(ai_rule, 100687) ->
    {ok, 
        #npc_ai_rule{
            id = 100687
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,8,1}]
            ,action = [{opp_side,skill,930008},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 100688) ->
    {ok, 
        #npc_ai_rule{
            id = 100688
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,9,1}]
            ,action = [{opp_side,skill,930009},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 100689) ->
    {ok, 
        #npc_ai_rule{
            id = 100689
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,10,1}]
            ,action = [{opp_side,skill,930010},{self,talk,[<<"你已经完全没有机会了">>]}]
        }
    };
get(ai_rule, 100690) ->
    {ok, 
        #npc_ai_rule{
            id = 100690
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,930011},{self,talk,[<<"地狱使者不可侵犯">>]}]
        }
    };
get(ai_rule, 100691) ->
    {ok, 
        #npc_ai_rule{
            id = 100691
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,2,1}]
            ,action = [{opp_side,skill,930004},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 100692) ->
    {ok, 
        #npc_ai_rule{
            id = 100692
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{self,skill,930015},{self,talk,[<<"哈士奇，出来吧">>]}]
        }
    };
get(ai_rule, 100693) ->
    {ok, 
        #npc_ai_rule{
            id = 100693
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,7,1}]
            ,action = [{self,skill,930016},{self,talk,[<<"这下你没有机会了">>]}]
        }
    };
get(ai_rule, 100694) ->
    {ok, 
        #npc_ai_rule{
            id = 100694
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1}]
            ,action = [{opp_side,skill,930004},{self,talk,[<<"你再不制止我，你就没有机会了">>]}]
        }
    };
get(ai_rule, 100695) ->
    {ok, 
        #npc_ai_rule{
            id = 100695
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,930021},{self,talk,[<<"可不要轻易中毒喔">>]}]
        }
    };
get(ai_rule, 100696) ->
    {ok, 
        #npc_ai_rule{
            id = 100696
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,2,1}]
            ,action = [{opp_side,skill,930025}]
        }
    };
get(ai_rule, 100697) ->
    {ok, 
        #npc_ai_rule{
            id = 100697
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,3,1}]
            ,action = [{opp_side,skill,930025}]
        }
    };
get(ai_rule, 100698) ->
    {ok, 
        #npc_ai_rule{
            id = 100698
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,4,1}]
            ,action = [{opp_side,skill,930025}]
        }
    };
get(ai_rule, 100699) ->
    {ok, 
        #npc_ai_rule{
            id = 100699
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,0,1}]
            ,action = [{opp_side,skill,930025}]
        }
    };
get(ai_rule, 100700) ->
    {ok, 
        #npc_ai_rule{
            id = 100700
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,209030,1}]
            ,action = [{opp_side,skill,930022},{self,talk,[<<"中毒了，可就是加倍的伤害">>]}]
        }
    };
get(ai_rule, 100701) ->
    {ok, 
        #npc_ai_rule{
            id = 100701
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,209030,1}]
            ,action = [{opp_side,skill,930022}]
        }
    };
get(ai_rule, 100702) ->
    {ok, 
        #npc_ai_rule{
            id = 100702
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<">>,50,1}]
            ,action = [{self,skill,930036},{self,talk,[<<"想干翻老子吗，给你点颜色瞧瞧">>]}]
        }
    };
get(ai_rule, 100703) ->
    {ok, 
        #npc_ai_rule{
            id = 100703
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<">>,20,1}]
            ,action = [{self,skill,930041},{self,talk,[<<"次奥，还真的有点厉害了">>]}]
        }
    };
get(ai_rule, 100704) ->
    {ok, 
        #npc_ai_rule{
            id = 100704
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,930031}]
        }
    };
get(ai_rule, 100705) ->
    {ok, 
        #npc_ai_rule{
            id = 100705
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,930038}]
        }
    };
get(ai_rule, 100706) ->
    {ok, 
        #npc_ai_rule{
            id = 100706
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,930043}]
        }
    };
get(ai_rule, 100707) ->
    {ok, 
        #npc_ai_rule{
            id = 100707
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,930037}]
        }
    };
get(ai_rule, 100708) ->
    {ok, 
        #npc_ai_rule{
            id = 100708
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600017}]
        }
    };
get(ai_rule, 100709) ->
    {ok, 
        #npc_ai_rule{
            id = 100709
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600018}]
        }
    };
get(ai_rule, 100710) ->
    {ok, 
        #npc_ai_rule{
            id = 100710
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600019}]
        }
    };
get(ai_rule, 100711) ->
    {ok, 
        #npc_ai_rule{
            id = 100711
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600014}]
        }
    };
get(ai_rule, 100712) ->
    {ok, 
        #npc_ai_rule{
            id = 100712
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,career,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100713) ->
    {ok, 
        #npc_ai_rule{
            id = 100713
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,career,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100714) ->
    {ok, 
        #npc_ai_rule{
            id = 100714
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,career,<<"=">>,5,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100715) ->
    {ok, 
        #npc_ai_rule{
            id = 100715
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600020}]
        }
    };
get(ai_rule, 100716) ->
    {ok, 
        #npc_ai_rule{
            id = 100716
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self_side,skill,600021}]
        }
    };
get(ai_rule, 100717) ->
    {ok, 
        #npc_ai_rule{
            id = 100717
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100718) ->
    {ok, 
        #npc_ai_rule{
            id = 100718
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,600022}]
        }
    };
get(ai_rule, 100719) ->
    {ok, 
        #npc_ai_rule{
            id = 100719
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600023}]
        }
    };
get(ai_rule, 100720) ->
    {ok, 
        #npc_ai_rule{
            id = 100720
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600024}]
        }
    };
get(ai_rule, 100721) ->
    {ok, 
        #npc_ai_rule{
            id = 100721
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600014}]
        }
    };
get(ai_rule, 100722) ->
    {ok, 
        #npc_ai_rule{
            id = 100722
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100723) ->
    {ok, 
        #npc_ai_rule{
            id = 100723
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100724) ->
    {ok, 
        #npc_ai_rule{
            id = 100724
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100725) ->
    {ok, 
        #npc_ai_rule{
            id = 100725
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600026}]
        }
    };
get(ai_rule, 100726) ->
    {ok, 
        #npc_ai_rule{
            id = 100726
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self_side,skill,600021}]
        }
    };
get(ai_rule, 100727) ->
    {ok, 
        #npc_ai_rule{
            id = 100727
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600025}]
        }
    };
get(ai_rule, 100728) ->
    {ok, 
        #npc_ai_rule{
            id = 100728
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side,hp,<<"<=">>,20,1},{opp_side,fighter_type,<<"=">>,2,1},{suit_tar,hp,<<">=">>,0,1}]
            ,action = [{suit_tar,skill,600003}]
        }
    };
get(ai_rule, 100729) ->
    {ok, 
        #npc_ai_rule{
            id = 100729
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side,hp,<<"<=">>,20,1},{opp_side,fighter_type,<<"=">>,2,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{opp_side,skill,600340}]
        }
    };
get(ai_rule, 100732) ->
    {ok, 
        #npc_ai_rule{
            id = 100732
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600003},{self,talk,[<<"又是一个新兵~">>]}]
        }
    };
get(ai_rule, 100733) ->
    {ok, 
        #npc_ai_rule{
            id = 100733
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,600003},{self,talk,[<<"打败我你就可以拿到勋章了。">>]}]
        }
    };
get(ai_rule, 100734) ->
    {ok, 
        #npc_ai_rule{
            id = 100734
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100735) ->
    {ok, 
        #npc_ai_rule{
            id = 100735
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600003},{self,talk,[<<"呀呀！">>]}]
        }
    };
get(ai_rule, 100736) ->
    {ok, 
        #npc_ai_rule{
            id = 100736
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600003}]
        }
    };
get(ai_rule, 100737) ->
    {ok, 
        #npc_ai_rule{
            id = 100737
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601014},{self,talk,[<<"又是人类！">>]}]
        }
    };
get(ai_rule, 100738) ->
    {ok, 
        #npc_ai_rule{
            id = 100738
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,601014},{self,talk,[<<"打我跟挠痒痒一样~">>]}]
        }
    };
get(ai_rule, 100739) ->
    {ok, 
        #npc_ai_rule{
            id = 100739
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601014}]
        }
    };
get(ai_rule, 100740) ->
    {ok, 
        #npc_ai_rule{
            id = 100740
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601014},{self,talk,[<<"看我漂亮的枪法~">>]}]
        }
    };
get(ai_rule, 100741) ->
    {ok, 
        #npc_ai_rule{
            id = 100741
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601014},{self,talk,[<<"哟还强化了装备！">>]}]
        }
    };
get(ai_rule, 100742) ->
    {ok, 
        #npc_ai_rule{
            id = 100742
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601014},{self,talk,[<<"有本事秒了我们啊~">>]}]
        }
    };
get(ai_rule, 101000) ->
    {ok, 
        #npc_ai_rule{
            id = 101000
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601000}]
        }
    };
get(ai_rule, 101001) ->
    {ok, 
        #npc_ai_rule{
            id = 101001
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601001}]
        }
    };
get(ai_rule, 101002) ->
    {ok, 
        #npc_ai_rule{
            id = 101002
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601002}]
        }
    };
get(ai_rule, 101003) ->
    {ok, 
        #npc_ai_rule{
            id = 101003
            ,type = 0
            ,repeat = 0
            ,prob = 14
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"“提升装备”是提升实力的重要方法">>]}]
        }
    };
get(ai_rule, 101004) ->
    {ok, 
        #npc_ai_rule{
            id = 101004
            ,type = 0
            ,repeat = 0
            ,prob = 17
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"“技能连招说明”会教你如何搭配技能">>]}]
        }
    };
get(ai_rule, 101005) ->
    {ok, 
        #npc_ai_rule{
            id = 101005
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"“升级技能”是提升实力的重要方法">>]}]
        }
    };
get(ai_rule, 101006) ->
    {ok, 
        #npc_ai_rule{
            id = 101006
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"提升伙伴能让战斗更轻松">>]}]
        }
    };
get(ai_rule, 101007) ->
    {ok, 
        #npc_ai_rule{
            id = 101007
            ,type = 0
            ,repeat = 0
            ,prob = 34
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"“提升神觉”是提升实力的重要手段">>]}]
        }
    };
get(ai_rule, 101008) ->
    {ok, 
        #npc_ai_rule{
            id = 101008
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"装备除了强化，还有镶嵌、鉴定、制作等">>]}]
        }
    };
get(ai_rule, 101009) ->
    {ok, 
        #npc_ai_rule{
            id = 101009
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"多研究一下各种材料是从哪里获得">>]}]
        }
    };
get(ai_rule, 101013) ->
    {ok, 
        #npc_ai_rule{
            id = 101013
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"“提升潜能”是培养伙伴的重要方法">>]}]
        }
    };
get(ai_rule, 101014) ->
    {ok, 
        #npc_ai_rule{
            id = 101014
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"“学习技能”是培养伙伴的重要方法">>]}]
        }
    };
get(ai_rule, 101015) ->
    {ok, 
        #npc_ai_rule{
            id = 101015
            ,type = 0
            ,repeat = 0
            ,prob = 34
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"伙伴技能在“龙族遗迹”里获得">>]}]
        }
    };
get(ai_rule, 101018) ->
    {ok, 
        #npc_ai_rule{
            id = 101018
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"伙伴每升一级可以获得20点基础属性">>]}]
        }
    };
get(ai_rule, 101019) ->
    {ok, 
        #npc_ai_rule{
            id = 101019
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,601003},{self,talk,[<<"通过庄园的训龙精灵可以快速提升伙伴等级">>]}]
        }
    };
get(ai_rule, 101023) ->
    {ok, 
        #npc_ai_rule{
            id = 101023
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601003}]
        }
    };
get(ai_rule, 101024) ->
    {ok, 
        #npc_ai_rule{
            id = 101024
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600015}]
        }
    };
get(ai_rule, 11328) ->
    {ok, 
        #npc_ai_rule{
            id = 11328
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,90,1}]
            ,action = [{self,skill,706160},{self,talk,[<<"看來我还是小瞧你了。">>]}]
        }
    };
get(ai_rule, 11329) ->
    {ok, 
        #npc_ai_rule{
            id = 11329
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,35,1}]
            ,action = [{opp_side,skill,706170}]
        }
    };
get(ai_rule, 11330) ->
    {ok, 
        #npc_ai_rule{
            id = 11330
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{self,hp,<<"<=">>,15,1}]
            ,action = [{self,skill,706180},{self,talk,[<<"不可能，我是无敌的蟹老板！">>]}]
        }
    };
get(ai_rule, 11331) ->
    {ok, 
        #npc_ai_rule{
            id = 11331
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706190},{self,talk,[<<"头晕不晕？">>]}]
        }
    };
get(ai_rule, 11332) ->
    {ok, 
        #npc_ai_rule{
            id = 11332
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{self,skill,706200},{self,talk,[<<"你们看起来很好吃啊~">>]}]
        }
    };
get(ai_rule, 11334) ->
    {ok, 
        #npc_ai_rule{
            id = 11334
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{self,skill,706210}]
        }
    };
get(ai_rule, 11335) ->
    {ok, 
        #npc_ai_rule{
            id = 11335
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{combat,round,<<"=">>,8,1}]
            ,action = [{opp_side,skill,706220},{self,talk,[<<"在痛苦中掙扎吧！哈哈哈。">>]}]
        }
    };
get(ai_rule, 11336) ->
    {ok, 
        #npc_ai_rule{
            id = 11336
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{combat,round,<<"=">>,9,1}]
            ,action = [{opp_side,skill,706230}]
        }
    };
get(ai_rule, 11337) ->
    {ok, 
        #npc_ai_rule{
            id = 11337
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">">>,1,1},{opp_side,hp,<<"<">>,30,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706240},{self,talk,[<<"哈哈，这次你还不死？">>]}]
        }
    };
get(ai_rule, 11338) ->
    {ok, 
        #npc_ai_rule{
            id = 11338
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,12,1}]
            ,action = [{opp_side,skill,706240}]
        }
    };
get(ai_rule, 11339) ->
    {ok, 
        #npc_ai_rule{
            id = 11339
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,14,1}]
            ,action = [{self,skill,706160},{self,talk,[<<"如果现在求饶，我可以让你做我的水手~">>]}]
        }
    };
get(ai_rule, 11340) ->
    {ok, 
        #npc_ai_rule{
            id = 11340
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,15,1},{opp_side,hp,<<">=">>,30,2}]
            ,action = [{opp_side,skill,706250}]
        }
    };
get(ai_rule, 11341) ->
    {ok, 
        #npc_ai_rule{
            id = 11341
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,0,1}]
            ,action = [{opp_side,skill,706250}]
        }
    };
get(ai_rule, 11342) ->
    {ok, 
        #npc_ai_rule{
            id = 11342
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,20,1}]
            ,action = [{opp_side,skill,706250}]
        }
    };
get(ai_rule, 11343) ->
    {ok, 
        #npc_ai_rule{
            id = 11343
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,80,1}]
            ,action = [{opp_side,skill,706260}]
        }
    };
get(ai_rule, 11344) ->
    {ok, 
        #npc_ai_rule{
            id = 11344
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,55,1},{opp_side,buff,<<"not_in">>,200060,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706270},{self,talk,[<<"不好意思，我今天的斧子不快，你还是下次再來送死吧。">>]}]
        }
    };
get(ai_rule, 11345) ->
    {ok, 
        #npc_ai_rule{
            id = 11345
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{opp_side,buff,<<"not_in">>,200060,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706280}]
        }
    };
get(ai_rule, 11346) ->
    {ok, 
        #npc_ai_rule{
            id = 11346
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,15,1}]
            ,action = [{self,skill,706290},{self,talk,[<<"别抢我的宝藏好吗555">>]}]
        }
    };
get(ai_rule, 11347) ->
    {ok, 
        #npc_ai_rule{
            id = 11347
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,706300},{self,talk,[<<"哟呵小家伙~">>]}]
        }
    };
get(ai_rule, 11348) ->
    {ok, 
        #npc_ai_rule{
            id = 11348
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1},{opp_side,buff,<<"not_in">>,200060,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706270},{self,talk,[<<"一斧子砸晕你！">>]}]
        }
    };
get(ai_rule, 11349) ->
    {ok, 
        #npc_ai_rule{
            id = 11349
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{opp_side,skill,706310},{self,talk,[<<"抓你回去擦甲板！~">>]}]
        }
    };
get(ai_rule, 11350) ->
    {ok, 
        #npc_ai_rule{
            id = 11350
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,8,1}]
            ,action = [{opp_side,skill,706320}]
        }
    };
get(ai_rule, 11351) ->
    {ok, 
        #npc_ai_rule{
            id = 11351
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{combat,round,<<"=">>,9,1}]
            ,action = [{opp_side,skill,706280},{self,talk,[<<"朗姆酒可以让你忘掉疼痛！">>]}]
        }
    };
get(ai_rule, 11352) ->
    {ok, 
        #npc_ai_rule{
            id = 11352
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,10,1}]
            ,action = [{opp_side,skill,706260},{self,talk,[<<"这三斧头下来疼吗？">>]}]
        }
    };
get(ai_rule, 11353) ->
    {ok, 
        #npc_ai_rule{
            id = 11353
            ,type = 0
            ,repeat = 0
            ,prob = 95
            ,condition = [{combat,round,<<"=">>,13,1}]
            ,action = [{opp_side,skill,706330}]
        }
    };
get(ai_rule, 11354) ->
    {ok, 
        #npc_ai_rule{
            id = 11354
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,14,1},{opp_side,buff,<<"not_in">>,200060,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706270}]
        }
    };
get(ai_rule, 11355) ->
    {ok, 
        #npc_ai_rule{
            id = 11355
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{combat,round,<<"=">>,16,1}]
            ,action = [{opp_side,skill,706320},{self,talk,[<<"不错嘛，在我斧头下能撑这么久。">>]}]
        }
    };
get(ai_rule, 11356) ->
    {ok, 
        #npc_ai_rule{
            id = 11356
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,17,1},{opp_side,buff,<<"not_in">>,200060,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706270}]
        }
    };
get(ai_rule, 11357) ->
    {ok, 
        #npc_ai_rule{
            id = 11357
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,19,1},{opp_side,hp,<<">=">>,40,1}]
            ,action = [{opp_side,skill,706320},{self,talk,[<<"打得太烦啦，能不能快点死！">>]}]
        }
    };
get(ai_rule, 11358) ->
    {ok, 
        #npc_ai_rule{
            id = 11358
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">">>,1,1},{opp_side,buff,<<"not_in">>,201030,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706330}]
        }
    };
get(ai_rule, 11359) ->
    {ok, 
        #npc_ai_rule{
            id = 11359
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,706320}]
        }
    };
get(ai_rule, 11360) ->
    {ok, 
        #npc_ai_rule{
            id = 11360
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,25,1}]
            ,action = [{opp_side,skill,706320},{self,talk,[<<"来成为我的奴隶吧！">>]}]
        }
    };
get(ai_rule, 11532) ->
    {ok, 
        #npc_ai_rule{
            id = 11532
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,80,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,707050}]
        }
    };
get(ai_rule, 11533) ->
    {ok, 
        #npc_ai_rule{
            id = 11533
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1}]
            ,action = [{opp_side,skill,707060},{self,talk,[<<"就不能对女士温柔一点吗啊？">>]}]
        }
    };
get(ai_rule, 11534) ->
    {ok, 
        #npc_ai_rule{
            id = 11534
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,707050},{self,talk,[<<"不玩啦，我要回家！">>]}]
        }
    };
get(ai_rule, 11535) ->
    {ok, 
        #npc_ai_rule{
            id = 11535
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,707140},{self,talk,[<<"死螃蟹被你打死了吗？">>]}]
        }
    };
get(ai_rule, 11536) ->
    {ok, 
        #npc_ai_rule{
            id = 11536
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,2,1},{self,buff,<<"not_in">>,101230,1}]
            ,action = [{opp_side,skill,707050}]
        }
    };
get(ai_rule, 11537) ->
    {ok, 
        #npc_ai_rule{
            id = 11537
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1},{self,buff,<<"not_in">>,101230,1},{opp_side,buff,<<"not_in">>,200040,2}]
            ,action = [{self,skill,707070},{self,talk,[<<"小朋友，想不想上船玩玩啊~">>]}]
        }
    };
get(ai_rule, 11538) ->
    {ok, 
        #npc_ai_rule{
            id = 11538
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,707080},{self,talk,[<<"我的船是海上最温柔的杀手~">>]}]
        }
    };
get(ai_rule, 11539) ->
    {ok, 
        #npc_ai_rule{
            id = 11539
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{combat,round,<<"=">>,6,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,707090}]
        }
    };
get(ai_rule, 11540) ->
    {ok, 
        #npc_ai_rule{
            id = 11540
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,9,1}]
            ,action = [{opp_side,skill,707100},{self,talk,[<<"对本女王尊重一点！">>]}]
        }
    };
get(ai_rule, 11541) ->
    {ok, 
        #npc_ai_rule{
            id = 11541
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,10,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,707050}]
        }
    };
get(ai_rule, 11542) ->
    {ok, 
        #npc_ai_rule{
            id = 11542
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,11,1},{opp_side,career,<<"=">>,1,1}]
            ,action = [{self,skill,707140}]
        }
    };
get(ai_rule, 11543) ->
    {ok, 
        #npc_ai_rule{
            id = 11543
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,11,1},{opp_side,hp,<<"<">>,30,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,707110},{self,talk,[<<"要死了啊，小朋友~">>]}]
        }
    };
get(ai_rule, 11544) ->
    {ok, 
        #npc_ai_rule{
            id = 11544
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,13,1}]
            ,action = [{self,skill,707070}]
        }
    };
get(ai_rule, 11545) ->
    {ok, 
        #npc_ai_rule{
            id = 11545
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,14,1}]
            ,action = [{opp_side,skill,707080},{self,talk,[<<"看到我，难道你没有心动吗？~">>]}]
        }
    };
get(ai_rule, 11546) ->
    {ok, 
        #npc_ai_rule{
            id = 11546
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,16,1},{opp_side,hp,<<"<">>,30,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,707110}]
        }
    };
get(ai_rule, 11547) ->
    {ok, 
        #npc_ai_rule{
            id = 11547
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1}]
            ,action = [{opp_side,skill,707080}]
        }
    };
get(ai_rule, 11548) ->
    {ok, 
        #npc_ai_rule{
            id = 11548
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,20,1},{opp_side,hp,<<"<">>,20,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,707120},{self,talk,[<<"两刀砍下去，舒服多了！">>]}]
        }
    };
get(ai_rule, 11549) ->
    {ok, 
        #npc_ai_rule{
            id = 11549
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,24,1}]
            ,action = [{opp_side,skill,707080}]
        }
    };
get(ai_rule, 11550) ->
    {ok, 
        #npc_ai_rule{
            id = 11550
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,27,1}]
            ,action = [{self,skill,707130}]
        }
    };
get(ai_rule, 11551) ->
    {ok, 
        #npc_ai_rule{
            id = 11551
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,28,1},{opp_side,hp,<<"<">>,20,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,707120},{self,talk,[<<"两刀砍下去，舒服多了！">>]}]
        }
    };
get(ai_rule, 11552) ->
    {ok, 
        #npc_ai_rule{
            id = 11552
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,29,1}]
            ,action = [{opp_side,skill,707080}]
        }
    };
get(ai_rule, 11553) ->
    {ok, 
        #npc_ai_rule{
            id = 11553
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod2">>,1,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,707090}]
        }
    };
get(ai_rule, 11554) ->
    {ok, 
        #npc_ai_rule{
            id = 11554
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod2">>,0,1}]
            ,action = [{opp_side,skill,707110}]
        }
    };
get(ai_rule, 11555) ->
    {ok, 
        #npc_ai_rule{
            id = 11555
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,30,1},{opp_side,hp,<<"<">>,20,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,707120},{self,talk,[<<"不玩了好吗，快死吧~">>]}]
        }
    };
get(ai_rule, 11556) ->
    {ok, 
        #npc_ai_rule{
            id = 11556
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,30,1}]
            ,action = [{opp_side,skill,707080}]
        }
    };
get(ai_rule, 11378) ->
    {ok, 
        #npc_ai_rule{
            id = 11378
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,80,1}]
            ,action = [{opp_side,skill,706420}]
        }
    };
get(ai_rule, 11379) ->
    {ok, 
        #npc_ai_rule{
            id = 11379
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,55,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706430},{self,talk,[<<"哎哟你挺厉害啊~">>]}]
        }
    };
get(ai_rule, 11380) ->
    {ok, 
        #npc_ai_rule{
            id = 11380
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,skill,706440},{self,talk,[<<"请问附近有没有洞可以钻啊？">>]}]
        }
    };
get(ai_rule, 11381) ->
    {ok, 
        #npc_ai_rule{
            id = 11381
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,706450},{self,talk,[<<"我是东瀛海盗杰瑞~">>]}]
        }
    };
get(ai_rule, 11382) ->
    {ok, 
        #npc_ai_rule{
            id = 11382
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{combat,round,<<">=">>,2,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706460},{self,talk,[<<"别小看我！">>]}]
        }
    };
get(ai_rule, 11383) ->
    {ok, 
        #npc_ai_rule{
            id = 11383
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,706470}]
        }
    };
get(ai_rule, 11384) ->
    {ok, 
        #npc_ai_rule{
            id = 11384
            ,type = 0
            ,repeat = 0
            ,prob = 85
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,706420},{self,talk,[<<"忍者神龟是我的徒弟~">>]}]
        }
    };
get(ai_rule, 11385) ->
    {ok, 
        #npc_ai_rule{
            id = 11385
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{opp_side,skill,706470}]
        }
    };
get(ai_rule, 11386) ->
    {ok, 
        #npc_ai_rule{
            id = 11386
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{self,skill,706480},{self,talk,[<<"我感觉自己要变身啦~">>]}]
        }
    };
get(ai_rule, 11387) ->
    {ok, 
        #npc_ai_rule{
            id = 11387
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{combat,round,<<">=">>,8,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706460}]
        }
    };
get(ai_rule, 11388) ->
    {ok, 
        #npc_ai_rule{
            id = 11388
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,9,1}]
            ,action = [{self,skill,706450},{self,talk,[<<"我好厉害哟~">>]}]
        }
    };
get(ai_rule, 11389) ->
    {ok, 
        #npc_ai_rule{
            id = 11389
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,11,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706430}]
        }
    };
get(ai_rule, 11390) ->
    {ok, 
        #npc_ai_rule{
            id = 11390
            ,type = 0
            ,repeat = 0
            ,prob = 95
            ,condition = [{combat,round,<<"=">>,12,1}]
            ,action = [{opp_side,skill,706420},{self,talk,[<<"你们的实力得到了我尊重，不過，你们还是差了點。">>]}]
        }
    };
get(ai_rule, 11391) ->
    {ok, 
        #npc_ai_rule{
            id = 11391
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,14,1}]
            ,action = [{opp_side,skill,706470}]
        }
    };
get(ai_rule, 11392) ->
    {ok, 
        #npc_ai_rule{
            id = 11392
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,15,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706460}]
        }
    };
get(ai_rule, 11393) ->
    {ok, 
        #npc_ai_rule{
            id = 11393
            ,type = 0
            ,repeat = 0
            ,prob = 70
            ,condition = [{combat,round,<<"=">>,16,1}]
            ,action = [{opp_side,skill,706470}]
        }
    };
get(ai_rule, 11394) ->
    {ok, 
        #npc_ai_rule{
            id = 11394
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,19,1},{opp_side,hp,<<">=">>,30,1}]
            ,action = [{opp_side,skill,706420},{self,talk,[<<"你还挺能撑的嘛~">>]}]
        }
    };
get(ai_rule, 11395) ->
    {ok, 
        #npc_ai_rule{
            id = 11395
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,706420}]
        }
    };
get(ai_rule, 11396) ->
    {ok, 
        #npc_ai_rule{
            id = 11396
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,29,1}]
            ,action = [{opp_side,skill,706420},{self,talk,[<<"这么久了，也该结束了吧！">>]}]
        }
    };
get(ai_rule, 11397) ->
    {ok, 
        #npc_ai_rule{
            id = 11397
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,201240,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706490}]
        }
    };
get(ai_rule, 11419) ->
    {ok, 
        #npc_ai_rule{
            id = 11419
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,70,1}]
            ,action = [{opp_side,skill,706580},{self,talk,[<<"就这么点本事吗？看來我还是高看你们了。">>]}]
        }
    };
get(ai_rule, 11420) ->
    {ok, 
        #npc_ai_rule{
            id = 11420
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706590},{self,talk,[<<"不错，你打疼我了，但这还远远不够！">>]}]
        }
    };
get(ai_rule, 11421) ->
    {ok, 
        #npc_ai_rule{
            id = 11421
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{opp_side,buff,<<"not_in">>,200080,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706600}]
        }
    };
get(ai_rule, 11422) ->
    {ok, 
        #npc_ai_rule{
            id = 11422
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,skill,706610}]
        }
    };
get(ai_rule, 11423) ->
    {ok, 
        #npc_ai_rule{
            id = 11423
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,10,1}]
            ,action = [{opp_side,skill,706580},{self,talk,[<<"不，我是不会输的！">>]}]
        }
    };
get(ai_rule, 11424) ->
    {ok, 
        #npc_ai_rule{
            id = 11424
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,706620},{self,talk,[<<"你想上我的幽灵船吗？">>]}]
        }
    };
get(ai_rule, 11425) ->
    {ok, 
        #npc_ai_rule{
            id = 11425
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,706580},{self,talk,[<<"我已经很久没有闻到活人的味道了。">>]}]
        }
    };
get(ai_rule, 11426) ->
    {ok, 
        #npc_ai_rule{
            id = 11426
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,706580},{self,talk,[<<"我看到你恐惧的眼神">>]}]
        }
    };
get(ai_rule, 11427) ->
    {ok, 
        #npc_ai_rule{
            id = 11427
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,4,1},{opp_side,buff,<<"not_in">>,200080,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706600},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 11428) ->
    {ok, 
        #npc_ai_rule{
            id = 11428
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{combat,round,<<"=">>,6,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706590},{self,talk,[<<"想抢我的聚魂棺吗？">>]}]
        }
    };
get(ai_rule, 11429) ->
    {ok, 
        #npc_ai_rule{
            id = 11429
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<"=">>,7,1},{opp_side,buff,<<"not_in">>,200080,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706600}]
        }
    };
get(ai_rule, 11430) ->
    {ok, 
        #npc_ai_rule{
            id = 11430
            ,type = 0
            ,repeat = 0
            ,prob = 90
            ,condition = [{combat,round,<<"=">>,8,1}]
            ,action = [{opp_side,skill,706580}]
        }
    };
get(ai_rule, 11431) ->
    {ok, 
        #npc_ai_rule{
            id = 11431
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,9,1},{opp_side,buff,<<"not_in">>,200080,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706600},{self,talk,[<<"听见了吧！我那打心底嘲笑你们的声音！">>]}]
        }
    };
get(ai_rule, 11432) ->
    {ok, 
        #npc_ai_rule{
            id = 11432
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,10,1}]
            ,action = [{opp_side,skill,706580},{self,talk,[<<"海是最强大的宠物！">>]}]
        }
    };
get(ai_rule, 11433) ->
    {ok, 
        #npc_ai_rule{
            id = 11433
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<"=">>,11,1}]
            ,action = [{opp_side,skill,706580}]
        }
    };
get(ai_rule, 11434) ->
    {ok, 
        #npc_ai_rule{
            id = 11434
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,12,1}]
            ,action = [{self,skill,706620},{self,talk,[<<"死在我手上，成为幽灵船的奴隶吧！">>]}]
        }
    };
get(ai_rule, 11435) ->
    {ok, 
        #npc_ai_rule{
            id = 11435
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,13,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706590},{self,talk,[<<"我就是海的霸主！">>]}]
        }
    };
get(ai_rule, 11436) ->
    {ok, 
        #npc_ai_rule{
            id = 11436
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<"=">>,14,1},{opp_side,buff,<<"not_in">>,200080,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706600}]
        }
    };
get(ai_rule, 11437) ->
    {ok, 
        #npc_ai_rule{
            id = 11437
            ,type = 0
            ,repeat = 0
            ,prob = 70
            ,condition = [{combat,round,<<"=">>,15,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706590},{self,talk,[<<"我可以让你死，也可以让你永生。">>]}]
        }
    };
get(ai_rule, 11438) ->
    {ok, 
        #npc_ai_rule{
            id = 11438
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,16,1},{opp_side,buff,<<"not_in">>,200080,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706600}]
        }
    };
get(ai_rule, 11439) ->
    {ok, 
        #npc_ai_rule{
            id = 11439
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,706630}]
        }
    };
get(ai_rule, 11440) ->
    {ok, 
        #npc_ai_rule{
            id = 11440
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod2">>,0,1}]
            ,action = [{opp_side,skill,706580}]
        }
    };
get(ai_rule, 11441) ->
    {ok, 
        #npc_ai_rule{
            id = 11441
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod3">>,0,1},{suit_tar,hp,<<"<=">>,30,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,706640}]
        }
    };
get(ai_rule, 11442) ->
    {ok, 
        #npc_ai_rule{
            id = 11442
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,30,1}]
            ,action = [{opp_side,skill,706580}]
        }
    };
get(ai_rule, 11623) ->
    {ok, 
        #npc_ai_rule{
            id = 11623
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,707610},{self,talk,[<<"小心别让我看到破绽！">>]}]
        }
    };
get(ai_rule, 11624) ->
    {ok, 
        #npc_ai_rule{
            id = 11624
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,11,1}]
            ,action = [{self,skill,707610}]
        }
    };
get(ai_rule, 11625) ->
    {ok, 
        #npc_ai_rule{
            id = 11625
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,21,1}]
            ,action = [{self,skill,707610}]
        }
    };
get(ai_rule, 11626) ->
    {ok, 
        #npc_ai_rule{
            id = 11626
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,31,1}]
            ,action = [{self,skill,707610}]
        }
    };
get(ai_rule, 11627) ->
    {ok, 
        #npc_ai_rule{
            id = 11627
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod7">>,0,1}]
            ,action = [{opp_side,skill,707620},{self,talk,[<<"我会让你们尝到苦头的！">>]}]
        }
    };
get(ai_rule, 11628) ->
    {ok, 
        #npc_ai_rule{
            id = 11628
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod9">>,0,1},{opp_side,career,<<"=">>,3,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,707630},{self,talk,[<<"乖乖受死吧！">>]}]
        }
    };
get(ai_rule, 11629) ->
    {ok, 
        #npc_ai_rule{
            id = 11629
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod9">>,0,1}]
            ,action = [{opp_side,skill,707640},{self,talk,[<<"乖乖受死吧！">>]}]
        }
    };
get(ai_rule, 11630) ->
    {ok, 
        #npc_ai_rule{
            id = 11630
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"<=">>,20,1}]
            ,action = [{opp_side,skill,707650},{self,talk,[<<"暗影箭！">>]}]
        }
    };
get(ai_rule, 11631) ->
    {ok, 
        #npc_ai_rule{
            id = 11631
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<"<=">>,20,1},{opp_side,buff,<<"not_in">>,200060,1}]
            ,action = [{suit_tar,skill,707660}]
        }
    };
get(ai_rule, 11632) ->
    {ok, 
        #npc_ai_rule{
            id = 11632
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,20,1}]
            ,action = [{opp_side,skill,707670}]
        }
    };
get(ai_rule, 11633) ->
    {ok, 
        #npc_ai_rule{
            id = 11633
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<">">>,20,1},{opp_side,buff,<<"not_in">>,200060,1}]
            ,action = [{suit_tar,skill,707680},{self,talk,[<<"这一箭就是终结！">>]}]
        }
    };
get(ai_rule, 11634) ->
    {ok, 
        #npc_ai_rule{
            id = 11634
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,20,1}]
            ,action = [{opp_side,skill,707690}]
        }
    };
get(ai_rule, 11650) ->
    {ok, 
        #npc_ai_rule{
            id = 11650
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod9">>,1,1}]
            ,action = [{self,skill,707840}]
        }
    };
get(ai_rule, 11651) ->
    {ok, 
        #npc_ai_rule{
            id = 11651
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,2,1}]
            ,action = [{opp_side,skill,707850},{self,talk,[<<"凡人，你居然敢正视我的眼睛！">>]}]
        }
    };
get(ai_rule, 11652) ->
    {ok, 
        #npc_ai_rule{
            id = 11652
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,3,1}]
            ,action = [{self_side,skill,707860},{self,talk,[<<"你再敢在我面前逗留，就让你死！">>]}]
        }
    };
get(ai_rule, 11653) ->
    {ok, 
        #npc_ai_rule{
            id = 11653
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,4,1}]
            ,action = [{opp_side,skill,707870},{self,talk,[<<"我的容颜可不是你能瞻仰的！">>]}]
        }
    };
get(ai_rule, 11654) ->
    {ok, 
        #npc_ai_rule{
            id = 11654
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod7">>,0,1}]
            ,action = [{opp_side,skill,707880}]
        }
    };
get(ai_rule, 11655) ->
    {ok, 
        #npc_ai_rule{
            id = 11655
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod6">>,0,1}]
            ,action = [{self_side,skill,707890},{self,talk,[<<"向我下跪，姑且可以免你一死。">>]}]
        }
    };
get(ai_rule, 11656) ->
    {ok, 
        #npc_ai_rule{
            id = 11656
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"<">>,30,1}]
            ,action = [{opp_side,skill,707900}]
        }
    };
get(ai_rule, 11657) ->
    {ok, 
        #npc_ai_rule{
            id = 11657
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"<">>,30,1}]
            ,action = [{opp_side,skill,707920}]
        }
    };
get(ai_rule, 11658) ->
    {ok, 
        #npc_ai_rule{
            id = 11658
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,30,1}]
            ,action = [{opp_side,skill,707910},{self,talk,[<<"我将用神力把你打得粉碎！">>]}]
        }
    };
get(ai_rule, 11659) ->
    {ok, 
        #npc_ai_rule{
            id = 11659
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,30,1}]
            ,action = [{opp_side,skill,707910}]
        }
    };
get(ai_rule, 11660) ->
    {ok, 
        #npc_ai_rule{
            id = 11660
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,707960},{self,talk,[<<"认清你们的处境，凡人！">>]}]
        }
    };
get(ai_rule, 11661) ->
    {ok, 
        #npc_ai_rule{
            id = 11661
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,707970}]
        }
    };
get(ai_rule, 11662) ->
    {ok, 
        #npc_ai_rule{
            id = 11662
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod9">>,1,1}]
            ,action = [{self,skill,707960},{self,talk,[<<"黑暗是最令人厌恶的东西！">>]}]
        }
    };
get(ai_rule, 11663) ->
    {ok, 
        #npc_ai_rule{
            id = 11663
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,2,1}]
            ,action = [{opp_side,skill,707970}]
        }
    };
get(ai_rule, 11664) ->
    {ok, 
        #npc_ai_rule{
            id = 11664
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{self,skill,707980},{self,talk,[<<"出来吧！">>]}]
        }
    };
get(ai_rule, 11665) ->
    {ok, 
        #npc_ai_rule{
            id = 11665
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,3,1},{self_side,id,<<"=">>,16119,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self,skill,707980},{self,talk,[<<"出来吧！">>]}]
        }
    };
get(ai_rule, 11666) ->
    {ok, 
        #npc_ai_rule{
            id = 11666
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,4,1}]
            ,action = [{opp_side,skill,707990}]
        }
    };
get(ai_rule, 11667) ->
    {ok, 
        #npc_ai_rule{
            id = 11667
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,5,1}]
            ,action = [{opp_side,skill,708000}]
        }
    };
get(ai_rule, 11668) ->
    {ok, 
        #npc_ai_rule{
            id = 11668
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,20,1},{combat,round,<<"mod2">>,0,1},{opp_side,hp,<<"<">>,40,1}]
            ,action = [{suit_tar,skill,708010}]
        }
    };
get(ai_rule, 11669) ->
    {ok, 
        #npc_ai_rule{
            id = 11669
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"<=">>,20,1}]
            ,action = [{opp_side,skill,708020},{self,talk,[<<"在光面前，一切都是渺小！">>]}]
        }
    };
get(ai_rule, 11670) ->
    {ok, 
        #npc_ai_rule{
            id = 11670
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,20,1}]
            ,action = [{opp_side,skill,708030}]
        }
    };
get(ai_rule, 11671) ->
    {ok, 
        #npc_ai_rule{
            id = 11671
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,20,1},{combat,round,<<"mod2">>,0,1},{opp_side,hp,<<"<">>,40,1}]
            ,action = [{suit_tar,skill,708040}]
        }
    };
get(ai_rule, 11672) ->
    {ok, 
        #npc_ai_rule{
            id = 11672
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">">>,20,1}]
            ,action = [{opp_side,skill,708050},{self,talk,[<<"让我用光为你洗礼。">>]}]
        }
    };
get(ai_rule, 11673) ->
    {ok, 
        #npc_ai_rule{
            id = 11673
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,20,1}]
            ,action = [{opp_side,skill,708060}]
        }
    };
get(ai_rule, 11674) ->
    {ok, 
        #npc_ai_rule{
            id = 11674
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{combat,round,<<"mod2">>,0,1},{opp_side,hp,<<"<">>,40,1}]
            ,action = [{suit_tar,skill,708070}]
        }
    };
get(ai_rule, 11675) ->
    {ok, 
        #npc_ai_rule{
            id = 11675
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,708080}]
        }
    };
get(ai_rule, 11676) ->
    {ok, 
        #npc_ai_rule{
            id = 11676
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,708090}]
        }
    };
get(ai_rule, 11677) ->
    {ok, 
        #npc_ai_rule{
            id = 11677
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{top_lev,skill,708140},{self,talk,[<<"你应该受到神的指引！">>]}]
        }
    };
get(ai_rule, 11678) ->
    {ok, 
        #npc_ai_rule{
            id = 11678
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,2,1}]
            ,action = [{opp_side,skill,708110},{self,talk,[<<"与神作对只有死路一条。">>]}]
        }
    };
get(ai_rule, 11679) ->
    {ok, 
        #npc_ai_rule{
            id = 11679
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,3,1}]
            ,action = [{opp_side,skill,708120}]
        }
    };
get(ai_rule, 11680) ->
    {ok, 
        #npc_ai_rule{
            id = 11680
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,4,1}]
            ,action = [{opp_side,skill,708130}]
        }
    };
get(ai_rule, 11681) ->
    {ok, 
        #npc_ai_rule{
            id = 11681
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,5,1},{opp_side,buff,<<"include">>,104140,1}]
            ,action = [{suit_tar,skill,708140},{self,talk,[<<"这是什么？">>]}]
        }
    };
get(ai_rule, 11682) ->
    {ok, 
        #npc_ai_rule{
            id = 11682
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod8">>,5,1}]
            ,action = [{low_lev,skill,708140},{self,talk,[<<"你是怎么到这里来的？">>]}]
        }
    };
get(ai_rule, 11683) ->
    {ok, 
        #npc_ai_rule{
            id = 11683
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"<">>,30,1},{self,hp,<<"<">>,50,1},{opp_side,buff,<<"include">>,200040,1}]
            ,action = [{suit_tar,skill,708150}]
        }
    };
get(ai_rule, 11684) ->
    {ok, 
        #npc_ai_rule{
            id = 11684
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<"<">>,30,1}]
            ,action = [{opp_side,skill,708160},{self,talk,[<<"所有的虚妄都是无用的！">>]}]
        }
    };
get(ai_rule, 11685) ->
    {ok, 
        #npc_ai_rule{
            id = 11685
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"<">>,30,1}]
            ,action = [{opp_side,skill,708170}]
        }
    };
get(ai_rule, 11686) ->
    {ok, 
        #npc_ai_rule{
            id = 11686
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,30,1},{self,hp,<<"<">>,50,1},{opp_side,buff,<<"include">>,200040,1}]
            ,action = [{suit_tar,skill,708180}]
        }
    };
get(ai_rule, 11687) ->
    {ok, 
        #npc_ai_rule{
            id = 11687
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<">=">>,30,1}]
            ,action = [{opp_side,skill,708190}]
        }
    };
get(ai_rule, 11688) ->
    {ok, 
        #npc_ai_rule{
            id = 11688
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,30,1}]
            ,action = [{opp_side,skill,708200}]
        }
    };
get(ai_rule, 11700) ->
    {ok, 
        #npc_ai_rule{
            id = 11700
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,708120},{self,talk,[<<"烧掉一切！毁掉一切！">>]}]
        }
    };
get(ai_rule, 11701) ->
    {ok, 
        #npc_ai_rule{
            id = 11701
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,600003},{self,talk,[<<"消灭你们，妈妈就会表扬我了">>]}]
        }
    };
get(ai_rule, 11702) ->
    {ok, 
        #npc_ai_rule{
            id = 11702
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1}]
            ,action = [{opp_side,skill,600004},{self,talk,[<<"活着的人！">>]}]
        }
    };
get(ai_rule, 11703) ->
    {ok, 
        #npc_ai_rule{
            id = 11703
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600421},{self,talk,[<<"不！！你不可能杀得了我，我们是最强的！">>]}]
        }
    };
get(ai_rule, 11704) ->
    {ok, 
        #npc_ai_rule{
            id = 11704
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600008},{self,talk,[<<"我以为你不敢来了呢，蠢货">>]}]
        }
    };
get(ai_rule, 11705) ->
    {ok, 
        #npc_ai_rule{
            id = 11705
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,2,1}]
            ,action = [{opp_side,skill,600008},{self,talk,[<<"乌璐就是被你干掉了？真不敢相信">>]}]
        }
    };
get(ai_rule, 11706) ->
    {ok, 
        #npc_ai_rule{
            id = 11706
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,4,1}]
            ,action = [{opp_side,skill,601032},{self,talk,[<<"与邪恶女巫作对，是你犯下的最大错误">>]}]
        }
    };
get(ai_rule, 11707) ->
    {ok, 
        #npc_ai_rule{
            id = 11707
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{self,skill,600420},{self,talk,[<<"出来吧我的孩子">>]}]
        }
    };
get(ai_rule, 11708) ->
    {ok, 
        #npc_ai_rule{
            id = 11708
            ,type = 0
            ,repeat = 0
            ,prob = 12
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600008},{self,talk,[<<"消灭一切活人">>]}]
        }
    };
get(ai_rule, 11709) ->
    {ok, 
        #npc_ai_rule{
            id = 11709
            ,type = 0
            ,repeat = 0
            ,prob = 13
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601032},{self,talk,[<<"我要粉碎你">>]}]
        }
    };
get(ai_rule, 11710) ->
    {ok, 
        #npc_ai_rule{
            id = 11710
            ,type = 0
            ,repeat = 0
            ,prob = 15
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601031},{self,talk,[<<"我们听从邪恶女巫大人的命令">>]}]
        }
    };
get(ai_rule, 11711) ->
    {ok, 
        #npc_ai_rule{
            id = 11711
            ,type = 0
            ,repeat = 0
            ,prob = 16
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600008},{self,talk,[<<"我是谁……">>]}]
        }
    };
get(ai_rule, 11712) ->
    {ok, 
        #npc_ai_rule{
            id = 11712
            ,type = 0
            ,repeat = 0
            ,prob = 17
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600008},{self,talk,[<<"我……好痛苦……">>]}]
        }
    };
get(ai_rule, 11713) ->
    {ok, 
        #npc_ai_rule{
            id = 11713
            ,type = 0
            ,repeat = 0
            ,prob = 12
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600008},{self,talk,[<<"我找到他们了，妈妈">>]}]
        }
    };
get(ai_rule, 11714) ->
    {ok, 
        #npc_ai_rule{
            id = 11714
            ,type = 0
            ,repeat = 0
            ,prob = 13
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601032},{self,talk,[<<"妈妈，我这就为您消灭他们">>]}]
        }
    };
get(ai_rule, 11715) ->
    {ok, 
        #npc_ai_rule{
            id = 11715
            ,type = 0
            ,repeat = 0
            ,prob = 15
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601031},{self,talk,[<<"又发现新目标了">>]}]
        }
    };
get(ai_rule, 11716) ->
    {ok, 
        #npc_ai_rule{
            id = 11716
            ,type = 0
            ,repeat = 0
            ,prob = 16
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600008},{self,talk,[<<"怨恨能给你无穷无尽的力量">>]}]
        }
    };
get(ai_rule, 11717) ->
    {ok, 
        #npc_ai_rule{
            id = 11717
            ,type = 0
            ,repeat = 0
            ,prob = 17
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600008},{self,talk,[<<"为什么妈妈这么在意你">>]}]
        }
    };
get(ai_rule, 11718) ->
    {ok, 
        #npc_ai_rule{
            id = 11718
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,600420},{self,talk,[<<"快保护我，你们两个白痴！">>]}]
        }
    };
get(ai_rule, 11719) ->
    {ok, 
        #npc_ai_rule{
            id = 11719
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600008},{self,talk,[<<"你果然来了">>]}]
        }
    };
get(ai_rule, 11720) ->
    {ok, 
        #npc_ai_rule{
            id = 11720
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,2,1}]
            ,action = [{opp_side,skill,601032},{self,talk,[<<"那就和你的朋友一起死在这里吧">>]}]
        }
    };
get(ai_rule, 11721) ->
    {ok, 
        #npc_ai_rule{
            id = 11721
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{opp_side,skill,601031},{self,talk,[<<"法琳娜，看来这次是我赢了">>]}]
        }
    };
get(ai_rule, 11722) ->
    {ok, 
        #npc_ai_rule{
            id = 11722
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,4,1}]
            ,action = [{opp_side,skill,601033},{self,talk,[<<"邪恶女巫会永远诅咒你的">>]}]
        }
    };
get(ai_rule, 11723) ->
    {ok, 
        #npc_ai_rule{
            id = 11723
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,600008}]
        }
    };
get(ai_rule, 120000) ->
    {ok, 
        #npc_ai_rule{
            id = 120000
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8051,1}]
            ,action = [{opp_side,base_skill,8051}]
        }
    };
get(ai_rule, 120001) ->
    {ok, 
        #npc_ai_rule{
            id = 120001
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8091,1}]
            ,action = [{opp_side,base_skill,8091}]
        }
    };
get(ai_rule, 120002) ->
    {ok, 
        #npc_ai_rule{
            id = 120002
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8021,1}]
            ,action = [{opp_side,base_skill,8021}]
        }
    };
get(ai_rule, 120003) ->
    {ok, 
        #npc_ai_rule{
            id = 120003
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8091,1}]
            ,action = [{opp_side,base_skill,8091}]
        }
    };
get(ai_rule, 120004) ->
    {ok, 
        #npc_ai_rule{
            id = 120004
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1},{self,base_skill,<<"include">>,8231,1}]
            ,action = [{self_side,base_skill,8231}]
        }
    };
get(ai_rule, 120005) ->
    {ok, 
        #npc_ai_rule{
            id = 120005
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8041,1}]
            ,action = [{self_side,base_skill,8041}]
        }
    };
get(ai_rule, 120006) ->
    {ok, 
        #npc_ai_rule{
            id = 120006
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8141,1}]
            ,action = [{self_side,base_skill,8141}]
        }
    };
get(ai_rule, 120007) ->
    {ok, 
        #npc_ai_rule{
            id = 120007
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8011,1}]
            ,action = [{opp_side,base_skill,8011}]
        }
    };
get(ai_rule, 120008) ->
    {ok, 
        #npc_ai_rule{
            id = 120008
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8131,1}]
            ,action = [{self_side,base_skill,8131}]
        }
    };
get(ai_rule, 120009) ->
    {ok, 
        #npc_ai_rule{
            id = 120009
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8071,1}]
            ,action = [{opp_side,base_skill,8071}]
        }
    };
get(ai_rule, 120010) ->
    {ok, 
        #npc_ai_rule{
            id = 120010
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8071,1}]
            ,action = [{opp_side,base_skill,8071}]
        }
    };
get(ai_rule, 120011) ->
    {ok, 
        #npc_ai_rule{
            id = 120011
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8072,1}]
            ,action = [{opp_side,base_skill,8072}]
        }
    };
get(ai_rule, 120012) ->
    {ok, 
        #npc_ai_rule{
            id = 120012
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8052,1}]
            ,action = [{opp_side,base_skill,8052}]
        }
    };
get(ai_rule, 120013) ->
    {ok, 
        #npc_ai_rule{
            id = 120013
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8102,1}]
            ,action = [{opp_side,base_skill,8102}]
        }
    };
get(ai_rule, 120014) ->
    {ok, 
        #npc_ai_rule{
            id = 120014
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8082,1}]
            ,action = [{opp_side,base_skill,8082}]
        }
    };
get(ai_rule, 120015) ->
    {ok, 
        #npc_ai_rule{
            id = 120015
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8032,1}]
            ,action = [{opp_side,base_skill,8032}]
        }
    };
get(ai_rule, 120016) ->
    {ok, 
        #npc_ai_rule{
            id = 120016
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8111,1}]
            ,action = [{opp_side,base_skill,8111}]
        }
    };
get(ai_rule, 120017) ->
    {ok, 
        #npc_ai_rule{
            id = 120017
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8221,1}]
            ,action = [{opp_side,base_skill,8221}]
        }
    };
get(ai_rule, 120018) ->
    {ok, 
        #npc_ai_rule{
            id = 120018
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8112,1}]
            ,action = [{opp_side,base_skill,8112}]
        }
    };
get(ai_rule, 120019) ->
    {ok, 
        #npc_ai_rule{
            id = 120019
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1},{self,base_skill,<<"include">>,8232,1}]
            ,action = [{self_side,base_skill,8232}]
        }
    };
get(ai_rule, 120020) ->
    {ok, 
        #npc_ai_rule{
            id = 120020
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8131,1}]
            ,action = [{self_side,base_skill,8131}]
        }
    };
get(ai_rule, 120021) ->
    {ok, 
        #npc_ai_rule{
            id = 120021
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8222,1}]
            ,action = [{opp_side,base_skill,8222}]
        }
    };
get(ai_rule, 120022) ->
    {ok, 
        #npc_ai_rule{
            id = 120022
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8142,1}]
            ,action = [{self_side,base_skill,8142}]
        }
    };
get(ai_rule, 120023) ->
    {ok, 
        #npc_ai_rule{
            id = 120023
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8022,1}]
            ,action = [{opp_side,base_skill,8022}]
        }
    };
get(ai_rule, 120024) ->
    {ok, 
        #npc_ai_rule{
            id = 120024
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8072,1}]
            ,action = [{opp_side,base_skill,8072}]
        }
    };
get(ai_rule, 120025) ->
    {ok, 
        #npc_ai_rule{
            id = 120025
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8101,1}]
            ,action = [{opp_side,base_skill,8101}]
        }
    };
get(ai_rule, 120026) ->
    {ok, 
        #npc_ai_rule{
            id = 120026
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8052,1}]
            ,action = [{opp_side,base_skill,8052}]
        }
    };
get(ai_rule, 120027) ->
    {ok, 
        #npc_ai_rule{
            id = 120027
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8032,1}]
            ,action = [{opp_side,base_skill,8032}]
        }
    };
get(ai_rule, 120028) ->
    {ok, 
        #npc_ai_rule{
            id = 120028
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1},{self,base_skill,<<"include">>,8241,1}]
            ,action = [{self_side,base_skill,8241}]
        }
    };
get(ai_rule, 120029) ->
    {ok, 
        #npc_ai_rule{
            id = 120029
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8031,1}]
            ,action = [{self_side,base_skill,8031}]
        }
    };
get(ai_rule, 120030) ->
    {ok, 
        #npc_ai_rule{
            id = 120030
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8072,1}]
            ,action = [{opp_side,base_skill,8072}]
        }
    };
get(ai_rule, 120031) ->
    {ok, 
        #npc_ai_rule{
            id = 120031
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8222,1}]
            ,action = [{opp_side,base_skill,8222}]
        }
    };
get(ai_rule, 120032) ->
    {ok, 
        #npc_ai_rule{
            id = 120032
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8063,1}]
            ,action = [{opp_side,base_skill,8063}]
        }
    };
get(ai_rule, 120033) ->
    {ok, 
        #npc_ai_rule{
            id = 120033
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8252,1}]
            ,action = [{self_side,base_skill,8252}]
        }
    };
get(ai_rule, 120034) ->
    {ok, 
        #npc_ai_rule{
            id = 120034
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8142,1}]
            ,action = [{self_side,base_skill,8142}]
        }
    };
get(ai_rule, 120035) ->
    {ok, 
        #npc_ai_rule{
            id = 120035
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8112,1}]
            ,action = [{opp_side,base_skill,8112}]
        }
    };
get(ai_rule, 120036) ->
    {ok, 
        #npc_ai_rule{
            id = 120036
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8132,1}]
            ,action = [{self_side,base_skill,8132}]
        }
    };
get(ai_rule, 120037) ->
    {ok, 
        #npc_ai_rule{
            id = 120037
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8113,1}]
            ,action = [{opp_side,base_skill,8113}]
        }
    };
get(ai_rule, 120038) ->
    {ok, 
        #npc_ai_rule{
            id = 120038
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8023,1}]
            ,action = [{opp_side,base_skill,8023}]
        }
    };
get(ai_rule, 120039) ->
    {ok, 
        #npc_ai_rule{
            id = 120039
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8063,1}]
            ,action = [{opp_side,base_skill,8063}]
        }
    };
get(ai_rule, 120040) ->
    {ok, 
        #npc_ai_rule{
            id = 120040
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8043,1}]
            ,action = [{self_side,base_skill,8043}]
        }
    };
get(ai_rule, 120041) ->
    {ok, 
        #npc_ai_rule{
            id = 120041
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8133,1}]
            ,action = [{self_side,base_skill,8133}]
        }
    };
get(ai_rule, 120042) ->
    {ok, 
        #npc_ai_rule{
            id = 120042
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1},{self,base_skill,<<"include">>,8242,1}]
            ,action = [{self_side,base_skill,8242}]
        }
    };
get(ai_rule, 120043) ->
    {ok, 
        #npc_ai_rule{
            id = 120043
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8232,1}]
            ,action = [{self_side,base_skill,8232}]
        }
    };
get(ai_rule, 120044) ->
    {ok, 
        #npc_ai_rule{
            id = 120044
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8252,1}]
            ,action = [{self_side,base_skill,8252}]
        }
    };
get(ai_rule, 120045) ->
    {ok, 
        #npc_ai_rule{
            id = 120045
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8132,1}]
            ,action = [{self_side,base_skill,8132}]
        }
    };
get(ai_rule, 120046) ->
    {ok, 
        #npc_ai_rule{
            id = 120046
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8103,1}]
            ,action = [{opp_side,base_skill,8103}]
        }
    };
get(ai_rule, 120047) ->
    {ok, 
        #npc_ai_rule{
            id = 120047
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8103,1}]
            ,action = [{opp_side,base_skill,8103}]
        }
    };
get(ai_rule, 120048) ->
    {ok, 
        #npc_ai_rule{
            id = 120048
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1},{self,base_skill,<<"include">>,8242,1}]
            ,action = [{self_side,base_skill,8242}]
        }
    };
get(ai_rule, 120049) ->
    {ok, 
        #npc_ai_rule{
            id = 120049
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8132,1}]
            ,action = [{self_side,base_skill,8132}]
        }
    };
get(ai_rule, 120050) ->
    {ok, 
        #npc_ai_rule{
            id = 120050
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8112,1}]
            ,action = [{opp_side,base_skill,8112}]
        }
    };
get(ai_rule, 120051) ->
    {ok, 
        #npc_ai_rule{
            id = 120051
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8132,1}]
            ,action = [{self_side,base_skill,8132}]
        }
    };
get(ai_rule, 120052) ->
    {ok, 
        #npc_ai_rule{
            id = 120052
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8062,1}]
            ,action = [{opp_side,base_skill,8062}]
        }
    };
get(ai_rule, 120053) ->
    {ok, 
        #npc_ai_rule{
            id = 120053
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8133,1}]
            ,action = [{self_side,base_skill,8133}]
        }
    };
get(ai_rule, 120054) ->
    {ok, 
        #npc_ai_rule{
            id = 120054
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8073,1}]
            ,action = [{opp_side,base_skill,8073}]
        }
    };
get(ai_rule, 120055) ->
    {ok, 
        #npc_ai_rule{
            id = 120055
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8031,1}]
            ,action = [{opp_side,base_skill,8031}]
        }
    };
get(ai_rule, 120056) ->
    {ok, 
        #npc_ai_rule{
            id = 120056
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8081,1}]
            ,action = [{opp_side,base_skill,8081}]
        }
    };
get(ai_rule, 120057) ->
    {ok, 
        #npc_ai_rule{
            id = 120057
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8013,1}]
            ,action = [{opp_side,base_skill,8013}]
        }
    };
get(ai_rule, 120058) ->
    {ok, 
        #npc_ai_rule{
            id = 120058
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1},{self,base_skill,<<"include">>,8243,1}]
            ,action = [{self_side,base_skill,8243}]
        }
    };
get(ai_rule, 120059) ->
    {ok, 
        #npc_ai_rule{
            id = 120059
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8023,1}]
            ,action = [{opp_side,base_skill,8023}]
        }
    };
get(ai_rule, 120060) ->
    {ok, 
        #npc_ai_rule{
            id = 120060
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8063,1}]
            ,action = [{opp_side,base_skill,8063}]
        }
    };
get(ai_rule, 120061) ->
    {ok, 
        #npc_ai_rule{
            id = 120061
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8053,1}]
            ,action = [{opp_side,base_skill,8053}]
        }
    };
get(ai_rule, 120062) ->
    {ok, 
        #npc_ai_rule{
            id = 120062
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8112,1}]
            ,action = [{opp_side,base_skill,8112}]
        }
    };
get(ai_rule, 120063) ->
    {ok, 
        #npc_ai_rule{
            id = 120063
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8142,1}]
            ,action = [{self_side,base_skill,8142}]
        }
    };
get(ai_rule, 120064) ->
    {ok, 
        #npc_ai_rule{
            id = 120064
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8032,1}]
            ,action = [{opp_side,base_skill,8032}]
        }
    };
get(ai_rule, 120065) ->
    {ok, 
        #npc_ai_rule{
            id = 120065
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8121,1}]
            ,action = [{opp_side,base_skill,8121}]
        }
    };
get(ai_rule, 120066) ->
    {ok, 
        #npc_ai_rule{
            id = 120066
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8142,1}]
            ,action = [{self_side,base_skill,8142}]
        }
    };
get(ai_rule, 120067) ->
    {ok, 
        #npc_ai_rule{
            id = 120067
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8072,1}]
            ,action = [{opp_side,base_skill,8072}]
        }
    };
get(ai_rule, 120068) ->
    {ok, 
        #npc_ai_rule{
            id = 120068
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8221,1}]
            ,action = [{opp_side,base_skill,8221}]
        }
    };
get(ai_rule, 120069) ->
    {ok, 
        #npc_ai_rule{
            id = 120069
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8071,1}]
            ,action = [{opp_side,base_skill,8071}]
        }
    };
get(ai_rule, 120071) ->
    {ok, 
        #npc_ai_rule{
            id = 120071
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,800047}]
        }
    };
get(ai_rule, 120072) ->
    {ok, 
        #npc_ai_rule{
            id = 120072
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,800048}]
        }
    };
get(ai_rule, 120073) ->
    {ok, 
        #npc_ai_rule{
            id = 120073
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8223,1}]
            ,action = [{opp_side,base_skill,8223}]
        }
    };
get(ai_rule, 120074) ->
    {ok, 
        #npc_ai_rule{
            id = 120074
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8253,1}]
            ,action = [{self_side,base_skill,8253}]
        }
    };
get(ai_rule, 120075) ->
    {ok, 
        #npc_ai_rule{
            id = 120075
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8143,1}]
            ,action = [{self_side,base_skill,8143}]
        }
    };
get(ai_rule, 120076) ->
    {ok, 
        #npc_ai_rule{
            id = 120076
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8123,1}]
            ,action = [{opp_side,base_skill,8123}]
        }
    };
get(ai_rule, 120077) ->
    {ok, 
        #npc_ai_rule{
            id = 120077
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,base_skill,<<"include">>,8033,1}]
            ,action = [{opp_side,base_skill,8033}]
        }
    };
get(ai_rule, 120078) ->
    {ok, 
        #npc_ai_rule{
            id = 120078
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1},{self,base_skill,<<"include">>,8233,1}]
            ,action = [{self_side,base_skill,8233}]
        }
    };
get(ai_rule, 120079) ->
    {ok, 
        #npc_ai_rule{
            id = 120079
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,2,1},{self,base_skill,<<"include">>,8152,1},{self_side,buff_eff_type,<<"include">>,debuff,1}]
            ,action = [{suit_tar,base_skill,8152}]
        }
    };
get(ai_rule, 120080) ->
    {ok, 
        #npc_ai_rule{
            id = 120080
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,800049}]
        }
    };
get(ai_rule, 120081) ->
    {ok, 
        #npc_ai_rule{
            id = 120081
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,800050}]
        }
    };
get(ai_rule, 120082) ->
    {ok, 
        #npc_ai_rule{
            id = 120082
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,800051}]
        }
    };
get(ai_rule, 120083) ->
    {ok, 
        #npc_ai_rule{
            id = 120083
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,800052}]
        }
    };
get(ai_rule, 102000) ->
    {ok, 
        #npc_ai_rule{
            id = 102000
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,600351}]
        }
    };
get(ai_rule, 102001) ->
    {ok, 
        #npc_ai_rule{
            id = 102001
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601010}]
        }
    };
get(ai_rule, 102002) ->
    {ok, 
        #npc_ai_rule{
            id = 102002
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600357}]
        }
    };
get(ai_rule, 102003) ->
    {ok, 
        #npc_ai_rule{
            id = 102003
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,600361}]
        }
    };
get(ai_rule, 102004) ->
    {ok, 
        #npc_ai_rule{
            id = 102004
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601010}]
        }
    };
get(ai_rule, 102005) ->
    {ok, 
        #npc_ai_rule{
            id = 102005
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600353}]
        }
    };
get(ai_rule, 102006) ->
    {ok, 
        #npc_ai_rule{
            id = 102006
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600358}]
        }
    };
get(ai_rule, 102007) ->
    {ok, 
        #npc_ai_rule{
            id = 102007
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600354}]
        }
    };
get(ai_rule, 102008) ->
    {ok, 
        #npc_ai_rule{
            id = 102008
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{self,skill,600361}]
        }
    };
get(ai_rule, 102009) ->
    {ok, 
        #npc_ai_rule{
            id = 102009
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601015}]
        }
    };
get(ai_rule, 102010) ->
    {ok, 
        #npc_ai_rule{
            id = 102010
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600356}]
        }
    };
get(ai_rule, 102011) ->
    {ok, 
        #npc_ai_rule{
            id = 102011
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600362}]
        }
    };
get(ai_rule, 102012) ->
    {ok, 
        #npc_ai_rule{
            id = 102012
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600354}]
        }
    };
get(ai_rule, 102013) ->
    {ok, 
        #npc_ai_rule{
            id = 102013
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601006}]
        }
    };
get(ai_rule, 102014) ->
    {ok, 
        #npc_ai_rule{
            id = 102014
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601006}]
        }
    };
get(ai_rule, 102015) ->
    {ok, 
        #npc_ai_rule{
            id = 102015
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,600352}]
        }
    };
get(ai_rule, 102016) ->
    {ok, 
        #npc_ai_rule{
            id = 102016
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600358}]
        }
    };
get(ai_rule, 102017) ->
    {ok, 
        #npc_ai_rule{
            id = 102017
            ,type = 0
            ,repeat = 1
            ,prob = 33
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601023}]
        }
    };
get(ai_rule, 102018) ->
    {ok, 
        #npc_ai_rule{
            id = 102018
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,600355}]
        }
    };
get(ai_rule, 102019) ->
    {ok, 
        #npc_ai_rule{
            id = 102019
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601023}]
        }
    };
get(ai_rule, 102020) ->
    {ok, 
        #npc_ai_rule{
            id = 102020
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601014}]
        }
    };
get(ai_rule, 102021) ->
    {ok, 
        #npc_ai_rule{
            id = 102021
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1}]
            ,action = [{self,skill,600352}]
        }
    };
get(ai_rule, 102022) ->
    {ok, 
        #npc_ai_rule{
            id = 102022
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600356}]
        }
    };
get(ai_rule, 102023) ->
    {ok, 
        #npc_ai_rule{
            id = 102023
            ,type = 0
            ,repeat = 1
            ,prob = 90
            ,condition = [{self,hp,<<"<=">>,40,1}]
            ,action = [{opp_side,skill,601014}]
        }
    };
get(ai_rule, 102024) ->
    {ok, 
        #npc_ai_rule{
            id = 102024
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601014}]
        }
    };
get(ai_rule, 102025) ->
    {ok, 
        #npc_ai_rule{
            id = 102025
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<"mod2">>,2,1}]
            ,action = [{opp_side,skill,601025}]
        }
    };
get(ai_rule, 102026) ->
    {ok, 
        #npc_ai_rule{
            id = 102026
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600357}]
        }
    };
get(ai_rule, 102027) ->
    {ok, 
        #npc_ai_rule{
            id = 102027
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,600354}]
        }
    };
get(ai_rule, 102028) ->
    {ok, 
        #npc_ai_rule{
            id = 102028
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,600361}]
        }
    };
get(ai_rule, 102029) ->
    {ok, 
        #npc_ai_rule{
            id = 102029
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601025}]
        }
    };
get(ai_rule, 102030) ->
    {ok, 
        #npc_ai_rule{
            id = 102030
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600362}]
        }
    };
get(ai_rule, 102031) ->
    {ok, 
        #npc_ai_rule{
            id = 102031
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self,hp,<<"<">>,50,1}]
            ,action = [{self,skill,600352}]
        }
    };
get(ai_rule, 102032) ->
    {ok, 
        #npc_ai_rule{
            id = 102032
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601024}]
        }
    };
get(ai_rule, 102033) ->
    {ok, 
        #npc_ai_rule{
            id = 102033
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600356}]
        }
    };
get(ai_rule, 102034) ->
    {ok, 
        #npc_ai_rule{
            id = 102034
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601024}]
        }
    };
get(ai_rule, 102035) ->
    {ok, 
        #npc_ai_rule{
            id = 102035
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600354}]
        }
    };
get(ai_rule, 102036) ->
    {ok, 
        #npc_ai_rule{
            id = 102036
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,4,1}]
            ,action = [{opp_side,skill,600363}]
        }
    };
get(ai_rule, 102037) ->
    {ok, 
        #npc_ai_rule{
            id = 102037
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{self,skill,600361}]
        }
    };
get(ai_rule, 102038) ->
    {ok, 
        #npc_ai_rule{
            id = 102038
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,601017}]
        }
    };
get(ai_rule, 102039) ->
    {ok, 
        #npc_ai_rule{
            id = 102039
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600353}]
        }
    };
get(ai_rule, 103000) ->
    {ok, 
        #npc_ai_rule{
            id = 103000
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,0,1},{self_side,buff,<<"not_in">>,101126,1}]
            ,action = [{suit_tar,skill,600400}]
        }
    };
get(ai_rule, 103001) ->
    {ok, 
        #npc_ai_rule{
            id = 103001
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601020}]
        }
    };
get(ai_rule, 103002) ->
    {ok, 
        #npc_ai_rule{
            id = 103002
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600402}]
        }
    };
get(ai_rule, 103003) ->
    {ok, 
        #npc_ai_rule{
            id = 103003
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601023}]
        }
    };
get(ai_rule, 103004) ->
    {ok, 
        #npc_ai_rule{
            id = 103004
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600402}]
        }
    };
get(ai_rule, 103005) ->
    {ok, 
        #npc_ai_rule{
            id = 103005
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601024}]
        }
    };
get(ai_rule, 103015) ->
    {ok, 
        #npc_ai_rule{
            id = 103015
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600403}]
        }
    };
get(ai_rule, 103016) ->
    {ok, 
        #npc_ai_rule{
            id = 103016
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601008}]
        }
    };
get(ai_rule, 103017) ->
    {ok, 
        #npc_ai_rule{
            id = 103017
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,2,1},{self_side,buff,<<"not_in">>,104140,1}]
            ,action = [{suit_tar,skill,600404}]
        }
    };
get(ai_rule, 103018) ->
    {ok, 
        #npc_ai_rule{
            id = 103018
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601014}]
        }
    };
get(ai_rule, 103019) ->
    {ok, 
        #npc_ai_rule{
            id = 103019
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600405}]
        }
    };
get(ai_rule, 103020) ->
    {ok, 
        #npc_ai_rule{
            id = 103020
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601015}]
        }
    };
get(ai_rule, 103030) ->
    {ok, 
        #npc_ai_rule{
            id = 103030
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600401}]
        }
    };
get(ai_rule, 103031) ->
    {ok, 
        #npc_ai_rule{
            id = 103031
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601010}]
        }
    };
get(ai_rule, 103032) ->
    {ok, 
        #npc_ai_rule{
            id = 103032
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{self_side,skill,600406}]
        }
    };
get(ai_rule, 103033) ->
    {ok, 
        #npc_ai_rule{
            id = 103033
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601011}]
        }
    };
get(ai_rule, 103034) ->
    {ok, 
        #npc_ai_rule{
            id = 103034
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,50,1}]
            ,action = [{opp_side,skill,600407}]
        }
    };
get(ai_rule, 103035) ->
    {ok, 
        #npc_ai_rule{
            id = 103035
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601010}]
        }
    };
get(ai_rule, 103045) ->
    {ok, 
        #npc_ai_rule{
            id = 103045
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600408}]
        }
    };
get(ai_rule, 103046) ->
    {ok, 
        #npc_ai_rule{
            id = 103046
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601005}]
        }
    };
get(ai_rule, 103047) ->
    {ok, 
        #npc_ai_rule{
            id = 103047
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600405}]
        }
    };
get(ai_rule, 103048) ->
    {ok, 
        #npc_ai_rule{
            id = 103048
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601004}]
        }
    };
get(ai_rule, 103049) ->
    {ok, 
        #npc_ai_rule{
            id = 103049
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600409}]
        }
    };
get(ai_rule, 103050) ->
    {ok, 
        #npc_ai_rule{
            id = 103050
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601006}]
        }
    };
get(ai_rule, 103060) ->
    {ok, 
        #npc_ai_rule{
            id = 103060
            ,type = 0
            ,repeat = 0
            ,prob = 70
            ,condition = [{combat,round,<<"mod2">>,1,1}]
            ,action = [{opp_side,skill,600410}]
        }
    };
get(ai_rule, 103061) ->
    {ok, 
        #npc_ai_rule{
            id = 103061
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601006}]
        }
    };
get(ai_rule, 103062) ->
    {ok, 
        #npc_ai_rule{
            id = 103062
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1},{self_side,buff,<<"not_in">>,101126,1}]
            ,action = [{suit_tar,skill,600411}]
        }
    };
get(ai_rule, 103063) ->
    {ok, 
        #npc_ai_rule{
            id = 103063
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601009}]
        }
    };
get(ai_rule, 103064) ->
    {ok, 
        #npc_ai_rule{
            id = 103064
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{self,hp,<<"<=">>,60,1}]
            ,action = [{opp_side,skill,600407}]
        }
    };
get(ai_rule, 103065) ->
    {ok, 
        #npc_ai_rule{
            id = 103065
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601010}]
        }
    };
get(ai_rule, 103075) ->
    {ok, 
        #npc_ai_rule{
            id = 103075
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self_side,skill,600412}]
        }
    };
get(ai_rule, 103076) ->
    {ok, 
        #npc_ai_rule{
            id = 103076
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601025}]
        }
    };
get(ai_rule, 103077) ->
    {ok, 
        #npc_ai_rule{
            id = 103077
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod2">>,0,1}]
            ,action = [{opp_side,skill,600403}]
        }
    };
get(ai_rule, 103078) ->
    {ok, 
        #npc_ai_rule{
            id = 103078
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601026}]
        }
    };
get(ai_rule, 103079) ->
    {ok, 
        #npc_ai_rule{
            id = 103079
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{opp_side,skill,600413}]
        }
    };
get(ai_rule, 103080) ->
    {ok, 
        #npc_ai_rule{
            id = 103080
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601020}]
        }
    };
get(ai_rule, 103090) ->
    {ok, 
        #npc_ai_rule{
            id = 103090
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600414}]
        }
    };
get(ai_rule, 103091) ->
    {ok, 
        #npc_ai_rule{
            id = 103091
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601025}]
        }
    };
get(ai_rule, 103092) ->
    {ok, 
        #npc_ai_rule{
            id = 103092
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1},{self_side,buff,<<"not_in">>,101110,1}]
            ,action = [{suit_tar,skill,600415}]
        }
    };
get(ai_rule, 103093) ->
    {ok, 
        #npc_ai_rule{
            id = 103093
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601026}]
        }
    };
get(ai_rule, 103094) ->
    {ok, 
        #npc_ai_rule{
            id = 103094
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600416}]
        }
    };
get(ai_rule, 103095) ->
    {ok, 
        #npc_ai_rule{
            id = 103095
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601020}]
        }
    };
get(ai_rule, 103105) ->
    {ok, 
        #npc_ai_rule{
            id = 103105
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,600417}]
        }
    };
get(ai_rule, 103106) ->
    {ok, 
        #npc_ai_rule{
            id = 103106
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601010}]
        }
    };
get(ai_rule, 103107) ->
    {ok, 
        #npc_ai_rule{
            id = 103107
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600418}]
        }
    };
get(ai_rule, 103108) ->
    {ok, 
        #npc_ai_rule{
            id = 103108
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601011}]
        }
    };
get(ai_rule, 103109) ->
    {ok, 
        #npc_ai_rule{
            id = 103109
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600419}]
        }
    };
get(ai_rule, 103110) ->
    {ok, 
        #npc_ai_rule{
            id = 103110
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601013}]
        }
    };
get(ai_rule, 103111) ->
    {ok, 
        #npc_ai_rule{
            id = 103111
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{opp_side,buff,<<"include">>,202150,1}]
            ,action = [{suit_tar,skill,600423},{self,talk,[<<"你好像流血了哦~">>]}]
        }
    };
get(ai_rule, 103112) ->
    {ok, 
        #npc_ai_rule{
            id = 103112
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,202150,1}]
            ,action = [{suit_tar,skill,600423},{self,talk,[<<"我最喜欢在伤口撒盐了~">>]}]
        }
    };
get(ai_rule, 103113) ->
    {ok, 
        #npc_ai_rule{
            id = 103113
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600422}]
        }
    };
get(ai_rule, 103114) ->
    {ok, 
        #npc_ai_rule{
            id = 103114
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,601018},{self,talk,[<<"敢来挑战我，真是勇气可嘉！">>]}]
        }
    };
get(ai_rule, 103115) ->
    {ok, 
        #npc_ai_rule{
            id = 103115
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,202150,1},{suit_tar,hp,<<"<=">>,50,1}]
            ,action = [{suit_tar,skill,600424},{self,talk,[<<"看我把你砍成残废！">>]}]
        }
    };
get(ai_rule, 103116) ->
    {ok, 
        #npc_ai_rule{
            id = 103116
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod3">>,3,1},{self,hp,<<"<=">>,50,1}]
            ,action = [{self,skill,600425}]
        }
    };
get(ai_rule, 103117) ->
    {ok, 
        #npc_ai_rule{
            id = 103117
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,buff,<<"not_in">>,101126,1}]
            ,action = [{self,skill,600426},{self,talk,[<<"我的身体都要燃烧了！">>]}]
        }
    };
get(ai_rule, 103118) ->
    {ok, 
        #npc_ai_rule{
            id = 103118
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,601018}]
        }
    };
get(ai_rule, 103119) ->
    {ok, 
        #npc_ai_rule{
            id = 103119
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,8,1}]
            ,action = [{self,skill,600426},{self,talk,[<<"我要愤怒了！">>]}]
        }
    };
get(ai_rule, 103120) ->
    {ok, 
        #npc_ai_rule{
            id = 103120
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,9,1}]
            ,action = [{opp_side,skill,600427}]
        }
    };
get(ai_rule, 103121) ->
    {ok, 
        #npc_ai_rule{
            id = 103121
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1},{opp_side,buff,<<"include">>,200040,0}]
            ,action = [{opp_side,skill,600428},{self,talk,[<<"头晕目眩吧！">>]}]
        }
    };
get(ai_rule, 103124) ->
    {ok, 
        #npc_ai_rule{
            id = 103124
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1},{opp_side,buff,<<"not_in">>,200040,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,600429},{self,talk,[<<"你居然还能动！">>]}]
        }
    };
get(ai_rule, 103125) ->
    {ok, 
        #npc_ai_rule{
            id = 103125
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,2,1}]
            ,action = [{opp_side,skill,600430}]
        }
    };
get(ai_rule, 103126) ->
    {ok, 
        #npc_ai_rule{
            id = 103126
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,8,1}]
            ,action = [{opp_side,skill,600430}]
        }
    };
get(ai_rule, 103127) ->
    {ok, 
        #npc_ai_rule{
            id = 103127
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600431}]
        }
    };
get(ai_rule, 103128) ->
    {ok, 
        #npc_ai_rule{
            id = 103128
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16166,0}]
            ,action = [{self,skill,600432}]
        }
    };
get(ai_rule, 103129) ->
    {ok, 
        #npc_ai_rule{
            id = 103129
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16166,1},{suit_tar,hp,<<">">>,0,1}]
            ,action = [{suit_tar,skill,600433}]
        }
    };
get(ai_rule, 103130) ->
    {ok, 
        #npc_ai_rule{
            id = 103130
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16166,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{opp_side,skill,600434},{self,talk,[<<"你们竟敢杀掉我的小蝎子！">>]}]
        }
    };
get(ai_rule, 103131) ->
    {ok, 
        #npc_ai_rule{
            id = 103131
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600435},{self,talk,[<<"在毒液中沉睡吧！">>]}]
        }
    };
get(ai_rule, 103132) ->
    {ok, 
        #npc_ai_rule{
            id = 103132
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{self_side,skill,600436}]
        }
    };
get(ai_rule, 103133) ->
    {ok, 
        #npc_ai_rule{
            id = 103133
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,600437}]
        }
    };
get(ai_rule, 103134) ->
    {ok, 
        #npc_ai_rule{
            id = 103134
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600438}]
        }
    };
get(ai_rule, 103135) ->
    {ok, 
        #npc_ai_rule{
            id = 103135
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600439}]
        }
    };
get(ai_rule, 103136) ->
    {ok, 
        #npc_ai_rule{
            id = 103136
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self_side,skill,600440}]
        }
    };
get(ai_rule, 103137) ->
    {ok, 
        #npc_ai_rule{
            id = 103137
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,2,1}]
            ,action = [{opp_side,skill,600441},{self,talk,[<<"沉睡吧孩子们~">>]}]
        }
    };
get(ai_rule, 103138) ->
    {ok, 
        #npc_ai_rule{
            id = 103138
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,3,1},{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{suit_tar,skill,600444},{self,talk,[<<"把你吵醒啦~">>]}]
        }
    };
get(ai_rule, 103139) ->
    {ok, 
        #npc_ai_rule{
            id = 103139
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,4,1},{opp_side,buff,<<"not_in">>,200051,1}]
            ,action = [{suit_tar,skill,600442},{self,talk,[<<"不睡觉的孩子就该打~">>]}]
        }
    };
get(ai_rule, 103140) ->
    {ok, 
        #npc_ai_rule{
            id = 103140
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,600443}]
        }
    };
get(ai_rule, 103141) ->
    {ok, 
        #npc_ai_rule{
            id = 103141
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">">>,1,1}]
            ,action = [{opp_side,skill,600444}]
        }
    };
get(ai_rule, 103142) ->
    {ok, 
        #npc_ai_rule{
            id = 103142
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16167,0}]
            ,action = [{self,skill,600445}]
        }
    };
get(ai_rule, 103143) ->
    {ok, 
        #npc_ai_rule{
            id = 103143
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16126,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,16126,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self,skill,600449},{self,talk,[<<"身与影同在！">>]}]
        }
    };
get(ai_rule, 103144) ->
    {ok, 
        #npc_ai_rule{
            id = 103144
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,16167,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,16167,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self,skill,600445},{self,talk,[<<"身与影同在！">>]}]
        }
    };
get(ai_rule, 103145) ->
    {ok, 
        #npc_ai_rule{
            id = 103145
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,600446}]
        }
    };
get(ai_rule, 103146) ->
    {ok, 
        #npc_ai_rule{
            id = 103146
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{self_side,skill,600447},{self,talk,[<<"让你们见识影子的力量！">>]}]
        }
    };
get(ai_rule, 103147) ->
    {ok, 
        #npc_ai_rule{
            id = 103147
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600448}]
        }
    };
get(ai_rule, 103148) ->
    {ok, 
        #npc_ai_rule{
            id = 103148
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600450},{self,talk,[<<"让暴风雪掩埋你吧！">>]}]
        }
    };
get(ai_rule, 103149) ->
    {ok, 
        #npc_ai_rule{
            id = 103149
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600450}]
        }
    };
get(ai_rule, 103150) ->
    {ok, 
        #npc_ai_rule{
            id = 103150
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1},{opp_side,buff,<<"include">>,200070,1}]
            ,action = [{suit_tar,skill,600451},{self,talk,[<<"冰火连击！">>]}]
        }
    };
get(ai_rule, 103151) ->
    {ok, 
        #npc_ai_rule{
            id = 103151
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1}]
            ,action = [{opp_side,skill,600452},{self,talk,[<<"你们把我激怒了！">>]}]
        }
    };
get(ai_rule, 103152) ->
    {ok, 
        #npc_ai_rule{
            id = 103152
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{opp_side,skill,600453},{self,talk,[<<"让大火烧毁你们！">>]}]
        }
    };
get(ai_rule, 103153) ->
    {ok, 
        #npc_ai_rule{
            id = 103153
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600454}]
        }
    };
get(ai_rule, 103154) ->
    {ok, 
        #npc_ai_rule{
            id = 103154
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,ai_level,2}]
        }
    };
get(ai_rule, 103155) ->
    {ok, 
        #npc_ai_rule{
            id = 103155
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,600456},{self,talk,[<<"打扰我的睡眠！">>]}]
        }
    };
get(ai_rule, 103156) ->
    {ok, 
        #npc_ai_rule{
            id = 103156
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{self,skill,600457}]
        }
    };
get(ai_rule, 103157) ->
    {ok, 
        #npc_ai_rule{
            id = 103157
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600456}]
        }
    };
get(ai_rule, 103158) ->
    {ok, 
        #npc_ai_rule{
            id = 103158
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,600455},{self,talk,[<<"你们惹毛我了！">>]}]
        }
    };
get(ai_rule, 103159) ->
    {ok, 
        #npc_ai_rule{
            id = 103159
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,600459}]
        }
    };
get(ai_rule, 103160) ->
    {ok, 
        #npc_ai_rule{
            id = 103160
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1},{self,buff,<<"not_in">>,104140,1}]
            ,action = [{self,skill,600460},{self,talk,[<<"我需要更多力量！">>]}]
        }
    };
get(ai_rule, 103161) ->
    {ok, 
        #npc_ai_rule{
            id = 103161
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,600461}]
        }
    };
get(ai_rule, 103162) ->
    {ok, 
        #npc_ai_rule{
            id = 103162
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600456}]
        }
    };
get(ai_rule, 103163) ->
    {ok, 
        #npc_ai_rule{
            id = 103163
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,600462},{self,talk,[<<"将你们困入地牢！">>]}]
        }
    };
get(ai_rule, 103164) ->
    {ok, 
        #npc_ai_rule{
            id = 103164
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200040,1}]
            ,action = [{suit_tar,skill,600463}]
        }
    };
get(ai_rule, 103165) ->
    {ok, 
        #npc_ai_rule{
            id = 103165
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1},{self,buff,<<"not_in">>,104140,1}]
            ,action = [{self,skill,600464}]
        }
    };
get(ai_rule, 103166) ->
    {ok, 
        #npc_ai_rule{
            id = 103166
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600465},{self,talk,[<<"用你们的血来治我的伤！">>]}]
        }
    };
get(ai_rule, 103167) ->
    {ok, 
        #npc_ai_rule{
            id = 103167
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,600466}]
        }
    };
get(ai_rule, 150011) ->
    {ok, 
        #npc_ai_rule{
            id = 150011
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,835005},{self,talk,[<<"小弟们，有客人上门了！">>]}]
        }
    };
get(ai_rule, 150012) ->
    {ok, 
        #npc_ai_rule{
            id = 150012
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10465,1},{suit_tar,hp,<<">">>,0,0},{self_side,id,<<"=">>,10576,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self,skill,835005},{self,talk,[<<"你们两个怎么都不见了，别想着偷懒！">>]}]
        }
    };
get(ai_rule, 150013) ->
    {ok, 
        #npc_ai_rule{
            id = 150013
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10465,1},{suit_tar,hp,<<">">>,0,0},{self_side,id,<<"=">>,10576,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self,skill,835005},{self,talk,[<<"给我挺起来！">>]}]
        }
    };
get(ai_rule, 150014) ->
    {ok, 
        #npc_ai_rule{
            id = 150014
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015},{self,talk,[<<"我这可是涂满毒液的利爪！">>]}]
        }
    };
get(ai_rule, 150015) ->
    {ok, 
        #npc_ai_rule{
            id = 150015
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015}]
        }
    };
get(ai_rule, 150016) ->
    {ok, 
        #npc_ai_rule{
            id = 150016
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830014}]
        }
    };
get(ai_rule, 150017) ->
    {ok, 
        #npc_ai_rule{
            id = 150017
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015}]
        }
    };
get(ai_rule, 150018) ->
    {ok, 
        #npc_ai_rule{
            id = 150018
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,835006},{self,talk,[<<"诶，快过来看玩偶~">>]}]
        }
    };
get(ai_rule, 150019) ->
    {ok, 
        #npc_ai_rule{
            id = 150019
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10466,1},{suit_tar,hp,<<">">>,0,0},{self_side,id,<<"=">>,10577,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self,skill,835006},{self,talk,[<<"还没玩够呢！">>]}]
        }
    };
get(ai_rule, 150020) ->
    {ok, 
        #npc_ai_rule{
            id = 150020
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10466,1},{suit_tar,hp,<<">">>,0,0},{self_side,id,<<"=">>,10577,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self,skill,835006},{self,talk,[<<"打完这次就让你们走~">>]}]
        }
    };
get(ai_rule, 150021) ->
    {ok, 
        #npc_ai_rule{
            id = 150021
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015},{self,talk,[<<"我这可是涂满毒液的利爪！">>]}]
        }
    };
get(ai_rule, 150022) ->
    {ok, 
        #npc_ai_rule{
            id = 150022
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015}]
        }
    };
get(ai_rule, 150023) ->
    {ok, 
        #npc_ai_rule{
            id = 150023
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830014}]
        }
    };
get(ai_rule, 150024) ->
    {ok, 
        #npc_ai_rule{
            id = 150024
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015}]
        }
    };
get(ai_rule, 150025) ->
    {ok, 
        #npc_ai_rule{
            id = 150025
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,835007},{self,talk,[<<"有肉送上门啦。">>]}]
        }
    };
get(ai_rule, 150026) ->
    {ok, 
        #npc_ai_rule{
            id = 150026
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10467,1},{suit_tar,hp,<<">">>,0,0},{self_side,id,<<"=">>,10578,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self,skill,835007},{self,talk,[<<"你们跑那么快干嘛~！">>]}]
        }
    };
get(ai_rule, 150027) ->
    {ok, 
        #npc_ai_rule{
            id = 150027
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10467,1},{suit_tar,hp,<<">">>,0,0},{self_side,id,<<"=">>,10578,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self,skill,835007},{self,talk,[<<"再来一遍！">>]}]
        }
    };
get(ai_rule, 150028) ->
    {ok, 
        #npc_ai_rule{
            id = 150028
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015},{self,talk,[<<"我这可是涂满毒液的利爪！">>]}]
        }
    };
get(ai_rule, 150029) ->
    {ok, 
        #npc_ai_rule{
            id = 150029
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015}]
        }
    };
get(ai_rule, 150030) ->
    {ok, 
        #npc_ai_rule{
            id = 150030
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830014}]
        }
    };
get(ai_rule, 150031) ->
    {ok, 
        #npc_ai_rule{
            id = 150031
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015}]
        }
    };
get(ai_rule, 150032) ->
    {ok, 
        #npc_ai_rule{
            id = 150032
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,10354,1}]
            ,action = [{suit_tar,skill,835018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 150156) ->
    {ok, 
        #npc_ai_rule{
            id = 150156
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,10355,1}]
            ,action = [{suit_tar,skill,835018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 150157) ->
    {ok, 
        #npc_ai_rule{
            id = 150157
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,10356,1}]
            ,action = [{suit_tar,skill,835018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 150033) ->
    {ok, 
        #npc_ai_rule{
            id = 150033
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830016},{self,talk,[<<"想以多欺少吗，那你就错了！">>]}]
        }
    };
get(ai_rule, 150034) ->
    {ok, 
        #npc_ai_rule{
            id = 150034
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830017},{self,talk,[<<"颤栗吧">>]}]
        }
    };
get(ai_rule, 150035) ->
    {ok, 
        #npc_ai_rule{
            id = 150035
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830016}]
        }
    };
get(ai_rule, 150036) ->
    {ok, 
        #npc_ai_rule{
            id = 150036
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830017}]
        }
    };
get(ai_rule, 150158) ->
    {ok, 
        #npc_ai_rule{
            id = 150158
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,10354,1}]
            ,action = [{suit_tar,skill,835018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 150159) ->
    {ok, 
        #npc_ai_rule{
            id = 150159
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,10355,1}]
            ,action = [{suit_tar,skill,835018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 150037) ->
    {ok, 
        #npc_ai_rule{
            id = 150037
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,10356,1}]
            ,action = [{suit_tar,skill,835018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 150038) ->
    {ok, 
        #npc_ai_rule{
            id = 150038
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830017},{self,talk,[<<"你不会打中我的！">>]}]
        }
    };
get(ai_rule, 150039) ->
    {ok, 
        #npc_ai_rule{
            id = 150039
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830016},{self,talk,[<<"吃我一记！">>]}]
        }
    };
get(ai_rule, 150040) ->
    {ok, 
        #npc_ai_rule{
            id = 150040
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830016}]
        }
    };
get(ai_rule, 150041) ->
    {ok, 
        #npc_ai_rule{
            id = 150041
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830017}]
        }
    };
get(ai_rule, 150160) ->
    {ok, 
        #npc_ai_rule{
            id = 150160
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,10354,1}]
            ,action = [{suit_tar,skill,835018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 150161) ->
    {ok, 
        #npc_ai_rule{
            id = 150161
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,10355,1}]
            ,action = [{suit_tar,skill,835018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 150042) ->
    {ok, 
        #npc_ai_rule{
            id = 150042
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,10356,1}]
            ,action = [{suit_tar,skill,835018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 150043) ->
    {ok, 
        #npc_ai_rule{
            id = 150043
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830016}]
        }
    };
get(ai_rule, 150044) ->
    {ok, 
        #npc_ai_rule{
            id = 150044
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830017}]
        }
    };
get(ai_rule, 150045) ->
    {ok, 
        #npc_ai_rule{
            id = 150045
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,835019},{self,talk,[<<"啊~你的魔力味道真好~">>]}]
        }
    };
get(ai_rule, 150046) ->
    {ok, 
        #npc_ai_rule{
            id = 150046
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,skill,835022},{self,talk,[<<"我能够将吸收的魔力化作护盾！">>]}]
        }
    };
get(ai_rule, 150047) ->
    {ok, 
        #npc_ai_rule{
            id = 150047
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835020},{self,talk,[<<"我感受到力量涌进我的身体！">>]}]
        }
    };
get(ai_rule, 150048) ->
    {ok, 
        #npc_ai_rule{
            id = 150048
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835020},{self,talk,[<<"抓不住的魔力，就随它去吧。">>]}]
        }
    };
get(ai_rule, 150049) ->
    {ok, 
        #npc_ai_rule{
            id = 150049
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{opp_side,career,<<"=">>,2,1}]
            ,action = [{opp_side,skill,835019},{self,talk,[<<"小朋友，拿稳你的玩具匕首了~">>]}]
        }
    };
get(ai_rule, 150050) ->
    {ok, 
        #npc_ai_rule{
            id = 150050
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{opp_side,career,<<"=">>,5,1}]
            ,action = [{opp_side,skill,835019},{self,talk,[<<"听说你的凌空下劈很厉害……呵呵呵……">>]}]
        }
    };
get(ai_rule, 150051) ->
    {ok, 
        #npc_ai_rule{
            id = 150051
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{opp_side,career,<<"=">>,3,1}]
            ,action = [{opp_side,skill,835019},{self,talk,[<<"你要用法杖敲我吗，好怕哦！">>]}]
        }
    };
get(ai_rule, 150052) ->
    {ok, 
        #npc_ai_rule{
            id = 150052
            ,type = 0
            ,repeat = 1
            ,prob = 18
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835020},{self,talk,[<<"这一点魔力并不能满足我">>]}]
        }
    };
get(ai_rule, 150053) ->
    {ok, 
        #npc_ai_rule{
            id = 150053
            ,type = 0
            ,repeat = 1
            ,prob = 36
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835021},{self,talk,[<<"我想要更多……更多……">>]}]
        }
    };
get(ai_rule, 150054) ->
    {ok, 
        #npc_ai_rule{
            id = 150054
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835019}]
        }
    };
get(ai_rule, 150055) ->
    {ok, 
        #npc_ai_rule{
            id = 150055
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,835023},{self,talk,[<<"安静下来。">>]}]
        }
    };
get(ai_rule, 150056) ->
    {ok, 
        #npc_ai_rule{
            id = 150056
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,835023},{self,talk,[<<"安静下来。">>]}]
        }
    };
get(ai_rule, 150057) ->
    {ok, 
        #npc_ai_rule{
            id = 150057
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835025}]
        }
    };
get(ai_rule, 150058) ->
    {ok, 
        #npc_ai_rule{
            id = 150058
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835024}]
        }
    };
get(ai_rule, 150059) ->
    {ok, 
        #npc_ai_rule{
            id = 150059
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,835026},{self,talk,[<<"强大的神源之力让我生命力更澎湃！">>]}]
        }
    };
get(ai_rule, 150060) ->
    {ok, 
        #npc_ai_rule{
            id = 150060
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,835026},{self,talk,[<<"你也太天真了~">>]}]
        }
    };
get(ai_rule, 150061) ->
    {ok, 
        #npc_ai_rule{
            id = 150061
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,835026},{self,talk,[<<"再砍我一刀试试">>]}]
        }
    };
get(ai_rule, 150062) ->
    {ok, 
        #npc_ai_rule{
            id = 150062
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,835026},{self,talk,[<<"就跟给我搔痒一样~">>]}]
        }
    };
get(ai_rule, 150063) ->
    {ok, 
        #npc_ai_rule{
            id = 150063
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,835026},{self,talk,[<<"这就是你的全部实力了吗？">>]}]
        }
    };
get(ai_rule, 150064) ->
    {ok, 
        #npc_ai_rule{
            id = 150064
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,835026},{self,talk,[<<"我还不想死啦">>]}]
        }
    };
get(ai_rule, 150065) ->
    {ok, 
        #npc_ai_rule{
            id = 150065
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,835026},{self,talk,[<<"我都懒得跟你打了~">>]}]
        }
    };
get(ai_rule, 150066) ->
    {ok, 
        #npc_ai_rule{
            id = 150066
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,835026},{self,talk,[<<"一不小心又治疗了一点~">>]}]
        }
    };
get(ai_rule, 150067) ->
    {ok, 
        #npc_ai_rule{
            id = 150067
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,835026},{self,talk,[<<"趁我心情好你快点跑吧！">>]}]
        }
    };
get(ai_rule, 150068) ->
    {ok, 
        #npc_ai_rule{
            id = 150068
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835027}]
        }
    };
get(ai_rule, 150073) ->
    {ok, 
        #npc_ai_rule{
            id = 150073
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830040},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 150074) ->
    {ok, 
        #npc_ai_rule{
            id = 150074
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830038},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 150075) ->
    {ok, 
        #npc_ai_rule{
            id = 150075
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830039},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 150076) ->
    {ok, 
        #npc_ai_rule{
            id = 150076
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830032},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 150077) ->
    {ok, 
        #npc_ai_rule{
            id = 150077
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,50,1}]
            ,action = [{opp_side,skill,830033},{self,talk,[<<"你为什么要伤害我……">>]}]
        }
    };
get(ai_rule, 150097) ->
    {ok, 
        #npc_ai_rule{
            id = 150097
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,50,1}]
            ,action = [{opp_side,skill,830033}]
        }
    };
get(ai_rule, 150078) ->
    {ok, 
        #npc_ai_rule{
            id = 150078
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033},{self,talk,[<<"谢谢你，让我一起来打倒他们！">>]}]
        }
    };
get(ai_rule, 150079) ->
    {ok, 
        #npc_ai_rule{
            id = 150079
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10366,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,10588,1},{suit_tar,hp,<<"<=">>,0,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1},{self,buff,<<"not_in">>,200060,1}]
            ,action = [{self,skill,830034},{self,talk,[<<"谢谢你，我要藏起来了！">>]}]
        }
    };
get(ai_rule, 150080) ->
    {ok, 
        #npc_ai_rule{
            id = 150080
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033}]
        }
    };
get(ai_rule, 150081) ->
    {ok, 
        #npc_ai_rule{
            id = 150081
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830040},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 150082) ->
    {ok, 
        #npc_ai_rule{
            id = 150082
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830038},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 150083) ->
    {ok, 
        #npc_ai_rule{
            id = 150083
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830039},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 150084) ->
    {ok, 
        #npc_ai_rule{
            id = 150084
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830032},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 150085) ->
    {ok, 
        #npc_ai_rule{
            id = 150085
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,50,1}]
            ,action = [{opp_side,skill,830033},{self,talk,[<<"你为什么要伤害我……">>]}]
        }
    };
get(ai_rule, 150098) ->
    {ok, 
        #npc_ai_rule{
            id = 150098
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,50,1}]
            ,action = [{opp_side,skill,830033}]
        }
    };
get(ai_rule, 150086) ->
    {ok, 
        #npc_ai_rule{
            id = 150086
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033},{self,talk,[<<"谢谢你，让我一起来打倒他们！">>]}]
        }
    };
get(ai_rule, 150087) ->
    {ok, 
        #npc_ai_rule{
            id = 150087
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10367,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,10589,1},{suit_tar,hp,<<"<=">>,0,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1},{self,buff,<<"not_in">>,200060,1}]
            ,action = [{self,skill,830034},{self,talk,[<<"谢谢你，我要藏起来了！">>]}]
        }
    };
get(ai_rule, 150088) ->
    {ok, 
        #npc_ai_rule{
            id = 150088
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033}]
        }
    };
get(ai_rule, 150089) ->
    {ok, 
        #npc_ai_rule{
            id = 150089
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830040},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 150090) ->
    {ok, 
        #npc_ai_rule{
            id = 150090
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830038},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 150091) ->
    {ok, 
        #npc_ai_rule{
            id = 150091
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830039},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 150092) ->
    {ok, 
        #npc_ai_rule{
            id = 150092
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830032},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 150093) ->
    {ok, 
        #npc_ai_rule{
            id = 150093
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,50,1}]
            ,action = [{opp_side,skill,830033},{self,talk,[<<"你为什么要伤害我……">>]}]
        }
    };
get(ai_rule, 150099) ->
    {ok, 
        #npc_ai_rule{
            id = 150099
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,50,1}]
            ,action = [{opp_side,skill,830033}]
        }
    };
get(ai_rule, 150094) ->
    {ok, 
        #npc_ai_rule{
            id = 150094
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033},{self,talk,[<<"谢谢你，让我一起来打倒他们！">>]}]
        }
    };
get(ai_rule, 150095) ->
    {ok, 
        #npc_ai_rule{
            id = 150095
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10368,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,10590,1},{suit_tar,hp,<<"<=">>,0,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1},{self,buff,<<"not_in">>,200060,1}]
            ,action = [{self,skill,830034},{self,talk,[<<"谢谢你，我要藏起来了！">>]}]
        }
    };
get(ai_rule, 150096) ->
    {ok, 
        #npc_ai_rule{
            id = 150096
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033}]
        }
    };
get(ai_rule, 150148) ->
    {ok, 
        #npc_ai_rule{
            id = 150148
            ,type = 0
            ,repeat = 1
            ,prob = 75
            ,condition = [{opp_side,career,<<"=">>,2,1},{suit_tar,buff,<<"not_in">>,209030,1}]
            ,action = [{opp_side,skill,830041},{self,talk,[<<"陷入无尽的毒液泥潭中吧">>]}]
        }
    };
get(ai_rule, 150149) ->
    {ok, 
        #npc_ai_rule{
            id = 150149
            ,type = 0
            ,repeat = 1
            ,prob = 75
            ,condition = [{opp_side,career,<<"=">>,5,1},{suit_tar,buff,<<"not_in">>,209030,1}]
            ,action = [{opp_side,skill,830041},{self,talk,[<<"陷入无尽的毒液泥潭中吧">>]}]
        }
    };
get(ai_rule, 150150) ->
    {ok, 
        #npc_ai_rule{
            id = 150150
            ,type = 0
            ,repeat = 1
            ,prob = 75
            ,condition = [{opp_side,career,<<"=">>,3,1},{suit_tar,buff,<<"not_in">>,209030,1}]
            ,action = [{opp_side,skill,830041},{self,talk,[<<"陷入无尽的毒液泥潭中吧">>]}]
        }
    };
get(ai_rule, 150151) ->
    {ok, 
        #npc_ai_rule{
            id = 150151
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"include">>,209030,1}]
            ,action = [{opp_side,skill,830044},{self,talk,[<<"浸泡着毒素的血液最鲜美了！">>]}]
        }
    };
get(ai_rule, 150152) ->
    {ok, 
        #npc_ai_rule{
            id = 150152
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835043},{self,talk,[<<"让你身上的毒素在下次爆发吧！">>]}]
        }
    };
get(ai_rule, 150153) ->
    {ok, 
        #npc_ai_rule{
            id = 150153
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,209030,1}]
            ,action = [{opp_side,skill,830042},{self,talk,[<<"毒液让你变得脆弱无比！">>]}]
        }
    };
get(ai_rule, 150154) ->
    {ok, 
        #npc_ai_rule{
            id = 150154
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{opp_side,buff,<<"include">>,209030,1}]
            ,action = [{opp_side,skill,830042}]
        }
    };
get(ai_rule, 150155) ->
    {ok, 
        #npc_ai_rule{
            id = 150155
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830045}]
        }
    };
get(ai_rule, 150200) ->
    {ok, 
        #npc_ai_rule{
            id = 150200
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,10483,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,835046},{self,talk,[<<"勇敢战斗吧">>]}]
        }
    };
get(ai_rule, 150201) ->
    {ok, 
        #npc_ai_rule{
            id = 150201
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,10594,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,835046},{self,talk,[<<"谁也无法刺穿这屏障">>]}]
        }
    };
get(ai_rule, 150202) ->
    {ok, 
        #npc_ai_rule{
            id = 150202
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835048}]
        }
    };
get(ai_rule, 150203) ->
    {ok, 
        #npc_ai_rule{
            id = 150203
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1}]
            ,action = [{suit_tar,skill,835047},{self,talk,[<<"胆小鬼，来打我呀">>]}]
        }
    };
get(ai_rule, 150204) ->
    {ok, 
        #npc_ai_rule{
            id = 150204
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1}]
            ,action = [{suit_tar,skill,835047},{self,talk,[<<"是不是吓得发抖了">>]}]
        }
    };
get(ai_rule, 150214) ->
    {ok, 
        #npc_ai_rule{
            id = 150214
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835048}]
        }
    };
get(ai_rule, 150205) ->
    {ok, 
        #npc_ai_rule{
            id = 150205
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1},{opp_side,career,<<"=">>,2,1}]
            ,action = [{suit_tar,skill,835047},{self,talk,[<<"你这把小匕首能把纸刺穿吗？">>]}]
        }
    };
get(ai_rule, 150206) ->
    {ok, 
        #npc_ai_rule{
            id = 150206
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1},{opp_side,career,<<"=">>,5,1}]
            ,action = [{suit_tar,skill,835047},{self,talk,[<<"在我眼里你的盾也不过跟纸糊的一样~">>]}]
        }
    };
get(ai_rule, 150207) ->
    {ok, 
        #npc_ai_rule{
            id = 150207
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1},{opp_side,career,<<"=">>,3,1}]
            ,action = [{suit_tar,skill,835047},{self,talk,[<<"用你这破法杖变个火球出来看看？">>]}]
        }
    };
get(ai_rule, 150208) ->
    {ok, 
        #npc_ai_rule{
            id = 150208
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1}]
            ,action = [{suit_tar,skill,835047}]
        }
    };
get(ai_rule, 150209) ->
    {ok, 
        #npc_ai_rule{
            id = 150209
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835048}]
        }
    };
get(ai_rule, 150210) ->
    {ok, 
        #npc_ai_rule{
            id = 150210
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,11484,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,830046},{self,talk,[<<"勇敢战斗吧">>]}]
        }
    };
get(ai_rule, 150211) ->
    {ok, 
        #npc_ai_rule{
            id = 150211
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,11595,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,830046},{self,talk,[<<"谁也无法刺穿这屏障">>]}]
        }
    };
get(ai_rule, 150212) ->
    {ok, 
        #npc_ai_rule{
            id = 150212
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,11485,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,830046},{self,talk,[<<"勇敢战斗吧">>]}]
        }
    };
get(ai_rule, 150215) ->
    {ok, 
        #npc_ai_rule{
            id = 150215
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,11596,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,830046},{self,talk,[<<"谁也无法刺穿这屏障">>]}]
        }
    };
get(ai_rule, 150355) ->
    {ok, 
        #npc_ai_rule{
            id = 150355
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10500,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,10500,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,835251},{self,talk,[<<"双生冰精，同生共死！">>]}]
        }
    };
get(ai_rule, 150361) ->
    {ok, 
        #npc_ai_rule{
            id = 150361
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<">">>,20,1},{self,hp,<<"<">>,40,1}]
            ,action = [{opp_side,skill,830256},{self,talk,[<<"血祭开始了">>]}]
        }
    };
get(ai_rule, 150362) ->
    {ok, 
        #npc_ai_rule{
            id = 150362
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,skill,835257},{self,talk,[<<"虽然冰精无法习得回复术">>]}]
        }
    };
get(ai_rule, 150363) ->
    {ok, 
        #npc_ai_rule{
            id = 150363
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830262}]
        }
    };
get(ai_rule, 150356) ->
    {ok, 
        #npc_ai_rule{
            id = 150356
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10387,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,10387,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,835250},{self,talk,[<<"双生冰精，同生共死！">>]}]
        }
    };
get(ai_rule, 150364) ->
    {ok, 
        #npc_ai_rule{
            id = 150364
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10387,1},{suit_tar,hp,<<">">>,20,1},{suit_tar,hp,<<"<">>,40,1}]
            ,action = [{self_side,skill,830263},{self,talk,[<<"我已准备就绪">>]}]
        }
    };
get(ai_rule, 150367) ->
    {ok, 
        #npc_ai_rule{
            id = 150367
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,skill,835258},{self,talk,[<<"但是通过这种方式，可以共享生命！">>]}]
        }
    };
get(ai_rule, 150368) ->
    {ok, 
        #npc_ai_rule{
            id = 150368
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,0,1}]
            ,action = [{opp_side,skill,830259},{self,talk,[<<"没想到你能逼我使出这招。">>]}]
        }
    };
get(ai_rule, 150369) ->
    {ok, 
        #npc_ai_rule{
            id = 150369
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,830260},{self,talk,[<<"窒息于严寒之中是件幸福的事情">>]}]
        }
    };
get(ai_rule, 150370) ->
    {ok, 
        #npc_ai_rule{
            id = 150370
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830261}]
        }
    };
get(ai_rule, 150371) ->
    {ok, 
        #npc_ai_rule{
            id = 150371
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830262}]
        }
    };
get(ai_rule, 150400) ->
    {ok, 
        #npc_ai_rule{
            id = 150400
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,835550},{self,talk,[<<"我一直生活在雪山地带，不希望外人来打扰">>]}]
        }
    };
get(ai_rule, 150401) ->
    {ok, 
        #npc_ai_rule{
            id = 150401
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,835551},{self,talk,[<<"雪山原本就是巨人与其他生物的住所，人类为何要侵略进来？">>]}]
        }
    };
get(ai_rule, 150402) ->
    {ok, 
        #npc_ai_rule{
            id = 150402
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1}]
            ,action = [{opp_side,skill,835552},{self,talk,[<<"你狭隘的思想真烦人，我甚至连你吟唱技能都不想听">>]}]
        }
    };
get(ai_rule, 150403) ->
    {ok, 
        #npc_ai_rule{
            id = 150403
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,0,1}]
            ,action = [{self_side,skill,835553},{self,talk,[<<"我们雪山一族不会轻易死去！">>]}]
        }
    };
get(ai_rule, 150404) ->
    {ok, 
        #npc_ai_rule{
            id = 150404
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835556}]
        }
    };
get(ai_rule, 150405) ->
    {ok, 
        #npc_ai_rule{
            id = 150405
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,15,1}]
            ,action = [{self_side,skill,835557},{self,talk,[<<"我终于把獠牙磨锋利了，嘿嘿嘿">>]}]
        }
    };
get(ai_rule, 150550) ->
    {ok, 
        #npc_ai_rule{
            id = 150550
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830456},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 150551) ->
    {ok, 
        #npc_ai_rule{
            id = 150551
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830457},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 150552) ->
    {ok, 
        #npc_ai_rule{
            id = 150552
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830458},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 150553) ->
    {ok, 
        #npc_ai_rule{
            id = 150553
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830450},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 150554) ->
    {ok, 
        #npc_ai_rule{
            id = 150554
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"听说人类很好骗，原来是真的！">>]}]
        }
    };
get(ai_rule, 150555) ->
    {ok, 
        #npc_ai_rule{
            id = 150555
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"我以为我们能做朋友的……如果你不是丑陋的人类的话！">>]}]
        }
    };
get(ai_rule, 150556) ->
    {ok, 
        #npc_ai_rule{
            id = 150556
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453}]
        }
    };
get(ai_rule, 150557) ->
    {ok, 
        #npc_ai_rule{
            id = 150557
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830456},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 150558) ->
    {ok, 
        #npc_ai_rule{
            id = 150558
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830457},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 150559) ->
    {ok, 
        #npc_ai_rule{
            id = 150559
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830458},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 150560) ->
    {ok, 
        #npc_ai_rule{
            id = 150560
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830450},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 150561) ->
    {ok, 
        #npc_ai_rule{
            id = 150561
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"听说人类很好骗，原来是真的！">>]}]
        }
    };
get(ai_rule, 150562) ->
    {ok, 
        #npc_ai_rule{
            id = 150562
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"我以为我们能做朋友的……如果你不是丑陋的人类的话！">>]}]
        }
    };
get(ai_rule, 150563) ->
    {ok, 
        #npc_ai_rule{
            id = 150563
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453}]
        }
    };
get(ai_rule, 150564) ->
    {ok, 
        #npc_ai_rule{
            id = 150564
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830457},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 150565) ->
    {ok, 
        #npc_ai_rule{
            id = 150565
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830456},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 150566) ->
    {ok, 
        #npc_ai_rule{
            id = 150566
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830458},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 150567) ->
    {ok, 
        #npc_ai_rule{
            id = 150567
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830450},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 150568) ->
    {ok, 
        #npc_ai_rule{
            id = 150568
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{self,ai_level,2}]
        }
    };
get(ai_rule, 150569) ->
    {ok, 
        #npc_ai_rule{
            id = 150569
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10401,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,10625,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{self,skill,830452},{self,talk,[<<"谢谢你，我要逃跑了！">>]}]
        }
    };
get(ai_rule, 150570) ->
    {ok, 
        #npc_ai_rule{
            id = 150570
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{self,hp,<<"<=">>,75,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"如果你不打我，我们还能做朋友！">>]}]
        }
    };
get(ai_rule, 150571) ->
    {ok, 
        #npc_ai_rule{
            id = 150571
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{self,hp,<<"<=">>,75,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"原本我还以为我们能做朋友的……">>]}]
        }
    };
get(ai_rule, 150572) ->
    {ok, 
        #npc_ai_rule{
            id = 150572
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{self_side,buff,<<"not_in">>,104140,1}]
            ,action = [{suit_tar,skill,830453},{self,talk,[<<"我们水精原本都是被俘虏的，但是有些开始为虎作伥了……">>]}]
        }
    };
get(ai_rule, 150573) ->
    {ok, 
        #npc_ai_rule{
            id = 150573
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{self_side,buff,<<"not_in">>,104140,1}]
            ,action = [{suit_tar,skill,830453}]
        }
    };
get(ai_rule, 150574) ->
    {ok, 
        #npc_ai_rule{
            id = 150574
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"听说人类很好骗，原来是真的！">>]}]
        }
    };
get(ai_rule, 150575) ->
    {ok, 
        #npc_ai_rule{
            id = 150575
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"我以为我们能做朋友的……如果你不是丑陋的人类的话！">>]}]
        }
    };
get(ai_rule, 150576) ->
    {ok, 
        #npc_ai_rule{
            id = 150576
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453}]
        }
    };
get(ai_rule, 150577) ->
    {ok, 
        #npc_ai_rule{
            id = 150577
            ,type = 0
            ,repeat = 1
            ,prob = 15
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830454},{self,talk,[<<"你再敢多嘴看看！">>]}]
        }
    };
get(ai_rule, 150578) ->
    {ok, 
        #npc_ai_rule{
            id = 150578
            ,type = 0
            ,repeat = 1
            ,prob = 15
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830455},{self,talk,[<<"等我收拾掉这些家伙再来教训你！">>]}]
        }
    };
get(ai_rule, 150579) ->
    {ok, 
        #npc_ai_rule{
            id = 150579
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830453}]
        }
    };
get(ai_rule, 150600) ->
    {ok, 
        #npc_ai_rule{
            id = 150600
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self_side,skill,835500},{self,talk,[<<"冰原狼，撕碎这个迷路的人类！">>]}]
        }
    };
get(ai_rule, 150602) ->
    {ok, 
        #npc_ai_rule{
            id = 150602
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10518,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,835505},{self,talk,[<<"铁甲巨兔，帮我抵住攻击！">>]}]
        }
    };
get(ai_rule, 150604) ->
    {ok, 
        #npc_ai_rule{
            id = 150604
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10518,1},{suit_tar,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,104140,1}]
            ,action = [{suit_tar,skill,835502},{self,talk,[<<"强化利爪！">>]}]
        }
    };
get(ai_rule, 150605) ->
    {ok, 
        #npc_ai_rule{
            id = 150605
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10518,1},{suit_tar,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,100390,1}]
            ,action = [{suit_tar,skill,835504},{self,talk,[<<"血液贪婪！">>]}]
        }
    };
get(ai_rule, 150609) ->
    {ok, 
        #npc_ai_rule{
            id = 150609
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10629,1},{suit_tar,hp,<<"<=">>,60,1}]
            ,action = [{suit_tar,skill,835509},{self,talk,[<<"这是最强的壁垒">>]}]
        }
    };
get(ai_rule, 150612) ->
    {ok, 
        #npc_ai_rule{
            id = 150612
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10518,1},{suit_tar,hp,<<">">>,0,0},{self_side,id,<<"=">>,10629,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{opp_side,skill,835510},{self,talk,[<<"你竟敢伤害我的宠物，你成功惹怒我了，人类！">>]}]
        }
    };
get(ai_rule, 150601) ->
    {ok, 
        #npc_ai_rule{
            id = 150601
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self_side,skill,835501},{self,talk,[<<"冰原狼，撕碎这个迷路的人类！">>]}]
        }
    };
get(ai_rule, 150603) ->
    {ok, 
        #npc_ai_rule{
            id = 150603
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10519,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,835506},{self,talk,[<<"铁甲巨兔，帮我抵住攻击！">>]}]
        }
    };
get(ai_rule, 150606) ->
    {ok, 
        #npc_ai_rule{
            id = 150606
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10519,1},{suit_tar,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,104140,1}]
            ,action = [{suit_tar,skill,835502},{self,talk,[<<"强化利爪！">>]}]
        }
    };
get(ai_rule, 150607) ->
    {ok, 
        #npc_ai_rule{
            id = 150607
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10519,1},{suit_tar,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,100120,1}]
            ,action = [{suit_tar,skill,835503},{self,talk,[<<"狂暴化吧冰原狼！">>]}]
        }
    };
get(ai_rule, 150608) ->
    {ok, 
        #npc_ai_rule{
            id = 150608
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10519,1},{suit_tar,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,100390,1}]
            ,action = [{suit_tar,skill,835504},{self,talk,[<<"血液贪婪！">>]}]
        }
    };
get(ai_rule, 150610) ->
    {ok, 
        #npc_ai_rule{
            id = 150610
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10630,1},{suit_tar,hp,<<"<=">>,60,1}]
            ,action = [{suit_tar,skill,835509},{self,talk,[<<"这是最强的壁垒">>]}]
        }
    };
get(ai_rule, 150611) ->
    {ok, 
        #npc_ai_rule{
            id = 150611
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10630,1},{suit_tar,hp,<<"<=">>,30,1}]
            ,action = [{suit_tar,skill,835508},{self,talk,[<<"我不会让你倒下的">>]}]
        }
    };
get(ai_rule, 150613) ->
    {ok, 
        #npc_ai_rule{
            id = 150613
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10519,1},{suit_tar,hp,<<">">>,0,0},{self_side,id,<<"=">>,10630,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{opp_side,skill,835510},{self,talk,[<<"你竟敢伤害我的宠物，你成功惹怒我了，人类！">>]}]
        }
    };
get(ai_rule, 150614) ->
    {ok, 
        #npc_ai_rule{
            id = 150614
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835511},{self,talk,[<<"你擅自闯入了主人的领地，他不会放过你的！">>]}]
        }
    };
get(ai_rule, 150615) ->
    {ok, 
        #npc_ai_rule{
            id = 150615
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835512}]
        }
    };
get(ai_rule, 150616) ->
    {ok, 
        #npc_ai_rule{
            id = 150616
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835513},{self,talk,[<<"可恶，我主人不在我无法发挥足够的力量">>]}]
        }
    };
get(ai_rule, 150617) ->
    {ok, 
        #npc_ai_rule{
            id = 150617
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835513}]
        }
    };
get(ai_rule, 150618) ->
    {ok, 
        #npc_ai_rule{
            id = 150618
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,7,1},{self,buff,<<"not_in">>,200060,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1}]
            ,action = [{self,skill,830034},{self,talk,[<<"不好了，我得找机会通知主人！">>]}]
        }
    };
get(ai_rule, 150619) ->
    {ok, 
        #npc_ai_rule{
            id = 150619
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835511}]
        }
    };
get(ai_rule, 150620) ->
    {ok, 
        #npc_ai_rule{
            id = 150620
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835512},{self,talk,[<<"我感觉到强大的力量源源不断地涌进身体！">>]}]
        }
    };
get(ai_rule, 150621) ->
    {ok, 
        #npc_ai_rule{
            id = 150621
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835512},{self,talk,[<<"你就帮我磨磨牙吧！">>]}]
        }
    };
get(ai_rule, 150622) ->
    {ok, 
        #npc_ai_rule{
            id = 150622
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835513},{self,talk,[<<"你也就只能趁主人不在的时候偷袭我们！">>]}]
        }
    };
get(ai_rule, 150623) ->
    {ok, 
        #npc_ai_rule{
            id = 150623
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835513},{self,talk,[<<"凭你这疲软的攻击，恐怕连一块树叶都打不穿！">>]}]
        }
    };
get(ai_rule, 150624) ->
    {ok, 
        #npc_ai_rule{
            id = 150624
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835513}]
        }
    };
get(ai_rule, 150650) ->
    {ok, 
        #npc_ai_rule{
            id = 150650
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,60,1},{self,buff,<<"not_in">>,200060,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1}]
            ,action = [{self,skill,835605},{self,talk,[<<"即使燃烧生命我也要击倒你！！！">>]}]
        }
    };
get(ai_rule, 150651) ->
    {ok, 
        #npc_ai_rule{
            id = 150651
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835601},{self,talk,[<<"撞在我的拳头下，只能怪你运气不好了！">>]}]
        }
    };
get(ai_rule, 150652) ->
    {ok, 
        #npc_ai_rule{
            id = 150652
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{opp_side,skill,835601},{self,talk,[<<"想逃？如果腿骨还没被敲断的话就试试吧！">>]}]
        }
    };
get(ai_rule, 150653) ->
    {ok, 
        #npc_ai_rule{
            id = 150653
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,835606},{self,talk,[<<"我给你一次机会，离开雪山。噢不，我反悔了哈哈哈！">>]}]
        }
    };
get(ai_rule, 150654) ->
    {ok, 
        #npc_ai_rule{
            id = 150654
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835601}]
        }
    };
get(ai_rule, 150655) ->
    {ok, 
        #npc_ai_rule{
            id = 150655
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835600}]
        }
    };
get(ai_rule, 150700) ->
    {ok, 
        #npc_ai_rule{
            id = 150700
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,835651},{self,talk,[<<"将你囚禁在骨牢地狱之中！">>]}]
        }
    };
get(ai_rule, 150701) ->
    {ok, 
        #npc_ai_rule{
            id = 150701
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,835651},{self,talk,[<<"将你囚禁在骨牢地狱之中！">>]}]
        }
    };
get(ai_rule, 150702) ->
    {ok, 
        #npc_ai_rule{
            id = 150702
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,835651},{self,talk,[<<"将你囚禁在骨牢地狱之中！">>]}]
        }
    };
get(ai_rule, 150703) ->
    {ok, 
        #npc_ai_rule{
            id = 150703
            ,type = 0
            ,repeat = 1
            ,prob = 41
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835652},{self,talk,[<<"骨刺攻击！">>]}]
        }
    };
get(ai_rule, 150704) ->
    {ok, 
        #npc_ai_rule{
            id = 150704
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835650}]
        }
    };
get(ai_rule, 150751) ->
    {ok, 
        #npc_ai_rule{
            id = 150751
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835702},{self,talk,[<<"银马冲锋刺！">>]}]
        }
    };
get(ai_rule, 150752) ->
    {ok, 
        #npc_ai_rule{
            id = 150752
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,835701},{self,talk,[<<"踏破你的铠甲！">>]}]
        }
    };
get(ai_rule, 150753) ->
    {ok, 
        #npc_ai_rule{
            id = 150753
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,835702},{self,talk,[<<"还能挡住我的冲锋吗！">>]}]
        }
    };
get(ai_rule, 150754) ->
    {ok, 
        #npc_ai_rule{
            id = 150754
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,835702}]
        }
    };
get(ai_rule, 150755) ->
    {ok, 
        #npc_ai_rule{
            id = 150755
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835700}]
        }
    };
get(ai_rule, 150800) ->
    {ok, 
        #npc_ai_rule{
            id = 150800
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,9,1}]
            ,action = [{self,skill,835752},{self,talk,[<<"狂暴之怒！">>]}]
        }
    };
get(ai_rule, 150801) ->
    {ok, 
        #npc_ai_rule{
            id = 150801
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{self,skill,835751},{self,talk,[<<"反击风暴开始了！">>]}]
        }
    };
get(ai_rule, 150802) ->
    {ok, 
        #npc_ai_rule{
            id = 150802
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835750}]
        }
    };
get(ai_rule, 150850) ->
    {ok, 
        #npc_ai_rule{
            id = 150850
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,18,1},{self_side,id,<<"=">>,10654,1},{suit_tar,hp,<<">">>,80,1},{self_side,id,<<"=">>,10684,1},{suit_tar,hp,<<">">>,80,1},{self_side,id,<<"=">>,10714,1},{suit_tar,hp,<<">">>,80,1}]
            ,action = [{opp_side,skill,835805},{self,talk,[<<"想法不错，但是，可惜！">>]}]
        }
    };
get(ai_rule, 150851) ->
    {ok, 
        #npc_ai_rule{
            id = 150851
            ,type = 0
            ,repeat = 0
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,3,1},{combat,round,<<"<=">>,7,1}]
            ,action = [{opp_side,skill,835802},{self,talk,[<<"锁定！">>]}]
        }
    };
get(ai_rule, 150852) ->
    {ok, 
        #npc_ai_rule{
            id = 150852
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,201110,1}]
            ,action = [{suit_tar,skill,835803},{self,talk,[<<"死定！">>]}]
        }
    };
get(ai_rule, 150853) ->
    {ok, 
        #npc_ai_rule{
            id = 150853
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,8,1},{combat,round,<<"<=">>,13,1}]
            ,action = [{opp_side,skill,835802},{self,talk,[<<"标记完毕！">>]}]
        }
    };
get(ai_rule, 150854) ->
    {ok, 
        #npc_ai_rule{
            id = 150854
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,201110,1}]
            ,action = [{suit_tar,skill,835803},{self,talk,[<<"强力一击！">>]}]
        }
    };
get(ai_rule, 150855) ->
    {ok, 
        #npc_ai_rule{
            id = 150855
            ,type = 0
            ,repeat = 0
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,14,1}]
            ,action = [{opp_side,skill,835802},{self,talk,[<<"看到这个呆货了没有，一会给你好看哦">>]}]
        }
    };
get(ai_rule, 150856) ->
    {ok, 
        #npc_ai_rule{
            id = 150856
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,201110,1}]
            ,action = [{suit_tar,skill,835803},{self,talk,[<<"真是完美的弧线">>]}]
        }
    };
get(ai_rule, 150857) ->
    {ok, 
        #npc_ai_rule{
            id = 150857
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835804},{self,talk,[<<"啊，这箭射得真没准头">>]}]
        }
    };
get(ai_rule, 150858) ->
    {ok, 
        #npc_ai_rule{
            id = 150858
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835801}]
        }
    };
get(ai_rule, 150859) ->
    {ok, 
        #npc_ai_rule{
            id = 150859
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835800}]
        }
    };
get(ai_rule, 150901) ->
    {ok, 
        #npc_ai_rule{
            id = 150901
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{self,buff,<<"not_in">>,209030,1}]
            ,action = [{self,skill,835851},{self,talk,[<<"不稳定魔导弹准备就绪！希望这次不会搞砸">>]}]
        }
    };
get(ai_rule, 150902) ->
    {ok, 
        #npc_ai_rule{
            id = 150902
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{self,buff,<<"include">>,209030,1}]
            ,action = [{opp_side,skill,835852},{self,talk,[<<"绝望吧！魔导弹！">>]}]
        }
    };
get(ai_rule, 150903) ->
    {ok, 
        #npc_ai_rule{
            id = 150903
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,buff,<<"include">>,209030,1}]
            ,action = [{self,skill,835853},{self,talk,[<<"糟糕！失控了！">>]}]
        }
    };
get(ai_rule, 150900) ->
    {ok, 
        #npc_ai_rule{
            id = 150900
            ,type = 0
            ,repeat = 1
            ,prob = 10
            ,condition = [{opp_side,buff,<<"not_in">>,200090,1}]
            ,action = [{suit_tar,skill,835854},{self,talk,[<<"封印你的暴怒与潜在能力！">>]}]
        }
    };
get(ai_rule, 150904) ->
    {ok, 
        #npc_ai_rule{
            id = 150904
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,5,1},{self,buff,<<"not_in">>,101011,1}]
            ,action = [{opp_side,skill,835855},{self,talk,[<<"春天种下一颗种子，桀桀桀桀……">>]}]
        }
    };
get(ai_rule, 150905) ->
    {ok, 
        #npc_ai_rule{
            id = 150905
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835850}]
        }
    };
get(ai_rule, 150950) ->
    {ok, 
        #npc_ai_rule{
            id = 150950
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,835903},{self,talk,[<<"啊，静心聆听这美妙的铃音~">>]}]
        }
    };
get(ai_rule, 150951) ->
    {ok, 
        #npc_ai_rule{
            id = 150951
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,835903},{self,talk,[<<"看来你沉浸其中了，是吗？">>]}]
        }
    };
get(ai_rule, 150952) ->
    {ok, 
        #npc_ai_rule{
            id = 150952
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,835901},{self,talk,[<<"束音成箭！">>]}]
        }
    };
get(ai_rule, 150953) ->
    {ok, 
        #npc_ai_rule{
            id = 150953
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,835901}]
        }
    };
get(ai_rule, 150954) ->
    {ok, 
        #npc_ai_rule{
            id = 150954
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,835904},{self,talk,[<<"声音具有巨大的能量">>]}]
        }
    };
get(ai_rule, 150955) ->
    {ok, 
        #npc_ai_rule{
            id = 150955
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{opp_side,skill,835904},{self,talk,[<<"喜欢我的音乐会吗">>]}]
        }
    };
get(ai_rule, 150956) ->
    {ok, 
        #npc_ai_rule{
            id = 150956
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{opp_side,skill,835902},{self,talk,[<<"演奏接近尾声了">>]}]
        }
    };
get(ai_rule, 150957) ->
    {ok, 
        #npc_ai_rule{
            id = 150957
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,8,1}]
            ,action = [{opp_side,skill,835902},{self,talk,[<<"该让战斗结束了。">>]}]
        }
    };
get(ai_rule, 150958) ->
    {ok, 
        #npc_ai_rule{
            id = 150958
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,835900}]
        }
    };
get(ai_rule, 150959) ->
    {ok, 
        #npc_ai_rule{
            id = 150959
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,835900}]
        }
    };
get(ai_rule, 150960) ->
    {ok, 
        #npc_ai_rule{
            id = 150960
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,835905},{self,talk,[<<"失去视线，你将对声音更敏感！">>]}]
        }
    };
get(ai_rule, 150961) ->
    {ok, 
        #npc_ai_rule{
            id = 150961
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{self_side,skill,835906},{self,talk,[<<"你能做得更好！">>]}]
        }
    };
get(ai_rule, 150962) ->
    {ok, 
        #npc_ai_rule{
            id = 150962
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,835900}]
        }
    };
get(ai_rule, 151000) ->
    {ok, 
        #npc_ai_rule{
            id = 151000
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self_side,skill,835951},{self,talk,[<<"出来吧，我的仆从！">>]}]
        }
    };
get(ai_rule, 151001) ->
    {ok, 
        #npc_ai_rule{
            id = 151001
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{self_side,skill,835952},{self,talk,[<<"出来吧，我的仆从！">>]}]
        }
    };
get(ai_rule, 151002) ->
    {ok, 
        #npc_ai_rule{
            id = 151002
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10693,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,10693,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,835951},{self,talk,[<<"哼哼，幻象可是无穷无尽的。">>]}]
        }
    };
get(ai_rule, 151003) ->
    {ok, 
        #npc_ai_rule{
            id = 151003
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,10723,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,10723,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,835952}]
        }
    };
get(ai_rule, 151004) ->
    {ok, 
        #npc_ai_rule{
            id = 151004
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,835950}]
        }
    };
get(ai_rule, 130001) ->
    {ok, 
        #npc_ai_rule{
            id = 130001
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{self,skill,830004},{self,talk,[<<"好累啊，休息一下吧">>]}]
        }
    };
get(ai_rule, 130002) ->
    {ok, 
        #npc_ai_rule{
            id = 130002
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{self,skill,830004},{self,talk,[<<"准备好挨打了吗">>]}]
        }
    };
get(ai_rule, 130003) ->
    {ok, 
        #npc_ai_rule{
            id = 130003
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,830001},{self,talk,[<<"热身一击！">>]}]
        }
    };
get(ai_rule, 130004) ->
    {ok, 
        #npc_ai_rule{
            id = 130004
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,830002},{self,talk,[<<"我的出手越来越快了">>]}]
        }
    };
get(ai_rule, 130005) ->
    {ok, 
        #npc_ai_rule{
            id = 130005
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,830003},{self,talk,[<<"将你撕裂成千百块！">>]}]
        }
    };
get(ai_rule, 130006) ->
    {ok, 
        #npc_ai_rule{
            id = 130006
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,830001}]
        }
    };
get(ai_rule, 130007) ->
    {ok, 
        #npc_ai_rule{
            id = 130007
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,830002}]
        }
    };
get(ai_rule, 130008) ->
    {ok, 
        #npc_ai_rule{
            id = 130008
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,830003}]
        }
    };
get(ai_rule, 130009) ->
    {ok, 
        #npc_ai_rule{
            id = 130009
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{self,skill,830004}]
        }
    };
get(ai_rule, 130010) ->
    {ok, 
        #npc_ai_rule{
            id = 130010
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{self,skill,830004}]
        }
    };
get(ai_rule, 130011) ->
    {ok, 
        #npc_ai_rule{
            id = 130011
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,830005},{self,talk,[<<"小弟们，有客人上门了！">>]}]
        }
    };
get(ai_rule, 130014) ->
    {ok, 
        #npc_ai_rule{
            id = 130014
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015},{self,talk,[<<"我这可是涂满毒液的利爪！">>]}]
        }
    };
get(ai_rule, 130015) ->
    {ok, 
        #npc_ai_rule{
            id = 130015
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015},{self,talk,[<<"我可是有6个手下呢！">>]}]
        }
    };
get(ai_rule, 130016) ->
    {ok, 
        #npc_ai_rule{
            id = 130016
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830014}]
        }
    };
get(ai_rule, 130017) ->
    {ok, 
        #npc_ai_rule{
            id = 130017
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015}]
        }
    };
get(ai_rule, 130018) ->
    {ok, 
        #npc_ai_rule{
            id = 130018
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,830006},{self,talk,[<<"诶，快过来看玩偶~">>]}]
        }
    };
get(ai_rule, 130021) ->
    {ok, 
        #npc_ai_rule{
            id = 130021
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015},{self,talk,[<<"我这可是涂满毒液的利爪！">>]}]
        }
    };
get(ai_rule, 130022) ->
    {ok, 
        #npc_ai_rule{
            id = 130022
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015},{self,talk,[<<"我可是有6个手下呢！">>]}]
        }
    };
get(ai_rule, 130023) ->
    {ok, 
        #npc_ai_rule{
            id = 130023
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830014}]
        }
    };
get(ai_rule, 130024) ->
    {ok, 
        #npc_ai_rule{
            id = 130024
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015}]
        }
    };
get(ai_rule, 130025) ->
    {ok, 
        #npc_ai_rule{
            id = 130025
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self,skill,830007},{self,talk,[<<"有肉送上门啦。">>]}]
        }
    };
get(ai_rule, 130028) ->
    {ok, 
        #npc_ai_rule{
            id = 130028
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015},{self,talk,[<<"我这可是涂满毒液的利爪！">>]}]
        }
    };
get(ai_rule, 130029) ->
    {ok, 
        #npc_ai_rule{
            id = 130029
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015},{self,talk,[<<"我可是有6个手下呢！">>]}]
        }
    };
get(ai_rule, 130030) ->
    {ok, 
        #npc_ai_rule{
            id = 130030
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830014}]
        }
    };
get(ai_rule, 130031) ->
    {ok, 
        #npc_ai_rule{
            id = 130031
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830015}]
        }
    };
get(ai_rule, 130032) ->
    {ok, 
        #npc_ai_rule{
            id = 130032
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,11354,1}]
            ,action = [{suit_tar,skill,830018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 130156) ->
    {ok, 
        #npc_ai_rule{
            id = 130156
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,11355,1}]
            ,action = [{suit_tar,skill,830018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 130157) ->
    {ok, 
        #npc_ai_rule{
            id = 130157
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,11356,1}]
            ,action = [{suit_tar,skill,830018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 130033) ->
    {ok, 
        #npc_ai_rule{
            id = 130033
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830016},{self,talk,[<<"想以多欺少吗，那你就错了！">>]}]
        }
    };
get(ai_rule, 130035) ->
    {ok, 
        #npc_ai_rule{
            id = 130035
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830016}]
        }
    };
get(ai_rule, 130158) ->
    {ok, 
        #npc_ai_rule{
            id = 130158
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,11354,1}]
            ,action = [{suit_tar,skill,830018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 130159) ->
    {ok, 
        #npc_ai_rule{
            id = 130159
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,11355,1}]
            ,action = [{suit_tar,skill,830018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 130037) ->
    {ok, 
        #npc_ai_rule{
            id = 130037
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,11356,1}]
            ,action = [{suit_tar,skill,830018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 130039) ->
    {ok, 
        #npc_ai_rule{
            id = 130039
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830016},{self,talk,[<<"吃我一记！">>]}]
        }
    };
get(ai_rule, 130040) ->
    {ok, 
        #npc_ai_rule{
            id = 130040
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830016}]
        }
    };
get(ai_rule, 130160) ->
    {ok, 
        #npc_ai_rule{
            id = 130160
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,11354,1}]
            ,action = [{suit_tar,skill,830018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 130161) ->
    {ok, 
        #npc_ai_rule{
            id = 130161
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,11355,1}]
            ,action = [{suit_tar,skill,830018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 130042) ->
    {ok, 
        #npc_ai_rule{
            id = 130042
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1},{self_side,id,<<"=">>,11356,1}]
            ,action = [{suit_tar,skill,830018},{self,talk,[<<"永远追随老大！">>]}]
        }
    };
get(ai_rule, 130043) ->
    {ok, 
        #npc_ai_rule{
            id = 130043
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830016}]
        }
    };
get(ai_rule, 130045) ->
    {ok, 
        #npc_ai_rule{
            id = 130045
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,830019},{self,talk,[<<"啊~你的魔力味道真好~">>]}]
        }
    };
get(ai_rule, 130046) ->
    {ok, 
        #npc_ai_rule{
            id = 130046
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,skill,830022},{self,talk,[<<"我能够将吸收的魔力化作护盾！">>]}]
        }
    };
get(ai_rule, 130047) ->
    {ok, 
        #npc_ai_rule{
            id = 130047
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830020},{self,talk,[<<"我感受到力量涌进我的身体！">>]}]
        }
    };
get(ai_rule, 130048) ->
    {ok, 
        #npc_ai_rule{
            id = 130048
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830020},{self,talk,[<<"抓不住的魔力，就随它去吧。">>]}]
        }
    };
get(ai_rule, 130049) ->
    {ok, 
        #npc_ai_rule{
            id = 130049
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{opp_side,career,<<"=">>,2,1}]
            ,action = [{opp_side,skill,830019},{self,talk,[<<"小朋友，拿稳你的玩具匕首了~">>]}]
        }
    };
get(ai_rule, 130050) ->
    {ok, 
        #npc_ai_rule{
            id = 130050
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{opp_side,career,<<"=">>,5,1}]
            ,action = [{opp_side,skill,830019},{self,talk,[<<"听说你的凌空下劈很厉害……呵呵呵……">>]}]
        }
    };
get(ai_rule, 130051) ->
    {ok, 
        #npc_ai_rule{
            id = 130051
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{opp_side,career,<<"=">>,3,1}]
            ,action = [{opp_side,skill,830019},{self,talk,[<<"你要用法杖敲我吗，好怕哦！">>]}]
        }
    };
get(ai_rule, 130052) ->
    {ok, 
        #npc_ai_rule{
            id = 130052
            ,type = 0
            ,repeat = 1
            ,prob = 18
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830020},{self,talk,[<<"这一点魔力并不能满足我">>]}]
        }
    };
get(ai_rule, 130053) ->
    {ok, 
        #npc_ai_rule{
            id = 130053
            ,type = 0
            ,repeat = 1
            ,prob = 36
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830021},{self,talk,[<<"我想要更多……更多……">>]}]
        }
    };
get(ai_rule, 130054) ->
    {ok, 
        #npc_ai_rule{
            id = 130054
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830019}]
        }
    };
get(ai_rule, 130055) ->
    {ok, 
        #npc_ai_rule{
            id = 130055
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,830023},{self,talk,[<<"安静下来。">>]}]
        }
    };
get(ai_rule, 130056) ->
    {ok, 
        #npc_ai_rule{
            id = 130056
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,830023},{self,talk,[<<"安静下来。">>]}]
        }
    };
get(ai_rule, 130057) ->
    {ok, 
        #npc_ai_rule{
            id = 130057
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830025}]
        }
    };
get(ai_rule, 130058) ->
    {ok, 
        #npc_ai_rule{
            id = 130058
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830024}]
        }
    };
get(ai_rule, 130059) ->
    {ok, 
        #npc_ai_rule{
            id = 130059
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,830026},{self,talk,[<<"强大的神源之力让我生命力更澎湃！">>]}]
        }
    };
get(ai_rule, 130060) ->
    {ok, 
        #npc_ai_rule{
            id = 130060
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,830026},{self,talk,[<<"你也太天真了~">>]}]
        }
    };
get(ai_rule, 130061) ->
    {ok, 
        #npc_ai_rule{
            id = 130061
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,830026},{self,talk,[<<"再砍我一刀试试">>]}]
        }
    };
get(ai_rule, 130062) ->
    {ok, 
        #npc_ai_rule{
            id = 130062
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,830026},{self,talk,[<<"就跟给我搔痒一样~">>]}]
        }
    };
get(ai_rule, 130063) ->
    {ok, 
        #npc_ai_rule{
            id = 130063
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,830026},{self,talk,[<<"这就是你的全部实力了吗？">>]}]
        }
    };
get(ai_rule, 130064) ->
    {ok, 
        #npc_ai_rule{
            id = 130064
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,830026},{self,talk,[<<"我还不想死啦">>]}]
        }
    };
get(ai_rule, 130065) ->
    {ok, 
        #npc_ai_rule{
            id = 130065
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,830026},{self,talk,[<<"我都懒得跟你打了~">>]}]
        }
    };
get(ai_rule, 130066) ->
    {ok, 
        #npc_ai_rule{
            id = 130066
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,830026},{self,talk,[<<"一不小心又治疗了一点~">>]}]
        }
    };
get(ai_rule, 130067) ->
    {ok, 
        #npc_ai_rule{
            id = 130067
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,830026},{self,talk,[<<"趁我心情好你快点跑吧！">>]}]
        }
    };
get(ai_rule, 130068) ->
    {ok, 
        #npc_ai_rule{
            id = 130068
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830027}]
        }
    };
get(ai_rule, 130069) ->
    {ok, 
        #npc_ai_rule{
            id = 130069
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{self,skill,830028},{self,talk,[<<"我的皮肤每过一段时间就会变得更坚韧！">>]}]
        }
    };
get(ai_rule, 130120) ->
    {ok, 
        #npc_ai_rule{
            id = 130120
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{self,skill,830049},{self,talk,[<<"我变得跟岩石一般硬">>]}]
        }
    };
get(ai_rule, 130121) ->
    {ok, 
        #npc_ai_rule{
            id = 130121
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,12,1}]
            ,action = [{self,skill,830050},{self,talk,[<<"尽管打过来吧！">>]}]
        }
    };
get(ai_rule, 130122) ->
    {ok, 
        #npc_ai_rule{
            id = 130122
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,17,1}]
            ,action = [{self,skill,830051},{self,talk,[<<"你的攻击丝毫没有作用！">>]}]
        }
    };
get(ai_rule, 130070) ->
    {ok, 
        #npc_ai_rule{
            id = 130070
            ,type = 0
            ,repeat = 0
            ,prob = 10
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{opp_side,skill,830031},{self,talk,[<<"人数跟战斗结果没有联系！">>]}]
        }
    };
get(ai_rule, 130071) ->
    {ok, 
        #npc_ai_rule{
            id = 130071
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,2,1}]
            ,action = [{opp_side,skill,830030}]
        }
    };
get(ai_rule, 130072) ->
    {ok, 
        #npc_ai_rule{
            id = 130072
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830029}]
        }
    };
get(ai_rule, 130079) ->
    {ok, 
        #npc_ai_rule{
            id = 130079
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11366,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,11588,1},{suit_tar,hp,<<"<=">>,0,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1},{self,buff,<<"not_in">>,200060,1}]
            ,action = [{self,skill,830034},{self,talk,[<<"谢谢你，我要藏起来了！">>]}]
        }
    };
get(ai_rule, 130073) ->
    {ok, 
        #npc_ai_rule{
            id = 130073
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830040},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 130074) ->
    {ok, 
        #npc_ai_rule{
            id = 130074
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830038},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 130075) ->
    {ok, 
        #npc_ai_rule{
            id = 130075
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830039},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 130076) ->
    {ok, 
        #npc_ai_rule{
            id = 130076
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830032},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 130077) ->
    {ok, 
        #npc_ai_rule{
            id = 130077
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,65,1}]
            ,action = [{opp_side,skill,830033},{self,talk,[<<"你为什么要伤害我……">>]}]
        }
    };
get(ai_rule, 130097) ->
    {ok, 
        #npc_ai_rule{
            id = 130097
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,65,1}]
            ,action = [{opp_side,skill,830033}]
        }
    };
get(ai_rule, 130078) ->
    {ok, 
        #npc_ai_rule{
            id = 130078
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033},{self,talk,[<<"谢谢你，让我一起来打倒他们！">>]}]
        }
    };
get(ai_rule, 130080) ->
    {ok, 
        #npc_ai_rule{
            id = 130080
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033}]
        }
    };
get(ai_rule, 130087) ->
    {ok, 
        #npc_ai_rule{
            id = 130087
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11367,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,11589,1},{suit_tar,hp,<<"<=">>,0,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1},{self,buff,<<"not_in">>,200060,1}]
            ,action = [{self,skill,830034},{self,talk,[<<"谢谢你，我要藏起来了！">>]}]
        }
    };
get(ai_rule, 130081) ->
    {ok, 
        #npc_ai_rule{
            id = 130081
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830040},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 130082) ->
    {ok, 
        #npc_ai_rule{
            id = 130082
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830038},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 130083) ->
    {ok, 
        #npc_ai_rule{
            id = 130083
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830039},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 130084) ->
    {ok, 
        #npc_ai_rule{
            id = 130084
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830032},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 130085) ->
    {ok, 
        #npc_ai_rule{
            id = 130085
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,65,1}]
            ,action = [{opp_side,skill,830033},{self,talk,[<<"你为什么要伤害我……">>]}]
        }
    };
get(ai_rule, 130098) ->
    {ok, 
        #npc_ai_rule{
            id = 130098
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,65,1}]
            ,action = [{opp_side,skill,830033}]
        }
    };
get(ai_rule, 130086) ->
    {ok, 
        #npc_ai_rule{
            id = 130086
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033},{self,talk,[<<"谢谢你，让我一起来打倒他们！">>]}]
        }
    };
get(ai_rule, 130088) ->
    {ok, 
        #npc_ai_rule{
            id = 130088
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033}]
        }
    };
get(ai_rule, 130095) ->
    {ok, 
        #npc_ai_rule{
            id = 130095
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11368,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,11590,1},{suit_tar,hp,<<"<=">>,0,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1},{self,buff,<<"not_in">>,200060,1}]
            ,action = [{self,skill,830034},{self,talk,[<<"谢谢你，我要藏起来了！">>]}]
        }
    };
get(ai_rule, 130089) ->
    {ok, 
        #npc_ai_rule{
            id = 130089
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830040},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 130090) ->
    {ok, 
        #npc_ai_rule{
            id = 130090
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830038},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 130091) ->
    {ok, 
        #npc_ai_rule{
            id = 130091
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830039},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 130092) ->
    {ok, 
        #npc_ai_rule{
            id = 130092
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830032},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 130093) ->
    {ok, 
        #npc_ai_rule{
            id = 130093
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,65,1}]
            ,action = [{opp_side,skill,830033},{self,talk,[<<"你为什么要伤害我……">>]}]
        }
    };
get(ai_rule, 130099) ->
    {ok, 
        #npc_ai_rule{
            id = 130099
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self,hp,<<"<=">>,65,1}]
            ,action = [{opp_side,skill,830033}]
        }
    };
get(ai_rule, 130094) ->
    {ok, 
        #npc_ai_rule{
            id = 130094
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033},{self,talk,[<<"谢谢你，让我一起来打倒他们！">>]}]
        }
    };
get(ai_rule, 130096) ->
    {ok, 
        #npc_ai_rule{
            id = 130096
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{self_side,buff,<<"not_in">>,101230,1}]
            ,action = [{suit_tar,skill,830033}]
        }
    };
get(ai_rule, 130100) ->
    {ok, 
        #npc_ai_rule{
            id = 130100
            ,type = 0
            ,repeat = 1
            ,prob = 15
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830036},{self,talk,[<<"你再敢多嘴看看！">>]}]
        }
    };
get(ai_rule, 130101) ->
    {ok, 
        #npc_ai_rule{
            id = 130101
            ,type = 0
            ,repeat = 1
            ,prob = 15
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830037},{self,talk,[<<"等我收拾掉这些家伙再来教训你！">>]}]
        }
    };
get(ai_rule, 130102) ->
    {ok, 
        #npc_ai_rule{
            id = 130102
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830035}]
        }
    };
get(ai_rule, 130103) ->
    {ok, 
        #npc_ai_rule{
            id = 130103
            ,type = 0
            ,repeat = 1
            ,prob = 36
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830021}]
        }
    };
get(ai_rule, 130104) ->
    {ok, 
        #npc_ai_rule{
            id = 130104
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830019}]
        }
    };
get(ai_rule, 130148) ->
    {ok, 
        #npc_ai_rule{
            id = 130148
            ,type = 0
            ,repeat = 1
            ,prob = 75
            ,condition = [{opp_side,career,<<"=">>,2,1},{suit_tar,buff,<<"not_in">>,209030,1}]
            ,action = [{opp_side,skill,830041},{self,talk,[<<"陷入无尽的毒液泥潭中吧">>]}]
        }
    };
get(ai_rule, 130149) ->
    {ok, 
        #npc_ai_rule{
            id = 130149
            ,type = 0
            ,repeat = 1
            ,prob = 75
            ,condition = [{opp_side,career,<<"=">>,5,1},{suit_tar,buff,<<"not_in">>,209030,1}]
            ,action = [{opp_side,skill,830041},{self,talk,[<<"陷入无尽的毒液泥潭中吧">>]}]
        }
    };
get(ai_rule, 130150) ->
    {ok, 
        #npc_ai_rule{
            id = 130150
            ,type = 0
            ,repeat = 1
            ,prob = 75
            ,condition = [{opp_side,career,<<"=">>,3,1},{suit_tar,buff,<<"not_in">>,209030,1}]
            ,action = [{opp_side,skill,830041},{self,talk,[<<"陷入无尽的毒液泥潭中吧">>]}]
        }
    };
get(ai_rule, 130151) ->
    {ok, 
        #npc_ai_rule{
            id = 130151
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"include">>,209030,1}]
            ,action = [{opp_side,skill,830044},{self,talk,[<<"浸泡着毒素的血液最鲜美了！">>]}]
        }
    };
get(ai_rule, 130152) ->
    {ok, 
        #npc_ai_rule{
            id = 130152
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830043},{self,talk,[<<"让你身上的毒素在下次爆发吧！">>]}]
        }
    };
get(ai_rule, 130153) ->
    {ok, 
        #npc_ai_rule{
            id = 130153
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,209030,1}]
            ,action = [{opp_side,skill,830042},{self,talk,[<<"毒液让你变得脆弱无比！">>]}]
        }
    };
get(ai_rule, 130154) ->
    {ok, 
        #npc_ai_rule{
            id = 130154
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{opp_side,buff,<<"include">>,209030,1}]
            ,action = [{opp_side,skill,830042}]
        }
    };
get(ai_rule, 130155) ->
    {ok, 
        #npc_ai_rule{
            id = 130155
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830045}]
        }
    };
get(ai_rule, 130200) ->
    {ok, 
        #npc_ai_rule{
            id = 130200
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,11483,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,830046},{self,talk,[<<"勇敢战斗吧">>]}]
        }
    };
get(ai_rule, 130201) ->
    {ok, 
        #npc_ai_rule{
            id = 130201
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,11594,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,830046},{self,talk,[<<"谁也无法刺穿这屏障">>]}]
        }
    };
get(ai_rule, 130202) ->
    {ok, 
        #npc_ai_rule{
            id = 130202
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830048}]
        }
    };
get(ai_rule, 130203) ->
    {ok, 
        #npc_ai_rule{
            id = 130203
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1}]
            ,action = [{suit_tar,skill,830047},{self,talk,[<<"胆小鬼，来打我呀">>]}]
        }
    };
get(ai_rule, 130204) ->
    {ok, 
        #npc_ai_rule{
            id = 130204
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1}]
            ,action = [{suit_tar,skill,830047},{self,talk,[<<"是不是吓得发抖了">>]}]
        }
    };
get(ai_rule, 130214) ->
    {ok, 
        #npc_ai_rule{
            id = 130214
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830048}]
        }
    };
get(ai_rule, 130205) ->
    {ok, 
        #npc_ai_rule{
            id = 130205
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1},{opp_side,career,<<"=">>,2,1}]
            ,action = [{suit_tar,skill,830047},{self,talk,[<<"你这把小匕首能把纸刺穿吗？">>]}]
        }
    };
get(ai_rule, 130206) ->
    {ok, 
        #npc_ai_rule{
            id = 130206
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1},{opp_side,career,<<"=">>,5,1}]
            ,action = [{suit_tar,skill,830047},{self,talk,[<<"在我眼里你的盾也不过跟纸糊的一样~">>]}]
        }
    };
get(ai_rule, 130207) ->
    {ok, 
        #npc_ai_rule{
            id = 130207
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1},{opp_side,career,<<"=">>,3,1}]
            ,action = [{suit_tar,skill,830047},{self,talk,[<<"用你这破法杖变个火球出来看看？">>]}]
        }
    };
get(ai_rule, 130208) ->
    {ok, 
        #npc_ai_rule{
            id = 130208
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{opp_side,buff,<<"not_in">>,200080,1}]
            ,action = [{suit_tar,skill,830047}]
        }
    };
get(ai_rule, 130209) ->
    {ok, 
        #npc_ai_rule{
            id = 130209
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830048}]
        }
    };
get(ai_rule, 130210) ->
    {ok, 
        #npc_ai_rule{
            id = 130210
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,11484,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,830046},{self,talk,[<<"勇敢战斗吧">>]}]
        }
    };
get(ai_rule, 130211) ->
    {ok, 
        #npc_ai_rule{
            id = 130211
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,11595,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,830046},{self,talk,[<<"谁也无法刺穿这屏障">>]}]
        }
    };
get(ai_rule, 130212) ->
    {ok, 
        #npc_ai_rule{
            id = 130212
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,11485,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,830046},{self,talk,[<<"勇敢战斗吧">>]}]
        }
    };
get(ai_rule, 130213) ->
    {ok, 
        #npc_ai_rule{
            id = 130213
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{self_side,id,<<"=">>,11596,1},{suit_tar,buff,<<"not_in">>,101400,1}]
            ,action = [{suit_tar,skill,830046},{self,talk,[<<"谁也无法刺穿这屏障">>]}]
        }
    };
get(ai_rule, 130250) ->
    {ok, 
        #npc_ai_rule{
            id = 130250
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,18,1}]
            ,action = [{self,skill,830100},{self,talk,[<<"只要黑暗尚在，我便永生不灭。">>]}]
        }
    };
get(ai_rule, 130251) ->
    {ok, 
        #npc_ai_rule{
            id = 130251
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,hp,<<"<=">>,30,1}]
            ,action = [{opp_side,skill,830103},{self,talk,[<<"有机可乘！">>]}]
        }
    };
get(ai_rule, 130252) ->
    {ok, 
        #npc_ai_rule{
            id = 130252
            ,type = 0
            ,repeat = 0
            ,prob = 45
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830101},{self,talk,[<<"寄宿在心底的阴影，便是我的力量。">>]}]
        }
    };
get(ai_rule, 130253) ->
    {ok, 
        #npc_ai_rule{
            id = 130253
            ,type = 0
            ,repeat = 1
            ,prob = 15
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830102},{self,talk,[<<"让我看到你绝望的样子，或许就会不舍得伤害你，哈哈哈！">>]}]
        }
    };
get(ai_rule, 130254) ->
    {ok, 
        #npc_ai_rule{
            id = 130254
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830103}]
        }
    };
get(ai_rule, 130255) ->
    {ok, 
        #npc_ai_rule{
            id = 130255
            ,type = 0
            ,repeat = 0
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830103},{self,talk,[<<"还想活着回去吗？哼哼，太晚了！">>]}]
        }
    };
get(ai_rule, 130256) ->
    {ok, 
        #npc_ai_rule{
            id = 130256
            ,type = 0
            ,repeat = 0
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830103},{self,talk,[<<"自从黑暗诞生之际，我已存在……">>]}]
        }
    };
get(ai_rule, 130257) ->
    {ok, 
        #npc_ai_rule{
            id = 130257
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830104}]
        }
    };
get(ai_rule, 130300) ->
    {ok, 
        #npc_ai_rule{
            id = 130300
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod7">>,2,1}]
            ,action = [{opp_side,skill,830154},{self,talk,[<<"雪山不是凡人应该踏足的地方！">>]}]
        }
    };
get(ai_rule, 130301) ->
    {ok, 
        #npc_ai_rule{
            id = 130301
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,830152}]
        }
    };
get(ai_rule, 130302) ->
    {ok, 
        #npc_ai_rule{
            id = 130302
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830151},{self,talk,[<<"还没有吃够教训吗？">>]}]
        }
    };
get(ai_rule, 130303) ->
    {ok, 
        #npc_ai_rule{
            id = 130303
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,830150},{self,talk,[<<"放弃抵抗！">>]}]
        }
    };
get(ai_rule, 130304) ->
    {ok, 
        #npc_ai_rule{
            id = 130304
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830154}]
        }
    };
get(ai_rule, 130305) ->
    {ok, 
        #npc_ai_rule{
            id = 130305
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830151}]
        }
    };
get(ai_rule, 130306) ->
    {ok, 
        #npc_ai_rule{
            id = 130306
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{self_side,skill,830153},{self,talk,[<<"蓄力完成，要开始认真囖！">>]}]
        }
    };
get(ai_rule, 130307) ->
    {ok, 
        #npc_ai_rule{
            id = 130307
            ,type = 0
            ,repeat = 0
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830152}]
        }
    };
get(ai_rule, 130308) ->
    {ok, 
        #npc_ai_rule{
            id = 130308
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830151}]
        }
    };
get(ai_rule, 130309) ->
    {ok, 
        #npc_ai_rule{
            id = 130309
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1},{self_side,buff,<<"not_in">>,104140,1}]
            ,action = [{self_side,skill,830153},{self,talk,[<<"蓄力完成，要开始认真囖！">>]}]
        }
    };
get(ai_rule, 130350) ->
    {ok, 
        #npc_ai_rule{
            id = 130350
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,3,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,buff,<<"not_in">>,202150,1}]
            ,action = [{opp_side,skill,830200},{self,talk,[<<"用这招击溃你的防线！">>]}]
        }
    };
get(ai_rule, 130351) ->
    {ok, 
        #npc_ai_rule{
            id = 130351
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,5,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,buff,<<"not_in">>,201240,1}]
            ,action = [{opp_side,skill,830201},{self,talk,[<<"刺骨的寒冷将瓦解你的盔甲！">>]}]
        }
    };
get(ai_rule, 130352) ->
    {ok, 
        #npc_ai_rule{
            id = 130352
            ,type = 0
            ,repeat = 1
            ,prob = 15
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830204},{self,talk,[<<"我们擅长利用冰雪之力">>]}]
        }
    };
get(ai_rule, 130353) ->
    {ok, 
        #npc_ai_rule{
            id = 130353
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830203}]
        }
    };
get(ai_rule, 130354) ->
    {ok, 
        #npc_ai_rule{
            id = 130354
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830202}]
        }
    };
get(ai_rule, 130355) ->
    {ok, 
        #npc_ai_rule{
            id = 130355
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11500,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,11500,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,830251},{self,talk,[<<"双生冰精，同生共死！">>]}]
        }
    };
get(ai_rule, 130356) ->
    {ok, 
        #npc_ai_rule{
            id = 130356
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11387,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,11387,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,830250},{self,talk,[<<"双生冰精，同生共死！">>]}]
        }
    };
get(ai_rule, 130361) ->
    {ok, 
        #npc_ai_rule{
            id = 130361
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<">">>,40,1},{self,hp,<<"<">>,60,1}]
            ,action = [{opp_side,skill,830256},{self,talk,[<<"血祭开始了">>]}]
        }
    };
get(ai_rule, 130362) ->
    {ok, 
        #npc_ai_rule{
            id = 130362
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,skill,830257},{self,talk,[<<"虽然冰精无法习得回复术">>]}]
        }
    };
get(ai_rule, 130363) ->
    {ok, 
        #npc_ai_rule{
            id = 130363
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830262}]
        }
    };
get(ai_rule, 130364) ->
    {ok, 
        #npc_ai_rule{
            id = 130364
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11387,1},{suit_tar,hp,<<">">>,40,1},{suit_tar,hp,<<"<">>,60,1}]
            ,action = [{self_side,skill,830263},{self,talk,[<<"我已准备就绪">>]}]
        }
    };
get(ai_rule, 130365) ->
    {ok, 
        #npc_ai_rule{
            id = 130365
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11388,1},{suit_tar,hp,<<">">>,40,1},{suit_tar,hp,<<"<">>,80000,1}]
            ,action = [{self_side,skill,830263},{self,talk,[<<"我已准备就绪">>]}]
        }
    };
get(ai_rule, 130366) ->
    {ok, 
        #npc_ai_rule{
            id = 130366
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11389,1},{suit_tar,hp,<<">">>,40,1},{suit_tar,hp,<<"<">>,80000,1}]
            ,action = [{self_side,skill,830263},{self,talk,[<<"我已准备就绪">>]}]
        }
    };
get(ai_rule, 130367) ->
    {ok, 
        #npc_ai_rule{
            id = 130367
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{self,skill,830258},{self,talk,[<<"但是通过这种方式，可以共享生命！">>]}]
        }
    };
get(ai_rule, 130368) ->
    {ok, 
        #npc_ai_rule{
            id = 130368
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,0,1}]
            ,action = [{opp_side,skill,830259},{self,talk,[<<"没想到你能逼我使出这招。">>]}]
        }
    };
get(ai_rule, 130369) ->
    {ok, 
        #npc_ai_rule{
            id = 130369
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,830260},{self,talk,[<<"窒息于严寒之中是件幸福的事情">>]}]
        }
    };
get(ai_rule, 130370) ->
    {ok, 
        #npc_ai_rule{
            id = 130370
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830261}]
        }
    };
get(ai_rule, 130371) ->
    {ok, 
        #npc_ai_rule{
            id = 130371
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830262}]
        }
    };
get(ai_rule, 130400) ->
    {ok, 
        #npc_ai_rule{
            id = 130400
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1}]
            ,action = [{opp_side,skill,830550},{self,talk,[<<"我一直生活在雪山地带，不希望外人来打扰">>]}]
        }
    };
get(ai_rule, 130401) ->
    {ok, 
        #npc_ai_rule{
            id = 130401
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,830551},{self,talk,[<<"雪山原本就是巨人与其他生物的住所，人类为何要侵略进来？">>]}]
        }
    };
get(ai_rule, 130402) ->
    {ok, 
        #npc_ai_rule{
            id = 130402
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1}]
            ,action = [{opp_side,skill,830552},{self,talk,[<<"你狭隘的思想真烦人，我甚至连你吟唱技能都不想听">>]}]
        }
    };
get(ai_rule, 130403) ->
    {ok, 
        #npc_ai_rule{
            id = 130403
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,0,1}]
            ,action = [{self_side,skill,830553},{self,talk,[<<"我们雪山一族不会轻易死去！">>]}]
        }
    };
get(ai_rule, 130404) ->
    {ok, 
        #npc_ai_rule{
            id = 130404
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830556}]
        }
    };
get(ai_rule, 130405) ->
    {ok, 
        #npc_ai_rule{
            id = 130405
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,15,1}]
            ,action = [{self_side,skill,830557},{self,talk,[<<"我终于把獠牙磨锋利了，嘿嘿嘿">>]}]
        }
    };
get(ai_rule, 130450) ->
    {ok, 
        #npc_ai_rule{
            id = 130450
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,101400,1},{opp_side,career,<<"=">>,5,1}]
            ,action = [{suit_tar,skill,830350},{self,talk,[<<"想嘲讽我的话，尽管试试看？">>]}]
        }
    };
get(ai_rule, 130451) ->
    {ok, 
        #npc_ai_rule{
            id = 130451
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,buff,<<"include">>,202140,1},{opp_side,career,<<"=">>,5,1}]
            ,action = [{suit_tar,skill,830350},{self,talk,[<<"我不会感到恐惧！">>]}]
        }
    };
get(ai_rule, 130452) ->
    {ok, 
        #npc_ai_rule{
            id = 130452
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,buff,<<"include">>,201101,1},{opp_side,career,<<"=">>,2,1}]
            ,action = [{suit_tar,skill,830350},{self,talk,[<<"我的眼睛不会被你的小伎俩弄瞎！">>]}]
        }
    };
get(ai_rule, 130453) ->
    {ok, 
        #npc_ai_rule{
            id = 130453
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,buff,<<"include">>,201110,1},{opp_side,career,<<"=">>,3,1}]
            ,action = [{suit_tar,skill,830350},{self,talk,[<<"真正虚弱的人，是你！">>]}]
        }
    };
get(ai_rule, 130454) ->
    {ok, 
        #npc_ai_rule{
            id = 130454
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,200060,1}]
            ,action = [{suit_tar,skill,830351},{self,talk,[<<"不在沉默中爆发，就在沉默中消亡！">>]}]
        }
    };
get(ai_rule, 130455) ->
    {ok, 
        #npc_ai_rule{
            id = 130455
            ,type = 0
            ,repeat = 1
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830352},{self,talk,[<<"倒在我的铁爪之下吧！">>]}]
        }
    };
get(ai_rule, 130456) ->
    {ok, 
        #npc_ai_rule{
            id = 130456
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830353}]
        }
    };
get(ai_rule, 130500) ->
    {ok, 
        #npc_ai_rule{
            id = 130500
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830401},{self,talk,[<<"不要惊讶，我出手速度就是这么快！">>]}]
        }
    };
get(ai_rule, 130501) ->
    {ok, 
        #npc_ai_rule{
            id = 130501
            ,type = 0
            ,repeat = 0
            ,prob = 70
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830401},{self,talk,[<<"你看见我的影子了吗？">>]}]
        }
    };
get(ai_rule, 130502) ->
    {ok, 
        #npc_ai_rule{
            id = 130502
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830401},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 130503) ->
    {ok, 
        #npc_ai_rule{
            id = 130503
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830402},{self,talk,[<<"冰雪连击！">>]}]
        }
    };
get(ai_rule, 130504) ->
    {ok, 
        #npc_ai_rule{
            id = 130504
            ,type = 0
            ,repeat = 0
            ,prob = 70
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830402},{self,talk,[<<"你能抓住我吗？">>]}]
        }
    };
get(ai_rule, 130505) ->
    {ok, 
        #npc_ai_rule{
            id = 130505
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830402},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 130506) ->
    {ok, 
        #npc_ai_rule{
            id = 130506
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830400},{self,talk,[<<"大自然的力量才是最强大的">>]}]
        }
    };
get(ai_rule, 130507) ->
    {ok, 
        #npc_ai_rule{
            id = 130507
            ,type = 0
            ,repeat = 0
            ,prob = 70
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830400},{self,talk,[<<"湮灭在这漫天的呼啸当中吧">>]}]
        }
    };
get(ai_rule, 130508) ->
    {ok, 
        #npc_ai_rule{
            id = 130508
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830400}]
        }
    };
get(ai_rule, 130509) ->
    {ok, 
        #npc_ai_rule{
            id = 130509
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830403}]
        }
    };
get(ai_rule, 130550) ->
    {ok, 
        #npc_ai_rule{
            id = 130550
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830456},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 130551) ->
    {ok, 
        #npc_ai_rule{
            id = 130551
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830457},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 130552) ->
    {ok, 
        #npc_ai_rule{
            id = 130552
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830458},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 130553) ->
    {ok, 
        #npc_ai_rule{
            id = 130553
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830450},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 130554) ->
    {ok, 
        #npc_ai_rule{
            id = 130554
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"听说人类很好骗，原来是真的！">>]}]
        }
    };
get(ai_rule, 130555) ->
    {ok, 
        #npc_ai_rule{
            id = 130555
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"我以为我们能做朋友的……如果你不是丑陋的人类的话！">>]}]
        }
    };
get(ai_rule, 130556) ->
    {ok, 
        #npc_ai_rule{
            id = 130556
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453}]
        }
    };
get(ai_rule, 130557) ->
    {ok, 
        #npc_ai_rule{
            id = 130557
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830456},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 130558) ->
    {ok, 
        #npc_ai_rule{
            id = 130558
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830457},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 130559) ->
    {ok, 
        #npc_ai_rule{
            id = 130559
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830458},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 130560) ->
    {ok, 
        #npc_ai_rule{
            id = 130560
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,4,1}]
            ,action = [{self,skill,830450},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 130561) ->
    {ok, 
        #npc_ai_rule{
            id = 130561
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"听说人类很好骗，原来是真的！">>]}]
        }
    };
get(ai_rule, 130562) ->
    {ok, 
        #npc_ai_rule{
            id = 130562
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"我以为我们能做朋友的……如果你不是丑陋的人类的话！">>]}]
        }
    };
get(ai_rule, 130563) ->
    {ok, 
        #npc_ai_rule{
            id = 130563
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453}]
        }
    };
get(ai_rule, 130564) ->
    {ok, 
        #npc_ai_rule{
            id = 130564
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830457},{self,talk,[<<"呜呜呜……我是被抓来的，请不要打我……">>]}]
        }
    };
get(ai_rule, 130565) ->
    {ok, 
        #npc_ai_rule{
            id = 130565
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830456},{self,talk,[<<"这两个可恶的家伙，每天都欺负我">>]}]
        }
    };
get(ai_rule, 130566) ->
    {ok, 
        #npc_ai_rule{
            id = 130566
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830458},{self,talk,[<<"其实我一直希望逃走……只是没有人帮我">>]}]
        }
    };
get(ai_rule, 130567) ->
    {ok, 
        #npc_ai_rule{
            id = 130567
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"<=">>,3,1}]
            ,action = [{self,skill,830450},{self,talk,[<<"如果你肯帮我，我也愿意帮助你打跑他们……">>]}]
        }
    };
get(ai_rule, 130568) ->
    {ok, 
        #npc_ai_rule{
            id = 130568
            ,type = 0
            ,repeat = 0
            ,prob = 40
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{self,ai_level,2}]
        }
    };
get(ai_rule, 130569) ->
    {ok, 
        #npc_ai_rule{
            id = 130569
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11401,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,11625,1},{suit_tar,hp,<<"<=">>,0,1}]
            ,action = [{self,skill,830452},{self,talk,[<<"谢谢你，我要逃跑了！">>]}]
        }
    };
get(ai_rule, 130570) ->
    {ok, 
        #npc_ai_rule{
            id = 130570
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{self,hp,<<"<=">>,75,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"如果你不打我，我们还能做朋友！">>]}]
        }
    };
get(ai_rule, 130571) ->
    {ok, 
        #npc_ai_rule{
            id = 130571
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{self,hp,<<"<=">>,75,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"原本我还以为我们能做朋友的……">>]}]
        }
    };
get(ai_rule, 130572) ->
    {ok, 
        #npc_ai_rule{
            id = 130572
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{self_side,buff,<<"not_in">>,104140,1}]
            ,action = [{suit_tar,skill,830453},{self,talk,[<<"我们水精原本都是被俘虏的，但是有些开始为虎作伥了……">>]}]
        }
    };
get(ai_rule, 130573) ->
    {ok, 
        #npc_ai_rule{
            id = 130573
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1},{self_side,buff,<<"not_in">>,104140,1}]
            ,action = [{suit_tar,skill,830453}]
        }
    };
get(ai_rule, 130574) ->
    {ok, 
        #npc_ai_rule{
            id = 130574
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"听说人类很好骗，原来是真的！">>]}]
        }
    };
get(ai_rule, 130575) ->
    {ok, 
        #npc_ai_rule{
            id = 130575
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453},{self,talk,[<<"我以为我们能做朋友的……如果你不是丑陋的人类的话！">>]}]
        }
    };
get(ai_rule, 130576) ->
    {ok, 
        #npc_ai_rule{
            id = 130576
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830453}]
        }
    };
get(ai_rule, 130577) ->
    {ok, 
        #npc_ai_rule{
            id = 130577
            ,type = 0
            ,repeat = 1
            ,prob = 15
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830454},{self,talk,[<<"你再敢多嘴看看！">>]}]
        }
    };
get(ai_rule, 130578) ->
    {ok, 
        #npc_ai_rule{
            id = 130578
            ,type = 0
            ,repeat = 1
            ,prob = 15
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830455},{self,talk,[<<"等我收拾掉这些家伙再来教训你！">>]}]
        }
    };
get(ai_rule, 130579) ->
    {ok, 
        #npc_ai_rule{
            id = 130579
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830453}]
        }
    };
get(ai_rule, 130600) ->
    {ok, 
        #npc_ai_rule{
            id = 130600
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self_side,skill,830500},{self,talk,[<<"冰原狼，撕碎这个迷路的人类！">>]}]
        }
    };
get(ai_rule, 130602) ->
    {ok, 
        #npc_ai_rule{
            id = 130602
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11518,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,830505},{self,talk,[<<"铁甲巨兔，帮我抵住攻击！">>]}]
        }
    };
get(ai_rule, 130604) ->
    {ok, 
        #npc_ai_rule{
            id = 130604
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11518,1},{suit_tar,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,104140,1}]
            ,action = [{suit_tar,skill,830502},{self,talk,[<<"强化利爪！">>]}]
        }
    };
get(ai_rule, 130605) ->
    {ok, 
        #npc_ai_rule{
            id = 130605
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11518,1},{suit_tar,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,100390,1}]
            ,action = [{suit_tar,skill,830504},{self,talk,[<<"血液贪婪！">>]}]
        }
    };
get(ai_rule, 130609) ->
    {ok, 
        #npc_ai_rule{
            id = 130609
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11629,1},{suit_tar,hp,<<"<=">>,60,1}]
            ,action = [{suit_tar,skill,830509},{self,talk,[<<"这是最强的壁垒">>]}]
        }
    };
get(ai_rule, 130612) ->
    {ok, 
        #npc_ai_rule{
            id = 130612
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11518,1},{suit_tar,hp,<<">">>,0,0},{self_side,id,<<"=">>,11629,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{opp_side,skill,830510},{self,talk,[<<"你竟敢伤害我的宠物，你成功惹怒我了，人类！">>]}]
        }
    };
get(ai_rule, 130601) ->
    {ok, 
        #npc_ai_rule{
            id = 130601
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{self_side,skill,830501},{self,talk,[<<"冰原狼，撕碎这个迷路的人类！">>]}]
        }
    };
get(ai_rule, 130603) ->
    {ok, 
        #npc_ai_rule{
            id = 130603
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11519,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,830506},{self,talk,[<<"铁甲巨兔，帮我抵住攻击！">>]}]
        }
    };
get(ai_rule, 130606) ->
    {ok, 
        #npc_ai_rule{
            id = 130606
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11519,1},{suit_tar,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,104140,1}]
            ,action = [{suit_tar,skill,830502},{self,talk,[<<"强化利爪！">>]}]
        }
    };
get(ai_rule, 130607) ->
    {ok, 
        #npc_ai_rule{
            id = 130607
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11519,1},{suit_tar,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,100120,1}]
            ,action = [{suit_tar,skill,830503},{self,talk,[<<"狂暴化吧冰原狼！">>]}]
        }
    };
get(ai_rule, 130608) ->
    {ok, 
        #npc_ai_rule{
            id = 130608
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11519,1},{suit_tar,hp,<<">">>,0,1},{suit_tar,buff,<<"not_in">>,100390,1}]
            ,action = [{suit_tar,skill,830504},{self,talk,[<<"血液贪婪！">>]}]
        }
    };
get(ai_rule, 130610) ->
    {ok, 
        #npc_ai_rule{
            id = 130610
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11630,1},{suit_tar,hp,<<"<=">>,60,1}]
            ,action = [{suit_tar,skill,830509},{self,talk,[<<"这是最强的壁垒！">>]}]
        }
    };
get(ai_rule, 130611) ->
    {ok, 
        #npc_ai_rule{
            id = 130611
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11630,1},{suit_tar,hp,<<"<=">>,30,1}]
            ,action = [{suit_tar,skill,830508},{self,talk,[<<"我不会让你倒下的">>]}]
        }
    };
get(ai_rule, 130613) ->
    {ok, 
        #npc_ai_rule{
            id = 130613
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11519,1},{suit_tar,hp,<<">">>,0,0},{self_side,id,<<"=">>,11630,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{opp_side,skill,830510},{self,talk,[<<"你竟敢伤害我的宠物，你成功惹怒我了，人类！">>]}]
        }
    };
get(ai_rule, 130614) ->
    {ok, 
        #npc_ai_rule{
            id = 130614
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830511},{self,talk,[<<"你擅自闯入了主人的领地，他不会放过你的！">>]}]
        }
    };
get(ai_rule, 130615) ->
    {ok, 
        #npc_ai_rule{
            id = 130615
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830512}]
        }
    };
get(ai_rule, 130616) ->
    {ok, 
        #npc_ai_rule{
            id = 130616
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830513},{self,talk,[<<"可恶，我主人不在我无法发挥足够的力量">>]}]
        }
    };
get(ai_rule, 130617) ->
    {ok, 
        #npc_ai_rule{
            id = 130617
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830513}]
        }
    };
get(ai_rule, 130618) ->
    {ok, 
        #npc_ai_rule{
            id = 130618
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,7,1},{self,buff,<<"not_in">>,200060,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1}]
            ,action = [{self,skill,830034},{self,talk,[<<"不好了，我得找机会通知主人！">>]}]
        }
    };
get(ai_rule, 130619) ->
    {ok, 
        #npc_ai_rule{
            id = 130619
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830511}]
        }
    };
get(ai_rule, 130620) ->
    {ok, 
        #npc_ai_rule{
            id = 130620
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830512},{self,talk,[<<"我感觉到强大的力量源源不断地涌进身体！">>]}]
        }
    };
get(ai_rule, 130621) ->
    {ok, 
        #npc_ai_rule{
            id = 130621
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830512},{self,talk,[<<"你就帮我磨磨牙吧！">>]}]
        }
    };
get(ai_rule, 130622) ->
    {ok, 
        #npc_ai_rule{
            id = 130622
            ,type = 0
            ,repeat = 0
            ,prob = 80
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830513},{self,talk,[<<"你也就只能趁主人不在的时候偷袭我们！">>]}]
        }
    };
get(ai_rule, 130623) ->
    {ok, 
        #npc_ai_rule{
            id = 130623
            ,type = 0
            ,repeat = 0
            ,prob = 60
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830513},{self,talk,[<<"凭你这疲软的攻击，恐怕连一块树叶都打不穿！">>]}]
        }
    };
get(ai_rule, 130624) ->
    {ok, 
        #npc_ai_rule{
            id = 130624
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830513}]
        }
    };
get(ai_rule, 130650) ->
    {ok, 
        #npc_ai_rule{
            id = 130650
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,60,1},{self,buff,<<"not_in">>,200060,1},{self,buff,<<"not_in">>,200080,1},{self,buff,<<"not_in">>,200051,1}]
            ,action = [{self,skill,830605},{self,talk,[<<"即使燃烧生命我也要击倒你！！！">>]}]
        }
    };
get(ai_rule, 130651) ->
    {ok, 
        #npc_ai_rule{
            id = 130651
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830601},{self,talk,[<<"撞在我的拳头下，只能怪你运气不好了！">>]}]
        }
    };
get(ai_rule, 130652) ->
    {ok, 
        #npc_ai_rule{
            id = 130652
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,3,1}]
            ,action = [{opp_side,skill,830601},{self,talk,[<<"想逃？如果腿骨还没被敲断的话就试试吧！">>]}]
        }
    };
get(ai_rule, 130653) ->
    {ok, 
        #npc_ai_rule{
            id = 130653
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830606},{self,talk,[<<"我给你一次机会，离开雪山。噢不，我反悔了哈哈哈！">>]}]
        }
    };
get(ai_rule, 130654) ->
    {ok, 
        #npc_ai_rule{
            id = 130654
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830601}]
        }
    };
get(ai_rule, 130655) ->
    {ok, 
        #npc_ai_rule{
            id = 130655
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830600}]
        }
    };
get(ai_rule, 130700) ->
    {ok, 
        #npc_ai_rule{
            id = 130700
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,2,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,830651},{self,talk,[<<"将你囚禁在骨牢地狱之中！">>]}]
        }
    };
get(ai_rule, 130701) ->
    {ok, 
        #npc_ai_rule{
            id = 130701
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,2,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,830651},{self,talk,[<<"将你囚禁在骨牢地狱之中！">>]}]
        }
    };
get(ai_rule, 130702) ->
    {ok, 
        #npc_ai_rule{
            id = 130702
            ,type = 0
            ,repeat = 0
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,2,1},{opp_side,buff,<<"not_in">>,200040,1}]
            ,action = [{suit_tar,skill,830651},{self,talk,[<<"将你囚禁在骨牢地狱之中！">>]}]
        }
    };
get(ai_rule, 130703) ->
    {ok, 
        #npc_ai_rule{
            id = 130703
            ,type = 0
            ,repeat = 1
            ,prob = 41
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830652},{self,talk,[<<"骨刺攻击！">>]}]
        }
    };
get(ai_rule, 130704) ->
    {ok, 
        #npc_ai_rule{
            id = 130704
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"include">>,200040,1}]
            ,action = [{suit_tar,skill,830654},{self,talk,[<<"毒刺与骨牢的毒融合在一起会变成致命的剧毒哈哈哈！">>]}]
        }
    };
get(ai_rule, 130705) ->
    {ok, 
        #npc_ai_rule{
            id = 130705
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830653},{self,talk,[<<"让我刺一下又不会死~">>]}]
        }
    };
get(ai_rule, 130706) ->
    {ok, 
        #npc_ai_rule{
            id = 130706
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1},{opp_side,buff,<<"include">>,200040,1}]
            ,action = [{suit_tar,skill,830654},{self,talk,[<<"毒刺与骨牢的毒融合在一起会变成致命的剧毒哈哈哈！">>]}]
        }
    };
get(ai_rule, 130707) ->
    {ok, 
        #npc_ai_rule{
            id = 130707
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,4,1}]
            ,action = [{opp_side,skill,830653},{self,talk,[<<"让我刺一下又不会死~">>]}]
        }
    };
get(ai_rule, 130708) ->
    {ok, 
        #npc_ai_rule{
            id = 130708
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830650}]
        }
    };
get(ai_rule, 130751) ->
    {ok, 
        #npc_ai_rule{
            id = 130751
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830702},{self,talk,[<<"银马冲锋刺！">>]}]
        }
    };
get(ai_rule, 130752) ->
    {ok, 
        #npc_ai_rule{
            id = 130752
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1}]
            ,action = [{opp_side,skill,830701},{self,talk,[<<"踏破你的铠甲！">>]}]
        }
    };
get(ai_rule, 130753) ->
    {ok, 
        #npc_ai_rule{
            id = 130753
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,0,1}]
            ,action = [{opp_side,skill,830702},{self,talk,[<<"还能挡住我的冲锋吗！">>]}]
        }
    };
get(ai_rule, 130754) ->
    {ok, 
        #npc_ai_rule{
            id = 130754
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,1,1}]
            ,action = [{opp_side,skill,830702}]
        }
    };
get(ai_rule, 130755) ->
    {ok, 
        #npc_ai_rule{
            id = 130755
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830700}]
        }
    };
get(ai_rule, 130756) ->
    {ok, 
        #npc_ai_rule{
            id = 130756
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,830703}]
        }
    };
get(ai_rule, 130800) ->
    {ok, 
        #npc_ai_rule{
            id = 130800
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,9,1}]
            ,action = [{self,skill,830752},{self,talk,[<<"狂暴之怒！">>]}]
        }
    };
get(ai_rule, 130801) ->
    {ok, 
        #npc_ai_rule{
            id = 130801
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{self,skill,830751},{self,talk,[<<"反击风暴开始了！">>]}]
        }
    };
get(ai_rule, 130802) ->
    {ok, 
        #npc_ai_rule{
            id = 130802
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830750}]
        }
    };
get(ai_rule, 130803) ->
    {ok, 
        #npc_ai_rule{
            id = 130803
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,8,1},{self_side,buff,<<"include">>,104140,1}]
            ,action = [{suit_tar,skill,830753},{self,talk,[<<"凭这种程度的攻击，还造不成威胁！">>]}]
        }
    };
get(ai_rule, 130850) ->
    {ok, 
        #npc_ai_rule{
            id = 130850
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,20,1},{self_side,id,<<"=">>,11654,1},{suit_tar,hp,<<">">>,80,1},{self_side,id,<<"=">>,11684,1},{suit_tar,hp,<<">">>,80,1},{self_side,id,<<"=">>,11714,1},{suit_tar,hp,<<">">>,80,1}]
            ,action = [{opp_side,skill,830805},{self,talk,[<<"想法不错，但是，可惜！">>]}]
        }
    };
get(ai_rule, 130851) ->
    {ok, 
        #npc_ai_rule{
            id = 130851
            ,type = 0
            ,repeat = 0
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,3,1},{combat,round,<<"<=">>,7,1}]
            ,action = [{opp_side,skill,830802},{self,talk,[<<"锁定！">>]}]
        }
    };
get(ai_rule, 130852) ->
    {ok, 
        #npc_ai_rule{
            id = 130852
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,201110,1}]
            ,action = [{suit_tar,skill,830803},{self,talk,[<<"死定！">>]}]
        }
    };
get(ai_rule, 130853) ->
    {ok, 
        #npc_ai_rule{
            id = 130853
            ,type = 0
            ,repeat = 0
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,8,1},{combat,round,<<"<=">>,14,1}]
            ,action = [{opp_side,skill,830802},{self,talk,[<<"标记完毕！">>]}]
        }
    };
get(ai_rule, 130854) ->
    {ok, 
        #npc_ai_rule{
            id = 130854
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,201110,1}]
            ,action = [{suit_tar,skill,830803},{self,talk,[<<"强力一击！">>]}]
        }
    };
get(ai_rule, 130855) ->
    {ok, 
        #npc_ai_rule{
            id = 130855
            ,type = 0
            ,repeat = 0
            ,prob = 35
            ,condition = [{combat,round,<<">=">>,15,1}]
            ,action = [{opp_side,skill,830802},{self,talk,[<<"看到这个呆货了没有，一会给你好看哦">>]}]
        }
    };
get(ai_rule, 130856) ->
    {ok, 
        #npc_ai_rule{
            id = 130856
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,201110,1}]
            ,action = [{suit_tar,skill,830803},{self,talk,[<<"真是完美的弧线">>]}]
        }
    };
get(ai_rule, 130857) ->
    {ok, 
        #npc_ai_rule{
            id = 130857
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830804},{self,talk,[<<"啊，这箭射得真没准头">>]}]
        }
    };
get(ai_rule, 130858) ->
    {ok, 
        #npc_ai_rule{
            id = 130858
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830801}]
        }
    };
get(ai_rule, 130859) ->
    {ok, 
        #npc_ai_rule{
            id = 130859
            ,type = 0
            ,repeat = 0
            ,prob = 20
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,201240,1}]
            ,action = [{opp_side,skill,830806},{self,talk,[<<"靶子就要有靶子的自觉！">>]}]
        }
    };
get(ai_rule, 130860) ->
    {ok, 
        #npc_ai_rule{
            id = 130860
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830800}]
        }
    };
get(ai_rule, 130901) ->
    {ok, 
        #npc_ai_rule{
            id = 130901
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{self,buff,<<"not_in">>,209030,1}]
            ,action = [{self,skill,830851},{self,talk,[<<"不稳定魔导弹准备就绪！希望这次不会搞砸">>]}]
        }
    };
get(ai_rule, 130902) ->
    {ok, 
        #npc_ai_rule{
            id = 130902
            ,type = 0
            ,repeat = 1
            ,prob = 60
            ,condition = [{self,buff,<<"include">>,209030,1}]
            ,action = [{opp_side,skill,830852},{self,talk,[<<"绝望吧！魔导弹！">>]}]
        }
    };
get(ai_rule, 130903) ->
    {ok, 
        #npc_ai_rule{
            id = 130903
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,buff,<<"include">>,209030,1}]
            ,action = [{self,skill,830853},{self,talk,[<<"糟糕！失控了！">>]}]
        }
    };
get(ai_rule, 130900) ->
    {ok, 
        #npc_ai_rule{
            id = 130900
            ,type = 0
            ,repeat = 1
            ,prob = 10
            ,condition = [{opp_side,buff,<<"not_in">>,200090,1}]
            ,action = [{suit_tar,skill,830854},{self,talk,[<<"封印你的暴怒与潜在能力！">>]}]
        }
    };
get(ai_rule, 130904) ->
    {ok, 
        #npc_ai_rule{
            id = 130904
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<">=">>,5,1},{self,buff,<<"not_in">>,101011,1}]
            ,action = [{opp_side,skill,830855},{self,talk,[<<"春天种下一颗种子，桀桀桀桀……">>]}]
        }
    };
get(ai_rule, 130905) ->
    {ok, 
        #npc_ai_rule{
            id = 130905
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830850}]
        }
    };
get(ai_rule, 130950) ->
    {ok, 
        #npc_ai_rule{
            id = 130950
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,830903},{self,talk,[<<"啊，静心聆听这美妙的铃音~">>]}]
        }
    };
get(ai_rule, 130951) ->
    {ok, 
        #npc_ai_rule{
            id = 130951
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,830903},{self,talk,[<<"看来你沉浸其中了，是吗？">>]}]
        }
    };
get(ai_rule, 130952) ->
    {ok, 
        #npc_ai_rule{
            id = 130952
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,830901},{self,talk,[<<"束音成箭！">>]}]
        }
    };
get(ai_rule, 130953) ->
    {ok, 
        #npc_ai_rule{
            id = 130953
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{opp_side,skill,830901}]
        }
    };
get(ai_rule, 130954) ->
    {ok, 
        #npc_ai_rule{
            id = 130954
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,5,1}]
            ,action = [{opp_side,skill,830904},{self,talk,[<<"声音具有巨大的能量">>]}]
        }
    };
get(ai_rule, 130955) ->
    {ok, 
        #npc_ai_rule{
            id = 130955
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,6,1}]
            ,action = [{opp_side,skill,830904},{self,talk,[<<"喜欢我的音乐会吗">>]}]
        }
    };
get(ai_rule, 130956) ->
    {ok, 
        #npc_ai_rule{
            id = 130956
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,7,1}]
            ,action = [{opp_side,skill,830902},{self,talk,[<<"演奏接近尾声了">>]}]
        }
    };
get(ai_rule, 130957) ->
    {ok, 
        #npc_ai_rule{
            id = 130957
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,8,1}]
            ,action = [{opp_side,skill,830902},{self,talk,[<<"该让战斗结束了。">>]}]
        }
    };
get(ai_rule, 130958) ->
    {ok, 
        #npc_ai_rule{
            id = 130958
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,1,1}]
            ,action = [{opp_side,skill,830900}]
        }
    };
get(ai_rule, 130959) ->
    {ok, 
        #npc_ai_rule{
            id = 130959
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,2,1}]
            ,action = [{opp_side,skill,830900}]
        }
    };
get(ai_rule, 130960) ->
    {ok, 
        #npc_ai_rule{
            id = 130960
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,3,1}]
            ,action = [{opp_side,skill,830905},{self,talk,[<<"失去视线，你将对声音更敏感！">>]}]
        }
    };
get(ai_rule, 130961) ->
    {ok, 
        #npc_ai_rule{
            id = 130961
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"=">>,4,1}]
            ,action = [{self_side,skill,830906},{self,talk,[<<"你能做得更好！">>]}]
        }
    };
get(ai_rule, 130962) ->
    {ok, 
        #npc_ai_rule{
            id = 130962
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,5,1}]
            ,action = [{opp_side,skill,830900}]
        }
    };
get(ai_rule, 131000) ->
    {ok, 
        #npc_ai_rule{
            id = 131000
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11693,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,11693,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,830951},{self,talk,[<<"出来吧，我的仆从！">>]}]
        }
    };
get(ai_rule, 131001) ->
    {ok, 
        #npc_ai_rule{
            id = 131001
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11723,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,11723,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,830952},{self,talk,[<<"出来吧，我的仆从！">>]}]
        }
    };
get(ai_rule, 131002) ->
    {ok, 
        #npc_ai_rule{
            id = 131002
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11693,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,11693,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,830951},{self,talk,[<<"哼哼，幻象可是无穷无尽的。">>]}]
        }
    };
get(ai_rule, 131003) ->
    {ok, 
        #npc_ai_rule{
            id = 131003
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,id,<<"=">>,11723,1},{suit_tar,hp,<<"<=">>,0,1},{self_side,id,<<"=">>,11723,1},{suit_tar,hp,<<">">>,0,0}]
            ,action = [{self_side,skill,830952}]
        }
    };
get(ai_rule, 131004) ->
    {ok, 
        #npc_ai_rule{
            id = 131004
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,830950}]
        }
    };
get(ai_rule, 140001) ->
    {ok, 
        #npc_ai_rule{
            id = 140001
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,60,1}]
            ,action = [{self,skill,840001},{self,talk,[<<"现在动我试试？">>]}]
        }
    };
get(ai_rule, 140002) ->
    {ok, 
        #npc_ai_rule{
            id = 140002
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,30,1}]
            ,action = [{self,skill,840001},{self,talk,[<<"现在动我试试？">>]}]
        }
    };
get(ai_rule, 140003) ->
    {ok, 
        #npc_ai_rule{
            id = 140003
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840002},{self,talk,[<<"小鬼，砍这里">>]}]
        }
    };
get(ai_rule, 140004) ->
    {ok, 
        #npc_ai_rule{
            id = 140004
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,840003}]
        }
    };
get(ai_rule, 140005) ->
    {ok, 
        #npc_ai_rule{
            id = 140005
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840004}]
        }
    };
get(ai_rule, 140006) ->
    {ok, 
        #npc_ai_rule{
            id = 140006
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840006}]
        }
    };
get(ai_rule, 140007) ->
    {ok, 
        #npc_ai_rule{
            id = 140007
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{combat,round,<<"mod3">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840011}]
        }
    };
get(ai_rule, 140008) ->
    {ok, 
        #npc_ai_rule{
            id = 140008
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,840012},{self,talk,[<<"睡吧！最好永远别醒来">>]}]
        }
    };
get(ai_rule, 140009) ->
    {ok, 
        #npc_ai_rule{
            id = 140009
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,3,1}]
            ,action = [{opp_side,skill,840013}]
        }
    };
get(ai_rule, 140010) ->
    {ok, 
        #npc_ai_rule{
            id = 140010
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840021},{self,talk,[<<"三杀！">>]}]
        }
    };
get(ai_rule, 140011) ->
    {ok, 
        #npc_ai_rule{
            id = 140011
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840022},{self,talk,[<<"瞄准你的头颅">>]}]
        }
    };
get(ai_rule, 140012) ->
    {ok, 
        #npc_ai_rule{
            id = 140012
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"include">>,200051,1}]
            ,action = [{suit_tar,skill,840023},{self,talk,[<<"哈哈哈，居然真的睡着了">>]}]
        }
    };
get(ai_rule, 140013) ->
    {ok, 
        #npc_ai_rule{
            id = 140013
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,840024},{self,talk,[<<"这些箭上涂了我的血">>]}]
        }
    };
get(ai_rule, 140014) ->
    {ok, 
        #npc_ai_rule{
            id = 140014
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840025},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 140101) ->
    {ok, 
        #npc_ai_rule{
            id = 140101
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840031},{self,talk,[<<"让我尝尝你的血是什么味道的">>]}]
        }
    };
get(ai_rule, 140102) ->
    {ok, 
        #npc_ai_rule{
            id = 140102
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840032},{self,talk,[<<"一锤让你生活不能自理！">>]}]
        }
    };
get(ai_rule, 140103) ->
    {ok, 
        #npc_ai_rule{
            id = 140103
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840042}]
        }
    };
get(ai_rule, 140104) ->
    {ok, 
        #npc_ai_rule{
            id = 140104
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"include">>,200040,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840043},{self,talk,[<<"晕了正好补刀">>]}]
        }
    };
get(ai_rule, 140105) ->
    {ok, 
        #npc_ai_rule{
            id = 140105
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{opp_side,hp,<<"<=">>,30,1},{suit_tar,hp,<<">=">>,20,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840044},{self,talk,[<<"三倍斩杀！">>]}]
        }
    };
get(ai_rule, 140106) ->
    {ok, 
        #npc_ai_rule{
            id = 140106
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{opp_side,hp,<<"<=">>,20,1},{suit_tar,hp,<<">=">>,10,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840045},{self,talk,[<<"四倍斩杀！">>]}]
        }
    };
get(ai_rule, 140107) ->
    {ok, 
        #npc_ai_rule{
            id = 140107
            ,type = 0
            ,repeat = 1
            ,prob = 50
            ,condition = [{opp_side,hp,<<"<=">>,10,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840046},{self,talk,[<<"五倍斩杀！">>]}]
        }
    };
get(ai_rule, 140108) ->
    {ok, 
        #npc_ai_rule{
            id = 140108
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840038}]
        }
    };
get(ai_rule, 140109) ->
    {ok, 
        #npc_ai_rule{
            id = 140109
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,buff,<<"not_in">>,102010,1}]
            ,action = [{self,skill,840041},{self,talk,[<<"干掉你以后我可要回去好好喝两杯">>]}]
        }
    };
get(ai_rule, 140201) ->
    {ok, 
        #npc_ai_rule{
            id = 140201
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,buff,<<"not_in">>,101250,1}]
            ,action = [{self,skill,840061},{self,talk,[<<"我的冰之铠甲会让你吃苦头的">>]}]
        }
    };
get(ai_rule, 140202) ->
    {ok, 
        #npc_ai_rule{
            id = 140202
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1}]
            ,action = [{self,skill,840062},{self,talk,[<<"看来要让我的铠甲更硬一点了">>]}]
        }
    };
get(ai_rule, 140203) ->
    {ok, 
        #npc_ai_rule{
            id = 140203
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod6">>,1,1}]
            ,action = [{self_side,skill,840063}]
        }
    };
get(ai_rule, 140204) ->
    {ok, 
        #npc_ai_rule{
            id = 140204
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1}]
            ,action = [{opp_side,skill,840064},{self,talk,[<<"看你的小身板儿，受得了这样的寒风吗？">>]}]
        }
    };
get(ai_rule, 140205) ->
    {ok, 
        #npc_ai_rule{
            id = 140205
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,3,1}]
            ,action = [{opp_side,skill,840065}]
        }
    };
get(ai_rule, 140206) ->
    {ok, 
        #npc_ai_rule{
            id = 140206
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,hp,<<">=">>,70,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840071}]
        }
    };
get(ai_rule, 140207) ->
    {ok, 
        #npc_ai_rule{
            id = 140207
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{self,hp,<<">=">>,70,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840071},{self,talk,[<<"吼！">>]}]
        }
    };
get(ai_rule, 140208) ->
    {ok, 
        #npc_ai_rule{
            id = 140208
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840072}]
        }
    };
get(ai_rule, 140209) ->
    {ok, 
        #npc_ai_rule{
            id = 140209
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,40,1}]
            ,action = [{opp_side,skill,840073},{self,talk,[<<"年轻人，你让我生气了">>]}]
        }
    };
get(ai_rule, 140210) ->
    {ok, 
        #npc_ai_rule{
            id = 140210
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840074}]
        }
    };
get(ai_rule, 140211) ->
    {ok, 
        #npc_ai_rule{
            id = 140211
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"include">>,201020,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840075},{self,talk,[<<"你的动作变僵硬了呢">>]}]
        }
    };
get(ai_rule, 140212) ->
    {ok, 
        #npc_ai_rule{
            id = 140212
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,840081},{self,talk,[<<"我的风舒服吗？">>]}]
        }
    };
get(ai_rule, 140213) ->
    {ok, 
        #npc_ai_rule{
            id = 140213
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,840082},{self,talk,[<<"你静止的样子也很可爱嘛">>]}]
        }
    };
get(ai_rule, 140214) ->
    {ok, 
        #npc_ai_rule{
            id = 140214
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{self_side,hp,<<"<=">>,80,1},{suit_tar,buff,<<"include">>,101130,1}]
            ,action = [{suit_tar,skill,840083},{self,talk,[<<"在坚硬的寒冰中好好恢复一下">>]}]
        }
    };
get(ai_rule, 140215) ->
    {ok, 
        #npc_ai_rule{
            id = 140215
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self_side,hp,<<"<=">>,20,1},{suit_tar,buff,<<"include">>,101130,1}]
            ,action = [{suit_tar,skill,840083},{self,talk,[<<"寒冰的保护是无懈可击的">>]}]
        }
    };
get(ai_rule, 140216) ->
    {ok, 
        #npc_ai_rule{
            id = 140216
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,3,1},{opp_side,buff_eff_type,<<"include">>,buff,1}]
            ,action = [{opp_side,skill,840084},{self,talk,[<<"你的魔法也救不了你">>]}]
        }
    };
get(ai_rule, 140217) ->
    {ok, 
        #npc_ai_rule{
            id = 140217
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840066}]
        }
    };
get(ai_rule, 140218) ->
    {ok, 
        #npc_ai_rule{
            id = 140218
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840085}]
        }
    };
get(ai_rule, 140219) ->
    {ok, 
        #npc_ai_rule{
            id = 140219
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{self,skill,840076}]
        }
    };
get(ai_rule, 140220) ->
    {ok, 
        #npc_ai_rule{
            id = 140220
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1}]
            ,action = [{opp_side,skill,840067},{self,talk,[<<"看你的小身板儿，受得了这样的寒风吗？">>]}]
        }
    };
get(ai_rule, 140221) ->
    {ok, 
        #npc_ai_rule{
            id = 140221
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1}]
            ,action = [{opp_side,skill,840068},{self,talk,[<<"看你的小身板儿，受得了这样的寒风吗？">>]}]
        }
    };
get(ai_rule, 140222) ->
    {ok, 
        #npc_ai_rule{
            id = 140222
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1}]
            ,action = [{opp_side,skill,840069},{self,talk,[<<"看你的小身板儿，受得了这样的寒风吗？">>]}]
        }
    };
get(ai_rule, 140223) ->
    {ok, 
        #npc_ai_rule{
            id = 140223
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1}]
            ,action = [{opp_side,skill,840070},{self,talk,[<<"看你的小身板儿，受得了这样的寒风吗？">>]}]
        }
    };
get(ai_rule, 140224) ->
    {ok, 
        #npc_ai_rule{
            id = 140224
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840077}]
        }
    };
get(ai_rule, 140225) ->
    {ok, 
        #npc_ai_rule{
            id = 140225
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840078}]
        }
    };
get(ai_rule, 140226) ->
    {ok, 
        #npc_ai_rule{
            id = 140226
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840079}]
        }
    };
get(ai_rule, 140227) ->
    {ok, 
        #npc_ai_rule{
            id = 140227
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1},{opp_side,fighter_type,<<"=">>,0,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840080}]
        }
    };
get(ai_rule, 140228) ->
    {ok, 
        #npc_ai_rule{
            id = 140228
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,840086},{self,talk,[<<"我的风舒服吗？">>]}]
        }
    };
get(ai_rule, 140229) ->
    {ok, 
        #npc_ai_rule{
            id = 140229
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,840087},{self,talk,[<<"我的风舒服吗？">>]}]
        }
    };
get(ai_rule, 140230) ->
    {ok, 
        #npc_ai_rule{
            id = 140230
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,840088},{self,talk,[<<"我的风舒服吗？">>]}]
        }
    };
get(ai_rule, 140231) ->
    {ok, 
        #npc_ai_rule{
            id = 140231
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,840089},{self,talk,[<<"我的风舒服吗？">>]}]
        }
    };
get(ai_rule, 140232) ->
    {ok, 
        #npc_ai_rule{
            id = 140232
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,840047},{self,talk,[<<"你静止的样子也很可爱嘛">>]}]
        }
    };
get(ai_rule, 140233) ->
    {ok, 
        #npc_ai_rule{
            id = 140233
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,840048},{self,talk,[<<"你静止的样子也很可爱嘛">>]}]
        }
    };
get(ai_rule, 140234) ->
    {ok, 
        #npc_ai_rule{
            id = 140234
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,840049},{self,talk,[<<"你静止的样子也很可爱嘛">>]}]
        }
    };
get(ai_rule, 140235) ->
    {ok, 
        #npc_ai_rule{
            id = 140235
            ,type = 0
            ,repeat = 1
            ,prob = 20
            ,condition = [{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,840050},{self,talk,[<<"你静止的样子也很可爱嘛">>]}]
        }
    };
get(ai_rule, 140301) ->
    {ok, 
        #npc_ai_rule{
            id = 140301
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840091}]
        }
    };
get(ai_rule, 140302) ->
    {ok, 
        #npc_ai_rule{
            id = 140302
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840093},{self,talk,[<<"">>]}]
        }
    };
get(ai_rule, 140303) ->
    {ok, 
        #npc_ai_rule{
            id = 140303
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840094}]
        }
    };
get(ai_rule, 140304) ->
    {ok, 
        #npc_ai_rule{
            id = 140304
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"include">>,210370,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840095},{self,talk,[<<"毒液在体内沸腾的感觉如何？">>]}]
        }
    };
get(ai_rule, 140305) ->
    {ok, 
        #npc_ai_rule{
            id = 140305
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1}]
            ,action = [{self,skill,840101},{self,talk,[<<"神源，会给我无穷无尽的生命">>]}]
        }
    };
get(ai_rule, 140306) ->
    {ok, 
        #npc_ai_rule{
            id = 140306
            ,type = 0
            ,repeat = 1
            ,prob = 70
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,840102},{self,talk,[<<"多吸一点吧">>]}]
        }
    };
get(ai_rule, 140307) ->
    {ok, 
        #npc_ai_rule{
            id = 140307
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod5">>,4,1}]
            ,action = [{self_side,skill,840103}]
        }
    };
get(ai_rule, 140308) ->
    {ok, 
        #npc_ai_rule{
            id = 140308
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,2,1},{self_side,buff_eff_type,<<"include">>,debuff,1}]
            ,action = [{self_side,skill,840104}]
        }
    };
get(ai_rule, 140309) ->
    {ok, 
        #npc_ai_rule{
            id = 140309
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod5">>,3,1},{opp_side,buff_eff_type,<<"include">>,buff,1}]
            ,action = [{opp_side,skill,840105}]
        }
    };
get(ai_rule, 140310) ->
    {ok, 
        #npc_ai_rule{
            id = 140310
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,buff,<<"not_in">>,200031,1}]
            ,action = [{self,skill,840111},{self,talk,[<<"这个拼凑的身体看来还不完美">>]}]
        }
    };
get(ai_rule, 140311) ->
    {ok, 
        #npc_ai_rule{
            id = 140311
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod3">>,2,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840112},{self,talk,[<<"尝尝我的剧毒吧">>]}]
        }
    };
get(ai_rule, 140312) ->
    {ok, 
        #npc_ai_rule{
            id = 140312
            ,type = 0
            ,repeat = 1
            ,prob = 90
            ,condition = [{combat,round,<<"mod4">>,3,1}]
            ,action = [{opp_side,skill,840113}]
        }
    };
get(ai_rule, 140313) ->
    {ok, 
        #npc_ai_rule{
            id = 140313
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<">>,20,1},{opp_side,fighter_type,<<"=">>,0,1}]
            ,action = [{suit_tar,skill,840114},{self,talk,[<<"跟我同归于尽吧！">>]}]
        }
    };
get(ai_rule, 140314) ->
    {ok, 
        #npc_ai_rule{
            id = 140314
            ,type = 0
            ,repeat = 1
            ,prob = 30
            ,condition = [{combat,round,<<">=">>,1,1},{self,buff,<<"not_in">>,100121,1}]
            ,action = [{self,skill,840097},{self,talk,[<<"毒液是我最好的朋友">>]}]
        }
    };
get(ai_rule, 140315) ->
    {ok, 
        #npc_ai_rule{
            id = 140315
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,buff,<<"not_in">>,100121,1}]
            ,action = [{self,skill,840097}]
        }
    };
get(ai_rule, 140316) ->
    {ok, 
        #npc_ai_rule{
            id = 140316
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840096}]
        }
    };
get(ai_rule, 140317) ->
    {ok, 
        #npc_ai_rule{
            id = 140317
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840106}]
        }
    };
get(ai_rule, 140318) ->
    {ok, 
        #npc_ai_rule{
            id = 140318
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,35,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840096},{self,talk,[<<"这个躯体看来已经没用了，不过……嘿嘿">>]}]
        }
    };
get(ai_rule, 140401) ->
    {ok, 
        #npc_ai_rule{
            id = 140401
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1}]
            ,action = [{opp_side,skill,840121},{self,talk,[<<"一点也不痛吧？">>]}]
        }
    };
get(ai_rule, 140402) ->
    {ok, 
        #npc_ai_rule{
            id = 140402
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<"mod4">>,2,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840122},{self,talk,[<<"哈哈，这下治疗也起不了作用了">>]}]
        }
    };
get(ai_rule, 140403) ->
    {ok, 
        #npc_ai_rule{
            id = 140403
            ,type = 0
            ,repeat = 1
            ,prob = 25
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840123}]
        }
    };
get(ai_rule, 140404) ->
    {ok, 
        #npc_ai_rule{
            id = 140404
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"include">>,200080,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840124},{self,talk,[<<"失去理智了吗？那真是太好了">>]}]
        }
    };
get(ai_rule, 140405) ->
    {ok, 
        #npc_ai_rule{
            id = 140405
            ,type = 0
            ,repeat = 1
            ,prob = 80
            ,condition = [{combat,round,<<"mod4">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840131},{self,talk,[<<"粉碎吧凡人！">>]}]
        }
    };
get(ai_rule, 140406) ->
    {ok, 
        #npc_ai_rule{
            id = 140406
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{opp_side,buff,<<"include">>,101400,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840132},{self,talk,[<<"这可怜的圣光可对付不了我">>]}]
        }
    };
get(ai_rule, 140407) ->
    {ok, 
        #npc_ai_rule{
            id = 140407
            ,type = 0
            ,repeat = 1
            ,prob = 90
            ,condition = [{combat,round,<<"mod5">>,1,1}]
            ,action = [{opp_side,skill,840141},{self,talk,[<<"虫子们，来吧">>]}]
        }
    };
get(ai_rule, 140408) ->
    {ok, 
        #npc_ai_rule{
            id = 140408
            ,type = 0
            ,repeat = 1
            ,prob = 40
            ,condition = [{combat,round,<<"mod4">>,2,1}]
            ,action = [{opp_side,skill,840142},{self,talk,[<<"这招怎么样">>]}]
        }
    };
get(ai_rule, 140409) ->
    {ok, 
        #npc_ai_rule{
            id = 140409
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{self,buff,<<"not_in">>,101126,1}]
            ,action = [{self,skill,840143},{self,talk,[<<"陪我们好好玩玩吧，虫子们">>]}]
        }
    };
get(ai_rule, 140410) ->
    {ok, 
        #npc_ai_rule{
            id = 140410
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,20,1},{self_side,buff,<<"not_in">>,101126,1},{suit_tar,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840144},{self,talk,[<<"对不起了朋友，你要变成我的食物了">>]}]
        }
    };
get(ai_rule, 140411) ->
    {ok, 
        #npc_ai_rule{
            id = 140411
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,50,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840145},{self,talk,[<<"我饿了">>]}]
        }
    };
get(ai_rule, 140412) ->
    {ok, 
        #npc_ai_rule{
            id = 140412
            ,type = 0
            ,repeat = 0
            ,prob = 100
            ,condition = [{self,hp,<<"<=">>,35,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840146},{self,talk,[<<"真的好饿，好饿">>]}]
        }
    };
get(ai_rule, 140413) ->
    {ok, 
        #npc_ai_rule{
            id = 140413
            ,type = 0
            ,repeat = 1
            ,prob = 100
            ,condition = [{combat,round,<<">=">>,1,1},{opp_side,buff,<<"not_in">>,200070,1}]
            ,action = [{suit_tar,skill,840147}]
        }
    };

get(ai, 2) ->
    {ok, [[1,90000,90001,90002,90003,90004,90005,90006,90007,90008,90009]]};
get(ai, 3) ->
    {ok, [[1,90010,90011,90012,90013,90014,90015,90016,90017,90018]]};
get(ai, 5) ->
    {ok, [[1,90019,90020,90021,90022,90023,90024,90025,90026,90027,90028]]};
get(ai, 12) ->
    {ok, [[1,100040,90000,90001,90002,90003,90004,90005,90006,90007,90008,90009]]};
get(ai, 13) ->
    {ok, [[1,100040,90010,90011,90012,90013,90014,90015,90016,90017,90018]]};
get(ai, 15) ->
    {ok, [[1,100040,90019,90020,90021,90022,90023,90024,90025,90026,90027,90028]]};
get(ai, 22) ->
    {ok, [[1,90006,90005,90007,90029,90008,90009]]};
get(ai, 23) ->
    {ok, [[1,90030,90031,90032,90015,90014,90018]]};
get(ai, 25) ->
    {ok, [[1,90033,90034,90035,90026,90022,90027,90028]]};
get(ai, 10208) ->
    {ok, [[1,101023]]};
get(ai, 10243) ->
    {ok, [[1,101001]]};
get(ai, 10244) ->
    {ok, [[1,101002]]};
get(ai, 10248) ->
    {ok, [[1,101023]]};
get(ai, 10282) ->
    {ok, [[1,101000]]};
get(ai, 13050) ->
    {ok, [[1,101000]]};
get(ai, 13051) ->
    {ok, [[1,101001]]};
get(ai, 13052) ->
    {ok, [[1,101001]]};
get(ai, 13053) ->
    {ok, [[1,101001]]};
get(ai, 13054) ->
    {ok, [[1,101000]]};
get(ai, 13055) ->
    {ok, [[1,101001]]};
get(ai, 13056) ->
    {ok, [[1,101001]]};
get(ai, 10298) ->
    {ok, [[1,100572,100652,100653,100654,100600,100576]]};
get(ai, 10299) ->
    {ok, [[1,100572,100652,100653,100654,100575,100576]]};
get(ai, 10300) ->
    {ok, [[1,100572,100652,100653,100654,100042,100043,100044,100045]]};
get(ai, 10301) ->
    {ok, [[1,100572,100652,100653,100654,100050,100051,100052,100053]]};
get(ai, 10302) ->
    {ok, [[1,100572,100652,100653,100654,11700,11723]]};
get(ai, 10413) ->
    {ok, [[1,100572,100652,100653,100654,11701,11723]]};
get(ai, 10524) ->
    {ok, [[1,100572,100652,100653,100654,11702,11723]]};
get(ai, 10303) ->
    {ok, [[1,100572,100652,100653,100654,100601,100602,100603]]};
get(ai, 10304) ->
    {ok, [[1,100572,100652,100653,100654,100573]]};
get(ai, 10305) ->
    {ok, [[1,11703,100572,100652,100653,100654,11704,11705,11707,11706,11723]]};
get(ai, 11306) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11417) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11528) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11307) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11418) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11529) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11308) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11419) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11530) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11309) ->
    {ok, [[1,100572,100652,100653,100654,11713,11714,11715,11716,11717,11723]]};
get(ai, 11420) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11531) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11310) ->
    {ok, [[1,100572,100652,100653,100654,11713,11714,11715,11716,11717,11723]]};
get(ai, 11421) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11532) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11311) ->
    {ok, [[1,100572,100652,100653,100654,11713,11714,11715,11716,11717,11723]]};
get(ai, 11533) ->
    {ok, [[1,100572,100652,100653,100654,11713,11714,11715,11716,11717,11723]]};
get(ai, 11422) ->
    {ok, [[1,100572,100652,100653,100654,11713,11714,11715,11716,11717,11723]]};
get(ai, 11312) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11423) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11534) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11313) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11424) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11535) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11314) ->
    {ok, [[1,100572,100652,100653,100654,11713,11714,11715,11716,11717,11723]]};
get(ai, 11425) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11536) ->
    {ok, [[1,100572,100652,100653,100654,11708,11709,11710,11711,11712,11723]]};
get(ai, 11317) ->
    {ok, [[1,11718,11719,11720,11721,11722,11723]]};
get(ai, 10306) ->
    {ok, [[1,100572,100652,100653,100654,100050,100051,100052,100053]]};
get(ai, 10307) ->
    {ok, [[1,100572,100652,100653,100654,100046,100047,100048,100049]]};
get(ai, 10308) ->
    {ok, [[1,100572,100652,100653,100654,100059,100060,100061,100063,100064,100065]]};
get(ai, 10309) ->
    {ok, [[1,100572,100652,100653,100654,100639,100640]]};
get(ai, 10310) ->
    {ok, [[1,100572,100652,100653,100654,100641,100642]]};
get(ai, 10311) ->
    {ok, [[1,100572,100652,100653,100654,100647,100648]]};
get(ai, 10312) ->
    {ok, [[1,100572,100652,100653,100654,100737,100738,100739]]};
get(ai, 10313) ->
    {ok, [[1,100572,100652,100653,100654,100741,100739]]};
get(ai, 10423) ->
    {ok, [[1,100572,100652,100653,100654,100740,100739]]};
get(ai, 10424) ->
    {ok, [[1,100572,100652,100653,100654,100742,100739]]};
get(ai, 10534) ->
    {ok, [[1,100572,100652,100653,100654,100739]]};
get(ai, 10535) ->
    {ok, [[1,100572,100652,100653,100654,100739]]};
get(ai, 10314) ->
    {ok, [[1,100572,100652,100653,100654,100577,100578,100579,100580]]};
get(ai, 10315) ->
    {ok, [[1,100572,100652,100653,100654,100042,100043,100044,100045]]};
get(ai, 10316) ->
    {ok, [[1,100572,100652,100653,100654,100075,100076,100077,100078,100079,100080]]};
get(ai, 10317) ->
    {ok, [[1,100572,100652,100653,100654,100067,100068,100069,100070,100071,100072,100073,100074]]};
get(ai, 10318) ->
    {ok, [[1,100572,100652,100653,100654,100081,100082,100083,100084,100085,100086,100087,100088,100089,100090]]};
get(ai, 10319) ->
    {ok, [[1,100572,100652,100653,100654,100081,100082,100083,100084,100085,100086,100087,100088,100089,100090]]};
get(ai, 10320) ->
    {ok, [[1,100572,100652,100653,100654,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 10321) ->
    {ok, [[1,100081,100082,100083,100084,100085,100086,100087,100088,100089,100090]]};
get(ai, 10322) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 10323) ->
    {ok, [[1,100606,100607,100608,100609,100610,100611,100612,100613,100614,100615]]};
get(ai, 10324) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 10325) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 10326) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 10327) ->
    {ok, [[1,100081,100082,100083,100084,100085,100086,100087,100088,100089,100090]]};
get(ai, 10328) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 10329) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 10330) ->
    {ok, [[1,100101,100102,100103,100104,100105,100106,100107,100108,100109,100110]]};
get(ai, 10331) ->
    {ok, [[1,100101,100102,100103,100104,100105,100106,100107,100108,100109,100110]]};
get(ai, 10332) ->
    {ok, [[1,100111,100112,100113,100114,100115,100116,100117,100118,100119]]};
get(ai, 10333) ->
    {ok, [[1,100126,100127,100128,100129,100130,100131,100132,100133,100134,100135,100136,100137]]};
get(ai, 10334) ->
    {ok, [[1,100138,100139,100140,100141,100142,100143,100144,100145,100146,100147,100148,100149]]};
get(ai, 10335) ->
    {ok, [[1,100150,100151,100152,100153,100154,100155,100156,100157,100158,100159,100160,100161]]};
get(ai, 10336) ->
    {ok, [[1,100138,100139,100140,100141,100142,100143,100144,100145,100146,100147,100148,100149]]};
get(ai, 10337) ->
    {ok, [[1,100150,100151,100152,100153,100154,100155,100156,100157,100158,100159,100160,100161]]};
get(ai, 10338) ->
    {ok, [[1,100627,100618,100616,100617,100619,100620,100621,100622,100623,100624,100625,100626,100628]]};
get(ai, 10339) ->
    {ok, [[1,100126,100127,100128,100129,100130,100131,100132,100133,100134,100135,100136,100137]]};
get(ai, 10340) ->
    {ok, [[1,100150,100151,100152,100153,100154,100155,100156,100157,100158,100159,100160,100161]]};
get(ai, 10341) ->
    {ok, [[1,100162,100163,100164,100165,100166,100167,100168,100169,100170,100171,100172,100173]]};
get(ai, 10342) ->
    {ok, [[1,100150,100151,100152,100153,100154,100155,100156,100157,100158,100159,100160,100161]]};
get(ai, 10343) ->
    {ok, [[1,100138,100139,100140,100141,100142,100143,100144,100145,100146,100147,100148,100149]]};
get(ai, 10344) ->
    {ok, [[1,100174,100175,100176,100177,100178,100179,100180,100181,100182,100183,100184,100185]]};
get(ai, 10345) ->
    {ok, [[1,100150,100151,100152,100153,100154,100155,100156,100157,100158,100159,100160,100161]]};
get(ai, 10346) ->
    {ok, [[1,100138,100139,100140,100141,100142,100143,100144,100145,100146,100147,100148,100149]]};
get(ai, 10347) ->
    {ok, [[1,100186,100187,100188,100189,100190,100191,100192,100193,100194,100195,100196,100197,100198,100199,100200,100201,100202,100203,100204,100205]]};
get(ai, 10348) ->
    {ok, [[1,100138,100139,100140,100141,100142,100143,100144,100145,100146,100147,100148,100149]]};
get(ai, 10349) ->
    {ok, [[1,100162,100163,100164,100165,100166,100167,100168,100169,100170,100171,100172,100173]]};
get(ai, 10350) ->
    {ok, [[1,100186,100187,100188,100189,100190,100191,100192,100193,100194,100195,100196,100197,100198,100199,100200,100201,100202,100203,100204,100205]]};
get(ai, 10525) ->
    {ok, [[1,100572,100652,100653,100654,100604,100605]]};
get(ai, 10526) ->
    {ok, [[1,100572,100652,100653,100654,100574,100605]]};
get(ai, 10531) ->
    {ok, [[1,100572,100652,100653,100654,100643,100644]]};
get(ai, 10532) ->
    {ok, [[1,100572,100652,100653,100654,100645,100646]]};
get(ai, 10533) ->
    {ok, [[1,100572,100652,100653,100654,110001]]};
get(ai, 10536) ->
    {ok, [[1,100572,100652,100653,100654,110001]]};
get(ai, 10537) ->
    {ok, [[1,100572,100652,100653,100654,110000]]};
get(ai, 10538) ->
    {ok, [[1,100572,100652,100653,100654,110005]]};
get(ai, 11300) ->
    {ok, [[1,100572,100652,100653,100654,100042,100043,100044,100045]]};
get(ai, 11301) ->
    {ok, [[1,100572,100652,100653,100654,100050,100051,100052,100053]]};
get(ai, 11302) ->
    {ok, [[1,100572,100652,100653,100654,100346,100347,100348,100349,100350]]};
get(ai, 11303) ->
    {ok, [[1,100572,100652,100653,100654,100632,100633,100634,100635,100636,100637,100638]]};
get(ai, 11304) ->
    {ok, [[1,100572,100652,100653,100654,100650,100651]]};
get(ai, 11305) ->
    {ok, [[1,100572,100652,100653,100654,100054,100055,100056,100057,100058]]};
get(ai, 11315) ->
    {ok, [[1,100572,100652,100653,100654,100577,100578,100579,100580]]};
get(ai, 11316) ->
    {ok, [[1,100572,100652,100653,100654,100046,100047,100048,100049]]};
get(ai, 10351) ->
    {ok, [[1,130001,130002,130003,130004,130005,130006,130007,130008]]};
get(ai, 10352) ->
    {ok, [[1,130001,130002,130003,130004,130005,130006,130007,130008]]};
get(ai, 10353) ->
    {ok, [[1,130001,130002,130003,130004,130005,130006,130007,130008]]};
get(ai, 10462) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 10463) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 10464) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 11351) ->
    {ok, [[1,130001,130002,130003,130004,130005,130006,130007,130008]]};
get(ai, 11352) ->
    {ok, [[1,130001,130002,130003,130004,130005,130006,130007,130008]]};
get(ai, 11353) ->
    {ok, [[1,130001,130002,130003,130004,130005,130006,130007,130008]]};
get(ai, 11462) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 11463) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 11464) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 10354) ->
    {ok, [[1,150011,150014,150015,150016,150017]]};
get(ai, 10355) ->
    {ok, [[1,150018,150021,150022,150023,150024]]};
get(ai, 10356) ->
    {ok, [[1,150025,150028,150029,150030,150031]]};
get(ai, 10465) ->
    {ok, [[1,150032,150156,150157,150033,150035]]};
get(ai, 10466) ->
    {ok, [[1,150037,150158,150159,150039,150040]]};
get(ai, 10467) ->
    {ok, [[1,150042,150160,150161,150043]]};
get(ai, 10576) ->
    {ok, [[1,150032,150156,150157,150033,150035]]};
get(ai, 10577) ->
    {ok, [[1,150037,150158,150159,150039,150040]]};
get(ai, 10578) ->
    {ok, [[1,150042,150160,150161,150043]]};
get(ai, 11354) ->
    {ok, [[1,130011,130014,130015,130016,130017]]};
get(ai, 11355) ->
    {ok, [[1,130018,130021,130022,130023,130024]]};
get(ai, 11356) ->
    {ok, [[1,130025,130028,130029,130030,130031]]};
get(ai, 11465) ->
    {ok, [[1,130032,130156,130157,130033,130035]]};
get(ai, 11466) ->
    {ok, [[1,130037,130158,130159,130039,130040]]};
get(ai, 11467) ->
    {ok, [[1,130042,130160,130161,130043]]};
get(ai, 11576) ->
    {ok, [[1,130032,130156,130157,130033,130035]]};
get(ai, 11577) ->
    {ok, [[1,130037,130158,130159,130039,130040]]};
get(ai, 11578) ->
    {ok, [[1,130042,130160,130161,130043]]};
get(ai, 10359) ->
    {ok, [[1,150045,150046,150047,150048,150049,150050,150051,150052,150053,150054]]};
get(ai, 10360) ->
    {ok, [[1,150059,150060,150061,150062,150063,150064,150065,150066,150067,150068]]};
get(ai, 10361) ->
    {ok, [[1,150059,150060,150061,150062,150063,150064,150065,150066,150067,150068]]};
get(ai, 10362) ->
    {ok, [[1,150059,150060,150061,150062,150063,150064,150065,150066,150067,150068]]};
get(ai, 10471) ->
    {ok, [[1,150068]]};
get(ai, 10472) ->
    {ok, [[1,150063,150064,150065,150066,150067,150059,150060,150061,150062,150068]]};
get(ai, 10473) ->
    {ok, [[1,150063,150064,150065,150066,150067,150059,150060,150061,150062,150068]]};
get(ai, 10582) ->
    {ok, [[1,150068]]};
get(ai, 10583) ->
    {ok, [[1,150068]]};
get(ai, 10584) ->
    {ok, [[1,150061,150062,150063,150064,150065,150066,150067,150059,150060,150068]]};
get(ai, 10363) ->
    {ok, [[1,130069,130120,130121,130122,130070,130071,130072]]};
get(ai, 10364) ->
    {ok, [[1,100206,100207,100208,100209,100210,100211,100212,100213,100214,100215,100216,100217,100218,100219,100220,100221,100222]]};
get(ai, 10365) ->
    {ok, [[1,100257,100258,100259,100260,100261,100262,100263,100264,100265,100266,100267,100268,100269,100270,100271,100272,100273]]};
get(ai, 10366) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 10367) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 10368) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 10477) ->
    {ok, [[1,150073,150075,150076,150078,150079,150080]]};
get(ai, 10478) ->
    {ok, [[1,150081,150083,150084,150086,150087,150088]]};
get(ai, 10479) ->
    {ok, [[1,150089,150091,150092,150094,150095,150096]]};
get(ai, 10588) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 10589) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 10590) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 11366) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 11367) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 11368) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 11477) ->
    {ok, [[1,130073,130075,130076,130078,130079,130080]]};
get(ai, 11478) ->
    {ok, [[1,130081,130083,130084,130086,130087,130088]]};
get(ai, 11479) ->
    {ok, [[1,130089,130091,130092,130094,130095,130096]]};
get(ai, 11588) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 11589) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 11590) ->
    {ok, [[1,130100,130101,130102,130103,130104]]};
get(ai, 10369) ->
    {ok, [[1,100223,100224,100225,100225,100226,100227,100228,100229,100230,100231,100232,100233,100234,100235,100236,100237,100238]]};
get(ai, 10370) ->
    {ok, [[1,100257,100258,100259,100260,100261,100262,100263,100264,100265,100266,100267,100268,100269,100270,100271,100272,100273]]};
get(ai, 10371) ->
    {ok, [[1,150148,150149,150150,150151,150152,150153,150154,150155]]};
get(ai, 10372) ->
    {ok, [[1,150200,150201,150202]]};
get(ai, 10373) ->
    {ok, [[1,150210,150211,150202]]};
get(ai, 10374) ->
    {ok, [[1,150212,150215,150202]]};
get(ai, 10375) ->
    {ok, [[1,150200,150201,150202]]};
get(ai, 10376) ->
    {ok, [[1,150200,150201,150202]]};
get(ai, 10377) ->
    {ok, [[1,130250,130251,130252,130253,130254,130255,130256,130257]]};
get(ai, 10378) ->
    {ok, [[1,100257,100258,100259,100260,100261,100262,100263,100264,100265,100266,100267,100268,100269,100270,100271,100272,100273]]};
get(ai, 10379) ->
    {ok, [[1,100274,100275,100276,100277,100278,100279,100280,100281,100282,100283,100284,100285,100286,100287,100288,100289,100290]]};
get(ai, 10380) ->
    {ok, [[1,130250,130251,130252,130253,130254,130255,130256,130257]]};
get(ai, 10381) ->
    {ok, [[1,130300,130301,130302]]};
get(ai, 10382) ->
    {ok, [[1,130300,130301,130302]]};
get(ai, 10383) ->
    {ok, [[1,130300,130301,130302]]};
get(ai, 10384) ->
    {ok, [[1,130352,130353,130354]]};
get(ai, 10385) ->
    {ok, [[1,130352,130353,130354]]};
get(ai, 10386) ->
    {ok, [[1,130352,130353,130354]]};
get(ai, 10390) ->
    {ok, [[1,130350,130351,130352,130353,130354]]};
get(ai, 10391) ->
    {ok, [[1,130350,130351,130352,130353,130354]]};
get(ai, 10387) ->
    {ok, [[1,150361,150362,150363]]};
get(ai, 10500) ->
    {ok, [[1,150364,150367,150368,150369,150370,150371]]};
get(ai, 11387) ->
    {ok, [[1,130361,130362,130363]]};
get(ai, 11500) ->
    {ok, [[1,130364,130367,130368,130369,130370,130371]]};
get(ai, 11501) ->
    {ok, [[1,130358,130365,130367,130368,130369,130370,130371]]};
get(ai, 11502) ->
    {ok, [[1,130360,130366,130367,130368,130369,130370,130371]]};
get(ai, 10388) ->
    {ok, [[1,150357,150361,150362,150363]]};
get(ai, 10389) ->
    {ok, [[1,150357,150361,150362,150363]]};
get(ai, 10392) ->
    {ok, [[1,150405]]};
get(ai, 10405) ->
    {ok, [[1,150405]]};
get(ai, 10406) ->
    {ok, [[1,150405]]};
get(ai, 10393) ->
    {ok, [[1,150405]]};
get(ai, 10394) ->
    {ok, [[1,150405]]};
get(ai, 10395) ->
    {ok, [[1,130450,130451,130452,130453,130454,130455,130456]]};
get(ai, 10396) ->
    {ok, [[1,130500,130501,130502,130509]]};
get(ai, 10397) ->
    {ok, [[1,130500,130501,130502,130509]]};
get(ai, 10398) ->
    {ok, [[1,130500,130501,130502,130509]]};
get(ai, 10399) ->
    {ok, [[1,150577,150578,150579]]};
get(ai, 10400) ->
    {ok, [[1,150577,150578,150579]]};
get(ai, 10401) ->
    {ok, [[1,150577,150578,150579]]};
get(ai, 10408) ->
    {ok, [[1,150564,150565,150566,150567,150568,150569,150570,150571,150572,150573],[2,150574,150575,150576]]};
get(ai, 10409) ->
    {ok, [[1,150564,150565,150566,150567,150568,150569,150570,150571,150572,150573],[2,150574,150575,150576]]};
get(ai, 10402) ->
    {ok, [[1,150618,150624]]};
get(ai, 10403) ->
    {ok, [[1,150600,150602,150604,150605,150609,150612,150624]]};
get(ai, 10404) ->
    {ok, [[1,150601,150603,150606,150607,150608,150610,150611,150613,150624]]};
get(ai, 10407) ->
    {ok, [[1,150650,150651,150652,150653,150654,150655]]};
get(ai, 10410) ->
    {ok, [[1,100314,100315,100316,100317,100318,100319,100320,100321,100322,100323,100324,100325,100326,100327,100328,100329]]};
get(ai, 10645) ->
    {ok, [[1,150700,150701,150702,150703,150704]]};
get(ai, 10646) ->
    {ok, [[1,150700,150701,150702,150703,150704]]};
get(ai, 10647) ->
    {ok, [[1,150700,150701,150702,150703,150704]]};
get(ai, 10648) ->
    {ok, [[1,150751,150752,150753,150754,150755]]};
get(ai, 10651) ->
    {ok, [[1,150800,150801,150802]]};
get(ai, 10652) ->
    {ok, [[1,150800,150801,150802]]};
get(ai, 10653) ->
    {ok, [[1,150800,150801,150802]]};
get(ai, 10654) ->
    {ok, [[1,150850,150851,150852,150853,150854,150855,150856,150857,150858]]};
get(ai, 10655) ->
    {ok, [[1,150851,150852,150853,150854,150855,150856,150857,150858]]};
get(ai, 10656) ->
    {ok, [[1,150851,150852,150853,150854,150855,150856,150857,150858]]};
get(ai, 10657) ->
    {ok, [[1,150851,150852,150853,150854,150855,150856,150857,150858]]};
get(ai, 10658) ->
    {ok, [[1,150851,150852,150853,150854,150855,150856,150857,150858]]};
get(ai, 10659) ->
    {ok, [[1,150901,150902,150903,150900,150904,150905]]};
get(ai, 10660) ->
    {ok, [[1,150950,150951,150952,150953,150954,150955,150956,150957]]};
get(ai, 10661) ->
    {ok, [[1,150950,150951,150952,150953,150954,150955,150956,150957]]};
get(ai, 10662) ->
    {ok, [[1,150950,150951,150952,150953,150954,150955,150956,150957]]};
get(ai, 10663) ->
    {ok, [[1,151000,151001,151002,151003,151004]]};
get(ai, 10411) ->
    {ok, [[1,110000]]};
get(ai, 10412) ->
    {ok, [[1,110001]]};
get(ai, 10414) ->
    {ok, [[1,100572,100652,100653,100654,100605]]};
get(ai, 10415) ->
    {ok, [[1,100572,100652,100653,100654,100605]]};
get(ai, 10416) ->
    {ok, [[1,110004]]};
get(ai, 10417) ->
    {ok, [[1,110001]]};
get(ai, 10418) ->
    {ok, [[1,110011]]};
get(ai, 10419) ->
    {ok, [[1,110001]]};
get(ai, 10420) ->
    {ok, [[1,100572,100652,100653,100654,110000]]};
get(ai, 10421) ->
    {ok, [[1,100572,100652,100653,100654,110001]]};
get(ai, 10422) ->
    {ok, [[1,100572,100652,100653,100654,110001]]};
get(ai, 10425) ->
    {ok, [[1,100572,100652,100653,100654,110002]]};
get(ai, 10426) ->
    {ok, [[1,100572,100652,100653,100654,110010]]};
get(ai, 10427) ->
    {ok, [[1,100572,100652,100653,100654,110004]]};
get(ai, 10428) ->
    {ok, [[1,110000]]};
get(ai, 10429) ->
    {ok, [[1,100572,100652,100653,100654,110000]]};
get(ai, 10430) ->
    {ok, [[1,100572,100652,100653,100654,110010]]};
get(ai, 10431) ->
    {ok, [[1,100572,100652,100653,100654,110015]]};
get(ai, 10432) ->
    {ok, [[1,110000]]};
get(ai, 10433) ->
    {ok, [[1,110014]]};
get(ai, 10434) ->
    {ok, [[1,110014]]};
get(ai, 10435) ->
    {ok, [[1,110014]]};
get(ai, 10436) ->
    {ok, [[1,110014]]};
get(ai, 10437) ->
    {ok, [[1,110014]]};
get(ai, 10438) ->
    {ok, [[1,110000]]};
get(ai, 10439) ->
    {ok, [[1,110015]]};
get(ai, 10440) ->
    {ok, [[1,110015]]};
get(ai, 10441) ->
    {ok, [[1,110015]]};
get(ai, 10442) ->
    {ok, [[1,110015]]};
get(ai, 10443) ->
    {ok, [[1,110002]]};
get(ai, 10444) ->
    {ok, [[1,110005]]};
get(ai, 10445) ->
    {ok, [[1,110006]]};
get(ai, 10446) ->
    {ok, [[1,110010]]};
get(ai, 10447) ->
    {ok, [[1,110006]]};
get(ai, 10448) ->
    {ok, [[1,110000]]};
get(ai, 10449) ->
    {ok, [[1,110007]]};
get(ai, 10450) ->
    {ok, [[1,110007]]};
get(ai, 10451) ->
    {ok, [[1,110011]]};
get(ai, 10452) ->
    {ok, [[1,110019]]};
get(ai, 10453) ->
    {ok, [[1,110000]]};
get(ai, 10454) ->
    {ok, [[1,110008]]};
get(ai, 10455) ->
    {ok, [[1,110019]]};
get(ai, 10456) ->
    {ok, [[1,110011]]};
get(ai, 10457) ->
    {ok, [[1,110006]]};
get(ai, 10458) ->
    {ok, [[1,110019]]};
get(ai, 10459) ->
    {ok, [[1,110006]]};
get(ai, 10460) ->
    {ok, [[1,110019]]};
get(ai, 10461) ->
    {ok, [[1,110002]]};
get(ai, 10468) ->
    {ok, [[1,150042,150160,150161,150043]]};
get(ai, 10469) ->
    {ok, [[1,150042,150160,150161,150043]]};
get(ai, 10470) ->
    {ok, [[1,110002]]};
get(ai, 10474) ->
    {ok, [[1,110007]]};
get(ai, 10475) ->
    {ok, [[1,110000]]};
get(ai, 10476) ->
    {ok, [[1,110000]]};
get(ai, 10480) ->
    {ok, [[1,110007]]};
get(ai, 10481) ->
    {ok, [[1,110006]]};
get(ai, 10482) ->
    {ok, [[1,110002]]};
get(ai, 10483) ->
    {ok, [[1,150203,150204,150214,150205,150206,150207,150208,150209]]};
get(ai, 10484) ->
    {ok, [[1,150203,150204,150214,150205,150206,150207,150208,150209]]};
get(ai, 10485) ->
    {ok, [[1,150203,150204,150214,150205,150206,150207,150208,150209]]};
get(ai, 10486) ->
    {ok, [[1,150203,150204,150214,150205,150206,150207,150208,150209]]};
get(ai, 10487) ->
    {ok, [[1,150203,150204,150214,150205,150206,150207,150208,150209]]};
get(ai, 10488) ->
    {ok, [[1,110007]]};
get(ai, 10489) ->
    {ok, [[1,110000]]};
get(ai, 10490) ->
    {ok, [[1,110007]]};
get(ai, 10491) ->
    {ok, [[1,110006]]};
get(ai, 10492) ->
    {ok, [[1,130303,130304,130305]]};
get(ai, 10493) ->
    {ok, [[1,130303,130304,130305]]};
get(ai, 10494) ->
    {ok, [[1,130303,130304,130305]]};
get(ai, 10495) ->
    {ok, [[1,130350,130352,130353,130354]]};
get(ai, 10496) ->
    {ok, [[1,130350,130352,130353,130354]]};
get(ai, 10497) ->
    {ok, [[1,130350,130352,130353,130354]]};
get(ai, 10498) ->
    {ok, [[1,130350,130352,130353,130354]]};
get(ai, 10499) ->
    {ok, [[1,130350,130352,130353,130354]]};
get(ai, 10501) ->
    {ok, [[1,150358,150365,150367,150368,150369,150370,150371]]};
get(ai, 10502) ->
    {ok, [[1,150360,150366,150367,150368,150369,150370,150371]]};
get(ai, 10503) ->
    {ok, [[1,150400,150401,150402,150403,150404]]};
get(ai, 10504) ->
    {ok, [[1,150400,150401,150402,150403,150404]]};
get(ai, 10505) ->
    {ok, [[1,150400,150401,150402,150403,150404]]};
get(ai, 10506) ->
    {ok, [[1,150400,150401,150402,150403,150404]]};
get(ai, 10507) ->
    {ok, [[1,150400,150401,150402,150403,150404]]};
get(ai, 10508) ->
    {ok, [[1,110018]]};
get(ai, 10509) ->
    {ok, [[1,130503,130504,130505,130509]]};
get(ai, 10510) ->
    {ok, [[1,130503,130504,130505,130509]]};
get(ai, 10511) ->
    {ok, [[1,130503,130504,130505,130509]]};
get(ai, 10512) ->
    {ok, [[1,150550,150551,150552,150553,150554,150555,150556]]};
get(ai, 10513) ->
    {ok, [[1,150557,150558,150559,150560,150561,150562,150563]]};
get(ai, 10514) ->
    {ok, [[1,150564,150566,150567,150568,150569,150570,150571,150572,150573],[2,150574,150575,150576]]};
get(ai, 10515) ->
    {ok, [[1,150577,150578,150579]]};
get(ai, 10516) ->
    {ok, [[1,150577,150578,150579]]};
get(ai, 10517) ->
    {ok, [[1,150614,150615,150616,150617,150624]]};
get(ai, 10518) ->
    {ok, [[1,150619,150620,150621,150624]]};
get(ai, 10519) ->
    {ok, [[1,150619,150620,150621,150624]]};
get(ai, 10520) ->
    {ok, [[1,110013]]};
get(ai, 10521) ->
    {ok, [[1,110022]]};
get(ai, 10675) ->
    {ok, [[1,150704]]};
get(ai, 10676) ->
    {ok, [[1,150704]]};
get(ai, 10677) ->
    {ok, [[1,150704]]};
get(ai, 10678) ->
    {ok, [[1,150755]]};
get(ai, 10681) ->
    {ok, [[1,150802]]};
get(ai, 10682) ->
    {ok, [[1,150802]]};
get(ai, 10683) ->
    {ok, [[1,150802]]};
get(ai, 10684) ->
    {ok, [[1,150859]]};
get(ai, 10685) ->
    {ok, [[1,150859]]};
get(ai, 10686) ->
    {ok, [[1,150859]]};
get(ai, 10687) ->
    {ok, [[1,150859]]};
get(ai, 10688) ->
    {ok, [[1,150859]]};
get(ai, 10690) ->
    {ok, [[1,150958,150959,150960,150961,150962]]};
get(ai, 10691) ->
    {ok, [[1,150958,150959,150960,150961,150962]]};
get(ai, 10692) ->
    {ok, [[1,150958,150959,150960,150961,150962]]};
get(ai, 10693) ->
    {ok, [[1,151004]]};
get(ai, 10573) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 10574) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 10575) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 10579) ->
    {ok, [[1,150032,150156,150157,150033,150035]]};
get(ai, 10580) ->
    {ok, [[1,150032,150156,150157,150033,150035]]};
get(ai, 10594) ->
    {ok, [[1,150203,150204,150214,150205,150206,150207,150208,150209]]};
get(ai, 10595) ->
    {ok, [[1,150203,150204,150214,150205,150206,150207,150208,150209]]};
get(ai, 10596) ->
    {ok, [[1,150203,150204,150214,150205,150206,150207,150208,150209]]};
get(ai, 10597) ->
    {ok, [[1,150203,150204,150214,150205,150206,150207,150208,150209]]};
get(ai, 10598) ->
    {ok, [[1,150203,150204,150214,150205,150206,150207,150208,150209]]};
get(ai, 10603) ->
    {ok, [[1,130306,130307,130308,130305]]};
get(ai, 10604) ->
    {ok, [[1,130306,130307,130308,130305]]};
get(ai, 10605) ->
    {ok, [[1,130306,130307,130308,130305]]};
get(ai, 10606) ->
    {ok, [[1,130351,130352,130353,130354]]};
get(ai, 10607) ->
    {ok, [[1,130351,130352,130353,130354]]};
get(ai, 10608) ->
    {ok, [[1,130351,130352,130353,130354]]};
get(ai, 10609) ->
    {ok, [[1,130351,130352,130353,130354]]};
get(ai, 10610) ->
    {ok, [[1,130351,130352,130353,130354]]};
get(ai, 10611) ->
    {ok, [[1,130356,130364,130367,130368,130369,130370,130371]]};
get(ai, 10612) ->
    {ok, [[1,130356,130364,130367,130368,130369,130370,130371]]};
get(ai, 10613) ->
    {ok, [[1,130356,130364,130367,130368,130369,130370,130371]]};
get(ai, 10614) ->
    {ok, [[1,150405,150404]]};
get(ai, 10615) ->
    {ok, [[1,150405,150404]]};
get(ai, 10616) ->
    {ok, [[1,150405,150404]]};
get(ai, 10617) ->
    {ok, [[1,150405,150404]]};
get(ai, 10618) ->
    {ok, [[1,150405,150404]]};
get(ai, 10620) ->
    {ok, [[1,130506,130507,130508,130509]]};
get(ai, 10621) ->
    {ok, [[1,130506,130507,130508,130509]]};
get(ai, 10622) ->
    {ok, [[1,130506,130507,130508,130509]]};
get(ai, 10623) ->
    {ok, [[1,150577,150578,150579]]};
get(ai, 10624) ->
    {ok, [[1,150577,150578,150579]]};
get(ai, 10625) ->
    {ok, [[1,150577,150578,150579]]};
get(ai, 10626) ->
    {ok, [[1,150577,150578,150579]]};
get(ai, 10627) ->
    {ok, [[1,150577,150578,150579]]};
get(ai, 10628) ->
    {ok, [[1,150614,150615,150616,150617,150624]]};
get(ai, 10629) ->
    {ok, [[1,150622,150623,150624]]};
get(ai, 10630) ->
    {ok, [[1,150622,150623,150624]]};
get(ai, 10705) ->
    {ok, [[1,150704]]};
get(ai, 10706) ->
    {ok, [[1,150704]]};
get(ai, 10707) ->
    {ok, [[1,150704]]};
get(ai, 10708) ->
    {ok, [[1,150755]]};
get(ai, 10711) ->
    {ok, [[1,150802]]};
get(ai, 10712) ->
    {ok, [[1,150802]]};
get(ai, 10713) ->
    {ok, [[1,150802]]};
get(ai, 10714) ->
    {ok, [[1,150859]]};
get(ai, 10715) ->
    {ok, [[1,150859]]};
get(ai, 10716) ->
    {ok, [[1,150859]]};
get(ai, 10717) ->
    {ok, [[1,150859]]};
get(ai, 10718) ->
    {ok, [[1,150859]]};
get(ai, 10723) ->
    {ok, [[1,151004]]};
get(ai, 11318) ->
    {ok, [[1,100572,100652,100653,100654,100708,100709,100710,100711,100712,100713,100714,100715,100716,100717]]};
get(ai, 11319) ->
    {ok, [[1,100572,100652,100653,100654,100708,100709,100710,100711,100712,100713,100714,100715,100716,100717]]};
get(ai, 11320) ->
    {ok, [[1,100572,100652,100653,100654,100718,100719,100720,100721,100722,100723,100724,100725,100726,100727]]};
get(ai, 11321) ->
    {ok, [[1,100081,100082,100083,100084,100085,100086,100087,100088,100089,100090]]};
get(ai, 11322) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 11323) ->
    {ok, [[1,100655,100656,100657,100658,100659,100660,100661,100662,100663]]};
get(ai, 11324) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 11325) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 11326) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 11327) ->
    {ok, [[1,100081,100082,100083,100084,100085,100086,100087,100088,100089,100090]]};
get(ai, 11328) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 11329) ->
    {ok, [[1,100091,100092,100093,100094,100095,100096,100097,100098,100099,100100]]};
get(ai, 11330) ->
    {ok, [[1,100101,100102,100103,100104,100105,100106,100107,100108,100109,100110]]};
get(ai, 11331) ->
    {ok, [[1,100101,100102,100103,100104,100105,100106,100107,100108,100109,100110]]};
get(ai, 11332) ->
    {ok, [[1,100111,100112,100113,100114,100115,100116,100117,100118,100119]]};
get(ai, 11333) ->
    {ok, [[1,100126,100127,100128,100129,100130,100131,100132,100133,100134,100135,100136,100137]]};
get(ai, 11334) ->
    {ok, [[1,100138,100139,100140,100141,100142,100143,100144,100145,100146,100147,100148,100149]]};
get(ai, 11335) ->
    {ok, [[1,100150,100151,100152,100153,100154,100155,100156,100157,100158,100159,100160,100161]]};
get(ai, 11336) ->
    {ok, [[1,100138,100139,100140,100141,100142,100143,100144,100145,100146,100147,100148,100149]]};
get(ai, 11337) ->
    {ok, [[1,100150,100151,100152,100153,100154,100155,100156,100157,100158,100159,100160,100161]]};
get(ai, 11338) ->
    {ok, [[1,100627,100618,100616,100617,100619,100620,100621,100622,100623,100624,100626,100628]]};
get(ai, 11339) ->
    {ok, [[1,100126,100127,100128,100129,100130,100131,100132,100133,100134,100135,100136,100137]]};
get(ai, 11340) ->
    {ok, [[1,100150,100151,100152,100153,100154,100155,100156,100157,100158,100159,100160,100161]]};
get(ai, 11341) ->
    {ok, [[1,100162,100163,100164,100165,100166,100167,100168,100169,100170,100171,100172,100173]]};
get(ai, 11342) ->
    {ok, [[1,100150,100151,100152,100153,100154,100155,100156,100157,100158,100159,100160,100161]]};
get(ai, 11343) ->
    {ok, [[1,100138,100139,100140,100141,100142,100143,100144,100145,100146,100147,100148,100149]]};
get(ai, 11344) ->
    {ok, [[1,100174,100175,100176,100177,100178,100179,100180,100181,100182,100183,100184,100185]]};
get(ai, 11345) ->
    {ok, [[1,100150,100151,100152,100153,100154,100155,100156,100157,100158,100159,100160,100161]]};
get(ai, 11346) ->
    {ok, [[1,100138,100139,100140,100141,100142,100143,100144,100145,100146,100147,100148,100149]]};
get(ai, 11347) ->
    {ok, [[1,100186,100187,100188,100189,100190,100191,100192,100193,100194,100195,100196,100197,100198,100199,100200,100201,100202,100203,100204,100205]]};
get(ai, 11348) ->
    {ok, [[1,100138,100139,100140,100141,100142,100143,100144,100145,100146,100147,100148,100149]]};
get(ai, 11349) ->
    {ok, [[1,100162,100163,100164,100165,100166,100167,100168,100169,100170,100171,100172,100173]]};
get(ai, 11350) ->
    {ok, [[1,100186,100187,100188,100189,100190,100191,100192,100193,100194,100195,100196,100197,100198,100199,100200,100201,100202,100203,100204,100205]]};
get(ai, 11357) ->
    {ok, [[1,130011,130012,130013,130014,130015,130016,130017]]};
get(ai, 11358) ->
    {ok, [[1,130011,130012,130013,130014,130015,130016,130017]]};
get(ai, 11359) ->
    {ok, [[1,130045,130046,130047,130048,130049,130050,130051,130052,130053,130054]]};
get(ai, 11360) ->
    {ok, [[1,130059,130060,130061,130062,130063,130064,130065,130066,130067,130068,130069]]};
get(ai, 11361) ->
    {ok, [[1,130059,130060,130061,130062,130063,130064,130065,130066,130067,130068,130069]]};
get(ai, 11362) ->
    {ok, [[1,130059,130060,130061,130062,130063,130064,130065,130066,130067,130068,130069]]};
get(ai, 11363) ->
    {ok, [[1,130069,130120,130121,130122,130070,130071,130072]]};
get(ai, 11364) ->
    {ok, [[1,100206,100207,100208,100209,100210,100211,100212,100213,100214,100215,100216,100217,100218,100219,100220,100221,100222]]};
get(ai, 11365) ->
    {ok, [[1,100257,100258,100259,100260,100261,100262,100263,100264,100265,100266,100267,100268,100269,100270,100271,100272,100273]]};
get(ai, 11369) ->
    {ok, [[1,100223,100224,100225,100225,100226,100227,100228,100229,100230,100231,100232,100233,100234,100235,100236,100237,100238]]};
get(ai, 11370) ->
    {ok, [[1,100257,100258,100259,100260,100261,100262,100263,100264,100265,100266,100267,100268,100269,100270,100271,100272,100273]]};
get(ai, 11371) ->
    {ok, [[1,130148,130149,130150,130151,130152,130153,130154,130155]]};
get(ai, 11372) ->
    {ok, [[1,130200,130201,130202]]};
get(ai, 11373) ->
    {ok, [[1,130210,130211,130202]]};
get(ai, 11374) ->
    {ok, [[1,130212,130213,130202]]};
get(ai, 11375) ->
    {ok, [[1,130200,130201,130202]]};
get(ai, 11376) ->
    {ok, [[1,130200,130201,130202]]};
get(ai, 11377) ->
    {ok, [[1,130250,130251,130252,130253,130254,130255,130256,130257]]};
get(ai, 11378) ->
    {ok, [[1,100257,100258,100259,100260,100261,100262,100263,100264,100265,100266,100267,100268,100269,100270,100271,100272,100273]]};
get(ai, 11379) ->
    {ok, [[1,100274,100275,100276,100277,100278,100279,100280,100281,100282,100283,100284,100285,100286,100287,100288,100289,100290]]};
get(ai, 11380) ->
    {ok, [[1,130250,130251,130252,130253,130254,130255,130256,130257]]};
get(ai, 11381) ->
    {ok, [[1,130300,130301,130302]]};
get(ai, 11382) ->
    {ok, [[1,130300,130301,130302]]};
get(ai, 11383) ->
    {ok, [[1,130300,130301,130302]]};
get(ai, 11384) ->
    {ok, [[1,130352,130353,130354]]};
get(ai, 11385) ->
    {ok, [[1,130352,130353,130354]]};
get(ai, 11386) ->
    {ok, [[1,130352,130353,130354]]};
get(ai, 11390) ->
    {ok, [[1,130352,130353,130354]]};
get(ai, 11391) ->
    {ok, [[1,130352,130353,130354]]};
get(ai, 11388) ->
    {ok, [[1,130357,130361,130362,130363]]};
get(ai, 11389) ->
    {ok, [[1,130357,130361,130362,130363]]};
get(ai, 11392) ->
    {ok, [[1,130405]]};
get(ai, 11405) ->
    {ok, [[1,130405]]};
get(ai, 11406) ->
    {ok, [[1,130405]]};
get(ai, 11393) ->
    {ok, [[1,130405]]};
get(ai, 11394) ->
    {ok, [[1,130405]]};
get(ai, 11395) ->
    {ok, [[1,130450,130451,130452,130453,130454,130455,130456]]};
get(ai, 11396) ->
    {ok, [[1,130500,130501,130502,130509]]};
get(ai, 11397) ->
    {ok, [[1,130500,130501,130502,130509]]};
get(ai, 11398) ->
    {ok, [[1,130500,130501,130502,130509]]};
get(ai, 11399) ->
    {ok, [[1,130577,130578,130579]]};
get(ai, 11400) ->
    {ok, [[1,130577,130578,130579]]};
get(ai, 11401) ->
    {ok, [[1,130577,130578,130579]]};
get(ai, 11408) ->
    {ok, [[1,130564,130565,130566,130567,130568,130569,130570,130571,130572,130573],[2,130574,130575,130576]]};
get(ai, 11409) ->
    {ok, [[1,130564,130565,130566,130567,130568,130569,130570,130571,130572,130573],[2,130574,130575,130576]]};
get(ai, 11402) ->
    {ok, [[1,130618,130624]]};
get(ai, 11403) ->
    {ok, [[1,130600,130602,130604,130605,130609,130612,130624]]};
get(ai, 11404) ->
    {ok, [[1,130601,130603,130606,130607,130608,130610,130611,130613,130624]]};
get(ai, 11407) ->
    {ok, [[1,130650,130651,130652,130653,130654,130655]]};
get(ai, 11410) ->
    {ok, [[1,100314,100315,100316,100317,100318,100319,100320,100321,100322,100323,100324,100325,100326,100327,100328,100329]]};
get(ai, 11645) ->
    {ok, [[1,130700,130701,130702,130703,130708]]};
get(ai, 11646) ->
    {ok, [[1,130700,130701,130702,130703,130708]]};
get(ai, 11647) ->
    {ok, [[1,130700,130701,130702,130703,130708]]};
get(ai, 11648) ->
    {ok, [[1,130751,130752,130753,130754,130755]]};
get(ai, 11651) ->
    {ok, [[1,130800,130801,130802]]};
get(ai, 11652) ->
    {ok, [[1,130800,130801,130802]]};
get(ai, 11653) ->
    {ok, [[1,130800,130801,130802]]};
get(ai, 11654) ->
    {ok, [[1,130850,130851,130852,130853,130854,130855,130856,130857,130858]]};
get(ai, 11655) ->
    {ok, [[1,130851,130852,130853,130854,130855,130856,130857,130858]]};
get(ai, 11656) ->
    {ok, [[1,130851,130852,130853,130854,130855,130856,130857,130858]]};
get(ai, 11657) ->
    {ok, [[1,130851,130852,130853,130854,130855,130856,130857,130858]]};
get(ai, 11658) ->
    {ok, [[1,130851,130852,130853,130854,130855,130856,130857,130858]]};
get(ai, 11659) ->
    {ok, [[1,130901,130902,130903,130900,130904,130905]]};
get(ai, 11660) ->
    {ok, [[1,130950,130951,130952,130953,130954,130955,130956,130957]]};
get(ai, 11661) ->
    {ok, [[1,130950,130951,130952,130953,130954,130955,130956,130957]]};
get(ai, 11662) ->
    {ok, [[1,130950,130951,130952,130953,130954,130955,130956,130957]]};
get(ai, 11663) ->
    {ok, [[1,131000,131001,131002,131003,131004]]};
get(ai, 11414) ->
    {ok, [[1,100572,100652,100653,100654,110014]]};
get(ai, 11415) ->
    {ok, [[1,100572,100652,100653,100654,110014]]};
get(ai, 11426) ->
    {ok, [[1,100572,100652,100653,100654,110015]]};
get(ai, 11427) ->
    {ok, [[1,100572,100652,100653,100654,110002]]};
get(ai, 11429) ->
    {ok, [[1,100572,100652,100653,100654,110000]]};
get(ai, 11430) ->
    {ok, [[1,100572,100652,100653,100654,110010]]};
get(ai, 11431) ->
    {ok, [[1,100572,100652,100653,100654,110015]]};
get(ai, 11432) ->
    {ok, [[1,110000]]};
get(ai, 11433) ->
    {ok, [[1,110014]]};
get(ai, 11434) ->
    {ok, [[1,110014]]};
get(ai, 11435) ->
    {ok, [[1,110014]]};
get(ai, 11436) ->
    {ok, [[1,110014]]};
get(ai, 11437) ->
    {ok, [[1,110014]]};
get(ai, 11438) ->
    {ok, [[1,110000]]};
get(ai, 11439) ->
    {ok, [[1,110015]]};
get(ai, 11440) ->
    {ok, [[1,110015]]};
get(ai, 11441) ->
    {ok, [[1,110015]]};
get(ai, 11442) ->
    {ok, [[1,110015]]};
get(ai, 11443) ->
    {ok, [[1,110002]]};
get(ai, 11444) ->
    {ok, [[1,110008]]};
get(ai, 11445) ->
    {ok, [[1,110007]]};
get(ai, 11446) ->
    {ok, [[1,110011]]};
get(ai, 11447) ->
    {ok, [[1,110007]]};
get(ai, 11448) ->
    {ok, [[1,110001]]};
get(ai, 11449) ->
    {ok, [[1,110018]]};
get(ai, 11450) ->
    {ok, [[1,110018]]};
get(ai, 11451) ->
    {ok, [[1,110011]]};
get(ai, 11452) ->
    {ok, [[1,110019]]};
get(ai, 11453) ->
    {ok, [[1,110001]]};
get(ai, 11454) ->
    {ok, [[1,110007]]};
get(ai, 11455) ->
    {ok, [[1,110019]]};
get(ai, 11456) ->
    {ok, [[1,110011]]};
get(ai, 11457) ->
    {ok, [[1,110007]]};
get(ai, 11458) ->
    {ok, [[1,110019]]};
get(ai, 11459) ->
    {ok, [[1,110007]]};
get(ai, 11460) ->
    {ok, [[1,110019]]};
get(ai, 11461) ->
    {ok, [[1,110001]]};
get(ai, 11468) ->
    {ok, [[1,130042,130160,130161,130043]]};
get(ai, 11469) ->
    {ok, [[1,130042,130160,130161,130043]]};
get(ai, 11470) ->
    {ok, [[1,110002]]};
get(ai, 11471) ->
    {ok, [[1,130068]]};
get(ai, 11472) ->
    {ok, [[1,130063,130064,130065,130066,130067,130059,130060,130061,130062,130068,130069]]};
get(ai, 11473) ->
    {ok, [[1,130063,130064,130065,130066,130067,130059,130060,130061,130062,130068,130069]]};
get(ai, 11474) ->
    {ok, [[1,110007]]};
get(ai, 11475) ->
    {ok, [[1,110000]]};
get(ai, 11476) ->
    {ok, [[1,110000]]};
get(ai, 11480) ->
    {ok, [[1,110007]]};
get(ai, 11481) ->
    {ok, [[1,110006]]};
get(ai, 11482) ->
    {ok, [[1,110002]]};
get(ai, 11483) ->
    {ok, [[1,130203,130204,130214,130205,130206,130207,130208,130209]]};
get(ai, 11484) ->
    {ok, [[1,130203,130204,130214,130205,130206,130207,130208,130209]]};
get(ai, 11485) ->
    {ok, [[1,130203,130204,130214,130205,130206,130207,130208,130209]]};
get(ai, 11486) ->
    {ok, [[1,130203,130204,130214,130205,130206,130207,130208,130209]]};
get(ai, 11487) ->
    {ok, [[1,130203,130204,130214,130205,130206,130207,130208,130209]]};
get(ai, 11488) ->
    {ok, [[1,110007]]};
get(ai, 11489) ->
    {ok, [[1,110000]]};
get(ai, 11490) ->
    {ok, [[1,110007]]};
get(ai, 11491) ->
    {ok, [[1,110006]]};
get(ai, 11492) ->
    {ok, [[1,130303,130304,130305]]};
get(ai, 11493) ->
    {ok, [[1,130303,130304,130305]]};
get(ai, 11494) ->
    {ok, [[1,130303,130304,130305]]};
get(ai, 11495) ->
    {ok, [[1,130350,130352,130353,130354]]};
get(ai, 11496) ->
    {ok, [[1,130350,130352,130353,130354]]};
get(ai, 11497) ->
    {ok, [[1,130350,130352,130353,130354]]};
get(ai, 11498) ->
    {ok, [[1,130350,130352,130353,130354]]};
get(ai, 11499) ->
    {ok, [[1,130350,130352,130353,130354]]};
get(ai, 11503) ->
    {ok, [[1,130400,130401,130402,130403,130404]]};
get(ai, 11504) ->
    {ok, [[1,130400,130401,130402,130403,130404]]};
get(ai, 11505) ->
    {ok, [[1,130400,130401,130402,130403,130404]]};
get(ai, 11506) ->
    {ok, [[1,130400,130401,130402,130403,130404]]};
get(ai, 11507) ->
    {ok, [[1,130400,130401,130402,130403,130404]]};
get(ai, 11508) ->
    {ok, [[1,110018]]};
get(ai, 11509) ->
    {ok, [[1,130503,130504,130505,130509]]};
get(ai, 11510) ->
    {ok, [[1,130503,130504,130505,130509]]};
get(ai, 11511) ->
    {ok, [[1,130503,130504,130505,130509]]};
get(ai, 11512) ->
    {ok, [[1,130550,130551,130552,130553,130554,130555,130556]]};
get(ai, 11513) ->
    {ok, [[1,130550,130551,130552,130553,130554,130555,130556]]};
get(ai, 11514) ->
    {ok, [[1,130564,130566,130567,130568,130569,130570,130571,130572,130573],[2,130574,130575,130576]]};
get(ai, 11515) ->
    {ok, [[1,130564,130566,130567,130568,130569,130570,130571,130572,130573],[2,130574,130575,130576]]};
get(ai, 11516) ->
    {ok, [[1,130577,130578,130579]]};
get(ai, 11517) ->
    {ok, [[1,130614,130615,130616,130617,130624]]};
get(ai, 11518) ->
    {ok, [[1,130619,130620,130621,130624]]};
get(ai, 11519) ->
    {ok, [[1,130619,130620,130621,130624]]};
get(ai, 11520) ->
    {ok, [[1,110013]]};
get(ai, 11521) ->
    {ok, [[1,110022]]};
get(ai, 11675) ->
    {ok, [[1,130704,130705,130708]]};
get(ai, 11676) ->
    {ok, [[1,130704,130705,130708]]};
get(ai, 11677) ->
    {ok, [[1,130704,130705,130708]]};
get(ai, 11678) ->
    {ok, [[1,130755,130756]]};
get(ai, 11681) ->
    {ok, [[1,130802,130803]]};
get(ai, 11682) ->
    {ok, [[1,130802,130803]]};
get(ai, 11683) ->
    {ok, [[1,130802,130803]]};
get(ai, 11684) ->
    {ok, [[1,130859,130860]]};
get(ai, 11685) ->
    {ok, [[1,130859,130860]]};
get(ai, 11686) ->
    {ok, [[1,130859,130860]]};
get(ai, 11687) ->
    {ok, [[1,130859,130860]]};
get(ai, 11688) ->
    {ok, [[1,130859,130860]]};
get(ai, 11690) ->
    {ok, [[1,130958,130959,130960,130961,130962]]};
get(ai, 11691) ->
    {ok, [[1,130958,130959,130960,130961,130962]]};
get(ai, 11692) ->
    {ok, [[1,130958,130959,130960,130961,130962]]};
get(ai, 11693) ->
    {ok, [[1,131004]]};
get(ai, 11537) ->
    {ok, [[1,100572,100652,100653,100654,110018]]};
get(ai, 11538) ->
    {ok, [[1,100572,100652,100653,100654,110014]]};
get(ai, 11573) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 11574) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 11575) ->
    {ok, [[1,130006,130007,130008,130009,130010]]};
get(ai, 11582) ->
    {ok, [[1,130068]]};
get(ai, 11583) ->
    {ok, [[1,130068]]};
get(ai, 11584) ->
    {ok, [[1,130061,130062,130063,130064,130065,130066,130067,130059,130060,130068,130069]]};
get(ai, 11594) ->
    {ok, [[1,130203,130204,130205,130206,130207,130208,130209]]};
get(ai, 11595) ->
    {ok, [[1,130203,130204,130205,130206,130207,130208,130209]]};
get(ai, 11596) ->
    {ok, [[1,130203,130204,130205,130206,130207,130208,130209]]};
get(ai, 11597) ->
    {ok, [[1,130203,130204,130205,130206,130207,130208,130209]]};
get(ai, 11598) ->
    {ok, [[1,130203,130204,130205,130206,130207,130208,130209]]};
get(ai, 11603) ->
    {ok, [[1,130306,130307,130308,130305]]};
get(ai, 11604) ->
    {ok, [[1,130306,130307,130308,130305]]};
get(ai, 11605) ->
    {ok, [[1,130306,130307,130308,130305]]};
get(ai, 11606) ->
    {ok, [[1,130351,130352,130353,130354]]};
get(ai, 11607) ->
    {ok, [[1,130351,130352,130353,130354]]};
get(ai, 11608) ->
    {ok, [[1,130351,130352,130353,130354]]};
get(ai, 11609) ->
    {ok, [[1,130351,130352,130353,130354]]};
get(ai, 11610) ->
    {ok, [[1,130351,130352,130353,130354]]};
get(ai, 11611) ->
    {ok, [[1,130356,130364,130367,130368,130369,130370,130371]]};
get(ai, 11612) ->
    {ok, [[1,130356,130364,130367,130368,130369,130370,130371]]};
get(ai, 11613) ->
    {ok, [[1,130356,130364,130367,130368,130369,130370,130371]]};
get(ai, 11614) ->
    {ok, [[1,130405,130404]]};
get(ai, 11615) ->
    {ok, [[1,130405,130404]]};
get(ai, 11616) ->
    {ok, [[1,130405,130404]]};
get(ai, 11617) ->
    {ok, [[1,130405,130404]]};
get(ai, 11618) ->
    {ok, [[1,130405,130404]]};
get(ai, 11620) ->
    {ok, [[1,130506,130507,130508,130509]]};
get(ai, 11621) ->
    {ok, [[1,130506,130507,130508,130509]]};
get(ai, 11622) ->
    {ok, [[1,130506,130507,130508,130509]]};
get(ai, 11623) ->
    {ok, [[1,130577,130578,130579]]};
get(ai, 11624) ->
    {ok, [[1,130577,130578,130579]]};
get(ai, 11625) ->
    {ok, [[1,130577,130578,130579]]};
get(ai, 11626) ->
    {ok, [[1,130577,130578,130579]]};
get(ai, 11627) ->
    {ok, [[1,130577,130578,130579]]};
get(ai, 11628) ->
    {ok, [[1,130614,130615,130616,130617,130624]]};
get(ai, 11629) ->
    {ok, [[1,130622,130623,130624]]};
get(ai, 11630) ->
    {ok, [[1,130622,130623,130624]]};
get(ai, 11705) ->
    {ok, [[1,130706,130707,130708]]};
get(ai, 11706) ->
    {ok, [[1,130706,130707,130708]]};
get(ai, 11707) ->
    {ok, [[1,130706,130707,130708]]};
get(ai, 11708) ->
    {ok, [[1,130755]]};
get(ai, 11711) ->
    {ok, [[1,130802,130803]]};
get(ai, 11712) ->
    {ok, [[1,130802,130803]]};
get(ai, 11713) ->
    {ok, [[1,130802,130803]]};
get(ai, 11714) ->
    {ok, [[1,130859,130860]]};
get(ai, 11715) ->
    {ok, [[1,130859,130860]]};
get(ai, 11716) ->
    {ok, [[1,130859,130860]]};
get(ai, 11717) ->
    {ok, [[1,130859,130860]]};
get(ai, 11718) ->
    {ok, [[1,130859,130860]]};
get(ai, 11723) ->
    {ok, [[1,131004]]};
get(ai, 13022) ->
    {ok, [[1,100728,100729,100732,100733,100734,100735,100736]]};
get(ai, 13000) ->
    {ok, [[1,100669,100670,100674,100671,100672,100673]]};
get(ai, 13001) ->
    {ok, [[1,100675,100676,100677,100678,100679]]};
get(ai, 13002) ->
    {ok, [[1,100680,100681,100682,100683,100684,100685,100686,100687,100688,100689]]};
get(ai, 13003) ->
    {ok, [[1,100690,100692,100691]]};
get(ai, 13004) ->
    {ok, [[1,100700,100701,100695,100696,100697,100698,100699]]};
get(ai, 13005) ->
    {ok, [[1,100702,100703,100704,100705,100707,100706]]};
get(ai, 13013) ->
    {ok, [[1,100693,1006941]]};
get(ai, 14001) ->
    {ok, [[1,100006,100007,100008,100009,100010,100011,100012,100013,100014,100015,100016,100017,100018,100019,100020,100021]]};
get(ai, 14002) ->
    {ok, [[1,100006,100007,100008,100009,100010,100011,100012,100013,100014,100015,100016,100017,100018,100019,100020,100021]]};
get(ai, 14003) ->
    {ok, [[1,100006,100007,100008,100009,100010,100011,100012,100013,100014,100015,100016,100017,100018,100019,100020,100021]]};
get(ai, 14004) ->
    {ok, [[1,100006,100007,100008,100009,100010,100011,100012,100013,100014,100015,100016,100017,100018,100019,100020,100021]]};
get(ai, 14005) ->
    {ok, [[1,100006,100007,100008,100009,100010,100011,100012,100013,100014,100015,100016,100017,100018,100019,100020,100021]]};
get(ai, 14011) ->
    {ok, [[1,100351,100352,100353,100354,100355,100356,100357,100358,100359,100360,100361,100362,100363,100364,100365,100366,100367,100368,100369,100370,100371,100372]]};
get(ai, 14012) ->
    {ok, [[1,100373,100374,100375,100376,100377,100378,100379,100380,100381,100382,100383,100384]]};
get(ai, 14013) ->
    {ok, [[1,100385,100386,100387,100388,100389,100390,100391,100392,100393]]};
get(ai, 14014) ->
    {ok, [[1,100394,100395,100396,100397,100398,100399,100400,100401,100402,100403,100404,100405,100406,100407,100408,100409,100410,100411]]};
get(ai, 14015) ->
    {ok, [[1,100412,100413,100414,100415,100416,100417,100418,100419,100420,100421]]};
get(ai, 14016) ->
    {ok, [[1,100422,100423,100424,100425,100426,100427,100428,100429,100430,100431,100432,100433,100434,100435,100436,100437,100438,100439,100440]]};
get(ai, 14017) ->
    {ok, [[1,100441,100442,100443,100444,100445,100446,100447,100448,100449,100450]]};
get(ai, 14018) ->
    {ok, [[1,100451,100452,100453,100454,100455,100456,100457,100458,100459,100460,100461]]};
get(ai, 14019) ->
    {ok, [[1,100462,100463,100464,100465,100466,100467,100468,100469,100470,100471,100472,100473,100474,100475]]};
get(ai, 14020) ->
    {ok, [[1,100476,100477,100478,100479,100480,100481,100482,100483,100484,100485,100486,100487,100488]]};
get(ai, 14021) ->
    {ok, [[1,100489,100490,100491,100492,100493,100494,100495,100496,100497,100498,100499,100500,100501,100502]]};
get(ai, 14022) ->
    {ok, [[1,100503,100504,100505,100506,100507,100508,100509,100510,100511,100512,100513,100514,100515,100516]]};
get(ai, 14023) ->
    {ok, [[1,100517,100518,100519,100520,100521,100522,100523,100524,100525,100526,100527,100528]]};
get(ai, 14024) ->
    {ok, [[1,100529,100530,100531,100532,100533,100534,100535,100536,100537,100538,100539,100540,100541]]};
get(ai, 14025) ->
    {ok, [[1,100544,100545,100546,100547,100548,100549,100550,100551,100552,100553,100554,100555,100556,100557]]};
get(ai, 14026) ->
    {ok, [[1,100558,100559,100560,100561,100562,100563,100564,100565,100566,100567,100568,100569,100570,100571]]};
get(ai, 14027) ->
    {ok, [[1,11623,11624,11625,11626,11627,11628,11629,11630,11631,11632,11633,11634]]};
get(ai, 14028) ->
    {ok, [[1,11650,11651,11652,11653,11654,11655,11656,11657,11658,11659]]};
get(ai, 14029) ->
    {ok, [[1,11660,11661,11662,11663,11664,11665,11666,11667,11668,11669,11670,11671,11672,11673]]};
get(ai, 14030) ->
    {ok, [[1,11677,11678,11679,11680,11681,11682,11683,11684,11685,11686,11687,11688]]};
get(ai, 14031) ->
    {ok, [[1,102005,102006,102007,102008,102009]]};
get(ai, 14032) ->
    {ok, [[1,102000,102001,102002,102003,102004]]};
get(ai, 14033) ->
    {ok, [[1,102005,102006,102007,102008,102009]]};
get(ai, 14034) ->
    {ok, [[1,102000,102001,102002,102003,102004]]};
get(ai, 14035) ->
    {ok, [[1,102010,102011,102012,102013,102014]]};
get(ai, 14036) ->
    {ok, [[1,102010,102011,102012,102013,102014]]};
get(ai, 14037) ->
    {ok, [[1,102020,102021,102022,102023,102024]]};
get(ai, 14038) ->
    {ok, [[1,102015,102016,102017,102018,102019]]};
get(ai, 14039) ->
    {ok, [[1,102030,102031,102032,102033,102034]]};
get(ai, 14040) ->
    {ok, [[1,102010,102011,102012,102013,102014]]};
get(ai, 14041) ->
    {ok, [[1,102020,102021,102022,102023,102024]]};
get(ai, 14042) ->
    {ok, [[1,102035,102036,102037,102038,102039]]};
get(ai, 14043) ->
    {ok, [[1,102035,102036,102037,102038,102039]]};
get(ai, 14044) ->
    {ok, [[1,102010,102011,102012,102013,102014]]};
get(ai, 14045) ->
    {ok, [[1,102005,102006,102007,102008,102009]]};
get(ai, 14046) ->
    {ok, [[1,102015,102016,102017,102018,102019]]};
get(ai, 14047) ->
    {ok, [[1,102025,102026,102027,102028,102029]]};
get(ai, 14048) ->
    {ok, [[1,102020,102021,102022,102023,102024]]};
get(ai, 14049) ->
    {ok, [[1,102015,102016,102017,102018,102019]]};
get(ai, 14050) ->
    {ok, [[1,102025,102026,102027,102028,102029]]};
get(ai, 14051) ->
    {ok, [[1,102030,102031,102032,102033,102034]]};
get(ai, 14052) ->
    {ok, [[1,102030,102031,102032,102033,102034]]};
get(ai, 14053) ->
    {ok, [[1,102000,102001,102002,102003,102004]]};
get(ai, 14054) ->
    {ok, [[1,102030,102031,102032,102033,102034]]};
get(ai, 14055) ->
    {ok, [[1,102020,102021,102022,102023,102024]]};
get(ai, 14056) ->
    {ok, [[1,102030,102031,102032,102033,102034]]};
get(ai, 14057) ->
    {ok, [[1,102025,102026,102027,102028,102029]]};
get(ai, 14058) ->
    {ok, [[1,102015,102016,102017,102018,102019]]};
get(ai, 14059) ->
    {ok, [[1,102035,102036,102037,102038,102039]]};
get(ai, 14060) ->
    {ok, [[1,102010,102011,102012,102013,102014]]};
get(ai, 14061) ->
    {ok, [[1,102035,102036,102037,102038,102039]]};
get(ai, 14062) ->
    {ok, [[1,102015,102016,102017,102018,102019]]};
get(ai, 14063) ->
    {ok, [[1,102025,102026,102027,102028,102029]]};
get(ai, 14064) ->
    {ok, [[1,102005,102006,102007,102008,102009]]};
get(ai, 14065) ->
    {ok, [[1,102020,102021,102022,102023,102024]]};
get(ai, 14066) ->
    {ok, [[1,102025,102026,102027,102028,102029]]};
get(ai, 14067) ->
    {ok, [[1,102035,102036,102037,102038,102039]]};
get(ai, 14068) ->
    {ok, [[1,102000,102001,102002,102003,102004]]};
get(ai, 14069) ->
    {ok, [[1,102000,102001,102002,102003,102004]]};
get(ai, 14070) ->
    {ok, [[1,102005,102006,102007,102008,102009]]};
get(ai, 15011) ->
    {ok, [[1,11378,11379,11380,11381,11382,11383,11384,11385,11386,11387,11388,11389,11390,11391,11392,11393,11394,11395,11396,11397]]};
get(ai, 15012) ->
    {ok, [[1,11343,11344,11345,11346,11347,11348,11349,11350,11351,11352,11353,11354,11355,11356,11357,11358,11359,11360]]};
get(ai, 15013) ->
    {ok, [[1,11328,11329,11330,11331,11332,11334,11335,11336,11337,11338,11339,11340,11341,11342]]};
get(ai, 15014) ->
    {ok, [[1,11532,11533,11534,11535,11536,11537,11538,11539,11540,11541,11542,11543,11544,11545,11546,11547,11548,11549,11550,11551,11552,11553,11554,11555,11556]]};
get(ai, 15015) ->
    {ok, [[1,11419,11420,11421,11422,11423,11424,11425,11426,11427,11428,11429,11430,11431,11432,11433,11434,11435,11436,11437,11438,11439,11440,11441,11442]]};
get(ai, 16000) ->
    {ok, [[1,103000,103001]]};
get(ai, 16001) ->
    {ok, [[1,103002,103003]]};
get(ai, 16002) ->
    {ok, [[1,103004,103005]]};
get(ai, 16003) ->
    {ok, [[1,103000,103001]]};
get(ai, 16004) ->
    {ok, [[1,103002,103003]]};
get(ai, 16005) ->
    {ok, [[1,103004,103005]]};
get(ai, 16006) ->
    {ok, [[1,103000,103001]]};
get(ai, 16007) ->
    {ok, [[1,103002,103003]]};
get(ai, 16008) ->
    {ok, [[1,103004,103005]]};
get(ai, 16009) ->
    {ok, [[1,103000,103001]]};
get(ai, 16010) ->
    {ok, [[1,103002,103003]]};
get(ai, 16011) ->
    {ok, [[1,103004,103005]]};
get(ai, 16012) ->
    {ok, [[1,103000,103001]]};
get(ai, 16013) ->
    {ok, [[1,103002,103003]]};
get(ai, 16014) ->
    {ok, [[1,103004,103005]]};
get(ai, 16015) ->
    {ok, [[1,103000,103001]]};
get(ai, 16016) ->
    {ok, [[1,103002,103003]]};
get(ai, 16017) ->
    {ok, [[1,103004,103005]]};
get(ai, 16122) ->
    {ok, [[1,103111,103112,103113,103114,103115,103116,103117,103118]]};
get(ai, 16018) ->
    {ok, [[1,103015,103016]]};
get(ai, 16019) ->
    {ok, [[1,103017,103018]]};
get(ai, 16020) ->
    {ok, [[1,103019,103020]]};
get(ai, 16021) ->
    {ok, [[1,103015,103016]]};
get(ai, 16022) ->
    {ok, [[1,103017,103018]]};
get(ai, 16023) ->
    {ok, [[1,103019,103020]]};
get(ai, 16024) ->
    {ok, [[1,103015,103016]]};
get(ai, 16025) ->
    {ok, [[1,103017,103018]]};
get(ai, 16026) ->
    {ok, [[1,103019,103020]]};
get(ai, 16027) ->
    {ok, [[1,103015,103016]]};
get(ai, 16028) ->
    {ok, [[1,103017,103018]]};
get(ai, 16029) ->
    {ok, [[1,103019,103020]]};
get(ai, 16030) ->
    {ok, [[1,103015,103016]]};
get(ai, 16031) ->
    {ok, [[1,103017,103018]]};
get(ai, 16032) ->
    {ok, [[1,103019,103020]]};
get(ai, 16033) ->
    {ok, [[1,103015,103016]]};
get(ai, 16034) ->
    {ok, [[1,103017,103018]]};
get(ai, 16035) ->
    {ok, [[1,103019,103020]]};
get(ai, 16123) ->
    {ok, [[1,103119,103120,103121,103124,103125,103126,103127]]};
get(ai, 16036) ->
    {ok, [[1,103030,103031]]};
get(ai, 16037) ->
    {ok, [[1,103032,103033]]};
get(ai, 16038) ->
    {ok, [[1,103034,103035]]};
get(ai, 16039) ->
    {ok, [[1,103030,103031]]};
get(ai, 16040) ->
    {ok, [[1,103032,103033]]};
get(ai, 16041) ->
    {ok, [[1,103034,103035]]};
get(ai, 16042) ->
    {ok, [[1,103030,103031]]};
get(ai, 16043) ->
    {ok, [[1,103032,103033]]};
get(ai, 16044) ->
    {ok, [[1,103034,103035]]};
get(ai, 16045) ->
    {ok, [[1,103030,103031]]};
get(ai, 16046) ->
    {ok, [[1,103032,103033]]};
get(ai, 16047) ->
    {ok, [[1,103034,103035]]};
get(ai, 16048) ->
    {ok, [[1,103030,103031]]};
get(ai, 16049) ->
    {ok, [[1,103032,103033]]};
get(ai, 16050) ->
    {ok, [[1,103034,103035]]};
get(ai, 16051) ->
    {ok, [[1,103030,103031]]};
get(ai, 16052) ->
    {ok, [[1,103032,103033]]};
get(ai, 16053) ->
    {ok, [[1,103034,103035]]};
get(ai, 16124) ->
    {ok, [[1,103128,103129,103130,103131,103132,103133,103134]]};
get(ai, 16054) ->
    {ok, [[1,103045,103046]]};
get(ai, 16055) ->
    {ok, [[1,103047,103048]]};
get(ai, 16056) ->
    {ok, [[1,103049,103050]]};
get(ai, 16057) ->
    {ok, [[1,103045,103046]]};
get(ai, 16058) ->
    {ok, [[1,103047,103048]]};
get(ai, 16059) ->
    {ok, [[1,103049,103050]]};
get(ai, 16060) ->
    {ok, [[1,103045,103046]]};
get(ai, 16061) ->
    {ok, [[1,103047,103048]]};
get(ai, 16062) ->
    {ok, [[1,103049,103050]]};
get(ai, 16063) ->
    {ok, [[1,103045,103046]]};
get(ai, 16064) ->
    {ok, [[1,103047,103048]]};
get(ai, 16065) ->
    {ok, [[1,103049,103050]]};
get(ai, 16066) ->
    {ok, [[1,103045,103046]]};
get(ai, 16067) ->
    {ok, [[1,103047,103048]]};
get(ai, 16068) ->
    {ok, [[1,103049,103050]]};
get(ai, 16069) ->
    {ok, [[1,103045,103046]]};
get(ai, 16070) ->
    {ok, [[1,103047,103048]]};
get(ai, 16071) ->
    {ok, [[1,103049,103050]]};
get(ai, 16125) ->
    {ok, [[1,103136,103137,103138,103139,103140,103141]]};
get(ai, 16072) ->
    {ok, [[1,103060,103061]]};
get(ai, 16073) ->
    {ok, [[1,103062,103063]]};
get(ai, 16074) ->
    {ok, [[1,103064,103065]]};
get(ai, 16075) ->
    {ok, [[1,103060,103061]]};
get(ai, 16076) ->
    {ok, [[1,103062,103063]]};
get(ai, 16077) ->
    {ok, [[1,103064,103065]]};
get(ai, 16078) ->
    {ok, [[1,103060,103061]]};
get(ai, 16079) ->
    {ok, [[1,103062,103063]]};
get(ai, 16080) ->
    {ok, [[1,103064,103065]]};
get(ai, 16081) ->
    {ok, [[1,103060,103061]]};
get(ai, 16082) ->
    {ok, [[1,103062,103063]]};
get(ai, 16083) ->
    {ok, [[1,103064,103065]]};
get(ai, 16084) ->
    {ok, [[1,103060,103061]]};
get(ai, 16085) ->
    {ok, [[1,103062,103063]]};
get(ai, 16086) ->
    {ok, [[1,103064,103065]]};
get(ai, 16087) ->
    {ok, [[1,103060,103061]]};
get(ai, 16088) ->
    {ok, [[1,103062,103063]]};
get(ai, 16089) ->
    {ok, [[1,103064,103065]]};
get(ai, 16126) ->
    {ok, [[1,103142,103144,103145,103146,103147]]};
get(ai, 16090) ->
    {ok, [[1,103075,103076]]};
get(ai, 16091) ->
    {ok, [[1,103077,103078]]};
get(ai, 16092) ->
    {ok, [[1,103079,103080]]};
get(ai, 16093) ->
    {ok, [[1,103075,103076]]};
get(ai, 16094) ->
    {ok, [[1,103077,103078]]};
get(ai, 16095) ->
    {ok, [[1,103079,103080]]};
get(ai, 16096) ->
    {ok, [[1,103075,103076]]};
get(ai, 16097) ->
    {ok, [[1,103077,103078]]};
get(ai, 16098) ->
    {ok, [[1,103079,103080]]};
get(ai, 16099) ->
    {ok, [[1,103075,103076]]};
get(ai, 16100) ->
    {ok, [[1,103077,103078]]};
get(ai, 16101) ->
    {ok, [[1,103079,103080]]};
get(ai, 16102) ->
    {ok, [[1,103075,103076]]};
get(ai, 16103) ->
    {ok, [[1,103077,103078]]};
get(ai, 16104) ->
    {ok, [[1,103079,103080]]};
get(ai, 16105) ->
    {ok, [[1,103075,103076]]};
get(ai, 16106) ->
    {ok, [[1,103077,103078]]};
get(ai, 16107) ->
    {ok, [[1,103079,103080]]};
get(ai, 16127) ->
    {ok, [[1,103148,103149,103150,103151,103152,103153]]};
get(ai, 16128) ->
    {ok, [[1,103090,103091]]};
get(ai, 16129) ->
    {ok, [[1,103092,103093]]};
get(ai, 16130) ->
    {ok, [[1,103094,103095]]};
get(ai, 16131) ->
    {ok, [[1,103090,103091]]};
get(ai, 16132) ->
    {ok, [[1,103092,103093]]};
get(ai, 16133) ->
    {ok, [[1,103094,103095]]};
get(ai, 16134) ->
    {ok, [[1,103090,103091]]};
get(ai, 16135) ->
    {ok, [[1,103092,103093]]};
get(ai, 16136) ->
    {ok, [[1,103094,103095]]};
get(ai, 16137) ->
    {ok, [[1,103090,103091]]};
get(ai, 16138) ->
    {ok, [[1,103092,103093]]};
get(ai, 16139) ->
    {ok, [[1,103094,103095]]};
get(ai, 16140) ->
    {ok, [[1,103090,103091]]};
get(ai, 16141) ->
    {ok, [[1,103092,103093]]};
get(ai, 16142) ->
    {ok, [[1,103094,103095]]};
get(ai, 16143) ->
    {ok, [[1,103090,103091]]};
get(ai, 16144) ->
    {ok, [[1,103092,103093]]};
get(ai, 16145) ->
    {ok, [[1,103094,103095]]};
get(ai, 16146) ->
    {ok, [[1,103154,103155,103156,103157],[2,103158,103159,103160,103161,103162]]};
get(ai, 16147) ->
    {ok, [[1,103105,103106]]};
get(ai, 16148) ->
    {ok, [[1,103107,103108]]};
get(ai, 16149) ->
    {ok, [[1,103109,103110]]};
get(ai, 16150) ->
    {ok, [[1,103105,103106]]};
get(ai, 16151) ->
    {ok, [[1,103107,103108]]};
get(ai, 16152) ->
    {ok, [[1,103109,103110]]};
get(ai, 16153) ->
    {ok, [[1,103105,103106]]};
get(ai, 16154) ->
    {ok, [[1,103107,103108]]};
get(ai, 16155) ->
    {ok, [[1,103109,103110]]};
get(ai, 16156) ->
    {ok, [[1,103105,103106]]};
get(ai, 16157) ->
    {ok, [[1,103107,103108]]};
get(ai, 16158) ->
    {ok, [[1,103109,103110]]};
get(ai, 16159) ->
    {ok, [[1,103105,103106]]};
get(ai, 16160) ->
    {ok, [[1,103107,103108]]};
get(ai, 16161) ->
    {ok, [[1,103109,103110]]};
get(ai, 16162) ->
    {ok, [[1,103105,103106]]};
get(ai, 16163) ->
    {ok, [[1,103107,103108]]};
get(ai, 16164) ->
    {ok, [[1,103109,103110]]};
get(ai, 16165) ->
    {ok, [[1,103163,103164,103165,103166,103167]]};
get(ai, 16166) ->
    {ok, [[1,103135]]};
get(ai, 16167) ->
    {ok, [[1,103143,103145,103146,103147]]};
get(ai, 19001) ->
    {ok, [[1,140001,140002,140003,140004,140005,140006]]};
get(ai, 19002) ->
    {ok, [[1,140001,140002,140003,140004,140005,140006]]};
get(ai, 19003) ->
    {ok, [[1,140001,140002,140003,140004,140005,140006]]};
get(ai, 19004) ->
    {ok, [[1,140001,140002,140003,140004,140005,140006]]};
get(ai, 19005) ->
    {ok, [[1,140001,140002,140003,140004,140005,140006]]};
get(ai, 19006) ->
    {ok, [[1,140007,140008,140009,140006]]};
get(ai, 19007) ->
    {ok, [[1,140007,140008,140009,140006]]};
get(ai, 19008) ->
    {ok, [[1,140007,140008,140009,140006]]};
get(ai, 19009) ->
    {ok, [[1,140007,140008,140009,140006]]};
get(ai, 19010) ->
    {ok, [[1,140007,140008,140009,140006]]};
get(ai, 19011) ->
    {ok, [[1,140012,140011,140010,140013,140014]]};
get(ai, 19012) ->
    {ok, [[1,140012,140011,140010,140013,140014]]};
get(ai, 19013) ->
    {ok, [[1,140012,140011,140010,140013,140014]]};
get(ai, 19014) ->
    {ok, [[1,140012,140011,140010,140013,140014]]};
get(ai, 19015) ->
    {ok, [[1,140012,140011,140010,140013,140014]]};
get(ai, 19016) ->
    {ok, [[1,140101,140102,140108]]};
get(ai, 19017) ->
    {ok, [[1,140101,140102,140108]]};
get(ai, 19018) ->
    {ok, [[1,140101,140102,140108]]};
get(ai, 19019) ->
    {ok, [[1,140101,140102,140108]]};
get(ai, 19020) ->
    {ok, [[1,140101,140102,140108]]};
get(ai, 19021) ->
    {ok, [[1,140109,140104,140103,140105,140106,140107,140108]]};
get(ai, 19022) ->
    {ok, [[1,140109,140104,140103,140105,140106,140107,140108]]};
get(ai, 19023) ->
    {ok, [[1,140109,140104,140103,140105,140106,140107,140108]]};
get(ai, 19024) ->
    {ok, [[1,140109,140104,140103,140105,140106,140107,140108]]};
get(ai, 19025) ->
    {ok, [[1,140109,140104,140103,140105,140106,140107,140108]]};
get(ai, 19026) ->
    {ok, [[1,140104,140103,140105,140106,140107,140108]]};
get(ai, 19027) ->
    {ok, [[1,140104,140103,140105,140106,140107,140108]]};
get(ai, 19028) ->
    {ok, [[1,140104,140103,140105,140106,140107,140108]]};
get(ai, 19029) ->
    {ok, [[1,140104,140103,140105,140106,140107,140108]]};
get(ai, 19030) ->
    {ok, [[1,140104,140103,140105,140106,140107,140108]]};
get(ai, 19031) ->
    {ok, [[1,140201,140202,140203,140204,140205,140217]]};
get(ai, 19032) ->
    {ok, [[1,140201,140202,140203,140220,140205,140217]]};
get(ai, 19033) ->
    {ok, [[1,140201,140202,140203,140221,140205,140217]]};
get(ai, 19034) ->
    {ok, [[1,140201,140202,140203,140222,140205,140217]]};
get(ai, 19035) ->
    {ok, [[1,140201,140202,140203,140223,140205,140217]]};
get(ai, 19036) ->
    {ok, [[1,140219,140207,140206,140211,140210,140208,140217]]};
get(ai, 19037) ->
    {ok, [[1,140219,140207,140206,140211,140210,140224,140217]]};
get(ai, 19038) ->
    {ok, [[1,140219,140207,140206,140211,140210,140225,140217]]};
get(ai, 19039) ->
    {ok, [[1,140219,140207,140206,140211,140210,140226,140217]]};
get(ai, 19040) ->
    {ok, [[1,140219,140207,140206,140211,140210,140227,140217]]};
get(ai, 19041) ->
    {ok, [[1,140215,140212,140213,140214,140216,140218]]};
get(ai, 19042) ->
    {ok, [[1,140215,140228,140232,140214,140216,140218]]};
get(ai, 19043) ->
    {ok, [[1,140215,140229,140233,140214,140216,140218]]};
get(ai, 19044) ->
    {ok, [[1,140215,140230,140234,140214,140216,140218]]};
get(ai, 19045) ->
    {ok, [[1,140215,140231,140235,140214,140216,140218]]};
get(ai, 19046) ->
    {ok, [[1,140314,140315,140304,140303,140302,140301,140316]]};
get(ai, 19047) ->
    {ok, [[1,140314,140315,140304,140303,140302,140301,140316]]};
get(ai, 19048) ->
    {ok, [[1,140314,140315,140304,140303,140302,140301,140316]]};
get(ai, 19049) ->
    {ok, [[1,140314,140315,140304,140303,140302,140301,140316]]};
get(ai, 19050) ->
    {ok, [[1,140314,140315,140304,140303,140302,140301,140316]]};
get(ai, 19051) ->
    {ok, [[1,140314,140315,140305,140306,140307,140308,140309,140317]]};
get(ai, 19052) ->
    {ok, [[1,140314,140315,140305,140306,140307,140308,140309,140317]]};
get(ai, 19053) ->
    {ok, [[1,140314,140315,140305,140306,140307,140308,140309,140317]]};
get(ai, 19054) ->
    {ok, [[1,140314,140315,140305,140306,140307,140308,140309,140317]]};
get(ai, 19055) ->
    {ok, [[1,140314,140315,140305,140306,140307,140308,140309,140317]]};
get(ai, 19056) ->
    {ok, [[1,140310,140318,140313,140311,140312,140316]]};
get(ai, 19057) ->
    {ok, [[1,140310,140318,140313,140311,140312,140316]]};
get(ai, 19058) ->
    {ok, [[1,140310,140318,140313,140311,140312,140316]]};
get(ai, 19059) ->
    {ok, [[1,140310,140318,140313,140311,140312,140316]]};
get(ai, 19060) ->
    {ok, [[1,140310,140318,140313,140311,140312,140316]]};
get(ai, 19061) ->
    {ok, [[1,140404,140403,140401,140402,140413]]};
get(ai, 19062) ->
    {ok, [[1,140404,140403,140401,140402,140413]]};
get(ai, 19063) ->
    {ok, [[1,140404,140403,140401,140402,140413]]};
get(ai, 19064) ->
    {ok, [[1,140404,140403,140401,140402,140413]]};
get(ai, 19065) ->
    {ok, [[1,140404,140403,140401,140402,140413]]};
get(ai, 19066) ->
    {ok, [[1,140406,140404,140403,140405,140413]]};
get(ai, 19067) ->
    {ok, [[1,140406,140404,140403,140405,140413]]};
get(ai, 19068) ->
    {ok, [[1,140406,140404,140403,140405,140413]]};
get(ai, 19069) ->
    {ok, [[1,140406,140404,140403,140405,140413]]};
get(ai, 19070) ->
    {ok, [[1,140406,140404,140403,140405,140413]]};
get(ai, 19071) ->
    {ok, [[1,140409,140410,140413,140412,140411,140407,140408]]};
get(ai, 19072) ->
    {ok, [[1,140409,140410,140413,140412,140411,140407,140408]]};
get(ai, 19073) ->
    {ok, [[1,140409,140410,140413,140412,140411,140407,140408]]};
get(ai, 19074) ->
    {ok, [[1,140409,140410,140413,140412,140411,140407,140408]]};
get(ai, 19075) ->
    {ok, [[1,140409,140410,140413,140412,140411,140407,140408]]};
get(ai, 16108) ->
    {ok, [[1,100572,100652,100653,100654,110009]]};
get(ai, 16109) ->
    {ok, [[1,100120,100121]]};
get(ai, 16110) ->
    {ok, [[1,100122,100123,100124,100125]]};
get(ai, 16111) ->
    {ok, [[1,130055,130056,130057,130058]]};
get(ai, 16113) ->
    {ok, [[1,100120,100121]]};
get(ai, 16114) ->
    {ok, [[1,100122,100123,100124,100125]]};
get(ai, 16115) ->
    {ok, [[1,130055,130056,130057,130058]]};
get(ai, 16119) ->
    {ok, [[1,11674,11675,11676]]};
get(ai, 16120) ->
    {ok, [[1,100629,100630,100631]]};
get(ai, 16121) ->
    {ok, [[1,100629,100630,100631]]};
get(ai, 17001) ->
    {ok, [[1,100597,100598,100599]]};
get(ai, 17002) ->
    {ok, [[1,100597,100598,100599]]};
get(ai, 110200) ->
    {ok, [[1,120064,120071]]};
get(ai, 110201) ->
    {ok, [[1,120001,120000,120071]]};
get(ai, 110202) ->
    {ok, [[1,120003,120002,120071]]};
get(ai, 110204) ->
    {ok, [[1,120004,120071]]};
get(ai, 110205) ->
    {ok, [[1,120005,120071]]};
get(ai, 110206) ->
    {ok, [[1,120006,120071]]};
get(ai, 110207) ->
    {ok, [[1,120007,120071]]};
get(ai, 110210) ->
    {ok, [[1,120008,120071]]};
get(ai, 110212) ->
    {ok, [[1,120009,120071]]};
get(ai, 110213) ->
    {ok, [[1,120010,120071]]};
get(ai, 110214) ->
    {ok, [[1,120011,120071]]};
get(ai, 110215) ->
    {ok, [[1,120013,120012,120071]]};
get(ai, 110216) ->
    {ok, [[1,120014,120071]]};
get(ai, 110217) ->
    {ok, [[1,120016,120015,120071]]};
get(ai, 110218) ->
    {ok, [[1,120017,120071]]};
get(ai, 110219) ->
    {ok, [[1,120018,120071]]};
get(ai, 110220) ->
    {ok, [[1,120020,120019,120071]]};
get(ai, 110258) ->
    {ok, [[1,120021,120071]]};
get(ai, 110226) ->
    {ok, [[1,120023,120022,120071]]};
get(ai, 110227) ->
    {ok, [[1,120025,120024,120071]]};
get(ai, 110230) ->
    {ok, [[1,120027,120026,120071]]};
get(ai, 110231) ->
    {ok, [[1,120028,120071]]};
get(ai, 110232) ->
    {ok, [[1,120071]]};
get(ai, 110234) ->
    {ok, [[1,120031,120030,120071]]};
get(ai, 110235) ->
    {ok, [[1,120033,120032,120071]]};
get(ai, 110236) ->
    {ok, [[1,120034,120071]]};
get(ai, 110237) ->
    {ok, [[1,120036,120035,120071]]};
get(ai, 110239) ->
    {ok, [[1,120038,120037,120071]]};
get(ai, 110240) ->
    {ok, [[1,120041,120040,120039,120071]]};
get(ai, 110241) ->
    {ok, [[1,120042,120072]]};
get(ai, 110242) ->
    {ok, [[1,120044,120043,120072]]};
get(ai, 110244) ->
    {ok, [[1,120046,120045,120072]]};
get(ai, 110245) ->
    {ok, [[1,120048,120047,120071]]};
get(ai, 110246) ->
    {ok, [[1,120050,120049,120071]]};
get(ai, 110247) ->
    {ok, [[1,120052,120051,120071]]};
get(ai, 110248) ->
    {ok, [[1,120054,120053,120071]]};
get(ai, 110252) ->
    {ok, [[1,120055,120071]]};
get(ai, 110253) ->
    {ok, [[1,120071]]};
get(ai, 110254) ->
    {ok, [[1,120058,120057,120071]]};
get(ai, 110256) ->
    {ok, [[1,120060,120059,120071]]};
get(ai, 110273) ->
    {ok, [[1,120071]]};
get(ai, 110274) ->
    {ok, [[1,120066,120065,120071]]};
get(ai, 110275) ->
    {ok, [[1,120068,120067,120071]]};
get(ai, 110276) ->
    {ok, [[1,120069,120071]]};
get(ai, 110277) ->
    {ok, [[1,120071]]};
get(ai, 118009) ->
    {ok, [[1,120074,120073,120080]]};
get(ai, 118010) ->
    {ok, [[1,120076,120075,120081]]};
get(ai, 118011) ->
    {ok, [[1,120078,120077,120082]]};
get(ai, 118012) ->
    {ok, [[1,120079,120083]]};
get(ai, 120007) ->
    {ok, [[1,120063,120062,120061,120071]]};

get(_I, _X) ->
    false.    
































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































get(_Talk, _Scene, _NpcId) ->
    {ok, []}.
