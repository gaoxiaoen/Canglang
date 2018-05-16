%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_magic_face
	%%% @Created : 2018-02-28 20:06:26
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_magic_face).
-export([get/1]).
-include("face_card.hrl").
-include("common.hrl").
get(1) -> #base_face_magic{id = 1, icon = 2001, name = ?T("吻你"), add_val = 1, consume1 = [{13100,1}], consume2 = [{13101,1}]};
get(2) -> #base_face_magic{id = 2, icon = 2002, name = ?T("戳你"), add_val = 2, consume1 = [{13100,2}], consume2 = [{13102,1}]};
get(3) -> #base_face_magic{id = 3, icon = 2003, name = ?T("打你"), add_val = 3, consume1 = [{13100,3}], consume2 = [{13103,1}]};
get(4) -> #base_face_magic{id = 4, icon = 2004, name = ?T("星星"), add_val = 4, consume1 = [{13100,4}], consume2 = [{13104,1}]};
get(5) -> #base_face_magic{id = 5, icon = 2005, name = ?T("爱你"), add_val = 5, consume1 = [{13100,5}], consume2 = [{13105,1}]};
get(_N) -> [].

