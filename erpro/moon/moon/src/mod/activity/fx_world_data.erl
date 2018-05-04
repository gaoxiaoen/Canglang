%%----------------------------------------------------
%% 飞仙世界配置数据
%% @author lishen@jieyou.cn
%%----------------------------------------------------
-module(fx_world_data).
-export([
        get_open_list/1
        ,srv_open_set/1
        ,srv_merge_set/1
        ,get_id_list/0
        ]).

%% 每天开启活动列表
get_open_list(1) -> [1,2,3,4,5,6,7,8,9,12,17,18];
get_open_list(2) -> [1,2,3,4,5,6,7,8,11,12,17,18];
get_open_list(3) -> [1,2,3,4,5,6,7,8,9,12,17,18];
get_open_list(4) -> [1,2,3,4,5,6,7,8,10,11,12,17,18];
get_open_list(5) -> [1,2,3,4,5,6,7,8,9,10,12,17,18];
get_open_list(6) -> [1,2,3,4,5,6,7,11,14,12,17,18];
get_open_list(7) -> [1,2,3,4,5,6,7,9,13,14,15,12,17,18];
get_open_list(_) -> [].

%% 活动id列表
get_id_list() -> [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18].

%% 活动开服设定
srv_open_set(1) -> 0;
srv_open_set(2) -> 0;
srv_open_set(3) -> 0;
srv_open_set(4) -> 0;
srv_open_set(5) -> 0;
srv_open_set(6) -> 0;
srv_open_set(7) -> 15;
srv_open_set(8) -> 0;
srv_open_set(9) -> 3;
srv_open_set(10) -> 7;
srv_open_set(11) -> 3;
srv_open_set(12) -> 15;
srv_open_set(13) -> 15;
srv_open_set(14) -> 7;
srv_open_set(15) -> 0;
srv_open_set(_) -> 0.

%% 活动合服设定
srv_merge_set(1) -> 0;
srv_merge_set(2) -> 0;
srv_merge_set(3) -> 0;
srv_merge_set(4) -> 0;
srv_merge_set(5) -> 0;
srv_merge_set(6) -> 0;
srv_merge_set(7) -> 0;
srv_merge_set(8) -> 0;
srv_merge_set(9) -> 0;
srv_merge_set(10) -> 0;
srv_merge_set(11) -> 0;
srv_merge_set(12) -> 0;
srv_merge_set(13) -> 0;
srv_merge_set(14) -> 0;
srv_merge_set(15) -> 1;
srv_merge_set(_) -> 0.
