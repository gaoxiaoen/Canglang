
-module(guild_target_data).
-export([get_target_num/1
		,get_target_q/1
		,q2id/1
		,get/1
		,all_type/0
		,q2rate/1
		,type2id/1
		,finish_val/1
		]).

get_target_num(1) -> 4;
get_target_num(2) -> 4;
get_target_num(3) -> 4;
get_target_num(4) -> 5;
get_target_num(5) -> 5;
get_target_num(6) -> 5;
get_target_num(7) -> 6;
get_target_num(8) -> 6;
get_target_num(9) -> 6;
get_target_num(10) -> 7;
get_target_num(11) -> 7;
get_target_num(12) -> 7;
get_target_num(13) -> 8;
get_target_num(14) -> 8;
get_target_num(15) -> 8;
get_target_num(16) -> 9;
get_target_num(17) -> 9;
get_target_num(18) -> 9;
get_target_num(19) -> 10;
get_target_num(20) -> 10;
get_target_num(_Lvl) -> false.

get_target_q(1) ->[1];
get_target_q(2) ->[2,1];
get_target_q(3) ->[2,1];
get_target_q(4) ->[3,2,1];
get_target_q(5) ->[3,2,1];
get_target_q(6) ->[4,3,2,1];
get_target_q(7) ->[4,3,2,1];
get_target_q(8) ->[5,4,3,2,1];
get_target_q(9) ->[5,4,3,2,1];
get_target_q(10) ->[6,5,4,3,2,1];
get_target_q(11) ->[6,5,4,3,2,1];
get_target_q(12) ->[6,5,4,3,2,1];
get_target_q(13) ->[6,5,4,3,2,1];
get_target_q(14) ->[6,5,4,3,2,1];
get_target_q(15) ->[6,5,4,3,2,1];
get_target_q(16) ->[6,5,4,3,2,1];
get_target_q(17) ->[6,5,4,3,2,1];
get_target_q(18) ->[6,5,4,3,2,1];
get_target_q(19) ->[6,5,4,3,2,1];
get_target_q(20) ->[6,5,4,3,2,1];
get_target_q(_Lvl) -> false.

q2id(1) -> [10001,10007,10013,10019,10025,10031,10037,10043,10049,10055];
q2id(2) -> [10002,10008,10014,10020,10026,10032,10038,10044,10050,10056];
q2id(3) -> [10003,10009,10015,10021,10027,10033,10039,10045,10051,10057];
q2id(4) -> [10004,10010,10016,10022,10028,10034,10040,10046,10052,10058];
q2id(5) -> [10005,10011,10017,10023,10029,10035,10041,10047,10053,10059];
q2id(6) -> [10006,10012,10018,10024,10030,10036,10042,10048,10054,10060];
q2id(_Q) -> false.

get(10001) -> {1,guild_wish,{exp,200},8};
get(10002) -> {2,guild_wish,{exp,400},16};
get(10003) -> {3,guild_wish,{exp,600},24};
get(10004) -> {4,guild_wish,{exp,800},36};
get(10005) -> {5,guild_wish,{exp,1000},40};
get(10006) -> {6,guild_wish,{exp,1200},48};
get(10007) -> {1,guild_buy,{exp,200},8};
get(10008) -> {2,guild_buy,{exp,400},16};
get(10009) -> {3,guild_buy,{exp,600},24};
get(10010) -> {4,guild_buy,{exp,800},36};
get(10011) -> {5,guild_buy,{exp,1000},40};
get(10012) -> {6,guild_buy,{exp,1200},48};
get(10013) -> {1,guild_kill_pirate,{exp,200},16};
get(10014) -> {2,guild_kill_pirate,{exp,400},32};
get(10015) -> {3,guild_kill_pirate,{exp,600},48};
get(10016) -> {4,guild_kill_pirate,{exp,800},64};
get(10017) -> {5,guild_kill_pirate,{exp,1000},80};
get(10018) -> {6,guild_kill_pirate,{exp,1200},96};
get(10019) -> {1,guild_chleg,{exp,200},40};
get(10020) -> {2,guild_chleg,{exp,400},80};
get(10021) -> {3,guild_chleg,{exp,600},120};
get(10022) -> {4,guild_chleg,{exp,800},160};
get(10023) -> {5,guild_chleg,{exp,1000},200};
get(10024) -> {6,guild_chleg,{exp,1200},240};
get(10025) -> {1,guild_gc,{exp,200},8};
get(10026) -> {2,guild_gc,{exp,400},16};
get(10027) -> {3,guild_gc,{exp,600},24};
get(10028) -> {4,guild_gc,{exp,800},32};
get(10029) -> {5,guild_gc,{exp,1000},40};
get(10030) -> {6,guild_gc,{exp,1200},48};
get(10031) -> {1,guild_dungeon,{exp,200},100};
get(10032) -> {2,guild_dungeon,{exp,400},200};
get(10033) -> {3,guild_dungeon,{exp,600},300};
get(10034) -> {4,guild_dungeon,{exp,800},400};
get(10035) -> {5,guild_dungeon,{exp,1000},500};
get(10036) -> {6,guild_dungeon,{exp,1200},600};
get(10037) -> {1,guild_tree,{exp,200},80};
get(10038) -> {2,guild_tree,{exp,400},160};
get(10039) -> {3,guild_tree,{exp,600},240};
get(10040) -> {4,guild_tree,{exp,800},320};
get(10041) -> {5,guild_tree,{exp,1000},400};
get(10042) -> {6,guild_tree,{exp,1200},480};
get(10043) -> {1,guild_activity,{exp,200},4};
get(10044) -> {2,guild_activity,{exp,400},8};
get(10045) -> {3,guild_activity,{exp,600},12};
get(10046) -> {4,guild_activity,{exp,800},16};
get(10047) -> {5,guild_activity,{exp,1000},20};
get(10048) -> {6,guild_activity,{exp,1200},24};
get(10049) -> {1,guild_skill,{exp,200},8};
get(10050) -> {2,guild_skill,{exp,400},16};
get(10051) -> {3,guild_skill,{exp,600},24};
get(10052) -> {4,guild_skill,{exp,800},32};
get(10053) -> {5,guild_skill,{exp,1000},40};
get(10054) -> {6,guild_skill,{exp,1200},48};
get(10055) -> {1,guild_multi_dun,{exp,200},16};
get(10056) -> {2,guild_multi_dun,{exp,400},32};
get(10057) -> {3,guild_multi_dun,{exp,600},48};
get(10058) -> {4,guild_multi_dun,{exp,800},64};
get(10059) -> {5,guild_multi_dun,{exp,1000},80};
get(10060) -> {6,guild_multi_dun,{exp,1200},96};
get(_Id) -> false.

