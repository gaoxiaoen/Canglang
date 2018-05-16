%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 十一月 2017 11:55
%%%-------------------------------------------------------------------
-module(pet_effect).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("pet.hrl").
-include("pet_war.hrl").
-include("battle.hrl").
-include("skill.hrl").

%% API
-export([
    add_effect/3,
    active/1,
    active/4,
    last_active/1,
    last_active/4
]).

%%添加效果
add_effect(BS, [], _skillid) -> BS;
add_effect(BS, EffList, SkillId) ->
    NewEffList = BS#bs.eff_list ++ prepare(EffList, SkillId, [], #attacker{}),
    BS#bs{eff_list = NewEffList}.

%%转换效果列表
prepare([], _SkillId, Efflist, _Attacker) -> Efflist;
prepare([{Effid, Target, Args} | L], SkillId, EffList, Attacker) ->
    prepare(L, SkillId, [#eff{key = {SkillId, Effid}, effid = Effid, args = Args, target = Target, attacker = Attacker} | EffList], Attacker).

%%效果生效
active(Bs) ->
    {NewBs, _, _, _} = active(Bs, [], [], []),
    NewBs.

active(Aer, AerList, DerList, TargetDerList) ->
    active(Aer#bs{eff_list = []}, AerList, DerList, TargetDerList, Aer#bs.eff_list).

active(Aer, AerList, DerList, TargetDerList, []) ->
    {Aer, AerList, DerList, TargetDerList};
active(Aer, AerList, DerList, TargetDerList, [Eff | EffectList]) ->
    {NewAer, NewAerList, NewDerList, NewTargetDerList} = eff(Eff, Aer, AerList, DerList, TargetDerList),
    active(NewAer, NewAerList, NewDerList, NewTargetDerList, EffectList).

%%出手后效果生效
last_active(Bs) ->
    {NewBs, _, _, _} = last_active(Bs, [], [], []),
    NewBs.
last_active(Aer, AerList, DerList, TargetDerList) ->
    last_active(Aer#bs{last_eff_list = []}, AerList, DerList, TargetDerList, Aer#bs.last_eff_list).

last_active(Aer, AerList, DerList, TargetDerList, []) ->
    {Aer, AerList, DerList, TargetDerList};
last_active(Aer, AerList, DerList, TargetDerList, [Eff | EffectList]) ->
    {NewAer, NewAerList, NewDerList, NewTargetDerList} = last_eff(Eff, Aer, AerList, DerList, TargetDerList),
    last_active(NewAer, NewAerList, NewDerList, NewTargetDerList, EffectList).

%%效果解析
%% N%概率获得buffid
eff(#eff{effid = 11035, key = Key, target = Target, args = Args}, Aer, AerList, DerList, TargetDerList) ->
    [Ratio | BuffidList] = Args,
    {SkillId, _EffID} = Key,
    case util:odds(Ratio * 100, 100) of
        true ->
            case Target of
                ?TARGET_ATT ->
                    [NewAer] = pet_buff:add_buff([Aer], BuffidList, SkillId),
                    {NewAer, AerList, DerList, TargetDerList};
                ?TARGET_DEF ->
                    NewTargetDerList = pet_buff:add_buff(TargetDerList, BuffidList, SkillId),
                    {Aer, AerList, DerList, NewTargetDerList};
                ?TARGET_TEAM ->
                    if
                        Aer#bs.war_sign == ?TEAM1 ->
                            NewAerList = pet_buff:add_buff(AerList, BuffidList, SkillId),
                            NewAer = lists:keyfind(Aer#bs.key, #bs.key, NewAerList),
                            {NewAer, NewAerList, DerList, TargetDerList};
                        true ->
                            NewDerList = pet_buff:add_buff(DerList, BuffidList, SkillId),
                            NewAer = lists:keyfind(Aer#bs.key, #bs.key, NewDerList),
                            {NewAer, AerList, NewDerList, TargetDerList}
                    end;
                _ ->
                    {Aer, AerList, DerList, TargetDerList}
            end;
        false ->
            {Aer, AerList, DerList, TargetDerList}
    end;

%% 眩晕，概率触发， 持续N回合
eff(#eff{effid = 20201, target = Target, args = Args}, Aer, AerList, DerList, TargetDerList) ->
    [Ratio, Round] = Args,
    case util:odds(Ratio * 100, 100) of
        true ->
            case Target of
                ?TARGET_ATT ->
                    EffArgs = Aer#bs.eff_args,
                    NewAer =
                        Aer#bs{
                            eff_args = EffArgs#eff_args{dizzy = Round},
                            state_list = [?STATE_DIZZZY | Aer#bs.state_list]
                        },
                    {NewAer, AerList, DerList, TargetDerList};
                _ ->
                    {Aer, AerList, DerList, TargetDerList}
            end;
        false ->
            {Aer, AerList, DerList, TargetDerList}
    end;

%% 灼烧，每回合造成生命值X伤害，持续N回合
eff(#eff{effid = 20101, target = Target, args = Args}, Aer, AerList, DerList, TargetDerList) ->
    [Precent, Round] = Args,
    case Target of
        ?TARGET_ATT ->
            EffArgs = Aer#bs.eff_args,
            NewAer =
                Aer#bs{
                    eff_args = EffArgs#eff_args{fire_add = Precent, fire_add_round = Round},
                    state_list = [?STATE_FIRING | Aer#bs.state_list]
                },
            {NewAer, AerList, DerList, TargetDerList};
        ?TARGET_DEF ->
            F = fun(Bs) ->
                EffArgs = Aer#bs.eff_args,
                Bs#bs{
                    eff_args = EffArgs#eff_args{fire_add = Precent, fire_add_round = Round},
                    state_list = [?STATE_DIZZZY | Bs#bs.state_list]
                }
            end,
            NewTargetDerList = lists:map(F, TargetDerList),
            {Aer, AerList, DerList, NewTargetDerList};
        _ ->
            {Aer, AerList, DerList, TargetDerList}
    end;

%% 灼烧加成，每回合造成生命值X%伤害，持续N回合
eff(#eff{effid = 20102, target = Target, args = Args}, Aer, AerList, DerList, TargetDerList) ->
    [Precent, Round] = Args,
    case Target of
        ?TARGET_ATT ->
            EffArgs = Aer#bs.eff_args,
            NewAer =
                Aer#bs{
                    eff_args = EffArgs#eff_args{fire_add_p = Precent, fire_add_p_round = Round},
                    state_list = [?STATE_FIRING_P | Aer#bs.state_list]
                },
            {NewAer, AerList, DerList, TargetDerList};
        ?TARGET_DEF ->
            F = fun(Bs) ->
                EffArgs = Aer#bs.eff_args,
                Bs#bs{
                    eff_args = EffArgs#eff_args{fire_add_p = Precent, fire_add_p_round = Round},
                    state_list = [?STATE_FIRING_P | Aer#bs.state_list]
                }
            end,
            NewTargetDerList = lists:map(F, TargetDerList),
            {Aer, AerList, DerList, NewTargetDerList};
        _ ->
            {Aer, AerList, DerList, TargetDerList}
    end;

eff(Eff, Aer, AerList, DerList, TargetDerList) ->
    %% 剩下的效果，都是当前出手后触发
    {Aer#bs{last_eff_list = [Eff | Aer#bs.last_eff_list]}, AerList, DerList, TargetDerList}.

%% 易伤，每回合造成生命值X伤害，持续N回合
last_eff(#eff{effid = 20301, target = Target, args = Args}, Aer, AerList, DerList, TargetDerList) ->
    [BaseHurt, Round] = Args,
    case Target of
        ?TARGET_ATT ->
            EffArgs = Aer#bs.eff_args,
            NewAer =
                Aer#bs{
                    eff_args = EffArgs#eff_args{easy_hurt = BaseHurt, easy_hurt_round = Round},
                    state_list = [?STATE_EASY | Aer#bs.state_list]
                },
            {NewAer, AerList, DerList, TargetDerList};
        ?TARGET_DEF ->
            F = fun(Bs) ->
                EffArgs = Aer#bs.eff_args,
                Bs#bs{
                    eff_args = EffArgs#eff_args{easy_hurt = BaseHurt, easy_hurt_round = Round},
                    state_list = [?STATE_EASY | Aer#bs.state_list]
                }
            end,
            NewTargetDerList = lists:map(F, TargetDerList),
            {Aer, AerList, DerList, NewTargetDerList};
        _ ->
            {Aer, AerList, DerList, TargetDerList}
    end;

%% 易伤加成，每回合造成生命值X%伤害，持续N回合
last_eff(#eff{effid = 20302, target = Target, args = Args}, Aer, AerList, DerList, TargetDerList) ->
    [Percent, Round] = Args,
    case Target of
        ?TARGET_ATT ->
            EffArgs = Aer#bs.eff_args,
            NewAer =
                Aer#bs{
                    eff_args = EffArgs#eff_args{easy_hurt_p = Percent, easy_hurt_p_round = Round},
                    state_list = [?STATE_EASY_P | Aer#bs.state_list]
                },
            {NewAer, AerList, DerList, TargetDerList};
        ?TARGET_DEF ->
            F = fun(Bs) ->
                EffArgs = Aer#bs.eff_args,
                Bs#bs{
                    eff_args = EffArgs#eff_args{easy_hurt_p = Percent, easy_hurt_p_round = Round},
                    state_list = [?STATE_EASY_P | Aer#bs.state_list]
                }
            end,
            NewTargetDerList = lists:map(F, TargetDerList),
            {Aer, AerList, DerList, NewTargetDerList};
        _ ->
            {Aer, AerList, DerList, TargetDerList}
    end;

%% 增伤加成，每回合造成生命值X%伤害，持续N回合
last_eff(#eff{effid = 20401, target = Target, args = Args}, Aer, AerList, DerList, TargetDerList) ->
    [Percent, Round] = Args,
    case Target of
        ?TARGET_ATT ->
            EffArgs = Aer#bs.eff_args,
            NewAer =
                Aer#bs{
                    eff_args = EffArgs#eff_args{add_hurt_p = Percent, add_hurt_p_round = Round},
                    state_list = [?STATE_ADD_HURT | Aer#bs.state_list]
                },
            {NewAer, AerList, DerList, TargetDerList};
        ?TARGET_DEF ->
            F = fun(Bs) ->
                EffArgs = Aer#bs.eff_args,
                Bs#bs{
                    eff_args = EffArgs#eff_args{add_hurt_p = Percent, add_hurt_p_round = Round},
                    state_list = [?STATE_ADD_HURT | Aer#bs.state_list]
                }
            end,
            NewTargetDerList = lists:map(F, TargetDerList),
            {Aer, AerList, DerList, NewTargetDerList};
        _ ->
            {Aer, AerList, DerList, TargetDerList}
    end;

last_eff(Eff, Aer, AerList, DerList, TargetDerList) ->
    ?ERR("Eff:~p", [Eff]),
    {Aer, AerList, DerList, TargetDerList}.