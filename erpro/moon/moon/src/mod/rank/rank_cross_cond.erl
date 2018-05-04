%%----------------------------------------------------
%% 跨服排行榜上榜条件过滤
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(rank_cross_cond).
-export([do/3]).
-include("common.hrl").
-include("rank.hrl").
-include("item.hrl").

do(_CrossType, [], L) -> L;
do(CrossType, [I | T], L) ->
    case check(CrossType, I) of
        false -> do(CrossType, T, L);
        true -> do(CrossType, T, [I | L])
    end.

%% 宠物
check(?rank_cross_pet_lev, #rank_role_pet{petlev = Val}) when Val < 70 -> false;
check(?rank_cross_pet_power, #rank_role_pet_power{power = Val}) when  Val < 18000 -> false;
check(?rank_cross_pet_grow, #rank_pet_grow{grow = Val}) when Val < 500 -> false;
check(?rank_cross_pet_potential, #rank_pet_potential{potential = Val}) when Val < 300 -> false;

%% 角色
check(?rank_cross_role_power, #rank_role_power{power = Val}) when Val < 50000 -> false;
check(?rank_cross_role_lev, #rank_role_lev{lev = Val}) when Val < 80 -> false;
check(?rank_cross_role_coin, #rank_role_coin{coin = Val}) when Val < 300000000 -> false;
check(?rank_cross_role_achieve, #rank_role_achieve{achieve = Val}) when Val < 3300 -> false;
check(?rank_cross_role_skill, #rank_role_skill{skill = Val}) when Val < 18000 -> false;
check(?rank_cross_role_soul, #rank_role_soul{soul = Val}) when Val < 8000 -> false;

%% 坐骑
check(?rank_cross_mount_power1, #rank_mount_power{step = Step, power = Power}) when Step < 8 orelse Power < 40000 -> false;
check(?rank_cross_mount_lev, #rank_mount_lev{mount_lev = Val, quality = _Quality}) when Val < 60 -> false;

%% 战场
check(?rank_cross_arena_kill, #rank_vie_kill{kill = Val}) when Val < 5000 -> false;
check(?rank_cross_world_compete_win, #rank_world_compete_win{win_count = Val}) when Val < 1000 -> false;

%% 装备
check(?rank_cross_arms, #rank_equip_arms{score = Val}) when Val < 25000 -> false;
%%    HoleList = [?attr_hole1, ?attr_hole2, ?attr_hole3, ?attr_hole4, ?attr_hole5],
%%    StoneList = [Value || {Name, _Flag, Value} <- Attr, lists:member(Name, HoleList) =:= true, stone_data:lev(Value) >= 6],
%%    StoneNum = lists:sum(StoneList),
%%    Enchant >= 12 andalso StoneNum >= 5;
check(?rank_cross_armor, #rank_equip_armor{score = Val}) when Val < 15000 -> false;

%% 灵戒洞天
check(?rank_cross_soul_world, #rank_soul_world{power = Power}) when Power < 10000 -> false;
check(?rank_cross_soul_world_array, #rank_soul_world_array{lev = Lev}) when Lev < 300 -> false;
check(?rank_cross_soul_world_spirit, #rank_soul_world_spirit{power = Power}) when Power < 4200 -> false;

%% 其它
check(_CrossType, _Data) -> true.
