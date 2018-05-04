%% Author: caochuncheng2002@gmail.com
%% Created: 2013-7-24
%% Description: GM命令处理
-module(mod_role_gm).

%%
%% Include files
%%
-include("mgeew.hrl").
%%
%% Exported Functions
%%
-export([
         handle/1
         ]).


handle({admin_add_exp,Info}) ->
    do_admin_add_exp(Info);

handle({admin_set_role_base_attr,Info}) ->
	do_admin_set_role_base_attr(Info);

handle({admin_set_role_level,Info}) ->
    do_admin_set_role_level(Info);

handle({admin_set_role_fight_attr,Info}) ->
    do_admin_set_role_fight_attr(Info);

handle(Info)->
    ?ERROR_MSG("receive unknown message,,Info=~w",[Info]).

%% GM命令 设置玩家等级
do_admin_set_role_level({RoleId,PRoleLevel}) ->
    {ok,#p_role_base{level = RoleLevel} = RoleBase} = mod_role:get_role_base(RoleId),
    case RoleLevel >= PRoleLevel of
        true ->
            ignroe;
        _ ->
            case cfg_role_level_exp:find(PRoleLevel + 1) of
                #r_level_exp{exp = NextLevelExp} ->
                    NewRoleBase = RoleBase#p_role_base{level = PRoleLevel,next_level_exp = NextLevelExp},
                    case common_transaction:t(
                           fun() -> 
                                   mod_role:t_set_role_base(RoleId, NewRoleBase),
                                   {ok}
                           end) of
                        {atomic, {ok}} ->
                            AttrList = [#p_attr{attr_code = ?ROLE_BASE_LEVEL,int_value = PRoleLevel},
                                        #p_attr{attr_code = ?ROLE_BASE_NEXT_LEVEL_EXP,int_value = NextLevelExp}],
                            common_misc:send_role_attr_change(RoleId, AttrList),
                            ?TRY_CATCH(hook_role:hook_role_level_up(RoleId, RoleLevel, PRoleLevel, NewRoleBase),LevelUpErr),
                            ok;
                        _ ->
                            next
                    end;
                _ ->
                    next
            end
    end,
    ok.
%% GM命令增加经验
do_admin_add_exp({RoleId,AddExp}) ->
    mod_role_bi:do_add_exp(RoleId, ?ADD_EXP_TYPE_GM, AddExp),
    ok.

%% 修改玩家基本属性值
do_admin_set_role_base_attr({RoleId,AttrIndex,Value}) ->
	case catch do_admin_set_role_base_attr2(RoleId,AttrIndex,Value) of
		{error,Error} ->
			?ERROR_MSG("GM Command exec fail,Error=~w",[Error]);
		{ok,NewRoleBase,AttrList,AddValue} ->
			do_admin_set_role_base_attr3(RoleId,AttrIndex,Value,
										 NewRoleBase,AttrList,AddValue)
	end.
do_admin_set_role_base_attr2(RoleId,AttrIndex,Value) ->
	case AttrIndex of
		#p_role_base.coin ->
			next;
		#p_role_base.gold ->
			next;
		#p_role_base.silver ->
			next;
        #p_role_base.energy ->
            next;
		_ ->
			erlang:throw({error,invalid_attr_index})
	end,
	case mod_role:get_role_base(RoleId) of
		{ok,RoleBase} ->
			next;
		_ ->
			RoleBase = undefined,
			erlang:throw({error,not_found_role_base})
	end,
	case AttrIndex of
		#p_role_base.coin ->
            AddValue = Value,
			AttrList=[#p_attr{attr_code=?ROLE_BASE_COIN,int_value=AddValue}],
			NewRoleBase = RoleBase#p_role_base{coin = AddValue};
		#p_role_base.gold ->
			AddValue = Value,
			AttrList=[#p_attr{attr_code=?ROLE_BASE_GOLD,int_value=AddValue},
					  #p_attr{attr_code=?ROLE_BASE_TOTAL_GOLD,int_value=AddValue}],
			NewRoleBase = RoleBase#p_role_base{gold = AddValue,
											   total_gold = AddValue};
		#p_role_base.silver ->
			AddValue = Value,
			AttrList=[#p_attr{attr_code=?ROLE_BASE_SILVER,int_value=AddValue}],
			NewRoleBase = RoleBase#p_role_base{silver =AddValue};
        #p_role_base.energy ->
            AddValue = Value,
            AttrList=[#p_attr{attr_code=?ROLE_BASE_ENERGY,int_value=AddValue}],
            NewRoleBase = RoleBase#p_role_base{energy =AddValue};
		_ ->
			AddValue = 0,
			AttrList=[],
			NewRoleBase = undefined,
			erlang:throw({error,invalid_attr_index})
	end,
	case AddValue < 0 of
		true ->
			erlang:throw({error,invalid_value});
		_ ->
			next
	end,
	{ok,NewRoleBase,AttrList,AddValue}.
do_admin_set_role_base_attr3(RoleId,_AttrIndex,_Value,
							 NewRoleBase,AttrList,_AddValue) ->
	case common_transaction:t(
		   fun() -> 
				   mod_role:t_set_role_base(RoleId, NewRoleBase),
				   {ok}
		   end) of
		{atomic, {ok}} ->
			common_misc:send_role_attr_change(RoleId, AttrList),
			ok;
		{aborted, Error} ->
			?ERROR_MSG("GM command exec fail,RoleId=~w,Error=~w",[RoleId,Error])
	end.

do_admin_set_role_fight_attr({RoleId,AttrIndex,Value}) ->
    case catch do_admin_set_role_fight_attr2(RoleId,AttrIndex,Value) of
        {error,Error} ->
            ?ERROR_MSG("GM Command exec fail,Error=~w",[Error]);
        {ok} ->
            ok
    end.
do_admin_set_role_fight_attr2(RoleId,AttrIndex,Value) ->
    case AttrIndex of
        #p_fight_attr.hp ->
            next;
        #p_fight_attr.mp ->
            next;
        #p_fight_attr.anger ->
            next;
        _ ->
            erlang:throw({error,invalid_attr_index})
    end,
    case mod_role:get_role_attr(RoleId) of
        {ok,RoleAttr} ->
            next;
        _ ->
            RoleAttr = undefined,
            erlang:throw({error,not_found_role_attr})
    end,
    #p_role_attr{attr=FightAttr} = RoleAttr,
    #p_fight_attr{max_hp=MaxHp,hp=Hp,max_mp=MaxMp,mp=Mp,max_anger=MaxAnger,anger=Anger} = FightAttr,
    case AttrIndex of
        #p_fight_attr.hp ->
            CurHp = erlang:min(MaxHp, Value),
            CurMp = Mp,CurAnger=Anger;
        #p_fight_attr.mp ->
            CurMp = erlang:min(MaxMp, Value),
            CurHp = Hp,CurAnger=Anger;
        #p_fight_attr.anger ->
            CurHp = Hp,
            CurMp = Mp,
            CurAnger = erlang:min(MaxAnger, Value)
    end,
    AttrList = [{#p_fight_attr.hp,CurHp},{#p_fight_attr.mp,CurMp},{#p_fight_attr.anger,CurAnger}],
    Info = {mod,mod_map_role,{sync,{RoleId,?ACTOR_TYPE_ROLE,AttrList}}},
    common_misc:send_to_role_map(RoleId, Info),
    ok.

