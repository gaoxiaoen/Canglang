%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_war_star
	%%% @Created : 2017-12-27 22:51:52
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_war_star).
-export([get/1]).
-export([ids/0]).
-export([get_by_chapter/1]).
-export([get_by_chapter_star/2]).
-include("pet_war.hrl").

get(1) -> #base_pet_war_star{id = 1 ,chapter = 1 ,star = 4 ,reward = [{10106,50}]};

get(2) -> #base_pet_war_star{id = 2 ,chapter = 1 ,star = 8 ,reward = [{8001069,5}]};

get(3) -> #base_pet_war_star{id = 3 ,chapter = 1 ,star = 13 ,reward = [{21011,1}]};

get(4) -> #base_pet_war_star{id = 4 ,chapter = 2 ,star = 4 ,reward = [{10106,50}]};

get(5) -> #base_pet_war_star{id = 5 ,chapter = 2 ,star = 8 ,reward = [{8001069,5}]};

get(6) -> #base_pet_war_star{id = 6 ,chapter = 2 ,star = 13 ,reward = [{21011,1}]};

get(7) -> #base_pet_war_star{id = 7 ,chapter = 3 ,star = 4 ,reward = [{10106,100}]};

get(8) -> #base_pet_war_star{id = 8 ,chapter = 3 ,star = 8 ,reward = [{8001069,8}]};

get(9) -> #base_pet_war_star{id = 9 ,chapter = 3 ,star = 13 ,reward = [{21051,1}]};

get(10) -> #base_pet_war_star{id = 10 ,chapter = 4 ,star = 4 ,reward = [{10106,100}]};

get(11) -> #base_pet_war_star{id = 11 ,chapter = 4 ,star = 8 ,reward = [{8001069,8}]};

get(12) -> #base_pet_war_star{id = 12 ,chapter = 4 ,star = 13 ,reward = [{21071,1}]};

get(13) -> #base_pet_war_star{id = 13 ,chapter = 5 ,star = 4 ,reward = [{10106,150}]};

get(14) -> #base_pet_war_star{id = 14 ,chapter = 5 ,star = 8 ,reward = [{8001069,10}]};

get(15) -> #base_pet_war_star{id = 15 ,chapter = 5 ,star = 13 ,reward = [{21091,1}]};

get(16) -> #base_pet_war_star{id = 16 ,chapter = 6 ,star = 4 ,reward = [{10106,150}]};

get(17) -> #base_pet_war_star{id = 17 ,chapter = 6 ,star = 8 ,reward = [{8001069,10}]};

get(18) -> #base_pet_war_star{id = 18 ,chapter = 6 ,star = 13 ,reward = [{21051,1}]};

get(19) -> #base_pet_war_star{id = 19 ,chapter = 7 ,star = 4 ,reward = [{10106,200}]};

get(20) -> #base_pet_war_star{id = 20 ,chapter = 7 ,star = 8 ,reward = [{8001069,15}]};

get(21) -> #base_pet_war_star{id = 21 ,chapter = 7 ,star = 13 ,reward = [{21071,1}]};

get(22) -> #base_pet_war_star{id = 22 ,chapter = 8 ,star = 4 ,reward = [{10106,200}]};

get(23) -> #base_pet_war_star{id = 23 ,chapter = 8 ,star = 8 ,reward = [{8001069,15}]};

get(24) -> #base_pet_war_star{id = 24 ,chapter = 8 ,star = 13 ,reward = [{21091,1}]};

get(25) -> #base_pet_war_star{id = 25 ,chapter = 9 ,star = 4 ,reward = [{10106,200}]};

get(26) -> #base_pet_war_star{id = 26 ,chapter = 9 ,star = 8 ,reward = [{8001069,15}]};

get(27) -> #base_pet_war_star{id = 27 ,chapter = 9 ,star = 13 ,reward = [{21051,1}]};

get(28) -> #base_pet_war_star{id = 28 ,chapter = 10 ,star = 4 ,reward = [{10106,200}]};

get(29) -> #base_pet_war_star{id = 29 ,chapter = 10 ,star = 8 ,reward = [{8001069,15}]};

get(30) -> #base_pet_war_star{id = 30 ,chapter = 10 ,star = 13 ,reward = [{21071,1}]};

get(_) ->  [].

get_by_chapter_star(1, 4) -> #base_pet_war_star{id = 1 ,chapter = 1 ,star = 4 ,reward = [{10106,50}]};

get_by_chapter_star(1, 8) -> #base_pet_war_star{id = 2 ,chapter = 1 ,star = 8 ,reward = [{8001069,5}]};

get_by_chapter_star(1, 13) -> #base_pet_war_star{id = 3 ,chapter = 1 ,star = 13 ,reward = [{21011,1}]};

get_by_chapter_star(2, 4) -> #base_pet_war_star{id = 4 ,chapter = 2 ,star = 4 ,reward = [{10106,50}]};

get_by_chapter_star(2, 8) -> #base_pet_war_star{id = 5 ,chapter = 2 ,star = 8 ,reward = [{8001069,5}]};

get_by_chapter_star(2, 13) -> #base_pet_war_star{id = 6 ,chapter = 2 ,star = 13 ,reward = [{21011,1}]};

