%% Author: caochuncheng2002@gmail.com
%% Created: 2015-11-27
%% Description: 每天固定时间循环广播消息配置，不可以修改，必须消息广播配置表生成

-module(cfg_broadcast_loop).

-include("common.hrl").

-export([
         list/0
        ]).


list() -> 
    [#r_broadcast_message_config{id=1,bc_time={12,1,1},msg_type=1,msg_sub_type=0,msg = <<"可以吃饭，小休息一下，呵呵呵">>},
     #r_broadcast_message_config{id=2,bc_time={13,30,0},msg_type=1,msg_sub_type=0,msg = <<"接着继续工作，233333">>},
     #r_broadcast_message_config{id=3,bc_time={18,30,0},msg_type=1,msg_sub_type=0,msg = <<"晚饭时间到，没有能量，无法工作了">>},
     #r_broadcast_message_config{id=4,bc_time={16,30,0},msg_type=2,msg_sub_type=1,msg = <<"下午茶时间了，起来走动走动，跟同事交流交流">>}].


