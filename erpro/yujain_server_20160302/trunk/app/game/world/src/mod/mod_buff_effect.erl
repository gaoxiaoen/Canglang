%% Author: jiangxiaowei
%% Created:
%% Description:  BUFF效果实现
-module(mod_buff_effect).

%%
%% Include files
%%
-include("mgeew.hrl").
%%
%% Exported Functions
%%
-export([get_buff_attr/1]).

-export([add/3, del/3, trigger/3]).

%%
%% API Functions
%%
get_buff_attr(#r_buff{type = ?BUFF_EFFECT_ATTR, buff_id=BuffId}) ->
    [#r_buff_info{a = AttrKvList}] = cfg_buff:find(BuffId),
    AttrKvList;
get_buff_attr(_) ->
    [].

%% 此函数地图进程执行
add(ObjectId, ObjectType, BuffId) when erlang:is_integer(BuffId) ->
    [BuffInfo] = cfg_buff:find(BuffId),
    add(ObjectId, ObjectType, BuffInfo);
add(ObjectId, ?ACTOR_TYPE_MONSTER, #r_buff_info{type = ?BUFF_EFFECT_FANIT}) -> %% 怪物眩晕
    mod_fight:break_chant(ObjectId, ?ACTOR_TYPE_MONSTER),
    mod_map_monster:set_monster_effect_status(ObjectId, ?MONSTER_EFFECT_STATUS_FANIT),
    ok;
add(ObjectId, ObjectType, #r_buff_info{type = ?BUFF_EFFECT_FANIT}) -> %% 其他对象眩晕
    mod_fight:break_chant(ObjectId, ObjectType);

add(_ObjectId, _ObjectType, _BuffInfo) -> ok.

%% 此函数地图进程执行
del(ObjectId, ObjectType, BuffId) when erlang:is_integer(BuffId) ->
    [BuffInfo] = cfg_buff:find(BuffId),
    del(ObjectId, ObjectType, BuffInfo);
del(ObjectId, ?ACTOR_TYPE_MONSTER, #r_buff_info{type = ?BUFF_EFFECT_FANIT}) -> %% 移除怪物眩晕
    BuffList = mod_buff:get_object_buff(ObjectId, ?ACTOR_TYPE_MONSTER),
    case lists:keyfind(?BUFF_EFFECT_FANIT, #r_buff.type, BuffList) of
        false -> % 没有其他眩晕效果， 解除眩晕状态
            mod_map_monster:erase_monster_effect_status(ObjectId),
            ok;
        _ ->
            ignore
    end;
del(_ObjectId, _ObjectType, _BuffInfo) -> ok.

%% BUFF间隔触发效果处理
%% 此函数在地图进程执行
-spec
trigger(ObjectId, ObjectType, Buff) -> AttackResult when
    ObjectId :: role_id | pet_id | monster_id | integer(),
    ObjectType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER,
    Buff :: #r_buff{},
    AttackResult :: #p_attack_result_buff{} | undefined.
trigger(ObjectId, ObjectType, #r_buff{buff_id=BuffId,
                                      type=?BUFF_EFFECT_ADD_HP,
                                      skill_level=SkillLevelT}) -> %% 加血
    case mod_map:get_map_actor(ObjectId, ObjectType) of
        #r_map_actor{attr=#p_fight_attr{max_hp=MaxHp,hp=Hp}=Attr} = MapActor -> next;
        _ -> 
            MapActor = undefined,Attr = undefined,
            MaxHp = 0, Hp = 0
    end,
    case Hp > 0 andalso MapActor =/= undefined of
        true ->
            SkillLevel = erlang:max(1, SkillLevelT),
            [#r_buff_info{keep_value=KeepValue,a=Value}] = cfg_buff:find(BuffId),
            AddHp = erlang:trunc(KeepValue + SkillLevel * Value),
            CurHp = erlang:min(MaxHp, Hp + AddHp),
            NewAttr = Attr#p_fight_attr{hp=CurHp},
            NewMapActor = MapActor#r_map_actor{attr=NewAttr},
            mod_map:set_map_actor(ObjectId, ObjectType, NewMapActor),
            mod_fight_misc:update_actor_info_attr(ObjectId, ObjectType, NewAttr),
            #p_attack_result_buff{result_type=?EFFECT_ADD_HP,result_value=AddHp,buff_id=BuffId};
        _ ->
            undefined
    end;
trigger(_ObjectId, _ObjectType, _Buff) -> 
    undefined.
