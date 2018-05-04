-module(leisure_ai_rule).
-export([
		  handle_type/3
		, handle_con_target/4
		, handle_con_rela/5
		, handle_con_count/2
		, can_verity/2
		, gen_scene/2
		, can_action/1
		, get_rand_action/2
		, pre_process/1
		]).


-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("combat.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("attr.hrl").
-include("npc.hrl").
-include("map.hrl").
-include("leisure.hrl").


%% @spec handle_con_target(TargetKey, SuitTar, Npc, Scene) -> Result
%% TargetKey = atom()
%% SuitTar = []
%% Npc = #fighter{} | #npc{}
%% Scene = #combat_scene 
%% Result = #fighter{} | #npc{}
%% 处理条件目标
handle_con_target(self, _SuitTar, Npc, Scene) when is_record(Npc, fighter) and is_record(Scene, combat_scene)->
    [Npc];
handle_con_target(combat, _SuitTar, Npc, Scene) when is_record(Npc, fighter) and is_record(Scene, combat_scene)->
    [Scene];
handle_con_target(self_side, _SuitTar, Npc, _Scene = #combat_scene{self_side = SelfSide}) when is_record(Npc, fighter) ->
    SelfSide;
handle_con_target(opp_side, _SuitTar, Npc, _Scene = #combat_scene{opp_side = OppSide}) when is_record(Npc, fighter) ->
    OppSide;
% handle_con_target(suit_tar, SuitTar, Npc, _Scene = #combat_scene{}) when is_record(Npc, fighter) ->
%     SuitTar;


handle_con_target(_ConTarget, _SuitTar, _Npc, Scene) ->
    [Scene].

%% @spec handle_con_rela(Targets, Key, Rela, Value) -> Result
%% Targets = is_list()
%% Key = atom()
%% Rela = bitstring()
%% Value = term()
%% Result = []
%% 处理比较
handle_con_rela(Targets, Key, Rela, Value, {_Self, _Scene}) ->
    handle_con_rela(Targets, Key, Rela, Value, [], {_Self, _Scene}).

handle_con_rela(_Targets = [], _Key, _Rela, _Value, Back, {_Self, _Scene}) ->
    Back;
handle_con_rela(_Targets = [H | T], Key, Rela, Value, Back, {Self, Scene}) ->
    case handle_con_compare(Rela, handle_con_key(Key, H), handle_con_value(Value, {Self, Scene})) of
        true ->
            handle_con_rela(T, Key, Rela, Value, [H | Back], {Self, Scene});
        false ->
            handle_con_rela(T, Key, Rela, Value, Back, {Self, Scene})
    end.


%% @spec handle_con_compare(Rela, Left, Right) -> true | false
%% Rela = binary()
%% Left = Right = term()
%% 比较
handle_con_compare(<<"<">>, Left, Right) ->
    Left < Right;
handle_con_compare(<<"=">>, Left, Right) ->
    Left == Right;
handle_con_compare(<<">">>, Left, Right) ->
    Left > Right;
handle_con_compare(<<">=">>, Left, Right) ->
    Left >= Right;
handle_con_compare(<<"<=">>, Left, Right) ->
    Left =< Right;
% handle_con_compare(<<"include">>, Left, Right) when is_list(Left) ->
%     lists:member(Right, Left);
% handle_con_compare(<<"not_in">>, Left, Right) when is_list(Left) ->
%     not lists:member(Right, Left);
handle_con_compare(<<"mod2">>, Left, Right) ->
    Left rem 2 =:= Right;
handle_con_compare(<<"mod3">>, Left, Right) ->
    Left rem 3 =:= Right;
handle_con_compare(<<"mod4">>, Left, Right) ->
    Left rem 4 =:= Right;
handle_con_compare(<<"mod5">>, Left, Right) ->
    Left rem 5 =:= Right;
handle_con_compare(<<"mod6">>, Left, Right) ->
    Left rem 6 =:= Right;
handle_con_compare(<<"mod7">>, Left, Right) ->
    Left rem 7 =:= Right;
handle_con_compare(<<"mod8">>, Left, Right) ->
    Left rem 8 =:= Right;
handle_con_compare(<<"mod9">>, Left, Right) ->
    Left rem 9 =:= Right;
handle_con_compare(_Rela, _Left, _Right) ->
    false.

%% @spec handle_con_key(Key, Target) -> term()
%% Key = atom()
%% Target = #fighter{} | #combat_scene{} | #npc{}
%% 处理条件属性 
%% key的处理
handle_con_key(hp, _Target = #fighter{hp = Hp}) ->
    Hp;
handle_con_key(hp_abs, _Target = #fighter{hp = Hp}) ->
    Hp;
handle_con_key(mp, _Target = #fighter{mp = Mp}) ->
    Mp;
handle_con_key(is_escape, _Target = #fighter{is_escape = IsEscape}) ->
    IsEscape;
handle_con_key(round, _Target = #combat_scene{round = Round}) ->
    Round;
handle_con_key(career, _Target = #fighter{career = Career}) ->
    Career;
handle_con_key(sex, _Target = #fighter{sex = Sex}) ->
    Sex;
handle_con_key(id, _Target = #fighter{rid = Rid}) ->
    Rid;
handle_con_key(attack, _Target = #fighter{attr = Attr}) ->
    Attr#attr.dmg_max;
handle_con_key(hitrate, _Target = #fighter{attr = Attr}) ->
    Attr#attr.hitrate;
handle_con_key(fighter_type, _Target = #fighter{type = FighterType}) ->
    FighterType;
handle_con_key(lev, _Target = #fighter{lev = Lev}) ->
    Lev;
handle_con_key(damage, _Target = #fighter{id = Id}) ->
	combat2:calc_damage(by_id, Id);

handle_con_key(hit, _Target = #fighter{id = Id}) ->
	combat2:f_atk_times(by_id, Id);

handle_con_key(choice, _Target = #fighter{act = #act{type = Action}}) ->
    Action;
handle_con_key(_key, _Target) ->
    0.

%% @spec handle_con_value(Key, Target) -> term()
%% value的处理
handle_con_value(Key, {_Self, _Scene}) when is_number(Key)-> %%数字的频率较高
    Key;

handle_con_value(focus, {_Self, _Scene}) -> 
    ?energy;
handle_con_value(attack, {_Self, _Scene}) -> 
    ?attack;
handle_con_value(block, {_Self, _Scene}) -> 
    ?defence;

handle_con_value(opp_hp, {_Self, Scene}) when is_record(Scene, combat_scene)->
    #combat_scene{opp_side = [OppSide|_]} = Scene,
    case is_record(OppSide, fighter) of 
        true ->
            OppSide#fighter.hp;
        _ ->
            0
    end;

handle_con_value(_key, _Target) ->
    0.

% handle_con_key(hp, _Target = #fighter{hp_max = HpMax}, Value) ->
%     HpMax /100 * Value;
% handle_con_key(_Key, _Fighter, Value) ->
%     Value.

%% @spec handle_con_count(Targets, Count) -> true | false
%% Targets = []
%% Count = integer()
%% 处理个数
handle_con_count(Targets, 0) ->
    Targets == [];
handle_con_count(Targets, Count) when Count > 0 ->
    length(Targets) >= Count;
handle_con_count(_Targets, _Count) ->
    false.

%% @spec pre_process(Npc) -> Result
%% Npc = #fighter{} | #Npc
%% Result = {false, Npc} | {list() | Npc}
%% 预处理
pre_process(#fighter{type = ?fighter_type_npc, base_id = BaseId})->
    case leisure_ai_data:get(ai, BaseId) of 
        {ok, AiConfig} ->
          	AiConfig;
        _ ->
            []
    end;

pre_process(#fighter{type = ?fighter_type_role, career = Career})->
    case leisure_ai_data:get(ai, Career) of 
        {ok, AiConfig} ->
          	AiConfig;
        _ ->
            []
    end.

%% @spec can_action(Npc) -> true | false
%% Npc = #fighter{} | #npc{}
%% 判断Npc是否可以执行动作
can_action(_Npc = #fighter{is_die = IsDie, is_escape = IsEscape, is_stun = IsStun, is_taunt = IsTaunt, is_silent = IsSilent, is_sleep = IsSleep, is_stone = IsStone}) when IsDie =:= ?true orelse IsEscape =:= ?true orelse IsStun =:= ?true orelse IsTaunt =:= ?true orelse IsSilent =:= ?true orelse IsSleep =:= ?true orelse IsStone =:= ?true ->
    false;
can_action(_Npc) ->
    true.

%% @spec can_verity(Rule, Npc) -> true | false
%% Rule = #npc_ai_rule
%% Npc = #fighter{} | #npc{}
%% 判断是否可对规则进行判定
can_verity(_Rule = #npc_ai_rule{id = Id, repeat = Repeat}, _Npc = #fighter{ai = {_AiList, AiHis}}) ->
    case ((Repeat == 0) and lists:member(Id, AiHis)) of
        true ->
            false;
        false ->
            true
    end.

%% @spec handle_type(Atom, #npc_ai_rule{}, Data) -> NewData
%% Atom = atom()
%% Data = NewData = term()
%% 处理AI类型
handle_type(scene, _Rule, Scene = #combat_scene{opp_side = OppSide, self_side = SelfSide}) ->
    Scene#combat_scene{opp_side = [F || F = #fighter{type = Type} <- OppSide, Type =/= ?fighter_type_pet], 
        self_side = [F || F = #fighter{type = Type} <- SelfSide, Type =/= ?fighter_type_pet]};
handle_type(_, _Rule, Data) ->
    Data.

%% @spec gen_scene(Type, Scene) -> #combat_scene{} |
%% Type = atom()
%% Scene = {}
%% 把tuple转换为record
gen_scene(combat, Scene = #combat_scene{}) ->
    Scene;
gen_scene(combat, Scene) -> 
    {SelfSide, OppSide, Round} = Scene,
    #combat_scene{self_side = SelfSide, opp_side = [F || F = #fighter{} <- OppSide], round = Round};
gen_scene(_Type, Scene) ->
    Scene.

%% 随机出招:根据是否有攻击次数来选招，没有则随机取蓄力或格挡
get_rand_action(Self = #fighter{id = Id}, _Scene = #combat_scene{opp_side = OppSide}) ->
	N = combat2:f_atk_times(by_id, Id),
	Action = 
		if
			N >= ?max_energy ->
				lists:nth(util:rand(1, 2), [?attack, ?defence]);
			N =< 0->
				lists:nth(util:rand(1, 2), [?energy, ?defence]);
			true ->
				lists:nth(util:rand(1, 3), [?energy, ?attack, ?defence])
		end,
	Act = 
	case Action of 
		?energy -> 
    		{Power, IsCrit} = leisure:calc_dmg(Self, OppSide),
    		#act{type = Action, power = Power, is_crit = IsCrit};
    	_ ->
    		#act{type = Action, power = 0, is_crit = 0}
    end,
    Self#fighter{act = Act}.