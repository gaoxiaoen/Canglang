
-module(task_data).
-export([
		get_conf/1
        ,all/0
        ,get/1
        ,lev/1
        ,acceptable/1
        ,commitable/1
		,all_star_dun_task/0
		,task2dungeon/1
		,dungeon2task/1		
    ]
).
-include("task.hrl").
-include("common.hrl").
-include("condition.hrl").
-include("gain.hrl").

%%　获取任务配置
get_conf(TaskId) ->
	case TaskId >= 100000 of	%% 日常任务，需转换
		true ->
			task_data:get(convert_id(TaskId));
		false ->
			task_data:get(TaskId)
	end.

%% 获取所有任务的ID
%% @spec all() -> TaskList
%% TaskList = list() of integer() 任务列表
all() -> [10000,10010,10020,10030,10040,10050,10060,10070,10080,10090,10100,10110,10120,10130,10140,10150,10151,10160,10170,10180,10190,10200,10210,10220,10230,10240,10250,10260,10270,10280,10290,10300,10310,10320,10330,10340,10350,10360,10370,10380,10390,10400,10410,10420,10430,10440,10450,10460,10470,10480,10490,10500,10510,10520,10530,10540,10550,10560,10570,10580,10590,10600,10610,10620,10630,10640,10650,10660,10670,10680,10690,10700,10710,10720,10730,10740,10750,10760,10770,10780,10790,10800,10810,10820,10830,10840,10850,10860,10870,10880,10890,10900,10910,10920,10930,10940,10950,10960,10970,10980,10990,11000,11010,11020,11030,11040,11050,11060,11070,11080,11090,11100,11110,11120,11130,11140,11150,11160,11170,11180,11190,11200,11210,11220,11230,11240,11250,11260,11270,11280,11290,11300,11310,11320,11330,11340,11350,11360,11390,11400,11410,11420,11430,11440,11450,11460,11470,11480,11490,11500,11510,11520,11530,11540,11550,11560,11570,11580,11590,11600,11610,11620,11630,11640,11650,11660,11670,11680,11690,11700,11710,11720,11730,11740,11750,11760,11770,11780,11790,11800,11810,11820,11830,11840,11850,11860,11870,11880,11890,11900,11910,11920,11930,11940,11950,11960,11970,11980,11990,12000,12010,12020,12030,12040,12050,12060,12070,12080,12090,12100,12110,12120,12130,12140,12150,12160,12170,12180,12190,12200,12210,12220,12230,12240,12250,12260,12270,12280,12290,12300,12310,12320,12330,12340,12350,12360,12370,12380,12390,12400,12410,12420,12430,12440,12450,12460,12470,12480,12490,12500,12510,12520,12530,12540,12550,12560].
all_star_dun_task() -> [50011,50021,50031,50041,50051,50061,51011,51021,51031,51041,51051,52011,52021,52031,52041,52051,52061,53011,53021,53031,53041,53051,53111,53121,53131,53141,53151,54011,54021,54031,54041,54051,54111,54121,54131,54141,54151].

task2dungeon(50011) -> ok;
task2dungeon(50021) -> 10012;
task2dungeon(50031) -> 10032;
task2dungeon(50041) -> 10052;
task2dungeon(50051) -> 10072;
task2dungeon(50061) -> 10092;
task2dungeon(51011) -> 11091;
task2dungeon(51021) -> 11012;
task2dungeon(51031) -> 11032;
task2dungeon(51041) -> 11052;
task2dungeon(51051) -> 11072;
task2dungeon(52011) -> 12131;
task2dungeon(52021) -> 12012;
task2dungeon(52031) -> 12032;
task2dungeon(52041) -> 12062;
task2dungeon(52051) -> 12082;
task2dungeon(52061) -> 12112;
task2dungeon(53011) -> 13121;
task2dungeon(53021) -> 13012;
task2dungeon(53031) -> 13032;
task2dungeon(53041) -> 13062;
task2dungeon(53051) -> 13092;
task2dungeon(53111) -> 14121;
task2dungeon(53121) -> 14012;
task2dungeon(53131) -> 14032;
task2dungeon(53141) -> 14062;
task2dungeon(53151) -> 14092;
task2dungeon(54011) -> 15131;
task2dungeon(54021) -> 15012;
task2dungeon(54031) -> 15042;
task2dungeon(54041) -> 15072;
task2dungeon(54051) -> 15102;
task2dungeon(54111) -> 16131;
task2dungeon(54121) -> 16012;
task2dungeon(54131) -> 16042;
task2dungeon(54141) -> 16072;
task2dungeon(54151) -> 16102;
task2dungeon(_) -> false.

dungeon2task(10012) -> 50021;
dungeon2task(10032) -> 50031;
dungeon2task(10052) -> 50041;
dungeon2task(10072) -> 50051;
dungeon2task(10092) -> 50061;
dungeon2task(11091) -> 51011;
dungeon2task(11012) -> 51021;
dungeon2task(11032) -> 51031;
dungeon2task(11052) -> 51041;
dungeon2task(11072) -> 51051;
dungeon2task(12131) -> 52011;
dungeon2task(12012) -> 52021;
dungeon2task(12032) -> 52031;
dungeon2task(12062) -> 52041;
dungeon2task(12082) -> 52051;
dungeon2task(12112) -> 52061;
dungeon2task(13121) -> 53011;
dungeon2task(13012) -> 53021;
dungeon2task(13032) -> 53031;
dungeon2task(13062) -> 53041;
dungeon2task(13092) -> 53051;
dungeon2task(14121) -> 53111;
dungeon2task(14012) -> 53121;
dungeon2task(14032) -> 53131;
dungeon2task(14062) -> 53141;
dungeon2task(14092) -> 53151;
dungeon2task(15131) -> 54011;
dungeon2task(15012) -> 54021;
dungeon2task(15042) -> 54031;
dungeon2task(15072) -> 54041;
dungeon2task(15102) -> 54051;
dungeon2task(16131) -> 54111;
dungeon2task(16012) -> 54121;
dungeon2task(16042) -> 54131;
dungeon2task(16072) -> 54141;
dungeon2task(16102) -> 54151;
dungeon2task(_) -> false.


%% 获取某级别可接任务列表
%% @spec lev(LevId) -> TaskList
%% LevId = integer() Lev编号
%% TaskList = list() of integer() 任务列表
lev(1) ->
    [10000,10010,10020,10030,10040,10050,10060,10070,10080,10090,10100,10110,10120,10130,10140,10150,10151,10160,10170,10180,10190,10200,10210,10220,10230,10240,10250,10260,10270,10280,10290,10300,10310,10320,10330,10340,10350,10360,10370,10380,10390,10400,10410,10420,10430,10440,10450,10460,10470,10480,10490,10500,10510,10520,10530,10540,10550,10560,10570,10580,10590,10600,10610,10620,10630,10640,10650,10660,10670,10680,10690,10700,10710,10720,10730,10740,10750,10760,10770,10780,10790,10800,10810,10820,10830,10840,10850,10860,10870,10880,10890,10900,10910,10920,10930,10940,10950,10960,10970,10980,10990,11000,11010,11020,11030,11040,11050,11060,11070,11080,11090,11100,11110,11120,11130,11140,11150,11160,11170,11180,11190,11200,11210,11220,11230,11240,11250,11260,11270,11280,11290,11300,11310,11320,11330,11340,11350,11360,11390,11400,11410,11420,11430,11440,11450,11460,11470,11480,11490,11500,11510,11520,11530,11540,11550,11560,11570,11580,11590,11600,11610,11630,11640,11650,11660,11670,11680,11690,11700,11710,11720,11730,11740,11750,11760,11770,11780,11790,11810,11820,11830,11840,11850,11860,11870,11880,11890,11900,11910,11920,11930,11940,11950,11960,11970,11980,11990,12000,12010,12020,12030,12040,12060,12070,12080,12090,12100,12110,12120,12130,12140,12150,12160,12170,12180,12190,12200,12210,12220,12230,12240,12250,12260,12270,12280,12290,12300,12310,12320,12330,12340,12360,12370,12380,12390,12400,12410,12420,12430,12440,12450,12460,12470,12480,12490,12500,12510,12520,12530,12540,12560,30001,30002,30003,30004,30005,30006,30007,30008,30009,30010,30011,30012,30013,30014,30015,30016,30017,30018,30019,30020,50011,50021,50031,50041,50051,50061,51011,51021,51031,51041,51051,52011,52021,52031,52041,52051,52061,53011,53021,53031,53041,53051,53111,53121,53131,53141,53151,54011,54021,54031,54041,54051,54111,54121,54131,54141,54151];
lev(40) ->
    [11620];
lev(45) ->
    [11800];
lev(50) ->
    [12050];
lev(55) ->
    [12350];
lev(60) ->
    [12550];
lev(_Id) ->
    [].
    
%% 获取某NPC可接任务列表
%% @spec acceptable(NpcId) -> TaskList
%% NpcId = integer() NPC编号
%% TaskList = list() of integer() 任务列表
acceptable(10070) ->
    [10000,10070,10100,10120,10150,10151];
acceptable(10072) ->
    [10010,10020,10080,10090,10140,10170];
acceptable(10071) ->
    [10030,10040,10050,10060,10110,10130,10160,10180,10190];
acceptable(10073) ->
    [10200];
acceptable(10077) ->
    [10210,10220,10230,10270,10280,10290,10300,10340,10350,10360,10420,10430,10670,10680,10730,10750,10760,10930,10940,10960,11100,11130,11160,11170,11420,11470,11530,11880,11920,12210,12550];
acceptable(10078) ->
    [10240,10330,10950,11140,11210,11280,11310,11410,11930];
acceptable(10076) ->
    [10250,10260,10310,10390,10400,10700,10970,10980,11110,11150,11180,11230,11270,11320,11430,11460,11490,11520,11550,11570,11910,11940,11950,11970,12040,12100,12220,12280,12440,12490,12540];
acceptable(10101) ->
    [10320];
acceptable(10075) ->
    [10370,10380,10410,10440,10690,10740,11480,11540,11560,11960,12560];
acceptable(10085) ->
    [10450,10470,10500,10510,10520,10540,10550,10570,10580,10600,10630,10660,10710,10720];
acceptable(10081) ->
    [10460,10490,10530,10590,10650];
acceptable(10084) ->
    [10480,10560,10620,10640];
acceptable(10082) ->
    [10610];
acceptable(10090) ->
    [10770,10800,10830,10860,10870,10900,10920,11010,11030,11050,11090,11240,11290,11300,11340,11390,11400,11440,11450,11500,11510];
