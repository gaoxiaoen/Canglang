%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_dark_scene_lv
	%%% @Created : 2017-11-23 18:26:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_dark_scene_lv).
-export([ids/0]).
-export([get/1]).
-export([get_task/1]).
-include("common.hrl").
-include("cross_dark_bribe.hrl").
ids() -> [22001,22002,22003,22004,22005].
get(22001)->#config_darak_bribe_scene_lv{scene_id = 22001,min_rate = 0,max_rate = 80,lv_min = 75,t_ids = [11,14],xy = [{5,99},{16,78},{18,98}]};
get(22002)->#config_darak_bribe_scene_lv{scene_id = 22002,min_rate = 80,max_rate = 85,lv_min = 80,t_ids = [21,24],xy = [{5,99},{16,78},{18,98}]};
get(22003)->#config_darak_bribe_scene_lv{scene_id = 22003,min_rate = 85,max_rate = 90,lv_min = 85,t_ids = [31,34],xy = [{5,99},{16,78},{18,98}]};
get(22004)->#config_darak_bribe_scene_lv{scene_id = 22004,min_rate = 90,max_rate = 95,lv_min = 90,t_ids = [41,44],xy = [{5,99},{16,78},{18,98}]};
get(22005)->#config_darak_bribe_scene_lv{scene_id = 22005,min_rate = 95,max_rate = 100,lv_min = 95,t_ids = [51,54],xy = [{5,99},{16,78},{18,98}]};
get(_) -> [].
get_task(22001)->1000001;
get_task(22002)->1000002;
get_task(22003)->1000003;
get_task(22004)->1000004;
get_task(22005)->1000005;
get_task(_) -> [].
