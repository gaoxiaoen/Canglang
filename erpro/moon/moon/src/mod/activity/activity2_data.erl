
-module(activity2_data).
-export([
		all/0
		,get/1
		,get_accept_cond/1
		,task_to_activity/1
		,get_events/1
		,get_name/1
    ]).

-include("activity2.hrl").

%% 兼容代码的接口
task_to_activity(_) -> false.
get_events(_) -> [].
get_name(_) -> <<"">>.
%% 

%% 所有日常ID
all() -> [3006,3007,3004,3005,3003,3002,3001,3011,3014,3015,3012,3013,3009,3008,3010].


%% 接受日常条件
get_accept_cond(3006) -> {10160, 0};
get_accept_cond(3007) -> {10555, 1};
get_accept_cond(3004) -> {10390, 0};
get_accept_cond(3005) -> {10420, 1};
get_accept_cond(3003) -> {10840, 1};
get_accept_cond(3002) -> {10670, 1};
get_accept_cond(3001) -> {10930, 1};
get_accept_cond(3011) -> {10330, 0};
get_accept_cond(3014) -> {10720, 0};
get_accept_cond(3015) -> {10930, 0};
get_accept_cond(3012) -> {11080, 1};
get_accept_cond(3013) -> {11310, 1};
get_accept_cond(3009) -> {11011, 0};
get_accept_cond(3008) -> {10340, 1};
get_accept_cond(3010) -> {11021, 0};
get_accept_cond(_) -> false.

%% 日常配置
%% {目标值，顺序， 开放等级，奖励}
get(3006) -> {3006, 10, 1, 0, [{exp, 25600},{coin, 2000}]};
get(3007) -> {3007, 5, 2, 1, [{exp, 12800},{coin, 2000}]};
get(3004) -> {3004, 3, 3, 1, [{exp, 25600},{coin, 2000}]};
get(3005) -> {3005, 3, 4, 1, [{exp, 22000},{coin, 2000}]};
get(3003) -> {3003, 1, 5, 1, [{exp, 25600},{coin, 2000}]};
get(3002) -> {3002, 1, 6, 1, [{exp, 25600},{coin, 2000}]};
get(3001) -> {3001, 1, 7, 1, [{exp, 25600},{coin, 2000}]};
get(3011) -> {3011, 5, 8, 1, [{exp, 6400},{coin, 2000}]};
get(3014) -> {3014, 1, 9, 1, [{exp, 6400},{coin, 2000}]};
get(3015) -> {3015, 3, 10, 1, [{exp, 12800},{coin, 2000}]};
get(3012) -> {3012, 3, 11, 1, [{exp, 12800},{coin, 2000}]};
get(3013) -> {3013, 5, 12, 1, [{exp, 12800},{coin, 2000},{item, [231001, 0, 1]}]};
get(3009) -> {3009, 3, 13, 1, [{exp, 12800},{coin, 2000}]};
get(3008) -> {3008, 1, 14, 1, [{exp, 12800},{coin, 2000}]};
get(3010) -> {3010, 1, 15, 1, [{exp, 6400},{coin, 2000}]};
get(_) -> false.