acceptable(10086) ->
    [10780,10810,10820,10880,10890,10910,10990,11000,11040,11060,11070,11080,11250,11330,11350,11360];
acceptable(10087) ->
    [10790];
acceptable(10089) ->
    [10840,10850,11020];
acceptable(10104) ->
    [11120,11220,12160,12340,12390];
acceptable(10074) ->
    [11190,11200,11260];
acceptable(10095) ->
    [11580,11600,11610,11620,11650,11660,11670,11700,11730,11740,11760,11780,11790,11810,11820,11840,11850,11860,11870,11890,11900];
acceptable(10092) ->
    [11590,11630,11800,11830];
acceptable(10096) ->
    [11640,11680,11690,11710,11720,11750,11770];
acceptable(10100) ->
    [11980,12010,12050,12110,12130,12170,12200,12230,12350,12400,12450,12460,12500,12530];
acceptable(10097) ->
    [11990,12120,12150,12250,12310];
acceptable(10099) ->
    [12000,12060,12090,12140,12180,12190,12270,12290,12380,12430,12480,12520];
acceptable(10105) ->
    [12020,12030,12070,12080,12260,12300,12330,12360,12370,12410,12420,12510];
acceptable(10098) ->
    [12240,12320,12470];
acceptable(0) ->
    [50011,50021,50031,50041,50051,50061,51011,51021,51031,51041,51051,52011,52021,52031,52041,52051,52061,53011,53021,53031,53041,53051,53111,53121,53131,53141,53151,54011,54021,54031,54041,54051,54111,54121,54131,54141,54151];
acceptable(_Id) ->
    [].

%% 获取某NPC可提交任务列表
%% @spec commitable(NpcId) -> TaskList
%% NpcId = integer() NPC编号
%% TaskList = list() of integer() 任务列表
commitable(10070) ->
    [10000,10070,10100,10120,10150,10151];
commitable(10072) ->
    [10010,10020,10080,10090,10140,10170];
commitable(10071) ->
    [10030,10040,10050,10060,10110,10130,10160,10180,10190];
commitable(10073) ->
    [10200];
commitable(10077) ->
    [10210,10220,10230,10270,10280,10290,10300,10340,10350,10360,10420,10430,10670,10680,10730,10750,10760,10930,10940,10960,11100,11130,11160,11170,11420,11470,11530,11880,11920,12210,12550];
commitable(10078) ->
    [10240,10330,10950,11140,11210,11280,11310,11410,11930];
commitable(10076) ->
    [10250,10260,10310,10390,10400,10700,10970,10980,11110,11150,11180,11230,11270,11320,11430,11460,11490,11520,11550,11570,11910,11940,11950,11970,12040,12100,12220,12280,12440,12490,12540];
commitable(10101) ->
    [10320];
commitable(10075) ->
    [10370,10380,10410,10440,10690,10740,11480,11540,11560,11960,12560];
commitable(10085) ->
    [10450,10470,10500,10510,10520,10540,10550,10570,10580,10600,10630,10660,10710,10720];
commitable(10081) ->
    [10460,10490,10530,10590,10650];
commitable(10084) ->
    [10480,10560,10620,10640];
commitable(10082) ->
    [10610];
commitable(10090) ->
    [10770,10800,10830,10860,10870,10900,10920,11010,11030,11050,11090,11240,11290,11300,11340,11390,11400,11440,11450,11500,11510];
commitable(10086) ->
    [10780,10810,10820,10880,10890,10910,10990,11000,11040,11060,11070,11080,11250,11330,11350,11360];
commitable(10087) ->
    [10790];
commitable(10089) ->
    [10840,10850,11020];
commitable(10104) ->
    [11120,11220,12160,12340,12390];
commitable(10074) ->
    [11190,11200,11260];
commitable(10095) ->
    [11580,11600,11610,11620,11650,11660,11670,11700,11730,11740,11760,11780,11790,11810,11820,11840,11850,11860,11870,11890,11900];
commitable(10092) ->
    [11590,11630,11800,11830];
commitable(10096) ->
    [11640,11680,11690,11710,11720,11750,11770];
commitable(10100) ->
    [11980,12010,12050,12110,12130,12170,12200,12230,12350,12400,12450,12460,12500,12530];
commitable(10097) ->
    [11990,12120,12150,12250,12310];
commitable(10099) ->
    [12000,12060,12090,12140,12180,12190,12270,12290,12380,12430,12480,12520];
commitable(10105) ->
    [12020,12030,12070,12080,12260,12300,12330,12360,12370,12410,12420,12510];
commitable(10098) ->
    [12240,12320,12470];
commitable(_Id) ->
    [].

	
	
	
	
	
	
	
		

%% 获取任务基础数据
%% 注意:100以下的ID是仅用于单元测试的数据
get(10000) ->
    {ok, #task_base{
            task_id = 10000
            ,name = ?L(<<"英雄预言">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10070
            ,npc_commit = 10072
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = item, val = [621401,1,1]}
            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = [{map_id, 1400}]
			
        }
    };
    
get(10010) ->
    {ok, #task_base{
            task_id = 10010
            ,name = ?L(<<"精灵之森">>)
            ,lev = 1
            ,prev = [10000]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10072
            ,npc_commit = 10072
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 10011, target_value = 1,map_id=10011}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
               ,#gain{label = item, val = [131001,1,2]}
               ,#gain{label = item_career, val =  [{2, [103201, 1, 1]}, {3, [102201, 1, 1]}, {5, [101201, 1, 1]}]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 10011},{dungeon_map_id, 10}]
			
        }
    };
    
get(10020) ->
    {ok, #task_base{
            task_id = 10020
            ,name = ?L(<<"王国兵长">>)
            ,lev = 1
            ,prev = [10010]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10072
            ,npc_commit = 10070
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1069,target_value = [{2, [103201, 1, 1]}, {3, [102201, 1, 1]}, {5, [101201, 1, 1]}]}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 200}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10030) ->
    {ok, #task_base{
            task_id = 10030
            ,name = ?L(<<"王国试炼">>)
            ,lev = 1
            ,prev = [10020]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10071
            ,npc_commit = 10071
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10040) ->
    {ok, #task_base{
            task_id = 10040
            ,name = ?L(<<"学习技能">>)
            ,lev = 1
            ,prev = [10030]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10071
            ,npc_commit = 10071
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1061, target_value = 1}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10050) ->
    {ok, #task_base{
            task_id = 10050
            ,name = ?L(<<"女巫试炼">>)
            ,lev = 1
            ,prev = [10040]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10071
            ,npc_commit = 10071
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10060) ->
    {ok, #task_base{
            task_id = 10060
            ,name = ?L(<<"安娜之伤">>)
            ,lev = 1
            ,prev = [10050]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10071
            ,npc_commit = 10070
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10070) ->
    {ok, #task_base{
            task_id = 10070
            ,name = ?L(<<"询问巫师">>)
            ,lev = 1
            ,prev = [10060]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10070
            ,npc_commit = 10072
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10080) ->
    {ok, #task_base{
            task_id = 10080
            ,name = ?L(<<"日光小径">>)
            ,lev = 1
            ,prev = [10070]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10072
            ,npc_commit = 10072
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 10031, target_value = 1,map_id=10031}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 300}
               ,#gain{label = item, val = [131001,1,1]}
               ,#gain{label = item_career, val =  [{2, [103501, 1, 1]}, {3, [102501, 1, 1]}, {5, [101501, 1, 1]}]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 10021}]
			
        }
    };
    
get(10090) ->
    {ok, #task_base{
            task_id = 10090
            ,name = ?L(<<"配制药水">>)
            ,lev = 1
            ,prev = [10080]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10072
            ,npc_commit = 10070
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1069,target_value = [{2, [103501, 1, 1]}, {3, [102501, 1, 1]}, {5, [101501, 1, 1]}]}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10100) ->
    {ok, #task_base{
            task_id = 10100
            ,name = ?L(<<"月光森林">>)
            ,lev = 1
            ,prev = [10090]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10070
            ,npc_commit = 10071
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = item, val = [111001,1,16]}
            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 10051, target_value = 1,map_id=10051}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
               ,#gain{label = item, val = [131001,1,2]}
               ,#gain{label = item, val = [111001,1,20]}
               ,#gain{label = item_career, val =  [{2, [103401, 1, 1]}, {3, [102401, 1, 1]}, {5, [101401, 1, 1]}]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 10041}]
			
        }
    };
    
get(10110) ->
    {ok, #task_base{
            task_id = 10110
            ,name = ?L(<<"兵长之命">>)
            ,lev = 1
            ,prev = [10100]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10071
            ,npc_commit = 10070
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = item, val = [131001,1,1]}
               ,#gain{label = coin, val = 600}
            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1069,target_value = [{2, [103401, 1, 1]}, {3, [102401, 1, 1]}, {5, [101401, 1, 1]}]}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111001,1,40]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10120) ->
    {ok, #task_base{
            task_id = 10120
            ,name = ?L(<<"魅影丛林">>)
            ,lev = 1
            ,prev = [10110]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10070
            ,npc_commit = 10071
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = coin, val = 18000}
            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 10071, target_value = 1,map_id=10071}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111001,1,40]}
               ,#gain{label = item_career, val =  [{2, [103101, 1, 1]}, {3, [102101, 1, 1]}, {5, [101101, 1, 1]}]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 10061}]
			
        }
    };
    
get(10130) ->
    {ok, #task_base{
            task_id = 10130
            ,name = ?L(<<"恶魔信使">>)
            ,lev = 1
            ,prev = [10120]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10071
            ,npc_commit = 10072
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1069,target_value = [{2, [103101, 1, 1]}, {3, [102101, 1, 1]}, {5, [101101, 1, 1]}]}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10140) ->
    {ok, #task_base{
            task_id = 10140
            ,name = ?L(<<"询问村长">>)
            ,lev = 1
            ,prev = [10130]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10072
            ,npc_commit = 10070
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
               ,#gain{label = item, val = [111001,1,20]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10150) ->
    {ok, #task_base{
            task_id = 10150
            ,name = ?L(<<"影月林间">>)
            ,lev = 1
            ,prev = [10140]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10070
            ,npc_commit = 10070
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 10091, target_value = 1,map_id=10091}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111001,1,60]}
               ,#gain{label = item_career, val =  [{2, [103601, 1, 1]}, {3, [102601, 1, 1]}, {5, [101601, 1, 1]}]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 10081}]
			
        }
    };
    
