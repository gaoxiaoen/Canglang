%% Author: caochuncheng2002@gmail.com
%% Created: 2013-5-13
%% Description: 玩家模块功能处理
-module(mod_role).

-include("mgeew.hrl").

%% 缓存在进程字典的数据操作
-export([
         init_dict/2,
         get_dict/1,
         get_dict_with_init/2,
         set_dict/2,
         t_set_dict/2,
         erase_dict/2,
         dump_dict/2
        ]).
%% 缓存在ETS公开表的数据操作
-export([
         init_ets/2,
         get_ets/1,
         get_ets_with_init/2,
         set_ets/2,
         t_set_ets/2,
         erase_ets/1,
         dump_ets/2,
         
         init_role_base/2,
         get_role_base/1,
         t_set_role_base/2,
         set_role_base/2,
         
         init_role_attr/2,
         get_role_attr/1,
         t_set_role_attr/2,
         set_role_attr/2,

         init_role_skill/2,
         get_role_skill/1,
         t_set_role_skill/2,
         set_role_skill/2,
         
         init_role_buff/1,
         dump_role_buff/1,
         
         init_role_pos/2,
         get_role_pos/1,
         set_role_pos/2,
		 t_set_role_pos/2,
         
         init_role_state/2,
         get_role_state/1,
         set_role_state/2,
         
         init_role_equip/2,
         get_role_equip/1,
         set_role_equip/2,
         get_role_activate_equip/1
         ]).

%% Dict 通用接口
init_dict(Key,Value) ->
    erlang:put(Key, Value).
get_dict(Key) ->
    case erlang:get(Key) of
        undefined ->
            {error, not_found};
        Value ->
            {ok, Value}
    end.

%% return {ok,Value}|{error,not_found}
get_dict_with_init(Tab,Key)->
    case get_dict({Tab,Key}) of
        {ok,Value}->
            {ok,Value};
        _->
            case db_api:dirty_read(Tab,Key) of
                [Value]->
                    erlang:put({Tab,Key}, Value),
                    {ok,Value};
                _->
                    {error,not_found}
            end
    end.

t_set_dict(Key,Value) ->
    common_transaction:set_transaction(Key),
    erlang:put(Key, Value).

set_dict(Key,Value)->
    erlang:put(Key, Value).

dump_dict(Key,Tab)->
    case get_dict(Key) of
        {ok,Value}->
            db_api:dirty_write(Tab,Value);
        _->
            ignore
    end.

erase_dict(Key,Tab) ->
    case get_dict(Key) of
        {ok,Value}->
            db_api:dirty_write(Tab,Value),
            erlang:erase(Key);
        _->
            ignore
    end.


%% ets 通用接口
init_ets(Key,Value) ->
    common_role:set_role_dict(Key, Value).
get_ets(Key) ->
    case common_role:get_role_dict(Key) of
        undefined ->
            {error, not_found};
        Value ->
            {ok, Value}
    end.

get_ets_with_init(Tab,Key)->
    case get_ets({Tab,Key}) of
        {ok,Value}->
            {ok,Value};
        _->
            case db_api:dirty_read(Tab,Key) of
                [Value]->
                    set_ets({Tab,Key}, Value),
                    {ok,Value};
                _->
                    {error,not_found}
            end
    end.


t_set_ets(Key,Value) ->
    common_role:set_transaction(Key),
    common_role:set_role_dict(Key, Value).

set_ets(Key,Value)->
    common_role:set_role_dict(Key, Value).
    
erase_ets(Key) ->
    common_role:erase_role_dict(Key).

dump_ets(Key,Tab) ->
    case get_ets(Key) of
        {ok,Value}->
            db_api:dirty_write(Tab,Value);
        _->
            ignore
    end.


%% 角色基本信息
init_role_base(RoleId,RoleBase) ->
    set_ets({?DB_ROLE_BASE, RoleId}, RoleBase).
get_role_base(RoleId) ->
    get_ets({?DB_ROLE_BASE, RoleId}).
t_set_role_base(RoleId,RoleBase) ->
    t_set_ets({?DB_ROLE_BASE, RoleId}, RoleBase).
