%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 技能效果
%%% @end
%%% Created : 27. 一月 2015 下午2:23
%%%-------------------------------------------------------------------
-module(effect).
-author("fancy").
-include("battle.hrl").
-include("common.hrl").
-include("skill.hrl").
-include("scene.hrl").

%% API
% {Key,killid,{key,skill},_slv,_stask,V}
-export([
    add_effect/4,
    prepare/5,
    active/4,
    last_active/4,
    last_active_der/4,
    trigger_effect/4,
    active_eff/3,
    end_eff/3,
    active_eff_mon/3
]).

%%添加效果
%% v 效果加成系数
add_effect(BS, [], _skillid, _v) -> BS;
add_effect(BS, EffList, SkillId, V) ->
    NewEffList = BS#bs.eff_list ++ prepare(EffList, SkillId, V, [], #attacker{}),
    BS#bs{eff_list = NewEffList}.

%%转换效果列表
prepare([], _SkillId, _V, Efflist, _Attacker) -> Efflist;
prepare([{Effid, Target, Args} | L], SkillId, V, EffList, Attacker) ->
    prepare(L, SkillId, V, [#eff{key = {SkillId, Effid}, effid = Effid, v = V, args = Args, target = Target, attacker = Attacker} | EffList], Attacker).

%%触发效果 [瞬间触发,不回写属性]
trigger_effect(BS, Effid, Target, Args) ->
    EffList = prepare([{Effid, Target, Args}], 0, 1, [], #attacker{}),
    active(EffList, BS, #bs{}, 1).


%%战斗伤害前激活
active(EffList, Aer, Der, N) ->
    eff(EffList, Aer, Der, N).

%%战斗伤害后激活
last_active(EffList, Aer, Der, Hurt) ->
    leff(EffList, Aer, Der, Hurt).
last_active_der(EffList, Aer, Der, Hurt) ->
    leff_der(EffList, Aer, Der, Hurt).


%%战斗外玩家激活
active_eff([], Player, _Now) ->
    Player;
%%改变速度
active_eff([#eff{effid = 11033, args = Args, v = V, key = Key} | L], Player, _Now) ->
    [Num, Sec | _] = Args,
    Val = Num * V,
    Speed = to_value(?BASE_SPEED, Val),
    server_send:send_node_pid(Player#player.node, Player#player.pid, {set_speed_eff, Key}),
    spawn(fun() ->
        timer:sleep(Sec * 1000),
        server_send:send_node_pid(Player#player.node, Player#player.pid, {speed_reset, true})
          end),
    Player1 = Player#player{attribute = Player#player.attribute#attribute{speed = Speed}},
    scene_agent_dispatch:speed_update(Player1),
    active_eff(L, Player1, _Now);
%%持续回血/掉血
active_eff([#eff{effid = 11047, args = Args, v = V, key = EffKey, attacker = Attacker} | L], Player, Now) ->
    [Hurt, Sec | _] = Args,
    Val = Hurt * V,
    case scene:get_scene_pid(Player#player.scene, Player#player.copy) of
        ?SCENE_TYPE_CROSS_All ->
            spawn(fun() -> util:sleep(1000),
                cross_all:apply(scene_agent_dispatch, dispatch, [Player#player.scene, Player#player.copy, {hp_change, EffKey, Player#player.key, ?SIGN_PLAYER, Val, Sec, Attacker}]) end);
        ?SCENE_TYPE_CROSS_AREA ->
            spawn(fun() -> util:sleep(1000),
                cross_area:apply(scene_agent_dispatch, dispatch, [Player#player.scene, Player#player.copy, {hp_change, EffKey, Player#player.key, ?SIGN_PLAYER, Val, Sec, Attacker}]) end);
        ?SCENE_TYPE_CROSS_WAR_AREA ->
            spawn(fun() -> util:sleep(1000),
                cross_area:war_apply(scene_agent_dispatch, dispatch, [Player#player.scene, Player#player.copy, {hp_change, EffKey, Player#player.key, ?SIGN_PLAYER, Val, Sec, Attacker}]) end);
        ScenePid ->
            erlang:send_after(1000, ScenePid, {hp_change, EffKey, Player#player.key, ?SIGN_PLAYER, Val, Sec, Attacker})
    end,
    active_eff(L, Player, Now);
%%恢复生命百分比
active_eff([#eff{effid = 11073, args = Args} | L], Player, Now) ->
    [Arg | _] = Args,
    Value = to_value(Player#player.attribute#attribute.hp_lim, Arg),
    Hp = min(Player#player.attribute#attribute.hp_lim, Player#player.hp + Value),
    {ok, Bin} = pt_200:write(20004, {[[?SIGN_PLAYER, Player#player.key, 1, Value, Hp]]}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player2 = Player#player{hp = Hp},
    scene_agent_dispatch:hpmp_update(Player2),
    active_eff(L, Player2, Now);
active_eff([_ | L], Player, Now) ->
    active_eff(L, Player, Now).


active_eff_mon([], Mon, _Now) ->
    Mon;
%%改变速度
active_eff_mon([#eff{effid = 11033, args = Args, v = V, key = Key} | L], Mon, _Now) ->
    [Num, Sec | _] = Args,
    Val = Num * V,
    Speed = to_value(Mon#mon.speed, Val),
    Mon#mon.pid ! {set_speed_eff, Key},
    spawn(fun() ->
        timer:sleep(Sec * 1000),
        Mon#mon.pid ! {speed_reset, true}
          end),
    Mon1 = Mon#mon{speed = Speed},
    active_eff_mon(L, Mon1, _Now);
%%持续回血/掉血
active_eff_mon([#eff{effid = 11047, args = Args, v = V, key = EffKey, attacker = Attacker} | L], Mon, Now) ->
    [Hurt, Sec | _] = Args,
    Val = Hurt * V,
    case scene:get_scene_pid(Mon#mon.scene, Mon#mon.copy) of
        ?SCENE_TYPE_CROSS_All ->
            spawn(fun() -> util:sleep(1000),
                cross_all:apply(scene_agent_dispatch, dispatch, [Mon#mon.scene, Mon#mon.copy, {hp_change, EffKey, Mon#mon.key, ?SIGN_MON, Val, Sec, Attacker}]) end);
        ?SCENE_TYPE_CROSS_AREA ->
            spawn(fun() -> util:sleep(1000),
                cross_area:apply(scene_agent_dispatch, dispatch, [Mon#mon.scene, Mon#mon.copy, {hp_change, EffKey, Mon#mon.key, ?SIGN_MON, Val, Sec, Attacker}]) end);
        ?SCENE_TYPE_CROSS_WAR_AREA ->
            spawn(fun() -> util:sleep(1000),
                cross_area:war_apply(scene_agent_dispatch, dispatch, [Mon#mon.scene, Mon#mon.copy, {hp_change, EffKey, Mon#mon.key, ?SIGN_MON, Val, Sec, Attacker}]) end);
        ScenePid ->
            erlang:send_after(1000, ScenePid, {hp_change, EffKey, Mon#mon.key, ?SIGN_MON, Val, Sec, Attacker})
    end,
    active_eff_mon(L, Mon, Now);
%%不能移动
active_eff_mon([#eff{effid = 11002, args = Args, v = V} | L], Mon, Now) ->
    TimeMark = Mon#mon.time_mark,
    [Arg | _] = Args,
    Sec = Arg * V,
    ExpireTime = ?IF_ELSE(Mon#mon.unyun > 0, 0, Now + Sec),
    TimeMark1 = TimeMark#time_mark{umt = ExpireTime},
    active_eff_mon(L, Mon#mon{time_mark = TimeMark1}, Now);
%%不能攻击
active_eff_mon([#eff{effid = 11003, args = Args, v = V} | L], Mon, Now) ->
    TimeMark = Mon#mon.time_mark,
    [Arg | _] = Args,
    Sec = Arg * V,
    ExpireTime = Now + Sec,
    TimeMark1 = TimeMark#time_mark{uat = ExpireTime},
    active_eff_mon(L, Mon#mon{time_mark = TimeMark1}, Now);
active_eff_mon([_ | L], Mon, Now) ->
    active_eff_mon(L, Mon, Now).

%% ---local function ---

eff([], Aer, Der, _N) -> {Aer, Der};

%% 无敌
eff([#eff{effid = 11001, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Sec = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            ExpireTime = Aer#bs.now + Sec,
            TimeMark = Aer#bs.time_mark,
            eff(L, Aer#bs{time_mark = TimeMark#time_mark{godt = ExpireTime}}, Der, N);
        ?TARGET_DEF ->
            ExpireTime = Der#bs.now + Sec,
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{godt = ExpireTime}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            ExpireTime = Der#bs.now + Sec,
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{godt = ExpireTime}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            ExpireTime = Der#bs.now + Sec,
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{godt = ExpireTime}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%不能移动 以buff时间为准
eff([#eff{effid = 11002, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Sec = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            BsArgs = Aer#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unyun > 0 orelse BsArgs#bs_args.unctrl > Aer#bs.now, 0, Aer#bs.now + Sec),
            TimeMark = Aer#bs.time_mark,
            eff(L, Aer#bs{time_mark = TimeMark#time_mark{umt = ExpireTime}}, Der, N);
        ?TARGET_DEF ->
            BsArgs = Der#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unyun > 0 orelse BsArgs#bs_args.unctrl > Der#bs.now, 0, Der#bs.now + Sec),
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{umt = ExpireTime}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BsArgs = Der#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unyun > 0 orelse BsArgs#bs_args.unctrl > Der#bs.now, 0, Der#bs.now + Sec),
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{umt = ExpireTime}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BsArgs = Der#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unyun > 0 orelse BsArgs#bs_args.unctrl > Der#bs.now, 0, Der#bs.now + Sec),
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{umt = ExpireTime}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;


%%不能攻击
eff([#eff{effid = 11003, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Sec = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            BsArgs = Aer#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unctrl > Aer#bs.now, 0, Aer#bs.now + Sec),
            TimeMark = Aer#bs.time_mark,
            eff(L, Aer#bs{time_mark = TimeMark#time_mark{uat = ExpireTime}}, Der, N);
        ?TARGET_DEF ->
            BsArgs = Der#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unctrl > Aer#bs.now, 0, Der#bs.now + Sec),
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{uat = ExpireTime}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BsArgs = Der#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unctrl > Aer#bs.now, 0, Der#bs.now + Sec),
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{uat = ExpireTime}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BsArgs = Der#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unctrl > Aer#bs.now, 0, Der#bs.now + Sec),
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{uat = ExpireTime}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;


%%不能施法
eff([#eff{effid = 11004, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Sec = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            ExpireTime = Aer#bs.now + Sec,
            TimeMark = Aer#bs.time_mark,
            eff(L, Aer#bs{time_mark = TimeMark#time_mark{uct = ExpireTime}}, Der, N);
        ?TARGET_DEF ->
            ExpireTime = Aer#bs.now + Sec,
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{uct = ExpireTime}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            ExpireTime = Aer#bs.now + Sec,
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{uct = ExpireTime}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            ExpireTime = Aer#bs.now + Sec,
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{uct = ExpireTime}}, N);
        _ ->
            eff(L, Aer, Der, N)

    end;


%%免疫硬值
eff([#eff{effid = 11005, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Sec = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            ExpireTime = Aer#bs.now + Sec,
            TimeMark = Aer#bs.time_mark,
            eff(L, Aer#bs{time_mark = TimeMark#time_mark{uft = ExpireTime}}, Der, N);
        ?TARGET_DEF ->
            ExpireTime = Aer#bs.now + Sec,
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{uft = ExpireTime}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            ExpireTime = Aer#bs.now + Sec,
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{uft = ExpireTime}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            ExpireTime = Aer#bs.now + Sec,
            TimeMark = Der#bs.time_mark,
            eff(L, Aer, Der#bs{time_mark = TimeMark#time_mark{uft = ExpireTime}}, N);
        _ ->
            eff(L, Aer, Der, N)

    end;


%%解除buff
eff([#eff{effid = 11006, target = Target, args = Args} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    case Target of
        ?TARGET_ATT when N == 1 ->
            BuffList = lists:keydelete(Arg, 2, Aer#bs.buff_list),
            eff(L, Aer#bs{buff_list = BuffList}, Der, N);
        ?TARGET_DEF ->
            BuffList = lists:keydelete(Arg, 2, Der#bs.buff_list),
            eff(L, Aer, Der#bs{buff_list = BuffList}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BuffList = lists:keydelete(Arg, 2, Der#bs.buff_list),
            eff(L, Aer, Der#bs{buff_list = BuffList}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BuffList = lists:keydelete(Arg, 2, Der#bs.buff_list),
            eff(L, Aer, Der#bs{buff_list = BuffList}, N);
        _ ->
            eff(L, Aer, Der, N)

    end;


%%必定命中
eff([#eff{effid = 11007, target = Target} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            BsArgs = Aer#bs.bs_args,
            eff(L, Aer#bs{bs_args = BsArgs#bs_args{fix_hit = true}}, Der, N);
        ?TARGET_DEF ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_hit = true}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_hit = true}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_hit = true}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%变身
eff([#eff{effid = 11008, target = Target, args = Args} | L], Aer, Der, N) ->
    [Figure, Sec | _] = Args,
    case Target of
        ?TARGET_ATT when N == 1 ->
            ?DO_IF(Aer#bs.sign == ?SIGN_PLAYER, Aer#bs.pid ! {figure, Figure, Sec});
        ?TARGET_DEF ->
            ?DO_IF(Der#bs.sign == ?SIGN_PLAYER, Der#bs.pid ! {figure, Figure, Sec});
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            ?DO_IF(Der#bs.sign == ?SIGN_PLAYER, Der#bs.pid ! {figure, Figure, Sec});
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            ?DO_IF(Der#bs.sign == ?SIGN_PLAYER, Der#bs.pid ! {figure, Figure, Sec});
        _ ->
            skip

    end,
    eff(L, Aer, Der, N);

%%防御变动n%
eff([#eff{effid = 11010, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Def = to_value(Aer#bs.def, Val),
            eff(L, Aer#bs{def = Def}, Der, N);
        ?TARGET_DEF ->
            Def = to_value(Der#bs.def, Val),
            eff(L, Aer, Der#bs{def = Def}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Def = to_value(Der#bs.def, Val),
            eff(L, Aer, Der#bs{def = Def}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Def = to_value(Der#bs.def, Val),
            eff(L, Aer, Der#bs{def = Def}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%普攻必然miss
eff([#eff{effid = 11012, target = Target} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            BsArgs = Aer#bs.bs_args,
            eff(L, Aer#bs{bs_args = BsArgs#bs_args{fix_miss = true}}, Der, N);
        ?TARGET_DEF ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_miss = true}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_miss = true}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_miss = true}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%治疗效果变动n%
eff([#eff{effid = 11013, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Cure = to_value(Aer#bs.cure, Val),
            eff(L, Aer#bs{cure = Cure}, Der, N);
        ?TARGET_DEF ->
            Cure = to_value(Der#bs.cure, Val),
            eff(L, Aer, Der#bs{cure = Cure}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Cure = to_value(Der#bs.cure, Val),
            eff(L, Aer, Der#bs{cure = Cure}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Cure = to_value(Der#bs.cure, Val),
            eff(L, Aer, Der#bs{cure = Cure}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%打断吟唱后触发buffid(针对怪物)
eff([#eff{effid = 11014, target = Target, args = Args} | L], Aer, Der, N) ->
    [Buffid | _] = Args,
    case Target of
        ?TARGET_ATT when N == 1 ->
            ?DO_IF(Aer#bs.sign == ?SIGN_MON, Aer#bs.pid ! {block_buff, Buffid});
        ?TARGET_DEF ->
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {block_buff, Buffid});
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {block_buff, Buffid});
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {block_buff, Buffid});
        _ ->
            skip
    end,
    eff(L, Aer, Der, N);

%%%%受到物理伤害变动n%
eff([#eff{effid = 11015, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            HurtDec = Val + Aer#bs.hurt_dec,
            eff(L, Aer#bs{hurt_dec = HurtDec}, Der, N);
        ?TARGET_DEF ->
            HurtDec = Val + Der#bs.hurt_dec,
            eff(L, Aer, Der#bs{hurt_dec = HurtDec}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            HurtDec = Val + Der#bs.hurt_dec,
            eff(L, Aer, Der#bs{hurt_dec = HurtDec}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            HurtDec = Val + Der#bs.hurt_dec,
            eff(L, Aer, Der#bs{hurt_dec = HurtDec}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%所有技能进入cd
eff([#eff{effid = 11016, target = Target} | L], Aer, Der, N) ->
    Now = Aer#bs.now,
    F = fun({Sid, _Slv, _state}) ->
        DataSkill = skill:get_skill(Sid),
        CdSec = DataSkill#skill.cd,
        {Sid, Now + CdSec}
        end,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Skills = Aer#bs.skill,
            SkillCd = lists:map(F, Skills),
            eff(L, Aer#bs{new_skill_cd = SkillCd ++ Aer#bs.new_skill_cd}, Der, N);
        ?TARGET_DEF ->
            Skills = Der#bs.skill,
            SkillCd = lists:map(F, Skills),
            eff(L, Aer, Der#bs{new_skill_cd = SkillCd ++ Der#bs.new_skill_cd}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Skills = Der#bs.skill,
            SkillCd = lists:map(F, Skills),
            eff(L, Aer, Der#bs{new_skill_cd = SkillCd ++ Der#bs.new_skill_cd}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Skills = Der#bs.skill,
            SkillCd = lists:map(F, Skills),
            eff(L, Aer, Der#bs{new_skill_cd = SkillCd ++ Der#bs.new_skill_cd}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%破冰伤害增加n%
eff([#eff{effid = 11017, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            BsArgs = Aer#bs.bs_args,
            Hurt = to_value(BsArgs#bs_args.ice_hurt, Val),
            eff(L, Aer#bs{bs_args = BsArgs#bs_args{ice_hurt = Hurt}}, Der, N);
        ?TARGET_DEF ->
            BsArgs = Der#bs.bs_args,
            Hurt = to_value(BsArgs#bs_args.ice_hurt, Val),
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{ice_hurt = Hurt}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BsArgs = Der#bs.bs_args,
            Hurt = to_value(BsArgs#bs_args.ice_hurt, Val),
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{ice_hurt = Hurt}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BsArgs = Der#bs.bs_args,
            Hurt = to_value(BsArgs#bs_args.ice_hurt, Val),
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{ice_hurt = Hurt}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%不受物理伤害
eff([#eff{effid = 11018, target = Target} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            BsArgs = Aer#bs.bs_args,
            eff(L, Aer#bs{bs_args = BsArgs#bs_args{zero_p_hurt = true}}, Der, N);
        ?TARGET_DEF ->
            BsArgs = Aer#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{zero_p_hurt = true}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BsArgs = Aer#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{zero_p_hurt = true}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BsArgs = Aer#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{zero_p_hurt = true}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%不受魔法伤害
%%eff([#eff{effid = 11009, target = Target} | L], Aer, Der, N) ->
%%    case Target of
%%        ?TARGET_ATT when N==1 ->
%%            BsArgs = Aer#bs.bs_args,
%%            eff(L, Aer#bs{bs_args = BsArgs#bs_args{zero_m_hurt = true}}, Der, N);
%%        1 ->
%%            BsArgs = Aer#bs.bs_args,
%%            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{zero_m_hurt = true}}, N);
%%        _ ->
%%            eff(L, Aer, Der, N)
%%    end;

%%每次攻击或者施法减少buff持续时间
eff([#eff{effid = 11020, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [BuffId, Sec | _] = Args,
    Val = Sec * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            BuffList = Aer#bs.buff_list,
            BuffList2 =
                case lists:keyfind(BuffId, 2, BuffList) of
                    false ->
                        BuffList;
                    Buff ->
                        OldTime = Buff#skillbuff.time,
                        lists:keyreplace(BuffId, 2, BuffList, Buff#skillbuff{time = max(0, OldTime - Val)})
                end,
            eff(L, Aer#bs{buff_list = BuffList2}, Der, N);
        ?TARGET_DEF ->
            BuffList = Der#bs.buff_list,
            BuffList2 =
                case lists:keyfind(BuffId, 2, BuffList) of
                    false ->
                        BuffList;
                    Buff ->
                        OldTime = Buff#skillbuff.time,
                        lists:keyreplace(BuffId, 2, BuffList, Buff#skillbuff{time = max(0, OldTime - Val)})
                end,
            eff(L, Aer, Der#bs{buff_list = BuffList2}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BuffList = Der#bs.buff_list,
            BuffList2 =
                case lists:keyfind(BuffId, 2, BuffList) of
                    false ->
                        BuffList;
                    Buff ->
                        OldTime = Buff#skillbuff.time,
                        lists:keyreplace(BuffId, 2, BuffList, Buff#skillbuff{time = max(0, OldTime - Val)})
                end,
            eff(L, Aer, Der#bs{buff_list = BuffList2}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BuffList = Der#bs.buff_list,
            BuffList2 =
                case lists:keyfind(BuffId, 2, BuffList) of
                    false ->
                        BuffList;
                    Buff ->
                        OldTime = Buff#skillbuff.time,
                        lists:keyreplace(BuffId, 2, BuffList, Buff#skillbuff{time = max(0, OldTime - Val)})
                end,
            eff(L, Aer, Der#bs{buff_list = BuffList2}, N);
        _ ->
            eff(L, Aer, Der, N)

    end;

%%攻击变动n
eff([#eff{effid = 11021, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = max(0, round(Aer#bs.att + Val)),
            eff(L, Aer#bs{att = Value}, Der, N);
        ?TARGET_DEF ->
            Value = max(0, round(Der#bs.att + Val)),
            eff(L, Aer, Der#bs{att = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = max(0, round(Der#bs.att + Val)),
            eff(L, Aer, Der#bs{att = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = max(0, round(Der#bs.att + Val)),
            eff(L, Aer, Der#bs{att = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%防御变动n
eff([#eff{effid = 11022, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = max(0, round(Aer#bs.def + Val)),
            eff(L, Aer#bs{def = Value}, Der, N);
        ?TARGET_DEF ->
            Value = max(0, round(Der#bs.def + Val)),
            eff(L, Aer, Der#bs{def = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = max(0, round(Der#bs.def + Val)),
            eff(L, Aer, Der#bs{def = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = max(0, round(Der#bs.def + Val)),
            eff(L, Aer, Der#bs{def = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%%%魔防变动
%%eff([#eff{effid = 11023, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
%%    [Arg | _] = Args,
%%    Val = Arg * V,
%%    case Target of
%%        ?TARGET_ATT when N==1 ->
%%            Value = max(0, round(Aer#bs.def_m + Val)),
%%            eff(L, Aer#bs{def_m = Value}, Der, N);
%%        1 ->
%%            Value = max(0, round(Der#bs.def_m + Val)),
%%            eff(L, Aer, Der#bs{def_m = Value}, N);
%%        _ ->
%%            eff(L, Aer, Der, N)
%%    end;

%%生命变动
eff([#eff{effid = 11024, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = max(0, round(Aer#bs.hp_lim + Val)),
            eff(L, Aer#bs{hp_lim = Value}, Der, N);
        ?TARGET_DEF ->
            Value = max(0, round(Der#bs.hp_lim + Val)),
            eff(L, Aer, Der#bs{hp_lim = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = max(0, round(Der#bs.hp_lim + Val)),
            eff(L, Aer, Der#bs{hp_lim = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = max(0, round(Der#bs.hp_lim + Val)),
            eff(L, Aer, Der#bs{hp_lim = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%生命变动%n
eff([#eff{effid = 11060, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = to_value(Aer#bs.hp_lim, Val),
            eff(L, Aer#bs{hp_lim = Value}, Der, N);
        ?TARGET_DEF ->
            Value = to_value(Der#bs.hp_lim, Val),
            eff(L, Aer, Der#bs{hp_lim = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = to_value(Der#bs.hp_lim, Val),
            eff(L, Aer, Der#bs{hp_lim = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = to_value(Der#bs.hp_lim, Val),
            eff(L, Aer, Der#bs{hp_lim = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%闪避变动n
eff([#eff{effid = 11025, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = max(0, round(Aer#bs.dodge + Val)),
            eff(L, Aer#bs{dodge = Value}, Der, N);
        ?TARGET_DEF ->
            Value = max(0, round(Der#bs.dodge + Val)),
            eff(L, Aer, Der#bs{dodge = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = max(0, round(Der#bs.dodge + Val)),
            eff(L, Aer, Der#bs{dodge = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = max(0, round(Der#bs.dodge + Val)),
            eff(L, Aer, Der#bs{dodge = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%命中变动n
eff([#eff{effid = 11026, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = max(0, round(Aer#bs.hit + Val)),
            eff(L, Aer#bs{hit = Value}, Der, N);
        ?TARGET_DEF ->
            Value = max(0, round(Der#bs.hit + Val)),
            eff(L, Aer, Der#bs{hit = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = max(0, round(Der#bs.hit + Val)),
            eff(L, Aer, Der#bs{hit = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = max(0, round(Der#bs.hit + Val)),
            eff(L, Aer, Der#bs{hit = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%暴击变动
eff([#eff{effid = 11027, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = max(0, round(Aer#bs.crit + Val)),
            eff(L, Aer#bs{crit = Value}, Der, N);
        ?TARGET_DEF ->
            Value = max(0, round(Der#bs.crit + Val)),
            eff(L, Aer, Der#bs{crit = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = max(0, round(Der#bs.crit + Val)),
            eff(L, Aer, Der#bs{crit = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = max(0, round(Der#bs.crit + Val)),
            eff(L, Aer, Der#bs{crit = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%坚韧变动
eff([#eff{effid = 11028, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = max(0, round(Aer#bs.ten + Val)),
            eff(L, Aer#bs{ten = Value}, Der, N);
        ?TARGET_DEF ->
            Value = max(0, round(Der#bs.ten + Val)),
            eff(L, Aer, Der#bs{ten = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = max(0, round(Der#bs.ten + Val)),
            eff(L, Aer, Der#bs{ten = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = max(0, round(Der#bs.ten + Val)),
            eff(L, Aer, Der#bs{ten = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%锁定目标不造成AOE伤害
eff([#eff{effid = 11030, target = Target} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            BsArgs = Aer#bs.bs_args,
            eff(L, Aer#bs{bs_args = BsArgs#bs_args{fix_target = 1}}, Der, N);
        ?TARGET_DEF ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_target = 1}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_target = 1}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_target = 1}}, N);
        _ ->
            eff(L, Aer, Der, N)

    end;

%%概率提升伤害百分比
eff([#eff{effid = 11031, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Ratio, Num | _] = Args,
    Val = Num * V,
    case util:odds(Ratio * 100, 100) of
        true ->
            case Target of
                ?TARGET_ATT when N == 1 ->
                    BsArgs = Aer#bs.bs_args,
                    eff(L, Aer#bs{bs_args = BsArgs#bs_args{hurt_inc = Val}}, Der, N);
                ?TARGET_DEF ->
                    BsArgs = Der#bs.bs_args,
                    eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{hurt_inc = Val}}, N);
                ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
                    BsArgs = Der#bs.bs_args,
                    eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{hurt_inc = Val}}, N);
                ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
                    BsArgs = Der#bs.bs_args,
                    eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{hurt_inc = Val}}, N);
                _ ->
                    eff(L, Aer, Der, N)

            end;
        _ ->
            eff(L, Aer, Der, N)

    end;

%%移动速度变动n%
eff([#eff{effid = 11033, target = Target, args = Args, v = V, key = Key} | L], Aer, Der, N) ->
    [Num, Sec | _] = Args,
    Val = Num * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Speed = to_value(Aer#bs.base_speed, Val),
            server_send:send_node_pid(Aer#bs.node, Aer#bs.pid, {set_speed_eff, Key}),
            spawn(fun() ->
                {ok, Bin} = pt_200:write(20006, {Aer#bs.sign, Aer#bs.key, Speed}),
                server_send:send_to_scene(Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Bin),
                timer:sleep(Sec * 1000),
                server_send:send_node_pid(Aer#bs.node, Aer#bs.pid, {speed_reset, true})
                  end),
            eff(L, Aer#bs{speed = Speed}, Der, N);
        ?TARGET_DEF ->
            Speed = to_value(Der#bs.base_speed, Val),
            server_send:send_node_pid(Der#bs.node, Der#bs.pid, {set_speed_eff, Key}),
            spawn(fun() ->
                {ok, Bin} = pt_200:write(20006, {Der#bs.sign, Der#bs.key, Speed}),
                server_send:send_to_scene(Der#bs.scene, Der#bs.copy, Der#bs.x, Der#bs.y, Bin),
                timer:sleep(Sec * 1000),
                server_send:send_node_pid(Der#bs.node, Der#bs.pid, {speed_reset, true})
                  end),
            eff(L, Aer, Der#bs{speed = Speed}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Speed = to_value(Der#bs.base_speed, Val),
            server_send:send_node_pid(Der#bs.node, Der#bs.pid, {set_speed_eff, Key}),
            spawn(fun() ->
                {ok, Bin} = pt_200:write(20006, {Der#bs.sign, Der#bs.key, Speed}),
                server_send:send_to_scene(Der#bs.scene, Der#bs.copy, Der#bs.x, Der#bs.y, Bin),
                timer:sleep(Sec * 1000),
                server_send:send_node_pid(Der#bs.node, Der#bs.pid, {speed_reset, true})
                  end),
            eff(L, Aer, Der#bs{speed = Speed}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Speed = to_value(Der#bs.base_speed, Val),
            server_send:send_node_pid(Der#bs.node, Der#bs.pid, {set_speed_eff, Key}),
            spawn(fun() ->
                {ok, Bin} = pt_200:write(20006, {Der#bs.sign, Der#bs.key, Speed}),
                server_send:send_to_scene(Der#bs.scene, Der#bs.copy, Der#bs.x, Der#bs.y, Bin),
                timer:sleep(Sec * 1000),
                server_send:send_node_pid(Der#bs.node, Der#bs.pid, {speed_reset, true})
                  end),
            eff(L, Aer, Der#bs{speed = Speed}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;


%%炸弹效果 type = 0 怪物和玩家 1 玩家 2 怪物
eff([#eff{effid = 11034, args = Args} | L], Aer, Der, N) when N == 1 ->
    [Type, HurtType, Area, V | _] = Args,
    TargetList =
        case Type of
            1 ->
                scene_agent:get_scene_player_for_battle(Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Area, [], Aer#bs.group);
            2 ->
                mon_agent:get_scene_mon_for_battle(Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Area, [], Aer#bs.group, Aer#bs.sign);
            _ ->
                scene_agent:get_scene_obj_for_battle(Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Area, [], Aer#bs.group)
        end,
    F = fun(Obj) ->
        BS = battle:init_data(Obj, Aer#bs.now2),
        Hurt = ?IF_ELSE(HurtType == 0, round(V), round(BS#bs.hp_lim * abs(V))),
        Hp = max(0, BS#bs.hp - Hurt),
        HurtList = BS#bs.hurt_list,
        HurtList2 = [[?HURT_TYPE_NORMAL, Hurt] | HurtList],
        BS#bs{hp = Hp, hurt_list = HurtList2, actor = ?ACTOR_DEF}
        end,
    DerList = lists:map(F, TargetList),
    eff(L, Aer#bs{der_list = DerList}, Der, N);


%% N%概率获得buffid
eff([#eff{effid = 11035, key = Key, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Ratio | BuffidList] = Args,
    {SkillId, _EffID} = Key,
    Ratio2 = Ratio * V,
    case util:odds(Ratio2 * 100, 100) of
        true ->
            Attacker = battle:make_attacker(Aer, 0),
            case Target of
                ?TARGET_ATT when N == 1 ->
                    Aer2 = buff:add_buff(Aer, BuffidList, SkillId, 1, Attacker),
                    eff(L, Aer2, Der, N);
                ?TARGET_DEF ->
                    Der2 = buff:add_buff(Der, BuffidList, SkillId, 1, Attacker),
                    eff(L, Aer, Der2, N);
                ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
                    Der2 = buff:add_buff(Der, BuffidList, SkillId, 1, Attacker),
                    eff(L, Aer, Der2, N);
                ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
                    Der2 = buff:add_buff(Der, BuffidList, SkillId, 1, Attacker),
                    eff(L, Aer, Der2, N);
                _ ->
                    eff(L, Aer, Der, N)
            end;
        false ->
            eff(L, Aer, Der, N)

    end;

%%目标mp变动n%
eff([#eff{effid = 11036, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = to_value(Aer#bs.mp_lim, Val),
            eff(L, Aer#bs{mp_lim = Value}, Der, N);
        ?TARGET_DEF ->
            Value = to_value(Der#bs.mp_lim, Val),
            eff(L, Aer, Der#bs{mp_lim = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = to_value(Der#bs.mp_lim, Val),
            eff(L, Aer, Der#bs{mp_lim = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = to_value(Der#bs.mp_lim, Val),
            eff(L, Aer, Der#bs{mp_lim = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;


%%打断持续，引导施法
eff([#eff{effid = 11037, target = Target} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            ?DO_IF(Aer#bs.sign == ?SIGN_MON, Aer#bs.pid ! {stop_ready});
        ?TARGET_DEF ->
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {stop_ready});
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {stop_ready});
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {stop_ready});
        _ -> ok

    end,
    eff(L, Aer, Der, N);


%%造成n点伤害
eff([#eff{effid = 11038, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = round(Arg * V),
    case Target of
        ?TARGET_ATT when N == 1 ->
            TimeMark = Aer#bs.time_mark,
            if
                Aer#bs.now > TimeMark#time_mark.godt ->
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Val] | Aer#bs.hurt_list],
                    Hp = ?IF_ELSE(Aer#bs.hp - Val =< 0, 1, Aer#bs.hp - Val),
                    eff(L, Aer#bs{hp = Hp, hurt_list = HurtList}, Der, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Val] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Val =< 0, 1, Der#bs.hp - Val),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Val] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Val =< 0, 1, Der#bs.hp - Val),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Val] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Val =< 0, 1, Der#bs.hp - Val),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        _ ->
            eff(L, Aer, Der, N)
    end;

%%造成攻击者的攻击力*n%伤害
eff([#eff{effid = 11039, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            TimeMark = Aer#bs.time_mark,
            if
                Aer#bs.now > TimeMark#time_mark.godt ->
                    Value = round(Aer#bs.att * Val),
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Value] | Aer#bs.hurt_list],
                    Hp = ?IF_ELSE(Aer#bs.hp - Value =< 0, 1, Aer#bs.hp - Value),
                    eff(L, Aer#bs{hp = Hp, hurt_list = HurtList}, Der, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    Value = round(Aer#bs.att * Val),
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Value] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Value =< 0, 1, Der#bs.hp - Value),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    Value = round(Aer#bs.att * Val),
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Value] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Value =< 0, 1, Der#bs.hp - Value),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    Value = round(Aer#bs.att * Val),
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Value] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Value =< 0, 1, Der#bs.hp - Value),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        _ ->
            eff(L, Aer, Der, N)
    end;

%%目标每有1层buffid,则伤害增加n%
eff([#eff{effid = 11040, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Buffid, Pre | _] = Args,
    Val = Pre, V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            case lists:keyfind(Buffid, 2, Aer#bs.buff_list) of
                false ->
                    eff(L, Aer, Der, N);
                Buff ->
                    Value = round(Val * Buff#skillbuff.stack),
                    BsArgs = Aer#bs.bs_args,
                    eff(L, Aer#bs{bs_args = BsArgs#bs_args{hurt_inc = Value}}, Der, N)
            end;
        ?TARGET_DEF ->
            case lists:keyfind(Buffid, 2, Der#bs.buff_list) of
                false ->
                    eff(L, Aer, Der, N);
                Buff ->
                    Value = round(Val * Buff#skillbuff.stack),
                    BsArgs = Der#bs.bs_args,
                    eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{hurt_inc = Value}}, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            case lists:keyfind(Buffid, 2, Der#bs.buff_list) of
                false ->
                    eff(L, Aer, Der, N);
                Buff ->
                    Value = round(Val * Buff#skillbuff.stack),
                    BsArgs = Der#bs.bs_args,
                    eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{hurt_inc = Value}}, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            case lists:keyfind(Buffid, 2, Der#bs.buff_list) of
                false ->
                    eff(L, Aer, Der, N);
                Buff ->
                    Value = round(Val * Buff#skillbuff.stack),
                    BsArgs = Der#bs.bs_args,
                    eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{hurt_inc = Value}}, N)
            end;
        _ ->
            eff(L, Aer, Der, N)
    end;

%%自杀效果
eff([#eff{effid = 11041, target = Target} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            TimeMark = Aer#bs.time_mark,
            if
                Aer#bs.now > TimeMark#time_mark.godt andalso (Aer#bs.kind == ?MON_KIND_NORMAL orelse Aer#bs.kind == ?MON_KIND_REMOVE_TRAP orelse Aer#bs.kind == ?MON_KIND_CROSS_BATTLEFIELD_BUFF) ->
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Aer#bs.hp] | Aer#bs.hurt_list],
                    eff(L, Aer#bs{hp = 0, hurt_list = HurtList}, Der, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt andalso (Aer#bs.kind == ?MON_KIND_NORMAL orelse Aer#bs.kind == ?MON_KIND_REMOVE_TRAP orelse Aer#bs.kind == ?MON_KIND_CROSS_BATTLEFIELD_BUFF) ->
                    Hurtlist = [[?HURT_TYPE_BUFF_DEC, Der#bs.hp] | Der#bs.hurt_list],
                    eff(L, Aer, Der#bs{hp = 0, hurt_list = Hurtlist}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt andalso (Aer#bs.kind == ?MON_KIND_NORMAL orelse Aer#bs.kind == ?MON_KIND_REMOVE_TRAP orelse Aer#bs.kind == ?MON_KIND_CROSS_BATTLEFIELD_BUFF) ->
                    Hurtlist = [[?HURT_TYPE_BUFF_DEC, Der#bs.hp] | Der#bs.hurt_list],
                    eff(L, Aer, Der#bs{hp = 0, hurt_list = Hurtlist}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt andalso (Aer#bs.kind == ?MON_KIND_NORMAL orelse Aer#bs.kind == ?MON_KIND_REMOVE_TRAP orelse Aer#bs.kind == ?MON_KIND_CROSS_BATTLEFIELD_BUFF) ->
                    Hurtlist = [[?HURT_TYPE_BUFF_DEC, Der#bs.hp] | Der#bs.hurt_list],
                    eff(L, Aer, Der#bs{hp = 0, hurt_list = Hurtlist}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        _ ->
            eff(L, Aer, Der, N)
    end;


%%获得护盾，抵消n点伤害，持续a秒
eff([#eff{effid = 11043, target = Target, args = Args, v = V, key = Key} | L], Aer, Der, N) ->
    [Num, Sec | _] = Args,
    Val1 = Num * V,
    Val = case lists:member(Aer#bs.boss,[?BOSS_TYPE_FIELD,?BOSS_TYPE_CROSS]) of
              false -> Val1;
              true ->
                  active_proc:get_active(Val1)
          end,
    case Target of
        ?TARGET_ATT when N == 1 ->
            ObjRef = Aer#bs.obj_ref,
            ScenePid = scene:get_scene_pid(Aer#bs.scene, Aer#bs.copy),
            [catch erlang:cancel_timer(OldRef) || {_, OldRef} <- ObjRef#obj_ref.ref_mana],
            Ref = erlang:send_after(Sec * 1000, ScenePid, {mana_reset, Aer#bs.key, Aer#bs.sign}),
            NewRef = ObjRef#obj_ref{ref_mana = [{Key, Ref}]},
            eff(L, Aer#bs{mana_lim = Val, mana = Val, obj_ref = NewRef}, Der, N);
        ?TARGET_DEF ->
            ObjRef = Der#bs.obj_ref,
            ScenePid = scene:get_scene_pid(Der#bs.scene, Der#bs.copy),
            [catch erlang:cancel_timer(OldRef) || {_, OldRef} <- ObjRef#obj_ref.ref_mana],
            Ref = erlang:send_after(Sec * 1000, ScenePid, {mana_reset, Der#bs.key, Der#bs.sign}),
            NewRef = ObjRef#obj_ref{ref_mana = [{Key, Ref}]},
            eff(L, Aer#bs{mana_lim = Val, mana = Val, obj_ref = NewRef}, Der, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            ObjRef = Der#bs.obj_ref,
            ScenePid = scene:get_scene_pid(Der#bs.scene, Der#bs.copy),
            [catch erlang:cancel_timer(OldRef) || {_, OldRef} <- ObjRef#obj_ref.ref_mana],
            Ref = erlang:send_after(Sec * 1000, ScenePid, {mana_reset, Der#bs.key, Der#bs.sign}),
            NewRef = ObjRef#obj_ref{ref_mana = [{Key, Ref}]},
            eff(L, Aer#bs{mana_lim = Val, mana = Val, obj_ref = NewRef}, Der, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            ObjRef = Der#bs.obj_ref,
            ScenePid = scene:get_scene_pid(Der#bs.scene, Der#bs.copy),
            [catch erlang:cancel_timer(OldRef) || {_, OldRef} <- ObjRef#obj_ref.ref_mana],
            Ref = erlang:send_after(Sec * 1000, ScenePid, {mana_reset, Der#bs.key, Der#bs.sign}),
            NewRef = ObjRef#obj_ref{ref_mana = [{Key, Ref}]},
            eff(L, Aer#bs{mana_lim = Val, mana = Val, obj_ref = NewRef}, Der, N);
        _ -> eff(L, Aer, Der, N)
    end;

%%范围内持续加血扣血，持续n秒
%% p 0相对坐标1绝对坐标
%% x,y
%% aera 范围
%% n秒数
%% A 系数参数
%% B 常数参数
%% Type Ax+B  x类型 0为系数V，1为攻击者等级 2,女神守护伤害公式
eff([#eff{effid = 11029, args = Args, v = V, key = EffKey} | L], Aer, Der, N) ->
    [P, X, Y, Area, Sec, A, B, Type | _] = Args,
    if
        N == 1 ->
            BsArgs = Aer#bs.bs_args,
            {X1, Y1} = if
                           BsArgs#bs_args.tx > 0 andalso BsArgs#bs_args.ty > 0 ->   %%优先固定点
                               {BsArgs#bs_args.tx, BsArgs#bs_args.ty};
                           true ->
                               ?IF_ELSE(P == 0, {Aer#bs.x + X, Aer#bs.y + Y}, {X, Y})
                       end,
            ScenePid = scene:get_scene_pid(Aer#bs.scene, Aer#bs.copy),
            Val = case Type of
                      1 -> round(A * Aer#bs.lv + B);
                      2 -> -1 * round(math:pow(Aer#bs.lv, A) + B);
                      _ -> A * V + B
                  end,
            Attacker = battle:make_attacker(Aer, Val),
            erlang:send_after(1000, ScenePid, {area_hp_change, EffKey, Aer#bs.copy, X1, Y1, Area, Val, Sec, [Aer#bs.key], Aer#bs.group, Attacker});
        true ->
            skip
    end,
    eff(L, Aer, Der, N);

%%每秒加血扣血，持续a秒
eff([#eff{effid = 11047, target = Target, args = Args, v = V, key = EffKey, attacker = Attacker1} | L], Aer, Der, N) ->
    [Hurt, Sec | _] = Args,
    Val = Hurt * V,
    Attacker = ?IF_ELSE(Attacker1#attacker.key == 0, battle:make_attacker(Aer, abs(Val)), Attacker1),
    case Target of
        ?TARGET_ATT when N == 1 ->
            TimeMark = Aer#bs.time_mark,
            if
                Aer#bs.now > TimeMark#time_mark.godt ->
                    ObjRef = Aer#bs.obj_ref,
                    ScenePid = scene:get_scene_pid(Aer#bs.scene, Aer#bs.copy),
                    {_, OldRef} = ?FIND_DEFAULT(EffKey, 1, ObjRef#obj_ref.ref_hp_list, {ref, none}),
                    Ref =
                        case OldRef == none orelse erlang:read_timer(OldRef) == false of
                            true ->
                                erlang:send_after(1000, ScenePid, {hp_change, EffKey, Aer#bs.key, Aer#bs.sign, Val, Sec, Attacker});
                            false ->
                                OldRef
                        end,
                    Ref_hp_list = [{EffKey, Ref} | lists:keydelete(EffKey, 1, ObjRef#obj_ref.ref_hp_list)],
                    eff(L, Aer#bs{obj_ref = ObjRef#obj_ref{ref_hp_list = Ref_hp_list}}, Der, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                (Der#bs.sign == ?SIGN_MON andalso Der#bs.kind == ?MON_KIND_MANOR) ->
                    eff(L, Aer, Der, N);
                Der#bs.now > TimeMark#time_mark.godt ->
                    ObjRef = Der#bs.obj_ref,
                    ScenePid = scene:get_scene_pid(Der#bs.scene, Der#bs.copy),
                    {_, OldRef} = ?FIND_DEFAULT(EffKey, 1, ObjRef#obj_ref.ref_hp_list, {ref, none}),
                    Ref =
                        case OldRef == none orelse erlang:read_timer(OldRef) == false of
                            true ->
                                erlang:send_after(1000, ScenePid, {hp_change, EffKey, Der#bs.key, Der#bs.sign, Val, Sec, Attacker});
                            false ->
                                OldRef
                        end,
                    Ref_hp_list = [{EffKey, Ref} | lists:keydelete(EffKey, 1, ObjRef#obj_ref.ref_hp_list)],
                    eff(L, Aer, Der#bs{obj_ref = ObjRef#obj_ref{ref_hp_list = Ref_hp_list}}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                (Der#bs.sign == ?SIGN_MON andalso Der#bs.kind == ?MON_KIND_MANOR) ->
                    eff(L, Aer, Der, N);
                Der#bs.now > TimeMark#time_mark.godt ->
                    ObjRef = Der#bs.obj_ref,
                    ScenePid = scene:get_scene_pid(Der#bs.scene, Der#bs.copy),
                    {_, OldRef} = ?FIND_DEFAULT(EffKey, 1, ObjRef#obj_ref.ref_hp_list, {ref, none}),
                    Ref =
                        case OldRef == none orelse erlang:read_timer(OldRef) == false of
                            true ->
                                erlang:send_after(1000, ScenePid, {hp_change, EffKey, Der#bs.key, Der#bs.sign, Val, Sec, Attacker});
                            false ->
                                OldRef
                        end,
                    Ref_hp_list = [{EffKey, Ref} | lists:keydelete(EffKey, 1, ObjRef#obj_ref.ref_hp_list)],
                    eff(L, Aer, Der#bs{obj_ref = ObjRef#obj_ref{ref_hp_list = Ref_hp_list}}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            TimeMark = Der#bs.time_mark,
            if
                (Der#bs.sign == ?SIGN_MON andalso Der#bs.kind == ?MON_KIND_MANOR) ->
                    eff(L, Aer, Der, N);
                Der#bs.now > TimeMark#time_mark.godt ->
                    ObjRef = Der#bs.obj_ref,
                    ScenePid = scene:get_scene_pid(Der#bs.scene, Der#bs.copy),
                    {_, OldRef} = ?FIND_DEFAULT(EffKey, 1, ObjRef#obj_ref.ref_hp_list, {ref, none}),
                    Ref =
                        case OldRef == none orelse erlang:read_timer(OldRef) == false of
                            true ->
                                erlang:send_after(1000, ScenePid, {hp_change, EffKey, Der#bs.key, Der#bs.sign, Val, Sec, Attacker});
                            false ->
                                OldRef
                        end,
                    Ref_hp_list = [{EffKey, Ref} | lists:keydelete(EffKey, 1, ObjRef#obj_ref.ref_hp_list)],
                    eff(L, Aer, Der#bs{obj_ref = ObjRef#obj_ref{ref_hp_list = Ref_hp_list}}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        _ ->
            eff(L, Aer, Der, N)
    end;

%%将目标拉至自己身前一格
eff([#eff{effid = 11048, target = Target} | L], Aer, Der, N) ->
    BsArgs = Der#bs.bs_args,
    case Target of
        ?TARGET_DEF ->
            case BsArgs#bs_args.unholding > 0 of
                false ->
                    X = ?IF_ELSE(Aer#bs.x > Der#bs.x, Aer#bs.x - 2, Aer#bs.x + 2),
                    Y = ?IF_ELSE(Aer#bs.y > Der#bs.y, Aer#bs.y - 2, Aer#bs.y + 2),
                    case scene:can_moved2(Aer#bs.scene, X, Y) of
                        true ->
                            eff(L, Aer, Der#bs{x = X, y = Y, is_move = ?EFF_POS_HOLDING}, N);
                        false ->
                            eff(L, Aer, Der, N)
                    end;
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            case BsArgs#bs_args.unholding > 0 of
                false ->
                    X = ?IF_ELSE(Aer#bs.x > Der#bs.x, Aer#bs.x - 2, Aer#bs.x + 2),
                    Y = ?IF_ELSE(Aer#bs.y > Der#bs.y, Aer#bs.y - 2, Aer#bs.y + 2),
                    case scene:can_moved2(Aer#bs.scene, X, Y) of
                        true ->
                            eff(L, Aer, Der#bs{x = X, y = Y, is_move = ?EFF_POS_HOLDING}, N);
                        false ->
                            eff(L, Aer, Der, N)
                    end;
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            case BsArgs#bs_args.unholding > 0 of
                false ->
                    X = ?IF_ELSE(Aer#bs.x > Der#bs.x, Aer#bs.x - 2, Aer#bs.x + 2),
                    Y = ?IF_ELSE(Aer#bs.y > Der#bs.y, Aer#bs.y - 2, Aer#bs.y + 2),
                    case scene:can_moved2(Aer#bs.scene, X, Y) of
                        true ->
                            eff(L, Aer, Der#bs{x = X, y = Y, is_move = ?EFF_POS_HOLDING}, N);
                        false ->
                            eff(L, Aer, Der, N)
                    end;
                true ->
                    eff(L, Aer, Der, N)
            end;
        _ ->
            eff(L, Aer, Der, N)
    end;

%% 冲向玩家身前一格
eff([#eff{effid = 11049} | L], Aer, Der, N) when N == 1 ->
    X = ?IF_ELSE(Aer#bs.x > Der#bs.x, Der#bs.x + 1, Der#bs.x - 1),
    Y = ?IF_ELSE(Aer#bs.y > Der#bs.y, Der#bs.y + 1, Der#bs.y - 1),
    case scene:can_moved2(Der#bs.scene, X, Y) of
        true ->
            eff(L, Aer#bs{x = X, y = Y, is_move = ?EFF_POS_SPRING}, Der, N);
        false ->
            eff(L, Aer, Der, N)
    end;

%% 使怪物释放技能
eff([#eff{effid = 11050, target = Target, args = Args} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    case Target of
        ?TARGET_ATT when N == 1 ->
            ?DO_IF(Aer#bs.sign == ?SIGN_MON, Aer#bs.pid ! {once_skill, Arg});
        ?TARGET_DEF ->
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {once_skill, Arg});
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {once_skill, Arg});
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {once_skill, Arg});
        _ ->
            skip
    end,
    eff(L, Aer, Der, N);


%%受到的暴击伤害提升n%
eff([#eff{effid = 11051, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = to_value(Aer#bs.crit_inc, Val),
            eff(L, Aer#bs{crit_inc = Value}, Der, N);
        ?TARGET_DEF ->
            Value = to_value(Der#bs.crit_inc, Val),
            eff(L, Aer, Der#bs{crit_inc = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = to_value(Der#bs.crit_inc, Val),
            eff(L, Aer, Der#bs{crit_inc = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = to_value(Der#bs.crit_inc, Val),
            eff(L, Aer, Der#bs{crit_inc = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%将被击方玩家身边的角色牵引到被击方身边
%% eff([#eff{effid = 11052,args = Args,v = V}|L],Aer,Der,N) ->
%%     [Arg|_] = Args,
%%     Area = Arg * V,
%%     AllObj = scene_agent:get_scene_obj_for_battle(Der#bs.scene,Der#bs.copy,Der#bs.x,Der#bs.y,Area,[Aer#bs.key,Der#bs.key],Der#bs.group),
%%     F = fun(Obj) ->
%%         BS = battle:init_data(Obj),
%%         X = ?IF_ELSE(BS#bs.x > Der#bs.x ,Der#bs.x + 1,Der#bs.x -1),
%%         Y = ?IF_ELSE(BS#bs.y > Der#bs.y ,Der#bs.y + 1,Der#bs.y -1),
%%         case scene:can_moved2(BS#bs.scene,X,Y) of
%%             true ->
%%                 BS#bs{x = X,y = Y};
%%             false ->
%%                 BS
%%         end
%%     end,
%%     DerList = lists:map(F,AllObj),
%%     eff(L,Aer#bs{der_list = DerList},Der,N);

eff([#eff{effid = 11052} | L], Aer, Der, N) ->
    if
        N == 1 ->
            BsArgs = Aer#bs.bs_args,
            eff(L, Aer#bs{bs_args = BsArgs#bs_args{eff_x = Der#bs.x, eff_y = Der#bs.y}}, Der, N);
        true ->
            BsArgs = Aer#bs.bs_args,
            X = BsArgs#bs_args.eff_x,
            Y = BsArgs#bs_args.eff_y,
            eff(L, Aer, Der#bs{x = X, y = Y, is_move = ?EFF_POS_HOLDING}, N)
    end;

%% 朝指定怪物id移动 (针对怪物)
eff([#eff{effid = 11053, target = Target, args = Args} | L], Aer, Der, N) ->
    [Mid | _] = Args,
    case mon_agent:get_scene_mon_by_mid(Aer#bs.scene, Aer#bs.copy, Mid) of
        [Mon | _] ->
            case Target of
                ?TARGET_ATT when N == 1 ->
                    ?DO_IF(Aer#bs.sign == ?SIGN_MON, Aer#bs.pid ! {trace, Mon#mon.key, Mon#mon.pid, ?SIGN_MON});
                ?TARGET_DEF ->
                    ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {trace, Mon#mon.key, Mon#mon.pid, ?SIGN_MON});
                ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
                    ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {trace, Mon#mon.key, Mon#mon.pid, ?SIGN_MON});
                ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
                    ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {trace, Mon#mon.key, Mon#mon.pid, ?SIGN_MON});
                _ ->
                    skip
            end;
        _ ->
            skip
    end,
    eff(L, Aer, Der, N);

%% 逃跑 (针对怪物)
eff([#eff{effid = 11054, target = Target} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            Direction = util:get_direction(Aer#bs.x, Aer#bs.y, Der#bs.x, Der#bs.y),
            [DX, DY] = util:get_escape_direction(Direction),
            ?DO_IF(Aer#bs.sign == ?SIGN_MON, Aer#bs.pid ! {move, Aer#bs.x + DX, Aer#bs.y + DY});
        ?TARGET_DEF ->
            Direction = util:get_direction(Der#bs.x, Der#bs.y, Aer#bs.x, Aer#bs.y),
            [DX, DY] = util:get_escape_direction(Direction),
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {move, Der#bs.x + DX, Der#bs.y + DY});
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Direction = util:get_direction(Der#bs.x, Der#bs.y, Aer#bs.x, Aer#bs.y),
            [DX, DY] = util:get_escape_direction(Direction),
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {move, Der#bs.x + DX, Der#bs.y + DY});
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Direction = util:get_direction(Der#bs.x, Der#bs.y, Aer#bs.x, Aer#bs.y),
            [DX, DY] = util:get_escape_direction(Direction),
            ?DO_IF(Der#bs.sign == ?SIGN_MON, Der#bs.pid ! {move, Der#bs.x + DX, Der#bs.y + DY});
        _ ->
            skip
    end,
    eff(L, Aer, Der, N);


%%在原地召唤一个怪物 Type 0 自己身旁，1目标身旁
%% group : 0 无分组,只攻击玩家 ; 1 跟召唤者一组,优先继承召唤者分组,否则以召唤者key作为分组key; -1 怪物攻击怪物
eff([#eff{effid = 11055, args = Args} | L], Aer, Der, N) when N == 1 ->
    [Type, MonId, Num, X, Y, Rn, Group | _] = Args,
    if
        Type == 0 ->
            X1 = Aer#bs.x + X,
            Y1 = Aer#bs.y + Y,
            F = fun(_) ->
                X2 = util:list_rand(lists:seq((X1 - Rn), (X1 + Rn))),
                Y2 = util:list_rand(lists:seq((Y1 - Rn), (Y1 + Rn))),
                Group2 = ?IF_ELSE(Group == 1, ?IF_ELSE(Aer#bs.group > 0, Aer#bs.group, Aer#bs.key), Group),
                mon_agent:create_mon_cast([MonId, Aer#bs.scene, X2, Y2, Aer#bs.copy, 1, [{group, Group2}]])
                end,
            lists:foreach(F, lists:seq(1, Num));
        true ->
            X1 = Der#bs.x + X,
            Y1 = Der#bs.y + Y,
            F = fun(_) ->
                X2 = util:list_rand(lists:seq((X1 - Rn), (X1 + Rn))),
                Y2 = util:list_rand(lists:seq((Y1 - Rn), (Y1 + Rn))),
                Group2 = ?IF_ELSE(Group == 1, ?IF_ELSE(Aer#bs.group > 0, Aer#bs.group, Aer#bs.key), Group),
                mon_agent:create_mon_cast([MonId, Der#bs.scene, X2, Y2, Der#bs.copy, 1, [{group, Group2}]])
                end,
            lists:foreach(F, lists:seq(1, Num))
    end,
    eff(L, Aer, Der, N);

%%绝对坐标召唤怪物
eff([#eff{effid = 11056, args = Args} | L], Aer, Der, N) when N == 1 ->
    F = fun({MonId, X, Y, Group}) ->
        Group2 = ?IF_ELSE(Group == 1, ?IF_ELSE(Aer#bs.group > 0, Aer#bs.group, Aer#bs.key), Group),
        mon_agent:create_mon_cast([MonId, Der#bs.scene, X, Y, Der#bs.copy, 1, [{group, Group2}]]);
        ({MonId, X, Y, Group, IsAutoLv}) ->
            ArgsList =
                case IsAutoLv of
                    1 -> [{lv, Aer#bs.lv}];
                    2 -> [{auto_lv, Aer#bs.lv}];
                    _ -> []
                end,
            Group2 = ?IF_ELSE(Group == 1, ?IF_ELSE(Aer#bs.group > 0, Aer#bs.group, Aer#bs.key), Group),
            mon_agent:create_mon_cast([MonId, Der#bs.scene, X, Y, Der#bs.copy, 1, ArgsList ++ [{group, Group2}]])
        end,
    lists:foreach(F, Args),
    eff(L, Aer, Der, N);


%%有n%概率使目标击退n格
eff([#eff{effid = 11057, args = Args, v = V, target = Target} | L], Aer, Der, N) ->
    [Ratio, Area | _] = Args,
    Ratio2 = Ratio * V,
    case util:odds(Ratio2 * 100, 100) of
        true ->
            case Der#bs.bs_args#bs_args.unbeat_back > 0 of
                false ->
                    {X, Y} =
                        if
                            (Der#bs.y == Aer#bs.y) andalso (Aer#bs.x /= Der#bs.x) ->
                                {
                                    round(Der#bs.x + Area * (Der#bs.x - Aer#bs.x) div abs(Der#bs.x - Aer#bs.x)),
                                    round(Der#bs.y)
                                };
                            (Der#bs.x == Aer#bs.x) andalso (Aer#bs.y /= Der#bs.y) ->
                                {
                                    round(Der#bs.x),
                                    round(Der#bs.y + Area * (Der#bs.y - Aer#bs.y) div abs(Der#bs.y - Aer#bs.y))
                                };
                            true ->
                                Angle = math:atan2(Der#bs.y - Aer#bs.y, Der#bs.x - Aer#bs.x),
                                {
                                    round(Der#bs.x + Area * math:cos(Angle)),
                                    round(Der#bs.y + Area * math:sin(Angle))
                                }
                        end,
                    case Target of
                        ?TARGET_DEF ->
                            case scene:can_moved2(Aer#bs.scene, X, Y) of
                                true ->
                                    eff(L, Aer, Der#bs{x = X, y = Y, is_move = ?EFF_POS_BACK}, N);
                                false ->
                                    eff(L, Aer, Der, N)
                            end;
                        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
                            case scene:can_moved2(Aer#bs.scene, X, Y) of
                                true ->
                                    eff(L, Aer, Der#bs{x = X, y = Y, is_move = ?EFF_POS_BACK}, N);
                                false ->
                                    eff(L, Aer, Der, N)
                            end;
                        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
                            case scene:can_moved2(Aer#bs.scene, X, Y) of
                                true ->
                                    eff(L, Aer, Der#bs{x = X, y = Y, is_move = ?EFF_POS_BACK}, N);
                                false ->
                                    eff(L, Aer, Der, N)
                            end;
                        _ ->
                            eff(L, Aer, Der, N)
                    end;
                true ->
                    eff(L, Aer, Der, N)
            end;
        false ->
            eff(L, Aer, Der, N)
    end;

eff([#eff{effid = 110570, args = Args, v = V, target = Target} | L], Aer, Der, N) ->
    [Ratio, Area, Cd | _] = Args,
    Ratio2 = Ratio * V,
    case util:odds(Ratio2 * 100, 100) of
        true ->
            case Der#bs.bs_args#bs_args.unbeat_back == 0 andalso Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 andalso Der#bs.shadow_key == 0 of
                true ->
                    if Der#bs.time_mark#time_mark.bbt + Cd < Der#bs.now ->
                        {X, Y} =
                            if
                                (Der#bs.y == Aer#bs.y) andalso (Aer#bs.x /= Der#bs.x) ->
                                    {
                                        round(Der#bs.x + Area * (Der#bs.x - Aer#bs.x) div abs(Der#bs.x - Aer#bs.x)),
                                        round(Der#bs.y)
                                    };
                                (Der#bs.x == Aer#bs.x) andalso (Aer#bs.y /= Der#bs.y) ->
                                    {
                                        round(Der#bs.x),
                                        round(Der#bs.y + Area * (Der#bs.y - Aer#bs.y) div abs(Der#bs.y - Aer#bs.y))
                                    };
                                true ->
                                    Angle = math:atan2(Der#bs.y - Aer#bs.y, Der#bs.x - Aer#bs.x),
                                    {
                                        round(Der#bs.x + Area * math:cos(Angle)),
                                        round(Der#bs.y + Area * math:sin(Angle))
                                    }
                            end,
                        case Target of
                            ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
                                case scene:can_moved2(Aer#bs.scene, X, Y) of
                                    true ->
                                        TimeMark = Der#bs.time_mark,
                                        NewTimeMark = TimeMark#time_mark{bbt = Der#bs.now},
                                        eff(L, Aer, Der#bs{x = X, y = Y, is_move = ?EFF_POS_BACK, time_mark = NewTimeMark}, N);
                                    false ->
                                        eff(L, Aer, Der, N)
                                end;
                            _ ->
                                case scene:can_moved2(Aer#bs.scene, X, Y) of
                                    true ->
                                        TimeMark = Der#bs.time_mark,
                                        NewTimeMark = TimeMark#time_mark{bbt = Der#bs.now},
                                        eff(L, Aer, Der#bs{x = X, y = Y, is_move = ?EFF_POS_BACK, time_mark = NewTimeMark}, N);
                                    false ->
                                        eff(L, Aer, Der, N)
                                end
                        end;
                        true ->
                            eff(L, Aer, Der, N)
                    end;
                false ->
                    eff(L, Aer, Der, N)
            end;
        false ->
            eff(L, Aer, Der, N)
    end;

%%造成被击者血量*n%伤害
eff([#eff{effid = 11058, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            TimeMark = Aer#bs.time_mark,
            if
                Aer#bs.now > TimeMark#time_mark.godt ->
                    Value = round(Der#bs.hp_lim * Val),
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Value] | Aer#bs.hurt_list],
                    Hp = ?IF_ELSE(Aer#bs.hp - Value =< 0, 1, Aer#bs.hp - Value),
                    eff(L, Aer#bs{hp = Hp, hurt_list = HurtList}, Der, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    Value = round(Der#bs.hp_lim * Val),
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Value] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Value =< 0, 1, Der#bs.hp - Value),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    Value = round(Der#bs.hp_lim * Val),
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Value] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Value =< 0, 1, Der#bs.hp - Value),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    Value = round(Der#bs.hp_lim * Val),
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Value] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Value =< 0, 1, Der#bs.hp - Value),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        _ ->
            eff(L, Aer, Der, N)
    end;


%%场上存活指定怪物id时,施法者和指定怪物id同时获得指定buffid
eff([#eff{effid = 11059, args = Args, key = Key} | L], Aer, Der, N) when N == 1 ->
    [MonId, BuffId | _] = Args,
    {SkillId, _EffID} = Key,
    MonList = mon_agent:get_scene_mon_by_mid(Aer#bs.scene, Aer#bs.copy, MonId),
    case MonList of
        [Mon | _] ->
            Attacker = battle:make_attacker(Aer, 0),
            Aer2 = buff:add_buff(Aer, [BuffId], SkillId, 1, Attacker),
            MonBs = battle:init_data(Mon, Aer#bs.now2),
            MonBs2 = buff:add_buff(MonBs, [BuffId], SkillId, 1, Attacker),
            Bs2Args = MonBs2#bs.bs_args,
            Bs2Args2 = Bs2Args#bs_args{zero_p_hurt = true, zero_m_hurt = true},
            eff(L, Aer2#bs{der_list = [MonBs2#bs{bs_args = Bs2Args2}]}, Der, N);
        _ ->
            eff(L, Aer, Der, N)

    end;

%% 若场上存在怪物id，触发buffid
eff([#eff{effid = 10075, args = Args, key = Key} | L], Aer, Der, N) when N == 1 ->
    [MonId, BuffId | _] = Args,
    {SkillId, _EffId} = Key,
    MonList = mon_agent:get_scene_mon_by_mid(Aer#bs.scene, Aer#bs.copy, MonId),
    case MonList of
        [_Mon | _] ->
            Attacker = battle:make_attacker(Aer, 0),
            Aer2 = buff:add_buff(Aer, [BuffId], SkillId, 1, Attacker),
            eff(L, Aer2, Der, N);
        _ ->
            eff(L, Aer, Der, N)
    end;


%% 自身n格单位获得buff
eff([#eff{effid = 11061, args = Args, target = Target, key = Key, v = V} | L], Aer, Der, N) ->
    [Arg, BuffId | _] = Args,
    {SkillId, _EffID} = Key,
    Area = Arg * V,
    Attacker = battle:make_attacker(Aer, 0),
    F = fun(Bs) ->
        buff:add_buff(Bs, [BuffId], SkillId, 1, Attacker)
        end,
    Buff = data_buff:get(BuffId),
    case Target of
        ?TARGET_ATT when N == 1 ->
            %%如果是减益效果，则排除队友
            Group = ?IF_ELSE(Buff#buff.type == 2 orelse Buff#buff.type == 3, Aer#bs.group, 0),
            AllObj = scene_agent:get_scene_obj_for_battle(Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Area, [Aer#bs.key, Der#bs.key], Group),
            BsList = [battle:init_data(Obj, Aer#bs.now2) || Obj <- AllObj],
            DerList = lists:map(F, BsList),
            if
                Buff#buff.type == 1 ->%%增益则包括自己
                    Aer2 = buff:add_buff(Aer, [BuffId], SkillId, 1, Attacker),
                    eff(L, Aer2#bs{der_list = DerList}, Der, N);
                true ->
                    eff(L, Aer#bs{der_list = DerList}, Der, N)
            end;
        ?TARGET_DEF ->
            Group = ?IF_ELSE(Buff#buff.type == 2 orelse Buff#buff.type == 3, Der#bs.group, 0),
            AllObj = scene_agent:get_scene_obj_for_battle(Der#bs.scene, Der#bs.copy, Der#bs.x, Der#bs.y, Area, [Aer#bs.key, Der#bs.key], Group),
            BsList = [battle:init_data(Obj, Aer#bs.now2) || Obj <- AllObj],
            DerList = lists:map(F, BsList),
            if
                Buff#buff.type == 1 ->
                    Der2 = buff:add_buff(Der, [BuffId], SkillId, 1, Attacker),
                    eff(L, Aer, Der2#bs{der_list = DerList}, N);
                true ->
                    eff(L, Aer, Der#bs{der_list = DerList}, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Group = ?IF_ELSE(Buff#buff.type == 2 orelse Buff#buff.type == 3, Der#bs.group, 0),
            AllObj = scene_agent:get_scene_obj_for_battle(Der#bs.scene, Der#bs.copy, Der#bs.x, Der#bs.y, Area, [Aer#bs.key, Der#bs.key], Group),
            BsList = [battle:init_data(Obj, Aer#bs.now2) || Obj <- AllObj],
            DerList = lists:map(F, BsList),
            if
                Buff#buff.type == 1 ->
                    Der2 = buff:add_buff(Der, [BuffId], SkillId, 1, Attacker),
                    eff(L, Aer, Der2#bs{der_list = DerList}, N);
                true ->
                    eff(L, Aer, Der#bs{der_list = DerList}, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Group = ?IF_ELSE(Buff#buff.type == 2 orelse Buff#buff.type == 3, Der#bs.group, 0),
            AllObj = scene_agent:get_scene_obj_for_battle(Der#bs.scene, Der#bs.copy, Der#bs.x, Der#bs.y, Area, [Aer#bs.key, Der#bs.key], Group),
            BsList = [battle:init_data(Obj, Aer#bs.now2) || Obj <- AllObj],
            DerList = lists:map(F, BsList),
            if
                Buff#buff.type == 1 ->
                    Der2 = buff:add_buff(Der, [BuffId], SkillId, 1, Attacker),
                    eff(L, Aer, Der2#bs{der_list = DerList}, N);
                true ->
                    eff(L, Aer, Der#bs{der_list = DerList}, N)
            end;
        _ ->
            eff(L, Aer, Der, N)

    end;

%%怒气变动n%
eff([#eff{effid = 11063, args = Args, target = Target, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = to_value(Aer#bs.mp, Val),
            Mp = max(0, min(Value, Aer#bs.mp_lim)),
            eff(L, Aer#bs{mp = Mp}, Der, N);
        ?TARGET_DEF ->
            Value = to_value(Der#bs.mp, Val),
            Mp = max(0, min(Value, Der#bs.mp_lim)),
            eff(L, Aer, Der#bs{mp = Mp}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = to_value(Der#bs.mp, Val),
            Mp = max(0, min(Value, Der#bs.mp_lim)),
            eff(L, Aer, Der#bs{mp = Mp}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = to_value(Der#bs.mp, Val),
            Mp = max(0, min(Value, Der#bs.mp_lim)),
            eff(L, Aer, Der#bs{mp = Mp}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%攻击变动n%
eff([#eff{effid = 11065, args = Args, target = Target, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Att = to_value(Aer#bs.att, Val),
            eff(L, Aer#bs{att = Att}, Der, N);
        ?TARGET_DEF ->
            Att = to_value(Der#bs.att, Val),
            eff(L, Aer, Der#bs{att = Att}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Att = to_value(Der#bs.att, Val),
            eff(L, Aer, Der#bs{att = Att}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Att = to_value(Der#bs.att, Val),
            eff(L, Aer, Der#bs{att = Att}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%指定技能id进入cd
eff([#eff{effid = 11066, args = Args, target = Target} | L], Aer, Der, N) ->
    [SkillId | _] = Args,
    Now = Aer#bs.now,
    case Target of
        ?TARGET_ATT when N == 1 ->
            case lists:keyfind(SkillId, 1, Aer#bs.skill) of
                false ->
                    eff(L, Aer, Der, N);
                {SkillId, _slv, _state} ->
                    DataSkill = skill:get_skill(SkillId),
                    CdSec = DataSkill#skill.cd,
                    SkillCd = [{SkillId, Now + CdSec} | lists:keydelete(SkillId, 1, Aer#bs.new_skill_cd)],
                    eff(L, Aer#bs{new_skill_cd = SkillCd}, Der, N)
            end;
        ?TARGET_DEF ->
            case lists:keyfind(SkillId, 1, Der#bs.skill) of
                false ->
                    eff(L, Aer, Der, N);
                {SkillId, _slv, _state} ->
                    DataSkill = skill:get_skill(SkillId),
                    CdSec = DataSkill#skill.cd,
                    SkillCd = [{SkillId, Now + CdSec} | lists:keydelete(SkillId, 1, Der#bs.new_skill_cd)],
                    eff(L, Aer, Der#bs{new_skill_cd = SkillCd}, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            case lists:keyfind(SkillId, 1, Der#bs.skill) of
                false ->
                    eff(L, Aer, Der, N);
                {SkillId, _slv, _state} ->
                    DataSkill = skill:get_skill(SkillId),
                    CdSec = DataSkill#skill.cd,
                    SkillCd = [{SkillId, Now + CdSec} | lists:keydelete(SkillId, 1, Der#bs.new_skill_cd)],
                    eff(L, Aer, Der#bs{new_skill_cd = SkillCd}, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            case lists:keyfind(SkillId, 1, Der#bs.skill) of
                false ->
                    eff(L, Aer, Der, N);
                {SkillId, _slv, _state} ->
                    DataSkill = skill:get_skill(SkillId),
                    CdSec = DataSkill#skill.cd,
                    SkillCd = [{SkillId, Now + CdSec} | lists:keydelete(SkillId, 1, Der#bs.new_skill_cd)],
                    eff(L, Aer, Der#bs{new_skill_cd = SkillCd}, N)
            end;
        _ ->
            eff(L, Aer, Der, N)
    end;

%%恢复生命百分比
eff([#eff{effid = 11073, target = Target, args = Args} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = to_value(Aer#bs.hp_lim, Arg),
            HurtList = [[?HURT_TYPE_BUFF_INC, Value] | Aer#bs.hurt_list],
            Hp = min(Aer#bs.hp_lim, Aer#bs.hp + Value),
            eff(L, Aer#bs{hp = Hp, hurt_list = HurtList, is_restore_hp = 1}, Der, N);
        ?TARGET_DEF ->
            Value = to_value(Der#bs.hp_lim, Arg),
            HurtList = [[?HURT_TYPE_BUFF_INC, Value] | Der#bs.hurt_list],
            Hp = min(Der#bs.hp_lim, Der#bs.hp + Value),
            eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList, is_restore_hp = 1}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = to_value(Der#bs.hp_lim, Arg),
            HurtList = [[?HURT_TYPE_BUFF_INC, Value] | Der#bs.hurt_list],
            Hp = min(Der#bs.hp_lim, Der#bs.hp + Value),
            eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList, is_restore_hp = 1}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = to_value(Der#bs.hp_lim, Arg),
            HurtList = [[?HURT_TYPE_BUFF_INC, Value] | Der#bs.hurt_list],
            Hp = min(Der#bs.hp_lim, Der#bs.hp + Value),
            eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList, is_restore_hp = 1}, N);
        _ ->
            eff(L, Aer, Der, N)

    end;

%%buff替换
eff([#eff{effid = 11075, target = Target, args = Args, key = EffKey} | L], Aer, Der, N) ->
    [BuffId, Stack, ReBuffId | _] = Args,
    {Skillid, _} = EffKey,
    Attacker = battle:make_attacker(Aer, 0),
    case Target of
        ?TARGET_ATT when N == 1 ->
            BuffList = Aer#bs.buff_list,
            case lists:keyfind(BuffId, #skillbuff.buffid, BuffList) of
                false ->
                    eff(L, Aer, Der, N);
                SkillBuff when SkillBuff#skillbuff.stack >= Stack ->
                    BuffList2 = lists:keydelete(BuffId, #skillbuff.buffid, BuffList),
                    Aer2 = buff:add_buff(Aer#bs{buff_list = BuffList2}, [ReBuffId], Skillid, 1, Attacker),
                    eff(L, Aer2, Der, N);
                _skillbuff ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_DEF ->
            BuffList = Der#bs.buff_list,
            case lists:keyfind(BuffId, #skillbuff.buffid, BuffList) of
                false ->
                    eff(L, Aer, Der, N);
                SkillBuff when SkillBuff#skillbuff.stack >= Stack ->
                    BuffList2 = lists:keydelete(BuffId, #skillbuff.buffid, BuffList),
                    Der2 = buff:add_buff(Der#bs{buff_list = BuffList2}, [ReBuffId], Skillid, 1, Attacker),
                    eff(L, Aer, Der2, N);
                _skillbuff ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BuffList = Der#bs.buff_list,
            case lists:keyfind(BuffId, #skillbuff.buffid, BuffList) of
                false ->
                    eff(L, Aer, Der, N);
                SkillBuff when SkillBuff#skillbuff.stack >= Stack ->
                    BuffList2 = lists:keydelete(BuffId, #skillbuff.buffid, BuffList),
                    Der2 = buff:add_buff(Der#bs{buff_list = BuffList2}, [ReBuffId], Skillid, 1, Attacker),
                    eff(L, Aer, Der2, N);
                _skillbuff ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BuffList = Der#bs.buff_list,
            case lists:keyfind(BuffId, #skillbuff.buffid, BuffList) of
                false ->
                    eff(L, Aer, Der, N);
                SkillBuff when SkillBuff#skillbuff.stack >= Stack ->
                    BuffList2 = lists:keydelete(BuffId, #skillbuff.buffid, BuffList),
                    Der2 = buff:add_buff(Der#bs{buff_list = BuffList2}, [ReBuffId], Skillid, 1, Attacker),
                    eff(L, Aer, Der2, N);
                _skillbuff ->
                    eff(L, Aer, Der, N)
            end;
        _ ->
            eff(L, Aer, Der, N)

    end;

%%直线伤害
eff([#eff{effid = 11076, args = Args} | L], Aer, Der, N) when N == 1 ->
    [HurtType, Area, V | _] = Args,
    Angle = util:get_angle(Aer#bs.x, Aer#bs.y, Der#bs.x, Der#bs.y),
    TargetList = scene_agent:get_line_obj_for_battle(Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Area, Angle, 5, [Aer#bs.key], Aer#bs.group),
    F = fun(Obj) ->
        BS = battle:init_data(Obj, Aer#bs.now2),
        Hurt = ?IF_ELSE(HurtType == 0, round(V), round(BS#bs.hp_lim * abs(V))),
        Hp = max(1, BS#bs.hp - Hurt),
        HurtList = BS#bs.hurt_list,
        HurtList2 = [[?HURT_TYPE_NORMAL, Hurt] | HurtList],
        BS#bs{hp = Hp, hurt_list = HurtList2}
        end,
    DerList = lists:map(F, TargetList),
    eff(L, Aer#bs{der_list = DerList}, Der, N);

%%清除目标身上buff类型 0,1,2,3
eff([#eff{effid = 11121, args = Args, target = Target} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    F = fun(SkillBuff, Bs) ->
        if SkillBuff#skillbuff.type == Arg andalso SkillBuff#skillbuff.subtype == 0 ->
            Buff = data_buff:get(SkillBuff#skillbuff.buffid),
            ObjRef = Bs#bs.obj_ref,
            [erlang:cancel_timer(Ref) || {{SkillId, _}, Ref} <- ObjRef#obj_ref.ref_hp_list, SkillId == SkillBuff#skillbuff.skillid],
            [catch erlang:cancel_timer(OldRef) || {{SkillId1, _}, OldRef} <- ObjRef#obj_ref.ref_mana, SkillId1 == SkillBuff#skillbuff.skillid],
            EffList = effect:prepare(Buff#buff.start_eff ++ Buff#buff.efflist, SkillBuff#skillbuff.skillid, SkillBuff#skillbuff.skilllv, [], #attacker{}),
            case lists:keyfind(11033, #eff.effid, EffList) of
                false -> ok;
                Eff ->
                    server_send:send_node_pid(Bs#bs.node, Bs#bs.pid, {cancel_speed_eff, Eff#eff.key})
            end,
            Bs;
            true -> Bs#bs{buff_list = [SkillBuff | Bs#bs.buff_list]}
        end
        end,
    case Target of
        ?TARGET_ATT when N == 1 ->
            BuffList = Aer#bs.buff_list,
            NewAer = lists:foldl(F, Aer, BuffList),
            server_send:send_node_pid(Aer#bs.node, Aer#bs.pid, {speed_reset, true}),
            eff(L, NewAer, Der, N);
        ?TARGET_DEF ->
            BuffList = Der#bs.buff_list,
            NewDer = lists:foldl(F, Der, BuffList),
            server_send:send_node_pid(Der#bs.node, Der#bs.pid, {speed_reset, true}),
            eff(L, Aer, NewDer, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BuffList = Der#bs.buff_list,
            NewDer = lists:foldl(F, Der, BuffList),
            server_send:send_node_pid(Der#bs.node, Der#bs.pid, {speed_reset, true}),
            eff(L, Aer, NewDer, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BuffList = Der#bs.buff_list,
            NewDer = lists:foldl(F, Der, BuffList),
            server_send:send_node_pid(Der#bs.node, Der#bs.pid, {speed_reset, true}),
            eff(L, Aer, NewDer, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%清除目标身上计时器
eff([#eff{effid = 11122, target = Target} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            ObjRef = Aer#bs.obj_ref,
                catch erlang:cancel_timer(ObjRef#obj_ref.ref_effect),
            [catch erlang:cancel_timer(OldRef) || {_, OldRef} <- ObjRef#obj_ref.ref_mana],
            [erlang:cancel_timer(Ref) || {_, Ref} <- ObjRef#obj_ref.ref_hp_list],
            eff(L, Aer#bs{obj_ref = #obj_ref{}}, Der, N);
        ?TARGET_DEF ->
            ObjRef = Der#bs.obj_ref,
                catch erlang:cancel_timer(ObjRef#obj_ref.ref_effect),
            [catch erlang:cancel_timer(OldRef) || {_, OldRef} <- ObjRef#obj_ref.ref_mana],
            [erlang:cancel_timer(Ref) || {_, Ref} <- ObjRef#obj_ref.ref_hp_list],
            eff(L, Aer, Der#bs{obj_ref = #obj_ref{}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            ObjRef = Der#bs.obj_ref,
                catch erlang:cancel_timer(ObjRef#obj_ref.ref_effect),
            [catch erlang:cancel_timer(OldRef) || {_, OldRef} <- ObjRef#obj_ref.ref_mana],
            [erlang:cancel_timer(Ref) || {_, Ref} <- ObjRef#obj_ref.ref_hp_list],
            eff(L, Aer, Der#bs{obj_ref = #obj_ref{}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            ObjRef = Der#bs.obj_ref,
                catch erlang:cancel_timer(ObjRef#obj_ref.ref_effect),
            [catch erlang:cancel_timer(OldRef) || {_, OldRef} <- ObjRef#obj_ref.ref_mana],
            [erlang:cancel_timer(Ref) || {_, Ref} <- ObjRef#obj_ref.ref_hp_list],
            eff(L, Aer, Der#bs{obj_ref = #obj_ref{}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%持续触发效果id n 秒
% {trigger_eff,Sign,Key,N,Effid,Target,Args}
eff([#eff{effid = 11123, args = Args, target = Target} | L], Aer, Der, N) ->
    [Sec, Effid, Target2, Args2 | _] = Args,
    case Target of
        ?TARGET_ATT when N == 1 ->
            ObjRef = Aer#bs.obj_ref,
            ScenePid = scene:get_scene_pid(Aer#bs.scene, Aer#bs.copy),
            Ref = erlang:send_after(1000, ScenePid, {trigger_eff, Aer#bs.sign, Aer#bs.key, Sec, Effid, Target2, Args2}),
            eff(L, Aer#bs{obj_ref = ObjRef#obj_ref{ref_effect = Ref}}, Der, N);
        ?TARGET_DEF ->
            ObjRef = Der#bs.obj_ref,
            ScenePid = scene:get_scene_pid(Der#bs.scene, Der#bs.copy),
            Ref = erlang:send_after(1000, ScenePid, {trigger_eff, Der#bs.sign, Der#bs.key, Sec, Effid, Target2, Args2}),
            eff(L, Aer, Der#bs{obj_ref = ObjRef#obj_ref{ref_effect = Ref}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            ObjRef = Der#bs.obj_ref,
            ScenePid = scene:get_scene_pid(Der#bs.scene, Der#bs.copy),
            Ref = erlang:send_after(1000, ScenePid, {trigger_eff, Der#bs.sign, Der#bs.key, Sec, Effid, Target2, Args2}),
            eff(L, Aer, Der#bs{obj_ref = ObjRef#obj_ref{ref_effect = Ref}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            ObjRef = Der#bs.obj_ref,
            ScenePid = scene:get_scene_pid(Der#bs.scene, Der#bs.scene),
            Ref = erlang:send_after(1000, ScenePid, {trigger_eff, Der#bs.sign, Der#bs.key, Sec, Effid, Target2, Args2}),
            eff(L, Aer, Der#bs{obj_ref = ObjRef#obj_ref{ref_effect = Ref}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%增伤百分比hurt_inc
eff([#eff{effid = 11124, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = max(0, round(Aer#bs.hurt_inc + Val)),
            eff(L, Aer#bs{hurt_inc = Value}, Der, N);
        ?TARGET_DEF ->
            Value = max(0, round(Der#bs.hurt_inc + Val)),
            eff(L, Aer, Der#bs{hurt_inc = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = max(0, round(Der#bs.hurt_inc + Val)),
            eff(L, Aer, Der#bs{hurt_inc = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = max(0, round(Der#bs.hurt_inc + Val)),
            eff(L, Aer, Der#bs{hurt_inc = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%免伤百分比hurt_dec
eff([#eff{effid = 11125, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = round(Aer#bs.hurt_dec + Val),
            eff(L, Aer#bs{hurt_dec = Value}, Der, N);
        ?TARGET_DEF ->
            Value = round(Der#bs.hurt_dec + Val),
            eff(L, Aer, Der#bs{hurt_dec = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = round(Der#bs.hurt_dec + Val),
            eff(L, Aer, Der#bs{hurt_dec = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = round(Der#bs.hurt_dec + Val),
            eff(L, Aer, Der#bs{hurt_dec = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%暴击伤害百分比crit_inc
eff([#eff{effid = 11126, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = max(0, round(Aer#bs.crit_inc + Val)),
            eff(L, Aer#bs{crit_inc = Value}, Der, N);
        ?TARGET_DEF ->
            Value = max(0, round(Der#bs.crit_inc + Val)),
            eff(L, Aer, Der#bs{crit_inc = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = max(0, round(Der#bs.crit_inc + Val)),
            eff(L, Aer, Der#bs{crit_inc = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = max(0, round(Der#bs.crit_inc + Val)),
            eff(L, Aer, Der#bs{crit_inc = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%暴击免伤百分比crit_dec
eff([#eff{effid = 11127, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Val = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            Value = max(0, round(Aer#bs.crit_dec + Val)),
            eff(L, Aer#bs{crit_dec = Value}, Der, N);
        ?TARGET_DEF ->
            Value = max(0, round(Der#bs.crit_dec + Val)),
            eff(L, Aer, Der#bs{crit_dec = Value}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            Value = max(0, round(Der#bs.crit_dec + Val)),
            eff(L, Aer, Der#bs{crit_dec = Value}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            Value = max(0, round(Der#bs.crit_dec + Val)),
            eff(L, Aer, Der#bs{crit_dec = Value}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%召唤分身
eff([#eff{effid = 11128, target = Target, args = Args} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            if Aer#bs.sign == ?SIGN_PLAYER ->
                shadow:create_shadow_for_skill(Aer#bs.key, Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Args, Aer#bs.group);
                Aer#bs.shadow_key /= 0 ->
                    shadow:create_shadow_for_skill(Aer#bs.shadow_key, Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Args, Aer#bs.group);
                true ->
                    ok
            end,
            eff(L, Aer, Der, N);
        ?TARGET_DEF ->
            if Der#bs.sign == ?SIGN_PLAYER ->
                shadow:create_shadow_for_skill(Der#bs.shadow_key, Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Args, Aer#bs.group);
                Der#bs.shadow_key /= 0 ->
                    shadow:create_shadow_for_skill(Der#bs.shadow_key, Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Args, Aer#bs.group);
                true ->
                    ok
            end,
            eff(L, Aer, Der, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            if Der#bs.sign == ?SIGN_PLAYER ->
                shadow:create_shadow_for_skill(Der#bs.shadow_key, Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Args, Aer#bs.group);
                Der#bs.shadow_key /= 0 ->
                    shadow:create_shadow_for_skill(Der#bs.shadow_key, Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Args, Aer#bs.group);
                true ->
                    ok
            end,
            eff(L, Aer, Der, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%1血保护
eff([#eff{effid = 11129, target = Target} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            BsArgs = Aer#bs.bs_args,
            eff(L, Aer#bs{bs_args = BsArgs#bs_args{fix_protect = true}}, Der, N);
        ?TARGET_DEF ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_protect = true}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_protect = true}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{fix_protect = true}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%无敌
eff([#eff{effid = 11130, target = Target} | L], Aer, Der, N) ->
    case Target of
        ?TARGET_ATT when N == 1 ->
            BsArgs = Aer#bs.bs_args,
            eff(L, Aer#bs{bs_args = BsArgs#bs_args{god_mode = true}}, Der, N);
        ?TARGET_DEF ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{god_mode = true}}, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{god_mode = true}}, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BsArgs = Der#bs.bs_args,
            eff(L, Aer, Der#bs{bs_args = BsArgs#bs_args{god_mode = true}}, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%造成n点伤害,boss翻倍
eff([#eff{effid = 11131, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg, Mult | _] = Args,
    Val = ?IF_ELSE(Der#bs.boss == 0, round(Arg * V), round(Arg * Mult * V)),
    case Target of
        ?TARGET_ATT when N == 1 ->
            TimeMark = Aer#bs.time_mark,
            if
                Aer#bs.now > TimeMark#time_mark.godt ->
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Val] | Aer#bs.hurt_list],
                    Hp = ?IF_ELSE(Aer#bs.hp - Val =< 0, 1, Aer#bs.hp - Val),
                    eff(L, Aer#bs{hp = Hp, hurt_list = HurtList}, Der, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Val] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Val =< 0, 1, Der#bs.hp - Val),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Val] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Val =< 0, 1, Der#bs.hp - Val),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            TimeMark = Der#bs.time_mark,
            if
                Der#bs.now > TimeMark#time_mark.godt ->
                    HurtList = [[?HURT_TYPE_BUFF_DEC, Val] | Der#bs.hurt_list],
                    Hp = ?IF_ELSE(Der#bs.hp - Val =< 0, 1, Der#bs.hp - Val),
                    eff(L, Aer, Der#bs{hp = Hp, hurt_list = HurtList}, N);
                true ->
                    eff(L, Aer, Der, N)
            end;
        _ ->
            eff(L, Aer, Der, N)
    end;


%%在原地召唤一个怪物 Type 0 自己身旁，1目标身旁
%% group : 0 无分组,只攻击玩家 ; 1 跟召唤者一组,优先继承召唤者分组,否则以召唤者key作为分组key; -1 怪物攻击怪物
eff([#eff{effid = 11132, args = Args} | L], Aer, Der, N) when N == 1 ->
    [Type, MonId, Num, X, Y, Rn, Group, HpPer, AttPer | _] = Args,
    if
        Type == 0 ->
            X1 = Aer#bs.x + X,
            Y1 = Aer#bs.y + Y,
            F = fun(_) ->
                X2 = util:list_rand(lists:seq((X1 - Rn), (X1 + Rn))),
                Y2 = util:list_rand(lists:seq((Y1 - Rn), (Y1 + Rn))),
                Group2 = ?IF_ELSE(Group == 1, ?IF_ELSE(Aer#bs.group > 0, Aer#bs.group, Aer#bs.key), Group),
                MonArgs = [{group, Group2}, {hp, round(Aer#bs.hp_lim * HpPer)}, {hp_lim, round(Aer#bs.hp_lim * HpPer)}, {att, round(Aer#bs.att * AttPer)}],
                mon_agent:create_mon_cast([MonId, Aer#bs.scene, X2, Y2, Aer#bs.copy, 1, MonArgs])
                end,
            lists:foreach(F, lists:seq(1, Num));
        true ->
            X1 = Der#bs.x + X,
            Y1 = Der#bs.y + Y,
            F = fun(_) ->
                X2 = util:list_rand(lists:seq((X1 - Rn), (X1 + Rn))),
                Y2 = util:list_rand(lists:seq((Y1 - Rn), (Y1 + Rn))),
                Group2 = ?IF_ELSE(Group == 1, ?IF_ELSE(Aer#bs.group > 0, Aer#bs.group, Aer#bs.key), Group),
                MonArgs = [{group, Group2}, {hp, round(Aer#bs.hp_lim * HpPer)}, {hp_lim, round(Aer#bs.hp_lim * HpPer)}, {att, round(Aer#bs.att * AttPer)}],
                mon_agent:create_mon_cast([MonId, Der#bs.scene, X2, Y2, Der#bs.copy, 1, MonArgs])
                end,
            lists:foreach(F, lists:seq(1, Num))
    end,
    eff(L, Aer, Der, N);

%%免疫控制
eff([#eff{effid = 11133, target = Target, args = Args, v = V} | L], Aer, Der, N) ->
    [Arg | _] = Args,
    Sec = Arg * V,
    case Target of
        ?TARGET_ATT when N == 1 ->
            BsArgs = Aer#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unctrl > Aer#bs.now, BsArgs#bs_args.unctrl + Sec, Aer#bs.now + Sec),
            NewBsArgs = BsArgs#bs_args{unctrl = ExpireTime},
            eff(L, Aer#bs{bs_args = NewBsArgs}, Der, N);
        ?TARGET_DEF ->
            BsArgs = Der#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unctrl > Der#bs.now, BsArgs#bs_args.unctrl + Sec, Der#bs.now + Sec),
            NewBsArgs = BsArgs#bs_args{unctrl = ExpireTime},
            eff(L, Der#bs{bs_args = NewBsArgs}, Der, N);
        ?TARGET_ACTOR_DEF when Der#bs.actor == ?ACTOR_DEF ->
            BsArgs = Der#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unctrl > Der#bs.now, BsArgs#bs_args.unctrl + Sec, Der#bs.now + Sec),
            NewBsArgs = BsArgs#bs_args{unctrl = ExpireTime},
            eff(L, Der#bs{bs_args = NewBsArgs}, Der, N);
        ?TARGET_MON when Der#bs.sign == ?SIGN_MON andalso Der#bs.boss == 0 ->
            BsArgs = Der#bs.bs_args,
            ExpireTime = ?IF_ELSE(BsArgs#bs_args.unctrl > Der#bs.now, BsArgs#bs_args.unctrl + Sec, Der#bs.now + Sec),
            NewBsArgs = BsArgs#bs_args{unctrl = ExpireTime},
            eff(L, Der#bs{bs_args = NewBsArgs}, Der, N);
        _ ->
            eff(L, Aer, Der, N)
    end;

%%嘲讽
eff([#eff{effid = 11134, args = Args} | L], Aer, Der, N) ->
    [Area, Num, BuffId | _] = Args,
    TargetList = scene_agent:get_scene_player_for_battle(Aer#bs.scene, Aer#bs.copy, Aer#bs.x, Aer#bs.y, Area, [], Aer#bs.group),
    {ok, Bin} = pt_200:write(20020, {Aer#bs.key}),
    F = fun(Obj) ->
        server_send:send_node_pid(Obj#scene_player.node, Obj#scene_player.pid, {buff, BuffId}),
        server_send:send_to_sid(Obj#scene_player.node, Obj#scene_player.sid, Bin),
        ok
        end,
    lists:foreach(F, util:get_random_list(TargetList, Num)),
    eff(L, Aer, Der, N);

eff([_ | L], Aer, Der, N) ->
    eff(L, Aer, Der, N).


%% ----------------------------------------------------------------------------------
%% 伤害后效果触发，如果被击方死亡，触发死亡效果
leff([], Aer, Der, _hurt) ->
    if
        Der#bs.hp =< 0 ->
            eff(Der#bs.dieeff_list, Aer, Der, 1);
        true ->
            {Aer, Der}
    end;


%%每秒受到本次技能伤害的百分之N1，伤害持续N2 秒
leff([#eff{effid = 11032, args = Args, v = V, key = EffKey} | L], Aer, Der, Hurt) ->
    TimeMark = Der#bs.time_mark,
    if
        Der#bs.now > TimeMark#time_mark.godt ->
            [N1, N2 | _] = Args,
            ScenePid = scene:get_scene_pid(Aer#bs.scene, Aer#bs.copy),
            Val = N1 * V,
            Value = round(Hurt * Val),
            ObjRef = Der#bs.obj_ref,
            Attacker = battle:make_attacker(Aer, Value),
            Ref = erlang:send_after(1000, ScenePid, {hp_change, EffKey, Der#bs.key, Der#bs.sign, -Value, N2, Attacker}),
            Ref_hp_list = [{EffKey, Ref} | lists:keydelete(EffKey, 1, ObjRef#obj_ref.ref_hp_list)],
            leff(L, Aer, Der#bs{obj_ref = ObjRef#obj_ref{ref_hp_list = Ref_hp_list}}, Hurt);
        true ->
            leff(L, Aer, Der, Hurt)
    end;

%%杀死目标后减少冷却n秒
leff([#eff{effid = 11042, args = Args} | L], Aer, Der, Hurt) ->
    [Mid, Sec | _] = Args,
    if
        Der#bs.mid == Mid andalso Der#bs.hp =< 0 ->
            SkillCd = Aer#bs.skill_cd,
            F = fun({Sid, ExpireTime}) ->
                {Sid, max(0, ExpireTime - Sec)}
                end,
            SkillCd2 = lists:map(F, SkillCd),
            leff(L, Aer#bs{new_skill_cd = SkillCd2 ++ Aer#bs.new_skill_cd}, Der, Hurt);
        true ->
            leff(L, Aer, Der, Hurt)
    end;


%%将造成伤害的n%转化成自身生命,吸血
leff([#eff{effid = 11044, args = Args, v = V, key = EffKey} | L], Aer, Der, Hurt) ->
    if Der#bs.actor == ?ACTOR_DEF ->
        [Arg | _] = Args,
        ScenePid = scene:get_scene_pid(Aer#bs.scene, Aer#bs.copy),
        Val = Arg * V,
        Value = round(Hurt * Val),
        ObjRef = Aer#bs.obj_ref,
        Ref = erlang:send_after(500, ScenePid, {hp_change, EffKey, Aer#bs.key, Aer#bs.sign, Value, 1, #attacker{}}),
        Ref_hp_list = [{EffKey, Ref} | lists:keydelete(EffKey, 1, ObjRef#obj_ref.ref_hp_list)],
        leff(L, Aer#bs{obj_ref = ObjRef#obj_ref{ref_hp_list = Ref_hp_list}}, Der, Hurt);
        true ->
            leff(L, Aer, Der, Hurt)
    end;

%%将造成伤害的n%转换成法盾
leff([#eff{effid = 11064, args = Args, v = V} | L], Aer, Der, Hurt) ->
    [Arg | _] = Args,
    Val = Arg * V,
    Value = round(Hurt * Val),
    Mana = Aer#bs.mana,
    leff(L, Aer#bs{mana = Mana + Value}, Der, Hurt);


%% @@@@@特殊@@@@@ 战斗触发的硬直效果
leff([#eff{effid = 99999, args = Args} | L], Aer, Der, Hurt) ->
    [Sec | _] = Args,
    TimeMark = Der#bs.time_mark,
    Umt = TimeMark#time_mark.umt,
    Uat = TimeMark#time_mark.uat,
    Now = Der#bs.now,
    Der2 = Der#bs{time_mark = TimeMark#time_mark{umt = max(Umt, Now + Sec), uat = max(Uat, Now + Sec)}},
    leff(L, Aer, Der2, Hurt);







leff([_ | L], Aer, Der, Hurt) ->
    leff(L, Aer, Der, Hurt).


leff_der([], Aer, Der, _hurt) ->
    if
        Aer#bs.hp =< 0 ->
            eff(Aer#bs.dieeff_list, Aer, Der, 1);
        true ->
            {Aer, Der}
    end;

%%反弹n%伤害
leff_der([#eff{effid = 11045, args = Args, v = V} | L], Aer, Der, Hurt) ->
    [Arg | _] = Args,
    Val = Arg * V,
    TimeMark = Aer#bs.time_mark,
    if
        Aer#bs.now > TimeMark#time_mark.godt ->
            Hurt = round(Hurt * Val),
            Hp = Aer#bs.hp - Hurt,
            if Hp =< 0 ->
                Attacker = battle:make_attacker(Der, Hurt),
                leff_der(L, Aer#bs{hp = 0, hurt_list = [[?HURT_TYPE_BUFF_DEC, Hurt] | Aer#bs.hurt_list], attacker = Attacker}, Der, Hurt);
                true ->
                    leff_der(L, Aer#bs{hp = Hp, hurt_list = [[?HURT_TYPE_BUFF_DEC, Hurt] | Aer#bs.hurt_list]}, Der, Hurt)
            end;
        true ->
            leff_der(L, Aer, Der, Hurt)
    end;


%%反弹n点伤害
leff_der([#eff{effid = 11046, args = Args, v = V} | L], Aer, Der, Hurt) ->
    [Arg | _] = Args,
    Val = Arg * V,
    TimeMark = Aer#bs.time_mark,
    if
        Aer#bs.now > TimeMark#time_mark.godt ->
            Hp = Aer#bs.hp - Val,
            if Hp =< 0 ->
                Attacker = battle:make_attacker(Der, Hurt),
                leff_der(L, Aer#bs{hp = 0, hurt_list = [[?HURT_TYPE_BUFF_DEC, Val] | Aer#bs.hurt_list], attacker = Attacker}, Der, Hurt);
                true ->
                    leff_der(L, Aer#bs{hp = Hp, hurt_list = [[?HURT_TYPE_BUFF_DEC, Val] | Aer#bs.hurt_list]}, Der, Hurt)
            end;
        true ->
            leff_der(L, Aer, Der, Hurt)
    end;


leff_der([_ | L], Aer, Der, Hurt) ->
    leff_der(L, Aer, Der, Hurt).





to_value(Base, Val) ->
    if
        Val > -1 ->
            round(Base * (1 + Val));
        true ->
            0
    end.

%%buff结束触发
end_eff([], _BS, _Param) ->
    ok;
end_eff([#eff{effid = 0} | L], BS, Param) ->
    end_eff(L, BS, Param);
end_eff([_ | L], BS, Param) ->
    end_eff(L, BS, Param).

