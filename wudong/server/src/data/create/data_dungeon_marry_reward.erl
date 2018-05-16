%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_marry_reward
	%%% @Created : 2017-11-16 16:43:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_marry_reward).
-export([get_passReward_by_lv/1]).
-export([get_collectDrop_by_lv/1]).
-export([get_dropGoods_by_lv/1]).
-export([get_anwser_reward/1]).
-include("server.hrl").

get_passReward_by_lv(Lv) when Lv >= 1 andalso Lv =< 60 -> [{10108,62050},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 61 andalso Lv =< 65 -> [{10108,73800},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 66 andalso Lv =< 68 -> [{10108,82050},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 69 andalso Lv =< 71 -> [{10108,91200},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 72 andalso Lv =< 74 -> [{10108,101250},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 75 andalso Lv =< 77 -> [{10108,112200},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 78 andalso Lv =< 79 -> [{10108,120000},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 80 andalso Lv =< 91 -> [{10108,175200},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 92 andalso Lv =< 112 -> [{10108,306450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 113 andalso Lv =< 127 -> [{10108,427200},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 128 andalso Lv =< 142 -> [{10108,570450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 143 andalso Lv =< 157 -> [{10108,736200},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 158 andalso Lv =< 172 -> [{10108,924450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 173 andalso Lv =< 192 -> [{10108,1210450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 193 andalso Lv =< 212 -> [{10108,1536450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 213 andalso Lv =< 242 -> [{10108,2100450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 243 andalso Lv =< 272 -> [{10108,2754450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 273 andalso Lv =< 302 -> [{10108,3498450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 303 andalso Lv =< 332 -> [{10108,4332450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 333 andalso Lv =< 362 -> [{10108,5256450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(Lv) when Lv >= 363 andalso Lv =< 382 -> [{10108,5922450},{7206001,20},{7207001,20},{1025001,1}];
get_passReward_by_lv(_lv) -> [].


get_collectDrop_by_lv(Lv) when Lv >= 1 andalso Lv =< 60 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 61 andalso Lv =< 65 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 66 andalso Lv =< 68 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 69 andalso Lv =< 71 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 72 andalso Lv =< 74 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 75 andalso Lv =< 77 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 78 andalso Lv =< 79 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 80 andalso Lv =< 91 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 92 andalso Lv =< 112 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 113 andalso Lv =< 127 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 128 andalso Lv =< 142 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 143 andalso Lv =< 157 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 158 andalso Lv =< 172 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 173 andalso Lv =< 192 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 193 andalso Lv =< 212 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 213 andalso Lv =< 242 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 243 andalso Lv =< 272 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 273 andalso Lv =< 302 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 303 andalso Lv =< 332 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 333 andalso Lv =< 362 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(Lv) when Lv >= 363 andalso Lv =< 382 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_collectDrop_by_lv(_lv) -> [].


get_dropGoods_by_lv(Lv) when Lv >= 1 andalso Lv =< 60 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 61 andalso Lv =< 65 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 66 andalso Lv =< 68 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 69 andalso Lv =< 71 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 72 andalso Lv =< 74 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 75 andalso Lv =< 77 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 78 andalso Lv =< 79 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 80 andalso Lv =< 91 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 92 andalso Lv =< 112 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 113 andalso Lv =< 127 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 128 andalso Lv =< 142 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 143 andalso Lv =< 157 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 158 andalso Lv =< 172 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 173 andalso Lv =< 192 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 193 andalso Lv =< 212 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 213 andalso Lv =< 242 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 243 andalso Lv =< 272 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 273 andalso Lv =< 302 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 303 andalso Lv =< 332 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 333 andalso Lv =< 362 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(Lv) when Lv >= 363 andalso Lv =< 382 -> [{10108,1},{7206001,1},{1025001,1}];
get_dropGoods_by_lv(_lv) -> [].


get_anwser_reward(Lv) when Lv >= 1 andalso Lv =< 60 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 61 andalso Lv =< 65 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 66 andalso Lv =< 68 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 69 andalso Lv =< 71 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 72 andalso Lv =< 74 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 75 andalso Lv =< 77 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 78 andalso Lv =< 79 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 80 andalso Lv =< 91 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 92 andalso Lv =< 112 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 113 andalso Lv =< 127 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 128 andalso Lv =< 142 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 143 andalso Lv =< 157 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 158 andalso Lv =< 172 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 173 andalso Lv =< 192 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 193 andalso Lv =< 212 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 213 andalso Lv =< 242 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 243 andalso Lv =< 272 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 273 andalso Lv =< 302 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 303 andalso Lv =< 332 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 333 andalso Lv =< 362 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(Lv) when Lv >= 363 andalso Lv =< 382 -> [{7301001,1,10},{7302001,1,10},{5101402,1,10},{5101412,1,10},{5101422,1,10},{7207001,3,10},{7206001,3,10},{1025001,3,10},{2003000,3,10},{10106,5,10}];
get_anwser_reward(_lv) -> [].

