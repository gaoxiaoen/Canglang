%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_elite
	%%% @Created : 2017-09-27 21:23:29
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_elite).
-export([get/1]).
-include("common.hrl").
-include("cross_elite.hrl").
%%青铜5
get(1) -> 
   #base_cross_elite{lv = 1 ,score = 50 ,score_lim = 0 ,daily_reward = {{1024000,100}} ,win_score = 10 ,fail_score = 5 }; 
%%青铜4
get(2) -> 
   #base_cross_elite{lv = 2 ,score = 60 ,score_lim = 50 ,daily_reward = {{1024000,130}} ,win_score = 12 ,fail_score = 5 }; 
%%青铜3
get(3) -> 
   #base_cross_elite{lv = 3 ,score = 70 ,score_lim = 110 ,daily_reward = {{1024000,160}} ,win_score = 14 ,fail_score = 5 }; 
%%青铜2
get(4) -> 
   #base_cross_elite{lv = 4 ,score = 80 ,score_lim = 180 ,daily_reward = {{1024000,190}} ,win_score = 16 ,fail_score = 5 }; 
%%青铜1
get(5) -> 
   #base_cross_elite{lv = 5 ,score = 90 ,score_lim = 260 ,daily_reward = {{1024000,220}} ,win_score = 18 ,fail_score = 5 }; 
%%白银5
get(6) -> 
   #base_cross_elite{lv = 6 ,score = 160 ,score_lim = 350 ,daily_reward = {{1024000,250}} ,win_score = 20 ,fail_score = 10 }; 
%%白银4
get(7) -> 
   #base_cross_elite{lv = 7 ,score = 176 ,score_lim = 510 ,daily_reward = {{1024000,280}} ,win_score = 22 ,fail_score = 10 }; 
%%白银3
get(8) -> 
   #base_cross_elite{lv = 8 ,score = 240 ,score_lim = 686 ,daily_reward = {{1024000,310}} ,win_score = 24 ,fail_score = 10 }; 
%%白银2
get(9) -> 
   #base_cross_elite{lv = 9 ,score = 390 ,score_lim = 926 ,daily_reward = {{1024000,340}} ,win_score = 26 ,fail_score = 10 }; 
%%白银1
get(10) -> 
   #base_cross_elite{lv = 10 ,score = 560 ,score_lim = 1316 ,daily_reward = {{1024000,370}} ,win_score = 28 ,fail_score = 10 }; 
%%黄金5
get(11) -> 
   #base_cross_elite{lv = 11 ,score = 900 ,score_lim = 1876 ,daily_reward = {{1024000,400}} ,win_score = 30 ,fail_score = 0 }; 
%%黄金4
get(12) -> 
   #base_cross_elite{lv = 12 ,score = 1280 ,score_lim = 2776 ,daily_reward = {{1024000,430}} ,win_score = 32 ,fail_score = 0 }; 
%%黄金3
get(13) -> 
   #base_cross_elite{lv = 13 ,score = 1700 ,score_lim = 4056 ,daily_reward = {{1024000,460}} ,win_score = 34 ,fail_score = 0 }; 
%%黄金2
get(14) -> 
   #base_cross_elite{lv = 14 ,score = 2160 ,score_lim = 5756 ,daily_reward = {{1024000,490}} ,win_score = 36 ,fail_score = 0 }; 
%%黄金1
get(15) -> 
   #base_cross_elite{lv = 15 ,score = 3040 ,score_lim = 7916 ,daily_reward = {{1024000,520}} ,win_score = 38 ,fail_score = 0 }; 
%%白金5
get(16) -> 
   #base_cross_elite{lv = 16 ,score = 3600 ,score_lim = 10956 ,daily_reward = {{1024000,550}} ,win_score = 40 ,fail_score = -20 }; 
%%白金4
get(17) -> 
   #base_cross_elite{lv = 17 ,score = 4620 ,score_lim = 14556 ,daily_reward = {{1024000,580}} ,win_score = 42 ,fail_score = -21 }; 
%%白金3
get(18) -> 
   #base_cross_elite{lv = 18 ,score = 5720 ,score_lim = 19176 ,daily_reward = {{1024000,610}} ,win_score = 44 ,fail_score = -22 }; 
%%白金2
get(19) -> 
   #base_cross_elite{lv = 19 ,score = 6900 ,score_lim = 24896 ,daily_reward = {{1024000,640}} ,win_score = 46 ,fail_score = -23 }; 
%%白金1
get(20) -> 
   #base_cross_elite{lv = 20 ,score = 8640 ,score_lim = 31796 ,daily_reward = {{1024000,670}} ,win_score = 48 ,fail_score = -24 }; 
%%钻石5
get(21) -> 
   #base_cross_elite{lv = 21 ,score = 10500 ,score_lim = 40436 ,daily_reward = {{1024000,700}} ,win_score = 50 ,fail_score = -50 }; 
%%钻石4
get(22) -> 
   #base_cross_elite{lv = 22 ,score = 13000 ,score_lim = 50936 ,daily_reward = {{1024000,730}} ,win_score = 52 ,fail_score = -52 }; 
%%钻石3
get(23) -> 
   #base_cross_elite{lv = 23 ,score = 15120 ,score_lim = 63936 ,daily_reward = {{1024000,760}} ,win_score = 54 ,fail_score = -54 }; 
%%钻石2
get(24) -> 
   #base_cross_elite{lv = 24 ,score = 16800 ,score_lim = 79056 ,daily_reward = {{1024000,790}} ,win_score = 56 ,fail_score = -56 }; 
%%钻石1
get(25) -> 
   #base_cross_elite{lv = 25 ,score = 30000 ,score_lim = 95856 ,daily_reward = {{1024000,820}} ,win_score = 58 ,fail_score = -58 }; 
%%最强王者
get(26) -> 
   #base_cross_elite{lv = 26 ,score = 0 ,score_lim = 125856 ,daily_reward = {{1024000,1000}} ,win_score = 60 ,fail_score = -60 }; 
get(_) -> []. 
