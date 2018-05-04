

-define(MONTH_CARD_GOLD, 300).  %% 冲值月卡精钻数
-define(MONTH_DAY, 30).		    %% 月卡失效天数
-define(MONTH_DAY_GOLD, 120).   %% 每天精钻数
-define(MONTH_DAY_1_GOLD, 300). %% 第一天精钻数

-record(month_card, {
	charge_time	 = 0	    %% 充值时间unix_time		charge_time = 0时，没有充值
    ,charge_0_time = 0      %% 充值当天零晨时间戳
	,last_gold_day = 0	    %% 上次领取的天数  1~30
}).
