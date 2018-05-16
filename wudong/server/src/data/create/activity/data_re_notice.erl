%% 配置生成时间 2018-04-23 20:11:24
-module(data_re_notice).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(2) ->
    #base_re_notice{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,16},{00,00,00}},end_time={{2017,12,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=2,
        notice_list=[
           
			#base_re_notice_info{id=1,
			title=?T("回归活动：震撼开启！"),
			content=?T("12月16日开始，凡连续3日及以上未登录游戏的角色，每日登录均可领取豪华礼包，同时享有超值充值特惠，并解锁专属兑换商店。海量福利助你快速提升战力！"),
			skip_id=0,
			page_id=0},
           
			#base_re_notice_info{id=2,
			title=?T("新增功能：装备套装"),
			content=?T("集齐一套橙色以上品质装备，可获得套装加成，人物整体属性飞快提升。仙境寻宝、神装副本每日通关，神装一套轻松集齐！"),
			skip_id=2,
			page_id=3},
           
			#base_re_notice_info{id=3,
			title=?T("新增功能：仙装觉醒"),
			content=?T("免费聚宝仙装，绑元洗练传奇属性，刷出橙装即可解锁专属技能，高性价比提升绝大战力！（80级开启，仙阶所需道具可从钻石商城获取）"),
			skip_id=105,
			page_id=1},
           
			#base_re_notice_info{id=4,
			title=?T("华丽无双：全新进阶坐骑"),
			content=?T("挟洞彻九界的炽焰霜雪之力，十一阶·九羿燃天凤，十二阶·天泽幻雪狐，震撼登场！唯有至尊强者能够驾驭的奇异珍兽，为获得它而努力进阶吧！"),
			skip_id=1,
			page_id=3}
        ],
        act_info=#act_info{}
    };

get(1) ->
    #base_re_notice{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,25},{00,00,00}},end_time={{2017,12,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        notice_list=[
           
			#base_re_notice_info{id=1,
			title=?T("回归活动"),
			content=?T("12月7日至12月13日活动开启期间，凡连续8日及以上未登录游戏的角色，每日登录均可领取豪华礼包，充值享有超值特惠，获得专属兑换商店的开启！"),
			skip_id=0,
			page_id=0},
           
			#base_re_notice_info{id=2,
			title=?T("装备套装"),
			content=?T("进阶装备品质，提升人物整体属性，免费宝石镶嵌位"),
			skip_id=2,
			page_id=3},
           
			#base_re_notice_info{id=3,
			title=?T("仙装觉醒"),
			content=?T("免费聚宝仙装，绑元即可洗练属性，高性价比提升绝大战力，解锁专属技能！"),
			skip_id=105,
			page_id=1},
           
			#base_re_notice_info{id=4,
			title=?T("宠物对战"),
			content=?T("宠物图鉴再升级，培养多种宠物，觉醒羁绊力量，专属关卡对战开放玩法新天地！"),
			skip_id=107,
			page_id=1},
           
			#base_re_notice_info{id=5,
			title=?T("宝宝系统"),
			content=?T("结婚免费解锁，灵弓灵骑强势助战，获取强大战力！"),
			skip_id=62,
			page_id=1}
        ],
        act_info=#act_info{}
    };

get(3) ->
    #base_re_notice{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,30},{00,00,00}},end_time={{2018,01,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=3,
        notice_list=[
           
			#base_re_notice_info{id=1,
			title=?T("回归活动：震撼开启！"),
			content=?T("12月30日开始，凡连续3日及以上未登录游戏的角色，每日登录均可领取豪华礼包，同时享有超值充值特惠，并解锁专属兑换商店。海量福利助你快速提升战力！"),
			skip_id=0,
			page_id=0},
           
			#base_re_notice_info{id=2,
			title=?T("新增功能：装备套装"),
			content=?T("集齐一套橙色以上品质装备，可获得套装加成，人物整体属性飞快提升。仙境寻宝、神装副本每日通关，神装一套轻松集齐！"),
			skip_id=2,
			page_id=3},
           
			#base_re_notice_info{id=3,
			title=?T("新增功能：仙装觉醒"),
			content=?T("免费聚宝仙装，绑元洗练传奇属性，刷出橙装即可解锁专属技能，高性价比提升绝大战力！（80级开启，仙阶所需道具可从钻石商城获取）"),
			skip_id=105,
			page_id=1},
           
			#base_re_notice_info{id=4,
			title=?T("华丽无双：全新进阶坐骑"),
			content=?T("挟洞彻九界的炽焰霜雪之力，十一阶·九羿燃天凤，十二阶·天泽幻雪狐，震撼登场！唯有至尊强者能够驾驭的奇异珍兽，为获得它而努力进阶吧！"),
			skip_id=1,
			page_id=3}
        ],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [2,1,3].
