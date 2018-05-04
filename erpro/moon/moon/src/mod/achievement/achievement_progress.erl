%%----------------------------------------------------
%% 成就系统条件进度转换 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(achievement_progress).
-export([convert/2]).

-include("common.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("condition.hrl").
-include("achievement.hrl").
-include("sns.hrl").
-include("task.hrl").
-include("guild.hrl").
-include("skill.hrl").
-include("channel.hrl").
-include("attr.hrl").
-include("pet.hrl").
-include("item.hrl").
-include("soul_world.hrl").

%% 要求角色等级大于或等于指定值
convert(Cond = #condition{label = lev, target_value = Num}, #role{lev = Lev}) ->
    {Status, Val} = status(Lev, Num),
    convert(Cond, Status, Val);

%% 要求金币大于或等于指定值
convert(Cond = #condition{label = coin, target_value = Num}, #role{assets = #assets{coin = Coin, coin_bind = BCoin}}) -> 
    {Status, Val} = status(Coin + BCoin, Num),
    convert(Cond, Status, Val);

%% 要求拥有N个好友
convert(Cond = #condition{label = has_friend, target_value = Num}, _Role) ->
    FriendList = friend:get_friend_list(),
    FriendHy = [Friend || Friend = #friend{type = Type} <- FriendList, Type =:= ?sns_friend_type_hy],
    {Status, Val} = status(length(FriendHy), Num),
    convert(Cond, Status, Val);

%% 要求完成前置成就功能
convert(Cond = #condition{label = prev, target_value = BaseId}, #role{achievement = #role_achievement{d_list = DList, finish_list = FList}}) ->
    Status = case lists:keyfind(BaseId, #achievement.id, DList) of
        #achievement{status = S} when S >= 1 -> 1;
        _ -> 
            case lists:member(BaseId, FList) of
                true -> 1;
                false -> 0
            end
    end,
    convert(Cond, Status, Status);

%% 要求完成前置成就功能
convert(Cond = #condition{label = prev_val, target_value = BaseId}, #role{achievement = #role_achievement{d_list = DList, finish_list = FList}}) ->
    Status = case lists:keyfind(BaseId, #achievement.id, DList) of
        #achievement{status = S} when S >= 1 -> 1;
        _ -> 
            case lists:member(BaseId, FList) of
                true -> 1;
                false -> 0
            end
    end,
    convert(Cond, Status, Status);

%% 职业要求
convert(Cond = #condition{label = career, target_value = Career}, #role{career = RoleCareer}) ->
    Status = case Career =:= 9 orelse Career =:= RoleCareer of
        true -> 1;
        false -> 0
    end,
    convert(Cond, Status, Status);

%% 判断玩家是否已选择职业
convert(Cond = #condition{label = special_event, target = 1001}, #role{career = RoleCareer}) ->
    Status = case RoleCareer =/= ?career_xinshou of
        true -> 1;
        false -> 0
    end,
    convert(Cond, Status, Status);

%% 判断角色是否已入帮
convert(Cond = #condition{label = special_event, target = 20001}, #role{guild = #role_guild{gid = Gid}}) ->
    Status = case Gid =/= 0 of
        true -> 1;
        false -> 0
    end,
    convert(Cond, Status, Status);

%% 对目标 封印蛟妖 特殊处理
convert(Cond = #condition{label = kill_npc, target = 30005}, #role{lev = Lev}) ->
    Status = case Lev >= 30 of
        true -> 1;
        false -> 0
    end,
    convert(Cond, Status, Status);

%% 判断角色帮贡数值
convert(Cond = #condition{label = special_event, target = 20005, target_value = TargetVal}, #role{guild = #role_guild{devote = Devote}}) ->
    {Status, Val} = status(Devote, TargetVal),
    convert(Cond, Status, Val);

%% 判断角色送花积分
convert(Cond = #condition{label = special_event, target = 20017, target_value = TargetVal}, #role{assets = #assets{flower = Flower}}) ->
    {Status, Val} = status(Flower, TargetVal),
    convert(Cond, Status, Val);

%% 判断角色魅力
convert(Cond = #condition{label = special_event, target = 20018, target_value = TargetVal}, #role{assets = #assets{charm = Charm}}) ->
    {Status, Val} = status(Charm, TargetVal),
    convert(Cond, Status, Val);

%% 判断角色与好友的最大亲密度
convert(Cond = #condition{label = special_event, target = 20009, target_ext = 0, target_value = TargetVal}, #role{}) ->
    N = case friend:get_friend_list() of
        Friends when is_list(Friends) ->
            case [Friend#friend.intimacy || Friend <- Friends, Friend#friend.type =:= ?sns_friend_type_hy] of
                [] -> 0;
                Intimacys -> lists:max(Intimacys)
            end;
        _ -> 0
    end,
    {Status, Val} = status(N, TargetVal),
    convert(Cond, Status, Val);

%% 判断角色生死好友数量
convert(Cond = #condition{label = special_event, target = 20009, target_ext = TargetExt, target_value = TargetVal}, _Role) ->
    N = case friend:get_friend_list() of
        Friends when is_list(Friends) ->
            MyFriends = [Friend || Friend <- Friends, Friend#friend.type =:= ?sns_friend_type_hy, Friend#friend.intimacy >= TargetExt],
            length(MyFriends);
        _ -> 
            0
    end,
    {Status, Val} = status(N, TargetVal),
    convert(Cond, Status, Val);

%% 判断角色双修时间
convert(Cond = #condition{label = special_event, target = 20011, target_value = TargetVal}, #role{assets = #assets{both_time = Time}}) ->
    {Status, Val} = status(erlang:round(Time / 60), TargetVal),
    convert(Cond, Status, Val);

%% 判断角色战斗力
convert(Cond = #condition{label = special_event, target = 20015, target_value = TargetVal}, #role{attr = #attr{fight_capacity = FC}}) ->
    {Status, Val} = status(FC, TargetVal),
    convert(Cond, Status, Val);

%% 元神修炼升级 将任意N个元神修炼到X级
convert(Cond = #condition{label = special_event, target = 1004, target_ext = TargetExt, target_value = TargetVal}, #role{channels = #channels{list = Channels}}) when is_integer(TargetExt) ->
    L = [Channel || Channel <- Channels, Channel#role_channel.lev >= TargetExt],
    {Status, Val} = status(length(L), TargetVal),
    convert(Cond, Status, Val);

%% 元神境界提升 将任意N个元神境界提升到X级
convert(Cond = #condition{label = special_event, target = 20012, target_ext = TargetExt, target_value = TargetVal}, #role{channels = #channels{list = Channels}}) when is_integer(TargetExt) ->
    L = [Channel || Channel <- Channels, Channel#role_channel.state >= TargetExt * 10],
    {Status, Val} = status(length(L), TargetVal),
    convert(Cond, Status, Val);

%% 阵法变化 N阵法达到X级
convert(Cond = #condition{label = special_event, target = 20010, target_ext = TargetExt, target_value = TargetVal}, #role{skill = #skill_all{skill_list = Skills}}) when is_integer(TargetExt) ->
    L = [Skill || Skill <- Skills, Skill#skill.type =:= ?type_lineup, Skill#skill.lev >= TargetExt],
    {Status, Val} = status(length(L), TargetVal),
    convert(Cond, Status, Val);

%% 技能变化 N个技能修炼至X级
convert(Cond = #condition{label = special_event, target = 20013, target_ext = TargetExt, target_value = TargetVal}, Role) when is_integer(TargetExt) ->
    Skills = skill:calc_result_skill(Role),
    L = [Skill || Skill <- Skills, (Skill#skill.type =:= ?type_active orelse Skill#skill.type =:= ?type_passive), Skill#skill.lev >= TargetExt],
    {Status, Val} = status(length(L), TargetVal),
    convert(Cond, Status, Val);

%% 判断宠物等级
convert(Cond = #condition{label = special_event, target = 20006, target_value = TargetVal}, #role{pet = #pet_bag{active = #pet{lev = Lev}}}) ->
    {Status, Val} = status(Lev, TargetVal),
    convert(Cond, Status, Val);

%% 判断宠物战斗力
convert(Cond = #condition{label = special_event, target = 20020, target_value = TargetVal}, #role{pet = #pet_bag{active = #pet{fight_capacity = Fight}}}) ->
    {Status, Val} = status(Fight, TargetVal),
    convert(Cond, Status, Val);

%% 判断宠物成长
convert(Cond = #condition{label = special_event, target = 20023, target_value = TargetVal}, #role{pet = #pet_bag{active = #pet{grow_val = Grow}}}) ->
    {Status, Val} = status(Grow, TargetVal),
    convert(Cond, Status, Val);

%% 判断宠物潜力
convert(Cond = #condition{label = special_event, target = 20021, target_value = TargetVal}, #role{pet = #pet_bag{active = #pet{attr = #pet_attr{avg_val = Avg}}}}) ->
    {Status, Val} = status(Avg, TargetVal),
    convert(Cond, Status, Val);

%% 坐骑战力
convert(Cond = #condition{label = special_event, target = 20024, target_value = TargetVal}, #role{eqm = Eqm}) ->
    N = case lists:keyfind(?item_zuo_qi, #item.type, Eqm) of
        false -> 0;
        Item -> mount:calc_power(Item)
    end,
    {Status, Val} = status(N, TargetVal),
    convert(Cond, Status, Val);

%% 灵戒战力
convert(Cond = #condition{label = special_event, target = 20025, target_value = TargetVal}, Role) ->
    N = soul_world:calc_fight_capacity(Role),
    {Status, Val} = status(N, TargetVal),
    convert(Cond, Status, Val);

%% 妖灵战力
convert(Cond = #condition{label = special_event, target = 20026, target_value = TargetVal}, #role{soul_world = #soul_world{spirits = Spirits}}) when length(Spirits) > 0 ->
    SortL = lists:keysort(#soul_world_spirit.fc, Spirits),
    [#soul_world_spirit{fc = N} | _] = lists:reverse(SortL),
    {Status, Val} = status(N, TargetVal),
    convert(Cond, Status, Val);

%% 神魔阵等级
convert(Cond = #condition{label = special_event, target = 20027, target_value = TargetVal}, #role{soul_world = #soul_world{array_lev = N}}) ->
    {Status, Val} = status(N, TargetVal),
    convert(Cond, Status, Val);

%% 判断宠物技能
convert(Cond = #condition{label = special_event, target = 20021, target_ext = [NeedStep, NeedLev], target_value = TargetVal}, #role{pet = #pet_bag{active = #pet{skill = Skills}}}) ->
    S1 = [pet_data_skill:get(SkillId) || {SkillId, _, _} <- Skills],
    S2 = [S || {_, S} <- S1, S#pet_skill.step >= NeedStep, S#pet_skill.lev >= NeedLev],
    {Status, Val} = status(length(S2), TargetVal),
    convert(Cond, Status, Val);

%% 竞技总杀人数
convert(Cond = #condition{label = special_event, target = 20022, target_value = TargetVal}, #role{rank = L}) ->
    N = case lists:keyfind(33, 1, L) of
        {_, Kill} -> Kill;
        _ -> 0
    end,
    {Status, Val} = status(N, TargetVal),
    convert(Cond, Status, Val);

%% 召唤指定品质妖灵数量
convert(Cond = #condition{label = acc_event, target = 124, target_ext = TargetExt, target_value = TargetVal}, #role{soul_world = #soul_world{spirits = Spirits}}) when is_integer(TargetExt) ->
    L = [Spirit || Spirit = #soul_world_spirit{quality = Quality} <- Spirits, Quality =:= TargetExt],
    {Status, Val} = status(length(L), TargetVal),
    convert(Cond, Status, Val);

%% 要求为VIP状态
convert(Cond = #condition{label = vip}, Role) ->
    Status = case vip:check(Role) of
        true -> 1;
        false -> 0
    end,
    convert(Cond, Status, Status);

%% 要求完成指定任务Num次
convert(Cond = #condition{label = finish_task, target = TaskId, target_value = Num}, _Role) ->
    N = case task_data:get_conf(TaskId) of
        #task_base{type = Type} ->
            case lists:member(Type, [1, 2]) of
                true -> 
                    task:get_count(log, TaskId);
                false -> 
                    task:get_count(log_daily, TaskId)
            end;
        {false, _Reason} -> 
            ?ERR("未定义任务TaskId:~s", [TaskId]),
            0
    end,
    {Status, Val} = status(N, Num),
    convert(Cond, Status, Val);

%% 翅膀阶数
convert(Cond = #condition{label = eqm_event, target_ext = wing_step, target_value = TargetVal}, #role{eqm = Eqm}) ->
    N = case lists:keyfind(?item_wing, #item.type, Eqm) of
        false -> 0;
        Item -> wing:get_wing_step(Item)
    end,
    {Status, Val} = status(N, TargetVal),
    convert(Cond, Status, Val);

%% 坐骑阶数
convert(Cond = #condition{label = eqm_event, target_ext = mount_step, target_value = TargetVal}, #role{eqm = Eqm}) ->
    N = case lists:keyfind(?item_zuo_qi, #item.type, Eqm) of
        false -> 0;
        #item{extra = Extra} ->
            case lists:keyfind(?extra_mount_grade, 1, Extra) of
                {_, Step, _} -> Step;
                _ -> 0
            end
    end,
    {Status, Val} = status(N, TargetVal),
    convert(Cond, Status, Val);

%% 点位函数
convert(Cond = #condition{}, _Role) ->
    convert(Cond, 0, 0);

%% 多个条件转换
convert(Conds, Role) -> 
    do_convert(1, Conds, Role, []).
do_convert(_No, [], _Role, L) -> L;
do_convert(No, [Cond | T], Role, L) ->
    Prog = convert(Cond, Role), 
    do_convert(No + 1, T, Role, [Prog#achievement_progress{code = No} | L]).

%%----------------------------------------------------
%% 内部方法
%%----------------------------------------------------

%% 特殊条件转换
convert(#condition{label = Label, target = Target, target_ext = TargetExt, target_value = TargetVal}, Status, Val) ->
    #achievement_progress{
        trg_label = cond_trg_mapping(Label)
        ,cond_label = Label
        ,target = Target
        ,target_ext = TargetExt
        ,value = Val
        ,target_value = TargetVal
        ,status = Status
    }.

%% 根据当前值与目标值作状态判断
status(Value, TargetVal) ->
    case Value >= TargetVal of
        true -> {1, TargetVal};
        false -> {0, Value}
    end.

%% 条件标签与触发器标签对应关系
cond_trg_mapping(get_item) -> get_item;
cond_trg_mapping(use_item) -> use_item;
cond_trg_mapping(kill_npc) -> kill_npc;
cond_trg_mapping(kill_boss) -> kill_npc;
cond_trg_mapping(world_boss) -> kill_npc;
cond_trg_mapping(vip) -> vip;
cond_trg_mapping(get_task) -> get_task;
cond_trg_mapping(finish_task) -> finish_task;
cond_trg_mapping(finish_task_type) -> finish_task;
cond_trg_mapping(finish_task_kind) -> finish_task;
cond_trg_mapping(coin) -> coin;
cond_trg_mapping(get_coin) -> coin;
cond_trg_mapping(lev) -> lev;
cond_trg_mapping(buy_item_store) -> buy_item_store;
cond_trg_mapping(buy_item_shop) -> buy_item_shop;
cond_trg_mapping(special_event) -> special_event;
cond_trg_mapping(make_friend) -> make_friend;
cond_trg_mapping(has_friend) -> make_friend;
cond_trg_mapping(acc_event) -> acc_event;
cond_trg_mapping(eqm_event) -> eqm_event;
cond_trg_mapping(_Label) -> false. 

