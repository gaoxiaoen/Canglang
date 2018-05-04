%%%-------------------------------------------------------------------
%%% @author jiangxiaowei
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 十月 2015 11:04
%%%-------------------------------------------------------------------
-module(mod_fight_misc).

-include("mgeem.hrl").

%% API
-export([reduce_hp/2, 
         reduce_mp/2, 
         add_hp/2, 
         add_mp/2,
         reduce_anger/2,
         
         get_map_actor_pos/1, get_map_actor_pos/2,
         get_map_actor_groupid/1, get_map_actor_groupid/2,
         
         update_actor_info_attr/3,
         update_actor_info_skill_state/3]).

-export([calc_skill_consume_mp/2,
         calc_skill_consume_mp/3]).

%% @doc 扣血
reduce_hp(ReduceHp, #p_fight_attr{hp = Hp, max_hp = MaxHp, anger = Anger, max_anger = MaxAnger} = FightAttr) ->
    NewHp = max(0, Hp - ReduceHp),
    case NewHp =< 0 of
        true -> %%死亡
            FightAttr#p_fight_attr{hp = 0, anger = 0};
        false ->
            %% 伤害自动回怒气
            AddAnger = mod_fight_calculate:hurt_anger(ReduceHp, MaxHp),
            FightAttr#p_fight_attr{hp = NewHp, anger = min(MaxAnger, Anger + AddAnger)}
    end.

%% @doc 加血
add_hp(AddHp, #p_fight_attr{hp = Hp, max_hp = MaxHp} = FightAttr) ->
    FightAttr#p_fight_attr{hp = min(MaxHp, Hp + AddHp)}.

%% @doc 扣蓝
reduce_mp(0, FightAttr) ->
    FightAttr;
reduce_mp(ReduceMp, #p_fight_attr{mp = Mp} = FightAttr) ->
    NewMp = max(0, Mp - ReduceMp),
    FightAttr#p_fight_attr{mp = NewMp}.

%% @doc 加蓝
add_mp(AddMp, #p_fight_attr{mp = Mp, max_mp = MaxMp} = FightAttr) ->
    FightAttr#p_fight_attr{mp = min(MaxMp, Mp + AddMp)}.

%% @doc 扣怒
reduce_anger(0,FightAttr) ->
    FightAttr;
reduce_anger(ReduceAnger,#p_fight_attr{anger=Anger}=FightAttr) ->
    NewAnger = max(0, Anger - ReduceAnger),
    FightAttr#p_fight_attr{anger = NewAnger}.

%% @doc 获取对象坐标点
get_map_actor_pos(#r_map_actor{actor_id = ActorId, actor_type = ActorType}) ->
    get_map_actor_pos(ActorId, ActorType).
get_map_actor_pos(ActorId, ActorType) ->
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{pos = Pos} -> Pos;
        #p_map_monster{pos = Pos} -> Pos;
        #p_map_pet{pos = Pos} -> Pos
    end.


get_map_actor_groupid(#r_map_actor{actor_id = ActorId, actor_type = ActorType}) ->
    get_map_actor_groupid(ActorId, ActorType).
get_map_actor_groupid(ActorId, ActorType) ->
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{group_id = GroupId} -> GroupId;
        #p_map_monster{group_id = GroupId} -> GroupId;
        #p_map_pet{group_id = GroupId} -> GroupId
    end.

update_actor_info_attr(ActorId, ActorType, #p_fight_attr{hp = Hp}) ->
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{} = Role -> mod_map:set_actor_info(ActorId, ActorType, Role#p_map_role{hp = Hp});
        #p_map_monster{} = Monster -> mod_map:set_actor_info(ActorId, ActorType, Monster#p_map_monster{hp = Hp});
        #p_map_pet{} = Pet -> mod_map:set_actor_info(ActorId, ActorType, Pet#p_map_pet{hp = Hp});
        undefined -> ignore
    end.

update_actor_info_skill_state(ActorId, ActorType, NewSkillState) ->
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{} = Role -> mod_map:set_actor_info(ActorId, ActorType, Role#p_map_role{skill_state=NewSkillState});
        #p_map_monster{} = Monster -> mod_map:set_actor_info(ActorId, ActorType, Monster#p_map_monster{skill_state=NewSkillState});
        #p_map_pet{} = Pet -> mod_map:set_actor_info(ActorId, ActorType, Pet#p_map_pet{skill_state=NewSkillState});
        undefined -> ignore
    end.


%% 计算技能消耗的魔法值
%% SkillId 技能id
%% SkillLevel 技能等级
-spec
calc_skill_consume_mp(SkillId,SkillLevel) -> ConsumeMp when
    SkillId :: skill_id,
    SkillLevel :: skill_level,
    ConsumeMp :: integer.
calc_skill_consume_mp(SkillId,SkillLevel) ->
    case cfg_skill:find(SkillId) of
        [] ->
            0;
        [#r_skill_info{consume_mp = ConsumeMp, consume_mp_index = ConsumeMpIndex}] ->
            ConsumeMp + erlang:trunc(ConsumeMpIndex * SkillLevel)
    end.
calc_skill_consume_mp(_SkillId,SkillLevel,SkillInfo) ->
    #r_skill_info{consume_mp = ConsumeMp, consume_mp_index = ConsumeMpIndex} = SkillInfo,
    ConsumeMp + erlang:trunc(ConsumeMpIndex * SkillLevel).
