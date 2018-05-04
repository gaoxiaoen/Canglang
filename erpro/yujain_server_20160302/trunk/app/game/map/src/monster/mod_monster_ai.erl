%%-------------------------------------------------------------------
%% File              :mod_monster_ai.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-11-20
%% @doc
%%     怪物AI处理模块
%% @end
%%-------------------------------------------------------------------


-module(mod_monster_ai).


-include("mgeem.hrl").

-export([
         get_ai_trigger_be_attacked/4,
         get_ai_trigger_attack/5,
         reset_ai_data/1
        ]).

%% 重置怪物Ai数据
-spec
reset_ai_data(AiData) -> NewAiData when 
    AiData :: [term()],
    NewAiData :: [term()].
reset_ai_data(AiData) when erlang:is_list(AiData)->
    reset_ai_data(AiData,[]);
reset_ai_data(_AiData) ->
    [].
reset_ai_data([],NewAiData) ->
    NewAiData;
reset_ai_data([Ai | AiData],NewAiData) ->
    case Ai of
        {{Priorty,?MONSTER_AI_TRIGGER_HP,TriggerVal},1} ->
            reset_ai_data(AiData,[{{Priorty,?MONSTER_AI_TRIGGER_HP,TriggerVal},1}|NewAiData]);
        {{Priorty,?MONSTER_AI_TRIGGER_FIRST_FIGHT},1} ->
            reset_ai_data(AiData,[{{Priorty,?MONSTER_AI_TRIGGER_FIRST_FIGHT},1}|NewAiData]);
        _ ->
            reset_ai_data(AiData,NewAiData)
    end.
%% 获取怪物被攻击时，是否有AI触发记录
%% AiId 怪物AI方案ID
-spec 
get_ai_trigger_be_attacked(MonsterId,AiId,AiData,FightAttr) -> {NewAiTrigger,NewAiData} when
    MonsterId :: integer,
    AiId :: integer,
    AiData :: [{key,value}],
    FightAttr :: #p_fight_attr{},
    NewAiTrigger :: undefined| #r_ai_trigger{},
    NewAiData :: [{key,value}].
get_ai_trigger_be_attacked(0,_MonsterId,AiData,_FightAttr) ->
    {undefined,AiData};
get_ai_trigger_be_attacked(AiId,MonsterId,AiData,FightAttr) ->
    case catch get_ai_trigger_be_attacked2(AiId,MonsterId,AiData,FightAttr) of
        {AiTrigger,NewAiData} ->
            {AiTrigger,NewAiData};
        _ ->
            {undefined,AiData}
    end.
get_ai_trigger_be_attacked2(AiId,MonsterId,AiData,FightAttr) ->
    case cfg_monster_ai:find(AiId) of
        undefined ->
            AiList = [],
            erlang:throw(false);
        #r_ai{ai_list=AiListT} ->
            AiList = 
                lists:sort(
                  fun(#r_ai_trigger{priority=PriorityA},#r_ai_trigger{priority=PriorityB}) ->
                          PriorityA < PriorityB
                  end, [AiTrigger || #r_ai_trigger{trigger_type=TriggerType} = AiTrigger <- AiListT,
                                     TriggerType == ?MONSTER_AI_TRIGGER_BE_ATTACKED])
    end,
    #p_fight_attr{hp=Hp}=FightAttr,
    case Hp > 0 of
        true ->
            next;
        false ->
            erlang:throw(false)
    end,
    Now = mgeem_map:get_now2(),
    get_ai_trigger_be_attacked3(do,AiList,MonsterId,Now,FightAttr,undefined,AiData).
    
get_ai_trigger_be_attacked3(done,_AiList,_MonsterId,_Now,_FightAttr,NewAiTrigger,NewAiData) ->
    {NewAiTrigger,NewAiData};
get_ai_trigger_be_attacked3(_Type,[],_MonsterId,_Now,_FightAttr,NewAiTrigger,NewAiData) ->
    {NewAiTrigger,NewAiData};
get_ai_trigger_be_attacked3(do,[AiTrigger|AiList],MonsterId,Now,FightAttr,NewAiTrigger,AiData) ->
    case catch get_ai_trigger_be_attacked4(AiTrigger,MonsterId,Now,FightAttr,AiData) of
        {true,NewAiData} ->
            get_ai_trigger_be_attacked3(done,AiList,MonsterId,Now,FightAttr,AiTrigger,NewAiData);
        {false,NewAiData} ->
            get_ai_trigger_be_attacked3(do,AiList,MonsterId,Now,FightAttr,NewAiTrigger,NewAiData);
        false ->
            get_ai_trigger_be_attacked3(do,AiList,MonsterId,Now,FightAttr,NewAiTrigger,AiData)
    end.
get_ai_trigger_be_attacked4(AiTrigger,MonsterId,Now,FightAttr,AiData) ->
    #r_ai_trigger{priority=Priority,
                  trigger_type=TriggerType,
                  trigger_val_1=TriggerVal1,
                  event_type=EventType} = AiTrigger,
    Key = {Priority,TriggerType,EventType},
    case lists:keyfind(Key, 1, AiData) of
        false ->
            next;
        _ ->
            erlang:throw(false)
    end,
    NewAiData= [{Key,1} | AiData],
    case TriggerVal1 > common_tool:random(1, 10000) of
        true ->
            Flag = (catch filter_ai_trigger_event(AiTrigger,MonsterId,Now,FightAttr)),
            {Flag,NewAiData};
        _ ->
            {false,NewAiData}
    end.
    

