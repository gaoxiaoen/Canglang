-module(notice_color).
-export([
		get_color_item/1,
		get_color_name/0,
		get_color_npc/0,
		get_color_dungeon/0
		]).


get_color_item(1) ->
	ff46d64a;
get_color_item(2) ->
	ff00e4ff;
get_color_item(3) ->
	ffe527e7;
get_color_item(4) ->
	fffe9999;
get_color_item(5) ->
	ffff7e00;
get_color_item(6) ->
	ffffea00;
get_color_item(_) ->
	ff46d64a.

get_color_name() ->
	ff08ff0e.

get_color_npc() ->
	ffffffff.

get_color_dungeon() ->
	ffff6c6c.