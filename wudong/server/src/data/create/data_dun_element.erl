%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dun_element
	%%% @Created : 2018-03-28 15:41:09
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dun_element).
-export([get/1]).
-export([get_all/0]).
-include("dungeon.hrl").
get(61001) -> #base_dun_element{dun_id = 61001, is_boss=0, race = 1, reward = [{40011,1}], lv_limit=120 };
get(61002) -> #base_dun_element{dun_id = 61002, is_boss=0, race = 1, reward = [{40011,1}], lv_limit=130 };
get(61003) -> #base_dun_element{dun_id = 61003, is_boss=1, race = 1, reward = [{40011,2}], lv_limit=140 };
get(62001) -> #base_dun_element{dun_id = 62001, is_boss=0, race = 2, reward = [{40012,1}], lv_limit=150 };
get(62002) -> #base_dun_element{dun_id = 62002, is_boss=0, race = 2, reward = [{40012,1}], lv_limit=160 };
get(62003) -> #base_dun_element{dun_id = 62003, is_boss=1, race = 2, reward = [{40012,2}], lv_limit=170 };
get(63001) -> #base_dun_element{dun_id = 63001, is_boss=0, race = 3, reward = [{40013,1}], lv_limit=180 };
get(63002) -> #base_dun_element{dun_id = 63002, is_boss=0, race = 3, reward = [{40013,1}], lv_limit=190 };
get(63003) -> #base_dun_element{dun_id = 63003, is_boss=1, race = 3, reward = [{40013,2}], lv_limit=200 };
get(64001) -> #base_dun_element{dun_id = 64001, is_boss=0, race = 4, reward = [{40014,1}], lv_limit=210 };
get(64002) -> #base_dun_element{dun_id = 64002, is_boss=0, race = 4, reward = [{40014,1}], lv_limit=220 };
get(64003) -> #base_dun_element{dun_id = 64003, is_boss=1, race = 4, reward = [{40014,2}], lv_limit=230 };
get(65001) -> #base_dun_element{dun_id = 65001, is_boss=0, race = 5, reward = [{40015,1}], lv_limit=240 };
get(65002) -> #base_dun_element{dun_id = 65002, is_boss=0, race = 5, reward = [{40015,1}], lv_limit=250 };
get(65003) -> #base_dun_element{dun_id = 65003, is_boss=1, race = 5, reward = [{40015,2}], lv_limit=260 };
get(61601) -> #base_dun_element{dun_id = 61601, is_boss=0, race = 6, reward = [{40016,1}], lv_limit=270 };
get(61602) -> #base_dun_element{dun_id = 61602, is_boss=0, race = 6, reward = [{40016,1}], lv_limit=280 };
get(61603) -> #base_dun_element{dun_id = 61603, is_boss=1, race = 6, reward = [{40016,2}], lv_limit=290 };
get(_dun_id) -> [].

get_all()->[61001,61002,61003,62001,62002,62003,63001,63002,63003,64001,64002,64003,65001,65002,65003,61601,61602,61603].

