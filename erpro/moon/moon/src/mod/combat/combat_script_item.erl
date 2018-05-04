%%----------------------------------------------------
%% 战斗物品脚本
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(combat_script_item).
-export([
        get/1
    ]
).
-include("common.hrl").
-include("combat.hrl").
-include("item.hrl").

get(Item = #item{base_id = ItemBaseId, quantity = Quantity}) ->
    case item_data:get(ItemBaseId) of
        {ok, #item_base{effect = ItemEffect, cooldown = Cooldown}} ->
            IsSkillCostItem = is_skill_cost_item(Item),
            if
                IsSkillCostItem =:= true -> 
                    #c_item{base_id = ItemBaseId, quantity = Quantity};
                true ->
                    case ItemEffect of
                        [{ScriptId, Target, Args, BuffSelf, BuffTarget}] ->
                            TmpCitem = #c_item{base_id = ItemBaseId, quantity = Quantity, target = Target, script_id = ScriptId, args = Args, cooldown = Cooldown},
                            %% 转换BUFF
                            BuffSelf1 = combat_script_buff:convert_buff(BuffSelf),
                            BuffTarget1 = combat_script_buff:convert_buff(BuffTarget),
                            Citem = TmpCitem#c_item{buff_self = BuffSelf1, buff_target = BuffTarget1},
                            case ScriptId of
                                10000 -> Citem#c_item{action = fun script_10000/3};
                                10001 -> Citem#c_item{action = fun script_10001/3};
                                10100 -> Citem#c_item{action = fun script_10100/3};
                                10101 -> Citem#c_item{action = fun script_10101/3};
                                10200 -> Citem#c_item{action = fun script_10200/3};
                                20000 -> Citem#c_item{action = fun script_20000/3};
                                20001 -> Citem#c_item{action = fun script_20001/3};
                                20002 ->
                                    %% Args 应该是： [{NpcBaseId, DmgHpRatio}]
                                    TargetBaseIds = [TargetBaseId || {TargetBaseId, _} <- Args],
                                    Citem#c_item{target_base_ids = TargetBaseIds, args = Args, action = fun script_20002/3};
                                _ -> 
                                    ?ERR("根据物品script_id=~w无法找到合适的脚本", [ScriptId]), 
                                    Citem
                            end;
                        _ -> 
                            ?ERR("转换物品错误，effect格式不对:~w", [ItemEffect]),
                            undefined
                    end
            end;
        _ ->
            ?ERR("转换物品错误，根据基础id=~w找不到物品", [ItemBaseId]),
            undefined
    end.
    
%% 是否技能消耗的物品
is_skill_cost_item(#item{type = ItemType}) ->
    ItemType =/= 39.

%%----------------------------------------------------
%% 生成播放子序列
%%----------------------------------------------------
%%gen_sub_play(
%%    #fighter{id = Sid}, %% 使用者
%%    #fighter{id = Tid}, %% 使用对象
%%    TargetHp,       %% 对象血量变化
%%    TargetMp        %% 对象魔量变化
%%) ->
%%    #skill_play{id = Sid, action_type = 0, attack_type = ?attack_type_range, skill_id = 1005, target_id = Tid, target_hp = TargetHp, target_mp = TargetMp}.

%% 一次过加血
script_10000(#c_item{base_id = ItemId, args = [HealHp]}, Self = #fighter{name = _Sname}, Target = #fighter{pid = Tpid}) ->
    HealHp1 = combat_util:calc_heal(Target, HealHp),
    combat:update_fighter(Tpid, [{hp_changed, HealHp1}]),
    combat:add_sub_play(combat:gen_sub_play(use_item, Self, Target, ItemId, 0, 0, HealHp1, 0)),
    ok.

%% 一次过加血(按照百分比)
script_10001(#c_item{base_id = ItemId, args = [Ratio]}, Self = #fighter{name = _Sname}, Target = #fighter{pid = Tpid, hp_max = ThpMax}) ->
    HealHp = round(ThpMax * Ratio),
    HealHp1 = combat_util:calc_heal(Target, HealHp),
    combat:update_fighter(Tpid, [{hp_changed, HealHp1}]),
    combat:add_sub_play(combat:gen_sub_play(use_item, Self, Target, ItemId, 0, 0, HealHp1, 0)),   
    ok.


%% 一次过加魔法
script_10100(#c_item{base_id = ItemId, args = [HealMp]}, Self = #fighter{name = _Sname}, Target = #fighter{pid = Tpid}) ->
    combat:update_fighter(Tpid, [{mp_changed, HealMp}]),
    combat:add_sub_play(combat:gen_sub_play(use_item, Self, Target, ItemId, 0, 0, 0, HealMp)),
    ok.

%% 一次过加魔法(按照百分比)
script_10101(#c_item{base_id = ItemId, args = [Ratio]}, Self = #fighter{name = _Sname}, Target = #fighter{pid = Tpid, mp_max = TmpMax}) ->
    HealMp = round(TmpMax * Ratio),
    combat:update_fighter(Tpid, [{mp_changed, HealMp}]),
    combat:add_sub_play(combat:gen_sub_play(use_item, Self, Target, ItemId, 0, 0, 0, HealMp)),
    ok.

%% 添加BUFF（包括回合型加血，加魔法）
script_10200(#c_item{base_id = ItemId, buff_self = BuffSelf, buff_target = BuffTarget}, Self, Target) ->
    combat:add_sub_play(combat:gen_sub_play(use_item, Self, Target, ItemId, 0, 0, 0, 0)),
    lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Target) end, BuffSelf),
    lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Target) end, BuffTarget),
    ok.

%% 造成伤害
script_20000(#c_item{base_id = ItemId, args = [DmgHp]}, Self, Target = #fighter{pid = Tpid}) ->
    combat:update_fighter(Tpid, [{hp_changed, -DmgHp}]),
    combat:add_sub_play(combat:gen_sub_play(use_item, Self, Target, ItemId, 0, 0, 0, -DmgHp)),
    ok.

%% 造成伤害（百分比）
script_20001(#c_item{base_id = ItemId, args = [DmgHpRatio]}, Self, Target = #fighter{pid = Tpid, hp_max = HpMax}) ->
    DmgHp = round(HpMax * DmgHpRatio / 100),
    combat:update_fighter(Tpid, [{hp_changed, -DmgHp}]),
    combat:add_sub_play(combat:gen_sub_play(use_item, Self, Target, ItemId, 0, 0, 0, -DmgHp)),
    ok.

%% 造成伤害（指定NpcBaseId，百分比伤害）
script_20002(#c_item{base_id = ItemId, args = Args}, Self, Target = #fighter{type = TargetType, rid = Trid, pid = Tpid, hp_max = HpMax}) ->
    DmgHpRatio = case TargetType of
        ?fighter_type_npc ->
            case lists:keyfind(Trid, 1, Args) of
                {Trid, Ratio} -> Ratio;
                _ -> 0
            end;
        _ -> 0
    end,
    DmgHp = round(HpMax * DmgHpRatio / 100),
    combat:update_fighter(Tpid, [{hp_changed, -DmgHp}]),
    combat:add_sub_play(combat:gen_sub_play(use_item, Self, Target, ItemId, 0, 0, -DmgHp, 0)),
    ok.
