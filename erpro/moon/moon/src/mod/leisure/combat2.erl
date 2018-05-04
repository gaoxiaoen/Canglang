%%----------------------------------------------------
%% 猜拳战斗进程
%% @author wangweibiao
%%         
%% @end
%%----------------------------------------------------
-module(combat2).
-behaviour(gen_fsm).
-export([
        start/3
        ,start/4
        ,start/5
        ,load_event/3
        ,action_event/4
        ,auto_action_event/3
        ,escape_event/2
        ,play_event/2
        ,play_end_calc_event/2
        ,loading/2
        ,round/2
        ,play/2
        ,idel/2
        ,play_end_calc_wait/2
        ,client_ready/2
        ,role_login/1
        ,role_disconnect/1
        ,role_switch/1
        ,u/2
        ,u_ext/1
        ,update_fighter/2
        ,f/2
        ,f/3
        ,add_play/1
        ,buff_add/3
        ,buff_del/2
        ,buff_add_fail/3
        ,add_sub_play/1
        ,commit_sub_play/0
        ,commit_play/0
        ,add_to_hit_history/3
        ,add_to_item_use_history/2
        ,get_item_use_history/2
        ,save_master_dmg/3
        ,fetch_master_dmg/1
        ,set_cost_flag/2
        ,fetch_cost_flag/1
        ,get_skill_history/1
        ,get_all_skill_history/2
        ,get_hit_history/1
        ,get_all_hit_history/2
        ,get_item_use_history/1
        ,get_all_item_use_history/2
        ,check_skill_limit/3
        ,add_to_catch_pet_history/2
        ,get_catch_pet_history/1
        ,get_original_fighter/1
        ,get_original_fighter/2
        ,gen_sub_play/4
        ,gen_sub_play/6
        ,gen_sub_play/8
        ,gen_sub_play/9
        ,gen_sub_play/11
        ,gen_sub_play/12
        ,gen_summon_sub_play/3
        ,add_to_show_passive_skills/3
        ,f_ext/2
        ,f_pet/1
        ,f_master/1
        ,first_round_auto_delay/2
        ,switch_pet/1
        ,add_fighter/4
        ,is_observing/1
        ,stop_observe/2
        ,stop_all_observe/1
        ,last_skill_update/3
        ,add_to_skill_cooldown/2
        ,add_to_skill_cooldown/3
        ,is_skill_in_cooldown/2
        ,is_skill_in_cooldown/3
        ,clear_observe/1
        ,fetch_pet_killed/1
        ,clear_pet_killed/1
        ,add_role_to_npc_dmg/3
        ,add_npc_to_role_dmg/3
        ,add_role_to_role_dmg/3
        ,add_demon_to_npc_dmg/3
        ,get_role_to_role_dmg/1
        ,get_role_to_role_dmg/2
        ,get_dungeon_score_data/2
        ,practice_has_next_wave/0
        ,practice_get_current_wave_no/0
        ,practice_get_all_killed_npc/0
        ,save_pet_status/2
        ,add_to_pet_revive/3
        ,is_illegal_auto_skill/1
        ,get_all_replay/0
        ,has_next_wave/0
        ,distance_check/2
        ,distance_check/6
        ,team_check/1
        ,erase_script_state/1
        ,get_script_state/1
        ,set_script_state/2
        ,get_action_state/2
        ,set_action_state/3
        ,clear_action_state/2
        ,clear_action_state/0
        ,get_fighter_state/2
        ,get_fighter_state/3
        ,set_fighter_state/2
        ,clear_fighter_state/2
        ,add_dynamic_buff/4
        %%TODO 保留
        ,wave_init/2
        ,join_helper_queue/2
        ,escape_with_story_npcs/1
        ,escape_with_demon/1
        ,role_join/3
        ,f_atk_times/2
        ,calc_damage/2
    ]
).
%% 结技能脚本调用
-export([
    get_normal_attack_skill/1
    ,do_skill/4
    ,do_multi/4
]).

