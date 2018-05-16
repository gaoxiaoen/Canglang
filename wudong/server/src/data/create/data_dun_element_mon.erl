%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dun_element_mon
	%%% @Created : 2018-03-28 15:41:09
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dun_element_mon).
-export([get/2]).
-export([get_all/0]).
-export([get_max_round_by_dun_id/1]).
-include("dungeon.hrl").
get(61001, 1) -> [{57101,27,82},{57101,26,83},{57101,27,84},{57101,28,85},{57101,29,85},{57101,30,84},{57101,30,82},{57101,29,79}];
get(61001, 2) -> [{57101,14,52},{57101,15,52},{57101,16,52},{57101,16,51},{57101,13,50},{57101,11,49},{57101,14,48}];
get(61001, 3) -> [{57101,17,29},{57101,19,29},{57101,16,33},{57101,15,27},{57101,15,30},{57101,16,29},{57101,19,29}];
get(61002, 1) -> [{57102,27,82},{57102,26,83},{57102,27,84},{57102,28,85},{57102,29,85},{57102,30,84},{57102,30,82},{57102,29,79}];
get(61002, 2) -> [{57102,14,52},{57102,15,52},{57102,16,52},{57102,16,51},{57102,13,50},{57102,11,49},{57102,14,48}];
get(61002, 3) -> [{57102,17,29},{57102,19,29},{57102,16,33},{57102,15,27},{57102,15,30},{57102,16,29},{57102,19,29}];
get(61003, 1) -> [{57103,27,82},{57103,26,83},{57103,27,84},{57103,28,85},{57103,29,85},{57103,30,84},{57103,30,82},{57103,29,79}];
get(61003, 2) -> [{57103,14,52},{57103,15,52},{57103,16,52},{57103,16,51},{57103,13,50},{57103,11,49},{57103,14,48}];
get(61003, 3) -> [{57104,34,28}];
get(62001, 1) -> [{57201,10,22},{57201,9,21},{57201,12,24},{57201,10,20},{57201,12,21},{57201,8,24},{57201,8,21},{57201,12,18}];
get(62001, 2) -> [{57201,24,32},{57201,25,32},{57201,25,34},{57201,26,32},{57201,28,32},{57201,27,33},{57201,26,34},{57201,29,32}];
get(62001, 3) -> [{57201,40,45},{57201,41,46},{57201,42,41},{57201,39,45},{57201,39,47},{57201,40,49},{57201,42,46},{57201,39,41}];
get(62002, 1) -> [{57202,10,22},{57202,9,21},{57202,12,24},{57202,10,20},{57202,12,21},{57202,8,24},{57202,8,21},{57202,12,18}];
get(62002, 2) -> [{57202,24,32},{57202,25,32},{57202,25,34},{57202,26,32},{57202,28,32},{57202,27,33},{57202,26,34},{57202,29,32}];
get(62002, 3) -> [{57202,40,45},{57202,41,46},{57202,42,41},{57202,39,45},{57202,39,47},{57202,40,49},{57202,42,46},{57202,39,41}];
get(62003, 1) -> [{57203,10,22},{57203,9,21},{57203,12,24},{57203,10,20},{57203,12,21},{57203,8,24},{57203,8,21},{57203,12,18}];
get(62003, 2) -> [{57203,24,32},{57203,25,32},{57203,25,34},{57203,26,32},{57203,28,32},{57203,27,33},{57203,26,34},{57203,29,32}];
get(62003, 3) -> [{57204,40,45}];
get(63001, 1) -> [{57301,21,102},{57301,24,100},{57301,23,102},{57301,20,101},{57301,18,98},{57301,19,101},{57301,21,99},{57301,25,100}];
get(63001, 2) -> [{57301,30,73},{57301,32,72},{57301,32,74},{57301,26,32},{57301,28,73},{57301,31,73},{57301,28,70},{57301,31,69}];
get(63001, 3) -> [{57301,43,69},{57301,42,70},{57301,41,67},{57301,45,70},{57301,44,69},{57301,42,66},{57301,41,71},{57301,43,67},{57301,45,68}];
get(63002, 1) -> [{57302,28,108},{57302,29,110},{57302,27,109},{57302,28,110},{57302,29,112},{57302,30,105},{57302,26,110},{57302,30,107}];
get(63002, 2) -> [{57302,30,73},{57302,32,72},{57302,32,74},{57302,26,32},{57302,28,73},{57302,31,73},{57302,28,70},{57302,31,69}];
get(63002, 3) -> [{57302,43,69},{57302,42,70},{57302,41,67},{57302,45,70},{57302,44,69},{57302,42,66},{57302,41,71},{57302,43,67},{57302,45,68}];
get(63003, 1) -> [{57303,28,108},{57303,29,110},{57303,27,109},{57303,28,110},{57303,29,112},{57303,30,105},{57303,26,110},{57303,30,107}];
get(63003, 2) -> [{57303,30,73},{57303,32,72},{57303,32,74},{57303,26,32},{57303,28,73},{57303,31,73},{57303,28,70},{57303,31,69}];
get(63003, 3) -> [{57304,43,69}];
get(64001, 1) -> [{57401,27,118},{57401,25,117},{57401,27,116},{57401,28,115},{57401,29,118},{57401,30,117},{57401,30,116},{57401,29,115}];
get(64001, 2) -> [{57401,53,107},{57401,52,105},{57401,51,106},{57401,51,108},{57401,51,102},{57401,52,100},{57401,53,99},{57401,51,100},{57401,55,101}];
get(64001, 3) -> [{57401,63,58},{57401,64,60},{57401,63,54},{57401,61,59},{57401,65,60},{57401,61,54},{57401,60,53},{57401,59,59}];
get(64002, 1) -> [{57402,27,118},{57402,25,117},{57402,27,116},{57402,28,115},{57402,29,118},{57402,30,117},{57402,30,116},{57402,29,115}];
get(64002, 2) -> [{57402,53,107},{57402,52,105},{57402,51,106},{57402,51,108},{57402,51,102},{57402,52,100},{57402,53,99},{57402,51,100},{57402,55,101}];
get(64002, 3) -> [{57402,63,58},{57402,64,60},{57402,63,54},{57402,61,59},{57402,65,60},{57402,61,54},{57402,60,53},{57402,59,59}];
get(64003, 1) -> [{57403,27,118},{57403,25,117},{57403,27,116},{57403,28,115},{57403,29,118},{57403,30,117},{57403,30,116},{57403,29,115}];
get(64003, 2) -> [{57403,53,107},{57403,52,105},{57403,51,106},{57403,51,108},{57403,51,102},{57403,52,100},{57403,53,99},{57403,51,100},{57403,55,101}];
get(64003, 3) -> [{57404,63,58}];
get(65001, 1) -> [{57501,25,92},{57501,27,92},{57501,23,90},{57501,25,88},{57501,23,90},{57501,22,91},{57501,24,87},{57501,22,89}];
get(65001, 2) -> [{57501,40,67},{57501,42,69},{57501,38,65},{57501,34,64},{57501,44,67},{57501,41,69},{57501,31,67}];
get(65001, 3) -> [{57501,68,32},{57501,66,34},{57501,67,33},{57501,71,37},{57501,70,32},{57501,68,30},{57501,67,28},{57501,68,35}];
get(65002, 1) -> [{57502,25,92},{57502,27,92},{57502,23,90},{57502,25,88},{57502,23,90},{57502,22,91},{57502,24,87},{57502,22,89}];
get(65002, 2) -> [{57502,40,67},{57502,42,69},{57502,38,65},{57502,34,64},{57502,44,67},{57502,41,69},{57502,31,67}];
get(65002, 3) -> [{57502,68,32},{57502,66,34},{57502,67,33},{57502,71,37},{57502,70,32},{57502,68,30},{57502,67,28},{57502,68,35}];
get(65003, 1) -> [{57503,25,92},{57503,27,92},{57503,23,90},{57503,25,88},{57503,23,90},{57503,22,91},{57503,24,87},{57503,22,89}];
get(65003, 2) -> [{57503,40,67},{57503,42,69},{57503,38,65},{57503,34,64},{57503,44,67},{57503,41,69},{57503,31,67}];
get(65003, 3) -> [{57504,68,32}];
get(61601, 1) -> [{57601,12,65},{57601,13,63},{57601,10,64},{57601,13,67},{57601,11,58},{57601,14,62},{57601,16,64},{57601,10,67}];
get(61601, 2) -> [{57601,33,39},{57601,32,40},{57601,34,37},{57601,35,40},{57601,33,35},{57601,36,35},{57601,37,39},{57601,37,41},{57601,34,38}];
get(61601, 3) -> [{57601,42,34},{57601,44,35},{57601,41,35},{57601,46,38},{57601,42,38},{57601,40,35},{57601,41,39}];
get(61602, 1) -> [{57602,12,65},{57602,13,63},{57602,10,64},{57602,13,67},{57602,11,58},{57602,14,62},{57602,16,64},{57602,10,67}];
get(61602, 2) -> [{57602,33,39},{57602,32,40},{57602,34,37},{57602,35,40},{57602,33,35},{57602,36,35},{57602,37,39},{57602,37,41},{57602,34,38}];
get(61602, 3) -> [{57602,42,34},{57602,44,35},{57602,41,35},{57602,46,38},{57602,42,38},{57602,40,35},{57602,41,39}];
get(61603, 1) -> [{57603,12,65},{57603,13,63},{57603,10,64},{57603,13,67},{57603,11,58},{57603,14,62},{57603,16,64},{57603,10,67}];
get(61603, 2) -> [{57603,33,39},{57603,32,40},{57603,34,37},{57603,35,40},{57603,33,35},{57603,36,35},{57603,37,39},{57603,37,41},{57603,34,38}];
get(61603, 3) -> [{57604,42,34}];
get(_dun_id, _round) -> [].