get(10151) ->
    {ok, #task_base{
            task_id = 10151
            ,name = ?L(<<"奥丁神鸦">>)
            ,lev = 1
            ,prev = [10150]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10070
            ,npc_commit = 10071
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1069,target_value = [{2, [103601, 1, 1]}, {3, [102601, 1, 1]}, {5, [101601, 1, 1]}]}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10160) ->
    {ok, #task_base{
            task_id = 10160
            ,name = ?L(<<"神鸦秘林">>)
            ,lev = 1
            ,prev = [10151]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10071
            ,npc_commit = 10072
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 10111, target_value = 1,map_id=10111}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111001,1,40]}
               ,#gain{label = item_career, val =  [{2, [103301, 1, 1]}, {3, [102301, 1, 1]}, {5, [101301, 1, 1]}]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 10101}]
			
        }
    };
    
get(10170) ->
    {ok, #task_base{
            task_id = 10170
            ,name = ?L(<<"欺瞒兵长">>)
            ,lev = 1
            ,prev = [10160]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10072
            ,npc_commit = 10071
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1069,target_value = [{2, [103301, 1, 1]}, {3, [102301, 1, 1]}, {5, [101301, 1, 1]}]}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10180) ->
    {ok, #task_base{
            task_id = 10180
            ,name = ?L(<<"告别大家">>)
            ,lev = 1
            ,prev = [10170]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10071
            ,npc_commit = 10072
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10190) ->
    {ok, #task_base{
            task_id = 10190
            ,name = ?L(<<"中庭之国">>)
            ,lev = 1
            ,prev = [10180]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10071
            ,npc_commit = 10073
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
               ,#gain{label = item, val = [111001,1,60]}
            ]
            ,times = 1
			,accept_open_map = [{map_id, 1405}]
			
        }
    };
    
get(10200) ->
    {ok, #task_base{
            task_id = 10200
            ,name = ?L(<<"英雄曙光">>)
            ,lev = 1
            ,prev = [10190]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10073
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10210) ->
    {ok, #task_base{
            task_id = 10210
            ,name = ?L(<<"制作装备">>)
            ,lev = 1
            ,prev = [10200]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = coin, val = 40600}
               ,#gain{label = item_career, val = [{2,[111660,1,1]},{3, [111660,1,1]},{5,[111660,1,1]}]}
               ,#gain{label = item_career, val =  [{2, [111425, 1, 5]}, {3, [111425, 1, 5]}, {5, [111425, 1, 5]}]}
               ,#gain{label = item_career, val =  [{2, [111426, 1, 3]}, {3, [111426, 1, 3]}, {5, [111426, 1, 3]}]}
            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
               ,#gain{label = item, val = [111001,1,50]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10220) ->
    {ok, #task_base{
            task_id = 10220
            ,name = ?L(<<"盖世神兵">>)
            ,lev = 1
            ,prev = [10210]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10230) ->
    {ok, #task_base{
            task_id = 10230
            ,name = ?L(<<"卡萝大妈">>)
            ,lev = 1
            ,prev = [10220]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10240) ->
    {ok, #task_base{
            task_id = 10240
            ,name = ?L(<<"初见艾娃">>)
            ,lev = 1
            ,prev = [10230]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10078
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10250) ->
    {ok, #task_base{
            task_id = 10250
            ,name = ?L(<<"艾娃考验">>)
            ,lev = 1
            ,prev = [10240]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10260) ->
    {ok, #task_base{
            task_id = 10260
            ,name = ?L(<<"将领考验">>)
            ,lev = 1
            ,prev = [10250]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10270) ->
    {ok, #task_base{
            task_id = 10270
            ,name = ?L(<<"晨曦小径">>)
            ,lev = 1
            ,prev = [10260]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = item, val = [621100,1,20]}
            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 11011, target_value = 1,map_id=11011}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1100}
               ,#gain{label = item, val = [111001,1,30]}
               ,#gain{label = item, val = [621100,1,22]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 11011},{dungeon_map_id, 11}]
			
        }
    };
    
get(10280) ->
    {ok, #task_base{
            task_id = 10280
            ,name = ?L(<<"对话艾娃">>)
            ,lev = 1
            ,prev = [10270]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1069,target_value = [{2, [103811, 1, 1]}, {3, [102811, 1, 1]}, {5, [101811, 1, 1]}]}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 3000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10290) ->
    {ok, #task_base{
            task_id = 10290
            ,name = ?L(<<"绿涛旷野">>)
            ,lev = 1
            ,prev = [10280]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = stone, val = 1000}
               ,#gain{label = coin, val = 6600}
               ,#gain{label = item, val = [132066,1,1]}
            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 11031, target_value = 1,map_id=11031}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
               ,#gain{label = item, val = [111001,1,60]}
               ,#gain{label = item, val = [621100,1,70]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 11021}]
			
        }
    };
    
get(10300) ->
    {ok, #task_base{
            task_id = 10300
            ,name = ?L(<<"通过考验">>)
            ,lev = 1
            ,prev = [10290]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10310) ->
    {ok, #task_base{
            task_id = 10310
            ,name = ?L(<<"荣耀学院">>)
            ,lev = 1
            ,prev = [10300]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10320) ->
    {ok, #task_base{
            task_id = 10320
            ,name = ?L(<<"勋章试炼">>)
            ,lev = 1
            ,prev = [10310]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10101
            ,npc_commit = 10102
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = kill_npc, target = 13022, target_value = 1,map_id=10000}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
               ,#gain{label = item, val = [111001,1,90]}
               ,#gain{label = item, val = [621100,1,50]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10330) ->
    {ok, #task_base{
            task_id = 10330
            ,name = ?L(<<"宝石庄园">>)
            ,lev = 1
            ,prev = [10320]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10078
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = coin, val = 1000}
               ,#gain{label = stone, val = 10000}
            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10340) ->
    {ok, #task_base{
            task_id = 10340
            ,name = ?L(<<"崇神湿地">>)
            ,lev = 1
            ,prev = [10330]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 11051, target_value = 1,map_id=11051}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
               ,#gain{label = item, val = [111001,1,80]}
               ,#gain{label = item, val = [621100,1,90]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 11041}]
			
        }
    };
    
get(10350) ->
    {ok, #task_base{
            task_id = 10350
            ,name = ?L(<<"大臣召见">>)
            ,lev = 1
            ,prev = [10340]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1069,target_value = [{2, [103911, 1, 1]}, {3, [102911, 1, 1]}, {5, [101911, 1, 1]}]}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10360) ->
    {ok, #task_base{
            task_id = 10360
            ,name = ?L(<<"王国大臣">>)
            ,lev = 1
            ,prev = [10350]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [621100,1,40]}
               ,#gain{label = item, val = [111001,1,60]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10370) ->
    {ok, #task_base{
            task_id = 10370
            ,name = ?L(<<"贫瘠腹地">>)
            ,lev = 1
            ,prev = [10360]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 11071, target_value = 1,map_id=11071}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [621100,1,80]}
               ,#gain{label = item, val = [111001,1,80]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 11061}]
			
        }
    };
    
get(10380) ->
    {ok, #task_base{
            task_id = 10380
            ,name = ?L(<<"祭坛之罪">>)
            ,lev = 1
            ,prev = [10370]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1069,target_value = [{2, [103711, 1, 1]}, {3, [102711, 1, 1]}, {5, [101711, 1, 1]}]}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10390) ->
    {ok, #task_base{
            task_id = 10390
            ,name = ?L(<<"中庭战神">>)
            ,lev = 1
            ,prev = [10380]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [621100,1,50]}
               ,#gain{label = item, val = [111001,1,80]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10400) ->
    {ok, #task_base{
            task_id = 10400
            ,name = ?L(<<"女神祭台">>)
            ,lev = 1
            ,prev = [10390]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 11091, target_value = 1,map_id=11091}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [621100,1,80]}
               ,#gain{label = item, val = [111001,1,90]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 11081}]
			
        }
    };
    
get(10410) ->
    {ok, #task_base{
            task_id = 10410
            ,name = ?L(<<"对话将领">>)
            ,lev = 1
            ,prev = [10400]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 800}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10420) ->
    {ok, #task_base{
            task_id = 10420
            ,name = ?L(<<"王国远征">>)
            ,lev = 1
            ,prev = [10410]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 800}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10430) ->
    {ok, #task_base{
            task_id = 10430
            ,name = ?L(<<"人为贡品">>)
            ,lev = 1
            ,prev = [10420]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 800}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10440) ->
    {ok, #task_base{
            task_id = 10440
            ,name = ?L(<<"沙丘之章">>)
            ,lev = 1
            ,prev = [10430]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 36400}
               ,#gain{label = exp, val = 800}
               ,#gain{label = item, val = [621100,1,20]}
            ]
            ,times = 1
			,accept_open_map = [{map_id, 1410}]
			
        }
    };
    
get(10450) ->
    {ok, #task_base{
            task_id = 10450
            ,name = ?L(<<"小镇镇长">>)
            ,lev = 1
            ,prev = [10440]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10081
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 800}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10460) ->
    {ok, #task_base{
            task_id = 10460
            ,name = ?L(<<"镇长之怒">>)
            ,lev = 1
            ,prev = [10450]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10081
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 800}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10470) ->
    {ok, #task_base{
            task_id = 10470
            ,name = ?L(<<"圆桌骑士">>)
            ,lev = 1
            ,prev = [10460]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10084
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 800}
               ,#gain{label = item_career, val = [{2,[111600,1,1]},{3, [111600,1,1]},{5,[111600,1,1]}]}
               ,#gain{label = item_career, val =  [{2, [111479, 1, 1]}, {3, [111479, 1, 1]}, {5, [111479, 1, 1]}]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10480) ->
    {ok, #task_base{
            task_id = 10480
            ,name = ?L(<<"威吓镇长">>)
            ,lev = 1
            ,prev = [10470]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10084
            ,npc_commit = 10081
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 800}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10490) ->
    {ok, #task_base{
            task_id = 10490
            ,name = ?L(<<"拯救女孩">>)
            ,lev = 1
            ,prev = [10480]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10081
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 800}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10500) ->
    {ok, #task_base{
            task_id = 10500
            ,name = ?L(<<"遗忘之路">>)
            ,lev = 1
            ,prev = [10490]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 12011, target_value = 1,map_id=12011}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 800}
               ,#gain{label = item, val = [111001,1,40]}
               ,#gain{label = item, val = [621100,1,60]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 12011},{dungeon_map_id, 12}]
			
        }
    };
    
