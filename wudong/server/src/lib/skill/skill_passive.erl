%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%     被动技能
%%% @end
%%% Created : 22. 十一月 2016 19:54
%%%-------------------------------------------------------------------
-module(skill_passive).
-author("hxming").
-include("battle.hrl").
-include("skill.hrl").
-include("common.hrl").

%% API
-compile(export_all).

%%攻击方触发
activate_passive_skill_att(Aer, Der) ->
    if Aer#bs.sign == ?SIGN_PLAYER andalso Der#bs.actor == ?ACTOR_DEF ->
        case filter_passive_skill(Aer, Der, Aer#bs.passive_skill, [0, 1]) of
            false ->
                {Aer, Der};
            {Aer1, Skill} ->
                if Skill#skill.passive_type == ?PASSIVE_SKILL_TYPE_DVIP ->
                    Der1 = use_passive_skill(Der, Skill, false),
                    {Aer1, Der1};
                    true ->
                        Aer2 = use_passive_skill(Aer1, Skill, true),
                        {Aer2, Der}
                end

        end;
        true ->
            {Aer, Der}
    end.

%%被击方触发
activate_passive_skill_def(Der, Aer) when Der#bs.sign == ?SIGN_PLAYER ->
    case filter_passive_skill(Der, Aer, Der#bs.passive_skill, [2]) of
        false ->
            Der;
        {Der1, Skill} ->
            Der2 = use_passive_skill(Der1, Skill, true),
            Der2
    end;
activate_passive_skill_def(Der, _Aer) -> Der.


%%使用被动技能
use_passive_skill(BS, Skill, IsNotice) ->
    ?DO_IF(IsNotice, passive_skill_msg(BS, Skill)),
    BS1 = effect:add_effect(BS, Skill#skill.efflist, Skill#skill.skillid, 1),
    BuffList = Skill#skill.bufflist,
    {BS2, AddBuffList} = buff:skill_add_buff(BS1, BuffList, Skill#skill.skillid, Skill#skill.lv),
    BS3 = buff:buff_to_eff(BS2, AddBuffList),
    BS3.

%%被动技能触发通知
passive_skill_msg(BS, Skill) ->
    if BS#bs.sign == ?SIGN_PLAYER ->
        {ok, Bin} = pt_200:write(20019, {Skill#skill.passive_type, Skill#skill.skillid}),
        server_send:send_to_pid(BS#bs.pid,Bin);
%%        server_send:rpc_node_apply(BS#bs.node, server_send, send_to_pid, [BS#bs.pid, Bin]);
        true -> ok
    end.


%%过滤被动技能
filter_passive_skill(Aer, Der, SkillList, SubtypeList) ->
    Now = Aer#bs.now,
    F = fun({SkillId, Type}) ->
        case data_skill:get(SkillId) of
            [] -> [];
            Skill ->
                case lists:member(Skill#skill.subtype, SubtypeList) of
                    true ->
                        case lists:keyfind(SkillId, 1, Aer#bs.skill_cd) of
                            false ->
                                Condition = data_skill_normal:get(SkillId),
                                case check_passive_skill_condition(Condition, [], Aer, Der) of
                                    false -> [];
                                    true -> [Skill#skill{passive_type = Type}]
                                end;
                            {_, Cd} ->
                                if Cd >= Now -> [];
                                    true ->

                                        Condition = data_skill_normal:get(SkillId),
                                        case check_passive_skill_condition(Condition, [], Aer, Der) of
                                            false -> [];
                                            true -> [Skill#skill{passive_type = Type}]
                                        end
                                end
                        end;
                    false -> []
                end
        end
        end,
    case lists:flatmap(F, SkillList) of
        [] -> false;
        Skills ->
            Skill = util:list_rand(Skills),
            SkillCd = [{Skill#skill.skillid, Skill#skill.cd + Now} | lists:keydelete(Skill#skill.skillid, 1, Aer#bs.new_skill_cd)],
            {Aer#bs{new_skill_cd = SkillCd}, Skill}
    end.

%%被动技能触发条件计算
check_passive_skill_condition([], BoolList, _Aer, _Der) ->
    case BoolList of
        [] -> true;
        _ ->
            F = fun(Item) -> Item == true end,
            lists:all(F, BoolList)
    end;
check_passive_skill_condition([Item | T], BoolList, Aer, Der) ->
    case Item of
        {1, Operation, Value} ->
            Result =
                case Operation of
                    ">" -> trunc(Aer#bs.hp / Aer#bs.hp_lim * 100) > Value;
                    "<" -> trunc(Aer#bs.hp / Aer#bs.hp_lim * 100) < Value;
                    "==" -> trunc(Aer#bs.hp / Aer#bs.hp_lim * 100) == Value;
                    _ -> false
                end,
            check_passive_skill_condition(T, [Result | BoolList], Aer, Der);
        {2, Operation, Value} ->
            Result =
                case Operation of
                    ">" -> trunc(Der#bs.hp / Der#bs.hp_lim * 100) > Value;
                    "<" -> trunc(Der#bs.hp / Der#bs.hp_lim * 100) < Value;
                    "==" -> trunc(Der#bs.hp / Der#bs.hp_lim * 100) == Value;
                    _ -> false
                end,
            check_passive_skill_condition(T, [Result | BoolList], Aer, Der);
        {3, Value} ->
            case util:rand(1, 100) < Value of
                true ->
                    check_passive_skill_condition(T, [true | BoolList], Aer, Der);
                false ->
                    check_passive_skill_condition(T, [false | BoolList], Aer, Der)
            end;
        {4, Operation} ->
            Result =
                case Operation of
                    ">" -> Aer#bs.speed > Aer#bs.base_speed;
                    "<" -> Aer#bs.speed < Aer#bs.base_speed;
                    "==" -> Aer#bs.speed == Aer#bs.base_speed;
                    _ -> false
                end,
            check_passive_skill_condition(T, [Result | BoolList], Aer, Der);
        {5, Operation} ->
            Result =
                case Operation of
                    ">" -> Der#bs.speed > Der#bs.base_speed;
                    "<" -> Der#bs.speed < Der#bs.base_speed;
                    "==" -> Der#bs.speed == Der#bs.base_speed;
                    _ -> false
                end,
            check_passive_skill_condition(T, [Result | BoolList], Aer, Der);
        _ ->
            check_passive_skill_condition(T, BoolList, Aer, Der)
    end.