all_type() -> [1,2,3,4,5,6,7,8,9,10].

q2rate(1) -> 100;
q2rate(2) -> 150;
q2rate(3) -> 50;
q2rate(4) -> 50;
q2rate(5) -> 50;
q2rate(6) -> 50.
type2id(1) -> [{10001,1},{10002,2},{10003,3},{10004,4},{10005,5},{10006,6}];
type2id(2) -> [{10007,1},{10008,2},{10009,3},{10010,4},{10011,5},{10012,6}];
type2id(3) -> [{10013,1},{10014,2},{10015,3},{10016,4},{10017,5},{10018,6}];
type2id(4) -> [{10019,1},{10020,2},{10021,3},{10022,4},{10023,5},{10024,6}];
type2id(5) -> [{10025,1},{10026,2},{10027,3},{10028,4},{10029,5},{10030,6}];
type2id(6) -> [{10031,1},{10032,2},{10033,3},{10034,4},{10035,5},{10036,6}];
type2id(7) -> [{10037,1},{10038,2},{10039,3},{10040,4},{10041,5},{10042,6}];
type2id(8) -> [{10043,1},{10044,2},{10045,3},{10046,4},{10047,5},{10048,6}];
type2id(9) -> [{10049,1},{10050,2},{10051,3},{10052,4},{10053,5},{10054,6}];
type2id(10) -> [{10055,1},{10056,2},{10057,3},{10058,4},{10059,5},{10060,6}];
type2id(_Type) -> false.

finish_val(10001) -> 8;
finish_val(10002) -> 16;
finish_val(10003) -> 24;
finish_val(10004) -> 36;
finish_val(10005) -> 40;
finish_val(10006) -> 48;
finish_val(10007) -> 8;
finish_val(10008) -> 16;
finish_val(10009) -> 24;
finish_val(10010) -> 36;
finish_val(10011) -> 40;
finish_val(10012) -> 48;
finish_val(10013) -> 16;
finish_val(10014) -> 32;
finish_val(10015) -> 48;
finish_val(10016) -> 64;
finish_val(10017) -> 80;
finish_val(10018) -> 96;
finish_val(10019) -> 40;
finish_val(10020) -> 80;
finish_val(10021) -> 120;
finish_val(10022) -> 160;
finish_val(10023) -> 200;
finish_val(10024) -> 240;
finish_val(10025) -> 8;
finish_val(10026) -> 16;
finish_val(10027) -> 24;
finish_val(10028) -> 32;
finish_val(10029) -> 40;
finish_val(10030) -> 48;
finish_val(10031) -> 100;
finish_val(10032) -> 200;
finish_val(10033) -> 300;
finish_val(10034) -> 400;
finish_val(10035) -> 500;
finish_val(10036) -> 600;
finish_val(10037) -> 80;
finish_val(10038) -> 160;
finish_val(10039) -> 240;
finish_val(10040) -> 320;
finish_val(10041) -> 400;
finish_val(10042) -> 480;
finish_val(10043) -> 4;
finish_val(10044) -> 8;
finish_val(10045) -> 12;
finish_val(10046) -> 16;
finish_val(10047) -> 20;
finish_val(10048) -> 24;
finish_val(10049) -> 8;
finish_val(10050) -> 16;
finish_val(10051) -> 24;
finish_val(10052) -> 32;
finish_val(10053) -> 40;
finish_val(10054) -> 48;
finish_val(10055) -> 16;
finish_val(10056) -> 32;
finish_val(10057) -> 48;
finish_val(10058) -> 64;
finish_val(10059) -> 80;
finish_val(10060) -> 96;
finish_val(_Id) -> false.