get(10510) ->
    {ok, #task_base{
            task_id = 10510
            ,name = ?L(<<"契约妖精">>)
            ,lev = 1
            ,prev = [10500]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = item, val = [535604,1,1]}
            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10520) ->
    {ok, #task_base{
            task_id = 10520
            ,name = ?L(<<"迷茫的人">>)
            ,lev = 1
            ,prev = [10510]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10081
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10530) ->
    {ok, #task_base{
            task_id = 10530
            ,name = ?L(<<"对话艾娃">>)
            ,lev = 1
            ,prev = [10520]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10081
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10540) ->
    {ok, #task_base{
            task_id = 10540
            ,name = ?L(<<"失落沙丘">>)
            ,lev = 1
            ,prev = [10530]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 12031, target_value = 1,map_id=12031}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111001,1,80]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 12021}]
			
        }
    };
    
get(10550) ->
    {ok, #task_base{
            task_id = 10550
            ,name = ?L(<<"组建军团">>)
            ,lev = 1
            ,prev = [10540]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10084
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10560) ->
    {ok, #task_base{
            task_id = 10560
            ,name = ?L(<<"军团介绍">>)
            ,lev = 1
            ,prev = [10550]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10084
            ,npc_commit = 10084
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111001,1,30]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10570) ->
    {ok, #task_base{
            task_id = 10570
            ,name = ?L(<<"祭祀迷道">>)
            ,lev = 1
            ,prev = [10560]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = item, val = [111301,1,5]}
            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 12061, target_value = 1,map_id=12061}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 3000}
               ,#gain{label = item, val = [111001,1,80]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 12041}]
			
        }
    };
    
get(10580) ->
    {ok, #task_base{
            task_id = 10580
            ,name = ?L(<<"镇长之惧">>)
            ,lev = 1
            ,prev = [10570]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10081
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10590) ->
    {ok, #task_base{
            task_id = 10590
            ,name = ?L(<<"询问艾娃">>)
            ,lev = 1
            ,prev = [10580]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10081
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10600) ->
    {ok, #task_base{
            task_id = 10600
            ,name = ?L(<<"问问镇民">>)
            ,lev = 1
            ,prev = [10590]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10082
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10610) ->
    {ok, #task_base{
            task_id = 10610
            ,name = ?L(<<"对话骑士">>)
            ,lev = 1
            ,prev = [10600]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10082
            ,npc_commit = 10084
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111001,1,100]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10620) ->
    {ok, #task_base{
            task_id = 10620
            ,name = ?L(<<"毒蝎之穴">>)
            ,lev = 1
            ,prev = [10610]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10084
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 12081, target_value = 1,map_id=12081}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111001,1,130]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 12071}]
			
        }
    };
    
get(10630) ->
    {ok, #task_base{
            task_id = 10630
            ,name = ?L(<<"准备出发">>)
            ,lev = 1
            ,prev = [10620]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10084
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 3000}
               ,#gain{label = item, val = [111001,1,120]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10640) ->
    {ok, #task_base{
            task_id = 10640
            ,name = ?L(<<"荒漠废墟">>)
            ,lev = 1
            ,prev = [10630]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10084
            ,npc_commit = 10081
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = item, val = [111402,1,1]}
               ,#gain{label = item, val = [111402,1,5]}
            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 12111, target_value = 1,map_id=12111}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 4000}
               ,#gain{label = item, val = [111001,1,220]}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 12091}]
			
        }
    };
    
get(10650) ->
    {ok, #task_base{
            task_id = 10650
            ,name = ?L(<<"询问艾娃">>)
            ,lev = 1
            ,prev = [10640]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10081
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10660) ->
    {ok, #task_base{
            task_id = 10660
            ,name = ?L(<<"回归中庭">>)
            ,lev = 1
            ,prev = [10650]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10670) ->
    {ok, #task_base{
            task_id = 10670
            ,name = ?L(<<"守城伐龙">>)
            ,lev = 1
            ,prev = [10660]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10680) ->
    {ok, #task_base{
            task_id = 10680
            ,name = ?L(<<"对话大臣">>)
            ,lev = 1
            ,prev = [10670]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10690) ->
    {ok, #task_base{
            task_id = 10690
            ,name = ?L(<<"违抗命令">>)
            ,lev = 1
            ,prev = [10680]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10700) ->
    {ok, #task_base{
            task_id = 10700
            ,name = ?L(<<"对话将领">>)
            ,lev = 1
            ,prev = [10690]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10710) ->
    {ok, #task_base{
            task_id = 10710
            ,name = ?L(<<"迷迹腹地">>)
            ,lev = 1
            ,prev = [10700]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 12131, target_value = 1,map_id=12131}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 12121}]
			
        }
    };
    
get(10720) ->
    {ok, #task_base{
            task_id = 10720
            ,name = ?L(<<"炼金作坊">>)
            ,lev = 1
            ,prev = [10710]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10085
            ,npc_commit = 10085
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = coin, val = 12500}
            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 2015, target_value = 1}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 10000}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10730) ->
    {ok, #task_base{
            task_id = 10730
            ,name = ?L(<<"对话将领">>)
            ,lev = 1
            ,prev = [10720]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10740) ->
    {ok, #task_base{
            task_id = 10740
            ,name = ?L(<<"世界树根">>)
            ,lev = 1
            ,prev = [10730]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10750) ->
    {ok, #task_base{
            task_id = 10750
            ,name = ?L(<<"新的任务">>)
            ,lev = 1
            ,prev = [10740]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10760) ->
    {ok, #task_base{
            task_id = 10760
            ,name = ?L(<<"地底之章">>)
            ,lev = 1
            ,prev = [10750]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = [{map_id, 1415}]
			
        }
    };
    
get(10770) ->
    {ok, #task_base{
            task_id = 10770
            ,name = ?L(<<"对话侏儒">>)
            ,lev = 1
            ,prev = [10760]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10780) ->
    {ok, #task_base{
            task_id = 10780
            ,name = ?L(<<"失忆伯特">>)
            ,lev = 1
            ,prev = [10770]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10087
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10790) ->
    {ok, #task_base{
            task_id = 10790
            ,name = ?L(<<"询问艾娃">>)
            ,lev = 1
            ,prev = [10780]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10087
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10800) ->
    {ok, #task_base{
            task_id = 10800
            ,name = ?L(<<"尝试回忆">>)
            ,lev = 1
            ,prev = [10790]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10810) ->
    {ok, #task_base{
            task_id = 10810
            ,name = ?L(<<"树根之路">>)
            ,lev = 1
            ,prev = [10800]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 13011, target_value = 1,map_id=13011}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 13011},{dungeon_map_id, 13}]
			
        }
    };
    
get(10820) ->
    {ok, #task_base{
            task_id = 10820
            ,name = ?L(<<"稍等再来">>)
            ,lev = 1
            ,prev = [10810]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 700}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10830) ->
    {ok, #task_base{
            task_id = 10830
            ,name = ?L(<<"古老术士">>)
            ,lev = 1
            ,prev = [10820]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10089
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 700}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10840) ->
    {ok, #task_base{
            task_id = 10840
            ,name = ?L(<<"世界之树">>)
            ,lev = 1
            ,prev = [10830]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10089
            ,npc_commit = 10089
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 700}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10850) ->
    {ok, #task_base{
            task_id = 10850
            ,name = ?L(<<"神源之史">>)
            ,lev = 1
            ,prev = [10840]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10089
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 700}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10860) ->
    {ok, #task_base{
            task_id = 10860
            ,name = ?L(<<"精炼装备">>)
            ,lev = 1
            ,prev = [10850]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = item, val = [111101,1,5]}
            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 700}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10870) ->
    {ok, #task_base{
            task_id = 10870
            ,name = ?L(<<"对话伯特">>)
            ,lev = 1
            ,prev = [10860]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 700}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10880) ->
    {ok, #task_base{
            task_id = 10880
            ,name = ?L(<<"虚渺根林">>)
            ,lev = 1
            ,prev = [10870]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 13031, target_value = 1,map_id=13031}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 800}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 13021}]
			
        }
    };
    
get(10890) ->
    {ok, #task_base{
            task_id = 10890
            ,name = ?L(<<"故人帽子">>)
            ,lev = 1
            ,prev = [10880]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10900) ->
    {ok, #task_base{
            task_id = 10900
            ,name = ?L(<<"对话伯特">>)
            ,lev = 1
            ,prev = [10890]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10910) ->
    {ok, #task_base{
            task_id = 10910
            ,name = ?L(<<"对话艾娃">>)
            ,lev = 1
            ,prev = [10900]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10920) ->
    {ok, #task_base{
            task_id = 10920
            ,name = ?L(<<"询问将领">>)
            ,lev = 1
            ,prev = [10910]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = special_event, target = 1065, target_value = 1}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10930) ->
    {ok, #task_base{
            task_id = 10930
            ,name = ?L(<<"缉猎海盗">>)
            ,lev = 1
            ,prev = [10920]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10940) ->
    {ok, #task_base{
            task_id = 10940
            ,name = ?L(<<"久远印象">>)
            ,lev = 1
            ,prev = [10930]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10950) ->
    {ok, #task_base{
            task_id = 10950
            ,name = ?L(<<"中庭铁匠">>)
            ,lev = 1
            ,prev = [10940]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10078
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10960) ->
    {ok, #task_base{
            task_id = 10960
            ,name = ?L(<<"铁匠故事">>)
            ,lev = 1
            ,prev = [10950]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10970) ->
    {ok, #task_base{
            task_id = 10970
            ,name = ?L(<<"稍作休息">>)
            ,lev = 1
            ,prev = [10960]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10980) ->
    {ok, #task_base{
            task_id = 10980
            ,name = ?L(<<"侏儒之候">>)
            ,lev = 1
            ,prev = [10970]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(10990) ->
    {ok, #task_base{
            task_id = 10990
            ,name = ?L(<<"萤火之森">>)
            ,lev = 1
            ,prev = [10980]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 13061, target_value = 1,map_id=13061}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 13041}]
			
        }
    };
    
get(11000) ->
    {ok, #task_base{
            task_id = 11000
            ,name = ?L(<<"伯特之喜">>)
            ,lev = 1
            ,prev = [10990]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11010) ->
    {ok, #task_base{
            task_id = 11010
            ,name = ?L(<<"四处逛逛">>)
            ,lev = 1
            ,prev = [11000]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10089
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11020) ->
    {ok, #task_base{
            task_id = 11020
            ,name = ?L(<<"术士感慨">>)
            ,lev = 1
            ,prev = [11010]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10089
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11030) ->
    {ok, #task_base{
            task_id = 11030
            ,name = ?L(<<"新的记忆">>)
            ,lev = 1
            ,prev = [11020]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11040) ->
    {ok, #task_base{
            task_id = 11040
            ,name = ?L(<<"神源之地">>)
            ,lev = 1
            ,prev = [11030]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 13091, target_value = 1,map_id=13091}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 13071}]
			
        }
    };
    
