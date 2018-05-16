%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 玩家技能
%%% @end
%%% Created : 26. 一月 2015 下午2:12
%%%-------------------------------------------------------------------
-module(skill).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("skill.hrl").
-include("tips.hrl").
-include("dvip.hrl").

-export([
    get_skill/1,
    get_skill_list/1,
    learn_skill/2,
    learn_skill_passive/2,
    upgrade_skill/2,
    upgrade_skill_passive/2,
    auto_learn_skill/1,
    get_skill_comat_effect/1,
    check_has_skill_up/1,
    shadow_skill/1,
    update_skill_exp/2,
    upgrade_career_skill/2,
    check_skill_up_state/2,
    change_skill_effect/2,
    active_skill_effect/1
]).

-export([cmd_exp/0]).

%%更新技能熟练度
update_skill_exp(0, Player) -> Player;
update_skill_exp(SkillId, Player) ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    case lists:keytake(SkillId, 1, St#st_skill.skill_battle_list) of
        false -> Player;
        {value, {_, Exp}, T} ->
            NewExp = Exp + 1,
            case data_skill:get(SkillId) of
                [] -> Player;
                Skill ->
                    %%熟练度满则提升等级
                    if Skill#skill.exp == 0 -> Player;
                        true ->
                            if Exp >= Skill#skill.exp -> Player;
                                true ->
                                    NewSt = St#st_skill{skill_battle_list = [{SkillId, min(NewExp, Skill#skill.exp)} | T], is_change = 1},
                                    lib_dict:put(?PROC_STATUS_SKILL, NewSt),
                                    Player
                            end
                    end
            end
    end.


cmd_exp() ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    F = fun({SkillId, _}) ->
        case data_skill:get(SkillId) of
            [] -> [];
            Skill -> [{SkillId, Skill#skill.exp}]
        end
        end,
    SkillBattleList = lists:flatmap(F, St#st_skill.skill_battle_list),
    lib_dict:put(?PROC_STATUS_SKILL, St#st_skill{skill_battle_list = SkillBattleList, is_change = 1}),
    ok.

%% 获取技能接口
get_skill(SkillId) ->
    case data_skill:get(SkillId) of
        [] ->
            #skill{};
        Skill -> Skill
    end.

%%获取技能
get_skill_list(Player) ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    F = fun(SkillId) ->
        case fetch_skill(St#st_skill.skill_battle_list, SkillId) of
            [] ->
                [SkillId, 0, 0];
            {NewSkillId, Exp} ->
                [NewSkillId, 1, Exp]
        end
        end,
    SkillList = lists:map(F, data_skill:career_skills(Player#player.career)),
    F1 = fun(SkillId1) ->
        case fetch_skill_passive(St#st_skill.skill_passive_list, SkillId1) of
            [] ->
                [SkillId1, 0];
            NewSkillId ->
                [NewSkillId, 1]
        end
         end,
    SkillPassiveList0 = lists:map(F1, data_skill:career_skills_passive(Player#player.career)),
    DvipSkill = [DvipSkill00, _] = dvip_util:get_active_skill(Player),
    SkillPassiveList1 = [SK || [SkillId, _Active] = SK <- SkillPassiveList0, SkillId /= DvipSkill00],
    SkillPassiveList = SkillPassiveList1 ++ [DvipSkill],
    GodnessWarSkillList = godness:get_war_godness_skill(),
    F2 = fun(SkillId2) ->
        case Player#player.lv < 50 of
            true -> [SkillId2, 0];
            false -> [SkillId2, 1]
        end
    end,
    EvilSkillList = lists:map(F2, ?IF_ELSE(GodnessWarSkillList == [], ?SKILL_EVIL_LIST, GodnessWarSkillList)),
    FF = fun(XianSkillId) ->
        #skill{type = Type} = data_skill:get(XianSkillId),
        ?IF_ELSE(Type == 1, [XianSkillId], [])
    end,
    XianSkillList = lists:flatmap(FF, Player#player.xian_skill),
    {ok, Bin} = pt_210:write(21001, {Player#player.skill_serial, SkillList, SkillPassiveList, EvilSkillList, Player#player.skill_effect, XianSkillList}),
    server_send:send_to_sid(Player#player.sid, Bin).



fetch_skill(SkillList, SkillId) ->
    case lists:keyfind(SkillId, 1, SkillList) of
        false ->
            case data_skill:get(SkillId) of
                [] -> [];
                Base ->
                    fetch_skill(SkillList, Base#skill.next_skillid)
            end;
        {_, Exp} ->
            {SkillId, Exp}
    end.

fetch_skill_passive(SkillList, SkillId) ->
    case lists:member(SkillId, SkillList) of
        false ->
            case data_skill:get(SkillId) of
                [] -> [];
                Base ->
                    fetch_skill_passive(SkillList, Base#skill.next_skillid)
            end;
        true ->
            SkillId
    end.

%%学习技能
learn_skill(Player, SkillId) ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    case check_skill_learn(Player, St#st_skill.skill_battle_list, SkillId) of
        {fail, Code} ->
            {Code, Player};
        {ok, Player1} ->
            SkillBattleList = [{SkillId, 0} | St#st_skill.skill_battle_list],
            NewSt = St#st_skill{skill_battle_list = SkillBattleList, is_change = 1},
            lib_dict:put(?PROC_STATUS_SKILL, NewSt),
            Player2 = Player1#player{skill = [Sid || {Sid, _} <- SkillBattleList]},
            player_util:count_player_attribute(Player2, true),
            {1, Player2}
    end.
%%学习被动技能
learn_skill_passive(Player, SkillId) ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    case check_skill_passive_learn(Player, St#st_skill.skill_passive_list, SkillId) of
        {fail, Code} ->
            {Code, Player};
        ok ->
            SkillPassiveList = [SkillId | St#st_skill.skill_passive_list],
            Attribute = skill_init:calc_skill_passive_attribute(SkillPassiveList),
            NewSt = St#st_skill{skill_passive_list = SkillPassiveList, attribute = Attribute, is_change = 1},
            lib_dict:put(?PROC_STATUS_SKILL, NewSt),
            NewPlayer = player_util:count_player_attribute(Player, true),
            {1, NewPlayer}
    end.

check_skill_learn(Player, SkillList, SkillId) ->
    case data_skill:get(SkillId) of
        [] ->
            {fail, 0};
        Skill ->
            if Player#player.lv < Skill#skill.needlv -> {fail, 2};
                Skill#skill.lv /= 1 -> {fail, 9};
                Skill#skill.type /= 1 -> {fail, 12};
                Skill#skill.career /= Player#player.career -> {fail, 11};
                true ->
                    case lists:keyfind(SkillId, 1, SkillList) of
                        false ->
                            case money:is_enough(Player, Skill#skill.cost, coin) of
                                false -> {fail, 6};
                                true ->
                                    NewPlayer = money:add_coin(Player, -Skill#skill.cost, 59, 0, 0),
                                    {ok, NewPlayer}
                            end;
                        _ ->
                            {fail, 3}
                    end
            end
    end.
check_skill_passive_learn(Player, SkillList, SkillId) ->
    case data_skill:get(SkillId) of
        [] -> {fail, 0};
        Skill ->
            if SkillId == ?DVIP_PASSIVE_SKILL -> ok;
                true ->
                    if Player#player.lv < Skill#skill.needlv -> {fail, 2};
                        Skill#skill.lv /= 1 -> {fail, 9};
                        Skill#skill.type /= 5 -> {fail, 10};
                        Skill#skill.career /= Player#player.career -> {fail, 11};
                        true ->
                            case lists:member(SkillId, SkillList) of
                                false ->
                                    case Skill#skill.goods of
                                        {} -> {fail, 13};
                                        {GoodsId, Num} ->
                                            case goods_util:get_goods_count(GoodsId) < Num of
                                                true -> {fail, 14};
                                                false ->
                                                    goods:subtract_good(Player, [{GoodsId, Num}], 59),
                                                    ok
                                            end
                                    end;
                                true -> {fail, 3}
                            end
                    end
            end
    end.


%% 自动学习技能
auto_learn_skill(Player) ->
    CareerSkills = data_skill:career_skills(Player#player.career),
    St = lib_dict:get(?PROC_STATUS_SKILL),
    F = fun(Sid, {P, L}) ->
        case fetch_skill(St#st_skill.skill_battle_list, Sid) of
            [] ->
                case data_skill:get(Sid) of
                    [] -> {P, L};
                    Skill ->
                        case Player#player.lv >= Skill#skill.needlv of
                            false -> {P, L};
                            true ->
                                case lists:keyfind(Sid, 1, St#st_skill.skill_battle_list) of
                                    false ->
                                        {P, [{Sid, 0} | L]};
                                    _ -> {P, L}
                                end
                        end
                end;
            _ -> {P, L}
        end
        end,
    {NewPlayer, AllowSkills} = lists:foldl(F, {Player, []}, CareerSkills),
    NewSkills = AllowSkills ++ St#st_skill.skill_battle_list,
    NewPlayer1 = NewPlayer#player{skill = [SkillId || {SkillId, _} <- NewSkills]},
    if
        AllowSkills /= [] ->
            lib_dict:put(?PROC_STATUS_SKILL, St#st_skill{skill_battle_list = NewSkills, is_change = 1});
        true ->
            skip
    end,
    NewPlayer1.

%%升级技能
upgrade_skill(Player, OldSkillId) ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    case check_skill_up(Player, St#st_skill.skill_battle_list, OldSkillId) of
        {fail, Code} ->
            {Code, Player};
        {ok, Player1, NewSkillId} ->
            SkillBattleList = [{NewSkillId, 0} | lists:keydelete(OldSkillId, 1, St#st_skill.skill_battle_list)],
            lib_dict:put(?PROC_STATUS_SKILL, St#st_skill{skill_battle_list = SkillBattleList, is_change = 1}),
            Player2 = Player1#player{skill = [Sid || {Sid, _} <- SkillBattleList]},
            Player3 = player_util:count_player_attribute(Player2, true),
            {1, Player3}
    end.
upgrade_skill_passive(Player, SkillId) ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    case check_skill_passive_up(Player, St#st_skill.skill_passive_list, SkillId) of
        {fail, Code} ->
            {Code, Player};
        {ok, NewSkillId} ->
            SkillPassiveList = [NewSkillId | lists:delete(SkillId, St#st_skill.skill_passive_list)],
            Attribute = skill_init:calc_skill_passive_attribute(SkillPassiveList),
            NewSt = St#st_skill{skill_passive_list = SkillPassiveList, attribute = Attribute, is_change = 1},
            lib_dict:put(?PROC_STATUS_SKILL, NewSt),
            NewPlayer = player_util:count_player_attribute(Player, true),
            {1, NewPlayer}
    end.

check_skill_up_state(Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    F = fun({SkillId, Exp}) ->
        Skill = data_skill:get(SkillId),
        if
            Skill#skill.next_skillid == 0 -> [];
            Player#player.lv < Skill#skill.needlv -> [];
            Exp < Skill#skill.exp -> [];
            true ->
                case data_skill:get(Skill#skill.next_skillid) of
                    [] -> [];
                    NewSkill ->
                        case money:is_enough(Player, NewSkill#skill.cost, coin) of
                            true ->
                                [1];
                            false ->
                                []
                        end
                end
        end
        end,
    L = lists:flatmap(F, St#st_skill.skill_battle_list),
    ?IF_ELSE(L == [], Tips, Tips#tips{state = 1}).

check_skill_up(Player, SkillList, SkillId) ->
    case data_skill:get(SkillId) of
        [] ->
            {fail, 0};
        Skill ->
            case lists:keyfind(SkillId, 1, SkillList) of
                false ->
                    {fail, 4};
                {SkillId, Exp} ->
                    if Skill#skill.next_skillid == 0 -> {fail, 7};
                        Player#player.lv < Skill#skill.needlv -> {fail, 2};
                        Exp < Skill#skill.exp -> {fail, 8};
                        true ->
                            case data_skill:get(Skill#skill.next_skillid) of
                                [] -> {fail, 0};
                                NewSkill ->
                                    case money:is_enough(Player, NewSkill#skill.cost, coin) of
                                        true ->
                                            NewPlayer = money:add_coin(Player, -NewSkill#skill.cost, 59, 0, 0),
                                            {ok, NewPlayer, NewSkill#skill.skillid};
                                        false ->
                                            {fail, 6}
                                    end
                            end
                    end
            end
    end.
check_skill_passive_up(Player, SkillList, SkillId) ->
    case data_skill:get(SkillId) of
        [] ->
            {fail, 0};
        Skill ->
            case lists:member(SkillId, SkillList) of
                false ->
                    {fail, 4};
                true ->
                    if Skill#skill.next_skillid == 0 -> {fail, 7};
                        Player#player.lv < Skill#skill.needlv -> {fail, 2};
                        true ->
                            case data_skill:get(Skill#skill.next_skillid) of
                                [] -> {fail, 0};
                                NewSkill ->
                                    case NewSkill#skill.goods of
                                        {} -> {fail, 13};
                                        {GoodsId, Num} ->
                                            case goods_util:get_goods_count(GoodsId) < Num of
                                                true -> {fail, 14};
                                                false ->
                                                    goods:subtract_good(Player, [{GoodsId, Num}], 59),
                                                    {ok, NewSkill#skill.skillid}
                                            end
                                    end
                            end
                    end
            end
    end.


%%获取技能给人物假的战斗力
get_skill_comat_effect(Player) ->
    Skills = Player#player.skill,
    Fun = fun(SkillId, Out) ->
        case data_skill:get(SkillId) of
            [] -> Out;
            Skill ->
                Skill#skill.skill_cbp
        end
          end,
    lists:foldl(Fun, 0, Skills).


%%检查玩家是否有技能可升级
check_has_skill_up(Player) ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    F = fun(Sid) ->
        case fetch_skill(St#st_skill.skill_battle_list, Sid) of
            [] ->
                case data_skill:get(Sid) of
                    [] -> false;
                    _Skill ->
                        case lists:keyfind(Sid, 1, St#st_skill.skill_battle_list) of
                            false ->
                                true;
                            _ -> false
                        end
                end;
            {SkillId, Exp} ->
                case data_skill:get(SkillId) of
                    [] -> false;
                    Skill ->
                        case data_skill:get(Skill#skill.next_skillid) of
                            [] -> false;
                            NextSkill ->
                                if Player#player.lv < NextSkill#skill.needlv -> false;
                                    Exp < Skill#skill.exp -> false;
                                    true ->
                                        true
                                end
                        end

                end
        end
        end,
    case lists:any(F, data_skill:career_skills(Player#player.career)) of
        false -> 0;
        true -> 1
    end.

%%系统镜像技能
shadow_skill(Career) ->
    data_skill:career_skills(Career).


%% 升级职业技能熟练度
upgrade_career_skill(Player, SkillId) ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    case lists:keytake(SkillId, 1, St#st_skill.skill_battle_list) of
        false -> {4, Player};
        {value, {_, Exp}, T} ->
            case data_skill:get(SkillId) of
                #skill{exp = LvExp, next_skillid = NextSkillId} when LvExp > 0 ->
                    case Exp >= LvExp of
                        true -> %% 可升级
                            case data_skill:get(NextSkillId) of
                                #skill{needlv = NeedLv} when NeedLv =< Player#player.lv ->
                                    NewSt = St#st_skill{skill_battle_list = [{NextSkillId, 0} | T], is_change = 1},
                                    lib_dict:put(?PROC_STATUS_SKILL, NewSt),
                                    Player1 = Player#player{skill = [Sid || {Sid, _} <- NewSt#st_skill.skill_battle_list]},
                                    Player2 = player_util:count_player_attribute(Player1, true),
                                    get_skill_list(Player2),
                                    {1, Player2};
                                _ ->
                                    {16, Player}
                            end;
                        _ ->
                            {8, Player}
                    end;
                _ ->
                    {15, Player}
            end
    end.


%%切换主技能效果
change_skill_effect(Player, SkillEffect) ->
    if Player#player.skill_effect == SkillEffect ->
        {17, Player};
        SkillEffect == 0 ->
            St = lib_dict:get(?PROC_STATUS_SKILL),
            NewSt = St#st_skill{skill_effect = SkillEffect, is_change = 1},
            lib_dict:put(?PROC_STATUS_SKILL, NewSt),
            NewPlayer = Player#player{skill_effect = SkillEffect},
            scene_agent_dispatch:update_skill_effect(NewPlayer),
            {1, NewPlayer};
        SkillEffect == 1 ->
            case dungeon_equip:is_all_pass() of
                false ->
                    {18, Player};
                true ->
                    St = lib_dict:get(?PROC_STATUS_SKILL),
                    NewSt = St#st_skill{skill_effect = SkillEffect, is_change = 1},
                    lib_dict:put(?PROC_STATUS_SKILL, NewSt),
                    NewPlayer = Player#player{skill_effect = SkillEffect},
                    scene_agent_dispatch:update_skill_effect(NewPlayer),
                    {1, NewPlayer}
            end;
        true ->
            {0, Player}
    end.


active_skill_effect(Player) ->
    case dungeon_equip:is_all_pass() of
        false ->
            Player;
        true ->
            St = lib_dict:get(?PROC_STATUS_SKILL),
            NewSt = St#st_skill{skill_effect = 1, is_change = 1},
            lib_dict:put(?PROC_STATUS_SKILL, NewSt),
            NewPlayer = Player#player{skill_effect = 1},
            scene_agent_dispatch:update_skill_effect(NewPlayer),
            {ok,Bin} = pt_210:write(21008,{1}),
            server_send:send_to_sid(Player#player.sid,Bin),
            NewPlayer
    end.