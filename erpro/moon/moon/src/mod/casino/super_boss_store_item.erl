%%----------------------------------------------------
%% 地下集市基础数据
%% @author bwang
%%----------------------------------------------------
-module(super_boss_store_item).
-export([get_all_item/1]).

-include("casino.hrl").
% %% 地下集市物品数据结构 by bwang
% -record(casino_base_item, {
%         item_id = 0                    %% 物品id
%         ,weight = 0                    %% 权重
%         ,weight_temp = 0               %% 存放暂时的权重
%         ,times_max = 0                 %% 保底次数，表示连续N次内必须出现 
%         ,times_max_undisplay = 0       %% 表示连续N次未出现 
%         ,times_limit_display = 0       %% 限制次数内已经出现的次数 
%         ,times_limit = 0               %% 限制次数 
%         ,times_terminate = 0           %% 禁用次数
%         ,count = 0                     %% 计算刷新的次数，概率被清零时开始计算，概率恢复则清零计数器 
%         ,is_notice = 0                 %% 1公告，0不公告（系统消息）
%     }).
get_all_item(1) ->
	[	
		#casino_base_item{
		item_id =221102, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =221103, 
		weight = 700,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =601001, 
		weight = 150,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111001, 
		weight = 800,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =621100, 
		weight = 800,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111301, 
		weight = 800,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =641201, 
		weight = 800,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =231001, 
		weight = 800,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =621501, 
		weight = 300,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =621502, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =111101, 
		weight = 250,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111102, 
		weight = 100,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =131001, 
		weight = 700,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =221105, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111203, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111213, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =111223, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111233, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111243, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111253, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111263, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111273, 
		weight = 50,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =111701, 
		weight = 150,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =535633, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =535651, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =535655, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		}
];

get_all_item(2) ->
	[	
		#casino_base_item{
		item_id =221102, 
		weight = 500,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =221103, 
		weight = 800,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111001, 
		weight = 900,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =621100, 
		weight = 900,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111301, 
		weight = 700,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =641201, 
		weight = 700,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =231001, 
		weight = 900,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =621502, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =621503, 
		weight = 140,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =111102, 
		weight = 300,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111103, 
		weight = 150,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =131001, 
		weight = 700,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =221105, 
		weight = 550,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111204, 
		weight = 180,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111214, 
		weight = 180,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =111224, 
		weight = 180,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111234, 
		weight = 180,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111244, 
		weight = 180,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111254, 
		weight = 180,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111264, 
		weight = 180,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 2
		},
	#casino_base_item{
		item_id =111274, 
		weight = 50,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =111702, 
		weight = 150,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =535636, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =535645, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		},
	#casino_base_item{
		item_id =231002, 
		weight = 100,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		is_notice = 1
		}
].