get(11050) ->
    {ok, #task_base{
            task_id = 11050
            ,name = ?L(<<"询问伯特">>)
            ,lev = 1
            ,prev = [11040]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11060) ->
    {ok, #task_base{
            task_id = 11060
            ,name = ?L(<<"吸收神源">>)
            ,lev = 1
            ,prev = [11050]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11070) ->
    {ok, #task_base{
            task_id = 11070
            ,name = ?L(<<"盘根之谷">>)
            ,lev = 1
            ,prev = [11060]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 13121, target_value = 1,map_id=13121}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 13101}]
			
        }
    };
    
get(11080) ->
    {ok, #task_base{
            task_id = 11080
            ,name = ?L(<<"神之觉醒">>)
            ,lev = 1
            ,prev = [11070]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
               ,#gain{label = stone, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11090) ->
    {ok, #task_base{
            task_id = 11090
            ,name = ?L(<<"对话将领">>)
            ,lev = 1
            ,prev = [11080]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11100) ->
    {ok, #task_base{
            task_id = 11100
            ,name = ?L(<<"将领心意">>)
            ,lev = 1
            ,prev = [11090]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11110) ->
    {ok, #task_base{
            task_id = 11110
            ,name = ?L(<<"狼嚎节日">>)
            ,lev = 1
            ,prev = [11100]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10104
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11120) ->
    {ok, #task_base{
            task_id = 11120
            ,name = ?L(<<"女神祭台">>)
            ,lev = 1
            ,prev = [11110]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10104
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 11091, target_value = 1,map_id=11091}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11130) ->
    {ok, #task_base{
            task_id = 11130
            ,name = ?L(<<"将领之情">>)
            ,lev = 1
            ,prev = [11120]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11140) ->
    {ok, #task_base{
            task_id = 11140
            ,name = ?L(<<"卡萝的心">>)
            ,lev = 1
            ,prev = [11130]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10078
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11150) ->
    {ok, #task_base{
            task_id = 11150
            ,name = ?L(<<"逗逗将领">>)
            ,lev = 1
            ,prev = [11140]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11160) ->
    {ok, #task_base{
            task_id = 11160
            ,name = ?L(<<"树根之路">>)
            ,lev = 1
            ,prev = [11150]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 13011, target_value = 1,map_id=13011}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11170) ->
    {ok, #task_base{
            task_id = 11170
            ,name = ?L(<<"小小担忧">>)
            ,lev = 1
            ,prev = [11160]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11180) ->
    {ok, #task_base{
            task_id = 11180
            ,name = ?L(<<"神秘商人">>)
            ,lev = 1
            ,prev = [11170]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10074
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11190) ->
    {ok, #task_base{
            task_id = 11190
            ,name = ?L(<<"绿涛旷野">>)
            ,lev = 1
            ,prev = [11180]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10074
            ,npc_commit = 10074
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 11031, target_value = 1,map_id=11031}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11200) ->
    {ok, #task_base{
            task_id = 11200
            ,name = ?L(<<"询问卡萝">>)
            ,lev = 1
            ,prev = [11190]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10074
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11210) ->
    {ok, #task_base{
            task_id = 11210
            ,name = ?L(<<"狼牙面包">>)
            ,lev = 1
            ,prev = [11200]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10078
            ,npc_commit = 10104
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11220) ->
    {ok, #task_base{
            task_id = 11220
            ,name = ?L(<<"告诉艾娃">>)
            ,lev = 1
            ,prev = [11210]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10104
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11230) ->
    {ok, #task_base{
            task_id = 11230
            ,name = ?L(<<"侏儒国度">>)
            ,lev = 1
            ,prev = [11220]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11240) ->
    {ok, #task_base{
            task_id = 11240
            ,name = ?L(<<"萤火之森">>)
            ,lev = 1
            ,prev = [11230]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 13061, target_value = 1,map_id=13061}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11250) ->
    {ok, #task_base{
            task_id = 11250
            ,name = ?L(<<"报告艾娃">>)
            ,lev = 1
            ,prev = [11240]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11260) ->
    {ok, #task_base{
            task_id = 11260
            ,name = ?L(<<"报告进度">>)
            ,lev = 1
            ,prev = [11250]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10074
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11270) ->
    {ok, #task_base{
            task_id = 11270
            ,name = ?L(<<"卡萝大妈">>)
            ,lev = 1
            ,prev = [11260]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11280) ->
    {ok, #task_base{
            task_id = 11280
            ,name = ?L(<<"好事多磨">>)
            ,lev = 1
            ,prev = [11270]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10078
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11290) ->
    {ok, #task_base{
            task_id = 11290
            ,name = ?L(<<"荧光洞穴">>)
            ,lev = 1
            ,prev = [11280]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 14011, target_value = 1,map_id=14011}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 14011},{dungeon_map_id, 14}]
			
        }
    };
    
get(11300) ->
    {ok, #task_base{
            task_id = 11300
            ,name = ?L(<<"故人呢喃">>)
            ,lev = 1
            ,prev = [11290]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11310) ->
    {ok, #task_base{
            task_id = 11310
            ,name = ?L(<<"神觉强化">>)
            ,lev = 1
            ,prev = [11300]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10078
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                #gain{label = item, val = [231001,1,1]}
            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
               ,#gain{label = stone, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11320) ->
    {ok, #task_base{
            task_id = 11320
            ,name = ?L(<<"侏儒国度">>)
            ,lev = 1
            ,prev = [11310]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11330) ->
    {ok, #task_base{
            task_id = 11330
            ,name = ?L(<<"询问艾娃">>)
            ,lev = 1
            ,prev = [11320]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11340) ->
    {ok, #task_base{
            task_id = 11340
            ,name = ?L(<<"沉寂湖畔">>)
            ,lev = 1
            ,prev = [11330]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11350) ->
    {ok, #task_base{
            task_id = 11350
            ,name = ?L(<<"沉寂湖畔">>)
            ,lev = 1
            ,prev = [11340]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10086
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 14031, target_value = 1,map_id=14031}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 14021}]
			
        }
    };
    
get(11360) ->
    {ok, #task_base{
            task_id = 11360
            ,name = ?L(<<"新的朋友">>)
            ,lev = 1
            ,prev = [11350]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10086
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11390) ->
    {ok, #task_base{
            task_id = 11390
            ,name = ?L(<<"树根囚笼">>)
            ,lev = 1
            ,prev = [11360]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 14061, target_value = 1,map_id=14061}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 14041}]
			
        }
    };
    
get(11400) ->
    {ok, #task_base{
            task_id = 11400
            ,name = ?L(<<"询问卡萝">>)
            ,lev = 1
            ,prev = [11390]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11410) ->
    {ok, #task_base{
            task_id = 11410
            ,name = ?L(<<"询问将领">>)
            ,lev = 1
            ,prev = [11400]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10078
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11420) ->
    {ok, #task_base{
            task_id = 11420
            ,name = ?L(<<"将领指示">>)
            ,lev = 1
            ,prev = [11410]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11430) ->
    {ok, #task_base{
            task_id = 11430
            ,name = ?L(<<"侏儒国度">>)
            ,lev = 1
            ,prev = [11420]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11440) ->
    {ok, #task_base{
            task_id = 11440
            ,name = ?L(<<"幽暗地穴">>)
            ,lev = 1
            ,prev = [11430]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 14091, target_value = 1,map_id=14091}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 14071}]
			
        }
    };
    
get(11450) ->
    {ok, #task_base{
            task_id = 11450
            ,name = ?L(<<"回归中庭">>)
            ,lev = 1
            ,prev = [11440]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11460) ->
    {ok, #task_base{
            task_id = 11460
            ,name = ?L(<<"对话将领">>)
            ,lev = 1
            ,prev = [11450]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11470) ->
    {ok, #task_base{
            task_id = 11470
            ,name = ?L(<<"提交任务">>)
            ,lev = 1
            ,prev = [11460]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11480) ->
    {ok, #task_base{
            task_id = 11480
            ,name = ?L(<<"稍作休整">>)
            ,lev = 1
            ,prev = [11470]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11490) ->
    {ok, #task_base{
            task_id = 11490
            ,name = ?L(<<"面对黑暗">>)
            ,lev = 1
            ,prev = [11480]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11500) ->
    {ok, #task_base{
            task_id = 11500
            ,name = ?L(<<"迷踪深渊">>)
            ,lev = 1
            ,prev = [11490]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10090
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 14121, target_value = 1,map_id=14121}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 14101}]
			
        }
    };
    
get(11510) ->
    {ok, #task_base{
            task_id = 11510
            ,name = ?L(<<"返回中庭">>)
            ,lev = 1
            ,prev = [11500]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10090
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11520) ->
    {ok, #task_base{
            task_id = 11520
            ,name = ?L(<<"对话将领">>)
            ,lev = 1
            ,prev = [11510]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11530) ->
    {ok, #task_base{
            task_id = 11530
            ,name = ?L(<<"面见大臣">>)
            ,lev = 1
            ,prev = [11520]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11540) ->
    {ok, #task_base{
            task_id = 11540
            ,name = ?L(<<"再做休息">>)
            ,lev = 1
            ,prev = [11530]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11550) ->
    {ok, #task_base{
            task_id = 11550
            ,name = ?L(<<"新的历程">>)
            ,lev = 1
            ,prev = [11540]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11560) ->
    {ok, #task_base{
            task_id = 11560
            ,name = ?L(<<"前往雪山">>)
            ,lev = 1
            ,prev = [11550]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11570) ->
    {ok, #task_base{
            task_id = 11570
            ,name = ?L(<<"雪山之章">>)
            ,lev = 1
            ,prev = [11560]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = [{map_id,1420}]
			
        }
    };
    
get(11580) ->
    {ok, #task_base{
            task_id = 11580
            ,name = ?L(<<"询问居民">>)
            ,lev = 1
            ,prev = [11570]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10092
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11590) ->
    {ok, #task_base{
            task_id = 11590
            ,name = ?L(<<"霜雪冰龙">>)
            ,lev = 1
            ,prev = [11580]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10092
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11600) ->
    {ok, #task_base{
            task_id = 11600
            ,name = ?L(<<"凛冽冰谷">>)
            ,lev = 1
            ,prev = [11590]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 15011, target_value = 1,map_id=15011}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 15011},{dungeon_map_id, 15}]
			
        }
    };
    
