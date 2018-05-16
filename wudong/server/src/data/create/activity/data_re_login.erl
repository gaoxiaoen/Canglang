%% 配置生成时间 2018-04-23 20:11:24
-module(data_re_login).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(2) ->
    #base_re_login{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,16},{00,00,00}},end_time={{2017,12,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=2,
        reward=[          
			{ 1,[{8002516,50},{2003000,50},{2005000,100},{10101,200000}]},          
			{ 2,[{8001058,5},{10106,200},{8002405,5},{7206002,20}]},          
			{ 3,[{6608020,10},{8001054,50},{8001085,50},{1010005,50}]},          
			{ 4,[{11601,2},{2014001,10},{1015001,20},{8001057,50},{1045008,10}]},          
			{ 5,[{21091,1},{8002405,6},{8001069,10},{2003000,100},{1045008,10}]},          
			{ 6,[{8301104,1},{8001054,60},{8002406,3},{2003000,125},{1045008,10}]},          
			{ 7,[{6602008,10},{8001054,80},{8002407,2},{2003000,150},{1045008,10}]}
        ],
        act_info=#act_info{}
    };

get(1) ->
    #base_re_login{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,25},{00,00,00}},end_time={{2017,12,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        reward=[          
			{ 1,[{8002516,50},{2003000,50},{2005000,100},{10101,200000}]},          
			{ 2,[{8001058,5},{10106,200},{8002405,5},{7206002,20}]},          
			{ 3,[{6603102,1},{8001054,50},{8001085,50},{1010005,50}]},          
			{ 4,[{11601,2},{2014001,10},{1015001,20},{8001057,50},{1045008,10}]},          
			{ 5,[{21091,1},{8002405,6},{8001069,10},{2003000,100},{1045008,10}]},          
			{ 6,[{8301104,1},{8001054,60},{8002406,3},{2003000,125},{1045008,10}]},          
			{ 7,[{6602008,10},{8001054,80},{8002407,2},{2003000,150},{1045008,10}]}
        ],
        act_info=#act_info{}
    };

get(3) ->
    #base_re_login{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,30},{00,00,00}},end_time={{2018,01,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=3,
        reward=[          
			{ 1,[{8002516,50},{2003000,50},{2005000,100},{10101,200000}]},          
			{ 2,[{8001058,5},{10106,200},{8002405,5},{7206002,20}]},          
			{ 3,[{6603102,1},{8001054,50},{8001085,50},{1010005,50}]},          
			{ 4,[{11601,2},{2014001,10},{1015001,20},{8001057,50},{1045008,10}]},          
			{ 5,[{21091,1},{8002405,6},{8001069,10},{2003000,100},{1045008,10}]},          
			{ 6,[{8301104,1},{8001054,60},{8002406,3},{2003000,125},{1045008,10}]},          
			{ 7,[{6602008,10},{8001054,80},{8002407,2},{2003000,150},{1045008,10}]}
        ],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [2,1,3].
