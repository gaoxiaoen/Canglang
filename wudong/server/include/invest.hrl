-ifndef(INVEST_HRL).
-define(INVEST_HRL, 1).

-record(st_invest, {
	is_buy_luxury = 0,
	is_buy_extreme = 0,
	luxury_award = [],
	extreme_award = [],
	invest_award = []
}).

-record(base_invest, {
	id = 0,
	type = 0,
	goods_list = [],
	need_num = [],
	need_vip = 0
}).

-record(base_act_invest, {
	id = 0,
	gift_id = 0
}).

-record(st_act_invest, {
	pkey = 0,
	act_num = 1, %%投资轮数
	invest_gold = 0, %% 投资钻石数
	recv_list = [], %% 已领取奖励表
	op_time = 0, %% 上次领取时间
	recv_time = 0 %% 上次领取时间
}).
-define(ACT_INVEST_COST_GOLD, 888).
-define(ACT_INVEST_COST_GOLD2, 1988).
-define(ACT_INVEST_DAY, 7). %% 1轮7天

-endif.