get(11610) ->
    {ok, #task_base{
            task_id = 11610
            ,name = ?L(<<"隐伏巨怪">>)
            ,lev = 1
            ,prev = [11600]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10092
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11620) ->
    {ok, #task_base{
            task_id = 11620
            ,name = ?L(<<"再问详细">>)
            ,lev = 40
            ,prev = [11610]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10092
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11630) ->
    {ok, #task_base{
            task_id = 11630
            ,name = ?L(<<"神秘守将">>)
            ,lev = 1
            ,prev = [11620]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10092
            ,npc_commit = 10096
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11640) ->
    {ok, #task_base{
            task_id = 11640
            ,name = ?L(<<"汇报艾娃">>)
            ,lev = 1
            ,prev = [11630]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10096
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11650) ->
    {ok, #task_base{
            task_id = 11650
            ,name = ?L(<<"冰棱之森">>)
            ,lev = 1
            ,prev = [11640]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 15041, target_value = 1,map_id=15041}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1200}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 15021}]
			
        }
    };
    
get(11660) ->
    {ok, #task_base{
            task_id = 11660
            ,name = ?L(<<"妇女之愁">>)
            ,lev = 1
            ,prev = [11650]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10096
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11670) ->
    {ok, #task_base{
            task_id = 11670
            ,name = ?L(<<"再寻妇人">>)
            ,lev = 1
            ,prev = [11660]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10096
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11680) ->
    {ok, #task_base{
            task_id = 11680
            ,name = ?L(<<"风暴要塞">>)
            ,lev = 1
            ,prev = [11670]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10096
            ,npc_commit = 10096
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 15071, target_value = 1,map_id=15071}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 15051}]
			
        }
    };
    
get(11690) ->
    {ok, #task_base{
            task_id = 11690
            ,name = ?L(<<"再做准备">>)
            ,lev = 1
            ,prev = [11680]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10096
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11700) ->
    {ok, #task_base{
            task_id = 11700
            ,name = ?L(<<"妇人之忧">>)
            ,lev = 1
            ,prev = [11690]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10096
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11710) ->
    {ok, #task_base{
            task_id = 11710
            ,name = ?L(<<"荒芜雪野">>)
            ,lev = 1
            ,prev = [11700]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10096
            ,npc_commit = 10096
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 15101, target_value = 1,map_id=15101}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 15081}]
			
        }
    };
    
get(11720) ->
    {ok, #task_base{
            task_id = 11720
            ,name = ?L(<<"怪物守卫">>)
            ,lev = 1
            ,prev = [11710]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10096
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11730) ->
    {ok, #task_base{
            task_id = 11730
            ,name = ?L(<<"艾娃之思">>)
            ,lev = 1
            ,prev = [11720]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10096
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11740) ->
    {ok, #task_base{
            task_id = 11740
            ,name = ?L(<<"再次寻踪">>)
            ,lev = 1
            ,prev = [11730]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10096
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11750) ->
    {ok, #task_base{
            task_id = 11750
            ,name = ?L(<<"狼嚎野岭">>)
            ,lev = 1
            ,prev = [11740]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10096
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 15131, target_value = 1,map_id=15131}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1500}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 15111}]
			
        }
    };
    
get(11760) ->
    {ok, #task_base{
            task_id = 11760
            ,name = ?L(<<"雪神之隐">>)
            ,lev = 1
            ,prev = [11750]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10096
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11770) ->
    {ok, #task_base{
            task_id = 11770
            ,name = ?L(<<"先这样吧">>)
            ,lev = 1
            ,prev = [11760]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10096
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11780) ->
    {ok, #task_base{
            task_id = 11780
            ,name = ?L(<<"刀锋高地">>)
            ,lev = 1
            ,prev = [11770]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 16011, target_value = 1,map_id=16011}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 3000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 16011},{dungeon_map_id, 16}]
			
        }
    };
    
get(11790) ->
    {ok, #task_base{
            task_id = 11790
            ,name = ?L(<<"巨人秘闻">>)
            ,lev = 1
            ,prev = [11780]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10092
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11800) ->
    {ok, #task_base{
            task_id = 11800
            ,name = ?L(<<"再做准备">>)
            ,lev = 45
            ,prev = [11790]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10092
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11810) ->
    {ok, #task_base{
            task_id = 11810
            ,name = ?L(<<"巨槌峰峦">>)
            ,lev = 1
            ,prev = [11800]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 16041, target_value = 1,map_id=16041}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 3000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 16021}]
			
        }
    };
    
get(11820) ->
    {ok, #task_base{
            task_id = 11820
            ,name = ?L(<<"龙与巨人">>)
            ,lev = 1
            ,prev = [11810]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10092
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11830) ->
    {ok, #task_base{
            task_id = 11830
            ,name = ?L(<<"诸神矛盾">>)
            ,lev = 1
            ,prev = [11820]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10092
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11840) ->
    {ok, #task_base{
            task_id = 11840
            ,name = ?L(<<"暮色雪岭">>)
            ,lev = 1
            ,prev = [11830]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 16071, target_value = 1,map_id=16071}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 3000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 16051}]
			
        }
    };
    
get(11850) ->
    {ok, #task_base{
            task_id = 11850
            ,name = ?L(<<"巨人之仇">>)
            ,lev = 1
            ,prev = [11840]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10096
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 3000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11860) ->
    {ok, #task_base{
            task_id = 11860
            ,name = ?L(<<"风雪之巅">>)
            ,lev = 1
            ,prev = [11850]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 16101, target_value = 1,map_id=16101}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 4000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 16081}]
			
        }
    };
    
get(11870) ->
    {ok, #task_base{
            task_id = 11870
            ,name = ?L(<<"请教将领">>)
            ,lev = 1
            ,prev = [11860]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11880) ->
    {ok, #task_base{
            task_id = 11880
            ,name = ?L(<<"决战之夕">>)
            ,lev = 1
            ,prev = [11870]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11890) ->
    {ok, #task_base{
            task_id = 11890
            ,name = ?L(<<"巨人山城">>)
            ,lev = 1
            ,prev = [11880]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10095
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 16131, target_value = 1,map_id=16131}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 3000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 16111}]
			
        }
    };
    
get(11900) ->
    {ok, #task_base{
            task_id = 11900
            ,name = ?L(<<"王国阴谋">>)
            ,lev = 1
            ,prev = [11890]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10095
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11910) ->
    {ok, #task_base{
            task_id = 11910
            ,name = ?L(<<"将领回忆">>)
            ,lev = 1
            ,prev = [11900]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11920) ->
    {ok, #task_base{
            task_id = 11920
            ,name = ?L(<<"骑士卡尔">>)
            ,lev = 1
            ,prev = [11910]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11930) ->
    {ok, #task_base{
            task_id = 11930
            ,name = ?L(<<"卡萝之忆">>)
            ,lev = 1
            ,prev = [11920]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10078
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11940) ->
    {ok, #task_base{
            task_id = 11940
            ,name = ?L(<<"身负使命">>)
            ,lev = 1
            ,prev = [11930]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11950) ->
    {ok, #task_base{
            task_id = 11950
            ,name = ?L(<<"新的使命">>)
            ,lev = 1
            ,prev = [11940]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11960) ->
    {ok, #task_base{
            task_id = 11960
            ,name = ?L(<<"封魔之书">>)
            ,lev = 1
            ,prev = [11950]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11970) ->
    {ok, #task_base{
            task_id = 11970
            ,name = ?L(<<"荒废地牢">>)
            ,lev = 1
            ,prev = [11960]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = [{map_id,1425}]
			
        }
    };
    
get(11980) ->
    {ok, #task_base{
            task_id = 11980
            ,name = ?L(<<"询问他人">>)
            ,lev = 1
            ,prev = [11970]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10097
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(11990) ->
    {ok, #task_base{
            task_id = 11990
            ,name = ?L(<<"询问阿春">>)
            ,lev = 1
            ,prev = [11980]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10097
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12000) ->
    {ok, #task_base{
            task_id = 12000
            ,name = ?L(<<"回复艾娃">>)
            ,lev = 1
            ,prev = [11990]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12010) ->
    {ok, #task_base{
            task_id = 12010
            ,name = ?L(<<"四处找找">>)
            ,lev = 1
            ,prev = [12000]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 700}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12020) ->
    {ok, #task_base{
            task_id = 12020
            ,name = ?L(<<"暮光峡湾">>)
            ,lev = 1
            ,prev = [12010]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 17011, target_value = 1,map_id=17011}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 700}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 17011},{dungeon_map_id, 17}]
			
        }
    };
    
get(12030) ->
    {ok, #task_base{
            task_id = 12030
            ,name = ?L(<<"报告艾娃">>)
            ,lev = 1
            ,prev = [12020]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12040) ->
    {ok, #task_base{
            task_id = 12040
            ,name = ?L(<<"春的来信">>)
            ,lev = 1
            ,prev = [12030]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12050) ->
    {ok, #task_base{
            task_id = 12050
            ,name = ?L(<<"询问阿春">>)
            ,lev = 50
            ,prev = [12040]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12060) ->
    {ok, #task_base{
            task_id = 12060
            ,name = ?L(<<"飞雪法杖">>)
            ,lev = 1
            ,prev = [12050]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12070) ->
    {ok, #task_base{
            task_id = 12070
            ,name = ?L(<<"荒骨走道">>)
            ,lev = 1
            ,prev = [12060]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 17041, target_value = 1,map_id=17041}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1600}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 17021}]
			
        }
    };
    
get(12080) ->
    {ok, #task_base{
            task_id = 12080
            ,name = ?L(<<"回复阿春">>)
            ,lev = 1
            ,prev = [12070]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12090) ->
    {ok, #task_base{
            task_id = 12090
            ,name = ?L(<<"回复艾娃">>)
            ,lev = 1
            ,prev = [12080]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12100) ->
    {ok, #task_base{
            task_id = 12100
            ,name = ?L(<<"新的消息">>)
            ,lev = 1
            ,prev = [12090]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12110) ->
    {ok, #task_base{
            task_id = 12110
            ,name = ?L(<<"冒险者们">>)
            ,lev = 1
            ,prev = [12100]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10097
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12120) ->
    {ok, #task_base{
            task_id = 12120
            ,name = ?L(<<"春的等候">>)
            ,lev = 1
            ,prev = [12110]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10097
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1400}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12130) ->
    {ok, #task_base{
            task_id = 12130
            ,name = ?L(<<"荒废之路">>)
            ,lev = 1
            ,prev = [12120]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 17071, target_value = 1,map_id=17071}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1400}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 17051}]
			
        }
    };
    
