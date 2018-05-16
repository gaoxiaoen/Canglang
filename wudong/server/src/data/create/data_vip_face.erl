%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_vip_face
	%%% @Created : 2018-02-28 20:06:26
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_vip_face).
-export([get/1]).
-include("face_card.hrl").
-include("common.hrl").
get(13001) -> #base_face_vip_card{goods_id=13001, vip = 3, expire_time = 86400};
get(13002) -> #base_face_vip_card{goods_id=13002, vip = 3, expire_time = 604800};
get(13003) -> #base_face_vip_card{goods_id=13003, vip = 8, expire_time = 86400};
get(13004) -> #base_face_vip_card{goods_id=13004, vip = 8, expire_time = 604800};
get(13005) -> #base_face_vip_card{goods_id=13005, vip = 12, expire_time = 86400};
get(13006) -> #base_face_vip_card{goods_id=13006, vip = 12, expire_time = 604800};
get(_N) -> [].