get_all()->[61001,61001,61001,61002,61002,61002,61003,61003,61003,62001,62001,62001,62002,62002,62002,62003,62003,62003,63001,63001,63001,63002,63002,63002,63003,63003,63003,64001,64001,64001,64002,64002,64002,64003,64003,64003,65001,65001,65001,65002,65002,65002,65003,65003,65003,61601,61601,61601,61602,61602,61602,61603,61603,61603].

get_max_round_by_dun_id(61001) -> 3; 
get_max_round_by_dun_id(61002) -> 3; 
get_max_round_by_dun_id(61003) -> 3; 
get_max_round_by_dun_id(62001) -> 3; 
get_max_round_by_dun_id(62002) -> 3; 
get_max_round_by_dun_id(62003) -> 3; 
get_max_round_by_dun_id(63001) -> 3; 
get_max_round_by_dun_id(63002) -> 3; 
get_max_round_by_dun_id(63003) -> 3; 
get_max_round_by_dun_id(64001) -> 3; 
get_max_round_by_dun_id(64002) -> 3; 
get_max_round_by_dun_id(64003) -> 3; 
get_max_round_by_dun_id(65001) -> 3; 
get_max_round_by_dun_id(65002) -> 3; 
get_max_round_by_dun_id(65003) -> 3; 
get_max_round_by_dun_id(61601) -> 3; 
get_max_round_by_dun_id(61602) -> 3; 
get_max_round_by_dun_id(61603) -> 3. 