get(12140) ->
    {ok, #task_base{
            task_id = 12140
            ,name = ?L(<<"回马奥瑞">>)
            ,lev = 1
            ,prev = [12130]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10097
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12150) ->
    {ok, #task_base{
            task_id = 12150
            ,name = ?L(<<"回复艾娃">>)
            ,lev = 1
            ,prev = [12140]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10097
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12160) ->
    {ok, #task_base{
            task_id = 12160
            ,name = ?L(<<"妖精消息">>)
            ,lev = 1
            ,prev = [12150]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10104
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12170) ->
    {ok, #task_base{
            task_id = 12170
            ,name = ?L(<<"告知阿春">>)
            ,lev = 1
            ,prev = [12160]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12180) ->
    {ok, #task_base{
            task_id = 12180
            ,name = ?L(<<"绝望回廊">>)
            ,lev = 1
            ,prev = [12170]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 17101, target_value = 1,map_id=17101}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1600}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 17081}]
			
        }
    };
    
get(12190) ->
    {ok, #task_base{
            task_id = 12190
            ,name = ?L(<<"巨人动静">>)
            ,lev = 1
            ,prev = [12180]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12200) ->
    {ok, #task_base{
            task_id = 12200
            ,name = ?L(<<"报告将领">>)
            ,lev = 1
            ,prev = [12190]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12210) ->
    {ok, #task_base{
            task_id = 12210
            ,name = ?L(<<"回复艾娃">>)
            ,lev = 1
            ,prev = [12200]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12220) ->
    {ok, #task_base{
            task_id = 12220
            ,name = ?L(<<"发现入口">>)
            ,lev = 1
            ,prev = [12210]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12230) ->
    {ok, #task_base{
            task_id = 12230
            ,name = ?L(<<"询问火山">>)
            ,lev = 1
            ,prev = [12220]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10098
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1400}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12240) ->
    {ok, #task_base{
            task_id = 12240
            ,name = ?L(<<"地牢入口">>)
            ,lev = 1
            ,prev = [12230]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10098
            ,npc_commit = 10097
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 17131, target_value = 1,map_id=17131}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1400}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 17111}]
			
        }
    };
    
get(12250) ->
    {ok, #task_base{
            task_id = 12250
            ,name = ?L(<<"书籍妖精">>)
            ,lev = 1
            ,prev = [12240]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10097
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12260) ->
    {ok, #task_base{
            task_id = 12260
            ,name = ?L(<<"海姆达尔">>)
            ,lev = 1
            ,prev = [12250]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12270) ->
    {ok, #task_base{
            task_id = 12270
            ,name = ?L(<<"回复艾娃">>)
            ,lev = 1
            ,prev = [12260]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12280) ->
    {ok, #task_base{
            task_id = 12280
            ,name = ?L(<<"获得钥匙">>)
            ,lev = 1
            ,prev = [12270]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12290) ->
    {ok, #task_base{
            task_id = 12290
            ,name = ?L(<<"书籍妖精">>)
            ,lev = 1
            ,prev = [12280]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12300) ->
    {ok, #task_base{
            task_id = 12300
            ,name = ?L(<<"噩梦地牢">>)
            ,lev = 1
            ,prev = [12290]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 18011, target_value = 1,map_id=18011}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 18011},{dungeon_map_id, 18}]
			
        }
    };
    
get(12310) ->
    {ok, #task_base{
            task_id = 12310
            ,name = ?L(<<"怪物信息">>)
            ,lev = 1
            ,prev = [12300]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10097
            ,npc_commit = 10098
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12320) ->
    {ok, #task_base{
            task_id = 12320
            ,name = ?L(<<"询问信息">>)
            ,lev = 1
            ,prev = [12310]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10098
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12330) ->
    {ok, #task_base{
            task_id = 12330
            ,name = ?L(<<"回复艾娃">>)
            ,lev = 1
            ,prev = [12320]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12340) ->
    {ok, #task_base{
            task_id = 12340
            ,name = ?L(<<"新的情报">>)
            ,lev = 1
            ,prev = [12330]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10104
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12350) ->
    {ok, #task_base{
            task_id = 12350
            ,name = ?L(<<"书籍妖精">>)
            ,lev = 55
            ,prev = [12340]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12360) ->
    {ok, #task_base{
            task_id = 12360
            ,name = ?L(<<"幽魂牢笼">>)
            ,lev = 1
            ,prev = [12350]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 18041, target_value = 1,map_id=18041}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 18021}]
			
        }
    };
    
get(12370) ->
    {ok, #task_base{
            task_id = 12370
            ,name = ?L(<<"询问阿春">>)
            ,lev = 1
            ,prev = [12360]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12380) ->
    {ok, #task_base{
            task_id = 12380
            ,name = ?L(<<"回复艾娃">>)
            ,lev = 1
            ,prev = [12370]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12390) ->
    {ok, #task_base{
            task_id = 12390
            ,name = ?L(<<"神的干涉">>)
            ,lev = 1
            ,prev = [12380]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10104
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12400) ->
    {ok, #task_base{
            task_id = 12400
            ,name = ?L(<<"书籍妖精">>)
            ,lev = 1
            ,prev = [12390]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12410) ->
    {ok, #task_base{
            task_id = 12410
            ,name = ?L(<<"森火之狱">>)
            ,lev = 1
            ,prev = [12400]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 18071, target_value = 1,map_id=18071}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 18051}]
			
        }
    };
    
get(12420) ->
    {ok, #task_base{
            task_id = 12420
            ,name = ?L(<<"询问阿春">>)
            ,lev = 1
            ,prev = [12410]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12430) ->
    {ok, #task_base{
            task_id = 12430
            ,name = ?L(<<"回复艾娃">>)
            ,lev = 1
            ,prev = [12420]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12440) ->
    {ok, #task_base{
            task_id = 12440
            ,name = ?L(<<"新的发现">>)
            ,lev = 1
            ,prev = [12430]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 3000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12450) ->
    {ok, #task_base{
            task_id = 12450
            ,name = ?L(<<"厄运牢房">>)
            ,lev = 1
            ,prev = [12440]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 18101, target_value = 1,map_id=18101}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 3000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 18081}]
			
        }
    };
    
get(12460) ->
    {ok, #task_base{
            task_id = 12460
            ,name = ?L(<<"询问火山">>)
            ,lev = 1
            ,prev = [12450]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10098
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12470) ->
    {ok, #task_base{
            task_id = 12470
            ,name = ?L(<<"询问阿春">>)
            ,lev = 1
            ,prev = [12460]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10098
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12480) ->
    {ok, #task_base{
            task_id = 12480
            ,name = ?L(<<"回复艾娃">>)
            ,lev = 1
            ,prev = [12470]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12490) ->
    {ok, #task_base{
            task_id = 12490
            ,name = ?L(<<"临战前夕">>)
            ,lev = 1
            ,prev = [12480]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12500) ->
    {ok, #task_base{
            task_id = 12500
            ,name = ?L(<<"沉息之地">>)
            ,lev = 1
            ,prev = [12490]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10105
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = sweep_dungeon, target = 18131, target_value = 1,map_id=18131}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
            ]
            ,times = 1
			,accept_open_map = [{dungeon_id, 18111}]
			
        }
    };
    
