%% Author: markycai<tomarky.cai@gmail.com>
%% Created: 2013-12-9
%% Description: TODO: Add description to cfg_chat

-module(cfg_chat).

-export([find/1]).

%% 频道处理消息进程数
%% 系统频道
find({channel_extend,0})->10;
%% 世界频道
find({channel_extend,1})->10;
%% 门派频道
find({channel_extend,2})->3;

%% 当前频道消息进程数，即地图频道进程数
find({channel_map,10001}) -> 2;
find({channel_map,_MapId}) -> 1;

%% 频道进入加入最小等级
find({min_level,1})->0;

%% 消息长度限制 80个汉字，对应erlang二进制长度为 240
find(max_message_length) ->
    240;

find({msg_code,10000})->true;

%% 不同频道发送消息的时间间隔，单位：秒
find({send_message_interval,1}) -> %% 世界频道
    30;
find({send_message_interval,2}) -> %% 门派频道
    10;
find({send_message_interval,3}) -> %% 帮派频道
    3;
find({send_message_interval,4}) -> %% 组队频道
    3;
find({send_message_interval,5}) -> %% 当前频道
    3;
find({send_message_interval,_}) -> %% 默认
    3;

%% 频道发送消息，需要消耗[活力值,#p_role_base.energy]
find({consume_energy,1}) -> %% 世界频道 50
    0;
find({consume_energy,2}) -> %% 门派频道 20
    0;
find({consume_energy,_}) -> %% 默认频道
    0;

find(_)->[].