get_by_chapter_star(3, 4) -> #base_pet_war_star{id = 7 ,chapter = 3 ,star = 4 ,reward = [{10106,100}]};

get_by_chapter_star(3, 8) -> #base_pet_war_star{id = 8 ,chapter = 3 ,star = 8 ,reward = [{8001069,8}]};

get_by_chapter_star(3, 13) -> #base_pet_war_star{id = 9 ,chapter = 3 ,star = 13 ,reward = [{21051,1}]};

get_by_chapter_star(4, 4) -> #base_pet_war_star{id = 10 ,chapter = 4 ,star = 4 ,reward = [{10106,100}]};

get_by_chapter_star(4, 8) -> #base_pet_war_star{id = 11 ,chapter = 4 ,star = 8 ,reward = [{8001069,8}]};

get_by_chapter_star(4, 13) -> #base_pet_war_star{id = 12 ,chapter = 4 ,star = 13 ,reward = [{21071,1}]};

get_by_chapter_star(5, 4) -> #base_pet_war_star{id = 13 ,chapter = 5 ,star = 4 ,reward = [{10106,150}]};

get_by_chapter_star(5, 8) -> #base_pet_war_star{id = 14 ,chapter = 5 ,star = 8 ,reward = [{8001069,10}]};

get_by_chapter_star(5, 13) -> #base_pet_war_star{id = 15 ,chapter = 5 ,star = 13 ,reward = [{21091,1}]};

get_by_chapter_star(6, 4) -> #base_pet_war_star{id = 16 ,chapter = 6 ,star = 4 ,reward = [{10106,150}]};

get_by_chapter_star(6, 8) -> #base_pet_war_star{id = 17 ,chapter = 6 ,star = 8 ,reward = [{8001069,10}]};

get_by_chapter_star(6, 13) -> #base_pet_war_star{id = 18 ,chapter = 6 ,star = 13 ,reward = [{21051,1}]};

get_by_chapter_star(7, 4) -> #base_pet_war_star{id = 19 ,chapter = 7 ,star = 4 ,reward = [{10106,200}]};

get_by_chapter_star(7, 8) -> #base_pet_war_star{id = 20 ,chapter = 7 ,star = 8 ,reward = [{8001069,15}]};

get_by_chapter_star(7, 13) -> #base_pet_war_star{id = 21 ,chapter = 7 ,star = 13 ,reward = [{21071,1}]};

get_by_chapter_star(8, 4) -> #base_pet_war_star{id = 22 ,chapter = 8 ,star = 4 ,reward = [{10106,200}]};

get_by_chapter_star(8, 8) -> #base_pet_war_star{id = 23 ,chapter = 8 ,star = 8 ,reward = [{8001069,15}]};

get_by_chapter_star(8, 13) -> #base_pet_war_star{id = 24 ,chapter = 8 ,star = 13 ,reward = [{21091,1}]};

get_by_chapter_star(9, 4) -> #base_pet_war_star{id = 25 ,chapter = 9 ,star = 4 ,reward = [{10106,200}]};

get_by_chapter_star(9, 8) -> #base_pet_war_star{id = 26 ,chapter = 9 ,star = 8 ,reward = [{8001069,15}]};

get_by_chapter_star(9, 13) -> #base_pet_war_star{id = 27 ,chapter = 9 ,star = 13 ,reward = [{21051,1}]};

get_by_chapter_star(10, 4) -> #base_pet_war_star{id = 28 ,chapter = 10 ,star = 4 ,reward = [{10106,200}]};

get_by_chapter_star(10, 8) -> #base_pet_war_star{id = 29 ,chapter = 10 ,star = 8 ,reward = [{8001069,15}]};

get_by_chapter_star(10, 13) -> #base_pet_war_star{id = 30 ,chapter = 10 ,star = 13 ,reward = [{21071,1}]};

get_by_chapter_star(_Chapter, _Star) ->  [].

ids() ->  [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30].
get_by_chapter(1) -> [{4, [{10106,50}]},{8, [{8001069,5}]},{13, [{21011,1}]}];
get_by_chapter(2) -> [{4, [{10106,50}]},{8, [{8001069,5}]},{13, [{21011,1}]}];
get_by_chapter(3) -> [{4, [{10106,100}]},{8, [{8001069,8}]},{13, [{21051,1}]}];
get_by_chapter(4) -> [{4, [{10106,100}]},{8, [{8001069,8}]},{13, [{21071,1}]}];
get_by_chapter(5) -> [{4, [{10106,150}]},{8, [{8001069,10}]},{13, [{21091,1}]}];
get_by_chapter(6) -> [{4, [{10106,150}]},{8, [{8001069,10}]},{13, [{21051,1}]}];
get_by_chapter(7) -> [{4, [{10106,200}]},{8, [{8001069,15}]},{13, [{21071,1}]}];
get_by_chapter(8) -> [{4, [{10106,200}]},{8, [{8001069,15}]},{13, [{21091,1}]}];
get_by_chapter(9) -> [{4, [{10106,200}]},{8, [{8001069,15}]},{13, [{21051,1}]}];
get_by_chapter(10) -> [{4, [{10106,200}]},{8, [{8001069,15}]},{13, [{21071,1}]}];
get_by_chapter(_Chapter) -> [].
