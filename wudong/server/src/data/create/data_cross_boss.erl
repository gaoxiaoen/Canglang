%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_boss
	%%% @Created : 2018-04-23 11:03:37
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_boss).
-export([ids/0, get/1, get_xy/1, get_layer_by_monId/1]).
-include("common.hrl").
-include("cross_boss.hrl").
ids() ->
    [44001,44002,44003,44004,44005,44011,44012,44013,44014,44015,44021,44022,44023,44029,44030,44031,44032,44033,44034].

get(44001) -> 
    #base_cross_boss{
    id = 1
    ,layer = 1
    ,type = 1
    ,boss_id = 44001
    ,x = 61
    ,y = 70
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 205
};
get(44002) -> 
    #base_cross_boss{
    id = 2
    ,layer = 1
    ,type = 1
    ,boss_id = 44002
    ,x = 9
    ,y = 81
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 109
};
get(44003) -> 
    #base_cross_boss{
    id = 3
    ,layer = 1
    ,type = 1
    ,boss_id = 44003
    ,x = 62
    ,y = 131
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 107
};
get(44004) -> 
    #base_cross_boss{
    id = 4
    ,layer = 1
    ,type = 1
    ,boss_id = 44004
    ,x = 62
    ,y = 20
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 108
};
get(44005) -> 
    #base_cross_boss{
    id = 5
    ,layer = 1
    ,type = 1
    ,boss_id = 44005
    ,x = 117
    ,y = 84
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 103
};
get(44011) -> 
    #base_cross_boss{
    id = 6
    ,layer = 2
    ,type = 1
    ,boss_id = 44011
    ,x = 61
    ,y = 70
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 304
};
get(44012) -> 
    #base_cross_boss{
    id = 7
    ,layer = 2
    ,type = 1
    ,boss_id = 44012
    ,x = 9
    ,y = 81
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 305
};
get(44013) -> 
    #base_cross_boss{
    id = 8
    ,layer = 2
    ,type = 1
    ,boss_id = 44013
    ,x = 62
    ,y = 131
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 303
};
get(44014) -> 
    #base_cross_boss{
    id = 9
    ,layer = 2
    ,type = 1
    ,boss_id = 44014
    ,x = 62
    ,y = 20
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 301
};
get(44015) -> 
    #base_cross_boss{
    id = 10
    ,layer = 2
    ,type = 1
    ,boss_id = 44015
    ,x = 117
    ,y = 84
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 302
};
get(44021) -> 
    #base_cross_boss{
    id = 11
    ,layer = 3
    ,type = 1
    ,boss_id = 44021
    ,x = 14
    ,y = 38
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 302
};
get(44022) -> 
    #base_cross_boss{
    id = 12
    ,layer = 3
    ,type = 1
    ,boss_id = 44022
    ,x = 33
    ,y = 25
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 109
};
get(44023) -> 
    #base_cross_boss{
    id = 13
    ,layer = 3
    ,type = 1
    ,boss_id = 44023
    ,x = 34
    ,y = 51
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 107
};
get(44029) -> 
    #base_cross_boss{
    id = 14
    ,layer = 4
    ,type = 1
    ,boss_id = 44029
    ,x = 9
    ,y = 20
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 106
};
get(44030) -> 
    #base_cross_boss{
    id = 15
    ,layer = 4
    ,type = 1
    ,boss_id = 44030
    ,x = 11
    ,y = 79
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 207
};
get(44031) -> 
    #base_cross_boss{
    id = 16
    ,layer = 4
    ,type = 1
    ,boss_id = 44031
    ,x = 64
    ,y = 78
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 209
};
get(44032) -> 
    #base_cross_boss{
    id = 17
    ,layer = 5
    ,type = 1
    ,boss_id = 44032
    ,x = 33
    ,y = 18
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 208
};
get(44033) -> 
    #base_cross_boss{
    id = 18
    ,layer = 5
    ,type = 1
    ,boss_id = 44033
    ,x = 13
    ,y = 78
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 303
};
get(44034) -> 
    #base_cross_boss{
    id = 19
    ,layer = 5
    ,type = 1
    ,boss_id = 44034
    ,x = 52
    ,y = 78
    ,is_exp = 1
    ,goods_list = [{8002003,1},{8001121,1},{8001001,1}]
    ,kill_score = 1
    ,kill_goods = 8002003
    ,roll_gift = 8001121
    ,red_bag_id = 1011004
    ,luck_goods = 8001001
    ,boss_icon = 304
};
get(_BossId) ->[].
get_xy(44001) -> {61,70};
get_xy(44002) -> {9,81};
get_xy(44003) -> {62,131};
get_xy(44004) -> {62,20};
get_xy(44005) -> {117,84};
get_xy(44011) -> {61,70};
get_xy(44012) -> {9,81};
get_xy(44013) -> {62,131};
get_xy(44014) -> {62,20};
get_xy(44015) -> {117,84};
get_xy(44021) -> {14,38};
get_xy(44022) -> {33,25};
get_xy(44023) -> {34,51};
get_xy(44029) -> {9,20};
get_xy(44030) -> {11,79};
get_xy(44031) -> {64,78};
get_xy(44032) -> {33,18};
get_xy(44033) -> {13,78};
get_xy(44034) -> {52,78};
get_xy(_BossId) ->[].
get_layer_by_monId(44001) -> 1;
get_layer_by_monId(44002) -> 1;
get_layer_by_monId(44003) -> 1;
get_layer_by_monId(44004) -> 1;
get_layer_by_monId(44005) -> 1;
get_layer_by_monId(44011) -> 2;
get_layer_by_monId(44012) -> 2;
get_layer_by_monId(44013) -> 2;
get_layer_by_monId(44014) -> 2;
get_layer_by_monId(44015) -> 2;
get_layer_by_monId(44021) -> 3;
get_layer_by_monId(44022) -> 3;
get_layer_by_monId(44023) -> 3;
get_layer_by_monId(44029) -> 4;
get_layer_by_monId(44030) -> 4;
get_layer_by_monId(44031) -> 4;
get_layer_by_monId(44032) -> 5;
get_layer_by_monId(44033) -> 5;
get_layer_by_monId(44034) -> 5;
get_layer_by_monId(_BossId) ->1.