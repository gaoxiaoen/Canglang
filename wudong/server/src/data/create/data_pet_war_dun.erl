%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_war_dun
	%%% @Created : 2017-12-27 22:51:52
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_war_dun).
-export([get/1]).
-export([ids/0]).
-export([get_ids_by_chapter/1]).
-include("pet_war.hrl").

get(1) -> #base_pet_war_dun{id = 1 ,desc = "1",chapter = 1 ,mon_list = [11] ,map_id = 6 ,first_pass_reward = [{20340,5},{1010005,2}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(2) -> #base_pet_war_dun{id = 2 ,desc = "2",chapter = 1 ,mon_list = [21] ,map_id = 6 ,first_pass_reward = [{20340,5},{1010005,2}] ,daily_pass_reward = [{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(3) -> #base_pet_war_dun{id = 3 ,desc = "3",chapter = 1 ,mon_list = [31,32] ,map_id = 7 ,first_pass_reward = [{20340,5},{1010005,2}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(4) -> #base_pet_war_dun{id = 4 ,desc = "4",chapter = 1 ,is_boss = 1 ,mon_list = [41,42] ,map_id = 7 ,first_pass_reward = [{20340,15},{1010005,6}] ,daily_pass_reward = [{20340,1,100},{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(5) -> #base_pet_war_dun{id = 5 ,desc = "5",chapter = 1 ,mon_list = [51,52,53] ,map_id = 8 ,first_pass_reward = [{20340,5},{1010005,2}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(6) -> #base_pet_war_dun{id = 6 ,desc = "6",chapter = 1 ,mon_list = [61,62,63] ,map_id = 8 ,first_pass_reward = [{20340,5},{1010005,2}] ,daily_pass_reward = [{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(7) -> #base_pet_war_dun{id = 7 ,desc = "7",chapter = 1 ,mon_list = [71,72,73,74] ,map_id = 9 ,first_pass_reward = [{20340,5},{1010005,2}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(8) -> #base_pet_war_dun{id = 8 ,desc = "8",chapter = 1 ,is_boss = 1 ,mon_list = [81,82,83,84] ,map_id = 9 ,first_pass_reward = [{20340,15},{1010005,6}] ,daily_pass_reward = [{20340,1,100},{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(9) -> #base_pet_war_dun{id = 9 ,desc = "9",chapter = 1 ,mon_list = [91,92,93,94,95] ,map_id = 4 ,first_pass_reward = [{20340,5},{1010005,2}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(10) -> #base_pet_war_dun{id = 10 ,desc = "10",chapter = 1 ,mon_list = [101,102,103,104,105] ,map_id = 5 ,first_pass_reward = [{20340,5},{1010005,2}] ,daily_pass_reward = [{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(11) -> #base_pet_war_dun{id = 11 ,desc = "11",chapter = 1 ,mon_list = [111,112,113,114,115] ,map_id = 1 ,first_pass_reward = [{20340,5},{1010005,2}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(12) -> #base_pet_war_dun{id = 12 ,desc = "12",chapter = 1 ,mon_list = [121,122,123,124,125] ,map_id = 2 ,first_pass_reward = [{20340,5},{1010005,2}] ,daily_pass_reward = [{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(13) -> #base_pet_war_dun{id = 13 ,desc = "13",chapter = 1 ,is_boss = 1 ,mon_list = [131,132,133,134,135] ,map_id = 3 ,first_pass_reward = [{20340,20},{1010005,8}] ,daily_pass_reward = [{20340,2,100},{1010005,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(14) -> #base_pet_war_dun{id = 14 ,desc = "14",chapter = 2 ,mon_list = [141,142,143,144,145] ,map_id = 4 ,first_pass_reward = [{20340,7},{1010005,3}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(15) -> #base_pet_war_dun{id = 15 ,desc = "15",chapter = 2 ,mon_list = [151,152,153,154,155] ,map_id = 5 ,first_pass_reward = [{20340,7},{1010005,3}] ,daily_pass_reward = [{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(16) -> #base_pet_war_dun{id = 16 ,desc = "16",chapter = 2 ,mon_list = [161,162,163,164,165] ,map_id = 1 ,first_pass_reward = [{20340,7},{1010005,3}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(17) -> #base_pet_war_dun{id = 17 ,desc = "17",chapter = 2 ,is_boss = 1 ,mon_list = [171,172,173,174,175] ,map_id = 2 ,first_pass_reward = [{20340,20},{1010005,9}] ,daily_pass_reward = [{20340,1,100},{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(18) -> #base_pet_war_dun{id = 18 ,desc = "18",chapter = 2 ,mon_list = [181,182,183,184,185] ,map_id = 3 ,first_pass_reward = [{20340,7},{1010005,3}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(19) -> #base_pet_war_dun{id = 19 ,desc = "19",chapter = 2 ,mon_list = [191,192,193,194,195] ,map_id = 4 ,first_pass_reward = [{20340,7},{1010005,3}] ,daily_pass_reward = [{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(20) -> #base_pet_war_dun{id = 20 ,desc = "20",chapter = 2 ,mon_list = [201,202,203,204,205] ,map_id = 5 ,first_pass_reward = [{20340,7},{1010005,3}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(21) -> #base_pet_war_dun{id = 21 ,desc = "21",chapter = 2 ,is_boss = 1 ,mon_list = [211,212,213,214,215] ,map_id = 1 ,first_pass_reward = [{20340,20},{1010005,9}] ,daily_pass_reward = [{20340,1,100},{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(22) -> #base_pet_war_dun{id = 22 ,desc = "22",chapter = 2 ,mon_list = [221,222,223,224,225] ,map_id = 2 ,first_pass_reward = [{20340,7},{1010005,3}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(23) -> #base_pet_war_dun{id = 23 ,desc = "23",chapter = 2 ,mon_list = [231,232,233,234,235] ,map_id = 3 ,first_pass_reward = [{20340,7},{1010005,3}] ,daily_pass_reward = [{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(24) -> #base_pet_war_dun{id = 24 ,desc = "24",chapter = 2 ,mon_list = [241,242,243,244,245] ,map_id = 4 ,first_pass_reward = [{20340,7},{1010005,3}] ,daily_pass_reward = [{20340,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(25) -> #base_pet_war_dun{id = 25 ,desc = "25",chapter = 2 ,mon_list = [251,252,253,254,255] ,map_id = 5 ,first_pass_reward = [{20340,7},{1010005,3}] ,daily_pass_reward = [{1010005,1,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(26) -> #base_pet_war_dun{id = 26 ,desc = "26",chapter = 2 ,is_boss = 1 ,mon_list = [261,262,263,264,265] ,map_id = 1 ,first_pass_reward = [{20340,28},{1010005,10}] ,daily_pass_reward = [{20340,2,100},{1010005,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(27) -> #base_pet_war_dun{id = 27 ,desc = "27",chapter = 3 ,mon_list = [271,272,273,274,275] ,map_id = 2 ,first_pass_reward = [{20340,10},{1010005,5}] ,daily_pass_reward = [{20340,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(28) -> #base_pet_war_dun{id = 28 ,desc = "28",chapter = 3 ,mon_list = [281,282,283,284,285] ,map_id = 3 ,first_pass_reward = [{20340,10},{1010005,5}] ,daily_pass_reward = [{1010005,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(29) -> #base_pet_war_dun{id = 29 ,desc = "29",chapter = 3 ,mon_list = [291,292,293,294,295] ,map_id = 4 ,first_pass_reward = [{20340,10},{1010005,5}] ,daily_pass_reward = [{20340,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(30) -> #base_pet_war_dun{id = 30 ,desc = "30",chapter = 3 ,is_boss = 1 ,mon_list = [301,302,303,304,305] ,map_id = 5 ,first_pass_reward = [{20340,30},{1010005,15}] ,daily_pass_reward = [{20340,2,100},{1010005,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(31) -> #base_pet_war_dun{id = 31 ,desc = "31",chapter = 3 ,mon_list = [311,312,313,314,315] ,map_id = 1 ,first_pass_reward = [{20340,10},{1010005,5}] ,daily_pass_reward = [{20340,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(32) -> #base_pet_war_dun{id = 32 ,desc = "32",chapter = 3 ,mon_list = [321,322,323,324,325] ,map_id = 2 ,first_pass_reward = [{20340,10},{1010005,5}] ,daily_pass_reward = [{1010005,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(33) -> #base_pet_war_dun{id = 33 ,desc = "33",chapter = 3 ,mon_list = [331,332,333,334,335] ,map_id = 3 ,first_pass_reward = [{20340,10},{1010005,5}] ,daily_pass_reward = [{20340,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(34) -> #base_pet_war_dun{id = 34 ,desc = "34",chapter = 3 ,is_boss = 1 ,mon_list = [341,342,343,344,345] ,map_id = 4 ,first_pass_reward = [{20340,30},{1010005,15}] ,daily_pass_reward = [{20340,2,100},{1010005,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(35) -> #base_pet_war_dun{id = 35 ,desc = "35",chapter = 3 ,mon_list = [351,352,353,354,355] ,map_id = 5 ,first_pass_reward = [{20340,10},{1010005,5}] ,daily_pass_reward = [{20340,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(36) -> #base_pet_war_dun{id = 36 ,desc = "36",chapter = 3 ,mon_list = [361,362,363,364,365] ,map_id = 1 ,first_pass_reward = [{20340,10},{1010005,5}] ,daily_pass_reward = [{1010005,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(37) -> #base_pet_war_dun{id = 37 ,desc = "37",chapter = 3 ,mon_list = [371,372,373,374,375] ,map_id = 2 ,first_pass_reward = [{20340,10},{1010005,5}] ,daily_pass_reward = [{20340,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(38) -> #base_pet_war_dun{id = 38 ,desc = "38",chapter = 3 ,mon_list = [381,382,383,384,385] ,map_id = 3 ,first_pass_reward = [{20340,10},{1010005,5}] ,daily_pass_reward = [{1010005,2,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(39) -> #base_pet_war_dun{id = 39 ,desc = "39",chapter = 3 ,is_boss = 1 ,mon_list = [391,392,393,394,395] ,map_id = 4 ,first_pass_reward = [{21091,1},{20340,40},{1010005,20}] ,daily_pass_reward = [{20340,4,100},{1010005,4,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(40) -> #base_pet_war_dun{id = 40 ,desc = "40",chapter = 4 ,mon_list = [401,402,403,404,405] ,map_id = 5 ,first_pass_reward = [{20340,15},{1010005,7}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(41) -> #base_pet_war_dun{id = 41 ,desc = "41",chapter = 4 ,mon_list = [411,412,413,414,415] ,map_id = 1 ,first_pass_reward = [{20340,15},{1010005,7}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(42) -> #base_pet_war_dun{id = 42 ,desc = "42",chapter = 4 ,mon_list = [421,422,423,424,425] ,map_id = 2 ,first_pass_reward = [{20340,15},{1010005,7}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(43) -> #base_pet_war_dun{id = 43 ,desc = "43",chapter = 4 ,is_boss = 1 ,mon_list = [431,432,433,434,435] ,map_id = 3 ,first_pass_reward = [{20340,45},{1010005,20}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(44) -> #base_pet_war_dun{id = 44 ,desc = "44",chapter = 4 ,mon_list = [441,442,443,444,445] ,map_id = 4 ,first_pass_reward = [{20340,15},{1010005,7}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(45) -> #base_pet_war_dun{id = 45 ,desc = "45",chapter = 4 ,mon_list = [451,452,453,454,455] ,map_id = 5 ,first_pass_reward = [{20340,15},{1010005,7}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(46) -> #base_pet_war_dun{id = 46 ,desc = "46",chapter = 4 ,mon_list = [461,462,463,464,465] ,map_id = 1 ,first_pass_reward = [{20340,15},{1010005,7}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(47) -> #base_pet_war_dun{id = 47 ,desc = "47",chapter = 4 ,is_boss = 1 ,mon_list = [471,472,473,474,475] ,map_id = 2 ,first_pass_reward = [{20340,45},{1010005,20}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(48) -> #base_pet_war_dun{id = 48 ,desc = "48",chapter = 4 ,mon_list = [481,482,483,484,485] ,map_id = 3 ,first_pass_reward = [{20340,15},{1010005,7}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(49) -> #base_pet_war_dun{id = 49 ,desc = "49",chapter = 4 ,mon_list = [491,492,493,494,495] ,map_id = 4 ,first_pass_reward = [{20340,15},{1010005,7}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(50) -> #base_pet_war_dun{id = 50 ,desc = "50",chapter = 4 ,mon_list = [501,502,503,504,505] ,map_id = 5 ,first_pass_reward = [{20340,15},{1010005,7}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(51) -> #base_pet_war_dun{id = 51 ,desc = "51",chapter = 4 ,mon_list = [511,512,513,514,515] ,map_id = 1 ,first_pass_reward = [{20340,15},{1010005,7}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(52) -> #base_pet_war_dun{id = 52 ,desc = "52",chapter = 4 ,is_boss = 1 ,mon_list = [521,522,523,524,525] ,map_id = 2 ,first_pass_reward = [{21071,1},{20340,60},{1010005,28}] ,daily_pass_reward = [{20340,6,100},{1010005,6,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(53) -> #base_pet_war_dun{id = 53 ,desc = "53",chapter = 5 ,mon_list = [531,532,533,534,535] ,map_id = 3 ,first_pass_reward = [{20340,20},{1010005,10}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(54) -> #base_pet_war_dun{id = 54 ,desc = "54",chapter = 5 ,mon_list = [541,542,543,544,545] ,map_id = 4 ,first_pass_reward = [{20340,20},{1010005,10}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(55) -> #base_pet_war_dun{id = 55 ,desc = "55",chapter = 5 ,mon_list = [551,552,553,554,555] ,map_id = 5 ,first_pass_reward = [{20340,20},{1010005,10}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(56) -> #base_pet_war_dun{id = 56 ,desc = "56",chapter = 5 ,is_boss = 1 ,mon_list = [561,562,563,564,565] ,map_id = 1 ,first_pass_reward = [{20340,60},{1010005,30}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(57) -> #base_pet_war_dun{id = 57 ,desc = "57",chapter = 5 ,mon_list = [571,572,573,574,575] ,map_id = 2 ,first_pass_reward = [{20340,20},{1010005,10}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(58) -> #base_pet_war_dun{id = 58 ,desc = "58",chapter = 5 ,mon_list = [581,582,583,584,585] ,map_id = 3 ,first_pass_reward = [{20340,20},{1010005,10}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(59) -> #base_pet_war_dun{id = 59 ,desc = "59",chapter = 5 ,mon_list = [591,592,593,594,595] ,map_id = 4 ,first_pass_reward = [{20340,20},{1010005,10}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(60) -> #base_pet_war_dun{id = 60 ,desc = "60",chapter = 5 ,is_boss = 1 ,mon_list = [601,602,603,604,605] ,map_id = 5 ,first_pass_reward = [{20340,60},{1010005,30}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(61) -> #base_pet_war_dun{id = 61 ,desc = "61",chapter = 5 ,mon_list = [611,612,613,614,615] ,map_id = 1 ,first_pass_reward = [{20340,20},{1010005,10}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(62) -> #base_pet_war_dun{id = 62 ,desc = "62",chapter = 5 ,mon_list = [621,622,623,624,625] ,map_id = 2 ,first_pass_reward = [{20340,20},{1010005,10}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(63) -> #base_pet_war_dun{id = 63 ,desc = "63",chapter = 5 ,mon_list = [631,632,633,634,635] ,map_id = 3 ,first_pass_reward = [{20340,20},{1010005,10}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(64) -> #base_pet_war_dun{id = 64 ,desc = "64",chapter = 5 ,mon_list = [641,642,643,644,645] ,map_id = 4 ,first_pass_reward = [{20340,20},{1010005,10}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(65) -> #base_pet_war_dun{id = 65 ,desc = "65",chapter = 5 ,is_boss = 1 ,mon_list = [651,652,653,654,655] ,map_id = 5 ,first_pass_reward = [{21091,1},{20340,80},{1010005,40}] ,daily_pass_reward = [{20340,6,100},{1010005,6,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(66) -> #base_pet_war_dun{id = 66 ,desc = "66",chapter = 6 ,mon_list = [661,662,663,664,665] ,map_id = 1 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(67) -> #base_pet_war_dun{id = 67 ,desc = "67",chapter = 6 ,mon_list = [671,672,673,674,675] ,map_id = 2 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(68) -> #base_pet_war_dun{id = 68 ,desc = "68",chapter = 6 ,mon_list = [681,682,683,684,685] ,map_id = 3 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(69) -> #base_pet_war_dun{id = 69 ,desc = "69",chapter = 6 ,is_boss = 1 ,mon_list = [691,692,693,694,695] ,map_id = 4 ,first_pass_reward = [{20340,75},{1010005,38}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(70) -> #base_pet_war_dun{id = 70 ,desc = "70",chapter = 6 ,mon_list = [701,702,703,704,705] ,map_id = 5 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(71) -> #base_pet_war_dun{id = 71 ,desc = "71",chapter = 6 ,mon_list = [711,712,713,714,715] ,map_id = 1 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(72) -> #base_pet_war_dun{id = 72 ,desc = "72",chapter = 6 ,mon_list = [721,722,723,724,725] ,map_id = 2 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(73) -> #base_pet_war_dun{id = 73 ,desc = "73",chapter = 6 ,is_boss = 1 ,mon_list = [731,732,733,734,735] ,map_id = 3 ,first_pass_reward = [{20340,75},{1010005,38}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(74) -> #base_pet_war_dun{id = 74 ,desc = "74",chapter = 6 ,mon_list = [741,742,743,744,745] ,map_id = 4 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(75) -> #base_pet_war_dun{id = 75 ,desc = "75",chapter = 6 ,mon_list = [751,752,753,754,755] ,map_id = 5 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(76) -> #base_pet_war_dun{id = 76 ,desc = "76",chapter = 6 ,mon_list = [761,762,763,764,765] ,map_id = 1 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(77) -> #base_pet_war_dun{id = 77 ,desc = "77",chapter = 6 ,mon_list = [771,772,773,774,775] ,map_id = 2 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(78) -> #base_pet_war_dun{id = 78 ,desc = "78",chapter = 6 ,is_boss = 1 ,mon_list = [781,782,783,784,785] ,map_id = 3 ,first_pass_reward = [{21051,1},{20340,100},{1010005,50}] ,daily_pass_reward = [{20340,6,100},{1010005,6,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(79) -> #base_pet_war_dun{id = 79 ,desc = "79",chapter = 7 ,mon_list = [791,792,793,794,795] ,map_id = 4 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(80) -> #base_pet_war_dun{id = 80 ,desc = "80",chapter = 7 ,mon_list = [801,802,803,804,805] ,map_id = 5 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(81) -> #base_pet_war_dun{id = 81 ,desc = "81",chapter = 7 ,mon_list = [811,812,813,814,815] ,map_id = 1 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(82) -> #base_pet_war_dun{id = 82 ,desc = "82",chapter = 7 ,is_boss = 1 ,mon_list = [821,822,823,824,825] ,map_id = 2 ,first_pass_reward = [{20340,75},{1010005,38}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(83) -> #base_pet_war_dun{id = 83 ,desc = "83",chapter = 7 ,mon_list = [831,832,833,834,835] ,map_id = 3 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(84) -> #base_pet_war_dun{id = 84 ,desc = "84",chapter = 7 ,mon_list = [841,842,843,844,845] ,map_id = 4 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(85) -> #base_pet_war_dun{id = 85 ,desc = "85",chapter = 7 ,mon_list = [851,852,853,854,855] ,map_id = 5 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(86) -> #base_pet_war_dun{id = 86 ,desc = "86",chapter = 7 ,is_boss = 1 ,mon_list = [861,862,863,864,865] ,map_id = 1 ,first_pass_reward = [{20340,75},{1010005,38}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(87) -> #base_pet_war_dun{id = 87 ,desc = "87",chapter = 7 ,mon_list = [871,872,873,874,875] ,map_id = 2 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(88) -> #base_pet_war_dun{id = 88 ,desc = "88",chapter = 7 ,mon_list = [881,882,883,884,885] ,map_id = 3 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(89) -> #base_pet_war_dun{id = 89 ,desc = "89",chapter = 7 ,mon_list = [891,892,893,894,895] ,map_id = 4 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(90) -> #base_pet_war_dun{id = 90 ,desc = "90",chapter = 7 ,mon_list = [901,902,903,904,905] ,map_id = 5 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(91) -> #base_pet_war_dun{id = 91 ,desc = "91",chapter = 7 ,is_boss = 1 ,mon_list = [911,912,913,914,915] ,map_id = 1 ,first_pass_reward = [{21071,1},{20340,100},{1010005,50}] ,daily_pass_reward = [{20340,6,100},{1010005,6,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(92) -> #base_pet_war_dun{id = 92 ,desc = "92",chapter = 8 ,mon_list = [921,922,923,924,925] ,map_id = 2 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(93) -> #base_pet_war_dun{id = 93 ,desc = "93",chapter = 8 ,mon_list = [931,932,933,934,935] ,map_id = 3 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(94) -> #base_pet_war_dun{id = 94 ,desc = "94",chapter = 8 ,mon_list = [941,942,943,944,945] ,map_id = 4 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(95) -> #base_pet_war_dun{id = 95 ,desc = "95",chapter = 8 ,is_boss = 1 ,mon_list = [951,952,953,954,955] ,map_id = 5 ,first_pass_reward = [{20340,75},{1010005,38}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(96) -> #base_pet_war_dun{id = 96 ,desc = "96",chapter = 8 ,mon_list = [961,962,963,964,965] ,map_id = 1 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(97) -> #base_pet_war_dun{id = 97 ,desc = "97",chapter = 8 ,mon_list = [971,972,973,974,975] ,map_id = 2 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(98) -> #base_pet_war_dun{id = 98 ,desc = "98",chapter = 8 ,mon_list = [981,982,983,984,985] ,map_id = 3 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(99) -> #base_pet_war_dun{id = 99 ,desc = "99",chapter = 8 ,is_boss = 1 ,mon_list = [991,992,993,994,995] ,map_id = 4 ,first_pass_reward = [{20340,75},{1010005,38}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(100) -> #base_pet_war_dun{id = 100 ,desc = "100",chapter = 8 ,mon_list = [1001,1002,1003,1004,1005] ,map_id = 5 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(101) -> #base_pet_war_dun{id = 101 ,desc = "101",chapter = 8 ,mon_list = [1011,1012,1013,1014,1015] ,map_id = 1 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(102) -> #base_pet_war_dun{id = 102 ,desc = "102",chapter = 8 ,mon_list = [1021,1022,1023,1024,1025] ,map_id = 2 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(103) -> #base_pet_war_dun{id = 103 ,desc = "103",chapter = 8 ,mon_list = [1031,1032,1033,1034,1035] ,map_id = 3 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(104) -> #base_pet_war_dun{id = 104 ,desc = "104",chapter = 8 ,is_boss = 1 ,mon_list = [1041,1042,1043,1044,1045] ,map_id = 4 ,first_pass_reward = [{21091,1},{20340,100},{1010005,50}] ,daily_pass_reward = [{20340,6,100},{1010005,6,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(105) -> #base_pet_war_dun{id = 105 ,desc = "105",chapter = 9 ,mon_list = [1051,1052,1053,1054,1055] ,map_id = 5 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(106) -> #base_pet_war_dun{id = 106 ,desc = "106",chapter = 9 ,mon_list = [1061,1062,1063,1064,1065] ,map_id = 1 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(107) -> #base_pet_war_dun{id = 107 ,desc = "107",chapter = 9 ,mon_list = [1071,1072,1073,1074,1075] ,map_id = 2 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(108) -> #base_pet_war_dun{id = 108 ,desc = "108",chapter = 9 ,is_boss = 1 ,mon_list = [1081,1082,1083,1084,1085] ,map_id = 3 ,first_pass_reward = [{20340,75},{1010005,38}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(109) -> #base_pet_war_dun{id = 109 ,desc = "109",chapter = 9 ,mon_list = [1091,1092,1093,1094,1095] ,map_id = 4 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(110) -> #base_pet_war_dun{id = 110 ,desc = "110",chapter = 9 ,mon_list = [1101,1102,1103,1104,1105] ,map_id = 5 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(111) -> #base_pet_war_dun{id = 111 ,desc = "111",chapter = 9 ,mon_list = [1111,1112,1113,1114,1115] ,map_id = 1 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(112) -> #base_pet_war_dun{id = 112 ,desc = "112",chapter = 9 ,is_boss = 1 ,mon_list = [1121,1122,1123,1124,1125] ,map_id = 2 ,first_pass_reward = [{20340,75},{1010005,38}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(113) -> #base_pet_war_dun{id = 113 ,desc = "113",chapter = 9 ,mon_list = [1131,1132,1133,1134,1135] ,map_id = 3 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(114) -> #base_pet_war_dun{id = 114 ,desc = "114",chapter = 9 ,mon_list = [1141,1142,1143,1144,1145] ,map_id = 4 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(115) -> #base_pet_war_dun{id = 115 ,desc = "115",chapter = 9 ,mon_list = [1151,1152,1153,1154,1155] ,map_id = 5 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(116) -> #base_pet_war_dun{id = 116 ,desc = "116",chapter = 9 ,mon_list = [1161,1162,1163,1164,1165] ,map_id = 1 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(117) -> #base_pet_war_dun{id = 117 ,desc = "117",chapter = 9 ,is_boss = 1 ,mon_list = [1171,1172,1173,1174,1175] ,map_id = 2 ,first_pass_reward = [{21051,1},{20340,100},{1010005,50}] ,daily_pass_reward = [{20340,6,100},{1010005,6,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(118) -> #base_pet_war_dun{id = 118 ,desc = "118",chapter = 10 ,mon_list = [1181,1182,1183,1184,1185] ,map_id = 3 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(119) -> #base_pet_war_dun{id = 119 ,desc = "119",chapter = 10 ,mon_list = [1191,1192,1193,1194,1195] ,map_id = 4 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(120) -> #base_pet_war_dun{id = 120 ,desc = "120",chapter = 10 ,mon_list = [1201,1202,1203,1204,1205] ,map_id = 5 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(121) -> #base_pet_war_dun{id = 121 ,desc = "121",chapter = 10 ,is_boss = 1 ,mon_list = [1211,1212,1213,1214,1215] ,map_id = 1 ,first_pass_reward = [{20340,75},{1010005,38}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(122) -> #base_pet_war_dun{id = 122 ,desc = "122",chapter = 10 ,mon_list = [1221,1222,1223,1224,1225] ,map_id = 2 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(123) -> #base_pet_war_dun{id = 123 ,desc = "123",chapter = 10 ,mon_list = [1231,1232,1233,1234,1235] ,map_id = 3 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(124) -> #base_pet_war_dun{id = 124 ,desc = "124",chapter = 10 ,mon_list = [1241,1242,1243,1244,1245] ,map_id = 4 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(125) -> #base_pet_war_dun{id = 125 ,desc = "125",chapter = 10 ,is_boss = 1 ,mon_list = [1251,1252,1253,1254,1255] ,map_id = 5 ,first_pass_reward = [{20340,75},{1010005,38}] ,daily_pass_reward = [{20340,3,100},{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(126) -> #base_pet_war_dun{id = 126 ,desc = "126",chapter = 10 ,mon_list = [1261,1262,1263,1264,1265] ,map_id = 1 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(127) -> #base_pet_war_dun{id = 127 ,desc = "127",chapter = 10 ,mon_list = [1271,1272,1273,1274,1275] ,map_id = 2 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(128) -> #base_pet_war_dun{id = 128 ,desc = "128",chapter = 10 ,mon_list = [1281,1282,1283,1284,1285] ,map_id = 3 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{20340,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(129) -> #base_pet_war_dun{id = 129 ,desc = "129",chapter = 10 ,mon_list = [1291,1292,1293,1294,1295] ,map_id = 4 ,first_pass_reward = [{20340,25},{1010005,12}] ,daily_pass_reward = [{1010005,3,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(130) -> #base_pet_war_dun{id = 130 ,desc = "130",chapter = 10 ,is_boss = 1 ,mon_list = [1301,1302,1303,1304,1305] ,map_id = 5 ,first_pass_reward = [{21071,1},{20340,100},{1010005,50}] ,daily_pass_reward = [{20340,6,100},{1010005,6,100}] ,saodang_num = 1 ,lv = 50 ,mapBgId = 1};

get(_mon_id) ->  [].

ids() ->  [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130].
get_ids_by_chapter(1) -> [1,2,3,4,5,6,7,8,9,10,11,12,13];
get_ids_by_chapter(2) -> [14,15,16,17,18,19,20,21,22,23,24,25,26];
get_ids_by_chapter(3) -> [27,28,29,30,31,32,33,34,35,36,37,38,39];
get_ids_by_chapter(4) -> [40,41,42,43,44,45,46,47,48,49,50,51,52];
get_ids_by_chapter(5) -> [53,54,55,56,57,58,59,60,61,62,63,64,65];
get_ids_by_chapter(6) -> [66,67,68,69,70,71,72,73,74,75,76,77,78];
get_ids_by_chapter(7) -> [79,80,81,82,83,84,85,86,87,88,89,90,91];
get_ids_by_chapter(8) -> [92,93,94,95,96,97,98,99,100,101,102,103,104];
get_ids_by_chapter(9) -> [105,106,107,108,109,110,111,112,113,114,115,116,117];
get_ids_by_chapter(10) -> [118,119,120,121,122,123,124,125,126,127,128,129,130];
get_ids_by_chapter(_Chapter) -> [].