get(12510) ->
    {ok, #task_base{
            task_id = 12510
            ,name = ?L(<<"告知阿春">>)
            ,lev = 1
            ,prev = [12500]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10105
            ,npc_commit = 10099
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12520) ->
    {ok, #task_base{
            task_id = 12520
            ,name = ?L(<<"回复艾娃">>)
            ,lev = 1
            ,prev = [12510]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10099
            ,npc_commit = 10100
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12530) ->
    {ok, #task_base{
            task_id = 12530
            ,name = ?L(<<"归去中庭">>)
            ,lev = 1
            ,prev = [12520]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10100
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12540) ->
    {ok, #task_base{
            task_id = 12540
            ,name = ?L(<<"请示将领">>)
            ,lev = 1
            ,prev = [12530]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10076
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12550) ->
    {ok, #task_base{
            task_id = 12550
            ,name = ?L(<<"报告大臣">>)
            ,lev = 60
            ,prev = [12540]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10077
            ,npc_commit = 10075
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(12560) ->
    {ok, #task_base{
            task_id = 12560
            ,name = ?L(<<"王国野心">>)
            ,lev = 1
            ,prev = [12550]
            ,kind = 1
            ,type = 1            ,career = 9
            ,delegate = 0
            ,npc_accept = 10075
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30001) ->
    {ok, #task_base{
            task_id = 30001
            ,name = ?L(<<"卡罗袜子">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501201,1,1]}
               ,#gain{label = coin, val = 20000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30002) ->
    {ok, #task_base{
            task_id = 30002
            ,name = ?L(<<"卡罗袜子">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10078
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501201,1,1]}
               ,#gain{label = coin, val = 3000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30003) ->
    {ok, #task_base{
            task_id = 30003
            ,name = ?L(<<"艾娃发卡">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501202,1,1]}
               ,#gain{label = item, val = [231001,1,1]}
               ,#gain{label = stone, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30004) ->
    {ok, #task_base{
            task_id = 30004
            ,name = ?L(<<"艾娃发卡">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10076
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501202,1,1]}
               ,#gain{label = coin, val = 6000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30005) ->
    {ok, #task_base{
            task_id = 30005
            ,name = ?L(<<"将领勋章">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501203,1,1]}
               ,#gain{label = item, val = [621100,1,1]}
               ,#gain{label = coin, val = 8000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30006) ->
    {ok, #task_base{
            task_id = 30006
            ,name = ?L(<<"将领勋章">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10077
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501203,1,1]}
               ,#gain{label = coin, val = 2000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30007) ->
    {ok, #task_base{
            task_id = 30007
            ,name = ?L(<<"村长帽子">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10070
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501204,1,1]}
               ,#gain{label = item, val = [111301,1,1]}
               ,#gain{label = coin, val = 6000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30008) ->
    {ok, #task_base{
            task_id = 30008
            ,name = ?L(<<"村长帽子">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10070
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501204,1,1]}
               ,#gain{label = coin, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30009) ->
    {ok, #task_base{
            task_id = 30009
            ,name = ?L(<<"巫师法书">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10072
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501205,1,1]}
               ,#gain{label = item, val = [621501,1,1]}
               ,#gain{label = coin, val = 6000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30010) ->
    {ok, #task_base{
            task_id = 30010
            ,name = ?L(<<"巫师法书">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10072
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501205,1,1]}
               ,#gain{label = coin, val = 3000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30011) ->
    {ok, #task_base{
            task_id = 30011
            ,name = ?L(<<"威利小刀">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10091
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501206,1,1]}
               ,#gain{label = item, val = [641201,1,1]}
               ,#gain{label = stone, val = 1000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30012) ->
    {ok, #task_base{
            task_id = 30012
            ,name = ?L(<<"威利小刀">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10091
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501206,1,1]}
               ,#gain{label = stone, val = 300}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30013) ->
    {ok, #task_base{
            task_id = 30013
            ,name = ?L(<<"凯文手套">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10089
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501207,1,1]}
               ,#gain{label = item, val = [621502,1,1]}
               ,#gain{label = coin, val = 12000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30014) ->
    {ok, #task_base{
            task_id = 30014
            ,name = ?L(<<"凯文手套">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10089
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501207,1,1]}
               ,#gain{label = stone, val = 100}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30015) ->
    {ok, #task_base{
            task_id = 30015
            ,name = ?L(<<"骑士戒指">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10084
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501208,1,1]}
               ,#gain{label = item, val = [621502,1,1]}
               ,#gain{label = coin, val = 4000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30016) ->
    {ok, #task_base{
            task_id = 30016
            ,name = ?L(<<"骑士戒指">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10084
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501208,1,1]}
               ,#gain{label = coin, val = 500}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30017) ->
    {ok, #task_base{
            task_id = 30017
            ,name = ?L(<<"元老围巾">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10103
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501209,1,1]}
               ,#gain{label = item, val = [131001,1,1]}
               ,#gain{label = stone, val = 800}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30018) ->
    {ok, #task_base{
            task_id = 30018
            ,name = ?L(<<"元老围巾">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10103
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501209,1,1]}
               ,#gain{label = stone, val = 600}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30019) ->
    {ok, #task_base{
            task_id = 30019
            ,name = ?L(<<"神秘丝巾">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10074
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501210,1,1]}
               ,#gain{label = item, val = [611101,1,1]}
               ,#gain{label = coin, val = 5000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(30020) ->
    {ok, #task_base{
            task_id = 30020
            ,name = ?L(<<"神秘丝巾">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 9            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 10074
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                            ]
            ,finish_rewards = [
                #loss{label = item, val = [501210,1,1]}
               ,#gain{label = stone, val = 100}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(50011) ->
    {ok, #task_base{
            task_id = 50011
            ,name = ?L(<<"精灵之森(困难)">>)
            ,lev = 1
            ,prev = [10210]
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {10012, 1}, target_value = 1,map_id=10012}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111425,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(50021) ->
    {ok, #task_base{
            task_id = 50021
            ,name = ?L(<<"日光小径(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {10032, 1}, target_value = 1,map_id=10032}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111426,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(50031) ->
    {ok, #task_base{
            task_id = 50031
            ,name = ?L(<<"月光森林(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {10052, 1}, target_value = 1,map_id=10052}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111425,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(50041) ->
    {ok, #task_base{
            task_id = 50041
            ,name = ?L(<<"魅影丛林(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {10072, 1}, target_value = 1,map_id=10072}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111425,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(50051) ->
    {ok, #task_base{
            task_id = 50051
            ,name = ?L(<<"影月林间(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {10092, 1}, target_value = 1,map_id=10092}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111426,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(50061) ->
    {ok, #task_base{
            task_id = 50061
            ,name = ?L(<<"女巫秘林(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {10112, 1}, target_value = 1,map_id=10112}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111426,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(51011) ->
    {ok, #task_base{
            task_id = 51011
            ,name = ?L(<<"晨曦小径(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {11012, 1}, target_value = 1,map_id=11012}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111232,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(51021) ->
    {ok, #task_base{
            task_id = 51021
            ,name = ?L(<<"绿涛旷野(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {11032, 1}, target_value = 1,map_id=11032}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111212,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(51031) ->
    {ok, #task_base{
            task_id = 51031
            ,name = ?L(<<"崇神湿地(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {11052, 1}, target_value = 1,map_id=11052}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111242,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(51041) ->
    {ok, #task_base{
            task_id = 51041
            ,name = ?L(<<"贫瘠腹地(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {11072, 1}, target_value = 1,map_id=11072}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111232,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(51051) ->
    {ok, #task_base{
            task_id = 51051
            ,name = ?L(<<"女神祭台(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {11092, 1}, target_value = 1,map_id=11092}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 2000}
               ,#gain{label = item, val = [111212,1,1]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(52011) ->
    {ok, #task_base{
            task_id = 52011
            ,name = ?L(<<"遗忘之路(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {12012, 1}, target_value = 1,map_id=12012}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 14000}
               ,#gain{label = item, val = [535644,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(52021) ->
    {ok, #task_base{
            task_id = 52021
            ,name = ?L(<<"失落沙丘(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {12032, 1}, target_value = 1,map_id=12032}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 14000}
               ,#gain{label = item, val = [535644,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(52031) ->
    {ok, #task_base{
            task_id = 52031
            ,name = ?L(<<"祭祀迷道(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {12062, 1}, target_value = 1,map_id=12062}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 14000}
               ,#gain{label = item, val = [535644,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(52041) ->
    {ok, #task_base{
            task_id = 52041
            ,name = ?L(<<"毒蝎之穴(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {12082, 1}, target_value = 1,map_id=12082}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 14000}
               ,#gain{label = item, val = [535644,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(52051) ->
    {ok, #task_base{
            task_id = 52051
            ,name = ?L(<<"荒漠废墟(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {12112, 1}, target_value = 1,map_id=12112}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 14000}
               ,#gain{label = item, val = [535644,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(52061) ->
    {ok, #task_base{
            task_id = 52061
            ,name = ?L(<<"迷迹腹地(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {12132, 1}, target_value = 1,map_id=12132}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 14000}
               ,#gain{label = item, val = [535644,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(53011) ->
    {ok, #task_base{
            task_id = 53011
            ,name = ?L(<<"树根之路(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {13012, 1}, target_value = 1,map_id=13012}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 16000}
               ,#gain{label = item, val = [535651,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(53021) ->
    {ok, #task_base{
            task_id = 53021
            ,name = ?L(<<"虚渺根林(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {13032, 1}, target_value = 1,map_id=13032}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 16000}
               ,#gain{label = item, val = [535651,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(53031) ->
    {ok, #task_base{
            task_id = 53031
            ,name = ?L(<<"萤火之森(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {13062, 1}, target_value = 1,map_id=13062}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 16000}
               ,#gain{label = item, val = [535651,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(53041) ->
    {ok, #task_base{
            task_id = 53041
            ,name = ?L(<<"神源之地(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {13092, 1}, target_value = 1,map_id=13092}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 16000}
               ,#gain{label = item, val = [535651,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(53051) ->
    {ok, #task_base{
            task_id = 53051
            ,name = ?L(<<"盘根之谷(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {13122, 1}, target_value = 1,map_id=13122}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 16000}
               ,#gain{label = item, val = [535651,1,3]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(53111) ->
    {ok, #task_base{
            task_id = 53111
            ,name = ?L(<<"荧光洞穴(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {14012, 1}, target_value = 1,map_id=14012}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 35000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(53121) ->
    {ok, #task_base{
            task_id = 53121
            ,name = ?L(<<"沉寂湖畔(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {14032, 1}, target_value = 1,map_id=14032}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 35000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(53131) ->
    {ok, #task_base{
            task_id = 53131
            ,name = ?L(<<"树根囚笼(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {14062, 1}, target_value = 1,map_id=14062}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 35000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(53141) ->
    {ok, #task_base{
            task_id = 53141
            ,name = ?L(<<"幽暗地穴(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {14092, 1}, target_value = 1,map_id=14092}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 35000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(53151) ->
    {ok, #task_base{
            task_id = 53151
            ,name = ?L(<<"迷踪深渊(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {14122, 1}, target_value = 1,map_id=14122}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 35000}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(54011) ->
    {ok, #task_base{
            task_id = 54011
            ,name = ?L(<<"凛冽冰谷(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {15012, 1}, target_value = 1,map_id=15012}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 45000}
               ,#gain{label = item, val = [535630,1,2]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(54021) ->
    {ok, #task_base{
            task_id = 54021
            ,name = ?L(<<"冰棱之森(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {15042, 1}, target_value = 1,map_id=15042}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 45000}
               ,#gain{label = item, val = [535630,1,2]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(54031) ->
    {ok, #task_base{
            task_id = 54031
            ,name = ?L(<<"风暴要塞(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {15072, 1}, target_value = 1,map_id=15072}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 45000}
               ,#gain{label = item, val = [535630,1,2]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(54041) ->
    {ok, #task_base{
            task_id = 54041
            ,name = ?L(<<"荒芜雪野(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {15102, 1}, target_value = 1,map_id=15102}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 45000}
               ,#gain{label = item, val = [535630,1,2]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(54051) ->
    {ok, #task_base{
            task_id = 54051
            ,name = ?L(<<"狼嚎野岭(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {15132, 1}, target_value = 1,map_id=15132}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 45000}
               ,#gain{label = item, val = [535630,1,2]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(54111) ->
    {ok, #task_base{
            task_id = 54111
            ,name = ?L(<<"刀锋高地(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {16012, 1}, target_value = 1,map_id=16012}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 57000}
               ,#gain{label = item, val = [535630,1,2]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(54121) ->
    {ok, #task_base{
            task_id = 54121
            ,name = ?L(<<"巨槌峰峦(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {16042, 1}, target_value = 1,map_id=16042}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 57000}
               ,#gain{label = item, val = [535630,1,2]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(54131) ->
    {ok, #task_base{
            task_id = 54131
            ,name = ?L(<<"暮色雪岭(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {16072, 1}, target_value = 1,map_id=16072}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 57000}
               ,#gain{label = item, val = [535630,1,2]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(54141) ->
    {ok, #task_base{
            task_id = 54141
            ,name = ?L(<<"风雪之巅(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {16102, 1}, target_value = 1,map_id=16102}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 57000}
               ,#gain{label = item, val = [535630,1,2]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(54151) ->
    {ok, #task_base{
            task_id = 54151
            ,name = ?L(<<"巨人山城(困难)">>)
            ,lev = 1
            ,prev = []
            ,kind = 1
            ,type = 10            ,career = 9
            ,delegate = 0
            ,npc_accept = 0
            ,npc_commit = 0
            ,cond_accept = [
                            ]
            ,accept_rewards = [
                            ]
            ,cond_finish = [
                #task_cond{label = star_dungeon, target = {16132, 1}, target_value = 1,map_id=16132}
            ]
            ,finish_rewards = [
                #gain{label = coin, val = 900}
               ,#gain{label = exp, val = 57000}
               ,#gain{label = item, val = [535630,1,2]}
            ]
            ,times = 1
			,accept_open_map = []
			
        }
    };
    
get(_Id) ->
    {false, <<"不存在此任务">>}.


%% 日常任务ID转成配置的日常ID
convert_id(Id) ->
	Id div 100 * 100.