-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("combat.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("attr.hrl").
-include("pos.hrl").
-include("pet.hrl").
-include("npc.hrl").
-include("skill.hrl").
-include("story.hrl").
-include("demon.hrl").
-include("leisure.hrl").

-define(leisure_t_round, 15000). %%休闲玩法选招时间

%% ----------------------------------------------------
%% 对外接口
%% ----------------------------------------------------

%% @spec start(Type, AtkList, DfdList) -> ok
%% Type = atom()
%% AtkList = [#converted_fighter()]
%% DfdList = [#converted_fighter()]
%% @doc 启动战斗进程(无裁判)
start(Type, AtkList, DfdList)->
    start(Type, 0, AtkList, DfdList).

%% @spec start(Type, Referee, AtkList, DfdList) -> ok
%% Type = atom()
%% Referee = pid() | [{common, pid()}, {XXX, pid{}} ...]
%% AtkList = [#converted_fighter()]
%% DfdList = [#converted_fighter()] | [NpcBaseId]
%% NpcBaseId = integer() 只有无尽的试炼才会用得上
%% @doc 启动战斗进程(有裁判)
%% start(Type, Referees, AtkList, DfdList) when is_list(Referees) ->
%%     gen_fsm:start(?MODULE, [Type, Referees, AtkList, DfdList], []);
start(Type, Referee, AtkList, DfdList) ->
    start(Type, Referee, AtkList, DfdList, []).

%% Args = [{Key, Val}]
%% Key,Val = {start_wave_no, integer()} | {room_master, {Rid, SrvId}}
start(Type, Referee, AtkList, DfdList, Args) ->
    gen_fsm:start(?MODULE, [Type, Referee, AtkList, DfdList, Args], []).

%% @spec load_event(CombatPid, Pid, Progress) -> ok
%% CombatPid = pid()
%% Pid = pid()
%% Progress = integer()
%% @doc 加载进度事件
load_event(CombatPid, Pid, Progress) ->
    CombatPid ! {loading, Pid, Progress}.

%% @spec action_event(CombatPid, Pid, SkillId, TargetId, ItemId) -> ok
%% CombatPid = pid()
%% Pid = pid()
%% SkillId = integer()
%% TargetId = integer()
%% ItemId = integer()
%% @doc 出招事件
action_event(CombatPid, Pid, SkillId, TargetId) ->
    CombatPid ! {action, Pid, SkillId, TargetId}.

%% @spec auto_action_event(CombatPid, Pid, SkillId, Val) -> ok
%% CombatPid = pid()
%% Pid = pid()
%% SkillId = integer()
%% Val = 0 | 1
%% @doc 改变自动战斗状态
auto_action_event(CombatPid, Pid, Val) ->
    CombatPid ! {auto, Pid, Val}.

%% @spec escape_event(CombatPid, Pid) -> ok
%% CombatPid = pid()
%% Pid = pid()
%% @doc 逃跑事件
escape_event(CombatPid, Pid) ->
    CombatPid ! {escape, Pid}.

%% @spec play_event(CombatPid, Pid) -> ok
%% CombatPid = pid()
%% Pid = pid()
%% @doc 客户端动画播放事件
play_event(CombatPid, Pid) ->
    CombatPid ! {play_done, Pid}.

%% @spec play_end_calc_event(CombatPid, Pid) -> ok
%% CombatPid = pid()
%% Pid = pid()
%% @doc 客户端结算面板播放事件
play_end_calc_event(CombatPid, Pid) ->
    CombatPid ! {play_end_calc_done, Pid}.

%% 客户端已准备事件(重新上线)
client_ready(CombatPid, Pid) ->
    CombatPid ! {client_ready, Pid}.

%% @spec role_login(Role) -> #role{}
%% Role = #role{}
%% @doc 角色重新上线通知
role_login(Role = #role{status = Status, pid = Pid, combat_pid = CombatPid}) ->
    case is_observing(Role) of
        {true, ObserveCombatPid} ->
            ObserveCombatPid ! {observer_interrupt, Pid};
        _ -> ignore
    end,
    case Status of
        ?status_fight ->
            case is_pid(CombatPid) andalso util:is_process_alive(CombatPid) of
                false -> %% 战斗进程异常终止则重设角色状态
                    Role1 = clear_observe(Role),
                    Role1#role{status = ?status_normal, combat_pid = 0}; 
                true -> 
                    CombatPid ! {role_online, Pid, ?true}, 
                    Role
            end;
        _ -> Role
    end.
    
%% 中途加入战斗
%% (#role{}, pid(), group_atk|group_dfd) -> ok | error
role_join(Role = #role{combat_pid = OldCombatPid}, CombatPid, Group) ->
    case is_pid(OldCombatPid) andalso erlang:is_process_alive(OldCombatPid) of
        true ->
            error;
        _ ->
            {ok, CF} = role_convert:do(to_fighter, Role),
            CombatPid ! {role_join, Group, CF},
            ok
    end.

%% @spec disconnect(Role) -> ok
%% Role = #role{}
%% @doc 角色断开连接通知
role_disconnect(Role = #role{pid = Pid, combat_pid = CombatPid}) ->
    case is_pid(CombatPid) of
        false -> ignore;
        true -> CombatPid ! {role_online, Pid, ?false}
    end,
    exit_live(Role),
    ok.

%% @spec role_switch(Role) -> ok
%% Role = #role{}
%% @doc 角色顶号事件处理
role_switch(Role = #role{status = ?status_fight, pid = Pid, combat_pid = CombatPid}) ->
    exit_live(Role),
    case is_pid(CombatPid) andalso util:is_process_alive(CombatPid) of
        false -> Role#role{status = ?status_normal, combat_pid = 0}; %% 战斗进程异常终止则重设角色状态
        true -> CombatPid ! {role_online, Pid, ?true}, Role
    end;
role_switch(Role) -> Role.

%% spec u(F, Group) -> ok
%% F = #fighter{}
%% Group = atom()
%% @doc 更新指定组的参战者数据
u(F = #fighter{id = Id}, Group) ->
    put(Group, lists:keyreplace(Id, #fighter.id, get(Group), F)),
    F.

%% spec u_ext(Fext) -> ok
%% Fext = #fighter_ext_role{} or #fighter_ext_npc{} or #fighter_ext_pet{}
%% @doc 更新参战者扩展信息
u_ext(Fext = #fighter_ext_role{pid = Pid}) ->
    put({fighter_ext, Pid}, Fext),
    Fext;
u_ext(Fext = #fighter_ext_npc{pid = Pid}) ->
    put({fighter_ext, Pid}, Fext),
    Fext;
u_ext(Fext = #fighter_ext_pet{pid = Pid}) ->
    put({fighter_ext, Pid}, Fext),
    Fext.

%% spec update_fighter(Pid, L) -> ok
%% Pid = pid()
%% L = [{Key, Val}...]
%% @doc 更新参战者数据，封装u()
update_fighter(Pid, L) -> 
    case f(by_pid, Pid) of
        {_, F} -> do_update_fighter(F, L);
        _ -> ignore
    end,
    ok.
do_update_fighter(F = #fighter{group = Group}, []) -> u(F, Group);
do_update_fighter(F, [{Key, Val}|T]) ->
    NF = case Key of
        hp ->
            #fighter{hp_max = HpMax} = F,
            NewHp = combat_util:check_range(Val, 0, HpMax),
            IsDie = combat_util:is_die(NewHp),
            case IsDie of
                ?true ->
                    F#fighter{hp = NewHp, is_die = IsDie, die_round = get(current_round)};
                _ ->
                    F#fighter{hp = NewHp, is_die = IsDie}
            end;
        hp_changed ->
            #fighter{hp = Hp, hp_max = HpMax} = F,
            NewHp = combat_util:check_range(Hp + Val, 0, HpMax),
            IsDie = combat_util:is_die(NewHp),
            case IsDie of
                ?true ->
                    F#fighter{hp = NewHp, is_die = IsDie, die_round = get(current_round)};
                _ ->
                    F#fighter{hp = NewHp, is_die = IsDie}
            end;
        mp ->
            #fighter{mp_max = MpMax} = F,
            NewMp = combat_util:check_range(Val, 0, MpMax),
            F#fighter{mp = NewMp};
        mp_changed ->
            #fighter{mp = Mp, mp_max = MpMax} = F,
            NewMp = combat_util:check_range(Mp + Val, 0, MpMax),
            F#fighter{mp = NewMp};
        anger ->
            #fighter{anger_max = AngerMax} = F,
            NewAnger = combat_util:check_range(Val, 0, AngerMax),
            F#fighter{anger = NewAnger};
        anger_changed ->
            #fighter{anger = Anger, anger_max = AngerMax} = F,
            NewAnger = combat_util:check_range(Anger + Val, 0, AngerMax),
            F#fighter{anger = NewAnger};
        power ->
            #fighter{power_max = PowerMax} = F,
            NewPower = combat_util:check_range(Val, 0, PowerMax),
            F#fighter{power = NewPower};
        power_changed ->
            #fighter{power = Power, power_max = PowerMax} = F,
            NewPower = combat_util:check_range(Power + Val, 0, PowerMax),
            F#fighter{power = NewPower};
        is_die ->
            case Val of
                ?true ->
                    F#fighter{is_die = Val, die_round = get(current_round)};
                _ ->
                    F#fighter{is_die = Val}
            end;
        is_escape -> F#fighter{is_escape = Val};
        is_stun -> F#fighter{is_stun = Val};
        is_sleep -> F#fighter{is_sleep = Val};
        is_stone -> F#fighter{is_stone = Val};
        is_taunt -> F#fighter{is_taunt = Val};
        is_silent -> F#fighter{is_silent = Val};
        is_nocrit -> F#fighter{is_nocrit = Val};
        is_nopassive -> F#fighter{is_nopassive = Val};
        is_defencing -> F#fighter{is_defencing = Val};
        heal_ratio ->
            NewHealRatio = util:check_range(Val, 0, 9999999),
            F#fighter{heal_ratio = NewHealRatio};
        stone_dmg_reduce_ratio ->
            NewStoneDmgReduceRatio = util:check_range(Val, 0, 100),
            F#fighter{stone_dmg_reduce_ratio = NewStoneDmgReduceRatio};
        heal_ratio_changed ->
            #fighter{heal_ratio = HealRatio} = F,
            NewHealRatio = util:check_range(HealRatio + Val, 0, 9999999),
            F#fighter{heal_ratio = NewHealRatio};
        protector_pid -> F#fighter{protector_pid = Val};
        taunt_pid -> F#fighter{taunt_pid = Val};
        anti_debuff_injure_changed ->
            #fighter{attr_ext = AttrExt = #attr_ext{anti_debuff_injure = AntiDebuffInjure}} = F,
            NewAntiDebuffInjure = combat_util:check_range(AntiDebuffInjure + Val, 0, 99999),
            F#fighter{attr_ext = AttrExt#attr_ext{anti_debuff_injure = NewAntiDebuffInjure}};
        anti_debuff_atk_changed ->
            #fighter{attr_ext = AttrExt = #attr_ext{anti_debuff_atk = AntiDebuffAtk}} = F,
            NewAntiDebuffAtk = combat_util:check_range(AntiDebuffAtk + Val, 0, 99999),
            F#fighter{attr_ext = AttrExt#attr_ext{anti_debuff_atk = NewAntiDebuffAtk}};
        anti_debuff_hitrate_changed ->
            #fighter{attr_ext = AttrExt = #attr_ext{anti_debuff_hitrate = AntiDebuffHitrate}} = F,
            NewAntiDebuffHitrate = combat_util:check_range(AntiDebuffHitrate + Val, 0, 99999),
            F#fighter{attr_ext = AttrExt#attr_ext{anti_debuff_hitrate = NewAntiDebuffHitrate}};
        anti_debuff_evasion_changed ->
            #fighter{attr_ext = AttrExt = #attr_ext{anti_debuff_evasion = AntiDebuffEvasion}} = F,
            NewAntiDebuffEvasion = combat_util:check_range(AntiDebuffEvasion + Val, 0, 99999),
            F#fighter{attr_ext = AttrExt#attr_ext{anti_debuff_evasion = NewAntiDebuffEvasion}};
        anti_debuff_critrate_changed ->
            #fighter{attr_ext = AttrExt = #attr_ext{anti_debuff_critrate = AntiDebuffCritrate}} = F,
            NewAntiDebuffCritrate = combat_util:check_range(AntiDebuffCritrate + Val, 0, 99999),
            F#fighter{attr_ext = AttrExt#attr_ext{anti_debuff_critrate = NewAntiDebuffCritrate}};
        anti_poison_changed ->
            #fighter{attr = Attr = #attr{anti_poison = AntiPoison}} = F,
            NewAntiPoison = combat_util:check_range(AntiPoison + Val, 0, 99999),
            F#fighter{attr = Attr#attr{anti_poison = NewAntiPoison}};
        shield ->
            F#fighter{shield = Val};
        is_undying ->
            F#fighter{is_undying = Val};
        super_crit ->
            F#fighter{super_crit = Val};
        Other -> 
            ?ERR("暂不支持的属性修改:key=~w,val=~w", [Other, Val]),
            F
    end,
    do_update_fighter(NF, T).


%% @spec add_play(P) -> ok
%% P = #skill_play{} | #buff_play{} | #summon_play{}
%% @doc 增加播放数据到播放列表
add_play(P) when is_record(P, skill_play) ->
    Id = get(play_next_id),
    put(skill_play, [P#skill_play{order = Id} | get(skill_play)]),
    put(play_next_id, Id + 1),
    ok;
add_play(P) when is_record(P, buff_play) ->
    Id = get(play_next_id),
    put(buff_play, [P#buff_play{order = Id} | get(buff_play)]),
    put(play_next_id, Id + 1),
    ok;
add_play(P) when is_record(P, summon_play) ->
    Id = get(play_next_id),
    put(summon_play, [P#summon_play{order = Id} | get(summon_play)]),
    put(play_next_id, Id + 1),
    ok.

%% 增加子播放序列，支持连击
add_sub_play(P) when is_record(P, skill_play) ->
    Id = get(play_next_id),
    SubId = get(sub_play_next_id),
    put(sub_skill_play, [P#skill_play{order = Id, sub_order = SubId} | get(sub_skill_play)]),
    ok;
add_sub_play(P) when is_record(P, buff_play) ->
    Id = get(play_next_id),
    SubId = get(sub_play_next_id),
    put(sub_buff_play, [P#buff_play{order = Id, sub_order = SubId} | get(sub_buff_play)]),
    ok;
add_sub_play(P) when is_record(P, summon_play) ->
    Id = get(play_next_id),
    SubId = get(sub_play_next_id),
    put(sub_summon_play, [P#summon_play{order = Id, sub_order = SubId} | get(sub_summon_play)]),
    ok.

%% 提交子播放序列（通常只有主动连击技能需要照顾到反击、反弹才用到）
commit_sub_play() ->
    LenSkill = length(get(sub_skill_play)),
    LenBuff = length(get(sub_buff_play)),
    LenSummon = length(get(sub_summon_play)),
    if
        LenSkill + LenBuff + LenSummon > 0 ->
            SubId = get(sub_play_next_id),
            put(sub_play_next_id, SubId+1);
        true -> ignore
    end,
    ok.

%% 提交播放序列
commit_play() ->
    Id = get(play_next_id),

    LenSkill = length(get(sub_skill_play)),
    put(skill_play, get(sub_skill_play) ++ get(skill_play)),
    put(sub_skill_play, []),

    LenBuff = length(get(sub_buff_play)),
    put(buff_play, get(sub_buff_play) ++ get(buff_play)),
    put(sub_buff_play, []),

    LenSummon = length(get(sub_summon_play)),
    put(summon_play, get(sub_summon_play) ++ get(summon_play)),
    put(sub_summon_play, []),

    %% 如果有行动数据才让play_next_id+1
    if
        LenSkill + LenBuff + LenSummon > 0 ->
            put(play_next_id, Id + 1);
        true -> ignore
    end,
    put(sub_play_next_id, 1),
    ok.


%% @doc 给指定角色增加一个BUFF并立即触发一次
%% -> ok | error
buff_add(#c_buff{id = Id, duration = Duration}, _Caster, _Target) when Duration < 1 ->
    ?ERR("BUFF[~w]的持续时间设定错误:不能小于1回合", [Id]),
    error;
buff_add(_,
    #fighter{id = Id, name = _Name, hp = Hp, is_die = IsDie, is_escape = IsEscape}, 
    #fighter{id = Id}) when IsDie =:= ?true orelse Hp < 1 orelse IsEscape =:= ?true ->
%% orelse IsStun =:= ?true orelse IsTaunt =:= ?true orelse IsSleep =:= ?true orelse IsStone =:= ?true ->
    %%?DEBUG("参战者[~s]当前状态下无法给自己添加BUFF", [_Name]),
    error;
buff_add(_,
    #fighter{name = _Name1, hp = Hp1, is_die = IsDie1, is_escape = IsEscape1},
    #fighter{name = _Name2, hp = Hp2, is_die = IsDie2, is_escape = IsEscape2}) when IsDie1 =:= ?true orelse Hp1 < 1 orelse IsEscape1 =:= ?true orelse IsDie2 =:= ?true orelse Hp2 < 1 orelse IsEscape2 =:= ?true ->
    %%?DEBUG("参战者[~s]无法给[~s]添加BUFF", [_Name1, _Name2]),
    error;
buff_add(
    Buff = #c_buff{id = Id, type = Type, eff_type = EffType, eff = EffFun, eff_before = BeforeFun, eff_refresh = RefreshFun, compare = Compare, args = _Args},
    #fighter{pid = Cpid, name = _Cname},
    #fighter{pid = Tpid}
) ->
    %% {_, Caster = #fighter{pid = Cpid, name = _Cname}} = f(by_pid, Cpid),
    Caster = get_original_fighter(Cpid),
    {_, Target = #fighter{name = _Tname, group = Group, buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound}} = f(by_pid, Tpid),
    NewBuff = Buff#c_buff{caster = Cpid}, %% 记录施放者
    %% ?DEBUG("[~s]对[~s]增加Buff[~w]成功", [_Cname, _Tname, Id]),
    %% 处理Buff的作用类型，如果新Buff效果更强，则把同类型的BUFF覆盖掉
    case buff_find(Id, Type, Target) of
        false ->
            %% ?DEBUG("旧BUFF效果不存在，执行前置效果"),
            case Type of
                atk ->
                    u(Target#fighter{buff_atk= [NewBuff | BuffAtk]}, Group);
                hit ->
                    u(Target#fighter{buff_hit = [NewBuff | BuffHit]}, Group);
                round ->
                    u(Target#fighter{buff_round = [NewBuff | BuffRound]}, Group);
                atk_hit ->
                    u(Target#fighter{buff_atk = [NewBuff | BuffAtk], buff_hit = [NewBuff | BuffHit]}, Group)
            end,
            put({buff_caster, Tpid, Id}, Caster),
            HasAdded = case BeforeFun of
                undefined -> false;
                _ ->
                    {_, T2} = f(by_pid, Tpid),
                    case catch BeforeFun(NewBuff, Caster, T2) of
                        ok -> true;
                        Err -> 
                            ?ERR("执行Buff[~w]前置效果时发生异常: ~w", [Id, Err]),
                            false
                    end
            end,
            if 
                EffType =:= buff andalso EffFun =/= undefined -> %% 如果有益，则马上生效
                    buff_eff([NewBuff], Tpid);
                Type =/= round andalso EffFun =/= undefined -> %% 如果非回合型，则马上生效
                    buff_eff([NewBuff], Tpid);
                true ->
                    case HasAdded of
                        true -> ignore;
                        false ->
                            case RefreshFun of
                                undefined -> 
                                    ?ERR("Buff Id=~w 没有配置刷新函数", [Id]);
                                _ -> 
                                    {_, T3} = f(by_pid, Tpid),
                                    RefreshFun(NewBuff, Caster, T3)
                            end
                    end
            end,
            ok;
        OldBuff = #c_buff{id = OldId} ->
            Result = case get({buff_caster, Tpid, OldId}) of
                undefined -> 1;
                OldCaster ->
                    Compare(NewBuff, OldBuff, Caster, OldCaster, Target)
            end,
            %% ?DEBUG("旧BUFF效果存在，比较它们的效果"),
            if
                Result > 0 -> %% 新Buff效果更强，覆盖旧Buff
                    %% ?DEBUG("新BUFF效果更强，覆盖旧BUFF"),
                    buff_replace(OldBuff, NewBuff, Tpid, Caster),
                    put({buff_caster, Tpid, Id}, Caster),
                    ok;
                Result =:= 0 -> %% 相同效果，刷新作用时间
                    %% ?DEBUG("旧BUFF效果存在，所以不执行前置效果，只刷新时间"),
                    case Type of
                        atk ->
                            u(Target#fighter{buff_atk = [NewBuff | lists:keydelete(Id, #c_buff.id, BuffAtk)]}, Group);
                        hit ->
                            u(Target#fighter{buff_hit = [NewBuff | lists:keydelete(Id, #c_buff.id, BuffHit)]}, Group);
                        round ->
                            u(Target#fighter{buff_round = [NewBuff | lists:keydelete(Id, #c_buff.id, BuffRound)]}, Group);
                        atk_hit ->
                            u(Target#fighter{buff_atk = [NewBuff | lists:keydelete(Id, #c_buff.id, BuffAtk)], buff_hit = [NewBuff | lists:keydelete(Id, #c_buff.id, BuffHit)]}, Group)
                    end,
                    case RefreshFun of
                        undefined -> ignore; %% add_sub_play(#buff_play{buff_id = Id, duration = Duration, target_id = TargetId});
                        _ -> 
                            {_, T2} = f(by_pid, Tpid),
                            RefreshFun(NewBuff, Caster, T2)
                    end,
                    put({buff_caster, Tpid, Id}, Caster),
                    ok;
                true -> %% 旧效果更强，不覆盖
                    %% ?DEBUG("旧BUFF效果更强，不覆盖"),
                    error
            end
    end.

%% 添加BUFF失败
buff_add_fail(#c_buff{id = Id, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
   combat:add_sub_play(#buff_play{buff_id = Id, duration = Duration, target_id = Tid, is_hit = ?false, tips_args = []}).


%% 查找BUFF列表
buff_find(Id, Type, _Target = #fighter{buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound}) ->
    case Type of
        atk -> lists:keyfind(Id, #c_buff.id, BuffAtk);            
        hit -> lists:keyfind(Id, #c_buff.id, BuffHit);
        round -> lists:keyfind(Id, #c_buff.id, BuffRound);
        atk_hit -> lists:keyfind(Id, #c_buff.id, BuffAtk)
    end.

%% 触发BUFF列表
buff_eff([], _Pid) -> ok;
buff_eff([Buff = #c_buff{id = Id, eff = EffFun} | T], Pid) ->
    case EffFun of
        undefined -> ignore;
        _ ->
            %% 必须取最新的参战者数据
            case get({buff_caster, Pid, Id}) of
                undefined -> ignore;
                Caster ->
                    case f(by_pid, Pid) of
                        {_, F = #fighter{is_die = ?false, is_escape = ?false}} ->
                            case catch EffFun(Buff, Caster, F) of
                                ok -> ok;
                                Err -> ?ERR("执行Buff[~w]触发效果时发生异常: ~w", [Id, Err])
                            end;
                        _ -> ignore
                    end
            end
    end,
    buff_eff(T, Pid).

%% 清除全部的BUFF
clear_all_buff(Pid) ->
    case f(by_pid, Pid) of
        false ->
            ?ERR("清除全部BUFF时发生异常:无法找到参战者[~w]", [Pid]),
            ignore;
        {_, #fighter{buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound}} ->
            lists:foreach(fun(Buff) -> buff_del(Buff, Pid) end, BuffAtk),
            lists:foreach(fun(Buff) -> buff_del(Buff, Pid) end, BuffHit),
            lists:foreach(fun(Buff) -> buff_del(Buff, Pid) end, BuffRound)
    end.

%% 清除指定BUFF
buff_del(Buff = #c_buff{id = Id, type = Type, eff_after = AfterFun}, Tpid) ->
    case f(by_pid, Tpid) of
        false ->
            ?ERR("清除BUFF[~w]时发生异常:无法找到参战者[~w]", [Id, Tpid]),
            ignore;
        {Group, Target = #fighter{buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound}} ->
            case lists:keyfind(Id, #c_buff.id, BuffAtk++BuffHit++BuffRound) of
                false -> ignore;
                _ ->
                    case AfterFun of
                        undefined -> ignore;
                        _ ->
                            case get({buff_caster, Tpid, Id}) of
                                undefined -> 
                                    ?ERR("无法找到buff的施法者[TargetPid=~w, BuffId=~w]", [Tpid, Id]),
                                    ignore;
                                Caster -> 
                                    case catch AfterFun(Buff, Caster, Target) of
                                        ok -> ok;
                                        Err -> ?ERR("执行Buff[~w]结束效果时发生异常: ~w", [Id, Err])
                                    end
                            end
                    end,
                    {_, Target1 = #fighter{id = TargetId, buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound, is_die = IsDie}} = f(by_pid, Tpid),
                    if
                        Type =:= atk -> u(Target1#fighter{buff_atk = lists:keydelete(Id, #c_buff.id, BuffAtk)}, Group);
                        Type =:= hit -> u(Target1#fighter{buff_hit = lists:keydelete(Id, #c_buff.id, BuffHit)}, Group);
                        Type =:= round -> u(Target1#fighter{buff_round = lists:keydelete(Id, #c_buff.id, BuffRound)}, Group);
                        Type =:= atk_hit ->
                            u(Target1#fighter{buff_atk = lists:keydelete(Id, #c_buff.id, BuffAtk), 
                                    buff_hit = lists:keydelete(Id, #c_buff.id, BuffHit)}, Group)
                    end,
                    add_sub_play(#buff_play{buff_id = Id, duration = 0, target_id = TargetId, is_target_die = IsDie})
            end
    end.

%% 替代指定BUFF
buff_replace(OldBuff, NewBuff = #c_buff{id = Id, duration = Duration, type = Type, eff_type = EffType, eff = EffFun, eff_before = BeforeFun, eff_refresh = RefreshFun}, Tpid, Caster) ->
    buff_del(OldBuff, Tpid),
    case f(by_pid, Tpid) of
        false ->
            ?ERR("替代指定BUFF[~w]时发生异常:无法找到参战者[~w]", [Id, Tpid]);
        {Group, Target = #fighter{id = TargetId, buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound}} ->
            case Type of
                atk ->
                    u(Target#fighter{buff_atk= [NewBuff | BuffAtk]}, Group);
                hit ->
                    u(Target#fighter{buff_hit = [NewBuff | BuffHit]}, Group);
                round ->
                    u(Target#fighter{buff_round = [NewBuff | BuffRound]}, Group);
                atk_hit ->
                    u(Target#fighter{buff_atk = [NewBuff | BuffAtk], buff_hit = [NewBuff | BuffHit]}, Group)
            end,
            case BeforeFun of
                undefined -> ignore;
                _ ->
                    {_, T2} = f(by_pid, Tpid),
                    case catch BeforeFun(NewBuff, Caster, T2) of
                        ok -> ok;
                        Err -> ?ERR("执行Buff[~w]前置效果时发生异常: ~w", [Id, Err])
                    end
            end,
            %% 添加后，若BUFF非回合结算才生效或者本身属于有益BUFF，则立即触发一次
            if 
                EffType =:= buff andalso EffFun =/= undefined -> %% 如果有益，则马上生效
                    buff_eff([NewBuff], Tpid);
                Type =/= round andalso EffFun =/= undefined -> %% 如果非回合型，则马上生效
                    buff_eff([NewBuff], Tpid);
                true ->
                    case RefreshFun of
                        undefined -> add_sub_play(#buff_play{buff_id = Id, duration = Duration, target_id = TargetId});
                        _ -> 
                            {_, T3} = f(by_pid, Tpid),
                            RefreshFun(NewBuff, Caster, T3)
                    end
            end
    end.

%% BUFF回合数结算
% buff_calc(Pid) ->
%     case f(by_pid, Pid) of
%         false -> ignore;
%         {_, F = #fighter{name = _Name, buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound}} ->
%             AllBuffs = BuffAtk ++ BuffHit ++ BuffRound,
%             %% ?DEBUG("结算[~s]的BUFF的剩余回合数:~w", [_Name, AllBuffs]),
%             do_buff_calc(AllBuffs, F)
%     end.

% do_buff_calc([], _F) ->ok;
% do_buff_calc([Buff = #c_buff{id = Id, type = Type, eff_type = EffType, duration = Duration, eff_refresh = RefreshFun} | T], F = #fighter{id = TargetId, pid = Pid, name = _Name, is_die = IsDie, hp = Hp, is_escape = IsEscape}) ->
%     if
%         IsDie =:= ?true orelse Hp < 1 ->
%             clear_all_buff(Pid),
%             pet_die([Pid]);
%         IsEscape =:= ?true ->
%             %% ?DEBUG("[~s]已经死亡或者逃离，BUFF自动清除", [_Name]),
%             {Group, F1} = f(by_pid, Pid),
%             u(F1#fighter{buff_atk = [], buff_hit = [], buff_round = []}, Group);
%         true ->
%             case (Duration =< 1) of
%                 true -> 
%                     %% 时辰到就自动消去BUFF
%                     %% ?DEBUG("BUFF[~w]时间到，消去", [Id]),
%                     buff_del(Buff, Pid);
%                 false ->
%                     %% 时辰未到就通知客户端BUFF回合数-1
%                     %% ?DEBUG("BUFF[~w]结算，剩余回合数-1", [Id]),
%                     NewDuration = Duration -1,
%                     NewBuff = Buff#c_buff{duration = NewDuration},
%                     {Group, F1 = #fighter{id = TargetId, buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound}} = f(by_pid, Pid),
%                     case Type of
%                         atk -> 
%                             u(F1#fighter{buff_atk = lists:keyreplace(Id, #c_buff.id, BuffAtk, NewBuff)}, Group);
%                         hit -> 
%                             u(F1#fighter{buff_hit = lists:keyreplace(Id, #c_buff.id, BuffHit, NewBuff)}, Group);
%                         round -> 
%                             u(F1#fighter{buff_round = lists:keyreplace(Id, #c_buff.id, BuffRound, NewBuff)}, Group);
%                         atk_hit -> 
%                             u(F1#fighter{buff_atk = lists:keyreplace(Id, #c_buff.id, BuffAtk, NewBuff), buff_hit = lists:keyreplace(Id, #c_buff.id, BuffHit, NewBuff)}, Group)
%                     end,
%                     %% 触发有益的回合型BUFF
%                     if
%                         Type =:= round andalso EffType =:= buff ->
%                             buff_eff([NewBuff], Pid);
%                         true ->
%                              case RefreshFun of
%                                 undefined -> ?ERR("Buff Id=~w 没有配置刷新函数", [Id]);
%                                 _ -> 
%                                     Caster = get({buff_caster, Pid, Id}),
%                                     {_, F2} = f(by_pid, Pid),
%                                     RefreshFun(NewBuff, Caster, F2)
%                             end
%                     end
%             end
%     end,
%     do_buff_calc(T, F).


%% ----------------------------------------------------
%% 内部调用处理
%% ----------------------------------------------------

%% 处理异常情况
init([Type, _, [], _DfdList, _]) ->
    ?ERR("对发起类型为[~w]的战斗时发生异常: 进攻方列表为空", [Type]),
    set_terminate_reason(enter_failed),
    {stop, normal};
init([Type, _, _AtkList, [], _]) ->
    ?ERR("对发起类型为[~w]的战斗时发生异常: 防守方列表为空", [Type]),
    set_terminate_reason(enter_failed),
    {stop, normal};
%% 正常发起
%% Args = [{key,value}]
init([Type, Referees1, OriginAtkList, OriginDfdList, Args])->
    ?log_init,
    %%?DEBUG("eprof starting..."),
    %%{ok, _Epid} = eprof:start(),
    %%eprof:start_profiling([self()]),
    %%?DEBUG("eprof started"),
    DfdList = OriginDfdList,

    AtkList = OriginAtkList,

    Referees = case is_list(Referees1) of
        true -> Referees1;
        false ->
            case is_pid(Referees1) of
                true -> [{common, Referees1}];
                false -> [{common, 0}]
            end
    end,
    Combat = #combat{
        type = Type,
        pid = self(),
        referees = Referees,
        % t_round = combat_type:calc_combat_round_time(Type, AtkList, DfdList)
        t_round = ?leisure_t_round
    },
    put(original_combat, Combat), %% 把原始的Combat保存起来，有些地方用到
    put(next_fighter_id, 1), %% 初始化下一个参战者ID
    put(is_fighting_super_boss, ?false), %% 是否在打超级世界boss

    %%新手引导
    [If_new_guy] = Args,
    case If_new_guy of 
        ?true ->
            put(if_new_guy, If_new_guy),
            put(new_guy_choose_times, 0);
        _ -> ignore
    end, 

    Atk0 = [#fighter{id = _MainRoleId, pid = MainRolePid, hp = AtkHp} | _] = fighter_init(group_atk, AtkList, Combat),

    Dfd0 = [#fighter{hp = DfdHp}] = fighter_init(group_dfd, DfdList, Combat),

    put(atk_hp, AtkHp),
    put(dfd_hp, DfdHp),

    %%记录主角参战者ID，目前在世界Boss用到
    % put(main_role_id, MainRoleId),

    %% 站位调整
    [ #fighter{x = RefPosX} | _ ] = Dfd0,
    init_pos(RefPosX, Type),  %% 初始化站位基础数据
    Atk = init_fighter_pos(Type, group_atk, Atk0), 
    Dfd = init_fighter_pos(Type, group_dfd, Dfd0),

    %% 处理一些需要根据全部对方数值来设置本方数值的地方
    AtkFinal = special_treat(Atk, Dfd),
    DfdFinal = special_treat(Dfd, Atk),

    %% 初始化进程字典
    put(group_atk, AtkFinal),    %% 进攻方队员
    put(group_dfd, DfdFinal),    %% 防守方队员
    put(group_atk_original, AtkFinal),      %% 进攻方队员原始数据
    put(group_dfd_original, DfdFinal),      %% 防守方队员原始数据
    put(playing, []),       %% 回合数据未播放完成的参战者
    put(play_next_id, 1),   %% 下一个播放序列

    put(current_round, 0),

    put(atk_times, []), %%初始化所有参战者的攻击次数 [{Id, Times}...]
    put(action_play, []), %%初始化播报列表[]


    %% 通知副本进程：战斗开始
    case f_ext(by_pid, MainRolePid) of
        #fighter_ext_role{event = ?event_dungeon, event_pid = DunPid} ->
            dungeon:combat_start(DunPid);
        _ -> ignore
    end,
    self() ! init,
    {ok, loading, Combat#combat{t_play = length(all()) * ?MIN_PLAY_TIME, t_play_max = length(all()) * ?MAX_PLAY_TIME}, ?TIMEOUT_LOADING}.

handle_event(_Event, StateName, Combat) ->
    continue(StateName, Combat).

handle_sync_event(_Event, _From, StateName, Combat) ->
    Reply = ok,
    {reply, Reply, StateName, Combat}.

%% 服务端初始化处理
handle_info(init, _StateName, Combat = #combat{type = CombatType, round = Round, referees = _Referees}) ->
    case all_enter(Combat, all(), []) of %%将role的状态设置为 status_fight
        {false, _Reason, NeedExitRoleList} ->
            case CombatType of
                guard_counter -> skip;
                _ -> ?ERR("发起战斗[类型:~w]失败:~s", [CombatType, _Reason])
            end,
            %% 战斗失败，复位
            NeedExitList = NeedExitRoleList ++ combat_util:filter_fighters(?fighter_type_role, all()),
            lists:foreach(fun(#fighter{pid = Fpid, name = _Name, type = Ftype}) ->
                        case Ftype of
                            ?fighter_type_npc ->
                                case is_pid(Fpid) of
                                    true -> npc:fight_info(Fpid, {stop, enter_fail});
                                    false -> ignore
                                end;
                            ?fighter_type_role ->
                                case is_pid(Fpid) of
                                    true -> 
                                        case catch role:apply(sync, Fpid, {fun enter_combat_failed/2, [self()]}) of
                                            true -> ok;
                                            _Err -> ?ERR("[~s]处理进入战斗失败出错:~w", [_Name, _Err])
                                        end;
                                    false -> ignore
                                end;
                            _ -> ignore
                        end
                end, NeedExitList),
            set_terminate_reason(enter_failed),
            {stop, normal, Combat};
        true ->
            Atk = get(group_atk),
            Dfd = get(group_dfd),
            All = Atk ++ Dfd,
            %% ?DEBUG("发起战斗成功"),
            _ActionFighterOrderList = get_sorted_action_list(), %%先打乱敏捷值，再排序，冒泡排序，从大到小

            ?logif([ ?log("act order: id=~p type=~p name=~s", [_F_id, _F_type, _F_name]) || #fighter{id = _F_id, type = _F_type, name = _F_name} <- _ActionFighterOrderList ]),

            Round2 = case Round of
                0 -> 1;
                _ -> Round
            end,
            %% ?DEBUG("初始化时回合数:~w, All=~w", [Round2, All]),

            %% 通知所有角色开始加载战斗场景 ,全部转化为 #fighter_info结构
            AtkInfos = [do(to_fighter_info, group_atk, F) || F <- Atk],
            DfdInfos = [do(to_fighter_info, group_dfd, F) || F <- Dfd], 
            FighterInfos = AtkInfos ++ DfdInfos,
            {RoleList, _PetList, NpcList} = sort_fighter_infos(FighterInfos),

            %% 保存FighterInfos到进程字典，方便查故障
            put(fighter_infos, FighterInfos),
            pack_cast(All, 19810, {Round2, CombatType, ?enter_combat_type_normal, ?false, RoleList, NpcList}),
            {next_state, loading, Combat#combat{ts = now()}, ?TIMEOUT_LOADING}
    end;

%% 中途加入进攻方
handle_info({role_join, Group, ConvFighter}, StateName, Combat) ->
    case exists_in_role_queue(ConvFighter) of
        true -> join_role_queue(Group, ConvFighter);
        _ -> ignore
    end,
    continue(StateName, Combat);

%% 客户端已经准备好
handle_info({client_ready, _Pid}, play_end_calc_wait, Combat) ->
    continue(play_end_calc_wait, Combat);
handle_info({client_ready, Pid}, StateName, Combat = #combat{type = CombatType, round = Round}) ->
    ?DEBUG("client_ready ................................."),
    put({re_conn, Pid}, true),
    _ActionFighterIdOrderList = fighter_id_action_order(),
    EnterCombatType = case get({enter_combat_type, Pid}) of
        undefined -> ?enter_combat_type_play_done;
        K -> K
    end,
    %% 通知客户端加载战斗场景
    Atk = get(group_atk),
    Dfd = get(group_dfd),
    Atk1 = [do(to_fighter_info, group_atk, F) || F <- Atk],
    Dfd1 = [do(to_fighter_info, group_dfd, F) || F <- Dfd],
    FL = Atk1 ++ Dfd1,
    {RoleList, _PetList, NpcList} = sort_fighter_infos(FL),
    role:pack_send(Pid, 19810, {Round, CombatType, EnterCombatType, ?false, RoleList, NpcList}), 
    continue(StateName, Combat);

% handle_info({client_ready, _Pid}, play_end_calc_wait, Combat) ->
%     continue(play_end_calc_wait, Combat);
% handle_info({client_ready, Pid}, StateName, Combat = #combat{type = CombatType, round = Round, t_round = Tround}) ->
%     ?DEBUG("client_ready ................................."),
%     put({re_conn, Pid}, true),  %% 重连
%     ActionFighterIdOrderList = fighter_id_action_order(),
%     EnterCombatType = case get({enter_combat_type, Pid}) of
%         undefined -> ?enter_combat_type_play_done;
%         K -> K
%     end,
%     %% 通知客户端加载战斗场景
%     Atk = get(group_atk),
%     Dfd = get(group_dfd),
%     Atk1 = [do(to_fighter_info, group_atk, F) || F <- Atk],
%     Dfd1 = [do(to_fighter_info, group_dfd, F) || F <- Dfd],
%     FL = Atk1 ++ Dfd1,
%     {RoleList, PetList, NpcList} = sort_fighter_infos(FL),
%     role:pack_send(Pid, 10710, {Round, Tround div 1000, CombatType, EnterCombatType, ?false, RoleList, PetList, NpcList, ActionFighterIdOrderList}), 
%     continue(StateName, Combat);


%% 角色在线状态变化处理
% handle_info({role_online, _Pid, ?false}, _StateName, Combat = #combat{type = ?combat_type_tutorial}) ->   %% 新手战斗退出时直接关闭战斗（因为新手战斗回合是不限时的，会引起战斗进程永远不退出）
%     {stop, normal, Combat};
% handle_info({role_online, Pid, Val}, StateName, Combat)
% when Val =:= ?true orelse Val =:= ?false ->
%     ?DEBUG("role_online: pid=~w", [Pid]),
%     case f(by_pid, Pid) of   
%         {Group, F = #fighter{name = _Name}} ->
%             %% 不管什么情况，客户端都必须重新加载，所以is_loaded要设成?false
%             u(F#fighter{is_online = Val, is_loaded = ?false}, Group),

%             %% 处理掉线和播放等待，无论刷新还是掉线都不再等他播放完毕
%             %Before = get(playing),
%             kick_offline_fighter_from_playing(Pid),
%             client_ready(self(), Pid),   %% 以前飞仙是客户端发起请求，改为服务端主动推 qingxuan 2013/7/20
%             case StateName =:= play of %% 所有客户端在播放动画中，自己未播放
%                 true -> self() ! {play_done, Pid};
%                 _ -> ignore
%             end,
%             case Val =:= ?false of
%                 true -> remove_from_role_join_queue(Pid);
%                 false -> ignore
%             end,
%             put({enter_combat_type, Pid}, ?enter_combat_type_play_done);
%         _ ->
%             ignore
%     end,
%     continue(StateName, Combat);


handle_info({role_online, _Pid, ?false}, _StateName, Combat = #combat{type = ?combat_type_tutorial}) ->   %% 新手战斗退出时直接关闭战斗（因为新手战斗回合是不限时的，会引起战斗进程永远不退出）
    {stop, normal, Combat};
handle_info({role_online, Pid, Val}, StateName, Combat)
when Val =:= ?true orelse Val =:= ?false ->
    ?DEBUG("role_online: pid=~w", [Pid]),
    case f(by_pid, Pid) of   
        {Group, F = #fighter{name = _Name, is_auto = IsAuto}} ->
            role:pack_send(Pid, 19812, {IsAuto}), 
            %% 不管什么情况，客户端都必须重新加载，所以is_loaded要设成?false
            u(F#fighter{is_online = Val, is_loaded = ?false}, Group),

            %% 处理掉线和播放等待，无论刷新还是掉线都不再等他播放完毕
            %Before = get(playing),
            kick_offline_fighter_from_playing(Pid),
            case Val of
                ?true -> client_ready(self(), Pid);   %% 以前飞仙是客户端发起请求，改为服务端主动推 qingxuan 2013/7/20
                _ -> ignore
            end,
            case StateName =:= play of %% 所有客户端在播放动画中，自己未播放
                true -> self() ! {play_done, Pid};
                _ -> ignore
            end,
            case Val of
                ?false -> remove_from_role_join_queue(Pid);
                _ -> ignore
            end,
            put({enter_combat_type, Pid}, ?enter_combat_type_play_done);
        _ ->
            ignore
    end,
    continue(StateName, Combat);


%% 观战者进入
handle_info({observer_enter, Ob = #c_observer{id = Id, pid = Pid, name = _Name, conn_pid = ConnPid, target_pid = Tpid}}, StateName, Combat = #combat{type = CombatType, round = Round, observer = L}) ->
    {Group, _} =  f(by_pid, Tpid),
    L1 = [do(to_fighter_info, group_atk, F) || F <- get(Group)],
    L2 = [do(to_fighter_info, group_dfd, F) || F <- get(op(Group))],
    FL = L1 ++ L2,
    ActionFighterIdOrderList = fighter_id_action_order(),
    case is_pid(Pid) of
        true ->
            case catch role:apply(sync, Pid, {fun enter_observe/2, [self()]}) of
                {false, Reason} -> 
                    ?ERR("观战者[~s]加入观战失败:[~w]", [_Name, Reason]),
                    continue(StateName, Combat);
                true ->
                    {RoleList, PetList, NpcList} = sort_fighter_infos(FL),
                    sys_conn:pack_send(ConnPid, 10710, {Round, CombatType, ?enter_combat_type_normal, ?true, RoleList, PetList, NpcList, ActionFighterIdOrderList}),
                    continue(StateName, Combat#combat{observer = [Ob | lists:keydelete(Id, #c_observer.id, L)]});
                Err ->
                    ?ERR("观战者[~s]加入观战失败:[~w]", [_Name, Err]),
                    continue(StateName, Combat)
            end;
        false -> continue(StateName, Combat)
    end;

%% 观战者离开
handle_info({observer_exit, Pid}, StateName, Combat = #combat{observer = Observer}) ->
    L = stop_observe(Observer, Pid),
    continue(StateName, Combat#combat{observer = L});

%% 观战者被其他事件中断观战
handle_info({observer_interrupt, Pid}, StateName, Combat = #combat{observer = Observer}) ->
    L = interrupt_observe(Observer, Pid),
    continue(StateName, Combat#combat{observer = L});

%% 处理loading状态下的加载完成事件
%% 如果所有人已完成加载则立即进入战斗回合
handle_info({loading, Pid, Progress}, loading, Combat) when Progress >= 50 ->
    case f(by_pid, Pid) of
        false -> continue(loading, Combat);
        {Group, F = #fighter{id = Id, name = _Name}} ->
            if
                Progress < 100 ->
                    pack_cast(all(), 19811, {Id, Progress}); %%回复客户端 10711
                true ->
                    ok
            end,
            u(F#fighter{is_loaded = ?true}, Group),
            case is_all_ready() of %% 判断 role 的 is_loaded 值是否为 ?true
                false -> 
                    continue(loading, Combat);
                true -> 
                    {next_state, first_round_auto_delay, Combat#combat{ts = erlang:now()}, ?FIRST_ROUND_AUTO_DELAY_TIME} %%第一回合延迟 0.5s
            end
    end;

%% 处理非loading状态下的加载完成事件
%% (现在改成加载到50%就可以出招)
% handle_info({loading, Pid, Progress}, StateName, Combat) when Progress >= 50 ->
%     %%?DEBUG("loading, Progress=~w, StateName=~w", [Progress, StateName]),
%     case f(by_pid, Pid) of
%         false -> ignore;
%         {Group, F = #fighter{id = Id, name = _Name, is_loaded = IsLoaded}} ->
%             if
%                 Progress < 100 ->
%                     %%?DEBUG("客户端[~s]已经加载了~w%，可以进入战斗", [_Name, Progress]),
%                     % pack_cast(all(), 10711, {Id, Progress});
%                     pack_cast(all(), 19811, {Id, Progress}); %%回复客户端 10711
%                 true ->
%                     %%?DEBUG("客户端[~s]已经加载完成", [_Name]),
%                     ok
%             end,
%             %%TODO:暂时改成100%时不发包
%             %% pack_cast(all(), 10711, {Id, Progress}),
%             case IsLoaded of
%                 ?true -> ignore;
%                 _ -> u(F#fighter{is_loaded = ?true}, Group) %% 更新加载状态
%             end
%     end,
%     continue(StateName, Combat);

%% 处理非loading状态下的加载完成事件
%% (现在改成加载到50%就可以出招)
handle_info({loading, Pid, Progress}, StateName, Combat) when Progress >= 50 ->
    % ?DEBUG("LOADING, Progress=~w, StateName=~w~n~n~n~n", [Progress, StateName]),
    case f(by_pid, Pid) of
        false -> ignore;
        {Group, F = #fighter{id = Id, name = _Name, is_loaded = IsLoaded}} ->
            if
                Progress < 100 ->
                    %%?DEBUG("客户端[~s]已经加载了~w%，可以进入战斗", [_Name, Progress]),
                    pack_cast(all(), 19811, {Id, Progress}); %%回复客户端 19811
                true ->
                    %%?DEBUG("客户端[~s]已经加载完成", [_Name]),
                    ok
            end,
            %%TODO:暂时改成100%时不发包
            case get({re_conn, Pid}) of
                true -> 
                    %% 如果是在回合状态下，重发开始出招
                    case StateName of
                        round -> replay_19821(Pid, Combat);
                        _ -> ignore
                    end;
                _ ->
                    ignore
            end,
            case IsLoaded of
                ?true -> ignore;
                _ -> u(F#fighter{is_loaded = ?true}, Group) %% 更新加载状态
            end
    end,
    continue(StateName, Combat);


%% 处理未完成的加载事件，广播给其它玩家
%% (现在改成加载到50%就可以出招)
handle_info({loading, Pid, Progress}, StateName, Combat)  ->
    case f(by_pid, Pid) of
        false -> ignore;
        {_Group, #fighter{id = Id, name = _Name}} ->
            pack_cast(all(), 19811, {Id, Progress}) %%回复客户端 10711
    end,
    continue(StateName, Combat);


%% 处理正常的出招事件
%% action_id :动作的类型，1:蓄力， 2:进攻， 3:格挡
handle_info({action, Pid, ActionId, TargetId}, round, Combat = #combat{type = ?combat_type_leisure, round = Round, ts = Ts, t_round = Tround}) ->
    Result = 
        case f(by_pid, Pid) of
            false ->
                {false, ?MSGID(<<"出招失败，你不在本场战斗中">>)};
            {Group, Atk = #fighter{id = Sid, pid = _Spid, name = _Name}} ->
                N = f_atk_times(by_id, Sid),
                Atk_Data = f_atk(by_id, Sid),
                case lists:keyfind(TargetId, #fighter.id, all()) of
                    Target = #fighter{pid = _Tpid, name = _TargetName} ->
                        case ActionId =:= ?attack andalso N =:= 0 of  %%选择进攻，但是已有的攻击次数为0
                            true ->
                                {false, ?MSGID(<<"出招失败，你的进攻次数为0">>), Atk_Data};
                            false ->
                                {Power, IsCrit} = 
                                    case ActionId =:= ?energy of 
                                        true -> leisure:calc_dmg(Atk, [Target]);
                                        false -> {0, 0}
                                    end,
                                u(Atk#fighter{act = #act{type = ActionId, power = Power, is_crit = IsCrit}}, Group), 
                                role:pack_send(Pid, 19830, {}), %% 通知客户端选招成功
                                true
                        end;
                    _ ->
                        {false, ?MSGID(<<"无效的使用对象">>), Atk_Data}
                end
        end,

    case Result of
        {false, _Reason} ->
            ?DEBUG("---出招异常:--~p~n~n~n", [_Reason]),
            continue(round, Combat);
        {false, Reason, AtkData} ->
            ?log("出招[~p]错误：~s", [ActionId, i18n:text(Reason)]),
            % role:pack_send(Pid, 10730, {?false, Reason}),
            notice:alert(error, Pid, Reason),

            Sec = case is_integer(Tround) of
                true -> util:floor(util:time_left(Tround, Ts) / 1000);
                _ -> 0
            end,
            [#fighter{id = IdDfd}|_] = get(group_dfd),
            Dfd_Data = f_atk(by_id, IdDfd),
            % role:pack_send(Pid, 19821, {Round, Sec, ?true, AtkData, Dfd_Data}),  %% 通知重新出招
            send_19821(Pid, Round, Sec, ?true, AtkData, Dfd_Data),  %% 通知重新出招

            continue(round, Combat);
        true ->
            case is_all_action() of
                false -> continue(round, Combat); %% 仍有未选招的参战者
                true ->
                    action_done(Combat)
            end
    end;

%% 处理异常的出招事件
handle_info({action, _Pid, _SkillId, _TargetId, _Special}, StateName, Combat) ->
    continue(StateName, Combat);

%% 处理播放完成事件
handle_info({play_done, Pid}, play, Combat = #combat{t_play = _TplayMin}) ->
    Playing = lists:delete(Pid, get(playing)), %% 从未播放完成列表中清除
    put(playing, Playing),
    {_, _F = #fighter{name = _Name, is_escape = _IsEscape}} = f(by_pid, Pid),
    ?log("[~s]客户端动画播放完成", [_Name]),
  
    %% 播放途中掉线的人就不等了
    kick_offline_fighter_from_playing(),

    next_round(Combat);

%% 开关自动战斗状态
handle_info({auto, Pid, Val}, StateName, Combat = #combat{round = _Round}) when Val =:= 0 orelse Val =:= 1 ->
    case f(by_pid, Pid) of
        false -> continue(StateName, Combat);
        {Group, F = #fighter{id = _Sid, name = _Name, is_auto = IsAuto}} ->
            if
                IsAuto =/= Val ->
                    ?DEBUG("[~s]改变自动战斗状态为:[~w]", [_Name, Val]),
                    Check = 
                        case StateName of 
                            play -> ok;
                            round -> ok;
                            _ -> false
                        end,
                    case Check of 
                        ok ->
                            u(F#fighter{is_auto = Val}, Group),
                            role:pack_send(Pid, 19812, {Val}), %% 通知客户端改变自动战斗状态成功
                            case StateName of 
                                round ->                             
                                    case is_all_action() of
                                        false -> continue(StateName, Combat);
                                        true ->
                                            % if
                                            %     Round > 1 ->
                                            %         case get(action_done) of
                                            %             undefined ->
                                            %                 action_done(Combat);
                                            %             true ->
                                            %                 continue(StateName, Combat)
                                            %         end;
                                            %     true ->
                                            %         case get(first_round_auto_delay_done) of
                                            %             true -> action_done(Combat);
                                            %             _ -> continue(StateName, Combat)
                                            %         end
                                            % end
                                            action_done(Combat)
                                    end;
                                _ -> 
                                    continue(StateName, Combat)
                            end;
                        _ ->
                            role:pack_send(Pid, 19812, {IsAuto}), %% 通知客户端改变自动战斗状态失败
                            continue(StateName, Combat)
                        end;
                true ->
                    ?DEBUG("[~s]收到改变战斗状态的信息[~p]，与当前状态一样，不处理", [_Name, Val]),
                    role:pack_send(Pid, 19812, {IsAuto}), %% 通知客户端改变自动战斗状态失败
                    continue(StateName, Combat)
            end
    end;

%% 中止战斗
handle_info(stop, play_end_calc_wait, Combat) ->
    continue(play_end_calc_wait, Combat);
handle_info(stop, _StateName, Combat) ->
    Losers = combat_util:filter_fighters([?fighter_type_pet, ?fighter_type_npc], all()),
    Combat1 = Combat#combat{loser = [ F#fighter{result = ?combat_result_abort} || F <- Losers ]},
    {stop, normal, Combat1};

%% 处理播放战斗结算面板完成事件
handle_info({play_end_calc_done, Pid}, play_end_calc_wait, Combat) ->
    L = lists:delete(Pid, get(playing_end_calc)),
    case length(L) =:= 0 of
        true -> 
            %%?DEBUG("全部结算面板播放完毕"),
            {stop, normal, Combat};
        false ->
            put(playing_end_calc, L),
            %%?DEBUG("剩余没有播放完毕的:~w", [L]),
            continue(play_end_calc_wait, Combat)
    end;

%% 打印fighter_infos
handle_info(print_fighter_infos, StateName, Combat) ->
    ?INFO("FighterInfos=~w", [get(fighter_infos)]),
    continue(StateName, Combat);

%% 注册直播
handle_info({register_live, _SrvId}, play_end_calc_wait, Combat) ->
    continue(play_end_calc_wait, Combat);
handle_info({register_live, SrvId}, StateName, Combat = #combat{live_srvs = SrvIds}) ->
    SrvIds1 = case center:is_cross_center() of
        true ->
            DestSrvId = c_mirror_group:get_merge_dest_srv_id(util:to_binary(SrvId)),
            case lists:member(DestSrvId, SrvIds) of
                true -> SrvIds;
                false ->
                    on_live_connected(DestSrvId, Combat),
                    [DestSrvId|SrvIds]
            end;
        false -> SrvIds
    end,
    continue(StateName, Combat#combat{live_srvs = SrvIds1});

handle_info({add_dynamic_buff, RolePid, BuffId, Duration}, StateName, Combat) ->
    case combat_script_buff:get(BuffId) of
        undefined ->
            ?DEBUG("buff ~p not exists!", [BuffId]),
            ignore;
        Buff = #c_buff{duration = _Duration} ->
            case f(by_pid, RolePid) of
                {_, Fighter = #fighter{id = _FighterId}} ->
                    case buff_add(Buff#c_buff{duration = Duration}, Fighter, Fighter) of
                        ok -> 
                            %% TODO 广播给参战者, 新协议
                            ok;
                        _ ->
                            ignore
                    end;
                _ ->
                    ?DEBUG("role ~p not in combat!", [RolePid]),
                    ignore
            end
    end,
    continue(StateName, Combat);

handle_info(_Info, StateName, Combat) ->
    ?DEBUG("在[~w]状态下收到无效消息:~w", [StateName, _Info]),
    continue(StateName, Combat).

%% 战斗结束处理
terminate(Reason, _StateName, Combat) ->
    ?log("战斗进程关闭~p : ~p", [Reason, get(terminate_reason)]),
    ?DEBUG("----战斗进程关闭~p : ~p~n~n~n~n", [Reason, get(terminate_reason)]),
    case Reason of
        normal ->
            case get(terminate_reason) of
                undefined ->
                    % pack_cast(all(), 19890, {?combat_result_abort, ?TIME_END_CALC, []})  %% 通知客户端退出
                    ok;
                enter_failed -> %% 进入战斗失败
                    all_npc_exit_combat(),
                    ok;
                _ ->
                    % all_npc_exit_combat(),
                    % pack_cast(all(), 19890, {?combat_result_abort, 0, []})  %% 通知客户端退出
                    combat_abort(Combat)
            end;
        _Err -> %% 因其他错误而结束
            % all_npc_exit_combat(),
            % pack_cast(all(), 19890, {?combat_result_abort, 0, []})  %% 通知客户端退出
            combat_abort(Combat)
    end,
	ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% ----------------------------------------
%% 战斗中止
combat_abort(_Combat) ->
    [Pid|_] = [Pid ||#fighter{pid = Pid} <- get(group_atk)],
    role:apply(async, Pid, {fun update_status/1, []}),
    ok.

replay_19821(Pid, _Combat = #combat{t_round = Tround, ts = Ts, round = Round}) ->
    case f(by_pid, Pid) of 
        {_, #fighter{id = IdAtk}} ->
            [#fighter{id = IdDfd}|_] = get(group_dfd),
            Dfd_Data = f_atk(by_id, IdDfd),
            Atk_Data = f_atk(by_id, IdAtk),
            Sec = case is_integer(Tround) of
                true -> util:floor(util:time_left(Tround, Ts) / 1000);
                _ -> 0
            end,
            role:pack_send(Pid, 19821, {Round, Sec, ?true, Atk_Data, Dfd_Data});
        _ ->
            ignore
    end.

send_19821(Pid, Round, Sec, IfNeed, Atk_Data, Dfd_Data) ->
    ?DEBUG("--人物蓄力情况---~p~n~n~n", [Atk_Data]),
    ?DEBUG("--怪物蓄力情况---~p~n~n~n", [Dfd_Data]),
    role:pack_send(Pid, 19821, {Round, Sec, IfNeed, Atk_Data, Dfd_Data}).

update_status(Role) ->
    Role1 = Role#role{status = ?status_normal, combat_pid = 0},
    {ok, Role1}.

%% 设置退出原因
set_terminate_reason(Reason) ->
    put(terminate_reason, Reason).

%% 播放战斗结算面板
play_end_calc(Combat = #combat{winner = Winner, loser = Loser, referees = Referees, round = Round}) ->
    Playing = [Pid || #fighter{pid = Pid, type = Type, is_clone = IsClone} <- (Winner ++ Loser), Type =:= ?fighter_type_role andalso IsClone =:= ?false],
    put(playing_end_calc, Playing), %%记录所有需要播报的客户端
    pack_cast(Winner, 19890, {?combat_result_win, ?TIME_END_CALC, []}),  %% 通知客户端退出
    pack_cast(Loser, 19890, {?combat_result_lost, ?TIME_END_CALC, []}),  %% 通知客户端退出

    %%去掉怪
    % Lost = [F||F = #fighter{type = ?fighter_type_npc} <-Loser],
    Referee1 = combat_util:match_param(common, Referees, 0),
    case is_pid(Referee1) of
        true ->
            case Loser of 
                [#fighter{rid = NpcBaseId, type = ?fighter_type_npc}|_] ->  %%怪物失败
                    %% TODO:如果以后人和NPC一起作战，这里可能有问题!!
                    Referee1 ! {combat_over_result, [{kill_npc, [NpcBaseId]}, {round, Round}, {combat_pid, self()}]};
                [#fighter{type = ?fighter_type_role}|_] -> %%人物失败
                    Referee1 ! {combat_over_lost, []};
                _ ->
                    ok
            end;
        false -> ignore
    end,
    combat_abort(Combat),
    {next_state, play_end_calc_wait, Combat#combat{ts = erlang:now()}, ?TIMEOUT_END_CALC}.

%% 给参战者加上抓宠记录
% append_catch_pet(F = #fighter{name = _Name, type = ?fighter_type_role, pid = Pid, is_clone = ?false}) ->
%     case get_catch_pet_history(Pid) of
%         [] -> 
%             %%?DEBUG("[~s]捕捉到的宠物:[]", [_Name]),
%             F;
%         PetNpcBaseIds -> 
%             %%?DEBUG("[~s]捕捉到的宠物:[~w]", [_Name, PetNpcBaseIds]),
%             F#fighter{pet_catch = PetNpcBaseIds}
%     end;
% append_catch_pet(F) ->
%     F.

%% 过滤和特殊处理战斗结果
% filter_combat_result(Combat = #combat{winner = _Winner, loser = _Loser}) ->
%     %% looks,skills等字段就不传过去了，不然报错时日志很大
%     % Winner1 = [append_catch_pet(F) || F <- Winner],
%     % Loser1 = [append_catch_pet(F) || F <- Loser],
%     % Combat#combat{winner = Winner1, loser = Loser1}.
%     Combat.


%% 获取参战者原始数据
%% get_original_fighter(Pid) -> #fighter{} | undefined
%% get_original_fighter(Group, Pid) -> #fighter{} | undefined
%% Group = atom()
%% Pid = pid()
get_original_fighter(Pid) ->
    case lists:keyfind(Pid, #fighter.pid, get(group_atk_original)) of
        false ->
            case lists:keyfind(Pid, #fighter.pid, get(group_dfd_original)) of
                false -> undefined;
                F -> F
            end;
        F -> F
    end.
get_original_fighter(Group, Pid) ->
    case Group of
        group_atk -> 
            case lists:keyfind(Pid, #fighter.pid, get(group_atk_original)) of
                false -> undefined;
                F -> F
            end;
        group_dfd ->
            case lists:keyfind(Pid, #fighter.pid, get(group_dfd_original)) of
                false -> undefined;
                F -> F
            end;
        _ -> undefined
    end.

%% 增加一个原始参战者信息或者替换旧的
replace_original_fighter(F = #fighter{group = Group, pid = Pid}) ->
    case Group of
        group_atk ->
            put(group_atk_original, [F|lists:keydelete(Pid, #fighter.pid, get(group_atk_original))]);
        group_dfd ->
            put(group_dfd_original, [F|lists:keydelete(Pid, #fighter.pid, get(group_dfd_original))]);
        _ -> ignore
    end.


%% 把掉线的人剔除出播放等待列表
kick_offline_fighter_from_playing(Pid) ->
    Playing = get(playing),
    put(playing, lists:delete(Pid, Playing)).

kick_offline_fighter_from_playing() ->
    Playing = get(playing),
    Playing2 = kick_offline_fighter_from_playing([], Playing),
    put(playing, Playing2).

kick_offline_fighter_from_playing(L, []) -> L;
kick_offline_fighter_from_playing(L, [Pid|T]) ->
    case f(by_pid, Pid) of
        {_, #fighter{is_online = IsOnline}} ->
            case IsOnline of
                ?true -> 
                    kick_offline_fighter_from_playing([Pid|L], T);
                ?false -> 
                    kick_offline_fighter_from_playing(L, T)
            end;
        _ -> 
            kick_offline_fighter_from_playing(L, T)
    end.

%% 告诉所有的参战的带有进程的NPC退出战斗
all_npc_exit_combat() ->
    lists:foreach(fun(#fighter{pid = Pid, type = Type}) -> 
                case Type of
                    ?fighter_type_npc ->
                        case is_pid(Pid) of
                            true -> npc:fight_info(Pid, {stop, win});
                            false -> ignore
                        end;
                    _ -> ignore
                end
        end, all()).

%%----------------------------------------------------
%% 宠物处理
%%----------------------------------------------------
%% 保存宠物被杀信息
% save_pet_killed(PetPid) ->
%     case f(by_pid, PetPid) of
%         {_, #fighter{type = ?fighter_type_pet, is_die = ?true}} ->
%             #fighter_ext_pet{original_id = OriginalId} = f_ext(by_pid, PetPid),
%             case f_master(PetPid) of
%                 #fighter{type = ?fighter_type_role, pid = MasterPid, is_clone = ?false} ->
%                     case get({pet_killed, MasterPid}) of
%                         L = [_|_] -> 
%                             case lists:member(OriginalId, L) of
%                                 false -> put({pet_killed, MasterPid}, [OriginalId|L]);
%                                 true -> ignore
%                             end;
%                         _ -> put({pet_killed, MasterPid}, [OriginalId])
%                     end;
%                 _ -> ignore
%             end;
%         _ -> ignore
%     end.

%% 获取宠物被杀信息
fetch_pet_killed(MasterPid) ->
    case get({pet_killed, MasterPid}) of
        L = [_|_] -> L;
        _ -> []
    end.

%% 清除宠物被杀信息
clear_pet_killed(#fighter{pid = Pid}) ->
    put({pet_killed, Pid}, []);
clear_pet_killed(MasterPid) ->
    put({pet_killed, MasterPid}, []).


%%----------------------------------------------------
%% 状态处理
%%----------------------------------------------------

%% 加载超时
loading(timeout, Combat) ->
    %%?DEBUG("加载战场超时，未完成加载的玩家将由系统自动出招"),
    next_round(Combat);
loading(_Any, Combat) ->
    continue(loading, Combat).

%% 回合超时
round(timeout, Combat) ->
    % ?DEBUG("round()---回合超时，所有未出招的参战者将会自动出招~n~n~n"),
    action_done(Combat);
round(_Any, Combat) ->
    % ?DEBUG("round()--进入下一回合~n~n~n"),
    continue(round, Combat).

%% 客户端播放超时
play(timeout, Combat = #combat{type = CombatType, t_play_max = _TplayMax}) ->
    % ?DEBUG("--播放超时，未播放完成的参战者: ~w~n~n~n", [get(playing)]),
    case sys_env:get(is_debug_combat) of
        true ->
            lists:foreach(fun(Name) -> ?INFO("战斗[Type=~w, Pid=~w]播放超时，播放限时:~w，未播放完成的参战者: ~s", [CombatType, self(), _TplayMax, Name]) end, name_list(get(playing)));
        _ -> ignore
    end,
    next_round(Combat);
play(_Any, Combat) ->
    continue(play, Combat).

%% 最小时间间隔已达到，继续下一回合
idel(timeout, Combat) ->
    next_round(Combat);
idel(_Any, Combat) ->
    continue(idel, Combat).

%% 战斗结束，播放结算面板超时
play_end_calc_wait(timeout, Combat) ->
    %%?DEBUG("播放结算面板时间到，结束战斗进程"),
    %% TODO:是否在这里才更新角色的战斗状态?
    {stop, normal, Combat};
play_end_calc_wait(_Any, Combat) ->
    continue(play_end_calc_wait, Combat).

%% 第一回合自动战斗延时
first_round_auto_delay(timeout, Combat) ->
    put(first_round_auto_delay_done, true),
    next_round(Combat);
first_round_auto_delay(_Any, Combat) ->
    continue(first_round_auto_delay, Combat).

%% ----------------------------------------------------
%% ** 生成播报 **
%% ----------------------------------------------------

%% 生成参战者技能播报
gen_sub_play(Type,
    Self,
    Target,
    Skill,
    SelfHp,     %% 攻击者血量变化
    TargetHp,   %% 被攻击者血量变化
    TargetMp,   %% 被攻击者魔量变化
    TargetAnger, %% 被攻击者怒气变化
    IsCrit, %% 是否暴击
    IsHit,  %% 是否命中
    IsDie
) ->
    gen_sub_play(Type, Self, Target, Skill, SelfHp, TargetHp, TargetMp, TargetAnger, IsCrit, IsHit, IsDie, 0).

gen_sub_play(attack,
    #fighter{id = Sid, pid = Spid, talk = Stalk}, %% 攻击者
    #fighter{id = Tid}, %% 被攻击者
    Skill,
    SelfHp,     %% 攻击者血量变化
    TargetHp,   %% 被攻击者血量变化
    TargetMp,   %% 被攻击者魔量变化
    TargetAnger, %% 被攻击者怒气变化
    IsCrit, %% 是否暴击
    IsHit,  %% 是否命中
    IsDie,   %% 被攻击者是否被打死
    TargetPower %% 目标天威值变化
) ->
    {SkillId, AttackType, CostMp, HpShowType, MpShowType, CostAnger} = case Skill of
        #c_skill{id = A, attack_type = B, cost_mp = C, cost_anger = D, show_type = ShowType} -> 
            HpShowType1 = combat_util:match_param(hp, ShowType, 0),
            MpShowType1 = combat_util:match_param(mp, ShowType, 0),
            {A, B, C, HpShowType1, MpShowType1, D};
        #c_pet_skill{id = A1, attack_type = B1, cost_mp = C1} -> {A1, B1, C1, ?show_passive_skills_before, ?show_passive_skills_before, 0}
    end,
    %% 天威值扣除效果
    PowerCost = case Skill of
        #c_skill{script_id = 10700} when SkillId rem 10 =:= 0 ->
            -(4000 + 500 * 9);
        #c_skill{script_id = 10700} ->
            -(4000 + 500 * (SkillId rem 10 - 1));
        _ -> 0
    end,
    FinalCostMp = case fetch_cost_flag(Spid) of
        true -> 0;
        false -> -CostMp
    end,
    Show = get_show_passive_skills(),
    clear_show_passive_skills(),
    Stalk1 = ?L(Stalk),
    ?log("被动技能~p", [Show]),
    #skill_play{id = Sid, action_type = 0, skill_id = SkillId, target_id = Tid, hp = SelfHp, hp_show_type = HpShowType, mp = FinalCostMp, mp_show_type = MpShowType, anger = CostAnger, target_hp = TargetHp, target_mp = TargetMp, target_anger = TargetAnger, attack_type = AttackType, is_crit = IsCrit, is_hit = IsHit, is_target_die = IsDie, talk = Stalk1, show_passive_skills = Show, target_power = TargetPower, power = PowerCost};

%% 生成精灵化形攻击技能播报
gen_sub_play(demon_attack,
    Self, %% 攻击者
    Target, %% 被攻击者
    Skill,
    SelfHp,     %% 攻击者血量变化
    TargetHp,   %% 被攻击者血量变化
    TargetMp,   %% 被攻击者魔量变化
    TargetAnger, %% 被攻击者怒气变化
    IsCrit, %% 是否暴击
    IsHit,  %% 是否命中
    IsDie,   %% 被攻击者是否被打死
    TargetPower %% 目标天威值变化
) ->
    Play = gen_sub_play(attack, Self, Target, Skill, SelfHp, TargetHp, TargetMp, TargetAnger, IsCrit, IsHit, IsDie, TargetPower),
    Play#skill_play{action_type = 6}.

%% 生成使用物品的播报
gen_sub_play(use_item,
    #fighter{id = Sid}, %% 使用者
    #fighter{id = Tid, pid = Tpid}, %% 目标
    ItemId,
    SelfHp,
    SelfMp,
    TargetHp,
    TargetMp
) ->
    IsTargetDie = case is_die(Tpid) of
        {true, _} -> ?true;
        _ -> ?false
    end,
    %% 借skill_id来保存使用物品的id
    #skill_play{id = Sid, action_type = 5, skill_id = ItemId, target_id = Tid, hp = SelfHp, mp = SelfMp, target_hp = TargetHp, target_mp = TargetMp, attack_type = ?attack_type_range, is_hit = ?true, is_target_die = IsTargetDie};
gen_sub_play(anti_attack,
    #fighter{id = Sid, talk = Stalk}, %% 反击者
    #fighter{id = Tid}, %% 被反击者
    TargetHp, %% 被反击的伤害
    TargetAnger,
    IsCrit, %% 是否暴击
    IsHit, %% 是否击中
    IsDie %% 被反击者是否被打死
) ->
    gen_sub_play(anti_attack,
        #fighter{id = Sid, talk = Stalk}, %% 反击者
        #fighter{id = Tid}, %% 被反击者
        TargetHp, %% 被反击的伤害
        TargetAnger,
        IsCrit, %% 是否暴击
        IsHit, %% 是否击中
        IsDie, %% 被反击者是否被打死
        0
    ).

gen_sub_play(anti_attack,
    #fighter{id = Sid, talk = Stalk}, %% 反击者
    #fighter{id = Tid}, %% 被反击者
    TargetHp, %% 被反击的伤害
    TargetAnger,
    IsCrit, %% 是否暴击
    IsHit, %% 是否击中
    IsDie, %% 被反击者是否被打死
    TargetPower %% 目标天威值变化
) ->
    Stalk1 = ?L(Stalk),
    #skill_play{id = Sid, action_type = 1, skill_id = ?skill_attack, target_id = Tid, 
        target_hp = TargetHp, target_anger = TargetAnger, is_hit = IsHit, is_crit = IsCrit, is_target_die = IsDie, talk = Stalk1, target_power = TargetPower}.

gen_sub_play(passive,
    #fighter{id = Sid}, %% 被动技能施放者
    #fighter{id = Tid}, %% 被动技能目标
    Skill
) ->
    {SkillId, AttackType} = case Skill of
        #c_skill{id = A, attack_type = B} -> {A, B};
        #c_pet_skill{id = A1, attack_type = B1} -> {A1, B1}
    end,
    #skill_play{id = Sid, action_type = 4, skill_id = SkillId, target_id = Tid, attack_type = AttackType}.

gen_sub_play(defence, Self, Target, Dmg, CostMp, IsDie) ->
    gen_sub_play(protect, Self, Target, Dmg, CostMp, IsDie);
gen_sub_play(protect,
    #fighter{id = Sid, talk = Stalk}, %% 保护者
    #fighter{id = Tid}, %% 被保护者
    Dmg, %% 保护者受到的伤害
    CostMp, %% 保护者损失的魔法
    IsDie %% 保护者是否被打死
) ->
    Show = get_show_passive_skills(),
    clear_show_passive_skills(),
    Stalk1 = ?L(Stalk),
    ?log("被动技能~p", [Show]),
    #skill_play{id = Sid, action_type = 2, skill_id = ?skill_defence, target_id = Tid, 
        hp = Dmg, mp = CostMp, is_hit = ?true, is_self_die = IsDie, talk = Stalk1, show_passive_skills = Show};

gen_sub_play(feedback,
    #fighter{id = Sid, talk = Stalk}, %% 反伤者
    #fighter{id = Tid}, %% 被反伤者
    Dmg, %% 被反伤的伤害
    IsCrit, %% 是否暴击
    IsDie %% 被反伤者是否被打死
) ->
    Show = get_show_passive_skills(),
    clear_show_passive_skills(),
    Stalk1 = ?L(Stalk),
    ?log("被动技能~p", [Show]),
    #skill_play{id = Sid, action_type = 3, skill_id = ?skill_attack, target_id = Tid, 
        target_hp = Dmg, is_hit = ?true, is_target_die = IsDie, is_crit = IsCrit, talk = Stalk1, show_passive_skills = Show}.

% gen_sub_play(suicide,
%     #fighter{id = Sid} %% 自杀者
% ) ->
%     #skill_play{id = Sid, action_type = 4, skill_id = ?skill_attack, target_id = Sid, is_self_die = ?true, is_target_die = ?true}.

%% 生成参战者召唤播报
gen_summon_sub_play(#c_pet{id = OriginalId}, #fighter{id = Id, name = Name, lev = Lev, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, type = ?fighter_type_pet, x = X, y = Y}, #fighter_ext_pet{master_id = MasterId, skills = Skills, passive_skills = PassiveSkills}) ->
    Skills1 = [{SkillId, SkillLastUse} || #c_skill{id = SkillId, last_use = SkillLastUse} <- Skills],
    PassiveSkills1 = [{SkillId1} || #c_skill{id = SkillId1} <- PassiveSkills],
    #summon_play{summoner_id = MasterId, summons_id = Id, summons_base_id = OriginalId, type = ?fighter_type_pet, name = Name, lev = Lev, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, skills = Skills1, passive_skills = PassiveSkills1, x = X, y = Y};
gen_summon_sub_play(#fighter{id = SummonerId}, #fighter{id = Id, name = Name, lev = Lev, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, type = ?fighter_type_npc, x = X, y = Y}, #fighter_ext_npc{npc_base_id = NpcBaseId, skills = Skills, passive_skills = PassiveSkills}) ->
    Skills1 = [{SkillId, SkillLastUse} || #c_skill{id = SkillId, last_use = SkillLastUse} <- Skills],
    PassiveSkills1 = [{SkillId1} || #c_skill{id = SkillId1} <- PassiveSkills],
    #summon_play{summoner_id = SummonerId, summons_id = Id, summons_base_id = NpcBaseId, type = ?fighter_type_npc, name = Name, lev = Lev, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, skills = Skills1, passive_skills = PassiveSkills1, x = X, y = Y}.


%% 加入要播放的被动技能（包含防御）
%% Id = integer()
%% SkillId = integer()
%% Type = integer()
add_to_show_passive_skills(Id, SkillId, Type) ->
    case get(show_passive_skills) of
        [_|_] = L -> put(show_passive_skills, [{Id, SkillId, Type}|L]);
        _ -> put(show_passive_skills, [{Id, SkillId, Type}])
    end.

get_show_passive_skills() ->
    case get(show_passive_skills) of
        undefined -> [];
        L -> L
    end.

clear_show_passive_skills() ->
    put(show_passive_skills, []).




%% @spec last_skill_update(Role, OldSkillId, NewSkillId) -> #role{}
%% Role = #role{}
%% OldSkillId = integer()
%% NewSkillId = integer()
%% @doc 自动战斗保存的技能升级时更改这个保存的值
last_skill_update(Role = #role{combat = CombatParams}, OldSkillId, NewSkillId) ->
    LastSkillId = combat_util:match_param(last_skill, CombatParams, 0),
    case LastSkillId =:= OldSkillId of
        true -> 
            L = [{last_skill, NewSkillId} | lists:keydelete(last_skill, 1, CombatParams)],
            Role#role{combat = L};
        false ->
            Role
    end.

%% ----------------------------------------------------
%% ** 观战者操作 **
%% ----------------------------------------------------
%% @spec stop_observe(Observer, Pid) -> list()
%% Observer = list()
%% Pid = pid()
%% @doc 结束观战
stop_observe(Observer, Pid) ->
    case is_pid(Pid) of
        true ->
            case lists:keyfind(Pid, #c_observer.pid, Observer) of
                #c_observer{name = _Name, conn_pid = ConnPid} ->
                    ?DEBUG("结束[~s]的观战", [_Name]),
                    case is_pid(Pid) of
                        true ->
                            case catch role:apply(sync, Pid, {fun exit_observe/2, [self()]}) of
                                {false, Reason} -> 
                                    ?ERR("观战者[~s]停止观战失败:[~w]", [_Name, Reason]),
                                    sys_conn:pack_send(ConnPid, 10708, {?false, ?L(<<"停止观战失败，请刷新">>)});
                                {true, not_same_observe_combat} ->
                                    ?DEBUG("观战者[~s]当前看的不是这一场战斗，忽略", [_Name]);
                                true ->
                                    sys_conn:pack_send(ConnPid, 10708, {?true, <<>>});
                                _Err ->
                                    ?ERR("观战者[~s]停止观战失败:[~w]", [_Name, _Err]),
                                    sys_conn:pack_send(ConnPid, 10708, {?false, ?L(<<"停止观战失败，请刷新">>)})
                            end;
                        false -> ignore
                    end,
                    lists:keydelete(Pid, #c_observer.pid, Observer);
                _ ->
                    ?ERR("根据Pid=~w找不到观战者", [Pid]),
                    Observer
            end;
        _ ->
            lists:keydelete(Pid, #c_observer.pid, Observer)
    end.

%% @spec stop_all_observe(Observer) -> ok
%% Observer = list()
%% @doc 结束所有观战者的观战
stop_all_observe(Observer) ->
    %% ?DEBUG("结束所有观战者的观战:~w", [Observer]),
    lists:foreach(fun(#c_observer{pid = Pid}) -> stop_observe(Observer, Pid) end, Observer),
    ok.

%% 因其他事件中断观战(比如战斗)
interrupt_observe(Observer, Pid) ->
    case lists:keyfind(Pid, #c_observer.pid, Observer) of
        #c_observer{name = _Name, conn_pid = ConnPid} ->
            sys_conn:pack_send(ConnPid, 10708, {?true, <<>>}),
            lists:keydelete(Pid, #c_observer.pid, Observer);
        _ ->
            ?ERR("根据Pid=~w找不到观战者", [Pid]),
            Observer
    end.


%% is_observing(#role{}) -> {true, CombatPid} | false
%% 是否在观战
is_observing(#role{combat = CombatParams}) ->
    Pid = combat_util:match_param(observe_combat_pid, CombatParams, 0),
    case is_pid(Pid) of
        true -> {true, Pid};
        false -> false
    end.
    
%% 角色切换到观战状态(由角色进程调用)
enter_observe(#role{name = Name, status = ?status_die}, _) ->
    {ok, {false, util:fbin(?L(<<"[~s]处在死亡状态，不能观战">>), [Name])}};
enter_observe(Role = #role{pid = _Pid, combat = CombatParams}, CombatPid) ->
    L = [{observe_combat_pid, CombatPid} | lists:keydelete(observe_combat_pid, 1, CombatParams)],
    {ok, true, Role#role{combat = L}}.
   
%% 角色退出观战状态(由角色进程调用)
exit_observe(Role = #role{combat = CombatParams}, CombatPid) ->
    ObserveCombatPid = combat_util:match_param(observe_combat_pid, CombatParams, 0),
    Result = case ObserveCombatPid =:= CombatPid of
        true -> true;
        _ -> {true, not_same_observe_combat}
    end,
    Role1 = clear_observe(Role),
    {ok, Result, Role1}.

%% 清除观战、录像、直播的信息
clear_observe(Role = #role{combat = CombatParams}) when is_list(CombatParams)->
    CombatParams1 = [{observe_combat_pid, 0} | lists:keydelete(observe_combat_pid, 1, CombatParams)],
    CombatParams2 = lists:keydelete(replay_pid, 1, CombatParams1),
    CombatParams3 = lists:keydelete(live_pid, 1, CombatParams2),
    Role#role{combat = CombatParams3};
clear_observe(CombatParams) when is_list(CombatParams) ->
    CombatParams1 = [{observe_combat_pid, 0} | lists:keydelete(observe_combat_pid, 1, CombatParams)],
    CombatParams2 = lists:keydelete(replay_pid, 1, CombatParams1),
    lists:keydelete(live_pid, 1, CombatParams2);
clear_observe(CombatParams) -> CombatParams.

%% 退出直播
exit_live(#role{pid = Pid, combat = CombatParams}) ->
    case lists:keyfind(live_pid, 1, CombatParams) of
        {live_pid, LivePid} when is_pid(LivePid) ->
            LivePid ! {exit_live, Pid};
        _ -> ignore
    end.
 
%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 重新计算超时时间，继续某一状态
continue(loading, Combat = #combat{ts = Ts}) ->
    {next_state, loading, Combat, util:time_left(?TIMEOUT_LOADING, Ts)};
continue(round, Combat = #combat{t_round = infinity}) ->
    {next_state, round, Combat, infinity};
continue(round, Combat = #combat{ts = Ts, t_round = Tround}) ->
    Delay = 1000,
    {next_state, round, Combat, util:time_left(Tround + Delay, Ts)};
continue(play, Combat = #combat{ts = Ts, t_play_max = TplayMax}) ->
    {next_state, play, Combat, util:time_left(TplayMax, Ts)};
continue(idel, Combat = #combat{ts = Ts, t_idel = Tidel}) ->
    {next_state, idel, Combat, util:time_left(Tidel, Ts)};
continue(play_end_calc_wait, Combat = #combat{ts = Ts}) ->
    {next_state, play_end_calc_wait, Combat, util:time_left(?TIMEOUT_END_CALC, Ts)};
continue(first_round_auto_delay, Combat = #combat{ts = Ts}) ->
    {next_state, first_round_auto_delay, Combat, util:time_left(?FIRST_ROUND_AUTO_DELAY_TIME, Ts)}.

%% 获取所有的参战者
all() -> get(group_atk) ++ get(group_dfd).

%% 获取所有参战者的名字和pid列表(发生异常时打印用)
%%all_fighter_info() ->
%%    [{Name, Pid} || #fighter{name = Name, pid = Pid} <- all()].

%% 通过pid()在所有列表中查找一个参战者数据
f(by_pid, Pid) ->
    case is_pid(Pid) of
        true ->
            case lists:keyfind(Pid, #fighter.pid, get(group_atk)) of
                false ->
                    case lists:keyfind(Pid, #fighter.pid, get(group_dfd)) of
                        false -> false;
                        F -> {group_dfd, F}
                    end;
                F ->
                    {group_atk, F}
            end;
        false ->    %% 如果不是进程ID，则表示是随从怪，使用的是id来代替pid
            case lists:keyfind(Pid, #fighter.id, get(group_atk)) of
                false ->
                    case lists:keyfind(Pid, #fighter.id, get(group_dfd)) of
                        false -> false;
                        F -> {group_dfd, F}
                    end;
                F ->
                    {group_atk, F}
            end
    end.

%% 通过ID在指定组中查找一个参战者数据
f(by_id, Group, Id) ->
    lists:keyfind(Id, #fighter.id, get(Group));

%% 通过rid和srvid查找参展者数据
f(by_rid, Group, {Rid, SrvId}) ->
    case lists:keyfind(Rid, #fighter.rid, get(Group)) of
        false -> false;
        F = #fighter{srv_id = SrvId} ->
            F;
        _ -> false
    end;
f(by_rid, _, _) -> false.


%% 通过pid()查找一个参战者的扩展数据
f_ext(by_pid, Pid) ->
    case get({fighter_ext, Pid}) of
        undefined -> undefined;
        Fext -> Fext
    end.

%% 通过主人pid查找该宠物的参战者数据
f_pet(MasterPid) ->
    case f_ext(by_pid, MasterPid) of
        #fighter_ext_role{active_pet = ActivePet} ->
            case ActivePet of
                undefined -> undefined;
                #c_pet{fighter_id = Id} -> 
                    case f(by_pid, Id) of
                        {_, Pet} -> Pet;
                        _ -> undefined
                    end
            end;
        _ -> undefined
    end.

%% 通过宠物pid查找主人的参战者数据
f_master(PetPid) ->
    case f_ext(by_pid, PetPid) of
        #fighter_ext_pet{master_pid = MasterPid} ->
            case f(by_pid, MasterPid) of
                {_, Master} -> Master;
                _ -> undefined
            end;
        _ -> undefined
    end.

%% 判断是否死亡
is_die(Pid) ->
    case f(by_pid, Pid) of
        {_, F = #fighter{is_die = IsDie, hp = Hp}} when IsDie =:= ?true orelse Hp < 1 -> {true, F};
        _ -> false
    end.

%% 主人死亡且未能复活则宠物也死亡
% pet_die(L) -> pet_die(L, true).
% pet_die([], true) -> commit_play();
% pet_die([], false) -> ok;
% pet_die([MasterPid|T], NeedCommit) ->
%     case is_die(MasterPid) of
%         {true, #fighter{name = _Name, type = ?fighter_type_role}} -> 
%             case f_pet(MasterPid) of
%                 Pet = #fighter{name = _PetName, type = ?fighter_type_pet, is_die = ?false, is_escape = ?false, group = Group} ->
%                     %% ?DEBUG("[~s]壮烈牺牲，宠物[~s]也不愿独活", [_Name, _PetName]),
%                     u(Pet#fighter{hp = 0, is_die = ?true}, Group),
%                     add_sub_play(gen_sub_play(suicide, Pet));
%                 _ -> ignore
%             end;
%         _ -> ignore
%     end,
%     pet_die(T, NeedCommit).


%% 把#fighter{}和#fighter_ext{}转换成#fighter_info{}
do(to_fighter_info, Group, F = #fighter{type = ?fighter_type_role, name = _Name, pid = Pid, is_die = IsDie, is_clone = IsClone, portrait_id = PortraitId, attr = #attr{fight_capacity = FightCapacity}, x = X, y = Y}) ->
    Group1 = case Group of
        group_atk -> 0;
        group_dfd -> 1
    end,
    Fext = f_ext(by_pid, Pid),
    #fighter_ext_role{lineup_id = LineupId, looks = Looks, skills = ActiveSkills, passive_skills = PassiveSkills, anger_skills = AngerSkills, active_pet = ActivePet, backup_pets = BackupPets, items = Items} = append_last_use(Fext),
    #fighter{id = Id, pid = Pid, type = Type, rid = Rid, srv_id = SrvId, name = Name, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, anger = Anger, anger_max = AngerMax, career = Career, lev = Lev, sex = Sex} = F,
    %% 技能
    ActiveSkills1 = [{get_original_skill_id(Pid, SkillId), SkillLastUse} || #c_skill{id = SkillId, last_use = SkillLastUse} <- ActiveSkills],
    PassiveSkills1 = [{SkillId1, 0} || #c_skill{id = SkillId1} <- PassiveSkills],
    AngerSkills1 = [{SkillId2, 0} || #c_skill{id = SkillId2} <- AngerSkills],
    Skills = [{?skill_type_active, ActiveSkills1}, {?skill_type_passive, PassiveSkills1}, {?skill_type_anger, AngerSkills1}],
    %% 宠物
    Pets1 = case ActivePet of
        #c_pet{id = OriginalId, base_id = PetBaseId, name = PetName, type = PetType1} -> [{OriginalId, PetBaseId, PetName, ?true, ?false, PetType1}];
        _ -> []
    end,
    Pets2 = [{OriginalId1, PetBaseId1, PetName1, ?false, CanSummon, PetType2} || #c_pet{id = OriginalId1, base_id = PetBaseId1, name = PetName1, can_summon = CanSummon, type = PetType2} <- BackupPets],
    Pets = Pets1 ++ Pets2,
    %% 物品
    Items1 = get_item_remain(Items, Pid),
    %% 特殊信息
    Specials = [{?combat_special_is_clone, IsClone, <<>>}] ++ practice_append_is_room_master({Rid, SrvId}),
    #fighter_info{group = Group1, id = Id, type = Type, rid = Rid, srv_id = SrvId, name = Name, sex = Sex, career = Career, lev = Lev, portrait_id = PortraitId, fight_capacity = FightCapacity, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, anger = Anger, anger_max = AngerMax, lineup_id = LineupId, is_die = IsDie, looks = Looks, skills = Skills, items = Items1, pets = Pets, specials = Specials, x = X, y = Y};

do(to_fighter_info, Group, F = #fighter{type = ?fighter_type_npc, subtype = Subtype, pid = Pid, is_die = IsDie, ms_rela = MsRela, x = X, y = Y}) ->
    Group1 = case Group of
        group_atk -> 0;
        group_dfd -> 1
    end,
    #fighter_ext_npc{skills = ActiveSkills, passive_skills = PassiveSkills, master_pid = MasterPid} = f_ext(by_pid, Pid),
    #fighter{id = Id, pid = Pid, type = Type, rid = Rid, base_id = BaseId, srv_id = SrvId, name = Name, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, lev = Lev} = F,
    %% 技能
    ActiveSkills1 = [{SkillId, 0} || #c_skill{id = SkillId} <- ActiveSkills],
    PassiveSkills1 = [{SkillId1, 0} || #c_skill{id = SkillId1} <- PassiveSkills],
    AngerSkills1 = [],
    Skills = [{?skill_type_active, ActiveSkills1}, {?skill_type_passive, PassiveSkills1}, {?skill_type_anger, AngerSkills1}],
    %% 特殊信息
    StoryNpcSpecial = case Subtype of
        ?fighter_subtype_story -> [{?combat_special_is_story_npc, 0, <<>>}];
        _ -> []
    end,
    %% 特殊信息
    DemonSpecial = case Subtype of
        ?fighter_subtype_demon -> 
            case f(by_pid, MasterPid) of
                {_, #fighter{id = MasterId}} ->
                    [{?combat_special_demon_master, MasterId, <<>>}];
                _ ->
                    []
            end;
        _ -> []
    end,
    Specials = [{?combat_special_ms_rela, MsRela, <<>>}] ++ StoryNpcSpecial ++ DemonSpecial,
    #fighter_info{group = Group1, id = Id, type = Type, rid = Rid, base_id = BaseId, srv_id = SrvId, name = Name, lev = Lev, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, is_die = IsDie, skills = Skills, specials = Specials, x = X, y = Y};

do(to_fighter_info, Group, F = #fighter{type = ?fighter_type_pet, pid = Pid, is_die = IsDie, attr = #attr{fight_capacity = FightCapacity}, x = X, y = Y}) ->
    Group1 = case Group of
        group_atk -> 0;
        group_dfd -> 1
    end,
    #fighter_ext_pet{master_id = MasterId, skills = ActiveSkills, passive_skills = PassiveSkills} = f_ext(by_pid, Pid),
    #fighter{id = Id, type = Type, rid = Rid, base_id = BaseId, srv_id = SrvId, name = Name, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, lev = Lev} = F,
    %% 技能
    ActiveSkills1 = [{SkillId, 0} || #c_pet_skill{id = SkillId} <- ActiveSkills],
    PassiveSkills1 = [{SkillId1, 0} || #c_pet_skill{id = SkillId1} <- PassiveSkills],
    AngerSkills1 = [],
    Skills = [{?skill_type_active, ActiveSkills1}, {?skill_type_passive, PassiveSkills1}, {?skill_type_anger, AngerSkills1}],
    #fighter_info{group = Group1, id = Id, type = Type, rid = Rid, base_id = BaseId, srv_id = SrvId, master_id = MasterId, name = Name, lev = Lev, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, is_die = IsDie, skills = Skills, fight_capacity = FightCapacity, x = X, y = Y}.


%%---------------------------------------------------
%% 记录冷却时间(技能和物品)
%%---------------------------------------------------
%% 通过技能ID和参战者ID来判断该技能是否处于冷却中
%% false:不在冷却中，可以使用; true:冷却中，不可以使用
is_skill_in_cooldown(FighterId, #c_skill{id = SkillId, cd = Cooldown}, CurrentRound) ->
    is_skill_in_cooldown(FighterId, {SkillId, Cooldown}, CurrentRound);
is_skill_in_cooldown(FighterId, #c_pet_skill{id = SkillId, cd = Cooldown}, CurrentRound) ->
    is_skill_in_cooldown(FighterId, {SkillId, Cooldown}, CurrentRound);
is_skill_in_cooldown(FighterId, {SkillId, Cooldown}, CurrentRound) ->
    case get({skill_cooldown, FighterId}) of
        undefined -> false;
        L ->
            case lists:keyfind(SkillId, 1, L) of
                false -> false;
                {SkillId, LastRound} ->
                    if
                        (LastRound > 0) andalso (CurrentRound - LastRound > Cooldown) ->
                            false;
                        true -> 
                            true
                    end
            end
    end.
is_skill_in_cooldown(FighterId, Skill) ->
    CurrentRound = get(current_round),
    is_skill_in_cooldown(FighterId, Skill, CurrentRound).
        

%% 把参战者的一个技能加入冷却，记录该技能最后一次使用的回合数
add_to_skill_cooldown(FighterId, SkillId) ->
    CurrentRound = get(current_round),
    add_to_skill_cooldown(FighterId, SkillId, CurrentRound).
add_to_skill_cooldown(FighterId, SkillId, Round) ->
    case get({skill_cooldown, FighterId}) of
        undefined -> put({skill_cooldown, FighterId}, [{SkillId, Round}]);
        L -> 
            case lists:keyfind(SkillId, 1, L) of
                false -> put({skill_cooldown, FighterId}, [{SkillId, Round}|L]);
                _ -> put({skill_cooldown, FighterId}, [{SkillId, Round}|lists:keydelete(SkillId, 1, L)])
            end
    end.

%% 清除所有技能冷却
clear_skill_cooldown(FighterId) ->
    put({skill_cooldown, FighterId}, undefined).


%% 通过物品ID和参战者ID来判断该物品是否处于冷却中
% is_item_in_cooldown(FighterId, #c_item{base_id = ItemBaseId, cooldown = Cooldown}, CurrentRound) ->
%     case get({item_cooldown, FighterId, ItemBaseId}) of
%         undefined -> false;
%         LastRound -> %% 上次使用的回合数
%             if
%                 (LastRound > 0) andalso (CurrentRound - LastRound > Cooldown) ->
%                     false;
%                 true ->
%                     true
%             end
%     end.

%% 把参战者的一个物品加入冷却，记录该物品最后一次使用的回合数
% add_to_item_cooldown(FighterId, ItemBaseId, Round) ->
%     put({item_cooldown, FighterId, ItemBaseId}, Round).


%% 附上技能和物品的最后一次使用回合数
append_last_use(Fext = #fighter_ext_role{id = Id, items = Items, skills = Skills}) ->
    NewItems = get_last_use(Id, Items, []),
    NewSkills = get_last_use(Id, Skills, []),
    Fext#fighter_ext_role{items = NewItems, skills = NewSkills};
append_last_use(Fext) ->
    Fext.

get_last_use(_, [], L) -> L;
get_last_use(FighterId, [H = #c_skill{id = SkillId}|T], L) ->
    LastUse = case get({skill_cooldown, FighterId}) of
        undefined -> 0;
        L1 ->
            case lists:keyfind(SkillId, 1, L1) of
                {SkillId, LastRound} -> LastRound;
                _ -> 0
            end
    end,
    get_last_use(FighterId, T, [H#c_skill{last_use = LastUse}|L]);
get_last_use(FighterId, [H = #c_item{base_id = ItemBaseId}|T], L) ->
    LastUse = case get({item_cooldown, FighterId, ItemBaseId}) of
        undefined -> 0;
        LastRound -> LastRound
    end,
    get_last_use(FighterId, T, [H#c_item{last_use = LastUse}|L]).


%%---------------------------------------------------
%% 记录熟练度
%%---------------------------------------------------
% add_to_skill_history(Pid, SkillId) when is_pid(Pid)->
%     if 
%         SkillId < 10000 -> ignore; %% 不记录普通技能
%         true ->
%             case get({skill_history, Pid}) of
%                 undefined ->
%                     Dict = dict:new(),
%                     Dict2 = dict:store(SkillId, 1, Dict),
%                     put({skill_history, Pid}, Dict2);
%                 Dict ->
%                     case dict:find(SkillId, Dict) of
%                         {ok, Times} -> 
%                             Dict2 = dict:store(SkillId, Times+1, Dict),
%                             put({skill_history, Pid}, Dict2);
%                         error ->
%                             Dict2 = dict:store(SkillId, 1, Dict),
%                             put({skill_history, Pid}, Dict2)
%                     end
%             end
%             %%?DEBUG("技能[ID=~w]的熟练度提升了1点", [SkillId])
%             %%?DEBUG("当前技能使用记录:~p", [get({skill_history, Pid})])
%     end;
% add_to_skill_history(_,_) ->
%     ok.

%% 获取个人技能熟练度记录
get_skill_history(Pid) ->
    case get({skill_history, Pid}) of
        undefined ->
            case f_ext(by_pid, Pid) of
                #fighter_ext_role{lineup_id = 0} -> [];
                #fighter_ext_role{lineup_id = LineupId} -> [{LineupId, 1}];
                _ -> []
            end;
        Dict -> 
            L1 = dict:to_list(Dict),
            L2 = case f_ext(by_pid, Pid) of
                #fighter_ext_role{lineup_id = 0} -> [];
                #fighter_ext_role{lineup_id = LineupId} -> [{LineupId, 1}];
                _ -> []
            end,
            [{get_original_skill_id(Pid, SkillId), Num} || {SkillId, Num} <- L1 ++ L2]
    end.

%% 获取队伍的技能熟练度记录
get_all_skill_history(L, []) -> 
    %%?DEBUG("队伍熟练度记录:~w", [L]), 
    L;
get_all_skill_history(L, [#fighter{pid = Pid} | T]) ->
    case is_pid(Pid) of
        true ->
            History = {Pid, get_skill_history(Pid)},
            get_all_skill_history([History|L], T);
        false -> ignore
    end.


%%---------------------------------------------------
%% 记录命中和被命中记录(用来扣除装备耐久)
%%---------------------------------------------------
%% Pid : pid()
%% AtkHitCount : integer()
%% DefHitCount : integer()
add_to_hit_history(Pid, AtkHitCount, DefHitCount) when is_pid(Pid) ->
    case get({hit_history, Pid}) of
        undefined ->
            put({hit_history, Pid}, {AtkHitCount, DefHitCount});
        {A, B} ->
            put({hit_history, Pid}, {AtkHitCount + A, DefHitCount + B})
    end;
add_to_hit_history(_, _, _) ->
    ok.

%% 获取个人命中和被命中记录
get_hit_history(Pid) ->
    case get({hit_history, Pid}) of
        undefined -> {0, 0};
        K -> K
    end.

%% 获取队伍的命中和被命中记录
get_all_hit_history(L, []) -> 
    %%?DEBUG("队伍命中和被命中记录:~w", [L]), 
    L;
get_all_hit_history(L, [#fighter{pid = Pid} | T]) ->
    case is_pid(Pid) of
        true ->
            {A, B} = get_hit_history(Pid),
            get_all_hit_history([{Pid, A, B}|L], T);
        false -> ignore
    end.


%%---------------------------------------------------
%% 记录物品使用记录
%%---------------------------------------------------
% init_item_use_history(Pid, ItemBaseId, Target, N) when is_pid(Pid)->
%     put({item_use_history, Pid, ItemBaseId}, {Target, N});
% init_item_use_history(_, _, _, _) ->
%     ok.

add_to_item_use_history(Pid, ItemBaseId) ->
    case get({item_use_history, Pid, ItemBaseId}) of
        undefined -> ignore;
        {Target, N} -> 
            if 
                N >= 1 ->
                    put({item_use_history, Pid, ItemBaseId}, {Target, N-1});
                true ->
                    ?ERR("[~w]的物品[~w]消耗错误，剩余数量:~w", [Pid, ItemBaseId, N])
            end
    end.

%% 获取个人物品使用记录
get_item_use_history(Pid, ItemBaseId) ->
    case get({item_use_history, Pid, ItemBaseId}) of
        undefined -> {any, 0};
        {Target, N} -> {Target, N}
    end.

%% 获取个人物品使用记录 -> [{ItemBaseId, UsedNum}]
get_item_use_history(Pid) ->
    case f_ext(by_pid, Pid) of
        #fighter_ext_role{items = Items} ->
            [{ItemBaseId, Quantity - N} || {ItemBaseId, Quantity, {_, N}} <- [{ItemBaseId, Quantity, get_item_use_history(Pid, ItemBaseId)} || #c_item{base_id = ItemBaseId, quantity = Quantity} <- Items],N < Quantity];
        _ -> []
    end.

%% 获取队伍的物品使用记录 -> {Pid, [{ItemBaseId, UsedNum}]}
get_all_item_use_history(L, []) -> 
    %%?DEBUG("队伍物品使用记录:~w", [L]), 
    L;
get_all_item_use_history(L, [#fighter{pid = Pid}|T]) ->
    case f_ext(by_pid, Pid) of
        #fighter_ext_role{items = Items} ->
            K =  [{ItemBaseId, Quantity - N} || {ItemBaseId, Quantity, {_, N}} 
                <- [{ItemBaseId, Quantity, get_item_use_history(Pid, ItemBaseId)} || #c_item{base_id = ItemBaseId, quantity = Quantity} <- Items] ,N < Quantity],
            get_all_item_use_history([{Pid,K}|L], T);
        _ -> get_all_item_use_history(L, T)
    end.

%% 获取剩余物品数量
get_item_remain(Items, Pid) ->
    [Item#c_item{quantity = N} || {Item, {_, N}} <- [{Item, get_item_use_history(Pid, ItemBaseId)} || Item = #c_item{base_id = ItemBaseId} <- Items]].


%%---------------------------------------------------
%% 记录抓宠记录
%%---------------------------------------------------
add_to_catch_pet_history(Pid, NpcBaseId) ->
    case get({catch_pet_history, Pid}) of
        undefined -> 
            put({catch_pet_history, Pid}, [NpcBaseId]);
        L ->
            put({catch_pet_history, Pid}, [NpcBaseId | L])
    end.


get_catch_pet_history(Pid) ->
    case get({catch_pet_history, Pid}) of
        undefined -> [];
        L -> L
    end.


%% 一场战斗只能使用若干次的技能
%% check_skill_limit(Pid, SkillId, Limit) -> true | false 
%% pid()
%% integer()
%% integer()
check_skill_limit(Pid, SkillId, Limit) ->
    case get({skill_limit, Pid, SkillId}) of
        undefined -> 
            put({skill_limit, Pid, SkillId}, 1),
            true;
        N -> N < Limit
    end.

%% 参战者ID分配
assign_fighter_id() ->
    case get(next_fighter_id) of 
        undefined -> 
            put(next_fighter_id, 1),
            1;
        I ->
            put(next_fighter_id, I + 1),
            I
    end.

%% 取得对手所在的组名
op(group_atk) -> group_dfd;
op(group_dfd) -> group_atk.

%% 初始化参战者列表，分配ID和设定分组等 -> [#fighter{}]
fighter_init(Group, FighterList, Combat) ->
    %% 如果人数达到2个，则计算阵法加成
    FighterList1 = case length(FighterList) >=2 of
        true ->
            case FighterList of
                [#converted_fighter{fighter_ext = #fighter_ext_role{lineup_id = LineupId}} | _] ->
                    combat_script_skill:lineup_calc(FighterList, LineupId);
                _ -> 
                    combat_script_skill:lineup_calc(FighterList, 0)
            end;
        false ->
            combat_script_skill:lineup_calc(FighterList, 0)
    end,
    fighter_init(Group, FighterList1, Combat, []).

fighter_init(_Group, [], _Combat, L) -> 
    lists:reverse(L);
fighter_init(Group, [H | T], Combat, L) ->
    {[NewF, _NewFpet]} = do_fighter_init(Group, H, Combat),
    NL = case NewF of
        undefined -> L;
        _ ->
            % case NewFpet of     %%role 初始化时去掉宠物
            %     undefined -> [NewF | L];
            %     _ -> [NewFpet, NewF | L]
            % end
            [NewF | L]
            % L
    end,
    fighter_init(Group, T, Combat, NL).


%% 初始化单个参数者数据
do_fighter_init(
    Group, 
    #converted_fighter{
        fighter = F = #fighter{pid = Pid1, name = _Name, type = ?fighter_type_role, career = _Career, is_clone = IsClone}, 
        fighter_ext = Fext = #fighter_ext_role{skills = _Skills, active_pet = _ActivePet, backup_pets = _BackupPets, items = _Items},
        skill_mapping = SkillMapping
    }, 
    #combat{type = _CombatType}
) ->
    %% 分配一个参战者ID
    FighterId = assign_fighter_id(),
    {NewF, Pid} = case IsClone of
        ?true ->
            {F#fighter{
                id = FighterId
                ,group = Group
                ,pid = FighterId
            }, FighterId};
        ?false ->
            {F#fighter{
                id = FighterId
                ,group = Group
            }, Pid1}
    end,
    put({fighter_skill_mapping, Pid}, SkillMapping),
    NewFext = Fext#fighter_ext_role{
        id = FighterId,
        pid = Pid,
        % skills = Skills2,
        skills = []
        % active_pet = ActivePet2,
        % backup_pets = BackupPets2
    },
    put({fighter_ext, Pid}, NewFext),

    {[NewF, []]};

do_fighter_init(
    Group, 
    #converted_fighter{
        fighter = F = #fighter{pid = Pid, name = _Name, type = ?fighter_type_npc}, 
        fighter_ext = Fext = #fighter_ext_npc{skills = _Skills}
    }, 
    #combat{type = _CombatType}
) ->
    FighterId = assign_fighter_id(),
    Pid1 = case is_pid(Pid) of
        true -> Pid;
        false -> FighterId
    end,
    NewF = F#fighter{
        id = FighterId,
        pid = Pid1,
        group = Group
    },
    NewFext = Fext#fighter_ext_npc{
        id = FighterId,
        pid = Pid1
        % skills = Skills2
    },
    put({fighter_ext, Pid1}, NewFext),
    %% ?DEBUG("参战者的数据:~w~n扩展数据:~w~n", [NewF, NewFext]),
    {[NewF, undefined]};

%% 把宠物转成fighter
do_fighter_init(
    Group, 
    _Master = #fighter{pid = MasterPid, id = MasterId},
    #c_pet{id = OriginalId, base_id = BaseId, fighter_id = Fid, lev = Lev, name = Name, skills = Skills, attr = PetAttr, fight_capacity = FightCapacity}
) ->
    #pet_attr{dmg = Dmg, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, critrate = Critrate, defence = Defence, tenacity = Tenacity, hitrate = Hitrate, evasion = Evasion, dmg_magic = DmgMagic, anti_js = Js, anti_attack = AntiAttack, anti_seal = AntiSeal, anti_stone = AntiStone, anti_stun = AntiStun, anti_sleep = AntiSleep, anti_taunt = AntiTaunt, anti_silent = AntiSilent, anti_poison = AntiPoison, blood = _Blood, rebound = _Rebound, resist_metal = ResistMetal, resist_wood = ResistWood, resist_water = ResistWater, resist_fire = ResistFire, resist_earth = ResistEarth} = PetAttr,
    Attr = #attr{dmg_min = Dmg, dmg_max = Dmg, critrate = Critrate, tenacity = Tenacity, defence = Defence, hitrate = Hitrate, evasion = Evasion, dmg_magic = DmgMagic, js = Js, anti_attack = AntiAttack, anti_seal = AntiSeal, anti_stone = AntiStone, anti_stun = AntiStun, anti_sleep = AntiSleep, anti_taunt = AntiTaunt, anti_silent = AntiSilent, anti_poison = AntiPoison, resist_metal = ResistMetal, resist_wood = ResistWood, resist_water = ResistWater, resist_fire = ResistFire, resist_earth = ResistEarth, fight_capacity = FightCapacity},
    F = #fighter{rid = OriginalId, base_id = BaseId, pid = Fid, id = Fid, name = Name, group = Group, type = ?fighter_type_pet, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, lev = Lev, attr = Attr, attr_ext = #attr_ext{}},
    Fext = #fighter_ext_pet{id = Fid, pid = Fid, original_id = OriginalId, master_id = MasterId, master_pid = MasterPid, skills = [], passive_skills = Skills},
    put({fighter_ext, Fid}, Fext),
    %% ?DEBUG("参战者的数据:~w~n扩展数据:~w~n", [F, Fext]),
    {F, Fext}.

%% 根据职业分配近战或者远程的普通攻击
get_normal_attack_skill(#fighter{type = ?fighter_type_npc, base_id = NpcBaseId, attack_type = AttackType}) ->
    case super_boss:is_super_boss(NpcBaseId) of
        true -> combat_data_skill:get(?skill_remote);
        false ->
            case AttackType of
                ?attack_type_range -> combat_data_skill:get(?skill_remote);
                _ -> combat_data_skill:get(?skill_attack)
            end
    end;
get_normal_attack_skill(#fighter{type = ?fighter_type_role, career = Career}) ->
    get_normal_attack_skill(Career);
get_normal_attack_skill(#fighter{type = ?fighter_type_pet}) ->
    combat_data_skill:get(?skill_attack);
get_normal_attack_skill(Career) ->
    case Career of
        ?career_xianzhe -> combat_data_skill:get(?normal_atk_skill_xianzhe);
        ?career_feiyu -> combat_data_skill:get(?normal_atk_skill_feiyu);
        ?career_cike -> combat_data_skill:get(?normal_atk_skill_cike);
        ?career_zhenwu -> combat_data_skill:get(?normal_atk_skill_zhenwu);
        ?career_qishi -> combat_data_skill:get(?normal_atk_skill_qishi);
        ?career_xinshou -> combat_data_skill:get(?normal_atk_skill_xinshou);
        _ -> combat_data_skill:get(?skill_attack)
    end.

%% 根据攻防双方的数值进行特殊处理
special_treat(Atk, Dfd) ->
    %% 设置逃跑几率(根据对方的最高防逃跑几率来设置)
    Dfd1 = lists:filter(fun(F) -> case F of
                    #fighter{attr = #attr{anti_escape = AntiEscape}} when is_integer(AntiEscape) -> true;
                    _ -> false
                end
        end, Dfd),
    DfdAntiEscapeList = [AntiEscape || #fighter{attr = #attr{anti_escape = AntiEscape}} <- Dfd1],
    Max = lists:max(DfdAntiEscapeList),
    AtkFinal = [F#fighter{attr = Attr#attr{escape_rate = EscapeRate - Max}} || F = #fighter{attr = Attr = #attr{escape_rate = EscapeRate}}<-Atk],
    %%?DEBUG("设置逃跑几率:~w", [Max]),
    AtkFinal.

%% 根据技能最终值获取其原始值
get_original_skill_id(Pid, SkillId) ->
    case get({fighter_skill_mapping, Pid}) of
        SkillMapping when is_list(SkillMapping) -> do_get_original_skill_id(SkillId, SkillMapping);
        _ -> SkillId
    end.
do_get_original_skill_id(SkillId, []) -> SkillId;
do_get_original_skill_id(SkillId, [{OriginalId, SkillId}|_]) -> OriginalId;
do_get_original_skill_id(SkillId, [{_, _}|T]) -> do_get_original_skill_id(SkillId, T).

%% 获取参战者技能和物品上次使用回合数 -> [{OriginalSkillId, LastUse}]
% get_skill_and_item_cooldown(Pid) ->
%     case f_ext(by_pid, Pid) of
%         Fext when is_record(Fext, fighter_ext_role) ->
%             #fighter_ext_role{id = _Id, skills = Skills, items = _Items} = append_last_use(Fext),
%             SkillCooldowns = [{get_original_skill_id(Pid, SkillId), SkillLastUse} || #c_skill{id = SkillId, last_use = SkillLastUse} <- Skills],
%             %ItemCooldowns = [{ItemBaseId, ItemLastUse} || #c_item{base_id = ItemBaseId, last_use = ItemLastUse} <- Items],
%             %{SkillCooldowns, ItemCooldowns};
%             SkillCooldowns;
%         #fighter_ext_npc{id = _Id} ->
%             %{[], []};
%             [];
%         #fighter_ext_pet{id = _Id} ->
%             %{[], []}
%             []
%     end.

%% 将[#fighter{}]转成[pid()]
pid_list(Flist) -> pid_list(Flist, []).
pid_list([], L) -> L;
pid_list([#fighter{pid = Pid} | T], L) -> pid_list(T, [Pid | L]).

name_list(PidList) -> name_list(PidList, []).
name_list([], L) -> L;
name_list([Pid|T], <<>>) ->
    case f(by_pid, Pid) of
        {_, #fighter{type = ?fighter_type_role, is_clone = ?false, rid = Rid, srv_id = SrvId, name = Name, is_online = IsOnline}} ->
            Msg = util:fbin(<<"{~w, ~s, ~s, is_online=~w}">>, [Rid, SrvId, Name, IsOnline]),
            name_list(T, Msg);
        _ ->
            name_list(T, <<>>)
    end;
name_list([Pid|T], L) ->
    case f(by_pid, Pid) of
        {_, #fighter{type = ?fighter_type_role, is_clone = ?false, rid = Rid, srv_id = SrvId, name = Name, is_online = IsOnline}} ->
            Msg = util:fbin(<<"{~w, ~s, ~s, is_online=~w}">>, [Rid, SrvId, Name, IsOnline]),
            Sp = util:to_binary(","),
            name_list(T, <<L/binary, Sp/binary, Msg/binary>>);
        _ -> name_list(T, L)
    end.

%% 设置所有参战队员的战斗状态
%% NeedExitRoleList = [#fighter{}] 进入战斗失败时需要复位的角色
all_enter(_Combat, [], _) -> true;
%% NPC无需处理
all_enter(Combat, [#fighter{type = ?fighter_type_pet} | T], NeedExitRoleList) -> all_enter(Combat, T, NeedExitRoleList);
all_enter(Combat, [#fighter{type = ?fighter_type_npc} | T], NeedExitRoleList) -> all_enter(Combat, T, NeedExitRoleList);
%% 参战者为角色进程
all_enter(Combat = #combat{type = ?combat_type_c_world_compete}, [F = #fighter{pid = Pid, group = Group, name = _Name, type = ?fighter_type_role, is_clone = ?false} | T], NeedExitRoleList) ->
    case is_pid(Pid) of
        true ->
            case catch role:apply(sync, Pid, {fun enter_combat/2, [self()]}) of
                true ->
                    all_enter(Combat, T, [F|NeedExitRoleList]);
                _Err ->
                    ?ERR("[~s]进入仙道会战斗失败:~w，转化成克隆人", [_Name, _Err]),
                    F1 = F#fighter{is_clone = ?true, is_auto = ?true},
                    u(F1, Group),
                    all_enter(Combat, T, NeedExitRoleList)
            end;
        false ->
            ?ERR("[~s]进入仙道会战斗失败, pid=~w", [_Name, Pid]),
            all_enter(Combat, T, NeedExitRoleList)
    end;
all_enter(Combat, [F = #fighter{pid = Pid, name = _Name, type = ?fighter_type_role, is_clone = ?false} | T], NeedExitRoleList) ->
    case is_pid(Pid) of
        true ->
            case catch role:apply(sync, Pid, {fun enter_combat/2, [self()]}) of
                {false, Reason} -> {false, Reason, NeedExitRoleList};
                true ->
                    %% 如果是在这次战斗中被设成战斗状态的角色，若最后进不了战斗，则需要复位
                    all_enter(Combat, T, [F|NeedExitRoleList]);
                _Err -> 
                    ?ERR("[~s]进入战斗失败:~w", [_Name, _Err]),
                    {false, ?L(<<"进入战斗失败">>), NeedExitRoleList}
            end;
        false -> {false, ?L(<<"进入战斗失败">>), NeedExitRoleList}
    end;
all_enter(Combat, [#fighter{pid = _Pid, name = _Name, type = ?fighter_type_role, is_clone = ?true} | T], NeedExitRoleList) ->
    all_enter(Combat, T, NeedExitRoleList).

%% 检查是否所有参战者都已经加载完成战斗模块
is_all_ready() -> is_all_ready(all()).
is_all_ready([]) -> true;
is_all_ready([#fighter{type = ?fighter_type_pet} | T]) -> is_all_ready(T);
is_all_ready([#fighter{type = ?fighter_type_npc} | T]) -> is_all_ready(T);
is_all_ready([#fighter{type = ?fighter_type_role, is_clone = ?false, is_loaded = ?false} | _T]) -> false;
is_all_ready([_H | T]) -> is_all_ready(T).

%% 检查是否所有参战者都已经出招
is_all_action() -> 
    %% 宠物不参加判定
    is_all_action(all()).
is_all_action([]) -> true;

is_all_action([#fighter{act = undefined, is_auto = IsAuto, type = ?fighter_type_role, is_die = IsDie} | _T]) ->
    case IsAuto =:= ?true orelse IsDie =:= ?true  of 
        true ->
            true;
        false ->
            false
    end;
% is_all_action([#fighter{is_die = IsDie, is_escape = IsEscape, is_loaded = IsLoaded, is_stun = IsStun, is_sleep = IsSleep, is_stone = IsStone} | T])
% when IsLoaded =:= ?false orelse IsStun =:= ?true orelse IsSleep =:= ?true orelse IsStone =:= ?true orelse IsDie =:= ?true orelse IsEscape =:= ?true ->
%     %% 被控制中的、已设置自动战斗的、未加载完成的参战者不需要选招
%     is_all_action(T);

is_all_action([_H | T]) -> is_all_action(T).

%% 打包并广播消息
pack_cast(Flist, Cmd, Data) ->
    case sys_conn:pack(Cmd, Data) of
        {ok, Bin} ->
            do_pack_cast(Flist, Bin);
        {false, _Reason} ->
            ignore
    end.
do_pack_cast(F, Bin) when is_record(F, fighter) -> do_pack_cast([F], Bin);
do_pack_cast([], _Bin) -> ok;
do_pack_cast([#fighter{pid = Pid, type = ?fighter_type_role, is_clone = ?false} | T], Bin) ->
    Pid ! {socket_proxy, Bin},
    do_pack_cast(T, Bin);
do_pack_cast([#c_observer{pid = Pid} | T], Bin) ->
    Pid ! {socket_proxy, Bin},
    do_pack_cast(T, Bin);
do_pack_cast([_H | T], Bin) ->
    do_pack_cast(T, Bin).

%% 请求指定角色切换到战斗状态(由角色进程调用)
enter_combat(Role = #role{pid = Pid, name = Name, combat_pid = P, status = Status}, CombatPid) ->
    if
        is_pid(P) ->
            {ok, {false, util:fbin(?L(<<"[~s]已经在战斗中，发起战斗失败">>), [Name])}, Role};
        Status =:= ?status_die ->
            {ok, {false, util:fbin(?L(<<"[~s]处在死亡状态，发起战斗失败">>), [Name])}, Role};
        true ->
            %% 停止打坐
            Role1 = case is_observing(Role) of
                {true, ObserveCombatPid} -> 
                    ObserveCombatPid ! {observer_interrupt, Pid},
                    clear_observe(Role);
                false -> Role
            end,
            Role2 = sit:handle_sit(?action_no, Role1),
            Role3 = Role2#role{status = ?status_fight, combat_pid = CombatPid},
            Role4 = combat_type:reset_special_npc_killed_count(Role3),
            %% map:role_update(looks:calc(Role4)),
            map:role_update(Role4),
            {ok, true, Role4}
    end.


%% 发起战斗失败
enter_combat_failed(Role = #role{combat_pid = CombatPid, status = OldStatus}, CurCombatPid) ->
    case is_pid(CombatPid) andalso CombatPid =/= CurCombatPid of
        true -> %% 若角色数据中的战斗进程还存活，而且不是当前战斗进程，则表示该角色在另外一场战斗中，不能修改他的状态
            {ok, true, Role};
        false ->
            NewStatus = case OldStatus of
                ?status_fight -> ?status_normal;
                _ -> OldStatus
            end,
            Role1 = Role#role{status = NewStatus, combat_pid = 0},
            map:role_update(Role1),
            {ok, true, Role1}
    end.


%% 自动出招
auto_action(Combat) -> auto_action(all(), Combat). %%这里需要保持人物先选招之后怪物再选
auto_action([], _Combat) -> ok;
auto_action([#fighter{act = undefined, is_stun = IsStun, is_sleep = IsSleep, is_stone = IsStone, type = ?fighter_type_role} | T], Combat)
when IsStun =:= ?true orelse IsSleep =:= ?true orelse IsStone =:= ?true ->
    %% 被控制中的玩家不能出招
    auto_action(T, Combat);

%% 玩家出招
auto_action([Self = #fighter{id = _Id, type = ?fighter_type_role, is_clone = ?false, act = undefined, group = Group} | T], Combat) ->
    %%玩家选招超时，系统自动选招，根据已有的攻击次数以及ai策略
    Fighter = leisure_ai:act(Self, {get(Group), get(op(Group)), Combat#combat.round}), %%npc新的 ai 策略， 根据已有的攻击次数

    % N = f_atk_times(by_id, Id),
    % Available = 
    %     case N >= 5 of 
    %         true -> 
    %             lists:nth(util:rand(1, 2), [?attack, ?defence]);
    %         false -> 
    %             case N > 0 of 
    %                 true ->
    %                     lists:nth(util:rand(1, 3), [?energy, ?attack, ?defence]);
    %                 false ->
    %                     lists:nth(util:rand(1, 2), [?energy, ?defence])
    %             end
    %     end,
    % Act = 
    %     case Available of
    %         ?energy ->
    %             % {Available, util:rand(2200, 2500)};
    %             {Available, leisure:calc_dmg(Self, get(group_dfd))};
    %         _ -> {Available, 0}
    %     end,
    % Fighter = Self#fighter{act = Act}, %% 1：蓄力 2攻击 3格挡 npc选招

    ?log("act = ~p", [Fighter#fighter.act]),
    ?DEBUG("---玩家自动选招-----：~p~n~n~n", [Fighter#fighter.act]),
    u(Fighter, Group),
    auto_action(T, Combat);

%% npc 出招
auto_action([Self = #fighter{id = _Id, act = undefined, group = Group, type = ?fighter_type_npc} | T], Combat) -> 
    Fighter = leisure_ai:act(Self, {get(Group), get(op(Group)), Combat#combat.round}), %%npc新的 ai 策略， 根据已有的攻击次数

    % 下面为暂时用的逻辑，未写ai
    % N = f_atk_times(by_id, Id),
    % Available = 
    %     case N >= 5 of 
    %         true -> 
    %             lists:nth(util:rand(1, 2), [?attack, ?defence]);
    %         false -> 
    %             case N > 0 of 
    %                 true ->
    %                     lists:nth(util:rand(1, 3), [?energy, ?attack, ?defence]);
    %                 false ->
    %                     lists:nth(util:rand(1, 2), [?energy, ?defence])
    %             end
    %     end,
    % Act = 
    %     case Available of
    %         ?energy ->
    %             % {Available, util:rand(500, 800)};
    %             {Available, leisure:calc_dmg(Self, get(group_atk))};
    %         _ -> {Available, 0}
    %     end,
    % Fighter = Self#fighter{act = Act}, %% 1：蓄力 2攻击 3格挡 npc选招，这时候要推送npc选招的结果 

    ?log("act = ~p", [Fighter#fighter.act]),
    ?DEBUG("---npc自动选招-----：~p~n~n~n", [Fighter#fighter.act]),
    u(Fighter, Group),
    auto_action(T, Combat);

auto_action([_H | T], Combat) ->
    auto_action(T, Combat).


%% 选择完成后处理
action_done(Combat = #combat{round = Round, observer = _Observer, live_srvs = _LiveSrvIds}) ->
    ?log("回合:~p 结算----------------------", [Round]),
    % ?DEBUG("回合:~p 结算---action_done-------~n~n~n", [Round]),
    put(action_done, true), %% 有时会出现同一回合的播报生成了2次，可能是action_done被调用了2次，所以这里设一个标记位

    %% 帮未出招的参战者自动出招
    ?logif([
        ?log("[~s]act = ~p", [AA1_name, AA1_act]) 
        || #fighter{
            name = AA1_name
            ,act = AA1_act
        } <- all()]),

    auto_action(Combat), %%自动选招

    ?logif([
        ?log("[~s]act = ~p", [AA_name, AA_act]) 
        || #fighter{
            name = AA_name
            ,act = AA_act
        } <- all()]),

    %% 回合计算
    round_calc(Combat),
    
    %% 处理播报
    ?DEBUG("--Dict 播报内容--~p~n~n~n", [get(action_play)]),
    % ActionPlays = lists:reverse(get(action_play)),
    ActionPlays = lists:keysort(#skill_play.order, get(action_play)),

    All = all(),
    RoleAct = get(role_act),
    NpcAct = get(npc_act),
    MsgBody = {Round, RoleAct, NpcAct, ActionPlays},
    %% 广播给参战者
    pack_cast(All, 19820, MsgBody), %% 10720 推送播报给角色

    put(all_plays, MsgBody),

    %% 排除未加载完成的之外，生成播放等待列表
    put(playing, pid_list([F || F = #fighter{type = ?fighter_type_role, is_loaded = ?true} <- get(group_atk)])),

    put(buff_play, []),     %% 重置BUFF播放列表
    put(summon_play, []),   %% 重置召唤播放列表
    % put(play_next_id, 1),   %% 重置播放序列编号
    % put(sub_play_next_id, 1), %% 重置子播放序列编号

    %% 清空所有参战者的动作状态值
    % clear_action_state(),
    clear_action_act(),
    
    %% 重置防御和保护状态
    lists:foreach(fun(F = #fighter{group = Group})->u(F#fighter{is_defencing = ?false, protector_pid = undefined}, Group) end, all()),
    Combat1 = #combat{t_play_max = TplayMax} = auto_adjust_play_time(Combat, ActionPlays),
    put(action_done, undefined),
    ?log("回合计算结束"),
    {next_state, play, Combat1#combat{ts = erlang:now()}, TplayMax}.

%% 出招排序
get_sorted_action_list() ->
    SL = sort_action(disturb_action_order()),
    %% TODO:若宠物的行动顺序需要设定成跟主人一样，就特殊处理宠物的行动顺序，否则就采用自然排序顺序
    % SL1 = special_treat_action_order(SL, []),
    % put(sorted_action_list, SL1),
    SL.

%% 参战者id出手顺序（过滤掉宠物）
fighter_id_action_order() ->
    [ Id || #fighter{id = Id, type = Type} <- get_sorted_action_list(), Type=/=?fighter_type_pet].

%% 重排出手顺序
% resort_action_list() ->
%     L = [F || F = #fighter{type = Type, is_die = IsDie} <- all(), (Type=:=?fighter_type_npc andalso IsDie=:=?false) orelse Type=/=?fighter_type_npc],
%     put(sorted_action_list, special_treat_action_order(sort_action(L), [])).

% special_treat_action_order([], L) -> lists:reverse(L);
% special_treat_action_order([F = #fighter{pid = Pid, type = Type}|T], L) ->
%     case Type of
%         ?fighter_type_role ->
%             case f_pet(Pid) of
%                 Pet = #fighter{type = ?fighter_type_pet} ->
%                     special_treat_action_order(T, [Pet, F|L]);
%                 _ -> 
%                     special_treat_action_order(T, [F|L])
%             end;
%         ?fighter_type_pet ->
%             special_treat_action_order(T, L);
%         ?fighter_type_npc ->
%             special_treat_action_order(T, [F|L]);
%         _ ->
%             special_treat_action_order(T, L)
%     end.


append_to_sorted_action_list(F) when is_record(F, fighter) ->
    put(sorted_action_list, get(sorted_action_list) ++ [F]).

sort_action(L) -> 
    po_sort(L, [], []).

%% 冒泡排序：攻速从高到低
po_sort([], [],  R)                -> R;
po_sort([A], PA, R)                -> po_sort(PA, [], [A|R]);
po_sort([#fighter{attr = #attr{aspd = Aaspd}} = A,#fighter{attr = #attr{aspd = Baspd}} = B|T], PA, R) 
when Aaspd < Baspd -> po_sort([A|T], [B|PA], R);
po_sort([A,B|T], PA, R)            -> po_sort([B|T], [A|PA], R).

%% 扰乱攻速(正负5点的浮动)
disturb_action_order() ->
    F = fun(X = #fighter{attr = Attr = #attr{aspd = Aspd}}) ->
            R = util:rand(0, 5) - util:rand(0, 5),
            NewAspd = case Aspd + R < 0 of
                true -> 0;
                false -> Aspd + R
            end,
            X#fighter{attr = Attr#attr{aspd = NewAspd}}
    end,
    [F(X) || X <- all()].


%% 优先处理某些技能
%% 防御->抓宠->保护
% get_final_sorted_action_list(Combat) ->
%     OldActionOrder = lists:reverse(pid_list(combat_util:filter_fighters(?fighter_type_pet, get_sorted_action_list()))),
%     {Def, Away, Prot, Catch, DelayAct, Other} = special_treat_skill([], [], [], [], [], [], OldActionOrder, Combat),
%     lists:reverse(Def) ++ lists:reverse(Catch) ++ lists:reverse(Away) ++ lists:reverse(Prot)  ++ lists:reverse(DelayAct) ++ lists:reverse(Other).
get_final_sorted_action_list() ->
    OldActionOrder = get_sorted_action_list(),
    OldActionOrder.


%% 保存主人攻击的中间数据，供宠物攻击用
%% @spec save_master_dmg(Pid, DmgHp, DmgMp) -> ok
%% Pid = pid() 宠物主人角色进程ID
%% DmgHp = integer() 主人对目标造成的气血伤害
%% DmgMp = integer() 主人对目标造成的魔法损耗
%% @doc 保存主人攻击的中间数据，供宠物攻击用
save_master_dmg(Pid, DmgHp, DmgMp) ->
    put({master_dmg, Pid}, {DmgHp, DmgMp}),
    ok.
%% 提取主人攻击的中间数据
%% @spec fetch_master_dmg(Pid) -> {integer(), integer()}
%% Pid = pid() 宠物主人角色进程ID
%% @doc 提取主人攻击的中间数据
fetch_master_dmg(Pid) ->
    get({master_dmg, Pid}).
%% 清除主人攻击的中间数据
% clear_master_dmg(Pid) ->
%     put({master_dmg, Pid}, undefined),
%     ok.

%% 设置人物消耗扣减标志，连击时用于标识是否已经扣减了魔法
set_cost_flag(Pid, Flag) ->
    put({has_cost, Pid}, Flag).
fetch_cost_flag(Pid) ->
    case get({has_cost, Pid}) of
        undefined -> false;
        K -> K
    end.

%% 人物战斗运算
round_calc(Combat) -> 
    put(action_play, []), %% 初始化播报为空
    put(is_same_action, false),

    round_calc(Combat, all()).

round_calc(Combat, [F1 = #fighter{type = ?fighter_type_role, act = #act{type = RoleAct}}, F2 = #fighter{type = ?fighter_type_npc, act = #act{type = NpcAct}}]) ->
    put(role_act, RoleAct), 
    put(npc_act, NpcAct), 
    round_calc(Combat, F1, F2);

round_calc(Combat, [F1 = #fighter{type = ?fighter_type_npc, act = #act{type = NpcAct}}, F2 = #fighter{type = ?fighter_type_role, act = #act{type = RoleAct}}]) -> 
    put(role_act, RoleAct), 
    put(npc_act, NpcAct), 
    round_calc(Combat, F2, F1);

% round_calc(Combat, [F1 = #fighter{type = ?fighter_type_role}, F2 = #fighter{type = ?fighter_type_role}]) -> 
%     round_calc(Combat, F1, F2);

round_calc(_Combat, _MaybeFighters) -> 
    ?DEBUG("-参战者数量有误：~p~n~n~n", [_MaybeFighters]),
    ok.

%% 处理技能运算
%% round_calc(Combat, F1, F2) -> ok
round_calc(_Combat = #combat{round = _Round}, FighterRole = #fighter{type = TypeRole}, FighterNpc = #fighter{type = TypeNpc}) 
when TypeRole =:= ?fighter_type_role andalso TypeNpc =:= ?fighter_type_npc ->
    Plays = gen_action_plays(FighterRole, FighterNpc),
    % ?DEBUG("--计算回合的结果~p~n~n~n---", [Plays]),
    put(action_play, Plays),
    ok;

round_calc(_Combat, _Fighter1, _Fighter2) ->
    ?DEBUG("--参战者数据类型有误---~n~n~n"),
    ok. 

%%gen_action_plays(F1, F2) -> ActionPlays
%% ActionPlays :: list

%%蓄力 vs 蓄力
gen_action_plays(FighterRole = #fighter{act = #act{type = ?energy}}, FighterNpc = #fighter{act = #act{type = ?energy}}) ->
    put(is_same_action, true),
    gen_same_time_plays(FighterRole, FighterNpc);

%%格挡 vs 格挡
gen_action_plays(FighterRole = #fighter{act = #act{type = ?defence}}, FighterNpc = #fighter{act = #act{type = ?defence}}) ->
    put(is_same_action, true),
    gen_same_time_plays(FighterRole, FighterNpc);

%%格挡 vs 蓄力
gen_action_plays(FighterRole = #fighter{act = #act{type = ?defence}}, FighterNpc = #fighter{act = #act{type = ?energy}}) ->
    put(is_same_action, true),
    gen_same_time_plays(FighterRole, FighterNpc);

%%蓄力 vs 格挡
gen_action_plays(FighterRole = #fighter{act = #act{type = ?energy}}, FighterNpc = #fighter{act = #act{type = ?defence}}) ->
    put(is_same_action, true),
    gen_same_time_plays(FighterRole, FighterNpc);

%% 攻击 vs 格挡 or 格挡 vs 攻击
gen_action_plays(Fighter1 = #fighter{act = #act{type = ?attack}}, Fighter2 = #fighter{act = #act{type = ?defence}}) -> 
    gen_atk_def_plays(Fighter1, Fighter2);
gen_action_plays(Fighter1 = #fighter{act = #act{type = ?defence}}, Fighter2 = #fighter{act = #act{type = ?attack}}) -> 
    gen_atk_def_plays(Fighter2, Fighter1);

%%攻击 vs 蓄力 or 蓄力 vs 攻击
gen_action_plays(Fighter1 = #fighter{act = #act{type = ?attack}}, Fighter2 = #fighter{act = #act{type = ?energy}}) -> 
    gen_atk_eng_plays(Fighter1, Fighter2);
gen_action_plays(Fighter1 = #fighter{act = #act{type = ?energy}}, Fighter2 = #fighter{act = #act{type = ?attack}}) -> 
    gen_atk_eng_plays(Fighter2, Fighter1);

%%攻击 vs 攻击
gen_action_plays(Fighter1 = #fighter{act = #act{type = ?attack}}, Fighter2 = #fighter{act = #act{type = ?attack}}) -> 
    gen_atk_atk_plays(Fighter1, Fighter2);

gen_action_plays(_, _) ->
    ?DEBUG("--回合计算时未知的动作类型---"),
    [].

%%产生同时播放的播报
gen_same_time_plays(FighterRole, FighterNpc) ->
    #fighter{id = RId, act = #act{type = RActT, power = RPower, is_crit = IsCrit}, is_die = RIsDie} = FighterRole,
    #fighter{id = NId, act = #act{type = NActT, power = NPower, is_crit = IsCrit2}, is_die = NIsDie} = FighterNpc,
   
    case RActT of 
        ?energy -> %% 蓄力
            %%更新攻击的次数 ,可能需要将蓄力的信息放到播报里面客户端才能显示蓄力的结果
            add_atk(by_id, RId, {RPower, IsCrit});
        _ -> ok
    end,
    Play1 = gen_action_play(0, RActT, RPower, 0, RId, 0, 0, 0, RId, 0, 0, 1, IsCrit, RIsDie, NIsDie, []),
    
    case NActT of 
        ?energy -> %% 蓄力
            %%更新攻击的次数
            add_atk(by_id, NId, {NPower, IsCrit2});
        _ -> ok
    end,
    Play2 = gen_action_play(0, NActT, NPower, 0, NId, 0, 0, 0, NId, 0, 0, 1, IsCrit2, NIsDie, RIsDie, []),

    [Play1, Play2].

%%处理 攻击 vs 蓄力
gen_atk_eng_plays(FighterAtk = #fighter{id = IdAtk, act = #act{type = ?attack}, is_die = _SIsDie}, 
                        FighterEng = #fighter{id = IdEng, act = #act{type = ?energy, power = _Power, is_crit = _IsCrit}, is_die = _TIsDie}) ->
    %%先蓄力再开始攻击
    % Play1 = gen_action_play(1, ?energy, Power, 0, IdEng, 0, 0, 1, IdEng, 0, 0, 1, IsCrit, SIsDie, TIsDie, []), %%自身蓄力, 可能需要调整蓄力获得进攻机会的时间

    %%下面是攻击的播报
    AtkData = f_atk(by_id, IdAtk), %%从最先的一次攻击开始
    del_atk(by_id, IdEng), %%蓄力方失去最老的一次攻击机会，如果有的话

    Play2 = do_gen_atk_eng_plays(AtkData, [], 1, FighterAtk, FighterEng),
    % [Play1] ++ Play2.
    Play2.
do_gen_atk_eng_plays([], Ret, _Nth, _FighterAtk = #fighter{id = IdAtk, is_die = SIsDie}, FighterEng = #fighter{id = IdEng, act = #act{type = ?energy, 
    power = Power, is_crit = IsCrit}, is_die = TIsDie, hp = THp, group = Group}) ->
    
    case THp =< 0 orelse TIsDie =:= ?true of 
        false ->
            Play1 = gen_action_play(_Nth, ?energy, Power, 0, IdEng, 0, 0, 1, IdEng, 0, 0, 1, IsCrit, SIsDie, TIsDie, []), %%自身蓄力, 可能需要调整蓄力获得进攻机会的时间
            
            u(FighterEng, Group),
         
            add_atk(by_id, IdEng, {Power, IsCrit}), %%蓄力方添加一次攻击的机会

            upd_atk(by_id, IdAtk, []), %%用完了攻击的次数
            [Play1] ++ Ret;
        true ->
            u(FighterEng, Group),
            upd_atk(by_id, IdAtk, []), %%用完了攻击的次数
            Ret
    end;
do_gen_atk_eng_plays(All = [#act{power = Dmg, is_crit = IsCrit}|T], Ret, Nth, FighterAtk = #fighter{id = IdAtk, act = #act{type = ?attack}, is_die = SIsDie}, 
                        FighterEng = #fighter{id = IdEng, act = #act{type = ?energy, power = _Power, is_crit = _IsCrit2}, group = Group, hp = THp, mp = TMp, is_die = TIsDie}) ->
    case THp =< 0 orelse TIsDie =:= ?true of 
        true ->
            u(FighterEng, Group),
            % add_atk(by_id, IdEng, {_Power, _IsCrit2}),
            upd_atk(by_id, IdAtk, All), %%更新剩余的攻击次数，虽然对方已经死掉了
            Ret;
        false ->
            {NTHp, NTIsDie}  = 
                case Dmg >= THp  of 
                    true -> {0, ?true};
                    false ->{THp - Dmg, ?false}
                end,

            AttackType = get_action_type(FighterAtk),

            P1 = 
                case Nth =:= 1 of 
                    true ->
                        gen_action_play(Nth, ?attack, 1, 0, IdAtk, 0, 0, AttackType, IdEng, -Dmg, TMp, 1, IsCrit, SIsDie, NTIsDie, [{IdEng, ?energy, 2}]); %% 2表示最后一次攻击后
                    _ ->
                        gen_action_play(Nth, ?attack, 0, 0, IdAtk, 0, 0, AttackType, IdEng, -Dmg, TMp, 1, IsCrit, SIsDie, NTIsDie, [])
                end,
            NFighterEng = FighterEng#fighter{hp = NTHp, is_die = NTIsDie},
            u(NFighterEng, Group), %%更新被攻击者
            del_atk(by_id, IdAtk), %% 保险起见更新攻击方的攻击次数
            do_gen_atk_eng_plays(T, [P1] ++ Ret, Nth + 1, FighterAtk, NFighterEng)
    end;
do_gen_atk_eng_plays(_AtkData, Ret, _Nth, _FighterAtk, _FighterEng) ->
    Ret.


%%处理 攻击 vs 格挡
gen_atk_def_plays(FighterAtk = #fighter{id = IdAtk, act = #act{type = ?attack}}, FighterDef = #fighter{act = #act{type = ?defence}}) ->
    AtkData = f_atk(by_id, IdAtk), %%从最先的一次攻击开始
    Play = do_gen_atk_def_plays(AtkData, [], 1, FighterAtk, FighterDef),
    Play.
do_gen_atk_def_plays([], Ret, _Nth, _FighterAtk = #fighter{id = IdAtk}, FighterDef = #fighter{group = Group}) -> 
    u(FighterDef, Group),

    upd_atk(by_id, IdAtk, []), %%用完了攻击的次数
    Ret;
do_gen_atk_def_plays(All = [#act{power = Dmg, is_crit = IsCrit}|T], Ret, Nth, FighterAtk = #fighter{id = IdAtk, act = #act{type = ?attack}, is_die = SIsDie}, 
                        FighterDef = #fighter{id = IdDef, act = #act{type = ?defence}, group = Group, hp = THp, is_die = TIsDie}) ->
    case THp =< 0 orelse TIsDie =:= ?true of 
        true ->
            u(FighterDef, Group),
            upd_atk(by_id, IdAtk, All), %%更新剩余的攻击次数，虽然对方已经死掉了
            Ret;
        false ->
            Power = %%表示是否为最后一次攻击
                case T of 
                    [] -> 1;
                    _ -> 0
                end,

            AttackType = get_action_type(FighterAtk),

            {NthPlay, NFighterDef} = 
                case Nth > 2 of 
                    true ->
                        {NTHp, NTIsDie}  = 
                            case Dmg >= THp of 
                                true -> {0, ?true};
                                false ->{THp - Dmg, ?false}
                            end,
                        P1 = gen_action_play(Nth, ?attack, Power, 0, IdAtk, 0, 0, AttackType, IdDef, -Dmg, 0, 1, IsCrit, SIsDie, NTIsDie, []),
                        u(FighterDef#fighter{hp = NTHp, is_die = NTIsDie}, Group), %%更新被攻击者
                        {P1, FighterDef#fighter{hp = NTHp, is_die = NTIsDie}};
                    false ->
                        P1 = gen_action_play(Nth, ?attack, Power, 0, IdAtk, 0, 0, AttackType, IdDef, 0, 0, 0, IsCrit, SIsDie, TIsDie, [{IdDef, ?defence, 1}]), %%这里是前两次攻击，预计需要标识客户端同时播放格挡
                        {P1, FighterDef}
                end,
            del_atk(by_id, IdAtk),
            do_gen_atk_def_plays(T, [NthPlay] ++ Ret, Nth + 1, FighterAtk, NFighterDef)
    end;
do_gen_atk_def_plays(_AtkData, Ret, _Nth, _FighterAtk, _FighterDef) ->
    Ret.

%%处理 进攻 vs 进攻
gen_atk_atk_plays(_FighterAtk1 = #fighter{id = _IdAtk1, act = #act{type = ?attack}}, _FighterAtk2 = #fighter{id = _IdAtk2, act = #act{type = ?attack}}) ->
    case get_and_check_fighters() of 
        {F1, F2} ->
            do_gen_atk_atk_plays(F1, F2, 1, [], 1); %%F1先攻击, 从1开始，下一回合可能需要计算顺序
        false ->
            ?DEBUG("--攻击vs攻击--参与战斗超过对象数量有误~n~n~n~n"),
            []
    end.
get_and_check_fighters() ->
    Sorted = get_final_sorted_action_list(),
    case erlang:length(Sorted) =:= 2 of 
        true ->
            [F1, F2] = Sorted,
            {F1, F2};
        false ->
            ?DEBUG("--攻击vs攻击--参与战斗超过对象数量有误：~p~n~n", [erlang:length(Sorted)]),
            false
    end.

do_gen_atk_atk_plays(F1, F2, Nth, Ret, NeedCalc) -> %%F1先攻击，F2 受击 之后再次计算出手顺序
    #fighter{id = IdAtk, hp = SHp, is_die = SIsDie} = F1,
    #fighter{id = IdAtked, group = Group, hp = THp, is_die = TIsDie} = F2,
    AtkData = f_atk(by_id, IdAtk),
    case SHp =< 0 orelse SIsDie =:= ?true of %%攻击方有可能是挂掉的了
        true ->  
            Ret;
        false ->
            case THp =< 0 orelse TIsDie =:= ?true of %%判断目标的状态
                true ->  %%目标挂了
                    Ret;
                false ->
                    case erlang:length(AtkData) > 0 of
                        true ->
                            [#act{power = Dmg, is_crit = IsCrit}|_] = AtkData, %%从最先的一次攻击开始

                            {NTHp, NTIsDie}  = 
                                case Dmg >= THp of 
                                    true -> {0, ?true};
                                    false -> {THp - Dmg, ?false}
                                end,
                            AttackType = get_action_type(F1),
                            P1 = gen_action_play(Nth, ?attack, 1, 0, IdAtk, 0, 0, AttackType, IdAtked, -Dmg, 0, 1, IsCrit, SIsDie, NTIsDie, []),
                            NF_2 = F2#fighter{hp = NTHp, is_die = NTIsDie}, 
                            u(NF_2, Group), %%更新受击者

                            del_atk(by_id, IdAtk), %%减去攻击者一次攻击次数

                            case NTHp =< 0 orelse NTIsDie =:= ?true of 
                                true ->
                                    [P1] ++ Ret;
                                false ->
                                    case NeedCalc of  %%判断是否需要计算出手顺序
                                        1 ->
                                            case get_and_check_fighters() of 
                                                {NF1, NF2} ->
                                                    do_gen_atk_atk_plays(NF1, NF2, Nth + 1, [P1] ++ Ret, NeedCalc);
                                                false ->
                                                    % ?DEBUG("-仅保留当前所有的播报--"),
                                                    [P1] ++ Ret
                                            end;
                                        0 -> %% 不需要计算出手顺序
                                            do_gen_atk_atk_plays(F1, NF_2, Nth + 1, [P1] ++ Ret, 0)
                                    end
                            end;
                        false -> %%准备出手的单位没有攻击次数了，则受击者一直攻击直到攻击次数为0
                            case THp =< 0 orelse TIsDie =:= ?true of
                                false ->
                                    case SHp =< 0 orelse SIsDie =:= ?true of %%判断目标的状态
                                        true ->  %%目标挂了
                                            upd_atk(by_id, IdAtk, []), %%更新剩余的攻击次数，虽然对方已经死掉了
                                            Ret;
                                        false ->
                                            AtkData1 = f_atk(by_id, IdAtked), %%从最先的一次攻击开始
                                            case erlang:length(AtkData1) > 0 of 
                                                true ->  
                                                    do_gen_atk_atk_plays(F2, F1, Nth, Ret, 0); %% 0表示不需要去计算出手顺序
                                                false -> %%双方都没有攻击次数，回合结束
                                                    Ret
                                            end
                                    end;
                                true ->
                                    Ret
                            end
                    end
            end
    end.      

gen_action_play(Order, ActionType, Power, SkillId, FighterId, SHp, SMp, AttackType, TargetId, TargetHp, TargetMP, IsHit, IsCrit, IsSelfDie, 
    IsTargetDie, Show_passive_skills) ->
        % order = 0           %% 播放序列
        % ,sub_order = 0      %% 子序列(用于连击)
        % ,action_type = 0    %% 行动类型(0是攻击和施法，1是反击，2是保护，3是反弹，4是自杀，5是使用物品，6是角色不动单纯释放特效)
        % ,skill_id = 0       %% 技能ID
        % ,id = 0             %% 参战者ID
        % ,hp = 0             %% 自身血量变化数据(若施放技能需要hp)
        % ,hp_show_type = 0   %% 自身血量变化的时机(0是行动前，1是行动中，2是行动后)
        % ,mp = 0             %% 自身魔量变化数据(若施放技能需要mp)
        % ,mp_show_type = 0   %% 自身血量变化的时机(0是行动前，1是行动中，2是行动后)
        % ,anger = 0          %% 自身怒气变化数据
        % ,power = 0          %% 自身天威变化数据
        % ,attack_type = 0    %% 攻击类型(0:近战 1:远程)
        % ,target_id = 0      %% 目标ID
        % ,target_hp = 0      %% 目标血量变化
        % ,target_mp = 0      %% 目标魔量变化
        % ,target_anger = 0   %% 目标怒气值变化
        % ,target_power = 0   %% 目标天威值变化
        % ,is_hit = 1         %% 是否命中
        % ,is_crit = 0        %% 是否爆击
        % ,is_self_die = 0    %% 自身是否死亡
        % ,is_target_die = 0  %% 目标是否死亡
        % ,talk = <<>>        %% 说话内容
        % ,show_passive_skills = []   %% 要展示特效的被动技能, [{Id, SkillId, Type}], Id = 执行该被动技能的参战者的ID = integer(), SkillId = integer(), Type = integer()
    #skill_play{order = Order, action_type = ActionType, id = FighterId, hp = SHp, mp = SMp, power = Power, attack_type = AttackType, 
                    target_id = TargetId, skill_id = SkillId, target_hp = TargetHp, target_mp = TargetMP, is_hit = IsHit, is_crit = IsCrit,
                    is_self_die = IsSelfDie, is_target_die = IsTargetDie, show_passive_skills = Show_passive_skills
                }.


%%获取近攻与远攻
get_action_type(_FighterAtk = #fighter{career = Career, attack_type = AttackType}) ->
    if
        Career =:= 0 ->
            if
                AttackType =:= 1 ->
                    11;
                true ->
                    AttackType 
            end;
        Career =:= 2 ->
            2;
        Career =:= 3 ->
            8;
        Career =:= 5 ->
            5;
        true ->
            AttackType
    end.
    

%% 通过id查询攻击的次数
f_atk_times(by_id, Id) ->
    case lists:keyfind(Id, 1, get(atk_times)) of
        {_, Times}when is_list(Times) ->
            erlang:length(Times);
        _ ->
            0
    end.

f_atk(by_id, Id) ->
    case lists:keyfind(Id, 1, get(atk_times)) of
        {_, Data} when is_list(Data) ->
            lists:keysort(#act.id, Data);
        _ ->
            []
    end.

%%计算伤害的总值
calc_damage(by_id, Id) ->
   Atk_List = f_atk(by_id, Id),
    case erlang:length(Atk_List) of 
        0 -> 0;
        _ ->
            Damages = [Dmg||#act{power = Dmg} <- Atk_List],
            lists:sum(Damages)
    end.

%% 增加攻击的次数
add_atk(by_id, Id, {Val, IsCrit}) -> %%Val 表示蓄力的大小
    Data = get(atk_times),
    NData = 
        case lists:keyfind(Id, 1, Data) of
            false ->
              [{Id,  [#act{id = 1, power = Val, is_crit = IsCrit}]}] ++ Data;  
            {_, Old} ->
                case is_list(Old) of 
                    true ->
                        case erlang:length(Old) >= ?max_energy of 
                            false ->
                                case Old of 
                                    [] ->
                                        ND = lists:keydelete(Id, 1, Data),
                                        [{Id, [#act{id = 1, power = Val, is_crit = IsCrit}]}] ++ ND;
                                    _ ->
                                        #act{id = Max} = lists:last(lists:keysort(#act.id, Old)),
                                        N = Max + 1,
                                        ND = lists:keydelete(Id, 1, Data),
                                        [{Id, [#act{id = N, power = Val, is_crit = IsCrit}] ++ Old}] ++ ND
                                end;
                            true -> 
                                Data
                        end;
                    false ->
                        ND = lists:keydelete(Id, 1, Data),
                        [{Id, [#act{id = 1, power = Val, is_crit = IsCrit}]}] ++ ND
                end
        end,
    put(atk_times, NData),
    ok.

%% 更新攻击剩余的次数
upd_atk(by_id, Id, Val) -> %%Val 表示剩余的次数{N, Power}
    Data = get(atk_times),
    NData = 
        case lists:keyfind(Id, 1, Data) of
            false ->
                % [{Id, Val}] ++ Data;
                Data;
            {_, _Old} ->
                ND = lists:keydelete(Id, 1, Data),
                [{Id, Val}] ++ ND 
        end,
    put(atk_times, NData),
    ok.


%% 减去最老的一次攻击机会
del_atk(by_id, Id) ->
    Data = get(atk_times),
    NData = 
    case lists:keyfind(Id, 1, Data) of
        {_, Have} ->
            case Have of 
                [] ->
                    lists:keydelete(Id, 1, Data);
                _ ->
                    Sorted = lists:keysort(#act.id, Have),
                    [_|NHave] = Sorted,
                    ND = lists:keydelete(Id, 1, Data),
                    [{Id, NHave}] ++ ND
            end;
        false ->
          Data
    end,
    put(atk_times, NData),
    ok.


%% 判断是否不能以作为自动战斗使用的技能
is_illegal_auto_skill(SkillId) ->
    if
        SkillId < 1000 -> true;
        true -> %lists:member(SkillId, [1002, 1003, 1004, 1005, 1007, 1008])
            lists:member(SkillId, [?skill_escape, ?skill_defence])
    end.


%% 切换宠物
switch_pet(NewActivePet = #c_pet{master_pid = MasterPid, fighter_id = Fid}) ->
    {Sgroup, Master} = combat:f(by_pid, MasterPid),
    {Fpet, FpetExt} = do_fighter_init(Sgroup, Master, NewActivePet),
    case f(by_pid, Fid) of
        {_, #fighter{type = ?fighter_type_pet}} ->
            u(Fpet, Sgroup);
        false ->
            put(Sgroup, [Fpet|get(Sgroup)])
    end,
    FpetExt1 = FpetExt#fighter_ext_pet{first_summon = ?true},
    put({fighter_ext, Fid}, FpetExt1),
    clear_skill_cooldown(Fid),
    replace_original_fighter(Fpet),
    {Fpet, FpetExt1}.


%% @spec add_fighter(npc, Group, Combat, Args) -> {#fighter{}, #fighter_ext_npc{}} | undefined
%% Combat = #combat{}, 如果是undefined则取进程字典中保存的原始值
%% Group = atom(), group_atk | group_dfd
%% Args = list()
%% @doc 动态增加参战者(NPC)
add_fighter(npc, Group, Combat, _Args = [NpcBaseId]) ->
    case check_add_fighter(Group) of
        true ->
            case npc_convert:do(to_fighter, NpcBaseId) of
                {ok, CF} ->
                    Combat1 = case Combat of
                        #combat{} -> Combat;
                        _ -> get(original_combat)
                    end,
                    {[NF0 = #fighter{pid = Pid, id = Fid}, _]} = do_fighter_init(Group, CF, Combat1),
                    NF = case hold_empty_pos(Group, Fid) of
                        null -> NF0;
                        {X, Y} -> NF0#fighter{x = X, y = Y}
                    end,
                    put(Group, get(Group) ++ [NF]),
                    %% ?DEBUG("In add_fighter():~w", [get(Group)]),
                    %% 加入到出手顺序列表中
                    append_to_sorted_action_list(NF),
                    replace_original_fighter(NF),
                    {NF, f_ext(by_pid, Pid)};
                _ -> 
                    ?ERR("动态增加NPC失败:NpcBaseId=~w", [NpcBaseId]),
                    undefined
            end;
        false -> 
            ?ERR("动态增加NPC[~w]失败:数量已经满了", [NpcBaseId]),
            undefined
    end;
add_fighter(clone, Group, Combat, _Args = [Fid]) ->
    case check_add_fighter(Group) of
        true ->
            case f(by_id, Group, Fid) of
                #fighter{rid = Rid, srv_id = SrvId, type = ?fighter_type_role} ->
                    case role_api:lookup(by_id, {Rid, SrvId}) of
                        {ok, _Node, Role} ->
                            case role_convert:do(to_fighter, {Role, clone_no_pet}) of
                                {ok, CF} ->
                                    Combat1 = case Combat of
                                        #combat{} -> Combat;
                                        _ -> get(original_combat)
                                    end,
                                    {[NF = #fighter{pid = Pid}, _]} = do_fighter_init(Group, CF, Combat1),
                                    put(Group, get(Group) ++ [NF]),
                                    %% ?DEBUG("In add_fighter():~w", [get(Group)]),
                                    %% 加入到出手顺序列表中
                                    append_to_sorted_action_list(NF),
                                    replace_original_fighter(NF),
                                    {NF, f_ext(by_pid, Pid)};
                                _ ->
                                    ?ERR("无法添加复制角色[Fid=~w, RoleId={~w, ~s}]，转换失败", [Fid, Rid, SrvId]),
                                    undefined
                            end;
                        _Err ->
                            ?ERR("无法添加复制角色[Fid=~w, RoleId={~w, ~s}]:~w", [Fid, Rid, SrvId, _Err]),
                            undefined
                    end;
                _ ->
                    ?ERR("无法添加复制角色[Fid=~w]，查找不到", [Fid]),
                    undefined
            end;
        false ->
            ?ERR("无法添加复制角色[Fid=~w]，数量已经满了", [Fid]),
            undefined
    end;
%% 加角色 
%% -> {#fighter, #fighter_ext, #fighter}
add_fighter(role, Group, Combat = #combat{type = Type}, ConvFighter) ->
    case check_add_fighter(Group) of
        true ->
            Combat1 = case Combat of
                #combat{} -> Combat;
                _ -> get(original_combat)
            end,
            {[NF0 = #fighter{pid = Pid, id = _Fid}, Fpet]} = do_fighter_init(Group, ConvFighter, Combat1),
            [NF1] = init_fighter_pos(Type, Group, [NF0]), 
            %% 处理一些需要根据全部对方数值来设置本方数值的地方
            [NF] = special_treat([NF1], get(op(Group))),
            put(Group, get(Group) ++ [NF]),
            %% ?DEBUG("In add_fighter():~w", [get(Group)]),
            %% 加入到出手顺序列表中
            append_to_sorted_action_list(NF),
            replace_original_fighter(NF),
            {NF, f_ext(by_pid, Pid), Fpet};
        false ->
            ?ERR("无法加入角色，队伍数量已经满了"),
            undefined
    end;
add_fighter(_, _, _, _) -> undefined.

check_add_fighter(Group) ->
    L = lists:filter(fun(#fighter{is_die = IsDie, is_escape = IsEscape}) -> IsDie =:= ?false andalso IsEscape =:= ?false end, get(Group)),
    length(L) < 6.


%% 添加BUFF
% do_buff_add([], _Cpid, _Tpid) -> ok;
% do_buff_add([H | T], Cpid, Tpid) ->
%     {_, Caster} = f(by_pid, Cpid),
%     {_, Target} = f(by_pid, Tpid),
%     buff_add(H, Caster, Target), 
%     do_buff_add(T, Cpid, Tpid).

%% 处理作用于多个目标的技能
do_multi(_, [], _Spid, _Skill) -> ok;
do_multi(0, _, _Spid, _Skill) -> ok;
do_multi(N, [#fighter{pid = Tpid, name=_Name} | T], Spid, Skill) ->
    %% ?DEBUG("处理对[~s]的群攻伤害", [_Name]),
    do_skill(1, Skill, Spid, Tpid),
    do_multi(N - 1, T, Spid, Skill).

%% 对同一个目标作用多次
do_skill(N, #c_skill{id = Id}, _Spid, _Tpid) when N < 0 ->
    ?ERR("技能[~w]的作用次数设置错误:[~w]", [Id, N]);
do_skill(0, _Skill, _Spid, _Tpid) -> ok;
do_skill(N, Skill, Spid, Tpid) ->
    {_, Self} = f(by_pid, Spid),
    {_, Target = #fighter{name = _Tname, is_die = IsDie, is_escape = IsEscape, hp = Thp}} = f(by_pid, Tpid),
    CanUseOnDead = case skill_check_on_dead({true, <<>>}, Skill, Self, Target) of
        {true, _} -> true;
        _ -> false
    end,
    if
        ((IsDie =:= ?true orelse Thp <1) andalso CanUseOnDead =:= false) orelse IsEscape =:= ?true -> ignore;
        true -> 
            skill_exec(Skill, Self, Target),
            %% 清除死亡目标的所有BUFF
            case f(by_pid, Spid) of
                {_, #fighter{is_die = ?true}} ->
                    clear_all_buff(Spid);
                _ -> ignore
            end,
            case f(by_pid, Tpid) of
                {_, #fighter{is_die = ?true}} ->
                    clear_all_buff(Tpid);
                _ -> ignore
            end
    end,
    do_skill(N - 1, skill_hitrate_reduce(N, Spid, Skill), Spid, Tpid).

%% 技能命中衰减判断 -> #c_skill{} | #c_pet_skill{}
skill_hitrate_reduce(N, Pid, Skill) ->
    case f(by_pid, Pid) of
        {_, #fighter{type = ?fighter_type_role}} -> %% 只有玩家施放的控制类技能会衰减
            case combat_script_skill:is_control_skill(Skill) of
                true -> %% 只有控制类技能会衰减
                    case Skill of
                        #c_skill{} ->
                            ReduceVal = util:check_range(6-N, 0, 6) * 60,
                            Skill#c_skill{hitrate_reduce = ReduceVal};
                        _ -> Skill
                    end;
                false -> Skill
            end;
        _ -> Skill
    end.
                    
%% 执行技能
%% ---------------------
%% 眩晕等状态不能攻击
skill_exec(_Skill, #fighter{name = _Name, hp = Hp, is_die = IsDie, is_escape = IsEscape, 
        is_stun = IsStun, is_sleep = IsSleep, is_stone = IsStone}, _Target)
when IsDie =:= ?true
orelse Hp < 1
orelse IsEscape =:= ?true
orelse IsStun =:= ?true
orelse IsSleep =:= ?true
orelse IsStone =:= ?true ->
    %%?DEBUG("参战者[~s]当前状态下无法行动:~w,~w,~w,~w,~w,~w", [_Name, IsDie, Hp, IsEscape, IsStun, IsSleep, IsStone]),
    ignore;
%% 设置技能脚本script模块
skill_exec(Skill = #c_skill{name = _Name, script = ScriptMod}, Self = #fighter{name = _Sname, pid = Spid}, Target) when ScriptMod =/= undefined ->
    ?DEBUG("执行技能脚本: ~p", [ScriptMod]),
    case catch ScriptMod:handle_active(Skill, Self, Target) of
        ok -> 
            set_cost_flag(Spid, true),
            ok;
        {'EXIT', {undef, _}} -> %% 不存在的技能脚本
             skill_exec(Skill#c_skill{script = undefined}, Self, Target);           
        Err -> 
            ?ERR("[~s]执行技能[~s]时发生异常: ~w", [_Sname, _Name, Err])
    end; 
%% 没有设置攻击函数attack属性
skill_exec(Skill = #c_skill{name = _Name, attack = undefined}, Self, Target) ->
    ?DEBUG("技能[~s]没有配置攻击效果", [_Name]),
    skill_exec(Skill#c_skill{attack = fun combat_script_skill:attack/3}, Self, Target); %% TODO 临时用普攻代替
%% 设置了攻击函数attack属性
skill_exec(Skill = #c_skill{name = _Name, attack = AttackFun}, Self = #fighter{name = _Sname, pid = Spid}, Target) ->
    case catch AttackFun(Skill, Self, Target) of
        ok -> 
            set_cost_flag(Spid, true),
            ok;
        Err -> 
            ?ERR("[~s]执行技能[~s]时发生异常: ~w", [_Sname, _Name, Err])
    end.

%% 进入下一回合
next_round(Combat = #combat{type = _CombatType, round = Round, t_round = _Tround, t_play_max = _MaxPlayTime, observer = _Observer, referees = _Referees, live_srvs = _LiveSrvIds}) ->
    ?log("进入回合~p: ============================", [Round]),
    % ?DEBUG("进入回合~p: ============================~n~n~n", [Round + 1]),
    Atk = combat_util:filter_fighters(?fighter_type_pet, get(group_atk)),
    Dfd = combat_util:filter_fighters(?fighter_type_pet, get(group_dfd)),

    case combat_type:check_combat_round_result(Combat, Atk, Dfd) of
        ?combat_round_result_draw_game ->   %% 双方同时阵亡 或 已经达到最大回合数
            % ?DEBUG("双方同时阵亡 或 已经达到最大回合数~n~n~n"),
            [FAtk|_] = Atk,
            [FDfd|_] = Dfd,
            calc_stop_message(FAtk, FDfd, Round),
            play_end_calc(Combat#combat{over = true, loser = Atk ++ Dfd});

        ?combat_round_result_atk_win ->     %% 进攻方胜

            calc_stop_message(Atk, 0, Round),
            play_end_calc(Combat#combat{over = true, winner = Atk, loser = Dfd});

        ?combat_round_result_dfd_win ->     %% 防守方胜

            calc_stop_message(Atk, Dfd, Round),
            play_end_calc(Combat#combat{over = true, winner = Dfd, loser = Atk});

        ?combat_round_result_next ->        %% 继续下一个回合

            NextRound = Round + 1,
            put(current_round, NextRound),

            put(skill_play, []),        %% 重置技能播放列表
            put(buff_play, []),         %% 重置BUFF播放列表
            put(summon_play, []),       %% 重置召唤播放列表
            put(play_next_id, 1),       %% 重置播放序列编号
            put(sub_play_next_id, 1),   %% 重置子播放序列编号
            put(action_play, []),       %% 初始化播报为空

            Roles = [F || F = #fighter{type = Type, is_clone = IsDie} <- get(group_atk), Type=:=?fighter_type_role andalso IsDie=:=?false],
            %% 通知出招

            %%新手引导
            Tround1 =  
                case get(if_new_guy) of 
                    ?true ->
                        case get(new_guy_choose_times) of 
                            N when is_integer(N) andalso N < 4 -> %% 新手引导4个回合
                                put(new_guy_choose_times, N + 1),
                                infinity;
                            _ ->
                                % Tround
                                ?leisure_t_round
                        end;
                    _ ->
                        % Tround
                        ?leisure_t_round
                end,

            Sec = case is_integer(Tround1) of
                true -> erlang:round(Tround1/1000);
                _ -> 0
            end,
            [#fighter{id = IdDfd}|_] = get(group_dfd),
            Dfd_Data = f_atk(by_id, IdDfd),

            case is_all_action() of %%关于选招
                true ->
                    %% 通知所有参战者只更新回合数和更新BUFF剩余回合数, 19821第三字段为false,不需要选招
                    lists:foreach(fun(#fighter{id = Id, pid = Pid}) when is_pid(Pid) -> %%只给玩家发出招的通知
                                Atk_Data = f_atk(by_id, Id),
                                % role:pack_send(Pid, 19821, {NextRound, Sec, ?false, Atk_Data, Dfd_Data}) %%全部都已经选完招，只需要更新回合数就可以了
                                send_19821(Pid, NextRound, Sec, ?false, Atk_Data, Dfd_Data)
                            end, Roles),
                    action_done(Combat#combat{round = NextRound});
                false ->
                    %% 通知所有参战者开始出招并更新回合数和BUFF剩余回合数 ,针对那些还没有选招的(Roles长度为1)，19821第三个字段为 true
                    lists:foreach(fun(#fighter{id = Id, pid = Pid}) when is_pid(Pid) ->  %%只给玩家发出招的通知
                                Atk_Data = f_atk(by_id, Id),
                                % role:pack_send(Pid, 19821, {NextRound, Sec, ?true, Atk_Data, Dfd_Data})  %%通知选招
                                send_19821(Pid, NextRound, Sec, ?true, Atk_Data, Dfd_Data)
                            end, Roles),
                    {next_state, round, auto_adjust_play_time(Combat#combat{round = NextRound, ts = erlang:now(), t_round = Tround1}), Tround1}
            end
    end.


%%计算人物与怪的血量剩余比例以及回合数，存储到副本进程，副本结算用到
%%三种情况  
%% 1:攻击方胜利
calc_stop_message([_Atk = #fighter{pid = Pid, type = ?fighter_type_role, hp = NHp}|_], 0, Round) ->
    case f_ext(by_pid, Pid) of
        #fighter_ext_role{event = ?event_dungeon, event_pid = DunPid} ->
            AtkHp = get(atk_hp),
            dungeon:combat2_info(DunPid, {0, erlang:round(NHp/AtkHp * 100), Round});
        _ -> ignore
    end;

%% 2:失败
calc_stop_message([#fighter{pid = Pid}|_], [_Dfd = #fighter{type = ?fighter_type_npc, hp = NHp}|_], Round) ->
    case f_ext(by_pid, Pid) of
        #fighter_ext_role{event = ?event_dungeon, event_pid = DunPid} ->
            DfdHp = get(dfd_hp),
            dungeon:combat2_info(DunPid, {erlang:round(NHp/DfdHp * 100), 0, Round});
        _ -> ignore
    end;
 
%% 2:平局 达到最大回合数
calc_stop_message(#fighter{pid = Pid, type = ?fighter_type_npc, hp = NRoleHp}, 
                _Dfd = #fighter{type = ?fighter_type_npc, hp = NNpcHp}, Round) ->
    case f_ext(by_pid, Pid) of
        #fighter_ext_role{event = ?event_dungeon, event_pid = DunPid} ->
            AtkHp = get(atk_hp),
            DfdHp = get(dfd_hp),
            dungeon:combat2_info(DunPid, {erlang:round(NNpcHp/DfdHp * 100), erlang:round(NRoleHp/AtkHp * 100), Round});
        _ -> ignore
    end;
 
calc_stop_message(_, _, _)->
    ignore.

%% 自动根据战况调整播放等待时间
auto_adjust_play_time(Combat = #combat{round = _Round}) ->
    L = [F || F = #fighter{type = Type, is_die = IsDie, is_escape = IsEscape, is_stun = IsStun, is_stone = IsStone, is_sleep = IsSleep} <- all(), Type =/= ?fighter_type_pet andalso IsDie =/= ?true andalso IsEscape =/= ?true andalso IsStun =/= ?true andalso IsStone =/= ?true andalso IsSleep =/= ?true],
    %%L = [F || F = #fighter{type = Type, is_die = IsDie, is_escape = IsEscape} <- all(), Type =/= ?fighter_type_pet andalso IsDie =/= ?true andalso IsEscape =/= ?true],
    Len = length(L),
    Len2 = if
        Len =< 1 -> 2; %% 适当延迟一些时间，不然看起来很奇怪
        true -> Len
    end,
    Max = Len2 * ?MAX_PLAY_TIME,
    Min = Len2 * ?MIN_PLAY_TIME,
    Min1 = case Min > 3000 of
        true -> 3000;
        false -> Min
    end,
    Combat#combat{t_play = Min1, t_play_max = Max}.
auto_adjust_play_time(Combat = #combat{round = _Round}, ActionPlays) when is_list(ActionPlays) ->
    Count = case count_skill_play_unit(ActionPlays)  of
        C when C > 0 -> C;
        _ -> 1
    end,
    Max = erlang:round(Count * ?MAX_PLAY_TIME), %%每一个参战者最大的播放时间为 4s
    Min = erlang:round(Count * ?MIN_PLAY_TIME), %%每一个参战者最大的播放时间为 1.5s
    Min1 = case Min > 3000 of
        true -> 3000;
        false -> Min
    end,
    Combat#combat{t_play = Min1, t_play_max = Max + 5000}; %%可在这里适当调整最大最小等待时间

auto_adjust_play_time(_, _) ->
    ?ERR("--自动调整播报等待时间出错--~n~n~n"),
    0.

count_skill_play_unit(ActionPlays) when is_list(ActionPlays) ->
    Same_action = 
        case get(is_same_action) of
            undefined -> false;
            Is_dfdvsdfd -> Is_dfdvsdfd
        end,
    case Same_action of 
        true ->
            0.4; %%蓄力与蓄力 格挡与格挡 的情况下最大的播放时间是2s， 最小是1s
        false ->
            0.4 * erlang:length(ActionPlays) %% 攻击与格挡只算攻击播报， 攻击与攻击同样，攻击与蓄力时蓄力是单独一个播报，因此都是算播报长度
    end.

%%---------------------------------------------------
%% 伤害记录相关
%%---------------------------------------------------
%% 记录玩家（包括他的宠物）对其他玩家（包括他的宠物）造成的伤害
add_role_to_role_dmg(Self = #fighter{rid = _Rid, srv_id = _SrvId, type = ?fighter_type_role, pid = Pid, is_clone = ?false}, Target = #fighter{type = ?fighter_type_role, rid = Trid, srv_id = TsrvId}, DmgHp) ->
    case get({role_to_role_dmg, Pid}) of
        undefined -> put({role_to_role_dmg, Pid}, [{{Trid, TsrvId}, DmgHp}]);
        L ->
            case lists:keyfind({Trid,TsrvId}, 1, L) of
                {_, OldDmgHp} ->
                    put({role_to_role_dmg, Pid}, [{{Trid, TsrvId}, OldDmgHp + DmgHp} | lists:keydelete({Trid, TsrvId}, 1, L)]);
                _ ->
                    put({role_to_role_dmg, Pid}, [{{Trid, TsrvId}, DmgHp}|L])
            end
    end,
    add_role_to_role_max_dmg(Self, Target, DmgHp);
add_role_to_role_dmg(Self = #fighter{type = ?fighter_type_role, is_clone = ?false}, #fighter{type = ?fighter_type_pet, pid = PetPid}, DmgHp) ->
    case f_master(PetPid) of
        F = #fighter{type = ?fighter_type_role, is_clone = ?false} ->
            add_role_to_role_dmg(Self, F, DmgHp);
        _ -> ignore
    end;
add_role_to_role_dmg(#fighter{type = ?fighter_type_pet, pid = Pid}, Target = #fighter{type = ?fighter_type_role}, DmgHp) ->
    case f_master(Pid) of
        F = #fighter{type = ?fighter_type_role, is_clone = ?false} ->
            add_role_to_role_dmg(F, Target, DmgHp);
        _ -> ignore
    end;
add_role_to_role_dmg(#fighter{type = ?fighter_type_pet, pid = Pid}, #fighter{type = ?fighter_type_pet, pid = PetPid}, DmgHp) ->
    case f_master(Pid) of
        Self = #fighter{type = ?fighter_type_role, is_clone = ?false} ->
            case f_master(PetPid) of
                Target = #fighter{type = ?fighter_type_role, is_clone = ?false} ->
                    add_role_to_role_dmg(Self, Target, DmgHp);
                _ -> ignore
            end;
        _ -> ignore
    end;
add_role_to_role_dmg(_, _, _) -> ok.

%% 记录玩家对npc造成的伤害
add_role_to_npc_dmg(Self = #fighter{type = ?fighter_type_role, pid = Pid}, Target = #fighter{type = ?fighter_type_npc, base_id = NpcBaseId}, DmgHp) ->
    case get({role_to_npc_dmg, Pid}) of
        undefined -> put({role_to_npc_dmg, Pid}, [{NpcBaseId, DmgHp}]);
        L ->
            case lists:keyfind(NpcBaseId, 1, L) of
                {NpcBaseId, OldDmgHp} ->
                    put({role_to_npc_dmg, Pid}, [{NpcBaseId, OldDmgHp + DmgHp} | lists:keydelete(NpcBaseId, 1, L)]);
                _ -> 
                    put({role_to_npc_dmg, Pid}, [{NpcBaseId, DmgHp}|L])
            end
    end,
    add_role_to_npc_max_dmg(Self, Target, DmgHp);
add_role_to_npc_dmg(#fighter{type = ?fighter_type_pet, pid = Pid}, Target = #fighter{type = ?fighter_type_npc}, DmgHp) ->
    case f_master(Pid) of
        Master = #fighter{type = ?fighter_type_role} ->
            add_role_to_npc_dmg(Master, Target, DmgHp);
        _ -> ok
    end;
add_role_to_npc_dmg(_,_,_) -> ok.

add_demon_to_npc_dmg(#fighter{type = ?fighter_type_npc, subtype = ?fighter_subtype_demon, pid = Pid}, Target = #fighter{type = ?fighter_type_npc}, DmgHp) ->
    case f_ext(by_pid, Pid) of
        undefined -> ok;
        #fighter_ext_npc{master_pid = MasterPid} ->
            case f(by_pid, MasterPid) of
                Master = #fighter{type = ?fighter_type_role} ->
                    add_role_to_npc_dmg(Master, Target, DmgHp);
                _ ->
                    ok
            end
    end;
add_demon_to_npc_dmg(_,_,_) -> ok.


%% 记录玩家对npc的单次最高伤害
add_role_to_npc_max_dmg(_Self = #fighter{type = ?fighter_type_role, pid = Pid}, _Target = #fighter{type = ?fighter_type_npc, base_id = NpcBaseId}, DmgHp) ->
    case get({role_to_npc_dmg_max, Pid}) of
        undefined -> put({role_to_npc_dmg_max, Pid}, [{NpcBaseId, DmgHp}]);
        L ->
            case lists:keyfind(NpcBaseId, 1, L) of
                {NpcBaseId, OldDmgHpMax} when DmgHp > OldDmgHpMax ->
                    put({role_to_npc_dmg_max, Pid}, [{NpcBaseId, DmgHp} | lists:keydelete(NpcBaseId, 1, L)]);
                false ->
                    put({role_to_npc_dmg_max, Pid}, [{NpcBaseId, DmgHp} | L]);
                _ -> ignore
            end
    end;
add_role_to_npc_max_dmg(_,_,_) -> ok.

%% 记录玩家对玩家的单次最高伤害
add_role_to_role_max_dmg(_Self = #fighter{rid = _Rid, srv_id = _SrvId, type = ?fighter_type_role, pid = Pid, is_clone = ?false}, _Target = #fighter{type = ?fighter_type_role, rid = Trid, srv_id = TsrvId}, DmgHp) ->
    case get({role_to_role_dmg_max, Pid}) of
        undefined -> put({role_to_role_dmg_max, Pid}, [{{Trid, TsrvId}, DmgHp}]);
        L ->
            case lists:keyfind({Trid, TsrvId}, 1, L) of
                {_, OldDmgHpMax} when DmgHp > OldDmgHpMax ->
                    put({role_to_role_dmg_max, Pid}, [{{Trid, TsrvId}, DmgHp} | lists:keydelete({Trid, TsrvId}, 1, L)]);
                false ->
                    put({role_to_role_dmg_max, Pid}, [{{Trid, TsrvId}, DmgHp} | L]);
                _ -> ignore
            end
    end;
add_role_to_role_max_dmg(#fighter{type = ?fighter_type_npc, pid = Pid}, Target = #fighter{type = ?fighter_type_role}, DmgHp) ->
    case f_master(Pid) of
        F = #fighter{type = ?fighter_type_role, is_clone = ?false} ->
            add_role_to_role_max_dmg(F, Target, DmgHp);
        _ -> ignore
    end;
add_role_to_role_max_dmg(_,_,_) -> ok.


%% 获取玩家对玩家造成的伤害 -> [{RoleId, DmgHpTotal, DmgHpMax}]
get_role_to_role_dmg(Pid) ->
    case get({role_to_role_dmg, Pid}) of
        undefined -> [];
        L -> [{RoleId, DmgHpTotal, get_role_to_role_dmg_max(Pid, RoleId)} || {RoleId, DmgHpTotal} <- L]
    end.
%% 获取玩家对指定玩家造成的伤害 -> {DmgHpTotal, DmgHpMax}
get_role_to_role_dmg(Pid, RoleId) ->
    L = get_role_to_role_dmg(Pid),
    case lists:keyfind(RoleId, 1, L) of
        {_, DmgHpTotal, DmgHpMax} -> {DmgHpTotal, DmgHpMax};
        _ -> {0, 0}
    end.

%% 获取玩家对玩家造成的最大单次伤害
get_role_to_role_dmg_max(Pid, RoleId) ->
    case get({role_to_role_dmg_max, Pid}) of
        undefined -> 0;
        L ->
            case lists:keyfind(RoleId, 1, L) of
                {RoleId, DmgHpMax} -> DmgHpMax;
                _ -> 0
            end
    end.

%% 获取玩家对npc造成的伤害 -> [{NpcBaseId, DmgHpTotal, DmgHpMax}]
get_role_to_npc_dmg(Pid) ->
    case get({role_to_npc_dmg, Pid}) of
        undefined -> [];
        L -> [{NpcBaseId, DmgHpTotal, get_role_to_npc_dmg_max(Pid, NpcBaseId)} || {NpcBaseId, DmgHpTotal} <- L]
    end.
%% 获取玩家对指定npc造成的伤害 -> {DmgHpTotal, DmgHpMax}
% get_role_to_npc_dmg(Pid, NpcBaseId) ->
%     L = get_role_to_npc_dmg(Pid),
%     case lists:keyfind(NpcBaseId, 1, L) of
%         {NpcBaseId, DmgHpTotal, DmgHpMax} -> {DmgHpTotal, DmgHpMax};
%         _ -> {0, 0}
%     end.

%% 获取玩家对npc造成的最大单次伤害
get_role_to_npc_dmg_max(Pid, NpcBaseId) ->
    case get({role_to_npc_dmg_max, Pid}) of
        undefined -> 0;
        L ->
            case lists:keyfind(NpcBaseId, 1, L) of
                {NpcBaseId, DmgHpMax} -> DmgHpMax;
                _ -> 0
            end
    end.

%% 记录npc对玩家造成的伤害
add_npc_to_role_dmg(#fighter{type = ?fighter_type_npc, rid = NpcBaseId}, #fighter{type = ?fighter_type_role, pid = Pid}, DmgHp) ->
    case get({npc_to_role_dmg, Pid}) of
        undefined -> put({npc_to_role_dmg, Pid}, [{NpcBaseId, DmgHp}]);
        L ->
            case lists:keyfind(NpcBaseId, 1, L) of
                {NpcBaseId, OldDmgHp} ->
                    put({npc_to_role_dmg, Pid}, [{NpcBaseId, OldDmgHp + DmgHp} | lists:keydelete(NpcBaseId, 1, L)]);
                _ -> 
                    put({npc_to_role_dmg, Pid}, [{NpcBaseId, DmgHp}|L])
            end
    end;
add_npc_to_role_dmg(_,_,_) -> ok.

%% 获取npc对玩家造成的伤害 -> [{NpcBaseId, DmgHpTotal}]
get_npc_to_role_dmg(Pid) ->
    case get({npc_to_role_dmg, Pid}) of
        L = [_|_] -> L;
        _ -> []
    end.



%%---------------------------------------------------
%% 副本评分相关
%%---------------------------------------------------
%% 获取参战者的副本评分所需要的数据 -> {Round, DmgMax, TotalHurt}
get_dungeon_score_data(#combat{round = Round}, Pid) ->
    %% 单次最高伤害
    DmgHistory = get_role_to_npc_dmg(Pid),
    DmgMaxList = [DmgHpMax || {_NpcBaseId, _DmgHpTotal, DmgHpMax} <- DmgHistory] ++ [0],
    DmgMax = lists:max(DmgMaxList),
    %% 总受伤
    HurtHistory = get_npc_to_role_dmg(Pid),
    HurtList = [Hurt || {_, Hurt} <- HurtHistory] ++ [0],
    TotalHurt = lists:sum(HurtList),
    {Round, DmgMax, TotalHurt}.
	
%%---------------------------------------------------
%% 怒气值相关
%%---------------------------------------------------
%% 是否可以使用怒气技能 -> ?true | ?false
% can_use_anger_skill(Pid) ->
%     case f(by_pid, Pid) of
%         {_, #fighter{anger = Anger}} ->
%             case Anger >= ?MAX_ANGER of
%                 true -> ?true;
%                 false -> ?false
%             end;
%         _ -> ?false
%     end.


% %% 判断是否有下一波怪
practice_has_next_wave() ->
    case get(practice_info) of
        {_, [_|_]} -> true;
        _ -> false
    end.

% %% 获取当前是第几波怪
practice_get_current_wave_no() ->
    case get(practice_info) of
        {WaveNo, _} when WaveNo > 1 -> WaveNo-1;
        _ -> 1
    end.

% %% 获取杀死的全部npc的base_id
practice_get_all_killed_npc() -> lists:reverse(get(practice_kill)).

% %% 获取是否房主的标志 -> [{?combat_special_is_room_master, ?true | ?false}] | []
practice_append_is_room_master(RoleId) ->
    case RoleId =:= get(room_master) of
        true -> [{?combat_special_is_room_master, ?true, <<>>}];
        false -> []
    end.


%%--------------------------------------------------
%% 通用的一波波怪这种模式相关
%%--------------------------------------------------
%% 初始化第一波怪 -> [#converted_fighter{}]
%% DfdList = [NpcBaseId]
%% NpcBaseId = integer()
%% StartWaveNo = integer() 从第几波开始
wave_init(DfdList, StartWaveNo) ->
    DfdList1 = lists:nthtail(StartWaveNo-1, DfdList),
    case DfdList1 of
        [NpcBaseId|T] ->
            case npc_data:get(NpcBaseId) of
                {ok, #npc_base{slave = Slave}} ->
                    put(wave_info, {StartWaveNo + 1, 0, T}),
                    NpcBaseIds = [NpcBaseId] ++ [Id || {Id, _, _} <- Slave],
                    gen_first_wave(NpcBaseIds, []);
                _ ->
                    ?ERR("指定base_id[~w]的NPC不存在", [NpcBaseId]),
                    []
            end;
        _ ->
            ?ERR("第一波怪配置错误:~w, ~w", [DfdList, StartWaveNo]),
            []
    end.

%% 生成第一波怪
gen_first_wave([], Result) -> lists:reverse(Result);
gen_first_wave([NpcBaseId|T], Result) ->
    case npc_convert:do(to_fighter, NpcBaseId) of
        {ok, CF} -> 
            gen_first_wave(T, [CF|Result]);
        _ -> 
            ?ERR("生成第一波怪物中的[NpcBaseId=~w]失败", [NpcBaseId]),
            gen_first_wave(T, Result)
    end.

%% 生成下一波怪

%% 判断是否有下一波怪
has_next_wave() ->
    case get(wave_info) of
        {_, _, [_ | _]} -> 
            true;
        _ -> 
            false
    end.



%%--------------------------------------------------
%% AI相关
%%--------------------------------------------------
%% 获取可以供ai使用的技能 -> [主动技能列表, 怒气技能列表]
%% 主动技能列表 = [{SkillIdPrefix, SkillId}]
%% 怒气技能列表 = [{SkillIdPrefix, SkillId}]
% get_available_ai_skills(#fighter{name = _Name, type = ?fighter_type_role, id = Sid, pid = Pid}, #combat{round = CurrentRound}) ->
%     #fighter_ext_role{skills = Skills, anger_skills = AngerSkills} = f_ext(by_pid, Pid),
%     AiSkills = [{get_skill_id_prefix(SkillId), SkillId} || Skill = #c_skill{id = SkillId} <- Skills, (not is_skill_in_cooldown(Sid, Skill, CurrentRound)) andalso SkillId>=10000],
%     AiAngerSkills = case can_use_anger_skill(Pid) of
%         ?true ->
%             [{get_skill_id_prefix(SkillId), SkillId} || #c_skill{id = SkillId} <- AngerSkills];
%         _ -> []
%     end,
%     {AiSkills, AiAngerSkills};
% get_available_ai_skills(_, _) ->
%     {[], []}.

%% 获取技能id的高3位
% get_skill_id_prefix(SkillId) ->
%     trunc(SkillId/100).


%%--------------------------------------------------
%% 宠物说话相关
%%--------------------------------------------------


%% 保存宠物状态
%% MasterRoleId = {Rid, SrvId}
%% MasterPid = pid()
save_pet_status(MasterRoleId, MasterPid) ->
    case get(original_combat) of
        #combat{type = ?combat_type_cross_king} ->
            case f_pet(MasterPid) of
                #fighter{pid = PetPid, type = ?fighter_type_pet, group = group_atk, hp = Hp, mp = Mp} ->
                    #fighter_ext_pet{original_id = PetId} = f_ext(by_pid, PetPid),
                    cross_king_mgr:save_pet_status(MasterRoleId, PetId, {Hp, Mp});
                _ -> ignore
            end;
        _ -> ignore
    end.


%%---------------------------------------------------
%% 宠物复活相关
%%---------------------------------------------------
%% 保存宠物复活自己的动作
add_to_pet_revive(ReviveSkill, Pet, HealHp) ->
    case get(pet_revive) of
        undefined -> put(pet_revive, [{ReviveSkill, Pet, HealHp}]);
        L -> put(pet_revive, [{ReviveSkill, Pet, HealHp}|L])
    end.



%% 获取该次战斗的所有协议（如果10710、10720和10721有一个为空则返回undefined）
get_all_replay() ->
    RP_10710 = get({combat_replay, 10710}),
    RP_10720 = get({combat_replay, 10720}),
    RP_10721 = get({combat_replay, 10721}),
    if
        RP_10710 =:= undefined orelse RP_10720 =:= undefined orelse RP_10720 =:= [] orelse RP_10721 =:= undefined orelse RP_10721 =:= [] ->
            undefined;
        true ->
            {{10710, RP_10710}, {10720, RP_10720}, {10721, RP_10721}}
    end.

%%---------------------------------------------------
%% 直播相关
%%---------------------------------------------------
%% 初次建立直播连接时发送一次10710
on_live_connected(DestSrvId, #combat{type = CombatType, round = Round}) ->
    L1 = [do(to_fighter_info, group_atk, F) || F <- get(group_atk)],
    L2 = [do(to_fighter_info, group_dfd, F) || F <- get(group_dfd)],
    FL = L1 ++ L2,
    ActionFighterIdOrderList = fighter_id_action_order(),
    {RoleList, PetList, NpcList} = sort_fighter_infos(FL),
    c_mirror_group:cast(node, DestSrvId, combat_live_mgr, recv_live, [self(), {10710, {Round, CombatType, ?enter_combat_type_normal, ?true, RoleList, PetList, NpcList, ActionFighterIdOrderList}}]).


%% 判断该技能是否能对死亡状态的角色使用
skill_check_on_dead(
    _PrevCheck = {true, _Why},
    _Skill = #c_skill{script_id = ScriptId},
    _Self,
    _Target = #fighter{is_die = IsTargetDie, hp = Thp}
) ->
    if
        IsTargetDie =:= ?true ->
            case ScriptId of
                10180 -> {true, <<>>};  %% 原飞仙复活技能
                10420 -> {true, <<>>};  %% 原飞仙复活技能
                100090 -> {true, <<>>};   %% 贤者技能：女神之光
                _ -> {false, ?MSGID(<<"不能对死亡目标使用">>)}
            end;
        IsTargetDie =:= ?false andalso Thp < 1 -> %% 频死状态特殊处理
            {false, ?MSGID(<<"不能对死亡目标使用">>)};
        true ->
            case ScriptId of
                10180 -> {false, ?MSGID(<<"只能对死亡目标使用">>)};
                10420 -> {false, ?MSGID(<<"只能对死亡目标使用">>)};
                _ -> {true, ?MSG_NULL}
            end
    end;
skill_check_on_dead(PrevCheck, _, _, _) ->
    PrevCheck.


%% 距离检测
%% 判断人与NPC距离
distance_check(#role{pos = #pos{map_pid = MapPid1, x = X1, y = Y1}}, #role{pos = #pos{map_pid = MapPid2, x = X2, y = Y2}}) ->
    distance_check(MapPid1, X1, Y1, MapPid2, X2, Y2);
distance_check(#role{cross_srv_id = CrossSrvId, pos = #pos{map_pid = MapPid1, x = X1, y = Y1}}, NpcId) ->
    case npc_mgr:get_npc(CrossSrvId, NpcId) of
        false -> null_npc;
        #npc{pos = #pos{map_pid = MapPid2, x = X2, y = Y2}} ->
            distance_check(MapPid1, X1, Y1, MapPid2, X2, Y2)
    end.
distance_check(MapPid1, X1, Y1, MapPid2, X2, Y2) ->
    DistX = erlang:abs(X1 - X2),
    DistY = erlang:abs(Y1 - Y2),
    if
        MapPid1 =:= MapPid2 andalso DistX =< 1000 andalso DistY =< 1000 ->
            true;
        true ->
            false
    end.


%% 组队情况下的判断
team_check(Role = #role{team_pid = TeamPid}) ->
    %% 是否有队伍
    A = not is_pid(TeamPid),
    %% 是否队长
    B = case team_api:is_leader(Role) of
        {T, _} -> T;
        K -> K
    end,
    %% 是否暂离队员
    C = team_api:is_tempout_member(Role),
    %% 三者有一个符合就行
    (A=:=true) orelse (B=:=true) orelse (C=:=true).


init_fighter_pos(CombatType, Group, Fighters) ->
    init_fighter_pos(CombatType, Group, Fighters, 1, []).

init_fighter_pos(CombatType, Group, [F|T], Pos, Ret) ->
    case F#fighter.type of
        ?fighter_type_pet -> %% 宠物(不指定站位)
            init_fighter_pos(CombatType, Group, T, Pos, [F|Ret]);
        ?fighter_type_role -> %% 角色（指定站位，并强制控制角色坐标）
            {X, Y} = hold_pos(Group, Pos, F#fighter.id),
            Fighter = F#fighter{x = X, y = Y},
            case is_pid(Fighter#fighter.pid) of
                true ->
                    case CombatType of
                        ?combat_type_tree -> ignore;
                        ?combat_type_wanted_role -> ignore;
                        ?combat_type_wanted_npc -> ignore;
                        _ ->
                            role:apply(async, Fighter#fighter.pid, {fun force_move/3, [Fighter#fighter.x, Fighter#fighter.y]})
                    end;
                _ ->
                    ignore
            end,
            init_fighter_pos(CombatType, Group, T, Pos+1, [Fighter|Ret]);
        _ -> %% npc (指定站位，不需要改变坐标)
            {X, Y} = hold_pos(Group, Pos, F#fighter.id),
            Fighter = F#fighter{x = X, y = Y},
            init_fighter_pos(CombatType, Group, T, Pos+1, [Fighter|Ret])
    end;
init_fighter_pos(_CombatType, _Group, [], _Index, Ret) ->
    Ret.

%% 初始化站位
%% -> any()
init_pos(RefX, Type) ->
    init_lineup(RefX, Type),
    put({group_atk, hold}, {0, 0, 0}),
    put({group_dfd, hold}, {0, 0, 0}).

%% 新手副本站位
init_lineup(RefX, ?combat_type_tutorial) ->
    put({group_atk, pos}, {
            {RefX - 300, ?combat_upper_pos_y3},
            {RefX - 410, ?combat_lower_pos_y3},
            {RefX - 520, ?combat_upper_pos_y3}
    }),
    put({group_dfd, pos}, {
            {RefX + 0, ?combat_upper_pos_y3},
            {RefX + 110, ?combat_lower_pos_y3},
            {RefX + 220, ?combat_upper_pos_y3}
    });
%% 多人副本（远征王军）站位
init_lineup(RefX, ?combat_type_expedition) ->
    put({group_atk, pos}, {
            {RefX - 300, ?combat_upper_pos_y2},
            {RefX - 410, ?combat_middle_pos_y2},
            {RefX - 520, ?combat_lower_pos_y2}
    }),
    put({group_dfd, pos}, {
            {RefX + 0, ?combat_upper_pos_y2},
            {RefX + 110, ?combat_middle_pos_y2},
            {RefX + 220, ?combat_lower_pos_y2}
    });
%% 一般站位
init_lineup(RefX, _Type) ->
    case get(is_fighting_super_boss) of
        ?true -> %% 世界boss
            put({group_atk, pos}, {
                    {RefX - 300, ?combat_upper_pos_y},
                    {RefX - 410, ?combat_lower_pos_y},
                    {RefX - 520, ?combat_upper_pos_y}
            }),
            put({group_dfd, pos}, {
                    {RefX + 110, ?combat_lower_pos_y},
                    {RefX + 0, ?combat_upper_pos_y},
                    {RefX + 220, ?combat_upper_pos_y}
            });
        _ ->  %% 一般怪
            put({group_atk, pos}, {
                    {RefX - 300, ?combat_upper_pos_y},
                    {RefX - 410, ?combat_lower_pos_y},
                    {RefX - 520, ?combat_upper_pos_y}
            }),
            put({group_dfd, pos}, {
                    {RefX + 0, ?combat_upper_pos_y},
                    {RefX + 110, ?combat_lower_pos_y},
                    {RefX + 220, ?combat_upper_pos_y}
            })
    end.

%% -> null | integer()
find_empty_pos(Group) ->
    find_empty_pos0(get({Group, hold})).
find_empty_pos0({0, _, _}) -> 1;
find_empty_pos0({_, 0, _}) -> 2;
find_empty_pos0({_, _, 0}) -> 3;
find_empty_pos0({_, _, _}) -> null.

%% -> {X, Y}
hold_pos(Group, Pos, FighterId) ->
    ?log("分配站位 group=~p id = ~p pos=~p", [Group, FighterId, Pos]),
    Holds = get({Group, hold}),
    put({Group, hold}, erlang:setelement(Pos, Holds, FighterId)),
    erlang:element(Pos, get({Group, pos})).

%% -> null | {X, Y}
hold_empty_pos(Group, FighterId) ->
    case find_empty_pos(Group) of
        null -> null;
        Pos -> hold_pos(Group, Pos, FighterId)
    end.

%% -> any()
% release_pos(Group, FighterId) ->
%     NewHold = case get({Group, hold}) of
%         {FighterId, A, B} -> {0, A, B};
%         {A, FighterId, B} -> {A, 0, B};
%         {A, B, FighterId} -> {A, B, 0};
%         Other -> Other
%     end,
%     ?log("释放站位 group=~p id = ~p old_hold=~w new_hold=~w", [Group, FighterId, get({Group, hold}), NewHold]),
%     put({Group, hold}, NewHold).

%% ----------------
force_move(Role=#role{pid = RolePid, pos=Pos=#pos{map_pid=MapPid, x=X, y=Y}}, DestX, DestY) 
when is_pid(MapPid), is_pid(RolePid) ->
    map:role_jump(MapPid, RolePid, X, Y, DestX, DestY), %% 跳到位置
    {ok, Role#role{pos=Pos#pos{x=DestX, y=DestY}}};
force_move(Role=#role{pos=Pos}, DestX, DestY) ->
    {ok, Role#role{pos=Pos#pos{x=DestX, y=DestY}}}.

sort_fighter_infos(FighterInfos) ->
    sort_fighter_infos(FighterInfos, {[], [], []}).

sort_fighter_infos([Fighter|T], {RoleList, PetList, NpcList}) ->
    Ret = case Fighter#fighter_info.type of
        ?fighter_type_role ->
            {[Fighter|RoleList], PetList, NpcList};
        ?fighter_type_pet ->
            ?DEBUG("type pet base_id=~p rid=~p", [Fighter#fighter_info.base_id, Fighter#fighter_info.rid]),
            {RoleList, [Fighter|PetList], NpcList};
        ?fighter_type_npc ->
            ?DEBUG("type npc base_id=~p rid=~p", [Fighter#fighter_info.base_id, Fighter#fighter_info.rid]),
            {RoleList, PetList, [Fighter|NpcList]}
    end,     
    sort_fighter_infos(T, Ret);
sort_fighter_infos([], Ret) ->
    Ret.

erase_script_state(ScriptId) ->
    erase({script_state, ScriptId}).
get_script_state(ScriptId) ->
    get({script_state, ScriptId}).
set_script_state(ScriptId, State) ->
    put({script_state, ScriptId}, State).

%% -> any()
set_action_state(Pid, Key, Value) ->
    case f(by_pid, Pid) of
        {Group, Fighter} ->
            State = Fighter#fighter.act_state,
            NewState = case lists:keymember(Key, 1, State) of
                true -> lists:keyreplace(Key, 1, State, {Key, Value});
                false -> [{Key, Value}|State]
            end,
            u(Fighter#fighter{act_state = NewState}, Group);
        _ ->
            ignore
    end.

%% -> undefined |  
get_action_state(Pid, Key) ->
    case f(by_pid, Pid) of
        {_Group, Fighter} ->
            State = Fighter#fighter.act_state,
            case lists:keyfind(Key, 1, State) of
                {_Key, Value} -> Value;
                _ -> undefined
            end;
        _ ->
            undefined
    end.

%% -> any()
clear_action_state(Pid, Key) ->
    case f(by_pid, Pid) of
        {Group, Fighter} ->
            State = Fighter#fighter.act_state,
            NewState = lists:keydelete(Key, 1, State),
            u(Fighter#fighter{act_state = NewState}, Group);
        _ ->
            ignore
    end.

%% -> any()
clear_action_state() ->
    [ u(F#fighter{act_state = []}, group_atk) || F <- get(group_atk) ],
    [ u(F#fighter{act_state = []}, group_dfd) || F <- get(group_dfd) ].

%% -> any()
clear_action_act() ->
    [ u(F#fighter{act = undefined}, group_atk) || F <- get(group_atk) ],
    [ u(F#fighter{act = undefined}, group_dfd) || F <- get(group_dfd) ].


get_fighter_state(Pid, Key) ->
    get({fighter_state, Pid, Key}).

get_fighter_state(Pid, Key, Def) ->
    case get({fighter_state, Pid, Key}) of
        undefined -> Def;
        Val -> Val
    end.

set_fighter_state(Pid, {Key, Value}) ->
    put({fighter_state, Pid, Key}, Value).

clear_fighter_state(Pid, Key) ->
    erase({fighter_state, Pid, Key}).


%% -> any()
add_dynamic_buff(CombatPid, RolePid, BuffId, Duration) ->
    CombatPid ! {add_dynamic_buff, RolePid, BuffId, Duration}.

%%
join_helper_queue(npc, NpcBaseId) ->
    Queue = case get(helpers_queue) of
        undefined -> [];
        Q -> Q
    end,
    put(helpers_queue, Queue ++ [{npc, NpcBaseId}]).


%% 剧情npc逃离战斗
escape_with_story_npcs(#fighter{pid = MasterPid, group = Group}) ->
    lists:foreach(fun(F)->
        case F#fighter.subtype =:= ?fighter_subtype_story of
            true ->
                case f_ext(by_pid, F#fighter.pid) of
                    undefined -> ignore;
                    Fext ->
                        case Fext#fighter_ext_npc.master_pid of
                            MasterPid ->
                                combat:update_fighter(F#fighter.pid, [{is_escape, ?true}]);
                            _ ->
                                ignore
                        end
                end;
            _ ->
                ignore
        end
    end, get(Group)).

escape_with_demon(#fighter{pid = MasterPid, group = Group}) ->
    lists:foreach(fun(F)->
        case F#fighter.subtype =:= ?fighter_subtype_demon of
            true ->
                case f_ext(by_pid, F#fighter.pid) of
                    undefined -> ignore;
                    Fext ->
                        case Fext#fighter_ext_npc.master_pid of
                            MasterPid ->
                                combat:update_fighter(F#fighter.pid, [{is_escape, ?true}]);
                            _ ->
                                ignore
                        end
                end;
            _ ->
                ignore
        end
    end, get(Group)).

%% ======= 中途加入玩家队列 ========================================
exists_in_role_queue(#converted_fighter{pid = Pid}) ->
    case lists:keyfind(Pid, #converted_fighter.pid, get_role_queue() ) of
        false -> false;
        _ -> true
    end.

join_role_queue(Group, CF) ->
    Queue = case get(join_role_queue) of
        undefined -> [];
        Q -> Q
    end,
    put(join_role_queue, Queue ++ {Group, CF}).

get_role_queue() ->
    case get(join_role_queue) of
        undefined -> [];
        Q -> Q
    end.

remove_from_role_join_queue(Pid) ->
    Queue = lists:keydelete(Pid, #converted_fighter.pid, get_role_queue()),
    put(join_role_queue, Queue).
    
% remove_from_role_join_queue(Group, Pid) ->
%     put({Group, queue}, lists:keydelete(Pid, #fighter.pid, get({Group, queue}))).
