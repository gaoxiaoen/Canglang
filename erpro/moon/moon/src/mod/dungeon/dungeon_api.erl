%% --------------------------------------------------------------------
%% 与副本相关的接口
%% @author abu@jieyou.cn
%% --------------------------------------------------------------------
-module(dungeon_api).

-export([
        pack_proto_13501/2
        ,get_vip_rewards/2
        ,unlock_dungeon/3
        ,unlock_all_dungeon/1
        ,best_all_dungeon/1
        ,unlock_all_map/1
        ,reset_box/1
        ,is_hard/1
        ,get_map_id/1
        ,clear_dungeon/4
        ,clear_dungeon/5
        ,clear_dungeon_leisure/5
        ,get_dungeon_drop/3
        ,make_gain_info/1
        ,notify_to_the_world/2
    ]).

-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("gain.hrl").
-include("dungeon.hrl").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------
pack_proto_13501(DungeonMap, RoleDungeons) ->
    ProtoMaps = [{MapId, BlueIsTaken, PurpleIsTaken, length(IsOpened)} || {MapId, _, _, BlueIsTaken, PurpleIsTaken, IsOpened} <- DungeonMap],
    ProtoNormal = [{Id, BestStar, ReachGoals} || #role_dungeon{id = Id, best_star = BestStar, reach_goals = ReachGoals} <- RoleDungeons, not is_hard(Id)],
    ProtoHard = [get_proto_hard(RoleDungeon) || RoleDungeon = #role_dungeon{id = Id} <- RoleDungeons, is_hard(Id)],
    {ProtoMaps, ProtoNormal, ProtoHard}.

get_vip_rewards(ClearRewards, Role) ->
    get_vip_rewards(ClearRewards, Role, []).
get_vip_rewards([], _, Return) ->
    Return;
get_vip_rewards([H = #gain{label = Label, val = Value} | T], Role, Return) ->
    case Label of
        exp ->
            Value2 = Value * (1 + vip:dungeon_exp(Role)),
            get_vip_rewards(T, Role, [H#gain{val = util:ceil(Value2)} | Return]);
        _ ->
            get_vip_rewards(T, Role, [H | Return])
    end.


unlock_dungeon(RolePid, RoleDungeons, DungeonId) ->
    case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        #role_dungeon{} ->
            RoleDungeons;
        _ ->
            role:pack_send(RolePid, 13502, {DungeonId, 0, 0, dungeon_type:get_left_count(DungeonId, 0, 0, 0), 0}),
            [#role_dungeon{id = DungeonId} | RoleDungeons]
    end.

unlock_all_dungeon(_RoleDungeons) ->
    DungeonIds = dungeon_data:all(),
    lists:foldl(fun(DungeonId, Return) ->
                case DungeonId < 10000 orelse (DungeonId rem 10) =:= 3 of
                    true ->
                        Return;
                    false -> 
                        [#role_dungeon{id = DungeonId} | Return]
                end
        end, [], DungeonIds).

best_all_dungeon(_RoleDungeons) ->
    DungeonIds = dungeon_data:all(),
    RoleDungeons2 = lists:foldl(fun(DungeonId, Return) ->
                case DungeonId < 10000 orelse (DungeonId rem 10) =:= 3 of
                    true ->
                        Return;
                    false ->
                        [#role_dungeon{id = DungeonId, best_star = 3, reach_goals = 14} | Return]
                end
        end, [], DungeonIds),
    MapIds = dungeon_data:all_map(),
    DungeonMap2 = lists:foldl(fun(MapId, Return) ->
                #dungeon_map_base{total_blue = TotalBlue, total_purple = TotalPurple} = dungeon_data:map(MapId),
                [{MapId, TotalBlue, TotalPurple, ?false, ?false, []} | Return]
        end, [], MapIds),
    {DungeonMap2, RoleDungeons2}.

unlock_all_map(DungeonMap) ->
    MapIds = dungeon_data:all_map(),
    lists:foldl(fun(MapId, Return) ->
                case lists:keyfind(MapId, 1, Return) of
                    false ->
                        [{MapId, 0, 0, ?false, ?false, []} | Return];
                    _ ->
                        Return
                end
        end, DungeonMap, MapIds).

reset_box(DungeonMap) ->
    lists:map(fun({MapId, Blue, Purple, BlueIsTaken, PurpleIsTaken, _IsOpened}) ->
                {MapId, Blue, Purple, BlueIsTaken, PurpleIsTaken, []}
        end, DungeonMap).

%%是否困难难度副本
is_hard(DungeonId) ->
    (DungeonId > 10000) and ((DungeonId rem 10) =:= 2).

get_map_id(DungeonId) ->
    DungeonId div 1000.

clear_dungeon(RolePid, DungeonId, _Star, Count) ->
    clear_dungeon(RolePid, DungeonId, 0, 0, Count).

clear_dungeon(RolePid, DungeonId, Star, ReachGoals, Count) ->
    role:apply(async, RolePid, {fun async_clear_dungeon/5, [DungeonId, Star, ReachGoals, Count]}).

%%Internal Function
async_clear_dungeon(Role = #role{dungeon = RoleDungeons, dungeon_map = DungeonMap}, DungeonId, Star, Goals, Count) ->
    %%首次通关奖励
    Role3 = case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        #role_dungeon{clear_count = OldClearCount} when OldClearCount > 0 ->
            Role;
        _ ->
            Role_1 = first_clear_dungeon(Role, DungeonId),
            task:clear_dungeon_fire(DungeonId, Role_1)
    end,

    {Role4, Star1} = case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        RoleDungeon = #role_dungeon{best_star = BestStar, reach_goals = ReachGoals, clear_count = ClearCount} ->
            BestStar2 = BestStar + Star,
            RoleDungeons2 = unlock_next_dungeon(Role3, DungeonId),

            RoleDungeons3 = lists:keyreplace(DungeonId, #role_dungeon.id, RoleDungeons2,
                RoleDungeon#role_dungeon{best_star = BestStar2, reach_goals = ReachGoals + Goals, clear_count = ClearCount + Count}),

            DungeonMap2 = add_map_star(DungeonMap, DungeonId, Star),

            {Role3#role{dungeon = RoleDungeons3, dungeon_map = DungeonMap2}, BestStar2};
        _ ->
            {Role3, 0}
    end,
    
    Role4_1 = role_listener:star_dungeon(Role4, {DungeonId, Star1}),

    %%军团目标监听
    role_listener:guild_dungeon(Role4_1, {}),
    Role5 = medal:listener(dungeon, Role4_1, {DungeonId, Count}),
    Role6 =
    case is_hard(DungeonId) of 
        false -> role_listener:special_event(Role5, {3006, Count});    %% 触发日常 普通副本通关
        true ->
            role_listener:special_event(Role5, {3007, Count})     %% 触发日常 困难副本通关
    end,        
    Role7 = role_listener:sweep_dungeon(Role6, {DungeonId, Count}),
    Role8 = role_listener:once_dungeon(Role7, {DungeonId, Count}),
    {ok, Role8}.

%%休闲玩法
clear_dungeon_leisure(RolePid, DungeonId, Star, ReachGoals, Count) ->
    role:apply(async, RolePid, {fun async_clear_dungeon_leisure/5, [DungeonId, Star, ReachGoals, Count]}).

%%休闲玩法 Internal Function
async_clear_dungeon_leisure(Role = #role{dungeon = RoleDungeons,
        dungeon_map = DungeonMap}, DungeonId, Star, Goals, Count) ->

    {Role2, NewStar} = case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        RoleDungeon = #role_dungeon{best_star = BestStar, reach_goals = ReachGoals, clear_count = ClearCount} ->
            BestStar2 =
                case is_integer(Star) andalso Star > BestStar of
                    true -> Star;
                    _ -> BestStar
                end,
            ReachGoals2 = 
                case Goals > ReachGoals of 
                    true -> Goals;
                    _ -> ReachGoals
                end,
            RoleDungeons2 = unlock_next_dungeon(Role, DungeonId),

            RoleDungeons3 = lists:keyreplace(DungeonId, #role_dungeon.id, RoleDungeons2,
                RoleDungeon#role_dungeon{best_star = BestStar2, reach_goals = ReachGoals2, clear_count = ClearCount + Count}),

            DungeonMap2 = add_map_star(DungeonMap, DungeonId, BestStar2 - BestStar),

            {Role#role{dungeon = RoleDungeons3, dungeon_map = DungeonMap2}, BestStar2};
        _ ->
            {Role, 0}
    end,
    
    %%军团目标监听
    role_listener:guild_dungeon(Role2, {}),
    Role3 = medal:listener(dungeon, Role2, {DungeonId, Count}),
    Role4 = role_listener:special_event(Role3, {2004, Count}),
    % Role5 = role_listener:special_event(Role4, {1071, finish}),
    Role5 = role_listener:ease_dungeon(Role4, {DungeonId, Count}),
    Role6 = role_listener:sweep_dungeon(Role5, {DungeonId, Count}),
    Role7 = role_listener:once_dungeon(Role6, {DungeonId, Count}),
    Role8 = 
     case is_hard(DungeonId) of 
        false -> role_listener:special_event(Role7, {3006, Count});    %% 触发日常 普通副本通关
        true ->  role_listener:special_event(Role7, {3007, Count})     %% 触发日常 困难副本通关
    end, 

    Role9 = role_listener:star_dungeon(Role8, {DungeonId, NewStar}),

    {ok, Role9}.

%% 获取副本结算时副本掉落
get_dungeon_drop(DungeonId, ClearCount, Career) ->
    ?DEBUG("获取副本掉落, 是否首通：~p~n", [ClearCount]),
    case ClearCount > 0 of 
        false ->
            case dungeon_drop_data:get_first_drop(DungeonId, Career) of 
                false ->
                    get_drop_randomly(DungeonId);
                [] ->
                    get_drop_randomly(DungeonId);
                Something ->
                    Something
            end;
        true ->
            get_drop_randomly(DungeonId)
    end.

get_drop_randomly(DungeonId) ->
    case dungeon_drop_data:get_drop(DungeonId) of 
        false -> [];
        Something ->
            Award = select_with_weight(Something),
            Award
    end.


make_gain_info([]) ->[];
make_gain_info(List) ->
    role_gain:merge_gains(make_gain_info(List, [])).

make_gain_info([], Ret) -> Ret;
make_gain_info([{Label, ItemBaseId, Num, _}|T], Ret) ->
    GainRecord = 
        case Label of
            fragile -> 
                #gain{label = fragile, val = [ItemBaseId, Num]};
            _ -> 
                #gain{label = item, val = [ItemBaseId, 0, Num]}
        end,
    make_gain_info(T, [GainRecord|Ret]).

notify_to_the_world(_, []) -> ok;
notify_to_the_world(Name, [{_, ItemBaseId, Num, Notify}|T]) ->
    case Notify of 
        0 ->
            notify_to_the_world(Name, T);
        1 ->
            RoleMsg = notice:role_to_msg(Name),
            ItemMsg = notice:item_msg({ItemBaseId, 0, Num}),
            role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"~s在副本中打出了~s，羡慕死人了!">>), [RoleMsg, ItemMsg])}),
            notify_to_the_world(Name, T)
    end.
    
%% --------------------------------------------------------------------
%% 内部函数
%% --------------------------------------------------------------------
unlock_next_dungeon(#role{pid = Pid, dungeon = RoleDungeons}, DungeonId) ->
    case dungeon_data:get(DungeonId) of
        #dungeon_base{show_type = ShowType} ->
            case ShowType =:= 0 orelse is_hard(DungeonId) of
                true ->
                    %%通关小副本或困难副本开启下一副本
                    NextDungeonId = DungeonId + 10,
                    case dungeon_data:get(NextDungeonId) of
                        #dungeon_base{} ->
                            unlock_dungeon(Pid, RoleDungeons, NextDungeonId);
                        _ ->
                            RoleDungeons
                    end;
                false ->
                    MapId = get_map_id(DungeonId),
                    #dungeon_map_base{last_normal_id = LastNormalId, first_hard_id = FirstHardId} = dungeon_data:map(MapId),
                    case LastNormalId =:= DungeonId of
                        true ->
                            %%每个地图最后一个普通本通关后开启该地图的第一个困难本
                            unlock_dungeon(Pid, RoleDungeons, FirstHardId);
                        false ->
                            RoleDungeons
                    end
            end;
        _ ->
            RoleDungeons
    end.

add_map_star(DungeonMap, DungeonId, Star) ->
    case dungeon_data:get(DungeonId) of
        #dungeon_base{show_type = 0} ->
            %%小副本星星不累加到地图上
            DungeonMap;
        _ ->
            MapId = get_map_id(DungeonId),
            case lists:keyfind(MapId, 1, DungeonMap) of
                false ->
                    DungeonMap;
                {_, Blue, Purple, BlueIsTaken, PurpleIsTaken, IsOpened} ->
                    case is_hard(DungeonId) of
                        true ->
                            lists:keyreplace(MapId, 1, DungeonMap, {MapId, Blue, Purple + Star, BlueIsTaken, PurpleIsTaken, IsOpened});
                        false ->
                            lists:keyreplace(MapId, 1, DungeonMap, {MapId, Blue + Star, Purple, BlueIsTaken, PurpleIsTaken, IsOpened})
                    end
            end
    end.

first_clear_dungeon(Role = #role{id = Rid, career = Career, pos = Pos}, DungeonId) ->
    Role1 = dress:first_clear_dungeon(DungeonId, Role),
    #dungeon_base{type = Type, args = Args, first_rewards = FirstRewards} = dungeon_data:get(DungeonId),
    Role2 = case lists:keyfind(Career, 1, FirstRewards) of
        {_, Gain} ->
            Gains = [Gain],
            case role_gain:do(Gains, Role1) of
                {ok, _Role} ->
                    _Role;
                _ ->
                    award:send(Rid, 104000, Gains),
                    Role1
            end;
        _ ->
            Role1
    end,
    case Args of 
        [MapBaseId, X, Y] ->
            case Type =:= ?dungeon_type_story orelse Type =:= ?dungeon_type_clear of 
                true ->
                    %%更新上一地图信息，目前用于剧情模式副本
                    Role2#role{pos = Pos#pos{last = {MapBaseId, X, Y}}};
                false ->
                    Role2
            end;
        _ ->
            Role2
    end.

get_proto_hard(#role_dungeon{id = Id, best_star = BestStar, reach_goals = ReachGoals, enter_count = EnterCount, paid_count = PaidCount, last = Last}) ->
    PaidCount2 = case Last >= util:unixtime({today, util:unixtime()}) of
        true ->
            PaidCount;
        false ->
            0
    end,
    {Id, BestStar, ReachGoals, dungeon_type:get_left_count(Id, EnterCount, PaidCount, Last), PaidCount2}.

select_with_weight([]) -> [];
select_with_weight(List) ->
    select_with_weight(List, []).

select_with_weight([], Ret) -> Ret;
select_with_weight([{Label, ItemBaseId, Num, Weight, Notify, EffectTime}|T], Ret) ->
    case check_effective(EffectTime) of
        ok ->
            Rand = util:rand(1, 10000),
            case Rand =< Weight of 
                true ->
                    select_with_weight(T, [{Label, ItemBaseId, Num, Notify}|Ret]);
                false -> 
                    select_with_weight(T, Ret)
            end;
        false ->
            select_with_weight(T, Ret)
    end.

check_effective([Start, End]) ->
    StartSeconds = util:datetime_to_seconds(Start),
    EndSeconds   = util:datetime_to_seconds(End),
    Now = util:unixtime(),
    case Now >= StartSeconds andalso Now =< EndSeconds of
        true -> 
            ok;
        false -> 
            false
    end;

check_effective(_) ->
    ok.
