%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 十一月 2015 14:58
%%%-------------------------------------------------------------------
-module(dungeon_init).
-author("hxming").

-include("server.hrl").
%% API
-export([init/1]).

%%初始化玩家副本数据
init(Player)->
    Now = util:unixtime(),
    dungeon_tower:init(Player,Now),
    dungeon_material:init(Player,Now),
    dungeon_exp:init(Player,Now),
    dungeon_daily:init(Player),
    dungeon_fuwen_tower:init(Player),
    dungeon_god_weapon:init(Player,Now),
    dungeon_guard:init(Player,Now),
    dungeon_marry:init(Player),
    dungeon_equip:init(Player),
    dungeon_godness:init(Player),
    dungeon_elite_boss:init(Player),
    dungeon_element:init(Player),
    dungeon_jiandao:init(Player),
    Player.