%% 获取怪物攻击AI Trigger
%% FightTime 怪物进入战斗时间，单位：毫秒
-spec
get_ai_trigger_attack(AiId,MonsterId,FightTime,AiData,FightAttr) -> {AiTrigger,NewAiData} when
    AiId :: integer,
    MonsterId :: integer,
    FightTime :: integer,
    AiData :: [{key,value}],
    FightAttr :: #p_fight_attr{},
    AiTrigger ::  undefined | #r_ai_trigger{},
    NewAiData :: [{key,value}].
get_ai_trigger_attack(0,_MonsterId,_FightTime,AiData,_FightAttr) ->
    {undefined,AiData};
get_ai_trigger_attack(AiId,MonsterId,FightTime,AiData,FightAttr) ->
    case catch get_ai_trigger_attack2(AiId,MonsterId,FightTime,AiData,FightAttr) of
        {AiTrigger,NewAiData} ->
            {AiTrigger,NewAiData};
        _ ->
            {undefined,AiData}
    end.
get_ai_trigger_attack2(AiId,MonsterId,FightTime,AiData,FightAttr) ->
    case cfg_monster_ai:find(AiId) of
        undefined ->
            AiList = [],
            erlang:throw(invalid_ai_id);
        #r_ai{ai_list=AiList} ->
            next
    end,
    Now = mgeem_map:get_now2(),
    FilterAiList = [ AiTrigger || #r_ai_trigger{trigger_type=TriggerType}=AiTrigger <- AiList, 
                                  TriggerType =/= ?MONSTER_AI_TRIGGER_BE_ATTACKED],
    SortAiList = 
        lists:sort(
          fun(#r_ai_trigger{priority=PriorityA},#r_ai_trigger{priority=PriorityB}) ->
                  PriorityA < PriorityB
          end, FilterAiList),
   get_ai_trigger_attack3(SortAiList,MonsterId,FightTime,Now,FightAttr,undefined,AiData).

get_ai_trigger_attack3([],_MonsterId,_FightTime,_Now,_FightAttr,NewAiTrigger,NewAiData) ->
    {NewAiTrigger,NewAiData};
get_ai_trigger_attack3([AiTrigger| AiList],MonsterId,FightTime,Now,FightAttr,NewAiTrigger,AiData) ->
    case catch filter_ai_trigger(AiTrigger,MonsterId,FightTime,Now,FightAttr,AiData) of
        true ->
            get_ai_trigger_attack3([],MonsterId,FightTime,Now,FightAttr,AiTrigger,AiData);
        {true,NewAiData} ->
            get_ai_trigger_attack3([],MonsterId,FightTime,Now,FightAttr,AiTrigger,NewAiData);
        false ->
            get_ai_trigger_attack3(AiList,MonsterId,FightTime,Now,FightAttr,NewAiTrigger,AiData);
        {false,NewAiData} ->
            get_ai_trigger_attack3(AiList,MonsterId,FightTime,Now,FightAttr,NewAiTrigger,NewAiData)
    end.
%% 检查怪物AI的合法性
%% 使用此函数必须使用 catch 
%% return true | {true,NewAiData} | false | {false,NewAiData} 
filter_ai_trigger(#r_ai_trigger{trigger_type=?MONSTER_AI_TRIGGER_SKILL_CD,
                                event_type=EventType} = AiTrigger,MonsterId,_FightTime,Now,
                  #p_fight_attr{hp=Hp}=FightAttr,_AiData) ->
    case Hp > 0 of
        true ->
            next;
        _ ->
            erlang:throw(false)
    end,
    case EventType of
        ?MONSTER_AI_EVENT_TYPE_SKILL ->
            filter_ai_trigger_event(AiTrigger,MonsterId,Now,FightAttr);
        _ ->
            false
    end;
filter_ai_trigger(#r_ai_trigger{priority=Priorty,
                                trigger_type=?MONSTER_AI_TRIGGER_HP,
                                trigger_val_1=TriggerVal1} = AiTrigger,MonsterId,_FightTime,Now,
                  #p_fight_attr{max_hp=MaxHp,hp=Hp}=FightAttr,AiData) ->
    case Hp > 0 of
        true ->
            next;
        _ ->
            erlang:throw(false)
    end,
    Key = {Priorty,?MONSTER_AI_TRIGGER_HP,TriggerVal1},
    case lists:keyfind(Key,1,AiData) of
        false ->
            next;
        _ ->
            erlang:throw(false)
    end,
    case Hp < erlang:trunc(MaxHp * TriggerVal1 / 100) of
        true ->
            NewAiData = [{Key,1} | AiData],
            Flag = (catch filter_ai_trigger_event(AiTrigger,MonsterId,Now,FightAttr)),
            erlang:throw({Flag,NewAiData});
        _ ->
            erlang:throw(false)
    end,
    true;
filter_ai_trigger(#r_ai_trigger{trigger_type=?MONSTER_AI_TRIGGER_BE_ATTACKED},_MonsterId,_FightTime,_Now,_FightAttr,_AiData) ->
    false;
filter_ai_trigger(#r_ai_trigger{trigger_type=?MONSTER_AI_TRIGGER_FIGHT,
                                trigger_val_1=TriggerVal1} = AiTrigger,MonsterId,_FightTime,Now,
                  #p_fight_attr{hp=Hp} = FightAttr,_AiData) ->
    case Hp > 0 of
        true ->
            next;
        _ ->
            erlang:throw(false)
    end,
    case TriggerVal1 > common_tool:random(1, 10000) of
        true ->
            filter_ai_trigger_event(AiTrigger,MonsterId,Now,FightAttr);
        _ ->
            false
    end;
filter_ai_trigger(#r_ai_trigger{priority=Priorty,
                                trigger_type=?MONSTER_AI_TRIGGER_FIRST_FIGHT,
                                trigger_val_1=TriggerVal1} = AiTrigger,MonsterId,_FightTime,Now,
                  #p_fight_attr{hp=Hp} = FightAttr,AiData) ->
    case Hp > 0 of
        true ->
            next;
        _ ->
            erlang:throw(false)
    end,
    Key = {Priorty,?MONSTER_AI_TRIGGER_FIRST_FIGHT},
    case lists:keyfind(Key,1,AiData) of
        false ->
            next;
        _ ->
            erlang:throw(false)
    end,
    NewAiData = [{Key,1} | AiData],
    case TriggerVal1 > common_tool:random(1, 10000) of
        true ->
            Flag = (catch filter_ai_trigger_event(AiTrigger,MonsterId,Now,FightAttr)),
            {Flag,NewAiData};
        _ ->
            {false,NewAiData}
    end;
filter_ai_trigger(#r_ai_trigger{priority=Priorty,
                                trigger_type=?MONSTER_AI_TRIGGER_TIME_INTERVAL,
                                trigger_val_1=TriggerVal1} = AiTrigger,MonsterId,FightTime,Now,
                  #p_fight_attr{hp=Hp} = FightAttr,AiData) ->
    case Hp > 0 of
        true ->
            next;
        _ ->
            erlang:throw(false)
    end,
    case FightTime > 0 of
        true ->
            next;
        _ ->
            erlang:throw(false)
    end,
    TotalFightTime = Now - FightTime,
    case TotalFightTime > 0 of
        true ->
           Times = TotalFightTime div TriggerVal1;
        _ ->
           Times = 0,
           erlang:throw(false)
    end,
    case Times > 0 of
        true ->
            next;
        _ ->
            erlang:throw(false)
    end,
    Key = {Priorty,?MONSTER_AI_TRIGGER_TIME_INTERVAL,Times},
    case lists:keyfind(Key,1,AiData) of
        false ->
            next;
        _ ->
            erlang:throw(false)
    end,
    NewAiData = [{Key,1} | AiData],
    Flag = (catch filter_ai_trigger_event(AiTrigger,MonsterId,Now,FightAttr)),
    {Flag,NewAiData};
filter_ai_trigger(#r_ai_trigger{priority=Priorty,
                                trigger_type=?MONSTER_AI_TRIGGER_IN_TIME,
                                trigger_val_1=TriggerVal1} = AiTrigger,MonsterId,FightTime,Now,
                  #p_fight_attr{hp=Hp} = FightAttr,AiData) ->
    case Hp > 0 of
        true ->
            next;
        _ ->
            erlang:throw(false)
    end,
    case FightTime > 0 of
        true ->
            next;
        _ ->
            erlang:throw(false)
    end,
    case Now > (FightTime + TriggerVal1) of
        true ->
            next;
        _ ->
            erlang:throw(false)
    end,
    Key = {Priorty,?MONSTER_AI_TRIGGER_IN_TIME,TriggerVal1},
    case lists:keyfind(Key,1,AiData) of
        false ->
            next;
        _ ->
            erlang:throw(false)
    end,
    NewAiData = [{Key,1} | AiData],
    Flag = (catch filter_ai_trigger_event(AiTrigger,MonsterId,Now,FightAttr)),
    {Flag,NewAiData};
filter_ai_trigger(_AiTrigger,_MonsterId,_FightTime,_Now,_FightAttr,_AiData) ->
    false.

%% 过滤AI触发记录中的，事件验证
filter_ai_trigger_event(#r_ai_trigger{event_type=?MONSTER_AI_EVENT_TYPE_SKILL,
                                      event_val_1=EventVal1,
                                      event_val_2=EventVal2},MonsterId,Now,#p_fight_attr{mp=Mp}) ->
    case cfg_skill:find(EventVal1) of
        [] ->
            SkillInfo = undefined,
            erlang:throw(false);
        [SkillInfo] ->
            next
    end,
    SkillCD = mod_fight:get_skill_cd_time(MonsterId, ?ACTOR_TYPE_MONSTER, EventVal1),
    case Now > SkillCD of
        true -> next;
        _ -> erlang:throw(false)
    end,
    %% 添加技能魔法消耗检查
    ConsumeMp = mod_monster_misc:calc_skill_consume_mp(EventVal1, EventVal2, SkillInfo),
    case Mp >= ConsumeMp of
        true -> next;
        _ -> erlang:throw(false)
    end,
    true;
filter_ai_trigger_event(#r_ai_trigger{event_type=?MONSTER_AI_EVENT_TYPE_SUICIDE,
                                      event_val_1=EventVal1},_MonsterId,_Now,_FightAttr) ->
    EventVal1 > common_tool:random(1, 10000);
filter_ai_trigger_event(#r_ai_trigger{event_type=?MONSTER_AI_EVENT_TYPE_FLEE,
                                      event_val_1=EventVal1},_MonsterId,_Now,_FightAttr) ->
    EventVal1 > common_tool:random(1, 10000);
filter_ai_trigger_event(_AiTrigger,_MonsterId,_Now,_FigtAttr) ->
    false.
    