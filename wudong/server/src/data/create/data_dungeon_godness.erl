%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_godness
	%%% @Created : 2018-04-16 11:17:52
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_godness).
-export([get/1]).
-export([get_all/0]).
-export([get_max_layer/0]).
-include("dungeon.hrl").
get(16001) -> #base_dun_godness{id=1, layer=1, name = "1号御魂副本", type=1, subtype=1, limit_lv=90, dun_id=16001, first_reward=[{7501100,1},{7500001,10}], daily_reward=[{7500001,5}], cbp=600000};
get(16002) -> #base_dun_godness{id=2, layer=1, name = "2号御魂副本", type=1, subtype=1, limit_lv=90, dun_id=16002, first_reward=[{7501100,1},{7500001,2},{7500002,1}], daily_reward=[{7500001,6}], cbp=600000};
get(16003) -> #base_dun_godness{id=3, layer=1, name = "3号御魂副本", type=1, subtype=1, limit_lv=90, dun_id=16003, first_reward=[{7501100,1},{7500001,8},{7500002,1}], daily_reward=[{7500001,9}], cbp=600000};
get(16004) -> #base_dun_godness{id=4, layer=1, name = "4号御魂副本", type=1, subtype=1, limit_lv=90, dun_id=16004, first_reward=[{7501100,1},{7500002,2}], daily_reward=[{7500001,10}], cbp=600000};
get(16005) -> #base_dun_godness{id=5, layer=1, name = "5号御魂副本", type=1, subtype=1, limit_lv=90, dun_id=16005, first_reward=[{7501100,1},{7500001,2},{7500002,2}], daily_reward=[{7500001,1},{7500002,1}], cbp=600000};
get(16006) -> #base_dun_godness{id=6, layer=1, name = "6号御魂副本", type=1, subtype=1, limit_lv=90, dun_id=16006, first_reward=[{7501100,1},{7500001,4},{7500002,2}], daily_reward=[{7500001,2},{7500002,1}], cbp=600000};
get(16007) -> #base_dun_godness{id=7, layer=1, name = "降神台1层", type=1, subtype=2, limit_lv=90, dun_id=16007, first_reward=[{7501100,4},{10106,100},{7500001,8},{7500002,2}], daily_reward=[{10106,50},{7500001,4},{7500002,1}], cbp=600000};
get(16008) -> #base_dun_godness{id=8, layer=1, name = "1号御魂副本", type=2, subtype=1, limit_lv=90, dun_id=16008, first_reward=[{7501100,1},{10106,100},{7500001,10}], daily_reward=[{7500001,10}], cbp=1000000};
get(16009) -> #base_dun_godness{id=9, layer=1, name = "2号御魂副本", type=2, subtype=1, limit_lv=90, dun_id=16009, first_reward=[{7501100,1},{7500001,2},{7500002,1}], daily_reward=[{7500001,2},{7500002,1}], cbp=1000000};
get(16010) -> #base_dun_godness{id=10, layer=1, name = "3号御魂副本", type=2, subtype=1, limit_lv=90, dun_id=16010, first_reward=[{7501100,1},{7500001,8},{7500002,1}], daily_reward=[{7500001,8},{7500002,1}], cbp=1000000};
get(16011) -> #base_dun_godness{id=11, layer=1, name = "4号御魂副本", type=2, subtype=1, limit_lv=90, dun_id=16011, first_reward=[{7501100,1},{10106,200},{7500002,2}], daily_reward=[{7500002,2}], cbp=1000000};
get(16012) -> #base_dun_godness{id=12, layer=1, name = "5号御魂副本", type=2, subtype=1, limit_lv=90, dun_id=16012, first_reward=[{7501100,1},{7500001,2},{7500002,2}], daily_reward=[{7500001,2},{7500002,2}], cbp=1000000};
get(16013) -> #base_dun_godness{id=13, layer=1, name = "6号御魂副本", type=2, subtype=1, limit_lv=90, dun_id=16013, first_reward=[{7501100,1},{7500001,4},{7500002,2}], daily_reward=[{7500001,4},{7500002,2}], cbp=1000000};
get(16014) -> #base_dun_godness{id=14, layer=1, name = "极·降神台1层", type=2, subtype=2, limit_lv=90, dun_id=16014, first_reward=[{7501100,4},{10106,100},{7500001,8},{7500002,2}], daily_reward=[{10106,100},{7500001,8},{7500002,2}], cbp=1000000};
get(16015) -> #base_dun_godness{id=15, layer=2, name = "1号御魂副本", type=1, subtype=1, limit_lv=151, dun_id=16015, first_reward=[{7500002,2}], daily_reward=[{7500001,10}], cbp=2000000};
get(16016) -> #base_dun_godness{id=16, layer=2, name = "2号御魂副本", type=1, subtype=1, limit_lv=151, dun_id=16016, first_reward=[{7500001,4},{7500002,2}], daily_reward=[{7500001,2},{7500002,1}], cbp=2000000};
get(16017) -> #base_dun_godness{id=17, layer=2, name = "3号御魂副本", type=1, subtype=1, limit_lv=151, dun_id=16017, first_reward=[{7500001,6},{7500002,3}], daily_reward=[{7500001,8},{7500002,1}], cbp=2000000};
get(16018) -> #base_dun_godness{id=18, layer=2, name = "4号御魂副本", type=1, subtype=1, limit_lv=151, dun_id=16018, first_reward=[{7500002,4}], daily_reward=[{7500002,2}], cbp=2000000};
get(16019) -> #base_dun_godness{id=19, layer=2, name = "5号御魂副本", type=1, subtype=1, limit_lv=151, dun_id=16019, first_reward=[{7500001,4},{7500002,4}], daily_reward=[{7500001,2},{7500002,2}], cbp=2000000};
get(16020) -> #base_dun_godness{id=20, layer=2, name = "6号御魂副本", type=1, subtype=1, limit_lv=151, dun_id=16020, first_reward=[{7500001,8},{7500002,4}], daily_reward=[{7500001,4},{7500002,2}], cbp=2000000};
get(16021) -> #base_dun_godness{id=21, layer=2, name = "降神台2层", type=1, subtype=2, limit_lv=151, dun_id=16021, first_reward=[{10106,100},{7500001,6},{7500002,5}], daily_reward=[{10106,100},{7500001,8},{7500002,2}], cbp=2000000};
get(16022) -> #base_dun_godness{id=22, layer=2, name = "1号御魂副本", type=2, subtype=1, limit_lv=171, dun_id=16022, first_reward=[{10106,100},{7500002,2}], daily_reward=[{7500002,2}], cbp=2400000};
get(16023) -> #base_dun_godness{id=23, layer=2, name = "2号御魂副本", type=2, subtype=1, limit_lv=171, dun_id=16023, first_reward=[{7500001,4},{7500002,2}], daily_reward=[{7500001,4},{7500002,2}], cbp=2400000};
get(16024) -> #base_dun_godness{id=24, layer=2, name = "3号御魂副本", type=2, subtype=1, limit_lv=171, dun_id=16024, first_reward=[{7500001,6},{7500002,3}], daily_reward=[{7500001,6},{7500002,3}], cbp=2400000};
get(16025) -> #base_dun_godness{id=25, layer=2, name = "4号御魂副本", type=2, subtype=1, limit_lv=171, dun_id=16025, first_reward=[{10106,200},{7500002,4}], daily_reward=[{7500002,4}], cbp=2400000};
get(16026) -> #base_dun_godness{id=26, layer=2, name = "5号御魂副本", type=2, subtype=1, limit_lv=171, dun_id=16026, first_reward=[{7500001,4},{7500002,4}], daily_reward=[{7500001,4},{7500002,4}], cbp=2400000};
get(16027) -> #base_dun_godness{id=27, layer=2, name = "6号御魂副本", type=2, subtype=1, limit_lv=171, dun_id=16027, first_reward=[{7500001,8},{7500002,4}], daily_reward=[{7500001,8},{7500002,4}], cbp=2400000};
get(16028) -> #base_dun_godness{id=28, layer=2, name = "极·降神台2层", type=2, subtype=2, limit_lv=171, dun_id=16028, first_reward=[{10106,100},{7500001,6},{7500002,5}], daily_reward=[{10106,100},{7500001,6},{7500002,5}], cbp=2400000};
get(16029) -> #base_dun_godness{id=29, layer=3, name = "1号御魂副本", type=1, subtype=1, limit_lv=190, dun_id=16029, first_reward=[{7500002,4}], daily_reward=[{7500001,20}], cbp=8000000};
get(16030) -> #base_dun_godness{id=30, layer=3, name = "2号御魂副本", type=1, subtype=1, limit_lv=190, dun_id=16030, first_reward=[{7500001,8},{7500002,4}], daily_reward=[{7500001,4},{7500002,2}], cbp=8000000};
get(16031) -> #base_dun_godness{id=31, layer=3, name = "3号御魂副本", type=1, subtype=1, limit_lv=190, dun_id=16031, first_reward=[{7500001,12},{7500002,6}], daily_reward=[{7500001,16},{7500002,2}], cbp=8000000};
get(16032) -> #base_dun_godness{id=32, layer=3, name = "4号御魂副本", type=1, subtype=1, limit_lv=190, dun_id=16032, first_reward=[{7500002,8}], daily_reward=[{7500002,4}], cbp=8000000};
get(16033) -> #base_dun_godness{id=33, layer=3, name = "5号御魂副本", type=1, subtype=1, limit_lv=190, dun_id=16033, first_reward=[{7500001,8},{7500002,8}], daily_reward=[{7500001,4},{7500002,4}], cbp=8000000};
get(16034) -> #base_dun_godness{id=34, layer=3, name = "6号御魂副本", type=1, subtype=1, limit_lv=190, dun_id=16034, first_reward=[{7500001,16},{7500002,8}], daily_reward=[{7500001,8},{7500002,4}], cbp=8000000};
get(16035) -> #base_dun_godness{id=35, layer=3, name = "降神台3层", type=1, subtype=2, limit_lv=190, dun_id=16035, first_reward=[{10106,100},{7500001,12},{7500002,10}], daily_reward=[{10106,100},{7500001,16},{7500002,4}], cbp=8000000};
get(16036) -> #base_dun_godness{id=36, layer=3, name = "1号御魂副本", type=2, subtype=1, limit_lv=190, dun_id=16036, first_reward=[{10106,100},{7500002,4}], daily_reward=[{7500002,4}], cbp=8800000};
get(16037) -> #base_dun_godness{id=37, layer=3, name = "2号御魂副本", type=2, subtype=1, limit_lv=190, dun_id=16037, first_reward=[{7500001,8},{7500002,4}], daily_reward=[{7500001,8},{7500002,4}], cbp=8800000};
get(16038) -> #base_dun_godness{id=38, layer=3, name = "3号御魂副本", type=2, subtype=1, limit_lv=190, dun_id=16038, first_reward=[{7500001,12},{7500002,6}], daily_reward=[{7500001,16},{7500002,6}], cbp=8800000};
get(16039) -> #base_dun_godness{id=39, layer=3, name = "4号御魂副本", type=2, subtype=1, limit_lv=190, dun_id=16039, first_reward=[{10106,200},{7500002,8}], daily_reward=[{7500002,8}], cbp=8800000};
get(16040) -> #base_dun_godness{id=40, layer=3, name = "5号御魂副本", type=2, subtype=1, limit_lv=190, dun_id=16040, first_reward=[{7500001,8},{7500002,8}], daily_reward=[{7500001,8},{7500002,8}], cbp=8800000};
get(16041) -> #base_dun_godness{id=41, layer=3, name = "6号御魂副本", type=2, subtype=1, limit_lv=190, dun_id=16041, first_reward=[{7500001,16},{7500002,8}], daily_reward=[{7500001,16},{7500002,8}], cbp=8800000};
get(16042) -> #base_dun_godness{id=42, layer=3, name = "极·降神台3层", type=2, subtype=2, limit_lv=190, dun_id=16042, first_reward=[{10106,100},{7500001,12},{7500002,10}], daily_reward=[{10106,100},{7500001,12},{7500002,10}], cbp=8800000};
get(_id) -> [].

get_all()->[16001,16002,16003,16004,16005,16006,16007,16008,16009,16010,16011,16012,16013,16014,16015,16016,16017,16018,16019,16020,16021,16022,16023,16024,16025,16026,16027,16028,16029,16030,16031,16032,16033,16034,16035,16036,16037,16038,16039,16040,16041,16042].

get_max_layer() -> 3.

