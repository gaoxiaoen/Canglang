%%----------------------------------------------------
%% Author: yqhuang(QQ:19123767)
%% Created: 2011-7-26
%% Description: TODO: 任务模块工具包，与业务逻辑无关的模块
%%----------------------------------------------------
-module(task_util).

-export([
        cond_trg_mapping/1
        ,get_cond_code/1
        ,records_to_lists/1
        ,lists_to_records/1
        ,unixtime/1
        ,get_task_gain/2
        ,calc_finish_imm_gold/2
        ,gain_xx/3
        ,gain_xx/2
        ,ms_mail_content/1
        ,ms_parse_gain/1
        ,convert_arena_career_role/1
    ]
).

-include("common.hrl").
-include("condition.hrl").
-include("task.hrl").
%%
-include("gain.hrl").
-include("attr.hrl").
-include("arena_career.hrl").

%% 条件标签与触发器标签对应关系
cond_trg_mapping(get_item) -> get_item;
cond_trg_mapping(use_item) -> use_item;
cond_trg_mapping(kill_npc) -> kill_npc;
cond_trg_mapping(vip) -> vip;
cond_trg_mapping(get_task) -> get_task;
cond_trg_mapping(finish_task) -> finish_task;
cond_trg_mapping(coin) -> coin;
cond_trg_mapping(get_coin) -> coin;
cond_trg_mapping(lev) -> lev;
cond_trg_mapping(buy_item_store) -> buy_item_store;
cond_trg_mapping(buy_item_shop) -> buy_item_shop;
cond_trg_mapping(special_event) -> special_event;
cond_trg_mapping(make_friend) -> make_friend;
cond_trg_mapping(kill_npc_random) -> kill_npc;
cond_trg_mapping(get_item_random) -> get_item;
cond_trg_mapping(activity) -> activity;
cond_trg_mapping(has_item) -> get_item;
cond_trg_mapping(sweep_dungeon) -> sweep_dungeon;
cond_trg_mapping(ease_dungeon) -> ease_dungeon;
cond_trg_mapping(once_dungeon) -> once_dungeon;
cond_trg_mapping(star_dungeon) -> star_dungeon;
cond_trg_mapping(_Label) -> false. 

%% 获取标签代码 具体情况查看策划文档
get_cond_code(get_item) ->        1;
get_cond_code(use_item) ->        2;
get_cond_code(kill_npc) ->        3;
get_cond_code(vip) ->             4;
get_cond_code(get_task) ->        5;
get_cond_code(finish_task) ->     6;
get_cond_code(coin) ->            7;
get_cond_code(get_coin) ->        8;
get_cond_code(lev) ->             10;
get_cond_code(make_friend) ->     11;
get_cond_code(has_friend) ->      12;
get_cond_code(in_team) ->         13;
get_cond_code(kill_npc_random) -> 14;
get_cond_code(get_item_random) -> 15;
get_cond_code(buy_item_store) ->  16;
get_cond_code(special_event) ->   17;
get_cond_code(has_item) ->        18; %% 貌似不要了
get_cond_code(buy_item_shop) ->   19;
get_cond_code(activity) ->        20;
get_cond_code(sweep_dungeon) ->   21;
get_cond_code(ease_dungeon) ->    22;
get_cond_code(once_dungeon) ->    23;
get_cond_code(star_dungeon) ->    24; %% 星级通关副本
get_cond_code(_Label) ->          99.

%% 将任务进度键值对转化为进度记录
lists_to_records([Item | T]) ->
    Progress = list_to_record(Item),
    [Progress| lists_to_records(T)];
lists_to_records([]) ->
    [].
%% 将记录转化为键值对列表
records_to_lists([Item | T]) ->
    List = record_to_list(Item),
    [List | records_to_lists(T)];
records_to_lists([]) ->
    [].