set_role_base(RoleId,RoleBase)->
    set_ets({?DB_ROLE_BASE, RoleId}, RoleBase).

%% 角色属性信息
init_role_attr(RoleId,RoleAttr) ->
    set_ets({?DB_ROLE_ATTR, RoleId}, RoleAttr).
get_role_attr(RoleId) ->
    get_ets({?DB_ROLE_ATTR, RoleId}).
t_set_role_attr(RoleId,RoleAttr) ->
    t_set_ets({?DB_ROLE_ATTR, RoleId}, RoleAttr).
set_role_attr(RoleId,RoleAttr) ->
    set_ets({?DB_ROLE_ATTR, RoleId}, RoleAttr).

%% 角色技能
init_role_skill(RoleId,RoleSkill) ->
    set_dict({?DB_ROLE_SKILL, RoleId}, RoleSkill).
get_role_skill(RoleId) ->
    get_dict({?DB_ROLE_SKILL, RoleId}).
t_set_role_skill(RoleId,RoleSkill) ->
    t_set_dict({?DB_ROLE_SKILL, RoleId}, RoleSkill).
set_role_skill(RoleId,RoleSkill) ->
    set_dict({?DB_ROLE_SKILL, RoleId}, RoleSkill).

%% 角色BUFF
init_role_buff(RoleId) ->
    case db_api:dirty_read(?DB_ROLE_BUFF, RoleId) of
        [RoleBuff] ->
            #r_role_buff{buff_list=BuffList} = RoleBuff,
            NewBuffList = mod_buff:init_object_buff(RoleId, ?ACTOR_TYPE_ROLE, BuffList),
            db_api:dirty_write(?DB_ROLE_BUFF, #r_role_buff{role_id=RoleId,buff_list=NewBuffList}),
            ok;
        _ ->
            next
    end,
    ok.
dump_role_buff(RoleId) ->
    BuffList =  mod_buff:get_object_buff(RoleId, ?ACTOR_TYPE_ROLE),
    db_api:dirty_write(?DB_ROLE_BUFF, #r_role_buff{role_id=RoleId,buff_list=BuffList}).      

%% 角色位置信息
init_role_pos(RoleId,RolePos) ->
    set_ets({?DB_ROLE_POS,RoleId}, RolePos).
get_role_pos(RoleId) ->
    get_ets({?DB_ROLE_POS,RoleId}).
set_role_pos(RoleId,RolePos) ->
    set_ets({?DB_ROLE_POS,RoleId}, RolePos).
t_set_role_pos(RoleId,RolePos) ->
    t_set_ets({?DB_ROLE_POS,RoleId}, RolePos).

%% 角色状态信息
init_role_state(RoleId,RoleState) ->
    set_ets({?DB_ROLE_STATE, RoleId}, RoleState).
get_role_state(RoleId) ->
    get_ets({?DB_ROLE_STATE, RoleId}).
set_role_state(RoleId,RoleState) ->
    set_ets({?DB_ROLE_STATE, RoleId}, RoleState).

%% 角色装备信息
init_role_equip(RoleId,RoleEquip) ->
    set_dict({?DB_ROLE_EQUIP, RoleId}, RoleEquip).
get_role_equip(RoleId) ->
    get_dict({?DB_ROLE_EQUIP, RoleId}).
set_role_equip(RoleId,RoleEquip) ->
    set_dict({?DB_ROLE_EQUIP, RoleId}, RoleEquip).

get_role_activate_equip(RoleId) ->
    case get_role_equip(RoleId) of
        {ok,#r_role_equip{suit_id=1}=RoleEquip} ->
            {ok,RoleEquip#r_role_equip.equip_a_list};
        {ok,#r_role_equip{suit_id=2}=RoleEquip} ->
            {ok,RoleEquip#r_role_equip.equip_b_list};
        {ok,#r_role_equip{suit_id=3}=RoleEquip} ->
            {ok,RoleEquip#r_role_equip.equip_c_list};
        {error,Reason} ->
            {error,Reason}
    end.
        



    
