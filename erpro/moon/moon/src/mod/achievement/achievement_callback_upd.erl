%%----------------------------------------------------
%% 成就系统触发器回调模块计算 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(achievement_callback_upd).
-export([
        upd/4
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("achievement.hrl").
-include("vip.hrl").
-include("item.hrl").
-include("sns.hrl").
-include("channel.hrl").
-include("skill.hrl").
-include("npc.hrl").
-include("task.hrl").
-include("pet.hrl").

%% <pre>
%% 当得到物品时，更新任务进度 
%% Item = #item{} 得到的物品
%% </pre>
upd(_AId, _Role, #achievement_progress{cond_label = get_item, value = Value, target_value = TargetVal}, #item{quantity = Q}) ->
    value_inc(Value, Q, TargetVal);

%% <pre>
%% 当得到物品时，更新任务进度 
%% Item = #item{} 得到的物品
%% </pre>
upd(_AId, _Role, #achievement_progress{cond_label = use_item, value = Value, target_value = TargetVal}, #item{quantity = Q}) ->
    value_inc(Value, Q, TargetVal);

%% <pre>
%% 要求金币大于或等于指定值
%% Coin = integer() 角色现有金币数
%% </pre>
upd(_AId, _Role, #achievement_progress{cond_label = coin, value = _Value, target_value = TargetVal}, Coin) ->
    min_value(Coin, TargetVal);

%% <pre>
%% 要求金币大于或等于指定值
%% Coin = integer() 涉及到金币数量,负数为减少数量
%% </pre>
upd(_AId, _Role, #achievement_progress{cond_label = get_coin, value = Value, target_value = TargetVal}, Coin) ->
    case Coin > 0 of
        true ->
            value_inc(Value, Coin, TargetVal);
        false -> %% 负数忽略
            Value
    end;

%% <pre>
%% 要求等级大于或等于指定值
%% Lev = integer() 当前角色等级
%% </pre>
upd(_AId, _Role, #achievement_progress{cond_label = lev, value = _Value, target_value = TargetVal}, Lev) ->
    min_value(Lev, TargetVal);

%% 元神修炼升级 将任意N个元神修炼到X级
upd(_AId, #role{channels = #channels{list = Channels}}, #achievement_progress{cond_label = special_event, target_ext = TargetExt, target_value = TargetVal}, {1004, _SpecArg}) when is_integer(TargetExt) ->
    L = [Channel || Channel <- Channels, Channel#role_channel.lev >= TargetExt],
    min_value(length(L), TargetVal);

%% 元神境界提升 将任意N个元神境界提升到X级
upd(_AId, #role{channels = #channels{list = Channels}}, #achievement_progress{cond_label = special_event, target_ext = TargetExt, target_value = TargetVal}, {20012, _SpecArg}) when is_integer(TargetExt) ->
    L = [Channel || Channel <- Channels, Channel#role_channel.state >= TargetExt * 10],
    min_value(length(L), TargetVal);

%% 阵法变化 N阵法达到X级
upd(_AId, #role{skill = #skill_all{skill_list = Skills}}, #achievement_progress{cond_label = special_event, target_ext = TargetExt, target_value = TargetVal}, {20010, _SpecArg}) when is_integer(TargetExt) ->
    L = [Skill || Skill <- Skills, Skill#skill.type =:= ?type_lineup, Skill#skill.lev >= TargetExt],
    min_value(length(L), TargetVal);

%% 技能变化 N个技能修炼至X级
upd(_AId, Role, #achievement_progress{cond_label = special_event, target_ext = TargetExt, target_value = TargetVal}, {20013, _SpecArg}) when is_integer(TargetExt) ->
    Skills = skill:calc_result_skill(Role),
    L = [Skill || Skill <- Skills, (Skill#skill.type =:= ?type_active orelse Skill#skill.type =:= ?type_passive), Skill#skill.lev >= TargetExt],
    min_value(length(L), TargetVal);

%% 好友亲密度变化
upd(_AId, _Role, #achievement_progress{cond_label = special_event, target_ext = 0, target_value = TargetVal, value = Value}, {20009, _}) ->
    Friends = friend:get_friend_list(),
    case [Friend#friend.intimacy || Friend <- Friends, Friend#friend.type =:= ?sns_friend_type_hy] of
        [] -> Value;
        Intimacys ->
            MaxIntmacys = lists:max(Intimacys),
            min_value(MaxIntmacys, TargetVal)
    end;

%% 拥有N个生死之交好友
upd(_AId, _Role, #achievement_progress{cond_label = special_event, target_ext = TargetExt, target_value = TargetVal}, {20009, _}) ->
    Friends = friend:get_friend_list(),
    MyFriends = [Friend || Friend <- Friends, Friend#friend.type =:= ?sns_friend_type_hy, Friend#friend.intimacy >= TargetExt],
    min_value(length(MyFriends), TargetVal);

%% 宠物指定阶数级别技能数量
upd(_AId, _Role, #achievement_progress{cond_label = special_event, target_ext = [NeedStep, NeedLev], target_value = TargetVal}, {20002, Skills}) ->
    S1 = [pet_data_skill:get(SkillId) || {SkillId, _, _, _} <- Skills],
    S2 = [S || {_, S} <- S1, S#pet_skill.step >= NeedStep, S#pet_skill.lev >= NeedLev],
    min_value(length(S2), TargetVal);

%% 完成某种类型所有成就
upd(AId, #role{achievement = #role_achievement{d_list = DList, finish_list = FList}}, #achievement_progress{cond_label = special_event, target_ext = TargetExt, target_value = TargetVal, value = Value}, {20016, FAId}) ->
    %% ?DEBUG("this_id[~p] finish_id[~p]", [AId, FAId]),
    case achievement_data:get(FAId) of
        {ok, #achievement_base{system_type = ?achievement_system_type, type = TargetExt}} ->
            AllTypes = achievement_data:list(?achievement_system_type, TargetExt),
            Atypes = [Id || Id <- AllTypes, Id =/= AId],
            case check_finish(Atypes, DList, FList) of
                true ->
                    TargetVal;
                false ->
                    Value 
            end;
        _ -> 
            Value 
    end;

%% 双修时间
upd(_AId, _Role, #achievement_progress{cond_label = special_event, target_value = TargetVal}, {20011, AccTime}) when is_integer(AccTime) ->
    %% ?DEBUG("time:[~p]", [erlang:round(AccTime/60)]),
    min_value(erlang:round(AccTime/60), TargetVal);

%% 完成一个特殊任务
%% Arg = {Key, SpecArg}
upd(_AId, _Role, #achievement_progress{cond_label = special_event, target_ext = TargetExt, target_value = TargetVal}, {_Key, SpecArg}) when is_integer(TargetExt) andalso TargetExt > 0 ->
    if
        SpecArg =:= finish -> TargetVal;
        is_integer(SpecArg) andalso TargetExt =< SpecArg -> TargetVal;
        is_integer(SpecArg) -> SpecArg;
        true -> 0
    end;
upd(_AId, _Role, #achievement_progress{cond_label = special_event, target_value = TargetVal}, {_Key, SpecArg}) ->
    if
        SpecArg =:= finish -> TargetVal;
        is_integer(SpecArg) andalso TargetVal =< SpecArg -> TargetVal;
        is_integer(SpecArg) -> SpecArg;
        true -> 0
    end;

%% 完成一个特殊累加任务
%% Arg = {Key, SpecArg}
upd(_AId, _Role, #achievement_progress{cond_label = acc_event, value = Value, target_ext = TargetExt, target_value = TargetVal}, {121, N}) -> %% 帮会副本评分等级
    case TargetExt >= N of
        true -> min_value(Value + 1, TargetVal);
        false -> Value
    end;
upd(_AId, _Role, #achievement_progress{cond_label = acc_event, value = Value, target_ext = TargetExt, target_value = TargetVal}, {124, N}) -> %% 召唤指定品质妖灵数量
    case N =:= TargetExt of
        true -> min_value(Value + 1, TargetVal);
        false -> Value
    end;
upd(_AId, _Role, #achievement_progress{cond_label = acc_event, value = Value, target_ext = TargetExt, target_value = TargetVal}, {118, {N, BaseId}}) when is_integer(N) andalso is_integer(TargetExt) -> %% 合成指定级别以上石头N个
    StoneLev = stone_data:lev(BaseId),
    case StoneLev >= TargetExt of
        true -> min_value(Value + N, TargetVal);
        false -> Value
    end;
upd(_AId, _Role, #achievement_progress{cond_label = acc_event, value = Value, target_value = TargetVal}, {118, {N, _BaseId}}) when is_integer(N) -> %% 四合一成功
    min_value(Value + N, TargetVal);
upd(_AId, _Role, #achievement_progress{cond_label = acc_event, value = Value, target_ext = TargetExt, target_value = TargetVal}, {134, {N, #item{quality = Q}}}) when is_integer(N) andalso is_integer(TargetExt) -> %% 魔晶升级
    case Q >= TargetExt of
        true -> min_value(Value + N, TargetVal);
        false -> Value
    end;
upd(_AId, _Role, #achievement_progress{cond_label = acc_event, value = Value, target_value = TargetVal}, {_Key, {N, _Args}}) when is_integer(N) ->
    %% ?DEBUG("~s--------~p", [_Role#role.name, N]),
    min_value(Value + N, TargetVal);
upd(_AId, _Role, #achievement_progress{cond_label = acc_event, value = Value, target_value = TargetVal}, {_Key, N}) when is_integer(N) ->
    %% ?DEBUG("~s--------~p, ~p", [_Role#role.name, Value, N]),
    min_value(Value + N, TargetVal);
upd(_AId, _Role, #achievement_progress{cond_label = acc_event, value = Value, target_value = TargetVal}, {_Key, _Args}) ->
    min_value(Value + 1, TargetVal);

%% <pre>
%% vip状态改变时，对任务进度状态修改
%% Arg = #vip{} 角色VIP属性
%% NewVal = #task_progress.value 0:非VIP 1:是VIP
%% </pre>
upd(_AId, _Role, #achievement_progress{cond_label = vip, value = _Value, target_value = _TargetVal}, Vip) ->
    case Vip#vip.type =:= ?vip_no of
        true -> 0;
        false -> 1
    end;

%% <pre>
%% 要求杀死指定的NPC N次
%% Npc = #npc{} 被杀NPC
%% Num = integer() 被杀NPC数量
%% NewVal = integer() 新已杀NPC数量
%% </pre>
upd(_AId, _Role, #achievement_progress{cond_label = kill_npc, target_ext = TargetExt, value = Value, target_value = TargetVal}, {NpcBaseId, Num}) when is_list(TargetExt) ->
    case lists:member(NpcBaseId, TargetExt) of
        true -> min_value(Value + Num, TargetVal);
        false -> Value 
    end;

upd(_AId, _Role, #achievement_progress{cond_label = kill_npc, value = Value, target_value = TargetVal}, {_NpcBaseId, Num}) ->
    min_value(Value + Num, TargetVal);

%% 在野外或副本中找到名字上有强化标记的首领怪物
upd(_AId, _Role, #achievement_progress{cond_label = kill_boss, value = Value, target_value = TargetVal}, {_NpcBaseId, Num}) ->
    min_value(Value + Num, TargetVal);

%% 杀BOSS数量
upd(_AId, _Role, #achievement_progress{cond_label = world_boss, value = Value, target_value = TargetVal}, {_NpcBaseId, Num}) ->
    min_value(Value + Num, TargetVal);

%% <pre>
%% 要求完成指定的任务N次
%% @upd_finish_task(Value, TaskId, TargetVal) -> NewVal
%% Value = interger() 已完成次数
%% Arg = TaskId = integer() 完成的任务ID
%% TargetVal = integer() 目标完成次数
%% NewVal = integer() 新已完成次数
%% </pre>
upd(_AId, _Role, #achievement_progress{cond_label = finish_task, value = Value, target_value = TargetVal}, _TaskId) ->
    min_value(Value + 1, TargetVal);

%% 完成某种类型任务
upd(_AId, _Role, #achievement_progress{cond_label = finish_task_type, value = Value, target_ext = TargetExt, target_value = TargetVal}, #task_base{sec_type = SecType}) when is_list(TargetExt) ->
    case lists:member(SecType, TargetExt) of
        true -> min_value(Value + 1, TargetVal);
        false -> Value 
    end;
upd(_AId, _Role, #achievement_progress{cond_label = finish_task_type, value = Value, target_value = TargetVal}, _Task) ->
    min_value(Value + 1, TargetVal);

upd(_AId, _Role, #achievement_progress{cond_label = finish_task_kind, value = Value, target_value = TargetVal}, _Task) ->
    min_value(Value + 1, TargetVal);

%% 到商城买一个物品
upd(_AId, _Role, #achievement_progress{cond_label = buy_item_shop, value = Value, target_value = TargetVal}, _Item = #item{quantity = Quantity}) ->
    min_value(Value + Quantity, TargetVal);

%% 添加N个好友
upd(_AId, _Role, #achievement_progress{cond_label = make_friend, value = Value, target_value = TargetVal}, _Friend) ->
    min_value(Value + 1, TargetVal);

%% 拥有N个好友
upd(_AId, _Role, #achievement_progress{cond_label = has_friend, target_value = TargetVal}, _Friend) ->
    Friends = friend:get_friend_list(),
    MyFriends = [Friend || Friend <- Friends, Friend#friend.type =:= ?sns_friend_type_hy],
    min_value(length(MyFriends), TargetVal);

%% 套装 TODO
upd(_AId, #role{eqm = Eqm}, #achievement_progress{cond_label = eqm_event, target_ext = [suit, NeedLev, NeedEnchant, NeedQuality], target_value = TargetVal}, _Args) ->
    L = [Item || Item <- Eqm, (Item#item.require_lev >= NeedLev orelse NeedLev =:= -1), Item#item.enchant >= NeedEnchant, Item#item.quality >= NeedQuality, lists:member(Item#item.type, ?armor)],
    case length(L) >= length(?armor) of
        true -> TargetVal;
        false -> 0
    end;

%% 防具
upd(_AId, #role{eqm = Eqm}, #achievement_progress{cond_label = eqm_event, target_ext = [armor, NeedLev, NeedEnchant, NeedQuality], target_value = TargetVal}, _Args) ->
    L = [Item || Item <- Eqm, (Item#item.require_lev =:= NeedLev orelse NeedLev =:= -1), Item#item.enchant >= NeedEnchant, (Item#item.quality >= NeedQuality orelse NeedQuality =:= -1), lists:member(Item#item.type, ?armor)],
    case length(L) >= TargetVal of
        true -> TargetVal;
        false -> 0
    end;

%% 武器 
upd(_AId, #role{eqm = Eqm}, #achievement_progress{cond_label = eqm_event, target_ext = [arms, NeedLev, NeedEnchant, NeedQuality], target_value = TargetVal}, _Args) ->
    ArmsL = [1,2,3,4,5],
    L = [Item || Item <- Eqm, (Item#item.require_lev =:= NeedLev orelse NeedLev =:= -1), Item#item.enchant >= NeedEnchant, (Item#item.quality >= NeedQuality orelse NeedQuality =:= -1), lists:member(Item#item.type, ArmsL)],
    case length(L) >= TargetVal of
        true -> TargetVal;
        false -> 0
    end;

%% 装备 指定某些类型
upd(_AId, #role{eqm = Eqm}, #achievement_progress{cond_label = eqm_event, target_ext = [TypeL, NeedLev, NeedEnchant, NeedQuality], target_value = TargetVal}, _Args) when is_list(TypeL) ->
     L = [Item || Item <- Eqm, (Item#item.require_lev =:= NeedLev orelse NeedLev =:= -1), Item#item.enchant >= NeedEnchant, (Item#item.quality >= NeedQuality orelse NeedQuality =:= -1), lists:member(Item#item.type, TypeL)],
    case length(L) >= TargetVal of
        true -> TargetVal;
        false -> 0
    end;

%% 装备 可飞行翅膀
upd(_AId, #role{eqm = Eqm}, #achievement_progress{cond_label = eqm_event, target_ext = wing_fly, target_value = TargetVal}, _Args) ->
    case lists:keyfind(?item_wing, #item.type, Eqm) of
        Item = #item{enchant = Enchant} ->
            Step = wing:get_wing_step(Item),
            case Step >= 6 orelse Enchant >= 10 of
                true -> TargetVal;
                false -> 0
            end;
        _ ->
            0
    end;

%% 装备 指定类型
upd(_AId, #role{eqm = Eqm}, #achievement_progress{cond_label = eqm_event, target_ext = [Type, NeedLev, NeedEnchant, NeedQuality], target_value = TargetVal}, _Args) ->
     L = [Item || Item <- Eqm, (Item#item.require_lev =:= NeedLev orelse NeedLev =:= -1), Item#item.enchant >= NeedEnchant, (Item#item.quality >= NeedQuality orelse NeedQuality =:= -1), Item#item.type =:= Type],
    case length(L) >= TargetVal of
        true -> TargetVal;
        false -> 0
    end;

%% 装备 时装数量
upd(_AId, #role{dress = Dress}, #achievement_progress{cond_label = eqm_event, target_ext = dress, target_value = TargetVal}, _Args) ->
    L = [Item || Item <- Dress, Item#item.type =:= ?item_shi_zhuang],
    min_value(length(L), TargetVal);

%% 翅膀进阶
upd(_AId, #role{eqm = Eqm}, #achievement_progress{cond_label = eqm_event, target_ext = wing_step, value = Value, target_value = TargetVal}, _Args) ->
    case lists:keyfind(?item_wing, #item.type, Eqm) of
        false -> Value;
        Item ->
            Step = wing:get_wing_step(Item),
            case Step > Value of
                true ->
                    min_value(Step, TargetVal);
                _ ->
                    Value
            end
    end;

%% 坐骑进阶
upd(_AId, #role{eqm = Eqm}, #achievement_progress{cond_label = eqm_event, target_ext = mount_step, value = Value, target_value = TargetVal}, _Args) ->
    case lists:keyfind(?item_zuo_qi, #item.type, Eqm) of
        false -> Value;
        #item{extra = Extra} ->
            case lists:keyfind(?extra_mount_grade, 1, Extra) of
                {_, Step, _} when Step > Value ->
                    min_value(Step, TargetVal);
                _ ->
                    Value
            end
    end;

%% 容错函数
upd(AId, _Role, Prg = #achievement_progress{value = Value}, Arg) -> 
    ?ERR("[~p]没有匹配的upd函数Prg:~w, Arg:~w", [AId, Prg, Arg]),
    Value.

%%--------------------------------------------------------------
%% 私有函数
%%--------------------------------------------------------------

%% 返回两个值中较少的
min_value(V1, V2) ->
    case V1 > V2 of
        true -> V2;
        false -> V1
    end.

%% @spec value_inc(V1, V2, TVal) -> Rs
%% @doc
%% <pre>
%% 累加
%% </pre>
value_inc(V1, V2, TVal) ->
    V = V1 + V2,
    case V >= TVal of
        true -> TVal;
        false -> V
    end.

%% 判断指定成就数据是否都已完成
check_finish([], _DList, _FList) -> true;
check_finish([Id | T], DList, FList) ->
    case lists:keyfind(Id, #achievement.id, DList) of
        #achievement{status = Status} when Status >= 1 ->
            check_finish(T, DList, FList);
        _ -> 
            case lists:member(Id, FList) of
                true -> check_finish(T, DList, FList);
                false -> false
            end
    end.