record_to_list(#task_progress{id = Id, code = Code, trg_label = TrgLabel, cond_label = CondLabel, target = Target, target_value = TargetVal, value = Val, status = Status, map_id = MapId}) ->
    [{id, Id}, {code, Code}, {trg_label, TrgLabel}, {cond_label, CondLabel}, {target, Target}, {target_value, TargetVal}, {value, Val}, {status, Status}, {map_id, MapId}].
list_to_record(List) ->
    R = #task_progress{},
    list_to_record(List, R).
list_to_record([Item | T], Prog) ->
    NewProg = set_prog(Item, Prog),
    list_to_record(T, NewProg);
list_to_record([], Prog) ->
    Prog.
set_prog({id, Id}, Prog) ->
    Prog#task_progress{id = Id};
set_prog({code, Code}, Prog) ->
    Prog#task_progress{code = Code};
set_prog({trg_label, TrgLabel}, Prog) ->
    Prog#task_progress{trg_label = TrgLabel};
set_prog({cond_label, CondLabel}, Prog) ->
    Prog#task_progress{cond_label = CondLabel};
set_prog({target, Target}, Prog) ->
    Prog#task_progress{target = Target};
set_prog({target_value, TargetVal}, Prog) ->
    Prog#task_progress{target_value = TargetVal};
set_prog({value, Val}, Prog) ->
    Prog#task_progress{value = Val};
set_prog({status, Status}, Prog) ->
    Prog#task_progress{status = Status};
set_prog({map_id, MapId}, Prog) ->
    Prog#task_progress{map_id = MapId};
set_prog(_Item, Prog) ->
    Prog.

calc_finish_imm_gold(?task_type_sm, _Lev) -> pay:price(?MODULE, calc_finish_imm_gold, task_type_sm);
calc_finish_imm_gold(?task_type_xx, _Lev) -> pay:price(?MODULE, calc_finish_imm_gold, task_type_xx);
calc_finish_imm_gold(?task_type_bh, _Lev) -> pay:price(?MODULE, calc_finish_imm_gold, task_type_bh).

%% 已接任务进度转换
%% convert_progress(P = #task_progress{trg_label = kill_npc, target = Target, target_value = TargetVal, status = 0}) ->
%%     case lists:member(Target, [20013, 20016, 20017, 20020, 20021, 20023, 20024, 20025, 20027, 20029, 20031, 20033, 20035, 20037, 20039, 20041, 20043, 20045, 20055, 20057, 20059, 20061, 20063]) of
%%         true -> P#task_progress{value = TargetVal, status = 1};
%%         false -> P
%%     end;
%% convert_progress(P) -> P.


%% 获取当天0时0分0秒的时间戳
unixtime(today) ->
    {M, S, MS} = now(),
    {_, Time} = now_to_datetime({M, S, MS}),
    M * 1000000 + S - calendar:time_to_seconds(Time).
now_to_datetime({MSec, Sec, _uSec}) ->
    Sec0 = MSec*1000000 + Sec + 719528 * 86400 + 8 * 3600, %为时区打补丁 8小时的毫秒
    calendar:gregorian_seconds_to_datetime(Sec0).

%% 基础数据
get_task_gain(100, 53) ->
    {ok, #task_gain{
            base_id = 100
            ,lev = 53
            ,list = [{31010, 88}, {31012, 12}]
        }
    };
get_task_gain(100, 58) ->
    {ok, #task_gain{
            base_id = 100
            ,lev = 58
            ,list = [{31010, 85}, {31012, 15}]
        }
    };
get_task_gain(100, 63) ->
    {ok, #task_gain{
            base_id = 100
            ,lev = 63
            ,list = [{31010, 82}, {31012, 18}]
        }
    };
get_task_gain(100, 68) ->
    {ok, #task_gain{
            base_id = 100
            ,lev = 68
            ,list = [{31010, 79}, {31012, 21}]
        }
    };
get_task_gain(100, 73) ->
    {ok, #task_gain{
            base_id = 100
            ,lev = 73
            ,list = [{31010, 76}, {31012, 24}]
        }
    };
get_task_gain(_Key, _Lev) ->
    {false, ?L(<<"没有匹配信息">>)}.

