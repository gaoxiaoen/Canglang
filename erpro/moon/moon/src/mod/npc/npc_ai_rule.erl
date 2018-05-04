%% ----------------------------------------------------------------------------
%% NPC AI
%% @author abu@jieyou.cn
%% ----------------------------------------------------------------------------
-module(npc_ai_rule).
%% include
-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("combat.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("attr.hrl").
-include("npc.hrl").
-include("map.hrl").

-define(keywords, [name]).
-define(npc_ai_level_count, npc_ai_level_count).

-export([ handle_con_target/4       %% 处理条件中目标
        , handle_con_rela/4         %% 处理条件中的比较
        , handle_con_key/2          %% 处理条件中的Key
        , handle_con_key/3          %% 处理key为hp时，数值为百分比
        , handle_con_compare/3      %% 处理比较
        , handle_con_count/2        %% 处理条件中的数量
        , handle_action_target/4    %% 处理行为中的目标
        , handle_action_type/6      %% 处理行为中的类别
        , handle_type/3             %% 处理AI类型
        , pre_process/1             %% 预算理
        , default_action/2          %% 默认行为
        , replace/3                 %% 字符中的特殊字符替换
        , gen_scene/2               %% 对场景tuple转换为record
        , can_action/1              %% 是否可以行动
        , can_verity/2              %% 是否可以检测此规则
        , get_not_die/1             %% 取得没有死掉的fighter
        , get_lowest_hp/1           %% 取没有死最弱的对手
        ]).

%% -----------------------------------------------------
%% api funs
%% -----------------------------------------------------

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
handle_con_target(opp_side, _SuitTar, #fighter{type = ?fighter_type_npc, subtype = ?fighter_subtype_demon}, _Scene = #combat_scene{opp_side = OppSide}) -> %% 妖精不打睡眠单位
        [ F ||  F = #fighter{is_sleep = IsSleep} <- OppSide, IsSleep =:= ?false];
handle_con_target(opp_side, _SuitTar, Npc, _Scene = #combat_scene{opp_side = OppSide}) when is_record(Npc, fighter) ->
    OppSide;
handle_con_target(suit_tar, SuitTar, Npc, _Scene = #combat_scene{}) when is_record(Npc, fighter) ->
    SuitTar;


handle_con_target(_ConTarget, _SuitTar, _Npc, Scene) ->
    [Scene].

%% @spec handle_con_rela(Targets, Key, Rela, Value) -> Result
%% Targets = is_list()
%% Key = atom()
%% Rela = bitstring()
%% Value = term()
%% Result = []
%% 处理比较
handle_con_rela(Targets, Key, Rela, Value) ->
    handle_con_rela(Targets, Key, Rela, Value, []).

handle_con_rela(_Targets = [], _Key, _Rela, _Value, Back) ->
    Back;
handle_con_rela(_Targets = [H | T], Key, Rela, Value, Back) ->
    case handle_con_compare(Rela, handle_con_key(Key, H), handle_con_key(Key, H, Value)) of
        true ->
            handle_con_rela(T, Key, Rela, Value, [H | Back]);
        false ->
            handle_con_rela(T, Key, Rela, Value, Back)
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
handle_con_compare(<<"include">>, Left, Right) when is_list(Left) ->
    lists:member(Right, Left);
handle_con_compare(<<"not_in">>, Left, Right) when is_list(Left) ->
    not lists:member(Right, Left);
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
handle_con_compare(<<"mod10">>, Left, Right) ->
    Left rem 10 =:= Right;
handle_con_compare(<<"mod11">>, Left, Right) ->
    Left rem 11 =:= Right;
handle_con_compare(<<"mod12">>, Left, Right) ->
    Left rem 12 =:= Right;
handle_con_compare(<<"mod13">>, Left, Right) ->
    Left rem 13 =:= Right;
handle_con_compare(<<"mod14">>, Left, Right) ->
    Left rem 14 =:= Right;
handle_con_compare(<<"mod15">>, Left, Right) ->
    Left rem 15 =:= Right;
handle_con_compare(<<"mod16">>, Left, Right) ->
    Left rem 16 =:= Right;
handle_con_compare(<<"mod17">>, Left, Right) ->
    Left rem 17 =:= Right;
handle_con_compare(<<"mod18">>, Left, Right) ->
    Left rem 18 =:= Right;
handle_con_compare(<<"mod19">>, Left, Right) ->
    Left rem 19 =:= Right;
handle_con_compare(<<"mod20">>, Left, Right) ->
    Left rem 20 =:= Right;

handle_con_compare(_Rela, _Left, _Right) ->
    false.

%% @spec handle_con_key(Key, Target) -> term()
%% Key = atom()
%% Target = #fighter{} | #combat_scene{} | #npc{}
%% 处理条件属性
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
handle_con_key(id, _Target = #fighter{base_id = BaseId}) ->
    BaseId;
handle_con_key(attack, _Target = #fighter{attr = Attr}) ->
    Attr#attr.dmg_max;
handle_con_key(hitrate, _Target = #fighter{attr = Attr}) ->
    Attr#attr.hitrate;
handle_con_key(buff, _Target = #fighter{buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound}) ->
    Buffs = BuffAtk ++ BuffHit ++ BuffRound,
    [Id || #c_buff{id = Id} <- Buffs];
handle_con_key(buff_eff_type, _Target = #fighter{buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound}) ->
    Buffs = BuffAtk ++ BuffHit ++ BuffRound,
    [EffType || #c_buff{eff_type = EffType} <- Buffs];
handle_con_key(fighter_type, _Target = #fighter{type = FighterType}) ->
    FighterType;
handle_con_key(base_skill, _Target = #fighter{ai_skills = BaseSkill}) ->
    case is_list(BaseSkill) of
        true ->
            [SkillPre || {SkillPre, _} <- BaseSkill];
        false ->
            []
    end;
handle_con_key(anger_skill, _Target = #fighter{ai_anger_skills = AngerSkill}) ->
    case is_list(AngerSkill) of
        true ->
            [SkillPre || {SkillPre, _} <- AngerSkill];
        false ->
            []
    end;
handle_con_key(lev, _Targe = #fighter{lev = Lev}) ->
    Lev;
handle_con_key(_key, _Target) ->
    0.

handle_con_key(hp, _Target = #fighter{hp_max = HpMax}, Value) ->
    HpMax /100 * Value;
handle_con_key(_Key, _Fighter, Value) ->
    Value.

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

%% @spec handle_action_target(Atype, Npc, SuitTar, Scene) -> []
%% Atype = atom()
%% Npc = #fighter{} | #npc{}
%% SuitTar = []
%% Scene = #combat_scene{} |
%% 处理行为的目标
handle_action_target(self, Npc, _SuitTar, Scene) when is_record(Npc, fighter) and is_record(Scene, combat_scene) ->
    [Npc];
handle_action_target(self_side, Npc, _SuitTar, _Scene = #combat_scene{self_side = SelfSide}) when is_record(Npc, fighter) ->
    SelfSide;
handle_action_target(opp_side, Npc, _SuitTar, _Scene = #combat_scene{opp_side = OppSide}) when is_record(Npc, fighter) ->
    OppSide;
handle_action_target(suit_tar, Npc, SuitTar, Scene) when is_record(Npc, fighter) and is_record(Scene, combat_scene) ->
    SuitTar;
handle_action_target(top_lev, Npc, _SuitTar, _Scene = #combat_scene{opp_side = OppSide}) when is_record(Npc, fighter) ->
    get_top_level(OppSide, true);
handle_action_target(low_lev, Npc, _SuitTar, _Scene = #combat_scene{opp_side = OppSide}) when is_record(Npc, fighter) ->
    get_top_level(OppSide, false);
handle_action_target(_Atype, Npc, _SuitTar, _Scene) ->
    [Npc].


%% @spec handle_action_type(Atype, Aval, Targets, Rule, Npc, Scene) -> Result
%% Atype = atom()
%% Aval = term()
%% Targets = []
%% Rule = #npc_ai_rule{}
%% Npc = #fighter{} | #npc{}
%% Scene = #combat_scene{}
%% Result = #fighter{} | #npc{}
%% 处理行为的动作
handle_action_type(talk, Aval, Targets, _Rule, Npc = #fighter{}, _Scene = #combat_scene{}) ->
    case util:rand_list(Aval) of
        null ->
            Npc;
        Sen ->
            case get_not_die(Targets) of
                false ->
                    Npc;
                Fighter ->
                    Npc#fighter{talk = replace(Sen, Npc, Fighter)}
            end
    end;
handle_action_type(skill, Aval, Targets, Rule, Npc = #fighter{type = FighterType}, _Scene = #combat_scene{}) ->
    Tar = case FighterType of
        ?fighter_type_role ->
            get_lowest_hp(Targets);
        _ ->
            assign_target(Targets)
    end,
    Act = case Tar of
        false ->
            false;
        #fighter{pid = Pid} ->
            {get_skill(Aval), Pid}
    end,
    case Act of
        false ->
            Npc;
        _ ->
            {Vlist, His} = Npc#fighter.ai,
            NewHis = [Rule#npc_ai_rule.id | His],
            Npc#fighter{act = Act, ai = {Vlist, NewHis}}
    end;
handle_action_type(base_skill, Aval, Targets, Rule, Npc = #fighter{ai_skills = BaseSkill, type = FighterType}, _Scene = #combat_scene{}) ->
    Tar = case FighterType of
        ?fighter_type_role ->
            get_lowest_hp(Targets);
        _ ->
            assign_target(Targets)
    end,
    Act = case Tar of
        false ->
            false;
        #fighter{pid = Pid} ->
            {get_skill(Aval, BaseSkill), Pid}
    end,
    case Act of
        false ->
            Npc;
        _ ->
            {Vlist, His} = Npc#fighter.ai,
            NewHis = [Rule#npc_ai_rule.id | His],
            Npc#fighter{act = Act, ai = {Vlist, NewHis}}
    end;
handle_action_type(anger_skill, Aval, _Targets, _Rule, Npc = #fighter{act = Act, ai_anger_skills = AngerSkill}, _Scene = #combat_scene{}) ->
    case Act of
        {Skill = #c_skill{}, T} ->
            SkillId = get_skill(anger, Aval, AngerSkill),
            Npc#fighter{act = {Skill#c_skill{special = [{2, SkillId}]}, T}};
        _ ->
            Npc
    end;
handle_action_type(ai_level, Aval, _Targets, _Rule, Npc = #fighter{ai = {_, AiHis}}, Scene = #combat_scene{}) ->
    Count = case get(?npc_ai_level_count) of
        C when is_integer(C) andalso C > 0 ->
            put(?npc_ai_level_count, C + 1);
        _ ->
            put(?npc_ai_level_count, 1),
            1
    end,
    case Count < 10 of %% 避免ai等级跳转的死循环
        true ->
            AiList = get_ai_config(Npc#fighter.base_id, Aval), 
            npc_ai:act(Npc#fighter{ai = {AiList, AiHis}}, Scene);
        false ->
            AiList = get_ai_config(Npc#fighter.base_id, Aval), 
            Npc#fighter{ai = {AiList, AiHis}}
    end;
handle_action_type(_Type, _Aval, _Targets, _Rule, Npc, _Scene) ->
    Npc.

%% @spec handle_type(Atom, #npc_ai_rule{}, Data) -> NewData
%% Atom = atom()
%% Data = NewData = term()
%% 处理AI类型
handle_type(scene, _Rule = #npc_ai_rule{type = ?npc_ai_type_nopet}, Scene = #combat_scene{opp_side = OppSide, self_side = SelfSide}) ->
    Scene#combat_scene{opp_side = [F || F = #fighter{type = Type} <- OppSide, Type =/= ?fighter_type_pet], 
        self_side = [F || F = #fighter{type = Type} <- SelfSide, Type =/= ?fighter_type_pet]};
handle_type(_, _Rule, Data) ->
    Data.


%% @spec pre_process(Npc) -> Result
%% Npc = #fighter{} | #Npc
%% Result = {false, Npc} | {list() | Npc}
%% 预处理
pre_process(Npc = #npc{base_id = Bid, ai = {AiList, AiHis}}) ->
    case AiList of
        [] ->
            case get_ai_config(Bid, 100) of
                [] ->
                    {false, Npc};
                Al ->
                    {Al, Npc#npc{ai = {Al, AiHis}}}
            end;
        _ ->
            {AiList, Npc}
    end;
pre_process(Npc = #fighter{ai = {AiList, AiHis}, type = Ftype, subtype = FsubType, secret_ai = SecretAI}) when SecretAI > 0 ->
    case AiList of
        [] ->
            case get_ai_config(Ftype, FsubType, 0, SecretAI, 1) of
                [] ->
                    {false, Npc};
                Al ->
                    {Al, Npc#fighter{ai = {Al, AiHis}}}
            end;
        _ ->
            {AiList, Npc}
    end;
pre_process(Npc = #fighter{ai = {AiList, AiHis}, type = Ftype, subtype = FsubType, special_ai = SpecialAI}) when SpecialAI > 0 ->
    case AiList of
        [] ->
            case get_ai_config(Ftype, FsubType, 0, SpecialAI, 1) of
                [] ->
                    {false, Npc};
                Al ->
                    {Al, Npc#fighter{ai = {Al, AiHis}}}
            end;
        _ ->
            {AiList, Npc}
    end;
pre_process(Npc = #fighter{base_id = BaseId, ai = {AiList, AiHis}, type = Ftype, career = Fcareer}) ->
    case AiList of
        [] ->
            case get_ai_config(Ftype, BaseId, Fcareer, 1) of
                [] ->
                    {false, Npc};
                Al ->
                    {Al, Npc#fighter{ai = {Al, AiHis}}}
            end;
        _ ->
            {AiList, Npc}
    end;
pre_process(Npc) ->
    {false, Npc}.

%% @spec default_action(Npc, Scene) -> Result
%% Npc = Result = #fighter{} | #npc{}
%% Scene = #combat_scene | 
%% 让npc使用默认动作
default_action(Npc, Scene) when is_record(Npc, fighter) and is_record(Scene, combat_scene) -> 
    NewScene = handle_type(scene, #npc_ai_rule{type = ?npc_ai_type_common}, Scene),
    Npc#fighter{act = get_default_attack(Npc, NewScene)};
default_action(Npc, _Scene) ->
    Npc.

%% @spec replace(Sen, Self, Target) -> Result
%% Sen = bitstring()
%% self = #fighter{} | #npc{}
%% Target = #fighter{} | #role{}
%% Result = bitstring()
%% 替换 说话 里的特殊变量
replace(Sen, Self, Target) ->
    replace(Sen, Self, Target, ?keywords).
replace(Sen, _Self, _Target, []) ->
    Sen;
replace(Sen, Self, Target, _Keywords = [H | T]) ->
    NewSen = do_replace(H, Sen, Self, Target),
    replace(NewSen, Self, Target, T).
do_replace(self, Sen, Self, _Target) when is_record(Self, npc) ->
    re:replace(Sen, "#self#", Self#npc.name, [{return, binary}]);
do_replace(self, Sen, Self, _Target) when is_record(Self, fighter) ->
    re:replace(Sen, "#self#", Self#fighter.name, [{return, binary}]);
do_replace(name, Sen, _Self, Target) when is_record(Target, map_role) ->
    re:replace(Sen, "#name#", Target#map_role.name, [{return, binary}]);
do_replace(name, Sen, _Self, Target) when is_record(Target, fighter) ->
    re:replace(Sen, "#name#", Target#fighter.name, [{return, binary}]);
do_replace(_Key, Sen, _Self, _Target) ->
    Sen.

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

%% @spec can_action(Npc) -> true | false
%% Npc = #fighter{} | #npc{}
%% 判断Npc是否可以执行动作
can_action(_Npc = #fighter{is_die = IsDie, is_escape = IsEscape, is_stun = IsStun, is_taunt = IsTaunt, is_silent = IsSilent, is_sleep = IsSleep, is_stone = IsStone}) when IsDie =:= ?true orelse IsEscape =:= ?true orelse IsStun =:= ?true orelse IsTaunt =:= ?true orelse IsSilent =:= ?true orelse IsSleep =:= ?true orelse IsStone =:= ?true ->
    false;
can_action(_Npc) ->
    true.

%% ----------------------------------------------------------------------------
%% util funs
%% ----------------------------------------------------------------------------

%% 默认攻击
get_default_attack(Npc = #fighter{type = FighterType}, _Scene = #combat_scene{opp_side = OppSide}) ->
    Tar = case FighterType of
        ?fighter_type_role ->
            get_lowest_hp(OppSide);
        _ ->
            assign_target(OppSide)
    end,
    case Tar of
        false ->
            undefined;
        #fighter{pid = Pid} ->
            {get_normal_attack_skill(Npc), Pid}
    end.


%% 取得普通攻击
%get_normal_attack_skill(#fighter{attack_type = ?attack_type_range}) ->
%    combat_data_skill:get(1001);
%get_normal_attack_skill(_) ->
%    combat_data_skill:get(1000).
get_normal_attack_skill(Fighter) ->
    combat:get_normal_attack_skill(Fighter).

%% 取得Skill
get_skill(SkillId) ->
    case combat_data_skill:get(SkillId) of
        undefined ->
            get_normal_attack_skill(false);
        CSkill ->
            CSkill
    end.

%% 根据skill前缀获取skill
get_skill(SkillPre, BaseSkill) ->
    case lists:keyfind(SkillPre, 1, BaseSkill) of
        {_, SkillId} ->
            get_skill(SkillId);
        _ ->
            get_normal_attack_skill(false)
    end.

get_skill(anger, SkillPre, BaseSkill) ->
    case lists:keyfind(SkillPre, 1, BaseSkill) of
        {_, SkillId} ->
            SkillId;
        _ ->
            0
    end.

%% 获取一个攻击目标
assign_target([]) -> false;
assign_target(Targets) ->
    case util:rand(1, 1000) =< 500 of
        true -> get_highest_hp(Targets);
        _ -> get_not_die(Targets)
    end.
   
%% 从指定组随机取出一个未阵亡的参战者
get_not_die([]) -> false;
get_not_die(Targets) ->
    case util:rand_list(Targets) of
        F = #fighter{is_die = IsDie, is_escape = IsEscape} ->
            if IsDie =:= ?true orelse IsEscape =:= ?true  ->
                    get_not_die(lists:delete(F, Targets));
                true ->
                    F
            end;
        Other ->
            Other
    end.

%% 获取未阵亡未逃走且hp最低
get_lowest_hp([]) -> false;
get_lowest_hp([F = #fighter{is_die = ?false, is_escape = ?false}]) -> F;
get_lowest_hp([_]) -> false;
get_lowest_hp(L) -> do_get_lowest_hp(L, false).

do_get_lowest_hp([], F) -> F; 
do_get_lowest_hp([#fighter{is_die = ?false, is_escape = ?false, hp = Hp}|T], F = #fighter{hp = Hp0}) when Hp > Hp0 ->
    do_get_lowest_hp(T, F);
do_get_lowest_hp([H = #fighter{is_die = ?false, is_escape = ?false}|T], _) ->
    do_get_lowest_hp(T, H);
do_get_lowest_hp([_|T], F) ->  
    do_get_lowest_hp(T, F).

%% 获取未阵亡未逃走且hp最高
get_highest_hp([]) -> false;
get_highest_hp([F = #fighter{is_die = ?false, is_escape = ?false}]) -> F;
get_highest_hp([_]) -> false;
get_highest_hp(L) -> do_get_highest_hp(L, false).

do_get_highest_hp([], F) -> F; 
do_get_highest_hp([#fighter{is_die = ?false, is_escape = ?false, hp = Hp}|T], F = #fighter{hp = Hp0}) when Hp < Hp0 ->
    do_get_highest_hp(T, F);
do_get_highest_hp([H = #fighter{is_die = ?false, is_escape = ?false}|T], _) ->
    do_get_highest_hp(T, H);
do_get_highest_hp([_|T], F) ->  
    do_get_highest_hp(T, F).

%% 从Targets中取得最高级的fighter, 并且是未死的
%% Flag为false时，取最低等级
get_top_level(_Targets = [], _Flag) ->
    [];
get_top_level(_Targets = [H = #fighter{is_die = ?false} | T], Flag) ->
    get_top_level(T, [H], Flag);
get_top_level(_Targets = [_H = #fighter{is_die = ?true} | T], Flag) ->
    get_top_level(T, Flag).

get_top_level(_Targets = [], Fighter, _Flag) ->
    Fighter;
get_top_level(_Targets = [H = #fighter{is_die = ?false} | T], Fighter = [F | _], Flag) when Flag == false ->
    case H#fighter.lev - F#fighter.lev of 
        R1 when R1 >= 0 ->
            get_top_level(T, Fighter, Flag);
        _ ->
            get_top_level(T, [H], Flag)
    end;
get_top_level(_Targets = [H = #fighter{is_die = ?false} | T], Fighter = [F | _], Flag) ->
    case H#fighter.lev - F#fighter.lev of 
        R1 when R1 > 0 ->
            get_top_level(T, [H], Flag);
        _ ->
            get_top_level(T, Fighter, Flag)
    end;
get_top_level(_Targets = [_H = #fighter{is_die = ?true} | T], Fighter, Flag) ->
    get_top_level(T, Fighter, Flag).

%% 取得npc配置的ai
get_ai_config(NpcBaseId, Level) ->
    %% ?DEBUG("~w~n", [npc_ai_data:get(ai, NpcId)]), 
    case npc_ai_data:get(ai, NpcBaseId) of 
        false ->
            [];
        {ok, AiConfig} ->
            case [Ai || Ai = [Alh | _] <- AiConfig, Alh == Level] of
                [Ai] ->
                    Ai;
                _ ->
                    []
            end
    end.

get_ai_config(?fighter_type_npc, NpcBaseId, _, Level) ->
    get_ai_config(NpcBaseId, Level);
get_ai_config(?fighter_type_role, _, Fcareer, Level) ->
    get_ai_config(Fcareer, Level);
get_ai_config(_, _, _, _) ->
    [].

get_ai_config(?fighter_type_npc, ?fighter_subtype_demon, _, SecertAi, Level) ->
    get_ai_config(SecertAi, Level);
get_ai_config(?fighter_type_npc, _, NpcBaseId, Career, Level) ->
    get_ai_config(?fighter_type_npc, NpcBaseId, Career, Level);
get_ai_config(?fighter_type_role, _, _NpcBaseId, Career, Level) ->
    get_ai_config(?fighter_type_role, _NpcBaseId, Career, Level).