%% @spec gain_xx(Lev, Quality) -> Rewards
%% Lev = Quality = integer()
%% @doc 新的修行任务奖励都是固定3种类型的，这里调用原来的算法
gain_xx(Lev, Quality) ->
    %% 经验
    case gain_xx(Lev, ?task_xx_exp, Quality) of
        {ok, #task_xx_rewards{rewards = Exp}} ->
            %% 阅历
            case gain_xx(Lev, ?task_xx_attainment, Quality) of
                {ok, #task_xx_rewards{rewards = Attain}} ->
                    %% 铜币
                    case gain_xx(Lev, ?task_xx_coin, Quality) of
                        {ok, #task_xx_rewards{rewards = Coin}} ->
                            {ok, Exp ++ Attain ++ Coin};
                        Err ->
                            Err
                    end;
                Err ->
                    Err
            end;
        Err ->
            Err
    end.


%% 修行任务奖励
gain_xx(Lev, ?task_xx_map, Quality) -> %% 宝图任务
    NewLev = Lev div 10 * 10,
    NewLev2 = case NewLev > 70 of
        true -> 70;
        false -> NewLev
    end,
    task_data_xx:get(NewLev2, ?task_xx_map, Quality);
gain_xx(Lev, ?task_xx_pet, Quality) -> %% 宝图任务
    NewLev = Lev div 10 * 10,
    NewLev2 = case NewLev > 70 of
        true -> 70;
        false -> NewLev
    end,
    task_data_xx:get(NewLev2, ?task_xx_pet, Quality);
gain_xx(Lev, SecType, Quality) -> %% 数值任务
    case task_data_xx:get(Lev, SecType, Quality) of
        {ok, XXRewards = #task_xx_rewards{rewards = Rewards}} ->
            NewRewards = gain_xx_convert(Quality, Rewards),
            {ok, XXRewards#task_xx_rewards{rewards = NewRewards}};
        {false, Reason} -> {false, Reason}
    end.
%% 数值任务品质转换
gain_xx_convert(_, []) -> [];
gain_xx_convert(?task_quality_white, [Gain = #gain{val = Val} | T]) when is_integer(Val) ->
    [Gain#gain{val = round(Val * 1.2)} | gain_xx_convert(?task_quality_white, T)];
gain_xx_convert(?task_quality_green, [Gain = #gain{val = Val} | T]) when is_integer(Val) ->
    [Gain#gain{val = round(Val * 1.5)} | gain_xx_convert(?task_quality_green, T)];
gain_xx_convert(?task_quality_blue, [Gain = #gain{val = Val} | T]) when is_integer(Val) ->
    [Gain#gain{val = round(Val * 2)} | gain_xx_convert(?task_quality_blue, T)];
gain_xx_convert(?task_quality_purple, [Gain = #gain{val = Val} | T]) when is_integer(Val) ->
    [Gain#gain{val = round(Val * 2.5)} | gain_xx_convert(?task_quality_purple, T)];
gain_xx_convert(?task_quality_orange, [Gain = #gain{val = Val} | T]) when is_integer(Val) ->
    [Gain#gain{val = round(Val * 3.5)} | gain_xx_convert(?task_quality_orange, T)];
gain_xx_convert(Quality, [Gain | T]) ->
    ?ERR("修行任务奖励匹配有误[Quality:~w, Gain:~w]", [Quality, Gain]),
    [Gain | gain_xx_convert(Quality, T)].

%% 师徒任务
ms_mail_content(84000) ->
    {ok, ?L(<<"请协助徒弟~s进入洛水殿，击杀藏宝老人，徒弟完成任务后，师傅可获奖励，经验：~w 。">>)};
ms_mail_content(84001) ->
    {ok, ?L(<<"请协助徒弟~s进入镇妖塔第一层，击杀玄冰妖，徒弟完成任务后，师傅可获奖励，经验：~w。">>)};
ms_mail_content(84002) ->
    {ok, ?L(<<"请协助徒弟~s进入镇妖塔第二层，击杀赤炎羽，徒弟完成任务后，师傅可获奖励，经验：~w。">>)};
ms_mail_content(84003) ->
    {ok, ?L(<<"请协助徒弟~s进入镇妖塔第三层，击杀流萤雪，徒弟完成任务后，师傅可获奖励，经验：~w。">>)};
ms_mail_content(84004) ->
    {ok, ?L(<<"请协助徒弟~s进入镇妖塔第三层，击杀流萤雪，徒弟完成任务后，师傅可获奖励，经验：~w。">>)};
ms_mail_content(84005) ->
    {ok, ?L(<<"请协助徒弟~s进入葬花岭，击杀葬花魂，徒弟完成任务后，师傅可获奖励，经验：~w。">>)};
ms_mail_content(84006) ->
    {ok, ?L(<<"请协助徒弟~s进入葬花岭，击杀葬花魂，徒弟完成任务后，师傅可获奖励，经验：~w。">>)};
ms_mail_content(84007) ->
    {ok, ?L(<<"请协助徒弟~s进入镇妖塔第五层，击杀罡少白，徒弟完成任务后，师傅可获奖励，经验：~w。">>)};
ms_mail_content(84008) ->
    {ok, ?L(<<"请协助徒弟~s进入镇妖塔第五层，击杀罡少白，徒弟完成任务后，师傅可获奖励，经验：~w。">>)};
ms_mail_content(84009) ->
    {ok, ?L(<<"请协助徒弟~s进入镇妖塔第五层，击杀罡少白，徒弟完成任务后，师傅可获奖励，经验：~w。">>)};
ms_mail_content(TaskId) ->
    {false, util:fbin(?L(<<"没有找到信函信息TaskId:~w">>), [TaskId])}.

%% 师徒任务获取经验和灵力值 {false, Reason} | {ok, Exp, Psy}
ms_parse_gain(TaskId) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{finish_rewards = Rewards}} ->
            case ms_rewards(exp, Rewards) of
                {ok, Exp} -> {ok, Exp};
                {false, Reason} -> {false, Reason}
            end;
        {false, Reason} -> {false, Reason}
    end.
ms_rewards(_Label, []) -> {false, ?L(<<"没找到">>)};
ms_rewards(Label, [#gain{label = Label, val = Val} | _]) when is_integer(Val) -> {ok, Val};
ms_rewards(Label, [_G | T]) ->
    ms_rewards(Label, T).
                    
%% 师门竞技新手引导属性
convert_arena_career_role(Arole = #arena_career_role{attr = #attr{fight_capacity = Fc}}) ->
    Attr = #attr{
        dmg_magic = 0000        %% 附加法术攻击
        ,dmg_ratio = 100        %% 攻击比率，单位：百分率
        ,def_magic = 0          %% 法术防御
        ,escape_rate = 100      %% 逃跑几率
        ,anti_escape = 70       %% 逃跑阻止几率(默认为70)
        ,hit_ratio = 1000       %% 命中修正，单位：千分率
        ,injure_ratio = 100     %% 伤害比率，被人攻击时受到伤害增加或减少，百分率
        ,fight_capacity = Fc    %% 战斗力
        ,js = 44                %% 精神
        ,aspd = 55              %% 攻击速度
        ,dmg_min = 241          %% 最小攻击
        ,dmg_max = 269          %% 最大攻击
        ,defence = 70          %% 防御值
        ,hitrate = 78           %% 攻击命中率，单位:千分率
        ,evasion = 94           %% 闪躲率，单位:千分率
        ,critrate = 81          %% 暴击率，单位:千分率
        ,tenacity = 1           %% 坚韧，单位:千分率
        ,anti_attack = 0.5      %% 反击率
        ,anti_stun = 0          %% 抗眩晕
        ,anti_taunt = 100       %% 抗嘲讽
        ,anti_silent = 0        %% 抗沉默/遗忘
        ,anti_sleep = 0         %% 抗睡眠
        ,anti_stone = 0         %% 抗石化
        ,anti_poison = 0        %% 抗中毒
        ,anti_seal = 0          %% 抗封印
        ,resist_metal = 70      %% 金抗性
        ,resist_wood = 70       %% 木抗性
        ,resist_water = 70      %% 水抗性
        ,resist_fire = 70       %% 火抗性
        ,resist_earth = 170     %% 土抗性
        ,dmg_wuxing = 0         %% 金攻 %% 木攻 %% 水攻 %% 火攻 %% 土攻
        ,asb_metal = 0          %% 金吸收
        ,asb_wood = 0           %% 木吸收
        ,asb_water = 0          %% 水吸收
        ,asb_fire = 0           %% 火吸收
        ,asb_earth = 0          %% 土吸收
    },
    Arole#arena_career_role{hp_max = 3000, mp_max = 3000, attr = Attr}.
